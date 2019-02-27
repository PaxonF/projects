SELECT
Title as 'Date',
(`Expenses.Rent Expense` / `Income.Total Income`) as 'Rent',
(`Expenses.Associate` / `Income.Total Income`) as 'Associate',
(`Expenses.Bank Service Charges` / `Income.Total Income`) as 'Bank Service Charges',
(`Expenses.Guaranteed Payments` / `Income.Total Income`) as 'Garanteed Payments',
(`Expenses.Guaranteed Payments.Eric Smith, DDS, PC` / `Income.Total Income`) as 'GP - Eric Smith',
(`Expenses.Health Insurance` / `Income.Total Income`) as 'Health Insurance',
(`Expenses.Laboratory Fees` / `Income.Total Income`) as 'Laboratory Fees',
(`Expenses.Marketing` / `Income.Total Income`) as 'Marketing',
(`Expenses.Petty Cash` / `Income.Total Income`) as 'Petty Cash',
(`Expenses.Taxes` / `Income.Total Income`) as 'Taxes'

FROM 
report
;