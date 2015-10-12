unit uMyTimer;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,idGlobal,
  StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls;

type
  TMyTimer = class(TComponent)
  private
    ftickCount : integer;
    timeStart, timeStop : cardinal;
  public
    function GetTickCount : integer;
    procedure Start;
    function Stop : integer;
  published
    property tickCount: integer read ftickCount write ftickcount;
  end;

procedure Register;

implementation

procedure TMyTimer.Start;
begin
  TimeStart := idGlobal.GetTickCount;
  tickCount := 0;
end;

function TMyTimer.Stop: integer;
begin
   if tickCount = 0 then begin
     TimeStop := idGlobal.GetTickCount;
     tickCount := timeStop - timeStart;
   end;
     result := tickCount;
end;

function TMyTimer.GetTickCount: integer;
begin
     result := tickCount;
end;

procedure Register;
begin
  RegisterComponents('System', [TMyTimer]);
end;

end.
