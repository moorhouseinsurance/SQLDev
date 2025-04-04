USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspEnablementCriteriaSetInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler 
-- Create date: 05-JAN-2011
-- Description: Stored procedure to Insert a record into the EnablementCriteriaSet table
-- =============================================
CREATE PROC [QuestionSet].[uspEnablementCriteriaSetInsert]
	 @InsertUserID bigint = 1
AS

/* 

DECLARE @InsertUserID bigint
	EXEC [QuestionSet].[uspEnablementCriteriaSetInsert] @InsertUserID


*/ -- FINISH

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	DECLARE @DateTime AS datetime
	SET @DateTime = CAST(GETDATE() AS datetime)

	INSERT INTO [QuestionSet].[EnablementCriteriaSet]
	(
		 [InsertUserID]
		,[UpdateUserID]
		,[InsertDateTime]
		,[UpdateDateTime]
		,[Obsolete]
	)
	VALUES
	(
		 @InsertUserID
		,@InsertUserID
		,@DateTime
		,@DateTime
		,0
	)

	RETURN CONVERT(bigint,SCOPE_IDENTITY())

END


GO
