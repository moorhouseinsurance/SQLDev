USE [Product]
GO
/****** Object:  UserDefinedFunction [QuestionSet].[tvfComparatorValueFunction]    Script Date: 3/19/2018 12:03:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************
-- Name:    [Product].[QuestionSet].[tvfComparatorValueFunction] 
-- Author:  Devlin Hostler
-- date:    24 Dec 2010
-- Description: Returns a value from a required function
*******************************************************************************/
CREATE FUNCTION [QuestionSet].[tvfComparatorValueFunction] 
(
	 @ComparatorValueFunctionID int 
)
RETURNS @Returntable Table 
(
	 Value varchar(1000)
	,ComparatorValueFunctionID int
	,FunctionName varchar(255)
)
AS

/*

DECLARE @ComparatorValueFunctionID int
SET @ComparatorValueFunctionID = 4

SELECT * FROM [QuestionSet].[tvfComparatorValueFunction](@ComparatorValueFunctionID)

*/
BEGIN
	IF @ComparatorValueFunctionID = 0
	BEGIN
		INSERT INTO @ReturnTable (ComparatorValueFunctionID ,FunctionName)
		(
			SELECT 1 ,'System Date'
			UNION SELECT 2, 'Current Year'
			UNION SELECT 3, 'Next Year'
			UNION SELECT 4, '18 Years Ago'
			UNION SELECT 5, '30 Days in the Future'
			UNION SELECT 6, '5 Years Ago'
			UNION SELECT 7, '1900-01-01 00:00:00.000'

			--UNION
		)

		RETURN
	END

	IF @ComparatorValueFunctionID = 1  BEGIN INSERT INTO @Returntable (Value) Select  CONVERT(VARCHAR(23),[Transactor_UAT].[dbo].[GetSystemDate](GETDATE()),121) RETURN END
	IF @ComparatorValueFunctionID = 2  BEGIN INSERT INTO @Returntable (Value) Select YEAR(GETDATE()) RETURN END
	IF @ComparatorValueFunctionID = 3  BEGIN INSERT INTO @Returntable (Value) Select YEAR(GETDATE()) + 1 RETURN END	
	IF @ComparatorValueFunctionID = 4  BEGIN INSERT INTO @Returntable (Value) Select  CONVERT(VARCHAR(23),DATEADD(YEAR ,-18 ,GETDATE()),121) RETURN END
	IF @ComparatorValueFunctionID = 5  BEGIN INSERT INTO @Returntable (Value) Select  CONVERT(VARCHAR(23),DATEADD(DAY  ,+30 ,GETDATE()),121) RETURN END	
	IF @ComparatorValueFunctionID = 6  BEGIN INSERT INTO @Returntable (Value) Select  CONVERT(VARCHAR(23),DATEADD(YEAR ,-5  ,GETDATE()),121) RETURN END	
	IF @ComparatorValueFunctionID = 7  BEGIN INSERT INTO @Returntable (Value) Select '1900-01-01 00:00:00.000' RETURN END
	
	RETURN
END


GO
