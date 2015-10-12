unit ifps3test1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ifps3utl, ifpscomp, ifps3, Menus, ifps3lib_std,
  ifps3lib_stdr, ifps3common;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    Toosl1: TMenuItem;
    Compile1: TMenuItem;
    CompilewithTimer1: TMenuItem;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    N2: TMenuItem;
    Stop1: TMenuItem;
    N3: TMenuItem;
    CompileandDisassemble1: TMenuItem;
    procedure Compile1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Stop1Click(Sender: TObject);
    procedure CompileandDisassemble1Click(Sender: TObject);
    procedure CompilewithTimer1Click(Sender: TObject);
  private
    fn: string;
    changed: Boolean;
    function SaveTest: Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

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
  ifpiir_classes
  ;
{$R *.DFM}
var
  Imp: TIFPSRuntimeClassImporter;

function MyOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
var
  cl: TIFPSCompileTimeClassesImporter;
begin
  if Name = 'SYSTEM' then
  begin
    TIFPSPascalCompiler(Sender).AddFunction('procedure Writeln(s: string);');
    TIFPSPascalCompiler(Sender).AddFunction('function Readln(question: string): string;');
    RegisterDelphiFunctionC(Sender, 'function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;');


    Sender.AddConstantN('NaN', 'extended')^.Value.Value := transExtendedtoStr(0.0 / 0.0);
    Sender.AddConstantN('Infinity', 'extended')^.Value.Value := transExtendedtoStr(1.0 / 0.0);
    Sender.AddConstantN('NegInfinity', 'extended')^.Value.Value := transExtendedtoStr(- 1.0 / 0.0);

    cl := TIFPSCompileTimeClassesImporter.Create(Sender, True);
    SIRegister_Std(Cl);
    SIRegister_Classes(Cl);
    SIRegister_Graphics(Cl);
    SIRegister_Controls(Cl);
    SIRegister_stdctrls(Cl);
    SIRegister_Forms(Cl);

    AddImportedClassVariable(Sender, 'Memo1', 'TMemo');
    AddImportedClassVariable(Sender, 'Memo2', 'TMemo');
    AddImportedClassVariable(Sender, 'Self', 'TForm');
    AddImportedClassVariable(Sender, 'Application', 'TApplication');

    RegisterStandardLibrary_C(Sender);
    Result := True;
  end
  else
  begin
    TIFPSPascalCompiler(Sender).MakeError('', ecUnknownIdentifier, '');
    Result := False;
  end;
end;

function MyWriteln(Caller: TIFPSExec; p: PIFProcRec; Global, Stack: TIfList): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;
  MainForm.Memo2.Lines.Add(LGetStr(Stack, PStart));
  Result := True;
end;

function MyReadln(Caller: TIFPSExec; p: PIFProcRec; Global, Stack: TIfList): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 2;
  LSetStr(Stack, PStart + 1, InputBox(MainForm.Caption, LGetStr(stack, PStart), ''));
  Result := True;
end;

function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;
begin
  Result := s1 + ' ' + IntToStr(s2) + ' ' + IntToStr(s3) + ' ' + IntToStr(s4) + ' - OK!';
  S5 := s5 + ' '+ result + ' -   OK2!';
end;

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

function MyExportCheck(Sender: TIFPSPascalCompiler; Proc: PIFPSProcedure; const ProcDecl: string): Boolean;
begin
  Result := TRue;
end;


procedure TMainForm.Compile1Click(Sender: TObject);
var
  x1: TIFPSPascalCompiler;
  x2: TIFPSDebugExec;
  s, d: string;

  procedure Outputtxt(const s: string);
  begin
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
        Memo1.SelStart := X1.Msg[l]^.Position;
      end;
    end;
  end;
begin
  if tag <> 0 then exit;
  Memo2.Clear;
  x1 := TIFPSPascalCompiler.Create;
  x1.OnExportCheck := MyExportCheck;
  x1.OnUses := MyOnUses;
  x1.OnExternalProc := DllExternalProc;
  if x1.Compile(Memo1.Text) then
  begin
    Outputtxt('Succesfully compiled');
    OutputMsgs;
    if not x1.GetOutput(s) then
    begin
      x1.Free;
      Outputtxt('[Error] : Could not get data');
      exit;
    end;
    x1.GetDebugOutput(d);
    x1.Free;
    x2 := TIFPSDebugExec.Create;
    try
      RegisterDLLRuntime(x2);
      RegisterClassLibraryRuntime(x2, Imp);
      tag := longint(x2);
      if sender <> nil then
        x2.OnRunLine := RunLine;
      x2.RegisterFunctionName('WRITELN', MyWriteln, nil, nil);
      x2.RegisterFunctionName('READLN', MyReadln, nil, nil);
      RegisterDelphiFunctionR(x2, @ImportTest, 'IMPORTTEST', cdRegister);
      RegisterStandardLibrary_R(x2);
      if not x2.LoadData(s) then
      begin
        Outputtxt('[Error] : Could not load data: '+TIFErrorToString(x2.ExceptionCode, x2.ExceptionString));
        tag := 0;
        exit;
      end;
      x2.LoadDebugData(d);
      SetVariantToClass(x2.GetVarNo(x2.GetVar('MEMO1')), Memo1);
      SetVariantToClass(x2.GetVarNo(x2.GetVar('MEMO2')), Memo2);
      SetVariantToClass(x2.GetVarNo(x2.GetVar('SELF')), Self);
      SetVariantToClass(x2.GetVarNo(x2.GetVar('APPLICATION')), Application);

      x2.RunScript;
      if x2.ExceptionCode <> erNoError then
        Outputtxt('[Runtime Error] : ' + TIFErrorToString(x2.ExceptionCode, x2.ExceptionString) +
          ' in ' + IntToStr(x2.ExceptionProcNo) + ' at ' + IntToSTr(x2.ExceptionPos))
      else
        OutputTxt('Successfully executed');
    finally
      tag := 0;
      x2.Free;
    end;
  end
  else
  begin
    Outputtxt('Failed when compiling');
    OutputMsgs;
    x1.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := 'Innerfuse Pascal Script III';
  fn := '';
  changed := False;
  Memo1.Lines.Text := 'Program IFSTest;'#13#10'Begin'#13#10'End.';
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
  if not SaveTest then
    exit;
  Memo1.Lines.Text := 'Program IFSTest;'#13#10'Begin'#13#10'End.';
  Memo2.Lines.Clear;
  fn := '';
end;

function TMainForm.SaveTest: Boolean;
begin
  if changed then
  begin
    case MessageDlg('File is not saved, save now?', mtWarning, mbYesNoCancel, 0) of
      mrYes:
        begin
          Save1Click(nil);
          Result := not changed;
        end;
      mrNo: Result := True;
    else
      Result := False;
    end;
  end
  else
    Result := True;
end;

procedure TMainForm.Open1Click(Sender: TObject);
begin
  if not SaveTest then
    exit;
  if OpenDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
    changed := False;
    Memo2.Lines.Clear;
    fn := OpenDialog1.FileName;
  end;
end;

procedure TMainForm.Save1Click(Sender: TObject);
begin
  if fn = '' then
  begin
    Saveas1Click(nil);
  end
  else
  begin
    Memo1.Lines.SaveToFile(fn);
    changed := False;
  end;
end;

procedure TMainForm.SaveAs1Click(Sender: TObject);
begin
  SaveDialog1.FileName := '';
  if SaveDialog1.Execute then
  begin
    fn := SaveDialog1.FileName;
    Memo1.Lines.SaveToFile(fn);
    changed := False;
  end;
end;

procedure TMainForm.Memo1Change(Sender: TObject);
begin
  changed := True;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := SaveTest;
end;

procedure TMainForm.Stop1Click(Sender: TObject);
begin
  if tag <> 0 then
    TIFPSExec(tag).Stop;
end;

procedure TMainForm.CompileandDisassemble1Click(Sender: TObject);
var
  x1: TIFPSPascalCompiler;
  s, s2: string;

  procedure OutputMsgs;
  var
    l: Longint;
    b: Boolean;
  begin
    b := False;
    for l := 0 to x1.MsgCount - 1 do
    begin
      Memo2.Lines.Add(IFPSMessageToString(x1.Msg[l]));
      if (not b) and (x1.Msg[l]^.MessageType = pterror) then
      begin
        b := True;
        Memo1.SelStart := X1.Msg[l]^.Position;
      end;
    end;
  end;
begin
  if tag <> 0 then exit;
  Memo2.Clear;
  x1 := TIFPSPascalCompiler.Create;
  x1.OnExternalProc := DllExternalProc;
  x1.OnUses := MyOnUses;
  if x1.Compile(Memo1.Text) then
  begin
    Memo2.Lines.Add('Succesfully compiled');
    OutputMsgs;
    if not x1.GetOutput(s) then
    begin
      x1.Free;
      Memo2.Lines.Add('[Error] : Could not get data');
      exit;
    end;
    x1.Free;
    IFPS3DataToText(s, s2);
    dwin.Memo1.Text := s2;
    dwin.showmodal;
  end
  else
  begin
    Memo2.Lines.Add('Failed when compiling');
    OutputMsgs;
    x1.Free;
  end;
end;


procedure TMainForm.CompilewithTimer1Click(Sender: TObject);
var
  Freq, Time1, Time2: Comp;
begin
  if not QueryPerformanceFrequency(TLargeInteger((@Freq)^)) then
  begin
    ShowMessage('Your computer does not support Performance Timers!');
    exit;
  end;
  QueryPerformanceCounter(TLargeInteger((@Time1)^));
  IgnoreRunline := True;
  try
    Compile1Click(nil);
  except
  end;
  IgnoreRunline := False;
  QueryPerformanceCounter(TLargeInteger((@Time2)^));
  Memo2.Lines.Add('Time: ' + Sysutils.FloatToStr((Time2 - Time1) / Freq) +
    ' sec');
end;

initialization
  Imp := TIFPSRuntimeClassImporter.Create;
  RIRegister_Std(Imp);
  RIRegister_Classes(Imp);
  RIRegister_Graphics(Imp);
  RIRegister_Controls(Imp);
  RIRegister_stdctrls(imp);
  RIRegister_Forms(Imp);
finalization
  Imp.Free;
end.
