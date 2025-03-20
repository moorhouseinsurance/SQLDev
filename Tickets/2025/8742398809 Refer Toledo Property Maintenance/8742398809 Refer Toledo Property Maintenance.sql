USE [Calculators]
GO

/*
SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL]
WHERE [TradeDescriptionInsurer] LIKE 'Property Maintenance%'
AND EndDateTime IS NULL
AND ISNULL([ReferCAQ], 0) <> 1
*/

-- Expire existing rows:

UPDATE [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL]
SET [EndDateTime] = CONVERT(date, GETDATE())
WHERE [TradeDescriptionInsurer] LIKE 'Property Maintenance%'
AND [EndDateTime] IS NULL
AND ISNULL([ReferCAQ], 0) <> 1
;
GO


-- Insert new rows and set to refer:

INSERT INTO [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] (
	 [TradeID]
	,[TradeDescriptionInsurer]
	,[TradeDescriptionMoorhouse]
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
	,[QuestionEfficacyCover]
	,[QuestionEfficacyCoverRequired]
	,[Refer]
	,[Decline]
	,[PriceMatchCapPct]
	,[StartDatetime]
	,[EndDatetime]
	,[UserID]
	,[ReferCAQ]
	,[ReferXB]
)
SELECT
	 [TradeID]
	,[TradeDescriptionInsurer]
	,[TradeDescriptionMoorhouse]
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
	,[QuestionEfficacyCover]
	,[QuestionEfficacyCoverRequired]
	,[Refer]
	,[Decline]
	,[PriceMatchCapPct]
	,CONVERT(date, GETDATE()) AS [StartDatetime]
	,NULL [EndDatetime]
	,'Jez' AS [UserID]
	,1 AS [ReferCAQ]
	,[ReferXB]
FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL]
WHERE [TradeDescriptionInsurer] LIKE 'Property Maintenance%'
AND [EndDateTime] = CONVERT(date, GETDATE())
;
GO