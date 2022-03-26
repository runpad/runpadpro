@echo off
if exist h_mysql.dll del h_mysql.dll

set cl=
cl -nologo -Feh_mysql -LD -MT -O2t *.cpp advapi32.lib ws2_32.lib api\lib\mysqlclient.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib

if exist h_mysql.dll move /Y h_mysql.dll ..\
