select
  *
  , p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 as total_matches
from
  (
    select
      t1.merchant_id
      --, t3.ofac_id
      , trim(lower(t1.first_name)) as first_name
      , trim(lower(t1.last_name)) || ' ' || trim(lower(t1.second_last_name)) as last_names
      , lower(t3.ofac_fn) as ofac_fn
      , lower(t3.ofac_ln) as ofac_ln
      , case
        when trim(lower(t1.first_name)) = lower(t3.ofac_fn)
          then 1
        else 0
      end as p1
      , case
        when(trim(lower(t1.last_name)) || ' ' || trim(lower(t1.second_last_name))) = lower(t3.ofac_ln)
          then 1
        --when (trim(lower(t1.first_name)) || ' ' || trim(lower(t1.last_name)) || ' '|| trim(lower(t1.second_last_name))) = lower(t2.concat_name) then 2
        --when trim(lower(x1.last_name)) = lower(x4.first_last_name) or trim(lower(x1.second_last_name)) = lower(x4.second_last_name) then .075 
        else 0
      end as p2
      , lower(t3.name) as name
      , lower(t3.address1) as address1
      , t3.ofac_address
      , t3.p3
      , t3.address2
      , t3.ofac_address2
      , t3.p4
      , t3.colony
      , t3.ofac_colony
      , t3.p5
      , t3.municipality
      , t3.ofac_municipality
      , t3.p6
      , t3.state
      , t3.ofac_state
      , t3.p7
      , t3.postal_code
      , t3.ofac_pc
      , t3.p8
    from
      clipdw_provisioning.users as t1 /*left join [ofac_names as t2] on (
                                 trim(lower(t1.last_name)) || ' '|| trim(lower(t1.second_last_name)) = t2.last_name or
                                 trim(lower(t1.first_name)) = lower(t1.first_name) or
                                 trim(lower(t1.first_name)) || ' ' || trim(lower(t1.last_name)) || ' '|| trim(lower(t1.second_last_name)) = lower(t2.concat_name)
                                )*/
      full join (
        select
          x1.addressable_id as m_id
          , x2.id as ofac_id
          , trim(lower(x3.name)) as name
          , lower(x2.ofac_fn) as ofac_fn
          , lower(x2.ofac_ln) as ofac_ln
          , trim(lower(x1.address1)) as address1
          , lower(x2.ofac_address) as ofac_address
          , case
            when lower(trim(x1.address1)) = lower(x2.ofac_address)
              then 1
            else 0
          end as p3
          , trim(lower(x1.address2)) as address2
          , lower(x2.ofac_address2) as ofac_address2
          , case
            when lower(trim(x1.address2)) = lower(x2.ofac_address2)
              then 1
            else 0
          end as p4
          , trim(lower(x1.colony)) as colony
          , lower(x2.ofac_colony) as ofac_colony
          , case
            when lower(trim(x1.colony)) = lower(x2.ofac_colony)
              then 1
            else 0
          end as p5
          , trim(lower(x1.municipality)) as municipality
          , lower(x2.ofac_municipality) as ofac_municipality
          , case
            when lower(trim(x1.municipality)) = lower(x2.ofac_municipality)
              then 1
            else 0
          end as p6
          , trim(lower(x1.state)) as state
          , lower(x2.ofac_state) as ofac_state
          , case
            when lower(trim(x1.state)) = lower(x2.ofac_state)
              then 1
            else 0
          end as p7
          , trim(lower(x1.postal_code)) as postal_code
          , x2.ofac_pc
          , case
            when lower(trim(x1.postal_code)) = lower(x2.ofac_pc)
              then 1
            else 0
          end as p8
        from
          datawarehouse.clipdw_provisioning.addresses as x1
          left join datawarehouse.clipdw_provisioning.merchants x3 on
            x3.id = x1.addressable_id
          inner join (
            -- hello world
            select
              first_name as ofac_fn
              , last_name as ofac_ln
              , address as ofac_address
              , address2 as ofac_address2
              , colony as ofac_colony
              , municipality as ofac_municipality
              , state as ofac_state
              , zip_code as ofac_pc
              , name_id as id
              -- load please
              -- load the sucker
            from
              [ofac_all]
              --ddfd
          )
          x2 on
            (
              lower(trim(x1.address1)) = lower(x2.ofac_address)
              or lower(trim(x1.address2)) = lower(x2.ofac_address2)
              or lower(trim(x1.colony)) = lower(x2.ofac_colony)
              or lower(trim(x1.municipality)) = lower(x2.ofac_municipality)
              or lower(trim(x1.state)) = lower(x2.ofac_state)
              or lower(trim(x1.postal_code)) = lower(x2.ofac_pc)
            )
      )
      on
        t3.m_id = t1.merchant_id
        --and t2.id = t3.id
  )
  as ta
where
[(p1+p2+p3+p4+p5+p6+p7+p8)=total_matches]
and address1 is not null
and ofac_address != ''
and address2 is not null
and ofac_address2 != ''
--and [ta.merchant_id=merchant_id]
order by
total_matches desc
, merchant_id