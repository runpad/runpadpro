

/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0361 */
/* at Wed Oct 29 21:31:36 2008
 */
/* Compiler settings for rs_api.idl:
    Oicf, W1, Zp8, env=Win32 (32b run)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#if !defined(_M_IA64) && !defined(_M_AMD64)


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

MIDL_DEFINE_GUID(IID, IID_IRunpadShell,0x0CBC0D60,0x02DB,0x434d,0x99,0xC0,0x00,0x37,0x02,0xC6,0x59,0x34);


MIDL_DEFINE_GUID(IID, IID_IRunpadShell2,0x548856D7,0x555A,0x445B,0xBD,0xEB,0xEE,0xE4,0x91,0xA1,0x4C,0x39);


MIDL_DEFINE_GUID(IID, LIBID_RS_APILib,0x02988454,0xDBAC,0x48b9,0xA8,0xA2,0x85,0xAE,0xE4,0xE2,0x48,0x6F);


MIDL_DEFINE_GUID(CLSID, CLSID_RunpadShell,0xD7346301,0xB73F,0x4a94,0xAB,0xE6,0x23,0x4A,0x0D,0x49,0x52,0x1D);


MIDL_DEFINE_GUID(CLSID, CLSID_RunpadShell2,0xD163EEE3,0x540A,0x48DA,0x90,0x09,0xC1,0x94,0x58,0x82,0x63,0xB9);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



#endif /* !defined(_M_IA64) && !defined(_M_AMD64)*/



/* this ALWAYS GENERATED file contains the IIDs and CLSIDs */

/* link this file in with the server and any clients */


 /* File created by MIDL compiler version 6.00.0361 */
/* at Wed Oct 29 21:31:36 2008
 */
/* Compiler settings for rs_api.idl:
    Oicf, W1, Zp8, env=Win64 (32b run,appending)
    protocol : dce , ms_ext, c_ext, robust
    error checks: allocation ref bounds_check enum stub_data 
    VC __declspec() decoration level: 
         __declspec(uuid()), __declspec(selectany), __declspec(novtable)
         DECLSPEC_UUID(), MIDL_INTERFACE()
*/
//@@MIDL_FILE_HEADING(  )

#if defined(_M_IA64) || defined(_M_AMD64)


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

MIDL_DEFINE_GUID(IID, IID_IRunpadShell,0x0CBC0D60,0x02DB,0x434d,0x99,0xC0,0x00,0x37,0x02,0xC6,0x59,0x34);


MIDL_DEFINE_GUID(IID, IID_IRunpadShell2,0x548856D7,0x555A,0x445B,0xBD,0xEB,0xEE,0xE4,0x91,0xA1,0x4C,0x39);


MIDL_DEFINE_GUID(IID, LIBID_RS_APILib,0x02988454,0xDBAC,0x48b9,0xA8,0xA2,0x85,0xAE,0xE4,0xE2,0x48,0x6F);


MIDL_DEFINE_GUID(CLSID, CLSID_RunpadShell,0xD7346301,0xB73F,0x4a94,0xAB,0xE6,0x23,0x4A,0x0D,0x49,0x52,0x1D);


MIDL_DEFINE_GUID(CLSID, CLSID_RunpadShell2,0xD163EEE3,0x540A,0x48DA,0x90,0x09,0xC1,0x94,0x58,0x82,0x63,0xB9);

#undef MIDL_DEFINE_GUID

#ifdef __cplusplus
}
#endif



#endif /* defined(_M_IA64) || defined(_M_AMD64)*/

