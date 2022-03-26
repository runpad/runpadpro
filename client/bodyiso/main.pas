unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TBodyISOForm = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Panel4: TPanel;
    ButtonCopy: TBitBtn;
    ButtonStop: TBitBtn;
    Image1: TImage;
    LabelTitle: TLabel;
    Panel3: TPanel;
    Label1: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    LabelProgress: TLabel;
    ProgressBar: TProgressBar;
    Panel7: TPanel;
    Bevel3: TBevel;
    Label2: TLabel;
    ComboBoxDrives: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonCopyClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
  private
    { Private declarations }
    global_abort : boolean;
    procedure WMQueryEndSession(var M: TWMQueryEndSession); message WM_QUERYENDSESSION;
    procedure UpdateButtonsFocus;
    function CreateISO(drive,filename:string):boolean;
    procedure OnSuccessCopy(filename:string);
  public
    { Public declarations }
  end;

var
  BodyISOForm: TBodyISOForm;


implementation

uses opnsavf;

{$R *.dfm}

{$INCLUDE ..\rp_shared\RP_Shared.inc}



procedure TBodyISOForm.FormCreate(Sender: TObject);
var n,drives:integer;
    s:string;
begin
 Application.Title:=Caption;
 LabelProgress.Enabled:=false;
 ButtonStop.Visible:=false;
 ButtonCopy.Visible:=true;
 Label3.Caption:='';
// CreateMutex(nil,false,'bodyburn.exe');
// ButtonCopy.Enabled:=(GetLastError = ERROR_ALREADY_EXISTS);

 drives:=GetLogicalDrives();
 for n:=2 to 25 do
  if ((drives shr n) and 1)<>0 then
   begin
    s:=Format('%s:\',[char(65+n)]);
    if GetDriveType(pchar(s))=DRIVE_CDROM then
      ComboBoxDrives.Items.Add('CD-ROM ['+char(65+n)+':]'); //do not change string form!!!!!
   end;
 if ComboBoxDrives.Items.Count<>0 then
  ComboBoxDrives.ItemIndex:=0;

 global_abort:=false;
end;

procedure TBodyISOForm.FormDestroy(Sender: TObject);
begin
//
end;

procedure TBodyISOForm.WMQueryEndSession(var M: TWMQueryEndSession);
begin
 if ButtonStop.Visible then
  M.Result:=0
 else
  M.Result:=1;
end;

procedure TBodyISOForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 if ButtonStop.Enabled and ButtonStop.Visible then
  begin
   CanClose:=false;
   ButtonStopClick(Sender);
  end
 else
 if (not ButtonStop.Enabled) and ButtonStop.Visible then
  CanClose:=false
 else
  CanClose:=true;
end;

procedure TBodyISOForm.UpdateButtonsFocus;
begin
 if ButtonCopy.Enabled and ButtonCopy.Visible then
  ButtonCopy.SetFocus
 else
 if ButtonStop.Enabled and ButtonStop.Visible then
  ButtonStop.SetFocus;
end;

procedure TBodyISOForm.FormShow(Sender: TObject);
begin
 UpdateButtonsFocus();
end;

procedure TBodyISOForm.ButtonStopClick(Sender: TObject);
begin
 global_abort:=true;
 ButtonStop.Enabled:=false;
 Application.ProcessMessages;
end;

procedure TBodyISOForm.ButtonCopyClick(Sender: TObject);
var drive,filename:string;
    p:pchar;
    rc:boolean;
begin
 if ComboBoxDrives.ItemIndex=-1 then
  begin
   MessageBox(Handle,'Не выбрано устройство','Ошибка',MB_OK or MB_ICONERROR);
   ComboBoxDrives.SetFocus;
   exit;
  end;

 if FindWindow('_RunpadClass',nil)=0 then
  begin
   p:=GetSaveFileDialog(handle,pchar('Образы ISO (*.iso)'#0'*.iso'#0#0),'image.iso');
   if (p=nil) or (length(string(p))=0) then
    exit;
   filename:=p;
  end
 else
  begin
   filename:='image.iso';
   if not OpenSaveForm.ExecuteSaveFile( '*.iso|Образы ISO (*.iso)', true, filename ) then
    exit;
  end;

 if filename='' then
  exit;

 Label3.Caption:='';
 Label2.Enabled:=false;
 ComboBoxDrives.Enabled:=false;
 LabelProgress.Enabled:=true;
 ProgressBar.Position:=0;
 ButtonCopy.Visible:=false;
 ButtonStop.Enabled:=true;
 ButtonStop.Visible:=true;
 UpdateButtonsFocus();
 Update;
 Application.ProcessMessages;

 global_abort:=false;

 drive:=ComboBoxDrives.Items[ComboBoxDrives.ItemIndex][9]+':';

 rc:=CreateISO(drive,filename);

 global_abort:=false;
 Label3.Caption:='';
 ButtonStop.Enabled:=true;
 ButtonStop.Visible:=false;

 if rc then
  begin
   OnSuccessCopy(filename);
   MessageBox(handle,'Образ успешно сохранен!','Информация',MB_OK or MB_ICONINFORMATION);
  end;

 Label2.Enabled:=true;
 ComboBoxDrives.Enabled:=true;
 LabelProgress.Enabled:=false;
 ProgressBar.Position:=0;
 ButtonCopy.Visible:=true;
 ButtonCopy.Enabled:=true;
 UpdateButtonsFocus();
end;


function TBodyISOForm.CreateISO(drive,filename:string):boolean;
label again;
const MAXTRYCOUNT=5;
var h:THandle;
    bytes_total,bytes_read:int64;
    f,try_count,n:integer;
    rc,packet_size,packet_max,packet_min:cardinal;
    buff:pointer;
    s:string;
begin
 Result:=false;

 h:=CreateFile(pchar('\\.\'+drive),GENERIC_READ,FILE_SHARE_READ or FILE_SHARE_WRITE,
     nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
 if h<>INVALID_HANDLE_VALUE then
  begin
   f:=FileCreate(filename);
   if f<>-1 then
    begin
     bytes_total:=(int64(GetDriveTotalSpace(pchar(drive))) shl 10);
     bytes_read:=0;

     packet_max:=65536; //cylinder
     packet_min:=2048;  //sector size
     GetMem(buff,packet_max);

     while true do
      begin
       if global_abort then
        break;

       packet_size:=packet_max;
       try_count:=0;
      again:;

       rc:=0;
       if not ReadFile(h,buff^,packet_size,rc,nil) then
        begin
         if packet_size=packet_max then
          begin
           packet_size:=packet_min;
           try_count:=MAXTRYCOUNT;
           goto again;
          end;

         if try_count>0 then
           dec(try_count);

         if try_count=0 then
          begin
           if (bytes_total<>0) and (bytes_total-bytes_read<12288) then
            begin
             Result:=true;
             break; //finish!
            end;
           if MessageBox(handle,'Ошибка чтения диска','Ошибка',MB_ICONWARNING or MB_RETRYCANCEL)=IDRETRY then
            begin
             try_count:=MAXTRYCOUNT;
             goto again;
            end
           else
            begin
             global_abort:=true;
             break;
            end;
          end
         else
          goto again;
        end; /////

       if rc=0 then
        begin
         Result:=true;
         break; //finish!
        end;
       
       if FileWrite(f,buff^,rc)<>integer(rc) then
        begin
         MessageBox(handle,'Не хватает места на диске','Ошибка',MB_ICONERROR or MB_OK);
         global_abort:=true;
         break;
        end;

       inc(bytes_read,rc);
       
       if (bytes_total<>0) and (bytes_read<=bytes_total) then
        begin
         n:=bytes_read*100 div bytes_total;
         if ProgressBar.Position<>n then
           ProgressBar.Position:=n;
        end;

       if bytes_total=0 then
        s:=Format('%d MB',[integer(bytes_read shr 20)])
       else
        s:=Format('%d MB / %d MB',[integer(bytes_read shr 20),integer(bytes_total shr 20)]);
       if Label3.Caption<>s then
        Label3.Caption:=s;

       Application.ProcessMessages; 
      end;

     FreeMem(buff);
     FileClose(f);
    end
   else
    MessageBox(handle,'Ошибка создания файла образа','Ошибка',MB_OK or MB_ICONERROR);

   CloseHandle(h);
  end
 else
  MessageBox(handle,'Устройство не готово или отсутствует диск','Ошибка',MB_OK or MB_ICONERROR);

 if global_abort then
  DeleteFile(filename);
end;


procedure TBodyISOForm.OnSuccessCopy(filename:string);
var w:HWND;
    atom:integer;
begin
 w:=FindWindow('_RunpadClass',nil);
 if w<>0 then
   begin
     atom:=GlobalAddAtom(pchar(filename));
     PostMessage(w,WM_USER+185,atom,0);
   end;
end;


end.
