@echo off
if exist *.exe del *.exe
set cl=
cl /Ferslmsvc /nologo /MT /MP /EHsc /O2s /DNDEBUG *.cpp -link /MACHINE:X86 kernel32.lib user32.lib advapi32.lib shlwapi.lib ws2_32.lib
if %ERRORLEVEL% NEQ 0 pause
del *.obj
mycodesign rslmsvc.exe
if %ERRORLEVEL% NEQ 0 pause
