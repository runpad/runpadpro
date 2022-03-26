#include <Windows.h>
#include <dbt.h>
#include <Shlwapi.h>
#include "rp_shared.h"
#include "filesys.h"



extern int Path2Drive(const char *path);
extern void *sys_alloc(int size);
extern void sys_free(void *buff);



void *sys_fcreate(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ|GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void *sys_fopenr(const char *filename)
{
  HANDLE h = CreateFile(filename,GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,NULL);
  return (h == INVALID_HANDLE_VALUE) ? NULL : h;
}


void sys_fclose(void *h)
{
  CloseHandle(h);
}


int sys_fwrite(void *h,void *buff,int len)
{
  DWORD rc;
  
  WriteFile(h,buff,len,&rc,NULL);
  return rc;
}


static int sys_fsize(void *h)
{
  int rc = GetFileSize(h,NULL);

  return rc == INVALID_FILE_SIZE ? 0 : rc;
}

static __int64 sys_fsizel(void *h)
{
  DWORD high,low;
  
  low = GetFileSize(h,&high);

  if ( low == INVALID_FILE_SIZE )
     return 0;
  else
     return ((__int64)high << 32) | low;
}



void ScanDir(const char *path,int type,SCANFUNC func,void *user)
{
  WIN32_FIND_DATA f;
  char s[MAX_PATH]; 
  HANDLE h;
  int rc,dir,file,hidden;

  lstrcpy(s,path);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  h = FindFirstFile(s,&f);
  rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         dir = (f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
         file = !dir;
         hidden = (f.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) || (f.dwFileAttributes & FILE_ATTRIBUTE_SYSTEM);

         if ( !hidden || (type & SCAN_HIDDEN) )
            {
              if ( ((type & SCAN_DIR) && dir) || ((type & SCAN_FILE) && file) )
                 {
                   lstrcpy(s,path);
                   PathAddBackslash(s);
                   lstrcat(s,f.cFileName);
                   if ( !func(s,&f,user) )
                      break;
                 }
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


static __int64 GetDirectorySizeInternal(const char *dir);


static BOOL CalcProc(const char *path,WIN32_FIND_DATA *f,void *user)
{
  if ( f->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY )
     {
       *((__int64*)user) += GetDirectorySizeInternal(path);
     }
  else
     {
       __int64 total;

       *((unsigned*)&total + 0) = f->nFileSizeLow;
       *((unsigned*)&total + 1) = f->nFileSizeHigh;
       
       *((__int64*)user) += total;
     }

  return TRUE;
}


static __int64 GetDirectorySizeInternal(const char *dir)
{
  __int64 size = 0;
  ScanDir(dir,SCAN_DIR | SCAN_FILE | SCAN_HIDDEN,CalcProc,(void*)&size);
  return size;
}


__declspec(dllexport) UINT __cdecl GetDirectorySize(const char *dir)
{
  if ( PathIsDirectory(dir) )
     return (GetDirectorySizeInternal(dir) + 512) >> 10;
  else
     {
       __int64 size = 0;
       void *h = sys_fopenr(dir);
       if ( h )
          {
            size = sys_fsizel(h);
            sys_fclose(h);
          }
       return (size + 512) >> 10;
     }
}


__declspec(dllexport) BOOL __cdecl CreateEmptyFile(const char *s)
{
  void *h = sys_fcreate(s);

  if ( h )
     {
       sys_fclose(h);
       return TRUE;
     }
  else
     return FALSE;
}


static BOOL GetDriveFreeSpaceInternal(const char *dir,unsigned *_total,unsigned *_free)
{
  char drive[8];
  ULARGE_INTEGER s_caller,s_total,s_free;
  BOOL (WINAPI *pSHGetDiskFreeSpace)(LPCSTR,ULARGE_INTEGER*,ULARGE_INTEGER*,ULARGE_INTEGER*);
  HINSTANCE lib;

  if ( _total )
     *_total = 0;
  
  if ( _free )
     *_free = 0;
  
  if ( !dir || !dir[0] || lstrlen(dir) < 2 )
     return FALSE;

  if ( dir[1] != ':' )
     return FALSE;

  drive[0] = dir[0];
  drive[1] = dir[1];
  drive[2] = '\\';
  drive[3] = 0;
 
  lib = GetModuleHandle("shell32.dll");
  if ( !lib )
     lib = LoadLibrary("shell32.dll");
  pSHGetDiskFreeSpace = (void*)GetProcAddress(lib,"SHGetDiskFreeSpaceExA");
  if ( !pSHGetDiskFreeSpace )
     return FALSE;
  
  if ( !pSHGetDiskFreeSpace(drive,&s_caller,&s_total,&s_free) )
     return FALSE;

  if ( _total )
     *_total = ((*(unsigned __int64*)&s_total) >> 10);

  if ( _free )
     *_free = ((*(unsigned __int64*)&s_free) >> 10);

  return TRUE;
}


__declspec(dllexport) unsigned __cdecl GetDriveFreeSpace(const char *dir)
{
  unsigned rc = 0;

  if ( !GetDriveFreeSpaceInternal(dir,NULL,&rc) )
     rc = 0;

  return rc;
}


__declspec(dllexport) unsigned __cdecl GetDriveTotalSpace(const char *dir)
{
  unsigned rc = 0;

  if ( !GetDriveFreeSpaceInternal(dir,&rc,NULL) )
     rc = 0;

  return rc;
}


static BOOL GetDisksProperty(HANDLE hDevice, STORAGE_DEVICE_DESCRIPTOR *pDevDesc)
{
	STORAGE_PROPERTY_QUERY	Query;	// input param for query
	DWORD dwOutBytes = 0;				// IOCTL output length

	// specify the query type
	Query.PropertyId = StorageDeviceProperty;
	Query.QueryType = PropertyStandardQuery;

	// Query using IOCTL_STORAGE_QUERY_PROPERTY 
	return DeviceIoControl(hDevice,			// device handle
			IOCTL_STORAGE_QUERY_PROPERTY,			// info of device property
			&Query, sizeof(STORAGE_PROPERTY_QUERY),	// input data buffer
			pDevDesc, pDevDesc->Size,				// output data buffer
			&dwOutBytes,							// out's length
			(LPOVERLAPPED)NULL);					
}



__declspec(dllexport) BOOL __cdecl IsDriveTrueRemovableS(const char *s_drive)
{
  BOOL rc = FALSE;
  char s[10];
  DWORD d_type;
  HANDLE hDevice;

  int i = Path2Drive(s_drive);
  
  if ( i == -1 )
     return FALSE;

  if ( i == 0 || i == 1 )
     return TRUE; //diskette

  wsprintf(s,"%c:\\",i+'A');
  d_type = GetDriveType(s);

  if ( d_type == DRIVE_REMOVABLE )
     return TRUE;

  if ( d_type != DRIVE_FIXED )
     return FALSE;

  wsprintf(s,"\\\\?\\%c:",i+'A');

  hDevice = CreateFile(s,STANDARD_RIGHTS_READ/*or 0*/,
            	FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, 0, NULL);

  if (hDevice != INVALID_HANDLE_VALUE)
  {
    int dd_size = sizeof(STORAGE_DEVICE_DESCRIPTOR)+511;
    STORAGE_DEVICE_DESCRIPTOR *pDevDesc = (STORAGE_DEVICE_DESCRIPTOR*)sys_alloc(dd_size);
    ZeroMemory(pDevDesc,dd_size);
    pDevDesc->Size = dd_size;

    if ( GetDisksProperty(hDevice, pDevDesc) )
    {
      rc = (pDevDesc->BusType == BusTypeUsb);
    }

    sys_free(pDevDesc);
    CloseHandle(hDevice);
  }

  return rc;
}



__declspec(dllexport) BOOL __cdecl IsDriveTrueRemovableI(int drive)
{
  char s[10];

  wsprintf(s,"%c:",drive+'A');

  return IsDriveTrueRemovableS(s);
}



