* Encoding: UTF-8.
DATASET CLOSE ALL.
OUTPUT CLOSE ALL.

DATA LIST LIST /var1 var2.
BEGIN DATA
1,2
2,3
3,4
8,9
END DATA.
LIST.
DATASET NAME MISME.
DATASET ACTIVATE MISME.

VALUE LABELS var1
  1.00 'NOT A MISSING'
  2.00 'MISSING WITH A LABEL'
  8.00.
MISSING VALUES  var1 (2 THRU 3, 8).


BEGIN PROGRAM.
import spss
import pandas as pd
import numpy as np
import platform

def datasetToDataframe(datasetname, variableLabelsExport= True, valueLabelsExport=True):
    varListObj2 = []
    caseListObj2 = []
    spss.StartDataStep()
    datasetObj = spss.Dataset(name=datasetname)
    caseListObj = datasetObj.cases
    varListObj = datasetObj.varlist
    for var in varListObj:
        dfvarname = var.label if variableLabelsExport and var.label else var.name
        varListObj2.append(dfvarname)
   
    for case in caseListObj:
        if valueLabelsExport:
            newcase =[]
            for index, cell in enumerate(case):
                valuelabelsDic = varListObj[index].valueLabels
                #print(varListObj[index].missingValues)
                if len(valuelabelsDic) > 0:
                    if cell in valuelabelsDic.data:
                        # IF cell is missing value
                        missingTuple = varListObj[index].missingValues
                        IsMissing = False
                        match missingTuple[0]:
                            case -3:
                                StartPointOfRange = missingTuple[1]
                                EndPointOfRange = missingTuple[2]
                                DiscreteValue = missingTuple[3]
                                if ((cell >= StartPointOfRange and cell <= EndPointOfRange) or cell==DiscreteValue):
                                    IsMissing = True
                            case -2:
                                StartPointOfRange = missingTuple[1]
                                EndPointOfRange = missingTuple[2]
                                if (cell >= StartPointOfRange and cell <= EndPointOfRange):
                                    IsMissing = True
                            # case -1:
                            #     print(-1, missingTuple)
                            # case 0:
                            #     print('NO MISSINGS')
                            case 1:
                                DiscreteValue = missingTuple[1]
                                if (cell == DiscreteValue):
                                    IsMissing = True
                            case 2:
                                DiscreteValue1 = missingTuple[1]
                                DiscreteValue2 = missingTuple[2]
                                if (cell == DiscreteValue1 or cell == DiscreteValue2):
                                    IsMissing = True
                                #print(2, DiscreteValue1, DiscreteValue2)
                            case 3:
                                DiscreteValue1 = missingTuple[1]
                                DiscreteValue2 = missingTuple[2]
                                DiscreteValue3 = missingTuple[3]
                                if (cell == DiscreteValue1 or cell == DiscreteValue2 or cell==DiscreteValue3):
                                    IsMissing = True
                        if IsMissing: 
                            #print('jaa ik heb wat gevonden het is een wonder!!!', varListObj[index].name, cell)
                            cell = np.nan
                        else:
                            cell = valuelabelsDic.data[cell] 
                newcase.append(cell)
            caseListObj2.append(newcase)
        else:
            caseListObj2.append(case)
    spss.EndDataStep()
    data = caseListObj2
    colums = varListObj2
    return pd.DataFrame(data,columns=colums)
    
currentdatasetname = spss.ActiveDataset()
df = datasetToDataframe(currentdatasetname, True)
print ('missing count:', df.isna().sum().sum())
print(df.dtypes)
print(df)
END PROGRAM.


