unit OPCClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs{,DdeMan}, ExtCtrls, StdCtrls, MemStructsU, Grids,OPCDA,
  OPCCOMN,  OPCerror, OPCCallback, ComObj, ActiveX, ComCtrls, ConstDef,OPCHDA;


  type TItemOPC   = record
      id: integer;
      rtid: array  of integer;
      name: string;
      path: string;
      group: string;
      val: real;
      valid: integer;
      //idDDE: integer;
      dat: OPCITEMSTATE;
      servHandle: OPCHANDLE;
      Qual: Word;
      changeActiv: boolean;
      serv: Pointer;
      MinEU: real;
      MaxEU: real;
      MinRaw: real;
      MaxRaw: real;
      activ: integer;
      count: integer;
      dataType: Word;
      CommandValue: real;
      WRHDL: Cardinal;
      commandActiv: boolean;
      Executed: boolean;
      err: LongInt;
      time: TDateTime;
      isNew: boolean;
      typ_: integer; // -1001 дискретный -1002 аналоговый целочисленный -1003 аналоговый float
      end;

type
TOPCConnectType_ = ( octAdvise2, octAsync2, octSync, octAsync);
TOPCConnectType = set of TOPCConnectType_;

TOPCversion_ = ( _1, _2);
TOPCversionType = set of TOPCversion_;

TServerStatus = (osNone, osRunning ,osFailed, osNoconfig, osSuspended, osStatusTest);

TGroupStatus_ = (gsGroupAdded ,gsGroupAdding, gsGroupRemoving ,gsItemsAdded ,gsItemsAdding, gsItemsRemoving, gsReadTransact, gsCommandTransact, gsCancelTransact, gsReading, gsWriting, gsAdvised);
TGroupStatus = set of TGroupStatus_;

TAnalizeFunction = procedure (server: TObject) of object;

PTItemOPC = ^TItemOPC;
TRiID_ItIDStub =record
    rtID: integer;
    itID: integer;
    ServHandle: integer;
    end;

  TItemOPCArray = array[1..1000000]of TItemOPC;
  PTItemOPCArray = ^TItemOPCArray;


type
TItemOPCs = class(TList)
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
    ItemDef  : array of OPCITEMDEF;

    m_pIOPCItemMgt : IOPCItemMgt;          // Interface IOPCItemMgt
    m_pIOPCSyncIO  : IOPCSyncIO;           // Interface IOPCSyncIO
    m_pIOPCAsyncIO2  : IOPCAsyncIO2;       // Interface IOPCSyncIO2
    m_pIOPCAsyncIO  : IOPCAsyncIO;         //  IOPCAsyncIO
    m_pOPCDataCallback : IOPCDataCallback; // Callback Object
    m_pIConnectionPoint: IConnectionPoint; // Connection Point for Callback
    m_pIConnectionPointContainer: IConnectionPointContainer;

    m_hSGroup: OPCHANDLE;
    m_ReadTransactHandle: DWORD;
    m_CommandTransactHandle: DWORD;
    m_CancelReadTransact: DWORD;
    m_CancelTransact: DWORD;


    temp_changactiv: boolean;
    ComandExecuted: boolean;
    CallBack: IOPCDataCallBack;
    m_Cookie : Longint;
    needActiv: boolean;
    connectionType: TOPCConnectType;
    isCommand: boolean;
    ferr: integer;
    PredLastCommand : integer;
    frtitems: TanalogMems;

      // getter/setter
    fAnalizeFunction: TAnalizeFunction;
    fgroup: string;
    fUpdateRate: DWORD;
    fPercentDeadBand: single;
    fRequestActive: boolean;
    fGroupStatus: TGroupStatus;
    procedure setRequestActive(val: boolean);
    function  getUpdateRate: DWORD;
    function  getPercentDeadBand: single;

       //incector override function
    procedure SetItem(i: integer; item: PTItemOPC);
    function  GetItem(i: integer): PTItemOPC;
    function  Add(item: PTItemOPC): integer;


        // convert func
    function  CovertValtoreal(val: Olevariant; dattype: word; var outs: real): boolean;
    function  CovertrealtoVal(val: real; dattype: word; var outs: Olevariant): boolean;

    procedure AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
    procedure DelRtID;
    function  FindItIdByRTid(id: integer): integer;
    function  FindByParam (path: string; name: string): integer;
    function  prepareCommand: boolean;
    function  prepareAddtoServer: boolean;
    function  RefreshActivState: boolean;
    procedure setActivById(val: integer);
    procedure setInActivById(val: integer);
    procedure SetItemErr(id: integer; err: Cardinal);


  public

   constructor create(group: string);
   destructor  destroy; override;


   procedure   addItem(path: string; name: string; group: string; num: integer; activ: boolean; typ: integer);

   function  Setval(vals: OPCITEMSTATE): Boolean;

   procedure   ClearAllItems;
   procedure   ClearReadTransaction;
   procedure   ClearCommandTransaction;
   function    GetReadTransaction: DWORD;
   function    GetCommandTransaction: DWORD;
   procedure   setCommandTransaction;
   function    GetTabCount: integer;

   property    items[i: integer]: PTItemOPC read getItem write setItem; default;
   property    RequestActive: boolean read fRequestActive write setRequestActive;
   property    GroupStatus: TGroupStatus read fGroupStatus write fGroupStatus;
   property    AnalizeFunction: TAnalizeFunction read fAnalizeFunction write fAnalizeFunction;
   property    Group: string read fGroup;
   property    UpdateRate: DWORD read getUpdateRate write fUpdateRate;
   property    PercentDeadBand: Single read getPercentDeadBand write fPercentDeadBand;


  end;


TOPCClientCell = class(TObject)
  private
    server: string;
    m_IOPCServer : IOPCServer;
    connected: boolean;
    ServerConnected: boolean;
    isNoAdvise: boolean;
    fversion: TOPCversionType;
    fStatus: TServerStatus;
    groupList: TStringList;
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
                        activ: boolean;typ: integer);
    procedure ClearAllClItems;         // очистить  €чейки клиента
    function  GetGroupCount: integer;
    function  GetItemCount(val: integer): integer;
    function  GetItemErrCount(val: integer): integer;
    function  GetGroupErr(val: integer): integer;
    function  GetGroupName(val: integer): string;

    procedure AddGroup(groupid: integer);
    procedure AddItems(groupid: integer);
    procedure AdviseCallback(groupid: integer);
    procedure RemGroup( groupid: integer);
    procedure RemGroups;
    procedure RemoveItems( groupid: integer);
    procedure RemoveItemsAll;
    procedure UnadviseCallback(groupid: integer);
    procedure ClearItemsErr(groupid: integer);
    function  ChangeActiv(groupid: integer): Boolean;
    function  ReadSync(groupid: integer): Boolean;
    function  WriteSync(groupid: integer): Boolean;
    function  ReadASync2(groupid: integer): Boolean;
    function  PrepareCommand( groupid: integer): boolean;
    function  WriteASync2(groupid: integer): Boolean;
  public
   m_Status: POPCSERVERSTATUS;
   constructor create(servn: string; slave: integer; hostn: string; noAdv: boolean);
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
   property GroupCount: integer read GetGroupCount;
   property GroupItemCount[i: integer]: integer read GetItemCount;
   property GroupItemErrCount[i: integer]: integer read GetItemErrCount;
   property GroupErr[i: integer]: integer read GetGroupErr;
   property GroupName[i: integer]: string read GetGroupName;
   property Host: string read fHost;

  end;





type
  TOPCClient = class(TThread)
  private
    isAdding: boolean;
    server: TOPCClientCell;
    nameserver: string;
    fPath: string;
    finitvar: boolean;
    fActivgr: integer;
    frtitems: TAnalogMems;
    fStatus: TServerStatus;
    ItemNumb: integer;
    fAnalize: boolean;

    procedure ReadASync2_;
    procedure WriteASync2_;
    procedure ReadSync_;
    procedure WriteSync_;
    procedure AddGroup_;
    procedure RemGroup_;

    procedure AddItems_;
    procedure RemItems_;

    procedure ChangeActivs_;
    procedure GetStatus_;               // проверка статуса дл€ синхронизации
    procedure InitVar;
    procedure UnInitVar;
    function  SeverInit: boolean;

    procedure ReadMain;
    procedure WriteMain;

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

     constructor Create(servn: string; path: string; slave: integer; host: string; noAdv: boolean);
     destructor  Destroy;  override;
  end;


implementation

function getvalbt(val: single; typ: integer): OLEVARIANT;
var temp: Smallint;
begin
   case typ of
    TYPE_DISCRET: begin if (val>0) then temp:=1 else
      temp:=0;
      result:=temp;
    end;
    TYPE_INTEGER: begin
      temp:=round(val);
      result:=temp;
           end
    else result:=val;
   end;
end;


function getconvcomm(val: single; mineu_,maxeu_: single;minraw_,maxraw_: single): single;
var raw_: single;
    eu_: single;
begin
  result:=val;

  if (mineu_>maxeu_) then
    begin
      eu_:=mineu_;
      mineu_:=maxeu_;
      maxeu_:=eu_
    end;
  if (minraw_>maxraw_) then
    begin
      raw_:=minraw_;
      minraw_:=maxraw_;
      maxraw_:=raw_
    end;
  eu_:=maxeu_-mineu_;
  raw_:=maxraw_-minraw_;

  if (eu_=0) then exit;
  if (raw_=0) then exit;
  if val>maxeu_ then val:=maxeu_;
  if val<mineu_ then val:=mineu_;
  result:=minraw_+(val-mineu_)/(eu_)*(1.0* raw_)
end;

constructor TOPCClientCell.create(servn: string; slave: integer; hostn: string; noAdv: boolean);
var clItemList: TItemOPCs;
begin
inherited create;
groupList:=TStringList.Create;
fHost:=hostn;
servslave:=slave;
server:=servn;
ServerConnected:=false;
fversion:=[];
fAnalizeFunction:=nil;
fstatus:=osNone;
isNoAdvise:=noAdv;
end;

destructor TOPCClientCell.destroy;
var i: integer;
begin
RemClGroup;
groupList.Free;
inherited;
end;

function TOPCClientCell.AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
var clItemList: TItemOPCs;
begin
result:=nil;
if  (groupList.Count=0) or ((slave=servslave)  and (groupList.IndexOf(trim(group))<0)) then
 begin
  clItemList:=TItemOPCs.create(group);
  clItemList.fPercentDeadBand:=PD;
  clItemList.fUpdateRate:=UR;
  groupList.AddObject(trim(group),clItemList);
  result:=clItemList;
 end else
  result:=groupList.Objects[groupList.IndexOf(trim(group))];
end;

procedure TOPCClientCell.RemClGroup;
var clItemList: TItemOPCs;
    i: integer;
begin
for i:=0 to self.groupList.Count-1 do
   (grouplist.Objects[i]).Free;
end;



function  TOPCClientCell.isCurTread(serv: string; group: string; slave: integer; hostn: string):boolean;
begin
 result:=false;
 if (trim(uppercase(serv))<>trim(uppercase(server))) then exit;
 if  (slave<>self.servslave) then exit;
 if (trim(uppercase(fhost))<>trim(uppercase(hostn))) then exit;
 result:=true;
end;

function  TOPCClientCell.GetAnalizeObject: TObject;
var i: integer;
begin
  result:=nil;
  if assigned(AnalizeFunction) then
  begin
   result:=self;
   exit;
  end;
  for i:=0 to self.groupList.Count-1 do
   if assigned(TItemOPCs(grouplist.Objects[i]).AnalizeFunction) then
      begin
       result:=grouplist.Objects[i];
       exit;
      end;
end;





function TOPCClientCell.ServerInit: boolean;
var
    HRes : HRESULT;
    fff:  IOPCHDA_Server;
    hostW: WideString;
begin
  {implementation code here}
  if not ServerConnected then
  begin
    // Exception handling
    try
    // Create an OPC Server Object

    if host='' then
    m_IOPCServer := CreateComObject(ProgIDToClassID(server)) as IOPCServer else
    begin
    hostW:= StringtoOlestr(host);
    m_IOPCServer := CreateRemoteComObject(hostW,ProgIDToClassID(server)) as IOPCServer;
    end;
 //   fff:=CreateComObject(ProgIDToClassID('Logika.SpserverOPC.Hda')) as  IOPCHDA_Server;
    HRes :=m_IOPCServer.GetStatus(m_Status);
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


function TOPCClientCell.ServerUnInit: boolean;
var i: integer;
begin
//if info.m_pIOPCItemMgt <> nil then begin
     // Remove Group
    for i:=0 to self.groupList.Count-1 do
     RemGroup(i);
//  end;

  if m_IOPCServer <> nil then begin
    // Release OPC Server Object
     m_IOPCServer := Nil;
  end;

  ServerConnected := FALSE;
end;

function TOPCClientCell.GetInit: boolean;         // проверка инициализации
begin
  result:=(m_IOPCServer <> Nil);
  if not result then
     ServerInit;
end;


procedure TOPCClientCell.SetVersion;                    // установка версииж
begin
if (m_Status<>nil) then
  begin
    if (m_Status.wMinorVersion=1) then
      begin

      end;
    if (m_Status.wMajorVersion=2) then
      begin

      end;
  end;
end;


function TOPCClientCell.GetVersion: TOPCversionType;
begin
 result:=[];
  if (m_Status<>nil) then
  begin
    if (m_Status.wMinorVersion=1) then
      begin
         result:=result+[_1];
      end;
    if (m_Status.wMajorVersion=2) then
      begin
          result:=result+[_2];
      end;
  end;
end;

function TOPCClientCell.GetStatus: TServerStatus;       // чтение статуса
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
   // result:=fStatus;
   // fStatus:=osRunning;
    //exit;
  //if self.m_IOPCServer=nil then
  //ServerInit;
  //exit;
  if not assigned(m_Status) or (fStatus=osNone) then
  begin//CoTaskMemFree(m_Status);
 // m_Status:=nil;
  //Hres:=0;
  HRes:=m_IOPCServer.GetStatus(m_Status);
  if failed(Hres) then
    begin
       fStatus:=osNone;
       result:=fStatus;
       exit;
    end;
    end;
    begin
      case m_Status.dwServerState of
       OPC_STATUS_RUNNING: fStatus:=osRunning;
       OPC_STATUS_FAILED:  fStatus:=osFailed;
       OPC_STATUS_NOCONFIG: fStatus:=osRunning;
       OPC_STATUS_SUSPENDED: fStatus:=osSuspended;
       OPC_STATUS_TEST:  fStatus:=osStatusTest;
       else fStatus:=osNone;
       end;
       result:=fStatus;
    end;
   //  if assigned(m_Status) then CoTaskMemFree(m_Status);
end;

procedure TOPCClientCell.ResetStatus;                   // перезапросить статус
begin
   fStatus:=osNone;
end;


procedure TOPCClientCell.addClItem(path: string; name: string; group: string; num: integer; activ: boolean; typ: integer);
var numgroup: integer;
    clItemList: TItemOPCs;
begin
   numgroup:=groupList.IndexOf(trim(group));
   if (numgroup>-1) then
    begin
      clItemList:=TItemOPCs(groupList.objects[numgroup]);
      clItemList.addItem(path,name,group,num,activ,typ);
    end;
end;

procedure TOPCClientCell.ClearAllClItems;
 var i: integer;
begin
   for i:=0 to groupList.Count-1 do
    begin
      if (groupList.objects[i]<>nil) then
        begin
           TItemOPCs(groupList.objects[i]).ClearAllItems;
        end;
    end;
end;


function  TOPCClientCell.GetGroupCount: integer;
begin
  result:=0;
  if  groupList=nil then exit;
  result:=groupList.Count;
end;

function  TOPCClientCell.GetItemCount(val: integer): integer;
begin
    result:=0;
  if  groupList=nil then exit;
  if (val<groupList.Count) then
    begin
       if (groupList.objects[val]<>nil) then
         begin
            result:=TItemOPCs(groupList.objects[val]).count;
         end;
    end;
end;

function  TOPCClientCell.GetItemErrCount(val: integer): integer;
var j: integer;
begin
  result:=0;
  if  groupList=nil then exit;
  if (val<groupList.Count) then
    begin
       if (groupList.objects[val]<>nil) then
         begin
            for j:=0 to TItemOPCs(groupList.objects[val]).count-1 do
           if  TItemOPCs(groupList.objects[val]).items[j].err<>0 then result:=result+1;
         end;
    end;


end;

function  TOPCClientCell.GetGroupErr(val: integer): integer;
begin
      result:=0;
  if  groupList=nil then exit;
  if (val<groupList.Count) then
    begin
       if (groupList.objects[val]<>nil) then
         begin
            result:=TItemOPCs(groupList.objects[val]).ferr;
         end;
    end;
end;

function  TOPCClientCell.GetGroupName(val: integer): string;
begin
     result:='';
  if  groupList=nil then exit;
  if (val<groupList.Count) then
    begin
       if (groupList.objects[val]<>nil) then
         begin
            result:=TItemOPCs(groupList.objects[val]).fgroup;
         end;
    end;
end;

procedure TOPCClientCell.RemGroups;
var i: integer;
begin
  for i:=0 to groupList.Count-1 do
    RemGroup(i);
end;

procedure TOPCClientCell.RemoveItemsAll;
var i: integer;
begin
  for i:=0 to groupList.Count-1 do
    RemoveItems(i);
end;



procedure TOPCClientCell.AddGroup(groupid: integer);
var
  HRes : HRESULT;
  PercentDeadBand: Single;
  Active : BOOL;
  i: integer;
  UpdateRate, RevisedUpdateRate: DWORD;
  clItemList: TItemOPCs;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  Active      := TRUE;
  UpdateRate  := clItemList.UpdateRate;
  PercentDeadBand:=clItemList.PercentDeadBand;
  if  not (fStatus=osRunning) then
  begin
     Exit;
  end;
  clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsGroupAdding];
  HRes := m_IOPCServer.AddGroup(
                           StringtoOlestr(clItemList.fgroup),   // Group Name from Edit Box
                           Active,                              // Active State
                           UpdateRate,                          // Requested Update Rate
                           groupid,                             // Client Handle Group
                           nil,                                 // Time Bias
                           @PercentDeadBand,                     // Percent Deadband
                           0,                                    // Local ID
                           clItemList.m_hSGroup,                 // Server Handle Group
                           RevisedUpdateRate,                    // Revised Update Rate
                           IOPCItemMgt,                           // Requested Interface
                           IUnknown(clItemList.m_pIOPCItemMgt));  // Interface Pointer

   clItemList.fGroupStatus:=clItemList.fGroupStatus-[gsGroupAdding];
  if Failed(HRes) then begin
    clItemList.ferr:=HRes;
    Exit;
  end;
  clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsGroupAdded];
  try
  clItemList.m_pIConnectionPointContainer:=clItemList.m_pIOPCItemMgt as IConnectionPointContainer;
  except
  end;
  if (clItemList.m_pIConnectionPointContainer<>nil) then
   begin
     HRes := clItemList.m_pIConnectionPointContainer.FindConnectionPoint(
                                         IID_IOPCDataCallback,  // IID of the Callback Interface
                                         clItemList.m_pIConnectionPoint);    // Returned Connection Point
     if not Failed(HRes) then
          begin
           if not self.isNoAdvise then
           clItemList.connectionType:=clItemList.connectionType+[octAdvise2] else
           clItemList.connectionType:=clItemList.connectionType-[octASync2];

          end;
   end;
  try
  clItemList.m_pIOPCSyncIO:=clItemList.m_pIOPCItemMgt as IOPCSyncIO;
  except
  end;
  if (clItemList.m_pIOPCSyncIO<>nil) then
          clItemList.connectionType:=clItemList.connectionType+[octSync];
   try
  clItemList.m_pIOPCASyncIO2:=clItemList.m_pIOPCItemMgt as IOPCASyncIO2;
   except
  end;
  if (clItemList.m_pIOPCASyncIO2<>nil) then
     if not self.isNoAdvise then
       clItemList.connectionType:=clItemList.connectionType+[octASync2]
     else   clItemList.connectionType:=clItemList.connectionType-[octASync2];
  if (clItemList.m_pIOPCASyncIO2=nil) then
  begin
    try
    clItemList.m_pIOPCASyncIO:=clItemList.m_pIOPCItemMgt as IOPCASyncIO;
    except
    end;
     if (clItemList.m_pIOPCASyncIO<>nil) then clItemList.connectionType:=clItemList.connectionType+[octASync];
  end;

end;


procedure TOPCClientCell.ClearItemsErr(groupid: integer);
var
  clItemList: TItemOPCs;
  maincount,i: integer;
  temp_hSItems : array of OPCHANDLE;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  setlength(temp_hSItems,clItemList.m_Num);
   maincount:=0;
   for i:=0 to clItemList.m_Num-1 do
    begin
      if (clItemList.m_hSItems[i]<>0) then
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


procedure TOPCClientCell.AddItems(groupid: integer);
var
  i : Integer;
  HRes     : HRESULT;
  Results  : POPCITEMRESULTARRAY;
  Errors   : PResultList;
  clItemList: TItemOPCs;
  isErr: boolean;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if not (fStatus=osRunning) or not (gsGroupAdded in clItemList.fGroupStatus) then
     Exit;
  clItemList.prepareAddtoServer;
  if clItemList.m_NewItem<1 then exit;
  isErr:=false;
  clItemList.fGroupStatus:=clItemList.fGroupStatus+[gsItemsAdding];
  HRes := clItemList.m_pIOPCItemMgt.AddItems(
                            clItemList.m_NewItem,   // Number of Items to add
                            @clItemList.ItemDef[0], // OPCITEMDEF array
                            Results,  // OPCITEMRESULT array
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
        end
        else begin
            clItemList.items[i].servHandle:=Results[i].hServer;
            clItemList.items[i].dataType:=Results[i].vtCanonicalDataType;
            clItemList.m_hSItems[i] := Results[i].hServer;
            clItemList.items[i].isNew:=false;
            clItemList.items[i].err:=0;

        end;

    end;
    ClearItemsErr(groupid);
    if not (gsAdvised in clItemList.GroupStatus) then
    if not isNoAdvise then AdviseCallback(groupid) else
    clItemList.GroupStatus:=clItemList.GroupStatus-[gsAdvised];

    CoTaskMemFree(Results);
    CoTaskMemFree(Errors);
  end;
  clItemList.ItemDef := Nil;
end;




procedure TOPCClientCell.RemGroup(groupid: integer);
var
  HRes : HRESULT;
  clItemList: TItemOPCs;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if not (fStatus=osRunning) or not
     (gsGroupAdded  in clItemList.fGroupStatus) then
      Exit;

  if clItemList.m_pIConnectionPoint <> nil then begin
  if isNoAdvise then UnadviseCallback(groupid);
  end;

  clItemList.m_pIOPCItemMgt := Nil; // delete outstanding references
  clItemList.m_pIOPCSyncIO  := Nil; // at the group

  // Remove Group
  HRes := m_IOPCServer.RemoveGroup( clItemList.m_hSGroup, // Server Handle Group
                                     TRUE);     // bForce = TRUE -> delete Group,
                                                // there should be no outstanding references
  if Failed(HRes) then begin
    Application.MessageBox('Unable to add a Group Object to the OPC Server Object', '', MB_OK);
    Exit;
  end;
  clItemList.fGroupStatus := clItemList.fGroupStatus-[gsGroupAdded];
  clItemList.m_hSItems := Nil;


end;




function TOPCClientCell.ReadSync(groupid: integer): Boolean;
var
  HRes : HRESULT;
  ValueStart :  POPCITEMSTATEARRAY;
  Errors: PResultList;
  clItemList: TItemOPCs;
  i: integer;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if (clItemList.m_NumCorrect=0) then exit;

  SetLength(clItemList.m_hSItemsRead,clItemList.m_Num);
  clItemList.m_numRead:=0;
  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].servHandle<>0) and (clItemList.items[i].id>-1)) then
    begin
        if (clItemList.items[i].activ>0) then
          begin
            clItemList.m_hSItemsRead[clItemList.m_numRead]:=clItemList.items[i].servHandle;
            clItemList.m_numRead:=clItemList.m_numRead+1;
          end
    end;
  end;
  if (clItemList.m_numRead<1) then exit;
  HRes := clItemList.m_pIOPCSyncIO.Read(OPC_DS_Cache, // Source
                             clItemList.m_NumRead,            // number of Items read
                             @clItemList.m_hSItemsRead[0],// Server Handles
                             ValueStart,   // Item Value
                             Errors);      //
  SetLength(clItemList.m_hSItemsRead,0);
  if Failed (HRes) then begin
    clItemList.ferr:=HRes;
    Exit;
  end
  else begin
    CoTaskMemFree(Errors);
  end;
  if   ValueStart[0].vDataValue Then
    ReadSync := TRUE
  else
    ReadSync := FALSE;
   for i:=0 to clItemList.m_NumCorrect-1 do
       clItemList.Setval(ValueStart[i]);
   CoTaskMemFree(ValueStart);

end;

function TOPCClientCell.PrepareCommand( groupid: integer): boolean;
begin
      result:=TItemOPCs(groupList.Objects[groupid]).prepareCommand;
end;


function TOPCClientCell.WriteASync2(groupid: integer): Boolean;
var
  HRes : HRESULT;
  ff: Word;
  i,testpos: integer;
  m_hSItemsCommand : array of OPCHANDLE;
  ValueCommand :  array of OleVariant;
  Errors: PResultList;
  clItemList: TItemOPCs;
  temp: Cardinal;
  m_numCommand: Cardinal;
  WRHDL: Cardinal;
  teststr: string;
begin
  try
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if (clItemList.m_CommandTransactHandle<>0) then exit;
  // Allocate Array for ItemHandle
  SetLength(m_hSItemsCommand,clItemList.m_Num);
  SetLength(ValueCommand,clItemList.m_Num);
  // Fill Local Array of Server Handles
  if (clItemList.m_NumCorrect=0) then exit;
  m_numCommand:=0;
  for i:=0 to clItemList.Count-1 do
    begin
       if (clItemList.items[i].servHandle<>0) then
          begin
             if (clItemList.items[i].commandActiv) then
                begin
                  try
                    m_hSItemsCommand[m_numCommand]:=clItemList.items[i].servHandle;

                    ValueCommand[m_numCommand]:=  getvalbt(clItemList.items[i].CommandValue,clItemList.items[i].typ_);
                    WRHDL:=clItemList.items[i].WRHDL;
                    m_numCommand:=m_numCommand+1;
                  except
                  end;
                end;
          end;
    end;
    if m_numCommand<1 then
      begin
        clItemList.ClearCommandTransaction;
        exit;
      end;
   clItemList.m_CommandTransactHandle:=WRHDL;
  HRes := clItemList.m_pIOPCASyncIO2.Write( m_numCommand,            // number of Items read
                             @m_hSItemsCommand[0],// Server Handles
                             @ValueCommand[0],   // Item Value
                             clItemList.m_CommandTransactHandle,
                             temp,
                             Errors);      //
  if Failed (HRes) then begin
   clItemList.ferr:=HRes;
   clItemList.m_CommandTransactHandle:=0;
   TItemOPCs(groupList.Objects[groupid]).ClearCommandTransaction;

    Exit;
  end;

    CoTaskMemFree(Errors);


    clItemList.ClearCommandTransaction;

   except
      clItemList.ClearCommandTransaction;
   end;

end;



function TOPCClientCell.WriteSync(groupid: integer): Boolean;
var
  HRes : HRESULT;
  temp: string;
  ff: Word;
  i,testpos: integer;
  m_hSItemsCommand : array of OPCHANDLE;
  ValueCommand :  array of OLEVARIANT;
  Errors: PResultList;
  clItemList: TItemOPCs;
  teststr:string;
  m_numCommand: Cardinal;
  hhh: single;
begin
   try
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);

  // Allocate Array for ItemHandle
  SetLength(m_hSItemsCommand,clItemList.m_Num);
  SetLength(ValueCommand,clItemList.m_Num);
  // Fill Local Array of Server Handles
  if (clItemList.m_NumCorrect=0) then exit;
  m_numCommand:=0;
  for i:=0 to clItemList.Count-1 do
    begin
       if (clItemList.items[i].servHandle<>0) then
          begin
             if (clItemList.items[i].commandActiv) then
                begin
                  try
                    m_hSItemsCommand[m_numCommand]:=clItemList.items[i].servHandle;
                    hhh:=getvalbt(clItemList.items[i].CommandValue,clItemList.items[i].typ_);
                    ValueCommand[m_numCommand]:= getvalbt(clItemList.items[i].CommandValue,clItemList.items[i].typ_);
                    m_numCommand:=m_numCommand+1;
                  except
                  end;
                end;
          end;
    end;
    if m_numCommand<1 then
      begin
        clItemList.ClearCommandTransaction;
        exit;
      end;
  HRes := clItemList.m_pIOPCSyncIO.Write( m_numCommand,            // number of Items read
                             @m_hSItemsCommand[0],// Server Handles
                             @ValueCommand[0],   // Item Value
                             Errors);      //

  if Failed (HRes) then begin
  clItemList.ComandExecuted:=false;
  TItemOPCs(groupList.Objects[groupid]).ClearCommandTransaction;
  clItemList.ferr:=HRes;
    Exit;
  end
  else begin
    clItemList.ComandExecuted:=false;
    CoTaskMemFree(Errors);
  end;
  TItemOPCs(groupList.Objects[groupid]).ClearCommandTransaction;
  except
   TItemOPCs(groupList.Objects[groupid]).ClearCommandTransaction;
  end;

end;



function TOPCClientCell.ReadASync2(groupid: integer): Boolean;
var
  HRes : HRESULT;
  ff: Word;
  i: integer;
  ValueStart :  POPCITEMSTATEARRAY;
  Errors: PResultList;
  clItemList: TItemOPCs;
  fff: real;
begin
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if clItemList.m_ReadTransactHandle<>0 then exit;
  if (clItemList.m_NumCorrect=0) then exit;

  SetLength(clItemList.m_hSItemsRead,clItemList.m_Num);
  clItemList.m_numRead:=0;
  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].servHandle<>0) and  (clItemList.items[i].id>-1)) then
    begin
        if (clItemList.items[i].activ>0) then
          begin
            clItemList.m_hSItemsRead[clItemList.m_numRead]:=clItemList.items[i].servHandle;
            clItemList.m_numRead:=clItemList.m_numRead+1;
          end
    end;
  end;
  if (clItemList.m_numRead<1) then exit;

  clItemList.m_ReadTransactHandle:=23;
  HRes := clItemList.m_pIOPCAsyncIO2.Read(clItemList.m_NumRead,
                             @clItemList.m_hSItemsRead[0],// Server Handles
                             clItemList.m_ReadTransactHandle,   // Item Value
                             clItemList.m_CancelReadTransact,
                             Errors);      //
  SetLength(clItemList.m_hSItemsRead,0);
  if Failed (HRes) then begin
    clItemList.ferr:=HRes;
    clItemList.m_ReadTransactHandle:=0;
    Exit;
  end
  else begin
    CoTaskMemFree(Errors);
  end;
end;


function TOPCClientCell.ConversionType(val: real; dataType: Word): OLEVARIANT;
begin
   result:=val;
end;

function TOPCClientCell.ChangeActiv(groupid: integer): Boolean;
var
  HRes : HRESULT;
  Errors: PResultList;
  clItemList: TItemOPCs;
  isErr: boolean;
  i: integer;
begin
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if ((not (gsItemsAdded in clItemList.fGroupStatus)) or
                        (not (gsGroupAdded in clItemList.fGroupStatus))) then exit;
   if ((not clItemList.needActiv)) then exit;

  clItemList.m_numActiv:=0;
  clItemList.m_numInactiv:=0;
  SetLength(clItemList.m_hSItemsActiv,clItemList.m_Num);
  SetLength(clItemList.m_hSItemsInActiv,clItemList.m_Num);

  for i:=0 to clItemList.count-1 do
  begin
    if ((clItemList.items[i].servHandle<>0) and (clItemList.items[i].id>-1)) then
    begin
     if (clItemList.items[i].changeActiv) then
      begin
        if ((clItemList.items[i].activ>0) or (clItemList.RequestActive)) then
          begin
            clItemList.m_hSItemsActiv[clItemList.m_numActiv]:=clItemList.items[i].servHandle;
            clItemList.m_numActiv:=clItemList.m_numActiv+1;
          end
         else
          begin
            clItemList.m_hSItemsInActiv[clItemList.m_numInActiv]:=clItemList.items[i].servHandle;
            clItemList.m_numInActiv:=clItemList.m_numInActiv+1;
          end;
       clItemList.items[i].changeActiv:=false;
    end;
  end;
  end;
  if (clItemList.m_numActiv>0) then

  begin

  HRes := clItemList.m_pIOPCItemMgt.SetActiveState(clItemList.m_numActiv,
                             @clItemList.m_hSItemsActiv[0],// Server Handles
                             true,   // Item Value
                             Errors);      //
  SetLength(clItemList.m_hSItemsActiv,0);
  if Failed (HRes) then begin
   clItemList.ferr:=HRes;
    SetLength(clItemList.m_hSItemsActiv,0);
    SetLength(clItemList.m_hSItemsInActiv,0);
  end
  else begin
    // Free returned memory
    CoTaskMemFree(Errors);
  end;
  end;

    if (clItemList.m_numInActiv>0) then

  begin

  HRes := clItemList.m_pIOPCItemMgt.SetActiveState(clItemList.m_numInActiv,
                             @clItemList.m_hSItemsInActiv[0],// Server Handles
                             false,   // Item Value
                             Errors);      //

  if Failed (HRes) then begin
    clItemList.ferr:=HRes;
     SetLength(clItemList.m_hSItemsActiv,0);
    SetLength(clItemList.m_hSItemsInActiv,0);
  end
  else begin
  //   for i := 0 to clItemList.m_numInActiv-1 do begin
       // if not Failed(Errors[i]) then setInactiveInem(clItemList.m_hSItemsInActiv[i]);
    CoTaskMemFree(Errors);
  end;
  end;
    SetLength(clItemList.m_hSItemsActiv,0);
    SetLength(clItemList.m_hSItemsInActiv,0);
    clItemList.needActiv:=false;

end;




procedure TOPCClientCell.RemoveItems(groupid: integer);
var
  i : integer;
  HRes     : HRESULT;
  Errors   : PResultList;
  clItemList: TItemOPCs;
begin
  if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);

  if not (fstatus=osRunning) or not (gsGroupAdded in clItemList.fGroupStatus) then
     Exit;
  HRes := clItemList.m_pIOPCItemMgt.RemoveItems(clItemList.m_NumCorrect, //number of Items to remove
                                     @clItemList.m_hCorrectSItems[0], //
                                     Errors);  // Error Array

  if Failed(HRes) then
  begin
    //Application.MessageBox('Unable to Remove Items from OPC Group', '', MB_OK);
    //Exit;
  end
  else begin
    // Get Item Server Handles
  //  for i := 0 to clItemList.Count-1 do begin
        //  Check item results
       // if Failed(Errors[i]) then begin
       //     Application.MessageBox('One Item FAILED at RemoveItems', '', MB_OK);
     //   end;
    end;

    CoTaskMemFree(Errors);
 // end;
  
end;

// Procedure UnadviseCallback
procedure TOPCClientCell.UnadviseCallback(groupid: integer);
var
  HRes : HRESULT;
  clItemList: TItemOPCs;
begin
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);
  if clItemList.m_pIConnectionPoint <> nil then begin
    HRes := clItemList.m_pIConnectionPoint.Unadvise(clItemList.m_Cookie);
     if Failed(HRes) then begin
         Application.MessageBox('Unadvise Connection for Callback FAILED', '', MB_OK);
     end
  end
   else
       clItemList.GroupStatus:=clItemList.GroupStatus-[gsAdvised];
  // delete Callback Object and Connection Point Interface
  clItemList.m_pOPCDataCallback := Nil;
  clItemList.m_pIConnectionPoint := Nil;

end;


// Procedure AdviseCallback
procedure TOPCClientCell.AdviseCallback(groupid: integer);
var
  HRes : HRESULT;
  clItemList: TItemOPCs;
begin
//  exit;
   if (groupid>=self.groupList.Count) then exit;
  clItemList:= TItemOPCs(groupList.Objects[groupid]);

  clItemList.CallBack := TOPCDataCallback.Create(clItemList);

    HRes := clItemList.m_pIConnectionPoint.Advise(clItemList.CallBack as IUnknown ,
                                          clItemList.m_cookie);
    if Failed(HRes) then
      begin
       clItemList.connectionType:=clItemList.connectionType-[octAdvise2,octAsync2];
       clItemList.CallBack:=nil;
      end else
       clItemList.GroupStatus:=clItemList.GroupStatus+ [gsAdvised];


end;


{----------TItemDDEs------------}

constructor TItemOPCs.create(group: string);
begin
  inherited create;
  fgroup:=group;
  connectionType:=[];
  m_rtItemsCount:=0;
  needActiv:=true;
  m_ReadTransactHandle:=0;
  m_CommandTransactHandle:=0;
  isCommand:=false;
  ComandExecuted:=false;
  fRequestActive:=false;
  fGroupStatus:=[];
  temp_changactiv:=false;
  ferr:=0;
end;




destructor TItemOPCs.destroy;
begin
inherited destroy;
end;

function TItemOPCs.Add(item: PTItemOPC): integer;
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

procedure TItemOPCs.addItem(path: string; name: string; group: string; num: integer; activ: boolean; typ: integer);

var
    ddeRslt: LongInt;

    it: PTItemOPC;
    dest: array of integer;
    i,j: integer;
begin
    i:=self.FindByParam(path, name);
    if (i<0) then
    begin
      new(it);
     // it.id:=count-1;
      it.name:=name;
      it.path:=path;
      it.val:=0;
      setLength(it.rtid,1);
      it.rtid[0]:=num;
      it.activ:=0;
      it.commandActiv:=false;
      it.count:=1;
      it.dataType:=999;
      it.changeActiv:=false;
      it.isNew:=true;
      it.err:=0;
      it.time:=0;
      it.Qual:=0;
      it.typ_:=typ;
      GroupStatus:=GroupStatus-[gsItemsAdded];
      begin
        i:=Add(it);
      end;
    end else
      begin
       it:=items[i];
        setLength(dest,it.count);
       for j:=0 to it.count-1 do dest[j]:=it.rtid[j];
       it.count:=it.count+1;
       setLength(it.rtid,it.count);
       for j:=0 to it.count-2 do it.rtid[j]:=dest[j];
       it.rtid[it.count-1]:=num;
      end;
     AddRtIDandSort(num,count-1,0);
     if activ then it.activ:=it.activ+1;
end;

procedure TItemOPCs.ClearAllItems;
begin
  self.DelRtID;
  while (count>0) do
    if items[0]<>nil then
     begin
      SetLength(items[0].rtid,0);
      dispose(items[0]);
      delete(0);
     end;
end;

procedure TItemOPCs.setActivById(val: integer);
var num: integer;
    temp: integer;
begin
   num:=self.FindItIdByRTid(val);
   if (num<0) then exit;
   temp:=items[num].activ;
   items[num].activ:=items[num].activ+1;
   if (temp<=0) then
     begin
       items[num].changeActiv:=true;
       self.needActiv:=true;
     end;
end;

function TItemOPCs.RefreshActivState: boolean;
var i,j, num: integer;
    temp: integer;
    tempres: boolean;

begin
  tempres:=false;
  for i:=0 to count-1 do
    begin
      temp:=0;
      if (Items[i].servHandle<>0) then
      begin
      for j:=0 to items[i].count-1 do
          if (frtitems.Items[items[i].rtid[j]].refCount>0) then inc(temp);
      if (((items[i].activ>0) and (temp<1))) then
        begin
         items[i].changeActiv:=true;
         items[i].activ:=temp;
         tempres:=true;
        end;
      if ((items[i].activ<1) and (temp>0)) then
        begin
         items[i].changeActiv:=true;
         items[i].activ:=temp;
         tempres:=true;
        end;
        end;
    end;
   needActiv:=true;
   if temp_changactiv then
    begin
      temp_changactiv:=false;
      result:=true;
      exit;
    end;

   result:=tempres;

end;

procedure TItemOPCs.setRequestActive(val: boolean);
var i: integer;
begin
  if (val<>fRequestActive) then
    begin
       fRequestActive:=val;
       for i:=0 to count-1 do
         items[i].changeActiv:=true;
       needActiv:=true;
       temp_changactiv:=true;
    end;
end;

function  TItemOPCs.getUpdateRate: DWORD;
begin
  result:=0;
  if fUpdateRate>0 then result:=fUpdateRate;
end;

function  TItemOPCs.getPercentDeadBand: single;
begin
   result:=0;
  if (fPercentDeadBand>0) and (fPercentDeadBand<=100) then result:=fPercentDeadBand;
end;

procedure TItemOPCs.setInActivById(val: integer);
var num: integer;
    temp: integer;
begin
   num:=self.FindItIdByRTid(val);
   if (num<0) then exit;
   temp:=items[num].activ;
   if (items[num].activ>0) then items[num].activ:=items[num].activ-1;
   if (items[num].activ=0) then
     begin
     items[num].changeActiv:=true;
       self.needActiv:=true;
     end;

end;


procedure TItemOPCs.AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
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

procedure TItemOPCs.DelRtID;
begin
   setLength(m_rtItemsId,0);
   m_rtItemsCount:=0;
end;

function TItemOPCs.FindItIdByRTid(id: integer): integer;
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


function TItemOPCs.FindByParam (path: string; name: string): integer;
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

function TItemOPCs.prepareAddtoServer: boolean;
var i: integer;
begin
  result:=true;
  SetLength(ItemDef, count);
  m_NewItem:=0;
  for i := 0 to count-1 do begin
   if items[i].isNew then
    with ItemDef[m_NewItem] do
      begin
        result:=true;
        szAccessPath := StringToOleStr(items[i].path);
        szItemID := StringToOleStr(items[i].name);  // ItemID
        bActive := ((items[i].activ>0) or (self.fRequestActive));       // Active -> TRUE to get DataChange Callbacks
        hClient := i+1;          // Item Client Handle to identify the items at the DataChange Callback
        dwBlobSize := 0;
        pBlob := nil;
        vtRequestedDataType := VT_EMPTY;  // VT_BSTR  -> Requested Data Type = String (BSTR)                                         // VT_EMPTY -> Requested Data Type = Canonical Data Type
        m_NewItem:=m_NewItem+1;
      end;
  end;
  self.m_Num:=Count;
end;



function TItemOPCs.prepareCommand: boolean;
var
  i,k,ids: longInt;
  newValue: longInt;
  cN: longInt;
  prevVal: word;
  newComValue: single;
  str: string;
  j : longInt;
  Last: longInt;
  val: real;
  temp_c: boolean;

function ExecuteCommand: boolean;
 var numit: integer;
begin

      result:=false;
      ids:=frtItems.Command[j].ID;
      if (ids <> -1)then
      begin
       cN := self.FindItIdByRTid(ids);
       if (CN>-1) then
       begin
        result:=true;
        items[CN].CommandValue:=getconvcomm(frtItems.Command[j].ValReal,
             frtItems[ids].MinEU,frtItems[ids].MaxEU,frtItems[ids].MinRaw,frtItems[ids].MaxRaw);
        items[CN].WRHDL:=j+1;
        items[CN].commandActiv:=true;
        frtItems.SetCommandExecuted(j);
        end;
      end;
end;

begin
      result:=false;
      temp_c:=false;
      try
      Last := PredLastCommand;
      if Last < frtItems.Command.CurLine then
        for j:=Last to frtItems.Command.CurLine - 1 do
        begin
         if ExecuteCommand then result:=true;
          begin
          inc(PredLastCommand); //увеличивать, если команда выполнилась
         // result:=true;
          end;
        end;

      if Last > frtItems.Command.CurLine then begin
        for j := Last to  frtItems.Command.Count - 1 do
        begin
            if ExecuteCommand then result:=true;
          begin


           inc(PredLastCommand)
          end;

        end;
        predLastCommand := 0;
        for j := 0 To frtItems.Command.CurLine - 1 do
        begin
           if ExecuteCommand then result:=true;
          begin
          inc(PredLastCommand);

          end;

        end;
      end;
      if result then ComandExecuted:=true;
{      for j := PredLastCommand - 1 downto 0 do
        ExecuteCommand;}
    except
     // if   WriteErrorCount < 3 then begin
     //   inc (WriteErrorCount);
     //   fThrtItems.ClearCommandExecuted(j);
    //  end else WriteErrorCount := 0; //—брасываем команду при трех неудачных попытках записи
    end; //except
end;





function TItemOPCs.CovertValtoreal(val: Olevariant; dattype: word; var outs: real): boolean;

begin
   result:=true;
     try
      outs:=val;
     except
       try

         outs:= strtofloat(val);

       except
          result:=false;
       end;
     end;

    { if (dattype=$2) then
     begin
       htsmallint:=val;
       outs:= htsmallint;
     end;
     if (dattype=$3) then
     begin
       htinteger:=val;
       outs:= htinteger;
     end;
     if (dattype=$4) then
     begin
       htsingle:=val;
       outs:= htsingle;
     end;
     if (dattype=$5) then
     begin
       htdouble:=val;
       outs:= htdouble;
     end;
     if (dattype=$8) then
     begin
       htolestring:=val;
       outs:= strtofloat(htsingle);
    end;
    if (dattype=$B) then
    begin
       htboolean:=val;
       outs:= htboolean;
    end;
    if (dattype=$10) then
    begin
      htsortint:=val;
       outs:= htsortint;
    end;
    if (dattype=$11) then
    begin
       htbyte:=val;
       outs:= htbyte;
    end;
    if (dattype=$12) then
    begin
       htword:=val;
       outs:= htword;
    end;
    if (dattype=$13) then
    begin
       htlongword:=val;
       outs:= htlongword;
    end;
    if (dattype=$14) then
    begin
       htint64:=val;
       outs:= htint64;
    end;
    if (dattype=$48) then
    begin
       htvarstr:=val;
       outs:= strtofloat(htvarstr);
    end

    else
         begin

         end

   end;     }

end;

function TItemOPCs.CovertrealtoVal(val: real; dattype: word; var outs: Olevariant): boolean;
begin
   result:=true;
     try
     // outs:=val;
     except
       try
       //  outs:= strtofloat(val);

       except
       //   result:=false;
       end;
     end;

    { if (dattype=$2) then
     begin
       htsmallint:=val;
       outs:= htsmallint;
     end;
     if (dattype=$3) then
     begin
       htinteger:=val;
       outs:= htinteger;
     end;
     if (dattype=$4) then
     begin
       htsingle:=val;
       outs:= htsingle;
     end;
     if (dattype=$5) then
     begin
       htdouble:=val;
       outs:= htdouble;
     end;
     if (dattype=$8) then
     begin
       htolestring:=val;
       outs:= strtofloat(htsingle);
    end;
    if (dattype=$B) then
    begin
       htboolean:=val;
       outs:= htboolean;
    end;
    if (dattype=$10) then
    begin
      htsortint:=val;
       outs:= htsortint;
    end;
    if (dattype=$11) then
    begin
       htbyte:=val;
       outs:= htbyte;
    end;
    if (dattype=$12) then
    begin
       htword:=val;
       outs:= htword;
    end;
    if (dattype=$13) then
    begin
       htlongword:=val;
       outs:= htlongword;
    end;
    if (dattype=$14) then
    begin
       htint64:=val;
       outs:= htint64;
    end;
    if (dattype=$48) then
    begin
       htvarstr:=val;
       outs:= strtofloat(htvarstr);
    end

    else
         begin

         end

   end;     }

end;

function TItemOPCs.Setval(vals: OPCITEMSTATE): Boolean;
var num,ids,i: integer;
    valmain,val: real;
    err: boolean;
    st, st1: word;
    tim: _FILETIME;
    tims: _SYSTEMTIME;
    rtID: integer;
    MinEU, MaxEU, MinRaw, MaxRaw: real;
    koef: real;
    qld: integer;
begin
 num:=vals.hClient-1;
 if ((num>-1) and (num<Count)) then
  begin


       begin
          qld:=0;
          if (vals.wQuality=OPC_QUALITY_GOOD) then qld:=100;
          err:=CovertValtoreal(vals.vDataValue,items[num].dataType,valmain);
          items[num].Qual:=vals.wQuality;
          items[num].val:=valmain;
          tim:=vals.ftTimeStamp;
          if FileTimeToSystemTime(tim, tims)=true then
          items[num].time:=SystemTimeToDateTime(tims) else items[num].time:=0;
          for i:=0 to items[num].count-1 do
            begin
             val:=valmain;
             rtID:=items[num].rtid[i];
             if (frtitems.items[rtID].ID>-1) then
             begin
                MinEU:=frtitems.items[rtID].MinEu;
                MaxEU:=frtitems.items[rtID].MaxEu;
                MinRaw:=frtitems.items[rtID].MinRaw;
                MaxRaw:=frtitems.items[rtID].MaxRaw;
                if ((frtitems.items[rtID].refCount>0) or(RequestActive)) and (err) then
                begin
                if (MinRaw=MaxRaw) {or (MinEU=MaxEU)} then
                begin

                    // frtitems.SetValid(items[num].rtid[i],qld);
                     frtitems.SetVal(items[num].rtid[i],val,qld);
                    // if round(val)=41 then
                       //  frtitems.SetValid(items[num].rtid[i],99);
                end
                 else
                begin
                   if (MinRaw<MaxRaw) then
                     begin
                        if (val<MinRaw) then val:=MinRaw;if (val>MaxRaw) then val:=MaxRaw;
                        koef:=(MaxEU-MinEU)/(MaxRaw-MinRaw);
                        val:=MinEU+koef*(val-MinEU);
                        frtitems.SetVal(items[num].rtid[i],val,100);
                         //frtitems.SetValid(items[num].rtid[i],100);
                     end
                   else
                     begin
                        if (val<MaxRaw) then val:=MinRaw;
                        if (val>MinRaw) then val:=MaxRaw;
                        koef:=(MaxEU-MinEU)/(MaxRaw-MinRaw);
                        val:=MinEU+koef*(val-MinEU);
                       // frtitems.SetValid(items[num].rtid[i],qld);
                        frtitems.SetVal(items[num].rtid[i],val,qld);

                     end;
                end;
                end
                else
                  begin
                       frtitems.ValidOff(items[num].rtid[i]);
                  end;
             end;
            end;
      end;
  end;
end;

procedure TItemOPCs.SetItemErr(id: integer; err: Cardinal);
var num,ids,i: integer;

begin
 num:=id-1;
 if ((num>-1) and (num<Count)) then
  begin
    items[num].err:=err;
  end;
end;

procedure TItemOPCs.ClearReadTransaction;
begin
   self.m_ReadTransactHandle:=0;
end;

procedure TItemOPCs.ClearCommandTransaction;

begin
   self.m_CommandTransactHandle:=0;
   self.ComandExecuted:=false;
   setCommandTransaction;
end;

procedure TItemOPCs.setCommandTransaction;
var i: integer;
begin
     for I:=0 to count-1 do
    begin
     items[i].commandActiv:=false;
     items[i].Executed:=false;
    end;
end;

function TItemOPCs.GetReadTransaction: DWORD;
begin
  result:= self.m_ReadTransactHandle;
end;

function TItemOPCs.GetCommandTransaction: DWORD;
begin
  result:= self.m_CommandTransactHandle;
end;


function TItemOPCs.GetItem(i: integer): PTItemOPC;
begin
  result := inherited Items[i];
end;

procedure TItemOPCs.SetItem(i: integer; item: PTItemOPC);
begin
  Items[i] := item;
end;

function TItemOPCs.GetTabCount: integer;
var i: integer;
begin
   result:=0;
   for i:=0 to count-1 do result:=result+items[i].count;
end;


constructor TOPCClient.Create(servn: string; path: string; slave: integer; host: string; noAdv: boolean);
begin
  fAnalize:=false;
 /// isExecuted:=true;
  isAdding:=false;
 /// isExit:=false;
  nameserver:=servn;
  fpath:=path;
  finitvar:=false;
 // isRunning:=false;
  inherited Create(false);
  server:=TOPCClientCell.create(servn,slave,host, noadv);
  
end;

destructor TOPCClient.Destroy;
begin
  server.Free;
  inherited;
end;


procedure TOPCClient.ReadASync2_;
begin
   server.ReadASync2(fActivgr);
end;

procedure TOPCClient.WriteSync_;
begin
   server.WriteSync(fActivgr);
end;

procedure TOPCClient.WriteASync2_;
begin
   server.WriteASync2(fActivgr);
end;

procedure TOPCClient.ReadSync_;
begin
   server.ReadSync(fActivgr);
end;

procedure TOPCClient.AddGroup_;
begin
   server.addGroup(fActivgr);
end;

procedure TOPCClient.AddItems_;
begin
   server.addItems(fActivgr);
end;

procedure TOPCClient.RemGroup_;
begin
   server.RemGroup(fActivgr);
end;

procedure TOPCClient.RemItems_;
begin
   server.RemoveItems(fActivgr);
end;

procedure TOPCClient.ChangeActivs_;
var i: integer;
begin
  server.ChangeActiv(fActivgr);
end;


procedure TOPCClient.ReadMain;
var i: integer;
begin
   for i:=0 to server.groupList.Count-1 do
    begin
    if  not (gsReading in TItemOPCs(server.groupList.Objects[i]).groupstatus) then
     if not (octAdvise2 in TItemOPCs(server.groupList.Objects[i]).connectionType) then
       begin
         fActivgr:=i;
         Synchronize(ReadSync_);
       end;
    end;
end;

procedure TOPCClient.ChangeActivsMain;
var i: integer;
begin
   for i:=0 to server.groupList.Count-1 do
    begin
     if  not (gsReading in TItemOPCs(server.groupList.Objects[i]).groupstatus) then
     if (TItemOPCs(server.groupList.Objects[i])<>nil) then
      if (TItemOPCs(server.groupList.Objects[i]).RefreshActivState) then

       begin
         fActivgr:=i;

         Synchronize(ChangeActivs_);
       end;
    end;
end;

procedure TOPCClient.WriteMain;
var i: integer;
begin
  for i:=0 to server.groupList.Count-1 do
    begin
      //if  not (gsReading in TItemOPCs(server.groupList.Objects[i]).groupstatus) then
      if (TItemOPCs(server.groupList.Objects[i]).GetCommandTransaction=0) and (TItemOPCs(server.groupList.Objects[i]).prepareCommand) then
        begin
          if (octASYNC2 in TItemOPCs(server.groupList.Objects[i]).connectionType) then
           begin
             fActivgr:=i;
             Synchronize(WriteASync2_);
           end
           else
           begin
             fActivgr:=i;
             Synchronize(WriteSync_);
           end;
        end;
       end;
  
end;

procedure TOPCClient.AddItems;
var  serv,group,group1,opcit,hostname: string;
     i,slave,j, typ: integer;

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
        slave:=frtItems.TegGroups.GetSlavebyNum(rtItems[i].GroupNum);
        typ:=rtItems[i].Logtime;
        if (serv<>'') and (trim(uppercase(serv))=trim(uppercase(self.nameserver))) then
          begin
             if (slave=self.server.servslave) then
             if (hostname=server.host) then
                begin
                  opcit:=frtItems.GetDDEItem(i);

                     if ((opcit<>'') {and (iscorrect(ddit))}) then
                       server.addClItem('',opcit,group,i,(frtItems.Items[i].refCount>0),typ);
                end;
           end;
      end;
  finally
  isAdding:=false;
  end;
end;

procedure TOPCClient.AddItem(val: integer);
var  serv,group,group1,opcit,hostname: string;
     i,slave,j, gn,typ: integer;

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
        typ:=rtItems[i].Logtime;
        if (serv<>'') and (trim(uppercase(serv))=trim(uppercase(self.nameserver))) then
          begin
             if (slave=self.server.servslave) then
             if (hostname=server.host) then
                begin
                  opcit:=frtItems.GetDDEItem(i);

                     if ((opcit<>'') {and (iscorrect(ddit))}) then
                       server.addClItem('',opcit,group,i,(frtItems.Items[i].refCount>0),typ);
                end;
           end;

      end;
  finally
  isAdding:=false;
  end;
end;


function TOPCClient.isOPC(val: string; var host: string; var grn: string): string;
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
   result:=getinVstring(val,'OPC');
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

procedure TOPCClient.RemItems;
var  serv,group,opcit: string;
     i,slave: integer;
begin
 server.ClearAllClItems;
end;

function  TOPCClient.GetStatus: TServerStatus;  // проверка статуса
var i: integer;
begin
  result:=fstatus;
  for i:=0 to  server.groupList.count-1 do
  if   (gsReading in TItemOPCs(server.groupList.Objects[i]).groupstatus) then exit;
  Synchronize(GetStatus_);
  result:=fstatus;
end;

procedure  TOPCClient.GetStatus_;  // проверка статуса
begin
  fstatus:=osNone;
 // exit;
  if (server<>nil) then
    fstatus:=server.status;
end;



function  TOPCClient.isCurTread(serv: string; group: string; slave: integer; host: string):boolean;
begin
result:=server.isCurTread(serv, group, slave,host);
end;



function TOPCClient.getServer: Tobject;
begin
  result:=server;
end;


function TOPCClient.AddClGroup(group: string; slave: integer ;PD: single; UR: DWORD): Tobject;
begin
 result:=server.AddClGroup(group, slave, PD, UR);
end;

procedure TOPCClient.RemClGroup;
begin
 server.RemClGroup;
end;



procedure TOPCClient.Execute;
begin
//isRunning:=true;
while not Terminated do
//if isExecuted then
  if ClientInit then
     begin
      if (ServerStatus=osRunning) then
        begin
         if SeverInit then
            begin
              ChangeActivsMain;
              WriteMain;
              ReadMain;
              sleep (100);
            end
          else
            begin
              sleep (1000);
            end;
        Synchronize(AnalizeMain);
        end
      else
        begin
         sleep (1000);
        end;
       if Analize then

     end;
end;



procedure TOPCClient.AnalizeMain;
var Analizeobj: TObject;
begin
   Analizeobj:=server.GetAnalizeObject;
   if (Analizeobj<>nil) then
     begin
      if (Analizeobj is TOPCClientCell) then  TOPCClientCell(Analizeobj).AnalizeFunction(Analizeobj) else
        if (Analizeobj is TItemOPCs) then  TItemOPCs(Analizeobj).AnalizeFunction(Analizeobj);
     end;
end;

procedure TOPCClient.InitVar;
var i,j: integer;
begin
  if not finitvar then
  begin
  frtitems:=TAnalogMems.Create(fPath);
//  frtitems.RegHandle('OPCgataway',self.Handle,[ImmiAll]);
  for i:=0 to server.groupList.count -1 do
    begin
      TItemOPCs(server.groupList.Objects[i]).frtitems:=frtitems;
      for j:=0 to frtitems.command.count-1 do
      begin
     // frtitems.setCommandExecuted(j);
      end;
      TItemOPCs(server.groupList.Objects[i]).PredLastCommand:=frtitems.command.CurLine;
    end;
  AddItems;
  
  finitvar:=true;
  end;
end;

procedure TOPCClient.UnInitVar;
var i: integer;
begin
 RemItems;;
  for i:=0 to server.groupList.count -1 do
      TItemOPCs(server.groupList.Objects[i]).frtitems:=nil;
  frtitems.free;
  finitvar:=false;
end;

function TOPCClient.SeverInit: boolean;
var i: integer;
begin
     result:=false;
     for i:=0 to server.groupList.count -1 do
       if (server.groupList.Objects[i]<>nil) then
         begin
            if not (gsGroupAdded in TItemOPCs(server.groupList.Objects[i]).fGroupStatus) then
              begin
                fActivgr:=i;
                SynChronize(AddGroup_);
              end;
              if (gsGroupAdded in TItemOPCs(server.groupList.Objects[i]).fGroupStatus) then
                  begin
                     if not (gsItemsAdded in TItemOPCs(server.groupList.Objects[i]).fGroupStatus) then
                       begin
                           fActivgr:=i;
                            SynChronize(AddItems_);
                       end;
                     if  (gsGroupAdded in TItemOPCs(server.groupList.Objects[i]).fGroupStatus) and
                            (gsItemsAdded in TItemOPCs(server.groupList.Objects[i]).fGroupStatus) then
                            result:=true;
                  end;
             
         end;

end;


function TOPCClient.getClientInit: boolean;   // чтение состо€ни€ инициализации переменных
begin
 if not finitvar then
  begin
   Synchronize(InitVar);
  end;
  result:=finitvar;
end;


end.
