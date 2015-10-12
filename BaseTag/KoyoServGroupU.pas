unit KoyoServGroupU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,ItemAdapterU, ServerU, InterfaceServerU;

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
    function GetStart(Index: Integer): integer;
    procedure SetStart(Index: Integer; value: integer);
    function GetStart_(): String;
    procedure SetStart_(value: String);
    function GetStop(Index: Integer): integer;
    procedure SetStop(Index: Integer; value: integer);
    function GetStop_(): String;
    procedure SetStop_(value: String);
    function GetPRTTM(Index: Integer): integer;
    procedure SetPRTTM(Index: Integer; value: integer);
    function GetPRTTM_(): String;
    procedure SetPRTTM_(value: String);
    function GetWait(Index: Integer): integer;
    procedure SetWait(Index: Integer; value: integer);
    function GetWait_(): String;
    procedure SetWait_(value: String);
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
    property PRTTM[Index: Integer]: integer read GetPRTTM write SetPRTTM;
    property PRTTM_: String read GetPRTTM_ write SetPRTTM_;
    property Wait[Index: Integer]: integer read GetWait write SetWait;
    property Wait_: String read GetWait_ write SetWait_;
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




function TKoyoServGroup.getCom(i: integer): TCOMSet;
begin
  isCom(Topic[i] ,'COM', com);
  result:=com;
end;



procedure TKoyoServGroup.setMap();
begin

         editor.Strings.Clear;

         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Номер устройства',Slave_);
         setPropertys('Номер com порта',self.ComN_);
         setPropertys('Скорость порта',self.BaudRate_,brSL);
         setPropertys('Бит данных',self.Databit_,dbSL);
         setPropertys('Стоповый бит',self.StopBit_,sbSL);
         setPropertys('Паритетный бит',self.ParityBit_,ptSL);
         setPropertys('FlowControl',self.FlowControl_,getBooleanList());
         setPropertys('FlowControlBeforeSleep',self.FlowControlBeforeSleep_);
         setPropertys('FlowControlAfterSleep',self.FlowControlAfterSleep_);
         setPropertys('ReadInterval',self.ReadInterval_);
         setPropertys('ReadTotalMultiplier',self.ReadTotalMultiplier_);
         setPropertys('ReadTotalConstant',self.ReadTotalConstant_);
         setPropertys('WriteTotalMultiplier',self.WriteTotalMultiplier_);
         setPropertys('WriteTotalConstant',self.WriteTotalConstant_);
         setPropertys('Размер блока данных',self.BlockSize_);
         setPropertys('ReadTimeout',self.ReadTimeout_);
         setPropertys('DirectTimeout',self.DirectTimeout_);
         setPropertys('Попыток чтения',self.TryCount_);
         setPropertys('Начальная минута часового цикла опроса',Start_);
         setPropertys('Конечная минута часового цикла опроса',Stop_);
         setPropertys('PRTTM',PRTTM_);
         setPropertys('Системный таймаут ожидания ответа',Wait_);
         setPropertys('Приложение','ServerKoyo_Service.exe/IServerKoyo_Prj.exe',true);
         setNew();


end;

function TKoyoServGroup.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Slave_:=val;
   2: ComN_:=val;
   3: BaudRate_:=val;
   4: Databit_:=val;
   5: StopBit_:=val;
   6: ParityBit_:=val;
   7: FlowControl_:=val;
   8: FlowControlBeforeSleep_:=val;
   9: FlowControlAfterSleep_:=val;
   10: ReadInterval_:=val;
   11: ReadTotalMultiplier_:=val;
   12: ReadTotalConstant_:=val;
   13: WriteTotalMultiplier_:=val;
   14: WriteTotalConstant_:=val;
   15: BlockSize_:=val;
   16: ReadTimeout_:=val;
   17: DirectTimeout_:=val;
   18: TryCount_:=val;
   19: Start_:=val;
   20: Stop_:=val;
   21: PRTTM_:=val;
   22: Wait_:=val;

   end;


end;


procedure TKoyoServGroup.SetType;
var i: integer;
begin   
  Application_:='DirectKoyoServ';
  Topic_:='com[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;





function TKoyoServGroup.GetComN(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.Com;
end;

procedure TKoyoServGroup.SetComN(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.Com:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetComN_(): String;
var i: integer;
begin
     result:=inttostr(ComN[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ComN[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetComN_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ComN[i]:=strtoint(value);
end;


function TKoyoServGroup.GetBaudRate(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.br;
end;

procedure TKoyoServGroup.SetBaudRate(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.br:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetBaudRate_(): String;
var i: integer;
begin
     result:=brtostr(BaudRate[0]);
        for i:=1 to idscount-1 do
         if (brtostr(BaudRate[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetBaudRate_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BaudRate[i]:=strtobr(value);
end;

function TKoyoServGroup.GetDatabit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.db;
end;

procedure TKoyoServGroup.SetDatabit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.db:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetDatabit_(): String;
var i: integer;
begin
     result:=dbtostr(Databit[0]);
        for i:=1 to idscount-1 do
         if (dbtostr(Databit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetDatabit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Databit[i]:=strtodb(value);
end;


function TKoyoServGroup.GetStopBit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.sb;
end;

procedure TKoyoServGroup.SetStopBit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.sb:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetStopBit_(): String;
var i: integer;
begin
     result:=sbtostr(StopBit[0]);
        for i:=1 to idscount-1 do
         if (sbtostr(StopBit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetStopBit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     StopBit[i]:=strtosb(value);
end;

function TKoyoServGroup.GetParityBit(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.pt;
end;

procedure TKoyoServGroup.SetParityBit(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.pt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetParityBit_(): String;
var i: integer;
begin
     result:=pttostr(ParityBit[0]);
        for i:=1 to idscount-1 do
         if (pttostr(ParityBit[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetParityBit_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ParityBit[i]:=strtopt(value);
end;

function TKoyoServGroup.GetFlowControl(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.flCtrl;
end;

procedure TKoyoServGroup.SetFlowControl(Index: Integer; value: boolean);
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


function TKoyoServGroup.GetFlowControl_(): String;
var i: integer;
begin
     result:=getbooleanstr(FlowControl[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(FlowControl[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetFlowControl_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControl[i]:=getstrboolean(value);
end;


function TKoyoServGroup.GetFlowControlBeforeSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trd;
end;

procedure TKoyoServGroup.SetFlowControlBeforeSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetFlowControlBeforeSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlBeforeSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlBeforeSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetFlowControlBeforeSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlBeforeSleep[i]:=strtoint(value);
end;

function TKoyoServGroup.GetFlowControlAfterSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.red;
end;

procedure TKoyoServGroup.SetFlowControlAfterSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.red:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetFlowControlAfterSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlAfterSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlAfterSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetFlowControlAfterSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlAfterSleep[i]:=strtoint(value);
end;

function TKoyoServGroup.GetReadInterval(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.ri;
end;

procedure TKoyoServGroup.SetReadInterval(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.ri:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetReadInterval_(): String;
var i: integer;
begin
     result:=inttostr(ReadInterval[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadInterval[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetReadInterval_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadInterval[i]:=strtoint(value);
end;


function TKoyoServGroup.GetReadTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtm;
end;

procedure TKoyoServGroup.SetReadTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetReadTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetReadTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalMultiplier[i]:=strtoint(value);
end;

function TKoyoServGroup.GetReadTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtc;
end;

procedure TKoyoServGroup.SetReadTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetReadTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetReadTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalConstant[i]:=strtoint(value);
end;

function TKoyoServGroup.GetWriteTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtm;
end;

procedure TKoyoServGroup.SetWriteTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetWriteTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetWriteTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalMultiplier[i]:=strtoint(value);
end;

function TKoyoServGroup.GetWriteTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtc;
end;

procedure TKoyoServGroup.SetWriteTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetWriteTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetWriteTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalConstant[i]:=strtoint(value);
end;

function TKoyoServGroup.GetBlockSize(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.bs;
end;

procedure TKoyoServGroup.SetBlockSize(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.bs:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetBlockSize_(): String;
var i: integer;
begin
     result:=inttostr(BlockSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(BlockSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetBlockSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BlockSize[i]:=strtoint(value);
end;


function TKoyoServGroup.GetReadTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frt;
end;

procedure TKoyoServGroup.SetReadTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetReadTimeout_(): String;
var i: integer;
begin
     result:=inttostr(ReadTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetReadTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTimeout[i]:=strtoint(value);
end;


function TKoyoServGroup.GetDirectTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frd;
end;

procedure TKoyoServGroup.SetDirectTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetDirectTimeout_(): String;
var i: integer;
begin
     result:=inttostr(DirectTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(DirectTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetDirectTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     DirectTimeout[i]:=strtoint(value);
end;

function TKoyoServGroup.GetTryCount(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trc;
end;

procedure TKoyoServGroup.SetTryCount(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetTryCount_(): String;
var i: integer;
begin
     result:=inttostr(TryCount[0]);
        for i:=1 to idscount-1 do
         if (inttostr(TryCount[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetTryCount_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TryCount[i]:=strtoint(value);
end;

function TKoyoServGroup.GetStart(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstrt;
end;

procedure TKoyoServGroup.SetStart(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstrt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetStart_(): String;
var i: integer;
begin
     result:=inttostr(Start[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Start[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetStart_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Start[i]:=strtoint(value);
end;

function TKoyoServGroup.GetStop(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstp;
end;

procedure TKoyoServGroup.SetStop(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstp:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetStop_(): String;
var i: integer;
begin
     result:=inttostr(Stop[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Stop[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetStop_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Stop[i]:=strtoint(value);
end;

function TKoyoServGroup.GetPRTTM(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.prttm;
end;

procedure TKoyoServGroup.SetPRTTM(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.prttm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetPRTTM_(): String;
var i: integer;
begin
     result:=inttostr(PRTTM[0]);
        for i:=1 to idscount-1 do
         if (inttostr(PRTTM[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetPRTTM_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     PRTTM[i]:=strtoint(value);
end;

function TKoyoServGroup.GetWait(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wait;
end;

procedure TKoyoServGroup.SetWait(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wait:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TKoyoServGroup.GetWait_(): String;
var i: integer;
begin
     result:=inttostr(Wait[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Wait[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TKoyoServGroup.SetWait_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Wait[i]:=strtoint(value);
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

function TKoyoServGroup.getApplication_conf(): string;
begin
    result:='DirectKoyoServ';;
end;

end.
