USE [Product]
GO
/****** Object:  Table [QuestionSet].[EnablementCriteriaList]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[EnablementCriteriaList](
	[EnablementCriteriaListID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsertUserID] [bigint] NOT NULL,
	[UpdateUserID] [bigint] NOT NULL,
	[InsertDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Obsolete] [bit] NOT NULL,
 CONSTRAINT [PK_EnablementCriteriaList] PRIMARY KEY CLUSTERED 
(
	[EnablementCriteriaListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
