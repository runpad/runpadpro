unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, ImgList, StdCtrls, ActiveX,
  global, login, h_sql;


type
  TRSSettingsForm = class(TForm)
    Panel1: TPanel;
    ImageTop: TImage;
    ImageBottom: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ButtonConnect: TToolButton;
    ButtonDisconnect: TToolButton;
    ToolButtonSep1: TToolButton;
    Bevel2: TBevel;
    Panel3: TPanel;
    ButtonDBConf: TToolButton;
    ToolButtonSep2: TToolButton;
    ButtonHelp: TToolButton;
    ImageList1: TImageList;
    Panel4: TPanel;
    Bevel3: TBevel;
    ImageCenter: TImage;
    ImageList2: TImageList;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet0: TTabSheet;
    Panel5: TPanel;
    Panel6: TPanel;
    ImageList3: TImageList;
    ImageList4: TImageList;
    Panel12: TPanel;
    GroupBox4: TGroupBox;
    Splitter2: TSplitter;
    Panel13: TPanel;
    CoolBar4: TCoolBar;
    ToolBar4: TToolBar;
    ButtonUserAdd: TToolButton;
    ButtonUserDel: TToolButton;
    ListBoxUsers: TListBox;
    ButtonUserEdit: TToolButton;
    PanelRights: TPanel;
    GroupBox5: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    GroupBox6: TGroupBox;
    CheckBox7: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox13: TCheckBox;
    ButtonSetRights: TButton;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    Panel7: TPanel;
    ComboBoxSettType: TComboBox;
    Panel8: TPanel;
    Splitter1: TSplitter;
    Panel9: TPanel;
    Panel10: TPanel;
    GroupBox1: TGroupBox;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ButtonVarsAdd: TToolButton;
    ButtonVarsEdit: TToolButton;
    ButtonVarsDel: TToolButton;
    ListBoxVars: TListBox;
    Panel11: TPanel;
    GroupBox2: TGroupBox;
    CoolBar2: TCoolBar;
    ToolBar2: TToolBar;
    ButtonCntAdd: TToolButton;
    ButtonCntEdit: TToolButton;
    ButtonCntDel: TToolButton;
    ListBoxCnts: TListBox;
    Panel14: TPanel;
    GroupBox3: TGroupBox;
    Bevel4: TBevel;
    CoolBar3: TCoolBar;
    ToolBar3: TToolBar;
    ButtonRuleAdd: TToolButton;
    ButtonRuleEdit: TToolButton;
    ButtonRuleDel: TToolButton;
    ButtonSep1: TToolButton;
    ButtonRuleMoveUp: TToolButton;
    ButtonRuleMoveDown: TToolButton;
    MemoRulesHelp: TMemo;
    ListViewRules: TListView;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonConnectClick(Sender: TObject);
    procedure ButtonDisconnectClick(Sender: TObject);
    procedure ButtonDBConfClick(Sender: TObject);
    procedure ButtonHelpClick(Sender: TObject);
    procedure Panel8Resize(Sender: TObject);
    procedure ListBoxVarsExit(Sender: TObject);
    procedure ListBoxCntsExit(Sender: TObject);
    procedure Panel9Resize(Sender: TObject);
    procedure ListViewRulesEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure TabSheet2Show(Sender: TObject);
    procedure ListViewRulesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewRulesExit(Sender: TObject);
    procedure ListBoxVarsClick(Sender: TObject);
    procedure ListBoxCntsClick(Sender: TObject);
    procedure ButtonVarsAddClick(Sender: TObject);
    procedure ButtonVarsEditClick(Sender: TObject);
    procedure ButtonVarsDelClick(Sender: TObject);
    procedure ButtonCntAddClick(Sender: TObject);
    procedure ButtonCntEditClick(Sender: TObject);
    procedure ButtonCntDelClick(Sender: TObject);
    procedure ButtonRuleAddClick(Sender: TObject);
    procedure ButtonRuleEditClick(Sender: TObject);
    procedure ButtonRuleDelClick(Sender: TObject);
    procedure ButtonRuleMoveUpClick(Sender: TObject);
    procedure ButtonRuleMoveDownClick(Sender: TObject);
    procedure ListBoxVarsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxCntsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBoxVarsDblClick(Sender: TObject);
    procedure ListBoxCntsDblClick(Sender: TObject);
    procedure ListViewRulesDblClick(Sender: TObject);
    procedure ListViewRulesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabSheet1Show(Sender: TObject);
    procedure ListBoxUsersClick(Sender: TObject);
    procedure ListBoxUsersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonUserAddClick(Sender: TObject);
    procedure ButtonUserDelClick(Sender: TObject);
    procedure ButtonUserEditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonSetRightsClick(Sender: TObject);
    procedure ComboBoxSettTypeSelect(Sender: TObject);
  private
    msg_login : cardinal;
    LoginForm : TLoginForm;
    sql : TSQLLib;
    { Private declarations }
    procedure UpdateView(conn:boolean);
    function TryConnect(server:string;server_type:integer;login,pwd:string):boolean;
    procedure UpdateStatusString(s:string;process_messages:boolean);
    procedure SettingsPageSelectionChanged();
    procedure UsersPageSelectionChanged();
    procedure UpdateEntireSettingsPage();
    procedure UpdateEntireUsersPage();
    procedure DeleteProfileInternal(lb:TListBox;profile_type:integer);
    procedure SwapRuleItemsContent(src,dest:integer);
    function GetListBoxIdx(lb:TListBox;const s:string):integer;
    procedure AddProfileInternal(lb:TListBox;profile_type:integer);
    function DBUsersCB(i:PEXECSQLCBSTRUCT):boolean;
    function ApplyUserRightsInternal(user_name,rights:string):boolean;
    procedure FillRightsPageFromString(s:string);
    function MakeStringFromRightsPage():string;
    function GetDefaultRightsString():string;
    function DBVarsProfilesNameCB(i:PEXECSQLCBSTRUCT):boolean;
    function DBContentProfilesNameCB(i:PEXECSQLCBSTRUCT):boolean;
    function DBRulesCB(i:PEXECSQLCBSTRUCT):boolean;
    function LoadProfileInternalBuffSize(name:string;profile_type:integer;_size:pinteger):pointer;
    function LoadProfileInternal(name:string;profile_type,machine_type,lang:integer):boolean;
    function SaveProfileInternal(name:string;profile_type:integer):boolean;
    procedure EditProfileInternal(lb:TListBox;profile_type:integer);
    function SaveAllRulesInternal:boolean;
    function IsUserSettings:boolean;
    function IsCompSettings:boolean;
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  RSSettingsForm: TRSSettingsForm;

implementation

uses Commctrl, ShellApi, StrUtils, tools, lang, setupcnt, setupvars, rule, profile, user, VistaAltFixUnit;

{$R *.dfm}

{$I ur.inc}


procedure TRSSettingsForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=msg_login then
  begin
   if ButtonConnect.Enabled then
    ButtonConnectClick(nil);
   Handled := True;
  end;
end;

procedure TRSSettingsForm.FormCreate(Sender: TObject);
begin
 CoInitialize(nil);

 sql:=nil;
 LoginForm:=TLoginForm.CreateForm();

 ThousandSeparator:=#0;
 DecimalSeparator:='.';
 DateSeparator:='/';
 TimeSeparator:=':';

 ImageList1.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 4, 1);
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(100)));
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(101)));
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(102)));
 ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(103)));

 ImageList2.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 2, 1);
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(110)));
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(111)));

 ButtonDBConf.Enabled:=FileExists(GetLocalPath(PATH_DBCONF));
 ButtonHelp.Enabled:=FileExists(GetLocalPath(PATH_HELP));

 Constraints.MinHeight:=Height;
 Constraints.MinWidth:=Width;
 WindowState:=wsMaximized;

 UpdateView(false);

 msg_login:=RegisterWindowMessage('_RSSettingsFormLogin');
 Application.OnMessage := AppMessage;

 TVistaAltFix.Create(Self);
end;

procedure TRSSettingsForm.FormDestroy(Sender: TObject);
begin
 Application.OnMessage:=nil;
 FreeAndNil(LoginForm);
 FreeAndNil(sql);
 CoUninitialize();
 HHW_Close();
end;

procedure TRSSettingsForm.FormShow(Sender: TObject);
begin
 PostMessage(Handle,msg_login,0,0);
end;

procedure TRSSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if (not ButtonConnect.Enabled) and ButtonDisconnect.Enabled then
  ButtonDisconnectClick(Sender);
end;

procedure TRSSettingsForm.UpdateStatusString(s:string;process_messages:boolean);
begin
 StatusBar.Panels[1].Text:=' '+s;
 if process_messages then
  Application.ProcessMessages;
end;

procedure TRSSettingsForm.ButtonConnectClick(Sender: TObject);
var rc:boolean;
begin
 if LoginForm.ShowModal=mrOK then
  begin
   UpdateStatusString(S_CONNECTING,false);
   Update;
   WaitCursor(true,true);

   rc:=TryConnect(LoginForm.GetServer,LoginForm.GetServerType,LoginForm.GetLogin,LoginForm.GetPwd);

   WaitCursor(false,false);

   if rc then
    begin
     LoginForm.WriteConfig;
     UpdateView(true);
     //TipForm.ShowTip(?);
    end
   else
     UpdateStatusString(S_ERRCONNECT,false);
  end;
end;

procedure TRSSettingsForm.ButtonDisconnectClick(Sender: TObject);
begin
 WaitCursor(true,false);
 UpdateView(false);
 FreeAndNil(sql);
 WaitCursor(false,false);
end;

function TRSSettingsForm.TryConnect(server:string;server_type:integer;login,pwd:string):boolean;
var err:string;
begin
 FreeAndNil(sql);
 sql:=TSQLLib.Create(server_type);

 if sql.ConnectAsNormalUser(server,login,pwd) then
  begin
   Result:=true;
  end
 else
  begin
   err:=sql.GetLastError;
   Result:=false;
   FreeAndNil(sql);
   MessageBox(Handle,pchar(err),S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TRSSettingsForm.UpdateView(conn:boolean);
begin
 if conn then
  begin
   ButtonConnect.Enabled:=false;
   ButtonDisconnect.Enabled:=true;
   Caption:=Application.Title + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')';
   UpdateStatusString(S_CONNECTED + '  (' + LoginForm.GetServer() + '/' + LoginForm.GetLogin() + ')',false);
   PageControl.ActivePageIndex:=0;
   PageControl.Visible:=true;
  end
 else
  begin
   ButtonConnect.Enabled:=true;
   ButtonDisconnect.Enabled:=false;
   PageControl.Visible:=false;
   Caption:=Application.Title;
   UpdateStatusString(S_NOTCONNECTED,false);
  end;
end;


procedure TRSSettingsForm.ButtonDBConfClick(Sender: TObject);
begin
 ExecLocalFile(PATH_DBCONF);
end;

procedure TRSSettingsForm.ButtonHelpClick(Sender: TObject);
begin
 HHW_DisplayTopic(0,pchar(GetLocalPath(PATH_HELP)),nil,nil);
end;

function GetFieldValueAsDelphiString(i:PEXECSQLCBSTRUCT;f:pointer):string;
var p:pchar;
begin
 Result:='';
 p:=i.GetFieldValueAsString(i.obj,f);
 if p<>nil then
  begin
   Result:=p;
   i.FreePointer(p);
  end;
end;

////////////////////////////////

procedure TRSSettingsForm.TabSheet2Show(Sender: TObject);
begin
 ComboBoxSettType.ItemIndex:=0;
 ComboBoxSettType.OnSelect(ComboBoxSettType);
end;

function TRSSettingsForm.IsUserSettings:boolean;
begin
 Result:=ComboBoxSettType.ItemIndex=1;
end;

function TRSSettingsForm.IsCompSettings:boolean;
begin
 Result:=ComboBoxSettType.ItemIndex=2;
end;

procedure TRSSettingsForm.ComboBoxSettTypeSelect(Sender: TObject);
begin
 if ComboBoxSettType.ItemIndex=0 then
  begin
   Panel8.Visible:=false;
   ComboBoxSettType.SetFocus;
  end
 else
 if ComboBoxSettType.ItemIndex=1 then
  begin
   Panel11.Visible:=true;
   ListViewRules.Columns[2].Caption:=S_CONTENTPROFILE;
   MemoRulesHelp.Text:=S_RULESHELPUSER;
   Panel8.Visible:=true;
   Panel8.SetFocus;
   UpdateEntireSettingsPage();
  end
 else
  begin
   Panel11.Visible:=false;
   ListViewRules.Columns[2].Caption:='';
   MemoRulesHelp.Text:=S_RULESHELPCOMP;
   Panel8.Visible:=true;
   Panel8.SetFocus;
   UpdateEntireSettingsPage();
  end;
end;

procedure TRSSettingsForm.Panel8Resize(Sender: TObject);
begin
 Panel10.Height:=Panel8.Height div 2;
end;

procedure TRSSettingsForm.ListBoxVarsExit(Sender: TObject);
begin
 ListBoxVars.ItemIndex:=-1;
 SettingsPageSelectionChanged();
end;

procedure TRSSettingsForm.ListBoxCntsExit(Sender: TObject);
begin
 ListBoxCnts.ItemIndex:=-1;
 SettingsPageSelectionChanged();
end;

procedure TRSSettingsForm.Panel9Resize(Sender: TObject);
var w:integer;
begin
 MemoRulesHelp.Height:=Panel9.Height * 45 div 100;
 w:=ListViewRules.Width-(ListViewRules.Columns[1].Width+ListViewRules.Columns[2].Width+25);
 if w < 200 then
  w:=200;
 ListViewRules.Columns[0].Width:=w;
end;

procedure TRSSettingsForm.ListViewRulesEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TRSSettingsForm.SettingsPageSelectionChanged();
begin
 ButtonVarsAdd.Enabled:=true;
 ButtonVarsEdit.Enabled:=ListBoxVars.ItemIndex<>-1;
 ButtonVarsDel.Enabled:=ListBoxVars.ItemIndex<>-1;
 ButtonCntAdd.Enabled:=true;
 ButtonCntEdit.Enabled:=ListBoxCnts.ItemIndex<>-1;
 ButtonCntDel.Enabled:=ListBoxCnts.ItemIndex<>-1;
 ButtonRuleAdd.Enabled:=true;
 ButtonRuleEdit.Enabled:=ListViewRules.Selected<>nil;
 ButtonRuleDel.Enabled:=ListViewRules.Selected<>nil;
 ButtonRuleMoveUp.Enabled:=(ListViewRules.Selected<>nil) and (ListViewRules.Selected.Index>0);
 ButtonRuleMoveDown.Enabled:=(ListViewRules.Selected<>nil) and (ListViewRules.Selected.Index<ListViewRules.Items.Count-1);
end;

function DBVarsProfilesNameCBWrapper(i:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TRSSettingsForm(i.user_parm).DBVarsProfilesNameCB(i);
end;

function TRSSettingsForm.DBVarsProfilesNameCB(i:PEXECSQLCBSTRUCT):boolean;
var f:pointer;
    s:string;
begin
 f:=i.GetFieldByName(i.obj,'name');
 if f<>nil then
  begin
   s:=GetFieldValueAsDelphiString(i,f);
   if s<>'' then
    ListBoxVars.Items.Add(s);
  end;
 Result:=true;
end;

function DBContentProfilesNameCBWrapper(i:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TRSSettingsForm(i.user_parm).DBContentProfilesNameCB(i);
end;

function TRSSettingsForm.DBContentProfilesNameCB(i:PEXECSQLCBSTRUCT):boolean;
var f:pointer;
    s:string;
begin
 f:=i.GetFieldByName(i.obj,'name');
 if f<>nil then
  begin
   s:=GetFieldValueAsDelphiString(i,f);
   if s<>'' then
    ListBoxCnts.Items.Add(s);
  end;
 Result:=true;
end;

function DBRulesCBWrapper(i:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TRSSettingsForm(i.user_parm).DBRulesCB(i);
end;

function TRSSettingsForm.DBRulesCB(i:PEXECSQLCBSTRUCT):boolean;
var f1,f2,f3,f4:pointer;
    s1,s2,s3,s4:string;
    item:TListItem;
begin
 f1:=i.GetFieldByName(i.obj,'rule_string');
 f2:=i.GetFieldByName(i.obj,'vars_profile');
 f3:=i.GetFieldByName(i.obj,'content_profile');
 f4:=i.GetFieldByName(i.obj,'comp_profile');
 if (f1<>nil) and (((f2<>nil) and (f3<>nil)) or (f4<>nil)) then
  begin
   s1:=GetFieldValueAsDelphiString(i,f1);
   if f2<>nil then
    s2:=GetFieldValueAsDelphiString(i,f2)
   else
    s2:='';
   if f3<>nil then
    s3:=GetFieldValueAsDelphiString(i,f3)
   else
    s3:='';
   if f4<>nil then
    s4:=GetFieldValueAsDelphiString(i,f4)
   else
    s4:='';
   item:=ListViewRules.Items.Add;
   item.ImageIndex:=0;
   item.Caption:=s1;
   if s4<>'' then
    begin
     item.SubItems.Add(s4);
     item.SubItems.Add('');
    end
   else
    begin
     item.SubItems.Add(s2);
     item.SubItems.Add(s3);
    end;
  end;
 Result:=true;
end;

procedure TRSSettingsForm.UpdateEntireSettingsPage();
var rc1,rc2,rc3 : boolean;
    err:string;
begin
 ListBoxVars.Clear;
 ListBoxVars.ItemIndex:=-1;
 ListBoxCnts.Clear;
 ListBoxCnts.ItemIndex:=-1;
 ListViewRules.Selected:=nil;
 ListViewRules.Clear;
 SettingsPageSelectionChanged();
 Panel8.SetFocus;
 WaitCursor(true,true);

 err:='';

 if IsUserSettings then
  rc1:=sql.Exec('SELECT name FROM TVarsProfiles ORDER BY name ASC',SQL_DEF_TIMEOUT,nil,DBVarsProfilesNameCBWrapper,self)
 else
  rc1:=sql.Exec('SELECT name FROM TCompProfiles ORDER BY name ASC',SQL_DEF_TIMEOUT,nil,DBVarsProfilesNameCBWrapper,self);
 if not rc1 then
  err:=err+sql.GetLastError+#13#10;

 if IsUserSettings then
  begin
   rc2:=sql.Exec('SELECT name FROM TContentProfiles ORDER BY name ASC',SQL_DEF_TIMEOUT,nil,DBContentProfilesNameCBWrapper,self);
   if not rc2 then
    err:=err+sql.GetLastError+#13#10;
  end
 else
  rc2:=true;

 if IsUserSettings then
  rc3:=sql.Exec('SELECT * FROM TSettingsRules ORDER BY number ASC',SQL_DEF_TIMEOUT,nil,DBRulesCBWrapper,self)
 else
  rc3:=sql.Exec('SELECT * FROM TCompSettingsRules ORDER BY number ASC',SQL_DEF_TIMEOUT,nil,DBRulesCBWrapper,self);
 if not rc3 then
  err:=err+sql.GetLastError+#13#10;

 if (not rc1) or (not rc2) or (not rc3) then
  MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+err),S_ERR,MB_OK or MB_ICONERROR);

 WaitCursor(false,false);
end;

procedure TRSSettingsForm.ListViewRulesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
 SettingsPageSelectionChanged();
end;

procedure TRSSettingsForm.ListViewRulesExit(Sender: TObject);
begin
 ListViewRules.Selected:=nil;
 SettingsPageSelectionChanged();
end;

procedure TRSSettingsForm.ListBoxVarsClick(Sender: TObject);
begin
 SettingsPageSelectionChanged();
end;

procedure TRSSettingsForm.ListBoxCntsClick(Sender: TObject);
begin
 SettingsPageSelectionChanged();
end;

type
     TLOADPROFILECB = record
     buff : pointer;
     size : integer;
     loaded : longbool;
     end;
     PLOADPROFILECB = ^TLOADPROFILECB;

function DBLoadProfileCB(i:PEXECSQLCBSTRUCT):longbool cdecl;
var p:PLOADPROFILECB;
    f,buff:pointer;
    size:integer;
begin
 p:=PLOADPROFILECB(i.user_parm);

 if not p.loaded then
  begin
   f:=i.GetFieldByName(i.obj,'data');
   if f<>nil then
    begin
     size:=0;
     buff:=i.GetFieldValueAsBlob(i.obj,f,@size);
     if (buff<>nil) then
      begin
       if size>0 then
        begin
         try
          GetMem(p.buff,size);
          p.size:=size;
          Move(buff^,p.buff^,size);
          p.loaded:=true;
         except
         end;
        end;
       i.FreePointer(buff);
      end;
    end;
  end;

 Result:=not p.loaded;
end;

function TRSSettingsForm.LoadProfileInternalBuffSize(name:string;profile_type:integer;_size:pinteger):pointer;
var i:TLOADPROFILECB;
    table:string;
begin
 Result:=nil;
 if _size<>nil then
  _size^:=0;
 if (name<>'') then
  begin
   if profile_type=0 then
    begin
     if IsUserSettings then
      table:='TVarsProfiles'
     else
      table:='TCompProfiles';
    end
   else
    table:='TContentProfiles';
   i.buff:=nil;
   i.size:=0;
   i.loaded:=false;
   if sql.Exec('SELECT data FROM '+table+' WHERE name='''+sql.EscapeString(name)+'''',30,nil,DBLoadProfileCB,@i) then
    begin
     if i.loaded then
      begin
       Result:=i.buff;
       if _size<>nil then
        _size^:=i.size;
      end;
    end;
  end;
end;

function TRSSettingsForm.LoadProfileInternal(name:string;profile_type,machine_type,lang:integer):boolean;
var buff:pointer;
    size:integer;
begin
 Result:=true;

 buff:=nil;
 size:=0;
 if name<>'' then
  begin
   buff:=LoadProfileInternalBuffSize(name,profile_type,@size);
   Result:=buff<>nil;
  end;

 CfgReadConfig(buff,size,lang,machine_type);

 if buff<>nil then
  FreeMem(buff);
end;

function TRSSettingsForm.SaveProfileInternal(name:string;profile_type:integer):boolean;
var buff:pointer;
    size:integer;
    argv:array[0..1] of TSTOREDPROCPARAM;
    t:array [0..MAX_PATH] of char;
    s_proc:string;
begin
 Result:=false;

 if name<>'' then
  begin
   buff:=nil;
   size:=0;
   if profile_type=0 then
    buff:=CfgWriteConfig(true,false,@size)
   else
    buff:=CfgWriteConfig(false,true,@size);

   if (buff<>nil) and (size>0) then
    begin
     if profile_type=0 then
      begin
       if IsUserSettings then
        s_proc:='PVarsProfilesAddModify'
       else
        s_proc:='PCompProfilesAddModify';
      end
     else
      s_proc:='PContentProfilesAddModify';

     argv[0].Direction:=SQL_PD_INPUT;
     argv[0].DataType:=SQL_DT_STRING;
     StrLCopy(t,pchar(name),sizeof(t)-1);
     argv[0].Value:=@t;
     argv[0].BlobSize:=0;

     argv[1].Direction:=SQL_PD_INPUT;
     argv[1].DataType:=SQL_DT_BLOB;
     argv[1].Value:=buff;
     argv[1].BlobSize:=size;

     if sql.CallStoredProc(s_proc,30,@argv,2) then
      Result:=true;
    end;

   if buff<>nil then
    CfgFreeBlock(buff);
  end;
end;

procedure TRSSettingsForm.AddProfileInternal(lb:TListBox;profile_type:integer);
var ar:array of string;
    n:integer;
    s_base,s_name:string;
    lang,machine_type:integer;
begin
 with lb do
  begin
   SetLength(ar,Items.Count);
   for n:=0 to Items.Count-1 do
    ar[n]:=Items[n];
  end;

 s_name:='';
 s_base:='';
 machine_type:=MACHINE_TYPE_OTHER;
 lang:=0;
 if ShowAddProfileFormModal(ar,s_name,s_base,machine_type,lang) then
  begin
   WaitCursor(true,true);

   if not LoadProfileInternal(s_base,profile_type,machine_type,lang) then
    begin
     WaitCursor(false,false);
     MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;

   if not SaveProfileInternal(s_name,profile_type) then
    MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR)
   else
    begin
     lb.ItemIndex:=lb.Items.Add(s_name);
     lb.SetFocus;
     SettingsPageSelectionChanged();
    end;

   CfgClearCnt(); //not needed

   WaitCursor(false,false);
  end;

 ar:=nil;
end;

procedure TRSSettingsForm.EditProfileInternal(lb:TListBox;profile_type:integer);
var idx:integer;
    name:string;
    rc:boolean;
begin
 idx:=lb.ItemIndex;
 if idx<>-1 then
  begin
   name:=lb.Items[idx];
   WaitCursor(true,true);
   if LoadProfileInternal(name,profile_type,MACHINE_TYPE_OTHER,0) then
    begin
     WaitCursor(false,false);
     if profile_type=0 then
      rc:=ShowSetupVarsFormModal(name,IsUserSettings)
     else
      rc:=ShowSetupContentFormModal(name);
     if rc then
      begin
       WaitCursor(true,false);
       if not SaveProfileInternal(name,profile_type) then
        MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
      end;
    end;
   CfgClearCnt(); //not needed
   WaitCursor(false,false);
  end;
end;

procedure TRSSettingsForm.DeleteProfileInternal(lb:TListBox;profile_type:integer);
var name,table:string;
    n,idx:integer;
begin
 idx:=lb.ItemIndex;
 if idx<>-1 then
  begin
   name:=lb.Items[idx];
   if MessageBox(Handle,pchar(S_CONFIRMDELETEPROFILE+' "'+name+'"?'),S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
    begin
     for n:=0 to ListViewRules.Items.Count-1 do
      if AnsiCompareText(ListViewRules.Items[n].SubItems[profile_type],name)=0 then
       begin
        MessageBox(Handle,S_PROFILEINUSE,S_ERR,MB_OK or MB_ICONERROR);
        Exit;
       end;

     WaitCursor(true,true);

     if profile_type=0 then
      begin
       if IsUserSettings then
        table:='TVarsProfiles'
       else
        table:='TCompProfiles';
      end
     else
      table:='TContentProfiles';

     if not sql.Exec('DELETE FROM '+table+' WHERE name='''+sql.EscapeString(name)+'''',10) then
      MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR)
     else
      begin
       lb.Items.Delete(idx);
       if idx>lb.Items.Count-1 then
        idx:=lb.Items.Count-1;
       lb.ItemIndex:=idx;
       lb.SetFocus;
       SettingsPageSelectionChanged();
      end;

     WaitCursor(false,false);
    end;
  end;
end;

procedure TRSSettingsForm.ButtonVarsAddClick(Sender: TObject);
begin
 AddProfileInternal(ListBoxVars,0);
end;

procedure TRSSettingsForm.ButtonCntAddClick(Sender: TObject);
begin
 AddProfileInternal(ListBoxCnts,1);
end;

procedure TRSSettingsForm.ButtonVarsEditClick(Sender: TObject);
begin
 EditProfileInternal(ListBoxVars,0);
end;

procedure TRSSettingsForm.ButtonCntEditClick(Sender: TObject);
begin
 EditProfileInternal(ListBoxCnts,1);
end;

procedure TRSSettingsForm.ButtonVarsDelClick(Sender: TObject);
begin
 DeleteProfileInternal(ListBoxVars,0);
end;

procedure TRSSettingsForm.ButtonCntDelClick(Sender: TObject);
begin
 DeleteProfileInternal(ListBoxCnts,1);
end;

function TRSSettingsForm.GetListBoxIdx(lb:TListBox;const s:string):integer;
var n:integer;
begin
 Result:=-1;
 for n:=0 to lb.Items.Count-1 do
  if AnsiCompareText(lb.Items[n],s)=0 then
   begin
    Result:=n;
    break;
   end;
end;

function TRSSettingsForm.SaveAllRulesInternal:boolean;
var n:integer;
    table,query,q_number,q_rule,q_profile1,q_profile2:string;
begin
 Result:=false;

 if IsUserSettings then
  table:='TSettingsRules'
 else
  table:='TCompSettingsRules';

 if sql.Exec('DELETE FROM '+table) then
  begin
   for n:=0 to ListViewRules.Items.Count-1 do
    begin
     q_number:=inttostr(n);
     q_rule:=''''+sql.EscapeString(ListViewRules.Items[n].Caption)+'''';
     q_profile1:=''''+sql.EscapeString(ListViewRules.Items[n].SubItems[0])+'''';
     q_profile2:=''''+sql.EscapeString(ListViewRules.Items[n].SubItems[1])+'''';

     if IsUserSettings then
      query:='INSERT INTO '+table+' VALUES('+q_number+','+q_rule+','+q_profile1+','+q_profile2+')'
     else
      query:='INSERT INTO '+table+' VALUES('+q_number+','+q_rule+','+q_profile1+')';

     if not sql.Exec(query) then
      Exit;
    end;

   Result:=true;
  end;
end;

procedure TRSSettingsForm.ButtonRuleAddClick(Sender: TObject);
var rule:string;
    i_vars,i_cnts:integer;
    ar_vars,ar_cnts:array of string;
    n:integer;
    item:TListItem;
    rc:boolean;
begin
 rule:='';
 i_vars:=-1;
 i_cnts:=-1;
 ar_vars:=nil;
 ar_cnts:=nil;

 with ListBoxVars do
  begin
   SetLength(ar_vars,Items.Count);
   for n:=0 to Items.Count-1 do
    ar_vars[n]:=Items[n];
  end;
 if IsUserSettings then
  with ListBoxCnts do
   begin
    SetLength(ar_cnts,Items.Count);
    for n:=0 to Items.Count-1 do
     ar_cnts[n]:=Items[n];
   end;

 if ShowRuleFormModal(rule,ar_vars,ar_cnts,i_vars,i_cnts,IsUserSettings) then
  begin
   if (i_vars<>-1) and ((i_cnts<>-1) or IsCompSettings) then
    begin
     item:=ListViewRules.Items.Add;
     item.ImageIndex:=0;
     item.Caption:=rule;
     item.SubItems.Add(ar_vars[i_vars]);
     if IsUserSettings then
      item.SubItems.Add(ar_cnts[i_cnts])
     else
      item.SubItems.Add('');
     ListViewRules.Selected:=item;
     ListViewRules.ItemFocused:=item;
     ListViewRules.SetFocus;
     SettingsPageSelectionChanged();

     WaitCursor(true,true);
     rc:=SaveAllRulesInternal();
     WaitCursor(false,false);

     if not rc then
      begin
       MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
       UpdateEntireSettingsPage();
      end;
    end;
  end;

 ar_vars:=nil;
 ar_cnts:=nil;
end;

procedure TRSSettingsForm.ButtonRuleEditClick(Sender: TObject);
var item:TListItem;
    rule:string;
    i_vars,i_cnts:integer;
    ar_vars,ar_cnts:array of string;
    n:integer;
    rc:boolean;
begin
 item:=ListViewRules.Selected;
 if item<>nil then
  begin
   rule:=item.Caption;
   i_vars:=GetListBoxIdx(ListBoxVars,item.SubItems[0]);
   if IsUserSettings then
    i_cnts:=GetListBoxIdx(ListBoxCnts,item.SubItems[1])
   else
    i_cnts:=-1;

   ar_vars:=nil;
   ar_cnts:=nil;

   with ListBoxVars do
    begin
     SetLength(ar_vars,Items.Count);
     for n:=0 to Items.Count-1 do
      ar_vars[n]:=Items[n];
    end;
   if IsUserSettings then
    with ListBoxCnts do
     begin
      SetLength(ar_cnts,Items.Count);
      for n:=0 to Items.Count-1 do
       ar_cnts[n]:=Items[n];
     end;

   if ShowRuleFormModal(rule,ar_vars,ar_cnts,i_vars,i_cnts,IsUserSettings) then
    begin
     if (i_vars<>-1) and ((i_cnts<>-1) or IsCompSettings) then
      begin
       item.Caption:=rule;
       item.SubItems[0]:=ar_vars[i_vars];
       if IsUserSettings then
        item.SubItems[1]:=ar_cnts[i_cnts]
       else
        item.SubItems[1]:='';
       ListViewRules.Selected:=item;
       ListViewRules.ItemFocused:=item;
       ListViewRules.SetFocus;
       SettingsPageSelectionChanged();

       WaitCursor(true,true);
       rc:=SaveAllRulesInternal();
       WaitCursor(false,false);

       if not rc then
        begin
         MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
         UpdateEntireSettingsPage();
        end;
      end;
    end;

   ar_vars:=nil;
   ar_cnts:=nil;
  end;
end;

procedure TRSSettingsForm.ButtonRuleDelClick(Sender: TObject);
var item:TListItem;
    rc:boolean;
begin
 item:=ListViewRules.Selected;
 if item<>nil then
  begin
   item.Delete;
   ListViewRules.Selected:=ListViewRules.ItemFocused;
   ListViewRules.SetFocus;
   SettingsPageSelectionChanged();

   WaitCursor(true,true);
   rc:=SaveAllRulesInternal();
   WaitCursor(false,false);

   if not rc then
    begin
     MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
     UpdateEntireSettingsPage();
    end;
  end;
end;

procedure TRSSettingsForm.SwapRuleItemsContent(src,dest:integer);
var s:string;
begin
 with ListViewRules.Items do
  begin
   s:=Item[src].Caption;
   Item[src].Caption:=Item[dest].Caption;
   Item[dest].Caption:=s;
   s:=Item[src].SubItems[0];
   Item[src].SubItems[0]:=Item[dest].SubItems[0];
   Item[dest].SubItems[0]:=s;
   s:=Item[src].SubItems[1];
   Item[src].SubItems[1]:=Item[dest].SubItems[1];
   Item[dest].SubItems[1]:=s;
  end;
end;

procedure TRSSettingsForm.ButtonRuleMoveUpClick(Sender: TObject);
var idx:integer;
    rc:boolean;
begin
 if ListViewRules.Selected<>nil then
  begin
   idx:=ListViewRules.Selected.Index;
   if idx>0 then
    begin
     SwapRuleItemsContent(idx,idx-1);
     ListViewRules.ItemIndex:=idx-1;
     ListViewRules.ItemFocused:=ListViewRules.Selected;
     ListViewRules.SetFocus;
     SettingsPageSelectionChanged();

     WaitCursor(true,true);
     rc:=SaveAllRulesInternal();
     WaitCursor(false,false);

     if not rc then
      begin
       MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
       UpdateEntireSettingsPage();
      end;
    end;
  end;
end;

procedure TRSSettingsForm.ButtonRuleMoveDownClick(Sender: TObject);
var idx:integer;
    rc:boolean;
begin
 if ListViewRules.Selected<>nil then
  begin
   idx:=ListViewRules.Selected.Index;
   if idx<ListViewRules.Items.Count-1 then
    begin
     SwapRuleItemsContent(idx,idx+1);
     ListViewRules.ItemIndex:=idx+1;
     ListViewRules.ItemFocused:=ListViewRules.Selected;
     ListViewRules.SetFocus;
     SettingsPageSelectionChanged();

     WaitCursor(true,true);
     rc:=SaveAllRulesInternal();
     WaitCursor(false,false);

     if not rc then
      begin
       MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
       UpdateEntireSettingsPage();
      end;
    end;
  end;
end;

procedure TRSSettingsForm.ListBoxVarsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=VK_DELETE then
  begin
   if ButtonVarsDel.Enabled then
     ButtonVarsDelClick(Sender);
  end
 else
 if key=VK_RETURN then
  begin
   if ButtonVarsEdit.Enabled then
     ButtonVarsEditClick(Sender);
  end
 else
 if key=VK_INSERT then
  begin
   if ButtonVarsAdd.Enabled then
     ButtonVarsAddClick(Sender);
  end;
end;

procedure TRSSettingsForm.ListBoxCntsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=VK_DELETE then
  begin
   if ButtonCntDel.Enabled then
     ButtonCntDelClick(Sender);
  end
 else
 if key=VK_RETURN then
  begin
   if ButtonCntEdit.Enabled then
     ButtonCntEditClick(Sender);
  end
 else
 if key=VK_INSERT then
  begin
   if ButtonCntAdd.Enabled then
     ButtonCntAddClick(Sender);
  end;
end;

procedure TRSSettingsForm.ListBoxVarsDblClick(Sender: TObject);
begin
 if ButtonVarsEdit.Enabled then
   ButtonVarsEditClick(Sender);
end;

procedure TRSSettingsForm.ListBoxCntsDblClick(Sender: TObject);
begin
 if ButtonCntEdit.Enabled then
   ButtonCntEditClick(Sender);
end;

procedure TRSSettingsForm.ListViewRulesDblClick(Sender: TObject);
begin
 if ButtonRuleEdit.Enabled then
  ButtonRuleEditClick(Sender);
end;

procedure TRSSettingsForm.ListViewRulesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=VK_DELETE then
  begin
   if ButtonRuleDel.Enabled then
     ButtonRuleDelClick(Sender);
  end
 else
 if key=VK_RETURN then
  begin
   if ButtonRuleEdit.Enabled then
     ButtonRuleEditClick(Sender);
  end
 else
 if key=VK_INSERT then
  begin
   if ButtonRuleAdd.Enabled then
     ButtonRuleAddClick(Sender);
  end
 else
 if (key=VK_UP) and (ssCtrl in Shift) then
  begin
   if ButtonRuleMoveUp.Enabled then
     ButtonRuleMoveUpClick(Sender);
   key:=255;
  end
 else
 if (key=VK_DOWN) and (ssCtrl in Shift) then
  begin
   if ButtonRuleMoveDown.Enabled then
     ButtonRuleMoveDownClick(Sender);
   key:=255;
  end;
end;

////////////////////////////////

function DBUsersCBWrapper(i:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TRSSettingsForm(i.user_parm).DBUsersCB(i);
end;

function TRSSettingsForm.DBUsersCB(i:PEXECSQLCBSTRUCT):boolean;
var f:pointer;
    s:string;
begin
 f:=i.GetFieldByName(i.obj,'user_name');
 if f<>nil then
  begin
   s:=GetFieldValueAsDelphiString(i,f);
   if s<>'' then
    ListBoxUsers.Items.Add(s);
  end;
 Result:=true;
end;

procedure TRSSettingsForm.UpdateEntireUsersPage();
begin
 ListBoxUsers.Clear;
 ListBoxUsers.ItemIndex:=-1;
 UsersPageSelectionChanged();
 Panel6.SetFocus;
 WaitCursor(true,true);

 if not sql.Exec('SELECT user_name FROM TDBUsers ORDER BY user_name ASC',SQL_DEF_TIMEOUT,nil,DBUsersCBWrapper,self) then
   MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);

 WaitCursor(false,false);
end;

procedure TRSSettingsForm.TabSheet1Show(Sender: TObject);
begin
 UpdateEntireUsersPage();
end;

procedure TRSSettingsForm.ListBoxUsersClick(Sender: TObject);
begin
 UsersPageSelectionChanged();
end;

procedure TRSSettingsForm.ListBoxUsersKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=VK_DELETE then
  begin
   if ButtonUserDel.Enabled then
     ButtonUserDelClick(Sender);
  end
 else
 if key=VK_INSERT then
  begin
   if ButtonUserAdd.Enabled then
     ButtonUserAddClick(Sender);
  end;
end;

procedure TRSSettingsForm.ButtonUserAddClick(Sender: TObject);
var name,pwd:string;
    lb:TListBox;
    n:integer;
    find:boolean;
begin
 lb:=ListBoxUsers;
 name:='';
 pwd:='';
 if ShowUserFormModal(name,pwd) then
  begin
   WaitCursor(true,true);

   if not sql.CreateUser(name,pwd) then
    begin
     WaitCursor(false,false);
     MessageBox(Handle,pchar(sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;

   find:=false;
   for n:=0 to lb.Items.Count-1 do
    if AnsiCompareText(lb.Items[n],name)=0 then
     begin
      find:=true;
      break;
     end;

   if find then
    begin
     WaitCursor(false,false);
     MessageBox(Handle,S_USER_EXISTS,S_INFO,MB_OK or MB_ICONINFORMATION);
     Exit;
    end;

   if not ApplyUserRightsInternal(name,GetDefaultRightsString()) then
    begin
     WaitCursor(false,false);
     MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;

   MessageBox(Handle,S_USER_ADDED,S_INFO,MB_OK or MB_ICONINFORMATION);

   WaitCursor(false,false);

   lb.ItemIndex:=lb.Items.Add(name);
   lb.SetFocus;
   UsersPageSelectionChanged();
  end;
end;

procedure TRSSettingsForm.ButtonUserEditClick(Sender: TObject);
var lb:TListBox;
    idx:integer;
    name,pwd:string;
    rc:boolean;
begin
 lb:=ListBoxUsers;
 idx:=lb.ItemIndex;
 if idx<>-1 then
  begin
   name:=lb.Items[idx];
   pwd:='';
   if ShowUserFormModal(name,pwd) then
    begin
     WaitCursor(true,true);
     rc:=sql.ChangeOtherPwd(name,pwd);
     WaitCursor(false,false);

     if rc then
      MessageBox(Handle,S_PWD_CHANGED,S_INFO,MB_OK or MB_ICONINFORMATION)
     else
      MessageBox(Handle,pchar(S_ERR_PWD_CHANGE+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TRSSettingsForm.ButtonUserDelClick(Sender: TObject);
var name:string;
    idx:integer;
    lb:TListBox;
    err:boolean;
begin
 lb:=ListBoxUsers;
 idx:=lb.ItemIndex;
 if idx<>-1 then
  begin
   name:=lb.Items[idx];
   if MessageBox(Handle,pchar(S_CONFIRMDELETEUSER+' "'+name+'"?'),S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
    begin
     WaitCursor(true,true);
     err:=not sql.Exec('DELETE FROM TDBUsers WHERE user_name='''+sql.EscapeString(name)+'''');
     if not err then
      sql.RemoveUserFromCurrentBase(name);
     WaitCursor(false,false);

     if err then
      begin
       MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
       Exit;
      end;

     lb.Items.Delete(idx);
     if idx>lb.Items.Count-1 then
      idx:=lb.Items.Count-1;
     lb.ItemIndex:=idx;
     lb.SetFocus;
     UsersPageSelectionChanged();
    end;
  end;
end;


type TUSERRIGHTSCB = record
      rights:string;
      retrieved:longbool;
     end;
     PUSERRIGHTSCB = ^TUSERRIGHTSCB;

function DBUserRightsCB(i:PEXECSQLCBSTRUCT):longbool cdecl;
var p:PUSERRIGHTSCB;
    f:pointer;
begin
 p:=PUSERRIGHTSCB(i.user_parm);

 if not p.retrieved then
  begin
   f:=i.GetFieldByName(i.obj,'user_rights');
   if f<>nil then
    begin
     p.rights:=GetFieldValueAsDelphiString(i,f);
     p.retrieved:=true;
    end;
  end;

 Result:=not p.retrieved;
end;

procedure TRSSettingsForm.UsersPageSelectionChanged();
var lb:TListBox;
    idx:integer;
    user_name:string;
    i:TUSERRIGHTSCB;
    err:boolean;
begin
 ButtonUserAdd.Enabled:=true;
 ButtonUserEdit.Enabled:=ListBoxUsers.ItemIndex<>-1;
 ButtonUserDel.Enabled:=ListBoxUsers.ItemIndex<>-1;

 lb:=ListBoxUsers;
 idx:=lb.ItemIndex;
 if idx=-1 then
  begin
   PanelRights.Visible:=false;
   Panel13.Caption:=S_SELECTUSER;
  end
 else
  begin
   user_name:=lb.Items[idx];

   WaitCursor(true,true);
   i.rights:='';
   i.retrieved:=false;
   err:=(not sql.Exec('SELECT user_rights FROM TDBUsers WHERE user_name='''+sql.EscapeString(user_name)+'''',SQL_DEF_TIMEOUT,nil,DBUserRightsCB,@i))
         or (not i.retrieved);
   WaitCursor(false,false);

   if err then
    begin
     PanelRights.Visible:=false;
     Panel13.Caption:=S_SELECTUSER;
     MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
     Exit;
    end;

   FillRightsPageFromString(i.rights);
   Panel13.Caption:='';
   PanelRights.Visible:=true;
  end;
end;

function TRSSettingsForm.GetDefaultRightsString():string;
begin
 Result:= UR_X_REBOOTSHUTDOWN+
          UR_X_LOGOFF+
          UR_X_TURNMONITOR+
          UR_X_TURNBLOCK+
          UR_X_KILLTASKS+
          UR_X_RESTOREVMODE+
          UR_X_SENDMESSAGE+
          UR_X_MACHINESINFO+
          UR_VIPWORK;
end;

procedure TRSSettingsForm.FillRightsPageFromString(s:string);
begin
 CheckBox1.Checked:=AnsiContainsText(s,UR_EDITRULES);
 CheckBox2.Checked:=AnsiContainsText(s,UR_EDITVARS);
 CheckBox3.Checked:=AnsiContainsText(s,UR_EDITCONTENT);
 CheckBox4.Checked:=AnsiContainsText(s,UR_DELOLDRECORDS);
 CheckBox5.Checked:=AnsiContainsText(s,UR_EDITCOSTS);
 CheckBox20.Checked:=AnsiContainsText(s,UR_VIPWORK);
 CheckBox6.Checked:=AnsiContainsText(s,UR_X_REBOOTSHUTDOWN);
 CheckBox7.Checked:=AnsiContainsText(s,UR_X_LOGOFF);
 CheckBox8.Checked:=AnsiContainsText(s,UR_X_TURNSHELL);
 CheckBox9.Checked:=AnsiContainsText(s,UR_X_TURNAUTOLOGON);
 CheckBox10.Checked:=AnsiContainsText(s,UR_X_TURNMONITOR);
 CheckBox11.Checked:=AnsiContainsText(s,UR_X_TURNBLOCK);
 CheckBox12.Checked:=AnsiContainsText(s,UR_X_EXECUTE);
 CheckBox13.Checked:=AnsiContainsText(s,UR_X_COPYDELFILES);
 CheckBox14.Checked:=AnsiContainsText(s,UR_X_KILLTASKS);
 CheckBox15.Checked:=AnsiContainsText(s,UR_X_CLEARSTAT);
 CheckBox16.Checked:=AnsiContainsText(s,UR_X_RESTOREVMODE);
 CheckBox17.Checked:=AnsiContainsText(s,UR_X_SENDMESSAGE);
 CheckBox18.Checked:=AnsiContainsText(s,UR_X_TIMESYNC);
 CheckBox19.Checked:=AnsiContainsText(s,UR_X_MACHINESINFO);
 CheckBox21.Checked:=AnsiContainsText(s,UR_X_CLIENTUPDATE);
 CheckBox22.Checked:=AnsiContainsText(s,UR_X_RFM);
 CheckBox23.Checked:=AnsiContainsText(s,UR_X_RSRD);
 CheckBox24.Checked:=AnsiContainsText(s,UR_EDITCOMPRULES);
 CheckBox25.Checked:=AnsiContainsText(s,UR_EDITCOMPVARS);
 CheckBox26.Checked:=AnsiContainsText(s,UR_X_ROLLBACK);
 CheckBox27.Checked:=AnsiContainsText(s,UR_X_CLIENTUNINSTALL);
end;

function TRSSettingsForm.MakeStringFromRightsPage():string;
var s:string;
begin
 s:='';

 if CheckBox1.Checked then  s:=s+UR_EDITRULES;
 if CheckBox2.Checked then  s:=s+UR_EDITVARS;
 if CheckBox3.Checked then  s:=s+UR_EDITCONTENT;
 if CheckBox4.Checked then  s:=s+UR_DELOLDRECORDS;
 if CheckBox5.Checked then  s:=s+UR_EDITCOSTS;
 if CheckBox20.Checked then s:=s+UR_VIPWORK;
 if CheckBox6.Checked then  s:=s+UR_X_REBOOTSHUTDOWN;
 if CheckBox7.Checked then  s:=s+UR_X_LOGOFF;
 if CheckBox8.Checked then  s:=s+UR_X_TURNSHELL;
 if CheckBox9.Checked then  s:=s+UR_X_TURNAUTOLOGON;
 if CheckBox10.Checked then s:=s+UR_X_TURNMONITOR;
 if CheckBox11.Checked then s:=s+UR_X_TURNBLOCK;
 if CheckBox12.Checked then s:=s+UR_X_EXECUTE;
 if CheckBox13.Checked then s:=s+UR_X_COPYDELFILES;
 if CheckBox14.Checked then s:=s+UR_X_KILLTASKS;
 if CheckBox15.Checked then s:=s+UR_X_CLEARSTAT;
 if CheckBox16.Checked then s:=s+UR_X_RESTOREVMODE;
 if CheckBox17.Checked then s:=s+UR_X_SENDMESSAGE;
 if CheckBox18.Checked then s:=s+UR_X_TIMESYNC;
 if CheckBox19.Checked then s:=s+UR_X_MACHINESINFO;
 if CheckBox21.Checked then s:=s+UR_X_CLIENTUPDATE;
 if CheckBox22.Checked then s:=s+UR_X_RFM;
 if CheckBox23.Checked then s:=s+UR_X_RSRD;
 if CheckBox24.Checked then s:=s+UR_EDITCOMPRULES;
 if CheckBox25.Checked then s:=s+UR_EDITCOMPVARS;
 if CheckBox26.Checked then s:=s+UR_X_ROLLBACK;
 if CheckBox27.Checked then s:=s+UR_X_CLIENTUNINSTALL;

 Result:=s;
end;

function TRSSettingsForm.ApplyUserRightsInternal(user_name,rights:string):boolean;
var cnt:integer;
    b1,b2,b3,b4,b5,b6,b7,b8:boolean;
    s:string;
begin
 Result:=false;

 if user_name<>'' then
  begin
   b1:=AnsiContainsText(rights,UR_EDITCOSTS);
   b2:=AnsiContainsText(rights,UR_DELOLDRECORDS);
   b3:=AnsiContainsText(rights,UR_EDITCOMPVARS);
   b4:=AnsiContainsText(rights,UR_EDITVARS);
   b5:=AnsiContainsText(rights,UR_EDITCONTENT);
   b6:=AnsiContainsText(rights,UR_EDITCOMPRULES);
   b7:=AnsiContainsText(rights,UR_EDITRULES);
   b8:=AnsiContainsText(rights,UR_VIPWORK);

   if sql.ApplyUserRights(user_name,b1,b2,b3,b4,b5,b6,b7,b8) then
    begin
     cnt:=0;
     if sql.Exec('SELECT * FROM TDBUsers WHERE user_name='''+sql.EscapeString(user_name)+'''',SQL_DEF_TIMEOUT,@cnt) then
      begin
       if cnt>0 then
        s:='UPDATE TDBUsers SET user_rights='''+rights+''' WHERE user_name='''+sql.EscapeString(user_name)+''''
       else
        s:='INSERT INTO TDBUsers VALUES('''+sql.EscapeString(user_name)+''','''+rights+''')';

       if sql.Exec(s) then
         Result:=true;
      end;
    end;
  end;
end;

procedure TRSSettingsForm.ButtonSetRightsClick(Sender: TObject);
var lb:TListBox;
    idx:integer;
    user_name,rights:string;
    err:boolean;
begin
 lb:=ListBoxUsers;
 idx:=lb.ItemIndex;
 if idx<>-1 then
  begin
   user_name:=lb.Items[idx];
   rights:=MakeStringFromRightsPage();

   ButtonSetRights.Enabled:=false;
   Update;
   WaitCursor(true,true);
   err:=not ApplyUserRightsInternal(user_name,rights);
   WaitCursor(false,false);
   ButtonSetRights.Enabled:=true;

   if err then
     MessageBox(Handle,pchar(S_ERR_ACCESS+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR)
   else
     MessageBox(Handle,S_ACCESS_SET,S_INFO,MB_OK or MB_ICONINFORMATION);

   UsersPageSelectionChanged();
  end;
end;


end.
