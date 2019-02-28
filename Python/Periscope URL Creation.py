#Packages for URL Creation
import json
import requests
import pandas as pd
import csv

#Google Sheet Packages
import gspread
#from __future__ import print_function
from apiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
from oauth2client.service_account import ServiceAccountCredentials

#Function to Create URL for Periscope
#Remember to delete the unwanted URLs
dashboard_Id = 268359
create_url_counter = 0
def create_url(df):
    global create_url_counter
    if df['Merchant_URL'] == None:
        #Credentials
        headers = {
            'HTTP-X-PARTNER-AUTH': 'payclip:16c7f5b6-32f4-4d08-95ee-aa2a8c26',
        }
        data = {
            "dashboard":dashboard_Id, 
            "embed": "v2",
            "filters":[
                {
                "name":"merchant_id",
                "value":df['ME ID']
                }
                ]
            }
        url = 'https://app.periscopedata.com/api/v1/shared_dashboard/create'
        response = requests.post(url = url, headers=headers, json=data)
        
        #Print message if request fails
        if response.status_code != 200:
            print('Status:', response.status_code, 'Problem with the request. API Limit may be exceeded.')
            return df['Merchant_URL']
        #Convert to JSON
        data = response.json()
        create_url_counter += 1
        #print(str(create_url_counter) + " URLs Created")
        return data['url']+"?embed=true"
    else:
        return df['Merchant_URL']


#Setup Google Sheets API
SCOPES = 'https://www.googleapis.com/auth/spreadsheets.readonly'
store = file.Storage('credentials.json')
creds = store.get()
if not creds or creds.invalid:
    flow = client.flow_from_clientsecrets('client_secret.json', SCOPES)
    creds = tools.run_flow(flow, store)
service = build('sheets', 'v4', http=creds.authorize(Http()))


# Top Accounts Sheet Details
spreadsheet_id =  '1CS-migmQC1qAnt7zo7wsFzRXVahrTl8aquHy00-xkYg'
rows = 'Hoja1!A:F'


#Grab sheet -> DataFrame
rows = service.spreadsheets().values().get(spreadsheetId=spreadsheet_id, range=rows).execute()
rows = rows.get('values') if rows.get('values')is not None else 0
df = pd.DataFrame(data = rows, columns = ['ME ID', 'CUENTA NODO', 'Estatus KAE', 'KAE', 'Nodo_URL', 'Merchant_URL'])
df = df.iloc[1:]


#Start Checking for URLs and Creating Missing URLs
df['Merchant_URL'] = df.apply(create_url, axis = 1)
print(str(create_url_counter) + " URLs Created!")


#Function for Getting correct Columns
def numberToLetters(q):
    q = q - 1
    result = ''
    while q >= 0:
        remain = q % 26
        result = chr(remain+65) + result;
        q = q//26 - 1
    return result

#Use Gspread Creds to re-open worksheet and load in results into separate sheet
json_key = json.load(open('creds.json'))
scope = ['https://spreadsheets.google.com/feeds']
creds = ServiceAccountCredentials.from_json_keyfile_name('creds.json', scope)
gc = gspread.authorize(creds)
ws = gc.open_by_key(spreadsheet_id).worksheet('Dashboard URLs')

#Write Columns
columns = df.columns.values.tolist()
# selection of the range that will be updated
cell_list = ws.range('A1:'+numberToLetters(len(columns))+'1')
# modifying the values in the range
for cell in cell_list:
    val = columns[cell.col-1]
#     if type(val) is str:
#         val = val.decode('utf-8')
    cell.value = val
# update in batch
ws.update_cells(cell_list)

# Write Rows
# number of lines and columns
num_lines, num_columns = df.shape
# selection of the range that will be updated
cell_list = ws.range('A2:'+numberToLetters(num_columns)+str(num_lines+1))
# modifying the values in the range
for cell in cell_list:
    val = df.iloc[cell.row-2,cell.col-1]
#     if type(val) is str:
#         val = val.decode('utf-8')
#     elif isinstance(val, (int, long, float, complex)):
#         # note that we round all numbers
#         val = int(round(val))
    cell.value = val
# update in batch
ws.update_cells(cell_list)

print("Finished Updating Document")