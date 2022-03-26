@echo off
if exist rsspoolcleaner.exe del rsspoolcleaner.exe
set cl=
rc /nologo resource.rc
cl -Fersspoolcleaner -O2s -nologo main.c -link /MACHINE:X86 /ENTRY:main kernel32.lib winspool.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist rsspoolcleaner.exe copy /Y rsspoolcleaner.exe ..\test\

