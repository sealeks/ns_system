unit KoyoServGroupsU;

interface

uses
  Classes, SimpleGroupAdapterU, SysUtils, StrUtils, ItemAdapterU,
  ServerU, InterfaceServerU;

type
  TKoyotypeconn = (ktcCom, ktcEth, ktcRmod, ktcTmod);

// com - номер порта  1..255
// br BaudRate - скорость 110..115200
// db-  Databit       5..8
// sb - StopBits      1,1.5,2
// pt - ParityBit     None, Odd, Even, Mark, Space
// trd-  задержка в миллисекундах до esc  FlowControlBeforeSleep
// red-  задержка в миллисекундах после esc  FlowControlAfterSleep
// ri -  ReadInterval
// rtm - ReadTotalMultiplier
// rtc - ReadTotalConstant
// wtm - WriteTotalMultiplier
// wtc - WriteTotalConstan
// bs -  blockSize
// frt - ReadTimeOUT    //  таймаут разрыва связи
// frd - DirectTimeOUT
// trc - TryCount попытки чтения
//  tstrt - время начала часового цикла опроса
//  tstp  - время конца часового цикла опроса
//  prttm - задержка перед puge порта
//  wait  - wait в  WaitForSingleObject


type
  TKoyoServGroups = class(TGroupWraper)
  private
    com: TCOMSet;
    procedure SetTypeCom;
    procedure SetTypeEth;
    procedure SetTypeRmod;
    procedure SetTypeTmod;
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
    function GetProtocol(Index: integer): integer;
    procedure SetProtocol(Index: integer; Value: integer);
    function GetProtocol_(): string;
    procedure SetProtocol_(Value: string);
    function GetTransport(Index: integer): integer;
    procedure SetTransport(Index: integer; Value: integer);
    function GetTransport_(): string;
    procedure SetTransport_(Value: string);


    function getCom(i: integer): TCOMSet;
    function getTopic_conf(val: TCOMSet): string;
    function getTopic_conf_com(val: TCOMSet; modbus: boolean): string;
    function getTopic_conf_eth(val: TCOMSet; modbus: boolean): string;
    function getApplication_conf(): string;
    function GetComN(Index: integer): integer;
    procedure SetComN(Index: integer; Value: integer);
    function GetComN_(): string;
    procedure SetComN_(Value: string);
    function GetBaudRate(Index: integer): integer;
    procedure SetBaudRate(Index: integer; Value: integer);
    function GetBaudRate_(): string;
    procedure SetBaudRate_(Value: string);
    function GetDatabit(Index: integer): integer;
    procedure SetDatabit(Index: integer; Value: integer);
    function GetDatabit_(): string;
    procedure SetDatabit_(Value: string);
    function GetStopBit(Index: integer): integer;
    procedure SetStopBit(Index: integer; Value: integer);
    function GetStopBit_(): string;
    procedure SetStopBit_(Value: string);
    function GetParityBit(Index: integer): integer;
    procedure SetParityBit(Index: integer; Value: integer);
    function GetParityBit_(): string;
    procedure SetParityBit_(Value: string);

    function GetFlowControl(Index: integer): boolean;
    procedure SetFlowControl(Index: integer; Value: boolean);
    function GetFlowControl_(): string;
    procedure SetFlowControl_(Value: string);

    function GetFlowControlBeforeSleep(Index: integer): integer;
    procedure SetFlowControlBeforeSleep(Index: integer; Value: integer);
    function GetFlowControlBeforeSleep_(): string;
    procedure SetFlowControlBeforeSleep_(Value: string);
    function GetFlowControlAfterSleep(Index: integer): integer;
    procedure SetFlowControlAfterSleep(Index: integer; Value: integer);
    function GetFlowControlAfterSleep_(): string;
    procedure SetFlowControlAfterSleep_(Value: string);
    function GetReadInterval(Index: integer): integer;
    procedure SetReadInterval(Index: integer; Value: integer);
    function GetReadInterval_(): string;
    procedure SetReadInterval_(Value: string);
    function GetReadTotalMultiplier(Index: integer): integer;
    procedure SetReadTotalMultiplier(Index: integer; Value: integer);
    function GetReadTotalMultiplier_(): string;
    procedure SetReadTotalMultiplier_(Value: string);
    function GetReadTotalConstant(Index: integer): integer;
    procedure SetReadTotalConstant(Index: integer; Value: integer);
    function GetReadTotalConstant_(): string;
    procedure SetReadTotalConstant_(Value: string);
    function GetWriteTotalMultiplier(Index: integer): integer;
    procedure SetWriteTotalMultiplier(Index: integer; Value: integer);
    function GetWriteTotalMultiplier_(): string;
    procedure SetWriteTotalMultiplier_(Value: string);
    function GetWriteTotalConstant(Index: integer): integer;
    procedure SetWriteTotalConstant(Index: integer; Value: integer);
    function GetWriteTotalConstant_(): string;
    procedure SetWriteTotalConstant_(Value: string);
    function GetBlockSize(Index: integer): integer;
    procedure SetBlockSize(Index: integer; Value: integer);
    function GetBlockSize_(): string;
    procedure SetBlockSize_(Value: string);
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
    function GetReport(Index: integer): boolean;
    procedure SetReport(Index: integer; Value: boolean);
    function GetReport_(): string;
    procedure SetReport_(Value: string);
    function GetSyncTime(Index: integer): boolean;
    procedure SetSyncTime(Index: integer; Value: boolean);
    function GetSyncTime_(): string;
    procedure SetSyncTime_(Value: string);
    function GetPRTTM(Index: integer): integer;
    procedure SetPRTTM(Index: integer; Value: integer);
    function GetPRTTM_(): string;
    procedure SetPRTTM_(Value: string);
    function GetWait(Index: integer): integer;
    procedure SetWait(Index: integer; Value: integer);
    function GetWait_(): string;
    procedure SetWait_(Value: string);
    function GetTypeConnect(Index: integer): TKoyotypeconn;
    procedure SetTypeConnect(Index: integer; Value: TKoyotypeconn);
    function GetTypeConnect_(): string;
    procedure SetTypeConnect_(Value: string);
    function getTypeConn(i: integer): TKoyotypeconn;
  public
    procedure SetType; override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    property ComN[Index: integer]: integer read GetComN write SetComN;
    property ComN_: string read GetComN_ write SetComN_;
    property BaudRate[Index: integer]: integer read GetBaudRate write SetBaudRate;
    property BaudRate_: string read GetBaudRate_ write SetBaudRate_;
    property Databit[Index: integer]: integer read GetDatabit write SetDatabit;
    property Databit_: string read GetDatabit_ write SetDatabit_;
    property StopBit[Index: integer]: integer read GetStopBit write SetStopBit;
    property StopBit_: string read GetStopBit_ write SetStopBit_;
    property ParityBit[Index: integer]: integer read GetParityBit write SetParityBit;
    property ParityBit_: string read GetParityBit_ write SetParityBit_;

    property FlowControl[Index: integer]: boolean
      read GetFlowControl write SetFlowControl;
    property FlowControl_: string read GetFlowControl_ write SetFlowControl_;

    property FlowControlBeforeSleep[Index: integer]: integer
      read GetFlowControlBeforeSleep write SetFlowControlBeforeSleep;
    property FlowControlBeforeSleep_: string
      read GetFlowControlBeforeSleep_ write SetFlowControlBeforeSleep_;
    property FlowControlAfterSleep[Index: integer]: integer
      read GetFlowControlAfterSleep write SetFlowControlAfterSleep;
    property FlowControlAfterSleep_: string
      read GetFlowControlAfterSleep_ write SetFlowControlAfterSleep_;
    property ReadInterval[Index: integer]: integer
      read GetReadInterval write SetReadInterval;
    property ReadInterval_: string read GetReadInterval_ write SetReadInterval_;
    property ReadTotalMultiplier[Index: integer]: integer
      read GetReadTotalMultiplier write SetReadTotalMultiplier;
    property ReadTotalMultiplier_: string read GetReadTotalMultiplier_
      write SetReadTotalMultiplier_;
    property ReadTotalConstant[Index: integer]: integer
      read GetReadTotalConstant write SetReadTotalConstant;
    property ReadTotalConstant_: string read GetReadTotalConstant_
      write SetReadTotalConstant_;
    property WriteTotalMultiplier[Index: integer]: integer
      read GetWriteTotalMultiplier write SetWriteTotalMultiplier;
    property WriteTotalMultiplier_: string
      read GetWriteTotalMultiplier_ write SetWriteTotalMultiplier_;
    property WriteTotalConstant[Index: integer]: integer
      read GetWriteTotalConstant write SetWriteTotalConstant;
    property WriteTotalConstant_: string read GetWriteTotalConstant_
      write SetWriteTotalConstant_;
    property BlockSize[Index: integer]: integer read GetBlockSize write SetBlockSize;
    property BlockSize_: string read GetBlockSize_ write SetBlockSize_;
    property ReadTimeout[Index: integer]: integer
      read GetReadTimeout write SetReadTimeout;
    //  таймаут на разрыв связи
    property ReadTimeout_: string read GetReadTimeout_ write SetReadTimeout_;
    property DirectTimeout[Index: integer]: integer
      read GetDirectTimeout write SetDirectTimeout;
    property DirectTimeout_: string read GetDirectTimeout_ write SetDirectTimeout_;
    property TryCount[Index: integer]: integer read GetTryCount write SetTryCount;
    property TryCount_: string read GetTryCount_ write SetTryCount_;
    property Report[Index: integer]: boolean read GetReport write SetReport;
    property Report_: string read GetReport_ write SetReport_;
    property SyncTime[Index: integer]: boolean read GetSyncTime write SetSyncTime;
    property SyncTime_: string read GetSyncTime_ write SetSyncTime_;
    property PRTTM[Index: integer]: integer read GetPRTTM write SetPRTTM;
    property PRTTM_: string read GetPRTTM_ write SetPRTTM_;
    property Wait[Index: integer]: integer read GetWait write SetWait;
    property Wait_: string read GetWait_ write SetWait_;
    property TypeConnect[Index: integer]: TKoyotypeconn
      read GetTypeConnect write SetTypeConnect;
    property TypeConnect_: string read GetTypeConnect_ write SetTypeConnect_;

    property Protocol[Index: integer]: integer read GetProtocol write SetProtocol;
    property Protocol_: string read GetProtocol_ write SetProtocol_;
    property Transport[Index: integer]: integer read GetTransport write SetTransport;
    property Transport_: string read GetTransport_ write SetTransport_;
    property IP[Index: integer]: integer read GetIP write SetIP;
    property IP_: string read GetIP_ write SetIP_;
    property Eth[Index: integer]: int64 read GetEth write SetEth;
    property Eth_: string read GetEth_ write SetEth_;
    property Host[Index: integer]: string read GetHost write SetHost;
    property Host_: string read GetHost_ write SetHost_;
  end;

implementation




function brtostr(val: integer): string;
begin
  case val of
    110: Result := '110';
    300: Result := '300';
    600: Result := '600';
    1200: Result := '1200';
    2400: Result := '2400';
    4800: Result := '4800';
    14400: Result := '14400';
    19200: Result := '19200';
    38400: Result := '38400';
    56000: Result := '56000';
    115200: Result := '115200';
    else
      Result := '9600'
  end;
end;

function strtobr(val: string): integer;
begin
  val := trim(val);
  Result := 0;
  if '110' = val then
    Result := 110;
  if '300' = val then
    Result := 300;
  if '600' = val then
    Result := 600;
  if '1200' = val then
    Result := 1200;
  if '2400' = val then
    Result := 2400;
  if '4800' = val then
    Result := 4800;
  if '14400' = val then
    Result := 14400;
  if '19200' = val then
    Result := 19200;
  if '38400' = val then
    Result := 38400;
  if '56000' = val then
    Result := 56000;
  if '115200' = val then
    Result := 115200;
  if Result = 0 then
    Result := 9600;

end;


function brSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('110');
  Result.Add('300');
  Result.Add('600');
  Result.Add('1200');
  Result.Add('2400');
  Result.Add('4800');
  Result.Add('9600');
  Result.Add('14400');
  Result.Add('19200');
  Result.Add('38400');
  Result.Add('56000');
  Result.Add('115200');
end;


function TCtostr(val: TKoyotypeconn): string;
begin
  case val of
    ktcCom: Result := 'K-SEQUENCE';
    ktcEth: Result := 'ECOM';
    ktcRmod: Result := 'RS-MODBUS';
    ktcTmod: Result := 'TCP-MODBUS';
  end;
end;

function strtoTC(val: string): TKoyotypeconn;
begin
  val := trim(val);
  if 'K-SEQUENCE' = val then
    Result := ktcCom;
  if 'ECOM' = val then
    Result := ktcEth;
  if 'RS-MODBUS' = val then
    Result := ktcRmod;
  if 'TCP-MODBUS' = val then
    Result := ktcTmod;
end;


function dbTC(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('K-SEQUENCE');
  Result.Add('ECOM');
  Result.Add('RS-MODBUS');
  Result.Add('TCP-MODBUS');
end;


function dbtostr(val: integer): string;
begin
  case val of
    5: Result := '5';
    6: Result := '6';
    7: Result := '7';

    else
      Result := '8'
  end;
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




function TKoyoServGroups.getCom(i: integer): TCOMSet;
begin
  case getTypeConn(i) of
    ktcCom: isCom(Topic[i], 'COM', com);
    ktcEth: isCom(Topic[i], 'ETH', com);
    ktcRmod: isCom(Topic[i], 'RMOD', com);
    ktcTmod: isCom(Topic[i], 'TMOD', com);
  end;

  Result := com;
end;

function TKoyoServGroups.getTypeConn(i: integer): TKoyotypeconn;
var
  temp: integer;
  com_: TComset;
begin
  temp := isCom(Topic[i], 'COM', com_);
  if ((temp > 0) and (com_.Com > -1)) then
    Result := ktcCom
  else
  begin
    temp := isCom(Topic[i], 'ETH', com_);
    if ((temp > 0) and (com_.Com > -1)) then
      Result := ktcEth
    else
    begin
      temp := isCom(Topic[i], 'RMOD', com_);
      if ((temp > 0) and (com_.Com > -1)) then
        Result := ktcRmod
      else
        Result := ktcTmod;
    end;
  end;
end;



procedure TKoyoServGroups.setMap();
begin

  case getTypeConn(0) of
    ktcCom, ktcRmod:
    begin
      editor.Strings.Clear;
      if (getCount = 1) then
        setPropertys('Имя', GetName_);
      setPropertys('Тип соединения', self.TypeConnect_, dbTC);
      setPropertys('Номер устройства', Slave_);
      setPropertys('Номер com порта', self.ComN_);
      setPropertys('Baundrate', self.BaudRate_, brSL);
      setPropertys('Databit', self.Databit_, dbSL);
      setPropertys('Stopbit', self.StopBit_, sbSL);
      setPropertys('Parity', self.ParityBit_, ptSL);
      setPropertys('FlowControl', self.FlowControl_, getBooleanList());
      setPropertys('FlowControlBeforeSleep', self.FlowControlBeforeSleep_);
      setPropertys('FlowControlAfterSleep', self.FlowControlAfterSleep_);
      setPropertys('ReadInterval', self.ReadInterval_);
      setPropertys('ReadTotalMultiplier', self.ReadTotalMultiplier_);
      setPropertys('ReadTotalConstant', self.ReadTotalConstant_);
      setPropertys('WriteTotalMultiplier', self.WriteTotalMultiplier_);
      setPropertys('WriteTotalConstant', self.WriteTotalConstant_);
      setPropertys('Размер блока данных', self.BlockSize_);
      setPropertys('Таймаут индикации разрыва соединения', self.ReadTimeout_);
      //  setPropertys('DirectTimeout',self.DirectTimeout_);
      setPropertys('Попыток чтения', self.TryCount_);
      setPropertys('Менеджер отчетов', Report_, getBooleanList);
      setPropertys('Синхронизация времени конроллера', SyncTime_, getBooleanList);
      // setPropertys('PRTTM',PRTTM_);
      setPropertys('Системный таймаут ожидания ответа', Wait_);

      setPropertys('Приложение',
        'NS_DirectNetIOService.exe/NS_DirectNetIOService_app.exe', True);
      setNew();
    end;

    ktcEth:
    begin
      editor.Strings.Clear;
      if (getCount = 1) then
        setPropertys('Имя', GetName_);
      setPropertys('Тип соединения', self.TypeConnect_, dbTC);
      setPropertys('Номер устройства', Slave_);
      setPropertys('Transport', self.Transport_, brtransport);
      setPropertys('Protocol', self.Protocol_, brprotocol);
      setPropertys('IP (опционально)', self.IP_);
      setPropertys('EthAdress (опционально)', self.Eth_);
      setPropertys('HostName (опционально)', self.Host_);
      setPropertys('Размер блока данных', self.BlockSize_);
      setPropertys('Таймаут индикации разрыва соединения', self.ReadTimeout_);
      // setPropertys('DirectTimeout',self.DirectTimeout_);
      setPropertys('Попыток чтения', self.TryCount_);
      setPropertys('Менеджер отчетов', Report_, getBooleanList);
      setPropertys('Синхронизация времени конроллера', SyncTime_, getBooleanList);
      setPropertys('Системный таймаут ожидания ответа', Wait_);

      setPropertys('Приложение',
        'NS_DirectNetIOService.exe/NS_DirectNetIOService_app.exe', True);
      setNew();
    end;

    ktcTmod:
    begin
      editor.Strings.Clear;
      if (getCount = 1) then
        setPropertys('Имя', GetName_);
      setPropertys('Тип соединения', self.TypeConnect_, dbTC);
      setPropertys('Номер устройства', Slave_);
      setPropertys('IP ', self.IP_);
      setPropertys('Размер блока данных', self.BlockSize_);
      setPropertys('Таймаут индикации разрыва соединения', self.ReadTimeout_);
      // setPropertys('DirectTimeout',self.DirectTimeout_);
      setPropertys('Попыток чтения', self.TryCount_);
      setPropertys('Менеджер отчетов', Report_, getBooleanList);
      setPropertys('Синхронизация времени конроллера', SyncTime_, getBooleanList);
      setPropertys('Системный таймаут ожидания ответа', Wait_);

      setPropertys('Приложение',
        'NS_DirectNetIOService.exe/NS_DirectNetIOService_app.exe', True);
      setNew();
    end;
  end;

end;

function TKoyoServGroups.setchange(key: integer; val: string): string;
begin
  Result := '';
  if (getCount > 1) then
    key := key + 1;

  case getTypeConn(0) of
    ktcCom, ktcRmod:
    begin
      case key of
        0:
        begin
          Name_ := val;
          Result := val;
        end;
        1: TypeConnect_ := val;
        2: Slave_ := val;
        3: ComN_ := val;
        4: BaudRate_ := val;
        5: Databit_ := val;
        6: StopBit_ := val;
        7: ParityBit_ := val;
        8: FlowControl_ := val;
        9: FlowControlBeforeSleep_ := val;
        10: FlowControlAfterSleep_ := val;
        11: ReadInterval_ := val;
        12: ReadTotalMultiplier_ := val;
        13: ReadTotalConstant_ := val;
        14: WriteTotalMultiplier_ := val;
        15: WriteTotalConstant_ := val;
        16: BlockSize_ := val;
        17: ReadTimeout_ := val;
        //  18: DirectTimeout_:=val;
        18: TryCount_ := val;
        19: Report_ := val;
        20: SyncTime_ := val;
        //22: PRTTM_:=val;
        21: Wait_ := val;

      end;
    end;

    ktcEth:
    begin
      case key of
        0:
        begin
          Name_ := val;
          Result := val;
        end;
        1: TypeConnect_ := val;
        2: Slave_ := val;
        3: Transport_ := val;
        4: Protocol_ := val;
        5: IP_ := val;
        6: Eth_ := val;
        7: Host_ := val;
        8: BlockSize_ := val;
        9: ReadTimeout_ := val;
        // 10: DirectTimeout_:=val;
        10: TryCount_ := val;
        11: Report_ := val;
        12: SyncTime_ := val;
        13: Wait_ := val;

      end;
    end;

    ktcTmod:
    begin
      case key of
        0:
        begin
          Name_ := val;
          Result := val;
        end;
        1: TypeConnect_ := val;
        2: Slave_ := val;
        3: IP_ := val;
        4: BlockSize_ := val;
        5: ReadTimeout_ := val;
        // 10: DirectTimeout_:=val;
        6: TryCount_ := val;
        7: Report_ := val;
        8: SyncTime_ := val;
        9: Wait_ := val;

      end;
    end
  end;

end;


procedure TKoyoServGroups.SetType;
begin
  case getTypeConn(0) of
    ktcCom: SetTypeCom;
    ktcEth: SetTypeEth;
    ktcRmod: SetTypeRmod;
    ktcTmod: SetTypeTmod;
  end;
end;

procedure TKoyoServGroups.SetTypeCom;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'com[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;

procedure TKoyoServGroups.SetTypeEth;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'eth[frt5,rtm3,rtc4,trd0,red0,wtm0]';
end;

procedure TKoyoServGroups.SetTypeRmod;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'rmod[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;

procedure TKoyoServGroups.SetTypeTmod;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'tmod[frt5,rtm3,rtc4,trd0,red0,wtm0]';
end;

function TKoyoServGroups.GetComN(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.Com;
end;

procedure TKoyoServGroups.SetComN(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.Com := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetComN_(): string;
var
  i: integer;
begin
  Result := IntToStr(ComN[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(ComN[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetComN_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ComN[i] := StrToInt(Value);
end;


function TKoyoServGroups.GetBaudRate(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.br;
end;

procedure TKoyoServGroups.SetBaudRate(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.br := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetBaudRate_(): string;
var
  i: integer;
begin
  Result := brtostr(BaudRate[0]);
  for i := 1 to idscount - 1 do
    if (brtostr(BaudRate[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetBaudRate_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    BaudRate[i] := strtobr(Value);
end;

function TKoyoServGroups.GetDatabit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.db;
end;

procedure TKoyoServGroups.SetDatabit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.db := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetDatabit_(): string;
var
  i: integer;
begin
  Result := dbtostr(Databit[0]);
  for i := 1 to idscount - 1 do
    if (dbtostr(Databit[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetDatabit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Databit[i] := strtodb(Value);
end;


function TKoyoServGroups.GetStopBit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.sb;
end;

procedure TKoyoServGroups.SetStopBit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.sb := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetStopBit_(): string;
var
  i: integer;
begin
  Result := sbtostr(StopBit[0]);
  for i := 1 to idscount - 1 do
    if (sbtostr(StopBit[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetStopBit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    StopBit[i] := strtosb(Value);
end;

function TKoyoServGroups.GetParityBit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.pt;
end;

procedure TKoyoServGroups.SetParityBit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.pt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetParityBit_(): string;
var
  i: integer;
begin
  Result := pttostr(ParityBit[0]);
  for i := 1 to idscount - 1 do
    if (pttostr(ParityBit[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetParityBit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ParityBit[i] := strtopt(Value);
end;

function TKoyoServGroups.GetFlowControl(Index: integer): boolean;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.flCtrl;
end;

procedure TKoyoServGroups.SetFlowControl(Index: integer; Value: boolean);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  if (Value) then
  begin
    if com_.trd = 0 then
      com_.trd := 60;
    if com_.red = 0 then
      com_.red := 50;
    com_.flCtrl := True;
  end
  else
  begin
    com_.trd := 0;
    com_.red := 0;
    com_.flCtrl := False;
  end;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetFlowControl_(): string;
var
  i: integer;
begin
  Result := getbooleanstr(FlowControl[0]);
  for i := 1 to idscount - 1 do
    if (getbooleanstr(FlowControl[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetFlowControl_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControl[i] := getstrboolean(Value);
end;


function TKoyoServGroups.GetFlowControlBeforeSleep(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trd;
end;

procedure TKoyoServGroups.SetFlowControlBeforeSleep(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trd := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetFlowControlBeforeSleep_(): string;
var
  i: integer;
begin
  Result := IntToStr(FlowControlBeforeSleep[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(FlowControlBeforeSleep[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetFlowControlBeforeSleep_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControlBeforeSleep[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetFlowControlAfterSleep(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.red;
end;

procedure TKoyoServGroups.SetFlowControlAfterSleep(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.red := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetFlowControlAfterSleep_(): string;
var
  i: integer;
begin
  Result := IntToStr(FlowControlAfterSleep[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(FlowControlAfterSleep[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetFlowControlAfterSleep_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControlAfterSleep[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetReadInterval(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.ri;
end;

procedure TKoyoServGroups.SetReadInterval(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.ri := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetReadInterval_(): string;
var
  i: integer;
begin
  Result := IntToStr(ReadInterval[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(ReadInterval[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetReadInterval_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadInterval[i] := StrToInt(Value);
end;


function TKoyoServGroups.GetReadTotalMultiplier(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtm;
end;

procedure TKoyoServGroups.SetReadTotalMultiplier(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetReadTotalMultiplier_(): string;
var
  i: integer;
begin
  Result := IntToStr(ReadTotalMultiplier[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(ReadTotalMultiplier[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetReadTotalMultiplier_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTotalMultiplier[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetReadTotalConstant(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtc;
end;

procedure TKoyoServGroups.SetReadTotalConstant(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetReadTotalConstant_(): string;
var
  i: integer;
begin
  Result := IntToStr(ReadTotalConstant[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(ReadTotalConstant[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetReadTotalConstant_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTotalConstant[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetWriteTotalMultiplier(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtm;
end;

procedure TKoyoServGroups.SetWriteTotalMultiplier(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetWriteTotalMultiplier_(): string;
var
  i: integer;
begin
  Result := IntToStr(WriteTotalMultiplier[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(WriteTotalMultiplier[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetWriteTotalMultiplier_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    WriteTotalMultiplier[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetWriteTotalConstant(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtc;
end;

procedure TKoyoServGroups.SetWriteTotalConstant(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetWriteTotalConstant_(): string;
var
  i: integer;
begin
  Result := IntToStr(WriteTotalConstant[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(WriteTotalConstant[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetWriteTotalConstant_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    WriteTotalConstant[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetBlockSize(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.bs;
end;

procedure TKoyoServGroups.SetBlockSize(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.bs := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetBlockSize_(): string;
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

procedure TKoyoServGroups.SetBlockSize_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    BlockSize[i] := StrToInt(Value);
end;


function TKoyoServGroups.GetReadTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frt;
end;

procedure TKoyoServGroups.SetReadTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetReadTimeout_(): string;
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

procedure TKoyoServGroups.SetReadTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTimeout[i] := StrToInt(Value);
end;


function TKoyoServGroups.GetDirectTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frd;
end;

procedure TKoyoServGroups.SetDirectTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frd := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetDirectTimeout_(): string;
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

procedure TKoyoServGroups.SetDirectTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    DirectTimeout[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetTryCount(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trc;
end;

procedure TKoyoServGroups.SetTryCount(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetTryCount_(): string;
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

procedure TKoyoServGroups.SetTryCount_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    TryCount[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetReport(Index: integer): boolean;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := (com.tstrt = 1);
end;

procedure TKoyoServGroups.SetReport(Index: integer; Value: boolean);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  if Value then
    com_.tstrt := 1
  else
    com_.tstrt := 0;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetReport_(): string;
var
  i: integer;
begin
  Result := getbooleanstr(Report[0]);
  for i := 1 to idscount - 1 do
    if (getbooleanstr(Report[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetReport_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Report[i] := getstrboolean(Value);
end;

function TKoyoServGroups.GetSyncTime(Index: integer): boolean;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := (com.tstp = 60);
end;

procedure TKoyoServGroups.SetSyncTime(Index: integer; Value: boolean);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  if Value then
    com_.tstp := 60
  else
    com_.tstp := 61;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetSyncTime_(): string;
var
  i: integer;
begin
  Result := getbooleanstr(SyncTime[0]);
  for i := 1 to idscount - 1 do
    if (getbooleanstr(SyncTime[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetSyncTime_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    SyncTime[i] := getstrboolean(Value);
end;

function TKoyoServGroups.GetPRTTM(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.prttm;
end;

procedure TKoyoServGroups.SetPRTTM(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.prttm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetPRTTM_(): string;
var
  i: integer;
begin
  Result := IntToStr(PRTTM[0]);
  for i := 1 to idscount - 1 do
    if (IntToStr(PRTTM[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetPRTTM_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    PRTTM[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetWait(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wait;
end;

procedure TKoyoServGroups.SetWait(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wait := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetWait_(): string;
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

procedure TKoyoServGroups.SetWait_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Wait[i] := StrToInt(Value);
end;

function TKoyoServGroups.GetTypeConnect(Index: integer): TKoyotypeconn;
var
  int_temp: integer;
begin
  Result := GetTypeConn(Index);
end;

procedure TKoyoServGroups.SetTypeConnect(Index: integer; Value: TKoyotypeconn);
var
  com_: TCOMSet;
begin
  if (GetTypeConnect(Index) <> Value) then
  begin
    case Value of
      ktcCom: SetTypeCom;
      ktcEth: SetTypeEth;
      ktcRmod: SetTypeRmod;
      ktcTmod: SetTypeTmod;
    end;
  end;
end;


function TKoyoServGroups.GetTypeConnect_(): string;
var
  i: integer;
begin
  Result := TCtostr(TypeConnect[0]);
  for i := 1 to idscount - 1 do
    if (TCtostr(TypeConnect[i]) <> Result) then
    begin
      Result := '';
    end;
end;

procedure TKoyoServGroups.SetTypeConnect_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    TypeConnect[i] := strtoTC(Value);
end;

function TKoyoServGroups.getTopic_conf_com(val: TCOMSet; modbus: boolean): string;
begin

  if val.Com > 255 then
    val.Com := 255;
  if val.Com < 1 then
    val.Com := 1;
  if not ((val.br = 110) or (val.br = 300) or (val.br = 600) or
    (val.br = 1200) or (val.br = 2400) or (val.br = 4800) or
    (val.br = 9600) or (val.br = 14400) or (val.br = 19200) or
    (val.br = 38400) or (val.br = 56000) or (val.br = 115200)) then
    val.br := 9600;
  if not ((val.db = 5) or (val.db = 6) or (val.DB = 7) or (val.DB = 8)) then
    val.DB := 8;
  if not ((val.sb = 3) or (val.sb = 2) or (val.sb = 1)) then
    val.sb := 1;
  if not ((val.pt = 1) or (val.pt = 2) or (val.pt = 3) or (val.pt = 4)) then
    val.pt := 0;

  if val.Com < 1 then
    val.Com := 1;
  if (modbus) then
    Result := 'rmod['
  else
    Result := 'com[';
  if val.Com < 1 then
    val.Com := 1;
  if (val.Com > 0) then
    Result := Result + 'com' + IntToStr(val.Com);
  if (val.br <> 9600) then
    Result := Result + ',br' + IntToStr(val.br);
  if (val.db <> 7) then
    Result := Result + ',bd' + IntToStr(val.db);
  if (val.sb <> 1) then
    Result := Result + ',sb' + IntToStr(val.sb);
  if (val.pt <> 0) then
    Result := Result + ',pt' + IntToStr(val.pt);
  if (val.trd <> 60) then
    Result := Result + ',trd' + IntToStr(val.trd);
  if (val.red <> 50) then
    Result := Result + ',red' + IntToStr(val.red);
  if (val.ri <> 100) then
    Result := Result + ',ri' + IntToStr(val.ri);
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
  if (val.prttm <> 500) then
    Result := Result + ',prttm' + IntToStr(val.prttm);
  if (val.wait <> 3000) then
    Result := Result + ',wait' + IntToStr(val.wait);
  Result := Result + ']';
end;

function TKoyoServGroups.getTopic_conf_eth(val: TCOMSet; modbus: boolean): string;
begin
  if not ((val.rtm = 3) or (val.rtm = 2) or (val.rtm = 1)) then
    val.sb := 3;
  if not ((val.rtc = 1) or (val.rtc = 2) or (val.rtc = 4)) then
    val.rtc := 4;
  if val.Com < 1 then
    val.Com := 1;
  if (modbus) then
    Result := 'tmod['
  else
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

function TKoyoServGroups.getTopic_conf(val: TCOMSet): string;
begin
  case getTypeConn(0) of
    ktcCom: Result := getTopic_conf_com(val, false);
    ktcEth: Result := getTopic_conf_eth(val, false);
    ktcRmod: Result := getTopic_conf_com(val, true);
    ktcTmod: Result := getTopic_conf_eth(val, true);
  end;
end;

function TKoyoServGroups.getApplication_conf(): string;
begin
  Result := 'DirectKoyoServ';
  ;
end;


function TKoyoServGroups.GetProtocol(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtm;
end;

procedure TKoyoServGroups.SetProtocol(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetProtocol_(): string;
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

procedure TKoyoServGroups.SetProtocol_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Protocol[i] := strtoprotocol(Value);
end;

function TKoyoServGroups.GetTransport(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtc;
end;

procedure TKoyoServGroups.SetTransport(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetTransport_(): string;
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

procedure TKoyoServGroups.SetTransport_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Transport[i] := strtotransport(Value);
end;

function TKoyoServGroups.GetIP(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtm;
end;

procedure TKoyoServGroups.SetIP(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetIP_(): string;
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

procedure TKoyoServGroups.SetIP_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    IP[i] := strtoip(Value);
end;

function TKoyoServGroups.GetEth(Index: integer): int64;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trd;
  Result := ((Result shl 24) and $FFFFFF000000) + (com.red and $FFFFFF);
end;

procedure TKoyoServGroups.SetEth(Index: integer; Value: int64);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trd := (Value and $FFFFFF000000) shr 24;
  com_.red := (Value and $FFFFFF);
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetEth_(): string;
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

procedure TKoyoServGroups.SetEth_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Eth[i] := strtoeth(Value);
end;

function TKoyoServGroups.GetHost(Index: integer): string;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.Name;

end;

procedure TKoyoServGroups.SetHost(Index: integer; Value: string);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.Name := Value;

  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroups.GetHost_(): string;
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

procedure TKoyoServGroups.SetHost_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Host[i] := Value;
end;

end.
 
