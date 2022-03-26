

static int WS_CreateSocket()
{
  int newsocket = socket(PF_INET,SOCK_DGRAM,IPPROTO_UDP);

  BOOL v = 1;
  setsockopt(newsocket,SOL_SOCKET,SO_BROADCAST,(char*)&v,sizeof(v));

  return newsocket;
}


static void WS_CloseSocket(int newsocket)
{
  closesocket(newsocket);
}


static void WS_SendPacket(int newsocket,unsigned port,int ip,const void *buff,int size)
{
  struct sockaddr_in addr;

  ZeroMemory(&addr,sizeof(addr));
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  *(int*)&addr.sin_addr = ip;

  sendto(newsocket,(const char*)buff,size,0,(struct sockaddr*)&addr,sizeof(addr));
}



static void WOL(int ip,unsigned char *mac)
{
  int send_sock = WS_CreateSocket();

  unsigned char packet[6+16*6];

  unsigned char *p = packet;
  for ( int n = 0; n < 6; n++ )
      *p++ = 0xFF;
  for ( int m = 0; m < 16; m++ )
  for ( int n = 0; n < 6; n++ )
      *p++ = mac[n];

  WS_SendPacket(send_sock,9,ip,packet,sizeof(packet));

  WS_CloseSocket(send_sock);
}


static void WakeupOnLANInternal(const char *s_ip,const char *s_mac)
{
  if ( !IsStrEmpty(s_mac) && lstrlen(s_mac) == lstrlen("XX:XX:XX:XX:XX:XX") )
     {
       if ( IsStrEmpty(s_ip) )
          {
            s_ip = "255.255.255.255";
          }

       int ip = inet_addr(s_ip);
       if ( ip == 0 )
          ip = -1;

       char s[MAX_PATH];
       ZeroMemory(s,sizeof(s));
       lstrcpy(s,s_mac);
       int count = 0;
       for ( int n = 0; n < lstrlen(s); n++ )
           if ( s[n] == ':' )
              {
                s[n] = ' ';
                count++;
              }
       if ( count == 5 )
          {
            int i_mac[6] = {0,0,0,0,0,0};
            
            sscanf(s,"%X %X %X %X %X %X",&i_mac[0],&i_mac[1],&i_mac[2],&i_mac[3],&i_mac[4],&i_mac[5]);

            unsigned char mac[6];

            mac[0] = (i_mac[0] & 0xFF);
            mac[1] = (i_mac[1] & 0xFF);
            mac[2] = (i_mac[2] & 0xFF);
            mac[3] = (i_mac[3] & 0xFF);
            mac[4] = (i_mac[4] & 0xFF);
            mac[5] = (i_mac[5] & 0xFF);

            if ( ip != -1 )
               WOL(ip,mac);
            WOL(-1,mac);
          }
     }
}


void WakeupOnLAN(const char *s_ip,const char *s_mac)
{
  if ( NetIsConnected() )
     {
       CNetCmd cmd(NETCMD_WOL);
       cmd.AddStringParm(NETPARM_S_IP,s_ip);
       cmd.AddStringParm(NETPARM_S_MAC,s_mac);
       NetSend(cmd);
     }
  else
     {
       WakeupOnLANInternal(s_ip,s_mac);
     }
}

