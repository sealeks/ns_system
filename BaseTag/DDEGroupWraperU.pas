unit DDEGroupWraperU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,Windows,ItemAdapterU,FormOPCClientUE;

type
  TDDEGroupWraper = class(TGroupWraper)
  private
  function getApplication_conf(server_, host_, topic_ : string): string;
  function GetServer(Index: Integer): String;
  procedure SetServer(Index: Integer; value: String);
  function GetServer_(): String;
  procedure SetServer_(value: String);
  function GetDDETopic(Index: Integer): String;
  procedure SetDDETopic(Index: Integer; value: String);
  function GetDDETopic_(): String;
  procedure SetDDETopic_(value: String);
  function GetHost(Index: Integer): String;
  procedure SetHost(Index: Integer; value: String);
  function GetHost_(): String;
  procedure SetHost_(value: String);
    { Private declarations }
  public
  property Server[Index: Integer]: String read GetServer write SetServer;
  property Server_: String read GetServer_ write SetServer_;
  property DDETopic[Index: Integer]: String read GetDDETopic write SetDDETopic;
  property DDETopic_: String read GetDDETopic_ write SetDDETopic_;
  property Host[Index: Integer]: String read GetHost write SetHost;
  property Host_: String read GetHost_ write SetHost_;
  procedure setType();  override;
  procedure setMap();    override;
  function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TDDEGroupWraper.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Имя',GetName_);
         setPropertys('Сервер DDE',Server_);
         setPropertys('Topic',DDETopic_);
         setPropertys('Хост',Host_);
         setPropertys('Номер потока',Slave_);
         setPropertys('Приложение','NS_OPCDDEbridgeService.exe/NS_OPCDDEbridge_app.exe',true);
         setNew();
end;

function TDDEGroupWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Server_:=val;
   2: DDETopic_:=val;
   3: Host_:=val;
   4: Slave_:=val;


   end;


end;


procedure TDDEGroupWraper.SetType;
var i: integer;
begin
  Application_:='DDE[FooServer|Footopic]';
end;

function TDDEGroupWraper.GetServer(Index: Integer): String;
var str_temp: string;
begin
    result:= isDDE(trim(Application[index]),str_temp,str_temp);
end;

procedure TDDEGroupWraper.SetServer(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(value,Host[index],DDETopic[Index]);
end;



function TDDEGroupWraper.GetServer_(): String;
var i: integer;
begin
     result:=Server[0];
        for i:=1 to idscount-1 do
         if (Server[i]<>result) then
           begin
              result:='';
           end;

end;

procedure TDDEGroupWraper.SetServer_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Server[i]:=value;
end;

function TDDEGroupWraper.GetDDETopic(Index: Integer): String;
var str_temp: string;
begin
    result:='';
    isDDE(trim(Application[index]),str_temp,result);

end;


procedure TDDEGroupWraper.SetDDETopic(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(Server[index],Host[index],value);
end;


function TDDEGroupWraper.GetDDETopic_(): String;
var i: integer;
begin
     result:=DDETopic[0];
        for i:=1 to idscount-1 do
         if (DDETopic[i]<>result) then
           begin
              result:='';
           end;

end;

procedure TDDEGroupWraper.SetDDETopic_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     DDETopic[i]:=value;
end;


function TDDEGroupWraper.GetHost(Index: Integer): String;
var str_temp: string;
begin
    result:='';
    isDDE(trim(Application[index]),result,str_temp);

end;


procedure TDDEGroupWraper.SetHost(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(Server[index],value,DDETopic[index]);
end;


function TDDEGroupWraper.GetHost_(): String;
var i: integer;
begin
     result:=Host[0];
        for i:=1 to idscount-1 do
         if (Host[i]<>result) then
           begin
              result:='';
           end;

end;

procedure TDDEGroupWraper.SetHost_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Host[i]:=value;
end;

function TDDEGroupWraper.getApplication_conf(server_, host_, topic_ : string): string;
begin
    if topic_<>'' then
    result:='DDE['+server_+'|'+topic_+']'
    else result:='DDE['+server_+']';
    if (trim(host_)<>'') then result:=result+'[host:'+host_+']';

end;



end.
