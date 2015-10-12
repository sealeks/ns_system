unit FormFix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst;

type
  TFormFix = class(TForm)
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    Redac: TComponent;
    procedure Execute;
    procedure  AddRed(Red: TComponent);
    { Public declarations }
  end;

var
  Form1: TFormFix;

implementation

uses Redactor;

{$R *.dfm}

procedure TFormFix.FormCreate(Sender: TObject);
var  i: integer;
begin


end;

procedure TFormFix.Execute;
begin
 showmodal;
end;


procedure  TFormFix.AddRed(Red: TComponent);
var i: integer;
begin
Redac:=red;
for i:=0 to (Redac as Tredactor).tComList.Count-1 do
  begin
    CheckListBox1.Items.AddObject(Tcomponent( (Redac as Tredactor).tComList.Items[i]).Name,Tcomponent( (Redac as Tredactor).tComList.Items[i]));
    if Tcomponent( (Redac as Tredactor).tComList.Items[i]).Tag<100 then
        CheckListBox1.Checked[CheckListBox1.Count-1]:=false
    else
       CheckListBox1.Checked[CheckListBox1.Count-1]:=true;

end;
end;

procedure TFormFix.Button2Click(Sender: TObject);
var i: integer;
begin
(Redac as Tredactor).DeleteSelected(true);
for i:=0 to  CheckListBox1.Count-1 do
 if CheckListBox1.Checked[i] then TComponent(CheckListBox1.Items.Objects[i]).Tag:=100 else
                    TComponent(CheckListBox1.Items.Objects[i]).Tag:=0;
ModalResult:=MrOk;
end;

procedure TFormFix.Button1Click(Sender: TObject);
var  i: integer;
begin
for i:=0 to  CheckListBox1.Count-1 do
  CheckListBox1.Checked[i]:=false;

end;

procedure TFormFix.Button3Click(Sender: TObject);
var  i: integer;
begin
for i:=0 to  CheckListBox1.Count-1 do
  CheckListBox1.Checked[i]:=true;
end;

procedure TFormFix.Button4Click(Sender: TObject);
begin
ModalResult:=MrNo;
end;

end.