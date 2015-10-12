unit DDEClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DDEml,MemStructsU, Grids;
type TItemDDE   = record
      id: integer;
      rtid: array of Integer;
      count: integer;
      name: string;
      topic: string;
      server: string;
      val: real;
      vals: string;
      valid: integer;
      servHandle: integer;
     // dat: HDDEDATA;
     // MinEU: real;
    //  MaxEU: real;
      err: integer;
      Activ: integer;
      ChangeActiv: boolean;
      connected: boolean;
      end;



type

TRiID_ItIDStub =record
    rtID: integer;
    itID: integer;
    ServHandle: integer;
    end;



PTItemDDE = ^TItemDDE;

  TItemDDEArray = array[1..1000000]of TItemDDE;
  PTItemDDEArray = ^TItemDDEArray;

type
   CallbackDDE = function (CallType, Fmt : UINT; Conv: HConv; hsz1, hsz2: HSZ;
   Data: HDDEData; Data1, Data2: DWORD): HDDEData; stdcall;

 TDDEServlist = class(TStringList);

 TDDETopiclist = class(TStringList)
    public
    nameserver: String;
    constructor Create(server: string);
   end;

 TDDETopicItem = class(TObject)
    public
    nametopic: String;
    nameserver: String;
    constructor Create(name: string; server: string);

   end;






type
TItemDDEs = class(TList)
  private
    m_rtItemsId: array of TRiID_ItIDStub;
    m_rtItemsCount: integer;
    wild: boolean;
    fHszTopic: HSZ;
    server: string;
    fRequestActive: boolean;
    fThrtItems: TAnalogMems;
    DdeInstId: longint;



    procedure disconnectALLandClear;
    procedure SetItem(i: integer; item: PTItemDDE);
    function  GetItem(i: integer): PTItemDDE;

    function  binFindItemByHandle (ID: longInt): integer;
    function  FindItemByHandle (ID: longInt): longInt;
    function  FindItIdByRTid(id: integer): integer;
    function  FindItemByParam (servern: string; topicn: string; namen:string): integer;
    procedure AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
    procedure RtExchache(in1, to1, in2, to2: integer);
    procedure Sort;

    procedure SetItemVal (ID: longInt; Data: HDDEData);
    procedure SetItemValid (ID: longInt);
    procedure SetItemInValid(ID: longInt);
    procedure SetItemValD(ID: longInt; val: real);
    procedure setRequestActiv(val: boolean);
    function  RefreshActivStateforTopic(val: boolean): boolean;


    function  GetConnected: boolean;

    procedure connectItem(id: integer);
    procedure disconnectItem(id: integer);

    function ExecuteCommand(id: integer ; val: real): boolean;
    function ReadDrectItem(id: integer;var val: real):  integer;
    function StoreData(DdeDat: HDDEData): string;

    procedure FreeAllItem;

  public
   topic: string;
   conv: HConv;
   
   constructor create(FDdeInstId: longint;val: TAnalogMems; topicn: string;servern: string; rtIt: TAnalogMems);
   destructor destroy; override;

   function GetTabCount: integer;
   procedure addItem(name: string; server: string; topic: string; num: integer; connect: boolean);

   property  RequestActive: boolean read fRequestActive write setRequestActiv;
   property  Connected: boolean read GetConnected;
   property  items[i: integer]: PTItemDDE read getItem write setItem; default;

  end;



  TServInfos = class(TList)
  private
    DdeInstId: Longint;
    fHszApp: HSZ;
    server: string;
    fThRtitems: TanalogMems;
    procedure SetItem(i: integer; item: TItemDDEs);
    function  GetItem(i: integer): TItemDDEs;

    procedure addItem(name: string; server: string; topic: string; num: integer; connect: boolean);
    function  addTopic(topic: string): TItemDDEs;
    function  FindTopic(topic: string):TItemDDEs;
    function  FindItem (conv: HConv): TItemDDEs;
    procedure ConnectAllActivTopic;
    procedure DisConnectAllActivTopic;
  public

   constructor create(FDdeInstId: Longint; servern: string; rtIt: TAnalogMems);
   destructor  destroy; override;

   function setconnectbyAppId: Longint;
   function disconnectbyConv(convs: HConv): Longint;

   property items[i: integer]: TItemDDEs read getItem write setItem; default;

  end;


type
  TDDEClient = class(TThread)
  private
    isAdding: boolean;
    itList: Titemddes;
    Context: TConvContext;
    curitem: integer;
    FDdeInstId : Longint;
    finit: boolean;
    FCnvInfo: TConvInfo;
    fThrtItems: TanalogMems;
    serverlist: TstringList;
    fpath: string;
    fserverinit, fclientinit: boolean;
    fAnalizeFunction: TNotifyEvent;
    Fanalizeobj:  Tobject;
    procedure OpenLink;
    procedure CloseLink;

    function  GetInit: boolean;
    procedure InitVar;
    procedure UnInitVar;
    procedure ClearItems;

    function  RefreshActivState: boolean;
    procedure iteminReq_;
    procedure itemfromReq_;
    procedure itemfromReq(Itid: integer; itli: Titemddes);
    procedure iteminReq(Itid: integer; itli: Titemddes);

    procedure ConnectAllActivServer;
    function  UnRegisterServ (id: HConv): LongInt;
    function  RegisterServ (id: HConv): LongInt;
    function  AddServer(servern: string): TServInfos;
    function  GetServer(servern: string): TServInfos;

    function findAppByAppId(id: HSZ): TServInfos;
    function FindByConv(conv: HConv): TItemDDEs;
    function FindListByrtId(rtId: integer; var ItId: integer): TItemDDEs;

    procedure SetItemVal (ID: longInt; conv: HConv; Data: HDDEData);

    procedure setAnalizeFunction(val: TNotifyEvent);
    procedure Analize_;
    { Private declarations }
  public
     isExecuted: boolean;
     PredLastCommand : integer;
     constructor Create(frtpath: string);
     destructor  Destroy;



     procedure Execute; override;
     procedure AddItems;
     procedure Analize;
     procedure DoRW;

     property  Init: boolean read GetInit;
     property  AnalizeFunction: TNotifyEvent read fAnalizeFunction write setAnalizeFunction;

     function SetAnObjectT(servern: string; topicn: string): TObject;
     function SetAnObjectA(servern: string): TObject;

  end;



function isDDE(val: string; var host: string; var topic: string): string;



var ddecl: TDDEClient;

implementation

function isDDE(val: string; var host: string; var topic: string): string;
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
    derpos: integer;
begin
   result:='';
   host:='';
   topic:='';
   val:=trim(val);
   if val='' then exit;
   result:=trim(getinVstring(val,'DDE'));
   if result<>'' then
    begin
       derpos:=pos('|',result);
       if (derpos>0) then
         begin
            if (derpos<length(result)) then
            topic:=trim(copy(result,derpos+1,length(result)-derpos));
            result:=trim(copy(result,1,derpos-1));
         end;
    end;
   if ((result<>'') and (val<>'')) then
     begin
       tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);

         tempval:=getinVstring(val,'');
       if (tempval<>'') then
       if (length(tempval)>5) and (uppercase(copy(tempval,1,5))='HOST:')
               then host:=copy(tempval,6,length(tempval)-5);

     end;
end;

Function iscorrect(val: string): boolean;
var i: integer;
begin
   result:=false;
   val:=uppercase(trim(val));
     for i:=1 to length(val) do
       if not (((byte(val[i])>47) and (byte(val[i])<57)) or
            ((byte(val[i])>64) and (byte(val[i])<91))) then  exit;
    result:=true;
end;


function DdeMgrCallBack(CallType, Fmt : UINT; Conv: HConv; hsz1, hsz2: HSZ;
  Data: HDDEData; Data1, Data2: DWORD): HDDEData; stdcall;
var
  ci: TConvInfo;
  ddeCli: TComponent;
  ids: integer;
  ddeObj: TComponent;
  xID: DWORD;
  Len: Longint;
  dataval: string;

begin
  Result := 1;
  case CallType of
    XTYP_CONNECT:
      Result := 1;//HDdeData(ddeMgrs.AllowConnect(hsz2, hsz1));
    XTYP_WILDCONNECT:
      Result := 1;//ddeMgrs.AllowWildConnect(hsz2, hsz1);
    XTYP_CONNECT_CONFIRM:
       Result := 1;//ddeMgr.Connect(Conv, hsz1, Boolean(Data2));
  end;

    case CallType of
      XTYP_ADVREQ:
        begin
         // ddeSrv := TDdeSrvrConv(ci.hUser);
         // Result := ddeSrv.RequestData(Conv, hsz1, hsz2, Fmt);
        end;
      XTYP_REQUEST:
        begin
      //    ddeSrv := TDdeSrvrConv(ci.hUser);
       //   Result := ddeSrv.RequestData(Conv, hsz1, hsz2, Fmt);
        end;
      XTYP_ADVSTOP:
        begin
        //  ddeSrv := TDdeSrvrConv(ci.hUser);
        //  ddeSrv.AdvStop(Conv, hsz1, hsz2);
        end;
      XTYP_ADVSTART:
        begin
         // ddeSrv := TDdeSrvrConv(ci.hUser);
        //  Result := HDdeData(ddeSrv.AdvStart(Conv, hsz1, hsz2, Fmt));
        end;
      XTYP_POKE:
        begin
      //    ddeSrv := TDdeSrvrConv(ci.hUser);
       //   Result := HDdeData(ddeSrv.PokeData(Conv, hsz1, hsz2, Data, Fmt));
        end;
      XTYP_EXECUTE:
        begin
      //    ddeSrv := TDdeSrvrConv(ci.hUser);
       //   Result := HDdeData(ddeSrv.ExecuteMacro(Conv, hsz1, Data));
        end;
      XTYP_XACT_COMPLETE:
        begin
      //    ddeCli := TComponent(ci.hUser);
       //   if ddeCli <> nil then TDdeClientConv(ddeCli).XactComplete
        end;
      XTYP_ADVDATA:
        begin

       ddecl.SetItemVal(hsz2,Conv,data);
        end;
      XTYP_DISCONNECT:
        begin
        ddecl.UnRegisterServ(Conv);
          end;
      XTYP_REGISTER:
        begin
        ddecl.RegisterServ(hsz1);
          end;
  end;
end;


constructor TDDETopicItem.Create(name: string; server: string);
begin
   self.nametopic:=uppercase(name);
   self.nameserver:=uppercase(server);
   inherited Create;
end;

constructor TDDETopicList.Create(server: string);
begin
   self.nameserver:=uppercase(server);
   inherited Create;
end;


{----------TServInfos------------}

constructor TServInfos.create(FDdeInstId: longint; servern: string; rtIt: TAnalogMems);
var   CharVal: array[0..255] of Char;
begin
inherited create;
DdeInstId:=FDdeInstId;
server:=trim(uppercase(servern));
StrPCopy(CharVal, server);
FHszApp := DdeCreateStringHandle(DdeInstId, CharVal, CP_WINANSI);
fThRtitems:=rtIt;
end;

destructor TServInfos.destroy;
begin
DDEFreeStringHandle(DdeInstId,FHszApp);
while (count>0) do
begin
   self.Delete(0);
end;
inherited;
end;

procedure TServInfos.SetItem(i: integer; item: TItemDDEs);
begin
 Items[i] := item;
end;

function TServInfos.GetItem(i: integer): TItemDDEs;
begin
   result := inherited Items[i];
end;



function TServInfos.setconnectbyAppId: Longint;
var fit: Longint;
    i,j: integer;
    Context: TConvConText;
begin
   result:=0;
     for i:=0 to count-1 do
  //   if (fHszApp=id) then
       begin
         FillChar(Context, SizeOf(Context), 0);
         with Context do
         begin
           cb := SizeOf(TConvConText);
           iCodePage := CP_WINANSI;
         end;
       items[i].conv:=DdeConnect(DdeInstId, fHszApp, items[i].fHszTopic, @Context);
       if (items[i].conv<>0) then
         begin
           for j:=0 to items[i].Count-1 do
                   if (items[i].items[j].Activ>0) then items[i].connectItem(j);
         end;
     //   items[i].connected:=(items[i].conv<>0);
       result:=items[i].conv;
       end;
end;



function TServInfos.disconnectbyConv(convs: HConv): Longint;
var fit: Longint;
    i,j: integer;
    Context: TConvConText;
begin
   result:=0;
  for i:=0 to count-1 do
     if (items[i].conv=convs) then
       begin
         FillChar(Context, SizeOf(Context), 0);
         with Context do
         begin
           cb := SizeOf(TConvConText);
           iCodePage := CP_WINANSI;
         end;
        if (items[i].conv<>0) then
         begin
           for j:=0 to items[i].Count-1 do
             items[i].disconnectItem(j);
         end;
         DdeDisconnect(items[i].conv);
         items[i].conv:=0;
       //  items[i].connected:=false;
       end;
end;

procedure TServInfos.ConnectAllActivTopic;
 var i,j: integer;
begin
   for i:=0 to count-1 do
   if (items[i].conv<>0) then
         begin
           for j:=0 to items[i].Count-1 do
             items[i].connectItem(j);
         end;
end;

procedure TServInfos.DisConnectAllActivTopic;
 var i,j: integer;
begin
   for i:=0 to count-1 do
   if (items[i].conv<>0) then
         begin
           for j:=0 to items[i].Count-1 do
             items[i].disconnectItem(j);
              items[i].conv:=0;
         end;
end;



function TServInfos.FindItem (conv: HConv): TItemDDEs;
var  i: integer;
begin
result:=nil;
   for i:=0 to count-1 do if (items[i].conv=conv) then result:=items[i];
end;



procedure TServInfos.addItem(name: string; server: string; topic: string; num: integer; connect: boolean);
var itlist:  TItemDDEs;
begin
   itlist:=findTopic(topic);
   if (findTopic(topic)=nil) then
        itlist:=addTopic(topic);
   if itlist=nil then exit;
   itlist.addItem(name,server,topic,num,connect);
end;

function TServInfos.addTopic(topic: string):TItemDDEs;
var i: integer;
    newlist:  TItemDDEs;
begin
result:=nil;
for i:=0 to count-1 do
      if items[i].topic=trim(uppercase(topic)) then
        begin
           result:=TItemDDEs(items[i]);
           exit;
        end;
newlist:=TItemDDEs.create(self.DdeInstId,nil,topic,server,fThRtitems);
add(newlist);
result:=newlist;
end;

function TServInfos.findTopic(topic: string):TItemDDEs;
var i: integer;
begin
result:=nil;
for i:=0 to count-1 do
      if items[i].topic=trim(uppercase(topic)) then
        begin
           result:=TItemDDEs(items[i]);
           exit;
        end;
end;




{----------TItemDDEs------------}

constructor TItemDDEs.create(FDdeInstId: longint;val: TAnalogMems; topicn: string; servern: string; rtIt: TAnalogMems);
 var   CharVal: array[0..255] of Char;
begin
  inherited create;
  fthrtitems:=val;
  m_rtItemsCount:=0;
  topic:=trim(uppercase(topicn));
  server:=trim(uppercase(servern));
  DdeInstId:=FDdeInstId;
  StrPCopy(CharVal, topic);
  wild:=true;
  FHszTopic := DdeCreateStringHandle(DdeInstId, CharVal, CP_WINANSI);
  fThRtitems:=rtIt;
end;

destructor TItemDDEs.destroy;
begin
DDEFreeStringHandle(DdeInstId,FHszTopic);
setLength( m_rtItemsId,0);
disconnectALLandClear;
inherited destroy;
end;

procedure TItemDDEs.disconnectALLandClear;
var i: integer;
begin
for i:=0 to count-1 do if (items[i].activ>0) then disconnectItem(i);
for i:=0 to Count-1 do
     begin
       setlength(items[i].rtid,0);
       dispose(items[i])
     end;
while (count>0) do
begin
   Delete(0);
end;
end;

function TItemDDEs.GetConnected: boolean;
begin
    result:=(conv<>0);
end;


procedure TItemDDEs.addItem(name: string; server: string; topic: string; num: integer; connect: boolean);
var FHszItem: HSZ;
    ddeRslt: LongInt;
    hdata: HDDEData;
    it: PTItemDDE;
    lConv: longint;
    i,j: integer;
    dest: array of integer;
begin
    if (true) then
    begin
      i:=FindItemByParam(server,topic,name);
      if (i<0) then
      begin
      new(it);
      it.id:=count;
      it.name:=name;
      it.valid:=0;
      it.val:=0;
      setLength(it.rtid,1);
      it.rtid[0]:=num;
      it.topic:=trim(topic);
      it.server:=trim(server);
      it.connected:=false;
      setLength(it.rtid,1);
      it.count:=1;
      FHszItem := DdeCreateStringHandle(DdeInstId, PChar(name), CP_WINANSI);
      it.servHandle:=FHszItem;
      if self.fThrtItems.Items[num].refCount>0 then
      it.activ:=1 else it.activ:=0;
      it.err:=999;
      i:=Add(it);
      it.ChangeActiv:=true;
      end else
      begin
        it:=items[i];
         if self.fThrtItems.Items[num].refCount>0 then
        it.activ:=it.activ+1;
        setLength(dest,it.count);
        for j:=0 to it.count-1 do dest[j]:=it.rtid[j];
        it.count:=it.count+1;
        setLength(it.rtid,it.count);
        for j:=0 to it.count-2 do it.rtid[j]:=dest[j];
        it.rtid[it.count-1]:=num;
      end;
      AddRtIDandSort(num,count-1,0);
      Sort;
    end;
end;

procedure TItemDDEs.AddRtIDandSort(rtId: integer; iTId: integer; servHdl: integer);
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

procedure TItemDDEs.RtExchache(in1, to1, in2, to2: integer);
var
    i: integer;
begin
     for i:=0 to m_rtItemsCount-1 do
      begin
        if m_rtItemsId[i].itId=in1 then m_rtItemsId[i].itId:=to1 else
             if m_rtItemsId[i].itId=in2 then m_rtItemsId[i].itId:=to2;
      end;

end;

procedure TItemDDEs.connectItem(id: integer);
var
    ddeRslt: LongInt;
    hdata: HDDEData;
    val: real;
    i: integer;
    res: integer;
begin
     if ((id>-1) and (id<count)) then
     begin

     //res:=ReadDrectItem(id,val);
     //if res<>0 then
     //  begin
       //  items[id].err:=res;
      //   exit;
      // end else
     //  items[id].err:=0;
   //  if (items[id].Activ=0) and (not self) then exit;
     if (wild) then
     begin
     if ((conv<>0) and (wild)) then
     begin

     DdeClientTransaction(nil, DWORD(-1), conv, items[id].servHandle,
      1, XTYP_ADVSTART {or XTYPF_NODATA}, TIMEOUT_ASYNC, @ddeRslt);

     end;
     end;
     items[id].connected:=true;
  //    items[id].activ:=1;
     // if ((items[id].rtid[0]>-1) and
     //      (fThrtItems.Items[items[id].rtid[0]].id>-1)) then fThrtItems.SetValid(items[id].rtid[0],0);
     end;
end;

function TItemDDEs.ReadDrectItem(id: integer;var val: real): integer;
var
    ddeRslt: LongInt;
    hdata: HDDEData;
    pData: Pointer;
    Len: Integer;
    i: integer;
    res: Pchar;
    hItem: HSZ;
begin
     //result:=false;
     val:=0;
     result:=0;
     if ((id>-1) and (id<count)) then
     begin
    hItem := DdeCreateStringHandle(DdeInstId, PChar(items[id].name), CP_WINANSI);
     if (conv<>0) then
     begin
     hdata:=DdeClientTransaction(nil, DWORD(-1), conv, items[id].servHandle,
      1, XTYP_REQUEST, 100, @ddeRslt);
    //if (items[id].dat=0) then items[id].dat:= hdata else hdata:=items[id].dat;
     end;
     if hData <> 0 then
     try
      pData := DdeAccessData(hData, @Len);
      if pData <> nil then
      try
        Res := StrAlloc(Len + 1);
        system.move(pData^, Res^, len);    // data is binary, may contain nulls
        Res[len] := #0;
        try
        val:=strtofloat(trim(res));
        result:=0;
        except
        result:=1;
        end;
      finally
        DdeUnaccessData(hData);
      end;
      finally
      DdeFreeDataHandle(hData);
      end else
      result:=2;
   end;
end;

procedure TItemDDEs.disconnectItem(id: integer);
var
    ddeRslt: LongInt;
    hdata: HDDEData;

    i: integer;
begin
     if ((id>-1) and (id<count)) then
    if self.fRequestActive then exit;
     if (wild) then
     begin
     if ((conv<>0) and (wild))then
     hdata:=DdeClientTransaction(nil, DWORD(-1), conv, items[id].servHandle,
      1, XTYP_ADVSTOP {or XTYPF_NODATA}, TIMEOUT_ASYNC, @ddeRslt);
     end;
     items[id].connected:=false;
    { items[id].activ:=0;
     if ((items[id].rtid[0]>-1) and
           (fThrtItems.Items[items[id].rtid[0]].id>-1)) then fThrtItems.SetValid(items[id].rtid[0],0);
     end;         }
end;


function TDDEClient.findAppByAppId(id: HSZ): TServInfos;
var i: integer;
begin
  result:=nil;
  for i:=0 to self.serverlist.Count-1 do
    if TServInfos(serverlist.objects[i]).fHszApp=id then
       begin
          result:=TServInfos(serverlist.objects[i]);
          exit;
       end;
end;

function TDDEClient.RegisterServ(id: HSZ): LongInt;
var i: integer;
    ddeRslt: LongInt;
    hdata: HDDEData;
    SINF: TServInfos;
begin
    SINF:=findAppByAppId(id);
    if SINF=nil then exit;
    SINF.setconnectbyAppId;

end;

function TDDEClient.UnRegisterServ (id: HConv): LongInt;
var i: integer;
    ddeRslt: LongInt;
    hdata: HDDEData;
    SINF: TServInfos;
begin
     for i:=0 to self.serverlist.Count-1 do
        if serverlist.objects[i] is TServInfos then
              (serverlist.objects[i] as TServInfos).disconnectbyConv(id);
end;



function TDDEClient.SetAnObjectT(servern: string; topicn: string): TObject;
var i,j:integer;
begin
result:=nil;
servern:=trim(uppercase(servern));
topicn:=trim(uppercase(topicn));
for i:=0 to serverlist.count-1 do
  begin
     if TservInfos(serverlist.objects[i]).server=servern then
     for j:=0 to TservInfos(serverlist.objects[i]).Count-1 do
      if TservInfos(serverlist.objects[i]).items[j].topic=topicn then
       begin
          result:=TservInfos(serverlist.objects[i]).items[j];
          Fanalizeobj:=result;
          exit;
       end;
  end;

  Fanalizeobj:=nil;
end;

function TDDEClient.SetAnObjectA(servern: string): TObject;
var i,j:integer;
begin
result:=nil;
servern:=trim(uppercase(servern));
for i:=0 to serverlist.count-1 do
  begin
     if TservInfos(serverlist.objects[i]).server=servern then
       begin
          result:=TservInfos(serverlist.objects[i]);
          Fanalizeobj:=result;
          exit;
       end;
  end;
  Fanalizeobj:=nil;
end;

procedure TDDEClient.setAnalizeFunction(val: TNotifyEvent);
begin
  if not assigned(val) then self.Fanalizeobj:=nil;
  fAnalizeFunction:=val;
end;



procedure TItemDDEs.Sort;
var
  firstLine: integer;
  ischange: boolean;
  i: integer;
begin
  ischange:=true;
  while ischange do
    begin
      ischange:=false;
      for i:=0 to count-2 do
        begin
          if (items[i].servHandle>items[i+1].servHandle) then
                  begin
                    Exchange (i,i+1);
                    RtExchache(i,i+1,i+1,i);
                    ischange:=true;
                  end;
        end;
    end;  
end;

function TItemDDEs.GetTabCount: integer;
var i: integer;
begin
   result:=0;
   for i:=0 to count-1 do result:=result+items[i].count;
end;




function TItemDDEs.FindItemByHandle (ID: longInt): longInt;
var
  i: integer;
  it: TItemDDEs;
begin
  result := -1;
  result := binFindItemByHandle(id);
end;

procedure TItemDDEs.SetItemValid(ID: longInt);
var j: integer;
begin
    if (id<0) or (id>=count) then exit;
    for j:=0 to items[id].count-1 do
                   begin
                      fThrtItems.SetValid(items[id].rtid[j],100);
                   end;
end;

procedure TItemDDEs.SetItemInValid(ID: longInt);
var j: integer;
begin
    if (id<0) or (id>=count) then exit;
    for j:=0 to items[id].count-1 do
                   begin
                      fThrtItems.SetValid(items[id].rtid[j],0);
                   end;
end;

procedure TItemDDEs.setRequestActiv(val: boolean);
begin
   if (val<>fRequestActive) then
   begin
   fRequestActive:=val;
   RefreshActivStateforTopic(val);
   end;
end;

procedure TItemDDEs.SetItemValD(ID: longInt; val: real);
var j: integer;
begin
    if (id<0) or (id>=count) then exit;
    for j:=0 to items[id].count-1 do
                   begin
                      fThrtItems.SetValue(items[id].rtid[j],val);
                      fThrtItems.SetValid(items[id].rtid[j],1000);
                   end;
end;

procedure TItemDDEs.SetItemVal (ID: longInt; Data: HDDEData);
var I,j: integer;
     dataval: string;
     val, val_t: real;
     rtid: integer;
     MinEU, MaxEU, MinRaw, MaxRaw,koef: real;
begin
  i:=FindItemByHandle(id);
       if (i>-1) then
         begin
          try
            if (data<>0) then
               begin
                 dataval:=StoreData(data);
                 try
                 if (trim(dataval)='') then
                   begin
                      items[i].err:=3;
                       for j:=0 to items[i].count-1 do
                      fThrtItems.SetValid(items[i].rtid[j],0);
                      exit;
                   end;
                 val:=strtofloat(trim(dataval));
                 items[i].vals:=dataval;
                 items[i].val:=val;
                 items[i].err:=0;
                 for j:=0 to items[i].count-1 do
                   begin
                         rtID:=items[i].rtid[j];
                       begin
                         MinEU:=fThrtitems.items[rtID].MinEu;
                         MaxEU:=fThrtitems.items[rtID].MaxEu;
                         MinRaw:=fThrtitems.items[rtID].MinRaw;
                         MaxRaw:=fThrtitems.items[rtID].MaxRaw;
                         if ((fThrtitems.items[rtID].refCount>0) or self.fRequestActive) then
                           begin
                              if (MinRaw=MaxRaw) {or (MinEU=MaxEU)} then
                                 begin
                                   fThrtitems.SetValid(rtid,100);
                                   fThrtitems.SetValue(rtid,val);
                                 end
                              else
                                 begin
                                   if (MinRaw<MaxRaw) then
                                       begin
                                         if (val<MinRaw) then val:=MinRaw;
                                         if (val>MaxRaw) then val:=MaxRaw;
                                         koef:=(MaxEU-MinEU)/(MaxRaw-MinRaw);
                                         val_t:=MinEU+koef*(val-MinEU);
                                         fThrtitems.SetValid(rtid,100);
                                         fThrtitems.SetValue(rtid,val_t);
                                        end
                                    else
                                        begin
                                          if (val<MaxRaw) then val:=MinRaw;
                                          if (val>MinRaw) then val:=MaxRaw;
                                          koef:=(MaxEU-MinEU)/(MaxRaw-MinRaw);
                                          val_t:=MinEU+koef*(val-MinEU);
                                          fThrtitems.SetValid(rtid,100);
                                          fThrtitems.SetValue(rtid,val_t);

                                        end;
                                 end;
                           end
                         else
                           begin
                             fThrtitems.SetValid(rtid,0);
                           end;
                        end;

                     // fThrtItems.SetValue(items[i].rtid[j],val);
                      //fThrtItems.SetValid(items[i].rtid[j],100);
                   end;
                 except
                    for j:=0 to items[i].count-1 do
                   begin
                      fThrtItems.SetValid(items[i].rtid[j],0);
                      items[i].err:=2;
                   end;
                 end;
             end
              else
                begin
                   for j:=0 to items[i].count-1 do
                   begin
                      fThrtItems.SetValid(items[i].rtid[j],0);
                      items[i].err:=2;
                   end;
                   items[i].err:=1;
                end;

        except
        end;
         end;
end;

function TItemDDEs.FindItemByParam (servern: string; topicn: string; namen:string): integer;
var
  i: integer;
begin
   result:=-1;
   for i:=0 to Count-1 do
    begin
      if (servern=items[i].server) and
             (topicn=items[i].topic) and
                (namen=items[i].name) then
                   begin
                      result:=i;
                      exit;
                   end;
    end;
end;

function TItemDDEs.binFindItemByHandle (ID: longInt): integer;
var
  i: integer;
   min, max: integer;
  temts: integer;
begin
  result := -1;
  min:=0;
  max:=count-1;
  while ((result<0) and (min<>max)) do
    begin
      if (Items[min].servHandle=id) then result:=min else
         begin
         if (Items[max].servHandle=id) then result:=max else
           begin
              temts:=round((max+min)/2);
              if (Items[temts].servHandle>=id) then max:=temts else min:=temts;

           end;
         end;
    end;

end;



function TItemDDEs.FindItIdByRTid(id: integer): integer;
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
               if  max=(min+1) then exit;
              temts:=trunc((max+min)/2);
              if (m_rtItemsId[temts].rtID>=id) then max:=temts else min:=temts;


           end;
         end;
    end;

end;

procedure TItemDDEs.FreeAllItem;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    DDEFreeStringHandle(DdeInstId,Items[i].servHandle);
end;






function TItemDDEs.GetItem(i: integer): PTItemDDE;
begin
  result := inherited Items[i];
end;

function TItemDDEs.RefreshActivStateforTopic(val: boolean): boolean;
var i,j,l,k, num: integer;
    temp: integer;
    tempres: boolean;
begin

  for i:=0 to count-1 do
    begin
      temp:=0;
      if (Items[i].servHandle<>0) then
      if (((items[i].activ=0) and (val))) then
        begin
         self.connectItem(i);
        end;
      if (((items[i].activ=0) and not (val))) then
        begin
         self.disconnectItem(i);
        end;

    end;
end;

procedure TItemDDEs.SetItem(i: integer; item: PTItemDDE);
begin
  Items[i] := item;
end;


function TItemDDEs.ExecuteCommand(id: integer ; val: real): boolean;
var
  hszDat: HDDEData;
  hdata: HDDEData;
 // hszItems: HSZ;
  ids: integer;
  Data: PChar;
begin
  Result := False;
 ids:=self.FindItidByRtId(id);
 try
 Data:=Pchar(trim(floattostr(val)));
 except
 end;
  if (Data<>'') then
  begin
  if (ids>-1) then
  begin

  if items[ids].servHandle= 0 then Exit;
  hszDat := DdeCreateDataHandle (DdeInstId, Data, StrLen(Data) + 1,
    0, items[ids].servHandle, 1, 0);
  if hszDat <> 0 then
  begin

    hdata := DdeClientTransaction(Pointer(hszDat), DWORD(-1), conv, items[ids].servHandle,
      CF_TEXT, XTYP_POKE, TIMEOUT_ASYNC, nil);
    Result := hdata <> 0;
  end;
  end;
  end;

end;




constructor TDDEClient.Create(frtpath: string);
begin
  isExecuted:=true;
  isAdding:=false;
  fpath:=frtpath;
  fserverinit:=false;
  fclientinit:=false;
  PredLastCommand:= 0;
  serverlist:=TStringList.Create;
  inherited Create(false);
end;

destructor TDDEClient.Destroy;
begin
  serverlist.Free;
  inherited;
end;

procedure TDDEClient.OpenLink;
var
  res: boolean;
  l: pointer;
begin
  FDdeInstId := 0;
  DdeInitialize(FDdeInstId, DdeMgrCallBack, APPCLASS_STANDARD, 0);
end;

function TItemDDEs.StoreData(DdeDat: HDDEData): string;
var
  Len: Longint;
  Data: string;
  i: integer;
   ddeRslt: LongInt;
begin
  try
  Data := PChar(DdeAccessData(DdeDat, @Len));
  if Data <> '' then
  begin
   result:= Data;
    begin
      for I := 1 to Length(Data) do
        if (Data[I] > #0) and (Data[I] < ' ') then Data[I] := ' ';
     result:= Data;
    end;
   end;
   finally
   DdeUnaccessData(DdeDat);
   DdeFreeDataHandle(DdeDat);
   end;
end;

procedure TDDEClient.CloseLink;
var
  OldConv: HConv;
begin
 // SI.Free;
  DdeUninitialize(FDdeInstId);
 // itemList.Free;
end;




function TDDEClient.RefreshActivState: boolean;
var i,j,l,k, num: integer;
    temp: integer;
    tempres: boolean;
    itemlist: TItemDDEs;
begin
  tempres:=false;
  for l:=0 to serverlist.Count-1 do
  if (serverlist.Objects[l]<>nil) then
  for k:=0 to TServInfos(serverlist.Objects[l]).Count-1 do
  if (TServInfos(serverlist.Objects[l]).items[k]<>nil) and
  (TServInfos(serverlist.Objects[l]).items[k].Connected) then
  begin
  itemlist:=TServInfos(serverlist.Objects[l]).items[k];
  for i:=0 to itemlist.count-1 do
    begin
      temp:=0;
      if (itemlist.Items[i].servHandle<>0) then
      begin
      for j:=0 to itemlist.items[i].count-1 do
          if (fthrtitems.Items[itemlist.items[i].rtid[j]].refCount>0) then inc(temp);
      if (((itemlist.items[i].activ>0) and (temp<1))) then
        begin
         itemlist.items[i].changeActiv:=true;
         itemlist.items[i].activ:=temp;
         itemfromReq(i,itemlist);
        end;
      if ((itemlist.items[i].activ<1) and (temp>0)) then
        begin
         itemlist.items[i].changeActiv:=true;
         itemlist.items[i].activ:=temp;
         tempres:=true;
          iteminReq(i,itemlist);
        end;
        end;
    end;
    end;
   result:=tempres;

end;



function TDDEClient.AddServer(servern: string): TServInfos;
var i: integer;
    newSI: TServInfos;
begin
 result:=nil;
 i:=serverlist.IndexOf(uppercase(trim(servern)));
 if i>-1 then
   begin
      result:=TServInfos(serverlist.Objects[i]);
      exit;
   end;
 newSI:= TServInfos.Create(self.FDdeInstId,uppercase(trim(servern)),self.fThrtItems);
 serverlist.AddObject(uppercase(trim(servern)),newSI);
 result:=newSI;
end;

function TDDEClient.GetServer(servern: string): TServInfos;
var i: integer;
begin
 result:=nil;
 i:=serverlist.IndexOf(uppercase(trim(servern)));
 if ((i<0) or (serverlist.Objects[i]=nil)) then exit;
 result:=TServInfos(serverlist.Objects[i]);
end;

procedure TDDEClient.AddItems;
var  app,topic,ddit,host: string;
     i: integer;
     serInf: TServInfos;
begin
  try
  isAdding:=true;
  for i:=0 to fThrtItems.Count-1 do
    if (fThrtItems.Items[i].id>-1) then
      begin
        app:=isDDE(fThrtItems.TegGroups.GetAppbyNum(fThrtItems[i].GroupNum),host,topic);
        app:=trim(uppercase(app));
        topic:=trim(uppercase(topic));
        if (app<>'') then
          begin
            //topic:=fThrtItems.TegGroups.GetTopicbyNum(fThrtItems[i].GroupNum);
              if (topic<>'') then
                begin
                  serInf:=GetServer(app);
                  if serInf=nil then
                      serInf:=AddServer(app);
                  ddit:=fThrtItems.GetDDEItem(i);
                     if ((ddit<>'') {and (iscorrect(ddit))}) then
                         serInf.addItem(ddit,app,topic,i,(fThrtItems.Items[i].refCount>0));
                end;
           end;
      end;
//  itemlist.Sort;
 // DefRange;
  //itemlist.ConnectallactivServ;
  finally
  isAdding:=false;
  end;                   
end;

procedure TDDEClient.ConnectAllActivServer;
var i: integer;
begin
  for i:=0 to serverlist.Count-1 do
  if (serverlist.Objects[i] is TServInfos) then
   begin
     TservInfos(serverlist.Objects[i]).setconnectbyAppId;
  //   TservInfos(serverlist.Objects[i]).ConnectAllActivTopic;
   end;
end;

procedure TDDEClient.ClearItems;
var  app,topic,ddit,host: string;
     i: integer;
begin
//itemlist.disconnectALLandClear;
end;

function TDDEClient.FindByConv(conv: HConv): TItemDDEs;
var i,j: integer;
begin
  result:=nil;
  for i:=0 to self.serverlist.Count-1 do
   for j:=0 to TServInfos(serverlist.objects[i]).Count-1 do
     if  TServInfos(serverlist.objects[i]).items[j].conv=conv then
          begin
            result:=TServInfos(serverlist.objects[i]).items[j];
            exit;
          end;
end;

function TDDEClient.FindListByrtId(rtId: integer; var ItId: integer): TItemDDEs;
var i,j: integer;
begin
   result:=nil;
   ItId:=-1;
  for i:=0 to self.serverlist.Count-1 do
   for j:=0 to TServInfos(serverlist.objects[i]).Count-1 do
     begin
     iTId:=TServInfos(serverlist.objects[i]).items[j].FindItIdByRTid(rtId);
     if ItId>-1 then
       begin
         result:=TServInfos(serverlist.objects[i]).items[j];
         exit;
       end;
     end;
end;


procedure TDDEClient.SetItemVal (ID: longInt; conv: HConv; Data: HDDEData);
 var DDEs: TItemDDEs;
begin
   DDEs:=FindByConv(conv);
   if DDEs=nil then exit;
     DDEs.SetItemVal(id,Data);
end;


procedure TDDEClient.iteminReq_;
var  app,topic,ddit: string;
     i: integer;
begin
    if itlist=nil then exit;
    i:=curItem;
    itlist.connectItem(i);
end;

procedure TDDEClient.itemfromReq_;
var  app,topic,ddit: string;
     i: integer;
begin
  if itlist=nil then exit;
  i:=curItem;
  itlist.disconnectItem(i);
end;


procedure TDDEClient.iteminReq(Itid: integer; itli: Titemddes);
var  app,topic,ddit: string;
     i: integer;
begin
  curItem:=itid;
  itlist:=itli;
  synchronize(iteminReq_);
  itlist:=nil;
end;

procedure TDDEClient.itemfromReq(Itid: integer; itli: Titemddes);
var  app,topic,ddit: string;
     i: integer;
begin
  curItem:=itid;
   itlist:=itli;
  synchronize(itemfromReq_);
   itlist:=nil;
end;


procedure TDDEClient.DoRW;
var
  i,k: longInt;
  newValue: longInt;
  cN: longInt;
  prevVal: word;
  newComValue: single;
  str: string;
  j : longInt;
  Last: longInt;
  val: real;
  res: integer;
  itli: TitemDDEs;
procedure ExecuteCommand;
 var numit: integer;
begin

      if fThrtItems.Command[j].Executed then exit
      else
      if (fThrtItems.Command[j].ID <> -1)then
      begin
        itli := self.FindListByrtId(fThrtItems.Command[j].ID,cN);
        if itli<>nil then
        begin
        newComValue := fThrtItems.Command[j].ValReal;
        if cN <> -1 then
        begin
          fThrtItems.SetCommandExecuted(j);
           if NewComValue >= fThrtItems.Items[fThrtItems.Command[j].ID].maxEU then
            NewComValue := fThrtItems.Items[fThrtItems.Command[j].ID].maxEU
          else if NewComValue <= fThrtItems.Items[fThrtItems.Command[j].ID].minEU then
              NewComValue := fThrtItems.Items[fThrtItems.Command[j].ID].minEU;
              itli.ExecuteCommand(Cn,newComValue)
        end; {//except }
        end;
      end;
end;


begin

{***********************************************************************}
{ Writing pareameters                                                   }
{***********************************************************************}
  setlength (str, 2);
    try
      Last := PredLastCommand;

      if Last < fThrtItems.Command.CurLine then
        for j:=Last to fThrtItems.Command.CurLine - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand); //увеличивать, если команда выполнилась
        end;

      if Last > fThrtItems.Command.CurLine then begin
        for j := Last to  fThrtItems.Command.Count - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand)
        end;
        predLastCommand := 0;
        for j := 0 To fThrtItems.Command.CurLine - 1 do
        begin
          ExecuteCommand;
          inc(predLastCommand)
        end;
      end;

{      for j := PredLastCommand - 1 downto 0 do
        ExecuteCommand;}
   except
     // if   WriteErrorCount < 3 then begin
     //   inc (WriteErrorCount);
     //   fThfThrtItems.ClearCommandExecuted(j);
    //  end else WriteErrorCount := 0; //Сбрасываем команду при трех неудачных попытках записи
    end; //except

{    if fThfThrtItems.Command[PredLastCommand - 1].Executed and (fThfThrtItems.Command.Count > 20) then
    begin
      fThfThrtItems.Command.Compress;
      predLastCommand := 0;
    end;
}
{***********************************************************************}
{ Reading pareameters                                                   }
{***********************************************************************}
for i:=0 to serverList.Count-1 do
  begin
    for j:=0 to TservInfos(serverList.Objects[i]).count-1 do
     if not TservInfos(serverList.Objects[i]).items[j].wild then
       begin
         itli:=TservInfos(serverList.Objects[i]).items[j];
         if (itli.items[k].activ>0) then
           begin
              res:=itli.ReadDrectItem(k,val);
              if (res=0) then
              begin
              itli.SetItemValD(k,val);
              
              end
              else
              begin
              fThrtItems.SetValid(itli.items[k].rtid[0],0);
              itli.items[k].err:=res;
              end;
           end;
       end;
  end;

end;


function TDDEClient.GetInit: boolean;
begin
   if not finit then
     begin
       Synchronize(InitVar);
       finit:=true;
     end;
  result:=finit;
end;

procedure TDDEClient.InitVar;
begin
  fThrtItems:=TanalogMems.Create(fpath);
  OpenLink;
  AddItems;
  ConnectAllActivServer;
end;

procedure TDDEClient.UnInitVar;
begin
  ClearItems;
  CloseLink;
  fThrtItems.Free;
end;

procedure TDDEClient.Analize;
begin
  if assigned(AnalizeFunction) and (Fanalizeobj<>nil) then
    Synchronize(Analize_);
end;

procedure TDDEClient.Analize_;
begin
    AnalizeFunction(Fanalizeobj);
end;

procedure TDDEClient.Execute;
begin
inherited;
while not TerMinated do
begin
if Init then
begin
  RefreshActivState;
  DORW;
  Analize;
  sleep (1000);
end else
  begin
    sleep (1000);
  end;
end;
Uninitvar;
end;



end.
