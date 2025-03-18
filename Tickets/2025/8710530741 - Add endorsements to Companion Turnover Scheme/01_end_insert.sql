USE [Transactor_Live]
GO

INSERT INTO [dbo].[LIST_ENDORSEMENT]
           ([ENDORSEMENT_ID]
           ,[ENDORSEMENT_CODE_ID]
           ,[ENDORSEMENT_CODE_DEBUG]
           ,[ENDORSEMENT_CODE_TEXT]
           ,[DELETED]
           ,[PRODUCTTYPE]
           ,[PORTFOLIOKEY]
           ,[INSURER_ID]
           ,[ABIVALUE]
           ,[ENDORS_LINKTYPE_ID])
     VALUES
           ('TOMTO002'
           ,'TOMINDEP'
           ,'Minimum and Deposit '
           ,'This policy is Minimum and Deposit, the Insurer reserves the right not to allow a return of premium.'
           ,0
           ,'306'
           ,'154'
           ,'459'
           ,0
           ,'POLICYENDORS'),
		   ('TOMTO003'
           ,'TOMDWE'
           ,'Defective Workmanship Extension '
           ,'Notwithstanding Exclusion 6 to Section 2 Underwriters will indemnify the Assured in respect of their legal liability for costs and expenses incurred in the repair reconditioning or replacement of any Product or contract work executed by the Assured where such Product or contract work has caused:

I.	accidental Bodily Injury to any person or
II.	accidental loss of or damage to tangible property

which is the subject of a claim that is covered under Section 2 of this Policy and such claim would have been covered notwithstanding this Extension

Provided that

a) the Assured has not otherwise made a claim under this Extension (or similar extension) which has arisen from an occurrence happening within the three years prior to the date of this occurrence   

b) The Assured shall contribute 10% or £500 whichever is the greater amount to each and every claim inclusive of costs and expenses  

c) The Underwriters’ liability to pay Damages (including claimants’ costs fees and expenses) and Defence Costs in respect of this Extension shall not exceed £25,000 which shall be the Underwriters’ total liability in respect of all occurrences in any one Period of Insurance

Subject otherwise to the Policy terms Conditions Limitations and Exclusions'
           ,0
           ,'306'
           ,'154'
           ,'459'
           ,0
           ,'POLICYENDORS')
GO


