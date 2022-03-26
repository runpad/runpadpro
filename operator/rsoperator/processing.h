
#ifndef __PROCESSING_H__
#define __PROCESSING_H__


class CVSControl;
class CAlerts;

extern CVSControl *vscontrol;
extern CAlerts *alerts;


BOOL CheckForAlreadyLoaded();
BOOL IsWeAddedToAutorun();
void AddToAutorun(HKEY root);
void RemoveFromAutorun(HKEY root);
void MainProcessing();



#endif
