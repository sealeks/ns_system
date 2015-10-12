unit OldGroupWraperU;

interface

uses
  Classes,SimpleGroupAdapterU,SysUtils,StrUtils,Windows,ItemAdapterU;

type
  TOldGroupWraper = class(TGroupWraper)
  private
    { Private declarations }
  public
    procedure setType();  override;
    procedure setMap();    override;
    function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TOldGroupWraper.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Имя',GetName_);
         setPropertys('Номер потока',Slave_);
         setPropertys('Приложение','ServerPEther.exe',true);
         setNew();
end;

function TOldGroupWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;

   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Slave_:=val;

           
   end;


end;


procedure TOldGroupWraper.SetType;
var i: integer;
begin
  Application_:='MyPLCDirectServer';
  Topic_:='MyPLCDirectServer';
end;

end.
