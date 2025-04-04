USE [Product]
GO
/****** Object:  Table [QuestionSet].[QuestionSet]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[QuestionSet](
	[QuestionSetID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionSetName] [varchar](50) NULL,
	[AgentID] [char](32) NULL,
	[ProductID] [char](32) NOT NULL,
	[DevelopersNotes] [varchar](4000) NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionSetID] PRIMARY KEY CLUSTERED 
(
	[QuestionSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
