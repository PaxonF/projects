SELECT EndDate, `Total Delivery Revenue`, 
POWER((LAST(`Total Delivery Revenue`)/FIRST(`Total Delivery Revenue`), 1.0/COUNT(`Total Delivery Revenue`)) - 1.0 as CAGR

FROM report1 

WHERE EndDate >= date('now','start of year');


SELECT EndDate, `Total Delivery Revenue`, 
LAST(`Total Delivery Revenue`) as CurrentMonth

FROM report1 

WHERE EndDate >= date('now','start of year');


select SUBSTR(`Created Date`,7,4)
|| SUBSTR(`Created Date`,3,4) || SUBSTR(`Created Date`,1,2) as "Created Date", 
`Converted Date` as "Converted_Date", Stage, `Opportunity Amount` as "OppAmount" 

from report