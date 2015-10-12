unit ifps_maincompile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ifps3utl, ifpscomp, ifps3, Menus, ifps3lib_std,
  ifps3lib_stdr, ifps3common, SynHighlighterAsm, SynEditHighlighter,
  SynHighlighterPas, SynEdit, SynMemo, StrUtils, MainCompilerigistration;





var
  memo1: string;
  fn: string;
  changed: Boolean;
  memo2: TSynMemo;
  tcom: TComponent;
  compileText: string;
  compileProgram: string;
  assembltext: string;
  errcl: integer;
  function EXecute(pr: string; debagMemo2: TSynMemo; var errc: integer): boolean;
  function EXecuteB(pr: string; debagMemo2: TSynMemo; var errc: integer): boolean;
  function CompileandDisassemble1: boolean;
  function  Compile1Click: boolean;

implementation
uses
  ifps3test2, ifps3disasm, ifpidelphi, ifpidll2, ifpidll2runtime, ifps3debug,
  ifpiclass, ifpiclassruntime, ifpiir_std, ifpii_std, ifpiir_stdctrls, ifpii_stdctrls,
  ifpiir_forms, ifpii_forms, ifpidelphiruntime,
  ifpii_graphics,
  ifpii_controls,
  ifpii_classes,
  ifpiir_graphics,
  ifpiir_controls,
  ifpiir_classes,
  AppImmi;
var
  IgnoreRunline: Boolean = False;
  I: Integer;

procedure RunLine(Sender: TIFPSExec);
begin
  if IgnoreRunline then Exit;
  i := (i + 1) mod 15;
  Sender.GetVar('');
  if i = 0 then Application.ProcessMessages;
end;

function EXecute(pr: string; debagMemo2: TSynMemo; var errc: integer): boolean;
begin
memo2:=debagMemo2;
if memo2<>nil then   Memo2.Lines.Clear;
memo1:=pr;
result:=Compile1Click;
errc:=errcl;
end;


function EXecuteB(pr: string; debagMemo2: TSynMemo; var errc: integer): boolean;
begin
memo2:=debagMemo2;
if memo2<>nil then   Memo2.Lines.Clear;
memo1:=pr;
result:=CompileandDisassemble1;
errc:=errcl;
end;

function Compile1Click: boolean;
var
  x1: TIFPSPascalCompiler;
  x2: TIFPSDebugExec;
  s, s2, d: string;
  formd: TForm;
  i,j: integer;
  procedure Outputtxt(const s: string);
  begin
 //  Memo2.Lines.Clear;
   Memo2.Lines.Add(s);
  end;

  procedure OutputMsgs;
  var
    l: Longint;
    b: Boolean;
  begin
    b := False;
    for l := 0 to x1.MsgCount - 1 do
    begin
      Outputtxt(IFPSMessageToString(x1.Msg[l]));
      if (not b) and (x1.Msg[l]^.MessageType = pterror) then
      begin
        b := True;
      end;
    end;
  end;
begin
  result:=false;
  x1 := TIFPSPascalCompiler.Create;
  x1.OnUses := MyOnUses;
  x1.OnExternalProc := DllExternalProc;
  if x1.Compile(Memo1) then
  begin
    Outputtxt('Проект успешно компилирован');
    OutputMsgs;
    if not x1.GetOutput(s) then
    begin
      x1.Free;
      Outputtxt('[Error] : Could not get data');
      exit;
    end;
    compiletext:=s;
    result:=true;
   // IFPS3DataToText(s, s2);
    assembltext:=s2;
  end
  else
  begin
    Outputtxt('Ошибка при компилляции');
    if x1.MsgCount>0 then errcl:=x1.Msg[0].Position;
    OutputMsgs;
    x1.Free;
  end;
end;



function CompileandDisassemble1: boolean;
var
  x1: TIFPSPascalCompiler;
  x2: TIFPSDebugExec;
  s, s2, d: string;
  formd: TForm;
  i,j: integer;

begin
  result:=false;
  x1 := TIFPSPascalCompiler.Create;
  x1.OnUses := MyOnUses;
  x1.OnExternalProc := DllExternalProc;
  if x1.Compile(Memo1) then
  begin

    if not x1.GetOutput(s) then
    begin
      x1.Free;
      exit;
    end;
    compiletext:=s;
    result:=true;
    IFPS3DataToText(s, s2);
    assembltext:=s2;
  end
  else
  begin
    x1.Free;
  end;
end;










end.
 