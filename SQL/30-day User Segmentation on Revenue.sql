/*The following query retroactively calculates revenue segments for our merchants based on a
log-transformed Normal Distribution on their weighted average Revenue over the last 360 days.*/

/* Results:
id  -3 sd -2 sd -1 sd mean  +1 sd +2 sd +3 sd
1 61.767260107990019  270.10063461542222  1181.1168682584428  5164.878855138305 22585.38024910992 98763.091120599871  431878.85526436154
*/

select
--Calcuate segments by converting log transformed values to original values. Each segment is a Standard Deviation.
  1 as id
  , power(10, mean - 3 * std_dev) as "-3 SD"
  , power(10, mean - 2 * std_dev) as "-2 SD"
  , power(10, mean - 1 * std_dev) as "-1 SD"
  , power(10, mean) mean
  , power(10, mean + 1 * std_dev) as "+1 SD"
  , power(10, mean + 2 * std_dev) as "+2 SD"
  , power(10, mean + 3 * std_dev) as "+3 SD"
from
  (
    select
    --Use weighted average of each merchant. Log transform and take summary statistics.
      avg(dlog10(weighted_average)) as mean
      , median(dlog10(weighted_average)) as median
      , stddev_pop(dlog10(weighted_average)) as std_dev
      , min(dlog10(weighted_average)) as min
      , max(dlog10(weighted_average)) as max
    from
      (
        select
        --Calculate Weighted Average of Revenue
          merchant_id
          , act_date
          , last_txn_date
          , sum(weighted_sum) as weighted_average
        from
          (
            select
            --Calculate Weighted Sum of Revenue
              merchant_id
              , act_date
              , last_txn_date
              , tpv
              , num_txn
              , segment_30_day
              , start_date
              , end_date
              , (num_txn::float / (sum(num_txn) over(partition by merchant_id) )::float * tpv) as weighted_sum
            from
              (
                --
                select
                  --Determine all transactions (total revenue and num transactions) as well as which 30-day period it belongs
                  --to in a merchant's life-span in the last 360 days
                  a.merchant_id
                  , act_date
                  , last_txn_date
                  , floor(date_diff('day', act_date, CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at) )::float / 30) as segment_30_day
                  , date_trunc('day', dateadd('day', (30 * (date_diff('day', act_date, CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at)) / 30)), act_date)) as start_date
                  , date_trunc('day', dateadd('day', 29, dateadd('day', (30 * (date_diff('day', act_date, CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at)) / 30)), act_date))) as end_date
                  , sum(amount) as tpv
                  , count(*) as num_txn
                from
                  datawarehouse.clipdw_transaction.payment as a
                  left join (
                    select
                      --Find Merchant's Activation date and date of last transaction
                      merchant_id
                      , min(CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at)) as act_date
                      , max(CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at)) as last_txn_date
                    from
                      datawarehouse.clipdw_transaction.payment
                    where
                      status_code = 1
                      and amount > 1
                    group by
                      1
                  )
                  b on
                    a.merchant_id = b.merchant_id
                where
                  status_code = 1
                  and amount > 1
                group by
                  1
                  , 2
                  , 3
                  , 4
                  , 5
                  , 6
                order by
                  2
                  , 4
              )
            where
              (
                end_date between dateadd('day', -360, date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', getdate())))
                and dateadd('day', -1, date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', getdate())))
              )
          )
        group by
          1
          , 2
          , 3
      )
    where
      --Based on prior QQPlots, this seems like a good place to 
      weighted_average between 101
      and 320000
  )