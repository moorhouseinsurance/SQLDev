USE [MI]
GO
/****** Object:  StoredProcedure [dbo].[uspReportBookedBusiness]    Script Date: 26/02/2025 13:16:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 14 Nov 2024
-- Description:	Booked Business report from overnight saved data (Qlikview replacement)
-- =============================================

-- Date			Who						Change
-- 14/02/2025	Jeremai Smith			Added BusinessSource to NB and EB by Policy data tables (Monday.com ticket 8370817954)
-- 17/02/2025	Jeremai Smith			Added introducer commission (Monday.com ticket 8481540017)
-- 26/02/2025	Jeremai Smith			Added SubagentName column (Monday.com ticket 7960435774)


ALTER PROCEDURE [dbo].[uspReportBookedBusiness]
	 @EffectiveStartDate datetime
	,@EffectiveEndDate datetime
	,@ActionStartDate datetime
	,@ActionEndDate datetime
	,@AgentID varchar(MAX)
	,@InsurerID varchar(MAX)
	,@LoginName varchar(50)
AS

/*

DECLARE @EffectiveStartDate datetime = '01 Feb 2025'
DECLARE @EffectiveEndDate datetime = '28 Feb 2025'
DECLARE @ActionStartDate datetime
DECLARE @ActionEndDate datetime
DECLARE @AgentID varchar(MAX) = 'ALL'
DECLARE @InsurerID varchar(MAX) = 'ALL'
DECLARE @LoginName varchar(50) = 'ALL' -- adavies -- select * from CRM.dbo.[User] where isnull(obsolete, 0) <> 1 order by surname, forename

EXEC [dbo].[uspReportBookedBusiness] @EffectiveStartDate, @EffectiveEndDate, @ActionStartDate, @ActionEndDate, @AgentID, @InsurerID, @LoginName

*/


IF CONVERT(VARCHAR(12), @EffectiveEndDate, 114) = '00:00:00:000'
	SET @EffectiveEndDate = DATEADD(DAY, 1, @EffectiveEndDate);

IF CONVERT(VARCHAR(12), @ActionEndDate, 114) = '00:00:00:000'
	SET @ActionEndDate = DATEADD(DAY, 1, @ActionEndDate);


-- ==================================
-- Create table variable to hold data
-- ==================================

DECLARE @Data TABLE (
	 [Dataset] varchar(50)
	,[POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[HistoryOrGroupingID] int
	,[PolicyNumber] varchar(30)
	,[AGENT_ID] char(32)
	,[AgentName] varchar(255)
	,[SubagentName] varchar(255)
	,[SaleAgentLogin] varchar(170)
	,[QuoteSaleAgentLogin] varchar(50)
	,[QuoteSaleAgent] varchar(170)
	,[OriginalActionDate] datetime
	,[OriginalInceptionDate] datetime
	,[ActionDate] datetime
	,[ClientRef] varchar(25)
	,[ProductName] varchar(150)
	,[PolicyEffectiveDate] datetime
	,[ClientName] varchar(255)
	,[ACTIONTYPE] int
	,[Action/TranType] varchar(18)
	,[NB/REN] varchar(3)
	,[Booked_Business_NB/REN/CANX/MTA] varchar(4)
	,[XBroker_NB/REN] varchar(3)
	,[PolicyStatus] varchar(13)
	,[POLICY_STATUS_DEBUG] varchar(25)
	,[CoreAddon] varchar(6)
	,[PrimaryTrade] varchar(500)
	,[Insurer] varchar(255)
	,[PaymentOption] varchar(25)
	,[ClientSource] varchar(50)
	,[BusinessSource] varchar(255)
	,[Policies] int
	,[AccountsTransactionType] varchar(25)
	,[LivePolicyFlag] char(1)
	,[Segmentation] varchar(25)
	,[GWPExcIPT] money
	,[GWPIncIPT] money
	,[MTAIncome] money
	,[BrokerCommission] money
	,[Discount] money
	,[Fee] money
	,[Brand Income] money
	,[Brand Income NB] money
	,[Brand Income EB] money
	,[CanxIncome] money
	,[Income] money
	,[AgentCommission] money
	,[SubAgentCommission] money
	,[IntroducerCommission] money
	,[XBrokerIncome] money
	,[BooksIncome] money
	,[TargetMonthDate] datetime
	,[TargetAmount] money
	,[PCofTarget] decimal (10,2)
	,[PCRanking] int
	,[DifferenceToTarget] money
	,[DifferenceRanking] int
	,[WebIncome] money
	,[DataIncome] money
	,[OtherIncome] money
)


-- ==========
-- Sales data
-- ==========

INSERT INTO @Data (
	 [Dataset]
	,[POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[PolicyNumber]
	,[AGENT_ID]
	,[AgentName]
	,[SubagentName]
	,[QuoteSaleAgentLogin]
	,[QuoteSaleAgent]
	,[OriginalActionDate]
	,[OriginalInceptionDate]
	,[ActionDate]
	,[ClientRef]
	,[ProductName]
	,[PolicyEffectiveDate]
	,[ClientName]
	,[ACTIONTYPE]
	,[Action/TranType]
	,[NB/REN]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[PolicyStatus]
	,[POLICY_STATUS_DEBUG]
	,[CoreAddon]
	,[PrimaryTrade]
	,[Insurer]
	,[PaymentOption]
	,[ClientSource]
	,[BusinessSource]	
	,[LivePolicyFlag]
	,[Segmentation]
)
SELECT 
	 'Sales'																									AS [Dataset]
	,[QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,[QVCD].[AGENT_ID]																							AS [AGENT_ID]
	,[QVCD].[AgentName]																							AS [AgentName]
	,[QVCD].[SubagentName]																						AS [SubagentName]
	,CASE WHEN [QVCD].[OriginalSaleAgent] LIKE 'xb%' THEN 'webapp' ELSE [QVCD].[OriginalSaleAgent] END			AS [QuoteSaleAgentLogin]
	,CASE
		WHEN [QVCD].[OriginalSaleAgent] LIKE 'xb%' THEN 'Web Application'
		ELSE [U].[Forename] + ' ' + [U].[Surname]
	 END + CASE [RMAMH].[XBroker] WHEN 1 THEN ' (XBroker)' ELSE '' END											AS [QuoteSaleAgent]
	,[QVCD].[Quotedate]																							AS [OriginalActionDate]
	,[QVCD].[OriginalInceptionDate]																				AS [OriginalInceptionDate]
	,[QVCD].[ACTIONDATE]																						AS [ActionDate]
	,RTRIM([QVCD].[ClientReference])																			AS [ClientRef]
	,[QVCD].[ProductName]																						AS [ProductName]
	,CASE
		WHEN [QVCD].[ACTIONTYPE] = 3 THEN [QVCD].[MTASTARTDATE]
		WHEN [QVCD].[ACTIONTYPE] = 4 THEN [QVCD].[CANCELLATIONDATE]
		ELSE [QVCD].[POLICYSTARTDATE]
	 END																										AS [PolicyEffectiveDate]
	,[QVCD].[ClientName]																						AS [ClientName]
	,[QVCD].[ACTIONTYPE]																						AS [ACTIONTYPE]
	,[QVCD].[Action]																							AS [Action/TranType]
	,[QVCD].[Booked_Business_NB/REN]																			AS [NB/REN]
	,[QVCD].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	,[QVCD].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	,ISNULL([QVCD].[PolicyStatus], 'OtherStatus')																AS [PolicyStatus]
	,[QVCD].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS_DEBUG]
	,[QVCD].[Core_Addon]																						AS [CoreAddon]
	,ISNULL([QVCD].[PrimaryTrade], 'None')																		AS [PrimaryTrade]
	,[QVCD].[InsurerName]																						AS [Insurer]
	,[QVCD].[PaymentOption]																						AS [PaymentOption]
	,[QVCD].[Client_Source]																						AS [ClientSource]
	,[QVCD].[BusinessSource]																					AS [BusinessSource]
	,[QVCD].[LivePolicyFlag]																					AS [LivePolicyFlag]
	,CASE
		WHEN [QVCD].[ProductName] = 'Fleet' THEN 'Fleet'
		WHEN [QVCD].[ProductName] = 'Professional Indemnity' THEN 'PI'
		WHEN [QVCD].[ProductName] = 'Shop Insurance' THEN 'Retail'
		ELSE 'Liability'
	 END																										AS [Segmentation] -- Qlikview load script also attempts to set Xbroker to 'Wholesale' but because it's case sensitive and the 'XBroker' agent contains a capital 'B', this is never applied. Leaving this out here, so that the results match how Qlikview currently looks.
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [QVCD].[AGENT_ID] = [RMAMH].[AGENT_ID] -- Synonym pointing to Transactor_Live database
		LEFT JOIN [dbo].[User] AS [U] ON [QVCD].[QuoteSale]	= [U].[TGSLLogin] -- Synonym pointing to CRM database
WHERE
	NOT ((@EffectiveStartDate IS NOT NULL AND @EffectiveEndDate IS NULL) OR (@EffectiveStartDate IS NULL AND @EffectiveEndDate IS NOT NULL)) -- Prevent from running with effective start date but no end date or vice-versa
	AND NOT ((@ActionStartDate IS NOT NULL AND @ActionEndDate IS NULL) OR (@ActionStartDate IS NULL AND @ActionEndDate IS NOT NULL)) -- Prevent from running with action start date but no end date or vice-versa
	AND NOT (@EffectiveStartDate IS NULL AND @ActionStartDate IS NULL) -- Prevent from running if neither effective nor action dates supplied
	AND (@EffectiveStartDate IS NULL
		 OR ([QVCD].[ACTIONTYPE] IN (2,5,9,42) AND [QVCD].[POLICYSTARTDATE] >= @EffectiveStartDate AND [QVCD].[POLICYSTARTDATE] < @EffectiveEndDate) -- Policy, Renewal, Reinstatement, ManualDebitCredit. Note, for ManualDebitCredit the source value in the QVCD table is RAL.POLICYSTARTDATE instead of CPD.POLICYSTARTDATE as the date on the RAL appears to be the effective date the agent enters when keying the ManualDebitCredit, which can apply to a CPD record with a start date much earlier.
		 OR ([QVCD].[ACTIONTYPE] = 3 AND [QVCD].[MTASTARTDATE] >= @EffectiveStartDate AND [QVCD].[MTASTARTDATE] < @EffectiveEndDate) -- MTA
		 OR ([QVCD].[ACTIONTYPE] = 4 AND [QVCD].[CANCELLATIONDATE] >= @EffectiveStartDate AND [QVCD].[CANCELLATIONDATE] < @EffectiveEndDate) -- Cancellation
		)
	AND (@ActionStartDate IS NULL
		 OR ([QVCD].[ACTIONDATE] >= @ActionStartDate AND [QVCD].[ACTIONDATE] < @ActionEndDate)
		)
	AND ('ALL' IN (@AgentID) OR [QVCD].[AGENT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@AgentID, ',')))
	AND ('ALL' IN (@InsurerID) OR [QVCD].[INSURER_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@InsurerID, ',')))
	AND ('ALL' IN (@LoginName) OR [QVCD].[QuoteSale] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@LoginName, ',')))
ORDER BY
	[QVCD].[POLICYNUMBER]
;


-- Update financials:
-- (For some reason this works much faster as an update compared to joining to PolicyFinancials in the insert statement above)

UPDATE [Data]
SET	 [AccountsTransactionType] = [FIN].[EarliestTranCodePerHistGroup]
	,[GWPExcIPT] = [FIN].[GWP]
	,[GWPIncIPT] = [FIN].[GWP] + [FIN].[IPT]
	,[BrokerCommission] = [FIN].[BrokerTotalCommission]
	,[Discount] = [FIN].[BrokerDiscount]
	,[Fee] = [FIN].[Fee]
	,[Income] = [FIN].[Income]
	,[AgentCommission] = [FIN].[AgentTotalCommissionAndDiscount]
	,[SubAgentCommission] = [FIN].[SubAgentTotalCommissionAndDiscount]
	,[IntroducerCommission] = [FIN].[IntroducerTotalCommission]
FROM @Data AS [Data]
INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[POLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[HistoryOrGroupingID] = [FIN].[HistoryOrGroupingID]


-- Delete rows with no financials:
-- (These were originally not selected when there was an INNER JOIN to PolicyFinancials in the initial insert)
/*
DELETE FROM @Data
WHERE [GWPExcIPT] IS NULL AND [GWPIncIPT] IS NULL AND [BrokerCommission] IS NULL AND [Discount] IS NULL AND [Fee] IS NULL AND [Income] IS NULL AND [AgentCommission] IS NULL;
*/


-- =================================
-- New Business by Policy data table
-- =================================

INSERT INTO @Data (
	 [Dataset]
	,[PolicyNumber]
	,[AgentName]
	,[SubagentName]
	,[QuoteSaleAgent]
	,[ActionDate]
	,[ClientRef]
	,[ProductName]
	,[OriginalInceptionDate]
	,[PolicyEffectiveDate]
	,[Action/TranType]
	,[NB/REN]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[PolicyStatus]
	,[POLICY_STATUS_DEBUG]
	,[AccountsTransactionType]
	,[Segmentation]
	,[BusinessSource]
	,[Policies]
	,[GWPExcIPT]
	,[GWPIncIPT]
	,[MTAIncome]
	,[BrokerCommission]
	,[Discount]
	,[Fee]
	,[Brand Income]
	,[CanxIncome]
	,[Income]
	,[SubAgentCommission]
	,[AgentCommission]
	,[IntroducerCommission]
	,[XBrokerIncome]
	,[BooksIncome]
)
SELECT
	 'New Business by Policy'																					AS [Dataset]
	,[Data].[PolicyNumber]																						AS [PolicyNumber]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[SubagentName]																						AS [SubagentName]
	,[Data].[QuoteSaleAgent]																					AS [QuoteSaleAgent]
	,[Data].[ActionDate]																						AS [ActionDate]
	,[Data].[ClientRef]																							AS [ClientRef]
	,[Data].[ProductName]																						AS [ProductName]
	,[Data].[OriginalInceptionDate]																				AS [OriginalInceptionDate]
	,[Data].[PolicyEffectiveDate]																				AS [PolicyEffectiveDate]
	,[Data].[Action/TranType]																					AS [Action/TranType]
	,[Data].[NB/REN]																							AS [NB/REN]
	,[Data].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	,[Data].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	,[Data].[PolicyStatus]																						AS [PolicyStatus]
	,[Data].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS_DEBUG]
	,[Data].[AccountsTransactionType]																			AS [AccountsTransactionType]
	,[Data].[Segmentation]																						AS [Segmentation]
	,[Data].[BusinessSource]																					AS [BusinessSource]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'NB' AND [Data].[Action/TranType] <> 'Reinstatement' THEN 1 ELSE 0
	 END																										AS [Policies]
	,[Data].[GWPExcIPT]																							AS [GWPExcIPT]
	,[Data].[GWPIncIPT]																							AS [GWPIncIPT]
	,CASE WHEN [Data].[Action/TranType] = 'NBMTA' THEN [Data].[Income] ELSE 0 END								AS [MTAIncome]
	,[Data].[BrokerCommission]																					AS [BrokerCommission]
	,[Data].[Discount]																							AS [Discount]
	,[Data].[Fee]																								AS [Fee]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' OR [Data].[Action/TranType] = 'NBCANX' THEN 0
		ELSE [Data].[Income]
	 END																										AS [Brand Income]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' OR [Data].[Action/TranType] = 'NBCANX' THEN [Data].[Income]
		ELSE 0
	 END																										AS [CanxIncome]
	,[Data].[Income]																							AS [Income]
	,[Data].[SubAgentCommission]																				AS [SubAgentCommission]
	,[Data].[AgentCommission]																					AS [AgentCommission]
	,[Data].[IntroducerCommission]																				AS [IntroducerCommission]
	,CASE
		WHEN ISNULL([Data].[XBroker_NB/REN], '') <> ''
			THEN [Data].[BrokerCommission] + [Data].[Discount] + [Data].[Fee] + [Data].[SubAgentCommission]
		ELSE 0
	 END																										AS [XBrokerIncome]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' OR [Data].[Action/TranType] = 'NBCANX' THEN 0
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'NB' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] IN ('Renewal', 'Reinstatement') THEN 0
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] IN ('NB', 'MTA') AND [Data].[PolicyStatus] NOT IN ('Invited', 'OtherStatus') AND [Data].[Action/TranType] = 'NBMTA' THEN 0
		ELSE [Data].[Income]
	 END																										AS [BooksIncome]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Sales'
	AND (([Data].[Booked_Business_NB/REN/CANX/MTA] = 'NB' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'LapsedRenewed') AND [Data].[Action/TranType] IN ('Renewal', 'New Business', 'Reinstatement'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'NB' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] IN ('New Business','Renewal', 'Reinstatement') AND [Data].[POLICY_STATUS_DEBUG] = 'History File')
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'NB' AND [Data].[PolicyStatus] = 'Invited' AND [Data].[Action/TranType] IN ('New Business', 'Reinstatement') AND [Data].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] IN ('NB', 'MTA') AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'LapsedRenewed') AND [Data].[Action/TranType] = 'NBMTA')
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] = 'Invited' AND [Data].[Action/TranType] = 'NBMTA' AND [Data].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] = 'NBCANX') --AND [Data].[POLICY_STATUS_DEBUG] <> 'Cancellation Pending')		
		 OR ([Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] = 'NBCANX' AND [Data].[POLICY_STATUS_DEBUG] = 'Policy' AND [Data].[LivePolicyFlag] = 'Y')		
		)
	AND NOT ([GWPExcIPT] IS NULL AND [GWPIncIPT] IS NULL AND [BrokerCommission] IS NULL AND [Discount] IS NULL AND [Fee] IS NULL AND [Income] IS NULL AND [AgentCommission] IS NULL)
;


-- ======================================
-- Existing Business by Policy data table
-- ======================================

INSERT INTO @Data (
	 [Dataset]
	,[PolicyNumber]
	,[AgentName]
	,[SubagentName]
	,[QuoteSaleAgent]
	,[ActionDate]
	,[ClientRef]
	,[ProductName]
	,[OriginalInceptionDate]
	,[PolicyEffectiveDate]
	,[Action/TranType]
	,[NB/REN]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[XBroker_NB/REN]
	,[PolicyStatus]
	,[POLICY_STATUS_DEBUG]
	,[AccountsTransactionType]
	,[Segmentation]
	,[BusinessSource]
	,[Policies]
	,[GWPExcIPT]
	,[GWPIncIPT]
	,[MTAIncome]
	,[BrokerCommission]
	,[Discount]
	,[Fee]
	,[Brand Income]
	,[CanxIncome]
	,[Income]
	,[SubAgentCommission]
	,[AgentCommission]
	,[IntroducerCommission]
	,[XBrokerIncome]
	,[BooksIncome]
)
SELECT
	 'Existing Business by Policy'																				AS [Dataset]
	,[Data].[PolicyNumber]																						AS [PolicyNumber]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[SubagentName]																						AS [SubagentName]
	,[Data].[QuoteSaleAgent]																					AS [QuoteSaleAgent]
	,[Data].[ActionDate]																						AS [ActionDate]
	,[Data].[ClientRef]																							AS [ClientRef]
	,[Data].[ProductName]																						AS [ProductName]
	,[Data].[OriginalInceptionDate]																				AS [OriginalInceptionDate]
	,[Data].[PolicyEffectiveDate]																				AS [PolicyEffectiveDate]
	,[Data].[Action/TranType]																					AS [Action/TranType]
	,[Data].[NB/REN]																							AS [NB/REN]
	,[Data].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	,[Data].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	,[Data].[PolicyStatus]																						AS [PolicyStatus]
	,[Data].[POLICY_STATUS_DEBUG]																				AS [POLICY_STATUS_DEBUG]
	,[Data].[AccountsTransactionType]																			AS [AccountsTransactionType]
	,[Data].[Segmentation]																						AS [Segmentation]
	,[Data].[BusinessSource]																					AS [BusinessSource]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN'
			AND NOT ([Data].[PolicyStatus] = 'Invited' AND ([Data].[Action/TranType] IN ('New Business', 'Reinstatement') OR [Data].[POLICY_STATUS_DEBUG] = 'History File')) -- In Qlikview these criteria are included in financials but not in the policy count
			THEN 1
		ELSE 0
	 END																										AS [Policies]
	,[Data].[GWPExcIPT]																							AS [GWPExcIPT]
	,[Data].[GWPIncIPT]																							AS [GWPIncIPT]
	,CASE WHEN [Data].[Action/TranType] = 'RENMTA' THEN [Data].[Income] ELSE 0 END								AS [MTAIncome]
	,[Data].[BrokerCommission]																					AS [BrokerCommission]
	,[Data].[Discount]																							AS [Discount]
	,[Data].[Fee]																								AS [Fee]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' OR [Data].[Action/TranType] = 'RENCANX' THEN 0
		ELSE [Data].[Income]
	 END																										AS [Brand Income]
	,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' OR [Data].[Action/TranType] = 'RENCANX' THEN [Data].[Income]
		ELSE 0
	 END																										AS [CanxIncome]
	,[Data].[Income]																							AS [Income]
	,[Data].[SubAgentCommission]																				AS [SubAgentCommission]
	,[Data].[AgentCommission]																					AS [AgentCommission]
	,[Data].[IntroducerCommission]																				AS [IntroducerCommission]
	,CASE
		WHEN ISNULL([Data].[XBroker_NB/REN], '') <> ''
			THEN [Data].[BrokerCommission] + [Data].[Discount] + [Data].[Fee] + [Data].[SubAgentCommission]
		ELSE 0
	 END																										AS [XBrokerIncome]
	 ,CASE
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'LapsedRenewed', 'Invited') AND [Data].[Action/TranType] = 'Reinstatement' THEN 0
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] <> 'Renewal' THEN 0
		WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] <> 'Invited' THEN 0
		WHEN [Data].[PolicyStatus] = 'Cancelled' AND [Data].[POLICY_STATUS_DEBUG] = 'Policy' AND [Data].[LivePolicyFlag] = 'Y' THEN [Data].[Income]
		WHEn [Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] = 'RENCANX' THEN 0
		ELSE [Data].[Income]
	  END																										AS [BooksIncome]
FROM
	@Data AS [Data]
WHERE
--[PolicyNumber] = 'ACTRM1014113' AND
	[Dataset] = 'Sales'
	AND (([Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'LapsedRenewed') AND [Data].[Action/TranType] IN ('Renewal', 'New Business', 'Reinstatement'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] IN ('New Business','Renewal', 'Reinstatement') AND [Data].[POLICY_STATUS_DEBUG] = 'History File')
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'REN' AND [Data].[PolicyStatus] = 'Invited' AND [Data].[Action/TranType] IN ('New Business','Renewal', 'Reinstatement') AND [Data].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed', 'LapsedRenewed') AND [Data].[Action/TranType] = 'RENMTA')
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] = 'Invited' AND [Data].[Action/TranType] = 'RENMTA' AND [Data].[POLICY_STATUS_DEBUG] IN ('Policy', 'History File'))
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX' AND [Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] = 'RENCANX')-- AND [Data].[POLICY_STATUS_DEBUG] <> 'Cancellation Pending')		
		 OR ([Data].[PolicyStatus] = 'Cancelled' AND [Data].[Action/TranType] = 'RENCANX' AND [Data].[POLICY_STATUS_DEBUG] = 'Policy' AND [Data].[LivePolicyFlag] = 'Y')		
		)
	AND NOT ([GWPExcIPT] IS NULL AND [GWPIncIPT] IS NULL AND [BrokerCommission] IS NULL AND [Discount] IS NULL AND [Fee] IS NULL AND [Income] IS NULL AND [AgentCommission] IS NULL)
;


-- ====================
-- New Business Summary
-- ====================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[MTAIncome]
	,[Brand Income]
	,[CanxIncome]
	,[Income]
	,[SubAgentCommission]
	,[AgentCommission]
	,[IntroducerCommission]
	,[XBrokerIncome]
	,[BooksIncome]
)
SELECT
	 'New Business Summary'																						AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,SUM([Data].[Policies])																						AS [Policies]
	,SUM([Data].[GWPExcIPT])																					AS [GWPExcIPT]
	,SUM([Data].[MTAIncome])																					AS [MTAIncome]
	,SUM([Data].[Brand Income])																					AS [Brand Income]
	,SUM([Data].[CanxIncome])																					AS [CanxIncome]
	,SUM([Data].[Income])																						AS [Income]
	,SUM([Data].[SubAgentCommission])																			AS [SubAgentCommission]
	,SUM([Data].[AgentCommission])																				AS [AgentCommission]
	,SUM([Data].[IntroducerCommission])																			AS [IntroducerCommission]
	,SUM([Data].[XBrokerIncome])																				AS [XBrokerIncome]
	,SUM([Data].[BooksIncome])																					AS [BooksIncome]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'New Business by Policy'
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- =========================
-- Existing Business Summary
-- =========================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[MTAIncome]
	,[Brand Income]
	,[CanxIncome]
	,[Income]
	,[SubAgentCommission]
	,[AgentCommission]
	,[IntroducerCommission]
	,[XBrokerIncome]
	,[BooksIncome]
)
SELECT
	 'Existing Business Summary'																				AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,SUM([Data].[Policies])																						AS [Policies]
	,SUM([Data].[GWPExcIPT])																					AS [GWPExcIPT]
	,SUM([Data].[MTAIncome])																					AS [MTAIncome]
	,SUM([Data].[Brand Income])																					AS [Brand Income]
	,SUM([Data].[CanxIncome])																					AS [CanxIncome]
	,SUM([Data].[Income])																						AS [Income]
	,SUM([Data].[SubAgentCommission])																			AS [SubAgentCommission]
	,SUM([Data].[AgentCommission])																				AS [AgentCommission]
	,SUM([Data].[IntroducerCommission])																			AS [IntroducerCommission]
	,SUM([Data].[XBrokerIncome])																				AS [XBrokerIncome]
	,SUM([Data].[BooksIncome])																					AS [BooksIncome]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Existing Business by Policy'
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- ==============================
-- MTA New Business Summary table
-- ==============================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'MTA New Business Summary'																					AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,COUNT(DISTINCT CASE
						WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed')
						THEN [Data].[POLICYNUMBER]
					END)																						AS [Policies]
	,SUM(CASE
			WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed')
			THEN [Data].[GWPExcIPT]
		 END)																									AS [GWPExcIPT]
	,SUM([Data].[Income])																						AS [Brand Income]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Sales'
	AND (([Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed') AND [Data].[Action/TranType] IN ('NBMTA')) -- Qlikview logic for Policies and Premium
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] IN ('NB','MTA') AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed', 'Invited', 'LapsedRenewed') AND [Data].[Action/TranType] IN ('NBMTA')) -- Qlikview logic for Brand Income
		)
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- ===================================
-- MTA Existing Business Summary table
-- ===================================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'MTA Existing Business Summary'																					AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,COUNT(DISTINCT CASE
						WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed')
						THEN [Data].[POLICYNUMBER]
					END)																						AS [Policies]
	,SUM(CASE
			WHEN [Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed')
			THEN [Data].[GWPExcIPT]
		 END)																									AS [GWPExcIPT]
	,SUM([Data].[Income])																						AS [Brand Income]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Sales'
	AND (([Data].[Booked_Business_NB/REN/CANX/MTA] = 'MTA' AND [Data].[PolicyStatus] IN ('Policy', 'OtherStatus', 'Renewed', 'Lapsed') AND [Data].[Action/TranType] IN ('RENMTA')) -- Qlikview logic for Policies and Premium
		 OR ([Data].[Booked_Business_NB/REN/CANX/MTA] IN ('NB','MTA') AND [Data].[PolicyStatus] IN ('OtherStatus', 'Policy','Renewed','Lapsed', 'Invited', 'LapsedRenewed') AND [Data].[Action/TranType] IN ('RENMTA')) -- Qlikview logic for Brand Income
		)
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- =================
-- MTA Summary table
-- =================

WITH [DataNB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
	FROM
		@Data
	WHERE
		[Dataset] = 'MTA New Business Summary'
)
,[DataEB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
	FROM
		@Data
	WHERE
		[Dataset] = 'MTA Existing Business Summary'
)
INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'MTA Summary'																								AS [Dataset]
	,ISNULL([DataNB].[AgentName], [DataEB].[AgentName])															AS [AgentName]
	,ISNULL([DataNB].[Segmentation], [DataEB].[Segmentation])													AS [Segmentation]
	,ISNULL([DataNB].[Policies], 0)	+ ISNULL([DataEB].[Policies], 0)											AS [Policies]
	,ISNULL([DataNB].[GWPExcIPT], 0)	+ ISNULL([DataEB].[GWPExcIPT], 0)										AS [GWPExcIPT]
	,ISNULL([DataNB].[Brand Income], 0)	+ ISNULL([DataEB].[Brand Income], 0)									AS [Brand Income]
FROM
	[DataNB]
	FULL JOIN [DataEB] ON [DataNB].[AgentName] = [DataEB].[AgentName]
					   AND [DataNB].[Segmentation] = [DataEB].[Segmentation]
;


-- ========================================
-- Cancellations New Business Summary table
-- ========================================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'Cancellations New Business Summary'																		AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,COUNT(DISTINCT [Data].[POLICYNUMBER])																		AS [Policies]
	,SUM([Data].[GWPExcIPT])																					AS [GWPExcIPT]
	,SUM([Data].[Income])																						AS [Brand Income]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Sales'
	AND [Data].[PolicyStatus] = 'Cancelled'
	AND [Data].[Action/TranType] = 'NBCANX'
	AND ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX'
		 OR ([Data].[POLICY_STATUS_DEBUG] = 'Policy' AND [Data].[LivePolicyFlag] = 'Y')
		)
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- =============================================
-- Cancellations Existing Business Summary table
-- =============================================

INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'Cancellations Existing Business Summary'																	AS [Dataset]
	,[Data].[AgentName]																							AS [AgentName]
	,[Data].[Segmentation]																						AS [Segmentation]
	,COUNT(DISTINCT [Data].[POLICYNUMBER])																		AS [Policies]
	,SUM([Data].[GWPExcIPT])																					AS [GWPExcIPT]
	,SUM([Data].[Income])																						AS [Brand Income]
FROM
	@Data AS [Data]
WHERE
	[Dataset] = 'Sales'
	AND [Data].[PolicyStatus] = 'Cancelled'
	AND [Data].[Action/TranType] = 'RENCANX'
	AND ([Data].[Booked_Business_NB/REN/CANX/MTA] = 'CANX'
		 OR ([Data].[POLICY_STATUS_DEBUG] = 'Policy' AND [Data].[LivePolicyFlag] = 'Y')
		)
GROUP BY
	 [Data].[AgentName]
	,[Data].[Segmentation]
;


-- ===========================
-- Cancellations Summary table
-- ===========================

WITH [DataNB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
	FROM
		@Data
	WHERE
		[Dataset] = 'Cancellations New Business Summary'
)
,[DataEB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
	FROM
		@Data
	WHERE
		[Dataset] = 'Cancellations Existing Business Summary'
)
INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
)
SELECT
	 'Cancellations Summary'																					AS [Dataset]
	,ISNULL([DataNB].[AgentName], [DataEB].[AgentName])															AS [AgentName]
	,ISNULL([DataNB].[Segmentation], [DataEB].[Segmentation])													AS [Segmentation]
	,ISNULL([DataNB].[Policies], 0)	+ ISNULL([DataEB].[Policies], 0)											AS [Policies]
	,ISNULL([DataNB].[GWPExcIPT], 0)	+ ISNULL([DataEB].[GWPExcIPT], 0)										AS [GWPExcIPT]
	,ISNULL([DataNB].[Brand Income], 0)	+ ISNULL([DataEB].[Brand Income], 0)									AS [Brand Income]
FROM
	[DataNB]
	FULL JOIN [DataEB] ON [DataNB].[AgentName] = [DataEB].[AgentName]
					   AND [DataNB].[Segmentation] = [DataEB].[Segmentation]
;


-- ======================
-- Combined Summary table
-- ======================

WITH [DataNB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
		,[Income]
		,[BooksIncome]
	FROM
		@Data
	WHERE
		[Dataset] = 'New Business Summary'
)
,[DataEB] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
		,[GWPExcIPT]
		,[Brand Income]
		,[Income]
		,[BooksIncome]
	FROM
		@Data
	WHERE
		[Dataset] = 'Existing Business Summary'
)
,[DataCANX] AS
(
	SELECT
		 [AgentName]
		,[Segmentation]
		,[Policies]
	FROM
		@Data
	WHERE
		[Dataset] = 'Cancellations Summary'
)
INSERT INTO @Data (
	 [Dataset]
	,[AgentName]
	,[Segmentation]
	,[Policies]
	,[GWPExcIPT]
	,[Brand Income]
	,[Income]
	,[BooksIncome]
)
SELECT
	 'Combined Summary'																							AS [Dataset]
	,ISNULL([DataNB].[AgentName], [DataEB].[AgentName])															AS [AgentName]
	,ISNULL([DataNB].[Segmentation], [DataEB].[Segmentation])													AS [Segmentation]
	,ISNULL([DataNB].[Policies], 0)	+ ISNULL([DataEB].[Policies], 0) - ISNULL([DataCANX].[Policies], 0)			AS [Policies]
	,ISNULL([DataNB].[GWPExcIPT], 0) + ISNULL([DataEB].[GWPExcIPT], 0)											AS [GWPExcIPT]
	,ISNULL([DataNB].[Brand Income], 0) + ISNULL([DataEB].[Brand Income], 0)									AS [Brand Income]
	,ISNULL([DataNB].[Income], 0) + ISNULL([DataEB].[Income], 0)												AS [Income]
	,ISNULL([DataNB].[BooksIncome], 0) + ISNULL([DataEB].[BooksIncome], 0)										AS [BooksIncome]
FROM
	[DataNB]
	FULL JOIN [DataEB] ON [DataNB].[AgentName] = [DataEB].[AgentName]
					   AND [DataNB].[Segmentation] = [DataEB].[Segmentation]
	FULL JOIN [DataCANX] ON ISNULL([DataNB].[AgentName], [DataEB].[AgentName]) = [DataCANX].[AgentName]
						 AND ISNULL([DataNB].[Segmentation], [DataEB].[Segmentation]) = [DataCANX].[Segmentation]
;


-- ======================
-- Combined Policy Detail
-- ======================

WITH [DataByPolicy] AS
(
	SELECT
		 [Dataset]
		,[PolicyNumber]
		,[Brand Income]
		,[MTAIncome]
		,[CanxIncome]
	FROM
		@Data
	WHERE
		[Dataset] = 'New Business by Policy'

	UNION ALL

	SELECT
		 [Dataset]
		,[PolicyNumber]
		,[Brand Income]
		,[MTAIncome]
		,[CanxIncome]
	FROM
		@Data
	WHERE
		[Dataset] = 'Existing Business by Policy'
)
INSERT INTO @Data (
	 [Dataset]
	,[PolicyNumber]
	,[Brand Income]
	,[Brand Income NB]
	,[Brand Income EB]
	,[MTAIncome]
	,[CanxIncome]
)
SELECT
	 'Combined Policy Detail'																					AS [Dataset]
	,[PolicyNumber]																								AS [PolicyNumber]
	,SUM([Brand Income])																						AS [Brand Income]
	,SUM(CASE WHEN [Dataset] = 'New Business by Policy' THEN [Brand Income] ELSE 0 END)							AS [Brand Income NB]
	,SUM(CASE WHEN [Dataset] = 'Existing Business by Policy' THEN [Brand Income] ELSE 0 END)					AS [Brand Income EB]
	,SUM([MTAIncome])																							AS [MTAIncome]
	,SUM([CanxIncome])																							AS [CanxIncome]
FROM
	[DataByPolicy]
GROUP BY
	[PolicyNumber]
;


-- Return data to the report:

SELECT * FROM @Data
--WHERE [Dataset] = 'Combined Policy Detail'
ORDER BY [Dataset], [AgentName], [Segmentation]
;