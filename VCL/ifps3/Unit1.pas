unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, IFPS3CompExec, Menus;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    IFPS3CompExec1: TIFPS3CompExec;
    IFPS3DllPlugin1: TIFPS3DllPlugin;
    IFPS3ClassesPlugin1: TIFPS3ClassesPlugin;
    MainMenu1: TMainMenu;
    Program1: TMenuItem;
    Compile1: TMenuItem;
    procedure IFPS3ClassesPlugin1CompImport(Sender: TObject;
      x: TIFPSCompileTimeClassesImporter);
    procedure IFPS3ClassesPlugin1ExecImport(Sender: TObject;
      x: TIFPSRuntimeClassImporter);
    procedure IFPS3CompExec1Compile(Sender: TIFPS3CompExec);
    procedure Compile1Click(Sender: TObject);
    procedure IFPS3CompExec1Execute(Sender: TIFPS3CompExec);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses
  ifpiir_std,
  ifpii_std,
  ifpiir_stdctrls,
  ifpii_stdctrls,
  ifpiir_forms,
  ifpii_forms,
  ifpii_graphics,
  ifpii_controls,
  ifpii_classes,
  ifpiir_graphics,
  ifpiir_controls,
  ifpiir_classes,
  ifpscomp
  ;

{$R *.DFM}

procedure TForm1.IFPS3ClassesPlugin1CompImport(Sender: TObject;
  x: TIFPSCompileTimeClassesImporter);
begin
  SIRegister_Std(x);
  SIRegister_Classes(x);
  SIRegister_Graphics(x);
  SIRegister_Controls(x);
  SIRegister_stdctrls(x);
  SIRegister_Forms(x);
end;

procedure TForm1.IFPS3ClassesPlugin1ExecImport(Sender: TObject;
  x: TIFPSRuntimeClassImporter);
begin
  RIRegister_Std(x);
  RIRegister_Classes(x);
  RIRegister_Graphics(x);
  RIRegister_Controls(x);
  RIRegister_stdctrls(x);
  RIRegister_Forms(x);
end;

function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;
begin
  Result := s1 + ' ' + IntToStr(s2) + ' ' + IntToStr(s3) + ' ' + IntToStr(s4) + ' - OK!';
  S5 := s5 + ' '+ result + ' -   OK2!';
end;

procedure MyWriteln(const s: string);
begin
  Form1.Memo2.Lines.Add(s);
end;

function MyReadln(const question: string): string;
begin
  Result := InputBox(question, '', '');
end;

procedure TForm1.IFPS3CompExec1Compile(Sender: TIFPS3CompExec);
begin
  Sender.AddFunction(@MyWriteln, 'procedure Writeln(s: string);');
  Sender.AddFunction(@MyReadln, 'function Readln(question: string): string;');
  Sender.AddFunction(@ImportTest, 'function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;');
  Sender.AddRegisteredVariable('Application', 'TApplication');
  Sender.AddRegisteredVariable('Self', 'TForm');
  Sender.AddRegisteredVariable('Memo1', 'TMemo');
  Sender.AddRegisteredVariable('Memo2', 'TMemo');
end;

procedure TForm1.Compile1Click(Sender: TObject);
  procedure OutputMessages;
  var
    l: Longint;
    b: Boolean;
  begin
    b := False;

    for l := 0 to IFPS3CompExec1.CompilerMessageCount - 1 do
    begin
      Memo2.Lines.Add('Compiler: '+ IFPS3CompExec1.CompilerErrorToStr(l));
      if (not b) and (IFPS3CompExec1.CompilerMessages[l].MessageType = pterror) then
      begin
        b := True;
        Memo1.SelStart := IFPS3CompExec1.CompilerMessages[l].Position;
      end;
    end;
  end;
begin
  Memo2.Lines.Clear;
  IFPS3CompExec1.Script.Assign(Memo1.Lines);
  Memo2.Lines.Add('Compiling');
  if IFPS3CompExec1.Compile then
  begin
    OutputMessages;
    Memo2.Lines.Add('Compiled succesfully');
    if not IFPS3CompExec1.Execute then
    begin
      Memo1.SelStart := IFPS3CompExec1.ExecErrorPosition;
      Memo2.Lines.Add(IFPS3CompExec1.ExecErrorToString +' at '+Inttostr(IFPS3CompExec1.ExecErrorProcNo)+'.'+Inttostr(IFPS3CompExec1.ExecErrorByteCodePosition));
    end else Memo2.Lines.Add('Succesfully executed');
  end else
  begin
    OutputMessages;
    Memo2.Lines.Add('Compiling failed');
  end;
end;

procedure TForm1.IFPS3CompExec1Execute(Sender: TIFPS3CompExec);
begin
  IFPS3ClassesPlugin1.SetVarToInstance('APPLICATION', Application);
  IFPS3ClassesPlugin1.SetVarToInstance('SELF', Self);
  IFPS3ClassesPlugin1.SetVarToInstance('MEMO1', Memo1);
  IFPS3ClassesPlugin1.SetVarToInstance('MEMO2', Memo2);
end;

end.
