USE [Calculators]
GO


-- Increase UserID field length from 3 to match other tables:

ALTER TABLE [Calculators].[dbo].[MLIAB_Covea_CAR_Rates]
ALTER COLUMN [UserID] varchar(10)