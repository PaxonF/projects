#Packages
import pandas as pd
import numpy as np
from functools import partial
import difflib 

#Function for returning ratio of Sequence Matcher
def apply_sm(s, c1, c2): 
    return difflib.SequenceMatcher(None, s[c1], s[c2]).ratio()

#Load Dataframe
df = pd.read_csv("MatchingAddressesandNames.csv")
print("DataFrame Loaded")

#df = df.applymap(lambda x: np.nan if isinstance(x, basestring) and x.isspace() else x)

df.loc[df['last_names'] == ' ', 'last_names'] = np.nan
df.loc[df['ofac_ln'] == ' ', 'ofac_ln'] = np.nan

#df = df.replace(r'\s+', np.nan, regex=True)
#df.loc[df['last_names'] == " ", 'last_names'] = ''
# df.loc[df['ofac_ln'] == " ", 'ofac_ln'] = ''


#Remove Blank Values
df['colony'] = df['colony'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_colony'] = df['ofac_colony'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['address2'] = df['address2'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_address2'] = df['ofac_address2'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['address1'] = df['address1'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_address'] = df['ofac_address'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['municipality'] = df['municipality'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_municipality'] = df['ofac_municipality'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['state'] = df['state'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_state'] = df['ofac_state'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['first_name'] = df['first_name'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_fn'] = df['ofac_fn'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['last_names'] = df['last_names'].astype(str).apply(lambda x: x.strip() if isinstance(x, str) else x).replace('', np.nan)
df['ofac_ln'] = df['ofac_ln'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
df['name'] = df['name'].astype(str).apply(lambda x: x.strip()).replace('', np.nan)
print("Blank Values Replaced")

#Test CSV
df.to_csv('testtest.csv')

#Create Columns that compares two addresses and finds ratio
df = df.applymap(lambda x: x.strip() if type(x) is str else x)

df['fn_score'] = df.apply(partial(apply_sm, c1='first_name', c2 = 'ofac_fn'), axis = 1)
print("First Names Complete")
df['ln_score'] = df.apply(partial(apply_sm, c1='last_names', c2 = 'ofac_ln'), axis = 1)
print("Last Names Complete")
df['business_score'] = df.apply(partial(apply_sm, c1='name', c2 = 'ofac_ln'), axis = 1)
print("Business Complete")
df['address1_score'] = df.apply(partial(apply_sm, c1='address1', c2 = 'ofac_address'), axis = 1)
print("Address Complete")
df['address2_score'] = df.apply(partial(apply_sm, c1='address2', c2 = 'ofac_address2'), axis = 1)
print("Address2 Complete")
df['colony_score'] = df.apply(partial(apply_sm, c1='colony', c2 = 'ofac_colony'), axis = 1)
print("Colony Complete")
df['municipality_score'] = df.apply(partial(apply_sm, c1='municipality', c2 = 'ofac_municipality'), axis = 1)
print("Municipality Complete")
df['state_score'] = df.apply(partial(apply_sm, c1='state', c2 = 'ofac_state'), axis = 1)
print("State Complete")

#Adjust scores with NaN's
df.loc[df['first_name'] == "nan", 'fn_score'] = 0
df.loc[df['ofac_fn'] == "nan", 'fn_score'] = 0
df.loc[df['last_names'] == "nan", 'ln_score'] = 0
df.loc[df['ofac_ln'] == "nan", 'ln_score'] = 0
df.loc[df['colony'] == "nan", 'colony_score'] = 0
df.loc[df['ofac_colony'] == "nan", 'colony_score'] = 0
df.loc[df['address2'] == "nan", 'address2_score'] = 0
df.loc[df['ofac_address2'] == "nan", 'address2_score'] = 0
df.loc[df['address1'] == "nan", 'address1_score'] = 0
df.loc[df['ofac_address'] == "nan", 'address1_score'] = 0
df.loc[df['municipality'] == "nan", 'municipality_score'] = 0
df.loc[df['ofac_municipality'] == "nan", 'municipality_score'] = 0
df.loc[df['state'] == "nan", 'state_score'] = 0
df.loc[df['ofac_state'] == "nan", 'state_score'] = 0
df.loc[df['ofac_ln'] == "nan", 'business_score'] = 0
df.loc[df['name'] == "nan", 'business_score'] = 0
print("Scores Adjusted")

#Sum Calculation
df["total_sum"] = df['fn_score'] + df['ln_score'] + df['business_score'] + df['address1_score'] + df['address2_score'] + df['colony_score'] + df['municipality_score'] + df['state_score'] + df['p8']
df["weighted_sum"] = .15 * df['fn_score'] + .2 * df['ln_score'] + .08*df['business_score'] + .2 * df['address1_score'] + .15 * df['address2_score'] + .05 * df['colony_score'] + .05 * df['municipality_score'] + 0.02 * df['state_score'] + .1 * df['p8']
print("Probabilities Calculated")
#Add to docs
#Emphasize that this was my decision, can be adjusted 


df = df.drop(['p1', 'p2', 'p3','p4','p5','p6','p7','p8'], axis = 1)

#Sort by largest Probabilities
df = df.sort_values(by = ["weighted_sum", "total_sum"],ascending = False)

#Write new file to CSV
df.to_csv('ofac_analysis_sm3.csv', index = False)
print("Analysis Complete")



#Distance, tokens, entitiy resolution (record matching) levingine distance
#
#remove addresses based on non-matching states