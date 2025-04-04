USE [Product]
GO
/****** Object:  Table [QuestionSet].[AddOn]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[AddOn](
	[AddOnID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionSetID] [bigint] NOT NULL,
	[AddOnQuestionSetID] [bigint] NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[AddOn]  WITH CHECK ADD  CONSTRAINT [FK_AddOn_QuestionSet] FOREIGN KEY([QuestionSetID])
REFERENCES [QuestionSet].[QuestionSet] ([QuestionSetID])
GO
ALTER TABLE [QuestionSet].[AddOn] CHECK CONSTRAINT [FK_AddOn_QuestionSet]
GO
