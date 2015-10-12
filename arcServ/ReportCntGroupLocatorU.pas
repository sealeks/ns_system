unit ReportCntGroupLocatorU;


interface



uses
  Classes, ActiveX, ConstDef, MemStructsU, SysUtils, MainDataModuleU, DBManagerFactoryU, math, DateUtils;

const APP_NAMEREPORTMENAG='Arch_Serv#RepMenCnt';




type TRepotCntItem   = record
      rtid: integer;
      name: string;
      typ: integer;
      lasttime: TDatetime;
      active: boolean;
      deep: integer;
      delt: integer;
      sourceids: intarray;
      sourcestrs: strarray;
      expr: string;
      sourceperiod: integer;
      tmreq: TDateTime;
      trycount: integer;
      tmwrite: TDateTime; // время для логики write to ArchServ
      tmwait: TDateTime; // время для логики wait
      agr: integer;
      init: boolean;
     end;

type
  PTRepotCntItem = ^TRepotCntItem;




type
  TSysReportCntGroup = class(TList)
  private
    frtitems: TanalogMems;
    finit: boolean;
    reportGrnum: integer;
    ffirst: boolean;
    procedure freeitem_;
    procedure SetItem(i: integer; item: PTRepotCntItem);
    function  GetItem(i: integer): PTRepotCntItem;
    procedure SetState(i: integer; state: integer);
    function  GetState(i: integer): integer;
    function  GetTyp(i: integer): integer;
    function  GetDeep(i: integer): integer;
    function  GetVal(i: integer): real;
    procedure  SetVal(i: integer; vals: real);
    function  GetTag(i: integer): string;

    function  GetDelt(i: integer): integer;
    function  GetRtid(i: integer): integer;
    function  GetSourceID(i: integer): intarray;
    function  GetSourcePeriod(i: integer): integer;
    function  GetReqTime(i: integer): TdateTime;
    function  GetAgr(i: integer): integer;
    function  GetSourceReady(i: integer): boolean;
    { Private declarations }
  protected
    function Add_(it: PTRepotCntItem): boolean;
    function findBS(IDS: integer): PTRepotCntItem;

    function inital: boolean;
    function uninital: boolean;

    function  GetInit: boolean;
    procedure SetInit(val: boolean);
    procedure Log(mess: string; lev: byte = 2);
  public
    constructor Create(frtitems_: TanalogMems);
    destructor destroy;
    procedure addItem(id_: integer);
    property items[i: integer]: PTRepotCntItem read getItem write setItem; default;
    property init: boolean read getInit write setInit;
    property State[i: integer]: integer read getState write setState;
    property Deep[i: integer]: integer read getDeep;
    property Val[i: integer]: real read getVal write setVal;
    property Delt[i: integer]: integer read getDelt;
    property Typ[i: integer]:  integer read getTyp;
    property RtId[i: integer]:  integer read getRtId;
    property SourceID[i: integer]:  intarray read getSourceID;
    property SourcePeriod[i: integer]:  integer read getSourcePeriod;
    property Tag[i: integer]:  string read getTag;
    property Agr[i: integer]:  integer read getAgr;
    //время когда фактически необходим опрос
    //задействуются механизмы опроса( может расходится с TabTime
    property ReqTime[i: integer]: TdateTime read getReqTime; // write setReqTime;


  end;







type
  TReportCntGroupLocator = class(TThread)
  private
    fDBMeneger: TMainDataModule;
    DBmenagtyp: integer;
    fconstr: string;
    list_Sys: TSysReportCntGroup;
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
     procedure ReadData(i: integer);


     function  getRoundTime(typ_: integer; dt: TDateTime): TDateTime;

  protected
    procedure Execute; override;
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



constructor TSysReportCntGroup.Create(frtitems_: Tanalogmems);
begin
   frtitems:=frtitems_;
   finit:=false;
   init:=true;
end;



destructor TSysReportCntGroup.destroy;
begin
   freeitem_;
   inherited destroy;
end;

procedure TSysReportCntGroup.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;





function TSysReportCntGroup.inital: boolean;
var i: integer;
begin
  result:=finit;
  if finit then exit;
  try
  reportGrnum:=frtItems.TegGroups.ItemNum['$REPORTCOUNT'];
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

function TSysReportCntGroup.uninital: boolean;
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

function  TSysReportCntGroup.GetInit: boolean;
begin
   result:=finit;
end;


procedure TSysReportCntGroup.SetInit(val: boolean);
begin
  if finit<>val then
    begin
      if val then finit:=inital
      else finit:=false;
    end
end;


function TSysReportCntGroup.GetItem(i: integer): PTRepotCntItem;
begin
  result := inherited Items[i];
end;

procedure TSysReportCntGroup.SetItem(i: integer; item: PTRepotCntItem);
begin
  Items[i] := item;
end;



procedure TSysReportCntGroup.addItem(id_: integer);
// определяет корректен ли источник для отчетных данных
function CheckSource(typ_: integer; name_,source_: string; var  sourceid_: intarray; var names_: strarray): integer;
procedure getIDs(source_: string; var  ids: intarray; var tags: strarray);
var tmp_source: string;
    k: integer;
    sl: TStringList;
     tf: TFormatSettings;
begin
   source_:=trim(uppercase( source_));
   source_:=StringReplace(source_,'(',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'sqrt',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,',',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,')',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'/',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'*',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'+',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'-',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'<',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'>',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,'=',' ',[rfReplaceAll, rfIgnoreCase]);
   source_:=StringReplace(source_,':',' ',[rfReplaceAll, rfIgnoreCase]);
   tmp_source:=StringReplace(source_,'  ',' ',[rfReplaceAll, rfIgnoreCase]);
   while (tmp_source<>source_)  do
    begin
      source_:=tmp_source;
      tmp_source:=StringReplace(source_,'  ',' ',[rfReplaceAll, rfIgnoreCase]);
    end;
   source_:=tmp_source;
   source_:=trim(source_)+' ';
   try
   sl:=TStringList.Create;
   sl.Duplicates:=dupIgnore;
   sl.Sorted:=true;
   sl.CaseSensitive:=false;
   tmp_source:='';
   for k:=1 to length(source_) do
     if source_[k]<>' ' then
       tmp_source:=tmp_source+source_[k]
     else
       begin
         sl.Add(tmp_source);
         tmp_source:='';
       end;
   finally
     k:=0;
     while (k<sl.Count) do
       begin
        // TFormatSettings tf
        // sl.Strings[k]:=StringReplace(sl.Strings[k],'.',',',[rfReplaceAll, rfIgnoreCase]);
         tf.DecimalSeparator:='.';
         if StrToFloatDef(sl.Strings[k],-12456789.12345, tf)=-12456789.12345 then
          k:=k+1
         else
           sl.Delete(k);
       end;
     setlength(tags, sl.Count);
     setlength(ids, sl.Count);
     for k:=0 to sl.Count-1 do
       begin

         tags[k]:=sl.Strings[k];
         ids[k]:=frtitems.GetSimpleID(tags[k]);
       end;
   end;


end;
var
    sourcetype: integer;
    k1: integer;
begin
   result:=-1;
   getIDs(source_, sourceid_, names_);
   if length(sourceid_)>0 then
      if sourceid_[0]>-1 then result:=round(frtitems[sourceid_[0]].logTime);
   for k1:=1 to length(sourceid_)-1 do
     if (result<>-1) then
        if sourceid_[k1]>-1 then
          if round(frtitems[sourceid_[k1]].logTime)<>result then result:=-1;
   if (typ_<>result) then result:=-1;
   if (result=-1) then setlength(names_,0);
   if (result=-1) then setlength(sourceid_,0);
end;
   var
    it: PTRepotCntItem;
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
         new(it);
         sourcetyp:=CheckSource(typ_,name_,source_,it.sourceids,it.sourcestrs);
         if sourcetyp in REPORT_SET  then
         begin
           if (id_>-1)  then
            begin

            it.name:=name_;
            it.rtid:=id_;
            it.typ:=typ_;
            it.expr:=source_;
            it.lasttime:=0;
            it.active:=false;
            frtitems.IncCounter(id_);
            it.agr:=frtitems[id_].PreTime;
             it.sourceperiod:=speriod;
            it.delt:= round(frtitems[id_].AlarmConst);
            if (not Add_(it)) then dispose(it);
            frtitems[id_].ValidLevel:=REPORT_NEEDKHOWDEEP;
           // log('Менджер группы $Report не добавил в опрос tg='+name_+',т.к источник  не задан',_DEBUG_WARNING) ;

            end;
         end else
         begin
            dispose(it);
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

function TSysReportCntGroup.Add_(it: PTRepotCntItem): boolean;
var
  SV: PTRepotCntItem;
  i: integer;
begin
  result:=false;
  if it=nil then exit;
  if it.rtid<0 then exit;
  if findBS(it.rtid)<>nil then exit;

  for i:=0 to count-1 do
   begin
     if PTRepotCntItem(items[i]).rtid>it.rtid then
      begin
       inherited Insert(i,it);
       result:=true;
       exit;
      end;
   end;
  inherited Add(it);
  result := true;
end;

function  TSysReportCntGroup.GetTyp(i: integer): integer;
begin
   result:=items[i].typ;
end;


function  TSysReportCntGroup.GetDeep(i: integer): integer;
begin
  result:=items[i].deep;
end;

function  TSysReportCntGroup.GetSourceID(i: integer): intarray;
begin
  result:=items[i].sourceids;
end;

function  TSysReportCntGroup.GetSourceReady(i: integer): boolean;
var j: integer;
begin
  result:=false;
 // result:=true;
  //exit;
  for j:=0 to Length(SourceID[i])-1 do
    begin
    if SourceID[i][j]<0 then exit;
    if frtitems[SourceID[i][j]].validlevel<>REPORT_NORMAL then exit;
    end;
  result:=true;
end;

function  TSysReportCntGroup.GetSourcePeriod(i: integer): integer;
begin
  result:=items[i].sourceperiod;
end;

function  TSysReportCntGroup.GetDelt(i: integer): integer;
begin
  result:=items[i].delt;
end;

function  TSysReportCntGroup.GetVal(i: integer): real;
begin
   result:=frtitems[Items[i].rtid].ValReal;
end;

procedure  TSysReportCntGroup.SetVal(i: integer; vals: real);
begin
   frtitems[Items[i].rtid].ValReal:=vals;
end;

function  TSysReportCntGroup.GetTag(i: integer): string;
begin
   result:=Items[i].name;
end;

function  TSysReportCntGroup.GetRtid(i: integer): integer;
begin
  result:=items[i].rtid;
end;

function  TSysReportCntGroup.GetAgr(i: integer): integer;
begin
  result:=items[i].agr;
end;







function  TSysReportCntGroup.GetReqTime(i: integer): TdateTime;
var vdt: TDateTime;
begin
   vdt:=frtitems[Items[i].rtid].TimeStamp;
   vdt:=incPeriod(typ[i],vdt,0);
   result:=
           GetTimeReqByTabTimeforSys(vdt,typ[i],delt[i]);
end;






procedure TSysReportCntGroup.freeitem_;
var
  i: integer;
begin
  for i:=0 to count-1 do
   begin
     setlength(items[i].sourceids,0);
     setlength(items[i].sourcestrs,0);
     dispose(items[i]);
   end;
end;


function TSysReportCntGroup.findBS(IDS: integer): PTRepotCntItem;
var x1,x2,xs: integer;
begin
    result:=nil;
    x1:=0;
    x2:=count-1;
    if x2<0 then exit;
    while (PTRepotCntItem(items[x1]).rtid<>PTRepotCntItem(items[x2]).rtid) do
      begin
        if PTRepotCntItem(items[x1]).rtid>IDS then exit;
        if PTRepotCntItem(items[x2]).rtid<IDS then exit;
        if PTRepotCntItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotCntItem(items[x1]);
           exit;
          end;
        if PTRepotCntItem(items[x2]).rtid=IDS then
          begin
           result:=PTRepotCntItem(items[x2]);
           exit;
          end;
       xs:=round((x1+x2)/2);
       if PTRepotCntItem(items[xs]).rtid>IDS then x2:=xs
         else x1:=xs;
     end;
      if PTRepotCntItem(items[x1]).rtid=IDS then
          begin
           result:=PTRepotCntItem(items[x1]);
           exit;
          end;
end;


procedure TSysReportCntGroup.SetState(i: integer; state: integer);
begin
   case state of
       REPORT_NEEDWAIT:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDWAIT;
       REPORT_NEEDKHOWDEEP:  frtitems[items[i].rtid].ValidLevel:=REPORT_NEEDKHOWDEEP;
       REPORT_DATA:       frtitems[items[i].rtid].ValidLevel:=REPORT_DATA;
       REPORT_NODATA:     frtitems[items[i].rtid].ValidLevel:=REPORT_NODATA;
   end;
end;

function  TSysReportCntGroup.GetState(i: integer): integer;
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




constructor TReportCntGroupLocator.Create(path: string; menagtyp: integer; constr: string);
begin
   inherited Create(false);
   DBmenagtyp:=menagtyp;
   fconstr:=constr;
   frtitems:=TanalogMems.Create(path);
   frtItems.SetAppName(APP_NAMEREPORTMENAG);
  // list_All:=TReportCntGroup.Create(frtitems);
   list_Sys:=TSysReportCntGroup.Create(frtitems);
   finit:=false;
   ffirst:=true;
   fLastReqTime:=0;
   fDBNoset:=false;
   fLastConn:=true;   // полпгаем что соединение было
   CoInitialize(nil);
end;

procedure TReportCntGroupLocator.Log(mess: string; lev: byte = 2);
begin
    if frtitems<>nil then
        frtitems.Log(mess,lev);
end;

destructor TReportCntGroupLocator.Destroy;
begin
  // list_All.Free;
   list_Sys.Free;
   if fDBMeneger<>nil then  fDBMeneger.Free;
   CoUnInitialize;
   inherited destroy;
end;

function  TReportCntGroupLocator.getDBMeneger: TMainDataModule;
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



function  TReportCntGroupLocator.getRoundTime(typ_: integer; dt: TDateTime): TDateTime;
var tmp_d: integer;
    dt1: TDateTime;
begin

   result:= incPeriod(typ_,dt,0);
end;


// предвигает на период вперед период  для TabTime  поэтому время вседа округлено
//при ноле просто производит округление до корректного периода




function  TReportCntGroupLocator.getInit: boolean;
begin
   result:=false;
   {if (not list_All.init) then
     begin
       list_All.init:=true;
     end; }
   if (not list_Sys.init) then
     begin
       list_Sys.init:=true;
     end;
   result:=((getDBMeneger<>nil) {and (list_All.init)} and (list_Sys.init));
end;



procedure TReportCntGroupLocator.Execute;
begin
  while (not Terminated) do
  begin
   try
   try
     if  Init then
       begin
          if (DBMeneger<>nil) then
          begin

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




procedure TReportCntGroupLocator.ReadData(i: integer);
var tm1,tm2: Tdatetime;
    res: real;
begin
   if DBMeneger<>nil then
     begin
         if ((list_Sys.GetSourceReady(i)) and (list_Sys.Typ[i] in REPORT_SET)) then
           begin

              if (DBMeneger.getRepCountData(list_Sys[i].name,list_Sys[i].expr,list_Sys[i].sourcestrs,list_Sys.Typ[i],list_Sys.ReqTime[i],res)) then
                 begin
                  list_Sys.Val[i]:=res;
                  list_Sys.State[i]:=REPORT_DATA;
                end else
                 begin
                   list_Sys.State[i]:=REPORT_NODATA;
                 end;
           end;


     end
end;

function TReportCntGroupLocator.getCount: integer;
begin
   result:=0;
  if list_Sys<>nil then result:=list_Sys.Count;
end;



procedure TReportCntGroupLocator.DoRowSys;
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
