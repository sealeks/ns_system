unit ImmiSys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Outline, DirOutln, ComCtrls, ShellCtrls, StdCtrls,
  FileCtrl;

type
  TImmiSysForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Edit1: TEdit;
    procedure DirectoryOutline1Click(Sender: TObject);
    procedure DriveComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    function Exec(var vardir: string): boolean;
    { Public declarations }
  end;

var
  ImmiSysForm: TImmiSysForm;
  dir:string;
implementation

{$R *.dfm}

function TImmiSysForm.Exec(var vardir: string): boolean;
begin
 result:=false;
 dir:=vardir;
 try
   DirectoryListBox1.Directory:=vardir;
//self.DriveComboBox1.Drive:=DirectoryOutline1.Drive;
except
end;
// self.FileListBox1.Directory:=DirectoryListBox1.Directory;
 if ShowModal=MrOk then
 begin
 result:=true;
 vardir:=edit1.Text;
 vardir:=trim(vardir);
 if vardir[length(vardir)]<>'\' then vardir:=vardir+'\';
 end;
end;

procedure TImmiSysForm.DirectoryOutline1Click(Sender: TObject);
begin
//self.FileListBox1.Directory:=self.DirectoryListBox1.Directory;
dir:=self.DirectoryListBox1.Directory;
end;

procedure TImmiSysForm.DriveComboBox1Change(Sender: TObject);
begin
self.DirectoryListBox1.Drive:=self.DriveComboBox1.Drive;
edit1.Text:=DirectoryListbox1.Directory;
end;

end.
