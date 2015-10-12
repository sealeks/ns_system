unit UnitScale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Contnrs;

type
  TForm5 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
     procedure Shows(SvoObj: TComponentList);
    { Public declarations }
  end;

var
  Form5: TForm5;
  perCent: integer;

implementation

{$R *.dfm}

procedure TForm5.Shows(SvoObj: TComponentList);
var i: integer;
begin
percent:=100;
Edit1.Text:='100';
ShowModal;
if percent<>100 then
begin
for i:=0 to SvoObj.Count-1 do
begin
if not(SvoObj.Items[i] is TWinControl) then
begin
if (((SvoObj.Items[i] as TControl).Height*percent div 100)>5) then (SvoObj.Items[i] as TControl).Height:=(SvoObj.Items[i] as TControl).Height*percent div 100;
if (((SvoObj.Items[i] as TControl).Width*percent div 100)>5) then (SvoObj.Items[i] as TControl).Width:=(SvoObj.Items[i] as TControl).Width*percent div 100;
end else
(SvoObj.Items[i] as TWinControl).ScaleBy(percent,100);
end;
end;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
ModalResult := mrNo;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
percent:=StrToIntDef(Edit1.Text,100);
if ((percent>300) or (percent<10)) then percent:=100;
ModalResult :=MrOK;
end;

end.
