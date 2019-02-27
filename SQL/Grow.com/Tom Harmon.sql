SELECT
`fields.timespent`,
REPLACE(REPLACE(REPLACE(REPLACE(`fields.fixVersions`,"[",""),"]",""),"{",""),"}",""),
`fields.components`
FROM
report
;

SELECT
`fields.timespent`,
`fields.fixVersions`,
`fields.components`
FROM
report
;

select
	`fields.fixVersions`,
    `fields.timespent`,
    `fields.components`
From
report1
where
	instr(`fields.components`,'17-18 AY Maintenance')
;