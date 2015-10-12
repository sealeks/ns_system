unit ActiveAlarmListU;

interface

uses Classes, sysutils, DBTables, db,
     Graphics, windows, constDef, memStructsU, Forms,
     dialogs,  ParamU, MainDataModuleU;

Type


TActiveAlarmList = class(THeaderedMem)
private
  DBMeneger: TMainDataModule;
  rtItemsPointer: pointer;
  function GetItem (num: longInt):PTActiveAlarmStruct;
  procedure CheckOut;
public
  property LastNumber;
  procedure SetDM(fDBMeneger: TMainDataModule);
  property Items[i: longInt]: PTActiveAlarmStruct read GetItem; default;
  constructor Create (rtItemsPtr:pointer; MemName: string);
  destructor Destroy; override;
  property Count: LongInt read GetCount;
  function AddItem(atime: TDateTime; aTegID: integer): integer;
  procedure KvitAll;
  procedure KvitAlarmGroup(grnum: integer);
  procedure KvitTagGroup(grnum: integer);
  procedure SetOff(aTegID: integer);
  procedure WriteAlarm (id: integer; iState: TJournalMessageType);
end;

implementation

function TActiveAlarmList.AddItem(atime: TDateTime; aTegID: integer): integer;
var i: integer;
begin
    TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmOnServ := true;
   // TAnalogMems(rtItemsPointer).Items[aTegId].isAlarmKvit := false;
  for i := 0 to count -1 do
    if Items[i].TegID = aTegId then
    begin
      Items[i].isOff := false;
      exit;
    end;

    inherited Count := Count + 1;
    inherited LastNumber := LastNumber + 1;
    Items[count-1].number := lastNumber;
    Items[count-1].Time := aTime;
    Items[count-1].TegID := aTegID;
    Items[count-1].isKvit := False;
    Items[count-1].isOff := false;
    result := count - 1;

    WriteAlarm(aTegID, ejAlOn )
end;

procedure TActiveAlarmList.SetDM(fDBMeneger: TMainDataModule);
begin
  DBMeneger:=fDBMeneger;
end;

procedure TActiveAlarmList.CheckOut;
var
  i: integer;
begin
  for i := count - 1 downto 0 do
    begin
    if items[i].isKvit and items[i].isOff then
    begin
      //TAnalogMems(rtItemsPointer).alarms.AddItem(Now, items[i].TegID, msOut);
      TAnalogMems(rtItemsPointer).Items[items[i].TegID].isAlarmOnServ := false;
      if i < (count - 1) then //если элемент не последний, подтягиваем хвост
      begin
        move(items[i + 1]^, items[i]^, sizeOf(TActiveAlarmStruct) * (count - i));
      end;
      inherited Count := count - 1;
    end;
    end;
end;

constructor TActiveAlarmList.Create;
begin
  inherited Create(MemName);
  rtItemsPointer := rtItemsPtr;
end;

destructor TActiveAlarmList.Destroy;
begin
  inherited;
end;

function TActiveAlarmList.GetItem(num: Integer): PTActiveAlarmStruct;
begin
  if (num >= count) or (num < 0) then raise Exception.Create('TActiveAlarmsMem индекс за границей! ' + inttostr(num));
  result := @(PTActiveAlarms(Data)^.Items[num]);

end;

procedure TActiveAlarmList.KvitAll;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
   // TAnalogMems(rtItemsPointer).Items[items[i].TegId].isAlarmKvit := true;
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
        WriteAlarm(items[i].TegID,ejAlKvit) ;
        inherited LastNumber := LastNumber + 1;
        if items[i].isOff then WriteAlarm(items[i].TegID, ejAlOff );
        inherited LastNumber := LastNumber + 1;
      end;
    end;
  end;
  CheckOut;

end;

procedure TActiveAlarmList.KvitAlarmGroup(grnum: integer);
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
   if TAnalogMems(rtItemsPointer).Items[items[i].TegId].AlarmGroup=grnum then
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
        WriteAlarm(items[i].TegID,ejAlKvit) ;
        inherited LastNumber := LastNumber + 1;
        if items[i].isOff then WriteAlarm(items[i].TegID,ejAlOff);
        inherited LastNumber := LastNumber + 1;
      end;
    end;
  end;
  CheckOut;

end;

procedure TActiveAlarmList.KvitTagGroup(grnum: integer);
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
   if TAnalogMems(rtItemsPointer).Items[items[i].TegId].GroupNum=grnum then
    if not items[i].isKvit then
    begin
      if items[i].isKvit <> true then
      begin
        items[i].isKvit := true;
        WriteAlarm(items[i].TegID,ejAlKvit) ;
        inherited LastNumber := LastNumber + 1;
        if items[i].isOff then WriteAlarm(items[i].TegID,ejAlOff);
        inherited LastNumber := LastNumber + 1;
      end;
    end;
  end;
  CheckOut;

end;

procedure TActiveAlarmList.SetOff(aTegID: integer);
var
  i: integer;
begin
  for i := 0 to count - 1 do
    if (items[i].TegID = aTegID) and not items[i].isOff then
    begin
      items[i].isOff := true;
      if not items[i].isKvit then exit;
      WriteAlarm(aTegID,ejAlOff) ;
      inherited LastNumber := LastNumber + 1;
    end;
  CheckOut;
end;



procedure TActiveAlarmList.WriteAlarm (id: integer; iState: TJournalMessageType);
var
  grN, itN, comT: string;
  AlarmL, grNum: integer;
begin
  if (id<0) then exit;
  if DBMeneger<>nil then
   begin
    if (TAnalogMems(rtItemsPointer).Items[id].ID<0) then exit;
 ////  DBMeneger.WriteAlarm(id,
   //  Alarm.group , Alarm.rtItem, Alarm.Comment, iState, Alarm.AlarmLevel, '', '' , now);


   grN:='';
   grNum:=TAnalogMems(rtItemsPointer).Items[id].AlarmGroup;
   if grNum>-1 then
      grN:=TAnalogMems(rtItemsPointer).AlarmGroups.ItemNameByNum[grNum];
   itN:=TAnalogMems(rtItemsPointer).GetName(id);
   comT:=TAnalogMems(rtItemsPointer).GetAlarmMsg(id);
   AlarmL:=TAnalogMems(rtItemsPointer).Items[id].AlarmLevel;
    DBMeneger.WriteAlarm(id,
        grN , itN, comT, iState, AlarmL, '', '' , now);
   end;
end;



end.
