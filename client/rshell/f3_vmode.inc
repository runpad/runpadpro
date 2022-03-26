
typedef struct {
int width;
int height;
int bpp;
int freq;
} VMODE;


static VMODE dm = {0,};   // default


void SaveDisplayMode(void)
{
  DEVMODE v;
  
  ZeroMemory(&v,sizeof(v));
  v.dmSize = sizeof(v);
  EnumDisplaySettings(NULL,ENUM_CURRENT_SETTINGS,&v);
  dm.width = v.dmPelsWidth;
  dm.height = v.dmPelsHeight;
  dm.bpp = v.dmBitsPerPel;
  dm.freq = v.dmDisplayFrequency;
  if ( dm.freq < 0 || dm.freq > 200 )
     dm.freq = 60;
}


void RestoreOriginalDesktopGamma(void)
{
  int i,j;
  unsigned short ramp[3][256];
  
  HWND hwnd = GetDesktopWindow();
  HDC hdc = GetDC(hwnd);

  for ( j = 0; j < 3; j++ )
  for ( i = 0; i < 256; i++ )
      ramp[j][i] = (i/2) << 8;
  SetDeviceGammaRamp(hdc,ramp);

  for ( j = 0; j < 3; j++ )
  for ( i = 0; i < 256; i++ )
      ramp[j][i] = i << 8;
  SetDeviceGammaRamp(hdc,ramp);

  ReleaseDC(hwnd,hdc);
}


void RestoreVModeInternal()
{
  int _width,_height,_bpp,_freq;
  
  if ( def_vmode_width <= 0 || def_vmode_height <= 0 || def_vmode_bpp <= 0 )
     {
       _width = dm.width;
       _height = dm.height;
       _bpp = dm.bpp;
     }
  else
     {
       _width = def_vmode_width;
       _height = def_vmode_height;
       _bpp = def_vmode_bpp;
     }

  _freq = ( display_freq < 43 || display_freq > 200 ) ? dm.freq : display_freq;
  
  DEVMODE v;
  ZeroMemory(&v,sizeof(v));
  v.dmSize = sizeof(v);
  v.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT | DM_DISPLAYFREQUENCY;
  v.dmBitsPerPel = _bpp;
  v.dmPelsWidth = _width;
  v.dmPelsHeight = _height;
  v.dmDisplayFrequency = _freq;

  if ( ChangeDisplaySettings(&v,CDS_SET_PRIMARY | CDS_UPDATEREGISTRY) != DISP_CHANGE_SUCCESSFUL )
     {
       v.dmFields &= ~DM_DISPLAYFREQUENCY;
       ChangeDisplaySettings(&v,CDS_SET_PRIMARY | CDS_UPDATEREGISTRY);
     }
}


void RestoreDisplayMode(void)
{
  RestoreOriginalDesktopGamma();
  RestoreVModeInternal();
  RestoreOriginalDesktopGamma();
}


