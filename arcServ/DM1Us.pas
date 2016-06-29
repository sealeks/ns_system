unit DM1Us;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ActiveAlarmListU,
  Dialogs,ShellApi,   ShareMem,
  Db, DBTables, constDef, ExtCtrls,  ActiveX,ComObj, DBManagerFactoryU,
  GlobalValue,ConfigurationSys, DateUtils, GroupsU,  MemStructsU, SvcMgr,
   StdCtrls, Menus, ImgList,MainDataModuleU,ReportGroupLocatorU, ReportCntGroupLocatorU;

const
   WM_ICONNOTYFY=WM_USER+1324;
   APP_NAMEARCH='Arch_Serv';
    

type
   pInteger= ^integer;  


type
  TDm1s = class(TForm)

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Timer5: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Timer4: TTimer;
    ImageList1: TImageList;
    Label9: TLabel;
    Label10: TLabel;  // таймер вычисляемой группы
    PugeTimer: TTimer;  // таймер чистки базы срабатывает первый раз и с наступлние суток
    StartHourWriteTimer: TTimer;
    TimerPingConnection_: TTimer;
    procedure PugeTimerTimer(Sender: TObject);
    procedure StartHourWriteTimerTimer(Sender: TObject);

    procedure Dm1Create(Sender: TObject);
    procedure PingOff;
    procedure PingOn;
    procedure ServiceStop;
    procedure ServiceShutdown;
    procedure ServiceStart;
    procedure Timer5Timer(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure setFirstInit(val: boolean);
    procedure TimerPingConnection_Timer(Sender: TObject);

  private
    { Private declarations }
    fDBNoset: boolean;    // менеджер СУБД не задан
    fLastConn: boolean;
    fLastReqTime: TDateTime;
    trayok: boolean;
    firstcall: boolean;
    CountAnalog,CountEvent,CountAnalogPer,CountEventPer: integer;
    fRunSt: boolean;
    BlinkState: boolean;
    NewWndProc, OldWndProc: pointer; //WndProc for application
    prevHour: integer;
    pugeTime: integer;
    ffirstInit: boolean;
    ffirst: boolean;    // флаг для первого соединение, чтобы показать
    // установку соединеия
    reportLocator: TReportGroupLocator;

    reportCntLocator: TReportCntGroupLocator;
//    reportGroupMenager: TSysReportGroupMenager;
    fDBMeneger: TMainDataModule;

    procedure CheckError(E: Exception);

    procedure Log(mess: string; lev: byte = 2);

    procedure WriteChange(id: integer);
    // запись событий с временной пометкой
    procedure WriteLog(id: integer; stop_: boolean = false);
    procedure WriteLog_(id: integer; stop_: boolean = false);
    // запись трендов
    procedure WriteEvent(id: integer; ln: integer);

    // запись событий on/off
    procedure WriteCommand(id: integer; ln: integer);
    // запись команд
    procedure WriteAlarm(id: integer);
    procedure WriteAlarm_(id: integer);
    // запись аварий
    procedure WriteAlarmLocal(id: integer);
    procedure WriteAlarmLocal_(id: integer);
    // запись тревог
    procedure WriteReport(id: integer);
    // запись отчетов
    procedure DeleteArchive(first: boolean);
    // чистка архива
    procedure ForcedWriteLog(stop_: boolean = false);
    // форсированная запись трендов
    procedure ForcedWriteMsg(stop_: boolean = false);
    // форсированная запись сообщений

    function  getDBMeneger: TMainDataModule;
    // менежер БД

    procedure Init;
    procedure Uninit;

    procedure SeticonSt;
    function  getRunSt: boolean;
    procedure setRunSt(val: boolean);


    

  public
    { Public declarations }
  //  ActiveAlarms : TA;
  //  Alarms : TAlarms;
    activeAlarmList: TActiveAlarmList;
    Myserv: TService;

    FNID: TNotifyIconData;
    property   DBMeneger: TMainDataModule read getDBMeneger;
    property   RunSt: boolean read getRunSt write SetRunSt;
    property   FirstInit:  boolean read ffirstInit write setfirstInit;
    procedure MsgTestWndProc(var Msg: TMessage);
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
    procedure WMClose(var messag: TMsg); message WM_Close;
    procedure WMEterClose(var messag: TMsg);
  //  destructor Destroy; override;
  end;

var
  Dm1: TDm1s;
  cif: ^_STARTUPINFOA;
  pip: PROCESS_INFORMATION;
  serv: integer;
  CoInitializeExProc: function (pvReserved: Pointer;
                                coInit: Longint): HResult; stdcall;

  stCount: integer;
  ttrdef: TTrenddefList;

implementation

uses uMyTimer;

{$R *.DFM}

procedure TDm1s.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin

    if messag.wParam=WM_RBUTTONDOWN then
      begin
        if Showing then popupmenu1.Items[0].Enabled:=false else popupmenu1.Items[0].Enabled:=true;
            getCursorPos(pt);
        popupmenu1.Popup(pt.X,pt.y);
      end;
end;

procedure  TDm1s.WMEterClose(var messag: TMsg);
begin
 messag.message:=0;
 Hide;
end;

procedure TDm1s.WMClose(var messag: TMsg);
begin
messag.message:=0;
Hide;
end;


procedure ServiceController(CtrlCode: DWord); stdcall;
  begin
     // dm1.Controller(CtrlCode);
  end;

procedure TDm1s.Init;
var i: integer;
begin
firstcall:=true;
pugeTime:=-1;
prevHour:=-1;
serv:=0;
stCount:=0;
CountAnalog:=0;
CountEvent:=0;
CountAnalogPer:=0;
CountEventPer:=0;
InitialSys;
rtItems := TAnalogMems.Create(Pathmem);
 for i := 0 to rtItems.Count - 1 do
    if rtItems[i].logged then
       rtItems[i].LogCode := rtItems.items[i].ID;
fLastReqTime:=0;
fDBNoset:=false;         //  предполагаем, что менеджер задан
ffirst:=true;            // сервис только инициализируется
fLastConn:=true;         // полпгаем что соединение было
rtItems.RegHandle('DBService', forms.application.handle, [IMMIall]);
rtItems.SetAppName(APP_NAMEARCH);

//Alarms := TAlarms.Create;
//ActiveAlarms := TactiveAlarms.Create();
activeAlarmList:=TActiveAlarmList.Create(rtItems,'NS_AlarmActive_map');
activeAlarmList.SetDM(DBMeneger);
reportLocator:=TReportGroupLocator.Create(Pathmem,dbmanager,connectionstr);
if reportLocator.Count>0 then
reportLocator.Resume
else
try
 reportLocator.Free;
 reportLocator:=nil;
except
end;

reportCntLocator:=TReportCntGroupLocator.Create(Pathmem,dbmanager,connectionstr);
if reportCntLocator.Count>0 then
reportCntLocator.Resume
else
try
 reportCntLocator.Free;
 reportCntLocator:=nil;
except
end;


pugeTime:=-1;
prevHour:=-1;
ServiceStart;
end;

procedure TDm1s.Uninit;
begin
ServiceStop;
rtItems.UnRegHandle(forms.application.handle);
activeAlarmList.Free;
//Alarms.Free;
if fDBMeneger<>nil then
 begin
   try
    fDBMeneger.Free;
    fDBMeneger:=nil;
   except
    fDBMeneger:=nil;
   end;
 end;
 if reportLocator<>nil then
 begin
reportLocator.Terminate;
reportLocator.WaitFor;
end;
 if reportCntLocator<>nil then
 begin
reportCntLocator.Terminate;
reportCntLocator.WaitFor;
end;
rtItems.Free;

end;

procedure TDm1s.ServiceStart;
var i,j: integer;
    f: Pchar;
    secString: string;
begin
  try
  for i := 0 to rtItems.Count - 1 do
  begin
    if rtItems[i].AlarmedLocal then rtItems.IncCounter(i);
    if rtItems[i].OnMsged then rtItems.IncCounter(i);
    if rtItems[i].OffMsged then rtItems.IncCounter(i);
    if (round(rtItems[i].logTime)=EVENT_TYPE_ALARM) then rtItems.IncCounter(i);
    if rtItems[i].logged then
    begin
      rtItems.incCounter(i);
      rtItems[i].LogCode := rtItems.items[i].ID;
               { GetLogCode(rtItems.GetName(i))};
    end;
  end;

 

  StartHourWriteTimer.Enabled := true;
  if rtitems.GetsimpleID('rOperator')>-1 then
           begin
             try
            //  AlarmTable.InitOperator(round(rtItems[rtitems.GetSimpleID('rOperator')].ValReal));
             except
             end;
           end;
  if rtitems.GetSimpleID('ArcStart')>-1 then
     rtitems.SetValForce(rtitems.GetSimpleID('$ArcStart') , 1, 100);
  finally
  PugeTimer.Enabled:=true;
  StartHourWriteTimer.Enabled:=true;
  end;


end;

procedure TDm1s.setFirstInit(val: boolean);
begin
   if (val<>ffirstinit) then
    begin
      ffirstinit:=val;
      if val then
        begin
          ForcedWriteLog();
          ForcedWriteMsg();
        end;
    end;
end;

procedure TDm1s.ServiceStop;
var i,j: integer;
begin
     StartHourWriteTimer.Enabled:=false;
     PugeTimer.Enabled:=false;
      try
     CountAnalog:=0;
     CountEvent:=0;
     CountAnalogPer:=0;
     CountEventPer:=0;
     DeleteArchive(false);
     ForcedWriteLog(true);
     prevHour:=-1;
   // if serv>31 then TerminateProcess(serv,0);
    if rtitems.GetSimpleID('ArcStart')>-1
      then
      begin
       rtitems.SetVal(rtitems.GetSimpleID('ArcStart') , 0,100);
       rtitems.ValidOff(rtitems.GetSimpleID('ArcStart'));
      end;
    if rtitems.GetSimpleID('ActivArc')>-1 then
       
      begin
       rtitems.SetVal(rtitems.GetSimpleID('ActivArc') , 0,100);
       rtitems.ValidOff(rtitems.GetSimpleID('ActivArc'));
      end;

   sendMessage(forms.application.handle, WM_IMMISaveArchive, -1, -1);

   for i := 0 to rtItems.Count - 1 do
   begin
      if rtItems[i].AlarmedLocal then rtItems.DecCounter(i);
      if rtItems[i].logged then rtItems.DecCounter(i);
      if rtItems[i].OnMsged then rtItems.DecCounter(i);
      if rtItems[i].OffMsged then rtItems.DecCounter(i);
  end;

     finally
      SetWindowLong(forms.application.handle, gwl_WndProc, LongInt(OldWndProc));
     FreeObjectInstance(NewWndProc);
     end;
end;



function TDm1s.getDBMeneger: TMainDataModule;

begin
   if fDBNoset then     // не установлен менеджер данных
     begin
       result:=nil;
       exit;
     end;
   if fDBMeneger=nil then
      begin
      fDBMeneger:=TDBManagerFactory.
      buildManager(dbmanager,connectionstr,dbaAll,false,'ARcServ');
      if fDBMeneger=nil then
       begin
        result:=nil;
        Log('Менеджер данных не установлен! Архивирование невозможно!',_DEBUG_ERROR);
        fDBNoset:=true;   // не задан можно и не соваться сюда
        exit;
        PingOff;
       end;
      end;

   if (((not fDBMeneger.Conneted)) and (SecondsBetween(now,fLastReqTime)>30)) then
   //  нет соединения
     try
       fDBMeneger.Connect;
     except

         fLastReqTime:=now;    // метка времени последнего обращения
         if fLastConn then     // соединение УТРАЧЕНО
         begin
         activeAlarmList.SetDM(nil);

          PingOn;

         SetWindowLong(forms.application.handle, gwl_WndProc, LongInt(OldWndProc));
           FreeObjectInstance(NewWndProc);

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
       fLastConn:=true; //
       ffirst:=false;
       activeAlarmList.SetDM(fDBMeneger);
       firstInit:=true;

       PingOff;

       NewWndProc := MakeObjectInstance (MsgTestWndProc);
       OldWndProc := Pointer(SetWindowLong(
       forms.application.handle, gwl_WndProc, LongInt(NewWndProc)));

       //test

        ttrdef:=nil;
        ttrdef:=fDBMeneger.regTrdef();
        fDBMeneger.StartUtilite;

       Log('Соединение с источником данных успешно установленою', _DEBUG_MESSAGE);
     end;
   end
   else
   begin
   result:=nil;
   prevHour:=-1;
   end;
end;

procedure TDm1s.CheckError(E: Exception);
begin
     try
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


      if (E is LostConnectionError) then
         begin
            fLastConn:=true;
            ffirstInit:=false;
            self.Log('Соединение с хранилищем данных данных прервано. Архивирование остановлено!',_DEBUG_ERROR);
            activeAlarmList.SetDM(nil);
            try
            if fDBMeneger<> nil then
              try
               fDBMeneger.Free;
               fDBMeneger:=nil;
              // ActiveAlarms.SetDM(nil);
              except
               fDBMeneger:=nil;
              end;
            except
            end;
         end else
         begin
            self.Log('Возникновение ошибки в обработчике сообщений MsgTestWndProc! Err: '+E.Message,_DEBUG_ERROR);
         end;
         except
         end;
end;



function TDm1s.getRunSt: boolean;
begin
  result:=fRunSt;
end;


procedure TDm1s.setRunSt(val: boolean);
begin
 if val<>fRunSt then
 begin
 if val then
  begin
    Init;
  end
 else
  begin
    Uninit;
  end;
 end;
 fRunSt:=val;
 ButtonStart.Enabled:=false;
 ButtonStop.Enabled:=true;
 PopupMenu1.Items[1].visible:=not fRunSt;
 PopupMenu1.Items[2].visible:=frunst;
 //seticonSt;
end;



procedure TDm1s.MsgTestWndProc(var Msg: TMessage);
 begin
  if DBMeneger=nil then exit;
  try
  try
  case Msg.Msg of

    WM_IMMIFirstUpd:
      begin

   {     isInit := true;
      //  alarms.UpdateValue(rtItems, activeAlarms);
        for i := 0 to rtItems.Count - 1 do
        begin
          if rtItems[i].id>-1 then
          begin
          rtItems[i].isAlarmOn := false;
          rtItems[i].isAlarmOnServ := false;
          if rtItems[i].AlarmedLocal then
            postMessage (forms.application.handle, WM_IMMIAlarmLocal, -1, rtItems[i].ID);
          end;
        end;   }

      end;

    WM_IMMIChange:
     begin
       inc(CountEvent);
       inc(CountEventPer);
       WriteChange(msg.LParam);
     end;
    WM_IMMILog:
      begin
        inc(CountAnalog);
        inc(CountAnalogPer);
        writeLog(msg.LParam);
      end;
    WM_IMMIEvent:
      begin
        inc(CountEvent);
        inc(CountEventPer);
        writeEvent(msg.LParam,msg.WParam);
      end;

    WM_IMMIAlarm:

      begin
        inc(CountEvent);
        inc(CountEventPer);
        writeAlarm(msg.LParam);

     //   alarms.UpdateValue(rtItems, activeAlarms);
     end;
    WM_IMMIAlarmLocal:
        begin
          inc(CountEvent);
          inc(CountEventPer);
          WriteAlarmLocal(msg.LParam);
        end;

    WM_IMMICommand:

       begin
        inc(CountEvent);
        inc(CountEventPer);
        writeCommand(msg.LParam,msg.WParam);

      end;
  end

  except
    on E: Exception do
    if E<>nil then
    CheckError(E) else
     self.Log('Возникновение ошибки в секции обработки исключений MsgTestWndProc! ПУСТОЕ ИСКЛЮЧЕНИЕ ',_DEBUG_ERROR);

  end;
  except
       self.Log('Возникновение ошибки в секции обработки исключений MsgTestWndProc! НЕ ОБРАБОТАНО ',_DEBUG_ERROR);
   //     Msg.Result := CallWindowProc(OldWndProc,
 //   forms.application.handle, Msg.Msg, Msg.WParam, Msg.LParam);
    end;
  end;




procedure TDm1s.Dm1Create(Sender: TObject);
var
  i,j: integer;
  iconl: TIcon;
    Ole32Handle: HModule;
begin
   isMultiThread:=true;
   fDBMeneger:=nil;
   fRunSt:=false;
   trayok:=false;
   ffirst:=true;
   fLastReqTime:=0;
   CoInitialize(nil);
   FNID.Wnd:=handle;
   FNID.uCallbackMessage:=WM_ICONNOTYFY;
   FNID.szTip:='NS_Arch_Service';
   FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;
   sleep(15000);
   seticonSt;
   runSt:=true;
   ffirstInit:=false;
  // NewWndProc := MakeObjectInstance (MsgTestWndProc);
  /// OldWndProc := Pointer(SetWindowLong(
  // forms.application.handle, gwl_WndProc, LongInt(NewWndProc)));
end;


procedure TDm1s.StartHourWriteTimerTimer(Sender: TObject);
var
   i,j: integer;
   secString, actString: string;
   laststAct,lastactt: boolean;
begin
  if not firstinit then exit;
  if houroftheday(now) <> prevHour then
    begin
    prevhour := houroftheday(now);
    ForcedWriteLog;
    end;
  if DBMeneger=nil then exit;
  DBMeneger.DayUtilite;
end;

procedure TDm1s.WriteChange(id: integer);
var alarngrNum,VL,AL,TYPE_: integer;
    alarmgrName: string;
    itemname, onmsg: string;
begin
 if DBMeneger=nil then exit;
 if id<0 then exit;
 if rtItems.Count<=id then exit;
 if rtItems[id].ID<0 then exit;
  TYPE_ :=rtItems[id].logTime;
 if ((TYPE_ in REPORT_SET)) then
     begin
        WriteReport(id);
        exit;
     end;

 if rtItems[id].logTime<>EVENT_TYPE_WITHTIME then exit;
 alarngrNum:=rtitems.Items[id].AlarmGroup;
 alarmgrName:='';
 if alarngrNum>-1 then alarmgrName:=rtItems.AlarmGroups.ItemNameByNum[alarngrNum];
 VL:=rtitems[id].ValidLevel;
 AL:=rtItems.Items[id].AlarmLevel;
 itemname:=rtItems.GetName(id);
 onmsg:=rtItems.GetOnMsg(id);
 if VL>0 then
    DBMeneger.WriteAlarm(id, alarmgrName, itemname,
                      '* ' +onmsg,
                     ejEvent, AL,'' , '' ,rtItems.Items[id].LogPrevVal)
 else
    DBMeneger.WriteAlarm(id, alarmgrName , itemname,
                     '* ' +'[-> '+FormatDateTime('ss.zzz',rtItems.Items[id].LogPrevVal)+']'+onmsg,
                     ejEvent, AL, '', '' , incminute(now,-1));
end;


procedure TDm1s.WriteLog(id: integer; stop_: boolean = false);
var alarngrNum, VL, AL, logC: integer;
    itemname: string;
    val: single;
begin
 if DBMeneger=nil then exit;
 if id<0 then exit;
 if rtItems.Count<=id then exit;
 if rtItems[id].ID<0 then exit;
 VL:=rtitems[id].ValidLevel;
 val:=rtItems[id].ValReal;
 itemname:=rtItems.GetName(id);
 logC:=rtItems[id].LogCode;
 if not stop_ then
 DBMeneger.WriteLog(itemname,val,now,VL>VALID_LEVEL)
 else
 DBMeneger.WriteLog(itemname,val,now,false)
end;

procedure TDm1s.WriteLog_(id: integer; stop_: boolean = false);
var alarngrNum, VL, AL, logC: integer;
    itemname: string;
    val: single;
begin
 if fDBMeneger=nil then exit;
 if id<0 then exit;
 if rtItems.Count<=id then exit;
 if rtItems[id].ID<0 then exit;
 VL:=rtitems[id].ValidLevel;
 val:=rtItems[id].ValReal;
 itemname:=rtItems.GetName(id);
 logC:=rtItems[id].LogCode;
 if not stop_ then
 fDBMeneger.WriteLog(itemname,val,now,VL>VALID_LEVEL)
 else
 fDBMeneger.WriteLog(itemname,val,now,false)
end;



procedure TDm1s.WriteEvent(id: integer; ln: integer);
var alarngrNum,VL,AL: integer;
    alarmgrName: string;
    itemname, onmsg, offmsg: string;
    val,comandval: real;
    off_, on_: boolean;
begin
   if DBMeneger=nil then exit;
   if id<0 then exit;
   if rtItems.Count<=id then exit;
   if rtItems[id].ID<0 then exit;
   VL:=rtitems[id].ValidLevel;
   if VL<=VALID_LEVEL then exit;
   alarngrNum:=rtitems.Items[id].AlarmGroup;
   alarmgrName:='';
   if alarngrNum>-1 then
     alarmgrName:=rtItems.AlarmGroups.ItemNameByNum[alarngrNum];
   AL:=rtItems.Items[id].AlarmLevel;
   itemname:=rtItems.GetName(id);
   onmsg:=rtItems.GetOnMsg(id);
   offmsg:=rtItems.GetOffMsg(id);
   val:=rtItems[id].ValReal;
   off_:=rtItems[id].OffMsged;
   on_:=rtItems[id].OnMsged;

   if (val = 0) and (off_) then
                  if ln <> -1 then
                     DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                    { format(}offmsg,
                     {[val,rtItems.Command[ln].ValReal]), }        // убрано 20.10.2009
                     ejOff, 20, '' , '' , now)
                  else
                      DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                      offmsg,ejOff, 20,  '' , '' , now)
            else
                if (val <> 0) and (on_) then
                     if ln <> -1 then
                         DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                           {format(}onmsg,
                           {[val,rtItems.Command[ln].ValReal]),}      // убрано 20.10.2009
                          ejOn, 20, '' , '' , now)
                     else
                         DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         onmsg,EjOn, 20,  '' , '' , now)

end;

procedure TDm1s.WriteAlarm(id: integer);
var alarngrNum,VL,AL,TYPE_: integer;
    alarmgrName: string;
    itemname, comt: string;
    val,comandval: single;
    off_, on_: boolean;
    lastevval, tempstr, eu: string;
begin
   if DBMeneger=nil then exit;
   if id<0 then exit;
   if rtItems.Count<=id then exit;
   if rtItems[id].ID<0 then exit;
   VL:=rtitems[id].ValidLevel;
   TYPE_ :=rtItems[id].logTime;

   alarngrNum:=rtitems.Items[id].AlarmGroup;
   alarmgrName:='';
   if alarngrNum>-1 then
     alarmgrName:=rtItems.AlarmGroups.ItemNameByNum[alarngrNum];
   AL:=rtItems.Items[id].AlarmLevel;
   itemname:=rtItems.GetName(id);
   val:=rtItems[id].ValReal;
   comt:=rtItems.GetComment(id);
   eu:=rtItems.GetEU(id);
   TYPE_ :=rtItems[id].logTime;

   case TYPE_  of
       EVENT_TYPE_ALARM:
          begin
             if VL>VALID_LEVEL then
             lastevval:='' else lastevval:='???';
             tempstr:='[__> зн. при соб.]-> ' +comt+' ='+lastevval+
             format('%4.2f',[rtItems[id].ValReal])+eu;
             DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         tempstr,ejEvent, 20,  '' , '' , now)

          end;


       EVENT_TYPE_OSC:
        begin



        end;
     end;
end;

procedure TDm1s.WriteAlarm_(id: integer);
var alarngrNum,VL,AL,TYPE_: integer;
    alarmgrName: string;
    itemname, comt: string;
    val,comandval: single;
    off_, on_: boolean;
    lastevval, tempstr, eu: string;
begin
   if fDBMeneger=nil then exit;
   if id<0 then exit;
   if rtItems.Count<=id then exit;
   if rtItems[id].ID<0 then exit;
   VL:=rtitems[id].ValidLevel;
   TYPE_ :=rtItems[id].logTime;

   alarngrNum:=rtitems.Items[id].AlarmGroup;
   alarmgrName:='';
   if alarngrNum>-1 then
     alarmgrName:=rtItems.AlarmGroups.ItemNameByNum[alarngrNum];
   AL:=rtItems.Items[id].AlarmLevel;
   itemname:=rtItems.GetName(id);
   val:=rtItems[id].ValReal;
   comt:=rtItems.GetComment(id);
   eu:=rtItems.GetEU(id);
   TYPE_ :=rtItems[id].logTime;

   case TYPE_  of
       EVENT_TYPE_ALARM:
          begin
             if VL>VALID_LEVEL then
             lastevval:='' else lastevval:='???';
             tempstr:='[__> зн. при соб.]-> ' +comt+' ='+lastevval+
             format('%4.2f',[rtItems[id].ValReal])+eu;
             fDBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         tempstr,ejEvent, 20,  '' , '' , now)

          end;


       EVENT_TYPE_OSC:
        begin



        end;
     end;
end;

procedure TDm1s.WriteCommand(id: integer;  ln: integer);
var alarngrNum,VL,AL, TYPE_: integer;
    alarmgrName: string;
    itemname,oprc,compc, comt : string;
    val,comandval, comandperval: real;

begin
   if DBMeneger=nil then exit;
   if id<0 then exit;
   if rtItems.Count<=id then exit;
   if rtItems[id].ID<0 then exit;
   VL:=rtitems[id].ValidLevel;
   TYPE_ :=rtItems[id].logTime;
   alarngrNum:=rtitems.Items[id].AlarmGroup;
   alarmgrName:='';
   if alarngrNum>-1 then
     alarmgrName:=rtItems.AlarmGroups.ItemNameByNum[alarngrNum];
   val:=rtItems[id].ValReal;
   itemname:=rtItems.GetName(id);
   comt:=rtItems.GetComment(id);
   case TYPE_ of
       EVENT_TYPE_WITHTIME: begin end;
       else
        begin
       { if pos('$',rtItems.GetName(msg.LParam))=1 then exit; }
        if ln <> -1 then
         begin
            oprc:=rtItems.command.Items[ln].UserName;
            compc:=rtItems.command.Items[ln].CompName;
            comandval:=rtItems.Command[ln].Valreal;
            comandperval:=rtItems.Command[ln].prevVal;
            if (TYPE_=TYPE_DISCRET) then
            begin
            if comandval=1 then
              DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         comt+ ' вкл',ejCommand, 10,  compc , oprc , now)

            else
              DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         comt+ ' выкл',ejCommand, 10,  compc , oprc , now)
            end else
             DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         comt+' изм. ['+  format('%8.2f',[comandperval])+'->'+format('%8.2f',[comandval])+']'
                         ,ejCommand, 10,  compc , oprc , now);


        end
        else
           DBMeneger.WriteAlarm (id, alarmgrName , itemname,
                         comt
                         ,ejCommand, 10,  compc , oprc , now);


        if (uppercase(trim(itemname))='RKVIT') or (pos('_RKVIT',uppercase(trim(itemname)))>1) and (ln <> -1) then
           begin
            if (uppercase(trim(itemname))='RKVIT') then
            begin
             activeAlarmList.KvitAll;
             //Alarms.Kvit;
            end else
             begin          // добавить квитирование групп
           //  ActiveAlarms.Kvit(itemname);
           //  Alarms.Kvit(itemname);
            end
           end;
        if (uppercase(trim(itemname))=uppercase('rOperator')) then
           begin
             try
         //    AlarmTable.InitOperator(round(rtItems[msg.LParam].ValReal));
             except
             end;
           end;
         end;
         end;
end;

procedure TDm1s.WriteReport(id: integer);
 var alarngrNum,VL,AL, TYPE_: integer;
     val, alconst: real;
     isAlarm, isAlarmPre : boolean;
     itemname: string;
     tim: TDateTime;
begin
     if DBMeneger=nil then exit;
     if id<0 then exit;
     if rtItems.Count<=id then exit;
     if rtItems[id].ID<0 then exit;
     TYPE_ :=rtItems[id].logTime;
     val:=rtItems[id].ValReal;
     tim:=rtitems[id].TimeStamp;
     VL:=rtitems[id].ValidLevel;
     rtitems[id].ValidLevel:=REPORT_WRITED;
    // exit;
     itemname:=rtItems.GetName(id);
     if (not (TYPE_ in REPORT_SET)) then  exit;
         if VL=REPORT_WRITE then
         begin
           try
            DBMeneger.WriteReport(itemname,TYPE_,val,tim);
            Log('Служба архивирования записала данные для tg:='+itemname+' vl='+floattostr(val)+' tm='+
            formatdatetime('yyyy-mm-dd hh:nn:ss.zzz',tim));
            rtitems[id].ValidLevel:=REPORT_WRITED;
           except
            on E: exception do
              begin
               rtitems[id].ValidLevel:=REPORT_NOWRITED;
               raise E;
              end;

           end;
         end;
end;



procedure TDm1s.WriteAlarmLocal(id: integer);
 var alarngrNum,VL,AL, TYPE_: integer;
     val, alconst: real;
     isAlarm, isAlarmPre : boolean;
     itemname: string;
begin
     if DBMeneger=nil then exit;
     if id<0 then exit;
     if rtItems.Count<=id then exit;
     if rtItems[id].ID<0 then exit;
     TYPE_ :=rtItems[id].logTime;
     if TYPE_=EVENT_TYPE_WITHTIME then exit;
     isAlarm := false;
     val:=rtItems[id].ValReal;
     alconst:=rtItems[id].alarmConst;
     itemname:=rtItems.GetName(id);
     case rtItems[id].alarmCase of
            alarmMore:
                if val > alconst then
                       isAlarm := true;
            alarmLess: if val < alconst then
                       isAlarm := true;
            alarmEqual: if val = alconst then
                       isAlarm := true;
        end;
        if isAlarm and not rtItems[id].isAlarmOnServ then
          begin
             rtItems[id].isAlarmOnServ := true;
             activeAlarmList.AddItem(now,id);
          end;
        if not isAlarm and rtItems[id].isAlarmOnServ then
          begin
             rtItems[id].isAlarmOnServ := false;
             activeAlarmList.SetOff(id);
          end;

end;

procedure TDm1s.WriteAlarmLocal_(id: integer);
 var alarngrNum,VL,AL, TYPE_: integer;
     val, alconst: real;
     isAlarm, isAlarmPre : boolean;
     itemname: string;
begin
     if fDBMeneger=nil then exit;
     if id<0 then exit;
     if rtItems.Count<=id then exit;
     if rtItems[id].ID<0 then exit;
     TYPE_ :=rtItems[id].logTime;
     if TYPE_=EVENT_TYPE_WITHTIME then exit;
     isAlarm := false;
     val:=rtItems[id].ValReal;
     alconst:=rtItems[id].alarmConst;
     itemname:=rtItems.GetName(id);
     case rtItems[id].alarmCase of
            alarmMore:
                if val > alconst then
                       isAlarm := true;
            alarmLess: if val < alconst then
                       isAlarm := true;
            alarmEqual: if val = alconst then
                       isAlarm := true;
        end;
        if isAlarm and not rtItems[id].isAlarmOnServ then
          begin
             rtItems[id].isAlarmOnServ := true;
             activeAlarmList.AddItem(now,id);
          end;
        if not isAlarm and rtItems[id].isAlarmOnServ then
          begin
             rtItems[id].isAlarmOnServ := false;
             activeAlarmList.SetOff(id);
          end;

end;


procedure TDm1s.ForcedWriteMsg(stop_: boolean = false);
var i: integer;
begin

  try
  if fDBMeneger=nil then exit;
   for i := 0 to rtItems.Count - 1 do
    begin
     if (rtItems[i].ID>-1) and (rtItems.isValid(i)) then
     begin
      if (rtItems[i].Alarmed)
        then
        begin
          self.WriteAlarm_(i);
        end;
        if (rtItems[i].AlarmedLocal)
        then
        begin
          self.WriteAlarmLocal_(i);
        end;
       end;
    end;
    except
     // on  E: Exception do CheckError(E);
     // Log('Не удалось записать реперные данные! err: dm2s.ForcedWriteLog '+ E.Message,_DEBUG_ERROR);
    end;

end;

procedure TDm1s.ForcedWriteLog(stop_: boolean = false);
var i: integer;
begin

  try
  if fDBMeneger=nil then exit;
  for i := 0 to rtItems.Count - 1 do
    begin
      if rtItems[i].logged then
        begin
          if not stop_ then
          WriteLog_(i)
          else
          WriteLog_(i,true)
        end;
    end;
    except
      //on  E: Exception do CheckError(E);
     // Log('Не удалось записать реперные данные! err: dm2s.ForcedWriteLog '+ E.Message,_DEBUG_ERROR);
    end;
end;



procedure TDm1s.DeleteArchive(first: boolean);
begin
    if DBMeneger=nil then exit;
    try
    DBMeneger.ClearArchive(deletecircle, first);
    except
      on E: Exception do CheckError(E);
   //  Log('Не удалось очистить архив! err: dm2s.DeleteArchive '+ E.Message,_DEBUG_ERROR);
    end;
end;


procedure TDm1s.ServiceShutdown;
var j: boolean;
begin
  RunSt:=false;
end;

procedure TDm1s.Timer5Timer(Sender: TObject);
begin
try

if Showing then
 begin
    label5.Caption:=inttostr(countEvent);
    label6.Caption:=inttostr(countEventPer*10);
    label7.Caption:=inttostr(countAnalog);
    label8.Caption:=inttostr(countAnalogPer*10);
 end;
CountAnalogPer:=0;
CountEventPer:=0;
finally

end;
end;

procedure TDm1s.ButtonStartClick(Sender: TObject);
begin
   RunSt:=true;
end;

procedure TDm1s.ButtonStopClick(Sender: TObject);
begin
   RunSt:=false;
end;

procedure TDm1s.N1Click(Sender: TObject);
begin
 Show;
end;

procedure TDm1s.N5Click(Sender: TObject);
begin
   RunSt:=false;
   Shell_NotifyIcon(NIM_DELETE,@FNID);
   Close;
 //
end;

procedure TDm1s.seticonSt;
var test: longbool;
begin
if runst then  FNID.hIcon:=self.Image3.picture.Icon.Handle
else  FNID.hIcon:=self.Image1.picture.Icon.Handle;
     try
     if not trayOk then
        begin
         test:=Shell_NotifyIcon(NIM_ADD,@FNID);
         if test then trayOk:=true;
        end
     else
     Shell_NotifyIcon(NIM_MODIFY,@FNID);
     except
     end;

end;

procedure TDm1s.Timer4Timer(Sender: TObject);
begin
   seticonSt;
   timer4.Enabled:=not trayOk;
end;

procedure TDm1s.PugeTimerTimer(Sender: TObject);
begin
if DBMeneger=nil then exit;
 if PugeTime<>DayofTheMonth(now) then
   begin
     DeleteArchive(firstcall);
     firstcall:=false;
     PugeTime:=DayofTheMonth(now);
     DBMeneger.DayUtilite;
   end;

end;


procedure TDm1s.Log(mess: string; lev: byte = 2);
begin
    if rtitems<>nil then
        rtitems.Log(mess,lev);
end;


procedure TDm1s.FormDestroy(Sender: TObject);
begin
  PingOff;
  forms.Application.Terminate;
// SetWindowLong(forms.application.handle, gwl_WndProc, LongInt(OldWndProc));
  //   FreeObjectInstance(NewWndProc);
 //CoUnInitialize;

end;

procedure TDm1s.TimerPingConnection_Timer(Sender: TObject);
begin
DBMeneger;
end;

procedure TDm1s.PingOn;
begin
TimerPingConnection_.Enabled:=false;
TimerPingConnection_.Enabled:=true;
end;

procedure TDm1s.PingOff;
begin
TimerPingConnection_.Enabled:=false;
end;

initialization







end.
