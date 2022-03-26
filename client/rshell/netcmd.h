
#ifndef __NETCMD_H__
#define __NETCMD_H__


static const unsigned NETPORT = 13228;  //our port

// net guids
enum {
NETGUID_INVALID                 = 0xFFFFFFFF,
NETGUID_UNKNOWN                 = 0xFFFFFFFF,
NETGUID_LOOPBACK                = 0xFFFFFFFE,
NETGUID_ALL_WITHME              = 0xFFFFFFFD,
NETGUID_ALL_WITHOUTME           = 0xFFFFFFFC,
NETGUID_SERVER                  = 0xFFFFFFFB,
NETGUID_ALL_OPERATORS_WITHME    = 0xFFFFFFFA,
NETGUID_ALL_OPERATORS_WITHOUTME = 0xFFFFFFF9,
NETGUID_ALL_COMPUTERS_WITHME    = 0xFFFFFFF8,
NETGUID_ALL_COMPUTERS_WITHOUTME = 0xFFFFFFF7,
NETGUID_ALL_USERS_WITHME        = 0xFFFFFFF6,
NETGUID_ALL_USERS_WITHOUTME     = 0xFFFFFFF5,
NETGUID_FIRST_OPERATOR          = 0xFFFFFFF4,
NETGUID_LAST                    = 0x7FFFFFFE,
NETGUID_FIRST                   = 0x00000000,
};


// classes (do not change names, used in some delphi dll(s)!)
#define NETCLASS_SERVER       "Server"
#define NETCLASS_USER         "User"
#define NETCLASS_COMPUTER     "Computer"
#define NETCLASS_OPERATOR     "Operator"


// net cmds
enum {
NETCMD_UNKNOWN              = 0x00000000,
NETCMD_INVALID              = 0x00000000,
NETCMD_REBOOT               = 0xAD130000,
NETCMD_SHUTDOWN             = 0xAD130001,
NETCMD_LOGOFF               = 0xAD130002,
NETCMD_OFFSHELL             = 0xAD130003,
NETCMD_ONSHELL              = 0xAD130004,
NETCMD_KILLALLTASKS         = 0xAD130005,
NETCMD_VMODERESTORE         = 0xAD130006,
NETCMD_BLOCKMACHINE         = 0xAD130007,
NETCMD_UNBLOCKMACHINE       = 0xAD130008,
NETCMD_MONITOROFF           = 0xAD130009,
NETCMD_MONITORON            = 0xAD13000A,
NETCMD_TEXTMESSAGE          = 0xAD13000B,
NETCMD_LICMAN_REQ           = 0xAD13000C,
NETCMD_LICMAN_ACK           = 0xAD13000D,
NETCMD_BODYVIP_REQ          = 0xAD13000E,
NETCMD_BODYVIP_ACK          = 0xAD13000F,
NETCMD_SCREEN_REQ           = 0xAD130010,
NETCMD_SCREEN_ACK           = 0xAD130011,
NETCMD_WEBCAM_REQ           = 0xAD130012,
NETCMD_WEBCAM_ACK           = 0xAD130013,
NETCMD_SCREENCONTROL_REQ    = 0xAD130014,
NETCMD_SCREENCONTROL_ACK    = 0xAD130015,
NETCMD_VIDEOCONTROL_REQ     = 0xAD130016,
NETCMD_VIDEOCONTROL_ACK     = 0xAD130017,
NETCMD_VIDEOCONTROLFINISH   = 0xAD130018,
NETCMD_SOMEINFO_REQ         = 0xAD130019,
NETCMD_SOMEINFO_ACK         = 0xAD13001A,
NETCMD_EXECSTAT_REQ         = 0xAD13001B,
NETCMD_EXECSTAT_ACK         = 0xAD13001C,
NETCMD_EXECSTATCLEAR        = 0xAD13001D,
NETCMD_SQLTEST_REQ          = 0xAD13001E,
NETCMD_SQLTEST_ACK          = 0xAD13001F,
NETCMD_NETRUN               = 0xAD130020,
NETCMD_COPYFILES            = 0xAD130021,
NETCMD_DELETEFILES          = 0xAD130022,
NETCMD_TIMESYNC             = 0xAD130023,
NETCMD_ADDSERVICESTR2BASE   = 0xAD130024,
NETCMD_ADDEVENTSTR2BASE     = 0xAD130025,
NETCMD_ADDUSERRESPONSE2BASE = 0xAD130026,
NETCMD_CALLOPERATOR_REQ     = 0xAD130027,
NETCMD_CALLOPERATOR_ACK     = 0xAD130028,
NETCMD_UPDATESELFENV        = 0xAD130029,
NETCMD_GETENV_REQ           = 0xAD13002A,
NETCMD_GETENV_ACK           = 0xAD13002B,
NETCMD_NETBURN_REQ          = 0xAD13002C,
NETCMD_NETBURN_ACK          = 0xAD13002D,
NETCMD_NETBT_REQ            = 0xAD13002E,
NETCMD_NETBT_ACK            = 0xAD13002F,
NETCMD_GETSETTINGS_REQ      = 0xAD130030,
NETCMD_GETSETTINGS_OK_ACK   = 0xAD130031,
NETCMD_GETSETTINGS_ERR_ACK  = 0xAD130032,
NETCMD_OFFAUTOLOGON         = 0xAD130033,
NETCMD_ONAUTOLOGON          = 0xAD130034,
NETCMD_POLLSERVER           = 0xAD130035,
NETCMD_GETALLENV_REQ        = 0xAD130036,
NETCMD_GETALLENV_ACK        = 0xAD130037,
NETCMD_WOL                  = 0xAD130038,
NETCMD_CLIENTUPDATELIST_REQ = 0xAD130039,
NETCMD_CLIENTUPDATELIST_ACK = 0xAD13003A,
NETCMD_CLIENTUPDATEFILES_REQ = 0xAD13003B,
NETCMD_CLIENTUPDATEFILES_ACK = 0xAD13003C,
NETCMD_CLIENTUPDATEPROPOSITION = 0xAD13003D,
NETCMD_HIBERNATE            = 0xAD13003E,
NETCMD_SUSPEND              = 0xAD13003F,
NETCMD_ROLLBACKINFO_REQ     = 0xAD130040,
NETCMD_ROLLBACKINFO_ACK     = 0xAD130041,
NETCMD_RLBSAVE1             = 0xAD130042,
NETCMD_RLBSAVE2             = 0xAD130043,
NETCMD_CLIENTUPDATENOSHELLLIST_REQ = 0xAD130044,
NETCMD_CLIENTUPDATENOSHELLLIST_ACK = 0xAD130045,
NETCMD_CLIENTUPDATENOSHELLFILES_REQ = 0xAD130046,
NETCMD_CLIENTUPDATENOSHELLFILES_ACK = 0xAD130047,
NETCMD_CLIENTUNINSTALL = 0xAD130048,
NETCMD_TEMPOFFSHELL = 0xAD130049,
NETCMD_CLASSNAMENOTUPDATED_ACK  = 0xAD13004A,
NETCMD_FLOATLIC2SERVER_REQ = 0xAD13004B,
NETCMD_FLOATLIC2SERVER_ACK = 0xAD13004C,
NETCMD_FLOATLIC2CLIENT_REQ = 0xAD13004D,
NETCMD_FLOATLIC2CLIENT_ACK = 0xAD13004E,

};


// error codes
enum {
NETERR_VIP_NOERROR = 0,
NETERR_VIP_NORESULT = -1,
NETERR_VIP_WRONGLOGIN = -3,
NETERR_VIP_ALREADYEXIST = -4,
NETERR_VIP_UNKNOWN = -5,
NETERR_VIP_NEWSERVER = -6,
NETERR_SETTINGS_DBNOTREADY = -1,
NETERR_SETTINGS_OUTOFLICENSE = -2,
NETERR_SETTINGS_OTHER = -3,

};


// parms defines for commands
#define NETPARM_B_FORCE           "bForce"
#define NETPARM_B_ALLUSERS        "bAllUsers"
#define NETPARM_I_DELAY           "iDelay"
#define NETPARM_S_TEXT            "sText"
#define NETPARM_S_FILENAME        "sFileName"
#define NETPARM_S_CMDLINE         "sCmdline"
#define NETPARM_B_KILLTASKS       "bKillTasks"
#define NETPARM_S_FROM            "sFrom"
#define NETPARM_S_TO              "sTo"
#define NETPARM_I_ID              "iId"
#define NETPARM_I_COUNT           "iCount"
#define NETPARM_I_SIZE            "iSize"
#define NETPARM_I_TIME            "iTime"
#define NETPARM_S_COMMENTS        "sComments"
#define NETPARM_I_LEVEL           "iLevel"
#define NETPARM_B_MONITORSTATE    "bMonitorState"
#define NETPARM_B_BLOCKEDSTATE    "bBlockedState"
#define NETPARM_S_ACTIVETASK      "sActiveTask"
#define NETPARM_S_VIPSESSION      "sVipSession"
#define NETPARM_S_CLASS           "sClass"
#define NETPARM_S_MACHINELOC      "sMachineLoc"
#define NETPARM_S_MACHINEDESC     "sMachineDesc"
#define NETPARM_S_COMPNAME        "sCompName"
#define NETPARM_S_DOMAIN          "sDomain"
#define NETPARM_S_USERNAME        "sUserName"
#define NETPARM_S_PASSWORD        "sPassword"
#define NETPARM_B_NEWUSER         "bNewUser"
#define NETPARM_S_PATH            "sPath"
#define NETPARM_I_RESULT          "iResult"
#define NETPARM_S_RESULT          "sResult"
#define NETPARM_S_PROCESSES       "sProcesses"
#define NETPARM_I_COPIES          "iCopies"
#define NETPARM_S_KIND            "sKind"
#define NETPARM_S_TITLE           "sTitle"
#define NETPARM_S_NAME            "sName"
#define NETPARM_S_AGE             "sAge"
#define NETPARM_B_MOBILECONTENT   "bMobileContent"
#define NETPARM_I_GUID            "iGUID"
#define NETPARM_S_LICORGANIZATION "sLicOrganization"  //this parm must be changed also in licgen.exe utility !
#define NETPARM_S_LICOWNER        "sLicOwner"         //this parm must be changed also in licgen.exe utility !
#define NETPARM_I_LICMACHINES     "iLicMachines"      //this parm must be changed also in licgen.exe utility !
#define NETPARM_S_LICFEATURES     "sLicFeatures"      //this parm must be changed also in licgen.exe utility !
#define NETPARM_I_LICNUMBER       "iLicNumber"        //this parm must be changed also in licgen.exe utility !
#define NETPARM_S_LICEXPDATE      "sLicExpDate"       //this parm must be changed also in licgen.exe utility !
#define NETPARM_S_VERSION         "sVersion"
#define NETPARM_I_YEAR            "iYear"
#define NETPARM_I_MONTH           "iMonth"
#define NETPARM_I_DAY             "iDay"
#define NETPARM_I_HOUR            "iHour"
#define NETPARM_I_MINUTE          "iMinute"
#define NETPARM_I_SECOND          "iSecond"
#define NETPARM_S_DISKSSPACE      "sDisksSpace"
#define NETPARM_S_CPUTEMP         "sCPUTemp"
#define NETPARM_S_GPUTEMP         "sGPUTemp"
#define NETPARM_S_MBMTEMP         "sMBMTemp"
#define NETPARM_S_CPUCOOLER       "sCPUCooler"
#define NETPARM_S_HWINFO          "sHWInfo"
#define NETPARM_S_COMPSETTINGS    "sCompSettings"
#define NETPARM_S_USERSETTINGS    "sUserSettings"
#define NETPARM_S_MAC             "sMAC"
#define NETPARM_S_IP              "sIP"
#define NETPARM_B_RFMSERVICE      "bRFMService"
#define NETPARM_B_RDSERVICE       "bRDService"
#define NETPARM_S_OURSERVICES     "sOurServices"
#define NETPARM_B_ISOPERATORSHELL "bIsOperatorShell"
#define NETPARM_I_LANGID          "iLangId"
#define NETPARM_I_ID_X            "iId_"
#define NETPARM_S_PATH_X          "sPath_"
#define NETPARM_S_CRC32_X         "sCRC32_"
#define NETPARM_B_IMMEDIATELY     "bImmediately"
#define NETPARM_B_ISROLLBACK      "bIsRollback"
#define NETPARM_S_RLBVERSION      "sRlbVersion"
#define NETPARM_S_RLBLICENSE      "sRlbLicense"
#define NETPARM_S_RLBDRVNOW       "sRlbDrvNow"
#define NETPARM_S_RLBDRVAFTER     "sRlbDrvAfter"
#define NETPARM_S_RLBRLBNOW       "sRlbRlbNow"
#define NETPARM_S_RLBRLBAFTER     "sRlbRlbAfter"
#define NETPARM_S_RLBDISKS        "sRlbDisks"
#define NETPARM_S_RLBPATHS        "sRlbPaths"
#define NETPARM_S_LIST            "sList"





class CNetCmd : public CDynBuff
{
  public:
          CNetCmd();
          CNetCmd(int cmd_id);
          ~CNetCmd();

          BOOL IsValid() const;
          int GetCmdId() const;
          const char* GetCmdBuffPtr() const;
          unsigned GetCmdBuffSize() const;

          const char* FindValueByName(const char *name) const;
          BOOL GetParmAsBool(const char *name,BOOL def=FALSE) const;
          int GetParmAsInt(const char *name,int def=0) const;
          const char* GetParmAsString(const char *name,const char *def="") const;

          void AddStringParm(const char *name,const char *value);
          void AddIntParm(const char *name,int value);
          void AddBoolParm(const char *name,BOOL value);
          
          operator const char* () const;
          operator const unsigned char* () const;
          operator const void* () const;
};



#endif

