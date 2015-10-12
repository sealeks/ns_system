unit KoyoEthServGroupU;



interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,ItemAdapterU, ServerU, InterfaceServerU;

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







    function GetProtocol(Index: Integer): integer;
    procedure SetProtocol(Index: Integer; value: integer);
    function GetProtocol_(): String;
    procedure SetProtocol_(value: String);
    function GetTransport(Index: Integer): integer;
    procedure SetTransport(Index: Integer; value: integer);
    function GetTransport_(): String;
    procedure SetTransport_(value: String);

    function GetBlockSize(Index: Integer): integer;
    procedure SetBlockSize(Index: Integer; value: integer);
    function GetBlockSize_(): String;
    procedure SetBlockSize_(value: String);

    function GetIP(Index: Integer): integer;
    procedure SetIP(Index: Integer; value: integer);
    function GetIP_(): String;
    procedure SetIP_(value: String);

    function GetEth(Index: Integer): int64;
    procedure SetEth(Index: Integer; value: int64);
    function GetEth_(): String;
    procedure SetEth_(value: String);

    function GetHost(Index: Integer): string;
    procedure SetHost(Index: Integer; value: string);
    function GetHost_(): String;
    procedure SetHost_(value: String);

    function GetReadTimeout(Index: Integer): integer;
    procedure SetReadTimeout(Index: Integer; value: integer);
    function GetReadTimeout_(): String;
    procedure SetReadTimeout_(value: String);
    function GetDirectTimeout(Index: Integer): integer;
    procedure SetDirectTimeout(Index: Integer; value: integer);
    function GetDirectTimeout_(): String;
    procedure SetDirectTimeout_(value: String);
    function GetTryCount(Index: Integer): integer;
    procedure SetTryCount(Index: Integer; value: integer);
    function GetTryCount_(): String;
    procedure SetTryCount_(value: String);
    function GetStart(Index: Integer): integer;
    procedure SetStart(Index: Integer; value: integer);
    function GetStart_(): String;
    procedure SetStart_(value: String);
    function GetStop(Index: Integer): integer;
    procedure SetStop(Index: Integer; value: integer);
    function GetStop_(): String;
    procedure SetStop_(value: String);

    function GetWait(Index: Integer): integer;
    procedure SetWait(Index: Integer; value: integer);
    function GetWait_(): String;
    procedure SetWait_(value: String);
  public
    procedure SetType; override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;

    property Protocol[Index: Integer]: integer read GetProtocol write SetProtocol;
    property Protocol_: String read GetProtocol_ write SetProtocol_;
    property Transport[Index: Integer]: integer read GetTransport write SetTransport;
    property Transport_: String read GetTransport_ write SetTransport_;

    property BlockSize[Index: Integer]: integer read GetBlockSize write SetBlockSize;
    property BlockSize_: String read GetBlockSize_ write SetBlockSize_;
    property IP[Index: Integer]: integer read GetIP write SetIP;
    property IP_: String read GetIP_ write SetIP_;
    property Eth[Index: Integer]: int64 read GetEth write SetEth;
    property Eth_: String read GetEth_ write SetEth_;
    property Host[Index: Integer]: string read GetHost write SetHost;
    property Host_: String read GetHost_ write SetHost_;
    property ReadTimeout[Index: Integer]: integer read GetReadTimeout write SetReadTimeout;
    property ReadTimeout_: String read GetReadTimeout_ write SetReadTimeout_;
    property DirectTimeout[Index: Integer]: integer read GetDirectTimeout write SetDirectTimeout;
    property DirectTimeout_: String read GetDirectTimeout_ write SetDirectTimeout_;
    property TryCount[Index: Integer]: integer read GetTryCount write SetTryCount;
    property TryCount_: String read GetTryCount_ write SetTryCount_;
    property Start[Index: Integer]: integer read GetStart write SetStart;
    property Start_: String read GetStart_ write SetStart_;
    property Stop[Index: Integer]: integer read GetStop write SetStop;
    property Stop_: String read GetStop_ write SetStop_;

    property Wait[Index: Integer]: integer read GetWait write SetWait;
    property Wait_: String read GetWait_ write SetWait_;
  end;

implementation




function protocoltostr(val: integer): string;
begin
 case val of
  1: result:='HOST';
  2: result:='IPX';
  3: result:='IP';
  else result:='NODEF'
 end;
end;

function strtoprotocol(val: string): integer;
begin
  val:=trim(val);
  result:=3;
  if 'HOST'=val then  result:=1;
  if 'IPX'=val then  result:=2;
  if 'IP'=val then  result:=3;
end;


function brProtocol(): TStringList;
begin
result:=TStringList.Create;
result.Add('IP');
result.Add('HOST');
result.Add('IPX');

end;


function transporttostr(val: integer): string;
begin
 case val of
  1: result:='HOST';
  2: result:='IPX';
  4: result:='WINSOCK';
  else result:='NODEF'
 end;
end;

function strtotransport(val: string): integer;
begin
  val:=trim(val);
  result:=3;
  if 'HOST'=val then  result:=1;
  if 'IPX'=val then  result:=2;
  if 'WINSOCK'=val then  result:=4;
end;


function brtransport(): TStringList;
begin
result:=TStringList.Create;
result.Add('WINSOCK');
result.Add('HOST');
result.Add('IPX');

end;

function iptostr(val: integer): string;
var a1,a2,a3,a4: byte;
begin
result:='';
if val=0 then exit;
a1:=$ff and val;
a2:=$ff and (val shr 8);
a3:=$ff and (val shr 16);
a4:=$ff and (val shr 24);
result:=format('%3u.%3u.%3u.%3u',[a4,a3,a2,a1]);
end;



function strtoip(val: string): integer;
var a: array[0..3] of byte;
    i,j: integer;
    val_: string;
begin
a[0]:=0; a[1]:=0; a[2]:=0; a[3]:=0;
j:=0;
result:=0;
if (trim(val)='') then exit;
try
while ((pos('.',val)>0) and (j<4)) do
  begin
    val_:=Leftstr(val,pos('.',val)-1);
    val:=Rightstr(val,length(val)-pos('.',val));
    a[3-j]:=strtointdef(trim(val_),0);
    j:=j+1;
  end;
  val:=trim(val);
  a[3-j]:=strtointdef(trim(val),0);
except
end;
 result:=0;
 for i:=3 downto 0 do
 result:=(result shl 8)+a[i];
end;

function Ethtostr_(val2,val1: integer): string;
var a1,a2,a3,a4,a5,a6: byte;
begin
a1:=$ff and val1;
a2:=$ff and (val1 shr 8);
a3:=$ff and (val1 shr 16);
a4:=$ff and val2;
a5:=$ff and (val2 shr 8);
a6:=$ff and (val2 shr 16);
result:=format('%2x:%2x:%2x:%2x:%2x:%2x',[a6,a5,a4,a3,a2,a1]);
end;

function StrtoEth(val: string): int64;
function HexToInt(Text: String): Integer;
var i: integer;
begin
  result:=0;
  Text:=trim(uppercase(Text));
  for i:=1 to  length(Text) do
   case Text[i] of
    '0': result:=result shl 4 + 0;
    '1': result:=result shl 4 + 1;
    '2': result:=result shl 4 + 2;
    '3': result:=result shl 4 + 3;
    '4': result:=result shl 4 + 4;
    '5': result:=result shl 4 + 5;
    '6': result:=result shl 4 + 6;
    '7': result:=result shl 4 + 7;
    '8': result:=result shl 4 + 8;
    '9': result:=result shl 4 + 9;
    'A': result:=result shl 4 + 10;
    'B': result:=result shl 4 + 11;
    'C': result:=result shl 4 + 12;
    'D': result:=result shl 4 + 13;
    'E': result:=result shl 4 + 14;
    'F': result:=result shl 4 + 15;
    end;
end;
 var a: array[0..5] of byte;
    i,j: integer;
    val_: string;
   // valtemp: Int64;
begin
result:=0;
if trim(val)='' then exit;
a[0]:=0; a[1]:=0; a[2]:=0; a[3]:=0; a[4]:=0; a[5]:=0;
j:=0;
try
while ((pos(':',val)>0) and (j<6)) do
  begin
    val_:=Leftstr(val,pos(':',val)-1);
    val:=Rightstr(val,length(val)-pos(':',val));
    a[5-j]:=HexToInt(trim(val_));
    j:=j+1;
  end;
  val:=trim(val);
  a[5-j]:=HexToInt(trim(val));
except
end;
 result:=0;
 for i:=5 downto 0 do
 result:=(result shl 8)+a[i];
end;


function Ethtostr(val: int64): string;
begin
   result:='';
   if val=0 then exit;
   result:=Ethtostr_((val and $FFFFFF000000) shr 24,(val and $FFFFFF));
end;









function strtodb(val: string): integer;
begin
 val:=trim(val);
  result:=0;
  if '5'=val then  result:=5;
  if '6'=val then  result:=6;
  if '7'=val then  result:=7;

  if result=0 then result:=8;

end;


function dbSL(): TStringList;
begin
result:=TStringList.Create;
result.Add('5');
result.Add('6');
result.Add('7');
result.Add('8');
end;


function sbtostr(val: integer): string;
begin
 case val of
  3: result:='1.5';
  2: result:='2';
  else result:='1'
 end;
end;

function strtosb(val: string): integer;
begin
  val:=trim(val);
  result:=0;
  if '1.5'=val then  result:=3;
  if '2'=val then  result:=2;
  if result=0 then result:=1;

end;


function sbSL(): TStringList;
begin
result:=TStringList.Create;
result.Add('1');
result.Add('1.5');
result.Add('2');
end;


function pttostr(val: integer): string;
begin
 case val of
  1: result:='Odd';
  2: result:='Even';
  3: result:='Mark';
  4: result:='Space';
  else result:='None'
 end;
end;

function strtopt(val: string): integer;
begin
 val:=Uppercase(trim(val));
  result:=0;
  if 'ODD'=val then  result:=1;
  if 'EVEN'=val then  result:=2;
  if 'MARK'=val then  result:=3;
  if 'SPACE'=val then  result:=4;


end;


function ptSL(): TStringList;
begin
result:=TStringList.Create;
result.Add('Odd');
result.Add('Even');
result.Add('Mark');
result.Add('Space');
result.Add('None');
end;




function TKoyoEthServGroup.getCom(i: integer): TCOMSet;
begin
  isCom(Topic[i] ,'ETH', com);
  result:=com;
end;



procedure TKoyoEthServGroup.setMap();
begin

         editor.Strings.Clear;

         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Номер устройства',Slave_);
         setPropertys('Transport',self.Transport_,brtransport);
         setPropertys('Protocol',self.Protocol_,brprotocol);
         setPropertys('IP (опционально)',self.IP_);
         setPropertys('EthAdress (опционально)',self.Eth_);
         setPropertys('HostName (опционально)',self.Host_);
         setPropertys('Размер блока данных',self.BlockSize_);
         setPropertys('ReadTimeout',self.ReadTimeout_);
         setPropertys('DirectTimeout',self.DirectTimeout_);
         setPropertys('Попыток чтения',self.TryCount_);
         setPropertys('Начальная минута часового цикла опроса',Start_);
         setPropertys('Конечная минута часового цикла опроса',Stop_);
         setPropertys('Системный таймаут ожидания ответа',Wait_);
         setPropertys('Приложение','ServerKoyo_Service.exe/IServerKoyo_Prj.exe',true);
         setNew();


end;

function TKoyoEthServGroup.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Slave_:=val;
   2: Transport_:=val;
   3: Protocol_:=val;
   4: IP_:=val;
   5: Eth_:=val;
   6: Host_:=val;
   7: BlockSize_:=val;
   8: DirectTimeout_:=val;
   9: TryCount_:=val;
   10: Start_:=val;
   11: Stop_:=val;
   12: Wait_:=val;

   end;


end;


procedure TKoyoEthServGroup.SetType;
var i: integer;
begin
  Application_:='DirectKoyoServ';
  Topic_:='eth[rtm3,rtc4,trd0,red0,wtm0]';
end;



function TKoyoEthServGroup.GetProtocol(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtm;
end;

procedure TKoyoEthServGroup.SetProtocol(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetProtocol_(): String;
var i: integer;
begin
     result:=protocoltostr(Protocol[0]);
        for i:=1 to idscount-1 do
         if (protocoltostr(Protocol[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetProtocol_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Protocol[i]:=strtoprotocol(value);
end;

function TKoyoEthServGroup.GetTransport(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtc;
end;

procedure TKoyoEthServGroup.SetTransport(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetTransport_(): String;
var i: integer;
begin
     result:=transporttostr(Transport[0]);
        for i:=1 to idscount-1 do
         if (transporttostr(Transport[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetTransport_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Transport[i]:=strtotransport(value);
end;



function TKoyoEthServGroup.GetBlockSize(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.bs;
end;

procedure TKoyoEthServGroup.SetBlockSize(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.bs:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetBlockSize_(): String;
var i: integer;
begin
     result:=inttostr(BlockSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(BlockSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetBlockSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BlockSize[i]:=strtoint(value);
end;

function TKoyoEthServGroup.GetIP(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtm;
end;

procedure TKoyoEthServGroup.SetIP(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetIP_(): String;
var i: integer;
begin
     result:=iptostr(IP[0]);
        for i:=1 to idscount-1 do
         if (iptostr(IP[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetIP_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     IP[i]:=strtoip(value);
end;

function TKoyoEthServGroup.GetEth(Index: Integer): int64;
var int_temp: integer;
begin
    getCom(Index);
    result:=com.trd;
    result:= ((result shl 24) and $FFFFFF000000) + (com.red and $FFFFFF);
end;

procedure TKoyoEthServGroup.SetEth(Index: Integer; value: int64);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trd:=(value and $FFFFFF000000) shr 24;
     com_.red:=(value and $FFFFFF);
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetEth_(): String;
var i: integer;
begin
     result:=ethtostr(Eth[0]);
        for i:=1 to idscount-1 do
         if (ethtostr(Eth[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetEth_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Eth[i]:=strtoeth(value);
end;

function TKoyoEthServGroup.GetHost(Index: Integer): string;
var int_temp: integer;
begin
    getCom(Index);
    result:=com.name;

end;

procedure TKoyoEthServGroup.SetHost(Index: Integer; value: string);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.name:=value;

     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetHost_(): String;
var i: integer;
begin
     result:=Host[0];
        for i:=1 to idscount-1 do
         if (Host[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetHost_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Host[i]:=value;
end;


function TKoyoEthServGroup.GetReadTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frt;
end;

procedure TKoyoEthServGroup.SetReadTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetReadTimeout_(): String;
var i: integer;
begin
     result:=inttostr(ReadTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetReadTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTimeout[i]:=strtoint(value);
end;


function TKoyoEthServGroup.GetDirectTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frd;
end;

procedure TKoyoEthServGroup.SetDirectTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetDirectTimeout_(): String;
var i: integer;
begin
     result:=inttostr(DirectTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(DirectTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetDirectTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     DirectTimeout[i]:=strtoint(value);
end;

function TKoyoEthServGroup.GetTryCount(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trc;
end;

procedure TKoyoEthServGroup.SetTryCount(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetTryCount_(): String;
var i: integer;
begin
     result:=inttostr(TryCount[0]);
        for i:=1 to idscount-1 do
         if (inttostr(TryCount[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetTryCount_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TryCount[i]:=strtoint(value);
end;

function TKoyoEthServGroup.GetStart(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstrt;
end;

procedure TKoyoEthServGroup.SetStart(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstrt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetStart_(): String;
var i: integer;
begin
     result:=inttostr(Start[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Start[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetStart_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Start[i]:=strtoint(value);
end;

function TKoyoEthServGroup.GetStop(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstp;
end;

procedure TKoyoEthServGroup.SetStop(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstp:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetStop_(): String;
var i: integer;
begin
     result:=inttostr(Stop[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Stop[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetStop_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Stop[i]:=strtoint(value);
end;


function TKoyoEthServGroup.GetWait(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wait;
end;

procedure TKoyoEthServGroup.SetWait(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wait:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoEthServGroup.GetWait_(): String;
var i: integer;
begin
     result:=inttostr(Wait[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Wait[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoEthServGroup.SetWait_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Wait[i]:=strtoint(value);
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
     if not((val.rtm=3) or (val.rtm=2) or (val.rtm=1) ) then val.sb:=3;
     if not((val.rtc=1) or (val.rtc=2) or (val.rtc=4)) then val.rtc:=4;

     if val.Com<1 then val.Com:=1;
     result:='eth[';
     if val.Com<1 then val.Com:=1;
     if (val.Com>0) then result:=result+'com'+inttostr(val.Com);
     result:=result+',trd'+inttostr(val.trd);
     result:=result+',red'+inttostr(val.red);
     if (val.rtm<>3000) then  result:=result+',rtm'+inttostr(val.rtm);
     if (val.rtc<>3000) then  result:=result+',rtc'+inttostr(val.rtc);
     if (val.wtm<>3000) then  result:=result+',wtm'+inttostr(val.wtm);
     if (val.wtc<>3000) then  result:=result+',wtc'+inttostr(val.wtc);
     if (val.bs<>64) then  result:=result+',bs'+inttostr(val.bs);
     if (val.frt<>60) then  result:=result+',frt'+inttostr(val.frt);
     if (val.frd<>60) then  result:=result+',frd'+inttostr(val.frd);
     if (val.trc<>3) then  result:=result+',trc'+inttostr(val.trc);
     if (val.tstrt>0) then  result:=result+',tstrt'+inttostr(val.tstrt);
     if (val.tstp<61) then  result:=result+',tstp'+inttostr(val.tstp);
     if (val.wait<>3000) then  result:=result+',wait'+inttostr(val.wait);
     if (trim(val.name)<>'') then  result:=result+',name'+val.name;
     result:=result+']';
end;

function TKoyoEthServGroup.getApplication_conf(): string;
begin
    result:='DirectKoyoServ';;
end;

end.
