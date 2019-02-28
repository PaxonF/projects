--Count number of distinct merchants per month (Monthly Active Users)
select date, count(distinct merchant_id) as MAU
from 
    (     
      --Table of merchants and their transaction dates
      select distinct merchant_id,
                      Date_trunc('day',CONVERT_TIMEZONE ( 'UTC' , 'America/Mexico_City' , created_at)) as transaction_date
      from datawarehouse.clipdw_transaction.payment
      where status_code = 1
     ) as x1
left join 
    (
      --Table of dates
      select distinct Date_trunc('day',CONVERT_TIMEZONE ( 'UTC' , 'America/Mexico_City' , created_at)) as date
      from datawarehouse.clipdw_transaction.payment 
      where status_code = 1
     ) x2 --Join on all days previously transacting per merchant to get a count of merchants who transacted
       on x1.transaction_date between dateadd('day', -29, x2.date) and x2.date
group by 1
order by 1