USE [Calculators]
GO

UPDATE
	[dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
SET
	[EndDateTime] = GETDATE()-1
WHERE
	[LoadDiscountType] = 'Multi Property Discount'
AND
	[EndDateTime] IS NULL;

INSERT INTO
	[dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
	(
		[LoadDiscountType]
		,[StartRange]
		,[EndRange]
		,[LoadDiscountValue]
		,[Refer]
		,[StartDateTime]
		,[InsertDateTime]
		,[UserID]
	)
VALUES
	(
		'Multi Property Discount'
		,3
		,10
		,-10.00
		,NULL
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'Multi Property Discount'
		,11
		,15
		,-15.00
		,NULL
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'Multi Property Discount'
		,16
		,20
		,-20.00
		,NULL
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'Multi Property Discount'
		,21
		,50
		,-25.00
		,NULL
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'Multi Property Discount'
		,51
		,NULL
		,NULL
		,1
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	);

UPDATE
	[dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
SET
	[EndDateTime] = GETDATE()-1
WHERE
	[LoadDiscountType] IN ('Students', 'DSS (Council Support)', 'HMO', 'Asylum Seekers')
AND
	[EndDateTime] IS NULL;

INSERT INTO
	[dbo].[MLETPROP_Toledo_PropertyOwners_LoadDiscount]
	(
		[LoadDiscountType]
		,[LoadDiscountValue]
		,[StartDateTime]
		,[InsertDateTime]
		,[UserID]
	)
VALUES
	(
		'Students'
		,30.00
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'DSS (Council Support)'
		,30.00
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'HMO'
		,30.00
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	),
	(
		'Asylum seekers'
		,30.00
		,GETDATE()-1
		,GETDATE()
		,'Simon'
	);

GO