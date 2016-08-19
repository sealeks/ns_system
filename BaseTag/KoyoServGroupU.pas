unit KoyoServGroupU;

interface

uses
  Classes, SimpleGroupAdapterU, SysUtils, StrUtils, ItemAdapterU, ServerU, InterfaceServerU;

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
// frt - ReadTimeOUT
// frd - DirectTimeOUT
// trc - TryCount попытки чтения
//  tstrt - время начала часового цикла опроса
//  tstp  - время конца часового цикла опроса
//  prttm - задержка перед puge порта
//  wait  - wait в  WaitForSingleObject


type
  TKoyoServGroup = class(TGroupWraper)
  private
    com: TCOMSet;
    function getCom(i: integer): TCOMSet;
    function getTopic_conf(val: TCOMSet): string;
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
    function GetStart(Index: integer): integer;
    procedure SetStart(Index: integer; Value: integer);
    function GetStart_(): string;
    procedure SetStart_(Value: string);
    function GetStop(Index: integer): integer;
    procedure SetStop(Index: integer; Value: integer);
    function GetStop_(): string;
    procedure SetStop_(Value: string);
    function GetPRTTM(Index: integer): integer;
    procedure SetPRTTM(Index: integer; Value: integer);
    function GetPRTTM_(): string;
    procedure SetPRTTM_(Value: string);
    function GetWait(Index: integer): integer;
    procedure SetWait(Index: integer; Value: integer);
    function GetWait_(): string;
    procedure SetWait_(Value: string);
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
    property WriteTotalMultiplier_: string read GetWriteTotalMultiplier_
      write SetWriteTotalMultiplier_;
    property WriteTotalConstant[Index: integer]: integer
      read GetWriteTotalConstant write SetWriteTotalConstant;
    property WriteTotalConstant_: string read GetWriteTotalConstant_
      write SetWriteTotalConstant_;
    property BlockSize[Index: integer]: integer read GetBlockSize write SetBlockSize;
    property BlockSize_: string read GetBlockSize_ write SetBlockSize_;
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
    property PRTTM[Index: integer]: integer read GetPRTTM write SetPRTTM;
    property PRTTM_: string read GetPRTTM_ write SetPRTTM_;
    property Wait[Index: integer]: integer read GetWait write SetWait;
    property Wait_: string read GetWait_ write SetWait_;
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




function TKoyoServGroup.getCom(i: integer): TCOMSet;
begin
  isCom(Topic[i], 'COM', com);
  Result := com;
end;



procedure TKoyoServGroup.setMap();
begin

  editor.Strings.Clear;

  if (getCount = 1) then
    setPropertys('Имя', GetName_);
  setPropertys('Номер устройства', Slave_);
  setPropertys('Номер com порта', self.ComN_);
  setPropertys('Скорость порта', self.BaudRate_, brSL);
  setPropertys('Бит данных', self.Databit_, dbSL);
  setPropertys('Стоповый бит', self.StopBit_, sbSL);
  setPropertys('Паритетный бит', self.ParityBit_, ptSL);
  setPropertys('FlowControl', self.FlowControl_, getBooleanList());
  setPropertys('FlowControlBeforeSleep', self.FlowControlBeforeSleep_);
  setPropertys('FlowControlAfterSleep', self.FlowControlAfterSleep_);
  setPropertys('ReadInterval', self.ReadInterval_);
  setPropertys('ReadTotalMultiplier', self.ReadTotalMultiplier_);
  setPropertys('ReadTotalConstant', self.ReadTotalConstant_);
  setPropertys('WriteTotalMultiplier', self.WriteTotalMultiplier_);
  setPropertys('WriteTotalConstant', self.WriteTotalConstant_);
  setPropertys('Размер блока данных', self.BlockSize_);
  setPropertys('ReadTimeout', self.ReadTimeout_);
  setPropertys('DirectTimeout', self.DirectTimeout_);
  setPropertys('Попыток чтения', self.TryCount_);
  setPropertys('Начальная минута часового цикла опроса', Start_);
  setPropertys('Конечная минута часового цикла опроса', Stop_);
  setPropertys('PRTTM', PRTTM_);
  setPropertys('Системный таймаут ожидания ответа', Wait_);
  setPropertys('Приложение', 'ServerKoyo_Service.exe/IServerKoyo_Prj.exe', True);
  setNew();

end;

function TKoyoServGroup.setchange(key: integer; val: string): string;
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
    2: ComN_ := val;
    3: BaudRate_ := val;
    4: Databit_ := val;
    5: StopBit_ := val;
    6: ParityBit_ := val;
    7: FlowControl_ := val;
    8: FlowControlBeforeSleep_ := val;
    9: FlowControlAfterSleep_ := val;
    10: ReadInterval_ := val;
    11: ReadTotalMultiplier_ := val;
    12: ReadTotalConstant_ := val;
    13: WriteTotalMultiplier_ := val;
    14: WriteTotalConstant_ := val;
    15: BlockSize_ := val;
    16: ReadTimeout_ := val;
    17: DirectTimeout_ := val;
    18: TryCount_ := val;
    19: Start_ := val;
    20: Stop_ := val;
    21: PRTTM_ := val;
    22: Wait_ := val;

  end;

end;


procedure TKoyoServGroup.SetType;
var
  i: integer;
begin
  Application_ := 'DirectKoyoServ';
  Topic_ := 'com[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;




function TKoyoServGroup.GetComN(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.Com;
end;

procedure TKoyoServGroup.SetComN(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.Com := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetComN_(): string;
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

procedure TKoyoServGroup.SetComN_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ComN[i] := StrToInt(Value);
end;


function TKoyoServGroup.GetBaudRate(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.br;
end;

procedure TKoyoServGroup.SetBaudRate(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.br := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetBaudRate_(): string;
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

procedure TKoyoServGroup.SetBaudRate_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    BaudRate[i] := strtobr(Value);
end;

function TKoyoServGroup.GetDatabit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.db;
end;

procedure TKoyoServGroup.SetDatabit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.db := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetDatabit_(): string;
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

procedure TKoyoServGroup.SetDatabit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Databit[i] := strtodb(Value);
end;


function TKoyoServGroup.GetStopBit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.sb;
end;

procedure TKoyoServGroup.SetStopBit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.sb := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetStopBit_(): string;
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

procedure TKoyoServGroup.SetStopBit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    StopBit[i] := strtosb(Value);
end;

function TKoyoServGroup.GetParityBit(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.pt;
end;

procedure TKoyoServGroup.SetParityBit(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.pt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetParityBit_(): string;
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

procedure TKoyoServGroup.SetParityBit_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ParityBit[i] := strtopt(Value);
end;

function TKoyoServGroup.GetFlowControl(Index: integer): boolean;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.flCtrl;
end;

procedure TKoyoServGroup.SetFlowControl(Index: integer; Value: boolean);
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


function TKoyoServGroup.GetFlowControl_(): string;
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

procedure TKoyoServGroup.SetFlowControl_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControl[i] := getstrboolean(Value);
end;


function TKoyoServGroup.GetFlowControlBeforeSleep(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trd;
end;

procedure TKoyoServGroup.SetFlowControlBeforeSleep(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trd := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetFlowControlBeforeSleep_(): string;
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

procedure TKoyoServGroup.SetFlowControlBeforeSleep_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControlBeforeSleep[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetFlowControlAfterSleep(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.red;
end;

procedure TKoyoServGroup.SetFlowControlAfterSleep(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.red := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetFlowControlAfterSleep_(): string;
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

procedure TKoyoServGroup.SetFlowControlAfterSleep_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    FlowControlAfterSleep[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetReadInterval(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.ri;
end;

procedure TKoyoServGroup.SetReadInterval(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.ri := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetReadInterval_(): string;
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

procedure TKoyoServGroup.SetReadInterval_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadInterval[i] := StrToInt(Value);
end;


function TKoyoServGroup.GetReadTotalMultiplier(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtm;
end;

procedure TKoyoServGroup.SetReadTotalMultiplier(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetReadTotalMultiplier_(): string;
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

procedure TKoyoServGroup.SetReadTotalMultiplier_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTotalMultiplier[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetReadTotalConstant(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.rtc;
end;

procedure TKoyoServGroup.SetReadTotalConstant(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.rtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetReadTotalConstant_(): string;
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

procedure TKoyoServGroup.SetReadTotalConstant_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTotalConstant[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetWriteTotalMultiplier(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtm;
end;

procedure TKoyoServGroup.SetWriteTotalMultiplier(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetWriteTotalMultiplier_(): string;
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

procedure TKoyoServGroup.SetWriteTotalMultiplier_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    WriteTotalMultiplier[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetWriteTotalConstant(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wtc;
end;

procedure TKoyoServGroup.SetWriteTotalConstant(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wtc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetWriteTotalConstant_(): string;
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

procedure TKoyoServGroup.SetWriteTotalConstant_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    WriteTotalConstant[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetBlockSize(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.bs;
end;

procedure TKoyoServGroup.SetBlockSize(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.bs := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetBlockSize_(): string;
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

procedure TKoyoServGroup.SetBlockSize_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    BlockSize[i] := StrToInt(Value);
end;


function TKoyoServGroup.GetReadTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frt;
end;

procedure TKoyoServGroup.SetReadTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetReadTimeout_(): string;
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

procedure TKoyoServGroup.SetReadTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    ReadTimeout[i] := StrToInt(Value);
end;


function TKoyoServGroup.GetDirectTimeout(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.frd;
end;

procedure TKoyoServGroup.SetDirectTimeout(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.frd := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetDirectTimeout_(): string;
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

procedure TKoyoServGroup.SetDirectTimeout_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    DirectTimeout[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetTryCount(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.trc;
end;

procedure TKoyoServGroup.SetTryCount(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.trc := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetTryCount_(): string;
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

procedure TKoyoServGroup.SetTryCount_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    TryCount[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetStart(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.tstrt;
end;

procedure TKoyoServGroup.SetStart(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.tstrt := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetStart_(): string;
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

procedure TKoyoServGroup.SetStart_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Start[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetStop(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.tstp;
end;

procedure TKoyoServGroup.SetStop(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.tstp := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetStop_(): string;
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

procedure TKoyoServGroup.SetStop_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Stop[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetPRTTM(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.prttm;
end;

procedure TKoyoServGroup.SetPRTTM(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.prttm := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetPRTTM_(): string;
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

procedure TKoyoServGroup.SetPRTTM_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    PRTTM[i] := StrToInt(Value);
end;

function TKoyoServGroup.GetWait(Index: integer): integer;
var
  int_temp: integer;
begin
  getCom(Index);
  Result := com.wait;
end;

procedure TKoyoServGroup.SetWait(Index: integer; Value: integer);
var
  com_: TCOMSet;
begin
  com_ := getCom(Index);
  com_.wait := Value;
  Topic[Index] := getTopic_conf(com_);
end;


function TKoyoServGroup.GetWait_(): string;
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

procedure TKoyoServGroup.SetWait_(Value: string);
var
  i: integer;
begin
  for i := 0 to idscount - 1 do
    Wait[i] := StrToInt(Value);
end;

function TKoyoServGroup.getTopic_conf(val: TCOMSet): string;
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
  if val.Com > 255 then
    val.Com := 255;
  if val.Com < 1 then
    val.Com := 1;
  if not ((val.br = 110) or (val.br = 300) or (val.br = 600) or (val.br = 1200) or
    (val.br = 2400) or (val.br = 4800) or (val.br = 9600) or (val.br = 14400) or
    (val.br = 19200) or (val.br = 38400) or (val.br = 56000) or (val.br = 115200)) then
    val.br := 9600;
  if not ((val.db = 5) or (val.db = 6) or (val.DB = 7) or (val.DB = 8)) then
    val.DB := 8;
  if not ((val.sb = 3) or (val.sb = 2) or (val.sb = 1)) then
    val.sb := 1;
  if not ((val.pt = 1) or (val.pt = 2) or (val.pt = 3) or (val.pt = 4)) then
    val.pt := 0;

  if val.Com < 1 then
    val.Com := 1;
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

function TKoyoServGroup.getApplication_conf(): string;
begin
  Result := 'DirectKoyoServ';
  ;
end;

end.
