unit DBManagerFactoryU;

interface

uses
  Classes,DataBDEU, DataMySQLU, DataPostgreeU, SysUtils, ExtCtrls, DataOracleU,
  StdCtrls, MainDataModuleU, dateutils, DataMSSQLU, DataIBU, ConstDef, DB;

type

   TNS_FetchComplete = procedure (data: tTDPointData; 
   Error: integer)  of object;

   TNS_JournalFetchComplete = procedure (res: TDataSet;  err: integer)  of object;

   TNS_ReportFetchComplete = procedure (res: TReportTable;  err: integer) of object;

   TNS_TrdfProgress = procedure (progress: integer;  err: integer) of object;
   TNS_TrdfComplete = procedure (err: integer) of object;

const

  BDE_MANAGER      = 6;
  POSTGRES_MANAGER = 1;
  MSSQL_MANAGER    = 2;
  ORACLE_MANAGER   = 3;
  INTERBASE_MANAGER= 4;
  MYSQL_MANAGER    = 5;


type
  TDBManagerFactory = class(TObject)
  public
    class function buildManager(_type: integer; conf: string; _faction: TDBAction = dbaReadOnly;
                       global_: boolean= false; session_: string = ''): TMainDataModule;
  end;

type
  TTrendThread = class(TThread)
  private
    err: integer;
    fDM: TMainDataModule;
    fid: string;
    fstarttime, fstoptime: TDatetime;
    fname: string;
    flist: TTrenddefList;
    fNS_FetchComplete:  TNS_FetchComplete;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Complete;
    procedure Request;
  public
    constructor create(_type: integer; conf: string; id: string; starttime, stoptime: TDatetime;

                       NS_FetchComplete:  TNS_FetchComplete; list: TTrenddefList=nil);

    destructor destroy;  override;

  end;

 TTrendDefThread = class(TThread)
  private
    err: integer;
    fDM: TMainDataModule;
    fopp: TTrendDefOp;
    flist: TTrenddefList;
    fNS_FetchProgress:  TNS_TrdfProgress;
    fNS_FetchComlete:  TNS_TrdfComplete;
    pers: integer;
    frecr: boolean;
    fdeletenouse: boolean;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Complete;
    procedure progress;
    procedure Request;
  public
    constructor create(_type: integer; conf: string;list: TTrenddefList;
                        NS_FetchProgress:  TNS_TrdfProgress;
                        NS_FetchComlete:  TNS_TrdfComplete; opp: TTrendDefOp; recr: boolean=false; deletenouse: boolean=false);

    destructor destroy;  override;

  end;



type
  TReportThread = class(TThread)
  private
    err: integer;
    fDM: TMainDataModule;
    fstarttime, fstoptime: TDatetime;
    freportUnit: TReportUtit;
    fNS_FetchComplete:  TNS_ReportFetchComplete;
    RT: TReportTable;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Complete;
    procedure Request;
  public
    constructor create(_type: integer; conf: string; starttime, stoptime: TDatetime;

                       NS_FetchComplete:  TNS_ReportFetchComplete; list: TReportUtit);

    destructor destroy; override;

  end;


type
  //  !!!! не очищает Dataset, необхлдиимо делать снаружи
  TJournalThread = class(TThread)
  private
    fDM: TMainDataModule;
    err: integer;
    fstarttime, fstoptime: TDatetime;
    fname: string;
    fmsgset: TJournalMessageSet;
    ftgList: TStrings;
    faggroups: TStrings;
    fsrtAl: integer;
    fstpAl: integer;
    fNS_FetchComplete:  TNS_JournalFetchComplete;
    DS: TDataSet;
    { Private declarations }
  protected
    procedure Execute; override;
    procedure Complete;
    procedure Request;
  public
    constructor create(_type: integer; conf: string; starttime: TDateTime; stopTime: TDateTime;
                       msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings;
                       NS_FetchComplete:  TNS_JournalFetchComplete;srtAl: integer=-1; stpAl: integer=-1);

    destructor destroy; override;

  end;



implementation



class function TDBManagerFactory.buildManager(_type: integer; conf: string; _faction: TDBAction = dbaReadOnly;
                       global_: boolean= false; session_: string = ''): TMainDataModule;
begin
  case _type of
   POSTGRES_MANAGER :  result:=TDataPostgree.Create(conf,_faction,global_,session_);
   ORACLE_MANAGER :    result:=TDataOracle.Create(conf,_faction,global_,session_);
   MSSQL_MANAGER    :  result:=TDataMSSQL.Create(conf,_faction,global_,session_);
   BDE_MANAGER      :  result:=TDataBDE.Create(conf,_faction,global_,session_);
   INTERBASE_MANAGER:  result:=TDataIB.Create(conf,_faction,global_,session_);
   MYSQL_MANAGER:      result:=TDataMySQL.Create(conf,_faction,global_,session_);
   else result:=nil;
   end;
end;


constructor TTrendThread.create(_type: integer; conf: string; id: string; starttime, stoptime: TDatetime;
                       NS_FetchComplete:  TNS_FetchComplete;list: TTrenddefList=nil);
begin
   err:=NSDB_REQEST_OK;
   fDM:=TDBManagerFactory.buildManager(_type, conf, dbaReadOnly);
   if fDM=nil then
     err:=NSDB_CONNECT_ERR;
   fid:=id;
   fstarttime:=starttime;
   fstoptime:=stoptime;
   fNS_FetchComplete:=NS_FetchComplete;
   flist:=list;
   if flist<>nil then
    if fDM<>nil then
      fDM.TrDF:=flist;
   FreeOnTerminate:=true;
   inherited create(false);
end;



procedure TTrendThread.Request;
var temp: tTDPointData;
begin
  if fDM<>nil then
    begin
    try
    if not fDM.Conneted then fDM.Connect;
      if fDM.Conneted then
         begin
           try
           fDM.GetLogData(fid,fstarttime,fstoptime);
           except
             err:=NSDB_REQEST_ERR;
           end
         end else err:=NSDB_CONNECT_ERR;

    except
    err:=NSDB_CONNECT_ERR
    end;
    end;
   synchronize(Complete);

end;

procedure TTrendThread.Complete;
var temp: tTDPointData;
begin
  if (assigned(fNS_FetchComplete)) then
  begin
   if (fDM<>nil) then
   fNS_FetchComplete(fDM.res,err) else
   fNS_FetchComplete(temp,NSDB_CONNECT_ERR);
  end;
end;


procedure TTrendThread.Execute();
begin

  try
    Request;
  except

  end;
  //self.free;
end;


destructor TTrendThread.destroy;
begin
 try
   if fDM<>nil then FreeAndNil(fDM);
 except
 end;
 inherited destroy;
end;






///----------------------TJournalThread

constructor TJournalThread.create(_type: integer; conf: string; starttime: TDateTime; stopTime: TDateTime;
                       msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings;
                       NS_FetchComplete:  TNS_JournalFetchComplete;srtAl: integer=-1; stpAl: integer=-1);
begin
   err:=NSDB_REQEST_OK;
   fDM:=TDBManagerFactory.buildManager(_type, conf, dbaReadOnly,false,'');
    if fDM=nil then
       err:=NSDB_CONNECT_ERR;
   fstarttime:=starttime;
   fstoptime:=stoptime;
   fNS_FetchComplete:=NS_FetchComplete;
   fmsgset:=msgset;
   ftgList:=tgList;
   faggroups:=aggroups;
   fsrtAl:=srtAl;
   fstpAl:=stpAl;
   DS:=nil;
   inherited create(false);
end;



procedure TJournalThread.Request;
var temp: tTDPointData;
begin

  if fDM<>nil then
    begin
     try
    if not fDM.Conneted then fDM.Connect;
      if fDM.Conneted then
         begin
           try
           DS:=fDM.getJournalDS(fstarttime,fstoptime,fmsgset,
           ftglist,faggroups,nil,nil,fsrtAl,fstpAl);
           except
             err:=NSDB_REQEST_ERR;
           end
         end else err:=NSDB_CONNECT_ERR;
      except
         err:=NSDB_CONNECT_ERR;
      end;
    end;
   synchronize(Complete);

end;

procedure TJournalThread.Complete;
begin
  if (assigned(fNS_FetchComplete)) then
  begin
   if (fDM<>nil) then
   fNS_FetchComplete(DS,err) else
   fNS_FetchComplete(DS,NSDB_CONNECT_ERR);
  end;
end;


procedure TJournalThread.Execute();
var err: integer;
begin

  try
    Request;
  except

  end;
 //self.Free;
end;


destructor TJournalThread.destroy;
begin
 try
   if fDM<>nil then FreeAndNil(fDM);
 except
 end;
 inherited destroy;
end;


///----------------------TReportThread


procedure TReportThread.Execute;
var err: integer;
begin

  try
    Request;
  except

  end;

end;

procedure TReportThread.Complete;
begin
  if (assigned(fNS_FetchComplete)) then
  begin
   if (fDM<>nil) then
   fNS_FetchComplete(RT,err) else
   fNS_FetchComplete(RT,NSDB_CONNECT_ERR);
  end;
end;

procedure TReportThread.Request;
begin

  if fDM<>nil then
    begin
    try
    if not fDM.Conneted then fDM.Connect;
      if fDM.Conneted then
         begin
           try
           fDM.getReportTable(fstarttime,fstoptime, freportUnit,RT);
           except
             err:=NSDB_REQEST_ERR;
           end
         end else err:=NSDB_CONNECT_ERR;
    except
    err:=NSDB_CONNECT_ERR
    end;
    end;
   synchronize(Complete);

end;

constructor TReportThread.create(_type: integer; conf: string; starttime, stoptime: TDatetime;
                       NS_FetchComplete:  TNS_ReportFetchComplete; list: TReportUtit);
begin
   err:=NSDB_REQEST_OK;
   fDM:=TDBManagerFactory.buildManager(_type, conf, dbaReadOnly,false,'');
   if fDM=nil then
       err:=NSDB_CONNECT_ERR;
   fstarttime:=starttime;
   fstoptime:=stoptime;
   fNS_FetchComplete:=NS_FetchComplete;
   freportUnit:=list;
   FreeOnTerminate:=true;
   inherited create(false);
end;

destructor TReportThread.destroy;
begin
  try
   if fDM<>nil then FreeAndNil(fDM);
 except
 end;
 inherited destroy;
end;


procedure TTrendDefThread.Execute;
begin
   try
    Request;
  except

  end;
end;

procedure TTrendDefThread.Complete;
begin
   fNS_FetchComlete(err);
end;

procedure TTrendDefThread.progress;
begin
   fNS_Fetchprogress(pers, err);
end;

procedure TTrendDefThread.Request;
var i,tmp: integer;
    tmpitem: PTrenddefRec;
begin
   if ((fDM<>nil) and (flist<>nil)) then
    begin
    try
    if not fDM.Conneted then fDM.Connect;
      if fDM.Conneted then
         begin
            if frecr then
              begin
                fDM.deleteTrenddef;
                fDM.recConnect;
                fopp:=tdoAdd;
              end else
              begin
                if (fdeletenouse) and (flist<>nil) then
                   tmp:=fdm.WriteTrendef(
                   -1,
                   'ffffffffffffffffffff',
                   'ffffffffffffffffffff',
                    0,
                    1,
                    0,
                    1,
                    0,
                    0,
                    1,
                    'ffffffffffffffffffff',
                    false,
                    false,
                    false, false, fopp,flist
                   );
                  if err=NSDB_REQEST_OK then err:=tmp;
              end;
            for i:=0 to flist.Count-1 do
             begin
               try
                 if flist.Count>0 then
                 pers:=round((i*100.0)/flist.Count)
                 else pers:=100;
                 tmpitem:=PTrenddefRec(flist.Objects[i]);
                 if tmpitem<>nil then
                   tmp:=fdm.WriteTrendef(tmpitem^.cod,
                                         tmpitem^.iname,
                                         tmpitem^.comment,
                                         tmpitem^.mineu,
                                         tmpitem^.maxeu,
                                         tmpitem^.minraw,
                                         tmpitem^.maxraw,
                                         tmpitem^.logdb,
                                         tmpitem^.logtime,
                                         tmpitem^.deadbaund,
                                         tmpitem^.eu,
                                         tmpitem^.onmsg,
                                         tmpitem^.offmsg,
                                         tmpitem^.almsg, tmpitem^.logged, fopp,nil);
                      if err=NSDB_REQEST_OK then err:=tmp;


             except
                err:=NSDB_REQEST_ERR;
             end;
             synchronize(Progress);
             end;
             
         end else err:=NSDB_CONNECT_ERR;

    except
    err:=NSDB_CONNECT_ERR
    end;
    end;
   synchronize(Complete);
end;

constructor TTrendDefThread.create(_type: integer; conf: string;list: TTrenddefList;
                        NS_FetchProgress:  TNS_TrdfProgress;
                        NS_FetchComlete:  TNS_TrdfComplete;  opp: TTrendDefOp; recr: boolean=false;  deletenouse: boolean=false);
begin
   err:=NSDB_REQEST_OK;
   fDM:=TDBManagerFactory.buildManager(_type, conf, dbaAll);
   if fDM=nil then
     err:=NSDB_CONNECT_ERR;
   fNS_FetchComlete:= NS_FetchComlete;
   fNS_FetchProgress:=NS_FetchProgress;
   flist:=list;
   fopp:= opp;
   frecr:=recr;
   FreeOnTerminate:=true;
   fdeletenouse:=deletenouse;
   inherited create(false);
end;

destructor TTrendDefThread.destroy;
begin
 try
   if fDM<>nil then FreeAndNil(fDM);
 except
 end;
 inherited destroy;
end;

end.
