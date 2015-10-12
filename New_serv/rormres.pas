unit rormres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxCore, dxButton, ImmibuttonXp, Grids, ColorStringGrid;

type
  TFormRecept = class(TForm)
    ColorStringGrid1: TColorStringGrid;
    ImmiButtonXp1: TImmiButtonXp;
    ImmiButtonXp2: TImmiButtonXp;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRecept: TFormRecept;

implementation

{$R *.dfm}

end.
