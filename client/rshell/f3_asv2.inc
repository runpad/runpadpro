
static BOOL asv2_tool_find = FALSE;



static int CheckRegEntry(const char *value,const char *data,void *param)
{
  int rc = 0;
  
  if ( !IsStrEmpty(value) && !IsStrEmpty(data) )
     {
       if ( !lstrcmpi(value,"rshell_asv2") || !lstrcmpi(value,"rshell_asv2.exe") )
          {
            ExecTool(data);
            asv2_tool_find = TRUE;
            rc++;
          }
     }

  return rc;
}


void ASV2_ExecToolIfPresent()
{
  EnumerateRegistryValues(HKCU,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",CheckRegEntry,NULL);
  EnumerateRegistryValues(HKLM,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",CheckRegEntry,NULL);

  for ( int n = 0; n < autorun_items.size(); n++ )
      {
        const CCfgEntry2 *i = &autorun_items[n];

        if ( i->IsActive() )
           {
             const char *s = i->GetParm2();
             
             // we do not use any expands here!
             if ( StrStrI(s,"\\rshell_asv2.exe") )
                {
                  ExecTool(s);
                  asv2_tool_find = TRUE;
                }
           }
      }
}


void ASV2_WaitForData()
{
  if ( asv2_tool_find )
     {
       AboutBoxUpdateProgress(LS(3235)); //waiting for asta2...

       HANDLE h = NULL;
       unsigned starttime = GetTickCount();
       
       do {
         h = OpenEvent(SYNCHRONIZE,FALSE,"rshell_asv2_Event_RecvData");
         if ( h )
            break;

         Sleep(50);

       } while ( GetTickCount() - starttime < 3000 );

       if ( h )
          {
            WaitForSingleObject(h,7000);
            CloseHandle(h);
          }

       AboutBoxUpdateProgress("");
     }
}


void ASV2_ForceUpdate()
{
  HWND w = FindWindow("_rshell_asv2_WndClass",NULL);
  if ( w )
     {
       CWaitCursor oCursor;
       
       DWORD_PTR rc = 0;
       SendMessageTimeout(w,WM_USER+102,0,0,SMTO_ABORTIFHUNG|SMTO_BLOCK,3000,&rc);
     }
}


