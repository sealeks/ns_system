unit IMMIPropertysEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, Spin, ComCtrls, EditExpr,FormManager, RedacOCForm;

type
  TIMMIPropertysForm = class(TForm)
    Button2: TButton;
    Button1: TButton;
    OpenPictureDialog2: TOpenPictureDialog;
    TPageControl1: TPageControl;
    tsPicture: TTabSheet;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    tsControl: TTabSheet;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    tsVisible: TTabSheet;
    Label6: TLabel;
    tsValue: TTabSheet;
    Label1: TLabel;
    tsLine: TTabSheet;
    tsFill: TTabSheet;
    tsBlink: TTabSheet;
    tsFont: TTabSheet;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEditExpr;
    Edit4: TEditExpr;
    Edit3: TEditExpr;
    Edit2: TEditExpr;
    Label9: TLabel;
    EditExpr1: TEditExpr;
    Button3: TButton;
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    formM: TFormManager;
    des: tComponent;
    { Public declarations }
  end;

var
  IMMIPropertysForm: TIMMIPropertysForm;

implementation

{$R *.dfm}

procedure TIMMIPropertysForm.Image2Click(Sender: TObject);
var
  dir: string;
begin
  dir := GetCurrentDir;
  if OpenPictureDialog2.Execute then
    Image2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  SetCurrentDir(dir);
end;

procedure TIMMIPropertysForm.Image1Click(Sender: TObject);
var
  dir: string;
begin
  dir := GetCurrentDir;
  if OpenPictureDialog2.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog2.FileName);
  SetCurrentDir(dir);
end;

procedure TIMMIPropertysForm.Button3Click(Sender: TObject);
var  PropT: TOKBottomDlgForm;
begin
 if des=nil then exit;
 try
    PropT:=TOKBottomDlgForm.Create(Application);
    PropT.Execute(des,FormM);
  finally
    PropT.Free;

  end;
end;

procedure TIMMIPropertysForm.FormCreate(Sender: TObject);
begin
  formM:=TFormManager.create(self);
end;

procedure TIMMIPropertysForm.FormDestroy(Sender: TObject);
begin
   formm.free;
end;

end.
