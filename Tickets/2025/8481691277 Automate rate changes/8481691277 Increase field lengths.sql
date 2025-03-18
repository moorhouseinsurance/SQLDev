USE [Calculators]
GO

ALTER TABLE [dbo].[MLIAB_Covea_CAR_Rates] ALTER COLUMN [UserID] varchar(30);

ALTER TABLE [dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate] ALTER COLUMN [InsertUserID] varchar(30);

ALTER TABLE [dbo].[MLIAB_Covea_ProfessionalIndemnity_Rate] ALTER COLUMN [UpdateUserID] varchar(30);

ALTER TABLE [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates] ALTER COLUMN [InsertUserID] varchar(30);

ALTER TABLE [dbo].[MLIAB_Covea_PersonalAccidentAndIncomeProtection_Rates] ALTER COLUMN [UpdateUserID] varchar(30);