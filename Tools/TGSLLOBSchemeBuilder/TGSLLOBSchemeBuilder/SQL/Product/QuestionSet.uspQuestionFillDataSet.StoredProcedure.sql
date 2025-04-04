USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionFillDataSet]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler (using stored procedure - ObjectCreateSearchProcedure)
-- Create date: 15-DEC-2010
-- Description: Stored procedure to Search for records from the [QuestionSet].Question table
-- =============================================
CREATE PROC [QuestionSet].[uspQuestionFillDataSet]
	 @QuestionSetID bigint = NULL
AS
--	TEST HARNESS
--	To test this procedure, copy the whole commented section into a new query window, remove the lines
--	marked START and FINISH and run the statement

/* -- START

DECLARE @QuestionSetID bigint
SET @QuestionSetID = NULL

EXEC [QuestionSet].[uspQuestionSearch] @QuestionSetID
*/ -- FINISH

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

	SELECT 
		 [Q].[QuestionID]
		,[Q].[QuestionSetID]
		,[Q].[AnswerTableName]
		,[Q].[AnswerFieldName]
		,[Q].[TailorQuoteFlag]
	FROM [QuestionSet].[Question] AS [Q] 
	WHERE 
		isnull([Q].[Obsolete],0) = 0 
		AND (@QuestionSetID IS NULL OR [Q].[QuestionSetID] = @QuestionSetID)
	ORDER BY [Q].[QuestionID], [Q].[QuestionSetID], [Q].[AnswerTableName], [Q].[AnswerFieldName], [Q].[TailorQuoteFlag]
END


GO
