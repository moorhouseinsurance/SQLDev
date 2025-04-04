USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspProductPolicyAnswerTablesInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Name:    [QuestionSet].[uspProductPolicyAnswerTablesInsert] 
-- Author:  Devlin Hostler
-- date:    09 Mar 2018
-- Description: Adds answer tables for a LOB to the tvf  [QuestionSet].[tvfProductPolicyAnswer] for a given QuestionSet
*******************************************************************************/
CREATE PROCEDURE [QuestionSet].[uspProductPolicyAnswerTablesInsert]
(
	  @QuestionSetID bigint
)

AS

/*
	SELECT * FROM [QuestionSet].[QuestionSet]

	DECLARE @QuestionSetID int = 13
	EXEC [QuestionSet].[uspProductPolicyAnswerTablesInsert] @QuestionSetID


	DECLARE @SQLSynonym varchar(max) = ''
	
	SELECT
		@SQLSynonym = @SQLSynonym + 'DROP SYNONYM [dbo].[' + [AnswerTableName] + '];' 
	FROM 
		[QuestionSet].[Question] AS [T1]
		JOIN [QuestionSet].[AgentQuestionDetails] AS [AQDT1] ON [T1].[QuestionID] = [AQDT1].[QuestionID]
	WHERE 
		[T1].[QuestionSetID] = @QuestionSetID

		exec @SQLSynonym


	--exec(@sql)
	--SET @SQL = replace(@SQL , @ListTableName , @ListTableName+'_VIEW')
	--EXEC(@SQL)

	exec [QuestionSet].[uspListTableInsert] @ListTableName
	SELECT * FROM [QuestionSet].[ListTable]
--	SELECT [Definition] FROM sys.sql_modules WHERE object_id=object_id('QuestionSet.tvfListTable')

	DECLARE @ListTableName varchar(255) = 'LIST_MH_Trade'
		exec [QuestionSet].[uspListTableInsert] @ListTableName

*/


BEGIN
	SET NOCOUNT ON

	DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
	DECLARE @XMLNewLine varchar(6) = '&#x0D;'
	DECLARE @XMLOtherLineCode varchar(6) = 'x0D;'

	DECLARE  @ProductID char(32)
			,@QuestionSetName varchar(255)
	SELECT @ProductID = [ProductID]  ,@QuestionSetName = [QuestionSetName] FROM [QuestionSet].[QuestionSet] WHERE [QuestionSetID] = @QuestionSetID;

	DECLARE @SQLSynonyms varchar(max) = '';
	DECLARE @SQLTables varchar(max) = '';

	DECLARE @SQLSynonym varchar(255) ='CREATE SYNONYM [dbo].[{AnswerTableName}] for [Transactor_UAT].[dbo].[{AnswerTableName}];'
	DECLARE @SQLTableSingle varchar(4000) = 
'			(
				SELECT * FROM [dbo].[{AnswerTableName}] AS [T] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH(''{AnswerTableName}''), TYPE
			)
'
	DECLARE @SQLTableLinked varchar(4000) = 
'			(
				SELECT [T1].* FROM [dbo].[{ParentTableName}] AS [T] JOIN [dbo].[{AnswerTableName}] AS [T1] ON [T1].[{PrimaryForeignKey}] = [T].[{PrimaryForeignKey}] WHERE [T].[Policy_Details_ID] = @Policy_Details_ID AND [T].[History_ID] = @PolicyDetailsHistory_ID
				FOR	XML PATH(''{AnswerTableName}''), TYPE
			)
'
	;WITH [DT] AS
	(
		SELECT DISTINCT 
			 [T1].[AnswerTableName] 
			,[T2].[AnswerTableName] AS [ParentTableName]
			,REPLACE([T2].[AnswerTableName]  ,'USER_','') + '_ID' AS [PrimaryForeignKey]
		FROM 
			[QuestionSet].[Question] AS [T1]
			JOIN [QuestionSet].[AgentQuestionDetails] AS [AQDT1] ON [T1].[QuestionID] = [AQDT1].[QuestionID]
			LEFT JOIN [QuestionSet].[Question] AS [T2] ON [AQDT1].[ParentQuestionID] = [T2].[QuestionID]
		WHERE 
			[T1].[QuestionSetID] = @QuestionSetID
	)
	,[SQL] AS 
	(
		SELECT 
			 REPLACE(@SQLSynonym ,'{AnswerTableName}' , [AnswerTableName]) AS [SQLSynonym]
			,COALESCE(
				 REPLACE(REPLACE(REPLACE(@SQLTableLinked ,'{AnswerTableName}' , [AnswerTableName]) ,'{ParentTableName}' ,[ParentTableName]) ,'{PrimaryForeignKey}' ,[PrimaryForeignKey])
				,REPLACE(@SQLTableSingle ,'{AnswerTableName}' , [AnswerTableName]) 
			) AS [SQLTable]

		FROM
			[DT]
	)
	SELECT
		 @SQLSynonyms = @SQLSynonyms + @NewLineChar + [SQLSynonym]
		,@SQLTables =  REPLACE(REPLACE(STUFF((SELECT '			,'+@NewLineChar + [SQLTable] FROM [SQL] FOR XML PATH('')),1,6,''),@XMLNewLine ,''),@XMLOtherLineCode , '')
	FROM 
		[SQL]

	SELECT
		 @SQLSynonyms 
		,@SQLTables 

	PRINT @SQLSynonyms

	DECLARE @SQL varchar(max) = 
		'
	IF @Product_ID = '''+ @ProductID + ''' --' + @QuestionSetName + '
	BEGIN
		SELECT @xml =
		(
			SELECT{@SQLTables}			FOR XML PATH (''''), ELEMENTS XSINIL
		)
	END	

	/*Insert New LOB tables Here*/
		'	
	SET @SQL = REPLACE(@SQL , '{@SQLTables}' , @SQLTables)


	DECLARE @SQLtvfProductPolicyAnswer varchar(max) = (SELECT [Definition] FROM sys.sql_modules WHERE object_id=object_id('QuestionSet.tvfProductPolicyAnswer'))

	SET @SQLtvfProductPolicyAnswer  = REPLACE(@SQLtvfProductPolicyAnswer,'/*Insert New LOB tables Here*/',@SQL)
	SET @SQLtvfProductPolicyAnswer  = REPLACE(@SQLtvfProductPolicyAnswer,'CREATE Function','ALTER Function')

	EXEC(@SQLSynonyms);
	EXEC(@SQLtvfProductPolicyAnswer)

END



GO
