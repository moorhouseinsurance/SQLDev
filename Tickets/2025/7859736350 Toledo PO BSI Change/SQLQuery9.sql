USE[Transactor_Live];

DECLARE @Schemes VARCHAR(60);
DECLARE @Rate DECIMAL(4,2);
DECLARE @SuccessFlag BIT;

SET @Schemes = '1594,1605';
SET @Rate = 2.5;
SET @SuccessFlag = 0;

DECLARE @Identified_Cases AS TABLE
(
	[Row_Number] INT
	,[POLICY_DETAILS_ID] CHAR(32)
	,[HISTORY_ID] INT
	,[MLETPROP_PRPDTAIL_ID] char(32)
	,[PolicyNumber] varchar(30)
	,[Current_BSI] INT
	,[Increase] INT
	,[New_BSI] INT
	,[Occ_ID] INT
	,[Occupied_Value] INT
	,[Occupied_Increase] INT
	,[New_Occupied_Value] INT
	,[New_Note] VARCHAR(160)
	,[Note_ID] CHAR(32)
)

INSERT INTO @Identified_Cases
	SELECT
		ROW_NUMBER() OVER (ORDER BY [Prop_Details].[MLETPROP_PRPDTAIL_ID])
		,[CPD].[POLICY_DETAILS_ID]
		,[CPD].[HISTORY_ID]
		,[Prop_Details].[MLETPROP_PRPDTAIL_ID]
		,[CPD].[PolicyNumber]
		,CAST([Prop_Details].[BUILDINGSSI] AS INT) AS [Current_BSI]
		,CAST(([Prop_Details].[BUILDINGSSI] + [Prop_Details].[BUILDINGSSI] * @Rate / 100) - [Prop_Details].[BUILDINGSSI] AS INT) AS [Increase]
		,(CAST([Prop_Details].[BUILDINGSSI] AS INT)) + (CAST(([Prop_Details].[BUILDINGSSI] + [Prop_Details].[BUILDINGSSI] * @Rate / 100) - [Prop_Details].[BUILDINGSSI] AS INT)) AS [New_BSI]
		,[Occ_Details].[USERINSTANCE] AS [Occ_ID]
		,CAST([Occ_Details].[OCCUPIED] AS INT) AS [Occupied_Value]
		,CAST(([Occ_Details].[OCCUPIED] + [Occ_Details].[OCCUPIED] * @Rate / 100) - [Occ_Details].[OCCUPIED] AS INT) AS [Occupied_Increase]
		,(CAST([Occ_Details].[OCCUPIED] AS INT)) + (CAST(([Occ_Details].[OCCUPIED] + [Occ_Details].[OCCUPIED] * @Rate / 100) - [Occ_Details].[OCCUPIED] AS INT)) AS [New_Occupied_Value]
		,CONCAT(FORMAT(GETDATE(), 'dd/MM/yyyy HH:mm:ss'),' - Automated Process - Address ' , [Prop_Details].[ADDONE], ' Postcode ', [Prop_Details].[POSTCODE], ' changed from ', CAST([Occ_Details].[OCCUPIED] AS INT), ' to ', (CAST([Occ_Details].[OCCUPIED] AS INT)) + (CAST(([Occ_Details].[OCCUPIED] + [Occ_Details].[OCCUPIED] * @Rate / 100) - [Occ_Details].[OCCUPIED] AS INT))) AS [Note]
		,[CUSTOMER_NOTES].[NOTES_ID]
	FROM
		[Transactor_Live].[dbo].[Customer_Policy_Details] AS [CPD]
	INNER JOIN
		[Transactor_Live].[dbo].[USER_MLETPROP_PROPINFO] AS [Prop_Info] ON [Prop_Info].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]
	AND
		[Prop_Info].[HISTORY_ID] = [CPD].[HISTORY_ID]
	INNER JOIN
		[Transactor_Live].[dbo].[USER_MLETPROP_PRPDTAIL] AS [Prop_Details] ON [Prop_Details].[MLETPROP_PROPINFO_ID] = [Prop_Info].[MLETPROP_PROPINFO_ID]
	AND
		[Prop_Details].[HISTORY_ID] = [Prop_Info].[HISTORY_ID]
	INNER JOIN
		(
			SELECT
				[MLETPROP_PRPDTAIL_ID]
				,[HISTORY_ID]
				,[OCCUPIED]
				,[USERINSTANCE]
			FROM
				(
					SELECT
						ROW_NUMBER() OVER(PARTITION BY MLETPROP_PRPDTAIL_ID ORDER BY OCCUPANCYTYPE_ID ASC) AS Row#
						,[MLETPROP_PRPDTAIL_ID]
						,[HISTORY_ID]
						,[OCCUPIED]
						,[USERINSTANCE]
					FROM
						[Transactor_Live].[dbo].[USER_MLETPROP_OCCDTAIL]
					WHERE
						[OCCUPIED] <> 0
				) AS [Cases]
			WHERE
				[Row#] = 1
		) AS [Occ_Details] ON [Occ_Details].[MLETPROP_PRPDTAIL_ID] = [Prop_Details].[MLETPROP_PRPDTAIL_ID]
	AND
		[Occ_Details].[HISTORY_ID] = [Prop_Details].[HISTORY_ID]
	INNER JOIN
		[Transactor_Live].[dbo].[CUSTOMER_NOTES] ON [CUSTOMER_NOTES].[POLICY_DETAILS_ID] = [CPD].[POLICY_DETAILS_ID]
	WHERE
		[CPD].[SCHEMETABLE_ID] IN (SELECT * FROM [dbo].[tvfSplitStringByDelimiter](@Schemes, ','))
	AND
		[CPD].[LIVE] = 1
	AND
		[CPD].[POLICY_STATUS_ID] = '3AJPUL66'
	AND
		CAST([CPD].[POLICYENDDATE] AS DATE) <= (SELECT DATEADD(Day, 30, [job_rundate]) FROM [Transactor_Support].[dbo].[TGSL_Job_Log] WHERE [job_name] = 'Toledo PO BSI Change')
	ORDER BY
		[CPD].[POLICY_DETAILS_ID]
		,[CPD].[HISTORY_ID];

--SELECT
--	[Row_Number]
--	,[POLICY_DETAILS_ID]
--	,[HISTORY_ID]
--	,[MLETPROP_PRPDTAIL_ID]
--	,[PolicyNumber]
--	,[Current_BSI]
--	,[Increase]
--	,[New_BSI]
--	,[Occupied_Value]
--	,[Occupied_Increase]
--	,[New_Occupied_Value]
--	,[New_Note]
--	,[Note_ID]
--FROM
--	@Identified_Cases;

UPDATE
	[USER_MLETPROP_PRPDTAIL]
SET
	[USER_MLETPROP_PRPDTAIL].[BUILDINGSSI] = [Identified_Cases].[New_BSI]
FROM
	[USER_MLETPROP_PRPDTAIL]
INNER JOIN
	@Identified_Cases AS [Identified_Cases]
ON
	[USER_MLETPROP_PRPDTAIL].[MLETPROP_PRPDTAIL_ID] = [Identified_Cases].[MLETPROP_PRPDTAIL_ID]
AND
	[USER_MLETPROP_PRPDTAIL].[HISTORY_ID] = [Identified_Cases].[HISTORY_ID];

UPDATE
	[USER_MLETPROP_OCCDTAIL]
SET
	[USER_MLETPROP_OCCDTAIL].[OCCUPIED] = [Identified_Cases].[New_Occupied_Value]
FROM
	[USER_MLETPROP_OCCDTAIL]
INNER JOIN
	@Identified_Cases AS [Identified_Cases]
ON
	[USER_MLETPROP_OCCDTAIL].[MLETPROP_PRPDTAIL_ID] = [Identified_Cases].[MLETPROP_PRPDTAIL_ID]
AND
	[USER_MLETPROP_OCCDTAIL].[HISTORY_ID] = [Identified_Cases].[HISTORY_ID]
AND
	[USER_MLETPROP_OCCDTAIL].[USERINSTANCE] = [Identified_Cases].[Occ_ID]; 

DECLARE @Min_Record INT
DECLARE @Max_record INT

SET @Min_Record = (SELECT MIN([Row_Number]) FROM @Identified_Cases);
SET @Max_record = (SELECT MAX([Row_Number]) FROM @Identified_Cases);

WHILE @Min_Record <= @Max_record
BEGIN

	SELECT @Min_Record, @Max_record

	UPDATE
		[dbo].[CUSTOMER_NOTES]
	SET
		[CUSTOMER_NOTES].[NOTES] = CONCAT([Identified_Cases].[New_Note], '
' , [CUSTOMER_NOTES].[NOTES])
	FROM
		[CUSTOMER_NOTES]
	INNER JOIN
		@Identified_Cases AS [Identified_Cases]
	ON
		[CUSTOMER_NOTES].[NOTES_ID] = [Identified_Cases].[Note_ID]
	WHERE
		[Identified_Cases].[Row_Number] = @Min_Record

	SET @Min_Record += 1;

	IF @Min_Record = @Max_record
	BEGIN
		SET @SuccessFlag = 1;
	END

END;

IF @SuccessFlag = 1
BEGIN
	UPDATE
		[Transactor_Support].[dbo].[TGSL_Job_Log]
	SET
		[job_rundate] = CAST(GETDATE() AS DATE)
		,[job_runtime] = CAST(GETDATE() AS TIME)
		,[job_qualcases] = (SELECT COUNT(*) FROM @Identified_Cases)
	WHERE
		[job_name] = 'Toledo PO BSI Change';
END