unit ReportGroupLocatorU;

interface



uses
  Classes, ActiveX, ConstDef, MemStructsU, SysUtils, MainDataModuleU, DBManagerFactoryU, math, DateUtils;

const APP_NAMEREPORTMENAG='Arch_Serv#RepMen';




const
    COUNTBYLOG=1;
    COUNTBYREP=2;



type TRepotItem   = record
      rtid: integer;
      name: string;
      typ: integer;
      lasttime: TDatetime;
      active: boolean;
      deep: integer;
      delt: integer;
      sourceid: integer;
      sourcetype: integer;
      sourceperiod: integer;
      tmreq: TDateTime;
      trycount: integer;
      tmwrite: TDateTime; // время для логики write to ArchServ
      tmwait: TDateTime; // время для логики wait
      agr: integer;
      init: boolean;
     end;

type
  PTRepotItem = ^TRepotItem;




type
  TSysReportGroup = class(TList)
  private
    frtitems: TanalogMems;
    finit: boolean;
    reportGrnum: integer;
    ffirst: boolean;
    procedure freeitem_;
    procedure SetItem(i: integer; item: PTRepotItem);
    function  GetItem(i: integer): PTRepotItem;
    procedure SetState(i: integer; state: integer);
    function  GetState(i: integer): integer;
    function  GetTyp(i: integer): integer;
    function  GetDeep(i: integer): integer;
    function  GetVal(i: integer): real;
    procedure  SetVal(i: integer; vals: real);
    function  GetTag(i: integer): string;

    function  GetDelt(i: integer): integer;
    function  GetRtid(i: integer): integer;
    function  GetSourceID(i: integer): integer;
    function  GetSourceType(i: integer): integer;
    function  GetSourcePeriod(i: integer): integer;
    function  GetReqTime1(i: integer): TdateTime;
    function  GetReqTime2(i: integer): TdateTime;
    function  GetAgr(i: integer): integer;

    { Private declarations }
  protected
    function Add_(it: PTRepotItem): boolean;
    function findBS(IDS: integer): PTRepotItem;

    function inital: boolean;
    function uninital: boolean;

    function  GetInit: boolean;
    procedure SetInit(val: boolean);
    procedure Log(mess: string; lev: byte = 2);
  public
    constructor Create(frtitems_: TanalogMems);
    destructor destroy;
    procedure addItem(id_: integer);
    property items[i: integer]: PTRepotItem read getItem write setItem; default;
    property init: boolean read getInit write setInit;
    property State[i: integer]: integer read getState write setState;
    property Deep[i: integer]: integer read getDeep;
    property Val[i: integer]: real read getVal write setVal;
    property Delt[i: integer]: integer read getDelt;
    property Typ[i: integer]:  integer read getTyp;
    property RtId[i: integer]:  integer read getRtId;
    property SourceID[i: integer]:  integer read getSourceID;
    property SourceType[i: integer]:  integer read getSourceType;
    property SourcePeriod[i: integer]:  integer read getSourcePeriod;
    property Tag[i: integer]:  string read getTag;
    property Agr[i: integer]:  integer read getAgr;
    //время когда фактически необходим опрос
    //задействуются механизмы опроса( может расходится с TabTime
    property ReqTime1[i: integer]: TdateTime read getReqTime1; // write setReqTime;
    property ReqTime2[i: integer]: TdateTime read getReqTime2; // write setReqTime;

  end;





type
  TReportGroup = class(TList)
  private

    frtitems: TanalogMems;
    finit: boolean;
    reportGrnum: integer;
    cntreportGrnum: integer;
    procedure freeitem_;

    procedure SetItem(i: integer; item: PTRepotItem);
    function  GetItem(i: integer): PTRepotItem;
    procedure SetState(i: integer; state: integer);
    function  GetState(i: integer): integer;
    function  GetTyp(i: integer): integer;
    function  GetDeep(i: integer): integer;
    function  GetVal(i: integer): real;
    function  GetTag(i: integer): string;
    function  GetDelt(i: integer): integer;
    function  GetRtid(i: integer): integer;
    function  GetReqTime(i: integer): TdateTime;
    function  GetTabTime(i: integer): TdateTime;
    procedure SetTabTime(i: integer; val: TdateTime);
    function  isReportCnt(i: integer): boolean;
  protected
    function Add_(it: PTRepotItem): boolean;
    function findBS(IDS: integer): PTRepotItem;

    function inital: boolean;
    function uninital: boolean;

    function  GetInit: boolean;
    procedure SetInit(val: boolean);

    procedure Log(mess: string; lev: byte = 2);
  public
    constructor Create(frtitems_: TanalogMems);
    destructor destroy;
    procedure addItem(id_: integer);
    property items[i: integer]: PTRepotItem read getItem write setItem; default;
    property init: boolean read getInit write setInit;
    property State[i: integer]: integer read getState write setState;
    property Deep[i: integer]: integer read getDeep;
    property Val[i: integer]: real read getVal;
    property Delt[i: integer]: integer read getDelt;
    property Typ[i: integer]:  integer read getTyp;
    property RtId[i: integer]:  integer read getRtId;
    property Tag[i: integer]:  string read getTag;
    //время когда фактически необходим опрос
    //задействуются механизмы опроса( может расходится с TabTime
    property ReqTime[i: integer]: TdateTime read getReqTime;// write setReqTime;
    //время в том виде в каком оно присудствует в таблицах
    property TabTime[i: integer]: TdateTime read getTabTime write setTabTime;
  end;

type
  TReportGroupLocator = class(TThread)
  private
    fDBMeneger: TMainDataModule;
    DBmenagtyp: integer;
    fconstr: string;
    list_Sys: TSysReportGroup;
    list_All: TReportGroup;
    finit: boolean;
    frtitems: TanalogMems;
    fDBNoset: boolean;
    fLastConn: boolean;
    fLastReqTime: TDateTime;
    ffirst: boolean;
    { Private declarations }
     function  getDBMeneger: TMainDataModule;
     function  getInit: boolean;


     function getCount: integer;
     procedure RequestDeep(i: integer);
     procedure WriteData(i: integer);
     procedure WaitData(i: integer);

     procedure NeedWaitData(i: integer);
     procedure CheckData(i: integer);
     procedure reCheckData();  // проверет соответствие - источник в случае группы $Report не должен быть готов
                               // а не в опросе STate=REPORT_NORMAL в исотчнике, чтобы выставить  STate=REPORT_NEEDREQUEST в теге опроса
     procedure NoData(i: integer);
     procedure ReadData(i: integer);
     procedure CheckWrite(i: integer);

     function  getRoundTime(typ_: integer; dt: TDateTime): TDateTime;

  protected
    procedure Execute; override;
    procedure DoRow;
    procedure DoRowSys;
    procedure Log(mess: string; lev: byte = 2);
  public



   constructor Create(path: string; menagtyp: integer; constr: string);
   destructor  Destroy;
   property    DBMeneger: TMainDataModule read getDBMeneger;
   property    Count: integer read getCount;
   property    init: boolean read getInit;

  end;

implementation


constructor TReportGroup.Create(frtitems_: TanalogMems);
begin
   inherited create;
   frtitems:=frtitems_;
   cntreportGrnum:=-1;
   finit:=false;
   init:=true;
end;

destructor TReportGroup.destroy;
begin
   freeitem_;
   inherited destroy;
end;

procedure TReportGroup.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;


function TReportGroup.inital: boolean;
var i: integer;
begin
  result:=finit;
  if finit then exit;
  try
  reportGrnum:=frtItems.TegGroups.ItemNum['$REPORT'];
  cntreportGrnum:=frtItems.TegGroups.ItemNum['$REPORTCOUNT'];
  if reportGrnum<0 then reportGrnum:=-2;
  for i:=0 to frtitems.Count-1 do
     addItem(frtitems[i].ID);
  finit:=true;
  result:=true;
  except
  finit:=false;
  frtitems:=nil;
  end;
end;

function TReportGroup.uninital: boolean;
var i: integer;
begin
  result:=finit;
  if not finit then exit;
  try
  if frtitems<>nil then
    FreeAndNil(frtitems);
  freeitem_;
  Clear;
  finit:=false;
  except
  finit:=false;
  frtitems:=nil;
  end;
end;

function  TReportGroup.GetInit: boolean;
begin
   result:=finit;
end;


procedure TReportGroup.SetInit(val: boolean);
begin
  if finit<>val then
    begin
      if val then finit:=inital
      else finit:=false;
    end
end;


function TReportGroup.GetItem(i: integer): PTRepotItem;
begin
  result := inherited Items[i];
end;

procedure TReportGroup.SetItem(i: integer; item: PTRepotItem);
begin
  Items[i] := item;
end;



procedure TReportGroup.addItem(id_: integer);
   var
    it: PTRepotItem;
    typ_: integer;
    i,j: integer;
    name_: string;

begin
      if id_<0 then exit;
      if frtitems[id_].ID<0 then exit;
      typ_:=frtitems[id_].logTime;
      name_:=frtitems.GetName(id_);
      if (typ_ in REPORT_SET) then
         begin
           if (id_>-1)  then
            begin
            new(it);
            it.name:=name_;
            it.rtid:=id_;
            it.typ:=typ_;
            it.lasttime:=0;
            it.active:=false;
            it.deep:=GetDeepUtil(typ_,round(frtitems[id_].logDB));
            it.sourceid:=-1;
            it.tmreq:=incday(now,1);
            if frtitems[id_].GroupNum=reportGrnum then
              begin
                it.sourceid:=frtitems.GetSimpleID(frtitems.GetDDEItem(id_));
              end;
            frtitems.IncCounter(id_);
            it.delt:= round(frtitems[id_].AlarmConst);
            if (not Add_(it)) then dispose(it);
            end;
            it.init:=false;
         end;

end;

function TReportGroup.Add_(it: PTRepotItem): boolean;
var
  SV: PTRepotItem;
  i: integer;
begin
  result:=false;
  if it=nil then exit;
  if it.rtid<0 then exit;
  if findBS(it.rtid)<>nil then exit;

  for i:=0 to count-1 do
   begin
     if PTRepotItem(items[i]).rtid>it.rtid then
      begin
       inherited Insert(i,it);
       result:=true;
       exit;
      end;
   end;
  inherited Add(it);
  result := true;
end;

function  TReportGroup.GetTyp(i: integer): integer;
begin
   result:=items[i].typ;
end;


function  TReportGroup.GetDeep(i: integer): integer;
begin
  result:=items[i].deep;
end;

function  TReportGroup.GetDelt(i: integer): integer;
begin
  result:=items[i].delt;
end;

function  TReportGroup.GetVal(i: integer): real;
begin
   result:=frtitems[Items[i].rtid].ValReal;
end;

function  TReportGroup.GetTag(i: integer): string;
begin
   result:=Items[i].name;
end;

function  TReportGroup.GetRtid(i: integer): integer;
begin
  result:=items[i].rtid;
end;

function  TReportGroup.GetTabTime(i: integer): TdateTime;
begin
   result:=frtitems[Items[i].rtid].TimeStamp;
end;

function  TReportGroup.isReportCnt(i: integer): boolean;
begin
   result:=((frtitems[Items[i].rtid].GroupNum=self.cntreportGrnum) and (self.cntreportGrnum>-1));
end;

procedure  TReportGroup.SetTabTime(i: integer; val: TdateTime);
begin
   frtitems[Items[i].rtid].TimeStamp:=val;

end;

function  TReportGroup.GetReqTime(i: integer): TdateTime;
begin
   result:=GetTimeReqByTabTime(TabTime[i],Typ[i],Delt[i], isReportCnt(i));
end;



procedure TReportGroup.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
     dispose(items[i]);
end;


function TReportGroup.findBS(IDS: integer): PTRepotItem;
var x1,x2,xs: integer;
begin
    result:=nil;
    x1:=0;
    x2:=count-1;
    if x2<0 then exit;
    while (PTRepotItem(items[x1]).rtid<>PTRepotItem(items[x2]).rtid) do
      begin
        if PTRepotItem(items[x1]).rtid>IDS then exit;
        if PTRepotItem(items[x2]).rtid<IDS then exit;
        if PTRepotItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x1]);
           exit;
          end;
        if PTRepotItem(items[x2]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x2]);
           exit;
          end;
       xs:=round((x1+x2)/2);
       if PTRepotItem(items[xs]).rtid>IDS then x2:=xs
         else x1:=xs;
     end;
      if PTRepotItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x1]);
           exit;
          end;
end;


procedure TReportGroup.SetState(i: integer; state: integer);
begin
   case state of

       REPORT_NEEDREQUEST:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDREQUEST;
       REPORT_NORMAL:       frtitems[items[i].rtid].ValidLevel:=REPORT_NORMAL;
       REPORT_WRITE:        frtitems[items[i].rtid].ValidLevel:=REPORT_WRITE;
       REPORT_WAIT:         frtitems[items[i].rtid].ValidLevel:=REPORT_WAIT;
       REPORT_WAITSOURCE:   frtitems[items[i].rtid].ValidLevel:=REPORT_WAITSOURCE;

   end;
end;

function  TReportGroup.GetState(i: integer): integer;
var res: integer;
begin
    result:=REPORT_NOACTIVE;
    if (items[i].rtid>0) then
       begin
         res:=frtitems[items[i].rtid].ValidLevel;
         if (res in [REPORT_NOACTIVE,REPORT_NEEDKHOWDEEP,
         REPORT_NEEDREQUEST,REPORT_NORMAL,REPORT_NODATA,REPORT_DATA,REPORT_WAIT,REPORT_NEEDWAIT
         ,REPORT_WRITE,REPORT_WRITED, REPORT_NOWRITED,REPORT_WAITSOURCE]) then
         result:=res else result:=REPORT_NOACTIVE;
       end;

end;






constructor TSysReportGroup.Create(frtitems_: Tanalogmems);
begin
   frtitems:=frtitems_;
   finit:=false;
   init:=true;
end;



destructor TSysReportGroup.destroy;
begin
   freeitem_;
   inherited destroy;
end;

procedure TSysReportGroup.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;





function TSysReportGroup.inital: boolean;
var i: integer;
begin
  result:=finit;
  if finit then exit;
  try
  reportGrnum:=frtItems.TegGroups.ItemNum['$REPORT'];
  if reportGrnum<0 then reportGrnum:=-2;
  if reportGrnum>-1 then
  begin
  for i:=0 to frtitems.Count-1 do
     addItem(frtitems[i].id);
  finit:=true;
  end;
  result:=true;
  except
  finit:=false;
  frtitems:=nil;
  end;
end;

function TSysReportGroup.uninital: boolean;
var i: integer;
begin
  result:=finit;
  if not finit then exit;
  try
  if frtitems<>nil then
    FreeAndNil(frtitems);
  freeitem_;
  Clear;
  finit:=false;
  except
  finit:=false;
  frtitems:=nil;
  end;
end;

function  TSysReportGroup.GetInit: boolean;
begin
   result:=finit;
end;


procedure TSysReportGroup.SetInit(val: boolean);
begin
  if finit<>val then
    begin
      if val then finit:=inital
      else finit:=false;
    end
end;


function TSysReportGroup.GetItem(i: integer): PTRepotItem;
begin
  result := inherited Items[i];
end;

procedure TSysReportGroup.SetItem(i: integer; item: PTRepotItem);
begin
  Items[i] := item;
end;



procedure TSysReportGroup.addItem(id_: integer);
// определяет корректен ли источник для отчетных данных
function CheckSource(typ_: integer; name_,source_: string; var sper: integer): integer;
var sourceid: integer;
    sourcetype: integer;
begin
   result:=-1;
   sper:=-1;
   sourceid:=frtitems.GetSimpleID(source_);

   if sourceid<0 then exit;
   if frtitems[sourceid].ID<0 then exit;

   sourcetype:=frtitems[sourceid].logTime;
   sper:=sourcetype;

   if not(sourcetype in  REPORT_SET)
          then
   begin
     if frtitems[sourceid].Logged then
       begin
         sourcetype:=0;
        // result:=true;
       end
      else
       begin
         exit;
       end;
   end;

   if (typ_ in [REPORTTYPE_HOUR, REPORTTYPE_MIN, REPORTTYPE_30MIN, REPORTTYPE_10MIN]) then
      begin
         if (sourcetype=0) then
         begin
         result:=COUNTBYLOG;
         exit;
         end;
         if ((sourcetype=REPORTTYPE_MIN)
          and (typ_ in [REPORTTYPE_HOUR, REPORTTYPE_30MIN, REPORTTYPE_10MIN])) then
          begin
             result:=COUNTBYREP;
             exit;
          end;
          if ((sourcetype=REPORTTYPE_10MIN)
          and (typ_ in [REPORTTYPE_HOUR, REPORTTYPE_30MIN])) then
          begin
             result:=COUNTBYREP;
             exit;
          end;
          if ((sourcetype=REPORTTYPE_30MIN)
          and (typ_ in [REPORTTYPE_HOUR])) then
          begin
             result:=COUNTBYREP;
             exit;
          end;
          exit;
      end;

   if (typ_ in [REPORTTYPE_YEAR]) then
      begin
         if (sourcetype in [REPORTTYPE_MONTH,REPORTTYPE_DAY]) then result:=COUNTBYREP;
         exit;
      end;

   if (typ_ in [REPORTTYPE_MONTH,REPORTTYPE_DEC]) then
      begin
         if (sourcetype in [REPORTTYPE_DAY,REPORTTYPE_HOUR]) then result:=COUNTBYREP;
         exit;
      end;

   if (typ_ in [REPORTTYPE_DAY]) then
      begin
         if (sourcetype in [REPORTTYPE_HOUR,REPORTTYPE_MIN,REPORTTYPE_30MIN,REPORTTYPE_10MIN]) then result:=COUNTBYREP;
         exit;
      end;
end;
   var
    it: PTRepotItem;
    typ_: integer;
    i,j: integer;
    name_, source_: string;
    sourcetyp, speriod: integer;
begin
      if id_<0 then exit;
      if frtitems[id_].ID<0 then exit;
      typ_:=frtitems[id_].logTime;
      name_:=frtitems.GetName(id_);
      source_:=frtitems.GetDDEItem(id_);
      if (frtitems[id_].GroupNum=reportGrnum)  then
      begin
      if ((typ_ in REPORT_SET ) ) then
         begin
         sourcetyp:=CheckSource(typ_,name_,source_,speriod);
         if sourcetyp in [COUNTBYLOG,COUNTBYREP]  then
         begin
           if (id_>-1)  then
            begin
            if ((sourcetyp in [COUNTBYLOG]) or
            ((sourcetyp in [COUNTBYREP]) and (speriod in REPORT_SET))) then
            begin
            new(it);
            it.name:=name_;
            it.rtid:=id_;
            it.typ:=typ_;
            it.sourceid:=frtitems.GetSimpleID(source_);
            it.sourcetype:=sourcetyp;
            it.lasttime:=0;
            it.active:=false;
           // it.deep:=GetDeepUtil(typ_,round(frtitems[id_].logDB));
            frtitems.IncCounter(id_);
            it.agr:=frtitems[id_].PreTime;
             it.sourceperiod:=speriod;
            it.delt:= round(frtitems[id_].AlarmConst);
            if (not Add_(it)) then dispose(it);
            frtitems[id_].ValidLevel:=REPORT_NEEDKHOWDEEP;
           // log('Менджер группы $Report не добавил в опрос tg='+name_+',т.к источник  не задан',_DEBUG_WARNING) ;
            end else
            begin
                 log('Менджер группы $Report не добавил в опрос tg='+name_+',т.к источник nm="'+
                  source_+ '" некорректен',_DEBUG_ERROR) ;
            end;
            end;
         end else
         begin
            log('Менджер группы $Report не добавил в опрос tg='+name_+',т.к источник nm="'+
            source_+ '" некорректен',_DEBUG_ERROR) ;
         end
         end
         else
          begin
             log('Менджер группы $Report не добавил в опрос tg='+name_+',т.к источник  не задан',_DEBUG_ERROR) ;
          end;
        end;

end;

function TSysReportGroup.Add_(it: PTRepotItem): boolean;
var
  SV: PTRepotItem;
  i: integer;
begin
  result:=false;
  if it=nil then exit;
  if it.rtid<0 then exit;
  if findBS(it.rtid)<>nil then exit;

  for i:=0 to count-1 do
   begin
     if PTRepotItem(items[i]).rtid>it.rtid then
      begin
       inherited Insert(i,it);
       result:=true;
       exit;
      end;
   end;
  inherited Add(it);
  result := true;
end;

function  TSysReportGroup.GetTyp(i: integer): integer;
begin
   result:=items[i].typ;
end;


function  TSysReportGroup.GetDeep(i: integer): integer;
begin
  result:=items[i].deep;
end;

function  TSysReportGroup.GetSourceID(i: integer): integer;
begin
  result:=items[i].sourceid;
end;

function  TSysReportGroup.GetSourceType(i: integer): integer;
begin
  result:=items[i].sourcetype;
end;

function  TSysReportGroup.GetSourcePeriod(i: integer): integer;
begin
  result:=items[i].sourceperiod;
end;

function  TSysReportGroup.GetDelt(i: integer): integer;
begin
  result:=items[i].delt;
end;

function  TSysReportGroup.GetVal(i: integer): real;
begin
   result:=frtitems[Items[i].rtid].ValReal;
end;

procedure  TSysReportGroup.SetVal(i: integer; vals: real);
begin
   frtitems[Items[i].rtid].ValReal:=vals;
end;

function  TSysReportGroup.GetTag(i: integer): string;
begin
   result:=Items[i].name;
end;

function  TSysReportGroup.GetRtid(i: integer): integer;
begin
  result:=items[i].rtid;
end;

function  TSysReportGroup.GetAgr(i: integer): integer;
begin
  result:=items[i].agr;
end;





function  TSysReportGroup.GetReqTime1(i: integer): TdateTime;
var vdt: TDateTime;
begin
   vdt:=frtitems[Items[i].rtid].TimeStamp;
   vdt:=incPeriod(typ[i],vdt,-1);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[i],delt[i]);
end;

function  TSysReportGroup.GetReqTime2(i: integer): TdateTime;
var vdt: TDateTime;
begin
   vdt:=frtitems[Items[i].rtid].TimeStamp;
   vdt:=incPeriod(typ[i],vdt,0);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[i],delt[i]);
end;




procedure TSysReportGroup.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
     dispose(items[i]);
end;


function TSysReportGroup.findBS(IDS: integer): PTRepotItem;
var x1,x2,xs: integer;
begin
    result:=nil;
    x1:=0;
    x2:=count-1;
    if x2<0 then exit;
    while (PTRepotItem(items[x1]).rtid<>PTRepotItem(items[x2]).rtid) do
      begin
        if PTRepotItem(items[x1]).rtid>IDS then exit;
        if PTRepotItem(items[x2]).rtid<IDS then exit;
        if PTRepotItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x1]);
           exit;
          end;
        if PTRepotItem(items[x2]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x2]);
           exit;
          end;
       xs:=round((x1+x2)/2);
       if PTRepotItem(items[xs]).rtid>IDS then x2:=xs
         else x1:=xs;
     end;
      if PTRepotItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotItem(items[x1]);
           exit;
          end;
end;


procedure TSysReportGroup.SetState(i: integer; state: integer);
begin
   case state of
       REPORT_NEEDWAIT:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDWAIT;
       REPORT_NEEDKHOWDEEP:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDKHOWDEEP;
       REPORT_DATA:       frtitems[items[i].rtid].ValidLevel:=REPORT_DATA;
       REPORT_NODATA:     frtitems[items[i].rtid].ValidLevel:=REPORT_NODATA;
   end;
end;

function  TSysReportGroup.GetState(i: integer): integer;
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

end;


//  ограничивает справа и слева, глубину поиска последних отчетных данных
// ! нельзя читать бесконечно глубокий или пустой в глубине источник данных




constructor TReportGroupLocator.Create(path: string; menagtyp: integer; constr: string);
begin
   inherited Create(false);
   DBmenagtyp:=menagtyp;
   fconstr:=constr;
   frtitems:=TanalogMems.Create(path);
   frtItems.SetAppName(APP_NAMEREPORTMENAG);
   list_All:=TReportGroup.Create(frtitems);
   list_Sys:=TSysReportGroup.Create(frtitems);
   finit:=false;
   ffirst:=true;
   fLastReqTime:=0;
   fDBNoset:=false;
   fLastConn:=true;   // полпгаем что соединение было
   CoInitialize(nil);
end;

procedure TReportGroupLocator.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

destructor TReportGroupLocator.Destroy;
begin
   list_All.Free;
   list_Sys.Free;
   if fDBMeneger<>nil then  fDBMeneger.Free;
   CoUnInitialize;
   inherited destroy;
end;

function  TReportGroupLocator.getDBMeneger: TMainDataModule;
begin

 if fDBNoset then     // не установлен менеджер данных
     begin
       result:=nil;
       exit;
     end;
   if fDBMeneger=nil then
      begin
      fDBMeneger:=TDBManagerFactory.
      buildManager(DBmenagtyp,fconstr,dbaReadOnly,false,'repServ');
      if fDBMeneger=nil then
       begin
        result:=nil;
        self.Log('Менеджер данных не установлен! Архивирование невозможно!',_DEBUG_ERROR);
        fDBNoset:=true;
        exit;
       end;
      end;
   if ((not fDBMeneger.Conneted) and (SecondsBetween(now,fLastReqTime)>30)) then
     try
       fDBMeneger.Connect;
     except
         fLastReqTime:=now;
         if fLastConn then
         begin
         Log('Не удалось связаться с хранилищем данных данных. Архивирование невозможно!',_DEBUG_ERROR);
         fLastConn:=false;
         ffirst:=true;
         end;

     end;
   if fDBMeneger.Conneted then
   begin
   result:=fDBMeneger;
   if ((not fLastConn) or ffirst) then
     begin
       fLastConn:=true;
       ffirst:=false;
       self.Log('Соединение с источником данных успешно установленою', _DEBUG_MESSAGE);
     end;
   end
   else
   begin
   result:=nil;

   
   end;
end;



function  TReportGroupLocator.getRoundTime(typ_: integer; dt: TDateTime): TDateTime;
var tmp_d: integer;
    dt1: TDateTime;
begin

   result:= incPeriod(typ_,dt,0);
end;


// предвигает на период вперед период  для TabTime  поэтому время вседа округлено
//при ноле просто производит округление до корректного периода




function  TReportGroupLocator.getInit: boolean;
begin
   result:=false;
   if (not list_All.init) then
     begin
       list_All.init:=true;
     end;
   if (not list_Sys.init) then
     begin
       list_Sys.init:=true;
     end;
   result:=((getDBMeneger<>nil) and (list_All.init) and (list_Sys.init));
end;



procedure TReportGroupLocator.Execute;
begin
  while (not Terminated) do
  begin
   try
   try
     if  Init then
       begin
          if (DBMeneger<>nil) then
          begin
          DoRow;
          reCheckData();
          DoRowSys;
          sleep(1000);
          end
          else
          sleep(10000);
          end
     else
       sleep(1000);

   except
     on E: Exception do
     begin
       if not (E is LostConnectionError) then
      begin
      if fDBMeneger<> nil then
                try
                  fDBMeneger.CheckConnection(E);
                except
                 on Ex: Exception do
                   E:=Ex;
                end;
       end;



       if E is LostConnectionError then
         begin
            fLastConn:=true;
            self.Log('Соединение с хранилищем данных данных прервано. Архивирование остановлено!',_DEBUG_ERROR);
            try
            if fDBMeneger<> nil then
              try
               fDBMeneger.Free;
               fDBMeneger:=nil;
              except
               fDBMeneger:=nil;
              end;
            except
            end;
         end else
         begin
            self.Log('Возникновение ошибки в обработчике сообщений Execute:TReportGroupLocator! Err: '+E.Message,_DEBUG_ERROR);
         end;
         sleep(1000);
     end


   end
   except
      self.Log('Возникновение ошибки в обработчике сообщений Execute:TReportGroupLocator! НЕ ОБРАБОТАНО',_DEBUG_ERROR);
   end;
  end;

end;

procedure TReportGroupLocator.RequestDeep(i: integer);
var tm: TdateTime;
    h: string;
begin
    if DBMeneger<>nil then
     begin

      if DBMeneger.GetLastReport(list_All.GetTag(i),list_All.typ[i],list_All.deep[i],tm) then
        begin
          list_All.items[i].trycount:=3;
          list_All.TabTime[i]:=incPeriod(list_All.Typ[i],tm);
          list_All.items[i].init:=true;
          // ставим на опрос
         /// log('Получена глубина архива для tg='+list_All.Tag[i]+' tm='+
         // formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',tm));
          CheckData(i);
        end else
        begin
          //!!!! Желательно считать попытки и писать в log
        end;
     end;
end;

procedure TReportGroupLocator.WriteData(i: integer);
begin

     begin
        try

          list_All.State[i]:=REPORT_WRITE;
          frtitems.Regs.NotifyChange(-1,list_All.Rtid[i]);
          list_All.Items[i].tmwrite:=now;  // выставляем время ожидания

        except

        end;
     end;
end;

procedure TReportGroupLocator.NoData(i: integer);
begin

        try
          list_All.items[i].trycount:=3;
          list_All.TabTime[i]:=incPeriod(list_All.Typ[i],list_All.TabTime[i]);
          CheckData(i);
        except

        end;

end;

procedure TReportGroupLocator.NeedWaitData(i: integer);
begin
   list_All.Items[i].tmwait:=now; // выставляем время ожидания
   list_All.State[i]:=REPORT_WAIT; // ставим состояние ожидания
end;

procedure TReportGroupLocator.WaitData(i: integer);
begin
   if (now-list_All.Items[i].tmwait)>GetTimeReqByTabTimeforRep(0,list_All.Typ[i]) then
    begin
     // если время ожидания прошло то
     // выводим из состояния ожидания
     Checkdata(i);
    end;
end;



procedure TReportGroupLocator.CheckWrite(i: integer);
begin

 case list_All.State[i] of
    REPORT_WRITED, REPORT_NOWRITED:
     begin
        // данные записаны службой архивирования
        //  идем дальше
       //  log('Принят ответ службы архивирования о записи');
        list_All.TabTime[i]:=incPeriod(list_All.Typ[i],list_All.TabTime[i]);
        Checkdata(i);
     end;
    REPORT_WRITE:
    begin
     if (now-list_All.Items[i].tmwrite)>GetTimeReqByTabTimeforRep(0,list_All.Typ[i]) then
      begin
      if (list_All.items[i].trycount<=0)  then
       begin   // попытки записи исчерпаны
         list_All.TabTime[i]:=incPeriod(list_All.Typ[i],list_All.TabTime[i]);
         Checkdata(i);
         list_All.items[i].trycount:=3;
       end else
       begin  // пытаемся записать еще раз
         log('Попытка записать N'+ inttostr(list_All.items[i].trycount));
        list_All.items[i].trycount:=list_All.items[i].trycount-1;
        WriteData(i);
       end;
      end;
      end;
    end;
end;


procedure TReportGroupLocator.CheckData(i: integer);
var  h: string;
begin


       //    h:=Datetimetostr(list_All.ReqTime[i]);
          if (list_All.ReqTime[i]<now) then
          begin

          list_All.items[i].trycount:=3;
          if (list_All.items[i].sourceid>-1) then   // выставляем на опрос
          // только если source все прочитал  REPORT_NORMAL
            begin
                if frtitems.Items[list_All.items[i].sourceid].ValidLevel=REPORT_NORMAL then
                        list_All.State[i]:=REPORT_NEEDREQUEST
                else
                list_All.State[i]:=REPORT_WAITSOURCE;
                exit;
                        
            end;
          list_All.State[i]:=REPORT_NEEDREQUEST;
          end
          else
            list_All.State[i]:=REPORT_NORMAL;

end;

procedure TReportGroupLocator.reCheckData();
var i, states: integer;
begin
    for i:=0 to list_All.Count-1 do
           if list_All.items[i].sourceid>-1 then
             begin
               states:= list_All.State[i];
               case states of
                 REPORT_NEEDREQUEST:  // если выставлен в опрос
                   begin
                     if frtitems.Items[list_All.items[i].sourceid].ValidLevel    // но источник сам в опросе
                     <>REPORT_NORMAL then
                        list_All.State[i]:=REPORT_NORMAL;         // выставляем в REPORT_NORMAL
                   end;
                end;
             end;
end;

procedure TReportGroupLocator.DoRow;
var i, states: integer;

begin
    for i:=0 to list_All.Count-1 do
      begin
         states:= list_All.State[i];
         if  ((not list_All.items[i].init) and (states<>REPORT_NEEDKHOWDEEP)) then
            states:=0; // тег опроса ДОЛЖЕН сначала обработать запрос о глубине архива

         case states of

           REPORT_NEEDKHOWDEEP :               // сервер i/o ответсвенный за учет просит опросить глубину архива  отчетов
             begin
                RequestDeep(i);
             //   log('Ответ серверу отчетов на запрос губины  для tg='+list_All.Tag[i]) ;
             end;

           REPORT_DATA:                     // записываем          // пришли данные от сервера i/o - необходимо записать
              begin
               {  log('Приняты данные: time='+
                formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_All.TabTime[i])+' val='+
                floattostr(list_All.Val[i]));  }
                WriteData(i);

              end;
           REPORT_NODATA:                     // записываем          // пришли данные от сервера i/o - необходимо записать
              begin
              {   log('Принят ответ об отсутсвии данных: time='+
                formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_All.TabTime[i])+' tg'+list_All.Tag[i] +' нет данных');   }
                NoData(i);
              end;

           REPORT_WRITED, REPORT_NOWRITED:                     // записываем          // пришли данные от сервера i/o - необходимо записать
              begin
 //                log('Принят ответ службы архивирования о записи');
                CheckWrite(i);
              end;

          REPORT_WRITE:                     // записываем          // пришли данные от сервера i/o - необходимо записать
              begin
               //  log('Принят ответ службы архивирования о записи');
                CheckWrite(i);
              end;

           REPORT_NEEDWAIT:                     // записываем          // пришли данные от сервера i/o - необходимо записать
              begin
              {   log('ПРинят запрос на ожидание прихода отчета');     }
                NeedWaitData(i);
              end;

           REPORT_NORMAL:                   //  100;   //  тег учета успешно опрошен и ждет следующих данных по наступлению время ч
              begin
                 CheckData(i);

              end;

           REPORT_WAIT:
              begin
                 WaitData(i);
              end;

           REPORT_WAITSOURCE:
              begin
                 CheckData(i);

              end;

          end;
          end;
end;


procedure TReportGroupLocator.ReadData(i: integer);
var tm1,tm2: Tdatetime;
    res: real;
begin
   if DBMeneger<>nil then
     begin
       
        
        if list_Sys.SourceID[i]>-1 then
         begin

         case list_Sys.SourceType[i] of

         COUNTBYLOG:
         begin
         if (DBMeneger.getStatistic(frtitems.GetName(list_Sys.SourceID[i]),list_Sys.ReqTime1[i],list_Sys.ReqTime2[i],list_Sys.Agr[i],res)) then
         begin
      {   log('Менджер группы $Report читает данные: time=['+
                formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime1[i])+
                '-'+formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime2[i])+'] '+
                ' val='+
                floattostr(res)+' tg='+list_Sys.Tag[i]);     }
         list_Sys.Val[i]:=res;
         list_Sys.State[i]:=REPORT_DATA;
         end else
         begin

         list_Sys.State[i]:=REPORT_NODATA;
        {  log('Менджер группы $Report не нашел данных: time=['+
                formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime1[i])+
                '-'+formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime2[i])+'] '+
                ' tg='+list_Sys.Tag[i]);     }
         end;
        end;


        COUNTBYREP:

         begin
         if (list_Sys.SourcePeriod[i] in REPORT_SET) then
         begin
         if (DBMeneger.getRepStatistic(frtitems.GetName(list_Sys.SourceID[i]),list_Sys.SourcePeriod[i],list_Sys.ReqTime1[i],list_Sys.ReqTime2[i],list_Sys.Agr[i],res)) then
         begin
        ////// log('Менджер группы $Report читает данные: time=['+
          //      formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime1[i])+
          //      '-'+formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime2[i])+'] '+
           //     ' val='+
           //     floattostr(res)+' tg='+list_Sys.Tag[i]);
         list_Sys.Val[i]:=res;
         list_Sys.State[i]:=REPORT_DATA;
         end else
         begin

         list_Sys.State[i]:=REPORT_NODATA;
      //    log('Менджер группы $Report не нашел данных: time=['+
        //        formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime1[i])+
         //       '-'+formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',list_Sys.ReqTime2[i])+'] '+
         //       ' tg='+list_Sys.Tag[i]);
         end;
        end else
        begin
          list_Sys.State[i]:=REPORT_NODATA;
          log('Менджер группы $Report не нашел данных - источник некорректен');
        end
        end;
        end;

        end

     end;
end;

function TReportGroupLocator.getCount: integer;
begin
   result:=0;
   if self.list_All<>nil then result:=self.list_All.Count;
end;



procedure TReportGroupLocator.DoRowSys;
var i, states: integer;

begin
    for i:=0 to list_Sys.Count-1 do
      begin
         states:= list_Sys.State[i];
         case states of

           REPORT_NEEDREQUEST:
             begin
                ReadData(i);

             end;
          end;
          end;
end;




end.
