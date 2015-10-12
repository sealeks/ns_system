unit AvPr;

interface

uses
  SysUtils, Classes, Controls,Graphics,Types,ConstDef, Messages, Expr, ExtCtrls;

type Orient = (oHor , oVert);

type
  TAvPr = class(TGraphicControl)
  private
    fmin: real;
    fmax: real;
    fnav, fvav, fnpr, fvpr: integer;
    favColor, fprColor, fColor: TColor;
    forientation: Orient;
    fNagStr, fVagStr, fNpgStr, fVpgStr: TExprStr;
    fexprNag, fexprVag, fexprNpg, fexprVpg: tExpretion;
    { Private declarations }
  protected
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure setnav(value: integer);
    procedure setvav(value: integer);
    procedure setnpr(value: integer);
    procedure setvpr(value: integer);
    procedure setColor(value: TColor);
    { Protected declarations }
  public
    property nav: integer  read fNav write SetNav;
    property vav: integer  read fvav write Setvav;
    property npr: integer  read fnpr write Setnpr;
    property vpr: integer  read fvpr write Setvpr;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure revPaint;
    { Public declarations }
  published

    property iBnNag: TExprStr  read fNagStr write fNagStr;
    property iBnVag: TExprStr  read fVagStr write fVagStr;
    property iBnNpg: TExprStr  read fNpgStr write fNpgStr;
    property iBnVpg: TExprStr  read fVpgStr write fVpgStr;
    property orientation: Orient read forientation write forientation;
    property Min: real read fmin write fmin;
    property Max: real read fmax write fmax;
    property avColor: TCOlor read favColor write favColor;
    property prColor: TCOlor read fprColor write fprColor;
    property Color: TCOlor read fColor write setColor;

    { Published declarations }
  end;

procedure Register;

implementation

constructor TAvPr.Create(AOwner: TComponent);
begin
inherited;
Height:=15;
Width:=70;
favColor:=clRed;
fprColor:=clyellow;
fColor:=clGreen;
fOrientation:=oHor;
fmin:=0;
fmax:=100;
fnav:=0;
fvav:=100;
fnpr:=0;
fvpr:=100;

end;


destructor TAvPr.Destroy;
begin
fexprVpg.free;
fexprNpg.free;
fexprNag.free;
fexprVag.free;
inherited;
end;


procedure TAvPr.ImmiInit (var Msg: TMessage);
begin

  CreateAndInitExpretion(fexprNag,fNagStr);
  CreateAndInitExpretion(fexprVag,fVagStr);
  CreateAndInitExpretion(fexprNpg,fNpgStr);
  CreateAndInitExpretion(fexprVpg,fVpgStr);

end;

procedure TAvpr.ImmiUnInit (var Msg: TMessage);
begin
  if assigned(fexprVpg) then fexprVpg.ImmiUnInit;
  if assigned(fexprNpg) then fexprNpg.ImmiUnInit;
  if assigned(fexprNag) then  fexprNag.ImmiUnInit  ;
  if assigned(fexprVag) then fexprVag.ImmiUnInit;
end;


procedure TAvpr.ImmiUpdate(var Msg: TMessage);
begin
  if assigned(fexprVpg) then fexprVpg.ImmiUpdate;
  if assigned(fexprNpg) then fexprNpg.ImmiUpdate;
  if assigned(fexprNag) then  fexprNag.ImmiUpdate;
  if assigned(fexprVag) then fexprVag.ImmiUpdate;
  if (fVpgstr<>'') then vpr:=round((fexprVpg.value-fmin)/(fmax-fmin)*100) else vpr:=100;
  if (fNpgstr<>'') then npr:=round((fexprNpg.value-fmin)/(fmax-fmin)*100)  else Npr:=0;
  if (fNagstr<>'') then  nav:=round((fexprNag.value-fmin)/(fmax-fmin)*100) else nav:=0;
  if (fVagstr<>'') then vav:=round((fexprVag.value-fmin)/(fmax-fmin)*100)  else vav:=100;
end;


procedure TAvPr.Paint;
var
   rr: TRect;
   lastColor: TColor;
begin
inherited;
canvas.Brush.Color:=fColor;
canvas.Rectangle(0,0,width,height);
revPaint;
end;


procedure TAvPr.setvav(value: integer);
begin
 if value<>fvav then
 begin
   fvav:=value;
    invalidate;
 end;
end;

procedure TAvPr.setnav(value: integer);
begin
 if value<>fnav then
  begin
   fnav:=value;
    invalidate;
 end;
end;


procedure TAvPr.setnpr(value: integer);
begin
 if value<>fnpr then
  begin
   fnpr:=value;
    invalidate;
 end;
end;

procedure TAvPr.setvpr(value: integer);
begin
 if value<>fvpr then
  begin
   fvpr:=value;
    invalidate;
 end;
end;

procedure TAvPr.setColor(value: TColor);
begin

fcolor:=value;
Paint;
end;


procedure TAvPr.revPaint;
var lastColor: TColor;
begin
if parent=nil then exit;
lastColor:= Color;
//if ((fNagStr='') and (fNpgStr='') and (fVpgStr='') and (fVagStr='')) then exit;
if fOrientation=ohor then
  begin
     canvas.Brush.Color:=fprColor;
    if fnpr>-10 then
       canvas.Rectangle(0,0,width*fnpr div 100,height);
    if fvpr<110 then
       canvas.Rectangle(width*fvpr div 100,0,width,height);
    canvas.Brush.Color:=favColor;
    if fnav>-10 then
       canvas.Rectangle(0,0,width*fnav div 100,height);
    if fvav<110 then
       canvas.Rectangle(width*fvav div 100,0,width,height);
  end
else
    begin
     canvas.Brush.Color:=fprColor;
    if fnpr>-10 then
       canvas.Rectangle(0,height*(100-fnpr) div 100,width,height);
    if fvpr<110 then
       canvas.Rectangle(0,0,width,height*(100-fvpr) div 100);
    canvas.Brush.Color:=favColor;
    if fnav>-10 then
       canvas.Rectangle(0,height*(100-fnav) div 100,width,height);
    if fvav<110 then
       canvas.Rectangle(0,0,width,height*(100-fvav) div 100);
  end ;
    canvas.Brush.Color:=LastColor;

end;


procedure Register;
begin
  RegisterComponents('IMMIImg', [TAvPr]);
end;

end.
