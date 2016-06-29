unit MainDataModuleU;

interface

uses
  SysUtils, Classes, Forms, DateUtils,DB,math, ConstDef, MemStructsU;

type
  TTrendDefOp= (tdoAdd, tdoUpdate, tdoDelete);



type
  TDBAction = (dbaReadOnly, dbaAll);

type
 LostConnectionError = class (Exception);

type intarray = array of integer;
type strarray = array of string;




// метаинформация отчетов
type TReporttag = record
     tg: string;
     eu: string;
     comment: string;
     cod: integer;
     typeEl: integer;
     agrType: integer;
     rnd: integer;
     rnffmt: string;

     end;

type
PReporttag = ^TReporttag;



// метаинформация Trenddef
type TTrenddefRec = record
      cod: integer;
      iname: string;
      comment: string;
      eu: string;
      mineu: Double;
      maxeu: Double;
      minraw: Double;
      maxraw: Double;
      logdb: Double;
      logtime: integer;
      deadbaund: Double;
      onmsg: boolean;
      offmsg: boolean;
      almsg: boolean;
      logged: boolean;
   end;

type
PTrenddefRec = ^TTrenddefRec;


type
  TTrenddefList = class(TStringlist)
   private
   finit: boolean;
   public
     constructor create;
     destructor destroy;
     function GetId(nm: string): integer;
     function GetInfo(nm: string): PTrenddefRec;
     function AddItems(cod: integer;
      iname: string;
      comment: string;
      eu: string;
      mineu: Double;
      maxeu: Double;
      minraw: Double;
      maxraw: Double;
      logdb: Double;
      logtime: integer;
      deadbaund: Double;
      onmsg: boolean;
      offmsg: boolean;
      almsg: boolean;
      logged: boolean
      ): PTrenddefRec;
      property Init: boolean read fInit write fInit;
   end;

// метаинформация отчетов
type TReportUtit = class (TStringList)
  private

     ftypeEl: integer;
     fresult_: boolean;
     fwidth: integer;
     fheight: integer;
     fdelt: integer;
     fgroup: integer;
     fsubperiod: boolean;
     finitperiod: boolean;
     finit: boolean;

     fHeader: string;
     fFooter: string;
  public

   fautoprint: boolean;
   fautoclose: boolean;

   function    GetInfo(nm: string):  PReporttag;

   constructor create(
     ffHeader: string;
     fftypeEl: integer;
     ffresult_: boolean;
     ffwidth: integer;
     ffheight: integer;
     ffdelt: integer;
     ffgroup: integer;
     ffinitperiod: boolean;
     ffsubperiod: boolean;
     ffautoprint: boolean;
     ffautoclose: boolean;
     ffFooter: string
   );
   destructor destroy;

   function AddItems(tg: string;
     eu: string;
     comment: string;
     cod: integer;
     typeEl: integer;
     fagrType: integer;
     rnd: integer): PReporttag; overload;
    function  AddItems(tg: string;
     fagrType: integer;
     rnd: integer): PReporttag; overload;

    function  initItems(
     lst: TTrenddefList): PReporttag;

    function GetCod(Index: Integer): integer;
    function GetAGR(Index: Integer): integer;
    function GetTyp(Index: Integer): integer;
    function GetTg(Index: Integer): string;
    function GetComment(Index: Integer): string;
    function GetEu(Index: Integer): string;
    function GetFormat(Index: Integer): string;

    property typeEl: integer read ftypeEl;
    property result_: boolean read fresult_;
    property width: integer read fwidth;
    property height: integer read fheight;
    property delt: integer read fdelt;
    property group: integer read fgroup;
    property Header: string read fHeader;
    property Footer: string read fFooter;
    property InitPeriod: boolean read fInitPeriod;
    property SubPeriod: boolean read fSubPeriod;
    property Init: boolean read fInit;
  end;




type
  TMainDataModule = class(TObject)
  private
     fserver: string;
     fuser: string;
     fpassword: string;
     fschema: string;
     fdatabase: string;
     fport: integer;
     fprop: string;
     faction: TDBAction;
     flocalhost: string;
     fprefix: string;
     fglobal: boolean;
     fsessionN: string; // для уникальности сессий bde
     fpropocol: string;
     fTrDF: TTrenddefList;
     fnodestryList: boolean;
    { Private declarations }
  protected

    DS: TDataSource;
  //  ffreeDS: boolean;
    function  getProperty: string;
    // удаление таблиц по типам
    function delTrTable(time: TDateTime): boolean;
    function delAlTable(time: TDateTime): boolean;
    function delRepTable(time: TDateTime): boolean;
    function deloscTable(time: TDateTime): boolean;

    //установщики свойств
    procedure setServer(val: string);
    procedure setPrefix(val: string);
    procedure setUser(val: string);
    procedure setPassword(val: string);
    procedure setSchema(val: string);
    procedure setDataBase(val: string);
    procedure setLocalhost(val: string);
    procedure setGlobal(val: boolean);
    procedure setPort(val: integer);

    // инициализатор и деинициализатор
    procedure init();  virtual;
    procedure uninit();  virtual;

    function getTrdef: TTrenddefList;
    procedure setTrdef( val : TTrenddefList);

    procedure setConnected(val: boolean);
    function getConnected(): boolean;  virtual;

    function WriteAlarm (id: integer; igroup, itag, iComment: string; iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;  overload; virtual;

    //чтенеие  dataset c данными trend  // шаблонный метод
    procedure readDataSet(Datset: TDataSet; starttime: TDateTime; stopTime: TDateTime; var res: tTDPointData; endp: boolean = true);
    procedure readDataSetNative(Datset: TDataSet; starttime: TDateTime; stopTime: TDateTime; var res: tTDPointData);
    // чтение последних данных по параметру rtid в таблицеах отчетов
    // реализация в потомках
    function GetLastRep(rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime ): boolean; virtual;
    function WriteLog   (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer;overload;  virtual;
    function WriteReport (Code:longInt;  typ: integer; Data: real; time: TDateTime): integer;overload; virtual;
    function WriteOsc(time: TdateTime; itid: integer; idelt: integer): integer; overload; virtual;
    function getRepCountData_(itag: string; expr_: string; strlist: strarray;  intlist: intarray; typ_: integer; time: TDateTime; var ress: real): boolean; virtual;

    // получение трендовых данных
    // данные помещаются в res
    procedure GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true); overload;  virtual;
     // получение отчетных данных
   // данные помещаются в res
    procedure GetRepData(id: integer;  typ_: integer; starttime: TDateTime; stopTime: TDateTime); overload;  virtual;

    function  getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet; virtual;

    function WriteTrendDefList(list: TTrenddefList; recreate_: boolean = false;
                                deletenoexists_: boolean=false; global_: string=''): integer; virtual;
  public
    res: tTDPointData;

    function CheckConnection(E: Exception): integer; virtual;

   // constructor create(conf: string);   overload;
    constructor create(conf: string; _faction: TDBAction = dbaReadOnly;
                       global_: boolean = false; session_: string = '');  //overload;
    destructor Destroy;  override;

    // тест соединения
    //переписывается в потомках
    function TestConnect(): boolean;  virtual;

    function Connect(): boolean;  virtual;
    function DisConnect(): boolean;  virtual;
    function testbefore: boolean; virtual;

    function recConnect(): boolean;

    function DateToFileName(iDate: TDateTime): String;
    function MonthToFileName(iDate: TDateTime): String;
    function DateToFileNameU(iDate: TDateTime; typ: integer): String;

    //
    function trendDateToFileName(iDate: TDateTime): String;
    function alarmDateToFileName(iDate: TDateTime): String;
    function ReportDateToFileName(iDate: TDateTime; typ: integer): String;
    function oscDateToFileName(iDate: TDateTime; typ: integer): String;

    function CreateRepTable(iFileName: String): boolean; virtual;
    function CreateTrTable(iFileName: String): boolean;  virtual;
    function CreateAlTable(iFileName: String): boolean;  virtual;
    function CreateOcsTable(iFileName: String): boolean;  virtual;
    function CreateTrenddef(): boolean;  virtual;


    function WriteLog   (itag: string; Data: real; time: TDateTime; validLevel: boolean): integer; overload;
    function WriteReport (itag: string;  typ: integer; Data: real; time: TDateTime): integer;overload;
    function WriteAlarm (id: integer; igroup, itag, iComment: string; iState: TJournalMessageType; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;  overload;
    function WriteOsc(itag: string; itid: integer; idelt: integer): integer; overload;
    function WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
             onmsg_: boolean; offmsg_: boolean; almsg_: boolean; logged: boolean; oper: TTrendDefOp; list: TTrenddefList): integer;  virtual;

    function ClearArchive(val: integer; first: boolean): boolean;
    function delTable(fn: string): boolean;  virtual;
    function deleteTrenddef(): boolean;

    procedure setProperty(val: string);

    // последние данные в таблице отчетов
    function GetLastReport(itag: string; typ_: integer; present_: integer; var tms: TdateTime ): boolean;


    function  GetLogID(iname: string): integer;  virtual;

        // получение трендовых данных
    // данные помещаются в res
    procedure GetLogData(itag: string; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true); overload;

    //отчетная статистика по параметру  на основе данных по графикам
    function getStatistic(itag: string; starttime: TDateTime; stopTime: TDateTime; agr: integer; var ress: real): boolean;

    function getRepCountData(itag: string; expr_: string; strlist: strarray;  typ_: integer; time: TDateTime; var ress: real): boolean;

    // получение отчетных данных
   // данные помещаются в res
    procedure GetRepData(itag: string;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);  overload;

    //отчетная статистика по параметру  на основе данных по отчетам
    function getRepStatistic(itag: string;  typ_: integer; starttime: TDateTime; stopTime: TDateTime; agr: integer; var ress: real): boolean;

    // получение данных журнала

    function getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet;
    tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet; virtual;

    // получение данных отчета
    function getReportTable(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit; var res: TReportTable): boolean;

    function  regTrdef(error: boolean=false): TTrenddefList;

    procedure loadTrdef(val : TTrenddefList; error: boolean=false); virtual;

    //  Утилиты запуска, останова, ежедневные, ежечасные

    procedure StartUtilite; virtual;

    procedure HourUtilite; virtual;

    procedure DayUtilite; virtual;

    procedure StopUtilite; virtual;


    procedure FreeAndReLease; virtual;
    procedure FreeReLease;

    property Server: string read fserver write setserver;
    property Prefix: string read fPrefix write setPrefix;
    property User: string read fuser write setuser;
    property Password: string read fPassword write setPassword;
    property Schema: string read fSchema write setSchema;
    property DataBase: string read fDataBase write setDataBase;
    property Port: integer read fPort write setPort;
    property localhost: string read flocalhost write setlocalhost;
    property global: boolean read fglobal write setglobal;
    property action:  TDBAction read  faction;
    property Conneted: boolean read getConnected write setConnected;
    property Prop: string read getProperty write setProperty ;
    property sessionN: string read fsessionN write fsessionN;
    property propocol: string read fpropocol write fpropocol;
    property TrDF: TTrenddefList read getTrdef write setTrdef;
  end;


function gettmpalias(t: integer): string;

implementation



function gettmpalias(t: integer): string;
begin
  t:=abs(t);
  result:=trim('aaa'+inttostr(t)+'aaa');
end;


procedure TMainDataModule.init();
begin
end;


procedure TMainDataModule.uninit();
begin
end;





constructor TMainDataModule.create(conf: string; _faction: TDBAction = dbaReadOnly;
                       global_: boolean= false; session_: string = '');
begin
  inherited create;
  init();
  setProperty(conf);
  faction:=_faction;
  global:=global_;
  sessionN:=session_;
  DS:=TDataSource.Create(nil);
 // ffreeDS:=freeDS;
  fTrDF:=nil;
  fnodestryList:=false;
end;

destructor TMainDataModule.Destroy;
begin
  try
  uninit();
  if not fnodestryList then
    begin
      if fTrDF<>nil then
        fTrDF.Free;
    end;
  except
  end;
  try
  FreeAndReLease;
  except
  end;
  if DS<>nil then DS.Free;
  inherited destroy;
end;

procedure TMainDataModule.FreeAndReLease;
begin

end;

procedure TMainDataModule.FreeReLease;
begin
FreeAndReLease;
end;

procedure TMainDataModule.setProperty(val: string);
  function findValNum(val: string; str: string):integer;
    var pos_,i: integer;
        numstr: string;
        fl: boolean;
    begin
       fl:=true;
       result:=-1;
       numstr:='';
       val:=trim(uppercase(val));
       str:=trim(uppercase(str));
       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str[i];
            end;
         end;
       try
         result:=strtoint(numstr);
       except
       end;
    end;

  function findtext(val: string; str: string):String;
    var pos_,i: integer;
        numstr,str1: string;
        fl: boolean;
    begin
       fl:=true;
       result:='';
       numstr:='';
       val:=trim(uppercase(val));
       str1:=trim(str);
       str:=trim(uppercase(str));

       pos_:=pos(val,str);
       if pos_<1 then exit;
       for i:=pos_+length(val) to length(str) do
         begin
           if fl then
            begin
             if ((str[i]=';') or (str[i]=',') or (str[i]=';')) then fl:=false else
             numstr:=numstr+str1[i];
            end;
         end;
       try
         result:=numstr;
       except
       end;
    end;
var tempval: string;
begin
   if (fprop<>val) then
   begin
   if val='' then exit;
   tempval:=trim(val);
   if tempval<>'' then
    begin
           server:=findtext('server=',tempval);
           user:=findtext('user=',tempval);
           password:=findtext('password=',tempval);
           database:=findtext('database=',tempval);
           schema:=findtext('schema=',tempval);
           schema:=findtext('prefix=',tempval);
           port:=findValNum('port=',tempval);
           
    end;
    fprop:=val;
    end;
end;

function  TMainDataModule.getProperty: string;
begin
   result:='server='+Server+';'+'database='+database+';';
   if (Schema<>'') then result:=result+'schema='+Schema+';';
   result:=result+'user='+User+';'+'password='+Password+';';
   if (prefix<>'') then result:=result+'prefix='+prefix+';';
   if (port<>0) then result:=result+'port='+inttostr(Port);
end;

function TMainDataModule.testbefore: boolean;
begin

end;

procedure TMainDataModule.setServer(val: string);
begin
  fserver:=val;
end;

procedure TMainDataModule.setPrefix(val: string);
begin
  fPrefix:=val;
end;

procedure TMainDataModule.setUser(val: string);
begin
  fuser:=val;
end;

procedure TMainDataModule.setPassword(val: string);
begin
  fpassword:=val;
end;

procedure TMainDataModule.setSchema(val: string);
begin
  fschema:=val;
end;

procedure TMainDataModule.setDataBase(val: string);
begin
  fdatabase:=val;
end;

procedure TMainDataModule.setPort(val: integer);
begin
  fport:=val;
end;

procedure TMainDataModule.setLocalhost(val: string);
begin
   flocalhost:=val;
end;

procedure TMainDataModule.setGlobal(val: boolean);
begin
   fglobal:=val;
end;

function TMainDataModule.Connect(): boolean;
begin

end;

function TMainDataModule.TestConnect(): boolean;
begin
   Connect;
end;

function TMainDataModule.DisConnect(): boolean;
begin

end;

function TMainDataModule.getConnected(): boolean;
begin

end;

function TMainDataModule.recConnect(): boolean;
begin
  DisConnect();
  Connect();
end;


procedure TMainDataModule.setConnected(val: boolean);
begin
    if val then Connect() else
        DisConnect();
end;

function TMainDataModule.DateToFileNameU(iDate: TDateTime; typ: integer): String;
begin

     iDate:=incSecond(iDate,-10);
     if (typ in REPORT_SET_ONETAB) then
     begin
     result := 'arch';
     exit;
     end;
     if (typ in REPORT_SET_YEARTAB) then
     begin
     result := 'arch'+trim(formatdatetime('yyyy',iDate));
     exit;
     end;
     result := 'arch'+trim(formatdatetime('mmyyyy',iDate));

end;

function TMainDataModule.DateToFileName(iDate: TDateTime): String;
begin
     result := trim(formatdatetime('ddmmyyyy',iDate));
end;

function TMainDataModule.MonthToFileName(iDate: TDateTime): String;
begin
     result := trim(formatdatetime('mmyyyy',iDate));
end;

function TMainDataModule.TrendDateToFileName(iDate: TDateTime): String;
begin
      result:='tr'+DateToFileName(iDate);
end;

function TMainDataModule.AlarmDateToFileName(iDate: TDateTime): String;
begin
      result:='al'+MonthToFileName(iDate);
end;

function TMainDataModule.ReportDateToFileName(iDate: TDateTime; typ: integer): String;
begin
      result:=DateToFileNameU(iDate,typ);
end;

function TMainDataModule.oscDateToFileName(iDate: TDateTime; typ: integer): String;
begin

end;

function TMainDataModule.CreateTrTable(iFileName: String): boolean;
begin
end;

function TMainDataModule.CreateAlTable(iFileName: String): boolean;
begin
end;

    //  Утилиты запуска, останова, ежедневные, ежечасные

procedure TMainDataModule.StartUtilite;
begin
end;

procedure TMainDataModule.HourUtilite;
begin
end;

procedure TMainDataModule.DayUtilite;
begin
end;

procedure TMainDataModule.StopUtilite; 
begin
end;

function TMainDataModule.CreateRepTable(iFileName: String): boolean;
begin
end;

function TMainDataModule.CreateOcsTable(iFileName: String): boolean;
begin
end;

function TMainDataModule.CreateTrenddef(): boolean;
begin

end;

function TMainDataModule.WriteLog (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer;
begin
end;

function TMainDataModule.WriteAlarm (id: integer; igroup, itag, iComment: string; iState: TJournalMessageType; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;
begin
   result:=WriteAlarm (id,igroup, itag, iComment, getTextJmessage(iState), iAlarmLevel, comp, oper, time);
end;

function TMainDataModule.WriteAlarm (id: integer; igroup, itag, iComment: string; iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;
begin
end;

function TMainDataModule.WriteReport(Code:longInt;  typ: integer; Data: real; time: TDateTime): integer;
begin
end;



function TMainDataModule.WriteOsc(time: TdateTime; itid: integer; idelt: integer): integer;
begin
end;

function TMainDataModule.WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
           onmsg_: boolean; offmsg_: boolean; almsg_: boolean;logged: boolean; oper: TTrendDefOp; list: TTrenddefList): integer;
begin

end;

function TMainDataModule.ClearArchive(val: integer; first: boolean ): boolean;
var DL,i, depth: integer;
    tm: TDateTime;
begin
if val<0 then exit;


if val<1 then DL:=6 else DL:=val;

// очистка трендов

   depth:=100;
   if (first) then
      begin
         depth:=900;
      end;


   tm:=incMonth(now,-DL);
   tm:=incday(tm,-1);

   if (rtItems<>nil) then
          rtItems.Log('delete trtabel start name: '+ trendDateToFileName(tm),_DEBUG_WARNING);

   for i:=0 to depth do
       begin
        delTrTable(tm);
        tm:=incday(tm,-1);
       end;

   if (rtItems<>nil) then
          rtItems.Log('delete trtabel stop name: '+ trendDateToFileName(tm),_DEBUG_WARNING);

// очистка журнала и отчентов

   if (rtItems<>nil) then
          rtItems.Log('delete tabel start name: '+ alarmDateToFileName(tm) + ' ... ' + ReportDateToFileName(tm,REPORTTYPE_HOUR),_DEBUG_WARNING);

   tm:=incMonth(now,-(DL+1));
   tm:=incday(tm,-1);
   delAlTable(tm);
   delRepTable(tm);

   if (first) then
     begin
        depth:=30;
        for i:=0 to depth do
          begin
            delAlTable(tm);
            delRepTable(tm);
            tm:=incMonth(tm,-1);
       end;
     end;

    if (rtItems<>nil) then
          rtItems.Log('delete tabel stop name: '+ alarmDateToFileName(tm) + ' ... ' + ReportDateToFileName(tm,REPORTTYPE_HOUR),_DEBUG_WARNING);
// очистка отчетов

   //tm:=incYear(now,-DL);
   //tm:=incmonth(tm,-1);
   {delRepTable(tm);}
   //delOscTable(tm);
   
end;

function TMainDataModule.delTable(fn: string): boolean;
begin

end;

function TMainDataModule.delTrTable(time: TDateTime): boolean;
var
   fn : string;
begin
     fn := trendDateToFileName(time);
     delTable(fn);
end;

function TMainDataModule.delAlTable(time: TDateTime): boolean;
var
   fn : string;
begin
   fn := alarmDateToFileName(time);
   delTable(fn);
end;

function TMainDataModule.delRepTable(time: TDateTime): boolean;
var
   fn : string;
begin
   fn := ReportDateToFileName(time,REPORTTYPE_HOUR);
   delTable(fn);
end;

function TMainDataModule.deloscTable(time: TDateTime): boolean;
begin
end;

function TMainDataModule.deleteTrenddef(): boolean;
begin
   delTable('trenddef');
end;



function TMainDataModule.GetLogID(iname: string): integer;
begin

end;

procedure TMainDataModule.GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true);
begin

end;

procedure TMainDataModule.GetRepData(id: integer;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);
begin

end;

function TMainDataModule.getStatistic(itag: string; starttime: TDateTime; stopTime: TDateTime; agr: integer; var ress: real): boolean;
var// tmp: tTDPointData;
    res1: real;
    i,id: integer;
begin
     try
     result:=false;
     ress:=0;

     id:=-1;
     result:=false;
     if TrDF<>nil then
     begin
        id:=TrDF.GetId(itag);
        if id<0 then
          begin
            result:=false;
            exit;
          end;
     end else
     begin
       result:=false;
       exit;
     end;

                                        // включаем конечные точки, если интеграл
     GetLogData(id, starttime, stopTime,agr<>REPORTAGR_INTEG);
     if (res.npoint=0) then exit;
     if ((res.ntime=1) and ((starttime=res.time[0][1]) and (stoptime=res.time[0][2]))) then exit;
     case agr of
        REPORTAGR_INTEG:   //  интеграл
            begin
               ress:=0;
               for i:=0 to res.npoint-2 do
                ress:=ress+(res.point[i+1][2]-res.point[i][2])*(res.point[i][1])*24;
                ress:=ress+ (stopTime-res.point[res.npoint-1][2])*(res.point[res.npoint-1][1])*24;
               result:=true;

            end;
        REPORTAGR_MIN:
            begin      // минимум
              ress:=res.point[0][1];
              for i:=0 to res.npoint-1 do
                if res.point[i][1]<ress then ress:=res.point[0][1];
               result:=true;
            end;
        REPORTTYPE_MAX:
            begin    // максимум
               ress:=res.point[0][1];
              for i:=0 to res.npoint-1 do
                if res.point[i][1]>ress then ress:=res.point[0][1];
               result:=true;
            end;
        REPORTTYPE_SCO:
            begin
              res1:=0;
              for i:=0 to res.npoint-1 do
                res1:=res1+res.point[i][1];
              if res.npoint>0 then res1:=res1*1.0/(1.0*res.npoint);
              ress:=0;
              for i:=0 to res.npoint-1 do
                ress:=ress+sqrt(abs(res.point[i][1]-res1));
              if res.npoint>0 then ress:=ress*1.0/(1.0*res.npoint);
               result:=true;
            end;
        else
            begin   // среднее
              ress:=0;
              for i:=0 to res.npoint-1 do
                ress:=ress+res.point[i][1];
              if res.npoint>0 then ress:=ress*1.0/(1.0*res.npoint);
              result:=true;
            end;
       end;
     finally
     setlength(res.point,0);
     setlength(res.time,0);
     end;
end;

function TMainDataModule.getRepCountData(itag: string; expr_: string; strlist: strarray;  typ_: integer; time: TDateTime; var ress: real): boolean;
var intlist: intarray;
    i: integer;
begin
  result:=false;
  try
  try
  setlength(intlist,length(strlist));
  for i:=0 to length(strlist)-1 do
     intlist[i]:=TrDF.GetId(strlist[i]);
  result:=getRepCountData_(itag, expr_, strlist,intlist,  typ_, time, ress);
  except
  end;
  finally
  setlength(intlist,0);
  end;
end;

function TMainDataModule.getRepCountData_(itag: string; expr_: string; strlist: strarray;  intlist: intarray; typ_: integer; time: TDateTime; var ress: real): boolean;
begin
   result:=false;
end;

// статистика по отчетным данным
function TMainDataModule.getRepStatistic(itag: string;  typ_: integer; starttime: TDateTime; stopTime: TDateTime; agr: integer; var ress: real): boolean;
var// tmp: tTDPointData;
    res1: real;
    i,id: integer;
begin
     try
     result:=false;
     ress:=0;

     id:=-1;
     result:=false;
     if TrDF<>nil then
     begin
        id:=TrDF.GetId(itag);
        if id<0 then
          begin
            result:=false;
            exit;
          end;
     end else
     begin
       result:=false;
       exit;
     end;


     GetRepData(id, typ_, starttime, stopTime);
     if (res.npoint=0) then exit;
     if ((res.ntime=1) and ((starttime=res.time[0][1]) and (stoptime=res.time[0][2]))) then exit;
     case agr of
        REPORTAGR_INTEG:   //  интеграл
            begin
              ress:=0;
              for i:=0 to res.npoint-1 do
                ress:=ress+res.point[i][1];
              result:=true;
            end;
        REPORTAGR_MIN:
            begin      // минимум
              ress:=res.point[0][1];
              for i:=0 to res.npoint-1 do
                if res.point[i][1]<ress then ress:=res.point[0][1];
               result:=true;
            end;
        REPORTTYPE_MAX:
            begin    // максимум
               ress:=res.point[0][1];
              for i:=0 to res.npoint-1 do
                if res.point[i][1]>ress then ress:=res.point[0][1];
               result:=true;
            end;
        REPORTTYPE_SCO:
            begin
              res1:=0;
              for i:=0 to res.npoint-1 do
                res1:=res1+res.point[i][1];
              if res.npoint>0 then res1:=res1*1.0/(1.0*res.npoint);
              ress:=0;
              for i:=0 to res.npoint-1 do
                ress:=ress+sqrt(abs(res.point[i][1]-res1));
              if res.npoint>0 then ress:=ress*1.0/(1.0*res.npoint);
               result:=true;
            end;
        else
            begin   // среднее
              ress:=0;
              for i:=0 to res.npoint-1 do
                ress:=ress+res.point[i][1];
              if res.npoint>0 then ress:=ress*1.0/(1.0*res.npoint);
              result:=true;
            end;
       end;
     finally
     setlength(res.point,0);
     setlength(res.time,0);
     end;
end;




function TMainDataModule.GetLastRep(rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime ): boolean;
begin

end;



procedure TMainDataModule.readDataSet(Datset: TDataSet; starttime: TDateTime; stopTime: TDateTime; var res: tTDPointData; endp: boolean = true);
var   i,j,pointcount,timecount, reccount: integer;
 {  //point_, time_: array of TDPointData ; }
    dataavalable: boolean;
begin
   setlength(res.point,0);
   res.npoint:=0;
   setlength(res.time,1);
   res.ntime:=1;
   res.time[0][1]:=starttime;
   res.time[0][2]:=stoptime;
   //self.DS.DataSet.Open
   try
   begin
 //  try
   with DatSet do
   begin
   Open;
   pointcount:=0;
   timecount:=0;
   reccount:=RecordCount;
   if ((reccount>0) ) then
         begin
            setlength(res.point, reccount+4);
            setlength(res.time, round((reccount+4)/2)+1);
            first;
            if  not FieldByName('val').IsNull then
              begin
                res.point[0][1]:=FieldByName('val').AsFloat;
                 res.point[0][2]:=FieldByName('tm').asDateTime;
                if ( res.point[0][2]<starttime) then
                  begin
                    res.point[0][2]:=starttime;
                  end
                else
                  begin
                    if (res.point[0][2]>starttime) then
                      begin
                        res.point[1][2]:=res.point[0][2];
                        res.point[1][1]:=res.point[0][1];
                        res.point[0][2]:=starttime;
                        inc(pointcount);
                      end;
                  end;
                inc(pointcount);
                dataavalable:=true;
              end else
              begin
                res.time[0][1]:=starttime;
                dataavalable:=false;
              end;
            next;
            while not Eof do
            begin
              if  not FieldByName('val').IsNull then
                begin
                   res.point[pointcount][1]:=FieldByName('val').AsFloat;
                   res.point[pointcount][2]:=FieldByName('tm').asDateTime;
                   if not dataavalable then
                     begin
                       res.time[timecount][2]:=res.point[pointcount][2];
                       inc(timecount);
                     end;
                   inc(pointcount);
                   dataavalable:=true;
                end
              else
                begin
                   if dataavalable then
                     begin
                       res.time[timecount][1]:=FieldByName('tm').asDateTime;
                       if (pointcount>0) then
                         begin
                         res.point[pointcount][1]:=res.point[pointcount-1][1];
                         res.point[pointcount][2]:=res.time[timecount][1];
                         inc(pointcount);
                         end;
                     end;
                   dataavalable:=false;
                end;
              next;
          end;
        end;
        end;
        Datset.Active:=false;

        
        if not dataavalable then
         begin
           res.time[timecount][2]:=stoptime;
           inc(timecount);
        end else
        begin
         if ((pointcount>0) and (endp)) then
          begin
            res.point[pointcount][1]:=res.point[pointcount-1][1];
            res.point[pointcount][2]:=stoptime;
            inc(pointcount);
          end;
         end;


        res.npoint:=pointcount;
        res.ntime:=timecount;
    // except
     //  on  E: Exception do CheckConnection(E);
   //  end;

   end;
   finally
      begin
     // setlength(point_, 0);
     // setlength(time_, 0 );

      DatSet.FreeOnRelease;
      if Datset.Active then
       Datset.Active:=false;


      end;

   end;

end;

procedure TMainDataModule.readDataSetNative(Datset: TDataSet; starttime: TDateTime; stopTime: TDateTime; var res: tTDPointData);
var   i,j,pointcount,timecount, reccount: integer;
 {  //point_, time_: array of TDPointData ; }
    dataavalable: boolean;
begin
   setlength(res.point,0);
   res.npoint:=0;
   setlength(res.time,0);
   res.ntime:=0;
   try
   begin
   //self.DS.DataSet.Open
 //  try
   with DatSet do
   begin
   Open;
   pointcount:=0;
   timecount:=0;
   reccount:=RecordCount;
   if ((reccount>0) ) then
         begin
            setlength(res.point, reccount);
            first;
            if  (not FieldByName('val').IsNull) and (FieldByName('tm').asDateTime>=starttime) then
              begin
                res.point[0][1]:=FieldByName('val').AsFloat;
                res.point[0][2]:=FieldByName('tm').asDateTime;
                inc(pointcount);
                dataavalable:=true;
              end;
            next;
            while not Eof do
            begin
              if  not FieldByName('val').IsNull then
                begin
                   res.point[pointcount][1]:=FieldByName('val').AsFloat;
                   res.point[pointcount][2]:=FieldByName('tm').asDateTime;
                   inc(pointcount);
                   dataavalable:=true;
                end;
              next;
            end;
        end;
        end;
        Datset.Active:=false;

          res.npoint:=pointcount;
          res.ntime:=0;

  // except
  //     on  E: Exception do CheckConnection(E);
  // end;

   end;
   finally
      begin
     // setlength(point_, 0);
     // setlength(time_, 0 );
      try
      DatSet.FreeOnRelease;
      if Datset.Active then
       Datset.Active:=false;

      except
      end;
      end;

   end;

end;

function TMainDataModule.GetLastReport(itag: string; typ_: integer; present_: integer;  var tms: TdateTime): boolean;
function  getdelt(val: TDateTime;_typ_: integer): TDateTime;
begin
if (_typ_ in REPORT_SET_ONETAB) then result:=incYear(val,-15) else                           // инкремент чтения
    begin
       if (_typ_ in REPORT_SET_YEARTAB) then result:=incYear(val,-1) else
         result:=incMonth(val,-1);
    end;
end;

var
   fn, s : string;
   h: string;
   strtseach, seachV, tm, tm1: TDateTime;
   rtid: integer;
begin
  rtid:=-1;
  result:=false;
    if TrDF<>nil then
     begin
        rtid:=TrDF.GetId(itag);
        if rtid<0 then
          begin
            result:=false;
            tms:=GetHistTm(typ_,present_);
            exit;
          end;
     end else
     begin
        result:=false;
        tms:=GetHistTm(typ_,present_);
        exit;
     end;

  if  (typ_ in REPORT_SET) then
  try
  result:=false;
  seachV:=now;
  h:=DateTimetostr(seachV);
  if (present_<36) then present_:=36;

  if (typ_ in REPORT_SET_ONETAB) then strtseach:=incMonth(seachV,-1*(present_+1)) else        //  начало чтения
    begin
       if (typ_ in REPORT_SET_YEARTAB) then strtseach:=incDay(seachV,-1*(present_+1)) else
       strtseach:=incHour(seachV,-1*(present_+1));
    end;

  strtseach:=min(strtseach,getdelt(seachV, typ_));
 // h:=DateTimetostr(strtseach);


  while(seachV>=strtseach) do
  begin
    if GetLastRep(rtid,typ_,seachV,tm) then
     begin
      tm1:=getHistTm(typ_,present_);
      tms:=max(tm,tm1);
      result:=true;
      exit;
     end;

    seachV:=getdelt(seachV,typ_);
  end;

  finally
  end;
  result:=true;
  tms:=GetHistTm(typ_,present_);
end;

function TMainDataModule.CheckConnection(E: Exception): integer;
begin

end;

function TMainDataModule.getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet;
begin

end;


function TMainDataModule.getTrdef: TTrenddefList;
begin
  if fTrDF=nil then
   begin
     fTrDF:=regTrdef;
   end;
   result:=fTrDF;
end;

procedure TMainDataModule.setTrdef( val : TTrenddefList);
begin
   if val<>nil then
    begin
     fnodestryList:=true;
     fTrDF:=val;
    end;
end;

function TMainDataModule.regTrdef(error: boolean=false): TTrenddefList;
begin
     result:=TTrenddefList.create;
     result.clear;
     loadTrdef(result,error);
end;

procedure TMainDataModule.loadTrdef(val : TTrenddefList; error: boolean=false);
begin

end;

function TMainDataModule.WriteLog(itag: string; Data: real; time: TDateTime; validLevel: boolean): integer;
var val: integer;
begin
    result:=-2;
    if TrDF<>nil then
     begin
        val:=TrDF.GetId(itag);
        if val>-1 then
          result:=WriteLog(val, Data, time, validLevel)
     end;
end;

function TMainDataModule.WriteReport (itag: string;  typ: integer; Data: real; time: TDateTime): integer;
var val: integer;
begin
    result:=-2;
    if TrDF<>nil then
     begin
        val:=TrDF.GetId(itag);
        if val>-1 then
          result:=WriteReport(val, typ, Data, time)
     end;
end;

function TMainDataModule.WriteOsc(itag: string; itid: integer; idelt: integer): integer;
var val: integer;
begin
    result:=-2;
    if TrDF<>nil then
     begin
        val:=TrDF.GetId(itag);
        if val>-1 then
          result:=WriteOsc(val, itid, idelt)
     end;
end;

procedure TMainDataModule.GetLogData(itag: string; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true);
var val: integer;
begin
    if TrDF<>nil then
     begin
        val:=TrDF.GetId(itag);
        if val>-1 then
          GetLogData(val, starttime, stopTime, endp)
     end;
end;

procedure TMainDataModule.GetRepData(itag: string;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);
var val: integer;
begin
    if TrDF<>nil then
     begin
        val:=TrDF.GetId(itag);
        if val>-1 then
          GetRepData(val, typ_, starttime, stopTime)
     end;
end;


function TMainDataModule.getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet;
begin
 //  result:=nil;
end;

function TMainDataModule.getReportTable(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit; var res: TReportTable): boolean;
var DS: TDataSet;
    reccount,i,j: integer;

begin
  try
    DS:=nil;
    DS:=getReportTab(starttime, stopTime, RU);
    if DS<>nil then
      begin
        try
          DS.Open;
          DS.RecordCount;
          reccount:=DS.RecordCount;
          if ((reccount>0) ) then
             begin
               setlength(res.tab,reccount);
               res.count:=reccount;
             with DS do
                begin
                  j:=0;
                  while not Eof do
                   begin
                    setlength(res.tab[j],RU.Count+1);
                    res.tab[j][0]:=Double(FieldByName('tm').asDateTime);
                    for i:=0 to RU.Count-1 do
                      begin
                        if not FieldByName(RU.GetTg(i)).IsNull then
                         res.tab[j][i+1]:=FieldByName(RU.GetTg(i)).AsFloat else
                         res.tab[j][i+1]:=NILL_ANALOGDOUBLE;
                      end;
                    j:=j+1;
                    next;
                    end;

               end
             end else
                   setlength(res.tab,RU.Count+1);
        except
        end
      end;

  finally
    if DS<>nil then
     begin
     try
      DS.FreeOnRelease;
      if DS.Active then
       DS.Active:=false;

     except
     end;
     end;
  end;
end;


function TMainDataModule.WriteTrendDefList(list: TTrenddefList; recreate_: boolean = false;
                                deletenoexists_: boolean=false; global_: string=''): integer;
begin

end;

constructor TTrenddefList.create;
begin
  inherited create();
  CaseSensitive:=false;
  Sorted:=true;
  Duplicates:=dupIgnore;
end;

destructor TTrenddefList.destroy;
var i: integer;
begin
  for i:=0 to count-1 do
   dispose(PTrenddefRec(Objects[i]));
  Clear;
  inherited destroy;
end;


function TTrenddefList.GetId(nm: string): integer;
var ind: integer;
    tmp: PTrenddefRec;
begin
  nm:=trim(nm);
  result:=-1;
  if Find(nm,ind) then
    begin
      tmp:=PTrenddefRec(objects[ind]);
      result:=tmp^.cod;
    end;
end;

function TTrenddefList.GetInfo(nm: string): PTrenddefRec;
var ind: integer;
    tmp: PTrenddefRec;
begin
  nm:=trim(nm);
  result:=nil;
  if Find(nm,ind) then
    begin
      result:=PTrenddefRec(objects[ind]);
    end;
end;

function TTrenddefList.AddItems(cod: integer;
      iname: string;
      comment: string;
      eu: string;
      mineu: Double;
      maxeu: Double;
      minraw: Double;
      maxraw: Double;
      logdb: Double;
      logtime: integer;
      deadbaund: Double;
      onmsg: boolean;
      offmsg: boolean;
      almsg: boolean;
      logged: boolean
      ): PTrenddefRec;
var tmp: PTrenddefRec;
begin
     iname:=trim(iname);
     if GetInfo(iname)=nil then
       begin
          new(tmp);
          tmp^.cod:=cod;
          tmp^.iname:=iname;
          tmp^.comment:=comment;
          tmp^.eu:=eu;
          tmp^.mineu:=mineu;
          tmp^.maxeu:=maxeu;
          tmp^.minraw:=minraw;
          tmp^.maxraw:=maxraw;
          tmp^.logdb:=logdb;
          tmp^.logtime:=logtime;
          tmp^.deadbaund:=deadbaund;
          tmp^.onmsg:=onmsg;
          tmp^.offmsg:=offmsg;
          tmp^.almsg:=almsg;
          tmp^.logged:=logged;
          self.AddObject(iname, TObject(tmp));
       end;
end;

constructor TReportUtit.create(
     ffHeader: string;
     fftypeEl: integer;
     ffresult_: boolean;
     ffwidth: integer;
     ffheight: integer;
     ffdelt: integer;
     ffgroup: integer;
     ffinitperiod: boolean;
     ffsubperiod: boolean;
     ffautoprint: boolean;
     ffautoclose: boolean;
     ffFooter: string
);
begin
  inherited create();
  finit:=false;
  fHeader:=ffHeader;
  fFooter:=ffFooter;
  ftypeEl:=fftypeEl;
  fresult_:=ffresult_;
  fwidth:=ffwidth;
  fheight:=ffheight;
  fdelt:=ffdelt;
  fgroup:=ffgroup;
  fsubperiod:=ffsubperiod;
  finitperiod:=ffinitperiod;
  CaseSensitive:=false;
  Sorted:=false;
  fautoprint:=ffautoprint;
  fautoclose:=ffautoclose;
  Duplicates:=dupAccept;
end;

destructor  TReportUtit.destroy;
var i: integer;
begin
   for i:=0 to count-1 do
   dispose(PTrenddefRec(Objects[i]));
   Clear;
  inherited destroy;
end;

function  TReportUtit.AddItems(tg: string;
     eu: string;
     comment: string;
     cod: integer;
     typeEl: integer;
     fagrType: integer;
     rnd: integer): PReporttag;
var tmp: PReporttag;
begin
   tg:=trim(tg);
   if GetInfo(tg)=nil then
       begin
          new(tmp);
          tmp^.cod:=cod;
          tmp^.tg:=tg;
          tmp^.eu:=eu;
          tmp^.comment:=comment;
          tmp^.typeEl:=typeEl;
          tmp^.agrType:=fagrType;
          tmp^.rnd:=rnd;
          if rnd>0 then
          tmp^.rnffmt:='%f10.'+inttostr(rnd)
          else tmp^.rnffmt:='%f10.0';
          tmp^.agrType:=fagrType;
          AddObject(tg, TObject(tmp));
       end;
       finit:=true;
end;


function  TReportUtit.initItems(
     lst: TTrenddefList): PReporttag;
var tmpind, i: integer;
    tmpUt: PReporttag;
    tmpinf: PTrenddefRec;
begin
  if lst=nil then exit;
  for i:=0 to self.Count-1 do
    begin
      tmpUt:=PReporttag(Objects[i]);
      tmpinf:=lst.GetInfo(self.Strings[i]);
      if tmpinf<>nil then
       begin
       tmpUt.cod:=tmpinf.cod;
       tmpUt.eu:=tmpinf.eu;
       tmpUt.comment:=tmpinf.comment;
       tmpUt.typeEl:=tmpinf.logtime;
       end;
    end;
    finit:=true;
end;

function  TReportUtit.AddItems(tg: string;
     fagrType: integer;
     rnd: integer): PReporttag;
var tmp: PReporttag;
begin
   tg:=trim(tg);
   if GetInfo(tg)=nil then
       begin
          new(tmp);
          tmp^.tg:=tg;
          tmp^.agrType:=fagrType;
          tmp^.rnd:=rnd;
          if rnd>0 then
          tmp^.rnffmt:='%10.'+inttostr(rnd)+'f'
          else tmp^.rnffmt:='%10.0f';
          tmp^.agrType:=fagrType;
          AddObject(tg, TObject(tmp));
       end;
       finit:=false;
end;

function TReportUtit.GetInfo(nm: string): PReporttag;
var ind: integer;
    tmp: PTrenddefRec;
begin
  nm:=trim(nm);
  result:=nil;
  ind:=IndexOf(nm);
  if ind>-1 then
    begin
      result:=PReporttag(objects[ind]);
    end;
end;


function TReportUtit.GetCod(Index: Integer): integer;
begin
   result:=-1;
   if index<count then
      result:=PReporttag(objects[index])^.cod;
end;

function TReportUtit.GetAGR(Index: Integer): integer;
begin
   result:=-1;
   if index<count then
      result:=PReporttag(objects[index])^.agrType;
end;

function TReportUtit.GetTyp(Index: Integer): integer;
begin
   result:=-1;
   if index<count then
      result:=PReporttag(objects[index])^.typeEl;
end;

function TReportUtit.GetTg(Index: Integer): string;
begin
   result:='';
   if index<count then
      result:=PReporttag(objects[index])^.tg;
end;

function TReportUtit.GetEu(Index: Integer): string;
begin
   result:='';
   if index<count then
      result:=PReporttag(objects[index])^.eu;
end;

function TReportUtit.GetComment(Index: Integer): string;
begin
   result:='';
   if index<count then
      result:=PReporttag(objects[index])^.comment;
end;

function TReportUtit.GetFormat(Index: Integer): string;
begin
   result:='';
   if index<count then
      result:=PReporttag(objects[index])^.rnffmt;
end;





end.
