#ifndef _STAT_H
#define _STAT_H


#include <Windows.h>

#ifdef STAT_EXPORTS
#define EXTERN extern "C" __declspec(dllexport)
#else
#define EXTERN extern "C" __declspec(dllimport)
#endif

#define ST_TYPE_SHEET     1
#define ST_TYPE_SHORTCUT  2
#define ST_TYPE_MACHINE   3

// Enumeration modes
#define ST_EMODE_SHEETS         -1
#define ST_EMODE_SHORTCUTS      -2
#define ST_EMODE_SHEETSHORTCUTS -3
#define ST_EMODE_TREE            1

// Sorting modes (for enumeration)
#define ST_ESORT_ALPHA           1
#define ST_ESORT_RATING          2


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Pseudo types
#define COLOR int
#define DATE int
//#define DATE ULARGE_INTEGER

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// DLL interface functions
EXTERN void* __cdecl st_Clean();
EXTERN void* __cdecl st_Update();
EXTERN void* __cdecl st_SetBeginDate(DATE date);
EXTERN void* __cdecl st_SetEndDate(DATE date);

EXTERN char* __cdecl st_GetItName(void *handle);
EXTERN int   __cdecl st_GetItColor(void *handle);
EXTERN HICON __cdecl st_GetItIcon(void *handle);
EXTERN int   __cdecl st_GetItType(void *handle);
EXTERN float __cdecl st_GetItMidlevel(void *handle);
EXTERN DATE  __cdecl st_GetItDate(void *handle);
EXTERN int   __cdecl st_GetItRawLen(void *handle);
EXTERN float __cdecl st_GetItRawItem(void *handle, int i);
EXTERN void* __cdecl st_GetItSheet(void *handle); // for shortcuts only!
EXTERN int   __cdecl st_GetItActive(void *handle);
EXTERN int   __cdecl st_GetItIp(void *handle); // for machines only!

EXTERN int   __cdecl st_SetItActive(void *handle, int active);
EXTERN int   __cdecl st_SetItChildrenActive(void *handle, int active);
EXTERN int   __cdecl st_SetEnumMode(int mode);
EXTERN int   __cdecl st_SetEnumSort(int sort);
EXTERN void* __cdecl st_EnumStart(void *handle);
EXTERN void* __cdecl st_EnumNext();
EXTERN int   __cdecl st_GetEnumSize();

EXTERN void* __cdecl st_EnumMachinesStart();
EXTERN void* __cdecl st_EnumMachinesNext();

EXTERN int   __cdecl st_LoadFile(char* filename);
EXTERN int   __cdecl st_SaveFile(char* filename);

EXTERN int   __cdecl st_Export2Html(char* filename);
EXTERN int   __cdecl st_Export2Xml(char* filename);
EXTERN int   __cdecl st_Export2Debug(char* filename);

#endif