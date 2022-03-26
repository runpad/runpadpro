unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ImgList, ToolWin, StdCtrls, ShellCtrls,
  my_preview, config, tools, dropper;

type
  TBodyMobileForm = class(TForm)
    Panel1: TPanel;
    ImageTop: TImage;
    ImageBottom: TImage;
    ImageCenter: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Panel5: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    CoolBar2: TCoolBar;
    ToolBar2: TToolBar;
    ImageList2: TImageList;
    ButtonDelCart: TToolButton;
    Sep3: TToolButton;
    ButtonUpload: TToolButton;
    Bevel2: TBevel;
    Panel6: TPanel;
    PanelPreview: TPanel;
    PanelFiles: TPanel;
    Splitter2: TSplitter;
    ShellListView: TShellListView;
    CoolBar3: TCoolBar;
    ToolBar3: TToolBar;
    ButtonUp: TToolButton;
    ButtonThumb: TToolButton;
    ImageList3: TImageList;
    Sep1: TToolButton;
    ButtonPreview: TToolButton;
    Sep2: TToolButton;
    ButtonAddCart: TToolButton;
    Panel7: TPanel;
    ListView: TListView;
    ImageList4: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShellListViewExit(Sender: TObject);
    procedure ListViewExit(Sender: TObject);
    procedure ShellListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ButtonThumbClick(Sender: TObject);
    procedure ShellListViewClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure ShellListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShellListViewDblClick(Sender: TObject);
    procedure ShellListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListViewDblClick(Sender: TObject);
    procedure ListViewEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure ListViewKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonPreviewClick(Sender: TObject);
    procedure ButtonAddCartClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure ButtonDelCartClick(Sender: TObject);
    procedure ButtonUploadClick(Sender: TObject);
    procedure DropperDropUp(var Files: TStringList);
    procedure DropperCheckTargetWindow(var Allow: Boolean);
    procedure ShellListViewMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure ShellListViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Dropper: TDropper;
    MouseDownX, MouseDownY: integer;
    preview : TMyPreview;
    cart : array of string;
    procedure ContentClick(Sender: TObject);
    procedure FileClick(do_preview:boolean);
    function GetCurrentContent():PContentItem;
    procedure UpdateCartInfo;
    procedure AcceptFiles(hDrop: THandle);
    procedure AddFileToCart(s:string);
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  end;

var
  BodyMobileForm: TBodyMobileForm;

implementation

uses Commctrl, lang, ShellApi;

{$R *.dfm}
{$I ..\rp_shared\rp_shared.inc}


procedure TBodyMobileForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 if (Msg.message=WM_DROPFILES) and (Msg.hwnd=ListView.Handle) then
  begin
   AcceptFiles(Msg.wParam);
   DragFinish(Msg.wParam);
   Handled := True;
  end;
end;

procedure TBodyMobileForm.FormCreate(Sender: TObject);
var n:integer;
    btn:TToolButton;
begin
 dropper:=nil;
 preview:=nil;
 cart:=nil;

 EnableFFDshowForOurApp();

 ReadConfig;

 preview:=TMyPreview.Create(nil);
 preview.Align:=alClient;
 preview.Parent:=PanelPreview;

 Dropper:=TDropper.Create(Self);
 Dropper.Enabled := True;
 Dropper.OnDropUp := DropperDropUp;
 Dropper.OnDropCheck := DropperCheckTargetWindow;

 ImageList1.Handle := ImageList_Create(48, 48, ILC_MASK or ILC_COLOR32, 5, 1);
 for n:=0 to MAXCONTENTICONS-1 do
  ImageList_AddIcon(ImageList1.Handle,   LoadIcon(HInstance, PChar(100+n)));

 ImageList2.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 5, 1);
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(120)));
 ImageList_AddIcon(ImageList2.Handle,   LoadIcon(HInstance, PChar(121)));

 ImageList3.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 5, 1);
 ImageList_AddIcon(ImageList3.Handle,   LoadIcon(HInstance, PChar(130)));
 ImageList_AddIcon(ImageList3.Handle,   LoadIcon(HInstance, PChar(131)));
 ImageList_AddIcon(ImageList3.Handle,   LoadIcon(HInstance, PChar(132)));
 ImageList_AddIcon(ImageList3.Handle,   LoadIcon(HInstance, PChar(133)));

 ImageList4.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 5, 1);

 DragAcceptFiles(ListView.Handle,true);

 for n:=Length(ContentItems)-1 downto 0 do
  begin
   btn:=TToolButton.Create(ToolBar1);
   btn.Style:=tbsCheck;
   btn.Grouped:=true;
   btn.AllowAllUp:=true;
   btn.Down:=false;
   btn.ImageIndex:=ContentItems[n].icon;
   btn.Caption:=ContentItems[n].title;
   btn.OnClick:=ContentClick;
   btn.Parent:=ToolBar1;
  end;

 Caption:=Application.Title + ' (' + S_SUBTITLE + ')';

 ShellListView.ReadOnly:=true;
 SetWindowLong(ShellListView.Handle,GWL_STYLE,GetWindowLong(ShellListView.Handle,GWL_STYLE) and (not LVS_EDITLABELS));

 if UseThumbnails then
  begin
   ButtonThumb.Down:=true;
   ShellListView.ThumbnailView := true;
  end
 else
  begin
   ButtonThumb.Down:=false;
   ShellListView.ViewStyle:=vsReport;
  end;

 ContentClick(nil);
 UpdateCartInfo;

 ClientHeight:=550;
 Width:=1024;
 Left:=(Screen.Width-Width) div 2;
 Top:=(Screen.Height-Height) div 2;
 Constraints.MinHeight:=Height;
 Constraints.MinWidth:=750;

 WindowState:=wsMaximized;

 Application.OnMessage := AppMessage;
end;

procedure TBodyMobileForm.FormDestroy(Sender: TObject);
begin
 Dropper.Free;
 Dropper:=nil;

 preview.Parent:=nil;
 preview.Free;
 preview:=nil;

 cart:=nil;

 FreeConfig;
end;

procedure TBodyMobileForm.FormShow(Sender: TObject);
begin
//
end;

function TBodyMobileForm.GetCurrentContent():PContentItem;
var n:integer;
begin
 Result:=nil;
 for n:=0 to ToolBar1.ButtonCount-1 do
  if ToolBar1.Buttons[n].Down then
   begin
    Result:=@ContentItems[n];
    break;
   end;
end;

procedure TBodyMobileForm.ContentClick(Sender: TObject);
var cnt:PContentItem;
begin
 cnt:=GetCurrentContent();

 ShellListView.Visible:=false;
 ShellListView.Selected:=nil;
 ListView.Selected:=nil;
 ButtonUp.Visible:=false;
 ButtonThumb.Visible:=false;
 Sep1.Visible:=false;
 StatusBar.Panels[0].Text:='';

 FileClick(false);

 WaitCursor(true);
 Application.ProcessMessages;

 if cnt<>nil then
  begin
   try
    if PathEqu(ShellListView.Root,cnt^.path) then
      ShellListView.Refresh
    else
      ShellListView.Root:=cnt^.path;
   except
    MessageBox(Handle,S_ERR_NAVIGATE,S_ERROR,MB_OK or MB_ICONERROR);
    cnt:=nil;
   end;
  end;

 if cnt<>nil then
  begin
   ShellListView.Visible:=true;
   try
    ShellListView.SetFocus;
   except end;
   ButtonThumb.Visible:=true;
   ButtonUp.Visible:=true;
   Sep1.Visible:=true;
   StatusBar.Panels[0].Text:=' '+S_CONTENT+' '+cnt^.title;
  end
 else
  begin
   StatusBar.Panels[0].Text:=' '+S_NO_CONTENT;
  end;

 WaitCursor(false);

 FileClick(false);
end;

procedure TBodyMobileForm.ShellListViewExit(Sender: TObject);
begin
 if ShellListView.Visible then
  begin
   ShellListView.Selected:=nil;
   FileClick(false);
  end;
end;

procedure TBodyMobileForm.ListViewExit(Sender: TObject);
begin
 if ListView.Visible then
  begin
   ListView.Selected:=nil;
   FileClick(false);
  end;
end;

procedure TBodyMobileForm.ShellListViewClick(Sender: TObject);
begin
 if ShellListView.Visible then
  FileClick(false);
end;

procedure TBodyMobileForm.ListViewClick(Sender: TObject);
begin
 if ListView.Visible then
  FileClick(false);
end;

procedure TBodyMobileForm.ShellListViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key=VK_RETURN then
   ShellListViewDblClick(Sender);
 if (key=ord('A')) and (ssCtrl in Shift) then
  begin
   ShellListView.SelectAll;
   FileClick(false);
  end;
 if key=VK_INSERT then
  if ButtonAddCart.Enabled then
   ButtonAddCartClick(Sender);
 if key=VK_BACK then
  ButtonUpClick(Sender);
end;

procedure TBodyMobileForm.ListViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
   ListViewDblClick(Sender);
 if (key=ord('A')) and (ssCtrl in Shift) then
  begin
   ListView.SelectAll;
   FileClick(false);
  end;
 if key=VK_DELETE then
  if ButtonDelCart.Enabled then
   ButtonDelCartClick(Sender);
end;

procedure TBodyMobileForm.ShellListViewKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_HOME,VK_END,VK_PRIOR,VK_NEXT] then
  FileClick(false);
end;

procedure TBodyMobileForm.ListViewKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key in [VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN,VK_HOME,VK_END,VK_PRIOR,VK_NEXT] then
  FileClick(false);
end;

procedure TBodyMobileForm.ShellListViewEditing(Sender: TObject;
  Item: TListItem; var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TBodyMobileForm.ListViewEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TBodyMobileForm.ShellListViewDblClick(Sender: TObject);
var s:string;
begin
 if (ShellListView.SelectedFolder<>nil) and (ShellListView.SelCount=1) then
  begin
   if not ShellListView.SelectedFolder.IsFolder then
    begin
     if ButtonPreview.Enabled then
      ButtonPreviewClick(Sender);
    end
   else
    begin
     s:=ShellListView.Root;
     try
      ShellListView.Root:=ShellListView.SelectedFolder.PathName;
     except
      try
       ShellListView.Root:=s;
       ShellListView.Refresh;
      except end;
     end;
     FileClick(false);
    end;
  end;
end;

procedure TBodyMobileForm.ListViewDblClick(Sender: TObject);
begin
 if ButtonPreview.Enabled then
   ButtonPreviewClick(Sender);
end;

procedure TBodyMobileForm.ButtonThumbClick(Sender: TObject);
begin
 if visible and ButtonThumb.Visible then
  begin
   if ButtonThumb.Down then
    ShellListView.ThumbnailView := true
   else
    ShellListView.ViewStyle:=vsReport;
   ShellListView.Selected:=nil;
   try
    ShellListView.SetFocus;
   except end;
   FileClick(false); 
  end;
end;

procedure TBodyMobileForm.ButtonUpClick(Sender: TObject);
var cnt:PContentItem;
    s,root,top:string;
    n:integer;
begin
 cnt:=GetCurrentContent();
 if cnt<>nil then
  begin
   root:=ShellListView.Root;
   top:=cnt^.path;
   if root<>'' then
    begin
     if not PathEqu(root,top) then
      begin
       s:=root;
       if s[length(s)]='\' then
        SetLength(s,length(s)-1);
       for n:=length(s) downto 1 do
        if s[n]='\' then
         begin
          SetLength(s,n);
          break;
         end;
       try
        ShellListView.Root:=s;
       except
        try
         ShellListView.Root:=root;
        except end;
       end;
       try
        ShellListView.SetFocus;
       except end;
       FileClick(false);
      end;
    end;
  end;
end;

procedure TBodyMobileForm.FileClick(do_preview:boolean);
var sfile:string;
begin
 if ShellListView.Visible and (ShellListView.Selected<>nil) then
  begin
   ButtonDelCart.Enabled:=false;
   if not ShellListView.SelectedFolder.IsFolder then
    begin
     ButtonPreview.Enabled:=true;
     ButtonAddCart.Enabled:=true;
     sfile:=ShellListView.SelectedFolder.PathName;
    end
   else
    begin
     ButtonPreview.Enabled:=false;
     ButtonAddCart.Enabled:=false;
     sfile:='';
    end;
  end
 else
 if ListView.Visible and (ListView.Selected<>nil) then
  begin
   ButtonAddCart.Enabled:=false;
   ButtonPreview.Enabled:=true;
   ButtonDelCart.Enabled:=true;
   sfile:=cart[ListView.Selected.ImageIndex];
  end
 else
  begin
   ButtonPreview.Enabled:=false;
   ButtonAddCart.Enabled:=false;
   ButtonDelCart.Enabled:=false;
   sfile:='';
  end;

 preview.PreviewFile(sfile,do_preview);
end;

procedure TBodyMobileForm.UpdateCartInfo;
var n:integer;
    s:string;
    kbsize:cardinal;
begin
 if ListView.Items.Count=0 then
  begin
   s:=S_EMPTY_CART;
  end
 else
  begin
   kbsize:=0;
   for n:=0 to ListView.Items.Count-1 do
    inc(kbsize,cardinal(ListView.Items[n].Data));
   s:=Format(S_FILL_CART,[ListView.Items.Count,kbsize]);
  end;
 StatusBar.Panels[1].Text:=' '+s;
end;

procedure TBodyMobileForm.ButtonPreviewClick(Sender: TObject);
begin
 FileClick(true);
end;

procedure TBodyMobileForm.ButtonAddCartClick(Sender: TObject);
var i:integer;
begin
 if ShellListView.SelCount>0 then
  begin
   WaitCursor(true);
   for i:=0 to ShellListView.Items.Count-1 do
     if ShellListView.Items[i].Selected then
       AddFileToCart(ShellListView.Folders[i].PathName);
   WaitCursor(false);
  end;
end;

procedure TBodyMobileForm.ButtonDelCartClick(Sender: TObject);
begin
 if ListView.SelCount>0 then
  begin
   ListView.DeleteSelected;
   UpdateCartInfo;
   FileClick(false);
  end;
end;

procedure TBodyMobileForm.AddFileToCart(s:string);
var ext:string;
    n:integer;
    find:boolean;
    kbsize:cardinal;
begin
 if (s='') or (not FileExists(s)) then
  exit;
  
 find:=false;
 for n:=0 to ListView.Items.Count-1 do
  if AnsiCompareText(s,cart[ListView.Items[n].ImageIndex])=0 then
   begin
    find:=true;
    break;
   end;
 if not find then
  begin
   SetLength(cart,Length(cart)+1);
   cart[Length(cart)-1]:=s;
   ImageList_AddIcon(ImageList4.Handle,GetFileNameIcon(s));
   with ListView.Items.Add do
    begin
     ImageIndex:=length(cart)-1;
     Caption:=ExtractFileName(s);
     ext:=AnsiUpperCase(ExtractFileExtStrict(s));
     SubItems.Add(ext);
     kbsize:=GetFileSizeKB(s);
     Data:=pointer(kbsize);
     SubItems.Add(inttostr(kbsize)+' KB');
    end;
   UpdateCartInfo;
  end;
end;

procedure TBodyMobileForm.DropperCheckTargetWindow(var Allow: Boolean);
var p:TPoint;
begin
  GetCursorPos(p);
  Allow:=WindowFromPoint(p)=ListView.Handle;
end;

procedure TBodyMobileForm.DropperDropUp(var Files: TStringList);
var i:integer;
begin
  if ShellListView.SelectedFolder<>nil then
   begin
    for i:=0 to ShellListView.Items.Count - 1 do
     if ShellListView.Items[i].Selected then
       Files.Add(ShellListView.Folders[i].PathName);
   end;
end;

procedure TBodyMobileForm.ShellListViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (abs(MouseDownX-X)+abs(MouseDownY-Y)>10) then
    if ShellListView.SelectedFolder<>nil then
      Dropper.StartDrag;
end;

procedure TBodyMobileForm.ShellListViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDownX := X;
  MouseDownY := Y;
end;

procedure TBodyMobileForm.AcceptFiles(hDrop: THandle);
var
  p : array [0..MAX_PATH] of char;
  i,numfiles: integer;
  s : string;
begin
  numfiles := DragQueryFile(hDrop, $FFFFFFFF, nil, 0);

  for i:=0 to numfiles - 1 do
    begin
      p[0]:=#0;
      DragQueryFile(hDrop, i, p, MAX_PATH);
      s:=string(p);
      if s<>'' then
       AddFileToCart(s);
    end;
end;

procedure TBodyMobileForm.ButtonUploadClick(Sender: TObject);
var n:integer;
    parms:string;
begin
 if ListView.Items.Count=0 then
  begin
   MessageBox(Handle,S_EMPTY_CART,S_INFO,MB_OK or MB_ICONINFORMATION);
  end
 else
  begin
   parms:='-send2';
   for n:=0 to ListView.Items.Count-1 do
     parms:=parms+' "'+cart[ListView.Items[n].ImageIndex]+'"';
   RunBodyToolWithParms('bodybt',parms);
  end;
end;


end.
