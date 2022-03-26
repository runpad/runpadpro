

const SCREEN_RLE7B_GRAY  = $2A91EF13;
const SCREEN_RLE7B_COLOR = $3D722E91;

const HELPER_DLL              = 'rsrdclient.dll';
const HELPER_MSG_DATA         = '_RSRDDataArrived';
const HELPER_MSG_DISCONNECTED = '_RSRDDisconnected';
const HELPER_MSG_FINISHED     = '_RSRDWorkFinished';


type pinteger = ^integer;

procedure  RA_Init(); cdecl; external HELPER_DLL;
procedure  RA_Done(); cdecl; external HELPER_DLL;
function   RA_Connect(server:pchar):longbool; cdecl; external HELPER_DLL;
procedure  RA_Disconnect(); cdecl; external HELPER_DLL;
procedure  RA_UpdatePictureType(picture_type:integer); cdecl; external HELPER_DLL;
procedure  RA_UpdateFPS(fps:single); cdecl; external HELPER_DLL;
function   RA_Lock(pw,ph:pinteger):HDC; cdecl; external HELPER_DLL;
procedure  RA_Unlock(); cdecl; external HELPER_DLL;
procedure  RA_InputEvent(message,wParam,lParam:integer;time:cardinal); cdecl; external HELPER_DLL;

function CheckAtStartup(parent:HWND;silent:longbool):longbool cdecl; external HELPER_DLL;
