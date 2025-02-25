--Property Maintenance and Repair

select * FROM [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE tradeID = '3N0TVI29'
AND [EndDateTime] IS NULL;

UPDATE [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDateTime] = '25 Feb 2025'
WHERE TradeID = '3N0TVI29' AND [EndDateTime] IS NULL;

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI29',	N'Property Maintenance and Repair', N'Property Maintenance and Repair', N'£1,000,000', 41,	 77,	224,	291,	375,	436,	495,	547,	596,	641,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI29',	N'Property Maintenance and Repair', N'Property Maintenance and Repair', N'£2,000,000', 52,	 98,	285,	370,	476,	555,	628,	695,	756,	814,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI29',	N'Property Maintenance and Repair', N'Property Maintenance and Repair', N'£5,000,000', 75,	140,	411,	532,	684,	797,	904,	1000,	1090,	1172,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


-- Property Maintenance (Ex Hazardous Activities)

select * FROM [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE tradeID = '3N0TVI19'
AND [EndDateTime] IS NULL;

UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDateTime] = '25 Feb 2025'
WHERE TradeID = '3N0TVI19' AND [EndDateTime] IS NULL AND LevelOfIndemnity <> '£10,000,000';

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI19',	N'Property Maintenance (Ex Hazardous Activities)', N'Property Maintenance (Ex Hazardous Activities)', N'£1,000,000', 41,	 77,	224,	291,	375,	436,	495,	547,	596,	641,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI19',	N'Property Maintenance (Ex Hazardous Activities)', N'Property Maintenance (Ex Hazardous Activities)', N'£2,000,000', 52,	 98,	285,	370,	476,	555,	628,	695,	756,	814,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVI19',	N'Property Maintenance (Ex Hazardous Activities)', N'Property Maintenance (Ex Hazardous Activities)', N'£5,000,000', 75,	140,	411,	532,	684,	797,	904,	1000,	1090,	1172,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


-- Ground Workers

SELECT * FROM [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE TradeID = '3N0TVE89'
AND [EndDateTime] is null

UPDATE [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDateTime] = '25 Feb 2025'
WHERE TradeID = '3N0TVE89' AND[EndDateTime] IS NULL AND TradeDescriptionInsurer <> 'Groundworker - 8 metres';

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworkers', N'Groundworker', N'£1,000,000', 106,	200,	291,	378,	487,	568,	642,	712	, 777,	 835,	133, NULL, NULL, 'TISTL016,TISTL043,TISTL066', 0, 0, 0, 0, 0, 0, 2, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworkers', N'Groundworker', N'£2,000,000', 128,	239,	349,	451,	580,	677,	767,	849	, 927,	 996,	133, NULL, NULL, 'TISTL016,TISTL043,TISTL066', 0, 0, 0, 0, 0, 0, 2, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworkers', N'Groundworker', N'£5,000,000', 152,	285,	417,	540,	694,	809,	915,	1014, 1105,	1190,	133, NULL, NULL, 'TISTL016,TISTL043,TISTL066', 0, 0, 0, 0, 0, 0, 2, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


-- Ground Workers - 3 METRE

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 3 metre', N'Groundworker', N'£1,000,000', 131,	236,	690,	 893,	1149,	1337,	1511,	1670,	1817,	1949,	119, NULL, NULL, 'TISTL017,TISTL043,TISTL066', 0, 0, 0, 0, 0, 3, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 3 metre', N'Groundworker', N'£2,000,000', 152,	272,	795,	1029,	1325,	1539,	1742,	1925,	2094,	2244,	119, NULL, NULL, 'TISTL017,TISTL043,TISTL066', 0, 0, 0, 0, 0, 3, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 3 metre', N'Groundworker', N'£5,000,000', 197,	355,	1034,	1338,	1721,	2003,	2264,	2501,	2721,	2918,	119, NULL, NULL, 'TISTL017,TISTL043,TISTL066', 0, 0, 0, 0, 0, 3, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


-- Ground Workers - 5 METRE

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 5 metre', N'Groundworker', N'£1,000,000', 315,	567,	828,	1071,	1380,	1603.5,	1813.5,	2004,	2181,	2338.5,	262.5, NULL, NULL, 'TISTL018,TISTL043,TISTL066', 0, 0, 0, 0, 0, 4, 5, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 5 metre', N'Groundworker', N'£2,000,000', 363,	654,	954,	1234.5,	1588.5,	1848,	2089.5,	2308.5,	2511,	2694,	262.5, NULL, NULL, 'TISTL018,TISTL043,TISTL066', 0, 0, 0, 0, 0, 4, 5, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVE89',	N'Groundworker - 5 metre', N'Groundworker', N'£5,000,000', 472.5,	850.5,	1240.5,	1605,	2064,	2401.5,	2715,	3001.5,	3264,	3502.5,	262.5, NULL, NULL, 'TISTL018,TISTL043,TISTL066', 0, 0, 0, 0, 0, 4, 5, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

-- Handyman

SELECT * FROM [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE TradeID = '8740638A'
AND [EndDateTime] is null

UPDATE [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDateTime] = '25 Feb 2025'
WHERE TradeID = '8740638A' AND[EndDateTime] IS NULL;


INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('8740638A',	N'Handyman', N'Handyman', N'£1,000,000', 41,	 77,	224,	291,	375,	436,	495,	547,	596,	641,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('8740638A',	N'Handyman', N'Handyman', N'£2,000,000', 52,	 98,	285,	370,	476,	555,	628,	695,	756,	814,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('8740638A',	N'Handyman', N'Handyman', N'£5,000,000', 75,	140,	411,	532,	684,	797,	904,	1000,	1090,	1172,	66, NULL, NULL, 'TISTL074,TISTL073,TISTL051,TISTL015,TISTL066,TISTL047', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

