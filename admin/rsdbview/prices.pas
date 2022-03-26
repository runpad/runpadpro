unit prices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, h_sql;

type
  TPricesForm = class(TForm)
    Panel1: TPanel;
    StringGrid: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
    sql:TSQLLib;
    GridChanged:boolean;
  public
    { Public declarations }
    constructor CreateForm(_sql:TSQLLib);
    destructor Destroy; override;

    function CBGridFill(i:PEXECSQLCBSTRUCT):boolean;
  end;


implementation

uses tools, lang;

{$R *.dfm}

type TCOLINFO = record
      defwidth:integer;
      name:string;
      expr:string;
      display_name:string;
     end;
     PCOLINFO = ^TCOLINFO;

const columns : array [0..5] of TCOLINFO =
(
  (defwidth:0;    name:'id';          expr:'id';            display_name:'id'),
  (defwidth:200;  name:'name';        expr:'name';          display_name:'Услуга'),
  (defwidth:100;  name:'price_count'; expr:'price_count';   display_name:'Цена за 1 ед.'),
  (defwidth:100;  name:'price_size';  expr:'price_size';    display_name:'Цена за 1 КБ'),
  (defwidth:100;  name:'price_time';  expr:'price_time';    display_name:'Цена за 1 сек.'),
  (defwidth:150;  name:'price_fixed'; expr:'price_fixed';   display_name:'Фиксированная цена')
);


constructor TPricesForm.CreateForm(_sql:TSQLLib);
begin
 inherited Create(nil);

 sql:=_sql;
 GridChanged:=false;
 StringGrid.Visible:=false;

 ThousandSeparator:=#0;
 DecimalSeparator:='.';
end;

destructor TPricesForm.Destroy;
begin
 sql:=nil;

 inherited;
end;

function TPricesForm.CBGridFill(i:PEXECSQLCBSTRUCT):boolean;
var n,numfields:integer;
    t:array[0..MAX_PATH] of char;
    obj:TObject;
    s_value:string;
    p:pchar;
begin
 numfields:=i.GetNumFields(i.obj);

 if i.idx=-1 then
  begin
   StringGrid.ColCount:=numfields;
   StringGrid.FixedCols:=2;
   StringGrid.RowCount:=1+i.numrecords;
   StringGrid.FixedRows:=1;
   for n:=0 to numfields-1 do
    begin
     t[0]:=#0;
     i.GetFieldDisplayName(i.obj,i.GetFieldByIdx(i.obj,n),t);
     StringGrid.Cells[n,0]:=string(t);
     StringGrid.Objects[n,0]:=nil;
     StringGrid.ColWidths[n]:=columns[n].defwidth;
    end;
  end
 else
  begin
   for n:=0 to numfields-1 do
    begin
     obj:=nil;
     s_value:='';

     if n=0 then
      begin
       s_value:=inttostr(i.GetFieldValueAsInt(i.obj,i.GetFieldByIdx(i.obj,n)));
      end
     else
     if n=1 then
      begin
       p:=i.GetFieldValueAsString(i.obj,i.GetFieldByIdx(i.obj,n));
       s_value:=p;
       i.FreePointer(p);
      end
     else
      begin
       s_value:=Format('%1.2f',[i.GetFieldValueAsDouble(i.obj,i.GetFieldByIdx(i.obj,n))]);
       obj:=TObject(1);
      end;

     StringGrid.Cells[n,i.idx+1]:=s_value;
     StringGrid.Objects[n,i.idx+1]:=obj;
    end;
  end;

 Result:=true;
end;

function CBGridFillWrapper(parm:PEXECSQLCBSTRUCT):longbool cdecl;
begin
 Result:=TPricesForm(parm.user_parm).CBGridFill(parm);
end;

procedure TPricesForm.FormShow(Sender: TObject);
var n:integer;
    q:string;
begin
 WaitCursor(true,false);

 q:='';
 for n:=0 to length(columns)-1 do
  begin
   if n>0 then
     q:=q+', ';
   q:=q+columns[n].expr+' AS '''+sql.EscapeString(columns[n].display_name)+'''';
  end;

 if sql.Exec('SELECT '+q+' FROM TPrices',SQL_DEF_TIMEOUT,nil,CBGridFillWrapper,self,true) then
  begin
   StringGrid.Visible:=true;
   StringGrid.SetFocus;
  end
 else
  begin
   MessageBox(Handle,pchar(S_ERR_LOADFROMBASE+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
  end;

 WaitCursor(false,false);
end;

procedure TPricesForm.FormClose(Sender: TObject; var Action: TCloseAction);
var n,m,id:integer;
    err:boolean;
begin
 if GridChanged and StringGrid.Visible then
  begin
   StringGrid.Visible:=false;
   WaitCursor(true,false);

   err:=false;
   for m:=1 to StringGrid.RowCount-1 do
    begin
     id:=strtointdef(StringGrid.Cells[0,m],-1);

     for n:=0 to StringGrid.ColCount-1 do
      if StringGrid.Objects[n,m]<>nil then
       begin
        if not sql.Exec('UPDATE TPrices SET '+columns[n].name+'='''+sql.EscapeString(StringGrid.Cells[n,m])+''' WHERE id='''+inttostr(id)+'''') then
         begin
          MessageBox(Handle,pchar(S_ERR_UPDATEPRICES+#13#10+#13#10+sql.GetLastError),S_ERR,MB_OK or MB_ICONERROR);
          err:=true;
          break;
         end;
       end;

     if err then
      break;
    end;

   WaitCursor(false,false);
  end;
end;

procedure TPricesForm.StringGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 GridChanged:=true;
end;

end.
