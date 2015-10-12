unit DataBDEU;

interface

uses
  SysUtils, Classes, DB, DBTables,MainDataModuleU,DateUtils,Math, ConstDef, Dialogs;

const
   ALARM_BASE='Alarms';
   TREND_BASE='Trend';

type
  TDataBDE = class(TMainDataModule)
    Trend: TQuery;
    Alarm: TQuery;
    AlarmConnection: TDataSource;
    TrendConnection: TDataSource;
  private
  protected
     function WriteAlarm (id: integer; igroup, itag, iComment, iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean; override;
     function getConnected(): boolean;  override;
     function GetLastRep(rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime): boolean;  override;   // getlastlog
     procedure init();  override;
     procedure uninit(); override;

     function WriteLog (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer; override;
     function WriteReport(Code:longInt;  typ: integer; Data: real; time: TDateTime): integer; override;
     procedure GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true);  override;
     procedure GetRepData(id: integer;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);  override;
     function  getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet;
  public
    function CheckConnection(E: Exception):integer; override;
    function TableExist(iFileName: String; dbname: String): boolean;
    function delTable(fn: string): boolean; override;
    function TestConnect(): boolean; override;
    function CreateTrTable(iFileName: String): boolean; override;
    function CreateAlTable(iFileName: String): boolean; override;
    function CreateRepTable(iFileName: String): boolean; override;
    function CreateTrenddef(): boolean;  override;

    function Connect(): boolean;  override;
    function DisConnect(): boolean;  override;




    function WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
             onmsg_: boolean; offmsg_: boolean; almsg_: boolean; logged: boolean;  oper: TTrendDefOp; list: TTrenddefList): integer; override;


    function GetLogID(iname: string): integer;  override;



    procedure FreeAndReLease; override;

    function  getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet; override;
    { Public declarations }
    procedure loadTrdef(val : TTrenddefList; error: boolean=false); override;

  end;



implementation


procedure TDataBDE.init();
begin
Trend:=TQuery.Create(nil);
Alarm:=TQuery.Create(nil);;
AlarmConnection:=TDataSource.Create(Alarm);
TrendConnection:=TDataSource.Create(nil);
TrendConnection.DataSet:=Trend;
AlarmConnection.DataSet:=Alarm;
trend.DatabaseName:=TREND_BASE;
alarm.DatabaseName:=ALARM_BASE;
end;


procedure TDataBDE.uninit();
begin
Trend.Free;
TrendConnection.Free;
//if ffreeDS then
//begin
AlarmConnection.Free;
Alarm.free;
//end;
end;


function TDataBDE.Connect(): boolean;
begin
  {if TrendConnection.Connected then  TrendConnection.Disconnect;
  TrendConnection.Database:=DataBase;
  TrendConnection.HostName:=Server;
  TrendConnection.User:=User;
  TrendConnection.Password:=Password;
  TrendConnection.ReadOnly:=(action=dbaReadOnly);
  if Port>-1 then TrendConnection.Port:=Port;
  TrendConnection.Connected:=true;
  result:=TrendConnection.Connected;
  testbefore;      }
  result:=true;
end;

function TDataBDE.DisConnect(): boolean;
begin
//  if TrendConnection.Connected then  TrendConnection.Disconnect;
 // result:= not TrendConnection.Connected;
end;

function TDataBDE.getConnected(): boolean;
begin
   result:= true; //TrendConnection.Connected;
end;

function TDataBDE.TestConnect(): boolean;
var
   TableList: TStringList;
begin
   TableList:=TStringList.Create;
   try
   session.GetTableNames(ALARM_BASE, '', False, false, TableList);
   session.GetTableNames(TREND_BASE, '', False, false, TableList);
   finally
   TableList.Free;
   end;
end;


function TDataBDE.TableExist(iFileName: String; dbname: String): boolean;
var
   TableList: TStringList;
   i : integer;
begin
     result := False;
     TableList := TStringlist.Create;
     try
     session.GetTableNames(dbname, '', False, false, TableList);
     for i := 0 to TableList.count - 1 do
         if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            tableExist := true;
            break;
         end;
     // 16.02
     if ((action=dbaReadOnly)) then
       begin
         recConnect;
         session.GetTableNames(dbname, '', False, false, TableList);
         for i := 0 to TableList.count - 1 do
         if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            tableExist := true;
            break;
         end;
       end;

     finally
         TableList.Free;
     end;
end;

function TDataBDE.CreateTrTable(iFileName: String): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  with Trend do
   begin
      try
      // создать таблицу и индекс

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn + ''+
                                      ' (cod INTEGER, tm TIMESTAMP, val FLOAT ,' +
                                      'PRIMARY KEY(cod, tm)) '
                                      );
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD) ');
      ExecSQL;
      except
       Trend.Sql.Clear;
      end;
      end;
end;


function TDataBDE.CreateAlTable(iFileName: String): boolean;
 var fn, s : string;
begin
  fn := iFileName;
  try
  with Alarm do
   begin

      Sql.Clear;
      s:='CREATE TABLE ' + fn +
                                      ' (cod INTEGER, tm TIMESTAMP, igroup CHAR(50), itag CHAR(50),' +
                                     'ilevel integer, icomment CHAR(250), istate CHAR(50),ihost CHAR(50), ' +
                                      'ioperator CHAR(50))';
      Sql.Add (s );
      ExecSQL;
      Sql.Clear;
      end
    except
     Alarm.Sql.Clear;
    end
end;

function TDataBDE.CreateRepTable(iFileName: String): boolean;
 var fn,s : string;
begin
  fn := iFileName;
  try
  with Trend do
   begin
      // создать таблицу и индекс
      Sql.Clear;
      s:= 'CREATE TABLE ' + fn +
                                      ' (cod INTEGER,  tm TIMESTAMP, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))  ';
      Sql.Add (s);
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD_'+fn+' ON ' + fn + ' (COD) ');
      ExecSQL;

      end;
  except
  Trend.Sql.Clear;
  end
end;

function TDataBDE.createTrenddef(): boolean;
 var fn,s : string;
begin
   if not TableExist('trenddef',TREND_BASE) then
     begin
       try
         with Trend do
            begin
            // создать таблицу и индекс
             Sql.Clear;
             s:= 'CREATE TABLE trenddef (cod AUTOINC, iname char(50), icomment char(250), eu char(50), mineu FLOAT, maxeu FLOAT, minraw FLOAT, maxraw FLOAT, logdb FLOAT,logtime FLOAT, deadbaund FLOAT, onmsg INTEGER, offmsg INTEGER , almsg INTEGER, logged INTEGER )';
             Sql.Add (s);
             ExecSQL;

            end;
       except
       Trend.SQL.Clear;
       end;
     end;
end;


function TDataBDE.WriteLog (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer;
var
   fn, s : string;
   param: Tparam;
begin
   try
     fn := trendDateToFileName(time);
  if not TableExist(fn, TREND_BASE) then
  begin
    CreateTrTable(fn);
  end;

  with Trend do
  begin
     if validLevel then
     begin

     s:='insert into ' + fn +
        ' (cod, tm, Val) values (:cod, :tm, :val)';
     SQL.Clear;
     SQL.Add(s);

     params.ParamByName('cod').value := iLogCode;
     params.ParamByName('tm').DataType:=ftDateTime;
     params.ParamByName('tm').value:=time;
     params.ParamByName('Val').value := data;
    {else
     begin
     s:='insert into ' + fn +
        ' (cod, tm) values (:cod, :tm )';
     SQL.Clear;
     SQL.Add(s);

     params.ParamByName('cod').value := iLogCode;
     params.ParamByName('tm').DataType:=ftDateTime;
     params.ParamByName('tm').value:=time;

     end; }
    try
     ExecSQL;
    except
       //on  E: Exception do CheckConnection(E);
    end;
     end;
  end;
  finally
  Trend.Sql.Clear;
  end;

end;

function TDataBDE.WriteAlarm(id: integer; igroup, itag, iComment, iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;
var
   dateString, pluscommand, sOperator: string;
   fn, s : string;
   itid: integer;
begin
    try
     fn:=alarmDateToFileName(time);
     if not TableExist(fn,ALARM_BASE) then
         begin
         CreateAlTable(fn);
         end;

     try
     with Alarm do
       begin
         Sql.Clear;

         s:='insert into ' + fn + '(cod, tm, igroup, itag,  ilevel, icomment, istate, ihost, ioperator)' +
                                  ' values (:cod, :tm, :igroup, :itag, :iLevel,  :iComment,' +
                                  ':iState, :iHost, :iOpr)';
         SQL.Add(s);
         params.ParamByName('cod').value := id;
         params.ParamByName('tm').DataType:= ftDateTime;
         params.ParamByName('tm').value := time;
         params.ParamByName('igroup').DataType := ftString;
         params.ParamByName('igroup').value := igroup;
         params.ParamByName('itag').DataType := ftString;
         params.ParamByName('itag').value:= itag;
         params.ParamByName('iLevel').value := iAlarmLevel;
         params.ParamByName('iComment').DataType := ftString;
         params.ParamByName('iComment').value := iComment ;
         params.ParamByName('iState').DataType := ftString;
         params.ParamByName('iState').value := iState;
         params.ParamByName('iHost').DataType := ftString;
         params.ParamByName('iHost').value:= comp;
         params.ParamByName('iOpr').DataType := ftString;
         params.ParamByName('iOpr').value := sOperator;




         ExecSQL;
         Sql.Clear;
       end;
      except
         on  E: Exception do  CheckConnection(E);
      end;
   finally
    Alarm.Sql.Clear;
   end;

end;

function TDataBDE.WriteReport(Code:longInt;  typ: integer; Data: real; time: TDateTime): integer;
var
   fn, s : string;
  // per: integer;
begin
   try
    // per:=round(rtitems[Code].logTime);
     fn := reportDateToFileName(time,typ);
      if not TableExist(fn,TREND_BASE) then
         begin
          CreateRepTable(fn);
         end;

     with Trend do
     begin
       s := 'insert into ' + fn+
        ' values (:cod, :tm, :Val)';

        SQL.Clear;
        SQL.Add(s);
        params.ParamByName('cod').value := code;
        params.ParamByName('tm').DataType:=ftDateTime;
        params.ParamByName('tm').value:=time;
        params.ParamByName('Val').value := data;

    try
     ExecSQL;
     Sql.Clear;
    except
      on  E: Exception do CheckConnection(E);
    end;
  end;
  finally
    Trend.Sql.Clear;
  end;

end;


function TDataBDE.WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
             onmsg_: boolean; offmsg_: boolean; almsg_: boolean; logged: boolean; oper: TTrendDefOp; list: TTrenddefList): integer;
   var
   fn, s,tnps : string;
   recordexist: boolean;
   i: integer;
begin
 fn:='trenddef';
 result:= NSDB_REQEST_OK;
 if not TableExist(fn,TREND_BASE ) then
         begin
          CreateTrenddef;
         end;

  if list<>nil then
    begin
    with Trend do
      begin
      SQL.Clear;
      tnps:='';

      begin
      s:='delete from '+fn+' where iname not in ';
      for i:=0 to list.Count-1 do
        if i=0 then tnps:=char($27)+PTrenddefRec(list.Objects[i])^.iname+char($27) else
          tnps:=tnps+ ', '+char($27)+PTrenddefRec(list.Objects[i])^.iname+char($27);
      s:=s+' ( '+ tnps + ' ) ';
      SQL.Add(s);
      try
         ExecSQL;
         SQL.Clear;
      except
         result:= NSDB_NODEL_ERR;
      end;

      end;
      end;
     exit;
    end;


  case oper of
   tdoAdd:
     begin

          with Trend do
          begin
           if iLogCode>-1 then
           begin
           s := 'insert into '+fn+' (iname, mineu, maxeu, minraw, maxraw, logdb, deadbaund, logtime, icomment, eu, onmsg, offmsg, almsg, logged) values( :nm, :MinEu, :MaxEu,:MinRaw, :MaxRaw, :logDB, :DeadBaund, :LogTime, :iComment, :EU, :onmsg, :offmsg, :almsg, :logged)';
           SQL.Clear;
           SQL.Add(s);
          // params.ParamByName('cod').Value:=iLogCode;
           params.ParamByName('nm').AsString:=iName;
           params.ParamByName('MinEu').AsFloat:=MinEu;
           params.ParamByName('MaxEu').AsFloat:=MaxEu;
           params.ParamByName('MinRaw').AsFloat:=MinRaw;
           params.ParamByName('MaxRaw').AsFloat:=MaxRaw;
           params.ParamByName('logDB').AsFloat:=logDB;
           params.ParamByName('DeadBaund').AsFloat:=DeadBaund;
           params.ParamByName('LogTime').AsFloat:=LogTime;
           params.ParamByName('iComment').AsString:=Comment;
           params.ParamByName('EU').AsString:=EU;
           if onmsg_ then Params.ParamByName('onmsg').AsInteger:=1 else Params.ParamByName('onmsg').AsInteger:=0;
           if offmsg_ then Params.ParamByName('offmsg').AsInteger:=1 else Params.ParamByName('offmsg').AsInteger:=0;
           if almsg_ then Params.ParamByName('almsg').AsInteger:=1 else Params.ParamByName('almsg').AsInteger:=0;
           if logged then Params.ParamByName('logged').AsInteger:=1 else Params.ParamByName('logged').AsInteger:=0;
           try
           ExecSQL;
           SQL.Clear;
           except
            result:= NSDB_NOADD_ERR;
           end;
           end else
           begin
            s := 'insert into '+fn+' ( iname, mineu, maxeu, minraw, maxraw, logdb, deadbaund, logtime, icomment, eu, onmsg, offmsg, almsg, logged) values( :nm, :MinEu, :MaxEu,:MinRaw, :MaxRaw, :logDB, :DeadBaund, :LogTime, :iComment, :EU, :onmsg, :offmsg, :almsg, :logged)';
           SQL.Clear;
           SQL.Add(s);
           params.ParamByName('nm').AsString:=iName;
           params.ParamByName('MinEu').AsFloat:=MinEu;
           params.ParamByName('MaxEu').AsFloat:=MaxEu;
           params.ParamByName('MinRaw').AsFloat:=MinRaw;
           params.ParamByName('MaxRaw').AsFloat:=MaxRaw;
           params.ParamByName('logDB').AsFloat:=logDB;
           params.ParamByName('DeadBaund').AsFloat:=DeadBaund;
           params.ParamByName('LogTime').AsFloat:=LogTime;
           params.ParamByName('iComment').AsString:=Comment;
           params.ParamByName('EU').AsString:=EU;
           if onmsg_ then Params.ParamByName('onmsg').AsInteger:=1 else Params.ParamByName('onmsg').AsInteger:=0;
           if offmsg_ then Params.ParamByName('offmsg').AsInteger:=1 else Params.ParamByName('offmsg').AsInteger:=0;
           if almsg_ then Params.ParamByName('almsg').AsInteger:=1 else Params.ParamByName('almsg').AsInteger:=0;
           if logged then Params.ParamByName('logged').AsInteger:=1 else Params.ParamByName('logged').AsInteger:=0;
           try
           ExecSQL;
           SQL.Clear;
           except
            result:= NSDB_NOADD_ERR;
           end;
           end;
           end;

     end;

  tdoDelete:
     begin
     {   with TrendQuery do
           begin
           s := 'delete from '+fn+' where iname = : iname';
           SQL.Clear;
           SQL.Add(s);
           params.ParamByName('iname').Value:=iName_;
           try
           ExecSQL;
           SQL.Clear;
           except
            result:= NSDB_NOADD_ERR;
           end;
           end;      }

     end;

   tdoUpdate:
     begin
        recordexist:=true;
        with Trend do
         begin
          s := 'select cod from ' + fn+
          ' where IName=:nm';
          SQL.Clear;
          SQL.Add(s);
         params.ParamByName('nm').DataType:=ftString;
         params.ParamByName('nm').value := iname;
         try
          Open;
          recordexist:=(Trend.RecordCount>0);
          Close;
          SQL.Clear;
         except;
          SQL.Clear;
          recordexist:=true;
         end;
          if (( not recordexist)) then
            begin
            Close;
            result:=WriteTrendef (iLogCode, iname, comment, MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund, EU,
            onmsg_, offmsg_, almsg_, logged ,tdoAdd, nil);
            SQL.Clear;
            exit;
            end else
            begin

            s := 'update '+fn+' set  mineu = :MinEu , maxeu = :MaxEu, minraw = :MinRaw, maxraw = :MaxRaw, logdb = :logDB, deadbaund = :DeadBaund, logtime = :LogTime, icomment = :iComment, eu = :EU, onmsg = :onmsg, offmsg = :offmsg, almsg = :almsg, logged = :logged where iname = :iName';
            SQL.Add(s);
            params.ParamByName('iname').AsString:=iName;
            params.ParamByName('MinEu').AsFloat:=MinEu;
            params.ParamByName('MaxEu').AsFloat:=MaxEu;
            params.ParamByName('MinRaw').AsFloat:=MinRaw;
            params.ParamByName('MaxRaw').AsFloat:=MaxRaw;
            params.ParamByName('logDB').AsFloat:=logDB;
            params.ParamByName('DeadBaund').AsFloat:=DeadBaund;
            params.ParamByName('LogTime').AsFloat:=LogTime;
            params.ParamByName('iComment').AsString:=Comment;
            params.ParamByName('EU').AsString:=EU;
            if onmsg_ then Params.ParamByName('onmsg').AsInteger:=1 else Params.ParamByName('onmsg').AsInteger:=0;
            if offmsg_ then Params.ParamByName('offmsg').AsInteger:=1 else Params.ParamByName('offmsg').AsInteger:=0;
            if almsg_ then Params.ParamByName('almsg').AsInteger:=1 else Params.ParamByName('almsg').AsInteger:=0;
            if logged then Params.ParamByName('logged').AsInteger:=1 else Params.ParamByName('logged').AsInteger:=0;
            try
             ExecSQL;
             SQL.Clear;
            except
             result:= NSDB_NOADD_ERR;
            end;


            end;
          end;
        end;
    end;
end;


function TDataBDE.delTable(fn: string): boolean;
var s: string;
    db_: string;
begin
result:=true;
if (pos('AL',trim(uppercase(fn)))>0) then
db_:=ALARM_BASE else db_:=TREND_BASE;
if not TableExist(fn,db_) then exit;
result:=false;
try
 with Trend do
       begin
        Sql.Clear;
        s:='DROP TABLE ' + fn ;
        Sql.Add (s );
        ExecSQL;
        Sql.Clear;
        result:=true;
       end;
except
 Trend.Sql.Clear;
end;
try
 with Alarm do
       begin
        Sql.Clear;
        s:='DROP TABLE ' + fn ;
        Sql.Add (s );
        ExecSQL;
        Sql.Clear;
        result:=true;
       end;
except
 Alarm.Sql.Clear;
end;
end;






function TDataBDE.GetLastRep (rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime ): boolean;
var
   fn, s : string;
begin
    fn := ReportDateToFileName(seachV,typ_);
    result:=false;
    if  TableExist(fn,TREND_BASE) then
        begin
        try
          with Trend do
            begin
              s := 'select max(tm) from '+fn+' where (cod = :cod)';
              SQL.Clear;
              SQL.Add(s);
              params.parambyname('cod').value := rtid;
                try
                 Open;
                  if (RecordCount=0) then  Trend.Sql.Clear
                  else
                  begin
                    first;
                    if (not Trend.Fields[0].IsNull) then   begin
                    tms:=Trend.Fields[0].AsDateTime;
                    result:=true;
                    Trend.Sql.Clear;
                    exit;
                    end;
                    Sql.Clear;
                  end;
                  except
                    on  E: Exception do
                   begin
                     try
                      close;
                     except;
                     end;
                   Trend.Sql.Clear;
                   CheckConnection(E);
                   end;
                 end;
             end;
          finally
            Trend.FreeOnRelease;
            if Trend.Active then
            Trend.Active:=false;
          end;
    end;
end;

function TDataBDE.GetLogID(iname: string): integer;
  var
   fn, s, iname_ : string;
   recordexist: boolean;
begin
 result:=-1;
 fn:='trenddef';
 if not TableExist(fn,TREND_BASE) then
         begin

          exit;
         end;
  try
  with Trend do
     begin
       s := 'select cod from ' + fn+
        ' where IName=:nm';
       SQL.Clear;
       SQL.Add(s);
       params.ParamByName('nm').Value:=iName_;
       Open;
       if ((Trend.RecordCount>0) and  (not Fields[0].IsNull)) then result:=Fields[0].AsInteger;
       close;
     end
   finally
     Trend.FreeOnRelease;
     if Trend.Active then
       Trend.Active:=false;
   end;

end;

procedure TDataBDE.GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true);
var i,j: integer;
    firsttable: string;
    fn, s: string;
    val: TDateTime;
    isfind: boolean;
    sl: TStringList;
begin

   try
   try
   sl:=TStringList.create;
   firsttable:='';

   isfind:=false;

   setlength(res.point,0);
   res.npoint:=0;
   setlength(res.time,1);
   res.ntime:=1;
   res.time[0][1]:=starttime;
   res.time[0][2]:=stoptime;


   if (starttime>=stopTime) then exit;
   val:=starttime;
   j:=0;
   s:='';
   while (val<=stopTime) do
     begin
       fn := trendDateToFileName(val);
       if TableExist(fn,TREND_BASE) then
         begin
           isfind:=true;
           if ((firsttable='') and (j=0)) then
             begin
               firsttable:=fn;

             end ;

             sl.Add(fn);

         end;
         j:=j+1;
         val:=incday(val,1);
         if (val>stopTime) and
           (trendDateToFileName(val)=
           trendDateToFileName(stopTime))
           then val:=stopTime;
     end;
     if isfind  then
     begin
     with Trend do
     begin
      // try

       if (firsttable<>'') then
         begin
            s:='select tm, val from '+ firsttable+ ' where (cod = :cod and tm = (select max(tm) from '+ firsttable +' where ((cod = :cod) and (tm<:start)) )) ';
         end;
       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            s:='select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = :cod) and (tm >= :start) and (tm <= :stop)) '
          else
            s:=s+' union select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = :cod) and (tm >= :start) and (tm <= :stop)) '
        end;

       if s<>'' then s:=' '+s+'  order by tm asc';

       SQL.Clear;
       SQL.Add(s);
       params.ParamByName('cod').Value:=id;
       if pos(':start',s)>0 then
       begin
       params.ParamByName('start').DataType:=ftDateTime;
       params.ParamByName('start').Value:=starttime;
       end;
       if pos(':stop',s)>0 then
       begin
       params.ParamByName('stop').DataType:=ftDateTime;
       params.ParamByName('stop').Value:=stoptime;
       end;
      // Trend.ExecSQL;
       if endp then
       readDataSet(Trend,starttime,stoptime,res,endp)
       else
       readDataSetNative(Trend,starttime,stoptime,res);

     //  except
        SQL.Clear;
      // end;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);
     end
     finally
     Trend.SQL.Clear;
     Trend.FreeOnRelease;
     if Trend.Active then
       Trend.Active:=false;
     sl.free;  
     end;
end;


procedure TDataBDE.GetRepData(id: integer;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);
var i,j: integer;

    fn, s: string;
    val: TDateTime;
    isfind: boolean;
    sl: TStringList;
begin
   try
   try
     starttime:=incsecond(starttime,20);
   stoptime:=incsecond(stoptime,20);
   sl:=TStringList.create;

   isfind:=false;
   setlength(res.point,0);
   res.npoint:=0;
   setlength(res.time,0);
   res.ntime:=0;


   if (starttime>=stopTime) then exit;
   val:=starttime;
   j:=0;
   s:='';
   while (val<=stopTime) do
     begin
      fn := ReportDateToFileName(val,0);
       if TableExist(fn,TREND_BASE) then
         begin
           isfind:=true;
           sl.Add(fn);
         end;
         j:=j+1;
         if (typ_ in REPORT_SET_ONETAB) then
           val:=incday(stopTime,1);

         if (typ_ in REPORT_SET_YEARTAB) then
           val:=incYear(val,1);

         if (typ_ in REPORT_SET_MONTHTAB) then
           val:=incMonth(val,1);

        // val:=incday(val,1);
         if (val>stopTime) and
           (ReportDateToFileName(val, typ_)=
           ReportDateToFileName(stopTime, typ_))
           then val:=stopTime;
     end;
     if isfind  then
     begin
     with Trend do
     begin
     //  try

       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            s:='select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = :cod) and (tm > :start) and (tm <= :stop)) '
          else
            s:=s+' union select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = :cod) and (tm > :start) and (tm <= :stop)) '
        end;

       if s<>'' then s:='( '+s+' ) order by tm asc';

       SQL.Clear;
       SQL.Add(s);
       params.ParamByName('cod').Value:=id;
       if pos(':start',s)>0 then
       begin
       params.ParamByName('start').DataType:=ftDateTime;
       params.ParamByName('start').Value:=starttime;
       end;
       if pos(':stop',s)>0 then
       begin
       params.ParamByName('stop').DataType:=ftDateTime;
       params.ParamByName('stop').Value:=stoptime;
       end;
      // Trend.ExecSQL;
       readDataSetNative(Trend,starttime,stoptime,res)

     //  except
      //  SQL.Clear;
      // end;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);
     end
     finally
     Trend.SQL.Clear;
     Trend.FreeOnRelease;
     if Trend.Active then
       Trend.Active:=false;
     sl.free;  
     end;
end;

function TDataBDE.CheckConnection(E: Exception):integer;
var
   TableList: TStringList;
begin
  //   try
  //   TableList:=TStringList.Create;
     //TrendConnection.Commit;
 //    session.GetTableNames(ALARM_BASE, '', False, false, TableList);
 //    session.GetTableNames(TREND_BASE, '', False, false, TableList);

 //   except
  //    E:=LostConnectionError.Create('');
  //  end;
  //  TableList.free;
  //  raise E;
end;

procedure TDataBDE.FreeAndReLease;
begin
       try
       Trend.FreeOnRelease;
       if Trend.Active then
       Trend.Active:=false;
       except
       end;
       try
       TrendConnection.FreeOnRelease;
       except
       end;

        try
       Alarm.FreeOnRelease;
       if Alarm.Active then
       Alarm.Active:=false;
       except
       end;
       try
       AlarmConnection.FreeOnRelease;
       except
       end;
end;

function TDataBDE.getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet;
var i,j: integer;
    firsttable: string;
    fn, s: string;
    val: TDateTime;
    isfind: boolean;
    sl: TStringList;
    tgSortStr: string;
    stSortStr: string;
    agrSortStr: string;
    hostsSortStr: string;
    operSortStr: string;
    ffirst: boolean;
begin
   try
   try
   sl:=TStringList.create;


   isfind:=false;
   tgSortStr:='';
   stSortStr:='';
   agrSortStr:='';
   hostsSortStr:='';
   operSortStr:='';

   if tgList<>nil then
    if tgList.Count>0 then
      begin
         tgSortStr:='(itag in (';
         for i:=0 to tgList.Count-1 do
           begin
            tgSortStr:=tgSortStr+char($27)+tgList.Strings[i]+char($27);
            if (i<>(tgList.Count-1)) then tgSortStr:=tgSortStr+', ';
           end;
         tgSortStr:=tgSortStr+'))';
      end;

   if aggroups<>nil then
    if aggroups.Count>0 then
      begin
         agrSortStr:='(igroup in (';
         for i:=0 to aggroups.Count-1 do
           begin
            agrSortStr:=agrSortStr+char($27)+aggroups.Strings[i]+char($27);
            if (i<>(aggroups.Count-1)) then agrSortStr:=agrSortStr+', ';
           end;
         agrSortStr:=agrSortStr+'))';
      end;

    if hosts<>nil then
    if hosts.Count>0 then
      begin
         hostsSortStr:='(ihost in (';
         for i:=0 to hosts.Count-1 do
           begin
            hostsSortStr:=hostsSortStr+char($27)+hosts.Strings[i]+char($27);
            if (i<>(hosts.Count-1)) then hostsSortStr:=hostsSortStr+', ';
           end;
         hostsSortStr:=hostsSortStr+'))';
      end;


    if operators<>nil then
    if operators.Count>0 then
      begin
         operSortStr:='(ioperator in (';
         for i:=0 to operators.Count-1 do
           begin
            operSortStr:=operSortStr+char($27)+operators.Strings[i]+char($27);
            if (i<>(operators.Count-1)) then operSortStr:=operSortStr+', ';
           end;
         operSortStr:=operSortStr+'))';
      end;


    if msgset<>[ejEvent, ejOn, ejOff, ejCommand, ejAlOn, ejAlOff, ejAlKvit] then
      begin
         ffirst:=true;
         stSortStr:='';
         for i:=0 to 6 do
           begin
            if TJournalMessageType(i) in msgset then
               begin
                 if ffirst then
                  begin
                     ffirst:=false;
                     stSortStr:='(istate in ('+char($27)+
                     getTextJmessage(TJournalMessageType(i))+char($27);
                  end else
                     stSortStr:=stSortStr+', '+char($27)+
                     getTextJmessage(TJournalMessageType(i))+char($27);
               end;
            end;
         stSortStr:=stSortStr+'))';
      end;


   if (starttime>=stopTime) then exit;

   val:=starttime;
   j:=0;
   s:='';
   while (val<=stopTime) do
     begin
       fn := AlarmDateToFileName(val);
       if TableExist(fn,ALARM_BASE) then
         begin
           isfind:=true;
           sl.Add(fn);

         end;
         j:=j+1;
         val:=incMonth(val,1);
         if (val>stopTime) and
           (AlarmDateToFileName(val)=
           AlarmDateToFileName(stopTime))
           then val:=stopTime;
     end;
     if isfind  then
     begin
     with Alarm do
     begin
     //  try


       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            begin
            s:='select * from '+  sl.Strings[i]  +
            ' where ((tm >= :start) and (tm <= :stop) ';
            if tgSortStr<>'' then s:=s+'and '+tgSortStr;
            if stSortStr<>'' then s:=s+'and '+stSortStr;
            if agrSortStr<>'' then s:=s+'and '+agrSortStr;
            if hostsSortStr<>'' then s:=s+'and '+hostsSortStr;
            if operSortStr<>'' then s:=s+'and '+operSortStr;
            s:=s+')  ';
            end
          else
            begin
            s:=s+' union select * from '+  sl.Strings[i]  +
            ' where ((tm >= :start) and (tm <= :stop) ';
            if tgSortStr<>'' then s:=s+'and '+tgSortStr;
            if stSortStr<>'' then s:=s+'and '+stSortStr;
            if agrSortStr<>'' then s:=s+'and '+agrSortStr;
            if hostsSortStr<>'' then s:=s+'and '+hostsSortStr;
            if operSortStr<>'' then s:=s+'and '+operSortStr;

            s:=s+')  '
            end;
        end;

       if s<>'' then s:=s+' order by tm desc';

       SQL.Clear;
       SQL.Add(s);

       if pos(':start',s)>0 then
       begin
       params.ParamByName('start').DataType:=ftDateTime;
       params.ParamByName('start').Value:=starttime;
       end;
       if pos(':stop',s)>0 then
       begin
       params.ParamByName('stop').DataType:=ftDateTime;
       params.ParamByName('stop').Value:=stoptime;
       end;
       Alarm.Open;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);

     end
     finally

       sl.free;
       result:=Alarm;
    end;
end;


function TDataBDE.getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet;
var i,j,k: integer;
    fn, h1, h2, Sreq: string;
    val: TDateTime;
    isfind: boolean;
    sl: TStringList;
    outVal: string;
    s: array of string;
    tmpalias_tb: string;
begin
   try
   try
   result:=nil;
   starttime:=incsecond(starttime,20);
   stoptime:=incsecond(stoptime,20);
   sl:=TStringList.create;

   isfind:=false;
   setlength(res.point,0);
   res.npoint:=0;
   setlength(res.time,0);
   res.ntime:=0;

   if (starttime>=stopTime) then exit;
   val:=starttime;
   j:=0;

   while (val<=stopTime) do
     begin
       fn := ReportDateToFileName(val, RU.typeEl);
       if TableExist(fn,TREND_BASE) then
         begin
           isfind:=true;
           sl.Add(fn);

         end;
         j:=j+1;
         if (RU.typeEl in REPORT_SET_ONETAB) then
           val:=incYear(stopTime,200);

         if (RU.typeEl in REPORT_SET_YEARTAB) then
           val:=incYear(val,1);

         if (RU.typeEl in REPORT_SET_MONTHTAB) then
           val:=incMonth(val,1);

        // val:=incday(val,1);
         if (val>stopTime) and
           (ReportDateToFileName(val, RU.typeEl)=
           ReportDateToFileName(stopTime, RU.typeEl))
           then val:=stopTime;
     end;

     if sl.Count=0 then exit; //  очистка ненужна exit возможен

     setLength(s,sl.Count);

     for k:=0 to sl.Count-1 do s[k]:='';

     for k:=0 to sl.Count-1 do
     begin
     outVal:=' '+gettmpalias(k)+'0.tm ';
     for i:=0 to RU.Count-1 do
       begin
         if outVal='' then outVal:=outVal+gettmpalias(k)+trim(inttostr(i+1))+'.val as '+trim(Ru.GetTg(i))  else
           outVal:=outVal+', '+gettmpalias(k)+trim(inttostr(i+1))+'.val as '+trim(Ru.GetTg(i));
       end;
      s[k]:='select distinct ' +outval+ ' from ' + sl.Strings[k] + ' '+gettmpalias(k)+'0 ';
     end;

     if isfind  then
     begin
     with Trend do
     begin


     for k:=0 to sl.Count-1 do
      begin
      for i:=0 to RU.Count-1 do
       begin
         tmpalias_tb:=' '+ gettmpalias(k) + trim(inttostr(i+1));
         s[k]:=s[k]+{' full outer}' left join '+ sl.Strings[k] + ' ' + tmpalias_tb + ' on ' +tmpalias_tb+'.cod='+
           trim(inttostr(Ru.GetCod(i))) + ' and ' + tmpalias_tb+ '.tm='+gettmpalias(k)+'0.tm ';
       end;
      end;

      for k:=0 to sl.Count-1 do
        begin
          s[k]:=s[k]+' where not ('+gettmpalias(k)+'0.tm is null) and not (';
          for i:=0 to RU.Count-1 do
            begin
             tmpalias_tb:=' '+gettmpalias(k) + trim(inttostr(i+1));
            if i=0 then s[k]:=s[k]+ tmpalias_tb+'.val is null' else
              s[k]:=s[k]+' and '+ tmpalias_tb+'.val is null';
            end;
           s[k]:=s[k]+')';
        end;

      for k:=0 to sl.Count-1 do
         begin
          s[k]:=s[k]+ ' and (('+gettmpalias(k)+'0.tm >= :start) and ('+gettmpalias(k)+'0.tm <= :stop)) ' ;
          s[k]:=' '+s[k]+'  order by '+gettmpalias(k)+'0.tm asc';
       //   s[k]:='( '+s[k]+' )'
         end;
      Sreq:='';
      for k:=0 to sl.Count-1 do
         begin
           if k=0 then Sreq:=s[k] else
            Sreq:=Sreq+' union '+s[k];
         end;

     // if Sreq<>'' then Sreq:='( '+Sreq+' ) order by '+gettmpalias(0)+'0.tm asc';

       SQL.Clear;
       SQL.Add(Sreq);
       //params.ParamByName('cod').Value:=id;
       if pos(':start',Sreq)>0 then
       begin
       params.ParamByName('start').DataType:=ftDateTime;
       params.ParamByName('start').Value:=starttime;
       end;
       if pos(':stop',Sreq)>0 then
       begin
       params.ParamByName('stop').DataType:=ftDateTime;
       params.ParamByName('stop').Value:=stoptime;
       end;

       result:=self.Trend;



     end;
     end;
     except
       on  E: Exception do CheckConnection(E);
     end
     finally
      // TrendQuery.SQL.Clear;
      // TrendQuery.FreeOnRelease;
      // if TrendQuery.Active then
      // TrendQuery.Active:=false;
      // sl.free;
    end;
end;

procedure TDataBDE.loadTrdef(val : TTrenddefList; error: boolean=false);
var fn,s: string;

begin
   fn:='trenddef';
   try
   try
   if val=nil then exit;
   val.Clear;
   if TableExist(fn,TREND_BASE) then
         begin
            s:='select * from trenddef';
            with Trend do
              begin
                SQL.Clear;
                SQL.Add(s);
                Open;
                first;

                while (not Eof) do
                  begin


                    val.AddItems(FieldByName('cod').AsInteger,
                                 FieldByName('iname').AsString,
                                 FieldByName('icomment').AsString,
                                 FieldByName('eu').AsString,
                                 FieldByName('mineu').AsFloat,
                                 FieldByName('maxeu').AsFloat,
                                 FieldByName('minraw').AsFloat,
                                 FieldByName('maxraw').AsFloat,
                                 FieldByName('logdb').AsFloat,
                                 FieldByName('logtime').AsInteger,
                                 FieldByName('deadbaund').AsFloat,
                                 (FieldByName('onmsg').AsInteger>0),
                                 (FieldByName('offmsg').AsInteger>0),
                                 (FieldByName('almsg').AsInteger>0),
                                 (FieldByName('logged').AsInteger>0)
                    );
                    next;
                  end;
              end;

         end;
         val.Init:=true;
   except
    on E: Exception do
      begin
         if error then ShowMessage(E.Message);
      end;
   end
   finally
     try
       Trend.SQL.Clear;
       Trend.FreeOnRelease;
       if Trend.Active then
       Trend.Active:=false;
     except
     end;
   end
end;


end.
