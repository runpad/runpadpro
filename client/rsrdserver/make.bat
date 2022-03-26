@echo off
if exist rsrdserver.exe del rsrdserver.exe
set cl=
rc /nologo resource.rc
cl /Fersrdserver /nologo /MT /MP /EHsc /O2s *.cpp ..\rshell\service\serviceman.cpp ..\rshell\f0.cpp -link /TSAWARE /MACHINE:X86 kernel32.lib user32.lib gdi32.lib advapi32.lib shlwapi.lib ws2_32.lib psapi.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
mycodesign rsrdserver.exe
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist rsrdserver.exe (
 if exist ..\test\rsrdserver.exe del /Q ..\test\rsrdserver.exe
 if exist ..\test\rsrdserver.exe (
  start /wait ..\test\rsrdserver.exe -uninstall
  copy /Y rsrdserver.exe ..\test\
  start /wait ..\test\rsrdserver.exe -install
 ) ELSE (
  copy /Y rsrdserver.exe ..\test\
 )
)
