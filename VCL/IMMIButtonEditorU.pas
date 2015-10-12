unit IMMIButtonEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, ExtDlgs, EditExpr, FormManager, RedacOCForm,
  dxCore, dxButton;

type
  TButtonEditorFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    EditExpr1: TEditExpr;
    EditExpr2: TEditExpr;
    Label1: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    Edit2: TEdit;
    SpinEdit2: TSpinEdit;
    Label5: TLabel;
    Button3: TButton;
    EditExpr3: TEditExpr;
    Label6: TLabel;
    Label8: TLabel;
    EditExpr4: TEditExpr;
    procedure Image1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  formM: TFormManager;
  des: tComponent;
    { Public declarations }
  end;

var
  ButtonEditorFrm: TButtonEditorFrm;

implementation

{$R *.dfm}

procedure TButtonEditorFrm.Image1Click(Sender: TObject);
var
  dir: string;
begin
 // dir := GetCurrentDir;
  //if OpenPictureDialog1.Execute then
    //Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
 // SetCurrentDir(dir);
end;

procedure TButtonEditorFrm.FormCreate(Sender: TObject);
begin
   formM:=TFormManager.create(self);
end;

procedure TButtonEditorFrm.FormDestroy(Sender: TObject);
begin
   formM.free;
end;

procedure TButtonEditorFrm.Button3Click(Sender: TObject);
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

end.
