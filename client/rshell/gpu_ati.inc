

typedef int (__cdecl *ADL_MAIN_CONTROL_CREATE )(ADL_MAIN_MALLOC_CALLBACK, int );
typedef int (__cdecl *ADL_MAIN_CONTROL_DESTROY )();
typedef int (__cdecl *ADL_ADAPTER_NUMBEROFADAPTERS_GET ) ( int* );
typedef int (__cdecl *ADL_ADAPTER_ADAPTERINFO_GET ) ( LPAdapterInfo, int );
typedef int (__cdecl *ADL_OVERDRIVE5_TEMPERATURE_GET)( int iAdapterIndex, int iThermalControllerIndex, ADLTemperature *  lpTemperature );


void* __stdcall ADL_Main_Memory_Alloc ( int iSize )
{
    void* lpBuffer = sys_alloc ( iSize );
    return lpBuffer;
}



BOOL GetGPUTemp_ATI(int *_temp)
{
  BOOL rc = FALSE;

  if ( _temp )
     {
       *_temp = 0;

       HINSTANCE lib = LoadLibrary("atiadlxx.dll");
       if ( !lib )
          lib = LoadLibrary("atiadlxy.dll");

       if ( lib )
          {
            ADL_MAIN_CONTROL_CREATE           ADL_Main_Control_Create;
            ADL_MAIN_CONTROL_DESTROY          ADL_Main_Control_Destroy;
            ADL_ADAPTER_NUMBEROFADAPTERS_GET  ADL_Adapter_NumberOfAdapters_Get;
            ADL_ADAPTER_ADAPTERINFO_GET       ADL_Adapter_AdapterInfo_Get;
            ADL_OVERDRIVE5_TEMPERATURE_GET    ADL_Overdrive5_Temperature_Get;

            *(void**)&ADL_Main_Control_Create =          (void*)GetProcAddress(lib,"ADL_Main_Control_Create");
            *(void**)&ADL_Main_Control_Destroy =         (void*)GetProcAddress(lib,"ADL_Main_Control_Destroy");
            *(void**)&ADL_Adapter_NumberOfAdapters_Get = (void*)GetProcAddress(lib,"ADL_Adapter_NumberOfAdapters_Get");
            *(void**)&ADL_Adapter_AdapterInfo_Get =      (void*)GetProcAddress(lib,"ADL_Adapter_AdapterInfo_Get");
            *(void**)&ADL_Overdrive5_Temperature_Get =   (void*)GetProcAddress(lib,"ADL_Overdrive5_Temperature_Get");

            if ( ADL_Main_Control_Create &&
                 ADL_Main_Control_Destroy &&
                 ADL_Adapter_NumberOfAdapters_Get &&
                 ADL_Adapter_AdapterInfo_Get &&
                 ADL_Overdrive5_Temperature_Get )
               {
                 if ( ADL_Main_Control_Create(ADL_Main_Memory_Alloc,1) == ADL_OK )
                    {
                      int count = 0;
                      if ( ADL_Adapter_NumberOfAdapters_Get(&count) == ADL_OK && count > 0 )
                         {
                           AdapterInfo *infos = (AdapterInfo*)sys_zalloc(count*sizeof(AdapterInfo));

                           if ( ADL_Adapter_AdapterInfo_Get(infos,sizeof(AdapterInfo)*count) == ADL_OK )
                              {
                                int maxtemp = 0;

                                for ( int n = 0; n < count; n++ )
                                    {
                                      int iAdapterIndex = infos[n].iAdapterIndex;

                                      ADLTemperature i;
                                      ZeroMemory(&i,sizeof(i));
                                      i.iSize = sizeof(i);
                                      if ( ADL_Overdrive5_Temperature_Get(iAdapterIndex,0,&i) == ADL_OK )
                                         {
                                           if ( i.iTemperature > maxtemp )
                                              {
                                                maxtemp = i.iTemperature;
                                                rc = TRUE;
                                              }
                                         }
                                    }

                                *_temp = maxtemp / 1000;
                              }

                           sys_free(infos);
                         }

                      ADL_Main_Control_Destroy();
                    }
               }

            FreeLibrary(lib);
          }
     }

  return rc;
}


