USE [Calculators]
GO

SELECT * FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] AS [T]
WHERE [TradeID] = '3N0TV8G9'
AND [TradeDescriptionInsurer] = 'Builder'
AND [EndDateTime] IS NULL



UPDATE [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] SET [EndDateTime] = GETDATE()
WHERE [TradeID] = '3N0TV8G9'
AND [TradeDescriptionInsurer] = 'Builder'
AND [EndDateTime] IS NULL


INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES (N'Builder',N'3N0TV8G9',N'£1,000,000',107.65, 202.57, 292.85, 377.35, 487.31, 568.34, 642.43, 711.88, 776.69, 832.26, 154.00, 100, NULL, 'MMALIA01', 0,	0,	0,	0,	0,	0,	3,  0,	16,	17,	0,	0, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES (N'Builder',N'3N0TV8G9',N'£2,000,000',130.80, 244.23, 357.68, 464.16, 598.44, 694.51, 785.96, 873.93, 950.32, 1020.94, 154.00, 100, NULL, 'MMALIA01', 0,	0,	0,	0,	0,	0,	3,  0,	16,	17,	0,	0,  NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES (N'Builder',N'3N0TV8G9',N'£5,000,000', 195.62, 370.41, 539.41, 699.14, 900.55, 1048.72, 1185.30,	1314.94, 1433.01, 1544.13, 154.00, 100, NULL, 'MMALIA01', 0,	0,	0,	0,	0,	0,	3, 0,	16,	17,	0,	0,  NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES (N'Builder',N'3N0TV8G9',N'£10,000,000', 1.00,	1.00,	1.00,	1.00,	1.00,	1.00,	1.00,	1.00,	1.00,	1.00,	1.00, 100, NULL, 'MMALIA01', 0,	0,	0,	0,	0,	0,	3,  0,	16,	17,	0,	0,  1,  NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 0)

