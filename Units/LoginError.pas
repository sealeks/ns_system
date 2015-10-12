unit LoginError;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TLoginError = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Execute(text: string);
    { Public declarations }
  end;

var
  LoginErrorForm: TLoginError;

implementation

{$R *.dfm}

procedure TLoginError.Execute(text: string);
begin
Label1.Caption:=text;
self.Timer1.Enabled:=true;
ShowModal;
end;

procedure TLoginError.Timer1Timer(Sender: TObject);
begin
ModalResult:=MrOk;
end;

end.
