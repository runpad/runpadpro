
#ifndef __INCLUDE_H__
#define __INCLUDE_H__

#define _WIN32_IE     0x0501   //WinXP
#define _WIN32_WINNT  0x0501   //WinXP
#define _WIN32_DCOM

#include <winsock2.h>
#include <windows.h>
#include <shlwapi.h>
#include <objbase.h>
#include <shlobj.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "def.h"
#include "serviceman.h"
#include "../common/version.h"
#include "../../client/rshell/f0.h"
#include "../../client/rshell/f1.h"
#include "../../client/rshell/netcmd.h"
#include "../../admin/sql/h_sql.h"
#include "db.h"
#include "server.h"
#include "myservice.h"
#include "tools.h"
#include "client.h"
#include "update.h"
#include "log.h"


#endif
