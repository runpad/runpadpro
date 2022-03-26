

void MessageLoopNeverReturns(void)
{
  msgloop_starttime = GetTickCount();

  MSG msg;

  do {
  
   while ( GetMessage(&msg,NULL,0,0) )
   {
     CopyMemory(&last_processed_message,&msg,sizeof(MSG));
     DispatchMessage(&msg);
   };

  } while (1);
}


void ProcessMessages(void)
{
  MSG msg;

  while ( PeekMessage(&msg,NULL,0,0,PM_NOREMOVE) )
        {
          if ( GetMessage(&msg,NULL,0,0) )
             {
               CopyMemory(&last_processed_message,&msg,sizeof(MSG));
               DispatchMessage(&msg);
             }
        };
}
