@echo off
if exist bodyminimize.exe del bodyminimize.exe
set cl=
rc /nologo resource.rc
cl -Febodyminimize -O2s -nologo main.c -link /MACHINE:X86 /ENTRY:WinMain resource.res kernel32.lib user32.lib
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist bodyminimize.exe copy /Y bodyminimize.exe ..\test\


