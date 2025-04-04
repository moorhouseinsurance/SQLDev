USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspLobLoad]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler 
-- Create date: 04-01-2011
-- Description: Stored procedure to Insert a New QuestionSet from the lob data
-- =============================================
CREATE PROC [QuestionSet].[uspLobLoad]
	  @QuestionSetName varchar(25)
	 ,@AgentID char(32)
	 ,@ProductID char(32)
	 ,@DevelopersNotes varchar(2000)
	 ,@InsertUserID bigint
AS

/* 
BEGIN TRAN

	DECLARE @QuestionSetName varchar(25)
	DECLARE @AgentID char(32)
	DECLARE @ProductID char(32)
	DECLARE @DevelopersNotes varchar(2000)
	DECLARE @InsertUserID bigint
	SET @InsertUserID = 1
	EXEC [QuestionSet].[uspLobLoad] @InsertUserID

	DECLARE @QuestionSetID AS bigint
	SET @QuestionSetID = 
	SELECT * FROM [QuestionSet].[QuestionSet] WHERE [QuestionSetID] = @QuestionSetID
	SELECT * FROM [QuestionSet].[Question] WHERE QuestionSetId = @QuestionSetID
	SELECT * FROM [QuestionSet].[AgentQuestionDetails] AS  [A] JOIN  [QuestionSet].[Question] AS [Q] ON [A].[QuestionID] = [Q].[QuestionID] WHERE [Q].[QuestionSetID] = @QuestionSetID	
		
ROLLBACK TRAN
--cleanup
DECLARE @FromDate datetime
SET @FromDate = '16 Mar 2011'

DELETE FROM [QuestionSet].[QuestionSet] WHERE [InsertDateTime] > @FromDate

*/ 

BEGIN
	SET NOCOUNT ON

-- Insert QuestionSet	
	DECLARE @DateTime datetime
	SET @DateTime = getdate()
	DECLARE @QuestionSetID AS bigint
	EXEC @QuestionSetID = [QuestionSet].[uspQuestionSetInsert] @QuestionSetName, @AgentID, @ProductID, @DevelopersNotes, @InsertUserID


--Insert Questions

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
		   @QuestionSetID
		  ,[AnswerTableName]
		  ,[AnswerFieldName]
		  ,[TailorQuoteFlag]
		  ,@InsertUserID
		  ,@InsertUserID
		  ,@DateTime
		  ,@DateTime
		  ,0
	  FROM [Product].[dbo].[QSEnablementCriteria]


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
		,[LOB].[AnswerDefaultValueOrID]
		,[LOB].[AnswerDefaultSet]
		,[A].[AnswerTypeID]
		,NULL
		,NULL
		,NULL
		,[LOB].[Enabled]
		,[LOB].[HelpText]
		,[LOB].[ListTableID]
		,[LOB].[Mandatory]
		,[LOB].[MandatoryText]
		,[PQ].[QuestionID]
		,[LOB].[QuickQuote]
		,[LOB].[SectionID]
		,[LOB].[SortOrder]
		,[LOB].[Text]
		,[LOB].[Visible]
		,'01 Jan 1990'
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0      
	FROM 
		[Product].[QuestionSet].[Question] AS [Q]
		JOIN [Product].[dbo].[QSEnablementCriteria] AS [LOB] ON ([Q].[AnswerTableName] = [LOB].[AnswerTableName] AND[Q].[AnswerFieldName] = [LOB].[AnswerFieldName])
		LEFT JOIN [Product].[QuestionSet].[Question] AS [PQ] ON ([LOB].[ParentAnswerTableName] = [PQ].[AnswerTableName] AND [PQ].[AnswerFieldName] = [LOB].[ParentAnswerFieldName])
		JOIN [Product].[QuestionSet].[AnswerType] AS [A] ON ([A].[AnswerTypeName] = [LOB].[AnswerTypeName])

	-- Insert Calculations

	--DECLARE @ParameterValue decimal(18,2)
	--DECLARE @ParameterValueFunctionID int
	--DECLARE @CalculatedQuestionID bigint
	--DECLARE @ParameterQuestionID bigint
	--DECLARE @Position int
	--DECLARE @Operator char(3)
	--DECLARE @InsertUserID bigint

	--SET @CalculatedQuestionID = 54
	--SET @ParameterQuestionID = 49
	--SET @ParameterValue = NULL
	--SET @ParameterValueFunctionID = NULL
	--SET @Position = 1
	--SET @Operator = '+'
	--SET @InsertUserID = 1

	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID

	--SET @ParameterQuestionID = 50
	--SET @Position = 2
	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID

	--SET @ParameterQuestionID = 51
	--SET @Position = 3
	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID

	--SET @ParameterQuestionID = 52
	--SET @Position = 4
	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID

	--SET @ParameterQuestionID = 53
	--SET @Position = 5
	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID

	--SET @CalculatedQuestionID = 58
	--SET @ParameterQuestionID = NULL
	--SET @ParameterValue = NULL
	--SET @ParameterValueFunctionID = 2
	--SET @Position = 1
	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID


	--SET @CalculatedQuestionID = 58
	--SET @ParameterQuestionID = 57
	--SET @ParameterValueFunctionID = NULL
	--SET @Operator = '-'
	--SET @Position = 2

	--EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID
END

GO
