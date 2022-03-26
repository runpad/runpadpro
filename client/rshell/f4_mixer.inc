
static HMIXER hMixer = NULL;


void CheckVolumes(HWND w_main)
{
  static int in_use = 0;
  MIXERLINE ml;
  MIXERLINECONTROLS mlc;
  MIXERCONTROL mc;
  MIXERCONTROLDETAILS mcd;
  MIXERCONTROLDETAILS_UNSIGNED mcdu;
  MIXERCONTROLDETAILS_BOOLEAN mcdb;
  DWORD v;
  int mute = 0;

  if ( in_use )
     return;

  in_use = 1;

  // master volume
  if ( hMixer )
     {
       ZeroMemory(&ml,sizeof(ml));
       ml.cbStruct = sizeof(MIXERLINE);
       ml.dwComponentType = MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
       if ( !mixerGetLineInfo((HMIXEROBJ) hMixer, &ml, MIXER_GETLINEINFOF_COMPONENTTYPE) )
          {
            ZeroMemory(&mc,sizeof(mc));
            ZeroMemory(&mlc,sizeof(mlc));
            mlc.cbStruct = sizeof(MIXERLINECONTROLS);
            mlc.dwLineID = ml.dwLineID;
            mlc.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME;
            mlc.cControls = 1;
            mlc.pamxctrl = &mc;
            mlc.cbmxctrl = sizeof(MIXERCONTROL);
            if ( !mixerGetLineControls((HMIXEROBJ) hMixer, &mlc, MIXER_GETLINECONTROLSF_ONEBYTYPE) )
               {
                 ZeroMemory(&mcd,sizeof(mcd));
                 mcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
                 mcd.hwndOwner = 0;
                 mcd.dwControlID = mc.dwControlID;
                 mcd.paDetails = &mcdu;
                 mcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
                 mcd.cChannels = 1;
                 if ( !mixerGetControlDetails((HMIXEROBJ) hMixer, &mcd, MIXER_GETCONTROLDETAILSF_VALUE) )
                    {
                      DWORD maxlimit = maxvol_master * (mc.Bounds.dwMaximum-mc.Bounds.dwMinimum) / 100 + mc.Bounds.dwMinimum;
                      DWORD minlimit = minvol_master * (mc.Bounds.dwMaximum-mc.Bounds.dwMinimum) / 100 + mc.Bounds.dwMinimum;

                      int change = 0;

                      if ( mcdu.dwValue > maxlimit && maxvol_enable )
                         {
                           mcdu.dwValue = maxlimit;
                           change = 1;
                         }

                      if ( mcdu.dwValue < minlimit && maxvol_enable )
                         {
                           mcdu.dwValue = minlimit;
                           change = 1;
                         }

                      if ( mcdu.dwValue == mc.Bounds.dwMinimum )
                         mute = 1;
                         
                      if ( change && maxvol_enable )
                         {
                           ZeroMemory(&mcd,sizeof(mcd));
                           mcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
                           mcd.hwndOwner = 0;
                           mcd.dwControlID = mc.dwControlID;
                           mcd.paDetails = &mcdu;
                           mcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
                           mcd.cChannels = 1;
                           mixerSetControlDetails((HMIXEROBJ) hMixer, &mcd, MIXER_SETCONTROLDETAILSF_VALUE);
                         }
                    }
               }

            ZeroMemory(&mc,sizeof(mc));
            ZeroMemory(&mlc,sizeof(mlc));
            mlc.cbStruct = sizeof(MIXERLINECONTROLS);
            mlc.dwLineID = ml.dwLineID;
            mlc.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE;
            mlc.cControls = 1;
            mlc.pamxctrl = &mc;
            mlc.cbmxctrl = sizeof(MIXERCONTROL);
            if ( !mixerGetLineControls((HMIXEROBJ) hMixer, &mlc, MIXER_GETLINECONTROLSF_ONEBYTYPE) )
               {
                 ZeroMemory(&mcd,sizeof(mcd));
                 mcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
                 mcd.hwndOwner = 0;
                 mcd.dwControlID = mc.dwControlID;
                 mcd.paDetails = &mcdb;
                 mcd.cbDetails = sizeof(MIXERCONTROLDETAILS_BOOLEAN);
                 mcd.cChannels = 1;
                 if ( !mixerGetControlDetails((HMIXEROBJ) hMixer, &mcd, MIXER_GETCONTROLDETAILSF_VALUE) )
                    {
                      if ( mcdb.fValue )
                         mute = 1;
                    }
               }
          }
     }


  // wave volume
  if ( !waveOutGetVolume((HWAVEOUT)WAVE_MAPPER,&v) )
     {
       DWORD maxlimit = maxvol_wave * 0xFFFF / 100;
       DWORD minlimit = minvol_wave * 0xFFFF / 100;
       DWORD vr = (v >> 16) & 0xFFFF;
       DWORD vl = v & 0xFFFF;
       int change = 0;

       v = vr > vl ? vr : vl;

       if ( v > maxlimit && maxvol_enable )
          {
            v = maxlimit;
            change = 1;
          }

       if ( v < minlimit && maxvol_enable )
          {
            v = minlimit;
            change = 1;
          }

       if ( v == 0 )
          mute = 1;
          
       if ( change && maxvol_enable )
          {
            v = (v << 16) + v;
            waveOutSetVolume((HWAVEOUT)WAVE_MAPPER,v);
          }
     }

  if ( is_volume_mute != mute )
     {
       is_volume_mute = mute;
       PostMessage(w_main,RS_MIXERUPDATEICON,0,0);
     }
  
  in_use = 0;
}


void PrepareVolumeMixer(HWND w)
{
  mixerOpen(&hMixer,0,(DWORD)w,0,MIXER_OBJECTF_MIXER | CALLBACK_WINDOW);
}


void FinishVolumeMixer(void)
{
  if ( hMixer )
     mixerClose(hMixer);
  hMixer = NULL;
}
