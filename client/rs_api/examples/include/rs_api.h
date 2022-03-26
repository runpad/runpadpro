

/* this ALWAYS GENERATED file contains the definitions for the interfaces */


 /* File created by MIDL compiler version 7.00.0555 */
/* at Sat Nov 21 15:41:24 2020
 */
/* Compiler settings for rs_api.idl:
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

#ifndef __rs_api_h__
#define __rs_api_h__

#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

/* Forward Declarations */ 

#ifndef __IRunpadShell_FWD_DEFINED__
#define __IRunpadShell_FWD_DEFINED__
typedef interface IRunpadShell IRunpadShell;
#endif 	/* __IRunpadShell_FWD_DEFINED__ */


#ifndef __IRunpadShell2_FWD_DEFINED__
#define __IRunpadShell2_FWD_DEFINED__
typedef interface IRunpadShell2 IRunpadShell2;
#endif 	/* __IRunpadShell2_FWD_DEFINED__ */


#ifndef __IRunpadProShell_FWD_DEFINED__
#define __IRunpadProShell_FWD_DEFINED__
typedef interface IRunpadProShell IRunpadProShell;
#endif 	/* __IRunpadProShell_FWD_DEFINED__ */


#ifndef __RunpadShell_FWD_DEFINED__
#define __RunpadShell_FWD_DEFINED__

#ifdef __cplusplus
typedef class RunpadShell RunpadShell;
#else
typedef struct RunpadShell RunpadShell;
#endif /* __cplusplus */

#endif 	/* __RunpadShell_FWD_DEFINED__ */


#ifndef __RunpadShell2_FWD_DEFINED__
#define __RunpadShell2_FWD_DEFINED__

#ifdef __cplusplus
typedef class RunpadShell2 RunpadShell2;
#else
typedef struct RunpadShell2 RunpadShell2;
#endif /* __cplusplus */

#endif 	/* __RunpadShell2_FWD_DEFINED__ */


#ifndef __RunpadProShell_FWD_DEFINED__
#define __RunpadProShell_FWD_DEFINED__

#ifdef __cplusplus
typedef class RunpadProShell RunpadProShell;
#else
typedef struct RunpadProShell RunpadProShell;
#endif /* __cplusplus */

#endif 	/* __RunpadProShell_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

#ifdef __cplusplus
extern "C"{
#endif 


#ifndef __IRunpadShell_INTERFACE_DEFINED__
#define __IRunpadShell_INTERFACE_DEFINED__

/* interface IRunpadShell */
/* [unique][helpstring][uuid][object] */ 

typedef /* [public][public][public] */ 
enum __MIDL_IRunpadShell_0001
    {	RSS_OFF	= 0,
	RSS_TURNEDON	= 1,
	RSS_ACTIVE	= 3,
	RSS_INVALID	= -1
    } 	RSHELLSTATE;

typedef /* [public] */ 
enum __MIDL_IRunpadShell_0002
    {	RSM_ADMIN	= 0x1,
	RSM_MONITOR	= 0x2,
	RSM_INPUT	= 0x4,
	RSM_BLOCKED	= 0x8
    } 	RSHELLMODE;

typedef /* [public][public][public][public] */ 
enum __MIDL_IRunpadShell_0003
    {	RSF_SHELL	= 0,
	RSF_DESKTOP	= 1,
	RSF_BG	= 2,
	RSF_RULES	= 3,
	RSF_USERFOLDER	= 4,
	RSF_VIPFOLDER	= 5
    } 	RSHELLFOLDER;

typedef /* [public] */ 
enum __MIDL_IRunpadShell_0004
    {	RSMSG_DESKTOP	= 0,
	RSMSG_TRAY	= 1,
	RSMSG_STATUS	= 2
    } 	RSHELLMESSAGE;

typedef /* [public][public][public][public] */ 
enum __MIDL_IRunpadShell_0005
    {	RSA_SHOWPANEL	= 0,
	RSA_MINIMIZEALLWINDOWS	= 1,
	RSA_KILLALLTASKS	= 2,
	RSA_RESTOREVMODE	= 3,
	RSA_UPDATEDESKTOP	= 4,
	RSA_CLOSECHILDWINDOWS	= 5,
	RSA_SWITCHTOUSERMODE	= 6,
	RSA_TURNMONITORON	= 7,
	RSA_TURNMONITOROFF	= 8,
	RSA_ENDVIPSESSION	= 9,
	RSA_RUNPROGRAMDISABLE	= 10,
	RSA_RUNPROGRAMENABLE	= 11,
	RSA_LOGOFF	= 12,
	RSA_LOGOFFFORCE	= 13,
	RSA_RUNSCREENSAVER	= 14,
	RSA_LANGSELECTDIALOG	= 15,
	RSA_LANGSELECTRUS	= 16,
	RSA_LANGSELECTENG	= 17,
	RSA_CLOSEACTIVESHEET	= 20,
	RSA_SHOWLA	= 21
    } 	RSHELLACTION;


EXTERN_C const IID IID_IRunpadShell;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("0CBC0D60-02DB-434d-99C0-003702C65934")
    IRunpadShell : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetShellState( 
            /* [out] */ RSHELLSTATE *pState) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetShellExecutable( 
            /* [size_is][out] */ LPSTR lpszExePath,
            /* [in] */ DWORD cbPathLen,
            /* [out] */ DWORD *lpdwPID) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE TurnShell( 
            /* [in] */ BOOL bNewState) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetShellMode( 
            /* [out] */ DWORD *lpdwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE IsShellOwnedWindow( 
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetFolderPath( 
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetMachineNumber( 
            /* [out] */ DWORD *lpdwNum) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentSheet( 
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnableSheets( 
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE RegisterClient( 
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE ShowInfoMessage( 
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE DoSingleAction( 
            /* [in] */ RSHELLACTION dwAction) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IRunpadShellVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IRunpadShell * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IRunpadShell * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IRunpadShell * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellState )( 
            IRunpadShell * This,
            /* [out] */ RSHELLSTATE *pState);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellExecutable )( 
            IRunpadShell * This,
            /* [size_is][out] */ LPSTR lpszExePath,
            /* [in] */ DWORD cbPathLen,
            /* [out] */ DWORD *lpdwPID);
        
        HRESULT ( STDMETHODCALLTYPE *TurnShell )( 
            IRunpadShell * This,
            /* [in] */ BOOL bNewState);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellMode )( 
            IRunpadShell * This,
            /* [out] */ DWORD *lpdwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *IsShellOwnedWindow )( 
            IRunpadShell * This,
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned);
        
        HRESULT ( STDMETHODCALLTYPE *GetFolderPath )( 
            IRunpadShell * This,
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen);
        
        HRESULT ( STDMETHODCALLTYPE *GetMachineNumber )( 
            IRunpadShell * This,
            /* [out] */ DWORD *lpdwNum);
        
        HRESULT ( STDMETHODCALLTYPE *GetCurrentSheet )( 
            IRunpadShell * This,
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen);
        
        HRESULT ( STDMETHODCALLTYPE *EnableSheets )( 
            IRunpadShell * This,
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable);
        
        HRESULT ( STDMETHODCALLTYPE *RegisterClient )( 
            IRunpadShell * This,
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *ShowInfoMessage )( 
            IRunpadShell * This,
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *DoSingleAction )( 
            IRunpadShell * This,
            /* [in] */ RSHELLACTION dwAction);
        
        END_INTERFACE
    } IRunpadShellVtbl;

    interface IRunpadShell
    {
        CONST_VTBL struct IRunpadShellVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IRunpadShell_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRunpadShell_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IRunpadShell_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IRunpadShell_GetShellState(This,pState)	\
    ( (This)->lpVtbl -> GetShellState(This,pState) ) 

#define IRunpadShell_GetShellExecutable(This,lpszExePath,cbPathLen,lpdwPID)	\
    ( (This)->lpVtbl -> GetShellExecutable(This,lpszExePath,cbPathLen,lpdwPID) ) 

#define IRunpadShell_TurnShell(This,bNewState)	\
    ( (This)->lpVtbl -> TurnShell(This,bNewState) ) 

#define IRunpadShell_GetShellMode(This,lpdwFlags)	\
    ( (This)->lpVtbl -> GetShellMode(This,lpdwFlags) ) 

#define IRunpadShell_IsShellOwnedWindow(This,hWnd,lpbOwned)	\
    ( (This)->lpVtbl -> IsShellOwnedWindow(This,hWnd,lpbOwned) ) 

#define IRunpadShell_GetFolderPath(This,dwFolderType,lpszPath,cbPathLen)	\
    ( (This)->lpVtbl -> GetFolderPath(This,dwFolderType,lpszPath,cbPathLen) ) 

#define IRunpadShell_GetMachineNumber(This,lpdwNum)	\
    ( (This)->lpVtbl -> GetMachineNumber(This,lpdwNum) ) 

#define IRunpadShell_GetCurrentSheet(This,lpszName,cbNameLen)	\
    ( (This)->lpVtbl -> GetCurrentSheet(This,lpszName,cbNameLen) ) 

#define IRunpadShell_EnableSheets(This,lpszName,bEnable)	\
    ( (This)->lpVtbl -> EnableSheets(This,lpszName,bEnable) ) 

#define IRunpadShell_RegisterClient(This,lpszClientName,lpszClientPath,dwFlags)	\
    ( (This)->lpVtbl -> RegisterClient(This,lpszClientName,lpszClientPath,dwFlags) ) 

#define IRunpadShell_ShowInfoMessage(This,lpszText,dwFlags)	\
    ( (This)->lpVtbl -> ShowInfoMessage(This,lpszText,dwFlags) ) 

#define IRunpadShell_DoSingleAction(This,dwAction)	\
    ( (This)->lpVtbl -> DoSingleAction(This,dwAction) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IRunpadShell_INTERFACE_DEFINED__ */


#ifndef __IRunpadShell2_INTERFACE_DEFINED__
#define __IRunpadShell2_INTERFACE_DEFINED__

/* interface IRunpadShell2 */
/* [unique][helpstring][uuid][object] */ 


EXTERN_C const IID IID_IRunpadShell2;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("548856D7-555A-445B-BDEB-EEE491A14C39")
    IRunpadShell2 : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetShellState( 
            /* [out] */ RSHELLSTATE *pState) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetShellExecutable( 
            /* [size_is][out] */ LPSTR lpszExePath,
            /* [in] */ DWORD cbPathLen,
            /* [out] */ DWORD *lpdwPID) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE TurnShell( 
            /* [in] */ BOOL bNewState) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetShellMode( 
            /* [out] */ DWORD *lpdwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE IsShellOwnedWindow( 
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetFolderPath( 
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetMachineNumber( 
            /* [out] */ DWORD *lpdwNum) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentSheet( 
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnableSheets( 
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE RegisterClient( 
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE ShowInfoMessage( 
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE DoSingleAction( 
            /* [in] */ RSHELLACTION dwAction) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipLogin( 
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipRegister( 
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipLogout( 
            /* [in] */ BOOL bWait) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IRunpadShell2Vtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IRunpadShell2 * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IRunpadShell2 * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IRunpadShell2 * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellState )( 
            IRunpadShell2 * This,
            /* [out] */ RSHELLSTATE *pState);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellExecutable )( 
            IRunpadShell2 * This,
            /* [size_is][out] */ LPSTR lpszExePath,
            /* [in] */ DWORD cbPathLen,
            /* [out] */ DWORD *lpdwPID);
        
        HRESULT ( STDMETHODCALLTYPE *TurnShell )( 
            IRunpadShell2 * This,
            /* [in] */ BOOL bNewState);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellMode )( 
            IRunpadShell2 * This,
            /* [out] */ DWORD *lpdwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *IsShellOwnedWindow )( 
            IRunpadShell2 * This,
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned);
        
        HRESULT ( STDMETHODCALLTYPE *GetFolderPath )( 
            IRunpadShell2 * This,
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen);
        
        HRESULT ( STDMETHODCALLTYPE *GetMachineNumber )( 
            IRunpadShell2 * This,
            /* [out] */ DWORD *lpdwNum);
        
        HRESULT ( STDMETHODCALLTYPE *GetCurrentSheet )( 
            IRunpadShell2 * This,
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen);
        
        HRESULT ( STDMETHODCALLTYPE *EnableSheets )( 
            IRunpadShell2 * This,
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable);
        
        HRESULT ( STDMETHODCALLTYPE *RegisterClient )( 
            IRunpadShell2 * This,
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *ShowInfoMessage )( 
            IRunpadShell2 * This,
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *DoSingleAction )( 
            IRunpadShell2 * This,
            /* [in] */ RSHELLACTION dwAction);
        
        HRESULT ( STDMETHODCALLTYPE *VipLogin )( 
            IRunpadShell2 * This,
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait);
        
        HRESULT ( STDMETHODCALLTYPE *VipRegister )( 
            IRunpadShell2 * This,
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait);
        
        HRESULT ( STDMETHODCALLTYPE *VipLogout )( 
            IRunpadShell2 * This,
            /* [in] */ BOOL bWait);
        
        END_INTERFACE
    } IRunpadShell2Vtbl;

    interface IRunpadShell2
    {
        CONST_VTBL struct IRunpadShell2Vtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IRunpadShell2_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRunpadShell2_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IRunpadShell2_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IRunpadShell2_GetShellState(This,pState)	\
    ( (This)->lpVtbl -> GetShellState(This,pState) ) 

#define IRunpadShell2_GetShellExecutable(This,lpszExePath,cbPathLen,lpdwPID)	\
    ( (This)->lpVtbl -> GetShellExecutable(This,lpszExePath,cbPathLen,lpdwPID) ) 

#define IRunpadShell2_TurnShell(This,bNewState)	\
    ( (This)->lpVtbl -> TurnShell(This,bNewState) ) 

#define IRunpadShell2_GetShellMode(This,lpdwFlags)	\
    ( (This)->lpVtbl -> GetShellMode(This,lpdwFlags) ) 

#define IRunpadShell2_IsShellOwnedWindow(This,hWnd,lpbOwned)	\
    ( (This)->lpVtbl -> IsShellOwnedWindow(This,hWnd,lpbOwned) ) 

#define IRunpadShell2_GetFolderPath(This,dwFolderType,lpszPath,cbPathLen)	\
    ( (This)->lpVtbl -> GetFolderPath(This,dwFolderType,lpszPath,cbPathLen) ) 

#define IRunpadShell2_GetMachineNumber(This,lpdwNum)	\
    ( (This)->lpVtbl -> GetMachineNumber(This,lpdwNum) ) 

#define IRunpadShell2_GetCurrentSheet(This,lpszName,cbNameLen)	\
    ( (This)->lpVtbl -> GetCurrentSheet(This,lpszName,cbNameLen) ) 

#define IRunpadShell2_EnableSheets(This,lpszName,bEnable)	\
    ( (This)->lpVtbl -> EnableSheets(This,lpszName,bEnable) ) 

#define IRunpadShell2_RegisterClient(This,lpszClientName,lpszClientPath,dwFlags)	\
    ( (This)->lpVtbl -> RegisterClient(This,lpszClientName,lpszClientPath,dwFlags) ) 

#define IRunpadShell2_ShowInfoMessage(This,lpszText,dwFlags)	\
    ( (This)->lpVtbl -> ShowInfoMessage(This,lpszText,dwFlags) ) 

#define IRunpadShell2_DoSingleAction(This,dwAction)	\
    ( (This)->lpVtbl -> DoSingleAction(This,dwAction) ) 

#define IRunpadShell2_VipLogin(This,lpszLogin,lpszPassword,bWait)	\
    ( (This)->lpVtbl -> VipLogin(This,lpszLogin,lpszPassword,bWait) ) 

#define IRunpadShell2_VipRegister(This,lpszLogin,lpszPassword,bWait)	\
    ( (This)->lpVtbl -> VipRegister(This,lpszLogin,lpszPassword,bWait) ) 

#define IRunpadShell2_VipLogout(This,bWait)	\
    ( (This)->lpVtbl -> VipLogout(This,bWait) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IRunpadShell2_INTERFACE_DEFINED__ */


#ifndef __IRunpadProShell_INTERFACE_DEFINED__
#define __IRunpadProShell_INTERFACE_DEFINED__

/* interface IRunpadProShell */
/* [unique][helpstring][uuid][object] */ 


EXTERN_C const IID IID_IRunpadProShell;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("83C12BF7-FF8F-4619-85CD-9DA77C8D7D5F")
    IRunpadProShell : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE GetShellPid( 
            /* [out] */ DWORD *lpdwPID) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetShellMode( 
            /* [out] */ DWORD *lpdwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE IsShellOwnedWindow( 
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetFolderPath( 
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE GetCurrentSheet( 
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE EnableSheets( 
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE RegisterClient( 
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE ShowInfoMessage( 
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE DoSingleAction( 
            /* [in] */ RSHELLACTION dwAction) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipLogin( 
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipRegister( 
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE VipLogout( 
            /* [in] */ BOOL bWait) = 0;
        
        virtual HRESULT STDMETHODCALLTYPE TempOffShell( 
            /* [in] */ LPCSTR lpszPasswordMD5,
            /* [in] */ BOOL bShowReminder) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IRunpadProShellVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )( 
            IRunpadProShell * This,
            /* [in] */ REFIID riid,
            /* [annotation][iid_is][out] */ 
            __RPC__deref_out  void **ppvObject);
        
        ULONG ( STDMETHODCALLTYPE *AddRef )( 
            IRunpadProShell * This);
        
        ULONG ( STDMETHODCALLTYPE *Release )( 
            IRunpadProShell * This);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellPid )( 
            IRunpadProShell * This,
            /* [out] */ DWORD *lpdwPID);
        
        HRESULT ( STDMETHODCALLTYPE *GetShellMode )( 
            IRunpadProShell * This,
            /* [out] */ DWORD *lpdwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *IsShellOwnedWindow )( 
            IRunpadProShell * This,
            /* [in] */ HWND hWnd,
            /* [out] */ BOOL *lpbOwned);
        
        HRESULT ( STDMETHODCALLTYPE *GetFolderPath )( 
            IRunpadProShell * This,
            /* [in] */ RSHELLFOLDER dwFolderType,
            /* [size_is][out] */ LPSTR lpszPath,
            /* [in] */ DWORD cbPathLen);
        
        HRESULT ( STDMETHODCALLTYPE *GetCurrentSheet )( 
            IRunpadProShell * This,
            /* [size_is][out] */ LPSTR lpszName,
            /* [in] */ DWORD cbNameLen);
        
        HRESULT ( STDMETHODCALLTYPE *EnableSheets )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszName,
            /* [in] */ BOOL bEnable);
        
        HRESULT ( STDMETHODCALLTYPE *RegisterClient )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszClientName,
            /* [in] */ LPCSTR lpszClientPath,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *ShowInfoMessage )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszText,
            /* [in] */ DWORD dwFlags);
        
        HRESULT ( STDMETHODCALLTYPE *DoSingleAction )( 
            IRunpadProShell * This,
            /* [in] */ RSHELLACTION dwAction);
        
        HRESULT ( STDMETHODCALLTYPE *VipLogin )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait);
        
        HRESULT ( STDMETHODCALLTYPE *VipRegister )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszLogin,
            /* [in] */ LPCSTR lpszPassword,
            /* [in] */ BOOL bWait);
        
        HRESULT ( STDMETHODCALLTYPE *VipLogout )( 
            IRunpadProShell * This,
            /* [in] */ BOOL bWait);
        
        HRESULT ( STDMETHODCALLTYPE *TempOffShell )( 
            IRunpadProShell * This,
            /* [in] */ LPCSTR lpszPasswordMD5,
            /* [in] */ BOOL bShowReminder);
        
        END_INTERFACE
    } IRunpadProShellVtbl;

    interface IRunpadProShell
    {
        CONST_VTBL struct IRunpadProShellVtbl *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IRunpadProShell_QueryInterface(This,riid,ppvObject)	\
    ( (This)->lpVtbl -> QueryInterface(This,riid,ppvObject) ) 

#define IRunpadProShell_AddRef(This)	\
    ( (This)->lpVtbl -> AddRef(This) ) 

#define IRunpadProShell_Release(This)	\
    ( (This)->lpVtbl -> Release(This) ) 


#define IRunpadProShell_GetShellPid(This,lpdwPID)	\
    ( (This)->lpVtbl -> GetShellPid(This,lpdwPID) ) 

#define IRunpadProShell_GetShellMode(This,lpdwFlags)	\
    ( (This)->lpVtbl -> GetShellMode(This,lpdwFlags) ) 

#define IRunpadProShell_IsShellOwnedWindow(This,hWnd,lpbOwned)	\
    ( (This)->lpVtbl -> IsShellOwnedWindow(This,hWnd,lpbOwned) ) 

#define IRunpadProShell_GetFolderPath(This,dwFolderType,lpszPath,cbPathLen)	\
    ( (This)->lpVtbl -> GetFolderPath(This,dwFolderType,lpszPath,cbPathLen) ) 

#define IRunpadProShell_GetCurrentSheet(This,lpszName,cbNameLen)	\
    ( (This)->lpVtbl -> GetCurrentSheet(This,lpszName,cbNameLen) ) 

#define IRunpadProShell_EnableSheets(This,lpszName,bEnable)	\
    ( (This)->lpVtbl -> EnableSheets(This,lpszName,bEnable) ) 

#define IRunpadProShell_RegisterClient(This,lpszClientName,lpszClientPath,dwFlags)	\
    ( (This)->lpVtbl -> RegisterClient(This,lpszClientName,lpszClientPath,dwFlags) ) 

#define IRunpadProShell_ShowInfoMessage(This,lpszText,dwFlags)	\
    ( (This)->lpVtbl -> ShowInfoMessage(This,lpszText,dwFlags) ) 

#define IRunpadProShell_DoSingleAction(This,dwAction)	\
    ( (This)->lpVtbl -> DoSingleAction(This,dwAction) ) 

#define IRunpadProShell_VipLogin(This,lpszLogin,lpszPassword,bWait)	\
    ( (This)->lpVtbl -> VipLogin(This,lpszLogin,lpszPassword,bWait) ) 

#define IRunpadProShell_VipRegister(This,lpszLogin,lpszPassword,bWait)	\
    ( (This)->lpVtbl -> VipRegister(This,lpszLogin,lpszPassword,bWait) ) 

#define IRunpadProShell_VipLogout(This,bWait)	\
    ( (This)->lpVtbl -> VipLogout(This,bWait) ) 

#define IRunpadProShell_TempOffShell(This,lpszPasswordMD5,bShowReminder)	\
    ( (This)->lpVtbl -> TempOffShell(This,lpszPasswordMD5,bShowReminder) ) 

#endif /* COBJMACROS */


#endif 	/* C style interface */




#endif 	/* __IRunpadProShell_INTERFACE_DEFINED__ */



#ifndef __RS_APILib_LIBRARY_DEFINED__
#define __RS_APILib_LIBRARY_DEFINED__

/* library RS_APILib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_RS_APILib;

EXTERN_C const CLSID CLSID_RunpadShell;

#ifdef __cplusplus

class DECLSPEC_UUID("D7346301-B73F-4a94-ABE6-234A0D49521D")
RunpadShell;
#endif

EXTERN_C const CLSID CLSID_RunpadShell2;

#ifdef __cplusplus

class DECLSPEC_UUID("D163EEE3-540A-48DA-9009-C194588263B9")
RunpadShell2;
#endif

EXTERN_C const CLSID CLSID_RunpadProShell;

#ifdef __cplusplus

class DECLSPEC_UUID("3D4B9FF0-329A-4ed9-A341-B07AE052B7D6")
RunpadProShell;
#endif
#endif /* __RS_APILib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  HWND_UserSize(     unsigned long *, unsigned long            , HWND * ); 
unsigned char * __RPC_USER  HWND_UserMarshal(  unsigned long *, unsigned char *, HWND * ); 
unsigned char * __RPC_USER  HWND_UserUnmarshal(unsigned long *, unsigned char *, HWND * ); 
void                      __RPC_USER  HWND_UserFree(     unsigned long *, HWND * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif


