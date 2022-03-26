
#ifndef __INSTALL_H__
#define __INSTALL_H__



void InstallGina(BOOL state,void *p1,void *p2,void *p3);
void SetAlternateShell(BOOL state,void *p1,void *p2,void *p3);
void ShellExecuteDisablePrepare(BOOL state,void *p1,void *p2,void *p3);
void InstallOurClasses(void);
void UninstallOurClasses(void);
void RemoveOldClassEntries();
void InstallCPUTempDriver();
void UninstallCPUTempDriver();
void InstallActions_FromSVC();



#endif

