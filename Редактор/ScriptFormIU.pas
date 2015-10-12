unit ScriptFormIU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, SynEditHighlighter,
  SynHighlighterPas, SynEdit, SynMemo;

type
  TScriptFormI = class(TForm)
    Panel1: TPanel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    function EXecute(var strL: string): boolean;
    { Public declarations }
  end;

var
  ScriptFormI: TScriptFormI;

implementation

{$R *.dfm}

function TScriptFormI.EXecute(var strL: string): boolean;
begin
//if not assigned(strL) then exit;
self.memo1.Text:=strL;
show;
end;

procedure TScriptFormI.N2Click(Sender: TObject);
begin
if self.OpenDialog1.Execute then
  memo1.Lines.LoadFromFile(self.OpenDialog1.FileName);
end;

procedure TScriptFormI.N3Click(Sender: TObject);
begin
if self.SaveDialog1.Execute then
  memo1.Lines.SaveToFile(self.OpenDialog1.FileName);
end;

end.
