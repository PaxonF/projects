SELECT created_at,
agent_one,
SUM (CASE 
  WHEN (agent_one = 'Meital' AND agent_two <> 'NA' AND agent_two <> 'Co-broke' AND (agent_one_commission + agent_two_commission > 0.5*total_gross_commission AND agent_one_commission + agent_two_commission < total_gross_commission)) THEN (agent_one_commission - (0.1*total_gross_commission))/((agent_one_commission+agent_two_commission)-(0.1*total_gross_commission)) 
  WHEN (agent_one = 'Meital' AND agent_two <> 'NA' AND agent_two <> 'Co-broke' AND (agent_one_commission + agent_two_commission = 0.5*total_gross_commission OR agent_one_commission + agent_two_commission = total_gross_commission)) THEN ((agent_one_commission)/(agent_one_commission+agent_two_commission))
  END) AS deal_count_one,
SUM (CASE 
  WHEN (agent_one = 'Meital' AND agent_two <> 'NA' AND agent_two <> 'Co-broke' AND (agent_one_commission + agent_two_commission > 0.5*total_gross_commission AND agent_one_commission + agent_two_commission < total_gross_commission)) THEN (agent_one_commission - (0.1*total_gross_commission))/((agent_one_commission+agent_two_commission)-(0.1*total_gross_commission))*total_gross_commission 
  WHEN (agent_one = 'Meital' AND agent_two <> 'NA' AND agent_two <> 'Co-broke' AND (agent_one_commission + agent_two_commission = 0.5*total_gross_commission OR agent_one_commission + agent_two_commission = total_gross_commission)) THEN (total_gross_commission * (agent_one_commission)/(agent_one_commission+agent_two_commission))
  END) AS commission_one


FROM
(SELECT created_at,
CASE WHEN `custom_attributes.1.value` = 'Blue Magic' THEN 'Office' ELSE `custom_attributes.1.value` END AS agent_one,
1.0*REPLACE(`custom_attributes.7.value`,'$','') AS agent_one_commission,
`custom_attributes.22.value` AS agent_two,
1.0*`custom_attributes.28.value`AS agent_two_commission,
1.0*total_gross_commission AS total_gross_commission
FROM report
WHERE `status` <> 'cancelled')

GROUP BY 1

UNION ALL


SELECT created_at,
agent_two,
SUM (CASE 
  WHEN (agent_two = 'Meital' AND agent_one <> 'NA' AND agent_one <> 'Co-broke' AND (agent_one_commission + agent_two_commission > 0.5*total_gross_commission AND agent_one_commission + agent_two_commission < total_gross_commission)) THEN (agent_two_commission - (0.1*total_gross_commission))/((agent_one_commission+agent_two_commission)-(0.1*total_gross_commission)) 
  WHEN (agent_two = 'Meital' AND agent_one <> 'NA' AND agent_one <> 'Co-broke' AND (agent_one_commission + agent_two_commission = 0.5*total_gross_commission OR agent_one_commission + agent_two_commission = total_gross_commission)) THEN ((agent_two_commission)/(agent_one_commission+agent_two_commission))
  END) AS deal_count_two,
SUM (CASE 
  WHEN (agent_two = 'Meital' AND agent_one <> 'NA' AND agent_one <> 'Co-broke' AND (agent_one_commission + agent_two_commission > 0.5*total_gross_commission AND agent_one_commission + agent_two_commission < total_gross_commission)) THEN (agent_two_commission - (0.1*total_gross_commission))/((agent_one_commission+agent_two_commission)-(0.1*total_gross_commission))*total_gross_commission 
  WHEN (agent_two = 'Meital' AND agent_one <> 'NA' AND agent_one <> 'Co-broke' AND (agent_one_commission + agent_two_commission = 0.5*total_gross_commission OR agent_one_commission + agent_two_commission = total_gross_commission)) THEN (total_gross_commission * (agent_two_commission)/(agent_one_commission+agent_two_commission))
  END) AS commission_two


FROM
(SELECT created_at,
CASE WHEN `custom_attributes.1.value` = 'Blue Magic' THEN 'Office' ELSE `custom_attributes.1.value` END AS agent_one,
1.0*REPLACE(`custom_attributes.7.value`,'$','') AS agent_one_commission,
`custom_attributes.22.value` AS agent_two,
1.0*`custom_attributes.28.value`AS agent_two_commission,
1.0*total_gross_commission AS total_gross_commission
FROM report
WHERE `status` <> 'cancelled')

GROUP BY 1