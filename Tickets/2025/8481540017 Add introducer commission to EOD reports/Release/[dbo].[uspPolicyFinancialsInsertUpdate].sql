USE [MI]
GO
/****** Object:  StoredProcedure [dbo].[uspPolicyFinancialsInsertUpdate]    Script Date: 17/02/2025 09:21:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 13 Aug 2024
-- Description:	Populate PolicyFinancials table for scorecards, etc.
-- =============================================

-- Date			Who						Change
-- 28/10/2024	Jeremai Smith			Include PREMREVE with PREMCORR transaction reason when creating pseudo history ID and attaching ManualDebitCredit transactions,
--										(Monday ticket 7625974294)
-- 29/11/2024	Jeremai Smith			Added EarliestPayMethodIDPerHistGroup and EarliestPayMethodPerHistGroup columns for Qlikview Analysis/Details tab replacement
--										report (Monday ticket 7121497730)
-- 27/12/2024	Jeremai Smith			Added Deposit column for Qlikview Live Book tab replacement report (Monday ticket 7186538203)
-- 17/02/2025	Jeremai Smith			Added introducer commission (Monday.com ticket 8481540017)


ALTER PROCEDURE [dbo].[uspPolicyFinancialsInsertUpdate]
AS

/*

	EXEC [dbo].[uspPolicyFinancialsInsertUpdate]

*/

DECLARE @Rundate datetime = GETDATE()
DECLARE @LastRundate datetime
SELECT @LastRundate = ISNULL([LastRundate], '01 Jan 1900') FROM [dbo].[SQLProcedureLastRunDate] WHERE [JobName] = 'uspPolicyFinancialsInsertUpdate';

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


-- ================================================
-- Identify policy histories with a new transaction
-- ================================================

DECLARE @PolicyHistoryIDs table (
	 [POLICY_DETAILS_ID] char(32)
	,[HISTORY_ID] int
)

INSERT INTO @PolicyHistoryIDs ([POLICY_DETAILS_ID], [HISTORY_ID])
SELECT DISTINCT -- Must be distinct to prevent duplication when joining to the table variable
	 [ACTL].[POLICY_DETAILS_ID]
	,[ACTL].[POLICY_DETAILS_HISTORY_ID]
FROM
	[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
	LEFT JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] WITH (NOLOCK) ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
WHERE
	[AT].[CREATEDDATE] >= @LastRunDate
;


-- =======================================================
-- Create and populate temp table with latest transactions
-- =======================================================

CREATE TABLE [#PolicyFinancials](
	 [POLICY_DETAILS_ID] char(32) NOT NULL
	,[POLICY_DETAILS_HISTORY_ID] int NOT NULL
	,[HistoryOrGroupingID] bigint NOT NULL
	,[EarliestTranCodePerHistGroup] varchar(255)
	,[EarliestPayMethodIDPerHistGroup] varchar(8)
	,[EarliestPayMethodPerHistGroup] varchar(255)
	,[GWP] money
	,[Fee] money
	,[BrokerCommissionFlatRate] money
	,[BrokerCommission] money
	,[BrokerTotalCommission] money
	,[BrokerDiscount] money
	,[BrokerTotalCommissionAndDiscount] money
	,[Income] money
	,[GrossIncomeIncSubagentCommission] money
	,[AgentCommissionFlatRate] money
	,[AgentCommission] money
	,[AgentTotalCommission] money
	,[AgentDiscount] money
	,[AgentTotalCommissionAndDiscount] money
	,[SubAgentCommissionFlatRate] money
	,[SubAgentCommission] money
	,[SubAgentTotalCommission] money
	,[SubAgentDiscount] money
	,[SubAgentTotalCommissionAndDiscount] money
	,[TotalDiscount] money -- There is no Introducer discount type in LIST_TRAN_BREAKDOWN_TYPE
	,[IntroducerCommissionFlatRate] money
	,[IntroducerCommission] money
	,[IntroducerTotalCommission] money
	,[IPT] money
	,[Deposit] money
	,[CP_GWP] money
	,[CP_Fee] money
	,[CP_BrokerCommissionFlatRate] money
	,[CP_BrokerCommission] money
	,[CP_BrokerTotalCommission] money
	,[CP_BrokerDiscount] money
	,[CP_BrokerTotalCommissionAndDiscount] money
	,[CP_Income] money
	,[CP_GrossIncomeIncSubagentCommission] money
	,[CP_AgentCommissionFlatRate] money
	,[CP_AgentCommission] money
	,[CP_AgentTotalCommission] money
	,[CP_AgentDiscount] money
	,[CP_AgentTotalCommissionAndDiscount] money
	,[CP_SubAgentCommissionFlatRate] money
	,[CP_SubAgentCommission] money
	,[CP_SubAgentTotalCommission] money
	,[CP_SubAgentDiscount] money
	,[CP_SubAgentTotalCommissionAndDiscount] money
	,[CP_TotalDiscount] money -- There is no Introducer discount type in LIST_PREMIUM_TYPE
	,[CP_IntroducerCommissionFlatRate] money
	,[CP_IntroducerCommission] money
	,[CP_IntroducerTotalCommission] money
	,[CP_IPT] money
);


WITH [Transactions] AS
(
	SELECT 
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,CASE WHEN [AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE') THEN 1 ELSE 0 END AS [PREMMCORRFlag]
		,CASE WHEN [AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE') THEN [AT].[CREATEDDATE] ELSE 1 END AS [PREMCORRDate]
		,[EarliestAT].[TRANSACTION_CODE_ID]
		,[EarliestAT].[PAYMETHOD_ID] AS [EarliestPayMethodIDPerHistGroup]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [GWP]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END) AS [Fee]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'BRKCOMMF' THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerCommissionFlatRate]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'BRKCOMMP' THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF', 'BRKCOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerTotalCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE 'BRKDISC%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF', 'BRKCOMMP', 'BRKDISCF', 'BRKDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerTotalCommissionAndDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','BRKDISCF','BRKDISCP','FEE') THEN [ATB].[AMOUNT] ELSE 0 END) AS [Income]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','BRKDISCF','BRKDISCP','FEE','SUBCOMMF','SUBCOMMP','SUBDISCF', 'SUBDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [GrossIncomeIncSubagentCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'AGECOMMF' THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentCommissionFlatRate]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'AGECOMMP' THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('AGECOMMF', 'AGECOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentTotalCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('AGEDISCF', 'AGEDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('AGECOMMF', 'AGECOMMP', 'AGEDISCF', 'AGEDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentTotalCommissionAndDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'SUBCOMMF' THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubAgentCommissionFlatRate]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'SUBCOMMP' THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubAgentCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'INTCOMMF' THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubAgentTotalCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('SUBDISCF', 'SUBDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubAgentDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('SUBCOMMF', 'SUBCOMMP', 'SUBDISCF', 'SUBDISCP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubAgentTotalCommissionAndDiscount]
		,SUM(CASE WHEN SUBSTRING([ATB].[TRAN_BREAKDOWN_TYPE_ID], 4, 4) = 'DISC' THEN [ATB].[AMOUNT] ELSE 0 END) AS [TotalDiscount]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'INTCOMMF' THEN [ATB].[AMOUNT] ELSE 0 END) AS [IntroducerCommissionFlatRate]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'INTCOMMP' THEN [ATB].[AMOUNT] ELSE 0 END) AS [IntroducerCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('INTCOMMF', 'INTCOMMP')  THEN [ATB].[AMOUNT] ELSE 0 END) AS [IntroducerTotalCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'TAX_IPT' THEN [ATB].[AMOUNT] ELSE 0 END) AS [IPT]
		,SUM(CASE WHEN [AT].[DEPOSIT] = 1 THEN [ATB].[AMOUNT] ELSE 0 END) AS [Deposit]
	FROM
		[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
			INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
				INNER JOIN @PolicyHistoryIDs AS [ID] ON [ACTL].[POLICY_DETAILS_ID] = [ID].[POLICY_DETAILS_ID] AND [ACTL].[POLICY_DETAILS_HISTORY_ID] = [ID].[HISTORY_ID]
			LEFT JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] as [ATB] ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
			OUTER APPLY (SELECT TOP 1 [AT1].[TRANSACTION_CODE_ID], [AT1].[PAYMETHOD_ID] FROM [dbo].[ACCOUNTS_TRANSACTION] AS [AT1]
						 INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL1] ON [AT1].[TRANSACTION_ID] = [ACTL1].[TRANSACTION_ID]
						 WHERE [ACTL1].[POLICY_DETAILS_ID] = [ACTL].[POLICY_DETAILS_ID]
						 AND [ACTL1].[POLICY_DETAILS_HISTORY_ID] = [ACTL].[POLICY_DETAILS_HISTORY_ID]
						 AND [AT1].[TRANSACTION_CODE_ID] IN  ('XLD','REN','NB','ADD','REIN','RET','XREN','XADD','XRET')
						 AND (([AT1].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE') AND [AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE'))
							  OR [AT].[TRANSACTION_REASON_ID] NOT IN ('PREMCORR', 'PREMREVE'))
						 ORDER BY [AT1].[CREATEDDATE]) AS [EarliestAT] -- Gets the earliest ACCOUNTS_TRANSACTION record for the Policy HistoryOrGroupingID to return what the first Transaction Code was for this history
	WHERE
		[AT].[TRANSACTION_CODE_ID] IN  ('XLD','REN','NB','ADD','REIN','RET','XREN','XADD','XRET')
		--AND POLICY_DETAILS_ID = 'A805FD983F7F4563907F32EC0B96147E'
		--AND [AT].[REFERENCE] = 'GTI01524734'
	GROUP BY
		[ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,CASE WHEN [AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE') THEN 1 ELSE 0 END
		,CASE WHEN [AT].[TRANSACTION_REASON_ID] IN ('PREMCORR', 'PREMREVE') THEN [AT].[CREATEDDATE] ELSE 1 END
		,[EarliestAT].[TRANSACTION_CODE_ID]
		,[EarliestAT].[PAYMETHOD_ID]
)
,[Deposit] AS 
(
	SELECT 
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,SUM([ATB].[AMOUNT]) as [Deposit]
	FROM
		[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
		LEFT JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] WITH (NOLOCK) ON [AT].[TRANSACTION_ID] = [ACTL].[TRANSACTION_ID]
		LEFT JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] as [ATB] WITH (NOLOCK) ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
	WHERE
		[AT].[DEPOSIT] = 1
	GROUP BY
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
)
,[CustomerPremium] AS
(
	SELECT
		 [CP].[POLICY_DETAILS_ID]
		,[CP].[HISTORY_ID]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'NET' THEN [CP].[PREMIUM] ELSE 0 END) AS [GWP]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'FEE' THEN [CP].[PREMIUM] ELSE 0 END) AS [Fee]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'BRKCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [BrokerCommissionFlatRate]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'BRKCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [BrokerCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('BRKCOMMF', 'BRKCOMMP') THEN [CP].[PREMIUM] ELSE 0 END) AS [BrokerTotalCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] LIKE 'BRKDISC%' THEN [CP].[PREMIUM] ELSE 0 END) AS [BrokerDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('BRKCOMMF', 'BRKCOMMP', 'BRKDISCF', 'BRKDISCP') THEN [CP].[PREMIUM] ELSE 0 END) AS [BrokerTotalCommissionAndDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','BRKDISCF','BRKDISCP','FEE') THEN [CP].[PREMIUM] ELSE 0 END) AS [Income]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP','BRKDISCF','BRKDISCP','FEE','SUBCOMMF','SUBCOMMP','SUBDISCF', 'SUBDISCP') THEN [CP].[PREMIUM] ELSE 0 END) as [GrossIncomeIncSubagentCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'AGECOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [AgentCommissionFlatRate]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'AGECOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [AgentCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('AGECOMMF', 'AGECOMMP') THEN [CP].[PREMIUM] ELSE 0 END) as [AgentTotalCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('AGEDISCF', 'AGEDISCP') THEN [CP].[PREMIUM] ELSE 0 END) as [AgentDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('AGECOMMF', 'AGECOMMP', 'AGEDISCF', 'AGEDISCP') THEN [CP].[PREMIUM] ELSE 0 END) as [AgentTotalCommissionAndDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'SUBCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [SubAgentCommissionFlatRate]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'SUBCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [SubAgentCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('SUBCOMMF', 'SUBCOMMP') THEN [CP].[PREMIUM] ELSE 0 END) as [SubAgentTotalCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('SUBDISCF', 'SUBDISCP') THEN [CP].[PREMIUM] ELSE 0 END) as [SubAgentDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('SUBCOMMF', 'SUBCOMMP', 'SUBDISCF', 'SUBDISCP') THEN [CP].[PREMIUM] ELSE 0 END) as [SubAgentTotalCommissionAndDiscount]
		,SUM(CASE WHEN SUBSTRING([CP].[PREMIUM_TYPE_ID], 4, 4) = 'DISC' THEN [CP].[PREMIUM] ELSE 0 END) as [TotalDiscount]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'INTCOMMF' THEN [CP].[PREMIUM] ELSE 0 END) AS [IntroducerCommissionFlatRate]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'INTCOMMP' THEN [CP].[PREMIUM] ELSE 0 END) AS [IntroducerCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] IN ('INTCOMMF', 'INTCOMMP')  THEN [CP].[PREMIUM] ELSE 0 END) AS [IntroducerTotalCommission]
		,SUM(CASE WHEN [CP].[PREMIUM_TYPE_ID] = 'TAX_IPT' THEN [CP].[PREMIUM] ELSE 0 END) AS [IPT]
	FROM
		[dbo].[CUSTOMER_PREMIUM] AS [CP]
	GROUP BY 
		 [CP].[POLICY_DETAILS_ID]
		,[CP].[HISTORY_ID]
)
INSERT INTO [dbo].[#PolicyFinancials](
	 [POLICY_DETAILS_ID]
	,[POLICY_DETAILS_HISTORY_ID]
	,[HistoryOrGroupingID]
	,[EarliestTranCodePerHistGroup]
	,[EarliestPayMethodIDPerHistGroup]
	,[EarliestPayMethodPerHistGroup]
	,[GWP]
	,[Fee]
	,[BrokerCommissionFlatRate]
	,[BrokerCommission]
	,[BrokerTotalCommission]
	,[BrokerDiscount]
	,[BrokerTotalCommissionAndDiscount]
	,[Income]
	,[GrossIncomeIncSubagentCommission]
	,[AgentCommissionFlatRate]
	,[AgentCommission]
	,[AgentTotalCommission]
	,[AgentDiscount]
	,[AgentTotalCommissionAndDiscount]
	,[SubAgentCommissionFlatRate]
	,[SubAgentCommission]	
	,[SubAgentTotalCommission]
	,[SubAgentDiscount]
	,[SubAgentTotalCommissionAndDiscount]
	,[TotalDiscount]
	,[IntroducerCommissionFlatRate]
	,[IntroducerCommission]
	,[IntroducerTotalCommission]
	,[IPT]
	,[Deposit]
	,[CP_GWP]
	,[CP_Fee]
	,[CP_BrokerCommissionFlatRate]
	,[CP_BrokerCommission]
	,[CP_BrokerTotalCommission]
	,[CP_BrokerDiscount]
	,[CP_BrokerTotalCommissionAndDiscount]
	,[CP_Income]
	,[CP_GrossIncomeIncSubagentCommission]
	,[CP_AgentCommissionFlatRate]
	,[CP_AgentCommission]
	,[CP_AgentTotalCommission]
	,[CP_AgentDiscount]
	,[CP_AgentTotalCommissionAndDiscount]
	,[CP_SubAgentCommissionFlatRate]
	,[CP_SubAgentCommission]
	,[CP_SubAgentTotalCommission]
	,[CP_SubAgentDiscount]
	,[CP_SubAgentTotalCommissionAndDiscount]
	,[CP_TotalDiscount]
	,[CP_IntroducerCommissionFlatRate]
	,[CP_IntroducerCommission]
	,[CP_IntroducerTotalCommission]
	,[CP_IPT]
)
SELECT 
	 [T].[POLICY_DETAILS_ID]
	,[T].[POLICY_DETAILS_HISTORY_ID]
	,CASE
		WHEN [T].[PREMMCORRFlag] <> 1 THEN [T].[POLICY_DETAILS_HISTORY_ID]
			ELSE (1000 * [T].[POLICY_DETAILS_HISTORY_ID]) + ROW_NUMBER() OVER(PARTITION BY [T].[POLICY_DETAILS_ID], [T].[POLICY_DETAILS_HISTORY_ID], [T].[PREMMCORRFlag] ORDER BY [T].[PREMCORRDate])
		END AS [HistoryOrGroupingID] -- PREMCORR / PREMEVE transactions for ManualDebitCredit are grouped separately from History ID since they can attach to an earlier history ID but need to be reported later
	,[LTC].[TRANSACTION_CODE_DEBUG] AS [EarliestTranCodePerHistGroup]
	,[T].[EarliestPayMethodIDPerHistGroup]
	,[LPM].[PAYMETHOD_DEBUG] AS [EarliestPayMethodPerHistGroup]
	,[T].[GWP]
	,[T].[Fee]
	,[T].[BrokerCommissionFlatRate]
	,[T].[BrokerCommission]
	,[T].[BrokerTotalCommission]
	,[T].[BrokerDiscount]
	,[T].[BrokerTotalCommissionAndDiscount]
	,[T].[Income]
	,[T].[GrossIncomeIncSubagentCommission]
	,[T].[AgentCommissionFlatRate]
	,[T].[AgentCommission]
	,[T].[AgentTotalCommission]
	,[T].[AgentDiscount]
	,[T].[AgentTotalCommissionAndDiscount]
	,[T].[SubAgentCommissionFlatRate]
	,[T].[SubAgentCommission]
	,[T].[SubAgentTotalCommission]
	,[T].[SubAgentDiscount]
	,[T].[SubAgentTotalCommissionAndDiscount]
	,[T].[TotalDiscount]
	,[T].[IntroducerCommissionFlatRate]
	,[T].[IntroducerCommission]
	,[T].[IntroducerTotalCommission]
	,[T].[IPT]
	,[DEP].[Deposit]
	,[CP].[GWP] AS [CP_GWP]
	,[CP].[Fee] AS [CP_Fee]
	,[CP].[BrokerCommissionFlatRate] AS [CP_BrokerCommissionFlatRate]
	,[CP].[BrokerCommission] AS [CP_BrokerCommission]
	,[CP].[BrokerTotalCommission] AS [CP_BrokerTotalCommission]
	,[CP].[BrokerDiscount] AS [CP_MHDiscount]
	,[CP].[BrokerTotalCommissionAndDiscount] AS [CP_BrokerTotalCommissionAndDiscount]
	,[CP].[Income] AS [CP_Income]
	,[CP].[GrossIncomeIncSubagentCommission] AS [CP_GrossIncomeIncSubagentCommission]
	,[CP].[AgentCommissionFlatRate] AS [CP_AgentCommissionFlatRate]
	,[CP].[AgentCommission] AS [CP_AgentCommission]
	,[CP].[AgentTotalCommission] AS [CP_AgentTotalCommission]
	,[CP].[AgentDiscount] AS [CP_AgentDiscount]
	,[CP].[AgentTotalCommissionAndDiscount] AS [CP_AgentTotalCommissionAndDiscount]
	,[CP].[SubAgentCommissionFlatRate] AS [CP_SubAgentCommissionFlatRate]
	,[CP].[SubAgentCommission] AS [CP_SubAgentCommission]
	,[CP].[SubAgentTotalCommission] AS [CP_SubAgentTotalCommission]
	,[CP].[SubAgentDiscount] AS [CP_SubAgentDiscount]
	,[CP].[SubAgentTotalCommissionAndDiscount] AS [CP_SubAgentTotalCommissionAndDiscount]
	,[CP].[TotalDiscount] AS [CP_TotalDiscount]
	,[CP].[IntroducerCommissionFlatRate] AS [CP_IntroducerCommissionFlatRate]
	,[CP].[IntroducerCommission] AS [CP_IntroducerCommission]
	,[CP].[IntroducerTotalCommission] AS [CP_IntroducerTotalCommission]
	,[CP].[IPT] AS [CP_IPT]
FROM
	[Transactions] AS [T]
	LEFT JOIN [Deposit] AS [DEP] ON [T].[POLICY_DETAILS_ID] = [DEP].[POLICY_DETAILS_ID] AND [T].[POLICY_DETAILS_HISTORY_ID] = [DEP].[POLICY_DETAILS_HISTORY_ID]
	LEFT JOIN [CustomerPremium] AS [CP] ON [T].[POLICY_DETAILS_ID] = [CP].[Policy_Details_ID] AND [T].[POLICY_DETAILS_HISTORY_ID] = [CP].[HISTORY_ID]
	LEFT JOIN [dbo].[LIST_TRANSACTION_CODE] AS [LTC] ON [T].[TRANSACTION_CODE_ID] = [LTC].[TRANSACTION_CODE_ID] -- Synonym pointing to Transactor_Live
	LEFT JOIN [dbo].[LIST_PAYMETHOD] AS [LPM] ON [T].[EarliestPayMethodIDPerHistGroup] = [LPM].[PAYMETHOD_ID] -- Synonym pointing to Transactor_Live
;


-- ======================================
-- Delete and replace rows in final table
-- ======================================

DELETE [PF]
FROM [dbo].[PolicyFinancials] AS [PF]
INNER JOIN @PolicyHistoryIDs AS [ID] ON [PF].[POLICY_DETAILS_ID] = [ID].[POLICY_DETAILS_ID] AND [PF].[POLICY_DETAILS_HISTORY_ID] = [ID].[HISTORY_ID]
;

INSERT INTO [dbo].[PolicyFinancials](
	 [POLICY_DETAILS_ID]
	,[POLICY_DETAILS_HISTORY_ID]
	,[HistoryOrGroupingID]
	,[EarliestTranCodePerHistGroup]
	,[EarliestPayMethodIDPerHistGroup]
	,[EarliestPayMethodPerHistGroup]
	,[GWP]
	,[Fee]
	,[BrokerCommissionFlatRate]
	,[BrokerCommission]
	,[BrokerTotalCommission]
	,[BrokerDiscount]
	,[BrokerTotalCommissionAndDiscount]
	,[Income]
	,[GrossIncomeIncSubagentCommission]
	,[AgentCommissionFlatRate]
	,[AgentCommission]
	,[AgentTotalCommission]
	,[AgentDiscount]
	,[AgentTotalCommissionAndDiscount]
	,[SubAgentCommissionFlatRate]
	,[SubAgentCommission]	
	,[SubAgentTotalCommission]
	,[SubAgentDiscount]
	,[SubAgentTotalCommissionAndDiscount]
	,[TotalDiscount]
	,[IntroducerCommissionFlatRate]
	,[IntroducerCommission]
	,[IntroducerTotalCommission]
	,[IPT]
	,[Deposit]
	,[CP_GWP]
	,[CP_Fee]
	,[CP_BrokerCommissionFlatRate]
	,[CP_BrokerCommission]
	,[CP_BrokerTotalCommission]
	,[CP_BrokerDiscount]
	,[CP_BrokerTotalCommissionAndDiscount]
	,[CP_Income]
	,[CP_GrossIncomeIncSubagentCommission]
	,[CP_AgentCommissionFlatRate]
	,[CP_AgentCommission]
	,[CP_AgentTotalCommission]
	,[CP_AgentDiscount]
	,[CP_AgentTotalCommissionAndDiscount]
	,[CP_SubAgentCommissionFlatRate]
	,[CP_SubAgentCommission]
	,[CP_SubAgentTotalCommission]
	,[CP_SubAgentDiscount]
	,[CP_SubAgentTotalCommissionAndDiscount]
	,[CP_TotalDiscount]
	,[CP_IntroducerCommissionFlatRate]
	,[CP_IntroducerCommission]
	,[CP_IntroducerTotalCommission]
	,[CP_IPT]
)
SELECT 
	 [POLICY_DETAILS_ID]
	,[POLICY_DETAILS_HISTORY_ID]
	,[HistoryOrGroupingID]
	,[EarliestTranCodePerHistGroup]
	,[EarliestPayMethodIDPerHistGroup]
	,[EarliestPayMethodPerHistGroup]
	,[GWP]
	,[Fee]
	,[BrokerCommissionFlatRate]
	,[BrokerCommission]
	,[BrokerTotalCommission]
	,[BrokerDiscount]
	,[BrokerTotalCommissionAndDiscount]
	,[Income]
	,[GrossIncomeIncSubagentCommission]
	,[AgentCommissionFlatRate]
	,[AgentCommission]
	,[AgentTotalCommission]
	,[AgentDiscount]
	,[AgentTotalCommissionAndDiscount]
	,[SubAgentCommissionFlatRate]
	,[SubAgentCommission]	
	,[SubAgentTotalCommission]
	,[SubAgentDiscount]
	,[SubAgentTotalCommissionAndDiscount]
	,[TotalDiscount]
	,[IntroducerCommissionFlatRate]
	,[IntroducerCommission]
	,[IntroducerTotalCommission]
	,[IPT]
	,[Deposit]
	,[CP_GWP]
	,[CP_Fee]
	,[CP_BrokerCommissionFlatRate]
	,[CP_BrokerCommission]
	,[CP_BrokerTotalCommission]
	,[CP_BrokerDiscount]
	,[CP_BrokerTotalCommissionAndDiscount]
	,[CP_Income]
	,[CP_GrossIncomeIncSubagentCommission]
	,[CP_AgentCommissionFlatRate]
	,[CP_AgentCommission]
	,[CP_AgentTotalCommission]
	,[CP_AgentDiscount]
	,[CP_AgentTotalCommissionAndDiscount]
	,[CP_SubAgentCommissionFlatRate]
	,[CP_SubAgentCommission]
	,[CP_SubAgentTotalCommission]
	,[CP_SubAgentDiscount]
	,[CP_SubAgentTotalCommissionAndDiscount]
	,[CP_TotalDiscount]
	,[CP_IntroducerCommissionFlatRate]
	,[CP_IntroducerCommission]
	,[CP_IntroducerTotalCommission]
	,[CP_IPT]
FROM
	[#PolicyFinancials]
;


UPDATE [dbo].[SQLProcedureLastRunDate]
SET [LastRundate] = @Rundate
WHERE [JobName] = 'uspPolicyFinancialsInsertUpdate';