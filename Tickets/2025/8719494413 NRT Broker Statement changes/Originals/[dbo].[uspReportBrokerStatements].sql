USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspReportBrokerStatements]    Script Date: 18/03/2025 09:06:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Jeremai Smith
-- Create date: 26 Jul 2024
-- Description:	Broker Statements SSRS report procedure based on SP_REP_CF01_SUBAGENTSTATEMENT and SP_ACC_SUBAGENTREC_GETDATA, with performance improvements
-- =============================================

-- Date			Who						Change
-- 28/11/2024	Jeremai Smith			Final select statement changed to exclude NRT schemes (could probably do this earlier on but there are so many other procedures and
--										functions called), change calculation of premium and number of days columns, and include new fee column (ticket 7744941214)


ALTER PROCEDURE [dbo].[uspReportBrokerStatements]
	 @StartDate datetime
	,@EndDate datetime
	,@AgentID char(32)
	,@SubAgentID varchar(MAX)

AS

/*
DECLARE @StartDate datetime = '01 Jan 2022'
DECLARE @EndDate datetime = '29 Feb 2024'
DECLARE @AgentID char(32) -- NULL input will run for all agents (that have SubAgents, i.e. currently XBroker and Blink); takes about 16s
DECLARE @SubAgentID varchar(MAX) -- NULL input will run for all subagents
--DECLARE @SubAgentID varchar(MAX) = '07CE6701B66B42839BD59275A32C9C5F' -- A Y S Financial Services
--DECLARE @SubAgentID varchar(MAX) = '60A5C313D1E44FA2BAF08885D9A75A37' -- XB1484 Academy Commercial Insurance
--DECLARE @SubAgentID varchar(MAX) = '07CE6701B66B42839BD59275A32C9C5F,60A5C313D1E44FA2BAF08885D9A75A37' -- A Y S Financial Services & XB1484 Academy Commercial Insurance

EXEC [dbo].[uspReportBrokerStatements] @StartDate, @EndDate, @AgentID, @SubAgentID

-- For debugging:
--IF (SELECT OBJECT_ID(N'tempdb..@UpdatePremiums')) IS NOT NULL DROP TABLE  @UpdatePremiums
--IF (SELECT OBJECT_ID(N'tempdb..@TransactionIDS')) IS NOT NULL DROP TABLE  @TransactionIDS
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

IF CONVERT(VARCHAR(12), @EndDate, 114) = '00:00:00:000'
	SET @EndDate = DATEADD(DAY, 1, @EndDate);

IF @SubAgentID LIKE '%ALLBALANCES%' SET @SubAgentID = NULL; -- RDL doesn't allow a parameter to be set to NULL if it allows multiple values so NULL it here as the standard TGSL procedures and functions below need it to be NULL to return all SubAgents with a balance


-- =======================
-- Declare table variables
-- =======================

DECLARE @Transactions TABLE ( -- Originally part of FN_Acc_GetPaymentsBySubAgent TVF; now combined with this script
	[Transaction_ID] char(32)
);


DECLARE @SubAgentRec TABLE (
	 [Transaction_ID] char(32) NOT NULL
	,[PolicyHolder] varchar(255) NULL
	,[PolicyNumber] varchar(50) NOT NULL
	,[CreatedDate] datetime NOT NULL
	,[PaymentDate] datetime NOT NULL
	,[Transaction_Code_ID] char(8) NOT NULL
	,[Gross] money NOT NULL
	,[Premium] money NOT NULL
	,[IPT] money NOT NULL
	,[Commission] money NOT NULL
	,[Ticked] bit NOT NULL
	,[Query] bit NOT NULL
	,[Query_Reason_ID] varchar(8) NOT NULL
	,[AwaitingReconciliation] bit NOT NULL
	,[Adjustment] money NOT NULL
	,[Outstanding] money NOT NULL
	,[Pay_Adjust_Type_ID] varchar(8) NOT NULL
	,[Due] money NOT NULL
	,[Agent_ID] char(32) NULL
	,[PortfolioKey] int NOT NULL
	,[SchemeTable_ID] int NULL
	,[ProductType_ID] int NULL
	,[SubAgent_ID] char(32) NOT NULL
	,[PayNetOfCommission] bit NOT NULL
	,[ClientOutstanding] money
	,[ClientSettled] bit NOT NULL
	,[Payment_Type_ID] char(8) NULL
	,[ClientPayment] int NULL
	,[FeeIPT] money NULL
);


DECLARE @UpdatePremiums TABLE (	
	 [Transaction_ID] char(32)
	,[TotalPayable] money
	,[NetPremium] money
	,[IPT] money
	,[Fee] money
	,[TotalCommission] money
	,[TotalDiscount] money
	,[BrokerCommission] money
	,[BrokerDiscount] money
	,[AgentCommission] money
	,[AgentDiscount] money
	,[SubAgentCommission] money
	,[SubAgentDiscount] money
	,[OriginalTransactionType] varchar(8) null
);


DECLARE @TransactionIDS TABLE (	
	 [Transaction_ID] char(32)
	,[Transaction_Code_ID] VARCHAR(8)
	,[PaymentDate] datetime
);


DECLARE @RecData TABLE (
	 [insertnum] int
	,[Transaction_ID] char(32) NULL
	,[ClientName] Varchar(255) NULL 
	,[PolicyNumber] Varchar(255) NULL
	,[CreatedDate] Datetime NULL
	,[PaymentDate] Datetime NULL
	,[Transaction_Code_ID] varchar(8) NULL
	,[Gross] Money NULL
	,[Premium] Money NULL
	,[IPT] Money NULL
	,[Commission] Money NULL
	,[Ticked] Bit NULL
	,[Query] Bit NULL
	,[Query_Reason_ID] varchar(8) NULL
	,[AwaitingReconciliation] bit NULL
	,[Adjustment] Money NULL
	,[Pay_Adjust_Type_ID] Varchar(8) NULL
	,[Outstanding] money NULL
	,[Due] Money NULL
	,[Agent_ID] Char(32) NULL
	,[PortfolioKey] int NULL
	,[SchemeTable_ID] int NULL
	,[ProductType] int NULL
	,[SubAgent_ID] Char(32) NULL
	,[PayNetOfCommission] bit NULL
	,[ClientOutstanding] Money NULL
	,[ClientSettled] bit NULL
	,[Payment_Type_ID] varchar(8) NULL
	,[ClientPayment] bit NULL
	,[Allocated] money NULL
	,[SubAgentAllocated] money NULL
	,[FeeIPT] money NULL
);


DECLARE @SubAgentList TABLE (
	[Transaction_ID] char(32) NOT NULL
);


DECLARE @NoSubAgentList TABLE (
	[Transaction_ID] char(32) NOT NULL
);


DECLARE @Premiums TABLE (
	 [Transaction_ID] char(32) NOT NULL
	,[NetPremium] money NULL
	,[TotalPayable] money NULL
	,[IPT] money NULL
);


DECLARE @Account_Premiums Table
(
	 [Transaction_Id] VarChar (32)
	,[Premium] Money
	,[IPT] Money
	,[Fee] Money
);


DECLARE @IPDALLOCATIONS TABLE
(
	 [Breakdown_Allocation_ID] char(32)
	,[Tran_Breakdown_ID] char(32)
	,[Tran_Link_ID] char(32)
	,[Allocated] money
);


-- ==========================================
-- Begin code from SP_ACC_SUBAGENTREC_GETDATA
-- ==========================================

DECLARE @ProductType int = NULL -- To run for an individaul product (would need to make this an input parameter on the report to use) 
DECLARE @SchemeTable_ID int = NULL -- To run for an individaul scheme (would need to make this an input parameter on the report to use) 
DECLARE @PaymentDate datetime
DECLARE @Transaction_Batch_ID char(32) = Replace(NEWID(), '-', '')
DECLARE @Transaction_ID varchar(32)
DECLARE @Transaction_Code_ID varchar(8)
DECLARE @IPDTransaction_ID char(32)
DECLARE @IPDLink_ID char(32)
;


-- Get a list of transactions that are set to payment by subagent (originally called FN_Acc_GetPaymentsBySubAgent TVF but code now combined with this script):

INSERT INTO @Transactions (
	[Transaction_ID]
)
SELECT 
	[AT].[TRANSACTION_ID]
FROM 
	[dbo].[ACCOUNTS_TRANSACTION] AS [AT]
	INNER JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [ACTL].[TRANSACTION_ID] = [AT].[TRANSACTION_ID]
	INNER JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [CPD].[POLICY_DETAILS_ID] = [ACTL].[POLICY_DETAILS_ID] AND [CPD].[HISTORY_ID] = [ACTL].[POLICY_DETAILS_HISTORY_ID]
WHERE 
	[ACCOUNT_TYPE_ID] = 'CLIENT'
	AND [AT].[PAYMETHOD_ID] = '3ERGLT19' -- Payment By Sub Agent
	AND ((ISNULL([dbo].[GetSubAgentParameter]([CPD].[SUBAGENT_ID], 'StatementSort'), '') <> '3H5TGAW0' -- Not Effective Date
		  AND [AT].[CREATEDDATE] BETWEEN @StartDate AND @Enddate
		  )
		  OR
		 ([dbo].[GetSubAgentParameter]([CPD].[SUBAGENT_ID], 'StatementSort') = '3H5TGAW0' -- Effective DAte
		  AND [AT].[PAYMENTDATE] BETWEEN @StartDate AND @Enddate
		  )
		 )
;

	
INSERT INTO 
	[dbo].[ACCOUNTS_TRANSACTION_BATCH] -- Used for passing list of Transaction IDs to other procedures; the record gets removed afterwards
SELECT DISTINCT
	 @Transaction_Batch_ID
	,Transaction_ID
	,Transaction_ID
FROM 
	@Transactions
;		


-- Get the NetPremium, IPT for Transaction_ID (logic taken from Accounts_Premium TVF):

INSERT INTO @Account_Premiums
SELECT 
	 [TranIDs].[TRANSACTION_ID]
	,ISNULL(SUM(CASE [ATB].[TRAN_BREAKDOWN_TYPE_ID] WHEN 'NET' THEN [ATB].[AMOUNT] ELSE 0 END), 0) AS [NetPremium]
	,ISNULL(SUM(CASE WHEN SubString([ATB].[PREMIUM_SECTION_ID], 1, 3) = 'TAX' THEN [ATB].[AMOUNT] ELSE 0 END), 0) AS [IPT]
	,ISNULL(SUM(CASE [ATB].[TRAN_BREAKDOWN_TYPE_ID] WHEN 'FEE' THEN [ATB].[AMOUNT] ELSE 0 END), 0) AS [Fee]
FROM 
	[dbo].[ACCOUNTS_TRANSACTION_BATCH] AS [TranIDs]
	INNER JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB]	ON [TranIDs].[TRANSACTION_ID] = [ATB].[TRANSACTION_ID]
	INNER JOIN [dbo].[LIST_TRAN_BREAKDOWN_TYPE] AS [LTBT] ON [ATB].[TRAN_BREAKDOWN_TYPE_ID] = [LTBT].[TRAN_BREAKDOWN_TYPE_ID]
WHERE
	[TranIDs].[TRANSACTION_BATCH_ID] = @Transaction_Batch_ID
GROUP BY
	[TranIDs].[TRANSACTION_ID]
;


-- Split the transaction list in to those with subagent payments, and those without:
INSERT INTO
	@SubAgentList
SELECT
	[Transaction_ID]
FROM 
	[dbo].[Accounts_SubAgent](NULL, NULL, NULL, NULL, NULL, @Transaction_Batch_ID)
WHERE 
	[Settled] = 0 
;


-- For the client part of the select we're only interested in those without a sub agent posting; the rest will be picked up on the sub agent select:

INSERT INTO 
	@NoSubAgentList
SELECT DISTINCT
	[Transaction_ID]
FROM 
	[dbo].[ACCOUNTS_TRANSACTION_BATCH]
WHERE
	[TRANSACTION_BATCH_ID] = @Transaction_Batch_ID
	AND [TRANSACTION_ID] NOT IN (SELECT [Transaction_ID] FROM @SubAgentList)
;


--Refil the transaction batch with only the client transactions:

DELETE FROM 
	[dbo].[ACCOUNTS_TRANSACTION_BATCH]
WHERE 
	[TRANSACTION_BATCH_ID] = @Transaction_Batch_ID
;


INSERT INTO
	[dbo].[ACCOUNTS_TRANSACTION_BATCH]
SELECT
	@Transaction_Batch_ID, 
	[Transaction_ID], 
	[Transaction_ID]
FROM 
	@NoSubAgentList
;


--Get a list of transactions the subagent is paying in full for the client where there is no commission or subsidy element:

INSERT INTO 
	@RecData
SELECT 
	 1
	,[ACV].[TRANSACTION_ID]
	,[ClientName]
	,[ACV].[PolicyNumber]
	,[ACV].[CreatedDate]
	,[ACV].[PaymentDate]
	,[ACV].[Transaction_Code_ID]
	,0 AS [Gross] -- Calculats below in the "update premiums" section
	,0 AS [Premium] -- Calculats below in the "update premiums" section
	,0 AS [IPT] -- Calculats below in the "update premiums" section
	,0 AS [Commission] -- Calculats below in the "update premiums" section
	,MAX(CONVERT(int, ISNULL([Ticked], 0))) AS [Ticked]
	,MAX(CONVERT(int, ISNULL([Query], 0))) AS [Query]
	,ISNULL([Query_Reason_ID], '0') AS [Query_Reason_ID]
	,MAX(CONVERT(int, ISNULL([AwaitingReconciliation], 0))) AS [AwaitingReconciliation]
	,ISNULL([Adjustment], 0) AS [Adjustment]
	,ISNULL([Pay_Adjust_Type_ID], '0') AS [Pay_Adjust_Type_ID]
	,ISNULL([ASAR].[OUTSTANDING], 0) AS [Outstanding]
	,[ACV].[Outstanding] + ISNULL([ASAR].[OUTSTANDING], 0) + ISNULL([ASAR].[ADJUSTMENT], 0) As [Due]
	,[ACV].Agent_ID -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[ACV].PortfolioKey -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[ACV].SchemeTable_ID -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[ACV].ProductType -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[ACV].SubAgent_ID -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[PayNetOfCommission] -- Irrelevant for this condition
	,[ACV].[Outstanding] AS [ClientOutstanding] -- Get the amount outstanding from the sub agent (for payment from dealer only)
	,0 AS [ClientSettled]
	,'0' AS [Payment_Type_ID]
	,1 AS [ClientPayment]
	,0 AS [Allocated]
	,0 AS [SubAgentAllocated]
	,ISNULL([ASAR].[IPT], 0) AS [FeeIPT]
FROM
	[dbo].[Accounts_Client](NULL, NULL, NULL, NULL, NULL, NULL, @Transaction_Batch_ID) AS [ACV]
	LEFT OUTER JOIN [dbo].[ACCOUNTS_SUBAGENT_RECONCILE] AS [ASAR] ON [ASAR].[TRANSACTION_ID] = [ACV].[Transaction_ID]
	INNER JOIN [dbo].[RM_SUBAGENT] AS [RMSA] ON [RMSA].[SUBAGENT_ID] = [ACV].[SubAgent_ID]
	INNER JOIN @NoSubAgentList AS [NSAL] ON [NSAL].[Transaction_ID] = [ACV].[Transaction_ID]
WHERE
	(@SubAgentID IS NULL OR [ACV].[SubAgent_ID] IN (SELECT [Data] FROM [dbo].[tvfSplitStringByDelimiter](@SubAgentID, ',')))
	AND [ACV].[Agent_ID] = IsNull(@AgentID, [ACV].[Agent_ID])
	AND ([ACV].[ProductType] = IsNull(@ProductType, [ACV].[ProductType]) OR [ACV].[ProductType] IS NULL)
	AND ([ACV].[SchemeTable_ID] = IsNull(@SchemeTable_ID, [ACV].[SchemeTable_ID]) OR ([ACV].[SchemeTable_ID] IS NULL AND @SchemeTable_ID IS NULL))
	AND [ACV].[Settled] = 0
GROUP BY
	 [ACV].[TRANSACTION_ID]
	,[ClientName]
	,[ACV].[PolicyNumber]
	,[ACV].[CreatedDate]
	,[ACV].[PaymentDate]
	,[ACV].[Transaction_Code_ID]
	,[ACV].[Agent_ID]
	,[ACV].[PortfolioKey]
	,[ACV].[SchemeTable_ID]
	,[ACV].[ProductType]
	,[ACV].[SubAgent_ID]
	,[ACV].[Amount]
	,[PayNetOfCommission]
	,[ACV].[Paymethod_ID] 
	,[Query_Reason_ID]
	,[Adjustment]
	,[ASAR].[OUTSTANDING]
	,[Pay_Adjust_Type_ID]
	,[ACV].[Outstanding]
	,[ASAR].[IPT]
;


-- Finished with the transaction batch now:

DELETE FROM
	[dbo].[ACCOUNTS_TRANSACTION_BATCH] 
WHERE 
	[TRANSACTION_BATCH_ID] = @Transaction_Batch_ID
;


-- Get transactions that have postings to the sub agent account; this will be both commission and payments by subagent:

INSERT INTO
	@RecData
SELECT
	 2
	,[ASV].[Transaction_ID]
	,[XRefAC] AS [ClientName]
	,[PolicyNumber]
	,[CreatedDate]
	,[PaymentDate]
	,[ASV].[Transaction_Code_ID]
	,ISNULL([Premium],0) as [Gross]
	,ISNULL([Premium] - [AP].[IPT],0) AS [Premium]
	,ISNULL([AP].[IPT],0)
	,[Amount] AS [Commission]
	,MAX(CONVERT(int, ISNULL([Ticked], 0))) AS [Ticked]
	,MAX(CONVERT(int, ISNULL([Query], 0))) AS [Query]
	,ISNULL([Query_Reason_ID], '0') AS [Query_Reason_ID]
	,MAX(CONVERT(int, ISNULL([AwaitingReconciliation], 0))) AS [AwaitingReconciliation]
	,ISNULL([Adjustment], 0) AS [Adjustment]
	,ISNULL([PAY_ADJUST_TYPE_ID], '0') AS [Pay_Adjust_Type_ID]
	,ISNULL([ASAR].[OUTSTANDING], 0) AS [Outstanding]
	,CASE [Paymethod_ID]
		WHEN '3ERGLT19' THEN -- If the paymethod is "payment from dealer"
			CASE [PayNetOfCommission]
				WHEN 0 THEN 
					--If the client is settled then the commission is due to the sub-agent, otherwise the sub-agent owes the gross.
					CASE (ISNULL([Premium],0) + ISNULL([AP].[IPT], 0) + ISNULL([Fee], 0) - ISNULL([ATLV].[Allocated], 0)) 
						WHEN 0 THEN ISNULL([Amount],0)  
						ELSE (ISNULL([Premium],0) + ISNULL([AP].[IPT], 0) + ISNULL([Fee], 0) - ISNULL([ATLV].Allocated, 0))
					END
				--Paying net is just concerned with what the sub-agent owes.
				WHEN 1 THEN (ISNULL([Premium],0) + ISNULL([AP].[IPT], 0) + ISNULL([Fee], 0) + ISNULL([Amount],0) - ISNULL([ATLV].[Allocated], 0))
			END 
		ELSE ISNULL([ASV].[Amount],0)
	END - ISNULL([ASV].[Allocated], 0) + ISNULL([ASAR].[Adjustment], 0) + ISNULL([ASAR].[OUTSTANDING], 0) + ISNULL([ASAR].[IPT], 0) As [Due] -- Get the due amount. Remember Amount is the commission amount, and is the reverse sign of Premium.
	,[ASV].[Agent_ID] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[PortfolioKey] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[SchemeTable_ID] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[ProductType] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[SubAgent_ID] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,[PayNetOfCommission] -- These are here for the save to work correctly because it uses the data set to fill the update transactions sp
	,CASE [Paymethod_ID]
		WHEN '3ERGLT19' THEN ISNULL((SELECT [Outstanding] FROM [dbo].[Accounts_Client_View] AS [ACV] WHERE [ACV].[TRANSACTION_ID] = [ASV].[Transaction_ID]), 0)
		ELSE 0
	 END AS [ClientOutstanding] -- Get the amount outstanding from the sub agent (for payment from dealer only)
	,ISNULL((SELECT [Settled] FROM [dbo].[ACCOUNTS_CLIENT_VIEW] AS [ACV] WHERE [ACV].[TRANSACTION_ID] = [ASV].[Transaction_ID]), 1) AS [ClientSettled]
	,'0' AS [Payment_Type_ID]
	,CASE [Paymethod_ID]
		WHEN '3ERGLT19' THEN
			--If the paymethod is "payment from dealer".
			CASE [PayNetOfCommission]
				WHEN 0 THEN 
					--If the client is settled then the commission is due to the sub-agent, otherwise the sub-agent owes the gross.
					CASE ([Premium]  + ISNULL([AP].[IPT], 0) + ISNULL([Fee], 0) - ISNULL([ATLV].[ALLOCATED], 0))
						WHEN 0 THEN 0  
						ELSE 1
					END
				WHEN 1 THEN 1
			END 
		ELSE 0
	END AS [ClientPayment]
	,ISNULL([ATLV].[Allocated], 0) AS [Allocated]
	,ISNULL([ASV].[Allocated], 0) AS [SubAgentAllocated]
	,ISNULL([ASAR].[IPT], 0)
FROM
	[dbo].[Accounts_SubAgent_MH](@SubAgentID, @StartDate, @EndDate, 1, NULL, NULL) AS [ASV] -- Moorhouse version of the function accepts multiple SubAgent IDs
	LEFT JOIN @Account_Premiums AS [AP] ON [AP].[Transaction_Id] = [ASV].[Transaction_ID]
	INNER JOIN [dbo].[LIST_TRANSACTION_CODE] AS [LTC] ON [ASV].[Transaction_Code_ID] = [LTC].[TRANSACTION_CODE_ID]
	LEFT OUTER JOIN [dbo].[ACCOUNTS_TRAN_LINK_VIEW] AS [ATLV] ON [ASV].[Transaction_ID] = [ATLV].[TRANSACTION_ID]
															  AND [ATLV].[ACCOUNT_TYPE_ID] = 'CLIENT'
	LEFT OUTER JOIN [dbo].[ACCOUNTS_SUBAGENT_RECONCILE] AS [ASAR] ON [ASAR].[TRANSACTION_ID] = [ASV].[TRANSACTION_ID]
																  AND [ASAR].[ClientPayment] = CASE [Paymethod_ID]
																									WHEN '3ERGLT19' THEN
																										--If the paymethod is "payment from dealer".
																										CASE [PayNetOfCommission]
																											WHEN 0 THEN 
																												--If the client is settled then the commission is due to the sub-agent, otherwise the sub-agent owes the gross.
																												CASE ([Premium] - ISNULL([ATLV].[Allocated], 0))
																													WHEN 0 THEN 0  
																													ELSE 1
																												END
																											WHEN 1 THEN 1
																										END 
																									ELSE 0
																								END
WHERE
	[ASV].Agent_ID = ISNULL(@AgentID, [ASV].[Agent_ID])
	AND ([ASV].[ProductType] = ISNULL(@ProductType, [ASV].[ProductType]) OR [ASV].[ProductType] IS NULL)
	AND ([ASV].SchemeTable_ID = ISNULL(@SchemeTable_ID, [ASV].[SchemeTable_ID]) OR ([ASV].[SchemeTable_ID] IS NULL AND @SchemeTable_ID IS NULL))
	AND [Settled] = 0
GROUP BY
	 [ASV].[TRANSACTION_ID]
	,[XRefAC]
	,[PolicyNumber]
	,[CreatedDate]
	,[PaymentDate]
	,[ASV].[Transaction_Code_ID]
	,[Query_Reason_ID]
	,[Adjustment]
	,[ASAR].[OUTSTANDING]
	,[Pay_Adjust_Type_ID]
	,[Agent_ID]
	,[PortfolioKey]
	,[SchemeTable_ID]
	,[ProductType]
	,[SubAgent_ID]
	,[Amount]
	,[Premium]
	,[PayNetOfCommission]
	,[AP].[IPT]
	,[Fee]
	,[Paymethod_ID]
	,[ASV].[Allocated]
	,[ASAR].[ClientPayment]
	,[ATLV].[Allocated]
	,[ASAR].[IPT]
;


INSERT INTO @TransactionIDS
SELECT
	 [Transaction_ID]
	,[Transaction_Code_ID]
	,[PaymentDate]
FROM
	@RecData
;


DECLARE [Premium_Cursors] CURSOR FOR
SELECT 
	 [Transaction_ID]
	,[Transaction_Code_ID]
	,[PaymentDate]
FROM 
	@TransactionIDS

OPEN [Premium_Cursors]

FETCH NEXT FROM [Premium_Cursors] INTO 
	@Transaction_ID,
	@Transaction_Code_ID,
	@PaymentDate

WHILE @@FETCH_STATUS = 0
BEGIN 

	IF @Transaction_Code_ID != 'IPD'
	BEGIN
		INSERT INTO @UpdatePremiums
			SELECT *, NULL FROM [dbo].[FN_Transaction_Premium](@Transaction_ID, NULL)
	END
	ELSE
	BEGIN
	
		IF @PaymentDate > @EndDate 
		BEGIN 	
			DELETE @RecData WHERE [Transaction_ID] = @Transaction_ID -- Remove future dated transactions
		END
		ELSE
		BEGIN 	

			-- IPD transactions need to calculate the allocated amounts. Get the link to the IPC:
			SELECT @IPDLINK_ID = MAX([ATL].[LINK_ID])
			FROM
				[dbo].[ACCOUNTS_TRAN_LINK] AS [ATL]
				INNER JOIN [dbo].[ACCOUNTS_TRAN_LINK] AS [ATL2]	ON [ATL].[LINK_ID] = [ATL2].[LINK_ID]
																AND [ATL2].[TRANSACTION_ID] <> [ATL].[TRANSACTION_ID]
				INNER JOIN [dbo].[ACCOUNTS_TRANSACTION] AS [AT2] ON [ATL2].[TRANSACTION_ID] = [AT2].[TRANSACTION_ID]
																	AND [AT2].[Transaction_Code_ID] = 'IPC'
			WHERE
				[ATL].[TRANSACTION_ID] = @TRANSACTION_ID
								
			DELETE FROM @IPDALLOCATIONS

			-- Call the allocation sp to work out the individual instalment premium allocations:
			INSERT INTO @IPDALLOCATIONS
			SELECT * FROM [dbo].[FN_ACC_ALLOC_IPD](@IPDLink_ID, 'CLIENT')

			-- UPDATE THE PREMIUMS TABLE
			INSERT INTO @UpdatePremiums(
				 [Transaction_ID]
				,[NetPremium]
				,[TotalPayable]
				,[IPT]
				,[OriginalTransactionType]
			)
			SELECT 
				@TRANSACTION_ID
				,ISNULL(SUM(CASE [ATB].[TRAN_BREAKDOWN_TYPE_ID]	WHEN 'NET' THEN [IPD].[Allocated] ELSE 0 END), 0) AS [NetPremium]
				,ISNULL(SUM(CASE [LTBT].[INCLUDEINTOTAL] WHEN 1 THEN [IPD].[Allocated] ELSE 0 END), 0) AS [TotalPayable]
				,ISNULL(SUM(CASE WHEN SUBSTRING([ATB].[PREMIUM_SECTION_ID], 1, 3) = 'TAX' THEN [IPD].[Allocated] ELSE 0 END), 0) AS [IPT]
				,MAX([AT].[TRANSACTION_CODE_ID])
			FROM	
				@IPDALLOCATIONS IPD
				INNER JOIN [dbo].[ACCOUNTS_TRAN_BREAKDOWN] AS [ATB] ON [IPD].[Tran_Breakdown_ID] = [ATB].[TRAN_BREAKDOWN_ID]
				INNER JOIN [dbo].[LIST_TRAN_BREAKDOWN_TYPE] AS [LTBT] ON [ATB].[TRAN_BREAKDOWN_TYPE_ID] = [LTBT].[TRAN_BREAKDOWN_TYPE_ID]
				INNER JOIN [dbo].[ACCOUNTS_TRANSACTION] AS [AT] ON [ATB].[TRANSACTION_ID] = [AT].[TRANSACTION_ID]

		END

	END

	FETCH NEXT FROM [Premium_Cursors] INTO 
		@Transaction_ID,
		@Transaction_Code_ID,
		@PaymentDate

END -- End @@FETCH_STATUS = 0

CLOSE [Premium_Cursors]
DEALLOCATE [Premium_Cursors]
;


UPDATE [RD]
SET	[RD].[Gross]				= ([UP].[NetPremium] + [UP].[IPT]),
	[RD].[Premium]				= ([UP].[NetPremium]), 
	[RD].[IPT]					= ([UP].[IPT]),
	[RD].[Transaction_Code_ID]	= ISNULL([UP].[OriginalTransactionType], [RD].[Transaction_Code_ID]),
	[RD].[Due]					= CASE [RD].[Transaction_Code_ID]
									WHEN 'IPD' THEN	(ISNULL([UP].[NetPremium],0) + ISNULL([UP].[IPT], 0) + ISNULL([Commission],0) + ISNULL([Fee], 0)
													 - ISNULL([Allocated], 0)) - ISNULL([SubAgentAllocated], 0) + ISNULL([Adjustment], 0)
									ELSE ISNULL([RD].[Due],0)
								  END,
	[RD].ClientPayment			= CASE [RD].[Transaction_Code_ID]
									WHEN 'IPD' THEN	 
											--If the client is settled then the commission is due to the sub-agent, otherwise the sub-agent owes the gross.
											CASE (IsNull([UP].[NetPremium],0) - ISNULL([Allocated], 0))
												WHEN 0 THEN 0  
												ELSE 1
											END
									ELSE [RD].ClientPayment
								  END
FROM
	@UpdatePremiums AS UP
	CROSS JOIN @RecData AS [RD]
WHERE
	[RD].[Transaction_ID] = [UP].[Transaction_ID]
;


INSERT INTO @SubAgentRec (
	 [Transaction_ID]
	,[PolicyHolder]
	,[PolicyNumber]
	,[CreatedDate]
	,[PaymentDate]
	,[Transaction_Code_ID]
	,[Gross]
	,[Premium]
	,[IPT]
	,[Commission]
	,[Ticked]
	,[Query]
	,[Query_Reason_ID]
	,[AwaitingReconciliation]
	,[Adjustment]
	,[Outstanding]
	,[Pay_Adjust_Type_ID]
	,[Due]
	,[Agent_ID]
	,[PortfolioKey]
	,[SchemeTable_ID]
	,[ProductType_ID]
	,[SubAgent_ID]
	,[PayNetOfCommission]
	,[ClientOutstanding]
	,[ClientSettled]
	,[Payment_Type_ID]
	,[ClientPayment]
	,[FeeIPT]
)
SELECT 
	 [Transaction_ID] 
	,[ClientName]
	,[PolicyNumber]
	,[CreatedDate]
	,[PaymentDate]
	,[Transaction_Code_ID]
	,[Gross]
	,[Premium]
	,[IPT]
	,[Commission]
	,[Ticked]
	,[Query]
	,[Query_Reason_ID]
	,[AwaitingReconciliation]
	,[Adjustment]
	,[Outstanding]
	,[Pay_Adjust_Type_ID]
	,[Due]
	,[Agent_ID]
	,[PortfolioKey]
	,[SchemeTable_ID]
	,[ProductType]
	,[SubAgent_ID]
	,[PayNetOfCommission]
	,[ClientOutstanding]
	,[ClientSettled]
	,[Payment_Type_ID]
	,[ClientPayment]
	,[FeeIPT]
FROM
	@RecData
;

-- End of code lifted from SP_ACC_SUBAGENTREC_GETDATA


-- =========================
-- Return data to the report (code from SP_REP_CF01_SUBAGENTSTATEMENT)
-- =========================

SELECT
	 [SAR].[PaymentDate] AS [EffectiveDate]
	,ISNULL([SAR].[PolicyNumber], '') AS [PolicyNo]
	,ISNULL([PolicyHolder], '') AS [PolicyHolder]
	,[SSN].[SchemeName]
	,[AT].[Transaction_Code_ID]
	,[APV].[NetPremium] AS [PremExcTaxes]
	,[APV].[Fee]
	,[APV].[IPT] AS [Tax]
	,[APV].[SubAgentCommission]
	--,[Due] AS [NetPayable]
	,[APV].[NetPremium] - [APV].[SubAgentCommission] + [APV].[IPT] + [APV].[Fee] AS [NetPayable]
	,[SAR].[SubAgent_ID]
	,[RMSA].[REFERENCE] AS [SubAgentRef]
	,CASE
		WHEN [RMSA].[NAME] LIKE '%[[]%' THEN RTRIM(LEFT([RMSA].[NAME], CHARINDEX('[', [RMSA].[NAME], 1) -1)) -- Remove postcodes in square brackets
		ELSE [RMSA].[NAME]
	 END AS [SubAgent]
	,CASE
		WHEN [RMSA].[NAME] LIKE '%[[]%' THEN RTRIM(LEFT([RMSA].[NAME], CHARINDEX('[', [RMSA].[NAME], 1) -1)) -- Remove postcodes in square brackets
		ELSE [RMSA].[NAME]
	 END + char(10)+char(13)
	 + CASE
		WHEN ISNUMERIC([ADDR].[HOUSE]) = 1 OR [ADDR].[HOUSE] LIKE '[0-9][a,b,c]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][a,b,c]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][0-9][a,b,c]'
			OR [ADDR].[HOUSE] LIKE '[0-9]-[0-9]' OR [ADDR].[HOUSE] LIKE '[0-9]-[0-9][0-9]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9]-[0-9][0-9]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]'
			THEN [ADDR].[HOUSE] + ' ' + [ADDR].[STREET]
		ELSE ISNULL([ADDR].[HOUSE], '')
	   END
	 + CASE
		WHEN ISNUMERIC([ADDR].[HOUSE]) = 1 OR [ADDR].[HOUSE] LIKE '[0-9][a,b,c]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][a,b,c]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][0-9][a,b,c]'
			OR [ADDR].[HOUSE] LIKE '[0-9]-[0-9]' OR [ADDR].[HOUSE] LIKE '[0-9]-[0-9][0-9]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9]-[0-9][0-9]' OR [ADDR].[HOUSE] LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]'
			THEN ''
		ELSE CASE WHEN ISNULL([ADDR].[STREET], '') = '' THEN '' ELSE char(10)+char(13) + [ADDR].[STREET] END END
	 + CASE WHEN ISNULL([ADDR].[LOCALITY], '') = '' THEN '' ELSE char(10)+char(13) + [ADDR].[LOCALITY] END
	 + CASE WHEN ISNULL([ADDR].[CITY], '') = '' THEN '' ELSE char(10)+char(13) + [ADDR].[CITY] END
	 + CASE WHEN ISNULL([ADDR].[POSTCODE], '') = '' THEN '' ELSE char(10)+char(13) + [ADDR].[POSTCODE] END  AS [SubAgentAddress]
	,ISNULL(CASE
				WHEN Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)) <= Convert(datetime, @EndDate) AND DATEDIFF(DAY, Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)), Convert(datetime, @EndDate)) BETWEEN 0 AND 30
				THEN [APV].[NetPremium] - [APV].[SubAgentCommission] + [APV].[IPT] + [APV].[Fee]
				ELSE 0
			END,0) AS [Age1To30]  -- 1-30 Days
	,ISNULL(CASE
				WHEN Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)) <= Convert(datetime, @EndDate) AND DATEDIFF(DAY, Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)), Convert(datetime, @EndDate)) BETWEEN 31 AND 60
				THEN [APV].[NetPremium] - [APV].[SubAgentCommission] + [APV].[IPT] + [APV].[Fee]
				ELSE 0
			END,0) AS [Age31To60]  -- 31-60 Days
	,ISNULL(CASE
				WHEN Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)) <= Convert(datetime, @EndDate) AND DATEDIFF(DAY, Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)), Convert(datetime, @EndDate)) BETWEEN 61 AND 90
				THEN [APV].[NetPremium] - [APV].[SubAgentCommission] + [APV].[IPT] + [APV].[Fee]
				ELSE 0
			END,0) AS [Age61To90]  -- 61-90 Days
	,ISNULL(CASE
				WHEN Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)) <= Convert(datetime, @EndDate) AND DATEDIFF(DAY, Convert(datetime, Convert(VARCHAR(11), [SAR].[CreatedDate], 113)), Convert(datetime, @EndDate)) > 90
				THEN [APV].[NetPremium] - [APV].[SubAgentCommission] + [APV].[IPT] + [APV].[Fee]
				ELSE 0
			END,0) AS [Age91Plus]  -- 91+ Days
FROM
	@SubAgentRec [SAR]
		INNER JOIN [dbo].[ACCOUNTS_TRANSACTION] AS [AT] ON [SAR].[Transaction_ID] = [AT].[TRANSACTION_ID]
		LEFT JOIN [dbo].[ACCOUNTS_CLIENT_TRAN_LINK] AS [ACTL] ON [ACTL].[TRANSACTION_ID] = [SAR].[Transaction_ID]
			LEFT JOIN [dbo].[CUSTOMER_POLICY_DETAILS] AS [CPD] ON [ACTL].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID] AND [ACTL].[POLICY_DETAILS_HISTORY_ID] = [CPD].[History_ID]
				LEFT OUTER JOIN [dbo].[RM_PRODUCT] AS [SRP] ON [SRP].[PRODUCT_ID] = [CPD].[PRODUCT_ID]
				LEFT OUTER JOIN [dbo].[SYSTEM_SCHEME_NAME] AS [SSN] ON [SSN].[SCHEMETABLE_ID] = [CPD].[SCHEMETABLE_ID]			
		INNER JOIN [dbo].[ACCOUNTS_PREMIUM_VIEW] AS [APV] ON [SAR].[Transaction_ID] = [APV].[Transaction_ID]
		INNER JOIN [dbo].[RM_SUBAGENT] AS [RMSA] ON [RMSA].[SUBAGENT_ID] = [SAR].[SubAgent_ID]
			LEFT JOIN [dbo].[RM_ADDRESS] AS [ADDR] ON [RMSA].[ADDRESS_ID] = [ADDR].[ADDRESS_ID]
WHERE
	(@SubAgentID IS NULL OR [SAR].[SubAgent_ID] IN (SELECT [Data] FROM [dbo].[tvfSplitStringByDelimiter](@SubAgentID, ',')))
	AND [CPD].[SCHEMETABLE_ID] NOT IN (1480 -- NRT Consilium - Contractors All Risk
									   ,1462 -- NRT Consilium - Fleet
									   ,1460 -- NRT Consilium - Tradesman Liability
									   ,1463 -- NRT Consilium - Professional Indemnity
									   ,1459 -- NRT Consilium - Commercial Combined
									   ,1461 -- NRT Consilium - Small Business and Consultants
									   ,1519 -- NRT Consilium - Turnover
									   ,1499 -- NRT Consilium - Liability XS Layer
									   ,1660 -- NRT Corin Underwriting Limited - Manufacturing
									   ,1657 -- NRT Corin Underwriting Limited - Small Business and Consultants
									   ,1656 -- NRT Corin Underwriting Limited - Tradesman Liability
									   ,1659 -- NRT Corin Underwriting Limited - Commercial Combined
									   ,1661 -- NRT Corin Underwriting Limited - Contractors All Risks
									   ,1658 -- NRT Corin Underwriting Limited - Motor Trade
									   ,1655 -- NRT Corin Underwriting Limited - Turnover
									   ,1214 -- NRT Miles Smith - Small Business & Consultants
									   ,1212 -- NRT Miles Smith - Commercial Combined
									   ,1577 -- NRT Miles Smith - Turnover
									   ,1210 -- NRT Miles Smith - Fleet
									   ,1389 -- NRT Miles Smith - Professional Indemnity
									   ,1211 -- NRT Miles Smith - Hauliers Choice
									   ,1390 -- NRT Miles Smith - Contractors All Risks
									   ,1470 -- NRT Miles Smith - Liability XS Layer
									   ,1213 -- NRT Miles Smith - Tradesman Liability
									   ,1507 -- NRT Jensten UW - Contractors All Risks
									   ,1513 -- NRT Jensten UW - Fleet
									   ,1650 -- NRT Jensten UW - Miscellaneous
									   ,1647 -- NRT Jensten UW - Cyber Insurance
									   ,1653 -- NRT Vasek - Miscellaneous
									   )
ORDER BY 
	 [RMSA].[NAME]
	,[PolicyHolder]
	,[SAR].PaymentDate
;

