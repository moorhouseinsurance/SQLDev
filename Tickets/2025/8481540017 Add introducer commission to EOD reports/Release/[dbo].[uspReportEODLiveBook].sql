USE [MI]
GO
/****** Object:  StoredProcedure [dbo].[uspReportEODLiveBook]    Script Date: 17/02/2025 14:18:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 27 Dec 2024
-- Description:	Live Book from overnight saved data (Qlikview replacement)
-- =============================================

-- Date			Who						Change
-- 12/02/2025	Jeremai Smith			Changed OriginalSaleAgent column to display full name instead of login, and added ActionDate and Postcode (Monday.com ticket 8370817954)
-- 17/02/2025	Jeremai Smith			Added introducer commission (Monday.com ticket 8481540017)


ALTER PROCEDURE [dbo].[uspReportEODLiveBook]
AS

/*

EXEC [dbo].[uspReportEODLiveBook]

*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- ==================================
-- Create table variable to hold data
-- ==================================

DECLARE @Data TABLE (
	 [POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[HistoryOrGroupingID] int
	,[AGENT_ID] char(32)
	,[AgentName] varchar(255)
	,[SubAgentName] varchar(255)
	,[PolicyNumber] varchar(30)
	,[Insurer] varchar(255)
	,[ProductName] varchar(255)
	,[PrimaryTrade] varchar(255)
	,[ClientReference] varchar(25)
	,[Postcode] varchar(10)
	,[TranType] varchar(18)
	,[OriginalSaleAgent] varchar(100)
	,[ActionDate] datetime
	,[RenewalDate] datetime
	,[PaymentOption] varchar(25)
	,[PolicyCount] int
	,[GWPExcIPT] money
	,[IPT] money
	,[BrokerCommission] money
	,[Fee] money
	,[Income] money
	,[Deposit] money
	,[IntroducerCommission] money
)


INSERT INTO @Data (
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[AgentName]
	,[SubAgentName]
	,[PolicyNumber]
	,[Insurer]
	,[ProductName]
	,[PrimaryTrade]
	,[ClientReference]
	,[Postcode]
	,[TranType]
	,[OriginalSaleAgent]
	,[ActionDate]
	,[RenewalDate]
	,[PaymentOption]
	,[PolicyCount]
)
SELECT 
	 [QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[AgentName]																							AS [AgentName]
	,[QVCD].[SubAgentName]																						AS [SubAgentName]
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,[QVCD].[InsurerName]																						AS [Insurer]
	,[QVCD].[ProductName]																						AS [ProductName]
	,[QVCD].[PrimaryTrade]																						AS [PrimaryTrade]
	,RTRIM([QVCD].[ClientReference])																			AS [ClientReference]
	,[C].[CustomerPostcode]																						AS [Postcode]
	,[QVCD].[Action]																							AS [TranType]
	,[U_OS].[Forename] + ' ' + [U_OS].[Surname]																	AS [OriginalSaleAgent]
	,[QVCD].[ACTIONDATE]																						AS [ActionDate] -- This will be the action date of the latest NB or renewal action as WHERE clause restricts to [LivePolicyLatestNBRENFlag] = 'Y'
	,DATEADD(d, 1, [QVCD].[POLICYENDDATE])																		AS [RenewalDate]
	,[QVCD].[PaymentOption]																						AS [PaymentOption]
	,1																											AS [PolicyCount]
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		--LEFT JOIN [dbo].[User] AS [U_QS] ON [QVCD].[QuoteSale] = [U_QS].[TGSLLogin] -- Synonym pointing to CRM database
		LEFT JOIN [dbo].[User] AS [U_OS] ON [QVCD].[OriginalSaleAgent] = [U_OS].[TGSLLogin] -- Synonym pointing to CRM database
		LEFT JOIN [dbo].[Customer] AS [C] ON [QVCD].[INSURED_PARTY_ID] = [C].[INSURED_PARTY_ID] -- Customer table only has one row per Insured
		--LEFT JOIN [dbo].[QVAgentTeamTargetNBREN] AS [VTT] ON [U_QS].[ID] = [VTT].[UserID] -- Synonym pointing to CRM database
		--												  AND [QVCD].[Booked_Business_NB/REN] = [VTT].[NB/REN]
		--												  AND EOMONTH([QVCD].[PolicyStartDate]) = EOMONTH([VTT].[HierarchyMonthID])
WHERE
	[QVCD].[Action] IN ('New Business','Renewal')
	AND [QVCD].[POLICYSTARTDATE] < DATEADD(DAY, 1, CONVERT(date, GETDATE()))
	AND [QVCD].[POLICYSTARTDATE] >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) - 5, 0) -- First day of the year five years previous, to match logic in Qlikview CustomerDetails.sql load script
	AND [QVCD].[LivePolicyFlag] = 'Y'
	AND [QVCD].[LivePolicyLatestNBRENFlag] = 'Y'
ORDER BY
	[QVCD].[POLICYNUMBER]
;


-- Update financials:
-- (For some reason this works much faster as an update compared to joining to PolicyFinancials in the insert statement above)

UPDATE [Data]
SET	 [GWPExcIPT] = [FIN].[GWP]
	,[IPT] = [FIN].[IPT]
	,[BrokerCommission] = [FIN].[BrokerTotalCommissionAndDiscount]
	,[Fee] = [FIN].[Fee]
	,[Income] = [FIN].[Income]
	,[Deposit] = ISNULL([FIN].[Deposit], 0) *-1
	,[IntroducerCommission] = [FIN].[IntroducerTotalCommission]
FROM @Data AS [Data]
INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[POLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[HistoryOrGroupingID] = [FIN].[HistoryOrGroupingID]
;


-- Return data to the report:

SELECT
DISTINCT -- Distinct to mirror Qlikview's automatic grouping
--	 [POLICY_DETAILS_ID]
--	,[HISTORY_ID]
--	,[ActionDate]
	 [AgentName]
	,[SubAgentName]
	,[PolicyNumber]
	,[Insurer]
	,[ProductName]
	,[PrimaryTrade]
	,[ClientReference]
	,[Postcode]
	,[TranType]
	,[OriginalSaleAgent]
	,[ActionDate]
	,[RenewalDate]
	,[PaymentOption]
	,[PolicyCount]
	,[GWPExcIPT]
	,[IPT]
	,[BrokerCommission]
	,[Fee]
	,[Income]
	,[Deposit]
	,[IntroducerCommission]
FROM
	@Data
ORDER BY [PolicyNumber]
;

