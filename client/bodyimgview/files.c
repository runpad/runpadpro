
#include <windows.h>
#include <shlwapi.h>
#include "utils.h"
#include "gdip.h"
#include "files.h"
#include "../rp_shared/rp_shared.h"


static char *path;

static char filepath[MAX_PATH];   // Pattern to return full file path (internally used)
static char *filepath_end;        // Pointer to character after last '\' in filepath. Speedup access.


typedef struct 
{
  char *filename; 
  int flags;      
} FILEINFO;

#define FILE_PICTURE_BAD   0x04  // file content is not picture.
#define FILE_ROTATE_MASK   0x03  // rotation bits.

static FILEINFO* files;    // array of file names in directory
static int numfiles = 0;   // number of filled records
static int reserved = 0;   // space reserved to fill files array
static int curfile = -1;   // current position - pointer to viewed file

static FILEINFO first_file; // Stores info about file from command line or current file(during rescan).

static char* *masks;
static int  nummasks;


static HANDLE mutex;
static HANDLE thread;
static volatile int thread_stop;
volatile int pause_changehandler = 0;

static void AddFile(char* file)
{
  if ( reserved == 0 )
     {
       files = sys_alloc(sizeof(FILEINFO));
       reserved = 1;
     }

  // extend files array if needed
  if ( numfiles == reserved )
     {
       FILEINFO *new_files;
       reserved <<= 1;
       new_files = (FILEINFO*) sys_alloc (sizeof(FILEINFO) * reserved);
       sys_memcpy (new_files, files, sizeof(FILEINFO) * numfiles);
       sys_free(files);
       files = new_files;
     }

  files[numfiles].filename = sys_alloc(lstrlen(file)+1);
  lstrcpy(files[numfiles].filename, file);
  files[numfiles].flags = 0;

  numfiles++;
}

static void AddFileCurrent(char* file)
{
  curfile = numfiles;
  AddFile(file);
  files[curfile].flags = first_file.flags;
}

static DWORD WINAPI ChangeHandler(LPVOID lpParameter)
{
  static char s[MAX_PATH];
  HANDLE h;

  ScanDirectory(path, first_file.filename);

  *filepath_end = '\0'; // cut the path string

  h = FindFirstChangeNotification(filepath,TRUE,FILE_NOTIFY_CHANGE_FILE_NAME | FILE_NOTIFY_CHANGE_DIR_NAME | FILE_NOTIFY_CHANGE_ATTRIBUTES | FILE_NOTIFY_CHANGE_LAST_WRITE);
  if ( h == INVALID_HANDLE_VALUE )
     return 1;

  do {
    if ( thread_stop )
       break;
    
    if ( WaitForSingleObject(h,50) == WAIT_OBJECT_0 )
       {
         if ( !pause_changehandler )
            {
              Sleep(500);
              lstrcpy(s, curfile == -1 ? first_file.filename : files[curfile].filename);
              ReScanDirectory(s);
            }
         else
            Sleep(10);
 
         if ( !FindNextChangeNotification(h) )
            break;
       }
  } while (1);
 
  FindCloseChangeNotification(h);
  return 1;
}
 

void InitFiles(char* _path, char* _file)
{
  path = _path;
  lstrcpy(filepath, path);
  filepath_end = filepath + lstrlen(filepath);
  if ( *filepath != '\0' && *(filepath_end-1) != '\\' )
     {
       *filepath_end++ = '\\';
       *filepath_end = '\0'; // cut the path string
     }
  first_file.filename = _file;

  mutex = CreateMutex(NULL, FALSE, NULL);
}

static void FreeFiles()
{
  int i;
  
  if (reserved > 0)
  {
    for ( i = 0; i<numfiles; i++ )
        sys_free(files[i].filename);
    sys_free(files);
    numfiles = 0;
    reserved = 0;
  }
  curfile = -1;
}

void DoneFiles()
{
  thread_stop = 1;
  if ( WaitForSingleObject(thread,500) == WAIT_TIMEOUT )
     TerminateThread(thread,1);
  CloseHandle(thread);
  
  CloseHandle(mutex);

  FreeFiles();  
}

void RunFilesThread(void)
{
  DWORD rc;
  thread_stop = 0;
  thread = CreateThread(NULL,0,ChangeHandler,NULL,0,&rc);
}

void sScanDirectory(char* _path, char* file)
{
  const char* mask;
  WIN32_FIND_DATA f;
  HANDLE h;
  int rc,n;
 
  if (path != _path)
     {
       MessageBox(NULL,"Internal program error",NULL,MB_OK);
     }
  
  SetFirstMask();
  while (mask = GetNextMask())
  {
    *filepath_end = '\0'; // cut the path string
    lstrcat(filepath, mask);
    
    n = 0;

    h = FindFirstFile(filepath,&f);
    rc = (h != INVALID_HANDLE_VALUE);

    while ( rc )
    {
      if ( !(f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) )
         {
           if ( file && !lstrcmpi(file, f.cFileName) )
              {
                AddFileCurrent(f.cFileName);
              }
           else
              {
                AddFile(f.cFileName);           
              }
         }
      rc = FindNextFile(h,&f);
    }

    FindClose(h);
  }
  if ( curfile == -1 )
     {
       if ( !file )
          {
            if ( numfiles )
               curfile = 0;
          }
     }
}


void ScanDirectory(char* _path, char* file)
{
  char filename[MAX_PATH];
  DWORD rc;
  
  lstrcpy(filename, file);

  rc = WaitForSingleObject(mutex, 50000);
  if ( rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
  {
    sScanDirectory(_path, file);

    ReleaseMutex(mutex);
  }
}

void ReScanDirectory(char* file)
{
  char filename[MAX_PATH];
  DWORD rc;
  
  lstrcpy(filename, file);

  rc = WaitForSingleObject(mutex, 5000);
  if ( rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
  {
    FreeFiles();
  
    sScanDirectory(path, filename);

    ReleaseMutex(mutex);
  }
}


char* GetFileName(void)
{
  *filepath_end = '\0'; // cut the path string
  if ( curfile == -1 )
     lstrcat(filepath, first_file.filename);
  else
     lstrcat(filepath, files[curfile].filename);
  return filepath;
}

char GetFileRotate(void)
{
  int rc;
  rc = WaitForSingleObject(mutex, 5);
  if (rc == WAIT_OBJECT_0)
     {
       if ( curfile == -1 )
          rc = first_file.flags & FILE_ROTATE_MASK;
       else
          rc = files[curfile].flags & FILE_ROTATE_MASK;
       ReleaseMutex(mutex);
       return rc;
     }
  return 0;
}

void SetFileRotate(char rotate)
{
  int rc;
  rc = WaitForSingleObject(mutex, 5);
  if (rc == WAIT_OBJECT_0)
     {
       if ( curfile == -1 )
          first_file.flags = (first_file.flags & ~FILE_ROTATE_MASK) | rotate & FILE_ROTATE_MASK;
       else
          files[curfile].flags = (files[curfile].flags & ~FILE_ROTATE_MASK) | rotate & FILE_ROTATE_MASK;
       ReleaseMutex(mutex);
     }
}

char GetFileBad(void)
{
  int rc;
  rc = WaitForSingleObject(mutex, 5);
  if (rc == WAIT_OBJECT_0)
     {
       if ( curfile == -1 )
          rc = first_file.flags & FILE_PICTURE_BAD;
       else
          rc = files[curfile].flags & FILE_PICTURE_BAD;
       ReleaseMutex(mutex);
       return rc;
     }
  return -1;
}

void SetFileBad(void)
{
  int rc;
  rc = WaitForSingleObject(mutex, 5);
  if (rc == WAIT_OBJECT_0)
     {
       if (curfile == -1)
          first_file.flags |= FILE_PICTURE_BAD;
       else
          files[curfile].flags |= FILE_PICTURE_BAD;
       ReleaseMutex(mutex);
     }
}

char PrevFile(void)     // return 0 if pointer is set to first valid file in list
{
  int rc;
  rc = WaitForSingleObject(mutex, 50000);
  if ( rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
     {
       int new_curfile = curfile-1;
       if ( new_curfile >= 0 )
          {
            while (files[new_curfile].flags & FILE_PICTURE_BAD)
            {
              if ( --new_curfile < 0 )
                 return 0;
            }
            curfile = new_curfile;
            ReleaseMutex(mutex);  
            return 1;
          }
       ReleaseMutex(mutex);  
       return 0;
     }
  return 0;
}

char NextFile(void)     // return 0 if pointer is set to last valid file in list
{
  int rc;
  rc = WaitForSingleObject(mutex, 50000);
  if ( rc == WAIT_OBJECT_0 )//rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
     {
       int new_curfile = curfile+1;
       if (new_curfile < numfiles)
          {
            while (files[new_curfile].flags & FILE_PICTURE_BAD)
            {
              if ( ++new_curfile >= numfiles )
                 return 0;
            }
            curfile = new_curfile;
            ReleaseMutex(mutex);  
            return 1;
          }
       ReleaseMutex(mutex);  
       return 0;
     }
  return 0;
}

void FirstFile(void)    // set the pointer to the first valid file in list
{
  int rc;
  rc = WaitForSingleObject(mutex, 50000);
  if ( rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
     {
       int new_curfile = 0;
       if ( numfiles > 0 )
          {
            while (files[new_curfile].flags & FILE_PICTURE_BAD)
            {
              if ( ++new_curfile >= numfiles )
                 return;
            }
            curfile = new_curfile;
          }
        ReleaseMutex(mutex);  
      }
}

void LastFile(void)     // set the pointer to the lastt valid file in list
{
  int rc;
  rc = WaitForSingleObject(mutex, 50000);
  if ( rc != WAIT_FAILED && rc != WAIT_TIMEOUT )
     {
       int new_curfile = numfiles - 1;
       if (numfiles > 0)
          {
            while (files[new_curfile].flags & FILE_PICTURE_BAD)
            {
              if ( --new_curfile < 0 )
                 return;
            }
            curfile = new_curfile;
          }
        ReleaseMutex(mutex);  
      }
}
