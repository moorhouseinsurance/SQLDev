USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspListTableSelect]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
























/******************************************************************************
-- Name:    [QuestionSet].[tvfListTable1] 
-- Author:  Devlin Hostler
-- date:    26 Feb Dec 2018
-- Description: Returns a List Table
*******************************************************************************/
CREATE PROCEDURE [QuestionSet].[uspListTableSelect] 
(
	 @ListTableID int
	,@AgentID char(32)	
	,@Productid char(32)
)

AS

/*

	DECLARE @ListTableID int
	DECLARE @AgentID char(32)	
	DECLARE @ProductID char(32)

	SET @ListTableID = 15
	SET @AgentID = NULL
	SET @ProductID = NULL
	exec [QuestionSet].[uspListTableSelect] @ListTableID ,@AgentID ,@Productid

*/
BEGIN

	DECLARE @Returntable Table 
	(
		 [ListTableID] int
		,[ListTableName] varchar(100)
		,[ValueID] varchar(32)
		,[Value] varchar(1000)
	)

	IF @ListTableID = 3
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) values(3,'998','No Previous Insurance')
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 3 ,[SI].Insurer_ID ,[SI].Insurer_Debug  FROM [MGL-V-SQL02].[Transactor_UAT].[dbo].[System_Insurer] AS [SI] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [SI].[INSURER_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE [SI].[Deleted] = 0 ORDER BY [SI].[Insurer_Debug] ASC
	END	

	IF @ListTableID = 13
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) 
		SELECT 13 ,'0' ,'Private Individual'
		UNION SELECT 13,'1' ,'Company' 
	END		

	DECLARE @Number int
	IF @ListTableID = 35
	BEGIN
		SET @Number = 0
		WHILE @Number < 11
		BEGIN
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 35 , cast(@Number AS varchar(2)), cast(@Number AS varchar(2))
			SET @Number = @Number + 1
		END	
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 35 , '11', '11+'
	END
	
	IF @ListTableID = 36
	BEGIN
		SET @Number = 1
		WHILE @Number < 11
		BEGIN
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 36 , cast(@Number AS varchar(2)), cast(@Number AS varchar(2))
			SET @Number = @Number + 1
		END	
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 36 , '11', '11+'
	END	

	IF @ListTableID = 55
	BEGIN
		SET @Number = YEAR(GETDATE())
		WHILE @Number > 1970
		BEGIN
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 55 , cast(@Number AS varchar(4)), cast(@Number AS varchar(4))
			SET @Number = @Number - 1
		END	
	END	
	
	IF @ListTableID = 56
	BEGIN
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 56 , '3NLE5TD3', '1'
	END		

	DECLARE @ListTableName varchar(100) = (SELECT [ListTableName] FROM [QuestionSet].[ListTable] WHERE [ListTableID] = @ListTableID)
	DECLARE @TableRoot varchar(255) =  REPLACE(@ListTableName , 'LIST_MH_' , '')

	IF @ListTableID NOT IN (3 ,13 ,35 ,36 ,55 ,56)
	BEGIN
		DECLARE @SQL varchar(max) = 
		'
				set nocount on
				DECLARE @Returntable Table 
				(	 
					 [ValueID] varchar(32)
					,[Value] varchar(1000)
				)

				INSERT INTO @Returntable (ValueID ,Value) 
				Select MH_{@TableRoot}_View_ID ,MH_{@TableRoot}_View_Debug FROM [dbo].[List_MH_{@TableRoot}_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_{@TableRoot}_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ValueID ,Value) 
					Select MH_{@TableRoot}_View_ID ,MH_{@TableRoot}_View_Debug FROM [dbo].[List_MH_{@TableRoot}_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_{@TableRoot}_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ValueID ,Value) 
						Select MH_{@TableRoot}_View_ID ,MH_{@TableRoot}_View_Debug FROM [dbo].[List_MH_{@TableRoot}_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_{@TableRoot}_View_Debug
						IF @@rowcount = 0  
						BEGIN 
							INSERT INTO @Returntable (ValueID ,Value) 
							Select MH_{@TableRoot}_View_ID ,MH_{@TableRoot}_View_Debug FROM [dbo].[List_MH_{@TableRoot}_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_{@TableRoot}_View_Debug
							IF @@rowcount = 0  
							BEGIN 
								INSERT INTO @Returntable (ValueID ,Value) 
								Select MH_{@TableRoot}_ID ,MH_{@TableRoot}_Debug FROM [dbo].[List_MH_{@TableRoot}] WHERE Deleted = 0 ORDER BY MH_{@TableRoot}_Debug
							END
						END
					END
				END

				SELECT * from @Returntable
		'	
		;	
		SET @SQL =  REPLACE(@SQL,'{@TableRoot}',@TableRoot)
		SET @SQL =  REPLACE(@SQL,'@AgentID',ISNULL(@AgentID,'NULL'))
		SET @SQL =  REPLACE(@SQL,'@ProductID',ISNULL(@ProductID,'NULL'))

		INSERT INTO @Returntable ([ValueID] ,[Value]) 
		exec (@SQL)
	END
	UPDATE @Returntable SET [ListTableID] = @ListTableID , [ListTableName] = @ListTableName
	
	DELETE FROM @Returntable WHERE @ListTableID != 0 AND Value is NULL						

	select * from @Returntable
END

GO
