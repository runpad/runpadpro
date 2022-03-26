

static HANDLE h_printerthread = NULL;
static HANDLE ev_printerthreadstop = NULL;



enum {
 PRINTCOL_PRINTER_NAME,
 PRINTCOL_MACHINE_NAME,
 PRINTCOL_USER_NAME,
 PRINTCOL_DOC_NAME,
 PRINTCOL_TOTAL_PAGES,
 PRINTCOL_PRINT_PAGES,
 PRINTCOL_TOTAL_BYTES,
 PRINTCOL_PRINT_BYTES,
};

#define MAXPRINTCOL 25  //jobs in queue

typedef struct {
BOOL done;
int id;
char printer_name[MAX_PATH];
char machine_name[MAX_PATH];
char user_name[MAX_PATH];
char doc_name[MAX_PATH];
int total_pages;
int print_pages;
int total_bytes;
int print_bytes;
} PRINTCOL;

static PRINTCOL printcol[MAXPRINTCOL];
static int printcol_slider;


static void ClearPrintCol(void)
{
  printcol_slider = 0;

  for ( int n = 0; n < MAXPRINTCOL; n++ )
      {
        PRINTCOL *p = &printcol[n];

        ZeroMemory(p,sizeof(*p));
        p->done = TRUE;
        p->id = -1;
      }
}


static void Add2PrintCollection(int id,int field,const void *pdata,int idata)
{
  if ( id != -1 )
     {
       PRINTCOL *work = NULL;

       for ( int n = 0; n < MAXPRINTCOL; n++ )
           {
             if ( printcol[n].id == id )
                {
                  if ( printcol[n].done )
                     return;

                  work = &printcol[n];
                  break;
                }
           }

       if ( !work )
          {
            int count = 0;

            do {

             PRINTCOL *p = &printcol[printcol_slider];

             printcol_slider++;
             if ( printcol_slider == MAXPRINTCOL )
                printcol_slider = 0;

             if ( p->done )
                {
                  work = p;
                  ZeroMemory(work,sizeof(*work));
                  work->done = FALSE;
                  work->id = id;
                  break;
                }

             count++;

            } while ( count < MAXPRINTCOL );
          }

       if ( !work )
          return;

       switch ( field )
       {
         case PRINTCOL_PRINTER_NAME:
                                     if ( pdata )
                                        lstrcpyn(work->printer_name,(LPCSTR)pdata,sizeof(work->printer_name)-1);
                                     break;
         case PRINTCOL_MACHINE_NAME:
                                     if ( pdata )
                                        lstrcpyn(work->machine_name,(LPCSTR)pdata,sizeof(work->machine_name)-1);
                                     break;
         case PRINTCOL_USER_NAME:
                                     if ( pdata )
                                        lstrcpyn(work->user_name,(LPCSTR)pdata,sizeof(work->user_name)-1);
                                     break;
         case PRINTCOL_DOC_NAME:
                                     if ( pdata )
                                        lstrcpyn(work->doc_name,(LPCSTR)pdata,sizeof(work->doc_name)-1);
                                     break;
         case PRINTCOL_TOTAL_PAGES:
                                     work->total_pages = idata;
                                     break;
         case PRINTCOL_PRINT_PAGES:
                                     work->print_pages = idata;
                                     break;
         case PRINTCOL_TOTAL_BYTES:
                                     work->total_bytes = idata;
                                     break;
         case PRINTCOL_PRINT_BYTES:
                                     work->print_bytes = idata;
                                     break;
       };

       if ( work->print_pages > 0 && work->print_pages >= work->total_pages )
          {
            work->done = TRUE;

            if ( GetMainWnd() )
               {
                 char s_printer[50];
                 char s_doc[50];
                 char s_user[17];
                 char s_machine[17];

                 lstrcpyn(s_printer,work->printer_name,sizeof(s_printer)-1);
                 lstrcpyn(s_doc,work->doc_name,sizeof(s_doc)-1);
                 lstrcpyn(s_user,work->user_name,sizeof(s_user)-1);
                 lstrcpyn(s_machine,work->machine_name,sizeof(s_machine)-1);

                 char s[MAX_PATH];
                 wsprintf(s,"%s, %s/%s, %d %s, %d KB, %s",s_printer,s_machine,s_user,work->total_pages,STR_008,work->total_bytes/1024,s_doc);

                 ATOM atom = GlobalAddAtom(s);
                 int l = (work->total_pages << 20) + ((work->total_bytes/1024) & 0xFFFFF);
                 
                 PostMessage(GetMainWnd(),RS_PRINTERJOBADD,atom,l);
               }
          }
     }
}


// returns error status
static BOOL ProcessSinglePrintNotify(HANDLE h,PRINTER_NOTIFY_OPTIONS& pn)
{
  BOOL exit_code = TRUE; // no error

  int wc = WaitForSingleObject(h,0);

  if ( wc == WAIT_FAILED )
     return FALSE;
  
  if ( wc == WAIT_OBJECT_0 )
     {
       DWORD ch = 0;
       PRINTER_NOTIFY_INFO *pni = NULL;
       
       pn.Flags = 0;//PRINTER_NOTIFY_OPTIONS_REFRESH; будет работать и с этой опцией
       BOOL rc = FindNextPrinterChangeNotification(h,&ch,&pn,(void**)&pni);

       if ( pni && (pni->Flags & PRINTER_NOTIFY_INFO_DISCARDED) )
          {
            FreePrinterNotifyInfo(pni);
            pni = NULL;
            ch = 0;

            pn.Flags = PRINTER_NOTIFY_OPTIONS_REFRESH;
            rc = FindNextPrinterChangeNotification(h,&ch,&pn,(void**)&pni);
            pn.Flags = 0;
          }

       if ( pni )
          {
            for ( int n = 0; n < pni->Count; n++ )
                {
                  if ( pni->aData[n].Type == JOB_NOTIFY_TYPE )
                     {
                       int id = pni->aData[n].Id;
                       
                       switch ( pni->aData[n].Field )
                       {
                         case JOB_NOTIFY_FIELD_PRINTER_NAME:
                                  Add2PrintCollection(id,PRINTCOL_PRINTER_NAME,pni->aData[n].NotifyData.Data.pBuf,0);
                                  break;
                         case JOB_NOTIFY_FIELD_MACHINE_NAME:
                                  Add2PrintCollection(id,PRINTCOL_MACHINE_NAME,pni->aData[n].NotifyData.Data.pBuf,0);
                                  break;
                         case JOB_NOTIFY_FIELD_USER_NAME:
                                  Add2PrintCollection(id,PRINTCOL_USER_NAME,pni->aData[n].NotifyData.Data.pBuf,0);
                                  break;
                         case JOB_NOTIFY_FIELD_DOCUMENT:
                                  Add2PrintCollection(id,PRINTCOL_DOC_NAME,pni->aData[n].NotifyData.Data.pBuf,0);
                                  break;
                         case JOB_NOTIFY_FIELD_TOTAL_PAGES:
                                  Add2PrintCollection(id,PRINTCOL_TOTAL_PAGES,NULL,pni->aData[n].NotifyData.adwData[0]);
                                  break;
                         case JOB_NOTIFY_FIELD_PAGES_PRINTED:
                                  Add2PrintCollection(id,PRINTCOL_PRINT_PAGES,NULL,pni->aData[n].NotifyData.adwData[0]);
                                  break;
                         case JOB_NOTIFY_FIELD_TOTAL_BYTES:
                                  Add2PrintCollection(id,PRINTCOL_TOTAL_BYTES,NULL,pni->aData[n].NotifyData.adwData[0]);
                                  break;
                         case JOB_NOTIFY_FIELD_BYTES_PRINTED:
                                  Add2PrintCollection(id,PRINTCOL_PRINT_BYTES,NULL,pni->aData[n].NotifyData.adwData[0]);
                                  break;
                       };
                     }
                }

            FreePrinterNotifyInfo(pni);
          }

       exit_code = rc;
     }

  return exit_code;
}



static DWORD WINAPI PrinterThreadProc(LPVOID lpParameter)
{
  typedef std::vector<HANDLE> THANDLES;


  // initialization
  ClearPrintCol();

  
  // create list of printers handles
  THANDLES h_printers;
  
  {
    DWORD dwNeeded = 0;
    DWORD dwReturned = 0;
    
    Sleep(2000);  // ensure spooler is loaded, todo: better way
    
    EnumPrinters(PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL,NULL,4,NULL,0,&dwNeeded,&dwReturned);

    if ( dwNeeded )
       {
         PRINTER_INFO_4 *printers = (PRINTER_INFO_4*)sys_zalloc(dwNeeded); //zero clears

         if ( EnumPrinters(PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL,NULL,4,(LPBYTE)printers,dwNeeded,&dwNeeded,&dwReturned) )
            {
              for ( DWORD i = 0; i < dwReturned; i++ )
                  {
                    if ( !IsStrEmpty(printers[i].pPrinterName) )
                       {
                         HANDLE ph = NULL;
                         
                         if ( OpenPrinter(printers[i].pPrinterName,&ph,NULL) && ph )
                            {
                              h_printers.push_back(ph);
                            }
                         else
                            {
                              if ( ph )
                                 {
                                   ClosePrinter(ph);
                                 }
                            }
                       }
                  }
            }

         sys_free(printers);
       }
  }


  // prepare notification structure
  WORD pnf[] = { 
    PRINTER_NOTIFY_FIELD_SERVER_NAME,
    PRINTER_NOTIFY_FIELD_PRINTER_NAME,
    PRINTER_NOTIFY_FIELD_SHARE_NAME,
    PRINTER_NOTIFY_FIELD_PORT_NAME,
    PRINTER_NOTIFY_FIELD_DRIVER_NAME,
    PRINTER_NOTIFY_FIELD_COMMENT,
    PRINTER_NOTIFY_FIELD_LOCATION,
    PRINTER_NOTIFY_FIELD_SEPFILE,
    PRINTER_NOTIFY_FIELD_DEVMODE,
    PRINTER_NOTIFY_FIELD_PRINT_PROCESSOR,
    PRINTER_NOTIFY_FIELD_PARAMETERS,
    PRINTER_NOTIFY_FIELD_DATATYPE,
    PRINTER_NOTIFY_FIELD_ATTRIBUTES,
    PRINTER_NOTIFY_FIELD_PRIORITY,
    PRINTER_NOTIFY_FIELD_DEFAULT_PRIORITY,
    PRINTER_NOTIFY_FIELD_START_TIME,
    PRINTER_NOTIFY_FIELD_UNTIL_TIME,
    PRINTER_NOTIFY_FIELD_STATUS_STRING,
    PRINTER_NOTIFY_FIELD_CJOBS,
    PRINTER_NOTIFY_FIELD_AVERAGE_PPM,
    PRINTER_NOTIFY_FIELD_TOTAL_PAGES,
    PRINTER_NOTIFY_FIELD_PAGES_PRINTED,
    PRINTER_NOTIFY_FIELD_TOTAL_BYTES,
    PRINTER_NOTIFY_FIELD_BYTES_PRINTED,
   };
  WORD jnf[] = {  
    JOB_NOTIFY_FIELD_PRINTER_NAME,
    JOB_NOTIFY_FIELD_MACHINE_NAME,
    JOB_NOTIFY_FIELD_PORT_NAME,
    JOB_NOTIFY_FIELD_USER_NAME,
    JOB_NOTIFY_FIELD_NOTIFY_NAME,
    JOB_NOTIFY_FIELD_DATATYPE,
    JOB_NOTIFY_FIELD_PRINT_PROCESSOR,
    JOB_NOTIFY_FIELD_PARAMETERS,
    JOB_NOTIFY_FIELD_DRIVER_NAME,
    JOB_NOTIFY_FIELD_STATUS,
    JOB_NOTIFY_FIELD_STATUS_STRING,
    JOB_NOTIFY_FIELD_DOCUMENT,
    JOB_NOTIFY_FIELD_DEVMODE,
    JOB_NOTIFY_FIELD_PRIORITY,
    JOB_NOTIFY_FIELD_START_TIME,
    JOB_NOTIFY_FIELD_UNTIL_TIME,
    JOB_NOTIFY_FIELD_TIME,
    JOB_NOTIFY_FIELD_TOTAL_PAGES,
    JOB_NOTIFY_FIELD_PAGES_PRINTED,
    JOB_NOTIFY_FIELD_TOTAL_BYTES,
    JOB_NOTIFY_FIELD_BYTES_PRINTED,
    JOB_NOTIFY_FIELD_POSITION,
  };
  PRINTER_NOTIFY_OPTIONS_TYPE pnt[2];
  PRINTER_NOTIFY_OPTIONS pn;

  pnt[0].Type = PRINTER_NOTIFY_TYPE;
  pnt[0].Count = sizeof(pnf)/sizeof(pnf[0]);
  pnt[0].pFields = pnf;

  pnt[1].Type = JOB_NOTIFY_TYPE;
  pnt[1].Count = sizeof(jnf)/sizeof(jnf[0]);
  pnt[1].pFields = jnf;

  pn.Version = 2;
  pn.Flags = 0;
  pn.Count = sizeof(pnt)/sizeof(pnt[0]);
  pn.pTypes = pnt;

  
  // create list of notification handlers
  THANDLES h_notifiers;

  for ( int n = 0; n < h_printers.size(); n++ )
      {
        HANDLE h = FindFirstPrinterChangeNotification(h_printers[n],PRINTER_CHANGE_ALL,0,&pn);
        if ( h != INVALID_HANDLE_VALUE )
           {
             h_notifiers.push_back(h);
           }
      }


  // main monitoring loop
  while ( 1 )
  {
    if ( h_notifiers.size() == 0 )
       break;

    int wc = WaitForSingleObject(ev_printerthreadstop,500);

    if ( wc == WAIT_OBJECT_0 || wc == WAIT_FAILED )
       break;

    for ( THANDLES::iterator it = h_notifiers.begin(); it != h_notifiers.end(); ++it )
        {
          if ( !ProcessSinglePrintNotify((*it),pn) )
             {
               FindClosePrinterChangeNotification((*it));
               h_notifiers.erase(it);
               break;
             }
        }
  }
  
  
  // destroy list of notification handlers
  for ( int n = 0; n < h_notifiers.size(); n++ )
      {
        FindClosePrinterChangeNotification(h_notifiers[n]);
        h_notifiers[n] = NULL;
      }

  h_notifiers.clear();


  // destroy list of handles
  for ( int i = 0; i < h_printers.size(); i++ )
      {
        ClosePrinter(h_printers[i]);
        h_printers[i] = NULL;
      }

  h_printers.clear();

  
  return 1;
}



void InitPrinterThread(void)
{
  if ( allow_printer_control )
     {
       if ( !h_printerthread )
          {
            ev_printerthreadstop = CreateEvent(NULL,FALSE,FALSE,NULL);
            h_printerthread = MyCreateThreadSelectedCPU(PrinterThreadProc);
          }
     }
}



void DonePrinterThread(void)
{
  if ( h_printerthread )
     {
       SetEvent(ev_printerthreadstop);
       if ( WaitForSingleObject(h_printerthread,1000) == WAIT_TIMEOUT )
          TerminateThread(h_printerthread,0);
       CloseHandle(h_printerthread);
       h_printerthread = NULL;
       CloseHandle(ev_printerthreadstop);
       ev_printerthreadstop = NULL;
     }
}



static void SpoolClearJobs(HANDLE hprinter)
{
  const int MAX_JOBS_COUNT = 1000;

  DWORD dwNeeded = 0;
  DWORD dwReturned = 0;
  
  EnumJobs(hprinter,0,MAX_JOBS_COUNT,1,NULL,0,&dwNeeded,&dwReturned);

  if ( dwNeeded )
     {
       JOB_INFO_1 *jobs = (JOB_INFO_1*)sys_zalloc(dwNeeded); //zero clears

       if ( EnumJobs(hprinter,0,MAX_JOBS_COUNT,1,(LPBYTE)jobs,dwNeeded,&dwNeeded,&dwReturned) )
          {
            DWORD i;
            for ( i = 0; i < dwReturned; i++ )
                {
                  if ( SetJob(hprinter,jobs[i].JobId,0,NULL,JOB_CONTROL_DELETE) )
                     {
                     }
                }
          }

       sys_free(jobs);
     }
}


void SpoolClear(void)
{
  DWORD dwNeeded = 0;
  DWORD dwReturned = 0;
  
  EnumPrinters(PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL,NULL,4,NULL,0,&dwNeeded,&dwReturned);

  if ( dwNeeded )
     {
       PRINTER_INFO_4 *printers = (PRINTER_INFO_4*)sys_zalloc(dwNeeded); //zero clears

       if ( EnumPrinters(PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL,NULL,4,(LPBYTE)printers,dwNeeded,&dwNeeded,&dwReturned) )
          {
            DWORD i;
            for ( i = 0; i < dwReturned; i++ )
                {
                  if ( !(printers[i].Attributes & PRINTER_ATTRIBUTE_NETWORK) )
                     {
                       HANDLE h = NULL;
                       
                       if ( OpenPrinter(printers[i].pPrinterName,&h,NULL) )
                          {
                            SpoolClearJobs(h);
                            ClosePrinter(h);
                          }
                     }
                }
          }

       sys_free(printers);
     }
}

