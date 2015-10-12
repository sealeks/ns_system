unit UnitExpr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, EditExpr;

type
  TFormExpr = class(TForm)
    StringGrid1: TStringGrid;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    SpeedButton6: TSpeedButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Memo1: TEditExpr;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure update;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Select(Sender: TObject);
  private
    { Private declarations }
  public
  stringListcoment: Tstringlist;
  stringlistExpr: TStringlist;
  function Execute(ins: string): string;
    { Public declarations }
  end;

var
  FormExpr: TFormExpr;
  block: bool;

implementation

uses  memStructsU,Redactor;

{$R *.dfm}

 function TForm13.Execute(ins: string): string;
 var i: integer;
  begin
 // Show;
 block:=false;
 result:=ins;
  stringgrid1.rowCount:=2;
  Memo1.Text:=ins;
  ComboBox1.Items.Clear;
  Combobox2.Items.Clear;
  ComboBox1.Text:=(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommandList.Strings[0];
  i:=0;
  for i:=0 to rtitems.Count-1 do
   begin
    StringGrid1.Cells[0,i+1]:=IntToStr(i);
    StringGrid1.Cells[1,i+1]:=(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommandList.Strings[i];
   ComboBox1.Items.Add((((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommandList.strings[i]);
   ComboBox2.Items.Add((((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommentList.strings[i]);
    StringGrid1.Cells[2,i+1]:=(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommentList.Strings[i];
    stringgrid1.rowCount := stringgrid1.rowCount + 1;
   end;
    stringgrid1.rowCount := stringgrid1.rowCount - 1;

 if  ShowModal=MrOk then
  result:=string(Memo1.Text);


  end;


procedure TForm13.SpeedButton2Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+'(';
block:=false;
end;

procedure TForm13.SpeedButton3Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+')';
block:=true;
end;

procedure TForm13.SpeedButton1Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' ! ';
 block:=true;
end;

procedure TForm13.SpeedButton4Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' | ';
block:=false;
end;

procedure TForm13.SpeedButton5Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' & ';
block:=false;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
Modalresult:=MrNo;
end;

procedure TForm13.Button1Click(Sender: TObject);
begin
Modalresult:=MrOk;
end;

procedure TForm13.SpeedButton6Click(Sender: TObject);
begin
block:=false;
Memo1.Text:='';
end;

procedure TForm13.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   if not block then
   begin
   Memo1.Text:=Memo1.Text+stringgrid1.Cells[1,Arow];
   block:=true;
   end;

end;

procedure TForm13.ComboBox1Select(Sender: TObject);
var
   i: integer;
begin
i:= ComboBox1.Items.IndexOf(ComboBox1.Text);
if i<1 then i:=1;
self.StringGrid1.TopRow:=i;
end;


procedure TForm13.FormCreate(Sender: TObject);
begin
ComboBox1.Text:='';
ComboBox2.Text:='';
 stringListcoment:=Tstringlist.create;
 stringlistExpr:=TStringlist.create;

end;

procedure TForm13.FormDestroy(Sender: TObject);
begin
stringListcoment.free;
stringlistExpr.free;
end;

procedure TForm13.update;
var i: integer;
begin
 {StringGrid1.RowCount:=1;
 for i:=0 to rtitems.Count-1 do
   begin
    if AnsiPos(combobox2.text,(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommentList.Strings[i])>0 then
     begin
    StringGrid1.Cells[0,i+1]:=IntToStr(i);
    StringGrid1.Cells[1,i+1]:=(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommandList.Strings[i];
    ComboBox1.Items.Add((((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommandList.strings[i]);
    StringGrid1.Cells[2,i+1]:=(((owner as Tcomponent).Owner as Tcomponent).owner as TRedactor).CommentList.Strings[i];
    stringgrid1.rowCount := stringgrid1.rowCount + 1;
    end;
   end;     }
end;

procedure TForm13.ComboBox1Change(Sender: TObject);
begin
update;
end;

procedure TForm13.ComboBox2Select(Sender: TObject);
var
   i: integer;
begin
i:= ComboBox2.Items.IndexOf(ComboBox2.Text);
if i<1 then i:=1;
self.StringGrid1.TopRow:=i;
end;

end.
