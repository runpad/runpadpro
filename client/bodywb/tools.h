

void ReadRegStr(HKEY root,const char *key,const char *value,char *data,const char *def);
DWORD ReadRegDword(HKEY root,const char *key,const char *value,int def);
int WriteRegDword(HKEY root, const char *key, const char *value, int data);
