USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspAnswerTypeInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 16-DEC-2010
-- Description: Stored procedure to Insert a record into the AnswerType table
-- =============================================
CREATE PROC [QuestionSet].[uspAnswerTypeInsert]
	 @AnswerTypeName varchar(30)
	,@AnswerTypeBaseTypeID bigint
	,@Regex varchar(255) = NULL
	,@StartRange varchar(20) = NULL
	,@EndRange varchar(20) = NULL
	,@Length int
	,@InsertUserID bigint
AS
--	TEST HARNESS
--	To test this procedure, copy the whole commented section into a new query window, remove the lines
--	marked START and FINISH and run the statement

/* -- START

BEGIN TRAN

	DECLARE @AnswerTypeName varchar(30)
	DECLARE @AnswerTypeBaseTypeID bigint
	DECLARE @Regex varchar(255)
	DECLARE @StartRange varchar(20)
	DECLARE @EndRange varchar(20)
	DECLARE @Length int
	DECLARE @InsertUserID bigint

	SET @AnswerTypeName = 'Email'
	SET @AnswerTypeBaseTypeID = 3
	SET @Regex = '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$'
	SET @StartRange = NULL
	SET @EndRange = NULL
	SET @Length = 50
	SET @InsertUserID = 1 

	SELECT * FROM [QuestionSet].[AnswerType] ORDER BY [AnswerTypeName] ASC
	EXEC [QuestionSet].[uspAnswerTypeInsert] @AnswerTypeName, @AnswerTypeBaseTypeID, @Regex, @StartRange, @EndRange, @Length, @InsertUserID
	SELECT  * FROM [QuestionSet].[AnswerType] ORDER BY [AnswerTypeName] ASC
	
ROLLBACK TRAN

*/ -- FINISH

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[AnswerType]
	(
		 [AnswerTypeName]
		,[AnswerTypeBaseTypeID]
		,[Regex]
		,[StartRange]
		,[EndRange]
		,[Length]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @AnswerTypeName
		,@AnswerTypeBaseTypeID
		,@Regex
		,@StartRange
		,@EndRange
		,@Length
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)
END

-- Return Identity of the insert
SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity


GO
