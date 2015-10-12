unit Projectdialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, Menus, IdGlobal, memStructsU, OpenDirectory;

type
  TForm9 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit2: TEdit;
    Button3: TButton;
    Label2: TLabel;
    Button4: TButton;
    Label3: TLabel;
    procedure N1Click(Sender: TObject);
    procedure DriveComboBox1Enter(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  function shows: boolean;
    { Public declarations }
  end;

var
  Form9: TForm9;
  creatpr: boolean;
  sf: TForm12;

implementation

uses Redactor;

{$R *.dfm}

 function TForm9.shows: boolean;
begin

sf:= TForm12.Create(self);
Edit1.Text:='C:\';
Edit2.Text:='C:\';
creatpr:=false;
self.RadioButton1.Checked:=true;
Edit2.Enabled:=false;
Button3.Enabled:=false;
//Edit1.text:=DirectoryListBox1.Directory;
ShowModal;
result:=creatpr;
sf.Free;
end;


procedure TForm9.N1Click(Sender: TObject);
begin
//CreateDir(DirectoryListBox1.Directory+'/Новая');


end;

procedure TForm9.DriveComboBox1Enter(Sender: TObject);
begin
//DirectoryListBox1.Directory:=DriveComboBox1.Drive+':/';
//Edit1.text:=DirectoryListBox1.Directory;
end;

procedure TForm9.DirectoryListBox1Change(Sender: TObject);
begin
 //Edit1.text:=DirectoryListBox1.Directory;
end;

procedure TForm9.Button1Click(Sender: TObject);
  var
  io: integer;

begin
  if not DirectoryExists(Edit1.Text) then
begin
 if MessageBox(0,'Такой путь не существует '+#13+'создать его?','Предупреждение',MB_YESNO+MB_ICONQUESTION)=IDNO then Abort else CreateDir(Edit1.Text);
end;
  CreateDir(Edit1.Text+'\Forms');
  CreateDir(Edit1.Text+'\dbData');
  CreateDir(Edit1.Text+'\exe');
  if self.RadioButton1.Checked then
     begin
       CopyFileTo('f:\эксперимент\Null\analog.mem',Edit1.Text+'\DBData\analog.mem');
       CopyFileTo('f:\эксперимент\Null\command.mem',Edit1.Text+'\DBData\command.mem');
       CopyFileTo('f:\эксперимент\Null\strings.mem',Edit1.Text+'\DBData\strings.mem');
       CopyFileTo('f:\эксперимент\Null\calc1.mem',Edit1.Text+'\DBData\calc1.mem');

     end
  else
     begin
     if (FileExists(Edit2.Text+'\analog.mem') and
          FileExists(Edit2.Text+'\calc1.mem') and
              FileExists(Edit2.Text+'\command.mem') and
                  FileExists(Edit2.Text+'\strings.mem')) then
                   begin
                    CopyFileTo(Edit2.Text+'\analog.mem',Edit1.Text+'\DBData\analog.mem');
                     CopyFileTo(Edit2.Text+'\calc1.mem',Edit1.Text+'\DBData\calc1.mem');
                     CopyFileTo(Edit2.Text+'\command.mem',Edit1.Text+'\DBData\command.mem');
                     CopyFileTo(Edit2.Text+'\strings.mem',Edit1.Text+'\DBData\strings.mem');

                   end else
                   begin
                   MessageBox(0,'МЕМ-файлы в указанной папке не найдены!','Ошибка',MB_OK);
                   self.RadioButton1.Checked:=true;
                   Edit2.Enabled:=false;
                   Button3.Enabled:=false;
                   Abort;
                   end;


     end;
  try
 // if assigned(rtitems) then rtitems.Free;
  //rtitems:=TAnalogmems.Create(Edit1.Text+'\DBData\');
  (owner as Tredactor).AnalogMem(Edit1.Text+'\DBData\');
  io:=filecreate(Edit1.Text+'\config.cfg');
  fileclose(io);
  (owner as Tredactor).ReadctorStatus:=(owner as Tredactor).ReadctorStatus+[rProject];
  (owner as Tredactor).DirProject:=(owner as Tredactor).DirProject+Edit1.Text;
  except
   MessageBox(0,'Возможно МЕМ-файлы повреждены!','Ошибка',MB_OK);
   abort;
   end;
    CopyFileTo('f:\эксперимент\exe\LogikaP1.exe',Edit1.Text+'\exe\LogikaP1.exe');
   creatpr:=true;
  Modalresult:=mrOk;


end;

procedure TForm9.Button2Click(Sender: TObject);
begin
 Modalresult:=mrNo;
  creatpr:=false;
end;

procedure TForm9.Button4Click(Sender: TObject);
begin
if sf.Execute then Edit1.Text:=sf.dir;
end;

procedure TForm9.RadioButton1Click(Sender: TObject);
begin
Edit2.Enabled:=false;
Button3.Enabled:=false;
end;

procedure TForm9.RadioButton2Click(Sender: TObject);
begin
Edit2.Enabled:=true;
Button3.Enabled:=true;
end;

procedure TForm9.Button3Click(Sender: TObject);
begin
if sf.Execute then
  Edit2.Text:=sf.dir
else
  begin
  Edit2.Enabled:=false;
  Button3.Enabled:=false;
  RadioButton1.Checked:=true;
  end;


end;

end.
