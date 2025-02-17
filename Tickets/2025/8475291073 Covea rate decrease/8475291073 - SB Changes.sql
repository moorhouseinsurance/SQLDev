USE [Calculators]
GO

---Small Business

-- Make sure UAT tables match live:
SELECT COUNT(*) FROM [dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
SELECT COUNT(*) FROM [MHGSQL01\TGSL].[Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]


--====Step 1: Updating existing records with todays date 
---621
SELECT * FROM [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL] 
WHERE [EndDateTime] IS NULL
ORDER BY [TradeDescriptionInsurer], [TradeID], [LevelOfIndemnity]

UPDATE [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL] SET [EndDatetime] = CONVERT(date, GETDATE())
WHERE [EndDatetime] IS NULL;

--select * from [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
--WHERE [EndDatetime] = CONVERT(date, GETDATE())


---=== Step 2: Insert new records with decreased value of 10%

INSERT INTO [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL](
     [TradeID]
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
	,[StartDatetime]
	,[EndDatetime]
	,[InsertDateTime]
	,[InsertUserID]
)SELECT 
     [TradeID]
	,[TradeDescriptionInsurer]
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
	,[Endorsements]
	,[ELLimitText]
	,[PriceMatchCapPct]
    ,[Refer]
	,CONVERT(date, GETDATE()) AS [StartDatetime]
	,NULL AS [EndDatetime]
	,GETDATE() AS [InsertDateTime]
	,'Jez'
FROM [Calculators].[dbo].[MCLIAB_Covea_SmallBusinessandConsultantsLiability_TradePLEL]
WHERE [EndDatetime]  = CONVERT(date, GETDATE());