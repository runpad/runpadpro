
#ifndef ___F3_H___
#define ___F3_H___

#include <vector>


class CLocalPath
{
           char s_path[MAX_PATH];
  public:
           CLocalPath(const char *local);
           ~CLocalPath() {}
           operator const char* () const { return s_path; }
           const char* Path() const { return s_path; }
};


typedef std::vector<char*> TStringList;


void GetDirFromPath(const char *path,char *dir);
char* GetLocalPath(const char *local,char *out);
void ClientRestore(void);
void CloseDisallowProcesses(void);
void CleanTempDir(void);
void CleanIEDir(void);
void CleanRecycleBin(void);
BOOL IsRunningInSafeModeWithCmdFromAnotherUser(void);
BOOL IsRemoteDesktopRunning(void);
BOOL IsGCInstalled(void);
BOOL IsBodyExplorerLoaded(void);
void ExecTool(const char *s,BOOL force32=FALSE);
void SetIEStartupSettings(void);
BOOL CheckUrlSite(const char *s);
BOOL IsThisURLMustBeRedirected(const char *url);
void InsertIntoCfgList1(TCFGLIST1& list,const char *value);
char** ConvertList2Ar(const char *list,int *_count,BOOL add_dot);
void FreeListAr(char **buff,int count);
BOOL IsProtoInList(const char *list,const char *url);
void InitAutorun(void);
void DoneAutorun(void);
void RunOurSSaver(void);
void RunOurBlocker(void);
void CloseOurBlocker(void);
ATOM OnGetCADMenu();
void OnCADMenuAction(int idx);
void SetSingleEnvVar(const char *name,const char *value,BOOL is_path=FALSE);
void DeleteSingleEnvVar(const char *name);
void DeleteAllEnvVars();
void SetShellEnvStrings(void);
void ClearShellEnvStrings(void);
void AddEventString2SQLBase(int id);
void CollectFlashDrivesInfo4Stat(void);
void FinishFlashDrives4Stat(void);
void OnFlashDriveInserted4Stat(int _drive);
void OnFlashDriveRemoved4Stat(int _drive);
void OnFlashDriveFormatted4Stat(int _drive);
void OnFlashDriveFilesDeleted4Stat(int _drive);
void OnFlashDriveFilesAdded4Stat(int _drive);
BOOL IsAnyOfInsertedFlashesHardwareIdFoundInList(const char *list);
BOOL MyTerminateProcess(int pid);
void PrepareTerminateProcessFunctionFromHack(void);
void TerminateGameGuardApp(HANDLE hProcess);
void KillGGIfPresent(BOOL wait);
BOOL IsGGApp(const char *s_exe);
void ProcessGGApp(const char *s_exe,HANDLE hProcess);
void KillAllTasks(void);
void InitPrinterThread(void);
void DonePrinterThread(void);
int IsCommandExtension(const char *ext);
int IsLinkExtension(const char *ext);
int RunAsAnotherUser(const CRealShortcut *rsh);
int RunAsThisUser(const CRealShortcut *rsh);
BOOL IsExtensionAllowedInternal(const char *path,const char *list);
BOOL ScanForDisallowedFileInDir(const char *dir,const char *exts,BOOL is_masks_allowed);
void ScheduleScanDisk(void);
void SetSpyProcess(int pid);
int IsProcessSpyed(void);
void CreateUserFolder(void);
void InsertVCD(const char *file,int num);
void SaveDisplayMode(void);
void RestoreOriginalDesktopGamma(void);
void RestoreDisplayMode(void);
IStream* GrabSingleWebCam();
IStream* GrabSeqWebCam();
void DisconnectWebCam();
void PollWebCam();
void CreateUrlFile(const char *url,char *out);
BOOL IsOurShellTurnedOnForCurrentUser();
BOOL TurnShellOffForCurrentUser();
BOOL IsOurShellTurnedOnForAllUsers();
BOOL TurnShellOffForAllUsers();
BOOL IsOurShellTurnedOn();
BOOL TurnShellOnFor(HKEY root);
void AddToAllowedFirewallProgramsList(const char *exe,const char *name);
void AddOurAppPath();
void RemoveOurAppPath();
void CloseHWWindow(void);
void ClearPrintSpooler();
void SpoolClear(void);
const char *GetDOWString(int dow);
void InitCameraCallback();
void DoneCameraCallback();
void InitHWIdents();
void DoneHWIdents();
BOOL GetHWIdentsEvent(CHWIdent::EHWIdentDevice *_device,char *id,int max_id_chars);
void InstallOurService();
void UninstallOurService();
void ASV2_ExecToolIfPresent();
void ASV2_WaitForData();
void ASV2_ForceUpdate();
void SetGlobalHook64(BOOL state);
void SetDialogsHook64(BOOL state);
void ShowCADDialog();
TStringList* CreateStringListFromMultiLineStringIgnoreEmptys(const char *_src,const char *undecorate_str,char terminator);
void FreeStringList(TStringList *list);



#endif


