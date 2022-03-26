
#include <winsock2.h>
#include <windows.h>
#include "socket.h"
#include "../../client/rsrdserver/cmds.h"
#include "../../client/rsrdserver/buff7.h"
#include "../../client/rsrdserver/rle7.h"



CScreenSocket::CScreenSocket()
{
  m_screen = NULL;
  m_rlebuff = NULL;
  m_picture_type = CMD_SCREENREQ_RLE7B_GRAY;
  m_fps = 1.5;
}


CScreenSocket::~CScreenSocket()
{
  FreeBuffers();
}


void CScreenSocket::FreeBuffers()
{
  if ( m_screen )
     {
       delete m_screen;
       m_screen = NULL;
     }

  if ( m_rlebuff )
     {
       delete m_rlebuff;
       m_rlebuff = NULL;
     }
}


void CScreenSocket::Disconnect()
{
  CSocket::Disconnect();
  FreeBuffers();
}


void CScreenSocket::ReallocateBuffIfNeeded(CBuff7* &buff,BOOL grayscale,int w,int h)
{
  if ( !buff || !buff->IsScreenMatch(grayscale,w,h) )
     {
       if ( buff )
          delete buff;
       buff = new CBuff7(grayscale,w,h);
     }
}


void CScreenSocket::WorkWithServer()
{
  unsigned last_update_time = GetTickCount();
  unsigned start_work_time = GetTickCount();

  do {
   // read parms
   SyncBegin();
   int picture_type = m_picture_type;
   float fps = m_fps;
   unsigned delta_frame = (unsigned)(1000.0/fps);
   unsigned finish_time = last_update_time + delta_frame;
   last_update_time = GetTickCount();
   SyncEnd();

   //send req to picture
   if ( !SendData(picture_type) )
      break;
   
   int cmd,w,h,size;
   if ( !RecvData(&cmd) ) 
      break;
   if ( !RecvData(&w) ) 
      break;
   if ( !RecvData(&h) ) 
      break;
   if ( !RecvData(&size) ) 
      break;
   if ( cmd != CMD_SCREENREQ_RLE7B_GRAY && cmd != CMD_SCREENREQ_RLE7B_COLOR )
      break;
   BOOL grayscale = (cmd == CMD_SCREENREQ_RLE7B_GRAY);
   if ( w <= 0 || h <= 0 || size < 0 || size > w*h )
      break;

   SyncBegin();
   ReallocateBuffIfNeeded(m_screen,grayscale,w,h);
   ReallocateBuffIfNeeded(m_rlebuff,grayscale,w,h);
   SyncEnd();

   if ( size )
      {
        if ( !RecvData(m_rlebuff->GetBits(),size) )
           break;

        SyncBegin();
        BOOL rc = CRLE7::Decode(m_rlebuff->GetBits(),m_screen->GetBits(),size,w*h);
        SyncEnd();

        if ( !rc )
           break;

        PostMessageToParentThread("_RSRDDataArrived");
      }

   //wait
   unsigned curr_time = GetTickCount();
   if ( curr_time < finish_time )
      Sleep(finish_time - curr_time);

   //license
   //if ( !IsLicenseMatch() )
   //   {
   //     if ( curr_time - start_work_time > 120*1000 )
   //        {
   //          PostMessageToParentThread("_RSRDWorkFinished");
   //          return;
   //        }
   //   }

  } while (1);

  PostDisconnectMessage();
}



void CScreenSocket::UpdateFPS(float fps)
{
  SyncBegin();

  if ( fps <= 0 )
     fps = 0.1;
  if ( fps > 50 )
     fps = 50;

  m_fps = fps;

  SyncEnd();
}


void CScreenSocket::UpdatePictureType(int type)
{
  SyncBegin();

  if ( type == CMD_SCREENREQ_RLE7B_GRAY || type == CMD_SCREENREQ_RLE7B_COLOR )
     m_picture_type = type;

  SyncEnd();
}


HDC CScreenSocket::Lock(int *_w,int *_h)
{
  SyncBegin();

  HDC hdc = m_screen ? m_screen->GetHDC() : NULL;
  *_w = m_screen ? m_screen->GetWidth() : 0;
  *_h = m_screen ? m_screen->GetHeight() : 0;

  return hdc;
}


void CScreenSocket::Unlock()
{
  SyncEnd();
}

