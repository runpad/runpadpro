
#ifndef __VOLUME_H__
#define __VOLUME_H__



class CMixer
{
          HMIXER hMixer;

  public:
          CMixer();
          ~CMixer();

          void TuneMaster(int delta_percent);
};



#endif
