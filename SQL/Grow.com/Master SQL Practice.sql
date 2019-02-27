SELECT
	SUBSTR(_DatesTable.date,1,10) AS OrderDate.
	COALESCE(SUM(report1.Monies),'0') AS myMonies

FROM 
	_DatesTable LEFT JOIN report1
	ON
	SUBSTR(_DatesTable.Date,1,10) = report1.dateofsale

WHERE
	_DatesTable.Date >= DATE('now','-90 days')

GROUP BY 1
ORDER BY 1
;