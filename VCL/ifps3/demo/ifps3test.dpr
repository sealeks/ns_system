program ifps3test;

uses
  Forms,
  ifps3test1 in 'ifps3test1.pas' {MainForm},
  ifps3disasm in 'ifps3disasm.pas',
  ifps3test2 in 'ifps3test2.pas' {dwin};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(Tdwin, dwin);
  Application.Run;
end.

