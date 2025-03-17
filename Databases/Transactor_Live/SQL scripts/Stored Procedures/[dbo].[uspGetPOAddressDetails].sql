USE [Transactor_Live]
GO

/****** Object:  StoredProcedure [dbo].[uspGetPOAddressDetails]    Script Date: 25/02/2025 12:59:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Simon Mackness-Pettit
-- Create date: 24 Feb 2025
-- Description:	TGSL database formula to return PropertyDetails for documents
-- =============================================

-- Date			Who						Change


CREATE PROCEDURE [dbo].[uspGetPOAddressDetails] (
 @PolicyDetailsID char(32)
,@HistoryID int
)

AS

/*

DECLARE @PolicyDetailsID char(32) = '6467C0013C16405089B34531A4C2F363'
DECLARE @HistoryID int = 1

EXEC [dbo].[uspGetPOAddressDetails] @PolicyDetailsID, @HistoryID

*/

DECLARE @PROPINFO_ID char(32) = (SELECT [MLETPROP_PROPINFO_ID] FROM [dbo].[USER_MLETPROP_PROPINFO]
								 WHERE [POLICY_DETAILS_ID] = @PolicyDetailsID AND [HISTORY_ID] = @HistoryID)
	,@PropertyCounter int = 0
	,@OccupancyCounter int = 0
	,@PRPDTAIL_ID char(32);

DECLARE @String varchar(MAX) = '';

-- =========================================
-- Loop through each Property Details record
-- =========================================

WHILE EXISTS (SELECT 1 FROM [dbo].[USER_MLETPROP_PRPDTAIL]
			  WHERE [MLETPROP_PROPINFO_ID] = @PROPINFO_ID
			  AND [HISTORY_ID] = @HistoryID
			  AND [USERINSTANCE] > @PropertyCounter)

BEGIN

	SET @PropertyCounter = @PropertyCounter + 1;

	SELECT @PRPDTAIL_ID = [MLETPROP_PRPDTAIL_ID] FROM [dbo].[USER_MLETPROP_PRPDTAIL]
												 WHERE [MLETPROP_PROPINFO_ID] = @PROPINFO_ID AND [HISTORY_ID] = @HistoryID AND [USERINSTANCE] = @PropertyCounter;

	SELECT @String = @String
		+ 'Property Address' + char(10)
		+ CASE WHEN [PD].[ADDONE] IS NULL THEN '' ELSE [PD].[ADDONE] + ' ' + CASE WHEN NULLIF([PD].[ADDTWO], '') IS NULL THEN '' ELSE [PD].[ADDTWO] END + ' ' + CASE WHEN NULLIF([PD].[POSTCODE], '') IS NULL THEN '' ELSE [PD].[POSTCODE] END + char(10) END
		+ 'Sums Insured' + char(10)
		+ CASE WHEN [PD].[BUILDINGSSI] IS NULL THEN '' ELSE 'Buildings' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + '£' + CAST(CAST([PD].[BUILDINGSSI] AS int) AS varchar) + char(10) END
		+ 'Accidental Damage' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) +  'NOT INCLUDED' + char(10) 
		+ CASE WHEN [PD].[CONTENTSTOTAL] IS NULL THEN '' ELSE 'Contents' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + '£' + CAST(CAST([PD].[CONTENTSTOTAL] AS int) AS varchar) + char(10) END
		+ 'Accidental Damage' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + 'NOT INCLUDED' + char(10)
		+ 'Loss of Rent' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + '20% of Buildings Sum Insured' + char(10)
		+ 'Property Owners Liability' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + '£5,000,000.00' + char(10) 
		+ CASE WHEN [LMB].[MH_BUILDING_ID] IS NULL THEN '' ELSE 'Type of Property' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + [LMB].[MH_BUILDING_DEBUG] + char(10) END
		+ CASE WHEN [PD].[CONSTRUCTYR] IS NULL THEN '' ELSE 'Year of constructions' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + CAST(CAST([PD].[CONSTRUCTYR] AS int) AS varchar) + char(10) END
		+ 'Details of any Financial Interest in the Property (if left blank then not applicable)' + char(10)
		+ CASE WHEN [PD].[FINANCIALINTR] IS NULL THEN '' ELSE 'Financial Interest:' + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + CASE [PD].[FINANCIALINTR] WHEN 0 THEN 'No' WHEN 1 THEN [PD].[FINANCEDETAILS] END + char(10) END
	FROM
		[dbo].[USER_MLETPROP_PRPDTAIL] AS [PD]
	LEFT JOIN
		[dbo].[LIST_MH_BUILDING] AS [LMB] ON [PD].[BUILDINGTYPE_ID] = [LMB].[MH_BUILDING_ID]
	WHERE
		[PD].[MLETPROP_PROPINFO_ID] = @PROPINFO_ID
	AND
		[PD].[HISTORY_ID] = @HistoryID
	AND
		[PD].[USERINSTANCE] = @PropertyCounter
	;

	SET @String = @String + char(10);

END; -- End looping through each Property Details record


SELECT @String;

GO


