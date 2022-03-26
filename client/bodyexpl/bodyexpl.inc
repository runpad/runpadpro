
const BODYEXPL_DLL = 'bodyexpl.dll';


procedure GDIP_Init(); cdecl; external BODYEXPL_DLL;
procedure GDIP_Done(); cdecl; external BODYEXPL_DLL;
function GDIP_IsSupportedFormat(const filename:pchar):longbool; cdecl; external BODYEXPL_DLL;
function GDIP_ConvertFile(const file_in,file_out:pchar):longbool; cdecl; external BODYEXPL_DLL;
function GDIP_RotateImage(ccw:longbool;const file_in,file_out:pchar):longbool; cdecl; external BODYEXPL_DLL;
function GDIP_ReduceImage(neww,newh:integer;const file_in,file_out:pchar):longbool; cdecl; external BODYEXPL_DLL;

