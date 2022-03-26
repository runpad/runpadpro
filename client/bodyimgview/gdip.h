

void GDIP_Init();
void GDIP_Done();
void SetFirstMask();
const char* GetNextMask();
BOOL LoadPicFile(const char *filename,int *_width,int *_height,void **_buff);
BOOL SavePicFile(const char *filename,int width,int height,const void *buff);
void FreePicFile(void *buff);

