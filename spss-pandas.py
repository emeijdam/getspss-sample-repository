import spss
import pandas as pd

def dataframeToDataset(df, datasetName=None):
    if datasetName != None:
        spss.Submit('DATASET DECLARE ' + datasetName)
    spss.StartDataStep()
    columns = list(df)
    datasetObj = spss.Dataset(name=datasetName)
    for column in columns:
        if df[column].dtype == "object":
            stringLeght = int(df[column].str.len().max())
            datasetObj.varlist.append(column,stringLeght)
        else:
            datasetObj.varlist.append(column,0)
    for index, row in df.iterrows():
        rowlist = []
        for column in columns:
            rowlist.append(row[column])
        #print(rowlist)
        datasetObj.cases.append(rowlist)
    datasetName =  datasetObj.name
    spss.EndDataStep()
    return datasetName


def datasetToDataframe(datasetname):
    varListObj2 = []
    caseListObj2 = []
    spss.StartDataStep()
    datasetObj = spss.Dataset(name=datasetname)
    caseListObj = datasetObj.cases
    varListObj = datasetObj.varlist
    for var in varListObj:
        varListObj2.append(var.label)
    for case in caseListObj:
        caseListObj2.append(case)
    spss.EndDataStep()
    data = caseListObj2
    colums = varListObj2
    return pd.DataFrame(data,columns=colums)

strtTest = "GET FILE='C:\PROGRA~1\IBM\SPSSST~1\Samples\English\car_sales.sav'."
spss.Submit(strtTest)
currentdatasetname = spss.ActiveDataset()
df = datasetToDataframe(currentdatasetname)
print (df)

students = [('Ankit', 22, 'A'),
           ('Swapnil', 22, 'B'),
           ('Priya', 22, 'B'),
           ('Shivangi', 22, 'B'),
            ]
 
# Create a DataFrame object
df = pd.DataFrame(students, columns =['Name', 'Age', 'Section'],
                      index =['1', '2', '3', '4'])

DatasetName = dataframeToDataset(df, "joop")
spss.Submit('DATASET ACTIVATE ' + DatasetName)
spss.Submit('list.')
spss.Submit('freq  Name.')
