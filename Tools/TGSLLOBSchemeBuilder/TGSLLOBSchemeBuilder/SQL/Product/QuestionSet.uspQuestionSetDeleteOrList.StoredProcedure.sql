USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspQuestionSetDeleteOrList]    Script Date: 3/21/2018 3:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler 
-- Create date: 04-01-2011
-- Description: Stored procedure to Remove a QuestionSet and it's related records
-- Extremely dangerous, back up before use.
-- Setting @Delete flag to 'True' will delete records
-- Setting @Delete Flag to 'False' Will List all records which will bbe deleted and the tables which they will be deleted from
-- @Type = 'A' Operate on all records
-- @Type = 'E' Operate on Enablement Records
-- @Type = 'C' Operate on Calculation records
-- =============================================
ALTER PROC [QuestionSet].[uspQuestionSetDeleteOrList]
	   @QuestionSetID bigint = NULL
	  ,@QuestionSetName varchar(50) = NULL
	  ,@Delete bit = 'False'
	  ,@Type char(1) = 'A'
AS

/* 
BEGIN TRAN

	DECLARE @QuestionSetID bigint --= 14
	DECLARE @QuestionSetName varchar(50) = 'Landlord in Residence and Tenants Contents'
	DECLARE @Delete bit = 'False'
	DECLARE @Type char(1)= 'A'

	EXEC [QuestionSet].[uspQuestionSetDeleteOrList] @QuestionSetID ,@QuestionSetName ,@Delete, @Type

select * from questionset.questionset

ROLLBACK TRAN


*/ 

BEGIN

	IF @QuestionSetID IS NULL
	BEGIN
		SELECT @QuestionSetID =  QuestionSetID FROM [QuestionSet].[QuestionSet] WHERE [QuestionSetName] = @QuestionSetName
	END

	IF @QuestionSetID IS NOT NULL
	BEGIN
		DECLARE @EnablementCriteriaSetIDs table
		(
			ID bigint
		)

		DECLARE @EnablementCriteriaListIDs table
		(
			ID bigint
		)

		DECLARE @ListIDs table
		(
			ID bigint
		)

		;WITH [QSL] AS
		(
			SELECT 
				DISTINCT [AQD].[ListTableID] 
			FROM 
				[QuestionSet].[Question] AS [Q]
				JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
			WHERE 
				[Q].[QuestionSetID] = @QuestionSetID
				AND [AQD].[ListTableID]  IS NOT NULL
		)
		, [NQSL] AS
		(
			SELECT 
				DISTINCT [AQD].[ListTableID] 
			FROM 
				[QuestionSet].[Question] AS [Q]
				JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
			WHERE 
				[Q].[QuestionSetID] != @QuestionSetID
				AND [AQD].[ListTableID]  IS NOT NULL
		)
		INSERT INTO @ListIDs
		SELECT
			[QSL].[ListTableID] 
		FROM
			[QSL]
			LEFT JOIN [NQSL] ON [QSL].[ListTableID] = [NQSL].[ListTableID] 
		WHERE
			[NQSL].[ListTableID] IS NULL

		INSERT INTO @EnablementCriteriaSetIDs
		SELECT DISTINCT [QECSL].[EnablementCriteriaSetID]
		FROM
			[QuestionSet].[Question] AS [Q]
			JOIN [QuestionSet].[QuestionEnablementCriteriaSetLink] AS [QECSL] ON [Q].[QuestionID] =  [QECSL].[QuestionID]
		WHERE [Q].[QuestionSetID] = @QuestionSetID

		INSERT INTO @EnablementCriteriaListIDs
		SELECT DISTINCT [EC].[EnablementCriteriaListID]
		FROM
			@EnablementCriteriaSetIDs AS [S]
			JOIN [QuestionSet].[EnablementCriteria] AS [EC] ON [S].[ID] = [EC].[EnablementCriteriaSetID]


		IF ISNULL(@Delete,'False') = 'False'
		BEGIN
			IF ISNULL(@Type,'A')IN ('A','E')
			BEGIN
				SELECT 'QuestionEnablementCriteriaSetLink'
				SELECT
					[QECSL].*
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[QuestionEnablementCriteriaSetLink] AS [QECSL] ON [S].[ID] =  [QECSL].[EnablementCriteriaSetID]

				SELECT 'EnablementCriteria'
				SELECT
					[EC].*
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[EnablementCriteria] AS [EC] ON [S].[ID] =  [EC].[EnablementCriteriaSetID]

				SELECT 'EnablementCriteriaSet'
				SELECT
					[ECS].*
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[EnablementCriteriaSet] AS [ECS] ON [S].[ID] =  [ECS].[EnablementCriteriaSetID]

				SELECT 'EnablementCriteriaListItem'
				SELECT
					[ECLI].*
				FROM
					@EnablementCriteriaListIDs AS [L]
					JOIN [QuestionSet].[EnablementCriteriaListItem] AS [ECLI] ON [L].[ID] =  [ECLI].[EnablementCriteriaListID]
			
				SELECT 'EnablementCriteriaList'
				SELECT
					[ECL].*
				FROM
					@EnablementCriteriaListIDs AS [L]
					JOIN [QuestionSet].[EnablementCriteriaList] AS [ECL] ON [L].[ID] =  [ECL].[EnablementCriteriaListID]
			END
		
			IF ISNULL(@Type,'A') IN ('A', 'C')
			BEGIN		
				SELECT 'CalculatedQuestionOperation'
				SELECT
					[CQO].*
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[CalculatedQuestionOperation] AS [CQO] ON [Q].[QuestionID] = [CQO].[CalculatedQuestionID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID
			END
			IF ISNULL(@Type,'A') = 'A'	
			BEGIN	

				SELECT 'GroupName'
				SELECT
					Distinct [G].[GroupName]	
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
					JOIN [QuestionSet].[Section] AS [S] ON [AQD].[SectionID] = [S].[SectionID]
					JOIN [QuestionSet].[Group] AS [G] ON  [S].[GroupID] = [G].[GroupID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID

				SELECT 'SectionName'
				SELECT
					Distinct [S].[SectionName]	
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
					JOIN [QuestionSet].[Section] AS [S] ON [AQD].[SectionID] = [S].[SectionID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID

				SELECT 'AgentQuestionDetails'	
				SELECT
					[AQD].*		
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID
			
				SELECT 'Question'
				SELECT
					[Q].*
				FROM
					[QuestionSet].[Question] AS [Q]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID
			
				SELECT 'QuestionSet'
				SELECT
					[QS].*		
				FROM
					[QuestionSet].[QuestionSet] AS [QS]
				WHERE
					[QS].[QuestionSetID] = @QuestionSetID

				SELECT
					[LT].[ListTableName]
				FROM
					@ListIDs AS [L]
					JOIN [QuestionSet].[ListTable] AS [LT] ON [L].[ID] = [LT].[ListTableID] 
			END
		END		
		ELSE
		BEGIN
			IF ISNULL(@Type,'A') IN ('A','E')
			BEGIN

				DELETE
					[QECSL]
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[QuestionEnablementCriteriaSetLink] AS [QECSL] ON [S].[ID] =  [QECSL].[EnablementCriteriaSetID]

				DELETE
					[EC]
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[EnablementCriteria] AS [EC] ON [S].[ID] =  [EC].[EnablementCriteriaSetID]

				DELETE
					[ECS]
				FROM
					@EnablementCriteriaSetIDs AS [S]
					JOIN [QuestionSet].[EnablementCriteriaSet] AS [ECS] ON [S].[ID] =  [ECS].[EnablementCriteriaSetID]

				DELETE 
					[ECL]
				FROM 
					@EnablementCriteriaListIDs AS [ECL]
					JOIN [QuestionSet].[EnablementCriteria] AS [EC2] ON [ECL].[ID] = [EC2].[EnablementCriteriaListID]
					LEFT JOIN @EnablementCriteriaSetIDs AS [S2] ON [S2].[ID] = [EC2].[EnablementCriteriaSetID]
				WHERE 
					[S2].[ID] IS NULL

				DELETE
					[L]
				FROM
					@EnablementCriteriaListIDs AS [L]
					JOIN [QuestionSet].[EnablementCriteria] AS [EC] ON [L].[ID] = [EC].[EnablementCriteriaListID]
				
				DELETE
					[ECLI]
				FROM
					@EnablementCriteriaListIDs AS [L]
					JOIN [QuestionSet].[EnablementCriteriaListItem] AS [ECLI] ON [L].[ID] =  [ECLI].[EnablementCriteriaListID]

				DELETE
					[ECL]
				FROM
					@EnablementCriteriaListIDs AS [L]
					JOIN [QuestionSet].EnablementCriteriaList AS [ECL] ON [L].[ID] =  [ECL].[EnablementCriteriaListID]

				DECLARE  @EnablementCriteriaListID int = (SELECT MAX(EnablementCriteriaListID) FROM [QuestionSet].[EnablementCriteriaList])
						,@EnablementCriteriaListItemID int = (SELECT MAX(EnablementCriteriaListItemID) FROM [QuestionSet].[EnablementCriteriaListItem])
						,@EnablementCriteriaSetID int = (SELECT MAX(EnablementCriteriaSetID) FROM [QuestionSet].[EnablementCriteriaSet])
						,@EnablementCriteriaID int = (SELECT MAX(EnablementCriteriaID) FROM [QuestionSet].[EnablementCriteria])
						,@QuestionEnablementCriteriaSetLinkID int = (SELECT MAX(QuestionEnablementCriteriaSetLinkID) FROM [QuestionSet].[QuestionEnablementCriteriaSetLink])

				DBCC CHECKIDENT ('[questionset].[EnablementCriteriaList]', RESEED, @EnablementCriteriaListID);
				DBCC CHECKIDENT ('[questionset].[EnablementCriteriaListItem]', RESEED, @EnablementCriteriaListItemID);
				DBCC CHECKIDENT ('[questionset].[EnablementCriteriaSet]', RESEED, @EnablementCriteriaSetID);
				DBCC CHECKIDENT ('[questionset].[EnablementCriteria]', RESEED, @EnablementCriteriaID);
				DBCC CHECKIDENT ('[questionset].[QuestionEnablementCriteriaSetLink]', RESEED, @QuestionEnablementCriteriaSetLinkID);
			END
		
			IF ISNULL(@Type,'A') IN ('A', 'C')
			BEGIN			
				DELETE
					[CQO]
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[CalculatedQuestionOperation] AS [CQO] ON [Q].[QuestionID] = [CQO].[CalculatedQuestionID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID

				DECLARE  @CalculatedQuestionOperationID int = (SELECT MAX(CalculatedQuestionOperationID) FROM [QuestionSet].[CalculatedQuestionOperation])
				DBCC CHECKIDENT ('[questionset].[CalculatedQuestionOperation]', RESEED, @CalculatedQuestionOperationID);

			END
			IF ISNULL(@Type,'A') = 'A'
			BEGIN	
				EXEC [QuestionSet].[uspProductPolicyAnswerTablesDelete] @QuestionSetID	
				
				DELETE
					[AQD]
				FROM
					[QuestionSet].[Question] AS [Q]
					JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID

				DELETE
					[Q]
				FROM
					[QuestionSet].[Question] AS [Q]
				WHERE
					[Q].[QuestionSetID] = @QuestionSetID
		
				DELETE
					[QS]
				FROM
					[QuestionSet].[QuestionSet] AS [QS]
				WHERE
					[QS].[QuestionSetID] = @QuestionSetID

				DELETE
					[S]
				FROM
					[QuestionSet].[Section] AS [S]
					LEFT JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [AQD].[SectionID] = [S].[SectionID]
				WHERE
					[AQD].[SectionID] IS NULL
			
				DELETE
					[G]
				FROM
					[QuestionSet].[Group] AS [G] 
					LEFT JOIN [QuestionSet].[Section] AS [S] ON [S].[GroupID] = [G].[GroupID]
				WHERE
					[S].[GroupID] IS NULL


				DECLARE @ListTableid int 
				WHILE 1 = 1
				BEGIN
					SELECT top 1 @ListTableID = ID FROM @ListIDs;
					IF @@rowcount = 0
						BREAK
					ELSE
						exec  [QuestionSet].[uspListTableDelete] @ListTableID
					DELETE FROM @ListIDs WHERE @ListTableID = ID
				END	

				DECLARE  @MaxQuestionSetID int = (SELECT MAX(QuestionsetID) FROM [QuestionSet].[Questionset])
						,@GroupID int = (SELECT MAX(GroupID) FROM [QuestionSet].[Group])
						,@SectionID int = (SELECT MAX(SectionID) FROM [QuestionSet].[Section])
						,@QuestionID int = (SELECT MAX(QuestionID) FROM [QuestionSet].[Question])
						,@AgentQuestionDetailsID int = (SELECT MAX(AgentQuestionDetailsID) FROM [QuestionSet].[AgentQuestionDetails])
						,@MaxListTableID int = (SELECT MAX(ListTableID) FROM [QuestionSet].[ListTable])

				DBCC CHECKIDENT ('[questionset].[questionset]', RESEED, @MaxQuestionSetID);
				DBCC CHECKIDENT ('[questionset].[Group]', RESEED, @GroupID);
				DBCC CHECKIDENT ('[questionset].[Section]', RESEED, @SectionID);
				DBCC CHECKIDENT ('[questionset].[Question]', RESEED, @QuestionID);
				DBCC CHECKIDENT ('[questionset].[AgentQuestionDetails]', RESEED, @AgentQuestionDetailsID);
				DBCC CHECKIDENT ('[questionset].[ListTable]', RESEED, @MaxListTableID);
			END
		END	
	END			
END

go

