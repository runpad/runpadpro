unit main;

{$I BF.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList, Buttons, BFClients,
  BFOBEXClient, BFObjectPushClient, BFServers, BFOBEXServer,
  BFObjectPushServer, BFDiscovery, BFAuthenticator, BFBase, BFAPI, lang;

type
  TBodyBTForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    LabelTitle: TLabel;
    Bevel1: TBevel;
    Panel2: TPanel;
    Panel4: TPanel;
    ButtonStop: TBitBtn;
    Panel3: TPanel;
    Label1: TLabel;
    Bevel2: TBevel;
    Panel5: TPanel;
    ImageList: TImageList;
    ListView: TListView;
    Bevel3: TBevel;
    Panel6: TPanel;
    LabelProgress: TLabel;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonStopClick(Sender: TObject);
  private
    { Private declarations }
    BFAPIInfo: TBFAPIInfo;
    BFAuthenticator: TBFAuthenticator;
    BFBluetoothDiscovery: TBFBluetoothDiscovery;
    BFObjectPushServerIrDA: TBFObjectPushServer;
    BFObjectPushServerBluetooth: TBFObjectPushServer;
    BFObjectPushClient: TBFObjectPushClient;
    recv_count : integer;
    recv_kb : integer;
    procedure BFObjectPushClientProgress(Sender: TObject; AName: String;
      Index, Count, Position, Size: Integer; var Abort: Boolean);
    procedure BFObjectPushServerBluetoothConnect(Sender: TObject);
    procedure BFObjectPushServerBluetoothDisconnect(Sender: TObject);
    procedure BFObjectPushServerBluetoothObject(Sender: TObject;
      AName: String; AObject: TBFByteArray);
    procedure BFObjectPushServerBluetoothProgress(Sender: TObject;
      AName: String; APosition, ASize: Cardinal; var AAbort: Boolean);
    procedure AddLogLine(idx:integer;text:string);
    procedure UpdateProgress(perc:integer);
    procedure Process();
    procedure NetSendProcess();
    function CopyToNetFolder(dest_folder,src_file:string):boolean;
    function UniqueFileName(folder,name,ext: string): string;
    procedure OnWorkFinish(is_send:boolean;count,size:integer;net_folder:string);
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
  public
    { Public declarations }
    procedure DefaultHandler(var Message); override;
  end;


const 
      BEGIN_MESSAGE_NAME = 'TBodyBTForm.Begin';
      MODE_NONE = 0;
      MODE_SEND = 1;
      MODE_RECV = 2;

var
  BodyBTForm: TBodyBTForm;
  user_message : cardinal = 0;
  g_mode : integer = MODE_NONE;
  g_stop : boolean = false;
  g_mobile_content : boolean = false;
  FileList : TStringList;
  DestDir : string = '';


implementation

uses commctrl, global;

{$R *.dfm}
{$INCLUDE ..\rp_shared\rp_shared.inc}


procedure TBodyBTForm.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    if msg=user_message then
      Process()
    else
      inherited;
end;

procedure TBodyBTForm.FormCreate(Sender: TObject);
var Radios: TBFBluetoothRadios;
begin
 Caption:=Application.Title;
 ButtonStop.Visible:=false;

 if g_mode=MODE_SEND then
   LabelTitle.Caption:=S_SEND
 else
   LabelTitle.Caption:=S_RECV;

 ImageList.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 1, 1);
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(101)));
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(102)));
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(103)));

 g_stop:=false;

 BFAPIInfo:=TBFAPIInfo.Create(self);

 BFAuthenticator:=TBFAuthenticator.Create(self);

 BFBluetoothDiscovery:=TBFBluetoothDiscovery.Create(self);

 BFObjectPushServerIrDA:=TBFObjectPushServer.Create(self);
 with BFObjectPushServerIrDA do
  begin
   BluetoothTransport.Service := 'OBEX Object Push';
   IrDATransport.Service := 'OBEX';
   Transport := atIrDA;
   ReadBuffer := 1024;
   WriteBuffer := 1024;
   PacketSize := 1024;
   OnConnect := BFObjectPushServerBluetoothConnect;
   OnDisconnect := BFObjectPushServerBluetoothDisconnect;
   OnObject := BFObjectPushServerBluetoothObject;
   OnProgress := BFObjectPushServerBluetoothProgress;
  end;

 BFObjectPushServerBluetooth:=TBFObjectPushServer.Create(self);
 with BFObjectPushServerBluetooth do
  begin
   BluetoothTransport.Service := 'OBEX Object Push';
   IrDATransport.Service := 'OBEX';
   ReadBuffer := 1024;
   WriteBuffer := 1024;
   PacketSize := 1024;
   OnConnect := BFObjectPushServerBluetoothConnect;
   OnDisconnect := BFObjectPushServerBluetoothDisconnect;
   OnObject := BFObjectPushServerBluetoothObject;
   OnProgress := BFObjectPushServerBluetoothProgress;
  end;

 BFObjectPushClient:=TBFObjectPushClient.Create(self);
 with BFObjectPushClient do
  begin
   BluetoothTransport.Address := '(00:00:00:00:00:00)';
   BluetoothTransport.Service := 'OBEX Object Push';
   IrDATransport.Address := '(00:00:00:00)';
   IrDATransport.Service := 'OBEX';
   ReadBuffer := 2048;
   WriteBuffer := 2048;
   PacketSize := 2048;
   OnProgress := BFObjectPushClientProgress;
  end;

 if atBluetooth in BFAPIInfo.Transports then
  begin
   try
    BFAuthenticator.Open;
   except end;

   if g_mode=MODE_RECV then
    begin
     try
      Radios := BFBluetoothDiscovery.EnumRadios;
     except 
      Radios := nil;
     end;
     if Radios<>nil then
      begin
       if Radios.Count > 0 then
        begin
         BFObjectPushServerBluetooth.BluetoothTransport.Radio := Radios[0];
         try
           BFObjectPushServerBluetooth.Open;
         except end;
        end;
       Radios.Free;
      end;
    end;
  end;

 if atIrDA in BFAPIInfo.Transports then
  begin
   if g_mode=MODE_RECV then
    begin
     try
      BFObjectPushServerIrDA.Open;
     except end;
    end;
  end;

 if g_mode=MODE_SEND then
  begin
   if not IsNetBurn then
    with BFObjectPushClient do
     begin
      try
       OpenDevice;
      except end;
     end;
  end;
end;

procedure TBodyBTForm.FormDestroy(Sender: TObject);
begin
 with BFObjectPushClient do
   if Active then
     Close;

 with BFObjectPushServerBluetooth do
   if Active then
     Close;

 with BFObjectPushServerIrDA do
   if Active then
     Close;

 with BFAuthenticator do
   if Active then
     Close;

 BFObjectPushClient.Free;
 BFObjectPushServerBluetooth.Free;
 BFObjectPushServerIrDA.Free;
 BFBluetoothDiscovery.Free;
 BFAuthenticator.Free;
 BFAPIInfo.Free;
end;

procedure TBodyBTForm.FormShow(Sender: TObject);
begin
 PostMessage(Handle,user_message,0,0);
end;

procedure TBodyBTForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if not ButtonStop.Visible then
  CanClose:=true
 else
  begin
   if not ButtonStop.Enabled then
    CanClose:=false
   else
    begin
     CanClose:=false;
     ButtonStopClick(Sender);
    end;
  end;
end;

procedure TBodyBTForm.WMQueryEndSession(var M: TWMQueryEndSession);
begin
 if ButtonStop.Visible then
  M.Result:=0
 else
  M.Result:=1;
end;

procedure TBodyBTForm.Process();
var n,sended_count,sended_kb:integer;
    s:string;
begin
 if g_mode=MODE_SEND then
  begin
   if IsNetBurn then
    begin  //net processing
     NetSendProcess();
    end
   else
    begin  //real processing
     if BFObjectPushClient.Active then
      begin
       AddLogLine(-1,S_TRANSMITBEGIN);
       ButtonStop.Enabled:=true;
       ButtonStop.Visible:=true;
       Update;

       g_stop := false;
       sended_count:=0;
       sended_kb:=0;

       for n := 0 to FileList.Count-1 do
        begin
         s:=FileList.Strings[n];
         AddLogLine(-1,S_TRANSMITSINGLE+' '+ExtractFileName(s)+' ...');
         UpdateProgress(0);
         Update;

         if FileExists(s) then
          begin
           try
            BFObjectPushClient.Put(s);
           except
            AddLogLine(0,S_TRANSMITERROR);
            break;
           end;
           if g_stop then
             break;
           inc(sended_count);
           inc(sended_kb,GetDirectorySize(pchar(s)));
          end
         else
          AddLogLine(0,S_NOTEXIST);
        end;

       UpdateProgress(0);
       AddLogLine(-1,S_FINISH);
       ButtonStop.Visible:=false;
       OnWorkFinish(TRUE,sended_count,sended_kb,'');
      end
     else
      begin
       AddLogLine(0,S_DEVICENOTSELECTED);
      end;
    end;
  end
 else
  begin
   if BFObjectPushServerBluetooth.Active or BFObjectPushServerIrDA.Active then
    begin
     AddLogLine(-1,S_WAITFORFILES);
     g_stop:=false;
    end
   else
    begin
     AddLogLine(0,S_ADAPTERNOTFOUND);
    end;
  end;
end;

procedure TBodyBTForm.NetSendProcess();
var s,folder:string;
    n,sended_count,sended_kb:integer;
begin
 if MessageBox(Handle,S_NETQUERY,S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION) <> IDOK then
  begin
   Close;
   exit;
  end;
 
 AddLogLine(-1,S_NETFOLDERCREATE);
 Application.ProcessMessages;
 folder:=GetNetBurnTimeFolder();
 if folder<>'' then
  begin
   AddLogLine(-1,S_TRANSMITBEGIN);
   ButtonStop.Enabled:=true;
   ButtonStop.Visible:=true;
   Update;

   g_stop := false;
   sended_count:=0;
   sended_kb:=0;

   for n := 0 to FileList.Count-1 do
    begin
     s:=FileList.Strings[n];
     AddLogLine(-1,S_TRANSMITSINGLE+' '+ExtractFileName(s)+' ...');
     UpdateProgress(n*100 div FileList.Count);
     Application.ProcessMessages;

     if g_stop then
       break;

     if FileExists(s) then
      begin
       if not CopyToNetFolder(folder,s) then
        begin
         AddLogLine(0,S_COPYERROR);
         break;
        end;
       inc(sended_count);
       inc(sended_kb,GetDirectorySize(pchar(s)));
      end
     else
      AddLogLine(0,S_NOTEXIST);
    end;

   UpdateProgress(0);
   AddLogLine(-1,S_FINISH);
   ButtonStop.Visible:=false;
   OnWorkFinish(TRUE,sended_count,sended_kb,folder);
   MessageBox(Handle,S_NETSUCCESS,S_INFO,MB_OK or MB_ICONINFORMATION);
  end
 else
  begin
   AddLogLine(0,S_ERRCREATENETFOLDER);
  end;
end;

procedure TBodyBTForm.ButtonStopClick(Sender: TObject);
begin
 AddLogLine(1,S_USERABORT);
 ButtonStop.Enabled:=false;
 Update;
 g_stop:=true;
end;

function TBodyBTForm.CopyToNetFolder(dest_folder,src_file:string):boolean;
var name,ext,dest_file:string;
begin
 name:=ExtractFileName(src_file);
 ext:=ExtractFileExt(name);
 name:=ChangeFileExt(name,'');
 dest_file:=UniqueFileName(dest_folder,name,ext);
 dest_file:=IncludeTrailingPathDelimiter(dest_folder)+dest_file;
 
 Result:=CopyFile(pchar(src_file),pchar(dest_file),FALSE);
end;

procedure TBodyBTForm.AddLogLine(idx:integer;text:string);
var item:TListItem;
begin
 if text<>'' then
  begin
   if (idx<0) or (idx>2) then
    idx:=-1;
   item:=ListView.Items.Add;
   item.SubItems.Add(text);
   item.ImageIndex:=idx;
   try
    ListView.Scroll(0,32);
   except end;
  end;
end;

procedure TBodyBTForm.UpdateProgress(perc:integer);
begin
 if perc<0 then
  perc:=0;
 if perc>100 then
  perc:=100;
 if perc<>ProgressBar.Position then
  ProgressBar.Position:=perc;
end;

procedure TBodyBTForm.BFObjectPushClientProgress(Sender: TObject;
  AName: String; Index, Count, Position, Size: Integer;
  var Abort: Boolean);
begin
 if size<>0 then
  UpdateProgress(Position*100 div Size)
 else
  UpdateProgress(100);
 Application.ProcessMessages;
 abort:=g_stop;
end;

procedure TBodyBTForm.BFObjectPushServerBluetoothProgress(Sender: TObject;
  AName: String; APosition, ASize: Cardinal; var AAbort: Boolean);
begin
 if ASize<>0 then
  UpdateProgress(APosition*100 div ASize)
 else
  UpdateProgress(100);
 Application.ProcessMessages;
 Aabort:=g_stop;
end;

procedure TBodyBTForm.BFObjectPushServerBluetoothConnect(Sender: TObject);
begin
 AddLogLine(-1,S_DEVICECONNECTED);
 UpdateProgress(0);
 g_stop:=false;
 recv_count:=0;
 recv_kb:=0;
 ButtonStop.Enabled:=true;
 ButtonStop.Visible:=true;
 Update;
end;

procedure TBodyBTForm.BFObjectPushServerBluetoothDisconnect(
  Sender: TObject);
begin
 AddLogLine(-1,S_DEVICEDISCONNECTED);
 UpdateProgress(0);
 ButtonStop.Visible:=false;
 Update;
 OnWorkFinish(FALSE,recv_count,recv_kb,'');
end;

procedure TBodyBTForm.BFObjectPushServerBluetoothObject(Sender: TObject;
  AName: String; AObject: TBFByteArray);
var h:integer;
    s:string;
begin
 AddLogLine(-1,S_SAVINGFILE+' '+aname);
 Update;

 s:=UniqueFileName(DestDir,ChangeFileExt(AName,''),ExtractFileExt(AName));

 h:=FileCreate(IncludeTrailingPathDelimiter(DestDir)+s);
 if h <> -1 then
  begin
   if Length(AObject)<>0 then
    FileWrite(h,PChar(AObject)^, Length(AObject));
   FileClose(h);
   inc(recv_count);
   inc(recv_kb,Length(AObject) div 1024);
  end
 else
  begin
   AddLogLine(0,S_ERRSAVINGFILE+' '+aname);
  end;
 
 UpdateProgress(0);
 Update;
end;

function TBodyBTForm.UniqueFileName(folder,name,ext: string): string;
var
  i: integer;
  s: string;
begin
  if name='' then
    s := '_0' + Ext
  else
    s := name + Ext;
  i := 1;
  while FileExists(IncludeTrailingPathDelimiter(folder)+s) do
    begin
      s := name + '_' + IntToStr(i) + Ext;
      inc(i);
    end;
  Result := s;
end;

procedure TBodyBTForm.OnWorkFinish(is_send:boolean;count,size:integer;net_folder:string);
var w:HWND;
begin
  w:=FindWindow('_RunpadClass',nil);
  if w<>0 then
   begin
    if is_send then
     count:=cardinal(count) or $80000000;
    
    if not g_mobile_content then
       PostMessage(w,WM_USER+179,count,size)
    else
       PostMessage(w,WM_USER+199,count,size);

    if net_folder<>'' then
       PostMessage(w,WM_USER+193,GlobalAddAtom(pchar(net_folder)),integer(g_mobile_content));
   end;
end;

end.
