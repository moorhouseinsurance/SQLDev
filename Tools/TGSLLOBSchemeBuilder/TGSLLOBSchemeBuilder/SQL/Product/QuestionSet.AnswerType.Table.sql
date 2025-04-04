USE [Product]
GO
/****** Object:  Table [QuestionSet].[AnswerType]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[AnswerType](
	[AnswerTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[AnswerTypeName] [varchar](30) NOT NULL,
	[AnswerTypeBaseTypeID] [bigint] NULL,
	[Regex] [varchar](255) NULL,
	[StartRange] [varchar](20) NULL,
	[EndRange] [varchar](20) NULL,
	[StartRangeFunctionID] [int] NULL,
	[EndRangeFunctionID] [int] NULL,
	[Length] [int] NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_AnswerTypeID] PRIMARY KEY CLUSTERED 
(
	[AnswerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[AnswerType]  WITH CHECK ADD  CONSTRAINT [FK_AnswerType_AnswerType] FOREIGN KEY([AnswerTypeBaseTypeID])
REFERENCES [QuestionSet].[AnswerType] ([AnswerTypeID])
GO
ALTER TABLE [QuestionSet].[AnswerType] CHECK CONSTRAINT [FK_AnswerType_AnswerType]
GO
