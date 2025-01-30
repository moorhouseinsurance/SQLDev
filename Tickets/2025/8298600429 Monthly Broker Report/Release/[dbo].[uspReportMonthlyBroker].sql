USE [MI]
GO


-- =============================================
-- Author:		Jeremai Smith
-- Create date: 27 Jan 2025
-- Description:	Monthly Broker Report
-- =============================================

-- Date			Who						Change

/*
CREATE PROCEDURE [dbo].[uspReportMonthlyBroker]
	@Date datetime
AS
*/
/**/

	DECLARE @Date datetime

	SET @Date = '31 Jan 2025'

	/*EXEC [dbo].[uspReportMonthlyBroker] @Date

*/

DECLARE @MonthStart datetime = @Date - DAY(@Date) +1
DECLARE @PreviousMonthStart datetime = DATEADD(mm,-1,@MonthStart)
DECLARE @NextMonthStart datetime = DATEADD(mm,1,@MonthStart)

;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF OBJECT_ID('tempdb..#ReportData') IS NOT NULL
    DROP TABLE [#ReportData];

CREATE TABLE [#ReportData]
(
	 [DataSet] varchar(50)
	,[SUBAGENT_ID] char(32)
	,[POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
	,[HistoryOrGroupingID] int
	,[PolicyNumber] varchar(30)
	,[ACTION_LOG_ID] char(32)
	,[ACTIONTYPE] int
	,[Action] varchar(50)
	,[ActionDate] datetime
	,[EffectiveDate] datetime
	,[InMonth] bit
	,[ClassifyNBREN] varchar(3)
	,[XBrokerNBREN] varchar(3)
	,[Agent] varchar(50)
	,[QuoteCount] int
	,[SaleRenewalCount] int
	,[SaleRenewalCountAddon] int
	,[SaleRenewalCountTotal] int
	,[GWP] money
	,[Commission] money
	,[AgentCommission] money
	,[Fee] money
	,[Discount] money
	,[DDIncome] money
	,[Income] money
	,[IncomeCore] money
	,[IncomeAddon] money
	,[IncomeInMonth] money
	,[PipelineGWP] money
	,[PipelineIncome] money
	,[MonthlyTarget] money
	,[WorkingDays] tinyint
	,[DailyTarget] money
	,[RenewedThisMonthCount] int
	,[MTDIncome] money
	,[MTDIncomeCore] money
	,[MTDIncomeAddon] money
	,[MTDIncomePCOfTarget] decimal(18,2)
	,[MTDPipelineIncome] money
	,[MTDSaleRenewalCount] int
	,[MTDSaleRenewalCountAddon] int
	,[MTDSaleRenewalCountTotal] int
);


-- ==================
-- Insert detail rows
-- ==================

-- 1. Quote and Sale RALs (logic based on Daily COD Report):

WITH [MDCGrouping] AS -- Works out a pseudo ID for ManualDebitCredit RALs as they attach to the original NB or Renewal Policy history version but could have been entered months later. We use this ID to attach the transactions to the correct date and sale agent later on. ID has to be worked out here instead of in the main SELECT as it needs to work out ROW_NUMBER over all RALs, not just the ones selected for the report date.
(
	SELECT
		[ACTION_LOG_ID]
		,(1000 * [RAL].[HISTORY_ID]) + ROW_NUMBER() OVER(PARTITION BY [RAL].[POLICY_DETAILS_ID], [RAL].[HISTORY_ID], [RAL].[ACTIONTYPE] ORDER BY [RAL].[ACTIONDATE]) AS [MDCGroupingID]
	FROM
		[dbo].[REPORT_ACTION_LOG] AS [RAL]
	WHERE
		[RAL].[ACTIONTYPE] = 42
)
INSERT INTO [#ReportData] (
	 [DataSet]
	,[SUBAGENT_ID]
	,[POLICY_DETAILS_ID]
	,[HISTORY_ID]
	,[HistoryOrGroupingID]
	,[PolicyNumber]
	,[ACTION_LOG_ID]
	,[ACTIONTYPE]
	,[Action]
	,[ActionDate]
	,[EffectiveDate]
	,[ClassifyNBREN]
	,[XBrokerNBREN]
	,[Agent]
	,[QuoteCount]
	,[SaleRenewalCount]
	,[SaleRenewalCountAddon]
	,[SaleRenewalCountTotal]
	,[GWP]
	,[Commission]
	,[AgentCommission]
	,[Fee]
	,[Discount]
	,[Income]
)
SELECT
	 'Quote Sale RALs' AS [DataSet]
	,[CPD].[SUBAGENT_ID]
	,[RAL].[POLICY_DETAILS_ID] 
	,[RAL].[HISTORY_ID]
	,CASE
		WHEN [RAL].[ACTIONTYPE] <> '42' THEN [RAL].[HISTORY_ID]
		ELSE (SELECT [MDCGroupingID] FROM [MDCGrouping] WHERE [RAL].[ACTION_LOG_ID] = [MDCGrouping].[ACTION_LOG_ID])
	 END AS [HistoryOrGroupingID] 
	,[CPD].[POLICYNUMBER] AS [PolicyNumber]
	,[RAL].[ACTION_LOG_ID]
	,[RAL].[ACTIONTYPE]
	,[LALT].[ACTION_LOG_TYPE_DEBUG] AS [Action]
	,[RAL].[ACTIONDATE]
	,CASE
		WHEN [RAL].[ACTIONTYPE] = '42'THEN [RAL].[POLICYSTARTDATE] -- ManualDebitCredit transactions attach to the original NB or Renewal Policy history but could have been entered months later. The POLICYSTARTDATE on the RAL appears to be the effective date the agent enters when keying the ManualDebitCredit.
		ELSE [CPD].[POLICYSTARTDATE]
	 END AS [EffectiveDate]
	,[TVFNBREN].[NB/REN] AS [ClassifyNBREN]
	,[TVFNBREN].[XBrokerNB/REN] AS [XBrokerNBREN]
	,[RMA].[NAME] AS [Agent]
	,CASE WHEN [LALT].[ACTION_LOG_TYPE_DEBUG] = 'Quote' THEN 1 ELSE 0 END AS [QuoteCount]
	,CASE WHEN [LALT].[ACTION_LOG_TYPE_DEBUG] IN ('Policy', 'Renewal', 'Reinstatement') AND [PCA].[CoreAddon] = 'Core' THEN 1 ELSE 0 END AS [SaleRenewalCount]
	,CASE WHEN [LALT].[ACTION_LOG_TYPE_DEBUG] IN ('Policy', 'Renewal', 'Reinstatement') AND [PCA].[CoreAddon] = 'Add-on' THEN 1 ELSE 0 END AS [SaleRenewalCountAddon]
	,CASE WHEN [LALT].[ACTION_LOG_TYPE_DEBUG] IN ('Policy', 'Renewal', 'Reinstatement') THEN 1 ELSE 0 END AS [SaleRenewalCountTotal]
	,NULL AS [GWP] -- Update below
	,NULL AS [Commission] -- Update below
	,NULL AS [AgentCommission] -- Update below
	,NULL AS [Fee] -- Update below
	,NULL AS [Discount] -- Update below
	,NULL AS [Income] -- Update below
FROM
	[dbo].[REPORT_ACTION_LOG] AS [RAL]
		INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [RAL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CPD].[HISTORY_ID]
			LEFT JOIN [dbo].[RM_AGENT] AS [RMA] ON [CPD].[AGENT_ID] = [RMA].[AGENT_ID]
			LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [CPD].[AGENT_ID] = [RMAMH].[AGENT_ID]
			LEFT JOIN [Transactor_Live].[dbo].[ProductCoreAddon] AS [PCA] ON [CPD].[PRODUCT_ID] = [PCA].[PRODUCT_ID]
		INNER JOIN [dbo].[LIST_ACTION_LOG_TYPE] AS [LALT] ON [RAL].[ACTIONTYPE] = [LALT].[ACTION_LOG_TYPE_ID]
		OUTER APPLY [dbo].[tvfClassifyRAL_NB_REN]([RAL].[ACTION_LOG_ID]) AS [TVFNBREN]
		OUTER APPLY (SELECT TOP 1 [RALCXR].[ACTIONTYPE]
					 FROM [dbo].[REPORT_ACTION_LOG] AS [RALCXR]
					 WHERE [RAL].[ACTIONTYPE] = 9 -- Only needed for source Reinstatements
					 AND [RALCXR].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID]
					 AND [RALCXR].[ACTIONTYPE] = 4 -- Cancellation
					 AND [RALCXR].[ACTIONDATE] BETWEEN [RAL].[ACTIONDATE] AND [CPD].[POLICYENDDATE]
					 ) AS [ReinstatementCANX]
		OUTER APPLY (SELECT TOP 1 [RALCXR].[ACTIONTYPE]
					 FROM [dbo].[REPORT_ACTION_LOG] AS [RALCXR]
					 WHERE [RAL].[ACTIONTYPE] IN (2, 5) -- Only needed for source Policy or Renewal
					 AND [RALCXR].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID]
					 AND [RALCXR].[ACTIONTYPE] = 9 -- Reinstatement
					 AND [RALCXR].[ACTIONDATE] BETWEEN [RAL].[ACTIONDATE] AND [CPD].[POLICYENDDATE]
					 ) AS [NBRENReinstatement]
		OUTER APPLY (SELECT TOP 1 [U1].[Forename], [U1].[Surname], [RAL1].[LOGINNAME]
					 FROM [dbo].[REPORT_ACTION_LOG] AS [RAL1]
					 LEFT JOIN [CRM].[dbo].[User] AS [U1] ON [RAL1].[LOGINNAME] = [U1].[TGSLLogin]
					 WHERE [RAL].[ACTIONTYPE] = 42 -- Only needed for source ManualDebitCredits
					 AND [RAL1].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID]
					 AND [RAL1].[ACTIONTYPE] IN ('2', '5', '3') -- Policy, Renewal, MTA
					 AND [RAL1].[ACTIONDATE] <= [RAL].[ACTIONDATE]
					 ORDER BY [RAL1].[ACTIONDATE] DESC
					 ) AS [LatestNBRENMTA] -- Get the agent who performed the latest Policy, Renewal or MTA by date since ManualDebitCredits can attach to an earlier history ID
		OUTER APPLY (SELECT TOP 1 [U1].[Forename], [U1].[Surname], [RAL1].[LOGINNAME]
					 FROM [dbo].[REPORT_ACTION_LOG] AS [RAL1]
					 LEFT JOIN [CRM].[dbo].[User] AS [U1] ON [RAL1].[LOGINNAME] = [U1].[TGSLLogin]
					 WHERE [RAL].[ACTIONTYPE] = 9 -- Only needed for source Reinstatements
					 AND [RAL1].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID]
					 AND [RAL1].[ACTIONTYPE] IN ('2', '5') -- Policy, Renewal
					 AND [RAL1].[ACTIONDATE] <= [RAL].[ACTIONDATE]
					 ORDER BY [RAL1].[ACTIONDATE] DESC
					 ) AS [LatestNBREN] -- Get the agent who performed the latest Policy or Renewal by date as Reinstatements need to be credited to the agent who sold the policy that got cancelled
WHERE
	[RAL].[ACTIONTYPE] IN (1, 2, 3, 5, 9, 42) -- Quote, Policy, MTA, Renewal, Reinstatement, ManualDebitCredit
	AND [CPD].[SUBAGENT_ID] IS NOT NULL -- Subagent data only
	AND [ReinstatementCANX].[ACTIONTYPE] IS NULL -- Exclude Reinstatements that are subsequently cancelled; subquery returns NULL for non-Reinstatement actions
	AND [NBRENReinstatement].[ACTIONTYPE] IS NULL -- Exclude New Business or Renewals that are subsequently reinstated; subquery returns NULL for non-NB/REN actions
	AND NOT ([RAL].[ACTIONTYPE] = 9 AND MONTH([CPD].[POLICYSTARTDATE]) <> MONTH([CPD].[POLICYINCEPTIONDATE])) -- Exclude Reinstatements with new effective month, as the agent will already have been credited with the sale in the original effective month (POLICYINCEPTIONDATE retains the effective date of the latest sale or renewal when reinstatements have a new POLICYSTARTDATE)
	AND [RAL].[ACTIONDATE] >= @PreviousMonthStart AND [RAL].[ACTIONDATE] < @NextMonthStart
	AND [CPD].[SCHEMETABLE_ID] NOT IN (1586, 1589) -- Exclude 'CoPlus - Complimentary Goods In Transit', 'Complimentary Keycare'
	;


WITH [PREMCORRGrouping] AS -- Works out a pseudo ID for PREMCORR and PREMREVE transactions for the ManualDebitCredits RALs as they attach to the original NB or Renewal Policy history version but could have been entered months later. ID has to be worked out here instead of in the main SELECT as it needs to work out ROW_NUMBER over all PREMCORR transactions, not just the ones selected for the report date.
(
	SELECT
		 [AT].[TRANSACTION_ID]
		,(1000 * [ACTL].[POLICY_DETAILS_HISTORY_ID])
			+ ROW_NUMBER() OVER(PARTITION BY [ACTL].[POLICY_DETAILS_ID], [ACTL].[POLICY_DETAILS_HISTORY_ID], [AT].[TRANSACTION_REASON_ID] ORDER BY [AT].[CREATEDDATE]) AS [GroupingID]
	FROM
		[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
			INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
	WHERE
		[AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE')
)
,[Transactions] AS
(
	SELECT
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,CASE
			WHEN [AT].[TRANSACTION_REASON_ID] NOT IN ('PREMCORR', 'PREMREVE') THEN [ACTL].[POLICY_DETAILS_HISTORY_ID]
				ELSE (SELECT [GroupingID] FROM [PREMCORRGrouping] WHERE [TRANSACTION_ID] = [AT].[TRANSACTION_ID])
		 END AS [HistoryOrGroupingID]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] END AS [GWP]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP') THEN [ATB].[AMOUNT] END AS [Commission]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('AGECOMMF','AGECOMMP','AGEDISCF','AGEDISCP') THEN [ATB].[AMOUNT] END AS [AgentCommission]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' THEN [ATB].[AMOUNT] END AS [Fee]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKDISCF','BRKDISCP') THEN [ATB].[AMOUNT] END AS [Discount]
		,CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','BRKDISCF','BRKDISCP','FEE') THEN [ATB].[AMOUNT] END AS [Income]
	FROM
		[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
			INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
			INNER JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
	WHERE
		[AT].[CREATEDDATE] >= @PreviousMonthStart AND [AT].[CREATEDDATE] < @NextMonthStart
		AND NOT ([ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' AND [AT].[TRANSACTION_CODE_ID] = 'REIN' AND [ATB].[AMOUNT] = -75) -- Ignore refund of £75 cancellation fee on reinstatements as cancellation income not included in report
)
,[TransactionsGrouped] AS
(
	SELECT
		 [POLICY_DETAILS_ID]
		,[HistoryOrGroupingID]
		,SUM([GWP]) AS [GWP]
		,SUM([Commission]) AS [Commission]
		,SUM([AgentCommission]) AS [AgentCommission]
		,SUM([Fee]) AS [Fee]
		,SUM([Discount]) AS [Discount]
		,SUM([Income]) AS [Income]
	FROM
		[Transactions]
	GROUP BY
		 [POLICY_DETAILS_ID]
		,[HistoryOrGroupingID]
)
UPDATE [TMP]
SET	 [GWP] = [TG].[GWP]
	,[Commission] = [TG].[Commission]
	,[AgentCommission] = [TG].[AgentCommission]
	,[Fee] = [TG].[Fee]
	,[Discount]	= [TG].[Discount]
	,[Income] = [TG].[Income]
FROM
	[#ReportData] AS [TMP]
	LEFT JOIN [TransactionsGrouped] AS [TG] ON [TMP].[POLICY_DETAILS_ID] = [TG].[POLICY_DETAILS_ID] AND [TMP].[HistoryOrGroupingID] = [TG].[HistoryOrGroupingID]
											AND [TMP].[ACTIONTYPE] <> 1
WHERE
	[DataSet] = 'Quote Sale RALs'
;




-- ===================
-- Insert summary rows
-- ===================




-- =========================
-- Return data to the report
-- =========================

SELECT * FROM [#ReportData];