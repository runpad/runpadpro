

#ifndef ___STAT_H___
#define ___STAT_H___


void Add2Stat(const CSheet *run_sheet,const char *title,int pid,HICON icon,BOOL is_from_ie);
void UpdateStat(void);
void ProcessStatAtStartup(void);
void DeleteAllStat(void);
void SaveStatToFile(const char *filename/*,const char *info*/);


#endif


