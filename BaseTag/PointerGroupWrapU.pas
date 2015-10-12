unit PointerGroupWrapU;

interface

uses
  Classes,SimpleGroupAdapterU;

type
  TPointerGroupWrap = class(TGroupWraper)
  private
  public
   procedure setType();  override;
   procedure setMap(); override;
   function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TPointerGroupWrap.setMap();
var
    str: String;
    id: integer;
    StrL: TStringList;
    diff: boolean;

begin
         editor.Strings.Clear;
       //  setPropertys('Сервер DDE',Application_);
         setNew();
end;

function TPointerGroupWrap.setchange(key: integer; val: string): string;
begin
   result:='';
  // case key of
   // 0: Application_:=val;
   //end;
end;


procedure TPointerGroupWrap.SetType;
var i: integer;
begin
  Application_:='';
  Topic_:='';
end;

end.
