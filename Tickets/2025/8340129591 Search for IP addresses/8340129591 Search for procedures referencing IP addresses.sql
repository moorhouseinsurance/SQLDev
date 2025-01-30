SELECT
	 @@SERVERNAME AS [Server]
	, DB_NAME() AS [Database]
	,'[' + [SS].[name] + '].[' + [SO].[name] + ']' AS [Object]
	,[SO].[type_desc] AS [Type]
	,[SM].[Definition]
FROM
	[sys].[sql_modules] AS [SM]
	INNER JOIN [sys].[objects] AS [SO] ON [SM].[object_id] = [SO].[object_id]
	INNER JOIN [sys].[schemas] AS [SS] ON [SO].[schema_id] = [SS].[schema_id]
WHERE
	[definition] LIKE '%[0-9].[0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN -- These should speed things up as only ever searching for a number or a dot
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN
	OR [definition] LIKE '%[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]%' COLLATE LATIN1_GENERAL_BIN