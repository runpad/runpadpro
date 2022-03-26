@echo off
copy /Y rslmsvc.exe %SystemRoot%\
netsh firewall add allowedprogram "%SystemRoot%\rslmsvc.exe" RSLicMgr ENABLE ALL
sc create RSLicMgr binPath= "%SystemRoot%\rslmsvc.exe -port 81" type= own start= auto DisplayName= "Runpad Pro Float License Manager"
sc start RSLicMgr
