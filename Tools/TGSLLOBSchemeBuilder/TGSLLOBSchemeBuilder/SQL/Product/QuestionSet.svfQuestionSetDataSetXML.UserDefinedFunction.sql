USE [Product]
GO
/****** Object:  UserDefinedFunction [QuestionSet].[svfQuestionSetDataSetXML]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:	DHostler 
-- Create date: 14-DEC-2010
-- Description: Returns XMl to match the DataSet XSD
-- Note https://connect.microsoft.com/SQLServer/feedback/details/265956/suppress-namespace-attributes-in-nested-select-for-xml-statements#
-- Therefore using Stuff temporarily until this issue is dealt with.
-- =============================================
CREATE FUNCTION [QuestionSet].[svfQuestionSetDataSetXML]
(
	 @AgentID char(32) = NULL
	,@ProductID char(32) = NULL
	,@Insured_Party_ID char(32)
	,@Insured_Party_History_ID int	
	,@Policy_Details_ID char(32)
	,@PolicyDetailsHistory_ID int
	,@AddOn bit	= NULL
	,@Selected bit = NULL
)
RETURNS	xml
AS

/*

BEGIN TRAN
	DECLARE @AgentID char(32)
	DECLARE @ProductID char(32)
	DECLARE @Insured_Party_ID char(32)
	DECLARE @Insured_Party_History_ID int	
	DECLARE @Policy_Details_ID char(32)
	DECLARE @PolicyDetailsHistory_ID int	
	DECLARE @XML xml
	DECLARE @AddOn bit
	DECLARE @Selected bit
	
	SET @AgentID = '5208F39A498E4706A91BEEC84ED25686'
	SET @ProductID = 'DD5B021CFDA44734957203889344C09E'
	SET @Insured_Party_ID = 'C6B041E22513420CA6D589A0D3E9BAAB'
	SET @Insured_Party_History_ID = 1	
	SET @Policy_Details_ID = 'CCF80C4E2F0A49BDBBB53874CA853427'
	SET @PolicyDetailsHistory_ID = 1
	SET @AddOn = 0
	SET @Selected = 0	

	SELECT [QuestionSet].[svfQuestionSetDataSetXML](@AgentID, @ProductID, @Insured_Party_ID,@Insured_Party_History_ID, @Policy_Details_ID, @PolicyDetailsHistory_ID, @AddOn, @Selected )

'503A067A9C5341F1B91781138689A631','A0E84546FD3E460884820F867CF62804'

ROLLBACK TRAN

--Test Data------------------------

SELECT
	 [CPL].[insured_party_ID], [CPL].[policy_details_id], [CPD].[Agent_ID]
FROM
	[dbo].[Customer_Policy_Details] AS [CPD] 
	JOIN [dbo].[Customer_Policy_Link] AS [CPL] ON [CPL].[Policy_Details_ID] = [CPD].[Policy_Details_ID]
WHERE
	[CPD].[Product_ID] = 'DD5B021CFDA44734957203889344C09E'
	AND [CPD].[Policynumber] = '154/012/M055/RAN'
--------------------------------------

*/

BEGIN

	SET @Addon = ISNULL(@AddOn,0)
	SET @Selected = ISNULL(@Selected,0)
	
	DECLARE @XML xml

	--;WITH XMLNameSpaces(DEFAULT 'http://WWW.MoorhouseInsurance.Co.UK/Schemas/Calculator/QuestionSet.xsd')

	;WITH [AQDIndexed] AS
	(
		SELECT 
			 ROW_NUMBER() OVER (PARTITION BY [Q].[QuestionID] ORDER BY [QS].[AgentID] DESC, [QS].[ProductID] DESC, [AQD].[AgentID] DESC,[AQD].[StartDateTime] DESC) AS [RowNumber]
			,[QS].[QuestionSetID]
			,[QS].[QuestionSetName]
			,@AgentID AS [QuestionSetAgentID]
			,@ProductID AS [ProductID]
			,[QS].[DevelopersNotes] AS [QuestionSetDevelopersNotes]
			,[Q].[QuestionID]
			,[Q].[AnswerTableName]
			,[Q].[AnswerFieldName]
			,[Q].[TailorQuoteFlag]						
			,[AQD].[AnswerDefaultValueOrID]
			,[AQD].[AnswerDefaultValueFunctionID]			
			,[AQD].[AnswerDefaultSet]
			,[AQD].[AnswerTypeID]
			,[AQD].[ChildQuestionRepeatMaximum]
			,[AQD].[ChildQuestionRepeatMinimum]
			,[AQD].[DevelopersNotes] AS [AgentQuestionDetailsDevelopersNotes]
			,[AQD].[Enabled]
			,[AQD].[HelpText]
			,[AQD].[ListTableID]
			,[AQD].[Mandatory]
			,[AQD].[MandatoryText]
			,[AQD].[ParentQuestionID]
			,[AQD].[QuickQuote]
			,[AQD].[SectionID]
			,[AQD].[SortOrder] AS [AgentQuestionDetailsSortOrder]
			,[AQD].[Text] AS [AgentQuestionDetailsText]
			,[AQD].[Visible]
			,[S].[GroupID]
			,[S].[SectionName]
			,[S].[Text] AS [SectionText]
			,[S].[SortOrder] AS [SectionSortOrder]
			,[G].[GroupName]
			,[G].[Text] AS [GroupText]
			,[G].[SortOrder] AS [GroupSortOrder]
			,[AT].[AnswerTypeName]
			,COALESCE([BT].[AnswerTypeName],[AT].[AnswerTypeName]) AS [ATBaseTypeName]
			,ISNULL([AT].[AnswerTypeBaseTypeID],[AT].[AnswerTypeID]) AS [ATAnswerTypeBaseTypeID]
			,COALESCE([AT].[Regex],[BT].[Regex]) AS [ATRegex]
			,COALESCE([AT].[StartRange],[BT].[StartRange]) AS [ATStartRange]
			,COALESCE([AT].[EndRange],[BT].[EndRange]) AS [ATEndRange]
			,COALESCE([AT].[StartRangeFunctionID],[BT].[StartRangeFunctionID]) AS [ATStartRangeFunctionID]
			,COALESCE([AT].[EndRangeFunctionID],[BT].[EndRangeFunctionID]) AS [ATEndRangeFunctionID]	
			,COALESCE([AT].[Length],[BT].[Length]) AS [ATLength]	
		FROM 
			[QuestionSet].[QuestionSet] AS [QS]		
			JOIN [QuestionSet].[Question] AS [Q] ON [QS].[QuestionSetID] = [Q].[QuestionSetID]
			JOIN [QuestionSet].[AgentQuestionDetails] AS [AQD] ON [Q].[QuestionID] = [AQD].[QuestionID]
			JOIN [QuestionSet].[AnswerType] AS [AT] ON [AQD].[AnswerTypeID] = [AT].[AnswerTypeID]
			LEFT JOIN [QuestionSet].[AnswerType] AS [BT] ON [AT].[AnswerTypeBaseTypeID] = [BT].[AnswerTypeID]
			JOIN [QuestionSet].[Section] AS [S] ON [S].[SectionID] = [AQD].[SectionID]
			JOIN [QuestionSet].[Group] AS [G] ON [G].[GroupID] = [S].[GroupID]
		WHERE
			([AQD].[AgentID] IS NULL OR [AQD].[AgentID] = @AgentID)
			AND
			(
				([QS].[QuestionSetID] = 1 AND @AddOn = 0)
				OR
				(
					([QS].[AgentID] IS NULL OR [QS].[AgentID] = @AgentID)
					 AND [QS].[ProductID] = @ProductID					
				)
			)						    
	)
	,
	CTE AS
	(		
		SELECT 
			 [AQDIndexed].*
			,[CQO].[CalculatedQuestionID] AS [CQOCalculatedQuestionID]
			,[CQO].[ParameterQuestionID] AS [CQOParameterQuestionID]
			,[CQO].[Position] AS [CQOPosition]
			,[CQO].[Operator] AS [CQOOperator]
			,[CQO].[ParameterValue] AS [CQOParameterValue]			
			,[CQO].[ParameterValueFunctionID] AS [CQOParameterValueFunctionID]
			,[QECSL].[QuestionID] AS [QECSLQuestionID]
			,[QECSL].[EnablementCriteriaSetID] AS [QECSLEnablementCriteriaSetID]	
			,[EC].[EnablementCriteriaID] AS [ECEnablementCriteriaID]
			,[EC].[EnablementCriteriaSetID] AS [ECEnablementCriteriaSetID]				
			,[EC].[ComparatorQuestionID] AS [ECComparatorQuestionID]
			,[EC].[ComparatorValueOrID]	AS [ECComparatorValueOrID]
			,[EC].[ComparatorValueFunctionID] AS [ECComparatorValueFunctionID]
			,[EC].[EnablementCriteriaListID] AS [ECEnablementCriteriaListID]
			,[EC].[Operator] AS [ECOperator]	
			,[ECLI].[EnablementCriteriaListID] AS [ECLIEnablementCriteriaListID]
			,[ECLI].[ListValue] AS [ECLIListValue]		
		FROM
			[AQDIndexed]
			LEFT JOIN [QuestionSet].[CalculatedQuestionOperation] AS [CQO] ON [AQDIndexed].[QuestionID] = [CQO].[CalculatedQuestionID]
			LEFT JOIN [QuestionSet].[QuestionEnablementCriteriaSetLink] AS [QECSL] ON [AQDIndexed].[QuestionID] = [QECSL].[QuestionID]		
			LEFT JOIN [QuestionSet].[EnablementCriteria] AS [EC] ON [QECSL].[EnablementCriteriaSetID] = [EC].[EnablementCriteriaSetID]		
			LEFT JOIN [QuestionSet].[EnablementCriteriaListItem] AS [ECLI] ON [EC].[EnablementCriteriaListID] = [ECLI].[EnablementCriteriaListID]								
		WHERE [AQDIndexed].[RowNumber] = 1
		
	)
	,LTN AS
	(
		SELECT DISTINCT
			[ListTableID]
		FROM [CTE]
		WHERE
			[ListTableID] IS NOT NULL
	) 
	,QID AS
	(
		SELECT DISTINCT
			[QuestionID]
		   ,[AnswerTableName]
		   ,[AnswerFieldName]
		FROM 
			[CTE]
	) 
	,EC AS		
	(
		SELECT DISTINCT
			 [ECEnablementCriteriaID] AS [EnablementCriteriaID]
			,[ECEnablementCriteriaSetID] AS [EnablementCriteriaSetID]
			,[ECComparatorQuestionID] AS [ComparatorQuestionID]
			,[ECComparatorValueOrID] AS [ComparatorValueOrID]
			,[ECOperator] AS [Operator]
			,[ECEnablementCriteriaListID] AS [EnablementCriteriaListID]
			,[ECComparatorValueFunctionID] AS [ComparatorValueFunctionID]
		FROM
			[CTE]
	)
	,QSID AS
	(
		SELECT DISTINCT [QuestionSetID] FROM [AQDIndexed]
	)
	,[AddOn] AS--Remember to change server and database link on release.
	(
		SELECT 
			  [AddOnQuestionSetID] AS [QuestionSetID]
			 ,[QS].[ProductID]
			 ,[P].[ProductType_ID] AS [ProductTypeID]
			 ,[P].[Reference] AS [WebReference]
			 ,[MA].[PolicyDetailsID]
			 ,ISNULL([MA].[Selected],0) AS [Selected]
		FROM 
			[QSID]
			JOIN [QuestionSet].[AddOn] AS [A] ON [QSID].[QuestionSetID] = [A].[QuestionSetID]
			JOIN [QuestionSet].[QuestionSet] AS [QS] ON  [A].[AddOnQuestionSetID] = [QS].[QuestionSetID] 
			JOIN [dbo].[RM_Product] AS [P] ON [QS].[ProductID] = [P].[Product_ID] 
			LEFT JOIN [Moorhouse].[AddOn] AS [MA] ON [MA].[ParentPolicyDetailsID] = @Policy_Details_ID AND [QS].[ProductID] = [MA].[ProductID]
		WHERE 
			@AddOn = 0
	)
	,[AddOnQuestion] AS
	(
		SELECT DISTINCT
				 [CTE].[QuestionSetID] * 100000 AS [QuestionID]
				,[CTE].[QuestionSetID]
				,'Table' + CAST([CTE].[QuestionSetID] AS varchar(4)) AS [AnswerTableName]
				,'Answer' + CAST([CTE].[QuestionSetID]  AS varchar(4)) AS [AnswerFieldName]
				,1 AS [TailorQuoteFlag]			
				,CAST(@Selected AS varchar(50)) AS [AnswerDefaultValueOrID]
				,1 AS [AnswerDefaultSet]
				,4 AS [AnswerTypeID]
				,NULL AS [ListTableID]
				,NULL AS [ChildQuestionRepeatMaximum]
				,NULL AS [ChildQuestionRepeatMinimum]
				,'Question not stored in DB, created dynamically' AS [DevelopersNotes]
				,1 AS [Enabled]
				,ISNULL([AD].[HelpText],'') AS [HelpText]
				,0 AS [Mandatory]
				,NULL AS [MandatoryText]
				,NULL AS [ParentQuestionID]
				,0 AS [QuickQuote]
				,[SectionID] AS [SectionID] --Optional Cover
				,'0' AS [SortOrder]
				,'Do you require ' + [QuestionSetName] + ' as additional cover?' AS [Text]
				,1 AS [Visible]		
		FROM
			[CTE] 	
			LEFT JOIN [QuestionSet].[AddOnDetails] AS [AD] ON [CTE].[QuestionSetID] = [AD].[QuestionSetID]				
		WHERE
			@AddOn = 1
	)

	,[AddonEnablementCriteriaSetLink] AS
	(
		SELECT DISTINCT
			 [QuestionID] AS [QuestionID]
			,([QuestionSetID]*100000) + [QuestionID]	AS [EnablementCriteriaSetID]
		FROM
			[CTE]
		WHERE 
			@AddOn = 1
	)
	,[AddonEnablementCriteria] AS
	(
		SELECT DISTINCT
			 ([QuestionSetID]*100000) + [QuestionID] AS [EnablementCriteriaID]
			,([QuestionSetID]*100000)  + [QuestionID] AS [EnablementCriteriaSetID]
			,([QuestionSetID]*100000) AS [ComparatorQuestionID]
			,'1' AS [ComparatorValueOrID]
			,'==' AS [Operator]
			,NULL AS [EnablementCriteriaListID]
		FROM
			[CTE]
		WHERE
			@AddOn = 1
	)			
	,[EnablementCriteriaSet] AS
	(
		SELECT DISTINCT
			 [QECSLQuestionID] AS [QuestionID]
			,[QECSLEnablementCriteriaSetID]	AS [EnablementCriteriaSetID]
		FROM
			[CTE]
		WHERE 
			[QECSLQuestionID] IS NOT NULL

		UNION
		SELECT * FROM [AddonEnablementCriteriaSetLink]
	)	
	,[EnablementCriteria] AS
	(
		SELECT
			 [EnablementCriteriaID]
			,[EnablementCriteriaSetID]
			,[ComparatorQuestionID]
			,COALESCE([ComparatorValueOrID],[CVF].[Value]) AS [ComparatorValueOrID]
			,[Operator]
			,[EnablementCriteriaListID]
		FROM
			[EC]
			OUTER APPLY [QuestionSet].[tvfComparatorValueFunction]([ComparatorValueFunctionID]) AS [CVF]
		WHERE
			[EnablementCriteriaID] IS NOT NULL

		UNION
		SELECT * FROM [AddonEnablementCriteria]
	)	
	,[AddonAnswerType] AS
	(
		SELECT
			 4 AS [AnswerTypeID]
			,'Boolean' AS [AnswerTypeName]
			,'Boolean' AS [BaseTypeName]
			,4 AS [AnswerTypeBaseTypeID]
			,NULL AS [Regex]
			,NULL AS [StartRange]
			,NULL AS [EndRange]
			,NULL AS [Length]		
		WHERE 
			@AddOn = 1
	)

	,[AnswerType] AS
	(
		SELECT DISTINCT
			 [AnswerTypeID]
			,[AnswerTypeName]
			,[ATBaseTypeName] AS [BaseTypeName]
			,[ATAnswerTypeBaseTypeID] AS [AnswerTypeBaseTypeID]
			,[ATRegex] AS [Regex]
			,COALESCE([SRF].[Value],[ATStartRange]) AS [StartRange]
			,COALESCE([ERF].[Value],[ATEndRange]) AS [EndRange]
			,[ATLength] AS [Length]
		FROM [CTE]
		OUTER APPLY [QuestionSet].[tvfComparatorValueFunction]([ATStartRangeFunctionID]) AS [SRF]		
		OUTER APPLY [QuestionSet].[tvfComparatorValueFunction]([ATEndRangeFunctionID]) AS [ERF]		
						
		UNION
		SELECT * FROM [AddonAnswerType]
	) 			

	,[Question] AS
	(
		SELECT DISTINCT
			 [QuestionID]
			,[QuestionSetID]
			,[AnswerTableName]
			,[AnswerFieldName]
			,CASE WHEN @AddOn = 1 THEN 1 ELSE [TailorQuoteFlag] END AS [TailorQuoteFlag]	
			,COALESCE([AnswerDefaultValueOrID],[ADVF].[Value]) AS [AnswerDefaultValueOrID]
			,[AnswerDefaultSet]
			,[AnswerTypeID]
			,[ListTableID]
			,[ChildQuestionRepeatMaximum]
			,[ChildQuestionRepeatMinimum]
			,[AgentQuestionDetailsDevelopersNotes] AS [DevelopersNotes]
			,[Enabled]
			,[HelpText]
			,[Mandatory]
			,[MandatoryText]
			,[ParentQuestionID]
			,[QuickQuote]
			,[SectionID]
			,CASE WHEN @AddOn = 1 THEN [QuestionSetID] * 100000 + [AgentQuestionDetailsSortOrder] ELSE [AgentQuestionDetailsSortOrder] END AS [SortOrder]
			,[AgentQuestionDetailsText] AS [Text]
			,[Visible]
		FROM
			[CTE] 
			 OUTER APPLY [QuestionSet].[tvfComparatorValueFunction]([AnswerDefaultValueFunctionID]) AS [ADVF]
			 
		UNION
		SELECT * From [AddOnQuestion]
	)


	SELECT @xml =
	(

		SELECT
		(		
			SELECT * From [Question]						
			FOR XML PATH('Question'), TYPE
		) 
		,
		(
			SELECT * FROM [AnswerType]				
			FOR XML PATH('AnswerType'), TYPE	
		) 						
		,
		(
			SELECT DISTINCT
				 [CQOCalculatedQuestionID] AS [CalculatedQuestionID]
				,[CQOParameterQuestionID] AS [ParameterQuestionID]
				,COALESCE([CQOParameterValue],[CVF].[Value]) AS [ParameterValue]			
				,[CQOPosition] AS [Position]
				,[CQOOperator] AS [Operator]
			FROM 
				[CTE]	
				OUTER APPLY [QuestionSet].[tvfComparatorValueFunction]([CQOParameterValueFunctionID]) AS [CVF]			
			WHERE  
				[CQOCalculatedQuestionID] IS NOT NULL
			FOR XML PATH('CalculatedQuestionOperation'), TYPE			
		)
		,
		(
			SELECT * FROM [EnablementCriteria]
			FOR XML PATH('EnablementCriteria'), TYPE	
		)
		,
		(
			SELECT DISTINCT
				 [GroupID]
				,[GroupName]
				,[GroupText] AS [Text]
				,[GroupSortOrder] AS [SortOrder]
			FROM [CTE]
			WHERE
				[GroupID] IS NOT NULL
			FOR XML PATH('Group'), TYPE	
		)		
		,
		(
			SELECT * FROM [EnablementCriteriaSet]
			FOR XML PATH('QuestionEnablementCriteriaSetLink'), TYPE	
		)	
		,
		(
			SELECT DISTINCT
				 [QuestionSetID]
				,[QuestionSetName]
				,@AgentID AS [AgentID]
				,@ProductID AS [ProductID]
				,@Policy_Details_ID AS [PolicyDetailsID]
				,@PolicyDetailsHistory_ID AS [PolicyDetailsHistoryID]
				,@Insured_Party_ID AS [InsuredPartyID]
				,@Insured_Party_History_ID AS [InsuredPartyHistoryID]
				,[QuestionSetDevelopersNotes] AS [DeveloperNotes]
			FROM
				[CTE]	
			FOR XML PATH('QuestionSet'), TYPE			
		)
		,
		(
			SELECT DISTINCT
				 [SectionID]
				,[GroupID]
				,[SectionName]
				,[SectionText] AS [Text]
				,[SectionSortOrder] AS [SortOrder]
			FROM [CTE]
			FOR XML PATH('Section'), TYPE
		)
		,
		(
			SELECT
				 [LT].[ListTableID] AS [ListTableID]
				,[LT].[ValueID]
				,[LT].[Value]
			FROM 
				[LTN]			
				CROSS APPLY [QuestionSet].[tvfListTable]([ListTableID] ,@AgentID ,@ProductID) AS [LT]
			FOR XML PATH('ListTable'), TYPE
		)
		,
		(
			SELECT 
				 [QID].[QuestionID]
				,[tvfPPA].[PrimaryKeyID]
				,[tvfPPA].[FieldValue]
			FROM 
				[QID]
				JOIN [QuestionSet].[tvfProductPolicyAnswer](@ProductID,@Insured_Party_ID,@Insured_Party_History_ID,@Policy_Details_ID,@PolicyDetailsHistory_ID) AS [tvfPPA] ON ([QID].[AnswerTableName] = [tvfPPA].[TableName] AND [QID].[AnswerFieldName] = [tvfPPA].[FieldName]) 
			WHERE 
				[tvfPPA].[PrimaryKeyID] IS NOT NULL
				AND @AddOn = 0 OR @Selected = 1
			FOR XML PATH('Answer'), TYPE	
		) 	
		,
		(
			SELECT DISTINCT
				 [ECLIEnablementCriteriaListID] AS [EnablementCriteriaListID]
				,[ECLIListValue] AS [ListValue]
			FROM
				[CTE]
			WHERE
				[ECLIEnablementCriteriaListID] IS NOT NULL
			FOR XML PATH('EnablementCriteriaListItem'), TYPE	
		)
		,
		(
			SELECT 
				 [QuestionSetID]
				,[ProductID]
				,[ProductTypeID]
				,[WebReference]
				,[PolicyDetailsID]
				,[Selected]
			FROM 
				[AddOn]
			WHERE 
				@AddOn = 0
				
			FOR XML PATH('AddOn'), TYPE	
		) 				
		FOR XML PATH('QuestionSet'), TYPE
	)

	SET @XML = STUFF(Convert(varchar(max),@XML),13,0,' xmlns="http://WWW.MoorhouseInsurance.Co.UK/Schemas/Calculator/QuestionSet.xsd"')

	RETURN @xml
END	


GO
