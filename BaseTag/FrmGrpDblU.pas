unit FrmGrpDblU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls;

type
  TFrmGrpDbl = class(TForm)
    Label5: TLabel;
    Label1: TLabel;
    ed1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    cbGrp1: TComboBox;
    cbGRP2: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmGrpDbl: TFrmGrpDbl;

implementation

{$R *.dfm}

end.
