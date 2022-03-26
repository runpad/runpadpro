
#include "include.h"

#include "actions_envlist.inc"
#include "actions_wol.inc"
#include "fid.inc"



void SendCmd2List(const CNetCmd &cmd,const TENVENTRY *list,int listcount)
{
  for ( int n = 0; n < listcount; n++ )
      {
        NetSend(cmd,list[n].guid);
      }
}


BOOL IsMyIPPresentInList(const TENVENTRY *list,int listcount)
{
  BOOL find = FALSE;
  
  for ( int n = 0; n < listcount; n++ )
      if ( !IsStrEmpty(list[n].ip) && IsMyIP(list[n].ip) )
         {
           find = TRUE;
           break;
         }

  return find;
}


void ExecFunction(int fid,const TENVENTRY *list,int listcount)
{
  if ( list && listcount > 0 )
     {
       switch ( fid )
       {
         case FID_SHUTDOWN:
         case FID_REBOOT:
         case FID_LOGOFF:
         {
           BOOL is_hard = FALSE;
           if ( gui->ForceConfirmBox(&is_hard) )
              {
                CNetCmd cmd(fid==FID_REBOOT?NETCMD_REBOOT:(fid==FID_SHUTDOWN?NETCMD_SHUTDOWN:NETCMD_LOGOFF));
                cmd.AddBoolParm(NETPARM_B_FORCE,is_hard);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_HIBERNATE:
         case FID_SUSPEND:
         {
           BOOL is_hard = FALSE;
           if ( gui->ForceConfirmBox(&is_hard) )
              {
                CNetCmd cmd(fid==FID_HIBERNATE?NETCMD_HIBERNATE:NETCMD_SUSPEND);
                cmd.AddBoolParm(NETPARM_B_FORCE,is_hard);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_KILLALL:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRM_KILLALLTASKS) )
              SendCmd2List(CNetCmd(NETCMD_KILLALLTASKS),list,listcount);
           break;
         }

         case FID_SENDMESSAGE:
         {
           char text[MAX_PATH] = "";
           int delay = 10;
           if ( gui->SendMessageBox(text,sizeof(text)-1,&delay) )
              {
                CNetCmd cmd(NETCMD_TEXTMESSAGE);
                cmd.AddIntParm(NETPARM_I_DELAY,delay);
                cmd.AddStringParm(NETPARM_S_TEXT,text);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_TURNMONITORON:
         {
           CNetCmd cmd(NETCMD_MONITORON);
           SendCmd2List(cmd,list,listcount);
           break;
         }

         case FID_TURNMONITOROFF:
         {
           CNetCmd cmd(NETCMD_MONITOROFF);
           SendCmd2List(cmd,list,listcount);
           break;
         }

         case FID_UNBLOCK:
         {
           CNetCmd cmd(NETCMD_UNBLOCKMACHINE);
           SendCmd2List(cmd,list,listcount);
           break;
         }

         case FID_BLOCK:
         {
           CNetCmd cmd(NETCMD_BLOCKMACHINE);
           SendCmd2List(cmd,list,listcount);
           break;
         }

         case FID_RESTOREVMODE:
         {
           CNetCmd cmd(NETCMD_VMODERESTORE);
           SendCmd2List(cmd,list,listcount);
           break;
         }

         case FID_SOMEINFOCOMP:
         case FID_SOMEINFOUSER:
         {
           SendCmd2List(CNetCmd(NETCMD_SOMEINFO_REQ),list,listcount);
           CCollector::Start<CMachinesInfoCollector>(list,listcount);
           break;
         }

         case FID_EXECSTAT:
         {
           SendCmd2List(CNetCmd(NETCMD_EXECSTAT_REQ),list,listcount);
           CCollector::Start<CExecStatCollector>(list,listcount);
           break;
         }

         case FID_SCREEN:
         {
           SendCmd2List(CNetCmd(NETCMD_SCREEN_REQ),list,listcount);
           CCollector::Start<CScreenCollector>(list,listcount);
           break;
         }

         case FID_WEBCAM:
         {
           SendCmd2List(CNetCmd(NETCMD_WEBCAM_REQ),list,listcount);
           CCollector::Start<CWebcamCollector>(list,listcount);
           break;
         }

         case FID_SCREENCONTROL:
         case FID_WEBCAMCONTROL:
         {
           if ( listcount == 1 )
              {
                vscontrol->Open(NULL,fid==FID_WEBCAMCONTROL,&list[0]);
              }
           break;
         }

         case FID_TURNSHELLON:
         case FID_TURNSHELLOFF:
         {
           BOOL all_users = TRUE;
           char domain[MAX_PATH] = "";
           char login[MAX_PATH] = "";
           char pwd[MAX_PATH] = "";
           if ( gui->TurnShellBox(fid==FID_TURNSHELLON,&all_users,domain,login,pwd) )
              {
                if ( fid == FID_TURNSHELLON )
                   {
                     // special check for self
                     if ( IsMyIPPresentInList(list,listcount) )
                        {
                          if ( !gui->ConfirmYesNoWarn(S_TURNSHELLFORSELFCONFIRM) )
                             break;
                        }
                   }
                
                CNetCmd cmd(fid==FID_TURNSHELLON?NETCMD_ONSHELL:NETCMD_OFFSHELL);
                cmd.AddBoolParm(NETPARM_B_ALLUSERS,all_users);
                cmd.AddStringParm(NETPARM_S_DOMAIN,domain);
                cmd.AddStringParm(NETPARM_S_USERNAME,login);
                cmd.AddStringParm(NETPARM_S_PASSWORD,pwd);
                SendCmd2List(cmd,list,listcount);

                gui->MsgBox(fid==FID_TURNSHELLON?S_TURNSHELLONLOGOFF:S_TURNSHELLOFFLOGOFF);
              }
           break;
         }

         case FID_TURNCURRENTSHELLOFF:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRM_OFFSHELL) )
              SendCmd2List(CNetCmd(NETCMD_OFFSHELL),list,listcount);
           break;
         }

         case FID_TEMPTURNSHELLOFF:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRM_TEMPOFFSHELL) )
              SendCmd2List(CNetCmd(NETCMD_TEMPOFFSHELL),list,listcount);
           break;
         }

         case FID_TURNAUTOLOGONON:
         {
           char domain[MAX_PATH] = "";
           char login[MAX_PATH] = "";
           char pwd[MAX_PATH] = "";
           BOOL force = TRUE;
           if ( gui->AutoLogonBox(domain,login,pwd,&force) )
              {
                CNetCmd cmd(NETCMD_ONAUTOLOGON);
                cmd.AddBoolParm(NETPARM_B_FORCE,force);
                cmd.AddStringParm(NETPARM_S_DOMAIN,domain);
                cmd.AddStringParm(NETPARM_S_USERNAME,login);
                cmd.AddStringParm(NETPARM_S_PASSWORD,pwd);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_TURNAUTOLOGONOFF:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRM_OFFAUTOLOGON) )
              SendCmd2List(CNetCmd(NETCMD_OFFAUTOLOGON),list,listcount);
           break;
         }

         case FID_TIMESYNC:
         {
           SYSTEMTIME st;
           GetLocalTime(&st);

           char s[MAX_PATH];
           wsprintf(s,S_CONFIRMTIMESYNC,st.wDay,st.wMonth,st.wYear,st.wHour,st.wMinute);
           if ( gui->ConfirmOkCancel(s) )
              {
                SYSTEMTIME st;
                GetLocalTime(&st);

                CNetCmd cmd(NETCMD_TIMESYNC);
                cmd.AddIntParm(NETPARM_I_YEAR,st.wYear);
                cmd.AddIntParm(NETPARM_I_MONTH,st.wMonth);
                cmd.AddIntParm(NETPARM_I_DAY,st.wDay);
                cmd.AddIntParm(NETPARM_I_HOUR,st.wHour);
                cmd.AddIntParm(NETPARM_I_MINUTE,st.wMinute);
                cmd.AddIntParm(NETPARM_I_SECOND,st.wSecond);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_CLEAREXECSTAT:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRMCLEAREXECSTAT) )
              {
                CNetCmd cmd(NETCMD_EXECSTATCLEAR);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_EXECUTECMDLINE:
         {
           char path[MAX_PATH] = "";
           if ( gui->ExecCmdLineBox(path) )
              {
                CNetCmd cmd(NETCMD_NETRUN);
                cmd.AddStringParm(NETPARM_S_CMDLINE,path);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_EXECUTEREG:
         {
           char path[MAX_PATH] = "";
           if ( gui->ExecRegFileBox(path) )
              {
                CNetCmd cmd(NETCMD_NETRUN);
                cmd.AddStringParm(NETPARM_S_FILENAME,path);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_EXECUTEBAT:
         {
           char path[MAX_PATH] = "";
           if ( gui->ExecBatFileBox(path) )
              {
                CNetCmd cmd(NETCMD_NETRUN);
                cmd.AddStringParm(NETPARM_S_FILENAME,path);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_COPYFILES:
         {
           char from[MAX_PATH] = "";
           char to[MAX_PATH] = "";
           BOOL killtasks = FALSE;
           if ( gui->CopyFilesBox(from,to,&killtasks) )
              {
                CNetCmd cmd(NETCMD_COPYFILES);
                cmd.AddBoolParm(NETPARM_B_KILLTASKS,killtasks);
                cmd.AddStringParm(NETPARM_S_FROM,from);
                cmd.AddStringParm(NETPARM_S_TO,to);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_DELETEFILES:
         {
           if ( gui->ConfirmOkCancel(S_CONFIRMDELETEFILES) )
              {
                BOOL killtasks = gui->ConfirmYesNo(S_CONFIRMKILLTASKS);
                
                CNetCmd cmd(NETCMD_DELETEFILES);
                cmd.AddBoolParm(NETPARM_B_KILLTASKS,killtasks);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_RFM:
         {
           char path[MAX_PATH];
           GetLocalPath(APP_RFM,path);
           
           if ( !IsFileExist(path) )
              {
                gui->WarnBox(S_APPNOTINSTALLED);
              }
           else
              {
                BOOL empty_find = FALSE;
                for ( int n = 0; n < listcount; n++ )
                    {
                      if ( !list[n].is_rfm )
                         {
                           empty_find = TRUE;
                           break;
                         }
                    }

                if ( empty_find )
                   {
                     if ( !gui->ConfirmOkCancel(S_NORFMATALL) )
                        break;
                   }

                CDynBuff cmd;
                cmd.AddStringNoTerm("\"");
                cmd.AddStringNoTerm(path);
                cmd.AddStringNoTerm("\"");
                
                BOOL service_find = FALSE;
                for ( int n = 0; n < listcount; n++ )
                    {
                      if ( list[n].is_rfm && !IsStrEmpty(list[n].ip) )
                         {
                           service_find = TRUE;
                           cmd.AddStringNoTerm(" ");
                           cmd.AddStringNoTerm(list[n].ip);
                         }
                    }

                cmd.AddStringSZ(""); //zero terminator

                if ( service_find )
                   {
                     RunProcess(cmd,our_currpath);
                   }
              }
           break;
         }

         case FID_RD:
         {
           char path[MAX_PATH];
           GetLocalPath(APP_RD,path);
           
           if ( !IsFileExist(path) )
              {
                gui->WarnBox(S_APPNOTINSTALLED);
              }
           else
              {
                if ( listcount == 1 )
                   {
                     if ( !list[0].is_rd )
                        {
                          gui->WarnBox(S_RDNOTINSTALLEDONMACHINE);
                        }
                     else
                        {
                          const char *ip = list[0].ip;
                          
                          if ( !IsStrEmpty(ip) )
                             {
                               char cmd[MAX_PATH];

                               wsprintf(cmd,"\"%s\" %s",path,ip);
                               RunProcess(cmd,our_currpath);
                             }
                        }
                   }
              }
           break;
         }

         case FID_CLIENTUPDATE:
         {
           BOOL is_imm = FALSE;
           BOOL is_force = FALSE;
           if ( gui->ClientUpdateBox(&is_imm,&is_force) )
              {
                // special check for self
                if ( is_imm && IsMyIPPresentInList(list,listcount) )
                   {
                     if ( !gui->ConfirmOkCancel(S_CLIENTUPDATEFORSELFCONFIRM) )
                        break;

                     is_imm = FALSE;
                     is_force = FALSE;
                   }
                
                if ( listcount > 10 )
                   {
                     if ( !gui->ConfirmYesNo(S_CLIENTUPDATEMAX) )
                        break;
                   }
                
                CNetCmd cmd(NETCMD_CLIENTUPDATEPROPOSITION);
                cmd.AddBoolParm(NETPARM_B_IMMEDIATELY,is_imm);
                cmd.AddBoolParm(NETPARM_B_FORCE,is_force);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_CLIENTUNINSTALL:
         {
           BOOL is_imm = FALSE;
           BOOL is_force = FALSE;
           if ( gui->ClientUninstallBox(&is_imm,&is_force) )
              {
                CNetCmd cmd(NETCMD_CLIENTUNINSTALL);
                cmd.AddBoolParm(NETPARM_B_IMMEDIATELY,is_imm);
                cmd.AddBoolParm(NETPARM_B_FORCE,is_force);
                SendCmd2List(cmd,list,listcount);
              }
           break;
         }

         case FID_RLBINFO:
         {
           SendCmd2List(CNetCmd(NETCMD_ROLLBACKINFO_REQ),list,listcount);
           CCollector::Start<CRollbackInfoCollector>(list,listcount);
           break;
         }

         case FID_RLBSAVE1:
         {
           if ( gui->ConfirmOkCancel(S_RLBSAVE1CONFIRM) )
              {
                SendCmd2List(CNetCmd(NETCMD_RLBSAVE1),list,listcount);
              }
           break;
         }

         case FID_RLBSAVE2:
         {
           if ( gui->ConfirmOkCancel(S_RLBSAVE2CONFIRM) )
              {
                SendCmd2List(CNetCmd(NETCMD_RLBSAVE2),list,listcount);
              }
           break;
         }

         case FID_RLBHELP:
         {
           gui->MsgBox(S_RLBHELP);
           break;
         }

       };
     }
}


void ProcessReceivedCmd(const CNetCmd &cmd,unsigned src_guid)
{
  switch ( cmd.GetCmdId() )
  {
    case NETCMD_GETALLENV_ACK:
    {
      UpdateEnvList(cmd.GetCmdBuffPtr(),cmd.GetCmdBuffSize());
      break;
    }

    case NETCMD_VIDEOCONTROL_ACK:
    case NETCMD_SCREENCONTROL_ACK:
    {
      vscontrol->IncomingScreen(cmd,src_guid);
      break;
    }
  
    case NETCMD_CALLOPERATOR_REQ:
    {
      alerts->Add<CAlertCallOperator>(cmd,src_guid);
      break;
    }

    case NETCMD_NETBURN_REQ:
    {
      alerts->Add<CAlertNetBurn>(cmd,src_guid);
      break;
    }

    case NETCMD_NETBT_REQ:
    {
      alerts->Add<CAlertNetBT>(cmd,src_guid);
      break;
    }

    case NETCMD_SOMEINFO_ACK:
    case NETCMD_ROLLBACKINFO_ACK:
    case NETCMD_SCREEN_ACK:
    case NETCMD_WEBCAM_ACK:
    case NETCMD_EXECSTAT_ACK:
    {
      CCollector::AppendData(cmd,src_guid);
      break;
    }

  };
}

