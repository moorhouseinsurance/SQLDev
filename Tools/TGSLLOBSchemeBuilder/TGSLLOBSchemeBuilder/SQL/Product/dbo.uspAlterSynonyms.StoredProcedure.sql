USE [Product]
GO
/****** Object:  StoredProcedure [dbo].[uspAlterSynonyms]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------
--Author:	D. Hostler
--Date:		16 Oct 2017
--Desc:		Change target database for a synonym
--------------------------------------------------

CREATE PROCEDURE [dbo].[uspAlterSynonyms]
	 @OldDB varchar(255)
	,@NewDB varchar(255)
AS

/*
	declare  @OldDB varchar(255) = '[Transactor_Live]'
	,@NewDB  varchar(255) = '[Transactor_UAT]'
	exec [dbo].[uspAlterSynonyms] @OldDB  ,@NewDB

	declare  @OldDB varchar(255) = '[Transactor_UAT]'
	,@NewDB  varchar(255) = '[Transactor_Live]'
		exec [dbo].[uspAlterSynonyms] @OldDB  ,@NewDB

*/

BEGIN	

	DECLARE @ObjectName sysname, @Definition VARCHAR(MAX), @Schema VARCHAR(50)
	DECLARE @SQL VARCHAR(MAX)

	DECLARE loccur CURSOR LOCAL STATIC FORWARD_ONLY READ_ONLY FOR
	SELECT name, SCHEMA_NAME(schema_id), base_object_name FROM sys.synonyms
	OPEN loccur

	FETCH NEXT FROM loccur INTO @ObjectName, @Schema, @Definition

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Converting: Synonym, ' + @ObjectName

		SET @SQL = 'DROP SYNONYM ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ObjectName)
	    EXEC(@SQL)

		SET @SQL = 'CREATE SYNONYM ' + QUOTENAME(@Schema) + '.' + QUOTENAME(@ObjectName) + ' FOR ' +
					  REPLACE(@Definition, @OldDB, @NewDB)
	    EXEC(@SQL)
	 print @sql

		FETCH NEXT FROM loccur INTO @ObjectName, @Schema, @Definition
	END

	CLOSE loccur
	DEALLOCATE loccur 
END


GO
