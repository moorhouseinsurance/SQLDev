USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[uspSchemeMMAComparePremiums_Discount]    Script Date: 23/12/2024 10:45:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Created by DHostler 
-- Create date: 07-Feb-2012
-- Description: Compare up to 5 scheme premiums and select the scheme to use.
--              Price Match Scheme is SchemeTableID1
-- =============================================

-- Date			Who						Change
-- 16/10/2018	Jeremai Smith			Amended to take @CapCollarPctRate as an input parameter instead of defaulting to 30% (DEV-1928)
-- 15/01/2024	Jeremai Smith			Addition of Companion scheme (Monday.com ticket 5719803938)
-- 20/03/2024   Linga                   Remove AXA from Covea Price Match(Monday.com ticket 6284831853)
-- 24/07/2024	Jeremai Smith			Reverse removal of AXA TL (Monday.com ticket 7076722962)
-- 11/02/2025	Jeremai Smith			Don't remove referred Companion premiums from the comparison (Monday ticket 7988983705)
-- 11/02/2025	Jeremai Smith			Commented out 'DELETE FROM @SchemePremiumTable WHERE [SchemeTableID] != @SchemeID' as this was preventing MTAs from
--										price matching (Monday ticket 8058730198)


ALTER PROCEDURE [dbo].[uspSchemeMMAComparePremiums_Discount]

(
             @NewBusinessSchemeID int = 0
            ,@PolicyDetailsID char(32) = ''
            ,@CapCollarPctRate decimal (18,5) = 0.3
			,@AgentName varchar(255)
            ,@SubAgentID char(32)
            ,@PolicyStartDate Datetime
            ,@PolicyQuoteStage Varchar(3)
            ,@PriceUndercut decimal(18,5) = 0
            ,@EmployeesPL int = 0 
            ,@EmployeesELManual int = 0
            ,@EmployeesELNonManual int = 0 
            ,@EmployeesFixedMachinery decimal(18,5) = 0     
            ,@TempInsurance bit = 'False'
            ,@ToolCover bit = 'False'
            ,@SchemeTableID1 int = 0
            ,@Refer1 bit = 'False'        
            ,@PremiumELTemp1 decimal(18,5) = 0
            ,@PremiumELManual1 decimal(18,5) = 0      
            ,@PremiumELNonManual1 decimal(18,5) = 0                     
            ,@DiscountPercent1 decimal(18,5) = 0
            ,@DiscountAmount1 decimal(18,5) = 0
            ,@DiscountPercentTools1 decimal(18,5) = 0
            ,@DiscountAmountTools1 decimal(18,5) = 0        
            ,@SECTION_LIABPREM_NETPREMIUM1 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM1 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM1 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM1 decimal(18,5) = 0
            ,@SECTION_CWRKPREM_NETPREMIUM1 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM1 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM1 decimal(18,5) = 0

            ,@SchemeTableID2 int = 0
            ,@Refer2 bit = 'False'  
            ,@PremiumELTemp2 decimal(18,5) = 0
            ,@PremiumELManual2 decimal(18,5) = 0      
            ,@PremiumELNonManual2 decimal(18,5) = 0                     
            ,@DiscountPercent2 decimal(18,5) = 0            
            ,@DiscountAmount2 decimal(18,5) = 0       
            ,@DiscountPercentTools2 decimal(18,5) = 0
            ,@DiscountAmountTools2 decimal(18,5) = 0        
            ,@SECTION_LIABPREM_NETPREMIUM2 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM2 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM2 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM2 decimal(18,5) = 0  
            ,@SECTION_CWRKPREM_NETPREMIUM2 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM2 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM2 decimal(18,5) = 0             
              
            ,@SchemeTableID3 int = 0
            ,@Refer3 bit = 'False' 
            ,@PremiumELTemp3 decimal(18,5) = 0
            ,@PremiumELManual3 decimal(18,5) = 0      
            ,@PremiumELNonManual3 decimal(18,5) = 0                     
            ,@DiscountPercent3 decimal(18,5) = 0      
            ,@DiscountAmount3 decimal(18,5) = 0 
            ,@DiscountPercentTools3 decimal(18,5) = 0
            ,@DiscountAmountTools3 decimal(18,5) = 0                         
            ,@SECTION_LIABPREM_NETPREMIUM3 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM3 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM3 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM3 decimal(18,5) = 0
            ,@SECTION_CWRKPREM_NETPREMIUM3 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM3 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM3 decimal(18,5) = 0            
            
            ,@SchemeTableID4 int = 0
            ,@Refer4 bit = 'False'
            ,@PremiumELTemp4 decimal(18,5) = 0
            ,@PremiumELManual4 decimal(18,5) = 0      
            ,@PremiumELNonManual4 decimal(18,5) = 0                     
            ,@DiscountPercent4 decimal(18,5) = 0
            ,@DiscountAmount4 decimal(18,5) = 0
            ,@DiscountPercentTools4 decimal(18,5) = 0
            ,@DiscountAmountTools4 decimal(18,5) = 0                    
            ,@SECTION_LIABPREM_NETPREMIUM4 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM4 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM4 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM4 decimal(18,5) = 0
            ,@SECTION_CWRKPREM_NETPREMIUM4 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM4 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM4 decimal(18,5) = 0            
            
            ,@SchemeTableID5 int = 0
            ,@Refer5 bit = 'False' 
            ,@PremiumELTemp5 decimal(18,5) = 0
            ,@PremiumELManual5 decimal(18,5) = 0      
            ,@PremiumELNonManual5 decimal(18,5) = 0                     
            ,@DiscountPercent5 decimal(18,5) = 0
            ,@DiscountAmount5 decimal(18,5) = 0
            ,@DiscountPercentTools5 decimal(18,5) = 0
            ,@DiscountAmountTools5 decimal(18,5) = 0                          
            ,@SECTION_LIABPREM_NETPREMIUM5 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM5 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM5 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM5 decimal(18,5) = 0
            ,@SECTION_CWRKPREM_NETPREMIUM5 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM5 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM5 decimal(18,5) = 0
			            
            ,@SchemeTableID6 int = 0
            ,@Refer6 bit = 'False' 
            ,@PremiumELTemp6 decimal(18,5) = 0
            ,@PremiumELManual6 decimal(18,5) = 0      
            ,@PremiumELNonManual6 decimal(18,5) = 0                     
            ,@DiscountPercent6 decimal(18,5) = 0
            ,@DiscountAmount6 decimal(18,5) = 0
            ,@DiscountPercentTools6 decimal(18,5) = 0
            ,@DiscountAmountTools6 decimal(18,5) = 0  
            ,@SECTION_LIABPREM_NETPREMIUM6 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM6 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM6 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM6 decimal(18,5) = 0 
            ,@SECTION_CWRKPREM_NETPREMIUM6 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM6 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM6 decimal(18,5) = 0  
			
			,@SchemeTableID7 int = 0
            ,@Refer7 bit = 'False' 
            ,@PremiumELTemp7 decimal(18,5) = 0
            ,@PremiumELManual7 decimal(18,5) = 0      
            ,@PremiumELNonManual7 decimal(18,5) = 0                     
            ,@DiscountPercent7 decimal(18,5) = 0
            ,@DiscountAmount7 decimal(18,5) = 0
            ,@DiscountPercentTools7 decimal(18,5) = 0
            ,@DiscountAmountTools7 decimal(18,5) = 0  
            ,@SECTION_LIABPREM_NETPREMIUM7 decimal(18,5) = 0
            ,@SECTION_EMPLPREM_NETPREMIUM7 decimal(18,5) = 0
            ,@SECTION_TOOLPREM_NETPREMIUM7 decimal(18,5) = 0
            ,@SECTION_FXMCPREM_NETPREMIUM7 decimal(18,5) = 0 
            ,@SECTION_CWRKPREM_NETPREMIUM7 decimal(18,5) = 0 
			,@SECTION_HIPLPREM_NETPREMIUM7 decimal(18,5) = 0
			,@SECTION_PLMAPREM_NETPREMIUM7 decimal(18,5) = 0  
			
			,@MinimumPremium  decimal(18,5) = 0          
)           

AS

/*
	DECLARE
				 @NewBusinessSchemeID int = 0
				,@PolicyDetailsID char(32) = ''
				,@CapCollarPctRate decimal (18,5) = 0.3
				,@AgentName varchar(255)
				,@SubAgentID char(32)
				,@PolicyStartDate Datetime
				,@PolicyQuoteStage Varchar(3)
				,@PriceUndercut decimal(18,5) = 0
				,@EmployeesPL int = 0 
				,@EmployeesELManual int = 0
				,@EmployeesELNonManual int = 0 
				,@EmployeesFixedMachinery decimal(18,5) = 0     
				,@TempInsurance bit = 'False'
				,@ToolCover bit = 'False'
				,@SchemeTableID1 int = 0
				,@Refer1 bit = 'False'        
				,@PremiumELTemp1 decimal(18,5) = 0
				,@PremiumELManual1 decimal(18,5) = 0      
				,@PremiumELNonManual1 decimal(18,5) = 0                     
				,@DiscountPercent1 decimal(18,5) = 0
				,@DiscountAmount1 decimal(18,5) = 0
				,@DiscountPercentTools1 decimal(18,5) = 0
				,@DiscountAmountTools1 decimal(18,5) = 0        
				,@SECTION_LIABPREM_NETPREMIUM1 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM1 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM1 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM1 decimal(18,5) = 0
				,@SECTION_CWRKPREM_NETPREMIUM1 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM1 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM1 decimal(18,5) = 0

				,@SchemeTableID2 int = 0
				,@Refer2 bit = 'False'  
				,@PremiumELTemp2 decimal(18,5) = 0
				,@PremiumELManual2 decimal(18,5) = 0      
				,@PremiumELNonManual2 decimal(18,5) = 0                     
				,@DiscountPercent2 decimal(18,5) = 0            
				,@DiscountAmount2 decimal(18,5) = 0       
				,@DiscountPercentTools2 decimal(18,5) = 0
				,@DiscountAmountTools2 decimal(18,5) = 0        
				,@SECTION_LIABPREM_NETPREMIUM2 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM2 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM2 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM2 decimal(18,5) = 0  
				,@SECTION_CWRKPREM_NETPREMIUM2 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM2 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM2 decimal(18,5) = 0             
	              
				,@SchemeTableID3 int = 0
				,@Refer3 bit = 'False' 
				,@PremiumELTemp3 decimal(18,5) = 0
				,@PremiumELManual3 decimal(18,5) = 0      
				,@PremiumELNonManual3 decimal(18,5) = 0                     
				,@DiscountPercent3 decimal(18,5) = 0      
				,@DiscountAmount3 decimal(18,5) = 0 
				,@DiscountPercentTools3 decimal(18,5) = 0
				,@DiscountAmountTools3 decimal(18,5) = 0                         
				,@SECTION_LIABPREM_NETPREMIUM3 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM3 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM3 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM3 decimal(18,5) = 0
				,@SECTION_CWRKPREM_NETPREMIUM3 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM3 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM3 decimal(18,5) = 0            
	            
				,@SchemeTableID4 int = 0
				,@Refer4 bit = 'False'
				,@PremiumELTemp4 decimal(18,5) = 0
				,@PremiumELManual4 decimal(18,5) = 0      
				,@PremiumELNonManual4 decimal(18,5) = 0                     
				,@DiscountPercent4 decimal(18,5) = 0
				,@DiscountAmount4 decimal(18,5) = 0
				,@DiscountPercentTools4 decimal(18,5) = 0
				,@DiscountAmountTools4 decimal(18,5) = 0                    
				,@SECTION_LIABPREM_NETPREMIUM4 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM4 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM4 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM4 decimal(18,5) = 0
				,@SECTION_CWRKPREM_NETPREMIUM4 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM4 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM4 decimal(18,5) = 0            
	            
	            
				,@SchemeTableID5 int = 0
				,@Refer5 bit = 'False' 
				,@PremiumELTemp5 decimal(18,5) = 0
				,@PremiumELManual5 decimal(18,5) = 0      
				,@PremiumELNonManual5 decimal(18,5) = 0                     
				,@DiscountPercent5 decimal(18,5) = 0
				,@DiscountAmount5 decimal(18,5) = 0
				,@DiscountPercentTools5 decimal(18,5) = 0
				,@DiscountAmountTools5 decimal(18,5) = 0                          
				,@SECTION_LIABPREM_NETPREMIUM5 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM5 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM5 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM5 decimal(18,5) = 0
				,@SECTION_CWRKPREM_NETPREMIUM5 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM5 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM5 decimal(18,5) = 0
				            
				,@SchemeTableID6 int = 0
				,@Refer6 bit = 'False' 
				,@PremiumELTemp6 decimal(18,5) = 0
				,@PremiumELManual6 decimal(18,5) = 0      
				,@PremiumELNonManual6 decimal(18,5) = 0                     
				,@DiscountPercent6 decimal(18,5) = 0
				,@DiscountAmount6 decimal(18,5) = 0
				,@DiscountPercentTools6 decimal(18,5) = 0
				,@DiscountAmountTools6 decimal(18,5) = 0  
				,@SECTION_LIABPREM_NETPREMIUM6 decimal(18,5) = 0
				,@SECTION_EMPLPREM_NETPREMIUM6 decimal(18,5) = 0
				,@SECTION_TOOLPREM_NETPREMIUM6 decimal(18,5) = 0
				,@SECTION_FXMCPREM_NETPREMIUM6 decimal(18,5) = 0 
				,@SECTION_CWRKPREM_NETPREMIUM6 decimal(18,5) = 0 
				,@SECTION_HIPLPREM_NETPREMIUM6 decimal(18,5) = 0
				,@SECTION_PLMAPREM_NETPREMIUM6 decimal(18,5) = 0     
	          
	EXEC [dbo].[uspSchemeMMAComparePremiums] @AgentName ,@SubAgentID ,@PolicyStartDate ,@PolicyQuoteStage ,@PriceUndercut ,@EmployeesPL	,@EmployeesELManual	,@EmployeesELNonManual ,@EmployeesFixedMachinery ,@TempInsurance
											,@SchemeTableID1 ,@Refer1 ,@PremiumELTemp1 ,@PremiumELManual1 ,@PremiumELNonManual1 ,@DiscountPercent1 ,@DiscountAmount1 ,@DiscountPercentTools1 ,@DiscountAmountTools1 ,@SECTION_LIABPREM_NETPREMIUM1 ,@SECTION_EMPLPREM_NETPREMIUM1 ,@SECTION_TOOLPREM_NETPREMIUM1 ,@SECTION_FXMCPREM_NETPREMIUM1 ,@SECTION_CWRKPREM_NETPREMIUM1 ,@SECTION_HIPLPREM_NETPREMIUM1 ,@SECTION_PLMAPREM_NETPREMIUM1
											,@SchemeTableID2 ,@Refer2 ,@PremiumELTemp2 ,@PremiumELManual2 ,@PremiumELNonManual2 ,@DiscountPercent2 ,@DiscountAmount2 ,@DiscountPercentTools2 ,@DiscountAmountTools2 ,@SECTION_LIABPREM_NETPREMIUM2 ,@SECTION_EMPLPREM_NETPREMIUM2 ,@SECTION_TOOLPREM_NETPREMIUM2 ,@SECTION_FXMCPREM_NETPREMIUM2 ,@SECTION_CWRKPREM_NETPREMIUM2 ,@SECTION_HIPLPREM_NETPREMIUM2 ,@SECTION_PLMAPREM_NETPREMIUM2
											,@SchemeTableID3 ,@Refer3 ,@PremiumELTemp3 ,@PremiumELManual3 ,@PremiumELNonManual3 ,@DiscountPercent3 ,@DiscountAmount3 ,@DiscountPercentTools3 ,@DiscountAmountTools3 ,@SECTION_LIABPREM_NETPREMIUM3 ,@SECTION_EMPLPREM_NETPREMIUM3 ,@SECTION_TOOLPREM_NETPREMIUM3 ,@SECTION_FXMCPREM_NETPREMIUM3 ,@SECTION_CWRKPREM_NETPREMIUM3 ,@SECTION_HIPLPREM_NETPREMIUM3 ,@SECTION_PLMAPREM_NETPREMIUM3
											,@SchemeTableID4 ,@Refer4 ,@PremiumELTemp4 ,@PremiumELManual4 ,@PremiumELNonManual4 ,@DiscountPercent4 ,@DiscountAmount4 ,@DiscountPercentTools4 ,@DiscountAmountTools4 ,@SECTION_LIABPREM_NETPREMIUM4 ,@SECTION_EMPLPREM_NETPREMIUM4 ,@SECTION_TOOLPREM_NETPREMIUM4 ,@SECTION_FXMCPREM_NETPREMIUM4 ,@SECTION_CWRKPREM_NETPREMIUM4 ,@SECTION_HIPLPREM_NETPREMIUM4 ,@SECTION_PLMAPREM_NETPREMIUM4
											,@SchemeTableID5 ,@Refer5 ,@PremiumELTemp5 ,@PremiumELManual5 ,@PremiumELNonManual5 ,@DiscountPercent5 ,@DiscountAmount5 ,@DiscountPercentTools5 ,@DiscountAmountTools5 ,@SECTION_LIABPREM_NETPREMIUM5 ,@SECTION_EMPLPREM_NETPREMIUM5 ,@SECTION_TOOLPREM_NETPREMIUM5 ,@SECTION_FXMCPREM_NETPREMIUM5 ,@SECTION_CWRKPREM_NETPREMIUM5 ,@SECTION_HIPLPREM_NETPREMIUM5 ,@SECTION_PLMAPREM_NETPREMIUM5
											,@SchemeTableID6 ,@Refer6 ,@PremiumELTemp6 ,@PremiumELManual6 ,@PremiumELNonManual6 ,@DiscountPercent6 ,@DiscountAmount6 ,@DiscountPercentTools6 ,@DiscountAmountTools6 ,@SECTION_LIABPREM_NETPREMIUM6 ,@SECTION_EMPLPREM_NETPREMIUM6 ,@SECTION_TOOLPREM_NETPREMIUM6 ,@SECTION_FXMCPREM_NETPREMIUM6 ,@SECTION_CWRKPREM_NETPREMIUM6 ,@SECTION_HIPLPREM_NETPREMIUM6 ,@SECTION_PLMAPREM_NETPREMIUM6
*/

BEGIN

	DECLARE
		 @SchemeTableID int = 0
		,@PremiumELTemp decimal(18,5) = 0
		,@PremiumELManual decimal(18,5) = 0
		,@PremiumELNonManual decimal(18,5) = 0
		,@DiscountPercent decimal(18,5) = 0
		,@DiscountAmount  decimal(18,5) = 0
		,@DiscountPercentTools  decimal(18,5) = 0
		,@DiscountAmountTools decimal(18,5) = 0                                             
		,@SECTION_LIABPREM_NETPREMIUM decimal(18,5) = 0
		,@SECTION_EMPLPREM_NETPREMIUM decimal(18,5) = 0
		,@SECTION_TOOLPREM_NETPREMIUM decimal(18,5) = 0
		,@SECTION_FXMCPREM_NETPREMIUM decimal(18,5) = 0
		,@SECTION_CWRKPREM_NETPREMIUM decimal(18,5) = 0 
		,@SECTION_HIPLPREM_NETPREMIUM decimal(18,5) = 0
		,@SECTION_PLMAPREM_NETPREMIUM decimal(18,5) = 0                  
		,@PriceMatchBreakdownLine1 varchar(60) = ''
		,@PriceMatchBreakdownLine2 varchar(30) = ''
		,@PriceMatchBreakdownLine3 varchar(30) = ''
		,@PriceMatchBreakdownLine4 varchar(30) = ''
		,@PriceMatchBreakdownLine5 varchar(30) = ''
		,@PriceMatchBreakdownLine6 varchar(30) = ''
		,@PriceMatchBreakdownLine7 varchar(30) = ''     
		,@PriceMatchBreakdownLine8 varchar(30) = ''     
		,@PriceMatchBreakdownLine9 varchar(30) = ''     
		,@PriceMatchBreakdownLine10 varchar(30) = ''   	            

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
		,SECTION_LIABPREM_NETPREMIUM decimal(18,5) 
		,SECTION_EMPLPREM_NETPREMIUM decimal(18,5) 
		,SECTION_TOOLPREM_NETPREMIUM decimal(18,5) 
		,SECTION_FXMCPREM_NETPREMIUM decimal(18,5)
		,SECTION_CWRKPREM_NETPREMIUM decimal(18,5)
		,SECTION_HIPLPREM_NETPREMIUM decimal(18,5)
		,SECTION_PLMAPREM_NETPREMIUM decimal(18,5) 
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
		,SECTION_LIABPREM_NETPREMIUM 
		,SECTION_EMPLPREM_NETPREMIUM
		,SECTION_TOOLPREM_NETPREMIUM
		,SECTION_FXMCPREM_NETPREMIUM
		,SECTION_CWRKPREM_NETPREMIUM
		,SECTION_HIPLPREM_NETPREMIUM
		,SECTION_PLMAPREM_NETPREMIUM                       
	)
	VALUES 
	 (@SchemeTableID1 ,@Refer1 ,@PremiumELTemp1 ,@DiscountPercent1 ,@DiscountAmount1 ,@DiscountPercentTools1 ,@DiscountAmountTools1 ,@PremiumELManual1 ,@PremiumELNonManual1 ,@SECTION_LIABPREM_NETPREMIUM1 ,@SECTION_EMPLPREM_NETPREMIUM1 ,@SECTION_TOOLPREM_NETPREMIUM1 ,@SECTION_FXMCPREM_NETPREMIUM1 ,@SECTION_CWRKPREM_NETPREMIUM1 ,@SECTION_HIPLPREM_NETPREMIUM1 ,@SECTION_PLMAPREM_NETPREMIUM1)
	,(@SchemeTableID2 ,@Refer2 ,@PremiumELTemp2 ,@DiscountPercent2 ,@DiscountAmount2 ,@DiscountPercentTools2 ,@DiscountAmountTools2 ,@PremiumELManual2 ,@PremiumELNonManual2 ,@SECTION_LIABPREM_NETPREMIUM2 ,@SECTION_EMPLPREM_NETPREMIUM2 ,@SECTION_TOOLPREM_NETPREMIUM2 ,@SECTION_FXMCPREM_NETPREMIUM2 ,@SECTION_CWRKPREM_NETPREMIUM2 ,@SECTION_HIPLPREM_NETPREMIUM2 ,@SECTION_PLMAPREM_NETPREMIUM2)
	,(@SchemeTableID3 ,@Refer3 ,@PremiumELTemp3 ,@DiscountPercent3 ,@DiscountAmount3 ,@DiscountPercentTools3 ,@DiscountAmountTools3 ,@PremiumELManual3 ,@PremiumELNonManual3 ,@SECTION_LIABPREM_NETPREMIUM3 ,@SECTION_EMPLPREM_NETPREMIUM3 ,@SECTION_TOOLPREM_NETPREMIUM3 ,@SECTION_FXMCPREM_NETPREMIUM3 ,@SECTION_CWRKPREM_NETPREMIUM3 ,@SECTION_HIPLPREM_NETPREMIUM3 ,@SECTION_PLMAPREM_NETPREMIUM3)
	,(@SchemeTableID4 ,@Refer4 ,@PremiumELTemp4 ,@DiscountPercent4 ,@DiscountAmount4 ,@DiscountPercentTools4 ,@DiscountAmountTools4 ,@PremiumELManual4 ,@PremiumELNonManual4 ,@SECTION_LIABPREM_NETPREMIUM4 ,@SECTION_EMPLPREM_NETPREMIUM4 ,@SECTION_TOOLPREM_NETPREMIUM4 ,@SECTION_FXMCPREM_NETPREMIUM4 ,@SECTION_CWRKPREM_NETPREMIUM4 ,@SECTION_HIPLPREM_NETPREMIUM4 ,@SECTION_PLMAPREM_NETPREMIUM4)  
	,(@SchemeTableID5 ,@Refer5 ,@PremiumELTemp5 ,@DiscountPercent5 ,@DiscountAmount5 ,@DiscountPercentTools5 ,@DiscountAmountTools5 ,@PremiumELManual5 ,@PremiumELNonManual5 ,@SECTION_LIABPREM_NETPREMIUM5 ,@SECTION_EMPLPREM_NETPREMIUM5 ,@SECTION_TOOLPREM_NETPREMIUM5 ,@SECTION_FXMCPREM_NETPREMIUM5 ,@SECTION_CWRKPREM_NETPREMIUM5 ,@SECTION_HIPLPREM_NETPREMIUM5 ,@SECTION_PLMAPREM_NETPREMIUM5)
	,(@SchemeTableID6 ,@Refer6 ,@PremiumELTemp6 ,@DiscountPercent6 ,@DiscountAmount6 ,@DiscountPercentTools6 ,@DiscountAmountTools6 ,@PremiumELManual6 ,@PremiumELNonManual6 ,@SECTION_LIABPREM_NETPREMIUM6 ,@SECTION_EMPLPREM_NETPREMIUM6 ,@SECTION_TOOLPREM_NETPREMIUM6 ,@SECTION_FXMCPREM_NETPREMIUM6 ,@SECTION_CWRKPREM_NETPREMIUM6 ,@SECTION_HIPLPREM_NETPREMIUM6 ,@SECTION_PLMAPREM_NETPREMIUM6)
	,(@SchemeTableID7 ,@Refer7 ,@PremiumELTemp7 ,@DiscountPercent7 ,@DiscountAmount7 ,@DiscountPercentTools7 ,@DiscountAmountTools7 ,@PremiumELManual7 ,@PremiumELNonManual7 ,@SECTION_LIABPREM_NETPREMIUM7 ,@SECTION_EMPLPREM_NETPREMIUM7 ,@SECTION_TOOLPREM_NETPREMIUM7 ,@SECTION_FXMCPREM_NETPREMIUM7 ,@SECTION_CWRKPREM_NETPREMIUM7 ,@SECTION_HIPLPREM_NETPREMIUM7 ,@SECTION_PLMAPREM_NETPREMIUM7)

	DELETE FROM @SchemePremiumTable WHERE [Refer] = 'True' AND NOT ([SchemeTableID] = 1449 AND [SECTION_LIABPREM_NETPREMIUM] + [SECTION_EMPLPREM_NETPREMIUM] > 10) -- Preserve referred Companion rates in the comparison per Sarah Evans (Monday ticket 7988983705)
	DELETE FROM @SchemePremiumTable WHERE ([SchemeTableID] != @SchemeTableID1) AND (@NewBusinessSchemeID != 0) AND (@PolicyQuoteStage IN ('MTA','CAN')) AND ([SchemeTableID] != @NewBusinessSchemeID)  
	DELETE FROM @SchemePremiumTable WHERE ([SchemeTableID] = 0)
	
	UPDATE [S] 
	SET Premium = [S].[SECTION_LIABPREM_NETPREMIUM] + [S].[SECTION_EMPLPREM_NETPREMIUM] + [S].[SECTION_TOOLPREM_NETPREMIUM] + [S].[SECTION_CWRKPREM_NETPREMIUM] + [S].[SECTION_HIPLPREM_NETPREMIUM] + [S].[SECTION_PLMAPREM_NETPREMIUM] + CASE [S].[SchemeTableID] WHEN 1072 THEN 0 ELSE [S].[SECTION_FXMCPREM_NETPREMIUM] END --Added Hack for Groupams section 
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

	DECLARE @NetRated bit = 0
	DECLARE @CommissionPct decimal(18,5) = 0
	DECLARE @MinGrossPremium decimal (18,5)
	DECLARE @SchemeID INT = 0
	DECLARE @LowerThanCap int = 0
	
	SELECT 
		 @NetRated = NetRated
		,@CommissionPct = CommissionPct
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
			 [S1].[SECTION_LIABPREM_NETPREMIUM] = [S2].[SECTION_LIABPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_EMPLPREM_NETPREMIUM] = [S2].[SECTION_EMPLPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_TOOLPREM_NETPREMIUM] = [S2].[SECTION_TOOLPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_FXMCPREM_NETPREMIUM] = [S2].[SECTION_FXMCPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_CWRKPREM_NETPREMIUM] = [S2].[SECTION_CWRKPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_HIPLPREM_NETPREMIUM] = [S2].[SECTION_HIPLPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[SECTION_PLMAPREM_NETPREMIUM] = [S2].[SECTION_PLMAPREM_NETPREMIUM] * (1-@CapCollarPctRate)
			,[S1].[GrossPremium] = [S2].[GrossPremium] * (1-@CapCollarPctRate)
			,[S1].[NetRated] = [S2].[NetRated]
			,[S1].[CommissionPct] = [S2].[CommissionPct]
		FROM 
			@SchemePremiumTable AS [S1]
			JOIN @SchemePremiumTable AS [S2] ON [S2].[SchemeTableID] = @SchemeTableID1
		WHERE 
			[S1].[SchemeTableID] = @SchemeID		
			
		SET @PriceMatchBreakdownLine10 = 'MMA Quote Capped at - ' + CAST(CAST(@CapCollarPctRate*100 AS int)AS Nvarchar(2))+ '%'
		SET @PriceUndercut = 0
	END
	
	-- 30/12/24 JS Commented out the following DELETE as this was preventing MTAs from price matching (Monday ticket 8058730198)
	--DELETE FROM @SchemePremiumTable WHERE [SchemeTableID] != @SchemeID
	
	IF @SchemeID = @SchemeTableID1
		SET @PriceUndercut = 0
		
--End Cap collar

	;WITH [P] AS
	(
		SELECT 
			 @NetRated AS [NetRated]
			,@CommissionPct AS [CommissionPct]
	)
	SELECT TOP 1
		   @SchemeTableID = [C].[SchemeTableID]
		  ,@DiscountPercent = [C].[DiscountPercent]
		  ,@PremiumELTemp = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[PremiumELTemp])*((100-[P].[CommissionPct])/100) ELSE [C].[PremiumELTemp]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END    
		  ,@PremiumELManual = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[PremiumELManual])*((100-[P].[CommissionPct])/100) ELSE [C].[PremiumELManual]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END  
		  ,@PremiumELNonManual = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[PremiumELNonManual])*((100-[P].[CommissionPct])/100) ELSE [C].[PremiumELNonManual]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END  
		  ,@DiscountAmount = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[DiscountAmount])*((100-[P].[CommissionPct])/100) ELSE [C].[DiscountAmount]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END  
		  ,@DiscountPercentTools = [C].[DiscountPercentTools]
		  ,@DiscountAmountTools = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[DiscountAmountTools])*((100-[P].[CommissionPct])/100) ELSE [C].[DiscountAmountTools]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END  
		  ,@SECTION_LIABPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN ([C].[SECTION_LIABPREM_NETPREMIUM] - @PriceUndercut)*((100-[P].[CommissionPct])/100) ELSE (([C].[SECTION_LIABPREM_NETPREMIUM]/(1- ([C].[CommissionPct]/100)))- @PriceUndercut)*(1-[P].[CommissionPct]/100) END 
		  ,@SECTION_EMPLPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_EMPLPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_EMPLPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END 
		  ,@SECTION_TOOLPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_TOOLPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_TOOLPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END
		  ,@SECTION_FXMCPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_FXMCPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_FXMCPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END
		  ,@SECTION_CWRKPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_CWRKPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_CWRKPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END 
		  ,@SECTION_HIPLPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_HIPLPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_HIPLPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END
		  ,@SECTION_PLMAPREM_NETPREMIUM = CASE WHEN [C].[NetRated] = 'False' AND [P].[NetRated] = 'True' THEN [C].[SECTION_PLMAPREM_NETPREMIUM]*((100-[P].[CommissionPct])/100) ELSE [C].[SECTION_PLMAPREM_NETPREMIUM]*(100-[P].[CommissionPct])/(100-[C].[CommissionPct]) END		  
	FROM 
		  @SchemePremiumTable AS [C]
		  CROSS JOIN [P]
	WHERE
		ISNULL([GrossPremium],0) != 0
	ORDER BY [GrossPremium] ASC


/* Construct Breakdowns, should be moved to a seperate scheme specific procedure */
/* Used Ageas Breakdown format  Will add logic for other breakdowns if required*/

	IF @SchemeTableID in (878,1064)--MMA
	BEGIN
		  SET @PriceMatchBreakdownLine1 = 'MMA was the lowest Quote'
	END
	ELSE
	BEGIN
		SELECT @PriceMatchBreakdownLine1 = Name + ' BreakDown' FROM RM_SCHEME WHERE @SchemeTableID = RM_SCHEME.SCHEMETABLE_ID
	END      
	      	
		
--Minimum Premium

	IF @SECTION_LIABPREM_NETPREMIUM + @SECTION_EMPLPREM_NETPREMIUM + @SECTION_TOOLPREM_NETPREMIUM + @SECTION_FXMCPREM_NETPREMIUM < @MinimumPremium
	BEGIN
		DECLARE @MinimumPremiumTable table
		(
			 SECTION_1 decimal(18,5)
			,SECTION_2 decimal(18,5)
			,SECTION_3 decimal(18,5)
			,SECTION_4 decimal(18,5)
		)	
		INSERT INTO @MinimumPremiumTable
		EXEC [dbo].[uspSchemeMMAMinimumPremiums]  @MinimumPremium ,@SECTION_LIABPREM_NETPREMIUM ,@SECTION_EMPLPREM_NETPREMIUM ,@SECTION_TOOLPREM_NETPREMIUM ,@SECTION_FXMCPREM_NETPREMIUM	
 
		SELECT 
			 @SECTION_LIABPREM_NETPREMIUM = SECTION_1 
			,@SECTION_EMPLPREM_NETPREMIUM = SECTION_2 
			,@SECTION_TOOLPREM_NETPREMIUM = SECTION_3 
			,@SECTION_FXMCPREM_NETPREMIUM = SECTION_4
		FROM @MinimumPremiumTable
		
		  SET @PriceMatchBreakdownLine2 = 'Minimum Premium of £' + CONVERT(varchar(10),@MinimumPremium) + ' applied'
		  		
		  SET @PriceMatchBreakdownLine3 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
		  SET @PriceMatchBreakdownLine4 = CASE WHEN @SECTION_EMPLPREM_NETPREMIUM != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@SECTION_EMPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
		  SET @PriceMatchBreakdownLine5 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
		  SET @PriceMatchBreakdownLine6 = CASE WHEN @EmployeesFixedMachinery != 0  THEN 'Fixed Machinery x' + CAST(@EmployeesFixedMachinery AS varchar(10)) + ':::' + CAST(@SECTION_FXMCPREM_NETPREMIUM AS varchar(10)) ELSE '' END
	END
	ELSE
	BEGIN
		IF @SchemeTableID IN (855,913)--Ageas
		BEGIN
			  SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			  SET @PriceMatchBreakdownLine3 = CASE WHEN @EmployeesELManual != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@PremiumELManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine4 = CASE WHEN @EmployeesELNonManual != 0 THEN 'Non Manual EL X ' + CAST(@EmployeesELNonManual AS varchar(10)) + ':::' + CAST(@PremiumELNonManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine5 = CASE WHEN @TempInsurance ='True' THEN 'Temp EL:::' + CAST(@PremiumELTemp AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine6 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine7 = 'Including ' + CAST(@DiscountPercent AS varchar(10)) + '% discount'
			  SET @PriceMatchBreakdownLine8 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10)) 
		END
		IF @SchemeTableID IN (866,997)--Arista
		BEGIN
			  SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			  SET @PriceMatchBreakdownLine3 = CASE WHEN @SECTION_EMPLPREM_NETPREMIUM != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@SECTION_EMPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine4 = CASE WHEN @TempInsurance ='True' THEN 'inc Temp EL' ELSE '' END
			  SET @PriceMatchBreakdownLine5 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine6 = CASE WHEN @DiscountPercentTools != 0 THEN 'Including ' + CAST(@DiscountPercentTools AS varchar(10)) + '% tools discount:::' +  CAST(-@DiscountAmountTools AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine7 = CASE WHEN @DiscountPercent != 0 THEN 'Including ' + CAST(@DiscountPercent AS varchar(10)) + '% discount:::-' +  CAST(@DiscountAmount AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine8 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10)) 
		END
		IF @SchemeTableID IN (1071,856)--Aviva
		BEGIN
			  SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			  SET @PriceMatchBreakdownLine3 = CASE WHEN @PremiumELManual != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@PremiumELManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine4 = CASE WHEN @PremiumELNonManual != 0 THEN 'Non Manual EL X ' + CAST(@EmployeesELNonManual AS varchar(10)) + ':::' + CAST(@PremiumELNonManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine5 = CASE WHEN @TempInsurance ='True' THEN 'Temp EL:::' + CAST(@PremiumELTemp AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine6 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine7 = CASE WHEN @EmployeesFixedMachinery != 0  THEN 'Fixed Machinery x' + CAST(@EmployeesFixedMachinery AS varchar(10)) + ':::' + CAST(@SECTION_FXMCPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine8 = CASE WHEN @DiscountPercent != 0 THEN 'Including ' + CAST(@DiscountPercent AS varchar(10)) + '% discount :::-' + + CAST(@DiscountAmount AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine9 = CASE WHEN @DiscountAmountTools != 0 THEN '1 Month Free :::' +  CAST(-@DiscountAmountTools AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine10 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10)) 
		END
		IF @SchemeTableID IN (1072,1063)--Groupama
		BEGIN
			  SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			  SET @PriceMatchBreakdownLine3 = CASE WHEN @PremiumELManual != 0 AND @EmployeesELManual = 0 THEN 'Temporary EL :::' + CAST(@PremiumELManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine4 = CASE WHEN @PremiumELManual != 0 AND @EmployeesELManual != 0 THEN 'EL X '  + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@PremiumELManual AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine5 = CASE WHEN @PremiumELManual != 0 AND @EmployeesELManual != 0 AND @SECTION_FXMCPREM_NETPREMIUM != 0  THEN 'Fixed Machinery x' + CAST(@EmployeesFixedMachinery AS varchar(10)) + ':::' + CAST(@SECTION_FXMCPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine6 = CASE WHEN @PremiumELNonManual != 0 THEN 'EL Clerical X ' + CAST(@EmployeesELNonManual AS varchar(10)) + ':::' + CAST(@PremiumELNonManual AS varchar(10)) ELSE '' END      
			  SET @PriceMatchBreakdownLine7 = CASE WHEN @TempInsurance ='True' THEN 'Temporary EL:::' + CAST(@PremiumELTemp AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine8 = CASE WHEN @SECTION_TOOLPREM_NETPREMIUM  != 0 THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ' and Transit :::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			  SET @PriceMatchBreakdownLine8 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10))   
			  SET @SECTION_FXMCPREM_NETPREMIUM = 0 --Groupama builds this into EMPLPREM, so just required for the breakdown
		END

		IF @SchemeTableID IN (1325) -- AXATL -- 1370 AXASB
		BEGIN
			SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			SET @PriceMatchBreakdownLine3 = CASE WHEN @EmployeesELManual != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@SECTION_EMPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine4 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END		  
			SET @PriceMatchBreakdownLine5 = CASE WHEN @SECTION_CWRKPREM_NETPREMIUM IS NOT NULL THEN 'Contract Work'  + ':::' + CAST(@SECTION_CWRKPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine6 = CASE WHEN @SECTION_HIPLPREM_NETPREMIUM IS NOT NULL THEN 'Hired Plant'  + ':::' + CAST(@SECTION_HIPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine7 = CASE WHEN @SECTION_PLMAPREM_NETPREMIUM IS NOT NULL THEN 'Own Plant'  + ':::' + CAST(@SECTION_PLMAPREM_NETPREMIUM AS varchar(10)) ELSE '' END				  
			SET @PriceMatchBreakdownLine8 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10)) 
		END

		IF @SchemeTableID IN (1448,1449) -- Companion
		BEGIN
			SET @PriceMatchBreakdownLine2 = 'PL X ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_LIABPREM_NETPREMIUM AS varchar(10))
			SET @PriceMatchBreakdownLine3 = CASE WHEN @EmployeesELManual != 0 THEN 'Manual EL x' + CAST(@EmployeesELManual AS varchar(10))  + ':::' + CAST(@SECTION_EMPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine4 = CASE WHEN @ToolCover  = 'True' THEN 'Tools x ' + CAST(@EmployeesPL AS varchar(10)) + ':::' + CAST(@SECTION_TOOLPREM_NETPREMIUM AS varchar(10)) ELSE '' END		  
			SET @PriceMatchBreakdownLine5 = CASE WHEN @SECTION_CWRKPREM_NETPREMIUM IS NOT NULL THEN 'Contract Work'  + ':::' + CAST(@SECTION_CWRKPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine6 = CASE WHEN @SECTION_HIPLPREM_NETPREMIUM IS NOT NULL THEN 'Hired Plant'  + ':::' + CAST(@SECTION_HIPLPREM_NETPREMIUM AS varchar(10)) ELSE '' END
			SET @PriceMatchBreakdownLine7 = CASE WHEN @SECTION_PLMAPREM_NETPREMIUM IS NOT NULL THEN 'Own Plant'  + ':::' + CAST(@SECTION_PLMAPREM_NETPREMIUM AS varchar(10)) ELSE '' END				  
			SET @PriceMatchBreakdownLine8 = 'Price Match Discount:::-' + CAST(@PriceUndercut AS varchar(10)) 
		END

	END

	/* Return Values ****/
	SELECT 
				 @SchemeTableID AS [SchemeTableID]
				,@SECTION_LIABPREM_NETPREMIUM AS [SECTION_LIABPREM_NETPREMIUM]
				,@SECTION_EMPLPREM_NETPREMIUM AS [SECTION_EMPLPREM_NETPREMIUM]
				,@SECTION_TOOLPREM_NETPREMIUM AS [SECTION_TOOLPREM_NETPREMIUM]
				,@SECTION_FXMCPREM_NETPREMIUM AS [SECTION_FXMCPREM_NETPREMIUM]
				,@SECTION_CWRKPREM_NETPREMIUM AS [SECTION_CWRKPREM_NETPREMIUM]
				,@SECTION_HIPLPREM_NETPREMIUM AS [SECTION_HIPLPREM_NETPREMIUM]
				,@SECTION_PLMAPREM_NETPREMIUM AS [SECTION_PLMAPREM_NETPREMIUM]
				,@SECTION_LIABPREM_NETPREMIUM + @SECTION_EMPLPREM_NETPREMIUM + @SECTION_TOOLPREM_NETPREMIUM + @SECTION_FXMCPREM_NETPREMIUM + @SECTION_CWRKPREM_NETPREMIUM + @SECTION_HIPLPREM_NETPREMIUM + @SECTION_PLMAPREM_NETPREMIUM AS [PREMIUM]
				,@PriceMatchBreakdownLine1 AS [PriceMatchBreakdownLine1]
				,@PriceMatchBreakdownLine2 AS [PriceMatchBreakdownLine2]
				,@PriceMatchBreakdownLine3 AS [PriceMatchBreakdownLine3]
				,@PriceMatchBreakdownLine4 AS [PriceMatchBreakdownLine4]
				,@PriceMatchBreakdownLine5 AS [PriceMatchBreakdownLine5]
				,@PriceMatchBreakdownLine6 AS [PriceMatchBreakdownLine6]
				,@PriceMatchBreakdownLine7 AS [PriceMatchBreakdownLine7]
				,@PriceMatchBreakdownLine8 AS [PriceMatchBreakdownLine8]
				,@PriceMatchBreakdownLine9 AS [PriceMatchBreakdownLine9]
				,@PriceMatchBreakdownLine10 AS [PriceMatchBreakdownLine10]        
				,'<Schemevariables><SchemeID>'+ CAST(@SchemeTableID AS varchar(4))+'</SchemeID></Schemevariables>' AS [ProductDetailsSchemeTableID]  
END

