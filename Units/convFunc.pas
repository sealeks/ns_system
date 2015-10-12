unit convFunc;

interface

function OctToHex (source: string): string;
function HexToOct (source: string): string;
function BINtoBCD (source: longInt): longInt;
function BCDtoBIN (source: longInt): longInt;

function OctStringToInteger (source: string) : integer;
function HexStringToInteger (source: string) : integer;
function IntegerToHexString (source: integer) : string;
function IntegerToOctString (source: integer) : string;

function NS_strOctToInt (source: string) : integer;
function NS_strBinOctToInt (source: string) : integer;
function NS_strBinToInt (source: string) : integer;
function NS_binbyteToHexbyte (vl: byte) : byte;
function NS_hexbyteTobinbyte (vl: byte) : byte;

implementation
uses math, sysutils;

function OctStringToInteger (source: string) : integer;
var
  i, len, sym: integer;

begin
  result := 0;
  len := length (source);
  for i := 1 to  len do begin
    sym := ord(source[len - i + 1]);
    if (ord('0') <= sym) and (sym <= ord('7')) then
      result := result + (sym - ord('0')) *  round(power(8, (i-1)))
    else raise Exception.Create ('Invalid octal number: ' + source);
  end;
end;

function HexStringToInteger (source: string) : integer;
var
  i, len, sym: integer;

begin
  result := 0;
  len := length (source);
  source := upperCase (source);
  for i := 1 to  len do begin
    sym := ord(source[len - i + 1]);
    if (ord('0') <= sym) and (sym <= ord('9')) then
      result := result + (sym - ord('0')) *  round(power(16, (i-1)))
    else
      if (ord('A') <= sym) and (sym <= ord('F')) then
        result := result + (sym - ord('A') + 10) *  round(power(16, (i-1)))
      else raise Exception.Create ('Invalid hexadecimal number: ' + source);
  end;
end;

function IntegerToHexString (source: integer) : string;
var
  i: integer;
  digit: integer;

begin
  result := '';
  if source = 0 then result := '0';
  for i := 1 to  8 do begin //32 bits
    if source = 0 then exit;
    digit := source and $F;
    source := source shr 4;
    if (0 <= digit) and (digit <= 9) then
      result := char(ord('0') + digit) + result
    else
      if (10 <= digit) and (digit <= 15) then
        result := char(ord('A') + digit - 10) + result
  end;
end;


function IntegerToOctString (source: integer) : string;
var
  i: integer;
  digit: integer;

begin
  result := '';
  if source = 0 then result := '0';
  for i := 1 to  11 do begin //32 bits
    if source = 0 then exit;
    digit := source and $7; //b111
    source := source shr 3;
    if (0 <= digit) and (digit <= 7) then
      result := char(ord('0') + digit) + result
  end;
end;


function BCDtoBIN (source: longInt): longInt;
var
  i: integer;
  digit: integer;
begin
  result := 0;
  for i := 0 to 7 do begin
    if source = 0 then exit;
    digit := source and $F;
    source := source shr 4;
    result := result + digit * round(power (10, i));
  end;
end;

function BINtoBCD (source: longInt): longInt;
var
  i: integer;
  digit: integer;
begin
  result := 0;
  for i := 0 to 7 do begin //max 32 bits
    if source = 0 then exit;
    digit := source mod 10;
    source := source div 10;
    result := result + digit shl (i * 4);
  end;
end;

function OctToHex (source: string): string;
begin
  result := integertohexString(OctStringtoInteger (source));
end;

function HexToOct (source: string): string;
var
  test: integer;
begin
  test := HexStringtoInteger (source);
  result := integertooctString(test);
end;

function NS_strBinOctToInt (source: string) : integer;
var
  i, len, k, tmp : integer;
  tmstr: string;
begin
  result := 0;
  tmstr:='';
  len := length (source);
  tmp:=0;
  for i := 1 to  len do begin
    tmp:= (tmp shl 8) +byte(source[i])
  end;
  k:=0;
  while k<16 do
   begin
     tmstr:=char(((tmp shr k) and $7) or $30)+tmstr;
     k:=k+3;
   end;
  result:=NS_strOctToInt(tmstr);
end;

function NS_strBinToInt (source: string) : integer;
var
  i, len, k, tmp : integer;
  tmstr: string;
begin
  result := 0;
  tmstr:='';
  len := length (source);
  tmp:=0;
  for i := 1 to  len do begin
    tmp:= (tmp shl 8) +byte(source[i])
  end;
  result:=tmp;
end;


function NS_strOctToInt (source: string) : integer;
var
  i, len, sym,k: integer;
begin
  result := 0;k:=1;
  len := length (source);
  for i := 1 to  len do begin
    sym := ord(source[len - i + 1]);
    if (ord('0') <= sym) and (sym <= ord('7')) then
      result := result + (sym - ord('0')) *  k
    else raise
    Exception.Create ('Invalid octal number: ' + source);
    k:=k*8;
  end;
end;

function NS_binbyteToHexbyte (vl: byte) : byte;
var tmp1,tmp2: byte;
begin
   tmp1:= (vl mod 10);
   tmp2:= (vl - (vl mod 10)) div 10;
   result:= ((tmp2 shl 4) and $F0) or ((tmp1) and $F );
end;

function NS_hexbyteTobinbyte (vl: byte) : byte;
var tmp1,tmp2: byte;
begin
   tmp2:= (vl shr 4) and $F;
   tmp1:= (vl) and $F;
   result:= 10*tmp2;
   result:= tmp1+result
end;

end.
