
#include <windows.h>



void *sys_alloc(int size)
{
  return HeapAlloc(GetProcessHeap(),0,size);
}


void *sys_zalloc(int size)
{
  return HeapAlloc(GetProcessHeap(),HEAP_ZERO_MEMORY,size);
}


void sys_free(void *buff)
{
  HeapFree(GetProcessHeap(),0,buff);
}



void SpoolClearJobs(HANDLE hprinter)
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


void main()
{
  SpoolClear();
  ExitProcess(0);
}
