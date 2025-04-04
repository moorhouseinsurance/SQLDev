USE [Product]
GO
/****** Object:  Table [Content].[Insurer]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Content].[Insurer](
	[InsurerSurrogateID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsurerID] [nvarchar](8) NULL,
	[Name] [nvarchar](255) NULL,
	[InsurerDetails] [nvarchar](max) NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[InsurerSurrogateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
