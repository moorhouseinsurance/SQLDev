USE [Product]
GO
/****** Object:  Table [QuestionSet].[AgentQuestionDetails]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[AgentQuestionDetails](
	[AgentQuestionDetailsID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionID] [bigint] NOT NULL,
	[AgentID] [char](32) NULL,
	[AnswerDefaultValueOrID] [varchar](50) NULL,
	[AnswerDefaultValueFunctionID] [int] NULL,
	[AnswerDefaultSet] [bit] NULL,
	[AnswerTypeID] [bigint] NOT NULL,
	[ChildQuestionRepeatMaximum] [int] NULL,
	[ChildQuestionRepeatMinimum] [int] NULL,
	[DevelopersNotes] [varchar](4000) NULL,
	[Enabled] [bit] NULL,
	[HelpText] [varchar](1000) NULL,
	[ListTableID] [int] NULL,
	[Mandatory] [bit] NULL,
	[MandatoryText] [varchar](1000) NULL,
	[ParentQuestionID] [bigint] NULL,
	[QuickQuote] [bit] NULL,
	[SectionID] [bigint] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Text] [varchar](4000) NOT NULL,
	[Visible] [bit] NULL,
	[StartDateTime] [datetime] NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionDetailsID] PRIMARY KEY CLUSTERED 
(
	[AgentQuestionDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[AgentQuestionDetails]  WITH CHECK ADD  CONSTRAINT [FK_AgentQuestionDetails_AnswerType] FOREIGN KEY([AnswerTypeID])
REFERENCES [QuestionSet].[AnswerType] ([AnswerTypeID])
GO
ALTER TABLE [QuestionSet].[AgentQuestionDetails] CHECK CONSTRAINT [FK_AgentQuestionDetails_AnswerType]
GO
ALTER TABLE [QuestionSet].[AgentQuestionDetails]  WITH CHECK ADD  CONSTRAINT [FK_AgentQuestionDetails_Section] FOREIGN KEY([SectionID])
REFERENCES [QuestionSet].[Section] ([SectionID])
GO
ALTER TABLE [QuestionSet].[AgentQuestionDetails] CHECK CONSTRAINT [FK_AgentQuestionDetails_Section]
GO
