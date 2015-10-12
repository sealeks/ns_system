unit Stringsprop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm14 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Edit1: TEdit;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
   function Execute(st: TstringList): Tstringlist;
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation
 {$R *.dfm}

function TForm14.Execute(st: TstringList): Tstringlist;
begin
edit1.Text:='';
result:=st;
self.ListBox1.Items.Clear;
self.ListBox1.Items:=st;
if ShowModal=MrOk then
begin
 result.Clear;
 result.AddStrings(ListBox1.Items);
 end;
end;


procedure TForm14.Button1Click(Sender: TObject);
var
sf: Topendialog;
begin
sf:=TopenDialog.Create(self);
if sf.Execute then
 try
  ListBox1.Items.LoadFromFile(sf.FileName);
 except
 end; 
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
ModalResult:=MrOk;
end;

procedure TForm14.Button3Click(Sender: TObject);
begin
ModalResult:=MrNo;
end;

procedure TForm14.Edit1Click(Sender: TObject);
begin
ListBox1.AddItem(edit1.Text,nil);
end;

procedure TForm14.Button4Click(Sender: TObject);
begin
if ((edit1.Text<>'') and (ListBox1.Items.IndexOf(edit1.Text)<0)) then ListBox1.AddItem(edit1.Text,nil);
end;

procedure TForm14.Button5Click(Sender: TObject);
begin
ListBox1.DeleteSelected;
end;

end.
