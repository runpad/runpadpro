unit FileBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TFileBoxForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ComboBoxEx: TComboBoxEx;
    ButtonSelectFile: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonSelectFileClick(Sender: TObject);
  private
    { Private declarations }
    m_list_id : string;
    m_def : string;
    m_filter : pchar;
  public
    { Public declarations }
    constructor CreateForm(instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;list_id:string;filter:pchar);
    destructor Destroy; override;
  end;


function ShowFileBoxFormModal(var out_path:string;instance:cardinal;icon_idx:integer;title,text,def:string;list_id:string;filter:pchar):boolean;
function ShowFolderBoxFormModal(var out_path:string;instance:cardinal;icon_idx:integer;title,text,def:string;list_id:string):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowFileBoxFormModal(var out_path:string;instance:cardinal;icon_idx:integer;title,text,def:string;list_id:string;filter:pchar):boolean;
var f:TFileBoxForm;
begin
 Result:=false;
 f:=TFileBoxForm.CreateForm(instance,icon_idx,title,text,def,MAX_PATH-1,list_id,filter);
 if f.ShowModal=mrOk then
  begin
   out_path:=f.ComboBoxEx.Text;
   Result:=true;
  end;
 f.Free;
end;

function ShowFolderBoxFormModal(var out_path:string;instance:cardinal;icon_idx:integer;title,text,def:string;list_id:string):boolean;
begin
 Result:=ShowFileBoxFormModal(out_path,instance,icon_idx,title,text,def,list_id,nil);
end;

constructor TFileBoxForm.CreateForm(instance:cardinal;icon_idx:integer;title,text,def:string;maxlength:integer;list_id:string;filter:pchar);
var i:TIcon;
begin
 inherited Create(nil);

 m_def:=def;
 m_filter:=filter;

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(instance,pchar(icon_idx),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 Caption:=title;
 Label1.Caption:=text;
 ComboBoxEx.MaxLength:=maxlength;

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

destructor TFileBoxForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TFileBoxForm.FormShow(Sender: TObject);
begin
 ComboBoxEx.SetFocus;
end;

procedure TFileBoxForm.ButtonOKClick(Sender: TObject);
begin
 if (trim(ComboBoxEx.Text)='') then
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

procedure TFileBoxForm.ButtonSelectFileClick(Sender: TObject);
var s:string;
begin
 if m_filter=nil then
  s:=EmulGetFolder(false)
 else
  s:=EmulGetOpenFile(m_filter,pchar(m_def));
 if s<>'' then
  ComboBoxEx.Text:=s;
end;

end.
