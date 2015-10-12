unit OPCHDAClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB, Math,
  Dialogs{,DdeMan}, ExtCtrls, StdCtrls, MemStructsU, Grids,DateUtils, Dm2UOPC,
  OPCCOMN,  OPCerror, OPCHDACallback, ComObj, ActiveX, ComCtrls, ConstDef,OPCHDA, OPCtypes;//,OPCDA;

  type TOPC_HDAItemState = ( his_Dead, // €чейка добавлена, но не инициалигирована
                             his_wait, //€чейка проинициализирована и ожидает врем€ дл€ чтени€
                             his_NeedRead , //€чейка должна быть прочитана при ближайшем опросе
                             his_Adding,  // €чейка добавл€етс€ в опрос
                             his_Reading,  // €чейка читаетс€
                             his_ErrAddHDA  // HDA сервер сообщил об ошибке дл€ данной €чейки

                              );

  type TItemPeriod = (ipNone{0}, ipSec{1}, ipMinute{2} , ip30Minute{3}, ipHour{4}, ip12Hour{5} , ipDay{6}, ipMonth{7}, ipYer{8});
  type TItemOPC_HDA   = record
      id: integer;
      rtid: integer;
      name: string;
      path: string;
      group: string;
      val: real;
      valid: integer;
         servHandle: OPCHANDLE;
      Qual: Word;
    //  changeActiv: boolean;
      serv: Pointer;
      MinEU: real;
      MaxEU: real;
      MinRaw: real;
      MaxRaw: real;
   //   activ: integer;
      count: integer;
      dataType: Word;
      ItPer: TItemPeriod;
      err: LongInt;
      time: TDateTime;
      isNew: boolean;
      isAdded: boolean;
      lastTime: _FILETIME;   // последнее данные
      lastTimeP: _FILETIME;   // последнее данные
      period: Integer;       // период отчета
      stateIT: TOPC_HDAItemState;
      lastR: boolean;
      historyPer: integer;
      readInTC: boolean;
      end;

type
TOPCConnectType_ = ( octDA_Sync, octDA_Async);
TOPCConnectType = set of TOPCConnectType_;

TOPCversion_ = ( _1, _2);
TOPCversionType = set of TOPCversion_;

TServerStatus = (osNone, osRunning ,osFailed, osNoconfig, osSuspended, osStatusTest);

TGroupStatus_ = (gsGroupAdded ,gsGroupAdding, gsGroupRemoving ,gsItemsAdded ,gsItemsAdding, gsItemsRemoving, gsReadTransact, gsCommandTransact, gsCancelTransact, gsReading);
TGroupStatus = set of TGroupStatus_;

TAnalizeFunction = procedure (server: TObject) of object;



PTItemOPC_HDA = ^TItemOPC_HDA;
TRiID_ItIDStub =record
    rtID: integer;
    itID: integer;
    ServHandle: integer;
    end;

  TItemOPC_HDAArray = array[1..1000000]of TItemOPC_HDA;
  PTItemOPC_HDAArray = ^TItemOPC_HDAArray;


type
TItemOPCHDAs = class(TList)
  private

                               // »м€ гоуппы
    m_hSItems : array of OPCHANDLE;            // ячейки клиента
    m_Num: Cardinal;                            //  ол-во €чейки клиента
    m_hCorrectSItems : array of OPCHANDLE;     // ячейки клиента, которые прин€л сервер
    m_NumCorrect: Cardinal;                     //  ол-во €чеек клиента, которые прин€л сервер
    m_hSItemsActiv : array of OPCHANDLE;       // јктивные €чейки клиента
    m_numActiv: Cardinal;                      //  ол-во н.а. €чеек клиента,
    m_hSItemsInActiv : array of OPCHANDLE;     // Ќеактивные €чейки клиента
    m_numInactiv: Cardinal;                    //  ол-во а. €чеек клиента,
    m_hSItemsRead : array of OPCHANDLE;         // ќпрашиваемые  €чейки клиента
    m_numRead: Cardinal;                        //  ол-во опрашиваемых €чеек клиента,
    m_NewItem: Cardinal;
    m_rtItemsId: array of TRiID_ItIDStub;
    m_rtItemsCount: integer;
    ItemDef  : array of POleStr;
    m_pIOPCHDA_SyncRead : IOPCHDA_SyncRead;          // Interface IOPCItemMgt
    m_pIOPCHDA_SyncUpdate  : IOPCHDA_SyncUpdate;
    m_pIOPCHDA_AsyncRead  : IOPCHDA_AsyncRead;           // Interface IOPCSyncIO
    m_pIOPCHDA_AsyncUpdate  : IOPCHDA_AsyncUpdate;       // Interface IOPCSyncIO2
    m_pIOPCHDA_DataCallback: IOPCHDA_DataCallback;
    m_pIOPCHDA_Playback: IOPCHDA_DataCallback;
    m_pIConnectionPoint: IConnectionPoint; // Connection Point for Callback
    m_pIConnectionPointContainer: IConnectionPointContainer;
    m_hSGroup: OPCHANDLE;

    m_CancelReadTransact: DWORD;
    m_CancelTransact: DWORD;
    temp_changactiv: boolean;
    timetransact: TdateTime;

    CallBack: TOPCHDADataCallback;
    m_Cookie : Longint;
    needActiv: boolean;
    connectionType: TOPCConnectType;
    ferr: integer;
    PredLastCommand : integer;
    frtitems: TanalogMems;
    dmodul: TDm2OPC;
      // getter/setter
    fAnalizeFunction: TAnalizeFunction;
    fAF: TAnalizeFunction;
    fgroup: string;
    fUpdateRate: DWORD;
    fPercentDeadBand: single;
    fRequestActive: boolean;
    fGroupStatus: TGroupStatus;

    function  getUpdateRate: DWORD;
    function  getPercentDeadBand: single;

       //incector override function
    procedure SetItem(i: integer; item: PTItemOPC_HDA);
    function  GetItem(i: integer): PTItemOPC_HDA;
    function  Add(item: PTItemOPC_HDA): integer;
    procedure  SetLastDate(item: PTItemOPC_HDA);

    procedure  WriteDataUnit(rtid: integer; rtname: string; tim: _FILETIME; val: real);
    function GetLastLog (ip: TItemPeriod; hp: integer; rtid: integer; var tms: TdateTime): boolean;
    procedure WriteUchet(Code:longInt; Data: real; tm: TDateTime);
        // convert func

    procedure AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
    procedure DelRtID;
    function  FindItIdByRTid(id: integer): integer;
    function  FindByParam (path: string; name: string): integer;
    function  prepareAddtoServer: boolean;
   // procedure setAnalizeFunction(val: TAnalizeFunction);
  //  procedure setAnalizeFunction_;

    procedure SetItemErr(id: integer; err: Cardinal);
    function getDBConnected: boolean;

  public
   canceled: boolean;
   m_ReadTransactHandle: DWORD;
   procedure  WriteData(id: integer; val: OPCHDA_ITEM);
   constructor create(group: string);
   destructor  destroy; override;
   procedure   addItem(path: string; name: string; group: string; num: integer);
 //  function  Setval(vals: OPCITEMSTATE): Boolean;
   procedure   ClearAllItems;
   procedure   ClearReadTransaction;
   function    GetReadTransaction: DWORD;
   function    GetTabCount: integer;
   property    items[i: integer]: PTItemOPC_HDA read getItem write setItem; default;
    property    GroupStatus: TGroupStatus read fGroupStatus write fGroupStatus;
   property    AnalizeFunction: TAnalizeFunction read fAnalizeFunction write fAnalizeFunction;
   property    Group: string read fGroup;
   property    UpdateRate: DWORD read getUpdateRate write fUpdateRate;
   property    PercentDeadBand: Single read getPercentDeadBand write fPercentDeadBand;
   property    DBConnected: boolean read getDBConnected;

  end;


TOPCHDAClientCell = class(TObject)
  private
    server: string;
    m_IOPCServer : IOPCHDA_Server;
    //m_IOPCServerU : IOPCServer;
    connected: boolean;
    ServerConnected: boolean;
    isNoAdvise: boolean;
    fversion: TOPCversionType;
    fStatus: TServerStatus;
    TA: integer;
    groupL: TObject;
    servslave: integer;
    fHost: string;
    fAnalizeFunction: TAnalizeFunction;
    function  ConversionType(val: real; dataType: Word): OLEVARIANT;
    function  ServerInit: boolean;           // инициализаци€ интефейса
    function  ServerUninit: boolean;         // деинициализаци€ интефейса
    function  GetInit: boolean;              // проверка инициализации базы клиета
    procedure SetVersion;                    // установка версииж
    function  GetVersion: TOPCversionType;   // запрос версии
    function  GetStatus: TServerStatus;      // чтение статуса
    procedure ResetStatus;                   // перезапросить статус
    procedure addClItem(path: string;              //добавить €чейки клиента
                        name: string; group:
                        string; num: integer;
                        activ: boolean);
    procedure ClearAllClItems;         // очистить  €чейки клиента
    function CancelReadASync: Boolean;
    function  GetItemCount(val: integer): integer;
    function  GetItemErrCount(val: integer): integer;
    function  GetGroupErr: integer;
    function  GetGroupName: string;

    procedure AddGroup;
    procedure AddItems;
    procedure AdviseCallback;
    procedure RemGroup;
    procedure RemGroups;
    procedure RemoveItems;
    procedure RemoveItemsAll;
    procedure UnadviseCallback;
    procedure ClearItemsErr;
    function  ChangeActiv: Boolean;
    function  ReadSync: Boolean;
    function  ReadASync: Boolean;
    function  Read: Boolean;
  public
   m_Status: OPCHDA_SERVERSTATUS;
   m_CurrentTime: PFileTimeArray;
   m_StartTime: PFileTimeArray;
   m_MajorVersion: WORD;
   m_MinorVersion: WORD;
   m_BuildNumber: WORD;
   m_MaxReturnValues: DWORD;
   m_StatusString: POleStr;
   m_VendorInfo: POleStr;
   constructor create(servn: string; slave: integer; hostn: string; noAdv: boolean; fTA: integer);
   destructor  destroy; override;
   function  AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
   procedure RemClGroup;
   function  isCurTread(serv: string; group: string; slave: integer; hostn: string):boolean;
   function  GetAnalizeObject: TObject;
   property AnalizeFunction: TAnalizeFunction read fAnalizeFunction write fAnalizeFunction;
   property Init: boolean read GetInit;
   property Status: TServerStatus read GetStatus;
   property Version: TOPCversionType read GetVersion;
   property ServerName: String read server;
   property GroupItemCount[i: integer]: integer read GetItemCount;
   property GroupItemErrCount[i: integer]: integer read GetItemErrCount;
   property GroupErr: integer read GetGroupErr;
   property GroupName: string read GetGroupName;
   property Host: string read fHost;

  end;





type
  TOPCHDAClient = class(TThread)
  private
    isAdding: boolean;
    server: TOPCHDAClientCell;
    nameserver: string;
    fPath: string;
    finitvar: boolean;
    frtitems: TAnalogMems;
    fStatus: TServerStatus;
    ItemNumb: integer;
    fAnalize: boolean;
    freadta: boolean;
    SI: boolean;
    TA,HR,MR: integer;
    procedure Read_;

    procedure AddGroup_;
    procedure RemGroup_;
    procedure AddItems_;
    procedure RemItems_;
    procedure ChangeActivs_;
    procedure GetStatus_;               // проверка статуса дл€ синхронизации
    procedure InitVar;
    procedure UnInitVar;
    function  SeverInit: boolean;
    procedure  SeverInit_;
    Function ReadMain: boolean;
    procedure ChangeActivsMain;
    procedure AnalizeMain;
    function getClientInit: boolean;    // чтение состо€ни€ инициализации переменных клиента
    function GetStatus: TServerStatus;  // проверка статуса
    function isOPC(val: string; var host: string; var grn: string): string;
  public
     procedure   AddItems;
     procedure   RemItems;
     procedure   AddItem(val: integer);
     function    AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
     procedure   RemClGroup;
     function    isCurTread(serv: string; group: string; slave: integer; host: string):boolean;
     function    getServer: Tobject;
     property    ClientInit: boolean read getClientInit;
     property    ServerStatus: TServerStatus read GetStatus;
     property    Analize: boolean read fAnalize write fAnalize;
     procedure   Execute; override;
     constructor Create(servn: string; path: string; slave: integer; host: string;fTA: integer; fHR: integer; fMR: integer; noAdv: boolean);
     destructor  Destroy;  override;
  end;


implementation





function GMTFTtoDT(tim: _FILETIME): TDateTime;   // GMT FT в DT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
   FileTimeToLocalFileTime(tim,tim1);
   FileTimeToSystemTime(tim1,temp);
   result:=SystemTimeToDateTime(temp);
end;

function FTtoDT(tim: _FILETIME): TDateTime;   // FT в DT
var  temp: TSystemTime;
begin
   FileTimeToSystemTime(tim,temp);
   result:=SystemTimeToDateTime(temp);
end;



function DTtoGMTFT(tim: TDateTime):_FILETIME;   // DT в GMT FT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
   DateTimeToSystemTime(tim,temp);
   SystemTimeToFileTime(temp,tim1);
   LocalFileTimeToFileTime(tim1,result);
end;




function DTtoFT(tim: TDateTime):_FILETIME;   // DT в FT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
   DateTimeToSystemTime(tim,temp);
   SystemTimeToFileTime(temp,tim1);
   result:=tim1;
end;

function compFT(tim1,tim2: _FILETIME):integer;   // DT в FT
//var  temp: TSystemTime;
  //   tim1: _FILETIME;
  var ff: double;
begin
   ff:=FTtoDT(tim2)-FTtoDT(tim1);
   if ff<0 then result:=-1;
   if ff=0 then result:=0;
   if ff>0 then result:=1;
end;

function DTtoOPCTM(tim: TDateTime):OPCHDA_TIME;   // DT в OPCTIME
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
     result.bString:=false;
     result.szTime:='';
     result.ftTime:=DTtoGMTFT(tim);
end;

function OPCTMtoDT(tim: OPCHDA_TIME):TDateTime;   //  OPCTIME to DT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
     result:=GMTFTtoDT(tim.ftTime);
end;

function NowGMTFT: _FILETIME;
begin
   result:=DTtoGMTFT(now);
end;

function NowFT: _FILETIME;
begin
   result:=DTtoFT(now);
end;

function NowOPCTM: OPCHDA_TIME;
begin
   result:=DTtoOPCTM(now);
end;

function FTtoStr(tim: _FILETIME):string;   // DT в GMT FT
var  temp: TSystemTime;
     tim1: _FILETIME;
begin
  result:=DateTimeTostr(FTtoDT(tim));
end;


function incSecond_OPCHDA(tim: OPCHDA_TIME; v: integer): OPCHDA_TIME;
var temp: TDateTime;
begin
   temp:=incSecond(OPCTMtoDT(tim),v);
   result:=DTtoOPCTM(temp);

end;

function GetNeedUpd(ip:  TItemPeriod; lasttime: _FileTime): boolean;
var tm: TDateTime;
    s1,s2: string;
begin
   tm:=GMTFTtoDT(lasttime);
   s1:=datetimetostr(tm);
   case ip of
   ipNone{0}: result:=(MinutesBetween(now,tm)>0);
   ipSec{1}: result:=(SecondsBetween(now,tm)>0);
   ipMinute{2}: result:=(MinutesBetween(now,tm)>0);
   ip30Minute{3}: result:=(MinutesBetween(now,tm)>29);
   ipHour{4}: result:=(HoursBetween(now,tm)>0);
   ip12Hour{5}: result:=(HoursBetween(now,tm)>11);
   ipDay{6}: result:=(DaysBetween(now,tm)>0);
   ipMonth{7}: result:=(MonthsBetween(now,tm)>0);
   ipYer{8}:  result:=(YearsBetween(now,tm)>0);
end;
end;

function GetNextTm(ip:  TItemPeriod; lasttime: _FileTime; var lst: boolean): _FILETIME;
var tm,tm2: TDateTime;
begin
   tm:=GMTFTtoDT(lasttime);
   case ip of
   ipNone{0}: tm2:=incYear(tm,10); //tm2:=incMinute(tm,20);
   ipSec{1}: tm2:=incSecond(tm,30);
   ipMinute{2}: tm2:=incMinute(tm,30);
   ip30Minute{3}: tm2:=incMinute(tm,30);
   ipHour{4}: tm2:=incHour(tm,30);
   ip12Hour{5}: tm2:=incHour(tm,30);
   ipDay{6}: tm2:=incDay(tm,30);
   ipMonth{7}: tm2:=incMonth(tm,30);
   ipYer{8}:  tm2:=incYear(tm,30);
   end;
   if (tm2>now) then
   begin
   tm2:=now;
   lst:=true;
   end else
   begin

   lst:=false;
   end;
   result:=DTtoGMTFT(tm2);
end;


function GetHistTm(ip:  TItemPeriod; hp: integer): TDateTime;
var tm,tm2: TDateTime;
begin
   tm:=now;
   case ip of
   ipNone{0}: {tm2:=incMinute(tm,-hp);}     tm2:=incYear(tm,-10);
   ipSec{1}: tm2:=incSecond(tm,-hp);
   ipMinute{2}: tm2:=incMinute(tm,-hp);
   ip30Minute{3}: tm2:=incMinute(tm,-hp);
   ipHour{4}: tm2:=incHour(tm,-hp);
   ip12Hour{5}: tm2:=incHour(tm,-hp);
   ipDay{6}: tm2:=incDay(tm,-hp);
   ipMonth{7}: tm2:=incMonth(tm,-hp);
   ipYer{8}:  tm2:=incYear(tm,-hp);
   end;
   result:=tm2;
end;

function NeedUpdte(tim: _FILETIME; modI: integer):boolean;
var  temp1,temp2: TSystemTime;
begin
    DateTimeToSystemTime(now,temp1);
    FileTimeToSystemTime(tim,temp2);
    result:=((SystemTimeToDateTime(temp1)-SystemTimeToDateTime(temp2))*3600*24 )>modI+15;
end;

function TItemOPCHDAs.GetLastLog (ip: TItemPeriod; hp: integer; rtid: integer; var tms: TdateTime): boolean;
var
   fn, s : string;
   per, cper: integer;
   h: string;
   strtseach, seachV,delt: TDateTime;
begin
  try
  result:=false;
  per:=round(rtitems[rtid].logTime);          //     тип отчета 7-мес€чн,6-дневнойб,4-часовой
  cper:=round(rtitems[rtid].MaxRaw);      //         глубина чтени€
  seachV:=now;
  if (cper<36) then cper:=36;
  if (per=REPORTTYPE_MONTH) then strtseach:=incMonth(seachV,-1*(cper+1)) else        //  начало чтени€
    begin
       if (per=REPORTTYPE_DAY) then strtseach:=incDay(seachV,-1*(cper+1)) else
       strtseach:=incHour(seachV,-1*(cper+1));
    end;

  if (per=REPORTTYPE_MONTH) then delt:=incYear(0,15) else                           // инкремент чтени€
    begin
       if (per=REPORTTYPE_DAY) then delt:=incYear(0,1) else
       delt:=incMonth(0,1);
    end;
   //  h:= DatetimeTostr(strtseach);
   //  h:= DatetimeTostr(seachV);

  strtseach:=min(strtseach,seachV-delt);

     //  h:= DatetimeTostr(strtseach);
    // h:= DatetimeTostr(seachV);

  strtseach:=strtseach-1;
  while(seachV>=strtseach) do
  begin
 // h:= DatetimeTostr(strtseach);
  //h:= DatetimeTostr(seachV);
  ///////////////////////////////////fn := datetoFileNameU(seachV,per);
 /////////////////////////////////// if  TableExist(fn, dmodul.Trend) then
  begin
    //dmodul..qTrend.Sql.Clear;
    //exit;
    //end;
  with dmodul.qTrend do
  begin
     s := 'select max(tm) from %s  where (cod = :cod)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
    SQL.Add(s);

    Parameters.parambyname('cod').value := rtid;
    try
     Open;
     if (RecordCount=0) then
       begin
       dmodul.qTrend.Sql.Clear;
     //  result:=true;
      // tim:=incYear(now,-10);
      // exit;
       end
      else
       begin
         first;
         if (not dmodul.qTrend.Fields[0].IsNull) then   begin
         tms:=dmodul.qTrend.Fields[0].AsDateTime;
      //  h:= dm2.qTrend.Fields[0].;
         h:= DatetimeTostr(tms);
         result:=true;
         exit;
          end;
         dmodul.qTrend.Sql.Clear;

       end;
    except

    end;
    end;
    end;
    dmodul.qTrend.Sql.Clear;
    seachV:=seachV-delt;
    end;

  except
  end;
    //dm2.qTrend.Sql.Clear;
   // seachV:=seachV-delt;
  //end;
  result:=true;
  tms:=GetHistTm(ip,hp);
 // tms:=incYear(now,-10);
  exit;





end;

procedure TItemOPCHDAs.WriteUchet(Code:longInt; Data: real; tm: TDateTime);
var
   fn, s : string;
   per: integer;
begin
   try

  per:=round(frtitems[Code].logTime);
  /////////////////////////////////////fn := datetoFileNameU(tm,per);
 //  fn:='_arch';
 ////////////////////////////////////// if not TableExist(fn, dmodul.Trend) then
  begin
    //create new trend table
   //  Sincronize;
   { dmodul.qTrend.Sql.Clear;
    dmodul.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, nm TEXT, period INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))');
    try
      dmodul.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Ќевозможно создать файл архива с именем ' + fn);
    end;
    dmodul.qTrend.Sql.Clear;
    dmodul.qTrend.Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD)');
    try
      dmodul.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Ќевозможно создать индекс дл€ архива ' + fn);
    end;
    dmodul.qTrend.Sql.Clear;     }
  ///////////////////////////////////////////////////  CreateUchTable(fn, fn, dmodul.Trend, dmodul.qTrend);
  end;

  with dmodul.qTrend do
  begin
     s := 'insert into %s (cod, nm, period, tm, val)' +
          ' values (:cod,  :nm, :period, :tm, :val)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
    SQL.Add('insert into ' + fn+
        ' values (:cod, :nm, :period,:tm, :Val)');
     Parameters.parambyname('cod').value := Code;
     Parameters.parambyname('nm').DataType:=ftString;
     Parameters.parambyname('nm').value := frtitems.GetName(Code);
     Parameters.parambyname('period').value := per;
     Parameters.parambyname('tm').DataType:=ftString;
    ////////////////////////////////// Parameters.parambyname('tm').value:=selfFormatDateTime(tm);
     Parameters.parambyname('Val').value := data;

    try
     ExecSQL;
    except

    end;
  end;
  except
  end;
    dmodul.qTrend.Sql.Clear;
end;


constructor TOPCHDAClientCell.create(servn: string; slave: integer; hostn: string; noAdv: boolean; fTA: integer);
var clItemList: TItemOPCHDAs;
begin
inherited create;
fHost:=hostn;
servslave:=slave;
server:=servn;
ServerConnected:=false;
fversion:=[];
if fTA<5 then TA:=5 else TA:=fTA;
fAnalizeFunction:=nil;
fstatus:=osNone;
isNoAdvise:=noAdv;
end;

destructor TOPCHDAClientCell.destroy;
var i: integer;
begin
RemClGroup;
inherited;
end;

function TOPCHDAClientCell.AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
var clItemList: TItemOPCHDAs;
begin
result:=nil;
if  (groupL=nil)  then
 begin
  clItemList:=TItemOPCHDAs.create(group);
  clItemList.fPercentDeadBand:=PD;
  clItemList.fUpdateRate:=UR;
  groupL:=clItemList;
  result:=clItemList;
 end else
  result:=groupL;
end;

procedure TOPCHDAClientCell.RemClGroup;
var clItemList: TItemOPCHDAs;
    i: integer;
begin
   groupl.Free;
end;



function  TOPCHDAClientCell.isCurTread(serv: string; group: string; slave: integer; hostn: string):boolean;
begin
 result:=false;
 if (trim(uppercase(serv))<>trim(uppercase(server))) then exit;
 if  (slave<>self.servslave) then exit;
 if (trim(uppercase(fhost))<>trim(uppercase(hostn))) then exit;
 result:=true;
end;

function  TOPCHDAClientCell.GetAnalizeObject: TObject;
var i: integer;
begin
  result:=nil;
  if assigned(AnalizeFunction) then
  begin
   result:=self;
   exit;
  end;

   if assigned(TItemOPCHDAs(groupl).AnalizeFunction) then
      begin
       result:=groupl;
       exit;
      end;
end;




function TOPCHDAClientCell.ServerInit: boolean;
var
    HRes : HRESULT;
    hostW: WideString;
    ff: IOPCHDA_SyncRead;
begin
  {implementation code here}
  //Showmessage('jjjjjjjjjjjjjjjjjj');
  if not ServerConnected then
  begin
    // Exception handling
    try
    // Create an OPC Server Object

    if host='' then
    begin
  //  m_IOPCServerU := CreateComObject(ProgIDToClassID(server)) as IOPCServer;
    m_IOPCServer := CreateComObject(ProgIDToClassID(server)) as IOPCHDA_Server
    end
    else
    begin
    hostW:= StringtoOlestr(host);
   // m_IOPCServerU := CreateRemoteComObject(hostW,ProgIDToClassID(server)) as IOPCServer;
    m_IOPCServer := CreateRemoteComObject(hostW,ProgIDToClassID(server)) as IOPCHDA_Server;
    end;
     ff:=m_IOPCServer as IOPCHDA_SyncRead;
//!!    HRes :=m_IOPCServer.GetStatus(m_Status);
    //Showmessage('jjjjjjjjjjjjjjjjjj');
    if not Failed(HRes) then
      begin

      end;                                                                               
    except
      m_IOPCServer := nil;
    end;
    if m_IOPCServer = nil then begin

    end;
  end;
   ServerConnected := TRUE;
end;




function TOPCHDAClientCell.ServerUnInit: boolean;
var i: integer;
begin

     RemGroup;


  if m_IOPCServer <> nil then begin

     m_IOPCServer := Nil;
  end;

  ServerConnected := FALSE;
end;

function TOPCHDAClientCell.GetInit: boolean;         // проверка инициализации
begin
  result:=(m_IOPCServer <> Nil);
  if not result then
     ServerInit;
end;


procedure TOPCHDAClientCell.SetVersion;                    // установка версииж
begin
//if (m_Status<>nil) then
  begin
  //  if (m_Status.wMinorVersion=1) then
      begin

      end;
   // if (m_Status.wMajorVersion=2) then
      begin

      end;
  end;
end;


function TOPCHDAClientCell.GetVersion: TOPCversionType;
begin
 result:=[];
  //if (m_Status<>nil) then
  begin
   // if (m_Status.wMinorVersion=1) then
      begin
   //      result:=result+[_1];
      end;
  //  if (m_Status.wMajorVersion=2) then
      begin
    //      result:=result+[_2];
      end;
  end;
end;

function TOPCHDAClientCell.GetStatus: TServerStatus;       // чтение статуса
var
    HRes : HRESULT;

begin
  if  fStatus=osNone then
    begin
      if  not Init then
      begin
        result:=fStatus;
        exit;
      end;
    end;
  if not Init then
    begin
       fStatus:=osNone;
       result:=fStatus;
       exit;
    end;

  if (fStatus=osNone) then
   begin

   Hres:=m_IOPCServer.GetHistorianStatus(m_Status,
   m_CurrentTime,
   m_StartTime,
   m_MajorVersion,
   m_MinorVersion,
   m_BuildNumber,
   m_MaxReturnValues,
   m_StatusString,
   m_VendorInfo);

  if failed(Hres) then
    begin
       fStatus:=osNone;
       result:=fStatus;
       exit;
    end;
    end;
    begin
      case m_Status of
       OPCHDA_UP: fStatus:=osRunning;
       OPCHDA_DOWN: fStatus:=osFailed;
       OPCHDA_INDETERMINATE: fStatus:=osRunning;
       else fStatus:=osNone;
       end;
       result:=fStatus;
    end;
   //  if assigned(m_Status) then CoTaskMemFree(m_Status);
end;

procedure TOPCHDAClientCell.ResetStatus;                   // перезапросить статус
begin
   fStatus:=osNone;
end;


procedure TOPCHDAClientCell.addClItem(path: string; name: string; group: string; num: integer; activ: boolean);
var numgroup: integer;
    clItemList: TItemOPCHDAs;
begin

   if (groupL<>nil) then
    begin
      clItemList:=TItemOPCHDAs(groupL);
      clItemList.addItem(path,name,group,num);
    end;
end;

procedure TOPCHDAClientCell.ClearAllClItems;
 var i: integer;
begin
  if (groupL<>nil) then TItemOPCHDAs(groupL).ClearAllItems;
end;




function  TOPCHDAClientCell.GetItemCount(val: integer): integer;
begin
    result:=0;
  if  groupL=nil then exit;
//  if (val<groupList.Count) then
    begin
       if (groupL<>nil) then
         begin
            result:=TItemOPCHDAs(groupL).count;
         end;
    end;
end;

function  TOPCHDAClientCell.GetItemErrCount(val: integer): integer;
var j: integer;
begin
  result:=0;
  if  groupL=nil then exit;
 // if (val<groupList.Count) then
    begin
       if (groupL<>nil) then
         begin
            for j:=0 to TItemOPCHDAs(groupL).count-1 do
           if  TItemOPCHDAs(groupL).items[j].err<>0 then result:=result+1;
         end;
    end;


end;

function  TOPCHDAClientCell.GetGroupErr: integer;
begin
      result:=0;
  if  groupL=nil then exit;
 // if (val<groupList.Count) then
    begin
       if (groupL<>nil) then
         begin
            result:=TItemOPCHDAs(groupL).ferr;
         end;
    end;
end;

function  TOPCHDAClientCell.GetGroupName: string;
begin
     result:='';
  if  groupL=nil then exit;
//  if (val<groupList.Count) then
    begin
       if (groupL<>nil) then
         begin
            result:=TItemOPCHDAs(groupL).fgroup;
         end;
    end;
end;

procedure TOPCHDAClientCell.RemGroups;
var i: integer;
begin

    RemGroup;
end;

procedure TOPCHDAClientCell.RemoveItemsAll;
var i: integer;
begin
 
    RemoveItems;
end;



procedure TOPCHDAClientCell.AddGroup;
var
  HRes : HRESULT;
  PercentDeadBand: Single;
  Active : BOOL;
  i: integer;
  UpdateRate, RevisedUpdateRate: DWORD;
  clItemList: TItemOPCHDAs;

begin
  clItemList:= TItemOPCHDAs(groupL);
  Active      := TRUE;
  UpdateRate  := clItemList.UpdateRate;
  PercentDeadBand:=clItemList.PercentDeadBand;
  if  not (fStatus=osRunning) then
  begin
     Exit;
  end;
 clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsGroupAdding];
 clItemList.fGroupStatus:=clItemList.fGroupStatus-[gsGroupAdding];
 clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsGroupAdded];
 clItemList.m_pIConnectionPointContainer:=m_IOPCServer as IConnectionPointContainer;
  if (clItemList.m_pIConnectionPointContainer<>nil) then
   begin
     HRes := clItemList.m_pIConnectionPointContainer.FindConnectionPoint(
                                        IOPCHDA_DataCallback,  // IID of the Callback Interface
                                         clItemList.m_pIConnectionPoint);    // Returned Connection Point
     if not Failed(HRes) then
          begin
                clItemList.connectionType:=clItemList.connectionType+[octDA_Sync];


          end;
   end;
  clItemList.m_pIOPCHDA_SyncRead:=m_IOPCServer as IOPCHDA_SyncRead;
  if (clItemList.m_pIOPCHDA_SyncRead<>nil) then
          clItemList.connectionType:=clItemList.connectionType+[octDA_Sync];

  clItemList.m_pIOPCHDA_AsyncRead:=m_IOPCServer as IOPCHDA_AsyncRead;
  if (clItemList.m_pIOPCHDA_AsyncRead<>nil) then
     if not self.isNoAdvise then
       clItemList.connectionType:=clItemList.connectionType+[octDA_ASync]
     else   clItemList.connectionType:=clItemList.connectionType-[octDA_ASync];


end;


procedure TOPCHDAClientCell.ClearItemsErr;
var
  clItemList: TItemOPCHDAs;
  maincount,i: integer;
  temp_hSItems : array of OPCHANDLE;
begin
 // if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCHDAs(groupL);
  setlength(temp_hSItems,clItemList.m_Num);
   maincount:=0;
   for i:=0 to clItemList.m_Num-1 do
    begin
      if (clItemList.items[i].err=S_OK) then
          begin
               temp_hSItems[maincount]:=clItemList.m_hSItems[i];
               maincount:=maincount+1;
          end;
     end;
   clItemList.m_NumCorrect:=maincount;
   setlength(clItemList.m_hCorrectSItems,clItemList.m_NumCorrect);
   for i:=0 to maincount-1 do
     clItemList.m_hCorrectSItems[i]:=temp_hSItems[i];
   setlength(temp_hSItems,0);
   if( clItemList.m_NumCorrect=0)  then
            clItemList.fGroupStatus:=clItemList.fGroupStatus-[gsItemsAdded];
end;


procedure TOPCHDAClientCell.AddItems;
var
  i : Integer;
  HRes     : HRESULT;
  Results  : PResultList;
  Errors   : PResultList;
  temp : POPCHANDLEARRAY;
  clItemList: TItemOPCHDAs;
  isErr: boolean;
begin

  clItemList:= TItemOPCHDAs(groupL);
  if not (fStatus=osRunning) or not (gsGroupAdded in clItemList.fGroupStatus) then
     Exit;
  clItemList.prepareAddtoServer;
  if clItemList.m_NewItem<1 then exit;
  isErr:=false;
  clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsItemsAdding];
  HRes := m_IOPCServer.GetItemHandles(
                            clItemList.m_NewItem,   // Number of Items to add
                            @clItemList.ItemDef[0], // OPCITEMDEF array
                            @clItemList.m_hSItems[0],  // OPCITEMRESULT array
                            temp,
                            Errors);  // Error array
  clItemList.fGroupStatus:=clItemList.fGroupStatus-[gsItemsAdding];
  if Failed(HRes) then
  begin
    clItemList.ferr:=HRes;
    Exit;
  end
  else begin
    clItemList.needActiv:=false;
    clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsItemsAdded];
    SetLength(clItemList.m_hSItems, clItemList.m_Num);
    for i := 0 to clItemList.m_Num-1 do begin
        if Failed(Errors[i]) then begin

            clItemList.m_hSItems[i] := 0;
            clItemList.items[i].servHandle:=0;
            clItemList.items[i].isNew:=false;
            clItemList.items[i].err:=Errors[i];
            isErr:=true;
            clItemList.items[i].isAdded:=false;
        end
        else begin
            clItemList.items[i].servHandle:=temp[i];
            clItemList.items[i].isNew:=false;
            clItemList.items[i].err:=S_OK;
            clItemList.items[i].isAdded:=true;
        end;

    end;
    ClearItemsErr;
  //  if not (gsAdvised in clItemList.GroupStatus) then
    if not isNoAdvise then AdviseCallback;//else
 //   clItemList.GroupStatus:=clItemList.GroupStatus-[gsAdvised];

   // CoTaskMemFree(Results);
   CoTaskMemFree(Errors);
  end;
  clItemList.ItemDef := Nil;
end;




procedure TOPCHDAClientCell.RemGroup;
var
  HRes : HRESULT;
  clItemList: TItemOPCHDAs;
begin
  //if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCHDAs(groupL);
  if not (fStatus=osRunning) or not
     (gsGroupAdded  in clItemList.fGroupStatus) then
      Exit;

  if clItemList.m_pIConnectionPoint <> nil then begin
  if not isNoAdvise then
      UnadviseCallback;
  end;

  
  if Failed(HRes) then begin
    Application.MessageBox('Unable to add a Group Object to the OPC Server Object', '', MB_OK);
    Exit;
  end;
  clItemList.fGroupStatus := clItemList.fGroupStatus-[gsGroupAdded];
  clItemList.m_hSItems := Nil;


end;


function TOPCHDAClientCell.Read: Boolean;
var

  clItemList: TItemOPCHDAs;
begin
  result:=false;
  clItemList:= TItemOPCHDAs(groupL);
  if (clItemList.m_NumCorrect=0) then exit;
  if octDA_ASync in clItemList.connectionType then
     result:=ReadASync
  else
     result:=ReadSync;
end;

function TOPCHDAClientCell.ReadSync: Boolean;
var
  HRes : HRESULT;
  ValueStart :  POPCHDA_ITEMARRAY;
  Errors: PResultList;
  clItemList: TItemOPCHDAs;
  i,g,j: integer;
  t1,t2: OPCHDA_TIME;
  numVal: DWORD;
  bond_: BOOL;
  mas: real;
  timstr: string;
  //ftArr: PFileTimeArray;
  reversL: TList;
  b1, b2: string;
  bb1: integer;
begin
  try
  result:=false;
  clItemList:= TItemOPCHDAs(groupL);
  if (clItemList.m_NumCorrect=0) then exit;
  SetLength(clItemList.m_hSItemsRead,clItemList.m_Num);
  //new(ftArr);
  reversL:=TList.Create;

  clItemList.m_numRead:=0;
  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].id>-1)) then
    begin
        if ((clItemList.items[i].stateIT=his_NeedRead) and (clItemList.items[i].isAdded)
         and (not clItemList.items[i].readInTC)) then
          begin
            clItemList.m_hSItemsRead[clItemList.m_numRead]:=clItemList.items[i].servHandle;
            t1.bString:=false;
            t1.szTime:='';
            t1.ftTime:=clItemList.items[i].lastTime;

            //b1:=FTtostr(t1.ftTime);

            t1:=incSecond_OPCHDA(t1,1);

           // b1:=FTtostr(t1.ftTime);
            t2.bString:=false;
            t2.szTime:='';
            t2.ftTime:=GetNextTm(clItemList.items[i].ItPer,clItemList.items[i].lastTime,clItemList.items[i].lastR);
           // b1:=FTtostr(t1.ftTime);
            clItemList.items[i].lastTimeP:=t2.ftTime;
            clItemList.items[i].stateIT:=his_Reading;
            clItemList.items[i].readInTC:=true;
            clItemList.m_numRead:=clItemList.m_numRead+1;
            reversL.Add(clItemList.items[i]);
            if clItemList.m_numRead>0 then break;
          end
    end;
  end;
  //t2.bString:=false;
 // t2.szTime:=nil;
 // t2.ftTime:=DTtoGMTFT(now);
   //t2:=incSecond_OPCHDA(t1,3600*24*30*12*3);
//  b1:=FTtostr(t2.ftTime);
 // bb1:=clItemList.items[i].rtid;
  numVal:=0;
  bond_:=false;
  if (clItemList.m_numRead<1) then
  begin
  for i:=0 to clItemList.count-1 do
    if ((clItemList.items[i].id>-1)) then
       begin
       clItemList.items[i].readInTC:=false;
       clItemList.items[i].err:=0;
       end;
  reversL.Destroy;
  exit;
  end;
  try
  result:=true;
  HRes := clItemList.m_pIOPCHDA_SyncRead.ReadRaw(t1,
                                                 t2,
                                                  numVal,
                                                  bond_,
                                                  clItemList.m_NumRead,
                                                  @clItemList.m_hSItemsRead[0],// Server Handles
                                                  ValueStart,   // Item Value
                                                  Errors);      //
   except
  end;
  SetLength(clItemList.m_hSItemsRead,0);
  if Failed (HRes) then begin
     for i:=0 to reversL.count-1 do
       begin
         PTITemOPC_HDA(reversL.items[i]).stateIT:=his_Wait;
        // PTITemOPC_HDA(reversL.items[i]).err:=-10;
       end;
    clItemList.ferr:=HRes;
    reversL.Destroy;
    Exit;
  end
  else
  begin

    for i:=0 to clItemList.m_NumRead-1 do
       begin
         if (ValueStart[i].hClient>0) then
         begin
         if Failed(Errors[i]) then begin

            clItemList.items[ValueStart[i].hClient-1].err:=Errors[i];
        end
        else begin
                 clItemList.WriteData(ValueStart[i].hClient-1,ValueStart[i]);

        end;
        end;

       end;
       //reversL.Destroy;
    CoTaskMemFree(Errors);
  end;
    CoTaskMemFree(ValueStart);
    reversL.Destroy;
    except
    end;
end;


function TOPCHDAClientCell.ReadASync: Boolean;
var
  HRes : HRESULT;
 // ValueStart :  POPCHDA_ITEMARRAY;
  Errors: PResultList;
  clItemList: TItemOPCHDAs;
  i,g,j: integer;
  t1,t2: OPCHDA_TIME;
  numVal: DWORD;
  bond_: BOOL;
  mas: real;
  timstr: string;
  //ftArr: PFileTimeArray;
  reversL: TList;
  b1, b2: string;
  bb1: integer;
  rtidtr: integer;
begin
  try
  result:=false;
  clItemList:= TItemOPCHDAs(groupL);
  if (clItemList.m_NumCorrect=0) then exit;
  if (clItemList.m_ReadTransactHandle>0) then
  begin
    if (secondsBetween(now,clItemList.timetransact)<TA) then
  exit else
   begin
     if (secondsBetween(now,clItemList.timetransact)>2*TA) then
       begin
          clItemList.canceled:=false;
          clItemList.m_ReadTransactHandle:=0;
          for i:=0 to clItemList.count-1 do
               if ((clItemList.items[i].id>-1)) then
                  begin
                   clItemList.items[i].readInTC:=false;
                   clItemList.items[i].err:=0;
                  end;
          exit;
       end;
     if clItemList.canceled then
       begin
          exit
       end
     else CancelReadASync;
   end
  end;
  SetLength(clItemList.m_hSItemsRead,clItemList.m_Num);
  //new(ftArr);
  reversL:=TList.Create;

  clItemList.m_numRead:=0;
  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].id>-1)) then
    begin
        if ((clItemList.items[i].stateIT=his_NeedRead) and (clItemList.items[i].isAdded)
          and (not clItemList.items[i].readInTC)) then
          begin
            rtidtr:=i+1;
            clItemList.m_hSItemsRead[clItemList.m_numRead]:=clItemList.items[i].servHandle;
            t1.bString:=false;
            t1.szTime:='';
            t1.ftTime:=clItemList.items[i].lastTime;

            //b1:=FTtostr(t1.ftTime);

            t1:=incSecond_OPCHDA(t1,-1);

           // b1:=FTtostr(t1.ftTime);
            t2.bString:=false;
            t2.szTime:='';
            t2.ftTime:=GetNextTm(clItemList.items[i].ItPer,clItemList.items[i].lastTime,clItemList.items[i].lastR);
            b1:=FTtostr(t1.ftTime);
             b1:=FTtostr(t2.ftTime);
            b2:=clItemList.items[i].name;
            clItemList.items[i].lastTimeP:=t2.ftTime;
            clItemList.items[i].stateIT:=his_Reading;
            clItemList.items[i].readInTC:=true;
            clItemList.m_numRead:=clItemList.m_numRead+1;
            reversL.Add(clItemList.items[i]);
            if clItemList.m_numRead>0 then break;
          end
    end;
  end;

  numVal:=0;
  bond_:=false;
  if (clItemList.m_numRead<1) then
  begin
  for i:=0 to clItemList.count-1 do
    if ((clItemList.items[i].id>-1)) then
       begin
       clItemList.items[i].readInTC:=false;
       clItemList.items[i].err:=0;
       clItemList.items[i].stateIT:=his_Wait;
       end;
  clItemList.canceled:=false;
  reversL.Destroy;
  clItemList.m_ReadTransactHandle:=0;
  clItemList.canceled:=false;
  sleep(5000);
  exit;
  end;
  result:=true;
  clItemList.m_ReadTransactHandle:=rtidtr;
   try
  HRes := clItemList.m_pIOPCHDA_AsyncRead.ReadRaw( clItemList.m_ReadTransactHandle,
                                                  t1,
                                                  t2,
                                                  numVal,
                                                  bond_,
                                                  clItemList.m_NumRead,
                                                  @clItemList.m_hSItemsRead[0],// Server Handles
                                                  clItemList.m_CancelReadTransact,
                                                  Errors);      //

  except
  end;
  SetLength(clItemList.m_hSItemsRead,0);
  if Failed (HRes) then begin
     for i:=0 to reversL.count-1 do
       begin
         PTITemOPC_HDA(reversL.items[i]).stateIT:=his_Wait;
         PTITemOPC_HDA(reversL.items[i]).err:=-10;

       end;
    clItemList.ferr:=HRes;
    reversL.Destroy;
    clItemList.m_ReadTransactHandle:=0;
    //sleep(40000);
    Exit;

  end
  else
  begin

    for i:=0 to clItemList.m_NumRead-1 do
       begin
         if Failed(Errors[i]) then begin
            clItemList.items[PTITemOPC_HDA(reversL.items[i]).id].err:=Errors[i];
            clItemList.m_ReadTransactHandle:=0;
            PTITemOPC_HDA(reversL.items[i]).stateIT:=his_Wait;
            PTITemOPC_HDA(reversL.items[i]).err:=-10;
        end
        else begin
             //    clItemList.WriteData(PTITemOPC_HDA(reversL.items[i]).id,ValueStart[i]);
             clItemList.timetransact:=now;
        end;


       end;
       //reversL.Destroy;
    CoTaskMemFree(Errors);
  end;
    //CoTaskMemFree(ValueStart);
    reversL.Destroy;
    except
   // ShowMessage('in read');
    end;
end;

function TOPCHDAClientCell.CancelReadASync: Boolean;
var
  HRes : HRESULT;
 // ValueStart :  POPCHDA_ITEMARRAY;
  Errors: PResultList;
  clItemList: TItemOPCHDAs;
  i,g,j: integer;
  t1,t2: OPCHDA_TIME;
  numVal: DWORD;
  bond_: BOOL;
  mas: real;
  timstr: string;
  //ftArr: PFileTimeArray;
  reversL: TList;
  b1, b2: string;
  bb1: integer;
  rtidtr: integer;
begin
  try
  clItemList:= TItemOPCHDAs(groupL);
  if (clItemList.m_NumCorrect=0) then exit;
   clItemList.canceled:=true;
  try
  HRes := clItemList.m_pIOPCHDA_AsyncRead.Cancel(clItemList.m_CancelReadTransact);      //
  except
  end;
  if Failed (HRes) then begin
    clItemList.canceled:=false;
    clItemList.m_ReadTransactHandle:=0;

    Exit;

  end
  else
  begin

    for i:=0 to clItemList.m_NumRead-1 do
       begin
         if Failed(Errors[i]) then begin
            clItemList.canceled:=false;
            clItemList.m_ReadTransactHandle:=0;

        end
        else begin
         // clItemList.canceled:=true;
        end;


       end;

    CoTaskMemFree(Errors);
  end;
  except
  end;
end;


function TOPCHDAClientCell.ConversionType(val: real; dataType: Word): OLEVARIANT;
begin
   result:=val;
end;

function TOPCHDAClientCell.ChangeActiv: Boolean;
var
  HRes : HRESULT;
  Errors: PResultList;
  clItemList: TItemOPCHDAs;
  isErr: boolean;
  i: integer;
begin

  clItemList:= TItemOPCHDAs(groupL);
  if ((not (gsItemsAdded in clItemList.fGroupStatus)) or
                        (not (gsGroupAdded in clItemList.fGroupStatus))) then exit;
  clItemList.m_numActiv:=0;
  clItemList.m_numInactiv:=0;
  SetLength(clItemList.m_hSItemsActiv,clItemList.m_Num);
  SetLength(clItemList.m_hSItemsInActiv,clItemList.m_Num);

  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].id>-1)) then
    begin
      if (clItemList.items[i].stateIT=his_Dead) then
      begin
         clItemList.SetLastDate(clItemList.items[i]);
      end;
     if (clItemList.items[i].stateIT=his_Wait) then
      begin
        if GetNeedUpd(clItemList.items[i].ItPer, clItemList.items[i].lastTime)
        then clItemList.items[i].stateIT:=his_NeedRead;
      end;
    end;
  end;

  if (clItemList.m_numActiv>0) then
  begin
  SetLength(clItemList.m_hSItemsActiv,0);
  if Failed (HRes) then begin
   clItemList.ferr:=HRes;
    SetLength(clItemList.m_hSItemsActiv,0);
    SetLength(clItemList.m_hSItemsInActiv,0);
  end
  else begin

    SetLength(clItemList.m_hSItemsActiv,0);
    SetLength(clItemList.m_hSItemsInActiv,0);
    clItemList.needActiv:=false;
   end;
   end;
end;




procedure TOPCHDAClientCell.RemoveItems;
var
  i : integer;
  HRes     : HRESULT;
  Errors   : PResultList;
  clItemList: TItemOPCHDAs;
begin
 // if (groupid>=self.groupL) then exit;
  clItemList:= TItemOPCHDAs(groupL);

  if not (fstatus=osRunning) or not (gsGroupAdded in clItemList.fGroupStatus) then
     Exit;
  HRes := m_IOPCServer.ReleaseItemHandles(clItemList.m_NumCorrect, //number of Items to remove
                                     @clItemList.m_hCorrectSItems[0], //
                                     Errors);  // Error Array

  if Failed(HRes) then
  begin

  end
  else begin

    end;

    CoTaskMemFree(Errors);


end;

// Procedure UnadviseCallback
procedure TOPCHDAClientCell.UnadviseCallback;
var
  HRes : HRESULT;
  clItemList: TItemOPCHDAs;
begin
 //  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCHDAs(groupL);
  if not (octDA_ASync in clItemList.connectionType) then
    begin
      clItemList.m_pIConnectionPoint:=nil;
      exit;
    end;

  if clItemList.m_pIConnectionPoint <> nil then begin
    HRes := clItemList.m_pIConnectionPoint.Unadvise(clItemList.m_Cookie);
     if Failed(HRes) then begin
         Application.MessageBox('Unadvise Connection for Callback FAILED', '', MB_OK);
     end
  end
   else
     //  clItemList.GroupStatus:=clItemList.GroupStatus-[gsAdvised];
  // delete Callback Object and Connection Point Interface
 // clItemList.m_pOPCDataCallback := Nil;
//  clItemList.m_pIConnectionPoint := Nil;

end;


// Procedure AdviseCallback
procedure TOPCHDAClientCell.AdviseCallback;
var
  HRes : HRESULT;
  clItemList: TItemOPCHDAs;
begin
  //exit;
  // if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCHDAs(groupL);

  clItemList.CallBack := TOPCHDADataCallback.Create(clItemList);

    HRes := clItemList.m_pIConnectionPoint.Advise(clItemList.CallBack as IUnknown ,
                                          clItemList.m_cookie);
    if Failed(HRes) then
      begin
        clItemList.connectionType:=clItemList.connectionType-[octDA_ASync];
        clItemList.CallBack:=nil;
      end else
        clItemList.connectionType:=clItemList.connectionType+[octDA_ASync];


end;


{----------TItemDDEs------------}

constructor TItemOPCHDAs.create(group: string);
begin
  inherited create;
  fgroup:=group;
  connectionType:=[];
  m_rtItemsCount:=0;
  needActiv:=true;
  m_ReadTransactHandle:=0;
  fRequestActive:=false;
  fGroupStatus:=[];
  temp_changactiv:=false;
  ferr:=0;
   CoInitFlags:= COINIT_MULTITHREADED;
   CoInitialize(nil);
  dmodul:=TDm2OPC.Create(nil);
end;




destructor TItemOPCHDAs.destroy;
begin
dmodul.Destroy;
inherited destroy;
end;

function TItemOPCHDAs.Add(item: PTItemOPC_HDA): integer;
var i: integer;
begin
 for i:=0 to count-1 do
  begin
    if items[i].id<0 then
      begin
        item.id:=i;
        Dispose(items[i]);
        Insert(i,item);
        result:=i;
        exit;
      end;
  end;
  item.id:=count;
  result:=inherited Add(item);
end;

procedure TItemOPCHDAs.addItem(path: string; name: string; group: string; num: integer);

var
    ddeRslt: LongInt;
    it: PTItemOPC_HDA;
    dest: array of integer;
    i,j: integer;
begin
      new(it);
      it.name:=name;
      it.id:=Count;
      it.path:=path;
      it.val:=0;
      it.rtid:=num;
      it.count:=1;
      it.dataType:=999;
      it.isNew:=true;
      it.err:=0;
      it.time:=0;
      it.Qual:=0;
      it.stateIT:=his_Dead;
      it.isAdded:=false;
      it.readInTC:=false;
    //  ipNone{0}, ipSec{1}), ipMinute{2} , ip30Minute{3}, ipHour{4}, ip12Hour{5} , ipDay{6}, ipMonth{7}, ipYer{8})
      case frtitems.Items[num].logTime of

       REPORTTYPE_HOUR:  it.ItPer:=ipHour;
      // 5:  it.ItPer:=ip12Hour;
       REPORTTYPE_DAY  :  it.ItPer:=ipDay;
       REPORTTYPE_MONTH:  it.ItPer:=ipMonth;

       else it.ItPer:=ipNone;
       end;
      if (frtitems.Items[num].logDB<5) then it.historyPer:=5 else
      it.historyPer:=round(frtitems.Items[num].logDB);
      SetLastDate(it);
      GroupStatus:=GroupStatus-[gsItemsAdded];
      begin
        i:=Add(it);
      end;
     AddRtIDandSort(num,count-1,0);

end;

procedure TItemOPCHDAs.ClearAllItems;
begin
  self.DelRtID;
  while (count>0) do
    if items[0]<>nil then
     begin
      dispose(items[0]);
      delete(0);
     end;
end;



function  TItemOPCHDAs.getUpdateRate: DWORD;
begin
  result:=0;
  if fUpdateRate>0 then result:=fUpdateRate;
end;

function  TItemOPCHDAs.getPercentDeadBand: single;
begin
   result:=0;
  if (fPercentDeadBand>0) and (fPercentDeadBand<=100) then result:=fPercentDeadBand;
end;




procedure TItemOPCHDAs.AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
var temp_rtidarray: array of TRiID_ItIDStub;
    i, temp_1,temp_2,temp_3, tempcount: integer;
    fl: boolean;
begin
   setLength(temp_rtidarray,m_rtItemsCount+1);
   tempcount:=0;
   for i:=0 to m_rtItemsCount-1 do
    begin
        if (m_rtItemsId[i].itId>-1) then
        begin
        temp_rtidarray[tempcount].rtID:=m_rtItemsId[i].rtID;
        temp_rtidarray[tempcount].itID:=m_rtItemsId[i].itId;
        temp_rtidarray[tempcount].ServHandle:=m_rtItemsId[i].ServHandle;
        tempcount:=tempcount+1;
        end;
    end;
     temp_rtidarray[tempcount].rtID:=rtID;
     temp_rtidarray[tempcount].itID:=itId;
     temp_rtidarray[tempcount].ServHandle:=servHdl;
    fl:=true;
    while ((fl)) do
      begin
         fl:=false;
         for i:=0 to tempcount-1 do
           if (temp_rtidarray[i].rtID>temp_rtidarray[i+1].rtId) then
             begin
                fl:=true;
                temp_1:=temp_rtidarray[i+1].rtID;
                temp_2:=temp_rtidarray[i+1].itID;
                temp_3:=temp_rtidarray[i+1].ServHandle;
                temp_rtidarray[i+1].rtID:=temp_rtidarray[i].rtID;
                temp_rtidarray[i+1].itID:=temp_rtidarray[i].itID;
                temp_rtidarray[i+1].ServHandle:=temp_rtidarray[i].ServHandle;
                temp_rtidarray[i].rtID:=temp_1;
                temp_rtidarray[i].itID:=temp_2;
                temp_rtidarray[i].ServHandle:=temp_3;
             end;
      end;
    m_rtItemsCount:=tempcount+1;
    setLength(m_rtItemsId,m_rtItemsCount);
     for i:=0 to m_rtItemsCount-1 do
    begin
        m_rtItemsId[i].rtID:=temp_rtidarray[i].rtID;
        m_rtItemsId[i].itId:=temp_rtidarray[i].itID;
        m_rtItemsId[i].ServHandle:=temp_rtidarray[i].ServHandle;
    end;
    setLength(temp_rtidarray,0);
end;

procedure TItemOPCHDAs.DelRtID;
begin
   setLength(m_rtItemsId,0);
   m_rtItemsCount:=0;
end;

function TItemOPCHDAs.FindItIdByRTid(id: integer): integer;
var
  i: integer;
  min, max: integer;
  temts: integer;
begin
  result := -1;
  min:=0;
  max:=m_rtItemsCount-1;
  if max<0 then exit;
  if (id>m_rtItemsId[max].rtID) or (id<m_rtItemsId[min].rtID) then exit;
  while ((result<0) and (min<max)) do
    begin
      if (m_rtItemsId[min].rtID=id) then result:=m_rtItemsId[min].itID else
         begin
         if (m_rtItemsId[max].rtID=id) then result:=m_rtItemsId[max].itID else
           begin
              temts:=trunc((max+min)/2);
              if (m_rtItemsId[temts].rtID>=id) then max:=temts else min:=temts;

           end;
         end;
    end;

end;


function TItemOPCHDAs.FindByParam (path: string; name: string): integer;
var
  i: integer;

begin
  result := -1;
  for i:=0 to count-1 do
  begin
      if ((trim(uppercase(items[i].path))=trim(uppercase(path))) and
                  (trim(items[i].name)=trim(name)))  then
                  begin
                     result:=i;
                     exit;
                  end;
  end;
end;

function TItemOPCHDAs.prepareAddtoServer: boolean;
var i: integer;
begin
  result:=true;
  SetLength(ItemDef, count);
   SetLength(m_hSItems, count);
  m_NewItem:=0;
  for i := 0 to count-1 do begin
   if items[i].isNew then
      ItemDef[m_NewItem]:=StringToOleStr(items[i].name);
      m_hSItems[m_NewItem]:=i+1;
      m_NewItem:=m_NewItem+1;
  end;
  self.m_Num:=Count;
end;






procedure TItemOPCHDAs.SetItemErr(id: integer; err: Cardinal);
var num,ids,i: integer;

begin
 num:=id-1;
 if ((num>-1) and (num<Count)) then
  begin
    items[num].err:=err;
  end;
end;

procedure TItemOPCHDAs.ClearReadTransaction;
begin
   self.m_ReadTransactHandle:=0;
end;




function TItemOPCHDAs.GetReadTransaction: DWORD;
begin
  result:= self.m_ReadTransactHandle;
end;




function TItemOPCHDAs.GetItem(i: integer): PTItemOPC_HDA;
begin
  result := inherited Items[i];
end;

function TItemOPCHDAs.getDBConnected: boolean;
begin
   try
   if (not dmodul.Trend.Connected) then dmodul.Trend.Connected:=true;

   except
   end;
   result:=dmodul.Trend.Connected;
end;

procedure TItemOPCHDAs.SetItem(i: integer; item: PTItemOPC_HDA);
begin
  Items[i] := item;
end;

procedure  TItemOPCHDAs.SetLastDate(item: PTItemOPC_HDA);
 var tims: TdateTime;
     b: string;
begin
  if ((DBConnected) and (GetLastLog (item.ItPer, item.historyPer, item.rtid,tims))) then
  begin
  item.lastTime:=DTtoGMTFT(tims);
  item.stateIT:=his_Wait;  // активаци€ €чейки
  b:=FTtoStr(item.lastTime);
  b:=FTtoStr(item.lastTime);
  end;

end;

procedure  TItemOPCHDAs.WriteData(id: integer; val: OPCHDA_ITEM);
var j: integer;

    b: string;
begin
   if ((not (Items[id].lastR)) and (Val.dwCount=0)) then
        begin
        Items[id].lastTime:=Items[id].lastTimeP;
        items[id].stateIT:=his_Wait;
        exit;
        end;

   for j:=0 to Val.dwCount-1 do
              begin
                try
                if CompFt(Items[id].lastTime,Val.pftTimeStamps[j])>0 then
                begin
                WriteDataUnit(Items[id].rtid, frtitems.GetName(Items[id].rtid) , Val.pftTimeStamps[j],Val.pvDataValues[j]);
                Items[id].lastTime:=Val.pftTimeStamps[j];
                end;
                b:=FTtostr(Val.pftTimeStamps[j]);
                b:=FTtostr(Val.pftTimeStamps[j]);
                except
                end;

              end;
              if ((not (Items[id].lastR))) then Items[id].lastTime:=Items[id].lastTimeP;
        items[id].stateIT:=his_Wait;
end;

procedure  TItemOPCHDAs.WriteDataUnit(rtid: integer; rtname: string; tim: _FILETIME; val: real);
begin
    WriteUchet( rtid, val , GMTFTtoDT(tim));
end;

function TItemOPCHDAs.GetTabCount: integer;
var i: integer;
begin
   result:=0;
   for i:=0 to count-1 do result:=result+items[i].count;
end;


constructor TOPCHDAClient.Create(servn: string; path: string; slave: integer; host: string;fTA: integer; fHR: integer; fMR: integer; noAdv: boolean);
begin
  fAnalize:=false;
  isAdding:=false;
  nameserver:=servn;
  fpath:=path;
  finitvar:=false;
  TA:=fTA;
  if fHR<5 then HR:=5 else HR:=fHR;
  if fMR>50 then MR:=50 else MR:=fMR;
  inherited Create(false);
  server:=TOPCHDAClientCell.create(servn,slave,host, noadv, fTA);
  
end;

destructor TOPCHDAClient.Destroy;
begin
  server.Free;
  inherited;
end;

procedure TOPCHDAClient.Read_;
begin
   freadta:=server.Read;
end;



procedure TOPCHDAClient.AddGroup_;
begin
   server.addGroup;
end;

procedure TOPCHDAClient.AddItems_;
begin
   server.addItems;
end;

procedure TOPCHDAClient.RemGroup_;
begin
   server.RemGroup;
end;

procedure TOPCHDAClient.RemItems_;
begin
   server.RemoveItems;
end;

procedure TOPCHDAClient.ChangeActivs_;
var i: integer;
begin
  server.ChangeActiv;
end;


Function TOPCHDAClient.ReadMain: boolean;
var i: integer;
begin

   Synchronize(Read_);
   result:=freadta;
end;

procedure TOPCHDAClient.ChangeActivsMain;
var i: integer;
begin
   Synchronize(ChangeActivs_);
end;


procedure TOPCHDAClient.AddItems;
var  serv,group,group1,opcit,hostname: string;
     i,slave,j: integer;

begin
  try
  isAdding:=true;
  for i:=0 to frtItems.Count-1 do
    if (frtItems.Items[i].id>-1) then
      begin
        serv:=isOPC(frtItems.TegGroups.GetAppbyNum(frtItems[i].GroupNum),hostname,group1);
          group:='';
        for j := 0 to frtItems.TegGroups.count - 1 do
           if ((frtItems.TegGroups.items[j].Num) = (frtItems[i].GroupNum)) then
             begin
              group := frtItems.TegGroups.Items[j].Name;
              break;
             end;
        //group:=frtItems.TegGroups.GetTopicbyNum(frtItems[i].GroupNum);
        slave:=frtItems.TegGroups.GetSlavebyNum(frtItems[i].GroupNum);

        if (serv<>'') and (trim(uppercase(serv))=trim(uppercase(self.nameserver))) then
          begin
             if (slave=self.server.servslave) then
             if (hostname=server.host) then
                begin
                  opcit:=frtItems.GetDDEItem(i);

                     if ((opcit<>'') {and (iscorrect(ddit))}) then
                       server.addClItem('',opcit,group,i,(frtItems.Items[i].refCount>0));
                end;
           end;
      end;
  finally
  isAdding:=false;
  end;
end;

procedure TOPCHDAClient.AddItem(val: integer);
var  serv,group,group1,opcit,hostname: string;
     i,slave,j, gn: integer;

begin
  try
  isAdding:=true;
  i:=val;
  if (i<frtItems.count) then
    if (frtItems.Items[i].id>-1) then
      begin
        serv:=isOPC(frtItems.TegGroups.GetAppbyNum(frtItems[i].GroupNum),hostname,group1);
        group:='';
        for j := 0 to frtItems.TegGroups.count - 1 do
           if ((frtItems.TegGroups.items[j].Num) = (frtItems[i].GroupNum)) then
             begin
              group := frtItems.TegGroups.Items[j].Name;
              break;
             end;
        group:=frtItems.TegGroups.GetTopicbyNum(frtItems[i].GroupNum);
        slave:=frtItems.TegGroups.GetSlavebyNum(rtItems[i].GroupNum);

        if (serv<>'') and (trim(uppercase(serv))=trim(uppercase(self.nameserver))) then
          begin
             if (slave=self.server.servslave) then
             if (hostname=server.host) then
                begin
                  opcit:=frtItems.GetDDEItem(i);

                     if ((opcit<>'') {and (iscorrect(ddit))}) then
                       server.addClItem('',opcit,group,i,(frtItems.Items[i].refCount>0));
                end;
           end;

      end;
  finally
  isAdding:=false;
  end;
end;


function TOPCHDAClient.isOPC(val: string; var host: string; var grn: string): string;
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

var valUp,tempval: string;
    i: integer;
begin
   result:='';
   host:='';
   grn:='';
   result:=getinVstring(val,'OPC_HDA');
   if ((result<>'') and (val<>'')) then
     begin
       tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
         tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);
       if (length(tempval)>6) and (uppercase(copy(tempval,1,6))='GROUP:')
               then grn:=copy(tempval,7,length(tempval)-6);
     end;
end;

procedure TOPCHDAClient.RemItems;
var  serv,group,opcit: string;
     i,slave: integer;
begin
 server.ClearAllClItems;
end;

function  TOPCHDAClient.GetStatus: TServerStatus;  // проверка статуса
var i: integer;
begin
  result:=fstatus;
  if   (gsReading in TItemOPCHDAs(server.groupL).groupstatus) then exit;
  Synchronize(GetStatus_);
  result:=fstatus;
end;

procedure  TOPCHDAClient.GetStatus_;  // проверка статуса
begin
  fstatus:=osNone;

  if (server<>nil) then
    fstatus:=server.status;
end;



function  TOPCHDAClient.isCurTread(serv: string; group: string; slave: integer; host: string):boolean;
begin
result:=server.isCurTread(serv, group, slave,host);
end;



function TOPCHDAClient.getServer: Tobject;
begin
  result:=server;
end;


function TOPCHDAClient.AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
begin
 result:=server.AddClGroup(group, slave, PD, UR);
end;

procedure TOPCHDAClient.RemClGroup;
begin
 server.RemClGroup;
end;



procedure TOPCHDAClient.Execute;
begin
while not Terminated do
  try
  if ClientInit then
     begin
      if (ServerStatus=osRunning) then
        begin
         if SeverInit then
            begin
            //
              if (SecondOfTheMinute(Now)>MR) and (MinuteofTheHour(now)<HR) then
              begin
               ChangeActivsMain;
               if not ReadMain then
               begin
                try
                Synchronize(AnalizeMain);
                sleep (2000);
                except
                end
               end else
                sleep (2000);
              end else
               try
                Synchronize(AnalizeMain);
                sleep (2000);
                except
                end
              end
          else
            begin
              sleep (1000);
            end;
         //if Analize then
         try
         Synchronize(AnalizeMain);
         except
         end;
        end
      else
        begin
         sleep (1000);
        end;


     end;
     except
     end;
end;



procedure TOPCHDAClient.AnalizeMain;
var Analizeobj: TObject;
begin
   Analizeobj:=server.GetAnalizeObject;
   if (Analizeobj<>nil) then
     begin
      if (Analizeobj is TOPCHDAClientCell) then  TOPCHDAClientCell(Analizeobj).AnalizeFunction(Analizeobj) else
        if (Analizeobj is TItemOPCHDAs) then  TItemOPCHDAs(Analizeobj).AnalizeFunction(Analizeobj);
     end;
end;

procedure TOPCHDAClient.InitVar;
var i: integer;
begin
  if not finitvar then
  begin
  frtitems:=TAnalogMems.Create(fPath);
    begin
      TItemOPCHDAs(server.groupL).frtitems:=frtitems;
      TItemOPCHDAs(server.groupL).PredLastCommand:=frtitems.command.CurLine;
    end;
  AddItems;
  finitvar:=true;
  end;
end;

procedure TOPCHDAClient.UnInitVar;
var i: integer;
begin
 RemItems;;
  TItemOPCHDAs(server.groupL).frtitems:=nil;
  frtitems.free;
  finitvar:=false;
end;

function TOPCHDAClient.SeverInit: boolean;
var i: integer;
begin
     Synchronize(SeverInit_);
     result:=SI;

end;

procedure TOPCHDAClient.SeverInit_;
var i: integer;
begin
     SI:=false;

       if (server.groupL<>nil) then
         begin
            if not (gsGroupAdded in TItemOPCHDAs(server.groupL).fGroupStatus) then
              begin
                SynChronize(AddGroup_);
              end;
              if (gsGroupAdded in TItemOPCHDAs(server.groupL).fGroupStatus) then
                  begin
                     if not (gsItemsAdded in TItemOPCHDAs(server.groupL).fGroupStatus) then
                       begin

                            SynChronize(AddItems_);
                       end;
                     if  (gsGroupAdded in TItemOPCHDAs(server.groupL).fGroupStatus)  then
                            SI:=true;
                  end;

         end;

end;


function TOPCHDAClient.getClientInit: boolean;   // чтение состо€ни€ инициализации переменных
begin
 result:=false;
 if not finitvar then
  begin
   Synchronize(InitVar);
  end;
  if ((server<>nil) and (server.groupL<>nil)) then
  result:=finitvar and TItemOPCHDAs(server.groupL).DBConnected;
end;




end.
