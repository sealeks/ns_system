unit KoyoServGroupsU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,ItemAdapterU, ServerU, InterfaceServerU;


  type
    TKoyotypeconn = (ktcCom, ktcEth);

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
    function GetProtocol(Index: Integer): integer;
    procedure SetProtocol(Index: Integer; value: integer);
    function GetProtocol_(): String;
    procedure SetProtocol_(value: String);
    function GetTransport(Index: Integer): integer;
    procedure SetTransport(Index: Integer; value: integer);
    function GetTransport_(): String;
    procedure SetTransport_(value: String);


    function getCom(i: integer): TCOMSet;
    function getTopic_conf(val: TCOMSet): string;
    function getTopic_conf_com(val: TCOMSet): string;
    function getTopic_conf_eth(val: TCOMSet): string;
    function getApplication_conf(): string;
    function GetComN(Index: Integer): integer;
    procedure SetComN(Index: Integer; value: integer);
    function GetComN_(): String;
    procedure SetComN_(value: String);
    function GetBaudRate(Index: Integer): integer;
    procedure SetBaudRate(Index: Integer; value: integer);
    function GetBaudRate_(): String;
    procedure SetBaudRate_(value: String);
    function GetDatabit(Index: Integer): integer;
    procedure SetDatabit(Index: Integer; value: integer);
    function GetDatabit_(): String;
    procedure SetDatabit_(value: String);
    function GetStopBit(Index: Integer): integer;
    procedure SetStopBit(Index: Integer; value: integer);
    function GetStopBit_(): String;
    procedure SetStopBit_(value: String);
    function GetParityBit(Index: Integer): integer;
    procedure SetParityBit(Index: Integer; value: integer);
    function GetParityBit_(): String;
    procedure SetParityBit_(value: String);

    function GetFlowControl(Index: Integer): boolean;
    procedure SetFlowControl(Index: Integer; value: boolean);
    function GetFlowControl_(): String;
    procedure SetFlowControl_(value: String);

    function GetFlowControlBeforeSleep(Index: Integer): integer;
    procedure SetFlowControlBeforeSleep(Index: Integer; value: integer);
    function GetFlowControlBeforeSleep_(): String;
    procedure SetFlowControlBeforeSleep_(value: String);
    function GetFlowControlAfterSleep(Index: Integer): integer;
    procedure SetFlowControlAfterSleep(Index: Integer; value: integer);
    function GetFlowControlAfterSleep_(): String;
    procedure SetFlowControlAfterSleep_(value: String);
    function GetReadInterval(Index: Integer): integer;
    procedure SetReadInterval(Index: Integer; value: integer);
    function GetReadInterval_(): String;
    procedure SetReadInterval_(value: String);
    function GetReadTotalMultiplier(Index: Integer): integer;
    procedure SetReadTotalMultiplier(Index: Integer; value: integer);
    function GetReadTotalMultiplier_(): String;
    procedure SetReadTotalMultiplier_(value: String);
    function GetReadTotalConstant(Index: Integer): integer;
    procedure SetReadTotalConstant(Index: Integer; value: integer);
    function GetReadTotalConstant_(): String;
    procedure SetReadTotalConstant_(value: String);
    function GetWriteTotalMultiplier(Index: Integer): integer;
    procedure SetWriteTotalMultiplier(Index: Integer; value: integer);
    function GetWriteTotalMultiplier_(): String;
    procedure SetWriteTotalMultiplier_(value: String);
    function GetWriteTotalConstant(Index: Integer): integer;
    procedure SetWriteTotalConstant(Index: Integer; value: integer);
    function GetWriteTotalConstant_(): String;
    procedure SetWriteTotalConstant_(value: String);
    function GetBlockSize(Index: Integer): integer;
    procedure SetBlockSize(Index: Integer; value: integer);
    function GetBlockSize_(): String;
    procedure SetBlockSize_(value: String);
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
    function GetReport(Index: Integer): boolean;
    procedure SetReport(Index: Integer; value: boolean);
    function GetReport_(): String;
    procedure SetReport_(value: String);
    function GetSyncTime(Index: Integer): boolean;
    procedure SetSyncTime(Index: Integer; value: boolean);
    function GetSyncTime_(): String;
    procedure SetSyncTime_(value: String);
    function GetPRTTM(Index: Integer): integer;
    procedure SetPRTTM(Index: Integer; value: integer);
    function GetPRTTM_(): String;
    procedure SetPRTTM_(value: String);
    function GetWait(Index: Integer): integer;
    procedure SetWait(Index: Integer; value: integer);
    function GetWait_(): String;
    procedure SetWait_(value: String);
    function GetTypeConnect(Index: Integer): TKoyotypeconn;
    procedure SetTypeConnect(Index: Integer; value: TKoyotypeconn);
    function GetTypeConnect_(): String;
    procedure SetTypeConnect_(value: String);
    function getTypeConn(i: integer): TKoyotypeconn;
  public
    procedure SetType; override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    property ComN[Index: Integer]: integer read GetComN write SetComN;
    property ComN_: String read GetComN_ write SetComN_;
    property BaudRate[Index: Integer]: integer read GetBaudRate write SetBaudRate;
    property BaudRate_: String read GetBaudRate_ write SetBaudRate_;
    property Databit[Index: Integer]: integer read GetDatabit write SetDatabit;
    property Databit_: String read GetDatabit_ write SetDatabit_;
    property StopBit[Index: Integer]: integer read GetStopBit write SetStopBit;
    property StopBit_: String read GetStopBit_ write SetStopBit_;
    property ParityBit[Index: Integer]: integer read GetParityBit write SetParityBit;
    property ParityBit_: String read GetParityBit_ write SetParityBit_;

    property FlowControl[Index: Integer]: boolean read GetFlowControl write SetFlowControl;
    property FlowControl_: String read GetFlowControl_ write SetFlowControl_;

    property FlowControlBeforeSleep[Index: Integer]: integer read GetFlowControlBeforeSleep write SetFlowControlBeforeSleep;
    property FlowControlBeforeSleep_: String read GetFlowControlBeforeSleep_ write SetFlowControlBeforeSleep_;
    property FlowControlAfterSleep[Index: Integer]: integer read GetFlowControlAfterSleep write SetFlowControlAfterSleep;
    property FlowControlAfterSleep_: String read GetFlowControlAfterSleep_ write SetFlowControlAfterSleep_;
    property ReadInterval[Index: Integer]: integer read GetReadInterval write SetReadInterval;
    property ReadInterval_: String read GetReadInterval_ write SetReadInterval_;
    property ReadTotalMultiplier[Index: Integer]: integer read GetReadTotalMultiplier write SetReadTotalMultiplier;
    property ReadTotalMultiplier_: String read GetReadTotalMultiplier_ write SetReadTotalMultiplier_;
    property ReadTotalConstant[Index: Integer]: integer read GetReadTotalConstant write SetReadTotalConstant;
    property ReadTotalConstant_: String read GetReadTotalConstant_ write SetReadTotalConstant_;
    property WriteTotalMultiplier[Index: Integer]: integer read GetWriteTotalMultiplier write SetWriteTotalMultiplier;
    property WriteTotalMultiplier_: String read GetWriteTotalMultiplier_ write SetWriteTotalMultiplier_;
    property WriteTotalConstant[Index: Integer]: integer read GetWriteTotalConstant write SetWriteTotalConstant;
    property WriteTotalConstant_: String read GetWriteTotalConstant_ write SetWriteTotalConstant_;
    property BlockSize[Index: Integer]: integer read GetBlockSize write SetBlockSize;
    property BlockSize_: String read GetBlockSize_ write SetBlockSize_;
    property ReadTimeout[Index: Integer]: integer read GetReadTimeout write SetReadTimeout;      //  таймаут на разрыв связи
    property ReadTimeout_: String read GetReadTimeout_ write SetReadTimeout_;
    property DirectTimeout[Index: Integer]: integer read GetDirectTimeout write SetDirectTimeout;
    property DirectTimeout_: String read GetDirectTimeout_ write SetDirectTimeout_;
    property TryCount[Index: Integer]: integer read GetTryCount write SetTryCount;
    property TryCount_: String read GetTryCount_ write SetTryCount_;
    property Report[Index: Integer]: boolean read GetReport write SetReport;
    property Report_: String read GetReport_ write SetReport_;
    property SyncTime[Index: Integer]: boolean read GetSyncTime write SetSyncTime;
    property SyncTime_: String read GetSyncTime_ write SetSyncTime_;
    property PRTTM[Index: Integer]: integer read GetPRTTM write SetPRTTM;
    property PRTTM_: String read GetPRTTM_ write SetPRTTM_;
    property Wait[Index: Integer]: integer read GetWait write SetWait;
    property Wait_: String read GetWait_ write SetWait_;
    property TypeConnect[Index: Integer]: TKoyotypeconn read GetTypeConnect write SetTypeConnect;
    property TypeConnect_: String read GetTypeConnect_ write SetTypeConnect_;

    property Protocol[Index: Integer]: integer read GetProtocol write SetProtocol;
    property Protocol_: String read GetProtocol_ write SetProtocol_;
    property Transport[Index: Integer]: integer read GetTransport write SetTransport;
    property Transport_: String read GetTransport_ write SetTransport_;
    property IP[Index: Integer]: integer read GetIP write SetIP;
    property IP_: String read GetIP_ write SetIP_;
    property Eth[Index: Integer]: int64 read GetEth write SetEth;
    property Eth_: String read GetEth_ write SetEth_;
    property Host[Index: Integer]: string read GetHost write SetHost;
    property Host_: String read GetHost_ write SetHost_;
  end;

implementation




function brtostr(val: integer): string;
begin
 case val of
  110: result:='110';
  300: result:='300';
  600: result:='600';
  1200: result:='1200';
  2400: result:='2400';
  4800: result:='4800';
  14400: result:='14400';
  19200: result:='19200';
  38400: result:='38400';
  56000: result:='56000';
  115200: result:='115200';
  else result:='9600'
 end;
end;

function strtobr(val: string): integer;
begin
  val:=trim(val);
  result:=0;
  if '110'=val then  result:=110;
  if '300'=val then  result:=300;
  if '600'=val then  result:=600;
  if '1200'=val then  result:=1200;
  if '2400'=val then  result:=2400;
  if '4800'=val then  result:=4800;
  if '14400'=val then  result:=14400;
  if '19200'=val then  result:=19200;
  if '38400'=val then  result:=38400;
  if '56000'=val then  result:=56000;
  if '115200'=val then  result:=115200;
  if result=0 then result:=9600;

end;


function brSL(): TStringList;
begin
result:=TStringList.Create;
result.Add('110');
result.Add('300');
result.Add('600');
result.Add('1200');
result.Add('2400');
result.Add('4800');
result.Add('9600');
result.Add('14400');
result.Add('19200');
result.Add('38400');
result.Add('56000');
result.Add('115200');
end;


function TCtostr(val: TKoyotypeconn): string;
begin
 case val of
  ktcCom: result:='RS232';
  ktcEth: result:='Ethernet';
 end;
end;

function strtoTC(val: string): TKoyotypeconn;
begin
 val:=trim(val);
  if 'RS232'=val then  result:=ktcCom;
  if 'ETHERNET'=val then  result:=ktcEth;
end;


function dbTC(): TStringList;
begin
result:=TStringList.Create;
result.Add('RS232');
result.Add('Ethernet');
end;


function dbtostr(val: integer): string;
begin
 case val of
  5: result:='5';
  6: result:='6';
  7: result:='7';

  else result:='8'
 end;
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




function TKoyoServGroups.getCom(i: integer): TCOMSet;
begin
    case getTypeConn(i) of
        ktcCom: isCom(Topic[i] ,'COM', com);
        ktcEth: isCom(Topic[i] ,'ETH', com);
        end;

  result:=com;
end;

function TKoyoServGroups.getTypeConn(i: integer): TKoyotypeconn;
var temp: integer;
    com_: TComset;
begin
  temp:=isCom(Topic[i] ,'COM', com_);
  if ((temp>0) and (com_.Com>-1)) then
  result:=ktcCom else result:=ktcEth;
end;



procedure TKoyoServGroups.setMap();
begin

     case getTypeConn(0) of
        ktcCom:
         begin
         editor.Strings.Clear;
         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Тип соединения',self.TypeConnect_,dbTC);
         setPropertys('Номер устройства',Slave_);
         setPropertys('Номер com порта',self.ComN_);
         setPropertys('Baundrate',self.BaudRate_,brSL);
         setPropertys('Databit',self.Databit_,dbSL);
         setPropertys('Stopbit',self.StopBit_,sbSL);
         setPropertys('Parity',self.ParityBit_,ptSL);
         setPropertys('FlowControl',self.FlowControl_,getBooleanList());
         setPropertys('FlowControlBeforeSleep',self.FlowControlBeforeSleep_);
         setPropertys('FlowControlAfterSleep',self.FlowControlAfterSleep_);
         setPropertys('ReadInterval',self.ReadInterval_);
         setPropertys('ReadTotalMultiplier',self.ReadTotalMultiplier_);
         setPropertys('ReadTotalConstant',self.ReadTotalConstant_);
         setPropertys('WriteTotalMultiplier',self.WriteTotalMultiplier_);
         setPropertys('WriteTotalConstant',self.WriteTotalConstant_);
         setPropertys('Размер блока данных',self.BlockSize_);
         setPropertys('Таймаут индикации разрыва соединения',self.ReadTimeout_);
       //  setPropertys('DirectTimeout',self.DirectTimeout_);
         setPropertys('Попыток чтения',self.TryCount_);
         setPropertys('Менеджер отчетов',Report_,getBooleanList);
         setPropertys('Синхронизация времени конроллера',SyncTime_,getBooleanList);
        // setPropertys('PRTTM',PRTTM_);
         setPropertys('Системный таймаут ожидания ответа',Wait_);

         setPropertys('Приложение','NS_DirectNetIOService.exe/NS_DirectNetIOService_app.exe',true);
         setNew();
         end;

        ktcEth:
         begin
         editor.Strings.Clear;
         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Тип соединения',self.TypeConnect_,dbTC);
         setPropertys('Номер устройства',Slave_);
         setPropertys('Transport',self.Transport_,brtransport);
         setPropertys('Protocol',self.Protocol_,brprotocol);
         setPropertys('IP (опционально)',self.IP_);
         setPropertys('EthAdress (опционально)',self.Eth_);
         setPropertys('HostName (опционально)',self.Host_);
         setPropertys('Размер блока данных',self.BlockSize_);
         setPropertys('Таймаут индикации разрыва соединения',self.ReadTimeout_);
        // setPropertys('DirectTimeout',self.DirectTimeout_);
         setPropertys('Попыток чтения',self.TryCount_);
         setPropertys('Менеджер отчетов',Report_,getBooleanList);
         setPropertys('Синхронизация времени конроллера',SyncTime_,getBooleanList);
         setPropertys('Системный таймаут ожидания ответа',Wait_);

         setPropertys('Приложение','NS_DirectNetIOService.exe/NS_DirectNetIOService_app.exe',true);
         setNew();
         end;
      end;

end;

function TKoyoServGroups.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case getTypeConn(0) of
   ktcCom:

   begin
   case key of
   0: begin Name_:=val;  result:=val; end;
   1: TypeConnect_:=val;
   2: Slave_:=val;
   3: ComN_:=val;
   4: BaudRate_:=val;
   5: Databit_:=val;
   6: StopBit_:=val;
   7: ParityBit_:=val;
   8: FlowControl_:=val;
   9: FlowControlBeforeSleep_:=val;
   10: FlowControlAfterSleep_:=val;
   11: ReadInterval_:=val;
   12: ReadTotalMultiplier_:=val;
   13: ReadTotalConstant_:=val;
   14: WriteTotalMultiplier_:=val;
   15: WriteTotalConstant_:=val;
   16: BlockSize_:=val;
   17: ReadTimeout_:=val;
 //  18: DirectTimeout_:=val;
   18: TryCount_:=val;
   19: Report_:=val;
   20: SyncTime_:=val;
   //22: PRTTM_:=val;
   21: Wait_:=val;

   end;
   end;

   ktcEth:
   begin
     case key of
   0: begin Name_:=val;  result:=val; end;
   1: TypeConnect_:=val;
   2: Slave_:=val;
   3: Transport_:=val;
   4: Protocol_:=val;
   5: IP_:=val;
   6: Eth_:=val;
   7: Host_:=val;
   8: BlockSize_:=val;
   9: ReadTimeout_:=val;
  // 10: DirectTimeout_:=val;
   10: TryCount_:=val;
   11: Report_:=val;
   12: SyncTime_:=val;
   13: Wait_:=val;

   end;
   end
   end;

end;


procedure TKoyoServGroups.SetType;
begin
  case getTypeConn(0) of
        ktcCom: SetTypeCom;
        ktcEth: SetTypeEth;
        end;
end;

procedure TKoyoServGroups.SetTypeCom;
var i: integer;
begin
  Application_:='DirectKoyoServ';
  Topic_:='com[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;

procedure TKoyoServGroups.SetTypeEth;
var i: integer;
begin
  Application_:='DirectKoyoServ';
  Topic_:='eth[rtm3,rtc4,trd0,red0,wtm0]';
end;



function TKoyoServGroups.GetComN(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.Com;
end;

procedure TKoyoServGroups.SetComN(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.Com:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetComN_(): String;
var i: integer;
begin
     result:=inttostr(ComN[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ComN[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetComN_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ComN[i]:=strtoint(value);
end;


function TKoyoServGroups.GetBaudRate(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.br;
end;

procedure TKoyoServGroups.SetBaudRate(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.br:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetBaudRate_(): String;
var i: integer;
begin
     result:=brtostr(BaudRate[0]);
        for i:=1 to idscount-1 do
         if (brtostr(BaudRate[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetBaudRate_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BaudRate[i]:=strtobr(value);
end;

function TKoyoServGroups.GetDatabit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.db;
end;

procedure TKoyoServGroups.SetDatabit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.db:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetDatabit_(): String;
var i: integer;
begin
     result:=dbtostr(Databit[0]);
        for i:=1 to idscount-1 do
         if (dbtostr(Databit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetDatabit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Databit[i]:=strtodb(value);
end;


function TKoyoServGroups.GetStopBit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.sb;
end;

procedure TKoyoServGroups.SetStopBit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.sb:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetStopBit_(): String;
var i: integer;
begin
     result:=sbtostr(StopBit[0]);
        for i:=1 to idscount-1 do
         if (sbtostr(StopBit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetStopBit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     StopBit[i]:=strtosb(value);
end;

function TKoyoServGroups.GetParityBit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.pt;
end;

procedure TKoyoServGroups.SetParityBit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.pt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetParityBit_(): String;
var i: integer;
begin
     result:=pttostr(ParityBit[0]);
        for i:=1 to idscount-1 do
         if (pttostr(ParityBit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetParityBit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ParityBit[i]:=strtopt(value);
end;

function TKoyoServGroups.GetFlowControl(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.flCtrl;
end;

procedure TKoyoServGroups.SetFlowControl(Index: Integer; value: boolean);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     if (value) then
     begin
     if com_.trd=0 then
     com_.trd:=60;
     if com_.red=0 then
     com_.red:=50;
     com_.flCtrl:=true;
     end else
     begin
     com_.trd:=0;
     com_.red:=0;
     com_.flCtrl:=false;
     end;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetFlowControl_(): String;
var i: integer;
begin
     result:=getbooleanstr(FlowControl[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(FlowControl[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetFlowControl_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControl[i]:=getstrboolean(value);
end;


function TKoyoServGroups.GetFlowControlBeforeSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trd;
end;

procedure TKoyoServGroups.SetFlowControlBeforeSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetFlowControlBeforeSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlBeforeSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlBeforeSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetFlowControlBeforeSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlBeforeSleep[i]:=strtoint(value);
end;

function TKoyoServGroups.GetFlowControlAfterSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.red;
end;

procedure TKoyoServGroups.SetFlowControlAfterSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.red:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetFlowControlAfterSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlAfterSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlAfterSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetFlowControlAfterSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlAfterSleep[i]:=strtoint(value);
end;

function TKoyoServGroups.GetReadInterval(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.ri;
end;

procedure TKoyoServGroups.SetReadInterval(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.ri:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetReadInterval_(): String;
var i: integer;
begin
     result:=inttostr(ReadInterval[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadInterval[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetReadInterval_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadInterval[i]:=strtoint(value);
end;


function TKoyoServGroups.GetReadTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtm;
end;

procedure TKoyoServGroups.SetReadTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetReadTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetReadTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalMultiplier[i]:=strtoint(value);
end;

function TKoyoServGroups.GetReadTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtc;
end;

procedure TKoyoServGroups.SetReadTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetReadTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetReadTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalConstant[i]:=strtoint(value);
end;

function TKoyoServGroups.GetWriteTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtm;
end;

procedure TKoyoServGroups.SetWriteTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetWriteTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetWriteTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalMultiplier[i]:=strtoint(value);
end;

function TKoyoServGroups.GetWriteTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtc;
end;

procedure TKoyoServGroups.SetWriteTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetWriteTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetWriteTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalConstant[i]:=strtoint(value);
end;

function TKoyoServGroups.GetBlockSize(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.bs;
end;

procedure TKoyoServGroups.SetBlockSize(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.bs:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetBlockSize_(): String;
var i: integer;
begin
     result:=inttostr(BlockSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(BlockSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetBlockSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BlockSize[i]:=strtoint(value);
end;


function TKoyoServGroups.GetReadTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frt;
end;

procedure TKoyoServGroups.SetReadTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetReadTimeout_(): String;
var i: integer;
begin
     result:=inttostr(ReadTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetReadTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTimeout[i]:=strtoint(value);
end;


function TKoyoServGroups.GetDirectTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frd;
end;

procedure TKoyoServGroups.SetDirectTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetDirectTimeout_(): String;
var i: integer;
begin
     result:=inttostr(DirectTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(DirectTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetDirectTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     DirectTimeout[i]:=strtoint(value);
end;

function TKoyoServGroups.GetTryCount(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trc;
end;

procedure TKoyoServGroups.SetTryCount(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetTryCount_(): String;
var i: integer;
begin
     result:=inttostr(TryCount[0]);
        for i:=1 to idscount-1 do
         if (inttostr(TryCount[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetTryCount_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TryCount[i]:=strtoint(value);
end;

function TKoyoServGroups.GetReport(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= (com.tstrt=1);
end;

procedure TKoyoServGroups.SetReport(Index: Integer; value: boolean);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     if value then com_.tstrt:=1 else com_.tstrt:=0;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetReport_(): String;
var i: integer;
begin
     result:=getbooleanstr(Report[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(Report[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetReport_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Report[i]:=getstrboolean(value);
end;

function TKoyoServGroups.GetSyncTime(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= (com.tstp=60);
end;

procedure TKoyoServGroups.SetSyncTime(Index: Integer; value: boolean);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     if value then com_.tstp:=60 else com_.tstp:=61;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetSyncTime_(): String;
var i: integer;
begin
     result:=getbooleanstr(SyncTime[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(SyncTime[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetSyncTime_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     SyncTime[i]:=getstrboolean(value);
end;

function TKoyoServGroups.GetPRTTM(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.prttm;
end;

procedure TKoyoServGroups.SetPRTTM(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.prttm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetPRTTM_(): String;
var i: integer;
begin
     result:=inttostr(PRTTM[0]);
        for i:=1 to idscount-1 do
         if (inttostr(PRTTM[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetPRTTM_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     PRTTM[i]:=strtoint(value);
end;

function TKoyoServGroups.GetWait(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wait;
end;

procedure TKoyoServGroups.SetWait(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wait:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetWait_(): String;
var i: integer;
begin
     result:=inttostr(Wait[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Wait[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetWait_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Wait[i]:=strtoint(value);
end;

function TKoyoServGroups.GetTypeConnect(Index: Integer): TKoyotypeconn;
var int_temp: integer;
begin
    result:= GetTypeConn(Index);
end;

procedure TKoyoServGroups.SetTypeConnect(Index: Integer; value: TKoyotypeconn);
var com_: TCOMSet;
begin
     if (GetTypeConnect(Index)<>value) then
       begin
          case value of
              ktcCom: SetTypeCom;
              ktcEth: SetTypeEth;
           end;
       end;
end;


function TKoyoServGroups.GetTypeConnect_(): String;
var i: integer;
begin
     result:=TCtostr(TypeConnect[0]);
        for i:=1 to idscount-1 do
         if (TCtostr(TypeConnect[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetTypeConnect_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TypeConnect[i]:=strtoTC(value);
end;

function TKoyoServGroups.getTopic_conf_com(val: TCOMSet): string;
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
     if val.Com>255 then val.Com:=255;
     if val.Com<1 then val.Com:=1;
     if not((val.br=110) or (val.br=300) or (val.br=600) or (val.br=1200) or (val.br=2400) or
        (val.br=4800) or (val.br=9600) or (val.br=14400) or (val.br=19200) or (val.br=38400)
        or (val.br=56000) or (val.br=115200)) then val.br:=9600;
     if not((val.db=5) or (val.db=6) or (val.DB=7) or (val.DB=8)) then val.DB:=8;
     if not((val.sb=3) or (val.sb=2) or (val.sb=1) ) then val.sb:=1;
     if not((val.pt=1) or (val.pt=2) or (val.pt=3) or (val.pt=4)) then val.pt:=0;

     if val.Com<1 then val.Com:=1;
     result:='com[';
     if val.Com<1 then val.Com:=1;
     if (val.Com>0) then result:=result+'com'+inttostr(val.Com);
     if (val.br<>9600) then  result:=result+',br'+inttostr(val.br);
     if (val.db<>7) then  result:=result+',bd'+inttostr(val.db);
     if (val.sb<>1) then  result:=result+',sb'+inttostr(val.sb);
     if (val.pt<>0) then  result:=result+',pt'+inttostr(val.pt);
     if (val.trd<>60) then  result:=result+',trd'+inttostr(val.trd);
     if (val.red<>50) then  result:=result+',red'+inttostr(val.red);
     if (val.ri<>100) then  result:=result+',ri'+inttostr(val.ri);
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
     if (val.prttm<>500) then  result:=result+',prttm'+inttostr(val.prttm);
     if (val.wait<>3000) then  result:=result+',wait'+inttostr(val.wait);
     result:=result+']';
end;

function TKoyoServGroups.getTopic_conf_eth(val: TCOMSet): string;
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

function TKoyoServGroups.getTopic_conf(val: TCOMSet): string;
begin
     case getTypeConn(0) of
        ktcCom: result:=getTopic_conf_com(val);
        ktcEth: result:=getTopic_conf_eth(val);
        end;
end;

function TKoyoServGroups.getApplication_conf(): string;
begin
    result:='DirectKoyoServ';;
end;


function TKoyoServGroups.GetProtocol(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtm;
end;

procedure TKoyoServGroups.SetProtocol(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetProtocol_(): String;
var i: integer;
begin
     result:=protocoltostr(Protocol[0]);
        for i:=1 to idscount-1 do
         if (protocoltostr(Protocol[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetProtocol_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Protocol[i]:=strtoprotocol(value);
end;

function TKoyoServGroups.GetTransport(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtc;
end;

procedure TKoyoServGroups.SetTransport(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetTransport_(): String;
var i: integer;
begin
     result:=transporttostr(Transport[0]);
        for i:=1 to idscount-1 do
         if (transporttostr(Transport[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetTransport_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Transport[i]:=strtotransport(value);
end;

function TKoyoServGroups.GetIP(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtm;
end;

procedure TKoyoServGroups.SetIP(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetIP_(): String;
var i: integer;
begin
     result:=iptostr(IP[0]);
        for i:=1 to idscount-1 do
         if (iptostr(IP[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetIP_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     IP[i]:=strtoip(value);
end;

function TKoyoServGroups.GetEth(Index: Integer): int64;
var int_temp: integer;
begin
    getCom(Index);
    result:=com.trd;
    result:= ((result shl 24) and $FFFFFF000000) + (com.red and $FFFFFF);
end;

procedure TKoyoServGroups.SetEth(Index: Integer; value: int64);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trd:=(value and $FFFFFF000000) shr 24;
     com_.red:=(value and $FFFFFF);
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetEth_(): String;
var i: integer;
begin
     result:=ethtostr(Eth[0]);
        for i:=1 to idscount-1 do
         if (ethtostr(Eth[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetEth_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Eth[i]:=strtoeth(value);
end;

function TKoyoServGroups.GetHost(Index: Integer): string;
var int_temp: integer;
begin
    getCom(Index);
    result:=com.name;

end;

procedure TKoyoServGroups.SetHost(Index: Integer; value: string);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.name:=value;

     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroups.GetHost_(): String;
var i: integer;
begin
     result:=Host[0];
        for i:=1 to idscount-1 do
         if (Host[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroups.SetHost_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Host[i]:=value;
end;

end.
 