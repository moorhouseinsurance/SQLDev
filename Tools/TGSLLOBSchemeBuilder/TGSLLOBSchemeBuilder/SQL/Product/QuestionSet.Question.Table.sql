USE [Product]
GO
/****** Object:  Table [QuestionSet].[Question]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[Question](
	[QuestionID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionSetID] [bigint] NOT NULL,
	[AnswerTableName] [varchar](50) NOT NULL,
	[AnswerFieldName] [varchar](50) NOT NULL,
	[TailorQuoteFlag] [bit] NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionID] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_QuestionSet] FOREIGN KEY([QuestionSetID])
REFERENCES [QuestionSet].[QuestionSet] ([QuestionSetID])
GO
ALTER TABLE [QuestionSet].[Question] CHECK CONSTRAINT [FK_Question_QuestionSet]
GO
