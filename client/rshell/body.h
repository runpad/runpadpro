
#ifndef ___BODY_H___
#define ___BODY_H___


void EnableSheetsFromAPI(const char *name,BOOL b_enable);
void GlobalOnSheetsStateChanged();
void GlobalOnTimerFast(void);
void GlobalOnTimerSlow(void);
void GlobalOnTimerSuperFast(void);
void InjectFunctions(void);
void CheckIdles(void);
void TimeSheetsCheck(void);
BOOL CanExecuteBodyToolWithSQLIntegrationOn(BOOL silent,BOOL check_protect_flag);
void DoShutdownAction(BOOL force);
void M_Offersbook(void);
void M_Restore(void);
void M_Reboot(void); 
void M_Shutdown(void); 
void M_Monitoroff(void);
void InternalLogOff(BOOL force);
void M_Logoff(void); 
void M_Mycomp(void);
void M_Calladmin(void);
void M_Showgcinfo(void);
void CAD_TaskManager(void);
void CAD_KillAllTasks(void);
void CAD_GCInfo(void);
void CAD_Reboot(void);
void CAD_Shutdown(void);
void CAD_LogOff(void);
void CAD_MonitorOffTime(void);
void DisplayFolder(const char *_path);
void NetRun(const CNetCmd &cmd);
void OnBlockAction(void);
void OnUnblockAction(void);
void CheckRunProtectionAtStartup(void);
void CheckMonitorPowerAtStartup(void);
void WaitForFileServerReady(void);
void WaitForOurServiceReady(void);
void AutoRestoreDisplayModeAtStartup(void);
void MouseRestoreAtStartup(void);
int OnDeviceChange(HWND hwnd,int wParam,int lParam);
int GetCopyDeleteThreadsCount(void);
BOOL IsCopyDeleteThreadsSensitive(void);
void SetCopyDeleteThreadsCount(int count);
void SetCopyDeleteThreadsSensitivity(BOOL state);
void NetCopyFiles(const CNetCmd &cmd);
void NetDeleteFolders(const CNetCmd &cmd);
int ProcessRunpadInternalMessage(HWND hwnd,int message,int wParam,int lParam,BOOL *is_processed);
void CloseRulesWindow(void);
void ShowRulesWindow(const char *s);
BOOL IsExtensionAllowed(const char *path);
BOOL ExecutionMustBeProtectedBecauseClientNotLoaded(void);
void RunProgram(const CShortcut *p_shortcut,BOOL checkext,const CSheet *p_sheet,BOOL add2stat);
void SetSheetActiveByIdx(int idx, BOOL active);
void SetSheetActiveByName(const char *desname);
void SheetsSelectPopup();
const char* ExpandStatusText(const char *s);
BOOL IsLicenseWithMO();
BOOL IsLicenseWithShell();
void NetInit();
void NetDone();
int NetGetLastWinsockErrorNonRepresentative();
int NetGetServerIP();
BOOL IsNetConnectEvent();
BOOL NetIsConnected();
BOOL NetSend(const CNetCmd& cmd,unsigned dest_guid=NETGUID_SERVER);
BOOL NetGet(CNetCmd& cmd,unsigned *_src_guid=NULL);
BOOL NetFlush(unsigned timeout);
BOOL NetSendFile(const char *file,int cmd_id,unsigned dest_guid,BOOL b_delete);
BOOL NetSendStream(IStream *stream,int cmd_id,unsigned dest_guid);
BOOL NetSendResource(int res_id,int cmd_id,unsigned dest_guid);
void AddServiceString2SQLBase(int s_id,int s_count,int s_size,int s_time,const char *s_comments);
void AddEventString2SQLBaseInternal(int s_level,const char *s_comments);
void SendMessageToOperator(const char *msg,BOOL to_all);
void SendDynamicInfoToServer();
void SendStaticInfoToServer();
void NetUpdate();
void OnLicManAck(const CNetCmd &cmd,unsigned src_guid);
void OnLicManReq(const CNetCmd &cmd,unsigned src_guid);
BOOL ExecuteLicMan(const char *path);
void UpdateStatusTextString();
void ReadConfig();
void WriteConfig4BodyTools();
void ClearSettingsCacheForAllUsers();
void PollServer(void);
void ProcessLangAtStartup();
void ShowLAAtStartup(void);
void ShowLA(void);
void ProcessHWIdents();
void OnKBFastExit();
void FastExitDialog();
void FE_DoFastExit(BOOL silent,BOOL show_reminder);
void FE_DoOffShell(BOOL silent);
void FE_DoOffAutoLogon(BOOL silent);
void TurnShellOnDialogW();
void CheckTimeLimitations();
void ExecExplorerUmulator4LA2();
void PrepareSomeInfo(CNetCmd &cmd);
void OpenDefaultSheetAsync();


#endif


