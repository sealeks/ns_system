unit TClockU;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,ExtCtrls, StdCtrls;

type timpr = procedure(hwnd1: hwnd; uMsg: DWORD;idEvent: DWORD; dwTime: DWORD) stdcall of object;

type
  TTClockU = class(TPanel)
  private
  fTickCounting: integer;
  tpTimer:  TTimer;
    { Private declarations }
  protected
    procedure SetTickCounting(value: integer);
  public
  constructor create(Aowner: TComponent); override;
  destructor destroy; Override;
  procedure PanelTimer(Sender: TObject);
    { Public declarations }
  published
  property TickCounting: integer  read fTickCounting write SetTickCounting;
    { Published declarations }
  end;

type
  TTClockLabelU = class(TLabel)
  private
  fTickCounting: integer;
  tpTimer:  TTimer;
    { Private declarations }
  protected
    procedure SetTickCounting(value: integer);
  public
  constructor create(Aowner: TComponent); override;
  destructor destroy; Override;
  procedure PanelTimer(Sender: TObject);
    { Public declarations }
  published
  property TickCounting: integer  read fTickCounting write SetTickCounting;
    { Published declarations }
  end;



procedure Register;


var
   {selff: TWincontrol; }
   i: integer;

 implementation


constructor TTClockU.create(Aowner: TComponent);
var
   i: integer;
begin
inherited;

tpTimer:=TTimer.Create(self);
tpTimer.Interval:=100;
tpTimer.OnTimer:=self.PanelTimer;
end;

destructor TTClockU.destroy;
begin
tpTimer.Free;
inherited;
end;

procedure TTClockU.PanelTimer(Sender: TObject);
begin
self.Caption:=Timetostr(now);
end;

procedure TTClockU.SetTickCounting(value: integer);
begin
if value <1 then value:=1;
if value >10000 then value:=10000;
fTickCounting:=value;
self.tpTimer.Interval:=fTickCounting;
end;

constructor TTClockLabelU.create(Aowner: TComponent);
var
   i: integer;
begin
inherited;

tpTimer:=TTimer.Create(self);
tpTimer.Interval:=100;
tpTimer.OnTimer:=self.PanelTimer;
end;

destructor TTClockLabelU.destroy;
begin
tpTimer.Free;
inherited;
end;

procedure TTClockLabelU.PanelTimer(Sender: TObject);
begin
self.Caption:=Timetostr(now);
end;

procedure TTClockLabelU.SetTickCounting(value: integer);
begin
if value <1 then value:=1;
if value >10000 then value:=10000;
fTickCounting:=value;
self.tpTimer.Interval:=fTickCounting;
end;



procedure Register;
begin
 // RegisterComponents('IMMISample', [TTClockU]);
//  RegisterComponents('IMMISample', [TTClockLabelU]);
end;

end.
