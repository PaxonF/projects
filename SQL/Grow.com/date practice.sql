YYYY-MM-DD:T:00:00:00:0000

SELECT
	Sum($$) as Monies, strftime('%w', `odate`) as wkdnumber

	also could use:

	odate (group by the strftime function)
FROM
	report
group by
	2
order by
	2
;


#Joins

T1
Sales Reps
*Name
*ID
*Email

T2
Money
*SID
*$$
*Dates

SELECT
	r1.name, sum(r2.monies)
FROM 
	report1 r1, report2 r2
WHERE 
	r1.ID = r2.SID
GROUP BY 1
ORDER BY 2 DESC
;

SELECT
	r1.name, r2.monies
FROM 
	report1 r1 JOIN report2 r2 on r1.ID = r2.SID
GROUP BY 1
ORDER BY 2 DESC
;

#Left Join
SELECT
	r1.name,
	r2.monies
FROM
	report1 r1 LEFT JOIN report2 r2 on r1.ID = r2.SID
;

#UNION (ALL) (Sales Table and CS Table)
SELECT *
FROM report1 
UNION ALL 
SELECT *
FROM report2
;

(SELECT r1.name, r1.monies, r1.date
FROM report1 r1
UNION ALL 
SELECT r2.csname, r2.monies, r2.date
FROM report2 r2) T1
GROUP BY 1
ORDER BY 2 DESC
;

Using just union will remove duplicates FROM EVERYTHING;

