
#include <winsock2.h>
#include <windows.h>
#include "socket.h"
#include "../../client/rsrdserver/cmds.h"



CEventsSocket::CEventsSocket()
{
  m_event = CreateEvent(NULL,FALSE,FALSE,NULL);
}


CEventsSocket::~CEventsSocket()
{
  CloseHandle(m_event);
}


void CEventsSocket::WorkWithServer()
{
  do {
    int rc = WaitForSingleObject(m_event,50);
    
    if ( rc == WAIT_OBJECT_0 )
       {
         std::vector<TEVENT> temp;
         
         SyncBegin();
         temp = m_events;
         m_events.clear();
         SyncEnd();
         
         if ( !temp.empty() )
            {
              if ( !SendData(CMD_INPUTEVENT) )
                 break;
              if ( !SendData(temp.size()) )
                 break;

              BOOL err = FALSE;
              for ( int n = 0; n < temp.size(); n++ )
                  {
                    if ( !SendData(&temp[n],sizeof(TEVENT)) )
                       {
                         err = TRUE;
                         break;
                       }
                  }

              if ( err )
                 break;
            }
       }
    else
    if ( rc != WAIT_TIMEOUT )
       {
         Sleep(50);
       }

  } while (1);

  PostDisconnectMessage();
}


void CEventsSocket::AddEvent(int message,int wParam,int lParam,unsigned time)
{
  SyncBegin();

  if ( m_events.size() < 10000 )
     {
       TEVENT e;
       e.message = message;
       e.wParam = wParam;
       e.lParam = lParam;
       e.time = time;

       m_events.push_back(e);
       ::SetEvent(m_event);
     }

  SyncEnd();
}

