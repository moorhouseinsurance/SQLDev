USE [Product]
GO
/****** Object:  Table [QuestionSet].[Group]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[Group](
	[GroupID] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](30) NOT NULL,
	[Text] [varchar](1000) NULL,
	[SortOrder] [int] NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_GroupID] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
