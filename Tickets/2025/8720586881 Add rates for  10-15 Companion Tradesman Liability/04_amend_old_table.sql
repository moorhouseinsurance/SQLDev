USE [Calculators]
GO

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]') AND type in (N'U'))
	DROP TABLE [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL];

	CREATE TABLE [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL](
		[TradePLELID] [bigint] IDENTITY(1,1) NOT NULL,
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
		[PL11] [money] NULL,
		[PL12] [money] NULL,
		[PL13] [money] NULL,
		[PL14] [money] NULL,
		[PL15] [money] NULL,
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
		[IsMinPremAppl] [bit] NULL,
	 CONSTRAINT [PK_MLIAB_TokioM_TL_TradePLELID] PRIMARY KEY NONCLUSTERED 
	(
		[TradePLELID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY];

	SET IDENTITY_INSERT [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL] ON;

	INSERT INTO
		[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL]
		(
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
			,[PL11]
			,[PL12]
			,[PL13]
			,[PL14]
			,[PL15]
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
		)
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
		,[PL11]
		,[PL12]
		,[PL13]
		,[PL14]
		,[PL15]
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
		[Calculators].[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL_new];

	SET IDENTITY_INSERT [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL] OFF;

	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL_new]') AND type in (N'U'))
	DROP TABLE [dbo].[MLIAB_TokioMarineHCC_TradesmanLiability_TradePLEL_new];

GO