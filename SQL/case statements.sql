SELECT
	case `column` when '______'
				  then ('______')(`column`)  -> This is like the replace part of the statement
				  (else (`_______` ('____')) -> still gives me everything
				  end as variable -> Names the new replacement (an alias)

replaces contents in column

#Example from sports
SELECT
case when `CampaignName` LIKE '%Basketball%' AND `CampaignName` LIKE '%NB%' then 'Basketball - NB'
	when `CampaignName` LIKE '%Basketball%' AND `CampaignName` LIKE '%Brand%' then 'Basketball - Branded'
	when `CampaignName` LIKE '%Baseball%' AND `CampaignName` LIKE '%NB%' then 'Baseball - NB'
	when `CampaignName` LIKE '%Baseball%' AND `CampaignName` LIKE '%Brand%' then 'Baseball - Branded'
	when `CampaignName` LIKE '%Soccer%' AND `CampaignName` LIKE '%NB%' then 'Soccer - NB'
	when `CampaignName` LIKE '%Soccer%' AND `CampaignName` LIKE '%Brand%' then 'Soccer - Branded'
	when `CampaignName` LIKE '%Football%' AND `CampaignName` LIKE '%NB%' then 'Football - NB'
	when `CampaignName` LIKE '%Football%' AND `CampaignName` LIKE '%Brand%' then 'Football - Branded'
	when `CampaignName` LIKE '%Lacrosse%' AND `CampaignName` LIKE '%NB%' then 'Lacrosse - NB'
	when `CampaignName` LIKE '%Lacrosse%' AND `CampaignName` LIKE '%Brand%' then 'Lacrosse - Branded'
	when `CampaignName` LIKE '%Tennis%' AND `CampaignName` LIKE '%NB%' then 'Tennis - NB'
	when `CampaignName` LIKE '%Tennis%' AND `CampaignName` LIKE '%Brand%' then 'Tennis - Branded'
	when `CampaignName` LIKE '%Track & Field%' AND `CampaignName` LIKE '%NB%' then 'Track & Field - NB'
	when `CampaignName` LIKE '%Track & Field%' AND `CampaignName` LIKE '%Brand%' then 'Track & Field - Branded'
	when `CampaignName` LIKE '%Golf%' AND `CampaignName` LIKE '%NB%' then 'Golf - NB'
	when `CampaignName` LIKE '%Golf%' AND `CampaignName` LIKE '%Brand%' then 'Golf - Branded'
	else 'Main'
	end as CampaignName,


SUM(`Impressions`) as Impressions, SUM(`Clicks`) as Clicks, AVG(`Ctr`) as CTR, SUM(`Spend`) as Spend, SUM(`Conversions`) as Conversions, AVG(`ConversionRate`) as ConversionRate, AVG(`CostPerConversion`) as CostPerConversion, SUM(`Revenue`) as Revenue

FROM
report

GROUP BY 1
;


##
SELECT
	case `lname` when 'Ashby'
				 then 'Villanueva'
				 else `lname`
				 end as Newlname

SELECT
	case when `fname` = 'Emily' and `lname` = 'Ashby' -> Creates new column 
		 then 'Villanueva' as Newlname
		 end

SELECT
	case `lname` when 'Ashby'
				 then 'Villanueva'
				 else 'lname'
				 end as Newlname
FROM report
WHERE ID = 001
;

SELECT
	case 'wkd' when '0'
			   then 'Sunday'
			   when '1'
			   then 'Monday'
			   .
			   .
			   .
			   (use an else statment for an error check)
			   end as weekday

SELECT
	sum(case when `status` = 'open' 
	or `status` = 'closed'
	then `$$$`
	else 'other'
	end)


(SELECT
	case `status` when 'open'
				  then 'open'
				  when 'closed'
				  then 'closed'
				  else 'other'
				  end)


#Trim Example
SELECT 
	r2.name, sum(r1.hours)
FROM
	report1 r1 LEFT JOIN report2 r2 on TRIM(report1.id) = TRIM(report2.id)

#Case Statments realistic example
SELECT
	`date`, 
	sum(case when `salesrep` = 'Jake'
		 	 then `$$$`
		 	 end) as `Jake`
	sum(case when `salesrep` = 'Jason'
			 then `$$$`
			 end) as `Jason`
	sum(case when `salesrep` = 'Jason'
			 then `$$$`
			 end) as `Parker`
FROM	
	report
GROUP BY 1
ORDER BY 1
;
#Change to counts to count how many sales instead of showing sum of the sales


#Concatonating
SELECT
	`fname`||`lname` as Name
FROM
...
#With space
SELECT
	`fname`||' '||`lname` as name
FROM
...

SELECT
	sum(case when `salesrep` in ('Josh', `Jake`, `Ryan`, `Jason`) then `$$` end) as SalesfromReps, ...

	-> use not in for the opposite


#Coalesce
coalesce(`column`, What to insert for null values)

SELECT
	coalesce(sum(case when `salesrep` = 'Jake'
			 then `$$`
			 end), '0')
