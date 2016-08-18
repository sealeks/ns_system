unit InterfaceServerU;

interface

uses
  Windows, Messages, Classes, SysUtils, GenAlg, Controls, Constdef,
  DateUtils, convFunc, StrUtils,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient;

const
  KOYO_PEPORT_ADDRARCH = $1F71;  {oct 17561  AddrArch}
  KOYO_PEPORT_PARAMCOUNT = $1F72;  {oct 17562  ParamCount}
  KOYO_PEPORT_HOURSCOUNT = $1F73;  {oct 17563  HoursCount}
  KOYO_PEPORT_CUR_CNT = $1F77;  {oct 17570  CurAddrArch}
  KOYO_PEPORT_CUR_ADDR = $1F78;  {oct 17570  CurAddrArch}
  KOYO_DATEPERC = $1F7D;  {oct 17570  CurAddrArch}
  KOYO_TIMEPERC = 8062;



type
  TEtherset = record
    bs, frt, frd, trc, tstrt, tstp, wait: integer;

  end;

type
  TCOMSet = record
    Com, br, db, sb, pt, trd, red, ri, rtm, rtc, wtm, wtc, bs, frt, frd, trc, tstrt,
    tstp, prttm, wait, slave: integer;
    Name: string;
    flCtrl: boolean;
    // com - номер порта  1..255
    // br BaudRate - скорость 110..115200
    // db-  Databit       5..8
    // sb - StopBits      1,1.5,2
    // pt - ParityBit     None, Odd, Even, Mark, Space
    // trd-  задержка в миллисекундах до esc
    // red-  задержка в миллисекундах после esc
    // ri -  ReadInterval
    // rtm - ReadTotalMultiplier
    // rtc - ReadTotalConstant
    // wtm - WriteTotalMultiplier
    // wtc - WriteTotalConstan
    // bs -  blockSize
    // flCtrl - Flow control
    // frt - ReadTimeOUT   //  таймаут рарыва св€зи
    // frd - DirectTimeOUT
    // trc - TryCount попытки чтени€
    //  tstrt - врем€ начала часового цикла опроса
    //  tstp  - врем€ конца часового цикла опроса
    //  prttm - задержка перед puge порта
    //  wait  - wait в  WaitForSingleObject


  end;


type
  TInterfaceServer = class(TComponent)
  private
    function readLineRep(slaveNumber: byte; var dt: TDateTime;
      var res: TReportCol; addr_: integer; p_count: integer; var errcnt: integer): boolean;

  public
    fcomset: TCOMSet;
    ProterrW: word;
    ProterrR: word;
    //function PLCreadString (slaveNumber: byte; startAddress, dataSize: integer): string;      virtual;
    function PLCreadString1(slaveNumber: byte; startAddress, dataSize: integer; var Data: string): integer; virtual;
    //function PLCreadStringB (slaveNumber: byte; startAddress, dataSize: integer; var data: string): boolean;  virtual;
    function PLCwriteString(slaveNumber: byte; startAddress: integer;NewValue: string): integer; virtual;
    function ReadSettings: boolean; virtual;
    function Open: boolean; virtual;
    procedure Close; virtual;
    procedure setComset(val: TComset); virtual;
    procedure setTimeSync(slaveNumber: byte; dt: TDateTime);
    function Readreport(slaveNumber: byte; var dt: TDateTime;
      var res: TReportCol): boolean;
    function FillRepData(var res: TReportCol; vl: string; Count: integer): boolean;

  end;


type
  TIPModBusServer = class(TInterfaceServer)

  protected

    TCPClient: TIdTCPClient;

    function PLCreadString(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer;

    function WriteString(Str: string; WaitFor: boolean): DWORD;
    function ReadString(var Str: string; Count: DWORD; WaitFor: boolean): DWORD;

  public

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    function PLCreadString1(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer; override;
    function PLCwriteString(slaveNumber: byte; startAddress: integer;
      NewValue: string): integer; override;

    function ReadSettings: boolean; override;
    function Open: boolean; override;
    procedure Close; override;
    procedure setComset(val: TComset); override;


  end;

function IntToIP(val: integer): string;
function HexCode(num: integer): char;
function byteToHexASCII(Value: byte): string;
function wordToHexASCII(Value: word): string;
function WordToStr(Source: word): string;
function LenToStr(Source: word): string;


implementation


function IntToIP(val: integer): string;
var
  i: integer;
begin
  if val <> 0 then
  begin
    Result := IntToStr(val and $FF);
    for i := 1 to 3 do
      Result := IntToStr((val shr (i * 8)) and $FF) + '.' + Result;
  end
  else
    Result := '127.0.0.1';
end;


function HexCode(num: integer): char;
begin
  case num of
    1, 2, 3, 4, 5, 6, 7, 8, 9, 0: Result := char($30 + num);
    10, 11, 12, 13, 14, 15: Result := char($37 + num);
    else
      raise Exception.Create('Iaaicii?iia i?aia?aciaaiea');
  end;
end;

function byteToHexASCII(Value: byte): string;
begin
  Result := HexCode(Value shr 4) + HexCode(Value - ((Value shr 4) shl 4));
end;

function wordToHexASCII(Value: word): string;
begin
  Result := byteToHexASCII(Value shr 8) +
    byteToHexASCII(Value - ((Value shr 8) shl 8));
end;


function WordToStr(Source: word): string;
begin
  Result := chr(Source shr 8) + chr(Source and $FF);
end;

function LenToStr(Source: word): string;
begin
  Result := chr((Source shr 8) and $FF) + chr(Source and $FF);
end;




function calculateStart(tb_adr, p_cnt, h_cnt, cur_tb: integer;
  tmrq, curtm: TDatetime; err_delt: integer = 0): integer;
var
  cnt: integer;
  tmp_num: integer;
begin
  Result := -1;
  tmrq := normalizeHour(tmrq);
  curtm := normalizeHour(trunc(curtm * 24) / 24);
  cnt := round((curtm - tmrq) * 24) + 1 + err_delt;
  if cnt < 0 then
    exit;
  if cnt > h_cnt then
    exit;
  if (cur_tb >= cnt) then
    tmp_num := cur_tb - cnt
  else
    tmp_num := (h_cnt) - (cnt - cur_tb);
  Result := tb_adr + tmp_num * (2 + p_cnt * 2);
  // result:=result+ (2+2*(5))*2;
end;




function gettimeLine(val: string; var tm: TDatetime): boolean;
var
  cnt: integer;
  tmp_num, yy, mm, dd, hh: word;
  test: string;
begin
  // hh dd yy mm

  Result := False;
  tm := 0;
  if length(val) < 5 then
    exit;

  hh := NS_hexbyteTobinbyte(byte(val[1]));
  dd := NS_hexbyteTobinbyte(byte(val[2]));
  yy := NS_hexbyteTobinbyte(byte(val[3]));
  mm := NS_hexbyteTobinbyte(byte(val[4]));

  // валидаци€ даты

  if (hh < 0) or (hh > 24) then
    exit;
  if (dd < 1) or (dd > 31) then
    exit;
  if (mm < 1) or (mm > 12) then
    exit;
  if (yy < 0) or (yy > 99) then
    exit;

  // валидаци€ пройдена

  tm := encodedatetime(2000 + yy, mm, dd, hh, 0, 0, 0);
  tm := inchour(tm, 1);
  tm := normalizeHour(tm);
  test := Datetimetostr(tm);
  Result := True;
end;

function GetSingleVal(vl: string; adr: integer): single;
var
  tmp_str: string;
  i: integer;
begin
  tmp_str := '';
  for i := 1 to 4 do
    tmp_str := tmp_str + vl[4 * adr + i];
  Result := Psingle(@tmp_str[1])^;
end;


function TInterfaceServer.PLCreadString1(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
begin
end;

function TInterfaceServer.PLCwriteString(slaveNumber: byte;
  startAddress: integer; NewValue: string): integer;
begin
end;

function TInterfaceServer.ReadSettings: boolean;
begin

end;

function TInterfaceServer.Open: boolean;
begin

end;

procedure TInterfaceServer.Close;
begin

end;

procedure TInterfaceServer.setComset(val: TComset);
begin
end;

function TInterfaceServer.Readreport(slaveNumber: byte; var dt: TDateTime;
  var res: TReportCol): boolean;

var
  meta_dat, dat: string;
  p_count, h_count, addr_tab, cnt_cur, cnt_addr, sech_addr,
  line_length, tmp_err: integer;
  tm_line, tm_now: TDateTime;
  test: string;
  i: integer;
begin
  setlength(res, 0);
  try
    Result := False;
    tm_now := now;
    PLCreadString1(slaveNumber, KOYO_PEPORT_ADDRARCH + 1, 16, meta_dat);
    if (ProterrR = 0) and (length(meta_dat) >= 16) then
    begin
      test := Datetimetostr(dt);
      addr_tab := NS_strBinOctToInt(meta_dat[2] + meta_dat[1]);
      p_count := NS_strBinToInt(meta_dat[4] + meta_dat[3]);
      h_count := NS_strBinToInt(meta_dat[6] + meta_dat[5]);
      cnt_cur := NS_strBinToInt(meta_dat[14] + meta_dat[13]);
      cnt_addr := NS_strBinOctToInt(meta_dat[16] + meta_dat[15]);

      // проверка корректности

      if (addr_tab > $4000) or (p_count > $100) or
        (h_count > $400) then
      begin
        Result := True;
        exit;
      end;

      // проверка корректности

      if (cnt_cur > h_count) or (cnt_addr >
        (addr_tab + h_count * (2 + 2 * (p_count + 1)))) then
      begin
        Result := True;
        exit;
      end;


      sech_addr := calculateStart(addr_tab, p_count, h_count, cnt_cur, dt, tm_now);

      // попытка прочитать текущий

      if sech_addr = cnt_addr then
      begin
        Result := False;
        exit;
      end;

      // адресс с ошибкой

      if sech_addr < 0 then
      begin

        Result := True;
        exit;
      end;

      // удачна€ валидаци€ адреса

      // sech_addr:=sech_addr;

      if readLineRep(slaveNumber, dt, res, sech_addr, p_count, tmp_err) then
      begin
        if tmp_err = 0 then
        begin
          Result := True;
          exit;
        end
        else
          //  ловим смещение
        begin
          sech_addr :=
            calculateStart(addr_tab, p_count, h_count, cnt_cur, dt, tm_now, tmp_err);
          setlength(res, 0);
          // повторна€ валидаци€
          if sech_addr = cnt_addr then
          begin
            Result := False;
            exit;
          end;

          if sech_addr < 0 then
          begin
            Result := True;
            exit;
          end;

          if not readLineRep(slaveNumber, dt, res,
            sech_addr, p_count, tmp_err) then
            setlength(res, 0);
          if tmp_err <> 0 then
            setlength(res, 0);
          Result := True;
          exit;

        end;
      end
      else
      begin
        setlength(res, 0);
        Result := True;
        exit;
      end;

    end
    else
    begin
      Result := False;
      exit;
    end;
  except
    ProterrR := ERRP_R_1;
    Result := False;
  end;

end;

function TInterfaceServer.readLineRep(slaveNumber: byte; var dt: TDateTime;
  var res: TReportCol; addr_: integer; p_count: integer; var errcnt: integer): boolean;
var
  dat: string;
  line_length: integer;
  tm_line: TDateTime;
  test: string;
  i: integer;

begin
  line_length := 4 + 4 * p_count;
  PLCreadString1(slaveNumber, addr_ + 1, line_length, dat);
  // hh dd yy mm
  if (length(dat) >= line_length) then
  begin
    if gettimeLine(dat, tm_line) then
    begin
      errcnt := hoursBetween(dt, tm_line);
      if errcnt = 0 then
      begin
        dt := tm_line;
        FillRepData(res, dat, p_count);
        Result := True;
      end
      else
      begin
        setlength(res, 0);
        Result := True;
      end;
    end
    else
    begin
      setlength(res, 0);
      Result := True;
      exit;
    end;
  end;

end;

function TInterfaceServer.FillRepData(var res: TReportCol; vl: string;
  Count: integer): boolean;
var
  i: integer;
begin
  Result := False;
  vl := rightstr(vl, length(vl) - 4);
  setlength(res, Count);
  for i := 0 to Count - 1 do
    res[i] := GetSingleVal(vl, i);
  Result := True;
end;

procedure TInterfaceServer.setTimeSync(slaveNumber: byte; dt: TDateTime);
var
  dd, hh, mm, yy, ss, nn, ww, out_: longint;
  str_out: string;
begin
  try
    ss := SecondOf(dt);
    nn := MinuteOf(dt);
    hh := HourOf(dt);
    dd := dayof(dt);
    mm := Monthof(dt);
    yy := YearOf(dt) mod 100;
    ww := DayOfTheWeek(dt);
    if ww = 7 then
      ww := 0;
    ww := ww;

    str_out := char(NS_binbyteToHexbyte(ss)) +
      char(NS_binbyteToHexbyte(nn)) + char(NS_binbyteToHexbyte(hh)) + char($80);
    PLCwriteString(slaveNumber, KOYO_TIMEPERC, str_out);
    str_out := char($80 or NS_binbyteToHexbyte(ww)) +
      char(NS_binbyteToHexbyte(dd)) + char(NS_binbyteToHexbyte(mm)) +
      char(NS_binbyteToHexbyte(yy));
    PLCwriteString(slaveNumber, KOYO_TIMEPERC, str_out);
  except
  end;
end;




{------------------------------------------------------------------------------------}
{ implement TIPModBusServer}


constructor TIPModBusServer.Create(aOwner: TComponent);
begin
  inherited;
  TCPClient := TIdTCPClient.Create(nil);
end;


destructor TIPModBusServer.Destroy;
begin
  TCPClient.Free;
  inherited Destroy;
end;


function TIPModBusServer.ReadSettings: boolean;
begin
  Result := True;
end;

function TIPModBusServer.Open: boolean;
begin
  try
    if (not TCPClient.Connected) then
    begin
      TCPClient.Host := IntToIP(fcomset.wtm);
      TCPClient.Port := 502;
      TCPClient.Connect(fcomset.wait);
      Result := TCPClient.Connected;
    end
    else
      Result := True;
    exit;
  except
  end;
  Result := False;
end;


procedure TIPModBusServer.Close;
begin
  try
    if (TCPClient.Connected) then
      TCPClient.Disconnect;
  except
  end;
end;


procedure TIPModBusServer.setComset(val: TComset);
begin

end;


function TIPModBusServer.PLCreadString1(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
begin
  result:=PLCreadString(SlaveNumber, StartAddress, dataSize, Data);
end;


function TIPModBusServer.PLCreadString(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
var
  Request, Body, Unser: string;
  str: string;
  len, cnt: integer;
  I: integer;
  BlockSize: integer;
  ch: char;
begin
  try
    Result := 0;
    Data := '';
    Body := chr(SLAVENUMBER) + chr(3) + WordToStr(startAddress - 1) + WordToStr(dataSize div 2);
    Request := chr(0) + chr(0) + chr(0) + chr(0) + LenToStr(Length(Body)) + Body;
    if (writeString(Request, True)<> Length(Request)) then
    begin
      Result := ERRP_R_1;
      proterrR := Result;
      //raise Exception.create ('Ќе послать запрос');
      exit;
    end;
    BlockSize := DataSize + 3;
    len := ReadString(str, 6, True);
    if ((len <> 6) or (Length(str) < 6)) then
    begin
      Result := ERRP_R_1;
      proterrR := Result;
      //raise Exception.create ('Ќет ответа с данными');
      exit;
    end;
    cnt := integer(str[6]) + integer(str[5]) * $100;
    len := ReadString(Unser, BlockSize, True);
    if (cnt <> len) then
    begin
      Result := ERRP_R_2;
      proterrR := Result;
      //raise Exception.create ('Ќет ответа с данными');
      exit;
    end;
    str := copy(unser, 4, length(unser) - 3);
    for i := 1 to length(str) div 2 do
    begin
      ch := str[i * 2 - 1];
      str[i * 2 - 1] := str[i * 2];
      str[i * 2] := ch;
    end;
    Data := Data + str;
    proterrR := 0;
  finally
  end;
end;


function TIPModBusServer.PLCwriteString(slaveNumber: byte;
  startAddress: integer; NewValue: string): integer;
var
  Request, Body, Unser: string;
  len, cnt: integer;
  I: integer;
  dataSize: integer;
  str: string;
begin
  try
    Result := 0;
    dataSize := length(newValue);
    if dataSize > 255 then
    begin
      Result := ERRP_W_1;
      proterrW := Result;
      //raise Exception.Create ('—лишком большой блок дл€ записи');
      exit;
    end;
    str := '';
    for i := 1 to length(NewValue) div 2 do
      str := str + NewValue[i * 2] + NewValue[i * 2 - 1];
    Body := chr(SLAVENUMBER) + chr(16) + WordToStr(StartAddress - 1) +
      WordToStr(dataSize div 2) + chr(dataSize) + str;
    Request := chr(0) + chr(0) + chr(0) + chr(0) + LenToStr(Length(Body)) + Body;

    if (writeString(Request, True)<> Length(Request)) then
    begin
      Result := ERRP_R_1;
      proterrR := Result;
      //raise Exception.create ('Ќе послать запрос');
      exit;
    end;

    len := ReadString(Unser, 6, True);
    if (len <> 6) then
    begin
      Result := ERRP_W_2;
      proterrW := Result;
      //raise exception.create ('Ќет подтверждени€ записи');
      exit;
    end;
    cnt := integer(Unser[6]) + integer(Unser[5]) * $100;
    len := ReadString(Unser, cnt, True);
    if (len = 0) then
    begin
      Result := ERRP_W_2;
      proterrW := Result;
      //raise exception.create ('Ќет подтверждени€ записи');
      exit;
    end;
    if (cnt <> len) then
    begin
      Result := ERRP_W_2;
      proterrW := Result;
      //raise exception.create ('Ќет подтверждени€ записи');
      exit;
    end;
    if (byte(Unser[1]) <> slaveNumber) then
    begin
      Result := ERRP_W_2;
      proterrW := Result;
      //raise exception.create ('Ќекорректный ответ');
      exit;
    end;
    proterrW := 0;

  finally
    //if Assigned (OnStopWrite) then OnStopWrite(slaveNumber);
  end;
end;



function TIPModBusServer.WriteString(Str: string; WaitFor: boolean): DWORD;
begin
  Result := 0;
  try
    if (not TCPClient.Connected) then
      if (not Open()) then
        exit;
    TCPClient.Write(Str);
    Result := Length(Str);
    exit;
  except
  end;
  Close;
end;

function TIPModBusServer.ReadString(var Str: string; Count: DWORD;
  WaitFor: boolean): DWORD;
begin
  Result := 0;
  try
    if (not TCPClient.Connected) then
      if (not Open()) then
        exit;
    Str := TCPClient.ReadString(Count);
    Result := Count;
    exit;
  except
  end;
  Close;
end;

end.
