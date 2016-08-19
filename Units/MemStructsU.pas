unit MemStructsU;

interface

uses Windows, SysUtils, Classes, constDef, Dialogs, Controls, GlobalValue, DateUtils,
  Forms, GroupsU, Math, mmsystem, winSock, StrUtils;

const
  MAIN_MAP_NAME = 'Global\nnnsys_analogmem_base';
  STRING_MAP_NAME = 'Global\nnnsys_string_base';
  COMMAND_MAP_NAME = 'Global\nnnsys_command_base';
  ALARMS_MAP_NAME = 'Global\nnnsys_alarms_base';
  ALARMLOCALS_MAP_NAME = 'Global\nnnsys_alarmlocal_base';
  DEBUGS_MAP_NAME = 'Global\nnnsys_debug_base';
  ANALOGLOCBASE_MAP_NAME = 'Global\nnnsys_analoglocbase_base';
  VALUECHANGE_MAP_NAME = 'Global\nnnsys_valuechange_base';
  REGISTRATION_MAP_NAME = 'Global\nnnsys_registration_base';




type
  pint = ^Pinteger;
  IntClosure = array [0..1] of integer;
  pintClosure = ^IntClosure;

type
  TOschTeg = array of integer;

  TOschTegGrope = record
    num: TOschTeg;
    n: integer;
  end;

type
  TAlarmCase = (alarmMore, alarmLess, alarmEqual);
  TMsgType = (msNew, msKvit, msOut, msOn, msOff, msCmd);
  TMsgState = set of TMsgType;

  TAddedItemType = (acNewCommand, acQueuedCommand);

  THeaderStruct = record
    Count: longint;
    maxCount: longint;
    firstNumber: longint;
    LastNumber: longint;
    CurLine: longint;
    UnUsed1, UnUsed2: DWord;
  end;


  TEventTypes = (IMMIAll, IMMIChanged, IMMILog, IMMIEvent, IMMIAlarm,
    IMMIAlarmLocal, IMMICommand,
    IMMINewRef, IMMIRemRef, IMMIValid);
  TEventTypesSet = set of TEventTypes;

  TRegStruct = record
    number: integer;
    Name: string[50];
    Handle: THandle;
    EventsSet: TEventTypesSet;
    UnUsed1, UnUsed2: DWord;
  end;

  TRegsStruct = record
    Header: THeaderStruct;
    Items: array [0..1000000] of TRegStruct;
  end;

  TAnalogMem = packed record
    ID: integer;
    ValReal: real;
    ValidLevel: integer;
    refCount: integer;
    NamePos: longint;
    GroupNum: integer; //номер группы опроса
    ItemPos: longint;
    DeviceNamePos: longint;
    CommentPos: longint;
    Logged: boolean;
    LogPrevVal: real;
    LogCode: longint;
    logTime: integer;
    logDB: real;
    MinRaw, MaxRaw, MinEu, maxEu: single;
    OnMsged: boolean;
    OnMsgPos: longint;
    offMsged: boolean;
    OffMsgPos: longint;
    Alarmed: boolean;
    AlarmedLocal: boolean;
    AlarmMsgPos: longint;
    AlarmLevel: integer;
    alarmCase: tAlarmCase;
    AlarmConst: single;
    isAlarmOn: boolean;
    isAlarmKvit: boolean;
    TimeStamp: real;
    EUPos: longint;
    AlarmGroup: integer;
    PreTime: integer;
    isAlarmOnServ: boolean;
  end;

  PTAnalogMem = ^TAnalogMem;

  TCalcMem = record
    ID: integer;
    Name: string[50];
    ValReal: real;
    ValidLevel: integer;
    refCount: integer;
    CommentPos: longint;
    OnMsgPos, OffMsgPos: longint;
  end;
  PTCalcMem = ^TCalcMem;

  TAnalogsStruct = record
    Items: array [0..1000000] of TAnalogMem;
  end;

  //*********************** TCommandStruct *****************************//
  TCommandStruct = record
    number: longint;
    time: TDateTime;
    ID: integer;
    prevVal: real;
    ValReal: real;
    executed: boolean;
    CompName: string[255];
    UserName: string[255];
    unUsed1: DWORD;

  end;

  PTCommandStruct = ^TCommandStruct;

  TCommandsStruct = record
    Header: THeaderStruct;
    Items: array [0..1000000] of TCommandStruct;
  end;

  PTCommands = ^TCommandsStruct;

  //*********************** TAlarmStruct *****************************//
  TAlarmStruct = record
    number: longint;
    time: TDateTime;
    TegID: integer;
    typ: TMsgType;
    oper: string[60];
    UnUsed1, UnUsed2: DWord;
  end;

  PTAlarmStruct = ^TAlarmStruct;

  TAlarmsStruct = record
    Header: THeaderStruct;
    Items: array [0..1000000] of TAlarmStruct;
  end;

  PTAlarms = ^TAlarmsStruct;


  //*********************** TDebugStruct *****************************//
  TDebugStruct = record
    number: longint;
    time: TDateTime;
    level: byte;
    debugmessage: string[250];
    application: string[50];
  end;

  PTDebugStruct = ^TDebugStruct;

  TDebugsStruct = record
    Header: THeaderStruct;
    Items: array [0..1000000] of TDebugStruct;
  end;

  PTDebugs = ^TDebugsStruct;

  //*********************** TOperatorStruct *****************************//
  TOperatorStruct = record
    id: longint;
    Name: string[255];
    idgroup: longint;
    accessLevel: integer;
    password: string[25];
    UnUsed1, UnUsed2: DWord;
  end;

  PTOperatorStruct = ^ TOperatorStruct;

  TOperatorsStruct = record
    Header: THeaderStruct;
    Items: array [0..10000] of TOperatorStruct;
  end;

  PTOperators = ^ TOperatorsStruct;

  //*********************** TActiveAlarmStruct *****************************//


  TActiveAlarmStruct = record
    number: longint;
    time: TDateTime;
    TegID: integer;
    isKvit, isOff: boolean;
    oper: string[60];
    UnUsed1, UnUsed2: DWord;
  end;

  PTActiveAlarmStruct = ^TActiveAlarmStruct;

  TActiveAlarmsStruct = record
    Header: THeaderStruct;
    Items: array [0..1000000] of TActiveAlarmStruct;
  end;

  PTActiveAlarms = ^TActiveAlarmsStruct;



  //*********************** TAnalogLocBaseStruct *****************************//
  PixelInfo = record
    Value: single;
    tim: TDatetime;
  end;

  TAnalogLocBaseStruct = record
    Count: longint;
    TagId: integer;
    last: integer;
    min, max: single;
    koef: single;
    point: array [0..3600] of PixelInfo;
  end;

  PTAnalogLocBaseStruct = ^TAnalogLocBaseStruct;

  TAnalogLocBasesStruct = record
    Header: THeaderStruct;
    Items: array [0..1000] of TAnalogLocBaseStruct;
  end;

  PTAnalogLocBase = ^TAnalogLocBasesStruct;

  TabsenttimeInfo = record
    start: TDatetime;
    stop: TDatetime;
  end;

  TAbsenttimeInfoStruct = record
    Count: longint;
    groupId: integer;
    last: integer;
    point: array [0..100] of TabsenttimeInfo;
  end;

  PTAbsenttimeInfoStruct = ^TAbsenttimeInfoStruct;

  TAbsenttimeInfosStruct = record
    Header: THeaderStruct;
    Items: array [0..1000] of TAbsenttimeInfoStruct;
  end;

  PTAbsenttimeInfo = ^TAnalogLocBasesStruct;

  //*********************** MappedFile *****************************//
  MappedFile = class
  private
    securyty: PSecurityAttributes;
    hMapping: THandle;
    isNewFileOpened: boolean;
    mapName, filename: string;
    //  Data: pointer;
    hFile: THandle;
    FileSize: DWORD;
    secD: pSecurityDescriptor;
    function OpenMappedFile(DeleteOnClose: boolean): boolean;
    function OpenMappedMemory: boolean;
  protected
    Data: pointer;
    class function MappedMemoryisLock(nm: string): boolean;
  public
    fsize: cardinal;
    constructor Create(fileNm, mapNm: string); virtual;
    destructor Destroy; override;
  end;

  {***************************** TMappedFilePsevdo ************************************}
  //выделяет файл в памяти и копирует туда содержание файла
  //при этом файл не блокируется, и можо его дополнять без проблем
  TMappedFilePsevdo = class(mappedFile)
  protected
  public
    constructor Create(fileNm, mapNm: string; oldOverride: boolean = False);
  end;



  {*****************************THeaderedMem************************************}
  THeaderedMem = class(mappedFile)
  protected
    function GetCount: longint;
    procedure SetCount(iCount: longint);
    function GetMaxCount: longint;
    procedure SetMaxCount(iCount: longint);
    function GetLastNumber: longint;
    procedure SetLastNumber(iLastNumber: longint);
    function GetFirstNumber: longint;
    procedure SetFirstNumber(iFirstNumber: longint);
    function GetCurLine: longint;
    procedure SetCurLine(iCurLine: longint);
    property Count: longint read GetCount write SetCount;
    property MaxCount: longint read GetMaxCount write SetMaxCount;
    property LastNumber: longint read GetLastNumber write SetLastNumber;
    property FirstNumber: longint read GetFirstNumber write SetFirstNumber;
    property CurLine: longint read GetCurLine write SetCurLine;
  public
    constructor Create(mapNm: string); virtual;
    constructor CreateW(mapNm: string; maxcount: word; filesize: cardinal); virtual;
  end;


  TRegs = class(THeaderedMem)
  private
    fRefMsgNum: longint; //Номер сообщения о увеличении ссылок
    rtItemsPointer: Pointer;
    function GetItem(number: longint): TRegStruct;
  public
    property Items[i: longint]: TRegStruct read GetItem;
    property MaxCount: longint read GetMaxCount;
    property LastNumber: longint read GetLastNumber;
    property Count: longint read GetCount;
    property FirstNumber: longint read GetFirstNumber;
    property CurLine: longint read GetCurLine;
    //number- number of line in events, ID-ID of parameters
    constructor Create(rtItemsPtr: pointer; mapNm: string);
    procedure RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
    procedure UnRegHandle(Handle: THandle);
    procedure NotifyValid(ID: longint);
    procedure NotifyLog(LineNumber: longint; ID: longint);
    procedure NotifyLogInside(LineNumber: longint; ID: longint);
    procedure NotifyEvents(LineNumber: longint; ID: longint);
    procedure NotifyChange(LineNumber: longint; ID: longint);
    procedure NotifyAlarm(LineNumber: longint; ID: longint);
    procedure NotifyNewAlarm;
    procedure NotifyAlarmLocal(LineNumber: longint; ID: longint);
    procedure NotifyCommands(LineNumber: longint; ID: longint);
    //Количество ссылок стало не ноль
    procedure NotifyNewRef(ID: longint);
    //Количество ссылок стало ноль
    procedure NotifyRemRef(ID: longint);
  end;

  TCommandMems = class(THeaderedMem)
  private
    function GetItem(number: longint): TCommandStruct;
    function GetItemN(number: longint): PTCommandStruct;
    procedure SetExecuted(num: longint);
    procedure ClearExecuted(num: longint);
    //  procedure IncItemCount;
    //  procedure IncLastNumber;
  public
    LastCommandLine: integer;
    constructor Create(fileDIR: string; MemName: string);
    destructor Destroy; override;
    property Count: longint read GetCount;
    property MaxCount: longint read GetMaxCount;
    property LastNumber: longint read GetLastNumber;
    property FirstNumber: longint read GetFirstNumber;
    property CurLine: longint read GetCurLine;
    property Items[i: longint]: TCommandStruct read GetItem; default;
    property ItemsN[i: longint]: PTCommandStruct read GetItemN;
    //Нормальный доступ, скрывающий структуру (i := 0 to -1)
    function AddItem(number: integer; PrevVal, val: real; queue: boolean;
      compName: string = ''; username: string = ''): TAddedItemType;
    procedure Compress; //удаляет отработанные команды
  end;


  TAlarmMems = class(THeaderedMem)
  private
    //переводим № аларма по порядку в номер строки
    function ConvertNumber(number: integer): integer;
    function GetItem(num: longint): PTAlarmStruct;
  public
    property CurLine;
    property Items[i: longint]: PTAlarmStruct read GetItem; default;
    //constructor Create (MemName: string); override;
    constructor Create(MemName: string; aMaxCount: integer);
    destructor Destroy; override;
    property Count: longint read GetCount;
    function AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType): integer; overload;
    function AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType;
      comp: string; oper: string): integer; overload;
  end;

  TActiveAlarmMems = class(THeaderedMem)
  private
    rtItemsPointer: pointer;
    function GetItem(num: longint): PTActiveAlarmStruct;
    procedure CheckOut;
  public
    property LastNumber;
    property Items[i: longint]: PTActiveAlarmStruct read GetItem; default;
    constructor Create(rtItemsPtr: pointer; MemName: string);
    destructor Destroy; override;
    property Count: longint read GetCount;
    function AddItem(atime: TDateTime; aTegID: integer): integer;
    procedure KvitAll;
    procedure KvitAlarmGroup(grnum: integer);
    procedure KvitTagGroup(grnum: integer);
    procedure SetOff(aTegID: integer);
  end;

  TDebugMems = class(THeaderedMem)
  private
    //переводим № аларма по порядку в номер строки
    function ConvertNumber(number: integer): integer;
    function GetItem(num: longint): PTDebugStruct;
    function GetItem_(num: longint): PTDebugStruct;
  public
    property CurLine;
    property Items[i: longint]: PTDebugStruct read GetItem; default;
    property Items_[i: longint]: PTDebugStruct read GetItem_;
    //constructor Create (MemName: string); override;
    constructor Create(MemName: string; aMaxCount: integer);
    destructor Destroy; override;
    property Count: longint read GetCount;
    function AddItem(atime: TDateTime; mess: string; app: string; lev: byte): integer;
  end;


  TAnalogLocBaseMems = class(THeaderedMem)
  private
    rtItemsPointer: pointer;
    indexListI: TStringList;
    function GetItem(num: longint): PTAnalogLocBaseStruct;
    procedure addIndex(idX, num: integer);
    function getNumbyId(idx: integer): integer;
    function AddItem(aTegID: integer): integer;
    procedure setvalue(ltime: TDateTime; aTagId: integer; Value: single; valid: integer);
    function getQuery(tim: TDateTime; minut: integer; aTagid: integer;
      var val: tTDPointData): tdatetime;
  public
    property LastNumber;
    property Items[i: longint]: PTAnalogLocBaseStruct read GetItem; default;
    constructor Create(rtItemsPtr: pointer; MemName: string);
    destructor Destroy; override;
    property Count: longint read GetCount;
    function findById(id: integer): PTAnalogLocBaseStruct;
  end;




  TOperatorMems = class(TMappedFilePsevdo)
  private
    fileStrings: TMappedFilePsevdo;
    fFileDir: string;
    IndexStringList: TStringList;
    fPHeader: ^THeaderStruct;
    procedure AddIndex(ID: integer);
    procedure RemoveIndex(ID: integer);
    function GetItem(number: integer): PTOperatorStruct;
    function GetCount: integer;
    procedure SetCount(const Value: integer);
    class procedure createfileO(fileName: string);
    function findNullId: integer;
  public
    usCur: integer;
    property Items[i: integer]: PTOperatorStruct read GetItem; default;
    property Count: integer read GetCount write SetCount;
    constructor Create(fileDIR: string);
    destructor Destroy; override;
    procedure writeBaseToFile;
    function GetNamebyid(idn: longint): string;
    function GetName(idn: longint): string;
    //  function GetHost(i: longInt): string;
    function GetSimpleID(ItemName: string): integer;
    function GetID(ItemName: string): integer;
    procedure SetName(idn: longint; Value: string);
    procedure FreeItem(Num: longint);
    procedure AddUser;
    procedure Linerize;
    function RenameUser(idN: integer; newname: string): boolean;
    procedure RemoveUser(val: integer);
    function changepassUser(idN: integer; oldpassword, newpassword: string): boolean;
    function RegistUser(idN: integer; password: string): boolean;
    function setAUser(idN: integer; al: integer): boolean;
    procedure setRegist(val: boolean);
    function getRegist: boolean;
  end;

  TAnalogMemHdr = packed record
    Ver: byte;
    HeaderSize: integer;
    RecordSize: integer;
    RecordCount: longint;
    DataSize: longint;
  end;

  PTAnalogMemHdr = ^ TAnalogMemHdr;

  TAnalogMems = class(TMappedFilePsevdo)
  private
    fileStrings: TMappedFilePsevdo;
    fFileDir: string;
    IndexStringList: TStringList;
    fPHeader: PTAnalogMemHdr;
    fTegGroups, fAlarmGroups: TGroups;
    fAppl: string;
    operator_: string;
    fdebugL: integer;
    hostName: {array [0..$FF] of Char}string;
    //absensAnalog: TAnalogAbsentTimeMems;
    analogLocBase: TAnalogLocBaseMems;
    procedure SetValid(number: integer; valid: integer);
    procedure SetValue(number: integer; val: real);
    procedure AddIndex(ID: integer);
    procedure RemoveIndex(ID: integer);
    function GetItem(number: integer): PTAnalogMem;
    procedure SetStringValue(var pos: longint; Value: string);

    function GetStringValue(pos: longint): string;
    function GetCount: integer;
    function GetItemOffset(ItemNum: longint): longint;
    procedure SetCount(const Value: integer);
    //преобразует файл предыдущей версии в текущую
    //размер заголовка и записи не должен уменьшаться
    procedure ConvertBase;
    function GetModName: string;
    //Записать всю базу на диск
    // procedure writeBaseToFile;

  public
    KvitId: integer;
    Regs: TRegs;
    command: TCommandMems;
    alarms: TAlarmMems;
    oper: TOperatorMems;
    activeAlarms: TActiveAlarmMems;
    // ValCh: TCommandMems;
    // calc: TCalcMems;
    fdebugBase: TDebugMems;
    class function isLock: boolean;
    procedure setOperator(val: string);
    property Items[i: integer]: PTAnalogMem read GetItem; default;
    property Count: integer read GetCount write SetCount;
    property PathMem: string read fFileDir;
    property TegGroups: TGroups read fTegGroups;
    property AlarmGroups: TGroups read fAlarmGroups;


    constructor Create(fileDIR: string);
    constructor CreateW(fileDIR: string);
    destructor Destroy; override;

    class procedure WriteZero(fileDIR: string; clear_: boolean = True);
    //  property pethMem: string read FFileDir;
    procedure ClearDubleErr;
    procedure addLocalBaseTag(idA: integer);
    procedure addLocalBaseGroup(idGroup: integer);
    procedure setLocalBaseTagval(ltime: TDateTime; aTagId: integer;
      Value: single; valid: integer);
    procedure setLocalBaseGroupval(ltime: TDateTime; GrouId: integer; state: boolean);
    function QueryLocalBaseTag(tim: TDateTime; minut: integer; aTagid: integer;
      var val: tTDPointData): Tdatetime;
    procedure writeBaseToFile(ClearStrings: boolean);
    procedure getOschTeg(num: integer; var val: TOschTegGrope);
    function GetName(i: longint): string;
    function GetComment(i: longint): string;
    function GetOnMsg(i: longint): string;
    function GetOffMsg(i: longint): string;
    function GetDDEItem(i: longint): string;
    function GetAlarmMsg(i: longint): string;
    function GetEU(i: longint): string;
    function GetAlarmCase(i: longint): string;
    function GetSimpleID(ItemName: string): integer;
    function GetID(ItemName: string): integer;
    function TagDubleErr(val: integer): integer;
    function TagDubleErrIs: boolean;
    procedure SetName(i: longint; Value: string);
    procedure SetComment(i: longint; Value: string);
    procedure SetOnMsg(i: longint; Value: string);
    procedure SetOffMsg(i: longint; Value: string);
    procedure SetDDEItem(i: longint; Value: string);
    procedure SetAlarmMsg(i: longint; Value: string);
    procedure SetEU(i: longint; Value: string);
    procedure WriteToFile(curItem: longint);
    procedure WriteToFileAll();
    procedure FreeItem(Num: longint);
    procedure RebuildIndex();
    function isIdent(Name: string): boolean;
    function isDiscret(number: integer): boolean;
    procedure IncCounter(number: integer);
    procedure DecCounter(number: integer);
    function isValid(number: integer): boolean;
    //procedure SetValid(number: integer; valid: integer);
    procedure ValidOff(number: integer);
    //использовать эту функцию для изменения базы данных сервером
    // procedure SetValue(number: integer; val: real); //убрано SetValue
    //из соображений, что значение всегда должно приходить с валидностью
    procedure SetVal(number: integer; val: real; VL: integer);
    //использовать эту функцию для записи в контроллер
    //для отображения можно использовать непосредственно Items
    procedure SetValForce(number: integer; val: real; VL: integer);

    //queue - использовать очередь - true или совмещать запросы на запись

    procedure AddCommand(number: integer; val: real;
      queue: boolean; CompName: string = ''; userName: string = '');
    //пометить команду выполненной
    procedure SetCommandExecuted(ComNum: longint);
    //очистить выполнение команды
    procedure ClearCommandExecuted(ComNum: longint);
    //использовать эту функцию для регистрации окон, получающих сообщения
    procedure RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
    procedure UnRegHandle(Handle: THandle);
    procedure Log(mess: string; lev: byte = 2);
    procedure LogWarning(mess: string);
    procedure LogError(mess: string);
    procedure LogFatalError(mess: string);
    procedure SetAppName(app: string);
  end;



var
  rtItems: TAnalogMems;
  ir: longbool;
  irr: integer;
  ostr: TOperatorsStruct;

function Regrtitems(point: Pointer; point1: pointer;
  point2: pointer; pactive: pointer): pointer;
procedure SetAcsessAdress(p: pointer; pname: pointer; ppas: pointer);
function isSystemGroup(val: string): boolean;
procedure AlarmSound(Value: boolean);
//function getTypeDataItem(val: integer): string;
//function  incPeriod(typ_: integer; dt: TDateTime; v: integer =1): TDateTime;
//function  GetDeepUtil(typ_: integer; reqdeep: integer): integer;
//function  GetTimeReqByTabTime(tm: TDateTime; typ_: integer; delt: integer): TDateTime;
//function  GetTimeReqByTabTimeforRep(tm: TDateTime; typ_: integer): TDateTime;
//function  GetTimeReqByTabTimeforSys(tm: TDateTime; typ_: integer; delt: integer): TDateTime;
//function  GetHistTm(typ_:  integer; hp: integer): TDateTime;
//procedure AlarmSound(value: boolean);
//function  roundPeriod(typ_: integer;  dt: TDateTime;  delt: integer): TDateTime;

implementation



procedure AlarmSound(Value: boolean);
begin
  Playsound(nil, 0, SND_PURGE);
  if Value then
    Playsound(PChar('ir_inter'), 0, SND_LOOP or SND_ASYNC or SND_ALIAS);
end;




function isSystemGroup(val: string): boolean;
begin
  Result := False;
  if trim(uppercase(val)) = '$SYSVAR' then
    Result := True;
  if trim(uppercase(val)) = '$SYSTEM' then
    Result := True;
  if trim(uppercase(val)) = '$REPORT' then
    Result := True;
  if trim(uppercase(val)) = '$SERVERCOUNT' then
    Result := True;
  //   if trim(uppercase(val))='$ВЫЧИСЛЯЕМАЯ' then  result:=ntOServCount;
  if trim(uppercase(val)) = '$POINTER' then
    Result := True;
  //  if pos('$ССЫЛОЧНАЯ',trim(uppercase(val)))=1 then result:=ntOPoint;
end;


//  инкримент отчетного периода v д.б!!!!! 0,-1,1


//uses GlobalVar, AlarmU;
{*********************************************************************}
{********************** Mapped File **********************************}
{*********************************************************************}

constructor MappedFile.Create(fileNm, mapNm: string);
var
  deleteOnClose: boolean;

begin
  new(securyty);
  new(secD);                                             //   SE_GROUP_DEFAULTED
  securyty^.lpSecurityDescriptor := secD;
  securyty^.nLength := sizeof(securyty);
  securyty^.bInheritHandle := True;

  ir := InitializeSecurityDescriptor(securyty^.lpSecurityDescriptor,
    SECURITY_DESCRIPTOR_REVISION);
  ir := SetSecurityDescriptorDacl(securyty^.lpSecurityDescriptor, True, nil, False);
  // ir:=SetSecurityDescriptorSacl(securyty^.lpSecurityDescriptor,true,nil,false);
  //ir:=SetSecurityDescriptorGroup(securyty^.lpSecurityDescriptor,nil,true);
  // ir:=SetSecurityDescriptorOwner(securyty^.lpSecurityDescriptor,nil,false);
  deleteOnClose := False;
  mapName := mapNm;
  fileName := fileNm;
  if fileName <> '' then
  begin
    if not OpenMappedFile(DeleteOnClose) then
      raise Exception.Create('Невозможно загрузить файл ' +
        fileName + 'в память');
  end
  else if not OpenMappedMemory then
    raise Exception.Create('Невозможно отобразить память');
end;

destructor mappedfile.Destroy;
begin
  if not UnMapViewOfFile(Data) then
    raise Exception.Create('No unmapping ' + mapName);
  if not CloseHandle(hMapping) then
    raise Exception.Create('No closing' + mapName);
  inherited;
end;

function MappedFile.OpenMappedFile(DeleteOnClose: boolean): boolean;
var
  HighSize: DWORD;

begin
  Result := False;

  if Length(FileName) = 0 then
    Exit;
  if DeleteOnClose then
    hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, securyty, OPEN_ALWAYS,
      FILE_FLAG_RANDOM_ACCESS, 0)
  else
    hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, securyty, OPEN_EXISTING,
      FILE_FLAG_RANDOM_ACCESS, 0);

  if (hFile = 0) then
    Exit;

  FileSize := GetFileSize(hFile, @HighSize);

  hMapping := CreateFileMapping(hFile, securyty, PAGE_READWRITE,
    0, 0, PChar(mapName));

  if (hMapping = 0) then
  begin
    CloseHandle(hFile);
    Exit;
  end;

  CloseHandle(hFile);

  Data := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS,
    0, 0, 0);

  if (Data <> nil) then
    Result := True;
end;


class function MappedFile.MappedMemoryisLock(nm: string): boolean;
var
  securyty_: PSecurityAttributes;
  _hMapping: THandle;
  _secD: pSecurityDescriptor;
begin

  new(securyty_);
  new(_secD);                                             //   SE_GROUP_DEFAULTED
  securyty_^.lpSecurityDescriptor := _secD;
  securyty_^.nLength := sizeof(securyty_);
  securyty_^.bInheritHandle := True;

  ir := InitializeSecurityDescriptor(securyty_^.lpSecurityDescriptor,
    SECURITY_DESCRIPTOR_REVISION);
  ir := SetSecurityDescriptorDacl(securyty_^.lpSecurityDescriptor, True, nil, False);
  Result := False;

  _hMapping := CreateFileMapping($FFFFFFFF, securyty_, PAGE_READWRITE,
    0, 10000000, PChar(nm));

  if GetLastError = ERROR_ALREADY_EXISTS then
    Result := True
  else
    Result := True;

  CloseHandle(_hMapping);

end;

function MappedFile.OpenMappedMemory: boolean;
var
  i: integer;
begin
  Result := False;
  isNewFileOpened := True;

  //  secd^.Revision:=1;


  if fsize < 10000000 then
    hMapping := CreateFileMapping($FFFFFFFF, securyty, PAGE_READWRITE,
      0, 10000000, PChar(mapName))
  else

    hMapping := CreateFileMapping($FFFFFFFF, securyty, PAGE_READWRITE,
      0, fsize, PChar(mapName));

  if (hMapping = 0) then
    Exit;

  if GetLastError = ERROR_ALREADY_EXISTS then
    isNewFileOpened := False
  else
    isNewFileOpened := True;

  Data := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);

  if (Data <> nil) then
    Result := True;
end;

{*********************************************************************}
{********************** HeaderedMem **********************************}
{*********************************************************************}

constructor THeaderedMem.Create(mapNm: string);
begin
  inherited Create('', mapNm);
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).MaxCount := 100;
    THeaderStruct(Data^).LastNumber := -1;
    THeaderStruct(Data^).FirstNumber := 0;
    THeaderStruct(Data^).CurLine := 0;
  end;
end;

constructor THeaderedMem.CreateW(mapNm: string; maxcount: word; filesize: cardinal);
begin
  fsize := filesize;
  inherited Create('', mapNm);
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).MaxCount := maxcount;
    THeaderStruct(Data^).LastNumber := -1;
    THeaderStruct(Data^).FirstNumber := 0;
    THeaderStruct(Data^).CurLine := 0;
  end;
end;

function THeaderedMem.GetCount: longint;
begin
  Result := THeaderStruct(Data^).Count;
end;

procedure THeaderedMem.SetCount(iCount: longint);
begin
  THeaderStruct(Data^).Count := iCount;
end;

function THeaderedMem.GetMaxCount: longint;
begin
  Result := THeaderStruct(Data^).MaxCount;
end;

procedure THeaderedMem.SetMaxCount(iCount: longint);
begin
  THeaderStruct(Data^).MaxCount := iCount;
end;

function THeaderedMem.GetLastNumber: longint;
begin
  Result := THeaderStruct(Data^).LastNumber;
end;

procedure THeaderedMem.SetLastNumber(iLastNumber: longint);
begin
  THeaderStruct(Data^).LastNumber := iLastNumber;
end;

function THeaderedMem.GetFirstNumber: longint;
begin
  Result := THeaderStruct(Data^).firstNumber;
end;

procedure THeaderedMem.SetFirstNumber(iFirstNumber: longint);
begin
  THeaderStruct(Data^).FirstNumber := iFirstNumber;
end;

function THeaderedMem.GetCurLine: longint;
begin
  Result := THeaderStruct(Data^).CurLine;
end;

procedure THeaderedMem.SetCurLine(iCurLine: longint);
begin
  THeaderStruct(Data^).CurLine := iCurLine;
end;

{*********************************************************************}
{********************** TRegs **********************************}
{*********************************************************************}

function TRegs.GetItem(number: longint): TRegStruct;
begin
  Result := TRegsStruct(Data^).Items[number];
end;

procedure TRegs.NotifyEvents(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIEvent in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMIEvent, LineNumber, ID);
end;

procedure TRegs.NotifyChange(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIChanged in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMIChange, LineNumber, ID);
end;

procedure TRegs.NotifyValid(ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIValid in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMIValid, ID, ID);
end;

procedure TRegs.NotifyLog(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMILog in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMILog, LineNumber, ID);
end;

procedure TRegs.NotifyLogInside(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMILog in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMILogInside, LineNumber, ID);
end;

procedure TRegs.NotifyAlarm(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIAlarm in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMIAlarm, LineNumber, ID);
end;

procedure TRegs.NotifyNewAlarm;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIAlarm in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMINewAlarm, 0, 0);
end;

procedure TRegs.NotifyAlarmLocal(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIAlarmLocal in
      Items[i].EventsSet)) and (Items[i].Handle <> 0) then
      sendMessage(Items[i].Handle, WM_IMMIAlarmLocal, LineNumber, ID);
end;

procedure TRegs.NotifyCommands(LineNumber: longint; ID: longint);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMICommand in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      postMessage(Items[i].Handle, WM_IMMICommand, LineNumber, ID);
end;

procedure TRegs.NotifyNewRef(ID: integer);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMINewRef in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      postMessage(Items[i].Handle, WM_IMMINewRef, fRefMsgNum, ID);
  Inc(frefMsgNum);
end;

procedure TRegs.NotifyRemRef(ID: integer);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then
    exit;
  for i := 0 to Count - 1 do
    if ((immiAll in Items[i].EventsSet) or (IMMIRemRef in Items[i].EventsSet)) and
      (Items[i].Handle <> 0) then
      postMessage(Items[i].Handle, WM_IMMIRemRef, fRefMsgNum, ID);
  Inc(frefMsgNum);
end;

constructor TRegs.Create;
begin
  inherited Create(MapNm);
  fRefMsgNum := 0;
  rtItemsPointer := rtItemsPtr;
end;

procedure TRegs.RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
begin
  inherited Count := Count + 1;
  inherited lastNumber := lastNumber + 1;
  TRegsStruct(Data^).Items[Count - 1].Number := lastNumber;
  TRegsStruct(Data^).Items[Count - 1].Name := Name;
  TRegsStruct(Data^).Items[Count - 1].Handle := Handle;
  TRegsStruct(Data^).Items[Count - 1].EventsSet := Events;
end;

procedure TRegs.UnRegHandle(Handle: THandle);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if TRegsStruct(Data^).Items[i].Handle = handle then
      TRegsStruct(Data^).Items[i].Handle := 0;
end;

{***************** TAnalogMems ****************************}

function TAnalogMems.GetModName: string;
var
  fName: string;
  nsize: cardinal;
begin
  nsize := 128;
  SetLength(fName, nsize);
  SetLength(fName,
    GetModuleFileName(hinstance, PChar(fName), nsize));
  Result := fName;
end;


class procedure TAnalogMems.WriteZero(fileDIR: string; clear_: boolean = True);
var
  fStr: TFileStream;
  head_: TAnalogMemHdr;
begin
  if FileExists(FileDir + 'command.mem') and (clear_) then
    DeleteFile(FileDir + 'command.mem');
  FileClose(FileCreate(FileDir + 'command.mem'));
  if FileExists(FileDir + 'Strings.mem') and (clear_) then
    DeleteFile(FileDir + 'Strings.mem');
  FileClose(FileCreate(FileDir + 'Strings.mem'));
  if FileExists(FileDir + 'Analog.mem') and (clear_) then
    DeleteFile(FileDir + 'Analog.mem');
  head_.Ver := CurrentBaseVersion;
  head_.HeaderSize := SizeOf(TAnalogMemHdr);
  head_.RecordSize := SizeOf(TAnalogMem);
  head_.RecordCount := 0;
  head_.DataSize := head_.HeaderSize + 0 * head_.RecordCount;
  // data^,SizeOf(fPHeader^) + Count * SizeOf(TAnalogMem)
  fStr := TFileStream.Create(fileDIR + 'Analog.mem', fmCreate);
  try

    fStr.Write(head_, SizeOf(TAnalogMemHdr) + 0 * SizeOf(TAnalogMem))
  finally
    fStr.Free;
  end;
  if FileExists(FileDir + 'groups.cfg') and (clear_) then
    DeleteFile(FileDir + 'groups.cfg');
  FileClose(FileCreate(FileDir + 'groups.cfg'));

  if FileExists(FileDir + 'alarmgroups.cfg') and (clear_) then
    DeleteFile(FileDir + 'alarmgroups.cfg');
  FileClose(FileCreate(FileDir + 'alarmgroups.cfg'));


  if FileExists(FileDir + 'TrendGroupsStruct.cfg') and (clear_) then
    DeleteFile(FileDir + 'TrendGroupsStruct.cfg');
  FileClose(FileCreate(FileDir + 'TrendGroupsStruct.cfg'));

  if FileExists(FileDir + 'AlarmGroupsStruct.cfg') and (clear_) then
    DeleteFile(FileDir + 'AlarmGroupsStruct.cfg');
  FileClose(FileCreate(FileDir + 'AlarmGroupsStruct.cfg'));

  FileClose(FileCreate(FileDir + 'initial.ini'));

  FileClose(FileCreate(FileDir + 'config.cfg'));

end;

constructor TAnalogMems.Create(fileDIR: string);
var
  WSAData: TWSAData;
  i: integer;
  fileName: string;
  fStr: TFileStream;
  isBaseReload: boolean;
  arhostnameName: array [0..$FF] of char;
begin
  fdebugBase := nil;
  operator_ := '';
  fdebugL := debug_Base;
  if trim(stationname) = '' then
    try
      WSAStartup($0101, WSAData);
      GetHostName(arhostnameName, $FF);
      WSACleanup;
      hostname := arhostnameName;
    finally
    end
  else
    hostname := stationname;
  try
    fAppl := GetModName;
  except
    fAppl := '';
  end;

  fFileDir := fileDir;
  fileName := fileDIR + 'analog.mem';
  if not fileExists(fileName) then
    raise Exception.Create('File not found ' + fileName);
  inherited Create(fileDIR + 'analog.mem', MAIN_MAP_NAME);


  fPHeader := Data;
  //данные, которые раньше содержались в заголовке, не соответствуют размеру файла
  //значит грузим новую базу
  with fPHeader^ do
    if RecordCount * RecordSize + HeaderSize <> fileSize then
      isBaseReload := True
    else
      isBaseReload := False;
             {if MessageDlg('Размер базы в памяти и загружаемой не совпадает. Перезаписать?',mtWarning, [mbYes, mbNo], 0) = mrYes then
                isBaseReload := true else isBaseReload := false;}
  if isBaseReload then
  begin
    fStr := TFileStream.Create(fileName, fmOpenReadWrite);
    try
      fStr.Read(Data^, fStr.Size);
    finally
      fStr.Free;
    end;
  end;


  //если версии совпадают проверить размер заголовка и записи
  if (FPHeader^.Ver = CurrentBaseVersion) then
  begin
    if fpHeader^.HeaderSize <> SizeOf(TAnalogMemHdr) then
      raise Exception.Create('Неверный размер заголовка.');
    if fpHeader^.RecordSize <> SizeOf(TAnalogMem) then
      raise Exception.Create('Неверный размер записи.');
  end;

  if (FPHeader^.Ver > CurrentBaseVersion) then
    raise Exception.Create(
      'База данных имеет более позднюю версию. Преобразоавние невозможно');
  if (FPHeader^.Ver < CurrentBaseVersion) then
    if MessageDlg('База данных имеет более раннюю версию. Преобразовать?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ConvertBase
    else
      raise Exception.Create('Конфликт версий.');

  fileStrings := TMappedFilePsevdo.Create(fileDIR + 'strings.mem', STRING_MAP_NAME);
  command := TCommandMems.Create(fileDIR, COMMAND_MAP_NAME);
  alarms := TAlarmMems.Create(ALARMS_MAP_NAME, 50000);
  activeAlarms := TActiveAlarmMems.Create(self, ALARMLOCALS_MAP_NAME);
  if ((fdebugL = DEBUGLEVEL_HIGH) or (fdebugL = DEBUGLEVEL_MIDLE) or
    (fdebugL = DEBUGLEVEL_LOW)) then
    fdebugBase := TDebugMems.Create(DEBUGS_MAP_NAME, 40000);
  ;
  analogLocBase := nil;
  // absensAnalog:=nil;
  // ValCh := TCommandMems.Create(fileDIR, VALUECHANGE_MAP_NAME);
  //   calc := TcalcMems.Create(fileDIR);
  Regs := TRegs.Create(Self, REGISTRATION_MAP_NAME);
  fTegGroups := TGroups.Create(PathMem + 'groups.cfg');
  fAlarmGroups := TGroups.Create(PathMem + 'AlarmGroups.cfg');
  oper := TOperatorMems.Create(fileDIR);
  IndexStringList := TStringList.Create;
  IndexStringList.Sorted := True;

  RebuildIndex;

  kvitID := GetSimpleID(KvitTegName);
  if kvitID <> -1 then
    Items[KvitID].ValReal := 0;
end;


constructor TAnalogMems.CreateW(fileDIR: string);
var
  WSAData: TWSAData;
  i: integer;
  fileName: string;
  fStr: TFileStream;
  isBaseReload: boolean;
  arhostnameName: array [0..$FF] of char;
begin
  fdebugBase := nil;
  fdebugL := debug_Base;
  if trim(stationname) = '' then
    try
      WSAStartup($0101, WSAData);
      GetHostName(arhostnameName, $FF);
      WSACleanup;
      hostname := arhostnameName;
    finally
    end
  else
    hostname := stationname;
  try
    fAppl := GetModName;
  except
    fAppl := '';
  end;
  fFileDir := fileDir;
  fileName := fileDIR + 'analog.mem';
  if not fileExists(fileName) then
    raise Exception.Create('File not found ' + fileName);
  inherited Create(fileDIR + 'analog.mem', MAIN_MAP_NAME);


  fPHeader := Data;
  //данные, которые раньше содержались в заголовке, не соответствуют размеру файла
  //значит грузим новую базу
  with fPHeader^ do
    if RecordCount * RecordSize + HeaderSize <> fileSize then
      isBaseReload := True
    else
      isBaseReload := False;
             {if MessageDlg('Размер базы в памяти и загружаемой не совпадает. Перезаписать?',mtWarning, [mbYes, mbNo], 0) = mrYes then
                isBaseReload := true else isBaseReload := false;}
  if isBaseReload then
  begin
    fStr := TFileStream.Create(fileName, fmOpenReadWrite);
    try
      fStr.Read(Data^, fStr.Size);
    finally
      fStr.Free;
    end;
  end;


  //если версии совпадают проверить размер заголовка и записи
  if (FPHeader^.Ver = CurrentBaseVersion) then
  begin
    if fpHeader^.HeaderSize <> SizeOf(TAnalogMemHdr) then
      raise Exception.Create('Неверный размер заголовка.');
    if fpHeader^.RecordSize <> SizeOf(TAnalogMem) then
      raise Exception.Create('Неверный размер записи.');
  end;

  if (FPHeader^.Ver > CurrentBaseVersion) then
    raise Exception.Create(
      'База данных имеет более позднюю версию. Преобразоавние невозможно');
  if (FPHeader^.Ver < CurrentBaseVersion) then
    if MessageDlg('База данных имеет более раннюю версию. Преобразовать?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ConvertBase
    else
      raise Exception.Create('Конфликт версий.');

  fileStrings := TMappedFilePsevdo.Create(fileDIR + 'strings.mem', STRING_MAP_NAME);
  command := TCommandMems.Create(fileDIR, COMMAND_MAP_NAME);
  alarms := TAlarmMems.Create(ALARMS_MAP_NAME, 50000);
  activeAlarms := TActiveAlarmMems.Create(self, ALARMLOCALS_MAP_NAME);
  if ((fdebugL = DEBUGLEVEL_HIGH) or (fdebugL = DEBUGLEVEL_MIDLE) or
    (fdebugL = DEBUGLEVEL_LOW)) then
    fdebugBase := TDebugMems.Create(DEBUGS_MAP_NAME, 40000);
  ;
  if (localbase) then
  begin
    analogLocBase := TAnalogLocBaseMems.Create(self, ANALOGLOCBASE_MAP_NAME);

  end
  else
  begin
    analogLocBase := nil;
    //   absensAnalog:=nil;
  end;
  //  ValCh := TCommandMems.Create(fileDIR, VALUECHANGE_MAP_NAME);
  //  calc := TcalcMems.Create(fileDIR);
  Regs := TRegs.Create(Self, REGISTRATION_MAP_NAME);
  fTegGroups := TGroups.Create(PathMem + 'groups.cfg');
  fAlarmGroups := TGroups.Create(PathMem + 'AlarmGroups.cfg');
  oper := TOperatorMems.Create(fileDIR);
  IndexStringList := TStringList.Create;
  IndexStringList.Sorted := True;

  RebuildIndex;

  kvitID := GetSimpleID(KvitTegName);
  if kvitID <> -1 then
    Items[KvitID].ValReal := 0;
end;

procedure TAnalogMems.RebuildIndex();
var
  i: integer;
begin
  IndexStringList.Clear;
  for i := 0 to Count - 1 do
    if Items[i].ID <> -1 then
      AddIndex(Items[i].ID);
end;


function TAnalogMems.isIdent(Name: string): boolean;
begin
  Result := (GetSimpleID(Name) <> -1);
end;

function TAnalogMems.isDiscret(number: integer): boolean;
begin
  Result := pos('.', GetDDEItem(number)) <> 0;
end;

function TAnalogMems.GetStringValue(pos: integer): string;
begin
  Result := '';
  if (pos <> -1) {and (pos <> 0)} then   //18.03.04 ska
    Result := PChar(fileStrings.Data) + pos + sizeOf(short);
end;

function TAnalogMems.GetName(i: longint): string;
begin
  Result := GetstringValue(Items[i].NamePos);
  //o  if result = '' then raise Exception.Create ('No elements name founded');
end;

function TAnalogMems.GetComment(i: longint): string;
begin
  Result := GetstringValue(items[i].CommentPos);
end;

function TAnalogMems.GetOnMsg(i: longint): string;
begin
  Result := GetstringValue(items[i].OnMsgPos);
end;

procedure TAnalogMems.getOschTeg(num: integer; var val: TOschTegGrope);

  function GetWordsR(var str: string): string;
  begin
    Result := '';
    Result := AnsiUpperCase(copy(str, 1, pos('/', str) - 1));
    str := copy(str, pos('/', str) + 1, length(str) - pos('/', str));
  end;

var
  strS, rtn: string;
begin
  setlength(val.num, 0);
  val.n := 0;
  if (num > Count - 1) or (num < 0) then
    exit;
  strS := self.GetOnMsg(num);
  while trim(strS) <> '' do
  begin
    rtn := GetWordsR(strS);
    if trim(rtn) <> '' then
    begin
      if getSimPleId(trim(rtn)) > -1 then
      begin
        setlength(val.num, val.n + 1);
        val.num[val.n] := getSimPleId(trim(rtn));
        val.n := val.n + 1;
      end;
    end;
  end;
end;

function TAnalogMems.GetOffMsg(i: longint): string;
begin
  Result := GetstringValue(items[i].OffMsgPos);
end;

procedure TAnalogMems.AddIndex(ID: integer);
var
  j: ^integer;
begin
  new(j);
  j^ := ID;
  IndexStringList.Objects[IndexStringList.Add(UpperCase(GetName(id)))] := TObject(j);
end;

procedure TAnalogMems.RemoveIndex(ID: integer);
begin
  IndexStringList.Delete(IndexStringList.indexOf(GetName(ID)));
end;

function TAnalogMems.GetItem(number: integer): PTAnalogMem;
begin
  Result := @(TAnalogsStruct((Pointer(PChar(Data) + FPHeader^.HeaderSize))^).Items
    [number]);
end;

function TAnalogMems.GetSimpleID(ItemName: string): integer;
var
  i: integer;
  str: string;
  j: integer;
begin
  Result := -1;
  if itemName = '' then
    exit;
    { for i := 0 to Count - 1 do
     begin
         str := ItemName;
         if AnsiUpperCase(GetName(i)) = AnsiUpperCase(str) then begin
            result := Items[i].ID;
            exit;
         end;
     end; }
  J := IndexStringList.IndexOf(UPPERCASE(ItemName));
  if j <> -1 then
    Result := integer(pint(IndexStringList.Objects[j])^);

end;

function TAnalogMems.GetID(ItemName: string): integer;
begin
  Result := GetSimpleID(ItemName);
  if Result <> -1 then
    exit;
  // result := calc.GetID (ItemName);
  if Result <> -1 then
  begin
    Inc(Result, calcShift);
    exit;
  end;
  //если имя не найдено в базе данных,
  //считаем что это выражение и добавляем его в базу выражений
  // calc.AddItem (ItemName);
  // result := calcShift + calc.Count - 1;
end;

procedure TAnalogMems.IncCounter(number: integer); //return number
begin
  if number < Count then
  begin
    Inc(Items[Number].RefCount);
    if Items[Number].RefCount = 1 then
      Regs.NotifyNewRef(Number);
  end;
end;

procedure TAnalogMems.DecCounter(number: integer);
begin
  if number < Count then
  begin
    Dec(Items[Number].RefCount);
    if Items[Number].RefCount = 0 then
      Regs.NotifyRemRef(Number);
  end;
end;

procedure TAnalogMems.ValidOff(number: integer);
begin
  SetValid(number, 0);
end;

procedure TAnalogMems.SetValid(number: integer; valid: integer);
var
  wasValid: boolean;
begin
  wasValid := IsValid(number);
  Items[number].ValidLevel := Valid;
  if wasValid <> IsValid(number) then
  begin
    regs.NotifyValid(number);
    if (Items[number].Logged) or (Items[Number].logtime = EVENT_TYPE_WITH_TIME_VAL) then
      Regs.NotifyLog(-1, Number);
    if IsValid(number) then
    begin
      Regs.NotifyEvents(0, Number);
      Regs.NotifyAlarm(0, Number);
      Regs.NotifyAlarmLocal(0, Number);
    end;
  end;
end;


procedure TAnalogMems.AddCommand(number: integer; val: real;
  queue: boolean; CompName: string = ''; userName: string = '');
var
  sysgrid: integer;
begin
  //добавляющий команду увеличивает колич. ссылок, если команда новая
  //выполняющ. уменьшает
  if Items[Number].ID = -1 then
    exit;
  if compName = '' then
    compName := HostName;
  if (userName = '') and (trim(uppercase(hostname)) = trim(uppercase(CompName))) then
    userName := operator_;
  sysgrid := fTegGroups.ItemNum['$SYSTEM'];     // добавлено 8.11.2009
  if Items[Number].GroupNum <> sysgrid then      // добавлено 8.11.2009
  begin
    if Command.AddItem(number, Items[Number].ValReal, Val, queue, compName, userName) =
      acNewCommand then
      incCounter(number);
  end
  else
    Items[Number].ValReal := val;            // добавлено 8.11.2009
  SetVal(Number, Val, Items[Number].ValidLevel);
  // поменял местами
  //Regs.NotifyCommands(Command.Count-1, Number);        //        28.1.04
  Regs.NotifyCommands(Command.LastCommandLine, Number);        //        12.03.04
end;

procedure TAnalogMems.RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
begin
  Regs.RegHandle(Name, Handle, Events);
end;

procedure TAnalogMems.UnRegHandle(Handle: THandle);
begin
  Regs.UnRegHandle(Handle);
end;

procedure TAnalogMems.Log(mess: string; lev: byte = 2);
begin
  if fdebugbase <> nil then
  begin
    if (fdebugL <= lev) then
    begin
      fdebugbase.AddItem(now, mess, fAppl, lev);
    end;
  end;
end;

procedure TAnalogMems.LogWarning(mess: string);
begin
  Log(mess, _DEBUG_WARNING);
end;

procedure TAnalogMems.LogError(mess: string);
begin
  Log(mess, _DEBUG_ERROR);
end;

procedure TAnalogMems.LogFatalError(mess: string);
begin
  Log(mess, _DEBUG_FATALERROR);
end;

procedure TAnalogMems.SetValue(number: integer; val: real);
var
  prevVal: real;
begin
  if ((Items[Number].ValReal <> Val) and
    (Items[Number].logtime <> EVENT_TYPE_WITHTIME)) then
  begin
    prevVal := Items[Number].ValReal;
    Items[Number].ValReal := val;

    // ValCh.AddItem(number, prevVal, Val, true);

    if (Items[number].Logged) or (Items[Number].logtime = EVENT_TYPE_WITH_TIME_VAL) then
    begin
      if (Items[number].ValidLevel > VALID_LEVEL) and
        (abs(prevVal - Items[Number].ValReal) >= Items[Number].logDB) then
        Regs.NotifyLog(0, Number);
    end;
    if (Items[number].ValidLevel > VALID_LEVEL) and
      ((Items[number].OnMsged and (Items[number].ValReal <> 0) and (prevVal = 0)) or
      (Items[number].OffMsged and (Items[number].ValReal = 0) and (prevVal <> 0))) then
      Regs.NotifyEvents(0, Number);
    if Items[number].Alarmed then
      Regs.NotifyAlarm(0, Number);
    ;
    if Items[number].AlarmedLocal then
      Regs.NotifyAlarmLocal(0, Number);
    Regs.NotifyChange(0, Number);
  end;
  if (Items[Number].logtime = EVENT_TYPE_WITHTIME) then
    Regs.NotifyChange(0, Number);
end;

procedure TAnalogMems.SetVal(number: integer; val: real; VL: integer);
var
  prevVal: real;
  rstVL, rstVal, rstTm: boolean;
  newVL, oldVL: boolean;
  newVal, oldVal: real;
  LTim: integer;
  logged_, alarmed_, alarmedlocal_, msged_: boolean;
begin
  newVL := VL > VALID_LEVEL;
  oldVL := isValid(number);
  oldVaL := Items[number].ValReal;
  newVal := val;
  rstVL := (isValid(number) <> newVL);
  rstVal := (val <> (Items[number].ValReal));
  logged_ := Items[number].Logged;
  alarmed_ := Items[number].Alarmed;
  alarmedlocal_ := Items[number].AlarmedLocal;
  msged_ := ((Items[number].OffMsged) or (Items[number].OnMsged));
  LTim := rtItems.Items[Number].logTime;
  prevVal := Items[Number].ValReal;
  Items[Number].ValReal := val;
  rstTm := abs(secondsbetween(now, Items[Number].TimeStamp)) > 30;
  Items[Number].ValidLevel := VL;

  if (rstVL or rstVal or rstTm) then
  begin

    // для трендов
    if (logged_) and not (LTim in REPORT_SET) then
    begin
      if rstVL then
        Regs.NotifyLog(0, Number) // при фронте валидности
      // пишем всегда   ( при исчезновении для создания метки исчезновения)
      else
      begin
        if ((newVL) and       //  иначе только в плюсовой валидности
          ((abs(prevVal - newVaL) >= Items[Number].logDB) or (rstTm)))
        then
        begin
          rtItems.Items[Number].TimeStamp := now;
          Regs.NotifyLog(0, Number);
        end;
      end;
    end;

    // для внутренних трендов
    if (logged_) then
    begin
      if rstVL then
        Regs.NotifyLogInside(0, Number) // при фронте валидности
      // пишем всегда   ( при исчезновении для создания метки исчезновения)
      else
      begin
        if (newVL)        //  иначе только в плюсовой валидности
        then
          Regs.NotifyLogInside(0, Number);
      end;
    end;

    //  для сообщений
    if (msged_) then
    begin    // пишем только в случае  newVL=oldVL+ в валидном состоянии
      // избегаем мусорных сообщений
      if (newVL and oldVL) then
        if (((Items[number].OnMsged) and (oldVaL = 0) and (newval <> 0)) or
          ((Items[number].OffMsged) and (oldVaL <> 0) and (newval = 0))) then
          Regs.NotifyEvents(0, Number);
    end;
    // для журнала и тревог
    if (alarmed_ and rstVal) then
      // закомментировал rstVal // скидывало валидность 2015-10-02
    begin    // пишем  в случае  newVL=oldVL+ в валидном состоянии  и при возникновении валиности

      if (newVL) then
        Regs.NotifyAlarm(0, Number);
    end;

    if (alarmedlocal_ and rstVal) then
      // закомментировал rstVal // скидывало валидность 2015-10-02
    begin    // пишем  в случае  newVL, oldVL + newVL
      if (newVL) then
        Regs.NotifyAlarmLocal(0, Number);
    end;

    if (newVL) then
      Regs.NotifyChange(0, Number);
  end;
  if (Items[Number].logtime = EVENT_TYPE_WITH_TIME_VAL) then
    Regs.NotifyLog(0, Number);
  if (Items[Number].logtime = EVENT_TYPE_WITHTIME) then
    Regs.NotifyChange(0, Number);
end;


procedure TAnalogMems.SetValForce(number: integer; val: real; VL: integer);
begin
  if number < 0 then
    exit;
  Items[Number].ValidLevel := VL;
  SetVal(number, val, VL);

end;

destructor TAnalogMems.Destroy;

var
  i: integer;
begin
  oper.Free;
  for i := 0 to IndexStringList.Count - 1 do
  begin
    dispose(Pint(IndexStringList.Objects[i]));
  end;
  IndexStringList.Free;
  fTegGroups.Free;
  fAlarmGroups.Free;
  fileStrings.Free;
  command.Free;
  alarms.Free;
  activeAlarms.Free;
  // ValCh.Free;
  //  calc.free;
  Regs.Free;
  if assigned(analogLocBase) then
    analogLocBase.Free;
  if assigned(self.fdebugBase) then
    fdebugBase.Free;
  inherited;
end;

function TAnalogMems.isValid(number: integer): boolean;
begin
  Result := (Items[number].ValidLevel > VALID_LEVEL);
end;

//*******************CalcMems**************************//
{constructor TCalcMems.Create (fileDIR : string);
begin
     inherited Create('calc');
end;

function TCalcMems.GetItem (number: integer): PTCalcMem;
begin
     result := PTCalcMem(@(PTCommands(data)^.Items[number]));
end;

procedure TCalcMems.SetItem( number: integer; item: PTCalcMem);
begin
     Move(item^, PTCommands(data)^.Items[number], SizeOf (item^));
end;

procedure TCalcMems.AddItem( name: string);
var
   item: ptCalcMem;
begin
  new(item);
  try
    Item.Name := Name;
    Item.ID := Count;
    Item.ValReal:= 0;
    Item.ValidLevel := 0;
    Item.refCount := 0;
    Item.CommentPos := -1;
    Item.OnMsgPos := -1;
    Item.OffMsgPos := -1;
    Items[count] := item;
    inherited Count := Count + 1;
  finally
    dispose (Item);
  end;
end;

function TCalcMems.GetID(ItemName: String): integer;
var
   i: integer;
begin
     result := -1;
     for i := 0 to Count - 1 do
         if UpperCase(ItemName) = UpperCase(Items[i].Name) then begin
            result := i;
            exit;
         end;
end;

procedure TCalcMems.IncCounter(number: integer); //return number
begin
     inc(Items[number].refCount);
end;

procedure TCalcMems.DecCounter (number: integer);
begin
     if (Items[number].refCount > 0) then dec(Items[number].refCount);
end;

function TCalcMems.isValid(number: integer): boolean;
begin
     result := (Items[number].ValidLevel > 90);
end;      }

//*******************ComandMems**************************//
function TCommandMems.GetItem(number: longint): TCommandStruct;
begin
  Result := PTCommands(Data)^.Items[number];
end;

function TCommandMems.GetItemN(number: integer): PTCommandStruct;
begin
  if CurLine + number < Count then
    Result := @(PTCommands(Data)^.Items[curline + number])
  else
    Result := @(PTCommands(Data)^.Items[curline + number - Count]);
end;

constructor TCommandMems.Create(fileDIR: string; MemName: string);
begin
  inherited Create(MemName);
  if isNewFileOpened then
  begin
    PTCommands(Data)^.Header.Count := 0;
    PTCommands(Data)^.Header.LastNumber := 0;
  end;
end;

procedure TCommandMems.SetExecuted(num: longint);
begin
  PTCommands(Data)^.Items[num].Executed := True;
end;

procedure TCommandMems.ClearExecuted(num: longint);
begin
  PTCommands(Data)^.Items[num].Executed := False;
end;

function TCommandMems.AddItem(number: integer; PrevVal, val: real;
  queue: boolean; compName: string = ''; username: string = ''): TAddedItemType;
var
  i: integer;
begin
  Result := acNewCommand;
  LastCommandLine := -1;
  if not queue then
    for i := Count - 1 downto 0 do
      if (Items[i].id = number) and (not Items[i].executed) then
      begin
        SetExecuted(i);//заблокировать выполнение
        LastCommandLine := i;
        Result := acQueuedCommand;
        break;
      end;
  if LastCommandLine = -1 then
  begin
    if CurLine = maxCount then
    begin
      inherited curLine := 0;
      inherited firstNumber := PTCommands(Data)^.Items[CurLine].Number;
    end;

    LastCommandLine := CurLine;
    ClearExecuted(LastCommandLine);

    if Count < maxCount then
      inherited Count := Count + 1;
    inherited CurLine := CurLine + 1;
    inherited LastNumber := LastNumber + 1;

    PTCommands(Data)^.Items[LastCommandLine].Number := lastNumber;
    PTCommands(Data)^.Items[LastCommandLine].PrevVal := PrevVal;
  end;

  PTCommands(Data)^.Items[LastCommandLine].ID := number;
  PTCommands(Data)^.Items[LastCommandLine].valReal := val;
  PTCommands(Data)^.Items[LastCommandLine].CompName := CompName;
  PTCommands(Data)^.Items[LastCommandLine].UserName := UserName;
  PTCommands(Data)^.Items[LastCommandLine].Executed := False;
  //разблокировать выполнение
end;

procedure TCommandMems.Compress; //удаляет отработанные команды
begin
  PTCommands(Data)^.Header.Count := 0;
end;

destructor TCommandMems.Destroy;
begin
  inherited;
end;

//******************* AlarmMems **************************//
constructor TAlarmMems.Create(MemName: string; aMaxCount: integer);
begin
  inherited CreateW(MemName, aMaxCount, sizeof(TAlarmStruct) *
    (aMaxCount + 100) + sizeof(THeaderStruct));
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).LastNumber := 0;
  end;
  THeaderStruct(Data^).MaxCount := aMaxCount;
end;

function TAlarmMems.ConvertNumber(number: integer): integer;
  //переводим № аларма по порядку в номер строки
var
  firstLine: integer;
begin
  firstLine := ifthen(Count = maxCount, curLine, 0);
  Result := (firstNumber + number) mod (MaxCount - 1);
end;

function TAlarmMems.GetItem(num: longint): PTalarmStruct;
begin
  if (num >= Count) or (num < 0) then
    raise Exception.Create('TAlarmsMem индекс за границей! ' + IntToStr(num));
  Result := @(PTalarms(Data)^.Items[ConvertNumber(num)]);
end;

function TAlarmMems.AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType): integer;
var
  i: integer;
begin
  inherited LastNumber := LastNumber + 1;
  if Count < maxCount then
    inherited Count := Count + 1;
  Items[curLine].number := lastNumber;
  Items[curLine].Time := aTime;
  Items[curLine].TegID := aTegID;
  Items[curLine].Typ := aTyp;
  Result := curLine;
  inherited CurLine := convertNumber(CurLine + 1);
end;

function TAlarmMems.AddItem(atime: TDateTime; aTegID: integer;
  atyp: TMsgType; comp: string; oper: string): integer;
var
  i: integer;
begin
  inherited LastNumber := LastNumber + 1;
  if Count < maxCount then
    inherited Count := Count + 1;
  Items[curLine].number := lastNumber;
  Items[curLine].Time := aTime;
  Items[curLine].TegID := aTegID;
  Items[curLine].Typ := aTyp;
  if atyp = msCmd then
  begin
    Items[curLine].oper := '';
    if comp <> '' then
      Items[curLine].oper := '[' + comp + ']';
    Items[curLine].oper := Items[curLine].oper + oper;
  end;
  Result := curLine;
  inherited CurLine := convertNumber(CurLine + 1);
end;

destructor TAlarmMems.Destroy;
begin
  inherited;
end;


//************************** TAnalogMems **************************//
procedure TAnalogMems.SetName(i: integer; Value: string);
begin
  SetStringValue(Items[i].NamePos, Value);
end;

procedure TAnalogMems.SetComment(i: integer; Value: string);
begin
  SetStringValue(Items[i].CommentPos, Value);
end;

procedure TAnalogMems.SetOnMsg(i: integer; Value: string);
begin
  SetStringValue(Items[i].OnMsgPos, Value);
end;

procedure TAnalogMems.SetOffMsg(i: integer; Value: string);
begin
  SetStringValue(Items[i].OffMsgPos, Value);
end;

procedure TAnalogMems.setOperator(val: string);
begin
  operator_ := val;
end;

procedure TAnalogMems.SetStringValue(var pos: longint; Value: string);
var
  allocSize: short;//объем выделенной памяти вод строку
  fStr: TFileStream;
begin
  if Value = '' then
  begin
    pos := -1;
  end
  else
  begin
    if (pos <> -1) and (pos <> 0) then
      //определяем объем уже выделенной памяти под эту строку
      move((PChar(fileStrings.Data) + pos)^, allocSize, SizeOf(allocSize))
    else
      allocSize := 0;

    //если размер строки увеличен, пишем строку в конец файла
    if (allocSize < Length(Value) + 1) then
    begin
      allocSize := Length(Value) + 1;
      pos := fileStrings.FileSize;//определяем позицию записи строки
      fileStrings.fileSize := fileStrings.FileSize + allocSize + sizeOf(allocSize);
    end;
    //пишем объем выделенной памяти
    move(allocSize, (PChar(fileStrings.Data) + pos)^, sizeOf(allocSize));
    //пишем строковые даные в память
    system.move(PChar(Value)^, (PChar(fileStrings.Data) + pos +
      sizeof(allocSize))^, Length(Value) + 1);
    //записываем данные в файл
    fStr := TFileStream.Create(ffileDIR + 'strings.mem', fmOpenReadWrite);
    try
      fStr.Seek(pos, soFromBeginning);
      fStr.Write(allocSize, sizeOf(allocSize));
      fStr.Write(PChar(Value)^, Length(Value) + 1);
      if fStr.Size <> fileStrings.FileSize then
        raise Exception.Create('Не совпадают дисковый и действительный размеры базы!!!');
    finally
      fStr.Free;
    end;
    //pos := pos + sizeof(allocSize);
  end;
end;

function TAnalogMems.GetCount: integer;
begin
  { try   }
  Result := fPHeader^.RecordCount;
 { except
    raise Exception.Create('Некорректное выражение');
  end;      }
end;

procedure TAnalogMems.SetCount(const Value: integer);
var
  fStr: TFileStream;
begin
  fPHeader^.RecordCount := Value;
  fStr := TFileStream.Create(ffileDIR + 'Analog.mem', fmOpenReadWrite);
  try
    fStr.Seek(0, SoFromBeginning);
    fStr.Write(fPHeader^, SizeOf(fPHeader^));
  finally
    fStr.Free;
  end;
end;

procedure TAnalogMems.ConvertBase;
var
  i: integer;
begin
  for i := fpHeader^.RecordCount - 1 downto 0 do
  begin
    //предварительно заполняе нулями
    fillChar((PChar(Data) + FPHeader^.HeaderSize + I * sizeOf(TanalogMem) +
      FPHeader^.RecordSize)^,
      sizeOf(TanalogMem) - FPHeader^.RecordSize, 0);
    move((PChar(Data) + FPHeader^.HeaderSize + I * FPHeader^.RecordSize)^,
      (PChar(Data) + SizeOf(TAnalogMemHdr) + I * sizeOf(TanalogMem))^,
      FPHeader^.RecordSize);
  end;
  with FPHeader^ do
  begin
    Ver := currentBaseVersion;
    HeaderSize := sizeOf(TAnalogMemHdr);
    RecordSize := sizeOf(TAnalogMem);
    DataSize := HeaderSize + RecordSize * RecordCount;
    fileSize := dataSize;
  end;
  writeBaseToFile(False);
end;



function TAnalogMems.GetItemOffset(ItemNum: integer): longint;
begin
  Result := FPHeader^.HeaderSize + ItemNum * SizeOf(TAnalogMem);
end;

procedure TAnalogMems.WriteToFileAll();
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    WriteToFile(i);
  end;
end;

procedure TAnalogMems.WriteToFile(curItem: integer);
var
  fStr: TFileStream;
  curRefCount: integer;
  curIsKvit: boolean;
  curBoolAO: boolean;
  curBoolAK: boolean;
  varsGrnum: integer;
  ValReal_: real;
  ValidLevel_: integer;
  GroupNum_: integer;
  DeathB: real;
begin

  ValidLevel_ := items[curItem].ValidLevel;
  GroupNum_ := items[curItem].GroupNum;
  varsGrnum := TegGroups.ItemNum['$SYSVAR'];
  DeathB := items[curItem].TimeStamp;

  if (trim(GetName(curItem)) = '') and (items[curItem].ID > -1) then
    exit;
  fStr := TFileStream.Create(ffileDIR + 'Analog.mem', fmOpenReadWrite);
  try
    fStr.Seek(GetItemOffset(curItem), SoFromBeginning);
    //сохраняем что бы сбросить для записи количество ссылок

    CurRefCount := items[curItem].refCount;
    items[curItem].refCount := 0;

    curBoolAO := items[curItem].isAlarmOn;
    items[curItem].isAlarmOn := False;

    curBoolAK := items[curItem].isAlarmKvit;
    items[curItem].isAlarmKvit := True;

    // записываем условие неалармности
    ValReal_ := items[curItem].ValReal;
    if (GroupNum_ <> varsGrnum) then
    begin
      if (items[curItem].alarmCase <> alarmEqual) then
      begin
        if (items[curItem].alarmCase = alarmMore) then
        begin
          if (items[curItem].AlarmConst >= 0) then
            items[curItem].ValReal := 0
          else
            items[curItem].ValReal := items[curItem].AlarmConst;
        end
        else
        begin
          items[curItem].ValReal := items[curItem].AlarmConst;
        end;
      end
      else
      begin
        if (items[curItem].AlarmConst <> 0) then
          items[curItem].ValReal := 0
        else
          items[curItem].ValReal := 1;
      end;
    end
    else
    begin
      // ValReal_:=items[curItem].ValReal;
    end;


    // записываем нулевую валидность
    // кроме $SYSVAR
    ValidLevel_ := items[curItem].ValidLevel;
    if (GroupNum_ <> varsGrnum) then
      items[curItem].ValidLevel := 0
    else
      items[curItem].ValidLevel := 100;
    items[curItem].TimeStamp := 0;
    CurIsKvit := items[curItem].isAlarmKvit;
    items[curItem].isAlarmKvit := True;
    // записываем запись
    fStr.Write(items[curItem]^, SizeOf(TAnalogMem));
    //восстанавливаем количество ссылок
    items[curItem].refCount := CurRefCount;
    items[curItem].isAlarmKvit := CurIsKvit;
    items[curItem].TimeStamp := DeathB;
    items[curItem].isAlarmKvit := curBoolAK;
    items[curItem].isAlarmOn := curBoolAO;
    if (GroupNum_ <> varsGrnum) then
      items[curItem].ValReal := ValReal_;
    if (GroupNum_ <> varsGrnum) then
      items[curItem].ValidLevel := ValidLevel_;
  finally
    fStr.Free;
  end;
  if (GetSimpleID(GetName(curItem)) = -1) and (Items[curItem].ID <> -1) then
    AddIndex(curItem);
end;

{ TMappedFilePsevdo }

{***************************** TMappedFilePsevdo ************************************}
//выделяет файл в памяти и копирует туда содержание файла
//при этом файл не блокируется, и можо его дополнять без проблем

constructor TMappedFilePsevdo.Create(fileNm, mapNm: string;
  oldOverride: boolean = False);
var
  fStr: TFileStream;
begin
  inherited Create('', MapNm);
  fStr := TFileStream.Create(filenm, fmOpenReadWrite);
  try
    if isNewFileOpened or oldOverride then
      fStr.Read(Data^, fStr.Size);
    fileSize := fStr.Size;
  finally
    fStr.Free;
  end;
end;

procedure TAnalogMems.FreeItem(Num: integer);
begin
  if GetSimpleID(GetName(Num)) <> -1 then
    RemoveIndex(Num);
  Items[Num].ID := -1;
  Items[Num].NamePos := -1;
  Items[Num].CommentPos := -1;
  Items[Num].OnMsgPos := -1;
  Items[Num].OffMsgPos := -1;
end;

procedure TAnalogMems.addLocalBaseTag(idA: integer);
begin
  if (localbase) and (self.analogLocBase <> nil) then
    self.analogLocBase.AddItem(idA);
end;

class function TAnalogMems.isLock: boolean;
begin
  Result := MappedMemoryisLock(MAIN_MAP_NAME);
end;

procedure TAnalogMems.addLocalBaseGroup(idGroup: integer);
begin
  //  if (localbase) and (absensAnalog<>nil) and (conttimeoff) then self.absensAnalog.AddItem(idGroup)
end;

procedure TAnalogMems.setLocalBaseTagval(ltime: TDateTime; aTagId: integer;
  Value: single; valid: integer);
begin
  if (localbase) and (self.analogLocBase <> nil) then
    self.analogLocBase.setvalue(ltime, aTagId, Value, valid);
end;

procedure TAnalogMems.setLocalBaseGroupval(ltime: TDateTime; GrouId: integer;
  state: boolean);
begin
  // if (localbase) and (absensAnalog<>nil) and (conttimeoff) then self.absensAnalog.setvalue(ltime, GrouId, state)
end;

function TAnalogMems.QueryLocalBaseTag(tim: TDateTime; minut: integer;
  aTagid: integer; var val: tTDPointData): Tdatetime;
begin
  Result := 0;
  if (localbase) and (self.analogLocBase <> nil) then
    Result := self.analogLocBase.getquery(tim, minut, aTagid, val);
end;




function TAnalogMems.GetDDEItem(i: integer): string;
begin
  Result := GetstringValue(Items[i].ItemPos);
end;

function TAnalogMems.TagDubleErr(val: integer): integer;
var
  i: integer;
  j: string;
begin
  Result := -1;
  if val > Count - 1 then
    exit;
  if items[val].ID < 0 then
    exit;
  for i := 0 {val - правильнее} to Count - 1 do
    if (i <> val) and (trim(uppercase(GetName(i))) = trim(uppercase(GetName(val)))) then
    begin
      Result := i;
      exit;
    end;
end;


function TAnalogMems.TagDubleErrIs: boolean;
var
  i: integer;
  j: string;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if TagDubleErr(i) > -1 then
    begin
      Result := True;
      exit;
    end;
end;

procedure TAnalogMems.ClearDubleErr;
var
  i: integer;
  j: integer;
begin
  i := 0;
  for i := 0 to Count - 1 do
    if ((Items[i].ID > -1) and (trim(GetName(i)) = '')) then
    begin
      ShowMessage('Обнаружен пустой тег ID=' + IntToStr(Items[i].ID) + '. ' +
        'Он будет удален');
      Items[i].ID := -1;
      Items[i].NamePos := -1;
      Items[i].CommentPos := -1;
      Items[i].OnMsgPos := -1;
      Items[i].OffMsgPos := -1;
      WriteToFile(i);
    end;
  i := 0;
  while i < Count do
  begin
    j := TagDubleErr(i);
    if j > -1 then
    begin
      ShowMessage('Обнаружен дублированный тег "' + getname(i) + '" ' + #10 + #13 +
        ' позиция рабочего - ' + IntToStr(i) +
        ', позиция дубликата -' + IntToStr(j) + #10 + #13 + ' ' +
        'Дупликат будет переименован в ' + self.getname(i) + '_doubleerror' + '!!! ');
      Items[i].ID := i;
      self.setname(i, self.getname(i) + '_doubleerror');
      self.WriteToFile(i);
    end;
    Inc(i);
  end;

end;

function TAnalogMems.GetAlarmMsg(i: integer): string;
begin
  Result := GetstringValue(Items[i].AlarmMsgPos);
end;

procedure TAnalogMems.SetAlarmMsg(i: integer; Value: string);
begin
  SetStringValue(Items[i].AlarmMsgPos, Value);
end;

function TAnalogMems.GetEU(i: integer): string;
begin
  Result := GetstringValue(Items[i].EUPos);
end;

procedure TAnalogMems.SetEU(i: integer; Value: string);
begin
  SetStringValue(Items[i].EUPos, Value);
end;

procedure TAnalogMems.SetDDEItem(i: integer; Value: string);
begin
  SetStringValue(Items[i].ItemPos, Value);
end;

function TAnalogMems.GetAlarmCase(i: integer): string;
begin
  case Items[i].alarmCase of
    alarmLess: Result := '<';
    alarmMore: Result := '>';
  end;
end;

procedure TAnalogMems.SetAppName(app: string);
begin
  self.fAppl := app;
end;

procedure TAnalogMems.ClearCommandExecuted(ComNum: integer);
begin
  command.ClearExecuted(ComNum);
  incCounter(command.Items[comNum].ID);
end;

procedure TAnalogMems.SetCommandExecuted(ComNum: integer);
begin
  command.SetExecuted(ComNum);
  decCounter(command.Items[comNum].ID);
end;


function Regrtitems(point: Pointer; point1: pointer; point2: pointer;
  pactive: pointer): pointer;
begin
  rtitems := TAnalogMems(point);
  Result := rtitems;
  EXIT; //24.05.04 - алармы теперь в мем файле
end;

procedure SetAcsessAdress(p: pointer; pname: pointer; ppas: pointer);
begin
  AccessLevel := p;
  OperatorName := pname;
  CurrantKey := ppas;

end;

procedure TAnalogMems.writeBaseToFile(ClearStrings: boolean);
var
  fStr: TFileStream;
begin
  if ClearStrings then
    ClearDubleErr;
  ShowMessage('Запись всей базы на диск');
  fStr := TFileStream.Create(ffileDIR + 'Analog.mem', fmCreate);
  try
    fStr.Write(Data^, SizeOf(fPHeader^) + Count * SizeOf(TAnalogMem))
  finally
    fStr.Free;
  end;
  if ClearStrings then
  begin
    fStr := TFileStream.Create(ffileDIR + 'strings.mem', fmCreate);
    fStr.Free;
  end;
end;

{ TActiveAlarmMems }

function TActiveAlarmMems.AddItem(atime: TDateTime; aTegID: integer): integer;
var
  i: integer;
begin
  TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmOn := True;
  TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmKvit := False;
  for i := 0 to Count - 1 do
    if Items[i].TegID = aTegId then
    begin
      Items[i].isOff := False;
      exit;
    end;

  inherited Count := Count + 1;
  inherited LastNumber := LastNumber + 1;
  Items[Count - 1].number := lastNumber;
  Items[Count - 1].Time := aTime;
  Items[Count - 1].TegID := aTegID;
  Items[Count - 1].isKvit := False;
  Items[Count - 1].isOff := False;
  Result := Count - 1;
  TAnalogMems(rtItemsPointer).alarms.AddItem(Now, aTegId, msNew);
  TAnalogMems(rtItemsPointer).Regs.NotifyNewAlarm;
end;

procedure TActiveAlarmMems.CheckOut;
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
  begin
    if items[i].isKvit and items[i].isOff then
    begin
      TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msOut);
      TAnalogMems(rtItemsPointer).Items[items[i].TegID].isAlarmOn := False;
      if i < (Count - 1) then //если элемент не последний, подтягиваем хвост
      begin
        move(items[i + 1]^, items[i]^, sizeOf(TActiveAlarmStruct) * (Count - i));
      end;
      inherited Count := Count - 1;
    end;
  end;
end;

constructor TActiveAlarmMems.Create;
begin
  inherited Create(MemName);
  rtItemsPointer := rtItemsPtr;
end;

destructor TActiveAlarmMems.Destroy;
begin
  inherited;
end;

function TActiveAlarmMems.GetItem(num: integer): PTActiveAlarmStruct;
begin
  if (num >= Count) or (num < 0) then
    raise Exception.Create('TActiveAlarmsMem индекс за границей! ' + IntToStr(num));
  Result := @(PTActiveAlarms(Data)^.Items[num]);

end;

procedure TActiveAlarmMems.KvitAll;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := True;
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> True then
      begin
        items[i].isKvit := True;
        TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msKvit);
        inherited LastNumber := LastNumber + 1;
      end;
    end;
  end;
  CheckOut;
end;

procedure TActiveAlarmMems.KvitAlarmGroup(grnum: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if TAnalogMems(rtItemsPointer).Items[items[i].TegId].AlarmGroup = grnum then
    begin
      TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := True;
      if not items[i].isKvit then
      begin
        if items[i].isKvit <> True then
        begin
          items[i].isKvit := True;
          TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msKvit);
          inherited LastNumber := LastNumber + 1;
        end;
      end;
    end;
  end;
  CheckOut;
end;

procedure TActiveAlarmMems.KvitTagGroup(grnum: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if TAnalogMems(rtItemsPointer).Items[items[i].TegId].GroupNum = grnum then
    begin
      TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := True;
      if not items[i].isKvit then
      begin
        if items[i].isKvit <> True then
        begin
          items[i].isKvit := True;
          TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msKvit);
          inherited LastNumber := LastNumber + 1;
        end;
      end;
    end;
  end;
  CheckOut;
end;

procedure TActiveAlarmMems.SetOff(aTegID: integer);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if (items[i].TegID = aTegID) and not items[i].isOff then
    begin
      items[i].isOff := True;
      inherited LastNumber := LastNumber + 1;
    end;
  CheckOut;
end;



{ TAnalogLocBaseMems }


function TAnalogLocBaseMems.AddItem(aTegID: integer): integer;
var

  i: integer;
begin
  for i := 0 to Count - 1 do
  begin
    if Items[i].TagId = aTegId then
    begin
      self.addIndex(aTegID, i);
      exit;
    end;
  end;
  self.addIndex(aTegID, Count);
  inherited Count := Count + 1;
  inherited LastNumber := LastNumber + 1;
  Items[Count - 1].Count := 0;
  Items[Count - 1].TagID := aTegID;
  Items[Count - 1].last := -1;
  for I := 0 to 3591 do
  begin
    Items[Count - 1].point[i].Value := 0;
    Items[Count - 1].point[i].tim := 0;
  end;
  Result := Count - 1;
end;




procedure TAnalogLocBaseMems.setvalue(ltime: TDateTime; aTagId: integer;
  Value: single; valid: integer);
var
  i, j, k, ltime_plus: integer;
  delt: single;
begin
  i := self.getNumById(aTagID);
  if i > -1 then
  begin
    if Items[i].Count < 3591 then
      Inc(Items[i].Count);
    if Items[i].last >= 3590 then
      Items[i].last := 0
    else
      Inc(Items[i].last);
    if (valid > VALID_LEVEL) then
      Items[i].point[Items[i].last].Value := Value
    else
      Items[i].point[Items[i].last].Value := NILL_ANALOG;
    Items[i].point[Items[i].last].tim := ltime;
    exit;
  end;
end;


function TAnalogLocBaseMems.getQuery(tim: TDateTime; minut: integer;
  aTagid: integer; var val: tTDPointData): tdatetime;
var
  i, j, cnt, l, n: integer;
  fl, lastvalid, flfind: boolean;
  starttime, stoptime: TdateTime;
  pointcount, timecount, reccount: integer;
  {  //point_, time_: array of TDPointData ; }
  dataavalable: boolean;
begin
  Result := 0;
  val.npoint := 0;
  val.ntime := 0;
  Setlength(val.point, 0);
  Setlength(val.time, 1);
  fl := False;
  starttime := incminute(tim, -minut);
  stoptime := tim;
  val.time[0][1] := incminute(tim, -minut);
  val.time[0][2] := tim;
  val.ntime := 1;
  lastvalid := False;
  for i := 0 to Count - 1 do
    if Items[i].TagId = aTagId then
    begin
      Result := 1;
      n := 0;
      l := Items[i].last + 2;
      j := Items[i].last + 1;
      if (l) >= Items[i].Count then
        l := 0;
      if (j) >= Items[i].Count then
        j := 0;
      setlength(val.point, Items[i].Count + 4);
      setlength(val.time, round((Items[i].Count + 4) / 2));
      cnt := Items[i].Count;
      pointcount := 0;
      timecount := 0;
      if (cnt = 0) then
      begin
        val.time[timecount][1] := incminute(tim, -minut);
        val.time[timecount][2] := tim;
        Inc(timecount);
      end
      else
        while (cnt > n) do
        begin
          if (Items[i].point[l].tim >= incminute(tim, -minut)) then
          begin
            if (not FL) and (not lastvalid) then
            begin
              val.time[timecount][1] := incminute(tim, -minut);
              val.time[timecount][2] := Items[i].point[l].tim;
              Inc(timecount);
            end;

            if not fl then
            begin
              if not (Items[i].point[j].Value = NILL_ANALOG) then
              begin
                val.point[0][1] := Items[i].point[j].Value;
                val.point[0][2] := Items[i].point[j].tim;

                if (val.point[0][2] < starttime) then
                begin
                  val.point[0][2] := starttime;
                end
                else
                begin
                  if (val.point[0][2] > starttime) then
                  begin
                    val.time[timecount][1] := incminute(tim, -2 * minut);
                    val.time[timecount][2] := val.point[0][2];
                    Inc(timecount);
                    val.point[1][2] := val.point[0][2];
                    val.point[1][1] := val.point[0][1];
                    val.point[0][2] := starttime;
                    Inc(pointcount);
                  end;
                end;



                Inc(pointcount);
                dataavalable := True;
              end
              else
              begin
                val.time[0][1] := starttime;
                dataavalable := False;
              end;
              fl := True;
            end;

            begin
              if not (Items[i].point[j].Value = NILL_ANALOG) then
              begin
                val.point[pointcount][1] := Items[i].point[j].Value;
                val.point[pointcount][2] := Items[i].point[j].tim;
                if not dataavalable then
                begin
                  val.time[timecount][2] := val.point[pointcount][2];
                  Inc(timecount);
                end;
                Inc(pointcount);
                dataavalable := True;
              end
              else
              begin
                if dataavalable then
                begin
                  val.time[timecount][1] := Items[i].point[j].tim;
                  if (pointcount > 0) then
                  begin
                    val.point[pointcount][1] := val.point[pointcount - 1][1];
                    val.point[pointcount][2] := val.time[timecount][1];
                    Inc(pointcount);
                  end;
                end;
                dataavalable := False;
              end;
            end;
          end
          else
          begin
            if not fl then
              lastvalid := (Items[i].point[j].Value <> NILL_ANALOG);
          end;
          val.npoint := pointcount;
          val.ntime := timecount;

          Inc(l);
          Inc(j);
          Inc(n);
          if (l) >= Items[i].Count then
            l := 0;
          if (j) >= Items[i].Count then
            j := 0;
        end;

      exit;
    end;
end;

constructor TAnalogLocBaseMems.Create(rtItemsPtr: pointer; MemName: string);
var
  I: integer;
begin
  inherited CreateW(MemName, 1000, 60000000);
  rtItemsPointer := rtItemsPtr;
  indexListI := TStringList.Create;
  indexListI.Sorted := True;
  indexListI.Clear;
end;

destructor TAnalogLocBaseMems.Destroy;
begin
  inherited;
  indexListI.Free;
end;

function TAnalogLocBaseMems.GetItem(num: integer): PTAnalogLocBaseStruct;
begin
  if (num >= Count) or (num < 0) then
    raise Exception.Create('TAnalogLocBaseMems индекс за границей! ' + IntToStr(num));
  Result := @(PTAnalogLocBase(Data)^.Items[num]);
end;

function TAnalogLocBaseMems.findById(id: integer): PTAnalogLocBaseStruct;
var
  I: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if items[i].TagId = id then
    begin
      Result := @(PTAnalogLocBase(Data)^.Items[i]);
      exit;
    end;
end;

procedure TAnalogLocBaseMems.addIndex(idX, num: integer);
var
  i: integer;
  ipo: pInteger;
  stry: string;
begin
  if num < 0 then
    exit;
  if idx < 0 then
    exit;
  i := indexListI.IndexOf(IntToStr(idX));
  if i > 0 then
    exit;
  new(ipo);
  ipo^ := num;
  indexListI.AddObject(trim(IntToStr(idX)), TObject(ipo));
end;



function TAnalogLocBaseMems.GetNumbyId(idx: integer): integer;
var
  j: integer;
begin
  Result := -1;
  j := indexListI.IndexOf(trim(IntToStr(idX)));
  if j > -1 then
    if indexListI.Objects[j] <> nil then
      Result := pinteger(indexListI.Objects[j])^;
end;



{ TAnalogLocBaseMems }

class procedure TOperatorMems.createfileO(fileName: string);
var
  i: integer;
  fStr: TFileStream;
begin

  for i := 0 to 1000 do
  begin
    ostr.Items[i].id := -1;
    ostr.Items[i].idgroup := -1;
    ostr.Items[i].accessLevel := 9999;
    ostr.Header.Count := 0;
    ostr.Header.maxcount := 999;
  end;
  fStr := TFileStream.Create(fileName + 'operators.mem', fmCreate);
  try
    fStr.Write(ostr, SizeOf(ostr))
  finally
    fStr.Free;
  end;
end;

constructor TOperatorMems.Create(fileDIR: string);

var
  WSAData: TWSAData;
  i: integer;
  fileName: string;
  fStr: TFileStream;
  isBaseReload: boolean;
  newoper: PTOperators;
begin

  usCur := -1;
  fsize := 100000;
  fFileDir := fileDir;
  fileName := fileDIR + 'operators.mem';

  if not fileExists(fileDIR + 'operators.mem') then
  begin
    createfileO(fFileDir);
  end;
  try
    inherited Create(fileDIR + 'operators.mem', 'immi_operators');
    fPHeader := Data;
  except
  end;
  IndexStringList := TStringList.Create;
  IndexStringList.Sorted := True;

  for i := 0 to Count - 1 do
    if Items[i].ID <> -1 then
      AddIndex(Items[i].ID);
  //fPHeader.maxCount:=999
end;


function TOperatorMems.findNullId: integer;
var
  i, j: integer;
  fl: boolean;
begin
  i := 0;
  fl := True;
  while fl do
  begin
    fl := False;
    for j := 0 to Count - 1 do
      if items[j].id = i then
      begin
        i := i + 1;
        fl := True;
      end;
  end;
  Result := i;
end;


function TOperatorMems.GetName(idn: longint): string;
var
  i: integer;
begin
  Result := 'Незарегистрирован';
  if idn < 0 then
    exit;
  Result := items[idn].Name;
end;

function TOperatorMems.GetNamebyid(idn: longint): string;
var
  i: integer;
begin
  Result := 'Незарегистрирован';
  for i := 0 to Count - 1 do
    if idn = items[i].id then
      Result := items[i].Name;
end;



procedure TOperatorMems.AddIndex(ID: integer);
var
  j: ^integer;
begin
  new(j);
  j^ := ID;
  IndexStringList.Objects[IndexStringList.Add(UpperCase(GetNamebyid(id)))] := TObject(j);
end;

procedure TOperatorMems.RemoveIndex(ID: integer);
begin
  IndexStringList.Delete(IndexStringList.indexOf(GetNamebyid(ID)));
end;

function TOperatorMems.GetItem(number: integer): PTOperatorstruct;
begin
  Result := @TOperatorsStruct(Data^).Items[number];
end;

function TOperatorMems.GetSimpleID(ItemName: string): integer;
var
  i: integer;
  str: string;
  j: integer;
begin
  Result := -1;
  if itemName = '' then
    exit;
  J := IndexStringList.IndexOf(UPPERCASE(ItemName));
  if j <> -1 then
    Result := integer(pint(IndexStringList.Objects[j])^);

end;

function TOperatorMems.GetID(ItemName: string): integer;
begin
  Result := GetSimpleID(ItemName);
end;


function TOperatorMems.GetCount: integer;
begin
  Result := fPHeader^.Count;
end;

procedure TOperatorMems.SetCount(const Value: integer);
var
  fStr: TFileStream;
begin
  fPHeader^.Count := Value;
end;



procedure TOperatorMems.FreeItem(Num: integer);
begin
  if GetSimpleID(GetName(Num)) <> -1 then
    RemoveIndex(Num);
  Items[Num].ID := -1;
end;


procedure TOperatorMems.writeBaseToFile;
var
  fStr: TFileStream;
begin
  // ClearDubleErr;
  // ShowMessage('Запись всей базы на диск');
  fStr := TFileStream.Create(ffileDIR + 'operators.mem', fmCreate);
  try
    fStr.Write(Data^, SizeOf(Toperatorsstruct))
  finally
    fStr.Free;
  end;

end;


procedure TOperatorMems.SetName(idn: integer; Value: string);
var
  j, i: integer;
begin
  begin
    j := self.GetSimpleID(Value);
    if (j > -1) then
    begin
      exit;
    end
    else
    begin
      for i := 0 to Count - 1 do
        if idn = items[i].id then
        begin
          items[i].Name := Value;
          exit;
        end;
    end;
  end;
end;

procedure TOperatorMems.Linerize;
var
  i, j: integer;
begin
  i := 0;
  while i < Count do
  begin
    if items[i].id < 0 then
    begin
      j := i;
      while j < Count - 1 do
      begin
        items[j].id := items[j + 1].id;
        items[j].Name := items[j + 1].Name;
        //items[j].host:=items[j+1].host;
        items[j].idgroup := items[j + 1].idgroup;
        items[j].accessLevel := items[j + 1].accessLevel;
        items[j].password := items[j + 1].password;
        items[j].UnUsed1 := items[j + 1].UnUsed1;
        items[j].UnUsed2 := items[j + 1].UnUsed2;
        Inc(j);
      end;
      Count := Count - 1;
    end
    else
      Inc(i);
  end;
  writeBaseToFile;
end;

procedure TOperatorMems.AddUser;
var
  i, j: integer;
begin
  i := 1;
  while self.GetSimpleID('NewUser' + IntToStr(i)) > -1 do
    Inc(i);
  Count := Count + 1;
  items[Count - 1].id := findNullId;
  self.SetName(items[Count - 1].id, 'NewUser' + IntToStr(i));
  AddIndex(Items[Count - 1].ID);
  writeBaseToFile;
end;


procedure TOperatorMems.RemoveUser(val: integer);
var
  i, j: integer;
begin

  begin
    for i := 0 to Count - 1 do
      if items[i].id = val then
      begin
        removeindex(val);
        items[i].id := -1;
        Linerize;
        writeBaseToFile;
        exit;
      end;
  end;
end;

function TOperatorMems.RenameUser(idN: integer; newname: string): boolean;
var
  i, j: integer;
begin
  Result := False;
  if self.GetSimpleID(newname) > -1 then
    exit;

  begin
    for i := 0 to Count - 1 do
      if items[i].id = idN then
      begin
        removeindex(idn);
        items[i].Name := newname;
        addindex(idn);
        Result := True;
        writeBaseToFile;
        exit;
      end;
  end;
end;


function TOperatorMems.setAUser(idN: integer; al: integer): boolean;
var
  i, j: integer;
begin
  Result := False;

  begin
    for i := 0 to Count - 1 do
      if items[i].id = idN then
      begin
        items[i].accessLevel := al;
        addindex(idn);
        Result := True;
        writeBaseToFile;
        exit;
      end;
  end;
end;



function TOperatorMems.changepassUser(idN: integer;
  oldpassword, newpassword: string): boolean;
var
  i, j: integer;
begin
  Result := False;
  if (idn > -1) and (idn < 1001) then
  begin
    for i := 0 to Count - 1 do
      if items[i].id = idN then
      begin
        if items[i].password = oldpassword then
        begin
          items[i].password := newpassword;
          Result := True;
          writeBaseToFile;
          exit;
        end;
      end;
  end;
end;

function TOperatorMems.RegistUser(idN: integer; password: string): boolean;
var
  i, j: integer;
begin
  Result := False;
  if idn < 0 then
  begin
    setaccessL(StartAcses);
    AccessLevel^ := StartAcses;
    OperatorName^ := 'Незарегистрирован';
    rtitems.oper.usCur := -1;
    rtitems.setOperator('Незарегистрирован');
    SendMessageBroadcast(WM_IMMIUSERCHANGED, AccessLevel^, 0);
    exit;
  end;
  if (idn > -1) and (idn < 1001) then
  begin
    for i := 0 to Count - 1 do
      if items[i].id = idN then
      begin
        if trim(uppercase(items[i].password)) = trim(uppercase(password)) then
        begin
          try
            Result := True;
            usCur := items[i].id;
            AccessLevel^ := items[i].accessLevel;
            CurrantKey^ := password;
            setaccessL(items[i].accessLevel);
            OperatorName^ := items[i].Name;
            rtitems.setOperator(items[i].Name);
            SendMessageBroadcast(WM_IMMIUSERCHANGED, AccessLevel^, 0);
          except
          end;
          exit;
        end;
      end;
  end;
end;

destructor TOperatorMems.Destroy;

var
  i: integer;
begin
  for i := 0 to IndexStringList.Count - 1 do
  begin
    dispose(Pint(IndexStringList.Objects[i]));
  end;
  IndexStringList.Free;
  inherited;
end;

procedure TOperatorMems.setRegist(val: boolean);
begin
  if val then
    self.fPHeader.maxCount := 999
  else
    self.fPHeader.maxCount := 0;
  writeBaseToFile;
end;

function TOperatorMems.getRegist: boolean;
begin
  Result := (self.fPHeader.maxCount > 0);
end;

//******************* DebugMems **************************//
constructor TDebugMems.Create(MemName: string; aMaxCount: integer);
begin
  inherited CreateW(MemName, aMaxCount, sizeof(TDebugStruct) *
    (aMaxCount + 100) + sizeof(THeaderStruct));
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).LastNumber := 0;
  end;
  THeaderStruct(Data^).MaxCount := aMaxCount;
end;

function TDebugMems.ConvertNumber(number: integer): integer;
  //переводим № аларма по порядку в номер строки
var
  firstLine: integer;
begin
  firstLine := ifthen(Count = maxCount, curLine, 0);
  Result := (firstNumber + number) mod (MaxCount - 1);
end;

function TDebugMems.GetItem(num: longint): PTDebugStruct;
begin
  if (num >= Count) or (num < 0) then
    raise Exception.Create('TAlarmsMem индекс за границей! ' + IntToStr(num));
  Result := @(PTDebugs(Data)^.Items[ConvertNumber(num)]);
end;

function TDebugMems.GetItem_(num: longint): PTDebugStruct;
var
  j: integer;
begin
  // if (num >= count) or (num < 0) then raise Exception.Create('TAlarmsMem индекс за границей! ' + inttostr(num));
  if (curline - num - 1) > -1 then
    j := curline - num - 1
  else
    j := Count - (num - curline - 1);
  Result := @(PTDebugs(Data)^.Items[j]);
end;

function TDebugMems.AddItem(atime: TDateTime; mess: string; app: string;
  lev: byte): integer;
var
  i: integer;
begin
  try
    inherited LastNumber := LastNumber + 1;
    if Count < maxCount then
      inherited Count := Count + 1;
    Items[curLine].number := lastNumber - 1;
    Items[curLine].Time := aTime;
    if length(mess) > 248 then
      mess := leftstr(mess, 249);
    Items[curLine].debugmessage := mess;
    if length(app) > 48 then
      app := leftstr(app, 49);
    Items[curLine].application := app;
    Items[curLine].level := lev;
    Result := curLine;
    inherited CurLine := convertNumber(CurLine + 1);
  except
    Result := curLine;
  end;
end;



destructor TDebugMems.Destroy;
begin
  inherited;
end;




initialization
  rtItems := nil;
end.
