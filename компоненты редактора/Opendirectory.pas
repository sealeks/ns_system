unit Opendirectory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl;

type
  TForm12 = class(TForm)
    Edit1: TEdit;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Button1: TButton;
    Button2: TButton;
    FileListBox1: TFileListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
  dir: string;
  function Execute: boolean;
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

function  TForm12.Execute: boolean;
begin
result:=true;
Edit1.Text:=self.DirectoryListBox1.Directory;
if ShowModal=MrNo then result:=false;
end;

{$R *.dfm}

procedure TForm12.Button1Click(Sender: TObject);
begin
if not DirectoryExists(Edit1.Text) then
begin
 if MessageBox(0,'Такой путь не существует '+#13+'создать его?','Предупреждение',MB_YESNO+MB_ICONQUESTION)=IDNO then Abort else CreateDir(Edit1.Text);
end;
dir:=Edit1.Text;
Modalresult:=MrOk;
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
Modalresult:=MrNo;
end;

procedure TForm12.DirectoryListBox1Change(Sender: TObject);
begin
Edit1.Text:=self.DirectoryListBox1.Directory;
self.FileListBox1.Directory:=DirectoryListBox1.Directory;
end;

procedure TForm12.DriveComboBox1Change(Sender: TObject);
begin
DirectoryListBox1.Drive:=self.DriveComboBox1.Drive;
end;

end.
