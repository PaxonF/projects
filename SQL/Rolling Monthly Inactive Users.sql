--Calculate inactive merchants by subtracting active merchants from total merchants activated.
select
  x1.date
  , active_merchants
  ,(merchants_activated-active_merchants) as inactive_merchants
from
  (
    --Get Count of New Merchants by day
    select
      date
      , count(*) as merchants_activated
    from
      (
        select
          *
        from
          (
            select
              date
            from
              dim_calendar
            where
              date < date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', getdate()))
          )
          x1
          left join (
            select
              merchant_id
              , min(date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at))) as act_date
            from
              datawarehouse.clipdw_transaction.payment
            where
              status_code = 1
            group by
              1
          )
          x2 on
            x1.date >= x2.act_date
        where
          act_date is not null
          and merchant_id is not null
        order by
          date
      )
    group by
      1
    order by
      1
  )
  x1
  left join (
    --Get count of active merchants (mau) by day
    select
      date
      , count(distinct merchant_id) as active_merchants
    from
      (
        select
          *
        from
          (
            select distinct
              (
                merchant_id
              )
              , date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', created_at)) as TXN_Date
              , dateadd('day', 29, TXN_Date) as count_until
            from
              datawarehouse.clipdw_transaction.payment
            where
              status_code = 1
            order by
              txn_date
          )
          as x1
          left join (
            select
              convert(datetime, date) as date
            from
              datawarehouse.dim_calendar
            where
              date < date_trunc('day', CONVERT_TIMEZONE('UTC', 'America/Mexico_City', getdate()))
            order by
              1
          )
          as x2 on
            x2.date >= x1.txn_date
            and x2.date <= x1.count_until
            --group by 1
        order by
          x2.date
      )
    group by
      1
    order by
      1
  )
  x2 on
    x1.date = x2.date
order by
  1