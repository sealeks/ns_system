unit ifps3lib_std;
{

Innerfuse Pascal Script III
Copyright (C) 2000-2002 by Carlo Kok (ck@carlo-kok.com)

}
{$I ifps3_def.inc}
interface
uses
  ifps3utl, ifpscomp;

{
  In your Compilers OnUses proc:
  RegisterStandardLibrary_C registers the standard library.

function floattostr(e: extended): string;
function inttostr(i: Longint): string;
function strtoint(s: string): Longint;
function strtointdef(s: string; def: Longint): Longint;
function copy(s: string; ifrom, icount: Longint): string;
function pos(substr, s: string): Longint;
procedure delete(var s: string; ifrom, icount: Longint): string;
procedure insert(s: string; var s2: string; ipos: Longint): string;
function getarraylength(var v: array): Integer;
procedure setarraylength(var v: array; i: Integer);

Function StrGet(var S : String; I : Integer) : Char;
procedure StrSet(c : Char; I : Integer; var s : String);
Function Uppercase(s : string) : string;
Function Lowercase(s : string) : string;
Function Trim(s : string) : string;
Function Length(s : String) : Longint;
procedure SetLength(var S: String; L: Longint);
Function Sin(e : Extended) : Extended;
Function Cos(e : Extended) : Extended;
Function Sqrt(e : Extended) : Extended;
Function Round(e : Extended) : Longint;
Function Trunc(e : Extended) : Longint;
Function Int(e : Extended) : Longint;
Function Pi : Extended;
Function Abs(e : Extended) : Extended;
function StrToFloat(s: string): Extended;
Function FloatToStr(e : Extended) : String;
Function Padl(s : string;I : longInt) : string;
Function Padr(s : string;I : longInt) : string;
Function Padz(s : string;I : longInt) : string;
Function Replicate(c : char;I : longInt) : string;
Function StringOfChar(c : char;I : longInt) : string;

type
  TVarType = (vtNull, vtString, vtU64, vtS32, vtU32, vtS16, vtU16, vtS8, vtU8, vtSingle, vtDouble, vtExtended, vtResourcePointer, vtArray, vtRecord);
function VarGetType(x: Variant): TVarType;
function Null: Variant;

type
  TIFException = (ErNoError, erCannotImport, erInvalidType, ErInternalError,
    erInvalidHeader, erInvalidOpcode, erInvalidOpcodeParameter, erNoMainProc,
    erOutOfGlobalVarsRange, erOutOfProcRange, ErOutOfRange, erOutOfStackRange,
    ErTypeMismatch, erUnexpectedEof, erVersionError, ErDivideByZero, ErMathError,
    erCouldNotCallProc, erOutofRecordRange, erOutOfMemory, erException,
    erNullPointerException, erNullVariantError, erCustomError);


procedure RaiseLastException;
procedure RaiseException(Ex: TIFException; Param: string);
function ExceptionType: TIFException;
function ExceptionParam: string;
function ExceptionProc: Cardinal;
function ExceptionPos: Cardinal;
function ExceptionToString(er: TIFException; Param: string): string;
}
procedure RegisterStandardLibrary_C(S: TIFPSPascalCompiler);

implementation

procedure RegisterStandardLibrary_C(S: TIFPSPascalCompiler);
var
  p: PIFPSRegProc;
begin
  s.AddFunction('function inttostr(i: Longint): string;','',1);
  s.AddFunction('function strtoint(s: string): Longint;','',1);
  s.AddFunction('function strtointdef(s: string; def: Longint): Longint;','',1);
  s.AddFunction('function copy(s: string; ifrom, icount: Longint): string;','',2);
  s.AddFunction('function pos(substr, s: string): Longint;','',2);
  s.AddFunction('procedure delete(var s: string; ifrom, icount: Longint): string;','',2);
  s.AddFunction('procedure insert(s: string; var s2: string; ipos: Longint): string;','',2);
  p := s.Addfunction('function getarraylength: integer;','',100);
  p^.Decl := p^.Decl + ' !V -1';
  p := s.Addfunction('procedure setarraylength;','',100);
  p^.Decl := p^.Decl + ' !V -1 @LENGTH '+IntToStr(Longint(s.FindType('INTEGER')));
  s.AddFunction('Function StrGet(var S : String; I : Integer) : Char;','',2);
  s.AddFunction('procedure StrSet(c : Char; I : Integer; var s : String);','',2);
  s.AddFunction('Function Uppercase(s : string) : string;','',2);
  s.AddFunction('Function Lowercase(s : string) : string;','',2);
  s.AddFunction('Function Trim(s : string) : string;','',2);
  s.AddFunction('Function Length(s : String) : Longint;','',2);
  s.AddFunction('procedure SetLength(var S: String; L: Longint);','',2);
  s.AddFunction('Function Sin(e : Extended) : Extended;','',3);
  s.AddFunction('Function Cos(e : Extended) : Extended;','',3);
  s.AddFunction('Function Sqrt(e : Extended) : Extended;','',3);
  s.AddFunction('Function Round(e : Extended) : Longint;','',3);
  s.AddFunction('Function Trunc(e : Extended) : Longint;','',3);
  s.AddFunction('Function Int(e : Extended) : Longint;','',2);
  s.AddFunction('Function Pi : Extended;','',3);
  s.AddFunction('Function Abs(e : Extended) : Extended;','',2);
  s.AddFunction('function StrToFloat(s: string): Extended;','',1);
  s.AddFunction('Function FloatToStr(e : Extended) : String;','',2);
  s.AddFunction('Function Padl(s : string;I : longInt) : string;','',2);
  s.AddFunction('Function Padr(s : string;I : longInt) : string;','',2);
  s.AddFunction('Function Padz(s : string;I : longInt) : string;','',2);
  s.AddFunction('Function Replicate(c : char;I : longInt) : string;','',2);
  s.AddFunction('Function StringOfChar(c : char;I : longInt) : string;','',2);
  s.AddTypeS('TVarType', '(vtNull, vtString, vtU64, vtS32, vtU32, vtS16, vtU16, vtS8, vtU8, vtSingle, vtDouble, vtExtended, vtResourcePointer, vtArray, vtRecord)');
  S.AddFunction('function VarGetType(x: Variant): TVarType;','',1);
  s.AddFunction('function Null: Variant;','',2);

  s.addTypeS('TIFException', '(ErNoError, erCannotImport, erInvalidType, ErInternalError, erInvalidHeader, erInvalidOpcode, erInvalidOpcodeParameter, erNoMainProc, erOutOfGlobalVarsRange, erOutOfProcRange, ErOutOfRange, erOutOfStackRange, '+
    'ErTypeMismatch, erUnexpectedEof, erVersionError, ErDivideByZero, ErMathError,erCouldNotCallProc, erOutofRecordRange, erOutOfMemory, erException, erNullPointerException, erNullVariantError, erCustomError)');

  s.AddFunction('procedure RaiseLastException;','',4);
  s.AddFunction('procedure RaiseException(Ex: TIFException; Param: string);','',4);
  s.AddFunction('function ExceptionType: TIFException;','',4);
  s.AddFunction('function ExceptionParam: string;','',4);
  s.AddFunction('function ExceptionProc: Cardinal;','',4);
  s.AddFunction('function ExceptionPos: Cardinal;','',4);
  s.Addfunction('function ExceptionToString(er: TIFException; Param: string): string;','',4);


end;


end.
