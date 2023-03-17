import spss
import pandas
spss.Submit('show license.')
currentdatasetname = spss.ActiveDataset()

print(currentdatasetname)

#os.path.normpath
strtTest = "GET FILE='C:\PROGRA~1\IBM\SPSSST~1\Samples\English\car_sales.sav'."

spss.Submit(strtTest)
spss.Submit('list.')

varListObj2 = []
caseListObj2 = []
spss.StartDataStep()
datasetObj = spss.Dataset(name=currentdatasetname)
caseListObj = datasetObj.cases
varListObj = datasetObj.varlist
for var in varListObj:
    varListObj2.append(var.label)
for case in caseListObj:
    #print(case)
    caseListObj2.append(case)
spss.EndDataStep()

import pandas as pd
data = caseListObj2
colums = varListObj2
#df = pd.DataFrame(data,columns=['Name','Age'],dtype=float)
df = pd.DataFrame(data,columns=colums)
print (df)