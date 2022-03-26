@echo off
if exist rsoffindic.exe del rsoffindic.exe
set cl=
rc /nologo resource.rc
cl /Fersoffindic /MT /EHsc /nologo /O2s *.cpp -link /MACHINE:X86 kernel32.lib user32.lib gdi32.lib comctl32.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.res del *.res
if exist *.obj del *.obj

if exist rsoffindic.exe copy /Y rsoffindic.exe ..\test\

