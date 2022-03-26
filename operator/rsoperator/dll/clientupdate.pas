unit ClientUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TClientUpdateForm = class(TForm)
    Image1: TImage;
    ButtonCancel: TButton;
    Memo1: TMemo;
    ButtonUpdate: TButton;
    CheckBoxForce: TCheckBox;
    RadioButtonImm: TRadioButton;
    RadioButtonPostpond: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure RadioButtonPostpondClick(Sender: TObject);
    procedure RadioButtonImmClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateForm(is_imm,is_force:boolean);
    destructor Destroy; override;
  end;


function ShowClientUpdateFormModal(var out_imm,out_force:boolean):boolean;


implementation

uses tools,lang;

{$R *.dfm}

const s_info_text:string =
'Памятка: '#13#10+
'Убедитесь, что перед выполнением операции выполнено обновление программы администратора (его нужно сделать вручную через программу установки), чтобы утилита конфигурации базы данных занесла в базу нужные файлы обновлений '+'(утилита автоматически запускается после обновления программы администратора).'#13#10+
''#13#10+
'Можно обновлять как на более новую версию, так и на старую.'#13#10+
'Само обновление происходит "в фоне" и обычно не занимает более 10-15 сек. При этом, если выбрать "отложенное обновление", то активация новой версии произойдет только после следующей перезагрузки машины. При выборе мгновенного обновления '+'автоматически произойдет перезагрузка машины после того, как все необходимые действия будут выполнены.'#13#10+
'Посмотреть текущую версию клиентской части можно через опцию: "Информация->Общие сведения".'#13#10+
''#13#10+
'ВНИМАНИЕ! При использовании программ типа ShadowUser, DeepFreeze, Norton GoBack и пр., которые восстанавливают образ системы после перезагрузки, необходимо их временное отключение для обновления клиентских машин. '#13#10+
'Включать программы снова следует только после ПОЛНОЙ перезагрузки после успешного обновления.'#13#10+
'При использовании встроенного модуля отката Rollback отключать его вручную не нужно, т.к. он автоматически будет отключен на две перезагрузки (с сохранением данных) при успешном обновлении, а после второй перезагрузки будет снова включен.';



function ShowClientUpdateFormModal(var out_imm,out_force:boolean):boolean;
var f:TClientUpdateForm;
begin
 Result:=false;
 f:=TClientUpdateForm.CreateForm(false,false);
 if f.ShowModal=mrOk then
  begin
   out_imm:=f.RadioButtonImm.Checked;
   out_force:=f.CheckBoxForce.Checked;
   Result:=true;
  end;
 f.Free;
end;

constructor TClientUpdateForm.CreateForm(is_imm,is_force:boolean);
var i:TIcon;
begin
 inherited Create(nil);

 Memo1.Text:=s_info_text;

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(242),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 if is_imm then
  RadioButtonImm.Checked:=true
 else
  RadioButtonPostpond.Checked:=true;
 CheckBoxForce.Checked:=is_force;
end;

destructor TClientUpdateForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TClientUpdateForm.FormShow(Sender: TObject);
begin
 ButtonUpdate.SetFocus;
end;

procedure TClientUpdateForm.RadioButtonPostpondClick(Sender: TObject);
begin
 if RadioButtonPostpond.Checked then
  begin
   CheckBoxForce.Enabled:=false;
  end;
end;

procedure TClientUpdateForm.RadioButtonImmClick(Sender: TObject);
begin
 if RadioButtonImm.Checked then
  begin
   CheckBoxForce.Enabled:=true;
  end;
end;

procedure TClientUpdateForm.ButtonUpdateClick(Sender: TObject);
begin
 ModalResult:=mrOk;
end;

end.
