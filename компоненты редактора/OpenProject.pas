unit OpenProject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl,StrUtils, EditExpr;

type
 TFormCuMy = class(TCustomForm);

type
  TForm10 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public

    Redac: TComponent;
    function shows: boolean;
    procedure N1Click(Sender: TObject);
    procedure DriveComboBox1Enter(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    { Public declarations }
  end;

var
  Form10: TForm10;
  creatpr: boolean;
  lastform: integer;

implementation

uses Redactor;

{$R *.dfm}

function TForm10.shows: boolean;
var  i: integer;
begin
{if ((Redac as Tredactor).activWind<>-1) then lastform:=(Redac as Tredactor).activWind;     }
if  (rProject in (Redac as Tredactor).ReadctorStatus) then Label1.Caption:='Формы проекта' else
  if  rForm in (Redac as Tredactor).ReadctorStatus then Label1.Caption:='Открытые формы' else
   begin
    self.Hide;
    Abort;
   end;
i:=0;
ListBox1.Clear;
while i<(Redac as Tredactor).componentCount do
begin
 ListBox1.AddItem(TForm((Redac as Tredactor).components[i]).Caption,nil);
 inc(i);
 end;
Show;
//(Redac as Tredactor).activWind:=lastform;
end;


procedure TForm10.N1Click(Sender: TObject);
begin



end;

procedure TForm10.DriveComboBox1Enter(Sender: TObject);
begin

end;

procedure TForm10.DirectoryListBox1Change(Sender: TObject);
begin

end;







procedure TForm10.Button1Click(Sender: TObject);
var i: integer;
j: integer;
begin
  { j:=-1;
   for i:=0 to (Redac as Tredactor).RedactorForm.Count-1 do
   if TForm((Redac as Tredactor).RedactorForm.items[i]).showing then  j:=i;
  // if j<0 then (Redac as Tredactor).activwind:=0 else (Redac as Tredactor).activwind:=j;
   ModalResult:=MrOk;   }
   self.Hide;
end;

procedure TForm10.Button4Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<(Redac as Tredactor).componentCount do
begin
if (ListBox1.Selected[i]) then
   begin
     //TFormCuMy((Redac as Tredactor).components[i]).FFormState:=
       //   TFormCuMy((Redac as Tredactor).components[i]).FFormState + [fsShowing];
    (Redac as Tredactor).ShowWindD(TForm((Redac as Tredactor).components[i]));
     lastform:=i;
     end

     else


     //TFormCuMy((Redac as Tredactor).RedactorForm.items[i]).FFormState:=
     //     TFormCuMy((Redac as Tredactor).RedactorForm.items[i]).FFormState-[fsShowing];
     (Redac as Tredactor).HideWindD(TForm((Redac as Tredactor).components[i]));
   inc(i);
   end;
 self.Show;
 {(Redac as Tredactor).ActivWind:=lastform;}
 (Redac as Tredactor).PropertyForm;
end;

procedure TForm10.Button3Click(Sender: TObject);
 var i: integer;
begin
i:=0;
while i<(Redac as Tredactor).componentCount do
begin
if (ListBox1.Selected[i]) then
   begin
  // TFormCuMy((Redac as Tredactor).RedactorForm.items[i]).FFormState:=
    //      TFormCuMy((Redac as Tredactor).RedactorForm.items[i]).FFormState-[fsShowing];
   (Redac as Tredactor).HideWindD(TForm((Redac as Tredactor).components[i]));

   end;
   inc(i);
   end;
 {(Redac as Tredactor).ActivWind:=0;  }
 (Redac as Tredactor).PropertyForm;
end;

procedure TForm10.Button2Click(Sender: TObject);
var i: integer;
begin
i:=0;
while i<(Redac as Tredactor).componentCount do
begin
if (ListBox1.Selected[i]) then
    begin
    // TFormCuMy((Redac as Tredactor).components[i]).FFormState:=
       //   TFormCuMy((Redac as Tredactor).componts[i]).FFormState+[fsShowing];
    (Redac as Tredactor).ShowWindD(TForm((Redac as Tredactor).components[i]));
     lastform:=i;
     end;
   inc(i);
   end;
 self.Show;
 {(Redac as Tredactor).ActivWind:=lastform;}
 (Redac as Tredactor).PropertyForm;
 //(owner as TForm).Show;
end;

procedure TForm10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
self.Hide;
end;

procedure TForm10.ListBox1DblClick(Sender: TObject);
begin
Button2Click(nil);
self.Hide;
end;

end.
