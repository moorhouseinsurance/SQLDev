select *  FROM [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
  where [EndDatetime] is null
  and [TradeID] = '3N0TVFI9'
  and [TradeDescriptionInsurer] = 'Landscape Gardener (inc Work on Paving Paths Drives & Patios)'


UPDATE [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL] SET [EndDatetime] = GETDATE()
WHERE [EndDatetime] IS NULL AND [TradeID] = '3N0TVFI9'
AND [TradeDescriptionInsurer] = 'Landscape Gardener (inc Work on Paving Paths Drives & Patios)';

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES ('Landscape Gardener (inc Work on Paving Paths Drives & Patios)', N'3N0TVFI9', N'£1,000,000', 74.36,  138.24, 200.03, 261.82, 336.18, 390.63, 443.00, 490.13, 535.16, 576.00, 62.84, 100,NULL, 'MMALIA01', 0, 0, 0, 0, 0, 0,3, 0, 0, 0, 1, 1, NULL, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES ('Landscape Gardener (inc Work on Paving Paths Drives & Patios)', N'3N0TVFI9', N'£2,000,000', 90.06,	 167.56, 241.92, 313.13, 404.25, 470.23, 533.06, 590.67, 640.93, 693.30, 62.84,	100,NULL, 'MMALIA01', 0, 0, 0, 0, 0, 0,3, 0, 0, 0, 1, 1, NULL, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES ('Landscape Gardener (inc Work on Paving Paths Drives & Patios)', N'3N0TVFI9', N'£5,000,000', 125.67, 237.73, 344.55, 446.14, 572.86, 669.21, 759.28, 840.96, 916.38, 985.49, 62.84,	100,NULL, 'MMALIA01', 0, 0, 0, 0, 0, 0,3, 0, 0, 0, 1, 1, NULL, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 1)

INSERT INTO [Calculators].[dbo].[MLIAB_Covea_TradesmanLiability_TradePLEL]
VALUES ('Landscape Gardener (inc Work on Paving Paths Drives & Patios)', N'3N0TVFI9', N'£10,000,000', 1.00,	 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 100,NULL, 'MMALIA01', 0, 0, 0, 0, 0, 0,3, 0, 0, 0, 1, 1, 1, 30, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 0)

