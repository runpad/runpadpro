
#ifndef __H_SQL_INC_H__
#define __H_SQL_INC_H__


// parameter directions
#define SQL_PD_INPUT     1  //same as pdInput

// data types
#define SQL_DT_UNKNOWN   0  //same as ftUnknown
#define SQL_DT_STRING    1  //same as ftString
#define SQL_DT_INTEGER   3  //same as ftInteger
#define SQL_DT_REAL      6  //same as ftFloat (8 bytes double)
#define SQL_DT_DATETIME  11 //same as ftDateTime (8 bytes double in delphi format TDateTime)
#define SQL_DT_BLOB      15 //same as ftBlob

// other
#define SQL_DEF_TIMEOUT  5  //in seconds


typedef struct {
int direction; // only Input supported!!!
int data_type;
void *value;
int blob_size; //used only for blob-data
} TSTOREDPROCPARAM;
typedef TSTOREDPROCPARAM* PSTOREDPROCPARAM;

typedef struct {
void *user_parm;
void *obj;
int idx; //curr record index (-1 will first time when call_cb_at_begin=TRUE)
int numrecords;
int (__cdecl *GetNumFields)(void *obj);
void* (__cdecl *GetFieldByName)(void *obj,const char *name);
void* (__cdecl *GetFieldByIdx)(void *obj,int idx);
void (__cdecl *GetFieldDisplayName)(void *obj,void *field,char *_out);  //reserve MAX_PATH for _out
int (__cdecl *GetFieldDataType)(void *obj,void *field);
int (__cdecl *GetFieldValueAsInt)(void *obj,void *field);
double (__cdecl *GetFieldValueAsDouble)(void *obj,void *field);
double (__cdecl *GetFieldValueAsDateTime)(void *obj,void *field);
char* (__cdecl *GetFieldValueAsString)(void *obj,void *field); //returns allocated string
void* (__cdecl *GetFieldValueAsBlob)(void *obj,void *field,int *_size); //returns allocated blob
void (__cdecl *FreePointer)(void *p); //free data returned by GetFieldValueAsString, GetFieldValueAsBlob
} TEXECSQLCBSTRUCT;
typedef TEXECSQLCBSTRUCT* PEXECSQLCBSTRUCT;

typedef BOOL (__cdecl *TEXECSQLCBPROC)(TEXECSQLCBSTRUCT *parm);


#endif
