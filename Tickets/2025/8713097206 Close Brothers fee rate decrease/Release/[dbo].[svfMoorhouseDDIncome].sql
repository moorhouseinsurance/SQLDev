USE [MI]
GO
/****** Object:  UserDefinedFunction [dbo].[svfMoorhouseDDIncome]    Script Date: 18/03/2025 08:12:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jeremai Smith
-- Create date: 21 Jun 2021
-- Description:	Calculates estimated Moorhouse income portion of Direct Debit charges by subtracting Close Brothers' fee
-- NOTE:		Identical function exists in both [MHGSQL01\INFOCENTRE].[OpenGI] and [MHGSQL01\TGSL].[MI] databases; changes should be released to both locations
-- =============================================

-- Date			Who						Change
-- 26/08/2022	Jeremai Smith			Close Brothers' fee percent now varies depending on effective date, and minimum fee is £10 (Monday ticket 3133776565)
-- 12/10/2022	Jeremai Smith			Rate increase effective 25/10/22 (Monday ticket 3363734211)
-- 17/02/2023	Jeremai Smith			Rate increase effective 07/03/23 (Monday ticket 4004151834)
-- 18/04/2023	Jeremai Smith			Rate increase effective 25/04/23 (Monday ticket 4325003897)
-- 31/05/2023	Jeremai Smith			Rate increase effective 13/06/23 (Monday ticket 4561980261)
-- 11/07/2023	Jeremai Smith			Rate increase effective 25/07/23 (Monday ticket 4787473333)
-- 16/11/2023	Jeremai Smith			Rate decrease effective 16/11/23 (Monday ticket 5521928232)
-- 05/12/2024	Linga         			Rate decrease effective 10/12/24 (Monday ticket 7990999226)
-- 18/03/2025	Jeremai Smith			Moved Close Brothers fee rates to an external table instead of hard coding in the function (Monday ticket 8713097206)


ALTER FUNCTION [dbo].[svfMoorhouseDDIncome]
(
	 @PolicyStartDate datetime
	,@CreditCharge decimal (18,2)
	,@GWP decimal (18,2)
	,@IPT decimal (18,2) -- Be careful when passing in IPT. If passing amounts from ic_brcledger, IPT is already included in Orig_debt which is passed in as @GWP so @IPT can be set to zero. If passing amounts from MH_POLICY_FINANCIAL_VIEW, GWP and IPT are in separate fields.
	,@Fee decimal (18,2)
)
RETURNS decimal (18,2)
AS

/*

	DECLARE @PolicyStartDate datetime
	DECLARE @CreditCharge decimal (18,2)
	DECLARE @GWP decimal (18,2)
	DECLARE @IPT decimal (18,2)
	DECLARE @Fee decimal (18,2)

	SET @PolicyStartDate = '24 Aug 2022'
	SET @CreditCharge = 35.00
	SET @GWP = 200.00
	SET @IPT = 24.00
	SET @Fee = 30.00

	SELECT [dbo].[svfMoorhouseDDIncome](@PolicyStartDate, @CreditCharge, @GWP, @IPT, @Fee)

*/

BEGIN
	
	IF ISNULL(@CreditCharge, 0) > 0
	BEGIN

		DECLARE @DDIncome decimal (18,2)
		DECLARE @CloseBrothersFeePC decimal(5,4)
		DECLARE @CloseBrothersFee decimal (18,2)

		SELECT @CloseBrothersFeePC = [FeePC] FROM [dbo].[CloseBrothersRate]
		WHERE [StartDate] <= @PolicyStartDate
		AND ISNULL([EndDate], '31 Dec 9999') > @PolicyStartDate

		SET @CloseBrothersFee = ((@GWP + @IPT + @Fee) * 0.88) -- Payable amount is GWP + IPT + Fee, less 12% deposit (0.88)
									* @CloseBrothersFeePC -- Close Brothers' fee is a percentage of the payable amount that increases or decreases to reflect interest rate changes

		IF @CloseBrothersFee < 10 SET @CloseBrothersFee = 10 -- Minimum fee is £10

		SET @DDIncome = @CreditCharge - @CloseBrothersFee

	END -- END IF @CreditCharge > 0
	
	RETURN @DDIncome

END
