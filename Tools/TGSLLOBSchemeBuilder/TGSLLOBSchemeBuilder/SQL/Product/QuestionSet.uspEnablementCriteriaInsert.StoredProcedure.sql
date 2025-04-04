USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspEnablementCriteriaInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 05-JAN-2011
-- Description: Stored procedure to Insert a record into the EnablementCriteria table
-- =============================================
CREATE PROC [QuestionSet].[uspEnablementCriteriaInsert]
	 @EnablementCriteriaSetID bigint
	,@ComparatorQuestionID bigint
	,@ComparatorValueOrID varchar(1000) = NULL
	,@ComparatorValueFunctionID int = NULL
	,@Operator varchar(2)
	,@EnablementCriteriaListID bigint
	,@InsertUserID bigint
AS


/* 
BEGIN TRAN
	DECLARE @EnablementCriteriaSetID bigint
	DECLARE @ComparatorQuestionID bigint
	DECLARE @ComparatorValueOrID varchar(1000)
	DECLARE @ComparatorValueFunctionID int
	DECLARE @Operator varchar(2)
	DECLARE @EnablementCriteriaListID bigint
	DECLARE @InsertUserID bigint

	SET @EnablementCriteriaSetID = 2
	SET @ComparatorQuestionID = 2
	SET @ComparatorValueOrID = '3N10P642'
	SET @ComparatorValueFunctionID = NULL
	SET @Operator = '=='
	SET @EnablementCriteriaListID = NULL
	SET @InsertUserID = 1


	SELECT * FROM [QuestionSet].[EnablementCriteria] ORDER BY [EnablementCriteriaSetID] DESC
	EXEC [QuestionSet].[uspEnablementCriteriaInsert] @EnablementCriteriaSetID, @ComparatorQuestionID, @ComparatorValueOrID, @ComparatorValueFunctionID, @Operator, @EnablementCriteriaListID, @InsertUserID
	SELECT * FROM [QuestionSet].[EnablementCriteria] ORDER BY [EnablementCriteriaSetID] DESC
ROLLBACK TRAN
*/ 

BEGIN

	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[EnablementCriteria]
	(
		 [EnablementCriteriaSetID]
		,[ComparatorQuestionID]
		,[ComparatorValueOrID]
		,[ComparatorValueFunctionID]
		,[Operator]
		,[EnablementCriteriaListID]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @EnablementCriteriaSetID
		,@ComparatorQuestionID
		,@ComparatorValueOrID
		,@ComparatorValueFunctionID
		,@Operator
		,@EnablementCriteriaListID
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	RETURN CONVERT(bigint,SCOPE_IDENTITY()) 
END



GO
