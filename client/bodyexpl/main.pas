unit main;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Menus, ShellApi, StdCtrls,
  Buttons, Registry, Clipbrd, Dropper, ImgList, CommCtrl, ToolWin,
  Archive, Extract, InProgress, ShellCtrls, SelfExt, Search;


type
  TBodyExplForm = class(TForm)
    ShellPopupMenu: TPopupMenu;
    MenuDel: TMenuItem;
    MenuRename: TMenuItem;
    N4: TMenuItem;
    MenuCopyToFlash: TMenuItem;
    N2: TMenuItem;
    MenuCopyPath: TMenuItem;
    N1: TMenuItem;
    MenuOpen: TMenuItem;
    MenuCopyTo: TMenuItem;
    MenuCopyFrom: TMenuItem;
    MenuCreateFolder: TMenuItem;
    ImageList: TImageList;
    ImageListBig: TImageList;
    N3: TMenuItem;
    MenuCopy: TMenuItem;
    MenuPaste: TMenuItem;
    ImageListTB: TImageList;
    PopupMenuView: TPopupMenu;
    MenuViewIconic: TMenuItem;
    MenuViewTable: TMenuItem;
    MenuViewList: TMenuItem;
    MenuRar: TMenuItem;
    MenuDirSize: TMenuItem;
    PopupMenu: TPopupMenu;
    MenuOpenMain: TMenuItem;
    MenuFormat: TMenuItem;
    MenuEject: TMenuItem;
    N5: TMenuItem;
    StatusBar: TStatusBar;
    ShellTreeView: TShellTreeView;
    Splitter: TSplitter;
    PopupMenuTree: TPopupMenu;
    MenuWinampAdd: TMenuItem;
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    BtnNew: TToolButton;
    TB1: TToolButton;
    BtnUp: TToolButton;
    BtnRefresh: TToolButton;
    TB2: TToolButton;
    BtnView: TToolButton;
    ComboBox: TComboBoxEx;
    MenuViewThumbnail: TMenuItem;
    MenuOpenWith: TMenuItem;
    MenuDVD: TMenuItem;
    MenuSelectAll: TMenuItem;
    ToolButton1: TToolButton;
    BtnBurn: TToolButton;
    N6: TMenuItem;
    MenuBurn: TMenuItem;
    MenuCreateWith: TMenuItem;
    N7: TMenuItem;
    MenuFreeSpace: TMenuItem;
    ToolButton3: TToolButton;
    BtnBTOut: TToolButton;
    BtnBTIn: TToolButton;
    MenuBTOut: TMenuItem;
    MenuBTIn: TMenuItem;
    MenuCut: TMenuItem;
    N8: TMenuItem;
    BtnMobile: TToolButton;
    MenuMail: TMenuItem;
    ToolButton4: TToolButton;
    BtnMail: TToolButton;
    ToolButton2: TToolButton;
    BtnCamera: TToolButton;
    MenuRotateCW: TMenuItem;
    MenuRotateCCW: TMenuItem;
    N9: TMenuItem;
    MenuResizeSmall: TMenuItem;
    MenuResizeNormal: TMenuItem;
    MenuResizeBig: TMenuItem;
    N10: TMenuItem;
    MenuConvertJPEG: TMenuItem;
    MenuConvertBMP: TMenuItem;
    MenuConvertTIFF: TMenuItem;
    MenuConvertPNG: TMenuItem;
    MenuConvertGIF: TMenuItem;
    MenuPicture: TMenuItem;
    Panel1: TPanel;
    CoolBar2: TCoolBar;
    ToolBar2: TToolBar;
    BtnSearch: TToolButton;
    ShellListView: TShellListView;
    ListView: TListView;
    MenuSort: TMenuItem;
    MenuSortByName: TMenuItem;
    MenuSortBySize: TMenuItem;
    MenuSortByType: TMenuItem;
    MenuSortByDate: TMenuItem;
    procedure ShellListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuRenameClick(Sender: TObject);
    procedure MenuDelClick(Sender: TObject);
    function MenuDelClickInternal(wnd:HWND=0;const list:TStringList=nil):boolean;
    procedure FormCreate(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure MenuCopyPathClick(Sender: TObject);
    procedure MenuCopyToFlashClick(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
    procedure ShellListViewDblClick(Sender: TObject);
    procedure BtnUpClick(Sender: TObject);
    procedure ShellListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuExtClick(Sender:TObject);
    procedure MenuExtRevClick(Sender:TObject);
    procedure CopyTo(src,dest:string);
    function CreateFileCopy(const orig:string):boolean;
    function MultiCopyTo(src,dest:PChar):boolean;
    function MultiMoveTo(src,dest:PChar):boolean;
    function MultiDelete(const src: PChar;use_recycle:boolean):boolean;
    procedure FormDestroy(Sender: TObject);
    procedure ShellListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShellListViewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ShellListViewColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure BtnNewClick(Sender: TObject);
    procedure MenuCreateFolderClick(Sender: TObject);
    procedure ComboBoxSelect(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure MenuCopyClick(Sender: TObject);
    procedure MenuCopyClickInternal(wnd:HWND=0;const list:TStringList=nil);
    procedure MenuCutClickInternal(wnd:HWND=0;const list:TStringList=nil);
    procedure MenuPasteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShellChangeNotifierChange;
    procedure MenuViewIconicClick(Sender: TObject);
    procedure MenuViewTableClick(Sender: TObject);
    procedure BtnViewClick(Sender: TObject);
    procedure MenuViewListClick(Sender: TObject);
    procedure MenuRarClick(Sender: TObject);
    procedure MenuDirSizeClick(Sender: TObject);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ShellListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuOpenMainClick(Sender: TObject);
    procedure MenuEjectClick(Sender: TObject);
    procedure MenuFormatClick(Sender: TObject);
    procedure ShellListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ShellTreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure ShellTreeViewClick(Sender: TObject);
    procedure ShellTreeViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopupMenuTreePopup(Sender: TObject);
    procedure MenuWinampAddClick(Sender: TObject);
    procedure MenuViewThumbnailClick(Sender: TObject);
    procedure MenuOpenWithClick(Sender: TObject);
    procedure MenuCreateWithClick(Sender: TObject);
    function GetCreateWithCount:integer;
    function GetCreateWithName(idx:integer):string;
    procedure CreateWithHL(idx:integer);
    procedure LoadMenuCreateWith;
   
    procedure MenuDVDClick(Sender: TObject);
    procedure MenuSelectAllClick(Sender: TObject);
    procedure BtnBurnClick(Sender: TObject);
    procedure MenuBurnClick(Sender: TObject);
    procedure MenuFreeSpaceClick(Sender: TObject);
    procedure BtnBTOutClick(Sender: TObject);
    procedure BtnBTInClick(Sender: TObject);
    procedure MenuBTOutClick(Sender: TObject);
    procedure MenuBTInClick(Sender: TObject);
    procedure MenuCutClick(Sender: TObject);
    procedure MenuMailClick(Sender: TObject);
    procedure BtnMailClick(Sender: TObject);
    procedure BtnMobileClick(Sender: TObject);
    procedure BtnCameraClick(Sender: TObject);
    procedure MenuRotateCWClick(Sender: TObject);
    procedure MenuRotateCCWClick(Sender: TObject);
    procedure MenuResizeSmallClick(Sender: TObject);
    procedure MenuResizeNormalClick(Sender: TObject);
    procedure MenuResizeBigClick(Sender: TObject);
    procedure MenuConvertJPEGClick(Sender: TObject);
    procedure MenuConvertBMPClick(Sender: TObject);
    procedure MenuConvertTIFFClick(Sender: TObject);
    procedure MenuConvertPNGClick(Sender: TObject);
    procedure MenuConvertGIFClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure MenuSortByNameClick(Sender: TObject);
    procedure MenuSortBySizeClick(Sender: TObject);
    procedure MenuSortByTypeClick(Sender: TObject);
    procedure MenuSortByDateClick(Sender: TObject);
  private
    ShellChangeNotifier: TShellChangeNotifier;
    Dropper: TDropper;
    MouseDownX, MouseDownY: integer;
    Title: string;
    use_recycle_bin : boolean;

    procedure ShellListViewSortBy(idx:integer);

    procedure DropperDropUp(var Files: TStringList);
    procedure DropperCheckTargetWindow(var Allow: Boolean);
    procedure WMDropFiles(var M: TWMDropFiles);message WM_DROPFILES;
    procedure AllocSelectedFolderNames(var buf: pchar;const list:TStringList=nil);
    procedure ReleaseSelectedFolderNames(var buf: pchar);
    function AcceptFiles(hDrop: THandle; delfiles:boolean):boolean;

    procedure Rar(RARFile: string; Split144: boolean);
    procedure UnRar(RARFile: string; Directory: string; Password: string);

    procedure InitComboBox();
    procedure InitListView();
    procedure ExploreHere(s: string);
    procedure ExploreDefault;
    function GoToRandomPathInsideGlobalRoot(const _Path:string):boolean;
    function GoToRandomFileInsideRoot(const filename:string):boolean;
    function GetExploringPlace(): string;
    function GetExploringPath(): string;
    procedure SetFocusOnList;

    procedure LoadMenuOpenWith;

    function GetWinRarPath:string;
    function GetWinRarExt:string;
    function UniqueArchiveName(folder,name,ext: string): string;

    function IsRemovableMedia: boolean;
    function AllowWriteToRemovableMedia: boolean;
    function WriteToRemovableMediaExclamination(RemovableMediaDestination: boolean): boolean;

    procedure SetTitle;
    procedure UpdateStatusBar;
    procedure RunBodyToolWithParms(tool,parms:string);
    function PathEqu(s1,s2:string):boolean;
    function GetDriveFreeSpaceStr(dir:string):string;

    procedure MenuCopyInternal(fmt:integer;const list:TStringList=nil);

    procedure NotifyAboutFlashDriveChange(typ:integer;path:string);
    procedure OnLanguageChanged();

    function IsOnlyImagesSelected:boolean;
    procedure Action4Images(action:integer;const postfix,new_ext:string);
    function CheckAccess(a:integer;wnd:HWND=0):boolean;
    function SearchFileOpFunc(wnd:HWND;cmd:TSearchFileOp;const list:TStringList):boolean;
    procedure ExecFileInternal(const filename:string);
  public
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

const MAXWINITEMS = 200; // must be like in rshell!!!

var
  BodyExplForm: TBodyExplForm;
  PathLevel: integer;
  menu_ext : array [0..MAXWINITEMS-1] of string;
  menu_ext_rev : array [0..MAXWINITEMS-1] of string;

  vip_begin_message: THandle;
  vip_end_message: THandle;
  msg_langchanged : cardinal;
  cf_cut : integer;


function DeleteFileOrFolder(path: string): Boolean;
function DeleteFolderContent(path: string): Boolean;


implementation

uses
  ComObj, StrUtils, CreateFolder, RenameFileOrFolder, VistaAltFixUnit;

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}
{$INCLUDE bodyexpl.inc}


const SHFMT_ERROR     = $FFFFFFFF;     // Error on last format, drive may be formatable
const SHFMT_CANCEL    = $FFFFFFFE;     // Last format was canceled
const SHFMT_NOFORMAT  = $FFFFFFFD;     // Drive is not formatable

const ACC_COPY    = 1;
const ACC_DELETE  = 2;
const ACC_WRITE   = 3;

const FLASH_NOTIFY_FORMAT = 0;
const FLASH_NOTIFY_ADD    = 1;
const FLASH_NOTIFY_DELETE = 2;

var
  SNone : string = '';
  SDiskette : string = '$diskette';
  SFlash : string = '$flash';
  SCdrom : string = '$cdrom';
  SVipFolder : string = '$vipfolder';
  SUserFolder : string = '$userfolder';
  SExFolder : string = '$exfolder';
  IDiskette : integer = -20;
  IFlash : integer = -20;
  ICdrom : integer = -20;
  IVipFolder : integer = -20;
  IUserFolder : integer = -20;
  IExFolder : integer = -20;
  buf : array [0..MAX_PATH-1] of char;
  g_sortcolumn : integer = -1;


procedure TBodyExplForm.OnLanguageChanged();
begin
   BtnNew.Hint:=                     LS(1327);
   BtnUp.Hint:=                      LS(1328);
   BtnRefresh.Hint:=                 LS(1329);
   BtnView.Hint:=                    LS(1330);
   BtnBurn.Hint:=                    LS(1331);
   BtnBTOut.Hint:=                   LS(1332);
   BtnBTIn.Hint:=                    LS(1333);
   BtnMobile.Hint:=                  LS(1334);
   BtnMail.Hint:=                    LS(1335);
   BtnCamera.Hint:=                  LS(1407);
   BtnSearch.Hint:=                  LS(1433);
   MenuViewIconic.Caption:=          LS(1336);
   MenuViewList.Caption:=            LS(1337);
   MenuViewTable.Caption:=           LS(1338);
   MenuViewThumbnail.Caption:=       LS(1339);
   MenuOpenMain.Caption:=            LS(1340);
   MenuDVD.Caption:=                 LS(1341);
   MenuEject.Caption:=               LS(1342);
   MenuFormat.Caption:=              LS(1343);
   MenuFreeSpace.Caption:=           LS(1344);
   MenuOpen.Caption:=                LS(1345);
   MenuOpenWith.Caption:=            LS(1346);
   MenuWinampAdd.Caption:=           LS(1347);
   MenuCopyPath.Caption:=            LS(1348);
   MenuDirSize.Caption:=             LS(1349);
   MenuCreateFolder.Caption:=        LS(1350);
   MenuCreateWith.Caption:=          LS(1351);
   MenuCopy.Caption:=                LS(1352);
   MenuCut.Caption:=                 LS(1353);
   MenuPaste.Caption:=               LS(1354);
   MenuSelectAll.Caption:=           LS(1355);
   MenuRar.Caption:=                 LS(1356);
   MenuDel.Caption:=                 LS(1357);
   MenuRename.Caption:=              LS(1358);
   MenuCopyToFlash.Caption:=         LS(1359);
   MenuCopyTo.Caption:=              LS(1360);
   MenuCopyFrom.Caption:=            LS(1361);
   MenuBurn.Caption:=                LS(1362);
   MenuMail.Caption:=                LS(1363);
   MenuBTOut.Caption:=               LS(1364);
   MenuBTIn.Caption:=                LS(1365);
   MenuPicture.Caption:=             LS(1408);
   MenuRotateCW.Caption:=            LS(1409);
   MenuRotateCCW.Caption:=           LS(1410);
   MenuResizeSmall.Caption:=         LS(1411)+' 640x480';
   MenuResizeNormal.Caption:=        LS(1411)+' 800x600';
   MenuResizeBig.Caption:=           LS(1411)+' 1024x768';
   MenuConvertJPEG.Caption:=         LS(1412)+' JPEG';
   MenuConvertBMP.Caption:=          LS(1412)+' BMP';
   MenuConvertTIFF.Caption:=         LS(1412)+' TIFF';
   MenuConvertPNG.Caption:=          LS(1412)+' PNG';
   MenuConvertGIF.Caption:=          LS(1412)+' GIF';
   MenuSort.Caption:=                LS(1434);
   MenuSortByName.Caption:=          LS(1435);
   MenuSortBySize.Caption:=          LS(1436);
   MenuSortByType.Caption:=          LS(1437);
   MenuSortByDate.Caption:=          LS(1438);
end;


procedure TBodyExplForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=msg_langchanged then
  begin
   MessageBox(handle,LSP(1366),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
   Handled := True;
  end
 else
  begin
    if IVipFolder >= 0 then
     begin
      if Msg.message=vip_begin_message then
        begin
          ComboBox.ItemsEx.Items[IVipFolder].Caption := GetVIPFolderName(@buf);
          ListView.Items[IVipFolder-1].Caption := GetVIPFolderName(@buf);
          Handled := True;
        end
      else if Msg.message=vip_end_message then
        begin
          ComboBox.ItemsEx.Items[IVipFolder].Caption := GetVIPFolderName(@buf);
          ListView.Items[IVipFolder-1].Caption := GetVIPFolderName(@buf);
          if GetExploringPlace = SVipFolder then
            ExploreDefault;
          Handled := True;
        end
     end;
  end;
end;

function GetDestFolderPath:string;
begin
 if BodyExplForm.IsRemovableMedia then
   begin
     Result:=GetVIPFolderPath(@buf);
     if buf[0] = #0 then
       Result:=GetUserFolderPath(@buf,0)
   end
 else
   begin
     if BodyExplForm.AllowWriteToRemovableMedia then 
       begin
         Result:=GetFlashPath(@buf,0);
         if buf[0] = #0 then
           Result:=GetDiskettePath(@buf);
       end
     else
       Result:='';
   end;
end;

function GetDestFolderName:string;
begin
 if BodyExplForm.IsRemovableMedia then
   begin
     GetVIPFolderPath(@buf);
     if buf[0] = #0 then
       Result:=LS(1367)
     else
       Result:=LS(1368);
   end
 else
   begin
     GetFlashPath(@buf,0);
     if buf[0] = #0 then
       Result:=LS(1369)
     else
       Result:=LS(1370);
   end;
end;

function GetNameFromPathName(path: string): string;
var
  i: integer;
  s: string;
begin
  s := path;
  i := Length(s);
  while (i>0) and ((s[i]='\') or (s[i]=':')) do
    begin
      Delete(s, i, 1);
      i := Length(s);
    end;

  while (i>0) and (path[i]<>'\') do
    dec(i);

  if i>0 then
    Delete(s, 1, i);

  Result := s;
end;

function TBodyExplForm.UniqueArchiveName(folder,name,ext: string): string;
var
  i: integer;
  s: string;
begin
  if name='' then
    s := '_0' + Ext
  else
    s := name + Ext;
  i := 1;
  while FileExists(IncludeTrailingPathDelimiter(folder)+s) do
    begin
      s := name + '_' + IntToStr(i) + Ext;
      inc(i);
    end;
  Result := s;
end;


function IsWinampFile(PathName: string): boolean;
var s,ext:string;
    reg:TRegistry;
    n:integer;
begin
 if DirectoryExists(PathName) then
  begin
   Result:=true;
   exit;
  end;
 
 s:=PathName;
 ext:='';
 for n:=length(s) downto 1 do
  if s[n]='.' then
   begin
    ext:=Copy(s,n,length(s)-n+1);
    break;
   end;

 Result:=false;

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


function TBodyExplForm.WriteToRemovableMediaExclamination(RemovableMediaDestination: boolean): boolean;
begin
 if RemovableMediaDestination and not AllowWriteToRemovableMedia then
   begin
     MessageBox(Handle, LSP(1371), LSP(LS_ERROR), MB_OK or MB_ICONERROR);
     Result := true;
   end
 else
   Result := false;
end;


function TBodyExplForm.AllowWriteToRemovableMedia: boolean;
var
  reg: TRegistry;
begin
  Result := true;
  reg := TRegistry.Create;
  if reg.OpenKeyReadOnly('Software\RunpadProShell') then
    begin
      try
        Result := reg.ReadBool('allow_write_to_removable');
      except end;
      reg.CloseKey;
    end;
  reg.Free;
end;

function TBodyExplForm.IsRemovableMedia: boolean;
begin
  Result := 
    ( BodyExplForm.ComboBox.ItemIndex = IFlash ) or
    ( BodyExplForm.ComboBox.ItemIndex = IDiskette ) or
    ( BodyExplForm.ComboBox.ItemIndex = ICdrom );
end;


procedure TBodyExplForm.DropperCheckTargetWindow(var Allow: Boolean);
var
  wnd, new_wnd : HWND;
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

  Allow := true;

  while (wnd <> 0) and (wnd <> GetDesktopWindow()) and (wnd <> Handle) do
    begin
      if (GetClassName(wnd, @s, sizeof(s)) > 0) then
        if (s = 'Winamp v1.x') or (s = 'TBodyExplForm') or (s = 'MediaPlayerClassicW') or (s = 'MediaPlayerClassicA') or (s = 'MediaPlayerClassic') or (s = 'TBodyBurnForm') or (s = 'TBodyMailForm') or (s = '_RSSheetWindowClass') or (s = 'TSaverForm') then
          exit;

      new_wnd := GetParent(wnd);
      if new_wnd = 0 then
        new_wnd := GetWindow(wnd, GW_OWNER);
      wnd := new_wnd;
    end;

  if (wnd<>Handle) and allow_from_cfg then
   Allow := true
  else
   Allow := false
end;


procedure TBodyExplForm.CopyTo(src,dest:string);
var i:TSHFileOpStruct;
    sfrom:array[0..MAX_PATH-1] of char;
    sto:array[0..MAX_PATH-1] of char;
    pfrom,pto:pchar;
begin
   FillChar(sfrom,sizeof(sfrom),0);
   FillChar(sto,sizeof(sto),0);
   pfrom:=@sfrom;
   pto:=@sto;
   StrCopy(pfrom,pchar(src));
   StrCopy(pto,pchar(dest));

   i.Wnd:=Handle;
   i.wFunc:=FO_COPY;
   i.pFrom:=pfrom;
   i.pTo:=pto;
   i.fFlags:=FOF_SIMPLEPROGRESS;
   i.lpszProgressTitle:=LSP(1372);
   SHFileOperation(i);
end;


function TBodyExplForm.MultiCopyTo(src,dest: PChar):boolean;
var
  i:TSHFileOpStruct;
  pto: PChar;
  rc:integer;
begin
   GetMem(pto, StrLen(dest)+2);
   StrCopy(pto, dest);
   (pto+StrLen(dest)+1)^ := #0; // set the second NULL

   i.Wnd:=Handle;
   i.wFunc:=FO_COPY;
   i.pFrom:=src;
   i.pTo:=pto;
   i.fFlags:=FOF_SIMPLEPROGRESS;
   i.lpszProgressTitle:=LSP(1372);
   rc:=SHFileOperation(i);

   FreeMem(pto);

   Result:=(rc=0);
end;


function TBodyExplForm.MultiMoveTo(src,dest: PChar):boolean;
var
  i:TSHFileOpStruct;
  pto: PChar;
  rc:integer;
begin
   GetMem(pto, StrLen(dest)+2);
   StrCopy(pto, dest);
   (pto+StrLen(dest)+1)^ := #0; // set the second NULL

   i.Wnd:=Handle;
   i.wFunc:=FO_MOVE;
   i.pFrom:=src;
   i.pTo:=pto;
   i.fFlags:=FOF_SIMPLEPROGRESS;
   i.lpszProgressTitle:=LSP(1373);
   rc:=SHFileOperation(i);

   FreeMem(pto);

   Result:=(rc=0);
end;


function TBodyExplForm.MultiDelete(const src: PChar;use_recycle:boolean):boolean;
var
  i:TSHFileOpStruct;
begin
   i.Wnd:=Handle;
   i.wFunc:=FO_DELETE;
   i.pFrom:=src;
   i.pTo:=nil;
   i.fFlags:=FOF_SIMPLEPROGRESS or FOF_NOCONFIRMATION;
   if use_recycle then
    i.fFlags:=i.fFlags or FOF_ALLOWUNDO;
   i.lpszProgressTitle:=LSP(1374);
   Result:=(SHFileOperation(i)=0);
end;


procedure TBodyExplForm.AllocSelectedFolderNames(var buf: pchar;const list:TStringList);
var
  p: pchar;
  i: integer;
  memSize: Integer;
begin
  memSize := 0;

  // Count memory needed
  if list=nil then
   begin
    for i:=0 to ShellListView.Items.Count-1 do
      if ShellListView.Items[i].Selected then
        memSize := memSize + length(ShellListView.Folders[i].PathName) + 1;
   end
  else
   begin
    for i:=0 to list.Count-1 do
     memSize := memSize + length(list[i]) + 1;
   end;

  // Allocate memory
  GetMem(buf, memSize+1);
  p := buf;
  p^ := #0;

  // Fill the buffer with selected folder names
  if list=nil then
   begin
    for i:=0 to ShellListView.Items.Count-1 do
      if ShellListView.Items[i].Selected then
        begin
          StrCopy(p, PChar(ShellListView.Folders[i].PathName));
          p := p + StrLen(p) + 1;
          p^ := #0;
        end;
   end
  else
   begin
    for i:=0 to list.Count-1 do
     begin
      StrCopy(p,pchar(list[i]));
      p := p + StrLen(p) + 1;
      p^ := #0;
     end;
   end;
end;

procedure TBodyExplForm.ReleaseSelectedFolderNames(var buf: pchar);
begin
  FreeMem(buf);
  buf:=nil;
end;

procedure TBodyExplForm.SetFocusOnList;
begin
 if ListView.Visible then
   ListView.SetFocus
 else if ShellListView.Visible then
   ShellListView.SetFocus;
end;

procedure TBodyExplForm.MenuExtClick(Sender:TObject);
var item : TMenuItem;
    s,ext,fname,allow,find:string;
    n:integer;
begin
 if ShellListView.SelectedFolder<>nil then
  begin
   if not CheckAccess(ACC_COPY) then
    exit;

   item:=Sender as TMenuItem;
   s:=item.Caption;
   allow:='';
   for n:=length(s) downto 1 do
    if s[n]='(' then
     begin
      allow:=Copy(s,n+1,length(s)-n);
      break;
     end;

   if allow<>'' then
    begin
     if allow[length(allow)]=')' then
      SetLength(allow,length(allow)-1);
     allow:=AnsiLowerCase(allow);

     s:=ShellListView.SelectedFolder.PathName;

     fname:=s;
     for n:=length(s) downto 1 do
      if (s[n]='\') or (s[n]='/') then
       begin
        fname:=Copy(s,n+1,length(s)-n);
        break;
       end;
     fname:=AnsiLowerCase(fname);

     ext:=fname;
     for n:=length(s) downto 1 do
      if s[n]='.' then
       begin
        ext:=Copy(s,n+1,length(s)-n);
        break;
       end;
     ext:=AnsiLowerCase(ext);

     if Pos('.',allow)<>0 then
       find:=fname
     else
       find:=ext;

     if (find='') or (Pos(find,allow)=0) then
      begin
       MessageBox(Handle,pchar(LS(1375)+' "'+allow+'"'),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
       Exit;
      end;
    end;

   CopyTo(ShellListView.SelectedFolder.PathName,menu_ext[item.MenuIndex]);
   MessageBox(Handle,LSP(1376),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
  end;
end;



procedure TBodyExplForm.MenuExtRevClick(Sender:TObject);
var item : TMenuItem;
begin
 item:=Sender as TMenuItem;
 if not WriteToRemovableMediaExclamination(IsRemovableMedia) then
 begin
  if not CheckAccess(ACC_WRITE) then
   exit;

  CopyTo(menu_ext_rev[item.MenuIndex],ShellListView.Root);
  NotifyAboutFlashDriveChange(FLASH_NOTIFY_ADD,ShellListView.Root);
  MessageBox(Handle,LSP(1376),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
  ShellListView.Refresh;
  ShellTreeView.Refresh(ShellTreeView.Items.GetFirstNode);
 end
end;


procedure TBodyExplForm.InitComboBox();
var
  i : integer;
begin
  ImageList.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 5, 1);
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(100)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(101)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(102)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(103)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(104)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(105)));
  ImageList_AddIcon(ImageList.Handle,   LoadIcon(HInstance, PChar(106)));

  ComboBox.ItemsEx.BeginUpdate;

  ComboBox.ItemsEx.AddItem(LS(1377), 0,0, -1, 0, @SNone);

  if IsFlashAllowed() then
   begin
    IFlash := ComboBox.ItemsEx.Count;
    ComboBox.ItemsEx.AddItem(GetFlashName(@buf), 1,1, -1, 1, @SFlash);
   end;

  if IsDisketteAllowed() then
   begin
    IDiskette := ComboBox.ItemsEx.Count;
    ComboBox.ItemsEx.AddItem(GetDisketteName(@buf), 2,2, -1, 1, @SDiskette);
   end;

  if IsCDROMAllowed() then
   begin
    ICdrom := ComboBox.ItemsEx.Count;
    ComboBox.ItemsEx.AddItem(GetCDROMName(@buf), 3,3, -1, 1, @SCdrom);
   end;

  if IsVipFolderAllowed() then
   begin
    IVipFolder := ComboBox.ItemsEx.Count;
    ComboBox.ItemsEx.AddItem(GetVIPFolderName(@buf), 4,4, -1, 1, @SVipFolder);
   end;

  if IsUserFolderAllowed() then
   begin
    IUserFolder := ComboBox.ItemsEx.Count;
    ComboBox.ItemsEx.AddItem(GetUserFolderName(@buf,0), 5,5, -1, 1, @SUserFolder);
    for i := 1 to GetUserFolderRetrospective-1 do
      ComboBox.ItemsEx.AddItem(GetUserFolderName(@buf,i), 5,5, -1, 1, @SUserFolder);
   end;

  if IsAdditionalFoldersAllowed() then
   begin
    IExFolder := ComboBox.ItemsEx.Count;
    for i := 0 to GetAdditionalFoldersCount-1 do
      ComboBox.ItemsEx.AddItem(GetAdditionalFolderName(@buf,i), 6,6, -1, 1, @SExFolder);
   end;

  ComboBox.ItemsEx.EndUpdate;
end;


procedure TBodyExplForm.InitListView();
var
  i : integer;
  Item: TListItem;
begin
  ImageListBig.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 5, 1);
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(100)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(101)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(102)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(103)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(104)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(105)));
  ImageList_AddIcon(ImageListBig.Handle,   LoadIcon(HInstance, PChar(106)));

  ListView.Items.BeginUpdate;

  if IsFlashAllowed() then
   begin
    Item := ListView.Items.Add;
    Item.Caption := GetFlashName(@buf);
    Item.Data := @SFlash;
    Item.ImageIndex := 1;
   end;

  if IsDisketteAllowed() then
   begin
    Item := ListView.Items.Add;
    Item.Caption := GetDisketteName(@buf);
    Item.Data := @SDiskette;
    Item.ImageIndex := 2;
   end;

  if IsCDROMAllowed() then
   begin
    Item := ListView.Items.Add;
    Item.Caption := GetCDROMName(@buf);
    Item.Data := @SCdrom;
    Item.ImageIndex := 3;
   end;

  if IsVipFolderAllowed() then
   begin
    Item := ListView.Items.Add;
    Item.Caption := GetVIPFolderName(@buf);
    Item.Data := @SVipFolder;
    Item.ImageIndex := 4;
   end;

  if IsUserFolderAllowed() then
   begin
    Item := ListView.Items.Add;
    Item.Caption := GetUserFolderName(@buf,0);
    Item.Data := @SUserFolder;
    Item.ImageIndex := 5;
    for i := 1 to GetUserFolderRetrospective-1 do
      begin
        Item := ListView.Items.Add;
        Item.Caption := GetUserFolderName(@buf,i);
        Item.Data := @SUserFolder;
        Item.ImageIndex := 5;
      end;
   end;

  if IsAdditionalFoldersAllowed() then
   begin
    for i := 0 to GetAdditionalFoldersCount-1 do
      begin
        Item := ListView.Items.Add;
        Item.Caption := GetAdditionalFolderName(@buf,i);
        Item.Data := @SExFolder;
        Item.ImageIndex := 6;
      end;
   end;

  ListView.Items.EndUpdate;
end;


procedure TBodyExplForm.ExploreDefault();
var
  hIcon : THandle;
begin
  if ShellChangeNotifier<>nil then
    begin
      ShellChangeNotifier.Free;
      ShellChangeNotifier := nil
    end;
  ListView.Visible := true;
  Splitter.Visible := false;
  ShellListView.Visible := false;
  ShellTreeView.Visible := false;
  CoolBar2.Visible:=false;
  ComboBox.ItemIndex := 0;
  Title := LS(1377);
  Application.Title := Title;
  Caption := Title;
  hIcon := LoadImage(HInstance, PChar(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].ImageIndex + 100), IMAGE_ICON, 16, 16, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_SMALL, hIcon);
  SendMessage(Application.Handle, WM_SETICON, ICON_SMALL, hIcon);
  hIcon := LoadImage(HInstance, PChar(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].ImageIndex + 100), IMAGE_ICON, 32, 32, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_BIG, hIcon);
  SendMessage(Application.Handle, WM_SETICON, ICON_BIG, hIcon);
  DragAcceptFiles(Handle, False);
  UpdateStatusBar;
end;


procedure TBodyExplForm.ExploreHere(s: string);
var
  S_DEFAULT_TITLE : string;
var
  Root, Path: string;
  i, iPathStart : integer;
  n: integer;
  hIcon : THandle;
begin

  S_DEFAULT_TITLE:=LS(1378);
  
  if ShellChangeNotifier<>nil then
    begin
      ShellChangeNotifier.Free;
      ShellChangeNotifier := nil
    end;

  if s='' then
    begin
      ExploreDefault;
      Exit;
    end;

  iPathStart := Pos(':', s);
  if iPathStart = 0 then
    iPathStart := Length(s)+1;
  Path := Copy(s, iPathStart+2, Length(s)-iPathStart-1);
  Root := '';

  if Path<>'' then
    if (Path[Length(Path)]='\') or (Path[Length(Path)]='/') then
      Delete(Path, Length(Path), 1);

  if Path='' then
    PathLevel := 0
  else
    PathLevel := 1;

  for i:=1 to Length(Path) do
    if Path[i] = '\' then
      Inc(PathLevel)
    else if Path[i] = '/' then
      begin
        Path[i] := '\';
        Inc(PathLevel);
      end;

  if (Pos(SFlash, s) = 1) and (IFlash>=0) then
    begin
      Root := GetFlashPath(@buf,Handle);
      Title := GetFlashName(@buf);
      ComboBox.ItemIndex := IFlash;
    end
  else if (Pos(SDiskette, s) = 1) and (IDiskette>=0) then
    begin
      Root := GetDiskettePath(@buf);
      Title := GetDisketteName(@buf);
      ComboBox.ItemIndex := IDiskette;
    end
  else if (Pos(SCdrom, s) = 1) and (ICdrom>=0) then
    begin
      Root := GetCDROMPath(@buf,Handle);
      Title := GetCDROMName(@buf);
      ComboBox.ItemIndex := ICdrom;
    end
  else if (Pos(SVipFolder, s) = 1) and (IVipFolder>=0) then
    begin
      Root := GetVIPFolderPath(@buf);
      Title := GetVIPFolderName(@buf);
      ComboBox.ItemIndex := IVipFolder;
    end
  else if (Pos(SUserFolder, s) = 1) and (IUserFolder>=0) then
    begin
      try
        n := StrToInt(Copy(s, Length(SUserFolder)+1, iPathStart-Length(SUserFolder)-1));
      except
        n := 0;
      end;
      Root := GetUserFolderPath(@buf,n);
      Title := GetUserFolderName(@buf,n);
      if Title = '' then
        Title := SUserFolder + IntToStr(n);
      ComboBox.ItemIndex := IUserFolder + n;
    end
  else if (Pos(SExFolder, s) = 1) and (IExFolder>=0) then
    begin
      try
        n := StrToInt(Copy(s, Length(SExFolder)+1, iPathStart-Length(SExFolder)-1));
      except
        n := 0;
      end;
      Root := GetAdditionalFolderPath(@buf,n);
      Title := GetAdditionalFolderName(@buf,n);
      if Title = '' then
        Title := SExFolder + IntToStr(n);
      ComboBox.ItemIndex := IExFolder + n;
    end
  else
    begin
      Title := s;
    end;

  try
    ShellListView.Root:='';
    ShellTreeView.Root:='';
  except end;

  if Root='' then
    begin
      Application.Title := S_DEFAULT_TITLE;
      Caption := Application.Title;
      if ComboBox.ItemIndex = IVipFolder then
       begin
        MessageBox(Handle,LSP(1379),LSP(LS_WARNING), MB_OK or MB_ICONWARNING);
       end
      else
       begin
        MessageBox(Handle,pchar(Format(LS(1380),[Title])),LSP(LS_WARN),MB_OK or MB_ICONWARNING);
       end;
      ExploreDefault;
      Exit;
    end;

  if Root[Length(Root)]<>'\' then
    Root := Root + '\';
  Path := Root + Path;

  if (Path[Length(Path)]='\') and (Length(Path)>3) then
    Delete(Path, Length(Path), 1);

  try
   ShellTreeView.Root := Root;
  except
   Application.Title := S_DEFAULT_TITLE;
   Caption := Application.Title;
   MessageBox(Handle,pchar(Format(LS(1381),[Root])),LSP(LS_ERR), MB_OK or MB_ICONERROR);
   ExploreDefault;
   Exit;
  end;

  while not PathEqu(ShellListView.Root,Path) do // loop introduced due to bug: Root changed from the second attempt
    try
      ShellListView.Root:=Path;
    except
      Application.Title := S_DEFAULT_TITLE;
      Caption := Application.Title;
      MessageBox(Handle,pchar(Format(LS(1381),[Path])),LSP(LS_ERR), MB_OK or MB_ICONERROR);
      ExploreDefault;
      Exit;
    end;

  try
    ShellChangeNotifier := TShellChangeNotifier.Create(Self);
    ShellChangeNotifier.OnChange := ShellChangeNotifierChange;
    ShellChangeNotifier.Root := Root;//Path;
  except
  end;

  ShellListView.Visible := true;
  ShellTreeView.Visible := true;
  Splitter.Visible := true;
  CoolBar2.Visible:=true;
  ListView.Visible := false;

  SetTitle;
  UpdateStatusBar;

  hIcon := LoadImage(HInstance, PChar(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].ImageIndex + 100), IMAGE_ICON, 16, 16, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_SMALL, hIcon);
  SendMessage(Application.Handle, WM_SETICON, ICON_SMALL, hIcon);
  hIcon := LoadImage(HInstance, PChar(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].ImageIndex + 100), IMAGE_ICON, 32, 32, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_BIG, hIcon);
  SendMessage(Application.Handle, WM_SETICON, ICON_BIG, hIcon);
  DragAcceptFiles(Handle, True);
end;

function TBodyExplForm.GoToRandomPathInsideGlobalRoot(const _Path:string):boolean;
var
  Path : string;
  s: string;
begin
  Path:=_Path;
  Delete(Path, 1, Length(ShellTreeView.Root));

  s := GetExploringPlace;
  if (s<>'') and (not PathEqu(GetExploringPath,Path)) then
  begin
    s := s + ':\' + Path;
    ExploreHere(s);
    Result:=true;
  end
 else
  Result:=s<>'';
end;

function TBodyExplForm.GoToRandomFileInsideRoot(const filename:string):boolean;
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

procedure TBodyExplForm.SetTitle;
var
  s : string;
begin
  s:=GetExploringPath;
  if (s = '') or (s = '\') then
    begin
      Application.Title := Title;
      Caption := Title;
    end
  else
    begin
      Application.Title := '\' + s;
      Caption := '\' + s;
    end
end;


function ObjectsNumberStr(n: integer; selected: boolean): string;
begin
  if (n mod 10 = 1) and (n <> 11)
  then
    Result := IntToStr(n) + ' ' + LS(1382)
  else
    if (n mod 10 in [2..4]) and not (n in [12..14])
    then
      Result := IntToStr(n) + ' ' + LS(1383)
    else
      Result := IntToStr(n) + ' ' + LS(1384);

  if selected
  then
    if (n mod 10 = 1) and (n <> 11)
    then
      Result := Result + ' ' + LS(1385)
    else
      Result := Result + ' ' + LS(1386);
end;


function TBodyExplForm.GetDriveFreeSpaceStr(dir:string):string;
var size1,size2:UINT;
    f1,f2:real;
begin
 Screen.Cursor:=crHourGlass;
 Result:='';
 size1:=GetDriveFreeSpace(pchar(dir));
 size2:=GetDriveTotalSpace(pchar(dir));
 if size2<>0 then
  begin
   f1:=size1/1000.0;
   f2:=size2/1000.0;
   Result:=Format(LS(1387),[f2,f1]);
  end;
 Screen.Cursor:=crDefault;
end;


procedure TBodyExplForm.UpdateStatusBar;
begin
  if ShellListView.Visible
  then
    if ShellListView.SelCount>1
    then
      StatusBar.Panels[0].Text := ObjectsNumberStr(ShellListView.SelCount, true)
    else
      StatusBar.Panels[0].Text := ObjectsNumberStr(ShellListView.Items.Count, false)
  else
    StatusBar.Panels[0].Text := ObjectsNumberStr(ListView.Items.Count, false);
end;

function TBodyExplForm.CheckAccess(a:integer;wnd:HWND):boolean;
var s:string;
    idx:integer;
    p:array[0..MAX_PATH]of char;
    pw:HWND;
begin
 Result:=true;

 if not ComboBox.HandleAllocated then
  exit;

 if ComboBox.ItemIndex <=0 then
  exit;

 s := string(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].Data^);

 if s = SExFolder then
  begin
   idx := ComboBox.ItemIndex-IExFolder;
   p[0]:=#0;
   GetAdditionalFolderAccess(p,idx);
   s:=p;

   case a of
    ACC_COPY:    Result:=not AnsiContainsText(s,'C');
    ACC_DELETE:  Result:=not AnsiContainsText(s,'D');
    ACC_WRITE:   Result:=not AnsiContainsText(s,'W');
   end;

   if not Result then
    begin
      if wnd=0 then
       pw:=Handle
      else
       pw:=wnd;
      MessageBox(pw, LSP(1413), LSP(LS_WARNING), MB_OK or MB_ICONWARNING);
    end;
  end;
end;

function TBodyExplForm.GetExploringPlace: string;
var s:string;
begin
  if not ComboBox.HandleAllocated then
    begin
      Result := '';
      exit;
    end;

  if ComboBox.ItemIndex <=0 then
    begin
      Result := '';
      exit;
    end;

  s := string(ComboBox.ItemsEx.Items[ComboBox.ItemIndex].Data^);

  if s = SUserFolder then
   s := SUserFolder + IntToStr(ComboBox.ItemIndex-IUserFolder)
  else
  if s = SExFolder then
   s := SExFolder + IntToStr(ComboBox.ItemIndex-IExFolder);

  Result:=s;
end;


function TBodyExplForm.GetExploringPath: string;
var
  s: string;
  n,j: integer;
begin
  Result := '';

  if PathLevel = 0 then
    Exit;

  j := PathLevel;
  s := ShellListView.Root;
  if s[length(s)]='\' then
    SetLength(s,length(s)-1);

  for n:=length(s) downto 1 do
    if s[n]='\' then
      begin
        dec(j);
        if j <= 0 then
          break;
      end;

  if s[n]='\' then
    Result := Copy(s, n+1, length(s)-n);
end;


procedure TBodyExplForm.FormCreate(Sender: TObject);
var n,count:integer;
    state,allow_burn,allow_bt,allow_mail,allow_mobile,allow_camera,allow_hiddens:boolean;
    name,path:string;
    reg:TRegistry;
    item:TMenuItem;
//    style: integer;
//    bi: TBBUTTONINFO;
begin
 GDIP_Init();

// try
//  CoolBar.Bitmap.LoadFromFile(ExtractFilePath(Application.ExeName)+'default_skin.bmp');
// except end;
 cf_cut:=RegisterClipboardFormat('BodyExpl.Cut');

 msg_langchanged:=RegisterWindowMessage('_RPLanguageChanged');
 vip_begin_message := RegisterWindowMessage('_RPVIPSessionBegin');
 vip_end_message := RegisterWindowMessage('_RPVIPSessionEnd');
 Application.OnMessage := AppMessage;

 ImageListTB.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 1, 1);
 for n:=120 to 130 do
  ImageList_AddIcon(ImageListTB.Handle,   LoadImage(hinstance,pchar(n),IMAGE_ICON,32,32,0));

 CoolBar.Bands[0].MinWidth := CoolBar.Bands[0].Control.Width;

 ShellListView.ReadOnly := True;
 ShellTreeView.ShowRoot := True;

 Dropper:=TDropper.Create(Self);
 Dropper.Enabled := True;
 Dropper.OnDropUp := DropperDropUp;
 Dropper.OnDropCheck := DropperCheckTargetWindow;
 DragAcceptFiles(Handle, True);

 OnLanguageChanged();

 count:=0;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell\menu_ext') then
  begin
   for n:=1 to MAXWINITEMS do
    begin
     state:=false;
     name:='';
     path:='';
     try
      name:=reg.ReadString('parm1_'+inttostr(n));
      path:=reg.ReadString('parm2_'+inttostr(n));
      state:=reg.ReadBool('state_'+inttostr(n));
     except end;
     if (state) and (name<>'') and (path<>'') then
      begin
       if path[length(path)]<>'\' then
        path:=path+'\';
       menu_ext[count]:=path;
       item:=TMenuItem.Create(Self);
       item.Caption:=name;
       item.OnClick:=MenuExtClick;
       MenuCopyTo.Add(item);
       inc(count);
      end;
    end;
   reg.CloseKey;
  end;
 reg.Free;

 count:=0;
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell\menu_ext_rev') then
  begin
   for n:=1 to MAXWINITEMS do
    begin
     state:=false;
     name:='';
     path:='';
     try
      name:=reg.ReadString('parm1_'+inttostr(n));
      path:=reg.ReadString('parm2_'+inttostr(n));
      state:=reg.ReadBool('state_'+inttostr(n));
     except end;
     if (state) and (name<>'') and (path<>'') then
      begin
       if path[length(path)]='\' then
        SetLength(path,length(path)-1);
       menu_ext_rev[count]:=path;
       item:=TMenuItem.Create(Self);
       item.Caption:=name;
       item.OnClick:=MenuExtRevClick;
       MenuCopyFrom.Add(item);
       inc(count);
      end;
    end;
   reg.CloseKey;
  end;
 reg.Free;

 allow_burn:=true;
 allow_bt:=true;
 allow_mail:=true;
 allow_mobile:=false;
 allow_camera:=true;
 use_recycle_bin:=false;
 allow_hiddens:=false;
 name := '';
 reg:=TRegistry.Create;
 if reg.OpenKeyReadOnly('Software\RunpadProShell') then
  begin
   try
    name := reg.ReadString('BodyExplViewStyle');
   except end;
   try
    allow_burn := reg.ReadBool('burn_integration');
   except end;
   try
    allow_bt := reg.ReadBool('bt_integration');
   except end;
   try
    allow_mail := reg.ReadBool('bodymail_integration');
   except end;
   try
    allow_mobile := reg.ReadBool('mobile_bodyexpl_integration');
   except end;
   try
    allow_camera := reg.ReadBool('allow_photocam');
   except end;
   try
    use_recycle_bin := reg.ReadBool('delete_to_recycle');
   except end;
   try
    allow_hiddens := reg.ReadBool('show_hiddens_in_bodyexpl');
   except end;
   reg.CloseKey;
  end;
 reg.Free;

 ShellListView.HandleNeeded;

 if ( name='' ) then
    name:='Report';
 if ( name = 'Report' ) then
   MenuViewTable.Click
 else if ( name = 'Icon' ) then
   MenuViewIconic.Click
 else if ( name = 'List' ) then
   MenuViewList.Click
 else if ( name = 'Thumbnail' ) then
   MenuViewThumbnail.Click;

 BtnBurn.Enabled:=allow_burn;
 BtnBTIn.Enabled:=allow_bt;
 BtnBTOut.Enabled:=allow_bt;
 BtnMobile.Enabled:=allow_mobile;
 BtnMail.Enabled:=allow_mail;
 BtnCamera.Enabled:=allow_camera;
 
 InitComboBox;
 InitListView;

 ShellChangeNotifier := nil;

 ExploreHere(ParamStr(1));

 if allow_hiddens then
  begin
   ShellListView.ObjectTypes := [otFolders, otNonFolders, otHidden];
   ShellTreeView.ObjectTypes := [otFolders, otHidden];
  end
 else
  begin
   ShellListView.ObjectTypes := [otFolders, otNonFolders];
   ShellTreeView.ObjectTypes := [otFolders];
  end;

// style := GetWindowLong(ToolBar.Handle, GWL_EXSTYLE);
// style := style or TBSTYLE_EX_DRAWDDARROWS;
// SetWindowLong(ToolBar.Handle, GWL_EXSTYLE, style);
// bi.cbSize := sizeof(bi);
// bi.dwMask := TBIF_STYLE;
// SendMessage(ToolBar.Handle, TB_GETBUTTONINFO, BtnView.Index, integer(@bi));
// bi.fsStyle := bi.fsStyle or BTNS_WHOLEDROPDOWN;
// SendMessage(ToolBar.Handle, TB_SETBUTTONINFO, BtnView.Index, integer(@bi));

 TVistaAltFix.Create(Self);
end;


procedure TBodyExplForm.ShellListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var p:TPoint;
    selected: integer;
    winamp: boolean;
    folder: boolean;
begin
 Handled:=TRUE;

 selected := ShellListView.SelCount;

 LoadMenuOpenWith;
 LoadMenuCreateWith;

 folder := false;
 winamp := false;
 if ShellListView.SelectedFolder<>nil then
   if ShellListView.SelectedFolder.IsFolder then
     begin
       winamp := selected=1;
       folder := true;
     end
   else
     winamp := IsWinampFile(ShellListView.SelectedFolder.PathName) {and (selected=1)};

 MenuOpen.Enabled         := selected=1; // Открыть
 MenuOpenWith.Enabled     :=(selected=1) and not folder; // Открыть с помощью...
 MenuPicture.Enabled      :=IsOnlyImagesSelected; //Изображение->
 MenuWinampAdd.Visible    := winamp;     // Добавить в плейлист Winamp
 MenuCopyPath.Enabled     := selected=1; // Скопировать путь в буфер обмена
 MenuDirSize.Enabled      := selected>0 ; // Посмотреть размер
 MenuCreateFolder.Enabled := selected=0; // Создать новую папку
 MenuCreateWith.Enabled   := selected=0; // Создать новое...
 MenuCopy.Visible         := selected>0; // Скопировать (в буфер обмена)
 MenuCut.Visible          := selected>0; // Вырезать (в буфер обмена)
 MenuPaste.Visible        := selected=0; // Вставить (из буфер обмена)
 MenuPaste.Enabled        := Clipboard.HasFormat(CF_HDROP) or Clipboard.HasFormat(cf_cut);
 MenuRar.Enabled          := selected>0;
 MenuDel.Enabled          := selected>0; // Удалить
 MenuRename.Enabled       := selected=1; // Переименовать
 MenuSelectAll.Enabled    := TRUE;       // Выделить все
 MenuCopyToFlash.Enabled  := selected>0; // Скопировать на дискету/флэш
 MenuCopyToFlash.Caption  := LS(1388)+' '+GetDestFolderName();

 MenuCopyTo.Visible       := MenuCopyTo.Count<>0;
 MenuCopyTo.Enabled       := selected=1; // Скопировать в
 MenuCopyFrom.Visible     := MenuCopyFrom.Count<>0;
 MenuCopyFrom.Enabled     := true;       // Скопировать из

 MenuBurn.Visible         := true;  //burn
 MenuBurn.Enabled         := BtnBurn.Enabled and (selected>0);  //burn

 MenuMail.Visible         := true;  //mail
 MenuMail.Enabled         := BtnMail.Enabled and (selected>0);  //mail

 MenuBTIn.Visible         := true;  //BT
 MenuBTIn.Enabled         := BtnBTIn.Enabled;  //BT
 MenuBTOut.Visible        := true;  //BT
 MenuBTOut.Enabled        := BtnBTOut.Enabled and (selected>0);  //BT

 GetCursorPos(p);
 ShellPopupMenu.Popup(p.X,p.Y);
end;


procedure TBodyExplForm.BtnUpClick(Sender: TObject);
var s,old:string;
    n:integer;
begin
 if PathLevel<=0 then
  begin
   ExploreHere('');
   SetFocusOnList;
   Exit;
  end;

 s:=ShellListView.Root;
 if s[length(s)]='\' then
  SetLength(s,length(s)-1);
 for n:=length(s) downto 1 do
  if s[n]='\' then
   begin
    SetLength(s,n-1);
    break;
   end;

 old:=ShellListView.Root;
 try
  ShellListView.Root:=s;
  dec(PathLevel);
 except
  ShellListView.Root:=old;
 end;

 ShellListView.Refresh;
 ShellTreeView.Refresh(ShellTreeView.Items.GetFirstNode);

 SetTitle;
 UpdateStatusBar;
end;


procedure TBodyExplForm.BtnRefreshClick(Sender: TObject);
begin
 if ShellListView.Visible then
   ShellListView.Refresh;
 if ShellTreeView.Visible then
   ShellTreeView.Refresh(ShellTreeView.Items.GetFirstNode);
 UpdateStatusBar;
end;


procedure TBodyExplForm.MenuRenameClick(Sender: TObject);
var
  s :string;
begin
  if ShellListView.SelectedFolder<>nil then
    begin
     if (not CheckAccess(ACC_WRITE)) or (not CheckAccess(ACC_DELETE)) then
      exit;

      s:=ShellListView.Root;
      if s[length(s)]<>'\' then
        s:=s+'\';
      RenameFileOrFolderForm.root := s;
      RenameFileOrFolderForm.folder := ShellListView.SelectedFolder.PathName;
      if RenameFileOrFolderForm.ShowModal = mrOk then
        begin
          if ShellListView.Visible then
            ShellListView.Refresh;
          if ShellTreeView.Visible then
            ShellTreeView.Refresh(ShellTreeView.Items.GetFirstNode);
          //GoToRandomFileInsideRoot(RenameFileOrFolderForm.out_file);  not works, why?
        end;
    end
end;


function DeleteFolderContent(path: string): Boolean;
var
  fd: WIN32_FIND_DATA;
  h: THandle;
begin
  Result := true;
  h := FindFirstFile(PChar(path + '\*.*'), fd);
  if (h <> INVALID_HANDLE_VALUE) then
    begin
      repeat
        if (string(fd.cFileName)<>'.') and (string(fd.cFileName)<>'..') then
          begin
            if not DeleteFileOrFolder(path + '\' + fd.cFileName) then
              Result := false;
          end;
      until not FindNextFile(h, fd);
    end
  else
    Result := false;
  Windows.FindClose(h);
end;

function DeleteFileOrFolder(path: string): Boolean;
var
  fd: WIN32_FIND_DATA;
  h: THandle;
begin
  Result := true;
  h := FindFirstFile(PChar(path), fd);
  if (h <> INVALID_HANDLE_VALUE) then
    begin
      SetFileAttributes(PChar(path), fd.dwFileAttributes and (not FILE_ATTRIBUTE_READONLY));
      if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          if not DeleteFile(PChar(path)) then
            Result := false;
        end
      else
        begin
          if DeleteFolderContent(path) then
            begin
              if not RemoveDirectory(PChar(path)) then
                Result := false;
            end
          else
            Result := false;
        end;
    end
  else
    Result := false;
  Windows.FindClose(h);
end;


function TBodyExplForm.MenuDelClickInternal(wnd:HWND;const list:TStringList):boolean;
var
  buf : pchar;
  i: integer;
  res: Boolean;
  count: integer;
begin
 Result:=false;
 
 if wnd=0 then
  wnd:=Handle;
 
 if list=nil then
  count:=ShellListView.SelCount
 else
  count:=list.count;
 
 if count>0 then
  begin
    if not CheckAccess(ACC_DELETE,wnd) then
     exit;

    if MessageBox(wnd,LSP(1389),LSP(LS_QUESTION), MB_OKCANCEL or MB_ICONQUESTION) = IDOK  then
      begin
        res := true;
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;
        
        if not use_recycle_bin then
         begin
          if list=nil then
           begin
            for i:=0 to ShellListView.Items.Count-1 do
              if ShellListView.Items[i].Selected then
                if not DeleteFileOrFolder(ShellListView.Folders[i].PathName) then
                  res := false;
           end
          else
           begin
            for i:=0 to list.count-1 do
              if not DeleteFileOrFolder(list[i]) then
                res := false;
           end;
         end
        else
         begin
          AllocSelectedFolderNames(buf,list);
          res:=MultiDelete(buf,true); // here we use Handle, but not wnd because of CopyHooks
          ReleaseSelectedFolderNames(buf);
         end;

        Screen.Cursor := crDefault;

        NotifyAboutFlashDriveChange(FLASH_NOTIFY_DELETE,ShellListView.Root);
        
        if not res then
          MessageBox(wnd,LSP(1390),LSP(LS_ERROR), MB_OK or MB_ICONERROR);

        Result:=res;
      end;
  end;
end;

procedure TBodyExplForm.MenuDelClick(Sender: TObject);
begin
 MenuDelClickInternal();
end;


procedure TBodyExplForm.MenuCopyPathClick(Sender: TObject);
var s:string;
begin
 if ShellListView.SelectedFolder<>nil then
  begin
   s:=ShellListView.SelectedFolder.PathName;
   try
    Clipboard.Open;
    Clipboard.Clear;
    Clipboard.SetTextBuf(pchar(s));
    Clipboard.Close;
   except end;
  end;
end;

procedure TBodyExplForm.MenuCopyToFlashClick(Sender: TObject);
var
 buf: PChar;
begin
 if ShellListView.SelectedFolder<>nil then
  if not WriteToRemovableMediaExclamination(not IsRemovableMedia) then
    begin
     if not CheckAccess(ACC_COPY) then
      exit;

     if GetDestFolderPath()='' then
      begin
       MessageBox(Handle,LSP(1391),LSP(LS_ERR),MB_OK or MB_ICONERROR);
       Exit;
      end;
     AllocSelectedFolderNames(buf);
     MultiCopyTo(buf,PChar(GetDestFolderPath()));
     ReleaseSelectedFolderNames(buf);
     NotifyAboutFlashDriveChange(FLASH_NOTIFY_ADD,GetDestFolderPath());
     MessageBox(Handle,LSP(1376),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
    end;
end;

procedure TBodyExplForm.MenuOpenClick(Sender: TObject);
begin
 ShellListViewDblClick(Sender);
end;

procedure TBodyExplForm.ExecFileInternal(const filename:string);
var w,f:HWND;
    atom,id:integer;
begin
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

     atom:=GlobalAddAtom(pchar(filename));
     PostMessage(w,WM_USER+118,atom,0);
   end;
end;

procedure TBodyExplForm.ShellListViewDblClick(Sender: TObject);
var old:string;
    rc:integer;
    ext:string;
    se_arch : boolean;
    Directory:string;
begin
  if ShellListView.SelectedFolder=nil then
    exit;

  if DirectoryExists(ShellListView.SelectedFolder.PathName) then
    begin
      old:=ShellListView.Root;
      try
        ShellListView.Root:=ShellListView.SelectedFolder.PathName;
        inc(PathLevel);
      except
        ShellListView.Root:=old;
      end;

      SetTitle;
      UpdateStatusBar;
      exit;
    end;

  ext := AnsiLowerCase(ExtractFileExt(ShellListView.SelectedFolder.PathName));

  se_arch:=FALSE;
  if (GetWinRarPath()<>'') and (ext = '.exe') then
   begin
    SEForm.SetExeName(ExtractFileName(ShellListView.SelectedFolder.PathName));
    rc:=SEForm.ShowModal;
    if rc=mrYes then
     se_arch:=TRUE
    else
    if rc=mrNo then
     se_arch:=FALSE
    else
     exit;
   end;

  if GetWinRarPath()<>'' then
   if se_arch or (ext = '.rar') or (ext = '.zip') or (ext = '.gz') or (ext = '.7z') or (ext = '.001') then
     begin
      if not CheckAccess(ACC_WRITE) then
       exit;

      // Delete archive extension
      Directory := GetNameFromPathName(ShellListView.SelectedFolder.PathName);
      while Directory[Length(Directory)] <> '.' do
        Delete(Directory, Length(Directory), 1);
      Delete(Directory, Length(Directory), 1);

      // Propose directory name to extract
      FormExtract.EditFolder.Text := Directory;
      FormExtract.EditPassword.Text := '';

      if FormExtract.ShowModal = mrOK then
        begin
          if FormExtract.RadioButtonCurrent.Checked then
            Directory := ShellListView.Root //ShellListView.RootFolder.PathName
          else
            begin
              Directory := ShellListView.Root; //ShellListView.RootFolder.PathName;
              if Directory[Length(Directory)]<>'\' then
                Directory := Directory + '\';
              Directory := Directory + FormExtract.EditFolder.Text;
              if not DirectoryExists(Directory) then
                if not CreateDirectory(pchar(Directory),nil) then
                  begin
                    MessageBox(Handle,LSP(1392),LSP(LS_ERR), MB_OK or MB_ICONERROR);
                    exit;
                  end;
            end;
          FormInProgress.Show;
          FormInProgress.Update;
          try
            UnRar(ShellListView.SelectedFolder.PathName, Directory, FormExtract.EditPassword.Text);
          finally
            FormInProgress.Hide;
          end;
        end;

//      if MessageBox(Handle, pchar('Распаковать содержимое архива в текущую папку?'), pchar('Подтвердите'), MB_OKCANCEL or MB_ICONQUESTION) = IDOK  then
//        UnRar(GetNameFromPathName(ShellListView.SelectedFolder.PathName), ShellListView.RootFolder.PathName);
      exit;
     end;

  ExecFileInternal(ShellListView.SelectedFolder.PathName);
end;

procedure TBodyExplForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ShellListView.IsEditing then
    exit;

  if key=VK_BACK then
    BtnUpClick(Sender);
end;

procedure TBodyExplForm.ShellListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ShellListView.IsEditing then
    exit;

  if ((Shift = []) or (Shift = [ssShift])) and (Key = VK_DELETE) then
    MenuDelClick(Sender);
  if Shift = [ssCtrl] then
    begin
      if Key = Ord('C') then
        MenuCopyClick(Sender);
      if Key = Ord('X') then
        MenuCutClick(Sender);
      if Key = Ord('V') then
        MenuPasteClick(Sender);
      if Key = Ord('A') then
        MenuSelectAllClick(Sender);
      if Key = Ord('F') then
       if BtnSearch.Enabled then
         BtnSearchClick(Sender);
    end;

  if key=VK_F2 then
   MenuRenameClick(Sender);

  if (Shift = []) and (Key=VK_RETURN) then
    ShellListViewDblClick(Sender);

  // Catch TShellListView BUG
  if (Key >= Ord('A')) and (Key <= Ord('Z')) then
    if ShellListView.Selected = nil then
      Key := 255;
end;

procedure TBodyExplForm.FormDestroy(Sender: TObject);
begin
  Dropper.Free;
  if ShellChangeNotifier<>nil then
    ShellChangeNotifier.Free;

  GDIP_Done();
end;

procedure TBodyExplForm.DropperDropUp(var Files: TStringList);
var
  i: integer;
begin
  if ShellListView.SelCount = 1 then
    Files.Add(ShellListView.SelectedFolder.PathName)
  else
    for i:=0 to ShellListView.Items.Count - 1 do
      if ShellListView.Items[i].Selected then
        Files.Add(ShellListView.Folders[i].PathName);
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

procedure TBodyExplForm.ShellListViewSortBy(idx:integer);
begin
  g_SortColumn := idx;
  ShellListView.ClearSelection;
  ShellListView.SortCurrentView(S_ShellCompare);
end;

procedure TBodyExplForm.ShellListViewColumnClick(Sender: TObject;
  Column: TListColumn);
begin
 ShellListViewSortBy(Column.Index);
end;

procedure TBodyExplForm.MenuSortByNameClick(Sender: TObject);
begin
 ShellListViewSortBy(0);
end;

procedure TBodyExplForm.MenuSortBySizeClick(Sender: TObject);
begin
 ShellListViewSortBy(1);
end;

procedure TBodyExplForm.MenuSortByTypeClick(Sender: TObject);
begin
 ShellListViewSortBy(2);
end;

procedure TBodyExplForm.MenuSortByDateClick(Sender: TObject);
begin
 ShellListViewSortBy(3);
end;

procedure TBodyExplForm.ShellListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDownX := X;
  MouseDownY := Y;
end;

procedure TBodyExplForm.ShellListViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (abs(MouseDownX-X)+abs(MouseDownY-Y)>10) then
    if ShellListView.SelCount>0 then
     begin
      if CheckAccess(ACC_COPY) then
       Dropper.StartDrag;
     end;
end;


function TBodyExplForm.CreateFileCopy(const orig:string):boolean;
var new_file:string;
    src:pchar;
begin
 Result:=false;
 
 if orig<>'' then
  begin
   new_file:=IncludeTrailingPathDelimiter(ExtractFilePath(orig)) + 
             UniqueArchiveName(ExtractFilePath(orig),ChangeFileExt(ExtractFileName(orig),''),ExtractFileExt(orig));

   GetMem(src, length(orig)+2);
   StrCopy(src, pchar(orig));
   (src+length(orig)+1)^ := #0; // set the second NULL

   Result:=MultiCopyTo(src,pchar(new_file));

   FreeMem(src);
  end;
end;


procedure TBodyExplForm.WMDropFiles(var M: TWMDropFiles);
begin
  AcceptFiles(M.Drop,false);

  DragFinish(M.Drop);
  M.Result := 0;
end;


function TBodyExplForm.AcceptFiles(hDrop: THandle; delfiles:boolean):boolean;
var
  buf, p: PChar;
  i,numfiles: integer;
  rc:boolean;
begin
  rc:=false;

  numfiles := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

  GetMem(buf, numfiles*MAX_PATH + 1);
  p := buf;

  for i:=0 to numfiles - 1 do
    begin
      DragQueryFile(hDrop, i, p, MAX_PATH);
      p := p + StrLen(p) + 1;
    end;
  p^ := #0; // Don't forget to set trailing dubbed NULL

  if not WriteToRemovableMediaExclamination(IsRemovableMedia) then
   begin
    if CheckAccess(ACC_WRITE) then
     begin
      // special check for duplicate creation
      if (numfiles=1) and PathEqu(ExtractFilePath(string(buf)),ShellListView.Root) and
         (not DirectoryExists(string(buf))) and (FileExists(string(buf))) then
       begin
        if delfiles then
         rc:=true
        else
         rc:=CreateFileCopy(string(buf));
       end
      else
       begin
        if delfiles then
          rc:=MultiMoveTo(buf, PChar(ShellListView.Root))
        else
          rc:=MultiCopyTo(buf, PChar(ShellListView.Root));
       end;

      NotifyAboutFlashDriveChange(FLASH_NOTIFY_ADD,ShellListView.Root);
     end;
   end;

  FreeMem(buf);

  Result:=rc;
end;


procedure TBodyExplForm.BtnNewClick(Sender: TObject);
var
  s : string;
begin
  s := GetExploringPlace;
  if s<>'' then
    s := '"'+s+':\'+GetExploringPath+'"';
  WinExec(PChar(ParamStr(0)+' '+s),SW_NORMAL);
end;

procedure TBodyExplForm.MenuCreateFolderClick(Sender: TObject);
var
 s, old, new :string;
begin
 if not CheckAccess(ACC_WRITE) then
  exit;

 s:=ShellListView.Root;
 if s[length(s)]<>'\' then
  s:=s+'\';
 CreateFolderForm.root := s;
 if CreateFolderForm.ShowModal = mrOk then
   begin
     new := CreateFolderForm.root + CreateFolderForm.EditName.Text;
     if DirectoryExists(new) then
       begin
         old:=ShellListView.Root;
         try
           ShellListView.Root:=new;
           inc(PathLevel);
         except
           ShellListView.Root:=old;
         end;
         SetTitle;
         UpdateStatusBar;
       end;
   end;
end;

procedure TBodyExplForm.ComboBoxSelect(Sender: TObject);
begin
  ExploreHere(GetExploringPlace);
end;

procedure TBodyExplForm.ListViewDblClick(Sender: TObject);
begin
  if ListView.Selected<>nil then
    begin
      ComboBox.ItemIndex := ListView.Selected.Index + 1;
      ComboBoxSelect(Sender);
      SetFocusOnList;
    end;
end;


procedure TBodyExplForm.MenuCopyInternal(fmt:integer;const list:TStringList);
var
  DropInfo: TDragDropInfo;
  i: integer;
  p: TPoint;
  count : integer;
begin
  if list=nil then
   count:=ShellListView.SelCount
  else
   count:=list.count;
  
  if count > 0 then
    begin
      p.X := 0;
      p.Y := 0;
      DropInfo := TDragDropInfo.Create(p, false);

      if list=nil then
       begin
        for i:=0 to ShellListView.Items.Count - 1 do
          if ShellListView.Items[i].Selected then
            DropInfo.Add(ShellListView.Folders[i].PathName);
       end
      else
       begin
        for i:=0 to list.count-1 do
         DropInfo.Add(list[i]);
       end;

      Clipboard.Open;
      Clipboard.Clear;
      Clipboard.SetAsHandle(fmt, DropInfo.CreateHDrop);
      Clipboard.Close;

      DropInfo.Free;
    end;
end;


procedure TBodyExplForm.MenuCopyClickInternal(wnd:HWND;const list:TStringList);
begin
 if CheckAccess(ACC_COPY,wnd) then
  MenuCopyInternal(CF_HDROP,list);
end;

procedure TBodyExplForm.MenuCopyClick(Sender: TObject);
begin
  MenuCopyClickInternal();
end;


procedure TBodyExplForm.MenuPasteClick(Sender: TObject);
var
  h: THandle;
  rc:boolean;
begin
  if not CheckAccess(ACC_WRITE) then
   exit;

  if Clipboard.HasFormat(CF_HDROP) then
    begin
      Clipboard.Open;
      h := Clipboard.GetAsHandle(CF_HDROP);
      GlobalLock(h);
      AcceptFiles(h,false);
      GlobalUnlock(h);
      Clipboard.Close;
    end;

  if Clipboard.HasFormat(cf_cut) then
    begin
      Clipboard.Open;
      h := Clipboard.GetAsHandle(cf_cut);
      GlobalLock(h);
      rc:=AcceptFiles(h,true);
      GlobalUnlock(h);
      if rc then
        Clipboard.Clear;
      Clipboard.Close;
    end;
end;

procedure TBodyExplForm.FormShow(Sender: TObject);
begin
  SetFocusOnList;
end;

procedure TBodyExplForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = []) and (Key=VK_RETURN) then
    ListViewDblClick(Sender);
end;

procedure TBodyExplForm.ShellChangeNotifierChange;
begin
  BtnRefreshClick(Self);
end;

procedure SaveViewStyle(s: string);
var
  reg: TRegistry;
begin
  reg:=TRegistry.Create;
  if reg.OpenKey('Software\RunpadProShell', true) then
    begin
      try
        reg.WriteString('BodyExplViewStyle', s);
      except end;
      reg.CloseKey;
    end;
  reg.Free;
end;

procedure TBodyExplForm.MenuViewIconicClick(Sender: TObject);
begin
  ListView.ViewStyle := vsIcon;
  ShellListView.ViewStyle := vsIcon;
  MenuViewIconic.Checked := true;
  SaveViewStyle('Icon');
end;

procedure TBodyExplForm.MenuViewListClick(Sender: TObject);
begin
  ListView.ViewStyle := vsList;
  ShellListView.ViewStyle := vsList;
  MenuViewList.Checked := true;
  SaveViewStyle('List');
end;

procedure TBodyExplForm.MenuViewTableClick(Sender: TObject);
begin
  ListView.ViewStyle := vsReport;
  ShellListView.ViewStyle := vsReport;
  MenuViewTable.Checked := true;
  SaveViewStyle('Report');
end;

procedure TBodyExplForm.MenuViewThumbnailClick(Sender: TObject);
begin
  ListView.ViewStyle := vsIcon;
  ShellListView.ThumbnailView := true;
  MenuViewThumbnail.Checked := true;
  SaveViewStyle('Thumbnail');
end;

procedure TBodyExplForm.BtnViewClick(Sender: TObject);
var
  p: TPoint;
begin
  p := BtnView.ClientToScreen(Point(0, BtnView.Height+2));
  PopupMenuView.Popup(p.X, p.Y);
end;

procedure TBodyExplForm.MenuRarClick(Sender: TObject);
var
  RARFile, s: string;
  Split144: boolean;
begin
  if not CheckAccess(ACC_WRITE) then
   exit;

  if ShellListView.SelCount = 1 then
    RARFile := UniqueArchiveName(ShellListView.Root,
      GetNameFromPathName(ShellListView.SelectedFolder.PathName),GetWinRarExt)
  else
    RARFile := UniqueArchiveName(ShellListView.Root,
      GetNameFromPathName(ShellListView.Root{ShellListView.RootFolder.PathName}),GetWinRarExt);

  FormArchive.EditName.Text := RARFile;

  if FormArchive.ShowModal = mrOK then
    begin
      s := GetNameFromPathName(FormArchive.EditName.Text);

      if UpperCase(Copy(s, Length(s)-3, 4)) = '.RAR' then
        Delete(s, Length(s)-3, 4)
      else if UpperCase(Copy(s, Length(s)-2, 3)) = '.7Z' then
        Delete(s, Length(s)-2, 3);
      RARFile := UniqueArchiveName(ShellListView.Root,s,GetWinRarExt);
      Split144 := FormArchive.CheckBox144.Checked;
      FormInProgress.Show;
      FormInProgress.Update;
      try
        Rar(RARFile, Split144);
      finally
        FormInProgress.Hide;
      end;  
    end;
end;


function TBodyExplForm.GetWinRarPath:string;
var WinRarPath:string;
    reg:TRegistry;
begin
  WinRARPath := '';
  reg:=TRegistry.Create;
  if reg.OpenKeyReadOnly('Software\RunpadProShell') then
    begin
      try
        WinRARPath := reg.ReadString('winrar_path');
      except end;
      reg.CloseKey;
    end;
  reg.Free;
  Result:=WinRarPath;
end;


function TBodyExplForm.GetWinRarExt:string;
var WinRarPath:string;
    i:integer;
begin
  WinRarPath := GetWinRarPath;
  WinRarPath := GetNameFromPathName(WinRarPath);
  i := Pos('.', WinRarPath);
  if i>0 then
    Delete(WinRarPath, i, Length(WinRarPath)-i+1);

  WinRarPath := UpperCase(WinRarPath);

  Result := '';

  if WinRarPath = '7Z' then
    Result := '.7z';
  if (WinRarPath = 'WINRAR') or (WinRarPath = 'RAR') then
    Result := '.rar';
end;


procedure TBodyExplForm.Rar(RARFile: string; Split144: boolean);
var
  WinRARPath: string;
  WinRARExt: string;
  oldDir: string;
  s: string;
  i: integer;
  Split144Switch: string;
begin
  WinRARPath := GetWinRarPath();
  WinRARExt := GetWinRarExt();

  if WinRARPath = '' then
    begin
     MessageBox(Handle, LSP(1393), LSP(LS_ERR), MB_OK or MB_ICONERROR);
     exit;
    end;

  if not FileExists(WinRARPath) then
    begin
     if WinRARExt = '.7z' then
       MessageBox(Handle, LSP(1394), LSP(LS_ERR), MB_OK or MB_ICONERROR)
     else
       MessageBox(Handle, LSP(1395), LSP(LS_ERR), MB_OK or MB_ICONERROR);
     exit;
    end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  oldDir := GetCurrentDir;

  if SetCurrentDir(ShellListView.Root{ShellListView.RootFolder.PathName}) then
    begin
      if WinRARExt = '.7z' then
        begin
          if Split144 then
            Split144Switch := '-v1457664b '
          else
            Split144Switch := '';

          s := '"'+WinRARPath+'" a -bd -r -y '+Split144Switch+'"'+RARFile+'"'
        end
      else
        begin
          if Split144 then
            Split144Switch := '-v1440 '
          else
            Split144Switch := '';

          s := '"'+WinRARPath+'" a -c- -dh -idp -inul -m5 -o+ -y '+Split144Switch+'"'+RARFile+'"'
        end;

      for i:=0 to ShellListView.Items.Count-1 do
        if ShellListView.Items[i].Selected then
          s := s +' "'+ GetNameFromPathName(ShellListView.Folders[i].PathName)+'"';

      RunHiddenProcessAndWait(pchar(s),nil);
    end;

  SetCurrentDir(oldDir);
  Screen.Cursor := crDefault;

  BtnRefreshClick(nil);
end;

procedure TBodyExplForm.UnRar(RARFile: string; Directory: string; Password: string);
var
  WinRARPath: string;
  WinRARExt: string;
  oldDir: string;
  s: string;
  pwd: string;
begin
  WinRARPath := GetWinRarPath();
  WinRARExt := GetWinRarExt();

  if WinRARPath = '' then
    begin
     MessageBox(Handle, LSP(1396), LSP(LS_ERR), MB_OK or MB_ICONERROR);
     exit;
    end;

  if not FileExists(WinRARPath) then
    begin
     if WinRARExt = '.7z' then
       MessageBox(Handle, LSP(1394), LSP(LS_ERR), MB_OK or MB_ICONERROR)
     else
       MessageBox(Handle, LSP(1395), LSP(LS_ERR), MB_OK or MB_ICONERROR);
     exit;
    end;

  if Password = '' then
    if WinRARExt = '.7z' then
      pwd := ''
    else
      pwd := ' -p-'
  else
    pwd := ' -p' + Password;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  oldDir := GetCurrentDir;

  if SetCurrentDir(Directory) then
    begin
      if WinRARExt = '.7z' then
        s := '"'+WinRARPath+'" x -bd'+pwd+' -y "'+RARFile+'"'
      else
        s := '"'+WinRARPath+'" x -c- -inul -o+'+pwd+' -y "'+RARFile+'"';

      RunHiddenProcessAndWait(pchar(s),nil);
    end;

  SetCurrentDir(oldDir);
  Screen.Cursor := crDefault;

  BtnRefreshClick(nil);
end;

procedure TBodyExplForm.MenuDirSizeClick(Sender: TObject);
var
  s: string;
  i: integer;
  total : cardinal;
begin
  if ShellListView.SelCount > 0 then
    begin
     Screen.Cursor := crHourGlass;
     Application.ProcessMessages;
     total:=0;
     for i:=0 to ShellListView.Items.Count - 1 do
       if ShellListView.Items[i].Selected then
         total:=total+GetDirectorySize(pchar(ShellListView.Folders[i].PathName));
     Screen.Cursor := crDefault;
     s:=inttostr(total);

     i := Length(s);
     repeat
       i := i-3;
       if (i<1) then break;
       Insert(' ', s, i+1);
     until false;
     MessageBox(Handle, pchar(s+' '+LS(1397)), LSP(1398), MB_OK or MB_ICONINFORMATION);
    end;
end;

procedure TBodyExplForm.ListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TBodyExplForm.ShellTreeViewEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;


procedure TBodyExplForm.ShellListViewEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TBodyExplForm.ListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  p   : TPoint;
  IExploringPlace: integer;
  DVDPath: string;
  isDVD: boolean;
begin
  Handled:=TRUE;

  if ListView.SelCount>0 then
    IExploringPlace := ListView.Selected.Index + 1
  else
    IExploringPlace := -1;

  isDVD := false;
  DVDPath := '';
  if ICdrom>=0 then
   begin
    DVDPath := GetCDROMPath(@buf,Handle);
    if (DVDPath<>'') and (DVDPath[2] = ':') then   //todo: see DvdLauncher() function
      begin
        SetLength(DVDPath, 2);
        DVDPath := DVDPath + '\VIDEO_TS\video_ts';
        isDVD := (IExploringPlace = ICdrom) and (FileExists(DVDPath+'.vob') or FileExists(DVDPath+'.ifo'));
      end;
   end;

  MenuOpenMain.Enabled   := IExploringPlace >= 0; // Открыть
  MenuEject.Enabled      := (IExploringPlace = ICdrom) or (IExploringPlace = IFlash); // Извлечь
  MenuDVD.Enabled        := isDVD;
  MenuFormat.Enabled     := (IExploringPlace = IDiskette) or (IExploringPlace = IFlash); // Форматировать
  MenuFreeSpace.Enabled  := (IExploringPlace = IDiskette) or (IExploringPlace = IFlash) or (IExploringPlace = ICdrom); // свободное место

  GetCursorPos(p);
  PopupMenu.Popup(p.X,p.Y);
end;

procedure TBodyExplForm.MenuOpenMainClick(Sender: TObject);
begin
  ListViewDblClick(Sender);
end;

procedure TBodyExplForm.MenuEjectClick(Sender: TObject);
var
  IExploringPlace: integer;
  Drive: string;
begin
  Drive := '';

  if ListView.SelCount>0 then
    IExploringPlace := ListView.Selected.Index + 1
  else
    IExploringPlace := -1;

  if IExploringPlace = ICdrom then
    Drive := GetCDROMPath(@buf,Handle);
  if IExploringPlace = IFlash then
    Drive := GetFlashPath(@buf,Handle);

  if (Drive<>'') and (Drive[1]<>'\') then
    EjectDrive(pchar(Drive))
  else
   begin
    MessageBox(Handle,LSP(1399),LSP(LS_WARN), MB_OK or MB_ICONWARNING);
   end;
end;

procedure TBodyExplForm.MenuFormatClick(Sender: TObject);
var
  IExploringPlace: integer;
  Drive: string;
  rc:cardinal;
begin
  Drive := '';

  if ListView.SelCount>0 then
    IExploringPlace := ListView.Selected.Index + 1
  else
    IExploringPlace := -1;

  if IExploringPlace = IDiskette then
    Drive := GetDiskettePath(@buf);
  if IExploringPlace = IFlash then
    Drive := GetFlashPath(@buf,Handle);

  if (Drive<>'') and (Drive[1]<>'\') then
   begin
    rc:=FormatDrive(Handle, pchar(Drive));
    if (rc<>SHFMT_ERROR) and (rc<>SHFMT_CANCEL) and (rc<>SHFMT_NOFORMAT) then
       NotifyAboutFlashDriveChange(FLASH_NOTIFY_FORMAT,drive);
   end
  else
   begin
    MessageBox(Handle,LSP(1399),LSP(LS_WARN), MB_OK or MB_ICONWARNING);
   end;
end;

procedure TBodyExplForm.ShellListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  UpdateStatusBar;
end;

procedure TBodyExplForm.ShellTreeViewClick(Sender: TObject);
begin
  if ShellTreeView.SelectedFolder<>nil then
   GoToRandomPathInsideGlobalRoot(ShellTreeView.SelectedFolder.PathName);
end;

procedure TBodyExplForm.ShellTreeViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ShellTreeView.IsEditing then
    exit;
{
  if ((Shift = []) or (Shift = [ssShift])) and (Key = VK_DELETE) then
    MenuDelClick(Sender);
  if Shift = [ssCtrl] then
    begin
      if Key = Ord('C') then
        MenuCopyClick(Sender);
      if Key = Ord('V') then
        MenuPasteClick(Sender);
    end;
}
  if (Shift = []) and (Key=VK_RETURN) then
    ShellTreeViewClick(Sender);
end;

procedure TBodyExplForm.PopupMenuTreePopup(Sender: TObject);
begin
//  PopupMenuTree.
end;

procedure TBodyExplForm.MenuWinampAddClick(Sender: TObject);
var reg:TRegistry;
    s:string;
    i:integer;
begin
 if ShellListView.SelectedFolder<>nil then
  begin
   //if not CheckAccess(ACC_COPY) then
   // exit;

   Screen.Cursor:=crHourGlass;

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

   if s<>'' then
    begin
     if s[length(s)]<>'\' then
      s:=s+'\';
     s:=s+'winamp.exe';
     if FileExists(s) then
      begin
       s:='"'+s+'" /ADD';
       for i:=0 to ShellListView.Items.Count - 1 do
        if ShellListView.Items[i].Selected then
         if IsWinampFile(ShellListView.Folders[i].PathName) then
           s:=s+' "'+ShellListView.Folders[i].PathName+'"';
       RunProcess(pchar(s));
      end;
    end;

   Screen.Cursor:=crDefault;
  end;
end;

procedure TBodyExplForm.LoadMenuOpenWith;
var
  i: integer;
  item: TMenuItem;
begin
  MenuOpenWith.Clear;

  if GetOpenWithCount>0 then
    begin
      for i:=1 to GetOpenWithCount() do
        begin
          item := TMenuItem.Create(Self);
          item.Caption := GetOpenWithName(i-1, @buf);
          item.OnClick := MenuOpenWithClick;
          MenuOpenWith.Add(item);
         end;
      MenuOpenWith.Visible := true;
    end
  else
    MenuOpenWith.Visible := false;
end;

procedure TBodyExplForm.MenuOpenWithClick(Sender: TObject);
var
  item: TMenuItem;
  s: string;
begin
 if ShellListView.SelectedFolder<>nil then
   begin
     item:=Sender as TMenuItem;
     s:=ShellListView.SelectedFolder.PathName;
     OpenWith(MenuOpenWith.IndexOf(item),pchar(s));
   end;
end;

{
function CreateNewTXT(s:string):boolean;
begin
 Result:=CreateEmptyFile(pchar(s));
end;

function CreateNewDOC(s:string):boolean;
var oo:OleVariant;
begin
 Result := true;
 try
   oo := CreateOleObject('Word.Application');
   oo.Documents.Add;
   try
    oo.ActiveDocument.SaveAs(s);
   except
    Result:=false;
   end;
   oo.ActiveDocument.Close;
   oo.Quit;
 except
  Result:=false;
 end;
 oo := UnAssigned;
end;

function CreateNewXLS(s:string):boolean;
var oo:OleVariant;
begin
 Result := true;
 try
   oo := CreateOleObject('Excel.Application');
   oo.Workbooks.Add;
   try
    oo.ActiveWorkbook.SaveAs(s);
   except
    Result:=false;
   end;
   oo.ActiveWorkbook.Close;
   oo.Quit;
 except
  Result:=false;
 end;
 oo := UnAssigned;
end;
}

function CreateNewTXT(s:string):boolean;
begin
 Result:=CreateNewEmptyTXT(pchar(s));
end;

function CreateNewDOC(s:string):boolean;
begin
 Result:=CreateNewEmptyDOC(pchar(s));
end;

function CreateNewXLS(s:string):boolean;
begin
 Result:=CreateNewEmptyXLS(pchar(s));
end;

type TCreateWithFunc = function(s:string):boolean;
type TCreateWith = record
     ext:string;
     name:integer;
     func:TCreateWithFunc;
     end;

const CreateWithAr : array [0..2] of TCreateWith =
(
  (ext:'.txt';name:1400;func:CreateNewTXT),
  (ext:'.doc';name:1401;func:CreateNewDOC),
  (ext:'.xls';name:1402;func:CreateNewXLS)
);


function TBodyExplForm.GetCreateWithCount:integer;
begin
 Result:=sizeof(CreateWithAr) div sizeof(CreateWithAr[0]);
end;

function TBodyExplForm.GetCreateWithName(idx:integer):string;
begin
 if (idx>=0) and (idx<GetCreateWithCount) then
  Result:=LS(CreateWithAr[idx].name)
 else
  Result:='';
end;

procedure TBodyExplForm.CreateWithHL(idx:integer);
var olddir,filename,name,ext:string;
    rc:boolean;
begin
 if (idx>=0) and (idx<GetCreateWithCount) then
  begin
   oldDir := GetCurrentDir;
   if SetCurrentDir(ShellListView.Root{ShellListView.RootFolder.PathName}) then
    begin
     Screen.Cursor := crHourGlass;
     Application.ProcessMessages;
     ext:=CreateWithAr[idx].ext;
     name:=LS(1403);
     filename:=IncludeTrailingPathDelimiter(ShellListView.Root{ShellListView.RootFolder.PathName})+UniqueArchiveName(ShellListView.Root,name,ext);
     rc:=CreateWithAr[idx].func(filename);
     SetCurrentDir(olddir);
     Screen.Cursor := crDefault;
     if not rc then
      MessageBox(Handle, LSP(1404), LSP(LS_ERROR), MB_OK or MB_ICONERROR);
    end;
  end;
end;

procedure TBodyExplForm.LoadMenuCreateWith;
var
  i: integer;
  item: TMenuItem;
begin
  MenuCreateWith.Clear;

  if GetCreateWithCount>0 then
    begin
      for i:=1 to GetCreateWithCount() do
        begin
          item := TMenuItem.Create(Self);
          item.Caption := GetCreateWithName(i-1);
          item.OnClick := MenuCreateWithClick;
          MenuCreateWith.Add(item);
         end;
      MenuCreateWith.Visible := true;
    end
  else
    MenuCreateWith.Visible := false;
end;

procedure TBodyExplForm.MenuCreateWithClick(Sender: TObject);
var
  item: TMenuItem;
  idx: integer;
begin
  if not CheckAccess(ACC_WRITE) then
   exit;

 item:=Sender as TMenuItem;
 idx:=MenuCreateWith.IndexOf(item);
 CreateWithHL(idx);
 try
  ShellListView.SetFocus;
 except end;
end;

procedure TBodyExplForm.MenuDVDClick(Sender: TObject);
var
  DVDPath: string;
  Command: string;
begin
  DVDPath := GetCDROMPath(@buf,Handle);
  if (DVDPath<>'') and (DVDPath[2] = ':') then
    begin
      SetLength(DVDPath, 2);
      DVDPath := DVDPath + '\VIDEO_TS\video_ts';
      if FileExists(DVDPath+'.vob') or FileExists(DVDPath+'.ifo') then
        begin
          Command := ExtractFileDir(ParamStr(0));
          if (Command<>'') then
            begin
              Command := IncludeTrailingPathDelimiter(Command) + 'bodymp.exe';
              WinExec(PChar('"' + Command + '" /dvd ' + AnsiUpperCase(DVDPath[1])), SW_SHOWDEFAULT);
            end;
        end;
    end;
end;

procedure TBodyExplForm.MenuSelectAllClick(Sender: TObject);
begin
 try
  ShellListView.SetFocus;
 except end;
 try
  ShellListView.SelectAll;
 except end;
end;

procedure TBodyExplForm.RunBodyToolWithParms(tool,parms:string);
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

procedure TBodyExplForm.BtnBurnClick(Sender: TObject);
begin
 RunBodyToolWithParms('bodyburn','');
end;

procedure TBodyExplForm.MenuBurnClick(Sender: TObject);
var i:integer;
    s:string;
begin
 if ShellListView.SelCount > 0 then
  begin
   if not CheckAccess(ACC_COPY) then
    exit;

   s:='';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     s:=s+' "'+ShellListView.Folders[i].PathName+'"';
   RunBodyToolWithParms('bodyburn',s);
  end;
end;

function TBodyExplForm.PathEqu(s1,s2:string):boolean;
begin
 s1:=IncludeTrailingPathDelimiter(s1);
 s2:=IncludeTrailingPathDelimiter(s2);
 Result:=(AnsiCompareText(s1,s2)=0);
end;

procedure TBodyExplForm.MenuFreeSpaceClick(Sender: TObject);
var
  IExploringPlace: integer;
  Drive,s: string;
begin
  Drive := '';

  if ListView.SelCount>0 then
    IExploringPlace := ListView.Selected.Index + 1
  else
    IExploringPlace := -1;

  if IExploringPlace = IDiskette then
    Drive := GetDiskettePath(@buf);
  if IExploringPlace = IFlash then
    Drive := GetFlashPath(@buf,Handle);
  if IExploringPlace = ICDROM then
    Drive := GetCDRomPath(@buf,Handle);

  if (Drive<>'') and (Drive[1]<>'\') then
   begin
    s:=GetDriveFreeSpaceStr(Drive);
    if s<>'' then
     begin
      MessageBox(Handle,pchar(s),LSP(LS_INFO), MB_OK or MB_ICONINFORMATION);
      exit;
     end;
   end;

 MessageBox(Handle,LSP(1399),LSP(LS_WARN), MB_OK or MB_ICONWARNING);
end;

procedure TBodyExplForm.BtnBTOutClick(Sender: TObject);
var i:integer;
    s:string;
begin
 if (GetExploringPlace<>sNone) and (ShellListView.SelCount>0) then
  begin
   if not CheckAccess(ACC_COPY) then
    exit;

   s:='-send';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     s:=s+' "'+ShellListView.Folders[i].PathName+'"';
   RunBodyToolWithParms('bodybt',s);
  end
 else
  begin
   MessageBox(Handle,LSP(1405),LSP(LS_INFO), MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TBodyExplForm.BtnBTInClick(Sender: TObject);
begin
 if GetExploringPlace<>sNone then
  begin
   if not CheckAccess(ACC_WRITE) then
    exit;

   RunBodyToolWithParms('bodybt','-recv "'+ShellListView.Root+'"');
  end
 else
  begin
   MessageBox(Handle,LSP(1406),LSP(LS_INFO), MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TBodyExplForm.MenuBTOutClick(Sender: TObject);
begin
 BtnBTOutClick(Sender);
end;

procedure TBodyExplForm.MenuBTInClick(Sender: TObject);
begin
 BtnBTInClick(Sender);
end;

procedure TBodyExplForm.MenuCutClickInternal(wnd:HWND;const list:TStringList);
begin
  if CheckAccess(ACC_COPY,wnd) and CheckAccess(ACC_DELETE,wnd) then
   MenuCopyInternal(cf_cut,list);
end;

procedure TBodyExplForm.MenuCutClick(Sender: TObject);
begin
   MenuCutClickInternal();
end;

procedure TBodyExplForm.MenuMailClick(Sender: TObject);
var i:integer;
    s:string;
begin
 if ShellListView.SelCount > 0 then
  begin
   if not CheckAccess(ACC_COPY) then
    exit;

   s:='';
   for i:=0 to ShellListView.Items.Count - 1 do
    if ShellListView.Items[i].Selected then
     s:=s+' "'+ShellListView.Folders[i].PathName+'"';
   RunBodyToolWithParms('bodymail',s);
  end;
end;

procedure TBodyExplForm.BtnMailClick(Sender: TObject);
begin
 RunBodyToolWithParms('bodymail','');
end;

procedure TBodyExplForm.NotifyAboutFlashDriveChange(typ:integer;path:string);
var drive:string;
    w:HWND;
    n,cmd:integer;
begin
 if (length(path)>2) and (path[2]=':') and (path[1]<>'a') and (path[1]<>'b') and (path[1]<>'A') and (path[1]<>'B') then
  begin
   drive:=path[1]+':\';
   if (GetDriveType(pchar(drive)) = DRIVE_REMOVABLE) or (IsDriveTrueRemovableS(pchar(drive))) then
    begin
     w:=FindWindow('_RunpadClass',nil);
     if w<>0 then
      begin
       n:=ord(AnsiUpperCase(drive)[1])-ord('A');
       if typ=FLASH_NOTIFY_FORMAT then
        cmd:=WM_USER+190
       else
       if typ=FLASH_NOTIFY_ADD then
        cmd:=WM_USER+191
       else
        cmd:=WM_USER+192;
       PostMessage(w,cmd,n,0);
      end;
    end;
  end;
end;


procedure TBodyExplForm.BtnMobileClick(Sender: TObject);
begin
 RunBodyToolWithParms('bodymobile','');
end;

procedure TBodyExplForm.BtnCameraClick(Sender: TObject);
begin
 if GetExploringPlace<>sNone then
  begin
   if not CheckAccess(ACC_WRITE) then
    exit;

   RunBodyToolWithParms('bodycam','"'+ShellListView.Root+'"');
  end
 else
  begin
   MessageBox(Handle,LSP(1406),LSP(LS_INFO), MB_OK or MB_ICONINFORMATION);
  end;
end;

function TBodyExplForm.IsOnlyImagesSelected:boolean;
var i:integer;
begin
 Result:=ShellListView.SelCount<>0;

 for i:=0 to ShellListView.Items.Count-1 do
   if ShellListView.Items[i].Selected then
    begin
     if ShellListView.Folders[i].IsFolder or (not GDIP_IsSupportedFormat(pchar(ShellListView.Folders[i].PathName))) then
      begin
       Result:=false;
       break;
      end;
    end;
end;


const IMGA_ROTATECW      = 1;
const IMGA_ROTATECCW     = 2;
const IMGA_RESIZESMALL   = 3;
const IMGA_RESIZENORMAL  = 4;
const IMGA_RESIZEBIG     = 5;
const IMGA_CONVERT       = 6;

procedure TBodyExplForm.Action4Images(action:integer;const postfix,new_ext:string);
var i:integer;
    list : array of string;
    src, dest, namepart, ext : string;
begin
 if not CheckAccess(ACC_WRITE) then
  exit;

 Screen.Cursor:=crHourGlass;
 FormInProgress.Show;
 FormInProgress.Update;

 list:=nil;
 for i:=0 to ShellListView.Items.Count-1 do
   if ShellListView.Items[i].Selected then
     if (not ShellListView.Folders[i].IsFolder) and GDIP_IsSupportedFormat(pchar(ShellListView.Folders[i].PathName)) then
      begin
       setlength(list,length(list)+1);
       list[high(list)]:=ShellListView.Folders[i].PathName;
      end;

 for i:=low(list) to high(list) do
  begin
   src:=list[i];
   namepart:=ChangeFileExt(ExtractFileName(src),'')+postfix;
   ext:=ExtractFileExt(src);
   if new_ext<>'' then
    ext:=new_ext;
   dest:=IncludeTrailingPathDelimiter(ExtractFilePath(src))+namepart+ext;

   case action of
    IMGA_ROTATECW:      GDIP_RotateImage(false,pchar(src),pchar(dest));
    IMGA_ROTATECCW:     GDIP_RotateImage(true,pchar(src),pchar(dest));
    IMGA_RESIZESMALL:   GDIP_ReduceImage(640,480,pchar(src),pchar(dest));
    IMGA_RESIZENORMAL:  GDIP_ReduceImage(800,600,pchar(src),pchar(dest));
    IMGA_RESIZEBIG:     GDIP_ReduceImage(1024,768,pchar(src),pchar(dest));
    IMGA_CONVERT:       GDIP_ConvertFile(pchar(src),pchar(dest));
   end;

   //Application.ProcessMessages;
  end;

 list:=nil; //free list

 FormInProgress.Hide;
 Screen.Cursor:=crDefault;
end;

procedure TBodyExplForm.MenuRotateCWClick(Sender: TObject);
begin
 Action4Images(IMGA_ROTATECW,'_rotate','');
end;

procedure TBodyExplForm.MenuRotateCCWClick(Sender: TObject);
begin
 Action4Images(IMGA_ROTATECCW,'_rotate','');
end;

procedure TBodyExplForm.MenuResizeSmallClick(Sender: TObject);
begin
 Action4Images(IMGA_RESIZESMALL,'_resize','');
end;

procedure TBodyExplForm.MenuResizeNormalClick(Sender: TObject);
begin
 Action4Images(IMGA_RESIZENORMAL,'_resize','');
end;

procedure TBodyExplForm.MenuResizeBigClick(Sender: TObject);
begin
 Action4Images(IMGA_RESIZEBIG,'_resize','');
end;

procedure TBodyExplForm.MenuConvertJPEGClick(Sender: TObject);
begin
 Action4Images(IMGA_CONVERT,'','.jpg');
end;

procedure TBodyExplForm.MenuConvertBMPClick(Sender: TObject);
begin
 Action4Images(IMGA_CONVERT,'','.bmp');
end;

procedure TBodyExplForm.MenuConvertTIFFClick(Sender: TObject);
begin
 Action4Images(IMGA_CONVERT,'','.tif');
end;

procedure TBodyExplForm.MenuConvertPNGClick(Sender: TObject);
begin
 Action4Images(IMGA_CONVERT,'','.png');
end;

procedure TBodyExplForm.MenuConvertGIFClick(Sender: TObject);
begin
 Action4Images(IMGA_CONVERT,'','.gif');
end;

procedure TBodyExplForm.BtnSearchClick(Sender: TObject);
var filename:string;
    goto_dir, goto_file : string;
begin
 filename:=ShowSearchFilesFormModal(Title,ShellTreeView.Root,ShellListView.Root,SearchFileOpFunc);
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
    if GoToRandomPathInsideGlobalRoot(goto_dir) and ShellListView.Visible then
     begin
      if goto_file<>'' then
       GoToRandomFileInsideRoot(goto_file);
     end;
  end;
end;

function TBodyExplForm.SearchFileOpFunc(wnd:HWND;cmd:TSearchFileOp;const list:TStringList):boolean;
begin
 Result:=false;
 
 if (list<>nil) and (list.count>0) then
  begin
   if cmd=sfop_exec then
    begin
     ExecFileInternal(list[0]);
     Result:=true;
    end
   else
   if cmd=sfop_copy then
    begin
     MenuCopyClickInternal(wnd,list);
     Result:=true;
    end
   else
   if cmd=sfop_cut then
    begin
     MenuCutClickInternal(wnd,list);
     Result:=true;
    end
   else
   if cmd=sfop_delete then
    begin
     Result:=MenuDelClickInternal(wnd,list);
    end;
  end;
end;


end.
