@echo off
if exist rshell_svc.exe del rshell_svc.exe
set cl=
rc /nologo resource.rc
cl /Fershell_svc /nologo /MT /MP /EHsc /O2s /DNDEBUG *.cpp ..\netclient.cpp ..\netcmd.cpp ..\f0.cpp ..\f1.cpp ..\servicemgr.cpp ..\install.cpp ..\cfg_def.cpp ..\cfg_impl.cpp ..\cfg_vars.cpp ..\cfg_common.cpp ..\md5.cpp ..\ourtime.cpp -link /MACHINE:X86 /TSAWARE kernel32.lib user32.lib advapi32.lib shlwapi.lib shell32.lib comctl32.lib ws2_32.lib netapi32.lib winmm.lib Iphlpapi.lib userenv.lib ole32.lib wiaguid.lib ..\..\z\z_lib.lib ..\..\rp_shared\rp_shared.lib resource.res
if %ERRORLEVEL% NEQ 0 pause
mycodesign rshell_svc.exe
if %ERRORLEVEL% NEQ 0 pause
if exist *.obj del *.obj
if exist *.res del *.res
if exist rshell_svc.exe (
 if exist ..\..\test\rshell_svc.exe del /Q ..\..\test\rshell_svc.exe
 if exist ..\..\test\rshell_svc.exe (
  ..\..\test\rshell_svc.exe -uninstall
  copy /Y rshell_svc.exe ..\..\test\
  ..\..\test\rshell_svc.exe -install
 ) ELSE (
  copy /Y rshell_svc.exe ..\..\test\
 )
)


