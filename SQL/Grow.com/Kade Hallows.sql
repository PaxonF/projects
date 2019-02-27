SELECT
je.description, 
je.reference_number,
je.transaction_date,
c.description, 
jed.amount, 
gl.description, 
gl.gl_account_number,
bt.transaction_date

from Journal_Entry je

LEFT OUTER JOIN Journal j on j.client_KEY = je.client_KEY

LEFT OUTER JOIN Journal_Entry_Distribution jed on jed.journal_entry_KEY = je.journal_entry_KEY

LEFT OUTER JOIN Client c on c.client_KEY = je.client_KEY

LEFT OUTER JOIN GL_Account gl on gl.gl_account_KEY = jed.gl_account_KEY

LEFT OUTER JOIN Bank_Transaction_Distribution btd on btd.bank_transaction_distribution_KEY = gl.gl_account_KEY

LEFT OUTER JOIN Bank_Transaction bt on bt.bank_reconciliation_clear_status_KEY = btd.bank_transaction_distribution_KEY

LEFT OUTER JOIN GL_Transaction_N_Bank_Transaction gltb on gltb.gl_transaction_KEY = bt.bank_reconciliation_clear_status_KEY

LEFT OUTER JOIN GL_Transaction glt on glt.gl_transaction_KEY = gltb.gl_transaction_KEY

LEFT OUTER JOIN GL_Period glp on glp.gl_period_KEY = glt.gl_transaction_KEY 

WHERE je.transaction_date BETWEEN '2017-02-01' AND '2017-02-28' AND c.description = 'HSE1, LLC'






SELECT 
DISTINCT(Bank_Transaction.amount) as trasaction_amount, Bank_Transaction.transaction_date, Bank_Transaction_Type.description, Transaction_Status.description, 
Client.description, 
GL_Account.description,
GL_Account.gl_account_number,
je.description,
jed.amount

FROM Bank_Transaction_Type

LEFT OUTER JOIN Journal_Entry je on je.journal_entry_KEY = Bank_Transaction_Type.bank_transaction_type_KEY

LEFT OUTER JOIN Journal_Entry_Distribution jed on jed.journal_entry_distribution_KEY = je.journal_entry_KEY

LEFT OUTER JOIN Bank_Transaction on Bank_Transaction_Type.bank_transaction_type_KEY
= Bank_Transaction.bank_transaction_type_KEY

LEFT OUTER JOIN Transaction_Status on Transaction_Status.transaction_status_KEY = Bank_Transaction.transaction_status_KEY

LEFT OUTER JOIN Bank_Transaction_Distribution on Bank_Transaction_Distribution.bank_transaction_KEY = Bank_Transaction.bank_transaction_KEY

LEFT OUTER JOIN GL_Account on GL_Account.gl_account_KEY = Bank_Transaction_Distribution.gl_account_KEY

LEFT OUTER JOIN Client on Client.client_KEY = GL_Account.client_KEY

WHERE Bank_Transaction.transaction_date BETWEEN '2017-02-01' AND '2017-02-28'