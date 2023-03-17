IBM SPSS Statistics Python & Syntax examples

https://www.ibm.com/docs/en/spss-statistics/29.0.0?topic=statistics-introduction-python-programs#python_package_intro

https://www.ibm.com/docs/en/spss-statistics/29.0.0?topic=python-running-code


https://github.com/sindresorhus/execa

# PYTHONENV.BAT
`
@for /f "tokens=* delims=" %%i in ('java.exe -Dapplication.home"=%SPSS_HOME%" -classpath "%SPSS_HOME%\*" com.spss.java_client.core.plugin.ConfigUtil %FOLDER_NAME%') do set PYTHON_HOME=%%i
@if "%PYTHON_HOME%" equ "internal" (
	call "%APPDATA%\IBM\SPSS Statistics\one\Python310\Scripts\activate.bat"
	goto module
)
@set PYTHONPATH="%SPSS_HOME%\%FOLDER_NAME%\Lib\site-packages";%PYTHONPATH%
@set PATH="%PYTHON_HOME%";%PATH%
`