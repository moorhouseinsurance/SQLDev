USE [Product]
GO
/****** Object:  User [TGSLUser]    Script Date: 3/19/2018 12:03:16 PM ******/
CREATE USER [TGSLUser] FOR LOGIN [TGSLUser] WITH DEFAULT_SCHEMA=[QuestionSet]
GO
ALTER ROLE [db_owner] ADD MEMBER [TGSLUser]
GO
