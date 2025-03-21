USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[SP_ACC_GETSUMMARYVALUES]    Script Date: 21/01/2025 09:05:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[SP_ACC_GETSUMMARYVALUES]

--Author	:	Brian Hearn
--Date		:	16/05/2003
--Purpose	:	Calculates the summary values (o/s balance etc..) for the client
--			account specified
--Amendments	:	BH 08/07/2003 - Updated to work with policy accounts
--			SP 09/03/2004 - Final four values added for premium and earnings.
--			BH 26/03/2004 - Added portfoliokey check to current period
--			BH 01/04/2004 - Fixed earnings to work on client accounts
--			IS 05/11/2004 - Removed journal entries from premium statistics
--			BH 25/11/2004 - Included journal entries to insurer account in premium.
--					Included journal entries to income account in earnings 
--					(immediately, unlike all other earnings that use pay as paid)
--			BH 10/12/2004 - Replaced joins to views because they were slow for no apparent reason
--			IB 13/11/2008 - Added new date calculation logic for finance plans as part of ADR04_C072
--			PWB 01/06/2015 TGS\68565 - Amended outstanding balance queries due to performance issues. Please see notes within SP

@PolicyAccount			bit,
@ID				char(32)
AS

SET NOCOUNT ON

DECLARE @CurrentBalanceDue	money
DECLARE @TotalBalanceDue	money
DECLARE @CurrentYear 		int
DECLARE @Portfoliokey 		int
DECLARE @PremiumYTD		money
DECLARE @PremiumLastYear	money
DECLARE @JRNPremiumYTD		money
DECLARE @JRNPremiumLastYear	money
DECLARE @EarningsYTD		money
DECLARE @EarningsLastYear	money
DECLARE @JrnEarningsYTD		money
DECLARE @JrnEarningsLastYear	money
DECLARE @TargetDate		datetime
DECLARE @IgnoreOutstandingFinancePayments bit
DECLARE @Temp char(17)

DECLARE @SystemDate 		datetime
DECLARE @TableDate		VarChar(24)
DECLARE @Offset 		int

--Get the date & offset from System_Data
SELECT @SystemDate = System_Date FROM System_Data
SELECT @Offset = System_Time FROM System_Data


--Grab parameter values (ADR04_C072 - see above)
IF @PolicyAccount = 1 
	SELECT 	@Portfoliokey = Portfoliokey
	FROM 	Customer_Policy_Details (NOLOCK)
	WHERE 	Policy_Details_ID = @ID
ELSE
	SELECT 	@Portfoliokey = Portfoliokey
	FROM 	Customer_Insured_Party (NOLOCK)
	WHERE 	Insured_Party_ID = @ID

Select @IgnoreOutstandingFinancePayments = [Value] From RM_Partner_Parameter Where [Parameter_Name] = 'IgnoreOutstandingFinancePayments' And Portfoliokey = @Portfoliokey


--If there's nothing there default server date
SELECT @Offset = IsNull(@Offset, 0)
SELECT @TableDate = Convert(VarChar(10), IsNull(@SystemDate, GetDate()), 101) + ' ' + Convert(Varchar(12), GetDate(), 114)

SELECT @SystemDate =
	CASE (SELECT UPPER(Status) FROM System_Version_Number)
		WHEN 'TEST' THEN DateAdd(minute, @Offset, @TableDate)
		ELSE GetDate()
	END

/*****************************/
/* Current Balance Due and   */
/* Total Outstanding Balance */
/*****************************/

--Get the sum of the due payable transactions
--IB 13/11/2008 - ADR04_C072 - change the basis for this calculation when the parameter IgnoreOutstandingFinancePayments is set

/*
** PWB 01/06/2015 TGS\68565 - SP was sometimes taking 40 minutes or more to complete.
** Replaced with If statements as couldn't find a logical reason why this was taking so long.
** Left original queries in but commented out in case anyone can see a sensible reason why it was taking so long. (Query looked fine to me).
*/

If @IgnoreOutstandingFinancePayments = 1 
Begin 
	--(ADR04_C072 - see above)
	IF @PolicyAccount = 1
	BEGIN

		SELECT @CurrentBalanceDue =
					Case Upper(RPP.IntervalPeriod)
							When 'F' Then Sum(CASE WHEN dbo.GET_FUTURE_FINANCE_DATE_RANGE(PaymentDate) <= @SystemDate THEN ACV.Outstanding ELSE 0 END) --IF this IS finance then use previous date instead
							Else Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END)
					End,
			@TotalBalanceDue = Sum(ACV.Outstanding)
		FROM 
			Accounts_Client_View ACV (NOLOCK)
				Inner Join RM_Payment_PLan RPP (NOLOCK)
					On ACV.Payment_Plan_ID = RPP.Payment_Plan_ID
		WHERE
			Outstanding <> 0
			AND Policy_Details_ID = @ID
		Group By RPP.IntervalPeriod

	END
	ELSE
	BEGIN
	
		SELECT @CurrentBalanceDue =
					Case Upper(RPP.IntervalPeriod)
							When 'F' Then Sum(CASE WHEN dbo.GET_FUTURE_FINANCE_DATE_RANGE(PaymentDate) <= @SystemDate THEN ACV.Outstanding ELSE 0 END) --IF this IS finance then use previous date instead
							Else Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END)
					End,
			@TotalBalanceDue = Sum(ACV.Outstanding)
		FROM 
			Accounts_Client_View ACV (NOLOCK)
				Inner Join RM_Payment_PLan RPP (NOLOCK)
					On ACV.Payment_Plan_ID = RPP.Payment_Plan_ID
		WHERE
			Outstanding <> 0
			AND Insured_Party_ID = @ID
		Group By RPP.IntervalPeriod

	END

	/* Original Query */
	/*
	SELECT @CurrentBalanceDue =
					Case Upper(RPP.IntervalPeriod)
							When 'F' Then Sum(CASE WHEN dbo.GET_FUTURE_FINANCE_DATE_RANGE(PaymentDate) <= @SystemDate THEN ACV.Outstanding ELSE 0 END) --IF this IS finance then use previous date instead
							Else Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END)
					End,
			@TotalBalanceDue = Sum(ACV.Outstanding)
		FROM 
			Accounts_Client_View ACV (NOLOCK)
				Inner Join RM_Payment_PLan RPP (NOLOCK)
					On ACV.Payment_Plan_ID = RPP.Payment_Plan_ID
		WHERE
			Outstanding <> 0
			AND (
				(Insured_Party_ID = @ID AND @PolicyAccount = 0)
				OR
				(Policy_Details_ID = @ID AND @PolicyAccount = 1)
				) 
		Group By RPP.IntervalPeriod
	*/

End
Else
Begin --Do it the way it was done before this RFC (ADR04_C072)

	IF @PolicyAccount = 1
	BEGIN
		
		SELECT
			@CurrentBalanceDue = Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END),
			@TotalBalanceDue = Sum(ACV.Outstanding) FROM  Accounts_Client_View ACV (NOLOCK)
		WHERE Outstanding <> 0
		AND Policy_Details_ID = @ID

	END
	ELSE
	BEGIN

		SELECT
			@CurrentBalanceDue = Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END),
			@TotalBalanceDue = Sum(ACV.Outstanding) FROM  Accounts_Client_View ACV (NOLOCK)
		WHERE Outstanding <> 0
		AND Insured_Party_ID = @ID

	END

	/* Original Query */
	/*
	SELECT 
		@CurrentBalanceDue = Sum(CASE WHEN PaymentDate <= @SystemDate THEN ACV.Outstanding ELSE 0 END), 
		@TotalBalanceDue = Sum(ACV.Outstanding)
	FROM 
		Accounts_Client_View ACV (NOLOCK)
	WHERE
		Outstanding <> 0
		AND (
			(Insured_Party_ID = @ID AND @PolicyAccount = 0)
			OR
			(Policy_Details_ID = @ID AND @PolicyAccount = 1)
			)
	*/

End

/************************/
/* Get the current year */
/************************/

/* MOVED THIS BIT TO THE TOP TO USE IT EARLIER IN THE CALCULATIONS (ADR04_C072)
IF @PolicyAccount = 1 
	SELECT 	@Portfoliokey = Portfoliokey
	FROM 	Customer_Policy_Details (NOLOCK)
	WHERE 	Policy_Details_ID = @ID
ELSE
	SELECT 	@Portfoliokey = Portfoliokey
	FROM 	Customer_Insured_Party (NOLOCK)
	WHERE 	Insured_Party_ID = @ID*/

SELECT 	@CurrentYear = [Year]
FROM	System_Accounts_Period
WHERE	Account_Current = 1
AND 	Portfoliokey = @Portfoliokey

/************************/
/* Premium Year To Date */
/************************/

--Client Postings
SELECT	

	@PremiumYTD = SUM(CASE SAP.[Year] WHEN @CurrentYear THEN 
				IsNull(CASE ATB.TRAN_BREAKDOWN_TYPE_ID 
							WHEN 'BRKCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'BRKCOMMF' THEN ATB.AMOUNT * -1
							WHEN 'AGECOMMP' THEN ATB.AMOUNT * -1
							WHEN 'AGECOMMF' THEN ATB.AMOUNT * -1
							WHEN 'SUBCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'SUBCOMMF' THEN ATB.AMOUNT * -1
							WHEN 'INTCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'INTCOMMF' THEN ATB.AMOUNT * -1
							ELSE ATB.AMOUNT 
						    END, 0) ELSE 0 END),
	@PremiumLastYear = SUM(CASE SAP.[Year] WHEN @CurrentYear - 1 THEN 
				IsNull(CASE ATB.TRAN_BREAKDOWN_TYPE_ID 
							WHEN 'BRKCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'BRKCOMMF' THEN ATB.AMOUNT * -1
							WHEN 'AGECOMMP' THEN ATB.AMOUNT * -1
							WHEN 'AGECOMMF' THEN ATB.AMOUNT * -1
							WHEN 'SUBCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'SUBCOMMF' THEN ATB.AMOUNT * -1
							WHEN 'INTCOMMP' THEN ATB.AMOUNT * -1
							WHEN 'INTCOMMF' THEN ATB.AMOUNT * -1
							ELSE ATB.AMOUNT 
						    END, 0) ELSE 0 END)
FROM	
	Accounts_Client_Tran_Link ACTL (NOLOCK)

		INNER JOIN Accounts_Tran_Breakdown ATB WITH (NOLOCK)
			ON ATB.Transaction_ID = ACTL.Transaction_ID

			INNER JOIN List_Tran_Breakdown_Type LTBT WITH  (NOLOCK, INDEX = 0)
				ON ATB.Tran_Breakdown_Type_ID = LTBT.Tran_Breakdown_Type_ID
				AND LTBT.Insurer = 1 --Filter to tran breakdown types like net, ipt & commission


		INNER JOIN Accounts_Transaction AT1 (NOLOCK)
			ON ACTL.Transaction_ID = AT1.Transaction_ID

			INNER JOIN System_Accounts_Period SAP (NOLOCK)
				ON SAP.Period_ID = AT1.Period_ID
WHERE	
	(@PolicyAccount = 0 AND ACTL.Insured_Party_ID = @ID) 
	OR (@PolicyAccount = 1 AND ACTL.Policy_Details_ID = @ID)

--Remove Journal Entries to the insurer account from premium
SELECT	
	@JrnPremiumYTD = SUM(CASE SAP.[Year] WHEN @CurrentYear THEN ATB.Amount * -1 ELSE 0 END),
	@JrnPremiumLastYear = SUM(CASE SAP.[Year] WHEN @CurrentYear - 1 THEN ATB.Amount * -1 ELSE 0 END)
FROM	
	Accounts_Client_Tran_Link ACTL (NOLOCK)

		INNER JOIN Accounts_Tran_Link ATL1 (NOLOCK)
			ON ATL1.Transaction_ID = ACTL.Transaction_ID
			AND ATL1.Account_Type_ID = 'CLIENT'
			AND ATL1.Allocated = 0 

			INNER JOIN Accounts_Tran_Link ATL2 (NOLOCK)
				ON ATL1.Link_ID = ATL2.Link_ID
				AND ATL2.Account_Type_ID = 'INSURER'
				AND ATL2.Allocated = 0 

				INNER JOIN Accounts_Transaction AT1 (NOLOCK)
					ON ATL2.Transaction_ID = AT1.Transaction_ID
	
					INNER JOIN Accounts_Tran_Breakdown ATB (NOLOCK)
						ON ATB.Transaction_ID = AT1.Transaction_ID
	
					INNER JOIN System_Accounts_Period SAP (NOLOCK)
						ON SAP.Period_ID = AT1.Period_ID
WHERE	
	(@PolicyAccount = 0 AND ACTL.Insured_Party_ID = @ID) 
	OR (@PolicyAccount = 1 AND ACTL.Policy_Details_ID = @ID)



/*************************/
/* Earnings Year To Date */
/* Earnings Last Year 	 */
/*************************/

SELECT	@EarningsYTD = SUM(CASE SAP.[Year] WHEN @CurrentYear THEN ABA.Allocated ELSE 0 END) ,
	@EarningsLastYear = SUM(CASE SAP.[Year] WHEN @CurrentYear - 1 THEN ABA.Allocated ELSE 0 END) 
FROM	
	Accounts_Client_Tran_Link ACTL (NOLOCK)

		INNER JOIN Accounts_Tran_Breakdown ATB (NOLOCK)
			ON ACTL.Transaction_ID = ATB.Transaction_ID

			INNER JOIN Accounts_Breakdown_Allocation ABA (NOLOCK)
				ON ATB.Tran_Breakdown_ID = ABA.Tran_Breakdown_ID

			INNER JOIN List_Tran_Breakdown_Type LTBT (NOLOCK)
				ON ATB.Tran_Breakdown_Type_ID = LTBT.Tran_Breakdown_Type_ID

		INNER JOIN Accounts_Transaction AT1 (NOLOCK)
			ON AT1.Transaction_ID = ACTL.Transaction_ID

			INNER JOIN System_Accounts_Period SAP (NOLOCK)
				ON AT1.Period_ID = SAP.Period_ID

		
WHERE	((@PolicyAccount = 0 AND ACTL.Insured_Party_ID = @ID) OR (@PolicyAccount = 1 AND ACTL.Policy_Details_ID = @ID))
AND	(LTBT.Income = 1 OR LTBT.Tran_Breakdown_Type_ID IN ('AGECOMMF','AGECOMMP','SUBCOMMF','SUBCOMMP'))

--Remove Journal Entries to the insurer account from premium
SELECT	
	@JrnEarningsYTD = SUM(CASE SAP.[Year] WHEN @CurrentYear THEN ATB.Amount * -1 ELSE 0 END),
	@JrnEarningsLastYear = SUM(CASE SAP.[Year] WHEN @CurrentYear - 1 THEN ATB.Amount * -1 ELSE 0 END)
FROM	
	Accounts_Client_Tran_Link ACTL (NOLOCK)

		INNER JOIN Accounts_Tran_Link ATL1 (NOLOCK)
			ON ATL1.Transaction_ID = ACTL.Transaction_ID
			AND ATL1.Account_Type_ID = 'CLIENT'
			AND ATL1.Allocated = 0 

			INNER JOIN Accounts_Tran_Link ATL2 (NOLOCK)
				ON ATL1.Link_ID = ATL2.Link_ID
				AND ATL2.Account_Type_ID = 'INCOME'
				AND ATL2.Allocated = 0 

				INNER JOIN Accounts_Transaction AT1 (NOLOCK)
					ON ATL2.Transaction_ID = AT1.Transaction_ID
	
					INNER JOIN Accounts_Tran_Breakdown ATB (NOLOCK)
						ON ATB.Transaction_ID = AT1.Transaction_ID
	
					INNER JOIN System_Accounts_Period SAP (NOLOCK)
						ON SAP.Period_ID = AT1.Period_ID
WHERE	
	(@PolicyAccount = 0 AND ACTL.Insured_Party_ID = @ID) 
	OR (@PolicyAccount = 1 AND ACTL.Policy_Details_ID = @ID)

--Return all results in a row
SELECT 
	IsNull(@CurrentBalanceDue, 0) CurrentBalanceDue,
	IsNull(@TotalBalanceDue, 0) TotalBalanceDue, 
	IsNull(@PremiumYTD, 0) + IsNull(@JRNPremiumYTD, 0) PremiumYTD, 
	IsNull(@PremiumLastYear, 0) + IsNull(@JRNPremiumLastYear, 0) PremiumLastYear, 
	IsNull(@EarningsYTD, 0) + IsNull(@JRNEarningsYTD, 0) EarningsYTD, 
	IsNull(@EarningsLastYear, 0) + IsNull(@JRNEarningsLastYear, 0) EarningsLastYear
