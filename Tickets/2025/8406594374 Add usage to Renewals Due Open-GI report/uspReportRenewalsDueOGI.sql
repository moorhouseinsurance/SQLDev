USE [OpenGI]
GO
/****** Object:  StoredProcedure [dbo].[uspReportRenewalsDueOGI]    Script Date: 11/02/2025 09:54:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create Date: 27 February 2023
-- Description: New version of Renewals Due OGI report
-- =============================================

-- Date			Who						Change
-- 05/02/2025	Simon					Added the vehicle cover/usage (Monday ticket 8406594374)

ALTER PROCEDURE [dbo].[uspReportRenewalsDueOGI]

      @DateFrom datetime,
      @DateTo datetime,
	  @Branch varchar(25)

AS

/*
	DECLARE @DateFrom datetime
	DECLARE @DateTo datetime
	DECLARE @Branch varchar(25)

	SET @DateFrom = '01 Mar 2023'
	SET @DateTo = '31 Mar 2023'
	SET @Branch = '0,3'

	EXEC [dbo].[uspReportRenewalsDueOGI] @DateFrom, @DateTo, @Branch
*/

IF CONVERT(VARCHAR(12), @DateTo, 114) = '00:00:00:000'
	SET @DateTo = DATEADD(DAY, 1, @DateTo);

IF OBJECT_ID(N'tempdb.dbo.#RenewalsDue') IS NOT NULL
	DROP TABLE [#RenewalsDue];

CREATE TABLE [#RenewalsDue] (
	 [B@] int
	,[BranchName] varchar(30)
	,[PreviousRef@] varchar(6)
	,[PreviousPolRef@] varchar(10)
	,[PreviousPType] varchar(2)
	,[PreviousProduct] varchar(20)
	,[PreviousInsurer] varchar(255)
	,[PreviousPolEffectiveDate] datetime
	,[PreviousPolEndDate] datetime
	,[PreviousTerm_Code] varchar(8)
	,[PreviousGWP] float
	,[PreviousCommission] float
	,[PreviousFee] float
	,[PreviousDiscount] float
	,[PreviousDDIncome] float
	,[PreviousIncomeExcDD] float
	,[PreviousIncomeIncDD] float
	,[PreviousVehicleReg] varchar(10)
	,[New Policy Match Type] int
	,[NewRef@] varchar(6)
	,[NewPolRef@] varchar(10)
	,[NewPType] varchar(2)
	,[NewInsurer] varchar(255)
	,[NewPolEffectiveDate] datetime
	,[NewPolEndDate] datetime
	,[NewTerm_Code] varchar(8)
	,[NewGWP] float
	,[NewCommission] float
	,[NewFee] float
	,[NewDiscount] float
	,[NewDDIncome] float
	,[NewIncomeExcDD] float
	,[NewIncomeIncDD] float
	,[NewVehicleReg] varchar(10)
	,[Status] varchar(25)
	,[Client Title] varchar(20)
	,[Client Forenames] varchar(20)
	,[Client DOB] varchar(20)
	,[Client Telephone] varchar(25)
	,[Client Telephone2] varchar(25)
	,[Payment Plan] varchar(15)
	,[Email] varchar(50)
	,[Classification] varchar(10)
	,[Occupation] varchar(30)
	,[ContinuousCardAuthority] varchar(3)
	,[VehicleCoverUsage] varchar(30)
);

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- ===================
-- INSERT DUE POLICIES
-- ===================

-- Insert policies:

WITH [NBRENTran] AS
(
	SELECT DISTINCT -- Distinct as there can be multiple transactions for smae NB / Renewal with same Dt_raised
		 [B@]
		,[PolRef@]
		,[Dt_raised]
		,DATEADD(yy,1,DATEADD(day, -1, [Dt_raised])) AS [PolEndDate]
	FROM
		[dbo].[ic_brcledger]
	WHERE
		[TranType] IN ('New Business','Renewal','Transfrd NB')
)
INSERT INTO [#RenewalsDue] (
	 [B@]
	,[BranchName]
	,[PreviousRef@]
	,[PreviousPolRef@]
	,[PreviousPType]
	,[PreviousProduct]
	,[PreviousInsurer]
	,[PreviousPolEffectiveDate]
	,[PreviousPolEndDate]
	,[PreviousTerm_Code]
	,[PreviousGWP]
	,[PreviousCommission]
	,[PreviousFee]
	,[PreviousDiscount]
	,[PreviousDDIncome]
	,[PreviousIncomeExcDD]
	,[PreviousIncomeIncDD]
	,[PreviousVehicleReg]
	,[NewRef@]
	,[NewPolRef@]
	,[NewPType]
	,[NewInsurer]
	,[NewPolEffectiveDate]
	,[NewPolEndDate]
	,[NewTerm_Code]
	,[NewGWP]
	,[NewCommission]
	,[NewFee]
	,[NewDiscount]
	,[NewDDIncome]
	,[NewIncomeExcDD]
	,[NewIncomeIncDD]
	,[NewVehicleReg]
	,[Status]
	,[Client Title]
	,[Client Forenames]
	,[Client DOB]
	,[Client Telephone]
	,[Client Telephone2]
	,[Payment Plan]
	,[Email]
	,[Classification]
	,[Occupation]
	,[ContinuousCardAuthority]
	,[VehicleCoverUsage]
)
SELECT
	 [P].[B@]
	,[B].[BranchName]
	,[P].[Ref@]
	,[P].[PolRef@] AS [PreviousPolRef@]
	,[P].[Ptype] AS [PreviousPType]
	,CASE
		WHEN [PD].[Poltype] IN ('BE', 'BU', 'FD') THEN 'Breakdown' -- BE = 'Breakdown EU and HS', BU = 'Breakdown UK and HS', FD = 'Free Breakdown'
		WHEN [PD].[Poltype] IN ('BS', 'LD', 'LF') THEN 'Legal Expenses' -- BS = 'Business Support', LD = 'Licence Defence', LF = 'Free Legal Exp'
		WHEN [PD].[Poltype] IN ('EP', 'PX') THEN 'Excess Waiver' -- EP = 'Excess Protection', PX = 'Protected Excess'
		WHEN [PD].[Poltype] = 'GL' THEN 'Windscreen' -- GL = 'Glass'
		WHEN [PD].[Poltype] IN ('SK', 'EX', 'FK') THEN 'Key Care' -- SK = 'KeyCover', EX = 'Keycare', FK = 'Free KC'
		ELSE [PD].[Description]
	 END AS [PreviousProduct]
	,CASE 
		WHEN [INS].[TGSL] IS NULL THEN [P].[Insco]
		ELSE [INS].[TGSL]
	 END AS [PreviousInsurer]
	,[NBRENTran].[Dt_raised] AS [PreviousPolEffectiveDate]
	,[NBRENTran].[PolEndDate] AS [PreviousPolEndDate]
	,[P].[Term_code] AS [PreviousTerm_Code]
	,NULL AS [PreviousGWP] -- Update below
	,NULL AS [PreviousCommission] -- Update below
	,NULL AS [PreviousFee] -- Update below
	,NULL AS [PreviousDiscount] -- Update below
	,NULL AS [PreviousDDIncome] -- Update below
	,NULL AS [PreviousIncomeExcDD] -- Update below
	,NULL AS [PreviousIncomeIncDD] -- Update below
	,ISNULL([TW1].[Reg_mark], [CF].[Reg]) AS [PreviousVehicleReg]
	,NULL AS [NewRef@] -- Update below
	,NULL AS [NewPolRef@] -- Update below
	,NULL AS [NewPType] -- Update below
	,NULL AS [NewInsurer] -- Update below
	,NULL AS [NewPolEffectiveDate] -- Update below
	,NULL AS [NewPolEndDate] -- Update below
	,NULL AS [NewTerm_Code] -- Update below
	,NULL AS [NewGWP] -- Update below
	,NULL AS [NewCommission] -- Update below
	,NULL AS [NewFee] -- Update below
	,NULL AS [NewDiscount] -- Update below
	,NULL AS [NewDDIncome] -- Update below
	,NULL AS [NewIncomeExcDD] -- Update below
	,NULL AS [NewIncomeIncDD] -- Update below
	,NULL AS [NewVehicleReg] -- Update below
	,NULL AS [Status] -- Update below
	,[C].[Title] AS [Client Title]
	,[C].[Forenames] AS [Client Forenames]
	,[C].[Dob] AS [Client DOB]
	,LEFT(REPLACE([C].[Tel],' ',''),CASE WHEN PATINDEX('%[^0-9]%',REPLACE([C].[Tel],' ',''))=0 THEN LEN(REPLACE([C].[Tel],' ','')) ELSE PATINDEX('%[^0-9]%',REPLACE([C].[Tel],' ',''))-1 END) AS [Client Telephone]
	,LEFT(REPLACE([C].[Tel2],' ',''),CASE WHEN PATINDEX('%[^0-9]%',REPLACE([C].[Tel2],' ',''))=0 THEN LEN(REPLACE([C].[Tel2],' ','')) ELSE PATINDEX('%[^0-9]%',REPLACE([C].[Tel2],' ',''))-1 END) AS [Client Telephone2]
	,NULL AS [Payment Plan] -- Update below
	,[C].[Email] AS [Email]
	,[P].[Cust_class] AS [Classification]
	,NULL AS [Occupation] -- Update below
	,NULL AS [ContinuousCardAuthority] -- Update below
	,[TW1].[Use]
FROM
	[dbo].[ic_brpolicy] AS [P]
	INNER JOIN [NBRENTran] ON [P].[PolRef@] = [NBRENTran].[PolRef@]
						   AND [P].[B@] = [NBRENTran].[B@]
	LEFT JOIN [dbo].[ic_yyclient] AS [C] ON [P].[Ref@] = [C].[Ref@] AND [P].[B@] = [C].[B@]
	LEFT JOIN [dbo].[ic_BD_TW1] AS [TW1] ON [P].[PolRef@] = [TW1].[PolRef@] AND [P].[B@] = [TW1].[B@]
	LEFT JOIN [dbo].[ic_BD_CF] AS [CF] ON [P].[PolRef@] = [CF].[PolRef@] AND [P].[B@] = [CF].[B@]
	LEFT JOIN [dbo].[ic_BD_WEBF] AS [WEBF] ON [P].[PolRef@] = [WEBF].[PolRef@]
										   AND [P].[B@] = [WEBF].[B@]
	LEFT JOIN [dbo].[OPENGI_Insurer_Mapping] AS [INS] ON [P].[Insco] = [INS].[OPENGI]
	LEFT JOIN [dbo].[ic_BD_WEBF] AS [WEB2] ON ([P].[Ref@] + [P].[Notes1]) = [WEB2].[PolRef@]
										   AND [P].[B@] = [WEB2].[B@]
	LEFT JOIN [dbo].[ic_brpolicy] AS [PPOL] ON [WEB2].[Polref@] = [PPOL].[Polref@]
											AND	[WEB2].[B@] = [PPOL].[B@]
	LEFT JOIN [dbo].[Branch] AS [B] ON [P].[B@] = [B].[B@]
	LEFT JOIN [dbo].[ic_brpoldesc] AS [PD] ON [P].[Ptype] = [PD].[Poltype]
										   AND [PD].[B@] = 0 -- Policy type descriptions in ic_brpoldesc all exist under branch 0 only, but added this restriction in case branch 3 records appear at some point
WHERE
	[P].[B@] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@Branch, ','))
	AND	[NBRENTran].[PolEndDate] >= @DateFrom
	AND	[NBRENTran].[PolEndDate] < @DateTo
	AND	([P].[Term_Code] IS NULL
		 OR [P].[Term_Code] IN ('Lapsed','MidTxfer','NonRnwbl','Transf-d')
		 OR ([P].[Term_Code] = 'Canc-led' AND [P].[Term_date] >= [NBRENTran].[PolEndDate]) -- Show cancelled policies if cancelled after they were due
		 )
;


-- Add Previous year financials:

WITH [LinkedCharge] AS
(
	SELECT
		 [BL].[PolRef@]
		,[BL].[B@]
		,[BL].[Suffix]
		,[BL].[CCODE]
		,[CCODE].[CCDescription]
		,SUM([Orig_debt]) AS [Orig_debt]
		,SUM(CASE [CCode] WHEN 7 THEN [Orig_debt] ELSE 0 END) AS [CommClawback]
	FROM
		[dbo].[ic_brcledger] AS [BL]
		LEFT JOIN [dbo].[CCODE] ON [BL].[Ccode] = [CCODE].[CCodes]
	GROUP BY
		 [BL].[PolRef@]
		,[BL].[B@]
		,[BL].[Suffix]
		,[BL].[CCODE]
		,[CCODE].[CCDescription]
)
UPDATE [TMP]
SET  [PreviousGWP] = [TRAN].[PremiumIncIPT] - [TRAN].[IPT]
	,[PreviousCommission] = [TRAN].[BrokerCommission]
	,[PreviousFee] = [TRAN].[FeeExclDiscount]
	,[PreviousDiscount] = [TRAN].[Discount]
	,[PreviousDDIncome] = [TRAN].[DDIncome]
	,[PreviousIncomeExcDD] = [TRAN].[BrokerCommission] + [TRAN].[FeeExclDiscount] + [TRAN].[Discount]
	,[PreviousIncomeIncDD] = [TRAN].[BrokerCommission] + [TRAN].[FeeExclDiscount] + [TRAN].[Discount] + [TRAN].[DDIncome]
FROM
	[#RenewalsDue] AS [TMP]
	CROSS APPLY (SELECT -- Logic from MH_POLICY_FINANCIAL_VIEW but performs much faster than using the view:
					 SUM(CASE
							WHEN [BL].[Trantype] in ('New Business','Renewal','Transfrd NB','Cancellation','Endorsement','Adjustment') THEN [BL].[Orig_debt]
							ELSE 0
						END
						) AS [PremiumIncIPT]
					,SUM(CASE
							WHEN [BL].[Trantype] in ('New Business','Renewal','Transfrd NB','Cancellation','Endorsement','Adjustment') THEN [BL].[Ipt_amount]
							ELSE 0
						END) AS [IPT]
					,SUM([BL].[Comm_amt]) AS [BrokerCommission]
					,SUM(CASE
							WHEN [BL].[Trantype] IN ('New Business','Renewal','Transfrd NB','Cancellation','Endorsement','Adjustment') THEN ISNULL([LC].[Orig_debt], 0)
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInFeeCalculation] = 1 THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						 END) AS [FeeExclDiscount]
					,SUM(CASE
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInDiscountCalculation] = 1 THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						END) AS [Discount]
					,SUM(CASE
							WHEN [BL].[Trantype] IN ('Renewal', 'Transfrd NB', 'New Business')
							AND ([BL].[Pf_transmit_dt] IS NOT NULL -- This seems to be equivalent to the value of 'F' shown in a column with no name in front end OpenGI which indicates Direct Debit
								 OR [BL].[Paymethod] IN ('B', 'P') -- Bank credit, Close automated payment
								 )
								THEN [dbo].[svfMoorhouseDDIncome]([BL].[Dt_raised], [BFD].[Credit Charge], [BL].[Orig_debt], 0, ISNULL([LC].[Orig_debt], 0))
							ELSE 0
						 END) AS [DDIncome]
				 FROM
					[dbo].[ic_brcledger] AS [BL]
					LEFT JOIN [dbo].[CCODE] AS [CC] ON [BL].[CCode] = [CC].[CCodes]
					LEFT JOIN [LinkedCharge] AS [LC] ON [BL].[PolRef@] = [LC].[PolRef@]
									AND [BL].[B@] = [LC].[B@]
						 			AND [BL].[Chg_Ptr] = [LC].[Suffix]
					OUTER APPLY (SELECT
									 SUM([BFD].[P_Deposit]) AS [Deposit]
									,SUM([BFD].[P_Interest]) AS [Credit Charge]
									,SUM([BFD].[P_Apr]) AS [APR Charge]
								 FROM 
									[dbo].[ic_BD_BFD] AS [BFD]
								 WHERE 
									[BL].[PolRef@] = [BFD].[PolRef@]
									AND [BL].[B@] = [BFD].[B@]
									AND [BL].[Suffix] = [BFD].[Key_suffix]
								 ) AS [BFD]
				 WHERE
					[BL].[Polref@] = [TMP].[PreviousPolref@]
					AND [BL].[B@] = [TMP].[B@]
					AND [BL].[Dt_raised] >= [TMP].[PreviousPolEffectiveDate]
					AND [BL].[Dt_raised] < [TMP].[PreviousPolEndDate]
					AND ([BL].Chg_ptr = '-1' OR [BL].[Trantype] IN ('New Business','Renewal','Transfrd NB','Cancellation','Endorsement','Adjustment'))
				) AS [TRAN]
;


-- =====================
-- MATCH TO NEW POLICIES
-- =====================

-- Creates a temp table and inserts all potential renewal matches before selecting the best match. This is to handle scenarios where multiple renewal or replacement
-- policies have been created and cancelled.

IF OBJECT_ID(N'tempdb.dbo.#MatchRenewals') IS NOT NULL
	DROP TABLE [#MatchRenewals];

CREATE TABLE [#MatchRenewals] (
	 [B@] int
	,[PreviousRef@] char(10)
	,[PreviousPolRef@] char(10)
	,[New Policy Match Type] int
	,[NewRef@] varchar(6)
	,[NewPolRef@] varchar(10)
	,[NewPType] varchar(2)
	,[NewInsurer] varchar(255)
	,[NewPolEffectiveDate] datetime
	,[NewPolEndDate] datetime
	,[NewTerm_Code] varchar(8)
	,[NewTerm_Date] datetime
	,[NewVehicleReg] varchar(10)
	,[Outside of renewal window] bit
	,[Renewal replacement] bit
);

WITH [NBRENTran] AS
(
	SELECT
		 [BL].[B@]
		,[BL].[Ref@]
		,[BL].[PolRef@]
		,[BL].[Dt_raised]
		,[BL].[DateCreated]
		,DATEADD(yy,1,DATEADD(day, -1, [Dt_raised])) AS [PolEndDate]
		,[BL].[Poltype]
		,CASE 
			WHEN [INS].[TGSL] IS NULL THEN [P].[Insco]
			ELSE [INS].[TGSL]
		 END AS [NewInsurer]
		,[P].[Term_Code]
		,ISNULL([TW1].[Reg_mark], [CF].[Reg]) AS [VehicleReg]
		,[C].[Title]
		,[C].[Forenames]
		,[C].[DOB]
	FROM
		[dbo].[ic_brcledger] AS [BL]
		INNER JOIN [dbo].[ic_brpolicy] AS [P] ON [BL].[Polref@] = [P].[Polref@] AND [BL].[B@] = [P].[B@]
		LEFT JOIN [dbo].[ic_yyclient] AS [C] ON [P].[Ref@] = [C].[Ref@] AND [P].[B@] = [C].[B@]
		LEFT JOIN [dbo].[ic_BD_TW1] AS [TW1] ON [P].[PolRef@] = [TW1].[PolRef@] AND [P].[B@] = [TW1].[B@]
		LEFT JOIN [dbo].[ic_BD_CF] AS [CF] ON [P].[PolRef@] = [CF].[PolRef@] AND [P].[B@] = [CF].[B@]
		LEFT JOIN [dbo].[OPENGI_Insurer_Mapping] AS [INS] ON [P].[Insco] = [INS].[OPENGI]
	WHERE
		[TranType] IN ('New Business','Renewal','Transfrd NB')
)
INSERT INTO [#MatchRenewals] (
	 [B@]
	,[PreviousRef@]
	,[PreviousPolRef@]
	,[New Policy Match Type]
	,[NewRef@]
	,[NewPolRef@]
	,[NewPType]
	,[NewInsurer]
	,[NewPolEffectiveDate]
	,[NewPolEndDate]
	,[NewTerm_Code]
	,[NewVehicleReg]
	,[Outside of renewal window]
)
-- 1. Renewed on same Policy ref, i.e. number not incremented (happens when no changes made to the policy):
SELECT
	 [TMP].[B@]
	,[TMP].[PreviousRef@]
	,[TMP].[PreviousPolRef@]
	,1 AS [New Policy Match Type]
	,[NBRENTran].[Ref@]AS [NewRef@]
	,[NBRENTran].[PolRef@] AS [NewPolRef@]
	,[NBRENTran].[Poltype] AS [NewPType]
	,[NBRENTran].[NewInsurer] AS [NewInsurer]
	,[NBRENTran].[Dt_raised] AS [NewPolEffectiveDate]
	,[NBRENTran].[PolEndDate] AS [NewPolEndDate]
	,[NBRENTran].[Term_Code] AS [NewTerm_Code]
	,[NBRENTran].[VehicleReg] AS [NewVehicleReg]
	,CASE WHEN [NBRENTran].[Dt_raised] > DATEADD(dd, 30, [TMP].[PreviousPolEndDate]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [NBRENTran] ON [TMP].[PreviousPolRef@] = [NBRENTran].[PolRef@]
							AND [TMP].[B@] = [NBRENTran].[B@]
							AND	[NBRENTran].[Dt_raised] >= DATEADD(d, -30, [TMP].[PreviousPolEndDate])
							AND	[NBRENTran].[PolEndDate] <= DATEADD(d, 30, DATEADD(yy, 1, [TMP].[PreviousPolEndDate]))

-- 2. Renewed on different Policy ref for same vehicle reg (some clients have multiple policies for different vehicles so need to match to the correct one):

UNION ALL

SELECT
	 [TMP].[B@]
	,[TMP].[PreviousRef@]
	,[TMP].[PreviousPolRef@]
	,2 AS [New Policy Match Type]
	,[NBRENTran].[Ref@]AS [NewRef@]
	,[NBRENTran].[PolRef@] AS [NewPolRef@]
	,[NBRENTran].[Poltype] AS [NewPType]
	,[NBRENTran].[NewInsurer] AS [NewInsurer]
	,[NBRENTran].[Dt_raised] AS [NewPolEffectiveDate]
	,[NBRENTran].[PolEndDate] AS [NewPolEndDate]
	,[NBRENTran].[Term_Code] AS [NewTerm_Code]
	,[NBRENTran].[VehicleReg] AS [NewVehicleReg]
	,CASE WHEN [NBRENTran].[Dt_raised] > DATEADD(dd, 30, [TMP].[PreviousPolEndDate]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [NBRENTran] ON [TMP].[PreviousRef@] = [NBRENTran].[Ref@]
							AND [TMP].[B@] = [NBRENTran].[B@]
							AND	[NBRENTran].[Dt_raised] >= DATEADD(d, -30, [TMP].[PreviousPolEndDate])
							AND	[NBRENTran].[PolEndDate] <= DATEADD(d, 30, DATEADD(yy, 1, [TMP].[PreviousPolEndDate]))
							AND	[TMP].[PreviousPType] = [NBRENTran].[Poltype]
							AND [TMP].[PreviousVehicleReg] = [NBRENTran].[VehicleReg]

-- 3. Renewed same vehicle reg on different Client Ref and Policy ref:

UNION ALL

SELECT
	 [TMP].[B@]
	,[TMP].[PreviousRef@]
	,[TMP].[PreviousPolRef@]
	,2 AS [New Policy Match Type]
	,[NBRENTran].[Ref@]AS [NewRef@]
	,[NBRENTran].[PolRef@] AS [NewPolRef@]
	,[NBRENTran].[Poltype] AS [NewPType]
	,[NBRENTran].[NewInsurer] AS [NewInsurer]
	,[NBRENTran].[Dt_raised] AS [NewPolEffectiveDate]
	,[NBRENTran].[PolEndDate] AS [NewPolEndDate]
	,[NBRENTran].[Term_Code] AS [NewTerm_Code]
	,[NBRENTran].[VehicleReg] AS [NewVehicleReg]
	,CASE WHEN [NBRENTran].[Dt_raised] > DATEADD(dd, 30, [TMP].[PreviousPolEndDate]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [NBRENTran] ON [TMP].[PreviousVehicleReg] = [NBRENTran].[VehicleReg]
						    AND [TMP].[Client Title] = [NBRENTran].[Title]
							AND [TMP].[Client Forenames] = [NBRENTran].[Forenames]
							AND [TMP].[Client DOB] = [NBRENTran].[DOB]
							AND NOT ([TMP].[B@] = [NBRENTran].[B@] AND [TMP].[PreviousRef@] = [NBRENTran].[Ref@])
							AND [NBRENTran].[Dt_raised] >= DATEADD(d, -30, [TMP].[PreviousPolEndDate])
							AND	[NBRENTran].[PolEndDate] <= DATEADD(d, 30, DATEADD(yy, 1, [TMP].[PreviousPolEndDate]))
							AND	[TMP].[PreviousPType] = [NBRENTran].[Poltype]

-- 4. Renewed on different Policy ref and vehicle reg changed:

UNION ALL

SELECT
	 [TMP].[B@]
	,[TMP].[PreviousRef@]
	,[TMP].[PreviousPolRef@]
	,2 AS [New Policy Match Type]
	,[NBRENTran].[Ref@]AS [NewRef@]
	,[NBRENTran].[PolRef@] AS [NewPolRef@]
	,[NBRENTran].[Poltype] AS [NewPType]
	,[NBRENTran].[NewInsurer] AS [NewInsurer]
	,[NBRENTran].[Dt_raised] AS [NewPolEffectiveDate]
	,[NBRENTran].[PolEndDate] AS [NewPolEndDate]
	,[NBRENTran].[Term_Code] AS [NewTerm_Code]
	,[NBRENTran].[VehicleReg] AS [NewVehicleReg]
	,CASE WHEN [NBRENTran].[Dt_raised] > DATEADD(dd, 30, [TMP].[PreviousPolEndDate]) THEN 1 ELSE 0 END AS [Outside of renewal window] -- If more than 30 days after the due policy it's not a renewal, unless cancelled and replaced (updated later)
FROM
	[#RenewalsDue] AS [TMP]
	INNER JOIN [NBRENTran] ON [TMP].[PreviousRef@] = [NBRENTran].[Ref@]
							AND [TMP].[B@] = [NBRENTran].[B@]
							AND	[NBRENTran].[Dt_raised] >= DATEADD(d, -30, [TMP].[PreviousPolEndDate])
							AND	[NBRENTran].[PolEndDate] <= DATEADD(d, 30, DATEADD(yy, 1, [TMP].[PreviousPolEndDate]))
							AND	[TMP].[PreviousPType] = [NBRENTran].[Poltype]
	LEFT JOIN [NBRENTran] AS [PREV] ON [TMP].[PreviousRef@] = [PREV].[Ref@]
									AND [TMP].[B@] = [PREV].[B@]
									AND	[PREV].[PolEndDate] < [NBRENTran].[Dt_raised]
									AND	[TMP].[PreviousPType] = [PREV].[Poltype]
									AND [NBRENTran].[VehicleReg] = [PREV].[VehicleReg]
WHERE
	[TMP].[PreviousVehicleReg] <> [NBRENTran].[VehicleReg]
	AND [PREV].[Polref@] IS NULL -- Don't match if the new vehicle reg appears on an earlier policy as that would be a client with multiple policies and would need to match the correct vehicle in step 2 above
;


-- Set Renewal Replacement = true for matched policies that are outside of the renewal window but are within 30 days of a cancellation:

UPDATE [MRRep]
	SET [Renewal replacement] = 1
FROM
	[#MatchRenewals] AS [MRCanx]
	INNER JOIN [#MatchRenewals] AS [MRRep] ON [MRCanx].[PreviousRef@] = [MRRep].[PreviousRef@] AND [MRCanx].[NewPType] = [MRRep].[NewPType]
										   AND [MRCanx].[Outside of renewal window] = 0
										   AND [MRCanx].[NewTerm_Code] = 'Canc-led'
										   AND [MRRep].[Outside of renewal window] = 1
										   AND [MRRep].[NewPolEffectiveDate] < DATEADD(dd, 30, [MRCanx].[NewTerm_Date])
;

WITH [MatchedRenewal] AS
(
	SELECT
		 ROW_NUMBER() OVER (PARTITION BY [B@] ,[PreviousPolRef@] ORDER BY CASE
																			WHEN [NewTerm_Code] IS NULL THEN 1
																			ELSE 99
																		 END
																		,[New Policy Match Type]
																		,[NewPolEffectiveDate] DESC) AS [RowNum]
		,[B@]
		,[PreviousPolRef@]
		,[New Policy Match Type]
		,[NewRef@]
		,[NewPolRef@]
		,[NewPType]
		,[NewInsurer]
		,[NewPolEffectiveDate]
		,[NewPolEndDate]
		,[NewTerm_Code]
		,[NewVehicleReg]
	FROM
		[#MatchRenewals]
	WHERE
		[Outside of renewal window] = 0
		OR ([Outside of renewal window] = 1 AND [Renewal replacement] = 1)
)
UPDATE [TMP]
SET
	 [New Policy Match Type] = [MR].[New Policy Match Type]
	,[NewRef@] = [MR].[NewRef@]
	,[NewPolRef@] = [MR].[NewPolref@]
	,[NewPType] = [MR].[NewPType]
	,[NewInsurer] = [MR].[NewInsurer]
	,[NewPolEffectiveDate] = [MR].[NewPolEffectiveDate]
	,[NewPolEndDate] = [MR].[NewPolEndDate]
	,[NewTerm_Code] = [MR].[NewTerm_Code]
	,[NewVehicleReg] = [MR].[NewVehicleReg]
	,[Status] = CASE
					WHEN [MR].[New Policy Match Type] IS NOT NULL AND ISNULL([TMP].[PreviousTerm_Code], '') <> 'Canc-led' AND [MR].[NewTerm_Code] IS NULL THEN 'Renewed' -- Match to a renewal that has not subsequently terminated
					WHEN [TMP].[PreviousTerm_Code] IS NULL THEN 'Outstanding/Invited' -- Expiring / due policy not yet terminated
					WHEN [MR].[NewTerm_Code] IS NOT NULL THEN [MR].[NewTerm_Code] -- Match to a renewal that has subsequently terminated so show the term code from the renewal
					ELSE [TMP].[PreviousTerm_Code] -- Otherwise show term code of the expiring / due policy
				END
FROM
	[#RenewalsDue] AS [TMP]
	LEFT JOIN [MatchedRenewal] AS [MR] ON [TMP].[B@] = [MR].[B@] AND [TMP].[PreviousPolRef@] = [MR].[PreviousPolRef@]
										AND [MR].[RowNum] = 1
;


-- Add renewal financials:

WITH [LinkedCharge] AS
(
	SELECT
		 [BL].[PolRef@]
		,[BL].[B@]
		,[BL].[Suffix]
		,[BL].[CCODE]
		,[CCODE].[CCDescription]
		,SUM([Orig_debt]) AS [Orig_debt]
		,SUM(CASE [CCode] WHEN 7 THEN [Orig_debt] ELSE 0 END) AS [CommClawback]
	FROM
		[dbo].[ic_brcledger] AS [BL]
		LEFT JOIN [dbo].[CCODE] ON [BL].[Ccode] = [CCODE].[CCodes]
	GROUP BY
		 [BL].[PolRef@]
		,[BL].[B@]
		,[BL].[Suffix]
		,[BL].[CCODE]
		,[CCODE].[CCDescription]
)
UPDATE [TMP]
SET  [NewGWP] = [TRAN].[PremiumIncIPT] - [TRAN].[IPT]
	,[NewCommission] = [TRAN].[BrokerCommission]
	,[NewFee] = CASE WHEN ISNULL([NewTerm_Code], '') = 'Canc-led' THEN [TRAN].[FeeExclDiscountExcReversals] ELSE [TRAN].[FeeExclDiscount] END -- Reversal charge types need to be excluded if renewed policy is cancelled because we want to show the invited amount before cancellation
	,[NewDiscount] = CASE WHEN ISNULL([NewTerm_Code], '') = 'Canc-led' THEN [TRAN].[DiscountExcReversals] ELSE [TRAN].[Discount] END -- Reversal charge types need to be excluded if renewed policy is cancelled because we want to show the invited amount before cancellation
	,[NewDDIncome] = [TRAN].[DDIncome]
FROM
	[#RenewalsDue] AS [TMP]
	CROSS APPLY (SELECT -- Logic from MH_POLICY_FINANCIAL_VIEW but performs much faster than using the view:
					SUM(CASE
							WHEN [BL].[Trantype] in ('New Business','Renewal','Transfrd NB','Endorsement','Adjustment') THEN [BL].[Orig_debt]
							ELSE 0
						END
						) AS [PremiumIncIPT]
					,SUM(CASE
							WHEN [BL].[Trantype] in ('New Business','Renewal','Transfrd NB','Endorsement','Adjustment') THEN [BL].[Ipt_amount]
							ELSE 0
						END) AS [IPT]
					,SUM([BL].[Comm_amt]) AS [BrokerCommission]
					,SUM(CASE
							WHEN [BL].[Trantype] IN ('New Business','Renewal','Transfrd NB','Endorsement','Adjustment') THEN ISNULL([LC].[Orig_debt], 0)
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInFeeCalculation] = 1 THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						 END) AS [FeeExclDiscount]
					,SUM(CASE
							WHEN [BL].[Trantype] IN ('New Business','Renewal','Transfrd NB','Endorsement','Adjustment') THEN ISNULL([LC].[Orig_debt], 0)
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInFeeCalculation] = 1 AND [CC].[CCDescription] <> 'Removal of Renewal Fee' -- This charge type needs to be excluded if renewed policy is cancelled because we want to show the invited amount before cancellation
								THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						 END) AS [FeeExclDiscountExcReversals]
					,SUM(CASE
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInDiscountCalculation] = 1
								THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						END) AS [Discount]
					,SUM(CASE
							WHEN [BL].[Trantype] in ('Charge') AND [CC].[IncludeInDiscountCalculation] = 1
								AND [CC].[CCDescription] NOT IN ('Reversal of NB Discount', 'Reversal of Rnl Discount') -- These charge types need to be excluded if renewed policy is cancelled because we want to show the invited amount before cancellation
								THEN ISNULL([BL].[Orig_debt], 0)
							ELSE 0
						END) AS [DiscountExcReversals]
					,SUM(CASE
							WHEN [BL].[Trantype] IN ('Renewal', 'Transfrd NB', 'New Business')
							AND ([BL].[Pf_transmit_dt] IS NOT NULL -- This seems to be equivalent to the value of 'F' shown in a column with no name in front end OpenGI which indicates Direct Debit
								 OR [BL].[Paymethod] IN ('B', 'P') -- Bank credit, Close automated payment
								 )
								THEN [dbo].[svfMoorhouseDDIncome]([BL].[Dt_raised], [BFD].[Credit Charge], [BL].[Orig_debt], 0, ISNULL([LC].[Orig_debt], 0))
							ELSE 0
						 END) AS [DDIncome]
				 FROM
					[dbo].[ic_brcledger] AS [BL]
					LEFT JOIN [dbo].[CCODE] AS [CC] ON [BL].[CCode] = [CC].[CCodes]
					LEFT JOIN [LinkedCharge] AS [LC] ON [BL].[PolRef@] = [LC].[PolRef@]
									AND [BL].[B@] = [LC].[B@]
						 			AND [BL].[Chg_Ptr] = [LC].[Suffix]
					OUTER APPLY (SELECT
									 SUM([BFD].[P_Deposit]) AS [Deposit]
									,SUM([BFD].[P_Interest]) AS [Credit Charge]
									,SUM([BFD].[P_Apr]) AS [APR Charge]
								 FROM 
									[dbo].[ic_BD_BFD] AS [BFD]
								 WHERE 
									[BL].[PolRef@] = [BFD].[PolRef@]
									AND [BL].[B@] = [BFD].[B@]
									AND [BL].[Suffix] = [BFD].[Key_suffix]
								 ) AS [BFD]
				 WHERE
					[BL].[Polref@] = [TMP].[NewPolref@]
					AND [BL].[B@] = [TMP].[B@]
					AND [BL].[Dt_raised] >= DATEADD(mm, -1, [TMP].[NewPolEffectiveDate]) -- Look at transactions from a month before the new effective date, as renewal discounts are created in advance
					AND [BL].[Dt_raised] < [TMP].[NewPolEndDate]
					AND ([BL].Chg_ptr = '-1' OR [BL].[Trantype] IN ('New Business','Renewal','Transfrd NB','Endorsement','Adjustment'))
				) AS [TRAN]
;

UPDATE [#RenewalsDue]
SET  [NewIncomeExcDD] = [NewCommission] + [NewFee] + [NewDiscount]
	,[NewIncomeIncDD] = [NewCommission] + [NewFee] + [NewDiscount] + [NewDDIncome]
FROM
	[#RenewalsDue] AS [TMP]
;


-- ==========================================================
-- POPULATE ADDITIONAL FIELDS FROM MATCHED OR ORIGINAL POLICY
-- ==========================================================

UPDATE [TMP]
SET  [Classification] = ISNULL([PNew].[Cust_class], [PCurr].[Cust_class])
	,[Payment Plan] = CASE
						WHEN [BFBNew].[PolRef@] IS NOT NULL THEN 'Premium Finance'
						WHEN [PNew].[PolRef@] IS NOT NULL AND [BFBNew].[PolRef@] IS NULL THEN 'Premium Finance'
						WHEN [BFBCurr].[PolRef@] IS NOT NULL THEN 'Premium Finance'
						ELSE 'Payment in Full'
					  END
	,[Occupation] = [D].[Occupation1]
	,[ContinuousCardAuthority] = ISNULL([DCNew].[Ca_approved], [DCCUrr].[Ca_approved])
FROM
	[#RenewalsDue] AS [TMP]
		LEFT JOIN [dbo].[ic_brpolicy] AS [PCurr] ON [TMP].[PreviousPolRef@] = [PCurr].[Polref@] AND [TMP].[B@] = [PCurr].[B@]
			LEFT JOIN [dbo].[ic_BD_BFB] AS [BFBCurr] ON [PCurr].[Polref@] = [BFBCurr].[PolRef@] AND [PCurr].[B@] = [BFBCurr].[B@]
			LEFT JOIN [dbo].[ic_BD_DC] AS [DCCurr] ON [PCurr].[PolRef@] = [DCCurr].[PolRef@] AND [PCurr].[B@] = [DCCurr].[B@]
		LEFT JOIN [dbo].[ic_brpolicy] AS [PNew] ON [TMP].[NewPolRef@] = [PNew].[Polref@] AND [TMP].[B@] = [PNew].[B@]
			LEFT JOIN [dbo].[ic_BD_BFB] AS [BFBNew] ON [PNew].[Polref@] = [BFBNew].[PolRef@] AND [PNew].[B@] = [BFBNew].[B@]
			LEFT JOIN [dbo].[ic_BD_DC] AS [DCNew] ON [PNew].[PolRef@] = [DCNew].[PolRef@] AND [PNew].[B@] = [DCNew].[B@]
		OUTER APPLY	(SELECT TOP 1 [Occupation1]
					 FROM [dbo].[MH_RISK_DRIVER_VIEW]
					 WHERE ([Polref@] = [PCurr].[Polref@] OR [Polref@] = [PNew].[Polref@]) AND [B@] = [TMP].[B@]
 					 ORDER BY CASE WHEN [Occupation1] IS NOT NULL THEN 1 ELSE 2 END -- There can be multiple driver records. Prioritise populated Occupation1 as this is the field being selected
						,CASE WHEN [DriverNumber] = 'Main' THEN 1 ELSE 2 END
						,CASE WHEN [Polref@] = [PNew].[Polref@] THEN 1 ELSE 2 END
					) AS [D]
;


-- ==================
-- RETURN REPORT DATA
-- ==================

SELECT * FROM [#RenewalsDue]
ORDER BY [PreviousPolRef@]
;
