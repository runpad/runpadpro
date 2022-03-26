@echo off
if exist rpgina.dll del rpgina.dll
set cl=
rc /nologo resource.rc
cl -Ferpgina -LD -MT -O2s -nologo *.c -link /DEF:exp.def /MACHINE:X86 resource.res kernel32.lib user32.lib advapi32.lib shlwapi.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.exp del *.exp
if exist *.lib del *.lib
if exist *.res del *.res
