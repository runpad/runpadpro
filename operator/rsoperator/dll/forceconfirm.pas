unit ForceConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForceConfirmForm = class(TForm)
    ButtonSoft: TButton;
    ButtonHard: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    default_hard : boolean;
  public
    { Public declarations }
    constructor CreateForm(is_hard_default:boolean);
    destructor Destroy; override;
  end;


function ShowForceConfirmFormModal(var is_hard_inout:boolean):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowForceConfirmFormModal(var is_hard_inout:boolean):boolean;
var f:TForceConfirmForm;
    rc:integer;
begin
 Result:=false;
 f:=TForceConfirmForm.CreateForm(is_hard_inout);
 rc:=f.ShowModal;
 if (rc=mrYes) or (rc=mrNo) then
  begin
   is_hard_inout:=(rc=mrYes);
   Result:=true;
  end;
 f.Free;
end;

constructor TForceConfirmForm.CreateForm(is_hard_default:boolean);
begin
 inherited Create(nil);

 default_hard:=is_hard_default;
end;

destructor TForceConfirmForm.Destroy;
begin

 inherited;
end;

procedure TForceConfirmForm.FormShow(Sender: TObject);
begin
 if default_hard then
  ButtonHard.SetFocus
 else
  ButtonSoft.SetFocus;
end;

procedure TForceConfirmForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_ESCAPE then
  ModalResult:=mrCancel;
end;

end.
