
unit MyWebBrowser;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}

interface

uses
    SysUtils, Classes, Controls, Windows, Messages, Variants, ActiveX, OleCtrls,
    UrlMon, SHDocVw, MSHTMLCustomUI, DownloadMgr, cmenu;


type
    TMyWebBrowser = class(TWebBrowser, IDocHostUIHandler, IDocHostShowUI, IDispatch, IServiceProvider, IDownloadManager, IOleCommandTarget)
    protected
        // IDocHostUIHandler
        function ShowContextMenu(dwID: LongWord; var ppt: tagPOINT; const pcmdtReserved: IUnknown;
                                 const pdispReserved: IDispatch): HResult; stdcall;
        function GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult; stdcall;
        function ShowUI(dwID: LongWord; const pActiveObject: IOleInPlaceActiveObject;
                        const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
                        const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
        function HideUI: HResult; stdcall;
        function UpdateUI: HResult; stdcall;
        function EnableModeless(fEnable: Integer): HResult; stdcall;
        function OnDocWindowActivate(fActivate: Integer): HResult; stdcall;
        function OnFrameWindowActivate(fActivate: Integer): HResult; stdcall;
        function ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow;
                              fRameWindow: Integer): HResult; stdcall;
        function TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: LongWord): HResult; stdcall;
        function GetOptionKeyPath(out pchKey: PWideChar; dw: LongWord): HResult; stdcall;
        function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
        function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
        function TranslateUrl(dwTranslate: LongWord; var pchURLIn: Word; out ppchURLOut: PWord1): HResult; stdcall;
        function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;

        // IDocHostShowUI
        function ShowMessage(var hwnd: _RemotableHandle; lpstrText: PWideChar; lpstrCaption: PWideChar;
                             dwType: LongWord; lpstrHelpFile: PWideChar; dwHelpContext: LongWord;
                             out plResult: LONG_PTR): HResult; stdcall;
        function ShowHelp(var hwnd: _RemotableHandle; pszHelpFile: PWideChar; uCommand: SYSUINT;
                          dwData: LongWord; ptMouse: tagPOINT; const pDispatchObjectHit: IDispatch): HResult; stdcall;

        // IDispatch
        function GetIDsOfNames(const IID: TGUID; Names: Pointer;
          NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
        function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
          Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;

        // IServiceProvider
        function QueryService(const rsid, iid: TGuid; out Obj): HResult; stdcall;

        // IDownloadManager
        function Download(
         pmk: IMoniker; // Identifies the object to be downloaded
         pbc: IBindCtx; // Stores information used by the moniker to bind
         dwBindVerb: DWORD; // The action to be performed during the bind
         grfBINDF: DWORD; // Determines the use of URL encoding during the bind
         pBindInfo: PBindInfo; // Used to implement IBindStatusCallback::GetBindInfo
         pszHeaders: PWidechar; // Additional headers to use with IHttpNegotiate
         pszRedir: PWidechar; // The URL that the moniker is redirected to
         uiCP: UINT // The code page of the object's display name
         ): HRESULT; stdcall;

        // IOleCommandTarget
        function QueryStatus(CmdGroup: PGUID; cCmds: Cardinal;
           prgCmds: POleCmd; CmdText: POleCmdText): HResult; stdcall;
        function Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD;
           const vaIn: OleVariant; var vaOut: OleVariant): HResult; stdcall;
    
    public
        procedure SetFocusToDoc;
    end;



implementation

uses global;

{$INCLUDE ..\..\RP_Shared\RP_Shared.inc}


function TMyWebBrowser.EnableModeless(fEnable: Integer): HResult;
begin
    Result := S_FALSE;
end;

function TMyWebBrowser.FilterDataObject(const pDO: IDataObject;
    out ppDORet: IDataObject): HResult;
begin
    ppDORet := NIL;
    Result := S_FALSE;
end;

function TMyWebBrowser.GetDropTarget(const pDropTarget: IDropTarget;
    out ppDropTarget: IDropTarget): HResult;
begin
    ppDropTarget := NIL;
    Result:=S_FALSE;
end;

function TMyWebBrowser.GetExternal(out ppDispatch: IDispatch): HResult;
begin
    ppDispatch := self;
    Result := S_OK;
end;

function TMyWebBrowser.GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult;
begin
    pInfo.cbSize := SizeOf(_DOCHOSTUIINFO);
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_THEME;
    Result := S_OK;
end;

function TMyWebBrowser.GetOptionKeyPath(out pchKey: PWideChar;
    dw: LongWord): HResult;
begin
    pchKey := NIL;
    Result := S_FALSE;
end;

function TMyWebBrowser.HideUI: HResult;
begin
    Result := S_OK;
end;

function TMyWebBrowser.OnDocWindowActivate(fActivate: Integer): HResult;
begin
    Result := S_FALSE;
end;

function TMyWebBrowser.OnFrameWindowActivate(fActivate: Integer): HResult;
begin
    Result := S_FALSE;
end;

function TMyWebBrowser.ResizeBorder(var prcBorder: tagRECT;
    const pUIWindow: IOleInPlaceUIWindow; fRameWindow: Integer): HResult;
begin
    Result := S_FALSE;
end;

function TMyWebBrowser.ShowContextMenu(dwID: LongWord; var ppt: tagPOINT;
    const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HResult;
begin
 ProcessContextMenu(dwId,ppt.x,ppt.y,pcmdtReserved,pdispReserved);
 Result:=S_OK;
end;

function TMyWebBrowser.ShowUI(dwID: LongWord;
    const pActiveObject: IOleInPlaceActiveObject;
    const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
    const pDoc: IOleInPlaceUIWindow): HResult;
begin
    Result := S_OK;
end;

function TMyWebBrowser.TranslateAccelerator(var lpmsg: tagMSG;
    var pguidCmdGroup: TGUID; nCmdID: LongWord): HResult;
begin
   Result := S_FALSE;
end;

function TMyWebBrowser.TranslateUrl(dwTranslate: LongWord; var pchURLIn: Word;
    out ppchURLOut: PWord1): HResult;
begin
    ppchURLOut := NIL;
    Result := S_FALSE;
end;

function TMyWebBrowser.UpdateUI: HResult;
begin
    Result := S_OK;
end;

function TMyWebBrowser.ShowHelp(var hwnd: _RemotableHandle;
    pszHelpFile: PWideChar; uCommand: SYSUINT; dwData: LongWord;
    ptMouse: tagPOINT; const pDispatchObjectHit: IDispatch): HResult;
begin
    Result := S_OK;
end;

function TMyWebBrowser.ShowMessage(var hwnd: _RemotableHandle; lpstrText,
    lpstrCaption: PWideChar; dwType: LongWord; lpstrHelpFile: PWideChar;
    dwHelpContext: LongWord; out plResult: LONG_PTR): HResult;
begin
      plResult := 0;
      Result := E_NOTIMPL;
end;


function TMyWebBrowser.GetIDsOfNames(const IID: TGUID; Names: Pointer;
    NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
    Result:=inherited GetIDsOfNames(IID,Names,NameCount,LocaleID,DispIDs);
end;


function TMyWebBrowser.Invoke(DispID: Integer; const IID: TGUID;
    LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
    ArgErr: Pointer): HResult;
var i: integer;
begin
    if DispID=DISPID_AMBIENT_DLCONTROL then
    begin
     if VarResult <> nil then
     begin
        i:=0;
        if true then
         begin
          i:=i or DLCTL_DLIMAGES;
          i:=i or DLCTL_VIDEOS;
         end;
        i:=i or DLCTL_BGSOUNDS;
        i:=i or DLCTL_NO_DLACTIVEXCTLS;  //prevent installing ActiveX's
        OleVariant(VarResult^) := i;
     end;
     Result:=S_OK;
    end
    else
        Result := inherited Invoke(DispID,
                                   IID,
                                   LocaleID,
                                   Flags, Params, VarResult, ExcepInfo,
                                   ArgErr);
end;


function TMyWebBrowser.Download(
      pmk: IMoniker; // Identifies the object to be downloaded
      pbc: IBindCtx; // Stores information used by the moniker to bind
      dwBindVerb: DWORD; // The action to be performed during the bind
      grfBINDF: DWORD; // Determines the use of URL encoding during the bind
      pBindInfo: PBindInfo; // Used to implement IBindStatusCallback::GetBindInfo
      pszHeaders: PWidechar; // Additional headers to use with IHttpNegotiate
      pszRedir: PWidechar; // The URL that the moniker is redirected to
      uiCP: UINT // The code page of the object's display name
      ): HRESULT;
var
  s: string;
  pwUrl : pwidechar;
  malloc : IMalloc;
begin
  Result := S_OK;

  s:='';
  if pszRedir<>nil then
    s:=string(widestring(pszRedir));
  if s='' then
   begin
    pwUrl:=nil;
    pmk.GetDisplayName(pbc, nil, pwUrl);
    if pwUrl<>nil then
     begin
      s:=string(widestring(pwUrl));
      malloc:=nil;
      CoGetMalloc(1,malloc);
      malloc.Free(pwUrl);
      malloc:=nil;
     end;
   end;

  if s<>'' then
   begin
    CorrectFileUrl(s);
    
    if not IsUrlCannotBeDownloadedWithOurDM(pchar(s)) then
      DownloadFileAsync(s,LocationURL)
    else
      Result:=E_NOTIMPL;
   end;
end;

function TMyWebBrowser.QueryService(const rsid, iid: TGuid; out Obj): HResult;
begin
 Result:=E_NOINTERFACE;

 if IsEqualIID(iid,IID_IDownloadManager) then
  begin
   if not g_config.use_std_downloader then
    begin
     pointer(obj):=nil;
     IDownloadManager(obj):=self;
     Result:=S_OK;
    end;
  end;
end;


const
      CGID_DocHostCommandHandler : TGUID = '{f38bc242-b950-11d1-8918-00c04fc2c836}';


function TMyWebBrowser.QueryStatus(CmdGroup: PGUID; cCmds: Cardinal;
  prgCmds: POleCmd; CmdText: POleCmdText): HResult;
var n:integer;
    p:POleCmd;
begin
 if (CmdGroup<>nil) and (IsEqualGuid(CmdGroup^,CGID_DocHostCommandHandler)) then
  begin
   if prgCmds<>nil then
    begin
     for n:=0 to cCmds-1 do
      begin
       p:=POleCmd(cardinal(prgCmds)+cardinal(n)*sizeof(OLECMD));
       if p^.cmdID = OLECMDID_SHOWSCRIPTERROR then
        p^.cmdf := OLECMDF_SUPPORTED or OLECMDF_ENABLED;
      end;

     if CmdText<>nil then
      CmdText^.cwActual:=0;

     Result:=S_OK;
    end
   else
    Result:=E_POINTER;
  end
 else
  Result:=OLECMDERR_E_UNKNOWNGROUP;
end;


function TMyWebBrowser.Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD;
  const vaIn: OleVariant; var vaOut: OleVariant): HResult;
begin
 if (CmdGroup<>nil) and (IsEqualGuid(CmdGroup^,CGID_DocHostCommandHandler)) then
  begin
   if nCmdID=OLECMDID_SHOWSCRIPTERROR then
    begin
     vaOut:=TRUE; //continue running scripts
     Result:=S_OK;
    end
   else
    Result:=OLECMDERR_E_NOTSUPPORTED;
  end
 else
  Result:=OLECMDERR_E_UNKNOWNGROUP;
end;


procedure TMyWebBrowser.SetFocusToDoc;
begin
 if Application<>nil then
  begin
   try
    with (Application as IOleobject) do
     DoVerb(OLEIVERB_UIACTIVATE, nil, Self, 0, Handle, GetClientRect);
   except
   end;
  end;
end;


end.
