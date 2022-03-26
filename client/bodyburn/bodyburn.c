
#include <windows.h>
#include <shlwapi.h>
#include "nero/NeroAPIGlue.h"


void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}


typedef BOOL (NERO_CALLBACK_ATTR *TIdleCallback) (void *pUserData);
typedef NeroUserDlgInOut (NERO_CALLBACK_ATTR *TUserDialog) (void *pUserData, NeroUserDlgInOut type, void *data);


static BOOL initialized = FALSE;
static BOOL global_abort = FALSE;
static TIdleCallback user_idlecallback = NULL;
static TUserDialog user_userdialog = NULL;


static BOOL NERO_CALLBACK_ATTR MyIdleCallback(void *pUserData)
{
  if ( user_idlecallback )
     user_idlecallback(pUserData);

  return global_abort;
}

static NeroUserDlgInOut NERO_CALLBACK_ATTR MyUserDialog(void *pUserData, NeroUserDlgInOut type, void *data)
{
  switch (type)
  {
    case DLG_NON_EMPTY_CDRW:
    case DLG_WAITCD:
    case DLG_FILESEL_IMAGE:
      if ( user_userdialog )
         return user_userdialog(pUserData,type,data);
      break;
    case DLG_AUTO_INSERT:
      return DLG_RETURN_CONTINUE;
    case DLG_DISCONNECT_RESTART:
      return DLG_RETURN_ON_RESTART;
    case DLG_DISCONNECT:
      return DLG_RETURN_CONTINUE;
    case DLG_AUTO_INSERT_RESTART:
      return DLG_RETURN_EXIT;
    case DLG_RESTART:
      return DLG_RETURN_EXIT;
    case DLG_SETTINGS_RESTART:
      return DLG_RETURN_CONTINUE;
    case DLG_OVERBURN:
      return DLG_RETURN_FALSE;
    case DLG_AUDIO_PROBLEMS:
      return DLG_RETURN_EXIT;
  }

  return DLG_RETURN_EXIT;
}


__declspec(dllexport) BOOL __cdecl BurnInit(TIdleCallback cb_func,TUserDialog ud_func,void *parm)
{
  static NERO_SETTINGS set; //must be non-auto

  if ( initialized )
     return FALSE;

  if ( !NeroAPIGlueConnect(NULL) )
     {
        return FALSE;
     }

  global_abort = FALSE;
  user_idlecallback = cb_func;
  user_userdialog = ud_func;
  
  ZeroMemory(&set,sizeof(set));
  set.nstNeroFilesPath = "NeroFiles";
  set.nstVendor = "ahead";
  set.nstSoftware = "Nero - Burning Rom";
  set.nstLanguageFile = "Nerorus.txt";
  set.nstIdle.ncCallbackFunction = MyIdleCallback;
  set.nstIdle.ncUserData = parm;
  set.nstUserDialog.ncCallbackFunction = MyUserDialog;
  set.nstUserDialog.ncUserData = parm;

  if ( NeroInit(&set,NULL) != NEROAPI_INIT_OK )
     {
       NeroAPIGlueDone();
       return FALSE;
     }

  initialized = TRUE;
  return TRUE;
}

static void FreeDevList(void);


__declspec(dllexport) void __cdecl BurnDone(void)
{
  if ( initialized )
     {
       FreeDevList();
       
       NeroClearErrors();
       NeroDone();
       NeroAPIGlueDone();

       initialized = FALSE;
     }
}


static NERO_SCSI_DEVICE_INFOS *dev_list = NULL;
static BOOL use_dvd = FALSE;


static void FreeDevList(void)
{
  if ( dev_list )
     {
       NeroFreeMem(dev_list);
       dev_list = NULL;
     }
}


__declspec(dllexport) int __cdecl BurnCreateDevList(BOOL dvd)
{
  if ( !initialized )
     return 0;

  FreeDevList();

  use_dvd = dvd;
  dev_list = NeroGetAvailableDrivesEx(dvd?MEDIA_DVD_ANY:MEDIA_CD,NULL);

  if ( !dev_list )
     return 0;

  return dev_list->nsdisNumDevInfos;
}


__declspec(dllexport) const char* __cdecl BurnGetDevName(int num)
{
  if ( !initialized )
     return NULL;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return NULL;

  return dev_list->nsdisDevInfos[num].nsdiDeviceName;
}


__declspec(dllexport) BOOL __cdecl BurnIsDriveAllowed(int num,BOOL allow_virtual,BOOL allow_real)
{
  DWORD cap;
  
  if ( !initialized )
     return FALSE;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return FALSE;

  cap = dev_list->nsdisDevInfos[num].nsdiCapabilities;

  if ( !(cap & NSDI_ALLOWED) )
     return FALSE;

  if ( (cap & NSDI_IMAGE_RECORDER) && allow_virtual )
     return TRUE;

  if ( !(cap & NSDI_IMAGE_RECORDER) && allow_real )
     return TRUE;

  return FALSE;
}


__declspec(dllexport) int __cdecl BurnGetDevSpeedsCount(int num)
{
  if ( !initialized )
     return 0;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return 0;

  return dev_list->nsdisDevInfos[num].nsdiWriteSpeeds.nsiNumSupportedSpeeds;
}


__declspec(dllexport) int __cdecl BurnGetDevSpeedAt(int num,int at)
{
  int count;
  NERO_SPEED_INFOS *speed;
  
  if ( !initialized )
     return 0;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return 0;

  count = dev_list->nsdisDevInfos[num].nsdiWriteSpeeds.nsiNumSupportedSpeeds;

  if ( at < 0 || at >= count )
     return 0;

  speed = &dev_list->nsdisDevInfos[num].nsdiWriteSpeeds;
  
  if ( speed->nsiBaseSpeedKBs != 0 )
     return speed->nsiSupportedSpeedsKBs[at] / speed->nsiBaseSpeedKBs;
  else
     return speed->nsiSupportedSpeeds[at];
}


__declspec(dllexport) BOOL __cdecl BurnEraseDisc(int num)
{
  int rc;
  NERO_DEVICEHANDLE handle;
  
  if ( !initialized )
     return FALSE;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return FALSE;

  handle = NeroOpenDevice(&dev_list->nsdisDevInfos[num]);

  if ( !handle )
     return FALSE;
  
  rc = NeroEraseCDRW(handle,1);

  NeroCloseDevice(handle);

  return rc?FALSE:TRUE;
}


static BOOL FileExist(char *s)
{
  return (GetFileAttributes(s) != INVALID_FILE_ATTRIBUTES);
}


#define MAXCDA 99
static struct {
char file[MAX_PATH];
int type;
} cda[MAXCDA];
static int num_cda = 0;


static BOOL IsAudioFile(char *s,BOOL audio_cd)
{
  BOOL rc = FALSE;

  if ( audio_cd )
     {
       if ( num_cda < MAXCDA )
          {
            if ( FileExist(s) && !PathIsDirectory(s) )
               {
                 int type = -1;
                 char *ext = PathFindExtension(s);
                 if ( !lstrcmpi(ext,".wav") )
                    type = NERO_ET_FILE;
                 else
                 if ( !lstrcmpi(ext,".mp3") )
                    type = NERO_ET_FILE_MP3;
                 else
                 if ( !lstrcmpi(ext,".wma") )
                    type = NERO_ET_FILE_WMA;

                 if ( type != -1 )
                    {
                      lstrcpy(cda[num_cda].file,s);
                      cda[num_cda].type = type;
                      num_cda++;
                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}


static NERO_ISO_ITEM *CreateTree4Dir(char *path,BOOL audio_cd)
{
  NERO_ISO_ITEM *root = NULL;
  NERO_ISO_ITEM *last = NULL;
  WIN32_FIND_DATA f;
  char s[MAX_PATH]; 
  HANDLE h;
  int rc;

  lstrcpy(s,path);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  h = FindFirstFile(s,&f);
  rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         lstrcpy(s,path);
         PathAddBackslash(s);
         lstrcat(s,f.cFileName);

         if ( !IsAudioFile(s,audio_cd) )
            {
              NERO_ISO_ITEM *item = NeroCreateIsoItem();
              ZeroMemory(item,sizeof(*item));
              item->nextItem = NULL;
              lstrcpy(item->fileName,f.cFileName);
              item->isDirectory = ((f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)?TRUE:FALSE);

              if ( item->isDirectory )
                 {
                   item->subDirFirstItem = CreateTree4Dir(s,audio_cd);
                 }
              else
                 {
                   lstrcpy(item->sourceFilePath,s);
                 }

              if ( !root )
                 {
                   root = item;
                   last = item;
                 }
              else
                 {
                   last->nextItem = item;
                   last = item;
                 }
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
  
  return root;
}


static NERO_ISO_ITEM *CreateTree(char *flist,BOOL audio_cd)
{
  NERO_ISO_ITEM *root = NULL;
  NERO_ISO_ITEM *last = NULL;

  num_cda = 0;
  
  if ( !flist || !flist[0] )
     return NULL;

  while ( *flist )
  {
    char s[MAX_PATH];

    lstrcpy(s,flist);
    PathRemoveBackslash(s);

    if ( lstrcmpi(s,".") && lstrcmpi(s,"..") && lstrlen(s) > 3 && FileExist(s) )
       {
         if ( !IsAudioFile(s,audio_cd) )
            {
              NERO_ISO_ITEM *item = NeroCreateIsoItem();
              ZeroMemory(item,sizeof(*item));
              lstrcpy(item->fileName,PathFindFileName(s));
              item->nextItem = NULL;
              item->isDirectory = PathIsDirectory(s);
              if ( item->isDirectory )
                 {
                   item->subDirFirstItem = CreateTree4Dir(s,audio_cd);
                 }
              else
                 {
                   lstrcpy(item->sourceFilePath,flist);
                 }

              if ( !root )
                 {
                   root = item;
                   last = item;
                 }
              else
                 {
                   last->nextItem = item;
                   last = item;
                 }
            }
       }

    flist += lstrlen(flist)+1;
  }

  return root;
}


static NERO_ISO_ITEM* GetReferenceTree(NERO_DEVICEHANDLE handle)
{
  NERO_ISO_ITEM *root = NULL;

  NERO_CD_INFO *info = NeroGetCDInfo(handle,0);
  if ( info )
     {
       int import_track = info->ncdiNumTracks-1;
       
       if ( import_track != -1 )
          {
            void *stamp = NULL;
            
            root = NeroImportIsoTrackEx(handle,import_track,&stamp,0/*NIITEF_IMPORT_ISO_ONLY|NIITEF_IMPORT_UDF*/);

            if ( stamp )
               NeroFreeCDStamp(stamp);
          }

       NeroFreeMem(info);
     }

  return root;
}


static char *GetFileName(NERO_ISO_ITEM *i)
{
  return i->longFileName ? i->longFileName : i->fileName;
}


// in ref must be used only ->fileName[] member, but no ->longFileName!!!
static BOOL CheckCollisions(NERO_ISO_ITEM *base,NERO_ISO_ITEM *ref)
{
  NERO_ISO_ITEM *p,*q;
  BOOL rc = FALSE;
  
  if ( !base || !ref )
     return rc;

  for ( p = base; p; p = p->nextItem )
      {
        char *name = GetFileName(p);

        if ( name && name[0] )
           {
             for ( q = ref; q; q = q->nextItem )
                 {
                   char *ref_name = GetFileName(q);

                   if ( ref_name && ref_name[0] )
                      {
                        if ( !lstrcmpi(name,ref_name) )
                           {
                             lstrcat(ref_name,".__dup");
                             rc = TRUE;
                             break;
                           }
                      }
                 }
           }
      }

  return rc;
}


// result = tree1+tree2
static NERO_ISO_ITEM* CombineTrees(NERO_ISO_ITEM *tree1,NERO_ISO_ITEM *tree2)
{
  if ( !tree1 && !tree2 )
     return NULL;

  if ( !tree1 )
     return tree2;

  if ( !tree2 )
     return tree1;

  {
    NERO_ISO_ITEM *ref = tree1;
    
    while ( ref->nextItem )
    {
      ref = ref->nextItem;
    }

    ref->nextItem = tree2;
  }

  return tree1;
}


typedef BOOL (NERO_CALLBACK_ATTR *TProgressCallback)(void *pUserData, DWORD dwProgressInPercent);
typedef void (NERO_CALLBACK_ATTR *TAddLogLine)(void *pUserData, NERO_TEXT_TYPE type, const char *text);
typedef void (NERO_CALLBACK_ATTR *TSetPhaseCallback)(void *pUserData, const char *text);

static TProgressCallback user_progresscallback = NULL;


static BOOL NERO_CALLBACK_ATTR MyProgressCallback(void *pUserData, DWORD dwProgressInPercent)
{
  if ( user_progresscallback )
     user_progresscallback(pUserData,dwProgressInPercent);

  return global_abort;
}


static BOOL NERO_CALLBACK_ATTR MyAbortedCallback(void *pUserData)
{
  return global_abort;
}


__declspec(dllexport) void __cdecl BurnAsyncCancelOperation(void)
{
  if ( initialized )
     global_abort = TRUE;
}


__declspec(dllexport) BOOL __cdecl BurnDisc(int num,
                                            char *flist,char *label,
                                            DWORD flags,
                                            int speed,
                                            void *parm,
                                            TProgressCallback cb_progress,
                                            TAddLogLine cb_addlogline,
                                            TSetPhaseCallback cb_setphase,
                                            int cd_type // 0-data, 1-image, 2-audio
                                            )
{
  BOOL res = FALSE;
  NERO_DEVICEHANDLE handle;
  
  if ( !initialized )
     return res;

  if ( !dev_list || num < 0 || num >= dev_list->nsdisNumDevInfos )
     return res;

  if ( !flist || !flist[0] )
     return res;

  if ( !label )
     label = "";

  global_abort = FALSE;

  handle = NeroOpenDevice(&dev_list->nsdisDevInfos[num]);

  if ( handle )
     {
       NERO_PROGRESS progress;
       DWORD burn_flags;

       user_progresscallback = cb_progress;
       ZeroMemory(&progress,sizeof(progress));
       progress.npProgressCallback = MyProgressCallback;
       progress.npAbortedCallback = MyAbortedCallback;
       progress.npAddLogLineCallback = cb_addlogline;
       progress.npSetPhaseCallback = cb_setphase;
       progress.npUserData = parm;
       progress.npDisableAbortCallback = NULL;
       progress.npSetMajorPhaseCallback = NULL;	
       progress.npSubTaskProgressCallback = NULL;

       burn_flags = flags | NBF_BUF_UNDERRUN_PROT | NBF_WRITE | NBF_DETECT_NON_EMPTY_CDRW;

       if ( cd_type == 1 /*IMAGE*/ )
          {
            cd_type = 0; //DATA
            
            if ( flist[lstrlen(flist)+1] == 0 )
               {
                 char *ext = PathFindExtension(flist);
                 if ( !lstrcmpi(ext,".iso") || !lstrcmpi(ext,".nrg") || !lstrcmpi(ext,".cue") )
                    {
                      if ( !PathIsDirectory(flist) && FileExist(flist) )
                         cd_type = 1;
                    }
               }
          }

       if ( cd_type != 1 )
          {
            BOOL audio_cd = (cd_type == 2);
            NERO_ISO_ITEM *tree1 = GetReferenceTree(handle);
            NERO_ISO_ITEM *tree2 = CreateTree(flist,audio_cd);
            BOOL was_collisions = CheckCollisions(tree1,tree2);
            NERO_ISO_ITEM *root = CombineTrees(tree1,tree2);
            
            if ( root || num_cda )
               {
                 NERO_WRITE_CD *w;
                 int s_size = sizeof(NERO_WRITE_CD);
                 if ( num_cda > 1 )
                    s_size += (num_cda-1) * sizeof(NERO_AUDIO_TRACK);
                 w = sys_alloc(s_size);
                 ZeroMemory(w,s_size);

                 w->nwcdMediaType = use_dvd ? MEDIA_DVD_ANY : MEDIA_CD;
                 w->nwcdNumTracks = num_cda;

                 if ( num_cda )
                    {
                      int n;
                      
                      w->nwcdArtist = NULL;
                      w->nwcdTitle = NULL;//label;

                      for ( n = 0; n < num_cda; n++ )
                          {
                            w->nwcdTracks[n].natPauseInBlksBeforeThisTrack = 150;
                            w->nwcdTracks[n].natSourceDataExchg.ndeType = cda[n].type;
                            w->nwcdTracks[n].natSourceDataExchg.ndeData.ndeLongFileName.ptr = cda[n].file;
                          }
                    }

                 if ( root )
                    {
                      w->nwcdIsoTrack = NeroCreateIsoTrackEx(root,label,NCITEF_USE_JOLIET|NCITEF_RELAX_JOLIET|NCITEF_CREATE_ISO_FS);
                    }

                 if ( NeroBurn(handle,NERO_ISO_AUDIO_MEDIA,w,burn_flags,speed,&progress) == NEROAPI_BURN_OK )
                    res = TRUE;

                 if ( w->nwcdIsoTrack )
                    NeroFreeIsoTrack(w->nwcdIsoTrack);

                 if ( root )
                    NeroFreeIsoItemTree(root);

                 sys_free(w);
               }
          }
       else
          {
            NERO_WRITE_IMAGE w;

            ZeroMemory(&w,sizeof(w));
            lstrcpy(w.nwiImageFileName,flist);
            w.nwiMediaType = use_dvd ? MEDIA_DVD_ANY : MEDIA_CD;

            if ( NeroBurn(handle,NERO_BURN_IMAGE_MEDIA,&w,burn_flags,speed,&progress) == NEROAPI_BURN_OK )
               res = TRUE;
          }
       
       NeroCloseDevice(handle);
     }

  global_abort = FALSE;
  return res;
}
