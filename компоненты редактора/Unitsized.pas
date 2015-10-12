unit Unitsized;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Contnrs;

type
  TForm6 = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);


  private
    { Private declarations }
  public
     MinW: integer;
     MaxW: integer;
     MinH: integer;
     MaxH: integer;
     parW: integer;
  parH: integer;
    procedure Shows(SvoObj: TComponentList);
    { Public declarations }
  end;

var
  Form6: TForm6;


implementation

{$R *.dfm}

procedure TForm6.Shows(SvoObj: TComponentList);
var i: integer;
begin
 parH:=-100;
 parW:=-100;

self.RadioButton7.Checked:=true;
self.RadioButton8.Checked:=true;
self.Edit1.Text:='';
self.Edit2.Text:='';
Edit1.Enabled:=false;
Edit2.Enabled:=false;
MinW:=(SvoObj.Items[0] as TControl).Width;
MaxW:=(SvoObj.Items[0] as TControl).Width;
MinH:=(SvoObj.Items[0] as TControl).Height;
MaxH:=(SvoObj.Items[0] as TControl).Height;
for i:=1 to SvoObj.Count-1 do
begin
if MinW>(SvoObj.Items[i] as TControl).Width then MinW:=(SvoObj.Items[i] as TControl).Width;
if MaxW<(SvoObj.Items[i] as TControl).Width then MaxW:=(SvoObj.Items[i] as TControl).Width;
if MinH>(SvoObj.Items[i] as TControl).Height then MinH:=(SvoObj.Items[i] as TControl).Height;
if MaxW<(SvoObj.Items[i] as TControl).Height then MaxH:=(SvoObj.Items[i] as TControl).Height;
end;
self.ShowModal;
if parH<>-100 then
for i:=0 to SvoObj.Count-1 do (SvoObj.Items[i] as TControl).Height:=parH;
if parW<>-100 then
for i:=0 to SvoObj.Count-1 do (SvoObj.Items[i] as TControl).Width:=parW;

end;

procedure TForm6.Button1Click(Sender: TObject);
begin
 parH:=-100;
 parW:=-100;
 ModalResult := mrNo;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
if self.RadioButton7.Checked then parH:=-100;
if self.RadioButton8.Checked then parW:=-100;
if self.RadioButton1.Checked then parH:=MaxH;
if self.RadioButton4.Checked then parW:=MaxW;
if self.RadioButton2.Checked then parH:=MinH;
if self.RadioButton5.Checked then parW:=MinW;
if self.RadioButton3.Checked then parH:=StrToIntDef(Edit1.Text,-100);
if self.RadioButton6.Checked then parW:=StrToIntDef(Edit2.Text,-100);
ModalResult := MrOK;
end;

procedure TForm6.RadioButton7Click(Sender: TObject);
begin
if Sender=RadioButton3 then
Edit1.Enabled:=true else
begin
Edit1.Text:='';
Edit1.Enabled:=false;
end;
end;

procedure TForm6.RadioButton8Click(Sender: TObject);
begin
if Sender=RadioButton6 then
Edit2.Enabled:=true else
begin
Edit2.Text:='';
Edit2.Enabled:=false;
end;
end;





end.
