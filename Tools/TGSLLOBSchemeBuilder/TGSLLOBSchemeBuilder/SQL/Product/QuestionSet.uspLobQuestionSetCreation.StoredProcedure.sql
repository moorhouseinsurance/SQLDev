USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspLobQuestionSetCreation]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler 
-- Create date: 24-03-2014
-- Description: Stored procedure to Insert a New QuestionSet from the lob data
-- =============================================
CREATE PROC [QuestionSet].[uspLobQuestionSetCreation]
AS

/* 
BEGIN TRAN

	EXEC [QuestionSet].[uspLobQuestionSetCreation]

	DECLARE @QuestionSetID AS bigint
	SELECT @QuestionSetID = max(questionsetid) from [QuestionSet].[QuestionSet]
	
	SELECT * FROM [QuestionSet].[QuestionSet] WHERE [QuestionSetID] = @QuestionSetID
	SELECT * FROM [QuestionSet].[Question] WHERE QuestionSetId = @QuestionSetID
	SELECT * FROM [QuestionSet].[AgentQuestionDetails] AS  [A] JOIN  [QuestionSet].[Question] AS [Q] ON [A].[QuestionID] = [Q].[QuestionID] WHERE [Q].[QuestionSetID] = @QuestionSetID	
		
ROLLBACK TRAN
--cleanup

DECLARE @FromDate datetime
SET @FromDate = '25 Mar 2014'

DELETE FROM [QuestionSet].[AgentQuestionDetails] WHERE [InsertDateTime] > @FromDate
DELETE FROM [QuestionSet].[Question] WHERE [InsertDateTime] > @FromDate
DELETE FROM [QuestionSet].[QuestionSet] WHERE [InsertDateTime] > @FromDate
DELETE FROM [QuestionSet].[Section] WHERE [InsertDateTime] > @FromDate
DELETE FROM [QuestionSet].[Group] WHERE [InsertDateTime] > @FromDate

EXEC [QuestionSet].[uspLobQuestionSetCreation]

GO
--drop table [QuestionSet].[LobQuestionSetCreation]

CREATE TABLE [QuestionSet].[LobQuestionSetCreation](
	[UserID] [int] NULL,
	[QuestionSetName] [nvarchar](50) NULL,
	[AgentID] [char](32) NULL,
	[ProductID] [char](32) NULL,
	[DevelopersNotes] [nvarchar](4000) NULL,
	[GroupName] [nvarchar](30) NULL,
	[GroupText] [nvarchar](1000) NULL,
	[GroupSortOrder] [int] NULL,
	[SectionName] [nvarchar](30) NULL,
	[SectionText] [nvarchar](1000) NULL,
	[SectionSortOrder] [int] NULL,
	[AnswerTableName] [nvarchar](50) NULL,
	[AnswerFieldName] [nvarchar](50) NULL,
	[TailorQuoteFlag] [bit]  NULL,
	[AnswerDefaultValueOrID] [nvarchar](50) NULL,
	[AnswerDefaultSet] [bit] NOT NULL,
	[AnswerTypeName] [nvarchar](30) NULL,
	[Enabled] [bit] NOT NULL,
	[HelpText] [nvarchar](1000) NULL,
	[ListTableID] [int] NULL,
	[Mandatory] [bit] NOT NULL,
	[MandatoryText] [nvarchar](1000) NULL,
	[QuickQuote] [bit] NOT NULL,
	[QuestionSortOrder] [int] NULL,
	[QuestionText] [nvarchar](4000) NULL,
	[Visible] [bit] NOT NULL,
	[ParentAnswerTableName] [nvarchar](255) NULL,
	[ParentAnswerFieldName] [nvarchar](255) NULL
) ON [PRIMARY]

GO


INSERT INTO [QuestionSet].[LobQuestionSetCreation]
SELECT * FROM [MGL-IT001].[Product].[QuestionSet].[LobQuestionSetCreation]
*/ 

BEGIN
	SET NOCOUNT ON

-- Insert QuestionSet	
	DECLARE @DateTime datetime
	SET @DateTime = getdate()

INSERT INTO [Product].[QuestionSet].[QuestionSet]
	([QuestionSetName]
	,[AgentID]
	,[ProductID]
	,[DevelopersNotes]
	,[InsertUserID]
	,[UpdateUserID]
	,[InsertDateTime]
	,[UpdateDateTime]
	,[Obsolete])
SELECT DISTINCT
	 [L].[QuestionSetName]
	,[L].[AgentID]
	,[L].[ProductID]
	,[L].[DevelopersNotes]
	,[L].[UserID]
	,[L].[UserID]
	,@DateTime
	,@DateTime
	,0
FROM
	[QuestionSet].[LobQuestionSetCreation] AS [L]	

--Group
INSERT INTO [Product].[QuestionSet].[Group]
	([GroupName]
	,[Text]
	,[SortOrder]
	,[InsertUserID]
	,[UpdateUserID]
	,[InsertDateTime]
	,[UpdateDateTime]
	,[Obsolete])
SELECT DISTINCT
	 [L].[GroupName]
	,[L].[GroupText]
	,[L].[GroupSortOrder]
	,[L].[UserID]
	,[L].[UserID]
	,@DateTime
	,@DateTime
	,0	
FROM
	[QuestionSet].[LobQuestionSetCreation] AS [L]			

--Section
INSERT INTO [Product].[QuestionSet].[Section]
	([GroupID]
	,[SectionName]
	,[Text]
	,[SortOrder]
	,[InsertUserID]
	,[UpdateUserID]
	,[InsertDateTime]
	,[UpdateDateTime]
	,[Obsolete])
SELECT DISTINCT
	 [G].[GroupID]
	,[L].[SectionName]
	,[L].[SectionText]
	,[L].[SectionSortOrder]
	,[L].[UserID]
	,[L].[UserID]
	,@DateTime
	,@DateTime
	,0		
FROM
	[QuestionSet].[LobQuestionSetCreation] AS [L]
	JOIN [QuestionSet].[Group] AS [G] ON [L].[GroupName] = [G].[GroupName]

--Question
INSERT INTO [Product].[QuestionSet].[Question]
	([QuestionSetID]
	,[AnswerTableName]
	,[AnswerFieldName]
	,[TailorQuoteFlag]
	,[InsertUserID]
	,[UpdateUserID]
	,[InsertDateTime]
	,[UpdateDateTime]
	,[Obsolete])
SELECT 
	 [QS].[QuestionSetID]
	,[L].[AnswerTableName]
	,[L].[AnswerFieldName]
	,[L].[TailorQuoteFlag]
	,[L].[UserID]
	,[L].[UserID]
	,@DateTime
	,@DateTime
	,0
FROM
	[QuestionSet].[LobQuestionSetCreation] AS [L]	
	JOIN [QuestionSet].[QuestionSet] AS [QS] ON [L].[QuestionSetName] = [QS].[QuestionSetName]



--Insert AgentQuestionDetails
INSERT INTO [Product].[QuestionSet].[AgentQuestionDetails]
	([QuestionID]
	,[AgentID]
	,[AnswerDefaultValueOrID]
	,[AnswerDefaultSet]
	,[AnswerTypeID]
	,[ChildQuestionRepeatMaximum]
	,[ChildQuestionRepeatMinimum]
	,[DevelopersNotes]
	,[Enabled]
	,[HelpText]
	,[ListTableID]
	,[Mandatory]
	,[MandatoryText]
	,[ParentQuestionID]
	,[QuickQuote]
	,[SectionID]
	,[SortOrder]
	,[Text]
	,[Visible]
	,[StartDateTime]
	,[InsertUserID]
	,[UpdateUserID]
	,[InsertDateTime]
	,[UpdateDateTime]
	,[Obsolete])
	           
SELECT 
	 [Q].[QuestionID]
	,NULL
	,[L].[AnswerDefaultValueOrID]
	,[L].[AnswerDefaultSet]
	,[A].[AnswerTypeID]
	,NULL
	,NULL
	,NULL
	,[L].[Enabled]
	,[L].[HelpText]
	,[L].[ListTableID]
	,[L].[Mandatory]
	,[L].[MandatoryText]
	,[PQ].[QuestionID]
	,[L].[QuickQuote]
	,[S].[SectionID]
	,[L].[QuestionSortOrder]
	,[L].[QuestionText]
	,[L].[Visible]
	,'01 Jan 1990'
	,[L].[UserID]
	,[L].[UserID]
	,@DateTime
	,@DateTime
	,0      
FROM 
	[Product].[QuestionSet].[LobQuestionSetCreation] AS [L] 
	JOIN [Product].[QuestionSet].[Question] AS [Q] ON ([Q].[AnswerTableName] = [L].[AnswerTableName] AND [Q].[AnswerFieldName] = [L].[AnswerFieldName])
	JOIN [Product].[QuestionSet].[AnswerType] AS [A] ON ([A].[AnswerTypeName] = [L].[AnswerTypeName])		
	LEFT JOIN [Product].[QuestionSet].[Question] AS [PQ] ON ([L].[ParentAnswerTableName] = [PQ].[AnswerTableName] AND [PQ].[AnswerFieldName] = [L].[ParentAnswerFieldName])
	JOIN [Product].[QuestionSet].[Group] AS [G] ON [L].[GroupName] = [G].[GroupName]
	JOIN [Product].[QuestionSet].[Section] AS [S] ON [L].[SectionName] = [S].[SectionNAme] AND [G].[GroupID] = [S].[GroupID]

END

GO
