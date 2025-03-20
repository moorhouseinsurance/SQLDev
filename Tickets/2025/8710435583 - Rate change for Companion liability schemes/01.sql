USE [Calculators];

DECLARE @Current_Rates_Table AS TABLE
(
	[TradePLELID] [bigint] NOT NULL,
	[TradeDescriptionInsurer] [nvarchar](255) NULL,
	[TradeID] [nvarchar](8) NULL,
	[LevelOfIndemnity] [nvarchar](12) NULL,
	[AdditionalTradeLookup] [nvarchar](50) NULL,
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
	[Refer] [bit] NULL,
	[StartDatetime] [datetime] NULL,
	[EndDatetime] [datetime] NULL,
	[BusinessTransactionTypeID] [int] NULL,
	[Decline] [bit] NULL,
	[InsertDateTime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdateUserID] [varchar](10) NULL,
	[DeclineNB] [bit] NULL,
	[IsMinPremAppl] [bit] NULL
)

DECLARE @Reversion_Table AS TABLE
(
	[TradeDescriptionInsurer] [nvarchar](255) NULL,
	[TradeID] [nvarchar](8) NULL,
	[LevelOfIndemnity] [nvarchar](12) NULL,
	[AdditionalTradeLookup] [nvarchar](50) NULL,
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
	[Refer] [bit] NULL,
	[StartDatetime] [datetime] NULL,
	[EndDatetime] [datetime] NULL,
	[BusinessTransactionTypeID] [int] NULL,
	[Decline] [bit] NULL,
	[InsertDateTime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdateUserID] [varchar](10) NULL,
	[DeclineNB] [bit] NULL,
	[IsMinPremAppl] [bit] NULL
)

INSERT INTO @Current_Rates_Table
	SELECT
		[TradePLELID]
		,[TradeDescriptionInsurer]
		,[TradeID]
		,[LevelOfIndemnity]
		,[AdditionalTradeLookup]
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
		,[StartDatetime]
		,[EndDatetime]
		,[BusinessTransactionTypeID]
		,[Decline]
		,[InsertDateTime]
		,[InsertUserID]
		,[UpdateDateTime]
		,[UpdateUserID]
		,[DeclineNB]
		,[IsMinPremAppl]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]
	WHERE
		[InsertUserID] = 'LINGA'
	AND
		[EndDatetime] IS NULL;

INSERT INTO @Reversion_Table
	SELECT
		[TradeDescriptionInsurer]
		,[TradeID]
		,[LevelOfIndemnity]
		,[AdditionalTradeLookup]
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
		,[StartDatetime]
		,[EndDatetime]
		,[BusinessTransactionTypeID]
		,[Decline]
		,[InsertDateTime]
		,[InsertUserID]
		,[UpdateDateTime]
		,[UpdateUserID]
		,[DeclineNB]
		,[IsMinPremAppl]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]
	WHERE
		[EndDatetime] = '01 Jan 2025';

UPDATE
	@Reversion_Table
SET
	[StartDatetime] = GETDATE()-1
	,[EndDatetime] = NULL
	,[InsertDateTime] = GETDATE()
	,[InsertUserID] = 'Simon'
	,[UpdateDateTime] = NULL
	,[UpdateUserID] = NULL
	
UPDATE
	e
SET
	e.[EndDatetime] = GETDATE()-1
	,e.[UpdateDatetime] = GETDATE()
	,e.[UpdateUserID] = 'Simon'
FROM
	[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL] e
INNER JOIN
	@Current_Rates_Table d ON e.[TradePLELID] = d.[TradePLELID];

INSERT INTO [Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]
	SELECT
		*
	FROM
		@Reversion_Table;

DECLARE @CAR_Current_Rates AS TABLE
(
	[RatesID] [int] NOT NULL
);

INSERT INTO @CAR_Current_Rates
	SELECT
		[RatesID]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_CAR_Rates]
	WHERE
		[StartDateTime] = '01 Jan 2025'
	AND
		[InsertUserID] = 'LINGA';

DECLARE @CAR_Revision_Table AS TABLE
(
	[CoverType] [nchar](2) NULL,
	[CoverStartRange] [bigint] NULL,
	[CoverEndRange] [bigint] NULL,
	[TradeBand] [int] NULL,
	[EmployeesPL] [int] NULL,
	[Premium] [numeric](18, 6) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDatetime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateDatetime] [datetime] NULL,
	[UpdateUserID] [varchar](10) NULL
);

INSERT INTO @CAR_Revision_Table
	SELECT
		[CoverType]
		,[CoverStartRange]
		,[CoverEndRange]
		,[TradeBand]
		,[EmployeesPL]
		,[Premium]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDatetime]
		,[InsertUserID]
		,[UpdateDatetime]
		,[UpdateUserID]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_CAR_Rates]
	WHERE
		[EndDatetime] = '01 Jan 2025';

UPDATE
	@CAR_Revision_Table
SET
	StartDateTime = GETDATE()-1
	,[EndDateTime] = NULL
	,[InsertDatetime] = GETDATE()
	,[InsertUserID] = 'Simon'
	,[UpdateDatetime] = NULL
	,[UpdateUserID] = NULL;

UPDATE
	e
SET
	e.[EndDateTime] = GETDATE()-1
	,e.[UpdateDatetime] = GETDATE()
	,e.[UpdateUserID] = 'Simon'
FROM
	[Calculators].[dbo].[MLIAB_TokioMarineHCC_CAR_Rates] AS e
INNER JOIN
	@CAR_Current_Rates d ON e.[RatesID] = d.[RatesID];

INSERT INTO [Calculators].[dbo].[MLIAB_TokioMarineHCC_CAR_Rates]
	SELECT
		*
	FROM
		@CAR_Revision_Table;

DECLARE @Tool_Current_Rates AS TABLE
(
	[RatesToolsID] [bigint] NOT NULL,
	[SumsInsuredRangeMin] [bigint] NULL,
	[SumsInsuredRangeMax] [bigint] NULL,
	[PremiumStandardPlus] [bigint] NULL,
	[StartDatetime] [datetime] NULL,
	[EndDatetime] [datetime] NULL,
	[InsertDatetime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateUserID] [varchar](10) NULL
);

INSERT INTO @Tool_Current_Rates
	SELECT
		[RatesToolsID]
		,[SumsInsuredRangeMin]
		,[SumsInsuredRangeMax]
		,[PremiumStandardPlus]
		,[StartDatetime]
		,[EndDatetime]
		,[InsertDatetime]
		,[InsertUserID]
		,[UpdateUserID]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_RatesTools]
	WHERE
		[StartDatetime] = '01 Jan 2025'
	AND
		[InsertUserID] = 'LINGA'

DECLARE @Tool_Revision_Rates AS TABLE
(
	[SumsInsuredRangeMin] [bigint] NULL,
	[SumsInsuredRangeMax] [bigint] NULL,
	[PremiumStandardPlus] [bigint] NULL,
	[StartDatetime] [datetime] NULL,
	[EndDatetime] [datetime] NULL,
	[InsertDatetime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateUserID] [varchar](10) NULL
);

INSERT INTO @Tool_Revision_Rates
	SELECT
		[SumsInsuredRangeMin]
		,[SumsInsuredRangeMax]
		,[PremiumStandardPlus]
		,[StartDatetime]
		,[EndDatetime]
		,[InsertDatetime]
		,[InsertUserID]
		,[UpdateUserID]
	FROM
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_RatesTools]
	WHERE
		[EndDatetime] = '01 Jan 2025'

UPDATE
	e
SET
	e.[EndDatetime] = GETDATE()-1
	,e.[UpdateUserID] = 'Simon'
FROM
	[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_RatesTools] e
INNER JOIN
	@Tool_Current_Rates d ON e.[RatesToolsID] = d.[RatesToolsID];

UPDATE
	@Tool_Revision_Rates
SET
	[StartDatetime] = GETDATE()-1
	,[EndDatetime] = NULL
	,[InsertDatetime] = GETDATE()
	,[InsertUserID] = 'Simon'
	,[UpdateUserID] = NULL

INSERT INTO [Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_RatesTools]
	SELECT
		[SumsInsuredRangeMin]
		,[SumsInsuredRangeMax]
		,[PremiumStandardPlus]
		,[StartDatetime]
		,[EndDatetime]
		,[InsertDatetime]
		,[InsertUserID]
		,[UpdateUserID]
	FROM
		@Tool_Revision_Rates;