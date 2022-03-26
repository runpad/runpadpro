
#ifndef ___F0_H___
#define ___F0_H___


#include <vector>


class CBuff
{
          char *start_buff;
          char *buff;

          std::vector<char*> stack;

  public:
          CBuff(char *_buff);
          ~CBuff();

          unsigned GetSize() const { return buff - start_buff; }

          // do not use operators here, because size must be always strictly known!
          unsigned AddBool(BOOL obj);
          unsigned AddInt(int obj);
          unsigned AddByte(unsigned char obj);
          unsigned AddString(const char *obj);

          void Push();
          void Pop();

  private:
          BOOL Simulate() const { return (start_buff == NULL); }
};


class CDynBuff
{
          void *m_buff;
          unsigned m_size;
          unsigned m_allocsize;

  public:
          CDynBuff();
          CDynBuff(const CDynBuff& other);
          CDynBuff(const void *buff,unsigned len);
          ~CDynBuff();

          void Clear();
          void Compact(unsigned size);
          
          const char* GetBuffPtr() const { return (const char*)m_buff; }
          unsigned GetBuffSize() const { return m_size; }
          
          const CDynBuff& operator = (const CDynBuff& other);

          void AddBuff(const void *buff,unsigned len);
          void AddChar(char v);
          void AddByte(unsigned char v);
          void AddInt(int v);
          void AddInt(unsigned v);
          void AddInt64(__int64 v);
          void AddStringNoTerm(const char *v);
          void AddStringSZ(const char *v);
          void AddStringPair(const char *name,const char *value);
          void AddPointer(void *v);

          const CDynBuff& operator += (const CDynBuff &v);
          const CDynBuff& operator += (char v);
          const CDynBuff& operator += (unsigned char v);
          const CDynBuff& operator += (int v);
          const CDynBuff& operator += (unsigned v);
          const CDynBuff& operator += (__int64 v);
          const CDynBuff& operator += (const char *v);

          operator const char* () const;
          operator const unsigned char* () const;
          operator const void* () const;

  private:
          void Free();
          void CopyFrom(const CDynBuff& other);
};


class CCSGuard
{
           CRITICAL_SECTION *p_cs;
  public:
           CCSGuard(const CRITICAL_SECTION &cs)
           {
             p_cs = (CRITICAL_SECTION*)&cs;
             EnterCriticalSection(p_cs);
           }

           ~CCSGuard()
           {
             LeaveCriticalSection(p_cs);
           }
};


class CWindowProc
{
  protected:
            void InitWindowProcWrapper(HWND hwnd);
            void DoneWindowProcWrapper(HWND hwnd);

            static LRESULT CALLBACK WindowProcWrapper(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam);
            virtual LRESULT WindowProc(HWND hwnd,UINT message,WPARAM wParam,LPARAM lParam) = 0;
};


class CPathExpander
{
           char *s_out;

  public:
           CPathExpander(const char *path,BOOL allow_args = FALSE);
           ~CPathExpander();

           const char* GetPath() { return GetNonNullString(s_out); }
           const char* GetCmdLine() { return GetNonNullString(s_out); }

           operator const char* () { return GetNonNullString(s_out); }
  private:
           const char* GetNonNullString( const char* s ) { return s ? s : ""; }
};


class CCmdLineExpander : public CPathExpander
{
  public:
           CCmdLineExpander(const char *path) : CPathExpander(path,TRUE) {}
};


class CUnicode
{
           WCHAR *s_out;

  public:
           CUnicode(const char *s,int locale=CP_ACP);
           ~CUnicode();

           operator const WCHAR* () const { return s_out ? s_out : L""; }
           const WCHAR* Text() const { return s_out ? s_out : L""; }
};


class CUnicodeRus : public CUnicode
{
  public:
           CUnicodeRus(const char *s) : CUnicode(s,1251) {}
};


class CANSI
{
           char *s_out;

  public:
           CANSI(const WCHAR *s,int codepage=CP_THREAD_ACP);
           ~CANSI();

           operator const char* () const { return s_out ? s_out : ""; }
           const char* Text() const { return s_out ? s_out : ""; }
};


class CString2Filename
{
           char *s_out;

  public:
           CString2Filename(const char *str);
           ~CString2Filename();

           const char* GetFileName() { return GetNonNullString(s_out); }

           operator const char* () { return GetNonNullString(s_out); }
  private:
           const char* GetNonNullString( const char* s ) { return s ? s : ""; }
};




int RangeI(int v,int min,int max);
void SetRandSeed(unsigned s);
int RandomSeed();
int RandomWord(void);
int RandomRange(int min,int max);
BOOL IsBoolEqu(BOOL b1,BOOL b2);
BOOL IsStrEmpty(const char *s);
BOOL IsStrEmpty(const WCHAR *s);
BOOL IsStringEmpty(const char *s);
void *sys_alloc(int size);
void *sys_realloc(void *buff,int newsize);
char *sys_copystring(const char *_src,int max=0);
WCHAR *sys_copystringW(const WCHAR *_src,int max=0);
char *sys_copystring_replace_empty_by_null(const char *_src,int max=0);
void *sys_zalloc(int size);
void sys_free(void *buff);
BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data);
BOOL WriteRegStr64(HKEY root,const char *key,const char *value,const char *data);
BOOL WriteRegMultiStr(HKEY root,const char *key,const char *value,const char *data,int len);
BOOL WriteRegMultiStr64(HKEY root,const char *key,const char *value,const char *data,int len);
BOOL WriteRegStrP(HKEY h,const char *value,const char *data);
BOOL WriteRegDword(HKEY root,const char *key,const char *value,DWORD data);
BOOL WriteRegDword64(HKEY root,const char *key,const char *value,DWORD data);
BOOL WriteRegDwordP(HKEY h,const char *value,DWORD data);
void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def);
void ReadRegStr64(HKEY root,const char *key,const char *value,char *data,const char *def);
DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def);
DWORD ReadRegDword64(HKEY root,const char *key,const char *value,int def);
void ReadRegBin(HKEY root,const char *key,const char *value,char *data,int max,int *out_len);
BOOL WriteRegBin(HKEY root,const char *key,const char *value,const char *data,int len);
BOOL DeleteRegValue(HKEY root,const char *key,const char *value);
BOOL DeleteRegValue64(HKEY root,const char *key,const char *value);
BOOL DeleteRegKey(HKEY root,const char *key);
BOOL DeleteRegKeyNoRec(HKEY root,const char *key);
BOOL DeleteRegKeyNoRec64(HKEY root,const char *key);
unsigned CalculateHashBobJankins( const unsigned char *k, unsigned length, unsigned initval );
int GetFirstHostAddrByName(const char *name);
char* GetDomainName(char*s);
char* MyGetUserName(char *out);
char* MyGetComputerName(char *out);
BOOL IsCurrentUserIsInDomain();
int GetMyIPAsInt(void);
char* GetMyIPAsString(char *s);
BOOL IsAdminAccount();
const char* GetSysDrivePathWithBackslash(void);
BOOL IsMyIP(int ip);
BOOL IsMyIP(const char *s_ip);
void SetProcessPrivilege(const char *name);
BOOL IsNetPathFast(const char *path);
const GUID& GetEmptyGUID();
BOOL IsGUIDEmpty(const GUID& guid);
BOOL IsWOW64();
int GetWow64RegFlag64();
PSECURITY_DESCRIPTOR AllocateSDWithNoDACL();
void FreeSD(PSECURITY_DESCRIPTOR sd);


#endif

