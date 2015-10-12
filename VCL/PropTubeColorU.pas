unit PropTubeColorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ExtDlgs, IMMITube;



type
  TPropTubeColor = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    PaintBox1: TPaintBox;
    Button3: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure PaintBox1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
     ColorsOn : TTubeColors;
     function Execute(var value: TTubeColors): boolean;

    { Public declarations }
  end;

var
PropTubeColor: TPropTubeColor;

implementation

{$R *.dfm}

procedure TPropTubeColor.PaintBox1Click(Sender: TObject);
var
  Pic: TPicture;
  i: integer;
begin
   Pic := TPicture.Create;
  if OpenPictureDialog1.Execute then
    pic.LoadFromFile(OpenPictureDialog1.FileName);
  for i := 1 to 15 do
    if i <= pic.Bitmap.Height then
      colorsOn.Colors[i]  := pic.bitmap.canvas.Pixels[1, i - 1]
    else colorsOn.Colors[i] := clNone;
  Pic.free;
  formPaint(nil);

end;

procedure TPropTubeColor.FormPaint(Sender: TObject);
var
  i: integer;
begin
    for i := 1 to 15 do begin
    if colorsOn.Colors[i] <> clNone then
    begin
      paintBox1.Canvas.pen.color := colorsOn.Colors[i];
      paintBox1.Canvas.MoveTo(1, i);
      paintBox1.Canvas.LineTo(width, i);
    end;
end;
end;

procedure TPropTubeColor.Button3Click(Sender: TObject);
var i,j: integer;
    colorb: Tcolor;
begin
   for i := low(colorsOn.Colors) to high(colorsOn.Colors) div 2 do
  begin
      colorb := colorsOn.Colors[i];
      colorsOn.Colors[i] := colorsOn.Colors[high(colorsOn.Colors) + low(colorsOn.Colors)- i];
      colorsOn.Colors[high(colorsOn.Colors) + low(colorsOn.Colors)- i] := colorb;
  end;
  j := 0;
  for i := low(colorsOn.Colors) to high(colorsOn.Colors) do
    if colorsOn.Colors[i] = clNone then inc(j)
      else break;
  for i := low(colorsOn.Colors) to high(colorsOn.Colors) do
    if i <= high(colorsOn.Colors) - j then
      colorsOn.Colors[i] := colorsOn.Colors[i + j]
    else colorsOn.Colors[i] := clNone;

  formpaint(nil);
end;

function TPropTubeColor.Execute(var value: TTubeColors): boolean;
var i: integer;
begin
ColorsOn:=value;
FormPaint(nil);
if ShowModal<>MrOk then result:=false else  result:=true;

end;


end.
