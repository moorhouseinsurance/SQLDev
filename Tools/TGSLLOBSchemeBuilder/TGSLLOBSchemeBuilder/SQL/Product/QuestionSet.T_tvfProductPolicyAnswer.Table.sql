USE [Product]
GO
/****** Object:  Table [QuestionSet].[T_tvfProductPolicyAnswer]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [QuestionSet].[T_tvfProductPolicyAnswer](
	[QuestionID] [bigint] NULL,
	[PrimaryKeyID] [varchar](32) NULL,
	[TableName] [varchar](50) NULL,
	[FieldName] [varchar](50) NULL,
	[FieldValue] [varchar](4000) NULL
) ON [PRIMARY]

GO
