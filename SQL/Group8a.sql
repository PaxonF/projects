select 
r1.Month, 
r1.LastYearRev as Previous_Revenue,
r1.CurrentYearRev as Current_Revenue,
r2.LastYearSpend as Adwords_Prior_Spend,
r2.CurrentYearSpend as Adwords_Curr_Spend,
r3.LastYearSpend as Facebook_Prior_Spend,
r3.CurrentYearSpend as Facebook_Curr_Spend


from report1 r1
left join report2 r2 on r2.Month=r1.Month
left join report3 r3 on r3.Month=r1.Month

WHERE r1.Month <= date('now','-1 years') OR r1.Month >=date('now','start of year')
;


select 
r1.Date,
r1.Transaction_Revenue as Analytics_Current,
r4.Transaction_Revenue as Analytics_Previous,
r2.Cost as Adwords_Current,
r5.Cost as Adwords_Previous,
r3.Spend as Facebook_Current

from report1 r1
left join report2 r2 on r2.Date=r1.Date
left join report3 r3 on r3.Date=r1.Date
left join report4 r4 on strftime('%m',`r4.Date`)= strftime('%m',`r1.Date`)
left join report5 r5 on strftime('%m',`r5.Date`)= strftime('%m',`r1.Date`)
;