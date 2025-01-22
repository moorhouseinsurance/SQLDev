USE [Product]
GO


--WITH CTE AS
--(SELECT
--	 [EC].[EnablementCriteriaID]
--	,[EC].[EnablementCriteriaSetID]
--	,[EC].[ComparatorQuestionID]
--	,[QS].[QuestionSetName]
--	,[Q].[AnswerTableName]
--	,[Q].[AnswerFieldName]
--	,[EC].[Operator]
--	,[EC].[ComparatorValueOrID]
--	,[EC].[EnablementCriteriaListID]
--	,(SELECT DISTINCT [ListValue] + ',' FROM [QuestionSet].[EnablementCriteriaListItem]
--      WHERE [EnablementCriteriaListID] = [EC].[EnablementCriteriaListID]
--      FOR XML PATH(''))  AS [CriteriaListItems]
--	,(SELECT DISTINCT [LINKQ].[AnswerTableName] + '.' + [LINKQ].[AnswerFieldName] + ',' FROM [QuestionSet].[QuestionEnablementCriteriaSetLink] AS [CSL]
--	  INNER JOIN [QuestionSet].[Question] AS [LINKQ] ON [CSL].[QuestionID] = [LINKQ].[QuestionID]
--      WHERE [CSL].[EnablementCriteriaSetID] = [EC].[EnablementCriteriaSetID]
--      FOR XML PATH(''))  AS [EnabledQuestions]
--FROM
--	[QuestionSet].[EnablementCriteria] AS [EC]
--	INNER JOIN [QuestionSet].[Question] AS [Q] ON [EC].[ComparatorQuestionID] = [Q].[QuestionID]
--	INNER JOIN [QuestionSet].[QuestionSet] AS [QS] ON [Q].[QuestionSetID] = [QS].[QuestionSetID]
--WHERE
--	[QS].[QuestionSetName] = 'Tradesman Liability'
--    AND [Q].[AnswerTableName] = 'USER_MLIAB_TRDDTAIL'
--	--AND [Q].[AnswerFieldName] = 'PAVING'
--	)

--SELECT * FROM CTE;
--===============--==========EnablementCriteria-- Manufature===================================

--Step1: first need to insert list of trades that enables this question
---EnablementCriteriaListID == 160, Live 148
EXEC [QuestionSet].[uspEnablementCriteriaListInsert] 1

--[EnablementCriteriaListItem]
INSERT INTO [QuestionSet].[EnablementCriteriaListItem] VALUES(148, '7GDK83KF', 1,1,GETDATE(), GETDATE(), 0)
INSERT INTO [QuestionSet].[EnablementCriteriaListItem] VALUES(148, '3N0TVJI9', 1,1,GETDATE(), GETDATE(), 0)
INSERT INTO [QuestionSet].[EnablementCriteriaListItem] VALUES(148, '3N0TVFD9', 1,1,GETDATE(), GETDATE(), 0)

--Step2: Enabling this field when selecting the above inserted trade from primary risk ID

--EnablementCriteriaSetID == 670, Live 671
EXEC [QuestionSet].[uspEnablementCriteriaSetInsert] 1

DECLARE @EnablementCriteriaSetID bigint
DECLARE @ComparatorQuestionID bigint
DECLARE @ComparatorValueOrID varchar(1000)
DECLARE @ComparatorValueFunctionID int
DECLARE @Operator varchar(2)
DECLARE @EnablementCriteriaListID bigint
DECLARE @InsertUserID bigint

SET @EnablementCriteriaSetID = (SELECT MAX( [EnablementCriteriaSetID]) FROM [Product].[QuestionSet].[EnablementCriteriaSet] WHERE CAST(InsertDateTime AS DATE) = CAST(GETDATE() AS date))
SET @ComparatorQuestionID = (SELECT MAX(QuestionID) FROM [QuestionSet].[Question] WHERE AnswerTableName = 'USER_MLIAB_TRDDTAIL' AND AnswerFieldName = 'PRIMARYRISK_ID') --IS Nothing but a questionID of PrimaryRiskID
SET @ComparatorValueOrID = NULL
SET @ComparatorValueFunctionID = NULL
SET @Operator = '=='
SET @EnablementCriteriaListID = 148
SET @InsertUserID = 1

EXEC [QuestionSet].[uspEnablementCriteriaInsert] @EnablementCriteriaSetID, @ComparatorQuestionID, @ComparatorValueOrID, @ComparatorValueFunctionID, @Operator, @EnablementCriteriaListID, @InsertUserID

--Step3: Enabling this field when selecting the above inserted trade from Secondary risk ID

--EnablementCriteriaSetID == 671,Live 672
EXEC [QuestionSet].[uspEnablementCriteriaSetInsert] 1

DECLARE @EnablementCriteriaSetID bigint
DECLARE @ComparatorQuestionID bigint
DECLARE @ComparatorValueOrID varchar(1000)
DECLARE @ComparatorValueFunctionID int
DECLARE @Operator varchar(2)
DECLARE @EnablementCriteriaListID bigint
DECLARE @InsertUserID bigint

SET @EnablementCriteriaSetID = (SELECT MAX( [EnablementCriteriaSetID]) FROM [Product].[QuestionSet].[EnablementCriteriaSet] WHERE CAST(InsertDateTime AS DATE) = CAST(GETDATE() AS date))
SET @ComparatorQuestionID = (SELECT MAX(QuestionID) FROM [QuestionSet].[Question] WHERE AnswerTableName = 'USER_MLIAB_TRDDTAIL' AND AnswerFieldName = 'SECONDARYRISK_ID') --IS Nothing but a questionID of SecondaryRiskID
SET @ComparatorValueOrID = NULL
SET @ComparatorValueFunctionID = NULL
SET @Operator = '=='
SET @EnablementCriteriaListID = 148
SET @InsertUserID = 1

EXEC [QuestionSet].[uspEnablementCriteriaInsert] @EnablementCriteriaSetID, @ComparatorQuestionID, @ComparatorValueOrID, @ComparatorValueFunctionID, @Operator, @EnablementCriteriaListID, @InsertUserID


--===============--==========EnablementCriteria-- Engineering===================================

--Step1: Enabling this field when selecting Yes for the field 'Manufatcure'

--EnablementCriteriaSetID == 671, Live 673
EXEC [QuestionSet].[uspEnablementCriteriaSetInsert] 1

DECLARE @EnablementCriteriaSetID bigint
DECLARE @ComparatorQuestionID bigint
DECLARE @ComparatorValueOrID varchar(1000)
DECLARE @ComparatorValueFunctionID int
DECLARE @Operator varchar(2)
DECLARE @EnablementCriteriaListID bigint
DECLARE @InsertUserID bigint

SET @EnablementCriteriaSetID = (SELECT MAX( [EnablementCriteriaSetID]) FROM [Product].[QuestionSet].[EnablementCriteriaSet] WHERE CAST(InsertDateTime AS DATE) = CAST(GETDATE() AS date))
SET @ComparatorQuestionID = (SELECT MAX(QuestionID) FROM [QuestionSet].[Question] WHERE AnswerTableName = 'USER_MLIAB_TRDDTAIL' AND AnswerFieldName = 'MANUFACTURE') --IS Nothing but a questionID of Manufature
SET @ComparatorValueOrID = 1
SET @ComparatorValueFunctionID = NULL
SET @Operator = '=='
SET @EnablementCriteriaListID = NULL
SET @InsertUserID = 1

EXEC [QuestionSet].[uspEnablementCriteriaInsert] @EnablementCriteriaSetID, @ComparatorQuestionID, @ComparatorValueOrID, @ComparatorValueFunctionID, @Operator, @EnablementCriteriaListID, @InsertUserID
	
---===============================[QuestionEnablementCriteriaSetLink]==========================================

--Step1: Linking the new questions to the newly added EnablementCriteriaSetIDs
--select * from [QuestionSet].[QuestionEnablementCriteriaSetLink]

INSERT INTO [QuestionSet].[QuestionEnablementCriteriaSetLink] VALUES (1362,671,1,1,GETDATE(), GETDATE(),0)
INSERT INTO [QuestionSet].[QuestionEnablementCriteriaSetLink] VALUES (1362,672,1,1,GETDATE(), GETDATE(),0)
INSERT INTO [QuestionSet].[QuestionEnablementCriteriaSetLink] VALUES (1363,673,1,1,GETDATE(), GETDATE(),0)
