USE [Calculators];

DECLARE @Current_Rates_Table AS TABLE
(
	[TradePLELID] [bigint] NOT NULL
);

INSERT INTO @Current_Rates_Table
	SELECT
		[TradePLELID]
	FROM
		[Calculators].[dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_TradePLEL] 
	WHERE
		[EndDateTime] IS NULL;

DECLARE @Revision_Rates_Table AS TABLE
(
	[TradeID] [varchar](8) NULL,
	[TradeDescriptionInsurer] [varchar](200) NULL,
	[LevelOfIndemnity] [varchar](15) NULL,
	[PL1] [float] NULL,
	[PL2] [float] NULL,
	[PL3] [float] NULL,
	[PL4] [float] NULL,
	[PL5] [float] NULL,
	[PL6] [float] NULL,
	[PL7] [float] NULL,
	[PL8] [float] NULL,
	[PL9] [float] NULL,
	[PL10] [float] NULL,
	[EL1] [float] NULL,
	[PropertyExcess] [float] NULL,
	[HeatExcess] [float] NULL,
	[Endorsements] [varchar](100) NULL,
	[ELLimitText] [varchar](15) NULL,
	[Refer] [bit] NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[Decline] [bit] NULL,
	[InsertDateTime] [datetime] NULL,
	[InsertUserID] [varchar](10) NULL,
	[UpdateDateTime] [datetime] NULL,
	[UpdateUserID] [varchar](10) NULL
);

INSERT INTO @Revision_Rates_Table
	SELECT
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
		,[PropertyExcess]
		,[HeatExcess]
		,[Endorsements]
		,[ELLimitText]
		,[Refer]
		,[StartDateTime]
		,[EndDateTime]
		,[Decline]
		,[InsertDateTime]
		,[InsertUserID]
		,[UpdateDateTime]
		,[UpdateUserID]
	FROM
		[Calculators].[dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_TradePLEL]
	WHERE
		[EndDateTime] = '01 Jan 2025';

UPDATE
	@Revision_Rates_Table
SET
	[StartDateTime] = GETDATE()-1
	,[EndDateTime] = NULL
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
	[Calculators].[dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_TradePLEL] e
INNER JOIN
	@Current_Rates_Table d ON e.[TradePLELID] = d.[TradePLELID];

INSERT INTO [Calculators].[dbo].[MCLIAB_TokioMarineHCC_SmallBusinessandConsultantsLiability_TradePLEL]
	SELECT
		*
	FROM
		@Revision_Rates_Table;