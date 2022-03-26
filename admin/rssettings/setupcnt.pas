unit setupcnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, ToolWin, ImgList, global, Buttons;


{$INCLUDE dll.inc}


type
     TCACHEDICON = record
      ext:string;
      idx:integer;
     end;
     PCACHEDICON = ^TCACHEDICON;

type
  TSetupContentForm = class(TForm)
    ColorDialog1: TColorDialog;
    Panel2: TPanel;
    Panel40: TPanel;
    Panel41: TPanel;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    Panel42: TPanel;
    Bevel2: TBevel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    CoolBar1: TCoolBar;
    TreeView: TTreeView;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ButtonAddSheet: TToolButton;
    ButtonAddShortcut: TToolButton;
    ButtonSep1: TToolButton;
    ButtonMoveUp: TToolButton;
    ButtonMoveDown: TToolButton;
    ButtonSep2: TToolButton;
    ButtonDel: TToolButton;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Label3: TLabel;
    PanelColor: TPanel;
    Label5: TLabel;
    Edit3: TEdit;
    Button2: TButton;
    GroupBox3: TGroupBox;
    TrackBarTimeMin: TTrackBar;
    Label6: TLabel;
    LabelTimeMin: TLabel;
    Label8: TLabel;
    TrackBarTimeMax: TTrackBar;
    LabelTimeMax: TLabel;
    Label10: TLabel;
    Edit4: TEdit;
    Label11: TLabel;
    Edit5: TEdit;
    Button4: TButton;
    CheckBoxInternet: TCheckBox;
    Label4: TLabel;
    PanelBGColor: TPanel;
    Label7: TLabel;
    Edit6: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    Button5: TButton;
    Label12: TLabel;
    Edit8: TEdit;
    Label13: TLabel;
    Edit9: TEdit;
    Button6: TButton;
    Label14: TLabel;
    Edit10: TEdit;
    Button7: TButton;
    Label15: TLabel;
    Edit11: TEdit;
    Label16: TLabel;
    Edit12: TEdit;
    CheckBoxOnlyOne: TCheckBox;
    GroupBox4: TGroupBox;
    Label17: TLabel;
    Edit13: TEdit;
    Label18: TLabel;
    Edit14: TEdit;
    Label19: TLabel;
    Edit15: TEdit;
    Label20: TLabel;
    ComboBoxShowCmd: TComboBox;
    Label21: TLabel;
    Edit16: TEdit;
    Button8: TButton;
    Label22: TLabel;
    ComboBoxVCD: TComboBox;
    Label24: TLabel;
    Edit18: TEdit;
    Button11: TButton;
    GroupBox5: TGroupBox;
    Memo1: TMemo;
    Button9: TButton;
    Button10: TButton;
    GroupBox6: TGroupBox;
    Memo2: TMemo;
    Button12: TButton;
    Button13: TButton;
    GroupBox7: TGroupBox;
    Memo3: TMemo;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    ImageListIcons: TImageList;
    Label23: TLabel;
    Edit17: TEdit;
    Button17: TButton;
    Button3: TBitBtn;
    Label25: TLabel;
    ComboBoxGroup: TComboBoxEx;
    ButtonAddShortcutsFromFolder: TToolButton;
    GroupBox8: TGroupBox;
    Button18: TButton;
    Button19: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ButtonSort: TToolButton;
    Label26: TLabel;
    Edit19: TEdit;
    Button20: TButton;
    procedure Button3Click(Sender: TObject);
    procedure ButtonAddSheetClick(Sender: TObject);
    procedure ButtonAddShortcutClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonMoveUpClick(Sender: TObject);
    procedure ButtonMoveDownClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PanelColorClick(Sender: TObject);
    procedure PanelBGColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TrackBarTimeMinChange(Sender: TObject);
    procedure TrackBarTimeMaxChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeViewChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure TreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button17Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboBoxVCDChange(Sender: TObject);
    procedure ButtonAddShortcutsFromFolderClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure ButtonSortClick(Sender: TObject);
    procedure Button20Click(Sender: TObject);
  private
    { Private declarations }
    icons : array of TCACHEDICON;
    onchange_enabled : boolean;
    procedure SwitchToPage(idx:integer);
    function GetFolder():string;
    function GetFolderFile():string;
    function GetOpenFile(filter,name:pchar):string;
    procedure UpdateSheetMinMaxTime();
    procedure OnSelectionChanged();
    procedure FillSheetPage(v:PSHEETVARS);
    procedure FillShortcutPage(v:PSHORTCUTVARS);
    procedure StoreSheetPage(v:PSHEETVARS);
    procedure StoreShortcutPage(v:PSHORTCUTVARS);
    function GetFileIcon(s:string):integer;
    procedure SetIconForNode(node:TTreeNode;s:string);
    procedure OnShortcutTitleChanged();
    procedure OnSheetTitleChanged();
    function IsSheetNode(node:TTreeNode):boolean;
    function IsShortcutNode(node:TTreeNode):boolean;
    procedure ApplyChanges();
    procedure ExecuteTreeViewAction(action:integer);
    procedure ActionAddSheet(node:TTreeNode);
    procedure ActionAddShortcut(node:TTreeNode;const def:POldLnkFileInfo=nil);
    procedure ActionMoveUp(node:TTreeNode);
    procedure ActionMoveDown(node:TTreeNode);
    procedure ActionDelete(node:TTreeNode);
    procedure ActionSort(node:TTreeNode);
    function ValidateContent():boolean;
    function IsNodeUnique(node:TTreeNode):boolean;
    function SaveShortcutToFile(const v:PSHORTCUTVARS;const filename:string):boolean;
    function LoadShortcutFromFile(v:PSHORTCUTVARS;const filename:string):boolean;
  public
    { Public declarations }
    constructor CreateForm(const title:string);
    destructor Destroy; override;

    procedure AddOldLnkShortcutProcPublic(const i:POldLnkFileInfo);
  end;


function ShowSetupContentFormModal(const title:string):boolean;


implementation

uses ShellApi, StrUtils, CommCtrl, IniFiles, tools, lang, tip;

{$R *.dfm}


const ACTION_ADDSHEET = 1;
const ACTION_ADDSHORTCUT = 2;
const ACTION_MOVEUP = 3;
const ACTION_MOVEDOWN = 4;
const ACTION_DELETE = 5;
const ACTION_ADDSHORTCUTS = 6;
const ACTION_SORT = 7;


function ShowSetupContentFormModal(const title:string):boolean;
var f:TSetupContentForm;
    old_cur:TCursor;
begin
 old_cur:=Screen.Cursor;
 Screen.Cursor:=crHourGlass;
 f:=TSetupContentForm.CreateForm(title);
 Screen.Cursor:=old_cur;
 Result:=f.ShowModal=mrOk;
 f.Free;
end;


function TSetupContentForm.GetFolder():string;
begin
 Result:=Tools.EmulGetFolder(false);
end;

function TSetupContentForm.GetFolderFile():string;
begin
 Result:=Tools.EmulGetFolder(true);
end;

function TSetupContentForm.GetOpenFile(filter,name:pchar):string;
begin
 Result:=Tools.EmulGetOpenFile(filter,name);
end;

function TSetupContentForm.GetFileIcon(s:string):integer;
var n,h_icon,idx : integer;
    temp, ext: string;
    t:TPATH;
begin
 Result:=-1;

 if s<>'' then
  begin
   if AnsiStartsText('http:',s) or AnsiStartsText('https:',s) or AnsiStartsText('ftp:',s) then
    ext:='.url'
   else
   if AnsiStartsText('$',s) then
    ext:='.exe'
   else
   if AnsiEndsText('\',s) or (ExtractFileExt(s)='') then
    ext:=''
   else
    ext:=ExtractFileExt(s);

   for n:=0 to length(icons)-1 do
    if AnsiCompareText(icons[n].ext,ext)=0 then
     begin
      Result:=icons[n].idx;
      Exit;
     end;

   t[0]:=#0;
   GetTempPath(sizeof(t),t);
   temp:=t;
   if ext='' then
    begin
     temp:=ExcludeTrailingPathDelimiter(temp);
     h_icon:=GetFileNameIcon(temp);
    end
   else
    begin
     temp:=IncludeTrailingPathDelimiter(temp)+'rs_tmp_null_file'+ext;
     FileClose(FileCreate(temp));
     h_icon:=GetFileNameIcon(temp);
     Windows.DeleteFile(pchar(temp));
    end;

   if h_icon=0 then
    h_icon:=CopyIcon(LoadIcon(0,IDI_APPLICATION));
   idx:=ImageList_AddIcon(ImageListIcons.Handle,h_icon);
   DestroyIcon(h_icon);

   SetLength(icons,Length(icons)+1);
   icons[High(icons)].ext:=ext;
   icons[High(icons)].idx:=idx;

   Result:=idx;
  end;
end;

procedure TSetupContentForm.SetIconForNode(node:TTreeNode;s:string);
var ii:integer;
begin
 ii:=GetFileIcon(s);
 node.ImageIndex:=ii;
 node.OverlayIndex:=ii;
 node.SelectedIndex:=ii;
end;

procedure TSetupContentForm.SwitchToPage(idx:integer);
begin
 if PageControl.ActivePageIndex<>idx then
  PageControl.ActivePageIndex:=idx;
end;

constructor TSetupContentForm.CreateForm(const title:string);
var numsheets,numshortcuts,n,m:integer;
    p1,p2:pointer;
    p1_v:PSHEETVARS;
    p2_v:PSHORTCUTVARS;
    node,child:TTreeNode;
begin
 inherited Create(nil);

 icons:=nil;
 onchange_enabled:=false;

 Constraints.MinWidth:=Width;
 Constraints.MinHeight:=Height;
 Caption:=Caption + ' ('+title+')';
 Button3.Enabled:=FileExists(GetLocalPath(PATH_HELP));
 Button16.Enabled:=FileExists(GetLocalPath(PATH_SAVEREXAMPLE));
 ImageListIcons.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 0, 10);
 FillStringListWithHistory(ComboBoxGroup.Items,'Groups');

 //load content and fill TreeView
 TreeView.Items.BeginUpdate;
 numsheets:=CfgGetCntSheetsCount();
 for n:=0 to numsheets-1 do
  begin
   GetMem(p1_v,sizeof(TSHEETVARS));
   p1:=CfgGetCntSheetAt(n);
   CfgGetCntSheetVars(p1,p1_v);
   node:=TreeView.Items.Add(nil,p1_v.s_name);
   node.Data:=p1_v;
   SetIconForNode(node,'\');
   numshortcuts:=CfgGetCntShortcutsCount(p1);
   for m:=0 to numshortcuts-1 do
    begin
     GetMem(p2_v,sizeof(TSHORTCUTVARS));
     p2:=CfgGetCntShortcutAt(p1,m);
     CfgGetCntShortcutVars(p2,p2_v);
     child:=TreeView.Items.AddChild(node,p2_v.s_name);
     child.Data:=p2_v;
     SetIconForNode(child,p2_v.s_exe);
    end;
  end;
 TreeView.Items.EndUpdate;
 TreeView.FullCollapse;
 TreeView.Selected:=nil;

 OnSelectionChanged();

 onchange_enabled:=true;
end;

destructor TSetupContentForm.Destroy;
var n:integer;
    node,child:TTreeNode;
    p_sheet,p_shortcut : pointer;
begin
 onchange_enabled:=false;

 if ModalResult=mrOk then
  begin
   //save content
   CfgClearCnt();

   node:=TreeView.Items.GetFirstNode;
   while node<>nil do
    begin
     p_sheet:=CfgAddCntSheet(PSHEETVARS(node.Data)^.s_name);
     if p_sheet<>nil then
      begin
       CfgSetCntSheetVars(p_sheet,PSHEETVARS(node.Data));
       child:=node.getFirstChild;
       while child<>nil do
        begin
         p_shortcut:=CfgAddCntShortcut(p_sheet,PSHORTCUTVARS(child.Data)^.s_name);
         if p_shortcut<>nil then
           CfgSetCntShortcutVars(p_shortcut,PSHORTCUTVARS(child.Data));
         child:=child.getNextSibling;
        end;
      end;
     node:=node.getNextSibling;
    end;
  end;

 for n:=0 to TreeView.Items.Count-1 do
  begin
   FreeMem(TreeView.Items[n].Data);
   TreeView.Items[n].Data:=nil;
  end;
 TreeView.Items.Clear;

 icons:=nil;

 inherited;
end;

procedure TSetupContentForm.FormShow(Sender: TObject);
begin
 try
  ButtonOK.SetFocus;
 except end;
end;

procedure TSetupContentForm.ActionAddSheet(node:TTreeNode);
var p:PSHEETVARS;
    n:TTreeNode;
begin
 GetMem(p,sizeof(TSHEETVARS));
 p.s_name:=S_DEFSHEETNAME;
 p.s_icon_path:='';
 p.i_color:=RGB(192,192,192);
 p.i_bg_color:=RGB(58,110,165);
 p.s_bg_pic:='';
 p.s_bg_thumb_pic:='';
 p.i_time_min:=0;
 p.i_time_max:=24;
 p.s_vip_users:='';
 p.s_rules:='';
 p.is_internet_sheet:=false;

 n:=TreeView.Items.Add(nil,p.s_name);
 n.Data:=p;
 SetIconForNode(n,'\');
 TreeView.Selected:=n;
end;

procedure TSetupContentForm.ActionAddShortcut(node:TTreeNode;const def:POldLnkFileInfo);
var n,sheet_node:TTreeNode;
    p:PSHORTCUTVARS;
begin
 if node<>nil then
  begin
   if node.Parent=nil then
    sheet_node:=node
   else
    sheet_node:=node.Parent;

   GetMem(p,sizeof(TSHORTCUTVARS));

   if def=nil then
    begin
     p.s_name:=S_DEFSHORTCUTNAME;
     p.s_exe:='';
     p.s_arg:='';
     p.s_cwd:='';
     p.s_icon_path:='';
     p.i_icon_idx:=0;
     p.s_pwd:='';
     p.b_allow_only_one:=true;
     p.s_runas_domain:='';
     p.s_runas_user:='';
     p.s_runas_pwd:='';
     p.i_show_cmd:=SW_SHOWNORMAL;
     p.i_vcd_num:=-1;
     p.s_vcd:='';
     p.s_saver:='';
     p.s_sshot:='';
     p.s_desc:='';
     p.s_script1:='';
     p.s_group:='';
     p.s_floatlic:='';
    end
   else
    begin
     StrCopy(p.s_name,def.name);
     StrCopy(p.s_exe,def.exe);
     StrCopy(p.s_arg,def.arg);
     StrCopy(p.s_cwd,def.cwd);
     StrCopy(p.s_icon_path,def.icon);
     p.i_icon_idx:=def.icon_idx;
     p.s_pwd:='';
     p.b_allow_only_one:=def.allow_one;
     StrCopy(p.s_runas_domain,def.runas_domain);
     StrCopy(p.s_runas_user,def.runas_user);
     StrCopy(p.s_runas_pwd,def.runas_pwd);
     p.i_show_cmd:=def.showcmd;
     p.i_vcd_num:=def.vcd_num;
     StrCopy(p.s_vcd,def.vcd);
     StrCopy(p.s_saver,def.saver);
     StrCopy(p.s_sshot,def.sshot);
     StrCopy(p.s_desc,def.desc);
     StrCopy(p.s_script1,def.run_script);
     p.s_group:='';
     p.s_floatlic:='';
    end;

   n:=TreeView.Items.AddChild(sheet_node,p.s_name);
   n.Data:=p;
   SetIconForNode(n,p.s_exe);
   TreeView.Selected:=n;
  end;
end;

procedure TSetupContentForm.ActionMoveUp(node:TTreeNode);
var other:TTreeNode;
begin
 if node<>nil then
  begin
   other:=node.getPrevSibling;
   if other<>nil then
    begin
     node.MoveTo(other,naInsert);
     TreeView.Selected:=node;
    end;
  end;
end;

procedure TSetupContentForm.ActionMoveDown(node:TTreeNode);
var other:TTreeNode;
begin
 if node<>nil then
  begin
   other:=node.getNextSibling;
   if other<>nil then
    begin
     other:=other.getNextSibling;
     if other<>nil then
      node.MoveTo(other,naInsert)
     else
      node.MoveTo(node.getNextSibling,naAdd);
     TreeView.Selected:=node;
    end;
  end;
end;

procedure TSetupContentForm.ActionDelete(node:TTreeNode);
var child,other:TTreeNode;
begin
 if node<>nil then
  begin
   other:=node.getNextSibling;
   if other=nil then
    other:=node.getPrevSibling;
   if other=nil then
    other:=node.Parent;

   if IsSheetNode(node) then
    begin
     if MessageBox(handle,S_CONFIRMDELETESHEET,S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)<>IDOK then
      Exit;

     TreeView.Items.BeginUpdate;
     while true do
      begin
       child:=node.getFirstChild;
       if child=nil then
        break;
       FreeMem(child.Data);
       child.Data:=nil;
       child.Delete;
      end;
     TreeView.Items.EndUpdate;
    end;

   FreeMem(node.Data);
   node.Data:=nil;
   node.Delete;

   TreeView.Selected:=other;
  end;
end;

procedure TSetupContentForm.ActionSort(node:TTreeNode);
var parent:TTreeNode;
begin
 if node<>nil then
  begin
   parent:=node.Parent;
   if parent<>nil then
    begin
     if MessageBox(Handle,S_QUERY_SORTSHORTCUTS,S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
      begin
       parent.AlphaSort();
       TreeView.Selected:=parent;
      end;
    end;
  end;
end;

procedure TSetupContentForm.AddOldLnkShortcutProcPublic(const i:POldLnkFileInfo);
begin
 ActionAddShortcut(TreeView.Selected,i);
end;

function AddOldLnkShortcutProc(const i:POldLnkFileInfo;parm:pointer):longbool cdecl;
var obj:TSetupContentForm;
begin
 obj:=TSetupContentForm(parm);
 obj.AddOldLnkShortcutProcPublic(i);
 Result:=true;
end;

procedure TSetupContentForm.ExecuteTreeViewAction(action:integer);
var path:string;
begin
 ApplyChanges;
 onchange_enabled:=false;

 case action of
  ACTION_ADDSHEET:    ActionAddSheet(TreeView.Selected);
  ACTION_ADDSHORTCUT: ActionAddShortcut(TreeView.Selected);
  ACTION_MOVEUP:      ActionMoveUp(TreeView.Selected);
  ACTION_MOVEDOWN:    ActionMoveDown(TreeView.Selected);
  ACTION_DELETE:      ActionDelete(TreeView.Selected);
  ACTION_SORT:        ActionSort(TreeView.Selected);
  ACTION_ADDSHORTCUTS:
                      begin
                       path:=TrueGetFolder(false);
                       if path<>'' then
                        begin
                         Screen.Cursor:=crHourGlass;
                         Repaint;
                         OldLnkFile_Iterate(pchar(path),AddOldLnkShortcutProc,self);
                         Screen.Cursor:=crDefault;
                        end;
                      end;
 end;

 OnSelectionChanged();
 TreeView.SetFocus;
 onchange_enabled:=true;
end;

procedure TSetupContentForm.ButtonAddSheetClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_ADDSHEET);
end;

procedure TSetupContentForm.ButtonAddShortcutClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_ADDSHORTCUT);
end;

procedure TSetupContentForm.ButtonAddShortcutsFromFolderClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_ADDSHORTCUTS);
end;

procedure TSetupContentForm.ButtonDelClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_DELETE);
end;

procedure TSetupContentForm.ButtonMoveUpClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_MOVEUP);
end;

procedure TSetupContentForm.ButtonMoveDownClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_MOVEDOWN);
end;

procedure TSetupContentForm.ButtonSortClick(Sender: TObject);
begin
 ExecuteTreeViewAction(ACTION_SORT);
end;

procedure TSetupContentForm.PanelColorClick(Sender: TObject);
begin
 ColorDialog1.Color:=PanelColor.Color;
 if ColorDialog1.Execute then
  PanelColor.Color:=ColorDialog1.Color;
end;

procedure TSetupContentForm.PanelBGColorClick(Sender: TObject);
begin
 ColorDialog1.Color:=PanelBGColor.Color;
 if ColorDialog1.Execute then
  PanelBGColor.Color:=ColorDialog1.Color;
end;

procedure TSetupContentForm.Button1Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('ICO Files'#0'*.ico'#0#0),'');
 if s<>'' then
  Edit2.Text:=s;
end;

procedure TSetupContentForm.Button2Click(Sender: TObject);
var s:string;
begin
 s:=GetFolderFile();
 if s<>'' then
  Edit3.Text:=s;
end;

procedure TSetupContentForm.UpdateSheetMinMaxTime();
begin
 LabelTimeMin.Caption:=inttostr(TrackBarTimeMin.Position)+' '+S_HOURS;
 LabelTimeMax.Caption:=inttostr(TrackBarTimeMax.Position)+' '+S_HOURS;
end;

procedure TSetupContentForm.TrackBarTimeMinChange(Sender: TObject);
begin
 UpdateSheetMinMaxTime();
end;

procedure TSetupContentForm.TrackBarTimeMaxChange(Sender: TObject);
begin
 UpdateSheetMinMaxTime();
end;

procedure TSetupContentForm.Button4Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('RTF/HTML Files'#0'*.rtf;*.html;*.htm'#0#0),'');
 if s<>'' then
  Edit5.Text:=s;
end;

procedure TSetupContentForm.Button5Click(Sender: TObject);
var s:string;
begin
 TipForm.ShowTip(3);
 s:=GetFolderFile();
 if s<>'' then
  Edit7.Text:=s;
end;

procedure TSetupContentForm.Button6Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit9.Text:=s;
end;

procedure TSetupContentForm.Button7Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('ICO/EXE/DLL/JPG/PNG/BMP'#0'*.ico;*.exe;*.dll;*.jpg;*.jpeg;*.jpe;*.bmp;*.png;*.tif;*.tiff;*.gif'#0#0),'');
 if s<>'' then
  Edit10.Text:=s;
end;

procedure TSetupContentForm.Button8Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('Virtual CD (VCD,D00,VC4,FCD,ISO,MDS,CCD,CUE,NRG,BWT,CDI,B5T,PDI,B6T,B6I,B00)'#0'*.vcd;*.d00;*.vc4;*.fcd;*.iso;*.mds;*.ccd;*.cue;*.nrg;*.bwt;*.cdi;*.b5t;*.pdi;*.b6t;*.b6i;*.b00'#0#0),'');
 if s<>'' then
  Edit16.Text:=s;
end;

procedure TSetupContentForm.Button11Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('JPEG/BMP/PNG/GIF/TIFF'#0'*.jpg;*.jpe;*.jpeg;*.bmp;*.png;*.gif;*.tif;*.tiff'#0#0),'');
 if s<>'' then
  Edit18.Text:=s;
end;

procedure TSetupContentForm.Button9Click(Sender: TObject);
begin
 Memo1.Text:='';
end;

procedure TSetupContentForm.Button12Click(Sender: TObject);
begin
 Memo2.Text:='';
end;

procedure TSetupContentForm.Button14Click(Sender: TObject);
begin
 Memo3.Text:='';
end;

procedure TSetupContentForm.Button10Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('TXT Files'#0'*.txt'#0#0),'');
 if s<>'' then
  Memo1.Text:=s;
end;

procedure TSetupContentForm.Button13Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('BAT/CMD Files'#0'*.bat;*.cmd'#0#0),'');
 if s<>'' then
  Memo2.Text:=s;
end;

procedure TSetupContentForm.Button15Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('INI Files'#0'*.ini'#0#0),'');
 if s<>'' then
  Memo3.Text:=s;
end;

procedure TSetupContentForm.Button20Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('INI Files'#0'*.ini'#0#0),'');
 if s<>'' then
  Edit19.Text:=s;
end;

procedure TSetupContentForm.Button16Click(Sender: TObject);
begin
 ShellExecute(0,nil,pchar(GetLocalPath(PATH_SAVEREXAMPLE)),nil,nil,SW_SHOWMAXIMIZED);
end;

procedure TSetupContentForm.TreeViewEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TSetupContentForm.OnSelectionChanged();
var node:TTreeNode;
begin
 node:=TreeView.Selected;
 if node=nil then
  begin
   ButtonAddSheet.Enabled:=true;
   ButtonAddShortcut.Enabled:=false;
   ButtonAddShortcutsFromFolder.Enabled:=false;
   ButtonMoveUp.Enabled:=false;
   ButtonMoveDown.Enabled:=false;
   ButtonSort.Enabled:=false;
   ButtonDel.Enabled:=false;
   SwitchToPage(0);
  end
 else
  begin
   if IsSheetNode(node) then
    begin
     ButtonAddSheet.Enabled:=true;
     ButtonAddShortcut.Enabled:=true;
     ButtonAddShortcutsFromFolder.Enabled:=true;
     ButtonMoveUp.Enabled:=node.getPrevSibling<>nil;
     ButtonMoveDown.Enabled:=node.getNextSibling<>nil;
     ButtonSort.Enabled:=false;
     ButtonDel.Enabled:=true;
     FillSheetPage(PSHEETVARS(node.Data));
     SwitchToPage(1);
    end
   else
    begin
     ButtonAddSheet.Enabled:=true;
     ButtonAddShortcut.Enabled:=true;
     ButtonAddShortcutsFromFolder.Enabled:=true;
     ButtonMoveUp.Enabled:=node.getPrevSibling<>nil;
     ButtonMoveDown.Enabled:=node.getNextSibling<>nil;
     ButtonSort.Enabled:=(node.getNextSibling<>nil) or (node.getPrevSibling<>nil);
     ButtonDel.Enabled:=true;
     FillShortcutPage(PSHORTCUTVARS(node.Data));
     SwitchToPage(2);
    end;
  end;
end;

procedure TSetupContentForm.FillSheetPage(v:PSHEETVARS);
begin
 Edit1.Text:=v.s_name;
 Edit2.Text:=v.s_icon_path;
 PanelColor.Color:=TColor(v.i_color);
 PanelBGColor.Color:=TColor(v.i_bg_color);
 Edit3.Text:=v.s_bg_pic;
 Edit17.Text:=v.s_bg_thumb_pic;
 TrackBarTimeMin.Position:=v.i_time_min;
 TrackBarTimeMax.Position:=v.i_time_max;
 UpdateSheetMinMaxTime();
 Edit4.Text:=v.s_vip_users;
 Edit5.Text:=v.s_rules;
 CheckBoxInternet.Checked:=v.is_internet_sheet;
end;

procedure TSetupContentForm.StoreSheetPage(v:PSHEETVARS);
begin
 StrLCopy(v.s_name,pchar(Edit1.Text),sizeof(v.s_name)-1);
 StrLCopy(v.s_icon_path,pchar(Edit2.Text),sizeof(v.s_icon_path)-1);
 v.i_color:=integer(PanelColor.Color);
 v.i_bg_color:=integer(PanelBGColor.Color);
 StrLCopy(v.s_bg_pic,pchar(Edit3.Text),sizeof(v.s_bg_pic)-1);
 StrLCopy(v.s_bg_thumb_pic,pchar(Edit17.Text),sizeof(v.s_bg_thumb_pic)-1);
 v.i_time_min:=TrackBarTimeMin.Position;
 v.i_time_max:=TrackBarTimeMax.Position;
 StrLCopy(v.s_vip_users,pchar(Edit4.Text),sizeof(v.s_vip_users)-1);
 StrLCopy(v.s_rules,pchar(Edit5.Text),sizeof(v.s_rules)-1);
 v.is_internet_sheet:=CheckBoxInternet.Checked;
end;

procedure TSetupContentForm.FillShortcutPage(v:PSHORTCUTVARS);
begin
 Edit6.Text:=v.s_name;
 Edit7.Text:=v.s_exe;
 Edit8.Text:=v.s_arg;
 Edit9.Text:=v.s_cwd;
 Edit10.Text:=v.s_icon_path;
 Edit11.Text:=inttostr(v.i_icon_idx);
 Edit12.Text:=v.s_pwd;
 if v.i_show_cmd in [SW_HIDE] then
  ComboBoxShowCmd.ItemIndex:=1
 else
 if v.i_show_cmd in [SW_MAXIMIZE,SW_SHOWMAXIMIZED] then
  ComboBoxShowCmd.ItemIndex:=2
 else
 if v.i_show_cmd in [SW_MINIMIZE,SW_SHOWMINIMIZED,SW_SHOWMINNOACTIVE] then
  ComboBoxShowCmd.ItemIndex:=3
 else
  ComboBoxShowCmd.ItemIndex:=0;
 CheckBoxOnlyOne.Checked:=v.b_allow_only_one;
 Edit13.Text:=v.s_runas_domain;
 Edit14.Text:=v.s_runas_user;
 Edit15.Text:=v.s_runas_pwd;
 Edit16.Text:=v.s_vcd;
 ComboBoxVCD.ItemIndex:=v.i_vcd_num;
 Edit18.Text:=v.s_sshot;
 Memo1.Text:=v.s_desc;
 Memo2.Text:=v.s_script1;
 Memo3.Text:=v.s_saver;
 ComboBoxGroup.Text:=v.s_group;
 Edit19.Text:=v.s_floatlic;
end;

procedure TSetupContentForm.StoreShortcutPage(v:PSHORTCUTVARS);
begin
 StrLCopy(v.s_name,pchar(Edit6.Text),sizeof(v.s_name)-1);
 StrLCopy(v.s_exe,pchar(Edit7.Text),sizeof(v.s_exe)-1);
 StrLCopy(v.s_arg,pchar(Edit8.Text),sizeof(v.s_arg)-1);
 StrLCopy(v.s_cwd,pchar(Edit9.Text),sizeof(v.s_cwd)-1);
 StrLCopy(v.s_icon_path,pchar(Edit10.Text),sizeof(v.s_icon_path)-1);
 v.i_icon_idx:=StrToIntDef(Edit11.Text,0);
 StrLCopy(v.s_pwd,pchar(Edit12.Text),sizeof(v.s_pwd)-1);
 case ComboBoxShowCmd.ItemIndex of
 1: v.i_show_cmd:=SW_HIDE;
 2: v.i_show_cmd:=SW_SHOWMAXIMIZED;
 3: v.i_show_cmd:=SW_SHOWMINIMIZED;
 else
  v.i_show_cmd:=SW_SHOWNORMAL;
 end;
 v.b_allow_only_one:=CheckBoxOnlyOne.Checked;
 StrLCopy(v.s_runas_domain,pchar(Edit13.Text),sizeof(v.s_runas_domain)-1);
 StrLCopy(v.s_runas_user,pchar(Edit14.Text),sizeof(v.s_runas_user)-1);
 StrLCopy(v.s_runas_pwd,pchar(Edit15.Text),sizeof(v.s_runas_pwd)-1);
 StrLCopy(v.s_vcd,pchar(Edit16.Text),sizeof(v.s_vcd)-1);
 v.i_vcd_num:=ComboBoxVCD.ItemIndex;
 StrLCopy(v.s_sshot,pchar(Edit18.Text),sizeof(v.s_sshot)-1);
 StrLCopy(v.s_desc,pchar(Memo1.Text),sizeof(v.s_desc)-1);
 StrLCopy(v.s_script1,pchar(Memo2.Text),sizeof(v.s_script1)-1);
 StrLCopy(v.s_saver,pchar(Memo3.Text),sizeof(v.s_saver)-1);
 StrLCopy(v.s_group,pchar(ComboBoxGroup.Text),sizeof(v.s_group)-1);
 UpdateHistoryFromComboBox(ComboBoxGroup,'Groups');
 StrLCopy(v.s_floatlic,pchar(Edit19.Text),sizeof(v.s_floatlic)-1);
end;

procedure TSetupContentForm.TreeViewChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
 AllowChange:=true;
 if Visible and onchange_enabled then
   ApplyChanges();
end;

procedure TSetupContentForm.TreeViewChange(Sender: TObject;
  Node: TTreeNode);
begin
 if Visible and onchange_enabled then
  begin
   onchange_enabled:=false;
   OnSelectionChanged();
   onchange_enabled:=true;
  end;
end;

procedure TSetupContentForm.OnShortcutTitleChanged();
var node:TTreeNode;
begin
 if Visible and onchange_enabled then
  begin
   onchange_enabled:=false;
   node:=TreeView.Selected;
   if (node<>nil) and IsShortcutNode(node) then
    begin
     node.Text:=Edit6.Text;
     SetIconForNode(node,Edit7.Text);
    end;
   onchange_enabled:=true;
  end;
end;

procedure TSetupContentForm.OnSheetTitleChanged();
var node:TTreeNode;
begin
 if Visible and onchange_enabled then
  begin
   onchange_enabled:=false;
   node:=TreeView.Selected;
   if (node<>nil) and IsSheetNode(node) then
    begin
     node.Text:=Edit1.Text;
    end;
   onchange_enabled:=true;
  end;
end;

procedure TSetupContentForm.Edit6Change(Sender: TObject);
begin
 OnShortcutTitleChanged();
end;

procedure TSetupContentForm.Edit7Change(Sender: TObject);
begin
 OnShortcutTitleChanged();
end;

procedure TSetupContentForm.Edit1Change(Sender: TObject);
begin
 OnSheetTitleChanged();
end;

function TSetupContentForm.IsSheetNode(node:TTreeNode):boolean;
begin
 Result:=(node<>nil) and (node.Parent=nil);
end;

function TSetupContentForm.IsShortcutNode(node:TTreeNode):boolean;
begin
 Result:=(node<>nil) and (node.Parent<>nil);
end;

procedure TSetupContentForm.ApplyChanges();
var node:TTreeNode;
begin
 node:=TreeView.Selected;
 if node<>nil then
  begin
   if IsSheetNode(node) then
    begin
     StoreSheetPage(PSHEETVARS(node.Data));
    end
   else
    begin
     StoreShortcutPage(PSHORTCUTVARS(node.Data));
    end;
  end;
end;

procedure TSetupContentForm.ButtonOKClick(Sender: TObject);
begin
 ApplyChanges();
 if ValidateContent() then
  ModalResult:=mrOk;
end;

procedure TSetupContentForm.TreeViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
 VK_INSERT:  begin
              if TreeView.Selected=nil then
               begin
                if ButtonAddSheet.Enabled then
                 ButtonAddSheetClick(Sender);
               end
              else
               begin
                if ButtonAddShortcut.Enabled then
                 ButtonAddShortcutClick(Sender);
               end;
             end;
 VK_DELETE:  begin
              if Buttondel.Enabled then
               ButtonDelClick(Sender);
             end;
 VK_UP:      begin
              if ssCtrl in Shift then
               begin
                if ButtonMoveUp.Enabled then
                 ButtonMoveUpClick(Sender);
               end;
             end;
 VK_DOWN:    begin
              if ssCtrl in Shift then
               begin
                if ButtonMoveDown.Enabled then
                 ButtonMoveDownClick(Sender);
               end;
             end;
 end;
end;

function TSetupContentForm.ValidateContent():boolean;
var n:integer;
    node,child:TTreeNode;
begin
 Result:=true;

 for n:=0 to TreeView.Items.Count-1 do
  if trim(TreeView.Items[n].Text)='' then
   begin
    MessageBox(Handle,S_EMPTYELEM,S_ERR,MB_OK or MB_ICONERROR);
    Result:=false;
    Exit;
   end;

 node:=TreeView.Items.GetFirstNode;
 while node<>nil do
  begin
   if not IsNodeUnique(node) then
    begin
     Result:=false;
     break;
    end;
   child:=node.getFirstChild;
   while child<>nil do
    begin
     if not IsNodeUnique(child) then
      begin
       Result:=false;
       break;
      end;
     child:=child.getNextSibling;
    end;
   if not Result then
    break;
   node:=node.getNextSibling;
  end;

 if not Result then
  MessageBox(Handle,S_NOTUNIQUEELEM,S_ERR,MB_OK or MB_ICONERROR);
end;

function TSetupContentForm.IsNodeUnique(node:TTreeNode):boolean;
var other:TTreeNode;
begin
 Result:=true;
 if node<>nil then
  begin
   other:=node;
   while true do
    begin
     other:=other.getPrevSibling;
     if other=nil then
      break;
     if AnsiCompareText(other.Text,node.Text)=0 then
      begin
       Result:=false;
       break;
      end;
    end;

   other:=node;
   while true do
    begin
     other:=other.getNextSibling;
     if other=nil then
      break;
     if AnsiCompareText(other.Text,node.Text)=0 then
      begin
       Result:=false;
       break;
      end;
    end;
  end;
end;


procedure TSetupContentForm.Button17Click(Sender: TObject);
var s:string;
begin
 s:=GetFolderFile();
 if s<>'' then
  Edit17.Text:=s;
end;

procedure TSetupContentForm.Button3Click(Sender: TObject);
var url:string;
begin
 url:='';
 if PageControl.ActivePageIndex=1 then
  url:='clcnt/01.html'
 else
 if PageControl.ActivePageIndex=2 then
  url:='clcnt/02.html';
 HHW_DisplayTopic(0,pchar(GetLocalPath(PATH_HELP)),pchar(url),nil);
end;

procedure TSetupContentForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_F1 then
  if Button3.Visible and Button3.Enabled then
    Button3Click(Sender);
end;

procedure TSetupContentForm.ComboBoxVCDChange(Sender: TObject);
//var idx:integer;
begin
// if visible then
//  begin
//   idx:=ComboBoxVCD.ItemIndex;
//   if idx in [3..6] then
//    TipForm.ShowTip(2);
//  end;
end;

function PrepareString4Saving2Ini(const s:string):string;
begin
 Result:=s;
 Result:=AnsiReplaceText(Result,#13,'');
 Result:=AnsiReplaceText(Result,#10,#127);
end;

function ConvertStringFromIni(const s:string):string;
begin
 Result:=AnsiReplaceText(s,#127,#13#10);
end;

function C4I(const s:string):string;
begin
 Result:=ConvertStringFromIni(s);
end;

function TSetupContentForm.SaveShortcutToFile(const v:PSHORTCUTVARS;const filename:string):boolean;
const section='main';
var ini:TIniFile;
begin
 Result:=false;

 ini:=nil;
 try
  ini:=TIniFile.Create(filename);

  ini.WriteString  (section,   's_name',            v.s_name                                );
  ini.WriteString  (section,   's_exe',             v.s_exe                                 );
  ini.WriteString  (section,   's_arg',             v.s_arg                                 );
  ini.WriteString  (section,   's_cwd',             v.s_cwd                                 );
  ini.WriteString  (section,   's_icon_path',       v.s_icon_path                           );
  ini.WriteInteger (section,   'i_icon_idx',        v.i_icon_idx                            );
  ini.WriteString  (section,   's_pwd',             v.s_pwd                                 );
  ini.WriteBool    (section,   'b_allow_only_one',  v.b_allow_only_one                      );
  ini.WriteString  (section,   's_runas_domain',    v.s_runas_domain                        );
  ini.WriteString  (section,   's_runas_user',      v.s_runas_user                          );
  ini.WriteString  (section,   's_runas_pwd',       v.s_runas_pwd                           );
  ini.WriteInteger (section,   'i_show_cmd',        v.i_show_cmd                            );
  ini.WriteInteger (section,   'i_vcd_num',         v.i_vcd_num                             );
  ini.WriteString  (section,   's_vcd',             v.s_vcd                                 );
  ini.WriteString  (section,   's_saver',           PrepareString4Saving2Ini(v.s_saver)     );
  ini.WriteString  (section,   's_sshot',           v.s_sshot                               );
  ini.WriteString  (section,   's_desc',            PrepareString4Saving2Ini(v.s_desc)      );
  ini.WriteString  (section,   's_script1',         PrepareString4Saving2Ini(v.s_script1)   );
  ini.WriteString  (section,   's_group',           v.s_group                               );
  ini.WriteString  (section,   's_floatlic',        v.s_floatlic                            );

  Result:=true;
 except
 end;
 ini.Free;
end;

function TSetupContentForm.LoadShortcutFromFile(v:PSHORTCUTVARS;const filename:string):boolean;
const section='main';
var ini:TIniFile;
begin
 Result:=false;

 ini:=nil;
 try
  ini:=TIniFile.Create(filename);

  StrCopy( v.s_name,             pchar(      ini.ReadString  (section,   's_name',            ''     )));
  StrCopy( v.s_exe,              pchar(      ini.ReadString  (section,   's_exe',             ''     )));
  StrCopy( v.s_arg,              pchar(      ini.ReadString  (section,   's_arg',             ''     )));
  StrCopy( v.s_cwd,              pchar(      ini.ReadString  (section,   's_cwd',             ''     )));
  StrCopy( v.s_icon_path,        pchar(      ini.ReadString  (section,   's_icon_path',       ''     )));
           v.i_icon_idx:=                    ini.ReadInteger (section,   'i_icon_idx',        0      );
  StrCopy( v.s_pwd,              pchar(      ini.ReadString  (section,   's_pwd',             ''     )));
           v.b_allow_only_one:=              ini.ReadBool    (section,   'b_allow_only_one',  false  );
  StrCopy( v.s_runas_domain,     pchar(      ini.ReadString  (section,   's_runas_domain',    ''     )));
  StrCopy( v.s_runas_user,       pchar(      ini.ReadString  (section,   's_runas_user',      ''     )));
  StrCopy( v.s_runas_pwd,        pchar(      ini.ReadString  (section,   's_runas_pwd',       ''     )));
           v.i_show_cmd:=                    ini.ReadInteger (section,   'i_show_cmd',        0      );
           v.i_vcd_num:=                     ini.ReadInteger (section,   'i_vcd_num',         0      );
  StrCopy( v.s_vcd,              pchar(      ini.ReadString  (section,   's_vcd',             ''     )));
  StrCopy( v.s_saver,            pchar( C4I( ini.ReadString  (section,   's_saver',           ''     ))));
  StrCopy( v.s_sshot,            pchar(      ini.ReadString  (section,   's_sshot',           ''     )));
  StrCopy( v.s_desc,             pchar( C4I( ini.ReadString  (section,   's_desc',            ''     ))));
  StrCopy( v.s_script1,          pchar( C4I( ini.ReadString  (section,   's_script1',         ''     ))));
  StrCopy( v.s_group,            pchar(      ini.ReadString  (section,   's_group',           ''     )));
  StrCopy( v.s_floatlic,         pchar(      ini.ReadString  (section,   's_floatlic',        ''     )));

  Result:=true;
 except
 end;
 ini.Free;
end;

procedure TSetupContentForm.Button18Click(Sender: TObject);
var filename:string;
    v:TSHORTCUTVARS;
begin
 StoreShortcutPage(@v);

 filename:=ReplaceInvalidFileNameChars(trim(v.s_name));
 if filename='' then
  filename:='default';
 filename:=filename+'.shortcut';

 SaveDialog1.FileName:=filename;
 if SaveDialog1.Execute then
  begin
   if not SaveShortcutToFile(@v,SaveDialog1.FileName) then
    MessageBox(Handle,S_ERR_FILEWRITE,S_ERR,MB_OK or MB_ICONERROR);
  end;
end;

procedure TSetupContentForm.Button19Click(Sender: TObject);
var v:TSHORTCUTVARS;
begin
 if OpenDialog1.Execute then
  begin
   if not LoadShortcutFromFile(@v,OpenDialog1.FileName) then
    MessageBox(Handle,S_ERR_FILEREAD,S_ERR,MB_OK or MB_ICONERROR)
   else
    FillShortcutPage(@v);
  end;
end;


end.
