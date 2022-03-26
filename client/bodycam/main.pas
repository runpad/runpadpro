unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActiveX, VSTWAINLib_TLB, ExtCtrls;

type
  TBodyCamForm = class(TForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    wia : TVintaSoftTwain;
    total_files : integer;
    total_kb : integer;
    file_idx : integer;
    procedure VSTwainPostScan(ASender: TObject; flag: Integer);
    procedure BeginScan;
    procedure Err(const s:string);
    procedure Msg(const s:string);
    procedure OnScanComplete();
    function GetUniqueFileInDir(const folder,file_fmt:string;var curr_idx:integer):string;
  public
    { Public declarations }
    procedure DefaultHandler(var Message); override;
  end;

var
  BodyCamForm: TBodyCamForm;
  dest_folder : string = '';


implementation

uses StrUtils;

{$R *.dfm}
{$INCLUDE ..\rp_shared\rp_shared.inc}


var msg_begin : cardinal = 0;
var msg_end : cardinal = 0;


function TBodyCamForm.GetUniqueFileInDir(const folder,file_fmt:string;var curr_idx:integer):string;
var s:string;
begin
 while true do
  begin
   s:=IncludeTrailingPathdelimiter(folder)+Format(file_fmt,[curr_idx]);
   inc(curr_idx);

   if not FileExists(s) then
    begin
     Result:=s;
     break;
    end;
  end;
end;

procedure TBodyCamForm.DefaultHandler(var Message);
begin
  with TMessage(Message) do
    if msg=msg_begin then
      BeginScan()
    else
    if msg=msg_end then
      Close()
    else
      inherited;
end;

procedure TBodyCamForm.Err(const s:string);
begin
 MessageBox(Handle,pchar(s),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
end;

procedure TBodyCamForm.Msg(const s:string);
begin
 MessageBox(Handle,pchar(s),LSP(LS_INFO),MB_OK or MB_ICONINFORMATION);
end;

procedure TBodyCamForm.FormCreate(Sender: TObject);
begin
 total_files:=0;
 total_kb:=0;
 file_idx:=0;

 Caption:=Application.Title;

 try
  wia:=TVintaSoftTwain.Create(nil);
  wia.OnPostScan:=VSTwainPostScan;
  wia.appProductName:='Runpad Shell Camera';
 except
  wia:=nil;
 end;
end;

procedure TBodyCamForm.FormDestroy(Sender: TObject);
begin
 OnScanComplete();

 Image1.Picture.Assign(nil);

 if wia<>nil then
  begin
   wia.OnPostScan:=nil;
   FreeAndNil(wia);
  end;
end;

procedure TBodyCamForm.FormShow(Sender: TObject);
begin
 PostMessage(Handle,msg_begin,0,0);
end;

procedure TBodyCamForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if wia<>nil then
  wia.StopDevice;
end;

procedure TBodyCamForm.VSTwainPostScan(ASender: TObject; flag: Integer);
var b_finish, rc : boolean;
    s, base_caption : string;
    bm : cardinal;
begin
  b_finish:=false;

  if (flag <> 0) then
    begin
      b_finish:=true;
      if wia.errorCode<>0 then
        Err(wia.errorString);
    end
  else
    begin
      Screen.Cursor:=crHourGlass;
      s:=GetUniqueFileInDir(dest_folder,'photo_%.4d.jpg',file_idx);
      Screen.Cursor:=crDefault;

      base_caption:=ExtractFileName(s)+' ['+inttostr(wia.GetImageWidth(0))+'x'+inttostr(wia.GetImageHeight(0))+']';
      Caption:=base_caption;

      if Image1.Picture.Bitmap.HandleAllocated then
       begin
        bm:=Image1.Picture.Bitmap.ReleaseHandle;
        if bm<>0 then
         Windows.DeleteObject(bm);
       end;
      Image1.Picture.Bitmap.Handle:=wia.GetCurrentImageAsHBitmap;
      Update;

      Caption:=base_caption+'...';
      Screen.Cursor:=crHourGlass;
      rc:=wia.SaveImage(0,s)<>0;
      Screen.Cursor:=crDefault;
      Caption:=base_caption;

      if not rc then
       begin
        wia.cancelTransfer:=1;
        Err(LS(4003));
        b_finish:=true;
       end
      else
       begin
        inc(total_files);
        inc(total_kb,GetDirectorySize(pchar(s)));

        if wia.dataSourceState=0 then
         begin
          Msg(LS(4004));
          b_finish:=true;
         end;
       end;
    end;

  if b_finish then
   PostMessage(Handle,msg_end,0,0);
end;

procedure TBodyCamForm.BeginScan;
var b_finish, b_selected, rc : boolean;
    s : string;
begin
 b_finish:=false;

 if wia=nil then
  begin
   Err('ActiveX control not installed');
   b_finish:=true;
  end
 else
  begin
   if wia.StartDevice=0 then
    begin
     Err(LS(4005));
     b_finish:=true;
    end
   else
    begin
     wia.Register('Сергей Шамшин','support@runpad-shell.com','51CBEC753C5C3C6931B0EF16AAF6D30B7468B715E7088E4CEDB43F71EA4E82DF519936D95FE774A4A5829D803D4B42E334CF15BB45D9E25EDB2294E82C6D9B94846E7E9A6161C3829307A83A0E575B28A9C1921D132C1E5BDF12D758A'+'03A69DEAA2CADFD7E0B754E29A4F3A5E93EA813CC7D066F33845E58F79A288232C4B37D3F5AFFE92DCB8249E0433D76473C191B0AC4DFA97D0534F6CA741D48D935E0EF');

     if wia.sourcesCount=0 then
      begin
       Err(LS(4006));
       b_finish:=true;
      end
     else
      begin
       wia.modalUI:=1;

       if wia.sourcesCount=1 then
        begin
         wia.sourceIndex:=0;
         b_selected:=true;
        end
       else
        begin
         b_selected:=wia.SelectSource<>0;
        end;

       if not b_selected then
        b_finish:=true
       else
        begin
         wia.disableAfterAcquire:=1;
         wia.showUI:=1;
         wia.maxImages:=1;

         Screen.Cursor:=crHourGlass;
         Caption:=LS(4007);
         rc:=wia.OpenDataSource<>0;
         Screen.Cursor:=crDefault;

         if not rc then
          begin
           Err(LS(4008));
           b_finish:=true;
          end
         else
          begin
           s:=wia.GetSourceProductName(wia.sourceIndex);
           if AnsiStartsText('WIA-',s) then
            s:=Copy(s,5,length(s)-4);
           Caption:=s;

           wia.unitOfMeasure := 0; //Inches;
           wia.pixelType := 2; //RGB;
           wia.resolution := 300;
           wia.brightness := wia.brightnessMaxValue;
           wia.contrast := 0;
           wia.xferCount := -1; //unlimited

           if wia.Acquire=0 then
            begin
             b_finish:=true;
            end
           else
            begin
             //success!!!
            end;
          end;
        end;
      end;
    end;
  end;

 if b_finish then
  Close;
end;

procedure TBodyCamForm.OnScanComplete;
var w:HWND;
begin
  if total_files>0 then
   begin
    w:=FindWindow('_RunpadClass',nil);
    if w<>0 then
     begin
      PostMessage(w,WM_USER+200,total_files,total_kb);
     end;
   end;
end;


initialization
 msg_begin:=RegisterWindowMessage('RSBodyCam.Begin');
 msg_end:=RegisterWindowMessage('RSBodyCam.End');
end.
