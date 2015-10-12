unit ArchiveItemWraperU;

interface

uses
  Classes, ItemAdapterU, MemStructsU, SysUtils,ValEdit,Grids,SimpleItemAdapterU;

type
  TArchiveItemWraper = class(TRTItemWraper)
  private
  public
     procedure setMap(); override;
     function setchange(key: integer; val: string): string; override;

  end;

implementation

procedure TArchiveItemWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('���',Name_,true);
         setPropertys('�����������',Comment_);
         setPropertys('���������� ������� min',MinEU_);
         setPropertys('���������� ������� max',MaxEU_);
         setPropertys('���������� ������� ',EU_);
         setPropertys('�������������',Logged_,getBooleanList());
         setPropertys('������� ���� �������������',LogDB_);
         setPropertys('������ ������ �������������',LogTime_);
         setNew();

end;


function TArchiveItemWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: MinEU_:=val;
   3: MaxEU_:=val;
   4: EU_:=val;
   5: Logged_:=val;
   6: LogDB_:=val;
   7: LogTime_:=val;
   end;


end;
end.
