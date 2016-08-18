unit PLCComPort;

{$DEFINE MYCOMMS}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MyComms, Math{, debugClasses}, convFunc, ConstDef;

type

  TNotifyRead = procedure(const Slavenum: integer) of object;

  //{$IFDEF MYCOMMS}
  TPLCComPort = class(TMyComPort)
    //{$ELSE}
    // TPLCComPort = class(TComPort)
    //{$ENDIF}
  private
    { Private declarations }

  protected
    { Protected declarations }
  public
    //ProterrW: word;
    //ProterrR: word;
    function PLCreadString(slaveNumber: byte; startAddress, dataSize: integer): string;
    // override;
    function PLCreadString1(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer; override;
    function PLCreadString1K(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer;
    function PLCreadStringB(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): boolean;  //override;
    function PLCreadStringModBus(slaveNumber: byte; startAddress, dataSize: integer;
      var Data: string): integer;
    function PLCwriteStringModBus(slaveNumber: byte; startAddress: integer;
      NewValue: string): integer;
    function PLCwriteString(slaveNumber: byte; startAddress: integer;
      NewValue: string): integer; override;
    function PLCwriteStringK(slaveNumber: byte; startAddress: integer;
      NewValue: string): integer;

  published
    { Published declarations }
  end;



const

  //  SLAVENUMBER = 1;
  MASTERNUMBER = chr($30) + chr($30);

  READOPERATION = CHR($30);
  WRITEOPERATION = CHR($38);

  //data type
  dtV = chr($31);
  dtInp = chr($32);
  dtOut = chr($33);
  dtState = chr($39);


implementation

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

function CRC(str: string): byte;
var
  i: integer;
begin
  Result := 0;
  for i := 1 to length(str) do
    Result := Result xor Ord(str[i]);
end;

function WordToStr(Source: word): string;
begin
  Result := chr(Source shr 8) + chr(Source and $FF);
end;

function CRC16(str: string): string;
var
  i, j: integer;
  pol: boolean;
  res: word;
begin
  res := $FFFF;
  for i := 1 to length(str) do
  begin
    res := res xor Ord(str[i]);
    for j := 1 to 8 do
    begin
      pol := (res and 1) = 1;
      res := res shr 1;
      if pol then
        res := res xor $A001;
    end;
  end;
  Result := chr(res and $FF) + chr(res shr 8);
end;

function TPLCComPort.PLCwriteStringK(slaveNumber: byte; startAddress: integer;
  NewValue: string): integer;
var
  Request, Unser: string;
  len: integer;
  I: integer;
  dataSize: integer;

begin
  try
    Result := ERRP_W_1;
    dataSize := length(newValue);
    if dataSize > 255 then
    begin
      proterrW := ERRP_W_1;
      Result := ERRP_W_1;
      raise Exception.Create('Neeoeii aieuoie aeie aey caiene');
    end;
    Request := chr($4E) + chr($20 + SLAVENUMBER) + ENQ;

    writeString(Request, True);
    Request[3] := ACK;
    len := ReadString(Unser, 3, True);
    if (len <> 3) or (Unser <> Request) then
    begin
      proterrW := ERRP_W_2;
      raise Exception.Create('Iao iiaoaa??aiey');

    end;
    //header
    request := bytetoHexASCII(SLAVENUMBER) + WRITEOPERATION +
      dtV + wordtoHexASCII(STARTADDRESS) +
      wordtoHexASCII(DATASIZE) + MASTERNUMBER;
    request := SOH + request + ETB + chr(crc(request));

    for I := 1 to 3 do
    begin
      writeString(Request, True);
      len := ReadString(Unser, 1, True);
      if (len > 0) and (unser[1] = ack) then
        break;
    end;
    if (len < 1) or (unser[1] <> ack) then
    begin
      proterrW := ERRP_W_3;
      raise Exception.Create('Iao iiaoaa??aiey');

    end;


    request := STX + NewValue + ETX + chr(crc(newValue));
    for i := 1 to 3 do
    begin
      writeString(request, True);
      len := ReadString(Unser, 1, True);
      if (len > 0) and (unser[1] = ack) then
        break;
    end;
    if (len <> 1) or (unser[1] <> ack) then
    begin
      proterrW := ERRP_W_4;
      raise Exception.Create('Iao iiaoaa??aaiey caiene');

    end;
    writeString(EOT, True);
    proterrW := ERRP_W_NONE;
  finally

  end;
  Result := ERRP_W_NONE;
end;

function TPLCComPort.PLCwriteString(slaveNumber: byte; startAddress: integer;
  NewValue: string): integer;
begin
  if (fModbus) then
    Result := PLCwriteStringModBus(slaveNumber, startAddress, NewValue)
  else
    Result := PLCwriteStringK(slaveNumber, startAddress, NewValue);
end;

function TPLCComPort.PLCreadString1K(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
var
  Request, Unser: string;
  str: string;
  len: integer;
  I: integer;
  BlockSize: integer;
const

  MaxBlockSize: integer = 256; //maximum data block size

begin
  //  datasize:=256;
  try
    Result := ERRP_R_1;



    Request := chr($4E) + chr($20 + SLAVENUMBER) + ENQ;
    writeString(Request, True);

    Request[3] := ACK;
    len := ReadString(Unser, 3, True);
    if (len <> 3) or (Unser <> Request) then
    begin
      proterrR := ERRP_R_1;
      raise Exception.Create('Нет подтвержения');

    end;
    //header
    request := bytetoHexASCII(SLAVENUMBER) + READOPERATION +
      dtV + wordtoHexASCII(STARTADDRESS) +
      wordtoHexASCII(DATASIZE) + MASTERNUMBER;

    request := SOH + request + ETB + chr(crc(request));

    for I := 1 to 3 do
    begin
      writeString(Request, True);
      len := ReadString(Unser, 1, True);
      if (len > 0) and (unser[1] = ack) then
        break;
    end;
    if (len < 1) or (unser[1] <> ack) then
    begin
      proterrR := ERRP_R_2;
      raise Exception.Create('Нет подтверждения запроса');
    end;
    PugeCom;
    //  writeString (ack, true);
    Data := '';
    repeat

      //calculating reading block size
      if DATASIZE > MaxBlockSize then
      begin
        BlockSize := maxblockSize + 3;
        DATASIZE := DATASIZE - MaxBlockSize;
      end
      else
        BlockSize := DATASIZE + 3;

      //reading block
      len := ReadString(Unser, BlockSize, True);
      if (len <> BlockSize) then
      begin
        proterrR := ERRP_R_3;
        raise Exception.Create('Нет ответа с данными');
      end;
      //check CRC
      str := copy(unser, 2, length(unser) - 3);
      if chr(crc(str)) <> unser[length(unser)] then
      begin
        proterrR := ERRP_R_4;
        raise Exception.Create('Ошибка контрольной суммы.');

      end;
      Data := Data + str;

      //acknowledge data
      writeString(ack, True);

    until unser[Length(unser) - 1] = ETX;

    len := ReadString(Unser, 1, True);
    if (len <> 1) or (unser[1] <> EOT) then
    begin
      proterrR := ERRP_R_5;
      raise Exception.Create('Нет подтверждения конца диалога');
    end;
    writeString(EOT, True);
    proterrR := ERRP_R_None;
  finally

  end;
  Result := ERRP_R_None;
end;

function TPLCComPort.PLCreadString1(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
begin
  if (fModbus) then
    Result := PLCreadStringModBus(slaveNumber, startAddress, dataSize, Data)
  else
    Result := PLCreadString1K(slaveNumber, startAddress, dataSize, Data);
end;

function TPLCComPort.PLCreadStringB(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): boolean;
begin
  try
    Result := True;
    PLCReadString1(SlaveNumber, StartAddress, dataSize, Data);
  except
    on E: Exception do
    begin

      Result := False;
    end;
  end;

end;

function TPLCComPort.PLCreadString(slaveNumber: byte;
  startAddress, dataSize: integer): string;
var
  Data: string;
begin
  PLCReadString1(SlaveNumber, StartAddress, dataSize, Data);
  Result := Data;
end;

function TPLCComPort.PLCreadStringModBus(slaveNumber: byte;
  startAddress, dataSize: integer; var Data: string): integer;
var
  Request, Unser: string;
  str: string;
  len: integer;
  I: integer;
  BlockSize: integer;
  ch: char;
begin
  try
    //if Assigned (OnStartRead) then OnStartRead(slaveNumber);
    //     DEBUG.Log('ReadString1 ' + inttostr(StartAddress)+ '; ' +
    //                inttostr(SlaveNumber)+ '; ' + inttostr(dataSize));
    Result := 0;
    Data := '';
    Request := chr(SLAVENUMBER) + chr(3) + WordToStr(startAddress - 1) +
      WordToStr(dataSize div 2);
    Request := Request + CRC16(Request);
    writeString(Request, True);
    BlockSize := DataSize + 5;
    len := ReadString(str, 1, True);
    if (len <> 1) then
    begin
      Result := ERRP_R_1;
      raise Exception.Create('Нет ответа с данными');
    end;
    len := ReadString(Unser, BlockSize - 1, True);
    if (len <> BlockSize - 1) then
    begin
      Result := ERRP_R_2;
      raise Exception.Create('Нет ответа с данными');
    end;
    Unser := str + Unser;
    //check CRC
    str := copy(unser, 4, length(unser) - 6);
    if copy(Unser, length(Unser) - 1, 2) <> crc16(copy(Unser, 1, length(Unser) - 2)) then
    begin
      Result := ERRP_R_3;
      raise Exception.Create('Ошибка контрольной суммы.');
    end;
    for i := 1 to length(str) div 2 do
    begin
      ch := str[i * 2 - 1];
      str[i * 2 - 1] := str[i * 2];
      str[i * 2] := ch;
    end;
    Data := Data + str;
  finally
    //if Assigned (OnStopRead) then OnStopRead(slaveNumber);

  end;
end;

function TPLCComPort.PLCwriteStringModBus(slaveNumber: byte;
  startAddress: integer; NewValue: string): integer;
var
  Request, Unser: string;
  len: integer;
  I: integer;
  dataSize: integer;
  str: string;
begin
  try
    Result := 0;
    //if Assigned (OnStartWrite) then OnStartWrite(slaveNumber);
    //DEBUG.Log('WriteString ' + inttostr(SlaveNumber)+ '; ' + inttostr(StartAddress) + '; ' + inttostr(BCDTOBIN(PWord(NewValue)^)));
    dataSize := length(newValue);
    if dataSize > 255 then
    begin
      Result := ERRP_W_1;
      raise Exception.Create('Слишком большой блок для записи');
    end;
    str := '';
    for i := 1 to length(NewValue) div 2 do
      str := str + NewValue[i * 2] + NewValue[i * 2 - 1];
    Request := chr(SLAVENUMBER) + chr(16) + WordToStr(StartAddress - 1) +
      WordToStr(dataSize div 2);
    Request := Request + chr(dataSize) + str;
    Request := Request + crc16(Request);
    writeString(Request, True);
    len := ReadString(Unser, 8, True);
    if (len <> 8) then
    begin
      Result := ERRP_W_2;
      raise Exception.Create('Нет подтверждения записи');
    end;
    if copy(Unser, length(Unser) - 1, 2) <> crc16(copy(Unser, 1, length(Unser) - 2)) then
    begin
      Result := ERRP_W_2;
      raise Exception.Create('Ошибка контрольной суммы.');
    end;

  finally
    //if Assigned (OnStopWrite) then OnStopWrite(slaveNumber);
  end;
end;

end.
