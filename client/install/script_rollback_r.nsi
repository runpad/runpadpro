
Name "Runpad Pro Клиент"
!include "..\common\version_nsis.inc"

OutFile "setup.exe"
BGGradient 000000 000000 FFFFFF
BGAlpha 160
InstallDir "$PROGRAMFILES\Runpad Pro Shell"
InstallDirRegKey HKLM "SOFTWARE\RunpadProShell" "Install_Dir"
ShowInstDetails nevershow
AutoCloseWindow true
InstallColors /windows
DirShow hide


Function .onInit
  IfNewOS OSOk
    MessageBox MB_OK|MB_ICONEXCLAMATION "Win95/98/ME/NT4 не поддерживаются программой"
    Abort
  OSOk:
  
  IfAdmin RightsOK
    MessageBox MB_OK|MB_ICONEXCLAMATION "Установку необходимо производить из-под учетной записи администратора"
    Abort
  RightsOK:

  ReadRegStr $0 HKLM "SOFTWARE\RunpadProShell" "update_finish_flag"
  StrCmp $0 "1" _UPD
  goto _LNext2
  _UPD:
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "Клиент находится в состоянии ожидания обновления.$\nНеобходимо перезагрузить компьютер и повторить установку.$\nПродолжить?$\n$\nНажмите [ДА] для продолжения (не рекомендуется)$\nНажмите [НЕТ] для выхода (рекомендуется)" IDYES _LNext2
    Abort
  _LNext2:
  DeleteRegValue HKLM "SOFTWARE\RunpadProShell" "update_finish_flag"
  
  IfFileExists "$INSTDIR\rshell.exe" 0 Label1
    MessageBox MB_OK|MB_ICONEXCLAMATION "Вы должны деинсталлировать предыдущую версию клиента (шелл) перед установкой этой версии"
    Abort
  Label1:

  IfFileExists "$INSTDIR\rshell_svc.exe" 0 Label2
    MessageBox MB_OK|MB_ICONINFORMATION "Клиент уже установлен.$\nВы можете только изменить настройки.$\nВсе действия над клиентом осуществляются с серверной части ПО (программа оператора)."
    SetOutPath $INSTDIR
    ExecWait "$INSTDIR\rshell_svc.exe -setup"
    Abort
  Label2:
  
  MessageBox MB_OKCANCEL|MB_ICONQUESTION "Установить клиентскую часть Runpad Pro на эту машину?" IDOK NoAbort
    Abort 
  NoAbort:


  SetOutPath $INSTDIR

  WriteRegStr HKLM "SOFTWARE\RunpadProShell" "Install_Dir" "$INSTDIR"

  RmDir /r "$INSTDIR\~RPS_UPD.TMP"

  ;---------------------------
  ; the same list in admin install!!!

  File "..\rp_shared\rp_shared.dll"
  File "..\rshell\dll\rshell.dll"
  File "..\rshell\service\rshell_svc.exe"
  File "..\..\common\redist\rtl70.bpl"
  File "..\..\common\redist\vcl70.bpl"
  ;---------------------------

  ExecWait "$INSTDIR\rshell_svc.exe -setup"
  ExecWaitHidden "$INSTDIR\rshell_svc.exe -install -silent"

FunctionEnd



Function .onInstSuccess
  MessageBox MB_OK|MB_ICONINFORMATION "Клиент успешно установлен!$\nВсе действия над клиентом осуществляются с серверной части ПО (программа оператора).$\n$\nВнимание! Для изменения настроек необходимо повторно запустить данную установку!"
FunctionEnd


Section ""
SectionEnd
