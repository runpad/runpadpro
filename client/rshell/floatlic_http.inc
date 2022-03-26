


class CHttpRequest
{
          MSXML2::IXMLHTTPRequestPtr m_req;

  public:
          CHttpRequest(const char *url,const char *method="GET",bool async=true);
          ~CHttpRequest();

          BOOL IsCompleted();
          int GetHttpStatus();
          MSXML2::IXMLDOMDocumentPtr GetResponseAsXML();
};



CHttpRequest::CHttpRequest(const char *url,const char *method,bool async)
{
  try
  {
    m_req.CreateInstance("Msxml2.XMLHTTP");
    if ( m_req )
       {
         if ( m_req->open(NNS(method),NNS(url),async) == S_OK )
            {
              m_req->send();
            }
       }
  }
  catch(_com_error &e)
  {
  }
}


CHttpRequest::~CHttpRequest()
{
}


BOOL CHttpRequest::IsCompleted()
{
  BOOL rc = FALSE;
  
  try
  {
    if ( m_req )
       {
         rc = (m_req->readyState == 4);
       }
  }
  catch(_com_error &e)
  {
  }

  return rc;
}


int CHttpRequest::GetHttpStatus()
{
  int rc = -1;
  
  try
  {
    if ( m_req )
       {
         rc = m_req->status;
       }
  }
  catch(_com_error &e)
  {
  }

  return rc;
}


MSXML2::IXMLDOMDocumentPtr CHttpRequest::GetResponseAsXML()
{
  MSXML2::IXMLDOMDocumentPtr rc = NULL;
  
  try
  {
    if ( m_req )
       {
         rc = m_req->responseXML;
       }
  }
  catch(_com_error &e)
  {
  }

  return rc;
}



///////////////////////



class CHttpRequestAsyncNoAnswer
{
          struct TInfo {
           std::string url;
           std::string method;
          };

  public:
          static void Execute(const char *url,const char *method="GET");

  private:
          static DWORD WINAPI ThreadProc(void*);

};



void CHttpRequestAsyncNoAnswer::Execute(const char *url,const char *method)
{
  TInfo *i = new TInfo();
  i->url = NNS(url);
  i->method = NNS(method);

  HANDLE h_thread = MyCreateThreadSelectedCPU(ThreadProc,i);
  CloseHandle(h_thread);
}


DWORD WINAPI CHttpRequestAsyncNoAnswer::ThreadProc(void *parm)
{
  TInfo *i = (TInfo*)parm;
  if ( i )
     {
       CoInitialize(0);

       {
         CHttpRequest r(i->url.c_str(),i->method.c_str(),false);
       }

       CoUninitialize();

       delete i;
     }

  return 1;
}



