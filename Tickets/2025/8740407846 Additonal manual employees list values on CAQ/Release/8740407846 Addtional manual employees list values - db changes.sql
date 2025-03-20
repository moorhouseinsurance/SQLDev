USE [Product]
GO

UPDATE [QuestionSet].[ListTable]
SET [ListTableName] = 'tvfListTable (' + [ListTableName] + ')'
WHERE [ListTableID] IN (13, 35, 36, 55, 56);
GO

INSERT INTO [QuestionSet].[ListTable](
	 [ListTableName]
	,[SortOrder]
)
VALUES ('tvfListTable (Numbers 1-16+)', NULL);
GO

-- SELECT [ListTableID] FROM [QuestionSet].[ListTable] WHERE [ListTableName] = 'tvfListTable (Numbers 1-16+)' -- New ID is 102

UPDATE [QuestionSet].[AgentQuestionDetails]
SET [ListTableID] = (SELECT [ListTableID] FROM [QuestionSet].[ListTable] WHERE [ListTableName] = 'tvfListTable (Numbers 1-16+)')
WHERE [AgentQuestionDetailsID] IN (49, 52) -- USER_MLIAB_CINFO.MANUALDIRECTORS and MANUALEMPS
;
GO