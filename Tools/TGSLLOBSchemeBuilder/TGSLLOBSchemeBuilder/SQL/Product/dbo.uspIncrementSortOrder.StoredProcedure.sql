USE [Product]
GO
/****** Object:  StoredProcedure [dbo].[uspIncrementSortOrder]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------
--Author		D. Hostler
--Date			18 Oct 2017
--Desc			Moves the questions sortorder
-------------------------------------------

CREATE PROCEDURE [dbo].[uspIncrementSortOrder]
	 @QuestionSetName varchar(255)
	,@StartSortOrder int
	,@IncrementValue int

AS
BEGIN

	UPDATE 
		[AQD]
	SET
		[SortOrder] = [SortOrder] + @IncrementValue
	FROM
		[QuestionSet].[QuestionSet] AS [QS] 	
		JOIN [Product].[QuestionSet].[Question] AS [Q] ON [QS].[QuestionSetID] = [Q].[QuestionSetID] 
		JOIN [Product].[QuestionSet].[AgentQuestionDetails] AS [AQD] ON  [Q].[QuestionID] = [AQD].[QuestionID]
	WHERE
		[QS].[QuestionSetName] = @QuestionSetName
		AND [AQD].[SortOrder] >= @StartSortOrder
END

GO
