unit uMyTime;

interface
function MyTime: TDateTime;
function MyDate: TDateTime;
function MyNow: TDateTime;

implementation
uses sysUtils, Types, windows;

var
  StartTime: TDateTime;
  StartTickCount: DWORD;


function MyTime: TDateTime;
begin
  result := StartTime + (GetTickCount - StartTickCount) /86400000;
end;

function MyDate: TDateTime;
begin
  result := SysUtils.Date;
end;

function MyNow: TDateTime;
begin
  result := MyDate + MyTime;
end;

procedure SinhronizeTime;
begin
  StartTime := SysUtils.Time;
  while SysUtils.Time = startTime do;
  StartTickCount := GetTickCount;
  StartTime := SysUtils.Time;
end;



begin
  SinhronizeTime;
end.
