unit LogikaClasses;

interface

uses
  Classes, SysUtils, InterfaceServerU,
  Mycomms, DateUtils, ConstDef, GlobalValue,
  Windows{, debugClasses}, Messages, ConvFunc, {Globalvar,} Dialogs,
  MemStructsU, LogikaComPortU, Math;

const
  UM_UPDATEPORT = WM_USER + 1;
  groupCount = 255;

const
  MAXREAD_ITEM = 20;
  MAXPERIOD_ARCHITEM = 31;

const
  REPORT_SET_LOGIKA = [REPORTTYPE_HOUR, REPORTTYPE_DEC,
    REPORTTYPE_DAY, REPORTTYPE_MONTH, REPORTTYPE_30MIN,
    REPORTTYPE_10MIN];

type
  TUnitItemType = (uiReal, uiInteger, uiTime, uiMessage);


type
  TLogNotyfy = procedure(Sender: TObject; val: integer; val1: integer) of object;

// тип тега опроса
// текущие данные, массив, архив
type
  TItemReqType = (rtCurrent, rtArray, rtArchive);

type
  TNetType = (ntAPS, ntDirect);

type
  TreportArrUnit = record
    dt: TDateTime;
    val: real;
  end;

// единица опроса для текущих данных
type
  TUnitItem = record
    Name: string;
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
    device_ue: string;
    device_tm: string;

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
    function GetItem(id: integer): PTUnitItem;
    function GetRefCount(id: integer): integer;
    procedure Log(mess: string; lev: byte = 2);
    procedure Sort;
    function getarchblocksize: integer;

    // для архивных меток
    function GetReqTime1(id: integer): TdateTime;
    function GetReqTime2(id: integer): TdateTime;
    procedure SetState(id: integer; state: integer);
    function GetState(id: integer): integer;
    function GetTyp(id: integer): integer;
    function GetDeep(id: integer): integer;
    function GetDelt(id: integer): integer;
    function GetVal(id: integer): real;
    procedure SetVal(id: integer; vals: real);
    function getBufferCount(id: integer): integer;
    function getValid(id: integer): integer;
    procedure addInBuffer(id: integer; val: TreportArrUnit);
    function getFromBuffer(id: integer): TreportArrUnit;
    function GetTag(id: integer): string;
    function GetRtid(id: integer): integer;
    function GetTabTime(id: integer): TdateTime;
    procedure SetTabTime(id: integer; val: TdateTime);
    procedure CheckNodata(id: integer);
    function isLastPeriod(id: integer): boolean;
  public
    procedure setAllValidOff;
    function NeedRequestItemArch(id: integer): boolean;
    // есть что опрашивать для архивной
    function NeedRequestItemArch_(id: integer): boolean;
    // есть что опрашивать для архивной
    function FindItemByParam(chanal_: longint; num: longint; ind: integer): integer;
      overload;
    function FindItemByParam(chanal_: longint; num: longint): integer; overload;
    function FindItemByParamArch(chanal_: longint; num: longint): integer; overload;
    property items[id: integer]: PTUnitItem read getItem write setItem; default;
    property valid[id: integer]: integer read getValid;
    property buff[id: integer]: integer read getBufferCount;
    property refCount[id: integer]: integer read getrefCount;
    function addItem(id: integer): PTUnitItem;
    procedure SetCurVal(id: integer; val: string; ue_: string; tm_: string);
    constructor Create(frtitems_: TanalogMems);
    destructor Destroy; override;

    // для архивных меток

    //время когда фактически необходим опрос
    //задействуются механизмы опроса( может расходится с TabTime
    property ReqTime1[id: integer]: TdateTime read getReqTime1; // write setReqTime;
    property ReqTime2[id: integer]: TdateTime read getReqTime2; // write setReqTime;
    property Typ[id: integer]: integer read getTyp;
    property State[id: integer]: integer read getState write setState;
    property Deep[id: integer]: integer read getDeep;
    property Val[id: integer]: real read getVal write setVal;
    property Delt[id: integer]: integer read getDelt;
    property RtId[id: integer]: integer read getRtId;
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
    function GetItem(id: integer): PTVirtualUnitItem;
    function GetNeedReq(id: integer): boolean;
    function GetNeedReq_(id: integer): boolean;
    function GetComMessageCurr(id: integer): string;  // сообщение в порт для текущих
    function GetComMessageArr(id: integer): string;  // сообщение в порт для массивов
    function GetComMessageArch(id: integer): string;  // сообщение в порт для массивов
    function ProccessMessageCurr(id: integer; val: string): integer;
    // сообщение в порт для текущих
    function ProccessMessageArr(id: integer; val: string): integer;
    // сообщение в порт для массивов
    function ProccessMessageArch(id: integer; val: string): integer;
    // сообщение в порт для массивов
    function AddCommand(It: PtUnitItem; val: real): integer;
    // сообщение в порт на запись
    function Sync: integer;
    function GetCommand(It: PtUnitItem; val: real): string;
    // сообщение в порт на запись
    function GetTimeC: string;  // сообщение в порт на запись
    function GetDateC: string;  // сообщение в порт на запись
    function GetCommandArr(It: PtUnitItem; val: real): string;
    // сообщение в порт на запись
    function ProccessCommand(It: PtUnitItem): integer;  // сообщение в порт на запись
    function ProccessCommandArr(It: PtUnitItem): integer;
    // сообщение в порт на запись
    function getblocksize: integer;
    procedure Init;
  public
    constructor Create;
    destructor Destroy;
    procedure CheckArch;
    procedure setUnitItems(unitList: TUnitItems; bs: integer);
    function virtCursor: integer;
    function Curread: string;
    procedure setProxy(fproxy: byte);
    procedure setComm(val: TLogikaComPort; fslave: byte; fproxy: byte);
    function Read: integer;
    procedure NeedRequestItemArchAll;
    function ReadItem(id: integer): integer;
    property NeedReq[id: integer]: boolean read getNeedReq;
    property items[id: integer]: PTVirtualUnitItem read getItem write setItem; default;
    property _blocksize: integer read getblocksize;
    property typeReq: TNetType read ftypeReq;
    property MaxUSD: byte read fMaxUSD;
  end;



  TDeviceItem = class(TObject)
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
    function GetNameDev: string;
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
    constructor Create(frtitems_: TanalogMems; groupnum: integer;
      AllItemsList: TStringList);
    function Init: boolean;
    function UnInit: boolean;
    procedure AddGroup;
    function Read: integer;
    destructor Destroy;
    property analizefunc: TLogNotyfy read fanalizefunc write fanalizefunc;
    property NameDev: string read getNameDev;
    property Proxy: byte read fProxy;
    property slavenum: integer read fslavenum;
    property error: integer read ferror;
    property unitList: TUnitItems read funitList;
    property ComSet: TComSEt read fComSet;
    property Curread: string read getCurread;
    property Cursor: integer read getCursor;
    property inReqest: boolean read finreqest;  // для отображения в окне
    property typeReq: TNetType read ftypeReq;
    property MaxUSD: byte read fMaxUSD;
  end;

  //PTDeviceItem = ^TDeviceItem;

  TDeviceItems = class(TList)
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
    function inReq: boolean;
    procedure SetItem(id: integer; item: TDeviceItem);
    function GetItem(id: integer): TDeviceItem;
    procedure Log(mess: string; lev: byte = 2);
    function FindBySlave(slave: integer): integer;
    procedure NeedRequestItemArchAll;
    procedure resetInread;
  public
    constructor Create(frtitems_: TanalogMems; comnum: integer; comset: TComSet);
    destructor Destroy;
    procedure setreqOff;
    function readDev: boolean;
    function synctime: boolean;
    function Open: boolean;
    function Connected: boolean;
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
function GetInfo(val: string; var chan: integer; var num: integer;
  var ind: integer; var ut: TUnitItemType): boolean;
function isCom(val: string; temp: string; var ComSet: TComSEt): integer;
function checkS(val_: string): boolean;
function CompareUI(v1: PTUnitItem; v2: PTUnitItem): integer;
function CompareUI_(v: PTUnitItem; chan: integer; num: integer; ind: integer): integer;
function GetCharPostDelimit(val: string; limitchar: char; sl: TStringList): integer;
function GetCharPreDelimit(val: string; limitchar: char; sl: TStringList): integer;
function DevValtoRtitemVal(val: string; typV: TUnitItemType; var res: real): boolean;
function RtitemValtoDevVal(val: real; typV: TUnitItemType; var res: string): boolean;
function datetimetoDevformat(val: TDateTime): string;
function getArrUnit(val: string; tm: string; var res: TreportArrUnit): boolean;
// преобразование строки полученной из контроллера в
// значение базы

implementation


function Decode_DOS_to_Win(str: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(str) do
  begin
    if ((byte(str[i]) > 128) and (byte(str[i]) <= 175)) then
      Result := Result + char(byte(str[i]) + 64)
    else if ((byte(str[i]) >= 224) and (byte(str[i]) <= 239)) then
      Result := Result + char(byte(str[i]) + 16)
    else if (byte(str[i]) = 252) then
      Result := Result + char(185)
    else
      Result := Result + str[i];
  end;

end;

function Decode_Win_to_DOS(str: string): string;
var
  i: integer;
begin
  for i := 1 to length(str) do
  begin
    if (byte(str[i]) > 128) then
      Result := Result + char(byte(str[i]) - 16)
    else if (byte(str[i]) >= 192) then
      Result := Result + char(byte(str[i]) - 64)
    else if (byte(str[i]) = 185) then
      Result := Result + char(252)
    else
      Result := Result + str[i];
  end;
end;


function datetimetoDevformat(val: TDateTime): string;
begin
  Result := formatdatetime(char(HT) + 'dd' + char(HT) + 'mm' + char(HT) + 'YY' +
    char(HT) + 'hh' + char(HT) + 'nn' + char(HT) + 'ss' + char(FF), val);
end;

function getArrUnit(val: string; tm: string; var res: TreportArrUnit): boolean;

  function deletnull(vl: string): string;
  var
    l: integer;
    fll: boolean;
  begin
    fll := False;
    Result := '';
    for l := 1 to length(vl) - 1 do
      case vl[l] of
        '1'..'9':
        begin
          Result := Result + vl[l];
          fll := True;
        end;
        '0':
        begin
          if fll then
            Result := Result + vl[l];
        end;
      end;
    if length(vl) > 0 then
      Result := Result + vl[length(vl)];
  end;

  function getDT(val_: string; var tm_: TDateTime): boolean;
  var
    tmp, yy, mm, dd, hh, nn, ss: string;
    k, rangnum, yy_: integer;
  begin
    Result := False;
    val := trim(val);
    rangnum := 0;
    tmp := '';
    for k := 1 to length(val_) do
    begin
      case val_[k] of
        '-', '/', ':':
        begin
          case rangnum of
            0: dd := tmp;
            1: mm := tmp;
            2: yy := tmp;
            3: hh := tmp;
            4: nn := tmp;
            5: ss := tmp;
          end;
          tmp := '';
          rangnum := rangnum + 1;
        end
        else
          tmp := tmp + val_[k]
      end;
    end;
    if ((tmp <> '') and (rangnum = 5)) then
      ss := tmp;
    yy := deletnull(yy);
    mm := deletnull(mm);
    dd := deletnull(dd);
    hh := deletnull(hh);
    nn := deletnull(nn);
    ss := deletnull(ss);
    if strtointdef(yy, 0) < 90 then
      yy_ := 2000 + strtointdef(yy, 0)
    else
      yy_ := strtointdef(yy, 0);
    if not ((yy <> '') and (mm <> '') and (dd <> '') and (hh <> '') and
      (nn <> '') and (ss <> '')) then
      exit;
    tm_ := EncodeDateTime(yy_, strtointdef(mm, 0), strtointdef(dd, 0),
      strtointdef(hh, 0), strtointdef(nn, 0), strtointdef(ss, 0), 0);
    tmp := datetimetostr(tm_);
    Result := True;
  end;

begin
  Result := False;
  if not DevValtoRtitemVal(val, uiReal, res.val) then
    exit;
  if not getDT(tm, res.dt) then
    exit;
  Result := True;
end;

function DevValtoRtitemVal(val: string; typV: TUnitItemType; var res: real): boolean;
var
  FormatS: TFormatSettings;
begin
  case typV of
    uiInteger:
    begin
      try
        res := round(StrToInt(val));
        Result := True;
      except
        res := 0;
        Result := False;
      end;
    end;
    uiTime:
    begin
      try
        res := secondoftheday(strtotime(val));
        Result := True;
      except
        res := 0;
        Result := False;
      end;
    end

    else
    begin
      try
        FormatS.DecimalSeparator := char('.');
        res := strtofloat(val, FormatS);
        Result := True;
      except
        res := 0;
        Result := False;
      end;
    end;
  end;
end;

function RtitemValtoDevVal(val: real; typV: TUnitItemType; var res: string): boolean;
var
  FormatS: TFormatSettings;
begin
  case typV of
    uiInteger:
    begin
      res := IntToStr(round(val));
      Result := True;
    end;
    uiTime:
    begin

      res := DateToStr(val);
      Result := True;
    end

    else
    begin

      FormatS.DecimalSeparator := char('.');
      res := floattostr(val, FormatS);
      Result := True;

    end;
  end;
end;

function isCom(val: string; temp: string; var ComSet: TComSEt): integer;

  function findValNum(val: string; str: string): integer;
  var
    pos_, i: integer;
    numstr: string;
    fl: boolean;
  begin
    fl := True;
    Result := -1000;
    numstr := '';
    val := trim(uppercase(val));
    str := trim(uppercase(str));
    pos_ := pos(val, str);
    if pos_ < 1 then
      exit;
    for i := pos_ + length(val) to length(str) do
    begin
      if fl then
      begin
        if ((str[i] = ';') or (str[i] = ',') or (str[i] = ';')) then
          fl := False
        else
          numstr := numstr + str[i];
      end;
    end;
    try
      Result := StrToInt(numstr);
    except
    end;
  end;

  function findtext(val: string; str: string): string;
  var
    pos_, i: integer;
    numstr: string;
    fl: boolean;
  begin
    fl := True;
    Result := '';
    numstr := '';
    val := trim(uppercase(val));
    str := trim(uppercase(str));
    pos_ := pos(val, str);
    if pos_ < 1 then
      exit;
    for i := pos_ + length(val) to length(str) do
    begin
      if fl then
      begin
        if ((str[i] = ';') or (str[i] = ',') or (str[i] = ';')) then
          fl := False
        else
          numstr := numstr + str[i];
      end;
    end;
    try
      Result := numstr;
    except
    end;
  end;


  function getinVstring(var val: string; pref: string): string;
  var
    valU, PrefU, preftemp: string;
    i: integer;
  begin
    val := trim(val);
    PrefU := trim(uppercase(pref));
    valU := trim(uppercase(val));
    if ((length(valU) + 3) < (length(PrefU))) then
    begin
      val := '';
      Result := '';
      exit;
    end;
    // if (pref<>'') then
    begin
      preftemp := copy(valU, 1, length(prefU) + 1);
      if ((pref + '[') = (preftemp)) then
      begin
        i := length(preftemp) + 1;
        while ((ValU[i] <> ']') and (i <= length(ValU))) do
        begin
          Result := Result + Val[i];
          i := i + 1;
        end;
        if (i < length(ValU)) then
          val := copy(val, i + 1, length(valU) - i + 1)
        else
          val := '';
      end;
    end;
  end;

var
  tempval: string;
  tempnum: integer;

begin
  Result := -1;
  ComSet.Com := 1;
  ComSet.br := 9600;
  ComSet.db := 1;       // максимальный номер прибора в сети
  ComSet.sb := 1;       //  тип соединения
  ComSet.pt := 16;      // архивный блок
  ComSet.trd := 0;
  ComSet.red := 0;
  ComSet.ri := 100;
  ComSet.rtm := 3000;
  ComSet.rtc := 3000;
  ComSet.wtm := 3000;
  ComSet.wtc := 3000;
  ComSet.bs := 5;
  ComSet.flCtrl := False;
  ComSet.frt := 60;   // таймаут на разрыв связи
  ComSet.frd := 0;   //  номер посредника
  ComSet.trc := 3;
  ComSet.tstrt := -1;
  ComSet.tstp := 61;
  ComSet.prttm := 500;
  Comset.wait := 3000;
  Comset.Name := '';
  val := trim(val);
  if val = '' then
    exit;
  tempval := trim(getinVstring(val, uppercase(temp)));

  if tempval <> '' then
  begin
    tempnum := findValNum('com', tempval);
    if tempnum > 0 then
    begin
      Result := tempnum;
      ComSet.Com := tempnum;
    end
    else
    begin
      Result := 1;
      ComSet.Com := 1;
    end;
    // com1[br9600,bd7,sb1,pt1,trd50,red50,ri300,rtm3000,rtc3000,wtm3000,wtc3000]
    tempnum := findValNum('br', tempval);
    if tempnum > 0 then
      ComSet.br := tempnum;

    tempnum := findValNum('bd', tempval);
    if (tempnum > 0) and (tempnum < 30) then
      ComSet.db := tempnum;

    tempnum := findValNum('sb', tempval);
    if (tempnum > -1) and (tempnum < 30) then
      ComSet.sb := tempnum;

    tempnum := findValNum('bs', tempval);
    if (tempnum > -1) then
      ComSet.bs := tempnum;

    tempnum := findValNum('ri', tempval);
    if (tempnum > -1) then
      ComSet.ri := tempnum;

    tempnum := findValNum('rtm', tempval);
    if (tempnum > -1) then
      ComSet.rtm := tempnum;

    tempnum := findValNum('rtc', tempval);
    if (tempnum > -1) then
      ComSet.rtc := tempnum;

    tempnum := findValNum('wtm', tempval);
    if ((tempnum > -1) or (uppercase(temp) = 'ETH')) then
      ComSet.wtm := tempnum;

    tempnum := findValNum('wtc', tempval);
    if (tempnum > -1) then
      ComSet.wtc := tempnum;

    tempnum := findValNum('frt', tempval);
    if (tempnum > -1) then
      ComSet.frt := tempnum;

    tempnum := findValNum('frd', tempval);
    if (tempnum > -1) then
      ComSet.frd := tempnum;

    tempnum := findValNum('trc', tempval);
    if (tempnum > -1) then
      ComSet.trc := tempnum;

    tempnum := findValNum('tstrt', tempval);
    if (tempnum > -1) then
      ComSet.tstrt := tempnum;
    tempnum := findValNum('tstp', tempval);
    if (tempnum > -1) then
      ComSet.tstp := tempnum;
    tempnum := findValNum('prttm', tempval);
    if (tempnum > -1) then
      ComSet.prttm := tempnum;
    tempnum := findValNum('wait', tempval);
    if (tempnum > -1) then
      ComSet.wait := tempnum;
    Comset.Name := findtext('name', tempval);

    tempnum := findValNum('pt', tempval);
    if (tempnum > -1) and (tempnum < 100) then
      ComSet.pt := tempnum;

  end;
  if ((comset.trd = 0) and (comset.red = 0)) then
    comset.flCtrl := False
  else
    comset.flCtrl := True;
end;

function GetCharPreDelimit(val: string; limitchar: char; sl: TStringList): integer;
var
  i: integer;
  temp: string;
  fl: boolean;
begin
  if sl = nil then
    exit;
  sl.Clear;
  fl := False;
  temp := '';
  for i := 1 to length(val) do
  begin
    if (val[i] = limitchar) then
    begin
      if (fl) then
      begin
        sl.Add(temp);
        temp := '';
      end
      else
      begin
        fl := True;
        temp := '';
      end;
    end
    else
      temp := temp + val[i];
  end;
  if fl then
    sl.Add(temp);
end;

function GetCharPostDelimit(val: string; limitchar: char; sl: TStringList): integer;
var
  i: integer;
  temp: string;
begin
  if sl = nil then
    exit;
  sl.Clear;
  for i := 1 to length(val) do
  begin
    if val[i] = limitchar then
    begin
      sl.Add(temp);
      temp := '';
    end
    else
      temp := temp + val[i];
  end;
end;


function CompareUI(v1: PTUnitItem; v2: PTUnitItem): integer;
var
  vir1, vir2: integer;
begin
  // виртальная добавка служит для того чтобы в отсортированном списке
  // элементы шли по типам опросов
  // сначала все текущие, потом все архивные, потом все массивы

  if v1.index = -2 {архивные} then
    vir1 := 1000
  else
  if v1.index > -1 {массивы} then
    vir1 := 10000
  else
    {текущие} vir1 := 0;

  if v2.index = -2 {архивные} then
    vir2 := 1000
  else
  if v2.index > -1 {массивы} then
    vir2 := 10000
  else
    {текущие} vir2 := 0;

  Result := 0;
  if (v1.chanalNum + vir1) > (v2.chanalNum + vir2) then
  begin
    Result := -1;
    exit;
  end;
  if (v1.chanalNum + vir1) < (v2.chanalNum + vir2) then
  begin
    Result := 1;
    exit;
  end;
  if v1.paramNum > v2.paramNum then
  begin
    Result := -1;
    exit;
  end;
  if v1.paramNum < v2.paramNum then
  begin
    Result := 1;
    exit;
  end;
  if v1.index > v2.index then
  begin
    Result := -1;
    exit;
  end;
  if v1.index < v2.index then
  begin
    Result := 1;
    exit;
  end;
end;

function CompareUI_(v: PTUnitItem; chan: integer; num: integer; ind: integer): integer;
var
  virv, virt_: integer;
begin

  if v.index = -2 {архивные} then
    virv := 1000
  else
  if v.index > -1 {массивы} then
    virv := 10000
  else
    {текущие} virv := 0;

  if ind = -2 {архивные} then
    virt_ := 1000
  else
  if ind > -1 {массивы} then
    virt_ := 10000
  else
    {текущие} virt_ := 0;

  Result := 0;
  if (v.chanalNum + virv) > (chan + virt_) then
  begin
    Result := -1;
    exit;
  end;
  if (v.chanalNum + virv) < (chan + virt_) then
  begin
    Result := 1;
    exit;
  end;
  if v.paramNum > num then
  begin
    Result := -1;
    exit;
  end;
  if v.paramNum < num then
  begin
    Result := 1;
    exit;
  end;
  if v.index > ind then
  begin
    Result := -1;
    exit;
  end;
  if v.index < ind then
  begin
    Result := 1;
    exit;
  end;
end;


function checkS(val_: string): boolean;
var
  i: integer;
begin
  Result := False;
  val_ := trim(Uppercase(val_));
  for i := 1 to length(val_) do
    if not (val_[i] in ['C', 'H', 'I', 'N', 'T', 'Y', 'P', 'R', 'M', ':', '0'..'9']) then
      exit;
  Result := True;
end;

{
 [chN]:nMMM[:iNN][:typI]
}


function GetInfo(val: string; var chan: integer; var num: integer;
  var ind: integer; var ut: TUnitItemType): boolean;

var
  temp, i: integer;
  tempstr: string;
begin
  try
    Result := False;
    val := trim(uppercase(val));

    temp := pos('CH', val);
    chan := 0;
    num := -1;
    ind := -1;
    if temp > 0 then
    begin
      chan := -1;
      if (temp + 2) < length(val) then
      begin
        i := temp + 2;
        tempstr := '';
        while (i <= length(val)) and (val[i] <> ':') do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        chan := strtointdef(tempstr, -1);
      end;
    end;

    temp := pos('N', val);
    if temp > 0 then
    begin
      num := -1;
      if (temp + 1) <= length(val) then
      begin
        i := temp + 1;
        tempstr := '';
        while (i <= length(val)) and (val[i] <> ':') do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        num := strtointdef(tempstr, -1);
      end;
    end;

    temp := pos('I', val);
    if temp > 0 then
    begin
      ind := -1;
      if (temp + 1) <= length(val) then
      begin
        i := temp + 1;
        tempstr := '';
        while (i <= length(val)) and (val[i] <> ':') do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        ind := strtointdef(tempstr, -1);
      end;
    end;

    temp := pos('TYP', val);
    if temp > 0 then
    begin

      if (temp + 3) <= length(val) then
      begin
        i := temp + 3;
        tempstr := '';
        while (i <= length(val)) and (val[i] <> ':') do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        tempstr := trim(tempstr);
        ut := uiInteger;
        if (tempstr = 'R') then
          ut := uiReal;
        if (tempstr = 'I') then
          ut := uiInteger;
        if (tempstr = 'T') then
          ut := uiTime;
        if (tempstr = 'M') then
          ut := uiMessage;
      end;
    end;
    if (chan > -1) and (num > -1) then
      Result := True;
  except
  end;
end;

{****************************TUnitItems*****************************************}

constructor TUnitItems.Create(frtitems_: TanalogMems);
begin
  inherited Create;
  frtitems := frtitems_;
end;

destructor TUnitItems.Destroy;
begin
  self.freeitem_;
  Clear;
  inherited Destroy;
end;

//  проверяет является ли опрашиваемый период последним
//  нет -  данных отчетного и правда  не существует
//  да  -  ничего не делает, ждет данные дальше
procedure TUnitItems.CheckNodata(id: integer);
begin
  if not isLastPeriod(id) then
  begin
    frtitems.Items[items[id].ID[0]].TimeStamp := ReqTime2[id];
  end
  else
    State[id] := REPORT_NEEDWAIT;
end;


function TUnitItems.isLastPeriod(id: integer): boolean;
begin
  Result := (ReqTime2[id] > now);
end;


function TUnitItems.NeedRequestItemArch(id: integer): boolean;
  // есть что опрашивать для архивной
var
  temp: TreportArrUnit;
begin
  Result := False;
  if items[id].reqType <> rtArchive then
  begin
    log('Попытка читать обычный элемент как архивный!', _DEBUG_ERROR);
    exit;
  end;
  if (State[id] <> REPORT_NEEDREQUEST) then
    exit;
  if getBufferCount(id) > 0 then
  begin
    temp := getFromBuffer(id);
    //  если время в ответе не совпадает со временем
    //запроса
    Val[id] := temp.val;
    if temp.dt <> TabTime[id] then
      TabTime[id] := roundPeriod(typ[id], temp.dt, delt[id]);

    State[id] := REPORT_DATA;
  end
  else
    Result := True;
end;

function TUnitItems.NeedRequestItemArch_(id: integer): boolean;
  // есть что опрашивать для архивной
begin
  Result := False;

  if (State[id] <> REPORT_NEEDREQUEST) then
    exit;
  if getBufferCount(id) = 0 then
    Result := True;
end;



function TUnitItems.GetItem(id: integer): PTUnitItem;
begin
  Result := inherited Items[id];
end;

procedure TUnitItems.SetItem(id: integer; item: PTUnitItem);
begin
  Items[id] := item;
end;

function TUnitItems.GetRefCount(id: integer): integer;
var
  j: integer;
begin
  Result := 0;
  for j := 0 to length(items[id].id) - 1 do
    if items[id].id[j] > -1 then
      if frtitems.Items[items[id].id[j]].refCount > 0 then
        Inc(Result);
end;

function TUnitItems.getValid(id: integer): integer;
begin
  Result := 0;
  if (items[id].id[0] > -1) and (frtitems.Items[items[id].id[0]].ID > -1) then
    Result := frtitems.Items[items[id].id[0]].ValidLevel;
end;




function TUnitItems.FindItemByParam(chanal_: longint; num: longint): integer;
begin
  Result := FindItemByParam(chanal_, num, -1);
end;


function TUnitItems.FindItemByParamArch(chanal_: longint; num: longint): integer;
begin
  Result := FindItemByParam(chanal_, num, -2);
end;

function TUnitItems.getarchblocksize: integer;
begin
  if (farchblocksize > 0) and (farchblocksize < 32) then
  begin
    Result := farchblocksize;
    exit;
  end;
  Result := 10;
end;

function TUnitItems.FindItemByParam(chanal_: longint; num: longint;
  ind: integer): integer;

var
  x1, x2, temp: integer;

begin
  Result := -1;
  if Count = 0 then
    exit;
  x1 := 0;
  x2 := Count - 1;
  if (x1 = x2) then
  begin
    if CompareUI_(Items[x1], chanal_, num, ind) = 0 then
      Result := x1;
    exit;
  end;
  if CompareUI_(Items[x1], chanal_, num, ind) < 0 then
    exit;
  if CompareUI_(Items[x2], chanal_, num, ind) > 0 then
    exit;
  while (x1 <> x2) do
  begin
    if CompareUI_(Items[x1], chanal_, num, ind) = 0 then
    begin
      Result := x1;
      exit;
    end;
    if CompareUI_(Items[x2], chanal_, num, ind) = 0 then
    begin
      Result := x2;
      exit;
    end;
    if (x2 - x1) = 1 then
      exit;
    temp := (x2 + x1) div 2;
    if CompareUI_(Items[temp], chanal_, num, ind) < 0 then
      x2 := temp
    else
      x1 := temp;
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

function TUnitItems.addItem(id: integer): PTUnitItem;
var
  ch_, num_, ind_, findid, l: integer;
  utyp_: TUnitItemType;
  it: PTUnitItem;
  tempid: array of integer;
  typ_: integer;
  name_: string;
  reqtype: TItemReqType;
begin
  Result := nil;
  if id < 0 then
    exit;
  if frtitems[id].ID < 0 then
    exit;

  typ_ := frtitems[id].logTime;
  name_ := frtitems.GetName(id);
  //  if FindItemByName(frtitems.GetName(id))<0 then
  begin
    if not checkS(trim(uppercase(frtitems.GetDDEItem(id)))) then
    begin
      log('Mетка nm:=' + frtitems.GetName(id) + ', id=' + IntToStr(id) +
        ' не добавлена. Источник ' + frtitems.GetDDEItem(id) +
        ' содержит некорректные символы!', _DEBUG_ERROR);
    end;

    if GetInfo(frtitems.GetDDEItem(id), ch_, num_, ind_, utyp_) then
    begin

      // определяем тип метки
      if not (typ_ in REPORT_SET_LOGIKA) then
      begin
        if ind_ > -1 then
          reqtype := rtArray
        else
          reqtype := rtCurrent;
      end
      else
        reqtype := rtArchive;


      case reqtype of

        rtCurrent, rtArray:
        begin
          findid := FindItemByParam(ch_, num_, ind_);
          if findid > -1 then
          begin
            it := items[findid];
            setlength(tempid, length(it.id) + 1);
            for l := 0 to length(it.id) - 1 do
              tempid[l] := it.id[l];
            setlength(it.id, length(it.id) + 1);
            for l := 0 to length(it.id) - 2 do
              it.id[l] := tempid[l];
            it.id[length(it.id) - 1] := id;
            setlength(tempid, 0);
            // log('Продублирована метка nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
            // inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
            Result := items[findid];
          end
          else
          begin
            new(it);
            it.Name := name_;
            setlength(it.ID, 1);
            it.ID[0] := id;
            it.chanalNum := ch_;
            it.paramNum := num_;
            it.uiType := utyp_;
            it.index := ind_;
            it.typ := typ_;
            // log('Добавлена метка nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
            //   inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
            Add(it);
            it.reqType := reqtype;
            it.error := 0;
            it.minRaw := frtitems[id].MinRaw;
            it.maxRaw := frtitems[id].MaxRaw;
            it.minEU := frtitems[id].MinEU;
            it.maxEU := frtitems[id].MaxEU;
            Result := it;
            Sort;
          end;
        end;

        rtArchive:
        begin
          ind_ := -2;
          findid := FindItemByParam(ch_, num_, -2);
          if findid > -1 then
          begin
            log('Архивная метка  не добавлена nm:=' + frtitems.GetName(
              id) + ' источник source=' + frtitems.GetDDEItem(id) +
              ' Имеет дупликат!', _DEBUG_ERROR);
            exit;
          end;


          new(it);
          it.reqType := reqtype;
          setlength(it.ID, 1);
          it.ID[0] := id;
          it.chanalNum := ch_;
          it.paramNum := num_;
          it.uiType := utyp_;
          it.index := -2;
          it.Name := name_;
          it.typ := typ_;
          it.lasttime := 0;
          it.minRaw := frtitems[id].MinRaw;
          it.maxRaw := frtitems[id].MaxRaw;
          it.minEU := frtitems[id].MinEU;
          it.maxEU := frtitems[id].MaxEU;
          setlength(it.buffer, 0);
          it.delt := round(frtitems[id].AlarmConst);
          //  log('Архивная  метка добавлена nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
          //inttostr(id) + ',ch:='+inttostr(ch_)+',num='+ inttostr(num_)+',ind='+ inttostr(ind_));
          Add(it);
          it.error := 0;
          Sort;
          findid := FindItemByParam(ch_, num_, -2);
          state[findid] := REPORT_NEEDKHOWDEEP;
          Result := it;
        end;
      end;
    end
    else
      log('Mетка nm:=' + frtitems.GetName(id) + ', id=' + IntToStr(id) +
        ', ch:=' + IntToStr(ch_) + ', num=' + IntToStr(num_) +
        ' не добавлена. Источник ' + frtitems.GetDDEItem(id) + ' задан не верно!', _DEBUG_ERROR);
  end;
end;


procedure TUnitItems.Sort;
var
  fl: boolean;
  i: integer;
begin
  // пузырьковая сортировка
  fl := True;
  while fl do
  begin
    fl := False;
    for i := 0 to Count - 2 do
    begin
      if CompareUI(items[i], items[i + 1]) < 0 then
      begin
        fl := True;
        Move(i, i + 1);
        break;
      end;
    end;
  end;

end;


procedure TUnitItems.Log(mess: string; lev: byte = 2);
begin
  if frtitems <> nil then
    frtitems.Log(mess, lev);
end;

procedure TUnitItems.setAllValidOff;
var
  i, j: integer;
begin
  for i := 0 to Count - 1 do
  begin
    for j := 0 to length(items[i].ID) - 1 do
    begin
      if (items[i].ID[j] > -1) then
        if frtitems.Items[items[i].ID[j]].ID > -1 then
          if not (frtitems.Items[items[i].ID[j]].logTime in REPORT_SET) then
            frtitems.ValidOff(frtitems.Items[items[i].ID[j]].ID);
    end;
  end;
end;



function TUnitItems.getBufferCount(id: integer): integer;
begin
  Result := -1;
  if ((id < 0) or (id >= Count)) then
    exit;
  Result := length(items[id].buffer);
end;




procedure TUnitItems.addInBuffer(id: integer; val: TreportArrUnit);
var
  j, k: integer;
  temp: array of TreportArrUnit;
begin

  if ((id < 0) or (id >= Count)) then
    exit;
  k := length(items[id].buffer);

  for j := 0 to length(items[id].buffer) - 1 do
  begin
    if (items[id].buffer[j].dt = val.dt) then
    begin
      items[id].buffer[j].val := val.val;
      exit;
    end;
    if (items[id].buffer[j].dt > val.dt) then
    begin
      k := j;
      break;
    end;
  end;

  setlength(temp, length(items[id].buffer));
  for j := 0 to length(items[id].buffer) - 1 do
  begin
    temp[j].dt := items[id].buffer[j].dt;
    temp[j].val := items[id].buffer[j].val;
  end;
  setlength(items[id].buffer, length(items[id].buffer) + 1);

  for j := 0 to length(items[id].buffer) - 1 do
  begin
    if j = k then
    begin
      items[id].buffer[k].dt := val.dt;
      items[id].buffer[k].val := val.val;
    end
    else
    begin
      if j < k then
      begin
        items[id].buffer[j].dt := temp[j].dt;
        items[id].buffer[j].val := temp[j].val;
      end
      else
      begin
        items[id].buffer[j].dt := temp[j - 1].dt;
        items[id].buffer[j].val := temp[j - 1].val;
      end;
    end;
  end;

  setlength(temp, 0);

end;

function TUnitItems.getFromBuffer(id: integer): TreportArrUnit;
var
  temp: array of TreportArrUnit;
  j: integer;
begin
  setlength(temp, length(items[id].buffer));
  for j := 0 to length(items[id].buffer) - 1 do
  begin
    temp[j].dt := items[id].buffer[j].dt;
    temp[j].val := items[id].buffer[j].val;
  end;
  Result := temp[0];
  setlength(items[id].buffer, length(items[id].buffer) - 1);

  for j := 0 to length(items[id].buffer) - 1 do
  begin
    items[id].buffer[j].dt := temp[j + 1].dt;
    items[id].buffer[j].val := temp[j + 1].val;
  end;
  setlength(temp, 0);
end;

function TUnitItems.GetTyp(id: integer): integer;
begin
  Result := items[id].typ;
end;


function TUnitItems.GetDeep(id: integer): integer;
begin
  Result := items[id].deep;
end;


function TUnitItems.GetDelt(id: integer): integer;
begin
  Result := items[id].delt;
end;

function TUnitItems.GetVal(id: integer): real;
begin
  Result := frtitems[Items[id].id[0]].ValReal;
end;

procedure TUnitItems.SetVal(id: integer; vals: real);
begin
  frtitems[Items[id].id[0]].ValReal := vals;
end;

procedure TUnitItems.SetCurVal(id: integer; val: string; ue_: string; tm_: string);
var
  l: integer;
  tempval: real;
  valcorrect: boolean;
begin
  items[id].device_val := val;
  items[id].device_ue := ue_;
  items[id].device_tm := tm_;
  valcorrect := DevValtoRtitemVal(val, items[id].uiType, tempval);
  for l := 0 to length(items[id].ID) - 1 do
  begin
    if valcorrect then
      frtitems.SetVal(items[id].ID[l], tempval, 100)
    else
      frtitems.ValidOff(items[id].ID[l]);
  end;
end;


function TUnitItems.GetTag(id: integer): string;
begin
  Result := Items[id].Name;
end;

function TUnitItems.GetRtid(id: integer): integer;
begin
  Result := Items[id].id[0];
end;

function TUnitItems.GetTabTime(id: integer): TdateTime;
begin
  Result := frtitems[Items[id].id[0]].TimeStamp;
end;

procedure TUnitItems.SetTabTime(id: integer; val: TdateTime);
begin
  frtitems[Items[id].id[0]].TimeStamp := val;
  Items[id].tmreq := GetTimeReqByTabTime(val, Typ[id], 0);
end;


function TUnitItems.GetReqTime1(id: integer): TdateTime;
var
  vdt: TDateTime;
  tmp: integer;
begin

  case Typ[id] of
    REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
      tmp := -1;
    else
      tmp := 0;
  end;
  vdt := frtitems[Items[id].id[0]].TimeStamp;
  vdt := incPeriod(typ[id], vdt, tmp);
  Result :=
    GetTimeReqByTabTimeforSys(vdt, typ[id], delt[id]);
  case Typ[id] of
    REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
      Result := incminute(Result, 1);
    else
      Result := Result;
  end;
end;

function TUnitItems.GetReqTime2(id: integer): TdateTime;
var
  vdt: TDateTime;
  l, tmp: integer;
begin

  case Typ[id] of
    REPORTTYPE_MONTH, REPORTTYPE_DEC, REPORTTYPE_DAY:
      tmp := 2;
    else
      tmp := 1;
  end;
  vdt := frtitems[Items[id].id[0]].TimeStamp;
  for l := 0 to archblocksize - tmp do
  begin
    if (incPeriod(typ[id], vdt, 1) < now) then
      vdt := incPeriod(typ[id], vdt, 1)
    else
      break;
  end;
  Result :=
    GetTimeReqByTabTimeforSys(vdt, typ[id], delt[id]);
  Result := incminute(Result, 1);
  //result:=min(result,incminute (incPeriod(typ[id],now,1),1));
end;



procedure TUnitItems.freeitem_;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    setlength(items[i].ID, 0);
    setlength(items[i].buffer, 0);
    dispose(items[i]);
  end;
end;

procedure TUnitItems.SetState(id: integer; state: integer);
begin
  if items[id].reqType <> rtArchive then
    exit;
  case state of
    REPORT_NEEDWAIT: frtitems[RtId[id]].ValidLevel := REPORT_NEEDWAIT;
    REPORT_NEEDKHOWDEEP: frtitems[RtId[id]].ValidLevel := REPORT_NEEDKHOWDEEP;
    REPORT_DATA: frtitems[RtId[id]].ValidLevel := REPORT_DATA;
    REPORT_NODATA: frtitems[RtId[id]].ValidLevel := REPORT_NODATA;
  end;
end;

function TUnitItems.GetState(id: integer): integer;
var
  res: integer;
begin
  if items[id].reqType <> rtArchive then
    exit;
  Result := REPORT_NOACTIVE;
  if (RtId[id] > 0) then
  begin
    res := frtitems[RtId[id]].ValidLevel;
    if (res in [REPORT_NOACTIVE, REPORT_NEEDKHOWDEEP,
      REPORT_NEEDREQUEST, REPORT_NORMAL, REPORT_NODATA, REPORT_DATA]) then
      Result := res
    else
      Result := REPORT_NOACTIVE;
  end;

end;

{*****************************TDeviceItem*********************************}

procedure TDeviceItem.Log(mess: string; lev: byte = 2);
begin
  if frtitems <> nil then
    frtitems.Log(mess, lev);
end;

procedure TDeviceItem.setComm(val: TLogikaComPort);
begin
  comserver := val;
  virtualitems.ftypeReq := typeReq;
  virtualitems.fMaxUSD := MaxUSD;
  virtualitems.setComm(val, fslavenum, fproxy);
end;

constructor TDeviceItem.Create(frtitems_: TanalogMems; groupnum: integer;
  AllItemsList: TStringList);
begin
  flastconnect := 0;
  id_req := -1;
  id_inreq := -1;
  timeoutreq := 60;
  frtitems := frtitems_;
  funitList := TUnitItems.Create(frtitems_);
  virtualitems := TVirtualUnitItems.Create;
  fAllItems := AllItemsList;
  fgroupnum := groupnum;
  inconnected := True;
  fAllItemsList := TStringList.Create;
  fAllItemsList.Sorted := True;
  fAllItemsList.CaseSensitive := False;
  fAllItemsList.Duplicates := dupIgnore;
  ferror := NOACTIVATE;
  finreqest := False;
  isSync := False;
end;

destructor TDeviceItem.Destroy;
begin
  fAllItemsList.Free;
  funitList.Free;

end;

function TDeviceItem.Init: boolean;
var
  grn, grindex: integer;
  grname: string;
begin
  grn := fGroupNum;
  if grn > -1 then
  begin
    grindex := frtitems.TegGroups.GetIdxByNum(grn);
    if (grindex > -1) then
    begin
      grname := frtitems.TegGroups.items[grindex].Name;
      grname := trim(uppercase(grname));
      id_req := frtitems.GetSimpleID(grname + '_REQ');
      id_inreq := frtitems.GetSimpleID(grname + '_INREQ');
    end;

  end;
  AddGroup;

end;

function TDeviceItem.inreq: boolean;
begin
  Result := (not (ferror = ERROR_OPEN) and (inconnected));
end;


function TDeviceItem.needreq: boolean;
begin
  Result := True;
  if (id_inreq < 0) then
  begin
    //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
    //  frtitems.SetVal(id_req,0,0);
    exit;
  end;
  if (frtitems.Items[id_inreq].ID < 0) then
  begin
    //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
    //  frtitems.SetVal(id_req,0,0);
    exit;
  end;
  if (frtitems.Items[id_inreq].ValReal > 0) then
  begin
    //  if (id_req>-1) and (frtitems.Items[id_req].ID>-1) then
    //  frtitems.SetVal(id_req,0,0);
    exit;
  end;
  Result := False;
end;

procedure TDeviceItem.setreqOff;
begin
  if (id_req > -1) and (frtitems.Items[id_req].ID > -1) then
    frtitems.SetVal(id_req, 0, 100);
  funitList.setAllValidOff;
end;

procedure TDeviceItem.setreqOn;
begin
  if (id_req > -1) and (frtitems.Items[id_req].ID > -1) then
    frtitems.SetVal(id_req, 1, 100);

end;




function TDeviceItem.Read: integer;
begin
  if flastconnect = 0 then
    flastconnect := now;

  if needreq then
  begin

    if not inconnected then
    begin
      if (SecondsBetween(now, flastconnect) < timeoutreq) then
        exit;
    end;

    Result := virtualitems.Read;
    if Result > 0 then
    begin
      ferror := Result;
      if SecondsBetween(now, flastconnect) > timeoutreq then
      begin
        setreqOff;
        if (self.comserver.Connected) then
           self.comserver.Close;
        inconnected := False;
        flastconnect := now;
      end;
    end
    else
    begin
      ferror := 0;
      if Result = 0 then
      begin
        flastconnect := now;
        setreqOn;
        inconnected := True;
      end;
    end;
  end
  else
    Result := 0;
end;



function TDeviceItem.UnInit: boolean;
begin
  funitList.Clear;
end;

function TDeviceItem.FindIt(val: string): PTUnitItem;
var
  temp: integer;
begin
  Result := nil;
  temp := 0;
  temp := fAllItemsList.Count;
  if fAllItemsList.Find(trim(val), temp) then
  begin
    Result := PTUnitItem(fAllItemsList.Objects[temp]);
  end;
end;




function TDeviceItem.AddCommand(nm: string; val: real): boolean;
var
  it: PTUnitItem;
begin
  Result := True;
  it := FindIt(nm);
  if it <> nil then
  begin
    if virtualitems <> nil then
    begin
      virtualitems.AddCommand(it, val);
    end;
  end;
end;

function TDeviceItem.Sync: boolean;
begin
  if virtualitems <> nil then
  begin
    if isSync then
      virtualitems.Sync;
  end;
end;

function TDeviceItem.GetNameDev: string;

begin
  Result := '';
  if fGroupNum > -1 then
    if frtitems.TegGroups.GetIdxByNum(fGroupNum) > -1 then
      Result := frtitems.TegGroups.Items[frtitems.TegGroups.GetIdxByNum(fGroupNum)].Name;
end;


function TDeviceItem.getCurread: string;
begin
  Result := '';
  if virtualitems <> nil then
    Result := virtualitems.curread;
end;

function TDeviceItem.getCursor: integer;
begin
  Result := -1;
  if virtualitems <> nil then
    Result := virtualitems.virtCursor;
end;

procedure TDeviceItem.AddGroup;

var
  i, gri, fblocksize, temp: integer;
  newit: PtUnitItem;
  Text: string;
begin
  gri := frtitems.TegGroups.GetIdxByNum(fgroupnum);
  fslavenum := frtitems.TegGroups.items[gri].SlaveNum;

  isCom(frtitems.TegGroups.items[gri].Topic, 'COM', fComSet);
  if fcomset.frt > 0 then
    timeoutreq := fcomset.frt
  else
    timeoutreq := 60;

  fblocksize := fcomset.bs;

  fproxy := fcomset.frd;

  self.isSync := (fcomset.tstp = 60);

  funitList.farchblocksize := fcomset.pt;


  for i := 0 to frtitems.Count - 1 do
  begin
    if frtitems[i].ID > -1 then
    begin
      if frtitems[i].GroupNum = fgroupnum then
      begin
        newit := funitList.addItem(i);
        if ((not fAllItemsList.Find(trim(frtitems.GetName(i)), temp)) and
          (newit <> nil)) then
        begin
          fAllItems.AddObject(trim(frtitems.GetName(i)), TObject(self));
          fAllItemsList.AddObject(trim(frtitems.GetName(i)), TObject(newit));
        end;
      end;
    end;
  end;
  virtualitems.proxy := fproxy;
  virtualitems.setUnitItems(funitList, fblocksize);

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


constructor TDeviceItems.Create(frtitems_: TanalogMems; comnum: integer;
  comset: TComSet);
begin
  inherited Create;
  fAllItemsList := TStringList.Create;
  fAllItemsList.Sorted := True;
  fAllItemsList.CaseSensitive := False;
  fAllItemsList.Duplicates := dupIgnore;
  currenread := 0;
  fconnected := False;
  frtitems := frtitems_;
  fcomnum := comnum;
  comserver := TLogikaComPort.Create(nil, comset);
  comserver.setComset(comset);
end;

destructor TDeviceItems.Destroy;
begin
  frtitems.Free;
  inherited Destroy;
  fAllItemsList.Free;
end;



procedure TDeviceItems.Log(mess: string; lev: byte = 2);
begin
  if frtitems <> nil then
    frtitems.Log(mess, lev);
end;


procedure TDeviceItems.NeedRequestItemArchAll;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    items[i].virtualitems.NeedRequestItemArchAll;
end;

procedure TDeviceItems.SetItem(id: integer; item: TDeviceItem);
begin
  Items[id] := item;
end;

function TDeviceItems.GetItem(id: integer): TDeviceItem;
begin
  Result := inherited Items[id];
end;

procedure TDeviceItems.resetInread;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    items[i].finReqest := False;
end;

function TDeviceItems.Connected: boolean;
begin
   if ( not comserver.Connected) then
     result:=Open
   else
     result:=true;
end;

function TDeviceItems.Open: boolean;
var
  i: integer;
begin
  Result := False;
  try
    if ftypeReq = ntAPS then
      comserver.fcomset.pt := 0
    else
      comserver.fcomset.pt := 4;
    fconnected :=comserver.Open;
    Result := fconnected;
    for i := 0 to Count - 1 do
      items[i].setComm(comserver);
    for i := 0 to Count - 1 do
      items[i].ferror := 0;
  except
    for i := 0 to Count - 1 do
      items[i].ferror := ERROR_OPEN;
    log('Не удалось открыть Com порт ' + IntToStr(self.fcomnum), _DEBUG_ERROR);
  end;
end;

function TDeviceItems.Close: boolean;
var
  i: integer;
begin
  try
    comserver.Close;
    fconnected := False;
    for i := 0 to Count - 1 do
      items[i].ferror := NOACTIVATE;
  except
    log('Не удалось закрыть Com порт ' + IntToStr(self.fcomnum), _DEBUG_ERROR);
  end;
end;

procedure TDeviceItems.setreqOff;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    items[i].setreqOff;
end;


function TDeviceItems.FindIt(val: string): TDeviceItem;
var
  temp: integer;
begin
  Result := nil;
  if fAllItemsList.Find(trim(val), temp) then
  begin
    Result := TDeviceItem(fAllItemsList.Objects[temp]);
  end;
end;

function TDeviceItems.AddCommand(nm: string; val: real): boolean;
var
  it: TDeviceItem;
begin
  Result := False;
  it := FindIt(nm);
  if it <> nil then
  begin
    if (it is TDeviceItem) then
    begin
      Result := it.AddCommand(nm, val);
    end;
  end;
end;

function TDeviceItems.Sync: boolean;
var
  i: integer;
begin
  Result := True;
  for i := 0 to self.Count - 1 do
  begin
    items[i].sync;
  end;
end;

function TDeviceItems.inReq: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if items[i].inreq then
    begin
      Result := True;
      exit;
    end;
end;

function TDeviceItems.Init: boolean;
var
  i, temComNum: integer;
  ComSet: TComSEt;
  DI: TDeviceItem;
begin
  // trim(uppercase(frtitems.TegGroups.Items[i].App));
  for i := 0 to frtitems.TegGroups.Count - 1 do
  begin
    if (trim(uppercase(frtitems.TegGroups.Items[i].App)) = 'LOGIKASERV') then
    begin
      temComNum := isCom(frtitems.TegGroups.Items[i].Topic, 'COM', ComSet);
      if (ComSet.db > 0) and (ComSet.db < 30) then
        fMaxUSD := ComSet.db
      else
        fMaxUSD := 29;
      if ComSet.sb = 0 then
        ftypeReq := ntDirect
      else
        ftypeReq := ntAPS;
      if (temComNum = fcomnum) then
      begin
        begin
          DI := TDeviceItem.Create(frtitems, frtitems.TegGroups.Items[i].Num,
            fAllItemsList);
          DI.ftypeReq := ftypeReq;
          DI.fMaxUSD := fMaxUSD;
          self.Add(DI);
          DI.Init;
        end;
      end;
    end;
  end;
end;

function TDeviceItems.readDev: boolean;
begin
  if not fconnected then
  begin
    Result := False;
    exit;
  end;
  resetInread;
  items[currenread].Read;
  items[currenread].finReqest := True;
  NeedRequestItemArchAll;
  currenread := currenread + 1;
  if currenread >= Count then
    currenread := 0;
  Result := inreq;
end;

function TDeviceItems.synctime: boolean;
begin
  if not fconnected then
  begin
    Result := False;
    exit;
  end;
  Result := True;
end;

function TDeviceItems.UnInit: boolean;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    items[i].UnInit;
end;


function TDeviceItems.FindBySlave(slave: integer): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  begin
    if (items[i].fslavenum = slave) then
      Result := i;
  end;
end;




{*****************************TVirtualUnitItems*********************************}
constructor TVirtualUnitItems.Create;
begin
  inherited Create;
end;

procedure TVirtualUnitItems.setUnitItems(unitList: TUnitItems; bs: integer);
begin
  fblocksize := bs;
  mainlist := unitList;
  Init;
end;

procedure TVirtualUnitItems.freeitem_;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    dispose(items[i]);
  Clear;
end;

function TVirtualUnitItems.getblocksize: integer;
begin
  if (fblocksize > 0) and (fblocksize < 121) then
  begin
    Result := fblocksize;
    exit;
  end;
  Result := 5;
end;



destructor TVirtualUnitItems.Destroy;
begin
  freeitem_;
  inherited;
end;

procedure TVirtualUnitItems.SetItem(id: integer; item: PTVirtualUnitItem);
begin
  Items[id] := item;
end;

function TVirtualUnitItems.GetItem(id: integer): PTVirtualUnitItem;
begin
  Result := inherited Items[id];
end;

procedure TVirtualUnitItems.Init;
var
  i, blocksize   // размер блока
  , mincur, maxcur,
  // минимальный и максимальный индекс текущих в mainlist (он сортирован, они вначале)
  curind, tempcurind           // текущий при подстановке в ряд архивных и массивов
  : integer;
  it: PTVirtualUnitItem;
  lasttype: TItemReqType;
  lastch_, lastnum_, tempi, maxread_: integer;
begin
  if mainlist = nil then
    exit;
  blocksize := 0;
  mincur := -1;    ///  индексы max и мин текущих данных
  maxcur := -1;
  //  parindex:=-1;
  curind := -1;
  lasttype := rtCurrent;
  maxread_ := _blocksize - 1;
  if maxread_ < 0 then
    maxread_ := 0;
  for i := 0 to mainlist.Count - 1 do
  begin
    if (mincur = -1) and (mainlist.items[i].reqType = rtCurrent) then
      mincur := i;   // подсчет минимальной позиции текущих
    if (maxcur < i) and (mainlist.items[i].reqType = rtCurrent) then
      maxcur := i;   // подсчет максимальной позиции текущих

    if lasttype <> mainlist.items[i].reqType then
    begin
      blocksize := 0;
      // при смене типа обнуляем размер блока
      if (lasttype = rtCurrent) and (curind < 0) then
        //eсли сменился тип и последним был текущий инициализирум счетчик текущего
        curind := mincur;
    end;

    if blocksize = 0 then
    begin

      case mainlist.items[i].reqType of
        rtArchive:
        begin
          //  архивная порождает одну витуальную архивную и блок текущей за собой
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtArchive;
          Add(it);
          if curind > -1 then
          begin
            new(it);
            tempcurind := curind + maxread_; // конещ блока текущих
            tempcurind := min(maxcur, tempcurind);
            it.start_ind := curind;
            it.stop_ind := tempcurind;
            it.reqType_ := rtCurrent;
            curind := tempcurind + 1;    // следующий блок текущих
            if curind > maxcur then
              curind := 0; // если блок переполнен в ноль
            add(it);
          end;
          blocksize := 0;
        end;
        rtArray:      // стартуем виртуальный элемент массив
        begin
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtArray;
          Add(it);
          blocksize := 1;
        end;
        rtCurrent:   // стартуем виртуальный элемент текущих
        begin
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtCurrent;
          Add(it);
          blocksize := 1;
        end
      end;
    end
    else
    begin
      case mainlist.items[i].reqType of
        rtCurrent:       //  следим за текущей если вписывается в размер блока,
        begin         // если входит в блок - продолжаем, нет - начинаем новый
          if blocksize <= maxread_ then
          begin
            PTVirtualUnitItem(last).stop_ind := i;     // продолжаем
            blocksize := blocksize + 1;
          end
          else
          begin
            new(it);                       // стартуем новый  элемент текущих
            it.start_ind := i;
            it.stop_ind := i;
            it.reqType_ := rtCurrent;
            Add(it);
            blocksize := 1;
          end;
        end;
        rtArray:  //  следим за массивом если вписывается в размер блока и принадлежит
        begin
          //  тому же каналу и номеру - продолжаем, нет - добавляем блок текущих и стартуем новый
          tempi := PTVirtualUnitItem(last).start_ind;
          tempi := mainlist.items[tempi].index; // индекс элемента в начале блока
          if ({blocksize}(mainlist.items[i].index - tempi) <= maxread_) and
            ((lastch_ = mainlist.items[i].chanalNum) and
            (lastnum_ = mainlist.items[i].paramNum)) then
          begin
            PTVirtualUnitItem(last).stop_ind := i;   // продолжаем
            blocksize := blocksize + 1;
          end
          else
          begin
            // вписываем блок текущих
            if curind > -1 then
            begin
              new(it);
              tempcurind := curind + maxread_;
              tempcurind := min(maxcur, tempcurind);
              it.start_ind := curind;
              it.stop_ind := tempcurind;
              it.reqType_ := rtCurrent;
              curind := tempcurind + 1;      // следующий блок текущих
              if curind > maxcur then
                curind := 0; // если блок переполнен в ноль
              Add(it);
            end;

            new(it);              // стартуем виртуальный элемент массив
            it.start_ind := i;
            it.stop_ind := i;
            it.reqType_ := rtArray;
            Add(it);
            blocksize := 1;

          end;
        end;

        rtArchive:       // можем прийти сюда только после конца текущих
        begin         // добавляем виртуальный архивный элемент  и вписываем  текущий
          new(it);     //  .... 3.01 теперь похоже не приходим
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtArchive;
          Add(it);
          if curind > -1 then
          begin
            new(it);
            tempcurind := curind + maxread_;
            tempcurind := min(maxcur, tempcurind);
            it.start_ind := curind;
            it.stop_ind := tempcurind;
            it.reqType_ := rtCurrent;
            curind := tempcurind + 1;
            if curind > maxcur then
              curind := 0;
            add(it);
          end;
          blocksize := 0;
        end;

      end;
    end;
    lasttype := PTVirtualUnitItem(last).reqType_;
    lastch_ := mainlist.items[i].chanalNum;
    lastnum_ := mainlist.items[i].paramNum;
  end;
end;

function TVirtualUnitItems.GetNeedReq(id: integer): boolean;
var
  i: integer;
begin
  Result := True;
  case items[id].reqType_ of
    rtCurrent, rtArray:
      // если  текущая проверяем количество ссылок для каждого элемента в блоке
    begin
      Result := False;
      for i := items[id].start_ind to items[id].stop_ind do
        if mainlist.refCount[i] > 0 then
        begin
          Result := True;
          exit;
        end;
    end;
    rtArchive:
    begin
      i := items[id].start_ind;
      if mainlist.NeedRequestItemArch(i) then
        Result := True
      else
        Result := False;
    end;
  end;
  //  result:=false;
end;


// в отличие от GetNeedReq не меняет состояния эдлементов(для анализа)
function TVirtualUnitItems.GetNeedReq_(id: integer): boolean;
var
  i: integer;
begin
  Result := True;
  case items[id].reqType_ of
    rtCurrent, rtArray:
      // если  текущая проверяем количество ссылок для каждого элемента в блоке
    begin
      Result := False;
      for i := items[id].start_ind to items[id].stop_ind do
        if mainlist.refCount[i] > 0 then
        begin
          Result := True;
          exit;
        end;
    end;
    rtArchive:
    begin
      i := items[id].start_ind;
      if mainlist.NeedRequestItemArch_(i) then
        Result := True
      else
        Result := False;
    end;
  end;
  //  result:=false;
end;


procedure TVirtualUnitItems.CheckArch;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if items[i].reqType_ = rtArchive then
      mainlist.NeedRequestItemArch(items[i].start_ind);
end;



function TVirtualUnitItems.ReadItem(id: integer): integer;
var
  outstr, instr: string;

begin

  if self.comserver = nil then
  begin
    self.mainlist.Log('Порт не установлен', _DEBUG_ERROR);
  end;
  CheckArch;
  Result := 0;
  case items[id].reqType_ of
    rtCurrent:
    begin
      outstr := GetComMessageCurr(id);
      if outstr = '' then
        exit;
      Result := comserver.LogikareadStr(slave, proxy, byte(RCURRENT), outstr, maxUsd,
        instr, (typeReq = ntDirect));
      if Result = ANSWER_OK then
      begin
        ProccessMessageCurr(id, instr);
      end;
    end;
    rtArray:
    begin
      outstr := GetComMessageArr(id);
      if outstr = '' then
        exit;
      Result := comserver.LogikareadStr(slave, proxy, byte(RARRAY), outstr, maxUsd,
        instr, (typeReq = ntDirect));
      if Result = ANSWER_OK then
      begin
        ProccessMessageArr(id, instr);
      end;
    end;
    rtArchive:
    begin
      outstr := GetComMessageArch(id);
      if outstr = '' then
        exit;
      Result := comserver.LogikareadStr(slave, proxy, byte(RARCH), outstr, maxUsd,
        instr, (typeReq = ntDirect));
      if Result = ANSWER_OK then
      begin
        ProccessMessageArch(id, instr);
      end;
    end;
  end;
end;

procedure TVirtualUnitItems.NeedRequestItemArchAll; // есть что опрашивать для архивной
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if items[i].reqType_ = rtArchive then
      mainlist.NeedRequestItemArch(items[i].start_ind);

end;


function TVirtualUnitItems.virtCursor: integer;
var
  trmpcount, vcur: integer;
  fl: boolean;
begin
  trmpcount := 0;
  fl := True;
  Result := -1;
  vcur := cursor;
  if vcur >= Count then
    vcur := 0;
  while (trmpcount < Count) and (fl) do
  begin
    if GetNeedReq(vcur) then
    begin
      Result := vcur;
      exit;

    end
    else
    begin
      if vcur >= Count then
        vcur := 0;
      if (items[vcur].reqType_ in [rtArray, rtArchive]) then
      begin
        vcur := vcur + 2;
        if vcur >= Count then
          vcur := 0;
        trmpcount := trmpcount + 2;
      end
      else
      begin
        vcur := vcur + 1;
        if cursor >= Count then
          vcur := 0;
        trmpcount := trmpcount + 1;
      end;
    end;
  end;
  if vcur >= Count then
    vcur := 0;
  //  если ничего не сделано возвращает -1;
end;


function TVirtualUnitItems.Curread: string;
var
  vcur: integer;
begin
  Result := '';
  vcur := virtCursor;
  if vcur < 0 then
    exit;
  case items[vcur].reqType_ of
    rtArray: Result := 'arr: ';
    rtArchive: Result := 'arch:';
    else
      Result := 'curr:';
  end;

  case items[vcur].reqType_ of
    rtArray: Result := Result + 'ch' + IntToStr(
        mainlist.items[items[vcur].start_ind].chanalNum) + 'num' +
        IntToStr(mainlist.items[items[vcur].start_ind].paramNum) +
        'i1' + IntToStr(mainlist.items[items[vcur].start_ind].index) +
        'ik' + IntToStr(mainlist.items[items[vcur].stop_ind].index) + ': ' +
        mainlist.items[items[vcur].start_ind].Name + '-' +
        mainlist.items[items[vcur].stop_ind].Name;
    rtArchive: Result := Result + 'ch' + IntToStr(
        mainlist.items[items[vcur].start_ind].chanalNum) + 'num' +
        IntToStr(mainlist.items[items[vcur].start_ind].paramNum) + ': ' +
        mainlist.items[items[vcur].start_ind].Name;
    else
      Result := Result + 'ch' + IntToStr(mainlist.items[items[vcur].start_ind].chanalNum)
        + 'num' + IntToStr(mainlist.items[items[vcur].start_ind].paramNum) +
        ' - ' + 'ch' + IntToStr(
        mainlist.items[items[vcur].stop_ind].chanalNum) + 'num' +
        IntToStr(mainlist.items[items[vcur].stop_ind].paramNum) +
        mainlist.items[items[vcur].start_ind].Name + '-' +
        mainlist.items[items[vcur].stop_ind].Name;
  end;
end;


function TVirtualUnitItems.Read: integer;
var
  trmpcount: integer;
  fl: boolean;
begin
  trmpcount := 0;
  fl := True;
  Result := -1;
  if cursor >= Count then
    cursor := 0;
  while (trmpcount < Count) and (fl) do
  begin
    if GetNeedReq(cursor) then
    begin
      Result := ReadItem(cursor); // возвращает положительный код ошибки
      fl := False;
      cursor := cursor + 1;
    end
    else
    begin
      if cursor >= Count then
        cursor := 0;
      if (items[cursor].reqType_ in [rtArray, rtArchive]) then
      begin
        cursor := cursor + 2;
        if cursor >= Count then
          cursor := 0;
        trmpcount := trmpcount + 2;
      end
      else
      begin
        cursor := cursor + 1;
        if cursor >= Count then
          cursor := 0;
        trmpcount := trmpcount + 1;
      end;
    end;
  end;
  if cursor >= Count then
    cursor := 0;
  //  если ничего не сделано возвращает -1;
end;

procedure TVirtualUnitItems.setComm(val: TLogikaComPort; fslave: byte; fproxy: byte);
begin
  comserver := val;
  slave := fslave;
  proxy := fproxy;
end;

procedure TVirtualUnitItems.setProxy(fproxy: byte);
begin

  proxy := fproxy;
end;

function TVirtualUnitItems.GetComMessageCurr(id: integer): string;
  // сообщение в порт для текущих
var
  i: integer;
begin
  Result := '';
  for i := items[id].start_ind to items[id].stop_ind do
  begin
    if mainlist.refCount[i] > 0 then
      Result := Result + HT + IntToStr(mainlist.items[i].chanalNum) + HT +
        IntToStr(mainlist.items[i].paramNum) + FF;
  end;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;

function TVirtualUnitItems.GetComMessageArr(id: integer): string;
  // сообщение в порт для массивов
var
  i: integer;
  istop, icount: integer;
begin
  Result := '';
  i := items[id].start_ind;
  istop := items[id].stop_ind;
  icount := mainlist.items[istop].index - mainlist.items[i].index + 1;
  Result := Result + HT + IntToStr(mainlist.items[i].chanalNum) + HT + IntToStr(
    mainlist.items[i].paramNum) + HT + IntToStr(mainlist.items[i].index) +
    HT + IntToStr(icount) + FF;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;

function TVirtualUnitItems.GetComMessageArch(id: integer): string;
  // сообщение в порт для массивов
var
  i: integer;
begin
  Result := '';
  i := items[id].start_ind;
  Result := Result + HT + IntToStr(mainlist.items[i].chanalNum) + HT + IntToStr(
    mainlist.items[i].paramNum) + FF + datetimetoDevformat(mainlist.ReqTime2[i]) +
    datetimetoDevformat(mainlist.ReqTime1[i]);
  //showmessage(datetimetostr(mainlist.ReqTime1[i])+  '  -  ' + datetimetostr(mainlist.ReqTime2[i]));
  if (mainlist.items[i].typ = REPORTTYPE_DAY) then
  begin
  {LogDebug('logika-debug', '   ' + inttostr(mainlist.items[i].chanalNum)+'|'+inttostr(mainlist.items[i].paramNum) +
  '  :  ' + datetimetostr(mainlist.ReqTime1[i])+  '  -  ' + datetimetostr(mainlist.ReqTime2[i]));}
    if rtitems <> nil then
      rtitems.Log('   ' + IntToStr(mainlist.items[i].chanalNum) + '|' +
        IntToStr(mainlist.items[i].paramNum) + '  :  ' + datetimetostr(mainlist.ReqTime1[i]) +
        '  -  ' + datetimetostr(mainlist.ReqTime2[i]), _DEBUG_MESSAGE);
  end;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;




//  запись команды
function TVirtualUnitItems.AddCommand(It: PtUnitItem; val: real): integer;
  // сообщение в порт на запись
var
  outstr, instr: string;

begin
  if comserver = nil then
    exit;
  if not comserver.Connected then
    exit;
  if it = nil then
    exit;
  case it.reqType of
    rtCurrent:
    begin
      outstr := GetCommand(It, val);
      if outstr = '' then
        exit;
      Result := comserver.LogikareadStr(slave, proxy, byte(WCURRENT), outstr, maxUsd,
        instr, (typeReq = ntDirect));
      if Result = ANSWER_OK then
      begin
        //   ProccessCommand(id,instr);
      end;
    end;
    rtArray:
    begin
      outstr := GetCommandArr(It, val);
      if outstr = '' then
        exit;
      Result := comserver.LogikareadStr(slave, proxy, byte(WARRAY), outstr, maxUsd,
        instr, (typeReq = ntDirect));
      if Result = ANSWER_OK then
      begin
        //   ProccessCommandArr(id,instr);
      end;
    end;
  end;
end;

function TVirtualUnitItems.Sync: integer;  // сообщение в порт на запись
var
  outstr, instr: string;

begin
  if comserver = nil then
    exit;
  if not comserver.Connected then
    exit;
  outstr := self.GetTimeC;
  Result := comserver.LogikareadStr(slave, proxy, byte(WCURRENT), outstr, maxUsd,
    instr, (typeReq = ntDirect));
  {if Result = ANSWER_OK then
  begin
    //result:=0;
  end;}

  outstr := self.GetDateC;
  Result := comserver.LogikareadStr(slave, proxy, byte(WCURRENT), outstr, maxUsd,
    instr, (typeReq = ntDirect));
  if Result = ANSWER_OK then
  begin

  end;

end;



function TVirtualUnitItems.GetCommand(It: PtUnitItem; val: real): string;
  // сообщение в порт на запись
var
  drval: string;
begin
  Result := '';
  if not RtitemValtoDevVal(val, It.uiType, drval) then
    exit;
  Result := Result + HT + IntToStr(It.chanalNum) + HT + IntToStr(It.paramNum) + FF +
    HT + Decode_Win_to_DOS(drval) + FF;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;

function TVirtualUnitItems.GetTimeC: string;  // сообщение в порт на запись
begin
  Result := '';
  Result := Result + HT + IntToStr(0) + HT + IntToStr(21) + FF + HT +
    formatdatetime('hh-nn-ss', now()) + FF;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;

function TVirtualUnitItems.GetDateC: string;  // сообщение в порт на запись
begin
  Result := '';
  Result := Result + HT + IntToStr(0) + HT + IntToStr(20) + FF + HT +
    formatdatetime('dd-mm-yy', now()) + FF;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;

function TVirtualUnitItems.GetCommandArr(It: PtUnitItem; val: real): string;
  // сообщение в порт на запись
var
  drval: string;
begin
  Result := '';
  if not RtitemValtoDevVal(val, It.uiType, drval) then
    exit;
  Result := Result + HT + IntToStr(It.chanalNum) + HT + IntToStr(It.paramNum) +
    HT + IntToStr(It.index) + HT + IntToStr(1) + FF + HT + Decode_Win_to_DOS(drval) + FF;
  if Result <> '' then
    Result := DLE + STX + Result + DLE + ETX;
end;


function TVirtualUnitItems.ProccessCommand(It: PtUnitItem): integer;
  // сообщение в порт на запись
begin

end;

function TVirtualUnitItems.ProccessCommandArr(It: PtUnitItem): integer;
begin

end;

function TVirtualUnitItems.ProccessMessageCurr(id: integer; val: string): integer;
  // обработка сообщения из порта для текущих
var
  sl, valsl: TStringList;
  ch_, num_, i, par_id: integer;
  dirval, dirue, dirtime: string;
  _getadr: boolean;

begin
  try
    _getadr := False;
    sl := TStringList.Create;
    GetCharPostDelimit(val, char(FF), sl);
    if sl.Count > 0 then
    begin

      try
        valsl := TStringList.Create;
        for i := 0 to sl.Count - 1 do
        begin
          valsl.Clear;
          if (i mod 2) = 0 then
          begin  // указатель
            GetCharPreDelimit(sl.Strings[i], char(HT), valsl);
            if valsl.Count > 1 then
            begin
              ch_ := strtointdef(valsl.Strings[0], 0);
              if valsl.Count > 1 then
                num_ := strtointdef(valsl.Strings[1], -10);
            end;
            _getadr := True;
          end
          else
          begin // данные
            if (_getadr) then
            begin
              GetCharPreDelimit(sl.Strings[i], char(HT), valsl);
              if valsl.Count > 0 then
              begin
                dirval := Decode_DOS_to_Win(valsl.Strings[0]);
                if valsl.Count > 1 then
                  dirue := Decode_DOS_to_Win(valsl.Strings[1])
                else
                  dirue := '';
                if valsl.Count > 2 then
                  dirtime := Decode_DOS_to_Win(valsl.Strings[2])
                else
                  dirtime := '';
                par_id := mainlist.FindItemByParam(ch_, num_, -1);
                if par_id > -1 then
                begin
                  mainlist.SetCurVal(par_id, dirval, dirue, dirtime);
                end;

              end;
              _getadr := False;
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

function TVirtualUnitItems.ProccessMessageArr(id: integer; val: string): integer;
  // обработка сообщения из порта для массивов
var
  sl, valsl: TStringList;
  ch_, num_, i, par_id, par_index: integer;
  dirval, dirue, dirtime: string;
begin
  try

    sl := TStringList.Create;
    GetCharPostDelimit(val, char(FF), sl);
    if sl.Count > 1 then
    begin
      try
        valsl := TStringList.Create;
        valsl.Clear;
        GetCharPreDelimit(sl.Strings[0], char(HT), valsl);
        if valsl.Count > 1 then
        begin
          ch_ := strtointdef(valsl.Strings[0], 0);
          if valsl.Count > 1 then
            num_ := strtointdef(valsl.Strings[1], -10);
          par_index := mainlist.items[items[id].start_ind].index;
        end;
        if (num_ > -1) and (ch_ > -1) then
        begin
          for i := 1 to sl.Count - 1 do
          begin
            valsl.Clear;
            GetCharPreDelimit(sl.Strings[i], char(HT), valsl);
            if valsl.Count > 0 then
            begin
              dirval := Decode_DOS_to_Win(valsl.Strings[0]);
              if valsl.Count > 1 then
                dirue := Decode_DOS_to_Win(valsl.Strings[1])
              else
                dirue := '';
              if valsl.Count > 2 then
                dirtime := Decode_DOS_to_Win(valsl.Strings[2])
              else
                dirtime := '';
              par_id := mainlist.FindItemByParam(ch_, num_, par_index);
              if par_id > -1 then
              begin
                mainlist.SetCurVal(par_id, dirval, dirue, dirtime);
              end;
              par_index := par_index + 1;

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

function TVirtualUnitItems.ProccessMessageArch(id: integer; val: string): integer;
  // обработка сообщения из порта в порт для архивов
var
  sl, valsl: TStringList;
  ch_, num_, i, par_id: integer;
  dirval, dirue, dirtime: string;
  au: TreportArrUnit;
begin
  try
    par_id := -1;
    sl := TStringList.Create;
    GetCharPostDelimit(val, char(FF), sl);
    if sl.Count > 1 then
    begin
      try
        valsl := TStringList.Create;
        valsl.Clear;
        GetCharPreDelimit(sl.Strings[0], char(HT), valsl);
        if valsl.Count > 1 then
        begin
          ch_ := strtointdef(valsl.Strings[0], 0);
          if valsl.Count > 1 then
            num_ := strtointdef(valsl.Strings[1], -10);
        end;

        if (num_ > -1) and (ch_ > -1) then
        begin
          par_id := mainlist.FindItemByParam(ch_, num_, -2);
          if par_id > -1 then
          begin
            if sl.Count > 3 then
            begin
              for i := 3 to sl.Count - 1 do
              begin
                valsl.Clear;
                GetCharPreDelimit(sl.Strings[i], char(HT), valsl);
                if valsl.Count > 0 then
                begin
                  dirval := Decode_DOS_to_Win(valsl.Strings[0]);
                  if valsl.Count > 1 then
                    dirue := Decode_DOS_to_Win(valsl.Strings[1])
                  else
                    dirue := '';
                  if valsl.Count > 2 then
                    dirtime := Decode_DOS_to_Win(valsl.Strings[2])
                  else
                    dirtime := '';
                  par_id := mainlist.FindItemByParam(ch_, num_, -2);
                  if par_id > -1 then
                  begin
                    if getArrUnit(dirval, dirtime, au) then
                    begin
                      if (au.dt < now) then
                        mainlist.addInBuffer(par_id, au)
                      else
                      begin
                        if rtitems <> nil then
                          rtitems.Log('now < tm arch', _DEBUG_MESSAGE);
                      end;
                    end;
                  end;
                end;
              end;
            end
            else
              mainlist.CheckNoData(par_id);
          end;
        end

      finally
        valsl.Clear;
        valsl.Free;
      end;
    end;
  finally
    sl.Clear;
  end;
end;

end.

