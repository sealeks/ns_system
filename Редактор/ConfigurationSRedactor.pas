unit ConfigurationSRedactor;

interface

uses
StrUtils,Windows,SysUtils, GlobalValue,Classes ;

var
   serverEth: THandle;
   serverCom: THandle;
   MainInit: string;
function InitialSysRed(fil: string): integer;

implementation

function InitialSysRed(fil: string): integer;

var
  ethi,ecom: integer;
  immisys: TStringList;
  fi: TextFile;
  text: string;
begin
  { ini := TIniFile.Create(ConfigName);
         PathMem := ini.readString('SETTINGS', GetGCom('PathMem'), '');
         FormsDir := ini.readString('SETTINGS', GetGCom('FormsDir'), '');
         GlobalPicturePath := ini.readString('SETTINGS', GetGCom('GlobalPicturePath'), '');
         FirstPicturePath := ini.readString('SETTINGS', GetGCom('FirstPicturePath'), '');
         deletecircle := ini.readInteger('SETTINGS', GetGCom('deletecircle'), 0);  }

end;

end.
 