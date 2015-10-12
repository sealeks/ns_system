unit IMMIPanelU;

interface

uses
  Windows, Messages, SysUtils, Classes,EditPanelFrU, Controls, ExtCtrls, constDef, Expr, ImControlBridge,Dialogs;

type
  TIMMIPanel = class(TPanel)
  private
        fExprVisible: tExpretion;
        fExprVisibleString: TExprStr;
        fExprEnable: tExpretion;
        fExprEnableString: TExprStr;
       // fCollar: TImControlBridge;
    { Private declarations }
  protected
    { Protected declarations }

    procedure IMMIInit (var msg: TMessage); message WM_IMMIINIT;
    procedure IMMIUNInit (var msg: TMessage); message WM_IMMIUNINIT;
    procedure IMMIUpdate (var msg: TMessage); message WM_IMMIUPDATE;
    procedure IMMIBlinkOn (var msg: TMessage); message WM_IMMIBLINKON;
    procedure IMMIBlinkOff (var msg: TMessage); message WM_IMMIBLINKOFF;
   // procedure SetCollar(value: TImControlBridge);
  public
    procedure ShowPropForm;
    { Public declarations }
  published
    property ExprVisible: TExprStr read fExprVisibleString write fExprVisibleString;
    property ExprEnable: TExprStr read fExprEnableString write fExprEnableString;
    //property Collar: TImControlBridge read FCollar write SetCollar;

    { Published declarations }
  end;

implementation
{ TIMMIPanel1 }

procedure TIMMIPanel.IMMIBlinkOff(var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIPanel.IMMIBlinkOn(var msg: TMessage);
begin
  broadcast (msg);
end;

procedure TIMMIPanel.IMMIInit(var msg: TMessage);
begin
  broadcast (msg);
   CreateAndInitExpretion(fExprVisible, fExprVisibleString);
   CreateAndInitExpretion(fExprEnable, fExprEnableString);
  //if fcollar<>nil then fCollar.ImmiInit;
end;


procedure TIMMIPanel.IMMIUNInit(var msg: TMessage);
begin
  broadcast (msg);
  if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
  if assigned(fExprEnable) then fExprEnable.ImmiUnInit;
  //if fcollar<>nil then fCollar.ImmiUnInit;
end;

procedure TIMMIPanel.ShowPropForm;
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

procedure TIMMIPanel.IMMIUpdate(var msg: TMessage);
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
     if (not (fExprVisible.IsTrue) and visible) then
     begin
     visible:=false;
     if ((Parent<>nil) and (Parent.Visible)) then Parent.Repaint;
     end;
  end;
 //if fcollar<>nil then fCollar.ImmiUpdate;
end;

{procedure TIMMIPanel.SetCollar(value: TImControlBridge);
begin
  if value=nil then
    begin
     if fCollar<>nil then
     fCollar.DelFromList(self);
     fCollar:=nil;
     exit;
    end;
  if value is TImControlBridge then
                if value<>fcollar then
                  begin
                   //ShowMessage('ddddd');
                   value.AddToList(self);
                   fCollar:=value;
                  end;

end;  }

end.
