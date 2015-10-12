unit IMMIColorLabelU;

interface

uses controls, classes, stdctrls, messages, Graphics, sysUtils, constDef, Expr;

type
  TIMMIColorLabel = class(TLabel)
  private
    { Private declarations }
    fExpr: tExpretion;
    fExprString: string;
    fColorOn, fColorOff: TColor;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property iExpr: string read fExprString write fExprString;
    property iColorOn: TColor read fColorOn write fColorOn;
    property iColorOff: TColor read fColorOff write fColorOff;

    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
  end;

procedure Register;

implementation

constructor TIMMIColorLabel.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     fExpr := tExpretion.Create;
end;

destructor TIMMIColorLabel.Destroy;
begin
     fExpr.free;
     inherited;
end;

procedure TIMMIColorLabel.ImmiInit (var Msg: TMessage);
begin
  fExpr.Expr := fExprString;
  fExpr.ImmiInit;
end;

procedure TIMMIColorLabel.ImmiUnInit (var Msg: TMessage);
begin
  fExpr.ImmiUnInit;
end;

procedure TIMMIColorLabel.ImmiUpdate;
var
  newColor: TColor;
begin
     fExpr.ImmiUpdate;
     if fExpr.IsTrue then newColor := fColorOn
     else newColor := fColorOff;
     if font.color <> newColor then font.color := newColor;
end;


procedure Register;
begin
  //RegisterComponents('IMMIOld', [TIMMIColorLabel]);
end;

end.
