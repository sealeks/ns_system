unit IMMITrackBEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, EditExpr;

type
  TTrackBEditorFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    SpinEdit1: TSpinEdit;
    Label7: TLabel;
    Edit1: TEditExpr;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrackBEditorFrm: TTrackBEditorFrm;

implementation

{$R *.dfm}

end.
