unit Ruler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TMeterType = (mtLeft, mtRight, mtTop, mtBottom);

  TRuler = class(TGraphicControl)
  private
    { Private declarations }
    fMinDiv, fMaxDiv: integer;
    fMeterType : TMeterType;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    procedure SetMinDiv (MinDiv: integer);
    procedure SetMaxDiv (MaxDiv: integer);
    procedure SetMeterType (MeterType: TMeterType);
  published
    { Published declarations }
    property iMinDiv: integer read fMinDiv write SetMinDiv default 10;
    property iMaxDiv: integer read fMaxDiv write SetMaxDiv default 10;
    property iMeterType: TMeterType read fMeterType write SetMeterType;
  end;

procedure Register;

implementation

constructor TRuler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WIDTH:=10;
  hEIGHT:=10;
  fMaxDiv := 10;
  fMinDiv := 10;
end;

procedure TRuler.Paint;
var
  i: integer;
  numDiv: integer;
begin
  with canvas do
  begin
    numDiv := fMaxDiv * fMinDiv;
    for i:= 0 to numDiv do 
      case fMeterType of
      mtLeft:
        begin
          MoveTo(1, trunc(i*((height-1) / NumDiv)));
          if ((i div fMinDiv) * fMinDiv) = i then
            LineTo(width, trunc(i*((height-1) / NumDiv)))
          else
            LineTo(width div 2, trunc(i*((height-1) / NumDiv)));
        end;
      mtRight:
        begin
          MoveTo(width, trunc(i*((height-1) / NumDiv)));
          if ((i div fMinDiv) * fMinDiv) = i then
            LineTo(1, trunc(i*((height-1) / NumDiv)))
          else
            LineTo(width div 2, trunc(i*((height-1) / NumDiv)));
        end;
      mtTop:
        begin
          MoveTo(trunc(i*((width-1) / NumDiv)), 1);
          if ((i div fMinDiv) * fMinDiv) = i then
            LineTo(trunc(i*((width-1) / NumDiv)), Height)
          else
            LineTo(trunc(i*((width-1) / NumDiv)), Height div 2);
        end;
      mtBottom:
        begin
          MoveTo(trunc(i*((width-1) / NumDiv)), Height);
          if ((i div fMinDiv) * fMinDiv) = i then
            LineTo(trunc(i*((width-1) / NumDiv)), 1)
          else
            LineTo(trunc(i*((width-1) / NumDiv)), Height div 2);
        end;
      end;
  end;
end;

procedure TRuler.SetMinDiv (MinDiv: integer);
begin
  if fMinDiv <> minDiv then
  begin
    fMinDiv := minDiv;
    invalidate;
  end;
end;

procedure TRuler.SetMaxDiv (MaxDiv: integer);
begin
  if fMaxDiv <> maxDiv then
  begin
    fMaxDiv := maxDiv;
    invalidate;
  end;
end;

procedure TRuler.SetMeterType (MeterType: TMeterType);
begin
  if MeterType <> fMeterType then
  begin
    fMeterType := MeterType;
    invalidate;
  end;
end;

procedure Register;
begin
  RegisterComponents('IMMISample', [TRuler]);
end;

end.
