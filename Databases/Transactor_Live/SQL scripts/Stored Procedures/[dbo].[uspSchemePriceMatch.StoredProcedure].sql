USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspSchemePriceMatch]    Script Date: 30/12/2024 08:44:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Created by DHostler 
-- Create date: 19 July 2016
-- Description: Compare up to 5 scheme premiums and select the scheme to use.
--              Price Match Scheme is SchemeTableID1
-- =============================================

-- 29/07/2024	Jeremai Smith			Ignore input schemes if all input premiums are zero. This will prevent false discounts being applied by the minimum
--										cap	logic applying the maximum discount to the Covea premium (as happened when AXA was temporarily excluded from price
--										match - Monday ticket 7086444390)
-- 11/02/2025	Jeremai Smith			Don't remove referred Companion premiums from the comparison (Monday ticket 7988983705)
-- 11/02/2025	Jeremai Smith			Commented out 'DELETE FROM @SchemePremiumTable WHERE [SchemeTableID] != @SchemeID' as this was preventing MTAs from
--										price matching (Monday ticket 8058730198)


ALTER PROCEDURE [dbo].[uspSchemePriceMatch]

(            
             @PolicyDetailsID char(32) = ''
            ,@HistoryID int = 0 
            ,@ElementTag nvarchar(20) = ''
            ,@CapCollarPctRate decimal (18,5) = 0.3
            ,@AgentName varchar(255)
            ,@SubAgentID char(32)
            ,@PolicyStartDate Datetime
            ,@PolicyQuoteStage Varchar(3)
            ,@PriceUndercut decimal(18,5) = 0  
            ,@SchemeTableID1 int = 0
            ,@Refer1 bit = 'False'        
            ,@PremiumELTemp1 decimal(18,5) = 0
            ,@PremiumELManual1 decimal(18,5) = 0      
            ,@PremiumELNonManual1 decimal(18,5) = 0                     
            ,@DiscountPercent1 decimal(18,5) = 0
            ,@DiscountAmount1 decimal(18,5) = 0
            ,@DiscountPercentTools1 decimal(18,5) = 0
            ,@DiscountAmountTools1 decimal(18,5) = 0        
            ,@SECTION_11 decimal(18,5) = 0
            ,@SECTION_12 decimal(18,5) = 0
            ,@SECTION_13 decimal(18,5) = 0
            ,@SECTION_14 decimal(18,5) = 0
            ,@SECTION_15 decimal(18,5) = 0 
			,@SECTION_16 decimal(18,5) = 0
			,@SECTION_17 decimal(18,5) = 0

            ,@SchemeTableID2 int = 0
            ,@Refer2 bit = 'False'  
            ,@PremiumELTemp2 decimal(18,5) = 0
            ,@PremiumELManual2 decimal(18,5) = 0      
            ,@PremiumELNonManual2 decimal(18,5) = 0                     
            ,@DiscountPercent2 decimal(18,5) = 0            
            ,@DiscountAmount2 decimal(18,5) = 0       
            ,@DiscountPercentTools2 decimal(18,5) = 0
            ,@DiscountAmountTools2 decimal(18,5) = 0        
            ,@SECTION_21 decimal(18,5) = 0
            ,@SECTION_22 decimal(18,5) = 0
            ,@SECTION_23 decimal(18,5) = 0
            ,@SECTION_24 decimal(18,5) = 0
            ,@SECTION_25 decimal(18,5) = 0 
			,@SECTION_26 decimal(18,5) = 0
			,@SECTION_27 decimal(18,5) = 0       
              
            ,@SchemeTableID3 int = 0
            ,@Refer3 bit = 'False' 
            ,@PremiumELTemp3 decimal(18,5) = 0
            ,@PremiumELManual3 decimal(18,5) = 0      
            ,@PremiumELNonManual3 decimal(18,5) = 0                     
            ,@DiscountPercent3 decimal(18,5) = 0      
            ,@DiscountAmount3 decimal(18,5) = 0 
            ,@DiscountPercentTools3 decimal(18,5) = 0
            ,@DiscountAmountTools3 decimal(18,5) = 0                         
            ,@SECTION_31 decimal(18,5) = 0
            ,@SECTION_32 decimal(18,5) = 0
            ,@SECTION_33 decimal(18,5) = 0
            ,@SECTION_34 decimal(18,5) = 0
            ,@SECTION_35 decimal(18,5) = 0 
			,@SECTION_36 decimal(18,5) = 0
			,@SECTION_37 decimal(18,5) = 0
			
            ,@SchemeTableID4 int = 0
            ,@Refer4 bit = 'False'
            ,@PremiumELTemp4 decimal(18,5) = 0
            ,@PremiumELManual4 decimal(18,5) = 0      
            ,@PremiumELNonManual4 decimal(18,5) = 0                     
            ,@DiscountPercent4 decimal(18,5) = 0
            ,@DiscountAmount4 decimal(18,5) = 0
            ,@DiscountPercentTools4 decimal(18,5) = 0
            ,@DiscountAmountTools4 decimal(18,5) = 0                    
            ,@SECTION_41 decimal(18,5) = 0
            ,@SECTION_42 decimal(18,5) = 0
            ,@SECTION_43 decimal(18,5) = 0
            ,@SECTION_44 decimal(18,5) = 0
            ,@SECTION_45 decimal(18,5) = 0 
			,@SECTION_46 decimal(18,5) = 0
			,@SECTION_47 decimal(18,5) = 0     
            
            ,@SchemeTableID5 int = 0
            ,@Refer5 bit = 'False' 
            ,@PremiumELTemp5 decimal(18,5) = 0
            ,@PremiumELManual5 decimal(18,5) = 0      
            ,@PremiumELNonManual5 decimal(18,5) = 0                     
            ,@DiscountPercent5 decimal(18,5) = 0
            ,@DiscountAmount5 decimal(18,5) = 0
            ,@DiscountPercentTools5 decimal(18,5) = 0
            ,@DiscountAmountTools5 decimal(18,5) = 0                          
            ,@SECTION_51 decimal(18,5) = 0
            ,@SECTION_52 decimal(18,5) = 0
            ,@SECTION_53 decimal(18,5) = 0
            ,@SECTION_54 decimal(18,5) = 0
            ,@SECTION_55 decimal(18,5) = 0 
			,@SECTION_56 decimal(18,5) = 0
			,@SECTION_57 decimal(18,5) = 0
			            
            ,@SchemeTableID6 int = 0
            ,@Refer6 bit = 'False' 
            ,@PremiumELTemp6 decimal(18,5) = 0
            ,@PremiumELManual6 decimal(18,5) = 0      
            ,@PremiumELNonManual6 decimal(18,5) = 0                     
            ,@DiscountPercent6 decimal(18,5) = 0
            ,@DiscountAmount6 decimal(18,5) = 0
            ,@DiscountPercentTools6 decimal(18,5) = 0
            ,@DiscountAmountTools6 decimal(18,5) = 0  
            ,@SECTION_61 decimal(18,5) = 0
            ,@SECTION_62 decimal(18,5) = 0
            ,@SECTION_63 decimal(18,5) = 0
            ,@SECTION_64 decimal(18,5) = 0
            ,@SECTION_65 decimal(18,5) = 0 
			,@SECTION_66 decimal(18,5) = 0
			,@SECTION_67 decimal(18,5) = 0    
			
			,@MinimumPremium decimal(18,5) = 0    
)           

AS

/*
	DECLARE
             @PolicyDetailsID char(32) = 'FF7EF1EACB0C49499E9DB7212AFF2AEB'
            ,@HistoryID int = 0 
            ,@ElementTag nvarchar(20) = 'Tradesman'
            ,@CapCollarPctRate decimal (18,5) = 0.3            
            ,@AgentName varchar(255)
            ,@SubAgentID char(32)
            ,@PolicyStartDate Datetime
            ,@PolicyQuoteStage Varchar(3)
            ,@PriceUndercut decimal(18,5) = 0  
            ,@SchemeTableID1 int = 0
            ,@Refer1 bit = 'False'        
            ,@PremiumELTemp1 decimal(18,5) = 0
            ,@PremiumELManual1 decimal(18,5) = 0      
            ,@PremiumELNonManual1 decimal(18,5) = 0                     
            ,@DiscountPercent1 decimal(18,5) = 0
            ,@DiscountAmount1 decimal(18,5) = 0
            ,@DiscountPercentTools1 decimal(18,5) = 0
            ,@DiscountAmountTools1 decimal(18,5) = 0        
            ,@SECTION_11 decimal(18,5) = 0
            ,@SECTION_12 decimal(18,5) = 0
            ,@SECTION_13 decimal(18,5) = 0
            ,@SECTION_14 decimal(18,5) = 0
            ,@SECTION_15 decimal(18,5) = 0 
			,@SECTION_16 decimal(18,5) = 0
			,@SECTION_17 decimal(18,5) = 0

            ,@SchemeTableID2 int = 0
            ,@Refer2 bit = 'False'  
            ,@PremiumELTemp2 decimal(18,5) = 0
            ,@PremiumELManual2 decimal(18,5) = 0      
            ,@PremiumELNonManual2 decimal(18,5) = 0                     
            ,@DiscountPercent2 decimal(18,5) = 0            
            ,@DiscountAmount2 decimal(18,5) = 0       
            ,@DiscountPercentTools2 decimal(18,5) = 0
            ,@DiscountAmountTools2 decimal(18,5) = 0        
            ,@SECTION_21 decimal(18,5) = 0
            ,@SECTION_22 decimal(18,5) = 0
            ,@SECTION_23 decimal(18,5) = 0
            ,@SECTION_24 decimal(18,5) = 0
            ,@SECTION_25 decimal(18,5) = 0 
			,@SECTION_26 decimal(18,5) = 0
			,@SECTION_27 decimal(18,5) = 0       
              
            ,@SchemeTableID3 int = 0
            ,@Refer3 bit = 'False' 
            ,@PremiumELTemp3 decimal(18,5) = 0
            ,@PremiumELManual3 decimal(18,5) = 0      
            ,@PremiumELNonManual3 decimal(18,5) = 0                     
            ,@DiscountPercent3 decimal(18,5) = 0      
            ,@DiscountAmount3 decimal(18,5) = 0 
            ,@DiscountPercentTools3 decimal(18,5) = 0
            ,@DiscountAmountTools3 decimal(18,5) = 0                         
            ,@SECTION_31 decimal(18,5) = 0
            ,@SECTION_32 decimal(18,5) = 0
            ,@SECTION_33 decimal(18,5) = 0
            ,@SECTION_34 decimal(18,5) = 0
            ,@SECTION_35 decimal(18,5) = 0 
			,@SECTION_36 decimal(18,5) = 0
			,@SECTION_37 decimal(18,5) = 0
			
            ,@SchemeTableID4 int = 0
            ,@Refer4 bit = 'False'
            ,@PremiumELTemp4 decimal(18,5) = 0
            ,@PremiumELManual4 decimal(18,5) = 0      
            ,@PremiumELNonManual4 decimal(18,5) = 0                     
            ,@DiscountPercent4 decimal(18,5) = 0
            ,@DiscountAmount4 decimal(18,5) = 0
            ,@DiscountPercentTools4 decimal(18,5) = 0
            ,@DiscountAmountTools4 decimal(18,5) = 0                    
            ,@SECTION_41 decimal(18,5) = 0
            ,@SECTION_42 decimal(18,5) = 0
            ,@SECTION_43 decimal(18,5) = 0
            ,@SECTION_44 decimal(18,5) = 0
            ,@SECTION_45 decimal(18,5) = 0 
			,@SECTION_46 decimal(18,5) = 0
			,@SECTION_47 decimal(18,5) = 0     
            
            ,@SchemeTableID5 int = 0
            ,@Refer5 bit = 'False' 
            ,@PremiumELTemp5 decimal(18,5) = 0
            ,@PremiumELManual5 decimal(18,5) = 0      
            ,@PremiumELNonManual5 decimal(18,5) = 0                     
            ,@DiscountPercent5 decimal(18,5) = 0
            ,@DiscountAmount5 decimal(18,5) = 0
            ,@DiscountPercentTools5 decimal(18,5) = 0
            ,@DiscountAmountTools5 decimal(18,5) = 0                          
            ,@SECTION_51 decimal(18,5) = 0
            ,@SECTION_52 decimal(18,5) = 0
            ,@SECTION_53 decimal(18,5) = 0
            ,@SECTION_54 decimal(18,5) = 0
            ,@SECTION_55 decimal(18,5) = 0 
			,@SECTION_56 decimal(18,5) = 0
			,@SECTION_57 decimal(18,5) = 0
			            
            ,@SchemeTableID6 int = 0
            ,@Refer6 bit = 'False' 
            ,@PremiumELTemp6 decimal(18,5) = 0
            ,@PremiumELManual6 decimal(18,5) = 0      
            ,@PremiumELNonManual6 decimal(18,5) = 0                     
            ,@DiscountPercent6 decimal(18,5) = 0
            ,@DiscountAmount6 decimal(18,5) = 0
            ,@DiscountPercentTools6 decimal(18,5) = 0
            ,@DiscountAmountTools6 decimal(18,5) = 0  
            ,@SECTION_61 decimal(18,5) = 0
            ,@SECTION_62 decimal(18,5) = 0
            ,@SECTION_63 decimal(18,5) = 0
            ,@SECTION_64 decimal(18,5) = 0
            ,@SECTION_65 decimal(18,5) = 0 
			,@SECTION_66 decimal(18,5) = 0
			,@SECTION_67 decimal(18,5) = 0       
			,@MinimumPremium decimal(18,5) = 0      
	          
	EXEC [dbo].[uspSchemePriceMatch]     @PolicyDetailsID, @HistoryID, @ElementTag, @CapCollarPctRate, @AgentName, @SubAgentID, @PolicyStartDate, @PolicyQuoteStage, @PriceUndercut
												,@SchemeTableID1 ,@Refer1 ,@PremiumELTemp1 ,@PremiumELManual1 ,@PremiumELNonManual1 ,@DiscountPercent1 ,@DiscountAmount1 ,@DiscountPercentTools1 ,@DiscountAmountTools1 ,@SECTION_11 ,@SECTION_12 ,@SECTION_13 ,@SECTION_14 ,@SECTION_15 ,@SECTION_16 ,@SECTION_17
												,@SchemeTableID2 ,@Refer2 ,@PremiumELTemp2 ,@PremiumELManual2 ,@PremiumELNonManual2 ,@DiscountPercent2 ,@DiscountAmount2 ,@DiscountPercentTools2 ,@DiscountAmountTools2 ,@SECTION_21 ,@SECTION_22 ,@SECTION_23 ,@SECTION_24 ,@SECTION_25 ,@SECTION_26 ,@SECTION_27
												,@SchemeTableID3 ,@Refer3 ,@PremiumELTemp3 ,@PremiumELManual3 ,@PremiumELNonManual3 ,@DiscountPercent3 ,@DiscountAmount3 ,@DiscountPercentTools3 ,@DiscountAmountTools3 ,@SECTION_31 ,@SECTION_32 ,@SECTION_33 ,@SECTION_34 ,@SECTION_35 ,@SECTION_36 ,@SECTION_37
												,@SchemeTableID4 ,@Refer4 ,@PremiumELTemp4 ,@PremiumELManual4 ,@PremiumELNonManual4 ,@DiscountPercent4 ,@DiscountAmount4 ,@DiscountPercentTools4 ,@DiscountAmountTools4 ,@SECTION_41 ,@SECTION_42 ,@SECTION_43 ,@SECTION_44 ,@SECTION_45 ,@SECTION_46 ,@SECTION_47
												,@SchemeTableID5 ,@Refer5 ,@PremiumELTemp5 ,@PremiumELManual5 ,@PremiumELNonManual5 ,@DiscountPercent5 ,@DiscountAmount5 ,@DiscountPercentTools5 ,@DiscountAmountTools5 ,@SECTION_51 ,@SECTION_52 ,@SECTION_53 ,@SECTION_54 ,@SECTION_55 ,@SECTION_56 ,@SECTION_57
												,@SchemeTableID6 ,@Refer6 ,@PremiumELTemp6 ,@PremiumELManual6 ,@PremiumELNonManual6 ,@DiscountPercent6 ,@DiscountAmount6 ,@DiscountPercentTools6 ,@DiscountAmountTools6 ,@SECTION_61 ,@SECTION_62 ,@SECTION_63 ,@SECTION_64 ,@SECTION_65 ,@SECTION_66 ,@SECTION_67
												,@MinimumPremium 

*/

BEGIN
	DECLARE  @NewBusinessSchemeID int = 0	
	
	SET @ElementTag = CASE @ElementTag WHEN  'Tradesman' THEN 'SchemeID' WHEN 'CAR' THEN 'CARSchemeID' END
	
	SELECT
		@NewBusinessSchemeID = CONVERT(XML,REPLACE(REPLACE([CPD].[Details],'&lt;','<'),'&gt;','>')).value('(//*[local-name()=sql:variable("@ElementTag")])[1]', 'int')
	FROM 
		[dbo].[Customer_Product_Details] AS [CPD]
	WHERE		
		[CPD].[Policy_Details_ID] = @PolicyDetailsID
		AND [CPD].[History_ID] = @HistoryID
		AND @PolicyQuoteStage IN ('MTA','CAN')
		AND ((Details LIKE '<SchemeVariables><' + @ElementTag + '>%'))	
		
	DECLARE
		 @SchemeTableID int = 0
		,@Capped int = 0
		,@PremiumELTemp decimal(18,5) = 0
		,@PremiumELManual decimal(18,5) = 0
		,@PremiumELNonManual decimal(18,5) = 0
		,@DiscountPercent decimal(18,5) = 0
		,@DiscountAmount  decimal(18,5) = 0
		,@DiscountPercentTools  decimal(18,5) = 0
		,@DiscountAmountTools decimal(18,5) = 0                                             
		,@SECTION_1 decimal(18,5) = 0
		,@SECTION_2 decimal(18,5) = 0
		,@SECTION_3 decimal(18,5) = 0
		,@SECTION_4 decimal(18,5) = 0
		,@SECTION_5 decimal(18,5) = 0 
		,@SECTION_6 decimal(18,5) = 0
		,@SECTION_7 decimal(18,5) = 0                  
          

	DECLARE @SchemePremiumTable table
	(
		 SchemeTableID int
		,Refer bit
		,Premium  decimal(18,5) 
		,PremiumELTemp decimal(18,5)
		,DiscountPercent decimal(18,5)
		,DiscountAmount  decimal(18,5)
		,DiscountPercentTools  decimal(18,5)
		,DiscountAmountTools decimal(18,5)  
		,PremiumELManual decimal(18,5)
		,PremiumELNonManual decimal(18,5)                          
		,SECTION_1 decimal(18,5) 
		,SECTION_2 decimal(18,5) 
		,SECTION_3 decimal(18,5) 
		,SECTION_4 decimal(18,5)
		,SECTION_5 decimal(18,5)
		,SECTION_6 decimal(18,5)
		,SECTION_7 decimal(18,5) 
		,GrossPremium decimal(18,5)
		,NetRated bit
		,CommissionPct decimal(18,5)  				             
	)
	
	INSERT INTO @SchemePremiumTable 
	(
		 SchemeTableID
		,Refer
		,PremiumELTemp
		,DiscountPercent 
		,DiscountAmount 
		,DiscountPercentTools
		,DiscountAmountTools    
		,PremiumELManual 
		,PremiumELNonManual
		,SECTION_1 
		,SECTION_2
		,SECTION_3
		,SECTION_4
		,SECTION_5
		,SECTION_6
		,SECTION_7                       
	)
	VALUES 
	 (@SchemeTableID1 ,@Refer1 ,@PremiumELTemp1 ,@DiscountPercent1 ,@DiscountAmount1 ,@DiscountPercentTools1 ,@DiscountAmountTools1 ,@PremiumELManual1 ,@PremiumELNonManual1 ,@SECTION_11 ,@SECTION_12 ,@SECTION_13 ,@SECTION_14 ,@SECTION_15 ,@SECTION_16 ,@SECTION_17)
	,(@SchemeTableID2 ,@Refer2 ,@PremiumELTemp2 ,@DiscountPercent2 ,@DiscountAmount2 ,@DiscountPercentTools2 ,@DiscountAmountTools2 ,@PremiumELManual2 ,@PremiumELNonManual2 ,@SECTION_21 ,@SECTION_22 ,@SECTION_23 ,@SECTION_24 ,@SECTION_25 ,@SECTION_26 ,@SECTION_27)
	,(@SchemeTableID3 ,@Refer3 ,@PremiumELTemp3 ,@DiscountPercent3 ,@DiscountAmount3 ,@DiscountPercentTools3 ,@DiscountAmountTools3 ,@PremiumELManual3 ,@PremiumELNonManual3 ,@SECTION_31 ,@SECTION_32 ,@SECTION_33 ,@SECTION_34 ,@SECTION_35 ,@SECTION_36 ,@SECTION_37)
	,(@SchemeTableID4 ,@Refer4 ,@PremiumELTemp4 ,@DiscountPercent4 ,@DiscountAmount4 ,@DiscountPercentTools4 ,@DiscountAmountTools4 ,@PremiumELManual4 ,@PremiumELNonManual4 ,@SECTION_41 ,@SECTION_42 ,@SECTION_43 ,@SECTION_44 ,@SECTION_45 ,@SECTION_46 ,@SECTION_47)  
	,(@SchemeTableID5 ,@Refer5 ,@PremiumELTemp5 ,@DiscountPercent5 ,@DiscountAmount5 ,@DiscountPercentTools5 ,@DiscountAmountTools5 ,@PremiumELManual5 ,@PremiumELNonManual5 ,@SECTION_51 ,@SECTION_52 ,@SECTION_53 ,@SECTION_54 ,@SECTION_55 ,@SECTION_56 ,@SECTION_57)
	,(@SchemeTableID6 ,@Refer6 ,@PremiumELTemp6 ,@DiscountPercent6 ,@DiscountAmount6 ,@DiscountPercentTools6 ,@DiscountAmountTools6 ,@PremiumELManual6 ,@PremiumELNonManual6 ,@SECTION_61 ,@SECTION_62 ,@SECTION_63 ,@SECTION_64 ,@SECTION_65 ,@SECTION_66 ,@SECTION_67)

	DELETE FROM @SchemePremiumTable WHERE [Refer] = 'True' AND NOT ([SchemeTableID] = 1448 AND [SECTION_1] + [SECTION_2] > 10) -- Preserve referred Companion rates in the comparison per Sarah Evans (Monday ticket 7988983705)
	DELETE FROM @SchemePremiumTable WHERE ([SchemeTableID] != @SchemeTableID1) AND (@NewBusinessSchemeID != 0) AND (@PolicyQuoteStage IN ('MTA','CAN')) AND ([SchemeTableID] != @NewBusinessSchemeID)  
	DELETE FROM @SchemePremiumTable WHERE ([SchemeTableID] = 0)
	DELETE FROM @SchemePremiumTable WHERE ISNULL([Premium], 0) = 0 AND ISNULL([PremiumELTemp], 0) = 0 AND ISNULL([DiscountPercent], 0) = 0 AND ISNULL([DiscountAmount], 0) = 0
									AND ISNULL([DiscountPercentTools], 0) = 0 AND ISNULL([DiscountAmountTools], 0) = 0 AND ISNULL([PremiumELManual], 0) = 0
									AND ISNULL([PremiumELNonManual], 0) = 0 AND ISNULL([SECTION_1], 0) = 0 AND ISNULL([SECTION_2], 0) = 0 AND ISNULL([SECTION_3], 0) = 0
									AND ISNULL([SECTION_4], 0) = 0 AND ISNULL([SECTION_5], 0) = 0 AND ISNULL([SECTION_6], 0) = 0 AND ISNULL([SECTION_7], 0) = 0
									AND ISNULL([GrossPremium], 0) = 0 AND ISNULL([NetRated], 0) = 0 AND ISNULL([CommissionPct], 0) = 0 -- All columns are zero so no premium to compare

	UPDATE [S] 
	SET Premium = [S].[SECTION_1] + [S].[SECTION_2] + [S].[SECTION_3] + [S].[SECTION_4] + [S].[SECTION_5] + [S].[SECTION_6] + [S].[SECTION_7]
	FROM @SchemePremiumTable AS [S] 

	--SELECT * FROM @SchemePremiumTable

	;WITH [CommissionData] AS
	(
		SELECT 
			 ROW_NUMBER() OVER (PARTITION BY [S].[SchemeTableID] ORDER BY [RMC].[AGENT_ID] DESC ,[RMC].[SUBAGENT_ID] DESC, [RMC].[AnySubAgent] DESC, [RMC].[EffectiveDate] DESC) AS [RowNumber]
			,CASE
				WHEN [RMS].[NETRATED] = 'False' THEN [S].[Premium]
				ELSE
					[S].[Premium]/((100-
						(
							  CASE @PolicyQuoteStage 
									WHEN 'NB' THEN [RMC].[NB_PARTNER_PERCENT] + [RMC].[NB_AGENT_PERCENT] + [RMC].[NB_SUBAGENT_PERCENT]
									WHEN 'MTA' THEN [RMC].[MTA_PARTNER_PERCENT] + [RMC].[MTA_AGENT_PERCENT] + [RMC].[MTA_SUBAGENT_PERCENT]
									WHEN 'REN' THEN [RMC].[REN_PARTNER_PERCENT] + [RMC].[REN_AGENT_PERCENT] + [RMC].[REN_SUBAGENT_PERCENT]    
							  END 
						)
					)/100)
			 END AS [GrossPremium] 
			,CASE @PolicyQuoteStage 
				WHEN 'NB' THEN [RMC].[NB_PARTNER_PERCENT] + [RMC].[NB_AGENT_PERCENT] + [RMC].[NB_SUBAGENT_PERCENT]
				WHEN 'MTA' THEN [RMC].[MTA_PARTNER_PERCENT] + [RMC].[MTA_AGENT_PERCENT] + [RMC].[MTA_SUBAGENT_PERCENT]
				WHEN 'REN' THEN [RMC].[REN_PARTNER_PERCENT] + [RMC].[REN_AGENT_PERCENT] + [RMC].[REN_SUBAGENT_PERCENT]  
			 END AS [CommissionPct]
			,[RMS].[NETRATED]
			,[S].[SchemeTableID]
		FROM 
			[dbo].[RM_SCHEME] AS [RMS] 
			JOIN @SchemePremiumTable AS [S] ON [RMS].[SCHEMETABLE_ID] = [S].[SchemeTableID]            
			JOIN [dbo].[RM_SCHEME_INSURER] AS [RMSI] ON [RMSI].[SCHEME_ID] = [RMS].[SCHEME_ID]
			JOIN [dbo].[RM_COMMISSION_GROUP] AS [RMCG] ON [RMSI].[COMMISSION_GROUP_ID] = [RMCG].[COMMISSION_GROUP_ID]
			JOIN [dbo].[RM_COMMISSION] AS [RMC] ON [RMCG].[COMMISSION_GROUP_ID] = [RMC].[COMMISSION_GROUP_ID]
			LEFT JOIN [dbo].[RM_AGENT] AS [RMA] ON [RMC].[AGENT_ID] = [RMA].[AGENT_ID]                      
		WHERE 
			([RMC].[Agent_ID] IS NULL OR [RMA].[NAME] = @AgentName)
			AND @PolicyStartDate BETWEEN [RMC].[EFFECTIVEDATE] AND ISNULL([RMC].[EXPIRYDATE],@PolicyStartDate)
			AND ((ISNULL([RMC].[SUBAGENT_ID],'') = @SubAgentID) OR (@SubAgentID != '' AND [RMC].[ANYSUBAGENT] = 'True'))
	            
	)
	UPDATE
		[S]	
	SET
		 [S].[GrossPremium] = [CD].[GrossPremium]
		,[S].[NetRated] = [CD].[NetRated]
		,[S].[CommissionPct] = [CD].[CommissionPct]
	FROM
		@SchemePremiumTable AS [S]
		JOIN [CommissionData] AS [CD] on [S].[SchemeTableID] = [CD].[SchemeTableID]
	WHERE
		  [CD].[RowNumber] = 1

--Cap Collar Check

	DECLARE @TargetNetRated bit = 0
	DECLARE @TargetCommissionPct decimal(18,5) = 0
	DECLARE @MinGrossPremium decimal (18,5)
	DECLARE @SchemeID INT = 0
	DECLARE @LowerThanCap int = 0
	
	SELECT 
		 @TargetNetRated = NetRated
		,@TargetCommissionPct = CommissionPct
		,@MinGrossPremium = ([GrossPremium] * (1-@CapCollarPctRate))
	FROM 
		@SchemePremiumTable
	WHERE 
		[SchemeTableID] = @SchemeTableID1

	SELECT TOP 1 
		 @SchemeID =  [SchemeTableID] 
		,@LowerThanCap = CASE WHEN [GrossPremium] <= @MinGrossPremium THEN 1 ELSE 0 END
	FROM 
		@SchemePremiumTable 
	WHERE 
		@NewBusinessSchemeID in (0,[SchemeTableID]) ORDER BY [GrossPremium]

	IF @LowerThanCap = 1
	BEGIN		
		UPDATE
			[S1]
		SET 
			 [S1].[SECTION_1] = [S2].[SECTION_1] * (1-@CapCollarPctRate)
			,[S1].[SECTION_2] = [S2].[SECTION_2] * (1-@CapCollarPctRate)
			,[S1].[SECTION_3] = [S2].[SECTION_3] * (1-@CapCollarPctRate)
			,[S1].[SECTION_4] = [S2].[SECTION_4] * (1-@CapCollarPctRate)
			,[S1].[SECTION_5] = [S2].[SECTION_5] * (1-@CapCollarPctRate)
			,[S1].[SECTION_6] = [S2].[SECTION_6] * (1-@CapCollarPctRate)
			,[S1].[SECTION_7] = [S2].[SECTION_7] * (1-@CapCollarPctRate)
			,[S1].[GrossPremium] = [S2].[GrossPremium] * (1-@CapCollarPctRate)
			,[S1].[NetRated] = [S2].[NetRated]
			,[S1].[CommissionPct] = [S2].[CommissionPct]
		FROM 
			@SchemePremiumTable AS [S1]
			JOIN @SchemePremiumTable AS [S2] ON [S2].[SchemeTableID] = @SchemeTableID1
		WHERE 
			[S1].[SchemeTableID] = @SchemeID		
			
		SET @Capped = 1
		SET @PriceUndercut = 0
	END
	
	-- 30/12/24 JS Commented out the following DELETE as this was preventing MTAs from price matching (Monday ticket 8058730198)
	--DELETE FROM @SchemePremiumTable WHERE [SchemeTableID] != @SchemeID	
	
	IF @SchemeID = @SchemeTableID1
		SET @PriceUndercut = 0
		
--End Cap collar

	SELECT TOP 1
		   @SchemeTableID			= [C].[SchemeTableID]
		  ,@DiscountPercent			= [C].[DiscountPercent]
		  ,@DiscountPercentTools	= [C].[DiscountPercentTools]
		  ,@PremiumELTemp			= [dbo].[svfPremiumToTargetNetOrGross]([C].[PremiumELTemp], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)  
		  ,@PremiumELManual			= [dbo].[svfPremiumToTargetNetOrGross]([C].[PremiumELManual], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default) 
		  ,@PremiumELNonManual		= [dbo].[svfPremiumToTargetNetOrGross]([C].[PremiumELNonManual], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@DiscountAmount			= [dbo].[svfPremiumToTargetNetOrGross]([C].[DiscountAmount], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@DiscountAmountTools		= [dbo].[svfPremiumToTargetNetOrGross]([C].[DiscountAmountTools], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_1 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_1], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, @PriceUndercut)
		  ,@SECTION_2 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_2], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_3 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_3], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_4 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_4], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_5 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_5], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_6 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_6], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)
		  ,@SECTION_7 = [dbo].[svfPremiumToTargetNetOrGross]([C].[SECTION_7], [C].[NetRated], @TargetNetrated, [C].[CommissionPct], @TargetCommissionPct, default)	  
	FROM																															
		  @SchemePremiumTable AS [C]
	WHERE
		ISNULL([GrossPremium],0) != 0
	ORDER BY 
		[GrossPremium] ASC
		
--Minimum Premium
	DECLARE @IsMinimumPremium bit = 0;
	
	IF @SECTION_1 + @SECTION_2 + @SECTION_3 + @SECTION_4 < @MinimumPremium
	BEGIN
		SET @IsMinimumPremium = 1;
		
		DECLARE @MinimumPremiumTable table
		(
			 SECTION_1 decimal(18,5)
			,SECTION_2 decimal(18,5)
			,SECTION_3 decimal(18,5)
			,SECTION_4 decimal(18,5)
		)	
		INSERT INTO @MinimumPremiumTable
		EXEC [dbo].[uspSchemeMMAMinimumPremiums]  @MinimumPremium ,@SECTION_1 ,@SECTION_2 ,@SECTION_3 ,@SECTION_4			
	 
		SELECT 
			 @SECTION_1 = SECTION_1 
			,@SECTION_2 = SECTION_2 
			,@SECTION_3 = SECTION_3 
			,@SECTION_4 = SECTION_4
		FROM @MinimumPremiumTable
	END		
	
	/* Return Values ****/
	SELECT 
				 @SchemeTableID AS [SchemeTableID]
				,@SECTION_1 AS [SECTION_1]
				,@SECTION_2 AS [SECTION_2]
				,@SECTION_3 AS [SECTION_3]
				,@SECTION_4 AS [SECTION_4]
				,@SECTION_5 AS [SECTION_5]
				,@SECTION_6 AS [SECTION_6]
				,@SECTION_7 AS [SECTION_7]
				,'<Schemevariables><'+ @ElementTag +'>'+ CAST(@SchemeTableID AS varchar(4))+'</' + @ElementTag +'></Schemevariables>' AS [ProductDetailsSchemeTableID]  
				,@Capped AS [Capped]
				,@DiscountPercent		AS [DiscountPercent]	
				,@DiscountPercentTools	AS [DiscountPercentTools]
				,@PremiumELTemp			AS [PremiumELTemp]		
				,@PremiumELManual		AS [PremiumELManual]	
				,@PremiumELNonManual	AS [PremiumELNonManual]	
				,@DiscountAmount		AS [DiscountAmount]		
				,@DiscountAmountTools	AS [DiscountAmountTools]
				,@IsMinimumPremium		AS [IsMinimumPremium]				
END

