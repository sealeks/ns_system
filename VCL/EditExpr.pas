unit EditExpr;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,Expr,ConstDef, Graphics, dxButton;



type
  TEditExpr = class(TEdit)
  private
    fcorrColor: TColor;
    fnocorrColor: TColor;
    fdefcolor: TColor;
    fbutton: TdxButton;
    fButDialog: boolean;
    { Private declarations }
  protected
   // function IsCorrect(value: TExprStr);
    { Protected declarations }
  public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy;  override;
     procedure Afterconstruction; override;
     procedure PaintText(value: TCorrExrStatus);
     procedure setButDialog(val: boolean);
    // function CheckText: TCorrExrStatus;
     procedure ExprClc(sender: TObject);
     procedure Change; override;
   // { Public declarations }
  published
    property corrColor: TColor read fcorrColor write fcorrColor;
    property nocorrColor: TColor read fnocorrColor write fnocorrColor;
    property defColor: TColor read fdefColor write fdefColor;
    property ButDialog: boolean read fButDialog write setButDialog;

    { Published declarations }
  end;

procedure Register;

implementation
uses  UnitExpr;
procedure TEditExpr.Afterconstruction;
begin
 inherited;
    fcorrColor:=clGreen;
    fnocorrColor:=clRed;
    fdefcolor:=clBlack;
end;

procedure TEditExpr.setButDialog(val: boolean);
begin
   if val=fButDialog then exit;
   if val then
      begin
       fbutton.Visible:=true;
       fbutton.Top:=0;
       fbutton.left:=self.Width-self.Height;
       fbutton.Width:=self.Height-5;
       fbutton.Height:=self.Height-5;
       fbutton.Caption:='***';
       fbutton.Font.Color:=clBlue;
       fbutton.OnClick:=ExprClc;
      end else fbutton.Visible:=false;
  fButDialog:=val;
end;

procedure TEditExpr.PaintText(value: TCorrExrStatus);
begin
    if value=cesCorr then Font.Color:=fcorrColor else
       if value=cesErr then Font.Color:=fnocorrColor else
         Font.Color:=fdefcolor;
    //Repaint;
end;

constructor TEditExpr.Create(AOwner: TComponent);
begin
inherited;
fbutton:=TdxButton.Create(self);

fbutton.Parent:=self;
fbutton.Visible:=false;
end;

destructor TEditExpr.Destroy;
begin
inherited;
end;

procedure TEditExpr.Change;
begin
  PaintText(CheckExpr(text));
  inherited;
 // self.Change
end;       

procedure TEditExpr.ExprClc(sender: TObject);
var expF: TFormExpr;
    kexp: string;
begin
  try
  expF:=TFormExpr.Create(self);
  kexp:= caption;
  if expF.Execute(kexp) then caption:=kexp;
  finally
  expF.Free;
  end
end;


procedure Register;
begin
  RegisterComponents('IMMIService', [TEditExpr]);
end;

end.
