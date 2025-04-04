USE [Product]
GO
/****** Object:  Table [QuestionSet].[EnablementCriteriaListItem]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[EnablementCriteriaListItem](
	[EnablementCriteriaListItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[EnablementCriteriaListID] [bigint] NOT NULL,
	[ListValue] [varchar](100) NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_EnablementCriteriaListItem] PRIMARY KEY CLUSTERED 
(
	[EnablementCriteriaListItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [QuestionSet].[EnablementCriteriaListItem]  WITH CHECK ADD  CONSTRAINT [FK_EnablementCriteriaListItem_EnablementCriteriaList] FOREIGN KEY([EnablementCriteriaListID])
REFERENCES [QuestionSet].[EnablementCriteriaList] ([EnablementCriteriaListID])
GO
ALTER TABLE [QuestionSet].[EnablementCriteriaListItem] CHECK CONSTRAINT [FK_EnablementCriteriaListItem_EnablementCriteriaList]
GO
