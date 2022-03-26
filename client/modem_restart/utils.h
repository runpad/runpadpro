
void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def);
DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def);
BOOL WriteRegStr(HKEY root,const char *key,const char *value,const char *data);
BOOL WriteRegDword(HKEY root,const char *key,const char *value,DWORD data);
