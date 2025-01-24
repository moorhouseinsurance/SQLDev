USE [Calculators]
GO

/****** Object:  UserDefinedTableType [dbo].[MLIAB_TrdDtail_TableType]  Script Date: 14/01/2025 09:05:13 ******/
CREATE TYPE [dbo].[MLIAB_TrdDtail_TableType] AS TABLE(
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
	[PresentInsurer_ID] [varchar](8) NULL,
	[Manufacture] [bit] NULL,
	[Engineering] [bit] NULL

)
GO


