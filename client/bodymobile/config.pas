unit config;

interface


type TContentItem = record
     title:string;
     icon:integer;
     path:string;
     end;
     PContentItem = ^TContentItem;

var ContentItems : array of TContentItem;
var UseThumbnails : boolean = false;

procedure ReadConfig;
procedure FreeConfig;
function IsAudioFile(s:string):boolean;
function IsVideoFile(s:string):boolean;
function IsPictureFile(s:string):boolean;

const MAXCONTENTICONS = 11;


implementation

uses SysUtils, Windows, Registry, tools;

const MAXWINITEMS = 200; // must be like in rshell!!!


procedure ReadConfig;
var n,i,s_icon,count:integer;
    s_num, s_num2, s_title, s_path : string;
    s_state : boolean;
begin
 UseThumbnails:=false;

 ContentItems:=nil;
 count:=0;
 for n:=1 to MAXWINITEMS do
  begin
   s_title:=ReadConfigStr('mobile_content','parm1_'+inttostr(n),'');
   s_path:=ReadConfigStr('mobile_content','parm2_'+inttostr(n),'');
   s_state:=ReadConfigInt('mobile_content','state_'+inttostr(n),0)<>0;
   if (s_title<>'') and (s_path<>'') and s_state then
    begin
     s_num:='';
     for i:=length(s_title) downto 1 do
       if s_title[i]='(' then
        begin
         s_num:=Copy(s_title,i,length(s_title)-i+1);
         SetLength(s_title,i-1);
         break;
        end;
     s_title:=trim(s_title);
     if s_title<>'' then
      begin
       s_num2:='';
       for i:=1 to length(s_num) do
        if (ord(s_num[i])>=ord('0')) and (ord(s_num[i])<=ord('9')) then
         s_num2:=s_num2+s_num[i];
       if s_num2='' then
        s_num2:='0';
       try
        s_icon:=strtoint(s_num2);
       except
        s_icon:=0;
       end;
       if s_icon<0 then 
         s_icon:=0;
       if s_icon>=MAXCONTENTICONS then 
         s_icon:=0;

       inc(count);
       SetLength(ContentItems,count);
       with ContentItems[count-1] do
        begin
         title:=s_title;
         icon:=s_icon;
         path:=s_path;
        end;
      end;
    end;
  end;
end;

procedure FreeConfig;
begin
 ContentItems:=nil;
end;


function IsFileExtInList(filename,list:string):boolean;
var ext:string;
begin
 ext:=ExtractFileExtStrict(filename);
 if (ext<>'') and (list<>'') then
   Result:=Pos(';'+AnsiLowerCase(ext)+';',';'+AnsiLowerCase(list)+';')<>0
 else
   Result:=false;
end;

function IsAudioFile(s:string):boolean;
begin
 Result:=IsFileExtInList(s,ReadConfigStr('','mobile_files_audio',''));
end;

function IsVideoFile(s:string):boolean;
begin
 Result:=IsFileExtInList(s,ReadConfigStr('','mobile_files_video',''));
end;

function IsPictureFile(s:string):boolean;
begin
 Result:=IsFileExtInList(s,ReadConfigStr('','mobile_files_pictures',''));
end;


end.
