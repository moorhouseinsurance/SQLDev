SELECT
	*
FROM
	[Transactor_Live].[dbo].[LIST_ENDORSEMENT]
WHERE
	[ENDORSEMENT_CODE_ID] = 'TOMDPT';

UPDATE
	[Transactor_Live].[dbo].[LIST_ENDORSEMENT]
SET
	[ENDORSEMENT_CODE_TEXT] = 'This Policy does not provide indemnity in respect of liability arising out of or in connection with any damp proofing or timber treatment

Subject otherwise to the Policy terms conditions limitations and exclusions '
WHERE
	[ENDORSEMENT_CODE_ID] = 'TOMDPT';

SELECT
	*
FROM
	[Transactor_Live].[dbo].[LIST_ENDORSEMENT]
WHERE
	[ENDORSEMENT_CODE_ID] = 'TOMDPT';