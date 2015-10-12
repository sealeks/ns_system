unit IMMIAlTrgEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, EditExpr;

type
  TAlTrgFrm = class(TForm)
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Button2: TButton;
    Button1: TButton;
    Edit1: TEditExpr;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlTrgFrm: TAlTrgFrm;

implementation

{$R *.dfm}

end.
