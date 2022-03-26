unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, ExtCtrls, ImgList, ToolWin,
  Menus;

type
  TBodyRecycleForm = class(TForm)
    Panel1: TPanel;
    ShellListView: TShellListView;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ButtonRefresh: TToolButton;
    ToolButton2: TToolButton;
    ButtonRestore: TToolButton;
    ImageList1: TImageList;
    ToolButton4: TToolButton;
    ButtonEmpty: TToolButton;
    ToolButton3: TToolButton;
    PopupMenu: TPopupMenu;
    MenuRestore: TMenuItem;
    N2: TMenuItem;
    MenuDelete: TMenuItem;
    ButtonDelete: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ButtonRestoreClick(Sender: TObject);
    procedure ShellListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ShellListViewDblClick(Sender: TObject);
    procedure ShellListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShellListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonEmptyClick(Sender: TObject);
    procedure MenuRestoreClick(Sender: TObject);
    procedure MenuDeleteClick(Sender: TObject);
    procedure ShellListViewContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
  private
    { Private declarations }
    function DoShellFolderVerb(AFolder: TShellFolder; Verb: PChar):HRESULT;
    procedure OnLangChanged;
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  BodyRecycleForm: TBodyRecycleForm;

implementation

uses CommCtrl, ShlObj;

{$R *.dfm}

{$INCLUDE ..\rp_shared\RP_Shared.inc}


function SHEmptyRecycleBin(wnd:HWND;const root:pchar;dwFlags:cardinal):HRESULT stdcall; external 'shell32.dll' name 'SHEmptyRecycleBinA';


var  lang_change_message : cardinal = WM_NULL;


procedure TBodyRecycleForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if Msg.message=lang_change_message then
   begin
     OnLangChanged();
     Handled := True;
   end;
end;

procedure TBodyRecycleForm.OnLangChanged;
begin
 Application.Title:=LS(1700);
 Caption:=Application.Title;
 ButtonRefresh.Caption:=LS(1701);
 ButtonRestore.Caption:=LS(1702);
 ButtonEmpty.Caption:=LS(1703);
 MenuRestore.Caption:=ButtonRestore.Caption;
 MenuDelete.Caption:=LS(1704);
end;

procedure TBodyRecycleForm.FormCreate(Sender: TObject);
begin
 lang_change_message := RegisterWindowMessage('_RPLanguageChanged');
 Application.OnMessage:=AppMessage;
 
 OnLangChanged;

 ButtonRestore.Enabled:=false;
 ButtonDelete.Enabled:=false;
 SetWindowLong(ShellListView.Handle,GWL_STYLE,GetWindowLong(ShellListView.Handle,GWL_STYLE) and (not LVS_EDITLABELS));

 ImageList1.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 5, 1);
 ImageList_AddIcon(ImageList1.Handle, LoadIcon(HInstance, PChar(120)));
 ImageList_AddIcon(ImageList1.Handle, LoadIcon(HInstance, PChar(121)));
 ImageList_AddIcon(ImageList1.Handle, LoadIcon(HInstance, PChar(122)));
end;

procedure TBodyRecycleForm.FormDestroy(Sender: TObject);
begin
//
end;

procedure TBodyRecycleForm.FormShow(Sender: TObject);
begin
 ShellListView.SetFocus;
end;

procedure TBodyRecycleForm.ShellListViewEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TBodyRecycleForm.ShellListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
 ButtonRestore.Enabled:=ShellListView.SelectedFolder<>nil;
 ButtonDelete.Enabled:=ShellListView.SelectedFolder<>nil;
end;

procedure TBodyRecycleForm.ShellListViewDblClick(Sender: TObject);
begin
 if ButtonRestore.Enabled then
   ButtonRestoreClick(Sender);
end;

procedure TBodyRecycleForm.ShellListViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if ShellListView.IsEditing then
   exit;

 if Key=VK_RETURN then
  ShellListViewDblClick(sender);
 if Key=VK_DELETE then
  begin
   if ButtonDelete.Enabled then
    ButtonDeleteClick(Sender);
  end;
 if Key=VK_F5 then
  begin
   ButtonRefreshClick(Sender);
  end;

 // Catch TShellListView BUG
 if (Key >= Ord('A')) and (Key <= Ord('Z')) then
  if ShellListView.Selected = nil then
    Key := 255;
end;

procedure TBodyRecycleForm.ShellListViewContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var p:TPoint;
begin
 Handled:=true;

 if ShellListView.SelectedFolder<>nil then
  begin
   MenuRestore.Enabled:=true;
   MenuDelete.Enabled:=true;

   GetCursorPos(p);
   PopupMenu.Popup(p.X,p.Y);
  end;
end;

procedure TBodyRecycleForm.MenuRestoreClick(Sender: TObject);
begin
 if ButtonRestore.Enabled then
  ButtonRestoreClick(Sender);
end;

procedure TBodyRecycleForm.MenuDeleteClick(Sender: TObject);
begin
 if ButtonDelete.Enabled then
  ButtonDeleteClick(Sender);
end;

procedure TBodyRecycleForm.ButtonRefreshClick(Sender: TObject);
begin
 try
  ShellListView.Refresh;
 except
 end;
 ShellListView.Selected:=nil;
 ShellListView.SetFocus;
end;

procedure TBodyRecycleForm.ButtonRestoreClick(Sender: TObject);
begin
 if ShellListView.SelectedFolder<>nil then
  begin
   if MessageBox(Handle,pchar(Format(LS(1705),[ShellListView.SelectedFolder.DisplayName])),LSP(LS_QUESTION),MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
    begin
     if DoShellFolderVerb(ShellListView.SelectedFolder,'undelete')=S_OK then
      MessageBox(Handle,LSP(1706),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION)
     else
      MessageBox(Handle,LSP(1707),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
     ButtonRefreshClick(Sender);
    end;
  end;
end;

procedure TBodyRecycleForm.ButtonEmptyClick(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;
 SHEmptyRecycleBin(Handle,nil,0);
 Screen.Cursor:=crDefault;
 ButtonRefreshClick(Sender);
end;

procedure TBodyRecycleForm.ButtonDeleteClick(Sender: TObject);
begin
 if ShellListView.SelectedFolder<>nil then
  begin
   DoShellFolderVerb(ShellListView.SelectedFolder,'delete');
   ButtonRefreshClick(Sender);
  end;
end;

function TBodyRecycleForm.DoShellFolderVerb(AFolder: TShellFolder; Verb: PChar):HRESULT;
var
  ICI: TCMInvokeCommandInfo;
  CM: IContextMenu;
  PIDL: PItemIDList;
begin
  Result:=E_FAIL;
  if AFolder = nil then Exit;

  FillChar(ICI, SizeOf(ICI), #0);
  with ICI do
  begin
    cbSize := SizeOf(ICI);
    fMask := CMIC_MASK_ASYNCOK;
    hWND := Handle;
    lpVerb := Verb;
    nShow := SW_SHOWNORMAL;
  end;
  PIDL := AFolder.RelativeID;
  CM:=nil;
  AFolder.ParentShellFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IContextMenu, nil, CM);
  if CM<>nil then
   Result:=CM.InvokeCommand(ICI)
  else
   Result:=E_FAIL;
  CM:=nil;
end;

end.
