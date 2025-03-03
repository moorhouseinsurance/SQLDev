USE [Transactor_Live]
GO
/****** Object:  StoredProcedure [dbo].[CUST_BUS_CONTACT_INSERT]    Script Date: 12/02/2025 15:02:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[CUST_BUS_CONTACT_INSERT]
(
@BUS_CONTACT_ID char (32),
@BUSINESS_ID char (32),
@HISTORY_ID int ,
@NAME varchar (255),
@JOBTITLE varchar (255),
@EMAIL varchar (100),
@BUSCONT_RELATIONSHIP_ID varchar(8)
)
AS
set nocount off;
			INSERT INTO [CUSTOMER_BUS_CONTACT] 
			SELECT 
 			@BUS_CONTACT_ID,
 			@BUSINESS_ID,
 			@HISTORY_ID,
 			@NAME,
 			@JOBTITLE,
			EMAIL = @EMAIL,
			BUSCONT_RELATIONSHIP_ID =	CASE
											WHEN @BUSCONT_RELATIONSHIP_ID = '' THEN '0'
											WHEN @BUSCONT_RELATIONSHIP_ID = ' ' THEN '0'
											WHEN @BUSCONT_RELATIONSHIP_ID IS NULL THEN '0'
											ELSE @BUSCONT_RELATIONSHIP_ID
										END
