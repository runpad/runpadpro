unit frame4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ImgList;

type
  TPage4 = class(TFrame)
    Panel1: TPanel;
    ProgressBar: TProgressBar;
    LabelProgress: TLabel;
    Bevel1: TBevel;
    ListView: TListView;
    ImageList: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OnShow(Sender:TObject);
    procedure OnCreate(Sender:TObject);
    procedure UpdateProgress(perc:integer);
    procedure AddLogLine(idx:integer;text:string);
    procedure BeforeBurn;
    procedure AfterBurn;
  end;

implementation

uses commctrl;

{$R *.dfm}


procedure TPage4.OnCreate(Sender:TObject);
begin
 ImageList.Handle := ImageList_Create(16, 16, ILC_MASK or ILC_COLOR32, 1, 1);
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(101)));
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(102)));
 ImageList_AddIcon(ImageList.Handle,LoadIcon(hInstance,pchar(103)));

 LabelProgress.Enabled:=false; 
end;

procedure TPage4.OnShow(Sender:TObject);
begin
 ListView.Clear;
 try
  ListView.Selected:=nil;
 except end;
 ProgressBar.Position:=0;
end;

procedure TPage4.UpdateProgress(perc:integer);
begin
 if perc<0 then
  perc:=0;
 if perc>100 then
  perc:=100;
 if perc<>ProgressBar.Position then
  ProgressBar.Position:=perc;
end;

procedure TPage4.AddLogLine(idx:integer;text:string);
var item:TListItem;
begin
 if text<>'' then
  begin
   if (idx<0) or (idx>2) then
    idx:=-1;
   item:=ListView.Items.Add;
   item.SubItems.Add(text);
   item.ImageIndex:=idx;
   try
    ListView.Scroll(0,32);
   except end;
  end;
end;

procedure TPage4.BeforeBurn;
begin
 LabelProgress.Enabled:=true;
end;

procedure TPage4.AfterBurn;
begin
 LabelProgress.Enabled:=false;
 UpdateProgress(0);
end;

end.
