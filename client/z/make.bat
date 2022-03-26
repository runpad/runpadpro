@echo off

if exist z_dll.lib del z_dll.lib
if exist z_dll.dll del z_dll.dll
set cl=
cl -nologo -Fez_dll -MT -LD -O2t -DZ_DLL zlib\*.c kernel32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist z_dll.dll copy /Y z_dll.dll ..\..\admin\test\

if exist z_lib.lib del z_lib.lib
set cl=
cl -nologo -c -MT -O2t zlib\*.c
if %ERRORLEVEL% NEQ 0 pause
lib /NOLOGO /OUT:z_lib.lib *.obj
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
