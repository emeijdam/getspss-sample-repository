* Encoding: UTF-8.
OUTPUT CLOSE ALL.
DATASET CLOSE ALL.

SET PRINTBACK=ON.

BEGIN PROGRAM PYTHON3.
# Ophalen OneDrive locatie via windows OS environment variable en zet File Handle automatisch.
import spss
import os

OneDriveEnv = os.getenv('OneDrive')
print('Uw OneDrive folder locatie is: ', OneDriveEnv)

FileHandleSyntax = f"FILE HANDLE OneDriveHandle /NAME='{OneDriveEnv}'."
spss.Submit(FileHandleSyntax)
print('')
print(FileHandleSyntax)
END PROGRAM.


* Orginele onedrive locatie.
GET
  FILE='C:\Users\ed\OneDrive - DASC\car_sales.sav'.
DATASET NAME voorbeeld1 WINDOW=FRONT.

DATASET CLOSE voorbeeld1.

* onedrive locatie / handmatig aanpassen in syntax..
GET
  FILE='OneDriveHandle\car_sales.sav'.
DATASET NAME OneDriveEnvVoorbeeld1 WINDOW=FRONT.

DATASET CLOSE OneDriveEnvVoorbeeld1.

* Onedrive folder als standaard locatie.
CD 'OneDriveHandle'.
* onedrive locatie / handmatig aanpassen in syntax..
GET
  FILE='car_sales.sav'.
DATASET NAME OneDriveEnvVoorbeeld2 WINDOW=FRONT.
