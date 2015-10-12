unit IMMIImgEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, Spin, ComCtrls;

type
  TIMMIImgForm = class(TForm)
    Button2: TButton;
    Button1: TButton;
    OpenPictureDialog2: TOpenPictureDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Edit1: TEdit;
    Label1: TLabel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Image1: TImage;
    Label2: TLabel;
    Image2: TImage;
    Label3: TLabel;
    TabSheet2: TTabSheet;
    Edit2: TEdit;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Label5: TLabel;
    TabSheet3: TTabSheet;
    Edit3: TEdit;
    Label6: TLabel;
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IMMIImgForm: TIMMIImgForm;

implementation

{$R *.dfm}

procedure TIMMIImgForm.Image2Click(Sender: TObject);
begin
  if OpenPictureDialog2.Execute then
    Image2.Picture.LoadFromFile(OpenPictureDialog2.FileName);
end;

procedure TIMMIImgForm.Image1Click(Sender: TObject);
begin
  if OpenPictureDialog2.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog2.FileName);
end;

end.
