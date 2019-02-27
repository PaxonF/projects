SELECT 
MIN(t1.date),
count(report1.created_at)
FROM

(SELECT
SUBSTR(_datesTable.date,1,10) as date
FROM _datesTable
WHERE SUBSTR(_datesTable.date,1,10) >= ‘2017-04-01’) 
t1
 
LEFT JOIN report1 on report1.created_at = t1.date
GROUP BY 1



#Used with Wilma Fernandez
SELECT 
min(t1.date) as Date,
report1.Count as Tweets, report2.Count as Retweets, report3.Count as Mentions, report4.`Sum of favorite_count`
 as Favorites
FROM

(SELECT
SUBSTR(_datesTable.date,1,10) as date
FROM _datesTable
WHERE SUBSTR(_datesTable.date,1,10) >= date('now', '-4 hours', '-30 days')) t1

LEFT JOIN report1 on report1.created_at = t1.date
LEFT JOIN report2 on report2.created_at = t1.date
LEFT JOIN report3 on report3.created_at = t1.date
LEFT JOIN report4 on report4.created_at = t1.date

GROUP BY date

