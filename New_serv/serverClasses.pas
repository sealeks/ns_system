unit serverClasses;
{$define MyComms}
interface
uses
  classes, plcComPort, SysUtils, InterfaceServerU,
  Mycomms, EtherServerU, ConstDef, math, DateUtils, StrUtils,
  windows{, debugClasses}, Messages, ConvFunc, {Globalvar,} dialogs, MemStructsU;
const
  UM_UPDATEPORT = WM_USER + 1;
  groupCount = 255;



type
  TConvType = (ctNone, ctB, ctD, ctBD, ctR, ctErr, ctArch); //bcd, double, double BCD
  TAskItem = record
    name : string;
    id: integer;
    GroupNum: integer;
    addr: integer; //f.e. v2000:bd.01 is ok, bits from 0 to 31
    conv: TConvType;
    bitNumber: integer; //number of bit, if not diskrete, number is -1;
    prevValue: longInt; //not Converted (we need correct prevValue when write to PLC)
    deadBaund: real; //server do nothing when value changed less then deadBaund
    minRaw, maxRaw, MinEu, MaxEu: real;
    activ: boolean;
    ref: integer;
  end;

  PTAskItem = ^TAskItem;

  TAskItemArray = array[1..1000000]of TAskItem;
  PTAskItemArray = ^TAskItemArray;



  // единица опроса для текущих данных
type
  TKoyoArchItem = record
    name: string;
    ID: integer;
    minRaw, maxRaw, MinEu, MaxEu: real;
    activ: boolean;
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
    convtyp: TConvType;
    device_val: string;
    device_ue:  string;
    device_tm:  string;
  end;


  PTKoyoArchItem = ^TKoyoArchItem;


  TAscItems = class(TList)
  private
     fanalizefunc: TNotifyEvent;
     frtitems: TanalogMems;
     lastupdatetime: TdateTime;
    procedure SetItem(i: integer; item: PtAskItem);
    function GetItem(i: integer): PTAskItem;
    function FindMinLine (firstLine, LastLine: longInt): longInt;
    function getTryCount: integer;
    function getReadTimeOUT: integer;
    function getDirectTimeOUT: integer;
    function FindItemByAdr (adr: longInt): longInt;
  public
   NewItems: boolean;
   groupname: string;
   fComSet: TCOMSet;
   freqId: integer;
   //freq_in: integer;
   freqTime: TdateTime;
   freqDelay: integer;
   //freqDirectId: integer;
   fslave: integer;
   freqDirectTime: TdateTime;
   freqDirectDelay: integer;
   ProterrW: word;
   ProterrR: word;
   ftimeDirectActive: TdateTime;
   fDirectActive: integer;
   function needSync: boolean;
   function getcurblock(ID: integer): integer;
   property items[i: integer]: PTAskItem read getItem write setItem; default;
   procedure Insert(item: PTAskItem); //вставляем запись в сортированный список
   procedure DeleteByID(ID: integer); //удаляем запись по ID
   constructor create( comset: TCOMSet; _fslave: integer; _frtitems: TanalogMems);
   destructor destroy; override;
   procedure SetPrevValue (i: integer; val: longInt);
   function FindItem (ID: longInt): longInt;
   function FindItemByName (Name: string): LongInt;
   procedure AllInvalid;
   procedure Sort;
   function GetReport: boolean;
   function GetSyncTime: boolean;
   property analizefunc: TNotifyEvent read fanalizefunc write fanalizefunc;
   property TryCount: integer read getTryCount;
   property ReadTimeOUT: integer read getReadTimeOUT;
   property DirectTimeOUT: integer read getDirectTimeOUT;

  end;


  TMemoryMask = array [0 .. 1000000] of smallInt;
  PTMemoryMask = ^TMemoryMask;
  //TSlaves = array [1..SlaveCount] of integer;
  TGroupValid = array [1..GroupCount] of boolean;

  TServer = class ({TPLCComPort} TObject)
  private
    fstartAddr, fendAddr: integer;

    data: string;
    fvalid : integer;
    fGroupNumber: integer;
    bs: integer;
    fServerName: string;
    fRequestActive: boolean;
    fcurblock: integer;
   
    GroupErrCount: array [1..GroupCount] of integer;
    function GetItems(Group, addr: integer): smallInt;
    function GetItemsB(group, addr: integer): smallInt;
    function GetItemsD(group, addr: integer): longInt;
    function GetItemsBD(group, addr: integer): longInt;
    function GetItemsR(group, addr: integer): single;
    function GetValid: boolean;
    function ReadData: boolean;

  public
    frtItems : TanalogMems;
    serverinf: TInterfaceServer;
    constructor Create(AOwner: TComponent; comset: TCOMSet); overload;
    constructor Create(slavenum: integer; comset: TCOMSet); overload;
    destructor destroy; override;
    property groupNumber: integer read fgroupNumber write fGroupNumber;
    property ValidLevel: integer read fValid write fValid;
    property isValid: boolean read getValid;
    property items[Group, addr: integer]: smallInt read getItems; default;
    property itemsB[Group, addr: integer]: smallInt read getItemsB;
    property itemsD[Group, addr: integer]: longInt read getItemsD;
    property itemsBD[Group, addr: integer]: longInt read getItemsBD;
    property itemsR[Group, addr: integer]: single read getItemsR;
    procedure setcurBlock(val: integer);
    property ServerName: string read fServerName write fServerName;
    property RequestActive: boolean read fRequestActive write fRequestActive;

    function IsGroupValid(Group: integer): boolean;
    function InBlock(addr: integer): boolean;
    procedure UpdateData;
    function Open: boolean;
    procedure Close;
    procedure PLCwriteString (slaveNumber: byte; startAddress: integer; NewValue: string);
    procedure setCurCoSet(val: TComSet);
    function getProterrW():word;
    function getProterrR():word;
   // procedure SaveSettingsToFile (FN: string);

  end;


// класс  архивных меток
type TKoyoArchItems = class(TList)
  private
    frtitems: TanalogMems;
    fgrind: integer;
    fserver: tserver;
    
    procedure freeitem_;
    procedure SetItem(id: integer; item: PTKoyoArchItem);
    function  GetItem(id: integer): PTKoyoArchItem;
    procedure Log(mess: string; lev: byte = 2);
    procedure Sort;

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
    function  GetTag(id: integer): string;
    function  GetRtid(id: integer): integer;
    function  GetTabTime(id: integer): TdateTime;
    procedure SetTabTime(id: integer; val: TdateTime);
    procedure CheckNodata(id: integer);
    function  isLastPeriod(id: integer): boolean;
    function  setdata(res: TReportCol; tm: TDateTime): boolean;
  public
   function    NeedReq: boolean; // есть теги которые надо опрашивать
   function    MinTimeReq(var tm: TDateTime): boolean;  //максимальное метки время которое нужно опрашивать
                                       //чтение по строкам таблицы и потому ищем наиболее старый
   function    NeedReqItem(id: integer): boolean;
   procedure   WriteVal(id: integer; vl: single; tm: TDateTime);

   procedure   setnodataforabs(maxcnt: integer; tm: TDateTime; tonow: boolean = false);

   function    FindItemByIndex(nm: integer): integer;
   property    items[id: integer]: PTKoyoArchItem read getItem write setItem; default;
   function    addItem(id: integer): PTKoyoArchItem;
   constructor create(frtitems_: TanalogMems; server: tserver; grind: integer);
   destructor  destroy; override;

   function read: boolean;
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

  end;

type TKoyoArchDevItems = class(TList)
       private
         frtitems: TanalogMems;
         fserver: tserver;
         fcursor: integer;
         procedure SetItem(id: integer; item: TKoyoArchItems);
         function  GetItem(id: integer): TKoyoArchItems;
         function  FindByGrInd(id: integer): TKoyoArchItems;
       public
         function  readDevs: boolean;
         constructor create(frtitems_: TanalogMems; server: tserver);
         function    AddItems(id: integer;  grInd: integer): boolean;
         property    items[id: integer]: TKoyoArchItems read getItem write setItem; default;
       end;

implementation

// корректность архивной метки
function checkS_koyo(vl: string): boolean;
begin
    result:=false;
    vl:=trim(uppercase(vl));
    if length(vl)<3 then exit;
    if vl[1]<>'A' then exit;
    if vl[2]<>':' then exit;
    result:=true;
end;

// определение информации источника архивной метки
function GetInfo_koyo(vl: string; var num: integer; var typ: TConvType): boolean;
begin
    num:=-1;
    result:=false;
    typ:=ctArch;
    vl:=trim(uppercase(vl));
    if length(vl)<3 then exit;
    if vl[1]<>'A' then exit;
    if vl[2]<>':' then exit;
    num:=strtointdef(rightstr(vl,length(vl)-2),-1);
    if num>-1 then
    result:=true;
end;

{****************************TAscItems*****************************************}
constructor TAscItems.create( comset: TCOMSet; _fslave: integer; _frtitems: TanalogMems);
begin
  inherited create;
  frtitems:=_frtitems;
  freqId:=-1;
  //freqDirectId:=-1;
  NewItems := true;
  lastupdatetime:=0;
  fComSet:=ComSet;
  fslave:=_fslave;
  fanalizefunc:=nil;
end;

destructor TAscItems.destroy;
var i: integer;
begin

 clear;
inherited destroy;
end;


function TAscItems.getTryCount: integer;
begin
    result:=1;
    if (self.fComSet.trc>0) then
      result:=self.fComSet.trc;
end;

function TAscItems.getReadTimeOUT: integer;
begin
   result:=30;
    if (self.fComSet.frt>-1) then
      result:=self.fComSet.frt;
end;

function TAscItems.getDirectTimeOUT: integer;
begin
   result:=60;
    if (self.fComSet.frd>-1) then
      result:=self.fComSet.frd;
end;


function TAscItems.FindMinLine (firstLine, LastLine: longInt): longInt;
var
  i: integer;
begin
  result := firstLine;
  for i := firstLine + 1 to LastLine do
    if (Items[i].GroupNum < Items[result].GroupNum)  then result := i
    else
      if (Items[i].GroupNum = Items[result].GroupNum) and
         (Items[i].Addr < Items[result].Addr)  then result := i;
end;

procedure TAscItems.Sort;
var
  firstLine: integer;
begin
  for firstLine := 1 to Count - 1 do
    Exchange (firstLine, FindMinLine(firstLine, Count-1));
end;

function TAscItems.FindItem (ID: longInt): longInt;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if Items[i].ID = ID then
    begin
      result := i;
      exit;
    end;
end;

function TAscItems.FindItemByAdr (adr: longInt): longInt;
var
  i,min,max,cur: integer;
begin
  result := -1;
  min:=0;
  max:=Count - 1;
  if count<1 then exit;
  while((items[min].addr>adr) and (items[max].addr<adr)) do
    begin
       cur:=round((max+min)/2);
       if (items[cur].addr=adr) then
        begin
           result:=cur;
           exit;
        end;
        if (min+1)=max then exit;
        if items[cur].addr<adr then min:=cur else max:=cur;
    end;
end;

function TAscItems.FindItemByName (Name: string): LongInt;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if Items[i].name = Name then
    begin
      result := i;
      exit;
    end;
end;


procedure TAscItems.SetPrevValue (i: integer; val: longInt);
begin
  Items[i].prevValue := val;
end;

function TAscItems.GetItem(i: integer): PTaskItem;
begin
  result := inherited Items[i];
end;

procedure TAscItems.AllInvalid;
var i: integer;
begin
  for i:=0 to count-1 do
  if items[i].id>-1 then
    frtitems.ValidOff(items[i].id);
end;


function TAscItems.needSync: boolean;
begin
result:=false;
 if (HoursBetween(now,lastupdatetime)>1) then
                  begin
                    if lastupdatetime=0 then
                      begin
                        // синхронизация в середине часа
                        lastupdatetime:=normalizeHour(now);
                        if minuteof(now)>31 then
                        incHour(lastupdatetime,-1);
                        incMinute(lastupdatetime,30);
                       // result:=true;
                      end else
                      begin
                       // fserver.serverinf.setTimeSync(frtitems.TegGroups.items[self.fgrind].SlaveNum,now);
                        result:=true;
                        lastupdatetime:=now;
                      end;
                  end;
end;

procedure TAscItems.SetItem(i: integer; item: PtAskItem);
begin
  Items[i] := item;
end;

function TAscItems.GetReport: boolean;
begin
   result:=(fComSet.tstrt=1);
end;

function TAscItems.GetSyncTime: boolean;
begin
   result:=(fComSet.tstp=60);
end;

{*****************************TServer*********************************}
constructor TServer.Create(AOwner: TComponent; comset: TCOMSet);
var i: integer;
begin

  serverinf:=TPLCComPort.Create(AOwner,comset);
  serverinf.fcomset:=comset;
  for i:=0 to groupcount-1 do
  GroupErrCount[i]:=3;
 
  updateData;
end;


constructor TServer.Create(slavenum: integer; comset: TCOMSet);
var i: integer;
begin

  serverinf:=TEtherServer.Create(nil);
  comset.slave:=slavenum;
  serverinf.fcomset:=comset;
  for i:=0 to groupcount-1 do
  GroupErrCount[i]:=3;
 
  updateData;
end;

destructor TServer.destroy; 
begin
  serverinf.Destroy;
  inherited destroy;
end;


function TServer.ReadData: boolean;
var
  newData : string;
   numit: integer;
   i: integer;
   err_fl: boolean;
begin
  result := false;

    err_fl:=false;
    i:=0;
    serverinf.proterrR:=100;
    while ((i<=GroupErrCount[fGroupNumber]) and (serverinf.proterrR<>0)) do
    begin
    try
   // if serverinf is TEtherServer then
   // serverinf.PLCreadString1(frtitems.TegGroups.GetSlaveByNum(fGroupNumber), fStartAddr, bs , newData) else
    serverinf.PLCreadString1(frtitems.TegGroups.GetSlaveByNum(fGroupNumber), fStartAddr, bs*2 , newData);
    except
    sleep(100);
    serverinf.proterrR:=12345;
    end;
    inc(i);
    if ((serverinf.proterrR<>0) and ((serverinf.proterrR=1234) or (serverinf.proterrR=12345))) then
    begin
    self.frtItems.LogWarning('Read error count='+ inttostr(i)+'12345 1234 in iddev='+ inttostr(frtitems.TegGroups.GetSlaveByNum(fGroupNumber))+ ' in block '+inttostr(fStartAddr)+' bs='+inttostr(bs));
    err_fl:=true;
    end;
    end;
    if serverinf.proterrR=0 then
    begin
    GroupErrCount[fGroupNumber]:=3;
    if err_fl  then self.frtItems.Log('Read ok!',_DEBUG_MESSAGE);
    data := newData;
    fvalid:=100;
    result := true;
    exit;
    end
    else
    begin
    fvalid:=0;
    //self.frtItems.LogError('Read fails!!!!!!! count='+ inttostr(i)+' in iddev='+ inttostr(frtitems.TegGroups.GetSlaveByNum(fGroupNumber))+ ' in block '+inttostr(fStartAddr)+' bs='+inttostr(bs));
    if GroupErrCount[fGroupNumber]>1 then dec (GroupErrCount[fGroupNumber]);

    if fValid > 0 then dec (fValid);
    result:=false;

    end;
  //  result:=false;
   
  //  GroupErrCount[fGroupNumber] := 0;

 // except
  //  on E: Exception do
  //  begin
      //DEBUG.Log (E.Message);
     // inc(GroupErrCount[fGroupNumber]);

   //   raise;
  //  end;
 // end;
end;

function TServer.GetValid: boolean;
begin
  result := fvalid > 90;
end;

procedure TServer.UpdateData;//remaind asked data
begin
  fstartAddr := -1;
  fEndAddr := -1;
end;

function TServer.GetItems(group, addr: integer): smallInt;
begin
  if GroupNumber <> Group then
  begin
    GroupNumber := Group;
    UpdateData;
  end;
  result := 0;
  if not InBlock(addr) then
  begin
    if (self.fcurblock>2)  and (self.fcurblock<128) then
      begin
          bs:=self.fcurblock;
      end else bs:=64;
    fStartAddr := addr;
    fEndAddr := addr + bs - 1;
    readData;

  end;
  if isValid then
    begin
   //if length()
    result := PTMemoryMask(data)^[addr-fstartAddr];
    end;
end;

function TServer.GetItemsB(Group, addr: integer): smallInt;
begin
  result := BCDtoBIN(Items[group, addr]);
end;

procedure TServer.setcurBlock(val: integer);
begin
  self.fcurblock:=val;
end;

function TServer.GetItemsD(group, addr: integer): longInt;
begin
  PSmallInt(@PChar(@result)[0])^ := Items[group, addr];
  PSmallInt(@PChar(@result)[2])^ := Items[group, addr+1];
end;

function TServer.GetItemsR(group, addr: integer): single;
var k:  single;
begin

    PSingle(@PChar(@result)[2])^ := Items[group, addr];
    PSingle(@PChar(@result)[0])^ := Items[group, addr+1];

end;

function TServer.GetItemsBD(group, addr: integer): longInt;
begin
  result := BintoBCD(ItemsD[group, addr]);
end;

function TServer.InBlock(addr: integer): boolean;
begin
  result := (fstartAddr <= addr) and (addr <= fEndAddr - 1);
end;

function TServer.Open: boolean;
begin
  serverinf.ReadSettings;
  result:=serverinf.Open;
end;

procedure TServer.close;
begin
  serverinf.close;
end;

function TServer.getProterrW():word;
begin
   result:=serverinf.ProterrW;
end;

function TServer.getProterrR():word;
begin
   result:=serverinf.ProterrR;
end;


procedure TServer.PLCwriteString (slaveNumber: byte; startAddress: integer; NewValue: string);
begin
  serverinf.PLCwriteString (slaveNumber, startAddress, NewValue);
end;

procedure TServer.setCurCoSet(val: TComSet);
begin
   serverinf.setComset(val);
end;




function TServer.IsGroupValid(Group: integer): boolean;
begin
  result := (GroupErrCount[Group] > 0);
end;

procedure TAscItems.Insert(item: PTAskItem);
var
  i, k: integer;
begin
 k := count;
 for i := 0 to count - 1 do
    if (Items[i].GroupNum > item.GroupNum)  then
    begin
      k := i;
      break;
    end
    else
      if (Items[i].GroupNum = Item.GroupNum) and
         (Items[i].Addr > Item.Addr)  then
      begin
        k := i;
        break;
      end else
        if (Items[i].GroupNum = Item.GroupNum) and
           (Items[i].Addr = Item.Addr)  and
           (Items[i].BitNumber > Item.BitNumber) then
        begin
        k := i;
        break;
      end;
   //Большего элемента нет, поищем раный...
   if (k <> 0) and (Items[k-1].id = Item.id) then
     dispose(Item)//Уничтожаем дубликат
   else begin
       inherited insert(k, item);
   end;
end;

procedure TAscItems.DeleteByID(ID: integer);
var
  i: integer;

begin
 for i := 0 to count - 1 do
   if Items[i].id = ID then
   begin
     dispose(Items[i]);
     inherited delete(i);
     exit;
   end;
end;

function TAscItems.getcurblock(ID: integer): integer;
var
  i: integer;

begin
i:=id+1;
result:=4;
{while ((i<count) and ((items[i].addr-self.fComSet.bs+1)<items[id].addr)) do
  begin
      if items[i].activ then
       result:=items[i].addr-items[id].addr+1;
      inc(i);
  end; }
  result:=self.fComSet.bs;
  if result<4 then result:=4;
end;


{****************************TKoyoArchItems**************************************}

constructor TKoyoArchItems.create(frtitems_: TanalogMems; server: tserver; grind: integer);
begin
  inherited create;
  frtitems:=frtitems_;
  fgrind:=grind;
  fserver:=server;

end;

destructor TKoyoArchItems.destroy;
begin
self.freeitem_;
clear;
inherited destroy;
end;

//  проверяет является ли опрашиваемый период последним
//  нет -  данных отчетного и правда  не существует
//  да  -  ничего не делает, ждет данные дальше
procedure TKoyoArchItems.CheckNodata(id: integer);
begin
  if not isLastPeriod(id) then
    begin
      frtitems.Items[items[id].ID].TimeStamp:=ReqTime2[id];
    end  else
    State[id]:=REPORT_NEEDWAIT;
end;


function TKoyoArchItems.isLastPeriod(id: integer): boolean;
begin
  result:=(ReqTime2[id]>now);
end;








function TKoyoArchItems.GetItem(id: integer): PTKoyoArchItem;
begin
  result := inherited Items[id];
end;

procedure TKoyoArchItems.SetItem(id: integer; item: PTKoyoArchItem);
begin
  Items[id] := item;
end;


function  TKoyoArchItems.FindItemByIndex(nm: integer): integer;
var x1, x2, temp: integer;
begin
  result := -1;
  if count=0 then exit;
  x1:=0;
  x2:=count-1;
  if Items[x1].index>nm then exit;
  if Items[x2].index<nm then exit;
  while (x1<>x2) do
    begin
      if Items[x1].index=nm then
       begin
         result:=x1;
         exit;
       end;
      if Items[x2].index=nm then
       begin
         result:=x2;
         exit;
       end;
       if (x2-x1)=1 then exit;
       temp:=(x2+x1) div 2;
       if (Items[temp].index>nm) then
         x2:=temp else x1:=temp;
    end;
end;


function  TKoyoArchItems.addItem(id: integer): PTKoyoArchItem ;
var  col_num , findid,l: integer;
     convtyp: TConvType;
     it: PTKoyoArchItem;
     typ_: integer;
     name_: string;

begin
  result:=nil;
   if id<0 then exit;
   if frtitems[id].ID<0 then exit;

   typ_:=frtitems[id].logTime;
   name_:=frtitems.GetName(id);

     begin
       if not checkS_koyo(trim(uppercase(frtitems.GetDDEItem(id)))) then
          begin
           log('Mетка nm:='+frtitems.GetName(id)+', id='+ inttostr(id) +
            ' не добавлена. Источник '+frtitems.GetDDEItem(id)+' содержит некорректные символы!',_DEBUG_ERROR);
          end;

       if GetInfo_Koyo(frtitems.GetDDEItem(id),col_num ,convtyp) then
          begin

                   findid:=FindItemByIndex(col_num);
                   if findid<0 then
                   begin
                   new(it);
                   it.name:=name_;
                   it.ID:=id;
                   it.convtyp:=convtyp;
                   it.index:=col_num;
                   Add(it);
                   it.error:=0;
                   it.minRaw:=frtitems[id].MinRaw;
                   it.maxRaw:=frtitems[id].MaxRaw;
                   it.minEU:=frtitems[id].MinEU;
                   it.maxEU:=frtitems[id].MaxEU;
                   result:=it;
                   Sort;
                   frtitems[id].ValidLevel:=REPORT_NEEDKHOWDEEP;
                   end else
                   begin

                    log('Архивная метка  не добавлена nm:='+frtitems.GetName(id)+' источник source='+frtitems.GetDDEItem(id)+
                      ' Имеет дупликат!',_DEBUG_ERROR);
                    exit;

                   end;
          end;



     end ;

end;


procedure TKoyoArchItems.Sort;
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
        if items[i].index>items[i+1].index
               then begin
                  fl:=true;
                  Move(i,i+1);
                  break;
                  end;
      end;
   end;

end;


procedure TKoyoArchItems.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;



function  TKoyoArchItems.GetTyp(id: integer): integer;
begin
   result:=items[id].typ;
end;


function  TKoyoArchItems.GetDeep(id: integer): integer;
begin
  result:=items[id].deep;
end;


function  TKoyoArchItems.GetDelt(id: integer): integer;
begin
  result:=items[id].delt;
end;

function  TKoyoArchItems.GetVal(id: integer): real;
begin
   result:=frtitems[Items[id].id].ValReal;
end;

procedure  TKoyoArchItems.SetVal(id: integer; vals: real);
begin
   frtitems[Items[id].id].ValReal:=vals;
end;




function  TKoyoArchItems.GetTag(id: integer): string;
begin
   result:=Items[id].name;
end;

function  TKoyoArchItems.GetRtid(id: integer): integer;
begin
  result:=Items[id].id;
end;

function  TKoyoArchItems.GetTabTime(id: integer): TdateTime;
begin
   result:=(round(frtitems[Items[id].id].TimeStamp*24)*1.0)/24;
end;

procedure  TKoyoArchItems.SetTabTime(id: integer; val: TdateTime);
begin
   frtitems[Items[id].id].TimeStamp:=val;
   Items[id].tmreq:=GetTimeReqByTabTime(val,Typ[id],0) ;
end;


function  TKoyoArchItems.GetReqTime1(id: integer): TdateTime;
var vdt: TDateTime;

begin

   vdt:=frtitems[Items[id].id].TimeStamp;
   vdt:=incPeriod(typ[id],vdt,0);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[id],delt[id]);
end;

function  TKoyoArchItems.GetReqTime2(id: integer): TdateTime;
var vdt: TDateTime;
    l,tmp: integer;
begin


   vdt:=frtitems[Items[id].id].TimeStamp;
   for l:=0 to 1 do
   vdt:=incPeriod(typ[id],vdt,1);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[id],delt[id]);
   result:=min(result,incminute (incPeriod(typ[id],now,0),1));
end;



procedure TKoyoArchItems.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
     begin
     //setlength(items[i].ID,0);
     //setlength(items[i].buffer,0);
     dispose(items[i]);
     end;
end;

procedure TKoyoArchItems.SetState(id: integer; state: integer);
begin
   //if items[id].reqType<>rtArchive then exit;
   case state of
       REPORT_NEEDWAIT:  frtitems[RtId[id]].ValidLevel:=REPORT_NEEDWAIT;
       REPORT_NEEDKHOWDEEP:  frtitems[RtId[id]].ValidLevel:=REPORT_NEEDKHOWDEEP;
       REPORT_DATA:       frtitems[RtId[id]].ValidLevel:=REPORT_DATA;
       REPORT_NODATA:     frtitems[RtId[id]].ValidLevel:=REPORT_NODATA;
   end;
end;

function  TKoyoArchItems.GetState(id: integer): integer;
var res: integer;
begin
   // if items[id].reqType<>rtArchive then exit;
    result:=REPORT_NOACTIVE;
    if (RtId[id]>0) then
       begin
         res:=frtitems[RtId[id]].ValidLevel;
         if (res in [REPORT_NOACTIVE,REPORT_NEEDKHOWDEEP,
         REPORT_NEEDREQUEST,REPORT_NORMAL,REPORT_NODATA,REPORT_DATA]) then
         result:=res else result:=REPORT_NOACTIVE;
       end;

end;

function  TKoyoArchItems.NeedReq: boolean;
var i: integer;
begin
  result:=false;
  for i:=0 to count-1 do
    if State[i]=REPORT_NEEDREQUEST then
      begin

        result:=true;
        exit;
      end;

end;

function  TKoyoArchItems.NeedReqItem(id: integer): boolean;
begin
    result:=false;
    if id>=count then exit;
    if State[id]=REPORT_NEEDREQUEST then
      begin
        result:=true;
        exit;
      end;

end;

procedure  TKoyoArchItems.WriteVal(id: integer; vl: single; tm: TDateTime);
var i: integer;
    rt_t: double;
begin
    if id>=count then exit;
    rt_t:=round(tm*24)*1.0/24;
    if Tabtime[id]<=rt_t then
      begin
        SetVal(id,vl);
        if Tabtime[id]<>rt_t then
        Tabtime[id]:=rt_t;
        State[id]:=REPORT_DATA;
      end;

end;


// только внутри needreq  !!!!!
function  TKoyoArchItems.MinTimeReq(var tm: TDateTime): boolean;
var i: integer;
begin
  result:=false;
  tm:=now+100;
  for i:=0 to count-1 do
    if State[i]=REPORT_NEEDREQUEST then
      begin
        result:=true;
        if TabTime[i]<tm then
         tm:=TabTime[i];
      end;
  exit;
end;

function TKoyoArchItems.read: boolean;
var tm_req: TDateTime;
    res: TReportCol;
    tmp: integer;
begin
   if NeedReq then
     begin
       if MinTimeReq(tm_req) then
         begin
           if (fserver<>nil) and (fserver.serverinf<>nil) and (fgrind>-1) then
              begin
                try

                setlength(res,0);
                if fserver.serverinf.Readreport(frtitems.TegGroups.items[self.fgrind].SlaveNum,
                tm_req,res) then
                  begin
                    if length(res)>0 then
                      begin
                        setdata(res,tm_req);
                      end else
                      begin
                        // нет данных
                        setnodataforabs(0,tm_req);
                      end
                  end;



               
                finally
                 setlength(res,0);
                end;
              end;

         end;
     end;
end;

function TKoyoArchItems.setdata(res: TReportCol; tm: TDateTime): boolean;
var i, findind: integer;
begin
     for i:=0 to length(res)-1 do
      begin
       findind:=self.FindItemByIndex(i);
       if (findind>-1) then
       begin
       if NeedReqItem(findind) then
            WriteVal(findind,res[i],tm);
       end;
      end;
      setnodataforabs(length(res),tm,true);
end;


//  если номер в таблице выходит за пределы полученного с контролера
//  прописываем nodata
procedure TKoyoArchItems.setnodataforabs(maxcnt: integer; tm: TDateTime; tonow: boolean = false);
var i, findind: integer;
begin
     tm:=normalizeHour(tm);
     for i:=0 to count-1 do
      begin
       if NeedReqItem(i) then
          if Tabtime[i]<=tm then
            if items[i].index>=maxcnt then
             begin
              State[i]:=REPORT_NODATA;
              if tonow then Tabtime[i]:=normalizeHour(now)
              else
               begin
               if Tabtime[i]<>tm then
                 Tabtime[i]:=tm;
               end;
             end;
      end;
end;




constructor TKoyoArchDevItems.create(frtitems_: TanalogMems; server: tserver);
begin
  inherited create;
  frtitems:=frtitems_;
  fserver:=server;
  fcursor:=0;
end;


procedure TKoyoArchDevItems.SetItem(id: integer; item: TKoyoArchItems);
begin
   Items[id] := item;
end;

function  TKoyoArchDevItems.GetItem(id: integer): TKoyoArchItems;
begin
    result := inherited Items[id];
end;

function  TKoyoArchDevItems.AddItems(id: integer; grInd: integer): boolean;
var grn, slvn: integer;
    tmp: TKoyoArchItems;
begin
   result:=false;
   if grInd<0 then exit;
   if frtitems[id].ID<0 then exit;
   slvn:=frtitems.TegGroups.items[grInd].SlaveNum;
   tmp:=FindByGrInd(grInd);
   if tmp=nil then
    begin
     tmp:=TKoyoArchItems.create(frtitems, fserver,grInd);
     self.Add(tmp);
    end;
    if tmp=nil then exit;
    tmp.addItem(id);
end;

function  TKoyoArchDevItems.readDevs: boolean;
begin
   result:=false;
   if count=0 then exit;
   if fcursor<count then
    begin
      result:=items[fcursor].read;
    end;
   fcursor:=fcursor+1;
   fcursor:=min((count-1),fcursor);
end;

function  TKoyoArchDevItems.FindByGrInd(id: integer): TKoyoArchItems;
var i: integer;
begin
   result:=nil;
   for i:=0 to Count-1 do
    begin
      if items[i].fgrind=id then
        begin
          result:=items[i];
          exit;
        end;
    end;
end;

end.
