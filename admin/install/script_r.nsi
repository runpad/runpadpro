
Name "Runpad Pro Администратор"
!include "..\common\version_nsis.inc"

OutFile "setup.exe"
BGGradient 000000 000000 FFFFFF
BGAlpha 160
InstallDir "$PROGRAMFILES\Runpad Pro Admin"
InstallDirRegKey HKLM "SOFTWARE\RunpadProAdmin" "Install_Dir"
ComponentText "Выберите необходимые компоненты для установки"
DirText "Выберите директорию для инсталляции"
UninstallText "Этот мастер удалит компоненты с Вашего компьютера"
;ShowInstDetails show
AutoCloseWindow true
InstallColors /windows
UninstallExeName "uninstall.exe"


InstType "Базовая установка"
InstType "Полная установка"


Function .onInit
  IfNewOS OSOk
    MessageBox MB_OK|MB_ICONEXCLAMATION "Win95/98/ME/NT4 не поддерживаются программой"
    Abort
  OSOk:
  
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Установку необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:

  GetACP $0
  StrCmp $0 "1251" _CYR
    MessageBox MB_OK|MB_ICONEXCLAMATION "В ваших региональных настройках язык по умолчанию (для не-Unicode программ) выбран не кириллическим.$\nИзмените его на Русский, Украинский, Белорусский, Болгарский или Казахский, а также установите ваше корректное местоположение/страну.$\nВ противном случае правильная работа ПО не гарантируется."
  _CYR:

FunctionEnd


Function .onInstSuccess
 SetOutPath $INSTDIR
 Exec "$INSTDIR\rsdbconf.exe"
FunctionEnd


Function un.onInit
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Удаление необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:
FunctionEnd



Section ""
  SetOutPath $INSTDIR

  File "..\..\common\hh_wrapper\hh_wrapper.dll"
  File "..\..\common\help\help_all.chm"
  File "..\sql\*.dll"
  File "..\..\client\z\z_dll.dll"
  File "..\rsdbconf\rsdbconf.exe"
  File "..\rsdbbackup\rsdbbackup.exe"


  ;---------------------------
  ; the same list in client install!!!

  RmDir /r "$INSTDIR\update"

  SetOutPath "$INSTDIR\update\client\System32"
  File "..\..\client\rs_api\rs_api.dll"
  File "..\..\client\rshell\gina\rpgina.dll"

  SetOutPath "$INSTDIR\update\client\rs_folder"
  File "..\..\client\bodyacro\bodyacro.exe"
  File "..\..\client\bodybook\bodybook.exe"
  File "..\..\client\bodybt\bodybt.exe"
  File "..\..\client\bodybt\bftowdthunk.dll"
  File "..\..\client\bodyburn\bodyburn.exe"
  File "..\..\client\bodyburn\bodyburn.dll"
  File "..\..\client\bodycalc\bodycalc.exe"
  File "..\..\client\bodycam\bodycam.exe"
  File "..\..\client\bodyexpl\bodyexpl.exe"
  File "..\..\client\bodyexpl\bodyexpl.dll"
  File "..\..\client\bodyflash\bodyflash.exe"
  File "..\..\client\bodyimgview\bodyimgview.exe"
  File "..\..\client\bodyiso\bodyiso.exe"
  File "..\..\client\bodymail\bodymail.exe"
  File "..\..\client\bodyminimize\bodyminimize.exe"
  File "..\..\client\bodymobile\bodymobile.exe"
  File "..\..\client\bodymouse\bodymouse.exe"
  File "..\..\client\bodymp\bodymp.exe"
  File "..\..\client\bodynotepad\bodynotepad.exe"
  File "..\..\client\bodyoffice\bodyoffice.dll"
  File "..\..\client\bodyoffice2000\bodyoffice2000.dll"
  File "..\..\client\bodyrecycle\bodyrecycle.exe"
  File "..\..\client\bodyscan\bodyscan.exe"
  File "..\..\client\bodyscan\VSTwain.dll"
  File "..\..\client\bodytm\bodytm.exe"
  File "..\..\client\bodywb\bodywb.exe"
  File "..\..\client\bodywb\dll\bodywb.dll"
  File "..\..\client\bodywrappers\*.exe"
  File /r "..\..\client\default_cnt\default"
  File "..\..\client\internat\indicdll.dll"
  File "..\..\client\internat\internat.exe"
  File "..\..\client\modem_restart\modem_restart.exe"
  File "..\..\client\rp_shared\rp_shared.dll"
  File "..\..\client\rsblock\rsblock.exe"
  File "..\..\client\rsbrowser\rsbrowser.exe"
  File "..\..\client\rshell\dll\rshell.dll"
  File "..\..\client\rshell\exhook\rsexhook.dll"
  File "..\..\client\rshell\exhook\rsexhook64.dll"
  File "..\..\client\rshell\hook\rshelper.dll"
  File "..\..\client\rshell\hook\rshelper64.dll"
  File "..\..\client\rshell\inj_scan\inj_scan.dll"
  File "..\..\client\rshell\service\rshell_svc.exe"
  File "..\..\client\rshell\rshell.exe"
  File "..\..\client\rsoffindic\rsoffindic.exe"
  File "..\..\client\rsrules\rsrules.dll"
  File "..\..\client\rsrules\rsrules.exe"
  File "..\..\client\rsspoolcleaner\rsspoolcleaner.exe"
  File "..\..\client\rstempdrv\giveio.sys"
  File "..\..\common\redist\gdiplus.dll"
  File "..\..\common\redist\rtl70.bpl"
  File "..\..\common\redist\vcl70.bpl"
  File "..\..\common\redist\msvcr90.dll"
  File "..\..\common\redist\msvcp90.dll"
  File "..\..\common\redist\atl90.dll"
  File "..\..\common\redist\ib97e32.dll"
  File "..\..\common\redist\ib97u32.dll"
  File "..\..\common\redist\ibfs32.dll"

  File "..\..\client\rfmserver\rfmserver.exe"
  File "..\..\client\rsrdserver\rsrdserver.exe"
  
  ;-----
  ; NoShell Update list
  ;-----
  SetOutPath "$INSTDIR\update\client_no_shell\rs_folder"
  File "..\..\client\rp_shared\rp_shared.dll"
  File "..\..\client\rshell\dll\rshell.dll"
  File "..\..\client\rshell\service\rshell_svc.exe"
  File "..\..\common\redist\rtl70.bpl"
  File "..\..\common\redist\vcl70.bpl"
  ;-----------------------

  
  SetOutPath $INSTDIR
  
  WriteRegStr HKLM "SOFTWARE\RunpadProAdmin" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProAdmin" "DisplayName" "Runpad Pro Администратор"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProAdmin" "UninstallString" '"$INSTDIR\uninstall.exe"'

  CreateDirectory "$SMPROGRAMS_COMMON\Runpad Pro Администратор"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Удаление программы.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Конфигурация базы данных.lnk" "$INSTDIR\rsdbconf.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Сохранение и восстановление базы данных.lnk" "$INSTDIR\rsdbbackup.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Справка по Runpad Pro.lnk" "$INSTDIR\help_all.chm"
SectionEnd


Section "Программа глобальных настроек"
  SectionIn 1-2
  
  SetOutPath $INSTDIR
  File "..\classv\classv.exe"
  File "..\needed\saver_example.ini"
  File "..\rssettings\rssettings.exe"
  File "..\rssettings\rssettings.dll"
  File "..\..\client\rshell\rscfg.dll"
  File "..\..\client\rp_shared\rp_shared.dll"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Глобальные настройки.lnk" "$INSTDIR\rssettings.exe"
SectionEnd

SectionDivider

Section "Программа просмотра отчетов"
  SectionIn 1-2
  
  SetOutPath $INSTDIR
  File "..\rsdbview\rsdbview.exe"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Просмотр отчетов.lnk" "$INSTDIR\rsdbview.exe"
SectionEnd


Section "Удаленный файловый менеджер"
  SectionIn 2

  SetOutPath $INSTDIR
  File "..\rfmclient\rfmclient.exe"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Удаленный файловый менеджер.lnk" "$INSTDIR\rfmclient.exe"
SectionEnd


Section "Удаленное управление рабочим столом"
  SectionIn 2

  SetOutPath $INSTDIR
  File "..\rsrdclient\rsrdclient.exe"
  File "..\rsrdclient\rsrdclient.dll"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Администратор\Удаленное управление рабочим столом.lnk" "$INSTDIR\rsrdclient.exe"
SectionEnd



Section "Uninstall"
  call un.onInit

  RMDir /r "$SMPROGRAMS_COMMON\Runpad Pro Администратор"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProAdmin"
  DeleteRegValue HKLM "SOFTWARE\RunpadProAdmin" "Install_Dir"

  RmDir /r "$INSTDIR"

SectionEnd

