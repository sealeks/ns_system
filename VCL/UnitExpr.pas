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
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    memo1: TEditExpr;
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
  function Execute(var ins: string): boolean;
    { Public declarations }
  end;

var
 FormExpr: TFormExpr;
  block: bool;

implementation

uses  memStructsU;

{$R *.dfm}

 function TFormExpr.Execute(var ins: string): boolean;
 var i: integer;
  begin
 result:=false;
 if rtitems=nil then exit;
 block:=false;

  stringgrid1.rowCount:=2;
  Memo1.Text:=ins;
  ComboBox1.Items.Clear;
  Combobox2.Items.Clear;
   for i:=0 to rtitems.Count-1 do
   ComboBox1.AddItem(rtitems.GetName(i),nil);
  ComboBox1.Text:=rtitems.GetName(0);
  i:=0;
  for i:=0 to rtitems.Count-1 do
   begin
    StringGrid1.Cells[0,i+1]:=IntToStr(i);
    StringGrid1.Cells[1,i+1]:=rtitems.GetName(i);
   ComboBox1.Items.Add(rtitems.GetName(i));
   ComboBox2.Items.Add(rtitems.GetComment(i));
   StringGrid1.Cells[2,i+1]:=rtitems.GetComment(i);
    stringgrid1.rowCount := stringgrid1.rowCount + 1;
   end;
    stringgrid1.rowCount := stringgrid1.rowCount - 1;

 if  ShowModal=MrOk then
 begin
  ins:=string(Memo1.Text);
  result:=true;
 end;

  end;


procedure TFormExpr.SpeedButton2Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+'(';
//block:=false;
end;

procedure TFormExpr.SpeedButton3Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+')';
//block:=true;
end;

procedure TFormExpr.SpeedButton1Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' ! ';
// block:=true;
end;

procedure TFormExpr.SpeedButton4Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' | ';
//block:=false;
end;

procedure TFormExpr.SpeedButton5Click(Sender: TObject);
begin
Memo1.Text:=Memo1.Text+' & ';
//block:=false;
end;

procedure TFormExpr.Button2Click(Sender: TObject);
begin
Modalresult:=MrNo;
end;

procedure TFormExpr.Button1Click(Sender: TObject);
begin
Modalresult:=MrOk;
end;

procedure TFormExpr.SpeedButton6Click(Sender: TObject);
begin
block:=false;
Memo1.Text:='';
end;

procedure TFormExpr.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  // if not block then
  // begin
   Memo1.Text:=Memo1.Text+stringgrid1.Cells[1,Arow];
  // block:=true;
  // end;

end;

procedure TFormExpr.ComboBox1Select(Sender: TObject);
var
   i: integer;
begin
i:= ComboBox1.Items.IndexOf(ComboBox1.Text);
if i<1 then i:=1;
self.StringGrid1.TopRow:=i;
end;


procedure TFormExpr.FormCreate(Sender: TObject);
begin
ComboBox1.Text:='';
ComboBox2.Text:='';
 stringListcoment:=Tstringlist.create;
 stringlistExpr:=TStringlist.create;

end;

procedure TFormExpr.FormDestroy(Sender: TObject);
begin
stringListcoment.free;
stringlistExpr.free;
end;

procedure TFormExpr.update;
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

procedure TFormExpr.ComboBox1Change(Sender: TObject);
begin
update;
end;

procedure TFormExpr.ComboBox2Select(Sender: TObject);
var
   i: integer;
begin
i:= ComboBox2.Items.IndexOf(ComboBox2.Text);
if i<1 then i:=1;
self.StringGrid1.TopRow:=i;
end;

end.
