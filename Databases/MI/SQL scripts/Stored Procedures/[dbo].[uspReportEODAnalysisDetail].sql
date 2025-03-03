USE [MI]
GO
/****** Object:  StoredProcedure [dbo].[uspReportEODAnalysisDetail]    Script Date: 26/02/2025 11:12:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 04 Dec 2024
-- Description:	Analysis/Details dataset from overnight saved data (Qlikview replacement)
-- =============================================

-- Date			Who						Change
-- 26/02/2025	Jeremai Smith			Added Client Source column (Monday.com ticket 7960435774)

ALTER PROCEDURE [dbo].[uspReportEODAnalysisDetail]
	 @DateType varchar(25)
	,@StartDate datetime
	,@EndDate datetime
	,@AgentID varchar(MAX)
AS

/*

DECLARE @DateType varchar(25) = 'Effective Date' -- 'Action Date'
DECLARE @StartDate datetime = '01 Nov 2024'
DECLARE @EndDate datetime = '30 Nov 2024'
DECLARE @AgentID varchar(MAX) = 'ALL'

EXEC [dbo].[uspReportEODAnalysisDetail] @DateType, @StartDate, @EndDate, @AgentID

*/


IF CONVERT(VARCHAR(12), @EndDate, 114) = '00:00:00:000'
	SET @EndDate = DATEADD(DAY, 1, @EndDate);

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
	,[OriginalActionDate] datetime
	,[TransactionDate] datetime
	,[PolicyNumber] varchar(30)
	,[ClientRef] varchar(25)
	,[PolicyStatus] varchar(13)
	,[POLICY_STATUS] varchar(50)
	,[TranType] varchar(18)
	,[PolicyMTACanxEffectiveDate] datetime
	,[TransactionEffectiveDate] datetime
	,[MTAStartDate] datetime
	,[Income] money
	,[Fee] money
	,[GWPExcIPT] money
	,[CPDCommission] money
	,[TransactionsCommission] money
	,[CanxPolicy] int
	,[EmployeeQuote] varchar(160)
	,[FirstViewedAgent] varchar(160)
	,[PolicyEffectiveDate] datetime
	,[QuoteSale] varchar(50)
	,[SaleAgent] varchar(160)
	,[Sale] varchar(50)
	,[RenPOLICY_DETAILS_ID] char(32)
	,[RenHISTORY_ID] int
	,[RenTransactionType] varchar(255)
	,[RenIncome] money
	,[CancellationEffectiveDate] datetime
	,[BB_CancellationDate] datetime
	,[BB_PolicyEndDate] datetime
    ,[BB_Premium] money
	,[BB_Status] varchar(10)
	,[Product] varchar(255)
	,[Insurer] varchar(255)
	,[PaymentOption] varchar(25)
	,[POSTCODE] varchar(10)
	,[Client_Source] varchar(50)
)


INSERT INTO @Data (
	 [POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[AGENT_ID]
	,[AgentName]
	,[OriginalActionDate]
	,[TransactionDate]
	,[PolicyNumber]
	,[ClientRef]
	,[PolicyStatus]
	,[POLICY_STATUS]
	,[TranType]
	,[PolicyMTACanxEffectiveDate]
	,[TransactionEffectiveDate]
	,[MTAStartDate]
	,[CPDCommission]
	,[CanxPolicy]
	,[EmployeeQuote]
	,[FirstViewedAgent]
	,[PolicyEffectiveDate]
	,[QuoteSale]
	,[SaleAgent]
	,[Sale]
	,[RenPOLICY_DETAILS_ID]
	,[RenHISTORY_ID]
	,[CancellationEffectiveDate]
	,[BB_CancellationDate]
	,[BB_PolicyEndDate]
    ,[BB_Premium]
	,[BB_Status]
	,[Product]
	,[Insurer]
	,[PaymentOption]
	,[POSTCODE]
	,[Client_Source]
)
SELECT 
	 [QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[AGENT_ID]																							AS [AGENT_ID]
	,[QVCD].[AgentName]																							AS [AgentName]
	,[QVCD].[Quotedate]																							AS [OriginalActionDate]
	,CONVERT(date, [QVCD].[ACTIONDATE])																			AS [TransactionDate] -- Needs to be converted to date (removes time element) to get correct number of rows when selecting DISTINCT below, to match Qlikview grouping
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,RTRIM([QVCD].[ClientReference])																			AS [ClientRef]
	,ISNULL([QVCD].[PolicyStatus], 'OtherStatus')																AS [PolicyStatus]
	,[QVCD].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS]
	,[QVCD].[Action]																							AS [TranType]
	,CASE
		WHEN [QVCD].[ACTIONTYPE] NOT IN (3, 4) THEN [QVCD].[POLICYSTARTDATE]
		WHEN [QVCD].[ACTIONTYPE] = 3 THEN [QVCD].[MTASTARTDATE] -- MTA
		WHEN [QVCD].[ACTIONTYPE] = 4 THEN [QVCD].[CANCELLATIONDATE] -- Cancellation
	 END																										AS [PolicyMTACanxEffectiveDate]
	,CASE
		WHEN [QVCD].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' AND [QVCD].[PolicyStatus] = 'Cancelled' AND [QVCD].[POLICY_STATUS_DEBUG] IN ('Cancelled', 'History File')
			THEN [QVCD].[CANCELLATIONDATE]
		WHEN [QVCD].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [QVCD].[PolicyStatus] IN ('OtherStatus', 'Policy', 'Renewed', 'Lapsed', 'Invited') AND [QVCD].[Action] IN ('RENMTA', 'NBMTA')
			THEN [QVCD].[MTASTARTDATE]
		ELSE [QVCD].[POLICYSTARTDATE] 
	 END																										AS [TransactionEffectiveDate]

	,[QVCD].[MTASTARTDATE]																						AS [MTAStartDate]
	,[QVCD].[COMMISSION]																						AS [CPDCommission]
	,[QVCD].[CanxPolicy]																						AS [CanxPolicy]
	,CASE
		WHEN [QVCD].[OriginalQuote] LIKE 'xb%' THEN 'Web Application'
		ELSE [U_OQ].[Forename] + ' ' + [U_OQ].[Surname]
	 END																										AS [EmployeeQuote]
	,CASE
		WHEN [QVCD].[QuoteSale] LIKE 'xb%' THEN 'Web Application'
		ELSE [U_FV].[Forename] + ' ' + [U_FV].[Surname]
	 END																										AS [FirstViewedAgent]
	,[QVCD].[POLICYSTARTDATE]																					AS [PolicyEffectiveDate]
	,[QVCD].[QuoteSale]																							AS [QuoteSale]
	,CASE
		WHEN [QVCD].[QuoteSale] LIKE 'xb%' THEN 'Web Application'
		ELSE [U_QS].[Forename] + ' ' + [U_QS].[Surname]
	 END																										AS [SaleAgent]
	,[QVCD].[Sale]																								AS [Sale]
	,[QVCD].[RenPOLICY_DETAILS_ID]																				AS [RenPOLICY_DETAILS_ID]
	,[QVCD].[RenHISTORY_ID]																						AS [RenHISTORY_ID]
	,[QVCD].[CANCELLATIONDATE]																					AS [CancellationEffectiveDate]
	,CASE WHEN [QVCD].[CANCELLATIONDATE] = '30 Dec 1899' THEN '' ELSE [QVCD].[CANCELLATIONDATE] END				AS [BB_CancellationDate]
	,CASE WHEN [QVCD].[CANCELLATIONDATE] = '30 Dec 1899' THEN [QVCD].[POLICYENDDATE] ELSE [QVCD].[CANCELLATIONDATE] END	AS [BB_PolicyEndDate]
    ,CASE WHEN [QVCD].[CANCELLATIONDATE] = '30 Dec 1899' THEN [QVCD].[PREMIUMB4IPT] ELSE NULL END				AS [BB_Premium]
	,CASE
		WHEN [QVCD].[PolicyStatus] IN ('LapsedRenewed', 'Policy', 'Renewed', 'NBMTA') THEN 'Live'
		WHEN [QVCD].[PolicyStatus] = 'Cancelled' THEN 'Cancelled'
	 END																										AS [BB_Status]
	,[QVCD].[ProductName]																						AS [Product]
	,[QVCD].[InsurerName]																						AS [Insurer]
	,[QVCD].[PaymentOption]																						AS [PaymentOption]
	,[C].[CustomerPostcode]																						AS [POSTCODE]
	,[QVCD].[Client_Source]																						AS [Client_Source]
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [QVCD].[AGENT_ID] = [RMAMH].[AGENT_ID] -- Synonym pointing to Transactor_Live database
		LEFT JOIN [dbo].[User] AS [U_OQ] ON [QVCD].[OriginalQuote] = [U_OQ].[TGSLLogin] -- Synonym pointing to CRM database
		LEFT JOIN [dbo].[User] AS [U_QS] ON [QVCD].[QuoteSale] = [U_QS].[TGSLLogin] -- Synonym pointing to CRM database
		LEFT JOIN [dbo].[User] AS [U_FV] ON [QVCD].[FirstViewed] = [U_FV].[TGSLLogin] -- Synonym pointing to CRM database
		LEFT JOIN [dbo].[Customer] AS [C] ON [QVCD].[INSURED_PARTY_ID] = [C].[INSURED_PARTY_ID] -- Customer table only has one row per Insured
		OUTER APPLY (SELECT MIN([ORIGINALINCEPTIONDATE]) AS [ORIGINALINCEPTIONDATE] FROM [dbo].[QVCustomerDetails]
					 WHERE [INSURED_PARTY_ID] = [QVCD].[INSURED_PARTY_ID]
					 AND [Action] IN ('Renewal','New Business')) AS [MinIncept]
WHERE
	((@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] NOT IN (3, 4) AND [QVCD].[POLICYSTARTDATE] >= @StartDate AND [QVCD].[POLICYSTARTDATE] < @EndDate)
	 --OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 3 AND [QVCD].[MTASTARTDATE] >= @StartDate AND [QVCD].[MTASTARTDATE] < @EndDate) -- MTA
	 OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 3 AND ISNULL([QVCD].[PolicyStatus], 'OtherStatus') IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'Invited') AND [QVCD].[MTASTARTDATE] >= @StartDate AND [QVCD].[MTASTARTDATE] < @EndDate) -- MTA
	 OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 3 AND ISNULL([QVCD].[PolicyStatus], 'OtherStatus') NOT IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'Invited') AND [QVCD].[POLICYSTARTDATE] >= @StartDate AND [QVCD].[POLICYSTARTDATE] < @EndDate) -- Cancelled MTA
	 OR (@DateType = 'Effective Date' AND [QVCD].[ACTIONTYPE] = 4 AND [QVCD].[CANCELLATIONDATE] >= @StartDate AND [QVCD].[CANCELLATIONDATE] < @EndDate) -- Cancellation
	 OR (@DateType = 'Action Date' AND [QVCD].[ACTIONDATE] >= @StartDate AND [QVCD].[ACTIONDATE]  < @EndDate)
	)
	AND ('ALL' IN (@AgentID) OR [QVCD].[AGENT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@AgentID, ',')))
ORDER BY
	[QVCD].[POLICYNUMBER]
;


-- Update financials:
-- (For some reason this works much faster as an update compared to joining to PolicyFinancials in the insert statement above)

UPDATE [Data]
SET	 [GWPExcIPT] = [FIN].[GWP]
	,[TransactionsCommission] = [FIN].[BrokerCommission]
	,[Fee] = [FIN].[Fee]
	,[Income] = [FIN].[Income]
FROM @Data AS [Data]
INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[POLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[HistoryOrGroupingID] = [FIN].[HistoryOrGroupingID]


-- Update renewal financials:

UPDATE [Data]
SET	 [RenTransactionType] = [FIN].[EarliestTranCodePerHistGroup]
	,[RenIncome] = [FIN].[Income]
FROM @Data AS [Data]
INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[RenPOLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[RenHISTORY_ID] = [FIN].[POLICY_DETAILS_HISTORY_ID]


-- Return data to the report:

SELECT DISTINCT -- Distinct to mirror Qlikview's automatic grouping
	 [AgentName]
	,[OriginalActionDate]
	,[TransactionDate]
	,[PolicyNumber]
	,[ClientRef]
	,[PolicyStatus]
	,[POLICY_STATUS]
	,[TranType]
	,[PolicyMTACanxEffectiveDate]
	,[TransactionEffectiveDate]
	,[MTAStartDate]
	,[Income]
	,[Fee]
	,[GWPExcIPT]
	,[CPDCommission]
	,[TransactionsCommission]
	,[CanxPolicy]
	,[EmployeeQuote]
	,[FirstViewedAgent]
	,[PolicyEffectiveDate]
	,[QuoteSale]
	,[SaleAgent]
	,[Sale]
	,[RenTransactionType]
	,[RenIncome]
	,[CancellationEffectiveDate]
	,[BB_CancellationDate]
	,[BB_PolicyEndDate]
    ,[BB_Premium]
	,[BB_Status]
	,[Product]
	,[Insurer]
	,[PaymentOption]
	,[POSTCODE]
	,[Client_Source]
FROM
	@Data
ORDER BY [PolicyNumber]
;

