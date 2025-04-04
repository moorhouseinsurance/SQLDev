USE [Product]
GO
/****** Object:  Table [QuestionSet].[AddonDetails]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[AddonDetails](
	[AddOnDetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionSetID] [bigint] NOT NULL,
	[HelpText] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[AddOnDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
