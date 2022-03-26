@echo off
if exist setup.exe del setup.exe
makensis_unc_req_admin_r.exe script_r.nsi
if %ERRORLEVEL% NEQ 0 pause
if exist setup.exe move /Y setup.exe ..\..\!out\runpad_pro_operator.exe >nul



