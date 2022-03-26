unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, ToolWin, ExtCtrls, OleCtrls, CommCtrl,
  ComObj, Registry, ActiveX, Shdocvw, MSHTMLCustomUI, MyWebBrowser, ADODB_TLB, CDO_TLB,
  Menus, ShellCtrls, Clipbrd;

type
  TBodyIEForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ImageListStatic: TImageList;
    ImageList: TImageList;
    ButtonBack: TToolButton;
    ButtonForward: TToolButton;
    ButtonStop: TToolButton;
    ButtonRefresh: TToolButton;
    PanelSplit: TPanel;
    StatusBar: TStatusBar;
    Animate: TAnimate;
    Timer: TTimer;
    ToolButton1: TToolButton;
    ButtonPrint: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ButtonSave: TToolButton;
    ButtonNew: TToolButton;
    ButtonFind: TToolButton;
    AddressToolBar: TToolBar;
    AddressBar: TComboBoxEx;
    ButtonGo: TToolButton;
    ButtonZoom: TToolButton;
    SearchBar: TComboBoxEx;
    PanelFav: TPanel;
    Splitter: TSplitter;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    ShellListViewFav: TShellListView;
    ToolButtonAddFav: TToolButton;
    ToolButton6: TToolButton;
    ToolButtonCloseFav: TToolButton;
    PopupMenuFav: TPopupMenu;
    MenuFavDel: TMenuItem;
    MenuFavChangeName: TMenuItem;
    MenuFavChangeURL: TMenuItem;
    MenuFavCopy: TMenuItem;
    MenuFavOpen: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ImageListFav: TImageList;
    ToolButton5: TToolButton;
    ButtonFav: TToolButton;
    ButtonMail: TToolButton;
    procedure AddressBarKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AddressBarSelect(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ButtonForwardClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonFindClick(Sender: TObject);
    procedure ButtonZoomClick(Sender: TObject);
    procedure SaveWebPage();
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure AddressBarKeyPress(Sender: TObject; var Key: Char);
    procedure AddressToolBarResize(Sender: TObject);
    procedure ButtonGoClick(Sender: TObject);
    procedure SearchBarDropDown(Sender: TObject);
    procedure SearchBarSelect(Sender: TObject);
    procedure SearchBarKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchBarEndEdit(Sender: TObject);
    procedure ToolButtonAddFavClick(Sender: TObject);
    procedure ToolButtonCloseFavClick(Sender: TObject);
    procedure ShellListViewFavChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure ShellListViewFavEnter(Sender: TObject);
    procedure MenuFavOpenClick(Sender: TObject);
    procedure MenuFavDelClick(Sender: TObject);
    procedure MenuFavChangeNameClick(Sender: TObject);
    procedure MenuFavChangeURLClick(Sender: TObject);
    procedure MenuFavCopyClick(Sender: TObject);
    procedure ShellListViewFavClick(Sender: TObject);
    procedure ButtonFavClick(Sender: TObject);
    procedure ShellListViewFavContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ButtonMailClick(Sender: TObject);
  private
    WebBrowser: TMyWebBrowser;
    progress_value : integer;
    FOleInPlaceActiveObject : IOleInPlaceActiveObject;
    SearchEngine: pointer;
    zoom_idx:integer;
    procedure LoadCommonHistory();
    procedure AddToCommonHistory(s : string);
    procedure ViewHTMLSource();
    procedure FavSwitch();
    procedure FavShow();
    procedure FavHide();
    procedure FavUpdate();
    function FavNavigate(path:string):boolean;
    procedure FavPrepareObject();
    function IsFavVisible:boolean;
    function GetFavPath:string;
    function GetFavSelection:string;
    procedure FavGetURLAndNameFromFile(s:string;var name,url:string);
    procedure ChangeURLInFile(s,url:string);
    procedure AddToFav();
    function PathEqu(s1,s2:string):boolean;
    function FavDialog(var name,url:string):boolean;
    procedure NavigateFailed();
    procedure URLRedirection(const url:string);
    procedure RunBodyToolWithParms(tool,parms:string);
    procedure OnLanguageChanged();
    procedure SetCaption(const fmt:string);
    procedure UpdateTitleIcon();
    function IsWBWindow(w:HWND):boolean;
    procedure SetZoom(scale_perc:integer);
    procedure ZoomIn();
    procedure ZoomOut();
    procedure Zoom100();
    procedure WebBrowserNavigateComplete2(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserNewWindow2(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
    procedure WebBrowserTitleChange(Sender: TObject; const Text: WideString);
    procedure WebBrowserBeforeNavigate2(Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,     Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowserStatusTextChange(Sender: TObject; const Text: WideString);
    procedure WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
    procedure WebBrowserWindowSetWidth(ASender: TObject; Width: Integer);
    procedure WebBrowserWindowSetHeight(ASender: TObject; Height: Integer);
    procedure WebBrowserStatusBar(ASender: TObject; StatusBar: WordBool);
    procedure WebBrowserToolBar(ASender: TObject; ToolBar: WordBool);
    procedure WebBrowserWindowSetResizable(ASender: TObject; Resizable: WordBool);
    procedure WebBrowserVisible(Sender: TObject; Visible: WordBool);
    procedure WebBrowserClientToHostWindow(ASender: TObject; var CX: Integer; var CY: Integer);
    procedure WebBrowserWindowSetLeft(ASender: TObject; Left: Integer);
    procedure WebBrowserWindowSetTop(ASender: TObject; Top: Integer);
    procedure WebBrowserProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
  public
    navigate_url : string;
    function GetWebBrowserApp:IDispatch;
    function ProcessOwnMessage(msg:TMsg):boolean;
  end;


implementation

uses StrUtils, ShellApi, global, fav, save_query, tools, wininet;

{$R *.dfm}
{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}
{$INCLUDE url.inc}




const ZOOM_SCALE_MIN_IDX = 0;
const ZOOM_SCALE_MAX_IDX = 8;
const ZOOM_SCALE_100_IDX = 4;

const zoom_scale : array [ZOOM_SCALE_MIN_IDX..ZOOM_SCALE_MAX_IDX] of integer = (10,25,50,75,100,125,150,200,400);


const HISTORY_LIMIT = 50;

const
  SearchEngineGoogle    : string = 'Google';
  SearchEngineYandex    : string = 'Yandex';
  SearchEngineRambler   : string = 'Rambler';
  SearchEngineAport     : string = 'Aport';
  SearchEngineMailru    : string = 'Mail.Ru';
  SearchEngineYahoo     : string = 'Yahoo';
  SearchEngineAltavista : string = 'Altavista';
  SearchEngineLive      : string = 'Live';


function GetSysDrivePathWithBackslash:string;
var s:string;
    p:array[0..MAX_PATH] of char;
    drive:char;
begin
 s:=GetEnvironmentVariable('SystemDrive');
 if s='' then
  begin
   p[0]:=#0;
   GetWindowsDirectory(p,sizeof(p));
   s:=p;
  end;

 if (length(s)>=2) and (s[2]=':') then
  drive:=UpperCase(s[1])[1]
 else
  drive:='C';

 if (ord(drive)<ord('C')) or (ord(drive)>ord('Z')) then
  drive:='C';

 Result:=drive+':\';
end;


procedure TBodyIEForm.OnLanguageChanged();
begin
   ButtonNew.Hint:=                         LS(1511);
   ButtonBack.Hint:=                        LS(1512);
   ButtonForward.Hint:=                     LS(1513);
   ButtonStop.Hint:=                        LS(1514);
   ButtonRefresh.Hint:=                     LS(1515);
   ButtonFind.Hint:=                        LS(1516);
   ButtonPrint.Hint:=                       LS(1517);
   ButtonZoom.Hint:=                        LS(1576);
   ButtonSave.Hint:=                        LS(1521);
   ButtonFav.Hint:=                         LS(1523);
   ButtonMail.Hint:=                        LS(1524);
   CoolBar.Bands[1].Text:=                  LS(1525);
   CoolBar.Bands[3].Text:=                  LS(1526);
   ButtonGo.Caption:=                       LS(1527);
   ToolButtonAddFav.Caption:=               LS(1528);
   ToolButtonAddFav.Hint:=                  LS(1529);
   ToolButtonCloseFav.Caption:=             LS(1530);
   ToolButtonCloseFav.Hint:=                LS(1531);
   MenuFavOpen.Caption:=                    LS(1532);
   MenuFavDel.Caption:=                     LS(1533);
   MenuFavChangeName.Caption:=              LS(1534);
   MenuFavChangeURL.Caption:=               LS(1535);
   MenuFavCopy.Caption:=                    LS(1536);
end;


procedure WBFindDialog(AWebBrowser: TWebbrowser) ;
const
  CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
  HTMLID_FIND = 1;
var
  CmdTarget : IOleCommandTarget;
  vaIn, vaOut: OleVariant;
  PtrGUID: PGUID;
begin
  New(PtrGUID) ;
  PtrGUID^ := CGID_WebBrowser;
  if AWebBrowser.Document <> nil then
    try
      AWebBrowser.Document.QueryInterface(IOleCommandTarget, CmdTarget);
      if CmdTarget <> nil then
        try
          CmdTarget.Exec(PtrGUID, HTMLID_FIND, 0, vaIn, vaOut);
        finally
          CmdTarget:=nil;
        end;
    except
    end;
  Dispose(PtrGUID) ;
end;


procedure TBodyIEForm.AddToCommonHistory(s : string);
var
  reg : TRegistry;
  CurrentHistItem : integer;
begin
  reg:=TRegistry.Create(KEY_WRITE or KEY_READ);
  reg.LazyWrite:=FALSE;
  if reg.OpenKey(string(g_config.regpath)+'\IEHistory',TRUE) then
    begin
      try
        CurrentHistItem := reg.ReadInteger('Last') + 1;
        if (CurrentHistItem >= HISTORY_LIMIT) or (CurrentHistItem < 0) then
          CurrentHistItem := 0;
      except
        CurrentHistItem := 0;
      end;

      try
        reg.WriteInteger('Last', CurrentHistItem);
        reg.WriteString('Item' + IntToStr(CurrentHistItem),s);
      except
      end;

      reg.CloseKey;
    end;
  reg.Free;
end;


procedure TBodyIEForm.LoadCommonHistory();
var
  reg : TRegistry;
  s   : String;
  i   : integer;
  CurrentHistItem : integer;
begin
  reg:=TRegistry.Create(KEY_READ);
  if reg.OpenKeyReadOnly(string(g_config.regpath)+'\IEHistory') then
    begin
      try
        CurrentHistItem := reg.ReadInteger('Last');
      except
        CurrentHistItem := 0;
      end;

      for i := CurrentHistItem downto 0 do
        try
          s := reg.ReadString('Item' + IntToStr(i));
          if Length(s)>0 then
            AddressBar.ItemsEx.AddItem(s,0,0,0,0,nil);
        except
        end;

      for i := HISTORY_LIMIT downto CurrentHistItem + 1 do
        try
          s := reg.ReadString('Item' + IntToStr(i));
          if Length(s)>0 then
            AddressBar.ItemsEx.AddItem(s,0,0,0,0,nil);
        except
        end;

      reg.CloseKey;
    end;
  reg.Free;
end;


procedure TBodyIEForm.NavigateFailed();
var s:string;
    p:array[0..MAX_PATH] of char;
begin
  p[0]:=#0;
  GetModuleFileName(hInstance,@p,sizeof(p));
  
  s := 'res://' + string(p) + '/failed.htm';
  
  try
    WebBrowser.Navigate(WideString(s));
  except
  end;
end;

procedure TBodyIEForm.URLRedirection(const url:string);
begin
  try
    WebBrowser.Navigate(WideString(url));
  except
  end;
end;

function TBodyIEForm.IsWBWindow(w:HWND):boolean;
var root:HWND;
begin
 Result:=false;

 if (w<>0) and IsWindow(w) and ((GetWindowLong(w,GWL_STYLE) and WS_CHILD)<>0) then
  begin
   if WebBrowser<>nil then
    begin
     root:=TWinControl(WebBrowser).Handle;
     if root<>0 then
      begin
       while (w<>0) and (w<>root) do
        w:=Windows.GetAncestor(w,GA_PARENT);

       Result:=(w=root);
      end;
    end;
  end;
end;

function TBodyIEForm.ProcessOwnMessage(msg:TMsg):boolean;
var
  ctrl,alt: boolean;
  p:pstring;
begin
 Result:=false;

 if Msg.message = cardinal(msg_vipend) then
  begin
   FavHide();
   exit;
  end;
 
 if Msg.message = cardinal(msg_langchanged) then
  begin
   //if WebBrowser<>nil then
   // OnLanguageChanged();   some bugs in delphi controls with this
   exit;
  end;

 if IsWBWindow(Msg.hwnd) then
  begin
   if Msg.message = cardinal(msg_viewsource) then
    begin
     Result:=true;
     ViewHTMLSource();
     exit;
    end;

   if Msg.message = cardinal(msg_navigatefailed) then
    begin
     Result:=true;
     NavigateFailed();
     exit;
    end;

   if Msg.message = cardinal(msg_redirection) then
    begin
     Result:=true;
     p:=pstring(Msg.lParam);
     URLRedirection(p^);
     dispose(p);
     exit;
    end;

   ctrl:=(GetAsyncKeyState(VK_CONTROL) and $8000)<>0;
   alt:=(GetAsyncKeyState(VK_MENU) and $8000)<>0;

   //if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('F')) and ctrl then
   // if WebBrowser.Busy then
   //   WebBrowser.Stop;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('N')) and ctrl then
    begin
     Result:=true;
     ButtonNewClick(nil);
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('P')) and ctrl then
    begin
     Result:=true;
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('I')) and ctrl then
    begin
     Result:=true;
     FavSwitch();
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('D')) and ctrl then
    begin
     Result:=true;
     AddToFav();
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and ((Msg.wParam = VK_ADD) or (Msg.wParam = $BB{VK_OEM_PLUS})) and ctrl then
    begin
     Result:=true;
     ZoomIn();
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and ((Msg.wParam = VK_SUBTRACT) or (Msg.wParam = $BD{VK_OEM_MINUS})) and ctrl then
    begin
     Result:=true;
     ZoomOut();
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = byte('0')) and ctrl then
    begin
     Result:=true;
     Zoom100();
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_F5) then
    begin
     Result:=true;
     ButtonRefreshClick(nil);
     exit;
    end;

   if (Msg.message = WM_KEYDOWN) and (Msg.wParam = VK_ESCAPE) and (not ctrl) and (not alt) then
    begin
     //Result:=true;
     ButtonStopClick(nil);
     //exit;
    end;

   if (Msg.message >= WM_KEYFIRST) and (Msg.message <= WM_KEYLAST) then
    begin
     if FOleInPlaceActiveObject<>nil then
       Result:=(FOleInPlaceActiveObject.TranslateAccelerator(Msg) = S_OK);
    end;
  end;
end;

function TBodyIEForm.GetWebBrowserApp:IDispatch;
begin
 Result:=WebBrowser.Application;
end;

procedure TBodyIEForm.WebBrowserClientToHostWindow(ASender: TObject; var CX: Integer; var CY: Integer);
begin
 inc(cx,Width-WebBrowser.Width);
 inc(cy,Height-WebBrowser.Height);
end;

procedure TBodyIEForm.WebBrowserWindowSetLeft(ASender: TObject; Left: Integer);
begin
// Self.Left := Left;
 SetWindowPos(Handle,0,Left,Top,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOOWNERZORDER or SWP_NOZORDER);
end;

procedure TBodyIEForm.WebBrowserWindowSetTop(ASender: TObject; Top: Integer);
begin
// Self.Top := Top;
 SetWindowPos(Handle,0,Left,Top,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOOWNERZORDER or SWP_NOZORDER);
end;

procedure TBodyIEForm.WebBrowserWindowSetWidth(ASender: TObject; Width: Integer);
begin
// Self.Width := Width;
 SetWindowPos(Handle,0,0,0,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOOWNERZORDER or SWP_NOZORDER);
end;

procedure TBodyIEForm.WebBrowserWindowSetHeight(ASender: TObject; Height: Integer);
begin
// Self.Height := Height;
 SetWindowPos(Handle,0,0,0,Width,Height,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOOWNERZORDER or SWP_NOZORDER);
end;

procedure TBodyIEForm.WebBrowserVisible(Sender: TObject; Visible: WordBool);
begin
 Self.Visible:=Visible;
end;

procedure TBodyIEForm.WebBrowserWindowSetResizable(ASender: TObject; Resizable: WordBool);
begin
 if Resizable then
  begin
   BorderIcons:=[biSystemMenu,biMinimize,biMaximize];
  end
 else
  begin
   BorderIcons:=[biSystemMenu,biMinimize];
  end;
 UpdateTitleIcon();
end;

procedure TBodyIEForm.WebBrowserStatusBar(ASender: TObject; StatusBar: WordBool);
begin
 Self.StatusBar.Visible:=StatusBar;
end;

procedure TBodyIEForm.WebBrowserToolBar(ASender: TObject; ToolBar: WordBool);
begin
 Self.CoolBar.Visible:=ToolBar;
 Self.PanelSplit.Visible:=ToolBar;
end;

procedure TBodyIEForm.WebBrowserWindowClosing(ASender: TObject; IsChildWindow: WordBool; var Cancel: WordBool);
begin
 if (Visible) and (CoolBar.Visible) then
  begin
   Cancel:=TRUE;
  end
 else
  begin
   Cancel:=FALSE;
   Release;
  end;
end;

procedure TBodyIEForm.WebBrowserNewWindow2(Sender: TObject;  var ppDisp: IDispatch; var Cancel: WordBool);
var t:IDispatch;
begin
 Cancel:=FALSE;
 t:=AddBrowser(handle,'',false);
 if t=nil then
   Cancel:=TRUE
 else
   ppDisp:=t;
 t:=nil;
end;

procedure TBodyIEForm.SetCaption(const fmt:string);
begin
 Caption:=AnsiReplaceText(fmt,'%APP%',LS(1542));
end;

procedure TBodyIEForm.WebBrowserTitleChange(Sender: TObject;  const Text: WideString);
begin
 SetCaption(AnsiReplaceText(string(g_config.bodywb_caption),'%TITLE%',string(Text)));
end;

procedure TBodyIEForm.WebBrowserStatusTextChange(Sender: TObject; const Text: WideString);
begin
 StatusBar.Panels[0].Text:=' '+Text;
end;

procedure TBodyIEForm.WebBrowserProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
begin
 if (progress=-1) or (progressmax=0) then
  progress_value:=-1
 else
  progress_value:=progress*100 div progressmax;

 StatusBar.Invalidate;
end;

procedure TBodyIEForm.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var width,full_width:integer;
    r:TRect;
begin
 full_width:=Rect.Right-Rect.Left;

 if full_width=0 then
  exit;
 
 width:=0;
 if progress_value<>-1 then
  begin
   width:=progress_value*full_width div 100;
   if width=0 then
    width:=1;
  end;

 if width>0 then
  begin
   StatusBar.Canvas.Brush.Style:=bsSolid;
   StatusBar.Canvas.Brush.Color:=$A00000;
   r:=Rect;
   r.Right:=r.Left+width;
   StatusBar.Canvas.FillRect(r);
   StatusBar.Canvas.Brush.Color:=StatusBar.Color;
  end;

 if full_width-width>0 then
  begin
   StatusBar.Canvas.Brush.Style:=bsSolid;
   StatusBar.Canvas.Brush.Color:=StatusBar.Color;
   r:=Rect;
   r.Left:=r.Left+width;
   StatusBar.Canvas.FillRect(r);
  end;
end;


procedure TBodyIEForm.UpdateTitleIcon();
var
  hIcon : THandle;
begin
  hIcon := LoadImage(HInstance, PChar(101), IMAGE_ICON, 16, 16, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_SMALL, hIcon);
  //SetClassLong(Handle,GCL_HICONSM,hIcon);
  hIcon := LoadImage(HInstance, PChar(101), IMAGE_ICON, 32, 32, LR_SHARED);
  SendMessage(Handle, WM_SETICON, ICON_BIG, hIcon);
  //SetClassLong(Handle,GCL_HICON,hIcon);
end;


procedure TBodyIEForm.FormCreate(Sender: TObject);
var
  i : integer;
  s: string;
begin
  zoom_idx:=ZOOM_SCALE_100_IDX;  // default is 100%, but not always true (ex. 120 DPI screen)
  
  WebBrowser:=TMyWebBrowser.Create(self);
  TWinControl(WebBrowser).Parent:=self;
  with TWebBrowser(WebBrowser) do
   begin
    Align := alClient;
    OnStatusTextChange := WebBrowserStatusTextChange;
    OnTitleChange := WebBrowserTitleChange;
    OnBeforeNavigate2 := WebBrowserBeforeNavigate2;
    OnNewWindow2 := WebBrowserNewWindow2;
    OnNavigateComplete2 := WebBrowserNavigateComplete2;
    OnWindowClosing := WebBrowserWindowClosing;
    OnWindowSetWidth := WebBrowserWindowSetWidth;
    OnWindowSetHeight := WebBrowserWindowSetHeight;
    OnWindowSetLeft := WebBrowserWindowSetLeft;
    OnWindowSetTop := WebBrowserWindowSetTop;
    OnStatusBar := WebBrowserStatusBar;
    OnToolBar := WebBrowserToolBar;
    OnWindowSetResizable := WebBrowserWindowSetResizable;
    OnVisible := WebBrowserVisible;
    OnClientToHostWindow := WebBrowserClientToHostWindow;
    OnProgressChange := WebBrowserProgressChange;
   end;

  ImageList.Handle := ImageList_Create(32, 32, ILC_MASK or ILC_COLOR32, 1, 1);
  for i:=200 to 214 do
    ImageList_AddIcon(ImageList.Handle, LoadImage(hinstance,pchar(i),IMAGE_ICON,32,32,0));


//  try
//    CoolBar.Bitmap.LoadFromFile(ExtractFilePath(Application.ExeName)+'default_skin.bmp');
//  except end;
  CoolBar.Bands[0].MinWidth := ButtonMail.Left + ButtonMail.Width + 2;

  SetCaption('%APP%');
  
  UpdateTitleIcon();
  
  progress_value:=-1;
  navigate_url:='';

  FOleInPlaceActiveObject:=nil;
  if WebBrowser.Application<>nil then
     WebBrowser.Application.QueryInterface(IOleInPlaceActiveObject,FOleInPlaceActiveObject);

  WebBrowser.OleObject.Silent:=false;
  WebBrowser.OleObject.RegisterAsDropTarget:=false;
  WebBrowser.OleObject.RegisterAsBrowser:=true;

  try
   Animate.ResID:=300;
  except end;
  Timer.Enabled:=TRUE;

  ButtonPrint.Enabled:=g_config.allow_ie_print;
  //ButtonEncoding.Visible:=false;
  MenuFavDel.Enabled:=not g_config.disallow_add2fav;
  MenuFavChangeName.Enabled:=not g_config.disallow_add2fav;
  MenuFavChangeURL.Enabled:=not g_config.disallow_add2fav;
  ToolButtonAddFav.Enabled:=not g_config.disallow_add2fav;

  LoadCommonHistory();

  if g_config.wb_search_bars then
   begin
    SearchBar.ItemsEx.AddItem(SearchEngineGoogle,  1,1,-1,-1, pointer(@SearchEngineGoogle));
    SearchBar.ItemsEx.AddItem(SearchEngineYandex,  2,2,-1,-1, pointer(@SearchEngineYandex));
    SearchBar.ItemsEx.AddItem(SearchEngineRambler, 3,3,-1,-1, pointer(@SearchEngineRambler));
    SearchBar.ItemsEx.AddItem(SearchEngineAport,   4,4,-1,-1, pointer(@SearchEngineAport));
    SearchBar.ItemsEx.AddItem(SearchEngineMailru,  5,5,-1,-1, pointer(@SearchEngineMailru));
    SearchBar.ItemsEx.AddItem(SearchEngineYahoo,   6,6,-1,-1, pointer(@SearchEngineYahoo));
    SearchBar.ItemsEx.AddItem(SearchEngineAltavista, 7,7,-1,-1, pointer(@SearchEngineAltavista));
    SearchBar.ItemsEx.AddItem(SearchEngineLive, 8,8,-1,-1, pointer(@SearchEngineLive));
   end;

  if (SearchBar.ItemsEx.Count > 0) then
    begin
      SearchBar.Visible := true;
      SearchBar.ItemIndex := 0;
      SearchEngine := SearchBar.ItemsEx.Items[0].Data;
    end
  else
    begin
      SearchBar.Visible := false;
      SearchEngine := nil;
    end;

  s:=string(g_config.fav_path);
  if s='' then
   ButtonFav.Visible:=false;

  ButtonMail.Visible:=g_config.bodymail_integration;

  OnLanguageChanged();

  if is_simple then
   begin
    CoolBar.Visible:=false;
    PanelSplit.Visible:=false;
    SetProp(Handle,'_NoClose',1);
    if not is_notopmost then
     begin
      SetWindowLong(Handle,GWL_EXSTYLE,GetWindowLong(Handle,GWL_EXSTYLE) or WS_EX_TOPMOST);
      SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
     end;
   end;
end;


procedure TBodyIEForm.FormDestroy(Sender: TObject);
begin
 RemoveProp(Handle,'_NoClose');

 Timer.Enabled:=FALSE;
 
 try
  Animate.Active:=FALSE;
 except end;
 
 FOleInPlaceActiveObject:=nil;

 SendMessage(Handle, WM_SETICON, ICON_SMALL, 0);
 SendMessage(Handle, WM_SETICON, ICON_BIG, 0);

 FreeAndNil(WebBrowser);

 RemoveBrowser(Self);
end;


procedure TBodyIEForm.FormShow(Sender: TObject);
begin
  if navigate_url<>'' then
    SetForegroundWindow(Handle);  //some problems with this

  WebBrowser.SetFocus;

  if navigate_url<>'' then
   begin
    try
     WebBrowser.Navigate(WideString(navigate_url));
    except
    end;
   end;
end;


function GetURLFileExtension(url:string):string;
var n:integer;
    ext,s:string;
begin
 s:=url;
 
 for n:=length(s) downto 1 do
  if (s[n]='?') or (s[n]='#') then
   begin
    SetLength(s,n-1);
    break;
   end;

 ext:='';
 for n:=length(s) downto 1 do
  if s[n]='.' then
   begin
    ext:=Copy(s,n+1,length(s)-n);
    break;
   end;

 Result:=ext;
end;


function IsSitesRestrictionTurnedOff:boolean;
var n : integer;
begin
 Result:=false;
 for n:=1 to ParamCount do
  if ParamStr(n)='-r' then
   begin
    Result:=true;
    break;
   end;
end;


procedure TBodyIEForm.WebBrowserBeforeNavigate2(Sender: TObject;  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,  Headers: OleVariant; var Cancel: WordBool);
var s,ext:string;
    atom1,atom2,rc:integer;
    w:HWND;
    t:array[0..MAX_PATH-1] of char;
    p:pstring;
    {frames:boolean;
    n:integer;
    fname:string;}
begin
 Cancel:=TRUE;

 s:=URL;
 ext:=GetURLFileExtension(s);

 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
  begin
   if length(s)>250 then
    setlength(s,250);
   atom1:=GlobalAddAtom(pchar(s));
   atom2:=GlobalAddAtom(pchar(ext));
   if not IsSitesRestrictionTurnedOff then
     rc:=SendMessage(w,g_config.msg_site_restrict1,atom1,atom2)
   else
     rc:=SendMessage(w,g_config.msg_site_restrict2,atom1,atom2);
   if rc=0 then
    Cancel:=FALSE
   else
    begin
     if rc=1 then
      Cancel:=TRUE
     else
     if rc=2 then
      begin
        Cancel:=TRUE;

        //problems with this (ex. banners, etc...)
        {if (TargetFrameName=NULL) or (string(TargetFrameName)='') then
         frames:=false
        else
         begin
          frames:=true;
          fname:=TargetFrameName;
          for n:=1 to length(fname) do
           if fname[n]=':' then  //todo: find better way, ex. webbrowser.document.frames....
            begin
             frames:=false;
             break;
            end;
         end;
        
        if not frames then
          PostMessage(WebBrowser.Handle,msg_navigatefailed,0,0);}
      end
     else
     if rc<0 then
      begin
       Cancel:=TRUE;
       atom1:=rc and $FFFF;
       t[0]:=#0;
       GlobalGetAtomName(atom1,t,MAX_PATH);
       GlobalDeleteAtom(atom1);
       new(p);
       p^:=string(t);
       PostMessage(WebBrowser.Handle,msg_redirection,0,cardinal(p));
      end
     else 
      begin
       Cancel:=TRUE;
       DownloadFileAsync(url,WebBrowser.LocationURL);
      end;
    end;
  end;
end;


procedure TBodyIEForm.SetZoom(scale_perc:integer);
var V : OleVariant;
begin
 if WebBrowser.Document<>nil then
  begin
   try
    V := scale_perc;
    WebBrowser.ExecWB(63{OLECMDID_OPTICAL_ZOOM}, OLECMDEXECOPT_DONTPROMPTUSER, V);
   except end;
  end;
end;

procedure TBodyIEForm.ZoomIn();
begin
 if zoom_idx<ZOOM_SCALE_MAX_IDX then
  begin
   inc(zoom_idx);
   SetZoom(zoom_scale[zoom_idx]);
  end;
end;

procedure TBodyIEForm.ZoomOut();
begin
 if zoom_idx>ZOOM_SCALE_MIN_IDX then
  begin
   dec(zoom_idx);
   SetZoom(zoom_scale[zoom_idx]);
  end;
end;

procedure TBodyIEForm.Zoom100();
begin
 zoom_idx:=ZOOM_SCALE_100_IDX;
 SetZoom(zoom_scale[zoom_idx]);
end;

function IsFlashFile(const filename:pchar):boolean;
var len:cardinal;
begin
 Result:=false;
 if filename<>nil then
  begin
   len:=StrLen(filename);
   if len>4 then
    begin
     Result:=(StrIComp(pchar(cardinal(filename)+len-4),'.swf')=0);
    end;
  end;
end;

procedure ClearFlashesFromIECache();
var buff:pointer;
    buffsize:integer;
    rcsize:DWORD;
    h:cardinal;
    cont:boolean;
    i:PINTERNETCACHEENTRYINFOA;
begin
 buffsize:=32768;
 GetMem(buff,buffsize);
 rcsize:=buffsize;
 h:=FindFirstUrlCacheEntryEx(nil,0,NORMAL_CACHE_ENTRY,0,PINTERNETCACHEENTRYINFOA(buff),@rcsize,nil,nil,nil);
 cont:=h<>0;
 while cont do
  begin
   i:=PINTERNETCACHEENTRYINFOA(buff);

   if (i.CacheEntryType=0) or ((i.CacheEntryType and NORMAL_CACHE_ENTRY)<>0) then
    begin
     if IsFlashFile(i.lpszLocalFileName)
        //or IsHeaderFlash(i.lpHeaderInfo,i.dwHeaderInfoSize)  // find here Content-type: application/x-shockwave-flash
        then
      begin
       if i.lpszSourceUrlName<>nil then
        DeleteUrlCacheEntry(i.lpszSourceUrlName);
      end;
    end;

   rcsize:=buffsize;
   cont:=FindNextUrlCacheEntryEx(h,PINTERNETCACHEENTRYINFOA(buff),@rcsize,nil,nil,nil);
  end;
 if h<>0 then
  FindCloseUrlCache(h);

 FreeMem(buff);
end;


// see about this bug:
// http://bugs.adobe.com/jira/browse/FP-256
// http://blogs.msdn.com/b/johan/archive/2009/08/06/problems-with-flash-content-in-the-webbrowser-control.aspx
procedure FlashBugWorkaround(const url:string);
var host:string;
begin
 host:=GetUrlHost(url);
 if host<>'' then
  begin
   if PathMatchSpec(pchar(host),'vkontakte.ru') or
      PathMatchSpec(pchar(host),'*.vkontakte.ru') or
      PathMatchSpec(pchar(host),'vk.com') or
      PathMatchSpec(pchar(host),'*.vk.com') or
      PathMatchSpec(pchar(host),'odnoklassniki.ru') or
      PathMatchSpec(pchar(host),'*.odnoklassniki.ru') or
      PathMatchSpec(pchar(host),'odnoklasniki.ru') or
      PathMatchSpec(pchar(host),'*.odnoklasniki.ru') or
      PathMatchSpec(pchar(host),'facebook.com') or
      PathMatchSpec(pchar(host),'*.facebook.com') or
      PathMatchSpec(pchar(host),'games.mail.ru') or
      PathMatchSpec(pchar(host),'minigames.mail.ru') then
   begin
    ClearFlashesFromIECache();
   end;
  end;
end;

procedure TBodyIEForm.WebBrowserNavigateComplete2(Sender: TObject;  const pDisp: IDispatch; var URL: OleVariant);
var CustDoc : ICustomDoc;
    w: IWebBrowser2;
begin
 if pDisp=nil then
  exit;

 w:=pDisp as IWebBrowser2;
 
 if w.Document<>nil then
  if w.Document.QueryInterface(ICustomDoc, CustDoc) = S_OK then
   begin
    CustDoc:=nil;

    AddressBar.Text:=URL;
    AddURL2Stat(pchar(string(URL)));
    g_last_url := URL;

    try
     if (GetForegroundWindow() = Handle) and (not IsIconic(Handle)) then
      begin
        WebBrowser.SetFocus;
        WebBrowser.SetFocusToDoc;
      end;
    except end;
   end;

 w:=nil;

 try
  FlashBugWorkaround(string(URL));
 except
 end;

end;


procedure TBodyIEForm.AddressBarSelect(Sender: TObject);
var
  i    : integer;
  new  : boolean;
  surl : string;
begin
  surl:=Trim(AddressBar.Text);
  if surl='' then
    exit;
  if (StrScan(PChar(surl),':')=nil) and (surl[1]<>'\') then
    surl:='http://'+surl;

  new := true;
  for i:=0 to AddressBar.ItemsEx.Count-1 do
    if AddressBar.ItemsEx.ComboItems[i].Caption = surl then
      new := false;

  if new then
    begin
      if AddressBar.ItemsEx.Count >= HISTORY_LIMIT then
        begin
          for i:=AddressBar.ItemsEx.Count-1 downto 1 do
            AddressBar.ItemsEx.Items[i].Caption := AddressBar.ItemsEx.Items[i-1].Caption;
          AddressBar.ItemsEx.Delete(AddressBar.ItemsEx.Count - 1);
        end;
      AddressBar.ItemsEx.Insert(0).Caption := surl;
      AddToCommonHistory(surl);
    end;

  try
    WebBrowser.Navigate(WideString(surl));
  except
  end;
end;


procedure TBodyIEForm.AddressBarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key = VK_UP ) or ( key = VK_DOWN ) then
    key := 255;

 if (key=byte('I')) and (ssCtrl in shift) then
   FavSwitch();

 if (key=byte('D')) and (ssCtrl in shift) then
   AddToFav();

  if Key = VK_RETURN then
    AddressBarSelect(Sender);
end;


procedure TBodyIEForm.ButtonBackClick(Sender: TObject);
begin
   try
   WebBrowser.GoBack;
   except
   end;
   WebBrowser.SetFocus;
   WebBrowser.SetFocusToDoc;
end;


procedure TBodyIEForm.ButtonForwardClick(Sender: TObject);
begin
   try
   WebBrowser.GoForward;
   except
   end;
   WebBrowser.SetFocus;
   WebBrowser.SetFocusToDoc;
end;


procedure TBodyIEForm.ButtonStopClick(Sender: TObject);
begin
   try
   WebBrowser.Stop;
   except
   end;
end;


procedure TBodyIEForm.ButtonRefreshClick(Sender: TObject);
begin
  FavUpdate;
  try
   WebBrowser.Refresh;
   WebBrowser.SetFocus;
   WebBrowser.SetFocusToDoc;
  except end;
end;


procedure TBodyIEForm.ButtonPrintClick(Sender: TObject);
var vaIn,vaOut: OleVariant;
begin
  if WebBrowser.Document=nil then
   Exit;
  
  vaIn:=NULL;
  vaOut:=NULL;

  if MessageBox(Handle,LSP(1543),LSP(LS_QUESTION),MB_YESNO or MB_ICONQUESTION) = ID_YES then
   begin
    try
     WebBrowser.ControlInterface.ExecWB(OLECMDID_PRINT,OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
     //MessageBox(Handle,'Print started!','Information',MB_OK or MB_ICONINFORMATION);
    except end;
   end;
end;


procedure TBodyIEForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if key=VK_F6 then
  begin
   AddressBar.SetFocus;
   AddressBar.SelectAll;
  end;
 if key=VK_F5 then
   ButtonRefreshClick(Sender);
 if key=VK_ESCAPE then
   ButtonStopClick(Sender);
 if (key=VK_LEFT) and (ssAlt in shift) then
   ButtonBackClick(Sender);
 if (key=VK_RIGHT) and (ssAlt in shift) then
   ButtonForwardClick(Sender);
// if (key=byte('F')) and (ssCtrl in shift) then
//   ButtonFindClick(Sender);
// if (key=byte('I')) and (ssCtrl in shift) then
//   FavSwitch();
end;


procedure TBodyIEForm.TimerTimer(Sender: TObject);
begin
 try
  Animate.Active:=WebBrowser.Busy;
 except end;
end;


procedure PrepareFileNameCompatibleTitle(var title:string);
var n:integer;
begin
 if Length(title)>100 then
  SetLength(title,100);
 
 for n:=1 to Length(title) do
  if byte(title[n]) in [33..39,42,43,44,47,58..64,91..96,123..127] then
   title[n]:='_';
end;


procedure TBodyIEForm.SaveWebPage();
var FPersistFile : IPersistFile;
    title,savepath : string;
    rc:integer;
    Msg: IMessage;
    Conf: IConfiguration;
    Stream: _Stream;
    URL : widestring;
    t : array [0..1024] of char;
    all:boolean;
    save_form:TSaveForm;
    dwSize : DWORD;
begin
  if (WebBrowser.Busy) or (WebBrowser.Document=nil) then
   Exit;

  save_form:=TSaveForm.Create(nil);
  rc:=save_form.ShowModal;
  save_form.Free;

  if rc=mrCancel then
   Exit;

  all:=rc=mrYes;

  repeat
   if RPOpenSaveDialog(Handle, LSP(1544),LSP(LS_QUESTION),t,nil) = RPOPENSAVE_CANCEL then
    Exit;
   savepath:=t;
  until savepath<>'';

  if savepath[length(savepath)]<>'\' then
   savepath:=savepath+'\';

  try
     title:=WebBrowser.OleObject.Document.Title;

     t[0]:=#0;
     dwSize:=sizeof(t);
     if UrlGetPart(pchar(string(WebBrowser.LocationURL)),t,@dwSize,URL_PART_HOSTNAME,0)=S_OK then
      title:=string(t)+'-'+title;

     PrepareFileNameCompatibleTitle(title);
     
     title:='saved_'+title+'_'+inttostr(GetTickCount() mod 100);
     if all then
      title:=title+'.mht'
     else
      title:=title+'.htm';

     if not all then
      begin
       // only HTML
       FPersistFile:=nil;
       WebBrowser.Document.QueryInterface(IPersistFile,FPersistFile);
       if FPersistFile<>nil then
        begin
         FPersistFile.Save(pwidechar(WideFormat('%s%s',[savepath,title])),false);
         FPersistFile:=nil;
        end;
      end
     else
      begin
       // all in MHT archive
       Screen.Cursor:=crHourGlass;
       URL:=WebBrowser.LocationURL;
       Msg:=CoMessage.Create;
       Conf:=CoConfiguration.Create;
       if (Msg<>nil) and (Conf<>nil) then
        begin
         Msg.Configuration:=Conf;
         Msg.CreateMHTMLBody(URL,cdoSuppressNone,'','');
         Stream:=Msg.GetStream;
         if Stream<>nil then
          Stream.SaveToFile(WideFormat('%s%s',[savepath,title]),adSaveCreateOverWrite);
        end;
       Stream:=nil;
       Msg:=nil;
       Conf:=nil;
       Screen.Cursor:=crDefault;
      end;

     MessageBox(Handle,pchar(Format(LS(1545),[title])),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);

  except
   Screen.Cursor:=crDefault;
   MessageBox(Handle,LSP(1546),LSP(LS_ERR),MB_OK or MB_ICONERROR);
  end;
end;


procedure TBodyIEForm.ButtonSaveClick(Sender: TObject);
begin
 SaveWebPage();
end;

procedure TBodyIEForm.ButtonNewClick(Sender: TObject);
begin
 WinExecW(pwidechar(widestring(GetModuleName(0))));
end;


procedure TBodyIEForm.ButtonFindClick(Sender: TObject);
begin
 try
  if WebBrowser.Busy then
   WebBrowser.Stop;
  WBFindDialog(WebBrowser);
 except end;
end;


procedure TBodyIEForm.ButtonZoomClick(Sender: TObject);
begin
 if WebBrowser.Document<>nil then
  begin
   if zoom_idx<ZOOM_SCALE_100_IDX then
    zoom_idx:=ZOOM_SCALE_100_IDX
   else
   if zoom_idx=ZOOM_SCALE_100_IDX then
    zoom_idx:=ZOOM_SCALE_100_IDX+1
   else
   if zoom_idx=ZOOM_SCALE_100_IDX+1 then
    zoom_idx:=ZOOM_SCALE_100_IDX+2
   else
   if zoom_idx>=ZOOM_SCALE_100_IDX+2 then
    zoom_idx:=ZOOM_SCALE_100_IDX;
   SetZoom(zoom_scale[zoom_idx]);
  end;
end;


procedure TBodyIEForm.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
 if CoolBar.Visible then
  begin
   MinWidth:=CoolBar.Bands[0].MinWidth+100;
   MinHeight:=200;
  end;
end;

procedure TBodyIEForm.FormClose(Sender: TObject; var Action: TCloseAction);
var V : OleVariant;
begin
 // Reset font size to default
 try
  V := 2;
  WebBrowser.ExecWB(OLECMDID_ZOOM, OLECMDEXECOPT_DONTPROMPTUSER, V);
 except end;

 Action:=caFree;

 try
  if WebBrowser.Busy then
    WebBrowser.Stop;
 except end;
end;

procedure TBodyIEForm.FormHide(Sender: TObject);
begin
 FavHide;
// HideBrowser(Self);
end;


procedure TBodyIEForm.AddressBarKeyPress(Sender: TObject; var Key: Char);
const
  LowCase:string = 'f,dult;pbqrkvyjghcnea[wxio]sm''.z';
  UpCase :string = 'F<DULT:PBQRKVYJGHCNEA{WXIO}SM">Z';
begin
  if g_config.rus2eng_wb then
    begin
      if ( ord(key) >= ord('à')) {and ( ord(key) <= ord('ÿ') )} {ALWAYS TRUE!} then
        key := LowCase[ord(key)-ord('à')+1];
      if ( ord(key) >= ord('À')) and ( ord(key) <= ord('ß') ) then
        key := UpCase[ord(key)-ord('À')+1];
    end;
end;

procedure TBodyIEForm.AddressToolBarResize(Sender: TObject);
begin
  AddressBar.Width := AddressToolBar.Width - ButtonGo.Width - 4;
end;

procedure TBodyIEForm.ButtonGoClick(Sender: TObject);
begin
  AddressBar.SetFocus;
  AddressBarSelect(AddressBar);
end;

procedure TBodyIEForm.SearchBarDropDown(Sender: TObject);
begin
  if SearchBar.ItemIndex >= 0 then
    with SearchBar do
      ItemsEx.Items[ItemIndex].Caption := string(ItemsEx.Items[ItemIndex].Data^);
end;

procedure TBodyIEForm.SearchBarSelect(Sender: TObject);
begin
  if SearchBar.ItemIndex >= 0 then
    begin
      SearchEngine := SearchBar.ItemsEx.Items[SearchBar.ItemIndex].Data;
      SearchBar.ItemsEx.Items[SearchBar.ItemIndex].Caption := '';
    end;
end;

procedure TBodyIEForm.SearchBarEndEdit(Sender: TObject);
begin
  if (SearchBar.ItemIndex >= 0) then
    SearchBar.ItemsEx.Items[SearchBar.ItemIndex].Caption := SearchBar.Text;
end;

procedure TBodyIEForm.SearchBarKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
type TUrlEscape = function(s:pchar): pchar; cdecl;
var
  sText: string;
begin
  if ( key = VK_UP ) or ( key = VK_DOWN ) then
    key := 255;

  if Key = VK_RETURN then
    begin
      if (SearchEngine = @SearchEngineGoogle) then
          sText := 'http://www.google.com/search?q=' + UrlEncodeUTF8(SearchBar.Text);
      if (SearchEngine = @SearchEngineYandex) then
          sText := 'http://www.yandex.ru/yandsearch?rpt=rad&text=' + UrlEncode(SearchBar.Text);
      if (SearchEngine = @SearchEngineRambler) then
          sText := 'http://www.rambler.ru/srch?words=' + UrlEncode(SearchBar.Text);
      if (SearchEngine = @SearchEngineAport) then
          sText := 'http://sm.aport.ru/scripts/template.dll?That=std&from=au_ru&r=' + UrlEncode(SearchBar.Text);
      if (SearchEngine = @SearchEngineMailru) then
          sText := 'http://go.mail.ru/search?lfilter=y&q=' + UrlEncode(SearchBar.Text);
      if (SearchEngine = @SearchEngineYahoo) then
          sText := 'http://search.yahoo.com/search?p=' + UrlEncodeUTF8(SearchBar.Text);
      if (SearchEngine = @SearchEngineAltavista) then
          sText := 'http://www.altavista.com/web/results?itag=ody&q=' + UrlEncodeUTF8(SearchBar.Text);
      if (SearchEngine = @SearchEngineLive) then
          sText := 'http://search.live.com/results.aspx?q=' + UrlEncodeUTF8(SearchBar.Text);

      AddressBar.Text := sText;
      AddressBarSelect(AddressBar);
    end;
end;


procedure TBodyIEForm.ViewHTMLSource();
var FPersistFile : IPersistFile;
    s,savepath:string;
    temp:array[0..MAX_PATH] of char;
    w:HWND;
    atom:integer;
begin
 if (WebBrowser.Document=nil) or (WebBrowser.Busy) then
  exit;

 temp[0]:=#0;
 GetTempPath(sizeof(temp),@temp);
 savepath:=temp;
 if (length(savepath)>0) and (savepath[length(savepath)]<>'\') then
  savepath:=savepath+'\';
 savepath:=savepath+'source.htm';

 try
  FPersistFile:=nil;
  WebBrowser.Document.QueryInterface(IPersistFile,FPersistFile);
  if FPersistFile<>nil then
   begin
    DeleteFile(pchar(savepath));
    if FPersistFile.Save(pwidechar(WideFormat('%s',[savepath])),false) = S_OK then
     begin
      s:=savepath;
      setlength(s,length(s)-3);
      s:=s+'txt';
      DeleteFile(pchar(s));
      MoveFile(pchar(savepath),pchar(s));
      
      // we do not use ShellExecute here, because CreateProcess can be blocked
      w:=FindWindow('_RunpadClass',nil);
      if w<>0 then
       begin
        atom:=GlobalAddAtom(pchar(s));
        if atom<>0 then
         PostMessage(w,g_config.msg_shellexecute,atom,0);
       end;
     end;
    FPersistFile:=nil;
   end;
 except end;
end;


procedure TBodyIEForm.ToolButtonAddFavClick(Sender: TObject);
begin
 AddToFav();
end;

procedure TBodyIEForm.ToolButtonCloseFavClick(Sender: TObject);
begin
 FavHide;
end;

procedure TBodyIEForm.ShellListViewFavChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
 AllowChange:=not g_config.disallow_add2fav;
end;

procedure TBodyIEForm.ShellListViewFavEnter(Sender: TObject);
begin
 try
  PanelFav.SetFocus;
 except end;
end;

procedure TBodyIEForm.MenuFavOpenClick(Sender: TObject);
begin
 ShellListViewFavClick(sender);
end;

procedure TBodyIEForm.MenuFavDelClick(Sender: TObject);
var s:string;
begin
 s:=GetFavSelection();
 if s<>'' then
  begin
   if MessageBox(Handle,LSP(1547),LSP(LS_QUESTION),MB_YESNO or MB_ICONQUESTION) = ID_YES then
    begin
     Windows.DeleteFile(pchar(s));
     FavUpdate;
    end;
  end;
end;

procedure TBodyIEForm.MenuFavChangeNameClick(Sender: TObject);
var s,name,url:string;
begin
 s:=GetFavSelection();
 if s<>'' then
  begin
   name:='';
   url:='';
   FavGetURLAndNameFromFile(s,name,url);

   if FavDialog(name,url) then
    begin
     PrepareFileNameCompatibleTitle(name);

     if (name<>'') and (url<>'') then
      begin
       Windows.DeleteFile(pchar(s));
       s:=GetFavPath();
       if s<>'' then
        begin
         s:=IncludeTrailingPathDelimiter(s)+name+'.url';
         ChangeURLInFile(s,url);
        end;
       FavUpdate;
      end;
    end;
  end;
end;

procedure TBodyIEForm.MenuFavChangeURLClick(Sender: TObject);
begin
 MenuFavChangeNameClick(Sender);
end;

procedure TBodyIEForm.MenuFavCopyClick(Sender: TObject);
var s,name,url:string;
begin
 s:=GetFavSelection();
 if s<>'' then
  begin
   name:='';
   url:='';
   FavGetURLAndNameFromFile(s,name,url);
   if url<>'' then
    begin
     try
      Clipboard.Open;
      Clipboard.Clear;
      Clipboard.SetTextBuf(pchar(url));
      Clipboard.Close;
     except end;
    end;
  end;
end;

procedure TBodyIEForm.ShellListViewFavClick(Sender: TObject);
var s,name,url:string;
begin
 s:=GetFavSelection();
 if s<>'' then
  begin
   name:='';
   url:='';
   FavGetURLAndNameFromFile(s,name,url);
   if url<>'' then
    begin
     if ((GetAsyncKeyState(VK_SHIFT) and $8000)<>0) then
      begin
       WinExecW(pwidechar(widestring('"'+GetModuleName(0)+'" -nohome "'+url+'"')));
      end
     else
      begin
       AddressBar.Text := url;
       AddressBarSelect(AddressBar);
       //FavHide;
      end;
    end;
  end;
end;

procedure TBodyIEForm.ButtonFavClick(Sender: TObject);
begin
 FavSwitch();
end;

procedure TBodyIEForm.FavSwitch();
begin
 if IsFavVisible then
  FavHide
 else
  FavShow;
end;

procedure TBodyIEForm.FavShow();
var s:string;
begin
 if (not IsFavVisible) and (not is_simple) and (ButtonFav.Visible) and (CoolBar.Visible) then
  begin
   s:=GetFavPath;
   if s='' then
    begin
     MessageBox(Handle,LSP(1548), LSP(LS_INFO), MB_OK or MB_ICONWARNING);
     ButtonFav.Down:=false;
     exit;
    end;
   
   if not FavNavigate(s) then
    begin
     MessageBox(Handle,LSP(1549), LSP(LS_ERR), MB_OK or MB_ICONERROR);
     ButtonFav.Down:=false;
     exit;
    end;
   
   FavPrepareObject();
   
   PanelFav.Visible:=true;
   Splitter.Visible:=true;
   ButtonFav.Down:=true;
  end;
end;

procedure TBodyIEForm.FavHide();
begin
 if IsFavVisible then
  begin
   Splitter.Visible:=false;
   PanelFav.Visible:=false;
   ButtonFav.Down:=false;

   try
    ShellListViewFav.Root:=GetSysDrivePathWithBackslash;
   except end;
  end;
end;

procedure TBodyIEForm.FavUpdate();
begin
 if IsFavVisible then
  begin
   ShellListViewFav.Visible:=false;
   try
    ShellListViewFav.Refresh;
   except end;
   FavPrepareObject();
   ShellListViewFav.Visible:=true;
  end;
end;

function TBodyIEForm.IsFavVisible:boolean;
begin
 Result:=PanelFav.Visible;
end;

function TBodyIEForm.FavNavigate(path:string):boolean;
var rc:boolean;
begin
 rc:=true;

 try
  ShellListViewFav.Root:=path;
 except
  rc:=false;
 end;
 
 if rc then
  begin
   while not PathEqu(ShellListViewFav.Root,Path) do // loop introduced due to bug: Root changed from the second attempt
     try
       ShellListViewFav.Root:=Path;
     except
       rc:=false;
       break;
     end;
  end;

 if not rc then
  begin
   try
    ShellListViewFav.Root:=GetSysDrivePathWithBackslash;
   except end;
  end;

 Result:=rc;
end;

procedure TBodyIEForm.FavPrepareObject();
var n:integer;
begin
  ShellListViewFav.HotTrackStyles:=[htHandPoint, htUnderlineHot];
  //ShellListViewFav.FlatScrollBars:=true;
  for n:=0 to ShellListViewFav.Columns.Count-1 do
   begin
    ShellListViewFav.Columns[n].AutoSize:=false;
    ShellListViewFav.Columns[n].MaxWidth:=0;
    ShellListViewFav.Columns[n].MinWidth:=0;
    ShellListViewFav.Columns[n].Width:=0;
   end;
  ShellListViewFav.Columns[0].Width:=ShellListViewFav.Width-22;
  ShellListViewFav.Columns[0].AutoSize:=true;
end;

function TBodyIEForm.GetFavPath:string;
var s:array[0..MAX_PATH] of char;
begin
 s[0]:=#0;
 GetFavoritesPath(@s);
 Result:=string(s);
end;

function TBodyIEForm.GetFavSelection:string;
var s:string;
begin
 Result:='';

 if IsFavVisible then
  begin
   if ShellListViewFav.SelectedFolder<>nil then
    begin
     s:=ShellListViewFav.SelectedFolder.PathName;
     if s<>'' then
      begin
       if AnsiLowerCase(ExtractFileExt(s))='.url' then
        Result:=s;
      end;
    end;
  end;
end;

procedure TBodyIEForm.ShellListViewFavContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var p:TPoint;
begin
 Handled:=TRUE;

 if GetFavSelection()<>'' then
  begin
   GetCursorPos(p);
   PopupMenuFav.Popup(p.X,p.Y);
  end;
end;

procedure TBodyIEForm.FavGetURLAndNameFromFile(s:string;var name,url:string);
var ret:array[0..1024] of char;
begin
 name:='';
 url:='';

 if s<>'' then
  begin
   if AnsiLowerCase(ExtractFileExt(s))='.url' then
    begin
     GetPrivateProfileString('InternetShortcut','URL','',@ret,sizeof(ret)-1,pchar(s));
     url:=string(ret);
     if url='' then
      begin
       GetPrivateProfileString('DEFAULT','BASEURL','',@ret,sizeof(ret)-1,pchar(s));
       url:=string(ret);
      end;
     if url<>'' then
      begin
       name:=ExtractFileName(s);
       name:=ChangeFileExt(name,'');
      end;
    end;
  end;
end;

procedure TBodyIEForm.ChangeURLInFile(s,url:string);
begin
 if s<>'' then
  begin
   if AnsiLowerCase(ExtractFileExt(s))='.url' then
    begin
     WritePrivateProfileString('InternetShortcut','URL',pchar(url),pchar(s));
     WritePrivateProfileString('DEFAULT','BASEURL',pchar(url),pchar(s));
    end;
  end;
end;


function TBodyIEForm.PathEqu(s1,s2:string):boolean;
begin
 s1:=IncludeTrailingPathDelimiter(s1);
 s2:=IncludeTrailingPathDelimiter(s2);
 Result:=(AnsiCompareText(s1,s2)=0);
end;

procedure TBodyIEForm.AddToFav();
var s,name,url:string;
begin
 if (not is_simple) and (ButtonFav.Visible) and (CoolBar.Visible) then
  begin
   s:=GetFavPath();
   if s='' then
    begin
     MessageBox(Handle,LSP(1548), LSP(LS_INFO), MB_OK or MB_ICONWARNING);
     exit;
    end;

   if g_config.disallow_add2fav then
    begin
     MessageBox(Handle,LSP(1550), LSP(LS_INFO), MB_OK or MB_ICONWARNING);
     exit;
    end;

   if WebBrowser.Document<>nil then
    begin
     try
      name:=WebBrowser.OleObject.Document.Title;
     except
      name:='';
     end;
     try
      url:=WebBrowser.LocationURL;
     except
      url:='';
     end;
     
     if (name<>'') and (url<>'') then
      begin
       if FavDialog(name,url) then
        begin
         PrepareFileNameCompatibleTitle(name);

         if (name<>'') and (url<>'') then
          begin
           Windows.CreateDirectory(pchar(s),nil);
           s:=IncludeTrailingPathDelimiter(s)+name+'.url';
           ChangeURLInFile(s,url);
           FavUpdate;
          end;
        end;
      end;
    end;
  end;
end;

function TBodyIEForm.FavDialog(var name,url:string):boolean;
var form : TFavForm;
begin
 Result:=false;
 form:=TFavForm.Create(nil);
 form.EditName.Text:=name;
 form.EditURL.Text:=url;
 if form.ShowModal=mrOk then
  begin
   name:=form.EditName.Text;
   url:=form.EditURL.Text;
   Result:=true;
  end;
 form.Free;
end;


procedure TBodyIEForm.RunBodyToolWithParms(tool,parms:string);
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
   WinExecW(pwidechar(widestring(s)));
  end;
end;


procedure TBodyIEForm.ButtonMailClick(Sender: TObject);
begin
 RunBodyToolWithParms('bodymail','');
end;



end.
