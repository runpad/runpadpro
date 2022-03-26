
#ifndef __HWIDENT_H__
#define __HWIDENT_H__


class CHWIdent
{
  public:
          enum EHWIdentDevice
          {
            HWID_NONE = 0,
            HWID_IBUTTON = 1,
          };

  public:
          CHWIdent() {}
          virtual ~CHWIdent() {}

          virtual EHWIdentDevice GetType() const { return HWID_NONE; }
          virtual BOOL IsDeviceDetection(BOOL &_is_present) = 0;
          virtual BOOL IsEvent(char *id,int max) = 0;
};


#endif

