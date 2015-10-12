unit QueryForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,IMMIFormU, dxCore, dxButton, ImmibuttonXp, ExtCtrls, IMMIPanelU,
  StdCtrls;

type
  TQueryForm = class(TIMMIForm)
    IMMIPanel1: TIMMIPanel;
    IMMIPanel2: TIMMIPanel;
    ImmiButtonXp1: TImmiButtonXp;
    ImmiButtonXp2: TImmiButtonXp;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formQ: TQueryForm;

implementation

{$R *.dfm}

end.
 