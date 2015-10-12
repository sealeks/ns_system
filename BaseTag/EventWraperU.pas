unit EventWraperU;

interface

uses
 Classes, ItemAdapterU, MemStructsU, SysUtils,ValEdit,Grids,SimpleItemAdapterU;

type
  TEventWraper = class(TRTItemWraper)
  private
  public
     procedure setMap(); override;
     function setchange(key: integer; val: string): string; override;

  end;

implementation

procedure TEventWraper.setMap();
begin
         editor.Strings.Clear;
         if (getCount<2) then
         setPropertys('Тег',Name_,true);
         setPropertys('Комментарий',Comment_);
         setPropertys('Сообщение о включении',OnMsg_,getBooleanList());
         setPropertys('Текст сообщения о включении',OnMsgStr_);
         setPropertys('Сообщение о выключении',OffMsg_,getBooleanList());
         setPropertys('Текст сообщения о выключении',OffMsgStr_);
         setNew();

end;


function TEventWraper.setchange(key: integer; val: string): string;
begin
   result:='';
   if (getCount>1) then key:=key+1;


   case key of
   0: begin Name_:=val;  result:=val; end;
   1: Comment_:=val;

   2: OnMsg_:=val;
   3: OnMsgStr_:=val;
   4: OffMsg_:=val;
   5: OffMsgStr_:=val;

   end;


end;

end.
