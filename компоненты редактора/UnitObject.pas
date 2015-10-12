unit UnitObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,Contnrs,TypInfo,ExtCtrls, StdCtrls, ObjInsp1, ValEdit,
  ComCtrls, dblookup;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    Edit1: TEdit;
    ObjInsp11: TObjInsp1;
    CheckBox1: TCheckBox;
    procedure ComboBox1MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure ComboBox1Select(Sender: TObject);
    procedure ObjInsp11KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObjInsp11KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);

   
  private

    { Private declarations }
  public
    objList: Tlist;
    procedure ShowS(SvoObj: TList);
    destructor Destroy;
    { Public declarations }
  end;

var
  Form2: TForm2;




implementation

uses
  redactor,Controlddh;


destructor TForm2.Destroy;
begin
objList.Free;
inherited;
end;

procedure TForm2.showS(SvoObj: TList);
var j,i: integer;
begin
i:=0;
if CheckBox1.Checked then self.FormStyle:=fsStayOnTop else self.FormStyle:=fsNormal;
edit1.Text:='';
ComboBox1.Clear;
if (owner as TRedactor).RedactorForm.Count>0 then
begin
try
objList.Assign(svoobj);
except
Form2.ComboBox1.Text:='';
end;
end;
while  i<SvoObj.Count do
   begin
   if i<SvoObj.Count-1 then
      Edit1.Text:=Edit1.Text+TComponent(SvoObj.Items[i]).Name+' ,'
   else
     Edit1.Text:=Edit1.Text+TComponent(SvoObj.Items[i]).Name;
   inc(i);
   end;
ComboBox1.Items.Clear;
i:=0;
while  (i<((owner as TRedactor).RedactorForm).Count) do
   begin
    if  TForm((owner as TRedactor).RedactorForm.Items[i]).Showing then
   begin
       for j:=0 to TForm((owner as TRedactor).RedactorForm.Items[i]).ComponentCount-1 do
         begin
         if not (TForm((owner as TRedactor).RedactorForm.Items[i]).Components[j] is Tcontrolddh) then
             ComboBox1.AddItem(TForm((owner as TRedactor).RedactorForm.Items[i]).Components[j].Name,TForm((owner as TRedactor).RedactorForm.Items[i]).Components[j]);
         end;
           ComboBox1.AddItem(TForm((owner as TRedactor).RedactorForm.Items[i]).Name,TForm((owner as TRedactor).RedactorForm.Items[i]));
       end;
       inc(i);

   end;

 Edit1.Hint:=Edit1.Text;
if ((SvoObj<>nil) and (SvoObj.Count<>0)) then form2.ObjInsp11.ShowS(SvoObj) else form2.ObjInsp11.Strings.Clear;


end;

{$R *.dfm}



procedure TForm2.ComboBox1MeasureItem(Control: TWinControl; Index: Integer;
  var Height: Integer);
  var i: integer;
begin
i:=0;
end;

procedure TForm2.ComboBox1Select(Sender: TObject);
  var i: integer;

begin

if ((not (pShift in (owner as TRedactor).Keys)) or (((pShift in (owner as TRedactor).Keys)) and (objList.Count=0))) then
  begin
   (owner as TRedactor).DeleteSelected;
   objList.clear;
   objList.Add(ComboBox1.Items.Objects[ ComboBox1.ItemIndex]);
 ObjInsp11.ShowS(objList);
   if TObject(ComboBox1.Items.Objects[ ComboBox1.ItemIndex]) is TForm then
   TForm(ComboBox1.Items.Objects[ ComboBox1.ItemIndex]).Show else
   if TObject(ComboBox1.Items.Objects[ComboBox1.ItemIndex]) is TControl then
  (owner as TRedactor).SelectControl(TControl(ComboBox1.Items.Objects[ ComboBox1.ItemIndex]));
  (owner as TRedactor).PropertyForm;
  (owner as TRedactor).SelectTree;
  end
else
   begin
  if not objList.IndexOf(ComboBox1.Items.Objects[ComboBox1.Items.IndexOf(ComboBox1.Text)])<0 then
  Abort;
   objList.Add(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
   ObjInsp11.ShowS(objList);
   if TObject(ComboBox1.Items.Objects[ ComboBox1.ItemIndex]) is TControl then
  (owner as TRedactor).SelectControl(TControl(ComboBox1.Items.Objects[ComboBox1.ItemIndex]));
   Form2.ComboBox1.Text:='';
   edit1.Text:='';
 end;
    edit1.Text:='';
   i:=0;
   while  i<objList.Count do
   begin
   if i<objList.Count-1 then
      edit1.Text:=edit1.Text+TComponent(objList.Items[i]).Name+' ,'
   else
     edit1.Text:=edit1.Text+TComponent(objList.Items[i]).Name;
   inc(i);
   end;
Edit1.Hint:=Edit1.Text;
end;

procedure TForm2.ObjInsp11KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Edit1.Hint:=Edit1.Text;
if ssShift in Shift  then
begin
//if not Multi then Multi:=true else Multi:=false;
end;
end;

procedure TForm2.ObjInsp11KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Edit1.Hint:=Edit1.Text;
//if  ssShift in Shift then   Multi:=false;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 objList:=TList.Create;
end;

initialization
RegisterClasses([TColorBox]);
end.
