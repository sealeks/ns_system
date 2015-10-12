unit IMMIShapeEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, Mask, EditExpr;

type
  TShapeEditorFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ColorBox2: TColorBox;
    ColorBox1: TColorBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Label6: TLabel;
    ComboBox2: TComboBox;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit1: TEditExpr;
    Edit2: TEditExpr;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpinEdit1: TSpinEdit;
    Button3: TButton;
    Panel1: TPanel;
    ColorDialog1: TColorDialog;
    Shape1: TShape;
    procedure ColorBox1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure UpdateS;
    { Public declarations }
  end;

var
  ShapeEditorFrm: TShapeEditorFrm;

implementation

{$R *.dfm}

procedure TShapeEditorFrm.UpdateS;
begin
shape1.Shape:=tshapetype(combobox1.ItemIndex);
shape1.Brush.Color:=colorbox1.Selected;
shape1.pen.Width:=spinedit1.Value;
end;

procedure TShapeEditorFrm.ColorBox1Change(Sender: TObject);
begin
UPDATES;
end;

procedure TShapeEditorFrm.Button3Click(Sender: TObject);
begin
IF colordialog1.Execute then shape1.pen.Color:=colordialog1.Color;
end;

end.
