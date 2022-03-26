

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


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


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 475
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __qedit_h__
#define __qedit_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __ISampleGrabberCB_FWD_DEFINED__
#define __ISampleGrabberCB_FWD_DEFINED__
typedef interface ISampleGrabberCB ISampleGrabberCB;
#endif 	/* __ISampleGrabberCB_FWD_DEFINED__ */


#ifndef __ISampleGrabber_FWD_DEFINED__
#define __ISampleGrabber_FWD_DEFINED__
typedef interface ISampleGrabber ISampleGrabber;
#endif 	/* __ISampleGrabber_FWD_DEFINED__ */


#ifndef __SampleGrabber_FWD_DEFINED__
#define __SampleGrabber_FWD_DEFINED__

#ifdef __cplusplus
typedef class SampleGrabber SampleGrabber;
#else
typedef struct SampleGrabber SampleGrabber;
#endif /* __cplusplus */

#endif 	/* __SampleGrabber_FWD_DEFINED__ */


#ifndef __NullRenderer_FWD_DEFINED__
#define __NullRenderer_FWD_DEFINED__

#ifdef __cplusplus
typedef class NullRenderer NullRenderer;
#else
typedef struct NullRenderer NullRenderer;
#endif /* __cplusplus */

#endif 	/* __NullRenderer_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"
#include "amstream.h"

#ifdef __cplusplus
extern "C"{
#endif 


/* interface __MIDL_itf_qedit_0000_0000 */
/* [local] */ 




extern RPC_IF_HANDLE __MIDL_itf_qedit_0000_0000_v0_0_c_ifspec;
extern RPC_IF_HANDLE __MIDL_itf_qedit_0000_0000_v0_0_s_ifspec;

#ifndef __ISampleGrabberCB_INTERFACE_DEFINED__
#define __ISampleGrabberCB_INTERFACE_DEFINED__

/* interface ISampleGrabberCB */
/* [unique][helpstring][local][uuid][object] */ 


EXTERN_C const IID IID_ISampleGrabberCB;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("0579154A-2B53-4994-B0D0-E773148EFF85")
    ISampleGrabberCB : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE SampleCB( 
            double SampleTime,
            IMediaSample *pSample) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE BufferCB( 
            double SampleTime,
            BYTE *pBuffer,
            long BufferLen) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ISampleGrabberCBVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ISampleGrabberCB * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ISampleGrabberCB * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ISampleGrabberCB * This);
        
        HRESULT ( STDMETHODCALLTYPE *SampleCB )( 
            ISampleGrabberCB * This,
            double SampleTime,
            IMediaSample *pSample);
        
        HRESULT ( STDMETHODCALLTYPE *BufferCB )( 
            ISampleGrabberCB * This,
            double SampleTime,
            BYTE *pBuffer,
            long BufferLen);
        
        END_INTERFACE
    } ISampleGrabberCBVtbl;

    interface ISampleGrabberCB
    {
        CONST_VTBL struct ISampleGrabberCBVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ISampleGrabberCB_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISampleGrabberCB_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ISampleGrabberCB_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ISampleGrabberCB_SampleCB(This,SampleTime,pSample)	\
    ( (This)->lpVtbl -> SampleCB(This,SampleTime,pSample) ) 

#define ISampleGrabberCB_BufferCB(This,SampleTime,pBuffer,BufferLen)	\
    ( (This)->lpVtbl -> BufferCB(This,SampleTime,pBuffer,BufferLen) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ISampleGrabberCB_INTERFACE_DEFINED__ */


#ifndef __ISampleGrabber_INTERFACE_DEFINED__
#define __ISampleGrabber_INTERFACE_DEFINED__

/* interface ISampleGrabber */
/* [unique][helpstring][local][uuid][object] */ 


EXTERN_C const IID IID_ISampleGrabber;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("6B652FFF-11FE-4fce-92AD-0266B5D7C78F")
    ISampleGrabber : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE SetOneShot( 
            BOOL OneShot) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetMediaType( 
            const AM_MEDIA_TYPE *pType) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetConnectedMediaType( 
            AM_MEDIA_TYPE *pType) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetBufferSamples( 
            BOOL BufferThem) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentBuffer( 
            /* [out][in] */ long *pBufferSize,
            /* [out] */ long *pBuffer) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentSample( 
            /* [retval][out] */ IMediaSample **ppSample) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE SetCallback( 
            ISampleGrabberCB *pCallback,
            long WhichMethodToCallback) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ISampleGrabberVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            ISampleGrabber * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            ISampleGrabber * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            ISampleGrabber * This);
        
        HRESULT ( STDMETHODCALLTYPE *SetOneShot )( 
            ISampleGrabber * This,
            BOOL OneShot);
        
        HRESULT ( STDMETHODCALLTYPE *SetMediaType )( 
            ISampleGrabber * This,
            const AM_MEDIA_TYPE *pType);
        
        HRESULT ( STDMETHODCALLTYPE *GetConnectedMediaType )( 
            ISampleGrabber * This,
            AM_MEDIA_TYPE *pType);
        
        HRESULT ( STDMETHODCALLTYPE *SetBufferSamples )( 
            ISampleGrabber * This,
            BOOL BufferThem);
        
        HRESULT ( STDMETHODCALLTYPE *GetCurrentBuffer )( 
            ISampleGrabber * This,
            /* [out][in] */ long *pBufferSize,
            /* [out] */ long *pBuffer);
        
        HRESULT ( STDMETHODCALLTYPE *GetCurrentSample )( 
            ISampleGrabber * This,
            /* [retval][out] */ IMediaSample **ppSample);
        
        HRESULT ( STDMETHODCALLTYPE *SetCallback )( 
            ISampleGrabber * This,
            ISampleGrabberCB *pCallback,
            long WhichMethodToCallback);
        
        END_INTERFACE
    } ISampleGrabberVtbl;

    interface ISampleGrabber
    {
        CONST_VTBL struct ISampleGrabberVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ISampleGrabber_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define ISampleGrabber_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define ISampleGrabber_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define ISampleGrabber_SetOneShot(This,OneShot)	\
    ( (This)->lpVtbl -> SetOneShot(This,OneShot) ) 

#define ISampleGrabber_SetMediaType(This,pType)	\
    ( (This)->lpVtbl -> SetMediaType(This,pType) ) 

#define ISampleGrabber_GetConnectedMediaType(This,pType)	\
    ( (This)->lpVtbl -> GetConnectedMediaType(This,pType) ) 

#define ISampleGrabber_SetBufferSamples(This,BufferThem)	\
    ( (This)->lpVtbl -> SetBufferSamples(This,BufferThem) ) 

#define ISampleGrabber_GetCurrentBuffer(This,pBufferSize,pBuffer)	\
    ( (This)->lpVtbl -> GetCurrentBuffer(This,pBufferSize,pBuffer) ) 

#define ISampleGrabber_GetCurrentSample(This,ppSample)	\
    ( (This)->lpVtbl -> GetCurrentSample(This,ppSample) ) 

#define ISampleGrabber_SetCallback(This,pCallback,WhichMethodToCallback)	\
    ( (This)->lpVtbl -> SetCallback(This,pCallback,WhichMethodToCallback) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __ISampleGrabber_INTERFACE_DEFINED__ */



#ifndef __DexterLib_LIBRARY_DEFINED__
#define __DexterLib_LIBRARY_DEFINED__

/* library DexterLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_DexterLib;

EXTERN_C const CLSID CLSID_SampleGrabber;

#ifdef __cplusplus

class DECLSPEC_UUID("C1F400A0-3F08-11d3-9F0B-006008039E37")
SampleGrabber;
#endif

EXTERN_C const CLSID CLSID_NullRenderer;

#ifdef __cplusplus

class DECLSPEC_UUID("C1F400A4-3F08-11d3-9F0B-006008039E37")
NullRenderer;
#endif
#endif /* __DexterLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


