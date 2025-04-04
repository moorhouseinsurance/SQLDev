USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionSetSelect]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateSelectProcedure)
-- Create date: Dec 14 2010  4:25PM
-- Description: Stored procedure to Select a single record from the [QuestionSet].[QuestionSet] table
-- =============================================
CREATE PROC [QuestionSet].[uspQuestionSetSelect]
	@QuestionSetID bigint
AS
--	TEST HARNESS
--	To test this procedure, copy the whole commented section into a new query window, remove the lines
--	marked START and FINISH and run the statement

/* -- START

DECLARE @QuestionSetID bigint

SET @QuestionSetID = 1

EXEC [QuestionSet].[uspQuestionSetSelect] @QuestionSetID

*/ -- FINISH

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON
-- [QuestionSet].[QuestionSet] Select Statement
	SELECT
		 [QS].[QuestionSetID]
		,[QS].[QuestionSetName]
		,[QS].[AgentID]
		,[QS].[ProductID]
		,[QS].[DevelopersNotes]
		,[QS].[InsertUserID]
		,[QS].[UpdateUserID]
		,[QS].[InsertDateTime]
		,[QS].[UpdateDateTime]
		,[QS].[Obsolete]
	FROM [QuestionSet].[QuestionSet] AS [QS]
	WHERE  [QS].[QuestionSetID] = @QuestionSetID
END

GO
