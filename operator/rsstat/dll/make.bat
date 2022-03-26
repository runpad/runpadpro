@echo off
if exist rsstat.dll del rsstat.dll
set cl=
cl -Fersstat -LD -nologo -DNDEBUG -DSTAT_EXPORTS -D_STLP_USE_STATIC_LIB /Zp1 /O2t /EHsc /MT data.cpp -link /MACHINE:X86 kernel32.lib user32.lib shlwapi.lib advapi32.lib gdi32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist rsstat.dll copy /Y rsstat.dll ..\..\TEST\
