
#include <winsock2.h>
#include <windows.h>
#include "socket.h"
#include "../../client/rsrdserver/global.h"


CEventsSocket *g_sock_events = NULL;
CScreenSocket *g_sock_screen = NULL;


extern "C" __declspec(dllexport) void __cdecl RA_Init(void)
{
  WSADATA winsockdata;
  WSAStartup(MAKEWORD(2,2),&winsockdata);

  g_sock_events = new CEventsSocket();
  g_sock_screen = new CScreenSocket();
}


extern "C" __declspec(dllexport) void __cdecl RA_Done(void)
{
  if ( g_sock_events )
     delete g_sock_events;
  g_sock_events = NULL;
  
  if ( g_sock_screen )
     delete g_sock_screen;
  g_sock_screen = NULL;
  
  WSACleanup();
}


extern "C" __declspec(dllexport) BOOL __cdecl RA_Connect(char *server)
{
  BOOL rc = FALSE;

  if ( g_sock_events->Connect(server,PORT_EVENTS) &&
       g_sock_screen->Connect(server,PORT_SCREEN) )
     {
       rc = TRUE;
     }
  else
     {
       if ( g_sock_events->IsConnected() )
          g_sock_events->Disconnect();
       if ( g_sock_screen->IsConnected() )
          g_sock_screen->Disconnect();
     }

  return rc;
}


extern "C" __declspec(dllexport) void __cdecl RA_Disconnect(void)
{
  if ( g_sock_events->IsConnected() )
     g_sock_events->Disconnect();
  if ( g_sock_screen->IsConnected() )
     g_sock_screen->Disconnect();
}


extern "C" __declspec(dllexport) void __cdecl RA_UpdatePictureType(int picture_type)
{
  g_sock_screen->UpdatePictureType(picture_type);
}


extern "C" __declspec(dllexport) void __cdecl RA_UpdateFPS(float fps)
{
  g_sock_screen->UpdateFPS(fps);
}


extern "C" __declspec(dllexport) HDC __cdecl RA_Lock(int *_w,int *_h)
{
  return g_sock_screen->Lock(_w,_h);
}


extern "C" __declspec(dllexport) void __cdecl RA_Unlock(void)
{
  g_sock_screen->Unlock();
}


extern "C" __declspec(dllexport) void __cdecl RA_InputEvent(int message,int wParam,int lParam,unsigned time)
{
  g_sock_events->AddEvent(message,wParam,lParam,time);
}


