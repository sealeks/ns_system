unit IMMIGroupBoxU;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,EditPanelFrU, StdCtrls, ConstDef,Expr,IMMIformx;

type
  TIMMIGroupBox = class(TGroupBox)
  private
      fExprVisible: tExpretion;
      fExprVisibleString: TExprStr;
      fExprEnable: tExpretion;
      fExprEnableString: TExprStr;
     // fIMMIFormExt: TIMMIFormExt;
    { Private declarations }
  protected
    { Protected declarations }
    procedure IMMIInit (var msg: TMessage); message WM_IMMIINIT;
    procedure IMMIUNInit (var msg: TMessage); message WM_IMMIUNINIT;
    procedure IMMIUpdate (var msg: TMessage); message WM_IMMIUPDATE;
    procedure IMMIBlinkOn (var msg: TMessage); message WM_IMMIBLINKON;
    procedure IMMIBlinkOff (var msg: TMessage); message WM_IMMIBLINKOFF;
  public
    procedure ShowPropForm;
    { Public declarations }
  published
    // property IMMIFormExt: TIMMIFormExt read fIMMIFormExt write fIMMIFormExt;
     property ExprVisible: TExprStr read fExprVisibleString write fExprVisibleString;
    property ExprEnable: TExprStr read fExprEnableString write fExprEnableString;
    { Published declarations }
  end;

implementation

{ TIMMIGroupBox }

procedure TIMMIGroupBox.IMMIBlinkOff(var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIGroupBox.IMMIBlinkOn(var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIGroupBox.IMMIInit(var msg: TMessage);
begin
  broadcast (msg);
   CreateAndInitExpretion(fExprVisible, fExprVisibleString);
   CreateAndInitExpretion(fExprEnable, fExprEnableString);
end;

procedure TIMMIGroupBox.IMMIUNInit(var msg: TMessage);
begin
  broadcast (msg);
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
  if assigned(fExprEnable) then fExprEnable.ImmiUnInit;
end;


procedure TIMMIGroupBox.ShowPropForm;
begin
  with TEditpanelFr.Create(nil) do begin
    Edit1.Text := self.ExprEnable;
    Edit2.Text := self.ExprVisible;
  //  Image1.Picture.Bitmap.Assign(Glyph);
    if ShowModal = mrOK then begin
        self.ExprEnable:=Edit1.Text;
        self.ExprVisible:=Edit2.Text;
     // Self.caption := '';
    end;
    Free;
  end;
end;

procedure TIMMIGroupBox.IMMIUpdate(var msg: TMessage);
begin
  broadcast (msg);
  if assigned(fExprEnable) then
  begin
    fExprEnable.ImmiUpdate;
    if ((fExprEnable.IsTrue) and not Enabled) then Enabled:=true;
     if (not (fExprEnable.IsTrue) and Enabled) then Enabled:=false;
  end;
    if assigned(fExprVisible) then
  begin
    fExprVisible.ImmiUpdate;
    if ((fExprVisible.IsTrue) and not visible) then visible:=true;
     if (not (fExprVisible.IsTrue) and visible) then visible:=false;
  end;
end;

end.
