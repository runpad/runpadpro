
const DLL_NAME      = 'bodyburn.dll';

type TIdleCallback     = function(parm:pointer):longbool; cdecl;
type TUserDialog       = function(parm:pointer;typ:integer;data:pointer):integer; cdecl;
type TProgressCallback = function(parm:pointer;dwProgressInPercent:integer):longbool; cdecl;
type TAddLogLine       = procedure(parm:pointer;typ:integer;text:pchar); cdecl;
type TSetPhaseCallback = procedure(parm:pointer;text:pchar); cdecl;


function  BurnInit(f1:TIdleCallback;f2:TUserDialog;parm:pointer):longbool; cdecl; external DLL_NAME;
procedure BurnDone; cdecl; external DLL_NAME;
function  BurnCreateDevList(dvd:longbool):integer; cdecl; external DLL_NAME;
function  BurnGetDevName(num:integer):pchar; cdecl; external DLL_NAME;
function  BurnIsDriveAllowed(num:integer;allow_virtual,allow_real:longbool):longbool; cdecl; external DLL_NAME;
function  BurnGetDevSpeedsCount(num:integer):integer; cdecl; external DLL_NAME;
function  BurnGetDevSpeedAt(num,at:integer):integer; cdecl; external DLL_NAME;
function  BurnEraseDisc(num:integer):longbool; cdecl; external DLL_NAME;
function  BurnDisc(num:integer;flist:pchar;name:pchar;flags:integer;speed:integer;parm:pointer;cb1:TProgressCallback;cb2:TAddLogLine;cb3:TSetPhaseCallback;cd_type:integer):longbool; cdecl; external DLL_NAME;
procedure BurnAsyncCancelOperation; cdecl; external DLL_NAME;

const
  NERO_TEXT_INFO = 0;         { informative text                     }
  NERO_TEXT_STOP = 1;         { some operation stopped prematurely   }
  NERO_TEXT_EXCLAMATION = 2;  { important information                }
  NERO_TEXT_QUESTION = 3;     { a question which requires an answer  }
  NERO_TEXT_DRIVE = 4;        { a message concerning a CD-ROM drive or recorder }
  NERO_TEXT_FILE = 5;         { a message concerning a file          }
  NERO_TEXT_UNSPECIFIED = 6;  { no type specified                    }


const
  NBF_CLOSE_SESSION = 16;
  NBF_VERIFY = 1024;

const 
  DLG_NON_EMPTY_CDRW = 22;
  DLG_FILESEL_IMAGE = 20;
  DLG_WAITCD = 15;

  DLG_RETURN_OK = -8;
  DLG_RETURN_YES = -7;
  DLG_RETURN_RETRY = -6;
  DLG_RETURN_IGNORE = -5;
  DLG_RETURN_NO = -4;
  DLG_RETURN_CANCEL = -3;
  DLG_RETURN_ABORT = -2;
  DLG_RETURN_NOT_HANDLED = -1;
  DLG_RETURN_EXIT = 0;
  DLG_RETURN_FALSE = 0;
  DLG_RETURN_TRUE = 1;
  DLG_RETURN_ON_RESTART = 3;
  DLG_RETURN_RESTART = 4;
  DLG_RETURN_CONTINUE = 5;
  DLG_RETURN_INSTALL_DRIVER = 8;
  DLG_RETURN_OFF_RESTART = 9;

