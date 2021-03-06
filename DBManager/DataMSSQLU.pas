unit DataMSSQLU;

interface

uses
  SysUtils, Classes,MainDataModuleU, DateUtils,Math, DBTables, DB, ADODB, ConstDef, Dialogs, ActiveX,
  Comobj, StrUtils;

type
  TDataMSSQL = class(TMainDataModule)
    TrendConnection: TADOConnection;
    TrendQuery: TADOQuery;
   private
    lasttrend: string;
    lastalarm: string;
    lastosc: string;
    lastuchet: string;
    function FormatDT(value: TDateTime; chars: boolean): string;
    { Private declarations }
  protected
     function WriteAlarm (id: integer; igroup, itag,  iComment, iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean; override;
     function getConnected(): boolean;  override;
     function GetLastRep(rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime): boolean;  override;   // getlastlog
     function CreateFilegroup(iFileName: String): boolean;
     procedure init();  override;
     procedure uninit();  override;

     function WriteLog (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer; override;
     function WriteReport(Code:longInt;  typ: integer; Data: real; time: TDateTime): integer; override;
     procedure GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime; endp: boolean = true);  override;
     procedure GetRepData(id: integer;  typ_: integer; starttime: TDateTime; stopTime: TDateTime);  override;
     function getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet; override;
     function getRepCountData_(itag: string; expr_: string; strlist: strarray;  intlist: intarray; typ_: integer; time: TDateTime; var ress: real): boolean; override;
  public

    function CheckConnection(E: Exception):integer; override;

    function TableExist(iFileName: String): boolean;
    function delTable(fn: string): boolean; override;
  
    function CreateTrTable(iFileName: String): boolean; override;
    function CreateAlTable(iFileName: String): boolean; override;
    function CreateRepTable(iFileName: String): boolean; override;
    function CreateTrenddef(): boolean;  override;

    function Connect(): boolean;  override;
    function DisConnect(): boolean;  override;




    function WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
             onmsg_: boolean; offmsg_: boolean; almsg_: boolean; logged: boolean; oper: TTrendDefOp; list: TTrenddefList): integer; override;


    function GetLogID(iname: string): integer;  override;


    procedure FreeAndReLease; override;

    function  getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet; override;

    procedure loadTrdef(val : TTrenddefList; error: boolean=false); override;

    { Public declarations }
  end;


implementation


procedure TDataMSSQL.init();
begin
CoInitialize(nil);
TrendQuery:=TADOQuery.Create(nil);
TrendConnection:=TADOConnection.Create(TrendQuery);
TrendQuery.Connection:=TrendConnection;
TrendConnection.LoginPrompt:=false;
TrendConnection.Provider:='SQLOLEDB.1';


end;


procedure TDataMSSQL.uninit();
begin
 CoUninitialize;
//if ffreeDS then
//begin
try
DisConnect;
except
end;
TrendQuery.free;
//end;

end;

function TDataMSSQL.FormatDT(value: TDateTime; chars: boolean): string;
begin
 if chars then
 result:=char($27)+FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',value)+char($27)
 else result:=FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',value);
end;


function TDataMSSQL.Connect(): boolean;
var connectstr: string;
begin
  if TrendConnection.Connected then  TrendConnection.Connected:=false;
  connectstr:='Provider=SQLOLEDB.1;Password='+Password+
  ';Persist Security Info=True;User ID='+ User+
  ';Initial Catalog='+DataBase+
  ';Data Source='+Server;
  TrendConnection.ConnectionString:=connectstr;
  if (action=dbaReadOnly) then
  TrendConnection.Mode:=cmRead else TrendConnection.Mode:=cmReadWrite;
  //if Port>-1 then TrendConnection.Port:=Port;
  TrendConnection.Connected:=true;
  result:=TrendConnection.Connected;
  testbefore;
end;

function TDataMSSQL.CreateFilegroup(iFileName: String): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := iFileName;

  with TrendQuery do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ TrendConnection.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ TrendConnection.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;
   end;
end;

function TDataMSSQL.DisConnect(): boolean;
begin
  if TrendConnection.Connected then  TrendConnection.Connected:=false;
  result:= not TrendConnection.Connected;
end;

function TDataMSSQL.getConnected(): boolean;
begin
   result:= TrendConnection.Connected;
end;

function TDataMSSQL.TableExist(iFileName: String): boolean;
var
   TableList: TStringList;
   i : integer;
begin
    // ShowMessage('eeee');
     result := false;
     TableList := TStringlist.Create;
     try
     TrendConnection.GetTableNames(TableList,false);
      for i := 0 to TableList.count - 1 do
         if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            result:= true;
            break;
         end;

      // 16.02
     if ((action=dbaReadOnly)) then
       begin
         recConnect;
         TrendConnection.GetTableNames(TableList,false);
         for i := 0 to TableList.count - 1 do
           if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            result:= true;
            break;
          end;
       end;
     finally
         TableList.Free;
     end;
end;

function TDataMSSQL.CreateTrTable(iFileName: String): boolean;
 var fn, s : string;
begin
  fn := iFileName;
  try
  with TrendQuery do
   begin

      CreateFilegroup(fn);

      Sql.Clear;

      s:= 'CREATE TABLE ' + fn + ''+
                                      ' (cod INTEGER NOT NULL, tm DATETIME NOT NULL, val FLOAT NULL,' +
                                      'PRIMARY KEY(cod, tm)) ';
      Sql.Add (s);
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD_'+fn+' ON ' + fn + ' (COD) ');
      ExecSQL;
     // TrendConnection.Disconnect;
     // TrendConnection.connect;
      end;
   except
   TrendQuery.Sql.Clear;
   end;
end;


function TDataMSSQL.CreateAlTable(iFileName: String): boolean;
 var fn, s : string;
begin
  fn := iFileName;
  try
  with TrendQuery do
   begin

      CreateFilegroup(fn);

      Sql.Clear;
      s:='CREATE TABLE ' + fn +
                                      ' (cod INTEGER, tm DATETIME, igroup CHAR(50), itag CHAR(50),' +
                                     'ilevel integer, icomment CHAR(250), istate CHAR(50), ihost CHAR(50),' +
                                      'ioperator CHAR(50))';
      Sql.Add (s );
      ExecSQL;
      Sql.Clear;


      //TrendConnection.Disconnect;
     // TrendConnection.connect;
      end

    except
    TrendQuery.Sql.Clear;
    end
end;


function TDataMSSQL.CreateRepTable(iFileName: String): boolean;
 var fn,s : string;
begin
  fn := iFileName;
  try
  with TrendQuery do
   begin

       CreateFilegroup(fn);

      // ������� ������� � ������
      Sql.Clear;
      s:= 'CREATE TABLE ' + fn +
                                      ' (cod INTEGER NOT NULL, tm DATETIME NOT NULL, val FLOAT NULL,' +
                                      'PRIMARY KEY(cod, tm))  ';
      Sql.Add (s);
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD_'+fn+' ON ' + fn + ' (COD) ');
      ExecSQL;
     // TrendConnection.Disconnect;
     // TrendConnection.connect;
      end;
  except
  TrendQuery.Sql.Clear;
  end
end;

function TDataMSSQL.createTrenddef(): boolean;
 var fn,s : string;
begin
   if not TableExist('trenddef') then
     begin
       try
         with TrendQuery do
            begin

             CreateFilegroup('trenddef');
            // ������� ������� � ������
             Sql.Clear;
             s:= 'CREATE TABLE trenddef (cod INTEGER UNIQUE , iname char(50), icomment TEXT, eu TEXT, mineu FLOAT, maxeu FLOAT, minraw FLOAT, maxraw FLOAT, logdb FLOAT,logtime FLOAT, deadbaund FLOAT, ' ;
             s:= s+ ' onmsg INTEGER, offmsg INTEGER , almsg INTEGER , logged INTEGER, PRIMARY KEY(cod))';
             Sql.Add (s);
             ExecSQL;
            // TrendConnection.Disconnect;
            // TrendConnection.connect;
            end;
       except
       TrendQuery.SQL.Clear;
       end;
     end;
end;


function TDataMSSQL.WriteLog (iLogCode: longInt; Data: real; time: TDateTime; validLevel: boolean): integer;
var
   fn, s : string;

begin
   try
    fn := trendDateToFileName(time);
   if (fn<>lasttrend) and (not TableExist(fn)) then
    begin
      CreateTrTable(fn);
    end;
   lasttrend:=fn;

  with TrendQuery do
  begin
     if validLevel then
     begin

     s := 'insert into ' + fn+
        ' (cod, tm, val) values (:cod, :tm, :Val)';
     SQL.Clear;
     SQL.Add(s);

     Parameters.ParamByName('cod').value := iLogCode;
     Parameters.ParamByName('tm').DataType:=ftString;
     Parameters.ParamByName('tm').value:=FormatDT(time,false);
     Parameters.ParamByName('Val').value := data;
     end else
     begin
     s := 'insert into ' + fn+
        ' (cod, tm ) values (:cod, :tm )';
     SQL.Clear;
     SQL.Add(s);

     Parameters.ParamByName('cod').value := iLogCode;
     Parameters.ParamByName('tm').DataType:=ftString;
     Parameters.ParamByName('tm').value:=FormatDT(time,false);

     end;
    try
     ExecSQL;
      Sql.Clear;
    except
       on  E: Exception do CheckConnection(E);
    end;
  end;
  finally
   TrendQuery.Sql.Clear;
  end;

end;


function TDataMSSQL.WriteAlarm(id: integer; igroup, itag, iComment, iState: string; iAlarmLevel: integer; comp: string; oper: string; time:  TDateTime): boolean;
var
   dateString, pluscommand, sOperator: string;
   fn, s : string;
   itid: integer;
begin
     try
     fn:=alarmDateToFileName(time);
     if (fn<>lastalarm) and (not TableExist(fn)) then
       begin
         CreateAlTable(fn);
       end;
      lastalarm:=fn;



     try

     //if iState<>'�������' then lastComandItem:=-1;
     with TrendQuery do
       begin
         Sql.Clear;


          s:='insert into ' + fn + '(cod, tm, igroup, itag,  ilevel, icomment, istate, ihost, ioperator)' +
                                  ' values (:cod, :tm, :igroup, :itag, :iLevel,  :iComment,' +
                                  ':iState, :iHost, :iOpr)';
         SQL.Add(s);
         Parameters.ParamByName('cod').value := id;
         Parameters.ParamByName('tm').DataType:= ftString;
         Parameters.ParamByName('tm').value := FormatDT(time,false);
         Parameters.ParamByName('igroup').DataType := ftString;
         Parameters.ParamByName('igroup').value := igroup;
         Parameters.ParamByName('itag').DataType := ftString;
         Parameters.ParamByName('itag').value:= itag;
         Parameters.ParamByName('iLevel').value := iAlarmLevel;
         Parameters.ParamByName('iComment').DataType := ftString;
         Parameters.ParamByName('iComment').value := iComment ;
         Parameters.ParamByName('iState').DataType := ftString;
         Parameters.ParamByName('iState').value := iState;
         Parameters.ParamByName('iHost').DataType := ftString;
         Parameters.ParamByName('iHost').value:= ftString;
         Parameters.ParamByName('iOpr').DataType := ftString;
         Parameters.ParamByName('iOpr').value := oper;

         ExecSQL;
         Sql.Clear;
       end;
      except
         on  E: Exception do  CheckConnection(E);
      end;
   finally
    TrendQuery.Sql.Clear;
   end;

end;

function TDataMSSQL.WriteReport(Code:longInt;  typ: integer; Data: real; time: TDateTime): integer;
var
   fn, s : string;
  // per: integer;
begin
   try
    // per:=round(rtitems[Code].logTime);
     fn := reportDateToFileName(time,typ);
     if (fn<>lastuchet) and (not TableExist(fn)) then
       begin
        CreateRepTable(fn);
       end;
     lastUchet:=fn;

     with TrendQuery do
     begin
       s := 'insert into ' + fn+
        ' values (:cod, :tm, :Val)';

        SQL.Clear;
        SQL.Add(s);
        Parameters.ParamByName('cod').value := code;
       // Parameters.ParamByName('nm').DataType:=ftString;
      //  Parameters.ParamByName('nm').value := iname;
     //   Parameters.ParamByName('period').value := typ;
        Parameters.ParamByName('tm').DataType:=ftString;
        Parameters.ParamByName('tm').value:=FormatDT(time,false);
        Parameters.ParamByName('Val').value := data;

    try
     ExecSQL;
     Sql.Clear;
    except
      on  E: Exception do CheckConnection(E);
    end;
  end;
  finally
    TrendQuery.Sql.Clear;
  end;

end;


function TDataMSSQL.WriteTrendef (iLogCode: longInt; iname: string; comment: string; MinEu, MaxEU, minRaw, maxRaw,logDB,logTime, DeadBaund: real; EU: string;
             onmsg_: boolean; offmsg_: boolean; almsg_: boolean; logged: boolean; oper: TTrendDefOp; list: TTrenddefList): integer;
     var
   fn, s,tnps : string;
   recordexist: boolean;
   i: integer;
begin
 fn:='trenddef';
 result:= NSDB_REQEST_OK;
 if not TableExist(fn) then
         begin
          CreateTrenddef;
         end;

  if list<>nil then
    begin
    with TrendQuery do
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

          with TrendQuery do
          begin
           if iLogCode>-1 then
           begin
           s := 'insert into '+fn+' (cod, iname, mineu, maxeu, minraw, maxraw, logdb, deadbaund, logtime, icomment, eu, onmsg, offmsg, almsg,  logged) values(:Cod, :nm, :MinEu, :MaxEu,:MinRaw, :MaxRaw, :logDB, :DeadBaund, :LogTime, :iComment, :EU, :onmsg, :offmsg, :almsg, :logged)';
           SQL.Clear;
           SQL.Add(s);
           Parameters.ParamByName('cod').Value:=iLogCode;
           Parameters.ParamByName('nm').Value:=iName;
           Parameters.ParamByName('MinEu').Value:=MinEu;
           Parameters.ParamByName('MaxEu').Value:=MaxEu;
           Parameters.ParamByName('MinRaw').Value:=MinRaw;
           Parameters.ParamByName('MaxRaw').Value:=MaxRaw;
           Parameters.ParamByName('logDB').Value:=logDB;
           Parameters.ParamByName('DeadBaund').Value:=DeadBaund;
           Parameters.ParamByName('LogTime').Value:=LogTime;
           Parameters.ParamByName('iComment').Value:=Comment;
           Parameters.ParamByName('EU').Value:=EU;
           if onmsg_ then Parameters.ParamByName('onmsg').Value:=1 else Parameters.ParamByName('onmsg').Value:=0;
           if offmsg_ then Parameters.ParamByName('offmsg').Value:=1 else Parameters.ParamByName('offmsg').Value:=0;
           if almsg_ then Parameters.ParamByName('almsg').Value:=1 else Parameters.ParamByName('almsg').Value:=0;
           if logged then Parameters.ParamByName('logged').Value:=1 else Parameters.ParamByName('logged').Value:=0;
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
           Parameters.ParamByName('nm').Value:=iName;
           Parameters.ParamByName('MinEu').Value:=MinEu;
           Parameters.ParamByName('MaxEu').Value:=MaxEu;
           Parameters.ParamByName('MinRaw').Value:=MinRaw;
           Parameters.ParamByName('MaxRaw').Value:=MaxRaw;
           Parameters.ParamByName('logDB').Value:=logDB;
           Parameters.ParamByName('DeadBaund').Value:=DeadBaund;
           Parameters.ParamByName('LogTime').Value:=LogTime;
           Parameters.ParamByName('iComment').Value:=Comment;
           Parameters.ParamByName('EU').Value:=EU;
           if onmsg_ then Parameters.ParamByName('onmsg').Value:=1 else Parameters.ParamByName('onmsg').Value:=0;
           if offmsg_ then Parameters.ParamByName('offmsg').Value:=1 else Parameters.ParamByName('offmsg').Value:=0;
           if almsg_ then Parameters.ParamByName('almsg').Value:=1 else Parameters.ParamByName('almsg').Value:=0;
           if logged then Parameters.ParamByName('logged').Value:=1 else Parameters.ParamByName('logged').Value:=0;
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
        with TrendQuery do
         begin
          s := 'select cod from ' + fn+
          ' where IName=:nm';
          SQL.Clear;
          SQL.Add(s);
         Parameters.ParamByName('nm').DataType:=ftString;
         Parameters.ParamByName('nm').value := iname;
         try
          Open;
          recordexist:=(TrendQuery.RecordCount>0);
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
            onmsg_, offmsg_, almsg_, logged, tdoAdd, nil);
            SQL.Clear;
            exit;
            end else
            begin

            s := 'update '+fn+' set  mineu = :MinEu , maxeu = :MaxEu, minraw = :MinRaw, maxraw = :MaxRaw, logdb = :logDB, deadbaund = :DeadBaund, logtime = :LogTime, icomment = :iComment, eu = :EU, onmsg = :onmsg, offmsg = :offmsg, almsg = :almsg, logged = :logged where iname = :iName';
            SQL.Add(s);
            Parameters.ParamByName('iname').Value:=iName;
            Parameters.ParamByName('MinEu').Value:=MinEu;
            Parameters.ParamByName('MaxEu').Value:=MaxEu;
            Parameters.ParamByName('MinRaw').Value:=MinRaw;
            Parameters.ParamByName('MaxRaw').Value:=MaxRaw;
            Parameters.ParamByName('logDB').Value:=logDB;
            Parameters.ParamByName('DeadBaund').Value:=DeadBaund;
            Parameters.ParamByName('LogTime').Value:=LogTime;
            Parameters.ParamByName('iComment').Value:=Comment;
            Parameters.ParamByName('EU').Value:=EU;
            if onmsg_ then Parameters.ParamByName('onmsg').Value:=1 else Parameters.ParamByName('onmsg').Value:=0;
            if offmsg_ then Parameters.ParamByName('offmsg').Value:=1 else Parameters.ParamByName('offmsg').Value:=0;
            if almsg_ then Parameters.ParamByName('almsg').Value:=1 else Parameters.ParamByName('almsg').Value:=0;
            if logged then Parameters.ParamByName('logged').Value:=1 else Parameters.ParamByName('logged').Value:=0;
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


function TDataMSSQL.delTable(fn: string): boolean;
var s: string;
begin
result:=true;
if not TableExist(fn) then exit;
result:=false;
try
 with TrendQuery do
       begin
        Sql.Clear;
        s:='DROP TABLE ' + fn ;
        Sql.Add (s );
        ExecSQL;
        Sql.Clear;
        result:=true;
       end;
except
 TrendQuery.Sql.Clear;
end;
end;






function TDataMSSQL.GetLastRep (rtid: integer; typ_: integer; seachV: TdateTime; var tms: TdateTime ): boolean;
var
   fn, s,hh : string;
begin
    fn := reportDateToFileName(seachV,typ_);
    result:=false;
    if  TableExist(fn) then
        begin
          try
          with TrendQuery do
            begin
              s := 'select max(tm) from '+fn+' where (cod = :cod)';
              SQL.Clear;
              SQL.Add(s);
              Parameters.parambyname('cod').value := rtid;
                try
                 Open;
                  if (RecordCount=0) then  TrendQuery.Sql.Clear
                  else
                  begin
                    first;
                    if (not TrendQuery.Fields[0].IsNull) then   begin
                    tms:=TrendQuery.Fields[0].AsDateTime;
                    hh:=datetimetostr(tms);
                    result:=true;
                    TrendQuery.Sql.Clear;
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
                   TrendQuery.Sql.Clear;
                   CheckConnection(E);
                   end;
                 end;
             end;
          finally
           TrendQuery.FreeOnRelease;
           if TrendQuery.Active then
           TrendQuery.Active:=false;
         end;
    end;
end;


function TDataMSSQL.GetLogID(iname: string): integer;
  var
   fn, s, iname_ : string;
   recordexist: boolean;
begin
 result:=-1;
 fn:='trenddef';
 if not TableExist(fn) then exit;
  try
  with TrendQuery do
     begin
       s := 'select cod from ' + fn+
        ' where IName=:nm';
       SQL.Clear;
       SQL.Add(s);
       Parameters.ParamByName('nm').Value:=iName_;
       Open;
       if ((TrendQuery.RecordCount>0) and  (not Fields[0].IsNull)) then result:=Fields[0].AsInteger;
       close;
     end;
   finally
     TrendQuery.FreeOnRelease;
     if TrendQuery.Active then
       TrendQuery.Active:=false;
   end;

end;

procedure TDataMSSQL.GetLogData(id: integer; starttime: TDateTime; stopTime: TDateTime;  endp: boolean = true);
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
       if TableExist(fn) then
         begin
           isfind:=true;
           if ((firsttable='') and (j=0)) then
             begin
               firsttable:=fn;

             end;

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

     with TrendQuery do
     begin
       Parameters.Clear;
      // try

       if (firsttable<>'') then
         begin
            s:='select tm, val from '+ firsttable+ ' where (cod = '+inttostr(id)+' and tm = (select max(tm) from '+ firsttable +' where ((cod = '+inttostr(id)+') and (tm<'+FormatDT(starttime,true)+')) )) ';
         end;
       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            s:='(select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = '+inttostr(id)+') and (tm >= '+FormatDT(starttime,true)+') and (tm <=' +FormatDT(stoptime,true)+'))) '
          else
            s:=s+' union (select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = '+inttostr(id)+') and (tm >= '+FormatDT(starttime,true)+') and (tm < ='+FormatDT(stoptime,true)+'))) '
        end;

       if s<>'' then s:='( '+s+' ) order by tm asc';

       SQL.Clear;
       SQL.Add(s);
       //Parameters.ParamByName('cod').DataType:=ftInteger;
      // Parameters.ParamByName('cod').Value:=id;
      // if pos(':start',s)>0 then
       //begin
      // Parameters.ParamByName('start').DataType:=ftString;
       //Parameters.ParamByName('start').Value:=FormatDT(starttime);
       //end;
      //if pos(':stop',s)>0 then
      // begin
     //  Parameters.ParamByName('stop').DataType:=ftString;

      // Parameters.ParamByName('stop').Value:=FormatDT(stoptime);
     //  end;
       //TrendQuery.ExecSQL;
       if endp then
       readDataSet(TrendQuery,starttime,stoptime,res,endp)
       else
       readDataSetNative(TrendQuery,starttime,stoptime,res);
       
     //  except
    //    SQL.Clear;
    //   end;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);
     end
     finally
       TrendQuery.SQL.Clear;
       TrendQuery.FreeOnRelease;
       if TrendQuery.Active then
       TrendQuery.Active:=false;
       sl.free;
     end;
end;

procedure TDataMSSQL.GetRepData(id: integer; typ_: integer; starttime: TDateTime; stopTime: TDateTime);
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
       if TableExist(fn) then
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

     with TrendQuery do
     begin
       Parameters.Clear;
      // try


       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            s:='(select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = '+inttostr(id)+') and (tm > '+FormatDT(starttime,true)+') and (tm <=' +FormatDT(stoptime,true)+'))) '
          else
            s:=s+' union (select tm, val from '+  sl.Strings[i]  +
            ' where ((cod = '+inttostr(id)+') and (tm > '+FormatDT(starttime,true)+') and (tm < ='+FormatDT(stoptime,true)+'))) '
        end;

       if s<>'' then s:='( '+s+' ) order by tm asc';

       SQL.Clear;
       SQL.Add(s);
       //Parameters.ParamByName('cod').DataType:=ftInteger;
      // Parameters.ParamByName('cod').Value:=id;
      // if pos(':start',s)>0 then
       //begin
      // Parameters.ParamByName('start').DataType:=ftString;
       //Parameters.ParamByName('start').Value:=FormatDT(starttime);
       //end;
      //if pos(':stop',s)>0 then
      // begin
     //  Parameters.ParamByName('stop').DataType:=ftString;

      // Parameters.ParamByName('stop').Value:=FormatDT(stoptime);
     //  end;
       //TrendQuery.ExecSQL;
       readDataSetNative(TrendQuery,starttime,stoptime,res)

      // except
      //  SQL.Clear;
     //  end;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);
     end
     finally
       TrendQuery.SQL.Clear;
       TrendQuery.FreeOnRelease;
       if TrendQuery.Active then
       TrendQuery.Active:=false;
       sl.free;
     end;
end;


function TDataMSSQL.CheckConnection(E: Exception):integer;
begin
 //   try
     //TrendConnection.Commit;
 //    TrendConnection.Close;
 //    TrendConnection.Connected:=true;
 //    if not TrendConnection.Connected then  E:=LostConnectionError.Create('');
 //   except
   //   E:=LostConnectionError.Create('');
  //  end;
  //  raise E;
end;

procedure TDataMSSQL.FreeAndReLease;
begin
       try
       TrendQuery.FreeOnRelease;
       if TrendQuery.Active then
       TrendQuery.Active:=false;
       except
       end;
       try
       TrendConnection.FreeOnRelease;
       except
       end;
end;

function TDataMSSQL.getJournalDS(starttime: TDateTime; stopTime: TDateTime; msgset: TJournalMessageSet; tgList: TStrings; aggroups: TStrings; hosts: TStrings; operators: TStrings; srtAl: integer=-1; stpAl: integer=-1): TDataSet;
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
       if TableExist(fn) then
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
     with TrendQuery do
     begin
     //  try


       for i:=0 to sl.Count-1 do
        begin
          if s='' then
            begin
            s:='select * from '+  sl.Strings[i]  +
            ' where ((tm >= '+FormatDT(starttime,true)+') and (tm <= '+FormatDT(stoptime,true)+') ';
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
            ' where ((tm >= '+FormatDT(starttime,true)+') and (tm <= '+FormatDT(stoptime,true)+') ';
            if tgSortStr<>'' then s:=s+'and '+tgSortStr;
            if stSortStr<>'' then s:=s+'and '+stSortStr;
            if agrSortStr<>'' then s:=s+'and '+agrSortStr;
            if hostsSortStr<>'' then s:=s+'and '+hostsSortStr;
            if operSortStr<>'' then s:=s+'and '+operSortStr;

            s:=s+')  '
            end;
        end;

       if s<>'' then s:='( '+s+' ) order by tm desc';

       SQL.Clear;
       SQL.Add(s);


       TrendQuery.Open;
     end;
     end;
     except
       on  E: Exception do CheckConnection(E);

     end
     finally

       sl.free;
       result:=TrendQuery;
    end;
end;


function TDataMSSQL.getReportTab(starttime: TDateTime; stopTime: TDateTime; RU: TReportUtit): TDataSet;
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
       if TableExist(fn) then
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

     if sl.Count=0 then exit; //  ������� ������� exit ��������

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
     with TrendQuery do
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
          s[k]:=s[k]+ ' and (('+gettmpalias(k)+'0.tm >= '+FormatDT(starttime,true)+') and ('+gettmpalias(k)+'0.tm <= '+FormatDT(stoptime,true)+')) ' ;
          s[k]:=' '+s[k]+'  order by '+gettmpalias(k)+'0.tm asc';
         // s[k]:='( '+s[k]+' )'
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
       {if pos(':start',Sreq)>0 then
       begin
       params.ParamByName('start').DataType:=ftDateTime;
       params.ParamByName('start').Value:=starttime;
       end;
       if pos(':stop',Sreq)>0 then
       begin
       params.ParamByName('stop').DataType:=ftDateTime;
       params.ParamByName('stop').Value:=stoptime;
       end;  }

       result:=self.TrendQuery;



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


procedure TDataMSSQL.loadTrdef(val : TTrenddefList; error: boolean=false);
var fn,s: string;
begin
   fn:='trenddef';
   try
   try
   if val=nil then exit;
   val.Clear;
   if TableExist(fn) then
         begin
            s:='select * from trenddef';
            with TrendQuery do
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
       TrendQuery.SQL.Clear;
       TrendQuery.FreeOnRelease;
       if TrendQuery.Active then
       TrendQuery.Active:=false;
     except
     end;
   end
end;


function TDataMSSQL.getRepCountData_(itag: string; expr_: string; strlist: strarray;  intlist: intarray; typ_: integer; time: TDateTime; var ress: real): boolean;
var tmp_query, fn, cond_expr: string;
    tmp_sl: TStringList;
    i, pos_: integer;
begin
   result:=false;
   if length(strlist)<1 then exit;
   try
   fn := ReportDateToFileName(time, typ_);
       if TableExist(fn) then
         begin
           tmp_sl:=TStringList.Create;
           tmp_sl.Duplicates:=dupIgnore;
           tmp_sl.Sorted:=true;
           tmp_sl.CaseSensitive:=false;
           for i:=0 to length(strlist)-1 do
             tmp_sl.Add(trim(strlist[i]));

           for i:=0 to tmp_sl.Count-1 do
             expr_:=StringReplace(expr_,tmp_sl.Strings[i],tmp_sl.Strings[i]+'.val',[rfReplaceAll, rfIgnoreCase]);
           tmp_sl.Free;

           pos_:=pos(':', expr_);
           if (pos_<>0) then
             begin
                cond_expr:=RightStr(expr_,length(expr_)-pos_);
                expr_:=LeftStr(expr_,pos_-1);
             end;

           tmp_query:= ' select '+ expr_ + ' from '+ fn ;
           for i:=0 to length(strlist)-1 do
              if (i=0) then tmp_query:= tmp_query+ ' '+ strlist[i]
              else  tmp_query:= tmp_query+', ' +fn+  ' '+ strlist[i];
           tmp_query:=tmp_query+ ' where ';
           for i:=0 to length(strlist)-1 do
             if (length(intlist)>i) then
                  if (i=0) then tmp_query:= tmp_query+ ' '+ strlist[i]+'.cod = ' + inttostr(intlist[i])
                  else tmp_query:= tmp_query+ ' and '+ strlist[i]+'.cod = ' + inttostr(intlist[i]);
           for i:=0 to length(strlist)-2 do
                  tmp_query:= tmp_query+ ' and '+ strlist[i]+'.tm = ' + strlist[i+1]+'.tm ';
           if length(strlist)>0 then tmp_query:=tmp_query+' and '+ strlist[i]+'.tm ='+FormatDT(time,true);
           if cond_expr<>'' then tmp_query:=tmp_query+' and '+cond_expr;
            try
            with TrendQuery do
              begin
                SQL.Clear;
                SQL.Add(tmp_query);
                Parameters.ParamByName('tm').DataType:=ftDateTime;
                Parameters.ParamByName('tm').Value:=time;
                Open;
                first;
                if (TrendQuery.RecordCount>0) and (not Fields[0].IsNull) then
                  begin
                  result:=true;
                  ress:=Fields[0].AsFloat;
                  end;
              end;
               except
                 result:=false;
               end;

         end;
         finally
          TrendQuery.FreeOnRelease;
          if TrendQuery.Active then
          TrendQuery.Active:=false;
      end;
end;

end.
