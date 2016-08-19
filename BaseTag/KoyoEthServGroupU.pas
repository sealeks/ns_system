unit KoyoEthServGroupU;



interface

uses
  Classes, SimpleGroupAdapterU, SysUtils, StrUtils, ItemAdapterU,
  ServerU, InterfaceServerU;

// com - номер порта  1..255
// br BaudRate - скорость 110..115200
// db-  Databit       5..8
// sb - StopBits      1,1.5,2
// pt - ParityBit     None, Odd, Even, Mark, Space
// trd-  задержка в миллисекундах до esc  FlowControlBeforeSleep       //   Eth
// red-  задержка в миллисекундах после esc  FlowControlAfterSleep     //   -адресс
// ri -  ReadInterval
// rtm - ReadTotalMultiplier                                           // protocol
// rtc - ReadTotalConstant                                             // transport
// wtm - WriteTotalMultiplier                                          // ip
// wtc - WriteTotalConstan
// bs -  blockSize
// frt - ReadTimeOUT
// frd - DirectTimeOUT
// trc - TryCount попытки чтения                                        //tryCount
//  tstrt - время начала часового цикла опроса
//  tstp  - время конца часового цикла опроса
//  prttm - задержка перед puge порта
//  wait  - wait в  WaitForSingleObject                                 //TimeOut


type
  TKoyoEthServGroup = class(TGroupWraper)
  private
    com: TCOMSet;
    function getCom(i: integer): TCOMSet;
    function getTopic_conf(val: TCOMSet): string;
    function getApplication_conf(): string;




    function GetProtocol(Index: integer): integer;
    procedure SetProtocol(Index: integer; Value: integer);
    function GetProtocol_(): string;
    procedure SetProtocol_(Value: string);
    function GetTransport(Index: integer): integer;
    procedure SetTransport(Index: integer; Value: integer);
    function GetTransport_(): string;
    procedure SetTransport_(Value: string);

    function GetBlockSize(Index: integer): integer;
    procedure SetBlockSize(Index: integer; Value: integer);
    function GetBlockSize_(): string;
    procedure SetBlockSize_(Value: string);

    function GetIP(Index: integer): integer;
    procedure SetIP(Index: integer; Value: integer);
    function GetIP_(): string;
    procedure SetIP_(Value: string);

    function GetEth(Index: integer): int64;
    procedure SetEth(Index: integer; Value: int64);
    function GetEth_(): string;
    procedure SetEth_(Value: string);

    function GetHost(Index: integer): string;
    procedure SetHost(Index: integer; Value: string);
    function GetHost_(): string;
    procedure SetHost_(Value: string);

    function GetReadTimeout(Index: integer): integer;
    procedure SetReadTimeout(Index: integer; Value: integer);
    function GetReadTimeout_(): string;
    procedure SetReadTimeout_(Value: string);
    function GetDirectTimeout(Index: integer): integer;
    procedure SetDirectTimeout(Index: integer; Value: integer);
    function GetDirectTimeout_(): string;
    procedure SetDirectTimeout_(Value: string);
    function GetTryCount(Index: integer): integer;
    procedure SetTryCount(Index: integer; Value: integer);
    function GetTryCount_(): string;
    procedure SetTryCount_(Value: string);
    function GetStart(Index: integer): integer;
    procedure SetStart(Index: integer; Value: integer);
    function GetStart_(): string;
    procedure SetStart_(Value: string);
    function GetStop(Index: integer): integer;
    procedure SetStop(Index: integer; Value: integer);
    function GetStop_(): string;
    procedure SetStop_(Value: string);

    function GetWait(Index: integer): integer;
    procedure SetWait(Index: integer; Value: integer);
    function GetWait_(): string;
    procedure SetWait_(Value: string);
  public
    procedure SetType; override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;

    property Protocol[Index: integer]: integer read GetProtocol write SetProtocol;
    property Protocol_: string read GetProtocol_ write SetProtocol_;
    property Transport[Index: integer]: integer read GetTransport write SetTransport;
    property Transport_: string read GetTransport_ write SetTransport_;

    property BlockSize[Index: integer]: integer read GetBlockSize write SetBlockSize;
    property BlockSize_: string read GetBlockSize_ write SetBlockSize_;
    property IP[Index: integer]: integer read GetIP write SetIP;
    property IP_: string read GetIP_ write SetIP_;
    property Eth[Index: integer]: int64 read GetEth write SetEth;
    property Eth_: string read GetEth_ write SetEth_;
    property Host[Index: integer]: string read GetHost write SetHost;
    property Host_: string read GetHost_ write SetHost_;
    property ReadTimeout[Index: integer]: integer
      read GetReadTimeout write SetReadTimeout;
    property ReadTimeout_: string read GetReadTimeout_ write SetReadTimeout_;
    property DirectTimeout[Index: integer]: integer
      read GetDirectTimeout write SetDirectTimeout;
    property DirectTimeout_: string read GetDirectTimeout_ write SetDirectTimeout_;
    property TryCount[Index: integer]: integer read GetTryCount write SetTryCount;
    property TryCount_: string read GetTryCount_ write SetTryCount_;
    property Start[Index: integer]: integer read GetStart write SetStart;
    property Start_: string read GetStart_ write SetStart_;
    property Stop[Index: integer]: integer read GetStop write SetStop;
    property Stop_: string read GetStop_ write SetStop_;

    property Wait[Index: integer]: integer read GetWait write SetWait;
    property Wait_: string read GetWait_ write SetWait_;
  end;

implementation




function protocoltostr(val: integer): string;
begin
  case val of
    1: Result := 'HOST';
    2: Result := 'IPX';
    3: Result := 'IP';
    else
      Result := 'NODEF'
  end;
end;

function strtoprotocol(val: string): integer;
begin
  val := trim(val);
  Result := 3;
  if 'HOST' = val then
    Result := 1;
  if 'IPX' = val then
    Result := 2;
  if 'IP' = val then
    Result := 3;
end;


function brProtocol(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('IP');
  Result.Add('HOST');
  Result.Add('IPX');

end;


function transporttostr(val: integer): string;
begin
  case val of
    1: Result := 'HOST';
    2: Result := 'IPX';
    4: Result := 'WINSOCK';
    else
      Result := 'NODEF'
  end;
end;

function strtotransport(val: string): integer;
begin
  val := trim(val);
  Result := 3;
  if 'HOST' = val then
    Result := 1;
  if 'IPX' = val then
    Result := 2;
  if 'WINSOCK' = val then
    Result := 4;
end;


function brtransport(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('WINSOCK');
  Result.Add('HOST');
  Result.Add('IPX');

end;

function iptostr(val: integer): string;
var
  a1, a2, a3, a4: byte;
begin
  Result := '';
  if val = 0 then
    exit;
  a1 := $ff and val;
  a2 := $ff and (val shr 8);
  a3 := $ff and (val shr 16);
  a4 := $ff and (val shr 24);
  Result := format('%3u.%3u.%3u.%3u', [a4, a3, a2, a1]);
end;



function strtoip(val: string): integer;
var
  a: array[0..3] of byte;
  i, j: integer;
  val_: string;
begin
  a[0] := 0;
  a[1] := 0;
  a[2] := 0;
  a[3] := 0;
  j := 0;
  Result := 0;
  if (trim(val) = '') then
    exit;
  try
    while ((pos('.', val) > 0) and (j < 4)) do
    begin
      val_ := Leftstr(val, pos('.', val) - 1);
      val := Rightstr(val, length(val) - pos('.', val));
      a[3 - j] := strtointdef(trim(val_), 0);
      j := j + 1;
    end;
    val := trim(val);
    a[3 - j] := strtointdef(trim(val), 0);
  except
  end;
  Result := 0;
  for i := 3 downto 0 do
    Result := (Result shl 8) + a[i];
end;

function Ethtostr_(val2, val1: integer): string;
var
  a1, a2, a3, a4, a5, a6: byte;
begin
  a1 := $ff and val1;
  a2 := $ff and (val1 shr 8);
  a3 := $ff and (val1 shr 16);
  a4 := $ff and val2;
  a5 := $ff and (val2 shr 8);
  a6 := $ff and (val2 shr 16);
  Result := format('%2x:%2x:%2x:%2x:%2x:%2x', [a6, a5, a4, a3, a2, a1]);
end;

function StrtoEth(val: string): int64;

  function HexToInt(Text: string): integer;
  var
    i: integer;
  begin
    Result := 0;
    Text := trim(uppercase(Text));
    for i := 1 to length(Text) do
      case Text[i] of
        '0': Result := Result shl 4 + 0;
        '1': Result := Result shl 4 + 1;
        '2': Result := Result shl 4 + 2;
        '3': Result := Result shl 4 + 3;
        '4': Result := Result shl 4 + 4;
        '5': Result := Result shl 4 + 5;
        '6': Result := Result shl 4 + 6;
        '7': Result := Result shl 4 + 7;
        '8': Result := Result shl 4 + 8;
        '9': Result := Result shl 4 + 9;
        'A': Result := Result shl 4 + 10;
        'B': Result := Result shl 4 + 11;
        'C': Result := Result shl 4 + 12;
        'D': Result := Result shl 4 + 13;
        'E': Result := Result shl 4 + 14;
        'F': Result := Result shl 4 + 15;
      end;
  end;

var
  a: array[0..5] of byte;
  i, j: integer;
  val_: string;
  // valtemp: Int64;
begin
  Result := 0;
  if trim(val) = '' then
    exit;
  a[0] := 0;
  a[1] := 0;
  a[2] := 0;
  a[3] := 0;
  a[4] := 0;
  a[5] := 0;
  j := 0;
  try
    while ((pos(':', val) > 0) and (j < 6)) do
    begin
      val_ := Leftstr(val, pos(':', val) - 1);
      val := Rightstr(val, length(val) - pos(':', val));
      a[5 - j] := HexToInt(trim(val_));
      j := j + 1;
    end;
    val := trim(val);
    a[5 - j] := HexToInt(trim(val));
  except
  end;
  Result := 0;
  for i := 5 downto 0 do
    Result := (Result shl 8) + a[i];
end;


function Ethtostr(val: int64): string;
begin
  Result := '';
  if val = 0 then
    exit;
  Result := Ethtostr_((val and $FFFFFF000000) shr 24, (val and $FFFFFF));
end;




function strtodb(val: string): integer;
begin
  val := trim(val);
  Result := 0;
  if '5' = val then
    Result := 5;
  if '6' = val then
    Result := 6;
  if '7' = val then
    Result := 7;

  if Result = 0 then
    Result := 8;

end;


function dbSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('5');
  Result.Add('6');
  Result.Add('7');
  Result.Add('8');
end;


function sbtostr(val: integer): string;
begin
  case val of
    3: Result := '1.5';
    2: Result := '2';
    else
      Result := '1'
  end;
end;

function strtosb(val: string): integer;
begin
  val := trim(val);
  Result := 0;
  if '1.5' = val then
    Result := 3;
  if '2' = val then
    Result := 2;
  if Result = 0 then
    Result := 1;

end;


function sbSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('1');
  Result.Add('1.5');
  Result.Add('2');
end;


function pttostr(val: integer): string;
begin
  case val of
    1: Result := 'Odd';
    2: Result := 'Even';
    3: Result := 'Mark';
    4: Result := 'Space';
    else
      Result := 'None'
  end;
end;

function strtopt(val: string): integer;
begin
  val := Uppercase(trim(val));
  Result := 0;
  if 'ODD' = val then
    Result := 1;
  if 'EVEN' = val then
    Result := 2;
  if 'MARK' = val then
    Result := 3;
  if 'SPACE' = val then
    Result := 4;

end;


function ptSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Odd');
  Result.Add('Even');
  Result.Add('Mark');
  Result.Add('Space');
  Result.Add('None');
end;




function TKoyoEthServGroup.getCom(i: integer): TCOMSet;
begin
  isCom(Topic[i], 'ETH', com);
  Result := com;
end;



procedure TKoyoEthServGroup.setMap();
begin

  editor.Strings.Clear;

  if (getCount = 1) then
    setPropertys('Имя', GetName_);
  setPropertys('Номер устройства', Slave_);
  setPropertys('Transport', self.Transport_, brtransport);
  setPropertys('Protocol', self.Protocol_, brprotocol);
  setPropertys('IP (опционально)', self.IP_);
  setPropertys('EthAdress (опционально)', self.Eth_);
  setPropertys('HostName (опционально)', self.Host_);
  setPropertys('Размер блока данных', self.BlockSize_);
  setPropertys('ReadTimeout', self.ReadTimeout_);
  setPropertys('DirectTimeout', self.DirectTimeout_);
  setPropertys('Попыток чтения', self.TryCount_);
  setPropertys('Начальная минута часового цикла опроса', Start_);
  setPropertys('Конечная минута часового цикла опроса', Stop_);
  setPropertys('Системный таймаут ожидания ответа', Wait_);
  setPropertys('Приложение', 'ServerKoyo_Service.exe/IServerKoyo_Prj.exe', True);
  setNew();

end;

function TKoyoEthServGroup.setchange(key: integer; val: string): string;
begin
  Result := '';
  if (getCount > 1) then
    key := key + 1;

  case key of
    0:
    begin
      Name_ := val;
      Result := val;
    end;
    1: Slave_ := val;
    2: Transport_ := val;
    3: Protocol_ := val;
    4: IP_ := val;
    5: Eth_ := val;
    6: Host_ := val;
    7: BlockSize_ := val;
    8: DirectTimeout_ := val;
    9: TryCount_ := val;
    10: Start_ := val;
    11: Stop_ := val;
    12: Wait_ := val;

  end;

end;


procedure TKoyoEthServGroup.SetType;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'eth[rtm3,rtc4,trd0,red0,wtm0]';
end;



function TKoyoEthServGroup.GetProtocol(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtm;
end;

procedure TKoyoEthServGroup.SetProtocol(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetProtocol_(): string;
var
  i: integer;
begin
  Result := protocoltostr(Protocol[0]);
  for i := 1 to idscount - 1 do
    if (protocoltostr(Protocol[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetProtocol_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Protocol[i] := strtoprotocol(Value);
end;

function TKoyoEthServGroup.GetTransport(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtc;
end;

procedure TKoyoEthServGroup.SetTransport(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetTransport_(): string;
var
  i: integer;
begin
  Result := transporttostr(Transport[0]);
  for i := 1 to idscount - 1 do
    if (transporttostr(Transport[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetTransport_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Transport[i] := strtotransport(Value);
end;



function TKoyoEthServGroup.GetBlockSize(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.bs;
end;

procedure TKoyoEthServGroup.SetBlockSize(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.bs := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetBlockSize_(): string;
var
  i: integer;
begin
  Result := IntToStr(BlockSize[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(BlockSize[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetBlockSize_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    BlockSize[i] := StrToInt(Value);
end;

function TKoyoEthServGroup.GetIP(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtm;
end;

procedure TKoyoEthServGroup.SetIP(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetIP_(): string;
var
  i: integer;
begin
  Result := iptostr(IP[0]);
  for i := 1 to idscount - 1 do
    if (iptostr(IP[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetIP_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    IP[i] := strtoip(Value);
end;

function TKoyoEthServGroup.GetEth(Index: integer): int64;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trd;
  Result := ((Result shl 24) and $FFFFFF000000) + (com.red and $FFFFFF);
end;

procedure TKoyoEthServGroup.SetEth(Index: integer; Value: int64);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trd := (Value and $FFFFFF000000) shr 24;
  com_.red := (Value and $FFFFFF);
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetEth_(): string;
var
  i: integer;
begin
  Result := ethtostr(Eth[0]);
  for i := 1 to idscount - 1 do
    if (ethtostr(Eth[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetEth_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Eth[i] := strtoeth(Value);
end;

function TKoyoEthServGroup.GetHost(Index: integer): string;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.Name;

end;

procedure TKoyoEthServGroup.SetHost(Index: integer; Value: string);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.Name := Value;

  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetHost_(): string;
var
  i: integer;
begin
  Result := Host[0];
  for i := 1 to idscount - 1 do
    if (Host[i] <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetHost_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Host[i] := Value;
end;


function TKoyoEthServGroup.GetReadTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frt;
end;

procedure TKoyoEthServGroup.SetReadTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetReadTimeout_(): string;
var
  i: integer;
begin
  Result := IntToStr(ReadTimeout[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(ReadTimeout[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetReadTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTimeout[i] := StrToInt(Value);
end;


function TKoyoEthServGroup.GetDirectTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frd;
end;

procedure TKoyoEthServGroup.SetDirectTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frd := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetDirectTimeout_(): string;
var
  i: integer;
begin
  Result := IntToStr(DirectTimeout[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(DirectTimeout[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetDirectTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    DirectTimeout[i] := StrToInt(Value);
end;

function TKoyoEthServGroup.GetTryCount(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trc;
end;

procedure TKoyoEthServGroup.SetTryCount(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetTryCount_(): string;
var
  i: integer;
begin
  Result := IntToStr(TryCount[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(TryCount[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetTryCount_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    TryCount[i] := StrToInt(Value);
end;

function TKoyoEthServGroup.GetStart(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.tstrt;
end;

procedure TKoyoEthServGroup.SetStart(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.tstrt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetStart_(): string;
var
  i: integer;
begin
  Result := IntToStr(Start[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(Start[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetStart_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Start[i] := StrToInt(Value);
end;

function TKoyoEthServGroup.GetStop(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.tstp;
end;

procedure TKoyoEthServGroup.SetStop(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.tstp := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetStop_(): string;
var
  i: integer;
begin
  Result := IntToStr(Stop[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(Stop[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetStop_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Stop[i] := StrToInt(Value);
end;


function TKoyoEthServGroup.GetWait(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wait;
end;

procedure TKoyoEthServGroup.SetWait(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wait := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoEthServGroup.GetWait_(): string;
var
  i: integer;
begin
  Result := IntToStr(Wait[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(Wait[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoEthServGroup.SetWait_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Wait[i] := StrToInt(Value);
end;

function TKoyoEthServGroup.getTopic_conf(val: TCOMSet): string;
begin
   {ComSet.br:=9600;
   ComSet.db:=7;
   ComSet.sb:=1;
   ComSet.pt:=0;
   ComSet.trd:=50;
   ComSet.red:=50;
   ComSet.ri:=100;
   ComSet.rtm:=3000;
   ComSet.rtc:=3000;
   ComSet.wtm:=3000;
   ComSet.wtc:=3000;
   ComSet.bs:=64;
   ComSet.flCtrl:=false;
   ComSet.frt:=60;
   ComSet.trd:=60;
   ComSet.trc:=3;
   ComSet.tstrt:=-1;
   ComSet.tstp:=61;
   ComSet.prttm:=500;

   Comset.wait:=3000;}
  //  if val.Com>255 then val.Com:=255;
  //  if val.Com<1 then val.Com:=1;
  //  if not((val.br=110) or (val.br=300) or (val.br=600) or (val.br=1200) or (val.br=2400) or
  //  //   (val.br=4800) or (val.br=9600) or (val.br=14400) or (val.br=19200) or (val.br=38400)
  //   or (val.br=56000) or (val.br=115200)) then val.br:=9600;
  // if not((val.db=5) or (val.db=6) or (val.DB=7) or (val.DB=8)) then val.DB:=8;
  if not ((val.rtm = 3) or (val.rtm = 2) or (val.rtm = 1)) then
    val.sb := 3;
  if not ((val.rtc = 1) or (val.rtc = 2) or (val.rtc = 4)) then
    val.rtc := 4;

  if val.Com < 1 then
    val.Com := 1;
  Result := 'eth[';
  if val.Com < 1 then
    val.Com := 1;
  if (val.Com > 0) then
    Result := Result + 'com' + IntToStr(val.Com);
  Result := Result + ',trd' + IntToStr(val.trd);
  Result := Result + ',red' + IntToStr(val.red);
  if (val.rtm <> 3000) then
    Result := Result + ',rtm' + IntToStr(val.rtm);
  if (val.rtc <> 3000) then
    Result := Result + ',rtc' + IntToStr(val.rtc);
  if (val.wtm <> 3000) then
    Result := Result + ',wtm' + IntToStr(val.wtm);
  if (val.wtc <> 3000) then
    Result := Result + ',wtc' + IntToStr(val.wtc);
  if (val.bs <> 64) then
    Result := Result + ',bs' + IntToStr(val.bs);
  if (val.frt <> 60) then
    Result := Result + ',frt' + IntToStr(val.frt);
  if (val.frd <> 60) then
    Result := Result + ',frd' + IntToStr(val.frd);
  if (val.trc <> 3) then
    Result := Result + ',trc' + IntToStr(val.trc);
  if (val.tstrt > 0) then
    Result := Result + ',tstrt' + IntToStr(val.tstrt);
  if (val.tstp < 61) then
    Result := Result + ',tstp' + IntToStr(val.tstp);
  if (val.wait <> 3000) then
    Result := Result + ',wait' + IntToStr(val.wait);
  if (trim(val.Name) <> '') then
    Result := Result + ',name' + val.Name;
  Result := Result + ']';
end;

function TKoyoEthServGroup.getApplication_conf(): string;
begin
  Result := 'DirectKoyoServ';
  ;
end;

end.
