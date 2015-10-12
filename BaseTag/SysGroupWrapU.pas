unit SysGroupWrapU;

interface

uses
  Classes,SimpleGroupAdapterU;

type
  TSysGroupWrap = class(TGroupWraper)
  private
  public
   procedure setType();  override;
   procedure setMap(); override;
   function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TSysGroupWrap.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Приложение','NS_MemBaseServ.exe/NS_MemBaseServ_app.exe',true);
         setNew();
end;

function TSysGroupWrap.setchange(key: integer; val: string): string;
begin
   result:='';






end;


procedure TSysGroupWrap.SetType;
var i: integer;
begin
  Application_:='';
  Topic_:='';
end;

end.
