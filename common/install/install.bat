@echo off

rar a -ep help_setup ..\help\help_setup.chm
if %ERRORLEVEL% NEQ 0 pause
if exist help_setup.rar move /Y help_setup.rar ..\..\!out\ >nul

if exist setup.exe del setup.exe
makensis_unc_req_admin_r.exe script_r.nsi
if %ERRORLEVEL% NEQ 0 pause
mycodesign setup.exe
if %ERRORLEVEL% NEQ 0 pause
if exist setup.exe move /Y setup.exe ..\..\!out\runpad_pro_setup.exe >nul
if exist ..\..\!out\runpad_pro_admin.exe del ..\..\!out\runpad_pro_admin.exe
if exist ..\..\!out\runpad_pro_operator.exe del ..\..\!out\runpad_pro_operator.exe
if exist ..\..\!out\runpad_pro_server.exe del ..\..\!out\runpad_pro_server.exe
if exist ..\..\!out\runpad_pro_client_shell.exe del ..\..\!out\runpad_pro_client_shell.exe
if exist ..\..\!out\runpad_pro_client_rollback.exe del ..\..\!out\runpad_pro_client_rollback.exe

