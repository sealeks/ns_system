unit SocketWraperU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,Windows,ItemAdapterU;

type
  TSocketWraper = class(TGroupWraper)
  private
    { Private declarations }
    function getApplication_conf(_server : string): string;
    function GetServer(Index: Integer): String;
    procedure SetServer(Index: Integer; value: String);
    function GetServer_(): String;
    procedure SetServer_(value: String);
  public
    property Server[Index: Integer]: String read GetServer write SetServer;
    property Server_: String read GetServer_ write SetServer_;
    procedure setType();  override;
    procedure setMap();    override;
    function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TSocketWraper.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Имя',GetName_);
         setPropertys('Сетевой адресс',Server_);
         setPropertys('Приложение','NS_NetShareService.exe/NS_NetShareService_app.exe',true);
         setNew();
end;

function TSocketWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Server_:=val;


   end;


end;


procedure TSocketWraper.SetType;
var i: integer;
begin
  Application_:='\\IP.IP.IP.IP\';
  Topic_:='';
end;

function TSocketWraper.GetServer(Index: Integer): String;
var str_temp: string;
begin
    str_temp:=Application[Index];
    if pos('\\', str_temp) = 1 then
    begin
      result := copy(str_temp, 3, length(str_temp) - 2);
      if pos('\', result) <> 0 then result := copy(result, 1, pos('\', result) - 1);
    end;
end;

procedure TSocketWraper.SetServer(Index: Integer; value: String);
begin
   Application[index]:=getApplication_conf(value);
end;



function TSocketWraper.GetServer_(): String;
var i: integer;
begin
     result:=Server[0];
        for i:=1 to idscount-1 do
         if (Server[i]<>result) then
           begin
              result:='';
           end;

end;

procedure TSocketWraper.SetServer_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Server[i]:=value;
end;

function TSocketWraper.getApplication_conf(_server : string): string;
begin
  result:='\\'+_server+'\';
end;
end.
