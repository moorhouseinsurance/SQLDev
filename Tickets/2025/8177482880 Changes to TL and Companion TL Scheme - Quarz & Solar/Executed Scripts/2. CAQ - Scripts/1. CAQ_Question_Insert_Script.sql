USE [Product]
GO

-- =============
-- New questions
-- =============

-- Trade details
-- -------------
--
-- New Question 1 - Do you Manufacture, Process (including cutting/grinding) or Supply any Kitchen Worktops (or any other similar products)?

DECLARE @QuestionSetID int = 2 -- Tradesman Liability
DECLARE @AnswerTableName varchar(50) = 'USER_MLIAB_TRDDTAIL'
DECLARE @AnswerFieldName varchar(50) = 'MANUFACTURE'
DECLARE @TailorQuoteFlag bit = NULL
DECLARE @InsertUserID int = 1

--EXEC [QuestionSet].[uspQuestionInsert] @QuestionSetID, @AnswerTableName, @AnswerFieldName, @TailorQuoteFlag, @InsertUserID;

--UAT QuestionID = 1375
--LIVE QuestionID = 1362
DECLARE @QuestionID bigint = (SELECT [Q].[QuestionID] FROM [QuestionSet].[Question] AS [Q] WHERE [AnswerTableName] = @AnswerTableName AND [AnswerFieldName] = @AnswerFieldName)
DECLARE @AgentID char(32) = NULL
DECLARE @AnswerDefaultValueOrID varchar(50) = '0'
DECLARE @AnswerDefaultSet bit = NULL
DECLARE @AnswerTypeID bigint = 4 -- 1 = List value ID
DECLARE @ChildQuestionRepeatMaximum int = NULL
DECLARE @ChildQuestionRepeatMinimum int = NULL
DECLARE @DevelopersNotes varchar(4000) = NULL
DECLARE @Enabled bit = 'False'
DECLARE @HelpText varchar(1000) = ''
DECLARE @ListTableID int = NULL
DECLARE @Mandatory bit = 'True'
DECLARE @MandatoryText varchar(1000) = NULL
DECLARE @ParentQuestionID bigint = NULL
DECLARE @QuickQuote bit = 1
DECLARE @SectionID int = 159
DECLARE @SortOrder int = (SELECT MAX([AQD].[SortOrder])
						  FROM [QuestionSet].[Question] AS [Q]
						  INNER JOIN [QuestionSet].[AgentQuestionDetails]  AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
						  WHERE [AQD].[SectionID] = @SectionID
						  AND [Q].[AnswerTableName] = @AnswerTableName
						  AND [Q].[QuestionSetID] = @QuestionSetID
						  --AND [Q].[AnswerFieldName] = 'CONVICTED_ID' -- New question will be inserted after this question
						 ) + 1
DECLARE @Text varchar(4000) = 'Do you Manufacture, Process (including cutting/grinding) or Supply any Kitchen Worktops (or any other similar products)?'
DECLARE @Visible bit = 'True'
DECLARE @StartDateTime datetime = '01 Jan 1990';----CONVERT(date, GETDATE());

EXEC [QuestionSet].[uspAgentQuestionDetailsInsert] @QuestionID, @AgentID, @AnswerDefaultValueOrID, @AnswerDefaultSet, @AnswerTypeID, @ChildQuestionRepeatMaximum, @ChildQuestionRepeatMinimum, @DevelopersNotes, @Enabled, @HelpText, @ListTableID, @Mandatory, @MandatoryText, @ParentQuestionID, @QuickQuote, @SectionID, @SortOrder, @Text, @Visible, @StartDateTime, @InsertUserID;

GO
-- UAT 1396
--Live 1382

-- Trade details
-- ----------------

-- New Question 2 - 'Please confirm that you have ensured that: 
--					i. any exposure to stone dust (particularly silica dust) is adequately controlled using engineering methods such as water suppression and local exhaust ventilation, and
--					ii. suitable controls are provided for all manufacturing, grinding, and cutting activities, irrelevant of duration and location (indoors or outdoors) and
--					iii. adequate and suitable Personal Protective Equipment (PPE) Respiratory Protective Equipment (RPE) is available for use by all employees and
--					iv. any RPE is appropriate, adequate, properly maintained and its use enforced
--					v. there is the provision of information, instruction, and training to employees on the risks and control measures required



DECLARE @QuestionSetID int = 2 -- Tradesman Liability
DECLARE @AnswerTableName varchar(50) = 'USER_MLIAB_TRDDTAIL'
DECLARE @AnswerFieldName varchar(50) = 'ENGINEERING'
DECLARE @TailorQuoteFlag bit = NULL
DECLARE @InsertUserID int = 1

--EXEC [QuestionSet].[uspQuestionInsert] @QuestionSetID, @AnswerTableName, @AnswerFieldName, @TailorQuoteFlag, @InsertUserID;

-----QuestionID = 1376
-----Live QuestionID = 1363
DECLARE @QuestionID bigint = (SELECT [Q].[QuestionID] FROM [QuestionSet].[Question] AS [Q] WHERE [AnswerTableName] = @AnswerTableName AND [AnswerFieldName] = @AnswerFieldName)
DECLARE @AgentID char(32) = NULL
DECLARE @AnswerDefaultValueOrID varchar(50) = '0'
DECLARE @AnswerDefaultSet bit = NULL
DECLARE @AnswerTypeID bigint = 4 -- 1 = List value ID
DECLARE @ChildQuestionRepeatMaximum int = NULL
DECLARE @ChildQuestionRepeatMinimum int = NULL
DECLARE @DevelopersNotes varchar(4000) = NULL
DECLARE @Enabled bit = 'False'
DECLARE @HelpText varchar(1000) = ''
DECLARE @ListTableID int = NULL
DECLARE @Mandatory bit = 'True'
DECLARE @MandatoryText varchar(1000) = NULL
DECLARE @ParentQuestionID bigint = NULL
DECLARE @QuickQuote bit = 1
DECLARE @SectionID int = 159
DECLARE @SortOrder int = (SELECT MAX([AQD].[SortOrder])
						  FROM [QuestionSet].[Question] AS [Q]
						  INNER JOIN [QuestionSet].[AgentQuestionDetails]  AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
						  WHERE [AQD].[SectionID] = @SectionID
						  AND [Q].[AnswerTableName] = @AnswerTableName
						  AND [Q].[QuestionSetID] = @QuestionSetID
						  --AND [Q].[AnswerFieldName] = 'CONVICTED_ID' -- New question will be inserted after this question
						 ) + 1
DECLARE @Text varchar(4000) = N'Please confirm that you have ensured that:
'+CHAR(13)+'
i. any exposure to stone dust (particularly silica dust) is adequately controlled using engineering methods such as water suppression and local exhaust ventilation, and
'+CHAR(13)+'
ii. suitable controls are provided for all manufacturing, grinding, and cutting activities, irrelevant of duration and location (indoors or outdoors) and
'+CHAR(13)+'
iii. adequate and suitable Personal Protective Equipment (PPE) Respiratory Protective Equipment (RPE) is available for use by all employees and
'+CHAR(13)+'
iv. any RPE is appropriate, adequate, properly maintained and its use enforced
'+CHAR(13)+'
v. there is the provision of information, instruction, and training to employees on the risks and control measures required'
DECLARE @Visible bit = 'True'
DECLARE @StartDateTime datetime =  '01 Jan 1990';----CONVERT(date, GETDATE());

EXEC [QuestionSet].[uspAgentQuestionDetailsInsert] @QuestionID, @AgentID, @AnswerDefaultValueOrID, @AnswerDefaultSet, @AnswerTypeID, @ChildQuestionRepeatMaximum, @ChildQuestionRepeatMinimum, @DevelopersNotes, @Enabled, @HelpText, @ListTableID, @Mandatory, @MandatoryText, @ParentQuestionID, @QuickQuote, @SectionID, @SortOrder, @Text, @Visible, @StartDateTime, @InsertUserID;
---1397
--Live 1383
GO

--===============




