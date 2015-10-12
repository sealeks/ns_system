unit LogikaItemWrapU;

interface

uses
  Classes,SimpleItemAdapterU, SysUtils,ItemAdapterU,MemStructsU,ConstDef;

type
  TLogikaItemWrap = class(TRTItemWraper)
  private
     function GetTypL(Index: Integer): String;
     procedure SetTypL(Index: Integer; value: String);
     function GetTypL_(): String;
     procedure SetTypL_(value: String);
    { Private declarations }
  protected

    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    property TypL[Index: Integer]: String read GetTypL write SetTypL;
    property TypL_: String read GetTypL_ write SetTypL_;
  end;

implementation

function getTypLog(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('�� ����������');
 result.Add('10��������');
 result.Add('30��������');
 result.Add('�������');
 result.Add('��������');
 result.Add('��������');
 result.Add('��������');

end;

function TypLogtoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='10��������') then result:=REPORTTYPE_10MIN else
 if (val='30��������') then result:=REPORTTYPE_30MIN else
 if (val='�������') then result:=REPORTTYPE_HOUR else
   if (val='��������')then result:=REPORTTYPE_DAY else
     if (val='��������')then result:=REPORTTYPE_DEC else
       if (val='��������')then result:=REPORTTYPE_MONTH else
        result:=0;
end;

function InttoTypLog(val: integer): string;
begin
 case val of
 REPORTTYPE_MIN : result:='������';
 REPORTTYPE_10MIN : result:='10��������';
 REPORTTYPE_30MIN : result:='30��������';
 REPORTTYPE_HOUR : result:='�������';
 REPORTTYPE_DAY   : result:='��������';
 REPORTTYPE_DEC   : result:='��������';
 REPORTTYPE_MONTH : result:='��������';
 REPORTTYPE_QVART   : result:='������';
 REPORTTYPE_YEAR : result:='������';
 else result:='�� ����������';

 end;
end;

procedure TLogikaItemWrap.setMap();
begin
          editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('���',Name_);
         setPropertys('�����������',Comment_);
         setPropertys('��������',Source_);
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
         setPropertys('���',TypL_,getTypLog);
         setNew();




end;


function TLogikaItemWrap.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;
   2: Source_:=val;
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
   20: TypL_:=val;
   end;
end;



function TLogikaItemWrap.GetTypL(Index: Integer): String;
begin
    result:=InttoTypLog(LogTime[Index]);
end;

procedure TLogikaItemWrap.SetTypL(Index: Integer; value: String);
begin
   LogTime[Index]:=TypLogtoInt(value);
end;


function TLogikaItemWrap.GetTypL_(): String;
var i: integer;
begin
     result:=TypL[0];
        for i:=1 to idscount-1 do
         if (TypL[i]<>result) then
           begin
              result:='';
           end;
end;

procedure TLogikaItemWrap.SetTypL_( value: String);
var i: integer;
begin
   for i:=0 to idscount-1 do
     TypL[i]:=value;
end;


end.
 