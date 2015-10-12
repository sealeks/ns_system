{
  ���������� �������������� ������

  �������������� ��������� � ������� ������ ����������

  � ����� �. �������, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtSysUtils;

interface

{$I EXT.INC}

uses
  SysUtils;

{ ������� ������ � ������������� �����. ��� ������������� ������ ��
  ������� ����������, �� ����������� ���������� �������� �� ���������. }

function StrToFloatDef(const S: string; Default: Extended): Extended;

{ ��������� ��������� �������������� �������� (Exception): ��������
  ��������� ������, ����� �� ����� ������. }

function ExceptionMsg(E: Exception): string;

{ ��������� ������� ����������� ��������� ��������� ������, �������
  ����� ��������� ������ (PartialOK = True) ��� ���������� �� ���������
  ������ (PartialOK = False). }

function FindParam(const Param: string; PartialOK: Boolean; var Value: string): Boolean;

{ ����������� ������� ��������� ��������� ������. }

function ParamExists(const Param: string; PartialOK: Boolean): Boolean;
function ParamsExists(const Params: array of string; PartialOK, CheckAll: Boolean): Boolean;

{ ����������� �������� ���������. ���������� ������, ��������� ����� ��
  ���������� �������. ��������, ��� ������ -F �������� ��������� ���������
  ������ -FExtUtils.pas ����� ����� ExtUtils.pas }

function GetParamValue(const Param: string): string;
function GetParamValueDef(const Param: string; const Default: string): string;

{ �������, �������� � ����������� ��������� � ������������ ������� �
  �������� �������� ������� ���������� False, ���� ������� ��������
  �������. }

function ArrayInsert(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
function ArrayDelete(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
function ArrayExchange(Items: Pointer; Count, ItemSize: Integer; Index1, Index2: Integer): Boolean;
function ArrayMove(Items: Pointer; Count, ItemSize: Integer; CurIndex, NewIndex: Integer): Boolean;

{ ������������ ������. ���� ��������� ��������� ��������� �� nil.  }

procedure FreeMemAndNil(var P; Size: Integer);

{$IFNDEF EXT_D5_UP}

procedure FreeAndNil(var Obj);

{$ENDIF}

{ ������� ������ ��������� 4-�������� ���������. }

procedure FillDWord(var Dest; Count, Value: Integer); register;

implementation

uses
  ExtStrUtils;

{ ������� ������ � ������������� ����� }

function StrToFloatDef(const S: string; Default: Extended): Extended;
begin
  if not TextToFloat(PChar(S), Result, fvExtended) then Result := Default;
end;

{ ��������� ��������� �������������� �������� }

function ExceptionMsg(E: Exception): string;
begin
  Result := RemoveLineBreaks(TrimCharRight(E.Message, '.'));
end;

{ ����� ��������� }

function FindParam(const Param: string; PartialOK: Boolean; var Value: string): Boolean;
var
  I, P: Integer;
begin
  { ���������� ��������� ��������� ������ }
  for I := 1 to ParamCount do
  begin
    { �������� �������� }
    Value := ParamStr(I);
    { ��������� ��������� ���������� }
    if PartialOK then
    begin
      { ���� � ��������� ������� }
      P := CasePos(Param, Value, False);
      if P = 1 then
      begin
        { �������� ���������� - ����� }
        Result := True;
        Exit;
      end;
    end
    else
      { ���������� }
      if AnsiCompareText(Param, Value) = 0 then
      begin
        { �������� ���������� - ����� }
        Result := True;
        Exit;
      end;
  end;
  { ��������� ��� }
  Value := '';
  Result := False;
end;

{ ����������� ������� ��������� ��������� ������ }

function ParamExists(const Param: string; PartialOK: Boolean): Boolean;
var
  Value: string;
begin
  Result := FindParam(Param, PartialOK, Value);
end;

function ParamsExists(const Params: array of string; PartialOK, CheckAll: Boolean): Boolean;
var
  I, Count: Integer;
begin
  Count := 0;
  { ���������� ��������� }
  for I := Low(Params) to High(Params) do
    if ParamExists(Params[I], PartialOK) then Inc(Count);
  { ��������� }
  if CheckAll then
    Result := Count = High(Params) - Low(Params) + 1
  else
   Result := Count > 0;
end;

{ ����������� �������� ��������� }

function GetParamValue(const Param: string): string;
begin
  Result := GetParamValueDef(Param, '');
end;

function GetParamValueDef(const Param: string; const Default: string): string;
var
  Value: string;
begin
  if FindParam(Param, True, Value) then
    Result := Copy(Value, Length(Param) + 1, MaxInt)
  else
    Result := Default;
end;

{ �������, �������� � ����������� ��������� � ������������ ������� �
  �������� �������� ��������� }

function ArrayInsert(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
var
  PI, PI1: PChar;
begin
  { ��������� ������ }
  if (Index < 0) or (Index > Count) then
  begin
    Result := False;
    Exit;
  end;
  { ��������� �� ������� Index � ��������� }
  PI := PChar(Items) + Index * ItemSize;
  PI1 := PChar(Items) + (Index + 1) * ItemSize;
  { ��������� }
  if Index < Count then Move(PI^, PI1^, (Count - Index) * ItemSize);
  if Item <> nil then Move(Item^, PI^, ItemSize);
  { ������� �������� }
  Result := True;
end;

function ArrayDelete(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
var
  PI, PI1: PChar;
begin
  { ��������� ������ }
  if (Index < 0) or (Index >= Count) then
  begin
    Result := False;
    Exit;
  end;
  { ��������� �� ������� Index � ��������� }
  PI := PChar(Items) + Index * ItemSize;
  PI1 := PChar(Items) + (Index + 1) * ItemSize;
  { ���������� �������, ������� }
  if Item <> nil then Move(PI^, Item^, ItemSize);
  if Index < Count then System.Move(PI1^, PI^, (Count - Index) * ItemSize);
  { ������� ������ }
  Result := True;
end;

function ArrayExchange(Items: Pointer; Count, ItemSize: Integer; Index1, Index2: Integer): Boolean;
var
  PI1, PI2: Pointer;
  Item: Pointer;
begin
  Result := True;
  { �� ������ ������� ��� � ����� }
  if Index1 <> Index2 then
  begin
    { ��������� ������� }
    if (Index1 < 0) or (Index1 >= Count) or (Index2 < 0) or (Index2 >= Count) then
    begin
      Result := False;
      Exit;
    end;
    { ����� ��� ������� }
    GetMem(Item, ItemSize);
    try
      { ��������� �� �������� Index1 Index2 }
      PI1 := PChar(Items) + Index1 * ItemSize;
      PI2 := PChar(Items) + Index2 * ItemSize;
      { ������ ������� }
      Move(PI1^, Item^, ItemSize);
      Move(PI2^, PI1^, ItemSize);
      Move(Item^, PI2^, ItemSize);
    finally
      FreeMem(Item, ItemSize);
    end;
  end;
end;

function ArrayMove(Items: Pointer; Count, ItemSize: Integer; CurIndex, NewIndex: Integer): Boolean;
var
  Item: Pointer;
begin
  Result := True;
  { ���� �� ������� ������� }
  if CurIndex <> NewIndex then
  begin
    { ��������� ������� }
    if (NewIndex < 0) or (NewIndex >= Count) then
    begin
      Result := False;
      Exit;
    end;
    { ����� ��� ������� }
    GetMem(Item, ItemSize);
    try
      { ����������� }
      ArrayDelete(Items, Count, ItemSize, CurIndex, Item);
      ArrayInsert(Items, Count, ItemSize, NewIndex, Item);
    finally
      FreeMem(Item, ItemSize);
    end;
  end;
end;

{ ������������ ������. ���� ��������� ��������� ��������� �� nil.  }

procedure FreeMemAndNil(var P; Size: Integer);
var
  Mem: Pointer;
begin
  Mem := Pointer(P);
  Pointer(P) := nil;
  if Mem <> nil then FreeMem(Mem, Size);
end;

{$IFNDEF EXT_D5_UP}

procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;
  P.Free;
end;

{$ENDIF}

{ ������� ������ ��������� 4-�������� ��������� }

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI                 
end;

end.
