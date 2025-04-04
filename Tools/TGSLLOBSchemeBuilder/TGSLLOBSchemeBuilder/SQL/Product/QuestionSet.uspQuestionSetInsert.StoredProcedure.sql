USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionSetInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 14-DEC-2010
-- Description: Stored procedure to Insert a record into the QuestionSet table
-- =============================================
CREATE PROC [QuestionSet].[uspQuestionSetInsert]
	 @QuestionSetName varchar(255) = NULL
	,@AgentID char(32) = NULL
	,@ProductID char(32) = NULL
	,@DevelopersNotes varchar(2000) = NULL
	,@InsertUserID bigint
AS

/* 
BEGIN TRAN
	DECLARE @QuestionSetName varchar(25)
	DECLARE @AgentID char(16)
	DECLARE @ProductID char(16)
	DECLARE @DevelopersNotes varchar(2000)
	DECLARE @InsertUserID bigint

	SET @QuestionSetName = 'Commercial Office' 
	--SET @AgentID = '0F849A389DD4477CAF66BBCBECA49AA4'
	SET @ProductID = '3C885E4C613B4B1FB279C313E43ABC1E'
	SET @DevelopersNotes = 'This is the Commercial Office Question Set for all Agents.'
	SET @InsertUserID = 1

	SELECT TOP 5 * FROM [QuestionSet].[QuestionSet] ORDER BY [QuestionSetName] DESC
	EXEC [QuestionSet].[uspQuestionSetInsert] @QuestionSetName, @AgentID, @ProductID, @DevelopersNotes, @InsertUserID
	SELECT TOP 5 * FROM [QuestionSet].[QuestionSet] ORDER BY [QuestionSetName] DESC
ROLLBACK TRAN

*/ 

BEGIN

	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)
	
	IF @ProductID IS NULL
	SELECT @ProductID = [Product_ID] FROM [dbo].[RM_Product] WHERE [Name] = @QuestionSetName;

	INSERT INTO [QuestionSet].[QuestionSet]
	(
		 [QuestionSetName]
		,[AgentID]
		,[ProductID]
		,[DevelopersNotes]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @QuestionSetName
		,@AgentID
		,@ProductID
		,@DevelopersNotes
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	SELECT CONVERT(bigint,SCOPE_IDENTITY()) AS InsertIdentity
END




GO
