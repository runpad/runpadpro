
#ifndef __UPDATE_H__
#define __UPDATE_H__


#include <vector>


class CConfigurator;
class CNetObj;


class CUpdate
{
          class CUpdateFile
          {
                    unsigned u_id;
                    char *s_envpath;
                    char *s_fullpath;
                    char *s_basedir;
                    char *s_crc32;
                    void *p_buff;
                    unsigned u_size;
                    unsigned u_tag;

            public:
                    CUpdateFile( unsigned _id,
                                 const char *_envpath,
                                 const char *_fullpath,
                                 const char *_basedir,
                                 const char *_crc32);
                    ~CUpdateFile();

                    unsigned GetId() const { return u_id; }
                    const char* GetEnvPath() const { return s_envpath; }
                    const char* GetFullPath() const { return s_fullpath; }
                    const char* GetBaseDir() const { return s_basedir; }
                    const char* GetCRC32() const { return s_crc32; }
                    const void* GetBuffPtr() const { return p_buff; }
                    unsigned GetBuffSize() const { return u_size; }
                    unsigned GetTag() const { return u_tag; }

                    void SetTag(unsigned _tag) { u_tag = _tag; }
                    BOOL LoadData(const void *buff,unsigned size);
          };
          
          enum {
           STATE_READY,
           STATE_WAITLIST,
           STATE_WAITFILES,
           STATE_FINISH,
          };
          
          int g_state;
          BOOL b_reboot_after_finish;
          BOOL b_force_reboot;

          typedef std::vector<CUpdateFile*> TUpdateFiles;
          TUpdateFiles g_files;


  public:
          CUpdate();
          ~CUpdate();

          void StartupActions();
          
          BOOL OnProposition(const CNetCmd &cmd_in,CNetCmd &cmd_out);
          BOOL OnListAck(const CNetCmd &cmd_in,CNetCmd &cmd_out);
          BOOL OnFilesAck(const CNetCmd &cmd_in,CConfigurator *cfg,CNetObj *net_obj);
  
  private:
          BOOL GetCUnsigned(const char* &src,unsigned &src_size,unsigned *p_value);
          BOOL GetCString(const char* &src,unsigned &src_size,const char **p_value,int max);
          BOOL GetCBuff(const char* &src,unsigned &src_size,const void **p_value,unsigned buff_size);
          void FreeFiles();
          BOOL IsUpdateFinishFlag();
          void SetUpdateFinishFlag();
          void ClearUpdateFinishFlag();
          BOOL ExpandEnvPath(const char *envpath,char *_fullpath,char *_basedir);
          BOOL GetFileCRC32(const char *fullpath,char *_crc32);
          void CleanDirNoRec(const char *dir);

};


#endif

