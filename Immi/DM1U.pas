unit DM1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, constDef, ExtCtrls, {globalVar , alarmU, AlarmTblU,   }
   GlobalValue, DateUtils, GroupsU, CalcTegsU, PointerTegsU;

type
   pInteger= ^integer;

type
  TDm1 = class(TDataModule)
    Timer1: TTimer;
    BlinkTimer: TTimer;
    Timer2: TTimer;
    procedure Dm1Create(Sender: TObject);
    procedure Dm1Destroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BlinkTimerTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    BlinkState: boolean;
    NewWndProc, OldWndProc: pointer; //WndProc for application
    isInit: boolean;
    prevDate: TDateTime;
    CalcGroupNum: integer;
    TagGroupList: TStringList;

  public
    appForm: TForm;
    { Public declarations }
    procedure MsgTestWndProc(var Msg: TMessage);
  end;

var
  Dm1: TDm1;
//  archives: tArchives;


implementation

uses  fLoadU, uMyTimer, MemStructsU;

{$R *.DFM}

procedure TDm1.MsgTestWndProc(var Msg: TMessage);
var
   isAlarm : boolean;
   i: longInt;

begin
  try
  if isInit or (Msg.Msg = WM_IMMIFirstUpd) then
  case Msg.Msg of
    WM_IMMISaveArchive: //при смене даты
                      // только если есть связь   //добавлено CA 14.4
      begin                             //добавлено CA 14.4
      end;
    WM_IMMIFirstUpd:
      begin

        isInit := true;
        for i := 0 to rtItems.activeAlarms.Count-1 do
          if not rtItems.activeAlarms.Items[i].isKvit then AlarmSound(true);

     //   alarms.UpdateValue(rtItems, activeAlarms);
        for i := 0 to rtItems.Count - 1 do
        begin
       //   rtItems[i].isAlarmOn := false;
        //  if rtItems[i].AlarmedLocal then
         //   postMessage (Application.Handle, WM_IMMIAlarmLocal, -1, rtItems[i].ID);
        end;

      end;
    WM_IMMIChange:
      begin
       if msg.LParam<0 then exit;
       if rtItems[msg.LParam].id<0 then exit;
       if rtItems[msg.LParam].logTime=EVENT_TYPE_WITHTIME then
         begin
           //if TDateTime(rtItems[msg.LParam].LogPrevVal)>Now then
            //activeAlarms.ActiveImEvents.AddEv(msg.LParam,now,rtItems[msg.LParam].AlarmLevel) else
           //  activeAlarms.ActiveImEvents.AddEv(msg.LParam,TDateTime(rtItems[msg.LParam].LogPrevVal),rtItems[msg.LParam].AlarmLevel);
         end;
      end;

 //   WM_IMMILog:
     //      if isActivate^ then               // только если есть связь   //добавлено CA 14.4
      //     begin
      //    if rtItems[msg.LParam].logged then
         //   if abs(rtItems[msg.LParam].LogPrevVal - rtItems[msg.LParam].ValReal) > rtItems[msg.LParam].LogDB then
         //   begin
          //    writeLog(rtItems[msg.LParam].LogCode, rtItems[msg.LParam].ValReal);
           //   rtItems[msg.LParam].LogPrevVal := rtItems[msg.LParam].ValReal;

       //     end;
         //   end;
  WM_IMMIEvent:
  begin
    {  if (rtItems.GetName(rtItems[msg.LParam].ID)='rKvit') and (rtItems[msg.LParam].ValReal <> 0) and (rtItems[msg.LParam].OnMsged) then
        begin
           if Screen.Forms[i].visible then
          SendMessage(Screen.Forms[i].Handle, WM_IMMIKvit  , 0, 0);
        end;   }
  end;

     { if (rtItems[msg.LParam].ValReal = 0) and (rtItems[msg.LParam].OffMsged) then
        if msg.WParam <> -1 then
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
            format(rtItems.GetOffMsg(msg.LParam),
              [rtItems.Command[msg.wParam].PrevVal,rtItems.Command[msg.wParam].ValReal]),
             'Выключение', 20)
        else
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
            rtItems.GetOffMsg(msg.LParam),'Выключение', 20)
      else
      if (rtItems[msg.LParam].ValReal <> 0) and (rtItems[msg.LParam].OnMsged) then
        if msg.WParam <> -1 then
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
            format(rtItems.GetOnMsg(msg.LParam),
              [rtItems.Command[msg.wParam].PrevVal,rtItems.Command[msg.wParam].ValReal]),
             'Включение', 20)
        else
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
            rtItems.GetOnMsg(msg.LParam), 'Включение', 20);  }
     WM_IMMIKEYSET:
      begin
       SendMessageBroadcast(WM_IMMIKEYSET,msg.WParam,msg.LParam);
       if msg.lparam=27 then SendMessageBroadcast(WM_IMMICLOSEALL,msg.WParam,msg.LParam);
      end;

    {WM_IMMIAlarm:
      begin
       if msg.LParam<0 then exit;
       if rtItems[msg.LParam].id<0 then exit;
       if rtItems[msg.LParam].logTime<>EVENT_TYPE_WITHTIME then
          alarms.UpdateValue(rtItems, activeAlarms);
      end; }
    WM_IMMINewAlarm: AlarmSound(true);
    {WM_IMMIAlarmLocal:
      begin
        if msg.LParam<0 then exit;
        if rtItems[msg.LParam].id<0 then exit;
        isAlarm := false;
        if rtItems[msg.LParam].logTime=EVENT_TYPE_WITHTIME then exit;
        if msg.LParam<0 then exit;
        case rtItems[msg.LParam].alarmCase of
           alarmMore:
             if rtItems[msg.LParam].ValReal > rtItems[msg.LParam].alarmConst then
                       isAlarm := true;
           alarmLess: if rtItems[msg.LParam].ValReal < rtItems[msg.LParam].alarmConst then
                       isAlarm := true;
        end;
        if isAlarm and not rtItems[msg.LParam].isAlarmOn then begin
          rtItems[msg.LParam].isAlarmKvit := false;
          rtItems[msg.LParam].isAlarmOn := true;
          activeAlarms.Add(TActiveAlarm.CreateLocal(rtItems,msg.LParam));
          
       end;
       if not isAlarm and rtItems[msg.LParam].isAlarmOn and rtItems[msg.LParam].isAlarmKvit then
       begin
          rtItems[msg.LParam].isAlarmOn := false;
          activeAlarms.Remove(rtItems.GetName(msg.LParam));
       end;
      end;   }
    WM_IMMICommand:
       begin
       { if rtItems[msg.LParam].logTime=EVENT_TYPE_WITHTIME then exit;
        if pos('$ССЫЛОЧНАЯ', AnsiUppercase(groups.ItemNameByNum[rtItems[msg.LParam].GroupNum]))<>0 then
             rtitems.SetDDEItem(rtItems.getsimpleid(AnsiUppercase(groups.ItemNameByNum[rtItems[msg.LParam].GroupNum])),rtItems.GetDDEItem(msg.LParam)); }
        if msg.LParam<0 then exit;
        if rtItems[msg.LParam].id<0 then exit;
        if (msg.LParam = rtItems.kvitID) then
        begin
          rtItems.activeAlarms.KvitAll;
          rtItems[rtItems.KvitID].ValReal := 0;
          AlarmSound(false);
        end;

       { if msg.WParam <> -1 then
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
           format(rtItems.GetComment(msg.LParam),
            [rtItems.Command[msg.wParam].PrevVal,rtItems.Command[msg.wParam].ValReal]),
            'Команда', 10)
        else
          AlarmTable.WriteAlarm (rtItems.GetName(msg.LParam), rtItems.GetName(msg.LParam),
           rtItems.GetComment(msg.LParam), 'Команда', 10);
        pointerItems.CheckCommand(msg.LParam, msg.WParam);    }
       end;
  end
  except
  end;
  Msg.Result := CallWindowProc(OldWndProc,
    Application.Handle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TDm1.Dm1Create(Sender: TObject);
var
  i,j: integer;
  secString, ActString: string;
begin
  appForm:=nil;
  prevDate := 0;
  TagGroupList:=TStringList.Create;
  FLoad.ProcessLog('Инициализация параметров');
  try
     rtItems := TAnalogMems.CreateW(PathMem);
     rtItems.RegHandle('IMMILogika', Application.Handle, [IMMIAll]);
     if rtitems.GetSimpleID('InterfaceStart')>-1 then rtitems.SetValForce(rtitems.GetSimpleID('InterfaceStart') , 1,100);
  except
     timer1.Enabled := false;
     showMessage ('Ошибка открытия базы данных');
     Application.Terminate;
     exit;
  end;

{  FLoad.ProcessLog('Инициализация архива');
  try
     Archives := TArchives.Create (TArchive);
     Archives.Init (dm1.tbrtBase, rtItems)
  except
     ShowMessage ('Ошибка инициализации архива');
     Application.Terminate;
  end;
  Archives.DefID(rtItems);
}
 // FLoad.ProcessLog('Инициализация тревог');
    // Alarms := TAlarms.Create;
    // ActiveAlarms := TactiveAlarms.Create;
   //  ActiveAlarms.ActiveImEvents := TActiveImEvents.Create;
  //ActiveImEvents:=TActiveImEvents.Create;
  try
//Alarms.Init (dm1.tbAlarmDef, rtItems)
  except
     ShowMessage ('Ошибка инициализации тревог');
//     Application.Terminate;
  end;
//  Alarms.DefID(rtItems);

  //получаем номер вычисляемой группы
  //rtitems.tegGroups:=TGroups.Create(PathMem + 'groups.cfg');
   with  rtitems.tegGroups do
   try
    CalcGroupNum := ItemNum['$ВЫЧИСЛЯЕМАЯ'];
   finally
  end;
  PointerItems.AddGroup(rtitems.tegGroups);


  for i := 0 to rtItems.Count - 1 do
  begin
    if rtItems[i].AlarmedLocal then rtItems.IncCounter(i);
    if rtItems[i].OnMsged then rtItems.IncCounter(i);
    if rtItems[i].OffMsged then rtItems.IncCounter(i);
    if rtItems[i].logged then
    begin
      rtItems.incCounter(i);
    //  rtItems[i].LogCode :=
     //           GetLogCode(rtItems.GetName(i), rtItems[i].minEu, rtItems[i].maxEu, rtItems.GetComment(i));
    end;
  //  if rtItems[i].GroupNum = CalcGroupNum then
  //   CalcItems.Add(i);
  end;

//  FLoad.ProcessLog('Запуск потока опроса параметров');
//  rtThread := TrtThread.Create(rtItems, DDEGroups);

//  rtItems.Update(DDEGroups);

  FLoad.ProcessLog('Запуск таймера тревог и экрана');
  timer1.Enabled := true;

  NewWndProc := MakeObjectInstance (MsgTestWndProc);
  OldWndProc := Pointer(SetWindowLong(
  Application.Handle, gwl_WndProc, LongInt(NewWndProc)));
  MaxSlaveNum:=-1;
   for j:=0 to 100 do
   begin


     if j=0 then ActString:='ActivServer' else ActString:='ActivServer'+inttostr(j);

   end;

  isInit := false;
end;


procedure TDm1.Dm1Destroy(Sender: TObject);
var
  i: integer;
begin
   if rtitems.GetSimpleID('InterfaceStart')>-1 then
   begin
    rtitems.SetVal(rtitems.GetSimpleID('InterfaceStart') ,0 ,100);
    rtitems.ValidOff(rtitems.GetSimpleID('InterfaceStart'));
   end;
  sendMessage(Application.Handle, WM_IMMISaveArchive, -1, -1);
  rtItems.UnRegHandle(Application.Handle);
 // ActiveAlarms.ActiveImEvents.Free;
//  ActiveAlarms.free;
//  Archives.free;
  PointerItems.Free;
//  Alarms.free;
  //Groups.Free;
  for i := 0 to rtItems.Count - 1 do
  begin
    if rtItems[i].AlarmedLocal then rtItems.DecCounter(i);
    if rtItems[i].logged then rtItems.DecCounter(i);
    if rtItems[i].OnMsged then rtItems.DecCounter(i);
    if rtItems[i].OffMsged then rtItems.DecCounter(i);
  end;

 TagGroupList.Free;
  rtItems.free;
  SetWindowLong(Application.Handle, gwl_WndProc, LongInt(OldWndProc));
  FreeObjectInstance(NewWndProc);
end;


procedure TDm1.Timer1Timer(Sender: TObject);
var
   i,j: integer;
   secString, actString: string;
begin
 // calcItems.update;
  PointerItems.update;
  if Date <> prevDate then
  begin
    prevDate := date;
    postMessage(Application.Handle, WM_IMMISaveArchive, -1, -1);
  end;

     






   if rtitems.GetSimpleID('AccessL')>-1 then rtitems.items[rtitems.GetSimpleID('AccessL')].ValReal:=integer(AccessLevel^);
end;

procedure TDm1.BlinkTimerTimer(Sender: TObject);
var
  i: integer;
begin
  BlinkState := not BlinkState;

  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].visible then
      if blinkState then
      begin
        sendMessage(Screen.Forms[i].Handle, WM_IMMIBlinkOn, 0, 0);
         if appForm<>nil then
             SendMessage(appForm.handle, WM_IMMIBlinkOn, 0, 0);
      end
      else
      begin
        sendMessage(Screen.Forms[i].Handle, WM_IMMIBlinkOff, 0, 0);
         if appForm<>nil then
             SendMessage(appForm.handle, WM_IMMIBlinkOff, 0, 0);
      end;
end;

procedure TDm1.Timer2Timer(Sender: TObject);
var i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
       if Screen.Forms[i].visible then
         SendMessage(Screen.Forms[i].Handle, WM_IMMIUpdate, 0, 0);
     if appForm<>nil then
      SendMessage(appForm.handle, WM_IMMIUpdate, 0, 0);
end;

end.
