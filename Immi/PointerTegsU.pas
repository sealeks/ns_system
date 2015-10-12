unit PointerTegsU;

interface

uses windows, sysutils, classes, CalcU1, memStructsU, Expr, ConstDef, dialogs, math, {debugClasses,} groupsU;

Type

TPrefficsItem = class
   PrefID: LongInt;//ID ���� ��������
   ActivePrefID: integer;
   preffics: string;
   constructor Create(iPrefID: longInt; iActivePrefID: longInt = -1);
end;

TPrefficsList = class(TList)
  private
    function GetItem(i: integer): TPrefficsItem;
    procedure SetItem(i: integer; const Value: TPrefficsItem);
public
   property Items[i: integer]: TPrefficsItem read GetItem write SetItem; default;
end;


TPointerItem = class
private
   ID: longInt;//����������� ����� ����
   PointID: longInt;//����� ����, �� ������� ��������� � ���� ������
   fPrefID: LongInt;
    procedure SetItem(const Value: longInt);//ID ���� ��������
public
   pointReffed: boolean; //��������� �� ���������� ������ �� ������������ ���
   property PrefId: longInt read fPrefID write SetItem;
   constructor Create(iID: integer);

   procedure Update;
   destructor destroy; override;
end;

tPointerItems = class (TList)
  private
    lastCommandLine: integer;
    function GetItem(i: integer): TPointerItem;
    procedure SetItem(i: integer; const Value: TPointerItem);
    procedure AddGroupNum(GroupNum: integer; GroupName: string);
public
   prefficsList: TPrefficsList;
   LastPrefficsID: integer;
   procedure update;
   procedure AddGroup(Groups: TGroups);
   //function Add(ID: integer): tPointerItem;
   destructor Destroy; override;
   constructor Create;
   property Items[i: integer]: TPointerItem read GetItem write SetItem; default;
   procedure SetPreffics(PrefID: longInt);
   procedure CheckCommand(ID, CommandLine: LongInt);
end;

Var
  PointerItemS : tPointerItems;

implementation



{ TPointerItem }

constructor TPointerItem.Create(iID: Integer);
begin
  ID := iID;
  fprefID := -1;
  pointReffed := false;
  pointID := -1;
  rtItems[ID].ValidLevel := 0;
  rtItems.SetComment(ID, copy('������� �� ������', 1, length(rtItems.GetComment(ID))));
end;


//***************tPointerItems ******************************
procedure tPointerItems.Update;
var
  i, j: integer;
begin
  //���������, �� ��������� �� ��������
  for i := 0 to PrefficsList.count - 1 do
    if rtItems[prefficsList[i].prefID].ValReal = 1 then
    begin
      //���������� ���������� ��������
      for j := 0 to PrefficsList.count - 1 do
        if rtItems[prefficsList[i].prefID].GroupNum = rtItems[prefficsList[j].prefID].GroupNum then
          rtItems[prefficsList[j].prefID].ValReal := 0;
      rtItems[prefficsList[i].prefID].ValReal := 2;
      //������������� �������
      SetPreffics(prefficsList[i].prefID);
      //������������� ������� ��� ��������� ���������
      if prefficsList[i].ActivePrefID <> -1 then
        rtItems.SetDDEItem(prefficsList[i].ActivePrefID, prefficsList[i].preffics);
      //���������� ������� �������
    end;
  for i := 0 to count - 1 do Items[i].Update;
end;

{function tPointerItems.Add(ID: Integer): TPointerItem;
var
  CI: TPointerItem;
begin
  if rtItems.GetName(ID)[1] <> '$' then
  begin
    if CI.Expr <> nil then
      inherited Add(CI);
  end
  else inherited Add(CI);
  result := CI;
end;
}

destructor tPointerItems.Destroy;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    //TPointerItem(Items[i]).Expr.ImmiUnInit;
    Items[i].Free;
  end;

  //������� ������ ����������
  for i := 0 to prefficsList.count - 1 do
  begin
    //TPointerItem(Items[i]).Expr.ImmiUnInit;
    prefficsList.Items[i].Free;
  end;
  prefficsList.Free;
  inherited;
end;


procedure tPointerItems.AddGroupNum(GroupNum: integer; GroupName: string);
var
 i, prefID: integer;
 activePrefID: integer;
begin
  prefID := -1;
  activePrefID := rtItems.GetSimpleID(GroupName); //���� ��� � ����� �� ���������, ��� ������

  //���� ������� ��������� ������
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].GroupNum = GroupNum) and
        (pos('$�������',AnsiUpperCase(rtItems.GetName(i))) <> 0) then
        begin
          prefID := rtItems[i].ID;
          if prefID <> -1 then
          begin
            //��������� � ������ ����������
            if rtItems.GetDDEItem(PrefID) <> '' then PrefficsList.Add(TPrefficsItem.Create(prefID, activePrefID))
            else showMessage ('������� �� ����� ���� ������ ' + rtItems.GetName(PrefID));
          end;
        end;
  if prefID = -1 then Raise exception.Create ('�� ������ ��� $������� ��� ������ ' + inttostr(GroupNum));


  //��������� ��� �������� ��������� ������
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].GroupNum = GroupNum) and
        (pos('$�������',AnsiUpperCase(rtItems.GetName(i))) = 0) then
        begin
          if rtItems[i].ID <> -1 then
            Add(TPointerItem.Create(i));
        end;
end;

constructor tPointerItems.Create;
begin
  inherited;
  PrefficsList := TPrefficsList.Create;
  lastCommandLine := -1;
  LastPrefficsID := -1;
end;

destructor TPointerItem.destroy;
begin
  if pointReffed then rtItems.DecCounter(pointID);
  inherited;
end;

procedure TPointerItem.SetItem(const Value: longInt);
var
  PointName: string;
begin
  if Value = fPrefID then exit;
  if pointReffed then rtItems.DecCounter(PointID);
  pointReffed := false;
  fPrefID := Value;

  with rtItems do pointName := GetDDEItem(fPrefID) + GetName(ID);
  pointID := rtItems.GetSimpleID(pointName);
  if  PointID = -1 then
  begin
    rtItems[id].ValReal := 0;
    rtItems[id].ValidLevel := 0;
    rtItems.SetComment(ID, copy('������ �� �������� ' + pointName + ' �� ����������', 1, length(rtItems.GetComment(ID))));
    //debug.log('������ �� �������� ' + pointName + ' �� ����������');
  end
  else
  begin
    rtItems.SetComment(ID, copy(rtItems.GetComment(PointID), 1, length(rtItems.GetComment(ID))));
    rtItems[ID].AlarmGroup := rtItems[PointID].AlarmGroup;
    rtItems[ID].MinRaw := rtItems[PointID].MinRaw;
    rtItems[ID].MaxRaw := rtItems[PointID].MaxRaw;
    rtItems[ID].MinEU := rtItems[PointID].MinEU;
    rtItems[ID].MaxEU := rtItems[PointID].MaxEU;
  end;
end;

procedure TPointerItem.Update;
begin
  if pointID = -1 then exit;
    //��������� ������
    if (rtItems[ID].refCount <> 0) <> pointReffed  then
    begin
      if pointReffed then
      begin
        //���� ������ ���� �����������, � �� ��� ������ ���, �� ������ ������
        rtItems.DecCounter(PointID);
        pointReffed := false;
      end else
      begin
        rtItems.IncCounter(PointID);
        pointReffed := true;
      end;
    end;
    if pointReffed then
    begin
    //�������� ������ �� ������
      rtItems[ID].ValReal := rtItems[PointID].ValReal;
      rtItems[ID].ValidLevel := rtItems[PointID].ValidLevel;
    end;
end;

{ TPrefficsItem }

constructor TPrefficsItem.Create(iPrefID: Integer; iActivePrefID: longInt = -1);
begin
  prefID := iPrefID;
  preffics := rtItems.GetDDEItem(prefID);
  activePrefID := iActivePrefID;
end;

{ TPrefficsList }

function TPrefficsList.GetItem(i: integer): TPrefficsItem;
begin
  result := TPrefficsItem (inherited Items[i]);
end;

procedure TPrefficsList.SetItem(i: integer; const Value: TPrefficsItem);
begin
  inherited Items[i] := value;
end;

function tPointerItems.GetItem(i: integer): TPointerItem;
begin
  result := TPointerItem (inherited Items[i]);
end;

procedure tPointerItems.SetItem(i: integer; const Value: TPointerItem);
begin
  inherited Items[i] := value;
end;

procedure tPointerItems.SetPreffics(PrefID: Integer);
var
  i: longInt;
begin
  for i := 0 to Count - 1 do
    if rtItems[Items[i].ID].GroupNum = rtItems[PrefID].GroupNum then
      Items[i].PrefId := PrefId;
  LastPrefficsID := prefID;
end;

procedure tPointerItems.CheckCommand(ID, CommandLine: Integer);
var
  i, pointID: integer;
  queue: boolean;

begin
  pointID := -1;
  //���������, ���� �� ������� � ������ ������
  for i := 0 to count - 1 do
    if Items[i].ID = id then
    begin
      pointID := Items[i].PointID;
      break;
    end;
  if pointID = -1 then exit; //��� �� ������, ��� �� �� ��� �� ���������

  //��������� ������������ ������ � ������ �������
  if rtItems.Command.Items[CommandLine].ID <> ID then
  begin
    ShowMessage ('���������� ���������� ������� ��� ���������� ��������');
    exit;
  end;

  //���� ����� �������� � ����������� ���� �� ���������,
  //�� ��������, ��� � ������� �� ���������
   queue := not (commandLine = LastCommandLine);
   LastCommandLine := commandLine;
  //��������� �������, ����� ����� ��������
  rtItems.AddCommand(PointID, rtItems.Command.Items[CommandLine].ValReal, queue);
end;

procedure tPointerItems.AddGroup(Groups: TGroups);
var
  i: integer;
begin
    for i := 0 to Groups.count - 1 do
      if pos('$���������', AnsiUpperCase(groups.items[i].Name)) <> 0 then
      try
        AddGroupNum(groups.items[i].Num, groups.items[i].Name);
      except
          on E: Exception do ShowMessage(E.Message);
      end;
end;

Initialization
  PointerItems := tPointerItems.Create;
end.
