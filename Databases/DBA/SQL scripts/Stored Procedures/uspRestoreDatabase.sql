USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[uspRestoreDatabase]    Script Date: 20/01/2025 15:11:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
--Author	Linga
--Date		20 Nov 2023
--Desc		Restore  database (Single data file single log file as per prodec)
*******************************************************************************
-- Date			Who						Change

-- 20/01/2025   Simon                   Will now restore on any version of MHGSQL01, else will return 1.
										Change @Log and @Data variables to use instance name in folder path.
*******************************************************************************/

CREATE PROCEDURE [dbo].[uspRestoreDatabase]
	 @DBName varchar(200)
	,@DBLocalName  varchar(200) = NULL
	,@Source Nvarchar(200)
AS

/*

DECLARE @RC int
DECLARE @DBName varchar(200) = 'Product'
DECLARE @DBLocalName varchar(200) = 'Product'
DECLARE @Source nvarchar(200) = 'X:\sql_backups\TGSL\Product_01082024.bak'

EXECUTE @RC = [dbo].[uspRestoreDatabase] @DBName ,@DBLocalName ,@Source

*/

BEGIN
	SET NOCOUNT ON
	DECLARE @ReturnCode int = 0

	IF @@ServerName NOT LIKE  'MHGSQL01\%'
		RETURN 1

	/*
		Exit the procedure if server = MHGSQL01\TGSL and database = Transactor_Live
		We would never want to restore anything over the live Transactor_Live db (unless something has gone very wrong!)
	*/
	IF @@ServerName =  'MHGSQL01\TGSL' AND @DBName = 'Transactor_Live'
		RETURN 1

	IF @DBLocalName IS NULL
		SET @DBLocalName = @DBName

	IF 	@Source = ''
		RETURN 2

	BEGIN
		DECLARE @Log Nvarchar(200) = ''
		DECLARE @Data Nvarchar(200) = ''
		DECLARE @LogicalNameData Nvarchar(200) = ''
		DECLARE @LogicalNameLog Nvarchar(200) = ''
		DECLARE @InstanceName Nvarchar(200) = ''

		SELECT @InstanceName = @@servicename;
		SELECT @LogicalNameData = [M].[Name] FROM [MHGSQL01\TGSL].[DBA].[sys].[master_files] AS [M] JOIN [MHGSQL01\TGSL].[DBA].[sys].[Databases] AS [D] ON [M].[Database_ID] = [D].[Database_ID] WHERE [D].[Name] = @DBName AND type_desc= 'ROWS'
		SELECT @LogicalNameLog = [M].[Name] FROM [MHGSQL01\TGSL].[DBA].[sys].[master_files] AS [M] JOIN [MHGSQL01\TGSL].[DBA].[sys].[Databases] AS [D] ON [M].[Database_ID] = [D].[Database_ID] WHERE [D].[Name] = @DBName AND type_desc= 'LOG'

		SET @log = N'L:\SQL_Logs\'  + @InstanceName + '\' + @DBLocalName + '.ldf'
		SET @Data = N'S:\SQL_Data\' + @InstanceName + '\' + @DBLocalName + '.mdf'

		DECLARE @ExistsLocalDB bit
		SET @ExistsLocalDB = (SELECT CASE WHEN COUNT(*) != 0 THEN 1 ELSE 0 END FROM [sys].[Databases] WHERE [Name] = @DBLocalName)

		DECLARE @SQL NVARCHAR(2000);
		SET @SQL = 
		CASE WHEN @ExistsLocalDB = 1 THEN N'
			ALTER DATABASE '	+ @DBLocalName + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
			RESTORE DATABASE '	+ @DBLocalName + ' FROM  DISK = @Source WITH FILE = 1, NOUNLOAD,  REPLACE,  STATS = 10,
				MOVE '''	+ @LogicalNameData + ''' TO @Data,
				MOVE '''	+ @LogicalNameLog + ''' TO @log;
			ALTER DATABASE '	+ @DBLocalName + ' SET MULTI_USER WITH ROLLBACK IMMEDIATE'	
		ELSE
			N'
			RESTORE DATABASE '	+ @DBLocalName + ' FROM  DISK = @Source WITH FILE = 1, NOUNLOAD,  REPLACE,  STATS = 10,
				MOVE '''	+ @LogicalNameData + ''' TO @Data,
				MOVE '''	+ @LogicalNameLog + ''' TO @log;'
		END

		EXEC @ReturnCode = sp_executesql @SQL ,N'@Source varchar(200) ,@Data varchar(200) ,@Log varchar(200)' ,@Source ,@Data ,@Log
		IF @ReturnCode != 0
			SET @ReturnCode = 3


		IF @ReturnCode = 0 
		BEGIN
			SET @SQL = 'use ' + @DBLocalName + ';' 
			+ 'IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[uspConfigureDatabase]'') AND type in (N''P'', N''PC''))
			      EXEC [dbo].[uspConfigureDatabase];'

			EXEC @ReturnCode = sp_executesql @SQL
			IF @ReturnCode != 0
				SET @ReturnCode = 4
		END

	END
	RETURN @ReturnCode
END






GO


