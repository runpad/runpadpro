unit Extract;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormExtract = class(TForm)
    EditPassword: TEdit;
    Label1: TLabel;
    RadioButtonCurrent: TRadioButton;
    RadioButtonDir: TRadioButton;
    EditFolder: TEdit;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    ImageBook: TImage;
    procedure RadioButtonClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormExtract: TFormExtract;

implementation

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

procedure TFormExtract.RadioButtonClick(Sender: TObject);
begin
  EditFolder.Enabled := RadioButtonDir.Checked;
end;

procedure TFormExtract.ButtonOkClick(Sender: TObject);
var
  i: integer;
  s: string;
  ValidDirName: boolean;
begin
  ValidDirName := true;
  if RadioButtonDir.Checked then
    begin
      s := EditFolder.Text;
      if s = '..' then
        ValidDirName := false
      else
        for i:=1 to Length(s) do
          if s[i] = '\' then
            begin
              ValidDirName := false;
              break;
            end
    end;

  if ValidDirName then
    ModalResult := mrOk
  else
    MessageBox(Handle, LSP(1307), LSP(LS_ERROR), MB_OK or MB_ICONERROR);
end;

procedure TFormExtract.FormShow(Sender: TObject);
begin
 Caption:=LS(1308);
 RadioButtonCurrent.Caption:=LS(1309);
 RadioButtonDir.Caption:=LS(1310);
 Label1.Caption:=LS(1311);
 ButtonOK.Caption:=LS(LS_OK);
 ButtonCancel.Caption:=LS(LS_CANCEL);
end;

end.
