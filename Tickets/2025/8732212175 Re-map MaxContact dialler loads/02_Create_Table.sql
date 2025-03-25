USE [CRM]
GO

/****** Object:  Table [dbo].[CS_MHGLG_Customer]    Script Date: 25/03/2025 11:01:14 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CS_MHGLG_Customer](
	[object_index] [int] NOT NULL,
	[P001] [nvarchar](40) NOT NULL,
	[P002] [nvarchar](40) NULL,
	[P003] [nvarchar](40) NULL,
	[P005] [nvarchar](40) NULL,
	[P006] [nvarchar](40) NULL,
	[P007] [nvarchar](40) NULL,
	[P008] [nvarchar](100) NULL,
	[P009] [nvarchar](40) NULL,
	[P010] [nvarchar](60) NULL,
	[P011] [nvarchar](100) NULL,
	[P012] [datetime] NULL,
	[P013] [numeric](38, 0) NULL,
	[P014] [numeric](38, 0) NULL,
	[P015] [numeric](38, 0) NULL,
	[P016] [numeric](38, 2) NULL,
	[P017] [datetime] NULL,
	[P018] [nvarchar](40) NULL,
	[P019] [nvarchar](40) NULL,
	[P020] [nvarchar](40) NULL,
	[P021] [nvarchar](40) NULL,
	[P022] [numeric](38, 0) NULL,
	[P023] [numeric](38, 0) NULL,
	[P024] [numeric](38, 0) NULL,
	[P025] [nvarchar](100) NULL,
	[P026] [numeric](38, 0) NULL,
	[P027] [numeric](38, 0) NULL,
	[P028] [nvarchar](40) NULL,
	[P029] [nvarchar](40) NULL,
	[P030] [nvarchar](40) NULL,
	[P031] [nvarchar](40) NULL,
	[P032] [nvarchar](40) NULL,
	[P033] [numeric](38, 0) NULL,
	[P034] [nvarchar](40) NULL,
	[P035] [nvarchar](40) NULL,
	[P036] [nvarchar](40) NULL,
	[P037] [nvarchar](40) NULL,
	[P038] [nvarchar](40) NULL,
	[P039] [nvarchar](40) NULL,
	[P040] [nvarchar](40) NULL,
	[P041] [nvarchar](40) NULL,
	[P042] [numeric](38, 0) NULL,
	[P043] [nvarchar](40) NULL,
	[P044] [nvarchar](40) NULL,
	[P045] [numeric](38, 0) NULL,
	[P046] [numeric](38, 0) NULL,
	[P047] [nvarchar](40) NULL,
	[P048] [nvarchar](40) NULL,
	[P049] [nvarchar](100) NULL,
	[P050] [nvarchar](40) NULL,
	[P051] [numeric](38, 0) NULL,
	[P052] [nvarchar](40) NULL,
	[P053] [nvarchar](40) NULL,
	[P054] [nvarchar](40) NULL,
	[P055] [nvarchar](40) NULL,
	[P056] [nvarchar](40) NULL,
	[P057] [numeric](38, 0) NULL,
	[P058] [numeric](38, 0) NULL,
	[P059] [nvarchar](40) NULL,
	[P060] [nvarchar](40) NULL,
	[P061] [nvarchar](40) NULL,
	[P062] [nvarchar](40) NULL,
	[P063] [nvarchar](40) NULL,
	[P064] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[object_index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[P001] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P013]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P014]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P015]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P016]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P022]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P023]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P024]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P026]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P027]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P033]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P042]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P045]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P046]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P051]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P057]
GO

ALTER TABLE [dbo].[CS_MHGLG_Customer] ADD  DEFAULT ('0') FOR [P058]
GO


