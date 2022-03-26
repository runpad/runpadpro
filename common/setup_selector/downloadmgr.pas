
unit DownloadMgr;

{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}

interface

uses Windows, ActiveX, Classes, UrlMon, Variants;


type
  IDownloadManager = interface(IUnknown)
    ['{988934A4-064B-11D3-BB80-00104B35E7F9}']
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
  end;


const
    IID_IDOWNLOADMANAGER: TGUID = '{988934A4-064B-11D3-BB80-00104B35E7F9}';


implementation

end.
