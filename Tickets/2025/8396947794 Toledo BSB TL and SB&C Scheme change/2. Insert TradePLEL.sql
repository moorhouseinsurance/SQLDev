--SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = '3SMJ6T96';

--SELECT * FROM [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = '3SMJ6T96';

--===Cladding Contractor

--SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = 'D20DDE3B';

UPDATE [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDatetime] = GETDATE()
WHERE EndDateTime is NULL AND TradeID = 'D20DDE3B';

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('D20DDE3B', N'Cladding Contractors',N'Cladding Contractor',N'£1,000,000', 253.00, 456.00, 665.00, 859.00, 1106.00, 1286.00, 0, 0, 0, 0, 130.00,  NULL, NULL, 'TISTL011,TISTL034,TISTL020,TISTL032,TISTL083,TISTL084', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('D20DDE3B', N'Cladding Contractors',N'Cladding Contractor',N'£2,000,000', 294.00, 527.00, 766.00, 992.00, 1274.00, 1483.00, 0, 0, 0, 0, 130.00,  NULL, NULL, 'TISTL011,TISTL034,TISTL020,TISTL032,TISTL083,TISTL084', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('D20DDE3B', N'Cladding Contractors',N'Cladding Contractor',N'£5,000,000', 383.00, 684.00, 997.00, 1288.00, 1654.00, 1926.00, 0, 0, 0, 0, 130.00,  NULL, NULL, 'TISTL011,TISTL034,TISTL020,TISTL032,TISTL083,TISTL084', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);



--====Engineer - Sprinkler

--SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = '3NVE0F70';

UPDATE [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDatetime] = GETDATE()
WHERE EndDateTime is NULL AND TradeID = '3NVE0F70';

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3NVE0F70', N'Engineer - Sprinkler',N'Engineers - sprinkler',N'£1,000,000', 160.00, 304.00, 448.00, 592.00, 736.00, 880.00, 1024.00, 1168.00, 1312.00, 1456.00, 83.00,  NULL, NULL, 'TISTL034,TISTL020,TISTL049,TISTL032', 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3NVE0F70', N'Engineer - Sprinkler',N'Engineers - sprinkler',N'£2,000,000', 184.00, 350.00, 515.00, 681.00, 846.00, 1012.00, 1178.00, 1343.00, 1509.00, 1674.00, 83.00,  NULL, NULL, 'TISTL034,TISTL020,TISTL049,TISTL032', 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3NVE0F70', N'Engineer - Sprinkler',N'Engineers - sprinkler',N'£5,000,000', 230.00, 437.00, 644.00, 670.00, 877.00, 1084.00, 1291.00, 1498.00, 1705.00, 1912.00, 83.00,  NULL, NULL, 'TISTL034,TISTL020,TISTL049,TISTL032', 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME), NULL, 'LINGA', NULL, NULL);


--====Welder & Mechanics 
--SELECT * FROM [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = '3N1MK8H4';

UPDATE [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET [EndDatetime] = GETDATE()
WHERE EndDateTime is NULL AND TradeID = '3N1MK8H4';

INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3N1MK8H4', N'Welder & Mechanics', N'Welder & Mechanics', N'£1,000,000',	350.00,	700.00,	1050.00, 1400.00, 1750.00, 2100.00,	2450.00, 2800.00, 3150.00, 3500.00, 200.00,	NULL, NULL,	NULL, 0, 0, 0, 0, 0, 0,	3, 0, 0, 15, 0,	0, 0, 0, 1, NULL,	NULL,	CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL,	'LINGA',	1,	1)
INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3N1MK8H4', N'Welder & Mechanics', N'Welder & Mechanics', N'£2,000,000',	415.00,	830.00,	1245.00, 1660.00, 2075.00, 2490.00,	2905.00, 3320.00, 3735.00, 4150.00,	200.00,	NULL, NULL,	NULL, 0, 0,	0, 0, 0, 0,	3, 0, 0, 15, 0,	0, 0, 0, 1, NULL,	NULL,	CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL,	'LINGA',	1,	1)
INSERT INTO  [dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] 
VALUES ('3N1MK8H4', N'Welder & Mechanics', N'Welder & Mechanics', N'£5,000,000',	540.00,	1080.00,1620.00, 2160.00, 2700.00, 3240.00,	3780.00, 4320.00, 4860.00, 5400.00,	200.00,	NULL, NULL,	NULL, 0, 0,	0, 0, 0, 0,	3, 0, 0, 15, 0,	0, 0, 0, 1, NULL,	NULL,	CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL,	'LINGA',	1,	1)





--=========================================

--SELECT * FROM RM_PRODUCT WHERE PRODUCTTYPE_ID = 196
--Market Trader

--SELECT * FROM [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] WHERE EndDateTime is NULL AND TradeID = '3SMJ6T96';

UPDATE [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] SET [EndDatetime] = GETDATE()
WHERE EndDateTime is NULL AND TradeID = '3SMJ6T96';


INSERT INTO  [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] 
VALUES ('3SMJ6T96', N'Market Trader', N'Market Trader', N'£1,000,000',	48.21,	91.599,	134.988, 178.377, 221.766, 265.155,	308.544, 351.933, 395.322, 438.711, 42.00,	NULL, NULL,	'TISSB008,TISSB063,TISSB081,TISSB082', NULL, 0, NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL, GETDATE(), 'LINGA')
INSERT INTO  [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] 
VALUES ('3SMJ6T96', N'Market Trader', N'Market Trader', N'£2,000,000',	54.00,	102.60,	151.20, 199.80,    248.40,  297.00,  345.60,  394.20,  442.80, 491.40,	42.00,	NULL, NULL,	'TISSB008,TISSB063,TISSB081,TISSB082', NULL, 0,	NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL, GETDATE(), 'LINGA')
INSERT INTO  [dbo].[MCLIAB_Toledo_SmallBusinessAndConsultantsLiability_TradePLEL] 
VALUES ('3SMJ6T96', N'Market Trader', N'Market Trader', N'£5,000,000',	55.00,	103.60, 152.20, 200.80,    249.40,  298.00,	 346.60,  395.20,  443.80, 492.40,	42.00,	NULL, NULL,	'TISSB008,TISSB063,TISSB081,TISSB082', NULL, 0,	NULL, NULL, CAST(CAST(GETDATE() AS DATE) AS DATETIME),	NULL, GETDATE(), 'LINGA')


