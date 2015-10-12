unit FormPackage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormPackage= class(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPack: TFormPackage;

implementation

{$R *.dfm}

procedure TFormPackage.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
       edit1.Text:=OpenDialog1.FileName;
end;

procedure TFormPackage.Button2Click(Sender: TObject);
begin
if Edit1.Text<>'' then Memo1.Lines.Add(Edit1.Text)
end;

procedure TFormPackage.Button5Click(Sender: TObject);
begin
memo1.ClearSelection;
end;

procedure TFormPackage.FormCreate(Sender: TObject);
begin
 edit1.Text:='';
 memo1.Lines.Clear;
end;

end.
