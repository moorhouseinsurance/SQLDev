USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportToledoLiabilityBord_test]    Script Date: 20/02/2025 15:08:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[uspReportToledoLiabilityBord_test]
	 @StartDate datetime
	,@EndDate datetime

AS

-- ==============================================
-- Author:		Jeremai Smith
-- Create date: 22 Apr 2024
-- Description:	Combined Toledo Tradesman, Small Business, Turnover and CAR bordereau based on Tokio Marine Tradesman Bordereau
-- ==============================================

-- Date			Who						Change
-- 23/05/2024	Jeremai Smith			Changed PolicyNumberVersion column to use new function svfPolicyTransactionVersion developed for the Commercial bord as discovered
--										same history ID can have multiple transaction types that need a separate version number of the report (e.g. REN and XREN) so can't
--										just count prior history IDs (Monday.com ticket 669555834)
-- 15/07/2024	Jeremai Smith			Use cancellation date for the effective date column on cancellations (Monday ticket 7023855489)
-- 17/07/2024	Jeremai Smith			Replaced hard coded XBroker Agent ID with join to new RM_AGENT_MH_TYPE table so Blink is included (Monday ticket 6996624659)
-- 22/07/2024	Jeremai Smith			Include Fixed Machinery in the PL premium (Monday ticket 7049540578)
-- 20/02/2025	Simon					Added Parent/Child columns (8526548143)

/*
	DECLARE @StartDate datetime = '01 May 2024'
	DECLARE @EndDate datetime = '31 May 2024'

	EXEC [dbo].[uspReportToledoLiabilityBord] @StartDate, @EndDate
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF CONVERT(VARCHAR(12), @EndDate, 114) = '00:00:00:000'
	SET @EndDate = DATEADD(DAY, 1, @EndDate);

WITH [Transactions] AS
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
	 [RAL].[POLICY_DETAILS_ID]
	,[RAL].[HISTORY_ID]
	,'ABE2300080'																								AS [ContractReference]
	,CASE
		WHEN [RMAMH].[XBroker] = 1 THEN [RMSA].[NAME] -- For XBroker, show the sub agent name
		ELSE [RMA].[NAME]
	 END																										AS [Intermediary]
	,REPLACE([RMS].[NAME], ' BXB ', ' ')																		AS [SchemeName]
	,[CPD].[POLICYNUMBER]																						AS [PolicyNumber] 
	,[dbo].[svfPolicyTransactionVersion]([RAL].[POLICY_DETAILS_ID], [RAL].[HISTORY_ID], [T].[TRANSACTION_CODE_ID]) AS [PolicyNumberVersion] -- Need to count the number of transaction versions including those previously reported (this is different to the Policy History ID as some histories have no transactions while others have multiple) so this is done by external function since joining to a CTE would restrict to only those rows in the report
	,CASE
		WHEN [T].[TRANSACTION_CODE_ID] IN ('NB') THEN 'Policy - New Business'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('REN') THEN 'Policy - Renewal'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('XLD','XREN','XADD') THEN 'Cancelled'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('REIN') THEN 'Reinstated'
		WHEN [T].[TRANSACTION_CODE_ID] IN ('ADD', 'RET') THEN 'Policy - Mid Term Adjustment'
		WHEN [T].[GrossPremiumIncIPT] IS NULL THEN 'Adjustment'
	 END																										AS [TransactionType]
	,'UK'																										AS [InsuredDomiciledCountry]
	,CASE [CIP].[COMPANY] WHEN 1 THEN 'Company' ELSE 'Individual' END											AS [Individual/Company]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' THEN 'Unoccupied Property' -- Property Owners
		WHEN [CPD].[PRODUCT_ID] = 'B39873D2146C466D8C00B21D1104D5DC' THEN 'Small Business and Consultants Liability ' -- Small Business & Consultants Liability 
		WHEN [CPD].[PRODUCT_ID] = 'A5ECDB30B22942BF8BD53F4586B08055' THEN 'Excess of Loss' -- Liability XS Layer
		WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' THEN 'Combined Liability' -- Turnover
		ELSE [RMP].[NAME]
	 END																										AS [Product]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'B39873D2146C466D8C00B21D1104D5DC' THEN 'Small Business and Consultants Liability ' -- Small Business & Consultants Liability 
		ELSE [RMP].[NAME]
	 END																										AS [SubProduct]
	,COALESCE(CASE WHEN [CIP].[COMPANY] = 1 THEN [CIP].[COMPANYCONTACTNAME] END
			  ,CASE WHEN [CIP].[COMPANY] = 0 THEN ISNULL([LT].[TITLE_DEBUG] + ' ','') + ISNULL([CIP].[FORENAME] + ' ','')  + ISNULL([CIP].[SURNAME],'') ELSE [CIP].[SURNAME] END
			  ,'')																								AS [InsuredName]
	,CASE WHEN [CIP].[COMPANY] = 1 THEN ISNULL([CIP].[SURNAME]  ,'') ELSE '' END								AS [TradingName]
	,COALESCE([SB_CI].[ERNREF], [TL_CI].[ERNREF], [TO_TO].[ERNREF], '')											AS [EmployerReferenceNumber]
	,CASE
		WHEN [TL_CI].[ERNEXEMPT] = 1 OR [SB_CI].[ERNEXEMPT] = 1 OR [TO_TO].[ERNEXEMPT] = 1 THEN 'Y'
		WHEN [TL_CI].[ERNEXEMPT] = 0  AND ISNULL([TL_CI].[ERNREF], '') <> '' THEN 'N'
		WHEN [SB_CI].[ERNEXEMPT] = 0  AND ISNULL([SB_CI].[ERNREF], '') <> '' THEN 'N'
		WHEN [TO_TO].[ERNEXEMPT] = 0  AND ISNULL([TO_TO].[ERNREF], '') <> '' THEN 'N'
		ELSE ''
	 END																										AS [ERNExemptFlag]
	,[LMHCS].[MH_COSTATUS_DEBUG]																				AS [CompanyStatus]
	,ISNULL(CAST([SB_CI].[YrEstablished] AS INT), CAST([TL_CI].[YrEstablished] AS INT))							AS [YearBusinessEstablished]
	,[LMHT1].[MH_TRADE_DEBUG]																					AS [PrimaryTradeDescription]
	,[LMHT2].[MH_TRADE_DEBUG]																					AS [SecondaryTradeDescription]
	,COALESCE([CAR_TI].[TURNOVER], [TL_CI].[ANNUALTURNOVER], [TO_TO].[ANUALTURNOVER])							AS [Turnover]
	,REPLACE(CASE WHEN ISNUMERIC([HOUSE]) = 1 THEN [HOUSE] + ' ' + [STREET] ELSE ISNULL([HOUSE], '') END
			 + CASE WHEN ISNUMERIC([HOUSE]) = 1 THEN '' ELSE CASE WHEN ISNULL([STREET], '') = '' THEN '' ELSE ', ' + [STREET] END END
			 + CASE WHEN ISNULL([LOCALITY], '') = '' THEN '' ELSE ', ' + [LOCALITY] END
			 + CASE WHEN ISNULL([CITY], '') = '' THEN '' ELSE ', ' + [CITY] END
			 + CASE WHEN ISNULL([COUNTY], '') = '' THEN '' ELSE ', ' + [COUNTY] END	
			 , ',,', '')																						AS [RiskAddress]
	,'UK'																										AS [RiskAddressCountry]
	,UPPER([CCA].[POSTCODE])																					AS [RiskPostcode]
	,'GBP'																										AS [SettlementCurrency]
	,[CPD].[POLICYINCEPTIONDATE]																				AS [InceptionDate]
	,CASE
		WHEN [T].[TRANSACTION_CODE_ID] IN ('XLD','XREN','XADD') THEN [CPD].[CANCELLATIONDATE]
		ELSE [CPD].[POLICYSTARTDATE]
	 END																										AS [EffectiveDate]
	,[CPD].[POLICYENDDATE]																						AS [ExpiryDateTime]
	,[T].[TransactionDate]																						AS [TransactionDate]
	,DATEDIFF(dd, [CPD].[POLICYSTARTDATE], [CPD].[POLICYENDDATE])												AS [IndemnityPeriod]
	,ISNULL(STUFF(  -- Stuff gets rid of the redundant first comma
					(
						SELECT
						 ',' + [E].[ENDORSEMENT_CODE_ID]
						FROM 
							[dbo].[CUSTOMER_ENDORSEMENT] AS [E]
						WHERE 
							[RAL].[POLICY_DETAILS_ID] = [E].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [E].[HISTORY_ID]
							AND [E].[ENDORSEMENT_CODE_ID] <> '0'
						FOR XML PATH('')
					) ,1,1,''),'')																				AS [EndorsementCodes]
	,CASE
		WHEN [CAR_ASS].[ASBESTOS_ID] = '3MQT5MC7' THEN 'Y'	WHEN [CAR_ASS].[ASBESTOS_ID] = '3MQT5MC6' THEN 'N' -- 3MQT5MC7 = Disagree, 3MQT5MC6 = Agree
		WHEN [SB_ASS].[ASBESTOS_ID] = '3MQT5MC7' THEN 'Y'	WHEN [SB_ASS].[ASBESTOS_ID] = '3MQT5MC6' THEN 'N' -- 3MQT5MC7 = Disagree, 3MQT5MC6 = Agree
		WHEN [TL_TD].[CorgiReg] = 1 THEN 'Y'	WHEN [TL_TD].[CorgiReg] = 0 THEN 'N'
		WHEN [TO_ASS].[ASBESTOS_ID] = '3MQT5MC7' THEN 'Y'	WHEN [TO_ASS].[ASBESTOS_ID] = '3MQT5MC6' THEN 'N' -- 3MQT5MC7 = Disagree, 3MQT5MC6 = Agree
		ELSE ''
	 END																										AS [GasFittingOrInstallationWorkUndertaken]
	,CASE [TL_CI].[Heat] WHEN 1 THEN 'Y' WHEN 0 THEN 'N' ELSE '' END											AS [UseOfHeatOrFire]
	,[T].[GrossPremiumExcIPT]																					AS [TotalGrossPremium]
	,[T].[GrossPremiumExcIPT] - [T].[TotalCommission]															AS [NetRate]
	,[T].[TotalCommission]																						AS [TotalCommission]
	,CASE
		WHEN [RMAMH].[XBroker] = 1 THEN ISNULL([T].[SubagentCommission], 0)
		ELSE ISNULL([T].[BrokerCommission], 0) + ISNULL([T].[IntroducerCommission], 0)
	 END																										AS [IntermediaryCommission]
	,[T].[IPT]																									AS [TotalIPT]
	,[T].[GrossPremiumIncIPT] - [T].[TotalCommission]															AS [TotalPayableToInsurer]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[MATERIALSVALUE] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN (SELECT CAST([CARMaxContractVal] AS money) FROM [dbo].[LIST_MH_CARMaxContractVal] WHERE [MH_CARMAXCONTRACTVAL_ID] = [TL_CAR].[MaxContractVal_ID])
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN (SELECT CAST([MH_CNTRCTLEVEL_DEBUG] AS money) FROM [dbo].[LIST_MH_CNTRCTLEVEL] WHERE [MH_CNTRCTLEVEL_ID] = [TO_TO].[LEVLCONTRACWRK_ID])	
			END, 0)																								AS [MaterialsOnSite]
	,ISNULL([T].[ToolsPlantPremium], 0)																			AS [ToolAndOwnPlantPremium]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[EMPTOOLS] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN CAST([LMHCT].[MH_COVTOOLS_DEBUG] AS money)
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([TO_TO].[TOOLSCOVER] AS money)
			END, 0)																								AS [ToolsSumInsured]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[TOOLSVALUE] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN CAST([LMHCOP].[CAROwnPlantMacVal] AS money)
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([TO_TO].[OWNPLANTCOVER] AS money)
			END, 0)																								AS [ConstructionalPlantMachinerySumInsured]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[VALUEHIREDPLANT] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN CAST([LMHCHP].[CARHirPlantMacVal] AS money)
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([TO_TO].[HIREDINPLANT] AS money)
			END, 0)																								AS [HiredInPlantSumInsured]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[HIRECHARGES] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN CAST([LMHCHC].[CARHireChargeVal] AS money)
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([TO_TO].[TGSHIRECHARGES] AS money)
			END, 0)																								AS [HiredInPlantAnnualHiringCharges]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' -- Contractors All Risks
					THEN CAST([CAR_TI].[HIREDPLANT] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN (SELECT CAST([CARMaxHirPlantVal] AS money) FROM [dbo].[LIST_MH_CARMaxHirPlantVal]
						  WHERE [MH_CARMAXHIRPLANTVAL_ID] = [TL_CAR].[MaxHirPlantVal_ID]) -- For some reason this subquery performs much faster than joining to the table in the main query which doubles the run time!
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([TO_TO].[HIREDVALMAX] AS money)
			END, 0)																								AS [HiredInPlantMaxValueSingleItem]
	,CASE [TO_TO].[REQMNYCOVER] WHEN 1 THEN 'Y' WHEN 0 THEN 'N' ELSE '' END										AS [MoneyCoverTaken]															
	,ISNULL([T].[MoneyPremium], 0)																				AS [MoneyCoverPremium]
	,ISNULL([T].[HiredPlantPremium], 0)																			AS [HiredPlantPremium]
	,ISNULL([T].[ContractWorksPremium], 0)																		AS [ContractWorksPremium]
	,[T].[EL Premium]																							AS [ELPremium]
	,CASE WHEN [T].[EL Premium] <> 0 THEN 10000000 ELSE 0 END													AS [LimitOfIndemnityEL]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'E7432392130E4E84B1D863C01891C42F' THEN '' -- Contractors All Risks blank per requirements
		ELSE [T].[PL Premium] + [T].[FixedMachineryPremium] -- Include fixed machinery with PL premium per Sarah (Monday ticket 7049540578)
	 END																										AS [PLPremium]
	,ISNULL(CASE
				WHEN [CPD].[PRODUCT_ID] = 'B39873D2146C466D8C00B21D1104D5DC' -- Small Business & Consultants Liability 
					THEN CAST([LMHPL].[MH_PUBLIAB_Debug] AS money)
				WHEN [CPD].[PRODUCT_ID] = 'DD5B021CFDA44734957203889344C09E' -- Tradesman Liability
					THEN CAST([LMHPL2].[MH_PUBLIAB_Debug] AS money)
				WHEN [CPD].[PRODUCT_ID] = '4BDC8816806045739A4CE97756B92E5B' -- Turnover
					THEN CAST([LMHLL].[MH_LIABLIMIT_DEBUG] AS money)
			END, 0)																								AS [LimitOfIndemnityPL]	
	,[EMP].[EmployeesELManual]																					AS [NoOfEmployeesManual]
	,[EMP].[EmployeesELNonManual]																				AS [NoOfEmployeesNonManual]
	,[EMP].[ManualPartnersAndPrincipals]																		AS [ManualPrinciplesAndPartners]
	,[EMP].[NonManuaPartnersAndPrincipals]																		AS [NonManualPrinciplesAndPartners]
	,CASE WHEN [RAL].[ACTIONTYPE] = 4 THEN [LCR].[CANCEL_REASON_DEBUG] END										AS [CancellationReason]
	,CASE WHEN [RAL].[ACTIONTYPE] = 3 THEN [LMTA].[MTAADJUSTMENTTYPE_DEBUG]	END									AS [MTAReason]
	,CASE WHEN ([TO_TO].[REQEMPLIAB] = 1 OR [T].[EL Premium] <> 0) THEN 'P' ELSE NULL END						AS [Parent/Child]
FROM 
	[dbo].[REPORT_ACTION_LOG] AS [RAL]
		LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [CPD].[POLICY_DETAILS_ID] = [RAL].[POLICY_DETAILS_ID] and [CPD].[HISTORY_ID] = [RAL].[HISTORY_ID]
			LEFT JOIN [dbo].[CUSTOMER_POLICY_LINK] AS [CPL] ON [CPD].[POLICY_DETAILS_ID] = [CPL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [CPL].[POLICY_DETAILS_HISTORY_ID]
				LEFT JOIN [dbo].[CUSTOMER_INSURED_PARTY] AS [CIP] ON [CPL].[INSURED_PARTY_ID] = [CIP].[INSURED_PARTY_ID] AND [CPL].[INSURED_PARTY_HISTORY_ID] = [CIP].[HISTORY_ID]
					LEFT JOIN [dbo].[CUSTOMER_CLIENT_ADDRESS] AS [CCA] ON [CIP].[INSURED_PARTY_ID] = [CCA].[INSURED_PARTY_ID] AND [CIP].[HISTORY_ID] = [CCA].[HISTORY_ID]
					LEFT JOIN [dbo].[LIST_TITLE] AS [LT] ON [CIP].[TITLE_ID] = [LT].[TITLE_ID]
			LEFT JOIN [dbo].[CUSTOMER_MTAADJUSTMENT] AS [CMTA] ON [CPD].[POLICY_DETAILS_ID] = [CMTA].[POLICY_DETAILS_ID] and [CPD].[HISTORY_ID] = [CMTA].[HISTORY_ID]
				LEFT JOIN [dbo].[LIST_MTAADJUSTMENTTYPE] AS [LMTA] ON [CMTA].[MTAADJUSTMENTTYPE_ID] = [LMTA].[MTAADJUSTMENTTYPE_ID]
			LEFT JOIN [dbo].[LIST_CANCEL_REASON] AS [LCR] ON [CPD].[CANCELLATION_REASON_ID] = [LCR].[CANCEL_REASON_ID]
			LEFT JOIN [dbo].[RM_AGENT] AS [RMA] ON [CPD].[AGENT_ID] = [RMA].[AGENT_ID]
			LEFT JOIN [dbo].[RM_AGENT_MH_TYPE] AS [RMAMH] ON [CPD].[AGENT_ID] = [RMAMH].[AGENT_ID]
			LEFT JOIN [dbo].[RM_PRODUCT] AS [RMP] ON [CPD].[PRODUCT_ID] = [RMP].[PRODUCT_ID]
			LEFT JOIN [dbo].[RM_SCHEME] AS [RMS] ON [CPD].[SCHEMETABLE_ID] = [RMS].[SCHEMETABLE_ID]
			LEFT JOIN [dbo].[RM_SUBAGENT] AS [RMSA] ON [CPD].[SUBAGENT_ID] = [RMSA].[SUBAGENT_ID]
		-- CAR risk tables:
		LEFT JOIN [dbo].[USER_MCARISK_TCCINFO] AS [CAR_TI] ON [RAL].[POLICY_DETAILS_ID] = [CAR_TI].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CAR_TI].[HISTORY_ID]
		LEFT JOIN [dbo].[USER_MCARISK_ASSUMP] AS [CAR_ASS] ON [RAL].[POLICY_DETAILS_ID] = [CAR_ASS].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CAR_ASS].[HISTORY_ID]
		-- Small Business risk tables:
		LEFT JOIN [dbo].[USER_MCLIAB_CINFO] AS [SB_CI] ON [RAL].[POLICY_DETAILS_ID] = [SB_CI].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [SB_CI].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_PUBLIAB] AS [LMHPL] ON [SB_CI].[PubLiabLimit_ID] = [LMHPL].[MH_PUBLIAB_ID]
		LEFT JOIN [dbo].[USER_MCLIAB_ASSUMP] AS [SB_ASS] ON [RAL].[POLICY_DETAILS_ID] = [SB_ASS].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [SB_ASS].[HISTORY_ID]
		-- Tradesman Liability risk tables:
		LEFT JOIN [dbo].[USER_MLIAB_CINFO] AS [TL_CI] ON [RAL].[POLICY_DETAILS_ID] = [TL_CI].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [TL_CI].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_COVTOOLS] AS [LMHCT] ON [TL_CI].[ToolValue_ID] = [LMHCT].[MH_COVTOOLS_ID]
			LEFT JOIN [dbo].[LIST_MH_PUBLIAB] AS [LMHPL2] ON [TL_CI].[PubLiabLimit_ID] = [LMHPL2].[MH_PUBLIAB_ID]
		LEFT JOIN [dbo].[USER_MLIAB_TRDDTAIL] AS [TL_TD] ON [RAL].[POLICY_DETAILS_ID] = [TL_TD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [TL_TD].[HISTORY_ID]
		LEFT JOIN [USER_MLIAB_CAR] AS [TL_CAR] ON [RAL].[POLICY_DETAILS_ID] = [TL_CAR].[Policy_Details_ID] AND [RAL].[HISTORY_ID] = [TL_CAR].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_CAROwnPlantMacVal] AS [LMHCOP] ON [TL_CAR].[OWNPLANTMACVAL_ID] = [LMHCOP].[MH_CAROWNPLANTMACVAL_ID]
			LEFT JOIN [dbo].[LIST_MH_CARHirPlantMacVal] AS [LMHCHP] ON [TL_CAR].[HIRPLANTMACVAL_ID] = [LMHCHP].[MH_CARHIRPLANTMACVAL_ID]
			LEFT JOIN [dbo].[LIST_MH_CARHireChargeVal] AS [LMHCHC] ON [TL_CAR].[HireChargeVal_ID] = [LMHCHC].[MH_CARHIRECHARGEVAL_ID]
		-- Turnover risk tables:
		LEFT JOIN [dbo].[USER_TURNOVER_TURNOVER] AS [TO_TO] ON [RAL].[POLICY_DETAILS_ID] = [TO_TO].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [TO_TO].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_LIABLIMIT] AS [LMHLL] ON [TO_TO].[PubLiabLimit_ID] = [LMHLL].[MH_LIABLIMIT_ID]
		LEFT JOIN [dbo].[USER_TURNOVER_ACTIVITY] AS [TO_ACT] ON [RAL].[POLICY_DETAILS_ID] = [TO_ACT].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [TO_ACT].[HISTORY_ID]
		LEFT JOIN [dbo].[USER_TURNOVER_ASUUMP] AS [TO_ASS] ON [RAL].[POLICY_DETAILS_ID] = [TO_ASS].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [TO_ASS].[HISTORY_ID]
		-- List tables for multiple LOBS:
			LEFT JOIN [dbo].[LIST_MH_COSTATUS] AS [LMHCS] ON COALESCE([TL_CI].[COMPANYSTATUS_ID], [SB_CI].[COMPSTATUS_ID], [CAR_TI].[COMPSTATUS_ID], [TO_TO].[COMPANYSTATUS_ID]) = [LMHCS].[MH_COSTATUS_ID]
			LEFT JOIN [dbo].[LIST_MH_TRADE] AS [LMHT1] ON COALESCE([TL_TD].[PRIMARYRISK_ID], [SB_CI].[PRIMARYRISK_ID], [CAR_TI].[PRIMARYRISK_ID], [TO_ACT].[PRIMARYTRADE_ID]) = [LMHT1].[MH_TRADE_ID]
			LEFT JOIN [dbo].[LIST_MH_TRADE] AS [LMHT2] ON COALESCE([TL_TD].[SECONDARYRISK_ID], [CAR_TI].[SECONDARYRISK_ID], [TO_ACT].[SECTRADE_ID]) = [LMHT2].[MH_TRADE_ID]
		INNER JOIN [Transactions] AS [T] ON [RAL].[POLICY_DETAILS_ID] = [T].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [T].[POLICY_DETAILS_HISTORY_ID] -- Inner join as actions with no transaction do not need to be reported per Sarah
										 AND [RAL].[ACTIONTYPE] = CASE [T].[TRANSACTION_CODE_ID]
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
		OUTER APPLY [dbo].[tvfSelectLiabilityEmployeeCount]([RMP].[NAME], [RAL].[POLICY_DETAILS_ID], [RAL].[HISTORY_ID]) AS [EMP]
WHERE 
	[CPD].[INSURER_ID] = 'TOLEDO'
	AND [CPD].[PRODUCT_ID] IN ('E7432392130E4E84B1D863C01891C42F', 'B39873D2146C466D8C00B21D1104D5DC', 'DD5B021CFDA44734957203889344C09E', '4BDC8816806045739A4CE97756B92E5B') -- Contractors All Risks, Small Business & Consultants Liability, Tradesman Liability, Turnover
	AND [RAL].[ACTIONTYPE] IN (2, 3, 4, 5, 9, 47, 51) -- Policy, MTA, Cancellation, Renewal, Reinstatement, UndoMTA, UndoRenewal
	AND [RAL].[ACTIONDATE] >= @StartDate
	AND [RAL].[ACTIONDATE] < @EndDate
	AND [CIP].[ClientYn] = 1
ORDER BY
	 [CPD].[POLICYNUMBER]
	,[RAL].[HISTORY_ID]
;
