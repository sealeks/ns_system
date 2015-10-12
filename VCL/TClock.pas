unit TClock;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls,ExtCtrls;

type timpr = procedure(hwnd1: hwnd; uMsg: DWORD;idEvent: DWORD; dwTime: DWORD) stdcall of object;

type
  TTClock = class(TPanel)
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


constructor TTClock.create(Aowner: TComponent);
var
   i: integer;
begin
inherited;

tpTimer:=TTimer.Create(self);
tpTimer.Interval:=100;
tpTimer.OnTimer:=self.PanelTimer;
end;

destructor TTClock.destroy;
begin
tpTimer.Free;
inherited;
end;

procedure TTClock.PanelTimer(Sender: TObject);
begin
self.Caption:=Timetostr(now);
end;

procedure TTClock.SetTickCounting(value: integer);
begin
if value <1 then value:=1;
if value >10000 then value:=10000;
fTickCounting:=value;
self.tpTimer.Interval:=fTickCounting;
end;

procedure Register;
begin
  RegisterComponents('IMMISample', [TTClock]);
end;

end.
