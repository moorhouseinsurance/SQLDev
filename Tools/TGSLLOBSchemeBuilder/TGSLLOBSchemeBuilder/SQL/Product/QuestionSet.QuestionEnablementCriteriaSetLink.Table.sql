USE [Product]
GO
/****** Object:  Table [QuestionSet].[QuestionEnablementCriteriaSetLink]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink](
	[QuestionEnablementCriteriaSetLinkID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuestionID] [bigint] NOT NULL,
	[EnablementCriteriaSetID] [bigint] NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_QuestionEnablementCriteriaSetLinktID] PRIMARY KEY CLUSTERED 
(
	[QuestionEnablementCriteriaSetLinkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink]  WITH CHECK ADD  CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet] FOREIGN KEY([EnablementCriteriaSetID])
REFERENCES [QuestionSet].[EnablementCriteriaSet] ([EnablementCriteriaSetID])
GO
ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink] CHECK CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet]
GO
ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink]  WITH CHECK ADD  CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_Question] FOREIGN KEY([QuestionID])
REFERENCES [QuestionSet].[Question] ([QuestionID])
GO
ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink] CHECK CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_Question]
GO
