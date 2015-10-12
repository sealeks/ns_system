unit LogikaComPortU;




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StrUtils,
   MyComms, math, convFunc, DateUtils, ConstDef;

type

  TMarkerMSgT = (mmsgRefuse, mmsgCupture, mmsgAck, mmsgNone );

  TNotifyRead = procedure(const Slavenum: integer) of object;

  TLogikaComPort = class(TMyComPort)

  private


  protected
    function  WaitAckMarker(num: byte; waitiime: integer): boolean;
    function  WriteAckMarker(addr: byte): boolean;

    function  WriteFlag: boolean;
    function  Wait2CharWithMarker(wc: char; waitiime: integer; var num: byte; var typ_: TMarkerMSgT): boolean;
    function  CatureMarkerandResponse(slaveNumber: byte; proxyNumber: byte; maxnum: byte): integer;
    function  ReadDirectData(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
    function  ReadDirect(var Str: String; Count: DWORD; WaitPerid: integer): DWORD;
    function  WriteMarkerForse(addr_: byte; typ_: TMarkerMSgT): boolean;
    function  WriteMarker(addr_: byte; typ_: TMarkerMSgT): boolean;
    function  CaptureResponse(slaveNumber: byte; proxyNumber: byte): integer;
  public




    function  LogikareadStringDirect (slaveNumber: byte; proxyNumber: byte; func: byte; body: string; maxnum: byte; var res: string): integer;
    function  LogikareadStringProxy (slaveNumber: byte; proxyNumber: byte; func: byte; body: string;  maxnum: byte; var res: string): integer;
    function  LogikareadStr (slaveNumber: byte; proxyNumber: byte; func: byte; body: string;  maxnum: byte; var res: string; direct: boolean =false): integer;
  published
    { Published declarations }
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

  NOACTIVATE=-1;
  ANSWER_OK=0;
  ERROR_NO_ANSWER=$100;
  ERROR_ADDRESS=$103;
  ERROR_FUNC=$104;
  ERROR_NO_CORRECTANSWER=$101;
  ERROR_CRC=$102;
  ERROR_OPEN=$110;
  ERROR_NOCONNECT=$111;
  ERROR_NOCUPTURE=$112;
  ERROR_NOACK=$113;
  ERROR_NOANSWERMARKER=$114;

  APPTIMOUT = 6;

function AnswerFunc(fc: byte): byte;
function CRC16str(str: string) : string;
function CRC16(str: string) : word;
function ComLerrorStr(vl: integer) : string;
function ProtocolBaseTB(vl: TBaudRate) : integer;
function ProtocolTO_calculate(vl: TBaudRate; selfnum: byte;  curnum: byte; maxnum: byte; msg: TMarkerMSgT; var  tm: integer): boolean;

implementation

// таймаут базовый
function ProtocolBaseTB(vl: TBaudRate) : integer;
begin
   case vl of
     br110, br300: result:=120;
     br600: result:=80;
     br1200: result:=60;
     br2400, br4800: result:=40;
     br9600,br14400, br19200, br38400, br56000, br57600, br115200: result:=20;
   end;
end;


// таймаут базовый отказа
function ProtocolBaseTM(vl: TBaudRate) : integer;
begin
   case vl of
     br110:   result:=8*5700*1000 div 110;
     br300:   result:=8*5700*1000 div 300;
     br600:   result:=8*5700*1000 div 600;
     br1200:  result:=8*5700*1000 div 1200;
     br2400:  result:=8*5700*1000 div 2400;
     br4800:  result:=8*5700*1000 div 4800;
     br9600:  result:=8*5700*1000 div 9600;
     br14400: result:=8*5700*1000 div 14400;
     br19200: result:=8*5700*1000 div 19200;
     br38400: result:=8*5700*1000 div 38400;
     br56000: result:=8*5700*1000 div 56000;
     br57600: result:=8*5700*1000 div 57600;
     br115200: result:=8*5700*1000 div 115200;
   end;
end;


function ProtocolTO_calculate(vl: TBaudRate; selfnum: byte;  curnum: byte; maxnum: byte; msg: TMarkerMSgT; var  tm: integer): boolean;
begin
  result:=false;
  tm:=round(ProtocolBaseTM(vl)*1.5+selfnum*ProtocolBaseTB(vl));
  if ((msg=mmsgRefuse) or (msg=mmsgCupture)) then
    begin
       result:=true;
       case msg of
         mmsgRefuse: begin
                       if (selfnum>curnum) then
                          tm:=round((selfnum-curnum)*ProtocolBaseTB(vl))
                       else tm:=round((selfnum-curnum+maxnum+1)*ProtocolBaseTB(vl));
                     end;
         mmsgCupture: tm:=round(ProtocolBaseTM(vl)*1.5+selfnum*ProtocolBaseTB(vl));
         end;
    end;
end;

// адрес из пост-маркера
function getAdrfromMarker(vl: char) : byte;
begin
  result:=(byte(vl) and ($1F))
end;
// тип из пост-маркера

function getTypfromMarker(vl: char) : TMarkerMSgT;
var tmp: byte;
begin
  tmp:=(byte(vl) and ($E0));
  case tmp of
    $60: result:=mmsgAck;
    $40: result:=mmsgRefuse;
    $20: result:=mmsgCupture;
  else result:=mmsgNone;
  end;
end;


// тип из пост-маркера

function createtoMarker(vl: TMarkerMSgT; addr: byte): byte;
begin
  result:=0;
  case vl of
    mmsgAck : result:=result or $60;
    mmsgRefuse : result:=result or $40;
    mmsgCupture: result:=result or $20;
  end;
  result:=(result or addr);
end;

function AnswerFunc(fc: byte): byte;
begin
   case char(fc) of
     RCURRENT: result:=byte(ACURRENT);
     RARRAY:  result:=byte(AARRAY);
     RARCH: result:=byte(AARCH);
     WCURRENT: result:=byte(WACURRENT);
     WARRAY:  result:=byte(WAARRAY);
   end;
end;


function HexCode (num : integer): char;
begin
     case num of
       1,2,3,4,5,6,7,8,9,0: result := char ($30 + num);
       10, 11, 12, 13, 14, 15: result := char ($37 + num);
       else raise exception.create ('Iaaicii?iia i?aia?aciaaiea');
     end;
end;

function ComLerrorStr(vl: integer) : string;
begin
  case vl of
  ANSWER_OK: result:='OK';
  ERROR_NO_ANSWER: result:='NO_ANSWER';
  ERROR_ADDRESS: result:='ADR_VALIDATE';
  ERROR_FUNC: result:='COD_FUNC_INTERPR';
  ERROR_NO_CORRECTANSWER: result:='NO_CORRECT_ANSWER';
  ERROR_CRC: result:='CRC_ERR';
  ERROR_OPEN: result:='PORT_NOTOPEN';
  ERROR_NOCONNECT: result:='CRC_CONNECT';
  NOACTIVATE: result:='NO_ACTIVATE';
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

function CRC16str(str: string) : string;
var wordres: word;
begin
    wordres:=CRC16(str);
    result:=char((wordres and $FF00) shr 8)+char(wordres and $FF)
end;


function CRC16(str: string) : word;
var
   j,len,i: integer;
   crc_: integer;
begin
  j:=0;
  crc_:=0;
  len:=length(str);
  i:=1;
  while (len>0) do
   begin
   crc_:=(crc_) xor (integer(str[i])) shl 8;
   inc(i);
   for j := 0 to 7 do
      if (crc_ and $8000)<>0 then crc_:=(crc_ shl 1) xor $1021
      else crc_:=(crc_ shl 1);
   len:=len-1;
   end;
   result:=crc_;
end;





function TLogikaComPort.ReadDirect(var Str: String; Count: DWORD; WaitPerid: integer): DWORD;
var
  Success: Boolean;
  BytesTrans, Signaled: DWORD;
  AsyncPtr: PAsync;
begin

  try

  InitAsync(AsyncPtr);

  SetLength(Str, Count);
  ReadFile(FHandle, Str[1], Count, BytesTrans, @AsyncPtr^.Overlapped);
  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, WaitPerid);
  Success := (Signaled = WAIT_OBJECT_0);
  GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, true);
  Result := BytesTrans;
  if not Success then
  result:=0
  else result:=bytestrans;

  finally
    DoneAsync(AsyncPtr);
  end;

end;


function TLogikaComPort.WriteMarkerForse(addr_: byte;  typ_: TMarkerMSgT): boolean;
var
  DCB: TDCB;
  oldParity: byte;
  temp: byte;

begin

  result:=true;

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  DCB.Parity:=MARKPARITY;
  SetCommState(FHandle, DCB);

  temp:=createtoMarker(typ_,addr_);
  ComTimer(APPTIMOUT);

  try

   result:=( TransmitCommChar(FHandle ,char($FF)) and (TransmitCommChar(FHandle ,char(temp))))

  finally

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  DCB.Parity:=oldParity;
  SetCommState(FHandle, DCB);

  end;

end;


function TLogikaComPort.WriteMarker(addr_: byte;  typ_: TMarkerMSgT): boolean;
var
  DCB: TDCB;
  oldParity: byte;
  temp: byte;
begin

  result:=true;

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  DCB.Parity:=MARKPARITY;
  SetCommState(FHandle, DCB);

  temp:=createtoMarker(typ_,addr_);
  ComTimer(APPTIMOUT);

  try
   WriteString(char($FF)+char(temp),true);
  finally

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  DCB.Parity:=oldParity;
  SetCommState(FHandle, DCB);

  end;

end;


function TLogikaComPort.WriteFlag: boolean;
var
  DCB: TDCB;
  oldParity: byte;
  str: string;

begin

  result:=true;

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  DCB.Parity:=MARKPARITY;
  SetCommState(FHandle, DCB);


  try

  WriteString(char($FF),true);

  finally

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  DCB.Parity:=oldParity;
  SetCommState(FHandle, DCB);

  end;

end;


function TLogikaComPort.WriteAckMarker(addr: byte): boolean;
var
  DCB: TDCB;
  oldParity: byte;
begin

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  DCB.Parity:=MARKPARITY;
  SetCommState(FHandle, DCB);

  try
    if TransmitCommChar(FHandle ,char($FF)) then
    begin

      GetCommState(FHandle, DCB);
      DCB.DCBlength := SizeOf(DCB);
      DCB.Parity:= oldParity;
      SetCommState(FHandle, DCB);
 
      TransmitCommChar(FHandle ,char(createtoMarker(mmsgAck,addr)));
      result:=true;

    end;
  finally

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  DCB.Parity:=oldParity;
  SetCommState(FHandle, DCB);

  end;
end;




function TLogikaComPort.CatureMarkerandResponse(slaveNumber: byte; proxyNumber: byte; maxnum: byte): integer;
var
  fl, fl_read: boolean;
  temptyp: TMarkerMSgT;
  tempnum: byte;
  starttime: Tdatetime;
  curtime: Tdatetime;
  temptm, curtimout, msb: integer;
  str: string;
  temp: integer;
begin

  fl_read:=true;
  fl:=false;
  starttime:=now;
  curtime:=0;
  result:=ERROR_NOCUPTURE;



  if Wait2CharWithMarker(char($FF),fcomset.wait,tempnum,temptyp) then
    begin
      while not fl and (abs(MilliSecondsBetween(now,starttime))<CurCoSet.wait) do
       begin
          if fl_read then
          begin
          if ProtocolTO_calculate(BaudRate,proxyNumber,tempnum,maxnum,temptyp,temptm) then
            begin
              curtimout:=temptm;
              curtime:=incMillisecond(now,curtimout);
            end;
          end;
          if curtime<>0 then
           begin
              msb:=millisecondsbetween(now,curtime);
              if (msb>APPTIMOUT) and (msb<=ProtocolBaseTB(BaudRate)) then
               begin
                 if (msb>-1) then
                 begin
                  fl:=true;
                  break;
                 end;
               end;
           end;
          if not fl then
            fl_read:=Wait2CharWithMarker(char($FF),ProtocolBaseTB(BaudRate)+APPTIMOUT,tempnum,temptyp);
       end;
     end;



    if fl then
     begin

    result:=ERROR_NOACK;
   // PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
    ComTimer(APPTIMOUT);

    fl:=WriteMarkerForse(slaveNumber,mmsgCupture);

    setlength(str,2);

    temp:=ReadDirect(str, 2, fcomset.wait);
    if (temp=2) and (length(str)=2) then
       begin
       if pos(char(slaveNumber or $60),str)>0 then
          result:=0
          else
          begin
          result:=ERROR_NOACK; end
       end;

      ComTimer(APPTIMOUT);

      
     end;

end;


function TLogikaComPort.CaptureResponse(slaveNumber: byte; proxyNumber: byte): integer;
var
  fl, fl_read: boolean;
  temptyp: TMarkerMSgT;
  tempnum: byte;
  starttime: Tdatetime;
  temptm, curtimout: integer;
begin
  fl:=false;
  starttime:=now;
  result:=ERROR_NOANSWERMARKER;
  fl_read:=true;
  if Wait2CharWithMarker(char($FF),CurCoSet.wait,tempnum,temptyp) then
    begin
      while not fl and (abs(MilliSecondsBetween(now,starttime))<CurCoSet.wait) do
       begin
          if (temptyp=mmsgCupture) and (tempnum=proxyNumber)
            then fl:=true;
          if not fl then
            if not Wait2CharWithMarker(char($FF),{ProtocolBaseTB(BaudRate)+APPTIMOUT}CurCoSet.wait,tempnum,temptyp) then
                   tempnum:=proxyNumber+1;
       end;
     end;
    if fl then
           begin

           // подтверждаем
           WriteAckMarker(proxyNumber);
           ComTimer(APPTIMOUT);
           result:=0;
           end;

end;



function TLogikaComPort.Wait2CharWithMarker(wc: char; waitiime: integer;  var num: byte; var typ_: TMarkerMSgT): boolean;
var
  Signaled: DWORD;
  MASK: CARDINAL;
  AsyncPtr: PAsync;
  DCB: TDCB;
  oldParity: byte;
  oldChar: char;
  oldMask: cardinal;
  instr: string;
  tempB: byte;
begin
  try

  result:=false;

  InitAsync(AsyncPtr);

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  oldChar:=DCB.EvtChar;
  DCB.EvtChar:=wc;
  DCB.Parity:=MARKPARITY;
  SetCommState(FHandle, DCB);

  getcommMask(FHandle,oldMask );
  setCommMask(FHandle,oldMask or EV_RXFLAG);

  mask:=EV_RXFLAG ;

  WaitCommEvent(FHandle, mask , @AsyncPtr^.Overlapped);
  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, waitiime);
  result := (Signaled = WAIT_OBJECT_0);
  if result then
    begin

    if (ReadDirect(instr,2,fcomset.wait)=2) then
    begin
     if length(instr)=2 then
       begin

        tempB:=byte(instr[2]);
        num:=getAdrfromMarker(char(tempB));
        typ_:=getTypfromMarker(char(tempB));

       end else
       begin

       typ_:=mmsgNone;
       result:=false;

       end;
     end else result:=false;
    end
  else
  result:=false;
  finally

    setCommMask(FHandle,oldMask);

    GetCommState(FHandle, DCB);
    DCB.DCBlength := SizeOf(DCB);
    DCB.EvtChar:=oldChar;
    DCB.Parity:=oldParity;
    SetCommState(FHandle, DCB);



    DoneAsync(AsyncPtr);

  end;
end;


function TLogikaComPort.WaitAckMarker(num: byte; waitiime: integer): boolean;
var
  Signaled: DWORD;
  MASK: CARDINAL;
  AsyncPtr: PAsync;
  AsyncPtr1: PAsync;
  DCB: TDCB;
  oldParity: byte;
  oldChar: char;
  oldMask: cardinal;
  instr: string;
  tempB: byte;
  BytesTrans: DWORD;
  cnt: DWORD;
  str: String;

begin
  try

  result:=false;
  InitAsync(AsyncPtr);
  InitAsync(AsyncPtr1);
  
  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldParity:=DCB.Parity;
  oldChar:=DCB.EvtChar;
  DCB.EvtChar:=char(num or $60);
  DCB.Parity:=SPACEPARITY;
  SetCommState(FHandle, DCB);

  getcommMask(FHandle,oldMask );
  setCommMask(FHandle,EV_RXFLAG);

  mask:=EV_RXFLAG ;

  WaitCommEvent(FHandle, mask , @AsyncPtr^.Overlapped);
  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, waitiime);

  result:=(Signaled = WAIT_OBJECT_0);

  finally

    GetCommState(FHandle, DCB);
    DCB.DCBlength := SizeOf(DCB);
    DCB.EvtChar:=oldChar;
    DCB.Parity:=oldParity;
    SetCommState(FHandle, DCB);

    setCommMask(FHandle,oldMask);

    DoneAsync(AsyncPtr1);
    DoneAsync(AsyncPtr);

  end;
end;

function  TLogikaComPort.ReadDirectData(var Str: String; Count: DWORD; WaitFor: Boolean): DWORD;
var
  BytesTrans, Signaled: DWORD;
  fl, inbuff, findstart: boolean;
  starttime: TDateTime;
  tempstr: string;
  endstr: string;
  templen, temp,errcount: integer;
  cstemp: TComStat;
  lpErrors: DWORD;
begin
  result:=0;
  Str:='';
  fl:=false;
  errcount:=0;
  inbuff:=false;
  findstart:=false;
  PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR);
  starttime:=incMillisecond(now,fcomset.wait);
  lpErrors:=CE_RXPARITY;
  ClearCommError(FHandle,lpErrors,@cstemp);
  while (((abs(MilliSecondsBetween(now,starttime))>0)
           and (abs(MilliSecondsBetween(now,starttime))<=fcomset.wait)) and
               (not fl)) do
    begin
        setlength(tempstr,1);
        templen:=ReadDirect(tempstr,1,fcomset.wait);
        inbuff:=((templen>0)) and (length(tempstr)>0);
        lpErrors:=0;

        if ClearCommError(FHandle,lpErrors,@cstemp) then
           begin
            if (lpErrors=CE_RXPARITY) then
            begin
              inbuff:=false;
              errcount:=errcount+1;
              if errcount>1 then fl:=true;
            end
           end;
           if inbuff and not fl then
              begin
               if not findstart then
                if byte(tempstr[1])=$10 then
                     findstart:=true;
               if findstart then
               begin
               Str:=str+tempstr[1];
               result:=result+1;
               end;
              end

    end;

  if result>5 then
   begin
    endstr:=char(DLE)+char(ETX);
    temp:=pos(endstr,str);
    if temp>0 then
      begin
        if (length(str)>=(temp+3)) then
          begin
           str:=leftstr(str,temp+3);
           result:=temp+3;
           end
          else result:=0;
      end else result:=0;
   end else result:=0;



end;




function TLogikaComPort.LogikareadStringDirect (slaveNumber: byte; proxyNumber: byte; func: byte; body: string;  maxnum: byte; var res: string): integer;

var
  afunc: byte;
  w_comand: string;
  data, crc_inspect: string;
  len,test: integer;
  oldFlag: Longint;
   DCB: TDCB;
begin
  if not Connected then
    begin
      result:=ERROR_NOCONNECT;
      exit;
    end;

  GetCommState(FHandle, DCB);
  DCB.DCBlength := SizeOf(DCB);
  oldFlag:=DCB.Flags;
  DCB.Flags:=(DCB.Flags and not 2);
  SetCommState(FHandle, DCB);


   try
    PurgeComm(FHandle,PURGE_TXABORT or PURGE_TXCLEAR or PURGE_RXABORT	or PURGE_RXCLEAR);

    begin

    afunc:=AnswerFunc(func);
    res:='';

   result:=CatureMarkerandResponse(slaveNumber,proxyNumber,maxnum);

   // если нет ответа или захват неудачен возвращаем код ошибки
   if result<>0 then
     begin
       WriteMarker(proxyNumber,mmsgRefuse);
       exit;
     end;


  // пишем флаг
    WriteFlag;

   ComTimer(APPTIMOUT);


  w_comand:=char(slaveNumber)+char(proxyNumber)+DLE+ISI+char(func)+body;
  w_comand:=w_comand+CRC16str(w_comand);
  w_comand:=DLE+SOH+w_comand;

  // пишем сообщение
  writeString (w_comand, true);
   FlushFileBuffers(FHandle);
  ComTimer(APPTIMOUT);
  // пишем отказ
  WriteMarkerForse(proxyNumber,mmsgRefuse);
 // WriteMarker(proxyNumber,mmsgRefuse);

  result:=CaptureResponse(slaveNumber, proxyNumber);


  if result<>0 then exit;

  len := ReadDirectData(data, 5700, true);

  end;
  if len<8 then
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

  setlength(data,len);

 // проверка старта ответа д. б. DLE SOH

  if ((data[1]<>DLE) or (data[2]<>SOH)) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      setlength(data,0);
      exit;
    end;

  data:=Rightstr(data,length(data)-2);

   if length(data)<4 then       // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

  crc_inspect:=Rightstr(data,2);
  data:=Leftstr(data,length(data)-2);

  //  провекка контрольной суммы

  if (trim(CRC16str(data))<>trim(crc_inspect)) then
   begin
      result:=ERROR_CRC;

      setlength(data,0);
      exit;
   end;

   // проверка адресов источника и приемника

   if length(data)<4 then         // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

    if ((data[1]<>char(proxyNumber)) or (data[2]<>char(slaveNumber))) then
    begin
      result:=ERROR_ADDRESS;
      setlength(data,0);
    //  ReadString(data, 5700, true);
      PugeCom;
      exit;
    end;

    data:=Rightstr(data,length(data)-2);



    // проверка кода функции

    if length(data)<5 then      // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

    if ((data[1]<>DLE) or (data[2]<>ISI) or (data[3]<>char(afunc))) then
    begin
      result:=ERROR_FUNC;
      setlength(data,0);
     // ReadString(data, 5700, true);
      PugeCom;
      exit;
    end;

    data:=Rightstr(data,length(data)-3);

   // writeString (data, true);

    result:=ANSWER_OK;
    res:=data;
    finally
    //  sleep(10000);
    end;

end;


function TLogikaComPort.LogikareadStringProxy (slaveNumber: byte; proxyNumber: byte; func: byte; body: string; maxnum: byte; var res: string): integer;
var
  afunc: byte;
  w_comand: string;
  data, crc_inspect: string;
  len: integer;
begin
  if not Connected then
    begin
      result:=ERROR_NOCONNECT;
      exit;
    end;
  proxyNumber:=  $80 or proxyNumber;
  afunc:=AnswerFunc(func);
  w_comand:=char(slaveNumber)+char(proxyNumber)+DLE+ISI+char(func)+body;
  w_comand:=w_comand+CRC16str(w_comand);
  w_comand:=DLE+SOH+w_comand;
  writeString (w_comand, true);
  len := ReadString(data, 5700, true);
  if len<8 then
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

  setlength(data,len);

 // проверка старта ответа д. б. DLE SOH

  if ((data[1]<>DLE) or (data[2]<>SOH)) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      setlength(data,0);
      exit;
    end;

  data:=Rightstr(data,length(data)-2);

   if length(data)<4 then       // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

  crc_inspect:=Rightstr(data,2);
  data:=Leftstr(data,length(data)-2);

  //  провекка контрольной суммы

  if (trim(CRC16str(data))<>trim(crc_inspect)) then
   begin
      result:=ERROR_CRC;

      setlength(data,0);
      exit;
   end;

   // проверка адресов источника и приемника

   if length(data)<4 then         // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

    if ((data[1]<>char(proxyNumber)) or (data[2]<>char(slaveNumber))) then
    begin
      result:=ERROR_ADDRESS;
      setlength(data,0);
      ReadString(data, 5700, true);
      PugeCom;
      exit;
    end;

    data:=Rightstr(data,length(data)-2);



    // проверка кода функции

    if length(data)<5 then      // тест длинны
    begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
    end;

    if ((data[1]<>DLE) or (data[2]<>ISI) or (data[3]<>char(afunc))) then
    begin
      result:=ERROR_FUNC;
      setlength(data,0);
      ReadString(data, 5700, true);
      PugeCom;
      exit;
    end;

    data:=Rightstr(data,length(data)-3);

   // writeString (data, true);

    result:=ANSWER_OK;
    res:=data;

end;

function  TLogikaComPort.LogikareadStr (slaveNumber: byte; proxyNumber: byte; func: byte; body: string;  maxnum: byte; var res: string;  direct: boolean =false): integer;
begin
    if direct then
       // result:=LogikareadStringDirect(slaveNumber,proxyNumber,func,body,maxnum,res)
       result:=LogikareadStringProxy(slaveNumber,proxyNumber,func,body,maxnum,res)
    else
       result:=LogikareadStringProxy(slaveNumber,proxyNumber,func,body,maxnum,res);
end;


end.
