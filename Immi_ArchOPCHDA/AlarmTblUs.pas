unit AlarmTblUs;

interface

uses classes, SysUtils, DBTables, db, ConstDef, Comobj,dialogs,memStructsU, DateUtils,globalvalue,ActiveX;

type

TAlarmTable = class
private
  lastTableName: string;
  //qAlarms: TQuery;
  //qOperator: TQuery;
public

  constructor Create;
  procedure WriteAlarm (iName, irtItem, iComment, iState: string; iAlarmLevel: integer);
  procedure WriteAlarmC (iName, irtItem, iComment, iState: string;iAlarmLevel: integer; comp: string; oper: string );
  procedure WriteEventTime (itid: integer; iName, irtItem, iComment, iState: string;iAlarmLevel: integer; dt: TDateTime);
  procedure InitOperator(ID: integer);
  procedure DeleteArchive;
  end;
var
  AlarmTable: TAlarmTable;
  lastComandItem: integer;
  lastcomandvalue: real;
  lastcomandtime: TDateTime;
implementation

uses Dm2us;

constructor TAlarmTable.Create;
begin
     inherited;
     lastTableName := '';
     //dm2.qAlarms:= TQuery.Create(nil);
     //dm2.qAlarms.DatabaseName := 'alarms';
     lastComandItem:=-1;
    // qOperator:= TQuery.Create(nil);
    // qOperator.DatabaseName := 'Registration';
     lastComandItem:=-1;
end;


procedure TAlarmTable.WriteEventTime (itid:integer; iName, irtItem, iComment, iState: string;iAlarmLevel: integer; dt: TDateTime);
var
   s,dateString,  sOperator : string;

begin
     try
     //удаление старого файла, старее 3 месяцев
   //  s:=DatetoFilename(IncMonth(Date, -3));
  //   DeleteFile('..\dbdata\Alarms\'+s+'.DB');

     //получение имени сегодняшнего файла
     //sOperator:=ConstDef.OperatorName^;
     dateString :='al'+ datetoFileName(dt);



     if trim(lastTableName) <> trim(dateString) then
     begin

        lastComandItem:=-1;

        if not TableExist(dateString, dm2.Alarms) then
         begin
       //create alarm trend table
          dm2.qAlarms.Sql.Clear;
          dm2.qAlarms.Sql.Add ('CREATE TABLE ' + dateString +
                                      ' (tm DateTime, iName CHAR(50), iPARAM CHAR(50),' +
                                     'iLevel integer, icomment CHAR(250), iState CHAR(50),' +
                                      'iOperator CHAR(50), iSELECTED INTEGER)');
          try
            dm2.qAlarms.ExecSQL;
          except
            raise Exception.Create('Невозможно создать журнал тревог ' + dateString);
          end;
         end;//создание таблицы
      end;
       lastTableName := dateString;


    with dm2.qAlarms do
    begin
     Sql.Clear;


     SQL.Add('insert into ' + dateString + '(tm, iname, iparam, ilevel, icomment, istate, ioperator)' +
                                  ' values (:prTime, :iName,:irtItem,:iAlarmLevel,:iComment,' +
                                  ':iState, :iOpr)');

     Parameters.Parambyname('iName').DataType := ftString;
     Parameters.Parambyname('irtItem').DataType := ftString;
     Parameters.Parambyname('iComment').DataType := ftString;
     Parameters.Parambyname('iState').DataType := ftString;
     Parameters.Parambyname('iOpr').DataType := ftString;
     Parameters.Parambyname('prtime').DataType:= ftString;


     Parameters.Parambyname('prTime').value := SelfFormatDateTime(dt);
     Parameters.Parambyname('iName').value:= iName;
     Parameters.Parambyname('irtItem').value := irtItem;
     Parameters.Parambyname('iAlarmLevel').value := iAlarmLevel;
     Parameters.Parambyname('iComment').value := iComment;
     Parameters.Parambyname('iState').value := iState;
     Parameters.Parambyname('iOpr').value := sOperator;
     try
       ExecSQL;
     except
        //showMessage (sql.Text);
       // raise;
     end;
    end
    except
    end;

end;

procedure TAlarmTable.WriteAlarm (iName, irtItem, iComment, iState: string;iAlarmLevel: integer);
var
   s,dateString, pluscommand, sOperator: string;
   itid: integer;
begin
      try
     //удаление старого файла, старее 3 месяцев
   //  s:=DatetoFilename(IncMonth(Date, -3));
  //   DeleteFile('..\dbdata\Alarms\'+s+'.DB');

     //получение имени сегодняшнего файла
     sOperator:=ConstDef.OperatorName^;
     dateString :='al'+ datetoFileName(Date);
     //Showmessage('pred1');
     pluscommand:='';
     if trim(lastTableName) <> trim(dateString) then
     begin
      //  Showmessage('pred2');
        lastComandItem:=-1;
         {Showmessage('pred3');
         if dm2=nil then Showmessage('dm - nil');
         if dm2.Alarms=nil then Showmessage('dm - nil'); }
        if not TableExist(dateString, dm2.Alarms) then
         begin

       //create alarm trend table
          dm2.qAlarms.Sql.Clear;
          dm2.qAlarms.Sql.Add ('CREATE TABLE ' + dateString +
                                      ' (tm DateTime, iName CHAR(50), iPARAM CHAR(50),' +
                                     'iLevel integer, icomment CHAR(250), iState CHAR(50),' +
                                      'iOperator CHAR(50), iSELECTED INTEGER)');
          try
            dm2.qAlarms.ExecSQL;
          except
            raise Exception.Create('Невозможно создать журнал тревог ' + dateString);
          end
         end;
      end;
       lastTableName := dateString;

     itid:=rtitems.GetSimpleID(irtItem);
     if iState<>'Команда' then lastComandItem:=-1;
    with dm2.qAlarms do
    begin
     Sql.Clear;
     if {((lastComandItem=-1) or
           ((itid>-1) and
                (lastComandItem<>itid)))}true then
     begin
    { if iState='Команда' then
       begin
        if itid>-1 then
         if ((rtitems.Items[itid].offMsged) or
                (rtitems.Items[itid].onMsged) or
                    (rtitems.Items[itid].Alarmed) or
                         (rtitems.Items[itid].AlarmedLocal) or
                         (trim(rtitems.GetOnMsg(itid))<>'')) then
                           begin
                             if rtitems.Items[itid].ValReal>0 then
                                 pluscommand:='' else pluscommand:=''
                           end else
                           begin
                              lastComandItem:=itid;
                              lastcomandtime:=now;
                              lastcomandvalue:=rtitems.Items[itid].ValReal;
                              //pluscommand:='( команда изм. '+trim(format('%10.2f',[rtitems.Items[itid].ValReal]))+rtitems.GetEU(itid)+')';
                           end;
       end;    }

     SQL.Add('insert into ' + dateString + '(tm, iname, iparam, ilevel, icomment, istate, ioperator)' +
                                  ' values (:prTime, :iName,:irtItem,:iAlarmLevel,:iComment,' +
                                  ':iState, :iOpr)');



    // Parameters.Parambyname('prTime').value := DateTimeToStr(Time);
     Parameters.Parambyname('iName').DataType := ftString;
     Parameters.Parambyname('irtItem').DataType := ftString;
     Parameters.Parambyname('iComment').DataType := ftString;
     Parameters.Parambyname('iState').DataType := ftString;
     Parameters.Parambyname('iOpr').DataType := ftString;
     Parameters.Parambyname('prtime').DataType:= ftString;
     {Parameters.Parambyname('iName').Size := 50;
     Parameters.Parambyname('irtItem').Size := 50;
     Parameters.Parambyname('iComment').Size := 250;
     Parameters.Parambyname('iState').Size := 50;
     Parameters.Parambyname('iOpr').Size := 50;  }

     Parameters.Parambyname('prTime').value := SelfFormatDateTime(now);
     Parameters.Parambyname('iName').value:= iName;
     Parameters.Parambyname('irtItem').value := irtItem;
     Parameters.Parambyname('iAlarmLevel').value := iAlarmLevel;
     Parameters.Parambyname('iComment').value := iComment +'  ' +pluscommand;
     Parameters.Parambyname('iState').value := iState;
     Parameters.Parambyname('iOpr').value := sOperator;
     try
       ExecSQL;
       except
      //  showMessage (sql.Text);
       // raise;
       end;
     end
     else
     begin
       if (itid>-1) then
        begin
         sql.Clear;
         pluscommand:='(команда изм. '+trim(format('%10.2f', [lastcomandvalue]))+ rtitems.GetEU(itid) +' - '+ trim(format('%10.2f',[rtitems.Items[itid].ValReal])) +rtitems.GetEU(itid) +')';
         icomment:=icomment + '  '+pluscommand;
         SQL.Add('UPDATE ' + dateString + ' SET icomment = :iComment where (tm = ( select max(tm) from ' + dateString +  ' where ((iState=:istate) and (iParam=:iParam))))');
       {  Parameters.Parambyname('iComment').Size := 250;}
         Parameters.Parambyname('iComment').DataType := ftString;
         Parameters.Parambyname('iComment').value := iComment;
         Parameters.Parambyname('iParam').DataType := ftString;
         Parameters.Parambyname('iParam').value := irtItem;
         Parameters.Parambyname('iState').DataType := ftString;
         Parameters.Parambyname('iState').value := istate;
      end;
       try
       ExecSQL;
       except
       // showMessage (sql.Text);
      //  raise;
       end;

     end;

    end; {with}
    except
    end;
if ((lastComandItem>-1) and (SecondsBetween(now,lastcomandtime)>59)) then lastComandItem:=-1;
end;

procedure TAlarmTable.WriteAlarmC (iName, irtItem, iComment, iState: string;iAlarmLevel: integer; comp: string; oper: string );
var
   s,dateString, pluscommand, sOperator: string;
   itid: integer;
begin
      try
     //удаление старого файла, старее 3 месяцев
   //  s:=DatetoFilename(IncMonth(Date, -3));
  //   DeleteFile('..\dbdata\Alarms\'+s+'.DB');

     //получение имени сегодняшнего файла
      sOperator:='';
      begin
        if comp<>'' then
       sOperator:='['+comp+']';
        sOperator:=sOperator+oper;
      end;
     dateString :='al'+ datetoFileName(Date);
     //Showmessage('pred1');
     pluscommand:='';
     if trim(lastTableName) <> trim(dateString) then
     begin
      //  Showmessage('pred2');
        lastComandItem:=-1;
         {Showmessage('pred3');
         if dm2=nil then Showmessage('dm - nil');
         if dm2.Alarms=nil then Showmessage('dm - nil'); }
        if not TableExist(dateString, dm2.Alarms) then
         begin

       //create alarm trend table
          dm2.qAlarms.Sql.Clear;
          dm2.qAlarms.Sql.Add ('CREATE TABLE ' + dateString +
                                      ' (tm DateTime, iName CHAR(50), iPARAM CHAR(50),' +
                                     'iLevel integer, icomment CHAR(250), iState CHAR(50),' +
                                      'iOperator CHAR(50), iSELECTED INTEGER)');
          try
            dm2.qAlarms.ExecSQL;
          except
            raise Exception.Create('Невозможно создать журнал тревог ' + dateString);
          end
         end;
      end;
       lastTableName := dateString;

     itid:=rtitems.GetSimpleID(irtItem);
     if iState<>'Команда' then lastComandItem:=-1;
    with dm2.qAlarms do
    begin
     Sql.Clear;
     if {((lastComandItem=-1) or
           ((itid>-1) and
                (lastComandItem<>itid)))}true then
     begin
    { if iState='Команда' then
       begin
        if itid>-1 then
         if ((rtitems.Items[itid].offMsged) or
                (rtitems.Items[itid].onMsged) or
                    (rtitems.Items[itid].Alarmed) or
                         (rtitems.Items[itid].AlarmedLocal) or
                         (trim(rtitems.GetOnMsg(itid))<>'')) then
                           begin
                             if rtitems.Items[itid].ValReal>0 then
                                 pluscommand:='' else pluscommand:=''
                           end else
                           begin
                              lastComandItem:=itid;
                              lastcomandtime:=now;
                              lastcomandvalue:=rtitems.Items[itid].ValReal;
                              //pluscommand:='( команда изм. '+trim(format('%10.2f',[rtitems.Items[itid].ValReal]))+rtitems.GetEU(itid)+')';
                           end;
       end;    }

     SQL.Add('insert into ' + dateString + '(tm, iname, iparam, ilevel, icomment, istate, ioperator)' +
                                  ' values (:prTime, :iName,:irtItem,:iAlarmLevel,:iComment,' +
                                  ':iState, :iOpr)');



    // Parameters.Parambyname('prTime').value := DateTimeToStr(Time);
     Parameters.Parambyname('iName').DataType := ftString;
     Parameters.Parambyname('irtItem').DataType := ftString;
     Parameters.Parambyname('iComment').DataType := ftString;
     Parameters.Parambyname('iState').DataType := ftString;
     Parameters.Parambyname('iOpr').DataType := ftString;
     Parameters.Parambyname('prtime').DataType:= ftString;
     {Parameters.Parambyname('iName').Size := 50;
     Parameters.Parambyname('irtItem').Size := 50;
     Parameters.Parambyname('iComment').Size := 250;
     Parameters.Parambyname('iState').Size := 50;
     Parameters.Parambyname('iOpr').Size := 50;  }

     Parameters.Parambyname('prTime').value := SelfFormatDateTime(now);
     Parameters.Parambyname('iName').value:= iName;
     Parameters.Parambyname('irtItem').value := irtItem;
     Parameters.Parambyname('iAlarmLevel').value := iAlarmLevel;
     Parameters.Parambyname('iComment').value := iComment +'  ' +pluscommand;
     Parameters.Parambyname('iState').value := iState;
     Parameters.Parambyname('iOpr').value := sOperator;
     try
       ExecSQL;
       except
      //  showMessage (sql.Text);
       // raise;
       end;
     end
     else
     begin
       if (itid>-1) then
        begin
         sql.Clear;
         pluscommand:='(команда изм. '+trim(format('%10.2f', [lastcomandvalue]))+ rtitems.GetEU(itid) +' - '+ trim(format('%10.2f',[rtitems.Items[itid].ValReal])) +rtitems.GetEU(itid) +')';
         icomment:=icomment + '  '+pluscommand;
         SQL.Add('UPDATE ' + dateString + ' SET icomment = :iComment where (tm = ( select max(tm) from ' + dateString +  ' where ((iState=:istate) and (iParam=:iParam))))');
       {  Parameters.Parambyname('iComment').Size := 250;}
         Parameters.Parambyname('iComment').DataType := ftString;
         Parameters.Parambyname('iComment').value := iComment;
         Parameters.Parambyname('iParam').DataType := ftString;
         Parameters.Parambyname('iParam').value := irtItem;
         Parameters.Parambyname('iState').DataType := ftString;
         Parameters.Parambyname('iState').value := istate;
      end;
       try
       ExecSQL;
       except
       // showMessage (sql.Text);
      //  raise;
       end;

     end;

    end; {with}
    except
    end;
if ((lastComandItem>-1) and (SecondsBetween(now,lastcomandtime)>59)) then lastComandItem:=-1;
end;


procedure TAlarmTable.InitOperator(ID: integer);
var i: integer;
begin
  try
   if rtitems<>nil
   then
  // if CSRegistration='' then
  begin
    if not rtitems.oper.getRegist then
    begin
    OperatorName^:='';
    exit;
    end;

  end;

  OperatorName^:='Незарегестрирован';
  if rtitems<>nil then
    begin
      if rtitems.oper.usCur>-1 then OperatorName^:=rtitems.oper.GetNamebyid(rtitems.oper.usCur)
    end;
    except
    end;
//  if id<1 then exit;

{ if TableExist('Operators', dm2.Registration) then
    begin

       with dm2.Regist do
         begin
           Sql.Clear;
           Sql.Add('select * from Operators');

           try
           ExecSQL;

           except
             OperatorName^:='Сбой службы безопасности';
             exit;
           end;
           if not dm2.Regist.Active then dm2.Regist.Open;

           dm2.Regist.First;
           i:=1;

           while ((i<id) and not (EOF)) do
              begin
                Next;
                inc(i);
              end;
           if (i<(Recordcount+1)) then
           OperatorName^:=FieldValues['Operator'];
         end;
   end;
   except
   end;   }
end;

procedure TAlarmTable.DeleteArchive;
var i: integer;
    tn: string;
    decyearval: TdateTime;
    dateString, sqlstr : string;
begin
   // if Assigned(ComObj.CoInitializeEx) then
  //ComObj.CoInitializeEx(nil, COINIT_MULTITHREADED)
 // else
  CoInitialize(nil);
   //coinitialize(nil);
   if deletecircle<1 then exit;
   decyearval:=incday(now,-1*deletecircle*2*30);
   try
      for i:=0 to deletecircle*30 do
       begin
        decyearval:=incday(decyearval);
        dateString := datetoFileName(decyearval);
        try
           Dm2.qAlarms.SQL.Clear;
           Dm2.qAlarms.SQL.Add('drop table [al'+trim(dateString)+']');
           Dm2.qAlarms.ExecSQL;
        except
        end;
        try
           Dm2.tbTrenddef.SQL.Clear;
           Dm2.tbTrenddef.SQL.Add('drop table [tr'+trim(dateString)+']');
           Dm2.tbTrenddef.ExecSQL;
        except
        end;
       end;
   except
   end;
   CoUnInitialize;


end;


initialization
 // CoInitFlags:= COINIT_MULTITHREADED;
  AlarmTable := TAlarmTable.Create;
finalization
 // AlarmTable.free;
end.
