USE [Transactor_Support]
GO

/****** Object:  UserDefinedFunction [dbo].[tvfSplitStringByDelimiter]    Script Date: 17/12/2024 15:22:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Created By Richard Drew (rdrew)
-- Create date: 20-JUL-2009
-- Description:	Function to split the supplied a string based on the delimiter provided
-- =============================================
CREATE FUNCTION [dbo].[tvfSplitStringByDelimiter]
(
	@str VARCHAR(MAX),
	@delimeter CHAR(1)
)
/*
	DECLARE @str NVARCHAR(MAX)
	DECLARE @delimeter CHAR(1)
	
	SET @str = '1,2,3,4,5'
	SET @delimeter = ','

	SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@str, @delimeter)
	
*/


RETURNS @Result TABLE (Data VARCHAR(max))
AS

BEGIN
	DECLARE	@NextPos INT,
		@LastPos INT

	SELECT	@NextPos = CHARINDEX(@delimeter, @str, 1),
		@LastPos = 0

	WHILE @NextPos > 0
		BEGIN
			INSERT	@Result
				(
					Data
				)
			SELECT	SUBSTRING(@str, @LastPos + 1, @NextPos - @LastPos - 1)

			SELECT	@LastPos = @NextPos,
				@NextPos = CHARINDEX(@delimeter, @str, @NextPos + 1)
		END

	IF @NextPos <= @LastPos
		INSERT	@Result
			(
				Data
			)
		SELECT	SUBSTRING(@str, @LastPos + 1, DATALENGTH(@str) - @LastPos)

	RETURN
END




/*
--More Old Code
RETURNS @ret TABLE (Token VARCHAR(MAX))
AS
BEGIN
DECLARE @x XML
SET @x = '<t>' + REPLACE(@str, @delimeter, '</t><t>') + '</t>'
INSERT INTO @ret
SELECT x.i.value('.', 'VARCHAR(MAX)') AS token
FROM @x.nodes('//t') x(i)
RETURN
END
*/

/*
--OLD CODE 
(
	 @ItemList NVARCHAR(MAX)
	,@Delimiter CHAR(1)
)
RETURNS @IDTable TABLE (Item VARCHAR(50) PRIMARY KEY CLUSTERED)
AS  
   
--	TEST HARNESS	
--	To test this procedure, copy the whole commented section into a new query window, remove the lines
--	marked START and FINISH and run the statement

/* -- START

	DECLARE @ItemList NVARCHAR(MAX)
	DECLARE @Delimiter CHAR(1)
	
	SET @ItemList = '1,2,3,4,5'
	SET @Delimiter = ','

	SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@ItemList, @Delimiter)

*/ -- FINISH
BEGIN    
    DECLARE @TemporaryItemList NVARCHAR(MAX)
    SET @TemporaryItemList = @ItemList

    DECLARE @Index INT    
    DECLARE @Item NVARCHAR(4000)

    --SET @TemporaryItemList = REPLACE (@TemporaryItemList, ' ', '')
    SET @Index = CHARINDEX(@Delimiter, @TemporaryItemList)

    WHILE (LEN(@TemporaryItemList) > 0)
    BEGIN
        IF @Index = 0
            SET @Item = @TemporaryItemList
        ELSE
            SET @Item = LEFT(@TemporaryItemList, @Index - 1)
        INSERT INTO @IDTable(Item) VALUES(@Item)
        IF @Index = 0
            SET @TemporaryItemList = ''
        ELSE
            SET @TemporaryItemList = RIGHT(@TemporaryItemList, LEN(@TemporaryItemList) - @Index)
        SET @Index = CHARINDEX(@Delimiter, @TemporaryItemList)
    END 
    RETURN
    */
   

 
GO


