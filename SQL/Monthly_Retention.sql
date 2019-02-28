--Calculate percent of merchants who were retained for each act_month by dividing number of merchants by the original value in each act_month 
--Calculate the diff between act_month and the transaction month to know how many months had passed
select
   date(act_month) as act_month,
   date_diff('month', act_month, Transacted_Month) as Months_Passed, 
   (Merchants_Transacted::numeric/(first_value(Merchants_Transacted) over (partition by act_month order by Transacted_Month rows UNBOUNDED PRECEDING))) as monthly_retention
from
(
    --Find count of number of merchants who transacted for each transacted month, act_month
    select 
          act_month,
          Transacted_Month,
          count(merchant_id) as Merchants_Transacted
    from
    (
        --Grab Merchant, Activation Month, and all transacted months          
        select 
            distinct merchant_id, 
            date_trunc('month', CONVERT_TIMEZONE ( 'UTC' , 'America/Mexico_City' , created_at)) as Transacted_Month, 
            min(date_trunc('month', CONVERT_TIMEZONE ( 'UTC' , 'America/Mexico_City' , created_at))) over (partition by merchant_id) as act_month
            
        from clipdw_transaction.payment
        where status_code = 1
    )
    group by 1,2
)
--Exclude Current Month
where Transacted_Month < date_trunc('month', CONVERT_TIMEZONE ( 'UTC' , 'America/Mexico_City' , getdate()))
order by act_month, Transacted_Month