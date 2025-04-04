
/******************************************************************************
-- Name:    [QuestionSet].[uspListTableInsert] 
-- Author:  Devlin Hostler
-- date:    21 Mar 2018
-- Description: Removes a List Table
*******************************************************************************/
ALTER PROCEDURE [QuestionSet].[uspListTableDelete] 
(
	  @ListTableID int
)

AS

/*

	DECLARE @ListTableid int = 66
	select * from [QuestionSet].[ListTable] where listtableid = @ListTableid
	exec  [QuestionSet].[uspListTableDelete] @ListTableID

*/
BEGIN
	SET NOCOUNT ON

	DECLARE @ListTableName varchar(255) = (SELECT [ListTableName] FROM [QuestionSet].[ListTable] WHERE [ListTableID] = @ListTableID)
	IF @ListTableName IS NOT NULL
	BEGIN
		DELETE FROM [QuestionSet].[ListTable] WHERE [ListTableID] = @ListTableID

		DECLARE @SQLSynonym varchar(255) ='DROP SYNONYM [dbo].[' + @ListTableName + '];'
		EXEC(@SQLSynonym)
		SET @SQLSynonym = replace(@SQLSynonym , @ListTableName , @ListTableName +'_VIEW')
		EXEC(@SQLSynonym)

		DECLARE @TableRoot varchar(255) = REPLACE(@ListTableName , 'LIST_' , '')

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
	END'	
		;	
		SET @SQL =  REPLACE(@SQL,'{@TableRoot}',@TableRoot)
		SET @SQL =  REPLACE(@SQL,'{@ListTableID}',@ListTableID)

		print @sql

		DECLARE @SQLtvfListTable varchar(max) = (SELECT [Definition] FROM sys.sql_modules WHERE object_id=object_id('QuestionSet.tvfListTable'))
		SET @SQLtvfListTable  = REPLACE(@SQLtvfListTable ,@SQL ,'')
		SET @SQLtvfListTable  = REPLACE(@SQLtvfListTable,'CREATE Function','ALTER Function')

		EXEC(@SQLtvfListTable)
	END
END

