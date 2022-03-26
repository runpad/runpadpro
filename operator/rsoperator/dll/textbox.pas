unit textbox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TTextBoxForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ComboBoxEx: TComboBoxEx;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
    b_allow_empty : boolean;
    m_list_id : string;
  public
    { Public declarations }
    constructor CreateForm(instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;allow_empty:boolean;list_id:string);
    destructor Destroy; override;
  end;


function ShowTextBoxFormModal(var out_text:string;instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;allow_empty:boolean;list_id:string):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowTextBoxFormModal(var out_text:string;instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;allow_empty:boolean;list_id:string):boolean;
var f:TTextBoxForm;
begin
 Result:=false;
 f:=TTextBoxForm.CreateForm(instance,icon_idx,title,text,def,maxlength,allow_empty,list_id);
 if f.ShowModal=mrOk then
  begin
   out_text:=f.ComboBoxEx.Text;
   Result:=true;
  end;
 f.Free;
end;

constructor TTextBoxForm.CreateForm(instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;allow_empty:boolean;list_id:string);
var i:TIcon;
begin
 inherited Create(nil);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(instance,pchar(icon_idx),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 Caption:=title;
 Label1.Caption:=text;
 ComboBoxEx.MaxLength:=maxlength;
 b_allow_empty:=allow_empty;

 m_list_id:=list_id;
 if list_id<>'' then
  begin
   FillStringListWithHistory(ComboBoxEx.Items,list_id);
  end
 else
  begin
   //ComboBoxEx.Style:=csExSimple;
  end;

 ComboBoxEx.Text:=def;
end;

destructor TTextBoxForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TTextBoxForm.FormShow(Sender: TObject);
begin
 ComboBoxEx.SetFocus;
end;

procedure TTextBoxForm.ButtonOKClick(Sender: TObject);
begin
 if (trim(ComboBoxEx.Text)='') and (not b_allow_empty) then
  begin
   MessageBox(Handle,S_EMPTYSTRING,S_ERR,MB_OK or MB_ICONERROR);
   ComboBoxEx.SetFocus;
  end
 else
  begin
   UpdateHistoryFromComboBox(ComboBoxEx,m_list_id);
   ModalResult:=mrOk;
  end;
end;

end.
