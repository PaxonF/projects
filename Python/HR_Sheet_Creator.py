from __future__ import print_function
import pickle
import os.path
from httplib2 import Http
from oauth2client import file, client, tools
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import random
import time
from datetime import datetime
from operator import itemgetter

#Start Timer
startTime = datetime.now()
wait = True

#Grab entire Column
def column(matrix, i):
    return [row[i] for row in matrix]

### CREATE GOOGLE DRIVE AND SHEETS CREDS ###
def get_credentials():
    scopes = 'https://www.googleapis.com/auth/drive'
    # Setup the Sheets API
    store = file.Storage('token.json')
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets('credentials.json', scopes)
        creds = tools.run_flow(flow, store)
    http = creds.authorize(Http())
    return http

#Sheet Service
sheet_service = build('sheets', 'v4', http=get_credentials())
#Drive Service
drive_service = build('drive', 'v3', http=get_credentials())

#Turn any spreadsheet into a list
def sheet_to_list(spreadsheetId, range):
    sheet_list = sheet_service.spreadsheets().values().get(spreadsheetId=spreadsheetId, range=range).execute()
    return sheet_list

#Create Spreadsheet
def create_spreadsheet(manager_email):
    spreadsheet_body = {
        'properties': {
            'title': '2018 Performance Review - ' + manager_email
            }
    }
    request = sheet_service.spreadsheets().create(body=spreadsheet_body)
    response = request.execute()
    return response

#Create Tabs
def create_tabs(employee_email, spreadsheetId):
    spreadsheet_body = {
    "requests": [
        {
        "addSheet": {
            "properties": {
            "title": employee_email,
            "gridProperties": {
                "rowCount": 18,
                "columnCount": 6
            },
            "tabColor": {
                "red": random.uniform(0, 1),
                "green": random.uniform(0, 1),
                "blue": random.uniform(0, 1)
            }
            }
        }
        }
    ]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    return response

#Write Data
def write_data(employee_projects, employee_email, ranges, spreadsheetId):
    default_data = ['Project1', 'Project2','Project3', 'Optional','Optional','Manager Choice']
    employee_projects = employee_projects[2:]
    for i in range(5):
        try:
            default_data[i] = employee_projects[i]
        except:
            break
    employee_projects = default_data
    sheet_range = employee_email + ranges
    values = {
    "range": sheet_range,
    "majorDimension": "ROWS",
    "values": [
        ["1", employee_projects[0], "", "", "", "=IFERROR(AVERAGE(C2:E2),"")"],
        ["2", employee_projects[1], "", "", "", "=IFERROR(AVERAGE(C3:E3),"")"],
        ["3", employee_projects[2], "", "", "", "=IFERROR(AVERAGE(C4:E4),"")"],
        ["4", employee_projects[3], "", "", "", "=IFERROR(AVERAGE(C5:E5),"")"],
        ["5", employee_projects[4], "", "", "", "=IFERROR(AVERAGE(C6:E6),"")"],
        ["6", employee_projects[5], "", "", "", "=IFERROR(AVERAGE(C7:E7),"")"]
    ],
    }
    request = sheet_service.spreadsheets().values().update(spreadsheetId = spreadsheetId,range = sheet_range, body = values, valueInputOption = 'USER_ENTERED')
    response = request.execute()
    return response

#Append Data
def append_data(values):
    values = [
        values
    ]
    body = {
    'values': values
    }
    request = sheet_service.spreadsheets().values().append(spreadsheetId='1cvewxHmXq9tMbX3X0QpIY-Yuv_OYqK41uWLVt7viayM', range= 'List of Sheets!A1', 
    valueInputOption='USER_ENTERED', body=body)
    response = request.execute()
    return response

#Delete Sheet
def delete_sheet1(spreadsheetId):
    spreadsheet_body = {
        "requests": [
           {
         "deleteSheet": {
           "sheetId": 0 
          }
        }
    ]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    return response

#Instructions Sheet
def Instructions_sheet(original_spreadsheetId, destination_spreadsheetId):
    #copy sheet from HR Sheet
    spreadsheet_body = {
    'destination_spreadsheet_id': destination_spreadsheetId
    }
    request = sheet_service.spreadsheets().sheets().copyTo(spreadsheetId = original_spreadsheetId, sheetId = 184655528, body=spreadsheet_body)
    response = request.execute()

    #Change Name of Sheet
    ranges = 'Copy of Instructions!A1:B14'
    request = sheet_service.spreadsheets().get(spreadsheetId=destination_spreadsheetId, ranges=ranges, includeGridData=False)
    response = request.execute()
    sheet_id = response['sheets'][0]['properties']['sheetId']
    spreadsheet_body = {
    "requests": [{
        "updateSheetProperties": {
            "properties": {
                "sheetId": sheet_id,
                "title": 'Instructions',
            },
            "fields": "title",
        }
    }]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = destination_spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    spreadsheet_body = {
    "requests": [{
      "addProtectedRange": {
        "protectedRange": {
          "range": {
            "sheetId": sheet_id
          },
          "description": "Protecting Document",
          "warningOnly": False,
            "editors":{
            "domainUsersCanEdit": False
            }
        }
      }
    }]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = destination_spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    return response

#Copy Sheet
def copy_sheet(original_spreadsheetId, destination_spreadsheetId, employee_email):
    #copy sheet from HR Sheet
    spreadsheet_body = {
    'destination_spreadsheet_id': destination_spreadsheetId
    }
    request = sheet_service.spreadsheets().sheets().copyTo(spreadsheetId = original_spreadsheetId, sheetId = 474735553, body=spreadsheet_body)
    response = request.execute()

    #Change Name of Sheet
    #find_range = employee_email + '!A1:F18'
    ranges = 'Copy of Example of Sheet!A1:F18'
    request = sheet_service.spreadsheets().get(spreadsheetId=destination_spreadsheetId, ranges=ranges, includeGridData=False)
    response = request.execute()
    sheet_id = response['sheets'][0]['properties']['sheetId']
    spreadsheet_body = {
    "requests": [{
        "updateSheetProperties": {
            "properties": {
                "sheetId": sheet_id,
                "title": employee_email,
            },
            "fields": "title",
        }
    }]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = destination_spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    spreadsheet_body = {
    "requests": [{
      "addProtectedRange": {
        "protectedRange": {
          "range": {
            "sheetId": sheet_id
          },
          "description": "Protecting Document",
          "warningOnly": False,
          "unprotectedRanges": [
            {
            "sheetId": sheet_id,
            "startRowIndex": 1,
            "endRowIndex": 7,
            "startColumnIndex": 2,
            "endColumnIndex": 5
            },
            {
            "sheetId": sheet_id,
            "startRowIndex": 9,
            "endRowIndex": 15,
            "startColumnIndex": 2,
            "endColumnIndex": 3
            },
            {
            "sheetId": sheet_id,
            "startRowIndex": 6,
            "endRowIndex": 7,
            "startColumnIndex": 1,
            "endColumnIndex": 2
            }
            ],
            "editors":{
            "domainUsersCanEdit": False
            }
        }
      }
    }]
    }
    request = sheet_service.spreadsheets().batchUpdate(spreadsheetId = destination_spreadsheetId, body=spreadsheet_body)
    response = request.execute()
    return response

#Give Permissions
def give_permissions(manager_email, spreadsheetId):
    body = {
    "kind": "drive#permission",
    "type": "user",
    "emailAddress": manager_email,
    "role": "writer"
    }
    message = """Líder Clip,
        Aquí puedes encontrar un google sheet para evaluar el desempeño en 2018 de tus reportes directos. Cada uno de ellos ya eligió hasta 5 proyectos o actividades y éstas están pre cargadas automáticamente. En cada pestaña verás el nombre de cada uno de ellos. El campo #6 es un campo editable en caso que quieras agregar un proyecto o tarea a evaluar.

        Por favor lee con atención las instrucciones como una guía de cómo hacer la evaluación de cada persona. Este google sheet se estará actualizando cada noche en caso de tener nuevas respuestas. En caso de que no te aparezca alguna persona en este google sheet es porque el o ella no han contestado un google form previo con sus objetivos o proyectos realizados en 2018, será recomendable dar follow up. Si para el jueves 7 de febrero sigues teniendo alguna persona faltante en el google sheet, contacta al equipo de People a mauricio.ortiz@payclip.com o a miriam.davila@payclip.com. Tendrás hasta el viernes 15 de febrero para completar todas tus evaluaciones.

        Gracias,
        The People Team

        ----

        Clip Leader, 
        Here you can find a google sheet to evaluate your direct reports performance for 2018. Each one of them have already chosen up to 5 projects or tasks that they have developed during the last year. The sixth project is optional for managers to add.

        Please read the instructions very carefully as a guide on how to grade every person. This google sheet will be automatically refreshed and updated every night in case there are new responses; so if you don't see a tab for any of your direct reports, it means that this person hasn't filled out his or her projects yet. If by Thursday February 7th any of your reports are missing, please notify this person as well as the People team to mauricio.ortiz@payclip.com or miriam.davila@payclip.com. You have till Friday, the 15th, to complete your team's evaluation.

        Thank you,
        The People Team"""


    response = drive_service.permissions().create(fileId = spreadsheetId, body = body, emailMessage = message).execute()
    return response

#Move to HR Folder
def move_to_folder(file_id, folder_id):
    file = drive_service.files().get(fileId=file_id, fields='parents').execute()
    previous_parents = ",".join(file.get('parents'))
    # Move the file to the new folder
    file = drive_service.files().update(fileId=file_id, addParents=folder_id, removeParents=previous_parents, fields='id, parents').execute()
    return file

def get_results(spreadsheetId, employee_email):
    #Projects
    project_range = employee_email + '!F8'
    response = sheet_to_list(spreadsheetId, project_range)
    try:
        project_score = response['values'][0][0]
    except:
        project_score = 'N/A'
    #Values
    value_range = employee_email + '!C16'
    response = sheet_to_list(spreadsheetId, value_range)
    try:
        value_score = response['values'][0][0]
    except:
        value_score = 'N/A'
    #Total
    total_range = employee_email + '!C18'
    response = sheet_to_list(spreadsheetId, total_range)
    total_score = response['values'][0][0]
    if total_score == '0.00':
        total_score = 'N/A'
    results_list = [project_score, value_score, total_score]
    return results_list 

def update_data(values):
    body = {
    'values': values
    }
    request = sheet_service.spreadsheets().values().update(spreadsheetId='1cvewxHmXq9tMbX3X0QpIY-Yuv_OYqK41uWLVt7viayM', range= 'Results!A1', 
    valueInputOption='USER_ENTERED', body=body)
    response = request.execute()
    return response

### Grab Performance Spreadsheet ###
hr_data_id = '1cvewxHmXq9tMbX3X0QpIY-Yuv_OYqK41uWLVt7viayM'
ranges = 'Form!B:H'
hr_data_list = sheet_to_list(hr_data_id, ranges)
hr_data_list = hr_data_list['values']

### Grab List of Spreadsheets already Created ###
ranges = 'List of Sheets!A:D'
verification_list = sheet_to_list(hr_data_id, ranges)
verification_list = verification_list['values']

#Count Sheets Created
manager_count = 0
employee_count = 0

#Start Loop
for response in hr_data_list:
    while wait == True:
        time.sleep(5)
        wait = False
    if response == []:
        break
    if response[0] == 'Employee Email':
        continue
    if response[1].lower() not in column(verification_list, 1):
        wait = True
        manager_email = response[1].lower()
        print('Create Sheet for ' + manager_email)
        manager_sheet = create_spreadsheet(manager_email)
        manager_sheet_id = manager_sheet['spreadsheetId']
        manager_sheet_url = manager_sheet['spreadsheetUrl']
        Instructions_sheet(hr_data_id, manager_sheet_id)
        manager_count += 1
        #create tab
        employee_email = response[0]
        print('Create Tab ' + employee_email)
        employee_tab = copy_sheet(hr_data_id, manager_sheet_id, employee_email)
        employee_count += 1
        ranges = '!A2:F7'
        #Paste Data
        write_to_sheet = write_data(response, employee_email, ranges, manager_sheet_id)

        #Delete Sheet1
        delete_sheet1(manager_sheet_id)
        #Give Permission
        print('Give Permissions to ' + manager_email)
        permissions = give_permissions(manager_email, manager_sheet_id)

        #Move to Folder
        folder_id = '1vBR72QteVL27aPgMDKQSFq1o0cf8Tspn'
        move_to_folder(manager_sheet_id, folder_id)
        #Append to Verification List(s)
        values = [employee_email, manager_email, manager_sheet_id, manager_sheet_url]
        append_data(values)
        verification_list.append(values)


    else:
        if response[0] not in column(verification_list, 0):
            wait = True
            for i in verification_list:
                manager_sheet_id = i[2]
                manager_email = i[1].lower()
                manager_sheet_url = i[3]
                if response[1] == i[1]:
                    break
            print("Using Document: " + manager_email)
            #create tab
            employee_email = response[0]
            print('Create Tab ' + employee_email)
            #manager_sheet_id = verification_list[2]
            employee_tab = copy_sheet(hr_data_id, manager_sheet_id, employee_email)
            employee_count += 1
            #Paste Data
            ranges = '!A2:F7'
            write_to_sheet = write_data(response, employee_email, ranges, manager_sheet_id)
        
            #Append to Verification List
            values = [employee_email, manager_email, manager_sheet_id, manager_sheet_url]
            append_data(values)
            verification_list.append(values)

        else:
            continue

print('Finished Updating Manager Documents')
print(str(manager_count) + ' Documents Created.')
print(str(employee_count) + ' Spreadsheets Updated.')
print('Starting to Scrape Scores...')

### Grab List of Spreadsheets already Created Once Again ###
ranges = 'List of Sheets!A:D'
verification_list = sheet_to_list(hr_data_id, ranges)
verification_list = verification_list['values']

#List to be Updated
results = [['Employee','Manager','Projects Score', 'Values Score', 'Total Score', 'URL to Sheet']]

#Loop Through List of Sheets to get Results
for sheet in verification_list:
    time.sleep(3)
    if sheet == []:
        break
    if sheet[0] == 'Employee':
        continue
    employee_email = sheet[0]
    manager_email = sheet[1].lower()
    sheet_id = sheet[2]
    url = sheet[3]
    scores = get_results(sheet_id, employee_email)
    data = [employee_email, manager_email, scores[0], scores[1], scores[2], url]
    results.append(data)

print("Updating Results Sheet")
results = sorted(results, key=itemgetter(1,0))
update_data(results)

print("Process took " + str(datetime.now() - startTime)+ ".")