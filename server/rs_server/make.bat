@echo off
if exist rs_server.exe del rs_server.exe
set cl=
rc /nologo resource.rc
cl /Fers_server /nologo /MT /MP /EHsc /O2s /DNDEBUG *.cpp ..\..\client\rshell\netcmd.cpp ..\..\client\rshell\f0.cpp ..\..\client\rshell\f1.cpp ..\..\admin\sql\h_sql.cpp -link /MACHINE:X86 /TSAWARE /STACK:131072 kernel32.lib user32.lib advapi32.lib shlwapi.lib shell32.lib ws2_32.lib ole32.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist *.exp del *.exp
if exist *.lib del *.lib
mycodesign rs_server.exe
if %ERRORLEVEL% NEQ 0 pause
if exist rs_server.exe (
 if exist ..\test\rs_server.exe del /Q ..\test\rs_server.exe
 if exist ..\test\rs_server.exe (
  ..\test\rs_server.exe -uninstall
  copy /Y rs_server.exe ..\test\
  ..\test\rs_server.exe -install
 ) ELSE (
  copy /Y rs_server.exe ..\test\
 )
)

