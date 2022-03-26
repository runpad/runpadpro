
#include "zlib.h"
#include "sys.h"
#include <string.h>

#define Z_INTERNAL
#include "z.h"



Z_EXPORT void* __cdecl Z_Compress(const void* src,unsigned src_size,unsigned *_dest_size)
{
  uLongf t_size;
  void *t_buff;
  
  if ( _dest_size )
     *_dest_size = 0;
  
  if ( !src || !src_size )
     return NULL;

  t_size = src_size + src_size/16 + 13;
  t_buff = z_sys_alloc(4 + t_size);

  if ( !t_buff )
     return NULL;

  if ( compress((Bytef*)t_buff+4,&t_size,(const Bytef*)src,src_size) != Z_OK )
     {
       memcpy((char*)t_buff+4,src,src_size);
       *(unsigned*)t_buff = 0; //raw format
       t_size = src_size + 4;
     }
  else
     {
       *(unsigned*)t_buff = src_size;  //compressed format
       t_size += 4;
     }

  if ( _dest_size )
     *_dest_size = t_size;

  return t_buff;
}



Z_EXPORT void* __cdecl Z_Decompress(const void* src,unsigned src_size,unsigned *_dest_size)
{
  if ( _dest_size )
     *_dest_size = 0;
  
  if ( !src || src_size <= 4 )
     return NULL;

  if ( *(unsigned*)src == 0 ) //raw format?
     {
       unsigned t_size = src_size-4;
       void *t_buff = z_sys_alloc(t_size);
       if ( !t_buff )
          return NULL;

       memcpy(t_buff,(char*)src+4,t_size);

       if ( _dest_size )
          *_dest_size = t_size;

       return t_buff;
     }
  else
     {
       uLongf t_size = *(unsigned*)src;
       void *t_buff = z_sys_alloc(t_size);
       if ( !t_buff )
          return NULL;

       if ( uncompress((Bytef*)t_buff,&t_size,(const Bytef*)src+4,src_size-4) != Z_OK ||
            t_size != *(unsigned*)src )
          {
            z_sys_free(t_buff);
            return NULL;
          }

       if ( _dest_size )
          *_dest_size = t_size;

       return t_buff;
     }
}



Z_EXPORT void __cdecl Z_Free(void* buff)
{
  if ( buff )
     z_sys_free(buff);
}



Z_EXPORT unsigned __cdecl Z_CRC32(const void* buff,unsigned size)
{
  unsigned crc = crc32(0,NULL,0);

  if ( buff && size )
     {
       crc = crc32(crc,(const Bytef*)buff,size);
     }

  return crc;
}


