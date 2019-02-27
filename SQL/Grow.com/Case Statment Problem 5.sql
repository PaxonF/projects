SELECT
	Name,
    Last_Logged_In__c,
    COUNT(CASE WHEN julianday('now') - julianday(Last_Logged_In__c) <= 5
          	   	THEN '1-5' END) as 'Risk'
    
FROM
	report
    
WHERE 
	Last_Logged_In__c IS NOT NULL
    
;


#Option 2
SELECT
	Name,
    Last_Logged_In__c,
    COUNT(CASE WHEN julianday('now') - 		             julianday(Last_Logged_In__c) <= 5
          	   	THEN '1-5' END) as 'Risk',
    COUNT(CASE WHEN julianday('now') - 		             julianday(Last_Logged_In__c) <= 10
          	   	THEN '6-10' END) as 'Risk',
    COUNT(CASE WHEN julianday('now') - 		             julianday(Last_Logged_In__c) <= 15
          	   	THEN '11-15' END) as 'Risk',
                
    COUNT(CASE WHEN julianday('now') - 		             julianday(Last_Logged_In__c) <= 20
          	   	THEN '16-20' END) as 'Risk',
                
    COUNT(CASE WHEN julianday('now') - 		             julianday(Last_Logged_In__c) <= 25
          	   	THEN '21-25' END) as 'Risk'
                
                
                
FROM
	report
    
WHERE 
	Last_Logged_In__c IS NOT NULL
    
;

#Fixed Version - No Julian Days
SELECT
	Name,
    Last_Logged_In__c,
    Days_Since_Last_Usage__c,
    case when Days_Since_Last_Usage__c <= 5
    	 then '1-5' end as Risk,
    case when Days_Since_Last_Usage__c >= 6 and 
    	 Days_Since_Last_Usage__c <=10
    	 then '6-10' end as Risk,
    case when Days_Since_Last_Usage__c >= 11 and 
    	 Days_Since_Last_Usage__c <=15
    	 then '11-15' end as Risk,
    case when Days_Since_Last_Usage__c >= 16 and 
    	 Days_Since_Last_Usage__c <=20
    	 then '16-20' end as Risk,
    case when Days_Since_Last_Usage__c >= 21 and 
    	 Days_Since_Last_Usage__c <=25
    	 then '21-25' end as Risk,
    case when Days_Since_Last_Usage__c >= 26 and 
    	 Days_Since_Last_Usage__c <=30
    	 then '26-30' end as Risk
              
FROM
	report
    
WHERE 
	Last_Logged_In__c IS NOT NULL
;





#Similar
SELECT Account.Name, 
count(case when julianday(Account.Last_Logged_In__c)

FROM Account

WHERE Account.Last_Logged_In__c != NULL 

