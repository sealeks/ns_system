unit SETClasses;

interface

uses
  Classes, SysUtils, InterfaceServerU,
  Mycomms, DateUtils, ConstDef,
  Windows{, debugClasses}, Messages, ConvFunc, {Globalvar,} Dialogs,
  MemStructsU, SETComPortU, Math;

const
  UM_UPDATEPORT = WM_USER + 1;
  groupCount = 255;

const
  MAXREAD_ITEM = 20;
  MAXPERIOD_ARCHITEM = 31;

const
  REPORT_SET_SET = [REPORTTYPE_HOUR, REPORTTYPE_DEC,
    REPORTTYPE_DAY, REPORTTYPE_MONTH, REPORTTYPE_30MIN,
    REPORTTYPE_10MIN];

type
  TUnitItemType = (uiReal, uiInteger, uiTime, uiMessage);


type
  TLogNotyfy = procedure(Sender: TObject; val: integer; val1: integer) of object;

// ��� ���� ������
// ������� ������, ������, �����
type
  TItemReqType = (rtCurrent, rtArchive, rtInput);

type
  TNetType = (ntAPS, ntDirect);

type
  TreportArrUnit = record
    dt: TDateTime;
    val: real;
  end;

// ������� ������ ��� ������� ������
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
    tmwrite: TDateTime; // ����� ��� ������ write to ArchServ
    tmwait: TDateTime; // ����� ��� ������ wait
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



// ����������� ��������
// ���������� ������ ����������������� ������
// curr-arch1-curr-arch2....   curr-array1-curr-array2
// curr,archN,arrayN - ����� ������, ������� ����� ��������� �������


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

    // ��� �������� �����
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
    // ���� ��� ���������� ��� ��������
    function NeedRequestItemArch_(id: integer): boolean;
    // ���� ��� ���������� ��� ��������
    function FindItemByParam(chanal_: longint; num: longint; ind: integer): integer;
      overload;
    function FindItemByParam(chanal_: longint; num: longint): integer; overload;
    function FindItemByParamArch(chanal_: longint; num: longint): integer; overload;
    property items[id: integer]: PTUnitItem read getItem write setItem; default;
    property valid[id: integer]: integer read getValid;
    property buff[id: integer]: integer read getBufferCount;
    property refCount[id: integer]: integer read getrefCount;
    function addItem(id: integer): PTUnitItem;
    procedure SetCurVal(id: integer; val: string);
    procedure SetInpVal(id: integer; val: string);
    procedure SetCurArch(id: integer; au: TreportArrUnit);
    constructor Create(frtitems_: TanalogMems);
    destructor Destroy; override;

    // ��� �������� �����

    //����� ����� ���������� ��������� �����
    //������������� ��������� ������( ����� ���������� � TabTime
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

  //  wraper ��� TUnitItems

  TVirtualUnitItems = class(TList)
  private
    mainlist: TUnitItems;
    frtitems: TanalogMems;
    cursor: integer;
    comserver: TSETComPort;
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
    function GetComMessageCurr(id: integer): string;  // ��������� � ���� ��� �������
    function GetComMessageInp(id: integer): string;  // ��������� � ���� ��� ������
    function GetComMessageArch(id: integer): TDateTime;
    // ��������� � ���� ��� ��������
    function GetArchChanal(id: integer): byte;  // ��������� � ���� ��� ��������
    function GetArchIs30min(id: integer): boolean;
    function ProccessMessageCurr(id: integer; val: string): integer;
    // ��������� � ���� ��� �������
    function ProccessMessageInp(id: integer; val: string): integer;
    // ��������� � ���� ��� ������
    function ProccessMessageArch(id: integer; time: TDateTime; val: real): integer;
    // ��������� � ���� ��� ��������
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
    procedure setComm(val: TSETComPort; fslave: byte; fproxy: byte);
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
    comserver: TSETComPort;
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
    procedure setComm(val: TSETComPort);
    function inreq: boolean;
    function needreq: boolean;
    procedure setreqOff;
    procedure setreqOn;
    function FindIt(val: string): PTUnitItem;
    function getCurread: string;
    function getCursor: integer;
  public
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
    property inReqest: boolean read finreqest;  // ��� ����������� � ����
    property typeReq: TNetType read ftypeReq;
    property MaxUSD: byte read fMaxUSD;
  end;

  //PTDeviceItem = ^TDeviceItem;

  TDeviceItems = class(TList)
  protected
    //    frepList: TLogRepItems;
    fAllItemsList: TStringList;  // ������ ���� ��������� �������
    funitList: TUnitItems;
    frtitems: TanalogMems;
    fcomnum: integer;
    comserver: TSETComPort;
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
    function Connected: boolean;
    function Open: boolean;
    function Close: boolean;
    function Init: boolean;
    function UnInit: boolean;
    property items[i: integer]: TDeviceItem read getItem write setItem; default;
    function FindIt(val: string): TDeviceItem;
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
// �������������� ������ ���������� �� ����������� �
// �������� ����

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
  ComSet.db := 1;       // ������������ ����� ������� � ����
  ComSet.sb := 1;       //  ��� ����������
  ComSet.pt := 16;      // �������� ����
  ComSet.trd := 0;
  ComSet.red := 0;
  ComSet.ri := 100;
  ComSet.rtm := 3000;
  ComSet.rtc := 3000;
  ComSet.wtm := 3000;
  ComSet.wtc := 3000;
  ComSet.bs := 5;
  ComSet.flCtrl := False;
  ComSet.frt := 60;   // ������� �� ������ �����
  ComSet.frd := 0;   //  ����� ����������
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
  // ���������� ������� ������ ��� ���� ����� � ��������������� ������
  // �������� ��� �� ����� �������
  // ������� ��� �������, ����� ��� ��������, ����� ��� �������

  if v1.index = -2 {��������} then
    vir1 := 1000
  else
  if v1.index > -1 {�������} then
    vir1 := 10000
  else
    {�������} vir1 := 0;

  if v2.index = -2 {��������} then
    vir2 := 1000
  else
  if v2.index > -1 {�������} then
    vir2 := 10000
  else
    {�������} vir2 := 0;

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

  if v.index = -2 {��������} then
    virv := 1000
  else
  if v.index > -1 {�������} then
    virv := 10000
  else
    {�������} virv := 0;

  if ind = -2 {��������} then
    virt_ := 1000
  else
  if ind > -1 {�������} then
    virt_ := 10000
  else
    {�������} virt_ := 0;

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
  Result := True;
end;




function GetInfo(val: string; var chan: integer; var num: integer;
  var ind: integer; var ut: TUnitItemType): boolean;

var
  temp, i: integer;
  tempstr: string;
begin
  try
    Result := False;
    val := trim(uppercase(val));

    temp := pos('RE', val);
    chan := 0;
    num := -1;
    ind := -1;
    if temp > 0 then
    begin
      chan := -1;
      if (temp + 1) < length(val) then
      begin
        i := temp + 2;
        tempstr := '';
        while (i <= length(val)){ and (val[i]<>':')} do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        chan := strtointdef(tempstr, -1);
        if (chan > -1) {and (num>-1)} then
          Result := True;
        exit;
      end;
    end;

    temp := pos('I', val);
    chan := 0;
    num := -1;
    ind := -1;
    if temp > 0 then
    begin
      chan := -1;
      if (temp) < length(val) then
      begin
        i := temp + 1;
        tempstr := '';
        while (i <= length(val)){ and (val[i]<>':')} do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        ind := strtointdef(tempstr, -1);
        if (ind > -1) {and (num>-1)} then
          Result := True;
        exit;
      end;
    end;

    temp := pos('AR', val);
    chan := 0;
    num := -1;
    ind := -1;
    if temp > 0 then
    begin
      chan := -1;
      if (temp + 1) < length(val) then
      begin
        i := temp + 2;
        tempstr := '';
        while (i <= length(val)){ and (val[i]<>':')} do
        begin
          tempstr := tempstr + val[i];
          Inc(i);
        end;
        num := strtointdef(tempstr, -1);
        if (num > -1) then
        begin
          Result := True;
          chan := 1000;
          exit;
        end;
      end;
    end;


    if (chan > -1) {and (num>-1)} then
      Result := True;
    num := 1;
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

//  ��������� �������� �� ������������ ������ ���������
//  ��� -  ������ ��������� � ������  �� ����������
//  ��  -  ������ �� ������, ���� ������ ������
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
  // ���� ��� ���������� ��� ��������
var
  temp: TreportArrUnit;
begin
  Result := False;
  if items[id].reqType <> rtArchive then
  begin
    log('������� ������ ������� ������� ��� ��������!', _DEBUG_ERROR);
    exit;
  end;
  if (State[id] <> REPORT_NEEDREQUEST) then
    exit;
  if getBufferCount(id) > 0 then
  begin
    temp := getFromBuffer(id);
    //  ���� ����� � ������ �� ��������� �� ��������
    //�������
    Val[id] := temp.val;
    if temp.dt <> TabTime[id] then
      TabTime[id] := roundPeriod(typ[id], temp.dt, delt[id]);

    State[id] := REPORT_DATA;
  end
  else
    Result := True;
end;

function TUnitItems.NeedRequestItemArch_(id: integer): boolean;
  // ���� ��� ���������� ��� ��������
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
      log('M���� nm:=' + frtitems.GetName(id) + ', id=' + IntToStr(id) +
        ' �� ���������. �������� ' + frtitems.GetDDEItem(id) +
        ' �������� ������������ �������!', _DEBUG_ERROR);
    end;

    if GetInfo(frtitems.GetDDEItem(id), ch_, num_, ind_, utyp_) then
    begin

      // ���������� ��� �����
      if not (typ_ in REPORT_SET_SET) then
      begin
        if (ind_ > -1) then
        begin
          reqtype := rtInput;
          ch_ := 2000;
          num_ := ind_;
          ind_ := -1;
        end
        else
          reqtype := rtCurrent;
      end
      else
      begin
        if (typ_ = REPORTTYPE_30MIN) then
          ch_ := 1001
        else
          ch_ := 1000;

        reqtype := rtArchive;
      end;


      case reqtype of

        rtCurrent, rtInput:
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
            // log('�������������� ����� nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
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
            // log('��������� ����� nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
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
            log('�������� �����  �� ��������� nm:=' + frtitems.GetName(
              id) + ' �������� source=' + frtitems.GetDDEItem(id) +
              ' ����� ��������!', _DEBUG_ERROR);
            exit;
          end;
          if ((typ_ <> REPORTTYPE_30MIN) and (typ_ <> REPORTTYPE_HOUR)) then
          begin
            log('�������� �����  �� ��������� nm:=' + frtitems.GetName(
              id) + '  �������� ��� �� ��������������', _DEBUG_ERROR);
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
          //  log('��������  ����� ��������� nm:='+frtitems.GetName(id)+', source='+frtitems.GetDDEItem(id)+', id='+
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
      log('M���� nm:=' + frtitems.GetName(id) + ', id=' + IntToStr(id) +
        ', ch:=' + IntToStr(ch_) + ', num=' + IntToStr(num_) +
        ' �� ���������. �������� ' + frtitems.GetDDEItem(id) + ' ����� �� �����!', _DEBUG_ERROR);
  end;
end;


procedure TUnitItems.Sort;
var
  fl: boolean;
  i: integer;
begin
  // ����������� ����������
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

procedure TUnitItems.SetCurVal(id: integer; val: string);
var
  l, i: integer;
  tempint: integer;
  tempval: real;
  valcorrect: boolean;
  minEU, maxEU, minR, maxR, tmpEU, tmpR: real;
begin
  tempint := 0;
  for i := 1 to length(val) do
    tempint := tempint * 256 + Ord(val[i]);
  tempval := 1.0 * tempint;
  for l := 0 to length(items[id].ID) - 1 do
  begin
    minEU := frtitems[items[id].ID[l]].MinEu;
    maxEU := frtitems[items[id].ID[l]].MaxEu;
    minR := frtitems[items[id].ID[l]].MinRaw;
    maxR := frtitems[items[id].ID[l]].MaxRaw;

    if ((minEU = maxEU) or (minR = maxR)) then
    begin
      frtitems.SetVal(items[id].ID[l], tempval, 100);
    end
    else
    begin
      if (minEU > maxEU) then
      begin
        tmpEU := minEU;
        minEU := maxEU;
        maxEU := tmpEU;
      end;

      if (minR > maxR) then
      begin
        tmpR := minR;
        minR := maxR;
        maxR := tmpR;
      end;
      tempval := minEU + (tempval - minR) / (maxR - minR) * (maxEU - minEU);
      frtitems.SetVal(items[id].ID[l], tempval, 100);
    end;

  end;
end;

procedure TUnitItems.SetInpVal(id: integer; val: string);
var
  l, i, pos: integer;
  tempint: integer;
  tempval: bool;
  valcorrect: boolean;
begin
  tempint := 0;
  pos := items[id].paramNum;
  if (pos > 0) then
  begin
    for i := 1 to length(val) do
      tempint := tempint * 256 + Ord(val[i]);
    tempval := ((1 shl (pos - 1)) and tempint) <> 0;
    for l := 0 to length(items[id].ID) - 1 do
    begin
      if (tempval) then
      begin
        frtitems.SetVal(items[id].ID[l], 1, 100);
      end
      else
      begin
        frtitems.SetVal(items[id].ID[l], 0, 100);
      end;
    end;
  end;
end;

procedure TUnitItems.SetCurArch(id: integer; au: TreportArrUnit);
var
  l, i: integer;
begin
  for l := 0 to length(items[id].ID) - 1 do
  begin
    //frtitems.addInBuffer(items[id].ID[l],au );
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
  //for l:=0 to archblocksize-tmp do
  vdt := incPeriod(typ[id], vdt, 1);
  Result :=
    GetTimeReqByTabTimeforSys(vdt, typ[id], delt[id]);
  Result := Result;
  incminute(Result, 1);
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

procedure TDeviceItem.setComm(val: TSETComPort);
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
    exit;
  end;
  if (frtitems.Items[id_inreq].ID < 0) then
  begin
    exit;
  end;
  if (frtitems.Items[id_inreq].ValReal > 0) then
  begin
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
  begin
    flastconnect := now;
    if (id_req > -1) and (frtitems.Items[id_req].ID > -1) then;
      //  frtitems.SetVal(id_req,0,0);
  end;


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
        comserver.Close;
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




function TDeviceItem.Sync: boolean;
begin
  if virtualitems <> nil then
  begin

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
  virtualitems.setUnitItems(funitList, 1);
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
  comserver := TSETComPort.Create(nil, comset);
  comserver.setComset(comset);
end;

destructor TDeviceItems.Destroy;
begin
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
  if not comserver.Connected then
    Result := Open
  else
    Result := True;
end;

function TDeviceItems.Open: boolean;
var
  i: integer;
begin
  Result := False;
  try
    comserver.fcomset.pt := 1;
    fconnected := comserver.Open;
    Result := fconnected;
    for i := 0 to Count - 1 do
      items[i].setComm(comserver);
    for i := 0 to Count - 1 do
      items[i].ferror := 0;
  except
    for i := 0 to Count - 1 do
      items[i].ferror := ERROR_OPEN;
    log('�� ������� ������� Com ���� ' + IntToStr(self.fcomnum), _DEBUG_ERROR);
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
    log('�� ������� ������� Com ���� ' + IntToStr(self.fcomnum), _DEBUG_ERROR);
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
    if (trim(uppercase(frtitems.TegGroups.Items[i].App)) = 'SETSERV') then
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
        // !!! �� ����� �����         // if FindBySlave(frtitems.TegGroups.Items[i].SlaveNum)<0 then
        begin
          DI := TDeviceItem.Create(frtitems, frtitems.TegGroups.Items[i].Num,
            fAllItemsList);
          DI.ftypeReq := ftypeReq;
          DI.fMaxUSD := fMaxUSD;
          self.Add(DI);
          DI.Init;
        end;
        //            else
        //              log('������ ��� ���������� ������ '+
        //             frtitems.TegGroups.Items[i].Name+' � �����. �������� slave.',_DEBUG_ERROR);
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
  i, blocksize   // ������ �����
  , mincur, maxcur,
  // ����������� � ������������ ������ ������� � mainlist (�� ����������, ��� �������)
  curind, tempcurind           // ������� ��� ����������� � ��� �������� � ��������
  : integer;
  it: PTVirtualUnitItem;
  lasttype: TItemReqType;
  lastch_, lastnum_, tempi, maxread_: integer;
begin
  if mainlist = nil then
    exit;
  blocksize := 0;
  mincur := -1;    ///  ������� max � ��� ������� ������
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
      mincur := i;   // ������� ����������� ������� �������
    if (maxcur < i) and (mainlist.items[i].reqType = rtCurrent) then
      maxcur := i;   // ������� ������������ ������� �������

    if lasttype <> mainlist.items[i].reqType then
    begin
      blocksize := 0;
      // ��� ����� ���� �������� ������ �����
      if (lasttype = rtCurrent) and (curind < 0) then
        //e��� �������� ��� � ��������� ��� ������� ������������� ������� ��������
        curind := mincur;
    end;

    begin

      case mainlist.items[i].reqType of
        rtArchive:
        begin
          //  �������� ��������� ���� ���������� �������� � ���� ������� �� �����
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtArchive;
          Add(it);
          blocksize := 0;
        end;
        rtCurrent:   // �������� ����������� ������� �������
        begin
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtCurrent;
          Add(it);
          blocksize := 1;
        end;
        rtInput:   // �������� ����������� ������� �������
        begin
          new(it);
          it.start_ind := i;
          it.stop_ind := i;
          it.reqType_ := rtInput;
          Add(it);
          blocksize := 1;
        end
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
    rtCurrent, rtInput:
      // ����  ������� ��������� ���������� ������ ��� ������� �������� � �����
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


// � ������� �� GetNeedReq �� ������ ��������� ����������(��� �������)
function TVirtualUnitItems.GetNeedReq_(id: integer): boolean;
var
  i: integer;
begin
  Result := True;
  case items[id].reqType_ of
    rtCurrent, rtInput:
      // ����  ������� ��������� ���������� ������ ��� ������� �������� � �����
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
  realresl: real;
  reqtm: TDateTime;
  chnl: byte;
  is30min: boolean;
  isfirst30min: boolean;
begin

  if self.comserver = nil then
  begin
    self.mainlist.Log('���� �� ����������', _DEBUG_ERROR);
  end;
  CheckArch;
  Result := 0;
  case items[id].reqType_ of
    rtCurrent:
    begin
      outstr := GetComMessageCurr(id);
      if outstr = '' then
        exit;
      Result := comserver.SETreadStr(slave, byte(RCURRENT), outstr, instr);
      if Result = ANSWER_OK then
      begin
        ProccessMessageCurr(id, instr);
      end;
    end;
    rtInput:
    begin
      outstr := GetComMessageInp(id);
      if outstr = '' then
        exit;
      Result := comserver.SETreadStr(slave, byte(RCURRENT), outstr, instr);
      if Result = ANSWER_OK then
      begin
        ProccessMessageInp(id, instr);
      end;
    end;
    rtArchive:
    begin
      reqtm := GetComMessageArch(id);
      is30min := GetArchIs30min(id);
      chnl := GetArchChanal(id) - 1;
      isfirst30min := (MinuteOfTheHour(incSecond(reqtm, 1)) = 30);
      if (is30min) then
        is30min := True;
      Result := comserver.RequestArch(slave, reqtm, chnl, is30min,
        isfirst30min, realresl);
      if Result = ANSWER_OK then
      begin
        ProccessMessageArch(id, reqtm, realresl);
      end;
    end;
  end;
end;

procedure TVirtualUnitItems.NeedRequestItemArchAll; // ���� ��� ���������� ��� ��������
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
      if (items[vcur].reqType_ in [rtArchive]) then
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
  //  ���� ������ �� ������� ���������� -1;
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
    rtArchive: Result := 'arch:';
    else
      Result := 'curr:';
  end;

  case items[vcur].reqType_ of
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
      Result := ReadItem(cursor); // ���������� ������������� ��� ������
      fl := False;
      cursor := cursor + 1;
    end
    else
    begin
      if cursor >= Count then
        cursor := 0;
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
  //  ���� ������ �� ������� ���������� -1;
end;

procedure TVirtualUnitItems.setComm(val: TSETComPort; fslave: byte; fproxy: byte);
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
  // ��������� � ���� ��� �������
var
  i: integer;
begin
  Result := '';
  i := items[id].start_ind;
  if mainlist.refCount[i] > 0 then
    Result := chr($11) + chr(mainlist.items[i].chanalNum);
  //end;
  if Result <> '' then
    Result := Result;
end;

function TVirtualUnitItems.GetComMessageInp(id: integer): string;
  // ��������� � ���� ��� �������
var
  i: integer;
begin
  Result := chr($1D) + chr($FA);
  if Result <> '' then
    Result := Result;
end;



function TVirtualUnitItems.GetComMessageArch(id: integer): TDateTime;
  // ��������� � ���� ��� ��������
var
  i: integer;
  start, stop: string;
begin
  i := items[id].start_ind;
  mainlist.ReqTime1[i];
  mainlist.ReqTime2[i];
  Result := mainlist.ReqTime1[i];
end;

function TVirtualUnitItems.GetArchChanal(id: integer): byte;
  // ��������� � ���� ��� ��������
var
  i: integer;
begin
  i := items[id].start_ind;
  Result := mainlist.items[i].paramNum;
end;

function TVirtualUnitItems.GetArchIs30min(id: integer): boolean;
  // ��������� � ���� ��� ��������
var
  i: integer;
begin
  i := items[id].start_ind;
  Result := (mainlist.items[i].typ = REPORTTYPE_30MIN);
end;




function TVirtualUnitItems.ProccessMessageCurr(id: integer; val: string): integer;
  // ��������� ��������� �� ����� ��� �������
var
  sl, valsl: TStringList;
  ch_, num_, i, par_id: integer;
  dirval, dirue, dirtime: string;
  _getadr: boolean;

begin
  if id > -1 then
  begin
    mainlist.SetCurVal(id, val);
  end;
end;

function TVirtualUnitItems.ProccessMessageInp(id: integer; val: string): integer;
  // ��������� ��������� �� ����� ��� �������
var
  sl, valsl: TStringList;
  ch_, num_, i, par_id: integer;
  dirval, dirue, dirtime: string;
  _getadr: boolean;

begin
  if id > -1 then
  begin
    mainlist.SetInpVal(id, val);
  end;
end;



function TVirtualUnitItems.ProccessMessageArch(id: integer; time: TDateTime;
  val: real): integer;  // ��������� ��������� �� ����� � ���� ��� �������
var
  ch_, num_, i, par_id: integer;
  dirval, dirue, dirtime: string;
  au: TreportArrUnit;
begin

  if id > -1 then
  begin
    if not IsNaN(val) then
    begin
      au.dt := time;
      au.val := val;
      mainlist.addInBuffer(id, au);
    end
    else
    begin
      mainlist.CheckNoData(id);
    end;
  end;
end;

end.
