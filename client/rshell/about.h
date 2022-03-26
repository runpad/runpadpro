
#ifndef ___ABOUT_H___
#define ___ABOUT_H___


void ShowAboutBox(void);
void HideAboutBox(void);
void AboutBoxUpdateProgress(const char *text,BOOL b_warn=FALSE);
void AboutBoxUpdateLicInfo(const char *lic_name,int lic_machines);


#endif
