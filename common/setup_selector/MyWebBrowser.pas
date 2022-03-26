
unit MyWebBrowser;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}

interface

uses
    SysUtils, Classes, Controls, Windows, Messages, Variants, ActiveX, OleCtrls,
    SHDocVw, MSHTMLCustomUI, Urlmon, DownloadMgr;


type
    TMyGenericFunction = function (Params: array of OleVariant): OleVariant of object;

    TWBDLOption = (dlImages, dlVideos, dlSounds, dlNoScripts, dlNoJava, dlNoActiveXDownload, dlNoActiveXRun, dlResynchronize, dlPragmaNoCache, dlSilent, dlForceOffline);
    TWBDLOptions = set of TWBDLOption;

    TMyWebBrowser = class(TWebBrowser, IDocHostUIHandler, IDocHostShowUI, IDispatch, IServiceProvider, IDownloadManager)
    private
        FExternalDispatch: IDispatch;
        FBindedNames: TStringList;
        FScrollEnabled: boolean;
        FBorder3DEnabled: boolean;
        FContextMenuEnabled: boolean;
        FTextSelectEnabled: boolean;
        FAllowFileDownload: boolean;
        FAllowAlerts: boolean;
        FDLOptions: TWBDLOptions;
        procedure SetScrollEnabled(const Value: boolean);
        procedure SetBorder3DEnabled(const Value: boolean);
        procedure SetContextMenuEnabled(const Value: boolean);
        procedure SetTextSelectEnabled(const Value: boolean);
        procedure SetAllowFileDownload(const Value: boolean);
        procedure SetAllowAlerts(const Value: boolean);
        procedure SetDLOptions(const Value: TWBDLOptions);
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
     public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure SetExternalDispatch(const ppDispatch: IDispatch);
        function InvokeScript(ScriptName: string; ScriptParams: array of OleVariant): OleVariant;
        procedure Bind(Name: WideString; Func: TMyGenericFunction);
        procedure Unbind(Name: WideString);
    published
        property ContextMenuEnabled: boolean read FContextMenuEnabled write SetContextMenuEnabled default False;
        property Border3DEnabled: boolean read FBorder3DEnabled write SetBorder3DEnabled default False;
        property ScrollEnabled: boolean read FScrollEnabled write SetScrollEnabled default False;
        property TextSelectEnabled: boolean read FTextSelectEnabled write SetTextSelectEnabled default False;
        property AllowFileDownload: boolean read FAllowFileDownload write SetAllowFileDownload default False;
        property AllowAlerts: boolean read FAllowAlerts write SetAllowAlerts default False;
        property DLOptions: TWBDLOptions read FDLOptions write SetDLOptions default [dlImages, dlVideos, dlSounds];
    end;


procedure Register;


implementation

const
    IID_IDISPATCH: TGUID = '{00020400-0000-0000-C000-000000000046}';
    IID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
    MyDispIdStart = 10001;

type
    TFuncPtrObj = class
    public
        Func: TMyGenericFunction;
        DispId: SYSINT;
        constructor Create(AFunc: TMyGenericFunction; ADispId: SYSINT);
    end;


constructor TFuncPtrObj.Create(AFunc: TMyGenericFunction; ADispId: SYSINT);
begin
    inherited Create;
    Func := AFunc;
    DispId := ADispId;
end;



{ TMyWebBrowser }


constructor TMyWebBrowser.Create(AOwner: TComponent);
begin
    inherited;
    FBindedNames := TStringList.Create;
    FBindedNames.Duplicates := dupError;
    SetExternalDispatch(Self);
end;

destructor TMyWebBrowser.Destroy;
var n:integer;
begin
    SetExternalDispatch(nil);
    for n:=0 to FBindedNames.Count-1 do
     begin
      FBindedNames.Objects[n].Free;
      FBindedNames.Objects[n]:=nil;
     end;
    FBindedNames.Free;
    FBindedNames:=nil;
    inherited;
end;

procedure TMyWebBrowser.Bind(Name: WideString; Func: TMyGenericFunction);
begin
    FBindedNames.AddObject(Name, TFuncPtrObj.Create(Func, MyDispIdStart + FBindedNames.Count));
end;

procedure TMyWebBrowser.Unbind(Name: WideString);
var idx:integer;
begin
    idx:=FBindedNames.IndexOfName(Name);
    if idx<>-1 then
     begin
      FBindedNames.Objects[idx].Free;
      FBindedNames.Objects[idx]:=nil;
      FBindedNames.Delete(idx);
     end;
end;

procedure TMyWebBrowser.SetBorder3DEnabled(const Value: boolean);
begin
    FBorder3DEnabled := Value;
end;

procedure TMyWebBrowser.SetContextMenuEnabled(const Value: boolean);
begin
    FContextMenuEnabled := Value;
end;

procedure TMyWebBrowser.SetScrollEnabled(const Value: boolean);
begin
    FScrollEnabled := Value;
end;

procedure TMyWebBrowser.SetTextSelectEnabled(const Value: boolean);
begin
    FTextSelectEnabled := Value;
end;

procedure TMyWebBrowser.SetAllowFileDownload(const Value: boolean);
begin
    FAllowFileDownload := Value;
end;

procedure TMyWebBrowser.SetAllowAlerts(const Value: boolean);
begin
    FAllowAlerts := Value;
end;

procedure TMyWebBrowser.SetDLOptions(const Value: TWBDLOptions);
begin
    FDLOptions:=Value;
end;

procedure TMyWebBrowser.SetExternalDispatch(const ppDispatch: IDispatch);
begin
    FExternalDispatch := ppDispatch;
end;

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
    ppDispatch := FExternalDispatch;
    Result := S_OK;
end;

function TMyWebBrowser.GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult;
begin
    pInfo.cbSize := SizeOf(_DOCHOSTUIINFO);

    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_THEME;
    if not FBorder3DEnabled then
        pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;
    if not FScrollEnabled then   
        pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_SCROLL_NO;
    if not FTextSelectEnabled then   
        pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_DIALOG;

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
    if FContextMenuEnabled then
        Result := S_FALSE
    else
        Result := S_OK;
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
    if FAllowAlerts then
     begin
      plResult := 0;
      Result := E_NOTIMPL;
     end
    else
     begin
      plResult := 0;
      case dwType of
       MB_OK, MB_OKCANCEL :       plResult := IDOK;
       MB_YESNO, MB_YESNOCANCEL : plResult := IDYES;
       MB_ABORTRETRYIGNORE :      plResult := IDIGNORE;
       MB_RETRYCANCEL :           plResult := IDCANCEL;
       //MB_CANCELTRYCONTINUE :     plResult := IDCONTINUE;
      end;
      Result:=S_OK;
     end;
end;


function TMyWebBrowser.GetIDsOfNames(const IID: TGUID; Names: Pointer;
    NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
var
    i, idx: integer;
    Name: PWideChar;  // Имена передаются в UNICODE
    DispId: SYSINT;
begin
    Result := S_OK;
    for i := 0 to NameCount - 1 do
    begin
        Name := POleStrList(Names)^[i];
        idx := FBindedNames.IndexOf(string(WideString(Name)));
        if idx <> -1 then
        begin
            DispId := (FBindedNames.Objects[idx] as TFuncPtrObj).DispId;
            PDispIdList(DispIDs)^[i] := DispId;
        end
        else
        begin
            if inherited GetIDsOfNames(IID, @Name, 1, LocaleID, @DispId) = S_OK then
                PDispIdList(DispIDs)^[i] := DispId
            else
            begin
                PDispIdList(DispIDs)^[i] := DISPID_UNKNOWN;
                Result := HResult(DISP_E_UNKNOWNNAME);
            end;
        end;
    end;
end;

function TMyWebBrowser.Invoke(DispID: Integer; const IID: TGUID;
    LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
    ArgErr: Pointer): HResult;
var
    Func: TMyGenericFunction;
    DispParams: ActiveX.DISPPARAMS absolute Params;
    args: array of OleVariant;
    i: integer;
    RResult: OleVariant;
begin
    if (DispId >= MyDispIdStart) and (DispId < MyDispIdStart + FBindedNames.Count) then
    begin
        if ((Flags and DISPATCH_PROPERTYPUT) <> 0) or
           ((Flags and DISPATCH_PROPERTYPUTREF) <> 0) then
        begin
            Result := E_NOTIMPL;
        end
        else
        begin
            Result := S_OK;

            if ((Flags and DISPATCH_METHOD) <> 0) or
               ((Flags and DISPATCH_PROPERTYGET) <> 0) then
            begin
                Func := (FBindedNames.Objects[DispId - MyDispIdStart] as TFuncPtrObj).Func;

                SetLength(args, DispParams.cArgs);
                for i := 0 to DispParams.cArgs - 1 do
                    args[i] := OleVariant(DispParams.rgvarg^[i]);

                RResult := Func(args);

                args:=nil; //free it

                if VarResult <> nil then
                    OleVariant(VarResult^) := RResult;
            end;
        end;
    end
    else
    if DispID=DISPID_AMBIENT_DLCONTROL then
    begin
     if VarResult <> nil then
     begin
        i:=0;
        if dlImages in FDLOptions then
         i:=i or DLCTL_DLIMAGES;
        if dlVideos in FDLOptions then
         i:=i or DLCTL_VIDEOS;
        if dlSounds in FDLOptions then
         i:=i or DLCTL_BGSOUNDS;
        if dlNoScripts in FDLOptions then
         i:=i or DLCTL_NO_SCRIPTS;
        if dlNoJava in FDLOptions then
         i:=i or DLCTL_NO_JAVA;
        if dlNoActiveXDownload in FDLOptions then
         i:=i or DLCTL_NO_DLACTIVEXCTLS;
        if dlNoActiveXRun in FDLOptions then
         i:=i or DLCTL_NO_RUNACTIVEXCTLS;
        if dlResynchronize in FDLOptions then
         i:=i or DLCTL_RESYNCHRONIZE;
        if dlPragmaNoCache in FDLOptions then
         i:=i or DLCTL_PRAGMA_NO_CACHE;
        if dlSilent in FDLOptions then
         i:=i or DLCTL_SILENT;
        if dlForceOffline in FDLOptions then
         i:=i or DLCTL_FORCEOFFLINE;
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

function TMyWebBrowser.InvokeScript(ScriptName: string;
    ScriptParams: array of OleVariant): OleVariant;
var
    doc: OleVariant; // Будем использовать позднее связывание
    ScriptEngineDispatch: IDispatch;
    DispId: SYSINT;
    hr: HRESULT;
    DispParams: ActiveX.DISPPARAMS;
    i : integer;
    wname : array [0..256] of WideChar;
    pname : PWideChar;
begin
    Result := Unassigned;

    if Self.Document=nil then
     exit;

    doc := Self.Document;
    ScriptEngineDispatch := doc.Script;
    if ScriptEngineDispatch=nil then
     exit;

    wname[0]:=#0;
    StringToWideChar(ScriptName,@wname,(sizeof(wname) div sizeof(wname[0])) - 1);
    pname:=@wname;

    hr := ScriptEngineDispatch.GetIDsOfNames(IID_NULL,
            @pname,
            1,
            LOCALE_USER_DEFAULT,
            @DispId);
    if hr = S_OK then
    begin
        with DispParams do
        begin
            cArgs := Length(ScriptParams);
            GetMem(rgvarg, cArgs*SizeOf(OleVariant));
            if rgvarg<>nil then
              ZeroMemory(rgvarg,cArgs*SizeOf(OleVariant)); //needed for variant types
            for i := 0 to cArgs - 1 do
              OleVariant(rgvarg^[i]) := ScriptParams[i];
            rgdispidNamedArgs := NIL;
            cNamedArgs := 0;
        end;
        try
            ScriptEngineDispatch.Invoke(DispId,
              IID_NULL,
              LOCALE_USER_DEFAULT,
              DISPATCH_METHOD,
              DispParams,
              NIL, NIL, NIL);
        finally
            with DispParams do
            begin
               for i := 0 to cArgs - 1 do
                 OleVariant(rgvarg^[i]):=unassigned;
               FreeMem(rgvarg);
            end;
        end;
    end
    else
    begin
        raise Exception.Create('Unknown script name in WebBrowser.InvokeScript');
    end;
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
begin
  Result:=S_OK;
end;

function TMyWebBrowser.QueryService(const rsid, iid: TGuid; out Obj): HResult;
begin
 Result:=E_NOINTERFACE;

 if IsEqualIID(iid,IID_IDownloadManager) then
  begin
   if not FAllowFileDownload then
    begin
     pointer(obj):=nil;
     IDownloadManager(obj):=self;
     Result:=S_OK;
    end;
  end;
end;

procedure Register;
begin
    RegisterComponents('Samples', [TMyWebBrowser]);
end;


end.
