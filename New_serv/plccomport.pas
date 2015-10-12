unit PLCComPort;
{$DEFINE MYCOMMS}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MyComms, math{, debugClasses}, convFunc, ConstDef;

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
    function PLCreadString (slaveNumber: byte; startAddress, dataSize: integer): string;  // override;
    function PLCreadString1 (slaveNumber: byte; startAddress, dataSize: integer; var data: string): integer;  override;
    function PLCreadStringB (slaveNumber: byte; startAddress, dataSize: integer; var data: string): boolean;  //override;
    function PLCwriteString (slaveNumber: byte; startAddress: integer; NewValue: string): integer;  override;

  published
    { Published declarations }
  end;



const

//  SLAVENUMBER = 1;
  MASTERNUMBER = chr($30) + chr($30);

  READOPERATION = CHR ($30);
  WRITEOPERATION = CHR ($38);

  //data type
  dtV = chr($31);
  dtInp = chr($32);
  dtOut = chr($33);
  dtState = chr($39);


implementation
function HexCode (num : integer): char;
begin
     case num of
       1,2,3,4,5,6,7,8,9,0: result := char ($30 + num);
       10, 11, 12, 13, 14, 15: result := char ($37 + num);
       else raise exception.create ('Iaaicii?iia i?aia?aciaaiea');
     end;
end;

function byteToHexASCII(value: byte) : string;
begin
     result := HexCode ( Value shr 4) + HexCode (Value - ((Value shr 4) shl 4));
end;

function wordToHexASCII(value: word) : string;
begin
     result := byteToHexASCII (Value shr 8) +
               byteToHexASCII (VALUE - ((Value shr 8) shl 8));
end;

function CRC(str: string) : byte;
var
   i: integer;
begin
  result := 0;
  for i := 1 to length (str) do
    result := result xor ord(str[i]);
end;



function TPLCComPort.PLCwriteString(slaveNumber: byte; startAddress: integer; NewValue: string): integer;
var
   Request, Unser: string;
   len : integer;
   I: integer;
   dataSize : integer;

begin
  try
     result:=ERRP_W_1;
     dataSize := length (newValue);
     if dataSize > 255 then
      begin
       proterrW:=ERRP_W_1;
       result:= ERRP_W_1;
       raise Exception.Create ('Neeoeii aieuoie aeie aey caiene');
      end;
     Request := chr($4E) + chr($20 + SLAVENUMBER) + ENQ;

     writeString (Request, true);
     Request[3] := ACK;
     len := ReadString(Unser, 3, true);
    if (len <> 3) or (Unser <>  Request) then
        begin
        proterrW:=ERRP_W_2;
        raise exception.create ('Iao iiaoaa??aiey');

        end;
    //header
    request := bytetoHexASCII (SLAVENUMBER)+
               WRITEOPERATION +
               dtV +
               wordtoHexASCII (STARTADDRESS) +
               wordtoHexASCII (DATASIZE) +
               MASTERNUMBER;
    request := SOH + request  + ETB + chr(crc(request));

    FOR I := 1 TO 3 DO BEGIN
     writeString (Request, true);
     len := ReadString(Unser, 1, true);
     if (len > 0) and (unser[1] = ack) then break;
    END;
    if (len < 1) or (unser[1] <> ack) then
       begin
        proterrW:=ERRP_W_3;
        raise exception.create ('Iao iiaoaa??aiey');

        end;


    request := STX + NewValue + ETX + chr(crc(newValue));
    for i := 1 to 3 do begin
     writeString (request, true);
     len := ReadString(Unser, 1, true);
     if (len > 0) and (unser[1] = ack) then break;
    end;
    if (len <> 1) or (unser[1] <> ack) then
       begin
        proterrW:=ERRP_W_4;
        raise Exception.Create ('Iao iiaoaa??aaiey caiene');

        end;
    writeString (EOT, true);
    proterrW:=ERRP_W_NONE;
  finally

  end;
  result:=ERRP_W_NONE;
end;

function TPLCComPort.PLCreadString1 (slaveNumber: byte; startAddress, dataSize: integer; var data: string): integer;
var
   Request, Unser: string;
   str : string;
   len : integer;
   I: integer;
   BlockSize: integer;
const

   MaxBlockSize: integer =256; //maximum data block size

begin
 //  datasize:=256;
  try
   result:=ERRP_R_1;



 Request := chr($4E) + chr($20 + SLAVENUMBER) + ENQ;
     writeString (Request, true);

    Request[3] := ACK;
    len := ReadString(Unser, 3, true);
    if (len <> 3) or (Unser <>  Request) then
      begin
        proterrR:=ERRP_R_1;
        raise exception.create ('Нет подтвержения');

      end;
    //header
    request := bytetoHexASCII (SLAVENUMBER)+
               READOPERATION +
               dtV +
               wordtoHexASCII (STARTADDRESS) +
               wordtoHexASCII (DATASIZE) +
               MASTERNUMBER;

    request := SOH + request  + ETB + chr(crc(request));

    FOR I := 1 TO 3 DO BEGIN
     writeString (Request, true);
     len := ReadString(Unser, 1, true);
     if (len > 0) and (unser[1] = ack) then break;
    END;
    if (len < 1) or (unser[1] <> ack) then
      begin
       proterrR:=ERRP_R_2;
       raise Exception.create ('Нет подтверждения запроса');
      end;
      PugeCom;
  //  writeString (ack, true);
    data := '';
    repeat

      //calculating reading block size
      if DATASIZE > MaxBlockSize then begin
        BlockSize := maxblockSize + 3;
        DATASIZE := DATASIZE - MaxBlockSize;
      end
      else
        BlockSize := DATASIZE + 3;

      //reading block
      len := ReadString(Unser, BlockSize, true);
      if (len <> BlockSize) then
        begin
         proterrR:=ERRP_R_3;
         raise Exception.create ('Нет ответа с данными');
        end;
      //check CRC
      str := copy(unser, 2, length (unser) - 3);
      if chr(crc(str)) <> unser[length(unser)] then
        begin
         proterrR:=ERRP_R_4;
         raise Exception.Create ('Ошибка контрольной суммы.');

        end;
      data := data + str;

      //acknowledge data
      writeString (ack, true);

    until unser[Length(unser)- 1] = ETX;

    len := ReadString(Unser, 1, true);
    if (len <> 1) or (unser[1] <> EOT) then
      begin
       proterrR:=ERRP_R_5;
       raise Exception.create ('Нет подтверждения конца диалога');
      end;
    writeString (EOT, true);
    proterrR:=ERRP_R_None;
  finally

  end;
    result:=ERRP_R_None;
end;

function TPLCComPort.PLCreadStringB (slaveNumber: byte; startAddress, dataSize: integer; var data: string): boolean;
begin
  try
    result := true;
    PLCReadString1 (SlaveNumber, StartAddress, dataSize, data);
  except
    on E: Exception do
    begin

      result := false;
    end;
  end;

end;

function TPLCComPort.PLCreadString (slaveNumber: byte; startAddress, dataSize: integer): string;
var
  data: string;
begin
  PLCReadString1 (SlaveNumber, StartAddress, dataSize, data);
  result := data;
end;

end.
