USE [Calculators];

DECLARE @Current_Rates_Table AS TABLE
(
	[RateID] [int] NOT NULL
);

INSERT INTO @Current_Rates_Table
	SELECT
		[RateID]
	FROM
		[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_ELPLRate] 
	WHERE
		[EndDateTime] IS NULL

DECLARE @Revision_Rates_Table AS TABLE
(
	[RateType] [varchar](40) NULL,
	[IndemnityLimit] [int] NULL,
	[StartRangeTurnoverFees] [int] NULL,
	[EndRangeTurnoverFees] [int] NULL,
	[RateValue] [decimal](10, 4) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL
);

INSERT INTO @Revision_Rates_Table
	SELECT
		[RateType]
		,[IndemnityLimit]
		,[StartRangeTurnoverFees]
		,[EndRangeTurnoverFees]
		,[RateValue]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDateTime]
		,[UserID]
	FROM
		[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_ELPLRate]
	WHERE
		[EndDateTime] = '01 Jan 2025';

UPDATE
	@Revision_Rates_Table
SET
	[StartDateTime] = GETDATE()-1
	,[EndDateTime] = NULL
	,[InsertDateTime] = GETDATE()
	,[UserID] = 'Simon'

UPDATE
	e
SET
	e.[EndDatetime] = GETDATE()-1
	,e.[UserID] = 'Simon'
FROM
	[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_ELPLRate] e
INNER JOIN
	@Current_Rates_Table d ON e.[RateID] = d.[RateID];

INSERT INTO [Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_ELPLRate]
	SELECT
		*
	FROM
		@Revision_Rates_Table;
		
DECLARE @PI_Current_Rates AS TABLE
(
	[RateID] [int]
);

INSERT INTO @PI_Current_Rates
	SELECT 
		[RateID]
	FROM
		[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_Rate]
	WHERE
		[EndDateTime] IS NULL;

DECLARE @PI_Revision_Rates AS TABLE
(
	[RateType] [varchar](40) NULL,
	[PIRatingTypeID] [varchar](2) NULL,
	[IndemnityLimit] [int] NULL,
	[StartRangeTurnoverFees] [int] NULL,
	[EndRangeTurnoverFees] [int] NULL,
	[RateValue] [decimal](10, 4) NULL,
	[NoRateReason] [varchar](100) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[InsertDateTime] [datetime] NULL,
	[UserID] [varchar](10) NULL	
);

INSERT INTO @PI_Revision_Rates
	SELECT
		[RateType]
		,[PIRatingTypeID]
		,[IndemnityLimit]
		,[StartRangeTurnoverFees]
		,[EndRangeTurnoverFees]
		,[RateValue]
		,[NoRateReason]
		,[StartDateTime]
		,[EndDateTime]
		,[InsertDateTime]
		,[UserID]
	FROM
		[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_Rate]
	WHERE
		[EndDatetime] = '01 Jan 2025';

UPDATE
	@PI_Revision_Rates
SET
	[StartDateTime] = GETDATE()-1
	,[EndDateTime] = NULL
	,[InsertDateTime] = GETDATE()
	,[UserID] = 'Simon';

UPDATE
	e
SET
	e.[EndDatetime] = GETDATE()-1
	,e.[UserID] = 'Simon'
FROM
	[Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_Rate] e
INNER JOIN
	@PI_Current_Rates d ON e.[RateID] = d.[RateID];

INSERT INTO [Calculators].[dbo].[MPROIND_TokioMarineHCC_ProfessionalIndemnity_Rate]
	SELECT
		*
	FROM
		@PI_Revision_Rates;