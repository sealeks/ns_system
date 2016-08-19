unit ItemCoordinator;

interface

uses
  Classes, ItemAdapterU, SimpleItemAdapterU, GroupsU, ValEdit, Grids, Controls,
  Graphics, ConstDef,
  MemStructsU, SimpleGroupAdapterU, SysUtils, OPCGroupAdapterU, HDAGroupAdapterU,
  ArchiveItemWraperU,
  SysGroupWrapU, KoyoServGroupU, DDEGroupWraperU, OldGroupWraperU,
  SocketWraperU, HDAItemWraperU, AlarmItemWraperU, PointerGroupWrapU,
  EventWraperU, KoyoEthServGroupU, OPCItemWraperU, SysVarItemWrapU, KoyoServGroupsU,
  ProjectpropItWrapU, ReportItemWraperU, ArchGroupWrapU,
  LogikaServGroupU, LogikaItemWrapU, SETServGroupU, SETItemWrapU, MetaWraperU;

type
  TItemInfo = record
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
    wrap_itOPC: TOPCItemWraper;
    wrap_itSysVar: TSysVarItemWrap;
    wrap_itReport: TReportItemWraper;
    wrap_itReportCnt: TReportItemWraper;
    wrap_itLogika: TLogikaItemWrap;

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
    editor: TValueListEditor;
    function getTypeGroup(node: TNSNodeType): TItemWraper;
    function getTypeItem(node: TNSNodeType): TItemWraper;

  protected

  public
    procedure resetsetgroup(val: TGroups);
    function setTypeGroups(node_: integer): integer;
    function setTypeGroupC(val: integer): integer;


    procedure setList(list: TList; node: TNSNodeType); overload;
    procedure setList(list: TList; node: TNSNodeType; parnode: TNSNodeType); overload;
    procedure Refresh;
    // function setTypeGroup(val: integer): integer;
    function Save(): string;
    constructor Create(Source: TObject; source1: TObject; le: TValueListEditor;
      button: TControl);
    destructor Destroy;
  end;

function isSystemGroup(val: string): TNSNodeType;
function gettype(app: string; topic: string; Name: string): TNSNodeType;
function getGroupIndex(val: TNSNodeType): integer;
function getNodeTypebyIndex(val: integer): TNSNodeType;
function getItemTypeIndex(val: PTAnalogMem): integer;

function getNameGrByIndex(node: TNSNodeType): string;


implementation




function isSystemGroup(val: string): TNSNodeType;
begin
  Result := ntOBase;
  if trim(uppercase(val)) = '$SYSVAR' then
    Result := ntOSysVar;
  if trim(uppercase(val)) = '$SYSTEM' then
    Result := ntOSystem;
  if trim(uppercase(val)) = '$REPORT' then
    Result := ntOReport;
  if trim(uppercase(val)) = '$REPORTCOUNT' then
    Result := ntOReportCnt;
  if trim(uppercase(val)) = '$SERVERCOUNT' then
    Result := ntOServCount;
  if trim(uppercase(val)) = '$COMMANDSCASE' then
    Result := ntComands;
  if trim(uppercase(val)) = '$POINTER' then
    Result := ntOPoint;
  // if pos('$ССЫЛОЧНАЯ',trim(uppercase(val)))=1 then result:=ntOPoint;
end;



function gettype(app: string; topic: string; Name: string): TNSNodeType;
var
  app_temp: string;
  topic_temp: string;
begin
  Result := ntOBase;
  app_temp := trim(uppercase(app));
  topic_temp := trim(uppercase(topic));

  if isSystemGroup(trim(uppercase(Name))) <> ntOBase then
  begin
    Result := isSystemGroup(trim(uppercase(Name)));
    exit;
  end;

  if (pos('\\', app_temp) = 1) then
  begin
    Result := ntOnet;
  end;

  if (pos('MYPLCDIRECTSERVER', app_temp) = 1) then
  begin
    Result := ntOSimple;

  end;

  if (pos('DIRECTKOYOSERV', app_temp) = 1) then
  begin
    Result := ntODKoy;
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

  if (pos('LOGIKASERV', app_temp) = 1) then
  begin

    begin
      if (pos('COM', topic_temp) = 1) then
      begin
        Result := ntOLogika;
        exit;
      end;

    end;
  end;


  if (pos('SETSERV', app_temp) = 1) then
  begin

    begin
      if (pos('COM', topic_temp) = 1) then
      begin
        Result := ntOSET;
        exit;
      end;

    end;
  end;

  if (pos('OPC_HDA[', app_temp) = 1) then
  begin
    Result := ntOOPCHDA;
    exit;
  end;
  if (pos('OPC[', app_temp) = 1) then
  begin
    Result := ntOOPC;
    exit;
  end;
  if (pos('DDE[', app_temp) = 1) then
  begin
    Result := ntODDE;
    exit;
  end;
end;

function getGroupIndex(val: TNSNodeType): integer;
begin
  case val of
    ntOEthKoy: Result := 3;
    ntOnet: Result := 7;
    ntOOPCHDA: Result := 6;
    ntODDE: Result := 5;
    ntOOPC: Result := 4;
    ntODKoy: Result := 2;
    ntOSimple: Result := 1;
    else
      Result := 0;
  end;
  if not (val in ntOl) then
    Result := -1;
end;

function getNodeTypebyIndex(val: integer): TNSNodeType;
begin
  case val of

    7: Result := ntOnet;
    6: Result := ntOOPCHDA;
    5: Result := ntODDE;
    4: Result := ntOOPC;
    3: Result := ntOEthKoy;
    2: Result := ntODKoy;
    1: Result := ntOSimple;
    0: Result := ntOBase;
    else
      Result := ntO;
  end;

end;


function getItemTypeIndex(val: PTAnalogMem): integer;
var
  typ: integer;
begin
  Result := integer(ntOT);
  if val = nil then
    exit;
  typ := val.logTime;
  case typ of
    TYPE_DISCRET: Result := integer(ntTDiskr);
    // дискретный параметер
    TYPE_INTEGER: Result := integer(ntInt);
    //32 аналоговый целочисленный
    TYPE_DOUBLE: Result := integer(ntReal);
    //32 аналоговый плавающая точка
    TYPE_LONGWORD: Result := integer(ntLongW);
    //32 аналоговый целочисленный без знака
    TYPE_SMALLINT: Result := integer(ntSmallI);
    //16 аналоговый целочисленный
    TYPE_WORD: Result := integer(ntWord);
    //16 аналоговый целочисленный без знака
    TYPE_SHORTINT: Result := integer(ntTShortI);
    //8 аналоговый целочисленный
    TYPE_BYTE: Result := integer(ntTByte);
    //8 аналоговый целочисленный без знака

    TYPE_CHAR: Result := integer(ntChar);
    //однобитный строковой
    TYPE_TEXT: Result := integer(ntText);                    // двубитный строковой

    TYPE_SINGLE: Result := integer(ntSing);
    //4 аналоговый целочисленный без знака
    TYPE_REAL48: Result := integer(ntReal48);
    //6 аналоговый целочисленный без знака

    REPORTTYPE_YEAR: Result := integer(ntRepY);
    REPORTTYPE_QVART: Result := integer(ntRepQart);
    REPORTTYPE_MONTH: Result := integer(ntRepM);
    REPORTTYPE_DEC: Result := integer(ntRepDec);
    REPORTTYPE_DAY: Result := integer(ntRepD);
    REPORTTYPE_HOUR: Result := integer(ntRepH);
    REPORTTYPE_30MIN: Result := integer(ntRep30Min);
    REPORTTYPE_10MIN: Result := integer(ntRep10Min);
    REPORTTYPE_MIN: Result := integer(ntRepMin);

    TYPE_DT: Result := integer(ntDT);


    EVENT_TYPE_WITHTIME: Result := integer(ntEvent);
    // для событий с временной пометкой, Logtime=-999
    EVENT_TYPE_ALARM: Result := integer(ntAnEvent);
    // для событий с временной пометкой т аналоговым значением, Logtime=-850
    EVENT_TYPE_OSC: Result := integer(ntOsc);              // события осцилографа
  end;
end;

function getNameGrByIndex(node: TNSNodeType): string;
begin
  case node of
    ntOOPCHDA: Result := 'OPCHDA';
    ntODDE: Result := 'DDE';
    ntOOPC: Result := 'OPC';
    ntODKoy: Result := 'DirectNET';
    //  ntOSimple: result:='DirectSoft(старые сервера)';
    ntOBase: Result := '';
    ntOnet: Result := 'Сетевой обмен';
    //   ntOEthKoy: result:='DirectSoft Ethernet';
    ntOSysVar: Result := '$SysVar';
    ntOServCount: Result := '$ServerCount';
    ntComands: Result := '$CommandsCase';
    ntOPoint: Result := '$ServerCount';
    ntOReport: Result := '$Report';
    ntOReportCnt: Result := '$ReportCount';
    ntOLogika: Result := 'Logika';
    ntOSET: Result := 'SET';
    else
      Result := '';
  end;
end;

constructor TItemCoordinator.Create(Source: TObject; source1: TObject;
  le: TValueListEditor; button: TControl);
begin
  control := button;
  editor := le;
  wrap_it := TRTItemWraper.Create(TanalogMems(Source), le);
  wrap_itHDA := THDAItemWraper.Create(TanalogMems(Source), le);
  wrap_itAlarm := TAlarmItemWraper.Create(TanalogMems(Source), le);
  wrap_itArchive := TArchiveItemWraper.Create(TanalogMems(Source), le);
  wrap_itEvent := TEventWraper.Create(TanalogMems(Source), le);
  ;
  wrap_itOPC := TOPCItemWraper.Create(TanalogMems(Source), le);
  wrap_itSysVar := TSysVarItemWrap.Create(TanalogMems(Source), le);
  ;
  wrap_itReport := TReportItemWraper.Create(TanalogMems(Source), le);
  wrap_itReportCnt := TReportItemWraper.Create(TanalogMems(Source), le);
  wrap_itLogika := TLogikaItemWrap.Create(TanalogMems(Source), le);

  Wrap_gr := TGroupWraper.Create(TGroups(source1), le);
  wrap_grOPC := TOPCGroupWraper.Create(TGroups(source1), le);
  wrap_grHDA := THDAGroupWraper.Create(TGroups(source1), le);
  wrap_grKoyo := TKoyoServGroup.Create(TGroups(source1), le);
  wrap_grDDE := TDDEGroupWraper.Create(TGroups(source1), le);
  wrap_old := TOldGroupWraper.Create(TGroups(source1), le);
  wrap_net := TSocketWraper.Create(TGroups(source1), le);
  wrap_grEthKoyo := TKoyoEthServGroup.Create(TGroups(source1), le);
  wrap_grSys := TSysGroupWrap.Create(TGroups(source1), le);
  ;
  wrap_grArh := TArchGroupWrap.Create(TGroups(source1), le);
  ;
  ;
  wrap_grPointer := TPointerGroupWrap.Create(TGroups(source1), le);
  wrap_grLogika := TLogikaServGroup.Create(TGroups(source1), le);
  wrap_grSET := TSETServGroup.Create(TGroups(source1), le);
  wrap_grKoyos := TKoyoServGroups.Create(TGroups(source1), le);

  wrap_cfg := TProjectpropItWrap.Create('', le);
  ;

  wrap_meta := TMetaWraper.Create(nil, le);

  rtgroup := TGroups(source1);
  rtit := TanalogMems(Source);
  nodetype := ntO;
  changegroup := False;
end;

procedure TItemCoordinator.resetsetgroup(val: TGroups);
begin
  rtgroup := TGroups(val);
end;


destructor TItemCoordinator.Destroy;
begin

end;

function TItemCoordinator.getTypeGroup(node: TNSNodeType): TItemWraper;
begin
  case node of
    ntOOPCHDA: Result := wrap_grHDA;
    ntODDE: Result := wrap_grDDE;
    ntOOPC: Result := wrap_grOPC;
    ntODKoy:   {result:=wrap_grKoyo;}Result := wrap_grKoyos;
    ntOSimple: Result := wrap_old;
    ntOBase: Result := wrap_gr;
    ntOnet: Result := wrap_net;
    ntOEthKoy: {result:=wrap_grEthKoyo;} Result := wrap_grKoyos;
    ntOSysVar: Result := wrap_grSys;
    ntOServCount: Result := wrap_grSys;
    ntComands: Result := wrap_grSys;
    ntOPoint: Result := wrap_grSys;
    ntOLogika: Result := wrap_grLogika;
    ntOSET: Result := wrap_grSET;
    ntOReport: Result := wrap_grArh;
    ntOReportCnt: Result := wrap_grArh;
    else
      Result := wrap_gr;
  end;
end;

function TItemCoordinator.getTypeItem(node: TNSNodeType): TItemWraper;
begin
  case node of
    ntOOPCHDA: Result := wrap_itHDA;
    ntGl: Result := wrap_itAlarm;
    ntA: Result := wrap_itArchive;
    ntS: Result := wrap_itEvent;
    ntOOPC: Result := wrap_itOPC;
    ntODDE: Result := wrap_itOPC;
    ntOSysVar: Result := wrap_itSysVar;
    ntOReport: Result := wrap_itReport;
    ntOLogika: Result := wrap_itReport;
    ntOSET: Result := wrap_itReport;
      // ntOSimple: result:=wrap_old;
      // ntOBase:   result:=wrap_gr;
      // ntOnet:   result:=wrap_net;
    else
      Result := wrap_it;

  end;

end;


function TItemCoordinator.setTypeGroups(node_: integer): integer;
var
  i: integer;
  node: TNSNodeType;
begin
  node := TNSNodeType(node_);
  if (node <> nodetype) then
  begin
    if ((node in ntOl)) then
    begin
      nodetype := node;
      oldWraper := itemwraper;
      Result := integer(node);
      itemwraper := getTypeGroup(node);
      itemwraper.idscount := oldWraper.idscount;
      setLength(itemwraper.ids, oldWraper.idscount);
      for i := 0 to oldWraper.idscount - 1 do
      begin
        itemwraper.ids[i] := oldWraper.ids[i];
      end;
      changegroup := True;
      itemwraper.setMap;
      itemwraper.setControl(control);
      itemwraper.setEnabled(oldWraper <> itemwraper);
      editor.Enabled := (oldWraper = itemwraper);

    end;
  end;
end;

function TItemCoordinator.setTypeGroupC(val: integer): integer;
var
  i: integer;
  node: TNSNodeType;
begin
  node := getNodeTypebyIndex(val);
  Result := setTypeGroups(integer(node));
end;

procedure TItemCoordinator.setList(list: TList; node: TNSNodeType);
var
  grnum: integer;
  grapp: string;
begin
  setList(list, node, TNSNodeType(0));
end;


procedure TItemCoordinator.setList(list: TList; node: TNSNodeType;
  parnode: TNSNodeType);
var
  grnum: integer;
  grapp: string;
begin
  editor.OnEditButtonClick := nil;
  editor.Color := clWhite;
  editor.Enabled := True;
  oldWraper := nil;
  nodetype := node;
  changegroup := False;
  if (node in tegSet) then
  begin
    itemwraper := getTypeItem(parnode);
    if node in ntArch then
      itemwraper := wrap_itHDA;
    if ((parnode = ntOLogika) or (parnode = ntOSET)) and not
      (node in ntArch) then
      itemwraper := wrap_it;
    itemwraper.setList(list);
  end;
  if (node in ntOl) then
    itemwraper := getTypeGroup(node);
  if (node = prjProp) then
    itemwraper := wrap_cfg;
  if (node in ntMeta) then
    itemwraper := wrap_meta;

  itemwraper.setList(list);
  itemwraper.setControl(control);
end;

procedure TItemCoordinator.Refresh;
begin
  itemwraper.setMap();
end;


function TItemCoordinator.Save(): string;
begin
  Result := '';
  if changegroup then
  begin
    changegroup := False;
    itemwraper.setType;
    itemwraper.writetofile;
    itemwraper.setMap();
    editor.Color := clWhite;
    editor.Enabled := True;
  end
  else
    Result := itemwraper.save;

end;




end.
 
