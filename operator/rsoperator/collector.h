
#ifndef __COLLECTOR_H__
#define __COLLECTOR_H__



class CCollector
{
  protected:
          typedef std::vector<TENVENTRY> TTargetList;
          typedef std::vector<unsigned> TRecvdList;

  private:        
          static CCollector* g_collector;
          
          TTargetList targets; // need to recv all of them
          TRecvdList recvd;  //list of received guids

          int m_cmdid; //only this command is to be accepted

  public:
          CCollector(int accept_cmd_id,const TENVENTRY *list,unsigned listcount);
          virtual ~CCollector();

          template< class _T >
          static inline void Start(const TENVENTRY *list,unsigned listcount);
          static inline void AppendData(const CNetCmd &cmd,unsigned src_guid);

          void ShowDialog();
          void Append(const CNetCmd &cmd,unsigned src_guid);
          void Finish();

  protected:
          virtual void OnDataAccepted(const CNetCmd &cmd,unsigned src_guid) = 0;
          virtual void OnFinish() = 0;

  private:
          static BOOL CALLBACK DialogProcWrapper(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);
          BOOL DialogProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam);

  protected:
          const TTargetList& GetTargetList();
          const TRecvdList& GetRecvdList();
};



class CHTMLCollector : public CCollector
{
          typedef std::vector<char*> TFields;
          typedef std::vector<char*> TRecord;
          typedef std::pair<TRecord*,const TENVENTRY*> TDataSetEntry;
          typedef std::vector<TDataSetEntry> TDataSet;

          std::vector< std::pair<CNetCmd,unsigned> > recvd;
          char *m_title;

  public:
          CHTMLCollector(const char *title,int accept_cmd_id,const TENVENTRY *list,unsigned listcount);
          ~CHTMLCollector();

  protected:
          virtual void OnDataAccepted(const CNetCmd &cmd,unsigned src_guid);
          virtual void OnFinish();

  private:
          int CompareEnvs(const TENVENTRY *e1,const TENVENTRY *e2);
          BOOL WriteHTML(const char *filename,const char *title,const TFields &fields,const TDataSet &dataset);
          BOOL IsFieldNeedParsing(const TFields &fields,int idx);

};


class CMachinesInfoCollector : public CHTMLCollector
{
  public:
          CMachinesInfoCollector(const TENVENTRY *list,unsigned listcount)
           : CHTMLCollector(S_TITLE_MACHINESINFO,NETCMD_SOMEINFO_ACK,list,listcount) {}
};


class CRollbackInfoCollector : public CHTMLCollector
{
  public:
          CRollbackInfoCollector(const TENVENTRY *list,unsigned listcount)
           : CHTMLCollector(S_TITLE_ROLLBACKINFO,NETCMD_ROLLBACKINFO_ACK,list,listcount) {}
};


class CPicCollector : public CHTMLCollector
{
          char *m_parm_name;
  
  public:
          CPicCollector(const char *title,const char *parm_name,int accept_cmd_id,const TENVENTRY *list,unsigned listcount);
          ~CPicCollector();

  protected:
          virtual void OnDataAccepted(const CNetCmd &cmd,unsigned src_guid);
};


class CScreenCollector : public CPicCollector
{
  public:
          CScreenCollector(const TENVENTRY *list,unsigned listcount)
           : CPicCollector(S_TITLE_SCREENS,S_NETPARM_SCREEN,NETCMD_SCREEN_ACK,list,listcount) {}

};


class CWebcamCollector : public CPicCollector
{
  public:
          CWebcamCollector(const TENVENTRY *list,unsigned listcount)
           : CPicCollector(S_TITLE_WEBCAMS,S_NETPARM_WEBCAM,NETCMD_WEBCAM_ACK,list,listcount) {}

};


class CExecStatCollector : public CCollector
{
          void *m_file;
          char m_filename[MAX_PATH];

  public:
          CExecStatCollector(const TENVENTRY *list,unsigned listcount);
          ~CExecStatCollector();

  protected:
          virtual void OnDataAccepted(const CNetCmd &cmd,unsigned src_guid);
          virtual void OnFinish();

  private:
          int GetNumberFromString(const char *s,int def);
};





#include "collector.hpp"


#endif

