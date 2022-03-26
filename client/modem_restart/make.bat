@echo off
if exist modem_restart.exe del modem_restart.exe
set cl=
rc /nologo resource.rc
cl -Femodem_restart -O2s -MT -nologo *.cpp -link /MACHINE:X86 resource.res kernel32.lib user32.lib shell32.lib advapi32.lib comctl32.lib ws2_32.lib wininet.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist modem_restart.exe copy /Y modem_restart.exe ..\test\

