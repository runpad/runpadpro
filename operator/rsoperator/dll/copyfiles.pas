unit CopyFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TCopyFilesForm = class(TForm)
    Image1: TImage;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBoxFrom: TComboBoxEx;
    ButtonSelectFileFrom: TButton;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    ComboBoxTo: TComboBoxEx;
    ButtonSelectFileTo: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    CheckBoxKillAll: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonSelectFileFromClick(Sender: TObject);
    procedure ButtonSelectFileToClick(Sender: TObject);
  private
    { Private declarations }
    m_list_id_from : string;
    m_list_id_to : string;
  public
    { Public declarations }
    constructor CreateForm();
    destructor Destroy; override;
  end;


function ShowCopyFilesFormModal(var out_pathfrom,out_pathto:string;var out_killtasks:boolean):boolean;


implementation

uses tools,lang;

{$R *.dfm}


function ShowCopyFilesFormModal(var out_pathfrom,out_pathto:string;var out_killtasks:boolean):boolean;
var f:TCopyFilesForm;
begin
 Result:=false;
 f:=TCopyFilesForm.CreateForm();
 if f.ShowModal=mrOk then
  begin
   out_pathfrom:=f.ComboBoxFrom.Text;
   out_pathto:=f.ComboBoxTo.Text;
   out_killtasks:=f.CheckBoxKillAll.Checked;
   Result:=true;
  end;
 f.Free;
end;

constructor TCopyFilesForm.CreateForm();
var i:TIcon;
begin
 inherited Create(nil);

 i:=TIcon.Create();
 i.Handle:=Windows.CopyIcon(LoadImage(hinstance,pchar(239),IMAGE_ICON,32,32,LR_SHARED));
 Image1.Picture.Assign(i);
 i.Free;

 m_list_id_from:='CopyFilesFrom';
 FillStringListWithHistory(ComboBoxFrom.Items,m_list_id_from);
 m_list_id_to:='CopyFilesTo';
 FillStringListWithHistory(ComboBoxTo.Items,m_list_id_to);

 ComboBoxFrom.Text:='';
 ComboBoxTo.Text:='';
 CheckBoxKillAll.Checked:=false;
end;

destructor TCopyFilesForm.Destroy;
begin
 Image1.Picture.Assign(nil);

 inherited;
end;

procedure TCopyFilesForm.FormShow(Sender: TObject);
begin
 ComboBoxFrom.SetFocus;
end;

procedure TCopyFilesForm.ButtonOKClick(Sender: TObject);
begin
 if (trim(ComboBoxFrom.Text)='') or (trim(ComboBoxTo.Text)='') then
  begin
   MessageBox(Handle,S_EMPTYSTRING,S_ERR,MB_OK or MB_ICONERROR);
   if (trim(ComboBoxFrom.Text)='') then
    ComboBoxFrom.SetFocus
   else
    ComboBoxTo.SetFocus;
  end
 else
  begin
   UpdateHistoryFromComboBox(ComboBoxFrom,m_list_id_from);
   UpdateHistoryFromComboBox(ComboBoxTo,m_list_id_to);
   ModalResult:=mrOk;
  end;
end;

procedure TCopyFilesForm.ButtonSelectFileFromClick(Sender: TObject);
var s:string;
begin
 s:=EmulGetFolder(true);
 if s<>'' then
  ComboBoxFrom.Text:=s;
end;

procedure TCopyFilesForm.ButtonSelectFileToClick(Sender: TObject);
var s:string;
begin
 s:=EmulGetFolder(false);
 if s<>'' then
  ComboBoxTo.Text:=s;
end;

end.
