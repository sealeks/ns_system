unit PLNClock;
{
**************************************************
**                                              **
**     PLNClock component for Delphi            **
**     V 1.22                                   **
**     Author: Frenk Vrtariè                    **
**             Cerknica, Slovenia               **
**                                              **
**                       1.9.2001               **
**                       7.5.2002               **
**                                              **
**     e-mail: VFrenk1@volja.net                **
**             NMC@SIOL.NET                     **
**                                              **
**   Thanks Uljaki Sándor for event routines.   **
**     e-mail: ujlaki.sandor@drotposta.hu       **
**                                              **
**************************************************

Do not change this head!
Freeware: Feel free to use and improve!
Infoware: I'd like to know, in what kind of programs this clock appears. So,
					it will be nice if you send me small mail about project, maybe also
          small screenshoot.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
	TNotifyTime = procedure (Sender :TObject;nHour,nMin,nSec :integer ) of object;
  THrStyle = (hsLine, hsCircle, hsNumber, hsNumInCir);
  THrMarks = (hmNone, hmFour, hmAll);
  TPLNClock = class(TCustomPanel)
  private
    { Private declarations }
  	phStyle :THrStyle;
  	pmStyle :THrStyle;
		pHrMarks :THrMarks;
  	pnHrSize :integer;
  	pnMinSize :integer;
  	pnMinFontSize :integer;

    OldS :Word;

    plSekunde :Boolean;
    plEnabled :Boolean;
    plSpider :Boolean;
    plSecJump :Boolean;
    pdUra :TDateTime;
		pnOffs :Integer;
    plDate :Boolean;

    plMinMarks :Boolean;
    plColHr: TColor;
		plColHrIn: TColor;
    plColMin: TColor;
		plColMinIn: TColor;
    plColHandHr: TColor;
    plColHandMin: TColor;
    plColHandSec: TColor;

    pnWidthHandMin: Byte;
    pnWidthHandHr: Byte;
    pnWidthHandSec: Byte;
    pnWidthHr: Byte;
    pnWidthMin: Byte;

    pnCenterSize: Byte;
    pnCenterCol: TColor;

    FTimer: TTimer;
		lSekOver: Boolean;

		nDeli: integer;
	  nUraM :integer;
	  nUraU :integer;
	  nUraS :integer;
	  npx,npy :integer;
	  npxk,npyk,npk,npy23 :integer;

    OldHour, OldMin, OldSec: Integer;
    FOnChangeSec:  TNotifyTime;
    FOnChangeMin:  TNotifyTime;
    FOnChangeHour: TNotifyTime;
		FOnSameTime: TNotifyEvent;

//  	pfMinFont :TFont;
  protected

    { Protected declarations }
		procedure PplDate(Value: Boolean);
		procedure PplSecJump(Value: Boolean);
		procedure PplSpider(Value: Boolean);
    procedure PplEnabled(Value : boolean);
    procedure PplMinMarks(Value : boolean);
    procedure PphStyle(Value : THrStyle);
    procedure PpmStyle(Value : THrStyle);
    procedure PpHrMarks(Value : THrMarks);
//		procedure ppHrSize(Value: integer);
		procedure ppHrSize(Value: integer);
		procedure ppMinSize(Value: integer);
		procedure ppMinFontSize(Value: integer);
    procedure PpdUra(Value :TDateTime);
    procedure PpnOffs(Value :integer);
    procedure PplColHr(Value :TColor);
    procedure PplColHrIn(Value :TColor);
    procedure PplColMin(Value :TColor);
    procedure PplColMinIn(Value :TColor);

    procedure PplColHandHr(Value :TColor);
    procedure PplColHandMin(Value :TColor);
    procedure PplColHandSec(Value :TColor);

    procedure PpnWidthHandMin(Value :Byte);
    procedure PpnWidthHandHr(Value :Byte);
    procedure PpnWidthHandSec(Value :Byte);
    procedure PpnWidthHr(Value :Byte);
    procedure PpnWidthMin(Value :Byte);

		procedure Zrisi;
    procedure Loaded; override;
    procedure Resize; override;
    procedure Paint; override;
    procedure ActTimer(Sender: TObject);

		procedure DoAlarm;
    procedure DoChangeSec(nHr,nMin,nSec:integer);
    procedure DoChangeMin(nHr,nMin,nSec:integer);
    procedure DoChangeHour(nHr,nMin,nSec:integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Date: Boolean read plDate write PplDate default False;
    property ClockEnabled: Boolean read plEnabled write PplEnabled default True;
    property TimeSet: TDateTime read pdUra write PpdUra;
    property TimeOffset: Integer read pnOffs write PpnOffs default 0;
    property SpiderClock: Boolean read plSpider write PplSpider default True;
    property SecJump: Boolean read plSecJump write PplSecJump default False;
    property Seconds: Boolean read plSekunde write plSekunde default True;
    property MinMarks: Boolean read plMinMarks write pplMinMarks default True;
    property HrStyle: THrStyle read phStyle write pphStyle default hsLine;
    property MinStyle: THrStyle read pmStyle write ppmStyle default hsLine;
    property HrMarks: THrMarks read pHrMarks write ppHrMarks default hmAll;
    property HrSize: integer read pnHrSize write ppHrSize default 12;
    property MinSize: integer read pnMinSize write ppMinSize default 7;
    property MinFontSize: integer read pnMinFontSize write ppMinFontSize default 7;
    property ColorHr: TColor read plColHr write PplColHr default clRed;
    property ColorHrIn: TColor read plColHrIn write PplColHrIn default clYellow;
    property ColorMin: TColor read plColMin write PplColMin default clBlue;
    property ColorMinIn: TColor read plColMinIn write PplColMinIn default clYellow;
    property ColorHandHr: TColor read plColHandHr write PplColHandHr default clRed;
    property ColorHandMin: TColor read plColHandMin write PplColHandMin default clBlue;
    property ColorHandSec: TColor read plColHandSec write PplColHandSec default clRed;

    property WidthHandSec: Byte read pnWidthHandSec write PpnWidthHandSec default 1;
    property WidthHandMin: Byte read pnWidthHandMin write PpnWidthHandMin default 3;
    property WidthHandHr: Byte read pnWidthHandHr write PpnWidthHandHr default 5;
    property WidthHr: Byte read pnWidthHr write PpnWidthHr default 2;
    property WidthMin: Byte read pnWidthMin write PpnWidthMin default 1;

//    property MinFont :TFont read pfMinFont write pfMinFont;

    property CenterSize: Byte read pnCenterSize write pnCenterSize default 3;
    property CenterCol: TColor read pnCenterCol write pnCenterCol default clPurple;

    property Align;
    property Color default clYellow;
    property Cursor;
    property DragCursor;
    property DragMode;
    property ParentColor;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChangeSec:  TNotifyTime read FOnChangeSec  write FOnChangeSec;
    property OnChangeMin:  TNotifyTime read FOnChangeMin  write FOnChangeMin;
    property OnChangeHour: TNotifyTime read FOnChangeHour write FOnChangeHour;

    property OnSameTime: TNotifyEvent read FOnSameTime write FOnSameTime;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;

    property Width default 137;
    property Height default 137;
		property BevelWidth;
    property BevelInner default bvLowered;
    property BevelOuter default bvRaised;
  end;

procedure Register;

implementation

//{$R *.res}

constructor TPLNClock.Create;
var
h,m,s,hund :word;
begin
  inherited;
  BevelOuter := bvRaised;
  BevelInner := bvLowered;
  BevelWidth := 3;
	pnHrSize := 12;
	pnMinSize := 7;
	pnMinFontSize := 7;

	plSpider := True;
	plSecJump := False;
	plEnabled := True;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled:= plEnabled;
  FTimer.Interval := 100;
  FTimer.OnTimer := ActTimer;

  Color := clYellow;
  Width := 137;
  Height := 137;
  Caption := ' ';
	plSekunde := True;
	plMinMarks := True;
	nDeli := 50;

	phStyle := hsLine;
	pmStyle := hsLine;
	pHrMarks := hmAll;

  plColHr := clRed;
  plColHrIn := clYellow;
  plColMin := clBlue;
  plColMinIn := clYellow;
  plColHandHr := clRed;
  plColHandMin := clBlue;
  plColHandSec := clPurple;

  pnWidthHandSec := 1;
  pnWidthHandMin := 3;
  pnWidthHandHr := 5;
  pnWidthHr := 2;
	pnWidthMin := 1;

  pnCenterCol := clPurple;
  pnCenterSize := 5;

//  pfMinFont := TFont.Create;
//  pfMinFont := TTextAttributes.Create;
//	pfMinFont.Assign(Font);
//	pfMinFont.Charset := Font.Charset;
//	pfMinFont.Name := Font.Name;
//	pfMinFont.Color := Font.Color;
//	pfMinFont.Size := Font.Size;
//	pfMinFont.Style := Font.Style;
//	pfMinFont.Pitch := Font.Pitch;
//	pfMinFont.FontAdapter := Font.FontAdapter;
//	pfMinFont.OnChange := Font.OnChange;
	//Zrisi;

	DecodeTime(Now,h,m,s,hund);
  OldMin := m;
  OldHour := h;
  OldSec := s;
end;

destructor TPLNClock.Destroy;
begin
  FTimer.Free;
//  pfMinFont.Free;
  inherited;
end;

procedure TPLNClock.Loaded;
begin
  inherited Loaded;
	Zrisi;
end;

procedure TPLNClock.Resize;
begin
  inherited;
	Zrisi;
end;

procedure TPLNClock.Paint;
begin
  inherited;
  Zrisi;
end;

procedure Register;
begin
  RegisterComponents('Immi', [TPLNClock]);
end;

procedure TPLNClock.PpdUra(Value : TDateTime);
begin
pdUra := Value;
nDeli := 50;
ActTimer(self);
end;

procedure TPLNClock.PpnOffs(Value : Integer);
begin
pnOffs := Value;
nDeli := 50;
if not plenabled then ActTimer(self);
end;

procedure TPLNClock.PplEnabled(Value: Boolean);
begin
plEnabled := Value;
if plEnabled and (not FTimer.Enabled) then FTimer.Enabled:= plEnabled;
nDeli := 50;
if not plenabled then
  begin
  pdUra := now;
	ActTimer(self);
  end;
end;

procedure TPLNClock.PplMinMarks(Value: Boolean);
begin
plMinMarks := Value;
Invalidate;
end;

procedure TPLNClock.pphStyle(Value: THrStyle);
begin
phStyle := Value;
Invalidate;
end;

procedure TPLNClock.ppmStyle(Value: THrStyle);
begin
pmStyle := Value;
Invalidate;
end;

procedure TPLNClock.ppHrMarks(Value: THrMarks);
begin
pHrMarks := Value;
Invalidate;
end;

procedure TPLNClock.pphrSize(Value: integer);
begin
pnhrSize := Value;
Invalidate;
end;

procedure TPLNClock.ppMinSize(Value: integer);
begin
pnMinSize := Value;
Invalidate;
end;

procedure TPLNClock.ppMinFontSize(Value: integer);
begin
pnMinFontSize := Value;
Invalidate;
end;

procedure TPLNClock.PplColHr(Value :TColor);
begin
plColHr := Value;
Invalidate;
end;

procedure TPLNClock.PplColHrIn(Value :TColor);
begin
plColHrIn := Value;
Invalidate;
end;

procedure TPLNClock.PplColMinIn(Value :TColor);
begin
plColMinIn := Value;
Invalidate;
end;

procedure TPLNClock.PplColMin(Value :TColor);
begin
plColMin := Value;
Invalidate;
end;

procedure TPLNClock.PplColHandHr(Value :TColor);
begin
plColHandHr := Value;
Invalidate;
end;

procedure TPLNClock.PplColHandMin(Value :TColor);
begin
plColHandMin := Value;
Invalidate;
end;

procedure TPLNClock.PplColHandSec(Value :TColor);
begin
plColHandSec := Value;
Invalidate;
end;

procedure TPLNClock.PpnWidthHandSec(Value :Byte);
begin
pnWidthHandSec := Value;
Invalidate;
end;

procedure TPLNClock.PpnWidthHandMin(Value :Byte);
begin
pnWidthHandMin := Value;
Invalidate;
end;

procedure TPLNClock.PpnWidthHandHr(Value :Byte);
begin
pnWidthHandHr := Value;
Invalidate;
end;

procedure TPLNClock.PpnWidthHr(Value :Byte);
begin
pnWidthHr := Value;
Invalidate;
end;

procedure TPLNClock.PpnWidthMin(Value :Byte);
begin
pnWidthMin := Value;
Invalidate;
end;

procedure TPLNClock.PplSecJump(Value: Boolean);
begin
plSecJump := Value;
//if plSecJump then FTimer.Interval := 500 else FTimer.Interval := 100;
end;

procedure TPLNClock.PplSpider(Value: Boolean);
begin
plSpider := Value;
Invalidate;
end;

procedure TPLNClock.PplDate(Value: Boolean);
begin
plDate := Value;
Invalidate;
//Zrisi;
end;

procedure TPLNClock.DoAlarm;
begin
  if Assigned(FOnSameTime) and not (csDestroying in ComponentState) then FOnSameTime(Self);
end;

procedure TPLNClock.DoChangeSec(nHr,nMin,nSec:integer);
begin
  if Assigned(FOnChangeSec) and not (csDestroying in ComponentState) then FOnChangeSec(Self,nHr,nMin,nSec);
end;

procedure TPLNClock.DoChangeMin(nHr,nMin,nSec:integer);
begin
  if Assigned(FOnChangeMin) and not (csDestroying in ComponentState) then FOnChangeMin(Self,nHr,nMin,nSec);
end;

procedure TPLNClock.DoChangeHour(nHr,nMin,nSec:integer);
begin
  if Assigned(FOnChangeHour) and not (csDestroying in ComponentState) then FOnChangeHour(Self,nHr,nMin,nSec);
end;


procedure TPLNClock.Zrisi;
var
fak :real;
t: Integer;
nUrca: Integer; //??
npkT,nXT,nYT: Integer;
rT :Trect;
sT :ShortString;
begin

npx := ((Width) div 2); {Center}
npy := ((Height) div 2);
//if plDate then npy := ((Height - pFDate.Height) div 2);
if plDate then npy := ((Height - (Font.Height+4)) div 2);

npxk := npx-(1+pnHrSize);
if BevelInner <> bvNone then npxk := npxk - (Bevelwidth);
if BevelOuter <> bvNone then npxk := npxk - (Bevelwidth);

npyk := npy-(1+pnHrSize);
if BevelInner <> bvNone then npyk := npYk - (Bevelwidth);
if BevelOuter <> bvNone then npyk := npYk - (Bevelwidth);

npk := npYk;
if npXk < npYk then npk := npXk;
npk := npk - pnWidthHr;
npy23 := npk div 3;

if plMinMarks then
	begin
	if pmStyle = hsLine then
		begin
		Canvas.Pen.Color := plColMin;
		Canvas.Pen.Width := pnWidthMin;
		fak := (Pi/(3000));
		for t := 0 to 59 do
			begin
			if (phStyle = hsNumInCir) or ((t mod 5) > 0) or (pHrMarks = hmNone) or ((pHrMarks = hmFour) and (((t div 5) mod 3) > 0) ) then
	      begin
			  nUrca := ((t)*100);
				if plSpider then
			    begin
					npkT := Round(SQRT(Abs((npYk) * cos(nUrca*fak))*Abs((npYk) * cos(nUrca*fak)) + Abs((npXk) * sin(nUrca*fak))*Abs((npXk) * sin(nUrca*fak)) ));
			    end
			  else
			    begin
					if npYk < npXk then npkT := npYk else npkT := npXk;
			    end;
				Canvas.MoveTo(npX+Round((npk+1)*sin(nUrca*fak)),npY-Round((npk+1)*cos(nUrca*fak)));
				nXT := npX+Round((npkT+pnMinSize)*sin(nUrca*fak));
				if nXT > npX+npXK+pnMinSize then nXT := npX+npXK+pnMinSize;
				if nXT < npX-npXK-pnMinSize then nXT := npX-npXK-pnMinSize;
			  nYT := npY-Round((npkT+pnMinSize)*cos(nUrca*fak));
				if nYT > npY+npYK+pnMinSize then nYT := npY+npYK+pnMinSize;
				if nYT < npY-npYK-pnMinSize then nYT := npY-npYK-pnMinSize;
				Canvas.LineTo(nXT,nYT);
	      end;
		  end;
	  end
  else
  	begin
		Canvas.Pen.Color := plColMin;
		Canvas.Pen.Width := pnWidthMin;
		if (pmStyle = hsNumber) or (pmStyle = hsNumInCir) then
      begin
    	Canvas.Font := Font;
    	Canvas.Font.Size := pnMinFontSize;
      end;
		fak := (Pi/(3000));
		for t := 0 to 59 do
			begin
			if ((t mod 5) > 0) or (pHrMarks = hmNone) or ((pHrMarks = hmFour) and (((t div 5) mod 3) > 0) ) then
//			if ((t mod 5) > 0) then
      	begin
			  nUrca := ((t)*100);
				if npYk < npXk then npkT := npYk else npkT := npXk;

				nXT := npX+1+Round((npkT+(pnMinSize div 2))*sin(nUrca*fak));
			  nYT := npY+1-Round((npkT+(pnMinSize div 2))*cos(nUrca*fak));
				rT := rect(nXT-(pnMinSize div 2),nYT-(pnMinSize div 2),nXT+(pnMinSize div 2),nYT+(pnMinSize div 2));
				sT := inttostr(t);
				if (pmStyle = hsCircle) or (pmStyle = hsNumInCir)  then
		      begin
					Canvas.Brush.Color := plColMinIn;
					Canvas.Brush.Style := bsSolid;
		    	Canvas.Ellipse(rT);
		      end;
				if (pmStyle = hsNumber) or (pmStyle = hsNumInCir)  then
		    	begin
					Canvas.Brush.Style := bsClear;
		      Canvas.TextRect(rT,rT.Right - ((rT.Right - rT.Left) div 2) - (Canvas.TextWidth(sT)div 2)-1, rT.Bottom - ((rT.Bottom - rT.Top) div 2) - (Canvas.TextHeight(sT) div 2)-1,sT);
		      end;
        end;
		  end;
    end;
  end;

if pHrMarks <> hmNone then
	begin
	if phStyle = hsLine then
		begin
		Canvas.Pen.Color := plColHr;
		Canvas.Pen.Width := pnWidthHr;
		fak := (Pi/(3000));
		for t:= 1 to 12 do
			begin
			if (pHrMarks = hmAll) or ((pHrMarks = hmFour) and ((t mod 3) = 0) ) then
      	begin
			  nUrca := ((t)*100)*30 div 6;
				if plSpider then
			    begin
					npkT := Round(SQRT(Abs((npYk) * cos(nUrca*fak))*Abs((npYk) * cos(nUrca*fak)) + Abs((npXk) * sin(nUrca*fak))*Abs((npXk) * sin(nUrca*fak)) ));
			    end
			  else
			    begin
					if npYk < npXk then npkT := npYk else npkT := npXk;
			    end;
				Canvas.MoveTo(npX+Round((npk+1)*sin(nUrca*fak)),npY-Round((npk+1)*cos(nUrca*fak)));
				nXT := npX+Round((npkT+pnHrSize)*sin(nUrca*fak));
				if nXT > npX+npXK+pnHrSize then nXT := npX+npXK+pnHrSize;
				if nXT < npX-npXK-pnHrSize then nXT := npX-npXK-pnHrSize;
			  nYT := npY-Round((npkT+pnHrSize)*cos(nUrca*fak));
				if nYT > npY+npYK+pnHrSize then nYT := npY+npYK+pnHrSize;
				if nYT < npY-npYK-pnHrSize then nYT := npY-npYK-pnHrSize;
				Canvas.LineTo(nXT,nYT);
        end;
		  end;
	  end
	else
		begin
		Canvas.Pen.Color := plColHr;
		Canvas.Pen.Width := pnWidthHr;
		if (phStyle = hsNumber) or (phStyle = hsNumInCir) then Canvas.Font := Font;
		fak := (Pi/(3000));
		for t:= 1 to 12 do
			begin
			if (pHrMarks = hmAll) or ((pHrMarks = hmFour) and ((t mod 3) = 0) ) then
      	begin
			  nUrca := ((t)*100)*30 div 6;
				if npYk < npXk then npkT := npYk else npkT := npXk;
				nXT := npX+1+Round((npkT+(pnHrSize div 2))*sin(nUrca*fak));
			  nYT := npY+1-Round((npkT+(pnHrSize div 2))*cos(nUrca*fak));
				rT := rect(nXT-(pnHrSize div 2),nYT-(pnHrSize div 2),nXT+(pnHrSize div 2),nYT+(pnHrSize div 2));
				sT := inttostr(t);
				if (phStyle = hsCircle) or (phStyle = hsNumInCir)  then
		      begin
					Canvas.Brush.Color := plColHrIn;
					Canvas.Brush.Style := bsSolid;
		    	Canvas.Ellipse(rT);
		      end;
				if (phStyle = hsNumber) or (phStyle = hsNumInCir)  then
		    	begin
					Canvas.Brush.Style := bsClear;
		      Canvas.TextRect(rT,rT.Right - ((rT.Right - rT.Left) div 2) - (Canvas.TextWidth(sT)div 2)-1, rT.Bottom - ((rT.Bottom - rT.Top) div 2) - (Canvas.TextHeight(sT) div 2)-1,sT);
		      end;
			  end;
		  end;
	  end;
  end;

if not plEnabled then
	begin
	nDeli := 50;
	ActTimer(Self);
  end;
end;

procedure TPLNClock.ActTimer;
var
h,m,s,hund :word;
h1,m1,s1,hund1 :word;
fak :real;
nUra: Integer;
dT :TDateTime;
begin

if not plEnabled then FTimer.Enabled:= plEnabled;
if plEnabled then dT := now else dT := pdUra;
dT := dT + (pnOffs/(60*24));
DecodeTime(dT,h,m,s,hund);
inc(nDeli);
if plSecJump then
	begin
	if s = OldS then if plEnabled then exit;
  OldS := s;
	hund := 0;
  end;

//event handler by Ujlaki Sándor e-mail: ujlaki.sandor@drotposta.hu
if plEnabled and (s <> OldSec) then //every seconds
	begin
  OldSec := s;
  DoChangeSec(h,m,s);
	DecodeTime(pdUra,h1,m1,s1,hund1);
	if (s1 = s) and (m1 = m) and (h1 = h) then DoAlarm;
  if m <> OldMin then
  	begin
    OldMin := m;
    DoChangeMin(h,m,s);
    if h <> OldHour then
    	begin
      OldHour := h;
      DoChangeHour(h,m,s);
	    end;
    end;
  end;

nUra := (((s)*1000)+hund) div 10;
fak := (Pi/(3000));
if plSekunde then inc(nDeli);

//Delete sec hand
if plSekunde or (nUraS > 0) then
	begin
	Canvas.Pen.Color := Color;
	Canvas.Pen.Width := pnWidthHandSec;

	Canvas.MoveTo(npX+Round(4*sin(nUraS*fak)),npY-Round(4*cos(nUraS*fak)));
	Canvas.LineTo(npX+Round(npk*sin(nUraS*fak)),npY-Round(npk*cos(nUraS*fak)));

	Canvas.MoveTo(npX-Round(4*sin(nUraS*fak)),npY+Round(4*cos(nUraS*fak)));
	Canvas.LineTo(npX-Round(15*sin(nUraS*fak)),npY+Round(15*cos(nUraS*fak)));
	end;

//Delete hand
if nDeli > 50 then
 	begin
	Canvas.Pen.Color := Color;
	Canvas.Pen.Width := pnWidthHandHr;

	//Urni kazalec
	Canvas.MoveTo(npX+Round(03*sin(nUraU*fak)),npY-Round(03*cos(nUraU*fak)));
	Canvas.LineTo(npX+Round((npk-npy23)*sin(nUraU*fak)),npY-Round((npk-npy23)*cos(nUraU*fak)));

	Canvas.MoveTo(npX-Round(03*sin(nUraU*fak)),npY+Round(03*cos(nUraU*fak)));
	Canvas.LineTo(npX-Round(10*sin(nUraU*fak)),npY+Round(10*cos(nUraU*fak)));

	//Minutni kazalec
	Canvas.Pen.Width := pnWidthHandMin;

	Canvas.MoveTo(npX+Round(3*sin(nUraM*fak)),npY-Round(3*cos(nUraM*fak)));
	Canvas.LineTo(npX+Round((npk-pnWidthHandMin)*sin(nUraM*fak)),npY-Round((npk-pnWidthHandMin)*cos(nUraM*fak)));

	Canvas.MoveTo(npX-Round(3*sin(nUraM*fak)),npY+Round(3*cos(nUraM*fak)));
	Canvas.LineTo(npX-Round(10*sin(nUraM*fak)),npY+Round(10*cos(nUraM*fak)));

	nUraM := (((m)*60+S)*10) div 6;
  nUraU := (((h)*60+m)*25) div 3;
	end;

//Draw hand
if ((nDeli > 50) or lSekOver) then
 	begin
	lSekOver := False;

	//Minutni kazalec
	Canvas.Pen.Width := pnWidthHandMin;
	Canvas.Pen.Color := plColHandMin;
  Canvas.MoveTo(npX+Round(3*sin(nUraM*fak)),npY-Round(3*cos(nUraM*fak)));
	Canvas.LineTo(npX+Round((npk-pnWidthHandMin)*sin(nUraM*fak)),npY-Round((npk-pnWidthHandMin)*cos(nUraM*fak)));

	Canvas.MoveTo(npX-Round(3*sin(nUraM*fak)),npY+Round(3*cos(nUraM*fak)));
	Canvas.LineTo(npX-Round(10*sin(nUraM*fak)),npY+Round(10*cos(nUraM*fak)));

	//Urni kazalec
	Canvas.Pen.Color := plColHandHr;
	Canvas.Pen.Width := pnWidthHandHr;
	Canvas.MoveTo(npX+Round(03*sin(nUraU*fak)),npY-Round(03*cos(nUraU*fak)));
	Canvas.LineTo(npX+Round((npk-npy23)*sin(nUraU*fak)),npY-Round((npk-npy23)*cos(nUraU*fak)));

	Canvas.MoveTo(npX-Round(03*sin(nUraU*fak)),npY+Round(03*cos(nUraU*fak)));
	Canvas.LineTo(npX-Round(10*sin(nUraU*fak)),npY+Round(10*cos(nUraU*fak)));

  if (not plSekunde) and (pnCenterSize > 0) then
   	begin
		Canvas.Pen.Color := plColHandHr;
    Canvas.Brush.Color := pnCenterCol;
    Canvas.Brush.Style := bsSolid;
		Canvas.Pen.Width := 1;
    Canvas.Ellipse(nPX-pnCenterSize,nPY-pnCenterSize,nPX+pnCenterSize,nPY+pnCenterSize);
    end;
	if (nDeli > 50) then nDeli := 0;
  end;

if plSekunde then
		begin
		Canvas.Pen.Width := pnWidthHandSec;
		Canvas.Pen.Color := plColHandSec;

		Canvas.MoveTo(npX+Round(4*sin(nUra*fak)),npY-Round(4*cos(nUra*fak)));
		Canvas.LineTo(npX+Round(npk*sin(nUra*fak)),npY-Round(npk*cos(nUra*fak)));

		Canvas.MoveTo(npX-Round(4*sin(nUra*fak)),npY+Round(4*cos(nUra*fak)));
		Canvas.LineTo(npX-Round(15*sin(nUra*fak)),npY+Round(15*cos(nUra*fak)));
		nUraS := nUra;

		lSekOver := True;

	  if (pnCenterSize > 0) then
	   	begin
			Canvas.Pen.Color := plColHandHr;
	    Canvas.Brush.Color := pnCenterCol;
	    Canvas.Brush.Style := bsSolid;
			Canvas.Pen.Width := 1;
	    Canvas.Ellipse(nPX-pnCenterSize,nPY-pnCenterSize,nPX+pnCenterSize,nPY+pnCenterSize);
	    end;

  	end else nUraS := 0;
end;

end.
