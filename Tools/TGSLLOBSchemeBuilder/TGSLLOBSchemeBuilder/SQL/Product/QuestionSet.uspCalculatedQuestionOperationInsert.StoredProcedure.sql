USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspCalculatedQuestionOperationInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 05-JAN-2011
-- Description: Stored procedure to Insert a record into the CalculatedQuestionOperation table
-- =============================================
CREATE PROC [QuestionSet].[uspCalculatedQuestionOperationInsert]
	 @CalculatedQuestionID bigint
	,@ParameterQuestionID bigint
	,@ParameterValue decimal(18,2)
	,@ParameterValueFunctionID int
	,@Position int
	,@Operator varchar(6)
	,@InsertUserID bigint = 1
AS

/* 

BEGIN TRAN

	DECLARE @CalculatedQuestionID bigint
	DECLARE @ParameterQuestionID bigint
	DECLARE @ParameterValue decimal(18,2)
	DECLARE @ParameterValueFunctionID int	
	DECLARE @Position int
	DECLARE @Operator char(6)
	DECLARE @InsertUserID bigint

	SET @CalculatedQuestionID = 10
	SET @ParameterQuestionID = 11
	SET @ParameterValue = 
	SET @ParameterValueFunctionID =
	SET @Position = 1
	SET @Operator = '+'
	SET @InsertUserID = 1

	SELECT TOP 5 * FROM [QuestionSet].[CalculatedQuestionOperation] ORDER BY [CalculatedQuestionID] DESC
	EXEC [QuestionSet].[uspCalculatedQuestionOperationInsert] @CalculatedQuestionID, @ParameterQuestionID, @ParameterValue, @ParameterValueFunctionID, @Position, @Operator, @InsertUserID
	SELECT TOP 5 * FROM [QuestionSet].[CalculatedQuestionOperation] ORDER BY [CalculatedQuestionID] DESC
ROLLBACK TRAN

*/ 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[CalculatedQuestionOperation]
	(
		 [CalculatedQuestionID]
		,[ParameterQuestionID]
		,[ParameterValue]
		,[ParameterValueFunctionID]
		,[Position]
		,[Operator]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @CalculatedQuestionID
		,@ParameterQuestionID
		,@ParameterValue
		,@ParameterValueFunctionID
		,@Position
		,@Operator
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity
END




GO
