unit wmppreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, WMPLib_TLB;

type
  TWMPPreviewForm = class(TForm)
    WMP: TWindowsMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    filename:string;
  end;

procedure ShowPreviewVideo(filename:string);


implementation

{$R *.dfm}


procedure ShowPreviewVideo(filename:string);
var f:TWMPPreviewForm;
begin
 try
  f:=TWMPPreviewForm.Create(nil);
 except
  f:=nil;
 end;
 if f<>nil then
  begin
   f.filename:=filename;
   f.ShowModal;
   f.Free;
  end;
end;

procedure TWMPPreviewForm.FormCreate(Sender: TObject);
begin
 filename:='';
 if wmp.settings<>nil then
   wmp.settings.enableErrorDialogs:=false;
end;

procedure TWMPPreviewForm.FormDestroy(Sender: TObject);
begin
 try
  wmp.close;
 except end;
end;

procedure TWMPPreviewForm.FormShow(Sender: TObject);
begin
 Caption:=ExtractFileName(filename);
 try
  wmp.URL:=filename;
 except end;
end;

procedure TWMPPreviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  Close;
end;

end.
