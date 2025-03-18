DECLARE @Trade_Table AS Table
(
	[TradePLELID] [bigint] NOT NULL,
	[TradeID] [nvarchar](8) NULL,
	[TradeDescriptionInsurer] [nvarchar](255) NULL,
	[TradeDescriptionMoorhouse] [nvarchar](255) NULL,
	[LevelOfIndemnity] [nvarchar](12) NULL,
	[PL1] [money] NULL,
	[PL2] [money] NULL,
	[PL3] [money] NULL,
	[PL4] [money] NULL,
	[PL5] [money] NULL,
	[PL6] [money] NULL,
	[PL7] [money] NULL,
	[PL8] [money] NULL,
	[PL9] [money] NULL,
	[PL10] [money] NULL,
	[EL1] [money] NULL,
	[ExcessProperty] [bigint] NULL,
	[ExcessHeat] [bigint] NULL,
	[Endorsement] [nvarchar](255) NULL,
	[QuestionHeat] [bit] NULL,
	[Question3Phase] [bit] NULL,
	[Question3PhaseRequired] [bit] NULL,
	[QuestionPDH] [bit] NULL,
	[QuestionPDHRequired] [bit] NULL,
	[QuestionMaximumDepthMin] [int] NULL,
	[QuestionMaximumDepthMax] [int] NULL,
	[QuestionHeatRequired] [bit] NULL,
	[QuestionMaximumHeightMin] [int] NULL,
	[QuestionMaximumHeightMax] [int] NULL,
	[QuestionPaving] [bit] NULL,
	[QuestionPavingRequired] [bit] NULL,
	[QuestionEfficacyCover] [bit] NULL,
	[QuestionEfficacyCoverRequired] [bit] NULL,
	[Refer] [bit] NULL,
	[Decline] [bit] NULL,
	[PriceMatchCapPct] [int] NULL,
	[StartDatetime] [datetime] NULL,
	[EndDatetime] [datetime] NULL,
	[UserID] [nvarchar](50) NULL,
	[ReferCAQ] [bit] NULL,
	[ReferXB] [bit] NULL
)

INSERT INTO @Trade_Table
	SELECT
		[TradePLELID]
		,[TradeID]
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
	FROM
		[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL]
	WHERE
		[TradeID] = '3N0TV819'
	AND
		[EndDatetime] IS NULL;

UPDATE
	@Trade_Table
SET
	[StartDatetime] = GETDATE()-1
	,[UserID] = 'Simon'
	,[ReferCAQ] = NULL;

UPDATE
	e
SET
	e.[EndDatetime] = GETDATE()-1
FROM
	[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] e
INNER JOIN
	@Trade_Table d ON e.[TradePLELID] = d.[TradePLELID];

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL]
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
		,[StartDatetime]
		,[EndDatetime]
		,[UserID]
		,[ReferCAQ]
		,[ReferXB]
	FROM
		@Trade_Table;