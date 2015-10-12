{
  Библиотека дополнительных утилит

  Дополнительные процедуры и функции общего назначения

  © Роман М. Мочалов, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtSysUtils;

interface

{$I EXT.INC}

uses
  SysUtils;

{ Перевод строки в верщественное число. При возникновении ошибки не
  создает исключение, но присваивает результату значение по умолчанию. }

function StrToFloatDef(const S: string; Default: Extended): Extended;

{ Обработка сообщения исключительной ситуации (Exception): удаление
  переносов строки, точки на конце строки. }

function ExceptionMsg(E: Exception): string;

{ Получение первого попавшегося параметра командной строки, который
  равен указанной строке (PartialOK = True) или начинается на указанную
  строку (PartialOK = False). }

function FindParam(const Param: string; PartialOK: Boolean; var Value: string): Boolean;

{ Определение наличия параметра командной строки. }

function ParamExists(const Param: string; PartialOK: Boolean): Boolean;
function ParamsExists(const Params: array of string; PartialOK, CheckAll: Boolean): Boolean;

{ Определение значения параметра. Возвращает строку, слудующую сразу за
  указанныой строкой. Например, для строки -F значение параметра командной
  строки -FExtUtils.pas будет равно ExtUtils.pas }

function GetParamValue(const Param: string): string;
function GetParamValueDef(const Param: string; const Default: string): string;

{ Вставка, удаление и перемещение элементов в произвольном массиве с
  заданным размером Функции врзвращают False, если указаны неверные
  индексы. }

function ArrayInsert(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
function ArrayDelete(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
function ArrayExchange(Items: Pointer; Count, ItemSize: Integer; Index1, Index2: Integer): Boolean;
function ArrayMove(Items: Pointer; Count, ItemSize: Integer; CurIndex, NewIndex: Integer): Boolean;

{ Освобождение памяти. Пред удалением проверяем указатель на nil.  }

procedure FreeMemAndNil(var P; Size: Integer);

{$IFNDEF EXT_D5_UP}

procedure FreeAndNil(var Obj);

{$ENDIF}

{ Заливка буфера указанным 4-байтовым значением. }

procedure FillDWord(var Dest; Count, Value: Integer); register;

implementation

uses
  ExtStrUtils;

{ Перевод строки в верщественное число }

function StrToFloatDef(const S: string; Default: Extended): Extended;
begin
  if not TextToFloat(PChar(S), Result, fvExtended) then Result := Default;
end;

{ Обработка сообщения исключительной ситуации }

function ExceptionMsg(E: Exception): string;
begin
  Result := RemoveLineBreaks(TrimCharRight(E.Message, '.'));
end;

{ Поиск параметра }

function FindParam(const Param: string; PartialOK: Boolean; var Value: string): Boolean;
var
  I, P: Integer;
begin
  { перебираем параметры командной строки }
  for I := 1 to ParamCount do
  begin
    { получаем параметр }
    Value := ParamStr(I);
    { проверяем частичное совпадение }
    if PartialOK then
    begin
      { ищем в параметре искомый }
      P := CasePos(Param, Value, False);
      if P = 1 then
      begin
        { параметр существует - выход }
        Result := True;
        Exit;
      end;
    end
    else
      { сравниваем }
      if AnsiCompareText(Param, Value) = 0 then
      begin
        { параметр существует - выход }
        Result := True;
        Exit;
      end;
  end;
  { параметра нет }
  Value := '';
  Result := False;
end;

{ Определение наличия параметра командной строки }

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
  { перебираем параметры }
  for I := Low(Params) to High(Params) do
    if ParamExists(Params[I], PartialOK) then Inc(Count);
  { результат }
  if CheckAll then
    Result := Count = High(Params) - Low(Params) + 1
  else
   Result := Count > 0;
end;

{ Определение значения параметра }

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

{ Вставка, удаление и перемещение элементов в произвольном массиве с
  заданным размером элеменнта }

function ArrayInsert(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
var
  PI, PI1: PChar;
begin
  { проверяем индекс }
  if (Index < 0) or (Index > Count) then
  begin
    Result := False;
    Exit;
  end;
  { указатели на элемент Index и следующий }
  PI := PChar(Items) + Index * ItemSize;
  PI1 := PChar(Items) + (Index + 1) * ItemSize;
  { вставляем }
  if Index < Count then Move(PI^, PI1^, (Count - Index) * ItemSize);
  if Item <> nil then Move(Item^, PI^, ItemSize);
  { элемент вставлен }
  Result := True;
end;

function ArrayDelete(Items: Pointer; Count, ItemSize: Integer; Index: Integer; Item: Pointer): Boolean;
var
  PI, PI1: PChar;
begin
  { проверяем индекс }
  if (Index < 0) or (Index >= Count) then
  begin
    Result := False;
    Exit;
  end;
  { указатели на элемент Index и следующий }
  PI := PChar(Items) + Index * ItemSize;
  PI1 := PChar(Items) + (Index + 1) * ItemSize;
  { запоминаем элемент, удаляем }
  if Item <> nil then Move(PI^, Item^, ItemSize);
  if Index < Count then System.Move(PI1^, PI^, (Count - Index) * ItemSize);
  { элемент удален }
  Result := True;
end;

function ArrayExchange(Items: Pointer; Count, ItemSize: Integer; Index1, Index2: Integer): Boolean;
var
  PI1, PI2: Pointer;
  Item: Pointer;
begin
  Result := True;
  { не меняем элемент сам с собой }
  if Index1 <> Index2 then
  begin
    { проверяем индексы }
    if (Index1 < 0) or (Index1 >= Count) or (Index2 < 0) or (Index2 >= Count) then
    begin
      Result := False;
      Exit;
    end;
    { буфер под элемент }
    GetMem(Item, ItemSize);
    try
      { указатели на элементы Index1 Index2 }
      PI1 := PChar(Items) + Index1 * ItemSize;
      PI2 := PChar(Items) + Index2 * ItemSize;
      { меняем местами }
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
  { надо ли двигать элемент }
  if CurIndex <> NewIndex then
  begin
    { проверяем индексы }
    if (NewIndex < 0) or (NewIndex >= Count) then
    begin
      Result := False;
      Exit;
    end;
    { буфер под элемент }
    GetMem(Item, ItemSize);
    try
      { передвигаем }
      ArrayDelete(Items, Count, ItemSize, CurIndex, Item);
      ArrayInsert(Items, Count, ItemSize, NewIndex, Item);
    finally
      FreeMem(Item, ItemSize);
    end;
  end;
end;

{ Освобождение памяти. Пред удалением проверяем указатель на nil.  }

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

{ Заливка буфера указанным 4-байтовым значением }

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
