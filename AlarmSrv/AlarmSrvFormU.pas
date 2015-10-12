unit AlarmSrvFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ShellApi,
  Dialogs, constDef, MemStructsU, configurationSys, GlobalValue, CalcTegsU, SysVariablesU, SysCommansGroupU,
   ExtCtrls, DateUtils, Menus;
const
WM_ICONNOTYFY=WM_USER+1324;

type
  TAlarmSrvForm = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    CalcTimer: TTimer;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure CalcTimerTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    CalcI : TCalcItems;
    VarI: TVariableItems;
    CommandsI: TSysCommandsGroupItems;
    CalcGroupNum: integer;
    CalcGroupNum1: integer;
    VarGroupNum: integer;
    CommandsGroupNum: integer;
    NewWndProc, OldWndProc: pointer; //WndProc for application
    isInit: boolean;
    TagGroupList: TStringList;
    FNID: TNotifyIconData;

  public
    { Public declarations }
    procedure MsgTestWndProc(var Msg: TMessage);
    procedure WMIconNotyfy(var messag: TMsg); message WM_ICONNOTYFY;
  end;

var
  AlarmSrvForm: TAlarmSrvForm;

implementation

{$R *.dfm}
procedure TAlarmSrvForm.MsgTestWndProc(var Msg: TMessage);
var
   isAlarm: boolean;
   i: longInt;
begin
  try
  if isInit or (Msg.Msg = WM_IMMIFirstUpd) then
  case Msg.Msg of
    WM_IMMIFirstUpd:
      begin

        isInit := true;
        for i := 0 to rtItems.Count - 1 do
          begin
          if rtItems[i].AlarmedLocal and rtItems.isValid(i) then
            postMessage (forms.Application.Handle, WM_IMMIAlarmLocal, -1, rtItems[i].ID);
           if rtItems[i].Logged then
            rtItems.setLocalBaseTagval(now,rtItems.items[i].ID,rtItems[i].ValReal,rtItems[i].ValidLevel);
          end;
      end;
    WM_IMMIEvent:
        if (msg.LParam < 0) or (rtItems[msg.LParam].logTime = EVENT_TYPE_WITHTIME) then exit
        else
          if rtItems[msg.LParam].ValReal <> 0 then
            rtItems.alarms.AddItem(Now, msg.LParam, msOn)
          else
            rtItems.alarms.AddItem(Now, msg.LParam, msOff);

     WM_IMMILogInside:
         if localbase then
         if msg.LParam>-1 then
         begin
            if {abs(rtItems[msg.LParam].LogPrevVal - rtItems[msg.LParam].ValReal) > (rtItems[msg.LParam].LogDB/4)} true then
              // if rtItems[msg.LParam].ValidLevel>89 then
                   begin
                   rtItems.setLocalBaseTagval(now,rtItems.items[msg.LParam].ID,rtItems[msg.LParam].ValReal,rtItems[msg.LParam].ValidLevel);
                  // rtItems[msg.LParam].LogPrevVal := rtItems[msg.LParam].ValReal;
                   end;
         end;
    WM_IMMIAlarmLocal:
      begin
        //if (msg.LParam = 580) then ShowMessage('!');
        isAlarm := false;
        if (msg.LParam < 0) or (rtItems[msg.LParam].logTime = EVENT_TYPE_WITHTIME) then exit;
        case rtItems[msg.LParam].alarmCase of
           alarmMore:
             if rtItems[msg.LParam].ValReal > rtItems[msg.LParam].alarmConst then
                       isAlarm := true;
           alarmLess: if rtItems[msg.LParam].ValReal < rtItems[msg.LParam].alarmConst then
                       isAlarm := true;
           alarmEqual: if rtItems[msg.LParam].ValReal = rtItems[msg.LParam].alarmConst then
                       isAlarm := true;
        end;
        if isAlarm then begin
          rtItems.ActiveAlarms.AddItem(Now, msg.LParam);
       end;
       if not isAlarm and rtItems[msg.LParam].isAlarmOn then
       begin
          rtItems.activeAlarms.SetOff(msg.LParam);
       end;
      end;
    WM_IMMICommand:
        if msg.WParam <> -1 then
          rtItems.alarms.AddItem(Now, msg.LParam, msCMD,rtItems.command.Items[msg.WParam].CompName,rtItems.command.Items[msg.WParam].UserName);
    WM_IMMIChange:
       if (msg.LParam >= 0) and (rtItems[msg.LParam].id >= 0) and (rtItems[msg.LParam].logTime=EVENT_TYPE_WITHTIME)then
          rtItems.alarms.AddItem(TDateTime(rtItems[msg.LParam].LogPrevVal), msg.LParam, msOn);
  end
  except
  end;
  Msg.Result := CallWindowProc(OldWndProc,
    forms.Application.Handle, Msg.Msg, Msg.WParam, Msg.LParam);
end;


procedure TAlarmSrvForm.FormCreate(Sender: TObject);
var
  i,j: integer;
  secString, ActString: string;
begin
   TagGroupList:=TStringList.Create;
  InitialSys;
  FNID.Wnd:=handle;
  FNID.uCallbackMessage:=WM_ICONNOTYFY;
  FNID.szTip:='NS_MemBase_Service';
  FNID.uFlags:=nif_Message or nif_Icon or nif_Tip ;
  FNID.hIcon:=self.Icon.Handle;
  
  try
     if localbase then rtItems := TAnalogMems.CreateW(Pathmem) else
       rtItems := TAnalogMems.Create(Pathmem);
     rtItems.RegHandle('IMMIAlarmServ', application.handle, [IMMIall]);
  except
  end;

  for i := 0 to rtItems.Count - 1 do
  begin
    if rtItems[i].AlarmedLocal then rtItems.IncCounter(i);
    if rtItems[i].OnMsged then rtItems.IncCounter(i);
    if rtItems[i].OffMsged then rtItems.IncCounter(i);
    if (rtItems[i].logged) {and  (localbase)} then
    begin
      rtItems.incCounter(i);
      rtitems.addLocalBaseTag(rtItems[i].ID);
    end;
  end;
   if (localbase) then
   for i:=0 to rtitems.tegGroups.Count-1 do
    rtitems.addLocalBaseGroup(rtitems.tegGroups.Items[i].Num);

  NewWndProc := MakeObjectInstance (MsgTestWndProc);
  OldWndProc := Pointer(SetWindowLong(
  forms.application.handle, gwl_WndProc, LongInt(NewWndProc)));


  postMessage (forms.Application.Handle,  WM_IMMIFirstUpd, -1, -1);
  MaxSlaveNum:=-1;

  CalcI :=TCalcItems.Create;

  with  rtitems.tegGroups do
 try
    CalcGroupNum := ItemNum['$SERVERCOUNT'];
   // CalcGroupNum1:= ItemNum['$ÂÛ×ÈÑËßÅÌÀß'];
    if (CalcGroupNum=-1) then CalcGroupNum:=-2;
   // if (CalcGroupNum1=-1) then CalcGroupNum1:=-2;
 finally
 end;
 for I:=0 to rtitems.Count-1 do
   if (rtItems[i].GroupNum = CalcGroupNum) or (rtItems[i].GroupNum = CalcGroupNum1) then
      try
      CalcI.Add(i);
      except
      end;

 if CalcI.Count=0 then
 FReeAndNil(CalcI);

 VarI :=TVariableItems.Create;

 with  rtitems.tegGroups do
 try
    VarGroupNum := ItemNum['$SYSVAR'];
    if (VarGroupNum=-1) then VarGroupNum:=-2;
 finally
 end;
 for I:=0 to rtitems.Count-1 do
   if rtItems[i].GroupNum = VarGroupNum then
      try
      VarI.Add(i);
     // VarI.Add(i);
      except
      end;

  if VarI.Count=0 then FreeAndNil(varI);

 CommandsI :=TSysCommandsGroupItems.Create;
 CommandsGroupNum:=-2;
 with  rtitems.tegGroups do
 try
    CommandsGroupNum := ItemNum['$COMMANDSCASE'];
    if (CommandsGroupNum=-1) then CommandsGroupNum:=-2;
 finally
 end;
 for I:=0 to rtitems.Count-1 do
   if rtItems[i].GroupNum = CommandsGroupNum then
      try
      CommandsI.Add(i);

      except
      end;

  if CommandsI.Count=0 then FreeAndNil(CommandsI);


  CalcTimer.Enabled:=((VarI<>nil) or (CalcI<>nil) or (CommandsI<>nil));

  Timer1.Enabled:=true;
end;

procedure TAlarmSrvForm.FormDestroy(Sender: TObject);
var
 i,j: integer;
 secString, ActString: string;
begin
   try
   Shell_NotifyIcon(NIM_DELETE,@FNID);
   except
   end;

   CalcTimer.Enabled:=false;
   if VarI<>nil then VarI.Free;
   if CalcI<>nil then CalcI.Free;

   rtItems.UnRegHandle(forms.application.handle);

   for i := 0 to rtItems.Count - 1 do
   begin
      if rtItems[i].AlarmedLocal then rtItems.DecCounter(i);
      if rtItems[i].OnMsged then rtItems.DecCounter(i);
      if rtItems[i].OffMsged then rtItems.DecCounter(i);
       if rtItems[i].logged then rtItems.DecCounter(i);
  end;

     rtItems.free;
     SetWindowLong(forms.application.handle, gwl_WndProc, LongInt(OldWndProc));
     FreeObjectInstance(NewWndProc);
     
end;





procedure TAlarmSrvForm.Timer2Timer(Sender: TObject);
begin
  try
  timer2.Enabled:= not Shell_NotifyIcon(NIM_ADD,@FNID);
  except
  end;
end;

procedure TAlarmSrvForm.CalcTimerTimer(Sender: TObject);
begin
   CalcTimer.Enabled:=false;
   try
   if   calcI<>nil  then
    calcI.update;
   if   VarI<>nil  then
    VarI.update;
   if   CommandsI<>nil  then
    CommandsI.update;
   except
   end;
    CalcTimer.Enabled:=true;
end;

procedure TAlarmSrvForm.WMIconNotyfy(var messag: TMsg);
var pt: TPoint;
begin

    if messag.wParam=WM_RBUTTONDOWN then
      begin
        if Showing then popupmenu1.Items[0].Enabled:=false else popupmenu1.Items[0].Enabled:=true;
            getCursorPos(pt);
        popupmenu1.Popup(pt.X,pt.y);
      end;
end;

procedure TAlarmSrvForm.N1Click(Sender: TObject);
begin
self.Close;
end;

initialization





end.
