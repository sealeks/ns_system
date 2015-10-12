unit SETServGroupU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,ItemAdapterU, SETClasses, InterfaceServerU;

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
  TSETServGroup = class(TGroupWraper)
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
    function GetMaxAddr(Index: Integer): integer;
    procedure SetMaxAddr(Index: Integer; value: integer);
    function GetMaxAddr_(): String;
    procedure SetMaxAddr_(value: String);
    function GetConnType(Index: Integer): integer;
    procedure SetConnType(Index: Integer; value: integer);
    function GetConnType_(): String;
    procedure SetConnType_(value: String);
    function GetArchBlockSize(Index: Integer): integer;
    procedure SetArchBlockSize(Index: Integer; value: integer);
    function GetArchBlockSize_(): String;
    procedure SetArchBlockSize_(value: String);

    function GetFlowControl(Index: Integer): boolean;
    procedure SetFlowControl(Index: Integer; value: boolean);
    function GetFlowControl_(): String;
    procedure SetFlowControl_(value: String);
    function GetSyncTime(Index: Integer): boolean;
    procedure SetSyncTime(Index: Integer; value: boolean);
    function GetSyncTime_(): String;
    procedure SetSyncTime_(value: String);
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
    function GetProxy(Index: Integer): integer;
    procedure SetProxy(Index: Integer; value: integer);
    function GetProxy_(): String;
    procedure SetProxy_(value: String);
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
    property MaxAddr[Index: Integer]: integer read GetMaxAddr write SetMaxAddr;
    property MaxAddr_: String read GetMaxAddr_ write SetMaxAddr_;
    property ConnType[Index: Integer]: integer read GetConnType write SetConnType;
    property ConnType_: String read GetConnType_ write SetConnType_;
    property ArchBlockSize[Index: Integer]: integer read GetArchBlockSize write SetArchBlockSize;
    property ArchBlockSize_: String read GetArchBlockSize_ write SetArchBlockSize_;

    property FlowControl[Index: Integer]: boolean read GetFlowControl write SetFlowControl;
    property FlowControl_: String read GetFlowControl_ write SetFlowControl_;
    property SyncTime[Index: Integer]: boolean read GetSyncTime write SetSyncTime;
    property SyncTime_: String read GetSyncTime_ write SetSyncTime_;
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
    property Proxy[Index: Integer]: integer read GetProxy write SetProxy;
    property Proxy_: String read GetProxy_ write SetProxy_;
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

function cttostr(val: integer): string;
begin
 case val of
  0: result:='прямое';
  else result:='адаптер'
 end;
end;

function strtoct(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
  result:=0;
  if 'АДАПТЕР'=val then  result:=1;
end;


function dbCT(): TStringList;
begin
result:=TStringList.Create;
result.Add('прямое');
result.Add('адаптер');
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




function TSETServGroup.getCom(i: integer): TCOMSet;
begin
  isCom(Topic[i] ,'COM', com);
  result:=com;
end;



procedure TSETServGroup.setMap();
begin

         editor.Strings.Clear;

         if (getCount=1) then setPropertys('Имя',GetName_);
         setPropertys('Номер устройства',Slave_);
         //setPropertys('Номер посредника',self.Proxy_);
        // setPropertys('Максимальный номер в сети',self.MaxAddr_);
         //setPropertys('Тип подключения',self.ConnType_,dbCT);
         setPropertys('Номер com порта',self.ComN_);
         setPropertys('Скорость порта',self.BaudRate_,brSL);
       //  setPropertys('Бит данных',self.Databit_,dbSL);
       //  setPropertys('Стоповый бит',self.StopBit_,sbSL);
       //  setPropertys('Паритетный бит',self.ParityBit_,ptSL);
       //  setPropertys('FlowControl',self.FlowControl_,getBooleanList());
       //  setPropertys('FlowControlBeforeSleep',self.FlowControlBeforeSleep_);
       //  setPropertys('FlowControlAfterSleep',self.FlowControlAfterSleep_);
         setPropertys('ReadInterval',self.ReadInterval_);
         setPropertys('ReadTotalMultiplier',self.ReadTotalMultiplier_);
         setPropertys('ReadTotalConstant',self.ReadTotalConstant_);
         setPropertys('WriteTotalMultiplier',self.WriteTotalMultiplier_);
         setPropertys('WriteTotalConstant',self.WriteTotalConstant_);
         setPropertys('Размер блока данных',self.BlockSize_);
         setPropertys('Размер архивного блока данных',self.ArchBlockSize_);
         setPropertys('Таймаут на идикацию разрыва связи',self.ReadTimeout_);

         setPropertys('Попыток чтения',self.TryCount_);
       //  setPropertys('Начальная минута часового цикла опроса',Start_);
       //  setPropertys('Конечная минута часового цикла опроса',Stop_);
        // setPropertys('PRTTM',PRTTM_);
         setPropertys('Системный таймаут ожидания ответа',Wait_);
         setPropertys('Синхронизация времени',SyncTime_,getBooleanList);
         setPropertys('Приложение','NS_SETIOServ.exe/NS_SETIOServ_app.exe',true);
         setNew();


end;

function TSETServGroup.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Slave_:=val;
   2: ComN_:=val;
   3: BaudRate_:=val;
  // 4: Databit_:=val;
  // 5: StopBit_:=val;
  // 6: ParityBit_:=val;
  // 7: FlowControl_:=val;
  // 8: FlowControlBeforeSleep_:=val;
 //  9: FlowControlAfterSleep_:=val;
   4: ReadInterval_:=val;
   5: ReadTotalMultiplier_:=val;
   6: ReadTotalConstant_:=val;
   7: WriteTotalMultiplier_:=val;
   8: WriteTotalConstant_:=val;
   9: BlockSize_:=val;
   10: ArchBlockSize_:=val;
   11: ReadTimeout_:=val;
   12: TryCount_:=val;
  // 13: Start_:=val;
  // 14: Stop_:=val;
  // 16: PRTTM_:=val;
   13: Wait_:=val;
   14: SyncTime_:=val;
   end;


end;


procedure TSETServGroup.SetType;
var i: integer;
begin   
  Application_:='SETServ';
  Topic_:='com[com1,bd8,pt2,trd0,red0,ri300,rtm800,rtc800,wtm800,wtc800]';
end;


function TSETServGroup.GetSyncTime(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= (com.tstp=60);
end;

procedure TSETServGroup.SetSyncTime(Index: Integer; value: boolean);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     if value then com_.tstp:=60 else com_.tstp:=61;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetSyncTime_(): String;
var i: integer;
begin
     result:=getbooleanstr(SyncTime[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(SyncTime[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetSyncTime_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     SyncTime[i]:=getstrboolean(value);
end;



function TSETServGroup.GetComN(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.Com;
end;

procedure TSETServGroup.SetComN(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.Com:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetComN_(): String;
var i: integer;
begin
     result:=inttostr(ComN[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ComN[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetComN_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ComN[i]:=strtoint(value);
end;


function TSETServGroup.GetBaudRate(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.br;
end;

procedure TSETServGroup.SetBaudRate(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.br:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetBaudRate_(): String;
var i: integer;
begin
     result:=brtostr(BaudRate[0]);
        for i:=1 to idscount-1 do
         if (brtostr(BaudRate[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetBaudRate_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BaudRate[i]:=strtobr(value);
end;

function TSETServGroup.GetMaxAddr(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.db;
end;

procedure TSETServGroup.SetMaxAddr(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.db:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetMaxAddr_(): String;
var i: integer;
begin
     result:=inttostr(MaxAddr[0]);
        for i:=1 to idscount-1 do
         if (inttostr(MaxAddr[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetMaxAddr_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     MaxAddr[i]:=strtointdef(value,29);
end;


function TSETServGroup.GetConnType(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.sb;
end;

procedure TSETServGroup.SetConnType(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.sb:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetConnType_(): String;
var i: integer;
begin
     result:=cttostr(ConnType[0]);
        for i:=1 to idscount-1 do
         if (cttostr(ConnType[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetConnType_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ConnType[i]:=strtoct(value);
end;

function TSETServGroup.GetArchBlockSize(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.pt;
end;

procedure TSETServGroup.SetArchBlockSize(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.pt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetArchBlockSize_(): String;
var i: integer;
begin
     result:=inttostr(ArchBlockSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ArchBlockSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetArchBlockSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ArchBlockSize[i]:=strtointdef(value,0);
end;

function TSETServGroup.GetFlowControl(Index: Integer): boolean;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.flCtrl;
end;

procedure TSETServGroup.SetFlowControl(Index: Integer; value: boolean);
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


function TSETServGroup.GetFlowControl_(): String;
var i: integer;
begin
     result:=getbooleanstr(FlowControl[0]);
        for i:=1 to idscount-1 do
         if (getbooleanstr(FlowControl[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetFlowControl_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControl[i]:=getstrboolean(value);
end;


function TSETServGroup.GetFlowControlBeforeSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trd;
end;

procedure TSETServGroup.SetFlowControlBeforeSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetFlowControlBeforeSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlBeforeSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlBeforeSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetFlowControlBeforeSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlBeforeSleep[i]:=strtoint(value);
end;

function TSETServGroup.GetFlowControlAfterSleep(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.red;
end;

procedure TSETServGroup.SetFlowControlAfterSleep(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.red:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetFlowControlAfterSleep_(): String;
var i: integer;
begin
     result:=inttostr(FlowControlAfterSleep[0]);
        for i:=1 to idscount-1 do
         if (inttostr(FlowControlAfterSleep[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetFlowControlAfterSleep_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     FlowControlAfterSleep[i]:=strtoint(value);
end;

function TSETServGroup.GetReadInterval(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.ri;
end;

procedure TSETServGroup.SetReadInterval(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.ri:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetReadInterval_(): String;
var i: integer;
begin
     result:=inttostr(ReadInterval[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadInterval[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetReadInterval_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadInterval[i]:=strtoint(value);
end;


function TSETServGroup.GetReadTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtm;
end;

procedure TSETServGroup.SetReadTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetReadTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetReadTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalMultiplier[i]:=strtoint(value);
end;

function TSETServGroup.GetReadTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.rtc;
end;

procedure TSETServGroup.SetReadTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.rtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetReadTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(ReadTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetReadTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTotalConstant[i]:=strtoint(value);
end;

function TSETServGroup.GetWriteTotalMultiplier(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtm;
end;

procedure TSETServGroup.SetWriteTotalMultiplier(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetWriteTotalMultiplier_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalMultiplier[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalMultiplier[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetWriteTotalMultiplier_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalMultiplier[i]:=strtoint(value);
end;

function TSETServGroup.GetWriteTotalConstant(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wtc;
end;

procedure TSETServGroup.SetWriteTotalConstant(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wtc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetWriteTotalConstant_(): String;
var i: integer;
begin
     result:=inttostr(WriteTotalConstant[0]);
        for i:=1 to idscount-1 do
         if (inttostr(WriteTotalConstant[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetWriteTotalConstant_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     WriteTotalConstant[i]:=strtoint(value);
end;

function TSETServGroup.GetBlockSize(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.bs;
end;

procedure TSETServGroup.SetBlockSize(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.bs:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetBlockSize_(): String;
var i: integer;
begin
     result:=inttostr(BlockSize[0]);
        for i:=1 to idscount-1 do
         if (inttostr(BlockSize[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetBlockSize_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     BlockSize[i]:=strtoint(value);
end;


function TSETServGroup.GetReadTimeout(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frt;
end;

procedure TSETServGroup.SetReadTimeout(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetReadTimeout_(): String;
var i: integer;
begin
     result:=inttostr(ReadTimeout[0]);
        for i:=1 to idscount-1 do
         if (inttostr(ReadTimeout[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetReadTimeout_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     ReadTimeout[i]:=strtoint(value);
end;


function TSETServGroup.GetProxy(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.frd;
end;

procedure TSETServGroup.SetProxy(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.frd:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetProxy_(): String;
var i: integer;
begin
     result:=inttostr(Proxy[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Proxy[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetProxy_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Proxy[i]:=strtoint(value);
end;

function TSETServGroup.GetTryCount(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.trc;
end;

procedure TSETServGroup.SetTryCount(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.trc:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetTryCount_(): String;
var i: integer;
begin
     result:=inttostr(TryCount[0]);
        for i:=1 to idscount-1 do
         if (inttostr(TryCount[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetTryCount_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TryCount[i]:=strtoint(value);
end;

function TSETServGroup.GetStart(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstrt;
end;

procedure TSETServGroup.SetStart(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstrt:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetStart_(): String;
var i: integer;
begin
     result:=inttostr(Start[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Start[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetStart_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Start[i]:=strtoint(value);
end;

function TSETServGroup.GetStop(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.tstp;
end;

procedure TSETServGroup.SetStop(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.tstp:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetStop_(): String;
var i: integer;
begin
     result:=inttostr(Stop[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Stop[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetStop_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Stop[i]:=strtoint(value);
end;

function TSETServGroup.GetPRTTM(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.prttm;
end;

procedure TSETServGroup.SetPRTTM(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.prttm:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetPRTTM_(): String;
var i: integer;
begin
     result:=inttostr(PRTTM[0]);
        for i:=1 to idscount-1 do
         if (inttostr(PRTTM[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetPRTTM_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     PRTTM[i]:=strtoint(value);
end;

function TSETServGroup.GetWait(Index: Integer): integer;
var int_temp: integer;
begin
    getCom(Index);
    result:= com.wait;
end;

procedure TSETServGroup.SetWait(Index: Integer; value: integer);
var com_: TCOMSet;
begin
     com_:=getCom(Index);
     com_.wait:=value;
     Topic[Index]:=getTopic_conf( com_);
end;


function TSETServGroup.GetWait_(): String;
var i: integer;
begin
     result:=inttostr(Wait[0]);
        for i:=1 to idscount-1 do
         if (inttostr(Wait[i])<>result) then
           begin
              result:='';
           end;
end;

procedure TSETServGroup.SetWait_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     Wait[i]:=strtoint(value);
end;

function TSETServGroup.getTopic_conf(val: TCOMSet): string;
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
    // if not((val.db=5) or (val.db=6) or (val.DB=7) or (val.DB=8)) then val.DB:=8;
    // if not((val.sb=3) or (val.sb=2) or (val.sb=1) ) then val.sb:=1;


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

function TSETServGroup.getApplication_conf(): string;
begin
    result:='SETServ';;
end;

end.
 