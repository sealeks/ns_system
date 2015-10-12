unit AlarmUs;

interface

uses Classes, sysutils, DBTables, db,
     Graphics, windows, constDef, memStructsU, Forms,
     dialogs,  ParamU, MainDataModuleU;

Type

Talarm = class;
TAlarms = class;
tActiveAlarm = class;
TactiveAlarms = class;

TChangeAlarmEvent = procedure(Sender: TactiveAlarms) of object;

//TAlarm = class (TCollectionItem)
TAlarm = class (TObject)
public

   AlarmCase : TAlarmCase; //more or less then alarmConst
   AlarmConst : real;
   ItemID : integer; // number of group in Items array
   isKvit : boolean;
   validLevel: integer;
   group : string;
   Name : NameString;
   Comment : string;
   AlarmLevel : integer;
   isOn : boolean;
   rtItem : NameString;
   function  UpdateValue(rtItems: TAnalogMems; activeAlarms : TActiveAlarms): integer;
 //  procedure DefID(rtItems: TAnalogMems); //define ItemID
   constructor Create (iName: NameString; iComment: string; iAlarmLevel : integer;
                    irtItem: NameString; iAlarmCase: TAlarmCase; iAlarmConst: real; fgroup: string);

end;


TactiveAlarm = class (TAlarm)
public
   Date : string[10]; //date of last alarm
   Time : string[10]; //time of last alarm
   constructor CreateLocal (rtItems: TAnalogMems; id: longInt);
   constructor Create (Alarm : TAlarm);
end;


TAlarms = class (TList)
private
  function GetAlarm(number: longInt): TAlarm;
public
   property Items[i: longInt]: TAlarm read GetAlarm; default;
   destructor Destroy; override;
   procedure Kvit;
  // procedure Init(table :TTable; rtItems: TAnalogMems);
 //  procedure DefID(rtItems: TAnalogMems);
  // function GetID(alarmName: string): integer;
   function UpdateValue(rtItems: TAnalogMems; activeAlarms : TActiveAlarms): integer;
end;


//TActiveAlarms = class (TCollection)
TActiveAlarms = class (TList)
private
    Manager: TMainDataModule;
    fOnChangeAlarm: TChangeAlarmEvent;
    findx: TStringList;
    procedure SetItem ( i : integer; item : TactiveAlarm );
    function GetItem ( i : integer ) : TactiveAlarm;
    function findAllarmsByName(nm: string): integer;
public
   constructor Create();
   destructor Destroy;
   procedure SetDM(fManager: TMainDataModule);
   property Items[i : integer] : TactiveAlarm read GetItem write SetItem;
   procedure Add (alarm: TActiveAlarm);
   procedure Remove (Name: string);
   procedure Kvit;
   function isKvited(Alarm: Talarm): boolean;
   procedure WriteAlarm(alarm: TAlarm; iState: string);

   property OnChangeAlarm: tChangeAlarmEvent read fOnChangeAlarm write fOnChangeAlarm;
end;


implementation

//uses DM1Us;


var
  CanAlarmed: Boolean = true;
  

  //class TAlarm
constructor TAlarm.Create
          (iName: NameString; iComment: string; iAlarmLevel : integer;
                  irtItem: NameString; iAlarmCase: TAlarmCase; iAlarmConst: real; fgroup: string);
begin
     isOn := false;
     isKvit := true;
     Name := iName;
     Comment := iComment;
     AlarmLevel := iAlarmLevel;
     rtItem := UpperCase(irtItem);
     alarmCase := iAlarmCase;
     AlarmConst := iAlarmConst;
     group:=fgroup;
     ItemID := -1;
end;




function TAlarm.UpdateValue(rtItems: TAnalogMems; activeAlarms : TActiveAlarms): integer;
var
   isAlarm : boolean;

begin
    result := 0;
    isAlarm := false;
    validLevel := rtItems[ItemID].ValidLevel;
    if not rtItems.isValid (ItemID) then exit;
    case alarmCase of
         alarmMore: if rtItems.Items[ItemID].ValReal > alarmConst then
                       isAlarm := true;
         alarmLess: if rtItems.Items[ItemID].ValReal < alarmConst then
                       isAlarm := true;
    end;
    if isAlarm and not isOn then begin
          isKvit := false;
          isOn := true;
          activeAlarms.Add(TActiveAlarm.Create(self));
    end;
    if not isAlarm and isOn then
       if  isKvit then begin
          isOn := false;
          activeAlarms.Remove(self.rtItem);
       end;
       result := 1;
end;

//class TrtAlarms definition

function TAlarms.GetAlarm(number: longInt): TAlarm;
begin
  result := TAlarm(inherited Items[number-alarmShift]);
end;








function TAlarms.UpdateValue(rtItems: TAnalogMems; activeAlarms : TActiveAlarms): integer;
var i : integer;
begin
     result := 1;
     for i := alarmShift to alarmShift + count - 1 do
         if TAlarm(Items[i]).UpdateValue(rtItems, ActiveAlarms) <> 1 then result := -1;
end;

destructor TAlarms.Destroy;
var
   i: integer;
begin
     for i := alarmShift  to alarmShift + count - 1 do
         rtItems.DecCounter(TAlarm(items[i]).ItemID);
     inherited;
end;

procedure TAlarms.Kvit;
var i : integer;
begin
  for i := alarmShift to alarmShift + count - 1 do Talarm(Items[i]).isKvit := true;
  postMessage (Application.Handle, WM_IMMIAlarm, -1, -1);
end;

//class TActiveAlarm
constructor TActiveAlarm.Create (Alarm : TAlarm);

begin
     inherited Create (alarm.Name, alarm.comment, alarm.alarmlevel, alarm.rtItem,
                      alarm.alarmCase, alarm.AlarmConst,'');
     isOn := true;
     isKvit := false;
     ItemID := alarm.ItemID;
     date := datetostr(sysutils.date);
     time := timetostr (sysutils.Time);
end;

constructor TActiveAlarm.CreateLocal(rtItems: TAnalogMems; id: longInt);

begin
  with rtItems do
  begin
    inherited Create (AlarmGroups.ItemNameByNum[rtitems.Items[id].AlarmGroup], GetAlarmMsg(ID), Items[id].alarmlevel,
      GetName(ID), Items[id].Alarmcase, Items[id].AlarmConst,'');
   itemID := ID;

   group:='';
   isKvit := false;
   isOn := true;
   date := datetostr(sysutils.date);
   time := timetostr (sysutils.Time);
  end;
end;

//class tActiveAlarms
constructor tActiveAlarms.Create();
begin
 inherited Create;
 findx:=TStringList.Create;
 findx.CaseSensitive:=false;
 findx.Sorted:=true;
end;

destructor TActiveAlarms.Destroy;
begin
findx.Free;
//ActiveImEvents.free;
inherited;
end;

procedure tActiveAlarms.SetDM(fManager: TMainDataModule);
begin
   Manager:=fManager;
end;

procedure TActiveAlarms.SetItem ( i : integer; item: TActiveAlarm );
begin
  inherited Insert(i, item);
end;

function TActiveAlarms.GetItem ( i : integer ) : TActiveAlarm;
begin
     result := TActiveAlarm (inherited Items[i]);
end;

function TActiveAlarms.findAllarmsByName(nm: string): integer;
begin
if not findx.Find(trim(uppercase(nm)),result) then result:=-1;
end;

procedure TActiveAlarms.Add(Alarm : TActiveAlarm);
var i, num : integer;
  remAl: TActiveAlarm;
  newnum: PInteger;
begin

     num:=findAllarmsByName(alarm.rtItem);
     remAl := nil;
    // for i := 0 to count - 1 do
       //  if trim(uppercase(Items[i].rtItem)) = trim(uppercase(alarm.rtItem)) then begin
        if num>-1 then
          begin
           i:=Pinteger(findx.Objects[num])^;
           remAl := Items[i];
           delete(i);
           dispose(PInteger(findx.Objects[num]));
           findx.Delete(num);
          // break;
          end;
       //  end;
     new(newnum);
     newnum^:=inherited Add(Alarm);
     findx.AddObject(trim(uppercase(alarm.rtItem)),TObject(newnum)) ;

     if Assigned(fOnChangeAlarm) then fOnChangeAlarm(self);
     try

       WriteAlarm(alarm, 'Вкл');

     except

     end;
      if remal<>nil then remAl.free;
end;

procedure TActiveAlarms.Remove (name: string);
var i, num : integer;
  remAl: TActiveAlarm;
begin
     remAl := nil;
     num:=findAllarmsByName(name);
   // for i := 0 to count - 1 do
     //    if trim(uppercase(Items[i].rtItem)) = trim(uppercase(Name)) then begin
     if num>-1 then
          begin
           i:=Pinteger(findx.Objects[num])^;
           remAl := Items[i];
           delete(i);
           dispose(PInteger(findx.Objects[num]));
           findx.Delete(num);
           WriteAlarm(Items[i], 'Выкл');
          end;
     if Assigned(fOnChangeAlarm) then fOnChangeAlarm(self);

    if remal<>nil then
    remAl.free;
end;

function TActiveAlarms.isKvited(alarm : TAlarm): boolean;
var i,num : integer;
begin
     result := false;
     num:=findAllarmsByName(alarm.rtItem);
      if num>-1 then
          begin
           i:=Pinteger(findx.Objects[num])^;
           result := Items[i].isKvit;
          end;
          /// try
          //  WriteAlarm(Items[i], 'Выкл');


end;

procedure TActiveAlarms.Kvit;
var i,num : integer;
begin
for i := 0 to count - 1 do
  begin
    if not Items[i].isKvit then
    begin
       Items[i].isKvit := true;
       rtItems[Items[i].ItemID].isAlarmKvit := true;
       if rtItems[Items[i].ItemID].AlarmedLocal then
         postMessage(Application.Handle, WM_IMMIAlarmLocal, -1, Items[i].ItemID);
         try
           WriteAlarm(Items[i], 'Квит');
         except
         end;
    end;
  end;

  if Assigned(fOnChangeAlarm) then fOnChangeAlarm(self);

end;

procedure TActiveAlarms.WriteAlarm (alarm: TAlarm; iState: string);
begin
  if Manager<>nil then
     Manager.WriteAlarm(Alarm.ItemID, Alarm.group , Alarm.rtItem, Alarm.Comment, iState, Alarm.AlarmLevel, '', '' , now);
end;

end.
