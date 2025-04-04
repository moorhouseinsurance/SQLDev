
SELECT * FROM [System_Control] where product_filename = 'POFCC001.wpd'
SELECT * FROM [dbo].[System_Scheme_Definitions] WHERE NEWBUSINESSSCHEME = 'POFCC001.wpd'
SELECT * FROM [dbo].[System_Scheme_Name] WHERE SCHEMETABLE_ID = '1671'
SELECT * FROM [dbo].[RM_SCHEME]  WHERE SCHEMETABLE_ID = '1671'
SELECT * FROM [dbo].[RM_Commission_Group] WHERE [Name] = 'Price Forbes - Commercial Combined'
SELECT * FROM [dbo].[RM_Range_Group] WHERE [Name] = 'Price Forbes - Commercial Combined'

SELECT * FROM [Product].[Content].[Scheme] WHERE [Name] = 'Price Forbes - Commercial Combined'

UPDATE [dbo].[System_Control] SET PRODUCT_DESC = 'NRT Price Forbes - Commercial Combined'
WHERE [PRODUCT_FILENAME] = 'POFCC001.wpd';

UPDATE [dbo].[System_Scheme_Definitions] SET [PRODUCTNAME] = 'NRT Price Forbes - Commercial Combined'
WHERE [NEWBUSINESSSCHEME] = 'POFCC001.wpd';

UPDATE [dbo].[System_Scheme_Name] SET [SCHEMENAME] = 'NRT Price Forbes - Commercial Combined'
WHERE [SCHEMETABLE_ID] = '1671';

UPDATE [dbo].[RM_SCHEME] SET [NAME] = 'NRT Price Forbes - Commercial Combined'
WHERE [SCHEMETABLE_ID] = '1671';

UPDATE [dbo].[RM_Commission_Group] SET [NAME] = 'NRT Price Forbes - Commercial Combined'
WHERE [Name] = 'Price Forbes - Commercial Combined'

UPDATE [dbo].[RM_Range_Group] SET [NAME] = 'NRT Price Forbes - Commercial Combined'
WHERE [Name] = 'Price Forbes - Commercial Combined'

--===Rename for CAQ website
UPDATE [Product].[Content].[Scheme] SET [Name] = 'NRT Price Forbes - Commercial Combined'
WHERE [Name] = 'Price Forbes - Commercial Combined'
