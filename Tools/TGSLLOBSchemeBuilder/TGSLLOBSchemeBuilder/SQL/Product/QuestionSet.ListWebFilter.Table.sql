USE [Product]
GO
/****** Object:  Table [QuestionSet].[ListWebFilter]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[ListWebFilter](
	[LISTTABLE_ID] [int] NOT NULL,
	[ID] [nvarchar](8) NULL,
	[DEBUG] [nvarchar](max) NULL,
	[SORTORDER] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
