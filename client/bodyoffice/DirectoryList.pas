unit DirectoryList;

interface

uses
  ComObj, ActiveX, BodyOffice_TLB, Office_TLB, Word_TLB, Excel_TLB,
  ComAddInUtils, Dialogs, Forms, OleServer, Types, Messages, ExtCtrls, Controls, CommCtrl;

type
  TDirectoryList = class(TAutoObject, IDTExtensibility2)
  private

    Host: IDispatch; //WordApplication;ExcelApplication
    WHost: WordApplication;
    EHost: ExcelApplication;
    IsWord: boolean;
    WA: TWordApplication;
    EA: TExcelApplication;
    bMainMenuEnabled : boolean;

    FButtonEventsSink: TCommandButtonEventSink; //open
    FButtonEventsSink2: TCommandButtonEventSink; //save as
    FButtonEventsSink3: TCommandButtonEventSink; //save
    FButtonEventsSink4: TCommandButtonEventSink; //PageNumber
    FButtonEventsSink5: TCommandButtonEventSink; //files

    procedure ChangeButtonState;
    procedure WADocumentOpen(ASender: TObject;
    const Doc: _Document);
    procedure WANewDocument(ASender: TObject;
    const Doc: _Document);
    procedure EANewWorkbook(ASender: TObject;
    const Wb: _Workbook);
    procedure EAWorkbookOpen(ASender: TObject;
    const Wb: _Workbook);
    procedure WADocumentBeforeClose(ASender: TObject;
      const Doc: _Document; var Cancel: WordBool);
    procedure EABeforeClose(ASender: TObject;
  const Wb: _Workbook; var Cancel: WordBool);
    procedure ButtonClick(Button: CommandBarButton; //Открыть
      var CancelDefault: WordBool);
    procedure ButtonClick2(Button: CommandBarButton;
      var CancelDefault: WordBool);                //Сохранить как...
    procedure ButtonClick3(Button: CommandBarButton;
      var CancelDefault: WordBool);                //Сохранить
    procedure ButtonClick4(Button: CommandBarButton;
      var CancelDefault: WordBool);                //Нумерация
    procedure ButtonClick5(Button: CommandBarButton;
      var CancelDefault: WordBool);                //files
    procedure BeforeDisconnect;
  protected
    procedure BeginShutdown(var custom: PSafeArray); safecall;
    procedure OnAddInsUpdate(var custom: PSafeArray); safecall;
    procedure OnConnection(const HostApp: IDispatch; ext_ConnectMode: Integer;
      const AddInInst: IDispatch; var custom: PSafeArray); safecall;
    procedure OnDisconnection(ext_DisconnectMode: Integer;
      var custom: PSafeArray); safecall;
    procedure OnStartupComplete(var custom: PSafeArray); safecall;
    { Protected declarations }
  private
    procedure ChangeExtControlState(id:integer;state:boolean);
  end;

implementation

uses Windows, Classes, ComServ, SysUtils, ShlObj, Registry, Variants, OpnSavF;

{$INCLUDE ..\rp_shared\RP_Shared.inc}

const
 //Константы ID пунктов меню
  cMenuFileID=30002;
  cMenuHelpID=30010;
  cPageParamID=247;
  cPrintAreaID=30255;
  cPrintID=4;
  cPrintPreviewID=109;

  dFileHistoryID=831;
  dViewPanelsID= 30045;
  dInsertObjectID=546;
  dServiceMacrosID=30017;
  dServiceNadstrID=943;
  dServiceTuneID=797;
  dServiceParamID=522;
  dDataImportID=30101;
  dDataXMLID=31268;
  dDataRenewID=459;
  dInsertFileID=777;
  dServiceNadstrShablID=751;
  dInsertGyperID=1576;
  dViewTaskPane=5746;

  dBarSaveID=3;
  dBarOpenID=23;
  dBarGyperID=1576;
  dBarReadID=7226;
  dBarMessageID=3738;
  dBarExtSearchID=5905;
  dBarHelp1ID=7343;
  dBarHelp2ID=984;
  dBarPublishID=9004;

  dCBOffice=809;
  dAutoText=30181;
  dField=772;
  dGyperID2=925;
  dHelpMaterials=7343;
  dCommonWork=30468;


  // Уникальный идентификатор кнопок Открыть и Сохранить
  BUTTON_TAG =   '{A386ED7E-DA3F-402F-A6B6-EB609EA7D7E5}'; //Open
  BUTTON_TAG2 =  '{0F7F2AF5-2F78-4385-B7AF-4607BDC74977}'; //Save As
  BUTTON_TAG3 =  '{6233B127-679D-47C7-BD7C-E2219D84A0FF}'; //Save
  BUTTON_TAG4 =  '{E4EAA67C-3BED-49E7-9B98-29EA939C5004}'; //Page Number
  BUTTON_TAG5 =  '{5A155784-0D44-49b3-A290-848A832BD795}'; //files

var LoadErrorCode :integer = 0;
    SaveExitProc : Pointer = nil;
    // дескрипторы ловушек
    HKey: hHook = 0;
    HMouse: hHook = 0;

    IsBeforeClose : boolean = false;

    h_api1 : pointer = nil;
    h_api2 : pointer = nil;


procedure HackAPIFunctions;
begin
 if h_api1=nil then
  h_api1:=HackCreateProcessA(true); //todo: is rp_sahred.dll will be loaded static from office dir?
 if h_api2=nil then
  h_api2:=HackCreateProcessW(true);
end;


procedure UnhackAPIFunctions;
begin
 if h_api1<>nil then
  UnhackCreateProcess(h_api1);
 if h_api2<>nil then
  UnhackCreateProcess(h_api2);
 h_api1:=nil;
 h_api2:=nil;
end;


//==============================================================================
// Функции ловушек мыши и клавиатуры
//==============================================================================

// ловушка клавиатуры
function Key_HookKey(code: integer; wParam: integer; lParam: integer): integer stdcall;
var bCTRL,bALT,bSHIFT : boolean;
begin
 if code >= 0 then
 begin
  bCTRL:=((GetKeyState(VK_CONTROL) and $8000)<>0);
  bALT:=((GetKeyState(VK_MENU) and $8000)<>0);
  bSHIFT:=((GetKeyState(VK_SHIFT) and $8000)<>0);
  if (wParam = VK_F12) or
     ((not bALT) and (not bCTRL) and (not bSHIFT) and (wParam = VK_F1)) or
     (bALT and (wParam = VK_F8)) or
     (bALT and (wParam = VK_F11)) or
     (bALT and bSHIFT and (wParam = VK_F2)) or
     (bALT and bSHIFT and (wParam = VK_F11)) or
     (bCTRL and (wParam = ord('O'))) or
     (bCTRL and (wParam = ord('S'))) or
     (bCTRL and (wParam = ord('P'))) or
     (bCTRL and (wParam = ord('K'))) or
     (bCTRL and (wParam = VK_F1)) or
     (bSHIFT and (wParam = VK_F1)) or
     (bSHIFT and (wParam = VK_F12)) then
   begin
    Result := 1;
    exit;
   end;
 end;

 Result := CallNextHookEx(HKey, Code, wParam, lParam);
end;

procedure StartKey;
// установка ловушки клавиатуры
begin
 if HKey = 0 then
   HKey := SetWindowsHookEx(WH_KEYBOARD, @Key_HookKey, 0{hInstance}, GetCurrentThreadId(){0});
end;

procedure RemoveHookKey;
// удаление ловушки клавиатуры
begin
 if HKey<>0 then
 begin
   UnhookWindowsHookEx(HKey);
   HKey := 0
 end;
end;

// ловушка мыши
function Key_HookMouse(code: integer; wParam: integer; lParam: integer): integer stdcall;
var s: array[0..MAX_PATH] of char;
begin
 if (code >= 0) and ((wParam = WM_RBUTTONDOWN) or (wParam = WM_RBUTTONUP)) then
 begin
  s[0]:=#0;
  GetClassName(PMouseHookStruct(lParam).hwnd, @s, sizeof(s));
  if (AnsiStrLComp(@s, 'MsoCommandBar', 13) = 0) or (AnsiStrLComp(@s, 'EXCEL2', 6) = 0) then
   begin
     Result := 1;
     exit;
   end;
 end;

 Result:= CallNextHookEx(HMouse, code, wParam, lParam);
end;

procedure StartMouse;
// установка ловушки мыши
begin
 if HMouse = 0 then
  HMouse := SetWindowsHookEx(WH_MOUSE, @Key_HookMouse, 0{hInstance}, GetCurrentThreadId(){0});
end;

procedure RemoveHookMouse;
// удаление ловушки мыши
begin
 if HMouse<>0 then
 begin
   UnhookWindowsHookEx(HMouse);
   HMouse:= 0
 end;
end;

procedure RemoveAllHooks;
// удаление всех установленных ловушек
begin
 RemoveHookMouse;
 RemoveHookKey;
 ExitProc := SaveExitProc;
end;

//===============================================================
//Функции форм Open и Save As
//===============================================================
//Open
function ShowOpenForm(Host: OleVariant; ISWord: boolean):boolean;
var f: TOpenSaveForm;
    FN: string;
    FNO: OleVariant;
    s_error : string;
begin
  f:=nil;
  Result:=false;

  s_error:=LS(600);
  
  try
    //if ISWord then
    //  Application.Handle := GetParent(FindWindow(nil, 'Microsoft Word'))
    //else
    //  Application.Handle := GetParent(FindWindow(nil, 'Microsoft Excel'));

    f := TOpenSaveForm.Create(Application);
    try
      if IsWord then
      begin
        if f.ExecuteOpenFile('*.doc|Microsoft Word (*.doc);*.rtf|Rich Text Format (*.rtf)', FN) then
        begin
          if FN <> '' then
          begin
            FNO:=FN;
            Host.Documents.Open(FNO, EmptyParam,EmptyParam,EmptyParam,
                                   EmptyParam,EmptyParam,EmptyParam,
                                   EmptyParam,EmptyParam,EmptyParam,
                                   EmptyParam, EmptyParam);
            Result:=true;
          end;
        end;
      end
      else
      begin
        if f.ExecuteOpenFile('*.xls|Microsoft Excel (*.xls);*.csv|CSV files (*.csv)', FN) then
        begin
          if FN <> '' then
          begin
            FNO:=FN;
            Host.Workbooks.Open(FNO, EmptyParam,EmptyParam,EmptyParam,
                                     EmptyParam,EmptyParam,EmptyParam,
                                     EmptyParam,EmptyParam,EmptyParam,
                                     EmptyParam,EmptyParam,EmptyParam);
            Result:=true;
          end;
        end;
      end;
    except showmessage(s_error);
    end;
  finally f.Free;
  end;
end;

//Save As
function ShowSaveForm(AD: OleVariant; IsWord: boolean):boolean;
var f: TOpenSaveForm;
    FN: string;
    IsNF: boolean;
    FNO: OleVariant;
    s_error : string;
begin
  IsNF:=true;
  f:=nil;
  Result:=false;

  s_error:=LS(601);
  
  try
    f := TOpenSaveForm.create(application);
    try
      if IsWord then
      begin
        if f.ExecuteSaveFile('*.doc|Microsoft Word (*.doc)', IsNF, FN) then
        begin
          if FN <> '' then
          begin
            FNO:=FN;
            AD.SaveAs(FNO);
            Result:=true;
          end;
        end;
      end
      else
      begin
        if f.ExecuteSaveFile('*.xls|Microsoft Excel (*.xls)', IsNF, FN) then
        begin
          if FN <> '' then
          begin
            FNO:=FN;
            AD.SaveAs(FNO);
            Result:=true;
          end;
        end
      end;
    except showmessage(s_error);
    end;
  finally f.Free;
  end;
end;

//Save
function SaveClick(AD: OleVariant; IsWord: boolean):boolean;
var s_error:string;
begin
 Result:=true;

 s_error:=LS(601);
 
 try
  if IsWord then
  begin
    if AD.Path <> ''
    then AD.SaveAs(AD.FullName)
    else ShowSaveForm(AD, IsWord);
  end
  else
  begin
   if AD.Path <> ''
   then AD.SaveAs(AD.FullName)
   else ShowSaveForm(AD, IsWord);
  end;
 except showmessage(s_error);
 end;
end;

//==============================================================================
// Методы класса TDirectoryList
//==============================================================================
procedure TDirectoryList.ChangeExtControlState(id:integer;state:boolean);
var varMainMenu:variant;
    i:integer;
begin
 try
   if IsWord then
     varMainMenu:=Whost.CommandBars.FindControls(EmptyParam,id,EmptyParam,EmptyParam)
   else
     varMainMenu:=Ehost.CommandBars.FindControls(EmptyParam,id,EmptyParam,EmptyParam);
   for i:=1 to varMainMenu.Count do
   begin
     try varMainMenu.Item[i].Enabled:=state; except end;
   end;
 except
 end;
end;


// Коннект к приложению, инициализация элементов
procedure TDirectoryList.OnConnection(const HostApp: IDispatch;
  ext_ConnectMode: Integer; const AddInInst: IDispatch;
  var custom: PSafeArray);
var
  Bar: CommandBar;
  Button: CommandBarButton;
  i,j : integer;
  varMainMenu: Variant;
  varMenuItem: Variant;
//  key2: wdKey;
//  key1,key3: olevariant;
  myKeysBoundTo: KeysBoundTo;
  NeedSave: OleVariant;
  AllowExtPrint : boolean;
  ProtectRunInOffice : boolean;
  reg : TRegistry;
  s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12:string;
begin

  bMainMenuEnabled:=false;
  ProtectRunInOffice:=true;
  AllowExtPrint := false;
  reg := TRegistry.Create;
  if reg.OpenKeyReadOnly( 'Software\RunpadProShell' ) then 
   begin
    try
     AllowExtPrint := reg.ReadBool('ext_office_print');
    except end;
    try
     ProtectRunInOffice := reg.ReadBool('protect_run_in_office');
    except end;
    try
     bMainMenuEnabled := reg.ReadBool('show_office_menu');
    except end;
    reg.CloseKey;
   end;
  reg.Free;

try

  LoadErrorCode:=1;
  NeedSave:=False;

  SaveExitProc := ExitProc;
  ExitProc := @RemoveAllHooks;

  // Сохраняем ссылку на WordApplication, Excel для
  // последующей работы с этой ссылкой
  try
    Host := HostApp as WordApplication;
    if (Host as WordApplication).Get_Name='Microsoft Word' then
      IsWord := true
    else
    begin
      Host := HostApp as ExcelApplication;
      IsWord := false;
    end;
  except
    Host := HostApp as ExcelApplication;
    IsWord := false;
  end;

  if IsWord then
  begin
    WHost := HostApp as WordApplication;
    WA := TWordApplication.Create(Application);
    WA.ConnectKind := ckRunningInstance;
    WA.AutoQuit:=true;
    WA.ConnectTo(WHost);
    WA.ondocumentbeforeclose := WADocumentBeforeClose;
    WA.OnNewDocument := WANewDocument;
    WA.OnDocumentOpen := WADocumentOpen;
  end
  else
  begin
    EHost := HostApp as ExcelApplication;
    EA := TExcelApplication.Create(Application);
    EA.ConnectKind := ckRunningInstance;
    EA.AutoQuit:=true;
    EA.ConnectTo(EHost);
    EA.OnWorkbookBeforeClose := EABeforeClose;
    EA.OnNewWorkbook := EANewWorkbook;
    EA.OnWorkbookOpen := EAWorkbookOpen;
  end;

  // Создаем обработчик событий для кнопок Открыть и Сохранить

  FButtonEventsSink := TCommandButtonEventSink.Create;
  FButtonEventsSink.OnClick := ButtonClick;

  FButtonEventsSink2 := TCommandButtonEventSink.Create;
  FButtonEventsSink2.OnClick := ButtonClick2;

  FButtonEventsSink3 := TCommandButtonEventSink.Create;
  FButtonEventsSink3.OnClick := ButtonClick3;

  FButtonEventsSink4 := TCommandButtonEventSink.Create;
  FButtonEventsSink4.OnClick := ButtonClick4;

  FButtonEventsSink5 := TCommandButtonEventSink.Create;
  FButtonEventsSink5.OnClick := ButtonClick5;

  // Создаем панель инструментов

  if IsWord then
  begin
    Bar := WHost.CommandBars.Add('ExtPanel', msoBarTop, false, true);
    Bar.Visible := true;
    Bar.Enabled := true;
  end
  else
  begin
    Bar := EHost.CommandBars.Add('ExtPanel', msoBarTop, false, true);
    Bar.Visible := true;
    Bar.Enabled := true;
  end;

  try

  s1:='[ '+LS(602)+' ]';
  s2:='[ '+LS(603)+' ]';
  s3:='[ '+LS(604)+' ]';
  s4:='[ '+LS(605)+' ]';
  s5:='[ '+LS(606)+' ]';
  s6:='[ '+LS(607)+' ]';
  s7:='[ '+LS(608)+' ]';
  s8:='[ '+LS(609)+' ]';
  s9:='[ '+LS(610)+' ]';
  s10:='[ '+LS(611)+' ]';
  s11:='[ '+LS(612)+' ]';
  s12:='[ '+LS(613)+' ]';

  // Создаем кнопку Выход
  Button := Bar.Controls.Add(msoControlButton, 752, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s1);

  // Создаем кнопку "выбор файлов"
  if not IsWord then
   begin
    Button := Bar.Controls.Add(msoControlButton, 1, BUTTON_TAG5, 1, true) as CommandBarButton;
    // Подключаем обработчик и устанавливаем свойства кнопки
    FButtonEventsSink5.Connect(Button);
    Button.Set_Style(msoButtonCaption);
    Button.Set_Tag(BUTTON_TAG5);
    Button.Set_Caption(s12);
   end;

  // Создаем кнопку Печать...
  if AllowExtPrint then
   begin
    Button := Bar.Controls.Add(msoControlButton, 4, emptyparam, 1, true) as CommandBarButton;
    Button.Set_Style(msoButtonCaption);
    Button.Set_Caption(s2);
   end;

  // Создаем кнопку Печать
  Button := Bar.Controls.Add(msoControlButton, 2521, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s3);

  // Создаем кнопку Preview
  Button := Bar.Controls.Add(msoControlButton, 109, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s4);

  // Создаем кнопку Нумерация...
  if IsWord then
  begin
    Button := Bar.Controls.Add(msoControlButton, 1, BUTTON_TAG4, 1, true) as CommandBarButton;
    FButtonEventsSink4.Connect(Button);
    Button.Set_Tag(BUTTON_TAG4);
  end
  else
    Button := Bar.Controls.Add(msoControlButton, 762, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s5);

  // Создаем кнопку Страница...
  Button := Bar.Controls.Add(msoControlButton, 247, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s6);

  // Создаем кнопку Закрыть
  Button := Bar.Controls.Add(msoControlButton, 106, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s7);

  // Создаем кнопку Сохранить как
  Button := Bar.Controls.Add(msoControlButton, 1, BUTTON_TAG2, 1, true) as CommandBarButton;
  // Подключаем обработчик и устанавливаем свойства кнопки
  FButtonEventsSink2.Connect(Button);
  Button.Set_Style(msoButtonCaption);
  Button.Set_Tag(BUTTON_TAG2);
  Button.Set_Caption(s8);

  // Создаем кнопку Сохранить
  Button := Bar.Controls.Add(msoControlButton, 1, BUTTON_TAG3, 1, true) as CommandBarButton;
  // Подключаем обработчик и устанавливаем свойства кнопки
  FButtonEventsSink3.Connect(Button);
  Button.Set_Style(msoButtonCaption);
  Button.Set_Tag(BUTTON_TAG3);
  Button.Set_Caption(s9);

  // Создаем кнопку Открыть
  Button := Bar.Controls.Add(msoControlButton, 1, BUTTON_TAG, 1, true) as CommandBarButton;
  // Подключаем обработчик и устанавливаем свойства кнопки
  FButtonEventsSink.Connect(Button);
  Button.Set_Style(msoButtonCaption);
  Button.Set_Tag(BUTTON_TAG);
  Button.Set_Caption(s10);

  // Создаем кнопку Создать
  Button := Bar.Controls.Add(msoControlButton, 2520, emptyparam, 1, true) as CommandBarButton;
  Button.Set_Style(msoButtonCaption);
  Button.Set_Caption(s11);

  except LoadErrorCode:=2;
  end;

  //Скрываем ненужные контролы
  try
      if IsWord then
        WHost.CommandBars.Item['Menu Bar'].Enabled:=bMainMenuEnabled
      else
        EHost.CommandBars.Item['WorkSheet Menu bar'].Enabled:=bMainMenuEnabled;

      if bMainMenuEnabled then
       begin
        if IsWord then
          varMainMenu:=WHost.CommandBars.Item['Menu Bar']
        else
          varMainMenu:=EHost.CommandBars.Item['WorkSheet Menu bar'];

        for j:=1 to varMainMenu.Controls.Count do
        begin
          varMenuItem:=varMainMenu.Controls.Item[j];
          if ((varMainMenu.Controls.Item[j].ID=cMenuFileId) and
             (varMainMenu.Controls.Item[j].Visible)) or
             ((varMainMenu.Controls.Item[j].ID=cMenuHelpId) and
             (varMainMenu.Controls.Item[j].Visible)) then      
          begin
            for i:=1 to varMenuItem.Controls.Count do
            begin
              if (varMenuItem.Controls.Item[i].ID <> cPageParamID) and
                 (varMenuItem.Controls.Item[i].ID <> cPrintAreaID) and
                 //(varMenuItem.Controls.Item[i].ID <> cPrintID) and
                 (varMenuItem.Controls.Item[i].ID <> cPrintPreviewID) then
              begin
               try
                 if varMenuItem.Controls.Item[i].Visible then varMenuItem.Controls.Item[i].Enabled:=false;
               except
               end;
              end;
            end;
          end
          else
          begin
            if (varMainMenu.Controls.Item[j].ID<>cMenuFileId) and
               (varMainMenu.Controls.Item[j].Visible) then
            begin
              for i:=1 to varMenuItem.Controls.Count do
              begin
                if (varMenuItem.Controls.Item[i].ID = dFileHistoryID) or
                   (varMenuItem.Controls.Item[i].ID = dInsertObjectID) or
                   (varMenuItem.Controls.Item[i].ID = dServiceMacrosID) or
                   (varMenuItem.Controls.Item[i].ID = dServiceNadstrID) or
                   (varMenuItem.Controls.Item[i].ID = dServiceTuneID) or
                   (varMenuItem.Controls.Item[i].ID = dServiceParamID) or
                   (varMenuItem.Controls.Item[i].ID = dDataImportID) or
                   (varMenuItem.Controls.Item[i].ID = dDataXMLID) or
                   (varMenuItem.Controls.Item[i].ID = dDataRenewID) or
                   (varMenuItem.Controls.Item[i].ID = dInsertFileID) or
                   (varMenuItem.Controls.Item[i].ID = dServiceNadstrShablID) or
                   (varMenuItem.Controls.Item[i].ID = dViewPanelsID) or
                   (varMenuItem.Controls.Item[i].ID = dInsertGyperID) or
                   (varMenuItem.Controls.Item[i].ID = dViewTaskPane) or
                   (varMenuItem.Controls.Item[i].ID = dCBOffice) or
                   (varMenuItem.Controls.Item[i].ID = dAutoText) or
                   (varMenuItem.Controls.Item[i].ID = dField) or
                   (varMenuItem.Controls.Item[i].ID = dGyperID2) or
                   (varMenuItem.Controls.Item[i].ID = dHelpMaterials) or
                   (varMenuItem.Controls.Item[i].ID = dCommonWork) then
                begin
                  try
                    if varMenuItem.Controls.Item[i].Visible then varMenuItem.Controls.Item[i].Enabled:=false;
                  except
                  end;
                end;
              end;
            end;
          end;
        end;
       end;

      if IsWord then
        varMainMenu:=WHost.CommandBars.Get_Item('Standard')
      else
        varMainMenu:=EHost.CommandBars.Get_Item('Standard');
      for j:=1 to varMainMenu.Controls.Count do
      begin
        if (varMainMenu.Controls.Item[j].ID = dBarSaveID) or
           (varMainMenu.Controls.Item[j].ID = dBarOpenID) or
           (varMainMenu.Controls.Item[j].ID = dBarGyperID) or
           (varMainMenu.Controls.Item[j].ID = dBarReadID) or
           (varMainMenu.Controls.Item[j].ID = dBarExtSearchID) or
           (varMainMenu.Controls.Item[j].ID = dBarHelp1ID) or
           (varMainMenu.Controls.Item[j].ID = dBarHelp2ID) or
           (varMainMenu.Controls.Item[j].ID = dBarPublishID) or
           (varMainMenu.Controls.Item[j].ID = dBarMessageID) then
          try
            varMainMenu.Controls.Item[j].Enabled:=false;
          except
          end;
      end;

      //Запрещаем правый клик на CommandBars и дополнительно горячие клавиши
      StartMouse;
      StartKey;

      //Удаляем горячие клвиши Save и Open
      if IsWord then
      begin
        myKeysBoundTo := WHost.KeysBoundTo[wdKeyCategoryCommand, 'FileOpen', EmptyParam];
        while myKeysBoundTo.Count>0 do
        begin
          for j := 1 to (myKeysBoundTo.Count) do
          try
            myKeysBoundTo.Item(j).Disable;
          except
          end;
        end;

        myKeysBoundTo := WHost.KeysBoundTo[wdKeyCategoryCommand, 'FileSave', EmptyParam];
        while myKeysBoundTo.Count>0 do
        begin
          for j := 1 to (myKeysBoundTo.Count) do
          try
            myKeysBoundTo.Item(j).Disable;
          except
          end;
        end;

        myKeysBoundTo := WHost.KeysBoundTo[wdKeyCategoryCommand, 'ViewTaskPane', EmptyParam];
        while myKeysBoundTo.Count>0 do
        begin
          for j := 1 to (myKeysBoundTo.Count) do
          try
            myKeysBoundTo.Item(j).Disable;
          except
          end;
        end;

      end
      else
      begin
        EHost.OnKey('^{F1}', '', LOCALE_USER_DEFAULT);
        EHost.OnKey('^s', '', LOCALE_USER_DEFAULT);
        EHost.OnKey('^S', '', LOCALE_USER_DEFAULT);
        EHost.OnKey('^o', '', LOCALE_USER_DEFAULT);
      end;

      //Скрываем Task Pane, запрещаем кастомизацию
      try
        if IsWord then
        begin
          //WHost.CommandBars.Item['Task Pane'].Enabled:=false;
          WHost.CommandBars.Item['Task Pane'].Visible:=false;
          WHost.CommandBars.DisableCustomize := true;
          WHost.DisplayRecentFiles := false;
          WHost.ShowWindowsInTaskbar:=false;
          WHost.CommandBars.Item['Reading Layout'].Visible:=false;
        end
        else
        begin
          //EHost.CommandBars.Item['Task Pane'].Enabled:=false;
          EHost.CommandBars.Item['Task Pane'].Visible:=false;
          EHost.CommandBars.DisableCustomize := true;
          EHost.DisplayRecentFiles := false;
          EHost.DisplayAlerts[LOCALE_USER_DEFAULT] := false;
          EHost.ShowWindowsInTaskbar:=false;
          EHost.CommandBars.Item['Reading Layout'].Visible:=false;
        end;
      except;
      end;

      //Запрещаем гиперссылку и поиск в контекстном меню
      ChangeExtControlState(1576,false);
      ChangeExtControlState(1577,false);
      ChangeExtControlState(7685,false);

  except LoadErrorCode:=3; //showmessage('Ошибка блокировки CommandBars !');
  end;

  if LoadErrorCode>1 then
  begin
    showmessage('Error loading! Error code: '+inttostr(LoadErrorCode));
    if IsWord then WHost.Quit(NeedSave, EmptyParam, EmptyParam)
    else EHost.Quit;
  end;

except
  begin
    showmessage('Error loading! Error code: '+inttostr(LoadErrorCode));
    if IsWord then WHost.Quit(NeedSave, EmptyParam, EmptyParam)
    else EHost.Quit;
  end;
end;

 if ProtectRunInOffice then
  HackAPIFunctions();
end;

// Перед отключением от приложения
procedure TDirectoryList.BeforeDisconnect;
var
//  Bar: CommandBar;
//  B: CommandBarButton;
  varMainMenu, varMenuItem: variant;
  i,j : integer;
//  myKeysBoundTo: KeysBoundTo;
begin
 UnhackAPIFunctions();
 
 try

  // Уничтожаем обработчик событий кнопки
  FreeAndNil(FButtonEventsSink);
  FreeAndNil(FButtonEventsSink2);
  FreeAndNil(FButtonEventsSink3);
  FreeAndNil(FButtonEventsSink4);
  FreeAndNil(FButtonEventsSink5);

  try
     //Открываем меню

      if IsWord then
        WHost.CommandBars.Item['Menu Bar'].Enabled:=true
      else
        EHost.CommandBars.Item['WorkSheet Menu bar'].Enabled:=true;

      if IsWord then
        varMainMenu:=WHost.CommandBars.Item['Menu Bar']
      else
        varMainMenu:=EHost.CommandBars.Item['WorkSheet Menu bar'];

      for j:=1 to varMainMenu.Controls.Count do
      begin
        varMenuItem:=varMainMenu.Controls.Item[j];
        if (varMainMenu.Controls.Item[j].ID=cMenuFileId) then
        begin
          for i:=1 to varMenuItem.Controls.Count do
          begin
            try
              varMenuItem.Controls.Item[i].Enabled:=true;
            except
            end;
         end;
        end
        else
        begin
          if (varMainMenu.Controls.Item[j].ID<>cMenuFileId) then
          begin
            for i:=1 to varMenuItem.Controls.Count do
            begin
              try
                varMenuItem.Controls.Item[i].Enabled:=true;
              except
              end;
            end;
          end;
        end;
      end;            

      //Открываем кнопки
      if IsWord then
        varMainMenu:=WHost.CommandBars.Get_Item('Standard')
      else
        varMainMenu:=EHost.CommandBars.Get_Item('Standard');
      for j:=1 to varMainMenu.Controls.Count do
      begin
        try
          varMainMenu.Controls.Item[j].Enabled:=true;
        except
        end;
      end;

      //Восстанавливаем горячие клвиши Save и Open
      if IsWord then
      begin
        WHost.KeyBindings.ClearAll;
      end;
      // Для Excel не нужно
      //else
      //begin
      //  EHost.OnKey('^{F1}', '', 0);
      //  EHost.OnKey('^s', '', 0);
      //  EHost.OnKey('^o', '', 0);
      //end;

      //Открываем Task Pane, разрешаем кастомизацию
      try
        if IsWord then
        begin
          //WHost.CommandBars.Item['Task Pane'].Enabled:=false;
          WHost.CommandBars.Item['Task Pane'].Visible:=true;
          WHost.CommandBars.DisableCustomize := false;
          WHost.DisplayRecentFiles := true;
          WHost.CommandBars.Item['Reading Layout'].Visible:=true;
        end
        else
        begin
          //EHost.CommandBars.Item['Task Pane'].Enabled:=false;
          EHost.CommandBars.Item['Task Pane'].Visible:=true;
          EHost.CommandBars.DisableCustomize := false;
          EHost.DisplayRecentFiles := true;
          EHost.DisplayAlerts[LOCALE_USER_DEFAULT] := true;
          EHost.CommandBars.Item['Reading Layout'].Visible:=true;
        end;
      except;
      end;

      //Открываем гиперссылку и поиск в контекстном меню
      ChangeExtControlState(1576,true);
      ChangeExtControlState(1577,true);
      ChangeExtControlState(7685,true);

  except ;//showmessage('Ошибка разблокировки CommandBars !');
  end;

  try
    if assigned(WA) then WA.Destroy;
    //if assigned(TEW) then TEW.Destroy;
    if assigned(EA) then EA.Destroy;
  except
  end;

  try
    if IsWord then
      WHost.NormalTemplate.Save;
  except
  end;

 except
 end;
end;

procedure TDirectoryList.OnDisconnection(ext_DisconnectMode: Integer;
  var custom: PSafeArray);
begin
  BeforeDisconnect;
end;

// Изменения состояния кнопок
procedure TDirectoryList.ChangeButtonState;
var B: CommandBarButton;
    Dcount: integer;
begin
 try
  if IsBeforeClose then Dcount:=1 else Dcount:=0;

  if IsWord then
  begin
    B := WHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG2, EmptyParam, msoFalse) as CommandBarButton;
    if WHost.Documents.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
    B := WHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG3, EmptyParam, msoFalse) as CommandBarButton;
    if WHost.Documents.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
    B := WHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG4, EmptyParam, msoFalse) as CommandBarButton;
    if WHost.Documents.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
  end
  else
  begin
    B := EHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG2, EmptyParam, msoFalse) as CommandBarButton;
    if EHost.Workbooks.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
    B := EHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG3, EmptyParam, msoFalse) as CommandBarButton;
    if EHost.Workbooks.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
    B := EHost.CommandBars.Item['ExtPanel'].FindControl(msoControlButton, EmptyParam, BUTTON_TAG5, EmptyParam, msoFalse) as CommandBarButton;
    if EHost.Workbooks.Count>Dcount then B.Enabled:=true else B.Enabled:=false;
  end;
 except
 end;
end;

procedure TDirectoryList.WADocumentOpen(ASender: TObject; const Doc: _Document);
begin
  ChangeButtonState;
end;

procedure TDirectoryList.WANewDocument(ASender: TObject; const Doc: _Document);
begin
  ChangeButtonState;
end;

procedure TDirectoryList.EANewWorkbook(ASender: TObject; const Wb: _Workbook);
begin
  ChangeButtonState;
end;

procedure TDirectoryList.EAWorkbookOpen(ASender: TObject; const Wb: _Workbook);
begin
  ChangeButtonState;
end;


//Перед закрытием документа Word
procedure TDirectoryList.WADocumentBeforeClose(ASender: TObject;
      const Doc: _Document; var Cancel: WordBool);
var str: string;
begin
  str := LS(614)+' '+Doc.Name+' ?';

  if not Doc.Saved then
  begin
    if application.messagebox(PAnsiChar(Str), 'Word',MB_YESNO) = IDYES	then
    begin
      SaveClick(Doc,IsWord);
      Doc.Saved:=true;
    end
    else
    begin
      Doc.Saved:=true;
    end;
  end;
  IsBeforeClose:=true;
  ChangeButtonState;
  IsBeforeClose:=false;
end;

//Перед закрытием книги Excel
procedure TDirectoryList.EABeforeClose(ASender: TObject;
  const Wb: _Workbook; var Cancel: WordBool);
var str: string;
begin
  Str:= LS(615)+' '+Wb.Name +' ?';

  if not Wb.Saved[LOCALE_USER_DEFAULT] then
  begin
    if application.messagebox(PAnsiChar(Str),'Excel',MB_YESNO) = IDYES	then
    begin
      SaveClick(Wb,IsWord);
      Wb.Saved[LOCALE_USER_DEFAULT]:=true;
    end
    else
    begin
      Wb.Saved[LOCALE_USER_DEFAULT]:=true;
    end;
  end;
  IsBeforeClose:=true;
  ChangeButtonState;
  IsBeforeClose:=false;
end;

//Open click
procedure TDirectoryList.ButtonClick(Button: CommandBarButton;
  var CancelDefault: WordBool);
begin
  ShowOpenForm(Host, IsWord);
end;

//Save as click
procedure TDirectoryList.ButtonClick2(Button: CommandBarButton;
  var CancelDefault: WordBool);
begin
  if IsWord then
  begin
    if (Host as WordApplication).Documents.Count >0 then
      ShowSaveForm((Host as WordApplication).ActiveDocument,IsWord);
  end
  else
  begin
    if (Host as ExcelApplication).Workbooks.Count >0 then
      ShowSaveForm((Host as ExcelApplication).ActiveWorkbook,IsWord);
  end;
end;

//Save click
procedure TDirectoryList.ButtonClick3(Button: CommandBarButton;
  var CancelDefault: WordBool);
begin
  if IsWord then
  begin
    if (Host as WordApplication).Documents.Count >0 then
      SaveClick((Host as WordApplication).ActiveDocument, IsWord);
  end
  else
  begin
    if (Host as ExcelApplication).Workbooks.Count >0 then
      SaveClick((Host as ExcelApplication).ActiveWorkbook, IsWord);
  end;
end;

//Нумерация
procedure TDirectoryList.ButtonClick4(Button: CommandBarButton;
  var CancelDefault: WordBool);
var i: integer;
    s1,s2:pchar;
begin
  try
    if WHost.Documents.Count=0 then exit;

    s1:=LSP(616);
    s2:=LSP(617);

    if Application.MessageBox(s1, s2, MB_YESNO )= IDNO	then
    begin
      for i:=1 to WHost.ActiveDocument.Sections.Item(1).Headers.Item(wdHeaderFooterPrimary).PageNumbers.Count do
        WHost.ActiveDocument.Sections.Item(1).Headers.Item(wdHeaderFooterPrimary).PageNumbers.Item(i).Delete;
      for i:=1 to WHost.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).PageNumbers.Count do
        WHost.ActiveDocument.Sections.Item(1).Footers.Item(wdHeaderFooterPrimary).PageNumbers.Item(i).Delete;
    end
    else
    begin
      WHost.Dialogs.Item(294).Show(EmptyParam);
    end;
  except end;
end;

//pages click
procedure TDirectoryList.ButtonClick5(Button: CommandBarButton;
  var CancelDefault: WordBool);
var wb_count,n,s_len,active_idx,idx : integer;
    p,q:pchar;
    v:OleVariant;
begin
  if IsWord then
  begin

  end
  else
  begin
   with (Host as ExcelApplication) do
    begin
     try
      wb_count:=WorkBooks.Count;
      if wb_count>0 then
       begin
        s_len:=0;
        for n:=1 to wb_count do
         s_len:=s_len+length(string(WorkBooks[n].Name))+1;
        inc(s_len); //NULL terminator
        GetMem(p,s_len);
        q:=p;
        active_idx:=0;
        for n:=1 to wb_count do
         begin
          if WorkBooks[n] = ActiveWorkBook then
           active_idx:=n-1;
          StrCopy(q,pchar(string(WorkBooks[n].Name)));
          q:=q+lstrlen(q)+1;
         end;
        q^:=#0;

        idx:=RPMessageBox(GetForegroundWindow(),LSP(618),LSP(619),p,active_idx,RPICON_QUESTION);

        if idx<>-1 then
         begin
          try
           WorkBooks[idx+1].Activate(v);
          except end;
         end;

        FreeMem(p);
       end;
     except
     end;
    end;
  end;
end;



// Остальные методы нам не нужны

procedure TDirectoryList.OnStartupComplete(var custom: PSafeArray);
begin
end;

procedure TDirectoryList.BeginShutdown(var custom: PSafeArray);
begin

end;

procedure TDirectoryList.OnAddInsUpdate(var custom: PSafeArray);
begin
end;

type
  TDirectoryListFactory=class(TAutoObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  private
//    procedure RegAddin(section:string; register:boolean);
  end;

{ TDirectoryListFactory }

{
procedure TDirectoryListFactory.RegAddin(section:string; register:boolean);
var
  Reg:TRegistry;
begin
  Reg:=nil;
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.LazyWrite:=false;
    if Register then 
    begin
      if Reg.OpenKey(Section,True) then
       begin
        try
          Reg.WriteString('FriendlyName','BodyOffice AddIn');
          Reg.WriteInteger('LoadBehavior',3);
        except end;
        Reg.CloseKey;
       end;
    end 
    else 
    begin
      Reg.DeleteKey(Section);
    end;
  finally
    Reg.Free;
  end;
end;
}

procedure TDirectoryListFactory.UpdateRegistry(Register: Boolean);
begin
// this is done externally by Runpad Shell !!!!!
{  inherited UpdateRegistry(Register);
  
  RegAddin('Software\Microsoft\Office\Word\Addins\BodyOffice.DTExtensibility2',Register);
  RegAddin('Software\Microsoft\Office\Excel\Addins\BodyOffice.DTExtensibility2',Register);}
end;


initialization
  TDirectoryListFactory.Create(ComServer, TDirectoryList, Class_DTExtensibility2,
    ciMultiInstance, tmApartment);
end.
