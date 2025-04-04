USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 15-DEC-2010
-- Description: Stored procedure to Insert a record into the Question table
-- =============================================
CREATE PROC [QuestionSet].[uspQuestionInsert]
	 @QuestionSetID bigint = NULL
	,@AnswerTableName varchar(50)
	,@AnswerFieldName varchar(50)
	,@TailorQuoteFlag bit = NULL
	,@InsertUserID bigint = 1
AS

/* 
BEGIN TRAN

	DECLARE @QuestionSetID bigint
	DECLARE @AnswerTableName varchar(50)
	DECLARE @AnswerFieldName varchar(50)
	DECLARE @TailorQuoteFlag bit = 'False'
	DECLARE @InsertUserID bigint = 1

	SET @QuestionSetID = 1
	SET @AnswerTableName = 'USER_MLIAB_TRDDTAIL'
	SET @AnswerFieldName = 'PRIMARYRISK_ID'
	SET @TailorQuoteFlag = 1
	SET @InsertUserID = 1

	SELECT TOP 5 * FROM [QuestionSet].[Question] ORDER BY [QuestionSetID] DESC
	EXEC [QuestionSet].[uspQuestionInsert] @QuestionSetID, @AnswerTableName, @AnswerFieldName, @TailorQuoteFlag, @InsertUserID
	SELECT TOP 5 * FROM [QuestionSet].[Question] ORDER BY [QuestionSetID] DESC
	
ROLLBACK TRAN

*/ 

BEGIN
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[Question]
	(
		 [QuestionSetID]
		,[AnswerTableName]
		,[AnswerFieldName]
		,[TailorQuoteFlag]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @QuestionSetID
		,@AnswerTableName
		,@AnswerFieldName
		,@TailorQuoteFlag
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity
END


GO
