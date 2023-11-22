import spss
import pandas as pd
import platform

def dataframeToDataset(df, datasetName=None):
    if datasetName != None:
        spss.Submit('DATASET DECLARE ' + datasetName)
    spss.StartDataStep()
    columns = list(df)
    datasetObj = spss.Dataset(name=datasetName)
    for column in columns:
        if df[column].dtype == "object":
            stringLeght = int(df[column].str.len().max())
            datasetObj.varlist.append(column, stringLeght)
        else:
            datasetObj.varlist.append(column, 0)
    for index, row in df.iterrows():
        rowlist = []
        for column in columns:
            rowlist.append(row[column])
        datasetObj.cases.append(rowlist)
    datasetName = datasetObj.name
    spss.EndDataStep()
    return datasetName


def datasetToDataframe(datasetname, variableLabelsExport= True, valueLabelsExport=True):
    varListObj2 = []
    caseListObj2 = []
    spss.StartDataStep()
    datasetObj = spss.Dataset(name=datasetname)
    caseListObj = datasetObj.cases
    varListObj = datasetObj.varlist
    for var in varListObj:
        dfvarname = var.label if variableLabelsExport else var.name
        varListObj2.append(dfvarname)
   
    for case in caseListObj:
        if valueLabelsExport:
            newcase =[]
            for index, cell in enumerate(case):
                valuelabelsDic = varListObj[index].valueLabels
                #missingValues
                if len(valuelabelsDic) > 0:
                    if cell in valuelabelsDic.data:
                        cell = valuelabelsDic.data[cell]
                newcase.append(cell)
            caseListObj2.append(newcase)
        else:
            caseListObj2.append(case)
    spss.EndDataStep()
    data = caseListObj2
    colums = varListObj2
    return pd.DataFrame(data,columns=colums)



#spss.Submit('SHOW LICENSE.')

if platform.system() == 'Windows':
    spss.Submit("FILE HANDLE DEFAULTSAMPLEFOLDERHANDLE /NAME='C:\Program Files\IBM\SPSS Statistics\Samples\English'.")
else:
    spss.Submit("FILE HANDLE DEFAULTSAMPLEFOLDERHANDLE /NAME='/Applications/IBM SPSS Statistics/Resources/Samples/English'.")


strtTest = "GET FILE='DEFAULTSAMPLEFOLDERHANDLE/survey_sample.sav'."
print(strtTest)
spss.Submit(strtTest)
currentdatasetname = spss.ActiveDataset()
df = datasetToDataframe(currentdatasetname, True)
print(list(df))
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
