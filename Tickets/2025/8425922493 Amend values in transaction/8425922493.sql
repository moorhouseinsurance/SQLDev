
--SELECT * FROM [Transactor_Live].[dbo].[CUSTOMER_POLICY_DETAILS] WHERE POLICYNUMBER = 'MMATL1084553'

--SELECT * FROM [Transactor_Live].[dbo].[ACCOUNTS_TRANSACTION] WHERE REFERENCE = 'TLI01878282'


--SELECT * FROM [Transactor_Live].[dbo].[ACCOUNTS_CLIENT_TRAN_LINK] WHERE POLICY_DETAILS_ID = '88F7A2E8F14F43D599CAD72565C7598C'

--SELECT * FROM [Transactor_Live].[dbo].[ACCOUNTS_TRAN_BREAKDOWN] WHERE TRANSACTION_ID =  '5D7103EBDCD34DCEBFE6486524DB9E93'


--SELECT
--	 SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('NET') THEN [ATB].[AMOUNT] END) AS GWP
--	,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('TAX_IPT') THEN [ATB].[AMOUNT] END) AS IPT
--	,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('BRKCOMMF','BRKCOMMP') THEN [ATB].[AMOUNT] END) AS [Brokerage]
--	,SUM(CASE WHEN [ATB].[TRAN_BREAKDOWN_TYPE_ID] IN ('FEE') THEN [ATB].[AMOUNT] END) AS [Fee]
--FROM
--	[dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB]
--WHERE [ATB].[TRANSACTION_ID] = '5D7103EBDCD34DCEBFE6486524DB9E93'



INSERT INTO [Transactor_Live].[dbo].[ACCOUNTS_TRAN_BREAKDOWN] VALUES ('007D230B7B554987A961AEA740D7B019', '5D7103EBDCD34DCEBFE6486524DB9E93', 299.31, 'BRKCOMMP', '74', 1, 'BDEA60DCBB514EA4B7149E9257A07991', '6', 'LIABPREM', '8126270EE367492CAD9BD753A2F540CC', NULL, NULL, 0)
