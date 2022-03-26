
Name "Runpad Pro Оператор"
!include "..\common\version_nsis.inc"

OutFile "setup.exe"
BGGradient 000000 000000 FFFFFF
BGAlpha 160
InstallDir "$PROGRAMFILES\Runpad Pro Operator"
InstallDirRegKey HKLM "SOFTWARE\RunpadProOperator" "Install_Dir"
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

  FindWindow goto:Abort1 "_RSOperatorClass"
  goto NoAbort1
  Abort1:
    MessageBox MB_OK|MB_ICONSTOP 'Вы должны закрыть программу "Runpad Pro Оператор" перед инсталляцией'
    Abort
  NoAbort1:

  GetACP $0
  StrCmp $0 "1251" _CYR
    MessageBox MB_OK|MB_ICONEXCLAMATION "В ваших региональных настройках язык по умолчанию (для не-Unicode программ) выбран не кириллическим.$\nИзмените его на Русский, Украинский, Белорусский, Болгарский или Казахский, а также установите ваше корректное местоположение/страну.$\nВ противном случае правильная работа ПО не гарантируется."
  _CYR:

FunctionEnd


Function .onInstSuccess
 SetOutPath $INSTDIR
 Exec "$INSTDIR\rsoperator.exe -setup"
FunctionEnd


Function un.onInit
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Удаление необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:

  FindWindow goto:Abort1 "_RSOperatorClass"
  goto NoAbort1
  Abort1:
    MessageBox MB_OK|MB_ICONSTOP 'Вы должны закрыть программу "Runpad Pro Оператор" перед удалением'
    Abort
  NoAbort1:
FunctionEnd



Section ""
  SetOutPath $INSTDIR
  File "..\..\admin\sql\*.dll"

  WriteRegStr HKLM "SOFTWARE\RunpadProOperator" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProOperator" "DisplayName" "Runpad Pro Оператор"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProOperator" "UninstallString" '"$INSTDIR\uninstall.exe"'

  CreateDirectory "$SMPROGRAMS_COMMON\Runpad Pro Оператор"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Оператор\Удаление программы.lnk" "$INSTDIR\uninstall.exe"
SectionEnd


Section "Программа оператора"
  
  SetOutPath $INSTDIR
  File "..\rsoperator\rsoperator.exe"
  File "..\rsoperator\dll\rsoperator.dll"
  File "..\rsstat\rsstat.exe"
  File "..\rsstat\dll\rsstat.dll"
  File "..\rsstat\help\rsstat.hlp"
  File "..\..\common\redist\gdiplus.dll"

  File "..\..\admin\rsrdclient\rsrdclient.exe"
  File "..\..\admin\rsrdclient\rsrdclient.dll"

  File "..\..\admin\rfmclient\rfmclient.exe"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Оператор\Программа оператора.lnk" "$INSTDIR\rsoperator.exe"
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Оператор\Настройки оператора.lnk" "$INSTDIR\rsoperator.exe" "-setup" "$INSTDIR\rsoperator.exe" 1
  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Оператор\Статистика запуска программ.lnk" "$INSTDIR\rsstat.exe"
SectionEnd


Section "Программа просмотра отчетов"
  
  SetOutPath $INSTDIR
  File "..\..\admin\rsdbview\rsdbview.exe"

  CreateShortCut "$SMPROGRAMS_COMMON\Runpad Pro Оператор\Просмотр отчетов.lnk" "$INSTDIR\rsdbview.exe"
SectionEnd



Section "Uninstall"
  call un.onInit

  RMDir /r "$SMPROGRAMS_COMMON\Runpad Pro Оператор"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProOperator"
  DeleteRegValue HKLM "SOFTWARE\RunpadProOperator" "Install_Dir"

  RmDir /r "$INSTDIR"

SectionEnd

