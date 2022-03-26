

void* LoadRawResource(int id,int *_size)
{
  HRSRC res = FindResource(our_instance,MAKEINTRESOURCE(id),RT_RCDATA);
  if ( res )
     {
       HGLOBAL g = LoadResource(our_instance,res);
       if ( g )
          {
            *_size = SizeofResource(our_instance,res);
            return LockResource(g);
          }
     }

  *_size = 0;
  return NULL;
}


BOOL WriteResourceToFile(const char *filename,int id)
{
  int size = 0;
  const void *buff = LoadRawResource(id,&size);
  return buff ? WriteFullFile(filename,buff,size) : FALSE;
}


IStream* CreateStreamFromResource(int res_id)
{
  IStream *stream = NULL;

  int size = 0;
  void *buff = LoadRawResource(res_id,&size);

  if ( buff && size > 0 )
     {
       if ( CreateStreamOnHGlobal(NULL,TRUE,&stream) == S_OK )
          {
            ULARGE_INTEGER u_zero; u_zero.QuadPart = 0;
            LARGE_INTEGER i_zero; i_zero.QuadPart = 0;
            stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
            stream->SetSize(u_zero);
            stream->Write(buff,size,NULL);
            stream->Seek(i_zero,STREAM_SEEK_SET,NULL);
          }
     }

  return stream;
}
