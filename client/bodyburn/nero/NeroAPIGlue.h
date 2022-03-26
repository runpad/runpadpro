/******************************************************************************
|* THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
|* ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
|* THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
|* PARTICULAR PURPOSE.
|* 
|* Copyright 1995-2005 Nero AG. All Rights Reserved.
|*-----------------------------------------------------------------------------
|* NeroSDK / NeroAPI
|*
|* PROGRAM: NeroAPIGlue.h
|*
|* PURPOSE: Functions for connecting to NeroAPI
******************************************************************************/


#ifndef __NEROAPIGLUE__
#define __NEROAPIGLUE__

#ifdef _NEROAPI_
#	pragma message("WARNING: Include 'NeroAPIGlue.h' BEFORE any other headers of the NeroAPI!")
#endif

#ifdef  __cplusplus
extern "C" {
#endif

/*
// All functions in NeroAPI.h are implemented here, too:
*/

#include "NeroAPI.h"

#define USING_NEROSDK

/*
// This function has to be called first.
*/

BOOL NADLL_ATTR NeroAPIGlueConnect (void *reserved);

/*
// This one cleans up after using the glue code.
*/
void NADLL_ATTR NeroAPIGlueDone (void);


// Returns the module handle of the loaded NeroAPI
HMODULE NADLL_ATTR NeroAPIGlueGetModuleHandle();


// Attach an already loaded NeroAPI module
// Do NOT call NeroAPIGlueDone after this method. This should only be called
// from the part of the application that called NeroAPIGlueInitEx or 
// NeroAPIGlueConnect
//
// NOTE: This method does not set the expected version of the NeroAPI.
// This is only done when the glue layer is initialized with NeroAPIGlueConnect
// or NeroAPIGlueInitEx
// Therefore, if you attach a NeroAPI module you should always set the
// expected version of NeroAPI before calling a NeroAPI method and restore the
// previously set version afterwards.
BOOL NADLL_ATTR NeroAPIGlueAttachModule(HMODULE hNeroAPI,void *reserved);


#ifdef  __cplusplus
}
#endif


#endif /* __NEROAPIGLUE__ */

