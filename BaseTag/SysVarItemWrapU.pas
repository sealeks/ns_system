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
         setPropertys('Тег',Name_);
         setPropertys('Комментарий',Comment_);
         setPropertys('Значение',Val_);
         setPropertys('Единицы контроллера min',MinRaw_);
         setPropertys('Единицы контроллера max',MaxRaw_);
         setPropertys('Единицы контроллера (мертвая зона)',DeadBaund_);
         setPropertys('Инженерные единицы min',MinEU_);
         setPropertys('Инженерные единицы max',MaxEU_);
         setPropertys('Инженерные единицы ',EU_);
         setPropertys('Сообщение о включении',OnMsg_,getBooleanList());
         setPropertys('Текст сообщения о включении',OnMsgStr_);
         setPropertys('Сообщение о выключении',OffMsg_,getBooleanList());
         setPropertys('Текст сообщения о выключении',OffMsgStr_);
         setPropertys('Тревожное сообщение',AlarmLocalMsg_,getBooleanList());
         setPropertys('Аварийное сообщение',AlarmMsg_,getBooleanList());
         setPropertys('Текст тревожного сообщения',AlarmMsgStr_);
         setPropertys('Граничное значение тревоги',AlarmConst_);
         setPropertys('Условие граничного значения тревоги',AlarmCond_,getCondList());
         setPropertys('Архивирование',Logged_,getBooleanList());
         setPropertys('Мертвая зона архивирования',LogDB_);
         setPropertys('Тип',Typ_,getTypIt);
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
