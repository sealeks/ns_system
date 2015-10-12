unit ItemCoordinator;

interface

uses
  Classes,ItemAdapterU,SimpleItemAdapterU,GroupsU,ValEdit,Grids,Controls, Graphics,ConstDef,
  MemStructsU,SimpleGroupAdapterU,SysUtils,OPCGroupAdapterU,HDAGroupAdapterU,ArchiveItemWraperU,
  SysGroupWrapU, KoyoServGroupU,DDEGroupWraperU,OldGroupWraperU,SocketWraperU,HDAItemWraperU,AlarmItemWraperU,PointerGroupWrapU,
  EventWraperU,KoyoEthServGroupU,OPCItemWraperU,SysVarItemWrapU, KoyoServGroupsU,
  ProjectpropItWrapU,ReportItemWraperU,ArchGroupWrapU,
  LogikaServGroupU,LogikaItemWrapU,SETServGroupU,SETItemWrapU,MetaWraperU;








Type
TItemInfo=record
multi: boolean;
edittype: TEditStyle;
list: TStrings;
end;

PTItemInfo = ^TItemInfo;

type
  TItemCoordinator = class(TObject)
  private
    { Private declarations }
    rtit: TanalogMems;
    rtgroup: TGroups;
    nodetype: TNSNodeType;
    itemwraper: TItemWraper;
    wrap_it: TRTItemWraper;
    wrap_itHDA: THDAItemWraper;
    wrap_itAlarm: TAlarmItemWraper;
    wrap_itArchive: TArchiveItemWraper;
    wrap_itEvent: TEventWraper;
    wrap_itOPC:  TOPCItemWraper;
    wrap_itSysVar:  TSysVarItemWrap;
    wrap_itReport:  TReportItemWraper;
    wrap_itReportCnt:  TReportItemWraper;
    wrap_itLogika:  TLogikaItemWrap;

    wrap_gr: TGroupWraper;
    wrap_grOPC: TOPCGroupWraper;
    wrap_grHDA: THDAGroupWraper;
    wrap_grKoyo: TKoyoServGroup;
    wrap_grDDE: TDDEGroupWraper;
    wrap_old: TOldGroupWraper;
    wrap_net: TSocketWraper;
    wrap_grEthKoyo: TKoyoEthServGroup;
    wrap_grSys: TSysGroupWrap;
    wrap_grArh: TArchGroupWrap;
    wrap_grPointer: TPointerGroupWrap;
    wrap_grLogika: TLogikaServGroup;
    wrap_grSET: TSETServGroup;
    wrap_grKoyos: TKoyoServGroups;

    wrap_cfg: TProjectpropItWrap;

    wrap_meta: TMetaWraper;

    control: TControl;
    changegroup: boolean;
    oldWraper: TItemWraper;
    editor:  TValueListEditor;
    function getTypeGroup(node: TNSNodeType): TItemWraper;
    function getTypeItem(node: TNSNodeType): TItemWraper;

  protected

  public
  procedure resetsetgroup(val: TGroups);
  function setTypeGroups(node_: integer): integer;
  function setTypeGroupC(val: integer): integer;


  procedure setList(list: TList; node: TNSNodeType);  overload;
  procedure setList(list: TList; node: TNSNodeType; parnode: TNSNodeType); overload;
  procedure Refresh;
 // function setTypeGroup(val: integer): integer;
  function Save(): string;
  constructor create(source: TObject;source1: TObject;le: TValueListEditor; button: TControl);
  destructor destroy;
  end;

  function isSystemGroup(val: string): TNSNodeType;
  function gettype(app: String; topic: string; name: string): TNSNodeType;
  function getGroupIndex(val: TNSNodeType): integer;
  function getNodeTypebyIndex(val: integer): TNSNodeType;
  function getItemTypeIndex(val: PTAnalogMem): integer;

 function getNameGrByIndex(node: TNSNodeType): string;


implementation






  function isSystemGroup(val: string): TNSNodeType;
   begin
     result:=ntOBase;
     if trim(uppercase(val))='$SYSVAR' then  result:=ntOSysVar;
     if trim(uppercase(val))='$SYSTEM' then  result:=ntOSystem;
     if trim(uppercase(val))='$REPORT' then  result:=ntOReport;
     if trim(uppercase(val))='$REPORTCOUNT' then  result:=ntOReportCnt;
     if trim(uppercase(val))='$SERVERCOUNT' then  result:=ntOServCount;
     if trim(uppercase(val))='$COMMANDSCASE' then  result:=ntComands;
     if trim(uppercase(val))='$POINTER' then result:=ntOPoint;
    // if pos('$ССЫЛОЧНАЯ',trim(uppercase(val)))=1 then result:=ntOPoint;
   end;



 function gettype(app: String; topic: string; name: string): TNSNodeType;
    var app_temp: String;
        topic_temp:  String;
    begin
       result:=ntOBase;
       app_temp:=trim(uppercase(app));
       topic_temp:=trim(uppercase(topic));

       if isSystemGroup(trim(uppercase(name)))<>ntOBase then
         begin
           result:=isSystemGroup(trim(uppercase(name)));
           exit;
         end;

       if (pos('\\',app_temp)=1) then
       begin
          result:=ntOnet;
       end;

       if (pos('MYPLCDIRECTSERVER',app_temp)=1) then
       begin
         result:=ntOSimple;

       end;

       if (pos('DIRECTKOYOSERV',app_temp)=1) then
         begin
            result:=ntODKoy;
           {begin
             if (pos('COM',topic_temp)=1)  then
               begin
                  result:=ntODKoy;
                  exit;
               end;
              if (pos('ETH',topic_temp)=1)  then
               begin
                 // result:=ntOEthKoy;
                  exit;
               end;
           end;  }
         end;

       if (pos('LOGIKASERV',app_temp)=1) then
         begin

           begin
             if (pos('COM',topic_temp)=1)  then
               begin
                  result:=ntOLogika;
                  exit;
               end;

           end;
         end;


       if (pos('SETSERV',app_temp)=1) then
         begin

           begin
             if (pos('COM',topic_temp)=1)  then
               begin
                  result:=ntOSET;
                  exit;
               end;

           end;
         end;

       if (pos('OPC_HDA[',app_temp)=1) then
         begin
            result:=ntOOPCHDA;
            exit;
         end;
       if (pos('OPC[',app_temp)=1) then
         begin
            result:=ntOOPC;
            exit;
         end;
       if (pos('DDE[',app_temp)=1) then
         begin
            result:=ntODDE;
            exit;
         end;
    end;

   function getGroupIndex(val: TNSNodeType): integer;
   begin
     case val of
       ntOEthKoy: result:=3;
       ntOnet: result:=7;
       ntOOPCHDA: result:=6;
       ntODDE:    result:=5;
       ntOOPC:    result:=4;
       ntODKoy:   result:=2;
       ntOSimple: result:=1;
       else result:=0;
   end;
   if not (val in ntOl) then
   result:=-1;
   end;

   function getNodeTypebyIndex(val: integer): TNSNodeType;
   begin
     case val of

       7 : result:=ntOnet;
       6 : result:=ntOOPCHDA;
       5 : result:=ntODDE;
       4 : result:=ntOOPC;
       3 : result:=ntOEthKoy;
       2 : result:=ntODKoy;
       1: result:=ntOSimple;
       0: result:=ntOBase;
       else result:=ntO;
   end;

   end;


   function getItemTypeIndex(val: PTAnalogMem): integer;
   var typ: integer;
   begin
     result:=integer(ntOT);
     if val=nil then exit;
     typ:=val.logTime;
     case typ of
       TYPE_DISCRET:  result:= integer(ntTDiskr);                     // дискретный параметер
       TYPE_INTEGER:  result:= integer(ntInt);                        //32 аналоговый целочисленный
       TYPE_DOUBLE:   result:= integer(ntReal);                       //32 аналоговый плавающая точка
       TYPE_LONGWORD: result:= integer(ntLongW);                      //32 аналоговый целочисленный без знака
       TYPE_SMALLINT: result:= integer(ntSmallI);                    //16 аналоговый целочисленный
       TYPE_WORD:     result:= integer(ntWord) ;                      //16 аналоговый целочисленный без знака
       TYPE_SHORTINT: result:= integer(ntTShortI) ;                     //8 аналоговый целочисленный
       TYPE_BYTE: 	  result:= integer(ntTByte);                      //8 аналоговый целочисленный без знака

       TYPE_CHAR: 	  result:= integer(ntChar);                      //однобитный строковой
       TYPE_TEXT: 	  result:= integer(ntText);                    // двубитный строковой

       TYPE_SINGLE:	  result:= integer(ntSing);                     //4 аналоговый целочисленный без знака
       TYPE_REAL48:	  result:= integer(ntReal48);                   //6 аналоговый целочисленный без знака

       REPORTTYPE_YEAR: result:= integer(ntRepY);
       REPORTTYPE_QVART: result:= integer(ntRepQart);
       REPORTTYPE_MONTH: result:= integer(ntRepM);
       REPORTTYPE_DEC: result:= integer(ntRepDec);
       REPORTTYPE_DAY: result:= integer(ntRepD);
       REPORTTYPE_HOUR: result:= integer(ntRepH);
       REPORTTYPE_30MIN: result:= integer(ntRep30Min);
       REPORTTYPE_10MIN: result:= integer(ntRep10Min);
       REPORTTYPE_MIN: result:= integer(ntRepMin);

       TYPE_DT: result:= integer(ntDT);


       EVENT_TYPE_WITHTIME: result:= integer(ntEvent);         // для событий с временной пометкой, Logtime=-999
       EVENT_TYPE_ALARM:    result:= integer(ntAnEvent);            // для событий с временной пометкой т аналоговым значением, Logtime=-850
       EVENT_TYPE_OSC:      result:= integer(ntOsc);              // события осцилографа
      end;
   end;

   function getNameGrByIndex(node: TNSNodeType): string;
   begin
      case node of
               ntOOPCHDA: result:='OPCHDA';
               ntODDE:    result:='DDE';
               ntOOPC:    result:='OPC';
               ntODKoy:   result:='DirectNET';
             //  ntOSimple: result:='DirectSoft(старые сервера)';
               ntOBase:   result:='';
               ntOnet:    result:='Сетевой обмен';
            //   ntOEthKoy: result:='DirectSoft Ethernet';
               ntOSysVar: result:='$SysVar';
               ntOServCount: result:='$ServerCount';
               ntComands: result:='$CommandsCase';
               ntOPoint: result:='$ServerCount';
               ntOReport: result:='$Report';
               ntOReportCnt: result:='$ReportCount';
               ntOLogika: result:='Logika';
               ntOSET: result:='SET';
               else result:='';
            end;
   end;

   constructor TItemCoordinator.create(source: TObject;source1: TObject;le: TValueListEditor; button: TControl);
   begin
       control:=button;
       editor:=le;
       wrap_it:=TRTItemWraper.create(TanalogMems(source),le);
       wrap_itHDA:=THDAItemWraper.create(TanalogMems(source),le);
       wrap_itAlarm:=TAlarmItemWraper.create(TanalogMems(source),le);
       wrap_itArchive:=TArchiveItemWraper.create(TanalogMems(source),le);
       wrap_itEvent:=TEventWraper.create(TanalogMems(source),le);;
       wrap_itOPC:=TOPCItemWraper.create(TanalogMems(source),le);
       wrap_itSysVar:=TSysVarItemWrap.create(TanalogMems(source),le);;
       wrap_itReport:=TReportItemWraper.create(TanalogMems(source),le);
       wrap_itReportCnt:=TReportItemWraper.create(TanalogMems(source),le);
       wrap_itLogika:=TLogikaItemWrap.create(TanalogMems(source),le);

       Wrap_gr:=TGroupWraper.create(TGroups(source1),le);
       wrap_grOPC:=TOPCGroupWraper.create(TGroups(source1),le);
       wrap_grHDA:=THDAGroupWraper.create(TGroups(source1),le);
       wrap_grKoyo:=TKoyoServGroup.create(TGroups(source1),le);
       wrap_grDDE:=TDDEGroupWraper.create(TGroups(source1),le);
       wrap_old:=TOldGroupWraper.create(TGroups(source1),le);
       wrap_net:=TSocketWraper.create(TGroups(source1),le);
       wrap_grEthKoyo:=TKoyoEthServGroup.create(TGroups(source1),le);
       wrap_grSys:=TSysGroupWrap.create(TGroups(source1),le);;
       wrap_grArh:=TArchGroupWrap.create(TGroups(source1),le);;;
       wrap_grPointer:=TPointerGroupWrap.create(TGroups(source1),le);
       wrap_grLogika:=TLogikaServGroup.create(TGroups(source1),le);
       wrap_grSET:=TSETServGroup.create(TGroups(source1),le);
       wrap_grKoyos:=TKoyoServGroups.create(TGroups(source1),le);

       wrap_cfg:=TProjectpropItWrap.create('',le);;

       wrap_meta:=TMetaWraper.create(nil,le);

       rtgroup:=TGroups(source1);
       rtit:=TanalogMems(source);
       nodetype:=ntO;
       changegroup:=false;
   end;

   procedure TItemCoordinator.resetsetgroup(val: TGroups);
   begin
        rtgroup:=TGroups(val);
   end;


   destructor TItemCoordinator.destroy;
   begin


   end;

   function TItemCoordinator.getTypeGroup(node: TNSNodeType): TItemWraper;
    begin
       case node of
               ntOOPCHDA: result:=wrap_grHDA;
               ntODDE:    result:=wrap_grDDE;
               ntOOPC:    result:=wrap_grOPC;
               ntODKoy:   {result:=wrap_grKoyo;}result:=wrap_grKoyos;
               ntOSimple: result:=wrap_old;
               ntOBase:   result:=wrap_gr;
               ntOnet:    result:=wrap_net;
               ntOEthKoy: {result:=wrap_grEthKoyo;} result:=wrap_grKoyos;
               ntOSysVar: result:=wrap_grSys;
               ntOServCount: result:=wrap_grSys;
               ntComands: result:=wrap_grSys;
               ntOPoint: result:=wrap_grSys;
               ntOLogika: result:=wrap_grLogika;
               ntOSET: result:=wrap_grSET;
               ntOReport: result:=wrap_grArh;
               ntOReportCnt: result:=wrap_grArh;
               else result:=wrap_gr;
            end;
    end;

    function TItemCoordinator.getTypeItem(node: TNSNodeType): TItemWraper;
    begin
       case node of
               ntOOPCHDA: result:=wrap_itHDA;
               ntGl: result:=wrap_itAlarm;
               ntA: result:=wrap_itArchive;
               ntS:    result:=wrap_itEvent;
               ntOOPC:    result:=wrap_itOPC;
               ntODDE:    result:=wrap_itOPC;
               ntOSysVar: result:=wrap_itSysVar;
               ntOReport:   result:=wrap_itReport;
               ntOLogika: result:=wrap_itReport;
               ntOSET: result:=wrap_itReport;
              // ntOSimple: result:=wrap_old;
              // ntOBase:   result:=wrap_gr;
              // ntOnet:   result:=wrap_net;
               else result:=wrap_it;

            end;

    end;


   function TItemCoordinator.setTypeGroups(node_: integer): integer;
   var
        i: integer;
        node: TNSNodeType;
   begin
      node:=TNSNodeType(node_);
      if (node<>nodetype) then
       begin
           if ((node in ntOl) ) then
            begin
            nodetype:=node;
            oldWraper:=itemwraper;
            result:=integer(node);
            itemwraper:=getTypeGroup(node);
            itemwraper.idscount:=oldWraper.idscount;
            setLength(itemwraper.ids,oldWraper.idscount);
             for i:=0 to oldWraper.idscount-1 do
               begin
                  itemwraper.ids[i]:=oldWraper.ids[i];
               end;
             changegroup:=true;
             itemwraper.setMap;
             itemwraper.setControl(control);
             itemwraper.setEnabled(oldWraper<>itemwraper);
             editor.Enabled:=(oldWraper=itemwraper);

       end;
   end;
   end;

   function TItemCoordinator.setTypeGroupC(val: integer): integer;
   var
        i: integer;
        node: TNSNodeType;
   begin
      node:=getNodeTypebyIndex(val);
      result:=setTypeGroups(integer(node));
   end;

   procedure TItemCoordinator.setList(list: TList; node: TNSNodeType );
   var grnum: integer;
   grapp: string;
   begin
     setList(list,node, TNSNodeType(0));
   end;


   procedure TItemCoordinator.setList(list: TList; node: TNSNodeType; parnode: TNSNodeType);
   var grnum: integer;
   grapp: string;
   begin
     editor.OnEditButtonClick:=nil;
     editor.Color:=clWhite;
     editor.Enabled:=true;
     oldWraper:=nil;
     nodetype:=node;
     changegroup:=false;
     if (node in tegSet) then
     begin
       itemwraper:=getTypeItem(parnode);
       if node in ntArch then itemwraper:=wrap_itHDA;
       if ((parnode = ntOLogika ) or (parnode = ntOSET ))
           and not (node in ntArch) then itemwraper:=wrap_it;
       itemwraper.setList(list);
     end;
     if (node in ntOl) then
       itemwraper:=getTypeGroup(node);
     if (node=prjProp) then
        itemwraper:=wrap_cfg;
     if (node in ntMeta) then
          itemwraper:=wrap_meta;

       itemwraper.setList(list);
       itemwraper.setControl(control);
   end;

   procedure TItemCoordinator.Refresh;
   begin
      itemwraper.setMap();
   end;


  function TItemCoordinator.Save(): string;
  begin
      result:='';
      if  changegroup then
      begin
      changegroup:=false;
      itemwraper.setType;
      itemwraper.writetofile;
      itemwraper.setMap();
      editor.Color:=clWhite;
      editor.Enabled:=true;
      end
      else
      result:=itemwraper.save;

  end;




end.
 