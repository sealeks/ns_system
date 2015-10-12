unit frmTegListClientU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, memStructsU, ParamU, math, StdCtrls;

type
  TfrmTegListClient = class(TForm)
    StringGrid2: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTegListClient: TfrmTegListClient;

implementation

{$R *.dfm}

procedure TfrmTegListClient.FormCreate(Sender: TObject);
begin
 with stringGrid2 do
 begin
   cells[0, 0] := '№';
   cells[1, 0] := 'ID';
   cells[2, 0] := 'Тег';
   cells[3, 0] := 'Значение';
   cells[4, 0] := 'Состояние';
 end;
end;

end.
