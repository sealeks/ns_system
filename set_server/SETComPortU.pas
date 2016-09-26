unit SETComPortU;




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StrUtils,
   MyComms, math, convFunc, DateUtils, ConstDef;

type

  TMarkerMSgT = (mmsgRefuse, mmsgCupture, mmsgAck, mmsgNone );

  TNotifyRead = procedure(const Slavenum: integer) of object;

  TSETComPort = class(TMyComPort)

  private

    function RequestData(slaveNumber: byte; func: byte; body: string; var res: string): integer;


  public



    function  SETreadStr(slaveNumber: byte; func: byte; body: string; var res: string): integer;
    function  SETreadPeriod (slaveNumber: byte; var addr: word; var timeintegr: word; var over: boolean;
                                    var min: word; var hour: word; var day: word; var month: word; var year: word ): integer;
    function  SETfindPeriod (slaveNumber: byte; time: TDateTime; is30min: boolean;isfirst30min: boolean; var res: string): integer;
    function  SETreadBlock (slaveNumber: byte; addr: word; length: word; var res: string ): integer;
    function  RequestArch(slaveNumber: byte; time : TDateTime; num: byte; is30min: boolean; isfirst30min: boolean; var res: real): integer;
  published
    { Published declarations }
  end;

const

  RCURRENT = chr($08);// запрос текущих
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

  ACCOUNT_MEM_SIZE= $10000;


function CRC8(str: string) : string;
function CRC16(str: string) : string;
function ComLerrorStr(vl: integer) : string;
function ActualMemSize(sz: integer; Tabsize: word) : integer;

implementation


function ActualMemSize(sz: integer; TabSize: word) : integer;
begin
   result:=sz - sz mod  TabSize;
end;




// тип из пост-маркера






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




function CRC8(str: string) : string;
var
   i,j: integer;
   crc: byte;
begin
  crc := $FF;
  for i := 1 to length (str) do
  begin
    crc := crc xor ord(str[i]);
        for j := 0 to  8 do
            begin
            if ((crc and $80)=0) then
                 crc := (crc shl 1)  xor $31
            else
                 crc := crc shl 1;
            end;
  end;
  result:=chr(crc);
end;

function CRC16(str: string) : string;
var crc: word;
n,i: integer;
b:byte;
begin
crc := $FFFF;
for i:=1 to length (str) do begin
b:=ord(str[i]);
crc := crc xor b;
for n:=1 to 8 do begin
if (crc and 1)<>0 
then crc:=(crc shr 1) xor $A001
else crc:=crc shr 1;
end;
end;
result:=chr(crc and $ff)+chr(crc shr 8);
end;






function TSETComPort.RequestData(slaveNumber: byte; func: byte; body: string; var res: string): integer;
var
  w_comand: string;
  data, crc_inspect: string;
  len: integer;
  cnt: integer;
begin
   cnt:=4;
   len:=0;

   w_comand:=char(slaveNumber) +  char(func) + body;
   w_comand:=w_comand+CRC16(w_comand);

   while((len=0) and (cnt>0)) do
   begin
   writeString (w_comand, true);
   len := ReadString(data, 2000, true);
   if(len=0)then
     begin
      sleep(100);
      PugeCom();
     end
     else
     break;
   cnt:=cnt-1;
   end;

   if (len<4) then
   begin
      result:=ERROR_NO_ANSWER;
      setlength(data,0);
      exit;
   end;

  setlength(data,len);
  if (data[1]<>char(slaveNumber)) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      sleep(300);
      PugeCom();
      setlength(data,0);
      exit;
    end;

  crc_inspect:=Rightstr(data,2);
  data:=Leftstr(data,length(data)-2);

  //  провекка контрольной суммы

  if (trim(CRC16(data))<>trim(crc_inspect)) then
   begin
      result:=ERROR_CRC;
      sleep(300);
      PugeCom();
      setlength(data,0);
      exit;
   end;

   data:=Rightstr(data,length(data)-1);
   result:=ANSWER_OK;
   res:=data;

end;







function TSETComPort.SETreadPeriod (slaveNumber: byte; var addr: word; var timeintegr: word; var over: boolean;
                                    var min: word; var hour: word; var day: word; var month: word; var year: word ): integer;
var
  body, data: string;
  len: integer;
begin


  result := RequestData(slaveNumber, 1, chr($30) + chr($30) + chr($30) + chr($30) + chr($30) + chr($30), data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;


  result := RequestData(slaveNumber, 8 , char($06) , data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

  if ((length(data)<>2) or (data[1]<>chr(0))) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      setlength(data,0);
      exit;
    end;


    timeintegr:=ord(data[2]);
    setlength(data,0);

    result := RequestData(slaveNumber, 8 , char($04) , data);

    if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

  if (length(data)<>7) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      setlength(data,0);
      exit;
    end;

  over := (ord(data[1]) and $80) <> 0;
  min := NS_hexbyteTobinbyte(ord(data[1]) and $7F);
  hour := NS_hexbyteTobinbyte(ord(data[2]));
  day := NS_hexbyteTobinbyte(ord(data[3]));
  month := NS_hexbyteTobinbyte(ord(data[4]));
  year := NS_hexbyteTobinbyte(ord(data[5]));
  addr := ord(data[6]) * 256 + ord(data[7]);
  addr := ord(data[6]) * 256 + ord(data[7]);

end;






function TSETComPort.SETreadBlock (slaveNumber: byte; addr: word; length: word; var res: string): integer;
var
  body, data: string;
  len: integer;
  addrT, lengthT, endT: word;
begin



  result := RequestData(slaveNumber, 1, chr($30) + chr($30) + chr($30) + chr($30) + chr($30) + chr($30), data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

  lengthT:=60;

  addrT := addr;
  endT := addr + length;


  while (addrT < endT) do
  begin
    if ((addrT + lengthT)> endT) then
      lengthT :=  endT - addrT;
    body := char($03) +  char((($FF00 and addrT) shr 8)) +  char(($FF and addrT)) +  char(($FF and lengthT));

    result := RequestData(slaveNumber, 6 , body , data);

    if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

    res:=res + data;
    addrT := addrT + lengthT;

  end

end;







function TSETComPort.SETfindPeriod (slaveNumber: byte; time: TDateTime; is30min: boolean; isfirst30min: boolean;  var res: string): integer;
var
  body, data, dt1, dt2: string;
  len: integer;
  over: boolean;
  addrF, timeinegrF, minF, hourF, dayF, monthF, yearF, currHeader, aimHeader, TabSize: word;
  hour, day, month, year: word;
  addrE: word;
  timeH: TDateTime;
  chksm: byte;
  delt, actualSize: integer;
begin

  result:= SETreadPeriod (slaveNumber, addrF, timeinegrF, over, minF, hourF, dayF, monthF, yearF);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

  //addrE =

  TabSize:= (60 div timeinegrF + 1)*8;
  currHeader:=  addrF - addrF mod TabSize;



  timeH := EncodeDateTime(yearF+2000, monthF, dayF, hourF, 0, 0, 0);

  delt:= round(((MinutesBetween(timeH, time) * 1.0) / 60.0));
  time:=incSecond(time,10);

  if (((delt<=0) and (not isfirst30min)) or (delt<0)) then
  begin
     result:=ERROR_NO_CORRECTANSWER;
     exit;
  end;
  if (delt=0) then
  begin
     if (minF<30) then
     begin
     result:=ERROR_NO_CORRECTANSWER;
     exit;
     end
  end;

  if (delt*TabSize<=currHeader) then
    begin
       aimHeader:=currHeader - delt*TabSize;
    end
  else
    begin
      actualSize :=  ActualMemSize(ACCOUNT_MEM_SIZE,TabSize);
      if  not (over) then
         begin
            result:=ANSWER_OK;
            setlength(data,0);
            setlength(res,0);
            exit;
         end;

      if (delt*TabSize>actualSize) then
         begin
            result:=ANSWER_OK;
            setlength(data,0);
            setlength(res,0);
            exit;
         end;
      aimHeader:= actualSize -  (delt*TabSize -currHeader);
    end;

  if (delt=0) then
  begin
      TabSize:= (60 div (2*timeinegrF) + 1)*8;
  end;

  result:=SETreadBlock (slaveNumber, aimHeader, TabSize, data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

  chksm:=ord(data[1]) + ord(data[2]) + ord(data[3]) + ord(data[4]) + ord(data[5]) + ord(data[6]);

  if (chksm<>ord(data[7])) then
    begin
      result:=ERROR_NO_CORRECTANSWER;
      exit;
    end;


  hour := NS_hexbyteTobinbyte(ord(data[1])) - HourOfTheDay(time);
  day := NS_hexbyteTobinbyte(ord(data[2])) - DayOfTheMonth(time);
  month := NS_hexbyteTobinbyte(ord(data[3])) -  MonthOfTheYear(time);
  year := NS_hexbyteTobinbyte(ord(data[4]));

  if ( (hour=0) and (day=0) and (month=0)) then
  begin
      res:=Rightstr(data,length(data)-8);
      if (is30min and not(delt=0)) then
        begin
           if (isfirst30min) then
              res:=Leftstr(res,length(res) div 2)
           else
              res:=Rightstr(res,length(res) div 2);
        end;
  end
  else
  begin
     res:='';
  end;
  result:=ANSWER_OK


end;


function TSETComPort.RequestArch(slaveNumber: byte; time : TDateTime; num: byte; is30min: boolean; isfirst30min: boolean; var res: real): integer;
var
  w_comand: string;
  data, crc_inspect: string;
  len, cnt, i , tmp: integer;
  addr: word;

begin

  if not Connected then
    begin
      result:=ERROR_NOCONNECT;
      exit;
    end;
    
    if isfirst30min then
    time:= IncMinute(time,-30)
    else
    time:= IncHour(time,-1);

    result:=SETfindPeriod(slaveNumber, time, is30min, isfirst30min, data);
    if (result<>ANSWER_OK) then
    begin
      exit;
    end;

    if (num>3) then
       num:=3;
    len:= length(data);
    if (len=0) then
    begin
      res:=NAN;
    end
    else
    begin
      cnt:= len div 8;
      res:=0;
      for i:=0 to cnt-1 do
        begin
           tmp:=(ord(data[i*8+1 + num * 2]) and $7F)*256 +  (ord(data[i*8+2+ num * 2]));
           res:=res+tmp;
        end;
    end;
   result:=ANSWER_OK;
end;


function TSETComPort.SETreadStr(slaveNumber: byte; func: byte; body: string; var res: string): integer;
var
  data: string;
  len: integer;
  addr: word;


begin
  if not Connected then
    begin
      result:=ERROR_NOCONNECT;
      exit;
    end;

  result := RequestData(slaveNumber, 1, chr($30) + chr($30) + chr($30) + chr($30) + chr($30) + chr($30), data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;


  result := RequestData(slaveNumber, func , body , data);

  if (result<>ANSWER_OK) then
    begin
      setlength(data,0);
      exit;
    end;

    data[1]:= char( ord(data[1]) and $3F);
    res:=data;

end;


end.
