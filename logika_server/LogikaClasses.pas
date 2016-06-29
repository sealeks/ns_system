unit LogikaClasses;

interface
uses
  classes,  SysUtils, InterfaceServerU,
  Mycomms, DateUtils, ConstDef, GlobalValue,
  windows{, debugClasses}, Messages, ConvFunc, {Globalvar,} dialogs, MemStructsU,LogikaComPortU, Math;

const
  UM_UPDATEPORT = WM_USER + 1;
  groupCount = 255;

const MAXREAD_ITEM=20;
      MAXPERIOD_ARCHITEM=31;

const  REPORT_SET_LOGIKA   = [ REPORTTYPE_HOUR,
         REPORTTYPE_DEC, REPORTTYPE_DAY, REPORTTYPE_MONTH,
          REPORTTYPE_30MIN, REPORTTYPE_10MIN
          ];

type
  TUnitItemType  = ( uiReal, uiInteger, uiTime, uiMessage);


type
  TLogNotyfy = procedure (Sender: TObject; val: integer; val1: integer) of Object;

// тип тега опроса
  // текущие данные, массив, архив
type
  TItemReqType  = (rtCurrent, rtArray, rtArchive);

type
  TNetType = ( ntAPS, ntDirect);

type
      TreportArrUnit = record
      dt: TDateTime;
      val: real;
      end;

// единица опроса для текущих данных
type
  TUnitItem = record
    name: string;
    ID: array of integer;
    chanalNum: integer;
    paramNum: integer;
    uiType: TUnitItemType;
    minRaw, maxRaw, MinEu, MaxEu: real;
    activ: boolean;
    buffer: array of TreportArrUnit;
    reqType: TItemReqType;
    index: integer;
    tmreq: TDateTime;
    trycount: integer;
    tmwrite: TDateTime; // время для логики write to ArchServ
    tmwait: TDateTime; // время для логики wait
    typ: integer;
    lasttime: TDatetime;
    delt: integer;
    deep: integer;
    error: integer;
    device_val: string;
    device_ue:  string;
    device_tm:  string;

  end;

  PTUnitItem = ^TUnitItem;



  // виртуальные элементы
  // организуют логику последовательного чтения
  // curr-arch1-curr-arch2....   curr-array1-curr-array2
  // curr,archN,arrayN - блоки данных, которые можно прочитать целиком


 type
  TVirtualUnitItem = record
    start_ind: integer;
    stop_ind: integer;
    reqType_: TItemReqType;
  end;

  PTVirtualUnitItem = ^TVirtualUnitItem;







  TUnitItems = class(TList)
  private
    frtitems: TanalogMems;

     farchblocksize: integer;
    procedure freeitem_;
    procedure SetItem(id: integer; item: PtUnitItem);
    function  GetItem(id: integer): PTUnitItem;
    function  GetRefCount(id: integer): integer;
    procedure Log(mess: string; lev: byte = 2);
    procedure Sort;
    function getarchblocksize: integer;

    // для архивных меток
    function  GetReqTime1(id: integer): TdateTime;
    function  GetReqTime2(id: integer): TdateTime;
    procedure SetState(id: integer; state: integer);
    function  GetState(id: integer): integer;
    function  GetTyp(id: integer): integer;
    function  GetDeep(id: integer): integer;
    function  GetDelt(id: integer): integer;
    function  GetVal(id: integer): real;
    procedure SetVal(id: integer; vals: real);
    function  getBufferCount(id: integer): integer;
    function  getValid(id: integer): integer;
    procedure addInBuffer(id: integer ; val: TreportArrUnit);
    function  getFromBuffer(id: integer): TreportArrUnit;
    function  GetTag(id: integer): string;
    function  GetRtid(id: integer): integer;
    function  GetTabTime(id: integer): TdateTime;
    procedure SetTabTime(id: integer; val: TdateTime);
    procedure CheckNodata(id: integer);
    function  isLastPeriod(id: integer): boolean;
  public
   procedure   setAllValidOff;
   function    NeedRequestItemArch(id: integer): boolean; // есть что опрашивать для архивной
   function    NeedRequestItemArch_(id: integer): boolean; // есть что опрашивать для архивной
   function    FindItemByParam(chanal_: longInt; num: Longint; ind: integer): integer;  overload;
   function    FindItemByParam(chanal_: longInt; num: Longint): integer;  overload;
   function    FindItemByParamArch(chanal_: longInt; num: Longint): integer;  overload;
   property    items[id: integer]: PTUnitItem read getItem write setItem; default;
   property    valid[id: integer]: integer read getValid;
   property    buff[id: integer]: integer read getBufferCount;
   property    refCount[id: integer]: integer read getrefCount;
   function    addItem(id: integer): PTUnitItem;
   procedure   SetCurVal(id: integer; val: string; ue_: string; tm_: string);
   constructor create(frtitems_: TanalogMems);
   destructor  destroy; override;

   // для архивных меток

    //время когда фактически необходим опрос
    //задействуются механизмы опроса( может расходится с TabTime
   property ReqTime1[id: integer]: TdateTime read getReqTime1; // write setReqTime;
   property ReqTime2[id: integer]: TdateTime read getReqTime2; // write setReqTime;
   property Typ[id: integer]:  integer read getTyp;
   property State[id: integer]: integer read getState write setState;
   property Deep[id: integer]: integer read getDeep;
   property Val[id: integer]: real read getVal write setVal;
   property Delt[id: integer]: integer read getDelt;
   property RtId[id: integer]:  integer read getRtId;
   property TabTime[id: integer]: TdateTime read getTabTime write setTabTime;
   property archblocksize: integer read getarchblocksize;
  end;

//  wraper для TUnitItems

TVirtualUnitItems = class(TList)
   private
      mainlist: TUnitItems;
      frtitems: TanalogMems;
      cursor: integer;
      comserver: TLogikaComPort;
      proxy: byte;
      slave: byte;
      fblocksize: integer;
      ftypeReq: TNetType;
      fMaxUSD: byte;
      procedure freeitem_;
      procedure SetItem(id: integer; item: PTVirtualUnitItem);
      function  GetItem(id: integer): PTVirtualUnitItem;
      function  GetNeedReq(id: integer): boolean;
      function  GetNeedReq_(id: integer): boolean;
      function  GetComMessageCurr(id: integer): string;  // сообщение в порт для текущих
      function  GetComMessageArr(id: integer): string;  // сообщение в порт для массивов
      function  GetComMessageArch(id: integer): string;  // сообщение в порт для массивов
      function  ProccessMessageCurr(id: integer; val: string): integer;  // сообщение в порт для текущих
      function  ProccessMessageArr(id: integer; val: string): integer;  // сообщение в порт для массивов
      function  ProccessMessageArch(id: integer; val: string): integer;  // сообщение в порт для массивов
      function  AddCommand(It: PtUnitItem; val: real): integer;  // сообщение в порт на запись
      function  Sync: integer;
      function  GetCommand(It: PtUnitItem; val: real): string;  // сообщение в порт на запись
      function  GetTimeC: string;  // сообщение в порт на запись
      function  GetDateC: string;  // сообщение в порт на запись
      function  GetCommandArr(It: PtUnitItem; val: real): string;  // сообщение в порт на запись
      function  ProccessCommand(It: PtUnitItem): integer;  // сообщение в порт на запись
      function  ProccessCommandArr(It: PtUnitItem): integer;  // сообщение в порт на запись
      function getblocksize: integer;
      procedure Init;
   public
     constructor create;
     destructor destroy;
     procedure  CheckArch;
     procedure  setUnitItems(unitList: TUnitItems; bs: integer);
     function  virtCursor: integer;
     function  Curread: string;
     procedure setProxy(fproxy: byte);
     procedure setComm(val: TLogikaComPort; fslave: byte; fproxy: byte);
     function  Read: integer;
     procedure  NeedRequestItemArchAll;
     function  ReadItem(id: integer): integer;
     property  NeedReq[id: integer]: boolean read getNeedReq;
     property  items[id: integer]: PTVirtualUnitItem read getItem write setItem; default;
     property _blocksize: integer read getblocksize;
     property typeReq: TNetType read ftypeReq;
     property MaxUSD: byte read fMaxUSD;
   end;



TDeviceItem =class (TObject)
   protected
     ferror: integer;
     fMaxUSD: byte;
     comserver: TLogikaComPort;
     frtitems: TanalogMems;
     funitList: TUnitItems;
     virtualitems: TVirtualUnitItems;
     fslavenum: integer;
     fGroupNum: integer;
     flastconnect: TdateTime;
     id_req: integer;
     id_inreq: integer;
     timeoutreq: integer;
     fComSet: TComSEt;
     fAllItems: TStringList;
     finreqest: boolean;
     fAllItemsList: TStringList;
     ftypeReq: TNetType;
     fproxy: byte;
     fanalizefunc: TLogNotyfy;
     inconnected: boolean;
     isSync: boolean;
     function  GetNameDev: string;
     procedure Log(mess: string; lev: byte = 2);
     procedure setComm(val: TLogikaComPort);
     function inreq: boolean;
     function needreq: boolean;
     procedure setreqOff;
     procedure setreqOn;
     function FindIt(val: string): PTUnitItem;
     function getCurread: string;
     function getCursor: integer;
   public
     function AddCommand(nm: string; val: real): boolean;
     function Sync: boolean;
     constructor Create(frtitems_: TanalogMems;  groupnum: integer; AllItemsList: TStringList);
     function Init: boolean;
     function UnInit: boolean;
     procedure AddGroup;
     function read: integer;
     destructor destroy;
     property analizefunc: TLogNotyfy read fanalizefunc write fanalizefunc;
     property NameDev: string read getNameDev;
     property Proxy: byte read fProxy;
     property slavenum: Integer read fslavenum;
     property error: Integer read ferror;
     property unitList: TUnitItems read funitList;
     property ComSet: TComSEt read fComSet;
     property Curread: string read getCurread;
     property Cursor: integer read getCursor;
     property inReqest: boolean read finreqest;  // для отображения в окне
     property typeReq: TNetType read ftypeReq;
     property MaxUSD: byte read fMaxUSD;
   end;

//PTDeviceItem = ^TDeviceItem;

TDeviceItems =class (TList)
   protected
 //    frepList: TLogRepItems;
     fAllItemsList: TStringList;  // список всех элементов Команды
     funitList: TUnitItems;
     frtitems: TanalogMems;
     fcomnum: integer;
     comserver: TLogikaComPort;
     currenread: integer;
     fconnected: boolean;
     fMaxUSD: byte;
     ftypeReq: TNetType;
     fanalizefunc: TLogNotyfy;
    function  inReq: boolean;
    procedure SetItem(id: integer; item: TDeviceItem);
    function  GetItem(id: integer):  TDeviceItem;
    procedure Log(mess: string; lev: byte = 2);
    function FindBySlave(slave: integer): integer;
    procedure NeedRequestItemArchAll;
    procedure resetInread;
   public
     constructor Create(frtitems_: TanalogMems; comnum: integer; comset: TComSet);
     destructor destroy;
     procedure setreqOff;
     function readDev: boolean;
     function synctime: boolean;
     function Open: boolean;
     function Close: boolean;
     function Init: boolean;
     function UnInit: boolean;
     property items[i: integer]: TDeviceItem read getItem write setItem; default;
     function FindIt(val: string): TDeviceItem;
     function AddCommand(nm: string; val: real): boolean;
     function Sync: boolean;
     property analizefunc: TLogNotyfy read fanalizefunc write fanalizefunc;
     property typeReq: TNetType read ftypeReq;
     property MaxUSD: byte read fMaxUSD;

   end;



function Decode_DOS_to_Win(str: string): string;
function Decode_Win_to_DOS(str: string): string;
function GetInfo(val: string; var chan: integer;var num: integer;var ind: integer; var ut: TUnitItemType): boolean;
function isCom(val: string;temp: string; var ComSet: TComSEt): integer;
function checkS(val_: string): boolean;
function CompareUI(v1:PTUnitItem; v2: PTUnitItem): integer;
function CompareUI_(v:PTUnitItem; chan: integer; num: integer; ind: integer): integer;
function GetCharPostDelimit(val: string; limitchar: char; sl: TStringlist): integer;
function GetCharPreDelimit(val: string; limitchar: char; sl: TStringlist): integer;
function DevValtoRtitemVal(val: string; typV: TUnitItemType; var res: real): boolean;
function RtitemValtoDevVal(val: real; typV: TUnitItemType;  var res: string): boolean;
function datetimetoDevformat(val: TDateTime): string;
function getArrUnit(val: string; tm: string; var res: TreportArrUnit): boolean;
  // преобразование строки полученной из контроллера в
  // значение базы

implementation


function Decode_DOS_to_Win(str: string): string;
var
    i: integer;
begin
 result:='';
   for i:=1 to length(str) do
    begin
       if((byte(str[i])>128) and (byte(str[i])<=175)) then
           result:=result+char(byte(str[i])+64)
       else if((byte(str[i])>=224) and (byte(str[i])<=239)) then
           result:=result+char(byte(str[i])+16)
       else if(byte(str[i])=252) then
           result:=result+char(185) else  result:=result+str[i];
      end;

end;

function  Decode_Win_to_DOS(str: string): string;
var
    i: integer;
begin
   for i:=1 to length(str) do
    begin
        if (byte(str[i])>128) then
            result:=result+char(byte(str[i])-16)
       else if(byte(str[i])>=192) then
           result:=result+char(byte(str[i])-64)
       else if(byte(str[i])=185)   then
           result:=result+char(252)  else  result:=result+str[i];
      end;
end;


function datetimetoDevformat(val: TDateTime): string;
begin
   result:=formatdatetime(char(HT)+'dd'+char(HT)+'mm'+char(HT)+'YY'+
     char(HT)+'hh'+char(HT)+'nn'+char(HT)+'ss'+char(FF),val);
end;

function getArrUnit(val: string; tm: string; var res: TreportArrUnit): boolean;
function deletnull(vl: string): string;
 var l: integer;
     fll: boolean;
begin
   fll:=false;
   result:='';
   for l:=1 to length(vl)-1 do
     case vl[l] of
       '1'..'9': begin result:=result+vl[l]; fll:=true; end;
       '0': begin
             if fll then result:=result+vl[l];
            end;
      end;
    if length(vl)>0 then result:=result+vl[length(vl)];
end;

function getDT(val_: string; var tm_: TDateTime ): boolean;
var tmp,yy,mm,dd,hh,nn,ss: string;
    k, rangnum,yy_: integer;
begin
   result:=false;
   val:=trim(val);
   rangnum:=0;
   tmp:='';
   for k:=1 to length(val_) do
    begin
      case val_[k] of
       '-','/',':':
         begin
           case rangnum of
            0: dd:=tmp;
            1: mm:=tmp;
            2: yy:=tmp;
            3: hh:=tmp;
            4: nn:=tmp;
            5: ss:=tmp;
            end;
            tmp:='';
            rangnum:=rangnum+1;
         end
       else tmp:=tmp+val_[k]
    end;
    end;
    if ((tmp<>'') and (rangnum=5)) then ss:=tmp;
    yy:=deletnull(yy);
    mm:=deletnull(mm);
    dd:=deletnull(dd);
    hh:=deletnull(hh);
    nn:=deletnull(nn);
    ss:=deletnull(ss);
    if strtointdef(yy,0)<90 then yy_:=2000+strtointdef(yy,0)
    else yy_:=strtointdef(yy,0);
    if not ((yy<>'') and (mm<>'') and (dd<>'') and (hh<>'') and (nn<>'') and (ss<>'')) then exit;
    tm_:=EncodeDateTime(yy_,strtointdef(mm,0),strtointdef(dd,0),
                       strtointdef(hh,0),strtointdef(nn,0),strtointdef(ss,0),0);
    tmp:=datetimetostr(tm_);
    result:=true;
end;

begin
   result:=false;
   if not  DevValtoRtitemVal(val,uiReal,res.val) then exit;
   if not  getDT(tm,res.dt) then exit;
   result:=true;
end;

function DevValtoRtitemVal(val: string; typV: TUnitItemType;  var res: real): boolean;
var FormatS: TFormatSettings;
begin
   case typV of
     uiInteger:
       begin
        try
          res:=round(strtoint(val));
          result:=true;
        except
          res:=0;
          result:=false;
        end;
       end;
     uiTime:
       begin
        try
          res:=secondoftheday(strtotime(val));
          result:=true;
        except
          res:=0;
          result:=false;
        end;
       end
     
     else
     begin
       try
          FormatS.DecimalSeparator:=char('.');
          res:=strtofloat(val,FormatS);
          result:=true;
        except
          res:=0;
          result:=false;
        end;
     end;
     end;
end;

function RtitemValtoDevVal(val: real; typV: TUnitItemType;  var res: string): boolean;
var FormatS: TFormatSettings;
begin
   case typV of
     uiInteger:
       begin
          res:=inttostr(round(val));
          result:=true;
       end;
     uiTime:
       begin

          res:=DateToStr(val);
          result:=true;
       end

     else
     begin

          FormatS.DecimalSeparator:=char('.');
          res:=floattostr(val,FormatS);
          result:=true;

     end;
     end;
end;

function isCom(val: string;temp: string; var ComSet: TComSEt): integer;
  function findValNum(val: string; str: string):integer;
    var pos_,i: integer;
        numstr: string;
        fl: boolean;
    begin
       fl:=true;
       result:=-1000;
       numstr:='';
       val:=trim(uppercase(val));
       str:=trim(uppercase(str));
       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str[i];
            end;
         end;
       try
         result:=strtoint(numstr);
       except
       end;
    end;

  function findtext(val: string; str: string):String;
    var pos_,i: integer;
        numstr: string;
        fl: boolean;
    begin
       fl:=true;
       result:='';
       numstr:='';
       val:=trim(uppercase(val));
       str:=trim(uppercase(str));
       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str[i];
            end;
         end;
       try
         result:=numstr;
       except
       end;
    end;


 function getinVstring(var val: string; pref: string): string;
   var valU, PrefU, preftemp: string;
       i: integer;
   begin
     val:=trim(val);
     PrefU:=trim(uppercase(pref));
     valU:=trim(uppercase(val));
     if ((length(valU)+3)<(length(PrefU))) then
       begin
         val:='';
         result:='';
         exit;
       end;
    // if (pref<>'') then
       begin
          preftemp:=copy(valU,1,length(prefU)+1);
          if ((pref+'[')=(preftemp)) then
            begin
              i:=length(preftemp)+1;
              while ((ValU[i]<>']') and (i<=length(ValU))) do
                begin
                  result:=result+Val[i];
                  i:=i+1;
                end;
              if (i<length(ValU)) then val:=copy(val,i+1,length(valU)-i+1) else
              val:='';
            end;
       end;
   end;

var tempval: string;
    tempnum: integer;

begin
   result:=-1;
   ComSet.Com:=1;
   ComSet.br:=9600;
   ComSet.db:=1;       // максимальный номер прибора в сети
   ComSet.sb:=1;       //  тип соединения
   ComSet.pt:=16;      // архивный блок
   ComSet.trd:=0;
   ComSet.red:=0;
   ComSet.ri:=100;
   ComSet.rtm:=3000;
   ComSet.rtc:=3000;
   ComSet.wtm:=3000;
   ComSet.wtc:=3000;
   ComSet.bs:=5;
   ComSet.flCtrl:=false;
   ComSet.frt:=60;   // таймаут на разрыв связи
   ComSet.frd:=0;   //  номер посредника
   ComSet.trc:=3;
   ComSet.tstrt:=-1;
   ComSet.tstp:=61;
   ComSet.prttm:=500;
   Comset.wait:=3000;
   Comset.name:='';
   val:=trim(val);
   if val='' then exit;
   tempval:=trim(getinVstring(val,uppercase(temp)));

   if tempval<>'' then
    begin
           tempnum:=findValNum('com',tempval);
           if tempnum>0 then
             begin
             result:=tempnum;
             ComSet.Com:=tempnum;
             end
             else
             begin
             result:=1;
             ComSet.Com:=1;
             end;
           // com1[br9600,bd7,sb1,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]
           tempnum:=findValNum('br',tempval);
           if tempnum>0 then
             ComSet.br:=tempnum;

            tempnum:=findValNum('bd',tempval);
           if (tempnum>0) and (tempnum<30) then
             ComSet.db:=tempnum;

           tempnum:=findValNum('sb',tempval);
           if (tempnum>-1) and (tempnum<30) then
             ComSet.sb:=tempnum;

           tempnum:=findValNum('bs',tempval);
           if (tempnum>-1) then
              ComSet.bs:=tempnum;

           tempnum:=findValNum('ri',tempval);
           if (tempnum>-1) then
              ComSet.ri:=tempnum;

           tempnum:=findValNum('rtm',tempval);
           if (tempnum>-1) then
              ComSet.rtm:=tempnum;

           tempnum:=findValNum('rtc',tempval);
           if (tempnum>-1) then
              ComSet.rtc:=tempnum;

            tempnum:=findValNum('wtm',tempval);
           if ((tempnum>-1) or (uppercase(temp)='ETH')) then
              ComSet.wtm:=tempnum;

           tempnum:=findValNum('wtc',tempval);
           if (tempnum>-1) then
              ComSet.wtc:=tempnum;



            tempnum:=findValNum('frt',tempval);
           if (tempnum>-1) then
              ComSet.frt:=tempnum;

           tempnum:=findValNum('frd',tempval);
           if (tempnum>-1) then
              ComSet.frd:=tempnum;

           tempnum:=findValNum('trc',tempval);
           if (tempnum>-1) then
              ComSet.trc:=tempnum;

           tempnum:=findValNum('tstrt',tempval);
           if (tempnum>-1) then
              ComSet.tstrt:=tempnum;
           tempnum:=findValNum('tstp',tempval);
           if (tempnum>-1) then
              ComSet.tstp:=tempnum;
           tempnum:=findValNum('prttm',tempval);
           if (tempnum>-1) then
              ComSet.prttm:=tempnum;
           tempnum:=findValNum('wait',tempval);
           if (tempnum>-1) then
              ComSet.wait:=tempnum;
           Comset.name:=findtext('name',tempval);

           tempnum:=findValNum('pt',tempval);
           if (tempnum>-1) and (tempnum<100) then
             ComSet.pt:=tempnum;


     end;
      if ((comset.trd=0) and (comset.red=0)) then
            comset.flCtrl:=false else
            comset.flCtrl:=true;
end;

function GetCharPreDelimit(val: string; limitchar: char; sl: TStringlist): integer;
var i: integer;
    temp: string;
    fl: boolean;
begin
 if sl=nil then exit;
 sl.Clear;
 fl:=false;
 temp:='';
 for i:=1 to length(val) do
   begin
     if (val[i]=limitchar) then
        begin
          if (fl) then
          begin
          sl.Add(temp);
          temp:='';
          end else
          begin
          fl:=true;
          temp:='';
          end;
        end else temp:=temp+val[i];
    end;
    if fl then  sl.Add(temp);
end;

function GetCharPostDelimit(val: string; limitchar: char; sl: TStringlist): integer;
var i: integer;
    temp: string;
begin
 if sl=nil then exit;
 sl.Clear;
 for i:=1 to length(val) do
   begin
     if val[i]=limitchar then
        begin
          sl.Add(temp);
          temp:='';
        end else temp:=temp+val[i];
    end;
end;


function CompareUI(v1:PTUnitItem; v2: PTUnitItem): integer;
var vir1,vir2: integer;
begin
   // виртальная добавка служит для того чтобы в отсортированном списке
   // элементы шли по типам опросов
   // сначала все текущие, потом все архивные, потом все массивы

   if v1.index=-2 {архивные} then vir1:=1000 else
       if v1.index>-1 {массивы} then vir1:=10000  else
          {текущие} vir1:=0;

   if v2.index=-2 {архивные} then vir2:=1000 else
       if v2.index>-1 {массивы} then vir2:=10000  else
          {текущие} vir2:=0;

   result:=0;
   if (v1.chanalNum+vir1)>(v2.chanalNum+vir2) then begin result:=-1; exit; end;
   if (v1.chanalNum+vir1)<(v2.chanalNum+vir2) then begin result:=1; exit; end;
   if v1.paramNum>v2.paramNum then begin result:=-1; exit; end;
   if v1.paramNum<v2.paramNum then begin result:=1; exit; end;
   if v1.index>v2.index then begin result:=-1; exit; end;
   if v1.index<v2.index then begin result:=1; exit; end;
end;

function CompareUI_(v:PTUnitItem; chan: integer; num: integer; ind: integer): integer;
var virv,virt_: integer;
begin

   if v.index=-2 {архивные} then virv:=1000 else
       if v.index>-1 {массивы} then virv:=10000  else
          {текущие} virv:=0;

   if ind=-2 {архивные} then virt_:=1000 else
       if ind>-1 {массивы} then virt_:=10000  else
          {текущие} virt_:=0;

   result:=0;
   if (v.chanalNum+virv)>(chan+virt_) then begin result:=-1; exit; end;
   if (v.chanalNum+virv)<(chan+virt_) then begin result:=1; exit; end;
   if v.paramNum>num then begin result:=-1; exit; end;
   if v.paramNum<num then begin result:=1; exit; end;
   if v.index>ind then begin result:=-1; exit; end;
   if v.index<ind then begin result:=1; exit; end;
end;




{function CompareRL(v1:PTRepLogItem; v2: PTRepLogItem): integer;
begin
   result:=0;
   if v1.chanalNum>v2.chanalNum then begin result:=-1; exit; end;
   if v1.chanalNum<v2.chanalNum then begin result:=1; exit; end;
   if v1.paramNum>v2.paramNum then begin result:=-1; exit; end;
   if v1.paramNum<v2.paramNum then begin result:=1; exit; end;
   if v1.index>v2.index then begin result:=-1; exit; end;
   if v1.index<v2.index then begin result:=1; exit; end;
end;

function CompareRL_(v:PTRepLogItem; chan: integer; num: integer; ind: integer): integer;
begin
   result:=0;
   if v.chanalNum>chan then begin result:=-1; exit; end;
   if v.chanalNum<chan then begin result:=1; exit; end;
   if v.paramNum>num then begin result:=-1; exit; end;
   if v.paramNum<num then begin result:=1; exit; end;
   if v.index>ind then begin result:=-1; exit; end;
   if v.index<ind then begin result:=1; exit; end;
end;       }

function checkS(val_: string): boolean;
var i: integer;
begin
  result:=false;
  val_:=trim(Uppercase(val_));
  for i:=1 to length(val_) do
   if not (val_[i] in ['C','H','I','N','T','Y','P','R','M',':','0'..'9']) then  exit;
  result:=true;
end;

{
 [chN]:nMMM[:iNN][:typI]

}


function GetInfo(val: string; var chan: integer;var num: integer;var ind: integer; var ut: TUnitItemType): boolean;

var temp,i: integer;
    tempstr: string;
begin
   try
   result:=false;
   val:=trim(uppercase(val));

   temp:=pos('CH',val);
   chan:=0;
   num:=-1;
   ind:=-1;
   if temp>0 then
     begin
       chan:=-1;
       if (temp+2)<length(val) then
       begin
        i:=temp+2;
        tempstr:='';
        while (i<=length(val)) and (val[i]<>':') do
         begin
            tempstr:=tempstr+val[i];
            inc(i);
         end;
        chan:=strtointdef(tempstr,-1);
       end;
     end;

   temp:=pos('N',val);
   if temp>0 then
     begin
       num:=-1;
       if (temp+1)<=length(val) then
       begin
        i:=temp+1;
        tempstr:='';
        while (i<=length(val)) and (val[i]<>':') do
         begin
            tempstr:=tempstr+val[i];
            inc(i);
         end;
        num:=strtointdef(tempstr,-1);
       end;
     end;

   temp:=pos('I',val);
   if temp>0 then
     begin
       ind:=-1;
       if (temp+1)<=length(val) then
       begin
        i:=temp+1;
        tempstr:='';
        while (i<=length(val)) and (val[i]<>':') do
         begin
            tempstr:=tempstr+val[i];
            inc(i);
         end;
        ind:=strtointdef(tempstr,-1);
       end;
     end;

   temp:=pos('TYP',val);
   if temp>0 then
     begin

       if (temp+3)<=length(val) then
       begin
        i:=temp+3;
        tempstr:='';
        while (i<=length(val)) and (val[i]<>':') do
         begin
            tempstr:=tempstr+val[i];
            inc(i);
         end;
           tempstr:=trim(tempstr);
           ut:=uiInteger;
           if (tempstr='R') then ut:=uiReal;
           if (tempstr='I') then ut:=uiInteger;
           if (tempstr='T') then ut:=uiTime;
           if (tempstr='M') then ut:=uiMessage;
       end;
     end;
     if (chan>-1) and (num>-1) then result:=true;
   except
   end;
end;

{****************************TUnitItems*****************************************}

constructor TUnitItems.create(frtitems_: TanalogMems);
begin
  inherited create;
  frtitems:=frtitems_;
end;

destructor TUnitItems.destroy;
begin
self.freeitem_;
clear;
inherited destroy;
end;

//  проверяет является ли опрашиваемый период последним
//  нет -  данных отчетного и правда  не существует
//  да  -  ничего не делает, ждет данные дальше
procedure TUnitItems.CheckNodata(id: integer);
begin
  if not isLastPeriod(id) then
    begin
      frtitems.Items[items[id].ID[0]].TimeStamp:=ReqTime2[id];
    end  else
    State[id]:=REPORT_NEEDWAIT;
end;


function TUnitItems.isLastPeriod(id: integer): boolean;
begin
  result:=(ReqTime2[id]>now);
end;


function TUnitItems.NeedRequestItemArch(id: integer): boolean; // есть что опрашивать для архивной
var temp: TreportArrUnit;
begin
 result:=false;
 if items[id].reqType<>rtArchive then
 begin
   log('Попытка читать обычный элемент как архивный!',_DEBUG_ERROR);
   exit;
 end;
 if (State[id]<>REPORT_NEEDREQUEST) then exit;
 if getBufferCount(id)>0 then
   begin
        temp:=getFromBuffer(id);
        //  если время в ответе не совпадает со временем
        //запроса
        Val[id]:=temp.val;
        if temp.dt<>TabTime[id] then
           TabTime[id]:=roundPeriod(typ[id],temp.dt,delt[id]);

        State[id]:=REPORT_DATA;
   end else
   result:=true;
end;

function TUnitItems.NeedRequestItemArch_(id: integer): boolean; // есть что опрашивать для архивной
begin
 result:=false;

 if (State[id]<>REPORT_NEEDREQUEST) then exit;
 if getBufferCount(id)=0 then
   result:=true;
end;



function TUnitItems.GetItem(id: integer): PTUnitItem;
begin
  result := inherited Items[id];
end;

procedure TUnitItems.SetItem(id: integer; item: PTUnitItem);
begin
  Items[id] := item;
end;

function TUnitItems.GetRefCount(id: integer): integer;
var j: integer;
begin
   result:=0;
   for j:=0 to length(items[id].id)-1 do
      if items[id].id[j]>-1 then
      if frtitems.Items[items[id].id[j]].refCount>0 then
         inc(result);
end;

function  TUnitItems.getValid(id: integer): integer;
begin
      result:=0;
      if (items[id].id[0]>-1) and (frtitems.Items[items[id].id[0]].ID>-1) then
      result:=frtitems.Items[items[id].id[0]].ValidLevel;
end;





function  TUnitItems.FindItemByParam(chanal_: longInt; num: Longint): integer;
begin
   result:=FindItemByParam(chanal_, num, -1);
end;


function  TUnitItems.FindItemByParamArch(chanal_: longInt; num: Longint): integer;
begin
   result:=FindItemByParam(chanal_, num, -2);
end;

function TUnitItems.getarchblocksize: integer;
begin
  if (farchblocksize>0) and  (farchblocksize<32)
   then
   begin
     result:=farchblocksize;
     exit;
   end;
   result:=10;
end;

function  TUnitItems.FindItemByParam(chanal_: longInt; num: Longint; ind: integer): integer;

var x1, x2, temp: integer;

begin
  result := -1;
  if count=0 then exit;
  x1:=0;
  x2:=count-1;
  if (x1=x2) then
   begin
     if CompareUI_(Items[x1],chanal_,num,ind)=0 then
        result:=x1;
     exit;
   end;
  if CompareUI_(Items[x1],chanal_,num,ind)<0 then exit;
  if CompareUI_(Items[x2],chanal_,num,ind)>0 then exit;
  while (x1<>x2) do
    begin
      if CompareUI_(Items[x1],chanal_,num,ind)=0 then
       begin
         result:=x1;
         exit;
       end;
      if CompareUI_(Items[x2],chanal_,num,ind)=0 then
       begin
         result:=x2;
         exit;
       end;
       if (x2-x1)=1 then exit;
       temp:=(x2+x1) div 2;
       if CompareUI_(Items[temp],chanal_,num,ind)<0 then
         x2:=temp else x1:=temp;
    end;
end;

{function  TUnitItems.FindItemByName(Name_: string): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if (uppercase(Items[i].name) = uppercase(Name_)) then
    begin
      result := i;
      exit;
    end;
end;   }

function  TUnitItems.addItem(id: integer): PTUnitItem ;
var ch_,num_,ind_, findid,l: integer;
    utyp_: TUnitItemType;
    it: PTUnitItem;
    tempid: array of integer;
    typ_: integer;
    name_: string;
    reqtype: TItemReqType;
begin
   result:=nil;
   if id<0 then exit;
   if frtitems[id].ID<0 then exit;

   typ_:=frtitems[id].logTime;
   name_:=frtitems.GetName(id);
 //  if FindItemByName(frtitems.GetName(id))<0 then
     begin
       if not checkS(trim(uppercase(frtitems.GetDDEItem(id)))) then
          begin
           log('Mетка nm:='+frtitems.GetName(id)+', id='+ inttostr(id) +
            ' не добавлена. Источник '+frtitems.GetDDEItem(id)+' содержит некорректные символы!',_DEBUG_ERROR);
          end;

       if GetInfo(frtitems.GetDDEItem(id),ch_,num_,ind_,utyp_) then
          begin

            // определяем тип метки
            if not (typ_ in REPORT_SET_LOGIKA ) then
              begin
                 if ind_>-1 then reqtype:=rtArray
                 else reqtype:=rtCurrent;
              end else
            reqtype:=rtArchive;


            case reqtype of

              rtCurrent,rtArray:
                begin
                   findid:=FindItemByParam(ch_,num_,ind_);
                   if findid>-1 then
                   begin
                   it:=items[findid];
                   setlength(tempid,length(it.id)+1);
                   for l:=0 to length(it.id)-1 do
                     tempid[l]:=it.id[l];
                   setlength(it.id,length(it.id)+1);
                   for l:=0 to length(it.id)-2 do
                      it.id[l]:=tempid[l];
                   it.id[length(it.id)-1]:=id;
                   setlength(tempid,0);
                  // log('Продублирована метка nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
                  // inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
                   result:=items[findid];
                   end
                  else
                   begin
                   new(it);
                   it.name:=name_;
                   setlength(it.ID,1);
                   it.ID[0]:=id;
                   it.chanalNum:=ch_;
                   it.paramNum:=num_;
                   it.uiType:=utyp_;
                   it.index:=ind_;
                   it.typ:=typ_;
                  // log('Добавлена метка nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
                //   inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
                   Add(it);
                   it.reqType:=reqtype;
                   it.error:=0;
                   it.minRaw:=frtitems[id].MinRaw;
                   it.maxRaw:=frtitems[id].MaxRaw;
                   it.minEU:=frtitems[id].MinEU;
                   it.maxEU:=frtitems[id].MaxEU;
                   result:=it;
                   Sort;
                   end
                end;

              rtArchive:
                begin
                 ind_:=-2;
                 findid:=FindItemByParam(ch_,num_,-2);
                 if findid>-1 then
                   begin
                    log('Архивная метка  не добавлена nm:='+frtitems.GetName(id)+' источник source='+frtitems.GetDDEItem(id)+
                      ' Имеет дупликат!',_DEBUG_ERROR);
                    exit;
                   end;


                  new(it);
                  it.reqType:=reqtype;
                  setlength(it.ID,1);
                  it.ID[0]:=id;
                  it.chanalNum:=ch_;
                  it.paramNum:=num_;
                  it.uiType:=utyp_;
                  it.index:=-2;
                  it.name:=name_;
                  it.typ:=typ_;
                  it.lasttime:=0;
                  it.minRaw:=frtitems[id].MinRaw;
                  it.maxRaw:=frtitems[id].MaxRaw;
                  it.minEU:=frtitems[id].MinEU;
                  it.maxEU:=frtitems[id].MaxEU;
                  setlength(it.buffer,0);
                  it.delt:= round(frtitems[id].AlarmConst);
                //  log('Архивная  метка добавлена nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
                  //inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
                  Add(it);
                  it.error:=0;
                  Sort;
                  findid:=FindItemByParam(ch_,num_,-2);
                  state[findid]:=REPORT_NEEDKHOWDEEP;
                  result:=it;
                end;
             end
     end else  log('Mетка nm:='+frtitems.GetName(id)+', id='+ inttostr(id) + ', ch:='+inttostr(ch_)+', num='+ inttostr(num_) +
     ' не добавлена. Источник '+frtitems.GetDDEItem(id)+' задан не верно!',_DEBUG_ERROR);
     end;
end;


procedure TUnitItems.Sort;
var fl: boolean;
    i: integer;
begin
  // пузырьковая сортировка
  fl:=true;
  while fl do
  begin
     fl:=false;
     for i:=0 to count-2 do
      begin
        if CompareUI(items[i],items[i+1])<0
               then begin
                  fl:=true;
                  Move(i,i+1);
                  break;
                  end;
      end;
   end;

end;


procedure TUnitItems.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

procedure TUnitItems.setAllValidOff;
var i,j: integer;
begin
  for i:=0 to count-1 do
   begin
     for j:=0 to length(items[i].ID)-1 do
       begin
          if (items[i].ID[j]>-1) then
            if frtitems.Items[items[i].ID[j]].ID>-1 then
              if not (frtitems.Items[items[i].ID[j]].logTime in REPORT_SET) then
                frtitems.ValidOff(frtitems.Items[items[i].ID[j]].ID);
       end;
   end;
end;



function TUnitItems.getBufferCount(id: integer): integer;
begin
   result:=-1;
   if ((id<0) or (id>=count)) then exit;
   result:=length(items[id].buffer);
end;




procedure TUnitItems.addInBuffer(id: integer ; val: TreportArrUnit);
var j,k: integer;
    temp: array of TreportArrUnit;
begin

   if ((id<0) or (id>=count)) then exit;
   k:=length(items[id].buffer);

   for j:=0 to length(items[id].buffer)-1 do
     begin
        if (items[id].buffer[j].dt=val.dt) then begin items[id].buffer[j].val:=val.val; exit; end;
        if  (items[id].buffer[j].dt>val.dt) then begin k:=j; break;  end;
     end;

   setlength(temp,length(items[id].buffer));
   for j:=0 to  length(items[id].buffer)-1 do
    begin
     temp[j].dt:=items[id].buffer[j].dt;
     temp[j].val:=items[id].buffer[j].val;
    end;
   setlength(items[id].buffer,length(items[id].buffer)+1);

   for j:=0  to length(items[id].buffer)-1 do
    begin
    if j=k then
     begin
      items[id].buffer[k].dt:=val.dt;
      items[id].buffer[k].val:=val.val;
     end
     else
     begin
     if j<k then
      begin
      items[id].buffer[j].dt:=temp[j].dt;
      items[id].buffer[j].val:=temp[j].val;
      end
      else
      begin
      items[id].buffer[j].dt:=temp[j-1].dt;
      items[id].buffer[j].val:=temp[j-1].val;
      end
     end;
    end;

    setlength(temp,0);


end;

function TUnitItems.getFromBuffer(id: integer): TreportArrUnit;
var temp: array of TreportArrUnit;
    j: integer;
begin
  setlength(temp,length(items[id].buffer));
   for j:=0 to  length(items[id].buffer)-1 do
    begin
     temp[j].dt:=items[id].buffer[j].dt;
     temp[j].val:=items[id].buffer[j].val;
    end;
  result:= temp[0];
  setlength(items[id].buffer, length(items[id].buffer)-1);

  for j:=0 to  length(items[id].buffer)-1 do
    begin
     items[id].buffer[j].dt:=temp[j+1].dt;
     items[id].buffer[j].val:=temp[j+1].val;
    end;
  setlength(temp,0);
end;

function  TUnitItems.GetTyp(id: integer): integer;
begin
   result:=items[id].typ;
end;


function  TUnitItems.GetDeep(id: integer): integer;
begin
  result:=items[id].deep;
end;


function  TUnitItems.GetDelt(id: integer): integer;
begin
  result:=items[id].delt;
end;

function  TUnitItems.GetVal(id: integer): real;
begin
   result:=frtitems[Items[id].id[0]].ValReal;
end;

procedure  TUnitItems.SetVal(id: integer; vals: real);
begin
   frtitems[Items[id].id[0]].ValReal:=vals;
end;

procedure  TUnitItems.SetCurVal(id: integer; val: string; ue_: string; tm_: string);
var l: integer;
    tempval: real;
    valcorrect: boolean;
begin
   items[id].device_val:=val;
   items[id].device_ue:=ue_;
   items[id].device_tm:=tm_;
   valcorrect:=DevValtoRtitemVal(val,items[id].uiType,tempval);
   for l:=0 to length(items[id].ID)-1 do
     begin
       if valcorrect then
         frtitems.SetVal(items[id].ID[l],tempval,100)
       else  frtitems.ValidOff(items[id].ID[l]);
     end;
end;


function  TUnitItems.GetTag(id: integer): string;
begin
   result:=Items[id].name;
end;

function  TUnitItems.GetRtid(id: integer): integer;
begin
  result:=Items[id].id[0];
end;

function  TUnitItems.GetTabTime(id: integer): TdateTime;
begin
   result:=frtitems[Items[id].id[0]].TimeStamp;
end;

procedure  TUnitItems.SetTabTime(id: integer; val: TdateTime);
begin
   frtitems[Items[id].id[0]].TimeStamp:=val;
   Items[id].tmreq:=GetTimeReqByTabTime(val,Typ[id],0) ;
end;


function  TUnitItems.GetReqTime1(id: integer): TdateTime;
var vdt: TDateTime;
    tmp: integer;
begin

   case Typ[id]of
     REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
       tmp:=-1;
     else tmp:=0;
   end;
   vdt:=frtitems[Items[id].id[0]].TimeStamp;
   vdt:=incPeriod(typ[id],vdt,tmp);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[id],delt[id]);
   case Typ[id]of
     REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
       result:=incminute (result, 1);
     else result:=result;
   end;
end;

function  TUnitItems.GetReqTime2(id: integer): TdateTime;
var vdt: TDateTime;
    l,tmp: integer;
begin

   case Typ[id]of
     REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
       tmp:=2;
     else tmp:=1;
   end;
   vdt:=frtitems[Items[id].id[0]].TimeStamp;
   for l:=0 to archblocksize-tmp do
   begin
   if (incPeriod(typ[id],vdt,1)<now) then
     vdt:=incPeriod(typ[id],vdt,1)
   else
     break;
   end;
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[id],delt[id]);
   result:=incminute (result, 1);
   //result:=min(result,incminute (incPeriod(typ[id],now,1),1));
end;



procedure TUnitItems.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
     begin
     setlength(items[i].ID,0);
     setlength(items[i].buffer,0);
     dispose(items[i]);
     end;
end;

procedure TUnitItems.SetState(id: integer; state: integer);
begin
   if items[id].reqType<>rtArchive then exit;
   case state of
       REPORT_NEEDWAIT:  frtitems[RtId[id]].ValidLevel:=REPORT_NEEDWAIT;
       REPORT_NEEDKHOWDEEP:  frtitems[RtId[id]].ValidLevel:=REPORT_NEEDKHOWDEEP;
       REPORT_DATA:       frtitems[RtId[id]].ValidLevel:=REPORT_DATA;
       REPORT_NODATA:     frtitems[RtId[id]].ValidLevel:=REPORT_NODATA;
   end;
end;

function  TUnitItems.GetState(id: integer): integer;
var res: integer;
begin
    if items[id].reqType<>rtArchive then exit;
    result:=REPORT_NOACTIVE;
    if (RtId[id]>0) then
       begin
         res:=frtitems[RtId[id]].ValidLevel;
         if (res in [REPORT_NOACTIVE,REPORT_NEEDKHOWDEEP,
         REPORT_NEEDREQUEST,REPORT_NORMAL,REPORT_NODATA,REPORT_DATA]) then
         result:=res else result:=REPORT_NOACTIVE;
       end;

end;

{*****************************TDeviceItem*********************************}

procedure TDeviceItem.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

procedure TDeviceItem.setComm(val: TLogikaComPort);
begin
    comserver:=val;
    virtualitems.ftypeReq:=typeReq;
    virtualitems.fMaxUSD:=MaxUSD;
    virtualitems.setComm(val,fslavenum, fproxy);
end;

constructor TDeviceItem.Create(frtitems_: TanalogMems; groupnum: integer; AllItemsList: TStringList);
begin
    flastconnect:=0;
    id_req:=-1;
    id_inreq:=-1;
    timeoutreq:=60;
    frtitems:=frtitems_;
    funitList:=TUnitItems.Create(frtitems_);
    virtualitems:=TVirtualUnitItems.create;
    fAllItems:=AllItemsList;
    fgroupnum:=groupnum;
    inconnected:=true;
    fAllItemsList:=TStringList.Create;
    fAllItemsList.Sorted:=true;
    fAllItemsList.CaseSensitive:=false;
    fAllItemsList.Duplicates:=dupIgnore;
    ferror:=NOACTIVATE;
    finreqest:=false;
    isSync:=false;
end;

destructor TDeviceItem.destroy;
begin
   fAllItemsList.Free;
   funitList.Free;

end;

function TDeviceItem.Init: boolean;
var grn, grindex: integer;
    grname: string;
begin
   grn:=fGroupNum;
   if grn>-1 then
    begin
      grindex:=frtitems.TegGroups.GetIdxByNum(grn);
      if (grindex>-1) then
       begin
         grname:=frtitems.TegGroups.items[grindex].Name;
         grname:=trim(uppercase(grname));
         id_req:=frtitems.GetSimpleID(grname+'_REQ');
         id_inreq:=frtitems.GetSimpleID(grname+'_INREQ')
       end;

    end;
   AddGroup;

end;

function TDeviceItem.inreq: boolean;
begin
   result:= (not (ferror=ERROR_OPEN) and (inconnected)
   )
end;


function TDeviceItem.needreq: boolean;
begin
   result:=true;
   if (id_inreq<0) then
     begin
   //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
   //  frtitems.SetVal(id_req,0,0);
     exit;
     end;
   if (frtitems.Items[id_inreq].ID<0) then
     begin
   //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
   //  frtitems.SetVal(id_req,0,0);
     exit;
     end;
   if (frtitems.Items[id_inreq].ValReal>0) then
     begin
   //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
   //  frtitems.SetVal(id_req,0,0);
     exit;
     end;
   result:=false;
end;

procedure TDeviceItem.setreqOff;
begin
   if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
     frtitems.SetVal(id_req,0,100);
   funitList.setAllValidOff;
end;

procedure TDeviceItem.setreqOn;
begin
     if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
     frtitems.SetVal(id_req,1,100);

end;





function TDeviceItem.read: integer;
begin
   if flastconnect=0 then
   begin
     flastconnect:=now;
       if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
     //  frtitems.SetVal(id_req,0,0);
   end;


   if needreq then
   begin

   if not inconnected then
     begin
       if (SecondsBetween(now,flastconnect)< timeoutreq) then exit;
     end;

   result:=virtualitems.Read;
   if result>0 then
    begin
      ferror:=result;
      if SecondsBetween(now,flastconnect)>timeoutreq then
        begin
          setreqOff;
          inconnected:=false;
          flastconnect:=now;
        end;
    end else
    begin
      ferror:=0;
      if result=0 then
       begin
         flastconnect:=now;
         setreqOn;
         inconnected:=true;
       end;

    end;
   end
   else result:=0;
end;



function TDeviceItem.UnInit: boolean;
begin
   funitList.Clear;
end;

function TDeviceItem.FindIt(val: string): PTUnitItem;
var temp: integer;
begin
   result:=nil;
   temp:=0;
   temp:=fAllItemsList.Count;
   if fAllItemsList.Find(trim(val),temp) then
     begin
       result:=PTUnitItem(fAllItemsList.Objects[temp]);
     end;
end;




function TDeviceItem.AddCommand(nm: string; val: real): boolean;
var
    it: PTUnitItem;
begin
   result:=true;
   it:=FindIt(nm);
   if it<>nil then
     begin
        if virtualitems<>nil then
          begin
            virtualitems.AddCommand(it,val);
          end;
     end;
end;

function TDeviceItem.Sync: boolean;
begin
if virtualitems<>nil then
begin
    if isSync then
    virtualitems.Sync;
end;
end;

function TDeviceItem.GetNameDev: string;

begin
    result:='';
    if fGroupNum>-1 then
      if frtitems.TegGroups.GetIdxByNum(fGroupNum)>-1 then
        result:=frtitems.TegGroups.Items[frtitems.TegGroups.GetIdxByNum(fGroupNum)].Name;
end;


function TDeviceItem.getCurread: string;
begin
   result:='';
   if virtualitems<>nil then
     result:=virtualitems.curread;
end;

function TDeviceItem.getCursor: integer;
begin
   result:=-1;
   if virtualitems<>nil then
     result:=virtualitems.virtCursor;
end;

procedure TDeviceItem.AddGroup;


var i, gri,fblocksize, temp: integer;
    newit: PtUnitItem;
    text: string;
begin
   gri:=frtitems.TegGroups.GetIdxByNum(fgroupnum);
   fslavenum:=frtitems.TegGroups.items[gri].SlaveNum;

   isCom(frtitems.TegGroups.items[gri].Topic,'COM',fComSet);
   if fcomset.frt>0 then
     timeoutreq:=fcomset.frt
     else timeoutreq:=60;

   fblocksize:=fcomset.bs;

   fproxy:=fcomset.frd;

   self.isSync:=(fcomset.tstp=60);

   funitList.farchblocksize:=fcomset.pt;


   for i:=0 to frtitems.Count-1 do
     begin
        if frtitems[i].ID>-1 then
          begin
            if frtitems[i].GroupNum=fgroupnum then
              begin
                    newit:=funitList.addItem(i);
                    if ((not fAllItemsList.Find(trim(frtitems.GetName(i)),temp)) and (newit<>nil)) then
                    begin
                    fAllItems.AddObject(trim(frtitems.GetName(i)),Tobject(self));
                    fAllItemsList.AddObject(trim(frtitems.GetName(i)),Tobject(newit));
                    end;
              end;
          end;
     end;
     virtualitems.proxy:=fproxy;
     virtualitems.setUnitItems(funitList,fblocksize);

    { text:='';
   for i:=0 to funitList.Count-1 do
     begin
     //  funitList.items[i].chanalNum
       text:=text+inttostr(i)+' item: ty:='+ inttostr(integer(funitList.items[i].reqType))+', ch:='+
       inttostr(funitList.items[i].chanalNum)+', par:='+inttostr(funitList.items[i].paramNum)+', ind:='+
       inttostr(funitList.items[i].index)+', utip:='+ inttostr(integer(funitList.items[i].uiType))+char(13);
     end;
   showmessage(text);
   text:='';
   for i:=0 to virtualitems.Count-1 do
     begin
     //  funitList.items[i].chanalNum
       text:=text+inttostr(i)+'+i item: ty:='+ inttostr(integer(virtualitems.items[i].reqType_))+', start:='+
       inttostr(virtualitems.items[i].start_ind)+', stop:='+inttostr(virtualitems.items[i].stop_ind)+char(13);
     end;
  //showmessage(text);    }
end;



{*****************************TDeviceItems*********************************}


constructor TDeviceItems.Create(frtitems_: TanalogMems; comnum: integer; comset: TComSet);
begin
 inherited create;
 fAllItemsList:=TStringList.Create;
 fAllItemsList.Sorted:=true;
 fAllItemsList.CaseSensitive:=false;
 fAllItemsList.Duplicates:=dupIgnore;
 currenread:=0;
 fconnected:=false;
 frtitems:=frtitems_;
 fcomnum:=comnum;
 comserver:=TLogikaComPort.Create(nil,comset);
 comserver.setComset(comset);
end;

destructor TDeviceItems.destroy;
begin
 frtitems.free;
 inherited destroy;
 fAllItemsList.free;
end;



procedure TDeviceItems.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;


procedure TDeviceItems.NeedRequestItemArchAll;
var i: integer;
begin
  for i:=0 to count -1 do
   items[i].virtualitems.NeedRequestItemArchAll;
end;

procedure TDeviceItems.SetItem(id: integer; item: TDeviceItem);
begin
  Items[id] := item;
end;

function  TDeviceItems.GetItem(id: integer):  TDeviceItem;
begin
  result := inherited Items[id];
end;

procedure TDeviceItems.resetInread;
var i: integer;
begin
for i:=0 to count-1 do
      items[i].finReqest:=false;
end;

function TDeviceItems.Open: boolean;
var i: integer;
begin
   result:=false;
   try
   if ftypeReq=ntAPS then
       comserver.fcomset.pt:=0
   else comserver.fcomset.pt:=4;
   comserver.Open;
   fconnected:=true;
   result:=true;
   for i:=0 to count-1 do
      items[i].setComm(comserver);
   for i:=0 to count-1 do
      items[i].ferror:=0;
   except
    for i:=0 to count-1 do
      items[i].ferror:=ERROR_OPEN;
    log('Не удалось открыть Com порт '+ inttostr(self.fcomnum),_DEBUG_ERROR);
   end;
end;

function TDeviceItems.Close: boolean;
var i: integer;
begin
  try
   comserver.Close;
   fconnected:=false;
   for i:=0 to count-1 do
      items[i].ferror:=NOACTIVATE;
  except
     log('Не удалось закрыть Com порт '+ inttostr(self.fcomnum),_DEBUG_ERROR);
  end;
end;

procedure TDeviceItems.setreqOff;
var i: integer;
begin
     for i:=0 to count-1 do
      items[i].setreqOff;
end;


function TDeviceItems.FindIt(val: string): TDeviceItem;
var temp: integer;
begin
   result:=nil;
   if fAllItemsList.Find(trim(val),temp) then
     begin
       result:=TDeviceItem(fAllItemsList.Objects[temp]);
     end;
end;

function TDeviceItems.AddCommand(nm: string; val: real): boolean;
var
    it: TDeviceItem;
begin
   result:=false;
   it:=FindIt(nm);
   if it<>nil then
     begin
        if (it is TDeviceItem) then
          begin
             result:=it.AddCommand(nm,val);
          end;
     end;
end;

function TDeviceItems.Sync: boolean;
var
    i: integer;
begin
   result:=true;
   for i:=0 to self.count-1 do
     begin
        items[i].sync;
     end;
end;

function TDeviceItems.inReq: boolean;
var i: integer;
begin
   result:=false;
   for i:=0 to count-1 do
    if items[i].inreq then
      begin
      result:=true;
      exit;
      end;
end;

function TDeviceItems.Init: boolean;
var i,temComNum: integer;
    ComSet: TComSEt;
    DI: TDeviceItem;
begin
  // trim(uppercase(frtitems.TegGroups.Items[i].App));
   for i:=0 to frtitems.TegGroups.Count-1 do
     begin
        if (trim(uppercase(frtitems.TegGroups.Items[i].App))='LOGIKASERV') then
          begin
            temComNum:=isCom(frtitems.TegGroups.Items[i].Topic,'COM',ComSet);
            if (ComSet.db>0) and (ComSet.db<30) then fMaxUSD:=ComSet.db
            else fMaxUSD:=29;
            if ComSet.sb=0 then ftypeReq:=ntDirect else ftypeReq:=ntAPS;
            if (temComNum=fcomnum) then
              begin
     // !!! на время теста         // if FindBySlave(frtitems.TegGroups.Items[i].SlaveNum)<0 then
                  begin
                    DI:=TDeviceItem.Create(frtitems,frtitems.TegGroups.Items[i].Num, fAllItemsList);
                    DI.ftypeReq:=ftypeReq;
                    DI.fMaxUSD:=fMaxUSD;
                    self.Add(DI);
                    DI.Init;
                  end
    //            else
    //              log('Ошибка при добавлении группы '+
     //             frtitems.TegGroups.Items[i].Name+' в опрос. Неверный slave.',_DEBUG_ERROR);
              end;
          end;
     end;
end;

function TDeviceItems.readDev: boolean;
begin
  if not fconnected then begin result:=false; exit; end;
  resetInread;
  items[currenread].read;
  items[currenread].finReqest:=true;
  NeedRequestItemArchAll;
  currenread:=currenread+1;
  if currenread>=count then currenread:=0;
  result:=inreq;
end;

function TDeviceItems.synctime: boolean;
begin
  if not fconnected then begin result:=false; exit; end;
  result:=true;
end;

function TDeviceItems.UnInit: boolean;
var i: integer;
begin
   for i:=0 to count-1 do
    items[i].UnInit;
end;


function TDeviceItems.FindBySlave(slave: integer): integer;
var i: integer;
begin
  result:=-1;
  for i:=0 to count-1 do
    begin
      if (items[i].fslavenum=slave) then
        result:=i;
    end;
end;




{*****************************TVirtualUnitItems*********************************}
constructor TVirtualUnitItems.create;
begin
   inherited create;
end;

procedure  TVirtualUnitItems.setUnitItems(unitList: TUnitItems; bs: integer);
begin
     fblocksize:=bs;
     mainlist:=unitList;
     Init;
end;

procedure TVirtualUnitItems.freeitem_;
var i: integer;
begin
   for i:=0 to count-1 do
     dispose(items[i]);
   clear;
end;

function TVirtualUnitItems.getblocksize: integer;
begin
  if (fblocksize>0) and  (fblocksize<121)
   then
   begin
     result:=fblocksize;
     exit;
   end;
   result:=5;
end;



destructor TVirtualUnitItems.destroy;
begin
   freeitem_;
   inherited;
end;

procedure TVirtualUnitItems.SetItem(id: integer; item: PTVirtualUnitItem);
begin
    Items[id] := item;
end;

function  TVirtualUnitItems.GetItem(id: integer): PTVirtualUnitItem;
begin
    result := inherited Items[id];
end;

procedure  TVirtualUnitItems.Init;
var i, blocksize   // размер блока
  , mincur, maxcur, // минимальный и максимальный индекс текущих в mainlist (он сортирован, они вначале)
  curind, tempcurind           // текущий при подстановке в ряд архивных и массивов
  : integer;
    it: PTVirtualUnitItem;
    lasttype: TItemReqType;
    lastch_,lastnum_, tempi, maxread_: integer;
begin
   if mainlist=nil then exit;
   blocksize:=0;
   mincur:=-1;    ///  индексы max и мин текущих данных
   maxcur:=-1;
 //  parindex:=-1;
   curind:=-1;
   lasttype:=rtCurrent;
   maxread_:=_blocksize-1;
   if maxread_<0 then maxread_:=0;
   for i:=0 to mainlist.Count-1 do
     begin
       if (mincur=-1) and (mainlist.items[i].reqType=rtCurrent) then
         mincur:=i;   // подсчет минимальной позиции текущих
       if (maxcur<i) and (mainlist.items[i].reqType=rtCurrent) then
         maxcur:=i;   // подсчет максимальной позиции текущих

       if lasttype<>mainlist.items[i].reqType then
         begin
         blocksize:=0;
       // при смене типа обнуляем размер блока
         if (lasttype=rtCurrent) and (curind<0) then
           //eсли сменился тип и последним был текущий инициализирум счетчик текущего
           curind:=mincur;
         end;

       if  blocksize=0 then
         begin

           case mainlist.items[i].reqType of
             rtArchive:
                begin
                  //  архивная порождает одну витуальную архивную и блок текущей за собой
                  new(it);
                  it.start_ind:=i;
                  it.stop_ind:=i;
                  it.reqType_:=rtArchive;
                  Add(it);
                  if curind>-1 then
                   begin
                     new(it);
                     tempcurind:=curind+maxread_; // конещ блока текущих
                     tempcurind:=min(maxcur,tempcurind);
                     it.start_ind:=curind;
                     it.stop_ind:=tempcurind;
                     it.reqType_:=rtCurrent;
                     curind:=tempcurind+1;    // следующий блок текущих
                     if curind>maxcur then curind:=0; // если блок переполнен в ноль
                     add(it);
                   end;
                   blocksize:=0; //
                end;
             rtArray:      // стартуем виртуальный элемент массив
                begin
                  new(it);
                  it.start_ind:=i;
                  it.stop_ind:=i;
                  it.reqType_:=rtArray;
                  Add(it);
                  blocksize:=1;
                end;
             rtCurrent:   // стартуем виртуальный элемент текущих
                begin
                  new(it);
                  it.start_ind:=i;
                  it.stop_ind:=i;
                  it.reqType_:=rtCurrent;
                  Add(it);
                  blocksize:=1;
                end
         end
         end
         else
         begin
          case mainlist.items[i].reqType of
             rtCurrent:       //  следим за текущей если вписывается в размер блока,
                begin         // если входит в блок - продолжаем, нет - начинаем новый
                 if blocksize<=maxread_
                 then
                   begin
                   PTVirtualUnitItem(last).stop_ind:=i;     // продолжаем
                   blocksize:=blocksize+1;
                   end
                 else
                 begin
                  new(it);                       // стартуем новый  элемент текущих
                  it.start_ind:=i;
                  it.stop_ind:=i;
                  it.reqType_:=rtCurrent;
                  Add(it);
                  blocksize:=1;
                 end;
                end;
              rtArray:  //  следим за массивом если вписывается в размер блока и принадлежит
                begin   //  тому же каналу и номеру - продолжаем, нет - добавляем блок текущих и стартуем новый
                 tempi:=PTVirtualUnitItem(last).start_ind;
                 tempi:=mainlist.items[tempi].index; // индекс элемента в начале блока
                 if ({blocksize}(mainlist.items[i].index-tempi)<=maxread_) and
                   ((lastch_=mainlist.items[i].chanalNum) and (lastnum_=mainlist.items[i].paramNum))
                 then
                 begin
                 PTVirtualUnitItem(last).stop_ind:=i;   // продолжаем
                 blocksize:=blocksize+1;
                 end
                 else
                 begin
                  // вписываем блок текущих
                  if curind>-1 then
                   begin
                     new(it);
                     tempcurind:=curind+maxread_;
                     tempcurind:=min(maxcur,tempcurind);
                     it.start_ind:=curind;
                     it.stop_ind:=tempcurind;
                     it.reqType_:=rtCurrent;
                     curind:=tempcurind+1;      // следующий блок текущих
                     if curind>maxcur then curind:=0; // если блок переполнен в ноль
                     Add(it);
                   end;

                   new(it);              // стартуем виртуальный элемент массив
                   it.start_ind:=i;
                   it.stop_ind:=i;
                   it.reqType_:=rtArray;
                   Add(it);
                   blocksize:=1;

                 end;
                end;

              rtArchive:       // можем прийти сюда только после конца текущих
                 begin         // добавляем виртуальный архивный элемент  и вписываем  текущий
                  new(it);     //  .... 3.01 теперь похоже не приходим
                  it.start_ind:=i;
                  it.stop_ind:=i;
                  it.reqType_:=rtArchive;
                  Add(it);
                  if curind>-1 then
                   begin
                     new(it);
                     tempcurind:=curind+maxread_;
                     tempcurind:=min(maxcur,tempcurind);
                     it.start_ind:=curind;
                     it.stop_ind:=tempcurind;
                     it.reqType_:=rtCurrent;
                     curind:=tempcurind+1;
                     if curind>maxcur then curind:=0;
                     add(it);
                   end;
                   blocksize:=0;
                end;

         end;
       end;
      lasttype:=PTVirtualUnitItem(last).reqType_;
      lastch_:=mainlist.items[i].chanalNum;
      lastnum_:=mainlist.items[i].paramNum;
     end;
end;

function  TVirtualUnitItems.GetNeedReq(id: integer): boolean;
var i: integer;
begin
    result:=true;
    case items[id].reqType_ of
       rtCurrent,rtArray:  // если  текущая проверяем количество ссылок для каждого элемента в блоке
         begin
            result:=false;
            for i:=items[id].start_ind to items[id].stop_ind  do
               if mainlist.refCount[i]>0 then
                 begin
                   result:=true;
                   exit;
                 end;
         end;
       rtArchive:
         begin
           i:=items[id].start_ind;
           if mainlist.NeedRequestItemArch(i) then
            result:=true else
            result:=false;
         end;
   end;
 //  result:=false;
end;


// в отличие от GetNeedReq не меняет состояния эдлементов(для анализа)
function  TVirtualUnitItems.GetNeedReq_(id: integer): boolean;
var i: integer;
begin
    result:=true;
    case items[id].reqType_ of
       rtCurrent,rtArray:  // если  текущая проверяем количество ссылок для каждого элемента в блоке
         begin
            result:=false;
            for i:=items[id].start_ind to items[id].stop_ind  do
               if mainlist.refCount[i]>0 then
                 begin
                   result:=true;
                   exit;
                 end;
         end;
       rtArchive:
         begin
           i:=items[id].start_ind;
           if mainlist.NeedRequestItemArch_(i) then
            result:=true else
            result:=false;
         end;
   end;
 //  result:=false;
end;


procedure  TVirtualUnitItems.CheckArch;
var i: integer;
begin
   for i:=0 to count-1 do
   if items[i].reqType_=rtArchive then
     mainlist.NeedRequestItemArch(items[i].start_ind );
end;



function  TVirtualUnitItems.ReadItem(id: integer): integer;
var outstr,instr: string;

begin


  if self.comserver=nil  then
    begin
     self.mainlist.Log('Порт не установлен',_DEBUG_ERROR);
    end;
  CheckArch;
  result:=0;
  case items[id].reqType_ of
    rtCurrent:
      begin
        outstr:=GetComMessageCurr(id);
        if outstr='' then exit;
        result:=comserver.LogikareadStr(slave,proxy,byte(RCURRENT),outstr,maxUsd, instr,(typeReq=ntDirect));
        if result=ANSWER_OK then
          begin
            ProccessMessageCurr(id,instr);
          end;
      end;
    rtArray:
      begin
        outstr:=GetComMessageArr(id);
        if outstr='' then exit;
        result:=comserver.LogikareadStr(slave,proxy,byte(RARRAY),outstr,maxUsd, instr,(typeReq=ntDirect));
        if result=ANSWER_OK then
          begin
            ProccessMessageArr(id,instr);
          end;
      end;
    rtArchive:
      begin
        outstr:=GetComMessageArch(id);
        if outstr='' then exit;
        result:=comserver.LogikareadStr(slave,proxy,byte(RARCH),outstr,maxUsd, instr,(typeReq=ntDirect));
        if result=ANSWER_OK then
          begin
            ProccessMessageArch(id,instr);
          end;
      end;
   end;
end;

procedure TVirtualUnitItems.NeedRequestItemArchAll; // есть что опрашивать для архивной
var i: integer;
begin
  for i:=0 to count-1 do
   if items[i].reqType_= rtArchive then
     mainlist.NeedRequestItemArch(items[i].start_ind);

end;


function  TVirtualUnitItems.virtCursor: integer;
var trmpcount,vcur: integer;
    fl: boolean;
begin
 trmpcount:=0;
 fl:=true;
 result:=-1;
 vcur:=cursor;
 if vcur>=count then vcur:=0;
 while (trmpcount<count) and (fl) do
   begin
     if GetNeedReq(vcur) then
      begin
         result:=vcur;
         exit;

      end else
      begin
         if vcur>=count then vcur:=0;
         if (items[vcur].reqType_ in [rtArray, rtArchive]) then
          begin
            vcur:=vcur+2;
            if vcur>=count then vcur:=0;
            trmpcount:=trmpcount+2;
          end else
          begin
            vcur:=vcur+1;
            if cursor>=count then vcur:=0;
            trmpcount:=trmpcount+1;
          end
      end;
   end;
   if vcur>=count then vcur:=0;
   //  если ничего не сделано возвращает -1;
end;


function  TVirtualUnitItems.Curread: string;
var vcur: integer;
begin
 result:='';
 vcur:=virtCursor;
 if vcur<0 then exit;
 case items[vcur].reqType_  of
   rtArray: result:='arr: ';
   rtArchive: result:='arch:';
   else result:='curr:';
 end;

 case items[vcur].reqType_  of
   rtArray: result:=result+'ch'+inttostr(mainlist.items[items[vcur].start_ind].chanalNum)
               +'num'+inttostr(mainlist.items[items[vcur].start_ind].paramNum)+
               'i1'+inttostr(mainlist.items[items[vcur].start_ind].index)+
               'ik'+inttostr(mainlist.items[items[vcur].stop_ind].index)+': '+
               mainlist.items[items[vcur].start_ind].name+'-'+mainlist.items[items[vcur].stop_ind].name;
   rtArchive:  result:=result+'ch'+inttostr(mainlist.items[items[vcur].start_ind].chanalNum)
               +'num'+inttostr(mainlist.items[items[vcur].start_ind].paramNum)+ ': '+
               mainlist.items[items[vcur].start_ind].name;
   else result:=result+'ch'+inttostr(mainlist.items[items[vcur].start_ind].chanalNum)
               +'num'+inttostr(mainlist.items[items[vcur].start_ind].paramNum)+ ' - '+
               'ch'+inttostr(mainlist.items[items[vcur].stop_ind].chanalNum)
               +'num'+inttostr(mainlist.items[items[vcur].stop_ind].paramNum)+
               mainlist.items[items[vcur].start_ind].name+'-'+mainlist.items[items[vcur].stop_ind].name;
  end;
end;


function  TVirtualUnitItems.Read: integer;
var trmpcount: integer;
    fl: boolean;
begin
 trmpcount:=0;
 fl:=true;
 result:=-1;
 if cursor>=count then cursor:=0;
 while (trmpcount<count) and (fl) do
   begin
     if GetNeedReq(cursor) then
      begin
         result:=ReadItem(cursor); // возвращает положительный код ошибки
         fl:=false;
         cursor:=cursor+1;
      end else
      begin
         if cursor>=count then cursor:=0;
         if (items[cursor].reqType_ in [rtArray, rtArchive]) then
          begin
            cursor:=cursor+2;
            if cursor>=count then cursor:=0;
            trmpcount:=trmpcount+2;
          end else
          begin
            cursor:=cursor+1;
            if cursor>=count then cursor:=0;
            trmpcount:=trmpcount+1;
          end
      end;
   end;
   if cursor>=count then cursor:=0;
   //  если ничего не сделано возвращает -1;
end;

procedure TVirtualUnitItems.setComm(val: TLogikaComPort; fslave: byte; fproxy: byte);
begin
    comserver:=val;
    slave:=fslave;
    proxy:=fproxy;
end;

procedure TVirtualUnitItems.setProxy(fproxy: byte);
begin

    proxy:=fproxy;
end;

function TVirtualUnitItems.GetComMessageCurr(id: integer): string;  // сообщение в порт для текущих
var i: integer;
begin
  result:='';
  for i:=items[id].start_ind to items[id].stop_ind do
   begin
      if mainlist.refCount[i]>0 then
        result:=result+HT+inttostr(mainlist.items[i].chanalNum)+HT+inttostr(mainlist.items[i].paramNum)+FF;
   end;
   if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;

function  TVirtualUnitItems.GetComMessageArr(id: integer): string;  // сообщение в порт для массивов
var i: integer;
     istop, icount: integer;
begin
  result:='';
  i:=items[id].start_ind;
  istop:=items[id].stop_ind;
  icount:=mainlist.items[istop].index-mainlist.items[i].index+1;
  result:=result+HT+inttostr(mainlist.items[i].chanalNum)+HT+inttostr(mainlist.items[i].paramNum)+HT+
  inttostr(mainlist.items[i].index)+HT+inttostr(icount)
  +FF;
   if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;

function  TVirtualUnitItems.GetComMessageArch(id: integer): string;  // сообщение в порт для массивов
var i: integer;
begin
  result:='';
  i:=items[id].start_ind;
  result:=result+HT+inttostr(mainlist.items[i].chanalNum)+HT+inttostr(mainlist.items[i].paramNum)+FF+
  datetimetoDevformat(mainlist.ReqTime2[i])+datetimetoDevformat(mainlist.ReqTime1[i]);
  //showmessage(datetimetostr(mainlist.ReqTime1[i])+  '  -  ' + datetimetostr(mainlist.ReqTime2[i]));
  if (mainlist.items[i].typ=REPORTTYPE_DAY) then
  begin
  {LogDebug('logika-debug', '   ' + inttostr(mainlist.items[i].chanalNum)+'|'+inttostr(mainlist.items[i].paramNum) +
  '  :  ' + datetimetostr(mainlist.ReqTime1[i])+  '  -  ' + datetimetostr(mainlist.ReqTime2[i]));}
  if rtitems<>nil then
  rtitems.Log('   ' + inttostr(mainlist.items[i].chanalNum)+'|'+inttostr(mainlist.items[i].paramNum) +
  '  :  ' + datetimetostr(mainlist.ReqTime1[i])+  '  -  ' + datetimetostr(mainlist.ReqTime2[i]),_DEBUG_MESSAGE);
  end;
  if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;




//  запись команды
function  TVirtualUnitItems.AddCommand(It: PtUnitItem; val: real): integer;  // сообщение в порт на запись
var outstr,instr: string;

begin
  if comserver=nil then exit;
  if not comserver.Connected then exit;
  if it=nil then exit;
  case it.reqType of
    rtCurrent:
      begin
        outstr:=GetCommand(It,val);
        if outstr='' then exit;
        result:=comserver.LogikareadStr(slave,proxy,byte(WCURRENT),outstr,maxUsd, instr,(typeReq=ntDirect));
        if result=ANSWER_OK then
          begin
          //   ProccessCommand(id,instr);
          end;
      end;
     rtArray:
      begin
         outstr:=GetCommandArr(It,val);
         if outstr='' then exit;
         result:=comserver.LogikareadStr(slave,proxy,byte(WARRAY),outstr,maxUsd, instr,(typeReq=ntDirect));
         if result=ANSWER_OK then
          begin
          //   ProccessCommandArr(id,instr);
          end;
      end;
     end;
end;

function  TVirtualUnitItems.Sync: integer;  // сообщение в порт на запись
var outstr,instr: string;

begin
  if comserver=nil then exit;
  if not comserver.Connected then exit;
  outstr:=self.GetTimeC;
  result:=comserver.LogikareadStr(slave,proxy,byte(WCURRENT),outstr,maxUsd, instr,(typeReq=ntDirect));
  if result=ANSWER_OK then
          begin
          //result:=0;
          end;

  outstr:=self.GetDateC;
  result:=comserver.LogikareadStr(slave,proxy,byte(WCURRENT),outstr,maxUsd, instr,(typeReq=ntDirect));
  if result=ANSWER_OK then
          begin
        
          end;


end;



function  TVirtualUnitItems.GetCommand(It: PtUnitItem; val: real): string;  // сообщение в порт на запись
var drval: string;
begin
  result:='';
  if not RtitemValtoDevVal(val,It.uiType,drval) then exit;
  result:=result+HT+inttostr(It.chanalNum)+HT+inttostr(It.paramNum)+FF+
  HT+ Decode_Win_to_DOS(drval) + FF;
  if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;

function  TVirtualUnitItems.GetTimeC: string;  // сообщение в порт на запись
begin
  result:='';
  result:=result+HT+inttostr(0)+HT+inttostr(21)+FF+
  HT+ formatdatetime('hh-nn-ss',now()) + FF;
  if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;

function  TVirtualUnitItems.GetDateC: string;  // сообщение в порт на запись
begin
  result:='';
  result:=result+HT+inttostr(0)+HT+inttostr(20)+FF+
  HT+ formatdatetime('dd-mm-yy',now()) + FF;
  if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;

function  TVirtualUnitItems.GetCommandArr(It: PtUnitItem; val: real): string;  // сообщение в порт на запись
var drval: string;
begin
  result:='';
  if not RtitemValtoDevVal(val,It.uiType,drval) then exit;
  result:=result+HT+inttostr(It.chanalNum)+HT+inttostr(It.paramNum)+HT+inttostr(It.index)+HT+ inttostr(1)+FF+
  HT+ Decode_Win_to_DOS(drval) + FF;
  if result<>'' then result:=DLE+STX+result+DLE+ETX;
end;


function  TVirtualUnitItems.ProccessCommand(It: PtUnitItem): integer;  // сообщение в порт на запись
begin

end;

function  TVirtualUnitItems.ProccessCommandArr(It: PtUnitItem): integer;
begin

end;

function TVirtualUnitItems.ProccessMessageCurr(id: integer; val: string): integer;  // обработка сообщения из порта для текущих
var sl, valsl: TStringList;
    ch_,num_, i,  par_id: integer;
    dirval, dirue, dirtime: string;
    _getadr: boolean;

begin
  try
  _getadr:=false;
  sl:=TStringList.Create;
  GetCharPostDelimit(val,char(FF),sl);
  if sl.Count>0 then
    begin

      try
        valsl:=TStringList.Create;
        for i:=0 to sl.Count-1 do
          begin
             valsl.Clear;
             if (i mod 2)=0 then
             begin  // указатель
             GetCharPreDelimit(sl.Strings[i],char(HT),valsl);
             if valsl.Count>1 then
               begin
                  ch_:=strtointdef(valsl.Strings[0],0);
                  if valsl.Count>1 then num_:=strtointdef(valsl.Strings[1],-10);
               end;
             _getadr:=true;
             end
             else
             begin // данные
             if (_getadr) then
               begin
                 GetCharPreDelimit(sl.Strings[i],char(HT),valsl);
                 if valsl.Count>0 then
                 begin
                     dirval:=Decode_DOS_to_Win(valsl.Strings[0]);
                     if valsl.Count>1 then dirue:=Decode_DOS_to_Win(valsl.Strings[1]) else
                     dirue:='';
                     if valsl.Count>2 then dirtime:=Decode_DOS_to_Win(valsl.Strings[2]) else
                     dirtime:='';
                     par_id:=mainlist.FindItemByParam(ch_,num_,-1);
                     if par_id>-1 then
                       begin
                         mainlist.SetCurVal(par_id, dirval,dirue,dirtime);
                       end;

               end;
                _getadr:=false;
               end;
             end;
          end;
      finally
        valsl.Clear;
        valsl.Free;
      end;
    end;
  finally
  sl.Clear;
  sl.Free;
  end;
end;

function  TVirtualUnitItems.ProccessMessageArr(id: integer; val: string): integer;  // обработка сообщения из порта для массивов
var sl, valsl: TStringList;
    ch_,num_, i,par_id,par_index: integer;
    dirval, dirue, dirtime: string;
begin
  try

  sl:=TStringList.Create;
  GetCharPostDelimit(val,char(FF),sl);
  if sl.Count>1 then
    begin
      try
        valsl:=TStringList.Create;
        valsl.Clear;
        GetCharPreDelimit(sl.Strings[0],char(HT),valsl);
        if valsl.Count>1 then
               begin
                  ch_:=strtointdef(valsl.Strings[0],0);
                  if valsl.Count>1 then
                  num_:=strtointdef(valsl.Strings[1],-10);
                  par_index:=mainlist.items[items[id].start_ind].index;
               end;
        if (num_>-1) and (ch_>-1) then
        begin
          for i:=1 to sl.Count-1 do
            begin
             valsl.Clear;
             GetCharPreDelimit(sl.Strings[i],char(HT),valsl);
                 if valsl.Count>0 then
                 begin
                     dirval:=Decode_DOS_to_Win(valsl.Strings[0]);
                     if valsl.Count>1 then dirue:=Decode_DOS_to_Win(valsl.Strings[1]) else
                     dirue:='';
                     if valsl.Count>2 then dirtime:=Decode_DOS_to_Win(valsl.Strings[2]) else
                     dirtime:='';
                     par_id:=mainlist.FindItemByParam(ch_,num_,par_index);
                     if par_id>-1 then
                       begin
                         mainlist.SetCurVal(par_id, dirval,dirue,dirtime);
                       end;
                     par_index:=par_index+1;

                 end;

               end;
             end;

      finally
        valsl.Clear;
        valsl.Free;
      end;
    end;
  finally
  sl.Clear;
  sl.Free;
  end;
end;

function  TVirtualUnitItems.ProccessMessageArch(id: integer; val: string): integer;  // обработка сообщения из порта в порт для архивов
  var sl, valsl: TStringList;
    ch_,num_, i, par_id: integer;
    dirval, dirue, dirtime: string;
    au: TreportArrUnit;
   // text: string;
begin
  try
  par_id:=-1;
  sl:=TStringList.Create;
  GetCharPostDelimit(val,char(FF),sl);
  if sl.Count>1 then
    begin
      try
        valsl:=TStringList.Create;
        valsl.Clear;
        GetCharPreDelimit(sl.Strings[0],char(HT),valsl);
        if valsl.Count>1 then
               begin
                  ch_:=strtointdef(valsl.Strings[0],0);
                  if valsl.Count>1 then
                  num_:=strtointdef(valsl.Strings[1],-10);

               end;

        if (num_>-1) and (ch_>-1) then
        begin
          par_id:=mainlist.FindItemByParam(ch_,num_,-2);
            if par_id>-1 then
             begin
              if sl.Count>3 then
                begin
                  for i:=3 to sl.Count-1 do
                    begin
                    valsl.Clear;
                    GetCharPreDelimit(sl.Strings[i],char(HT),valsl);
                    if valsl.Count>0 then
                     begin
                     dirval:=Decode_DOS_to_Win(valsl.Strings[0]);
                     if valsl.Count>1 then dirue:=Decode_DOS_to_Win(valsl.Strings[1]) else
                     dirue:='';
                     if valsl.Count>2 then dirtime:=Decode_DOS_to_Win(valsl.Strings[2]) else
                     dirtime:='';
                     par_id:=mainlist.FindItemByParam(ch_,num_,-2);
                     if par_id>-1 then
                       begin
                         if getArrUnit(dirval,dirtime,au) then
                            begin
                            if (au.dt<now) then
                                mainlist.addInBuffer(par_id, au)
                            else
                              begin
                                 if rtitems<>nil then
                                     rtitems.Log('now < tm arch' ,_DEBUG_MESSAGE);
                              end;
                            end;
                       end;
                     end;

                end
             end else
                mainlist.CheckNoData(par_id);
             end;

             //  если ответ пришел, но нет данных
            // if (sl.Count<4) and (par_id>-1) then
           //    begin

             //  end;


              //  если ответ пришел, но нет данных
             end

      finally
        valsl.Clear;
        valsl.Free;
      end;
    end;
  finally
  sl.Clear;
  sl.Free;
  {for j:=0 to length(mainlist.items[par_id].buffer)-1 do
      text:=text+datetimetostr(mainlist.items[par_id].buffer[j].dt)+' : '+floattostr(mainlist.items[par_id].buffer[j].val)+ char(13);

  showmessage(text);    }
end;
end;

end.


{*****************************TLogRepItems*********************************}



{constructor TLogRepItems.Create(frtitems_: Tanalogmems);
begin
   frtitems:=frtitems_;
   finit:=false;
  // init:=true;
end;



destructor TLogRepItems.destroy;
begin
   freeitem_;
   inherited destroy;
end;

procedure TLogRepItems.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

procedure TLogRepItems.Sort;
var fl: boolean;
    i, j: integer;
begin
  // пузырьковая сортировка
  fl:=true;
  while fl do
  begin
     fl:=false;
     for i:=0 to count-2 do
      begin
        if CompareRL(items[i],items[i+1])<0
               then begin
                  fl:=true;
                  Move(i,i+1);
                  break;
                  end;
      end;
   end;

end;

function TLogRepItems.getBufferCount(i: integer): integer;
begin
   result:=-1;
   if ((i<0) or (i>=count)) then exit;
   result:=length(items[i].buffer);
end;

function TLogRepItems.NeedRequestItem(i: integer): boolean;
begin
result:=false;
if (getBufferCount(i)=0) and (state[i]=REPORT_NEEDREQUEST) then
     result:=true;
end;

function TLogRepItems.NeedRequest: boolean;
var i: integer;
begin
   result:=false;
   for i:=0 to count-1 do
     if NeedRequestItem(i) then
      begin
      result:=true;
      exit;
      end;
end;


procedure TLogRepItems.addInBuffer(i: integer ; val: TreportArrUnit);
var j,k,l: integer;
    fl: boolean;
    temp: array of TreportArrUnit;
begin
   if ((i<0) or (i>=count)) then exit;
   k:=length(items[i].buffer);
   fl:=false;
   for j:=0 to length(items[i].buffer)-1 do
     begin
        if (items[i].buffer[j].dt=val.dt) then begin items[i].buffer[j].val:=val.val; exit; end;
        if  (items[i].buffer[j].dt>val.dt) then begin fl:=true; break; k:=j end;
     end;
   setlength(temp,length(items[i].buffer));
   for j:=0 to  length(items[i].buffer)-1 do
    begin
     temp[j].dt:=items[i].buffer[j].dt;
     temp[j].val:=items[i].buffer[j].val;
    end;
   setlength(temp,length(items[i].buffer)+1);
   l:=0;
   for j:=0  to length(items[i].buffer)-2 do
    begin
    if j=k then
     begin
      temp[k].dt:=val.dt;
      temp[k].val:=val.val;
     end
     else
     begin
     if j<k then
      begin
      temp[j].dt:=temp[j].dt;
      temp[j].val:=temp[j].val;
      end
      else
      begin
      temp[j+1].dt:=temp[j].dt;
      temp[j+1].val:=temp[j].val;
      end
     end;
    end;
    setlength(temp,0);
end;

function TLogRepItems.getFromBuffer(i: integer): TreportArrUnit;
var temp: array of TreportArrUnit;
    j: integer;
begin
  setlength(temp,length(items[i].buffer));
   for j:=0 to  length(items[i].buffer)-1 do
    begin
     temp[j].dt:=items[i].buffer[j].dt;
     temp[j].val:=items[i].buffer[j].val;
    end;
  result:= temp[0];
  setlength(items[i].buffer, length(items[i].buffer)-1);

  for j:=0 to  length(items[i].buffer)-1 do
    begin
     items[i].buffer[j].dt:=temp[j+1].dt;
     items[i].buffer[j].val:=temp[j+1].val;
    end;
  setlength(temp,0);
end;


function  TLogRepItems.FindItemByParam(chanal_: longInt; num: Longint): integer;
var i,x1, x2, temp: integer;
    fl: boolean;
begin
  result := -1;
  if count=0 then exit;
  x1:=0;
  x2:=count-1;
  if CompareRL_(Items[x1],chanal_,num,-1)<0 then exit;
  if CompareRL_(Items[x2],chanal_,num,-1)>0 then exit;
  while (x1<>x2) do
    begin
      if CompareRL_(Items[x1],chanal_,num,-1)=0 then
       begin
         result:=x1;
         exit;
       end;
      if CompareRL_(Items[x2],chanal_,num,-1)=0 then
       begin
         result:=x2;
         exit;
       end;
       if (x2-x1)=1 then exit;
       temp:=(x2+x1) div 2;
       if CompareRL_(Items[temp],chanal_,num,-1)<0 then
         x2:=temp else x1:=temp;
    end;
end;

function TLogRepItems.GetItem(i: integer): PTRepLogItem;
begin
  result := inherited Items[i];
end;

procedure TLogRepItems.SetItem(i: integer; item: PTRepLogItem);
begin
  Items[i] := item;
end;



procedure TLogRepItems.addItem(id_: integer);
   var
    it: PTRepLogItem;
    typ_: integer;

    name_, source_: string;
    speriod: integer;
    ch_,num_,ind_, findid,i,j: integer;
    utyp_: TUnitItemType;
begin
   if id_<0 then exit;
   if frtitems[id_].ID<0 then exit;
   typ_:=frtitems[id_].logTime;
   name_:=frtitems.GetName(id_);
     begin
       if not (typ_ in REPORT_SET_LOGIKA ) then
         begin
             log('Архивная метка  не добавлена nm:='+frtitems.GetName(id_)+'. Не указан или некорректен период!',_DEBUG_ERROR);
             exit;
         end;
       if not checkS(trim(uppercase(frtitems.GetDDEItem(id_)))) then
          begin
           log('Mетка nm:='+frtitems.GetName(id_)+', id='+ inttostr(id_) +
            ' не добавлена. Источник '+frtitems.GetDDEItem(id_)+' содержит некорректные символы!',_DEBUG_ERROR);
            exit;
          end;
       if not GetInfo(frtitems.GetDDEItem(id_),ch_,num_,ind_,utyp_) then
            begin
               log('Архивная метка  не добавлена nm:='+frtitems.GetName(id_)+' источник source='+frtitems.GetDDEItem(id_)+
               ' Задан некорректно!',_DEBUG_ERROR);
               exit;
             end;
       findid:=FindItemByParam(ch_,num_);
       if findid>-1 then
              begin
               log('Архивная метка  не добавлена nm:='+frtitems.GetName(id_)+' источник source='+frtitems.GetDDEItem(id_)+
               ' Имеет дупликат!',_DEBUG_ERROR);
               exit;
             end;

       begin
               new(it);
               it.rtid:=id_;
               it.chanalNum:=ch_;
               it.paramNum:=num_;
               it.uiType:=utyp_;
               it.index:=-1;
               it.name:=name_;
               it.typ:=typ_;
               it.lasttime:=0;
               it.active:=false;
               setlength(it.buffer,0);
               it.delt:= round(frtitems[id_].minRaw);
               log('Архивная  метка добавлена nm:='+frtitems.GetName(id_)+', source='+frtitems.GetDDEItem(id_)+', id='+
               inttostr(id_) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
               Add(it);
               Sort;
      end

     end;


end;

{function TLogRepItems.Add_(it: PTRepLogItem): boolean;
var
  SV: PTRepLogItem;
  i: integer;
begin
  result:=false;
  if it=nil then exit;
  if it.rtid<0 then exit;
  if findBS(it.rtid)<>nil then exit;

  for i:=0 to count-1 do
   begin
     if PTRepLogItem(items[i]).rtid>it.rtid then
      begin
       inherited Insert(i,it);
       result:=true;
       exit;
      end;
   end;
  inherited Add(it);
  result := true;
end;   }

{function  TLogRepItems.GetTyp(i: integer): integer;
begin
   result:=items[i].typ;
end;


function  TLogRepItems.GetDeep(i: integer): integer;
begin
  result:=items[i].deep;
end;





function  TLogRepItems.GetSourcePeriod(i: integer): integer;
begin
  result:=items[i].sourceperiod;
end;

function  TLogRepItems.GetDelt(i: integer): integer;
begin
  result:=items[i].delt;
end;

function  TLogRepItems.GetVal(i: integer): real;
begin
   result:=frtitems[Items[i].rtid].ValReal;
end;

procedure  TLogRepItems.SetVal(i: integer; vals: real);
begin
   frtitems[Items[i].rtid].ValReal:=vals;
end;

function  TLogRepItems.GetTag(i: integer): string;
begin
   result:=Items[i].name;
end;

function  TLogRepItems.GetRtid(i: integer): integer;
begin
  result:=items[i].rtid;
end;







function  TLogRepItems.GetReqTime1(i: integer): TdateTime;
var vdt: TDateTime;
begin
   vdt:=frtitems[Items[i].rtid].TimeStamp;
   vdt:=incPeriod(typ[i],vdt,-1);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[i],delt[i]);
end;

function  TLogRepItems.GetReqTime2(i: integer): TdateTime;
var vdt: TDateTime;
begin
   vdt:=frtitems[Items[i].rtid].TimeStamp;
   vdt:=incPeriod(typ[i],vdt,0);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[i],delt[i]);
end;




procedure TLogRepItems.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
     dispose(items[i]);
end;




procedure TLogRepItems.SetState(i: integer; state: integer);
begin
   case state of
       REPORT_NEEDWAIT:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDWAIT;
       REPORT_NEEDKHOWDEEP:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDKHOWDEEP;
       REPORT_DATA:       frtitems[items[i].rtid].ValidLevel:=REPORT_DATA;
       REPORT_NODATA:     frtitems[items[i].rtid].ValidLevel:=REPORT_NODATA;
   end;
end;

function  TLogRepItems.GetState(i: integer): integer;
var res: integer;
begin
    result:=REPORT_NOACTIVE;
    if (items[i].rtid>0) then
       begin
         res:=frtitems[items[i].rtid].ValidLevel;
         if (res in [REPORT_NOACTIVE,REPORT_NEEDKHOWDEEP,
         REPORT_NEEDREQUEST,REPORT_NORMAL,REPORT_NODATA,REPORT_DATA]) then
         result:=res else result:=REPORT_NOACTIVE;
       end;

end;      }

 { type TRepLogItem   = record
      rtid: integer;
      name: string;
      typ: integer;
      lasttime: TDatetime;
      active: boolean;
      deep: integer;
      delt: integer;
      sourceperiod: integer;
      tmreq: TDateTime;
      trycount: integer;
      tmwrite: TDateTime; // время для логики write to ArchServ
      tmwait: TDateTime; // время для логики wait
      chanalNum: integer;
      paramNum: integer;
      index: integer;
      uiType: TUnitItemType;

      buffer: array of TreportArrUnit;
     end;

type
  PTRepLogItem = ^TRepLogItem;   }
