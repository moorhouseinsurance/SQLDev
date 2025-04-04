USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionEnablementCriteriaSetLinkInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateInsertProcedure)
-- Create date: 05-JAN-2011
-- Description: Stored procedure to Insert a record into the QuestionEnablementCriteriaSetLink table
-- =============================================
CREATE PROC [QuestionSet].[uspQuestionEnablementCriteriaSetLinkInsert]
	 @QuestionID bigint
	,@EnablementCriteriaSetID bigint
	,@InsertUserID bigint
AS

/* 
	DECLARE @QuestionID bigint
	DECLARE @EnablementCriteriaSetID bigint
	DECLARE @InsertUserID bigint

	SET @QuestionID = 1
	SET @EnablementCriteriaSetID = 2
	SET @InsertUserID = 1

	EXEC [QuestionSet].[uspQuestionEnablementCriteriaSetLinkInsert] @QuestionID, @EnablementCriteriaSetID, @InsertUserID

*/

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[QuestionEnablementCriteriaSetLink]
	(
		 [QuestionID]
		,[EnablementCriteriaSetID]
		,[InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @QuestionID
		,@EnablementCriteriaSetID
		,@InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)
	RETURN CONVERT(bigint,SCOPE_IDENTITY()) 
END



GO
