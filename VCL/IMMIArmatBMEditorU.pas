unit IMMIArmatBMEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ExtDlgs, EditExpr;

type
  TArmatBmEditorFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SpinEdit1: TSpinEdit;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    Edit8: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    Bevel1: TBevel;
    OpenPictureDialog2: TOpenPictureDialog;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Edit1: TEditExpr;
    Edit2: TEditExpr;
    Edit3: TEditExpr;
    Edit4: TEditExpr;
    Edit5: TEditExpr;
    Edit6: TEditExpr;
    EditExpr1: TEditExpr;
    Label10: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ArmatBmEditorFrm: TArmatBmEditorFrm;

implementation

{$R *.dfm}

procedure TArmatBmEditorFrm.Image1Click(Sender: TObject);
var
  dir: string;
begin
  dir := GetCurrentDir;
  if OpenPictureDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  SetCurrentDir(dir);
end;

procedure TArmatBmEditorFrm.Image2Click(Sender: TObject);
var
  dir: string;
begin
  dir := GetCurrentDir;
  if OpenPictureDialog1.Execute then
    Image2.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  SetCurrentDir(dir);
end;

procedure TArmatBmEditorFrm.Image3Click(Sender: TObject);
var
  dir: string;
begin
  dir := GetCurrentDir;
  if OpenPictureDialog1.Execute then
    Image3.Picture.LoadFromFile(OpenPictureDialog1.FileName);
  SetCurrentDir(dir);
end;

end.
