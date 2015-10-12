unit SaveArcPU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSaveArcP = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  function ShowA(var str: string): boolean;
    { Public declarations }
  end;

var
  SaveArcP: TSaveArcP;

implementation

function TSaveArcP.ShowA(var str: string): boolean;
begin
  Edit1.Text:='';
  if ShowModal=IDOK	then
   begin
    str:= Edit1.Text;
    result:=true;
  end
     else result:=false;

end;


{$R *.dfm}

procedure TSaveArcP.Button1Click(Sender: TObject);
begin
if Edit1.Text<>'' then ModalResult:=MrOk else
   MessageBox(0,'Ошибка','Настройка должна быть названа',MB_OK+MB_ICONERROR)
end;

end.
