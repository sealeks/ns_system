unit ArchGroupWrapU;

interface

uses
  Classes,SimpleGroupAdapterU;

type
  TArchGroupWrap = class(TGroupWraper)
  private
  public
   procedure setType();  override;
   procedure setMap(); override;
   function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TArchGroupWrap.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
         setPropertys('Приложение','NS_ArchServ.exe/NS_ArchServ_app.exe',true);
         setNew();
end;

function TArchGroupWrap.setchange(key: integer; val: string): string;
begin
   result:='';






end;


procedure TArchGroupWrap.SetType;
var i: integer;
begin
  Application_:='';
  Topic_:='';
end;
end.
