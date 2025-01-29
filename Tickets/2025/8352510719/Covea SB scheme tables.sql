SELECT 
	[SchemeExcessID]
	,[ExcessID]
	,[Level]
	,[Criteria]
FROM
	[Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_Excess]
WHERE
	[EndDateTime] IS NULL;

SELECT 
	[TradePLELID]
	,[TradeID]
	,[TradeDescriptionInsurer]
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
	,[Endorsements]
	,[ELLimitText]
	,[PriceMatchCapPct]
	,[Refer]
FROM
	[Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
WHERE
	[EndDateTime] IS NULL;