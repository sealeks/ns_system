unit ImitEditFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls;

type
  TImitEditForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit1: TSpinEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    StaticText1: TStaticText;
    Edit6: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImitEditForm: TImitEditForm;

implementation

{$R *.dfm}

end.
