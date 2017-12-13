 AND `created_at` BETWEEN DATE('now','-4 hours','start of month') AND DATE('now','-4 hours')




 SELECT 

FROM

(SELECT Manufacturer, Count(*) as Count
FROM 

(SELECT case when `Manufacturer` is null THEN 'No Manufacturer Listed'
else `Manufacturer` end as `Manufacturer`
FROM report1) 
GROUP BY 1
ORDER BY 2 desc)
;

SELECT
FROM

(SELECT Manufacturer, Count(*) as Count
FROM 

(SELECT case when `Manufacturer` is null THEN 'OTHER'
	WHEN `Manufacturer` <> '' THEN 'OTHER'
 end as `Manufacturer`
FROM report1

LIMIT 1000000 OFFSET 7

) T1

GROUP BY 1
ORDER BY 2 desc) T2,
report
;


#OFFICIAL
SELECT case when `Manufacturer` is null THEN 'Other'
 when `Manufacturer` <> '' THEN 'Other' 
 end as `Manufacturer`, Sum(Count) as Count

 FROM

(SELECT `Manufacturer`, COUNT(*) as Count
 FROM report1
 GROUP BY 1
 ORDER BY 2 desc
 LIMIT 1000000000 OFFSET 8
) t1

GROUP BY 1

UNION ALL

SELECT `Manufacturer`, COUNT(*) as Count
 FROM report1
 WHERE `Manufacturer` <> ''
 GROUP BY 1
 ORDER BY 2 desc
 LIMIT 8
;

#other
SELECT case when `Manufacturer` is null THEN 'Other'
 when `Manufacturer` <> '' THEN 'Other' 
 end as `Manufacturer`, Sum(Count) as Count

 FROM

(SELECT `Manufacturer`, COUNT(*) as Count
 FROM report1
 GROUP BY 1
 ORDER BY 2 desc
 LIMIT 1000000000 OFFSET 6
) t1

GROUP BY 1

UNION ALL

SELECT `Manufacturer`, COUNT(*) as Count
 FROM report1
 WHERE `Manufacturer` <> ''
 GROUP BY 1
 ORDER BY 2 desc
 LIMIT 6
;



SELECT COUNT(*) AS COUNT, `Quote-Need Differential`
from report1
GROUP BY 2
ORDER BY 1 DESC
limit 2
;

SELECT
       (SELECT `Quote-Need Differential`
        FROM report1
        GROUP BY `Quote-Need Differential`
        ORDER BY COUNT(*) DESC
        LIMIT 1)
FROM report1


