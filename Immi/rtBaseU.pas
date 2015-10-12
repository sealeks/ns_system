unit rtBaseU;

interface

uses windows, DDEMan1, DDEML, DBTables,
     sysutils, classes, CalcU1, memStructsU;

Type

TBasertItem = class(TObject)
private
   ValidLevel: integer;//100-ok, 89-notValid, 0 - notInit
   isfirstUpdated: boolean;

protected
   fLinkCounter: integer;
   Item: NameString;
   GroupID : integer; // number of group in Groups array
   DDEGroup : NameString;
   thread : TThread;
   procedure DefID(Groups: TDDEGroups); //define GroupID
   procedure IncRef; virtual;
   procedure DecRef; virtual;
public
   Name : NameString;
   Comment : string;
   ValueString : string;
//   Value : Variant;
   ValueReal : real;

   procedure Init(Table: TTable); virtual;
   procedure firstUpdate(Groups: TDDEGroups); virtual; // when all Item is Init
   procedure UpdateValue(Groups: TDDEGroups); virtual;

   function isValid : boolean; virtual;
end;

PTBasertItem = ^TBasertItem;


TrtItem = class (TBasertItem)
 private
   procedure convertValue;
 public
   procedure UpdateValue(Groups: TDDEGroups); override;
end;

TrtCalcItem = class (TBasertItem)
 private
   Calc: Tcalculator;
 protected
   procedure IncRef; override;
   procedure DecRef; override;
 public
   constructor Create;
   destructor Destroy; override;
   //address of this function send to the calc object
   //Sender: TCalcItem, result - real value of rt tag
   procedure GetrtValue(Sender: tObject; var rez: real);
   procedure firstUpdate(Groups: TDDEGroups); override; // when all Item is Init
   procedure UpdateValue(Groups: TDDEGroups); override;
end;

TrtItems = class (TList)
private
  procedure SetItem (i: longint; client: TbasertItem);
  function  GetItem (i: longint): TbasertItem;
public
   mBase: TAnalogMems;
   constructor create;
   property Items[i: longint]: TbasertItem read getItem write SetItem;
   function Add(item: TbasertItem): TbasertItem;
   procedure Init (table :TTable);
   procedure DefID(Groups: TDDEGroups);
   procedure UpdateValue(Groups: TDDEGroups);
   function GetID(iName : NameString): integer; // return -1 if not found
   procedure IncCounter(ItemID: longInt);
   procedure DecCounter(ItemID: longint);
end;

{Var
  rtItems : TrtItems;}

implementation

procedure TbasertItem.IncRef;
begin
     inc(fLinkCounter);
end;

procedure TbasertItem.DecRef;
begin
     Dec(fLinkCounter);
end;

function TbasertItem.isValid : boolean;
begin
     if ValidLevel >= 90 then result := true
     else result := false;
end;


procedure TbasertItem.DefID(Groups: TDDEGroups);
begin
     if (GroupID <> -1) and (Groups.Items[GroupID].Name = DDEGroup) then exit;
     GroupID := Groups.getID(DDEGroup);
     if GroupID = -1 then
        raise Exception.Create ('Не найдена группа');
end;

procedure TbasertItem.Init (table: ttable);
begin
     Name := Table['Name'];
     DDEGroup := Table['Group'];
     Comment := Table['Comment'];
     Item := Table.FieldByName('Item').asString;

     GroupID := -1;
     isFirstUpdated := false;
     ValueString := '';
     ValueReal := 0;
     ValidLevel := 0;
end;


procedure TbasertItem.firstUpdate(Groups: TDDEGroups);
begin
     DefID(groups);
end;

procedure TbasertItem.UpdateValue(Groups: TDDEGroups);
begin
  if not isFirstUpdated then FirstUpdate(Groups);
end;

function RequestData(const Item: string; DDEConv: TDDEClientConv): PChar;
var
  hData: HDDEData;
  ddeRslt: LongInt;
  hItem: HSZ;
  pData: Pointer;
  Len: Integer;
  Sect: TRTLCriticalSection;
begin
  Result := nil;
  if (DDEConv.Conv = 0) or DDEConv.WaitStat then Exit;
  hItem := DdeCreateStringHandle(ddeMgr.DdeInstId, PChar(Item), CP_WINANSI);
  if hItem <> 0 then
  begin
    initializeCriticalSection(Sect);
    EnterCriticalSection(Sect);
    hData := DdeClientTransaction(nil, 0, DDEConv.Conv, hItem, CF_TEXT,
      XTYP_REQUEST, 10000, @ddeRslt);
    LeaveCriticalSection(Sect);
    DeleteCriticalSection(Sect);
    DdeFreeStringHandle(ddeMgr.DdeInstId, hItem);
    if hData <> 0 then
    try
      pData := DdeAccessData(hData, @Len);
      if pData <> nil then
      try
        Result := StrAlloc(Len + 1);
        StrCopy(Result, pData);
      finally
        DdeUnaccessData(hData);
      end;
    finally
      DdeFreeDataHandle(hData);
    end;
  end;
end;


// TrtItem definition
procedure TrtItem.UpdateValue(Groups: TDDEGroups);
var
   res : PChar;
begin
  res := nil;
  inherited UpdateValue(Groups);
  try
    IF fLinkCounter = 0 then exit;
       try
         res := Groups.Items[GroupID].RequestData(Item);
//         res := RequestData(Item, Groups.Items[GroupID].DDE);
         if res = nil then exit;
         ValueString := res;
         convertValue;
         ValidLevel := 101;
       finally
                 StrDispose (res);
       end;
    finally
           if ValidLevel > 0 then dec (ValidLevel);
    end;
end;

procedure TrtItem.convertValue;
var
   tabPos : integer;

begin
     tabPos := pos(chr(9), valueString);
     if  tabPos <> 0 then
          valueString := copy(valueString, tabPos + 1, length(valueString) - tabPos);
     tabPos := pos(chr($C), valueString);
     if tabPos <> 0 then
          valueString := copy(valueString, 1, tabPos - 1);
     tabPos := pos('.', ValueString);
     if tabpos <> 0 then valueString[tabPos] := ',';
     try
        if (pos('E', valueString)= 0) and (valueString <> '')  then
           ValueReal := strtofloat (valueString);
     except     ;
//              exception.Create('Cant convert value to real');
     end;

end;

//class TrtItems definition

procedure TrtItems.SetItem (i: longint; client: TbasertItem);
begin
  inherited Items[i] := TCollectionItem(client);
end;

function  TrtItems.GetItem (i: longint): TbasertItem;
begin
     result := TbasertItem(inherited Items[i]);
end;

function TrtItems.Add(item: TbasertItem): TbasertItem;
begin
     inherited Add(Item);
     result := Item;
end;


//class TrtItems definition
procedure TrtItems.Init (table: ttable);
var
   tableState: boolean;
begin
  tableState := Table.Active;
  try
     table.active := true;
     table.first;
     while not table.EOF do begin
        if Table['Group'] = '$Вычисляемая' then
           Add(TrtCalcItem.Create).init(Table)
        else
           Add(TrtItem.Create).init(Table);
        Table.next;
     end;
  finally
     table.active := TableState;
  end;
end;

procedure TrtItems.DefID(Groups: TDDEGroups);
var i : integer;
begin
     for i := 0 to count - 1 do
         items[i].DefID(Groups);
end;

procedure TrtItems.UpdateValue(Groups: TDDEGroups);
var i : integer;
begin
     for i := 0 to count - 1 do
         items[i].UpdateValue(Groups);
end;

function TrtItems.GetID(iName: NameString): integer;
var
   i : integer;
   upperName: NameString;

begin
     upperName := UpperCase(iName);
     result := -1;
     for i := 0 to count - 1 do
         if UpperCase(items[i].Name) =  upperName then begin
            result := i;
            exit;
         end;
end;

constructor TrtItems.create;
begin
     inherited;
     mBase := TAnalogMems.create ('');
end;

procedure TrtItems.IncCounter(ItemID: longInt);
begin
     items[ItemID].IncRef;
     mBase.IncCounter(ItemID);
end;

procedure TrtItems.DecCounter(ItemID: longint);
begin
     items[ItemID].DecRef;
     mBase.DecCounter(ItemID);
end;


//TrtCalcItem definition
constructor TrtCalcItem.Create;
begin
     inherited;
     calc := TCalculator.Create;
end;

destructor TrtCalcItem.Destroy;
begin
     calc.free;
     inherited;
end;

procedure TrtCalcItem.GetrtValue(Sender: tObject; var rez: real);
begin
     rez := rtItems.Items[(Sender as TCalcItem).IdentID].ValReal;
end;

procedure TrtCalcItem.firstUpdate(Groups: TDDEGroups);
var
   i, ID: integer;
begin
     inherited;
     Calc.Expresion := Item;
     Calc.ConvertFunction := GetrtValue;
     for i := 0 to Calc.ExprList.Count - 1 do
       if Calc.ExprList[i].IdentType = itIdent then begin
             ID := rtItems.GetID(Calc.ExprList[i].Ident);
             Calc.ExprList[i].IdentID := ID;
             if ID <> -1 then rtItems.IncCounter(ID)
             else raise Exception.Create ('Не найден вычисляемый параметр');
       end;
end;

procedure TrtCalcItem.UpdateValue(Groups: TDDEGroups);
begin
  inherited;
  try
    IF fLinkCounter = 0 then exit;
         Calc.Calc;
         ValueReal := Calc.Value;
         ValidLevel := 101;
    finally
           if ValidLevel > 0 then dec (ValidLevel);
    end;
end;

procedure TrtCalcItem.Incref;
var
   i: integer;
begin
     inherited;
     if fLinkCounter = 1 then
      for i := 0 to Calc.ExprList.Count - 1 do
          if (Calc.ExprList[i].IdentType = itIdent) and
             (Calc.ExprList[i].IdentID <> -1) then
                  rtItems.IncCounter(Calc.ExprList[i].IdentID);
end;

procedure TrtCalcItem.DecRef;
var
   i: integer;
begin
     inherited;
     if fLinkCounter = 0 then
      for i := 0 to Calc.ExprList.Count - 1 do
          if (Calc.ExprList[i].IdentType = itIdent) and
             (Calc.ExprList[i].IdentID <> -1) then
                 rtItems.DecCounter(Calc.ExprList[i].IdentID);
end;

end.
