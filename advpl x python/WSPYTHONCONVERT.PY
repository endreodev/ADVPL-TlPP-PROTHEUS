import os
import openpyxl 
import csv 
from flask import Flask, render_template, url_for, jsonify, request,send_file
from pandas import read_sql, read_json, to_numeric ,read_excel 
import pandas as pd 
from werkzeug.utils import redirect, secure_filename

app = Flask(__name__)
UPLOAD_FOLER = os.path.join( os.getcwd(),'upload')

@app.route('/home', methods=['GET'])
def home():
    msg = 'conectado'
    
    return jsonify(rest=msg)

@app.route('/convert', methods=['POST'])
def upload_file():
    
    file = request.files['file']
    
    print(file)
    savePath = os.path.join( UPLOAD_FOLER , secure_filename(file.filename) )
    savePathcsv = os.path.join( UPLOAD_FOLER , secure_filename(file.filename))

    savePathcsv =  savePathcsv.upper()
    savePathcsv =  savePathcsv.replace('XLSX', 'CSV')
    savePathcsv =  savePathcsv.replace('XLS' , 'CSV')
    
    file.save(savePath)

    excel = openpyxl.load_workbook(savePath) 
    sheet = excel.active 


    col = csv.writer(open(savePathcsv,'w', newline="")) 
    for r in sheet.rows: 
        col.writerow([cell.value for cell in r]) 

    excel_data_df = pd.read_excel(savePath)

    json_str = excel_data_df.to_json()
        
    return json_str

if __name__ == "__main__":
    app.debug = True
    app.run(host='localhost', port=21658)
