* Encoding: UTF-8.
output close all.

begin program.
import spss, spssaux
import subprocess
import pkg_resources
import sys
import os
import site
import importlib

def get_python3_executable(python3_home):
    python3_executable = ''
    if sys.platform.startswith('win32'):
        python3_executable = os.path.join(python3_home, 'python.exe')
    elif sys.platform.startswith('darwin'):
        python3_executable = os.path.join(python3_home, 'bin/python3')
    return python3_executable
    
def get_python3_executable_from_spss_settings():
    python3_executable = ''
    python3_executable_found = False
    cmd = r"show plugins."
    handle, errorlevel = spssaux.createXmlOutput(cmd, omsid="Show", subtype="System Settings", visible=False)
    settings_column =spssaux.getValuesFromXmlWorkspace(handle, "System Settings", colCategory="Setting")
    
    for cell in settings_column:
        plugin, info = cell.split(':',1)
        if info.find('--') > 0:
            installed, location = info.split('--')
            #print(plugin, installed, location)
            if plugin == "Python3" and installed == "Yes":
                python3_executable = get_python3_executable(location)
                python3_executable_found = True
    spss.DeleteXPathHandle(handle)
    spss.Submit('omsend')
    return python3_executable, python3_executable_found

def get_pkg_installed_dict(packagelist):
    packageDict = {}   
    for package in packagelist:
           distribution_name, package_disribution_version  = get_pkg_installed(package)
           packageDict[distribution_name]  = package_disribution_version
    return packageDict
 
 
def create_table(package_dict):
    spss.StartProcedure("required python3 packages")
    table = spss.BasePivotTable("required python3 PIP packages","OMS table subtype")
    table.SimplePivotTable(rowdim = "Package", 
                                       rowlabels = list(package_dict),
                                       collabels = ["Version"], 
                                       cells = list(package_dict.values())
                                       )
    spss.EndProcedure()
    
def get_pkg_installed(package): 
    try:
         dist = pkg_resources.get_distribution(package)
         #print('{} ({}) is installed'.format(dist.key, dist.version))
         return dist.key, dist.version
    except pkg_resources.DistributionNotFound:
         print('{} is NOT installed'.format(package))
         return package, None

def install_python_package(packagename, python_executable): 
        print('INSTALLING:', packagename)
        this_env = os.environ.copy()
        result = subprocess.run([python_executable,  "-m" ,"pip" ,"install",  packagename], capture_output=True, text=True, env=this_env)   
        print(result.stdout)
        print(result.stderr)

def uninstall_python_package(packagename, python_executable): 
        print('UNINSTALLING:', packagename)
        this_env = os.environ.copy()
        result = subprocess.run([python_executable,  "-m" ,"pip" ,"uninstall",  packagename], capture_output=True, text=True, env=this_env)   
        print(result.stdout)
        print(result.stderr)
        
def get_site_package_info(python3_executable):
    this_env = os.environ.copy()
    #this_env["PATH"] =  this_env["PATH"] + ';' + os.path.normpath('C:\\Users\\ed\\AppData\\Roaming\\Python\\Python310\\site-packages')
    #this_env["PATH"] =  this_env["PATH"] + ';' + os.path.normpath('C:\\Users\\ed\\AppData\\Roaming\\Python\\Python310\\Scripts')
    for k in this_env["PATH"].split(';'):
        print(k)
    print('pypath')
    for k in this_env["PYTHONPATH"].split(';'):
        print(k)
    print(sys.path)
    result = subprocess.run([python3_executable,  "-m" ,"pip" ,"install",  "--upgrade", "pip"], capture_output=True, text=True, env=this_env)   
    print(result.stdout)
    print(result.stderr)    
    print(site.getusersitepackages())
    print(site.getsitepackages())
    print(site.USER_SITE)
    print(importlib.util.find_spec('spss'))

def package_manager(package_list, install_if_not_exists=False):
    packages_status_dict = get_pkg_installed_dict(packages)     
    create_table(packages_status_dict)      
    python3_executable, python3_executable_found = get_python3_executable_from_spss_settings()
    #print(python3_executable, python3_executable_found)
    #print(packages_status_dict)
    not_installed_package_list = [k for k, v in packages_status_dict.items() if v == None]
    #print(not_installed_package_list)
    if python3_executable_found != None:
        if install_if_not_exists:
            for package in not_installed_package_list:
                install_python_package(package, python3_executable)
    get_site_package_info(python3_executable)
    packages_status_dict = get_pkg_installed_dict(packages)     
    create_table(packages_status_dict)     
 
# installing   
packages = [
    'emoji',
    'pandas',
    'ply', 
    'Seaborn', 
    'urllib3',
     'Boto3',
     'colorama',
     'isodate',
     'rich',
     'requests'
]   

package_manager(packages, True)

end program.


