
Name "Runpad Pro Сервер"
!include "..\common\version_nsis.inc"

OutFile "setup.exe"
BGGradient 000000 000000 FFFFFF
BGAlpha 160
InstallDir "$PROGRAMFILES\Runpad Pro Server"
InstallDirRegKey HKLM "SOFTWARE\RunpadProServer" "Install_Dir"
ComponentText "Выберите необходимые компоненты для установки"
DirText "Выберите директорию для инсталляции"
UninstallText "Этот мастер удалит компоненты с Вашего компьютера"
;ShowInstDetails show
AutoCloseWindow true
InstallColors /windows
UninstallExeName "uninstall.exe"


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

;  MessageBox MB_OK|MB_ICONINFORMATION "Внимание!$\nНекоторые антивирусы ошибочно принимают файл rs_server.exe за вирус.$\nПоэтому рекомендуется не блокировать, а добавить в исключения антивируса данный файл. В противном случае правильная работа ПО не гарантируется!"

FunctionEnd


Function .onInstSuccess
 SetOutPath $INSTDIR
 Exec "$INSTDIR\rs_server_setup.exe"
FunctionEnd


Function un.onInit
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Удаление необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:
FunctionEnd



Section ""
  SetOutPath $INSTDIR

  IfFileExists "$INSTDIR\rs_server.exe" 0 Label1
    ExecWaitHidden "$INSTDIR\rs_server.exe -uninstall -silent"
    Sleep 1000
  Label1:
  
  File "..\..\admin\sql\*.dll"
  File "..\rs_server\rs_server.exe"
  File "..\rs_server_setup\rs_server_setup.exe"
  File "..\rs_server_setup\rs_server_setup.dll"
  File "..\needed\start_server.bat"
  File "..\needed\stop_server.bat"

  WriteRegStr HKLM "SOFTWARE\RunpadProServer" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProServer" "DisplayName" "Runpad Pro Сервер"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProServer" "UninstallString" '"$INSTDIR\uninstall.exe"'

  CreateDirectory "$SMPROGRAMS_COMMON\Runpad Pro Сервер"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Сервер\Настройки сервера.lnk" "$INSTDIR\rs_server_setup.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Сервер\Удаление программы.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Сервер\Остановить сервер.lnk" "$INSTDIR\stop_server.bat"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Сервер\Возобновить сервер.lnk" "$INSTDIR\start_server.bat"

  ; Vista + ASProtect workarounds
  SetWow64RegRedirector false
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\rs_server.exe" "DisableNXShowUI"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\rs_server_setup.exe" "DisableNXShowUI WINXPSP2"
  SetWow64RegRedirector true
  
  ExecWaitHidden 'netsh.exe firewall add allowedprogram "$INSTDIR\rs_server.exe" RunpadProServer ENABLE ALL'
  ExecWaitHidden "$INSTDIR\rs_server.exe -install -silent"

SectionEnd



Section "Uninstall"
  call un.onInit

  SetOutPath $INSTDIR

  IfFileExists "$INSTDIR\rs_server.exe" 0 Label1
    ExecWaitHidden "$INSTDIR\rs_server.exe -uninstall -silent"
    Sleep 1000
  Label1:

  RMDir /r "$SMPROGRAMS_COMMON\Runpad Pro Сервер"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProServer"
  DeleteRegValue HKLM "SOFTWARE\RunpadProServer" "Install_Dir"

  RmDir /r "$INSTDIR"

SectionEnd

