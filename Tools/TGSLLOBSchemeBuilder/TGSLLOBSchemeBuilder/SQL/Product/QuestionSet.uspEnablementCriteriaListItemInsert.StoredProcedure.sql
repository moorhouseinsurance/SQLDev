USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspEnablementCriteriaListItemInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 06-JAN-2011
-- Description: Stored procedure to Insert a record into the EnablementCriteriaList table
-- =============================================
CREATE PROC [QuestionSet].[uspEnablementCriteriaListItemInsert]
	 @EnablementCriteriaListID bigint
	,@ListValue varchar(100)
	,@InsertUserID bigint
AS

/* 
BEGIN TRAN
	DECLARE @EnablementCriteriaListID bigint
	DECLARE @ListValue varchar(100)
	DECLARE @InsertUserID bigint

	SET @EnablementCriteriaListID = 
	SET @ListValue = 
	SET @InsertUserID = 

	SELECT * FROM [QuestionSet].[EnablementCriteriaList] ORDER BY [EnablementCriteriaListID] DESC
	EXEC [QuestionSet].[uspEnablementCriteriaListItemInsert] @EnablementCriteriaListID, @ListValue, @InsertUserID
	SELECT * FROM [QuestionSet].[EnablementCriteriaListItem] ORDER BY [EnablementCriteriaListID] DESC
ROLLBACK TRAN

*/ 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[EnablementCriteriaListItem]
	(
		 [EnablementCriteriaListID]
		,[ListValue]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @EnablementCriteriaListID
		,@ListValue
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity
END




GO
