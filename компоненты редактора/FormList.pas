unit FormList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtDlgs,ImageForm,globalValue;

type
  TForm7 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Label5: TLabel;
    ComboBox1: TComboBox;
    Button3: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  Redac: TComponent;
  projecpicture: boolean;
  formBitmap: TBitmap;
  function Execute(nameF: string): Tform;

    { Public declarations }
  end;

var
  Form7: TForm7;
  NameF: string;

implementation

{$R *.dfm}

uses redactor;


function TForm7.Execute(nameF: string): Tform;
var i: integer;
   formcr: tform;
   namecap: string;

function ReplicateCap(value: string): boolean;
var i: integer;
begin
  result:=true;
  for i:=0 to (Redac as Tredactor).RedactorForm.Count-1 do
    if Tform((Redac as Tredactor).RedactorForm.Items[i]).Caption=value then
    begin
    result:=false;
    exit;
    end;
end;

begin
result:=nil;
projecpicture:=false;
if assigned(formBitmap) then formBitmap.Free;
  ComboBox1.Clear;
  ComboBox1.Text:='Без полосы заголовка';
  ComboBox1.Items.Add('Диалоговая');
  ComboBox1.Items.Add('Без полосы заголовка');
  ComboBox1.Items.Add('С изменяемыми размерами');
  ComboBox1.Items.Add('С неизменяемыми размерами и меньшей полосой');
  ComboBox1.Items.Add('С изменяемыми размерами и меньшей полосой');
  CheckBox1.Checked:=true;
  CheckBox1.Enabled:=false;
  i:=1;
while not  ReplicateCap('Форма '+ inttostr(i)) do inc(i);
Edit1.Text:='Форма '+InttoStr(i);
if (rProject in (Redac as Tredactor).ReadctorStatus) then
       CheckBox1.Enabled:=true;
edit2.Text:='20';
edit3.Text:='0';
edit4.Text:='860';
edit5.Text:='1150';
if Showmodal=MrOk then
begin
With TForm.Create(Redac) do
begin
visible:=true;
Name:=NameF;
caption:=Edit1.text;
top:=StrToIntDef(edit2.Text,20);
left:=StrToIntDef(edit3.Text,0);
height:=StrToIntDef(edit4.Text,400);
width:=StrToIntDef(edit5.Text,600);
result:=(Redac.components[componentindex] as Tform);
result.Tag:=1;
if  combobox1.Items.IndexOf(ComboBox1.text)=1 then result.BorderStyle:=bsNone else
 if  combobox1.Items.IndexOf(ComboBox1.text)=2 then result.BorderStyle:=bsSizeable else
   if  combobox1.Items.IndexOf(ComboBox1.text)=3 then result.BorderStyle:=bsToolWindow else
     if  combobox1.Items.IndexOf(ComboBox1.text)=4 then result.BorderStyle:=bsSizeToolWin else
        result.BorderStyle:=bsDialog;
if CheckBox1.Checked then result.visible:=true else result.visible:=false;
     end;
end;
end;

procedure TForm7.Button1Click(Sender: TObject);
var i: integer;
     fi: TextFile;
     fullstring: string;
     filn: string;

begin
if CheckBox1.Enabled then
  begin
    for i:=0 to (Redac as Tredactor).RedactorForm.Count-1 do
    begin
    if Edit1.Text=TForm((Redac as Tredactor).RedactorForm.items[i]).caption then
      begin
       MessageBox(0,'В проекте имеется форма с таким именем!','Ошибка',MB_OK);
       Abort;
      end
    end;
    end;
NameF:=Edit1.Text;
Modalresult:=MrOk;
end;

procedure TForm7.Button2Click(Sender: TObject);
begin
Modalresult:=MrNo;
end;


procedure TForm7.Button3Click(Sender: TObject);
var ImageForm: TForm18;
    kbit: TBitmap;
begin
kBit:=TBitmap.Create;
ImageForm:=TForm18.Create(self);
if (Redac as Tredactor).ProjectBitmap<>nil then ImageForm.BitmapProject.Assign((redac as Tredactor).ProjectBitmap);
formBitmap:=Tbitmap.Create;
ImageForm.RedBit(kBit);
projecpicture:=ImageForm.ImagProject;
formBitmap.Assign(kBit);


end;

procedure TForm7.FormCreate(Sender: TObject);
begin
projecpicture:=false;
end;

initialization
RegisterClasses([TForm]);

end.
