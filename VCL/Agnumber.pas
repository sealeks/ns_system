unit Agnumber;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Menus;

type
  TNumericType = (ntGeneral, ntExponent, ntFixed);
  TDataType = (dtByte, dtDouble, dtExtended, dtInteger,
               dtLongint, dtReal, dtShortint, dtSingle, dtWord);

{ num edit component }
type
  TAgCustomNumEdit = class (TCustomEdit)
  private
    FDecimals : word;
    FDigits : word;
    FMax : extended;
    FMin : extended;
    FNumericType : TNumericType;
    FDataType : TDataType;
    FValue : extended;
    FValidate : boolean;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetDecimals(Value : word);
    procedure SetDigits(Value : word);
    procedure SetMax(Value : extended);
    procedure SetMin(Value : extended);
    procedure SetNumericType(Value : TNumericType);
    procedure SetDataType(Value : TDataType);
    procedure SetValue(Value : extended);
    procedure SetValidate(Value : boolean);
  protected
    procedure FormatText; dynamic;
    procedure CheckRange; dynamic;
    procedure KeyPress(var Key: Char); override;
    property Decimals : word read FDecimals write SetDecimals;
    property Digits : word read FDigits write SetDigits;
    property Max : extended read FMax write SetMax;
    property Min : extended read FMin write SetMin;
    property NumericType : TNumericType read FNumericType write SetNumericType default ntGeneral;
    property DataType : TDataType read FDataType write SetDataType default dtExtended;
    property Value : extended read FValue write SetValue;
    property Validate : boolean read FValidate write SetValidate;
  public
    constructor Create(AOwner: TComponent); override;
    function AsByte : Byte; dynamic;
    function AsDouble : double; dynamic;
    function AsInteger : integer; dynamic;
    function AsLongint : longint; dynamic;
    function AsReal : real; dynamic;
    function AsShortInt : ShortInt; dynamic;
    function AsSingle : Single; dynamic;
    function AsWord : Word; dynamic;
    function Valid ( Value : extended ) : boolean; dynamic;
  end;

  TAgNumEdit = class (TAgCustomNumEdit)
  published
    property AutoSize;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property Datatype;
    property Decimals;
    property Digits;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property Max;
    property Min;
    property NumericType;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property Value;
    property Validate;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

type
  TSetOfChar = set of char;

const
  MaxByte    : byte     = 255;
  MinByte    : byte     = 0;
  MaxDouble  : double   = 1.7E308;
  MinDouble  : double   = -1.7E308;
  MaxInteger : integer  = 32767;
  MinInteger : integer  = -32768;
  MaxLongint : longint  = 2147483647;
  MinLongint : longint  = -2147483647;
  MaxReal    : real     = 1.7E38;
  MinReal    : real     = -1.7E38;
  MaxShortInt: ShortInt = 127;
  MinShortInt: ShortInt = -128;
  MaxSingle  : Single   = 3.4E38;
  MinSingle  : Single   = -3.4E38;
  MaxWord    : Word     = 65535;
  MinWord    : Word     = 0;

{========================================================================}
{ Custom Numeric Edit                                                    }
{========================================================================}

constructor TAgCustomNumEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 85;
  FNumericType := ntGeneral;
  FDataType := dtExtended;
  FDigits := 12;
  FDecimals := 2;
  AutoSelect := true;
  FMax := 1.1E4932;
  FMin := -1.1E4932;
  FValidate := true;
  FValue := 0.0;
  MaxLength := FDigits;
  Text := '0.0';
  FormatText;
end;

function TAgCustomNumEdit.AsByte: byte;
begin
  Result := 0;
  if (FValue <= MaxByte) and (FValue >= MinByte) then
     Result := Round(FValue);
end;

function TAgCustomNumEdit.AsDouble: double;
begin
  Result := 0;
  if (FValue <= MaxDouble) and (FValue >= MinDouble) then
     Result := FValue;
end;

function TAgCustomNumEdit.AsInteger: integer;
begin
  Result := 0;
  if (FValue <= MaxInteger) and (FValue >= MinInteger) then
      Result := round(FValue)
end;

function TAgCustomNumEdit.AsLongint: longint;
begin
  Result := 0;
  if (FValue <= MaxLongint) and (FValue >= MinLongint) then
      Result := round(FValue);
end;

function TAgCustomNumEdit.AsReal: real;
begin
  Result := 0;
  if (FValue <= MaxReal) and (FValue >= MinReal) then
     Result := FValue;
end;

function TAgCustomNumEdit.AsShortInt: ShortInt;
begin
  Result := 0;
  if (FValue <= MaxShortInt) and  (FValue >= MinShortInt) then
     Result := Round(FValue);
end;

function TAgCustomNumEdit.AsSingle: Single;
begin
  Result := 0;
  if (FValue <= MaxSingle) and  (FValue >= MinSingle) then
     Result := FValue;
end;

function TAgCustomNumEdit.AsWord: Word;
begin
  Result := 0;
  if (FValue <= MaxWord) and  (FValue >= MinWord) then
     Result := Round(FValue);
end;

procedure TAgCustomNumEdit.SetMin(Value: extended);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    CheckRange;
    if FMin > FMax then FMin := FMax;
    if FValue < FMin then
      FValue := FMin;
    FormatText;
  end;
end;

procedure TAgCustomNumEdit.SetMax(Value: extended);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    CheckRange;
    if FMax < FMin then FMax := FMin;
    if FValue > FMax then
      FValue := FMax;
    FormatText;
  end;
end;

procedure TAgCustomNumEdit.SetValue(Value: extended);
begin
  if (FValue <> Value) and (Valid(Value)) then
  begin
    FValue := Value;
    FormatText;
  end
end;

procedure TAgCustomNumEdit.SetDigits(Value: word);
begin
  if FDigits <> Value then
  begin
    FDigits := Value;
    FormatText;
  end;
end;

procedure TAgCustomNumEdit.SetDecimals (Value: word);
begin
  if FDecimals <> Value then
  begin
    FDecimals := Value;
    FormatText;
  end;
end;

procedure TAgCustomNumEdit.SetDataType(Value: TDataType);
begin
{  if FDataType <> Value then}
  begin
    FDataType := Value;
    if FDataType in [dtByte, dtInteger, dtLongint, dtShortint, dtWord] then
       FNumericType := ntGeneral;
    CheckRange;
    FormatText;
  end;
end;

procedure TAgCustomNumEdit.SetNumericType(Value: TNumericType);
begin
  if FDataType in [dtDouble, dtExtended, dtReal, dtSingle] then
     if FNumericType <> Value then
     begin
       FNumericType := Value;
       FormatText;
     end
  else FNumericType := ntGeneral;
end;

procedure TAgCustomNumEdit.SetValidate(Value: boolean);
begin
  if FValidate <> Value then
  begin
    FValidate := Value;
    if FValidate and ((FValue < FMin) or (FValue > FMax)) then
    begin
      FValue := FMin;
      FormatText;
    end;
  end;
end;

function TAgCustomNumEdit.Valid(Value: extended): boolean;
var
  S: string;
begin
  Result := true;
  if Validate and ((Value < FMin) or (Value > FMax)) then
  begin
   { FmtStr(S, 'Value must be between %g and %g', [FMin, FMax]);
   }
    FmtStr(S, 'Число должно находится между %g и %g', [FMin, FMax]);
    MessageDlg(S, mtError, [mbOk], 0);
    Result := false;
  end;
end;

procedure TAgCustomNumEdit.KeyPress(var Key: Char);
begin
  if Key in ['0'..'9', '-', '+', 'e', 'E', DecimalSeparator, #8] then
  begin
    if Key in ['e', 'E', DecimalSeparator] then
       if FDataType in [dtDouble, dtExtended, dtReal, dtSingle] then
          inherited KeyPress(Key)
       else Key := #0;
  end
  else
    Key := #0;
end;

procedure TAgCustomNumEdit.CMExit(var Message: TCMExit);
var
  X: extended;
begin
  try
    X := StrToFloat(Text);
    if Valid(X) then
    begin
      FValue := X;
      FormatText;
      inherited;
    end
    else
    begin
      SelectAll;
      SetFocus;
    end;
  except
    on E: EConvertError do
    begin
     { MessageDlg('''' + Text + ''' is no valid numeric input.', mtError, [mbOK], 0);
      }
      MessageDlg(ConCat('''',Text,''' неверный ввод числа.'), mtError, [mbOK], 0);

      SelectAll;
      SetFocus;
    end;
  end;
end;

procedure TAgCustomNumEdit.CheckRange;
var
  LMax, LMin: Extended;

  procedure check;
    begin
      if ((FMin < LMin) or (FMin > LMax)) then FMin := LMin;
      if ((FMax > LMax) or (FMax < LMin)) then FMax := LMax;
      if ((FValue < LMin) or (FValue > LMax))
         then FValue := 0;
    end;

begin
  case FDataType of
       dtByte:
         begin
           LMax := MaxByte; LMin := MinByte;
           check;
         end;
       dtDouble:
         begin
           LMax := MaxDouble; LMin := MinDouble;
           check;
         end;
       dtInteger:
         begin
           LMax := MaxInteger; LMin := MinInteger;
           check;
         end;
       dtLongint:
         begin
           LMax := MaxLongInt; LMin := MinLongInt;
           check;
         end;
       dtReal:
         begin
           LMax := MaxReal; LMin := MinReal;
           check;
         end;
       dtShortint:
         begin
           LMax := MaxShortInt; LMin := MinShortInt;
           check;
         end;
       dtSingle:
         begin
           LMax := MaxSingle; LMin := MinSingle;
           check;
         end;
       dtWord:
         begin
           LMax := MaxWord; LMin := MinWord;
           check;
         end;
  end;
end;

procedure TAgCustomNumEdit.FormatText;
var
  X: Extended;
begin
  if FDataType in [dtDouble, dtExtended, dtReal, dtSingle] then
  begin
    X := FValue;
    case FNumericType of
      ntGeneral  : Text := FloatToStrF ( X, ffGeneral, FDigits, FDecimals);
      ntExponent : Text := FloatToStrF ( X, ffExponent, FDigits, FDecimals);
      ntFixed    : Text := FloatToStrF ( X, ffFixed, FDigits, FDecimals);
    end
  end
  else
  begin
    FValue := Round(FValue);
    X := FValue;
    Text := IntToStr(Round(X));
  end;
end;

procedure Register;
begin
  RegisterComponents ('Argent', [TAgNumEdit]);
end;

end.
