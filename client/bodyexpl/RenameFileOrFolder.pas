unit RenameFileOrFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TRenameFileOrFolderForm = class(TForm)
    LabelInfo: TLabel;
    EditName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    root : string;
    folder : string;
    out_file : string;
    { Public declarations }
  end;

var
  RenameFileOrFolderForm: TRenameFileOrFolderForm;

implementation

uses main;

{$R *.dfm}
{$INCLUDE ..\rp_shared\RP_Shared.inc}

procedure TRenameFileOrFolderForm.FormShow(Sender: TObject);
var
 name: string;
begin
 name := ExtractFileName(folder);
 EditName.Text := name;
 EditName.SelectAll;

 Caption:=LS(1313);
 LabelInfo.Caption:=LS(1314);

 out_file:='';
end;

procedure TRenameFileOrFolderForm.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  s : string;
  i : integer;
begin
  if Key = VK_RETURN then
    begin
      if EditName.Text = '' then
        begin
          MessageBox(Handle,LSP(1315),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
          Exit;
        end;

      if (EditName.Text = '.') or (EditName.Text = '..') then
        begin
          MessageBox(Handle,LSP(1316),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
          Exit;
        end;

      for i:=1 to Length(EditName.Text) do
        if (EditName.Text[i]='\') or (EditName.Text='+') or (EditName.Text='/') then
          begin
            MessageBox(Handle,LSP(1317),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
            Exit;
          end;

      s := root + EditName.Text;

      if AnsiCompareText(s,folder)=0 then
       Exit;

      if DirectoryExists(s) then
        begin
          MessageBox(Handle,LSP(1318),LSP(LS_ERROR),MB_OK or MB_ICONERROR);
          Exit;
        end;

      if FileExists(s) then
       begin
          if MessageBox(Handle,LSP(1319),LSP(LS_QUESTION),MB_OKCANCEL or MB_ICONQUESTION)<>IDOK then
           Exit
          else
           Windows.DeleteFile(pchar(s));
       end;

      BodyExplForm.Cursor := crHourglass;
      Application.ProcessMessages;

      if MoveFile(PChar(folder), PChar(s)) then
       begin
        ModalResult := mrOk;
        out_file:=s;
       end
      else
        MessageBox(Handle,LSP(1320),LSP(LS_ERROR),MB_OK or MB_ICONERROR);

      BodyExplForm.Cursor := crDefault;

      Key := 0;
    end;

  if Key = VK_ESCAPE then
    begin
      ModalResult := mrCancel;
      Key := 0;
    end;
end;

end.
