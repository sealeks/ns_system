unit LogikaThreadU;

interface

uses
  Classes, LogikaClasses, Windows, memStructsU, SysUtils,
  convFunc, InterfaceServerU, MyComms, DateUtils;

type
  TLogikaServerThread = class(TThread)

    { Private declarations }
  private
    fisExecuted: boolean;//stop in that plase what I want
    fAn: boolean;
    fpath: string;
    finitvar: boolean;
    PredLastCommand: integer;
    procedure InitServ;
    procedure Analizing;
    procedure Analize;

  protected
    syncTime: TDateTime;
  public
    fisstopped: boolean;
    server: TDeviceItems;
    fcomNum: integer;
    itemsList: TStringList;
    frtItems: TanalogMems;

    procedure UnInitVar;
    procedure InitVar;
    procedure Stops;
    procedure reset;
    constructor Create(irtItems: string; comNum: integer; comset: TCOMSet); overload;
    destructor Destroy; override;
    function DoRW: boolean;
    property isExecuted: boolean read fisExecuted write fisExecuted default False;
    property An: boolean read fAn write fAn default False;
    procedure Execute; override;
  end;


implementation


constructor TLogikaServerThread.Create(irtItems: string; comNum: integer;
  comset: TCOMSet);

begin
  inherited Create(False);
  IsMultiThread := True;
  fpath := irtItems;
  fComNum := comNum;
  itemsList := TStringList.Create;
  finitvar := False;
  frtItems := TanalogMems.Create(fpath);

  frtItems.SetAppName('#LogikaServ' + IntToStr(comNum));
  comset.db := 8;
  comset.sb := 1;
  syncTime := 0;
  comset.pt := 0;
  server := TDeviceItems.Create(frtItems, comNum, comset);

  PredLastCommand := 0;
  fAn := False;

end;


destructor TLogikaServerThread.Destroy;
begin
  Terminate;
  while not Terminated do
    sleep(50);
  UnInitVar;
  itemsList.Free;
  server.Close;
  server.Free;

  frtItems.Free;

  inherited Destroy;
end;

procedure TLogikaServerThread.Analize;
var
  i: integer;
  fl: boolean;
begin
  if not fAn then
    exit;
  fl := False;
  if assigned(server.analizefunc) then
    fl := True
  else
  begin
    for i := 0 to server.Count - 1 do
    begin
      if assigned(server.items[i].analizefunc) then
      begin
        fl := True;
        break;
      end;
    end;
  end;
  if fl then
    Synchronize(Analizing);
end;


procedure TLogikaServerThread.Analizing;
var
  i: integer;
begin
  if assigned(server.analizefunc) then
    server.analizefunc(server, 0, 0)
  else
  begin
    for i := 0 to server.Count - 1 do
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
  finitVar := True;
  server.Init;
end;


procedure TLogikaServerThread.UnInitVar;
begin
  finitVar := False;
  server.UnInit;
end;


procedure TLogikaServerThread.InitServ;
begin
  if (not server.Open) then
    exit;
  server.readDev;
  PredLastCommand := frtItems.command.CurLine;

end;



function TLogikaServerThread.DoRW: boolean;
var
  Last: longint;

  {***********************************************************************}
  { Writing pareameters                                                   }
  {***********************************************************************}
  function WriteCommand: boolean;
  var
    j: integer;

    function ExecuteCommand: boolean;
    begin
      Result := True;
      if frtItems.Command[j].Executed then
        exit
      else
      if (frtItems.Command[j].ID <> -1) then
      begin
        try
          Server.AddCommand(frtitems.GetName(frtItems.Command[j].ID),
            frtItems.Command[j].ValReal);
        except
        end;

      end;
    end;

  begin
    Result := False;

    try
      Last := PredLastCommand;

      if Last < frtItems.Command.CurLine then
        for j := Last to frtItems.Command.CurLine - 1 do
        begin
          Result := ExecuteCommand;
          Inc(predLastCommand); //увеличивать, если команда выполнилась
        end;

      if Last > frtItems.Command.CurLine then
      begin
        for j := Last to frtItems.Command.Count - 1 do
        begin
          Result := ExecuteCommand;
          Inc(predLastCommand);
        end;
        predLastCommand := 0;
        for j := 0 to frtItems.Command.CurLine - 1 do
        begin
          Result := ExecuteCommand;
          Inc(predLastCommand);
        end;
      end;

    except
    end;

  end;

  {***********************************************************************}
  { Reading pareameters                                                   }
  {***********************************************************************}
begin
  WriteCommand;
  Result := server.readDev;
  if (now() - syncTime) > 1 then
  begin
    server.Sync;
    syncTime := now();
  end;
end;


procedure TLogikaServerThread.Stops;
begin
  synchronize(reset);
end;


procedure TLogikaServerThread.reset;
begin
  fisExecuted := False;
end;


procedure TLogikaServerThread.Execute;
begin
  try
    fisExecuted := True;
    while not Terminated and fisExecuted do
    begin
      if not fisExecuted then
      begin
        Terminate;
        if server <> nil then
        begin
          try
            server.Close;
            server.setreqOff;
          except
            on E: Exception do
            begin
              if frtItems <> nil then
                frtitems.LogFatalError('Logika sever thread error To Stop Except');
            end
          end;
        end;
        exit;
      end;
      if not finitvar then
        synchronize(InitVar)
      else
      begin
        if not server.Connected then
          synchronize(Initserv)
        else
        begin
          try
            Analize;
            if not DORW then
              sleep(10)
            else
              sleep(10);
          except
            on E: Exception do
            begin
              if frtItems <> nil then
                frtitems.LogFatalError('Logika sever thread error In = ' + E.Message);
            end
          end;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      if frtItems <> nil then
        frtitems.LogFatalError('Logika sever thread error out');
    end
  end;
  fisExecuted := False;
  if frtItems <> nil then
    frtitems.LogError('Logika sever thread error To End');
  if server <> nil then
    try
      server.Close;
      server.setreqOff;
    except
      on E: Exception do
      begin
        if frtItems <> nil then
          frtitems.LogFatalError('Logika sever thread error To End Except');
      end
    end;
end;

end.
