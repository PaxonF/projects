SELECT
SUM(`Open`) + SUM(`Pending`) as `Total Unresolved`, date('now') as Date


FROM

(SELECT
created_at,
count(case `status` when 'open' then 1 end) as `Open`,
count(case `status` when 'closed' then 1 end) as `Closed`,
count(case `status` when 'pending' then 1 end) as `Pending`,
count(case `status` when 'solved' then 1 end) as `Solved`
FROM 
report
GROUP BY 1)