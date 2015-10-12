unit ImControlBridge;

interface

uses
  SysUtils, Classes, Windows, constdef, Messages, EXpr, TypInfo, Dialogs, Controls, Graphics;



type
  TImObjectBridge = class(TComponent)
   private
    fListComp: TList;
   // froot: TList;
    fisInit: boolean;
   protected
    procedure SetPropertyInComponent(value: tExpretion; nameC: string);
   public
    //isonBlink: boolean;
    procedure ImmiInit; virtual; abstract;
    procedure ImmiUnInit;  virtual; abstract;
    procedure ImmiUpdate;  virtual; abstract;
    procedure ImmiBlinkOn;
    procedure ImmiBlinkOff;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddToList(obj: TPersistent);
    procedure DelFromList(obj: TPersistent);
    property  isInit: boolean read fisInit;

end;

type
  TImColorBridge = class(TImObjectBridge)
end;

type
  TImColorExprBridge = class(TImColorBridge)
  private
     fColor: TExprStr;
     fExprColor: tExpretion;
  public
    procedure ImmiInit; override;
    procedure ImmiUnInit; override;
    procedure ImmiUpdate; override;

  published
    property Color: TExprStr read FColor write FColor;
 end;



type
  TImPersistentBridge = class(TImObjectBridge)
  private
    FLeft: TExprStr;
    FTop: TExprStr;
    FWidth: TExprStr;
    FHeight: TExprStr;
    FVisible: TExprStr;
    FColor: TImColorBridge;

    fExprLeft: tExpretion;
    fExprTop: tExpretion;
    fExprWidth: tExpretion;
    fExprHeight: tExpretion;
    fExprVisible: tExpretion;
    procedure SetColor(value: TImColorBridge);

  public
    procedure ImmiInit; override;
    procedure ImmiUnInit; override;
    procedure ImmiUpdate; override;
    property Left: TExprStr read FLeft write FLeft;
    property Top: TExprStr read FTop write FTop;
    property Width: TExprStr read FWidth write FWidth;
    property Height: TExprStr read FHeight write FHeight;
    property Visible: TExprStr read FVisible write FVisible;
    property Color: TImColorBridge read fColor  write setColor;

  end;


type
  TImColorListBridge = class(TImColorBridge)
  private
    fColor: TImColorListBridge;
    fiColor: TColor;
    fiExpr: TExprStr;
    fiExpretion: TExpretion;
    procedure SetColor(value: TImColorListBridge);
  public

    procedure ImmiInit; override;
    procedure ImmiUnInit; override;
    procedure ImmiUpdate; override;

  published
    property iColor: TColor read fiColor write fiColor;
    property Expr: TExprStr read fiExpr write  fiExpr;
    property Color: TImColorListBridge read fColor  write setColor;
 end;

type


TImFontBridge = class(TImPersistentBridge)
 published
    property Height;
    property Color;
 end;


TImControlBridge = class(TImPersistentBridge)
  private
    FFont: TImFontBridge;
  protected
    procedure SetFont(value: TImFontBridge);
    procedure ImmiInit; override;
    procedure ImmiUnInit; override;
    procedure ImmiUpdate; override;

  published
    property Left;
    property Top;
    property Width;
    property Height;
    property Visible;
    property Color;
    property Font: TImFontBridge read fFont  write setFont;
  end;

procedure Register;

implementation



constructor TImObjectBridge.Create(AOwner: TComponent);
begin
 inherited;
  fListComp:=TList.Create;
  fListComp.Clear;
  fisInit:=false;
 // froot:=TList.Create;
end;


destructor TImObjectBridge.Destroy;
begin
 // froot.free;
  fListComp.Free;
  inherited;
end;


procedure TImObjectBridge.AddToList(obj: TPersistent);
begin
  //froot.add(obj);
  fListComp.add(obj);
end;


procedure TImObjectBridge.DelFromList(obj: TPersistent);
begin
  // froot.add(obj);
   fListComp.remove(obj);
end;


procedure TImObjectBridge.SetPropertyInComponent(value: TExpretion; nameC: string);
var i,f: integer;

begin

  f:=round(value.value);
  value.ImmiUpdate;

//  if f<>round(value.value) then
  begin
  for i:=0 to fListComp.Count-1 do
       if fListComp.Items[i]<>nil then
           //TControl(fListComp.Items[i]).top:=200;
          SetOrdProp(TObject(fListComp.Items[i]),nameC,round(value.value));
  end;
end;


procedure TImObjectBridge.ImmiBlinkOn;
begin
 //isonBlink:=true;
end;

procedure TImObjectBridge.ImmiBlinkOff;
begin
 //isonBlink:=false;
end;


procedure TImColorExprBridge.ImmiInit;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin
    CreateAndInitExpretion(fExprColor,  FColor);

  end;
end;


procedure TImColorExprBridge.ImmiUnInit;
begin
if fisinit and not (csDesigning	 in ComponentState)
                              and (fListComp.Count>0) then
  begin
   if assigned(fexprColor) then fExprColor.ImmiUnInit;

  end;
end;

procedure TImColorExprBridge.ImmiUpdate;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin

    if assigned(fExprColor) then SetPropertyInComponent(fExprColor,'Color');


  end;
end;



procedure TImColorListBridge.ImmiInit;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin
    CreateAndInitExpretion(fiExpretion, fiExpr);
    if assigned(Color) then Color.ImmiInit;

  end;
end;


procedure TImColorListBridge.ImmiUnInit;
begin
if fisinit and not (csDesigning	 in ComponentState)
                              and (fListComp.Count>0) then
  begin
   if assigned(Color) then Color.ImmiUnInit;
   if assigned(fiExpretion) then fiExpretion.ImmiUnInit
  end;
end;

procedure TImColorListBridge.ImmiUpdate;
var i: integer;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin

    if assigned(fiExpretion) then
      begin
        fiExpretion.ImmiUpdate;
        if fiExpretion.isTrue then
          begin
          for i:=0 to fListComp.Count-1 do
            begin

            setordprop(TObject(fListComp.Items[i]),'Color',integer(iColor));
            end;
           // showmessage(self.Name);
          end;
      end;
    if assigned(Color) then Color.ImmiUpdate;


  end;
end;

procedure TImColorListBridge.SetColor(value: TImColorListBridge);
var i: integer;
begin
  if value=nil then
    begin

     if fColor<>nil then

     fColor.fListComp.Assign(fListComp,laXor);
     fColor:=nil;


    end;
  if value is TImColorListBridge then
               begin
                   value.fListComp.Assign(fListComp,laOr);
                 //  if value.fListComp.Count=0 then showmessage('ggggg'+inttostr(fListComp.Count));
                   fColor:=value;
                   if  (self.Color.Color<>nil)  then self.Color.Color:=self.Color.Color;
               end;

end;





procedure TImPersistentBridge.SetColor(value: TImColorBridge);
begin
  if value=nil then
    begin
     if fColor<>nil then
     fColor.fListComp.Assign(fListComp, laXor);
     fColor:=nil;
     exit;
    end;
  if value is TImColorBridge then
                {if value<>fColor then }
                  begin
                   fColor:=value;
                   value.fListComp.Assign(fListComp,laOr);
                  // fColor:=value;
                  end;

end;

procedure TImControlBridge.SetFont(value: TImFontBridge);
var i: integer;
    f: TObject;
    nameF: string;
begin
  nameF:='Font';
  if value=nil then
    begin
     if fFont<>nil then
      begin

      for i:=0 to fListComp.count-1 do
                           begin
                           f:=GetObjectProp(TObject(fListComp.items[i]),'Font');
                           ffont.fListComp.remove(f as TFont);
                           end;
       ffont:=nil;
      end;
     exit;
    end;
  if value is TImFontBridge then
                if value<>fFont then
                  begin
                  // value.AddToList(self);
                   fFont:=value;
                 //  value.fListComp.clear;
                   for i:=0 to fListComp.count-1 do
                           begin
                           f:=GetObjectProp(TObject(fListComp.items[i]),'Font');
                           value.fListComp.add(f as TFont);
                           end;
                  end;
end;

procedure TImPersistentBridge.ImmiInit;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin
    CreateAndInitExpretion(fExprLeft,  FLeft);
    CreateAndInitExpretion(fExprTop,  Ftop);
    CreateAndInitExpretion(fExprWidth,  FWidth);
    CreateAndInitExpretion(fExprHeight,  FHeight);
    CreateAndInitExpretion(fExprVisible,  FVisible);
    if assigned(FColor) then FColor.ImmiInit;
    fisInit:=true;
  end;
end;

procedure TImPersistentBridge.ImmiUnInit;
begin
if not (csDesigning	 in ComponentState)
                              and (fListComp.Count>0) then
  begin
   if assigned(fExprLeft) then fExprLeft.ImmiUnInit;
   if assigned(fExprTop) then fExprTop.ImmiUnInit;
   if assigned(fExprHeight) then fExprHeight.ImmiUnInit;
   if assigned(fExprWidth) then fExprWidth.ImmiUnInit;
   if assigned(fExprVisible) then fExprVisible.ImmiUnInit;
   if assigned(fColor) then fColor.ImmiUnInit;
   // fisInit:=false;
  end;
end;

procedure TImPersistentBridge.ImmiUpdate;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin

    if assigned(fExprLeft) then SetPropertyInComponent(fExprLeft,'Left');
    if assigned(fExprTop) then SetPropertyInComponent(fExprTop,'Top');
    if assigned(fExprHeight) then SetPropertyInComponent(fExprHeight,'Height');
    if assigned(fExprWidth) then SetPropertyInComponent(fExprWidth,'Width');
    if assigned(fExprVisible) then SetPropertyInComponent(fExprVisible,'Visible');
    if assigned(fColor) then fColor.ImmiUpdate;

  end;
end;




procedure TImControlBridge.ImmiInit;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin
    inherited;
    if assigned(FFont) then FFont.ImmiInit;

  end;
end;

procedure TImControlBridge.ImmiUnInit;
begin
if fisinit and not (csDesigning	 in ComponentState)
                              and (fListComp.Count>0) then
  begin
   inherited;
   if assigned(fFont) then fFont.ImmiUnInit;

  end;
end;

procedure TImControlBridge.ImmiUpdate;
begin
if not (csDesigning	 in ComponentState) and (fListComp.Count>0) then
  begin

    inherited;
    if assigned(fFont) then fFont.ImmiUpdate;

  end;
end;




procedure Register;
begin
 // RegisterComponents('IMMIImit', [TImControlBridge]);
 // RegisterComponents('IMMIImit', [TImColorExprBridge]);
 // RegisterComponents('IMMIImit', [TImColorListBridge]);
 // RegisterComponents('IMMIImit', [TImFontBridge]);

end;

end.
 