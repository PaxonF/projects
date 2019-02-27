
#Consultation Complete
SELECT substr(r1.date_moved, 1, 10) as date,
COUNT(CASE WHEN r1.stage_name IN('Closed - WON', 'Lost', 'Negotiating (Consult Complete)') 
AND r1.stage_name_from = 'Pre-Qual Consult Scheduled' THEN 1 end) as consult_complete

FROM report1 r1

group by substr(r1.date_moved, 1, 10)
;


SELECT substr(r1.date_moved, 1, 10) as date,
COUNT(CASE WHEN r1.stage_name IN('Closed - WON', 'Lost', 'Negotiating (Consult Complete)') 
AND r1.stage_name_from = 'Consultation Scheduled' THEN 1 end) as consult_complete

FROM report1 r1

group by substr(r1.date_moved, 1, 10)


#Dates problem.

SELECT ro.date_created, rom.date_moved, rl.contact_id, rosg.stage_name as stage_name, rosf.stage_name as stage_name_from, 
rost.status_name, rl.region, u.name, u.is_sales, u.active, rl.business_level, ro.opp_from

FROM reporting_opps_moves rom 
LEFT JOIN reporting_opps_stages rosg ON rom.stage_to = rosg.stage_id 
LEFT JOIN reporting_opps_stages rosf ON rom.stage_from = rosf.stage_id 
LEFT JOIN reporting_opps ro ON rom.opp_id = ro.opp_id 
LEFT JOIN reporting_opps_statuses rost ON ro.status_id = rost.status_id 
LEFT JOIN reporting_leads rl ON ro.contact_id = rl.contact_id 
LEFT JOIN users u ON rom.user_id_to = u.isUID

where rosg.stage_name <> rosf.stage_name AND rom.date_moved > DATE_SUB(now(), INTERVAL 18 MONTH)
;






#For the days average metrics
SELECT rom.date_moved, rl.contact_id, rosg.stage_name as stage_name, rosf.stage_name as stage_name_from, rost.status_name, rl.region, u.name, u.is_sales, u.active, rl.business_level, ro.opp_from

FROM reporting_opps_moves rom 
LEFT JOIN reporting_opps_stages rosg ON rom.stage_to = rosg.stage_id 
LEFT JOIN reporting_opps_stages rosf ON rom.stage_from = rosf.stage_id 
LEFT JOIN reporting_opps ro ON rom.opp_id = ro.opp_id 
LEFT JOIN reporting_opps_statuses rost ON ro.status_id = rost.status_id 
LEFT JOIN reporting_leads rl ON ro.contact_id = rl.contact_id 
LEFT JOIN users u ON rom.user_id_to = u.isUID

where rosg.stage_name <> rosf.stage_name AND rom.date_moved > DATE_SUB(now(), INTERVAL 18 MONTH)


#masterreport
SELECT t1.contact_id, t2.`Date Started`, t1.`Date Completed`, julianday(t1.`Date Completed`) - julianday(t2.`Date Started`) as `Time Taken`

FROM

(SELECT r1.contact_id,
CASE r1.`stage_name_from` WHEN 'Negotiating (Consult Complete)' THEN r1.`date_moved` end as `Date Completed`
FROM 
report1 r1
WHERE r1.`stage_name_from` = 'Negotiating (Consult Complete)') t1

LEFT JOIN

(SELECT r1.contact_id, 
CASE r1.`stage_name` WHEN 'Negotiating (Consult Complete)' THEN julianday(r1.`date_moved`) end as `Date Started`
FROM
report1 r1
WHERE r1.`stage_name` = 'Negotiating (Consult Complete)') t2 
ON t1.contact_id = t2.contact_id
;
