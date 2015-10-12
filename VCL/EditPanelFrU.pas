unit EditPanelFrU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EditExpr;

type
  TEditpanelFr = class(TForm)
    Edit1: TEditExpr;
    Edit2: TEditExpr;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditpanelFr: TEditpanelFr;

implementation

{$R *.dfm}

end.
