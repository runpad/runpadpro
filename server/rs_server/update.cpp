
#include "include.h"




CUpdate::CCachedFile::CCachedFile(unsigned _id,const char *_crc32,const char *_path)
{
  u_id = _id;
  s_crc32 = sys_copystring(_crc32);
  s_path = sys_copystring(_path);
  p_buff = NULL;
  u_size = 0;
}


CUpdate::CCachedFile::~CCachedFile()
{
  if ( s_crc32 )
     sys_free(s_crc32);
  if ( s_path )
     sys_free(s_path);
  if ( p_buff )
     sys_free(p_buff);
}


void CUpdate::CCachedFile::LoadData(const void* _buff,unsigned _size)
{
  if ( p_buff )
     sys_free(p_buff);

  p_buff = sys_alloc(_size);  //maybe 0
  u_size = _size;

  if ( _size )
     CopyMemory(p_buff,_buff,_size);
}


CUpdate::CUpdate()
{
  session_id = RandomWord()*RandomWord();  //maybe better 0 ???
}


CUpdate::~CUpdate()
{
  Clear();
}


void CUpdate::Clear()
{
  for ( int n = 0; n < m_files.size(); n++ )
      {
        if ( m_files[n] )
           delete m_files[n];
        m_files[n] = NULL;
      }

  m_files.clear();
}


void CUpdate::Add(const char *_crc32,const char *_path)
{
  CCachedFile *f = new CCachedFile(session_id,_crc32,_path);
  m_files.push_back(f);
  session_id++;
}





