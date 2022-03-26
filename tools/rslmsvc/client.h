
#ifndef __CLIENT_H__
#define __CLIENT_H__


class CServer;

typedef struct {
 CServer *server;
 SOCKET h_socket;
} TCLIENTTHREAD;


unsigned __stdcall ClientThreadProc(LPVOID lpParameter);



#endif

