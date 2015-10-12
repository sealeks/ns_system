unit IMMIBorder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  constDef,   Expr,  Math,
  IMMIPropertysU,
  IMMIPropertysEditorU;

type TBorderType = (btRectangle,  btRoundRect,  btEllipse);


type TBorder = class (TPersistent)
private
    fEnterColor: TColor;
    fOutColor: TColor;
   // fOnColor: TColor;
   // fOffColor: TColor;
    fBlkColor: TColor;
    fBorderType: TBorderType;
    fPenWidth: byte;
   // fExprOnstring: TExprStr;
   // fExprBlkstring: TExprStr;
    fBlinkInvisible: boolean;
published
    constructor create;
    property EnterColor: TColor read fEnterColor write fEnterColor;
    property OutColor: TColor read fOutColor write fOutColor;
   // property OnColor: TColor read fOnColor write fOnColor default clNone;
   // property OffColor: TColor read fOffColor write fOffColor default clNone;
    property BlkColor: TColor read fBlkColor write fblkColor;
    property BorderType: TBorderType read fBorderType write fBorderType;
    property PenWidth: byte read fPenWidth write fPenWidth;
    //property ExprOn: TExprStr read fExprOnString  write fExprOnString;
    //property ExprBlk: TExprStr read fExprBlkString  write fExprBlkString;
    property BlinkInvisible: boolean read fBlinkInvisible  write fBlinkInvisible;
end;


type

  TIMMIBorder = class(TImage)
  private
    { Private declarations }
    isInit: boolean;
    fIMMIProp: TIMMIImgPropertys;
    fison: boolean;
    fisBlk: boolean;
    fUp: boolean;
    fstateMouse: boolean;
    fExprOnString: TExprStr;
    fExprOn:  tExpretion;
    fExprBlkString: TExprStr;
    fExprblk:  tExpretion;
    fMouseControl: TControl;
    finBitMap: Tbitmap;
    foutBitMap: Tbitmap;
    fonBitMap: Tbitmap;
    foffBitMap: Tbitmap;
    fblkBitMap: Tbitmap;
    fEnterColor: TColor;
    foutColor: TColor;
    fonColor: TColor;
    foffColor: TColor;
    fblkColor: TColor;
    fBorderType: TBorderType;
    fPenWidth: byte;
    blkState, fBlinkInvisible: boolean;
    OnState: boolean;
    procedure SetIsOn(const Value: boolean);
    procedure SetIsBlk(const Value: boolean);
    function getInBitmap(value: boolean): TBitmap;
    function getOutBitmap: TBitmap;
    function getonBitmap: TBitmap;
    function getOffBitmap: TBitmap;
    function getblkBitmap: TBitmap;
    procedure setMouseControl(value: TControl);
  protected
    { Protected declarations }
  public
    { Public declarations }
    property isOn: boolean read fIsOn write SetIsOn;
    property isBlk: boolean read fIsBlk write SetIsBlk;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    ///property Transparent;
    procedure ImmiInit (var Msg: TMessage); message WM_IMMIINIT;
    procedure ImmiUnInit (var Msg: TMessage); message WM_IMMIUNINIT;
    procedure ImmiUpdate (var Msg: TMessage); message WM_IMMIUPDATE;
    procedure ImmiBlinkOn (var Msg: TMessage); message WM_IMMIBLINKON;
    procedure ImmiBlinkOff (var Msg: TMessage); message WM_IMMIBLINKOFF;
    procedure CMMouseEnter(var AMsg: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var AMsg: TMessage); message CM_MOUSELEAVE;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
    procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
    procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
    procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
   // procedure Loaded; override;
    //procedure CreateParams (var Params: TCreateParams);
     // override;

  //published
    { Published declarations }
    property MouseControl: TControl read fMouseControl write setMouseControl;

    property EnterColor: TColor read fEnterColor write fEnterColor;
    property OutColor: TColor read fOutColor write fOutColor;
    property OnColor: TColor read fOnColor write fOnColor;
    property OffColor: TColor read fOffColor write fOffColor;
    property BlkColor: TColor read fBlkColor write fblkColor;
    property BorderType: TBorderType read fBorderType write fBorderType;
    property PenWidth: byte read fPenWidth write fPenWidth;
    property BlinkInvisible: boolean read fBlinkInvisible  write fBlinkInvisible;
    property ExprOn: TExprStr read fExprOnString  write fExprOnString;
    property ExprBlk: TExprStr read fExprBlkString  write fExprBlkString;


  end;


procedure Register;


implementation

constructor TBorder.create;
begin
 fEnterColor:=clNone;
 fOutColor:=clNone;
 //fOnColor:=clNone;
 //fOffColor:=clNone;
 fBlkColor:=clNone;
 fBorderType:=btRectangle;
 fPenWidth:=0;
end;

constructor TIMMIBorder.Create(AOwner: TComponent);
begin
  inherited;
  fstateMouse:=false;
  fUp:=false;;
  fIMMIProp := TIMMIImgPropertys.create(self);
  width:=40;
  height:=40;

  finBitMap:=tBitmap.create;
  finBitMap.width:=0;
  finBitMap.height:=0;
  finBitMap.FreeImage;

  foutBitmap:=tBitmap.create;
  foutbitmap.width:=0;
  foutbitmap.height:=0;
  foutbitmap.FreeImage;

  fonBitmap:=tBitmap.create;
  fonbitmap.width:=0;
  fonbitmap.height:=0;
  fonbitmap.FreeImage;

  foffBitmap:=tBitmap.create;
  foffbitmap.width:=0;
  foffbitmap.height:=0;
  foffbitmap.FreeImage;

  fblkBitmap:=tBitmap.create;
  fblkbitmap.width:=0;
  fblkbitmap.height:=0;
  fblkbitmap.FreeImage;

  isInit:=true;
  fEnterColor:=clNone;
  foutColor:=clNone;
  fonColor:=clNone;
  foffColor:=clNone;
  transparent := true;
  fIsOn := false;
  fIsblk := false;
  blkState:=false;
  OnState:=false;
  fBorderType:=btRoundRect;
  fPenWidth:=1;
  self.ShowHint:=true;
end;



procedure TIMMIBorder.ImmiInit (var Msg: TMessage);
begin

  CreateAndInitExpretion(fExprBlk, fExprBlkString);
  CreateAndInitExpretion(fExprOn, fExprOnString);
  //  CreateAndInitExpretion(fExprOn, fExprOnString);
//  CreateAndInitExpretion(fExprBlk, fExprBlkString);
  finBitMap.width:=0;
  if assigned(fExprOn) then Onstate:=true else OnState:=false;
  if assigned(fExprBlk) then Blkstate:=true else BlkState:=false;

end;

procedure TIMMIBorder.setMouseControl(value: TControl);
begin

 if value<>nil then
   begin
     self.top:=value.top-2-fPenWidth;
     self.left:=value.left-2-fPenWidth;
     self.width:=value.width+4+2*fPenWidth;
     self.Height:=value.Height+4+2*fPenWidth;
     self.bringtofront;
     self.hint:=value.hint;
     self.Cursor:=value.cursor;
     self.ShowHint:=true;
   end;
  fMouseControl:=value;
  //picture.assign(getInBitmap(false));
  paint;
end;

procedure TIMMIBorder.ImmiUnInit (var Msg: TMessage);
begin

  if assigned(fExprOn) then fExpron.ImmiUnInit;
  if assigned(fExprBlk) then fExprBlk.ImmiUnInit;
end;

{procedure TIMMIImg11.CreateParams (var Params: TCreateParams);
begin
  inherited CreateParams(Params);
 Params.ExStyle := Params.ExStyle +
  ws_ex_Transparent;
end;  }

 procedure TIMMIBorder.WMLButtonDown(var Message: TWMLButtonDown);
 begin
  fUp:=true;
  picture.assign(getinBitmap(true));
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
  inherited;
 end;
 procedure TIMMIBorder.WMRButtonDown(var Message: TWMRButtonDown);
  begin
   fUp:=true;
   picture.assign(getinBitmap(true));
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
  inherited;
 end;
 procedure TIMMIBorder.WMMButtonDown(var Message: TWMMButtonDown);
  begin
   fUp:=true;
   picture.assign(getinBitmap(true));
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
  inherited;
 end;
 procedure TIMMIBorder.WMLButtonDblClk(var Message: TWMLButtonDblClk);
  var t: TMessage;
  begin
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
   t:=TMessage(message);
   self.CMMouseLeave(t);
  inherited;
 end;
 procedure TIMMIBorder.WMRButtonDblClk(var Message: TWMRButtonDblClk);
 var t: TMessage;
  begin
   t:=TMessage(message);
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
   self.CMMouseLeave(t);
  inherited;
 end;
 procedure TIMMIBorder.WMMButtonDblClk(var Message: TWMMButtonDblClk);
 var t: TMessage;
  begin
   t:=TMessage(message);
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
   self.CMMouseLeave(t);
  inherited;
 end;
 procedure TIMMIBorder.WMLButtonUp(var Message: TWMLButtonUp);
 var t: TMessage;
  begin
   fUp:=false;

   picture.assign(getinBitmap(true));
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
   t:=TMessage(message);
   self.CMMouseLeave(t);
  inherited;
 end;
 procedure TIMMIBorder.WMRButtonUp(var Message: TWMRButtonUp);
 var t: TMessage;
  begin
  picture.assign(getinBitmap(true));
  fUp:=false;
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
   t:=TMessage(message);
   self.CMMouseLeave(t);
  inherited;
 end;
 procedure TIMMIBorder.WMMButtonUp(var Message: TWMMButtonUp);
 var t: TMessage;
  begin
  fUp:=false;
  picture.assign(getinBitmap(true));
  if fMouseControl<>nil then fMouseControl.Dispatch(Message);
  t:=TMessage(message);
  self.CMMouseLeave(t);
  inherited;
 end;

function TIMMIBorder.getInBitmap(value: boolean): TBitmap;
begin
result:=nil;
if (MouseControl<>nil) and  (not MouseControl.Enabled) then
  begin
   result:=getblkBitmap;
   exit;
  end;
if Entercolor=clNone then exit;
if csDesigning in ComponentState then exit;
self.transparent:=true;
if (not ((finBitMap.width=self.width)
        and (finBitMap.height=self.height) and (finBitMap.Canvas.Pen.color=entercolor))) or (value)  then
begin
with finBitMap do
  begin
    FreeImage;
    transparent:=true;
    Height:=self.Height-2;
    Width:=self.Width-2;
    canvas.Pen.Color:=entercolor;
    canvas.Pen.Width:=fPenWidth;
    if fUp then canvas.Pen.Width:=canvas.Pen.Width+1;
    canvas.fillrect(self.ClientRect);
    if fBorderType=btRectangle then canvas.rectangle(1,1,width-1,height-1);
    if fBorderType=btRoundRect then canvas.roundRect(1,1,width-1,height-1,min(width,height) div 6,min(width,height) div 6);
    if fBorderType=btEllipse then canvas.Ellipse(1,1,width-1,height-1);
  end;
end;
result:=finBitMap;
end;

function TIMMIBorder.getoutBitmap: TBitmap;
begin
result:=nil;
if outcolor=clNone then exit;
if csDesigning in ComponentState then exit;
self.transparent:=true;
if not ((foutBitMap.width=self.width)
        and (foutbitMap.height=self.height) and (foutBitMap.Canvas.Pen.color=outcolor)) then
begin
with foutBitMap do
  begin
    FreeImage;
    transparent:=true;
    Height:=self.Height-2;
    Width:=self.Width-2;
    canvas.Pen.Color:=outcolor;
    canvas.Pen.Width:=fPenWidth;
    canvas.fillrect(ClientRect);
    if fBorderType=btRectangle then canvas.rectangle(1,1,width-1,height-1);
    if fBorderType=btRoundRect then canvas.roundRect(1,1,width-1,height-1,min(width,height) div 6,min(width,height) div 6);
    if fBorderType=btEllipse then canvas.Ellipse(1,1,width-1,height-1);
  end;
end;
result:=foutBitMap;
end;

function TIMMIBorder.getonBitmap: TBitmap;
begin
result:=nil;
if oncolor=clNone then exit;
if csDesigning in ComponentState then exit;
self.transparent:=true;
if not ((fonBitMap.width=self.width)
        and (fonBitMap.height=self.height) and (fonBitMap.Canvas.Pen.color=oncolor)) then
begin
with fonBitMap do
  begin
    FreeImage;
    transparent:=true;
    Height:=self.Height-2;
    Width:=self.Width-2;
    canvas.Pen.Color:=oncolor;
    canvas.Pen.Width:=fPenWidth;
    canvas.fillrect(self.ClientRect);
    if fBorderType=btRectangle then canvas.rectangle(1,1,width-1,height-1);
    if fBorderType=btRoundRect then canvas.roundRect(1,1,width-1,height-1,min(width,height) div 6,min(width,height) div 6);
    if fBorderType=btEllipse then canvas.Ellipse(1,1,width-1,height-1);
  end;
end;
result:=fonBitMap;
end;

function TIMMIBorder.getoffBitmap: TBitmap;
begin
result:=nil;
if offcolor=clNone then exit;
if csDesigning in ComponentState then exit;
self.transparent:=true;
if not ((foffBitMap.width=self.width)
        and (foffbitMap.height=self.height) and (foffBitMap.Canvas.Pen.color=offcolor)) then
begin
with foffBitMap do
  begin
    FreeImage;
    transparent:=true;
    Height:=self.Height-2;
    Width:=self.Width-2;
    canvas.Pen.Color:=offcolor;
    canvas.Pen.Width:=fPenWidth;
    canvas.fillrect(ClientRect);
    if fBorderType=btRectangle then canvas.rectangle(1,1,width-1,height-1);
    if fBorderType=btRoundRect then canvas.roundRect(1,1,width-1,height-1,min(width,height) div 6,min(width,height) div 6);
    if fBorderType=btEllipse then canvas.Ellipse(1,1,width-1,height-1);
  end;
end;
result:=foffBitMap;
end;

function TIMMIBorder.getBlkBitmap: TBitmap;
begin
result:=nil;
if blkcolor=clNone then exit;
self.transparent:=true;
if not ((fblkBitMap.width=self.width)
        and (fblkbitMap.height=self.height) and (fblkBitMap.Canvas.Pen.color=blkcolor)) then
begin
with fblkBitMap do
  begin
    FreeImage;
    transparent:=true;
    Height:=self.Height-2;
    Width:=self.Width-2;
    canvas.Pen.Color:=blkcolor;
    canvas.Pen.Width:=fPenWidth;
    canvas.fillrect(ClientRect);
    if fBorderType=btRectangle then canvas.rectangle(1,1,width-1,height-1);
    if fBorderType=btRoundRect then canvas.roundRect(1,1,width-1,height-1,min(width,height) div 6,min(width,height) div 6);
    if fBorderType=btEllipse then canvas.Ellipse(1,1,width-1,height-1);
  end;
end;
result:=fblkBitMap;
end;

procedure TIMMIBorder.ImmiUpdate (var Msg: TMessage);
begin

  if assigned(fExprOn) then
   begin
     //ShowMessage('U');
     fExprOn.ImmiUpdate;
     isOn:=(fExprOn.value>0);

   end;
  if assigned(fExprBlk) then
   begin
    // ShowMessage('B');
     fExprBlk.ImmiUpdate;
     isBlk:=(fExprBlk.value>0);
   end else isblk:=false;
  // Paint;
end;



procedure TIMMIBorder.CMMouseEnter(var AMsg: TMessage);
var b: TBitMap;
begin
if fMouseControl=nil then exit;
if (csDesigning in ComponentState) or (csDesigning in parent.ComponentState) then SendToBack;
 fstatemouse:=true;
 picture.Assign(getInBitmap(false));
 if (csDesigning in ComponentState) then picture.Assign(nil);
end;

procedure TIMMIBorder.CMMouseLeave(var AMsg: TMessage);
begin
   if fMouseControl=nil then exit;
   if (csDesigning in ComponentState) or (csDesigning in parent.ComponentState) then SendToBack;
   fstatemouse:=false;
   if  ((onColor<>clNone) or (offColor<>clNone)) and (ExprOn<>'') then
     begin
      if (isOn) then picture.Assign(getonBitmap);
      if not (isOn) then picture.Assign(getoffBitmap);
      fisOn:=isOn;
      exit;
     end;
   picture.Assign(getoutBitmap);
end;



procedure TIMMIBorder.ImmiBlinkOff(var Msg: TMessage);
begin
 if not BlkState then exit;
 if isBlk and not fstateMouse then picture.Assign(getoffBitmap);
 if not isBlk and not fstateMouse then picture.Assign(getoutBitmap);
end;

procedure TIMMIBorder.ImmiBlinkOn(var Msg: TMessage);
begin
  if not BlkState then exit;
  if isBlk and not fstateMouse then picture.Assign(getonBitmap);
  if not isBlk and not fstateMouse then picture.Assign(getoutBitmap);
end;



procedure TIMMIBorder.SetIsOn(const Value: boolean);
begin
  if not Onstate then exit;
  if (fstateMouse) and (fentercolor<>clNone) and (foutcolor<>clNone) then exit;
  if fisOn<>value then
  begin

    if value then picture.assign(getOnBitmap) else picture.assign(getOffBitmap);
    fisOn:=value;
  end;
end;

procedure TIMMIBorder.SetIsBlk(const Value: boolean);
begin
  fisBlk:=value;
end;

destructor TIMMIBorder.destroy;
begin
  finBitMap.free;
  foutBitMap.free;
  fonBitMap.free;
  foffBitMap.free;
  fblkBitMap.free;
  inherited;
end;


procedure Register;
begin
  RegisterComponents('ImmiSample',[TIMMIBorder]);
end;


end.

