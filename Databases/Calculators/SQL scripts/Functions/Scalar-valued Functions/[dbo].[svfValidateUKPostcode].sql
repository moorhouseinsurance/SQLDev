USE [Calculators]
GO
/****** Object:  UserDefinedFunction [dbo].[svfValidateUKPostcode]    Script Date: 21/01/2025 08:05:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Linga
-- Create date: 02 Jan 2025
-- Description:	To validate the UK Postcode
-- =============================================
CREATE FUNCTION [dbo].[svfValidateUKPostcode]
(
	 @PostCode Nvarchar(10)
)
RETURNS BIT
AS
/*
	DECLARE @PostCode varchar(10) ;
	SET @PostCode = 'cf833hu'
	SELECT  @PostCode AS Postcode, dbo.svfValidateUKPostcode(@PostCode) AS IsValid
*/
BEGIN
	-- Declare the return variable here
	DECLARE @Result BIT

--AN NAA
--ANN NAA
--AAN NAA
--AANN NAA
--ANA NAA
--AANA NAA
	DECLARE @Pattern1 NVARCHAR(100) = '%[A-Z][1-9][0-9][A-Z][A-Z]%'
	DECLARE @Pattern2 NVARCHAR(100) = '%[A-Z][1-9][0-9][0-9][A-Z][A-Z]%'
	DECLARE @Pattern3 NVARCHAR(100) = '%[A-Z][A-Z][0-9][0-9][A-Z][A-Z]%'
	DECLARE @Pattern4 NVARCHAR(100) = '%[A-Z][A-Z][1-9][0-9][0-9][A-Z][A-Z]%'
	DECLARE @Pattern5 NVARCHAR(100) = '%[A-Z][1-9][A-Z][0-9][A-Z][A-Z]%'
	DECLARE @Pattern6 NVARCHAR(100) = '%[A-Z][A-Z][1-9][A-Z][0-9][A-Z][A-Z]%'


	--Remove any spaces for validation purposes
	SET @PostCode = REPLACE(@PostCode, ' ','');

	--Initialize the result
	SET @Result = 0

	IF @PostCode LIKE '%[^A-Za-z]%'  
	AND (PATINDEX (@Pattern1, @PostCode) > 0 OR
	     PATINDEX (@Pattern2, @PostCode) > 0 OR
	     PATINDEX (@Pattern3, @PostCode) > 0 OR
	     PATINDEX (@Pattern4, @PostCode) > 0 OR
	     PATINDEX (@Pattern5, @PostCode) > 0 OR
	     PATINDEX (@Pattern6, @PostCode) > 0 )
	AND
		LEN(@PostCode) BETWEEN 5 AND 8  -- ENsure length constraints for the postcode 
    BEGIN
        SET @Result = 1 
    END

	--Return the Result
	RETURN @Result
	
END
