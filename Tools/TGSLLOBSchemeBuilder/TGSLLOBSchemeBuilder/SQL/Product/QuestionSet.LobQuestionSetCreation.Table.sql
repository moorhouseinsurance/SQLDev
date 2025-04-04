USE [Product]
GO
/****** Object:  Table [QuestionSet].[LobQuestionSetCreation]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[LobQuestionSetCreation](
	[UserID] [int] NULL,
	[QuestionSetName] [nvarchar](50) NULL,
	[AgentID] [char](32) NULL,
	[ProductID] [char](32) NULL,
	[DevelopersNotes] [nvarchar](4000) NULL,
	[GroupName] [nvarchar](30) NULL,
	[GroupText] [nvarchar](1000) NULL,
	[GroupSortOrder] [int] NULL,
	[SectionName] [nvarchar](30) NULL,
	[SectionText] [nvarchar](1000) NULL,
	[SectionSortOrder] [int] NULL,
	[AnswerTableName] [nvarchar](50) NULL,
	[AnswerFieldName] [nvarchar](50) NULL,
	[TailorQuoteFlag] [bit] NULL,
	[AnswerDefaultValueOrID] [nvarchar](50) NULL,
	[AnswerDefaultSet] [bit] NOT NULL,
	[AnswerTypeName] [nvarchar](30) NULL,
	[Enabled] [bit] NOT NULL,
	[HelpText] [nvarchar](1000) NULL,
	[ListTableID] [int] NULL,
	[Mandatory] [bit] NOT NULL,
	[MandatoryText] [nvarchar](1000) NULL,
	[QuickQuote] [bit] NOT NULL,
	[QuestionSortOrder] [int] NULL,
	[QuestionText] [nvarchar](4000) NULL,
	[Visible] [bit] NOT NULL,
	[ParentAnswerTableName] [nvarchar](255) NULL,
	[ParentAnswerFieldName] [nvarchar](255) NULL
) ON [PRIMARY]

GO
