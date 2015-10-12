unit frmEditCSVU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids;

type
  TfrmEditCSV = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    StringGrid1: TStringGrid;
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditCSV: TfrmEditCSV;

implementation

{$R *.dfm}

procedure TfrmEditCSV.ListBox1DblClick(Sender: TObject);
begin
  button1.Click;
end;

procedure TfrmEditCSV.FormResize(Sender: TObject);
var
  i, j, MaxItemLength: integer;
begin
  for i := 0 to StringGrid1.ColCount - 1 do
  begin
    MaxItemLength := 0;
    for j := 0 to StringGrid1.RowCount do
    if MaxItemLength < length(StringGrid1.Cells[i, j]) then
        maxItemLength := length(StringGrid1.Cells[i, j]);
    StringGrid1.ColWidths[i] := (MaxItemLength + 5) * 5;
  end;
end;

end.
