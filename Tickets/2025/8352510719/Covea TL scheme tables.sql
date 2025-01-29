SELECT
	[SchemeExcessID]
	,[ExcessID]
	,[Level]
	,[Criteria]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Excess]
WHERE
	[EndDateTime] IS NULL;

SELECT 
	[LoadDiscountClaimsID]
	,[ExperienceYears]
	,[MostRecentClaimYears]
	,[DiscountWeight]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscountClaims]
WHERE
	[EndDateTime] IS NULL;

SELECT 
	[LoadDiscountID]
	,[EmployeesEL]
	,[DiscountWeight]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_LoadDiscountEmployees]
WHERE
	[EndDateTime] IS NULL;

SELECT [RatesID]
      ,[TypeName]
      ,[Value]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_Rate]
WHERE
	[EndDatetime] IS NULL;

SELECT 
	[RatesPostcodeID]
	,[Postcode]
	,[Weight]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesPostcode]
WHERE
	[EndDatetime] IS NULL;

SELECT 
	[RatesToolsID]
	,[SumsInsuredRangeMin]
	,[SumsInsuredRangeMax]
	,[PremiumStandardPlus]
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_RatesTools]
WHERE
	[EndDatetime] IS NULL;

SELECT 
	[TradePLELID]
	,[TradeDescriptionInsurer]
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
FROM
	[Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
WHERE
	[EndDatetime] IS NULL;