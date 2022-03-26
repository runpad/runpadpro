

BOOL GetGPUTemp_NVidia1(int *_temp)
{
  BOOL rc = FALSE;

  if ( _temp )
     {
       *_temp = 0;

       if ( NvAPI_Initialize() == NVAPI_OK )
          {
            NvPhysicalGpuHandle gpus[NVAPI_MAX_PHYSICAL_GPUS];
            ZeroMemory(gpus,sizeof(gpus));

            NvU32 count = 0;
            if ( NvAPI_EnumPhysicalGPUs(gpus,&count) == NVAPI_OK && count > 0 )
               {
                 int maxtemp = 0;

                 for ( int n = 0; n < count; n++ )
                     {
                       NV_GPU_THERMAL_SETTINGS i;
                       ZeroMemory(&i,sizeof(i));
                       i.version = NV_GPU_THERMAL_SETTINGS_VER;
                       i.count = 1; //needed?
                       
                       if ( NvAPI_GPU_GetThermalSettings(gpus[n],0,&i) == NVAPI_OK )
                          {
                            if ( i.sensor[0].currentTemp > maxtemp )
                               {
                                 maxtemp = i.sensor[0].currentTemp;
                                 rc = TRUE;
                               }
                          }
                     }

                 *_temp = maxtemp;
               }
          }
     }

  return rc;
}


// deprecated
BOOL GetGPUTemp_NVidia2(int *_temp)
{
  BOOL rc = FALSE;

  if ( _temp )
     {
       *_temp = 0;

       HINSTANCE lib = LoadLibrary("nvcpl.dll");
       if ( lib )
          {
            BOOL (CDECL *NvCplGetThermalSettings)(IN UINT nWindowsMonitorNumber,OUT DWORD* pdwCoreTemp,OUT DWORD* pdwAmbientTemp,OUT DWORD* pdwUpperLimit);

            *(void**)&NvCplGetThermalSettings = (void*)GetProcAddress(lib,"NvCplGetThermalSettings");
            if ( NvCplGetThermalSettings )
               {
                 DWORD t1=0,t2=0,t3=0;
                 if ( NvCplGetThermalSettings(0,&t1,&t2,&t3) )
                    {
                      *_temp = t1;
                      rc = TRUE;
                    }
               }

            FreeLibrary(lib);
          }
     }

  return rc;
}


