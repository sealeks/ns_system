unit TmyStringListFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TmyStringList = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Mnemo: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
      function Execute(var val: TStringList): boolean;
     { Public declarations }
  end;

var
  myStringList: TmyStringList;
  vals: TStringList;
  results: boolean;
implementation

{$R *.dfm}

function TmyStringList.Execute(var val: TStringList): boolean;
begin
result:=false;
results:=false;
vals:=val;
self.Mnemo.Lines.Text:=val.Text;
self.ShowModal;
result:=results;
end;

procedure TmyStringList.Button1Click(Sender: TObject);
begin
vals.Text:=self.Mnemo.Lines.Text;
results:=true;
self.ModalResult:=MrOk;
end;

procedure TmyStringList.Button2Click(Sender: TObject);
begin
self.ModalResult:=MrNone;
end;

end.
