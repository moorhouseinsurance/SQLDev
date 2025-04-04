USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[SP_OUTCOME_QUOTE]    Script Date: 26/03/2025 15:31:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by DHostler 
-- Create date: 30-Apr-2010
-- Description: Replacement for TGSL provied usp. This allows us to catch the SQL sent through and reformat the where clause as parameters.
-- =============================================

-- Date			Who						Change
-- 20/10/2022	Jeremai Smith			New QuoteDateTime column on SchemeCommandDebug table, and table renamed (Monday.com ticket 3396342226)
-- 31/08/2023	Linga			        Hyphen character in Claims text causes Declines - Replaced '&hypen;' with '&#45;' (Monday.com Ticket 5084334867)
-- 29/02/2024	Jeremai Smith			Changed @Input from VARCHAR(8000) to VARCHAR(MAX) due to long XML from Property Owners (Monday.com Ticket 6153526690)


ALTER PROCEDURE [dbo].[SP_OUTCOME_QUOTE]
	@Input VARCHAR(MAX)
AS

/* --Original Procedure
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[SP_OUTCOME_QUOTE]

@Input VARCHAR(8000)

AS

EXEC(@Input)
GO
*/

/*Test Harness
DECLARE @SQL VARCHAR(MAX)
SET @SQL = 'SELECT usp FROM uspSchemeTradesmansLiabilityFortis WHERE para1 = ''A'' AND PARA2 = ''1'' AND PARA3 = ''1.321'''
SELECT @SQL
EXEC [dbo].[SP_OUTCOME_QUOTE] @SQL


DECLARE @SQL VARCHAR(MAX)
DECLARE @Input VARCHAR(MAX)
SET @Input = 'SELECT usp from uspSchemeTradesmansLiabilityFortis WHERE para1 = ''A'' AND PARA2 = ''1'' AND PARA3 = ''1.321'''
PRINT @Input
		DECLARE @Pos int
		
		SET @Pos = PATINDEX('% FROM %',@Input)
		SET @SQL = SUBSTRING(@Input,@Pos+6,LEN(@Input)-@Pos-5)
				PRINT @SQL
		SET @SQL = REPLACE(REPLACE(@SQL,' AND ',',@'),' WHERE ',' @')
		PRINT @SQL
		EXEC(@SQL)
*/


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements
	SET NOCOUNT ON
	
	INSERT INTO [dbo].[SchemeCommandDebug] ([SchemeCommandText], [QuoteDateTime]) VALUES (@Input, GETDATE())

	IF @Input LIKE '%FROM usp%' OR  @Input LIKE '%FROM Calculators%'
	BEGIN --Call Procedure Instead
		DECLARE
			 @StartString varchar(100) = '= '' <'
			,@EndString varchar(100) = '>'' AND'
			,@SearchString1 varchar(100) = ''''
			,@ReplacementString1 varchar(100) = '&apos;'
			,@SearchString2 varchar(100) = ' AND '
			,@ReplacementString2 varchar(100) = ' &amp; '

		DECLARE
			@StringReplacementTable [dbo].[StringReplacementTableType],
			@StringReplacementXml xml

		INSERT INTO
			@StringReplacementTable ([CharacterRowNum],[CharacterFilter], [CharacterString])
		VALUES
			(1,' AND ', '&amp;'),
			(2,'''', '&apos;'),
			(3,'&', '&amp;'),
			/* monday - 5084334867
			--(4,' - ', '&hyphen;');
			*/
			(4,' - ', '&#45;');
		
		SET @StringReplacementXml = (SELECT * FROM @StringReplacementTable FOR XML PATH('StringReplacementTable'), TYPE)

		SET @Input = [Shared].[dbo].[svfReplaceMultipleStrings] (@Input, @StartString, @EndString, @StringReplacementXml)

		DECLARE @Pos int
		DECLARE @SQL varchar(Max)
		SET @Pos = PATINDEX('% FROM %',@Input)
		SET @SQL = SUBSTRING(@Input,@Pos+6,LEN(@Input)-@Pos-5)
		SET @SQL = REPLACE(REPLACE(REPLACE(@SQL,' AND ',',@'),' WHERE ',' @'), '1.00', '1')
		--Insert into uspSchemeCommandDebug (uspSchemeCommandText) VALUES (@SQL)
		EXEC(@SQL)
	END
	ELSE
	BEGIN
		--Print 'Run TGSL View'
		EXEC(@Input)
	END
END
