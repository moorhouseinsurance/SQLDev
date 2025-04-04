USE [Product]
GO
/****** Object:  UserDefinedFunction [dbo].[tvfSplit]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	Created by Devlin Hostler
-- Create date: 02 Mar2018
-- Description: Split csv to single column
-- =============================================
CREATE FUNCTION [dbo].[tvfSplit]
(
	 @String VARCHAR(max)
	,@Delimiter CHAR(1) = ','
)
RETURNS @ReturnTable TABLE 
(
	  col1 VARCHAR(100) 
)		 
	 		 
AS
/*
	 DECLARE @String NVARCHAR(4000) = 'a,b,c,d'
	 DECLARE @Delimiter NCHAR(1) = ','
	
	SELECT * FROM [dbo].[tvfSplit](@String, @Delimiter)

*/
BEGIN

	DECLARE @x XML
	SET @String = REPLACE(@String,'&','&amp;')
	SELECT @x = CAST(('<A>' + REPLACE(@String, @Delimiter, '</A><A>') + '</A>') AS XML)

	;WITH [R] AS
	(
		SELECT
			 t.value('.', 'VARCHAR(100)') AS [Col]
		FROM
			@x.nodes('/A') AS x (t)
	)
	INSERT INTO @ReturnTable
	SELECT [Col] FROM [R]
RETURN 
END	

GO
