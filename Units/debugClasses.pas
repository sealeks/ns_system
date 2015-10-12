unit debugClasses;

interface

uses sysUtils;
type
TDebug = class (TObject)
private
  LogFile: textfile;
  LogFileOK: boolean;
public
  constructor create;
  procedure Log(Msg: string);
  destructor Destroy; override;
end;

var
  debug: TDebug;

implementation

{ TDebug }
const
  DebugLogFile: string = 'debug.txt';

constructor TDebug.create;
begin
  inherited;
  {LogFileOk := FileExists (DebugLogFile);
  if not LogFileOK then exit;
  AssignFile(LogFile, DebugLogFile);
  Append(LogFile);
  Writeln(LogFile, dateTimeToStr(Now) + ' ' + 'Начало отладки ');
  flush(LogFile);
  closefile(logFile);   }
end;

destructor TDebug.Destroy;
begin
 { Close (LogFile);}
  inherited;
end;

procedure TDebug.Log(Msg: string);
begin
 { if LogFileOk then
  begin
    AssignFile(LogFile, DebugLogFile);
    Append(LogFile);
    Writeln(logFile, dateTimeToStr(Now) + ' ' + Msg);
    flush(LogFile);
    closefile(logFile);
  end;         }
end;

begin
  {debug := TDebug.Create;}
end.





