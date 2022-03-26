
Name "Runpad Pro Клиент"
!include "..\common\version_nsis.inc"

OutFile "setup.exe"
BGGradient 000000 000000 FFFFFF
BGAlpha 160
InstallDir "$PROGRAMFILES\Runpad Pro Shell"
InstallDirRegKey HKLM "SOFTWARE\RunpadProShell" "Install_Dir"
ComponentText "Выберите необходимые компоненты для установки"
DirText "Выберите директорию для инсталляции"
UninstallText "Этот мастер удалит компоненты с Вашего компьютера"
;ShowInstDetails show
AutoCloseWindow false
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

  FindWindow goto:Abort1 "_RunpadClass"
  goto NoAbort1
  Abort1:
    MessageBox MB_OK|MB_ICONSTOP 'Вы должны отключить шелл перед инсталляцией'
    Abort
  NoAbort1:

  FindWindow goto:Abort2 "_rsoffindic_wnd_class"
  goto NoAbort2
  Abort2:
    MessageBox MB_OK|MB_ICONSTOP 'Невозможно продолжить пока шелл временно отключен'
    Abort
  NoAbort2:

  ReadRegStr $0 HKLM "SOFTWARE\RunpadProShell" "update_finish_flag"
  StrCmp $0 "1" _UPD
  goto _LNext2
  _UPD:
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "Шелл находится в состоянии ожидания обновления.$\nНеобходимо перезагрузить компьютер и повторить установку.$\nПродолжить?$\n$\nНажмите [ДА] для продолжения (не рекомендуется)$\nНажмите [НЕТ] для выхода (рекомендуется)" IDYES _LNext2
    Abort
  _LNext2:
  DeleteRegValue HKLM "SOFTWARE\RunpadProShell" "update_finish_flag"

FunctionEnd


Function .onInstSuccess

FunctionEnd


Function un.onInit
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Удаление необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:

  FindWindow goto:Abort1 "_RunpadClass"
  goto NoAbort1
  Abort1:
    MessageBox MB_OK|MB_ICONSTOP 'Вы должны отключить шелл перед деинсталляцией'
    Abort
  NoAbort1:

  FindWindow goto:Abort2 "_rsoffindic_wnd_class"
  goto NoAbort2
  Abort2:
    MessageBox MB_OK|MB_ICONSTOP 'Невозможно продолжить пока шелл временно отключен'
    Abort
  NoAbort2:

  MessageBox MB_OKCANCEL|MB_ICONQUESTION "Перед удалением программы рекомендуется отключить шелл на всех пользователях машины, на которых ранее он был установлен$\n$\nПродолжить?" IDOK NoAbort
    Abort 
  NoAbort:
FunctionEnd


Function un.onDone
  MessageBox MB_OK|MB_ICONINFORMATION "Деинсталляция успешно завершена!$\nТеперь рекомендуется перезагрузить компьютер"
FunctionEnd


Function GetLangStrings
  GetACP $0
  StrCmp $0 "1251" _CYR
  StrCpy $1 "Runpad Pro Shell"
  StrCpy $2 "Uninstall"
  StrCpy $3 "Shell settings"
  StrCpy $4 "Turn shell ON (for advanced users)"
  goto _LNext
  _CYR:
  StrCpy $1 "Runpad Pro Шелл"
  StrCpy $2 "Удаление программы"
  StrCpy $3 "Настройки шелла"
  StrCpy $4 "Включить шелл (только для опытных пользователей)"
  _LNext:
FunctionEnd

Function un.GetLangStrings
  GetACP $0
  StrCmp $0 "1251" _CYR
  StrCpy $1 "Runpad Pro Shell"
  goto _LNext
  _CYR:
  StrCpy $1 "Runpad Pro Шелл"
  _LNext:
FunctionEnd



Section ""
  IfFileExists "$INSTDIR\rshell_svc.exe" 0 Label1
  IfFileExists "$INSTDIR\rshell.exe" Label1 0
    MessageBox MB_OK|MB_ICONEXCLAMATION "Вы должны деинсталлировать предыдущую версию клиента перед установкой этой версии"
    Abort
  Label1:
  
  call GetLangStrings

  SetOutPath $INSTDIR

  WriteRegStr HKLM "SOFTWARE\RunpadProShell" "Install_Dir" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProShell" "DisplayName" $1
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProShell" "UninstallString" '"$INSTDIR\uninstall.exe"'

  CreateDirectory "$SMPROGRAMS_COMMON\$1"
  CreateShortCut "$SMPROGRAMS_COMMON\$1\$2.lnk" "$INSTDIR\uninstall.exe"
SectionEnd


Section "Клиентский/операторский шелл"
  SectionIn 1-2
  
  SetOutPath $INSTDIR

  File "..\psexec\psexec.exe"

  IfFileExists "$INSTDIR\rshell.exe" 0 Label1
    ExecWaitHidden '"$INSTDIR\psexec.exe" -s -accepteula -w "$INSTDIR" "$INSTDIR\rshell.exe" -uninstall -silent'
    Sleep 1000
  Label1:

  RmDir /r "$INSTDIR\~RPS_UPD.TMP"

  ;---------------------------
  ; the same list in admin install!!!


  ; on WOW64 we will be redirected to \SysWOW64 automatically
  SetOverwrite try
  SetOutPath $SYSDIR

  File "..\rs_api\rs_api.dll"
  File "..\rshell\gina\rpgina.dll"

  SetOutPath $INSTDIR
  SetOverwrite on


  File "..\bodyacro\bodyacro.exe"
  File "..\bodybook\bodybook.exe"
  File "..\bodybt\bodybt.exe"
  File "..\bodybt\bftowdthunk.dll"
  File "..\bodyburn\bodyburn.exe"
  File "..\bodyburn\bodyburn.dll"
  File "..\bodycalc\bodycalc.exe"
  File "..\bodycam\bodycam.exe"
  File "..\bodyexpl\bodyexpl.exe"
  File "..\bodyexpl\bodyexpl.dll"
  File "..\bodyflash\bodyflash.exe"
  File "..\bodyimgview\bodyimgview.exe"
  File "..\bodyiso\bodyiso.exe"
  File "..\bodymail\bodymail.exe"
  File "..\bodyminimize\bodyminimize.exe"
  File "..\bodymobile\bodymobile.exe"
  File "..\bodymouse\bodymouse.exe"
  File "..\bodymp\bodymp.exe"
  File "..\bodynotepad\bodynotepad.exe"
  File "..\bodyoffice\bodyoffice.dll"
  File "..\bodyoffice2000\bodyoffice2000.dll"
  File "..\bodyrecycle\bodyrecycle.exe"
  File "..\bodyscan\bodyscan.exe"
  File "..\bodyscan\VSTwain.dll"
  File "..\bodytm\bodytm.exe"
  File "..\bodywb\bodywb.exe"
  File "..\bodywb\dll\bodywb.dll"
  File "..\bodywrappers\*.exe"
  File /r "..\default_cnt\default"
  File "..\internat\indicdll.dll"
  File "..\internat\internat.exe"
  File "..\modem_restart\modem_restart.exe"
  File "..\rp_shared\rp_shared.dll"
  File "..\rsblock\rsblock.exe"
  File "..\rsbrowser\rsbrowser.exe"
  File "..\rshell\dll\rshell.dll"

  SetOverwrite try
  File "..\rshell\exhook\rsexhook.dll"
  File "..\rshell\exhook\rsexhook64.dll"
  SetOverwrite on

  File "..\rshell\hook\rshelper.dll"
  File "..\rshell\hook\rshelper64.dll"
  File "..\rshell\inj_scan\inj_scan.dll"
  File "..\rshell\service\rshell_svc.exe"
  File "..\rshell\rshell.exe"
  File "..\rsoffindic\rsoffindic.exe"
  File "..\rsrules\rsrules.dll"
  File "..\rsrules\rsrules.exe"
  File "..\rsspoolcleaner\rsspoolcleaner.exe"
  File "..\rstempdrv\giveio.sys"
  File "..\..\common\redist\gdiplus.dll"
  File "..\..\common\redist\rtl70.bpl"
  File "..\..\common\redist\vcl70.bpl"
  File "..\..\common\redist\msvcr90.dll"
  File "..\..\common\redist\msvcp90.dll"
  File "..\..\common\redist\atl90.dll"
  File "..\..\common\redist\ib97e32.dll"
  File "..\..\common\redist\ib97u32.dll"
  File "..\..\common\redist\ibfs32.dll"
  ;---------------------------

  call GetLangStrings

  CreateShortCut "$SMPROGRAMS_COMMON\$1\$4.lnk" "$INSTDIR\rshell.exe" "-turnON" "$INSTDIR\rshell.exe" 0
  CreateShortCut "$SMPROGRAMS_COMMON\$1\$3.lnk" "$INSTDIR\rshell.exe" "" "$INSTDIR\rshell.exe" 1

  HideWindow
  ExecWait "$INSTDIR\rshell.exe"
  BringToFront

  ExecWaitHidden '"$INSTDIR\psexec.exe" -s -accepteula -w "$INSTDIR" "$INSTDIR\rshell.exe" -install -silent'
SectionEnd


SectionDivider


Section "Сервис удаленного менеджера файлов"
  SectionIn 2

  SetOutPath $INSTDIR

  IfFileExists "$INSTDIR\rfmserver.exe" 0 Label1
    ExecWaitHidden "$INSTDIR\rfmserver.exe -uninstall -silent"
    Sleep 1000
  Label1:
  
  File "..\rfmserver\rfmserver.exe"

  ExecWaitHidden 'netsh.exe firewall add allowedprogram "$INSTDIR\rfmserver.exe" RunpadProRFMServer ENABLE ALL'
  ExecWaitHidden "$INSTDIR\rfmserver.exe -install -silent"
SectionEnd


Section "Сервис удаленного управления"
  SectionIn 2

  SetOutPath $INSTDIR

  IfFileExists "$INSTDIR\rsrdserver.exe" 0 Label1
    ExecWaitHidden "$INSTDIR\rsrdserver.exe -uninstall -silent"
    Sleep 1000
  Label1:
  
  File "..\rsrdserver\rsrdserver.exe"

  ExecWaitHidden 'netsh.exe firewall add allowedprogram "$INSTDIR\rsrdserver.exe" RunpadProRDServer ENABLE ALL'
  ExecWaitHidden "$INSTDIR\rsrdserver.exe -install -silent"
SectionEnd



Section "Uninstall"
  call un.onInit

  SetOutPath $INSTDIR

  IfFileExists "$INSTDIR\rfmserver.exe" 0 Label3
    ExecWaitHidden "$INSTDIR\rfmserver.exe -uninstall -silent"
    Sleep 1000
  Label3:

  IfFileExists "$INSTDIR\rsrdserver.exe" 0 Label4
    ExecWaitHidden "$INSTDIR\rsrdserver.exe -uninstall -silent"
    Sleep 1000
  Label4:

  IfFileExists "$INSTDIR\rshell.exe" 0 Label1
    ExecWaitHidden '"$INSTDIR\psexec.exe" -s -accepteula -w "$INSTDIR" "$INSTDIR\rshell.exe" -uninstall -silent'
    Sleep 1000
  Label1:

  DeleteRegValue HKLM "SOFTWARE\RunpadProShell" "update_finish_flag"
  
  call un.GetLangStrings

  RMDir /r "$SMPROGRAMS_COMMON\$1"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\RunpadProShell"
  DeleteRegValue HKLM "SOFTWARE\RunpadProShell" "Install_Dir"

  RmDir /r "$INSTDIR"

  call un.onDone
SectionEnd

