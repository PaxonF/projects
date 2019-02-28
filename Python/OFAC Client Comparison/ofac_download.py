#import packages
import csv
import pandas as pd
from pprint import pprint

#column names
names_columns = ['name_id', 'name','type','program','title','call_sign','vessel_type','tonnage','gross_registered_tonnage','vessel_flag','vessel_owner','identifications']
address_columns = ['name_id','address_id', 'address', 'city_state', 'country','null1']
alt_columns = ['name_id', 'alt_id','aka','alt_name', 'null2']

### load CSVs and create new columns ###
#names
names = pd.read_csv('https://www.treasury.gov/ofac/downloads/sdn.csv', names = names_columns)
names['last_name'], names['first_name'] = names['name'].str.split(',',1).str
names = names.replace({'-0- ': ''}, regex=True)

#addresses
addresses = pd.read_csv('https://www.treasury.gov/ofac/downloads/add.csv', names = address_columns)
addresses.to_csv('addresses.csv')
addresses = addresses.replace({'-0- ': ''}, regex=True)

    #Parse zip_codes, cities, and states
addresses['zip_code'] = addresses['city_state'].str[-5:]
addresses['city_state'] = addresses['city_state'].str.replace(r'\d+', '')
addresses['zip_code'] = addresses['zip_code'].str.replace(r'\D+', '')
addresses['city_state'] = addresses['city_state'].str.replace(' CP ','')
addresses['city_state'] = addresses['city_state'].str.replace(' CP','')
addresses['city_state'] = addresses['city_state'].str.replace(' C.P. ','')
addresses['city_state'] = addresses['city_state'].str.strip()
addresses['city_state'] = addresses['city_state'].replace({'Mexico, D.F.':'Mexico City'})
addresses['municipality'], addresses['state'] = addresses['city_state'].str.split(', ', 1).str
    
    #Parse out street address
addresses['address'] = addresses['address'].str.replace('c/o ','')    
addresses['address'] = addresses['address'].str.replace(' Col. ',' Colonia ') 
addresses['address'] = addresses['address'].str.replace(' Col ',' Colonia ')   
addresses['address'] = addresses['address'].str.replace(' Fraccionamiento ',' Colonia ')  
addresses['address'] = addresses['address'].str.replace(' Frac. ',' Colonia ')  
addresses['address'] = addresses['address'].str.replace(' Fracc. ',' Colonia ')
addresses['address'], addresses['colony'] = addresses['address'].str.split(' Colonia ', 1).str
addresses['address'] = addresses['address'].str.replace(' S.A. DE C.V.', '')
addresses['address'] = addresses['address'].str.replace(' S.A. de C.V.', '') 
addresses['address'] = addresses['address'].str.replace(' S.A. DE. C.V.', '')
addresses['address'] = addresses['address'].str.replace('Num.', '') 
addresses['address'] = addresses['address'].str.replace('Ext.', '')
addresses['address'] = addresses['address'].str.replace('Int.', '') 
#addresses['address2'] = addresses['address2'].str.replace('int. ', '')  
addresses['address'], addresses['address2'] = addresses['address'].str.split(',', 1).str

    #make second zip-code column
addresses['colony'] = addresses['colony'].str.replace(' Secc. ',' Seccion ')
addresses['zip_code2'] = addresses['colony'].str[-5:]
addresses['zip_code2'] = addresses['zip_code2'].str.replace(r'\D+', '')
addresses['colony'] = addresses['colony'].str.replace(r'\d+', '')
addresses['colony'] = addresses['colony'].str.replace(' CP ','')

addresses["zip_code3"] = addresses["zip_code"].map(str) + addresses["zip_code2"]

#addresses['colony'], addresses['municipality'] = addresses['colony'].str.split(' Seccion ', 1).str

#alternate names
alt_names = pd.read_csv('https://www.treasury.gov/ofac/downloads/alt.csv', names = alt_columns)
alt_names = alt_names.replace({'-0- ': ''}, regex=True)
alt_names['alt_last_name'], alt_names['alt_first_name'] = alt_names['alt_name'].str.split(',',1).str

#merge datasets on address base table
data = addresses.merge(names, how = 'left', on = 'name_id')
data = data.merge(alt_names, how = 'left', on = 'name_id')

#Filter by Mexico and Type
data = data[data['country']=='Mexico']


#data = data[data['type']=='individual']

#Drop and reorganize columns
drop_list = ['name','city_state','null1','title','call_sign','vessel_type','tonnage','gross_registered_tonnage','vessel_flag','vessel_owner', 'null2','aka']
data = data.drop(drop_list, axis=1)
data = data[['first_name', 'last_name','alt_first_name','alt_last_name','address', 'address2', 'colony','municipality','state','zip_code','zip_code2', 'zip_code3','type','program','identifications','name_id']]
#data.columns.values[0] = 'id'

#Trim
data = data.replace('\s+', ' ', regex = True)
data = data.replace({',': ''}, regex=True)
data = data.applymap(lambda x: x.strip() if type(x) is str else x)
data = data.apply(lambda x: x.astype(str).str.lower())
#data.loc[data == "nan"] = ''

#export CSV
data.to_csv('ofac_all.csv', index = False)