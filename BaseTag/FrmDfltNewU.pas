unit FrmDfltNewU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Spin;

type
  TfrmdfltNew = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    GroupBox2: TGroupBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    ComboBox2: TComboBox;
    CheckBox2: TCheckBox;
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmdfltNew: TfrmdfltNew;

implementation

{$R *.dfm}

procedure TfrmdfltNew.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.checked then
  begin
    Edit3.Text := '4095';
    Edit5.Text := '100';
  end else
  begin
    Edit3.Text := '1';
    Edit5.Text := '1';
  end
end;

end.
