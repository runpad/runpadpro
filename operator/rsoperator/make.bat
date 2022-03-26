@echo off
if exist rsoperator.exe del rsoperator.exe
set cl=
rc /nologo resource.rc
cl -Fersoperator -nologo -DNDEBUG /O2s /EHsc /MT /MP *.cpp ..\..\client\rshell\f0.cpp ..\..\client\rshell\f1.cpp ..\..\client\rshell\netclient.cpp ..\..\client\rshell\netcmd.cpp -link /MACHINE:X86 kernel32.lib user32.lib gdi32.lib shlwapi.lib shell32.lib advapi32.lib ole32.lib ws2_32.lib comctl32.lib gdiplus.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
del *.obj
del *.res
if exist rsoperator.exe copy /Y rsoperator.exe ..\test\


