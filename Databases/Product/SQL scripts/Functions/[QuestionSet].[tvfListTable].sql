USE [Product]
GO
/****** Object:  UserDefinedFunction [QuestionSet].[tvfListTable]    Script Date: 20/03/2025 11:15:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Name:    [QuestionSet].[tvfListTable] 
-- Author:  Devlin Hostler
-- date:    24 Dec 2010
-- Description: Returns a List Table
*******************************************************************************/

-- Date			Who						Change
-- 20/03/2025	Jeremai Smith			Add 


ALTER FUNCTION [QuestionSet].[tvfListTable] 
(
	 @ListTableID int
	,@AgentID char(32)	
	,@Productid char(32)
)
RETURNS @Returntable Table 
(
	 ListTableID int
	,ListTableName varchar(100)
	,ValueID varchar(32)
	,Value varchar(1000)
)
AS

/*

DECLARE @ListTableID int
DECLARE @AgentID char(32)	
DECLARE @ProductID char(32)

SET @ListTableID = 86
SET @AgentID = NULL
SET @ProductID = NULL
SELECT * FROM [QuestionSet].[tvfListTable](@ListTableID ,@AgentID ,@Productid)

*/
BEGIN
	DECLARE @MyCount bigint
	SET @MyCount = 0
	
	IF @ListTableID = 0
	BEGIN
		INSERT INTO @ReturnTable (ListTableID ,ListTableName)
		SELECT [ListTableID] ,[ListTableName] FROM [QuestionSet].[ListTable]

		RETURN
	END

	IF @ListTableID = 1
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 1 ,MH_Trade_View_ID ,MH_Trade_View_Debug FROM [dbo].[List_MH_Trade_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Trade_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 1 ,MH_Trade_View_ID ,MH_Trade_View_Debug FROM [dbo].[List_MH_Trade_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Trade_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 1 ,MH_Trade_View_ID ,MH_Trade_View_Debug FROM [dbo].[List_MH_Trade_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Trade_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 1 ,MH_Trade_View_ID ,MH_Trade_View_Debug FROM [dbo].[List_MH_Trade_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Trade_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 1 ,MH_Trade_ID ,MH_Trade_Debug FROM [dbo].[List_MH_Trade] WHERE Deleted = 0 ORDER BY MH_Trade_Debug
					END
				END
			END
		END
	END
	
	IF @ListTableID = 2
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 2 ,MH_MaxDepth_View_ID ,MH_MaxDepth_View_Debug FROM [dbo].[List_MH_MaxDepth_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_MaxDepth_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 2 ,MH_MaxDepth_View_ID ,MH_MaxDepth_View_Debug FROM [dbo].[List_MH_MaxDepth_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_MaxDepth_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 2 ,MH_MaxDepth_View_ID ,MH_MaxDepth_View_Debug FROM [dbo].[List_MH_MaxDepth_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_MaxDepth_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 2 ,MH_MaxDepth_View_ID ,MH_MaxDepth_View_Debug FROM [dbo].[List_MH_MaxDepth_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_MaxDepth_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 2 ,MH_MaxDepth_ID ,MH_MaxDepth_Debug FROM [dbo].[List_MH_MaxDepth] WHERE Deleted = 0 ORDER BY MH_MaxDepth_Debug
					END
				END
			END
		END
	END

	IF @ListTableID = 3
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) values(3,'998','No Previous Insurance')
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 3 ,[SI].Insurer_ID ,[SI].Insurer_Debug  FROM [dbo].[System_Insurer] AS [SI] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [SI].[INSURER_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE [SI].[Deleted] = 0 ORDER BY [SI].[Insurer_Debug] ASC
	END	

	IF @ListTableID = 4
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 4 ,MH_P_Status_View_ID ,MH_P_Status_View_Debug FROM [dbo].[List_MH_P_Status_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_P_Status_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 4 ,MH_P_Status_View_ID ,MH_P_Status_View_Debug FROM [dbo].[List_MH_P_Status_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_P_Status_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 4 ,MH_P_Status_View_ID ,MH_P_Status_View_Debug FROM [dbo].[List_MH_P_Status_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_P_Status_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 4 ,MH_P_Status_View_ID ,MH_P_Status_View_Debug FROM [dbo].[List_MH_P_Status_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_P_Status_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 4 ,MH_P_Status_ID ,MH_P_Status_Debug FROM [dbo].[List_MH_P_Status] WHERE Deleted = 0 ORDER BY MH_P_Status_Debug
					END
				END
			END
		END	
	END	
	
	IF @ListTableID = 5
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 5 ,Title_View_ID ,Title_View_Debug FROM [dbo].[List_Title_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY Title_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 5 ,Title_View_ID ,Title_View_Debug FROM [dbo].[List_Title_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY Title_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 5 ,Title_View_ID ,Title_View_Debug FROM [dbo].[List_Title_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY Title_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 5 ,Title_View_ID ,Title_View_Debug FROM [dbo].[List_Title_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY Title_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 5 ,Title_ID ,Title_Debug FROM [dbo].[List_Title] WHERE Deleted = 0 ORDER BY Title_Debug
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 6
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 6 ,MH_CoStatus_View_ID ,MH_CoStatus_View_Debug FROM [dbo].[List_MH_CoStatus_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_CoStatus_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 6 ,MH_CoStatus_View_ID ,MH_CoStatus_View_Debug FROM [dbo].[List_MH_CoStatus_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_CoStatus_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 6 ,MH_CoStatus_View_ID ,MH_CoStatus_View_Debug FROM [dbo].[List_MH_CoStatus_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_CoStatus_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 6 ,MH_CoStatus_View_ID ,MH_CoStatus_View_Debug FROM [dbo].[List_MH_CoStatus_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_CoStatus_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 6 ,MH_CoStatus_ID ,MH_CoStatus_Debug FROM [dbo].[List_MH_CoStatus] WHERE Deleted = 0 ORDER BY MH_CoStatus_Debug
					END
				END
			END
		END
	END	
	

	
	
	IF @ListTableID = 7
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 7 ,MH_CovTools_View_ID ,MH_CovTools_View_Debug FROM [dbo].[List_MH_CovTools_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_CovTools_View_Debug)AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 7 ,MH_CovTools_View_ID ,MH_CovTools_View_Debug FROM [dbo].[List_MH_CovTools_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_CovTools_View_Debug)AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 7 ,MH_CovTools_View_ID ,MH_CovTools_View_Debug FROM [dbo].[List_MH_CovTools_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_CovTools_View_Debug)AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 7 ,MH_CovTools_View_ID ,MH_CovTools_View_Debug FROM [dbo].[List_MH_CovTools_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_CovTools_View_Debug)AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 7 ,MH_CovTools_ID ,MH_CovTools_Debug FROM [dbo].[List_MH_CovTools] WHERE Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_CovTools_Debug)AS int)
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 8
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 8 ,MH_PubLiab_View_ID ,MH_PubLiab_View_Debug FROM [dbo].[List_MH_PubLiab_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_PubLiab_View_Debug)AS int) 
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 8 ,MH_PubLiab_View_ID ,MH_PubLiab_View_Debug FROM [dbo].[List_MH_PubLiab_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_PubLiab_View_Debug)AS int) 
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 8 ,MH_PubLiab_View_ID ,MH_PubLiab_View_Debug FROM [dbo].[List_MH_PubLiab_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_PubLiab_View_Debug)AS int) 
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 8 ,MH_PubLiab_View_ID ,MH_PubLiab_View_Debug FROM [dbo].[List_MH_PubLiab_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_PubLiab_View_Debug)AS int) 
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 8 ,MH_PubLiab_ID ,MH_PubLiab_Debug FROM [dbo].[List_MH_PubLiab] WHERE Deleted = 0 ORDER BY CAST( CONVERT(MONEY,MH_PubLiab_Debug)AS int) 
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 9
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 9 ,MH_Assoc_Fed_View_ID ,MH_Assoc_Fed_View_Debug FROM [dbo].[List_MH_Assoc_Fed_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Assoc_Fed_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 9 ,MH_Assoc_Fed_View_ID ,MH_Assoc_Fed_View_Debug FROM [dbo].[List_MH_Assoc_Fed_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Assoc_Fed_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 9 ,MH_Assoc_Fed_View_ID ,MH_Assoc_Fed_View_Debug FROM [dbo].[List_MH_Assoc_Fed_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Assoc_Fed_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 9 ,MH_Assoc_Fed_View_ID ,MH_Assoc_Fed_View_Debug FROM [dbo].[List_MH_Assoc_Fed_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Assoc_Fed_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 9 ,MH_Assoc_Fed_ID ,MH_Assoc_Fed_Debug FROM [dbo].[List_MH_Assoc_Fed] WHERE Deleted = 0 ORDER BY MH_Assoc_Fed_Debug
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 10
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 10 ,MH_MaxHeight_View_ID ,MH_MaxHeight_View_Debug FROM [dbo].[List_MH_MaxHeight_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(REPLACE(MH_MaxHeight_View_Debug,'Over ','') AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 10 ,MH_MaxHeight_View_ID ,MH_MaxHeight_View_Debug FROM [dbo].[List_MH_MaxHeight_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(REPLACE(MH_MaxHeight_View_Debug,'Over ','') AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 10 ,MH_MaxHeight_View_ID ,MH_MaxHeight_View_Debug FROM [dbo].[List_MH_MaxHeight_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(REPLACE(MH_MaxHeight_View_Debug,'Over ','') AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 10 ,MH_MaxHeight_View_ID ,MH_MaxHeight_View_Debug FROM [dbo].[List_MH_MaxHeight_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0  ORDER BY CAST(REPLACE(MH_MaxHeight_View_Debug,'Over ','') AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 10 ,MH_MaxHeight_ID ,MH_MaxHeight_Debug FROM [dbo].[List_MH_MaxHeight] WHERE Deleted = 0  ORDER BY  CAST(REPLACE(MH_MaxHeight_Debug,'Over ','') AS int)
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 11
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 11 ,MH_ClaimType_View_ID ,MH_ClaimType_View_Debug FROM [dbo].[List_MH_ClaimType_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_ClaimType_View_Debug
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 11 ,MH_ClaimType_View_ID ,MH_ClaimType_View_Debug FROM [dbo].[List_MH_ClaimType_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_ClaimType_View_Debug
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 11 ,MH_ClaimType_View_ID ,MH_ClaimType_View_Debug FROM [dbo].[List_MH_ClaimType_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_ClaimType_View_Debug
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 11 ,MH_ClaimType_View_ID ,MH_ClaimType_View_Debug FROM [dbo].[List_MH_ClaimType_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_ClaimType_View_Debug
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 11 ,MH_ClaimType_ID ,MH_ClaimType_Debug FROM [dbo].[List_MH_ClaimType] WHERE Deleted = 0 ORDER BY MH_ClaimType_Debug
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 12
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 12 ,MH_Assumpt_View_ID ,MH_Assumpt_View_Debug FROM [dbo].[List_MH_Assumpt_View] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Assumpt_View_Debug ASC
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 12 ,MH_Assumpt_View_ID ,MH_Assumpt_View_Debug FROM [dbo].[List_MH_Assumpt_View] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY MH_Assumpt_View_Debug ASC
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 12 ,MH_Assumpt_View_ID ,MH_Assumpt_View_Debug FROM [dbo].[List_MH_Assumpt_View] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Assumpt_View_Debug ASC
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 12 ,MH_Assumpt_View_ID ,MH_Assumpt_View_Debug FROM [dbo].[List_MH_Assumpt_View] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY MH_Assumpt_View_Debug ASC
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) Select 12 ,MH_Assumpt_ID ,MH_Assumpt_Debug FROM [dbo].[List_MH_Assumpt] WHERE Deleted = 0 ORDER BY MH_Assumpt_Debug ASC
					END
				END
			END
		END
	END	

	IF @ListTableID = 13
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) 
		SELECT 13 ,'0' ,'Private Individual'
		UNION SELECT 13,'1' ,'Company' 
	END		
	
	IF @ListTableID = 14
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 14 ,[METHODOFCONTACT_VIEW_ID] ,[METHODOFCONTACT_VIEW_DEBUG] FROM [dbo].[LIST_METHODOFCONTACT_VIEW] WHERE Deleted = 0 ORDER BY [METHODOFCONTACT_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 14 ,[METHODOFCONTACT_ID] ,[METHODOFCONTACT_DEBUG] FROM [dbo].[LIST_METHODOFCONTACT] WHERE Deleted = 0 ORDER BY [METHODOFCONTACT_DEBUG]
		END
	END		
	
	IF @ListTableID = 15
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 15 ,[TELEPHONE_TYPE_VIEW_ID] ,[TELEPHONE_TYPE_VIEW_DEBUG] FROM [dbo].[LIST_TELEPHONE_TYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [TELEPHONE_TYPE_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 15 ,[TELEPHONE_TYPE_VIEW_ID] ,[TELEPHONE_TYPE_VIEW_DEBUG] FROM [dbo].[LIST_TELEPHONE_TYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [TELEPHONE_TYPE_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 15 ,[TELEPHONE_TYPE_VIEW_ID] ,[TELEPHONE_TYPE_VIEW_DEBUG] FROM [dbo].[LIST_TELEPHONE_TYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [TELEPHONE_TYPE_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 15 ,[TELEPHONE_TYPE_VIEW_ID] ,[TELEPHONE_TYPE_VIEW_DEBUG] FROM [dbo].[LIST_TELEPHONE_TYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [TELEPHONE_TYPE_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 15 ,[TELEPHONE_TYPE_ID] ,[TELEPHONE_TYPE_DEBUG] FROM [dbo].[LIST_TELEPHONE_TYPE] WHERE Deleted = 0 ORDER BY [TELEPHONE_TYPE_DEBUG]
					END
				END
			END
		END		
	END	
	
	IF @ListTableID = 16
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 16 ,[MH_INDEMNITY_VIEW_ID] ,[MH_INDEMNITY_VIEW_DEBUG] FROM [dbo].[LIST_MH_INDEMNITY_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_VIEW_DEBUG])AS int) 
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 16 ,[MH_INDEMNITY_VIEW_ID] ,[MH_INDEMNITY_VIEW_DEBUG] FROM [dbo].[LIST_MH_INDEMNITY_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_VIEW_DEBUG])AS int) 
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 16 ,[MH_INDEMNITY_VIEW_ID] ,[MH_INDEMNITY_VIEW_DEBUG] FROM [dbo].[LIST_MH_INDEMNITY_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_VIEW_DEBUG])AS int) 
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 16 ,[MH_INDEMNITY_VIEW_ID] ,[MH_INDEMNITY_VIEW_DEBUG] FROM [dbo].[LIST_MH_INDEMNITY_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_VIEW_DEBUG])AS int) 
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 16 ,[MH_INDEMNITY_ID] ,[MH_INDEMNITY_DEBUG] FROM [dbo].[LIST_MH_INDEMNITY] WHERE Deleted = 0  ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_DEBUG])AS int)
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 17
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 17 ,[MH_COVER_VIEW_ID] ,[MH_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_COVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_COVER_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 17 ,[MH_COVER_VIEW_ID] ,[MH_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_COVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_COVER_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 17 ,[MH_COVER_VIEW_ID] ,[MH_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_COVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_COVER_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 17 ,[MH_COVER_VIEW_ID] ,[MH_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_COVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_COVER_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 17 ,[MH_COVER_ID] ,[MH_COVER_DEBUG] FROM [dbo].[LIST_MH_COVER] WHERE Deleted = 0 ORDER BY [MH_COVER_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 18
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 18 ,[MH_LIABLIMIT_VIEW_ID] ,[MH_LIABLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIABLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_LIABLIMIT_VIEW_DEBUG])AS int) 
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 18 ,[MH_LIABLIMIT_VIEW_ID] ,[MH_LIABLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIABLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_LIABLIMIT_VIEW_DEBUG])AS int) 
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 18 ,[MH_LIABLIMIT_VIEW_ID] ,[MH_LIABLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIABLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_LIABLIMIT_VIEW_DEBUG])AS int) 
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 18 ,[MH_LIABLIMIT_VIEW_ID] ,[MH_LIABLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIABLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST( CONVERT(MONEY,[MH_LIABLIMIT_VIEW_DEBUG])AS int) 
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 18 ,[MH_LIABLIMIT_ID] ,[MH_LIABLIMIT_DEBUG] FROM [dbo].[LIST_MH_LIABLIMIT] WHERE Deleted = 0  ORDER BY CAST( CONVERT(MONEY,[MH_LIABLIMIT_DEBUG])AS int) 
					END
				END
			END
		END
	END		
		
	IF @ListTableID = 19
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 19 ,[MH_PA_NUMEMP_VIEW_ID] ,[MH_PA_NUMEMP_VIEW_DEBUG] FROM [dbo].[LIST_MH_PA_NUMEMP_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY cast([MH_PA_NUMEMP_VIEW_DEBUG] as int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 19 ,[MH_PA_NUMEMP_VIEW_ID] ,[MH_PA_NUMEMP_VIEW_DEBUG] FROM [dbo].[LIST_MH_PA_NUMEMP_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY cast([MH_PA_NUMEMP_VIEW_DEBUG] as int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 19 ,[MH_PA_NUMEMP_VIEW_ID] ,[MH_PA_NUMEMP_VIEW_DEBUG] FROM [dbo].[LIST_MH_PA_NUMEMP_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY cast([MH_PA_NUMEMP_VIEW_DEBUG] as int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 19 ,[MH_PA_NUMEMP_VIEW_ID] ,[MH_PA_NUMEMP_VIEW_DEBUG] FROM [dbo].[LIST_MH_PA_NUMEMP_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY cast([MH_PA_NUMEMP_VIEW_DEBUG] as int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 19 ,[MH_PA_NUMEMP_ID] ,[MH_PA_NUMEMP_DEBUG] FROM [dbo].[LIST_MH_PA_NUMEMP] WHERE Deleted = 0 ORDER BY cast([MH_PA_NUMEMP_DEBUG] as int)
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 20
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 20 ,[MH_PREMLOC_VIEW_ID] ,[MH_PREMLOC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMLOC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PREMLOC_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 20 ,[MH_PREMLOC_VIEW_ID] ,[MH_PREMLOC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMLOC_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PREMLOC_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 20 ,[MH_PREMLOC_VIEW_ID] ,[MH_PREMLOC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMLOC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PREMLOC_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 20 ,[MH_PREMLOC_VIEW_ID] ,[MH_PREMLOC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMLOC_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PREMLOC_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 20 ,[MH_PREMLOC_ID] ,[MH_PREMLOC_DEBUG] FROM [dbo].[LIST_MH_PREMLOC] WHERE Deleted = 0 ORDER BY [MH_PREMLOC_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 21
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 21 ,[MH_PREMOCC_VIEW_ID] ,[MH_PREMOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMOCC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PREMOCC_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 21 ,[MH_PREMOCC_VIEW_ID] ,[MH_PREMOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMOCC_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PREMOCC_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 21 ,[MH_PREMOCC_VIEW_ID] ,[MH_PREMOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMOCC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PREMOCC_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 21 ,[MH_PREMOCC_VIEW_ID] ,[MH_PREMOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_PREMOCC_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PREMOCC_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 21 ,[MH_PREMOCC_ID] ,[MH_PREMOCC_DEBUG] FROM [dbo].[LIST_MH_PREMOCC] WHERE Deleted = 0 ORDER BY [MH_PREMOCC_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 22
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 22 ,[MH_ALARM_VIEW_ID] ,[MH_ALARM_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARM_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARM_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 22 ,[MH_ALARM_VIEW_ID] ,[MH_ALARM_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARM_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARM_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 22 ,[MH_ALARM_VIEW_ID] ,[MH_ALARM_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARM_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARM_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 22 ,[MH_ALARM_VIEW_ID] ,[MH_ALARM_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARM_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARM_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 22 ,[MH_ALARM_ID] ,[MH_ALARM_DEBUG] FROM [dbo].[LIST_MH_ALARM] WHERE Deleted = 0 ORDER BY [MH_ALARM_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 23
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 23 ,[MH_ALARMINSTALL_VIEW_ID] ,[MH_ALARMINSTALL_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMINSTALL_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMINSTALL_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 23 ,[MH_ALARMINSTALL_VIEW_ID] ,[MH_ALARMINSTALL_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMINSTALL_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMINSTALL_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 23 ,[MH_ALARMINSTALL_VIEW_ID] ,[MH_ALARMINSTALL_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMINSTALL_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMINSTALL_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 23 ,[MH_ALARMINSTALL_VIEW_ID] ,[MH_ALARMINSTALL_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMINSTALL_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMINSTALL_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 23 ,[MH_ALARMINSTALL_ID] ,[MH_ALARMINSTALL_DEBUG] FROM [dbo].[LIST_MH_ALARMINSTALL] WHERE Deleted = 0 ORDER BY [MH_ALARMINSTALL_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 24
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 24 ,[MH_ALARMMAINT_VIEW_ID] ,[MH_ALARMMAINT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMMAINT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMMAINT_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 24 ,[MH_ALARMMAINT_VIEW_ID] ,[MH_ALARMMAINT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMMAINT_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMMAINT_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 24 ,[MH_ALARMMAINT_VIEW_ID] ,[MH_ALARMMAINT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMMAINT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMMAINT_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 24 ,[MH_ALARMMAINT_VIEW_ID] ,[MH_ALARMMAINT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMMAINT_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMMAINT_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 24 ,[MH_ALARMMAINT_ID] ,[MH_ALARMMAINT_DEBUG] FROM [dbo].[LIST_MH_ALARMMAINT] WHERE Deleted = 0 ORDER BY [MH_ALARMMAINT_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 25
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 25 ,[MH_NUMVEHCOV_VIEW_ID] ,[MH_NUMVEHCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMVEHCOV_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMVEHCOV_VIEW_ID]  --CAST([MH_NUMVEHCOV_VIEW_DEBUG] AS int
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 25 ,[MH_NUMVEHCOV_VIEW_ID] ,[MH_NUMVEHCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMVEHCOV_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMVEHCOV_VIEW_ID]--CAST([MH_NUMVEHCOV_VIEW_DEBUG] AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 25 ,[MH_NUMVEHCOV_VIEW_ID] ,[MH_NUMVEHCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMVEHCOV_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMVEHCOV_VIEW_ID]--CAST([MH_NUMVEHCOV_VIEW_DEBUG] AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 25 ,[MH_NUMVEHCOV_VIEW_ID] ,[MH_NUMVEHCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMVEHCOV_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMVEHCOV_VIEW_ID]--CAST([MH_NUMVEHCOV_VIEW_DEBUG] AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 25 ,[MH_NUMVEHCOV_ID] ,[MH_NUMVEHCOV_DEBUG] FROM [dbo].[LIST_MH_NUMVEHCOV] WHERE Deleted = 0 ORDER BY [MH_NUMVEHCOV_ID]--CAST([MH_NUMVEHCOV_DEBUG] AS int)
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 26
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 26 ,[MH_LIQUORCOVER_VIEW_ID] ,[MH_LIQUORCOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIQUORCOVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST([MH_LIQUORCOVER_VIEW_DEBUG] AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 26 ,[MH_LIQUORCOVER_VIEW_ID] ,[MH_LIQUORCOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIQUORCOVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST([MH_LIQUORCOVER_VIEW_DEBUG] AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 26 ,[MH_LIQUORCOVER_VIEW_ID] ,[MH_LIQUORCOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIQUORCOVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST([MH_LIQUORCOVER_VIEW_DEBUG] AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 26 ,[MH_LIQUORCOVER_VIEW_ID] ,[MH_LIQUORCOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_LIQUORCOVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST([MH_LIQUORCOVER_VIEW_DEBUG] AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 26 ,[MH_LIQUORCOVER_ID] ,[MH_LIQUORCOVER_DEBUG] FROM [dbo].[LIST_MH_LIQUORCOVER] WHERE Deleted = 0 ORDER BY CAST([MH_LIQUORCOVER_DEBUG] AS int)
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 27
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 27 ,[MH_BUILDING_VIEW_ID] ,[MH_BUILDING_VIEW_DEBUG] FROM [dbo].[LIST_MH_BUILDING_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_BUILDING_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 27 ,[MH_BUILDING_VIEW_ID] ,[MH_BUILDING_VIEW_DEBUG] FROM [dbo].[LIST_MH_BUILDING_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_BUILDING_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 27 ,[MH_BUILDING_VIEW_ID] ,[MH_BUILDING_VIEW_DEBUG] FROM [dbo].[LIST_MH_BUILDING_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_BUILDING_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 27 ,[MH_BUILDING_VIEW_ID] ,[MH_BUILDING_VIEW_DEBUG] FROM [dbo].[LIST_MH_BUILDING_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_BUILDING_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 27 ,[MH_BUILDING_ID] ,[MH_BUILDING_DEBUG] FROM [dbo].[LIST_MH_BUILDING] WHERE Deleted = 0 ORDER BY [MH_BUILDING_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 28
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 28 ,[MH_STORIES_VIEW_ID] ,[MH_STORIES_VIEW_DEBUG] FROM [dbo].[LIST_MH_STORIES_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_STORIES_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 28 ,[MH_STORIES_VIEW_ID] ,[MH_STORIES_VIEW_DEBUG] FROM [dbo].[LIST_MH_STORIES_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_STORIES_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 28 ,[MH_STORIES_VIEW_ID] ,[MH_STORIES_VIEW_DEBUG] FROM [dbo].[LIST_MH_STORIES_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_STORIES_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 28 ,[MH_STORIES_VIEW_ID] ,[MH_STORIES_VIEW_DEBUG] FROM [dbo].[LIST_MH_STORIES_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_STORIES_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 28 ,[MH_STORIES_ID] ,[MH_STORIES_DEBUG] FROM [dbo].[LIST_MH_STORIES] WHERE Deleted = 0 ORDER BY [MH_STORIES_DEBUG]
					END
				END
			END
		END
	END
	
	IF @ListTableID = 29
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 29 ,[MH_LISTED_VIEW_ID] ,[MH_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_LISTED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_LISTED_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 29 ,[MH_LISTED_VIEW_ID] ,[MH_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_LISTED_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_LISTED_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 29 ,[MH_LISTED_VIEW_ID] ,[MH_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_LISTED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_LISTED_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 29 ,[MH_LISTED_VIEW_ID] ,[MH_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_LISTED_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_LISTED_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 29 ,[MH_LISTED_ID] ,[MH_LISTED_DEBUG] FROM [dbo].[LIST_MH_LISTED] WHERE Deleted = 0 ORDER BY [MH_LISTED_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 30
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 30 ,[MH_RESOCC_VIEW_ID] ,[MH_RESOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_RESOCC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_RESOCC_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 30 ,[MH_RESOCC_VIEW_ID] ,[MH_RESOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_RESOCC_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_RESOCC_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 30 ,[MH_RESOCC_VIEW_ID] ,[MH_RESOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_RESOCC_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_RESOCC_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 30 ,[MH_RESOCC_VIEW_ID] ,[MH_RESOCC_VIEW_DEBUG] FROM [dbo].[LIST_MH_RESOCC_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_RESOCC_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 30 ,[MH_RESOCC_ID] ,[MH_RESOCC_DEBUG] FROM [dbo].[LIST_MH_RESOCC] WHERE Deleted = 0 ORDER BY [MH_RESOCC_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 31
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 31 ,[MH_LET_VOLXS_VIEW_ID] ,[MH_LET_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_LET_VOLXS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY, [MH_LET_VOLXS_VIEW_DEBUG]) AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 31 ,[MH_LET_VOLXS_VIEW_ID] ,[MH_LET_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_LET_VOLXS_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY, [MH_LET_VOLXS_VIEW_DEBUG]) AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 31 ,[MH_LET_VOLXS_VIEW_ID] ,[MH_LET_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_LET_VOLXS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY, [MH_LET_VOLXS_VIEW_DEBUG]) AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 31 ,[MH_LET_VOLXS_VIEW_ID] ,[MH_LET_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_LET_VOLXS_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY, [MH_LET_VOLXS_VIEW_DEBUG]) AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 31 ,[MH_LET_VOLXS_ID] ,[MH_LET_VOLXS_DEBUG] FROM [dbo].[LIST_MH_LET_VOLXS] WHERE Deleted = 0  ORDER BY CAST(CONVERT( MONEY, [MH_LET_VOLXS_DEBUG]) AS int)
					END
				END
			END
		END
	END	
		
	IF @ListTableID = 32
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 32 ,[MH_VEHTYPE_VIEW_ID] ,[MH_VEHTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_VEHTYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_VEHTYPE_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 32 ,[MH_VEHTYPE_VIEW_ID] ,[MH_VEHTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_VEHTYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_VEHTYPE_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 32 ,[MH_VEHTYPE_VIEW_ID] ,[MH_VEHTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_VEHTYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_VEHTYPE_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 32 ,[MH_VEHTYPE_VIEW_ID] ,[MH_VEHTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_VEHTYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_VEHTYPE_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 32 ,[MH_VEHTYPE_ID] ,[MH_VEHTYPE_DEBUG] FROM [dbo].[LIST_MH_VEHTYPE] WHERE Deleted = 0 ORDER BY [MH_VEHTYPE_DEBUG]
					END
				END
			END
		END
	END	
		
	IF @ListTableID = 33
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 33 ,[MH_NUMTRLCOV_VIEW_ID] ,[MH_NUMTRLCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMTRLCOV_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST([MH_NUMTRLCOV_VIEW_DEBUG] AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 33 ,[MH_NUMTRLCOV_VIEW_ID] ,[MH_NUMTRLCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMTRLCOV_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST([MH_NUMTRLCOV_VIEW_DEBUG] AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 33 ,[MH_NUMTRLCOV_VIEW_ID] ,[MH_NUMTRLCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMTRLCOV_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST([MH_NUMTRLCOV_VIEW_DEBUG] AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 33 ,[MH_NUMTRLCOV_VIEW_ID] ,[MH_NUMTRLCOV_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMTRLCOV_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST([MH_NUMTRLCOV_VIEW_DEBUG] AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 33 ,[MH_NUMTRLCOV_ID] ,[MH_NUMTRLCOV_DEBUG] FROM [dbo].[LIST_MH_NUMTRLCOV] WHERE Deleted = 0 ORDER BY CAST([MH_NUMTRLCOV_DEBUG] AS int)
					END
				END
			END
		END
	END
	
	IF @ListTableID = 34
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 34 ,[MH_GDSLIMIT_VIEW_ID] ,[MH_GDSLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_GDSLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GDSLIMIT_VIEW_DEBUG]) AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 34 ,[MH_GDSLIMIT_VIEW_ID] ,[MH_GDSLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_GDSLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GDSLIMIT_VIEW_DEBUG]) AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 34 ,[MH_GDSLIMIT_VIEW_ID] ,[MH_GDSLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_GDSLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GDSLIMIT_VIEW_DEBUG]) AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 34 ,[MH_GDSLIMIT_VIEW_ID] ,[MH_GDSLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_GDSLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GDSLIMIT_VIEW_DEBUG]) AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 34 ,[MH_GDSLIMIT_ID] ,[MH_GDSLIMIT_DEBUG] FROM [dbo].[LIST_MH_GDSLIMIT] WHERE Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GDSLIMIT_DEBUG]) AS int)
					END
				END
			END
		END
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
	
	IF @ListTableID = 37
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMMANUAL_VIEW_ID] ,[MH_NUMMANUAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMMANUAL_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMMANUAL_VIEW_ID]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMMANUAL_VIEW_ID] ,[MH_NUMMANUAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMMANUAL_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMMANUAL_VIEW_ID]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMMANUAL_VIEW_ID] ,[MH_NUMMANUAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMMANUAL_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMMANUAL_VIEW_ID]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMMANUAL_VIEW_ID] ,[MH_NUMMANUAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMMANUAL_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMMANUAL_VIEW_ID]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMMANUAL_ID] ,[MH_NUMMANUAL_DEBUG] FROM [dbo].[LIST_MH_NUMMANUAL] WHERE Deleted = 0 ORDER BY [MH_NUMMANUAL_ID]
					END
				END
			END
		END
	END

	IF @ListTableID = 38
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NETWORK_VIEW_ID] ,[MH_NETWORK_VIEW_DEBUG] FROM [dbo].[LIST_MH_NETWORK_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NETWORK_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NETWORK_VIEW_ID] ,[MH_NETWORK_VIEW_DEBUG] FROM [dbo].[LIST_MH_NETWORK_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NETWORK_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NETWORK_VIEW_ID] ,[MH_NETWORK_VIEW_DEBUG] FROM [dbo].[LIST_MH_NETWORK_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NETWORK_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NETWORK_VIEW_ID] ,[MH_NETWORK_VIEW_DEBUG] FROM [dbo].[LIST_MH_NETWORK_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NETWORK_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NETWORK_ID] ,[MH_NETWORK_DEBUG] FROM [dbo].[LIST_MH_NETWORK] WHERE Deleted = 0 ORDER BY [MH_NETWORK_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 39
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMSCAN_VIEW_ID] ,[MH_NUMSCAN_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMSCAN_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMSCAN_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMSCAN_VIEW_ID] ,[MH_NUMSCAN_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMSCAN_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_NUMSCAN_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMSCAN_VIEW_ID] ,[MH_NUMSCAN_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMSCAN_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMSCAN_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMSCAN_VIEW_ID] ,[MH_NUMSCAN_VIEW_DEBUG] FROM [dbo].[LIST_MH_NUMSCAN_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_NUMSCAN_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_NUMSCAN_ID] ,[MH_NUMSCAN_DEBUG] FROM [dbo].[LIST_MH_NUMSCAN] WHERE Deleted = 0 ORDER BY [MH_NUMSCAN_DEBUG]
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 40
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_GITC_INSURED_VIEW_ID] ,[MH_GITC_INSURED_VIEW_DEBUG] FROM [dbo].[LIST_MH_GITC_INSURED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GITC_INSURED_VIEW_DEBUG]) AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_GITC_INSURED_VIEW_ID] ,[MH_GITC_INSURED_VIEW_DEBUG] FROM [dbo].[LIST_MH_GITC_INSURED_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GITC_INSURED_VIEW_DEBUG]) AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_GITC_INSURED_VIEW_ID] ,[MH_GITC_INSURED_VIEW_DEBUG] FROM [dbo].[LIST_MH_GITC_INSURED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GITC_INSURED_VIEW_DEBUG]) AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_GITC_INSURED_VIEW_ID] ,[MH_GITC_INSURED_VIEW_DEBUG] FROM [dbo].[LIST_MH_GITC_INSURED_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GITC_INSURED_VIEW_DEBUG]) AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_GITC_INSURED_ID] ,[MH_GITC_INSURED_DEBUG] FROM [dbo].[LIST_MH_GITC_INSURED] WHERE Deleted = 0 ORDER BY CAST(CONVERT( MONEY,[MH_GITC_INSURED_DEBUG]) AS int)
					END
				END
			END
		END
	END		

	IF @ListTableID = 41
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_TERRITORIAL_VIEW_ID] ,[MH_TERRITORIAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_TERRITORIAL_VIEW] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [MH_TERRITORIAL_VIEW_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [WF].[SORTORDER],[MH_TERRITORIAL_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_TERRITORIAL_VIEW_ID] ,[MH_TERRITORIAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_TERRITORIAL_VIEW] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [MH_TERRITORIAL_VIEW_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [WF].[SORTORDER], [MH_TERRITORIAL_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_TERRITORIAL_VIEW_ID] ,[MH_TERRITORIAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_TERRITORIAL_VIEW] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [MH_TERRITORIAL_VIEW_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [WF].[SORTORDER], [MH_TERRITORIAL_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_TERRITORIAL_VIEW_ID] ,[MH_TERRITORIAL_VIEW_DEBUG] FROM [dbo].[LIST_MH_TERRITORIAL_VIEW] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [MH_TERRITORIAL_VIEW_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [WF].[SORTORDER], [MH_TERRITORIAL_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_TERRITORIAL_ID] ,[MH_TERRITORIAL_DEBUG] FROM [dbo].[LIST_MH_TERRITORIAL] JOIN [Product].[QuestionSet].[ListWebFilter] AS [WF] ON [MH_TERRITORIAL_ID] = [WF].[ID] AND [WF].[LISTTABLE_ID] = @ListTableID WHERE Deleted = 0 ORDER BY [WF].[SORTORDER], [MH_TERRITORIAL_DEBUG]
					END
				END
			END
		END
	END	
	
	IF @ListTableID = 42
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_COVER_VIEW_ID] ,[MH_DOS_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_COVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DOS_COVER_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_COVER_VIEW_ID] ,[MH_DOS_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_COVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DOS_COVER_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_COVER_VIEW_ID] ,[MH_DOS_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_COVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DOS_COVER_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_COVER_VIEW_ID] ,[MH_DOS_COVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_COVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DOS_COVER_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_COVER_ID] ,[MH_DOS_COVER_DEBUG] FROM [dbo].[LIST_MH_DOS_COVER] WHERE Deleted = 0 ORDER BY [MH_DOS_COVER_DEBUG]
					END
				END
			END
		END
	END
	
	IF @ListTableID = 43
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_CHARGE_VIEW_ID] ,[MH_DOS_CHARGE_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_CHARGE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DOS_CHARGE_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_CHARGE_VIEW_ID] ,[MH_DOS_CHARGE_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_CHARGE_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DOS_CHARGE_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_CHARGE_VIEW_ID] ,[MH_DOS_CHARGE_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_CHARGE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DOS_CHARGE_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_CHARGE_VIEW_ID] ,[MH_DOS_CHARGE_VIEW_DEBUG] FROM [dbo].[LIST_MH_DOS_CHARGE_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DOS_CHARGE_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DOS_CHARGE_ID] ,[MH_DOS_CHARGE_DEBUG] FROM [dbo].[LIST_MH_DOS_CHARGE] WHERE Deleted = 0 ORDER BY [MH_DOS_CHARGE_DEBUG]
					END
				END
			END
		END
	END			
		
	IF @ListTableID = 44
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PLLIMIT_VIEW_ID] ,[MH_PLLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_PLLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PLLIMIT_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PLLIMIT_VIEW_ID] ,[MH_PLLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_PLLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PLLIMIT_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PLLIMIT_VIEW_ID] ,[MH_PLLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_PLLIMIT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PLLIMIT_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PLLIMIT_VIEW_ID] ,[MH_PLLIMIT_VIEW_DEBUG] FROM [dbo].[LIST_MH_PLLIMIT_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PLLIMIT_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PLLIMIT_ID] ,[MH_PLLIMIT_DEBUG] FROM [dbo].[LIST_MH_PLLIMIT] WHERE Deleted = 0 ORDER BY [MH_PLLIMIT_DEBUG]
					END
				END
			END
		END
	END	

	IF @ListTableID = 45
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_OCCUPIED_VIEW_ID] ,[MH_OCCUPIED_VIEW_DEBUG] FROM [dbo].[LIST_MH_OCCUPIED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_OCCUPIED_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_OCCUPIED_VIEW_ID] ,[MH_OCCUPIED_VIEW_DEBUG] FROM [dbo].[LIST_MH_OCCUPIED_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_OCCUPIED_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_OCCUPIED_VIEW_ID] ,[MH_OCCUPIED_VIEW_DEBUG] FROM [dbo].[LIST_MH_OCCUPIED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_OCCUPIED_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_OCCUPIED_VIEW_ID] ,[MH_OCCUPIED_VIEW_DEBUG] FROM [dbo].[LIST_MH_OCCUPIED_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_OCCUPIED_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_OCCUPIED_ID] ,[MH_OCCUPIED_DEBUG] FROM [dbo].[LIST_MH_OCCUPIED] WHERE Deleted = 0 ORDER BY [MH_OCCUPIED_DEBUG]
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 46
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_COMMOFF_LISTED_VIEW_ID] ,[MH_COMMOFF_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_COMMOFF_LISTED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_COMMOFF_LISTED_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_COMMOFF_LISTED_VIEW_ID] ,[MH_COMMOFF_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_COMMOFF_LISTED_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_COMMOFF_LISTED_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_COMMOFF_LISTED_VIEW_ID] ,[MH_COMMOFF_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_COMMOFF_LISTED_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_COMMOFF_LISTED_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_COMMOFF_LISTED_VIEW_ID] ,[MH_COMMOFF_LISTED_VIEW_DEBUG] FROM [dbo].[LIST_MH_COMMOFF_LISTED_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_COMMOFF_LISTED_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_COMMOFF_LISTED_ID] ,[MH_COMMOFF_LISTED_DEBUG] FROM [dbo].[LIST_MH_COMMOFF_LISTED] WHERE Deleted = 0 ORDER BY [MH_COMMOFF_LISTED_DEBUG]
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 47
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ACCESS_VIEW_ID] ,[MH_ACCESS_VIEW_DEBUG] FROM [dbo].[LIST_MH_ACCESS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ACCESS_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ACCESS_VIEW_ID] ,[MH_ACCESS_VIEW_DEBUG] FROM [dbo].[LIST_MH_ACCESS_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ACCESS_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ACCESS_VIEW_ID] ,[MH_ACCESS_VIEW_DEBUG] FROM [dbo].[LIST_MH_ACCESS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ACCESS_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ACCESS_VIEW_ID] ,[MH_ACCESS_VIEW_DEBUG] FROM [dbo].[LIST_MH_ACCESS_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ACCESS_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ACCESS_ID] ,[MH_ACCESS_DEBUG] FROM [dbo].[LIST_MH_ACCESS] WHERE Deleted = 0 ORDER BY [MH_ACCESS_DEBUG]
					END
				END
			END
		END
	END			

	IF @ListTableID = 48
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMRESP_VIEW_ID] ,[MH_ALARMRESP_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMRESP_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMRESP_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMRESP_VIEW_ID] ,[MH_ALARMRESP_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMRESP_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMRESP_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMRESP_VIEW_ID] ,[MH_ALARMRESP_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMRESP_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMRESP_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMRESP_VIEW_ID] ,[MH_ALARMRESP_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMRESP_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMRESP_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMRESP_ID] ,[MH_ALARMRESP_DEBUG] FROM [dbo].[LIST_MH_ALARMRESP] WHERE Deleted = 0 ORDER BY [MH_ALARMRESP_DEBUG]
					END
				END
			END
		END
	END			

	IF @ListTableID = 49
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMCONT_VIEW_ID] ,[MH_ALARMCONT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMCONT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMCONT_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMCONT_VIEW_ID] ,[MH_ALARMCONT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMCONT_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMCONT_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMCONT_VIEW_ID] ,[MH_ALARMCONT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMCONT_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMCONT_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMCONT_VIEW_ID] ,[MH_ALARMCONT_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMCONT_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMCONT_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMCONT_ID] ,[MH_ALARMCONT_DEBUG] FROM [dbo].[LIST_MH_ALARMCONT] WHERE Deleted = 0 ORDER BY [MH_ALARMCONT_DEBUG]
					END
				END
			END
		END
	END			
						


	IF @ListTableID = 50
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMTYPE_VIEW_ID] ,[MH_ALARMTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMTYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMTYPE_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMTYPE_VIEW_ID] ,[MH_ALARMTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMTYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_ALARMTYPE_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMTYPE_VIEW_ID] ,[MH_ALARMTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMTYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMTYPE_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMTYPE_VIEW_ID] ,[MH_ALARMTYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_ALARMTYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_ALARMTYPE_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_ALARMTYPE_ID] ,[MH_ALARMTYPE_DEBUG] FROM [dbo].[LIST_MH_ALARMTYPE] WHERE Deleted = 0 ORDER BY [MH_ALARMTYPE_DEBUG]
					END
				END
			END
		END
	END		
	

	IF @ListTableID = 51
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_VOLXS_VIEW_ID] ,[MH_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_VOLXS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_VOLXS_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_VOLXS_VIEW_ID] ,[MH_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_VOLXS_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_VOLXS_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_VOLXS_VIEW_ID] ,[MH_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_VOLXS_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_VOLXS_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_VOLXS_VIEW_ID] ,[MH_VOLXS_VIEW_DEBUG] FROM [dbo].[LIST_MH_VOLXS_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_VOLXS_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_VOLXS_ID] ,[MH_VOLXS_DEBUG] FROM [dbo].[LIST_MH_VOLXS] WHERE Deleted = 0 ORDER BY [MH_VOLXS_DEBUG]
					END
				END
			END
		END
	END			


	IF @ListTableID = 52
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_WKBEN_VIEW_ID] ,[MH_WKBEN_VIEW_DEBUG] FROM [dbo].[LIST_MH_WKBEN_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT(MONEY,[MH_WKBEN_VIEW_DEBUG]) AS INT)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_WKBEN_VIEW_ID] ,[MH_WKBEN_VIEW_DEBUG] FROM [dbo].[LIST_MH_WKBEN_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY CAST(CONVERT(MONEY,[MH_WKBEN_VIEW_DEBUG]) AS INT)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_WKBEN_VIEW_ID] ,[MH_WKBEN_VIEW_DEBUG] FROM [dbo].[LIST_MH_WKBEN_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT(MONEY,[MH_WKBEN_VIEW_DEBUG]) AS INT)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_WKBEN_VIEW_ID] ,[MH_WKBEN_VIEW_DEBUG] FROM [dbo].[LIST_MH_WKBEN_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY CAST(CONVERT(MONEY,[MH_WKBEN_VIEW_DEBUG]) AS INT)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_WKBEN_ID] ,[MH_WKBEN_DEBUG] FROM [dbo].[LIST_MH_WKBEN] WHERE Deleted = 0 ORDER BY CAST(CONVERT(MONEY,[MH_WKBEN_DEBUG]) AS INT)
					END
				END
			END
		END
	END								
				



	IF @ListTableID = 53
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PATYPE_VIEW_ID] ,[MH_PATYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_PATYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PATYPE_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PATYPE_VIEW_ID] ,[MH_PATYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_PATYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_PATYPE_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PATYPE_VIEW_ID] ,[MH_PATYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_PATYPE_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PATYPE_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PATYPE_VIEW_ID] ,[MH_PATYPE_VIEW_DEBUG] FROM [dbo].[LIST_MH_PATYPE_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_PATYPE_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_PATYPE_ID] ,[MH_PATYPE_DEBUG] FROM [dbo].[LIST_MH_PATYPE] WHERE Deleted = 0 ORDER BY [MH_PATYPE_DEBUG]
					END
				END
			END
		END
	END			
	


	IF @ListTableID = 54
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_BICOVER_VIEW_ID] ,[MH_BICOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_BICOVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_BICOVER_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_BICOVER_VIEW_ID] ,[MH_BICOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_BICOVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_BICOVER_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_BICOVER_VIEW_ID] ,[MH_BICOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_BICOVER_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_BICOVER_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_BICOVER_VIEW_ID] ,[MH_BICOVER_VIEW_DEBUG] FROM [dbo].[LIST_MH_BICOVER_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_BICOVER_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_BICOVER_ID] ,[MH_BICOVER_DEBUG] FROM [dbo].[LIST_MH_BICOVER] WHERE Deleted = 0 ORDER BY [MH_BICOVER_DEBUG]
					END
				END
			END
		END
	END
	
	IF @ListTableID = 57
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[COUNTRY_VIEW_ID] ,[COUNTRY_VIEW_DEBUG] FROM [dbo].[LIST_COUNTRY_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [COUNTRY_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[COUNTRY_VIEW_ID] ,[COUNTRY_VIEW_DEBUG] FROM [dbo].[LIST_COUNTRY_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [COUNTRY_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[COUNTRY_VIEW_ID] ,[COUNTRY_VIEW_DEBUG] FROM [dbo].[LIST_COUNTRY_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [COUNTRY_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[COUNTRY_VIEW_ID] ,[COUNTRY_VIEW_DEBUG] FROM [dbo].[LIST_COUNTRY_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [COUNTRY_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[COUNTRY_VIEW_ID] ,[COUNTRY_VIEW_DEBUG] FROM [dbo].[LIST_COUNTRY_VIEW] WHERE Deleted = 0 ORDER BY [COUNTRY_VIEW_DEBUG]
					END
				END
			END
		END
	END	

	IF @ListTableID = 58
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHirPlantMacVal_VIEW_ID] ,[MH_CARHirPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHirPlantMacVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARHirPlantMacVal_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHirPlantMacVal_VIEW_ID] ,[MH_CARHirPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHirPlantMacVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARHirPlantMacVal_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHirPlantMacVal_VIEW_ID] ,[MH_CARHirPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHirPlantMacVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARHirPlantMacVal_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHirPlantMacVal_VIEW_ID] ,[MH_CARHirPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHirPlantMacVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARHirPlantMacVal_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHirPlantMacVal_ID] ,[MH_CARHirPlantMacVal_DEBUG] FROM [dbo].[LIST_MH_CARHirPlantMacVal] WHERE Deleted = 0 ORDER BY [MH_CARHirPlantMacVal_DEBUG]
					END
				END
			END
		END
	END		
	
	IF @ListTableID = 59
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CAROwnPlantMacVal_VIEW_ID] ,[MH_CAROwnPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CAROwnPlantMacVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CAROwnPlantMacVal_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CAROwnPlantMacVal_VIEW_ID] ,[MH_CAROwnPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CAROwnPlantMacVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CAROwnPlantMacVal_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CAROwnPlantMacVal_VIEW_ID] ,[MH_CAROwnPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CAROwnPlantMacVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CAROwnPlantMacVal_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CAROwnPlantMacVal_VIEW_ID] ,[MH_CAROwnPlantMacVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CAROwnPlantMacVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CAROwnPlantMacVal_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CAROwnPlantMacVal_ID] ,[MH_CAROwnPlantMacVal_DEBUG] FROM [dbo].[LIST_MH_CAROwnPlantMacVal] WHERE Deleted = 0 ORDER BY [MH_CAROwnPlantMacVal_DEBUG]
					END
				END
			END
		END
	END			
	
	IF @ListTableID = 60
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxContractVal_VIEW_ID] ,[MH_CARMaxContractVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxContractVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARMaxContractVal_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxContractVal_VIEW_ID] ,[MH_CARMaxContractVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxContractVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARMaxContractVal_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxContractVal_VIEW_ID] ,[MH_CARMaxContractVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxContractVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARMaxContractVal_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxContractVal_VIEW_ID] ,[MH_CARMaxContractVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxContractVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARMaxContractVal_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxContractVal_ID] ,[MH_CARMaxContractVal_DEBUG] FROM [dbo].[LIST_MH_CARMaxContractVal] WHERE Deleted = 0 ORDER BY [MH_CARMaxContractVal_DEBUG]
					END
				END
			END
		END
	END			
	
	IF @ListTableID = 61
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHireChargeVal_VIEW_ID] ,[MH_CARHireChargeVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHireChargeVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARHireChargeVal_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHireChargeVal_VIEW_ID] ,[MH_CARHireChargeVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHireChargeVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARHireChargeVal_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHireChargeVal_VIEW_ID] ,[MH_CARHireChargeVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHireChargeVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARHireChargeVal_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHireChargeVal_VIEW_ID] ,[MH_CARHireChargeVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARHireChargeVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARHireChargeVal_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARHireChargeVal_ID] ,[MH_CARHireChargeVal_DEBUG] FROM [dbo].[LIST_MH_CARHireChargeVal] WHERE Deleted = 0 ORDER BY [MH_CARHireChargeVal_DEBUG]
					END
				END
			END
		END
	END			
	
	IF @ListTableID = 62
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxHirPlantVal_VIEW_ID] ,[MH_CARMaxHirPlantVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxHirPlantVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARMaxHirPlantVal_VIEW_DEBUG]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxHirPlantVal_VIEW_ID] ,[MH_CARMaxHirPlantVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxHirPlantVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_CARMaxHirPlantVal_VIEW_DEBUG]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxHirPlantVal_VIEW_ID] ,[MH_CARMaxHirPlantVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxHirPlantVal_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARMaxHirPlantVal_VIEW_DEBUG]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxHirPlantVal_VIEW_ID] ,[MH_CARMaxHirPlantVal_VIEW_DEBUG] FROM [dbo].[LIST_MH_CARMaxHirPlantVal_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_CARMaxHirPlantVal_VIEW_DEBUG]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_CARMaxHirPlantVal_ID] ,[MH_CARMaxHirPlantVal_DEBUG] FROM [dbo].[LIST_MH_CARMaxHirPlantVal] WHERE Deleted = 0 ORDER BY [MH_CARMaxHirPlantVal_DEBUG]
					END
				END
			END
		END
	END				
	
	IF @ListTableID = 63
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DayOfWeek_VIEW_ID] ,[MH_DayOfWeek_VIEW_DEBUG] FROM [dbo].[LIST_MH_DayOfWeek_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DayOfWeek_VIEW_ID]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DayOfWeek_VIEW_ID] ,[MH_DayOfWeek_VIEW_DEBUG] FROM [dbo].[LIST_MH_DayOfWeek_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_DayOfWeek_VIEW_ID]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DayOfWeek_VIEW_ID] ,[MH_DayOfWeek_VIEW_DEBUG] FROM [dbo].[LIST_MH_DayOfWeek_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DayOfWeek_VIEW_ID]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DayOfWeek_VIEW_ID] ,[MH_DayOfWeek_VIEW_DEBUG] FROM [dbo].[LIST_MH_DayOfWeek_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_DayOfWeek_VIEW_ID]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_DayOfWeek_ID] ,[MH_DayOfWeek_DEBUG] FROM [dbo].[LIST_MH_DayOfWeek] WHERE Deleted = 0 ORDER BY [MH_DayOfWeek_ID]
					END
				END
			END
		END
	END		

	IF @ListTableID = 64
	BEGIN 
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_InsurancePolicyType_VIEW_ID] ,[MH_InsurancePolicyType_VIEW_DEBUG] FROM [dbo].[LIST_MH_InsurancePolicyType_VIEW] WHERE Agent_ID = @AgentID AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_InsurancePolicyType_VIEW_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_InsurancePolicyType_VIEW_ID] ,[MH_InsurancePolicyType_VIEW_DEBUG] FROM [dbo].[LIST_MH_InsurancePolicyType_VIEW] WHERE Agent_ID IS NULL AND Product_ID = @ProductID AND Deleted = 0 ORDER BY [MH_InsurancePolicyType_VIEW_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_InsurancePolicyType_VIEW_ID] ,[MH_InsurancePolicyType_VIEW_DEBUG] FROM [dbo].[LIST_MH_InsurancePolicyType_VIEW] WHERE Agent_ID = @AgentID AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_InsurancePolicyType_VIEW_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_InsurancePolicyType_VIEW_ID] ,[MH_InsurancePolicyType_VIEW_DEBUG] FROM [dbo].[LIST_MH_InsurancePolicyType_VIEW] WHERE Agent_ID IS NULL AND Product_ID IS NULL AND Deleted = 0 ORDER BY [MH_InsurancePolicyType_VIEW_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT @ListTableID ,[MH_InsurancePolicyType_ID] ,[MH_InsurancePolicyType_DEBUG] FROM [dbo].[LIST_MH_InsurancePolicyType] WHERE Deleted = 0 ORDER BY [MH_InsurancePolicyType_Debug]
					END
				END
			END
		END
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

	
	IF @ListTableID = 65
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 65 ,'List_EMPLOYMENT_STATUS' ,[EMPLOYMENT_STATUS_View_ID] ,[EMPLOYMENT_STATUS_View_Debug] FROM [dbo].[List_EMPLOYMENT_STATUS_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [EMPLOYMENT_STATUS_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 65 ,'List_EMPLOYMENT_STATUS' ,[EMPLOYMENT_STATUS_View_ID] ,[EMPLOYMENT_STATUS_View_Debug] FROM [dbo].[List_EMPLOYMENT_STATUS_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [EMPLOYMENT_STATUS_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 65 ,'List_EMPLOYMENT_STATUS' ,[EMPLOYMENT_STATUS_View_ID] ,[EMPLOYMENT_STATUS_View_Debug] FROM [dbo].[List_EMPLOYMENT_STATUS_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [EMPLOYMENT_STATUS_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 65 ,'List_EMPLOYMENT_STATUS' ,[EMPLOYMENT_STATUS_View_ID] ,[EMPLOYMENT_STATUS_View_Debug] FROM [dbo].[List_EMPLOYMENT_STATUS_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [EMPLOYMENT_STATUS_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 65 ,'List_EMPLOYMENT_STATUS' ,[EMPLOYMENT_STATUS_ID] ,[EMPLOYMENT_STATUS_Debug] FROM [dbo].[List_EMPLOYMENT_STATUS] WHERE [Deleted] = 0 ORDER BY [EMPLOYMENT_STATUS_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 66
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 66 ,'List_MH_MLRTCCoverType' ,[MH_MLRTCCoverType_View_ID] ,[MH_MLRTCCoverType_View_Debug] FROM [dbo].[List_MH_MLRTCCoverType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCCoverType_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 66 ,'List_MH_MLRTCCoverType' ,[MH_MLRTCCoverType_View_ID] ,[MH_MLRTCCoverType_View_Debug] FROM [dbo].[List_MH_MLRTCCoverType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCCoverType_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 66 ,'List_MH_MLRTCCoverType' ,[MH_MLRTCCoverType_View_ID] ,[MH_MLRTCCoverType_View_Debug] FROM [dbo].[List_MH_MLRTCCoverType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCCoverType_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 66 ,'List_MH_MLRTCCoverType' ,[MH_MLRTCCoverType_View_ID] ,[MH_MLRTCCoverType_View_Debug] FROM [dbo].[List_MH_MLRTCCoverType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCCoverType_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 66 ,'List_MH_MLRTCCoverType' ,[MH_MLRTCCoverType_ID] ,[MH_MLRTCCoverType_Debug] FROM [dbo].[List_MH_MLRTCCoverType] WHERE [Deleted] = 0 ORDER BY [MH_MLRTCCoverType_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 67
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 67 ,'List_MH_NumberType0To9' ,[MH_NumberType0To9_View_ID] ,[MH_NumberType0To9_View_Debug] FROM [dbo].[List_MH_NumberType0To9_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NumberType0To9_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 67 ,'List_MH_NumberType0To9' ,[MH_NumberType0To9_View_ID] ,[MH_NumberType0To9_View_Debug] FROM [dbo].[List_MH_NumberType0To9_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NumberType0To9_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 67 ,'List_MH_NumberType0To9' ,[MH_NumberType0To9_View_ID] ,[MH_NumberType0To9_View_Debug] FROM [dbo].[List_MH_NumberType0To9_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NumberType0To9_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 67 ,'List_MH_NumberType0To9' ,[MH_NumberType0To9_View_ID] ,[MH_NumberType0To9_View_Debug] FROM [dbo].[List_MH_NumberType0To9_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NumberType0To9_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 67 ,'List_MH_NumberType0To9' ,[MH_NumberType0To9_ID] ,[MH_NumberType0To9_Debug] FROM [dbo].[List_MH_NumberType0To9] WHERE [Deleted] = 0 ORDER BY [MH_NumberType0To9_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 68
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 68 ,'List_MH_MLRTCBathrooms' ,[MH_MLRTCBathrooms_View_ID] ,[MH_MLRTCBathrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBathrooms_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCBathrooms_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 68 ,'List_MH_MLRTCBathrooms' ,[MH_MLRTCBathrooms_View_ID] ,[MH_MLRTCBathrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBathrooms_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCBathrooms_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 68 ,'List_MH_MLRTCBathrooms' ,[MH_MLRTCBathrooms_View_ID] ,[MH_MLRTCBathrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBathrooms_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCBathrooms_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 68 ,'List_MH_MLRTCBathrooms' ,[MH_MLRTCBathrooms_View_ID] ,[MH_MLRTCBathrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBathrooms_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCBathrooms_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 68 ,'List_MH_MLRTCBathrooms' ,[MH_MLRTCBathrooms_ID] ,[MH_MLRTCBathrooms_Debug] FROM [dbo].[List_MH_MLRTCBathrooms] WHERE [Deleted] = 0 ORDER BY [MH_MLRTCBathrooms_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 69
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 69 ,'List_MH_MLRTCBedrooms' ,[MH_MLRTCBedrooms_View_ID] ,[MH_MLRTCBedrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBedrooms_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCBedrooms_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 69 ,'List_MH_MLRTCBedrooms' ,[MH_MLRTCBedrooms_View_ID] ,[MH_MLRTCBedrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBedrooms_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_MLRTCBedrooms_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 69 ,'List_MH_MLRTCBedrooms' ,[MH_MLRTCBedrooms_View_ID] ,[MH_MLRTCBedrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBedrooms_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCBedrooms_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 69 ,'List_MH_MLRTCBedrooms' ,[MH_MLRTCBedrooms_View_ID] ,[MH_MLRTCBedrooms_View_Debug] FROM [dbo].[List_MH_MLRTCBedrooms_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_MLRTCBedrooms_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 69 ,'List_MH_MLRTCBedrooms' ,[MH_MLRTCBedrooms_ID] ,[MH_MLRTCBedrooms_Debug] FROM [dbo].[List_MH_MLRTCBedrooms] WHERE [Deleted] = 0 ORDER BY [MH_MLRTCBedrooms_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 70
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 70 ,'List_MH_TimeSpan' ,[MH_TimeSpan_View_ID] ,[MH_TimeSpan_View_Debug] FROM [dbo].[List_MH_TimeSpan_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_TimeSpan_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 70 ,'List_MH_TimeSpan' ,[MH_TimeSpan_View_ID] ,[MH_TimeSpan_View_Debug] FROM [dbo].[List_MH_TimeSpan_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_TimeSpan_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 70 ,'List_MH_TimeSpan' ,[MH_TimeSpan_View_ID] ,[MH_TimeSpan_View_Debug] FROM [dbo].[List_MH_TimeSpan_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_TimeSpan_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 70 ,'List_MH_TimeSpan' ,[MH_TimeSpan_View_ID] ,[MH_TimeSpan_View_Debug] FROM [dbo].[List_MH_TimeSpan_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_TimeSpan_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 70 ,'List_MH_TimeSpan' ,[MH_TimeSpan_ID] ,[MH_TimeSpan_Debug] FROM [dbo].[List_MH_TimeSpan] WHERE [Deleted] = 0 ORDER BY [MH_TimeSpan_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 71
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 71 ,'List_MH_NumberType' ,[MH_NumberType_View_ID] ,[MH_NumberType_View_Debug] FROM [dbo].[List_MH_NumberType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NumberType_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 71 ,'List_MH_NumberType' ,[MH_NumberType_View_ID] ,[MH_NumberType_View_Debug] FROM [dbo].[List_MH_NumberType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NumberType_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 71 ,'List_MH_NumberType' ,[MH_NumberType_View_ID] ,[MH_NumberType_View_Debug] FROM [dbo].[List_MH_NumberType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NumberType_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 71 ,'List_MH_NumberType' ,[MH_NumberType_View_ID] ,[MH_NumberType_View_Debug] FROM [dbo].[List_MH_NumberType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NumberType_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 71 ,'List_MH_NumberType' ,[MH_NumberType_ID] ,[MH_NumberType_Debug] FROM [dbo].[List_MH_NumberType] WHERE [Deleted] = 0 ORDER BY [MH_NumberType_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 72
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 72 ,'List_MH_Resident' ,[MH_Resident_View_ID] ,[MH_Resident_View_Debug] FROM [dbo].[List_MH_Resident_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_Resident_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 72 ,'List_MH_Resident' ,[MH_Resident_View_ID] ,[MH_Resident_View_Debug] FROM [dbo].[List_MH_Resident_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_Resident_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 72 ,'List_MH_Resident' ,[MH_Resident_View_ID] ,[MH_Resident_View_Debug] FROM [dbo].[List_MH_Resident_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_Resident_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 72 ,'List_MH_Resident' ,[MH_Resident_View_ID] ,[MH_Resident_View_Debug] FROM [dbo].[List_MH_Resident_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_Resident_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 72 ,'List_MH_Resident' ,[MH_Resident_ID] ,[MH_Resident_Debug] FROM [dbo].[List_MH_Resident] WHERE [Deleted] = 0 ORDER BY [MH_Resident_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 73
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 73 ,'List_MH_PropertyUsageType' ,[MH_PropertyUsageType_View_ID] ,[MH_PropertyUsageType_View_Debug] FROM [dbo].[List_MH_PropertyUsageType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PropertyUsageType_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 73 ,'List_MH_PropertyUsageType' ,[MH_PropertyUsageType_View_ID] ,[MH_PropertyUsageType_View_Debug] FROM [dbo].[List_MH_PropertyUsageType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PropertyUsageType_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 73 ,'List_MH_PropertyUsageType' ,[MH_PropertyUsageType_View_ID] ,[MH_PropertyUsageType_View_Debug] FROM [dbo].[List_MH_PropertyUsageType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PropertyUsageType_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 73 ,'List_MH_PropertyUsageType' ,[MH_PropertyUsageType_View_ID] ,[MH_PropertyUsageType_View_Debug] FROM [dbo].[List_MH_PropertyUsageType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PropertyUsageType_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 73 ,'List_MH_PropertyUsageType' ,[MH_PropertyUsageType_ID] ,[MH_PropertyUsageType_Debug] FROM [dbo].[List_MH_PropertyUsageType] WHERE [Deleted] = 0 ORDER BY [MH_PropertyUsageType_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 74
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 74 ,'List_MH_PropertyOwnershipType' ,[MH_PropertyOwnershipType_View_ID] ,[MH_PropertyOwnershipType_View_Debug] FROM [dbo].[List_MH_PropertyOwnershipType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PropertyOwnershipType_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 74 ,'List_MH_PropertyOwnershipType' ,[MH_PropertyOwnershipType_View_ID] ,[MH_PropertyOwnershipType_View_Debug] FROM [dbo].[List_MH_PropertyOwnershipType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PropertyOwnershipType_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 74 ,'List_MH_PropertyOwnershipType' ,[MH_PropertyOwnershipType_View_ID] ,[MH_PropertyOwnershipType_View_Debug] FROM [dbo].[List_MH_PropertyOwnershipType_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PropertyOwnershipType_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 74 ,'List_MH_PropertyOwnershipType' ,[MH_PropertyOwnershipType_View_ID] ,[MH_PropertyOwnershipType_View_Debug] FROM [dbo].[List_MH_PropertyOwnershipType_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PropertyOwnershipType_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 74 ,'List_MH_PropertyOwnershipType' ,[MH_PropertyOwnershipType_ID] ,[MH_PropertyOwnershipType_Debug] FROM [dbo].[List_MH_PropertyOwnershipType] WHERE [Deleted] = 0 ORDER BY [MH_PropertyOwnershipType_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 75
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 75 ,'List_MH_VoluntaryExcess' ,[MH_VoluntaryExcess_View_ID] ,[MH_VoluntaryExcess_View_Debug] FROM [dbo].[List_MH_VoluntaryExcess_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_VoluntaryExcess_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 75 ,'List_MH_VoluntaryExcess' ,[MH_VoluntaryExcess_View_ID] ,[MH_VoluntaryExcess_View_Debug] FROM [dbo].[List_MH_VoluntaryExcess_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_VoluntaryExcess_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 75 ,'List_MH_VoluntaryExcess' ,[MH_VoluntaryExcess_View_ID] ,[MH_VoluntaryExcess_View_Debug] FROM [dbo].[List_MH_VoluntaryExcess_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_VoluntaryExcess_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 75 ,'List_MH_VoluntaryExcess' ,[MH_VoluntaryExcess_View_ID] ,[MH_VoluntaryExcess_View_Debug] FROM [dbo].[List_MH_VoluntaryExcess_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_VoluntaryExcess_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 75 ,'List_MH_VoluntaryExcess' ,[MH_VoluntaryExcess_ID] ,[MH_VoluntaryExcess_Debug] FROM [dbo].[List_MH_VoluntaryExcess] WHERE [Deleted] = 0 ORDER BY [MH_VoluntaryExcess_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 76
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 76 ,'List_MH_SUMINSURED' ,[MH_SUMINSURED_View_ID] ,[MH_SUMINSURED_View_Debug] FROM [dbo].[List_MH_SUMINSURED_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_SUMINSURED_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 76 ,'List_MH_SUMINSURED' ,[MH_SUMINSURED_View_ID] ,[MH_SUMINSURED_View_Debug] FROM [dbo].[List_MH_SUMINSURED_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_SUMINSURED_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 76 ,'List_MH_SUMINSURED' ,[MH_SUMINSURED_View_ID] ,[MH_SUMINSURED_View_Debug] FROM [dbo].[List_MH_SUMINSURED_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_SUMINSURED_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 76 ,'List_MH_SUMINSURED' ,[MH_SUMINSURED_View_ID] ,[MH_SUMINSURED_View_Debug] FROM [dbo].[List_MH_SUMINSURED_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_SUMINSURED_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 76 ,'List_MH_SUMINSURED' ,[MH_SUMINSURED_ID] ,[MH_SUMINSURED_Debug] FROM [dbo].[List_MH_SUMINSURED] WHERE [Deleted] = 0 ORDER BY [MH_SUMINSURED_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 77
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 77 ,'List_MH_CoverItem' ,[MH_CoverItem_View_ID] ,[MH_CoverItem_View_Debug] FROM [dbo].[List_MH_CoverItem_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_CoverItem_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 77 ,'List_MH_CoverItem' ,[MH_CoverItem_View_ID] ,[MH_CoverItem_View_Debug] FROM [dbo].[List_MH_CoverItem_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_CoverItem_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 77 ,'List_MH_CoverItem' ,[MH_CoverItem_View_ID] ,[MH_CoverItem_View_Debug] FROM [dbo].[List_MH_CoverItem_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_CoverItem_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 77 ,'List_MH_CoverItem' ,[MH_CoverItem_View_ID] ,[MH_CoverItem_View_Debug] FROM [dbo].[List_MH_CoverItem_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_CoverItem_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 77 ,'List_MH_CoverItem' ,[MH_CoverItem_ID] ,[MH_CoverItem_Debug] FROM [dbo].[List_MH_CoverItem] WHERE [Deleted] = 0 ORDER BY [MH_CoverItem_Debug]
					END
				END
			END
		END
	END
	

	

	

	

	

	

	

	

	

	

	

	

	

	
	IF @ListTableID = 79
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 79 ,'List_MH_LIABLIMIT' ,[MH_LIABLIMIT_View_ID] ,[MH_LIABLIMIT_View_Debug] FROM [dbo].[List_MH_LIABLIMIT_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_LIABLIMIT_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 79 ,'List_MH_LIABLIMIT' ,[MH_LIABLIMIT_View_ID] ,[MH_LIABLIMIT_View_Debug] FROM [dbo].[List_MH_LIABLIMIT_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_LIABLIMIT_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 79 ,'List_MH_LIABLIMIT' ,[MH_LIABLIMIT_View_ID] ,[MH_LIABLIMIT_View_Debug] FROM [dbo].[List_MH_LIABLIMIT_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_LIABLIMIT_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 79 ,'List_MH_LIABLIMIT' ,[MH_LIABLIMIT_View_ID] ,[MH_LIABLIMIT_View_Debug] FROM [dbo].[List_MH_LIABLIMIT_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_LIABLIMIT_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 79 ,'List_MH_LIABLIMIT' ,[MH_LIABLIMIT_ID] ,[MH_LIABLIMIT_Debug] FROM [dbo].[List_MH_LIABLIMIT] WHERE [Deleted] = 0 ORDER BY [MH_LIABLIMIT_Debug]
					END
				END
			END
		END
	END

	

	
	IF @ListTableID = 81
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 81 ,'List_MH_INDEMNITY' ,[MH_INDEMNITY_View_ID] ,[MH_INDEMNITY_View_Debug] FROM [dbo].[List_MH_INDEMNITY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_View_Debug])AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 81 ,'List_MH_INDEMNITY' ,[MH_INDEMNITY_View_ID] ,[MH_INDEMNITY_View_Debug] FROM [dbo].[List_MH_INDEMNITY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_View_Debug])AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 81 ,'List_MH_INDEMNITY' ,[MH_INDEMNITY_View_ID] ,[MH_INDEMNITY_View_Debug] FROM [dbo].[List_MH_INDEMNITY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_View_Debug])AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 81 ,'List_MH_INDEMNITY' ,[MH_INDEMNITY_View_ID] ,[MH_INDEMNITY_View_Debug] FROM [dbo].[List_MH_INDEMNITY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_View_Debug])AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 81 ,'List_MH_INDEMNITY' ,[MH_INDEMNITY_ID] ,[MH_INDEMNITY_Debug] FROM [dbo].[List_MH_INDEMNITY] WHERE [Deleted] = 0 ORDER BY CAST( CONVERT(MONEY,[MH_INDEMNITY_Debug])AS int)
					END
				END
			END
		END
	END

	
	IF @ListTableID = 82
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 82 ,'List_MH_PAIncomeProtectionLevel' ,[MH_PAIncomeProtectionLevel_View_ID] ,[MH_PAIncomeProtectionLevel_View_Debug] FROM [dbo].[List_MH_PAIncomeProtectionLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PAIncomeProtectionLevel_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 82 ,'List_MH_PAIncomeProtectionLevel' ,[MH_PAIncomeProtectionLevel_View_ID] ,[MH_PAIncomeProtectionLevel_View_Debug] FROM [dbo].[List_MH_PAIncomeProtectionLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PAIncomeProtectionLevel_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 82 ,'List_MH_PAIncomeProtectionLevel' ,[MH_PAIncomeProtectionLevel_View_ID] ,[MH_PAIncomeProtectionLevel_View_Debug] FROM [dbo].[List_MH_PAIncomeProtectionLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PAIncomeProtectionLevel_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 82 ,'List_MH_PAIncomeProtectionLevel' ,[MH_PAIncomeProtectionLevel_View_ID] ,[MH_PAIncomeProtectionLevel_View_Debug] FROM [dbo].[List_MH_PAIncomeProtectionLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PAIncomeProtectionLevel_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 82 ,'List_MH_PAIncomeProtectionLevel' ,[MH_PAIncomeProtectionLevel_ID] ,[MH_PAIncomeProtectionLevel_Debug] FROM [dbo].[List_MH_PAIncomeProtectionLevel] WHERE [Deleted] = 0 ORDER BY [MH_PAIncomeProtectionLevel_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 83
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 83 ,'List_MH_PersonalAccidentLevel' ,[MH_PersonalAccidentLevel_View_ID] ,[MH_PersonalAccidentLevel_View_Debug] FROM [dbo].[List_MH_PersonalAccidentLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PersonalAccidentLevel_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 83 ,'List_MH_PersonalAccidentLevel' ,[MH_PersonalAccidentLevel_View_ID] ,[MH_PersonalAccidentLevel_View_Debug] FROM [dbo].[List_MH_PersonalAccidentLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_PersonalAccidentLevel_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 83 ,'List_MH_PersonalAccidentLevel' ,[MH_PersonalAccidentLevel_View_ID] ,[MH_PersonalAccidentLevel_View_Debug] FROM [dbo].[List_MH_PersonalAccidentLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PersonalAccidentLevel_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 83 ,'List_MH_PersonalAccidentLevel' ,[MH_PersonalAccidentLevel_View_ID] ,[MH_PersonalAccidentLevel_View_Debug] FROM [dbo].[List_MH_PersonalAccidentLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_PersonalAccidentLevel_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 83 ,'List_MH_PersonalAccidentLevel' ,[MH_PersonalAccidentLevel_ID] ,[MH_PersonalAccidentLevel_Debug] FROM [dbo].[List_MH_PersonalAccidentLevel] WHERE [Deleted] = 0 ORDER BY [MH_PersonalAccidentLevel_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 84
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 84 ,'List_MH_ProfessionalIndemnityLevel' ,[MH_ProfessionalIndemnityLevel_View_ID] ,[MH_ProfessionalIndemnityLevel_View_Debug] FROM [dbo].[List_MH_ProfessionalIndemnityLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_ProfessionalIndemnityLevel_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 84 ,'List_MH_ProfessionalIndemnityLevel' ,[MH_ProfessionalIndemnityLevel_View_ID] ,[MH_ProfessionalIndemnityLevel_View_Debug] FROM [dbo].[List_MH_ProfessionalIndemnityLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_ProfessionalIndemnityLevel_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 84 ,'List_MH_ProfessionalIndemnityLevel' ,[MH_ProfessionalIndemnityLevel_View_ID] ,[MH_ProfessionalIndemnityLevel_View_Debug] FROM [dbo].[List_MH_ProfessionalIndemnityLevel_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_ProfessionalIndemnityLevel_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 84 ,'List_MH_ProfessionalIndemnityLevel' ,[MH_ProfessionalIndemnityLevel_View_ID] ,[MH_ProfessionalIndemnityLevel_View_Debug] FROM [dbo].[List_MH_ProfessionalIndemnityLevel_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_ProfessionalIndemnityLevel_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 84 ,'List_MH_ProfessionalIndemnityLevel' ,[MH_ProfessionalIndemnityLevel_ID] ,[MH_ProfessionalIndemnityLevel_Debug] FROM [dbo].[List_MH_ProfessionalIndemnityLevel] WHERE [Deleted] = 0 ORDER BY [MH_ProfessionalIndemnityLevel_Debug]
					END
				END
			END
		END
	END


	IF @ListTableID = 85
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 85 ,'List_MH_HeatingEquipment' ,[MH_HeatingEquipment_View_ID] ,[MH_HeatingEquipment_View_Debug] FROM [dbo].[List_MH_HeatingEquipment_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_HeatingEquipment_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 85 ,'List_MH_HeatingEquipment' ,[MH_HeatingEquipment_View_ID] ,[MH_HeatingEquipment_View_Debug] FROM [dbo].[List_MH_HeatingEquipment_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_HeatingEquipment_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 85 ,'List_MH_HeatingEquipment' ,[MH_HeatingEquipment_View_ID] ,[MH_HeatingEquipment_View_Debug] FROM [dbo].[List_MH_HeatingEquipment_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_HeatingEquipment_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 85 ,'List_MH_HeatingEquipment' ,[MH_HeatingEquipment_View_ID] ,[MH_HeatingEquipment_View_Debug] FROM [dbo].[List_MH_HeatingEquipment_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_HeatingEquipment_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 85 ,'List_MH_HeatingEquipment' ,[MH_HeatingEquipment_ID] ,[MH_HeatingEquipment_Debug] FROM [dbo].[List_MH_HeatingEquipment] WHERE [Deleted] = 0 ORDER BY [MH_HeatingEquipment_Debug]
					END
				END
			END
		END
	END

	

	
	IF @ListTableID = 86
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 86 ,'List_MH_DEPTHMAX' ,[MH_DEPTHMAX_View_ID] ,[MH_DEPTHMAX_View_Debug] FROM [dbo].[List_MH_DEPTHMAX_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_DEPTHMAX_View_ID]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 86 ,'List_MH_DEPTHMAX' ,[MH_DEPTHMAX_View_ID] ,[MH_DEPTHMAX_View_Debug] FROM [dbo].[List_MH_DEPTHMAX_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_DEPTHMAX_View_ID]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 86 ,'List_MH_DEPTHMAX' ,[MH_DEPTHMAX_View_ID] ,[MH_DEPTHMAX_View_Debug] FROM [dbo].[List_MH_DEPTHMAX_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_DEPTHMAX_View_ID]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 86 ,'List_MH_DEPTHMAX' ,[MH_DEPTHMAX_View_ID] ,[MH_DEPTHMAX_View_Debug] FROM [dbo].[List_MH_DEPTHMAX_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_DEPTHMAX_View_ID]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 86 ,'List_MH_DEPTHMAX' ,[MH_DEPTHMAX_ID] ,[MH_DEPTHMAX_Debug] FROM [dbo].[List_MH_DEPTHMAX] WHERE [Deleted] = 0 ORDER BY [MH_DEPTHMAX_ID]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 87
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 87 ,'List_MH_NUMBER' ,[MH_NUMBER_View_ID] ,[MH_NUMBER_View_Debug] FROM [dbo].[List_MH_NUMBER_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NUMBER_View_ID]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 87 ,'List_MH_NUMBER' ,[MH_NUMBER_View_ID] ,[MH_NUMBER_View_Debug] FROM [dbo].[List_MH_NUMBER_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NUMBER_View_ID]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 87 ,'List_MH_NUMBER' ,[MH_NUMBER_View_ID] ,[MH_NUMBER_View_Debug] FROM [dbo].[List_MH_NUMBER_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NUMBER_View_ID]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 87 ,'List_MH_NUMBER' ,[MH_NUMBER_View_ID] ,[MH_NUMBER_View_Debug] FROM [dbo].[List_MH_NUMBER_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NUMBER_View_ID]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 87 ,'List_MH_NUMBER' ,[MH_NUMBER_ID] ,[MH_NUMBER_Debug] FROM [dbo].[List_MH_NUMBER] WHERE [Deleted] = 0 ORDER BY [MH_NUMBER_ID]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 88
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 88 ,'List_MH_CNTRCTLEVEL' ,[MH_CNTRCTLEVEL_View_ID] ,[MH_CNTRCTLEVEL_View_Debug] FROM [dbo].[List_MH_CNTRCTLEVEL_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_CNTRCTLEVEL_View_Debug])AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 88 ,'List_MH_CNTRCTLEVEL' ,[MH_CNTRCTLEVEL_View_ID] ,[MH_CNTRCTLEVEL_View_Debug] FROM [dbo].[List_MH_CNTRCTLEVEL_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_CNTRCTLEVEL_View_Debug])AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 88 ,'List_MH_CNTRCTLEVEL' ,[MH_CNTRCTLEVEL_View_ID] ,[MH_CNTRCTLEVEL_View_Debug] FROM [dbo].[List_MH_CNTRCTLEVEL_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_CNTRCTLEVEL_View_Debug])AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 88 ,'List_MH_CNTRCTLEVEL' ,[MH_CNTRCTLEVEL_View_ID] ,[MH_CNTRCTLEVEL_View_Debug] FROM [dbo].[List_MH_CNTRCTLEVEL_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_CNTRCTLEVEL_View_Debug])AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 88 ,'List_MH_CNTRCTLEVEL' ,[MH_CNTRCTLEVEL_ID] ,[MH_CNTRCTLEVEL_Debug] FROM [dbo].[List_MH_CNTRCTLEVEL] WHERE [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_CNTRCTLEVEL_Debug])AS int)
					END
				END
			END
		END
	END

	
	IF @ListTableID = 89
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 89 ,'List_MH_LEVELGIT' ,[MH_LEVELGIT_View_ID] ,[MH_LEVELGIT_View_Debug] FROM [dbo].[List_MH_LEVELGIT_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_LEVELGIT_View_Debug])AS int)
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 89 ,'List_MH_LEVELGIT' ,[MH_LEVELGIT_View_ID] ,[MH_LEVELGIT_View_Debug] FROM [dbo].[List_MH_LEVELGIT_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_LEVELGIT_View_Debug])AS int)
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 89 ,'List_MH_LEVELGIT' ,[MH_LEVELGIT_View_ID] ,[MH_LEVELGIT_View_Debug] FROM [dbo].[List_MH_LEVELGIT_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_LEVELGIT_View_Debug])AS int)
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 89 ,'List_MH_LEVELGIT' ,[MH_LEVELGIT_View_ID] ,[MH_LEVELGIT_View_Debug] FROM [dbo].[List_MH_LEVELGIT_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_LEVELGIT_View_Debug])AS int)
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 89 ,'List_MH_LEVELGIT' ,[MH_LEVELGIT_ID] ,[MH_LEVELGIT_Debug] FROM [dbo].[List_MH_LEVELGIT] WHERE [Deleted] = 0 ORDER BY CAST(CONVERT(MONEY,[MH_LEVELGIT_Debug])AS int)
					END
				END
			END
		END
	END


	
	IF @ListTableID = 90
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 90 ,'List_VALUE_NONSTRUCTURAL_WORK' ,[VALUE_NONSTRUCTURAL_WORK_View_ID] ,[VALUE_NONSTRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_NONSTRUCTURAL_WORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [VALUE_NONSTRUCTURAL_WORK_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 90 ,'List_VALUE_NONSTRUCTURAL_WORK' ,[VALUE_NONSTRUCTURAL_WORK_View_ID] ,[VALUE_NONSTRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_NONSTRUCTURAL_WORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [VALUE_NONSTRUCTURAL_WORK_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 90 ,'List_VALUE_NONSTRUCTURAL_WORK' ,[VALUE_NONSTRUCTURAL_WORK_View_ID] ,[VALUE_NONSTRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_NONSTRUCTURAL_WORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [VALUE_NONSTRUCTURAL_WORK_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 90 ,'List_VALUE_NONSTRUCTURAL_WORK' ,[VALUE_NONSTRUCTURAL_WORK_View_ID] ,[VALUE_NONSTRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_NONSTRUCTURAL_WORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [VALUE_NONSTRUCTURAL_WORK_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 90 ,'List_VALUE_NONSTRUCTURAL_WORK' ,[VALUE_NONSTRUCTURAL_WORK_ID] ,[VALUE_NONSTRUCTURAL_WORK_Debug] FROM [dbo].[List_VALUE_NONSTRUCTURAL_WORK] WHERE [Deleted] = 0 ORDER BY [VALUE_NONSTRUCTURAL_WORK_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 91
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 91 ,'List_VALUE_STRUCTURAL_WORK' ,[VALUE_STRUCTURAL_WORK_View_ID] ,[VALUE_STRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_STRUCTURAL_WORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [VALUE_STRUCTURAL_WORK_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 91 ,'List_VALUE_STRUCTURAL_WORK' ,[VALUE_STRUCTURAL_WORK_View_ID] ,[VALUE_STRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_STRUCTURAL_WORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [VALUE_STRUCTURAL_WORK_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 91 ,'List_VALUE_STRUCTURAL_WORK' ,[VALUE_STRUCTURAL_WORK_View_ID] ,[VALUE_STRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_STRUCTURAL_WORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [VALUE_STRUCTURAL_WORK_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 91 ,'List_VALUE_STRUCTURAL_WORK' ,[VALUE_STRUCTURAL_WORK_View_ID] ,[VALUE_STRUCTURAL_WORK_View_Debug] FROM [dbo].[List_VALUE_STRUCTURAL_WORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [VALUE_STRUCTURAL_WORK_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 91 ,'List_VALUE_STRUCTURAL_WORK' ,[VALUE_STRUCTURAL_WORK_ID] ,[VALUE_STRUCTURAL_WORK_Debug] FROM [dbo].[List_VALUE_STRUCTURAL_WORK] WHERE [Deleted] = 0 ORDER BY [VALUE_STRUCTURAL_WORK_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 92
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 92 ,'List_ROOF_CONSTRUCTION' ,[ROOF_CONSTRUCTION_View_ID] ,[ROOF_CONSTRUCTION_View_Debug] FROM [dbo].[List_ROOF_CONSTRUCTION_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [ROOF_CONSTRUCTION_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 92 ,'List_ROOF_CONSTRUCTION' ,[ROOF_CONSTRUCTION_View_ID] ,[ROOF_CONSTRUCTION_View_Debug] FROM [dbo].[List_ROOF_CONSTRUCTION_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [ROOF_CONSTRUCTION_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 92 ,'List_ROOF_CONSTRUCTION' ,[ROOF_CONSTRUCTION_View_ID] ,[ROOF_CONSTRUCTION_View_Debug] FROM [dbo].[List_ROOF_CONSTRUCTION_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [ROOF_CONSTRUCTION_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 92 ,'List_ROOF_CONSTRUCTION' ,[ROOF_CONSTRUCTION_View_ID] ,[ROOF_CONSTRUCTION_View_Debug] FROM [dbo].[List_ROOF_CONSTRUCTION_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [ROOF_CONSTRUCTION_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 92 ,'List_ROOF_CONSTRUCTION' ,[ROOF_CONSTRUCTION_ID] ,[ROOF_CONSTRUCTION_Debug] FROM [dbo].[List_ROOF_CONSTRUCTION] WHERE [Deleted] = 0 ORDER BY [ROOF_CONSTRUCTION_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 93
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 93 ,'List_WALL_CONSTRUCTION' ,[WALL_CONSTRUCTION_View_ID] ,[WALL_CONSTRUCTION_View_Debug] FROM [dbo].[List_WALL_CONSTRUCTION_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [WALL_CONSTRUCTION_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 93 ,'List_WALL_CONSTRUCTION' ,[WALL_CONSTRUCTION_View_ID] ,[WALL_CONSTRUCTION_View_Debug] FROM [dbo].[List_WALL_CONSTRUCTION_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [WALL_CONSTRUCTION_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 93 ,'List_WALL_CONSTRUCTION' ,[WALL_CONSTRUCTION_View_ID] ,[WALL_CONSTRUCTION_View_Debug] FROM [dbo].[List_WALL_CONSTRUCTION_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [WALL_CONSTRUCTION_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 93 ,'List_WALL_CONSTRUCTION' ,[WALL_CONSTRUCTION_View_ID] ,[WALL_CONSTRUCTION_View_Debug] FROM [dbo].[List_WALL_CONSTRUCTION_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [WALL_CONSTRUCTION_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 93 ,'List_WALL_CONSTRUCTION' ,[WALL_CONSTRUCTION_ID] ,[WALL_CONSTRUCTION_Debug] FROM [dbo].[List_WALL_CONSTRUCTION] WHERE [Deleted] = 0 ORDER BY [WALL_CONSTRUCTION_Debug]
					END
				END
			END
		END
	END

	

	

	

	

	

	

	

	

	

	

	
	IF @ListTableID = 94
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 94 ,'List_AAMEMBER_TYPE' ,[AAMEMBER_TYPE_View_ID] ,[AAMEMBER_TYPE_View_Debug] FROM [dbo].[List_AAMEMBER_TYPE_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [AAMEMBER_TYPE_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 94 ,'List_AAMEMBER_TYPE' ,[AAMEMBER_TYPE_View_ID] ,[AAMEMBER_TYPE_View_Debug] FROM [dbo].[List_AAMEMBER_TYPE_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [AAMEMBER_TYPE_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 94 ,'List_AAMEMBER_TYPE' ,[AAMEMBER_TYPE_View_ID] ,[AAMEMBER_TYPE_View_Debug] FROM [dbo].[List_AAMEMBER_TYPE_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [AAMEMBER_TYPE_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 94 ,'List_AAMEMBER_TYPE' ,[AAMEMBER_TYPE_View_ID] ,[AAMEMBER_TYPE_View_Debug] FROM [dbo].[List_AAMEMBER_TYPE_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [AAMEMBER_TYPE_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 94 ,'List_AAMEMBER_TYPE' ,[AAMEMBER_TYPE_ID] ,[AAMEMBER_TYPE_Debug] FROM [dbo].[List_AAMEMBER_TYPE] WHERE [Deleted] = 0 ORDER BY [AAMEMBER_TYPE_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 95
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 95 ,'List_MH_NETWORK' ,[MH_NETWORK_View_ID] ,[MH_NETWORK_View_Debug] FROM [dbo].[List_MH_NETWORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NETWORK_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 95 ,'List_MH_NETWORK' ,[MH_NETWORK_View_ID] ,[MH_NETWORK_View_Debug] FROM [dbo].[List_MH_NETWORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NETWORK_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 95 ,'List_MH_NETWORK' ,[MH_NETWORK_View_ID] ,[MH_NETWORK_View_Debug] FROM [dbo].[List_MH_NETWORK_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NETWORK_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 95 ,'List_MH_NETWORK' ,[MH_NETWORK_View_ID] ,[MH_NETWORK_View_Debug] FROM [dbo].[List_MH_NETWORK_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NETWORK_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 95 ,'List_MH_NETWORK' ,[MH_NETWORK_ID] ,[MH_NETWORK_Debug] FROM [dbo].[List_MH_NETWORK] WHERE [Deleted] = 0 ORDER BY [MH_NETWORK_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 96
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 96 ,'List_MH_NUMSCAN' ,[MH_NUMSCAN_View_ID] ,[MH_NUMSCAN_View_Debug] FROM [dbo].[List_MH_NUMSCAN_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NUMSCAN_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 96 ,'List_MH_NUMSCAN' ,[MH_NUMSCAN_View_ID] ,[MH_NUMSCAN_View_Debug] FROM [dbo].[List_MH_NUMSCAN_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_NUMSCAN_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 96 ,'List_MH_NUMSCAN' ,[MH_NUMSCAN_View_ID] ,[MH_NUMSCAN_View_Debug] FROM [dbo].[List_MH_NUMSCAN_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NUMSCAN_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 96 ,'List_MH_NUMSCAN' ,[MH_NUMSCAN_View_ID] ,[MH_NUMSCAN_View_Debug] FROM [dbo].[List_MH_NUMSCAN_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_NUMSCAN_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 96 ,'List_MH_NUMSCAN' ,[MH_NUMSCAN_ID] ,[MH_NUMSCAN_Debug] FROM [dbo].[List_MH_NUMSCAN] WHERE [Deleted] = 0 ORDER BY [MH_NUMSCAN_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 97
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 97 ,'List_MH_TERRITORIAL' ,[MH_TERRITORIAL_View_ID] ,[MH_TERRITORIAL_View_Debug] FROM [dbo].[List_MH_TERRITORIAL_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_TERRITORIAL_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 97 ,'List_MH_TERRITORIAL' ,[MH_TERRITORIAL_View_ID] ,[MH_TERRITORIAL_View_Debug] FROM [dbo].[List_MH_TERRITORIAL_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_TERRITORIAL_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 97 ,'List_MH_TERRITORIAL' ,[MH_TERRITORIAL_View_ID] ,[MH_TERRITORIAL_View_Debug] FROM [dbo].[List_MH_TERRITORIAL_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_TERRITORIAL_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 97 ,'List_MH_TERRITORIAL' ,[MH_TERRITORIAL_View_ID] ,[MH_TERRITORIAL_View_Debug] FROM [dbo].[List_MH_TERRITORIAL_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_TERRITORIAL_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 97 ,'List_MH_TERRITORIAL' ,[MH_TERRITORIAL_ID] ,[MH_TERRITORIAL_Debug] FROM [dbo].[List_MH_TERRITORIAL] WHERE [Deleted] = 0 ORDER BY [MH_TERRITORIAL_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 98
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 98 ,'List_MH_GITC_INSURED' ,[MH_GITC_INSURED_View_ID] ,[MH_GITC_INSURED_View_Debug] FROM [dbo].[List_MH_GITC_INSURED_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_GITC_INSURED_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 98 ,'List_MH_GITC_INSURED' ,[MH_GITC_INSURED_View_ID] ,[MH_GITC_INSURED_View_Debug] FROM [dbo].[List_MH_GITC_INSURED_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_GITC_INSURED_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 98 ,'List_MH_GITC_INSURED' ,[MH_GITC_INSURED_View_ID] ,[MH_GITC_INSURED_View_Debug] FROM [dbo].[List_MH_GITC_INSURED_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_GITC_INSURED_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 98 ,'List_MH_GITC_INSURED' ,[MH_GITC_INSURED_View_ID] ,[MH_GITC_INSURED_View_Debug] FROM [dbo].[List_MH_GITC_INSURED_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_GITC_INSURED_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 98 ,'List_MH_GITC_INSURED' ,[MH_GITC_INSURED_ID] ,[MH_GITC_INSURED_Debug] FROM [dbo].[List_MH_GITC_INSURED] WHERE [Deleted] = 0 ORDER BY [MH_GITC_INSURED_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 99
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 99 ,'List_MH_BUSINESS_ACTIVITY' ,[MH_BUSINESS_ACTIVITY_View_ID] ,[MH_BUSINESS_ACTIVITY_View_Debug] FROM [dbo].[List_MH_BUSINESS_ACTIVITY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_BUSINESS_ACTIVITY_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 99 ,'List_MH_BUSINESS_ACTIVITY' ,[MH_BUSINESS_ACTIVITY_View_ID] ,[MH_BUSINESS_ACTIVITY_View_Debug] FROM [dbo].[List_MH_BUSINESS_ACTIVITY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_BUSINESS_ACTIVITY_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 99 ,'List_MH_BUSINESS_ACTIVITY' ,[MH_BUSINESS_ACTIVITY_View_ID] ,[MH_BUSINESS_ACTIVITY_View_Debug] FROM [dbo].[List_MH_BUSINESS_ACTIVITY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_BUSINESS_ACTIVITY_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 99 ,'List_MH_BUSINESS_ACTIVITY' ,[MH_BUSINESS_ACTIVITY_View_ID] ,[MH_BUSINESS_ACTIVITY_View_Debug] FROM [dbo].[List_MH_BUSINESS_ACTIVITY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_BUSINESS_ACTIVITY_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 99 ,'List_MH_BUSINESS_ACTIVITY' ,[MH_BUSINESS_ACTIVITY_ID] ,[MH_BUSINESS_ACTIVITY_Debug] FROM [dbo].[List_MH_BUSINESS_ACTIVITY] WHERE [Deleted] = 0 ORDER BY [MH_BUSINESS_ACTIVITY_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 100
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 100 ,'List_COUNTRY' ,[COUNTRY_View_ID] ,[COUNTRY_View_Debug] FROM [dbo].[List_COUNTRY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [COUNTRY_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 100 ,'List_COUNTRY' ,[COUNTRY_View_ID] ,[COUNTRY_View_Debug] FROM [dbo].[List_COUNTRY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [COUNTRY_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 100 ,'List_COUNTRY' ,[COUNTRY_View_ID] ,[COUNTRY_View_Debug] FROM [dbo].[List_COUNTRY_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [COUNTRY_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 100 ,'List_COUNTRY' ,[COUNTRY_View_ID] ,[COUNTRY_View_Debug] FROM [dbo].[List_COUNTRY_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [COUNTRY_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 100 ,'List_COUNTRY' ,[COUNTRY_ID] ,[COUNTRY_Debug] FROM [dbo].[List_COUNTRY] WHERE [Deleted] = 0 ORDER BY [COUNTRY_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 101
	BEGIN
		INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value]) 
		Select 101 ,'List_MH_COVER' ,[MH_COVER_View_ID] ,[MH_COVER_View_Debug] FROM [dbo].[List_MH_COVER_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_COVER_View_Debug]
		IF @@rowcount = 0  
		BEGIN 
			INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
			Select 101 ,'List_MH_COVER' ,[MH_COVER_View_ID] ,[MH_COVER_View_Debug] FROM [dbo].[List_MH_COVER_View] WHERE [Agent_ID] IS NULL AND [Product_ID] = @ProductID AND [Deleted] = 0 ORDER BY [MH_COVER_View_Debug]
			IF @@rowcount = 0  
			BEGIN 
				INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
				Select 101 ,'List_MH_COVER' ,[MH_COVER_View_ID] ,[MH_COVER_View_Debug] FROM [dbo].[List_MH_COVER_View] WHERE [Agent_ID] = @AgentID AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_COVER_View_Debug]
				IF @@rowcount = 0  
				BEGIN 
					INSERT INTO @Returntable ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
					Select 101 ,'List_MH_COVER' ,[MH_COVER_View_ID] ,[MH_COVER_View_Debug] FROM [dbo].[List_MH_COVER_View] WHERE [Agent_ID] IS NULL AND [Product_ID] IS NULL AND [Deleted] = 0 ORDER BY [MH_COVER_View_Debug]
					IF @@rowcount = 0  
					BEGIN 
						INSERT INTO @Returntable  ([ListTableID] ,[ListTableName] ,[ValueID] ,[Value])
						Select 101 ,'List_MH_COVER' ,[MH_COVER_ID] ,[MH_COVER_Debug] FROM [dbo].[List_MH_COVER] WHERE [Deleted] = 0 ORDER BY [MH_COVER_Debug]
					END
				END
			END
		END
	END

	
	IF @ListTableID = 102
	BEGIN
		SET @Number = 0
		WHILE @Number < 16
		BEGIN
			INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 102 , cast(@Number AS varchar(2)), cast(@Number AS varchar(2))
			SET @Number = @Number + 1
		END	
		INSERT INTO @Returntable (ListTableID ,ValueID ,Value) SELECT 102 , '16', '16+'
	END

	
	/*Insert New List tables Here*/	
	
	
	DELETE FROM @Returntable WHERE @ListTableID != 0 AND Value is NULL						
	RETURN	
END
