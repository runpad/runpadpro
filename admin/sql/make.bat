@echo off

if exist *.dll del *.dll

cd mssql
call make.bat
cd..

cd mysql
call make.bat
cd..

copy /Y *.dll ..\test\
copy /Y *.dll ..\..\operator\test\
copy /Y *.dll ..\..\server\test\
