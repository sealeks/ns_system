unit IMMILabelU;

interface

uses controls, classes, stdctrls, messages, sysUtils, constDef, Expr;

type
  TIMMILabel = class(TLabel)
  private
    { Private declarations }
    fExpr: tExpretion;
    fFormat: string;
    fExprString: string;
    fNagStr, fVagStr, fNpgStr, fVpgStr: string;
    fCap: string;
    procedure SetForm (str: string);
    procedure SetCaption (str: TCaption);
  protected
    { Protected declarations }
    procedure Click; override;
  public
    { Public declarations }
    function GetLabelText: string; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property form: string read fFormat write SetForm;
    property Expr: string read fExprString write fExprString;
    property iBnNag: string read fNagStr write fNagStr;
    property iBnVag: string read fVagStr write fVagStr;
    property iBnNpg: string read fNpgStr write fNpgStr;
    property iBnVpg: string read fVpgStr write fVpgStr;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    property caption write SetCaption;
  end;

procedure Register;

implementation

Uses IMMIAnalogPropU, MemStructsU;

constructor TIMMILabel.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    fExpr := tExpretion.Create;
    form := '%8.2f';
    fNagStr := '';
    fVagStr := '';
    fNpgStr := '';
    fVpgStr := '';
end;

procedure TIMMILabel.Click;
var
  id: longInt;
begin
  if rtItems.isIdent(Expr) then
  begin
    id := rtItems.GetSimpleID(Expr);
    if id>-1 then
     begin
      IMMIAnalogProp.IMMIShape1.iMinValue := rtItems[ID].MinEu;
      IMMIAnalogProp.IMMIShape1.iMaxValue := rtItems[ID].MaxEu;
      IMMIAnalogProp.Label1.Caption := floattostr (rtItems[ID].MinEu);
      IMMIAnalogProp.Label2.Caption := floattostr (rtItems[ID].MaxEu);
      IMMIAnalogProp.Label3.Caption :=
      floattostr ((rtItems[ID].MaxEu - rtItems[ID].MinEu) / 2);
     end;
    IMMIAnalogProp.Hide;
    IMMIAnalogProp.LName.Caption := Expr;
    IMMIAnalogProp.LComment.Caption := rtItems.GetComment(ID);
    IMMIAnalogProp.IMMILabel1.iExprVal := Expr;
    IMMIAnalogProp.IMMILabel2.iExprVal := ibnNag;
    IMMIAnalogProp.IMMILabel3.iExprVal := ibnNpg;
    IMMIAnalogProp.IMMILabel4.iExprVal := ibnVpg;
    IMMIAnalogProp.IMMILabel5.iExprVal := ibnVag;
    IMMIAnalogProp.IMMIShape1.iExpr := Expr;

    IMMIAnalogProp.top := top  - IMMIAnalogProp.height;
    IMMIAnalogProp.Left := Left;
    if IMMIAnalogProp.top < 0 then IMMIAnalogProp.top := 0;
    if IMMIAnalogProp.Left < 0 then IMMIAnalogProp.left := 0;
    IMMIAnalogProp.Show;
  end;
end;

function TIMMILabel.GetLabelText: string;
begin
  result := fCap;
end;

procedure TIMMILabel.SetForm (str: string);
begin
  fformat := str;
  caption := str;
end;

procedure TIMMILabel.SetCaption (str: TCaption);
begin
  fCap := string(str);
  inherited caption := str;
end;

destructor TIMMILabel.Destroy;
begin
     fExpr.free;
     inherited;
end;

procedure TIMMILabel.ImmiInit (var Msg: TMessage);
begin
  fExpr.Expr := fExprString;
  fExpr.ImmiInit;
  if rtItems.isIdent(Expr) then
  begin
    showHint := true;
    try
    if rtItems.GetSimpleID(Expr)>-1 then
    hint := rtItems.GetComment(rtItems.GetSimpleID(Expr));
    except
    end;
  end;
end;

procedure TIMMILabel.ImmiUnInit (var Msg: TMessage);
begin
  fExpr.ImmiUnInit;
end;

procedure TIMMILabel.ImmiUpdate;
var
   val: real;
   str: string;
   newCap: string;
begin
   try
     fExpr.ImmiUpdate;
     val := fExpr.Value;
     str := TrimLeft(format(Form, [val]));
     if fexpr.validLevel > 90 then begin
        newCap := str;
      end else newCap := '?' + str;
   except
     raise;
     newCap := '???';
   end;
   if newCap <> fCap then
   begin
     fCap := newCap;
     if not transparent then paint
     else invalidate;
   end;
end;


procedure Register;
begin
  //RegisterComponents('IMMIOld', [TIMMILabel]);
end;

end.
