unit AlarmItemWraperU;

interface

uses
  Classes, ItemAdapterU, MemStructsU, SysUtils,ValEdit,Grids,SimpleItemAdapterU;

type
  TAlarmItemWraper = class(TRTItemWraper)
  private

  public
     procedure setMap(); override;
     function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TAlarmItemWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('���',Name_,true);
         setPropertys('�����������',Comment_);
         setPropertys('��������� ���������',AlarmLocalMsg_,getBooleanList());
         setPropertys('��������� ���������',AlarmMsg_,getBooleanList());
         setPropertys('����� ���������� ���������',AlarmMsgStr_);

         setPropertys('������� ���������� �������� �������',AlarmCond_,getCondList());
         setPropertys('��������� �������� �������',AlarmConst_);
         setNew();

end;


function TAlarmItemWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: AlarmLocalMsg_:=val;
   3: AlarmMsg_:=val;
   4: AlarmMsgStr_:=val;
   5: AlarmCond_:=val;
   6: AlarmConst_:=val;


   end;


end;

end.
