USE [MI]
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 03 Sep 2024
-- Description:	SME Agent Scorecard full dataset from overnight saved data (Qlikview replacement)
-- =============================================

-- Date			Who						Change
-- 14/02/2025	Jeremai Smith			Added ProductName field (Monday.com ticket 8370817954)


ALTER PROCEDURE [dbo].[uspReportAgentScorecardSMEDataset]
	 @EffectiveStartDate datetime
	,@EffectiveEndDate datetime
	,@ActionStartDate datetime
	,@ActionEndDate datetime
	,@AgentID varchar(MAX)
	,@LoginName varchar(50)
AS

/*

-- Supply either effective or action dates, or both:

DECLARE @EffectiveStartDate datetime = '01 Sep 2024'
DECLARE @EffectiveEndDate datetime = '30 Sep 2024'
DECLARE @ActionStartDate datetime
DECLARE @ActionEndDate datetime
DECLARE @AgentID varchar(MAX) = 'ALL'
DECLARE @LoginName varchar(50) = 'ALL' -- adavies -- select * from CRM.dbo.[User] where isnull(obsolete, 0) <> 1 order by surname, forename

EXEC [dbo].[uspReportAgentScorecardSMEDataset] @EffectiveStartDate, @EffectiveEndDate, @ActionStartDate, @ActionEndDate, @AgentID, @LoginName

*/


IF CONVERT(VARCHAR(12), @EffectiveEndDate, 114) = '00:00:00:000'
	SET @EffectiveEndDate = DATEADD(DAY, 1, @EffectiveEndDate);

IF CONVERT(VARCHAR(12), @ActionEndDate, 114) = '00:00:00:000'
	SET @ActionEndDate = DATEADD(DAY, 1, @ActionEndDate);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- ==================================
-- Create table variable to hold data
-- ==================================

DECLARE @Data TABLE (
	 [Dataset] varchar(25)
	,[POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[HistoryOrGroupingID] int
	,[AGENT_ID] char(32)
	,[AgentName] varchar(255)
	,[OriginalSaleAgentLogin] varchar(50)
	,[OriginalSaleAgent] varchar(171)
	,[OriginalActionDate] datetime
	,[ActionDate] datetime
	,[ClientRef] varchar(25)
	,[PolicyEffectiveDate] datetime
	,[ClientName] varchar(255)
	,[ProductName] varchar(255)
	,[PolicyNumber] varchar(30)
	,[TransactionType] varchar(18)
	,[Booked_Business_NB/REN/CANX/MTA] varchar(4)
	,[PolicyStatus] varchar(13)
	,[CoreAddon] varchar(6)
	,[PrimaryTrade] varchar(500)
	,[Insurer] varchar(255)
	,[PaymentOption] varchar(25)
	,[ClientSource] varchar(50)
	,[BusinessSource] varchar(255)
	,[GWPExcIPT] money
	,[GWPIncIPT] money
	,[BrokerCommission] money
	,[Discount] money
	,[Fee] money
	,[Income] money
	,[AgentCommission] money
	,[XBroker_NB/REN] varchar(3)
	,[NB/REN] varchar(3)
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


-- =============
-- 1. Sales data
-- =============

INSERT INTO @Data (
	 [Dataset]
	,[POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[AGENT_ID]
	,[AgentName]
	,[OriginalSaleAgentLogin]
	,[OriginalSaleAgent]
	,[OriginalActionDate]
	,[ActionDate]
	,[ClientRef]
	,[PolicyEffectiveDate]
	,[ClientName]
	,[ProductName]
	,[PolicyNumber]
	,[TransactionType]
	,[Booked_Business_NB/REN/CANX/MTA]
	,[PolicyStatus]
	,[CoreAddon]
	,[PrimaryTrade]
	,[Insurer]
	,[PaymentOption]
	,[ClientSource]
	,[BusinessSource]
	,[XBroker_NB/REN]
	,[NB/REN]
)
SELECT 
	 'Sales'																									AS [Dataset]
	,[QVCD].[POLICY_DETAILS_ID]																					AS [POLICY_DETAILS_ID]
	,[QVCD].[HISTORY_ID]																						AS [HISTORY_ID]
	,[QVCD].[HistoryOrGroupingID]																				AS [HistoryOrGroupingID]
	,[QVCD].[AGENT_ID]																							AS [AGENT_ID]
	,[QVCD].[AgentName]																							AS [AgentName]
	,CASE WHEN [QVCD].[OriginalSaleAgent] LIKE 'xb%' THEN 'webapp' ELSE [QVCD].[OriginalSaleAgent] END			AS [OriginalSaleAgentLogin]
	,CASE
		WHEN [QVCD].[OriginalSaleAgent] LIKE 'xb%' THEN 'Web Application'
		ELSE [U].[Forename] + ' ' + [U].[Surname]
	 END + CASE [RMAMH].[XBroker] WHEN 1 THEN ' (XBroker)' ELSE '' END											AS [OriginalSaleAgent]
	,[QVCD].[Quotedate]																							AS [OriginalActionDate]
	,[QVCD].[ACTIONDATE]																						AS [ActionDate]
	,RTRIM([QVCD].[ClientReference])																			AS [ClientRef]
	,CASE
		WHEN [QVCD].[ACTIONTYPE] = 3 THEN [QVCD].[MTASTARTDATE]	ELSE [QVCD].[POLICYSTARTDATE]
	 END																										AS [PolicyEffectiveDate]
	,[QVCD].[ClientName]																						AS [ClientName]
	,[QVCD].[ProductName]																						AS [ProductName]
	,[QVCD].[POLICYNUMBER]																						AS [PolicyNumber]
	,[QVCD].[Action]																							AS [TransactionType]
	,[QVCD].[Booked_Business_NB/REN/CANX/MTA]																	AS [Booked_Business_NB/REN/CANX/MTA]
	,[QVCD].[PolicyStatus]																						AS [PolicyStatus]
	,[QVCD].[Core_Addon]																						AS [CoreAddon]
	,ISNULL([QVCD].[PrimaryTrade], 'None')																		AS [PrimaryTrade]
	,[QVCD].[InsurerName]																						AS [Insurer]
	,[QVCD].[PaymentOption]																						AS [PaymentOption]
	,[QVCD].[Client_Source]																						AS [ClientSource]
	,[QVCD].[BusinessSource]																					AS [BusinessSource]
	,[QVCD].[XBroker_NB/REN]																					AS [XBroker_NB/REN]
	,[QVCD].[Booked_Business_NB/REN]																			AS [NB/REN]
FROM
	[dbo].[QVCustomerDetails] AS [QVCD]
		LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [QVCD].[AGENT_ID] = [RMAMH].[AGENT_ID] -- Synonym pointing to Transactor_Live database
		LEFT JOIN [dbo].[User] AS [U] ON [QVCD].[OriginalSaleAgent]	= [U].[TGSLLogin] -- Synonym pointing to CRM database
WHERE
	NOT ((@EffectiveStartDate IS NOT NULL AND @EffectiveEndDate IS NULL) OR (@EffectiveStartDate IS NULL AND @EffectiveEndDate IS NOT NULL)) -- Prevent from running with effective start date but no end date or vice-versa
	AND NOT ((@ActionStartDate IS NOT NULL AND @ActionEndDate IS NULL) OR (@ActionStartDate IS NULL AND @ActionEndDate IS NOT NULL)) -- Prevent from running with action start date but no end date or vice-versa
	AND NOT (@EffectiveStartDate IS NULL AND @ActionStartDate IS NULL) -- Prevent from running if neither effective nor action dates supplied
	AND (@EffectiveStartDate IS NULL
		 OR ([QVCD].[ACTIONTYPE] IN (2,5,9,42) AND [QVCD].[POLICYSTARTDATE] >= @EffectiveStartDate AND [QVCD].[POLICYSTARTDATE] < @EffectiveEndDate) -- Policy, Renewal, Reinstatement, ManualDebitCredit. Note, for ManualDebitCredit the source value in the QVCD table is RAL.POLICYSTARTDATE instead of CPD.POLICYSTARTDATE as the date on the RAL appears to be the effective date the agent enters when keying the ManualDebitCredit, which can apply to a CPD record with a start date much earlier.
		 OR ([QVCD].[ACTIONTYPE] = 3 AND [QVCD].[MTASTARTDATE] >= @EffectiveStartDate AND [QVCD].[MTASTARTDATE] < @EffectiveEndDate) -- MTA
		)
	AND (@ActionStartDate IS NULL
		 OR ([QVCD].[ACTIONDATE] >= @ActionStartDate AND [QVCD].[ACTIONDATE] < @ActionEndDate)
		)
	AND [QVCD].[Booked_Business_NB/REN/CANX/MTA] IN ('NB','REN','MTA')
	AND ([QVCD].[PolicyStatus] IS NULL OR [PolicyStatus] IN ('Policy','Renewed','Lapsed','LapsedRenewed','Invited'))
	AND [QVCD].[Action] IN ('Renewal','New Business','NBMTA','RENMTA','Reinstatement')
	AND NOT EXISTS (SELECT 1 FROM [dbo].[RM_SCHEME] WHERE [SCHEMETABLE_ID] = [QVCD].[SCHEMETABLE_ID] AND [NAME] LIKE '%Complimentary%' AND [DELETED] <> 1) -- Doing this as a NOT EXISTS instead of a join because some SCHEMETABLE_IDs exist more than once in RM_SCHEME which would cause duplicate rows
	AND NOT ([QVCD].[SCHEMETABLE_ID] = 1073 AND [QVCD].[POLICYSTARTDATE] >= '31 Jan 2022' AND [QVCD].[POLICYSTARTDATE] <= '30 Jun 2023') -- Keycare product was excluded due to being given away free between January 2022 and when the complimentary scheme was created in June 2023, to prevent showing income as the write-off transactions were not loaded in Qlikview
	AND NOT ([QVCD].[ACTIONTYPE] = 9 AND EOMONTH([QVCD].[POLICYINCEPTIONDATE]) <> EOMONTH([QVCD].[POLICYSTARTDATE])) -- Exclude reinstatements with a new effective date, as the agent will already have been credited with the sale in the original effective month
ORDER BY
	[QVCD].[POLICYNUMBER]
;


-- Update financials:
-- (For some reason this works much faster as an update compared to joining to PolicyFinancials in the insert statement above)

UPDATE [Data]
SET	 [GWPExcIPT] = [FIN].[GWP]
	,[GWPIncIPT] = [FIN].[GWP] + [FIN].[IPT]
	,[BrokerCommission] = [FIN].[BrokerTotalCommission]
	,[Discount] = [FIN].[BrokerDiscount]
	,[Fee] = [FIN].[Fee]
	,[Income] = [FIN].[Income]
	,[AgentCommission]= [FIN].[AgentTotalCommissionAndDiscount]
FROM @Data AS [Data]
INNER JOIN [dbo].[PolicyFinancials] AS [FIN] ON [Data].[POLICY_DETAILS_ID] = [FIN].[POLICY_DETAILS_ID] AND [Data].[HistoryOrGroupingID] = [FIN].[HistoryOrGroupingID]


-- Delete rows with no financials:
-- (These were originally not selected when there was an INNER JOIN to PolicyFinancials in the initial insert)

DELETE FROM @Data
WHERE [GWPExcIPT] IS NULL AND [GWPIncIPT] IS NULL AND [BrokerCommission] IS NULL AND [Discount] IS NULL AND [Fee] IS NULL AND [Income] IS NULL AND [AgentCommission] IS NULL;


-- ===============
-- 2. Targets data
-- ===============

INSERT INTO @Data (
	 [Dataset]
	,[OriginalSaleAgentLogin]
	,[OriginalSaleAgent]
	,[NB/REN]
	,[TargetMonthDate]
	,[TargetAmount]
)
SELECT
	 'Targets'																									AS [Dataset]
	,[U].[TGSLLogin]																							AS [OriginalSaleAgentLogin]
	,[U].[Forename] + ' ' + [U].[Surname]																		AS [OriginalSaleAgent]
	,[TGT].[NB/REN]																								AS [NB/REN]
	,[TGT].[TargetMonthDate]																					AS [TargetMonthDate]
	,[TGT].[TargetAmount]																						AS [TargetAmount]
FROM
	[dbo].[UserTarget] AS [TGT]
		INNER JOIN [dbo].[User] AS [U] ON [TGT].[UserId] = [U].[ID]
			LEFT JOIN [dbo].[UserTeamHistory] AS [TH] ON [TGT].[UserId] = [TH].[UserId]
													  AND [TH].[StartDate] <= [TGT].[TargetMonthDate]
													  AND ISNULL([TH].[EndDate], '31 Dec 3000') > [TGT].[TargetMonthDate]
				LEFT JOIN [dbo].[Team] AS [T] ON [TH].[TeamID] = [T].[ID]
											  AND [T].[BusinessAreaID] = 1 -- SME
WHERE
	[TGT].[TargetMonthDate]	>= ISNULL(@EffectiveStartDate, @ActionStartDate) AND [TGT].[TargetMonthDate] < ISNULL(@EffectiveEndDate, @ActionEndDate)
	AND [TGT].[TargetAmount] > 0
	AND ([U].[Forename] + ' ' + [U].[Surname] = 'Web Application' OR [T].[BusinessAreaID] = 1) -- 1 = SME (Web app doesn't have team records)
	AND [U].[TGSLLogin] IS NOT NULL
;


-- ====================================
-- 3. Summary table by Agent and NB/REN
-- ====================================

INSERT INTO @Data (
	 [Dataset]
	,[OriginalSaleAgent]
	,[Income]
	,[NB/REN]
	,[TargetAmount]
)
SELECT
	 'AgentNBRENSummary'																						AS [Dataset]
	,[OriginalSaleAgent]																						AS [OriginalSaleAgent]
	,SUM(ISNULL([Income], 0))																					AS [Income]
	,[NB/REN]																									AS [NB/REN]
	,SUM([TargetAmount])																						AS [TargetAmount]
FROM
	@Data
WHERE
	[Dataset] IN ('Sales', 'Targets')
GROUP BY
	 [OriginalSaleAgent]
	,[NB/REN]
;


-- =======================================
-- 4. Summary table by Agent with rankings
-- =======================================

INSERT INTO @Data (
	 [Dataset]
	,[OriginalSaleAgent]
	,[Income]
	,[TargetAmount]
	,[WebIncome]
	,[DataIncome]
)
SELECT
	 'AgentSummary'																								AS [Dataset]
	,[OriginalSaleAgent]																						AS [OriginalSaleAgent]
	,SUM(ISNULL([Income], 0))																					AS [Income]
	,SUM([TargetAmount])																						AS [TargetAmount]
	,SUM(CASE [AgentName] WHEN 'Constructaquote.com' THEN [Income] ELSE 0 END)									AS [WebIncome]
	,SUM(CASE [AgentName] WHEN 'Constructaquote' THEN [Income] ELSE 0 END)										AS [DataIncome]
FROM
	@Data
WHERE
	[Dataset] IN ('Sales', 'Targets')
GROUP BY
	[OriginalSaleAgent]
;

UPDATE @Data
SET  [OtherIncome] = [Income] - [WebIncome] - [DataIncome]
	,[PCofTarget] = [Income] / [TargetAmount]
	,[DifferenceToTarget] = [Income] - [TargetAmount]
WHERE [Dataset] = 'AgentSummary';

WITH [Rankings] AS
(
	SELECT
		 [OriginalSaleAgent]
		,RANK() OVER (PARTITION BY [Dataset] ORDER BY [PCofTarget] DESC) AS [PCRanking]
		,RANK() OVER (PARTITION BY [Dataset] ORDER BY [DifferenceToTarget] DESC) AS [DifferenceRanking]
	FROM
		@Data
	WHERE
		[Dataset] = 'AgentSummary'
		AND [TargetAmount] IS NOT NULL
)
UPDATE [Data]
SET  [PCRanking] = [RNK].[PCRanking]
	,[DifferenceRanking] = [RNK].[DifferenceRanking]
FROM
	@Data AS [Data]
	INNER JOIN [Rankings] AS [RNK] ON [Data].[OriginalSaleAgent] = [RNK].[OriginalSaleAgent]
WHERE
	[Dataset] = 'AgentSummary'
;


-- Return data to the report:
-- (The summary tables show results for all Agents and all sales agents; only the detail table is filtered by these parameters)

SELECT * FROM @Data
WHERE [Dataset] <> 'Sales'
OR ([Dataset] = 'Sales'
	AND ('ALL' IN (@AgentID) OR [AGENT_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@AgentID, ',')))
	AND ('ALL' IN (@LoginName) OR [OriginalSaleAgentLogin] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@LoginName, ',')))
	)

ORDER BY [Dataset], [POLICYNUMBER], [OriginalSaleAgent], [TargetMonthDate], [NB/REN]

GO