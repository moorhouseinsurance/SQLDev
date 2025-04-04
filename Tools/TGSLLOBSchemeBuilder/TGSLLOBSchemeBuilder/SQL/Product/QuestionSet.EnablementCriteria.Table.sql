USE [Product]
GO
/****** Object:  Table [QuestionSet].[EnablementCriteria]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[EnablementCriteria](
	[EnablementCriteriaID] [bigint] IDENTITY(1,1) NOT NULL,
	[EnablementCriteriaSetID] [bigint] NOT NULL,
	[ComparatorQuestionID] [bigint] NOT NULL,
	[ComparatorValueOrID] [varchar](1000) NULL,
	[ComparatorValueFunctionID] [int] NULL,
	[Operator] [varchar](2) NOT NULL,
	[EnablementCriteriaListID] [bigint] NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_EnablementCriteriaID] PRIMARY KEY CLUSTERED 
(
	[EnablementCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[EnablementCriteria]  WITH CHECK ADD  CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaList] FOREIGN KEY([EnablementCriteriaListID])
REFERENCES [QuestionSet].[EnablementCriteriaList] ([EnablementCriteriaListID])
GO
ALTER TABLE [QuestionSet].[EnablementCriteria] CHECK CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaList]
GO
ALTER TABLE [QuestionSet].[EnablementCriteria]  WITH CHECK ADD  CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaSet] FOREIGN KEY([EnablementCriteriaSetID])
REFERENCES [QuestionSet].[EnablementCriteriaSet] ([EnablementCriteriaSetID])
GO
ALTER TABLE [QuestionSet].[EnablementCriteria] CHECK CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaSet]
GO
ALTER TABLE [QuestionSet].[EnablementCriteria]  WITH CHECK ADD  CONSTRAINT [FK_EnablementCriteria_Question] FOREIGN KEY([ComparatorQuestionID])
REFERENCES [QuestionSet].[Question] ([QuestionID])
GO
ALTER TABLE [QuestionSet].[EnablementCriteria] CHECK CONSTRAINT [FK_EnablementCriteria_Question]
GO
