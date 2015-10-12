unit SETThreadU;

interface

uses
  Classes, SETClasses, windows, memStructsU, sysUtils,
  convFunc, InterfaceServerU, {GlobalVar,} MyComms, DateUtils;

type
  TSETServerThread = class(TThread)//(TThread)

    { Private declarations }
    private
    fisExecuted: boolean;//stop in that plase what I want
    fAn: boolean;
    fpath: string;
    finitvar: boolean;
    finitserv: boolean;
    PredLastCommand : integer;
    procedure InitServ;
    procedure UnInitServ;
    procedure Analizing;
    procedure Analize;

  protected
    syncTime: TDateTime;
//    procedure SetRTItems; //for synhronize
  public
    fisstopped: boolean;
    server: TDeviceItems;
    fcomNum: integer;
    itemsList: TStringList;
    frtItems : TanalogMems;

    procedure UnInitVar;
    procedure InitVar;
    procedure Stops;
    procedure reset;
    constructor create(irtItems : string; comNum: integer; comset: TCOMSet); overload;
    destructor destroy; override;
    function DoRW: boolean;
    function term: boolean;
    property isExecuted: boolean read fisExecuted write fisExecuted default false;
    property An: boolean read fAn write fAn default false;
    procedure Execute; override;
  end;


implementation





constructor TSETServerThread.create(irtItems : string; comNum: integer;comset: TCOMSet);

begin
  inherited create(false);
  fpath := irtItems;
  fComNum:=comNum;
  itemsList:=TStringList.Create;
  finitvar:=false;
  finitserv:=false;
  frtItems := TanalogMems.Create(fpath);
  frtItems.SetAppName('#SETServ'+inttostr(comNum));
  comset.db:=8;
  comset.sb:=1;
  syncTime:=0;
  comset.pt:=1;
  server:=TDeviceItems.Create(frtItems,comNum,comset);
  PredLastCommand:=0;
  fAn:=false;
end;





destructor TSETServerThread.destroy;
begin
self.Terminate;
while not Terminated do
sleep(50);
UnInitVar;
UnInitserv;
itemsList.Free;
server.close;
server.Free;
inherited destroy;
end;

procedure TSETServerThread.Analize;
var i: integer;
    fl: boolean;
begin
  if not fAn then exit;
  fl:=false;
  if assigned(server.analizefunc) then fl:=true else
  begin
      for i:=0 to server.Count-1 do
        begin
          if assigned(server.items[i].analizefunc) then
            begin
            fl:=true;
            break;
            end;
        end;
  end;
  if fl then
    Synchronize(Analizing);
end;

procedure TSETServerThread.Analizing;
var i: integer;
begin
  if assigned(server.analizefunc) then server.analizefunc(server, 0, 0) else
  begin
      for i:=0 to server.Count-1 do
        begin
          if assigned(server.items[i].analizefunc) then
            begin
              server.items[i].analizefunc(server.items[i], 0, 0);
              exit;
            end;
        end;
  end;

end;

procedure TSETServerThread.InitVar;
begin
   finitVar:=(frtItems<>nil);
   server.Init;
end;


procedure TSETServerThread.UnInitVar;
begin
   if (frtItems<>nil) then frtItems.Free;
   server.UnInit;
end;

procedure TSETServerThread.InitServ;
begin
   if  (frtItems=nil) then exit;

   if (not server.Open) then exit;
   finitserv:=true;
   server.readDev;
   PredLastCommand:=frtItems.command.CurLine;

end;

procedure TSETServerThread.UnInitServ;
begin
   finitserv:=false;
end;






function TSETServerThread.DoRW:boolean;
var
  Last: longInt;


{***********************************************************************}
{ Reading pareameters                                                   }
{***********************************************************************}
begin
    //WriteCommand;
    result:=server.readDev;
    {if (now()-syncTime)>1 then
      begin
        server.Sync;
        syncTime:=now();
      end;  }
end;














function TSETServerThread.term: boolean;
begin
   result:=self.Terminated ;
end;



procedure TSETServerThread.Stops;
begin
    synchronize(reset);
end;

procedure TSETServerThread.reset;
begin
 fisExecuted:=false;
end;

procedure TSETServerThread.Execute;

begin
try
fisExecuted:=true;
while not Terminated and fisExecuted do
begin
if not fisExecuted then
  begin
   Terminate;
   if server<>nil then
    begin
    try
    server.Close;
    server.setreqOff;
    except
    end;
    end;
   exit;
  end;
if not finitvar then synchronize(InitVar) else
 if not finitserv then synchronize(Initserv) else
  Analize;
  begin
  if true then
    begin
      if not DORW then
      sleep (10) else
      sleep(10);
    end;

  end;
end;
except
end;
fisExecuted:=false;

 if server<>nil then
    begin
    try
    server.Close;
    server.setreqOff;
    except
    end;
    end;
end;

end.
