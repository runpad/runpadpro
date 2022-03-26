

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 7.00.0555 */
/* at Fri Jan 22 23:27:02 2010
 */
/* Compiler settings for qedit.idl:
    Oicf, W1, Zp8, env=Win32 (32b run), target_arch=X86 7.00.0555 
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
/* @@MIDL_FILE_HEADING(  ) */

#pragma warning( disable: 4049 )  /* more than 64k source lines */


#ifdef __cplusplus
extern "C"{
#endif 


#include <rpc.h>
#include <rpcndr.h>

#ifdef _MIDL_USE_GUIDDEF_

#ifndef INITGUID
#define INITGUID
#include <guiddef.h>
#undef INITGUID
#else
#include <guiddef.h>
#endif

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        DEFINE_GUID(name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8)

#else // !_MIDL_USE_GUIDDEF_

#ifndef __IID_DEFINED__
#define __IID_DEFINED__

typedef struct _IID
{
    unsigned long x;
    unsigned short s1;
    unsigned short s2;
    unsigned char  c[8];
} IID;

#endif // __IID_DEFINED__

#ifndef CLSID_DEFINED
#define CLSID_DEFINED
typedef IID CLSID;
#endif // CLSID_DEFINED

#define MIDL_DEFINE_GUID(type,name,l,w1,w2,b1,b2,b3,b4,b5,b6,b7,b8) \
        const type name = {l,w1,w2,{b1,b2,b3,b4,b5,b6,b7,b8}}

#endif !_MIDL_USE_GUIDDEF_

MIDL_DEFINE_GUID(IID, IID_ISampleGrabberCB,0x0579154A,0x2B53,0x4994,0xB0,0xD0,0xE7,0x73,0x14,0x8E,0xFF,0x85);


MIDL_DEFINE_GUID(IID, IID_ISampleGrabber,0x6B652FFF,0x11FE,0x4fce,0x92,0xAD,0x02,0x66,0xB5,0xD7,0xC7,0x8F);


MIDL_DEFINE_GUID(IID, LIBID_DexterLib,0x78530B68,0x61F9,0x11D2,0x8C,0xAD,0x00,0xA0,0x24,0x58,0x09,0x02);


MIDL_DEFINE_GUID(CLSID, CLSID_SampleGrabber,0xC1F400A0,0x3F08,0x11d3,0x9F,0x0B,0x00,0x60,0x08,0x03,0x9E,0x37);


MIDL_DEFINE_GUID(CLSID, CLSID_NullRenderer,0xC1F400A4,0x3F08,0x11d3,0x9F,0x0B,0x00,0x60,0x08,0x03,0x9E,0x37);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



