unit ArhiveTblUs;

interface

uses classes,SvcMgr, DateUtils,SysUtils,MemStructsU, DBTables, db, Forms, dialogs, ConstDef, dm2Us, Variants, UMyTime,GlobalValue,SqlTimSt, TimeSincronize;

function GetLogCode (iName: string): longInt;
procedure WriteLog (iLogCode:longInt; iData: real);
procedure WriteLogP (iLogCode:longInt; iData: real;tim: TDatetime);
procedure WriteStartTime(numb: integer);
procedure WriteTime(numb: integer);
procedure clearerror(numb: integer);
procedure clearArcOff(numb: integer;month: integer);
procedure clearOscOff(month: integer);
procedure WriteOsc (itm: TdateTime; itid: integer; idelt: integer);
procedure WriteUchet(Code:longInt; Data: real; tm: TDateTime);


implementation

//uses dm1us;

var
  CanLog: Boolean = true;
   null_1: double;


function GetLogCode (iName: string): longInt;
var
 ts: boolean;
begin

  GetLogCode := -2;
  //if not CanLog then exit;
   try
  // dm1.Status:=csStartPending;
   //dm2.Trend.Open;
   if TableExist('Trenddef', dm2.Trend) then

     { ShowMessage('Файл Treddef не найден, что может быть связано с тем, что: '+char(13)+
      '1. Система запускается впервые.'+char(13)+
      '2. Изменен каталог доступа к базе Trend в драйвере BDE Administrator.'+char(13)+
      'Таблица Trenddef будет создана заново.
      В случае если система работала и  '+char(13)+
      'до этого, необходимо проверить путь к БД Trend(2) или переисать в текущий'+char(13)+
      'каталог доступа к БД Trend резервную копию  таблицы Trenddef ');
       dm2.tbTrendDef.Sql.Add ('CREATE TABLE Trenddef' +
                                      ' (cod AUTOINC, Name ALPHA, Enabled LOGICAL, MinEU NUMBER, MaxEU NUMBER,Comment ALPHA'+
                                      ' Edizmer ALPHA)');
       dm2.tbTrendDef.sq  }
      {  ShowMessage('Работа с архивом невозможна, файл Treddef не найден');
       CanLog:=false;
       exit;

     end;      }
             begin
              dm2.tbTrendDef.SQL.Clear;
             // dm2.tbTrendDef.Parameters.Clear;
              dm2.tbTrendDef.SQL.Add('select * from trenddef where iName=:Name');

              dm2.tbTrendDef.Parameters.ParamByName('Name').Value:=iName;
              dm2.tbTrendDef.ExecSQL;
              dm2.tbTrendDef.Open;

              if dm2.tbTrendDef.RecordCount=1 then


  {dm2.tbTrendDef.TableName:='TrendDef';
   ts:=dm2.tbTrendDef.Active;
  try
     try
        dm2.tbTrendDef.Active := true;
     except
       CanLog := False;
       ShowMessage('Работа с архивом невозможна, файл Treddef поврежден');
       exit;
     end;
     if dm2.tbTrendDef.Locate('Name', iName, [loCaseInsensitive]) then  }
                result := dm2.tbTrendDef.fieldbyName('Cod').asInteger;
        end;
  except
  // ShowMessage(inttostr(2));
  //  ShowMessage('tttt');

     //dm2.tbTrendDef.Close := ;
 end;
end;

procedure WriteLog (iLogCode:longInt; iData: real);
var
   fn, s : string;

begin
   try
  //if not CanLog then exit; //global variable, determize existing of dataBase

  fn := 'tr' + datetoFileName(Date);
  if not TableExist(fn, dm2.Trend) then
  begin
    //create new trend table
     Sincronize;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать файл архива с именем ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD)');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать индекс для архива ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
  end;

  with dm2.qTrend do
  begin
     s := 'insert into %s (cod, tm, Val)' +
          ' values (:cod, :tm, :val)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
    SQL.Add('insert into ' + fn+
        ' values (:cod, :tm, :Val)');
     Parameters.parambyname('cod').value := iLogCode;

     Parameters.parambyname('tm').DataType:=ftString;
    // Parameters.parambyname('tm').DataType:=ftDateTime;
     //s:=selfFormatDateTime(now);
     Parameters.parambyname('tm').value:=selfFormatDateTime(now);
     Parameters.parambyname('Val').value := idata;

    try
     ExecSQL;
    except
      //если приходят данные в то же время меняем - последние данные самые главные.
      SQL.Clear;
      SQL.Add(format('UPDATE %s SET Val = :Val ' +
                        'WHERE (cod = :Cod) and  (tm = :tm)', [fn]));

      Parameters.parambyname('Cod').value := iLogCode;


      Parameters.parambyname('tm').DataType:=ftDateTime;
      Parameters.parambyname('tm').value := now;
      Parameters.parambyname('Val').value := idata;
    end;
  end;
  except
  end;
    dm2.qTrend.Sql.Clear;
end;


procedure WriteUchet(Code:longInt; Data: real; tm: TDateTime);
var
   fn, s : string;
   per: integer;
begin
   try
  //if not CanLog then exit; //global variable, determize existing of dataBase
  //f (rtitems[Code].logDB<=3600*24)
  per:=round(rtitems[Code].logDB);
  per:=  random(3600*24*30*2);
  fn := datetoFileNameU(Date,per);
  if not TableExist(fn, dm2.Trend) then
  begin
    //create new trend table
     Sincronize;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, nm TEXT, period INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать файл архива с именем ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD)');
    try
      dm2.qTrend.ExecSQL;
    except
   //   raise Exception.Create('Невозможно создать индекс для архива ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
  end;

  with dm2.qTrend do
  begin
     s := 'insert into %s (cod, nm, period, tm, val)' +
          ' values (:cod,  :nm, :period, :tm, :val)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
    SQL.Add('insert into ' + fn+
        ' values (:cod, :nm, :period,:tm, :Val)');
     Parameters.parambyname('cod').value := rtitems[Code].ID;
     Parameters.parambyname('nm').DataType:=ftString;
     Parameters.parambyname('nm').value := rtitems.GetName(Code);
     Parameters.parambyname('period').value := per;
     Parameters.parambyname('tm').DataType:=ftString;
     Parameters.parambyname('tm').value:=selfFormatDateTime(tm);
     Parameters.parambyname('Val').value := data;

    try
     ExecSQL;
    except
      //если приходят данные в то же время меняем - последние данные самые главные.
     // SQL.Clear;
    //  SQL.Add(format('UPDATE %s SET Val = :Val ' +
                   //     'WHERE (cod = :Cod) and  (tm = :tm)', [fn]));

     // Parameters.parambyname('Cod').value := iLogCode;


     // Parameters.parambyname('tm').DataType:=ftDateTime;
     // Parameters.parambyname('tm').value := now;
     // Parameters.parambyname('Val').value := idata;
    end;
  end;
  except
  end;
    dm2.qTrend.Sql.Clear;
end;


procedure WriteOsc (itm: TdateTime; itid: integer; idelt: integer);
var
   fn, s : string;

begin
   if itid<0 then exit;
   if idelt<0 then exit;
   try
     fn := 'OscllConf';
     if not TableExist(fn, dm2.Trend) then
      begin
      dm2.qTrend.Sql.Clear;
      dm2.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (tm DATETIME, iName CHAR(50),iComment CHAR(250), idelt INT');
      try
      dm2.qTrend.ExecSQL;
      except
        //raise Exception.Create('Невозможно создать файл архива с именем ' + fn);
      end;
      end;

     with dm2.qTrend do
      begin
      SQL.Clear;
      SQL.Add('insert into ' + fn+
        ' values (:tm, :iName, :iComment, :idelt)');


      Parameters.parambyname('tm').DataType:=ftString;
      Parameters.parambyname('tm').value:=selfFormatDateTime(now);
      Parameters.parambyname('iName').DataType:=ftString;
      Parameters.parambyname('iName').value:=rtitems.GetName(itid);
      Parameters.parambyname('iComment').DataType:=ftString;
      Parameters.parambyname('iComment').value:=rtitems.GetComment(itid);
      Parameters.parambyname('idelt').Value:=idelt;
      try
      ExecSQL;
      except
      end;
      end;
     except
     end;
end;

procedure WriteLogP (iLogCode:longInt; iData: real;tim: TDatetime);
var
   fn, s : string;

begin
  try
  //if not CanLog then exit; //global variable, determize existing of dataBase

  fn := 'tr' + datetoFileName(tim);
  if not TableExist(fn, dm2.Trend) then
  begin
    //create new trend table
     Sincronize;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm))');
    try
      dm2.qTrend.ExecSQL;
    except
      raise Exception.Create('Невозможно создать файл архива с именем ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD)');
    try
      dm2.qTrend.ExecSQL;
    except
      raise Exception.Create('Невозможно создать индекс для архива ' + fn);
    end;
    dm2.qTrend.Sql.Clear;
  end;

  with dm2.qTrend do
  begin
     s := 'insert into %s (cod, tm, Val)' +
          ' values (:cod, :tm, :val)';
     s := format (s, [fn]);
     DecimalSeparator := '.';
     SQL.Clear;
     SQL.Add(format('insert into %s (cod, tm, Val)' +
          ' values (:cod, :tm, :Val)',[fn]));

     Parameters.parambyname('Cod').value := iLogCode;
     Parameters.parambyname('tm').DataType:=ftString;

     Parameters.parambyname('tm').value := selfFormatDateTime(tim);
     Parameters.parambyname('Val').value := idata;

    try
     ExecSQL;
    except
      //если приходят данные в то же время меняем - последние данные самые главные.
      SQL.Clear;
      SQL.Add(format('UPDATE %s SET Val = :Val ' +
                        'WHERE (cod = :Cod) and  (tm = :tm)', [fn]));

      Parameters.parambyname('tm').DataType:=ftString;
      Parameters.parambyname('Cod').value := iLogCode;
      Parameters.parambyname('tm').value := selfFormatDateTime(tim);
      Parameters.parambyname('Val').value := idata;
    end;
  end;
  except
  end;
end;

procedure WriteStartTime(numb: integer);
var
    s : string;
   null: double;
   tstart,tstop: TDateTime;
   tIsR: boolean;
   tcod: integer;
   tn: string;
begin
 if not conttimeoff then exit;
 try
 null:=0;
 null_1:=402132;
 if numb=0 then tn:='StStDef' else tn:='StStDef'+inttostr(numb);
 //if not CanLog then exit; //global variable, determize existing of dataBase

 // fn := tn;
  if not TableExist(tn, dm2.Trend ) then
  begin
    dm2.qDateTime.Sql.Clear;
    dm2.qDateTime.Sql.Add ('CREATE TABLE ' + tn +
                                      ' (stoptime DATETIME, starttime DATETIME, isR Integer,'+
                                      'PRIMARY KEY (starttime))');
    try
        dm2.qDateTime.ExecSQL;
    except
        // on e:Exception do ShowMessage(E.Message);
    end;
     dm2.qTrend.Sql.Clear;
    dm2.qTrend.Sql.Add ('CREATE INDEX COD ON ' + tn + ' (starttime)');
    try
      dm2.qTrend.ExecSQL;
    except
     // on e:Exception do ShowMessage(E.Message);
    end;
    dm2.qDateTime.Sql.Clear;
    dm2.qDateTime.SQL.Add('insert into '+tn+' (stoptime, starttime, IsR) values (:stoptime, :starttime, :IsR)');
    dm2.qDateTime.Parameters.parambyname('stoptime').DataType:=ftString;
    dm2.qDateTime.Parameters.parambyname('starttime').DataType:=ftString;
    dm2.qDateTime.Parameters.parambyname('starttime').value := '2500-12-30';
    dm2.qDateTime.Parameters.parambyname('stoptime').value:='1900-12-30';
    dm2.qDateTime.Parameters.parambyname('isR').value := false;
    try
      dm2.qDateTime.ExecSQL;
      exit;
    except
     //  on e:Exception do ShowMessage(E.Message);
    end;
   end;

   dm2.qDateTime.Sql.Clear;
   dm2.qDateTime.SQL.Add('update  '+tn+' set starttime=:starttime where starttime=(select max(starttime) from '+tn+')');
   dm2.qDateTime.Parameters.parambyname('starttime').DataType:=ftString;
   dm2.qDateTime.Parameters.parambyname('starttime').value:=selfFormatDateTime(now);
   try
     dm2.qDateTime.ExecSQL;
   except
   //on e:Exception do ShowMessage(E.Message);
   end;
   except
   end;



end;

procedure WriteTime(numb: integer);
var
   tn, start : string;

begin
if not conttimeoff then exit;
try
start:=SQLTimeStampToStr('',DateTimeToSQLTimeStamp(starttime));
 if numb=0 then tn:='StStDef' else tn:='StStDef'+inttostr(numb);
 //fn := tn;
//if not CanLog then exit;
  if not TableExist(tn, dm2.Trend) then
    begin
  //  showmessage('kkkkkk');
    WriteStartTime(numb);
    exit;
    end;
  //
 with dm2.qDateTime do
  begin
     try
     SQL.Clear;

     SQL.Add('Insert into '+tn+'(stoptime, starttime, IsR) values (:stoptime, :starttime, :IsR)');
     Parameters.parambyname('stoptime').DataType:=ftString;
     Parameters.parambyname('starttime').DataType:=ftString;
     Parameters.parambyname('starttime').value:='2500-12-30';
     Parameters.parambyname('stoptime').value := selfFormatDateTime(now);
     Parameters.parambyname('IsR').value := false;
     try

     ExecSQL;

     except
     // on e:Exception do ShowMessage(E.Message);
     end;
     except
     end;
  end;
  except
  end;
 end;


procedure clearerror(numb: integer);
var
   tn, start : string;

begin
if not conttimeoff then exit;
try
start:=SQLTimeStampToStr('',DateTimeToSQLTimeStamp(starttime));
 if numb=0 then tn:='StStDef' else tn:='StStDef'+inttostr(numb);
// fn := tn;
  if not TableExist(tn, dm2.Trend) then
    exit;
 with dm2.qDateTime do
  begin
     try
     SQL.Clear;

     SQL.Add('delete from '+tn+' where ((starttime=:starttime1)  and (stoptime <> (select max(stoptime) from '+tn+' where starttime=:starttime2 )) and (stoptime<>:stoptime)) or ((starttime>:starttime3) and (starttime<>:starttime4))  or (stoptime>:starttime5)');
     Parameters.parambyname('starttime1').DataType:=ftString;
     Parameters.parambyname('starttime1').value:='2500-12-30';
     Parameters.parambyname('starttime2').DataType:=ftString;
     Parameters.parambyname('starttime2').value:='2500-12-30';
     Parameters.parambyname('stoptime').DataType:=ftString;
     Parameters.parambyname('stoptime').value:='1900-12-30';
     Parameters.parambyname('starttime3').DataType:=ftString;
     Parameters.parambyname('starttime3').value:=selfFormatDateTime(now);
     Parameters.parambyname('starttime4').DataType:=ftString;
     Parameters.parambyname('starttime4').value:='2500-12-30';
     Parameters.parambyname('starttime5').DataType:=ftString;
     Parameters.parambyname('starttime5').value:=selfFormatDateTime(inchour(now,1));
     try

     ExecSQL;

     except
     // on e:Exception do ShowMessage(E.Message);
     end;
     Sql.Clear;
     SQL.Add('update  '+tn+' set stoptime=:stoptime where (stoptime=(select min(stoptime) from '+tn+')) and (stoptime<>:stoptime1)');
     Parameters.parambyname('stoptime').DataType:=ftString;
     Parameters.parambyname('stoptime').value:='1900-12-30';
     Parameters.parambyname('stoptime1').DataType:=ftString;
     Parameters.parambyname('stoptime1').value:='1900-12-30';
     try
      ExecSQL;
     except
      // on e:Exception do ShowMessage(E.Message);
     end;
     except

       //on e:Exception do ShowMessage(E.Message);
     end;
  end;
  except
  end;
end;


procedure clearArcOff(numb: integer;month: integer);
var
    tn, start : string;

begin
if not conttimeoff then exit;
try
if month<1 then month:=6;
start:=SQLTimeStampToStr('',DateTimeToSQLTimeStamp(starttime));
 if numb=0 then tn:='StStDef' else tn:='StStDef'+inttostr(numb);
 //fn := tn;
  if not TableExist(tn, dm2.Trend) then
    exit;
 with dm2.qDateTime do
  begin
     try
     SQL.Clear;

     SQL.Add('delete from '+tn+' where (starttime<:starttime1) and (stoptime<>:stoptime)');
     Parameters.parambyname('starttime1').DataType:=ftString;
     Parameters.parambyname('starttime1').value:=selfFormatDateTime(incmonth(now,-1* month));
     Parameters.parambyname('stoptime').DataType:=ftString;
     Parameters.parambyname('stoptime').value:='1900-12-30';
     try

     ExecSQL;

     except
     // on e:Exception do ShowMessage(E.Message);
     end;
   Sql.Clear;
   SQL.Add('update  '+tn+' set starttime=:starttime where (stoptime=:stoptime) and (starttime<:starttime1)');
   Parameters.parambyname('starttime').DataType:=ftString;
   Parameters.parambyname('starttime').value:=selfFormatDateTime(incmonth(now,-1* month));
   Parameters.parambyname('stoptime').DataType:=ftString;
   Parameters.parambyname('stoptime').value:='1900-12-30';
   Parameters.parambyname('starttime1').DataType:=ftString;
   Parameters.parambyname('starttime1').value:=selfFormatDateTime(incmonth(now,-1* month));
   try
     dm2.qDateTime.ExecSQL;
   except
  // on e:Exception do ShowMessage(E.Message);
   end;
     except
     end;

  end;
  except
  end;
 end;

procedure clearOscOff(month: integer);
var
   fn, tn, start : string;

begin
try
if month<1 then month:=6;
 fn := 'OscllConf';
  if not TableExist(fn, dm2.Trend) then
    exit;
 with dm2.qDateTime do
  begin
     try
     SQL.Clear;

     SQL.Add('delete from '+fn+' where tm<:starttime1');
   //  ShowMessage(SQL.text);
     Parameters.parambyname('starttime1').DataType:=ftString;
     Parameters.parambyname('starttime1').value:=selfFormatDateTime(incmonth(now,-1* month));
     try

     ExecSQL;

     except
     // on e:Exception do ShowMessage(E.Message);
     end;
     except
     end;


  end;
  except
  end;
 end;


end.
