USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportToledoPIBord_test]    Script Date: 20/02/2025 15:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspReportToledoPIBord_test]
	 @StartDate datetime
	,@EndDate datetime

AS

-- ==============================================
-- Author:		Simon Mackness-Pettit
-- Create date: 06 Nov 2024
-- Description:	Toledo Insurance Solutions Professional Indemnity
-- ==============================================

-- Date			Who						Change
-- 20/02/2025	Simon					Added Parent/Child columns (8526548143)

/*
	DECLARE @StartDate datetime = '01 May 2024'
	DECLARE @EndDate datetime = '31 May 2024'

	EXEC [dbo].[uspReportToledoPIBord] @StartDate, @EndDate
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF CONVERT(VARCHAR(12), @EndDate, 114) = '00:00:00:000'
	SET @EndDate = DATEADD(DAY, 1, @EndDate);

;WITH [Transactions] AS
(
	SELECT
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,[AT].[TRANSACTION_ID]
		,[AT].[CREATEDDATE] AS [TransactionDate]
		,[AT].[TRANSACTION_CODE_ID]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [GrossPremiumExcIPT]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'TAX_IPT' THEN [ATB].[AMOUNT] ELSE 0 END) AS [IPT]			
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('NET', 'TAX_IPT') THEN [ATB].[AMOUNT] ELSE 0 END) AS [GrossPremiumIncIPT]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] LIKE '%COMM%' THEN [ATB].[AMOUNT] ELSE 0 END) AS [TotalCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('AGECOMMF','AGECOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [AgentCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [BrokerCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('INTCOMMF','INTCOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [IntroducerCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('SUBCOMMF','SUBCOMMP') THEN [ATB].[AMOUNT] ELSE 0 END) AS [SubagentCommission]
		,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END) AS [OtherDeductions]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] IN ('TOOLPREM', 'PLMTPREM', 'PLMAPREM') AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [ToolsPlantPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'MONEPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [MoneyPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'HIPLPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [HiredPlantPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'CWRKPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [ContractWorksPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'FXMCPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [FixedMachineryPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'EMPLPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [EL Premium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'LIABPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [PL Premium]
	FROM 
		[dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL]
		JOIN [dbo].[ACCOUNTS_TRANSACTION] AS [AT] ON [ACTL].[TRANSACTION_ID] = [AT].[TRANSACTION_ID]
		JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [AT].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
	WHERE
		[ATB].[POLICY_SECTION_ID] <> '0'
		AND [AT].[TRANSACTION_CODE_ID] IN ('NB','REN','REIN','XLD','XREN','XADD','ADD','RET')
	GROUP BY 
		 [ACTL].[POLICY_DETAILS_ID]
		,[ACTL].[POLICY_DETAILS_HISTORY_ID]
		,[AT].[TRANSACTION_ID]
		,[AT].[CREATEDDATE]
		,[AT].[TRANSACTION_CODE_ID]
)

SELECT
	'ABE2300080' AS [Contract Reference]
	,CASE
		WHEN [RMAMH].[XBroker] = 1 THEN [RMSA].[NAME] -- For XBroker, show the sub agent name
		ELSE [RMA].[NAME]
	 END AS [Intermediary]
	,REPLACE([RMS].[NAME], ' BXB ', ' ') AS [Scheme Name]
	,[CPD].[POLICYNUMBER] AS [Policy Number] 
	,[dbo].[svfPolicyTransactionVersion]([RAL].[POLICY_DETAILS_ID], [RAL].[HISTORY_ID], [T].[TRANSACTION_CODE_ID]) AS [Policy Number Version] -- Need to count the number of transaction versions including those previously reported (this is different to the Policy History ID as some histories have no transactions while others have multiple) so this is done by external function since joining to a CTE would restrict to only those rows in the report
	,CASE
		WHEN [T].[TRANSACTION_CODE_ID] IN ('NB') THEN 'Policy - New Business'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('REN') THEN 'Policy - Renewal'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('XLD','XREN','XADD') THEN 'Cancelled'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('REIN') THEN 'Reinstated'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('ADD', 'RET') THEN 'Policy - Mid Term Adjustment'
		WHEN [T].[GrossPremiumIncIPT] IS NULL THEN 'Adjustment'
	 END AS [Transaction Type]
	,'UK' AS [Insured Domiciled Country]
	,CASE [CIP].[COMPANY] WHEN 1 THEN 'Company' ELSE 'Individual' END AS [Individual/Company]
	,'Professional Indemnity' AS [Product]
	,'Professional Indemnity' AS [Sub Product]
	,COALESCE	(
					CASE WHEN [CIP].[COMPANY] = 1 THEN [CIP].[COMPANYCONTACTNAME] END
					,CASE WHEN [CIP].[COMPANY] = 0 THEN ISNULL([LT].[TITLE_DEBUG] + ' ','') + ISNULL([CIP].[FORENAME] + ' ','')  + ISNULL([CIP].[SURNAME],'') ELSE [CIP].[SURNAME] END
					,''
				) AS [Insured Name]
	,CASE WHEN [CIP].[COMPANY] = 1 THEN ISNULL([CIP].[SURNAME]  ,'') ELSE '' END AS [Trading Name]
	,[PI_Details].[ERNREF] AS [Employer Reference Number]
	,CASE
		WHEN [PI_Details].[ERNEXEMPT] = 1 THEN 'Yes'
		Else NULL
	END AS [ERNExempt Flag]
	,CASE [CIP].[COMPANY] WHEN 1 THEN 'Limited' ELSE 'Individual' END AS [Company Status]
	,[PI_Trade].[MH_TRADE_DEBUG] AS [Primary Trade Description]
	,[PI_Details].[TURNOVER] AS [Turnover/Fee Income]
	,REPLACE	(
					CASE WHEN ISNUMERIC([HOUSE]) = 1 THEN [HOUSE] + ' ' + [STREET] ELSE ISNULL([HOUSE], '') END
					+ CASE WHEN ISNUMERIC([HOUSE]) = 1 THEN '' ELSE CASE WHEN ISNULL([STREET], '') = '' THEN '' ELSE ', ' + [STREET] END END
					+ CASE WHEN ISNULL([LOCALITY], '') = '' THEN '' ELSE ', ' + [LOCALITY] END
					+ CASE WHEN ISNULL([CITY], '') = '' THEN '' ELSE ', ' + [CITY] END
					+ CASE WHEN ISNULL([COUNTY], '') = '' THEN '' ELSE ', ' + [COUNTY] END	
					, ',,', ''
				) AS [Risk Address]
	,'UK' AS [Risk Address Country]
	,UPPER([CCA].[POSTCODE]) AS [Risk Postcode]
	,'GBP' AS [Settlement Currency]
	,[CPD].[POLICYINCEPTIONDATE] AS [Inception Date]
	,CASE
		WHEN [T].[TRANSACTION_CODE_ID] IN ('XLD','XREN','XADD') THEN [CPD].[CANCELLATIONDATE]
		ELSE [CPD].[POLICYSTARTDATE]
	 END AS [Effective Date]
	,[CPD].[POLICYENDDATE] AS [Expiry Date]
	,[T].[TransactionDate] AS [Transaction Date]
	,DATEDIFF(dd, [CPD].[POLICYSTARTDATE], [CPD].[POLICYENDDATE]) AS [Indemnity Period]
	,ISNULL(STUFF(  -- Stuff gets rid of the redundant first comma
					(
						SELECT
						 ',' + ISNULL([End].[ENDORSEMENT_CODE_ID], LTRIM(RTRIM([End].[ENDORSEMENT_ID])))
						FROM 
							[dbo].[CUSTOMER_ENDORSEMENT] AS [E]
						INNER JOIN
							[dbo].[LIST_ENDORSEMENT] AS [End] ON [E].[ENDORSEMENT_CODE_ID] = [End].ENDORSEMENT_ID
						WHERE 
							[RAL].[POLICY_DETAILS_ID] = [E].[POLICY_DETAILS_ID]
						AND
							[RAL].[HISTORY_ID] = [E].[HISTORY_ID]
						FOR XML PATH('')
					) ,1,1,''),'') AS [Endorsement Codes]
	,[T].[GrossPremiumExcIPT] AS [Total Gross Premium]
	,[T].[GrossPremiumExcIPT] - [T].[TotalCommission] AS [Net Rate]
	,[T].[TotalCommission] AS [Total Commission]
	,CASE
		WHEN [RMAMH].[XBroker] = 1 THEN ISNULL([T].[SubagentCommission], 0)
		ELSE ISNULL([T].[BrokerCommission], 0) + ISNULL([T].[IntroducerCommission], 0)
	 END AS [Intermediary Commission]
	,[T].[IPT] AS [Total IPT]
	,[T].[GrossPremiumIncIPT] - [T].[TotalCommission] AS [Total Payable To Insurer]
	,[PI_Cover].[MH_COVER_DEBUG] AS [Aggregtae/ Any One Claim?]
	,[PI_Limit].[MH_INDEMNITY_DEBUG] AS [PI Limit]
	,[T].[GrossPremiumExcIPT] AS [PI Premium]
	,[T].[EL Premium] AS [EL Premium]
	,CASE
		WHEN [PI_Details].[EMPLIAB] = 1 THEN '£10,000,000'
		ELSE NULL
	END AS [Limit Of Indemnity EL]
	,[T].[PL Premium] AS [PL Premium]
	,[PI_PL_Limit].[MH_LIABLIMIT_DEBUG] AS [Limit Of Indemnity PL]
	,[PI_Workers].[MH_PA_NUMEMP_DEBUG] AS [No Of Workers, Including Principles And Partners]
	,CASE WHEN [RAL].[ACTIONTYPE] = 4 THEN [LCR].[CANCEL_REASON_DEBUG] END AS [Cancellation Reason]
	,CASE WHEN [RAL].[ACTIONTYPE] = 3 THEN [LMTA].[MTAADJUSTMENTTYPE_DEBUG]	END AS [MTA Reason]
	,CASE WHEN [PI_Details].[EMPLIAB] = 1 THEN 'P' ELSE NULL END AS [Parent/Child]
FROM 
	[dbo].[REPORT_ACTION_LOG] AS [RAL]
LEFT JOIN
	[dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [CPD].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID] and [CPD].[HISTORY_ID] = [RAL].[HISTORY_ID]
LEFT JOIN
	[dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [CPD].[AGENT_ID] = [RMAMH].[AGENT_ID]
LEFT JOIN
	[dbo].[RM_SUBAGENT] AS [RMSA] ON [CPD].[SUBAGENT_ID] = [RMSA].[SUBAGENT_ID]
LEFT JOIN
	[dbo].[RM_AGENT] AS [RMA] ON [CPD].[AGENT_ID] = [RMA].[AGENT_ID]
LEFT JOIN
	[dbo].[RM_SCHEME] AS [RMS] ON [CPD].[SCHEMETABLE_ID] = [RMS].[SCHEMETABLE_ID]
INNER JOIN
	[Transactions] AS [T] ON [RAL].[POLICY_DETAILS_ID] = [T].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [T].[POLICY_DETAILS_HISTORY_ID] -- Inner join as actions with no transaction do not need to be reported per Sarah
AND
	[RAL].[ACTIONTYPE] =	CASE [T].[TRANSACTION_CODE_ID]
								WHEN 'NB' THEN 2 -- Policy
								WHEN 'ADD' THEN 3 -- MTA
								WHEN 'RET' THEN 3 -- MTA
								WHEN 'XLD' THEN 4 -- Cancellation
								WHEN 'XADD' THEN 47 -- UndoMTA
								WHEN 'XRET' THEN 47 -- UndoMTA
								WHEN 'REN' THEN 5 -- Renewal
								WHEN 'XREN' THEN 51 -- UndoRenewal
								WHEN 'REIN' THEN 9 -- Reinstatement
							END
LEFT JOIN
	[dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID]
AND
	[CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
LEFT JOIN
	[dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID]
AND
	[CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
LEFT JOIN
	[dbo].[CUSTOMER_CLIENT_ADDRESS] AS [CCA] ON [CIP].[INSURED_PARTY_ID] = [CCA].[INSURED_PARTY_ID]
AND
	[CIP].[HISTORY_ID] = [CCA].[HISTORY_ID]
LEFT JOIN
	[dbo].[USER_MPROIND_CLIENTDT] AS [PI_Details] ON [CPD].[POLICY_DETAILS_ID] = [PI_Details].[POLICY_DETAILS_ID]
AND
	[CPD].[HISTORY_ID] = [PI_Details].[HISTORY_ID]
LEFT JOIN
	[dbo].[LIST_MH_TRADE] AS [PI_Trade] ON [PI_Details].[RISKTRADE_ID] = [PI_Trade].[MH_TRADE_ID]
LEFT JOIN
	[dbo].[LIST_MH_COVER] AS [PI_Cover] ON [PI_Details].[COVERTYPE_ID] = [PI_Cover].[MH_COVER_ID]
LEFT JOIN
	[dbo].[LIST_MH_INDEMNITY] AS [PI_Limit] ON [PI_Details].[LIMITOFINDEM_ID] = [PI_Limit].[MH_INDEMNITY_ID]
LEFT JOIN
	[dbo].[LIST_MH_LIABLIMIT] AS [PI_PL_Limit] ON [PI_Details].[PUBLIABCOVER_ID] = [PI_PL_Limit].[MH_LIABLIMIT_ID]
LEFT JOIN
	[dbo].[LIST_MH_PA_NUMEMP] AS [PI_Workers] ON [PI_Details].[EMPSANDDIREC_ID] = [PI_Workers].[MH_PA_NUMEMP_ID]
LEFT JOIN
	[dbo].[LIST_TITLE] AS [LT] ON [CIP].[TITLE_ID] = [LT].[TITLE_ID]
LEFT JOIN
	[dbo].[LIST_CANCEL_REASON] AS [LCR] ON [CPD].[CANCELLATION_REASON_ID] = [LCR].[CANCEL_REASON_ID]
LEFT JOIN
	[dbo].[CUSTOMER_MTAADJUSTMENT] AS [CMTA] ON [CPD].[POLICY_DETAILS_ID] = [CMTA].[POLICY_DETAILS_ID]
AND
	[CPD].[HISTORY_ID] = [CMTA].[HISTORY_ID]
LEFT JOIN
	[dbo].[LIST_MTAADJUSTMENTTYPE] AS [LMTA] ON [CMTA].[MTAADJUSTMENTTYPE_ID] = [LMTA].[MTAADJUSTMENTTYPE_ID]
WHERE 
	[CPD].[INSURER_ID] = 'TOLEDO'
AND
	[CPD].[SCHEMETABLE_ID] IN (1610, 1599) --Toledo Insurance Solutions BXB Liability XS Layer, Toledo Insurance Solutions Liability XS Layer
AND
	[CPD].[PRODUCT_ID] = '4318A62733AD444DBBA0AB2A586D5021' --Professional Indemnity
AND
	[RAL].[ACTIONTYPE] IN (2, 3, 4, 5, 9, 47, 51) -- Policy, MTA, Cancellation, Renewal, Reinstatement, UndoMTA, UndoRenewal
AND
	[RAL].[ACTIONDATE] >= @StartDate
AND
	[RAL].[ACTIONDATE] < @EndDate
AND
	[CIP].[ClientYn] = 1
ORDER BY
	 [CPD].[POLICYNUMBER]
	,[RAL].[HISTORY_ID];

