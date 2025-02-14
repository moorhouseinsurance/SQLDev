USE [Calculators]
GO

---===Tradesman Liability

-- Make sure UAT tables match live:
SELECT COUNT(*) FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
SELECT COUNT(*) FROM [MHGSQL01\TGSL].[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]

SELECT COUNT(*) FROM [Calculators].[dbo].[MLIAB_Covea_CAR_Rates]
SELECT COUNT(*) FROM [MHGSQL01\TGSL].[Calculators].[dbo].[MLIAB_Covea_CAR_Rates]


--====Step 1: Updating existing records with todays date, except LOI '£10,000,000' 

--735
SELECT * FROM [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] 
WHERE [EndDateTime] IS NULL
AND [LevelOfIndemnity] != '£10,000,000' -- These are all set to £1
ORDER BY [TradeDescriptionInsurer], [TradeID], [LevelOfIndemnity]

UPDATE [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL
AND [LevelOfIndemnity] != '£10,000,000'

--SELECT * FROM [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
--WHERE [EndDateTime] = CONVERT(date, GETDATE())


---=== Step 2: Insert new records with decreased value of 10%

INSERT INTO [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL](
     [TradeDescriptionInsurer]
	,[TradeID]
	,[LevelOfIndemnity]
	,[PL1]
	,[PL2]
	,[PL3]
	,[PL4]
	,[PL5]
	,[PL6]
	,[PL7]
	,[PL8]
	,[PL9]
	,[PL10]
	,[EL1]
	,[ExcessProperty]
	,[ExcessHeat]
	,[Endorsement]
	,[QuestionHeat]
	,[Question3Phase]
	,[Question3PhaseRequired]
	,[QuestionPDH]
	,[QuestionPDHRequired]
	,[QuestionMaximumDepthMin]
	,[QuestionMaximumDepthMax]
	,[QuestionHeatRequired]
	,[QuestionMaximumHeightMin]
	,[QuestionMaximumHeightMax]
	,[QuestionPaving]
	,[QuestionPavingRequired]
	,[Refer]
	,[PriceMatchCapPct]
	,[StartDatetime]
	,[EndDatetime]
	,[IsMinPremAppl]
)SELECT 
     [TradeDescriptionInsurer]
	,[TradeID]
	,[LevelOfIndemnity]
	,ROUND([PL1] * 0.9, 2)
	,ROUND([PL2] * 0.9, 2)
	,ROUND([PL3] * 0.9, 2)
	,ROUND([PL4] * 0.9, 2)
	,ROUND([PL5] * 0.9, 2)
	,ROUND([PL6] * 0.9, 2)
	,ROUND([PL7] * 0.9, 2)
	,ROUND([PL8] * 0.9, 2)
	,ROUND([PL9] * 0.9, 2)
	,ROUND([PL10]* 0.9, 2)
	,ROUND([EL1] * 0.9, 2)
	,[ExcessProperty]
	,[ExcessHeat]
	,[Endorsement]
	,[QuestionHeat]
	,[Question3Phase]
	,[Question3PhaseRequired]
	,[QuestionPDH]
	,[QuestionPDHRequired]
	,[QuestionMaximumDepthMin]
	,[QuestionMaximumDepthMax]
	,[QuestionHeatRequired]
	,[QuestionMaximumHeightMin]
	,[QuestionMaximumHeightMax]
	,[QuestionPaving]
	,[QuestionPavingRequired]
	,[Refer]
	,[PriceMatchCapPct]
	,CONVERT(date, GETDATE()) AS [StartDatetime]
	,NULL AS [EndDatetime]
	,[IsMinPremAppl]
FROM [dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
WHERE [EndDatetime] = CONVERT(date, GETDATE())
AND [LevelOfIndemnity] != '£10,000,000' -- These are all set to £1
;


--=========CAR

--====Step 1: Updating existing records with todays date
-- 156
SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_CAR_Rates]
WHERE [EndDateTime] IS NULL
AND [Premium] <> 0
ORDER BY [CoverType], [TradeBand], [EmployeesPL], [CoverStartRange]

UPDATE [Calculators].[dbo].[MLIAB_Covea_CAR_Rates]  SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDateTime] IS NULL
AND [Premium] <> 0

--SELECT * FROM [dbo].[MLIAB_Covea_CAR_Rates]
--WHERE [EndDateTime] = CONVERT(date, GETDATE())


---=== Step 2: Insert new records with decreased value of 10%

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_CAR_Rates](
	 [CoverType]
	,[CoverStartRange]
	,[CoverEndRange]
	,[TradeBand]
	,[EmployeesPL]
	,[Premium]
	,[StartDateTime]
	,[EndDateTime]
	,[InsertDateTime]
	,[UserID]
)
SELECT 
	 [CoverType]
	,[CoverStartRange]
	,[CoverEndRange]
	,[TradeBand]
	,[EmployeesPL]
	,ROUND([Premium] * 0.9, 2)
	,CONVERT(date, GETDATE()) AS [StartDateTime]
	,NULL AS [EndDateTime]
	,GETDATE()
    ,'Jez'
FROM [Calculators].[dbo].[MLIAB_Covea_CAR_Rates]
WHERE [EndDatetime] = CONVERT(date, GETDATE())
AND [Premium] <> 0;


--=========Tools
--3
SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools]
WHERE [EndDatetime] IS NULL;

--====Step 1: Updating existing records with todays date

UPDATE [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools] 
SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL;

---=== Step 2: Insert new records with decreased value of 10%

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools] (
	 [SumsInsuredRangeMin]
	,[SumsInsuredRangeMax]
	,[PremiumStandardPlus]
	,[StartDatetime]
	,[EndDatetime]
)
SELECT
	 [SumsInsuredRangeMin]
	,[SumsInsuredRangeMax]
	,ROUND([PremiumStandardPlus] * 0.9, 2)
	,CONVERT(date, GETDATE()) AS [StartDatetime]
	,NULL AS [EndDatetime]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools]
WHERE
	[EndDatetime] = CONVERT(date, GETDATE())
;


--========Fixed Machinery
--1
SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate]
WHERE [EndDatetime] IS NULL;

UPDATE [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate]
SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL;

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate](
	 [TypeName]
	,[Value]
	,[StartDatetime]
	,[EndDatetime]
)
SELECT
	 [TypeName]
	,ROUND([Value] * 0.9, 2)
	,CONVERT(date, GETDATE()) AS [StartDatetime]
	,NULL AS [EndDatetime]
FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate]
WHERE [EndDatetime] = CONVERT(date, GETDATE())
;


--========Professional Indemnity
--1
SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate]
WHERE [EndDatetime] IS NULL;

UPDATE [Calculators].[dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate]
SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL;

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate](
	 [RatingGroupID]
	,[TurnoverStartRange]
	,[TurnoverEndRange]
	,[PILimit]
	,[Rate]
	,[StartDateTime]
	,[EndDateTime]
	,[InsertDateTime]
	,[InsertUserID]
	,[UpdateDateTime]
	,[UpdateUserID]
)
SELECT
	 [RatingGroupID]
	,[TurnoverStartRange]
	,[TurnoverEndRange]
	,[PILimit]
	,ROUND([Rate] * 0.9, 8)
	,CONVERT(date, GETDATE()) AS [StartDateTime]
	,NULL AS [EndDateTime]
	,GETDATE() AS [InsertDateTime]
	,'Jez' [InsertUserID]
	,GETDATE() AS [UpdateDateTime]
	,'Jez' AS [UpdateUserID]
FROM [Calculators].[dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate]
WHERE [EndDatetime] = CONVERT(date, GETDATE())
;


--========Personal Accident
--1
SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
WHERE [EndDatetime] IS NULL;

UPDATE [Calculators].[dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL;

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates](
	 [CoverType]
	,[CoverLevel]
	,[Premium]
	,[StartDateTime]
	,[EndDateTime]
	,[InsertDateTime]
	,[InsertUserID]
	,[UpdateDateTime]
	,[UpdateUserID]
)
SELECT
	 [CoverType]
	,[CoverLevel]
	,ROUND([Premium] * 0.9, 4)
	,CONVERT(date, GETDATE()) AS [StartDateTime]
	,NULL AS [EndDateTime]
	,GETDATE() AS [InsertDateTime]
	,'Jez' [InsertUserID]
	,GETDATE() AS [UpdateDateTime]
	,'Jez' AS [UpdateUserID]
FROM [Calculators].[dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates]
WHERE [EndDatetime] = CONVERT(date, GETDATE())
;