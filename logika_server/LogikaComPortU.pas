unit LogikaComPortU;




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StrUtils,
  MyComms, Math, convFunc, DateUtils, ConstDef;

type

  TMarkerMSgT = (mmsgRefuse, mmsgCupture, mmsgAck, mmsgNone);

  TNotifyRead = procedure(const Slavenum: integer) of object;

  TLogikaComPort = class(TMyComPort)
  protected

    function WriteFlag: boolean;

  public

    function LogikareadStringProxy(slaveNumber: byte; proxyNumber: byte;
      func: byte; body: string; maxnum: byte; var res: string): integer;
    function LogikareadStr(slaveNumber: byte; proxyNumber: byte;
      func: byte; body: string; maxnum: byte; var res: string;
      direct: boolean = False): integer;

  end;

const

  RCURRENT = chr($1D);// запрос текущих
  ACURRENT = chr($03);// ответ на текущие
  RARRAY = chr($0C);  // запрос массивов
  AARRAY = chr($14); // ответ массивов
  RARCH = chr($E);  // запрос массивов
  AARCH = chr($16); // ответ массивов


  WCURRENT = chr($03);// запрос текущих
  WACURRENT = chr($7F);// ответ на текущие
  WARRAY = chr($14);  // запрос массивов
  WAARRAY = chr($7F); // ответ массивов

  NOACTIVATE = -1;
  ANSWER_OK = 0;
  ERROR_NO_ANSWER = $100;
  ERROR_ADDRESS = $103;
  ERROR_FUNC = $104;
  ERROR_NO_CORRECTANSWER = $101;
  ERROR_CRC = $102;
  ERROR_OPEN = $110;
  ERROR_NOCONNECT = $111;
  ERROR_NOCUPTURE = $112;
  ERROR_NOACK = $113;
  ERROR_NOANSWERMARKER = $114;

  APPTIMOUT = 6;

function AnswerFunc(fc: byte): byte;
function CRC16str(str: string): string;
function CRC16(str: string): word;
function ComLerrorStr(vl: integer): string;
function ProtocolBaseTB(vl: TBaudRate): integer;
function ProtocolTO_calculate(vl: TBaudRate; selfnum: byte; curnum: byte;
  maxnum: byte; msg: TMarkerMSgT; var tm: integer): boolean;

implementation

// таймаут базовый
function ProtocolBaseTB(vl: TBaudRate): integer;
begin
  case vl of
    br110, br300: Result := 120;
    br600: Result := 80;
    br1200: Result := 60;
    br2400, br4800: Result := 40;
    br9600, br14400, br19200, br38400, br56000, br57600, br115200: Result := 20;
  end;
end;


// таймаут базовый отказа
function ProtocolBaseTM(vl: TBaudRate): integer;
begin
  case vl of
    br110: Result := 8 * 5700 * 1000 div 110;
    br300: Result := 8 * 5700 * 1000 div 300;
    br600: Result := 8 * 5700 * 1000 div 600;
    br1200: Result := 8 * 5700 * 1000 div 1200;
    br2400: Result := 8 * 5700 * 1000 div 2400;
    br4800: Result := 8 * 5700 * 1000 div 4800;
    br9600: Result := 8 * 5700 * 1000 div 9600;
    br14400: Result := 8 * 5700 * 1000 div 14400;
    br19200: Result := 8 * 5700 * 1000 div 19200;
    br38400: Result := 8 * 5700 * 1000 div 38400;
    br56000: Result := 8 * 5700 * 1000 div 56000;
    br57600: Result := 8 * 5700 * 1000 div 57600;
    br115200: Result := 8 * 5700 * 1000 div 115200;
  end;
end;


function ProtocolTO_calculate(vl: TBaudRate; selfnum: byte; curnum: byte;
  maxnum: byte; msg: TMarkerMSgT; var tm: integer): boolean;
begin
  Result := False;
  tm := round(ProtocolBaseTM(vl) * 1.5 + selfnum * ProtocolBaseTB(vl));
  if ((msg = mmsgRefuse) or (msg = mmsgCupture)) then
  begin
    Result := True;
    case msg of
      mmsgRefuse:
      begin
        if (selfnum > curnum) then
          tm := round((selfnum - curnum) * ProtocolBaseTB(vl))
        else
          tm := round((selfnum - curnum + maxnum + 1) * ProtocolBaseTB(vl));
      end;
      mmsgCupture: tm := round(ProtocolBaseTM(vl) * 1.5 + selfnum * ProtocolBaseTB(vl));
    end;
  end;
end;

// адрес из пост-маркера
function getAdrfromMarker(vl: char): byte;
begin
  Result := (byte(vl) and ($1F));
end;
// тип из пост-маркера

function getTypfromMarker(vl: char): TMarkerMSgT;
var
  tmp: byte;
begin
  tmp := (byte(vl) and ($E0));
  case tmp of
    $60: Result := mmsgAck;
    $40: Result := mmsgRefuse;
    $20: Result := mmsgCupture;
    else
      Result := mmsgNone;
  end;
end;


// тип из пост-маркера

function createtoMarker(vl: TMarkerMSgT; addr: byte): byte;
begin
  Result := 0;
  case vl of
    mmsgAck: Result := Result or $60;
    mmsgRefuse: Result := Result or $40;
    mmsgCupture: Result := Result or $20;
  end;
  Result := (Result or addr);
end;

function AnswerFunc(fc: byte): byte;
begin
  case char(fc) of
    RCURRENT: Result := byte(ACURRENT);
    RARRAY: Result := byte(AARRAY);
    RARCH: Result := byte(AARCH);
    WCURRENT: Result := byte(WACURRENT);
    WARRAY: Result := byte(WAARRAY);
  end;
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

function ComLerrorStr(vl: integer): string;
begin
  case vl of
    ANSWER_OK: Result := 'OK';
    ERROR_NO_ANSWER: Result := 'NO_ANSWER';
    ERROR_ADDRESS: Result := 'ADR_VALIDATE';
    ERROR_FUNC: Result := 'COD_FUNC_INTERPR';
    ERROR_NO_CORRECTANSWER: Result := 'NO_CORRECT_ANSWER';
    ERROR_CRC: Result := 'CRC_ERR';
    ERROR_OPEN: Result := 'PORT_NOTOPEN';
    ERROR_NOCONNECT: Result := 'CRC_CONNECT';
    NOACTIVATE: Result := 'NO_ACTIVATE';
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

function CRC16str(str: string): string;
var
  wordres: word;
begin
  wordres := CRC16(str);
  Result := char((wordres and $FF00) shr 8) + char(wordres and $FF);
end;


function CRC16(str: string): word;
var
  j, len, i: integer;
  crc_: integer;
begin
  j := 0;
  crc_ := 0;
  len := length(str);
  i := 1;
  while (len > 0) do
  begin
    crc_ := (crc_) xor (integer(str[i])) shl 8;
    Inc(i);
    for j := 0 to 7 do
      if (crc_ and $8000) <> 0 then
        crc_ := (crc_ shl 1) xor $1021
      else
        crc_ := (crc_ shl 1);
    len := len - 1;
  end;
  Result := crc_;
end;


function TLogikaComPort.WriteFlag: boolean;
var
  DCB: TDCB;
  oldParity: byte;
  str: string;

begin

  Result := True;

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity := DCB.Parity;
  DCB.Parity := MARKPARITY;
  SetCommState(FHandle, DCB);


  try

    WriteString(char($FF), True);

  finally

    GetCommState(FHandle, DCB);
    DCB.DCBlength := SizeOf(DCB);
    DCB.Parity := oldParity;
    SetCommState(FHandle, DCB);

  end;
end;




function TLogikaComPort.LogikareadStringProxy(slaveNumber: byte;
  proxyNumber: byte; func: byte; body: string; maxnum: byte; var res: string): integer;
var
  afunc: byte;
  w_comand: string;
  Data, crc_inspect: string;
  len: integer;
begin
  if not Connected then
  begin
    Result := ERROR_NOCONNECT;
    exit;
  end;
  proxyNumber := $80 or proxyNumber;
  afunc := AnswerFunc(func);
  w_comand := char(slaveNumber) + char(proxyNumber) + DLE + ISI + char(func) + body;
  w_comand := w_comand + CRC16str(w_comand);
  w_comand := DLE + SOH + w_comand;
  writeString(w_comand, True);
  len := ReadString(Data, 5700, True);
  if len < 8 then
  begin
    Result := ERROR_NO_ANSWER;
    setlength(Data, 0);
    exit;
  end;

  setlength(Data, len);

  // проверка старта ответа д. б. DLE SOH

  if ((Data[1] <> DLE) or (Data[2] <> SOH)) then
  begin
    Result := ERROR_NO_CORRECTANSWER;
    setlength(Data, 0);
    exit;
  end;

  Data := Rightstr(Data, length(Data) - 2);

  if length(Data) < 4 then       // тест длинны
  begin
    Result := ERROR_NO_ANSWER;
    setlength(Data, 0);
    exit;
  end;

  crc_inspect := Rightstr(Data, 2);
  Data := Leftstr(Data, length(Data) - 2);

  //  провекка контрольной суммы

  if (trim(CRC16str(Data)) <> trim(crc_inspect)) then
  begin
    Result := ERROR_CRC;
    setlength(Data, 0);
    exit;
  end;

  // проверка адресов источника и приемника

  if length(Data) < 4 then         // тест длинны
  begin
    Result := ERROR_NO_ANSWER;
    setlength(Data, 0);
    exit;
  end;

  if ((Data[1] <> char(proxyNumber)) or (Data[2] <> char(slaveNumber))) then
  begin
    Result := ERROR_ADDRESS;
    setlength(Data, 0);
    ReadString(Data, 5700, True);
    PugeCom;
    exit;
  end;

  Data := Rightstr(Data, length(Data) - 2);



  // проверка кода функции

  if length(Data) < 5 then      // тест длинны
  begin
    Result := ERROR_NO_ANSWER;
    setlength(Data, 0);
    exit;
  end;

  if ((Data[1] <> DLE) or (Data[2] <> ISI) or (Data[3] <> char(afunc))) then
  begin
    Result := ERROR_FUNC;
    setlength(Data, 0);
    ReadString(Data, 5700, True);
    PugeCom;
    exit;
  end;

  Data := Rightstr(Data, length(Data) - 3);

  // writeString (data, true);

  Result := ANSWER_OK;
  res := Data;

end;

function TLogikaComPort.LogikareadStr(slaveNumber: byte; proxyNumber: byte;
  func: byte; body: string; maxnum: byte; var res: string;
  direct: boolean = False): integer;
begin
    Result := LogikareadStringProxy(slaveNumber, proxyNumber, func, body, maxnum, res);
end;


end.
