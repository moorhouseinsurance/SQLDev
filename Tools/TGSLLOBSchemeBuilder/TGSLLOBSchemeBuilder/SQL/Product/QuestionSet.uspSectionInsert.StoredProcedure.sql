USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspSectionInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 16-DEC-2010
-- Description: Stored procedure to Insert a record into the Section table
-- =============================================
CREATE PROC [QuestionSet].[uspSectionInsert]
	 @GroupID bigint = NULL
	,@SectionName varchar(30)
	,@Text varchar(1000) = NULL
	,@SortOrder int
	,@InsertUserID bigint
AS

/* -- START

BEGIN TRAN

	DECLARE @GroupID bigint
	DECLARE @SectionName varchar(30)
	DECLARE @Text varchar(1000)
	DECLARE @SortOrder int
	DECLARE @InsertUserID bigint

	SET @GroupID = 2
	SET @SectionName = 'Assumptions'
	SET @Text = 'Assumptions'
	SET @SortOrder = 7
	SET @InsertUserID = 1

	SELECT * FROM [QuestionSet].[Section] ORDER BY [GroupID] DESC
	EXEC [QuestionSet].[uspSectionInsert] @GroupID, @SectionName, @Text, @SortOrder, @InsertUserID
	SELECT  * FROM [QuestionSet].[Section] ORDER BY [GroupID] DESC
	
ROLLBACK TRAN

*/ -- FINISH

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[Section]
	(
		 [GroupID]
		,[SectionName]
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
		 @GroupID
		,@SectionName
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
