USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportToledoCommercialBord]    Script Date: 20/02/2025 15:04:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[uspReportToledoCommercialBord]
	 @StartDate datetime
	,@EndDate datetime
	,@ResultSet int

AS

-- ==============================================
-- Author:		Jeremai Smith
-- Create date: 20 May 2024
-- Description:	Combined Toledo Propery Owners, Shop, Commercial Combined, and Directors & Officers bordereau based on Toledo Liability Bordereau
-- ==============================================

-- Date			Who						Change
-- 15/07/2024	Jeremai Smith			Use cancellation date for the effective date column on cancellations (Monday ticket 7023855489)
-- 17/07/2024	Jeremai Smith			Replaced hard coded XBroker Agent ID with join to new RM_AGENT_MH_TYPE table so Blink is included (Monday ticket 6996624659)
-- 04/10/2024	Jeremai Smith			Default PLLimit to £5m for Property Owners (Monday ticket 7565710491)
-- 16/12/2024	Linga       			Change to Toledo Commercial BDX (Monday ticket 8044781067)
-- 18/12/2024   Linga					Add Toledo D&O to BDX  (Monday ticket 8046531345)


/*
	DECLARE @StartDate datetime = '01 Jan 2024'
	DECLARE @EndDate datetime = '15 dec 2024'
	DECLARE @ResultSet INT = 1
	EXEC [dbo].[uspReportToledoCommercialBord] @StartDate, @EndDate, @ResultSet
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
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'DIOFPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [D&OPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'BUILPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [BuildingsPremium]
		,SUM(CASE WHEN [ATB].[POLICY_SECTION_ID] = 'CONTPREM' AND [ATB].[TRAN_BREAKDOWN_TYPE_ID] = 'NET' THEN [ATB].[AMOUNT] ELSE 0 END) AS [ContentsPremium]
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
	,CASE
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' THEN 'Unoccupied Property' -- Property Owners
		ELSE [RMP].[NAME]
	 END																										AS [Product]
	,[RMP].[NAME]																								AS [SubProduct]
	,COALESCE(CASE WHEN [CIP].[COMPANY] = 1 THEN [CIP].[COMPANYCONTACTNAME] END
			  ,CASE WHEN [CIP].[COMPANY] = 0 THEN ISNULL([LT].[TITLE_DEBUG] + ' ','') + ISNULL([CIP].[FORENAME] + ' ','')  + ISNULL([CIP].[SURNAME],'') ELSE [CIP].[SURNAME] END
			  ,'')																								AS [InsuredName]
	,CASE WHEN [CIP].[COMPANY] = 1 THEN ISNULL([CIP].[SURNAME]  ,'') ELSE '' END								AS [TradingName]
	,[CPD].[POLICYINCEPTIONDATE]																				AS [InceptionDate]
	,CASE
		WHEN [T].[TRANSACTION_CODE_ID] IN ('XLD','XREN','XADD') THEN [CPD].[CANCELLATIONDATE]
		ELSE [CPD].[POLICYSTARTDATE]
	 END																										AS [EffectiveDate]
	,[CPD].[POLICYENDDATE]																						AS [ExpiryDateTime]
	,[T].[TransactionDate]																						AS [TransactionDate]
	,DATEDIFF(dd, [CPD].[POLICYSTARTDATE], [CPD].[POLICYENDDATE])												AS [IndemnityPeriod]
	,CASE [CIP].[COMPANY] WHEN 1 THEN 'Company' ELSE 'Individual' END											AS [Individual/Company]
	,REPLACE(CASE WHEN ISNUMERIC([CCA].[HOUSE]) = 1 THEN [CCA].[HOUSE] + ' ' + [CCA].[STREET] ELSE ISNULL([CCA].[HOUSE], '') END
			 + CASE WHEN ISNUMERIC([CCA].[HOUSE]) = 1 THEN '' ELSE CASE WHEN ISNULL([CCA].[STREET], '') = '' THEN '' ELSE ', ' + [CCA].[STREET] END END
			 + CASE WHEN ISNULL([CCA].[LOCALITY], '') = '' THEN '' ELSE ', ' + [CCA].[LOCALITY] END
			 + CASE WHEN ISNULL([CCA].[CITY], '') = '' THEN '' ELSE ', ' + [CCA].[CITY] END
			 + CASE WHEN ISNULL([CCA].[COUNTY], '') = '' THEN '' ELSE ', ' + [CCA].[COUNTY] END	
			 , ',,', '')																						AS [Address] -- Note USER_MCOMMCOM_BUSDTAIL table holds a separate business address; may need adding when Commercial Combined gets added to the report
	,'UK'																										AS [Country]
	,UPPER([CCA].[POSTCODE])																					AS [Postcode]
	,[PO_PINF].[PROPERTIES]																						AS [NumberOfPropertiesInsured]
	,'UK'																										AS [InsuredDomiciledCountry]
	,0																											AS [MD/Fire Premium] -- Not sure what premium section this is. Will need adding after other Toledo products have been built.
	,[T].[EL Premium]																							AS [ELPremium]
	,[T].[PL Premium]																							AS [PLPremium]
	,[T].[D&OPremium]																							AS [D&OPremium]
	,[T].[BuildingsPremium]																						AS [BuildingsPremium]
	,[T].[ContentsPremium]																						AS [ContentsPremium]
	,[T].[GrossPremiumExcIPT]																					AS [TotalGrossPremium]
	,[T].[GrossPremiumExcIPT] - [T].[TotalCommission]															AS [NetRate]
	,[T].[TotalCommission]																						AS [TotalCommission]
	,CASE
		WHEN [RMAMH].[XBroker] = 1 THEN ISNULL([T].[SubagentCommission], 0)
		ELSE ISNULL([T].[BrokerCommission], 0) + ISNULL([T].[IntroducerCommission], 0)
	 END																										AS [IntermediaryCommission]
	,[T].[IPT]																									AS [TotalIPT]
	,[T].[GrossPremiumIncIPT] - [T].[TotalCommission]															AS [TotalPayableToInsurer]
	,'GBP'																										AS [SettlementCurrency]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[TOBACCO] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[CIGARETTES] AS money)
	 END																										AS [TotalTobaccoSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[SPIRITS] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[ALCOHOL] AS money)
	 END																										AS [TotalAlcoholSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[DVDS] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[DVDS] AS money)
	 END																										AS [TotalVideoSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[OTHERSTOCK] + [CC_MD].[CLOTHING] + [CC_MD].[LEATHER] + [CC_MD].[FANCYGOODS] + [CC_MD].[CAMERAS] + [CC_MD].[WHITEGOODS]
					  + [CC_MD].[BROWNGOODS] + [CC_MD].[POWERTOOLS] AS money) -- Waiting for rule; TARGETSTOCK also be added, or is this a repeat of alcohol, tobacco, etc.?
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[STOCK] AS money)
	 END																										AS [TotalAllOtherStockSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[CONTENTSTOTAL] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[CONTENTSSI] AS money)
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' -- Property Owners
			THEN CAST([PO_PD].[LANDLORDSSI] AS money)
	 END																										AS [TotalContentsSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[BUILDINGSTOTAL] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CD].[BUILDINGSI] + [S_CD].[IMPOVEMENTSSI] + [S_CD].[SHOPFRONTSI] AS money)
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' -- Property Owners
			THEN CAST([PO_PD].[BUILDINGSSI] AS money)
	 END																										AS [TotalBuildingsSI]	
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_BI].[INTERRUPTIONSI] AS money)
	 END																										AS [BusinessInterruptionSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			AND ([CC_SUB].[SUBSIDAMAGE] = 1 OR [CC_SUB].[MONITORED] = 1 OR [CC_SUB].[SURVEY] = 1 OR [CC_SUB].[DRAINS] = 1
				 OR [CC_SUB].[TREES] = 1 OR [CC_SUB].[EXTENDED] = 1 OR [CC_SUB].[NEIGHBOUR] = 1) THEN 'Yes'
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			AND [S_CD].[SUBSIDENCE] = 1 THEN 'Yes'
	 END																										AS [Subsidence]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_MD].[FROZEN] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_OC].[FROZENFOODSI] AS money)
	 END																										AS [TotalRefridgeratedStockSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([LMHLC].[MH_LIQUORCOVER_DEBUG] AS money)
	 END																										AS [TotalLossOfLicenceSI]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = '4E2C45ACF9304BA094E5C5403FEAB595' -- Directors & Officers
			THEN CAST([LMHCL].[MH_COVERLEVEL_DEBUG] AS money)
	 END																										AS [TotalDirectors&OfficersSI]
	,NULL																										AS [TotalCashPointOnPremises] -- Awaiting rule; currently only a Yes/No question on Shop Insurance
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN [LMHT].[MH_TRADE_DEBUG]
	 END																										AS [TradeDescription]
	,NULL																										AS [ELLimit] -- Awaiting rule; currently only a Yes/No question on Commercial Combined
	,CASE
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' THEN 5000000 -- Property Owners
		ELSE NULL
	 END																										AS [PLLimit]
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
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_BI].[LOSSOFRENTSI] AS money)
		WHEN [CPD].[PRODUCT_ID] = '904B4440FE0B49FEA2CDBAEC11E113E0' -- Property Owners
			THEN CAST([PO_PD].[RENTINCOME] AS money)
	 END																										AS [LossOfRent]
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN [CC_EL].[ERNREF]
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN [S_CO].[ERNREF]
	END																											AS [EmployerReferenceNumber]
	,CASE
		WHEN [CC_EL].[ERNEXEMPT] = 1 OR [S_CO].[ERNEXEMPT] = 1 THEN 'Y'
		WHEN [CC_EL].[ERNEXEMPT] = 0  AND ISNULL([CC_EL].[ERNREF], '') <> '' THEN 'N'
		WHEN [S_CO].[ERNEXEMPT] = 0  AND ISNULL([S_CO].[ERNREF], '') <> '' THEN 'N'
		ELSE ''
	 END																										AS [ERNExemptFlag]
	,NULL																										AS [NoOfEmployeesManual] -- Awaiting rule; Shop Insurance only has total employees
	,NULL																										AS [NoOfEmployeesNonManual] -- Awaiting rule; Shop Insurance only has total employees
	,NULL																										AS [ManualPrinciplesAndPartners] -- Awaiting rule; Shop Insurance only has partners but doesn't differentiate manual
	,NULL																										AS [NonManualPrinciplesAndPartners] -- Awaiting rule; Shop Insurance only has partners but doesn't differentiate manual
	,CASE
		WHEN [CPD].[PRODUCT_ID] = 'D5D5CCD78165456AA41464C98B9B4998' -- Commercial Combined
			THEN CAST([CC_BD].[TURNOVER] AS money)
		WHEN [CPD].[PRODUCT_ID] = '4E2C45ACF9304BA094E5C5403FEAB595' -- Directors & Officers
			THEN CAST([DO].[ANUALTURN] AS money)
		WHEN [CPD].[PRODUCT_ID] = '92EE6D9B2D7D43F3A7B9E8C8594BA3E1' -- Shop Insurance
			THEN CAST([S_CO].[ANNTURNOVER] AS money)
	 END																										AS [Turnover]
	,CASE WHEN [RAL].[ACTIONTYPE] = 4 THEN [LCR].[CANCEL_REASON_DEBUG] END										AS [CancellationReason]
	,CASE WHEN [RAL].[ACTIONTYPE] = 3 THEN [LMTA].[MTAADJUSTMENTTYPE_DEBUG]	END									AS [MTAReason]
INTO [#Temp_Existing_ToledoCommercialBord_Results]
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
		-- Commercial Combined risk tables:
		LEFT JOIN [dbo].[USER_MCOMMCOM_BUSDTAIL] AS [CC_BD] ON [RAL].[POLICY_DETAILS_ID] = [CC_BD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CC_BD].[HISTORY_ID]
			LEFT JOIN [dbo].[USER_MCOMMCOM_MTRLDAMG] AS [CC_MD] ON [CC_BD].[MCOMMCOM_BUSDTAIL_ID] = [CC_MD].[MCOMMCOM_BUSDTAIL_ID] AND [CC_BD].[HISTORY_ID] = [CC_MD].[HISTORY_ID]
			LEFT JOIN [dbo].[USER_MCOMMCOM_SUBSIDEN] AS [CC_SUB] ON [CC_BD].[MCOMMCOM_BUSDTAIL_ID] = [CC_SUB].[MCOMMCOM_BUSDTAIL_ID] AND [CC_BD].[HISTORY_ID] = [CC_SUB].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_TRADE] AS [LMHT] ON [CC_BD].[TRADE_ID] = [LMHT].[MH_TRADE_ID]
		LEFT JOIN [dbo].[USER_MCOMMCOM_BUSIINTE] AS [CC_BI] ON [RAL].[POLICY_DETAILS_ID] = [CC_BI].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CC_BI].[HISTORY_ID]
		LEFT JOIN [dbo].[USER_MCOMMCOM_EMPLIAB] AS [CC_EL] ON [RAL].[POLICY_DETAILS_ID] = [CC_EL].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [CC_EL].[HISTORY_ID]
		-- Directors & Officers risk tables:
		LEFT JOIN [dbo].[USER_MDO_DIRCOFFI] AS [DO] ON [RAL].[POLICY_DETAILS_ID] = [DO].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [DO].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_COVERLEVEL] AS [LMHCL] ON [DO].[COVERLEVEL_ID] = [LMHCL].[MH_COVERLEVEL_ID]
		-- Property Owners risk tables:
		LEFT JOIN [dbo].[USER_MLETPROP_PROPINFO] AS [PO_PINF] ON [RAL].[POLICY_DETAILS_ID] = [PO_PINF].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [PO_PINF].[HISTORY_ID]
		OUTER APPLY (SELECT SUM([BUILDINGSSI]) AS [BUILDINGSSI], SUM([LANDLORDSSI]) AS [LANDLORDSSI], SUM([RENTINCOME]) AS [RENTINCOME]
					 FROM [dbo].[USER_MLETPROP_PRPDTAIL]
					 WHERE [MLETPROP_PROPINFO_ID] = [PO_PINF].[MLETPROP_PROPINFO_ID] AND [HISTORY_ID] = [PO_PINF].[HISTORY_ID]) AS [PO_PD]
		-- Shop risk tables:
		LEFT JOIN [dbo].[USER_MSHOP_CVRDTAIL] AS [S_CD] ON [RAL].[POLICY_DETAILS_ID] = [S_CD].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [S_CD].[HISTORY_ID]
		LEFT JOIN [dbo].[USER_MSHOP_COMPANY] AS [S_CO] ON [RAL].[POLICY_DETAILS_ID] = [S_CO].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [S_CO].[HISTORY_ID]
		LEFT JOIN [dbo].[USER_MSHOP_OPTCVR] AS [S_OC] ON [RAL].[POLICY_DETAILS_ID] = [S_OC].[POLICY_DETAILS_ID] AND [RAL].[HISTORY_ID] = [S_OC].[HISTORY_ID]
			LEFT JOIN [dbo].[LIST_MH_LIQUORCOVER] AS [LMHLC] ON [S_OC].[LICENCECOVER_ID] = [LMHLC].[MH_LIQUORCOVER_ID]
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
WHERE 
	[CPD].[INSURER_ID] = 'TOLEDO'
	AND [CPD].[PRODUCT_ID] IN ('904B4440FE0B49FEA2CDBAEC11E113E0', '4E2C45ACF9304BA094E5C5403FEAB595') -- Property Owners and Directors & Officers 	-- '92EE6D9B2D7D43F3A7B9E8C8594BA3E1', 'D5D5CCD78165456AA41464C98B9B4998') , Shop Insurance, Commercial Combined to be added after Toledo schemes built
	AND [RAL].[ACTIONTYPE] IN (2, 3, 4, 5, 9, 47, 51) -- Policy, MTA, Cancellation, Renewal, Reinstatement, UndoMTA, UndoRenewal
	AND [RAL].[ACTIONDATE] >= @StartDate
	AND [RAL].[ACTIONDATE] < @EndDate
	AND [CIP].[ClientYn] = 1
ORDER BY
	 [CPD].[POLICYNUMBER]
	,[RAL].[HISTORY_ID];

-- Creating an indexes on the temp table to improve the join performance
CREATE INDEX IDX_POLICYNUMER_HISTORY ON [#Temp_Existing_ToledoCommercialBord_Results] ([PolicyNumber], [HISTORY_ID]);
CREATE INDEX IDX_SUBPRODUCT ON [#Temp_Existing_ToledoCommercialBord_Results] ([SubProduct]);

-- Displaying existing results
IF(@ResultSet = 1)
BEGIN
    SELECT * FROM #Temp_Existing_ToledoCommercialBord_Results ORDER BY [PolicyNumber], [HISTORY_ID];
END
-- Fetching location details from existing results and showing as new table 'Locations'
IF(@ResultSet = 2)
BEGIN
WITH [Locations] AS(
SELECT DISTINCT
 [TER].[PolicyNumber]        AS [PolicyNumber]
,(CASE WHEN [PRPDTAIL].[USERINSTANCE] IS NULL THEN (ROW_NUMBER() OVER (PARTITION BY [PRPDTAIL].[MLETPROP_PRPDTAIL_ID] ORDER BY [PRPDTAIL].[HISTORY_ID]))
 ELSE [PRPDTAIL].[USERINSTANCE]
 END)                        AS [PropertyNumber]
--,[TER].[HISTORY_ID]
,[TER].[SubProduct]          AS [ProperyProduct]
,[PRPDTAIL].[POSTCODE]       AS [PropertyPostcode]
,[PRPDTAIL].ADDONE           AS [PropertyAddress1]
,[PRPDTAIL].[ADDTWO]         AS [PropertyAddress2]
,[PRPDTAIL].[ADDTHREE]       AS [PropertyAddress3]
,[PRPDTAIL].[TOWN]           AS [PropertyTown]
,[PRPDTAIL].[COUNTY]         AS [PropertyCounty]
,[TER].[InceptionDate]       AS [InceptionDate]
,[TER].[EffectiveDate]       AS [EffectiveDate]
,[TER].[ExpiryDateTime]      AS [ExpiryDateTime]
,[TER].[TransactionDate]     AS [TransactionDate]
,[TER].[Country]             AS [PropertyCountry]
,[TER].[LossOfRent]          AS [LossOfRent]
,[PRPDTAIL].[BUILDINGSSI]    AS [PropertyBuildingSI]
,[PRPDTAIL].[CONTENTSTOTAL]  AS [PropertyContentSI]
,''                          AS [BusinessInterruptionSI]

FROM [#Temp_Existing_ToledoCommercialBord_Results] AS [TER]
JOIN [Transactor_Live].[dbo].[USER_MLETPROP_PROPINFO] AS [PRPINFO] ON [PRPINFO].[POLICY_DETAILS_ID] = [TER].[POLICY_DETAILS_ID] AND [PRPINFO].[HISTORY_ID] = [TER].[HISTORY_ID]
JOIN [Transactor_Live].[dbo].[USER_MLETPROP_PRPDTAIL] AS [PRPDTAIL] ON [PRPDTAIL].[MLETPROP_PROPINFO_ID] = [PRPINFO].[MLETPROP_PROPINFO_ID] AND [PRPDTAIL].[HISTORY_ID] = [PRPINFO].[HISTORY_ID]
WHERE [TER].[SubProduct] = 'Property Owners')

SELECT DISTINCT
 [PolicyNumber]
,[PropertyNumber]
,[ProperyProduct]
,[PropertyPostcode]
,[PropertyAddress1]
,[PropertyAddress2]
,[PropertyAddress3]
,[PropertyTown]
,[PropertyCounty]
,[InceptionDate]
,[EffectiveDate]
,[ExpiryDateTime]
,[TransactionDate]
,[PropertyCountry]
,[LossOfRent]
,[PropertyBuildingSI]
,[PropertyContentSI]
,[BusinessInterruptionSI]
FROM [Locations] ORDER BY [PolicyNumber];
END

																								