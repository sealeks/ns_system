unit ItemAdapterU;

interface

uses
  Classes, ValEdit, Grids, MemStructsU, SysUtils, Controls, ConstDef;

type
  TItemWraper = class
  protected
    editor: TValueListEditor;
    differ: array[0..1000] of boolean;
    control: TControl;
  public

    changes: array[0..1000] of boolean;
    oldstr: array[0..1000] of string;
    newstr: array[0..1000] of string;
    rowcount: integer;
    ids: array of integer;
    idscount: integer;

    procedure ValueListEditorEdit(Sender: TObject; ACol, ARow: integer;
      const Value: string);
    procedure setMap(); virtual;
    function getCount(): integer;
    function getVal(key: string; var dif: boolean): string; virtual;
    procedure setVal(key: string; Value: string); virtual;
    procedure setList(Value: TList); virtual;
    procedure setType(); virtual;
    function save(): string; virtual;
    procedure setNew();
    constructor Create(le: TValueListEditor);
    procedure setPropertys(Name: string; Value: string;
      list: TStringList); overload;
    procedure setPropertys(Name: string; Value: string); overload;
    function setchange(key: integer; val: string): string; virtual;
    procedure setControl(observer: TControl);
    procedure setEnabled(Value: boolean);
    procedure writetofile(); virtual;
    procedure setPropertys(Name: string; Value: string; ReadOnly: boolean); overload;
    procedure setPropertys(Name: string; Value: string; NI: TNotifyEvent); overload;
  end;




function getbooleanstr(val: boolean): string;
function getstrboolean(val: string): boolean;
function getACstr(val: TAlarmCase): string;
function getstrAC(val: string): TAlarmCase;
function getCondList: TStringList;
function getNASL(): TStringList;
function getBooleanList(): TStringList;
function getNAtoStr(val: boolean): string;
function getstrToNA(val: string): boolean;
function tagisCorrect_(val: string): boolean;
function TypRtoInt(val: string): integer;
function InttoTypR(val: integer): string;
function getTypAGRSL(): TStringList;
function TypAGRtoInt(val: string): integer;
function InttoTypAGR(val: integer): string;
function getTypRSL(): TStringList;

implementation


function getTypRSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('�� ����������');
  Result.Add('��������');
  Result.Add('10��������');
  Result.Add('30��������');
  Result.Add('�������');
  Result.Add('��������');
  Result.Add('��������');
  Result.Add('��������');
  Result.Add('�����������');
  Result.Add('�������');
end;

function TypRtoInt(val: string): integer;
begin
  val := trim(AnsiUpperCase(val));
  if (val = '��������') then
    Result := REPORTTYPE_MIN
  else
  if (val = '10��������') then
    Result := REPORTTYPE_10MIN
  else
  if (val = '30��������') then
    Result := REPORTTYPE_30MIN
  else
  if (val = '�������') then
    Result := REPORTTYPE_HOUR
  else
  if (val = '��������') then
    Result := REPORTTYPE_DAY
  else
  if (val = '��������') then
    Result := REPORTTYPE_DEC
  else
  if (val = '��������') then
    Result := REPORTTYPE_MONTH
  else
  if (val = '�����������') then
    Result := REPORTTYPE_QVART
  else
  if (val = '�������') then
    Result := REPORTTYPE_YEAR
  else
    Result := -1;
end;

function InttoTypR(val: integer): string;
begin
  case val of
    REPORTTYPE_MIN: Result := '��������';
    REPORTTYPE_10MIN: Result := '10��������';
    REPORTTYPE_30MIN: Result := '30��������';
    REPORTTYPE_HOUR: Result := '�������';
    REPORTTYPE_DAY: Result := '��������';
    REPORTTYPE_DEC: Result := '��������';
    REPORTTYPE_MONTH: Result := '��������';
    REPORTTYPE_QVART: Result := '�����������';
    REPORTTYPE_YEAR: Result := '�������';
    else
      Result := '�� ����������';

  end;
end;

function getTypAGRSL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('�� ����������');
  Result.Add('��������');
  Result.Add('�������');
  Result.Add('�������');
  Result.Add('��������');
  Result.Add('���');
end;


function TypAGRtoInt(val: string): integer;
begin
  val := trim(AnsiUpperCase(val));
  if (val = '��������') then
    Result := REPORTAGR_INTEG
  else
  if (val = '�������') then
    Result := REPORTAGR_MID
  else
  if (val = '�������') then
    Result := REPORTAGR_MIN
  else
  if (val = '��������') then
    Result := REPORTTYPE_MAX
  else
  if (val = '���') then
    Result := REPORTTYPE_SCO
  else
    Result := -1;
end;

function InttoTypAGR(val: integer): string;
begin
  case val of
    REPORTAGR_INTEG: Result := '��������';
    REPORTAGR_MID: Result := '�������';
    REPORTAGR_MIN: Result := '�������';
    REPORTTYPE_MAX: Result := '��������';
    REPORTTYPE_SCO: Result := '���';
    else
      Result := '�� ����������';

  end;
end;



function tagisCorrect_(val: string): boolean;
var
  First: char;
  i: integer;
begin
  Result := False;
  val := trim(val);
  val := AnsiUpperCase(val);
  if length(val) = 0 then
    exit;
  First := val[1];
  if not (First in ['A'..'Z', '@', '%', '$', '&', '_', char('�')..char('�')]) then
    exit;
  for i := 2 to length(val) do
    if not (val[i] in ['A'..'Z', '@', '%', '$', '&', '_', '0'..'9', char('�')..char('�')]) then
      exit;
  Result := True;
end;

function getbooleanstr(val: boolean): string;
begin
  Result := '��';
  if (not val) then
    Result := '���';
end;

function getstrboolean(val: string): boolean;
begin
  if (trim(AnsiUpperCase(val)) = '��') then
    Result := True
  else
  begin
    if (trim(AnsiUpperCase(val)) = 'HET') then
      Result := False
    else
      Result := False;
  end;
end;

function getACstr(val: TAlarmCase): string;
begin
  Result := '<';
  if (val = alarmMore) then
    Result := '>';
  if (val = alarmEqual) then
    Result := '=';
end;

function getstrAC(val: string): TAlarmCase;
begin
  if (trim(UpperCase(val)) = '>') then
    Result := alarmMore
  else

  if (trim(UpperCase(val)) = '<') then
    Result := alarmLess
  else
    Result := alarmEqual;

end;

function getCondList: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('>');
  Result.Add('<');
  Result.Add('=');

end;

function getNASL(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('����������');
  Result.Add('a����������');
end;

function getBooleanList(): TStringList;
begin
  Result := TStringList.Create;
  Result.Add('��');
  Result.Add('���');
end;

function getNAtoStr(val: boolean): string;
begin
  Result := '�����������';
  if val then
    Result := '����������';
end;

function getstrToNA(val: string): boolean;
begin
  Result := False;
  if (trim(uppercase(val)) = uppercase('����������')) then
    Result := True;
end;


constructor TItemWraper.Create(le: TValueListEditor);
begin

  editor := le;
end;




procedure TItemWraper.setMap();
begin
end;

function TItemWraper.setchange(key: integer; val: string): string;
begin
end;

procedure TItemWraper.setPropertys(Name: string; Value: string; list: TStringList);
begin
  setPropertys(Name, Value);
  editor.ItemProps[editor.Strings.Count - 1].EditStyle := esPickList;
  editor.ItemProps[editor.Strings.Count - 1].PickList := list;
  editor.ItemProps[editor.Strings.Count - 1].ReadOnly := False;
end;

procedure TItemWraper.setPropertys(Name: string; Value: string; NI: TNotifyEvent);
begin
  setPropertys(Name, Value);
  editor.ItemProps[editor.Strings.Count - 1].EditStyle := esEllipsis;
  editor.ItemProps[editor.Strings.Count - 1].ReadOnly := False;
  editor.OnEditButtonClick := NI;
end;

procedure TItemWraper.setPropertys(Name: string; Value: string);
begin

  editor.InsertRow(Name, Value, True);
  editor.ItemProps[editor.Strings.Count - 1].EditStyle := esSimple;
  editor.ItemProps[editor.Strings.Count - 1].ReadOnly := False;
end;

procedure TItemWraper.setPropertys(Name: string; Value: string; ReadOnly: boolean);
begin

  editor.InsertRow(Name, Value, True);
  editor.ItemProps[editor.Strings.Count - 1].EditStyle := esSimple;
  editor.ItemProps[editor.Strings.Count - 1].ReadOnly := ReadOnly;
end;

procedure TItemWraper.setList(Value: TList);
begin

end;

function TItemWraper.getVal(key: string; var dif: boolean): string;
begin

end;

procedure TItemWraper.setVal(key: string; Value: string);
begin

end;

function TItemWraper.getCount(): integer;
begin
  Result := idscount;
end;

procedure TItemWraper.setType();
begin
end;


procedure TItemWraper.setNew();
var
  i: integer;
begin
  editor.Refresh;
  editor.OnSetEditText := self.ValueListEditorEdit;
  for i := 0 to 999 do
    changes[i] := False;
  for i := 0 to editor.RowCount - 1 do
  begin
    oldstr[i] := editor.Cells[1, i];
    newstr[i] := oldstr[i];
  end;
  rowcount := editor.RowCount;
  setEnabled(False);

end;

procedure TItemWraper.ValueListEditorEdit(Sender: TObject; ACol, ARow: integer;
  const Value: string);
var
  i: integer;
begin
  if (ACol = 1) then
  begin
    if (Value <> newstr[ARow]) then
    begin
      newstr[ARow] := Value;
      if (newstr[ARow] <> oldstr[ARow]) then
        changes[ARow] := True
      else
        changes[ARow] := False;
    end;
  end;
  // ��������� ���� �� ���������
  // setEnabled(false);
  for i := 0 to rowcount - 1 do
  begin
    if (changes[ARow]) then
    begin
      setEnabled(True);
      exit;
    end;
  end;
end;

function TItemWraper.save(): string;
var
  i: integer;
  tempstr: string;
begin
  try
    Result := '';
    for i := 0 to rowcount - 1 do
    begin
      if changes[i] then
      begin
        tempstr := setchange(i, newstr[i]);
        if (tempstr <> '') then
          Result := tempstr;
      end;
    end;
    writetofile();
  finally
    SetMap;
  end;
end;

procedure TItemWraper.setControl(observer: TControl);
begin
  control := observer;
end;

procedure TItemWraper.setEnabled(Value: boolean);
begin
  if (control <> nil) then
    control.Enabled := Value;
end;

procedure TItemWraper.writetofile();
begin

end;

end.
 
