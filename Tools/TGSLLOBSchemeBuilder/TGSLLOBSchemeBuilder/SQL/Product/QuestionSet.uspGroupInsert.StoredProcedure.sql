USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspGroupInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 16-DEC-2010
-- Description: Stored procedure to Insert a record into the Group table
-- =============================================
CREATE PROC [QuestionSet].[uspGroupInsert]
	 @GroupName varchar(30)
	,@Text varchar(500) = NULL
	,@SortOrder int
	,@InsertUserID bigint
AS

/* 
BEGIN TRAN

	DECLARE @GroupName varchar(30)
	DECLARE @Text varchar(1000)
	DECLARE @SortOrder int
	DECLARE @InsertUserID bigint

	SET @GroupName = 'Goods In Transit Courier'
	SET @Text = 'Goods In Transit Courier'
	SET @SortOrder = 1
	SET @InsertUserID = 1

	SELECT * FROM [QuestionSet].[Group] ORDER BY [GroupName] DESC
	EXEC [QuestionSet].[uspGroupInsert] @GroupName, @Text, @SortOrder, @InsertUserID
	SELECT * FROM [QuestionSet].[Group] ORDER BY [GroupName] DESC
	
ROLLBACK TRAN

*/ 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[Group]
	(
		 [GroupName]
		,[Text]
		,[SortOrder]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @GroupName
		,@Text
		,@SortOrder
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
