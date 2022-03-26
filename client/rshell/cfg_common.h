
#ifndef __CFG_COMMON_H__
#define __CFG_COMMON_H__



char* GetGlobalCommonPath(const char *local,char *out);
char* GetErrLogFileName(char *s);
char* GetConfigCacheDir4AllUsers(char *s);
char* GetConfigCacheDir4CurrentUser(char *s);
void WriteSidEncryptedFileWithCRC(const char *filename,const void *buff,unsigned size);
void* ReadSidEncryptedFileWithCRC(const char *filename,unsigned *_size);
void WriteLicFeatToCache(const char *s);
BOOL ReadLicFeatFromCache(char *_lic_feat,int max);
void WriteSettingsToCache(const void *buff,unsigned size);
BOOL ReadSettingsFromCache(int _curr_lang,int _machine_type);



#endif
