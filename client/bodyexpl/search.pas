unit search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Menus, ImgList;


type TSearchFileOp = (sfop_copy,sfop_cut,sfop_delete,sfop_exec);

type TSearchFileOpFunc = function(wnd:HWND;cmd:TSearchFileOp;const list:TStringList):boolean of object;


type
  TSearchFilesForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EditMasks: TEdit;
    CheckBoxRecurse: TCheckBox;
    ButtonStartStop: TButton;
    StatusBar: TStatusBar;
    Bevel1: TBevel;
    Panel2: TPanel;
    PanelTools: TPanel;
    PanelListView: TPanel;
    ListView: TListView;
    CheckBoxFolders: TCheckBox;
    ButtonGo: TButton;
    ButtonExec: TButton;
    PopupMenu: TPopupMenu;
    MenuCopy: TMenuItem;
    N1: TMenuItem;
    MenuDelete: TMenuItem;
    MenuCut: TMenuItem;
    N2: TMenuItem;
    MenuGo: TMenuItem;
    MenuExec: TMenuItem;
    ImageList: TImageList;
    Panel3: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ListViewDeletion(Sender: TObject; Item: TListItem);
    procedure ButtonGoClick(Sender: TObject);
    procedure ButtonExecClick(Sender: TObject);
    procedure MenuGoClick(Sender: TObject);
    procedure MenuExecClick(Sender: TObject);
    procedure MenuCopyClick(Sender: TObject);
    procedure MenuCutClick(Sender: TObject);
    procedure MenuDeleteClick(Sender: TObject);
    procedure ButtonStartStopClick(Sender: TObject);
    procedure ListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EditMasksKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewInsert(Sender: TObject; Item: TListItem);
  private
    { Private declarations }
    g_stop_search : boolean;             // used only during search process
    g_files_processed : integer;         // used only during search process
    g_files_find : integer;              // used only during search process
    g_last_processmessages : cardinal;   // used only during search process

    procedure SearchFiles(const path,masks:string;b_recurse,b_search_folders:boolean);
    function IsMatchMasks(const filename,_masks:string):boolean;
    function IsMatchSingleMask(const filename,mask:string):boolean;
    procedure AddFileToListView(const filename:string;var _f:_WIN32_FIND_DATA);
    function GetFileIcon(const s:string):HICON;
    function GetFileSizeStr(low,high:cardinal):string;
    function CreateSelectedList(include_dirs:boolean=false):TStringList;
    function MultiFilesOperation(cmd:TSearchFileOp):boolean;
  public
    { Public declarations }
    g_resource_name : string;
    g_resource_root : string;
    g_search_from : string;
    g_op_func : TSearchFileOpFunc;
    g_output_file : string;

  end;

var
  SearchFilesForm: TSearchFilesForm;



function ShowSearchFilesFormModal(const _resource_name,_resource_root,_search_from:string;
                             _op_func:TSearchFileOpFunc):string;


implementation

uses CommCtrl, ShellAPI, StrUtils;

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

type
     TFileInfo = record
      filename : string;
      is_dir : longbool;
     end;
     PFileInfo = ^TFileInfo;

function PathMatchSpec(const filename,spec:pchar):BOOL stdcall; external 'shlwapi.dll' name 'PathMatchSpecA';


function ShowSearchFilesFormModal(const _resource_name,_resource_root,_search_from:string;
                                  _op_func:TSearchFileOpFunc):string;
var _root,_from:string;
begin
 Result:='';

 if (_resource_root='') or (_search_from='') or (@_op_func=nil) then
  exit;

 _root:=IncludeTrailingPathDelimiter(_resource_root);
 _from:=IncludeTrailingPathDelimiter(_search_from);

 if (length(_from)<length(_root)) or (not AnsiStartsText(_root,_from)) then
    exit;

 with SearchFilesForm do
  begin
   g_resource_name:=_resource_name;
   g_resource_root:=_root;
   g_search_from:=_from;
   g_op_func:=_op_func;

   if ShowModal=mrOk then
    Result:=g_output_file;
  end;
end;

procedure TSearchFilesForm.FormCreate(Sender: TObject);
var i:TIcon;
begin
 g_resource_name:='';
 g_resource_root:='';
 g_search_from:='';
 g_op_func:=nil;
 g_output_file:='';

 EditMasks.Text:='';
 CheckBoxRecurse.Checked:=true;
 CheckBoxFolders.Checked:=false;

 ImageList.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 1, 100);

 i:=TIcon.Create();
 i.Handle:=DuplicateIcon(0,LoadImage(hinstance,pchar(110),IMAGE_ICON,48,48,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;
end;

procedure TSearchFilesForm.FormDestroy(Sender: TObject);
begin
 Image1.Picture.Assign(nil);
end;

procedure TSearchFilesForm.FormShow(Sender: TObject);
begin
 Caption:=Format(LS(1414),[g_resource_name+'\'+Copy(g_search_from,length(g_resource_root)+1,length(g_search_from)-length(g_resource_root))]);
 Label1.Caption:=LS(1415);
 CheckBoxRecurse.Caption:=LS(1416);
 CheckBoxFolders.Caption:=LS(1417);
 ButtonStartStop.Caption:=LS(1418);
 ButtonGo.Caption:=LS(1419);
 ButtonExec.Caption:=LS(1420);
 MenuCopy.Caption:=LS(1421);
 MenuDelete.Caption:=LS(1422);
 MenuCut.Caption:=LS(1423);
 MenuGo.Caption:=ButtonGo.Caption;
 MenuExec.Caption:=ButtonExec.Caption;
 PanelListView.Caption:=LS(1424);

 ListView.Clear;
 ListView.Columns[0].Caption:=LS(1425);
 ListView.Columns[1].Caption:=LS(1426);
 ListView.Columns[2].Caption:=LS(1427);

 PanelTools.Visible:=false;
 ImageList_RemoveAll(ImageList.Handle);

 StatusBar.Panels[0].Text:='';
 StatusBar.Panels[1].Text:='';

 EditMasks.SetFocus;
end;

procedure TSearchFilesForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=EditMasks.Enabled;
end;

procedure TSearchFilesForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=VK_ESCAPE then
  begin
   if EditMasks.Enabled then
    ModalResult:=mrCancel
   else
   if ButtonStartStop.Enabled then
    ButtonStartStopClick(Sender);
  end;
end;

procedure TSearchFilesForm.ListViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var b_single, b_dir : boolean;
begin
 b_single:=ListView.SelCount=1;
 b_dir:=b_single and (ListView.Selected.Data<>nil) and PFileInfo(ListView.Selected.Data)^.is_dir;

 ButtonGo.Enabled:=b_single;
 ButtonExec.Enabled:=b_single and (not b_dir);
end;

procedure TSearchFilesForm.ListViewDblClick(Sender: TObject);
begin
 MenuExecClick(Sender);
end;

procedure TSearchFilesForm.ListViewEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TSearchFilesForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=ord('A')) and (ssCtrl in Shift) then
  ListView.SelectAll;
 if (key=ord('C')) and (ssCtrl in Shift) then
  MenuCopyClick(Sender);
 if (key=ord('X')) and (ssCtrl in Shift) then
  MenuCutClick(Sender);
 if (key=VK_DELETE) then
  MenuDeleteClick(Sender);
 if (key=VK_RETURN) then
  MenuExecClick(Sender);
end;

procedure TSearchFilesForm.ListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var b_selected : boolean;
    b_multi : boolean;
    b_single : boolean;
    b_dir : boolean;
begin
 b_single:=ListView.SelCount=1;
 b_multi:=ListView.SelCount>1;
 b_selected:=b_single or b_multi;
 b_dir:=b_single and (ListView.Selected.Data<>nil) and PFileInfo(ListView.Selected.Data)^.is_dir;

 MenuGo.Enabled:=b_single;
 MenuExec.Enabled:=b_single and (not b_dir);
 MenuCopy.Enabled:=b_selected;
 MenuCut.Enabled:=b_selected;
 MenuDelete.Enabled:=b_selected;

 Handled:=false;
end;

procedure TSearchFilesForm.ListViewInsert(Sender: TObject;
  Item: TListItem);
begin
 Item.Data:=nil;
end;

procedure TSearchFilesForm.ListViewDeletion(Sender: TObject;
  Item: TListItem);
begin
 if Item.Data<>nil then
  begin
   dispose(PFileInfo(Item.Data));
   Item.Data:=nil;
  end;
end;

procedure TSearchFilesForm.ButtonGoClick(Sender: TObject);
begin
 MenuGoClick(Sender);
end;

procedure TSearchFilesForm.ButtonExecClick(Sender: TObject);
begin
 MenuExecClick(Sender);
end;

procedure TSearchFilesForm.MenuGoClick(Sender: TObject);
var i:PFileInfo;
begin
 if ListView.SelCount=1 then
  begin
   i:=PFileInfo(ListView.Selected.Data);
   if i<>nil then
    begin
     g_output_file:=i.filename;
     ModalResult:=mrOk;
    end;
  end;
end;

procedure TSearchFilesForm.MenuExecClick(Sender: TObject);
var i:PFileInfo;
    list:TStringList;
begin
 if ListView.SelCount=1 then
  begin
   i:=PFileInfo(ListView.Selected.Data);
   if (i<>nil) and (not i.is_dir) then
    begin
     list:=CreateSelectedList();
     g_op_func(Handle,sfop_exec,list);
     list.Free;
    end;
  end;
end;

procedure TSearchFilesForm.MenuCopyClick(Sender: TObject);
begin
 MultiFilesOperation(sfop_copy);
end;

procedure TSearchFilesForm.MenuCutClick(Sender: TObject);
begin
 MultiFilesOperation(sfop_cut);
end;

procedure TSearchFilesForm.MenuDeleteClick(Sender: TObject);
begin
 if MultiFilesOperation(sfop_delete) then
  begin
   ListView.DeleteSelected;
  end;
end;

function TSearchFilesForm.MultiFilesOperation(cmd:TSearchFileOp):boolean;
var list:TStringList;
begin
 Result:=false;
 if ListView.SelCount>0 then
  begin
   list:=CreateSelectedList(false);
   if list.Count>0 then
    Result:=g_op_func(Handle,cmd,list);
   list.Free;
  end;
end;

procedure TSearchFilesForm.ButtonStartStopClick(Sender: TObject);
begin
 if EditMasks.Enabled then
  begin //start search
   if trim(EditMasks.Text)='' then
    begin
     MessageBox(Handle,LSP(1428),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
     EditMasks.SetFocus;
     exit;
    end;

   Label1.Enabled:=false;
   EditMasks.Enabled:=false;
   CheckBoxRecurse.Enabled:=false;
   CheckBoxFolders.Enabled:=false;
   ButtonStartStop.Caption:=LS(1429);
   ListView.Clear;
   ListView.Enabled:=false;
   ListView.Visible:=false;
   ImageList_RemoveAll(ImageList.Handle);
   PanelTools.Visible:=false;
   StatusBar.Panels[0].Text:='';
   StatusBar.Panels[1].Text:='';
   ButtonStartStop.SetFocus;
   Update;

   g_stop_search:=false;
   g_files_processed:=0;
   g_files_find:=0;
   g_last_processmessages:=GetTickCount();
   SearchFiles(g_search_from,EditMasks.Text,CheckBoxRecurse.Checked,CheckBoxFolders.Checked);

   if StatusBar.Panels[0].Text='' then
    StatusBar.Panels[0].Text:=LS(1430);

   Label1.Enabled:=true;
   EditMasks.Enabled:=true;
   CheckBoxRecurse.Enabled:=true;
   CheckBoxFolders.Enabled:=true;
   ButtonStartStop.Caption:=LS(1418);
   ButtonStartStop.Enabled:=true;
   ListView.ClearSelection;
   ListView.Visible:=true;
   ListView.Enabled:=true;
   ButtonGo.Enabled:=false;
   ButtonExec.Enabled:=false;
   PanelTools.Visible:=ListView.Items.Count>0;

   EditMasks.SetFocus;
  end
 else
  begin // stop search
   ButtonStartStop.Caption:='...';
   ButtonStartStop.Enabled:=false;
   Update;
   g_stop_search:=true;
  end;
end;

procedure TSearchFilesForm.SearchFiles(const path,masks:string;b_recurse,b_search_folders:boolean);
var f:_WIN32_FIND_DATA;
    h:cardinal;
    local:string;
    b_folder:boolean;
    b_match:boolean;
begin
 h:=Windows.FindFirstFile(pchar(IncludeTrailingPathdelimiter(path)+'*.*'),f);
 if h<>INVALID_HANDLE_VALUE then
  begin
   repeat
    local:=f.cFileName;
    if (local<>'.') and (local<>'..') then
     begin
      //if not (((f.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN)<>0) {or ((f.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM)<>0)}) then
       begin
        b_folder:=(f.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0;
        if b_search_folders or (not b_folder) then
         begin
          inc(g_files_processed);
          b_match:=IsMatchMasks(local,masks);
          if b_match then
           begin
            inc(g_files_find);
            AddFileToListView(IncludeTrailingPathdelimiter(path)+local,f);
           end;
          StatusBar.Panels[0].Text:=Format(LS(1431),[g_files_find]);
          StatusBar.Panels[1].Text:=Format(LS(1432),[g_files_processed]);
          //Update;
         end;

        if b_folder and b_recurse then
         SearchFiles(IncludeTrailingPathdelimiter(path)+local,masks,b_recurse,b_search_folders);
       end;
     end;
    if GetTickCount() - g_last_processmessages > 100 then
     begin
      g_last_processmessages:=GetTickCount();
      Application.ProcessMessages; // to fire g_stop_search and screen update
     end;
   until (g_stop_search) or (not Windows.FindNextFile(h,f));

   Windows.FindClose(h);
  end;
end;

function TSearchFilesForm.IsMatchMasks(const filename,_masks:string):boolean;
var s:string;
    masks:string;
    n:integer;
begin
 Result:=false;

 masks:=_masks+';';
 s:='';
 for n:=1 to length(masks) do
  begin
   if (masks[n]=',') or (masks[n]=';') then
    begin
     s:=trim(s);

     if s<>'' then
      begin
       if IsMatchSingleMask(filename,s) then
        begin
         Result:=true;
         break;
        end;
      end;

     s:='';
    end
   else
    s:=s+masks[n];
  end;
end;

function TSearchFilesForm.IsMatchSingleMask(const filename,mask:string):boolean;
begin
 Result:=false;

 if (filename='') or (mask='') then
  exit;

 if (AnsiCompareText(filename,mask)=0) or
    AnsiContainsText(filename,mask) or
    PathMatchSpec(pchar(filename),pchar(mask)) then
  Result:=true;
end;

procedure TSearchFilesForm.AddFileToListView(const filename:string;var _f:_WIN32_FIND_DATA);
var i:TListItem;
    icon:HICON;
    s:string;
    st:_SYSTEMTIME;
    pfi:PFileInfo;
    is_dir:boolean;
begin
 is_dir:=(_f.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0;

 i:=ListView.Items.Add;

 s:=Copy(filename,length(g_resource_root)+1,length(filename)-length(g_resource_root));
 {if Pos('\',s)=0 then
  i.Caption:=s
 else}
  i.Caption:='\'+s;

 icon:=GetFileIcon(filename);
 i.ImageIndex:=ImageList_AddIcon(ImageList.Handle,icon);
 Windows.DestroyIcon(icon);

 if is_dir then
   i.SubItems.Add('---')
 else
   i.SubItems.Add(GetFileSizeStr(_f.nFileSizeLow,_f.nFileSizeHigh));

 FileTimeToSystemTime(_f.ftLastWriteTime,st);
 i.SubItems.Add(Format('%.2d.%.2d.%.4d %d:%.2d',[st.wDay,st.wMonth,st.wYear,st.wHour,st.wMinute]));

 new(pfi);
 pfi.filename:=filename;
 pfi.is_dir:=is_dir;
 i.Data:=pfi;
end;

function TSearchFilesForm.GetFileIcon(const s:string):HICON;
var info:SHFILEINFO;
begin
 Result:=0;
 if SHGetFileInfo(pchar(s),0,info,sizeof(info),SHGFI_ICON or SHGFI_SMALLICON)<>0 then
  Result:=info.hIcon;
 if Result=0 then
  Result:=CopyIcon(LoadIcon(0,IDI_APPLICATION));
end;

function TSearchFilesForm.GetFileSizeStr(low,high:cardinal):string;
var i:int64;
begin
 i:=(int64(high) shl 32) or low;

 if i < 1024 then
  Result:=Format('%d B',[cardinal(i)])
 else
 if i < 1024*1024 then
  Result:=Format('%d KB',[cardinal(i div 1024)])
 else
 if i < 1024*1024*10 then
  Result:=Format('%.2f MB',[i/(1024*1024)])
 else
 if i < 1024*1024*100 then
  Result:=Format('%.1f MB',[i/(1024*1024)])
 else
 if i < 1024*1024*1000 then
  Result:=Format('%d MB',[cardinal(i div (1024*1024))])
 else
  Result:=Format('%.2f GB',[i/(1024*1024*1000)])
end;

function TSearchFilesForm.CreateSelectedList(include_dirs:boolean):TStringList;
var n:integer;
    list:TStringList;
    i:PFileInfo;
begin
 list:=TStringList.Create;

 for n:=0 to ListView.Items.Count-1 do
  begin
   if ListView.Items[n].Selected then
    begin
     i:=PFileInfo(ListView.Items[n].Data);
     if i<>nil then
      begin
       if (not i.is_dir) or include_dirs then
        list.Add(i.filename);
      end;
    end;
  end;

 Result:=list;
end;

procedure TSearchFilesForm.EditMasksKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
  if ButtonStartStop.Enabled then
   ButtonStartStopClick(Sender);
end;


end.
