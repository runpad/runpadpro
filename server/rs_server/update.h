
#ifndef __UPDATE_H__
#define __UPDATE_H__

#include <vector>


class CUpdate
{
  protected:
          friend class CServer;
          
          class CCachedFile
          {
                    unsigned u_id;
                    char *s_crc32;
                    char *s_path;
                    void *p_buff;
                    unsigned u_size;

            public:
                    CCachedFile(unsigned _id,const char *_crc32,const char *_path);
                    ~CCachedFile();

                    unsigned GetId() const { return u_id; }
                    const char* GetCRC32() const { return s_crc32; }
                    const char* GetPath() const { return s_path; }
                    const void* GetBuffPtr() const { return p_buff; }
                    unsigned GetBuffSize() const { return u_size; }
                    BOOL IsDataLoaded() const { return p_buff != NULL; }
                    void LoadData(const void* _buff,unsigned _size);

          };

  private:
          typedef std::vector<CCachedFile*> TFiles;
          TFiles m_files;

          unsigned session_id;

  public:
          CUpdate();
          ~CUpdate();

          void Clear();
          void Add(const char *_crc32,const char *_path);
          unsigned GetCount() const { return m_files.size(); }

          const CCachedFile& operator [] (unsigned idx) const { return *m_files[idx]; }
          const CCachedFile& operator [] (int idx) const { return *m_files[idx]; }
          CCachedFile& operator [] (unsigned idx) { return *m_files[idx]; }
          CCachedFile& operator [] (int idx) { return *m_files[idx]; }

};



#endif
