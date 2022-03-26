@echo off

set cl=

if exist rsexhook.dll del rsexhook.dll
if exist rsexhook64.dll del rsexhook64.dll

rem ---- 32-bit ----
cl -nologo -Fersexhook -O2s -MT -LD -EHsc -DNDEBUG *.cpp -link /MACHINE:X86 /DEF:exp.def kernel32.lib user32.lib uuid.lib comdlg32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
mycodesign rsexhook.dll
if %ERRORLEVEL% NEQ 0 pause

rem ---- 64-bit ----
call pushvcvars.bat
call setvcvars64.bat
cl -nologo -Fersexhook64 -O2s -MT -LD -EHsc -DNDEBUG *.cpp -link /MACHINE:X64 /DEF:exp.def kernel32.lib user32.lib uuid.lib comdlg32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
mycodesign rsexhook64.dll
if %ERRORLEVEL% NEQ 0 pause
call popvcvars.bat

if exist rsexhook.dll copy /Y rsexhook.dll ..\..\test\
if exist rsexhook64.dll copy /Y rsexhook64.dll ..\..\test\

