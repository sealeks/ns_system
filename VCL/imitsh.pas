unit imitsh;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls,
  StdCtrls,
  Graphics,
  constDef,
  memStructsU,
  Expr,
  IMMIShapeEditorU,IMMIShape;

type
  timitsh = class(TIMMIShape)
  private
   timer: TTimer;
   fcoef: real;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(Aowner: TComponent); override;
    destructor Destroy; override;
     procedure ImmiHd(Sender: TObject);
    { Public declarations }
  published
    property coef: real read fcoef write fcoef;
    { Published declarations }
  end;



procedure Register;

implementation


constructor timitsh.Create(Aowner: TComponent);
begin
inherited;
 fcoef:=1;
 timer:=TTimer.Create(self);
 timer.Interval:=1000;
 if not (csDesigning	in Componentstate) then timer.OnTimer:=ImmiHd;
 self.ifillRec.brush.Color:=clBlue;
 self.ifillRec.FillStyle:=fsUp;
 self.Width:=20;
 self.Height:=50;
end;

destructor timitsh.Destroy;
begin
  timer.Free;
inherited;
end;

procedure timitsh.ImmiHd(Sender: TObject);
var x,delta: real;
function randomreal(n: integer): real;
 begin
   if n=0 then n:=1;
   result:=((Random(n)+random(n)+random(n)+random(n)+random(n))*1.0)/5 - (0.5 * n);
 end;
begin
 delta:=self.imaxValue-self.iminValue;
 x:=((1+sin(now*5000*fcoef))*delta/2)+self.iminValue;
 rtitems.AddCommand(rtitems.GetSimpleID(iExpr),x,true);
 inherited;
end;

procedure Register;
begin
  //RegisterComponents('IMMI', [timitsh]);
end;

end.
