USE [Product]
GO
/****** Object:  Table [QuestionSet].[CalculatedQuestionOperation]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[CalculatedQuestionOperation](
	[CalculatedQuestionOperationID] [bigint] IDENTITY(1,1) NOT NULL,
	[CalculatedQuestionID] [bigint] NOT NULL,
	[ParameterQuestionID] [bigint] NULL,
	[ParameterValue] [decimal](18, 2) NULL,
	[ParameterValueFunctionID] [int] NULL,
	[Position] [int] NOT NULL,
	[Operator] [varchar](6) NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [CalculatedQuestionOperationID] PRIMARY KEY CLUSTERED 
(
	[CalculatedQuestionOperationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[CalculatedQuestionOperation]  WITH CHECK ADD  CONSTRAINT [FK_CalculatedQuestionOperation_Question] FOREIGN KEY([CalculatedQuestionID])
REFERENCES [QuestionSet].[Question] ([QuestionID])
GO
ALTER TABLE [QuestionSet].[CalculatedQuestionOperation] CHECK CONSTRAINT [FK_CalculatedQuestionOperation_Question]
GO
ALTER TABLE [QuestionSet].[CalculatedQuestionOperation]  WITH CHECK ADD  CONSTRAINT [FK_CalculatedQuestionOperation_Question1] FOREIGN KEY([ParameterQuestionID])
REFERENCES [QuestionSet].[Question] ([QuestionID])
GO
ALTER TABLE [QuestionSet].[CalculatedQuestionOperation] CHECK CONSTRAINT [FK_CalculatedQuestionOperation_Question1]
GO
