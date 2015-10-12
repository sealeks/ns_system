{
  ���������� �������������� ������

  �������������� ��������� � ������� ��� ������ �� ��������

  � ����� �. �������, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtStrUtils;

interface

{$I EXT.INC}

uses
  SysUtils, Classes, Math;

type
  TCharSet = set of Char;

{ ����� ��������� Substr � ������ S. ���� �������� MatchCase ��������� �
  False, �� ����� ������������ ��� ����������� �� ��������. }

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;

{ ������ � ������ S ������� C1 �� ������ C2. }

function ReplaceChar(const S: string; C1, C2: Char): string;

{ ������ � ������ S ���� ��������, ��������� � ������� C1 �� ������ C2. }

function ReplaceChars(const S: string; C1: array of Char; C2: Char): string;

{ ������ � ������ S ������ ��������� ��������� S1 �� ��������� S2. ������
  ������������ ��� ����������� �� �������� ��������. }

function ReplaceStr(const S: string; S1, S2: string): string;

{ ����������� ������� ������� ������ � ������ S ��������� S1 �� ��������� S2.
  �������� ������ ���� ������������ �������� S1 � ��������� ����������� ��
  �������� ��������. }

function ReplaceStrEx(const S: string; S1, S2: string; ReplaceAll, MatchCase: Boolean): string;

{ �������� �� ������ S ���� ��������, ��������� � ������� C ��� ������ C. }

function RemoveChars(const S: string; C: TCharSet): string;
function ExtractChars(const S: string; const C: string): string;

{ �������� �������� �������� �� ������. ������ �������� ���������� ��
  ������. }

function RemoveLineBreaks(const S: string): string;

{ �������� ������� �������� �� ������. }

function RemoveDoubleSpace(const S: string): string;

{ ��������� ����� � ������ �� ������ S ���������� ������� C. }

function TrimChar(const S: string; C: Char): string;
function TrimChars(const S: string; C: TCharSet): string;

{ ��������� ����� �� ������ S ���������� ������� C. }

function TrimCharLeft(const S: string; C: Char): string;

{ ��������� ������ �� ������ S ���������� ������� C. }

function TrimCharRight(const S: string; C: Char): string;

{ ���������� ������ S ����� ��������� C �� ����� Len. }

function InsertCharLeft(const S: string; C: Char; Len: Integer): string;

{ ���������� ������ S ������ ��������� C �� ����� Len. }

function InsertCharRight(const S: string; C: Char; Len: Integer): string;

{ �������� ������ S ����� �� ����� MaxLen. ���� ����� ������ �����
  ��������� �����, �� ������ ������������ ��� ���������. }

function TruncLeft(const S: string; MaxLen: Integer): string;

{ �������� ������ S ������ �� ����� MaxLen. ���� ����� ������ �����
  ��������� �����, �� ������ ������������ ��� ���������. }

function TruncRight(const S: string; MaxLen: Integer): string;

{ ������� ��� ����������� ����� ��������� � �������� ������
  ���� ��������=��������. ������������ ��� �������� ����������� ���������
  � �������� �� ������ StringList. }

function ExtractParamName(const S: string; Delimiter: Char): string;
function ExtractParamValue(const S: string; Delimiter: Char): string;

{ ����������� ��������� ������ �����. }

function StringsEqual(List: array of string; MatchCase: Boolean): Boolean;

{ ����������� ������� ������ ����� ������� ������ � ��������� ������. }

function StringsEmpty(List: array of string): Boolean;

{ ����������� ���������� ����� � ����������� � ����������. }

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

{ ������� �������������� Ident � �������� � ������������ � ��������� �������
  ��������� ����������� Map. ���� ���������� �������������� ��� � ������,
  ������������ �������� �� ��������� Default. }

function IdentToIntDef(const Ident: string; Default: Longint; const Map: array of TIdentMapEntry): Longint;

{ ������� �������� Int � ������������� � ������������ � ��������� �������
  ��������� ����������� Map. ���� ���������� �������� ��� � ������,
  ������������ �������� �� ��������� Default. }

function IntToIdentDef(Int: Longint; const Default: string; const Map: array of TIdentMapEntry): string;

{ ��������� ������� �������������� Name � ������ Map. ���� ��������������
  � ������ ���, ������������ ������ �� ���������. }

function GetIdentNameIndex(const Name: string; const Map: array of TIdentMapEntry): Integer;
function GetIdentNameIndexDef(const Name: string; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;

{ ��������� ������� �������� Value � ������ Map. ���� �������� � ������ ���,
  ������������ ������ �� ���������. }

function GetIdentValueIndex(Value: Longint; const Map: array of TIdentMapEntry): Integer;
function GetIdentValueIndexDef(Value: Longint; DefIndex: Integer; const Map: array of TIdentMapEntry): Integer;

{ ����������� ������������� ������ ���������������� ������ Map. ����������
  ������������ � ����� ������ ��������� Proc � ���� �������� ������ Map.
  ���������� ���������� ��������� � ������. }

function GetIdentsList(const Map: array of TIdentMapEntry; Proc: TGetStrProc): Integer;

{ ����������� ������ Strings ���������������� �� ������ Map. }

function GetIdentsStringList(const Map: array of TIdentMapEntry; Strings: TStrings): Integer;

{$IFNDEF EXT_D4_UP}

{ ������� ������ ��������, ����������� ��������� ��������, � ������ �����. }
type
  TSysCharSet = set of Char;

function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar; Strings: TStrings): Integer;

{$ENDIF}

{ ������� ������ ����� � ���� ������ � ������������� ���������� �����������. }

function ExpandStrings(Strings: TStrings; const Separator: string): string;

{ ��������� ���� ����� � ������ ������� ������. }

function CompareStrEx(const S1, S2: string; WholeWord, MatchCase: Boolean): Boolean;

implementation

{ ����� ��������� Substr � ������ S }

function CasePos(Substr: string; S: string; MatchCase: Boolean): Integer;
begin
  if not MatchCase then
  begin
    { ��� � ������� ������� }
    Substr := AnsiUpperCase(Substr);
    S := AnsiUpperCase(S);
  end;
  { ���� }
{$IFDEF EXT_D2}
  Result := Pos(Substr, S);
{$ELSE}
  Result := AnsiPos(Substr, S);
{$ENDIF}
end;

{ ������ � ������ S ������� C1 �� ������ C2 }

function ReplaceChar(const S: string; C1, C2: Char): string;
var
  I: Integer;
begin
  { ������������� ��������� � �������� ������ }
  Result := S;
  { ������ ������ }
  for I := 1 to Length(Result) do
    if Result[I] = C1 then Result[I] := C2;
end;

{ ������ � ������ S ���� ��������, ��������� � ������� C1 �� ������ C2 }

function ReplaceChars(const S: string; C1: array of Char; C2: Char): string;
var
  I, J: Integer;
begin
  { ������������� ��������� � �������� ������ }
  Result := S;
  { ������ ������ }
  for I := 1 to Length(Result) do
    for J := Low(C1) to High(C1) do
      if Result[I] = C1[J] then Result[I] := C2;
end;

{ ������ � ������ S ������ ��������� ��������� S1 �� ��������� S2 }

function ReplaceStr(const S: string; S1, S2: string): string;
begin
  Result := ReplaceStrEx(S, S1, S2, False, False);
end;

{ ����������� ������� ������� ������ � ������ S ��������� S1 �� ��������� S2 }

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

{ �������� �� ������ S ���� ��������, ��������� � ������� C }

function RemoveChars(const S: string; C: TCharSet): string;
var
  I, L, N: Integer;
begin
  { ����� ������ }
  L := Length(S);
  { ������������� ����� ���������� � ����� ������ }
  SetString(Result, nil, L);
  N := 0;
  { ���������� ������� ������ }
  for I := 1 to L do
    { ���� �� ������� ������ ����� ��������� }
    if not (S[I] in C) then
    begin
      Inc(N);
      Result[N] := S[I];
    end;
  { ������������� �������� ����� ������ ���������� }
  SetLength(Result, N);
end;

function ExtractChars(const S: string; const C: string): string;
var
  I, J, K, L, N: Integer;
begin
  { ����� ������ }
  L := Length(S);
  { ������������� ����� ���������� � ����� ������ }
  SetString(Result, nil, L);
  N := 0;
  { ���������� ������� ������ }
  for I := 1 to L do
  begin
    K := 0;
    { ���� ������� ������ ����� ��������� }
    for J := 1 to Length(C) do
      if S[I] = C[J] then
      begin
        Inc(K);
        Break;
      end;
    { ���� �� ���� - ��������� � ��������� }
    if K = 0 then
    begin
      Inc(N);
      Result[N] := S[I];
    end;
  end;
  { ������������� �������� ����� ������ ���������� }
  SetLength(Result, N);
end;

{ �������� �������� �������� �� ������ }

function RemoveLineBreaks(const S: string): string;
var
  I, L, N: Integer;
begin
  { ����� ������ }
  L := Length(S);
  { ������������� ����� ���������� � ����� ������ }
  SetString(Result, nil, L);
  N := 0;
  { ���������� ������� ������ }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { �������� �� ������� ������ �������� �������� ������ }
    if S[I] in [#13, #10] then
    begin
      { �� - ������ ��� �� ������ }
      Result[N] := ' ';
      { ��������� ������� �������� ���������� }
      while (I < L) and (S[I + 1] in [#13, #10]) do Inc(I);
    end
    else
      { ��� - ����� ��� }
      Result[N] := S[I];
    { ��������� ������ }
    Inc(I);
  end;
  { ������������� �������� ����� ������ ���������� }
  SetLength(Result, N);
end;

{ �������� ������� �������� �� ������ }

function RemoveDoubleSpace(const S: string): string;
var
  I, L, N: Integer;
begin
  { ����� ������ }
  L := Length(S);
  { ������������� ����� ���������� � ����� ������ }
  SetString(Result, nil, L);
  N := 0;
  { ���������� ������� ������ }
  I := 1;
  while I <= L do
  begin
    Inc(N);
    { �������� �� ������� ������ �������� }
    if S[I] = ' ' then
    begin
      { �� - ��������� ��� }
      Result[N] := ' ';
      { ��������� ������� ���������� }
      while (I < L) and (S[I + 1] = ' ') do Inc(I);
    end
    else
      { ��� - ����� ��� }
      Result[N] := S[I];
    { ��������� ������ }
    Inc(I);
  end;
  { ������������� �������� ����� ������ ���������� }
  SetLength(Result, N);
end;

{ ��������� ����� � ������ �� ������ S ���������� ������� C }

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

{ ��������� ����� �� ������ S ���������� ������� C. }

function TrimCharLeft(const S: string; C: Char): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] = C) do Inc(I);
  Result := Copy(S, I, Maxint);
end;

{ ��������� ������ �� ������ S ���������� ������� C. }

function TrimCharRight(const S: string; C: Char): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] = C) do Dec(I);
  if I <> 0 then Result := Copy(S, 1, I) else Result := '';
end;

{ ���������� ������ S ����� ��������� C �� ����� Len }

function InsertCharLeft(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  L := Length(S);
  { �������� ����� }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { ��������� ������� }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { ��������� }
  Result := A + S;
end;

{ ���������� ������ S ������ ��������� C �� ����� Len. }

function InsertCharRight(const S: string; C: Char; Len: Integer): string;
var
  L: Integer;
  A: string;
begin
  { �������� ����� ������ }
  L := Length(S);
  { ��������� ����� }
  if L >= Len then
  begin
    Result := S;
    Exit;
  end;
  { ��������� ������� }
  SetString(A, nil, Len - L);
  FillChar(Pointer(A)^, Len - L, Byte(C));
  { ��������� }
  Result := S + A;
end;

{ �������� ������ S ����� �� ����� MaxLen }

function TruncLeft(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { �������� ����� ������ }
  L := Length(S);
  { ���� ����� ������ - �������� ������� ����� }
  if L > MaxLen then
  begin
    Result := Copy(S, MaxIntValue([1, L - MaxLen]), MaxLen);
    Exit;
  end;
  { ���������� ������ ��� ��������� }
  Result := S;
end;

{ �������� ������ S ������ �� ����� MaxLen }

function TruncRight(const S: string; MaxLen: Integer): string;
var
  L: Integer;
begin
  { �������� ����� ������ }
  L := Length(S);
  { ���� ����� ������ - �������� ������� ����� }
  if L > MaxLen then
  begin
    Result := Copy(S, 1, MaxLen);
    Exit;
  end;
  { ���������� ������ ��� ��������� }
  Result := S;
end;

{ ������� ��� ����������� ����� ��������� � �������� ������ } 

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

{ ����������� ��������� ������ �����. }

function StringsEqual(List: array of string; MatchCase: Boolean): Boolean;
var
  I: Integer;
  S1, S2: string;
begin
  Result := False;
  { �������� ������ ������ }
  S1 := List[Low(List)];
  if not MatchCase then S1 := AnsiUpperCase(S1);
  { ����������� }
  for I := Low(List) + 1 to High(List) do
  begin
    { �������� ������ ������ }
    S2 := List[I];
    if not MatchCase then S2 := AnsiUpperCase(S2);
    { ���������� }
    if AnsiCompareStr(S1, S2) <> 0 then Exit;
  end;
  { ��� ����� }
  Result := True;
end;

{ ����������� ������� ������ ����� ������� ������ � ��������� ������ }

function StringsEmpty(List: array of string): Boolean;
var
  I: Integer;
begin
  { ����������� }
  for I := Low(List) to High(List) do
    { ���������� ����� }
    if Length(List[I]) = 0 then
    begin
      Result := False;
      Exit;
    end;
  { ��� ����� }
  Result := True;
end;

{ ����������� ���������� ����� � ����������� � ���������� }

function GetLineCount(const S: string): Integer;
var
  P: PChar;
begin
  Result := 0;
  { ���� ������� ������ }
  P := Pointer(S);
  while P^ <> #0 do
  begin
    while not (P^ in [#0, #10, #13]) do Inc(P);
    { ���� ������ }
    Inc(Result);
    { ��������� ������� �������� }
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

{ ������� �������������� Ident � �������� � ������������ �� ������� Map }

function IdentToIntDef(const Ident: string; Default: Longint; const Map: array of TIdentMapEntry): Longint;
begin
  if not IdentToInt(Ident, Result, Map) then Result := Default;
end;

{ ������� �������� Int � ������������� � ������������ �� ������� Map }

function IntToIdentDef(Int: Longint; const Default: string; const Map: array of TIdentMapEntry): string;
begin
  if not IntToIdent(Int, Result, Map) then Result := Default;
end;

{ ��������� ������� �������������� Name � ������ Map }

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

{ ��������� ������� �������� Value � ������ Map }

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

{ ����������� ������������� ������ ���������������� ������ Map. ����������
  ������������ � ����� ������ ��������� Proc � ���� �������� ������ Map. }

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

{ ����������� ������ Strings ���������������� ������ Map. }

function GetIdentsStringList(const Map: array of TIdentMapEntry; Strings: TStrings): Integer;
type
  TGetStrFunc = function(const S: string): Integer of object;
var
  Proc: TGetStrFunc;
begin
  { ������� ������ }
  Strings.Clear;
  { ��������� }
  Proc := Strings.Add;
  Result := GetIdentsList(Map, TGetStrProc(Proc));
end;

{$IFNDEF EXT_D4_UP}

{ ������� ������ ��������, ����������� ��������� ��������, � ������ �����. }

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

{ ������� ������ ����� � ���� ������ � ������������� ���������� ����������� }

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

{ ��������� ���� ����� � ������ ������� ������. }

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
