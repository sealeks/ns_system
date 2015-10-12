unit debugClassesplc;

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

constructor TDebug.create;
const
  FN: string = 'debug.txt';
begin
  inherited;
 // LogFileOk := FileExists (FN);
 // if not LogFileOK then exit;
 // AssignFile(LogFile, FN);
 // Rewrite(LogFile);
 // Writeln(LogFile, dateTimeToStr(Now) + ' ' + 'Начало отладки ');
//  flush(LogFile);
end;

destructor TDebug.Destroy;
begin
  Close (LogFile);
  inherited;
end;

procedure TDebug.Log(Msg: string);
begin
  if LogFileOk then
  begin
    Writeln(logFile, dateTimeToStr(Now) + ' ' + Msg);
    flush(LogFile);
  end;
end;

begin
  debug := TDebug.Create;
end.
