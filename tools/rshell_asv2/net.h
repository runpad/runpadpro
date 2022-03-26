

class CNet
{
          static const int PORT = 44565;
         
          int recv_socket;

  public:
          CNet();
          ~CNet();

          BOOL Get(void *buff,int maxlen,int *_recv_bytes);

  private:
          int CreateRecvSocket(unsigned port);
          int RecvPacket(int newsocket,void *buff,int maxlen,int *from_ip);
          BOOL IsMyIP(int ip);

};

