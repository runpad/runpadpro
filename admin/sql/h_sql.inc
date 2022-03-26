

// parameter directions
const SQL_PD_INPUT    = 1;  //same as pdInput

// data types
const SQL_DT_UNKNOWN  = 0;  //same as ftUnknown
const SQL_DT_STRING   = 1;  //same as ftString
const SQL_DT_INTEGER  = 3;  //same as ftInteger
const SQL_DT_REAL     = 6;  //same as ftFloat (8 bytes double)
const SQL_DT_DATETIME = 11; //same as ftDateTime (8 bytes double in delphi format TDateTime)
const SQL_DT_BLOB     = 15; //same as ftBlob

// other
const SQL_DEF_TIMEOUT = 5;  // in seconds


type TSTOREDPROCPARAM = record
      Direction : integer; // only Input supported!!!
      DataType : integer;
      Value : pointer;
      BlobSize : integer; //used only for blob-data
     end;
     PSTOREDPROCPARAM = ^TSTOREDPROCPARAM;

type TEXECSQLCBSTRUCT = record
      user_parm : pointer;
      obj : pointer;
      idx : integer; //curr record index (-1 will first time when call_cb_at_begin=TRUE)
      numrecords : integer;
      GetNumFields : function(obj:pointer):integer cdecl;
      GetFieldByName : function(obj:pointer;const name:pchar):pointer cdecl;
      GetFieldByIdx : function(obj:pointer;idx:integer):pointer cdecl;
      GetFieldDisplayName : procedure(obj:pointer;field:pointer;_out:pchar) cdecl;  //reserve MAX_PATH for _out
      GetFieldDataType : function(obj:pointer;field:pointer):integer cdecl;
      GetFieldValueAsInt : function(obj:pointer;field:pointer):integer cdecl;
      GetFieldValueAsDouble : function(obj:pointer;field:pointer):double cdecl;
      GetFieldValueAsDateTime : function(obj:pointer;field:pointer):double cdecl;
      GetFieldValueAsString : function(obj:pointer;field:pointer):pchar cdecl; //returns allocated string
      GetFieldValueAsBlob : function(obj:pointer;field:pointer;_size:pinteger):pointer cdecl; //returns allocated blob
      FreePointer : procedure(p:pointer) cdecl; //free data returned by GetFieldValueAsString, GetFieldValueAsBlob
     end;
     PEXECSQLCBSTRUCT = ^TEXECSQLCBSTRUCT;

type TEXECSQLCBPROC = function(parm:PEXECSQLCBSTRUCT):longbool cdecl;


