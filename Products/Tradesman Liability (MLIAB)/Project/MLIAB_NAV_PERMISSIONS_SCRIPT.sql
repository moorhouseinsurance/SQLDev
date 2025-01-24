INSERT INTO [dbo].[NAV_PERM_MLIAB_IND]
           ([PERM_MLIAB_IND_ID]
           ,[NAV_MLIAB_IND_ID]
           ,[ROLE_ID])
           (SELECT
			NEWID() AS [ID]
			,[Data].[NAV_MLIAB_IND_ID]
			,[Role].[ROLE_ID]
			FROM [dbo].[NAV_FIELDS_MLIAB_IND] AS [Data]
			CROSS APPLY [dbo].[SYSTEM_ROLE] AS [Role]
			WHERE NOT EXISTS (SELECT
							  *
							  FROM [dbo].[NAV_PERM_MLIAB_IND] AS [P]
							  WHERE [Data].[NAV_MLIAB_IND_ID] = [P].[NAV_MLIAB_IND_ID]))
GO

INSERT INTO [dbo].[NAV_PERM_MLIAB_ADD]
           ([PERM_MLIAB_ADD_ID]
           ,[NAV_MLIAB_ADD_ID]
           ,[ROLE_ID])
           (SELECT
			NEWID() AS [ID]
			,[Data].[NAV_MLIAB_ADD_ID]
			,[Role].[ROLE_ID]
			FROM [dbo].[NAV_FIELDS_MLIAB_ADD] AS [Data]
			CROSS APPLY [dbo].[SYSTEM_ROLE] AS [Role]
			WHERE NOT EXISTS (SELECT
							  *
							  FROM [dbo].[NAV_PERM_MLIAB_ADD] AS [P]
							  WHERE [Data].[NAV_MLIAB_ADD_ID] = [P].[NAV_MLIAB_ADD_ID]))
GO

INSERT INTO [dbo].[NAV_PERM_MLIAB_NEW]
           ([PERM_MLIAB_NEW_ID]
           ,[NAV_MLIAB_NEW_ID]
           ,[ROLE_ID])
           (SELECT
			NEWID() AS [ID]
			,[Data].[NAV_MLIAB_NEW_ID]
			,[Role].[ROLE_ID]
			FROM [dbo].[NAV_FIELDS_MLIAB_NEW] AS [Data]
			CROSS APPLY [dbo].[SYSTEM_ROLE] AS [Role]
			WHERE NOT EXISTS (SELECT
							  *
							  FROM [dbo].[NAV_PERM_MLIAB_NEW] AS [P]
							  WHERE [Data].[NAV_MLIAB_NEW_ID] = [P].[NAV_MLIAB_NEW_ID]))
GO





