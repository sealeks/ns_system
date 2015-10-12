unit IMMIEditEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, EditExpr;

type
  TEditEditorFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Edit1: TEditExpr;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditEditorFrm: TEditEditorFrm;

implementation

{$R *.dfm}

end.
