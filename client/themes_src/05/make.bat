@echo off
if exist *.dll del *.dll
if exist *.theme del *.theme
set cl=
rc /nologo resource.rc
rem cl -Fetheme -nologo /O2t /EHsc /MTd /LD /DDEBUG /D_DEBUG *.cpp common\*.cpp -link /DEF:exp.def /MACHINE:X86 kernel32.lib user32.lib gdi32.lib shlwapi.lib gdiplus.lib Msimg32.lib ole32.lib resource.res
cl -Fetheme -nologo /O2t /EHsc /MT /LD /DNDEBUG *.cpp common\*.cpp -link /DEF:exp.def /MACHINE:X86 kernel32.lib user32.lib gdi32.lib shlwapi.lib gdiplus.lib Msimg32.lib ole32.lib resource.res
if %ERRORLEVEL% NEQ 0 pause

mycodesign theme.dll
if %ERRORLEVEL% NEQ 0 pause

if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.obj del *.obj
if exist *.pch del *.pch
if exist *.res del *.res

if exist theme.dll rename theme.dll 05.theme

