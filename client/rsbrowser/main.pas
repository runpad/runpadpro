unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, ExtCtrls, Registry, Dropper,
  Buttons, ImgList, ToolWin, Menus, Search;

type
  TRSFolderBrowserForm = class(TForm)
    ImageList: TImageList;
    Splitter1: TSplitter;
    ShellTreeView: TShellTreeView;
    Panel1: TPanel;
    ShellListView: TShellListView;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    tbWinAmp: TToolButton;
    ToolButton1: TToolButton;
    tbBurn: TToolButton;
    ToolButton2: TToolButton;
    tbBT: TToolButton;
    PopupMenu: TPopupMenu;
    MenuWinamp: TMenuItem;
    MenuBurn: TMenuItem;
    MenuBT: TMenuItem;
    N1: TMenuItem;
    MenuCopy: TMenuItem;
    N2: TMenuItem;
    MenuSelectAll: TMenuItem;
    ToolButton3: TToolButton;
    tbSearch: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ShellTreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure DropperDropUp(var Files: TStringList);
    procedure DropperCheckTargetWindow(var Allow: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbWinampClick(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure tbBurnClick(Sender: TObject);
    procedure tbBTClick(Sender: TObject);
    procedure ShellListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ShellListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShellListViewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ShellListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ShellListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShellListViewDblClick(Sender: TObject);
    procedure ShellListViewColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure MenuWinampClick(Sender: TObject);
    procedure MenuBurnClick(Sender: TObject);
    procedure MenuBTClick(Sender: TObject);
    procedure MenuCopyClick(Sender: TObject);
    procedure MenuSelectAllClick(Sender: TObject);
    procedure tbSearchClick(Sender: TObject);
  private
    Dropper: TDropper;
    MouseDownX, MouseDownY: integer;
    run_sheet_name:string;
    disallow_copy_from_folder : boolean;
    { Private declarations }
    procedure RunBodyToolWithParms(tool,parms:string);
    function IsWinampFile(PathName: string): boolean;
    function GetWinampPath:string;
    procedure ShellListViewSortBy(idx:integer);
    function SearchFileOpFunc(wnd:HWND;cmd:TSearchFileOp;const list:TStringList):boolean;
    function GoToRandomFileInsideRoot(const filename:string):boolean;
  public
    { Public declarations }
  end;

var
  RSFolderBrowserForm: TRSFolderBrowserForm;

implementation

uses commctrl, clipbrd;

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

var
   g_SortColumn : integer = -1;


procedure TRSFolderBrowserForm.DropperCheckTargetWindow(var Allow: Boolean);
var
  wnd, old_wnd : HWND;
  p   : TPoint;
  s   : array[0..200]of Char;
  reg : TRegistry;
  allow_from_cfg : boolean;
begin

  allow_from_cfg := true;
  reg := TRegistry.Create;
  if reg.OpenKeyReadOnly('Software\RunpadProShell') then
    begin
      try
        allow_from_cfg := reg.ReadBool('allow_drag_anywhere');
      except end;
      reg.CloseKey;
    end;
  reg.Free;

  GetCursorPos(p);
  wnd := WindowFromPoint(p);

  while (wnd <> 0) and (wnd <> GetDesktopWindow()) and (wnd <> Handle) do
    begin
      if (GetClassName(wnd, @s, sizeof(s)) > 0) then
        begin
          if ((s = 'TBodyExplForm') and (not disallow_copy_from_folder)) or 
             (s = 'Winamp v1.x') or (s = 'MediaPlayerClassicW') or (s = 'MediaPlayerClassicA') or 
             (s = 'MediaPlayerClassic') or (s = 'TBodyBurnForm') or 
             ((s = 'TBodyMailForm') and (not disallow_copy_from_folder)) then
            begin
              Allow := True;
              exit;
            end;
        end;
      old_wnd := wnd;
      wnd := GetParent(old_wnd);
      if wnd=0 then
        wnd := GetWindow(old_wnd,GW_OWNER);
    end;

  if (wnd<>Handle) and allow_from_cfg then
   Allow := true
  else
   Allow := false
end;


function TRSFolderBrowserForm.IsWinampFile(PathName: string): boolean;
var s,ext:string;
    reg:TRegistry;
begin
 Result:=false;

 if DirectoryExists(PathName) then
  begin
   Result:=true;
   exit;
  end;

 ext:=ExtractFileExt(PathName);

 if ext='' then
   exit;

 s:='';
 reg:=TRegistry.Create;
 reg.RootKey:=HKEY_CLASSES_ROOT;
 if reg.OpenKeyReadOnly(ext) then
  begin
   try
    s:=reg.ReadString('');
   except end;
   reg.CloseKey;
  end;
 reg.Free;

 if s<>'' then
  begin
   if length(s) >= 6 then
    begin
     if length(s)>6 then
      setlength(s,6);
     if UpperCase(s) = 'WINAMP' then
      Result:=true;
    end;
  end;
end;


function TRSFolderBrowserForm.GetWinampPath:string;
var reg:TRegistry;
    s:string;
begin
 s:='C:\Program Files\Winamp';
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\Winamp') then
  begin
   try
    s:=reg.ReadString('');
   except end;
   reg.CloseKey;
  end;
 reg.Free;

 if s='' then
  s:='C:\Program Files\Winamp';

 s:=IncludeTrailingPathDelimiter(s)+'winamp.exe';

 if not FileExists(s) then
  s:='';

 Result:=s;
end;


procedure TRSFolderBrowserForm.RunBodyToolWithParms(tool,parms:string);
var s,command:string;
begin
 Command := ExtractFileDir(ParamStr(0));
 if (Command<>'') then
  begin
   Command := IncludeTrailingPathDelimiter(Command) + tool + '.exe';
   s:='"' + Command + '"';
   if parms<>'' then
    begin
     if parms[1]<>' ' then
      s:=s+' ';
     s:=s+parms;
    end;
   RunProcess(PChar(s));
  end;
end;


procedure TRSFolderBrowserForm.FormCreate(Sender: TObject);
var w : HWND;
    atom : integer;
    buf : array[0..256] of char;
    reg : TRegistry;
    allow_burn : boolean;
    allow_bt : boolean;
begin
// try
//   CoolBar.Bitmap.LoadFromFile(ExtractFilePath(Application.ExeName)+'default_skin.bmp');
// except end;

 Caption:=LS(800);
 tbWinamp.Caption:=LS(801);
 tbBurn.Caption:=LS(802);
 tbBT.Caption:=LS(803);
 tbSearch.Caption:=LS(1433);
 MenuWinamp.Caption:=LS(801);
 MenuBurn.Caption:=LS(802);
 MenuBT.Caption:=LS(803);
 MenuCopy.Caption:=LS(807);
 MenuSelectAll.Caption:=LS(808);

 Application.Title:=Caption;

 SetWindowLong(ShellListView.Handle,GWL_STYLE,GetWindowLong(ShellListView.Handle,GWL_STYLE) and (not LVS_EDITLABELS));

 Dropper:=TDropper.Create(Self);
 Dropper.Enabled := True;
 Dropper.OnDropUp := DropperDropUp;
 Dropper.OnDropCheck := DropperCheckTargetWindow;

 disallow_copy_from_folder:=false;
 allow_burn:=true;
 allow_bt:=true;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell') then
  begin
   try
    allow_burn := reg.ReadBool('burn_integration');
   except end;
   try
    allow_bt := reg.ReadBool('bt_integration');
   except end;
   try
    disallow_copy_from_folder := reg.ReadBool('disallow_copy_from_lnkfolder');
   except end;
   reg.CloseKey;
  end;
 reg.Free;

 tbBurn.Enabled:=allow_burn;
 MenuBurn.Enabled:=allow_burn;
 tbBT.Enabled:=allow_bt;
 MenuBT.Enabled:=allow_bt;

 buf[0]:=#0;
 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
  begin
   atom:=SendMessage(w,WM_USER+143,0,0);
   if atom<>0 then
    begin
     GlobalGetAtomName(atom,buf,255);
     GlobalDeleteAtom(atom);
    end;
  end;
 run_sheet_name:=buf;
 if run_sheet_name='' then
  run_sheet_name:='_';

 try
  ShellTreeView.Root:=ParamStr(1);
  ShellTreeView.Selected:=nil;
  ShellListView.Selected:=nil;
 except
  MessageBox(0,LSP(809),LSP(LS_ERR),MB_OK or MB_ICONERROR);
  ExitProcess(0);
 end;
end;


procedure TRSFolderBrowserForm.FormDestroy(Sender: TObject);
begin
 Dropper.Free;
end;


procedure TRSFolderBrowserForm.FormShow(Sender: TObject);
begin
 Panel1.SetFocus;
end;


procedure TRSFolderBrowserForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#27 then
  Close;
end;


procedure TRSFolderBrowserForm.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
 MinWidth:=300;
 MinHeight:=200;
end;


procedure TRSFolderBrowserForm.ShellTreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;


procedure TRSFolderBrowserForm.ShellListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;


procedure TRSFolderBrowserForm.ShellListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDownX := X;
  MouseDownY := Y;
end;


procedure TRSFolderBrowserForm.ShellListViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (abs(MouseDownX-X)+abs(MouseDownY-Y)>10) then
    if ShellListView.SelectedFolder<>nil then
      Dropper.StartDrag;
end;


procedure TRSFolderBrowserForm.ShellListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var p:TPoint;
begin
 Handled:=TRUE;

 MenuCopy.Enabled:=ShellListView.Selected<>nil;

 GetCursorPos(p);
 PopupMenu.Popup(p.X,p.Y);
end;


procedure TRSFolderBrowserForm.DropperDropUp(var Files: TStringList);
var i:integer;
begin
  if ShellListView.SelectedFolder<>nil then
   begin
    for i:=0 to ShellListView.Items.Count - 1 do
     if ShellListView.Items[i].Selected then
       Files.Add(ShellListView.Folders[i].PathName);
   end;
end;


procedure TRSFolderBrowserForm.ShellListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ShellListView.IsEditing then
    exit;

  if Shift = [ssCtrl] then
    begin
      if Key = Ord('C') then
        MenuCopyClick(Sender);
      if Key = Ord('A') then
        MenuSelectAllClick(Sender);
    end;

  if (Shift = []) and (Key=VK_RETURN) then
    ShellListViewDblClick(Sender);

  // Catch TShellListView BUG
  if (Key >= Ord('A')) and (Key <= Ord('Z')) then
    if ShellListView.Selected = nil then
      Key := 255;
end;


procedure TRSFolderBrowserForm.ShellListViewDblClick(Sender: TObject);
var p:pchar;
    f,w:HWND;
    id,atom,atom2:integer;
begin
 if (ShellListView.SelectedFolder<>nil) and (ShellListView.SelCount=1) then
  begin
   if not ShellListView.SelectedFolder.IsFolder then
    begin
     p:=pchar(ShellListView.SelectedFolder.PathName);
     w:=FindWindow('_RunpadClass',nil);
     if w<>0 then
      begin
       f:=FindWindow('Shell_TrayWnd',nil);
       if f<>0 then
        begin
         id:=GetWindowThreadProcessId(f,nil);
         AttachThreadInput(id,GetCurrentThreadId(),TRUE);
         SetForegroundWindow(f);
         AttachThreadInput(id,GetCurrentThreadId(),FALSE);
        end;

       atom:=GlobalAddAtom(p);
       atom2:=GlobalAddAtom(pchar(run_sheet_name));

       PostMessage(w,WM_USER+118,atom,atom2);
      end;
    end
   else
    begin
     ShellListView.SetPathFromID(ShellListView.SelectedFolder.AbsoluteID);
    end;
  end;
end;

function S_ShellCompare(Item1, Item2: Pointer): Integer;
begin
  Result:=0;

 try
  if (item1=nil) or (item2=nil) then
    Result:=0
  else
   Result := Smallint(
      TShellFolder(Item1).ParentShellFolder.CompareIDs(
      g_SortColumn,
      TShellFolder(Item1).RelativeID,
      TShellFolder(Item2).RelativeID) );
  except
  end;    
end;

procedure TRSFolderBrowserForm.ShellListViewSortBy(idx:integer);
begin
  g_SortColumn := idx;
  ShellListView.ClearSelection;
  ShellListView.SortCurrentView(S_ShellCompare);
end;

procedure TRSFolderBrowserForm.ShellListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
 ShellListViewSortBy(Column.Index);
end;



procedure TRSFolderBrowserForm.tbWinampClick(Sender: TObject);
var s,wpath:string;
    i:integer;
    s_info,s1,s2:pchar;
begin
 wpath:=GetWinampPath();
 if wpath='' then
  exit;

 s_info:=LSP(LS_INFO);
 s1:=LSP(810);
 s2:=LSP(811);

 if ShellListView.SelectedFolder<>nil then
  begin
   s:='';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     if IsWinampFile(ShellListView.Folders[i].PathName) then
       s:=s+' "'+ShellListView.Folders[i].PathName+'"';
   if s<>'' then
    begin
     s:='"'+wpath+'" /ADD'+s;
     WinExec(pchar(s),SW_NORMAL);
    end
   else
    MessageBox(Handle,s1,s_info,MB_OK or MB_ICONINFORMATION);
  end
 else
   MessageBox(Handle,s2,s_info,MB_OK or MB_ICONINFORMATION);
end;


procedure TRSFolderBrowserForm.tbBurnClick(Sender: TObject);
var s:string;
    i:integer;
    s_info,s1:pchar;
begin
 s_info:=LSP(LS_INFO);
 s1:=LSP(812);

 if ShellListView.SelectedFolder<>nil then
  begin
   s:='';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     s:=s+' "'+ShellListView.Folders[i].PathName+'"';
   RunBodyToolWithParms('bodyburn',s);
  end
 else
   MessageBox(Handle,s1,s_info,MB_OK or MB_ICONINFORMATION);
end;


procedure TRSFolderBrowserForm.tbBTClick(Sender: TObject);
var s:string;
    i:integer;
    s_info,s1,s2:pchar;
begin
 s_info:=LSP(LS_INFO);
 s1:=LSP(813);
 s2:=LSP(814);

 if ShellListView.SelectedFolder<>nil then
  begin
   s:='-send';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     begin
      if not ShellListView.Folders[i].IsFolder then
       s:=s+' "'+ShellListView.Folders[i].PathName+'"'
      else
       begin
        MessageBox(Handle,s1,s_info,MB_OK or MB_ICONINFORMATION);
        exit;
       end;
     end;
   RunBodyToolWithParms('bodybt',s);
  end
 else
   MessageBox(Handle,s2,s_info,MB_OK or MB_ICONINFORMATION);
end;


procedure TRSFolderBrowserForm.MenuWinampClick(Sender: TObject);
begin
 tbWinampClick(sender);
end;


procedure TRSFolderBrowserForm.MenuBurnClick(Sender: TObject);
begin
 tbBurnClick(sender);
end;


procedure TRSFolderBrowserForm.MenuBTClick(Sender: TObject);
begin
 tbBTClick(sender);
end;


procedure TRSFolderBrowserForm.MenuCopyClick(Sender: TObject);
var
  DropInfo: TDragDropInfo;
  i: integer;
  p: TPoint;
begin
  if ShellListView.SelCount > 0 then
    begin
      if disallow_copy_from_folder then
       begin
        MessageBox(handle,LSP(815),LSP(LS_WARN),MB_OK or MB_ICONWARNING);
       end
      else
       begin
        p.X := 0;
        p.Y := 0;
        DropInfo := TDragDropInfo.Create(p, false);

        if ShellListView.SelCount = 1 then
          DropInfo.Add(ShellListView.SelectedFolder.PathName)
        else
          for i:=0 to ShellListView.Items.Count - 1 do
            if ShellListView.Items[i].Selected then
              DropInfo.Add(ShellListView.Folders[i].PathName);

        Clipboard.Open;
        Clipboard.Clear;
        Clipboard.SetAsHandle(CF_HDROP, DropInfo.CreateHDrop);
        Clipboard.Close;

        DropInfo.Free;
       end;
    end;
end;


procedure TRSFolderBrowserForm.MenuSelectAllClick(Sender: TObject);
begin
 ShellListView.SelectAll;
end;


procedure TRSFolderBrowserForm.tbSearchClick(Sender: TObject);
var s_root,s_from,goto_dir,goto_file,filename:string;
begin
 s_root:=IncludeTrailingPathdelimiter(ShellTreeView.Root);
 s_from:=IncludeTrailingPathdelimiter(ShellListView.RootFolder.PathName);

 filename:=ShowSearchFilesFormModal('',s_root,s_from,SearchFileOpFunc);
 if filename<>'' then
  begin
   if DirectoryExists(filename) then
    begin
     goto_dir:=filename;
     goto_file:='';
    end
   else
    begin
     goto_dir:=ExtractFilePath(filename);
     goto_file:=ExtractFileName(filename);
    end;

   goto_dir:=IncludeTrailingPathDelimiter(goto_dir);

   if goto_dir<>'' then
    begin
     try
      ShellTreeView.Path:=goto_dir;
      if goto_file<>'' then
       GoToRandomFileInsideRoot(goto_file);
     except
     end;
    end;
  end;
end;


function TRSFolderBrowserForm.GoToRandomFileInsideRoot(const filename:string):boolean;
var n:integer;
begin
 Result:=false;

 for n:=0 to ShellListView.Items.Count-1 do
  if AnsiCompareText(ExtractFileName(ShellListView.Folders[n].PathName),ExtractFileName(filename))=0 then
   begin
    try
     try
      ShellListView.SetFocus;
     except end;
     ShellListView.Selected:=nil;
     ShellListView.Items[n].Selected:=true;
     try
      ShellListView.Items[n].Focused:=true;
     except end;
     ShellListView.Items[n].MakeVisible(false);
     ShellListView.Repaint;
    except end;
    Result:=true;
    break;
   end;
end;

function TRSFolderBrowserForm.SearchFileOpFunc(wnd:HWND;cmd:TSearchFileOp;const list:TStringList):boolean;
begin
 Result:=false;
 
 if (list<>nil) and (list.count>0) then
  begin
   if cmd=sfop_exec then
    begin
     //ExecFileInternal(list[0]);
     Result:=true;
    end
   else
   if cmd=sfop_copy then
    begin
     //MenuCopyClickInternal(wnd,list);
     Result:=true;
    end;
  end;
end;


end.
