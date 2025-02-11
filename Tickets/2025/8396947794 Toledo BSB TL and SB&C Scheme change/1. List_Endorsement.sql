USE [Transactor_Live]
GO

--select * from [Transactor_Live].[dbo].[LIST_ENDORSEMENT] where insurer_id = 'TOLEDO' and producttype = '196' endorsement_code_id = 'TISLGC'

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISTL081', N'TISPAMWA', N'Manual Work Away Exclusion (other than Collection & Delivery)', N'We will not indemnify You in respect of any claims arising in connection with any manual work away from Your premises by You or Your Employees other than for collection and delivery only.', 0, 195, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISTL082', N'TISPRO', N'Product Liability Exclusion', N'We shall not be liable in respect of Bodily Injury or Damage to property caused by or in connection with any product manufactured, sold or supplied by the insured.', 0, 195, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISTL083', N'TISROOF', N'Roofing Exclusion', N'We will not indemnify You in respect of any claims arising from or in connection with roof work.', 0, 195, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISTL084', N'TISSAF', N'Safety Harness Condition', N'It is a condition precedent to Our liability that all persons employed shall be issued with and shall wear fall-arrest equipment consisting of a full body harness, shock absorbing lanyard and connecting hook which conforms to CEN standards when working at heights exceeding 5 metres above the ground.
'+CHAR(13)+'
This condition shall not apply when the work area, including any access platform or scaffolding, has edge protection consisting of:
'+CHAR(13)+'
a) a main guard rail of at least 910mm above the edge;
'+CHAR(13)+'
b) a toe board of at least 150mm high;
'+CHAR(13)+'
c) an intermediate guard rail or other barrier so that there is no gap of more than 470mm.', 0, 195, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO


--=====Small Business

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSB081', N'TISPAMWA', N'Manual Work Away Exclusion (other than Collection & Delivery)', N'We will not indemnify You in respect of any claims arising in connection with any manual work away from Your premises by You or Your Employees other than for collection and delivery only.', 0, 196, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSB082', N'TISPRO', N'Product Liability Exclusion', N'We shall not be liable in respect of Bodily Injury or Damage to property caused by or in connection with any product manufactured, sold or supplied by the insured.', 0, 196, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSB083', N'TISROOF', N'Roofing Exclusion', N'We will not indemnify You in respect of any claims arising from or in connection with roof work.', 0, 196, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSB084', N'TISSAF', N'Safety Harness Condition', N'It is a condition precedent to Our liability that all persons employed shall be issued with and shall wear fall-arrest equipment consisting of a full body harness, shock absorbing lanyard and connecting hook which conforms to CEN standards when working at heights exceeding 5 metres above the ground.
'+CHAR(13)+'
This condition shall not apply when the work area, including any access platform or scaffolding, has edge protection consisting of:
'+CHAR(13)+'
a) a main guard rail of at least 910mm above the edge;
'+CHAR(13)+'
b) a toe board of at least 150mm high;
'+CHAR(13)+'
c) an intermediate guard rail or other barrier so that there is no gap of more than 470mm.', 0, 196, 154, 'TOLEDO', 0, 'POLICYENDORS')
GO



