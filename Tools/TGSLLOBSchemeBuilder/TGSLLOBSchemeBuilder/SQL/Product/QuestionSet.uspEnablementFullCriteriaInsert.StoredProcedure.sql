USE [Product]
GO
/****** Object:  StoredProcedure [QuestionSet].[uspEnablementFullCriteriaInsert]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Created by DHostler 
-- Create date: 28-01-2011
-- Description: Stored procedure to Insert a Criteria Set, criteriaset link and criteria record.
-- =============================================
CREATE PROC [QuestionSet].[uspEnablementFullCriteriaInsert]
	 @InsertUserID bigint
AS

/* 
BEGIN TRAN

	DECLARE @InsertUserID bigint
	
	SET @InsertUserID = 1
	EXEC [QuestionSet].[uspEnablementFullCriteriaInsert] @InsertUserID



ROLLBACK TRAN
--cleanup
 delete from QuestionSet.QuestionEnablementCriteriaSetLink where INSERTDATETIME > '02 Mar 2011'
  go  
  
 delete from  QuestionSet.EnablementCriteria where INSERTDATETIME > '02 Mar 2011'
  go  
  
  delete from QuestionSet.EnablementCriteriaSet where INSERTDATETIME > '02 Mar 2011'
  go
  
  delete from  QuestionSet.EnablementCriteriaListItem where INSERTDATETIME > '02 Mar 2011'
  go  

  delete from QuestionSet.EnablementCriteriaList where INSERTDATETIME > '02 Mar 2011'
  go
      
  
  


--Reset Enablement
SELECT * FROM  [Product].[QuestionSet].[EnablementCriteriaListItem]
SELECT * FROM  [Product].[QuestionSet].[EnablementCriteriaList]
SELECT * FROM  [Product].[QuestionSet].[EnablementCriteria]
SELECT * FROM  [Product].[QuestionSet].[QuestionEnablementCriteriaSetLink]
SELECT * FROM  [Product].[QuestionSet].[EnablementCriteriaSet]

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[QuestionSet].[FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet]') AND parent_object_id = OBJECT_ID(N'[QuestionSet].[QuestionEnablementCriteriaSetLink]'))
ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink] DROP CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[QuestionSet].[FK_EnablementCriteria_EnablementCriteriaSet]') AND parent_object_id = OBJECT_ID(N'[QuestionSet].[EnablementCriteria]'))
ALTER TABLE [QuestionSet].[EnablementCriteria] DROP CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaSet]
GO
	


ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink]  WITH CHECK ADD  CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet] FOREIGN KEY([EnablementCriteriaSetID])
REFERENCES [QuestionSet].[EnablementCriteriaSet] ([EnablementCriteriaSetID])
GO

ALTER TABLE [QuestionSet].[QuestionEnablementCriteriaSetLink] CHECK CONSTRAINT [FK_QuestionEnablementCriteriaSetLink_EnablementCriteriaSet]
GO


ALTER TABLE [QuestionSet].[EnablementCriteria]  WITH CHECK ADD  CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaSet] FOREIGN KEY([EnablementCriteriaSetID])
REFERENCES [QuestionSet].[EnablementCriteriaSet] ([EnablementCriteriaSetID])
GO

ALTER TABLE [QuestionSet].[EnablementCriteria] CHECK CONSTRAINT [FK_EnablementCriteria_EnablementCriteriaSet]
GO

*/ 

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON


DECLARE @DateTime AS datetime
SET @DateTime = CAST(GETDATE() AS datetime)
DECLARE @LastEnablementCriteriaListID int
SELECT @LastEnablementCriteriaListID = ISNULL(MAX([ECL].[EnablementCriteriaListID]),0) FROM [QuestionSet].[EnablementCriteriaList] AS [ECL]
DECLARE @LastEnablementCriteriaSetID int
SELECT @LastEnablementCriteriaSetID = ISNULL(MAX([ECS].[EnablementCriteriaSetID]),0) FROM [QuestionSet].[EnablementCriteriaSet] AS [ECS]

DECLARE @Temp AS Table
(
	 [QuestionID] bigint
	,[Operator] varchar(2)
	,[ComparatorQuestionID] bigint
	,[ComparatorValueOrID] varchar(1000)
	,[EnablementCriteriaListID] bigint
	,[ListValue] varchar(100)
	,[EnablementCriteriaSetID] bigint
)	
	
;WITH
CTE AS 
(
	SELECT 
		DISTINCT [LOB].[EnablementList] AS [EL] 
	FROM 
		[dbo].[QSCAR_UPDATE_27042011] AS [LOB] 
	WHERE 
		[LOB].[EnablementList] IS NOT NULL
)
,
CTE1 AS
(
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY [CTE].[EL]) + @LastEnablementCriteriaListID AS [EnablementCriteriaListID] 
		,[CTE].[EL]
	FROM	
		[CTE]
)
INSERT INTO @Temp
(
	 [QuestionID]
	,[Operator]
	,[ComparatorQuestionID]
	,[ComparatorValueOrID]
	,[EnablementCriteriaListID]
	,[ListValue]
)
SELECT 
	 [Q].[QuestionID]
	,[LOB].[EnablementOperator] AS [Operator]
	,[C].[QuestionID] AS [ComparatorQuestionID]
	,CASE
		WHEN [LOB].[EnablementValue] = 'TRUE' THEN 1
		WHEN [LOB].[EnablementValue] = 'FALSE' THEN 0
		ELSE [LOB].[EnablementValue]
	 END AS [ComparatorValueOrID]
	,[CTE1].[EnablementCriteriaListID]
	,[AL].[Data] AS [ListValue]
FROM
	[dbo].[QSCAR_UPDATE_27042011] AS [LOB]
	JOIN [QuestionSet].[Question] AS [Q] ON ([LOB].[Answertablename] = [Q].[AnswerTableName] AND [LOB].[AnswerFieldName] = [Q].[AnswerFieldName] )
	OUTER APPLY [transactor_dev].[dbo].tvfSplitStringByDelimiter([LOB].[EnablementAnswerField],',') AS [AF]
	LEFT JOIN [QuestionSet].[Question] AS [C] ON ([LOB].[EnablementAnswerTable] = [C].[AnswerTableName] AND [C].[AnswerFieldName] = [AF].[Data]) 	 
	LEFT JOIN [CTE1] ON [CTE1].[EL] = [LOB].[EnablementList]
	OUTER APPLY [transactor_dev].[dbo].tvfSplitStringByDelimiter([LOB].[EnablementList],',') AS [AL]
WHERE
	[LOB].[EnablementOperator] IS NOT NULL
	

SET IDENTITY_INSERT [Product].[QuestionSet].[EnablementCriteriaList] ON

INSERT INTO [Product].[QuestionSet].[EnablementCriteriaList]
           (
			[EnablementCriteriaListID]
		   ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])

SELECT
	 DISTINCT [T].[EnablementCriteriaListID] 
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,0
FROM
	@temp As [T]
WHERE	
		[T].[EnablementCriteriaListID]	IS NOT NULL		
GROUP BY
	[T].[EnablementCriteriaListID]	

	
SET IDENTITY_INSERT [Product].[QuestionSet].[EnablementCriteriaList] OFF	

INSERT INTO [Product].[QuestionSet].[EnablementCriteriaListItem]
           ([EnablementCriteriaListID]
           ,[ListValue]
           ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])
SELECT 
	DISTINCT [T].[EnablementCriteriaListID], [T].[ListValue]
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,0
FROM
	@temp As [T]	
WHERE	
	[T].[EnablementCriteriaListID]	IS NOT NULL				


UPDATE [T3]
SET EnablementCriteriaSetID = [T2].[EnablementCriteriaSetID]
FROM
(
	SELECT 
		ROW_NUMBER() OVER (Partition By 1  Order BY [T].[QuestionID]) + @LastEnablementCriteriaSetID  AS [EnablementCriteriaSetID]
		,[T].[QuestionID]
		,[T].[Operator]
		,[T].[ComparatorQuestionID]	
	FROM
		@temp As [T]
	GROUP BY
		 [T].[QuestionID]
		,[T].[Operator]
		,[T].[ComparatorQuestionID]
) AS [T2] JOIN @Temp AS [T3] ON ([T2].[QuestionID] = [T3].[QuestionID] AND [T2].[Operator] = [T3].[Operator])-- AND [T2].[ComparatorQuestionID] = [T3].[ComparatorQuestionID])

SET IDENTITY_INSERT [Product].[QuestionSet].[EnablementCriteriaSet] ON
	
INSERT INTO [Product].[QuestionSet].[EnablementCriteriaSet]
           (
           [EnablementCriteriaSetID]
           ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])
SELECT 
	[T].[EnablementCriteriaSetID]
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,0
FROM
	@temp As [T]
GROUP BY
	  [T].[EnablementCriteriaSetID]
	  
SET IDENTITY_INSERT [Product].[QuestionSet].[EnablementCriteriaSet] OFF
	
INSERT INTO [Product].[QuestionSet].[QuestionEnablementCriteriaSetLink]
           ([QuestionID]
           ,[EnablementCriteriaSetID]
           ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])

SELECT
	 [T].[QuestionID]
	,[T].[EnablementCriteriaSetID]
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,0
FROM
	@temp As [T]
GROUP BY
	 [T].[QuestionID]
	,[T].[EnablementCriteriaSetID]


INSERT INTO [Product].[QuestionSet].[EnablementCriteria]
           ([EnablementCriteriaSetID]
           ,[ComparatorQuestionID]
           ,[ComparatorValueOrID]
           ,[ComparatorValueFunctionID]
           ,[Operator]
           ,[EnablementCriteriaListID]
           ,[InsertUserID]
           ,[UpdateUserID]
           ,[InsertDateTime]
           ,[UpdateDateTime]
           ,[Obsolete])
SELECT
	 [T].[EnablementCriteriaSetID]
	,[T].[ComparatorQuestionID]
	,[T].[ComparatorValueOrID]
    ,NULL -- To be completed when a function is used [T].[ComparatorValueFunctionID]
    ,[T].[Operator]
    ,[T].[EnablementCriteriaListID]	
	,@InsertUserID
	,@InsertUserID
	,@DateTime
	,@DateTime
	,0
FROM
	@temp As [T]
WHERE
	[T].[Operator] IS NOT NULL		
GROUP BY
	 [T].[EnablementCriteriaSetID]
	,[T].[ComparatorQuestionID]
	,[T].[ComparatorValueOrID]
 --   ,[T].[ComparatorValueFunctionID]
    ,[T].[Operator]
    ,[T].[EnablementCriteriaListID]	
           

END

GO
