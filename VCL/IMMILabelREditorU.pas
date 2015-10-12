unit IMMILabelREditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EditExpr, Spin, PDJRotoLabel,
  IMMILabelRotateU;

type
  TLabelREditorFrm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    ColorDialog1: TColorDialog;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEditExpr;
    Edit3: TEditExpr;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    ComboBox1: TComboBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioGroup2: TRadioGroup;
    SpinEdit3: TSpinEdit;
    Label10: TLabel;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    Edit4: TEditExpr;
    EditExpr1: TEditExpr;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    EditExpr2: TEditExpr;
    EditExpr3: TEditExpr;
    EditExpr4: TEditExpr;
    EditExpr5: TEditExpr;
    Label5: TLabel;
    Label6: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    CheckBox2: TCheckBox;
    Panel1: TPanel;
    Button3: TButton;
    ColorDialog2: TColorDialog;
    Button4: TButton;
    FontDialog1: TFontDialog;
    ComboBox2: TComboBox;
    Label17: TLabel;
    label16: TIMMILabelRotate;
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpinEdit3Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    Lcolor: TColor;
    procedure updateS;
    { Public declarations }
  end;

var
  LabelREditorFrm: TLabelREditorFrm;




implementation

{$R *.dfm}

procedure TLabelREditorFrm.updateS;
begin
 self.RadioGroup1.Enabled:=self.CheckBox1.Checked;
 combobox1.Enabled:=(self.CheckBox1.Checked) and  (radiogroup1.ItemIndex=1);
 label9.Enabled:=(self.CheckBox1.Checked) and  (radiogroup1.ItemIndex=1);
 self.SpinEdit1.Enabled:=(self.CheckBox1.Checked) and (combobox1.ItemIndex=0) and  (radiogroup1.ItemIndex=1);
 self.SpinEdit2.Enabled:=(self.CheckBox1.Checked) and (combobox1.ItemIndex=0) and  (radiogroup1.ItemIndex=1);
 label7.Enabled:=(self.CheckBox1.Checked) and (combobox1.ItemIndex=0) and  (radiogroup1.ItemIndex=1);
 label8.Enabled:=(self.CheckBox1.Checked) and (combobox1.ItemIndex=0) and  (radiogroup1.ItemIndex=1);
 self.SpinEdit3.Enabled:=(self.CheckBox1.Checked) and (radiogroup1.ItemIndex=1);
 label10.visible:=(self.CheckBox1.Checked) and (radiogroup1.ItemIndex=1);
 self.RadioGroup2.Enabled:=(self.CheckBox1.Checked) and (radiogroup1.ItemIndex=1);
 groupbox1.Enabled:=self.CheckBox1.Checked;
end;

procedure TLabelREditorFrm.ComboBox1Change(Sender: TObject);
begin
updateS;
end;

procedure TLabelREditorFrm.RadioGroup1Click(Sender: TObject);
begin
  updateS;
end;

procedure TLabelREditorFrm.RadioGroup2Click(Sender: TObject);
begin
updateS;
end;

procedure TLabelREditorFrm.CheckBox1Click(Sender: TObject);
begin
 updateS;
end;

procedure TLabelREditorFrm.SpinEdit3Change(Sender: TObject);
begin
 updateS;
end;

procedure TLabelREditorFrm.Button3Click(Sender: TObject);
begin
self.colordialog2.color:=label16.color;
if self.colordialog2.execute then
  label16.color:=self.colordialog2.color;
end;

procedure TLabelREditorFrm.CheckBox2Click(Sender: TObject);
begin
self.Label16.Transparent:=CheckBox2.Checked;
end;

procedure TLabelREditorFrm.Button4Click(Sender: TObject);
begin
  self.FontDialog1.font.Assign(label16.Font);
if FontDialog1.execute then
 label16.Font.Assign(self.FontDialog1.font);
end;

procedure TLabelREditorFrm.ComboBox2Change(Sender: TObject);
begin
if self.ComboBox2.ItemIndex<0 then  self.ComboBox2.ItemIndex:=0;
label16.angle:=tugao(self.ComboBox2.ItemIndex);
end;

procedure TLabelREditorFrm.Edit1Change(Sender: TObject);
begin
label16.Caption:=Edit1.Text;
end;

end.
