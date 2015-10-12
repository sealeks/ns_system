unit UnitAlighn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Contnrs, ControlDDH;

type
  TForm3 = class(TForm)
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton20: TRadioButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
  private
   procedure AllLeft(l: integer;SvoObj: TComponentList);
   procedure AllRight(r: integer;SvoObj: TComponentList);
   procedure AllTop(t: integer;SvoObj: TComponentList);
   procedure AllBottom(b: integer;SvoObj: TComponentList);
   procedure AllWcenter(c: integer;SvoObj: TComponentList);
   procedure AllHcenter(c: integer;SvoObj: TComponentList);
   procedure Sortirovka(SvoObj: TComponentList);
    { Private declarations }
  public
   procedure Shows(SvoObj: TComponentList);

    { Public declarations }
  end;



var
  typeAlw: integer;
  typeAlh: integer;
  Form3: TForm3;
  mostLeft: integer;
  ml: integer;
  unmostLeft: integer;
  uml: integer;
  mostRight: integer;
  mr: integer;
  unmostRight: integer;
  umr: integer;
   mostTop: integer;
  mt: integer;
  unmostTop: integer;
  umt: integer;
  mostBottom: integer;
  mb: integer;
  unmostBottom: integer;
  umb: integer;
  parCenterW: integer;
  parCenterH: integer;
  mostlCenter: integer;
  mostbCenter: integer;
  mostrCenter: integer;
  mosttCenter: integer;
  mostlRight: integer;
  mostrRight: integer;
  mostrLeft: integer;
  mostbTop:  integer;
  mosttBottom:integer;
  UnMosttBottom: integer;
  arrH: array of integer;
  arrW: array of integer;
  deltaH: integer;
  deltaW: integer;
  screenCenter: integer;
  paren: TWinControl;
  currentH: integer;
  currentW: integer;

implementation

{$R *.dfm}

procedure TForm3.Shows(SvoObj: TComponentList);
var i: integer;

begin
typeAlh:=-1;
typeAlw:=-1;
setLength(arrH,Svoobj.Count);
setLength(arrW,Svoobj.Count);
for i:=0 to Svoobj.Count-1 do arrH[i]:=i;
for i:=0 to Svoobj.Count-1 do arrW[i]:=i;
self.RadioButton1.Checked:=true;
self.RadioButton8.Checked:=true;
self.Edit1.Text:='';
self.Edit2.Text:='';
Edit1.Enabled:=false;
Edit2.Enabled:=false;
Sortirovka(SvoObj);
paren:=(SvoObj.Items[0] as TControl).Parent;
mostLeft:=(SvoObj.Items[0] as TControl).BoundsRect.Left;
ml:=0;
unmostLeft:=(SvoObj.Items[0] as TControl).BoundsRect.Left;
uml:=0;
mostRight:=(SvoObj.Items[0] as TControl).BoundsRect.Right;
mr:=0;
unmostRight:=(SvoObj.Items[0] as TControl).BoundsRect.Right;
umr:=0;
mostTop:=(SvoObj.Items[0] as TControl).BoundsRect.Top;
mt:=0;
unmostTop:=(SvoObj.Items[0] as TControl).BoundsRect.Top;
umt:=0;
mostBottom:=(SvoObj.Items[0] as TControl).BoundsRect.Bottom;
mb:=0;
unmostBottom:=(SvoObj.Items[0] as TControl).BoundsRect.Bottom;
umb:=0;
parCenterW:=(SvoObj.Items[0] as TControl).Parent.Width div 2;
parCenterH:=(SvoObj.Items[0] as TControl).Parent.Height div 2;
for i:=1 to SvoObj.Count-1 do
begin
if MostLeft>(SvoObj.Items[i] as TControl).BoundsRect.Left then
                begin
                MostLeft:=(SvoObj.Items[i] as TControl).BoundsRect.Left;
                ml:=i;
                end;
if UnMostLeft<(SvoObj.Items[i] as TControl).BoundsRect.Left then
                begin
                UnMostLeft:=(SvoObj.Items[i] as TControl).BoundsRect.Left;
                uml:=i;
                end;
if MostRight>(SvoObj.Items[i] as TControl).BoundsRect.Right then
                begin
                MostRight:=(SvoObj.Items[i] as TControl).BoundsRect.right;
                mr:=i;
                end;
if UnMostRight<(SvoObj.Items[i] as TControl).BoundsRect.Right then
                begin
                UnMostRight:=(SvoObj.Items[i] as TControl).BoundsRect.Right;
                umr:=i;
                end;
if MostTop>(SvoObj.Items[i] as TControl).BoundsRect.Top then
                begin
                MostTop:=(SvoObj.Items[i] as TControl).BoundsRect.Top;
                mt:=i;
                end;
if UnMostTop<(SvoObj.Items[i] as TControl).BoundsRect.Top then
                begin
                UnMostTop:=(SvoObj.Items[i] as TControl).BoundsRect.Top;
                umt:=i;
                end;
if MostBottom>(SvoObj.Items[i] as TControl).BoundsRect.Bottom then
                begin
                MostBottom:=(SvoObj.Items[i] as TControl).BoundsRect.Bottom;
                mb:=i;
                end;
if UnMostBottom<(SvoObj.Items[i] as TControl).BoundsRect.Bottom then
                begin
                UnMostBottom:=(SvoObj.Items[i] as TControl).BoundsRect.Bottom;
                umb:=i;
                end;
end;
mostlCenter:=((SvoObj.Items[ml] as TControl).BoundsRect.Right+(SvoObj.Items[ml] as TControl).BoundsRect.Left) div 2;
mostbCenter:=((SvoObj.Items[umt] as TControl).BoundsRect.Bottom+(SvoObj.Items[umt] as TControl).BoundsRect.Top) div 2;
mostrCenter:=((SvoObj.Items[uml] as TControl).BoundsRect.Right+(SvoObj.Items[uml] as TControl).BoundsRect.Left) div 2;
mosttCenter:=((SvoObj.Items[mt] as TControl).BoundsRect.top+(SvoObj.Items[mt] as TControl).BoundsRect.Bottom) div 2;
mostlRight:=(SvoObj.Items[ml] as TControl).BoundsRect.Right;
mostrRight:=(SvoObj.Items[uml] as TControl).BoundsRect.Right;
mostrLeft:=(SvoObj.Items[uml] as TControl).BoundsRect.Left;
mostbTop:=(SvoObj.Items[mt] as TControl).BoundsRect.Top;
mosttBottom:=(SvoObj.Items[mt] as TControl).BoundsRect.Bottom;
UnMosttBottom:=(SvoObj.Items[umt] as TControl).BoundsRect.Bottom;
if SvoObj.Count>1 then deltaW:=(mostrLeft-MostLeft) div (SvoObj.Count -1) else deltaW:=0;
if SvoObj.Count>1 then deltaH:=(UnmostTop-MostTop) div (SvoObj.Count -1) else  deltaH:=0;
ShowModal;
if typeAlW=1 then AllLeft(currentW,SvoObj);
if typeAlH=1 then AllTop(currentH,SvoObj);
if typeAlW=2 then AllWCenter(currentW,SvoObj);
if typeAlH=2 then AllHCenter(currentH,SvoObj);
if typeAlW=3 then AllRight(currentW,SvoObj);
if typeAlH=3 then AllBottom(currentH,SvoObj);
if typeAlW=4 then
begin
  if  deltaW>0 then
  begin
   for i:=1 to SvoObj.Count-2 do
     begin
      (SvoObj.Items[arrW[i]] as TControl).Left:=(SvoObj.Items[arrW[0]] as TControl).Left+i*deltaW;
      (SvoObj.Items[arrW[i]] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[arrW[i]] as TControlddh).BoundsRect ;
     end;
  end;
end;
if typeAlH=4 then
begin
if deltaH>0 then
begin
   for i:=1 to SvoObj.Count-2 do
     begin
      (SvoObj.Items[arrH[i]] as TControl).Top:=(SvoObj.Items[arrH[0]] as TControl).Top+i*deltaH;
      (SvoObj.Items[arrH[i]] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[arrH[i]] as TControlddh).BoundsRect ;
     end;
  end;
end;
end;

procedure TForm3.AllLeft(l: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
begin
(SvoObj.Items[i] as TControl).Left:=l;
(SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;

procedure TForm3.AllTop(t: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
 begin
(SvoObj.Items[i] as TControl).Top:=t;
 (SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;

procedure TForm3.AllRight(r: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
begin
(SvoObj.Items[i] as TControl).Left:=r-(SvoObj.Items[i] as TControl).Width;
(SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;

procedure TForm3.AllBottom(b: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
begin
(SvoObj.Items[i] as TControl).Top:=b-(SvoObj.Items[i] as TControl).Height;
(SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;

procedure TForm3.AllWcenter(c: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
begin
(SvoObj.Items[i] as TControl).Left:=c-((SvoObj.Items[i] as TControl).Width div 2);
(SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;

procedure TForm3.AllHcenter(c: integer;SvoObj: TComponentList);
var i: integer;
begin
for i:=0 to SvoObj.Count-1 do
begin
(SvoObj.Items[i] as TControl).Top:=c-((SvoObj.Items[i] as TControl).Height div 2);
(SvoObj.Items[i] as TControlddh).FControl.BoundsRect:=(SvoObj.Items[i] as TControlddh).BoundsRect;
end;
end;


procedure TForm3.Button2Click(Sender: TObject);
begin
if (self.RadioButton1.Checked) then
   begin
   currentW:=-100;
   typeAlW:=-1;
   end;
if (self.RadioButton8.Checked) then
   begin
   currentH:=-100;
   typeAlH:=-1;
   end;
if (self.RadioButton2.Checked) then
   begin
   currentW:=MostLeft;
   typeAlW:=1;
   end;
if (self.RadioButton16.Checked) then
   begin
   currentW:=UnMostLeft;
   typeAlW:=1;
   end;
if (self.RadioButton9.Checked) then
   begin
   currentH:=MostTop;
   typeAlH:=1;
   end;
if (self.RadioButton18.Checked) then
   begin
   currentH:=UnMostTop;
   typeAlH:=1;
   end;
if (self.RadioButton3.Checked) then
   begin
   currentW:=mostlCenter;
   typeAlW:=2;
   end;
if (self.RadioButton15.Checked) then
   begin
   currentW:=mostrCenter;
   typeAlW:=2;
   end;
if (self.RadioButton10.Checked) then
   begin
   currentH:=MosttCenter;
   typeAlH:=2;
   end;
if (self.RadioButton19.Checked) then
   begin
   currentH:=MostbCenter;
   typeAlH:=2;
   end;
if (self.RadioButton4.Checked) then
   begin
   currentW:=mostlRight;
   typeAlW:=3;
   end;
if (self.RadioButton17.Checked) then
   begin
   currentW:=mostrRight;
   typeAlW:=3;
   end;
if (self.RadioButton11.Checked) then
   begin
   currentH:=MosttBottom;
   typeAlH:=3;
   end;
if (self.RadioButton20.Checked) then
   begin
   currentH:=UnMosttBottom;
   typeAlH:=3;
   end;
if (self.RadioButton5.Checked) then
   begin
   currentW:=deltaW;
   typeAlW:=4;
   end;
if (self.RadioButton12.Checked) then
   begin
   currentH:=deltaH;
   typeAlH:=4;
   end;
if (self.RadioButton6.Checked) then
   begin
   currentW:=parCenterW;
   typeAlW:=2;
   end;
if (self.RadioButton13.Checked) then
   begin
   currentH:=parCenterH;
   typeAlH:=2;
   end;
if (self.RadioButton7.Checked) then
   begin
   currentW:=StrTointDef(Edit1.Text,-100);
   typeAlW:=1;
   if  currentW<0 then typeAlW:=-1;
   end;
if (self.RadioButton14.Checked) then
   begin
   currentH:=StrTointDef(Edit2.Text,-100);;
   typeAlH:=1;
   if  currentH<0 then typeAlH:=-1;
   end;
ModalResult := mrOK;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
ModalResult := mrNo;
end;

procedure TForm3.Sortirovka(SvoObj: TComponentList);
var d,i,j: integer;
    g: boolean;
begin
g:=false;
while not g do
 begin
 g:=true;
 for i:=0 to SvoObj.Count-2  do
   begin
     for j:=i to SvoObj.Count-1  do
        begin
          if ((SvoObj.Items[arrW[i]] as TControl).Left>(SvoObj.Items[arrW[j]] as TControl).Left) then
             begin
              g:=false;
              d:=arrW[j];
              arrW[j]:=arrW[i];
              arrW[i]:=d;
             end;
       end;
   end;
end;

g:=false;
while not g do
 begin
 g:=true;
 for i:=0 to SvoObj.Count-2  do
   begin
     for j:=i to SvoObj.Count-1  do
        begin
          if ((SvoObj.Items[arrH[i]] as TControl).Top>(SvoObj.Items[arrH[j]] as TControl).Top) then
             begin
              g:=false;
              d:=arrH[j];
              arrH[j]:=arrH[i];
              arrH[i]:=d;
             end;
       end;
   end;
end;

end;


procedure TForm3.RadioButton1Click(Sender: TObject);
begin
if Sender=self.RadioButton7 then
Edit1.Enabled:=true else
begin
Edit1.Text:='';
Edit1.Enabled:=false;
end;
end;

procedure TForm3.RadioButton8Click(Sender: TObject);
begin
if Sender=self.RadioButton14 then
Edit2.Enabled:=true else
begin
Edit2.Text:='';
Edit2.Enabled:=false;
end;
end;

end.
