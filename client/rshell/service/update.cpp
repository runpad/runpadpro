
#include "include.h"
//#include <stdio.h>

static const char* UPDATE_DIR = "~RPS_UPD.TMP";



CUpdate::CUpdateFile::CUpdateFile( unsigned _id,
                                   const char *_envpath,
                                   const char *_fullpath,
                                   const char *_basedir,
                                   const char *_crc32)
{
  u_id = _id;
  s_envpath = sys_copystring(_envpath);
  s_fullpath = sys_copystring(_fullpath);
  s_basedir = sys_copystring(_basedir);
  s_crc32 = sys_copystring(_crc32);
  p_buff = NULL;
  u_size = 0;
  u_tag = 0;
}


CUpdate::CUpdateFile::~CUpdateFile()
{
  if ( s_envpath )
     sys_free(s_envpath);
  if ( s_fullpath )
     sys_free(s_fullpath);
  if ( s_basedir )
     sys_free(s_basedir);
  if ( s_crc32 )
     sys_free(s_crc32);
  if ( p_buff )
     sys_free(p_buff);
}


BOOL CUpdate::CUpdateFile::LoadData(const void *buff,unsigned size)
{
  if ( p_buff )
     sys_free(p_buff);

  p_buff = NULL;
  u_size = 0;

  if ( buff )
     {
       p_buff = sys_alloc(size);

       if ( p_buff )
          {
            u_size = size;

            if ( size )
               {
                 CopyMemory(p_buff,buff,size);
               }
          }
     }

  return p_buff != NULL;
}


CUpdate::CUpdate()
{
  g_state = STATE_READY;
  b_reboot_after_finish = FALSE;
  b_force_reboot = FALSE;
}


CUpdate::~CUpdate()
{
  FreeFiles();
}


void CUpdate::FreeFiles()
{
  for ( int n = 0; n < g_files.size(); n++ )
      {
        if ( g_files[n] )
           {
             delete g_files[n];
             g_files[n] = NULL;
           }
      }

  g_files.clear();
}


BOOL CUpdate::GetCUnsigned(const char* &src,unsigned &src_size,unsigned *p_value)
{
  BOOL rc = FALSE;

  if ( src && src_size > 0 )
     {
       if ( src_size >= sizeof(unsigned) )
          {
            *p_value = *(const unsigned *)src;

            src += sizeof(unsigned);
            src_size -= sizeof(unsigned);

            rc = TRUE;
          }
     }

  return rc;
}


BOOL CUpdate::GetCString(const char* &src,unsigned &src_size,const char **p_value,int max)
{
  BOOL rc = FALSE;

  if ( src && src_size > 0 && max > 0 )
     {
       *p_value = src;

       int count = 0;
       
       do {
         char c = *src++;
         src_size--;

         count++;

         if ( count == max || src_size == 0 || c == 0 )
            {
              rc = (c == 0);
              break;
            }

       } while ( 1 );
     }

  return rc;
}


BOOL CUpdate::GetCBuff(const char* &src,unsigned &src_size,const void **p_value,unsigned buff_size)
{
  BOOL rc = FALSE;

  if ( src )
     {
       if ( src_size >= buff_size )
          {
            *p_value = src;

            src += buff_size;
            src_size -= buff_size;
            rc = TRUE;
          }
     }

  return rc;
}


BOOL CUpdate::IsUpdateFinishFlag()
{
  char s[MAX_PATH];
  ReadRegStr(HKLM,REGPATH,"update_finish_flag",s,"");
  return (lstrcmpi(s,"1") == 0);
}


void CUpdate::SetUpdateFinishFlag()
{
  WriteRegStr(HKLM,REGPATH,"update_finish_flag","1");
}


void CUpdate::ClearUpdateFinishFlag()
{
  DeleteRegValue(HKLM,REGPATH,"update_finish_flag");
}


BOOL CUpdate::ExpandEnvPath(const char *envpath,char *_fullpath,char *_basedir)
{
  BOOL rc = FALSE;

  if ( _fullpath )
     _fullpath[0] = 0;

  if ( _basedir )
     _basedir[0] = 0;

  if ( !IsStrEmpty(envpath) )
     {
       if ( envpath[0] == '%' )
          {
            const char *p = StrStr(envpath+1,"%");
            if ( p )
               {
                 char s[MAX_PATH] = "";
                 lstrcpyn(s,envpath+1,p-envpath);

                 char base[MAX_PATH] = "";

                 if ( !lstrcmpi(s,"RS_FOLDER") )
                    {
                      GetModuleFileName(GetModuleHandle(NULL),base,sizeof(base));
                      PathRemoveFileSpec(base);
                    }
                 else
                 if ( !lstrcmpi(s,"SYSTEM32") )
                    {
                      GetTrueSystem32Dir(base);
                    }
                 else
                 if ( !lstrcmpi(s,"SYSTEM64") )
                    {
                      GetTrueSystem64Dir(base);
                      if ( IsStrEmpty(base) )
                         {
                           GetTrueSystem32Dir(base);
                           PathRemoveBackslash(base);
                           PathRemoveFileSpec(base);
                           PathAppend(base,"system64");  //emulation
                           CreateDirectory(base,NULL);
                         }
                    }
                 else
                 if ( !lstrcmpi(s,"DRIVERS32") )
                    {
                      GetTrueSystem32Dir(base);
                      PathAppend(base,"drivers");
                    }
                 else
                 if ( !lstrcmpi(s,"DRIVERS64") )
                    {
                      GetTrueSystem64Dir(base);
                      if ( IsStrEmpty(base) )
                         {
                           GetTrueSystem32Dir(base);
                           PathRemoveBackslash(base);
                           PathRemoveFileSpec(base);
                           PathAppend(base,"system64");  //emulation
                           CreateDirectory(base,NULL);
                         }
                      PathAppend(base,"drivers");
                      CreateDirectory(base,NULL); //paranoja
                    }
                 else
                 if ( !lstrcmpi(s,"WINDIR") )
                    {
                      GetSystemWindowsDirectory(base,sizeof(base));
                    }
                 else
                 if ( !lstrcmpi(s,"AppData") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_APPDATA,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"Desktop") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_DESKTOPDIRECTORY,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"Programs") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_PROGRAMS,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"StartMenu") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_STARTMENU,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"Startup") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_STARTUP,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"Templates") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_COMMON_TEMPLATES,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"Fonts") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_FONTS,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"ProgramFiles") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_PROGRAM_FILES,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"ProgramFilesCommon") )
                    {
                      SHGetSpecialFolderPath(NULL,base,CSIDL_PROGRAM_FILES_COMMON,TRUE);
                    }
                 else
                 if ( !lstrcmpi(s,"SystemDrive") )
                    {
                      lstrcpy(base,GetSysDrivePathWithBackslash());
                    }

                 if ( !IsStrEmpty(base) )
                    {
                      PathRemoveBackslash(base);

                      if ( base[0] != '\\' )  //network paths are not allowed
                         {
                           char t[8];

                           t[0] = base[0];
                           t[1] = ':';
                           t[2] = '\\';
                           t[3] = 0;

                           if ( GetDriveType(t) == DRIVE_FIXED )
                              {
                                char fullpath[MAX_PATH];
                                lstrcpy(fullpath,base);

                                const char *local_part = p+1;

                                if ( lstrlen(local_part) >= 2 && local_part[0] == '\\' )
                                   {
                                     PathAppend(fullpath,local_part);

                                     if ( fullpath[lstrlen(fullpath)-1] != '\\' )
                                        {
                                          if ( !StrStr(fullpath,"%") )
                                             {
                                               if ( _fullpath )
                                                  lstrcpy(_fullpath,fullpath);

                                               if ( _basedir )
                                                  lstrcpy(_basedir,base);

                                               rc = TRUE;
                                             }
                                        }
                                   }
                              }
                         }
                    }
               }
          }
     }

  return rc;
}


BOOL CUpdate::GetFileCRC32(const char *fullpath,char *_crc32)
{
  BOOL rc = FALSE;
  
  if ( _crc32 )
     _crc32[0] = 0;
  
  int size = 0;
  void* buff = ReadFullFile(fullpath,&size);
  if ( buff )
     {
       unsigned u_crc32 = Z_CRC32(buff,size);

       if ( _crc32 )
          wsprintf(_crc32,"%08X",u_crc32);

       rc = TRUE;

       sys_free(buff);
     }

  return rc;
}


void CUpdate::CleanDirNoRec(const char *_dir)
{
  char s[MAX_PATH]; 
  lstrcpy(s,_dir);
  PathAddBackslash(s);
  lstrcat(s,"*.*");

  WIN32_FIND_DATA f;
  HANDLE h = FindFirstFile(s,&f);
  BOOL rc = (h != INVALID_HANDLE_VALUE);

  while ( rc )
  {
    if ( lstrcmp(f.cFileName,".") && lstrcmp(f.cFileName,"..") )
       {
         if ( !(f.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) )
            {
              char s[MAX_PATH];
              lstrcpy(s,_dir);
              PathAppend(s,f.cFileName);
              DeleteFile(s);
            }
       }

    rc = FindNextFile(h,&f);
  }

  FindClose(h);
}


void CUpdate::StartupActions()
{
  if ( IsUpdateFinishFlag() )
     {
       ClearUpdateFinishFlag();
       InstallActions_FromSVC();

       { // update driver file
         CRollback rlb;
         int st = -1;
         if ( rlb.GetDriverStatus(st) )
            {
              if ( st == CRollback::ST_DRV_OFF_ON || st == CRollback::ST_DRV_ON_ON )
                 {
                   rlb.UpdateDriverFile();
                 }
            }
       }
     }
}


BOOL CUpdate::OnProposition(const CNetCmd &cmd_in,CNetCmd &cmd_out)
{
  BOOL rc = FALSE;

  if ( g_state == STATE_READY )
     {
       b_reboot_after_finish = cmd_in.GetParmAsBool(NETPARM_B_IMMEDIATELY,FALSE);
       b_force_reboot = cmd_in.GetParmAsBool(NETPARM_B_FORCE,FALSE);
       g_state = STATE_WAITLIST;
       rc = TRUE;
     }

  return rc;
}


BOOL CUpdate::OnListAck(const CNetCmd &cmd_in,CNetCmd &cmd_out)
{
  CDisableWOW64FSRedirection oWOW64guard; // for 64-bit systems
  
  BOOL rc = FALSE;

  if ( g_state == STATE_WAITLIST )
     {
       BOOL err = FALSE;

       FreeFiles();

       //FILE *ff = fopen("c:\\_list.txt","wt");
       
       for ( int n = 0; ; n++ )
           {
             char s[MAX_PATH];
             
             wsprintf(s,"%s%d",NETPARM_I_ID_X,n);
             unsigned id = cmd_in.GetParmAsInt(s,-1);

             wsprintf(s,"%s%d",NETPARM_S_PATH_X,n);
             const char *envpath = cmd_in.GetParmAsString(s,"");

             wsprintf(s,"%s%d",NETPARM_S_CRC32_X,n);
             const char *crc32 = cmd_in.GetParmAsString(s,"");

             if ( IsStrEmpty(envpath) || IsStrEmpty(crc32) )
                break;

             char fullpath[MAX_PATH] = "";
             char basedir[MAX_PATH] = "";
             
             if ( !ExpandEnvPath(envpath,fullpath,basedir) )
                {
                  err = TRUE;
                  break;
                }

             if ( IsFileExist(fullpath) && PathIsDirectory(fullpath) )
                {
                  err = TRUE;
                  break;
                }

             BOOL b_add = FALSE;
             
             if ( !IsFileExist(fullpath) )
                {
                  b_add = TRUE;
                }
             else
                {
                  char d_crc32[MAX_PATH] = "";

                  if ( !GetFileCRC32(fullpath,d_crc32) )
                     {
                       //err = TRUE;
                       //break;
                       b_add = TRUE; // for example SHARE_DENY files
                     }
                  else
                     {
                       b_add = (lstrcmpi(d_crc32,crc32) != 0);
                     }
                }

             if ( b_add )
                {
                  char s[MAX_PATH];
                  wsprintf(s,"%s%d",NETPARM_I_ID_X,g_files.size());
                  cmd_out.AddIntParm(s,id);

                  CUpdateFile *f = new CUpdateFile(id,envpath,fullpath,basedir,crc32);
                  f->SetTag(0);
                  g_files.push_back(f);
                  //fprintf(ff,"(+) ");
                }
             else
                {
                  //fprintf(ff,"    ");
                }
             //fprintf(ff,"%08X \"%s\" [%s] \"%s\" \"%s\"\n",id,envpath,crc32,fullpath,basedir);
           }

       //if ( err )
        //  fprintf(ff,"error!\n");
       //else
         // fprintf(ff,"no errors: %d added\n",g_files.size());

       //fclose(ff);

       if ( err || g_files.size() == 0 )
          {
            FreeFiles();
            g_state = STATE_READY;
            rc = FALSE;
          }
       else
          {
            g_state = STATE_WAITFILES;
            rc = TRUE;
          }
     }

  return rc;
}


BOOL CUpdate::OnFilesAck(const CNetCmd &cmd_in,CConfigurator *cfg,CNetObj *net_obj)
{
  CDisableWOW64FSRedirection oWOW64guard; // for 64-bit systems

  BOOL rc = FALSE;

  if ( g_state == STATE_WAITFILES )
     {
       assert( g_files.size() > 0 );
       
       const char* cbuff = cmd_in.GetCmdBuffPtr();
       unsigned csize = cmd_in.GetCmdBuffSize();

       BOOL err = FALSE;

       while ( csize > 0 ) 
       {
         unsigned id = 0;
         if ( !GetCUnsigned(cbuff,csize,&id) )
            {
              err = TRUE;
              break;
            }

         const char *envpath = NULL;
         if ( !GetCString(cbuff,csize,&envpath,MAX_PATH) )
            {
              err = TRUE;
              break;
            }

         const char *crc32 = NULL;
         if ( !GetCString(cbuff,csize,&crc32,MAX_PATH) )
            {
              err = TRUE;
              break;
            }

         // find this file in list
         CUpdateFile *f = NULL;
         for ( int n = 0; n < g_files.size(); n++ )
             {
               if ( g_files[n]->GetId() == id )
                  {
                    f = g_files[n];
                    break;
                  }
             }
         if ( !f || f->GetTag() != 0 || lstrcmpi(envpath,f->GetEnvPath()) || lstrcmpi(crc32,f->GetCRC32()) )
            {
              err = TRUE;
              break;
            }

         unsigned zsize = 0;
         if ( !GetCUnsigned(cbuff,csize,&zsize) || zsize == 0 /*todo: support empty files*/ )
            {
              err = TRUE;
              break;
            }

         const void *zbuff = NULL;
         if ( !GetCBuff(cbuff,csize,&zbuff,zsize) )
            {
              err = TRUE;
              break;
            }

         unsigned raw_size = 0;
         void *raw_buff = Z_Decompress(zbuff,zsize,&raw_size);
         if ( !raw_buff )
            {
              err = TRUE;
              break;
            }

         char cmp_crc32[MAX_PATH];
         wsprintf(cmp_crc32,"%08X",Z_CRC32(raw_buff,raw_size));
         if ( lstrcmpi(crc32,cmp_crc32) )
            {
              Z_Free(raw_buff);
              err = TRUE;
              break;
            }

         if ( !f->LoadData(raw_buff,raw_size) )
            {
              Z_Free(raw_buff);
              err = TRUE;
              break;
            }

         Z_Free(raw_buff);

         f->SetTag(1); //set used

       }; //while

       if ( !err )
          {
            // check for unused files
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  if ( g_files[n]->GetTag() == 0 )
                     {
                       err = TRUE;
                       break;
                     }
                }
          }

       if ( !err )
          {
            // create relative dest dirs
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  char dir[MAX_PATH];
                  lstrcpy(dir,g_files[n]->GetFullPath());
                  PathRemoveFileSpec(dir);
                  PathRemoveBackslash(dir);
                  SHCreateDirectoryEx(NULL,dir,NULL);
                  if ( !IsFileExist(dir) )
                     {
                       err = TRUE;
                       break;
                     }
                }
          }

       if ( !err )
          {
            // prepare src update-folders
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  char dir[MAX_PATH];
                  lstrcpy(dir,g_files[n]->GetBaseDir());
                  PathAppend(dir,UPDATE_DIR);
                  SHCreateDirectoryEx(NULL,dir,NULL);
                  if ( !IsFileExist(dir) )
                     {
                       err = TRUE;
                       break;
                     }

                  CleanDirNoRec(dir);
                }
          }

       if ( !err )
          {
            // create all files in their src-dirs
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  char dir[MAX_PATH];
                  lstrcpy(dir,g_files[n]->GetBaseDir());
                  PathAppend(dir,UPDATE_DIR);

                  char t[32];
                  wsprintf(t,"%05d",n);
                  PathAppend(dir,t);

                  if ( !WriteFullFile(dir,g_files[n]->GetBuffPtr(),g_files[n]->GetBuffSize()) )
                     {
                       err = TRUE;
                       break;
                     }
                }
          }

       if ( !err )
          {
            // schedule moving files
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  char src[MAX_PATH];
                  lstrcpy(src,g_files[n]->GetBaseDir());
                  PathAppend(src,UPDATE_DIR);

                  char t[32];
                  wsprintf(t,"%05d",n);
                  PathAppend(src,t);

                  if ( !MoveFileEx(src,g_files[n]->GetFullPath(),MOVEFILE_DELAY_UNTIL_REBOOT|MOVEFILE_REPLACE_EXISTING) )
                     {
                       err = TRUE; //must be never happens
                       break;
                     }

                  lstrcpy(src,g_files[n]->GetBaseDir());
                  PathAppend(src,UPDATE_DIR);

                  if ( !MoveFileEx(src,NULL,MOVEFILE_DELAY_UNTIL_REBOOT) )
                     {
                       err = TRUE; //must be never happens
                       break;
                     }
                }
          }

       if ( !err )
          {
            // finish
            SetUpdateFinishFlag();

            g_state = STATE_FINISH;
            rc = TRUE;

            { // turn off rollback
              CRollback rlb;

              if ( !cfg->CanAccess() || !cfg->GetCfgVar<BOOL>(used_another_rollback) )
                 {
                   int st_rlb = -1;
                   if ( rlb.GetRollbackStatus(st_rlb) )
                      {
                        if ( st_rlb == CRollback::ST_RLB_ON_ON || st_rlb == CRollback::ST_RLB_ON_ON_SAVE )
                           {
                             rlb.RollbackDeactivate(TRUE);
                             net_obj->SendDynamicInfoToServer();
                           }
                      }
                 }
            }
            
            
            if ( b_reboot_after_finish )
               {
                 DoRebootShutdown(TRUE,b_force_reboot);
               }
          }
       else
          {
            // clean dirs
            for ( int n = 0; n < g_files.size(); n++ )
                {
                  char dir[MAX_PATH];
                  lstrcpy(dir,g_files[n]->GetBaseDir());
                  PathAppend(dir,UPDATE_DIR);
                  if ( IsFileExist(dir) )
                     {
                       CleanDirNoRec(dir);
                       RemoveDirectory(dir);
                     }
                }

            // todo: clean scheduled operation in registry! (in 0.001% cases this needed :)
            //.....
            
            
            // return to ready-state
            g_state = STATE_READY;
            rc = FALSE;
          }

       FreeFiles();
     }

  return rc;
}


