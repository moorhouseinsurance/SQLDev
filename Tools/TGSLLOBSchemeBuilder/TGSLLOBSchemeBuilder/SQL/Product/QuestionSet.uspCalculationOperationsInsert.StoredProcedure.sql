USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspCalculationOperationsInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler 
-- Create date: 04-05-2011
-- Description: Inserts Calculation Operations for  questions
-- =============================================
CREATE PROC [QuestionSet].[uspCalculationOperationsInsert]
	 @InsertUserID bigint
AS

/* 
BEGIN TRAN

	DECLARE @InsertUserID bigint
	
	SET @InsertUserID = 1
	EXEC [QuestionSet].[uspCalculationOperationsInsert] @InsertUserID


ROLLBACK TRAN

  

*/ 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON

DECLARE @DateTime AS datetime
SET @DateTime = CAST(GETDATE() AS datetime)

INSERT INTO [Product].[QuestionSet].[CalculatedQuestionOperation]
           ([CalculatedQuestionID]
           ,[ParameterQuestionID]
           ,[ParameterValue]
           ,[ParameterValueFunctionID]
           ,[Position]
           ,[Operator]
           ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])
SELECT 
	 [Q].[QuestionID]
	,[P].[QuestionID]
	,[CQ].[ParameterValue]
	,[F].[ComparatorValueFunctionID]
	,[CQ].[Position]
	,[CQ].[Operator]
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,'False'
	
FROM
	[dbo].[QSCalculationOperation] AS [CQ]
	JOIN [QuestionSet].[Question] AS [Q] ON ([CQ].[Answertablename] = [Q].[AnswerTableName] AND [CQ].[AnswerFieldName] = [Q].[AnswerFieldName] )
	LEFT JOIN [QuestionSet].[Question] AS [P] ON ([CQ].[ParameterTableName] = [P].[AnswerTableName] AND [CQ].[ParameterFieldName] = [P].[AnswerFieldName]) 	 
	LEFT JOIN [QuestionSet].[tvfComparatorValueFunction](0) AS [F] ON [CQ].[ParameterValueFunctionName] = [F].[FunctionName]
END


GO
