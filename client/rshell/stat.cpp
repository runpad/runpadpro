
#include "include.h"



#define STAT_VER         100
#define STAT_DEFSHEET    "def"
#define STAT_IESHEET     STR_009
#define STAT_ZPZDCOUNT   0x01
#define STAT_ZPZDTIME    0x00
#define STAT_MAXPROGRAMS 15


static const __int64 one_day = 864000000000LL;
static const unsigned one_minute = 600000000;
static const unsigned one_second = 10000000;
static const unsigned minutes_in_day = (24*60);


typedef struct {
int used;
char sheet_name[MAX_PATH];
int sheet_color;
int sheet_iconsize;
void *sheet_icon;
char name[MAX_PATH];
int iconsize;
void *icon;
HANDLE process;
int pid;
unsigned last_update_time;
int firsttime;
} STATINFO;


static STATINFO stats[STAT_MAXPROGRAMS] = {{0,},};



typedef struct {
char sheet_name[MAX_PATH];
char **programs;
int numprograms;
int maxprograms;
unsigned interval;
} STATPROGRAMS;


static int EnumProgramsFunc(HKEY root,const char *key,void *param)
{
  STATPROGRAMS *i = (STATPROGRAMS*)param;
  HKEY h;
  int rc = 0;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       unsigned s_time = ReadRegDwordP(h,"stime",0);
       unsigned e_time = ReadRegDwordP(h,"etime",0);
       unsigned curr_time = GetLocalTimeMin();
       unsigned cut_time = curr_time - i->interval;

       if ( !s_time || !e_time || s_time >= e_time || e_time < cut_time )
          {
            // add to delete list
            if ( i->numprograms < i->maxprograms )
               {
                 char s[MAX_PATH],*buff;

                 lstrcpy(s,i->sheet_name);
                 PathAddBackslash(s);
                 lstrcat(s,key);
                 PathRemoveBackslash(s);
                 buff = (char*)sys_alloc(lstrlen(s)+1);
                 lstrcpy(buff,s);
                 
                 i->programs[i->numprograms++] = buff;
                 rc = 1;
               }
          }

       RegCloseKey(h);
     }

  return rc;
}


static int EnumSheetsFunc(HKEY h,const char *key,void *param)
{
  STATPROGRAMS *i = (STATPROGRAMS*)param;

  lstrcpy(i->sheet_name,key);
  
  return EnumerateRegistryKeys(h,key,EnumProgramsFunc,param);
}


static unsigned GetClearStatIntervalInMin(void)
{
  unsigned interval = clear_stat_interval;

  if ( interval < 1 )
     interval = 1;
  if ( interval > 12 )
     interval = 12;
  interval *= 30 * minutes_in_day;

  return interval;
}


void DeleteAllStat(void)
{
  DeleteRegKey(HKCU,REGPATH "\\Stat");
}


void ProcessStatAtStartup(void)
{
  char root[MAX_PATH];
  char s[MAX_PATH];
  HKEY h;
  STATPROGRAMS i;
  int n;

  i.interval = GetClearStatIntervalInMin();
  i.sheet_name[0] = 0;
  i.maxprograms = 50000;
  i.numprograms = 0;
  i.programs = (char**)sys_alloc(i.maxprograms*sizeof(*i.programs));

  lstrcpy(root,REGPATH "\\Stat");

  EnumerateRegistryKeys(HKCU,root,EnumSheetsFunc,&i);

  if ( RegOpenKeyEx(HKCU,root,0,KEY_READ|KEY_WRITE,&h) == ERROR_SUCCESS )
     {
       int n;
       
       for ( n = 0; n < i.numprograms; n++ )
           DeleteRegKey(h,i.programs[n]);

       RegCloseKey(h);
     }

  for ( n = 0; n < i.numprograms; n++ )
      sys_free(i.programs[n]);

  sys_free(i.programs);
}


static BOOL IsProcessHiddenDaemon(int pid)
{
  BOOL rc = FALSE;
  
  if ( pid != -1 )
     {
       if ( !HasProcessAppWindow(pid) )
          {
            unsigned t_process = GetProcessCreationTimeInSec(pid);
            if ( t_process )
               {
                 __int64 ft = GetSystemTime64();
                 unsigned t_now = GetNormalTimeSec((FILETIME*)&ft);

                 if ( t_now - t_process > 10 )
                    {
                      rc = TRUE;
                    }
               }
          }
     }

  return rc;
}


static void UpdateSingleStat(STATINFO *info)
{
  unsigned delta,curr_time;
  unsigned flags;
  char s[MAX_PATH];
  HKEY h;
  
  if ( !info->used )
     return;

  curr_time = GetTickCount();
  delta = curr_time - info->last_update_time;

  if ( delta < 60000 )
     return;

  info->last_update_time = curr_time - (delta % 60000);

  if ( !info->process )
     {
       flags = STAT_ZPZDCOUNT;
       info->used = 0;
     }
  else
     {
       flags = STAT_ZPZDTIME;

       DWORD rc = WaitForSingleObject(info->process,0);
       if ( rc == WAIT_FAILED || rc == WAIT_OBJECT_0 /*|| IsProcessHiddenDaemon(info->pid)*/ )
          {
            int child = FindLastProcessChild(info->pid);
            if ( child != -1 )
               {
                 CloseHandle(info->process);
                 info->process = OpenProcess(SYNCHRONIZE,FALSE,child);
                 info->pid = child;

                 if ( !info->process )
                    info->used = 0;
               }
            else
               {
                 CloseHandle(info->process);
                 info->used = 0;
               }
          }
     }

  wsprintf(s,"%s\\%s",REGPATH "\\Stat",info->sheet_name);
  WriteRegDword(HKCU,s,"color",info->sheet_color);

  if ( info->firsttime )
     {
       if ( info->sheet_iconsize && info->sheet_icon )
          WriteRegBin(HKCU,s,"icon",(char*)info->sheet_icon,info->sheet_iconsize);
       else
          DeleteRegValue(HKCU,s,"icon");
     }

  lstrcat(s,"\\");
  lstrcat(s,info->name);

  if ( RegCreateKeyEx(HKCU,s,0,NULL,REG_OPTION_NON_VOLATILE,KEY_WRITE|KEY_READ,NULL,&h,NULL) == ERROR_SUCCESS )
     {
       int len,count;
       unsigned short pop[366];
       unsigned s_time,e_time;

       WriteRegDwordP(h,"color",info->sheet_color);
       
       if ( info->firsttime )
          {
            if ( info->iconsize && info->icon )
               WriteRegBinP(h,"icon",(char*)info->icon,info->iconsize);
            else
               RegDeleteValue(h,"icon");
          }

       WriteRegDwordP(h,"flags",flags);

       ZeroMemory(pop,sizeof(pop));
       ReadRegBinP(h,"pop",(char*)pop,sizeof(pop),&len);
       count = len/sizeof(pop[0]);

       if ( count == 0 )
          {
            pop[0] = 1;
            count = 1;

            e_time = GetLocalTimeMin();
            s_time = e_time - 1;
          }
       else
          {
            s_time = ReadRegDwordP(h,"stime",0);
            e_time = GetLocalTimeMin();

            if ( s_time && e_time > s_time )
               {
                 unsigned s_day = s_time / minutes_in_day;
                 unsigned e_day = e_time / minutes_in_day;
                 unsigned day_offset = e_day - s_day;

                 if ( day_offset < sizeof(pop)/sizeof(pop[0]) )
                    {
                      unsigned cut_time = e_time - GetClearStatIntervalInMin();
                      unsigned cut_day = cut_time / minutes_in_day;
                      int cut_offset = (int)cut_day - (int)s_day;

                      pop[day_offset]++;
                      count = day_offset + 1;

                      if ( cut_offset > 0 && cut_offset < count )
                         {
                           int n;
                           
                           for ( n = 0; n < count - cut_offset; n++ )
                               pop[n] = pop[n + cut_offset];

                           count -= cut_offset;
                           s_time = cut_day * minutes_in_day;
                         }
                    }
               }
          }

       WriteRegDwordP(h,"stime",s_time);
       WriteRegDwordP(h,"etime",e_time);
       WriteRegBinP(h,"pop",(char*)pop,count*sizeof(pop[0]));
          
       RegCloseKey(h);
     }

  if ( !info->used )
     {
       if ( info->icon )
          sys_free(info->icon);
       if ( info->sheet_icon )
          sys_free(info->sheet_icon);
       info->icon = NULL;
       info->iconsize = 0;
       info->sheet_icon = NULL;
       info->sheet_iconsize = 0;
     }

  info->firsttime = 0;
}


void UpdateStat(void)
{
  int n;
  
  if ( !stat_enable )
     return;

  for ( n = 0; n < STAT_MAXPROGRAMS; n++ )
      if ( stats[n].used )
         UpdateSingleStat(&stats[n]);
}


void Add2Stat(const CSheet *run_sheet,const char *title,int pid,HICON icon,BOOL is_from_ie)
{
  char sheet_name[MAX_PATH];
  int sheet_color;
  void *rawicon;
  int rawiconsize;
  void *sheet_rawicon;
  int sheet_rawiconsize;
  STATINFO *info;
  HICON sheet_icon;
  int n;

  if ( !title || !title[0] )
     return;

  info = NULL;
  for ( n = 0; n < STAT_MAXPROGRAMS; n++ )
      if ( !stats[n].used )
         {
           info = &stats[n];
           break;
         }

  if ( !info )
     return;

  if ( !run_sheet && !is_from_ie )
     {
       lstrcpy(sheet_name,STAT_DEFSHEET);
       sheet_color = def_sheet_color;
       sheet_icon = NULL;
     }
  else
  if ( !run_sheet && is_from_ie )
     {
       lstrcpy(sheet_name,STAT_IESHEET);
       sheet_color = def_sheet_color;
       sheet_icon = LoadIcon(our_instance,MAKEINTRESOURCE(IDI_IE));
     }
  else
     {
       lstrcpy(sheet_name,run_sheet->GetName());
       sheet_color = run_sheet->GetColor();
       sheet_icon = (HICON)LoadImage(our_instance,MAKEINTRESOURCE(IDI_DEFSHEET),IMAGE_ICON,16,16,LR_SHARED);
     }

  if ( icon )
     {
       rawicon = GetIconRaw(icon,&rawiconsize);
     }
  else
     {
       rawicon = NULL;
       rawiconsize = 0;
     }

  if ( sheet_icon )
     {
       sheet_rawicon = GetIconRaw(sheet_icon,&sheet_rawiconsize);
     }
  else
     {
       sheet_rawicon = NULL;
       sheet_rawiconsize = 0;
     }

  info->used = 1;
  lstrcpy(info->sheet_name,sheet_name);
  info->sheet_color = sheet_color;
  info->sheet_iconsize = sheet_rawiconsize;
  info->sheet_icon = sheet_rawicon;
  info->iconsize = rawiconsize;
  info->icon = rawicon;
  lstrcpy(info->name,title);
  info->process = (pid != -1) ? OpenProcess(SYNCHRONIZE,FALSE,pid) : NULL;
  info->pid = pid;
  info->last_update_time = GetTickCount();
  info->firsttime = 1;
}


typedef struct {
void *f;
int is_graphics;
int is_pop;
unsigned s_day;
unsigned e_day;
char local_path[MAX_PATH];
} SAVEINFO;


static void SaveSingleEntry(HKEY root,const char *key,const char *name,SAVEINFO *i)
{
  HKEY h;
  
  if ( !i->is_graphics && !i->is_pop )
     return;

  if ( RegOpenKeyEx(root,key,0,KEY_READ,&h) == ERROR_SUCCESS )
     {
       const char *write_name = name;

       if ( !lstrcmpi(name,STAT_DEFSHEET) )
          write_name = "";
       else
          {
            const char *cmp = STAT_DEFSHEET "\\";
            if ( !StrCmpNI(name,cmp,lstrlen(cmp)) )
               {
                 char *p = StrChr(name,'\\');
                 if ( p )
                    write_name = p;
               }
          }
          
       if ( i->is_graphics )
          {
            static char icon[65536];
            int icon_size,color;
            char id = 'e';
            
            color = ReadRegDwordP(h,"color",def_sheet_color);
            ReadRegBinP(h,"icon",icon,sizeof(icon),&icon_size);

            sys_fwrite(i->f,&id,1);
            sys_fwrite(i->f,write_name,lstrlen(write_name)+1);
            sys_fwrite(i->f,&color,3);
            sys_fwrite(i->f,&icon_size,4);
            if ( icon_size )
               sys_fwrite(i->f,icon,icon_size);
          }

       if ( i->is_pop )
          {
            unsigned s_time,e_time;

            s_time = ReadRegDwordP(h,"stime",0);
            e_time = ReadRegDwordP(h,"etime",0);

            if ( s_time && e_time && s_time < e_time )
               {
                 int len,count;
                 unsigned short pop[366];

                 unsigned s_day = s_time / minutes_in_day;
                 unsigned e_day = e_time / minutes_in_day;

                 ZeroMemory(pop,sizeof(pop));
                 ReadRegBinP(h,"pop",(char*)pop,sizeof(pop),&len);
                 count = len/sizeof(pop[0]);

                 if ( count && count == e_day - s_day + 1 )
                    {
                      unsigned req_s_day = i->s_day;
                      unsigned req_e_day = i->e_day;

                      if ( req_s_day == 0 && req_e_day == 0 )
                         {
                           req_s_day = 0;
                           req_e_day = 1000000;
                         }

                      if ( !(req_e_day < s_day || req_s_day > e_day) )
                         {
                           int write_s_offset = 0;
                           int write_e_offset = count-1;
                           unsigned write_s_time = s_time;
                           unsigned write_e_time = e_time;

                           if ( req_s_day > s_day )
                              {
                                write_s_offset = req_s_day - s_day;
                                write_s_time = req_s_day * minutes_in_day;
                              }

                           if ( req_e_day < e_day )
                              {
                                write_e_offset = count-1 - (e_day - req_e_day);
                                write_e_time = (req_e_day + 1) * minutes_in_day - 1;
                              }

                           if ( write_s_offset >= 0 && write_s_offset < count &&
                                write_e_offset >= 0 && write_e_offset < count &&
                                write_s_offset <= write_e_offset )
                              {
                                char id = 'r';
                                char flags = ReadRegDwordP(h,"flags",0);
                                __int64 wt_s = (__int64)write_s_time * one_minute;
                                __int64 wt_e = (__int64)write_e_time * one_minute;
                                int write_count = write_e_offset - write_s_offset + 1;
                                unsigned short term = 0xFFFF;

                                sys_fwrite(i->f,&id,1);
                                sys_fwrite(i->f,write_name,lstrlen(write_name)+1);
                                sys_fwrite(i->f,&flags,1);
                                sys_fwrite(i->f,&wt_s,8);
                                sys_fwrite(i->f,&wt_e,8);
                                sys_fwrite(i->f,&pop[write_s_offset],write_count*sizeof(pop[0]));
                                sys_fwrite(i->f,&term,2);
                              }
                         }
                    }
               }
          }
       
       RegCloseKey(h);
     }
}


static int EnumPrograms4SaveFunc(HKEY h,const char *key,void *param)
{
  SAVEINFO *i = (SAVEINFO*)param;
  char s[MAX_PATH];

  lstrcpy(s,i->local_path);
  PathAddBackslash(s);
  lstrcat(s,key);
  PathRemoveBackslash(s);

  SaveSingleEntry(h,key,s,i);
  
  return 1;
}


static int EnumSheets4SaveFunc(HKEY h,const char *key,void *param)
{
  SAVEINFO *i = (SAVEINFO*)param;

  lstrcpy(i->local_path,key);
  PathRemoveBackslash(i->local_path);

  SaveSingleEntry(h,key,i->local_path,i);
  
  return EnumerateRegistryKeys(h,key,EnumPrograms4SaveFunc,param);
}


void SaveStatToFile(const char *filename/*,const char *info*/)
{
  int /*flags,*/is_datas,is_graphics,is_pop,is_onlyone;
  __int64 data1,data2;
  char req_name[MAX_PATH];
  void *f;
  
//  if ( !info )
//     return;

//  if ( *info++ != STAT_VER )
//     return;

//  flags = *info++;
//  is_datas = !(flags & 1);
//  is_graphics = flags & 2;
//  is_pop = flags & 4;
//  is_onlyone = flags & 8;

  is_datas = FALSE;
  is_graphics = TRUE;
  is_pop = TRUE;
  is_onlyone = FALSE;

//  if ( is_datas )
//     {
//       data1 = *(__int64*)info;
//       info += 8;
//       data2 = *(__int64*)info;
//       info += 8;
//
//       if ( !data1 || !data2 || data1 > data2 )
//          return;
//     }
//  else
     {
       data1 = 0;
       data2 = 0;
     }

//  if ( is_onlyone )
//     lstrcpy(req_name,info);
//  else
     req_name[0] = 0;

  f = sys_fcreate(filename);
  if ( !f )
     return;

  if ( is_graphics || is_pop )
     {
       SAVEINFO i;
       char root[MAX_PATH];
       
       unsigned req_s_day = data1 / one_minute / minutes_in_day;
       unsigned req_e_day = data2 / one_minute / minutes_in_day;

       if ( req_name[0] == '\\' )
          {
            char s[MAX_PATH];
            wsprintf(s,"%s%s",STAT_DEFSHEET,req_name);
            lstrcpy(req_name,s);
          }

       PathRemoveBackslash(req_name);

       i.f = f;
       i.is_graphics = is_graphics;
       i.is_pop = is_pop;
       i.s_day = req_s_day;
       i.e_day = req_e_day;
       i.local_path[0] = 0;

       lstrcpy(root,REGPATH "\\Stat");

       if ( !req_name[0] )
          EnumerateRegistryKeys(HKCU,root,EnumSheets4SaveFunc,&i);
       else
          {
            HKEY h;
            
            if ( RegOpenKeyEx(HKCU,root,0,KEY_READ,&h) == ERROR_SUCCESS )
               {
                 SaveSingleEntry(h,req_name,req_name,&i);
                 RegCloseKey(h);
               }
          }
     }

  sys_fclose(f);
}
