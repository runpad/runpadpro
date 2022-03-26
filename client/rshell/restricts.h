
#ifndef __RESTRICTS_H__
#define __RESTRICTS_H__


enum {
RREASON_INSTALL = 1,
RREASON_UNINSTALL,
RREASON_STARTUP,
RREASON_SHUTDOWN,   //here logoff, reboot, etc..
RREASON_OFFSHELL,
};

void ProcessRestricts(int reason);
void UpdateRestricts(void);



#endif
