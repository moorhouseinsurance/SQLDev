USE [Product]
GO
/****** Object:  StoredProcedure [Content].[uspSchemeSelect]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Content].[uspSchemeSelect]
	 @SchemeID nvarchar(32)
	,@PolicyStartDateTime datetime
AS
/*
	DECLARE @SchemeID nvarchar(32) = '2E76BD3831CD4FA68719AE81A711FB70'
	DECLARE @PolicyStartDateTime datetime = getdate()
	EXEC [Content].[uspSchemeSelect] @SchemeID, @PolicyStartDateTime
	
	SELECT * FROM  [Content].[Scheme]
		SELECT * FROM  [Content].[Insurer]
*/
BEGIN
	SELECT TOP 1 
		 [S].[Name]
		,[I].[InsurerDetails]
		,[S].[KeyProductInformation]
		,[S].[PolicyDetails]
		,[S].[ImportantInformation]
	FROM  
		[Content].[Scheme] AS [S]
		JOIN [Content].[Insurer] AS [I] ON [S].[InsurerID] = [I].[InsurerID]
	WHERE
		[S].[SchemeID] = @SchemeID
		AND [S].[StartDateTime] <= 	@PolicyStartDateTime
		AND ISNULL([S].[EndDateTime],@PolicyStartDateTime) >= @PolicyStartDateTime
		AND [I].[StartDateTime] <= 	@PolicyStartDateTime
		AND ISNULL([I].[EndDateTime],@PolicyStartDateTime) >= @PolicyStartDateTime		
	ORDER BY
		 [S].[StartDateTime] DESC
		,[I].[StartDateTime] DESC
END

GO
