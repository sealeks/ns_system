unit TimeSincronize;

interface

uses StrUtils,Windows,SysUtils, GlobalValue,Forms;


function Sincronize: boolean;


implementation

function Sincronize: boolean;
  var f: Pchar;
begin

  result:=false;
  if reserver<>'' then
   begin
    Application.ProcessMessages;
    f:=PChar('net time /set /y \\'+ reserver);
    if winexec(f,0)>31 then result:=true;
   end;
end;

end.
