unit MemStructsU;

interface
uses Windows, sysUtils, classes, constDef, Dialogs, controls, GlobalValue,DateUtils,
    forms, GroupsU, MATH, mmsystem, winSock, StrUtils;



const
   MAIN_MAP_NAME = 'Global\nnnsys_analogmem_base';
   STRING_MAP_NAME = 'Global\nnnsys_string_base';
   COMMAND_MAP_NAME = 'Global\nnnsys_command_base';
   ALARMS_MAP_NAME  = 'Global\nnnsys_alarms_base';
   ALARMLOCALS_MAP_NAME  = 'Global\nnnsys_alarmlocal_base';
   DEBUGS_MAP_NAME  = 'Global\nnnsys_debug_base';
   ANALOGLOCBASE_MAP_NAME  = 'Global\nnnsys_analoglocbase_base';
   VALUECHANGE_MAP_NAME  = 'Global\nnnsys_valuechange_base';
   REGISTRATION_MAP_NAME  = 'Global\nnnsys_registration_base';




type pint = ^Pinteger;
     IntClosure = array [0..1] of integer;
     pintClosure = ^IntClosure;
type
TOschTeg = array of integer;
TOschTegGrope = record
num : TOschTeg;
n: integer;
end;
type
TAlarmCase = (alarmMore, alarmLess, alarmEqual);
TMsgType = (msNew, msKvit, msOut, msOn, msOff, msCmd);
TMsgState = set of TMsgType;

TAddedItemType = (acNewCommand, acQueuedCommand);

THeaderStruct = record
  count: LongInt;
  maxCount: LongInt;
  firstNumber: LongInt;
  LastNumber: LongInt;
  CurLine: LongInt;
  UnUsed1, UnUsed2: DWord;
end;


TEventTypes = (IMMIAll, IMMIChanged, IMMILog, IMMIEvent, IMMIAlarm, IMMIAlarmLocal, IMMICommand,
                IMMINewRef, IMMIRemRef, IMMIValid);
TEventTypesSet = set of TEventTypes;

TRegStruct = record
  number: integer;
  Name: String[50];
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
   NamePos: LongInt;
   GroupNum: integer; //номер группы опроса
   ItemPos: Longint;
   DeviceNamePos: longint;
   CommentPos: Longint;
   Logged: boolean;
   LogPrevVal: real;
   LogCode: longInt;
   logTime:integer;
   logDB: real;
   MinRaw, MaxRaw, MinEu, maxEu: single;
   OnMsged: boolean;
   OnMsgPos: longInt;
   offMsged: boolean;
   OffMsgPos: longInt;
   Alarmed: boolean;
   AlarmedLocal: boolean;
   AlarmMsgPos: longInt;
   AlarmLevel: integer;
   alarmCase: tAlarmCase;
   AlarmConst: single;
   isAlarmOn: boolean;
   isAlarmKvit: boolean;
   TimeStamp: real;
   EUPos: longInt;
   AlarmGroup: integer;
   PreTime: integer;
   isAlarmOnServ: boolean;
end;

PTAnalogMem = ^TAnalogMem;

TCalcMem = record
   ID: integer;
   Name: String[50];
   ValReal: real;
   ValidLevel: integer;
   refCount: integer;
   CommentPos: Longint;
   OnMsgPos, OffMsgPos: longInt;
end;
PTCalcMem = ^TCalcMem;

TAnalogsStruct = record
  Items: array [0..1000000] of TAnalogMem;
end;

//*********************** TCommandStruct *****************************//
TCommandStruct = record
  number: longInt;
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
  number: longInt;
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
  number: longInt;
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
  id: longInt;
  name: string[255];
  idgroup: longInt;
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
  number: longInt;
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
 value: single;
 tim: TDatetime;
 end;

TAnalogLocBaseStruct = record
  count: longInt;
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
  count: longInt;
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
  function OpenMappedFile(DeleteOnClose: boolean): Boolean;
  function OpenMappedMemory: Boolean;
protected
Data: pointer;
class function MappedMemoryisLock(nm: string): Boolean;
public
  fsize: cardinal;
  constructor Create (fileNm, mapNm: string);virtual;
  destructor Destroy; override;
end;

{***************************** TMappedFilePsevdo ************************************}
//выделяет файл в памяти и копирует туда содержание файла
//при этом файл не блокируется, и можо его дополнять без проблем
TMappedFilePsevdo = class(mappedFile)
protected
public
  constructor Create (fileNm, mapNm: string; oldOverride: boolean = false);
end;



{*****************************THeaderedMem************************************}
THeaderedMem = class(mappedFile)
protected
  function GetCount: LongInt;
  procedure SetCount(iCount: LongInt);
  function GetMaxCount: LongInt;
  procedure SetMaxCount(iCount: LongInt);
  function GetLastNumber: LongInt;
  procedure SetLastNumber(iLastNumber: LongInt);
  function GetFirstNumber: LongInt;
  procedure SetFirstNumber(iFirstNumber: LongInt);
  function GetCurLine: LongInt;
  procedure SetCurLine(iCurLine: LongInt);
  property Count: LongInt read GetCount write SetCount;
  property MaxCount: LongInt read GetMaxCount write SetMaxCount;
  property LastNumber: LongInt read GetLastNumber write SetLastNumber;
  property FirstNumber: LongInt read GetFirstNumber write SetFirstNumber;
  property CurLine: LongInt read GetCurLine write SetCurLine;
public
  constructor Create (mapNm: string); virtual;
  constructor CreateW (mapNm: string; maxcount: word; filesize: Cardinal); virtual;
end;


TRegs = class(THeaderedMem)
private
  fRefMsgNum: longInt; //Номер сообщения о увеличении ссылок
  rtItemsPointer: Pointer;
  function GetItem (number: longInt):TRegStruct;
public
  property Items[i: longInt]: TRegStruct read GetItem;
  property MaxCount: LongInt read GetMaxCount;
  property LastNumber: LongInt read GetLastNumber;
  property Count: LongInt read GetCount;
  property FirstNumber: LongInt read GetFirstNumber;
  property CurLine: LongInt read GetCurLine;
  //number- number of line in events, ID-ID of parameters
  constructor Create(rtItemsPtr: pointer; mapNm: string);
  procedure RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet );
  procedure UnRegHandle(Handle: THandle);
  procedure NotifyValid(ID: longInt);
  procedure NotifyLog(LineNumber: longInt; ID: longInt);
  procedure NotifyLogInside(LineNumber: longInt; ID: longInt);
  procedure NotifyEvents(LineNumber: longInt; ID: longInt);
  procedure NotifyChange(LineNumber: longInt; ID: longInt);
  procedure NotifyAlarm(LineNumber: longInt; ID: longInt);
  procedure NotifyNewAlarm;
  procedure NotifyAlarmLocal(LineNumber: longInt; ID: longInt);
  procedure NotifyCommands(LineNumber: longInt; ID: longInt);
  //Количество ссылок стало не ноль
  procedure NotifyNewRef(ID: longInt);
  //Количество ссылок стало ноль
  procedure NotifyRemRef(ID: longInt);
end;

TCommandMems = class(THeaderedMem)
private
  function GetItem (number: longInt):TCommandStruct;
  function GetItemN (number: longInt):PTCommandStruct;
  procedure SetExecuted(num: longInt);
  procedure ClearExecuted(num: longInt);
//  procedure IncItemCount;
//  procedure IncLastNumber;
public
  LastCommandLine: integer;
  constructor Create (fileDIR: string; MemName: string);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  property MaxCount: LongInt read GetMaxCount;
  property LastNumber: LongInt read GetLastNumber;
  property FirstNumber: LongInt read GetFirstNumber;
  property CurLine: LongInt read GetCurLine;
  property Items[i: longInt]: TCommandStruct read GetItem; default;
  property ItemsN[i: longInt]: PTCommandStruct read GetItemN; //Нормальный доступ, скрывающий структуру (i := 0 to -1)
  function AddItem(number: integer; PrevVal, val: real; queue: boolean; compName: string = ''; username: string=''): TAddedItemType;
  procedure Compress; //удаляет отработанные команды
end;


TAlarmMems = class(THeaderedMem)
private
  //переводим № аларма по порядку в номер строки
  function ConvertNumber (number: integer) : integer;
  function GetItem (num: longInt):PTAlarmStruct;
public
  property CurLine;
  property Items[i: longInt]: PTAlarmStruct read GetItem; default;
  //constructor Create (MemName: string); override;
  constructor Create (MemName: string; aMaxCount: integer);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType): integer; overload;
  function AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType; comp: string; oper: string ): integer; overload;
end;

TActiveAlarmMems = class(THeaderedMem)
private
  rtItemsPointer: pointer;
  function GetItem (num: longInt):PTActiveAlarmStruct;
  procedure CheckOut;
public
  property LastNumber;
  property Items[i: longInt]: PTActiveAlarmStruct read GetItem; default;
  constructor Create (rtItemsPtr:pointer; MemName: string);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function AddItem(atime: TDateTime; aTegID: integer): integer;
  procedure KvitAll;
  procedure KvitAlarmGroup(grnum: integer);
  procedure KvitTagGroup(grnum: integer);
  procedure SetOff(aTegID: integer);
end;

TDebugMems = class(THeaderedMem)
private
  //переводим № аларма по порядку в номер строки
  function ConvertNumber (number: integer) : integer;
  function GetItem (num: longInt):PTDebugStruct;
  function GetItem_ (num: longInt):PTDebugStruct;
public
  property CurLine;
  property Items[i: longInt]: PTDebugStruct read GetItem; default;
  property Items_[i: longInt]: PTDebugStruct read GetItem_;
  //constructor Create (MemName: string); override;
  constructor Create (MemName: string; aMaxCount: integer);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function AddItem(atime: TDateTime; mess: string; app: string; lev: byte): integer;
end;


TAnalogLocBaseMems = class(THeaderedMem)
private
  rtItemsPointer: pointer;
  indexListI: TStringList;
  function GetItem (num: longInt):PTAnalogLocBaseStruct;
  procedure addIndex(idX, num: integer);
  function getNumbyId(idx: integer): integer;
  function AddItem(aTegID: integer): integer;
  procedure setvalue(ltime: TDateTime; aTagId: integer; value: single; valid: integer);
  function getQuery(tim: TDateTime; minut: integer; aTagid: integer; var val: tTDPointData): tdatetime;
public
  property LastNumber;
  property Items[i: longInt]: PTAnalogLocBaseStruct read GetItem; default;
  constructor Create (rtItemsPtr:pointer; MemName: string);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function findById(id: Integer): PTAnalogLocBaseStruct;

 // procedure setvalueNo(ltime: integer; aTagId: integer);
end;

///TAnalogAbsentTimeMems = class(THeaderedMem)
{private
  rtItemsPointer: pointer;
  indexListI: TStringList;
  function GetItem (num: longInt):PTAbsenttimeInfoStruct;
  procedure addIndex(idX, num: integer);
  function getNumbyId(idx: integer): integer;
  function AddItem(groupId: integer): integer;
  procedure setvalue(ltime: TDateTime; GrouId: integer; state: boolean);
  function getQuery(tim: TDateTime; minut: integer; Groupid: integer; var val: tTDPoint): boolean;
public
  property LastNumber;
  property Items[i: longInt]: PTAbsenttimeInfoStruct read GetItem; default;
  constructor Create (rtItemsPtr:pointer; MemName: string);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function findById(id: Integer): PTAbsenttimeInfoStruct;

end;      }

{TCalcMems = class(THeaderedMem)
private
       function GetItem (number: integer):PTCalcMem;
       procedure SetItem(number: Integer; item: PTCalcMem);

public
  constructor Create (fileDIR: string);

  property Count: LongInt read GetCount;
  property MaxCount: LongInt read GetMaxCount;
  property LastNumber: LongInt read GetLastNumber;
  property FirstNumber: LongInt read GetFirstNumber;
  property CurLine: LongInt read GetCurLine;
  property Items[i: integer]: PTCalcMem read GetItem write SetItem; default;

  function GetID(ItemName: String): integer;
  procedure IncCounter(number: integer);
  procedure DecCounter (number: integer);
  function isValid(number: integer): boolean;
  procedure AddItem (name: string);
end;   }


TOperatorMems      = class (TMappedFilePsevdo)
private
  fileStrings: TMappedFilePsevdo;
  fFileDir: string;
  IndexStringList: TStringList;
  fPHeader: ^THeaderStruct;
  procedure AddIndex(ID: integer);
  procedure RemoveIndex(ID: integer);
  function GetItem (number: integer):PTOperatorStruct;
  function GetCount: integer;
  procedure SetCount(const Value: integer);
  class procedure createfileO(fileName: string);
  function findNullId:integer;
  public
  usCur: integer;
  property Items[i: integer]: PTOperatorStruct read GetItem; default;
  property Count: integer read GetCount write SetCount;
  constructor Create (fileDIR: string);
  destructor Destroy; override;
  procedure writeBaseToFile;
   function GetNamebyid(idn: longInt): string;
  function GetName(idn: longInt): string;
//  function GetHost(i: longInt): string;
  function GetSimpleID(ItemName: String): integer;
  function GetID(ItemName: String): integer;
  procedure SetName(idn: longInt; value: string);
  procedure FreeItem(Num: longInt);
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
  RecordCount: longInt;
  DataSize: longint;
end;

PTAnalogMemHdr = ^ TAnalogMemHdr;

TAnalogMems      = class (TMappedFilePsevdo)
private
  fileStrings: TMappedFilePsevdo;
  fFileDir: string;
  IndexStringList: TStringList;
  fPHeader: PTAnalogMemHdr;
  fTegGroups, fAlarmGroups: TGroups;
  fAppl: string;
  operator_: string;
  fdebugL: integer;
  hostName : {array [0..$FF] of Char}string;
  //absensAnalog: TAnalogAbsentTimeMems;
  analogLocBase: TAnalogLocBaseMems;
  procedure SetValid(number: integer; valid: integer);
  procedure SetValue(number: integer; val: real);
  procedure AddIndex(ID: integer);
  procedure RemoveIndex(ID: integer);
  function GetItem (number: integer):PTAnalogMem;
  procedure SetStringValue(var pos: longInt; value: string);

  function GetStringValue(pos: longInt): string;
    function GetCount: integer;
  Function GetItemOffset(ItemNum: longint): longInt;
    procedure SetCount(const Value: integer);
  //преобразует файл предыдущей версии в текущую
  //размер заголовка и записи не должен уменьшаться
  procedure ConvertBase;
  function  GetModName: string;
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


  constructor Create (fileDIR: string);
  constructor CreateW (fileDIR: string);
  destructor Destroy; override;

  class procedure WriteZero(fileDIR: string; clear_: boolean = true);
//  property pethMem: string read FFileDir;
  procedure ClearDubleErr;
  procedure addLocalBaseTag(idA: integer);
  procedure addLocalBaseGroup(idGroup: integer);
  procedure setLocalBaseTagval(ltime: TDateTime; aTagId: integer; value: single;valid: integer);
  procedure setLocalBaseGroupval(ltime: TDateTime; GrouId: integer; state: boolean);
  function QueryLocalBaseTag(tim: TDateTime; minut: integer; aTagid: integer; var val: tTDPointData): Tdatetime;
  procedure writeBaseToFile(ClearStrings: boolean);
  procedure getOschTeg(num: integer;var val: TOschTegGrope);
  function GetName(i: longInt): string;
  function GetComment(i: longInt): string;
  function GetOnMsg(i: longInt): string;
  function GetOffMsg(i: longInt): string;
  function GetDDEItem(i: longInt): string;
  function GetAlarmMsg(i: longInt): string;
  function GetEU(i: longInt): string;
  function GetAlarmCase(i: longInt): string;
  function GetSimpleID(ItemName: String): integer;
  function GetID(ItemName: String): integer;
  function TagDubleErr(val: integer): integer;
  function TagDubleErrIs: boolean;
  procedure SetName(i: longInt; value: string);
  procedure SetComment(i: longInt; value: string);
  procedure SetOnMsg(i: longInt; value: string);
  procedure SetOffMsg(i: longInt; value: string);
  procedure SetDDEItem(i: longInt; value: string);
  procedure SetAlarmMsg(i: longInt; value: string);
  procedure SetEU(i: longInt; value: string);
  procedure WriteToFile(curItem: longint);
  procedure WriteToFileAll();
  procedure FreeItem(Num: longInt);
  procedure  RebuildIndex();
  function isIdent(name: string): boolean;
  function isDiscret(number: integer): boolean;
  procedure IncCounter(number: integer);
  procedure DecCounter (number: integer);
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

  procedure AddCommand(number: integer; val: real; queue: boolean;CompName:string='';userName:string='');
  //пометить команду выполненной
  procedure SetCommandExecuted(ComNum: longInt);
  //очистить выполнение команды
  procedure ClearCommandExecuted(ComNum: longInt);
  //использовать эту функцию для регистрации окон, получающих сообщения
  procedure RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
  procedure UnRegHandle(Handle: THandle);
  procedure Log(mess: string; lev: byte=2);
  procedure LogWarning(mess: string);
  procedure LogError(mess: string);
  procedure LogFatalError(mess: string);
  procedure SetAppName(app: string);
end;



Var
  rtItems : TAnalogMems;
   ir: LongBool;
   irr: integer;
   ostr: TOperatorsStruct;
function Regrtitems(point: Pointer; point1: pointer; point2: pointer;pactive: pointer): pointer;
procedure SetAcsessAdress(p: pointer;pname: pointer;ppas: pointer);
function isSystemGroup(val: string): boolean;
procedure AlarmSound(value: boolean);
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



procedure AlarmSound(value: boolean);
begin
Playsound(nil,0,SND_PURGE);
if value then Playsound(Pchar('ir_inter'),0, SND_LOOP or SND_ASYNC or SND_ALIAS);
end;




function isSystemGroup(val: string): boolean;
   begin
     result:=false;
     if trim(uppercase(val))='$SYSVAR' then  result:=true;
     if trim(uppercase(val))='$SYSTEM' then  result:=true;
     if trim(uppercase(val))='$REPORT' then  result:=true;
     if trim(uppercase(val))='$SERVERCOUNT' then  result:=true;
  //   if trim(uppercase(val))='$ВЫЧИСЛЯЕМАЯ' then  result:=ntOServCount;
     if trim(uppercase(val))='$POINTER' then result:=true;
   //  if pos('$ССЫЛОЧНАЯ',trim(uppercase(val)))=1 then result:=ntOPoint;
   end;


//  инкримент отчетного периода v д.б!!!!! 0,-1,1


//uses GlobalVar, AlarmU;
{*********************************************************************}
{********************** Mapped File **********************************}
{*********************************************************************}

constructor MappedFile.Create (fileNm, mapNm : string);
var
    deleteOnClose: boolean;

begin
  new(securyty);
  new(secD);                                             //   SE_GROUP_DEFAULTED
  securyty^.lpSecurityDescriptor:=secD;
  securyty^.nLength:=sizeof(securyty);
  securyty^.bInheritHandle:=true;

  ir:=InitializeSecurityDescriptor(securyty^.lpSecurityDescriptor, SECURITY_DESCRIPTOR_REVISION);
  ir:=SetSecurityDescriptorDacl(securyty^.lpSecurityDescriptor,true,nil,false);
 // ir:=SetSecurityDescriptorSacl(securyty^.lpSecurityDescriptor,true,nil,false);
  //ir:=SetSecurityDescriptorGroup(securyty^.lpSecurityDescriptor,nil,true);
  // ir:=SetSecurityDescriptorOwner(securyty^.lpSecurityDescriptor,nil,false);
  deleteOnClose := false;
  mapName := mapNm;
  fileName := fileNm;
     if fileName <> '' then
     begin
       if not OpenMappedFile(DeleteOnClose) then
          raise Exception.Create ('Невозможно загрузить файл ' +
                                                      fileName +'в память');
     end
     else if not OpenMappedMemory then
          raise Exception.Create ('Невозможно отобразить память');
end;

destructor mappedfile.Destroy;
begin
    if not UnMapViewOfFile(Data) then
      raise Exception.Create('No unmapping '+ mapName);
    if not CloseHandle(hMapping) then
      raise Exception.Create('No closing' + mapName);
  inherited;
end;

function MappedFile.OpenMappedFile(DeleteOnClose: boolean): Boolean;
var
  HighSize: DWORD;

begin
  Result := False;

  if Length(FileName) = 0 then Exit;
  if DeleteOnClose then
    hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
             FILE_SHARE_READ or FILE_SHARE_WRITE, securyty, OPEN_ALWAYS,
             FILE_FLAG_RANDOM_ACCESS, 0)
  else
    hFile := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
             FILE_SHARE_READ or FILE_SHARE_WRITE, securyty, OPEN_EXISTING,
             FILE_FLAG_RANDOM_ACCESS, 0);

  if (hFile = 0) then Exit;

  FileSize := GetFileSize(hFile, @HighSize);

  hMapping := CreateFileMapping(hFile, securyty, PAGE_READWRITE,
                               0, 0, PChar(mapName));

  if (hMapping = 0) then begin
    CloseHandle(hFile);
    Exit;
  end;

  CloseHandle(hFile);

  Data := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS,
                                        0, 0, 0);

  if (Data <> nil) then Result := True;
end;


class function MappedFile.MappedMemoryisLock(nm: string): Boolean;
var
  securyty_: PSecurityAttributes;
  _hMapping: THandle;
  _secD: pSecurityDescriptor;
begin

  new(securyty_);
  new(_secD);                                             //   SE_GROUP_DEFAULTED
  securyty_^.lpSecurityDescriptor:=_secD;
  securyty_^.nLength:=sizeof(securyty_);
  securyty_^.bInheritHandle:=true;

  ir:=InitializeSecurityDescriptor(securyty_^.lpSecurityDescriptor, SECURITY_DESCRIPTOR_REVISION);
  ir:=SetSecurityDescriptorDacl(securyty_^.lpSecurityDescriptor,true,nil,false);
  Result := False;

  _hMapping := CreateFileMapping($FFFFFFFF,securyty_, PAGE_READWRITE	,
                              0, 10000000, PChar(nm));

  if GetLastError = ERROR_ALREADY_EXISTS then result := true
  else result := True;

  CloseHandle(_hMapping);

end;

function MappedFile.OpenMappedMemory: Boolean;
var
     i: integer;
begin
  Result := False;
  isNewFileOpened := true;

   //  secd^.Revision:=1;


  if fsize<10000000 then
  hMapping := CreateFileMapping($FFFFFFFF,securyty, PAGE_READWRITE	,
                              0, 10000000, PChar(mapName)) else

  hMapping := CreateFileMapping($FFFFFFFF,securyty, PAGE_READWRITE	,
                              0, fsize, PChar(mapName));

  if (hMapping = 0) then Exit;

  if GetLastError = ERROR_ALREADY_EXISTS then isNewFileOpened := False
  else isNewFileOpened := True;

  Data := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);

  if (Data <> nil) then Result := True;
end;

{*********************************************************************}
{********************** HeaderedMem **********************************}
{*********************************************************************}

constructor THeaderedMem.Create (mapNm: string);
begin
  inherited Create ('', mapNm);
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).MaxCount := 100;
    THeaderStruct(Data^).LastNumber := -1;
    THeaderStruct(Data^).FirstNumber := 0;
    THeaderStruct(Data^).CurLine := 0;
  end;
end;

constructor THeaderedMem.CreateW (mapNm: string; maxcount: word; filesize: Cardinal);
begin
  fsize:=filesize;
  inherited Create ('', mapNm);
  if isNewFileOpened then
  begin
    THeaderStruct(Data^).Count := 0;
    THeaderStruct(Data^).MaxCount := maxcount;
    THeaderStruct(Data^).LastNumber := -1;
    THeaderStruct(Data^).FirstNumber := 0;
    THeaderStruct(Data^).CurLine := 0;
  end;
end;

function THeaderedMem.GetCount: LongInt;
begin
  result := THeaderStruct(Data^).Count;
end;

procedure THeaderedMem.SetCount(iCount: LongInt);
begin
  THeaderStruct(Data^).Count := iCount;
end;

function THeaderedMem.GetMaxCount: LongInt;
begin
  result := THeaderStruct(Data^).MaxCount;
end;

procedure THeaderedMem.SetMaxCount(iCount: LongInt);
begin
  THeaderStruct(Data^).MaxCount := iCount;
end;

function THeaderedMem.GetLastNumber: LongInt;
begin
  result := THeaderStruct(Data^).LastNumber;
end;

procedure THeaderedMem.SetLastNumber(iLastNumber: LongInt);
begin
  THeaderStruct(Data^).LastNumber := iLastNumber;
end;

function THeaderedMem.GetFirstNumber: LongInt;
begin
  result := THeaderStruct(Data^).firstNumber;
end;

procedure THeaderedMem.SetFirstNumber(iFirstNumber: LongInt);
begin
  THeaderStruct(Data^).FirstNumber := iFirstNumber;
end;

function THeaderedMem.GetCurLine: LongInt;
begin
  result := THeaderStruct(Data^).CurLine;
end;

procedure THeaderedMem.SetCurLine(iCurLine: LongInt);
begin
  THeaderStruct(Data^).CurLine := iCurLine;
end;

{*********************************************************************}
{********************** TRegs **********************************}
{*********************************************************************}

function TRegs.GetItem (number: longInt):TRegStruct;
begin
  result := TRegsStruct(Data^).Items[number];
end;

procedure TRegs.NotifyEvents(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIEvent in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMIEvent, LineNumber, ID);
end;

procedure TRegs.NotifyChange(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIChanged in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMIChange, LineNumber, ID);
end;

procedure TRegs.NotifyValid(ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIValid in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMIValid, ID, ID);
end;

procedure TRegs.NotifyLog(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMILog in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMILog, LineNumber, ID);
end;

procedure TRegs.NotifyLogInside(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMILog in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMILogInside, LineNumber, ID);
end;

procedure TRegs.NotifyAlarm(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIAlarm in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMIAlarm, LineNumber, ID);
end;

procedure TRegs.NotifyNewAlarm;
var
  i: integer;
begin
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIAlarm in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMINewAlarm, 0, 0);
end;

procedure TRegs.NotifyAlarmLocal(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIAlarmLocal in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      sendMessage (Items[i].Handle, WM_IMMIAlarmLocal, LineNumber, ID);
end;

procedure TRegs.NotifyCommands(LineNumber: longInt; ID: longInt);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMICommand in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
      postMessage (Items[i].Handle, WM_IMMICommand, LineNumber, ID);
end;

procedure TRegs.NotifyNewRef(ID: Integer);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMINewRef in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
        postMessage (Items[i].Handle, WM_IMMINewRef, fRefMsgNum, ID);
   inc(frefMsgNum);
end;

procedure TRegs.NotifyRemRef(ID: Integer);
var
  i: integer;
begin
  if TAnalogMems(rtItemsPointer).Items[ID].ID = -1 then exit;
  for i := 0 to count-1 do
    if ((immiAll in Items[i].EventsSet) OR (IMMIRemRef in Items[i].EventsSet))
      AND (Items[i].Handle <> 0) then
        postMessage (Items[i].Handle, WM_IMMIRemRef, fRefMsgNum, ID);
  inc(frefMsgNum);
end;

constructor TRegs.Create;
begin
  inherited create(MapNm);
  fRefMsgNum := 0;
  rtItemsPointer := rtItemsPtr;
end;

procedure TRegs.RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
begin
  inherited count := count + 1;
  inherited lastNumber := lastNumber + 1;
  TRegsStruct(Data^).Items[count - 1].Number := lastNumber;
  TRegsStruct(Data^).Items[count - 1].Name := Name;
  TRegsStruct(Data^).Items[count - 1].Handle := Handle;
  TRegsStruct(Data^).Items[count - 1].EventsSet := Events;
end;

procedure TRegs.UnRegHandle(Handle: THandle);
var
  i: integer;
begin
  for i := 0 to count-1 do
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
    GetModuleFileName(
    hinstance,
    pchar(fName),
    nsize));
  Result := fName;
end;


class procedure TAnalogMems.WriteZero(fileDIR: string; clear_: boolean = true);
var fStr: TFileStream;
    head_: TAnalogMemHdr;
begin
   if FileExists( FileDir + 'command.mem') and (clear_) then
   DeleteFile(FileDir + 'command.mem');
   FileClose(FileCreate(  FileDir + 'command.mem'));
   if FileExists( FileDir + 'Strings.mem') and (clear_) then
   DeleteFile(FileDir + 'Strings.mem');
   FileClose(FileCreate(  FileDir + 'Strings.mem'));
   if FileExists( FileDir + 'Analog.mem') and (clear_) then
   DeleteFile(FileDir + 'Analog.mem');
   head_.Ver:=CurrentBaseVersion;
   head_.HeaderSize:=SizeOf(TAnalogMemHdr);
   head_.RecordSize:=SizeOf(TAnalogMem);
   head_.RecordCount:=0;
   head_.DataSize:= head_.HeaderSize + 0 * head_.RecordCount;
  // data^,SizeOf(fPHeader^) + Count * SizeOf(TAnalogMem)
   fStr := TFileStream.Create(fileDIR + 'Analog.mem', fmCreate);
   try

    fStr.Write(head_,SizeOf(TAnalogMemHdr) + 0 * SizeOf(TAnalogMem))
   finally
    fStr.Free;
  end;
  if FileExists( FileDir + 'groups.cfg') and (clear_) then
   DeleteFile(FileDir + 'groups.cfg');
   FileClose(FileCreate(  FileDir + 'groups.cfg'));

   if FileExists( FileDir + 'alarmgroups.cfg') and (clear_) then
   DeleteFile(FileDir + 'alarmgroups.cfg');
   FileClose(FileCreate(  FileDir + 'alarmgroups.cfg'));


   if FileExists( FileDir + 'TrendGroupsStruct.cfg') and (clear_) then
   DeleteFile(FileDir + 'TrendGroupsStruct.cfg');
   FileClose(FileCreate(  FileDir + 'TrendGroupsStruct.cfg'));

   if FileExists( FileDir + 'AlarmGroupsStruct.cfg') and (clear_) then
   DeleteFile(FileDir + 'AlarmGroupsStruct.cfg');
   FileClose(FileCreate(  FileDir + 'AlarmGroupsStruct.cfg'));

   FileClose(FileCreate(  FileDir + 'initial.ini'));

   FileClose(FileCreate(  FileDir + 'config.cfg'));
  
end;

constructor TAnalogMems.Create (fileDIR : string);
var
  WSAData : TWSAData;
  i: integer;
  fileName : string;
  fStr: TFileStream;
  isBaseReload: boolean;
  arhostnameName: array [0..$FF] of Char;
begin
  fdebugBase:=nil;
  operator_:='';
  fdebugL:=debug_Base;
  if trim(stationname)='' then
  try
    WSAStartup($0101, WSAData);
    GetHostName(arhostnameName, $FF);
    WSACleanup;
    hostname:=arhostnameName;
  finally
  end else hostname:=stationname;
  try
  fAppl:=GetModName;
  except
  fAppl:='';
  end;

  fFileDir := fileDir;
  fileName := fileDIR + 'analog.mem';
     if not fileExists (fileName) then
       raise Exception.Create ('File not found ' + fileName);
     inherited Create(fileDIR + 'analog.mem', MAIN_MAP_NAME);


   fPHeader := Data;
   //данные, которые раньше содержались в заголовке, не соответствуют размеру файла
   //значит грузим новую базу
    with fPHeader^ do
       if RecordCount * RecordSize + HeaderSize <> fileSize then isBaseReload := true else isBaseReload := false;
             {if MessageDlg('Размер базы в памяти и загружаемой не совпадает. Перезаписать?',mtWarning, [mbYes, mbNo], 0) = mrYes then
                isBaseReload := true else isBaseReload := false;}
    if isBaseReload then
    begin
      fStr := TFileStream.Create(fileName, fmOpenReadWrite);
      try
        fStr.Read(data^, fStr.Size);
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
       raise Exception.Create('База данных имеет более позднюю версию. Преобразоавние невозможно');
     if (FPHeader^.Ver < CurrentBaseVersion) then
         if MessageDlg('База данных имеет более раннюю версию. Преобразовать?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
           ConvertBase
         else raise Exception.Create('Конфликт версий.');

     fileStrings := TMappedFilePsevdo.Create(fileDIR + 'strings.mem', STRING_MAP_NAME);
     command := TCommandMems.Create(fileDIR, COMMAND_MAP_NAME);
     alarms := TAlarmMems.Create(ALARMS_MAP_NAME, 50000);
     activeAlarms := TActiveAlarmMems.Create(self,ALARMLOCALS_MAP_NAME);
     if ((fdebugL=DEBUGLEVEL_HIGH) or
         (fdebugL=DEBUGLEVEL_MIDLE) or (fdebugL=DEBUGLEVEL_LOW)) then
               fdebugBase:=TDebugMems.Create(DEBUGS_MAP_NAME, 40000);;
     analogLocBase := nil;
    // absensAnalog:=nil;
    // ValCh := TCommandMems.Create(fileDIR, VALUECHANGE_MAP_NAME);
  //   calc := TcalcMems.Create(fileDIR);
     Regs := TRegs.Create(Self, REGISTRATION_MAP_NAME);
     fTegGroups := TGroups.Create(PathMem + 'groups.cfg');
     fAlarmGroups := TGroups.Create(PathMem + 'AlarmGroups.cfg');
     oper:=TOperatorMems.Create(fileDIR);
     IndexStringList:=TStringList.Create;
     IndexStringList.Sorted:=true;

     RebuildIndex;

      kvitID := GetSimpleID(KvitTegName);
      if kvitID <> -1 then Items[KvitID].ValReal := 0;
 end;


constructor TAnalogMems.CreateW (fileDIR : string);
var
  WSAData : TWSAData;
  i: integer;
  fileName : string;
  fStr: TFileStream;
  isBaseReload: boolean;
  arhostnameName: array [0..$FF] of Char;
begin
  fdebugBase:=nil;
  fdebugL:=debug_Base;
  if trim(stationname)='' then
  try
    WSAStartup($0101, WSAData);
    GetHostName(arhostnameName, $FF);
    WSACleanup;
    hostname:=arhostnameName;
  finally
  end else hostname:=stationname;
  try
  fAppl:=GetModName;
  except
  fAppl:='';
  end;
  fFileDir := fileDir;
  fileName := fileDIR + 'analog.mem';
     if not fileExists (fileName) then
       raise Exception.Create ('File not found ' + fileName);
     inherited Create(fileDIR + 'analog.mem', MAIN_MAP_NAME);


   fPHeader := Data;
   //данные, которые раньше содержались в заголовке, не соответствуют размеру файла
   //значит грузим новую базу
    with fPHeader^ do
       if RecordCount * RecordSize + HeaderSize <> fileSize then isBaseReload := true else isBaseReload := false;
             {if MessageDlg('Размер базы в памяти и загружаемой не совпадает. Перезаписать?',mtWarning, [mbYes, mbNo], 0) = mrYes then
                isBaseReload := true else isBaseReload := false;}
    if isBaseReload then
    begin
      fStr := TFileStream.Create(fileName, fmOpenReadWrite);
      try
        fStr.Read(data^, fStr.Size);
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
       raise Exception.Create('База данных имеет более позднюю версию. Преобразоавние невозможно');
     if (FPHeader^.Ver < CurrentBaseVersion) then
         if MessageDlg('База данных имеет более раннюю версию. Преобразовать?',
           mtConfirmation, [mbYes, mbNo], 0) = mrYes then
           ConvertBase
         else raise Exception.Create('Конфликт версий.');

     fileStrings := TMappedFilePsevdo.Create(fileDIR + 'strings.mem', STRING_MAP_NAME);
     command := TCommandMems.Create(fileDIR, COMMAND_MAP_NAME);
     alarms := TAlarmMems.Create(ALARMS_MAP_NAME, 50000);
     activeAlarms := TActiveAlarmMems.Create(self,ALARMLOCALS_MAP_NAME);
      if ((fdebugL=DEBUGLEVEL_HIGH) or
         (fdebugL=DEBUGLEVEL_MIDLE) or ( fdebugL=DEBUGLEVEL_LOW)) then
               fdebugBase:=TDebugMems.Create(DEBUGS_MAP_NAME, 40000);;
     if (localbase)  then
     begin
     analogLocBase := TAnalogLocBaseMems.Create(self,ANALOGLOCBASE_MAP_NAME);

     end else
     begin
     analogLocBase :=nil;
  //   absensAnalog:=nil;
     end;
   //  ValCh := TCommandMems.Create(fileDIR, VALUECHANGE_MAP_NAME);
   //  calc := TcalcMems.Create(fileDIR);
     Regs := TRegs.Create(Self,REGISTRATION_MAP_NAME );
     fTegGroups := TGroups.Create(PathMem + 'groups.cfg');
     fAlarmGroups := TGroups.Create(PathMem + 'AlarmGroups.cfg');
     oper:=TOperatorMems.Create(fileDIR);
     IndexStringList:=TStringList.Create;
     IndexStringList.Sorted:=true;

     RebuildIndex;

      kvitID := GetSimpleID(KvitTegName);
      if kvitID <> -1 then Items[KvitID].ValReal := 0;
 end;

procedure TAnalogMems.RebuildIndex();
var i: integer;
begin
    IndexStringList.Clear;
    for i:=0 to Count-1 do
       if Items[i].ID <> -1 then
        AddIndex(Items[i].ID);
end;


function TAnalogMems.isIdent(name: string): boolean;
begin
  result := (GetSimpleID(Name) <> -1);
end;

function TAnalogMems.isDiscret(number: integer): boolean;
begin
  result := pos('.', GetDDEItem(number)) <> 0;
end;

function TAnalogMems.GetStringValue(pos: Integer): string;
begin
  result := '';
  if (pos <> -1) {and (pos <> 0)} then   //18.03.04 ska
    result := PChar(fileStrings.Data) + pos + sizeOf (short);
end;

function TAnalogMems.GetName(i: longInt): string;
begin
  result := GetstringValue(Items[i].NamePos);
//o  if result = '' then raise Exception.Create ('No elements name founded');
end;

function TAnalogMems.GetComment(i: longInt): string;
begin
  result := GetstringValue(items[i].CommentPos);
end;

function TAnalogMems.GetOnMsg(i: longInt): string;
begin
  result := GetstringValue(items[i].OnMsgPos);
end;

procedure TAnalogMems.getOschTeg(num: integer; var val: TOschTegGrope);
function GetWordsR(var str: string): string;
begin
  result := '';
  result := AnsiUpperCase(copy (str, 1, pos('/', str) - 1));
  str := copy(str, pos('/', str) + 1, length(str) - pos('/', str));
end;
var strS,rtn: string;
begin
setlength( val.num,0);
val.n:=0;
if (num>count-1) or (num<0) then exit;
strS:=self.GetOnMsg(num);
while trim(strS) <> '' do
 begin
   rtn:=GetWordsR(strS);
   if trim(rtn)<>'' then
    begin
      if getSimPleId(trim(rtn))>-1 then
        begin
         setlength( val.num,val.n+1);
          val.num[val.n]:=getSimPleId(trim(rtn));
          val.n:= val.n+1;
        end;
    end;
 end;
end;

function TAnalogMems.GetOffMsg(i: longInt): string;
begin
  result := GetstringValue(items[i].OffMsgPos);
end;

procedure TAnalogMems.AddIndex(ID: integer);
var
  j: ^integer;
begin
  new(j);
  j^:=ID;
  IndexStringList.Objects[IndexStringList.Add(UpperCase(GetName(id)))]:=TObject(j);
end;

procedure TAnalogMems.RemoveIndex(ID: integer);
begin
  IndexStringList.Delete(IndexStringList.indexOf(GetName(ID)));
end;

function TAnalogMems.GetItem (number: integer): PTAnalogMem;
begin
  result := @(TAnalogsStruct((Pointer(PChar(Data) + FPHeader^.HeaderSize))^).Items[number]);
end;

function TAnalogMems.GetSimpleID(ItemName: String): integer;
var
   i: integer;
   str :string;
   j: INTEGER;
begin
    result := -1;
    if itemName = '' then exit;
    { for i := 0 to Count - 1 do
     begin
         str := ItemName;
         if AnsiUpperCase(GetName(i)) = AnsiUpperCase(str) then begin
            result := Items[i].ID;
            exit;
         end;
     end; }
     J:=IndexStringList.IndexOf(UPPERCASE(ItemName));
     if j<>-1 then result:=integer(pint(IndexStringList.Objects[j])^);

end;

function TAnalogMems.GetID(ItemName: String): integer;
begin
    result := GetSimpleID(ItemName);
    if result <> -1 then exit;
   // result := calc.GetID (ItemName);
    if result <> -1 then begin
       inc (result, calcShift);
       exit;
    end;
    //если имя не найдено в базе данных,
    //считаем что это выражение и добавляем его в базу выражений
   // calc.AddItem (ItemName);
   // result := calcShift + calc.Count - 1;
end;

procedure TAnalogMems.IncCounter(number: integer); //return number
begin
   if number < count then
   begin
     inc(Items[Number].RefCount);
     if Items[Number].RefCount = 1 then Regs.NotifyNewRef(Number);
   end;
end;

procedure TAnalogMems.DecCounter (number: integer);
begin
   if number < count then
   begin
     dec(Items[Number].RefCount);
     if Items[Number].RefCount = 0 then Regs.NotifyRemRef(Number);
   end;
end;

procedure TAnalogMems.ValidOff(number: integer);
begin
   SetValid(number,0);
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
     if (Items[number].Logged) or (Items[Number].logtime=EVENT_TYPE_WITH_TIME_VAL) then
       Regs.NotifyLog(-1, Number);
     if IsValid(number) then
       begin
           Regs.NotifyEvents(0, Number);
           Regs.NotifyAlarm(0, Number);
           Regs.NotifyAlarmLocal(0, Number);
       end;
   end
end;


procedure TAnalogMems.AddCommand(number: integer; val: real; queue: boolean;CompName:string='';userName:string='');
var sysgrid: integer;
begin
  //добавляющий команду увеличивает колич. ссылок, если команда новая
  //выполняющ. уменьшает
  if Items[Number].ID = -1 then exit;
  if compName = '' then
    compName := HostName;
  if (userName='') and (trim(uppercase(hostname))=trim(uppercase(CompName))) then  userName:=operator_;
  sysgrid:= fTegGroups.ItemNum['$SYSTEM'];     // добавлено 8.11.2009
  if Items[Number].GroupNum<>sysgrid then      // добавлено 8.11.2009
  begin
  if Command.AddItem(number, Items[Number].ValReal, Val, queue, compName, userName ) = acNewCommand then
    incCounter(number);
  end else Items[Number].ValReal:=val;            // добавлено 8.11.2009
  SetVal(Number, Val,Items[Number].ValidLevel);                                // поменял местами
  //Regs.NotifyCommands(Command.Count-1, Number);        //        28.1.04
  Regs.NotifyCommands(Command.LastCommandLine  , Number);        //        12.03.04
end;

procedure TAnalogMems.RegHandle(Name: string; Handle: THandle; Events: TEventTypesSet);
begin
  Regs.RegHandle(Name, Handle, Events);
end;

procedure TAnalogMems.UnRegHandle(Handle: THandle);
begin
  Regs.UnRegHandle(Handle);
end;

procedure TAnalogMems.Log(mess: string; lev: byte=2);
begin
   if fdebugbase<>nil then
    begin
       if (fdebugL<=lev) then
         begin
            fdebugbase.AddItem(now,mess,fAppl,lev);
         end;
    end;
end;

procedure TAnalogMems.LogWarning( mess: string);
begin
  Log(mess, _DEBUG_WARNING);
end;

procedure TAnalogMems.LogError( mess: string);
begin
  Log(mess, _DEBUG_ERROR);
end;

procedure TAnalogMems.LogFatalError( mess: string);
begin
  Log(mess, _DEBUG_FATALERROR);
end;

procedure TAnalogMems.SetValue(number: integer; val: real);
var
  prevVal: real;
begin
   if ((Items[Number].ValReal <> Val) and (Items[Number].logtime<>EVENT_TYPE_WITHTIME)) then
  begin
    prevVal := Items[Number].ValReal;
    Items[Number].ValReal := val;

  // ValCh.AddItem(number, prevVal, Val, true);

    if (Items[number].Logged) or (Items[Number].logtime=EVENT_TYPE_WITH_TIME_VAL) then
     begin
      if (Items[number].ValidLevel>VALID_LEVEL) and
        (abs(prevVal-Items[Number].ValReal)>=Items[Number].logDB)
           then Regs.NotifyLog(0, Number);
     end;
    if (Items[number].ValidLevel>VALID_LEVEL) and ((Items[number].OnMsged and (Items[number].ValReal <> 0) and (prevVal = 0)) or
       (Items[number].OffMsged and (Items[number].ValReal = 0) and (prevVal <> 0))) then
         Regs.NotifyEvents(0, Number);
    if Items[number].Alarmed then Regs.NotifyAlarm(0, Number);;
    if Items[number].AlarmedLocal then Regs.NotifyAlarmLocal(0, Number);
    Regs.NotifyChange(0, Number);
  end;
  if (Items[Number].logtime=EVENT_TYPE_WITHTIME) then Regs.NotifyChange(0, Number);
end;

procedure TAnalogMems.SetVal(number: integer; val: real; VL: integer);
var
  prevVal: real;
  rstVL, rstVal, rstTm: boolean;
  newVL,oldVL: boolean;
  newVal,oldVal: real;
  LTim: integer;
  logged_,alarmed_, alarmedlocal_, msged_: boolean;
begin
   newVL:=VL > VALID_LEVEL;
   oldVL:=isValid(number);
   oldVaL:=Items[number].ValReal;
   newVal:=val;
   rstVL:=(isValid(number)<>newVL);
   rstVal:=(val<>(Items[number].ValReal));
   logged_:=Items[number].Logged;
   alarmed_:=Items[number].Alarmed;
   alarmedlocal_:=Items[number].AlarmedLocal;
   msged_:=((Items[number].OffMsged) or (Items[number].OnMsged));
   LTim:=rtItems.Items[Number].logTime;
   prevVal := Items[Number].ValReal;
   Items[Number].ValReal := val;
   rstTm:=abs(secondsbetween(now,Items[Number].TimeStamp))>30;
   Items[Number].ValidLevel := VL;

   if  (rstVL or rstVal or rstTm) then
     begin

      // для трендов
      if (logged_) and  not (LTim in REPORT_SET) then
       begin
         if rstVL then Regs.NotifyLog(0, Number) // при фронте валидности
           // пишем всегда   ( при исчезновении для создания метки исчезновения)
           else
             begin
               if ((newVL) and       //  иначе только в плюсовой валидности
                ((abs(prevVal-newVaL)>=Items[Number].logDB)
                or (rstTm)))
               then
               begin
               rtItems.Items[Number].TimeStamp:=now;
               Regs.NotifyLog(0, Number);
               end;
             end;
        end;

      // для внутренних трендов
      if (logged_) then
       begin
         if rstVL then Regs.NotifyLogInside(0, Number) // при фронте валидности
           // пишем всегда   ( при исчезновении для создания метки исчезновения)
           else
             begin
               if (newVL)        //  иначе только в плюсовой валидности
               then Regs.NotifyLogInside(0, Number);
             end;
        end;

       //  для сообщений
       if (msged_) then
          begin    // пишем только в случае  newVL=oldVL+ в валидном состоянии
                   // избегаем мусорных сообщений
             if (newVL and oldVL) then
               if (((Items[number].OnMsged) and (oldVaL=0) and (newval<>0)) or
                   ((Items[number].OffMsged) and (oldVaL<>0) and (newval=0))) then
                        Regs.NotifyEvents(0, Number);
          end;
      // для журнала и тревог
      if (alarmed_ and rstVal) then   // закомментировал rstVal // скидывало валидность 2015-10-02
          begin    // пишем  в случае  newVL=oldVL+ в валидном состоянии  и при возникновении валиности

             if (newVL) then
                        Regs.NotifyAlarm(0, Number);
          end;

       if ( alarmedlocal_ and rstVal) then // закомментировал rstVal // скидывало валидность 2015-10-02
          begin    // пишем  в случае  newVL, oldVL + newVL
             if (newVL) then
                Regs.NotifyAlarmLocal(0, Number);
          end;

      if (newVL) then
            Regs.NotifyChange(0, Number);
  end;
  if (Items[Number].logtime=EVENT_TYPE_WITH_TIME_VAL) then Regs.NotifyLog(0, Number);
  if (Items[Number].logtime=EVENT_TYPE_WITHTIME) then Regs.NotifyChange(0, Number);
end;


procedure TAnalogMems.SetValForce(number: integer; val: real; VL: integer);
begin
   if number<0 then exit;
   Items[Number].ValidLevel := VL;
   SetVal(number, val, VL);

end;

destructor TAnalogMems.Destroy;

var i: integer;
begin
     oper.Free;
     for i:=0 to IndexStringList.Count-1 do
      begin
        dispose(Pint(IndexStringList.Objects[i]));
       end;
     IndexStringList.Free;
     fTegGroups.free;
     fAlarmGroups.free;
     fileStrings.Free;
     command.free;
     alarms.Free;
     activeAlarms.Free;
    // ValCh.Free;
   //  calc.free;
     Regs.Free;
     if assigned(analogLocBase) then analogLocBase.free;
    if assigned(self.fdebugBase) then fdebugBase.free;
     inherited;
end;

function TAnalogMems.isValid(number: integer): boolean;
begin
     result := (Items[number].ValidLevel > VALID_LEVEL);
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
function TCommandMems.GetItem (number: longInt):TCommandStruct;
begin
     result := PTCommands(Data)^.Items[number];
end;

function TCommandMems.GetItemN(number: Integer): PTCommandStruct;
begin
  if CurLine + number < count then
     result := @(PTCommands(Data)^.Items[curline + number])
  else
     result := @(PTCommands(Data)^.Items[curline + number - count]);
end;

constructor TCommandMems.Create (fileDIR: string; MemName: string);
begin
  inherited Create(MemName);
  if isNewFileOpened then
  begin
    PTCommands(Data)^.Header.Count := 0;
    PTCommands(Data)^.Header.LastNumber := 0;
  end;
end;

procedure TCommandMems.SetExecuted(num: longInt);
begin
  PTCommands(Data)^.Items[num].Executed := true;
end;

procedure TCommandMems.ClearExecuted(num: longInt);
begin
  PTCommands(Data)^.Items[num].Executed := false;
end;

function TCommandMems.AddItem(number: integer; PrevVal, val: real; queue: boolean; compName: string = ''; username: string=''): TAddedItemType;
var
   i: integer;
begin
     result := acNewCommand;
     LastCommandLine := -1;
     if not queue then
        for i := Count - 1 downto 0 do
            if (Items[i].id = number) and (not Items[i].executed) then begin
              SetExecuted(i);//заблокировать выполнение
              LastCommandLine := i;
              result := acQueuedCommand;
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

       if count < maxCount then inherited Count := Count + 1;
       inherited CurLine := CurLine + 1;
       inherited LastNumber := LastNumber + 1;

       PTCommands(Data)^.Items[LastCommandLine].Number := lastNumber;
       PTCommands(Data)^.Items[LastCommandLine].PrevVal := PrevVal;
     end;

     PTCommands(Data)^.Items[LastCommandLine].ID := number;
     PTCommands(Data)^.Items[LastCommandLine].valReal := val;
     PTCommands(Data)^.Items[LastCommandLine].CompName := CompName;
     PTCommands(Data)^.Items[LastCommandLine].UserName := UserName;
     PTCommands(Data)^.Items[LastCommandLine].Executed := False; //разблокировать выполнение
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
constructor TAlarmMems.Create (MemName: string; aMaxCount: integer);
begin
  inherited CreateW(MemName,aMaxCount,sizeof(TAlarmStruct)*(aMaxCount+100)+sizeof(THeaderStruct));
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
  firstLine : integer;
begin
  firstLine := ifthen(count = maxCount, curLine, 0);
  result := (firstNumber + number) mod (MaxCount - 1);
end;

function TAlarmMems.GetItem (num: longInt):PTalarmStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TAlarmsMem индекс за границей! ' + inttostr(num));
  result := @(PTalarms(Data)^.Items[ConvertNumber(num)]);
end;

function TAlarmMems.AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType): integer;
var
   i: integer;
begin
   inherited LastNumber := LastNumber + 1;
    if count < maxCount then inherited Count := Count + 1;
    Items[curLine].number := lastNumber;
    Items[curLine].Time := aTime;
    Items[curLine].TegID := aTegID;
    Items[curLine].Typ := aTyp;
    result := curLine;
    inherited CurLine := convertNumber(CurLine + 1);
end;

function TAlarmMems.AddItem(atime: TDateTime; aTegID: integer; atyp: TMsgType; comp: string; oper: string ): integer;
var
   i: integer;
begin
   inherited LastNumber := LastNumber + 1;
    if count < maxCount then inherited Count := Count + 1;
    Items[curLine].number := lastNumber;
    Items[curLine].Time := aTime;
    Items[curLine].TegID := aTegID;
    Items[curLine].Typ := aTyp;
    if  atyp=msCmd then
      begin
        Items[curLine].oper:='';
        if comp<>'' then
        Items[curLine].oper:='['+comp+']';
        Items[curLine].oper:=Items[curLine].oper+oper;
      end;
    result := curLine;
    inherited CurLine := convertNumber(CurLine + 1);
end;

destructor TAlarmMems.Destroy;
begin
    inherited;
end;


//************************** TAnalogMems **************************//
procedure TAnalogMems.SetName(i: Integer; value: string);
begin
  SetStringValue(Items[i].NamePos, value);
end;

procedure TAnalogMems.SetComment(i: Integer; value: string);   
begin
  SetStringValue(Items[i].CommentPos, value);
end;

procedure TAnalogMems.SetOnMsg(i: Integer; value: string);
begin
  SetStringValue(Items[i].OnMsgPos, value);
end;

procedure TAnalogMems.SetOffMsg(i: Integer; value: string);
begin
  SetStringValue(Items[i].OffMsgPos, value);
end;

procedure TAnalogMems.setOperator(val: string);
begin
   operator_:=val;
end;

procedure TAnalogMems.SetStringValue(var pos: longInt; value: string);
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
      move((PChar(fileStrings.Data)+pos)^, allocSize, SizeOf(allocSize))
    else allocSize := 0;

    //если размер строки увеличен, пишем строку в конец файла
    if (allocSize < Length(Value) + 1   ) then
    begin
      allocSize := Length(Value) + 1;
      pos := fileStrings.FileSize;//определяем позицию записи строки
      fileStrings.fileSize := fileStrings.FileSize + allocSize + sizeOf(allocSize);
    end;
    //пишем объем выделенной памяти
    move(allocSize, (PChar(fileStrings.data) + pos)^, sizeOf(allocSize));
    //пишем строковые даные в память
    system.move(PChar(Value)^, (PChar(fileStrings.Data) +
                pos + sizeof(allocSize))^, Length(Value) + 1);
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
  result := fPHeader^.RecordCount;
 { except
    raise Exception.Create('Некорректное выражение');
  end;      }
end;

procedure TAnalogMems.SetCount(const Value: integer);
var
  fStr: TFileStream;
begin
  fPHeader^.RecordCount := value;
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
 for i := fpHeader^.recordCount - 1 downto 0 do
 begin
   //предварительно заполняе нулями
   fillChar((PChar(Data) + FPHeader^.HeaderSize + I * sizeOf(TanalogMem) + FPHeader^.RecordSize)^,
                sizeOf(TanalogMem) - FPHeader^.RecordSize, 0);
   move((PChar(Data) + FPHeader^.HeaderSize + I * FPHeader^.RecordSize)^,
        (PChar(Data) + SizeOf(TAnalogMemHdr) + I * sizeOf(TanalogMem))^,
                                                FPHeader^.RecordSize);
 end;
  with FPHeader^ do
  begin
    Ver := currentBaseVersion;
    HeaderSize :=  sizeOf(TAnalogMemHdr);
    RecordSize := sizeOf(TAnalogMem);
    DataSize := HeaderSize + RecordSize * RecordCount;
    fileSize := dataSize;
  end;
  writeBaseToFile(false);
end;



function TAnalogMems.GetItemOffset(ItemNum: Integer): longInt;
begin
  result := FPHeader^.HeaderSize + ItemNum * SizeOf(TAnalogMem);
end;

procedure TAnalogMems.WriteToFileAll();
var i: integer;
begin
   for i:=0 to Count-1 do
     begin
        WriteToFile(i);
     end;
end;

procedure TAnalogMems.WriteToFile(curItem: Integer);
var
  fStr: TFileStream;
  curRefCount: integer;
  curIsKvit: boolean;
  varsGrnum: integer;
  ValReal_: real;
  ValidLevel_: integer;
  GroupNum_: integer;
  DeathB: real;
begin



   ValidLevel_:=items[curItem].ValidLevel;
   GroupNum_:=items[curItem].GroupNum;
   varsGrnum:=TegGroups.ItemNum['$SYSVAR'];
   DeathB:=items[curItem].TimeStamp;

  if (trim(GetName(curItem))='') and (items[curItem].ID>-1) then exit;
  fStr := TFileStream.Create(ffileDIR + 'Analog.mem', fmOpenReadWrite);
  try
    fStr.Seek(GetItemOffset(curItem), SoFromBeginning);
    //сохраняем что бы сбросить для записи количество ссылок

    CurRefCount := items[curItem].refCount;
    items[curItem].refCount := 0;

    // записываем условие неалармности
    ValReal_:=items[curItem].ValReal;
    if (GroupNum_<>varsGrnum) then
         begin
         if (items[curItem].alarmCase<>alarmEqual) then
         begin
           if (items[curItem].alarmCase=alarmMore) then
             begin
               if (items[curItem].AlarmConst>=0) then
                 items[curItem].ValReal:=0
               else items[curItem].ValReal:=items[curItem].AlarmConst;
             end
           else
             begin
               items[curItem].ValReal:=items[curItem].AlarmConst;
             end;
         end else
         begin
           if (items[curItem].AlarmConst<>0) then items[curItem].ValReal:=0
           else items[curItem].ValReal:=1;
         end;
         end else
       begin
         // ValReal_:=items[curItem].ValReal;
       end;


    // записываем нулевую валидность
    // кроме $SYSVAR
    ValidLevel_:=items[curItem].ValidLevel;
    if (GroupNum_<>varsGrnum) then
         items[curItem].ValidLevel:=0 else
         items[curItem].ValidLevel:=100;
    items[curItem].TimeStamp:=0;
    CurIsKvit := items[curItem].isAlarmKvit;
    items[curItem].isAlarmKvit := true;
    // записываем запись
    fStr.Write(items[curItem]^, SizeOf(TAnalogMem));
    //восстанавливаем количество ссылок
    items[curItem].refCount := CurRefCount;
    items[curItem].isAlarmKvit := CurIsKvit;
    items[curItem].TimeStamp:=DeathB;
    if (GroupNum_<>varsGrnum) then
         items[curItem].ValReal:=ValReal_;
    if (GroupNum_<>varsGrnum) then
         items[curItem].ValidLevel:=ValidLevel_;
  finally
    fStr.Free;
  end;
  if (GetSimpleID(GetName(curItem)) = -1) and (Items[curItem].ID <> -1) then AddIndex(curItem);
end;

{ TMappedFilePsevdo }

{***************************** TMappedFilePsevdo ************************************}
//выделяет файл в памяти и копирует туда содержание файла
//при этом файл не блокируется, и можо его дополнять без проблем

constructor TMappedFilePsevdo.Create (fileNm, mapNm: string; oldOverride: boolean = false);
var
  fStr: TFileStream;
begin
  inherited Create('', MapNm);
    fStr := TFileStream.Create(filenm, fmOpenReadWrite);
    try
      if isNewFileOpened or oldOverride then fStr.Read(data^, fStr.Size);
       fileSize := fStr.Size;
    finally
      fStr.Free;
    end;
end;

procedure TAnalogMems.FreeItem(Num: Integer);
begin
  if GetSimpleID(GetName(Num)) <> -1 then RemoveIndex(Num);
  Items[Num].ID := -1;
  Items[Num].NamePos := -1;
  Items[Num].CommentPos := -1;
  Items[Num].OnMsgPos := -1;
  Items[Num].OffMsgPos := -1;
end;

procedure TAnalogMems.addLocalBaseTag(idA: integer);
begin
  if (localbase) and (self.analogLocBase<>nil) then self.analogLocBase.AddItem(idA)
end;

class function TAnalogMems.isLock: boolean;
begin
   result:=MappedMemoryisLock(MAIN_MAP_NAME);
end;

procedure TAnalogMems.addLocalBaseGroup(idGroup: integer);
begin
//  if (localbase) and (absensAnalog<>nil) and (conttimeoff) then self.absensAnalog.AddItem(idGroup)
end;

procedure TAnalogMems.setLocalBaseTagval(ltime: TDateTime; aTagId: integer; value: single;valid: integer);
begin
  if (localbase) and (self.analogLocBase<>nil) then self.analogLocBase.setvalue(ltime , aTagId, value, valid)
end;

procedure TAnalogMems.setLocalBaseGroupval(ltime: TDateTime; GrouId: integer; state: boolean);
begin
 // if (localbase) and (absensAnalog<>nil) and (conttimeoff) then self.absensAnalog.setvalue(ltime, GrouId, state)
end;

function TAnalogMems.QueryLocalBaseTag(tim: TDateTime; minut: integer; aTagid: integer; var val: tTDPointData): Tdatetime;
begin
  result:=0;
  if (localbase) and (self.analogLocBase<>nil) then result:=self.analogLocBase.getquery(tim, minut, aTagid, val);
end;




function TAnalogMems.GetDDEItem(i: Integer): string;
begin
  result := GetstringValue(Items[i].ItemPos);
end;

function TAnalogMems.TagDubleErr(val: integer): integer;
var i: integer;
    j: string;
begin
  result:=-1;
  if val>count-1 then exit;
  if items[val].ID<0 then exit;
  for i:=0 {val - правильнее} to count-1 do
   if (i<>val) and (trim(uppercase(GetName(i)))= trim(uppercase(GetName(val))))
      then
      begin
      result:=i;
      exit;
      end
end;


function TAnalogMems.TagDubleErrIs: boolean;
var i: integer;
    j: string;
begin
 result:=false;
 for i:=0  to count-1 do
   if TagDubleErr(i)>-1 then
   begin
   result:=true;
   exit;
   end;
end;

procedure TAnalogMems.ClearDubleErr;
var i: integer;
    j: integer;
begin
  i:=0;
  for i:=0 to count-1 do
   if ((Items[i].ID>-1) and (trim(GetName(i))='')) then
     begin
       Showmessage('Обнаружен пустой тег ID='+inttostr(Items[i].ID)+'. '+
             'Он будет удален');
       Items[i].ID := -1;
       Items[i].NamePos := -1;
       Items[i].CommentPos := -1;
       Items[i].OnMsgPos := -1;
       Items[i].OffMsgPos := -1;
       WriteToFile(i);
     end;
  i:=0;
  while i<count do
    begin
      j:=TagDubleErr(i);
      if j>-1 then
        begin
          Showmessage('Обнаружен дублированный тег "'+getname(i)+'" '+#10+#13+
             ' позиция рабочего - '+inttostr(i)+ ', позиция дубликата -' +inttostr(j)+#10+#13+' '+
             'Дупликат будет переименован в '+self.getname(i)+'_doubleerror'+'!!! ');
           Items[i].ID := i;
           self.setname(i,self.getname(i)+'_doubleerror');
          // Items[i].NamePos := -1;
          // Items[i].CommentPos := -1;
        //   Items[i].OnMsgPos := -1;
         //  Items[i].OffMsgPos := -1;
           self.WriteToFile(i);
        end;
        inc(i);
    end;

end;

function TAnalogMems.GetAlarmMsg(i: Integer): string;
begin
  result := GetstringValue(Items[i].AlarmMsgPos);
end;

procedure TAnalogMems.SetAlarmMsg(i: Integer; value: string);
begin
  SetStringValue(Items[i].AlarmMsgPos, value);
end;

function TAnalogMems.GetEU(i: Integer): string;
begin
  result := GetstringValue(Items[i].EUPos);
end;

procedure TAnalogMems.SetEU(i: Integer; value: string);
begin
  SetStringValue(Items[i].EUPos, value);
end;

procedure TAnalogMems.SetDDEItem(i: Integer; value: string);
begin
  SetStringValue(Items[i].ItemPos, value);
end;

function TAnalogMems.GetAlarmCase(i: Integer): string;
begin
  case Items[i].alarmCase of
    alarmLess: result := '<';
    alarmMore: result := '>';
  end;
end;

procedure TAnalogMems.SetAppName(app: string);
begin
   self.fAppl:=app;
end;

procedure TAnalogMems.ClearCommandExecuted(ComNum: Integer);
begin
  command.ClearExecuted(ComNum);
  incCounter(command.Items[comNum].ID);
end;

procedure TAnalogMems.SetCommandExecuted(ComNum: Integer);
begin
  command.SetExecuted(ComNum);
  decCounter(command.Items[comNum].ID);
end;


function Regrtitems(point: Pointer; point1: pointer; point2: pointer; pactive: pointer): pointer;
begin
  rtitems:=TAnalogMems(point);
  result:=rtitems;
 
  EXIT; //24.05.04 - алармы теперь в мем файле
{
if point1=nil then
 begin
    Alarms := TAlarms.Create;
 end
else
 begin
    Alarms := TAlarms(point1);
 end;

if point2=nil then
 begin
    ActiveAlarms := TactiveAlarms.Create;
 end
else
 begin
    ActiveAlarms := TactiveAlarms(point2);
 end;
}
end;

procedure SetAcsessAdress(p: pointer;pname: pointer;ppas: pointer);
begin
  AccessLevel:=p;
  OperatorName:=pname;
  CurrantKey:=ppas;

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
    fStr.Write(data^,SizeOf(fPHeader^) + Count * SizeOf(TAnalogMem))
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
    TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmOn := true;
    TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmKvit := false;
  for i := 0 to count -1 do
    if Items[i].TegID = aTegId then
    begin
      Items[i].isOff := false;
      exit;
    end;

    inherited Count := Count + 1;
    inherited LastNumber := LastNumber + 1;
    Items[count-1].number := lastNumber;
    Items[count-1].Time := aTime;
    Items[count-1].TegID := aTegID;
    Items[count-1].isKvit := False;
    Items[count-1].isOff := false;
    result := count - 1;
    TAnalogMems(rtItemsPointer).alarms.AddItem(Now, aTegId, msNew);
    TAnalogMems(rtItemsPointer).Regs.NotifyNewAlarm;
end;

procedure TActiveAlarmMems.CheckOut;
var
  i: integer;
begin
  for i := count - 1 downto 0 do
    begin
    if items[i].isKvit and items[i].isOff then
    begin
      TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msOut);
      TAnalogMems(rtItemsPointer).Items[items[i].TegID].isAlarmOn := false;
      if i < (count - 1) then //если элемент не последний, подтягиваем хвост
      begin
        move(items[i + 1]^, items[i]^, sizeOf(TActiveAlarmStruct) * (count - i));
      end;
      inherited Count := count - 1;
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

function TActiveAlarmMems.GetItem(num: Integer): PTActiveAlarmStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TActiveAlarmsMem индекс за границей! ' + inttostr(num));
  result := @(PTActiveAlarms(Data)^.Items[num]);

end;

procedure TActiveAlarmMems.KvitAll;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := true;
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
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
  for i := 0 to count - 1 do
  begin
    if TAnalogMems(rtItemsPointer).Items[items[i].TegId].AlarmGroup=grnum then
    begin
    TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := true;
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
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
  for i := 0 to count - 1 do
  begin
    if TAnalogMems(rtItemsPointer).Items[items[i].TegId].GroupNum=grnum then
    begin
    TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := true;
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
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
  for i := 0 to count - 1 do
    if (items[i].TegID = aTegID) and not items[i].isOff then
    begin
      items[i].isOff := true;
      inherited LastNumber := LastNumber + 1;
    end;
  CheckOut;
end;



{ TAnalogLocBaseMems }


function TAnalogLocBaseMems.AddItem(aTegID: integer): integer;
var

   i: integer;
begin
      for i := 0 to count-1 do
        begin
        if Items[i].TagId = aTegId  then
           begin
             self.addIndex(aTegID,i);
             exit;
           end;
        end;
    self.addIndex(aTegID,count);
    inherited Count := Count + 1;
    inherited LastNumber := LastNumber + 1;
    Items[count-1].count := 0;
    Items[count-1].TagID := aTegID;
    Items[count-1].last:=-1;
    for I:=0 to 3591 do
      begin
         Items[count-1].point[i].value:=0;
         Items[count-1].point[i].tim:=0;
      end;
    result := count - 1;
end;




procedure TAnalogLocBaseMems.setvalue(ltime: TDateTime; aTagId: integer; value: single;valid: integer);
var
   i,j,k, ltime_plus: integer;
   delt: single;
begin
    i:=self.getNumById(aTagID);
    if i>-1 then
    begin
      if Items[i].count<3591 then inc(Items[i].count);
      if Items[i].last>=3590
         then Items[i].last:=0
      else
         inc(Items[i].last);
      if (valid>VALID_LEVEL) then
      Items[i].point[Items[i].last].value:=value else
      Items[i].point[Items[i].last].value:=NILL_ANALOG;
      Items[i].point[Items[i].last].tim:=ltime;
      exit;
     end;
end;


function TAnalogLocBaseMems.getQuery(tim: TDateTime; minut: integer; aTagid: integer; var val: tTDPointData): tdatetime;
var i,j,cnt,l,n: integer;
    fl, lastvalid, flfind: boolean;
    starttime, stoptime: TdateTime;
     pointcount,timecount, reccount: integer;
 {  //point_, time_: array of TDPointData ; }
    dataavalable: boolean;
begin
    result:=0;
    val.npoint:=0;
    val.ntime:=0;
    Setlength(val.point,0);
    Setlength(val.time,1);
    fl:=false;
    starttime:=incminute(tim,-minut);
    stoptime:=tim;
    val.time[0][1]:=incminute(tim,-minut);
    val.time[0][2]:=tim;
    val.ntime:=1;
    lastvalid:=false;
    for i := 0 to count -1 do
    if Items[i].TagId = aTagId then
    begin
       result:=1;
       n:=0;
       l:=Items[i].last+2;
       j:=Items[i].last+1;
       if (l)>=Items[i].count then l:=0;
       if (j)>=Items[i].count then j:=0;
       setlength(val.point,Items[i].count+4);
       setlength(val.time,round((Items[i].count+4)/2));
       cnt:=Items[i].count;
       pointcount:=0;
       timecount:=0;
       if (cnt=0) then
       begin
         val.time[timecount][1]:=incminute(tim,-minut);
         val.time[timecount][2]:=tim;
         inc(timecount);
       end
       else
       while (cnt>n) do
         begin
            if (Items[i].point[l].tim>=incminute(tim,-minut))  then
            begin
              if (NOT FL) and (not lastvalid) then
              begin
                val.time[timecount][1]:=incminute(tim,-minut);
                val.time[timecount][2]:=Items[i].point[l].tim;
                inc(timecount);
              end;

             if not fl then
              begin
              if  not (Items[i].point[j].value=NILL_ANALOG) then
              begin
                 val.point[0][1]:=Items[i].point[j].value;
                 val.point[0][2]:=Items[i].point[j].tim;

                if (val.point[0][2]<starttime) then
                  begin
                    val.point[0][2]:=starttime;
                  end
                else
                  begin
                    if (val.point[0][2]>starttime) then
                      begin
                        val.time[timecount][1]:=incminute(tim,-2*minut);
                        val.time[timecount][2]:=val.point[0][2];
                        inc(timecount);
                        val.point[1][2]:=val.point[0][2];
                        val.point[1][1]:=val.point[0][1];
                        val.point[0][2]:=starttime;
                        inc(pointcount);
                      end;
                  end;



              inc(pointcount);
              dataavalable:=true;
              end
              else
              begin
                val.time[0][1]:=starttime;
                dataavalable:=false;
              end;
                fl:=true;
            end;


            begin
              if  not (Items[i].point[j].value=NILL_ANALOG) then
                begin
                   val.point[pointcount][1]:=Items[i].point[j].value;
                   val.point[pointcount][2]:=Items[i].point[j].tim;
                   if not dataavalable then
                     begin
                       val.time[timecount][2]:=val.point[pointcount][2];
                       inc(timecount);
                     end;
                   inc(pointcount);
                   dataavalable:=true;
                end
              else
                begin
                   if dataavalable then
                     begin
                       val.time[timecount][1]:=Items[i].point[j].tim;
                       if (pointcount>0) then
                         begin
                         val.point[pointcount][1]:=val.point[pointcount-1][1];
                         val.point[pointcount][2]:=val.time[timecount][1];
                         inc(pointcount);
                         end;
                     end;
                   dataavalable:=false;
                end;
              end;
              end
              else
              begin
                 if not fl then
                      lastvalid:=(Items[i].point[j].value<>NILL_ANALOG);
              end;
              val.npoint:=pointcount;
              val.ntime:=timecount;

            inc(l);
            inc(j);
            inc(n);
            if (l)>=Items[i].count then l:=0;
            if (j)>=Items[i].count then j:=0;
         end;

       exit;
    end;
end;

constructor TAnalogLocBaseMems.Create(rtItemsPtr:pointer; MemName: string);
var I: integer;
begin
  inherited CreateW(MemName,1000,60000000);
  rtItemsPointer := rtItemsPtr;
  indexListI:=TStringList.Create;
  indexListI.Sorted:=true;
  indexListI.Clear;
end;

destructor TAnalogLocBaseMems.Destroy;
begin
  inherited;
  indexListI.Free;
end;

function TAnalogLocBaseMems.GetItem(num: Integer): PTAnalogLocBaseStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TAnalogLocBaseMems индекс за границей! ' + inttostr(num));
  result := @(PTAnalogLocBase(Data)^.Items[num]);
end;

function TAnalogLocBaseMems.findById(id: Integer): PTAnalogLocBaseStruct;
var I: integer;
begin
  result:=nil;
  for i:=0 to count-1 do
  if items[i].TagId=id then
  begin
  result := @(PTAnalogLocBase(Data)^.Items[i]);
  exit;
  end;
end;

procedure TAnalogLocBaseMems.addIndex(idX, num: integer);
var i: integer;
    ipo: pInteger;
    stry: string;
begin
if num<0 then exit;
if idx<0 then exit;
i:=indexListI.IndexOf(inttostr(idX));
if i>0 then exit;
new(ipo);
ipo^:=num;
indexListI.AddObject(trim(inttostr(idX)),tobject(ipo))
end;



function TAnalogLocBaseMems.GetNumbyId(idx: integer): integer;
var j: integer;
begin
 result:=-1;
 j:=indexListI.IndexOf(trim(inttostr(idX)));
 if j>-1 then
     if indexListI.Objects[j]<>nil then result:=pinteger(indexListI.Objects[j])^;
end;

{ TAnalogAbsent }

{function TAnalogAbsentTimeMems.AddItem(GroupID: integer): integer;
var
   i: integer;
begin
      for i := 0 to count-1 do
        begin
        if Items[i].groupId = groupId  then
           begin
             self.addIndex(groupId,i);
             exit;
           end;
        end;
    self.addIndex(groupId,count);
    inherited Count := Count + 1;
    inherited LastNumber := LastNumber + 1;
    Items[count-1].count := 1;
    Items[count-1].groupId := groupId;
    Items[count-1].last:=0;
    for I:=0 to 99 do
      begin
         Items[count-1].point[i].start:=strtodate('31.12.3000');;
         Items[count-1].point[i].stop:=0;
      end;
    result := count - 1;
end;



procedure TAnalogAbsentTimeMems.setvalue(ltime: TDateTime; GrouId: integer; state: boolean);
var
   i,j,k, ltime_plus: integer;
   delt: single;
begin
    i:=self.getNumById(GrouId);
    if i>-1 then
    begin

      if state then
        begin
         if  items[i].point[Items[i].last].start>ltime then
           items[i].point[Items[i].last].start:=ltime;
          //  showmessage('on->'+datetimetostr(items[i].point[Items[i].last].stop)+'-'+datetimetostr(items[i].point[Items[i].last].start));
        end else
        begin

           if  items[i].point[Items[i].last].start>(ltime+100) then exit;

              if Items[i].count<100 then inc(Items[i].count);
           //items[i].point[Items[i].last].start:=ltime;
           inc(Items[i].last);
           if Items[i].last>=Items[i].count then Items[i].last:=0;
             items[i].point[Items[i].last].stop:=ltime;
             items[i].point[Items[i].last].start:=strtodate('31.12.3000');
        //     showmessage('off->'+datetimetostr(items[i].point[Items[i].last].stop)+'-'+datetimetostr(items[i].point[Items[i].last].start));
        end;

      exit;
     end;
end;


function TAnalogAbsentTimeMems.getQuery(tim: TDateTime; minut: integer; groupid: integer; var val: tTDPoint): boolean;
var i,j,n,cnt: integer;
    fl: boolean;
begin
    val.n:=0;
    Setlength(val.point, 0);
    result:=false;
    for i := 0 to count -1 do
    if Items[i].groupId = groupid then
    begin
       n:=0;
       result:=true;
       j:=Items[i].last+1;;
       if (j)>=Items[i].count then j:=0;
       cnt:=Items[i].count;
       while n<cnt do
         begin
            inc(n);
            if ((Items[i].point[j].stop>=incminute(tim,-minut)) or
               (Items[i].point[j].start>=incminute(tim,-minut))) then
              begin
               Setlength(val.point, val.n+1);
               inc(val.n);
               val.point[val.n-1][1]:=Items[i].point[j].stop;
               val.point[val.n-1][2]:=Items[i].point[j].start;
              end;
              // showmessage(Datetimetostr(Items[i].point[j].stop)+'-'+datetimetostr(Items[i].point[j].start)+'count='+inttostr(Items[i].count)+'last='+inttostr(Items[i].last)+'j='+inttostr(j));
            inc(j);
            if (j)>=Items[i].count then j:=0;

         end;

         exit;
    end;
end;

constructor TAnalogAbsentTimeMems.Create(rtItemsPtr:pointer; MemName: string);
var I: integer;
begin
  inherited CreateW(MemName,1000,10000000);
  rtItemsPointer := rtItemsPtr;
  indexListI:=TStringList.Create;
  indexListI.Sorted:=true;
  indexListI.Clear;
end;

destructor TAnalogAbsentTimeMems.Destroy;
begin
  inherited;
  indexListI.Free;
end;

function TAnalogAbsentTimeMems.GetItem(num: Integer): PTAbsenttimeInfoStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TActiveAlarmsMem индекс за границей! ' + inttostr(num));
  result := @(PTAbsenttimeInfo(Data)^.Items[num]);
end;

function TAnalogAbsentTimeMems.findById(id: Integer): PTAbsenttimeInfoStruct;
var I: integer;
begin
  result:=nil;
  for i:=0 to count-1 do
  if items[i].groupId=id then
  begin
  result := @(PTAbsenttimeInfo(Data)^.Items[i]);
  exit;
  end;
end;

procedure TAnalogAbsentTimeMems.addIndex(idX, num: integer);
var i: integer;
    ipo: pInteger;
    stry: string;
begin
if num<0 then exit;
if idx<0 then exit;
i:=indexListI.IndexOf(inttostr(idX));
if i>0 then exit;
new(ipo);
ipo^:=num;
indexListI.AddObject(trim(inttostr(idX)),tobject(ipo))
end;



function TAnalogAbsentTimeMems.GetNumbyId(idx: integer): integer;
var j: integer;
begin
 result:=-1;
 j:=indexListI.IndexOf(trim(inttostr(idX)));
 if j>0 then
     if indexListI.Objects[j]<>nil then result:=pinteger(indexListI.Objects[j])^;
end;      }

{ TAnalogLocBaseMems }

class procedure  TOperatorMems.createfileO(fileName: string);
var
       i: integer;
         fStr: TFileStream;
begin

   for i:=0 to 1000 do
     begin
      ostr.Items[i].id:=-1;
      ostr.Items[i].idgroup:=-1;
      ostr.Items[i].accessLevel:=9999;
      ostr.Header.count:=0;
       ostr.Header.maxcount:=999;
     end;
       fStr := TFileStream.Create(fileName+ 'operators.mem', fmCreate);
  try
    fStr.Write(ostr,SizeOf(ostr))
  finally
    fStr.Free;
  end;
end;

constructor TOperatorMems.Create (fileDIR : string);


var
  WSAData : TWSAData;
  i: integer;
  fileName : string;
  fStr: TFileStream;
  isBaseReload: boolean;
  newoper: PTOperators;
begin

   usCur:=-1;
  fsize:=100000;
  fFileDir := fileDir;
  fileName := fileDIR + 'operators.mem';

     if not fileExists (fileDIR + 'operators.mem') then
       begin
         createfileO(fFileDir)
       end;
       try
        inherited Create(fileDIR + 'operators.mem', 'immi_operators');
        fPHeader := Data;
       except
       end;
     IndexStringList:=TStringList.Create;
     IndexStringList.Sorted:=true;

     for i:=0 to Count-1 do
       if Items[i].ID <> -1 then
        AddIndex(Items[i].ID);
     //fPHeader.maxCount:=999   
 end;


function TOperatorMems.findNullId:integer;
var i,j: integer;
    fl: boolean;
begin
  i:=0;
  fl:=true;
  while fl do
  begin
  fl:=false;
  for j:=0 to count-1 do if items[j].id=i then
    begin
     i:=i+1;
     fl:=true;
    end;
  end;
  result:=i;
end;


function TOperatorMems.GetName(idn: longInt): string;
var
   i: integer;
begin
  result:='Незарегистрирован';
 if idn<0 then exit;
 result:=items[idn].name;
end;

function TOperatorMems.GetNamebyid(idn: longInt): string;
var
   i: integer;
begin
  result:='Незарегистрирован';
 for i:=0 to count-1 do
 if idn=items[i].id then
 result:=items[i].name;
end;



procedure TOperatorMems.AddIndex(ID: integer);
var
  j: ^integer;
begin
  new(j);
  j^:=ID;
  IndexStringList.Objects[IndexStringList.Add(UpperCase(GetNamebyid(id)))]:=TObject(j);
end;

procedure TOperatorMems.RemoveIndex(ID: integer);
begin
  IndexStringList.Delete(IndexStringList.indexOf(GetNamebyid(ID)));
end;

function TOperatorMems.GetItem (number: integer): PTOperatorstruct;
begin
  result := @TOperatorsStruct(data^).Items[number];
end;

function TOperatorMems.GetSimpleID(ItemName: String): integer;
var
   i: integer;
   str :string;
   j: INTEGER;
begin
    result := -1;
    if itemName = '' then exit;
     J:=IndexStringList.IndexOf(UPPERCASE(ItemName));
     if j<>-1 then result:=integer(pint(IndexStringList.Objects[j])^);

end;

function TOperatorMems.GetID(ItemName: String): integer;
begin
    result := GetSimpleID(ItemName);
end;


function TOperatorMems.GetCount: integer;
begin
  result := fPHeader^.count;
end;

procedure TOperatorMems.SetCount(const Value: integer);
var
  fStr: TFileStream;
begin
  fPHeader^.count:=value;
end;



procedure TOperatorMems.FreeItem(Num: Integer);
begin
  if GetSimpleID(GetName(Num)) <> -1 then RemoveIndex(Num);
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
    fStr.Write(data^,SizeOf(Toperatorsstruct))
  finally
    fStr.Free;
  end;
 
end;


procedure TOperatorMems.SetName(idn: Integer; value: string);
var j,i: integer;
begin
      begin
         j:=self.GetSimpleID(value);
         if (j>-1) then
           begin
           exit;
           end else
           begin
             for i:=0 to count-1 do
             if idn=items[i].id then
                 begin
                  items[i].name:=value;
                  exit;
                 end;
           end;
       end;
end;

procedure TOperatorMems.Linerize;
var i,j: integer;
begin
 i:=0;
 while i<count do
  begin
    if items[i].id<0 then
      begin
        j:=i;
         while j<count-1 do
           begin
           items[j].id:=items[j+1].id;
           items[j].name:=items[j+1].name;
           //items[j].host:=items[j+1].host;
           items[j].idgroup:=items[j+1].idgroup;
           items[j].accessLevel:=items[j+1].accessLevel;
           items[j].password:=items[j+1].password;
           items[j].UnUsed1:=items[j+1].UnUsed1;
           items[j].UnUsed2:=items[j+1].UnUsed2;
           inc(j);
           end;
        count:=count-1;
       end else
       inc(i);
   end;
   writeBaseToFile;
end;

procedure TOperatorMems.AddUser;
var i,j: integer;
begin
 i:=1;
 while self.GetSimpleID('NewUser'+inttostr(i))>-1 do inc(i);
 count:=count+1;
 items[count-1].id:=findNullId;
 self.SetName(items[count-1].id,'NewUser'+inttostr(i));
  AddIndex(Items[count-1].ID);
 writeBaseToFile;
end;


procedure TOperatorMems.RemoveUser(val: integer);
var i,j: integer;
begin

   begin
   for i:=0 to count-1 do
   if items[i].id=val then
         begin
         removeindex(val);
         items[i].id:=-1;
         Linerize;
         writeBaseToFile;
         exit;
         end;
   end
end;

function TOperatorMems.RenameUser(idN: integer; newname: string): boolean;
var i,j: integer;
begin
 result:=false;
 if self.GetSimpleID(newname)>-1 then exit;

   begin
   for i:=0 to count-1 do
   if items[i].id=idN then
      begin
          removeindex(idn);
         items[i].name:=newname;
          addindex(idn);
         result:=true;
         writeBaseToFile;
         exit;
      end;
   end
end;


function TOperatorMems.setAUser(idN: integer; al: integer): boolean;
var i,j: integer;
begin
 result:=false;
 
   begin
   for i:=0 to count-1 do
   if items[i].id=idN then
      begin
         items[i].accessLevel:=al;
          addindex(idn);
         result:=true;
         writeBaseToFile;
         exit;
      end;
   end
end;



function TOperatorMems.changepassUser(idN: integer; oldpassword, newpassword: string): boolean;
var i,j: integer;
begin
 result:=false;
 if (idn>-1) and (idn<1001) then
   begin
   for i:=0 to count-1 do
   if items[i].id=idN then
      begin
        if items[i].password=oldpassword then
          begin
            items[i].password:=newpassword;
            result:=true;
            writeBaseToFile;
            exit;
          end;
      end;
     end;
end;

function TOperatorMems.RegistUser(idN: integer; password: string): boolean;
var i,j: integer;
begin
 result:=false;
 if idn<0 then
   begin
    setaccessL(StartAcses);
    AccessLevel^:=StartAcses;
    OperatorName^ := 'Незарегистрирован';
    rtitems.oper.usCur:=-1;
    rtitems.setOperator('Незарегистрирован');
    SendMessageBroadcast(WM_IMMIUSERCHANGED, AccessLevel^, 0);
    exit;
   end;
 if (idn>-1) and (idn<1001) then
   begin
   for i:=0 to count-1 do
   if items[i].id=idN then
      begin
        if trim(uppercase(items[i].password))=trim(uppercase(password)) then
          begin
            try
            result:=true;
            usCur:=items[i].id;
            AccessLevel^:=items[i].accessLevel;
            CurrantKey^:=password;
            setaccessL(items[i].accessLevel);
            OperatorName^ := items[i].name;
            rtitems.setOperator(items[i].name);
            SendMessageBroadcast(WM_IMMIUSERCHANGED, AccessLevel^, 0);
            except
            end;
            exit;
          end;
      end;
     end;
end;

destructor TOperatorMems.Destroy;

var i: integer;
begin
     for i:=0 to IndexStringList.Count-1 do
      begin
        dispose(Pint(IndexStringList.Objects[i]));
       end;
     IndexStringList.Free;
     inherited;
end;

procedure TOperatorMems.setRegist(val: boolean);
begin
 if val then
   self.fPHeader.maxCount:=999 else
     self.fPHeader.maxCount:=0;
    writeBaseToFile;
end;

function TOperatorMems.getRegist: boolean;
begin
   result:=(self.fPHeader.maxCount>0);
end;

//******************* DebugMems **************************//
constructor TDebugMems.Create (MemName: string; aMaxCount: integer);
begin
  inherited CreateW(MemName,aMaxCount,sizeof(TDebugStruct)*(aMaxCount+100)+sizeof(THeaderStruct));
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
  firstLine : integer;
begin
  firstLine := ifthen(count = maxCount, curLine, 0);
  result := (firstNumber + number) mod (MaxCount - 1);
end;

function TDebugMems.GetItem (num: longInt):PTDebugStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TAlarmsMem индекс за границей! ' + inttostr(num));
  result := @(PTDebugs(Data)^.Items[ConvertNumber(num)]);
end;

function TDebugMems.GetItem_ (num: longInt):PTDebugStruct;
var j: integer;
begin
 // if (num >= count) or (num < 0) then raise Exception.Create('TAlarmsMem индекс за границей! ' + inttostr(num));
  if (curline-num-1)>-1 then j:=curline-num-1 else
  j:=count-(num-curline-1);
  result := @(PTDebugs(Data)^.Items[j]);
end;

function TDebugMems.AddItem(atime: TDateTime; mess: string; app: string; lev: byte): integer;
var
   i: integer;
begin
   try
   inherited LastNumber := LastNumber + 1;
    if count < maxCount then
    inherited Count := Count + 1;
   // else    try
    //  inherited  Count := Count;
  
    Items[curLine].number := lastNumber-1;
    Items[curLine].Time := aTime;
    if length(mess)>248 then mess:=leftstr(mess,249);
    Items[curLine].debugmessage := mess;
    if length(app)>48 then app:=leftstr(app,49);
    Items[curLine].application := app;
    Items[curLine].level := lev;
    result := curLine;
    inherited CurLine := convertNumber(CurLine + 1);
     except
     result := curLine;
    end;
end;



destructor TDebugMems.Destroy;
begin
    inherited;
end;








initialization
  rtItems := nil;
end.
