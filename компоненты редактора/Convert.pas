unit Convert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl;


type MonitS = record
   x: Word;
   y: Word;
 end;

type MonitSs = array [0..5] of MonitS;

type
  TFormConvert = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
  coefX: real;
  coefY: real;
  dir: string;
  function Execute: boolean;
    { Public declarations }
  end;

var
  Form12: TFormConvert;
  typeSc:  MonitSs;

implementation

function  TFormConvert.Execute: boolean;
begin

end;

{$R *.dfm}

procedure TFormConvert.FormCreate(Sender: TObject);
var
 i: integer;
begin
coefX:=0;
coefY:=0;
typeSc[0].x:=800;
typeSc[0].y:=600;
typeSc[1].x:=1024;
typeSc[1].y:=768;
typeSc[2].x:=1280;
typeSc[2].y:=1024;
typeSc[3].x:=1280;
typeSc[3].y:=1024;
typeSc[4].x:=1600;
typeSc[4].y:=900;
typeSc[5].x:=1600;
typeSc[5].y:=1024;
combobox1.Text:='';
combobox2.Text:='';
combobox1.Items.Clear;
combobox2.Items.Clear;
for i:=0 to 5 do
  begin
     combobox1.Items.Add('"'+Inttostr(typeSc[i].x)+' x '+Inttostr(typeSc[i].y)+'"');
     combobox2.Items.Add('"'+Inttostr(typeSc[i].x)+' x '+Inttostr(typeSc[i].y)+'"');
  end;

end;

procedure TFormConvert.Button1Click(Sender: TObject);
var
   i,j: integer;
begin
i:=combobox1.Items.IndexOf(combobox1.Text);
j:=combobox2.Items.IndexOf(combobox2.Text);
if ((j=i) or (i<0) or (j<0)) then exit;
coefX:=typeSc[j].x/typeSc[i].x;
coefY:=typeSc[j].y/typeSc[i].y;
ModalResult:=MrOk;
end;

procedure TFormConvert.Button2Click(Sender: TObject);
begin
ModalResult:=MrNo;
end;

end.
