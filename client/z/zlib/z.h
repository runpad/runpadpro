
#ifndef __Z_H__
#define __Z_H__

#ifdef __cplusplus
extern "C" {
#endif


#ifdef Z_INTERNAL
 #ifdef Z_DLL
  #define Z_EXPORT __declspec(dllexport)
 #else
  #define Z_EXPORT 
 #endif
#else
 #ifdef Z_DLL
  #define Z_EXPORT __declspec(dllimport)
 #else
  #define Z_EXPORT extern
 #endif
#endif


Z_EXPORT void* __cdecl Z_Compress(const void* src,unsigned src_size,unsigned *_dest_size);
Z_EXPORT void* __cdecl Z_Decompress(const void* src,unsigned src_size,unsigned *_dest_size);
Z_EXPORT void __cdecl Z_Free(void* buff);
Z_EXPORT unsigned __cdecl Z_CRC32(const void* buff,unsigned size);


#ifdef __cplusplus
}
#endif


#endif //__Z_H__
