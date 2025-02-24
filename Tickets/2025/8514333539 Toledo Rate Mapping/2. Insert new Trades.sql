SELECT * FROM [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] --where levelofindemnity = '£10,000,000'
WHERE [EndDatetime] IS NULL
AND TRADEID IN (
'3N0TV7H9'
,'DAFCFD54'
,'3N0TV8F9'
,'3N0TV9C9'
,'3N0TVAT9'
,'3N0TVBL9'
,'3N0TVBU9'
,'3N0TVC29'
,'3N1MK866'
,'3NVE0AJ9'
,'FE62A481'
,'1EBCA3B0'
,'3N0TVDH9'
,'3N0TVDO9'
,'3N0TVEK9'
,'3N0TVFC9'
,'OFCFITTR'
,'3N0TVHF9'
,'F971C83B'
,'3N0TVK89'
,'426N8U23'
,'25DE6D3A'
)


--Artist
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV7H9',	N'Artist', N'Artist', N'£1,000,000',	34,	63,	 91,  118, 151,	177, 200, 221, 241, 259, 50, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV7H9',	N'Artist', N'Artist', N'£2,000,000',	42,	80,	 116, 150, 193,	224, 255, 281, 306, 329, 50, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV7H9',	N'Artist', N'Artist', N'£5,000,000',	57,	109, 158, 204, 263,	306, 347, 385, 420, 450, 50, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Audio, Visual Installation and Repairs
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('DAFCFD54',	N'Audio, Visual Installation and Repairs', N'Audio, Visual Installation and Repairs', N'£1,000,000',	54,	102, 147, 191, 246,	287, 324, 360, 392, 422, 55, NULL, NULL, 'TISTL063,TISTL039', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('DAFCFD54',	N'Audio, Visual Installation and Repairs', N'Audio, Visual Installation and Repairs', N'£2,000,000',	68,	127, 185, 239, 307,	358, 405, 450, 490, 527, 55, NULL, NULL, 'TISTL063,TISTL039', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('DAFCFD54',	N'Audio, Visual Installation and Repairs', N'Audio, Visual Installation and Repairs', N'£5,000,000',	91,	170, 248, 321, 413,	483, 546, 605, 659, 711, 55, NULL, NULL, 'TISTL063,TISTL039', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Broadband Installer

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV8F9',	N'Broadband Installer', N'Broadband Installer', N'£1,000,000',	51,	96,  140, 182, 234, 273, 308, 342, 373, 400, 58, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV8F9',	N'Broadband Installer', N'Broadband Installer', N'£2,000,000',	62,	116, 170, 220, 282, 330, 373, 412, 451, 485, 58, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV8F9',	N'Broadband Installer', N'Broadband Installer', N'£5,000,000',	73,	136, 199, 257, 331, 386, 436, 484, 525, 566, 58, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Cavity Wall Insulation

UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET EndDatetime = '24 Feb 2025'
WHERE EndDatetime IS NULL AND TradeID = '3N0TV9C9' AND LevelOfIndemnity <> '£10,000,000'

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV9C9',	N'Cavity Wall Insulation', N'Cavity Wall Insulation', N'£1,000,000', 182, 327, 477, 616, 793, 923, 0, 0, 0, 0, 109,  NULL, NULL, 'TISTL034,TISTL032,TISTL020', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV9C9',	N'Cavity Wall Insulation', N'Cavity Wall Insulation', N'£2,000,000', 210, 376, 549, 711, 914, 1062, 0, 0, 0, 0, 109, NULL, NULL, 'TISTL034,TISTL032,TISTL020', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TV9C9',	N'Cavity Wall Insulation', N'Cavity Wall Insulation', N'£5,000,000', 273, 490, 714, 924, 1188, 1382, 0, 0, 0, 0, 109, NULL, NULL, 'TISTL034,TISTL032,TISTL020', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)



--Damp Proofing Contractor


UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET EndDatetime = '24 Feb 2025'
WHERE EndDatetime IS NULL AND TradeID = '3N0TVAT9' AND LevelOfIndemnity <> '£10,000,000'

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVAT9',	N'Damp Proofing Contractor', N'Damp Proofing Contractor', N'£1,000,000', 150, 270, 392, 509, 653, 759, 857, 948, 1031, 1106, 114, NULL, NULL, 'TISTL020,TISTL032,TISTL048', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVAT9',	N'Damp Proofing Contractor', N'Damp Proofing Contractor', N'£2,000,000', 173, 309, 453, 585, 752, 873, 988, 1092, 1188, 1275, 114, NULL, NULL, 'TISTL020,TISTL032,TISTL048', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVAT9',	N'Damp Proofing Contractor', N'Damp Proofing Contractor', N'£5,000,000', 224, 403, 587, 759, 977, 1137, 1284, 1419, 1543, 1656, 114, NULL, NULL, 'TISTL020,TISTL032,TISTL048', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Draft Proofing Installer

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBL9',	N'Draft Proofing Installer', N'Draft Proofing Installer', N'£1,000,000', 55,	104, 152, 196, 253, 295, 333, 370, 403, 433, 70, NULL, NULL, 'TISTL026', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBL9',	N'Draft Proofing Installer', N'Draft Proofing Installer', N'£2,000,000', 68,	130, 189, 245, 316, 368, 417, 462, 503, 542, 70, NULL, NULL, 'TISTL026', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBL9',	N'Draft Proofing Installer', N'Draft Proofing Installer', N'£5,000,000', 78,	147, 215, 278, 358, 417, 472, 523, 569, 612, 70, NULL, NULL, 'TISTL026', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Dry Lining Contractor

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBU9',	N'Dry Lining Contractor', N'Dry Lining Contractor', N'£1,000,000', 46,	86,	123, 159, 204,	237, 270, 299, 326,	350, 49, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBU9',	N'Dry Lining Contractor', N'Dry Lining Contractor', N'£2,000,000', 55,	105, 151, 196, 252,	294, 333, 369, 403,	433, 49, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVBU9',	N'Dry Lining Contractor', N'Dry Lining Contractor', N'£5,000,000', 73,	136, 201, 259, 333,	389, 439, 487, 531,	572, 49, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Electrical Appliance Servicing

UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET EndDatetime = '24 Feb 2025'
WHERE EndDatetime IS NULL AND TradeID = '3N0TVC29' AND LevelOfIndemnity <> '£10,000,000'


INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVC29',	N'Electrical Appliance Servicing', N'Electrical Appliance Servicing', N'£1,000,000', 80.85,	150.15,	216.3, 278.25,	359.1,	420,	475.65,	526.05,	572.25,	616.35,	90,  NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVC29',	N'Electrical Appliance Servicing', N'Electrical Appliance Servicing', N'£2,000,000', 96.6,	 178.5,	262.5, 337.05,	434.7,	504,	572.25,	634.2,	689.85,	744.45,	90, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVC29',	N'Electrical Appliance Servicing', N'Electrical Appliance Servicing', N'£5,000,000', 127.05, 239.4,	346.5, 448.35,	578.55,	674.1,	762.3,	845.25,	920.85,	990.15,	90, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Electrical Engineer

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N1MK866',	N'Electrical Engineer', N'Electrical Engineer', N'£1,000,000', 41,	76,	 110,	143,	184,	214,	243,	269,	292,	315,	51, NULL, NULL, 'TISTL025,TISTL049,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N1MK866',	N'Electrical Engineer', N'Electrical Engineer', N'£2,000,000', 51,	94,	 136,	177,	227,	265,	300,	332,	362,	389,	51, NULL, NULL, 'TISTL025,TISTL049,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N1MK866',	N'Electrical Engineer', N'Electrical Engineer', N'£5,000,000', 66,	123, 180,	232,	300,	350,	395,	437,	477,	514,	51, NULL, NULL, 'TISTL025,TISTL049,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Engineers - General Machinery / Machine Tool Repair ex heat

UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET EndDatetime = '24 Feb 2025'
WHERE EndDatetime IS NULL AND TradeID = '3NVE0AJ9' AND LevelOfIndemnity <> '£10,000,000'


INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3NVE0AJ9',	N'Engineers - General Machinery / Machine Tool Repair ex heat', N'Engineers - General Machinery / Machine Tool Repair ex heat', N'£1,000,000', 182, 327,	477,	616,	793,	923,	1043,	1152,	1254,	1345,	182, NULL, NULL, 'TISTL069,TISTL032', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3NVE0AJ9',	N'Engineers - General Machinery / Machine Tool Repair ex heat', N'Engineers - General Machinery / Machine Tool Repair ex heat', N'£2,000,000', 210, 376,	549,	711,	914,	1062,	1202,	1328,	1445,	1549,	182, NULL, NULL, 'TISTL069,TISTL032', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3NVE0AJ9',	N'Engineers - General Machinery / Machine Tool Repair ex heat', N'Engineers - General Machinery / Machine Tool Repair ex heat', N'£5,000,000', 273, 490,	714,	924,	1188,	1382,	1562,	1726,	1878,	2014,	182, NULL, NULL, 'TISTL069,TISTL032', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Fabricator


UPDATE[Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] SET EndDatetime = '24 Feb 2025'
WHERE EndDatetime IS NULL AND TradeID = 'FE62A481' AND LevelOfIndemnity <> '£10,000,000'

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('FE62A481',	N'Fabricator', N'Fabricator', N'£1,000,000', 350,	700,	1050,	1400,	1750,	2100,	2450,	2800,	3150,	3500,	200, NULL, NULL, 'TISTL049,TISTL062', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('FE62A481',	N'Fabricator', N'Fabricator', N'£2,000,000', 415,	830,	1245,	1660,	2075,	2490,	2905,	3320,	3735,	4150,	200, NULL, NULL, 'TISTL049,TISTL062', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('FE62A481',	N'Fabricator', N'Fabricator', N'£5,000,000', 540,	1080,	1620,	2160,	2700,	3240,	3780,	4320,	4860,	5400,	200, NULL, NULL, 'TISTL049,TISTL062', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Fence Erecting

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('1EBCA3B0',	N'Fence Erecting', N'Fence Erecting', N'£1,000,000', 52,	99,	143, 187, 241, 280,	316, 350, 381, 410,	65, NULL, NULL, 'TISTL027', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('1EBCA3B0',	N'Fence Erecting', N'Fence Erecting', N'£2,000,000', 62,	116, 170, 220, 282,	330, 373, 412, 451,	485, 65, NULL, NULL, 'TISTL027', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('1EBCA3B0',	N'Fence Erecting', N'Fence Erecting', N'£5,000,000', 75,	143, 207, 269, 345,	402, 455, 504, 550,	589, 65, NULL, NULL, 'TISTL027', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Furniture Assembly and Repair


INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDH9',	N'Furniture Assembly and Repair', N'Furniture Assembly and Repair', N'£1,000,000', 57,	109,	158,	205,	264,	309,	348,	388,	421,	454,	73, NULL, NULL, 'TISTL024,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDH9',	N'Furniture Assembly and Repair', N'Furniture Assembly and Repair', N'£2,000,000', 71,  134,	195,	252,	325,	378,	429,	475,	518,	557,	73, NULL, NULL, 'TISTL024,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDH9',	N'Furniture Assembly and Repair', N'Furniture Assembly and Repair', N'£5,000,000', 98,	185,	269,	348,	450,	523,	593,	657,	716,	771,	73, NULL, NULL, 'TISTL024,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Gas Fitter

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDO9',	N'Gas Fitter', N'Gas Fitter', N'£1,000,000', 203,	386,	569,	751,	934,	1117,	1300,	1483,	1665,	1848,	83, NULL, NULL, 'TISTL073,TISTL051', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDO9',	N'Gas Fitter', N'Gas Fitter', N'£2,000,000', 284,	540,	796,	1052,	1308,	1564,	1820,	2076,	2332,	2587,	83, NULL, NULL, 'TISTL073,TISTL051', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVDO9',	N'Gas Fitter', N'Gas Fitter', N'£5,000,000', 398,	756,	1115,	1473,	1831,	2189,	2548,	2906,	3264,	3622,	83, NULL, NULL, 'TISTL073,TISTL051', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)



--Harling and Roughcasting

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVEK9',	N'Harling and Roughcasting', N'Harling and Roughcasting', N'£1,000,000', 52,	98,	 144, 185, 238,	277, 315, 349, 379,	408, 67, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVEK9',	N'Harling and Roughcasting', N'Harling and Roughcasting', N'£2,000,000', 64,	121, 177, 230, 295,	344, 389, 432, 471,	506, 67, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVEK9',	N'Harling and Roughcasting', N'Harling and Roughcasting', N'£5,000,000', 84,	160, 233, 302, 389,	454, 514, 570, 621,	668, 67, NULL, NULL, 'TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Joiners

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVFC9',	N'Joiners', N'Joiners', N'£1,000,000', 47,	87,	124, 160, 206, 238,	271, 301, 327, 350,	60, NULL, NULL, 'TISTL074,TISTL028,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVFC9',	N'Joiners', N'Joiners', N'£2,000,000', 55,	105, 151, 196, 252, 294, 333, 369, 403, 433, 60, NULL, NULL, 'TISTL074,TISTL028,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVFC9',	N'Joiners', N'Joiners', N'£5,000,000', 73,	136, 201, 259, 333, 389, 439, 487, 531, 572, 60, NULL, NULL, 'TISTL074,TISTL028,TISTL034', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Office Fitter

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('OFCFITTR',	N'Office Fitter', N'Office Fitter', N'£1,000,000', 64,	 121, 176, 228,	293, 342, 387, 428,	467, 503, 74, NULL, NULL, 'TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('OFCFITTR',	N'Office Fitter', N'Office Fitter', N'£2,000,000', 76,	 143, 208, 270,	347, 405, 459, 507,	555, 596, 74, NULL, NULL, 'TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('OFCFITTR',	N'Office Fitter', N'Office Fitter', N'£5,000,000', 104, 196, 286, 370,	477, 556, 629, 697,	759, 817, 74, NULL, NULL, 'TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Photographers

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVHF9',	N'Photographers', N'Photographers', N'£1,000,000', 33,	62,	 90,  116,	150, 173, 196, 218,	237, 256, 42, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVHF9',	N'Photographers', N'Photographers', N'£2,000,000', 41,	76,	 109, 140,	181, 211, 238, 264,	288, 310, 42, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVHF9',	N'Photographers', N'Photographers', N'£5,000,000', 56,	106, 153, 200,	256, 299, 338, 374,	408, 439, 42, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)

--Signwriting

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('F971C83B',	N'Signwriting', N'Signwriting', N'£1,000,000', 74,	 138, 202, 261,	336,	391,	443,	491,	535,	574,	81, NULL, NULL, 'TISTL032,TISTL056,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('F971C83B',	N'Signwriting', N'Signwriting', N'£2,000,000', 84,	 159, 231, 303,	410,	503,	594,	687,	779,	872,	81, NULL, NULL, 'TISTL032,TISTL056,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('F971C83B',	N'Signwriting', N'Signwriting', N'£5,000,000', 105, 199, 290, 375,	483,	562,	637,	707,	770,	827,	81, NULL, NULL, 'TISTL032,TISTL056,TISTL074', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Telephone System (Including wireless signalling installations) & Data Cabling Installers


INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVK89',	N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'£1,000,000', 41,	82,	 123, 164, 205,	246, 287, 328, 369,	410, 51, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVK89',	N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'£2,000,000', 66,	132, 198, 264, 330,	396, 462, 528, 594,	660, 51, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('3N0TVK89',	N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'Telephone System (Including wireless signalling installations) & Data Cabling Installers', N'£5,000,000', 74,	148, 222, 296, 370,	444, 518, 592, 666,	740, 51, NULL, NULL, 'TISTL025', 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, NULL, NULL, NULL, GETDATE(), NULL, 'LINGA', NULL, NULL)


--Vehicle Mechanic Including Welding and Fabrication

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('426N8U23',	N'Vehicle Mechanic Including Welding and Fabrication', N'Vehicle Mechanic Including Welding and Fabrication', N'£1,000,000', 350,	700,	1050,	1400,	1750,	2100,	2450,	2800,	3150,	3500,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('426N8U23',	N'Vehicle Mechanic Including Welding and Fabrication', N'Vehicle Mechanic Including Welding and Fabrication', N'£2,000,000', 415,	830,	1245,	1660,	2075,	2490,	2905,	3320,	3735,	4150,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('426N8U23',	N'Vehicle Mechanic Including Welding and Fabrication', N'Vehicle Mechanic Including Welding and Fabrication', N'£5,000,000', 540,	1080,	1620,	2160,	2700,	3240,	3780,	4320,	4860,	5400,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)


--Welder

INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('25DE6D3A',	N'Welder', N'Welder', N'£1,000,000', 350,	700,	1050,	1400,	1750,	2100,	2450,	2800,	3150,	3500,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('25DE6D3A',	N'Welder', N'Welder', N'£2,000,000', 415,	830,	1245,	1660,	2075,	2490,	2905,	3320,	3735,	4150,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)
INSERT INTO [Calculators].[dbo].[MLIAB_Toledo_TradesmanLiability_TradePLEL] VALUES ('25DE6D3A',	N'Welder', N'Welder', N'£5,000,000', 540,	1080,	1620,	2160,	2700,	3240,	3780,	4320,	4860,	5400,	200, NULL, NULL, NULL, 0, 0, 0, 0, 0, 0, 3, 0, 0, 15, 0, 0, 0, 0, 1, NULL, NULL, GETDATE(), NULL, 'LINGA', 1, 1)

























