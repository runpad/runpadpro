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
|* PROGRAM: NeroAPI.h
|*
|* PURPOSE: Main interface for Nero API DLL
******************************************************************************/
#ifndef _NEROAPI_
#define _NEROAPI_

#ifdef __cplusplus
extern "C"
{
#endif

   
/*
// If included within the glue code, then don't add special
// attributes to the functions.
*/
#define NADLL_ATTR  __cdecl
#ifdef __NEROAPIGLUE__
	#define NEROAPI_API
#else

	/* NEROAPI must not be defined when using the DLL */
	#ifdef NEROAPI
		#define NEROAPI_API __declspec(dllexport)
	#else
		#define NEROAPI_API __declspec(dllimport)
	#endif /* NEROAPI */

#endif /* __NEROAPIGLUE__ */

#ifdef  __cplusplus
class CSourceDriveInfo;
typedef CSourceDriveInfo *NERO_DEVICEHANDLE;
#else
typedef void *NERO_DEVICEHANDLE;
#endif


#include <windows.h> // the data types used below are those of windows
   
#include <time.h>

#include "NeroUserDialog.h"


#if defined(__BORLANDC__)
// NEROAPI expects structs to be 8byte aligned
#pragma pack(push, 8) 
// tell Borland C++ Builder to treat enums as int
#pragma option push -b 
#endif


/*
// The NeroAPI never uses static memory. Instead, memory is allocated
// dynamically on behalf of the application, e.g. for strings. This
// memory has to be freed with this function.
//
// Passing a NULL is allowed.
*/
NEROAPI_API void NADLL_ATTR NeroFreeMem (void *pMem);


/*
// All functions returning an DWORD will return 0 for success and a
// error number otherwise. This error numbers are opaque and neither
// can nor should be interpreted by the application. Instead, localized
// strings are provided for errors and informative displays.
//
// The NeroAPI keeps a log of such informative messages or errors.

// In case of an error, NeroGetLastError() will return more information
// about the last error and NeroGetErrorLog() will show all recorded
// events.
//
// Both functions return NULL if no error is available.
//
// Memory is allocated for the string, which has to be freed with NeroFreeMem().
//
// Note: NeroCloseDrive() has to throw away all errors, because they 
//       might be bound to the driver. Handle errors before calling it!
*/
NEROAPI_API char * NADLL_ATTR NeroGetLastError ();
NEROAPI_API char * NADLL_ATTR NeroGetErrorLog ();

/* NeroAPI >= 6.0.0.29: returns the last iNum errors */
NEROAPI_API char * NADLL_ATTR NeroGetLastErrors(int iNum, DWORD dwFlags, void *reserved);

/* include also errors which does not contain a description to be shown in the GUI */
#define NGLE_ALL (1<<0) 
/* format the errors as in the NeroAPI error log */
#define NGLE_REPORT (1<<1) 



/*
// NeroAPI >= 6.0.0.0:
// Error code describing an error happened during communication with a drive.
// This error code is returned by NeroIsDeviceReady. Other functions set an internal error
// variable to one of these codes if an error occured. This error can be received with
// NeroGetLastDriveError.
*/
typedef enum
{
   NDE_NO_ERROR  = 0, // no error occured/ drive is ready
   NDE_GENERIC_ERROR = 1, // generic error, not handled with other enums
   NDE_DRIVE_IN_USE = 2, // drive cannot be locked, maybe a other application uses this drive at the moment
   NDE_DRIVE_NOT_READY = 3, // drive is not ready
   NDE_NO_DRIVE = 4, // The given device is not available . Probably removed by the user (USB/Firewire)
   NDE_DISC_NOT_PRESENT = 5, // no medium in drive, status of tray unknown
   NDE_DISC_NOT_PRESENT_TRAY_OPEN = 6, // no medium - tray open
   NDE_DISC_NOT_PRESENT_TRAY_CLOSED = 7 // no medium - tray closed
} NERO_DRIVE_ERROR;

// Check for all variations of 'disc not present'
#define DISC_NOT_PRESENT(x)	(((x == NDE_DISC_NOT_PRESENT) || \
								  (x == NDE_DISC_NOT_PRESENT_TRAY_CLOSED) || \
								  (x == NDE_DISC_NOT_PRESENT_TRAY_OPEN)) ? TRUE : FALSE)

/*
// NeroAPI >= 6.0.0.0:
// get the last error occured during communication with a drive
// 
// The following methods set this error value:
//  - NeroGetCDInfo
//  - NeroImportDataTrack
//  - NeroEjectLoadCD
//  - NeroGetCDRWErasingTime
//  - NeroEraseDisc
//
// All these methods first reset the error value and if an error occured the value is set
// accordingly.
*/
NEROAPI_API void NADLL_ATTR NeroGetLastDriveError( NERO_DRIVE_ERROR *driveError, void *reserved);


/*
// Clear errors and log (done automatically for every read or write function,
// but can be used to avoid false memory leak warnings).
*/
NEROAPI_API void NADLL_ATTR NeroClearErrors ();


/*
// Version management for this API:
*/

// This file is the interface for this version of NeroAPI
#define NEROAPI_VERSION_MAJOR_HIGH		6
#define NEROAPI_VERSION_MAJOR_LOW		6
#define NEROAPI_VERSION_MINOR_HIGH		0
#define NEROAPI_VERSION_MINOR_LOW		1

/* Fills the pointed numbers with version number and returns true for 
   success. Extended in NeroAPI 5.5.9.9 to support multiple digits */
NEROAPI_API BOOL NADLL_ATTR NeroGetAPIVersionEx(WORD *majhi
											   ,WORD *majlo
											   ,WORD *minhi
											   ,WORD *minlo
											   ,void *reserved);  // Must be NULL

/* Using this function, an application can tell NeroAPI for which version of NeroAPI it was
designed to work. NeroAPI will then tries to behave as this version as much as possible. This
ensures the binary compatibility with future versions of NeroAPI. If this function is not called,
NeroAPI will behaves as NeroAPI 5.0.3.9. If your application uses NeroAPIGlue.c, this function
will be automatically called. Extended in NeroAPI 5.5.9.9 to support multiple digits 

If pPrevExpectedVersion is not NULL, it must point onto an array of 4 WORDs that will be filled
with the previously expected version number

Returns true for success*/
NEROAPI_API BOOL NADLL_ATTR NeroSetExpectedAPIVersionEx(WORD majhi
                                                       ,WORD majlo
													   ,WORD minhi
													   ,WORD minlo
													   ,WORD *pPrevExpectedVersion);

/*
// During writing or in several long running functions control
// is transfered to the DLL. The application has to provide services
// and dialog with the user via callback functions.
//
// NERO_CALLBACK_ATTR is defined in "NeroUserDialog.h" and ensures that
// the same conventions are used for passing of parameters.
*/
typedef struct tag_NERO_CALLBACK
{
	void *ncCallbackFunction; /* actually, this is a pointer to one of several different callback functions defined below */
	void *ncUserData;         /* this will be passed to the function as first parameter */
} NERO_CALLBACK;

typedef BOOL (NERO_CALLBACK_ATTR *NERO_IDLE_CALLBACK) (void *pUserData); /* called regularly during long running activities; return TRUE if this activity shall be aborted */


/*
// The NeroAPI needs some information:
*/
typedef struct tag_NERO_SETTINGS
{
	const char *nstNeroFilesPath;   /* directory name with trailing '\' of where to find the additional Nero DLL and text files */
   
	const char *nstVendor,
		*nstSoftware;               /* path for registry settings (use "ahead", "Nero - Burning Rom" for Nero application's settings) */
	const char *nstLanguageFile;    /* name of the Nero language file; relativ to nstNeroFilesPath (e.g. "Nero.txt") */
	NERO_CALLBACK nstIdle;          /* NERO_IDLE_CALLBACK, may be NULL */
	NERO_CALLBACK nstUserDialog;    /* NERO_USER_DIALOG, must not be NULL, see "NeroUserDialog.h" for details */

	/*
	// overburn settings:
	// overburning (writing more than the nominal capacity of a disc) is allowed if:
	//  - nstEnableOverburn == TRUE
	//  - nstOverburnSize >= amount of required blocks for compilation
	// and if
	//  - the drive supports it
	//  - DAO is used.
	// Even then, overburning has to be acknowledged via callback (see DLG_OVERBURN in "NeroUserDialog.h").
	*/
	BOOL  nstEnableOverburn;
	DWORD nstOverburnSize;    /* in blocks */
} NERO_SETTINGS;


/*
// Initialize the DLL. Must be successful before any of the remaining
// functions can be called. Settings structure and strings it points
// to are _not_ copied and function callbacks must be available all
// the time.
*/

typedef enum
{
	NEROAPI_INIT_OK=0,
	NEROAPI_INIT_INVALID_ARGS,
	NEROAPI_INIT_UNSPECIFIED_ERROR,					// Unspecified error
	NEROAPI_INIT_INVALID_SERIAL_NUM,
	NEROAPI_INIT_DEMOVERSION_EXPIRED,
	NEROAPI_INIT_ALREADY_INITIALISED,				
	NEROAPI_INIT_CANNOT_LOCK						
} NEROAPI_INIT_ERROR;

// Make sure to keep *all* the data including the strings valid as long as you're using NeroAPI,
// since Nero will only store a pointer to this structure, not make a copy.
NEROAPI_API NEROAPI_INIT_ERROR NADLL_ATTR NeroInit (const NERO_SETTINGS *pNeroSettings,const char *reserved);


/*
// Call this function before closing the DLL. This is necessary because
// some clean-up actions like stopping threads cannot be done in the
// close function of the DLL.
//
// NeroDone returns TRUE if some memory blocks were not unallocated using NeroFreeMem. They are dumped in
// the debug output.
// NeroDone returns FALSE if it succeeded
*/
NEROAPI_API BOOL NADLL_ATTR NeroDone ();

/*
Call this function to change a global option of NeroAPI
*/

typedef enum
{
	NEROAPI_OPTION_MSG_FILE_NAME,		// Set the language file. The value points to a string containing the file name. This adress will be kept.
	NEROAPI_OPTION_WRITE_BUFFER_SIZE,	// Set write buffer size. Value points onto an integer containing the size in byte
	
	// NeroAPI>=6.0.0.0 Set the user dialog callback, overwriting nstUserDialog of the settings
	// structure passed to NeroInit. 
	// Pass a pointer to a NERO_CALLBACK structure as value. After returning,
	// the struct will contain the previous user callback.
	NEROAPI_OPTION_USER_DLG_CALLBACK,		
	// NeroAPI>=6.0.0.0 Set the idle callback, overwriting nstIdle of the settings
	// structure passed to NeroInit. 
	// Pass a pointer to a NERO_CALLBACK structure as value. After returning,
	// the struct will contain the previous idle callback.
	NEROAPI_OPTION_IDLE_CALLBACK,

	// NeroAPI>=6.0.0.27: Enable/Disable overburning for CDs.
	// Value is a pointer to a DWORD containing the overburn size (the total size
	// of the CD) in blocks.
	// If the value is NULL, disable overburning for CDs.
	NEROAPI_OPTION_OVERBURN,

	// NeroAPI>=6.3.1.12: Enable/Disable overburning for DVD.
	// Value is a pointer to a DWORD containing the overburn size (the total size
	// of the DVD) in blocks. 
	// If the value is NULL, disable overburning for DVDs.
	NEROAPI_OPTION_DVDOVERBURN

} NEROAPI_OPTION;

NEROAPI_API int NADLL_ATTR NeroSetOption(NEROAPI_OPTION option,void *value);


/*
// Code to scan the SCSI/IDE bus and get information about
// the available WORM/CDROM drives:
*/

typedef enum
{       
	NEA_SCSI_DEVTYPE_UNKNOWN,
	NEA_SCSI_DEVTYPE_WORM,      /* can write */
	NEA_SCSI_DEVTYPE_CDROM,     /* can only read */
	NEA_SCSI_DEVTYPE_UNSUPPORTED_WORM	/* can write but is not supported by NeroAPI */
} NEROAPI_SCSI_DEVTYPE;

typedef struct tag_NERO_SPEED_INFOS
{
	DWORD nsiNumSupportedSpeeds;     /* 1 if the speed cannot be changed */
	DWORD nsiBaseSpeedKBs;			 /* Speed corresponding to 1X for the selected media in KB/s */
	DWORD nsiSupportedSpeedsKBs[64]; /* List of possible speeds in KB/s */
	DWORD nsiSupportedSpeeds[64];    /* List of possible speeds in multiple of 150KB/s (1X for CD) (present for compatibility) */
	DWORD nsiReserved[32];
} NERO_SPEED_INFOS;

typedef enum tag_NERO_MEDIA_TYPE
{
	MEDIA_NONE				=	0,								// No media present (NeroAPI>=5.5.9.4)
	MEDIA_CD				=	0x00001,						// CD-R/RW
	MEDIA_DDCD				=	0x00002,						// DDCD-R/RW
	MEDIA_DVD_M				=	0x00004,						// DVD-R/RW
	MEDIA_DVD_P				=	0x00008,						// DVD+RW
	MEDIA_DVD_RAM			=	0x00010,						// DVD-RAM
	MEDIA_ML				=	0x00020,						// ML (Multi Level disc)
	MEDIA_MRW				=	0x00040,						// Mt. Rainier

	//NeroAPI>=5.5.9.4:
	MEDIA_NO_CDR			=	0x00080,						// Exclude CD-R
	MEDIA_NO_CDRW			=	0x00100,						// Exclude CD-RW
	MEDIA_CDRW				=   MEDIA_CD|MEDIA_NO_CDR,			// CD-RW		
	MEDIA_CDR				=   MEDIA_CD|MEDIA_NO_CDRW,			// CD-R
	MEDIA_DVD_ROM			=	0x00200,						// DVD-ROM (non writable)
	MEDIA_CDROM				=	0x00400,						// CD-ROM (non writable)

	//NeroAPI>=5.5.9.10
	MEDIA_NO_DVD_M_RW		=	0x00800,						// Exclude DVD-RW
	MEDIA_NO_DVD_M_R		=	0x01000,						// Exclude DVD-R
	MEDIA_NO_DVD_P_RW		=	0x02000,						// Exclude DVD+RW
	MEDIA_NO_DVD_P_R		=	0x04000,						// Exclude DVD+R
	MEDIA_DVD_M_R			=	MEDIA_DVD_M|MEDIA_NO_DVD_M_RW,	// DVD-R
	MEDIA_DVD_M_RW			=	MEDIA_DVD_M|MEDIA_NO_DVD_M_R,	// DVD-RW
	MEDIA_DVD_P_R			=	MEDIA_DVD_P|MEDIA_NO_DVD_P_RW,	// DVD+R
	MEDIA_DVD_P_RW			=	MEDIA_DVD_P|MEDIA_NO_DVD_P_R,	// DVD+RW
	MEDIA_FPACKET			=   0x08000,						// Fixed Packetwriting
	MEDIA_VPACKET			=	0x10000,						// Variable Packetwriting
	MEDIA_PACKETW			=	MEDIA_MRW|MEDIA_FPACKET			// a bit mask for packetwriting
									|MEDIA_VPACKET,
	//NeroAPI>=5.5.10.4
	MEDIA_HDB				=	0x20000,						// HD-Burn

	//NeroAPI>=6.0.0.29
	MEDIA_DVD_P_R9			=	0x40000,
	MEDIA_DVD_ANY			=	MEDIA_DVD_M|MEDIA_DVD_P|MEDIA_DVD_RAM|MEDIA_DVD_P_R9 // Any DVD-Media	
} NERO_MEDIA_TYPE;

typedef DWORD NERO_MEDIA_SET;	// Represents a set of several medias

typedef struct tag_NERO_SCSI_DEVICE_INFO
{
	char                nsdiDeviceName[64];
	char                nsdiHostAdapterName[8];
	DWORD               nsdiHostAdapterNo; 
	DWORD               nsdiDeviceID;
	NEROAPI_SCSI_DEVTYPE nsdiDevType;
	char                nsdiDriveLetter;        /* Windows drive letter or 0 if not available */

	DWORD				nsdiCapabilities;       /* drive capabilities: */
#define NSDI_ALLOWED				(1<<0)      /* the drive can only be used if this bit is set */
#define NSDI_DAO                    (1<<1)      /* can write in DAO. */
#define NSDI_READ_CD_TEXT           (1<<2)      /* can read CD text */
#define NSDI_VARIABLE_PAUSES_IN_TAO (1<<3)      /* see natPauseInBlksBeforeThisTrack below */
#define NSDI_DAO_WRITE_CD_TEXT      (1<<4)      /* writes CD text in DAO (see natArtist/Title); never supported in TAO */
#define NSDI_IMAGE_RECORDER			(1<<6)		/* drive is the image recorder */
#define NSDI_UNDETECTED				(1<<7)
#define NSDI_IDE_BUS				(1<<8)
#define NSDI_SCSI_BUS				(1<<9)
#define NSDI_BUF_UNDERRUN_PROT		(1<<10)		/* drive has a buffer underrun protection feature (not necessary Burn Proof) */
#define NSDI_RESERVED				(1<<11)		/* Must not be used */
#define NSDI_RESERVED2				(1<<12)		/* Must not be used */
#define NSDI_ALLOW_CHANGE_BOOKTYPE	(1<<13)		/* NeroAPI >5.5.10.7: DVD recorder can change booktype of burned medium */
#define NSDI_DVDPLUSVR_SUPPORTED    (1<<14)     /* NeroAPI >= 6.0.0.0: This recorder can write DVD+VR */

	NERO_SPEED_INFOS    nsdiReadSpeeds;
	NERO_SPEED_INFOS    nsdiWriteSpeeds;
	const void         *nsdiDriver;             /* opaque identifier of the internal driver, required by NeroOpenDevice() */
	char		nsdiBufUnderrunProtName[64];	/* Buffer underrun protection technology name */
												/* The string will be empty if the technology has no name */
	DWORD				nsdiMandatoryBUPSpeed;	/* it is highly recommanded to enable buffer
												   underrun protection protection when burning at this speed or
												   faster. Contains 0 if there is no recommandation */
	NERO_MEDIA_SET		nsdiMediaSupport;		/* NeroAPI>=5.5.4.1: Bit field of supported writable media (constructed with the NERO_MEDIA_TYPE enum)*/

	DWORD				nsdiDriveBufferSize;	/* NeroAPI>=5.5.9.4: Drive buffer size (internal) in KB */
	
	DWORD				nsdiDriveError;			/* NeroAPI>=6.0.0.0: Contains a NERO_DRIVE_ERROR that occured during generating the information.
												   If != NDE_NO_ERROR, some information like the drive capabilities or the speeds might be wrong.
												   You can check with NeroIsDeviceReady if the drive is ready later
												   and update the device information with NeroUpdateDeviceInfo.
												   NDE_DISC_NOT_PRESENT* errors can be ignored.
												*/
	NERO_MEDIA_SET		nsdiMediaReadSupport;	/* NeroAPI>=6.0.0.8: Bit field of supported readable media (constructed with the NERO_MEDIA_TYPE enum)*/

	DWORD               nsdiReserved[61];       /* Should be zero */
} NERO_SCSI_DEVICE_INFO;

typedef struct tag_NERO_SCSI_DEVICE_INFOS
{
	DWORD nsdisNumDevInfos; /* number of the following entries */
	NERO_SCSI_DEVICE_INFO nsdisDevInfos[1];
} NERO_SCSI_DEVICE_INFOS;

/* Gets a list of available WORM and CDROM devices, free with NeroFreeMem(). */
/* Returns NULL for error */
NEROAPI_API NERO_SCSI_DEVICE_INFOS * NADLL_ATTR NeroGetAvailableDrivesEx(
													NERO_MEDIA_TYPE	mediaType,	// Provide speeds values for this kind of media
													void *reserved);			// Must be NULL

/* NeroAPI>=6.0.0.0: Update the information about a drive. */
NEROAPI_API NERO_DRIVE_ERROR NADLL_ATTR NeroUpdateDeviceInfo(NERO_SCSI_DEVICE_INFO *devInfo // the device info to update
												, NERO_MEDIA_TYPE mediaType // the media type to update the speed infos with
												, void *reserved); // Must be NULL

/* Get a string describing the given bit field of supported media
   Free with NeroFreeMem();
*/
NEROAPI_API char *NADLL_ATTR NeroGetTypeNameOfMedia(NERO_MEDIA_SET media,void *reserved);

/*
// Open and close a device:
*/
NEROAPI_API NERO_DEVICEHANDLE NADLL_ATTR NeroOpenDevice(const NERO_SCSI_DEVICE_INFO* pDevInfo);  /* NULL for errors */
NEROAPI_API void NADLL_ATTR NeroCloseDevice(NERO_DEVICEHANDLE aDeviceHandle);

/*
// NeroAPI > 5.5.9.10
// Get available write speeds depending on medium type, free with NeroFreeMem().
// Returns NULL for error
*/
  
typedef enum
{
   ACCESSTYPE_WRITE,
   ACCESSTYPE_READ
} NERO_ACCESSTYPE;

NEROAPI_API NERO_SPEED_INFOS * NADLL_ATTR NeroGetAvailableSpeeds(NERO_DEVICEHANDLE aDeviceHandle,
							       NERO_ACCESSTYPE accessType,
							       NERO_MEDIA_TYPE mediaType,
							       void *reserved);

/*
 * NeroAPI >= 6.3.1.20e
 * Booktype settings
 */
typedef enum tag_BookTypeSettings
{
	BTS_PHYSICAL_DISC_TYPE	= 0,	// Set booktype to physical disc type. E.g. if a DVD+R is loaded the booktype is set to DVD+R.
	BTS_DVD_ROM				= 1,	// Set booktype to DVD-ROM for all types of DVDs (DVD+R, DVD+RW, DVD+R9 DL, ...).
	BTS_UNMODIFIED			= 2,	// Don't send any booktype change command to the drive. This is useful, if you have changed the settings on the drive and want to use this setting.
	BTS_AUTOMATIC			= 3		// Let NeroAPI decide, which booktype to use. This may depend from the recorder, medium type and compilation type that is burned.
} NERO_BOOK_TYPE_SETTINGS;


/*
 * NeroAPI > 5.5.10.7
 * Get and set special low level options of devices
 */
typedef enum
{
	/*
	 * Change booktype in recorder driver to the booktype given in <*value> and
	 * perform changing Booktype on drive so that the booktype of a DVD recordable
	 * disc is changed for subsequent writes until next power cycle.
	 * void* is a pointer to NERO_BOOK_TYPE_SETTINGS in Nero(Set|Get)DeviceOption.
	 *
	 * For setting the booktype to DVD-ROM, set parameter to BTS_DVD_ROM (before
	 * and including NeroAPI 6.3.1.20e: TRUE), to set to physical disc type set
	 * parameter to BTS_PHYSICAL_DISC_TYPE (before and including NeroAPI 6.3.1.20e:
	 * FALSE) and to not change the booktype settings on the drive set the parameter
	 * to BTS_UNMODIFIED. To take effect the flag NBF_NO_BOOKTYPE_CHANGE in NeroBurn
	 * should be set.
	 * In NeroGetDeviceOption, TRUE is returned if the booktype on the drive is set
	 * to DVD-ROM, FALSE otherwise.
	 */
	NERO_DEVICEOPTION_BOOKTYPE_DVDROM = 0,

	/*
	 * Set the number of blocks after that to switch from layer 0
	 * to layer 1 when writing on a double layer medium. 
	 * Notes:
	 * - the number of blocks must be a multiple of 16
	 * - the layer 0 must be >= totalDataSize/2, because there can
	 *   never be more data on layer 1 than on layer 0.
	 *
	 * In NeroSetDeviceOption value is a pointer to a DWORD variable.
	 * In NeroGetDeviceOption a pointer to a DWORD is returned.
	 */
	NERO_DEVICEOPTION_LAYERSWITCH = 1,

	/*
	 * NeroAPI >= 6.0.0.24: 
	 * Set the booktype of the next DVD recordable that is written to the value given
	 * in <*value>. the behaviour is similar as for NERO_DEVICEOPTION_BOOKTYPE_DVDROM
	 * but the change is only made in the recorder driver and not on the drive.
	 * This option is useful, if you do packetwriting.  To take effect when using NeroBurn
	 * the flag NBF_NO_BOOKTYPE_CHANGE should be set.
	 * void* is a pointer to NERO_BOOK_TYPE_SETTINGS in Nero(Set|Get)DeviceOption.
	 * In NeroGetDeviceOption, TRUE is returned if the booktype in the recorder driver
	 * is set to DVD-ROM, FALSE otherwise.
	 */
	NERO_DEVICEOPTION_BOOKTYPE_DVDROM_NEXT_WRITE = 2,

	/*
	 * Set the number of blocks after that to switch from layer 0
	 * to layer 1 when writing on a double layer medium. In difference to
	 * NERO_DEVICEOPTION_LAYERSWITCH the layer break is written
	 * immediately to the disc, while otherwise it is set during burning.
	 * Notes:
	 * - the number of blocks must be a multiple of 16
	 * - the layer 0 must be >= totalDataSize/2, because there can
	 *   never be more data on layer 1 than on layer 0.
	 *
	 * In NeroSetDeviceOption value is a pointer to a DWORD variable.
	 * In NeroGetDeviceOption a pointer to a DWORD specifying any physically
	 * set layer break point on the medium or NULL if no layer break point
	 * has been set as of yet is returned
	 */
	NERO_DEVICEOPTION_BREAK_LAYER = 3

} NERO_DEVICEOPTION;

/*
// Set a special option for a device
// returns 0 an success
*/
NEROAPI_API int NADLL_ATTR NeroSetDeviceOption(NERO_DEVICEHANDLE aDeviceHandle,
									NERO_DEVICEOPTION aOption,
									void *value);

/*
// Get an option from a device. The returned value must be freed with NeroFreeMem
// by the caller
*/
NEROAPI_API void* NADLL_ATTR NeroGetDeviceOption(NERO_DEVICEHANDLE aDeviceHandle,
									NERO_DEVICEOPTION aOption, void* reserved);


/*
// CD-Information:
*/

typedef enum
{
	NTT_UNKNOWN,
	NTT_DATA,
	NTT_AUDIO
} NERO_TRACK_TYPE;

typedef struct tag_NERO_TRACK_INFO
{
	DWORD           ntiSessionNumber;
	DWORD           ntiTrackNumber;
	NERO_TRACK_TYPE ntiTrackType;
	DWORD           ntiTrackStartBlk;
	DWORD           ntiTrackLengthInBlks;
	char            ntiArtist[65];
	char            ntiTitle[65];
	char			ntiISRC[13];			/* NeroAPI > 5.5.8.3: if NGCDI_READ_ISRC is present: 12 chars ISRC code + terminator */
	DWORD           ntiBlockSize;           /* NeroAPI >= 6.0.0.0: size of one block in bytes */
	DWORD           ntiReserved[28];        /* Should be zero */
} NERO_TRACK_INFO;

typedef enum
{
	NMT_UNKNOWN,
	NMT_CD_ROM,
	NMT_CD_RECORDABLE,
	NMT_CD_REWRITEABLE
} NERO_MEDIUM_TYPE;

typedef struct tag_NERO_CD_INFO
{
	DWORD            ncdiFreeCapacityInBlocks;
	BOOL             ncdiIsWriteable;       /* A disc can be non-writeable */
	NERO_MEDIUM_TYPE ncdiMediumType;        /* Old media type description, ncdiMediaType should be used instead */
	char             ncdiArtist[65];
	char             ncdiTitle[65];
	DWORD			 ncdiAvailableEraseModes;/* This bitfield can be decoded using the NCDI_IS_ERASE_MODE_AVAILABLE macro */
	DWORD			 ncdiUnusedBlocks;		/* difference beetween Lead-Out position and last possible Lead-Out position */
	NERO_MEDIA_TYPE	 ncdiMediaType;			/* NeroAPI>=5.5.9.4: type of media */
	DWORD			 ncdiMediumFlags;		/* NeroAPI>6.0.0.10: various medium flags (Virtual multisession, ...)  */
/* The medium is a virtual multisession medium, use VMS API to retrieve session information.
   NOTE: This flag only tells you, that if multisession is written, VMS is used. But not
         that this medium contains multisessions.
*/
#define NCDIMF_VIRTUALMULTISESSION	(1<<0)
#define NCDIMF_HDB_SUPPORTED		(1<<1)  /* The medium supports HD-BURN */

	DWORD            ncdiLayer0MaxBlocks;   /* NeroAPI>6.0.0.19: If this value is set, the medium is a double layer medium whereby 
	                                         * layer 0 can not be bigger than the given number of blocks.
                                             */
	DWORD            ncdiTotalCapacity;		/* NeroAPI>=6.3.0.5: The total capacity of this medium */
	DWORD            ncdiReserved[26];      /* Should be zero */
	DWORD            ncdiNumTracks;
	NERO_TRACK_INFO  ncdiTrackInfos[1];
} NERO_CD_INFO;

#define NCDI_IS_ERASE_MODE_AVAILABLE(cdInfo,eraseMode)	((cdInfo).ncdiAvailableEraseModes & (1<<(eraseMode)))

/*
// Get information about a CD. Free result with NeroFreeMem().
//
// aDeviceHandle: result of NeroOpenDevice()
//         flags: see below
//
// Returns NULL in case of error.
*/
NEROAPI_API NERO_CD_INFO * NADLL_ATTR NeroGetCDInfo(NERO_DEVICEHANDLE aDeviceHandle, DWORD dwFlags);
#define NGCDI_READ_CD_TEXT      (1<<0)		/* also try to fill in */
#define NGCDI_READ_ISRC			(1<<1)		/* NeroAPI>=5.5.8.4 */
/* NeroAPI>=6.0.0.25: 
 * If the recorder and the current medium support HD-BURN, give the capacity and 
 * the unused blocks for the HD-BURN mode 
 * Note, that if the medium is already written in HD-BURN mode, this flag is not necessary.
 */
#define NGCDI_USE_HDB			(1<<2)		

typedef struct tag_NERO_VMSSESSION
{
	char		nvmssSessionName[256];		/* The name of the session (volume name) */
	struct tm	nvmssCreationTime;			/* The creation time of the session */
	DWORD		nvmssNextWritableAddress;	/* The first block that is not occupied by this session */
	DWORD		nvmssReserved[32];			/* Should be zero */
} NERO_VMSSESSION;

typedef struct tag_NERO_VMS_INFO
{
	DWORD			nvmsiNextWritableAddress;	/* The next writable address of the medium, may be used for free space calculation */
	DWORD			nvmsiNumSessions;			/* Number of sessions stored on the VMS medium */
	DWORD			nvmsiReserved[32];			/* Should be zero */
	NERO_VMSSESSION	nvmsiSessionInfo[1];		/* One entry per session */
} NERO_VMS_INFO;


/*
// NeroAPI>6.0.0.10: Retrieve virtual multisession information for media supporting it.
// This function may be called for media having the NCDIMF_VIRTUALMULTISESSION flag
// set in their NERO_CD_INFO structure. Free result with NeroFreeMem()
//
// aDeviceHandle: result of NeroOpenDevice()
//         flags: currently unused, reserved for future extensions
//
// Returns NULL in case of error (e.g. non-VMS medium inserted)
//
// Virtual multisession is a technique to allow writing multisession discs on
// medium types that does not support normal multisession, e.g. DVD-+RW.
*/
NEROAPI_API NERO_VMS_INFO * NADLL_ATTR NeroGetVMSInfo(NERO_DEVICEHANDLE aDeviceHandle, DWORD dwFlags);


/*
// NeroAPI>=5.5.9.16: Get information about a disc image. Result must be released using NeroFreeMem().
//
// imagePath: path to the image file
// reserved: reserved for future usage
// 
// Returns NULL in case of error.
*/
NEROAPI_API NERO_CD_INFO * NADLL_ATTR NeroGetDiscImageInfo(const char *imagePath, void *reserved);

/*
// A progress display could look like this:
//
// +------------------------------------------------------+
// | Log of Operation:                                    |
// | +--------------------------------------------------+ |
// | | [icon] text                                      | |
// | | ...........                                      | |
// | |                                                  | |
// | +--------------------------------------------------+ |
// | Current Phase: text                                  |
// |      Progress: ********............................  |
// |                                                      |
// |                       ABORT                          |
// +------------------------------------------------------+
//
// The application may provide callback functions to set
// the different parts of this display. All of them may
// be NULL.
*/
typedef BOOL  (NERO_CALLBACK_ATTR *NERO_PROGRESS_CALLBACK)(void *pUserData, DWORD dwProgressInPercent); /* Will return TRUE if the user wants to abort */
typedef BOOL  (NERO_CALLBACK_ATTR *NERO_ABORTED_CALLBACK)(void *pUserData);                             /*  "     "     "    "  "    "    "    "   "   */
typedef enum
{
	NERO_TEXT_INFO,        /* informative text                     */
	NERO_TEXT_STOP,        /* some operation stopped prematurely   */
	NERO_TEXT_EXCLAMATION, /* important information                */
	NERO_TEXT_QUESTION,    /* a question which requires an answer  */
	NERO_TEXT_DRIVE,       /* a message concerning a CD-ROM drive or recorder */
	NERO_TEXT_FILE,        /* a message concerning a file          */
	NERO_TEXT_UNSPECIFIED  /* no type specified                    */
} NERO_TEXT_TYPE;       

typedef enum
{
	NERO_PHASE_UNSPECIFIED					=-1,
	NERO_PHASE_START_CACHE					=24,
	NERO_PHASE_DONE_CACHE					=25,
	NERO_PHASE_FAIL_CACHE					= 26,
	NERO_PHASE_ABORT_CACHE					= 27,
	NERO_PHASE_START_TEST					=28,
	NERO_PHASE_DONE_TEST					=29,
	NERO_PHASE_FAIL_TEST					= 30,
	NERO_PHASE_ABORT_TEST					= 31,
	NERO_PHASE_START_SIMULATE				=32,
	NERO_PHASE_DONE_SIMULATE				=33,
	NERO_PHASE_FAIL_SIMULATE				= 34,
	NERO_PHASE_ABORT_SIMULATE				= 35,
	NERO_PHASE_START_WRITE					=36,
	NERO_PHASE_DONE_WRITE					=37,
	NERO_PHASE_FAIL_WRITE					= 38,
	NERO_PHASE_ABORT_WRITE					= 39,
	NERO_PHASE_START_SIMULATE_NOSPD			=61,
	NERO_PHASE_DONE_SIMULATE_NOSPD			=62,
	NERO_PHASE_FAIL_SIMULATE_NOSPD			= 63,
	NERO_PHASE_ABORT_SIMULATE_NOSPD			= 64,
	NERO_PHASE_START_WRITE_NOSPD			=65,
	NERO_PHASE_DONE_WRITE_NOSPD				=66,
	NERO_PHASE_FAIL_WRITE_NOSPD				= 67,
	NERO_PHASE_ABORT_WRITE_NOSPD			= 68,
	NERO_PHASE_PREPARE_ITEMS				= 73,
	NERO_PHASE_VERIFY_COMPILATION			= 78,
	NERO_PHASE_VERIFY_ABORTED				= 79,
	NERO_PHASE_VERIFY_END_OK				= 80,
	NERO_PHASE_VERIFY_END_FAIL				= 81,
	NERO_PHASE_ENCODE_VIDEO					=82,
	NERO_PHASE_SEAMLESSLINK_ACTIVATED      = 87,  // deprecated, use NERO_PHASE_BUP_ACTIVATED below
	NERO_PHASE_BUP_ACTIVATED				=90,  // Generic: Buffer underun protection activated
	NERO_PHASE_START_FORMATTING				= 98, 
	NERO_PHASE_CONTINUE_FORMATTING			=99,
	NERO_PHASE_FORMATTING_SUCCESSFUL		=100,
	NERO_PHASE_FORMATTING_FAILED            =101,
	NERO_PHASE_PREPARE_CD					=105,
	NERO_PHASE_DONE_PREPARE_CD				=106,
	NERO_PHASE_FAIL_PREPARE_CD				=107,
	NERO_PHASE_ABORT_PREPARE_CD				=108,
	NERO_PHASE_DVDVIDEO_DETECTED			=111,
	NERO_PHASE_DVDVIDEO_REALLOC_STARTED		=112,
	NERO_PHASE_DVDVIDEO_REALLOC_COMPLETED	=113,
	NERO_PHASE_DVDVIDEO_REALLOC_NOTNEEDED	=114, // NeroAPI > 5.5.9.3
	NERO_PHASE_DVDVIDEO_REALLOC_FAILED		=115,  // NeroAPI > 5.5.9.3
	NERO_PHASE_DRM_CHECK_FAILURE			=169,  // NeroAPI >= 6.3.0.6
	/** Start Burn-at-once phases **/
	NERO_PHASE_START_WRITE_DATAFILES		=171,	// Writing data files started
	NERO_PHASE_DONE_WRITE_DATAFILES			=172,   // Writing data files completed successfully
	NERO_PHASE_FAIL_WRITE_DATAFILES			=173,	// Writing data files failed
	NERO_PHASE_WARN_WRITE_DATAFILES			=174,	// Writing data files completed with warnings
	NERO_PHASE_START_BAO_FINALIZE			=175,	// Finalizing disc started
	NERO_PHASE_FAIL_BAO_FINALIZE			=176,	// Finalizing the disc failed
	NERO_PHASE_DONE_BAO_FINALIZE			=177,	// Disc finalized successfully
	NERO_PHASE_FAIL_BAO_PREPARE				=178,	// Preparing the disc failed
	NERO_PHASE_FAIL_BAO_WRITEFILE			=179,	// Writing file to disc failed
	/** End Burn-at-once phases **/
	NERO_PHASE_BURN_LAYER_1					=180,	// Starting writing on layer 1 of a double layer disc
	NERO_PHASE_BURN_LAYER_2					=181,	// Starting writing on layer 2 of a double layer disc
} NERO_MAJOR_PHASE;

/* a one-line text to be displayed; text pointer becomes invalid after returning from this function */
typedef void  (NERO_CALLBACK_ATTR *NERO_ADD_LOG_LINE_CALLBACK)(void *pUserData, NERO_TEXT_TYPE type, const char *text); 

/* set the phase line; text pointer becomes invalid after returning from this function */
typedef void  (NERO_CALLBACK_ATTR *NERO_SET_PHASE_CALLBACK)(void *pUserData, const char *text);                         

/* Tell the main program whether the burn process can be interrupted or not */
typedef void (NERO_CALLBACK_ATTR *NERO_DISABLE_ABORT_CALLBACK)(void *pUserData,BOOL abortEnabled);

/* Let the application knows in which part of the burn process NeroAPI is */
typedef void (NERO_CALLBACK_ATTR *NERO_SET_MAJOR_PHASE_CALLBACK)(void *pUserData,NERO_MAJOR_PHASE phase,void *reserved);

typedef struct tag_NERO_PROGRESS
{
	NERO_PROGRESS_CALLBACK npProgressCallback;
	NERO_ABORTED_CALLBACK npAbortedCallback;
	NERO_ADD_LOG_LINE_CALLBACK npAddLogLineCallback;
	NERO_SET_PHASE_CALLBACK npSetPhaseCallback;
	void *npUserData;
	NERO_DISABLE_ABORT_CALLBACK npDisableAbortCallback;		/* Will be called only if the NBF_DISABLE_ABORT flags is given to the NeroBurn function */
	NERO_SET_MAJOR_PHASE_CALLBACK npSetMajorPhaseCallback;	
	NERO_PROGRESS_CALLBACK npSubTaskProgressCallback;		/* provide the write buffer fill level */
} NERO_PROGRESS;

/*
// NeroAPI >= 6.0.0.0
// creates a NERO_PROGRESS structure correctly initialised.
// Must be freed with NeroFreeMem when no longer needed.
*/
NEROAPI_API NERO_PROGRESS* NADLL_ATTR NeroCreateProgress();

/*
// Data exchange between application and NeroAPI is done with
// a function that gets a pointer to its own structure, a buffer
// pointer and the amount in bytes to be read or written. It
// shall return the actual amount of bytes transferred. Other
// functions indicate that the EOF file has been reached when
// reading or a serious error occured.
*/
typedef DWORD (NERO_CALLBACK_ATTR *NERO_IO_CALLBACK)(void *pUserData, BYTE *pBuffer, DWORD dwLen);
typedef BOOL (NERO_CALLBACK_ATTR *NERO_STATUS_CALLBACK)(void *pUserData);
typedef struct tag_NERO_IO
{
	void                 *nioUserData;
	NERO_IO_CALLBACK     nioIOCallback;
	NERO_STATUS_CALLBACK nioEOFCallback;          // shall return TRUE if further IO calls will always fail to transfer any data, i.e. EOF reached
	NERO_STATUS_CALLBACK nioErrorCallback;        // shall return TRUE if an error occured during an IO call
} NERO_IO;


/* A pointer on this structure will be passed with the DLG_WAITCD_MEDIA_INFO user dialog callback 
   (NeroAPI>=5.5.9.4)
*/

typedef struct 
{
	DWORD ndwmiSize;
	NERO_MEDIA_TYPE ndwmiLastDetectedMedia;
	NERO_MEDIA_SET	ndwmiRequestedMedia;
	const char *ndwmiLastDetectedMediaName;
	const char *ndwmiRequestedMediaName;
} NERO_DLG_WAITCD_MEDIA_INFO;



/*
// ISO track generation functions
*/

typedef struct tag_NERO_ISO_ITEM
{
	char fileName[252];						// Deprecated, use longFileName instead
	char *longFileName;				// File name on the burnt CD 
									// (will be freed in NeroFreeIsoItem if this item is a reference)

	BOOL isDirectory;						// Is this item a directory ?
	BOOL isReference;						// Is this item a reference to a file/directory of a previous session
    // when recording RockRidge, you can set the name of a directory to be used for
	// retrieving rockridge informations here
	char sourceFilePath[252];				// Deprecated, use longSourceFilePath instead
	const char *longSourceFilePath;			// Path to the file, including file name (ignored for a directory)
	struct tag_NERO_ISO_ITEM *subDirFirstItem;	// Point on the first item of the sub directory if the item is a directory 
											// Can be NULL if the directory is empty
											// (ignored for a file)
	struct tag_NERO_ISO_ITEM *nextItem;			// Next item in the current directory
	void *userData;							// Can be used to store additional informations

	// Used to reference a file from a previous session
	long dataStartSec;
	__int64 dataLength;
	struct tm entryTime;
    int itemSize;  							// Size of the structure
    struct CImportInfo *importinfo;			// ImportInfo

    WCHAR *unicodeFileName;    // NeroAPI>=6.6.0.0: file name on the burnt CD in unicode format. If unicodeFileName is present,	it supersedes fileName and longFileName.
                                   // (will be freed in NeroFreeIsoItem if this item is a reference)
} NERO_ISO_ITEM;

typedef struct tag_NERO_IMPORT_DATA_TRACK_INFO
{
	DWORD nidtiSize;			// Must contain the size of the structure
	char *nidtipVolumeName;		// This must be released using NeroFreeMem
} NERO_IMPORT_DATA_TRACK_INFO;

// NeroCreateIsoItem: Allocate an instance from the NERO_ISO_ITEM structure
//    The itemSize member of the structure will be automatically be filled by this
//    function
#define NeroCreateIsoItem()	NeroCreateIsoItemOfSize(sizeof(NERO_ISO_ITEM))
NEROAPI_API NERO_ISO_ITEM * NADLL_ATTR NeroCreateIsoItemOfSize(size_t);

// Free an instance from the NERO_ISO_ITEM structure
// longFilename is only freed if this item is a reference, because only then is longFilename allocated by NeroAPI
NEROAPI_API void NADLL_ATTR NeroFreeIsoItem(NERO_ISO_ITEM *);

/*
// NeroAPI >= 6.0.0.0:
// Free an NERO_ISO_ITEM including all linked items
*/ 
NEROAPI_API void NADLL_ATTR NeroFreeIsoItemTree(NERO_ISO_ITEM*);
   
// NeroCopyIsoItem: Create a copy of an existing NERO_ISO_ITEM object.
//    This is a safe way to obtain an exact copy of NERO_ISO_ITEM objects imported
//    from a previous session
//    Note that the new NERO_ISO_ITEM's nextItem,userData and subDirFirstItem members are set to NULL
//    longFilename is only copied if this item is a reference, because only then is longFilename allocated by NeroAPI
//    Available for NeroAPI versions >5.5.9.9
NEROAPI_API NERO_ISO_ITEM * NADLL_ATTR NeroCopyIsoItem(const NERO_ISO_ITEM *iso_item);

// Create an ISO track from a NERO_ISO_ITEM tree
// NeroAPI >= 5.5.9.0:
// For special needs you have to give a pointer to NeroCITEArgs instead of name.
// See declaration of NeroCiteArgs below. Set flags to NCITEF_USE_STRUCT,
// to tell NeroCreateIsoTrackEx that name is a NeroCITEArgs struct and set the flags
// for the burn options with NeroCITEArgs::dwBurnOptions. root should also be NULL
// in this case.
NEROAPI_API
struct CNeroIsoTrack * NADLL_ATTR NeroCreateIsoTrackEx(NERO_ISO_ITEM *root,	// First item of the root directory
													 const char *name,				// Name of the CD
													 DWORD flags);					// See constants below


// this struct can be used to give some more parameters to NeroCreateIsoTrackEx:
// - If a CD shall have two different filesystems (e.g. HFS+ CDs), you can give
// the second filesystem with firstRootItem_wrapper.
// - give some information to be written to the volume descriptor
typedef struct tag_NERO_CITE_ARGS {
	int size; // ignored. Initialise whole struct with 0. The version of the
	          // struct will be taken from expected version of NeroAPI
	NERO_ISO_ITEM *firstRootItem;
	NERO_ISO_ITEM *firstRootItem_wrapper;
	const char    *name;
	DWORD          dwBurnOptions;
	// NeroAPI >= 5.5.9.26: 
	const char    *systemIdentifier; // system identifier
	const char    *volumeSet;
	const char    *publisher; // the publisher of this track
	const char    *dataPreparer; // the preparer of this track
	const char    *application; // the application, that created this track
	const char    *copyright; // copyright file
	const char    *abstract;  // abstract file
	const char    *bibliographic; // bibliographic file
} NERO_CITE_ARGS;

// definition for compatibility reasons
#define NeroCITEArgs NERO_CITE_ARGS

#define NCITEF_USE_JOLIET		(1<<0)
#define NCITEF_USE_MODE2		(1<<1)
#define NCITEF_USE_ROCKRIDGE	(1<<2)
#define NCITEF_CREATE_ISO_FS	(1<<3)
#define NCITEF_CREATE_UDF_FS	(1<<4)
#define NCITEF_CREATE_HFS_FS    (1<<5)
#define NCITEF_DVDVIDEO_REALLOC	(1<<6)	// NeroAPI>=5.5.7.8:  Perform reallocation of files in the VIDEO_TS directory; NeroAPI>=6.3.1.4: Also create layerbreak if writing on a double layer medium
#define NCITEF_USE_STRUCT	    (1<<7)	// NeroAPI>=5.5.9.0:  'name' points to an argument struct instead of name. If set, 'root' and other 'flags' are ignored.
#define NCITEF_RESERVED1        (1<<8)  // Reserved
#define NCITEF_USE_ALLSPACE	    (1<<9)	// NeroAPI>=5.5.9.17: Use all space available on the medium for the volume to be created. Supported for DVD+-RW only
#define NCITEF_RESERVED2	    (1<<10)	// Reserved
#define NCITEF_RESERVED3        (1<<11) // Reserved
#define NCITEF_RESERVED4		(1<<12) // Reserved
#define NCITEF_RELAX_JOLIET		(1<<13)	// NeroAPI>=6.0.0.0:Relax joliet filename length limitations -> allow a maximum of 109 characters per filename
#define NCITEF_DVDVIDEO_CMPT	(1<<14)	// NeroAPI>6.0.0.13:  Create DVD-Video compatible medium, NCITEF_CREATE_ISO_FS and NCITEF_CREATE_UDF_FS must be set,
                                        //                    NCITEF_DVDVIDEO_REALLOC may be set to reallocate DVD-Video .IFO pointers
										//					  Note that NeroAPI versions prior or equal to 6.0.0.13 will implicitly enable DVD-Video compatibility
										//					  when DVD-Video content is found within your compilation
#define NCITEF_RESERVED5		(1<<15)	// Reserved


// Free an ISO track previously allocated with NeroCreateIsoTrackEx

NEROAPI_API void NADLL_ATTR NeroFreeIsoTrack(struct CNeroIsoTrack *track);

typedef enum 
{
	NIDTR_NO_ERROR=0,
	NIDTR_GENERIC_ERROR, // undefined error
	NIDTR_DRIVE_ERROR, // get more details with NeroGetLastDriveError
	// filesystem errors below, maybe a corrupted filesystem etc.
	// If one of these is returned, parts of the filesystem may have
	// been imported nevertheless
	NIDTR_READ_ERROR, // error while reading from the disc
	NIDTR_INVALID_FS, // errors in the filesystem on the disc	
	NIDTR_INVALID_TRACKNUMBER // the tracknumber given is invalid
} NERO_IMPORT_DATA_TRACK_RESULT;

/*
// Create a NERO_ISO_ITEM tree from an already existing ISO track in order to create a new session
// with reference to files from older sessions
// *ppCDStamp will be filled with a pointer on a CDStamp object which will have to be freed later
// *pInfo will be filled with information about the imported track
// *result will contain a result flag, may be NULL
// (NeroAPI>=6.0.0.0)
*/
NEROAPI_API NERO_ISO_ITEM *NADLL_ATTR NeroImportDataTrack(	NERO_DEVICEHANDLE pRecorder,
												DWORD trackNumber,
												void **ppCDStamp,
												NERO_IMPORT_DATA_TRACK_INFO *pInfo,
												DWORD flags,
												NERO_IMPORT_DATA_TRACK_RESULT *result,
												void *reserved);		// Must be NULL
#define NIITEF_IMPORT_ROCKRIDGE		(1<<0) // Will be ignored, RockRidge is now always imported if present
#define NIITEF_IMPORT_ISO_ONLY		(1<<1)
#define NIITEF_PREFER_ROCKRIDGE		(1<<2) // Will be ignored
#define NIITEF_IMPORT_UDF			(1<<3) // Import UDF Session
#define NIITEF_IMPORT_VMS_SESSION	(1<<4) // treat trackNumber as the virtual multisession session specifier

// Free a CD stamp allocated by NeroImportIsoTrackEx

NEROAPI_API void NADLL_ATTR NeroFreeCDStamp(void *pCDStamp);

// Create a file system container for the NERO_FILE_SYSTEM_CONTAINER_MEDIA compilation type

#ifdef __cplusplus
namespace FileSystemContent
{
	struct IFileSystemDescContainer;
};
#else //__cplusplus
struct IFileSystemDescContainer;
#endif//__cplusplus

NEROAPI_API 
#ifdef __cplusplus
FileSystemContent::
#else //__cplusplus
struct
#endif//__cplusplus
IFileSystemDescContainer *NADLL_ATTR NeroCreateFileSystemContainer(void *reserved);


/*
// Recording functions:
*/

typedef enum
{
	NERO_ET_FILE,			/* read/write to/from WAV file. */
	NERO_ET_IO_CALLBACK,	/* exchange data with application directly */
	NERO_ET_FILE_MP3,		/* read from MP3 file (not for DAE) */
	NERO_ET_FILE_WMA,		/* read from MS audio file (not for DAE) */
    NERO_ET_FILE_RAW,        /* for a Freestyle compilation,
					 * this and NERO_ET_IO_CALLBACK
					 * are the only types allowed
					 * at the moment.
					 * It will expect files 
					 * to be in the format
					 * as to be written to the disc.
					 * This exchange type is valid
					 * for freestyle compilations only */

	NERO_ET_AUDIO_FILE	/* NeroAPI > 5.5.9.8: audio file created with the plugin manager*/

} NERO_DATA_EXCHANGE_TYPE;

typedef void * NERO_AUDIO_ITEM_HANDLE;

typedef struct tagNERO_AUDIO_ITEM_INFO
{
	NERO_AUDIO_ITEM_HANDLE	naiiAudioItem;
	const char				*naiiFileName;
} NERO_AUDIO_ITEM_INFO;

/* use PCM, 44.1kHz, Stereo (left channel first), 16 bits per channel, LSB,
   when exchanging data with the NeroAPI */
typedef	struct tag_NERO_DATA_EXCHANGE
{
	NERO_DATA_EXCHANGE_TYPE ndeType;
	union
	{
		char			ndeFileName[256];      // Deprecated, use ndeLongFileName.ptr instead
		struct
		{
			DWORD	reserved;				   /* must be 0	*/
			const char 	*ptr;				   
		} ndeLongFileName;
		NERO_IO			ndeIO;                 // NERO_IO/EOF/ERROR_CALLBACK

		NERO_AUDIO_ITEM_INFO	ndeAudioItemInfo; // NeroAPI > 5.5.9.8
	} ndeData;
} NERO_DATA_EXCHANGE;
		
typedef struct tag_NERO_AUDIO_TRACK
{
	DWORD natPauseInBlksBeforeThisTrack;
	DWORD natNumIndexPositions;
	/* NOTE: values of index positions has to be given in bytes,
	 * whereby the values have to be a multiple of 2352
	 */
	DWORD natRelativeIndexBlkPositions[98];  /* offsets between one index position and the next one */
	const char *natTitle, *natArtist;        /* set to NULL if unknown or to be taken from source */
	NERO_DATA_EXCHANGE natSourceDataExchg;
	DWORD natLengthInBlocks;                 /* only used for NERO_IO_CALLBACK */
	BOOL  natIndex0ContainsData;			 /* NeroAPI 5.5.9.8: TRUE, if audio data shall be written into index 
												0. Data for index 0 must be provided. */
	DWORD natReserved[31];                   /* Should be zero */
} NERO_AUDIO_TRACK;

typedef enum
{
   NERO_TRACKMODE_MODE1,         /* 2048 Bytes per sector data track */
   NERO_TRACKMODE_MODE2_FORM1,   /* 2048 Bytes per sector, used for multisession */
   NERO_TRACKMODE_AUDIO          /* 2352 Bytes per sector, standard audio track */
} NERO_TRACKMODE_TYPE;
   
typedef struct tag_NERO_FREESTYLE_TRACK
{
    DWORD nftStructureSize;                     /* size of this structure, to ensure binary compatibility */
	DWORD nftPauseInBlksBeforeThisTrack;
	DWORD nftNumIndexPositions;
	DWORD nftRelativeIndexBlkPositions[98];  /* offsets between one index position and the next one */
	const char *nftTitle, *nftArtist;        /* set to NULL if unknown or to be taken from source */
	NERO_DATA_EXCHANGE nftSourceDataExchg;   /* source for raw track data */
	DWORD nftLengthInBlocks;                 /* only used for NERO_IO_CALLBACK */
    NERO_TRACKMODE_TYPE nftTracktype;           /* specifies track type to be written */
} NERO_FREESTYLE_TRACK;
      
typedef enum
{
	NERO_MPEG_ITEM,
	NERO_JPEG_ITEM,
	NERO_NONENCODED_VIDEO_ITEM,	// The source file name will be an AVI file which will be encoded into MPG by NeroAPI
} NERO_VIDEO_ITEM_TYPE;

typedef struct tag_NERO_VIDEO_ITEM
{
	DWORD nviPauseAfterItem;			// value is number of blocks (75 blocks = 1 second)
	char nviSourceFileName[250];		// Deprecated, use nviLongSourceFileName instead
	const char *nviLongSourceFileName;	// MPG, JPG or AVI file
	NERO_VIDEO_ITEM_TYPE nviItemType;
} NERO_VIDEO_ITEM;

typedef enum
{
	NERO_ISO_AUDIO_MEDIA			=0,	// Burn either a CD or a DVD, depending on the nwcdMediaType member
	NERO_VIDEO_CD					=1,
	NERO_BURN_IMAGE_MEDIA			=2,	// Burn either a CD or a DVD from an image
    NERO_FREESTYLE_CD				=3,
	NERO_FILE_SYSTEM_CONTAINER_MEDIA=4,	// Burn an IFileSystemDescContainer (see NeroFileSystemContainer.h) 

	// For compatibility
	NERO_ISO_AUDIO_CD				=0,
	NERO_BURN_IMAGE_CD				=2
} NERO_CD_FORMAT;

typedef struct tag_NERO_WRITE_CD
{
	/* both may be NULL: */
	const char *nwcdArtist;
	const char *nwcdTitle;

	struct CNeroIsoTrack *nwcdIsoTrack;      /* if not NULL, then the disc will have an ISO track - please refer to "NeroIsoTrack.h" */
	BOOL nwcdCDExtra;                        /* if TRUE and nwcdIsoTrack not NULL, then the resulting CD will have audio in the first session
											    and the data track in the second, however, currently the NeroAPI does not add any of the
												special CD Extra files to the data track */
	void *nwcdpCDStamp;						// Point on a CDStamp object if a particular CD is requested, otherwise NULL
	DWORD nwcdNumTracks;

	NERO_MEDIA_TYPE	nwcdMediaType;			/* Media on which the data should be written */
	DWORD nwcdReserved[32];					/* Should be zero */

	NERO_AUDIO_TRACK nwcdTracks[1];
} NERO_WRITE_CD;

#ifdef __cplusplus
namespace VCDEngine
{
	struct IVCDFSContentGenerator;
	struct IVCDMediaDescription;
};
#endif


typedef enum
{
	NERO_VIDEO_RESOLUTION_PAL = 0,
	NERO_VIDEO_RESOLUTION_NTSC = 1
} NERO_VIDEO_RESOLUTION;


typedef struct tag_NERO_WRITE_VIDEO_CD
{
	BOOL nwvcdSVCD;							// If TRUE, write a SVCD
	DWORD nwvcdNumItems;
	struct CNeroIsoTrack *nwvcdIsoTrack;
	char nwvcdTempPath[252];				/* Deprecated, use nwvcdLongTempPath instead */
	const char *nwvcdLongTempPath;			/* NeroAPI>=5.5.5.3: where the encoded files will be temporary stored */
#ifdef __cplusplus							/* NeroAPI>=5.5.7.6 */
	VCDEngine::IVCDFSContentGenerator *(*nwvcdCustomVCDEngine)(VCDEngine::IVCDMediaDescription *desc,FileSystemContent::IFileSystemDescContainer *pFSDC);
#else
	void *nwvcdCustomVCDEngine;
#endif
	NERO_VIDEO_RESOLUTION nwvcdEncodingResolution; /* NeroAPI >= 6.0.0.17: select the encoding resolution for the video. 
                                                    * This option only has effects for video items of type NERO_NONENCODED_VIDEO_ITEM. */
	DWORD nwvcdReserved[31];				/* Should be zero */
	NERO_VIDEO_ITEM nwvcdItems[1];
} NERO_WRITE_VIDEO_CD;

typedef struct tag_NERO_WRITE_IMAGE
{
	char nwiImageFileName[252];				/* Deprecated, use nwiLongImageFileName instead */
	const char *nwiLongImageFileName;		/* Name of the NRG file to burn
											   ISO and CUE files can also be burnt this way */
	NERO_MEDIA_TYPE	nwiMediaType;			/* NeroAPI >= 6.3.0.6: Media on which the image should be written. If set to MEDIA_NONE the default media type of the image will be used. */
	DWORD nwiReserved[32];
} NERO_WRITE_IMAGE;

/* This structure will allow you to write any type of 
 * CD Layout, e.g. containing a raw data track at the beginning of the
 * disc instead of a self-made ISO/UDF filesystem.
 * This is good for writing .iso images as they can be downloaded everywhere
 * on the net */
typedef struct tag_NERO_WRITE_FREESTYLE_CD
{
    DWORD nwfcdStructureSize;                   /* fill this with sizeof(NERO_FREESTYLEWRITE_CD) */
	/* both may be NULL: */
	const char *nwfcdArtist;
	const char *nwfcdTitle;

	struct CNeroIsoTrack *nwfcdIsoTrack;		/* if not NULL, then the disc will have an ISO track - please refer to "NeroIsoTrack.h" */
	BOOL nwfcdCDExtra;							/* if TRUE and nwfcdIsoTrack not NULL, then the resulting CD will have audio in the first session
											       and the data track in the second, however, currently the NeroAPI does not add any of the
												   special CD Extra files to the data track */
	void *nwfcdpCDStamp;						/* Point on a CDStamp object if a particular CD is requested, otherwise NULL */
	
	DWORD nwfcdNumTracks;

	DWORD nwfcdBurnOptions;						/* NeroAPI>=5.5.9.1: Combination of NCITEF flags (ignored if nwfcdFSContainer is NULL) */
#ifdef __cplusplus
FileSystemContent::
#else //__cplusplus
struct
#endif//__cplusplus
    IFileSystemDescContainer *nwfcdFSContainer;	/* NeroAPI>=5.5.9.1: if not NULL, then the disc will have an ISO track described by 
												   this container. nwfcdIsoTrack must be NULL, otherwise the container will be ignored */
	NERO_MEDIA_TYPE	nwfcdMediaType;				/* NeroAPI >=5.5.9.1: Media on which the data should be written */
	DWORD nwfcdReserved[32];					/* Should be zero */

	NERO_FREESTYLE_TRACK nwfcdTracks[1];
} NERO_WRITE_FREESTYLE_CD;


// To burn an IFileSystemDescContainer object

typedef struct tag_NERO_WRITE_FILE_SYSTEM_CONTAINER
{
	DWORD nwfscSize;						/* fill this with sizeof(NERO_WRITE_FILE_SYSTEM_CONTENT) */
#ifdef __cplusplus
FileSystemContent::
#else //__cplusplus
struct
#endif//__cplusplus
    IFileSystemDescContainer *nwfscFSContainer;
	NERO_MEDIA_TYPE	nwfscMediaType;			/* Media on which the data should be written */
	DWORD nwfscBurnOptions;					/* Combination of NCITEF flags */
	DWORD nwfscReserved[32];				/* Should be zero */
} NERO_WRITE_FILE_SYSTEM_CONTENT;
	
typedef enum
{
	NEROAPI_BURN_OK=0,
	NEROAPI_BURN_UNKNOWN_CD_FORMAT,
	NEROAPI_BURN_INVALID_DRIVE,
	NEROAPI_BURN_FAILED,
	NEROAPI_BURN_FUNCTION_NOT_ALLOWED,
	NEROAPI_BURN_DRIVE_NOT_ALLOWED,
	NEROAPI_BURN_USER_ABORT,
	NEROAPI_BURN_BAD_MESSAGE_FILE		// message file invalid or missing
} NEROAPI_BURN_ERROR;

NEROAPI_API
NEROAPI_BURN_ERROR NADLL_ATTR NeroBurn(NERO_DEVICEHANDLE    aDeviceHandle,
			 NERO_CD_FORMAT		  CDFormat,
             const void*		  pWriteCD, // Must point on a NERO_WRITE_CD or a NERO_WRITE_VIDEO_CD structure
 			 DWORD                dwFlags,
             DWORD                dwSpeed,  // In KB/s if NBF_SPEED_IN_KBS is present, in multiple of 150 KB/s otherwise
             NERO_PROGRESS*       pNeroProgress);
/* NeroBurn() flags: */
#define NBF_SPEED_TEST				(1<<0)  /* test speed of source first */
#define NBF_SIMULATE				(1<<1)  /* simulate writing before actually writing */
#define NBF_WRITE					(1<<2)  /* really write at the end */
#define NBF_DAO						(1<<3)  /* write in DAO */
#define NBF_CLOSE_SESSION			(1<<4)  /* only close the session and not the whole disc */
#define NBF_CD_TEXT					(1<<5)  /* write CD text - will be ignore if not supported by drive */
#define NBF_BUF_UNDERRUN_PROT		(1<<6)	/* enable saver burn mode  */
#define NBF_DISABLE_ABORT			(1<<7)  /* The disable abort callback will be called */
#define NBF_DETECT_NON_EMPTY_CDRW	(1<<8)	/* The DLG_NON_EMPTY_CDRW user callback will be called when trying to burn onto a non empty CDRW */
#define NBF_DISABLE_EJECT			(1<<9)	/* CD will not be ejected at the end of the burn process */
#define NBF_VERIFY                  (1<<10) /* Verify Filesystem after writing. Works for ISO only */
#define NBF_SPEED_IN_KBS			(1<<11)	/* NeroAPI>=5.5.5.5: Interpret the dwSpeed as KB/s instead of multiple of 150 KB/s */
#define NBF_DVDP_BURN_30MM_AT_LEAST	(1<<12)	/* NeroAPI>=5.5.8.0: DVD+R/RW high compability mode (at least 1GB will be written) */
#define NBF_CD_TEXT_IS_JAPANESE		(1<<13) /* NeroApi>=5.5.9.17: If NBF_CD_TEXT and NBF_CD_TEXT_IS_JAPANESE are set, then the CD Text is treated as japanese CD Text */
#define NBF_BOOKTYPE_DVDROM         (1<<14) /* NeroAPI>5.5.10.7: If NBF_BOOKTYPE_DVDROM the booktype of a burned DVD will be set to DVD-ROM */
#define NBF_NO_BOOKTYPE_CHANGE		(1<<15) /* NeroAPI>=6.0.0.24: Don't change the booktype of DVD, even if the default setting of NeroAPI is to change the booktype to DVD-ROM*/
#define NBF_RESERVED2				(1<<30) /* Reserved */
#define NBF_RESERVED				(1<<31) /* Reserved */


typedef struct tag_NERO_FILESYSTEMTRACK_OPTIONS
{
    DWORD				netsStructureSize;		/* fill this with sizeof(NERO_FILESYSTEMTRACK_OPTIONS) */

	/*
     * The following three entries need to be filled out whenever the file system size is to be calculated
	 * accurately.
	 */

	void *				netspCDStamp;			/* Point on a CDStamp object when appending to an existing medium, otherwise NULL */	
	NERO_MEDIA_TYPE		netsMediaType;			/* The media type the file system is to be written to */
	NERO_DEVICEHANDLE	netsDeviceHandle;		/* device handle representing the drive the file system is to be written to */
	DWORD				netsFlags;				/* NBF_XXXX that will be used for the recording process */
#ifdef __cplusplus
FileSystemContent::
#else //__cplusplus
struct
#endif//__cplusplus
    IFileSystemDescContainer *netsFSContainer;	/* if not NULL, the file system will be created from this 
												 * object instead of the passed CNeroIsoTrack object. pIsoTrack must be NULL in this case */
	DWORD				netsFSContainerFlags;	/* NCITEF_XXXX flags to be used for filesystem creation. Used only when netsFSContainer 
												 * is used to create the file system */
	DWORD netsReserved[32];						/* Should be zero */
} NERO_FILESYSTEMTRACK_OPTIONS;



/* NeroAPI >= 6.0.0.14: Estimate the total size of a track including data and overhead
 * for the filesystem. The method returns the size in blocks.
 * Use the flags below to specify what exactly has to be taken into account for the
 * calculation.
 *
 * Warning: Depending on the parameters passed, the returned size might only be an estimation!
 */
NEROAPI_API unsigned int NADLL_ATTR NeroEstimateTrackSize(struct CNeroIsoTrack *pIsoTrack // the iso track for which to calculate the size
															   , DWORD dwFlags // combination of the flags below
															   , NERO_FILESYSTEMTRACK_OPTIONS *pOptions);

#define NETS_FILESYSTEM_OVERHEAD	(1<<0) /* calculate filesystem overhead */
#define NETS_DATA					(1<<1) /* calculate size of the data */
#define NETS_EXACT_SIZE				(1<<2) /* Nero >= 6.0.0.21 calculate exactly. 
											* If this option is specified, filesystem overhead as well as file data is taken into account 
											* the optional fields of the NERO_ESTIMATETRACKSIZE_OPTIONS structure need to be filled out */

/*
// Digital Audio Extraction functions:
// - aborting will not be reported by NeroGetLastError()
// - incomplete target files are not deleted
// - the function will return 0 for success, else error
*/

NEROAPI_API
int NADLL_ATTR NeroDAE(NERO_DEVICEHANDLE aDeviceHandle,
			DWORD             dwTrackStartBlk,
			DWORD             dwTrackLengthInBlks,
            const NERO_DATA_EXCHANGE *pDestDataExchg,
            DWORD             iSpeedInX,				// speed of extraction, 0 means maximum speed
            NERO_CALLBACK*    pNeroProgressCallback); /* has to be a NERO_PROGRESS_CALLBACK */


//
// Utility functions:
//
NEROAPI_API int NADLL_ATTR NeroIsDeviceReady(NERO_DEVICEHANDLE aDeviceHandle); // returns a value of NERO_DRIVE_ERROR
NEROAPI_API int NADLL_ATTR NeroEjectLoadCD(NERO_DEVICEHANDLE aDeviceHandle,BOOL eject);	// returns a value of NERO_DRIVE_ERROR

// NeroAPI >= 6.0.0.25:
// Set the image file for the image recorder. This can be used to initialize
// the image recorder for packet writing.
// If imageFilePath is NULL, the last opened file is closed.
NEROAPI_API int NADLL_ATTR NeroInitImageRecorder(NERO_DEVICEHANDLE aDeviceHandle, const char *imageFilePath, DWORD dwFlags, NERO_MEDIA_TYPE mediaType, void *reserved);


// NeroAPI>=5.5.9.10: Get localized WAIT_CD text
//	Returned string must be released using NeroFreeMem()
//	Function may return NULL if type is out of range
NEROAPI_API char * NADLL_ATTR NeroGetLocalizedWaitCDTexts (NERO_WAITCD_TYPE type);

	
// NeroAPI >= 6.0.0.25: Use the nstUserDialog callback functions to request a CD
// Returns FALSE if the burn process should be aborted
NEROAPI_API BOOL NADLL_ATTR NeroWaitForDisc(NERO_DEVICEHANDLE aDeviceHandle
											 ,NERO_MEDIA_SET nmt	// media types requested
											 ,DWORD dwBurnFlags		// Set of NBF_ flags
											 ,void *pCDStamp		// Optional stamp of requested media
											 ,DWORD dwFlags			// Set of NWFD_ flags
											 ,void *reserved);	    // must be NULL
#define NWFD_REQUIRE_EMPTY_DISC (1<<0)


// CDRW erasing functions

typedef enum 
{
	NEROAPI_ERASE_ENTIRE	=0,
	NEROAPI_ERASE_QUICK		=1,
} NEROAPI_CDRW_ERASE_MODE;


NEROAPI_API int NADLL_ATTR NeroGetCDRWErasingTime(NERO_DEVICEHANDLE aDeviceHandle,NEROAPI_CDRW_ERASE_MODE mode);
					// Returns estimated blanking time for loaded CD-RW in seconds, 
					// -1 if no CD inserted, 
					// -2 if recorder doesn't support CDRW
					// -3 if the inserted media is not rewritable

// Erase the disc inserted in the given recorder
NEROAPI_API int NADLL_ATTR NeroEraseDisc(NERO_DEVICEHANDLE aDeviceHandle,NEROAPI_CDRW_ERASE_MODE mode
										 ,DWORD dwFlags,void *reserved);
#define NEDF_DISABLE_EJECT			(1<<0)	/* NeroAPI>=6.0.0.0: CD will not be ejected at the end of the 
												erasing, even if this is recommanded for the selected recorder*/
#define NEDF_EJECT_AFTER_ERASE		(1<<1)  /* NeroAPI > 6.0.0.0: eject disc after erasing, no matter if this is 
											   recommended for the recorder or not */



typedef enum
{
   NDR_DRIVE_IN_USE=0,
   NDR_DRIVE_NOT_IN_USE,
   NDR_DISC_REMOVED,
   NDR_DISC_INSERTED,
   NDR_DRIVE_REMOVED,
   NDR_DRIVE_ADDED
} NERO_DRIVESTATUS_RESULT;

/* 
// callback that is called to tell the application about a status change of a drive 
// hostID corresponds to the nsdiHostAdapterNo and targetID corresponds 
// to the nsdiDeviceID of NERO_SCSI_DEVICE_INFO
// Note: The callback need to be thread safe, since it might be called from a different thread
*/
typedef void  (NERO_CALLBACK_ATTR *NERO_DRIVESTATUS_CALLBACK)(int hostID, int targetID, NERO_DRIVESTATUS_RESULT result, void *pUserData);

typedef enum
{
   // the disc in the drive has been changed
   // Warning: This change notification is based on Windows notifying about
   // medium changes. If an application has disabled this notification, the
   // callback will not be called. If you want to be sure to recognize all 
   // medium changes, you should use timer events and use NeroIsDeviceReady
   // to ask for the drive status.
   NDT_DISC_CHANGE, 
   NDT_IN_USE_CHANGE  // the in-use status of the drive has been changed
} NERO_DRIVESTATUS_TYPE;

/* NeroAPI >= 6.0.0.0: 
// Register a callback which is called whenever the specified status
// of a drive is changed.
//
// Please see documentation of NERO_DRIVE_STATUS_TYPE for restrictions of the
// notifications.
//
//
// Parameters:
// status: the status the application is interested in
// pDeviceInfo: the drive for which the status change should be notified.
//              The pointer can be freed afterwards.
// callback: the callback to be called if the status changed. 
// Note: The callback need to be thread safe, since it might be called from a different thread
// pUserData: data passed to the callback
//
// returns 0 on success
*/
NEROAPI_API int NADLL_ATTR NeroRegisterDriveStatusCallback(NERO_DRIVESTATUS_TYPE status 
													 , const NERO_SCSI_DEVICE_INFO *pDeviceInfo  
													 , NERO_DRIVESTATUS_CALLBACK callback 
													 , void *pUserData);

/* NeroAPI >= 6.0.0.0: 
// Unregister a callback
//
// Parameters:
// status: the status for which the callback has been registered
// pDeviceInfo: the drive for which the status was notified
//              The pointer does not need to be the same as in
//              NeroRegisterDrivestatusCallback, but has to represent
//              the same drive.
// callback: the callback to be called if the status changed.
// pUserData: data passed to the callback
//
// returns 0 on success
*/
NEROAPI_API int NADLL_ATTR NeroUnregisterDriveStatusCallback(NERO_DRIVESTATUS_TYPE status // the status the application is interested in
													 , const NERO_SCSI_DEVICE_INFO *pDeviceInfo  // the drive for which the status should be acknowledged
													 , NERO_DRIVESTATUS_CALLBACK callback // the callback to be called if the status changed
													 , void *pUserData); // data passed to the callback

/*
// NeroAPI >= 6.0.0.0:
// Register a callback which is called whenever a drive was removed or added in the system
// Use NeroGetAvailableDrivesEx to get the current list of drives in the system.
//
// NOTE: In some rare cases NeroAPI does not get this information from the OS and will therefore
//       never notify the callback if a drive has been added/removed.
//
// Parameters:
// callback: the callback to be called when a drive is removed or added
//    Note: The callback need to be thread safe, since it might be called from a different thread
// pUserData: data passed to the callback
//
// returns 0 on success
*/
NEROAPI_API int NADLL_ATTR NeroRegisterDriveChangeCallback( NERO_DRIVESTATUS_CALLBACK callback
													 , void *pUserData);

/*
// NeroAPI >= 6.0.0.0:
// Unregister a callback which was registered with NeroRegisterDriveChangeCallback
//
// Parameters:
// callback: the callback to be called when a drive is removed or added
// pUserData: data passed to the callback
//
// returns 0 on success
*/
NEROAPI_API int NADLL_ATTR NeroUnregisterDriveChangeCallback(NERO_DRIVESTATUS_CALLBACK callback
													 , void *pUserData); 


// NeroAPI > 5.5.9.8: AUDIO SUPPORT


// NERO_CONFIG_RESULT

typedef enum
{
	NCR_CANNOT_CONFIGURE,
	NCR_CHANGED,
	NCR_NOT_CHANGED
} NERO_CONFIG_RESULT;

////////////////////////////////////////////////////// NERO_AUDIO_FORMAT_INFO //

typedef struct tagNERO_AUDIO_FORMAT_INFO
{
// Data
	// smth. like "RIFF PCM WAV format"
	char	nafiDescription[256],

	// smth. like "wav,wave,riff"
			nafiExtList[256];

	BOOL	nafiTgt,				// Contains TRUE if this is a target plugin
			nafiConfigurable;	// ConfigureItem will fail on items of
								// this type if this member == false
}
	NERO_AUDIO_FORMAT_INFO;

//////////////////////////////////////////////////////////// Helper functions //

NEROAPI_API NERO_AUDIO_ITEM_HANDLE	NeroAudioCreateTargetItem(int iFormatNumber);

NEROAPI_API BOOL				NeroAudioCloseItem(NERO_AUDIO_ITEM_HANDLE hItem);

// Insead of hItem a value of NULL can be passed to configure the
// whole plugin manager.
NEROAPI_API NERO_CONFIG_RESULT	NeroAudioGUIConfigureItem		\
									(NERO_AUDIO_ITEM_HANDLE *phItem, int iNum);

// As soon as it returns false, it means that there are no more formats.
NEROAPI_API BOOL				NeroAudioGetFormatInfo			\
									(int iNum, NERO_AUDIO_FORMAT_INFO *pFI);

//
// Deprecated functions. Present for compatibility with previous versions
//

NEROAPI_API DWORD NADLL_ATTR NeroGetAPIVersion(void);  /* Returns 1000 for 1.0.0.0 */

NEROAPI_API BOOL NADLL_ATTR NeroSetExpectedAPIVersion(DWORD);

NEROAPI_API NERO_ISO_ITEM *NeroImportIsoTrackEx(NERO_DEVICEHANDLE pRecorder,
						     DWORD trackNumber,
						     void **ppCDStamp,
						     DWORD flags);

NEROAPI_API int NADLL_ATTR NeroEraseCDRW(NERO_DEVICEHANDLE aDeviceHandle,NEROAPI_CDRW_ERASE_MODE mode);			// Erase the loaded CD


// NeroAPI>=5.5.9.4: Use the nstUserDialog callback functions to request a CD
// Returns FALSE if the burn process should be aborted
NEROAPI_API BOOL NADLL_ATTR NeroWaitForMedia(NERO_DEVICEHANDLE aDeviceHandle
											 ,NERO_MEDIA_SET nms			// media types requested
											 ,DWORD dwFlags					// Set of NBF_ flags
											 ,void *pCDStamp);				// Optional stamp of requested media



#ifdef __cplusplus
}
#endif

#if defined(__BORLANDC__)
#pragma pack(pop)
#pragma option pop 
#endif

#endif  // _NEROAPI_

//======================================================
// NeroApi.h
//======================================================


