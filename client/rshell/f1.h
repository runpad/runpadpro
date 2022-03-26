
#ifndef ___F1_H___
#define ___F1_H___



class CDisableWOW64FSRedirection
{
          void *old_value;
  
  public:
          CDisableWOW64FSRedirection();
          ~CDisableWOW64FSRedirection();
};


class CRegEmptySD
{
          HKEY m_root;
          char *s_key;
          void *p_old;
          BOOL b_use64;

  public:
          CRegEmptySD(HKEY root,const char *key,BOOL use64=FALSE);
          ~CRegEmptySD();
};


class CRegEmptySD64 : public CRegEmptySD
{
  public:
          CRegEmptySD64(HKEY root,const char *key) : CRegEmptySD(root,key,TRUE) {}
};



BOOL IsFileExist(const char *s);
void sys_deletefile(const char *s);
void sys_removedirectory(const char *s);
void *sys_fopenr(const char *filename);
void *sys_fopenw(const char *filename);
void *sys_fopena(const char *filename);
void *sys_fcreate(const char *filename,int sharemode=FILE_SHARE_READ);
void sys_fclose(void *h);
int sys_fread(void *h,void *buff,int len);
int sys_fwrite(void *h,const void *buff,int len);
int sys_fwrite_txt(void *h,const char *buff);
int sys_fsize(void *h);
void sys_fseek(void *h,int pos);
BOOL WriteFullFile(const char *filename,const void *buff,int size,int sharemode=FILE_SHARE_READ);
void* ReadFullFile(const char *filename,int *_size);
void RegCopyKey(HKEY hkey,const char *in,const char *out);
BOOL WriteRegStrExp(HKEY root,const char *key,const char *value,const char *data);
BOOL WriteRegStrExp64(HKEY root,const char *key,const char *value,const char *data);
void ReadRegMultiStr(HKEY root,const char *key,const char *value,char *data,int max,int *_out);
DWORD ReadRegDwordP(HKEY h,const char *value,int def);
BOOL WriteRegBinP(HKEY h,const char *value,const char *data,int len);
void ReadRegBinP(HKEY h,const char *value,char *data,int max,int *out_len);
void RegFlush(void);
const char *IntToStr(int n);
void GetSpecialFolder(int folder,char *s);
void Copy2Clipboard(const char *s);
void StrReplaceI(char *str,const char *name,const char *value);
BOOL IsExtensionInList(const char *ext,const char *list);
void Reboot(BOOL force);
void Shutdown(BOOL force);
void LogOff(BOOL force);
void Hibernate(BOOL force);
void Suspend(BOOL force);
BOOL IsVistaLonghorn(void);
BOOL IsWindows8OrHigher();
BOOL IsWin2000(void);
unsigned GetNormalTimeSec(FILETIME *time);
__int64 GetLocalTime64(void);
__int64 GetSystemTime64(void);
unsigned GetLocalTimeMin(void);
void EndTaskRequest(HWND hwnd);
BOOL IsRunningInSafeMode(void);
void ShellReadyEvent(void);
unsigned GetProcessCreationTimeInSec(int pid);
BOOL IsInShutdownState();
BOOL IsTerminalSession();
char* GetProcessOwnerStringSid(int pid,char *out);
char* GetCurrentUserSid(char *out);
BOOL IsOurServiceActive();
char* GetFileNameInTempDir(const char *local,char *out);
char* GetTrueSystem32Dir(char *out);
char* GetTrueSystem64Dir(char *out);
char* GetFileNameInWindowsDir(const char *local,char *out);
char* GetFileNameInTrueSystem32Dir(const char *local,char *out);
char* GetFileNameInTrueSystem64Dir(const char *local,char *out);
char* GetFileNameInLocalAppDir(const char *local,char *out);
BOOL IsCyrillic();
BOOL IsPidWow64(int pid);
void ActiveXRegister32(const char *classid,const char *desc,const char *dll,const char *model,const char *progid);
void ActiveXRegister64(const char *classid,const char *desc,const char *dll,const char *model,const char *progid);
void ActiveXUnregister32(const char *classid);
void ActiveXUnregister64(const char *classid);
void ActiveXRegisterFromDLL32(const char *dll);
void ActiveXUnregisterFromDLL32(const char *dll);


#endif

