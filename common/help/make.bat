@echo off
if exist *.chm del *.chm
hhc help_all.hhp
if %ERRORLEVEL% EQU 0 pause
if exist help_all.chm copy /Y help_all.chm help_setup.chm
if exist help_all.chm copy /Y help_all.chm ..\..\admin\test\
