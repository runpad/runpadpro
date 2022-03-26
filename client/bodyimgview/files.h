

#ifndef _FILES_H
#define _FILES_H


// scan directory of image files
void ScanDirectory(char* path, char* file);
void ReScanDirectory(char *file);


char* GetFileName(void);
char GetFileRotate(void);
void SetFileRotate(char);
char GetFileBad(void);   // return value: 0 on sucess, 1 if file is bad, -1 if current file isn't selected
void SetFileBad(void);
char PrevFile(void);     // return 0 if pointer is set to first valid file in list
char NextFile(void);     // return 0 if pointer is set to last valid file in list
void FirstFile(void);    // set the pointer to the first valid file in list
void LastFile(void);     // set the pointer to the last valid file in list

void InitFiles(char* _path, char* _file);
void RunFilesThread();
void DoneFiles(void);


#endif
