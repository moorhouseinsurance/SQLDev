USE [Calculators]
GO

/****** Object:  UserDefinedTableType [dbo].[MLIAB_TrdDtailTableType]    Script Date: 21/01/2025 22:47:36 ******/
CREATE TYPE [dbo].[MLIAB_TrdDtailTableType] AS TABLE(
	[HistoryID] [varchar](3) NULL,
	[PolicyDetailsID] [varchar](32) NULL,
	[EfficacyCover] [bit] NULL,
	[WorkshopPercent] [money] NULL,
	[Workshop] [bit] NULL,
	[EmpsUsing] [money] NULL,
	[FixedMachinery] [bit] NULL,
	[CavityWall] [bit] NULL,
	[Solvent] [bit] NULL,
	[Waterproofing] [bit] NULL,
	[Roofing] [bit] NULL,
	[Ventilation] [bit] NULL,
	[CorgiReg] [bit] NULL,
	[RoadSurfacing] [bit] NULL,
	[Paving] [bit] NULL,
	[MaxDepth] [varchar](250) NULL,
	[MaxDepth_ID] [varchar](8) NULL,
	[Phase] [bit] NULL,
	[SecondaryRisk] [varchar](250) NULL,
	[SecondaryRisk_ID] [varchar](8) NULL,
	[PrimaryRisk] [varchar](250) NULL,
	[PrimaryRisk_ID] [varchar](8) NULL,
	[CoverStartDate] [datetime] NULL,
	[PresentInsurer] [varchar](250) NULL,
	[PresentInsurer_ID] [varchar](8) NULL
)
GO


