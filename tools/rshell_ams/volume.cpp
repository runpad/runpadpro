
#include "include.h"



CMixer::CMixer()
{
  hMixer = NULL;

  mixerOpen(&hMixer,0,0,0,MIXER_OBJECTF_MIXER);
}


CMixer::~CMixer()
{
  if ( hMixer )
     mixerClose(hMixer);
  hMixer = NULL;
}


void CMixer::TuneMaster(int delta_percent)
{
  if ( hMixer )
     {
       MIXERLINE ml;
       ZeroMemory(&ml,sizeof(ml));
       ml.cbStruct = sizeof(MIXERLINE);
       ml.dwComponentType = MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
       if ( !mixerGetLineInfo((HMIXEROBJ) hMixer, &ml, MIXER_GETLINEINFOF_COMPONENTTYPE) )
          {
            MIXERCONTROL mc;
            MIXERLINECONTROLS mlc;
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
                 MIXERCONTROLDETAILS_UNSIGNED mcdu;

                 MIXERCONTROLDETAILS mcd;
                 ZeroMemory(&mcd,sizeof(mcd));
                 mcd.cbStruct = sizeof(MIXERCONTROLDETAILS);
                 mcd.hwndOwner = 0;
                 mcd.dwControlID = mc.dwControlID;
                 mcd.paDetails = &mcdu;
                 mcd.cbDetails = sizeof(MIXERCONTROLDETAILS_UNSIGNED);
                 mcd.cChannels = 1;
                 if ( !mixerGetControlDetails((HMIXEROBJ) hMixer, &mcd, MIXER_GETCONTROLDETAILSF_VALUE) )
                    {
                      DWORD maxlimit = mc.Bounds.dwMaximum;
                      DWORD minlimit = mc.Bounds.dwMinimum;
                      DWORD curr = mcdu.dwValue;

                      if ( curr >= minlimit && curr <= maxlimit && minlimit < maxlimit )
                         {
                           int perc = (curr-minlimit)*100/(maxlimit-minlimit);
                           perc += delta_percent;

                           if ( perc < 0 )
                              perc = 0;
                           if ( perc > 100 )
                              perc = 100;

                           curr = perc*(maxlimit-minlimit)/100+minlimit;

                           if ( curr != mcdu.dwValue )
                              {
                                mcdu.dwValue = curr;
                                
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
               }
          }
     }
}


