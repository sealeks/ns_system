unit SysVarItemWrapU;

interface

uses
  Classes,SimpleItemAdapterU, SysUtils,ItemAdapterU,MemStructsU;

type
  TSysVarItemWrap = class(TRTItemWraper)
  private
    { Private declarations }
  protected

    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
  end;

implementation

procedure TSysVarItemWrap.setMap();
begin
          editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('���',Name_);
         setPropertys('�����������',Comment_);
         setPropertys('��������',Val_);
         setPropertys('������� ����������� min',MinRaw_);
         setPropertys('������� ����������� max',MaxRaw_);
         setPropertys('������� ����������� (������� ����)',DeadBaund_);
         setPropertys('���������� ������� min',MinEU_);
         setPropertys('���������� ������� max',MaxEU_);
         setPropertys('���������� ������� ',EU_);
         setPropertys('��������� � ���������',OnMsg_,getBooleanList());
         setPropertys('����� ��������� � ���������',OnMsgStr_);
         setPropertys('��������� � ����������',OffMsg_,getBooleanList());
         setPropertys('����� ��������� � ����������',OffMsgStr_);
         setPropertys('��������� ���������',AlarmLocalMsg_,getBooleanList());
         setPropertys('��������� ���������',AlarmMsg_,getBooleanList());
         setPropertys('����� ���������� ���������',AlarmMsgStr_);
         setPropertys('��������� �������� �������',AlarmConst_);
         setPropertys('������� ���������� �������� �������',AlarmCond_,getCondList());
         setPropertys('�������������',Logged_,getBooleanList());
         setPropertys('������� ���� �������������',LogDB_);
         setPropertys('���',Typ_,getTypIt);
         setNew();




end;


function TSysVarItemWrap.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: Val_:=val;
   3: MinRaw_:=val;
   4: MaxRaw_:=val;
   5: DeadBaund_:=val;
   6: MinEU_:=val;
   7: MaxEU_:=val;
   8: EU_:=val;
   9: OnMsg_:=val;
   10: OnMsgStr_:=val;
   11: OffMsg_:=val;
   12: OffMsgStr_:=val;
   13: AlarmLocalMsg_:=val;
   14: AlarmMsg_:=val;
   15: AlarmMsgStr_:=val;
   16: AlarmConst_:=val;
   17: AlarmCond_:=val;
   18: Logged_:=val;
   19: LogDB_:=val;
   20: Typ_:=val;
   end;
end;



end.
