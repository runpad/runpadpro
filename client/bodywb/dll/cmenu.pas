
unit cmenu;

interface

uses Windows, Messages, Classes, ActiveX;



procedure ProcessContextMenu(dwID: LongWord; x,y : integer;
                      const pcmdtReserved: IInterface; const pdispReserved: IDispatch);



implementation

uses SysUtils, Variants, ShlObj, ieconst, mshtml, global;

{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}


const
      IDM_MY_REFRESH    = 6042;
      IDM_MY_SAVEIMG    = 40001;
      IDM_MY_PRINTIMG   = 40002;
      IDM_MY_SAVETARGET = 40003;

      IDR_BROWSE_CONTEXT_MENU  = 24641;
      IDR_FORM_CONTEXT_MENU    = 24640;
      SHDVID_GETMIMECSETMENU   = 27;
      SHDVID_ADDMENUEXTENSIONS = 53;


procedure crop_separators(h_menu:HMENU);
var mii:MENUITEMINFO;
    itemcount,i:integer;
begin
itemcount:=getmenuitemcount(h_menu);
if itemcount<=0 then exit;
for i:=itemcount-1 downto 0 do
   begin
      fillchar(mii,sizeof(mii),0);
      mii.cbSize:=sizeof(mii);
      mii.fMask:=MIIM_TYPE;
      if getmenuiteminfo(h_menu,i,true,mii) then
       begin
        if (mii.fType and MFT_SEPARATOR)<>0 then
         deletemenu(h_menu,i,MF_BYPOSITION);
       end;
   end;
end;


procedure crop_menu(h_menu:HMENU;item_ids:array of integer);
var itemcount,i,ii:integer;
    id:integer;
    need:boolean;
begin
itemcount:=getmenuitemcount(h_menu); if itemcount<=0 then exit;

for i:=itemcount-1 downto 0 do
   begin
    id:=getmenuitemid(h_menu,i);
    need:=false;
    for ii:=low(item_ids) to high(item_ids) do
     if id=item_ids[ii] then
       need:=true;
    if not need then
     deletemenu(h_menu,i,MF_BYPOSITION);
   end;
end;


// Показываем меню (предварительно его модифицируем) ///////////////////////////
procedure show_menu(menu_id:integer;const dwID: DWORD; const ppt: PPOINT;
  const pcmdtReserved: IUnknown; const pdispReserved: IDispatch;pictureURL,hrefURL:string);
label l_end;
var
    hinstSHDOCLC:HINST;
    handle:HWND;
    h_MainMenu,h_Menu:HMENU;
    spCT:IOleCommandTarget;
    spWnd:IOleWindow;
    vvar:OleVariant;
    iSelection:integer;
    vardata:pvardata;
    MenuFlags:UINT;
    mii:MENUITEMINFO;
    path:string;
begin
if pcmdtReserved=nil then
 exit;
if pcmdtReserved.QueryInterface(IOleCommandTarget,spCT)<>s_ok then
 exit;
if pcmdtReserved.QueryInterface(IOleWindow,spWnd)<>s_ok then
 exit;

spWnd.GetWindow(handle);

hinstSHDOCLC:=LoadLibrary('ieframe.dll.mui');

if IsRunningUnderVistaLonghorn() then
 begin
  if hinstSHDOCLC=0 then
   hinstSHDOCLC:=LoadLibrary('ieframe.dll');
 end;

if hinstSHDOCLC=0 then
 hinstSHDOCLC:=LoadLibrary('shdoclc.dll');
if hinstSHDOCLC=0 then
 exit;

h_MainMenu:=LoadMenu(hinstSHDOCLC,MakeIntResource(IDR_BROWSE_CONTEXT_MENU));
h_Menu:=getsubmenu(h_MainMenu,dwId); // Загружаем меню, которое предлагается

if h_menu=0 then
 goto l_end;

// Начинаем модифицировать меню
case menu_id of
     1: begin// Клик на картинке
        crop_menu(h_Menu,[]);
        AppendMenu(h_Menu,MF_STRING,IDM_MY_SAVEIMG,LSP(1500));
        if not is_simple then
         begin
          AppendMenu(h_Menu,MF_STRING,IDM_MY_PRINTIMG,LSP(1501));
         end;
        end;
     2: begin // Клик на ссылке
        crop_menu(h_Menu,[IDM_FOLLOWLINKC,IDM_FOLLOWLINKN,{IDM_SAVETARGET,}IDM_COPY,IDM_COPYSHORTCUT]);
        AppendMenu(h_Menu,MF_SEPARATOR,0,nil);
        AppendMenu(h_Menu,MF_STRING,IDM_MY_SAVETARGET,LSP(1575));
        end;
     3: begin // Клик на картинке-ссылке
        crop_menu(h_Menu,[IDM_FOLLOWLINKC,IDM_FOLLOWLINKN,{IDM_SAVETARGET,}IDM_COPYSHORTCUT]);
        AppendMenu(h_Menu,MF_SEPARATOR,0,nil);
        AppendMenu(h_Menu,MF_STRING,IDM_MY_SAVEIMG,LSP(1500));
        if not is_simple then
         begin
          AppendMenu(h_Menu,MF_STRING,IDM_MY_PRINTIMG,LSP(1501));
         end;
        AppendMenu(h_Menu,MF_SEPARATOR,0,nil);
        AppendMenu(h_Menu,MF_STRING,IDM_MY_SAVETARGET,LSP(1575));
        end;
     4: begin // Клик на выделенном тексте
        crop_menu(h_menu,[IDM_COPY]);
        end;
     5: begin // Клик на элементе управления
        crop_separators(h_menu);
        end;
     6: begin // Клик где-нибудь еще
        if not g_config.disable_view_html then
          crop_menu(h_menu,[IDM_GOBACKWARD,IDM_GOFORWARD,IDM_SELECTALL,IDM_MY_REFRESH,IDM_LANGUAGE,IDM_VIEWSOURCE])
        else
          crop_menu(h_menu,[IDM_GOBACKWARD,IDM_GOFORWARD,IDM_SELECTALL,IDM_MY_REFRESH,IDM_LANGUAGE]);
        vvar:=NULL;
        if spCT.Exec(@CGID_ShellDocView,SHDVID_GETMIMECSETMENU,0,NULL,vvar)=s_ok then
         begin
          vardata:=FindVarData(vvar);
          if vardata<>nil then
           begin
            fillchar(mii,sizeof(mii),0);
            mii.cbSize:=sizeof(mii);
            mii.fMask:=MIIM_SUBMENU;
            mii.hSubMenu:=HMENU(vardata^.VInteger);
            SetMenuItemInfo(h_menu,IDM_LANGUAGE,false,mii);
           end;
         end;
        end;
end;

MenuFlags:=TPM_LEFTALIGN or TPM_RIGHTBUTTON or TPM_RETURNCMD or TPM_NONOTIFY;
iSelection:=integer(TrackPopupMenu(h_Menu,MenuFlags,ppt.X,ppt.Y,0,handle,nil));

case iSelection of
     0: begin end; //Ничего не делаем

     IDM_MY_SAVEIMG:
      begin
       DownloadFileAsync(pictureUrl,'');
      end;

     IDM_MY_SAVETARGET:
      begin
       if hrefUrl<>'' then
        DownloadFileAsync(hrefUrl,'');
      end;

     IDM_MY_PRINTIMG:
      begin
       path:= '"'+GetModuleName(0)+'" "'+pictureUrl+'"';
       WinExecW(pwidechar(widestring(path)));
      end;

     IDM_VIEWSOURCE:
      begin
       PostMessage(handle,msg_viewsource,0,0);
      end;

else
     SendMessage(handle,WM_COMMAND,iSelection,0);
end;

l_end:
 DestroyMenu(h_MainMenu);
 FreeLibrary(hinstSHDOCLC);
 spWnd:=nil;
 spCT:=nil;
end;

// Проверяем на каком элементе проихошел клик. Если на картинке, то возвращаем еще ее URL
function checktarget(const dwID: DWORD;
  const ppt: PPOINT; const pcmdtReserved: IInterface;
  const pdispReserved: IDispatch; var pictureURL, hrefURL: string): integer;
var pElem:IHTMLElement;
    IsPicture, IsUrl, IsInput : boolean;
begin
   result:=0;
   pictureURL:='';
   hrefURL:='';

   if (dwid>7) then
      exit;

   if pdispreserved=nil then
    exit;

   if pdispreserved.QueryInterface(IID_IHTMLElement,pElem)<>s_ok then
    exit;

   IsPicture := WideUpperCase(pElem.tagName) = 'IMG';
   if IsPicture then
    begin
      pictureURL:=AnsiString(pElem.getAttribute('src',0));
      CorrectFileUrl(pictureURL);
    end;

   IsInput:=(WideUpperCase(pElem.tagName) = 'INPUT') or (WideUpperCase(pElem.tagName) = 'TEXTAREA');

   IsUrl:=false;
   while true do
    begin
     if WideUpperCase(pElem.tagName) = 'A' then begin IsUrl:=true; hrefURL:=AnsiString(pElem.getAttribute('href',0)); CorrectFileUrl(hrefURL); break; end;
     if (WideUpperCase(pElem.tagName) = 'HTML') or (WideUpperCase(pElem.tagName) = 'BODY') then break;
     pElem := pElem.parentElement;
    end;

   pElem:=nil;

   if dwID = 4 then
    begin
     result:=4;
     exit;
    end;

   if IsInput then
    begin
     result:=5;
     exit;
    end;

   if IsPicture and not IsUrl then
    begin
     result:=1;
     exit;
    end;

   if not IsPicture and IsUrl then
    begin
     result:=2;
     exit;
    end;

   if IsPicture and IsUrl then
    begin
     result:=3;
     exit;
    end;

   result:=6;
end;


procedure ProcessContextMenu(dwID: LongWord; x,y : integer;
                              const pcmdtReserved: IInterface; const pdispReserved: IDispatch);
var menu_id:integer;
    pictureURL, hrefURL:string;
    p : TPoint;
begin
 p.x:=x;
 p.y:=y;

 try
  menu_id:=checktarget(dwID,@p,pcmdtReserved,pdispReserved,pictureURL,hrefURL);
  if (menu_id >= 1) and (menu_id <= 6) then
   show_menu(menu_id,dwID,@p,pcmdtReserved,pdispReserved,pictureURL,hrefURL);
 except end;
end;


end.
