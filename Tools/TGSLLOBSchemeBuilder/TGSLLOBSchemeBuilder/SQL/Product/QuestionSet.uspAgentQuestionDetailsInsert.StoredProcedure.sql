USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspAgentQuestionDetailsInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 16-DEC-2010
-- Description: Stored procedure to Insert a record into the AgentQuestionDetails table
-- =============================================
CREATE PROC [QuestionSet].[uspAgentQuestionDetailsInsert]
	 @QuestionID bigint
	,@AgentID char(32) = NULL
	,@AnswerDefaultValueOrID varchar(50) = NULL
	,@AnswerDefaultSet bit = 'False'
	,@AnswerTypeID bigint
	,@ChildQuestionRepeatMaximum int = NULL
	,@ChildQuestionRepeatMinimum int = NULL
	,@DevelopersNotes varchar(4000) = NULL
	,@Enabled bit = NULL
	,@HelpText varchar(1000) = NULL
	,@ListTableID int = NULL
	,@Mandatory bit = NULL
	,@MandatoryText varchar(1000) = NULL
	,@ParentQuestionID bigint = NULL
	,@QuickQuote bit = NULL
	,@SectionID bigint
	,@SortOrder int
	,@Text varchar(4000)
	,@Visible bit = 'True'
	,@StartDateTime datetime = '01 Jan 1990'
	,@InsertUserID bigint = 1
AS

/* 
BEGIN TRAN

	DECLARE @QuestionID bigint
	DECLARE @AgentID char(32)
	DECLARE @AnswerDefaultValueOrID varchar(50)
	DECLARE @AnswerDefaultSet bit
	DECLARE @AnswerTypeID bigint
	DECLARE @ChildQuestionRepeatMaximum int
	DECLARE @ChildQuestionRepeatMinimum int
	DECLARE @DevelopersNotes varchar(4000)
	DECLARE @Enabled bit
	DECLARE @HelpText varchar(1000)
	DECLARE @ListTableID int
	DECLARE @Mandatory bit
	DECLARE @MandatoryText varchar(1000)
	DECLARE @ParentQuestionID bigint
	DECLARE @QuickQuote bit
	DECLARE @SectionID bigint
	DECLARE @SortOrder int
	DECLARE @Text varchar(4000)
	DECLARE @Visible bit
	DECLARE @StartDateTime datetime
	DECLARE @InsertUserID bigint

	SET @QuestionID = 3
	SET @AgentID = NULL
	SET @AnswerDefaultValueOrID = NULL
	SET @AnswerDefaultSet = 'False'
	SET @AnswerTypeID = 1
	SET @ChildQuestionRepeatMaximum = NULL
	SET @ChildQuestionRepeatMinimum = NULL
	SET @DevelopersNotes = 'Phase using this as a left outer test in linq'
	SET @Enabled = 'True'
	SET @HelpText = 'Do you use 3 Phase'
	SET @ListTableID = NULL
	SET @Mandatory = 'False'
	SET @MandatoryText = NULL
	SET @ParentQuestionID = NULL
	SET @QuickQuote = NULL
	SET @SectionID = 1
	SET @SortOrder = 3
	SET @Text = '3- Phase'
	SET @Visible = 'True'
	SET @StartDateTime = '01 Jan 1990'
	SET @InsertUserID = 1


	SELECT TOP 5 * FROM [QuestionSet].[AgentQuestionDetails] ORDER BY [QuestionID] DESC
	EXEC [QuestionSet].[uspAgentQuestionDetailsInsert] @QuestionID, @AgentID, @AnswerDefaultValueOrID, @AnswerDefaultSet, @AnswerTypeID, @ChildQuestionRepeatMaximum, @ChildQuestionRepeatMinimum, @DevelopersNotes, @Enabled, @HelpText, @ListTableID, @Mandatory, @MandatoryText, @ParentQuestionID, @QuickQuote, @SectionID, @SortOrder, @Text, @Visible, @StartDateTime, @InsertUserID
	SELECT TOP 5 * FROM [QuestionSet].[AgentQuestionDetails] ORDER BY [QuestionID] DESC
	
ROLLBACK TRAN

*/

BEGIN

	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[AgentQuestionDetails]
	(
		 [QuestionID]
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
		,[Obsolete]
	)
	VALUES
	(
		 @QuestionID
		,@AgentID
		,@AnswerDefaultValueOrID
		,@AnswerDefaultSet
		,@AnswerTypeID
		,@ChildQuestionRepeatMaximum
		,@ChildQuestionRepeatMinimum
		,@DevelopersNotes
		,@Enabled
		,@HelpText
		,@ListTableID
		,@Mandatory
		,@MandatoryText
		,@ParentQuestionID
		,@QuickQuote
		,@SectionID
		,@SortOrder
		,@Text
		,@Visible
		,@StartDateTime
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity
END


GO
