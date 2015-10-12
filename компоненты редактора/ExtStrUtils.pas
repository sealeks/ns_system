{
  Библиотека дополнительных утилит

  Дополнительные процедуры и функции для работы со строками

  © Роман М. Мочалов, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtStrUtils;

interface

{$I EXT.INC}

uses
  SysUtils, Classes, Math;

type
  TCharSet = set of Char;

{ Поиск подстроки Substr в строке S. Если параметр MatchCase выставлен в
  False, то поиск производится без зависимости от регистра. }

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;

{ Замена в строке S символа C1 на символ C2. }

function ReplaceChar(const S: string; C1, C2: Char): string;

{ Замена в строке S всех символов, указанных в массиве C1 на символ C2. }

function ReplaceChars(const S: string; C1: array of Char; C2: Char): string;

{ Замена в строке S первой найденной подстроки S1 на подстроку S2. Замена
  производится без зависимости от регистра символов. }

function ReplaceStr(const S: string; S1, S2: string): string;

{ Расширенный вариант функции замены в строке S подстроки S1 на подстроку S2.
  Возможна замена всех втречающихся подстрок S1 с указанием зависимости от
  регистра символов. }

function ReplaceStrEx(const S: string; S1, S2: string; ReplaceAll, MatchCase: Boolean): string;

{ Удаление из строки S всех симовлов, указанных в массиве C или строке C. }

function RemoveChars(const S: string; C: TCharSet): string;
function ExtractChars(const S: string; const C: string): string;

{ Удаление символов переноса из строки. Сиволы переноса заменяются на
  пробел. }

function RemoveLineBreaks(const S: string): string;

{ Удаление двойных пробелов из строки. }

function RemoveDoubleSpace(const S: string): string;

{ Отсечение слева и справа от строки S указанного символа C. }

function TrimChar(const S: string; C: Char): string;
function TrimChars(const S: string; C: TCharSet): string;

{ Отсечение слева от строки S указанного символа C. }

function TrimCharLeft(const S: string; C: Char): string;

{ Отсечение справа от строки S указанного символа C. }

function TrimCharRight(const S: string; C: Char): string;

{ Дополнение строки S слева символами C до длины Len. }

function InsertCharLeft(const S: string; C: Char; Len: Integer): string;

{ Дополнение строки S справа символами C до длины Len. }

function InsertCharRight(const S: string; C: Char; Len: Integer): string;

{ Усечение строки S слева до длины MaxLen. Если длина строки менее
  указанной длины, то строка возвращается без изменения. }

function TruncLeft(const S: string; MaxLen: Integer): string;

{ Усечение строки S справа до длины MaxLen. Если длина строки менее
  указанной длины, то строка возвращается без изменения. }

function TruncRight(const S: string; MaxLen: Integer): string;

{ Функции для определения имени параметра и значения строки
  вида Параметр=значение. Используются для быстрого определения параметра
  и значения из списка StringList. }

function ExtractParamName(const S: string; Delimiter: Char): string;
function ExtractParamValue(const S: string; Delimiter: Char): string;

{ Определение равенства набора строк. }

function StringsEqual(List: array of string; MatchCase: Boolean): Boolean;

{ Определение наличия хотябы одной пустрой строки в указанном наборе. }

function StringsEmpty(List: array of string): Boolean;

{ Определение количества строк в соотвествии с переносами. }

function GetLineCount(const S: string): Integer;

{$IFDEF EXT_D2}

{ Returns the smallest and largest value in the data array (MIN/MAX) }

function MinIntValue(const Data: array of Integer): Integer;
function MaxIntValue(const Data: array of Integer): Integer;

type
  TIdentMapEntry = record
    Value: Integer;
    Name: String;
  end;

function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean;
function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;

{$ENDIF}

{ Перевод идентификатора Ident в значение в соотвествием с указанным списком
  возможных соотвествий Map. Если указанного идентификатора нет в списке,
  возвращается значение по умолчанию Default. }

function IdentToIntDef(const Ident: string; Default: Longint; const Map: array of TIdentMapEntry): Longint;

{ Перевод Значения Int в идентификатор в соотвествием с указанным списком
  возможных соотвествий Map. Если указанного значения нет в списке,
  возвращается значение по умолчанию Default. }

function IntToIdentDef(Int: Longint; const Default: string; const Map: array of TIdentMapEntry): string;

{ Получение индекса идентификатора Name в списке Map. Если идентификатора
  в списке нет, возвращается индекс по умолчанию. }

function GetIdentNameIndex(const Name: string; const Map: array of TIdentMapEntry): Integer;
function GetIdentNameIndexDef(const Name: string; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;

{ Получение индекса значения Value в списке Map. Если значения в списке нет,
  возвращается индекс по умолчанию. }

function GetIdentValueIndex(Value: Longint; const Map: array of TIdentMapEntry): Integer;
function GetIdentValueIndexDef(Value: Longint; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;

{ Заполненине произвольного списка идентификаторами списка Map. Заполнение
  производится в путем вызова процедуры Proc в ходе перебора списка Map.
  Возвращает количество элементов в списке. }

function GetIdentsList(const Map: array of TIdentMapEntry; Proc: TGetStrProc): Integer;

{ Заполненине списка Strings идентификаторами из списка Map. }

function GetIdentsStringList(const Map: array of TIdentMapEntry; Strings: TStrings): Integer;

{$IFNDEF EXT_D4_UP}

{ Перевод строки значений, разделенных указанным символом, в список строк. }
type
  TSysCharSet = set of Char;

function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings): Integer;

{$ENDIF}

{ Перевод списка строк в одну строку с использование указанного разделителя. }

function ExpandStrings(Strings: TStrings; const Separator: string): string;

{ Сравнение двух строк с учетом условий поиска. }

function CompareStrEx(const S1, S2: string; WholeWord, MatchCase: Boolean): Boolean;

implementation

{ Поиск подстроки Substr в строке S }

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;
begin
  if not MatchCase then
  begin
    { все в верхний регистр }
    Substr := AnsiUpperCase(Substr);
    S := AnsiUpperCase(S);
  end;
  { ищем }
{$IFDEF EXT_D2}
  Result := Pos(Substr, S);
{$ELSE}
  Result := AnsiPos(Substr, S);
{$ENDIF}
end;

{ Замена в строке S символа C1 на символ C2 }

function ReplaceChar(const S: string; C1, C2: Char): string;
var
  I: Integer;
begin
  { устанавливаем результат в исходную строку }
  Result := S;
  { меняем символ }
  for I := 1 to Length(Result) do
    if Result[I] = C1 then Result[I] := C2;
end;

{ Замена в строке S всех символов, указанных в массиве C1 на символ C2 }

function ReplaceChars(const S: string; C1: array of Char; C2: Char): string;
var
  I, J: Integer;
begin
  { устанавливаем результат в исходную строку }
  Result := S;
  { меняем символ }
  for I := 1 to Length(Result) do
    for J := Low(C1) to High(C1) do
      if Result[I] = C1[J] then Result[I] := C2;
end;

{ Замена в строке S первой найденной подстроки S1 на подстроку S2 }

function ReplaceStr(const S: string; S1, S2: string): string;
begin
  Result := ReplaceStrEx(S, S1, S2, False, False);
end;

{ Расширенный вариант функции замены в строке S подстроки S1 на подстроку S2 }

function ReplaceStrEx(const S: string; S1, S2: string; ReplaceAll, MatchCase: Boolean): string;
var
  P: Integer;
begin
  Result := S;
  P := CasePos(S1, Result, MatchCase);
  while P <> 0 do
  begin
    Delete(Result, P, Length(S1));
    Insert(S2, Result, P);
    P := CasePos(S1, Result, MatchCase);
  end;
end;

{ Удаление из строки S всех симовлов, указанных в массиве C }

function RemoveChars(const S: string; C: TCharSet): string;
var
  I, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  for I := 1 to L do
    { есть ли текущий символ среди удаляемых }
    if not (S[I] in C) then
    begin
      Inc(N);
      Result[N] := S[I];
    end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

function ExtractChars(const S: string; const C: string): string;
var
  I, J, K, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  for I := 1 to L do
  begin
    K := 0;
    { ищем текущий символ среди удаляемых }
    for J := 1 to Length(C) do
      if S[I] = C[J] then
      begin
        Inc(K);
        Break;
      end;
    { если не было - добавляем в результат }
    if K = 0 then
    begin
      Inc(N);
      Result[N] := S[I];
    end;
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

{ Удаление символов переноса из строки }

function RemoveLineBreaks(const S: string): string;
var
  I, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { является ли текущий символ символом переноса строки }
    if S[I] in [#13, #10] then
    begin
      { да - меняем его на пробел }
      Result[N] := ' ';
      { следующие символы переноса игнорируем }
      while (I < L) and (S[I + 1] in [#13, #10]) do Inc(I);
    end
    else
      { нет - берем его }
      Result[N] := S[I];
    { следующий символ }
    Inc(I);
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

{ Удаление двойных пробелов из строки }

function RemoveDoubleSpace(const S: string): string;
var
  I, L, N: Integer;
begin
  { длина строки }
  L := Length(S);
  { устанавливаем длину результата в длину строки }
  SetString(Result, nil, L);
  N := 0;
  { перебираем символы строки }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { является ли текущий символ пробелом }
    if S[I] = ' ' then
    begin
      { да - оставляем его }
      Result[N] := ' ';
      { следующие пробелы игнорируем }
      while (I < L) and (S[I + 1] = ' ') do Inc(I);
    end
    else
      { нет - берем его }
      Result[N] := S[I];
    { следующий символ }
    Inc(I);
  end;
  { устанавливаем реальную длину строки результата }
  SetLength(Result, N);
end;

{ Отсечение слева и справа от строки S указанного символа C }

function TrimChar(const S: string; C: Char): string;
begin
  Result := TrimChars(S, [C]);
end;

function TrimChars(const S: string; C: TCharSet): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] in C) do Inc(I);
  if I > L then
  begin
    Result := '';
    Exit;
  end;
  while S[L] in C do Dec(L);
  Result := Copy(S, I, L - I + 1);
end;

{ Отсечение слева от строки S указанного символа C. }

function TrimCharLeft(const S: string; C: Char): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] = C) do Inc(I);
  Result := Copy(S, I, Maxint);
end;

{ Отсечение справа от строки S указанного символа C. }

function TrimCharRight(const S: string; C: Char): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = C) do Dec(I);
  if I <> 0 then Result := Copy(S, 1, I) else Result := '';
end;

{ Дополнение строки S слева символами C до длины Len }

function InsertCharLeft(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  L := Length(S);
  { прверяем длину }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { формируем добавок }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { результат }
  Result := A + S;
end;

{ Дополнение строки S справа символами C до длины Len. }

function InsertCharRight(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  { получаем длину строки }
  L := Length(S);
  { проверяем длину }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { формируем добавок }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { результат }
  Result := S + A;
end;

{ Усечение строки S слева до длины MaxLen }

function TruncLeft(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { получаем длину строки }
  L := Length(S);
  { если длина больше - отрезаем сколько нужно }
  if L > MaxLen then
  begin
    Result := Copy(S, MaxIntValue([1, L - MaxLen]), MaxLen);
    Exit;
  end;
  { возвращаем строку без изменения }
  Result := S;
end;

{ Усечение строки S справа до длины MaxLen }

function TruncRight(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { получаем длину строки }
  L := Length(S);
  { если длина больше - отрезаем сколько нужно }
  if L > MaxLen then
  begin
    Result := Copy(S, 1, MaxLen);
    Exit;
  end;
  { возвращаем строку без изменения }
  Result := S;
end;

{ Функции для определения имени параметра и значения строки } 

function ExtractParamName(const S: string; Delimiter: Char): string;
var
  P: Integer;
begin
  Result := S;
{$IFDEF EXT_D2}
  P := Pos(Delimiter, Result);
{$ELSE}
  P := AnsiPos(Delimiter, Result);
{$ENDIF}
  if P <> 0 then SetLength(Result, P - 1);
end;

function ExtractParamValue(const S: string; Delimiter: Char): string;
begin
  Result := Copy(S, Length(ExtractParamName(S, Delimiter)) + 2, MaxInt);
end;

{ Определение равенства набора строк. }

function StringsEqual(List: array of string; MatchCase: Boolean): Boolean;
var
  I: Integer;
  S1, S2: string;
begin
  Result := False;
  { получаем первую строку }
  S1 := List[Low(List)];
  if not MatchCase then S1 := AnsiUpperCase(S1);
  { преребираем }
  for I := Low(List) + 1 to High(List) do
  begin
    { получаем вторую строку }
    S2 := List[I];
    if not MatchCase then S2 := AnsiUpperCase(S2);
    { сравниваем }
    if AnsiCompareStr(S1, S2) <> 0 then Exit;
  end;
  { все равны }
  Result := True;
end;

{ Определение наличия хотябы одной пустрой строки в указанном наборе }

function StringsEmpty(List: array of string): Boolean;
var
  I: Integer;
begin
  { преребираем }
  for I := Low(List) to High(List) do
    { определяем длину }
    if Length(List[I]) = 0 then
    begin
      Result := False;
      Exit;
    end;
  { все пусты }
  Result := True;
end;

{ Определение количество строк в соотвествии с переносами }

function GetLineCount(const S: string): Integer;
var
  P: PChar;
begin
  Result := 0;
  { ищем перенос строки }
  P := Pointer(S);
  while P^ <> #0 do
  begin
    while not (P^ in [#0, #10, #13]) do Inc(P);
    { была строка }
    Inc(Result);
    { учитываем символы переноса }
    if P^ = #13 then Inc(P);
    if P^ = #10 then Inc(P);
  end;
end;

{$IFDEF EXT_D2}

{ Returns the smallest and largest value in the data array (MIN/MAX) }

function MinIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result > Data[I] then Result := Data[I];
end;

function MaxIntValue(const Data: array of Integer): Integer;
var
  I: Integer;
begin
  Result := Data[Low(Data)];
  for I := Low(Data) + 1 to High(Data) do
    if Result < Data[I] then Result := Data[I];
end;

function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if CompareText(Map[I].Name, Ident) = 0 then
    begin
      Result := True;
      Int := Map[I].Value;
      Exit;
    end;
  Result := False;
end;

function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if Map[I].Value = Int then
    begin
      Result := True;
      Ident := Map[I].Name;
      Exit;
    end;
  Result := False;
end;

{$ENDIF}

{ Перевод идентификатора Ident в значение в соотвествием со списком Map }

function IdentToIntDef(const Ident: string; Default: Longint; const Map: array of TIdentMapEntry): Longint;
begin
  if not IdentToInt(Ident, Result, Map) then Result := Default;
end;

{ Перевод значения Int в идентификатор в соотвествием со списком Map }

function IntToIdentDef(Int: Longint; const Default: string; const Map: array of TIdentMapEntry): string;
begin
  if not IntToIdent(Int, Result, Map) then Result := Default;
end;

{ Получение индекса идентификатора Name в списке Map }

function GetIdentNameIndex(const Name: string; const Map: array of TIdentMapEntry): Integer;
begin
  Result := GetIdentNameIndexDef(Name, -1, Map);
end;

function GetIdentNameIndexDef(const Name: string; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if CompareText(Map[I].Name, Name) = 0 then
    begin
      Result := I;
      Exit;
    end;
  Result := DefIndex;
end;

{ Получение индекса значения Value в списке Map }

function GetIdentValueIndex(Value: Longint; const Map: array of TIdentMapEntry): Integer;
begin
  Result := GetIdentValueIndexDef(Value, -1, Map);
end;

function GetIdentValueIndexDef(Value: Longint; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;
var
  I: Integer;
begin
  for I := Low(Map) to High(Map) do
    if Map[I].Value = Value then
    begin
      Result := I;
      Exit;
    end;
  Result := DefIndex;
end;

{ Заполненине произвольного списка идентификаторами списка Map. Заполнение
  производится в путем вызова процедуры Proc в ходе перебора списка Map. }

function GetIdentsList(const Map: array of TIdentMapEntry; Proc: TGetStrProc): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(Map) to High(Map) do
  begin
    Proc(Map[I].Name);
    Inc(Result);
  end;
end;

{ Заполненине списка Strings идентификаторами списка Map. }

function GetIdentsStringList(const Map: array of TIdentMapEntry; Strings: TStrings): Integer;
type
  TGetStrFunc = function(const S: string): Integer of object;
var
  Proc: TGetStrFunc;
begin
  { очищием список }
  Strings.Clear;
  { заполняем }
  Proc := Strings.Add;
  Result := GetIdentsList(Map, TGetStrProc(Proc));
end;

{$IFNDEF EXT_D4_UP}

{ Перевод строки значений, разделенных указанным символом, в список строк. }

function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings): Integer;
var
  Head, Tail: PChar;
  EOS, InQuote: Boolean;
  QuoteChar: Char;
  Item: string;
begin
  Result := 0;
  if (Content = nil) or (Content^=#0) or (Strings = nil) then Exit;
  Tail := Content;
  InQuote := False;
  QuoteChar := #0;
  Strings.BeginUpdate;
  try
    repeat
      while Tail^ in WhiteSpace + [#13, #10] do Inc(Tail);
      Head := Tail;
      while True do
      begin
        while (InQuote and not (Tail^ in ['''', '"', #0])) or
          not (Tail^ in Separators + [#0, #13, #10, '''', '"']) do Inc(Tail);
        if Tail^ in ['''', '"'] then
        begin
          if (QuoteChar <> #0) and (QuoteChar = Tail^) then
            QuoteChar := #0
          else QuoteChar := Tail^;
          InQuote := QuoteChar <> #0;
          Inc(Tail);
        end else Break;
      end;
      EOS := Tail^ = #0;
      if (Head <> Tail) and (Head^ <> #0) then
      begin
        if Strings <> nil then
        begin
          SetString(Item, Head, Tail - Head);
          Strings.Add(Item);
        end;
        Inc(Result);
      end;
      Inc(Tail);
    until EOS;
  finally
    Strings.EndUpdate;
  end;
end;

{$ENDIF}

{ Перевод списка строк в одну строку с использование указанного разделителя }

function ExpandStrings(Strings: TStrings; const Separator: string): string;
var
  I: Integer;
begin
  Result := '';
  if Strings.Count > 0 then
  begin
    Result := Strings[0]; 
    for I := 1 to Strings.Count - 1 do Result := Result + Separator + Strings[I];
  end;
end;

{ Сравнение двух строк с учетом условий поиска. }

function CompareStrEx(const S1, S2: string; WholeWord, MatchCase: Boolean): Boolean;
begin
  if WholeWord then
    if MatchCase then
      Result := AnsiCompareStr(S1, S2) = 0
    else
      Result := AnsiCompareText(S1, S2) = 0
  else
    Result := CasePos(S1, S2, MatchCase) <> 0;
end;

end.
