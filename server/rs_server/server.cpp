
#include "include.h"



CServer::CServer()
{
  InitializeCriticalSection(&o_cs);

  p_env = new CNetCmd(NETCMD_GETENV_ACK);
  p_env->AddStringParm(NETPARM_S_CLASS,NETCLASS_SERVER);
  p_env->AddIntParm(NETPARM_I_GUID,NETGUID_SERVER);
  p_env->AddStringParm(NETPARM_S_VERSION,SERVER_VERSION_STR);
  AddLicInfoToEnv(*p_env);
  
  p_db = new CDBObj(HKLM,REGPATH,"sql_server","sql_type_rp","sql_type_gc");

  p_client_update = new CUpdate();
  last_client_update_time = GetTickCount() - CLIENT_UPDATE_DELTA - 1;
  p_client_update_no_shell = new CUpdate();
  last_client_update_no_shell_time = GetTickCount() - CLIENT_UPDATE_DELTA - 1;

  curr_guid = NETGUID_FIRST;

  h_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  struct sockaddr_in sin;
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(NETPORT);
  bind(h_socket,(SOCKADDR*)&sin,sizeof(sin));
  listen(h_socket,SOMAXCONN/*maybe 0 ?*/);

  h_stop_event = CreateEvent(NULL,FALSE,FALSE,NULL);
  h_thread = CreateThread(NULL,0,AcceptThreadProcWrapper,this,0,NULL);
}


CServer::~CServer()
{
  SetEvent(h_stop_event);
  if ( WaitForSingleObject(h_thread,3000) == WAIT_TIMEOUT )
     TerminateThread(h_thread,0);
  CloseHandle(h_thread);

  CloseHandle(h_stop_event);

  if ( h_socket != INVALID_SOCKET )
     {
       shutdown(h_socket,SD_BOTH);
       closesocket(h_socket);
       h_socket = INVALID_SOCKET;
     }

  TerminateAndCleanupClients();
     
  delete p_client_update;
  delete p_client_update_no_shell;
  delete p_db;
  delete p_env;

  DeleteCriticalSection(&o_cs);
}


DWORD WINAPI CServer::AcceptThreadProcWrapper(LPVOID lpParameter)
{
  CServer *obj = (CServer*)lpParameter;
  return obj->AcceptThreadProc();
}


DWORD CServer::AcceptThreadProc()
{
  unsigned last_heap_compact_time = GetTickCount();
  unsigned last_clients_cleanup_time = GetTickCount();
  
  do {

    timeval tv;
    tv.tv_sec = 0;
    tv.tv_usec = 100*1000; //100 msec

    fd_set rset;
    rset.fd_count = 1;
    rset.fd_array[0] = h_socket;

    int count = select(0,&rset,NULL,NULL,&tv);

    if ( count == SOCKET_ERROR )
       break;

    if ( count == 1 )
       {
         struct sockaddr_in s_in;
         int i_s_in_len = sizeof(s_in);
         int temp_sock = accept(h_socket,(struct sockaddr*)&s_in,&i_s_in_len);
         if ( temp_sock != INVALID_SOCKET )
            {
              int ip = s_in.sin_addr.s_addr;
              AddClient(temp_sock,ip);
            }
         else
            Sleep(10); //paranoja
       }

    if ( WaitForSingleObject(h_stop_event,0) == WAIT_OBJECT_0 )
       break;

    DoHeapCompact(last_heap_compact_time);
    DoClientsCleanup(last_clients_cleanup_time);

  } while (1);

  shutdown(h_socket,SD_BOTH);

  return 1;
}


void CServer::AddClient(int _socket,int _ip)
{
  CCSGuard g(o_cs);
  
  CClient *cl = new CClient(this,p_db,_socket,_ip,curr_guid);

  curr_guid++;
  if ( curr_guid > NETGUID_LAST )
     curr_guid = NETGUID_FIRST;

  for ( int n = 0; n < clients.size(); n++ )
      {
        if ( !clients[n]->IsActive() )
           {
             delete clients[n]; //must be fast in this case
             clients[n] = cl;
             cl = NULL;
             break;
           }
      }
  
  if ( cl )
     {
       clients.push_back(cl);
     }
}


void CServer::TerminateAndCleanupClients()
{
  for ( TClients::iterator it = clients.begin(); it != clients.end(); ++it )
      {
        (*it)->AsyncTerminate();
      }

  unsigned starttime = GetTickCount();
  do {

    BOOL all_terminated = TRUE;

    for ( TClients::const_iterator it = clients.begin(); it != clients.end(); ++it )
        {
          if ( (*it)->IsActive() )
             {
               all_terminated = FALSE;
               break;
             }
        }

    if ( all_terminated )
       break;

    Sleep(100);

  } while ( GetTickCount() - starttime < 10000 );

  {
    CCSGuard g(o_cs);
  
    do {

      TClients::iterator it = clients.begin();
      if ( it == clients.end() )
         break;
    
      delete *it;
      clients.erase(it);

    } while (1);
  }
}


void CServer::Push2Send(int cmd_id,const void *data_buff,unsigned data_size,unsigned src_guid,unsigned dest_guid)
{
  CCSGuard g(o_cs);

  BOOL first_operator_find = FALSE;

  for ( TClients::iterator it = clients.begin(); it != clients.end(); ++it )
      {
        CClient *cl = *it;

        unsigned guid = cl->GetGUID();

        BOOL do_send = FALSE;

        switch ( dest_guid )
        {
          case NETGUID_ALL_WITHME:
                                     do_send = TRUE;
                                     break;
          case NETGUID_ALL_WITHOUTME:
                                     do_send = (guid != src_guid);
                                     break;
          case NETGUID_ALL_OPERATORS_WITHME:
                                     do_send = cl->IsOperator();
                                     break;
          case NETGUID_ALL_OPERATORS_WITHOUTME:
                                     do_send = (cl->IsOperator() && guid != src_guid);
                                     break;
          case NETGUID_ALL_COMPUTERS_WITHME:
                                     do_send = cl->IsComputer();
                                     break;
          case NETGUID_ALL_COMPUTERS_WITHOUTME:
                                     do_send = (cl->IsComputer() && guid != src_guid);
                                     break;
          case NETGUID_ALL_USERS_WITHME:
                                     do_send = cl->IsUser();
                                     break;
          case NETGUID_ALL_USERS_WITHOUTME:
                                     do_send = (cl->IsUser() && guid != src_guid);
                                     break;
          case NETGUID_FIRST_OPERATOR:
                                     do_send = (cl->IsOperator() && !first_operator_find);
                                     if ( do_send )
                                        first_operator_find = TRUE;
                                     break;
          default:
                                     if ( dest_guid >= NETGUID_FIRST && dest_guid <= NETGUID_LAST )
                                        {
                                          do_send = (guid == dest_guid);
                                        }
                                     break;
        };

        if ( do_send )
           {
             cl->Push(cmd_id,data_buff,data_size,src_guid);
           }
      }
}


void CServer::GetCopyOfEnv(CNetCmd &env,unsigned guid)
{
  CCSGuard g(o_cs);

  BOOL filled = FALSE;
  
  if ( guid == NETGUID_SERVER )
     {
       env = *p_env;
       filled = TRUE;
     }
  else
     {
       if ( guid >= NETGUID_FIRST && guid <= NETGUID_LAST )
          {
            for ( TClients::const_iterator it = clients.begin(); it != clients.end(); ++it )
                {
                  const CClient *cl = *it;
                  if ( cl->GetGUID() == guid )
                     {
                       if ( cl->IsActive() && cl->IsClassKnown()/*really?*/ )
                          {
                            cl->GetCopyOfEnv(env);
                            filled = TRUE;
                          }

                       break;
                     }
                }
          }
     }

  if ( !filled )
     {
       CNetCmd t(env.GetCmdId());
       env = t; //clear
     }
}


void CServer::GetCopyOfAllEnv(CNetCmd &out)
{
  CCSGuard g(o_cs);

  CNetCmd buff(out.GetCmdId());

  int count = 0;

  buff.AddInt(count); //reserve for count
  if ( p_env->GetCmdBuffSize() )
     {
       buff.AddInt(p_env->GetCmdBuffSize());
       buff.AddBuff(p_env->GetCmdBuffPtr(),p_env->GetCmdBuffSize());
       count++;
     }
  
  CNetCmd env(NETCMD_GETENV_ACK); //out of loop
  for ( TClients::const_iterator it = clients.begin(); it != clients.end(); ++it )
      {
        const CClient *cl = *it;
        if ( cl->IsActive() && cl->IsClassKnown()/*really?*/ )
           {
             cl->GetCopyOfEnv(env);

             if ( env.GetCmdBuffSize() )
                {
                  buff.AddInt(env.GetCmdBuffSize());
                  buff.AddBuff(env.GetCmdBuffPtr(),env.GetCmdBuffSize());
                  count++;
                }
           }
      }

  *(int*)buff.GetCmdBuffPtr() = count; //set correct count value
  out = buff;
}


int CServer::GetNumActiveUsers()
{
  CCSGuard g(o_cs);

  int find = 0;
  for ( TClients::const_iterator it = clients.begin(); it != clients.end(); ++it )
      {
        const CClient *cl = *it;
        if ( cl->IsActive() && cl->IsUser() )
           {
             find++;
           }
      }

  return find;
}


int CServer::GetNumActiveComputers()
{
  CCSGuard g(o_cs);

  int find = 0;
  for ( TClients::const_iterator it = clients.begin(); it != clients.end(); ++it )
      {
        const CClient *cl = *it;
        if ( cl->IsActive() && cl->IsComputer() )
           {
             find++;
           }
      }

  return find;
}


BOOL CServer::CanAddNewClass(const char *new_class,int ip,BOOL is_operator_shell)
{
  BOOL rc = TRUE;

  if ( !IsStrEmpty(new_class) )
     {
       if ( !lstrcmpi(new_class,NETCLASS_USER) )
          {
            BOOL license_with_mo = (StrStrI(p_env->GetParmAsString(NETPARM_S_LICFEATURES,""),"Server") != NULL);

            if ( is_operator_shell && !license_with_mo )
               {
                 rc = FALSE;
               }
            else
               {
                 rc = (GetNumActiveUsers() < p_env->GetParmAsInt(NETPARM_I_LICMACHINES) + 1/*!!!*/);
                 // здесь может возникнуть ситуация, когда сервер еще не знает про отключение клиента и
                 // этот клиент подключается снова (например, когда нажали Reset на клиентской машине),
                 // в итоге можем получить "мертвые души" и как итог - "живому" клиенту может быть отказано
                 // потому добавляем символическую единичку, хотя проблемы это не решит
                 // todo: изменить как-то это
               }
          }
       else
       if ( !lstrcmpi(new_class,NETCLASS_OPERATOR) )
          {
            //todo: check 'ip' here for only allowed ip's
            rc = TRUE;
          }
       else
       if ( !lstrcmpi(new_class,NETCLASS_COMPUTER) )
          {
            rc = (GetNumActiveComputers() < p_env->GetParmAsInt(NETPARM_I_LICMACHINES) + 1/*!!!*/);
            // здесь может возникнуть ситуация, когда сервер еще не знает про отключение клиента и
            // этот клиент подключается снова (например, когда нажали Reset на клиентской машине),
            // в итоге можем получить "мертвые души" и как итог - "живому" клиенту может быть отказано
            // потому добавляем символическую единичку, хотя проблемы это не решит
            // todo: изменить как-то это
          }
     }

  return rc;
}


void CServer::DoHeapCompact(unsigned &last_time)
{
  if ( GetTickCount() - last_time > 5*60*1000 )
     {
       HeapCompact(GetProcessHeap(),0);
       last_time = GetTickCount();
     }
}


void CServer::DoClientsCleanup(unsigned &last_time)
{
  if ( GetTickCount() - last_time > 30*1000 )
     {
       CCSGuard g(o_cs);
       
       do {
         BOOL deleted = FALSE;

         for ( TClients::iterator it = clients.begin(); it != clients.end(); ++it )
             {
               if ( !(*it)->IsActive() )
                  {
                    delete *it;
                    clients.erase(it);
                    deleted = TRUE;
                    break;
                  }
             }

         if ( !deleted )
            break;

       } while ( 1 );
       
       last_time = GetTickCount();
     }
}


void CServer::GetClientUpdateList(BOOL is_no_shell,CNetCmd &out)
{
  CCSGuard g(o_cs);

  CUpdate* p_upd = is_no_shell ? p_client_update_no_shell : p_client_update;
  unsigned& last_time = is_no_shell ? last_client_update_no_shell_time : last_client_update_time;


  if ( GetTickCount() - last_time >= CLIENT_UPDATE_DELTA )
     {
       TryRefreshClientUpdateCacheNoGuard(is_no_shell);
       last_time = GetTickCount();
     }

        //FILE *ff = fopen("c:\\list.txt","wt");

  for ( int n = 0; n < p_upd->GetCount(); n++ )
      {
        const CUpdate::CCachedFile &f = (*p_upd)[n];

        unsigned id = f.GetId();
        const char *path = f.GetPath();
        const char *crc32 = f.GetCRC32();

        char s[MAX_PATH];
        
        wsprintf(s,"%s%d",NETPARM_I_ID_X,n);
        out.AddIntParm(s,id);
        wsprintf(s,"%s%d",NETPARM_S_PATH_X,n);
        out.AddStringParm(s,path);
        wsprintf(s,"%s%d",NETPARM_S_CRC32_X,n);
        out.AddStringParm(s,crc32);

        //fprintf(ff,"%08X \"%s\" [%s]\n",id,path,crc32);
      }

      //fclose(ff);
}


void CServer::TryRefreshClientUpdateCacheNoGuard(BOOL is_no_shell)
{
  CUpdate* p_upd = is_no_shell ? p_client_update_no_shell : p_client_update;

  CDBObj::TStringPairVector v;
  
  if ( p_db->GetClientUpdateOrderedList(is_no_shell,v) )
     {
       if ( v.size() > 0 )  //ignore empty list
          {
            BOOL equ = FALSE;
            
            if ( p_upd->GetCount() == v.size() )
               {
                 equ = TRUE;
                 
                 for ( int n = 0; n < v.size(); n++ )
                     {
                       const CUpdate::CCachedFile &f = (*p_upd)[n];
                       if ( lstrcmpi(f.GetPath(),v[n].first) || lstrcmpi(f.GetCRC32(),v[n].second) )
                          {
                            equ = FALSE;
                            break;
                          }
                     }
               }

            if ( !equ )
               {
                 p_upd->Clear();

                 for ( int n = 0; n < v.size(); n++ )
                     {
                       p_upd->Add(v[n].second,v[n].first);
                     }
               }

            // we are responsible to free list
            for ( int n = 0; n < v.size(); n++ )
                {
                  sys_free(v[n].first);
                  sys_free(v[n].second);
                }
            v.clear();
          }
     }
}


void CServer::GetClientUpdateFiles(BOOL is_no_shell,const CNetCmd &in,CNetCmd &out)
{
  CCSGuard g(o_cs);

  CUpdate* p_upd = is_no_shell ? p_client_update_no_shell : p_client_update;

  // retrieve list of requested ids
  std::vector<unsigned> ids;
  for ( int n = 0; ; n++ )
      {
        char s[MAX_PATH];
        wsprintf(s,"%s%d",NETPARM_I_ID_X,n);
        int id1 = in.GetParmAsInt(s,-1);
        int id2 = in.GetParmAsInt(s,0);
        if ( id1 != id2 )
           break;

        unsigned id = id1;
        ids.push_back(id);
      }

  if ( ids.size() == 0 )
     return;

  // check if all ids are present in cache
  for ( int n = 0; n < ids.size(); n++ )
      {
        unsigned id = ids[n];

        BOOL find = FALSE;
        for ( int j = 0; j < p_upd->GetCount(); j++ )
            {
              if ( (*p_upd)[j].GetId() == id )
                 {
                   find = TRUE;
                   break;
                 }
            }

        if ( !find )
           return;
      }

  // try to load data for all ids to cache (if needed)
  for ( int n = 0; n < ids.size(); n++ )
      {
        unsigned id = ids[n];

        CUpdate::CCachedFile *f = NULL;
        for ( int j = 0; j < p_upd->GetCount(); j++ )
            {
              if ( (*p_upd)[j].GetId() == id )
                 {
                   f = &(*p_upd)[j];
                   break;
                 }
            }

        if ( !f )
           return; //assert

        if ( !f->IsDataLoaded() )
           {
             unsigned fsize = 0;
             void* fbuff = p_db->GetClientUpdateFile(is_no_shell,f->GetPath(),f->GetCRC32(),&fsize);
             if ( !fbuff )
                {
                  TryRefreshClientUpdateCacheNoGuard(is_no_shell);
                  return;
                }

             f->LoadData(fbuff,fsize);
             sys_free(fbuff);
           }
      }

        //FILE *ff = fopen("c:\\files.txt","wt");
        //unsigned total_size = 0;

  // fill out buff with data
  for ( int n = 0; n < ids.size(); n++ )
      {
        unsigned id = ids[n];

        const CUpdate::CCachedFile *f = NULL;
        for ( int j = 0; j < p_upd->GetCount(); j++ )
            {
              if ( (*p_upd)[j].GetId() == id )
                 {
                   f = &(*p_upd)[j];
                   break;
                 }
            }

        if ( !f || !f->IsDataLoaded() )
           return; //assert

        out += id;               // id
        out += f->GetPath();     // path
        out += f->GetCRC32();    // crc32
        out += f->GetBuffSize(); // data_size
        out.AddBuff(f->GetBuffPtr(),f->GetBuffSize()); // data

        //total_size += f->GetBuffSize();

        //fprintf(ff,"%08X \"%s\" [%s] %d ...\n",id,f->GetPath(),f->GetCRC32(),f->GetBuffSize());
      }

      //fprintf(ff,"%d added with %d KB total size",ids.size(),total_size/1024);

      //fclose(ff);
}

