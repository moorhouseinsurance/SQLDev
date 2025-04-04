USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspListTableInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************
-- Name:    [QuestionSet].[uspListTableInsert] 
-- Author:  Devlin Hostler
-- date:    26 Feb Dec 2018
-- Description: Returns a List Table
*******************************************************************************/
CREATE PROCEDURE [QuestionSet].[uspListTableInsert] 
(
	  @ListTableName varchar(255)
)

AS

/*

	DECLARE @ListTableName varchar(255) = 'LIST_MH_MLRTCBathrooms'
	
	
	DELETE FROM [QuestionSet].[ListTable] WHERE LISTTABLENAME = @ListTableName

	declare @sql varchar(255) = 'drop SYNONYM [dbo].[' + @ListTableName + ']'
	exec(@sql)
	SET @SQL = replace(@SQL , @ListTableName , @ListTableName+'_VIEW')
	EXEC(@SQL)

	exec [QuestionSet].[uspListTableInsert] @ListTableName
	SELECT * FROM [QuestionSet].[ListTable]
--	SELECT [Definition] FROM sys.sql_modules WHERE object_id=object_id('QuestionSet.tvfListTable')

	DECLARE @ListTableName varchar(255) = 'LIST_MH_Trade'
		exec [QuestionSet].[uspListTableInsert] @ListTableName

*/
BEGIN
	SET NOCOUNT ON

	DECLARE @ListTableID bigint = (SELECT [ListTableID] FROM [QuestionSet].[ListTable] WHERE [ListTableName] = @ListTableName)
	IF @ListTableID IS NULL
	BEGIN
		INSERT INTO [QuestionSet].[ListTable] ([ListTableName])
		VALUES (@ListTableName);
		
		SELECT @ListTableID = [ListTableID] FROM [QuestionSet].[ListTable] WHERE [ListTableName] = @ListTableName;

		DECLARE @SQLSynonym varchar(255) ='CREATE SYNONYM [dbo].[' + @ListTableName + '] for [Transactor_UAT].[dbo].[' + @ListTableName +'];'
		EXEC(@SQLSynonym)
		SET @SQLSynonym = replace(@SQLSynonym , @ListTableName , @ListTableName+'_VIEW')
		EXEC(@SQLSynonym)

		DECLARE @TableRoot varchar(255) =  REPLACE(@ListTableName , 'LIST_' , '')

		DECLARE @SQL varchar(max) = 
		'
	IF @ListTableID = {@ListTableID}
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select {@ListTableID} ,''List_{@TableRoot}'' ,[{@TableRoot}_View_ID] ,[{@TableRoot}_View_Debug] FROM [dbo].[List_{@TableRoot}_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [{@TableRoot}_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select {@ListTableID} ,''List_{@TableRoot}'' ,[{@TableRoot}_View_ID] ,[{@TableRoot}_View_Debug] FROM [dbo].[List_{@TableRoot}_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [{@TableRoot}_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select {@ListTableID} ,''List_{@TableRoot}'' ,[{@TableRoot}_View_ID] ,[{@TableRoot}_View_Debug] FROM [dbo].[List_{@TableRoot}_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [{@TableRoot}_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select {@ListTableID} ,''List_{@TableRoot}'' ,[{@TableRoot}_View_ID] ,[{@TableRoot}_View_Debug] FROM [dbo].[List_{@TableRoot}_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [{@TableRoot}_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select {@ListTableID} ,''List_{@TableRoot}'' ,[{@TableRoot}_ID] ,[{@TableRoot}_Debug] FROM [dbo].[List_{@TableRoot}] WHERE [Deleted] = 0 ORDER BY [{@TableRoot}_Debug]
					END
				END
			END
		END
	END

	/*Insert New List tables Here*/
		'	
		;	
		SET @SQL =  REPLACE(@SQL,'{@TableRoot}',@TableRoot)
		SET @SQL =  REPLACE(@SQL,'{@ListTableID}',@ListTableID)

		DECLARE @SQLtvfListTable varchar(max) = (SELECT [Definition] FROM sys.sql_modules WHERE object_id=object_id('QuestionSet.tvfListTable'))

		SET @SQLtvfListTable  = REPLACE(@SQLtvfListTable,'/*Insert New List tables Here*/',@SQL)
		SET @SQLtvfListTable  = REPLACE(@SQLtvfListTable,'CREATE Function','ALTER Function')
		EXEC(@SQLtvfListTable)

	END

	SELECT @ListTableID AS [ListTableID]
END


GO
