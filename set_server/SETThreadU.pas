unit SETThreadU;

interface

uses
  Classes, SETClasses, Windows, memStructsU, SysUtils,
  convFunc, InterfaceServerU, {GlobalVar,} MyComms, DateUtils;

type
  TSETServerThread = class(TThread)//(TThread)

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
    function term: boolean;
    property isExecuted: boolean read fisExecuted write fisExecuted default False;
    property An: boolean read fAn write fAn default False;
    procedure Execute; override;
  end;


implementation




constructor TSETServerThread.Create(irtItems: string; comNum: integer; comset: TCOMSet);

begin
  inherited Create(False);
  IsMultiThread := True;
  fpath := irtItems;
  fComNum := comNum;
  itemsList := TStringList.Create;
  finitvar := False;
  frtItems := TanalogMems.Create(fpath);
  frtItems.SetAppName('#SETServ' + IntToStr(comNum));
  comset.db := 8;
  comset.sb := 1;
  syncTime := 0;
  comset.pt := 1;
  server := TDeviceItems.Create(frtItems, comNum, comset);
  PredLastCommand := 0;
  fAn := False;
end;

destructor TSETServerThread.Destroy;
begin
  self.Terminate;
  while not Terminated do
    sleep(50);
  UnInitVar;
  itemsList.Free;
  server.Close;
  server.Free;
  inherited Destroy;
end;

procedure TSETServerThread.Analize;
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

procedure TSETServerThread.Analizing;
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


procedure TSETServerThread.InitVar;
begin
  finitVar := (frtItems <> nil);
  server.Init;
end;

procedure TSETServerThread.UnInitVar;
begin
  if (frtItems <> nil) then
    frtItems.Free;
  server.UnInit;
end;


procedure TSETServerThread.InitServ;
begin
  if (frtItems = nil) then
    exit;
  if (not server.Connected) then
    exit;
  server.readDev;
  PredLastCommand := frtItems.command.CurLine;
end;


function TSETServerThread.DoRW: boolean;
begin
  Result := server.readDev;
end;


function TSETServerThread.term: boolean;
begin
  Result := self.Terminated;
end;


procedure TSETServerThread.Stops;
begin
  synchronize(reset);
end;


procedure TSETServerThread.reset;
begin
  fisExecuted := False;
end;

procedure TSETServerThread.Execute;

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
          end;
        end;
        exit;
      end;
      if not finitvar then
        synchronize(InitVar)
      else
      if not server.Connected then
        synchronize(Initserv)
      else
        begin
          Analize;
          if not DORW then
            sleep(10)
          else
            sleep(10);
        end;
    end;
  except
  end;
  fisExecuted := False;

  if server <> nil then
  begin
    try
      server.Close;
      server.setreqOff;
    except
    end;
  end;

end;

end.
