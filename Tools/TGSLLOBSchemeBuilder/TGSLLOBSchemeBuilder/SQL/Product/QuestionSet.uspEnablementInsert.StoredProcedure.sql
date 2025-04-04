USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspEnablementInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================
-- Author:	Created by DHostler
-- Create date: 02 Mar 2018
-- Description: if matching criteria set not found create enablement criteria set, criteria,listtable components
--	            create a link to the enablementcriteriaSet
-- =============================================
CREATE PROC [QuestionSet].[uspEnablementInsert]
	 @ComparatorQuestionID bigint
	,@EnablementListValueString varchar(max) = null
	,@EnabledQuestionID bigint
	,@Operator varchar(5) = null
	,@ComparatorValueOrID varchar(255) = null
	,@EnablementCriteriaSetID bigint = null
	,@InsertUserID bigint = 1
AS

/*

BEGIN TRAN
DECLARE @RC int
DECLARE @ComparatorQuestionId bigint = 771
DECLARE @EnablementListValueString varchar(max) = '2'
DECLARE @EnabledQuestionID bigint = 771
DECLARE @Operator varchar(5) = ''
DECLARE @ComparatorValueOrID varchar(255) =''
DECLARE @EnablementCriteriaSetID bigint = null
DECLARE @InsertUserID bigint


	SELECT * FROM [dbo].[tvfSplit](@EnablementListValueString, ',')	
EXECUTE @RC = [Product].[QuestionSet].[uspEnablementInsert] 
   @ComparatorQuestionId
  ,@EnablementListValueString
  ,@EnabledQuestionID
  ,@Operator
  ,@ComparatorValueOrID
  ,@EnablementCriteriaSetID
  ,@InsertUserID
GO

ROLLBACK TRAN

*/ 

BEGIN

	SET NOCOUNT ON

	DECLARE  @DateTime AS datetime = CAST(GETDATE() AS datetime)
			,@Count int
			,@EnablementCriteriaListID bigint
			,@ComparatorValueFunctionID BIGINT

	IF @ComparatorValueOrID = 'True' 
		SET @ComparatorValueOrID = '1'
	
	IF @EnablementListValueString IS NOT NULL
	BEGIN 

		DECLARE @EnablementList table
		(
			[ListValue] varchar(100)
		)
		
		INSERT INTO @EnablementList
		SELECT * FROM [dbo].[tvfSplit](@EnablementListValueString, ',')	
		SET @Count = @@RowCount;

		IF @Count = 1
		BEGIN
			SET @ComparatorValueOrID = @EnablementListValueString
		END
		ELSE
		BEGIN
			SELECT 
				TOP 1 @EnablementCriteriaListID = [L].[EnablementCriteriaListID]
			FROM
				@EnablementList AS [EL]
				LEFT JOIN [QuestionSet].[EnablementCriteriaListItem] AS [L] ON  [EL].[ListValue] = [L].[ListValue]
			GROUP BY
				[L].[EnablementCriteriaListID]
			HAVING
				COUNT(*) = @Count
				AND SUM(CASE WHEN [EL].[ListValue] IS NULL THEN 1 ELSE 0 END) = 0 	
				
			IF @EnablementCriteriaListID IS NULL
			BEGIN
				EXEC @EnablementCriteriaListID = [QuestionSet].[uspEnablementCriteriaListInsert] @InsertUserID

				INSERT INTO [QuestionSet].[EnablementCriteriaListItem]
				(
					 [EnablementCriteriaListID]
					,[ListValue]
					,[InsertUserID]
					,[UpdateUserID]
					,[InsertDateTime]
					,[UpdateDateTime]
					,[Obsolete]
				)
				SELECT
					 @EnablementCriteriaListID
					,[EL].[ListValue]
					,@InsertUserID
					,@InsertUserID
					,@DateTime
					,@DateTime
					,0
				FROM
					@EnablementList AS [EL]
			END	
		END	
	END	

	IF 	@EnablementCriteriaSetID IS NULL
	BEGIN
		EXEC @EnablementCriteriaSetID = [QuestionSet].[uspEnablementCriteriaSetInsert] @InsertUserID
		EXEC [QuestionSet].[uspQuestionEnablementCriteriaSetLinkInsert] @EnabledQuestionID, @EnablementCriteriaSetID, @InsertUserID
	END

	EXEC [QuestionSet].[uspEnablementCriteriaInsert] @EnablementCriteriaSetID, @ComparatorQuestionID, @ComparatorValueOrID, @ComparatorValueFunctionID, @Operator, @EnablementCriteriaListID, @InsertUserID

	UPDATE [QuestionSet].[AgentQuestionDetails] SET [Enabled] = 'False' WHERE [QuestionID] = @EnabledQuestionID;

	SELECT @EnablementCriteriaSetID AS [EnablementCriteriaSetID]
END


GO
