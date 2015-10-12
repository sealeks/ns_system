unit IMMITube1;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Expr, Graphics, Forms,
  constDef, Math, dialogs, IMMITubeEditorU;

type
 // TTubeColorPresets = (cpGas, cpMaz, cpSteam, cpAir, cpSmoke, cpNone);
  TTubeOrient = (toVert, toHor);
  TTubeEnd = (teDirect, teConer1, teConer2);
  TTubeKind = (kGas, kMaz, kWat, kDym, kNone);

  TTubeColors = class(tPersistent)
  private
    fCount: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    Colors: TColorArray;
    function calcColCount: integer;
    procedure SetColor11 (iColor: TColor);
    procedure SetColor12 (iColor: TColor);
    procedure SetColor13 (iColor: TColor);
    procedure SetColor14 (iColor: TColor);
    procedure SetColor15 (iColor: TColor);
    procedure SetColor16 (iColor: TColor);
    procedure SetColor17 (iColor: TColor);
    procedure SetColor18 (iColor: TColor);
    procedure SetColor19 (iColor: TColor);
    procedure SetColor20 (iColor: TColor);
    procedure SetColor21 (iColor: TColor);
    procedure SetColor22 (iColor: TColor);
    procedure SetColor23 (iColor: TColor);
    procedure SetColor24 (iColor: TColor);
    procedure SetColor25 (iColor: TColor);
    Function GetColor11: tColor;
    Function GetColor12: tColor;
    Function GetColor13: tColor;
    Function GetColor14: tColor;
    Function GetColor15: tColor;
    Function GetColor16: tColor;
    Function GetColor17: tColor;
    Function GetColor18: tColor;
    Function GetColor19: tColor;
    Function GetColor20: tColor;
    Function GetColor21: tColor;
    Function GetColor22: tColor;
    Function GetColor23: tColor;
    Function GetColor24: tColor;
    Function GetColor25: tColor;
    constructor Create;
  published
    property Count: integer read fCount write fCount;
    property Color11: TColor read GetColor11 write SetColor11;
    property Color12: TColor read GetColor12 write SetColor12;
    property Color13: TColor read GetColor13 write SetColor13;
    property Color14: TColor read GetColor14 write SetColor14;
    property Color15: TColor read GetColor15 write SetColor15;
    property Color16: TColor read GetColor16 write SetColor16;
    property Color17: TColor read GetColor17 write SetColor17;
    property Color18: TColor read GetColor18 write SetColor18;
    property Color19: TColor read GetColor19 write SetColor19;
    property Color20: TColor read GetColor20 write SetColor20;
    property Color21: TColor read GetColor21 write SetColor21;
    property Color22: TColor read GetColor22 write SetColor22;
    property Color23: TColor read GetColor23 write SetColor23;
    property Color24: TColor read GetColor24 write SetColor24;
    property Color25: TColor read GetColor25 write SetColor25;
  end;

  TIMMITube1 = class(TGraphicControl)
  private
    { Private declarations }
    fColorsOn, fColorsOff, fColorsCur: TTubeColors;
    fExprString: String;
    fExpr: tExpretion;
    fOrient: TTubeOrient;
   // fPresets: TTubeColorPresets;
    fisOn: boolean;
    fTubeEnd1, fTubeEnd2: TTubeEnd;
    fTubeKind: TTubeKind;
    fTubewidth: integer;

  protected
    { Protected declarations }
    procedure SetColorsOn(iColors: tTubeColors);
    procedure SetColorsOff(iColors: tTubeColors);
    procedure SetOrient(iOrient: tTubeOrient);
    procedure SetIsOn(iIsOn: boolean);
    procedure setTubWidth(value: integer);
   // procedure SetPresets(iPresets: TTubeColorPresets);
    procedure TubeKind(value: TTubeKind);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;

    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;

    procedure changeConstRaints;
    procedure ShowPropFormMsg(var Msg: TMessage); message WM_IMMSHOWPROPFORM;
    procedure ShowPropForm;
  published
    { Published declarations }
    property TubWidth: integer read fTubeWidth write setTubWidth default 5;
    property icolorsOn: TTubeColors read fColorsOn write SetColorsOn;
    property icolorsOff: TTubeColors read fColorsOff write SetColorsOff;
    property iorient: TTubeOrient read fOrient write SetOrient;
 //   property iPresets: TTubeColorPresets read fpresets write SetPresets;
    property iExpr: string read fExprString write fExprString;
    property isOn: boolean read fisOn write SetIsOn;
    property iTubeEnd1: TTubeEnd read fTubeEnd1 write fTubeEnd1;
    property iTubeEnd2: TTubeEnd read fTubeEnd2 write fTubeEnd2;
    property iTubeKind: TTubeKind read fTubeKind write TubeKind;
  end;

Implementation

{ TIMMITube1 }

constructor TIMMITube1.Create(AOwner: TComponent);
begin
  inherited;
  fColorsOn := TTubeColors.Create;
  fColorsOff := TTubeColors.Create;
  width := 41;
  height := 25;
  TubWidth:=5;
  iTubeKind:=kGas;
 // paint;

end;

destructor TIMMITube1.Destroy;
begin
  fColorsOn.Free;
  fColorsOff.Free;
  fExpr.Free;
  inherited;
end;

procedure TIMMITube1.setTubWidth(value: integer);
begin
if value<5 then value:=5;
if value>13 then value:=13;
icolorson.Count:=value;
icolorsoff.Count:=value;
TubeKind(iTubeKind);
 fTubewidth:=value;
paint;
end;

procedure TIMMITube1.ImmiInit(var Msg: TMessage);
begin
  if (fExprString <> '') and (not Assigned (fExpr)) then
    fExpr := tExpretion.Create;
  if assigned(fExpr) then
  begin
    fExpr.Expr := fExprString;
    fExpr.ImmiInit;
  end;
end;

procedure TIMMITube1.ImmiUnInit(var Msg: TMessage);
begin
  if assigned(fExpr) then fExpr.ImmiUnInit;
end;

procedure TIMMITube1.ImmiUpdate(var Msg: TMessage);
begin
  if assigned(fExpr) then
  begin
    fExpr.ImmiUpdate;
    isOn := fExpr.isTrue;
  end;
end;

procedure TIMMITube1.Paint;
var
  i: integer;
begin
  inherited;
  if Parent<>nil then
  begin
  if isOn then fColorsCur := fColorsOn
    else fColorsCur := fColorsOff;

  for i := 1 to fColorsCur.Count do
  begin
    canvas.pen.color := fColorsCur.colors[i];
    case fOrient of
    toHor:
      begin
        case ftubeEnd1 of
          teDirect:
            Canvas.MoveTo(0, i);
          teConer1:
            Canvas.MoveTo(i, i);
          teConer2:
            Canvas.MoveTo(fColorsCur.Count - i, i);
        end;
        case ftubeEnd2 of
          teDirect:
            Canvas.LineTo(width, i);
          teConer1:
            Canvas.LineTo(width - i, i);
          teConer2:
            Canvas.LineTo(width - fColorsCur.Count + i, i);
        end;
      end;
    toVert:
      begin
        case ftubeEnd1 of
          teDirect:
            Canvas.MoveTo(i, 0);
          teConer1:
            Canvas.MoveTo(i, i);
          teConer2:
            Canvas.MoveTo(i, fColorsCur.Count - i);
        end;
        case ftubeEnd2 of
          teDirect:
            Canvas.LineTo(i, Height);
          teConer1:
            Canvas.LineTo(i, Height - i);
          teConer2:
            Canvas.LineTo(i, Height - fColorsCur.Count + i);
        end;
      end;
    end; //case orientation
  end;
  {if csDesigning in ComponentState then
	with inherited Canvas do
	begin
	  Pen.Style := psDash;
	  Brush.Style := bsClear;
	  Rectangle(0, 0, Width, Height);
	  Pen.Style := psSolid;
	end;      }
        end;
end;

procedure TIMMITube1.SetColorsOff(iColors: tTubeColors);
begin
  if fColorsOff <> iColors then
  begin
    fColorsOff := iColors;
    paint;
  end;
end;

procedure TIMMITube1.SetColorsOn(iColors: tTubeColors);
begin
  if fColorsOn <> iColors then
  begin
    fColorsOn := iColors;
    paint;
  end;
end;


procedure TIMMITube1.TubeKind(value: TTubeKind);
var i: integer;
begin

  if value= kGas then
   begin
    fTubeKind:=kGas;
    icolorsON.Colors[1]:=clYellow;
    icolorsON.Colors[icolorsoff.Count]:=clYellow;
    icolorsOff.Colors[1]:=clYellow;
    icolorsoff.Colors[icolorsoff.Count]:=clYellow;
    for i:=2 to icolorson.Count-1 do
        icolorsON.Colors[i]:=clYellow;
    for i:=2 to icolorsoff.Count-1 do
        icolorsoff.Colors[i]:=clBlack;
    update;
   end;

    if value= kMaz then
   begin
    fTubeKind:=kMaz;
    icolorsON.Colors[1]:=clYellow;
    icolorsON.Colors[icolorsoff.fCount-1]:=clYellow;
    icolorsOff.Colors[1]:=clYellow;
    icolorsoff.Colors[icolorsoff.fCount-1]:=clYellow;
    for i:=2 to icolorson.Count-1 do
        icolorsON.Colors[i]:=clYellow;
    for i:=2 to icolorsoff.Count-1 do
        icolorsoff.Colors[i]:=clBlack;
    update;
   end;

   if value= kWAt then
   begin
    fTubeKind:=kWat;
    icolorsON.Colors[1]:=clBlue;
    icolorsON.Colors[icolorsoff.fCount-1]:=clBlue;
    icolorsOff.Colors[1]:=clBlue;
    icolorsoff.Colors[icolorsoff.fCount-1]:=clblue;
    for i:=2 to icolorson.Count-2 do
        icolorsON.Colors[i]:=clBlue;
    for i:=2 to icolorsoff.Count-2 do
        icolorsoff.Colors[i]:=clBlack;
    update;
   end;


 if value= kDym then
   begin
    fTubeKind:=kDym;
    icolorsON.Colors[1]:=clGray;
    icolorsON.Colors[icolorsoff.fCount]:=clGray;
    icolorsOff.Colors[1]:=clGray;
    icolorsoff.Colors[icolorsoff.fCount]:=clGray;
    for i:=2 to icolorson.Count-1 do
        icolorsON.Colors[i]:=clgray;
    for i:=2 to icolorsoff.Count-1 do
        icolorsoff.Colors[i]:=clBlack;
    update;
   end;

 if value=kNone then

 if value<>kNone then  fTubeKind:=kNone;
   begin

for i:=icolorsoff.Count+1 to 13 do
begin
   icolorsON.Colors[i]:=clnone;
   icolorsoff.Colors[i]:=clNone;
end;
end;
paint;

end;


procedure TIMMITube1.changeConstRaints;
begin
    case fOrient of
      toHor:
        begin
          Constraints.MinHeight := min (fColorsOn.Count, fColorsOff.Count);
          Constraints.MaxHeight := max (fColorsOn.Count, fColorsOff.Count) ;
          Constraints.MinWidth := 0;
          Constraints.MaxWidth := 0;
        end;
      toVert:
        begin
          Constraints.MinHeight := 0;
          Constraints.MaxHeight := 0;
          Constraints.MinWidth := min (fColorsOn.Count, fColorsOff.Count);
          Constraints.MaxWidth := max (fColorsOn.Count, fColorsOff.Count){ + 1};
        end;
    end;
end;

procedure TIMMITube1.SetIsOn(iIsOn: boolean);
begin
  if fIsOn <> iIsOn then
  begin
    fIsOn := iIsOn;
    paint;
  end;
end;

procedure TIMMITube1.SetOrient(iOrient: tTubeOrient);
begin
  if fOrient <> iOrient then
  begin
    fOrient := iOrient;
    paint; //repaint
  end;
end;

{procedure TIMMITube1.SetPresets(iPresets: TTubeColorPresets);
begin
  if fPresets <> iPresets then
  begin
    TubeKind(fpresets);
    fPresets := ipresets;
    paint;
  end;
end;      }

procedure TIMMITube1.ShowPropForm;
var
  w, h: integer;
begin
  with TIMMITubeForm.Create(nil) do begin
    Edit1.Text := fExprString;
    comboBox1.ItemIndex := integer(forient);
    comboBox2.ItemIndex := integer(fTubeEnd1);
    comboBox3.ItemIndex := integer(fTubeEnd2);
    colorsOn := self.fColorsOn.colors;

    colorsOff := self.fColorsOff.colors;

    if ShowModal = mrOK then begin
      fExprString := Edit1.Text;
      self.iColorsOn.colors := colorsOn;
      self.iColorsOn.calcColCount;
      self.iColorsOff.colors := colorsOff;
      self.iColorsOff.calcColCount;
      if iorient <> TTubeOrient(comboBox1.ItemIndex) then
      begin
        w:= self.width;
        h := self.height;
        forient := TTubeOrient(comboBox1.ItemIndex);
        changeConstRaints;
        self.width := h;
        self.height := w;
      end;
      fTubeEnd1 := TTubeEnd(comboBox2.ItemIndex);
      fTubeEnd2 := TTubeEnd(comboBox3.ItemIndex);
    end;
    Free;
  end;
  changeConstRaints;
  paint;
end;

procedure TIMMITube1.ShowPropFormMsg(var Msg: TMessage);
begin
  immiUninit(Msg);
  showPropForm;
  try
    IMMIInit(Msg);
  except
    on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], E.HelpContext);
        perform(WM_IMMSHOWPROPFORM, 0, 0);
      end;
  end;
end;

{ TTubeColors }

procedure TTubeColors.AssignTo(Dest: TPersistent);
begin
  TTubeColors(Dest).Colors := Colors;
  inherited;
end;

function TTubeColors.calcColCount: integer;
var
  i: integer;

begin
  result := 0;
  for i:= low(Colors) to high (Colors)  do
    if (Colors[i] <> clNone) and (i > result) then result := i;
  count := result;
end;


constructor TTubeColors.Create;
var
  i: integer;

begin
  inherited;
  for i:= low(Colors) to high (Colors)  do
    Colors[i] := clNone;
end;

function TTubeColors.GetColor11: tColor;
begin
  result := Colors[1];
end;

function TTubeColors.GetColor12: tColor;
begin
  result := Colors[2];
end;

function TTubeColors.GetColor13: tColor;
begin
  result := Colors[3];
end;

function TTubeColors.GetColor14: tColor;
begin
  result := Colors[4];
end;

function TTubeColors.GetColor15: tColor;
begin
  result := Colors[5];
end;

function TTubeColors.GetColor16: tColor;
begin
  result := Colors[6];
end;

function TTubeColors.GetColor17: tColor;
begin
  result := Colors[7];
end;

function TTubeColors.GetColor18: tColor;
begin
  result := Colors[8];
end;

function TTubeColors.GetColor19: tColor;
begin
  result := Colors[9];
end;

function TTubeColors.GetColor20: tColor;
begin
  result := Colors[10];
end;

function TTubeColors.GetColor21: tColor;
begin
  result := Colors[11];
end;

function TTubeColors.GetColor22: tColor;
begin
  result := Colors[12];
end;

function TTubeColors.GetColor23: tColor;
begin
  result := Colors[13];
end;

function TTubeColors.GetColor24: tColor;
begin
  result := Colors[14];
end;

function TTubeColors.GetColor25: tColor;
begin
  result := Colors[15];
end;


procedure TTubeColors.SetColor11(iColor: TColor);
begin
  Colors[1] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor12(iColor: TColor);
begin
  Colors[2] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor13(iColor: TColor);
begin
  Colors[3] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor14(iColor: TColor);
begin
  Colors[4] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor15(iColor: TColor);
begin
  Colors[5] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor16(iColor: TColor);
begin
  Colors[6] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor17(iColor: TColor);
begin
  Colors[7] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor18(iColor: TColor);
begin
  Colors[8] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor19(iColor: TColor);
begin
  Colors[9] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor20(iColor: TColor);
begin
  Colors[10] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor21(iColor: TColor);
begin
  Colors[11] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor22(iColor: TColor);
begin
  Colors[12] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor23(iColor: TColor);
begin
  Colors[13] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor24(iColor: TColor);
begin
  Colors[14] := iColor;
  calcColCount;
end;

procedure TTubeColors.SetColor25(iColor: TColor);
begin
  Colors[15] := iColor;
  calcColCount;
end;

end.
