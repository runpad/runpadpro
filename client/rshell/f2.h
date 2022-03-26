
#ifndef ___F2_H___
#define ___F2_H___


class CSessionProcessList
{
          struct {
           HANDLE handle;
           BOOL first;
          } snap;
          
          struct {
           DWORD our_sid;   // our session id
           WTS_PROCESS_INFO *list;
           DWORD count;
           DWORD curr;  // current index in list
          } wts;

  public:
          CSessionProcessList();
          ~CSessionProcessList();

          BOOL GetNext(int *_pid,char *_filename=NULL);
};


class CShellObjDelayLoad
{
          static const int MAXSHELLOBJ = 32;

          IOleCommandTarget* shellobj[MAXSHELLOBJ];
          int num_shellobj;

  public:
          CShellObjDelayLoad();
          ~CShellObjDelayLoad();

  private:
          static int EnumSOFunc(const char *name,const char *data,void *param);
          void AddShellObj(const char *name);
          void FreeShellObj(IOleCommandTarget *obj);

};


BOOL IsApplicationHung(HWND w,int timeout);
BOOL IsTempRelativeDir(const char *dir);
BOOL IsExplorerLoaded(void);
void CleanDir(const char *dir);
void LoadTextFromDescriptionToken(const char *token,char *out,int max);
void GetRandomPictureFileFromGallery(const char *path,char *out);
void RemoveAppCompatFlags(void);
void RegUnregExtensions(BOOL state,const char *subname,const char *path,int icon_idx,const char *desc,const char *list);
void RegUnregProtocols(BOOL state,const char *subname,const char *path,const char *list);
BOOL IsOurDesktopHidden(void);
void Wait4DesktopSwitch(void);
HICON ExtractSingleIconInOldMethod(const char *s,int size);
void LoadFileIconsGuarant( const char *s_fullpath,const char *s_iconpath,int i_iconidx,int i_size1,int i_size2,HICON *p_hicon1,HICON *p_hicon2,BOOL *p_is_net,BOOL &_is_default_loaded);
void LoadUrlIconsGuarant(int i_size1,int i_size2,HICON *p_hicon1,HICON *p_hicon2);
void InjectLocalDLLIntoProcessList32(const char *list,const char *dllname,BOOL allow_into_older,int delay);
void ScanDir(const char *path,int type,SCANFUNC func,void *user);
void ScanProcesses(SCANPROCESSESPROC func,void *parm);
int EnumerateRegistryKeys(HKEY root,const char *key,REGENUMKEYFUNC func,void *param);
int EnumerateRegistryValues(HKEY root,const char *key,REGENUMVALUEFUNC func,void *param);
int EnumerateRegistryValues64(HKEY root,const char *key,REGENUMVALUEFUNC func,void *param);
void GetLnkFileInfo(const char *filename,char *path,char *desc,char *arg,char *cwd,int *showcmd,char *iconpath,int *iconidx,BOOL invoke_msi);
BOOL IsProcessExists(int pid);
int FindProcess(const char *name);
char* GetExePathByPid(int pid,char *_path);
void GetProcessNameByPID(DWORD pid,char *s);
void GetWindowProcessFileName(HWND w,char *out);
HWND GetProcessAppWindow(int pid);
int FindLastProcessChild(int pid_parent);
BOOL HasProcessAppWindow(int pid);
char* GetActiveTaskString(char *s);
char* ExpandPath(const char *in,char *out);
char* ExpandPath(char *in_out);
BOOL AdminAccessWriteRegStr(HKEY root,const char *key,const char *value,const char *data);
BOOL AdminAccessWriteRegStr64(HKEY root,const char *key,const char *value,const char *data);
BOOL AdminAccessWriteRegMultiStr(HKEY root,const char *key,const char *value,const char *data,int len);
BOOL AdminAccessWriteRegDword(HKEY root,const char *key,const char *value,DWORD data);
BOOL AdminAccessDeleteRegValue(HKEY root,const char *key,const char *value);
BOOL AdminAccessDeleteRegValue64(HKEY root,const char *key,const char *value);
BOOL AdminAccessDeleteRegKey(HKEY root,const char *key);
HANDLE MyCreateThread(LPTHREAD_START_ROUTINE func,void *parm=NULL,DWORD *_id=NULL,int priority=THREAD_PRIORITY_NORMAL,int cpu_mask=-1);
HANDLE MyCreateThreadDontCare(LPTHREAD_START_ROUTINE func,void *parm=NULL,DWORD *_id=NULL);
HANDLE MyCreateThreadSelectedCPU(LPTHREAD_START_ROUTINE func,void *parm=NULL,DWORD *_id=NULL,int priority=THREAD_PRIORITY_NORMAL);
void SwitchCurrentThreadToCPU0IfNeeded();
HBITMAP LoadPicAsHBitmap(const char *filename);
HBITMAP LoadPicFromResource(int res_id);
//BOOL LoadPicAsRGB(const char *filename,int *_w,int *_h,void **_buff);
IStream* SaveImageToStream(Image *img,const WCHAR *format);
BOOL SaveImageToFile(Image *img,const WCHAR *format,const char *filename);
void* LoadRawResource(int id,int *_size);
BOOL WriteResourceToFile(const char *filename,int id);
IStream* CreateStreamFromResource(int res_id);
BOOL IsPictureFile(const char *filename);
BOOL IsPNGPictureFile(const char *filename);
BOOL ImportRegistryFileGuarantee(const char *filename);
BOOL IsFileAssociationSetInRegistry(const char *filepath);



#endif
