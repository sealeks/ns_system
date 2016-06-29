unit LogikaThreadU;

interface

uses
  Classes, LogikaClasses, windows, memStructsU, sysUtils,
  convFunc, InterfaceServerU, {GlobalVar,} MyComms, DateUtils;

type
  TLogikaServerThread = class(TThread)//(TThread)

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





constructor TLogikaServerThread.create(irtItems : string; comNum: integer;comset: TCOMSet);

begin
  inherited create(false);
  IsMultiThread:=true;
  fpath := irtItems;
  fComNum:=comNum;
  itemsList:=TStringList.Create;
  finitvar:=false;
  finitserv:=false;
  frtItems := TanalogMems.Create(fpath);
  frtItems.SetAppName('#LogikaServ'+inttostr(comNum));
  comset.db:=8;
  comset.sb:=1;
  syncTime:=0;
  comset.pt:=0;
  server:=TDeviceItems.Create(frtItems,comNum,comset);
  PredLastCommand:=0;
  fAn:=false;
end;





destructor TLogikaServerThread.destroy;
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

procedure TLogikaServerThread.Analize;
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

procedure TLogikaServerThread.Analizing;
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

procedure TLogikaServerThread.InitVar;
begin
   finitVar:=(frtItems<>nil);
   server.Init;
end;


procedure TLogikaServerThread.UnInitVar;
begin
   if (frtItems<>nil) then frtItems.Free;
   server.UnInit;
end;

procedure TLogikaServerThread.InitServ;
begin
   if  (frtItems=nil) then exit;

   if (not server.Open) then exit;
   finitserv:=true;
   server.readDev;
   PredLastCommand:=frtItems.command.CurLine;

end;

procedure TLogikaServerThread.UnInitServ;
begin
   finitserv:=false;
end;






function TLogikaServerThread.DoRW:boolean;
var
  Last: longInt;

{***********************************************************************}
{ Writing pareameters                                                   }
{***********************************************************************}
  function WriteCommand: boolean;
  var j: integer;

  function ExecuteCommand: boolean;
    begin
      result:=true;
      if frtItems.Command[j].Executed then exit
      else
      if (frtItems.Command[j].ID <> -1)then
      begin

          try
            Server.AddCommand (frtitems.GetName(frtItems.Command[j].ID),frtItems.Command[j].ValReal);
          except
          end;


      end;
end;


begin
  result:=false;

    try
      Last := PredLastCommand;

      if Last < frtItems.Command.CurLine then
        for j := Last to frtItems.Command.CurLine - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand); //увеличивать, если команда выполнилась
        end;

      if Last > frtItems.Command.CurLine then begin
        for j := Last to  frtItems.Command.Count - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand)
        end;
        predLastCommand := 0;
        for j := 0 To frtItems.Command.CurLine - 1 do
        begin
          result:=ExecuteCommand;
          inc(predLastCommand)
        end;
      end;

{      for j := PredLastCommand - 1 downto 0 do
        ExecuteCommand;}
    except
     // if   WriteErrorCount < 3 then begin
     //   inc (WriteErrorCount);
     //   frtItems.ClearCommandExecuted(j);
    //  end else WriteErrorCount := 0; //Сбрасываем команду при трех неудачных попытках записи

    end; //except


   end;
{***********************************************************************}
{ Reading pareameters                                                   }
{***********************************************************************}
begin
    WriteCommand;
    result:=server.readDev;
    if (now()-syncTime)>1 then
      begin
        server.Sync;
        syncTime:=now();
      end;
end;











{procedure TLogikaServerThread.Analize;
var i: integer;
 //   AskItems_:  TAscItems;
begin
 {  if self.Terminated then exit;
   if assigned(analizefunc) then
        fanalizefunc(self,self.curReadid,self.curforceReadid) else
           for i:=0 to itemslist.Count-1 do
            begin
              AskItems_:=TAscItems(itemslist.Objects[i]);
              if assigned(AskItems_.analizefunc) then
               begin
                 AskItems_.analizefunc(AskItems_);
                 exit;
               end;
            end;   }
{end;  }


function TLogikaServerThread.term: boolean;
begin
   result:=self.Terminated ;
end;



procedure TLogikaServerThread.Stops;
begin
    synchronize(reset);
end;

procedure TLogikaServerThread.reset;
begin
 fisExecuted:=false;
end;

procedure TLogikaServerThread.Execute;

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
