unit ImageExtract;


interface


uses Windows, Graphics, SysUtils, ShellApi, ShlObj, ActiveX, ComObj;


const
  IEIFLAG_ASYNC    =   $001;
  IEIFLAG_CACHE    =   $002;
  IEIFLAG_ASPECT   =   $004;
  IEIFLAG_OFFLINE  =   $008;
  IEIFLAG_GLEAM    =   $010;
  IEIFLAG_SCREEN   =   $020;
  IEIFLAG_ORIGSIZE =   $040;
  IEIFLAG_NOSTAMP  =   $080;
  IEIFLAG_NOBORDER =   $100;
  IEIFLAG_QUALITY  =   $200;

  {$EXTERNALSYM IID_IExtractImage}
  IID_IExtractImage: TGUID = '{BB2E617C-0920-11d1-9A0B-00C04FC2D6C1}'; //??GUID???????
  {$EXTERNALSYM SID_IRunnableTask}
  SID_IRunnableTask: TGUID = '{85788D00-6807-11D0-B810-00C04FD706EC}';

  IRTIR_TASK_NOT_RUNNING = 0;
  IRTIR_TASK_RUNNING     = 1;
  IRTIR_TASK_SUSPENDED   = 2;
  IRTIR_TASK_PENDING     = 3;
  IRTIR_TASK_FINISHED    = 4;


type
  {$EXTERNALSYM IExtractImage}
  IExtractImage = interface(IUnknown)
    ['{BB2E617C-0920-11D1-9A0B-00C04FC2D6C1}']
    function GetLocation(pszPathBuffer: LPWSTR; cchMax: DWORD;
      pdwPriority: PDWORD; const prgSize: PSIZE; dwRecClrDepth: DWORD;
      pdwFlags: PDWORD): HRESULT; stdcall;
    function Extract(phBmpImage: PHandle): HRESULT; stdcall;
  end;

  {$EXTERNALSYM IRunnableTask}
  IRunnableTask = interface(IUnknown)
    ['{85788D00-6807-11D0-B810-00C04FD706EC}']
    function Run: HResult; stdcall;
    function Kill(fWait : BOOL): HResult; stdcall;
    function Suspend: HResult; stdcall;
    function Resume: HResult; stdcall;
    function IsRunning : ULONG; stdcall;
  end;

function ExtractImage(AFileName: string; ABitmap: TBitmap; AFlags: DWORD = 0): Boolean;
function ExtractIcon(AFileName: String; IconSize: Byte): HICON;
function FastExtractIcon(AFolder: IShellFolder; ApIdl, AbsIdl: PItemIDList; ImgLst: Integer;
  AFlags: DWORD = 0): HICON;
function FastExtractImage(AFolder: IShellFolder; ApIdl: PItemIDList;
  ABitmap: TBitmap; AFlags: DWORD = 0): Boolean;


var
  Malloc: IMalloc;


implementation

uses Types, CommCtrl;


function ExtractImage(AFileName: string; ABitmap: TBitmap; AFlags: DWORD = 0): Boolean;
var
  WidePath: WideString;
  Eaten, Attribute: Cardinal;
  DesktopFolder, Folder: IShellFolder;
  ItemIDList, IDList: PItemIDList;
  ExtractImage: IExtractImage;
  Unknown: IUnknown;
  PCh : PWideChar;
  Priority : DWORD;
  ImageSize : SIZE;
  RecClrDepth: DWORD;
  Flags: DWORD;
  hBmp : THandle;
begin
  Result := False;
  SHGetDesktopFolder(DesktopFolder);
  WidePath := ExtractFilePath(AFileName);
  DesktopFolder.ParseDisplayName(0, nil, PWideChar(WidePath),
    Eaten, ItemIDList, Attribute);
  DesktopFolder.BindToObject(ItemIDList, nil,
    IID_IShellFolder, Pointer(Folder));
  WidePath := ExtractFileName(AFileName);
  Folder.ParseDisplayName(0, nil, PWideChar(WidePath), Eaten, IDList, Attribute);
  if Succeeded(Folder.GetUIObjectOf(0, 1,
    IDList, IID_IExtractImage, nil, Unknown)) then
  begin
    ExtractImage := Unknown as IExtractImage;
    if ExtractImage <> nil then
    begin
      case ABitmap.PixelFormat of
        pfDevice : RecClrDepth := 24;
        pf1bit   : RecClrDepth := 1;
        pf4bit   : RecClrDepth := 4;
        pf8bit   : RecClrDepth := 8;
        pf15bit  : RecClrDepth := 16;
        pf16bit  : RecClrDepth := 16;
        pf24bit  : RecClrDepth := 24;
        pf32bit  : RecClrDepth := 32;
        pfCustom : RecClrDepth := 24;
        else RecClrDepth := 24;
      end;
      Priority := 0;
      ImageSize.cx := ABitmap.Width;
      ImageSize.cy := ABitmap.Height;
      Flags := AFlags;
      PCh := AllocMem(512);
      try
        ExtractImage.GetLocation(PCh, 512,
          @Priority, @ImageSize, RecClrDepth, @Flags);
        if Succeeded(ExtractImage.Extract(@hBmp)) then
        begin
          ABitmap.Handle := hBmp;
          Result := True;
        end;
      finally
        FreeMem(PCh);
      end;
    end;
  end;
  Malloc.Free(ItemIDList);
  Malloc.Free(IDList);
  DesktopFolder := nil;
  Folder := nil;
end;
//------------------------------------------------------------------------------
function ExtractIcon(AFileName: String; IconSize: Byte): HICON;
var
  hr: HRESULT;
  DesktopFolder, Folder: IShellFolder;
  Eaten, Attribute: Cardinal;
  ItemIDList, IDList: PItemIDList;
  Unknown: IUnknown;
  PCh : PWideChar;
  Flags: DWORD;
  icon, tmpIcon: HICON;
  WidePath: WideString;
  ExtractIcon: IExtractIcon;
  IconIndex: integer;
begin
  Result := 0;
  SHGetDesktopFolder(DesktopFolder);
  WidePath := ExtractFilePath(AFileName);
  ItemIDList := nil;
  DesktopFolder.ParseDisplayName(0, nil, PWideChar(WidePath),
    Eaten, ItemIDList, Attribute);
  DesktopFolder.BindToObject(ItemIDList, nil,
    IID_IShellFolder, Pointer(Folder));
  WidePath := ExtractFileName(AFileName);
  Folder.ParseDisplayName(0, nil, PWideChar(WidePath), Eaten, IDList, Attribute);
  if Succeeded(Folder.GetUIObjectOf(0, 1,
    IDList, IID_IExtractIconW, nil, Unknown)) then
  begin
    ExtractIcon := Unknown as IExtractIcon;
    if ExtractIcon <> nil then
    begin
      Flags := 0;
      PCh := AllocMem(512);
      try
        ExtractIcon.GetIconLocation(0, PAnsiChar(PCh), 512,
          IconIndex, Flags);
        if iconSize = 16 then
          hr := ExtractIcon.Extract(PAnsiChar(PCh), iconIndex, tmpIcon, icon, MAKELONG(32, 16))
        else
          hr := ExtractIcon.Extract(PAnsiChar(PCh), iconIndex, icon, tmpIcon, MAKELONG(iconSize, 16));
        if Succeeded(hr) then
        begin
          DestroyIcon(tmpIcon);
          Result := icon;
        end;
      finally
        FreeMem(PCh);
      end;
    end;
  end;
  Malloc.Free(ItemIDList);
  Malloc.Free(IDList);
  DesktopFolder := nil;
  Folder := nil;
end;
//------------------------------------------------------------------------------
function FastExtractIcon(AFolder: IShellFolder; ApIdl, AbsIdl: PItemIDList; ImgLst: Integer;
  AFlags: DWORD = 0): HICON;
var
  hr           : HRESULT;
  Unknown      : IUnknown;
  PCh          : PWideChar;
  Flags        : DWORD;
  icon, tmpIcon: HICON;
  ExtractIcon  : IExtractIcon;
  IconIndex    : integer;
  FileInfo     : TSHFileInfo;
begin
  Result := 0;
  if Succeeded(AFolder.GetUIObjectOf(0, 1,
    ApIDL, IID_IExtractIconA, nil, Unknown)) then
  begin
    ExtractIcon := Unknown as IExtractIcon;
    if ExtractIcon <> nil then
    begin
      Flags := AFlags;
      PCh := AllocMem(512);
      try
        ExtractIcon.GetIconLocation(0, PChar(PCh), 512, IconIndex, Flags);
        icon := 0;
        hr := ExtractIcon.Extract(PChar(PCh), iconIndex, icon, tmpIcon, MAKELONG(48, 16));
        if Succeeded(hr) then
        begin
          DestroyIcon(tmpIcon);
          if icon <> 0 then
            Result := icon
          else
          begin
            // для неопознанных иконок
            Flags := SHGFI_PIDL {or SHGFI_ICON} or SHGFI_LARGEICON or SHGFI_SYSICONINDEX;
            SHGetFileInfo(PChar(AbsIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
            Result := ImageList_GetIcon(ImgLst, FileInfo.iIcon, ILD_NORMAL);
        //    Result := FileInfo.hIcon;
          end;
        end
        else
        begin
          // для неопознанных иконок
          Flags := SHGFI_PIDL {or SHGFI_ICON} or SHGFI_LARGEICON or SHGFI_SYSICONINDEX;
          SHGetFileInfo(PChar(AbsIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
          Result := ImageList_GetIcon(ImgLst, FileInfo.iIcon, ILD_NORMAL);
      //    Result := FileInfo.hIcon;
        end;
      finally
        FreeMem(PCh);
      end;
    end;
  end
  else
  begin
    // для неопознанных иконок
    Flags := SHGFI_PIDL {or SHGFI_ICON} or SHGFI_LARGEICON or SHGFI_SYSICONINDEX;
    SHGetFileInfo(PChar(AbsIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
    Result := ImageList_GetIcon(ImgLst, FileInfo.iIcon, ILD_NORMAL);
//    Result := FileInfo.hIcon;
  end;
end;
//------------------------------------------------------------------------------
function StrRetToStrA(str:pointer;pidl:pointer;var _s:pchar):HRESULT stdcall; external 'shlwapi.dll';


function FastExtractImage(AFolder: IShellFolder; ApIdl: PItemIDList;
  ABitmap: TBitmap; AFlags: DWORD = 0): Boolean;
var
  ExtractImage: IExtractImage;
  Unknown     : IUnknown;
  PCh         : PWideChar;
  Priority    : DWORD;
  ImageSize   : SIZE;
  RecClrDepth : DWORD;
  Flags       : DWORD;
  hBmp        : THandle;
  //RunnableTask: IRunnableTask;
  str:_STRRET;
  ps:pchar;
  ext:string;
begin
  Result := False;

  // workaround for .odt, .ods files (GPF on FreeMem in some cases)
  if Succeeded(AFolder.GetDisplayNameOf(ApIdl, SHGDN_FORPARSING or SHGDN_INFOLDER, str)) then
   begin
    ps:=nil;
    if Succeeded(StrRetToStrA(@str,ApIdl,ps)) then
     begin
      ext:=ExtractFileExt(string(ps));
      CoTaskMemFree(ps);
      if (AnsiCompareText(ext,'.odt')=0) or 
         (AnsiCompareText(ext,'.ods')=0) or 
         (AnsiCompareText(ext,'.sxw')=0) or 
         (AnsiCompareText(ext,'.sxc')=0) then
       begin
        Exit;
       end;
     end
    else
     begin
      if str.uType=STRRET_WSTR then
       CoTaskMemFree(str.pOleStr);
     end;
   end;
  
  if Succeeded(AFolder.GetUIObjectOf(0, 1,
    ApIdl, IID_IExtractImage, nil, Unknown)) then
  begin
    ExtractImage := Unknown as IExtractImage;
    if ExtractImage <> nil then
    begin
      case ABitmap.PixelFormat of
        pfDevice : RecClrDepth := 24;
        pf1bit   : RecClrDepth := 1;
        pf4bit   : RecClrDepth := 4;
        pf8bit   : RecClrDepth := 8;
        pf15bit  : RecClrDepth := 16;
        pf16bit  : RecClrDepth := 16;
        pf24bit  : RecClrDepth := 24;
        pf32bit  : RecClrDepth := 32;
        pfCustom : RecClrDepth := 24;
        else RecClrDepth := 24;
      end;
      Priority := 0;
      ABitmap.Width := 96;
      ABitmap.Height:= 96;
      ImageSize.cx := 96;
      ImageSize.cy := 96;
      Flags := AFlags;
      PCh := AllocMem(512);
      try
        ExtractImage.GetLocation(PCh, 512,
          @Priority, @ImageSize, RecClrDepth, @Flags);
        ABitmap.Width := ImageSize.cx;
        ABitmap.Height := ImageSize.cy;
        if Succeeded(ExtractImage.Extract(@hBmp)) then
        begin
          ABitmap.Handle := hBmp;
          Result := True;
        end;
      finally
        FreeMem(PCh);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
initialization
  OleInitialize(nil);
  SHGetMalloc(Malloc);
finalization
  Malloc := nil;
  OleUninitialize;
end.