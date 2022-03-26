
unit theme;

interface



type
  // external connection with host (runpad)
  TDeskExternalConnection = record
   OnError : procedure (const err_text:pchar); cdecl;
   OnRClick : procedure (); cdecl;
   OnMouseDown : procedure (); cdecl;
   GetMachineLoc : function () : pchar; cdecl;
   GetMachineDesc : function () : pchar; cdecl;
   GetVipSessionName : function () : pchar; cdecl;
   GetStatusString : function () : pchar; cdecl;
   GetInfoText : function () : pchar; cdecl;
   GetNumSheets : function () : integer; cdecl;
   GetSheetName : function (idx:integer) : pchar; cdecl;
   IsSheetActive : function (idx:integer) : longbool; cdecl;
   SetSheetActive : procedure (idx:integer;active:longbool); cdecl;
   GetSheetBGPic : function (idx:integer) : pchar; cdecl;
   IsPageShaded : function () : longbool; cdecl;
   IsWaitCursor : function () : longbool; cdecl;
   CanUseGFX : function () : longbool; cdecl;
   DoShellExec : procedure (const exe,args:pchar); cdecl;
   GetInputText : function (const title,text:pchar):pchar; cdecl;
   Alert : procedure (const text:pchar); cdecl;
   GetInputTextPos : function (pwdchar:char;x,y,w,h,maxlen:integer;const text:pchar):pchar; cdecl;
   //....
  end;
  PDeskExternalConnection = ^TDeskExternalConnection;


  // abstract theme class
  TTheme = class(TObject)
  public
   function IsLoaded:boolean; virtual; abstract;
   procedure Refresh; virtual; abstract;
   procedure Repaint; virtual; abstract;
   procedure OnStatusStringChanged; virtual; abstract;
   procedure OnActiveSheetChanged; virtual; abstract;
   procedure OnPageShaded; virtual; abstract;
   procedure OnDisplayChanged; virtual; abstract;
  end;



implementation



end.
