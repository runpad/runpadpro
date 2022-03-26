

void WriteConfig4BodyTools()
{
  CfgWriteBWCConfig();
  WriteRegDword(HKCU,REGPATH,"curr_lang",curr_lang);
}


void ClearSettingsCacheForAllUsers()
{
  char s[MAX_PATH] = "";
  GetConfigCacheDir4AllUsers(s);
  if ( s[0] )
     {
       CleanDir(s);
     }
}



void ReadConfig()
{
  // set base vars (I don't know why is here...)
  SetSingleEnvVar("RS_FOLDER",our_currpath,TRUE);
  SetSingleEnvVar("RS_MACHINE",machine_desc);
  SetSingleEnvVar("RS_LOC",machine_loc);


  BOOL b_connected = FALSE;
  BOOL b_licfeat_received = FALSE;
  BOOL b_settings_received = FALSE;

  char err_string[MAX_PATH*2] = "";
  int err_msg = 3230;  // err connecting to server

  if ( 1 )
     {
       // connect to server
       AboutBoxUpdateProgress(LS(3014));
       unsigned starttime = GetTickCount();
#ifndef DEBUG
       unsigned timeout = (machine_type == MACHINE_TYPE_OPERATOR || machine_type == MACHINE_TYPE_HOME) ? (is_vista?70000:40000) : 8000;
#else
       unsigned timeout = 3000;
#endif
       do {
        if ( IsNetConnectEvent() )
           {
             b_connected = TRUE;
             break;
           }
        Sleep(20);
       } while ( GetTickCount() - starttime < timeout );

       if ( !b_connected )
          {
            unsigned char s_ip[4];
            *(int*)s_ip = NetGetServerIP();

            int err = NetGetLastWinsockErrorNonRepresentative();
            
            wsprintf(err_string,"%s (%d.%d.%d.%d, err: %d)",LS(err_msg),s_ip[0],s_ip[1],s_ip[2],s_ip[3],err);
            err_msg = (int)err_string;
          }
     }

  if ( b_connected )
     {
       //try to get config from server
       AboutBoxUpdateProgress(LS(3015));

       err_msg = 3231; // no response from server

       SendStaticInfoToServer();
       
       {
         CNetCmd cmd(NETCMD_GETENV_REQ);
         cmd.AddIntParm(NETPARM_I_GUID,NETGUID_SERVER);
         NetSend(cmd);
       }

       NetSend(CNetCmd(NETCMD_GETSETTINGS_REQ));

       unsigned starttime = GetTickCount();
       unsigned last_recv_time = starttime;
#ifndef DEBUG
       unsigned timeout_cmd = 10000;
       unsigned timeout_max = 45000;
#else
       unsigned timeout_cmd = 2000;
       unsigned timeout_max = 3000;
#endif

       CNetCmd cmd; //out of loop

       do {
        unsigned src_guid = NETGUID_UNKNOWN;
        if ( NetGet(cmd,&src_guid) )
           {
             if ( src_guid == NETGUID_SERVER )
                {
                  int id = cmd.GetCmdId();

                  if ( id == NETCMD_GETENV_ACK )
                     {
                       if ( cmd.GetParmAsInt(NETPARM_I_GUID,NETGUID_UNKNOWN) == NETGUID_SERVER )
                          {
                            const char *lic_organization = cmd.GetParmAsString(NETPARM_S_LICORGANIZATION,"");
                            const char *lic_owner = cmd.GetParmAsString(NETPARM_S_LICOWNER,"");
                            int lic_machines = cmd.GetParmAsInt(NETPARM_I_LICMACHINES,0);
                            const char *lic_features = cmd.GetParmAsString(NETPARM_S_LICFEATURES,"");

                            if ( lic_organization[0] && lic_machines != 0 )
                               {
                                 AboutBoxUpdateLicInfo(lic_organization,lic_machines);
                               }

                            lstrcpyn(lic_feat,lic_features,sizeof(lic_feat));
                            WriteLicFeatToCache(lic_features);
                            b_licfeat_received = TRUE;
                          }
                     }
                  else
                  if ( id == NETCMD_GETSETTINGS_OK_ACK )
                     {
                       if ( cmd.GetCmdBuffSize() > 0 )
                          {
                            CfgReadConfig(cmd.GetCmdBuffPtr(),cmd.GetCmdBuffSize(),curr_lang,machine_type);
                            WriteSettingsToCache(cmd.GetCmdBuffPtr(),cmd.GetCmdBuffSize());
                            b_settings_received = TRUE;
                            err_msg = -1; // no error
                          }
                       break; //assume that licfeat is already received
                     }
                  else
                  if ( id == NETCMD_GETSETTINGS_ERR_ACK )
                     {
                       char server_err[MAX_PATH];
                       lstrcpyn(server_err,cmd.GetParmAsString(NETPARM_S_RESULT,""),sizeof(server_err));

                       int rc = cmd.GetParmAsInt(NETPARM_I_RESULT,NETERR_SETTINGS_DBNOTREADY);

                       if ( rc == NETERR_SETTINGS_DBNOTREADY )
                          err_msg = 3232; // SQL-server isn't ready
                       else
                       if ( rc == NETERR_SETTINGS_OUTOFLICENSE )
                          err_msg = 3234; // license error
                       else
                          err_msg = 3233; // server error

                       wsprintf(err_string,"%s (%s)",LS(err_msg),server_err);
                       err_msg = (int)err_string;

                       if ( rc == NETERR_SETTINGS_DBNOTREADY )
                          {
                            if ( machine_type == MACHINE_TYPE_OPERATOR || machine_type == MACHINE_TYPE_HOME )
                               {
                                 NetSend(CNetCmd(NETCMD_GETSETTINGS_REQ));
                                 last_recv_time = GetTickCount(); //timeout for next cmd
                               }
                            else
                               break; //assume that licfeat is already received
                          }
                       else
                       if ( rc == NETERR_SETTINGS_OUTOFLICENSE )
                          {
                            break; //assume that licfeat is already received
                          }
                       else
                          {
                            // any other error
                            break; //assume that licfeat is already received
                          }
                     }
                }
           }

        if ( b_licfeat_received && b_settings_received )
           break;
        
        Sleep(20);

        if ( GetTickCount() - last_recv_time > timeout_cmd )
           break;

       } while ( GetTickCount() - starttime < timeout_max );
     }
  else
     {
       // not connected
       SendStaticInfoToServer();  //maybe server got this packet later...
     }


  if ( !b_licfeat_received )
     {
       if ( !ReadLicFeatFromCache(lic_feat,sizeof(lic_feat)) )
          {
            lstrcpy(lic_feat,"" /*"NoShell"*/ );  //default is nothing, but with Shell?
          }                       
     }

  if ( !b_settings_received )
     {
       if ( !ReadSettingsFromCache(curr_lang,machine_type) )
          {
            CfgReadConfig(NULL,0,curr_lang,machine_type); //default settings
            g_cfg_recv_type = 0;
          }
       else
          {
            g_cfg_recv_type = 1;
          }
     }
  else
     {
       g_cfg_recv_type = 2;
     }

  if ( err_msg != -1 )
     {
       const char *str = (err_msg&0xFFFF0000)?(char*)err_msg:LS(err_msg);

       lstrcpyn(g_cfg_recv_msg,str,sizeof(g_cfg_recv_msg)-1);
       
       #ifndef DEBUG
       AboutBoxUpdateProgress(str,TRUE);
       Sleep(3500);
       #endif
     }
  else
     {
       lstrcpy(g_cfg_recv_msg,"");
     }
  
  AboutBoxUpdateProgress("");
}

