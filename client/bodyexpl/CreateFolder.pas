unit CreateFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCreateFolderForm = class(TForm)
    LabelInfo: TLabel;
    EditName: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    root : string;
    { Public declarations }
  end;

var
  CreateFolderForm: TCreateFolderForm;

implementation

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

procedure TCreateFolderForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s : string;
begin
  if Key = VK_RETURN then
    begin
      if EditName.Text = '' then
        MessageBox(Handle,LSP(1303),LSP(LS_ERROR),MB_OK or MB_ICONERROR)
      else
        begin
          s := root + EditName.Text;
          if CreateDirectory(pchar(s),nil) then
            ModalResult := mrOk
          else
            MessageBox(Handle,LSP(1304),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
        end;
      Key := 0;
    end;
  if Key = VK_ESCAPE then
    begin
      ModalResult := mrCancel;
      Key := 0;
    end;
end;

procedure TCreateFolderForm.FormShow(Sender: TObject);
begin
 EditName.Text := '';

 Caption:=LS(1305);
 LabelInfo.Caption:=LS(1306);
end;

end.
