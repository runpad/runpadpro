
const STAT_DLL      = 'rsstat.dll';

const ST_TYPE_SHEET    = 1;
const ST_TYPE_SHORTCUT = 2;
const ST_TYPE_MACHINE  = 3;


// Enumeration modes
const ST_EMODE_SHEETS         = -1;
const ST_EMODE_SHORTCUTS      = -2;
const ST_EMODE_SHEETSHORTCUTS = -3;
const ST_EMODE_TREE           =  1;

// Sorting modes (for enumeration)
const ST_ESORT_ALPHA          =  1;
const ST_ESORT_RATING         =  2;


function st_Clean(): pointer; cdecl; external STAT_DLL;
function st_Update(): pointer; cdecl; external STAT_DLL;
function st_SetBeginDate(date: integer): pointer; cdecl; external STAT_DLL;
function st_SetEndDate(date: integer): pointer; cdecl; external STAT_DLL;

function st_GetItName(handle: pointer): pchar; cdecl; external STAT_DLL;
function st_GetItColor(handle: pointer): integer; cdecl; external STAT_DLL;
function st_GetItIcon(handle: pointer): HICON; cdecl; external STAT_DLL;
function st_GetItType(handle: pointer): integer; cdecl; external STAT_DLL;
function st_GetItMidlevel(handle: pointer): real; cdecl; external STAT_DLL;
function st_GetItDate(handle: pointer): integer; cdecl; external STAT_DLL;
function st_GetItRawLen(handle: pointer): integer; cdecl; external STAT_DLL;
function st_GetItRawItem(handle: pointer; i: integer): real; cdecl; external STAT_DLL;
function st_GetItSheet(handle: pointer): pointer; cdecl; external STAT_DLL; // for shortcuts only!
function st_GetItActive(handle: pointer): integer; cdecl; external STAT_DLL;
function st_GetItIp(handle: pointer): integer; cdecl; external STAT_DLL; // for machines only!

function st_SetItActive(handle: pointer; active: integer): integer; cdecl; external STAT_DLL;
function st_SetItChildrenActive(handle: pointer; active: integer): integer; cdecl; external STAT_DLL;
function st_SetEnumMode(mode: integer): integer; cdecl; external STAT_DLL;
function st_SetEnumSort(sort: integer): integer; cdecl; external STAT_DLL;
function st_EnumStart(handle: pointer): pointer; cdecl; external STAT_DLL;
function st_EnumNext(): pointer; cdecl; external STAT_DLL;
function st_GetEnumSize(): integer; cdecl; external STAT_DLL;

function st_EnumMachinesStart(): pointer; cdecl; external STAT_DLL;
function st_EnumMachinesNext(): pointer; cdecl; external STAT_DLL;

function st_LoadFile(filename: pchar): integer; cdecl; external STAT_DLL;
function st_SaveFile(filename: pchar): integer; cdecl; external STAT_DLL;

function st_Export2Html(filename: pchar): integer; cdecl; external STAT_DLL;
function st_Export2Xml(filename: pchar): integer; cdecl; external STAT_DLL;
function st_Export2Debug(filename: pchar): integer; cdecl; external STAT_DLL;
