unit IMMITubeEditorU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ExtDlgs, EditExpr;

type
  TColorArray = array [1..15] of TColor;

  TIMMITubeForm = class(TForm)
    Button2: TButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    OpenPictureDialog1: TOpenPictureDialog;
    ComboBox1: TComboBox;
    Label4: TLabel;
    PaintBox1: TPaintBox;
    Button3: TButton;
    Button4: TButton;
    PaintBox2: TPaintBox;
    GroupBox2: TGroupBox;
    ComboBox3: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Edit1: TEditExpr;
    procedure PaintBox1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure PaintBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ColorsOn, ColorsOff: TColorArray;

  end;

var
  IMMITubeForm: TIMMITubeForm;

implementation

{$R *.dfm}

procedure TIMMITubeForm.PaintBox1Click(Sender: TObject);
var
  Pic: TPicture;
  i: integer;
begin
  Pic := TPicture.Create;
  if OpenPictureDialog1.Execute then
    pic.LoadFromFile(OpenPictureDialog1.FileName);
  for i := 1 to 15 do
    if i <= pic.Bitmap.Height then
      colorsOn[i]  := pic.bitmap.canvas.Pixels[1, i - 1]
    else colorsOn[i] := clNone;
  Pic.free;
  formPaint(nil);
end;

procedure TIMMITubeForm.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to 15 do begin
    if colorsOn[i] <> clNone then
    begin
      paintBox1.Canvas.pen.color := colorsOn[i];
      paintBox1.Canvas.MoveTo(1, i);
      paintBox1.Canvas.LineTo(width, i);
    end;
    if colorsOff[i] <> clNone then
    begin
      paintBox2.Canvas.pen.color := colorsOff[i];
      paintBox2.Canvas.MoveTo(1, i);
      paintBox2.Canvas.LineTo(width, i);
    end;
  end;
end;

procedure TIMMITubeForm.Button3Click(Sender: TObject);
var
  i, j: integer;
  color: TColor;
begin
  for i := low(colorsOn) to high(colorsOn) div 2 do
  begin
      color := colorsOn[i];
      colorsOn[i] := colorsOn[high(colorsOn) + low(colorsOn)- i];
      colorsOn[high(colorsOn) + low(colorsOn)- i] := color;
  end;
  j := 0;
  for i := low(colorsOn) to high(colorsOn) do
    if colorsOn[i] = clNone then inc(j)
      else break;
  for i := low(colorsOn) to high(colorsOn) do
    if i <= high(colorsOn) - j then
      colorsOn[i] := colorsOn[i + j]
    else colorsOn[i] := clNone;

  formpaint(self);
end;

procedure TIMMITubeForm.Button4Click(Sender: TObject);
var
  i, j: integer;
  color: TColor;
begin
  for i := low(colorsOff) to high(colorsOff) div 2 do
  begin
      color := colorsOff[i];
      colorsOff[i] := colorsOff[high(colorsOff) + low(colorsOff)- i];
      colorsOff[high(colorsOff) + low(colorsOff)- i] := color;
  end;
  j := 0;
  for i := low(colorsOff) to high(colorsOff) do
    if colorsOff[i] = clNone then inc(j)
      else break;
  for i := low(colorsOff) to high(colorsOff) do
    if i <= high(colorsOff) - j then
      colorsOff[i] := colorsOff[i + j]
    else colorsOff[i] := clNone;

  formpaint(self);
end;

procedure TIMMITubeForm.PaintBox2Click(Sender: TObject);
var
  Pic: TPicture;
  i: integer;
begin
  Pic := TPicture.Create;
  if OpenPictureDialog1.Execute then
    pic.LoadFromFile(OpenPictureDialog1.FileName);
  for i := 1 to 15 do
    if i <= pic.Bitmap.Height then
      colorsOff[i]  := pic.bitmap.canvas.Pixels[1, i - 1]
    else colorsOff[i] := clNone;
  Pic.free;
  formPaint(nil);
end;

end.
