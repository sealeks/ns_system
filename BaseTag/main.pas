{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, Mask, ExtCtrls, MemStructsU, GroupsU,
  Math, StrUtils, ToolWin, FloatEdits, ImgList, idGlobal,
  constDef, calcU1,   ItemCoordinator, ConfigurationSys,
  SelectAppFormU, ViewDSDoc, ConvFunc, FrmDfltNewU, frmEditCSVU,
  frmGrpNewU, FrmGrpDblU, Grids, ColorStringGrid, globalValue,ItemAdapterU,
  DB, DBTables, ADODB,  ValEdit, Buttons, DBManagerFactoryU, MainDataModuleU,
  xmldom, XMLIntf, msxmldom, XMLDoc,FormMetaSelectU, WinSock, UpdateTrDfU;
{$R *.res}

const
  crDragAdd = 5;
  //количество основных групп,при прибавлении к группе полуаем подгруппу .
  MainGroupCount = 6;
  clMultyDif: TColor = (230 shl 8 + 230) shl 8 + 230;

const
  PRJ_MAIN =0;
  PRJ_TREE =1;
  PRJ_SOME =2;
  PRJ_MAINOLD =3;

  PRJ_SOMEOLD =4;


type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    TreeView1: TTreeView;
    Splitter1: TSplitter;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    N3: TMenuItem;
    NewProj: TMenuItem;
    ttt1: TMenuItem;
    PanelItem: TPanel;
    ToolBar: TToolBar;
    bNew: TToolButton;
    bDelete: TToolButton;
    bSave: TToolButton;
    ToolButton10: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    PanelDown: TPanel;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    ImageList2: TImageList;
    N8: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    Cjhfybnlthtdj1: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N15: TMenuItem;
    TrendCon: TADOConnection;
    Trend: TADOQuery;
    ValueListItem: TValueListEditor;
    PopupMenu2: TPopupMenu;
    N16: TMenuItem;
    DirectSoft1: TMenuItem;
    DirectSoft2: TMenuItem;
    OPC1: TMenuItem;
    DDE1: TMenuItem;
    OPCHDA1: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    renddef1: TMenuItem;
    N22: TMenuItem;
    bLeft: TToolButton;
    bRight: TToolButton;
    N23: TMenuItem;
    N24: TMenuItem;
    PanelActive: TPanel;
    PanelProject: TPanel;
    TreeViewProject: TTreeView;
    ImageListPrj: TImageList;
    Splitter2: TSplitter;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    Butts: TToolButton;
    ValueListPrj: TValueListEditor;
    PopupMenuPrj: TPopupMenu;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    csv1: TMenuItem;
    N5: TMenuItem;
    N13: TMenuItem;
    N40: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    DirectSoftCOM2: TMenuItem;
    OPC3: TMenuItem;
    DDE3: TMenuItem;
    OPCHDA3: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    SysVar2: TMenuItem;
    System2: TMenuItem;
    Report2: TMenuItem;
    Pointer2: TMenuItem;
    ServerCount2: TMenuItem;
    N38: TMenuItem;
    DirectSoftCOM1: TMenuItem;
    OPC2: TMenuItem;
    DDE2: TMenuItem;
    OPCHDA2: TMenuItem;
    N39: TMenuItem;
    N1: TMenuItem;
    PanelGr: TPanel;
    LabelGr: TLabel;
    Logika1: TMenuItem;
    Logika2: TMenuItem;
    XMLMeta: TXMLDocument;
    NRepRoot: TMenuItem;
    N2: TMenuItem;
    NnewRepTag: TMenuItem;
    N14: TMenuItem;
    N19: TMenuItem;
    NnewTrendTag: TMenuItem;
    N21: TMenuItem;
    N37: TMenuItem;
    NnewMessTag: TMenuItem;
    ImageList3: TImageList;
    Ndown: TMenuItem;
    NUp: TMenuItem;
    Trenddef2: TMenuItem;
    N9: TMenuItem;
    CommandsCase1: TMenuItem;
    Xml1: TMenuItem;
    SaveDialogXml: TSaveDialog;
    XMLDocumentExport: TXMLDocument;
    ImporttoXml1: TMenuItem;
    ReportCount1: TMenuItem;

    procedure setpanel(key: integer);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TreeView2Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure refreshNode(node: TTreeNode; firstTime: boolean = false);
    procedure refreshNodeName(nodeName: string);
    procedure refreshNodeNameandtype(nodeName: string; ntype: TNSNodeSet);
    procedure refreshtree;
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ChangeTreeMenuGroup();
    //***********************************************************************
    procedure TegChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShowTagItem(num: longInt; parent: TNSNodeSet);
    procedure addnewitem(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Edit1Changed(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure setbutNav;
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure PLCDirect2Click(Sender: TObject);
    procedure csv3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure ComboGroupChange(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure setcaption(path: string);
    procedure ChangeOGroup(Sender: TObject);
    procedure TreeTagOutofGroup();
    procedure TreeAlTagOutofAlarmGroup();
    procedure TreeOutofAlarmGroup(Node: TTreeNode);
    procedure ChangeTreeMenuAlarmGroup();
    procedure ChangeOAlarmGroup(Sender: TObject);
    function AddRTitems(num: integer;name,comment, ddeitem, onmsg, ofmsg,alarmmsg, eu:  string; newitem: TAnalogMem; save: boolean; var replaceAll: boolean  ): boolean;
    procedure N21Click(Sender: TObject);
    procedure renddef1Click(Sender: TObject);
    procedure CleareClick(Sender: TObject);
    procedure bLeftClick(Sender: TObject);
    procedure bRightClick(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure TreeViewProjectChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure TreeViewProjectMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N25Click(Sender: TObject);
    procedure PopupMenuPrjPopup(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure NewProjClick(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ChangeGroupType(Sender: TObject);
    procedure SystenGroupCreate(Sender: TObject);
    procedure CreateNewO(Sender: TObject);
    procedure NMetaGrClick(Sender: TObject);
    procedure NnewRepTagClick(Sender: TObject);
    procedure NUpDownClick(Sender: TObject);
    procedure Trenddef2Click(Sender: TObject);
    procedure Xml1Click(Sender: TObject);
  private
    { Private declarations }
    fisChanged: boolean;
    fmultyEditMode: boolean;

    MultyEditList: TList;
    filter: string;
    finit: boolean;
    PtojMen: boolean;
    curProj: TTReenode;
    someProj: TTReenode;
    fWorkwithMem: boolean;
    function getMetaObject: TObject;
  //  function checkLock: boolean;
    procedure Setcontrol;
    procedure ititial;
    procedure unititial;
    function  getInit: boolean;
    procedure setInit(val: boolean);
    function  getTAGItems: TanalogMems;
    procedure UpdateItemName(oldName, newName: string);
    procedure UpdateItem(Name: string);
    procedure SaveNode(NodeName, fileName: string);
    procedure LoadNode(NodeName, fileName: string);
    procedure SeTNSNodeType(NodeName: string; NodeType, TegType: TNSNodeType);
    procedure SeTNSNodeTypeRec(Node: TTreeNode; NodeType, TegType: TNSNodeType);
    procedure copyNode(dest:TTreeView; parent, Node: TTreeNode);
    function HasAlarms(fromPriority, toPriority: integer): boolean;
    function HasLog: boolean;
    function HasEvents: boolean;
    function HasAnalog(GroupNum: integer): boolean;
    function HasDiscret(GroupNum: integer): boolean;
    function HasAlarmGroupItems(GroupNum: integer): boolean;
    function HasChildGG(GroupName: string): boolean;
    function GetDraggedType(source: TObject): TNSNodeSet;
    function IsDraggedMove(source: TObject; DestItem: TTreeNode): boolean;
    procedure FillDraggedList(source: TObject; list: TList);
    procedure SetIsChanged(const Value: boolean);
    procedure SetMultyEditMode(const Value: boolean);
    procedure SaveListToFile(SavedItems:TList);
    function TreeViewFindNode(tree: TTreeView; str: string): TTreeNode;
    procedure Refresh(Node: TTreeNode);
    {Работа с группами опроса}
    procedure CreateNewGroup(GroupName: string = '');
    procedure CreateNewAlarmGroup(GroupName: string = '');
    procedure ShowGroups(fn: string);

    procedure DublicateGroup();
    procedure TreeOutofGroup(Node: TTreeNode);
    procedure exportGroup(GroupName: string = '');//по умолчанию экспортировать все группы
    procedure LoadRegestry;
    procedure LoadMetadata(root: TTreeNode);
    procedure CreateMetadata;
    procedure SaveMetadata;
    procedure AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string; header: boolean=true);
    function getTrdef: TTrenddefList;
    procedure addExportXMLgroup(gr: IXMLNode);
    procedure addExportXMLrtitems(gr: IXMLNode);
  public
    { Public declarations }
     //Все что ниже,

    curItem: longint;
    enableAlarmDefinition: boolean;
    itemcoord: TItemCoordinator;
    projcoord: TItemCoordinator;
    changeGrMI: TMenuItem;
    FMetaSelect: TFormMetaSelect;
    property isChanged: boolean read fisChanged write SetIsChanged;
    property multyEditMode: boolean read fmultyEditMode write SetMultyEditMode;
    property WorkwithMem: boolean read fWorkwithMem write fWorkwithMem; 
    function deleteTeg(TegName: string): integer;
//    procedure WriteTrenddef;
    procedure ShowItembyName(Name : string);
    function FindLesses: integer;
    function FindBiggest: integer;
    function FindNextLess(var curIt: integer): boolean;  //curIt изменяется, если найдено
    function FindNextMore(var curIt: integer): boolean;  //curIt изменяется, если найдено
    function GetStartAddr(typeMod:string): string;
    function ShiftAddr(typeMod, Item: string; shiftWord: integer): string;
    function DefDflt(var dfltBCD, dfltAlarmedLocal: boolean;
                           var dfltGroup, dfltAlCase: string;
                           var dfltAlLevel: integer;
                           var dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst: real; var dfltLogtime): TModalResult;
    procedure SaveAlarmsGroups;
    property  TAGItems: TanalogMems read getTAGItems;
    property  Init: boolean read  getInit  write setInit;
  end;

  TControlHack = class(TControl);


 function strtofloat_(val: string): double;
var
    Form1: TForm1;
    RightClickedItem,RightClickedItemPrj: TTreeNode;
    ListedItem: TTreeNode;
    rtItems: TanalogMems;
    TRENDLIST_GLOBAL_TRDF: TTrenddefList;
    var test: integer;
implementation


function strtofloat_(val: string): double;
begin
try
  result:=strtofloat(val);
except
    val:=AnsiReplaceStr(val,'.',',');
    result:=strtofloat(val);
end;
end;

{$R *.dfm}



function TForm1.getInit: boolean;
begin
     result:=finit;
end;

procedure TForm1.setInit(val: boolean);
begin
  if (finit<>val) then
   begin
    if val then
      begin
      ititial;
      if TAGItems<>nil then
      begin
      finit:=true;

      end;
      end
    else
      begin
       finit:=false;
       Unititial;
       if TAGItems=nil then
      // PanelActive.Visible:=false;
      // PanelProject.Visible:= not PanelActive.Visible;
      end;
   end;

   setcontrol;
end;

function TForm1.getTAGItems: TanalogMems;
begin
   result:=rtitems;
end;

procedure TForm1.ititial;
begin
 //  if groups<>nil then Freeandnil(groups);
   if rtItems<>nil then Freeandnil(rtItems);
   try
    if CheckVer(GetCurrentApp)=CONFFILE_V1 then
    begin
      MessageBox(0,PChar('Текущий проект принадлежит старой версии!  '+ char(13)+
               'Произведите преобразование в менеджере поектов!'),'Сообщение',
                 MB_OK+MB_TOPMOST+MB_ICONWARNING);
      finit:=true;
      init:=false;
      LoadRegestry;
      exit;
    end;

    if CheckVer(GetCurrentApp)=CONFFILE_NE then
    begin

      finit:=true;
      init:=false;
      LoadRegestry;
      exit;
    end;

    setcaption(GetCurrentApp);
    rtItems := TanalogMems.Create(PathMem);
 //   groups := TGroups.Create(PathMem + 'groups.cfg');
    //AlarmGroups := TGroups.Create(PathMem + 'alarmGroups.cfg');

  except



      MessageBox(0,PChar('Фатальная ошибка при открытии проекта!  '+ char(13)+
               'Файлы проекта повреждены!'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
     //  groups:=nil;
       finit:=true;
       init:=false;
       LoadRegestry;
       exit;



  end;
    Refresh(nil);
    panelItem.Visible := false;

  //  MultyEditList := TList.Create;
    itemcoord:=TItemCoordinator.create(rtitems,rtitems.TegGroups,ValueListItem,bSave);
    Screen.Cursors[crDragAdd] := LoadCursor(HInstance, 'CURSORDRAGADD');
    cursor := crDragAdd;


end;




procedure TForm1.Unititial;
 var i: integer;
begin
  if XMLMeta.Active then
   begin
    SaveMetadata;
    XMLMeta.Active:=false;
   end;

  if rtItems<>nil then
    begin
     rtItems.WriteToFileAll();
     for i:=0 to rtItems.TegGroups.Count-1 do
       if (isSystemGroup(rtItems.TegGroups.Items[i].Name)<>ntOBase) then
         begin
            rtItems.TegGroups.Items[i].App:='';
            rtItems.TegGroups.Items[i].Topic:='';
         end;
    end;
//  test:=SizeOf(TMsgType);
 // if groups<>nil then Freeandnil(groups);
  if rtItems<>nil then Freeandnil(rtItems);
 // if groups<>nil then
 // begin
  //saveNode('Тревоги группы', PathMem + 'AlarmGroupsStruct.cfg');
 // saveNode('Архив группы', PathMem + 'TrendGroupsStruct.cfg');
 // end;

  TreeView1.Items.Clear;
  ListView1.Items.Clear;
  itemcoord.Free;
 // ChangedList.Free;
 // MultyEditList.Free;
 // groups:=nil;
  rtItems:=nil;
  cursor := crDefault;

end;

procedure TForm1.LoadRegestry;
var TStr: TStrings;
    temp: TTReenode;
    i: integer;
    tempb: boolean;
begin
tempb:=false;
someProj:=nil;
curProj:=nil;
TreeViewProject.Items.Clear;
if (CheckVer(GetCurrentApp)<>CONFFILE_NE) then
  begin
  curProj:=TreeViewProject.Items.AddChild(nil,'Текущий проект');
  if (CheckVer(GetCurrentApp)=CONFFILE_V1) then
       curProj.ImageIndex:= PRJ_MAINOLD else
          curProj.ImageIndex:= PRJ_MAIN;
  end;

TStr:=ConfigurationSys.getAppList();
if ((TStr<>nil) and (TStr.Count>-1)) then
begin
 someProj:=TreeViewProject.Items.AddChild(nil,'Проекты');
 someProj.ImageIndex:= PRJ_TREE;
 someProj.Expand(true);
 //
 for i:=0 to TStr.Count-1 do
 begin
  try
   if ((CheckVer(TStr.Strings[i])=CONFFILE_V1) or (CheckVer(TStr.Strings[i])=CONFFILE_V2)) then
   begin
   temp:=TreeViewProject.Items.AddChild(someProj,TStr.Strings[i]);
   if CheckVer(TStr.Strings[i])=CONFFILE_V1 then
       temp.ImageIndex:= PRJ_SOMEOLD else
          temp.ImageIndex:= PRJ_SOME;
   end;
  except
  end;
  butts.Enabled:=false;
end;
if someProj<>nil then someProj.Expand(true);

//if curProj<>nil then
//   TreeViewProject.Select(curProj)
 //else
 // if someProj<>nil then
 //    TreeViewProject.Select(someProj);

if TStr<>nil then TStr.Free;
PtojMen:=true;
setcaption('Менеджер проектов');
setcontrol;

end;
end;


procedure TForm1.Edit1changed(Sender: TObject);
var
  MyTreeNode1, MyTreeNode2: TTreeNode;
begin
  with TreeView1.Items do
  begin
    Clear; { remove any existing nodes }
    MyTreeNode1 := Add(nil, 'RootTreeNode1'); { Add a root node }
    { Add a child node to the node just added }
    AddChild(MyTreeNode1,'ChildNode1');

    {Add another root node}
    MyTreeNode2 := Add(MyTreeNode1, 'RootTreeNode2');
    {Give MyTreeNode2 to a child }
    AddChild(MyTreeNode2,'ChildNode2');

    {Change MyTreeNode2 to ChildNode2 }
    { and add a child node to it}
    MyTreeNode2 := TreeView1.Items[3];
    AddChild(MyTreeNode2,'ChildNode2a');

    {Add another child to ChildNode2, after ChildNode2a }
    Add(MyTreeNode2,'ChildNode2b');

    {add another root node}
    Add(MyTreeNode1, 'RootTreeNode3');
  end;

end;

procedure TForm1.TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbRight then
  begin
    RightClickedItem := TreeView1.GetNodeAt(X, Y);
  end;

end;

procedure TForm1.N1Click(Sender: TObject);
//новый узел
var
  i: integer;
  str: string;
  nt: TNSNodeType;
  NewNode: TTreeNode;
begin
    with TreeView1.Items do
    begin
      i:=1;
      str:='AlarmGroup1';
            while(rtitems.AlarmGroups.ItemNum[str]<>-1) do
              begin
                 inc(i);
                 str:='AlarmGroup'+inttostr(i);
              end;

      if InputQuery('Ввод пользователя','Имя узла',Str) then
      begin
         if rtitems.AlarmGroups.itemNum[str] <> -1 then
                   raise Exception.Create('Группа уже существует.');
        if RightClickedItem <> nil then nt :=TNSNodeType(RightClickedItem.ImageIndex)
        else nt := ntGG;
        case nt of
          ntO:
          begin
            CreateNewGroup(str);
            exit;
          end;
          ntG:
            begin
              //добавить в группу алармов новый
              rtitems.alarmGroups.Add(str, RightClickedItem.Text, '');
              NewNode:= self.TreeView1.Items.AddChild(RightClickedItem,str);;
              NewNode.ImageIndex:=integer(ntGl);
              exit;
            end;
        end;
        //если все прошло успешно, добавляет в дерево
        NewNode := AddChildFirst(RightClickedItem,Str);
        with NewNode do
        begin
          //если создаем узел внутри главного, то получаем подчиненного
          //а если внутри подчиненного, то подчиненного и получаем
          if RightClickedItem <> nil then
            ImageIndex := RightClickedItem.ImageIndex +
                ifThen(TNSNodeType(RightClickedItem.ImageIndex) in NodeBaseSet, MainGroupCount, 0)
          else ImageIndex := integer(ntGG);
        end;
        refreshNode(newNode, true);
      end;
    end;
end;

{$WARNINGS OFF}
procedure TForm1.N2Click(Sender: TObject);
var
  list: tList;
  i: integer;
  parentName: string;
  parentX: IXMLNode;
begin
  if MessageDlg('Удалить выбранные элементы?', mtWarning, [mbYes, mbNo], 0) = mrYes then
    try
      list := Tlist.Create;
      TreeView1.GetSelections(List);
      for i:= 0 to list.count - 1 do
      begin
        if (TNSNodeType(TTreeNode(list.Items[i]).ImageIndex) in ntOl) then
        rtitems.TegGroups.deleteGroup(TTreeNode(list.Items[i]).text);

        case TNSNodeType(TTreeNode(list.Items[i]).ImageIndex) of
          ntOT:  deleteTeg(TTreeNode(list.Items[i]).text);
       //   ntOl: Groups.deleteGroup(TTreeNode(list.Items[i]).text);
          ntAt:
            //смотрим папаню, если просто архив (ntA), то удаляем из архивации
            if TTreeNode(list.Items[i]).Parent <> nil then
              if TNSNodeType(TTreeNode(list.Items[i]).Parent.ImageIndex) = ntA then
                if rtItems.GetSimpleID(TTreeNode(list.Items[i]).text) <> -1 then
                  rtItems[rtItems.GetSimpleID(TTreeNode(list.Items[i]).text)].logged := false;
          ntGl:
          begin
            rtitems.AlarmGroups.deleteGroup(TTreeNode(list.Items[i]).text);


          end;


          
        end;

        if (TNSNodeType(TTreeNode(list.Items[i]).ImageIndex) in ntMeta)  then
           begin

              if assigned(IXMLNode(TTreeNode(list.Items[i]).Data)) then
                begin
                parentX:=IXMLNode(TTreeNode(list.Items[i]).Data).ParentNode;
                parentX.ChildNodes.Remove(IXMLNode(TTreeNode(list.Items[i]).Data));

                end;
           end;

        TTreeNode(list.Items[i]).Delete;
      end;
    finally
      List.Free;
    end;
end;
{$WARNINGS ON}

procedure TForm1.TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var

  dest, saveDest: TTreeNode;
  HT: THitTests;
  list: tList;
  i, j: integer;
  AttachMode: TNodeAttachMode;
  sourceTypeSet: TNSNodeSet;
  dragList: tList;
  id, GroupNum: integer;
  dragMove: boolean;
  cursor: TCursor;

begin
  dest := TreeView1.GetNodeAt(X, Y);

  //можем перетаскивать из 2 источников, для унификации делаем общий список

  sourceTypeSet := GetDraggedType(source);
    draglist := tList.Create;

  //dragMove := IsDraggedMove(source, dest);
  dragMove := ((Source as TListView).dragcursor = crDrag);



  try
    FillDraggedList(source, dragList);
    //бросаем в группы тревог
    if (TNSNodeType(dest.ImageIndex) in ntOl) then
    begin

     GroupNum := rtitems.TegGroups.ItemNum[dest.Text];
    if groupNum <> -1 then
     for i:= 0 to dragList.Count - 1 do
     begin
       id := rtItems.GetSimpleID(TTreeNode(dragList[i]).text);
       rtItems[ID].GroupNum := GroupNum;
      end;

    end;
    case TNSNodeType(dest.ImageIndex) of

    ntGl, ntG:
      for i:= 0 to dragList.Count - 1 do
      //если это другая группа, то меняем ей родителя
        if rtitems.AlarmGroups.ItemNum[TTreeNode(dragList[i]).text] <> -1 then
        begin
          rtitems.AlarmGroups.Items[rtitems.AlarmGroups.Idx[TTreeNode(dragList[i]).text]].App := dest.Text;
          rtitems.AlarmGroups.SaveToFile(PathMem + 'alarmgroups.cfg');
        end
        else
          rtItems[rtItems.GetSimpleID(TTreeNode(dragList[i]).text)].AlarmGroup := rtitems.AlarmGroups.ItemNum[dest.Text];
    //бросаем в архив
    ntA:
      for i:= 0 to dragList.Count - 1 do
      begin
        id := rtItems.GetSimpleID(TTreeNode(dragList[i]).text);
        if not rtItems[ID].Logged then
        begin
          rtItems[ID].Logged := true;
          rtItems[ID].LogDB := (rtItems[ID].MaxEu - rtItems[ID].MinEu) / 200;
        end;
      end;
    //бросаем в тревоги
    ntT:
      for i:= 0 to dragList.Count - 1 do
      begin
        id := rtItems.GetSimpleID(TTreeNode(dragList[i]).text);
        if not rtItems[ID].Logged then
        begin
          rtItems[ID].AlarmedLocal := true;
          rtItems[i].alarmCase := alarmMore;
          rtItems[ID].AlarmConst := 0;
           rtItems[ID].Logtime := 0;
          rtItems[id].AlarmLevel := ifthen(dest.text = 'Неисправности', 400, 600);
          if rtItems.GetAlarmMsg(ID) <> '' then rtItems.SetAlarmMsg(ID, rtItems.GetComment(ID));
        end;
        dest.DeleteChildren;
        dest.HasChildren := true;
      end;


    end;

    savelistToFile(dragList);

    //только для групп опроса, проверяем тип тега
      SaveDest := dest;
      if (sender is TTreeView) and (TNSNodeType(dest.ImageIndex) in ntOL)then
        if (TTreeNode(dragList[0]).Parent.text = 'Аналоговые')  then dest := dest.Item[0]
        else
        if TTreeNode(dragList[0]).Parent.text = 'Дискретные' then dest := dest.Item[1];

      //поменяли свойства объектов, теперь комплектуем дерево
     //если перетаскиваем из соседнего списка, то и копируем от туда
      for i:= 0 to dragList.count - 1 do
          with(sender as TTreeView).Items.AddChild(dest, TTreeNode(dragList[i]).text) do
            if (TNSNodeType(dest.ImageIndex) = ntGG) or (TNSNodeType(dest.ImageIndex) = ntGGl) then
              ImageIndex := integer(ntGGl)
            else ImageIndex := TTreeNode(dragList[i]).ImageIndex;
   dest := saveDest;

  if source = ListView1 then
  begin
      for i:= ListView1.Items.count - 1 downto 0 do
        if ListView1.Items[i].Selected AND dragMove then ListView1.Items.Delete(i);
  end;

  //удаляем из дерева ненужное
  if dragMove then
    for i := 0 to dragList.Count - 1 do
      treeView1.Items.Delete(dragList[i]);


  finally
    dragList.Free;
  end;
end;

procedure TForm1.TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  DestItem: TTreeNode;
  SourceTypeSet: TNSNodeSet;
  ActionMove: boolean;
  CanCopy, CanMove: boolean;
  cursor: TCursor;

begin

  Accept := false;
  cANcOPY := FALSE;
  CanMove := false;
  cursor := crNoDrop;

  if ((source <> TreeView1) and (source <> ListView1)) or (Sender <> TreeView1) then
    exit;//драгият от неизвестного исочника или в неизвестный приемник
  DestItem := TreeView1.GetNodeAt(X, Y);
  //если пытаются бросить в пустоту или на тег, или в себя, не разрешать!!!
  if (DestItem = nil) or (TNSNodeType(DestItem.ImageIndex) in TegSet) or
    (DestItem = ListedItem) then exit;

  //определяем тип кидаемых элементов
  SourceTypeSet := GetDraggedType(source);

  //если нельзя ни переносить, ни копировать, то до свиданья
  if not(SourceTypeSet <= acceptCopyArray[TNSNodeType(DestItem.ImageIndex)]) and
        not(SourceTypeSet <= acceptMoveArray[TNSNodeType(DestItem.ImageIndex)]) then
          exit;
  //определяем, что хотим, тащить или копировать
  ActionMove := IsDraggedMove(source, DestItem);

  //если хотим копировать и разрешено копирование, то разрешено
  if (not ActionMove) and (SourceTypeSet <= acceptCopyArray[TNSNodeType(DestItem.ImageIndex)]) then
    cursor := crDragAdd;
  //а если хотим перемещать и разрешено переносить, то разрешено
  if (ActionMove) and (SourceTypeSet <= acceptMoveArray[TNSNodeType(DestItem.ImageIndex)]) then
    cursor := crDrag;
  //а если нельзя делать что хотим, делаем что можно
   if (cursor <> crDrag) and (cursor <> crDragAdd) then
    if (SourceTypeSet <= acceptCopyArray[TNSNodeType(DestItem.ImageIndex)]) then cursor := crDragAdd
    else if (SourceTypeSet <= acceptMoveArray[TNSNodeType(DestItem.ImageIndex)]) then cursor := crDrag;

   if (cursor = crDrag) or (cursor = crDragAdd) then
        begin
          Accept := true;
          if (Source is TListView) then
            (Source as TListView).DragCursor := crDragAdd;
          if (Source is TTreeView) then
            (Source as TTreeView).DragCursor := crDragAdd;
        end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fWorkwithMem:=false;
  CheckAndCreateMainKey();
  filter:='';
  PtojMen:=false;
  init:=true;
  projcoord:=TItemCoordinator.create(nil,nil,ValueListPrj,Butts);
  MultyEditList := TList.Create;
  FMetaSelect:=TFormMetaSelect.Create(self);
end;

procedure TForm1.refreshNode(node: TTreeNode;firstTime: boolean = false);
var
 i, j, k: integer;
  groupNum: integer;
  nodeExist: boolean;
  newNode: TTreeNode;
begin
  node.DeleteChildren;

  with TreeView1.Items do
  begin

  if (TNSNodeType(node.ImageIndex) in ntOl) then
    begin
      GroupNum := rtitems.TegGroups.ItemNum[node.Text];

      begin
         for i := 0 to rtItems.Count - 1 do
        if (rtItems[i].GroupNum = GroupNum) and
           (rtItems[i].ID <> -1) then
          with AddChild(node,rtItems.GetName(i)) do
            ImageIndex := getItemTypeIndex(rtItems.items[i])//integer(ntOT)
      end;
    end;

  case TNSNodeType(node.ImageIndex) of
  ntArc:
      begin
         for i := 0 to rtItems.Count - 1 do
        if (rtItems[i].ID <> -1) and (rtItems[i].logTime in REPORT_SET)
            then
          with AddChild(node,rtItems.GetName(i)) do
            ImageIndex := getItemTypeIndex(rtItems.items[i])
            end;
      end;


  case TNSNodeType(node.ImageIndex) of
  ntO:
    begin
      for i := 0 to rtitems.TegGroups.Count - 1 do
      begin
        NewNode := AddChild(Node,rtitems.TegGroups.Items[i].Name);
        newNode.Data:=rtitems.TegGroups.Items[i];
        NewNode.ImageIndex := integer(gettype(rtitems.TegGroups.Items[i].App,
           rtitems.TegGroups.Items[i].Topic,rtitems.TegGroups.Items[i].Name));//integer(ntOl);
        NewNode.hasChildren := true;
        refreshNode(NewNode, firstTime);
      end;
      TreeOutofGroup(node);
    end;

  ntOll: //подгруппы аналоговые и дискретные
    begin
      GroupNum := rtitems.TegGroups.ItemNum[node.Parent.Text];
      //node.DeleteChildren;
       for i := 0 to rtItems.Count - 1 do
        if (Node.Text = 'Аналоговые') and (rtItems[i].GroupNum = GroupNum) and
        (rtItems[i].ID <> -1) and (not rtItems.isDiscret(i))then
          with AddChild(node,rtItems.GetName(i)) do
            ImageIndex := integer(ntOT)
        else
        if (Node.Text = 'Дискретные') and (rtItems[i].GroupNum = GroupNum) and
        (rtItems[i].ID <> -1) and (rtItems.isDiscret(i))then
          with AddChild(Node,rtItems.GetName(i)) do
            ImageIndex := integer(ntOT);
    end;
  ntG:
     begin
      node.deleteChildren;
      for i := 0 to rtitems.Alarmgroups.Count - 1 do

        with AddChild(node,rtitems.AlarmGroups.Items[i].Name) do
        begin
          ImageIndex := integer(ntGl);
           hasChildren := HasAlarmGroupItems(rtitems.AlarmGroups.ItemNum[rtitems.AlarmGroups.Items[i].Name]);
        end;
      TreeAlTagOutofAlarmGroup;
      end;
  ntGl:
    begin
       for i := 0 to rtItems.Count - 1 do
        if (rtItems[i].AlarmGroup = rtitems.AlarmGroups.ItemNum[Node.Text]) and (rtItems[i].ID <> -1)then
          with AddChild(node,rtItems.GetName(i))do
            ImageIndex := integer(ntGT);

    end;
  ntT:
    begin
        with TreeView1.Items.AddChild(Node, 'Аварии') do
        begin
          HasChildren := HasAlarms(500, 999);
          ImageIndex := integer(ntTl);
        end;
        with TreeView1.Items.AddChild(Node, 'Неисправности') do
        begin
          HasChildren := HasAlarms(0, 499);
          ImageIndex := integer(ntTl);
        end;

    end;
  ntTl:
    begin
       for i := 0 to rtItems.Count - 1 do
        if rtItems[i].AlarmedLocal and (rtItems[i].ID <> -1)then
          if Node.Text = 'Неисправности' then
          begin
            if (0 <= rtItems[i].AlarmLevel) and (rtItems[i].AlarmLevel <= 499) then
              with TreeView1.Items.AddChild(Node, rtItems.GetName(i)) do
                ImageIndex := integer(ntTT);
          end
          else
            if (499 <= rtItems[i].AlarmLevel) and (rtItems[i].AlarmLevel <= 999) then
              with TreeView1.Items.AddChild(Node, rtItems.GetName(i)) do
                imageIndex := integer(ntTT);
    end;
  ntGG, ntGGl: ;
  ntA:
       for i := 0 to rtItems.Count - 1 do
        if rtItems[i].Logged and (rtItems[i].ID <> -1)then
          with AddChild(node,rtItems.GetName(i))do
            ImageIndex := integer(ntAT);
  ntS:
       for i := 0 to rtItems.Count - 1 do
        if (rtItems[i].OnMsged or rtItems[i].OffMsged) and (rtItems[i].ID <> -1)then
          with AddChild(node,rtItems.GetName(i))do
            ImageIndex := integer(ntSt);
  end;
  end;
  if not firstTime then
  //эта штука работает медленно и вообще виснит
  //надо бы выинуть, да жаль...
  begin
   treeView1.Items.BeginUpdate;
  //создали узел, теперь синхронизируем 2 узла
  //удаляем несуществующие
  //наверное нельзя удалять в цикле
  i := Node.Count-1;
   for k := 0 to i do
   begin
    nodeExist := false;
    for j := 0 to Node.Count-1 do
      if Node[k].Text = Node[j].Text then
      begin
        NodeExist := true;
        Node[j].Delete; //такой узел есть в списке
        break;
      end;
      if not NodeExist then Node[k].Delete;
   end;
   for j := 0 to Node.Count - 1 do
    with treeView1.Items.AddChild(node,Node[j].text)do
    begin
      ImageIndex := Node[j].ImageIndex;
      HasChildren := Node[j].HasChildren;
     end;
   treeView1.Items.EndUpdate;
   treeView1.Items.Delete(Node);
  end;

end;

procedure TForm1.TreeView2Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  with TreeView1.Items do
  if Node.HasChildren and (Node.Count = 0) then
    RefreshNode(Node, true);
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
// ветвь является ветвью опроса
function isTagGroup(Node: TTreeNode): integer;
var i: integer;
begin
  result:=-1;
  for i:=0 to rtitems.TegGroups.Count-1 do
    begin
      if (node.Data=rtitems.TegGroups.Items[i]) then
        begin
          result:=i;
          break;
        end;
    end;
end;
var
  i,k: integer;
  tempfl: boolean;
  temp: boolean;
  cnt: integer;
  list: Tlist;
  numGr: String;
  tempstr: Pstring;
begin
   if not finit then exit;

   listedItem := node;

   tempfl:=true;
   if TNSNodeType(Node.ImageIndex) in tegSet then
     begin
     tempfl:=false;
        for k:=0 to  TreeView1.SelectionCount-1  do
        begin
        if ((TNSNodeType(TreeView1.Selections[k].ImageIndex)<>
            TNSNodeType(Node.ImageIndex)) and not ((TNSNodeType(TreeView1.Selections[k].ImageIndex) in ntArch) and
            (TNSNodeType(Node.ImageIndex)  in ntArch ))) then
          begin

            tempfl:=true;
            break;
          end;
        end;
    end;


   // снимаем мульти режим если элементы
   //разных типов

   if (tempfl) then
     begin
     while  TreeView1.SelectionCount>0 do
     TreeView1.Deselect(TreeView1.Selections[0]);
     TreeView1.Select(Node);
   end;

   Panelgr.Visible:=(TNSNodeType(Node.ImageIndex) in ntOl);
   if Panelgr.Visible then
     LabelGr.Caption:=getNameGrByIndex(TNSNodeType(Node.ImageIndex)) ;

   TreeView2Expanding(self, Node,temp);

  cnt := node.Count;
  ListView1.AllocBy := cnt;

  // если выбрали установки проекта
  if (TNSNodeType(Node.ImageIndex)=prjProp) then
  begin
    panelItem.Visible := true;
    list:=Tlist.Create;
    new(tempstr);
    tempstr^:=GetCurrentApp;
    list.Add(tempstr);
    itemcoord.setList(list,TNSNodeType(Node.ImageIndex));
    itemcoord.refresh;
    setpanel(3);
    list.Free;
    exit;
  end
  else
  begin

  //  иначе ставим контролы
  if (getGroupIndex(TNSNodeType(Node.ImageIndex))>-1) then
     setpanel(2) else setpanel(1);
  end;

  // выбраны метаданные
  if (TNSNodeType(Node.ImageIndex) in ntMeta) then
    begin
      panelItem.Visible := true;
      list:=Tlist.Create;
      for i:=0 to treeView1.SelectionCount-1 do
      begin
      list.Add(treeView1.Selections[i].Data);
      IXMLNode(treeView1.Selections[i].Data).LocalName;
      end;
      itemcoord.setList(list,TNSNodeType(Node.ImageIndex),TNSNodeType(Node.Parent.ImageIndex));
      itemcoord.refresh;
      list.Free;
      exit;
    end;

  if (Node.ImageIndex>-1) and not (TNSNodeType(Node.ImageIndex) in tegSet) then
  begin
    if (isTagGroup(node)<>-1) then
    begin
      if (getGroupIndex(TNSNodeType(Node.ImageIndex))>-1) then
        begin
         // ComboGroup.ItemIndex:=getGroupIndex(TNSNodeType(Node.ImageIndex));
        end;
      panelItem.Visible := true;
      list:=Tlist.Create;
      numGr:=inttostr(isTagGroup(node));
      list.Add(@numGr);

      itemcoord.setList(list,TNSNodeType(Node.ImageIndex),TNSNodeType(Node.Parent.ImageIndex));
      itemcoord.refresh;
      list.Free;
    end
    else
    begin
    panelItem.Visible := false;
     ListView1.Items.Clear;
    self.ListView1.Visible:=true;
    progressBar1.Max := cnt;
    ListView1.Items.BeginUpdate;
    for i := 0 to cnt - 1 do
     begin

     with ListView1.Items.Add do
     begin
       caption := node[i].Text;
       ImageIndex := node[i].ImageIndex;
       progressBar1.position := i + 1;
     end;

     end;
     ListView1.Items.EndUpdate;
     end;
  end
  else
     //выделен набор тегов
     if treeView1.SelectionCount = 1 then
     begin
       list:=Tlist.Create;
       if TNSNodeType(Node.ImageIndex) in TegSet then
       begin
         panelItem.Visible := true;
       //  showItem(rtItems.GetSimpleID(node.Text));
         multyEditMode := false;
         list.Add(@node.Text);
         itemcoord.setList(list,TNSNodeType(Node.ImageIndex),TNSNodeType(Node.Parent.ImageIndex));
         itemcoord.refresh;
       end;
       list.Destroy;
     end else
       begin
       list:=Tlist.Create;


       //если выбраны только теги, генерим из список и передаем на отображение
       if (treeView1.SelectionCount > 1) and (GetDraggedType(treeView1) <= TegSet) then
       begin
           for i:=0 to treeView1.SelectionCount-1 do
           begin
           list.Add(@treeView1.Selections[i].Text);

           end;
           panelItem.Visible := true;
           MultyEditList.Clear;

           FillDraggedList(treeView1, MultyEditList);
           itemcoord.setList(list,TNSNodeType(Node.ImageIndex),TNSNodeType(Node.Parent.ImageIndex));
           itemcoord.refresh;
           //передаем список на груповое редактирование
           
       end;
       list.Destroy;
       end;


end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
var i: integer;
begin
  //если нельзя иметь детей, то предовратить возможность

  // скрываем все меню метаданных
  for i:=9 to 19 do
  PopupMenu1.Items[i].Visible:=false;

  if RightClickedItem <> nil then
  begin
    PopupMenu1.Items[2].Visible:=false;
    PopupMenu1.Items[2].Enabled:=false;
    PopupMenu1.Items[5].Visible:=(TNSNodeType(RightClickedItem.ImageIndex) in ntRefresh);

    PopupMenu1.Items[3].Visible:=(TNSNodeType(RightClickedItem.ImageIndex)=ntOT);
    PopupMenu1.Items[4].Visible:=(TNSNodeType(RightClickedItem.ImageIndex)=ntGT);



  //определяем, можно ли узел удалить
    PopupMenu1.Items[1].Visible := (TNSNodeType(RightClickedItem.ImageIndex) in NodeCanDeletedSet) and
                                        not RightClickedItem.HasChildren;
  //группу опроса можно удалять всегда      // не фига!!!! Алексеев
    if (TNSNodeType(RightClickedItem.ImageIndex) in ntOL) then
    begin
      PopupMenu1.Items[1].Visible := true;
      PopupMenu1.Items[1].Enabled := not RightClickedItem.HasChildren;
      PopupMenu1.Items[2].Visible:=true;
      PopupMenu1.Items[2].Enabled:=true;
    end;

    if (TNSNodeType(RightClickedItem.ImageIndex) in tegSet) then
    begin
       ChangeTreeMenuGroup;

    end;

     if (TNSNodeType(RightClickedItem.ImageIndex)=ntGT) then
    begin
       ChangeTreeMenuAlarmGroup;
    end;


    if (TNSNodeType(RightClickedItem.ImageIndex)=ntAT) then
      begin
          if (TTreeNode(RightClickedItem).Parent<>nil) then
            PopupMenu1.Items[1].Visible:=(TNSNodeType(TTreeNode(RightClickedItem).Parent.ImageIndex)<>ntA)
      end;

      //PopupMenu1.Items[6].Visible:=false;
          // доделать
      PopupMenu1.Items[6].Visible:=((TNSNodeType(RightClickedItem.ImageIndex) in ntOl) and not
      ((TNSNodeType(RightClickedItem.ImageIndex) in ntOSys)));

       if (PopupMenu1.Items[6].Visible) then
        begin
           for i:=0 to  PopupMenu1.Items[6].Count-1 do
              PopupMenu1.Items[6].Items[i].Visible:=
                 (PopupMenu1.Items[6].Items[i].ImageIndex<>RightClickedItem.ImageIndex);
        end;

      PopupMenu1.Items[7].Visible := (TNSNodeType(RightClickedItem.ImageIndex)=ntO);


      if (PopupMenu1.Items[7].Visible) then
        begin
           PopupMenu1.Items[7].Items[0].Visible:=(rtitems.TegGroups.ItemNum['$SYSVAR']<0);
           PopupMenu1.Items[7].Items[1].Visible:=(rtitems.TegGroups.ItemNum['$SYSTEM']<0);
           PopupMenu1.Items[7].Items[2].Visible:=(rtitems.TegGroups.ItemNum['$REPORT']<0);
           PopupMenu1.Items[7].Items[3].Visible:=(rtitems.TegGroups.ItemNum['$POINTER']<0);
           PopupMenu1.Items[7].Items[4].Visible:=(rtitems.TegGroups.ItemNum['$SERVERCOUNT']<0);
           PopupMenu1.Items[7].Items[5].Visible:=(rtitems.TegGroups.ItemNum['$COMMANDSCASE']<0);
        end;


      PopupMenu1.Items[0].Visible := (TNSNodeType(RightClickedItem.ImageIndex)=ntO);
      

      PopupMenu1.Items[8].Visible := (TNSNodeType(RightClickedItem.ImageIndex)=ntG);

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtReportList) then
        begin
           PopupMenu1.Items[9].Visible := true;

        end;






      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtReportHeader) then
        begin
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           PopupMenu1.Items[10].Visible := true;

        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtReportArr) then
        begin
           // если не стартовая
           if TNSNodeType(RightClickedItem.Parent.ImageIndex)<>cdtHomeList then
           begin
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           end;
           PopupMenu1.Items[11].Visible := true;

        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtTrendList) then
        begin
           PopupMenu1.Items[12].Visible := true;
           PopupMenu1.Items[13].Visible := true;
        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtTrendHeader) then
        begin
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           PopupMenu1.Items[13].Visible := true;

        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtTrendArr) then
        begin
           if TNSNodeType(RightClickedItem.Parent.ImageIndex)<>cdtHomeList then
           begin
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           PopupMenu1.Items[13].Visible := true;

           end;

           PopupMenu1.Items[14].Visible := true;
        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtMessageList) then
        begin
          // PopupMenu1.Items[15].Visible := true;
           PopupMenu1.Items[16].Visible := true;
           PopupMenu1.Items[17].Visible := true;
        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtMessageHeader) then
        begin
        //   PopupMenu1.Items[15].Visible := true;
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           PopupMenu1.Items[16].Visible := true;
           PopupMenu1.Items[17].Visible := true;
        end;

      if (TNSNodeType(RightClickedItem.ImageIndex)=cdtGroup) then
        begin
           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;
           PopupMenu1.Items[16].Visible := true;
           PopupMenu1.Items[17].Visible := true;

        end;

      if (TNSNodeType(RightClickedItem.ImageIndex) in [cdtmsgtag,cdttrend,cdtunit]) then
        begin

           PopupMenu1.Items[1].Visible := true;
           PopupMenu1.Items[1].Enabled := true;



        end;

       if ((TNSNodeType(RightClickedItem.ImageIndex) in ntMovable) or
        (TNSNodeType(RightClickedItem.ImageIndex) in ntOl) or
         (TNSNodeType(RightClickedItem.ImageIndex)=ntGl)) then
        begin
           if (TNSNodeType(RightClickedItem.Parent.ImageIndex)<>cdtHomeList) then
           begin
           PopupMenu1.Items[18].visible :=
                (RightClickedItem.Parent.IndexOf(RightClickedItem)<>(RightClickedItem.Parent.Count-1));
           PopupMenu1.Items[19].Visible :=
                (RightClickedItem.Parent.IndexOf(RightClickedItem)<>0);
            end;
        end;


  end
  else begin
    PopupMenu1.Items[0].Visible := true;
    PopupMenu1.Items[1].Visible := false;
    PopupMenu1.Items[2].Visible := false;
  end;
end;

function TForm1.HasAlarms(fromPriority, toPriority: integer): boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and rtItems[i].AlarmedLocal and
      (FromPriority <= rtItems[i].AlarmLevel) and (rtItems[i].AlarmLevel <= toPriority) then
      exit;
  result := false;
end;

function TForm1.HasEvents: boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and (rtItems[i].OnMsged or rtItems[i].OffMsged) then
      exit;
  result := false;
end;

function TForm1.HasLog: boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and rtItems[i].Logged then
      exit;
  result := false;
end;

function TForm1.HasAnalog(GroupNum: integer): boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and (rtItems[i].GroupNum = GroupNum) and not rtItems.IsDiscret(i) then
      exit;
  result := false;
end;

function TForm1.HasDiscret(GroupNum: integer): boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and (rtItems[i].GroupNum = GroupNum) and not rtItems.IsDiscret(i) then
      exit;
  result := false;
end;

function TForm1.HasAlarmGroupItems(GroupNum: integer): boolean;
var
 i: integer;
begin
  result := true;
  for i := 0 to rtitems.AlarmGroups.Count - 1 do
    if rtitems.AlarmGroups.Items[i].App = rtitems.AlarmGroups[GroupNum] then exit;
  for i := 0 to rtItems.Count - 1 do
    if (rtItems[i].ID <> -1) and (rtItems[i].AlarmGroup = GroupNum) then
      exit;
  result := false;
end;

function TForm1.GetDraggedType(source: TObject): TNSNodeSet;
var
  i: integer;
begin
  result := [];
  if (source is TTreeView) then
    for i := 0 to (source as TTreeView).SelectionCount - 1 do
      result := result +
        [TNSNodeType((source as TTreeView).Selections[i].ImageIndex)];
  if (source is TListView) then
    for i := 0 to (source as TListView).Items.Count - 1 do
      if (source as TListView).Items[i].Selected then
        result := result +
          [TNSNodeType((source as TListView).Items[i].ImageIndex)];
end;

procedure TForm1.FillDraggedList(source: TObject; list: TList);
var
  i, j: integer;
begin
  //если источник дерево, то все просто
  if (source is TTreeView) then (source as TTreeView).GetSelections(list);

  //если источник список, то ищем в развернутом узле дерева
  //соответствующие элементы и модифицируем их
  if (source is TListView) then
  begin
    ProgressBar1.Max := (source as TListView).Items.Count;
    for i := 0 to (source as TListView).Items.Count - 1 do
    begin
        ProgressBar1.Position := i;
        ProgressBar1.refresh;
        if (source as TListView).Items[i].Selected then
        for j := 0 to listedItem.Count -1 do
          if (source as TListView).Items[i].Caption = listedItem[j].Text then
          begin
            list.Add(listedItem[j]);
            break;
          end;
      end;
  end;
end;

function TForm1.IsDraggedMove(source: TObject; DestItem: TTreeNode): boolean;
var
  parenTNSNodeType: TNSNodeType;

begin
  //определяем родителя для определения действия по умолчанию
  if(source = TreeView1) then parenTNSNodeType :=TNSNodeType(TreeView1.Selected.Parent.ImageIndex)
  else parenTNSNodeType := TNSNodeType(ListedItem.ImageIndex);
  result := not(parenTNSNodeType in DefaultCopyArray[TNSNodeType(DestItem.ImageIndex)]);//из массива
  //Контрол и шифт перезаписывают значения по умолчанию
  if (Hi(GetKeyState(VK_CONTROL)) <> 0) then result := false;
  if (Hi(GetKeyState(VK_SHIFT)) <> 0) then result := true;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
var
  ListItem: TListItem;
  i: integer;
begin
  with ListView1.ScreenToClient(Mouse.CursorPos) do
    ListItem := ListView1.GetItemAt(X, Y);
  if ListItem <> nil then
  begin
    //showMessage(ListItem.Caption);
    for i := 0 to ListedItem.Count - 1 do
      if ListedItem.Item[i].Text = ListItem.Caption then
      begin
        TreeView1.Select(ListedItem.Item[i]);
        TreeView1Change(self,TreeView1.Selected);
        break;
      end;
  end;
end;
//*****************************************************************************
function cbSelectItem(cb: tComboBox; it: string): boolean;  //выбирает в выпадающем списке совпадающую заись
var
  i: integer;
begin
result := false;
for i :=0 to cb.Items.Count - 1 do
  if UpperCase(cb.Items[i]) = UpperCase(it) then
  begin
    cb.ItemIndex := i;
    result := true;
    exit;
  end;
end;
{ TForm1 }

procedure TForm1.SetIsChanged(const Value: boolean);
begin
//  if fisChanged = Value then exit;
//  fisChanged := Value;
 // treeView1.Enabled := not fisChanged;
  if fIsChanged then
  begin
   // ToolButton1.Enabled := false;
   // ToolButton2.Enabled := false;
   // ToolButton3.Enabled := false;
  //  ToolButton4.Enabled := false;
   // ToolButton5.Enabled := false;
    bDelete.Enabled := false;

   // ToolButton8.Enabled := true;
  end else
  begin
    if curItem <> FindLesses then
    begin
     // ToolButton1.Enabled := true;
    //  ToolButton2.Enabled := true;
    end;
    if curItem <> FindBiggest then
    begin
    //  ToolButton3.Enabled := true;
     // ToolButton4.Enabled := true;
    end;
   // ToolButton5.Enabled := true;
    bDelete.Enabled := true;
    //ToolButton7.Enabled := false;
   // ToolButton8.Enabled := false;
    //changedList.Clear;
  end;
end;

procedure TForm1.TegChanged(Sender: TObject);
begin
 // isChanged := true;
//  if changedList.IndexOf(sender) = -1 then changedList.Add(sender);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Init:=false;
end;

procedure TForm1.ShowItembyName(Name: string);
var
  i: integer;
begin
    for  i := 0 to rtitems.Count - 1 do
      if UpperCase(rtItems.GetName(i)) = UpperCase(Name) then
      begin
        ShowTagItem(i, []);
        break;
      end;
end;

procedure TForm1.ShowTagItem(num: longInt; parent: TNSNodeSet);
var str: string;
    j: integer;
    partype: TNSNodeType;
begin
  curItem := num;
  if num<0 then exit;

  str:=rtitems.GetName(num);
  for j := 0 to TreeView1.Items.Count-1 do
      if (TreeView1.Items[j].Text=str) then
         if (parent=[]) then
            begin
               TreeView1Change(TreeView1,TreeView1.Items[j]);
               TreeView1.Select(TreeView1.Items[j]);
               TreeView1.Repaint;
               exit;
            end else
            begin
              if (TreeView1.Items[j].Parent<>nil) then
                 if (TNSNodeType(TreeView1.Items[j].Parent.ImageIndex) in parent) then
                   begin
                     TreeView1Change(TreeView1,TreeView1.Items[j]);
                     TreeView1.Select(TreeView1.Items[j]);
                     TreeView1.Repaint;
                     exit;
                   end;
            end;
            setbutNav;
end;

procedure TForm1.addNewitem(Sender: TObject);
// определяем имя для нового тега
function getNameUnic(): string;
var i: integer;
begin
    i:=0;
    while (rtitems.GetSimpleID('newitem'+inttostr(i))>-1) do
     i:=i+1;
     result:= 'newitem'+inttostr(i);
end;

// определяем группу для нового тега
function getGroupnum(): integer;
var tgid: integer;
begin
   result:=-1;
   if (TreeView1.SelectionCount=0) then
    begin
       if (rtitems.TegGroups.Count=0) then exit
       else result:=rtitems.TegGroups.Items[0].Num;
    end else
    begin
      if  (not ((TNSNodeType(TreeView1.Selections[0].ImageIndex)=ntOT) or
      (TNSNodeType(TreeView1.Selections[0].ImageIndex) in ntOl)))  then
      begin
        if (rtitems.TegGroups.Count=0) then exit
          else result:=rtitems.TegGroups.Items[0].Num;
      end else
      begin
        if  (TNSNodeType(TreeView1.Selections[0].ImageIndex)=ntOT)
          then
            begin
               tgid:=rtitems.GetSimpleID(TreeView1.Selections[0].Text);
               if (tgid<0) then result:=-1
               else  result:=rtitems[tgid].GroupNum;
            end;
        if(TNSNodeType(TreeView1.Selections[0].ImageIndex) in ntOl)
           then
             begin
               result:=rtitems.TegGroups.ItemNum[TreeView1.Selections[0].Text];

            end;
    end;
    end;
end;

// выделяем новый тег
function select(tag: string): integer;
var groupname: string;
    tgid,i,j: integer;
    newnode: TTreeNode;
begin
    tgid:=rtitems.GetSimpleID(tag);
    if (tgid<0) then exit;
    tgid:=rtitems[tgid].GroupNum;
    groupname:=rtitems.TegGroups.ItemNameByNum[tgid];
    if (groupname='') then groupname:='Вне групп';
    for i := 0 to TreeView1.Items.Count - 1 do
      if ((TreeView1.Items[i].Text = groupname) and (TNSNodeType(TreeView1.Items[i].ImageIndex) in ntOl)) then
        begin
         newnode:=TreeView1.Items.AddChild(TreeView1.Items[i],tag);
         newnode.ImageIndex:=integer(ntOT);
         newnode.SelectedIndex:=integer(ntOT);
         for j := 0 to TreeView1.Items[i].Count-1 do
           if (TreeView1.Items[i].Item[j].Text=tag) then
            begin
               TreeView1.Select(newnode);
               TreeView1Change(TreeView1,TreeView1.Items[i].Item[j]);
               exit;
            end;
       end;
end;
var
  i: integer;
begin
  if rtItems.Count = 0 then
  begin
   // isChanged := true;
    curItem := 0;
  end
  else
  begin
    //ищем пустую запись, если нет, добавляем в конец
    curItem := -1;
    for  i := 0 to rtitems.Count - 1 do
      if rtItems[i].ID = -1 then
      begin
        curitem := i;
        break;
      end;
    if CurItem = -1 then
    begin
      CurItem := rtitems.Count;

    end;
  end;
  rtitems[CurItem].ID:=CurItem;
  rtitems[CurItem].MinRaw:=0;
  rtitems[CurItem].MaxRaw:=100;
  rtitems[CurItem].MinEU:=0;
  rtitems[CurItem].MaxEU:=100;
  rtitems.SetName(CurItem,getNameUnic);
  rtitems.SetComment(CurItem,'Comment');
  rtitems.SetDDEItem(CurItem,'');
  rtitems.SetOnMsg(CurItem,'');
  rtitems.SetOffMsg(CurItem,'');
  rtitems.SetAlarmMsg(CurItem,'');
  rtitems.SetEU(CurItem,'');
  rtitems[CurItem].Logged:=false;
  rtitems[CurItem].logTime:=0;
  rtitems[CurItem].logDB:=0;
  rtitems[CurItem].OnMsged:=false;
  rtitems[CurItem].OffMsged:=false;
  rtitems[CurItem].Alarmed:=false;
  rtitems[CurItem].GroupNum:=getGroupnum();
  rtitems[CurItem].AlarmGroup:=0;
 if CurItem = rtItems.Count then
   begin
     rtItems.Count := rtItems.Count  + 1;
   //  rtItems.FreeItem(CurItem);
   end;
   rtitems.WriteToFile(CurItem);
   select(rtitems.GetName(CurItem));

end;

procedure TForm1.bDeleteClick(Sender: TObject);
var
  ItemName: string;
  i, showit: integer;
begin
   if TreeView1.SelectionCount=0 then exit;
   if (TNSNodeType(TreeView1.Selections[0].ImageIndex) = ntOT) then
   begin
   for i := 0 to TreeView1.SelectionCount - 1 do
   begin
    ItemName := TreeView1.Selections[i].Text;
    showit:=DeleteTeg(ItemName);
   end;
   if showit>-1 then ShowTagItem(showit,[]);
   end;

   if (TNSNodeType(TreeView1.Selections[0].ImageIndex) in ntMeta) then
     begin
         self.N2Click(Sender);
     end;


end;



procedure TForm1.ToolButton11Click(Sender: TObject);
var
  i: integer;
begin
  with TSelectAppForm.Create(self) do
  try
    rtit:=rtitems;
    show(self.filter);
    if ShowModal = mrOK then
     // showTagItem(rtItems.GetSimpleID(ListBox1.Items[ListBox1.ItemIndex]));
    ShowTagItem(rtItems.GetSimpleID(ListBox1.Items[ListBox1.ItemIndex]),ntOl);
  finally
    self.filter:=Edit1.Text;
    free;
  end;
end;

function TForm1.GetStartAddr(typeMod:string): string;
begin
 if trim(typeMod) = 'V' then result := '0';
 if trim(typeMod) = 'B' then result := '0';
 if trim(typeMod) = 'GX' then result := '40000';
 if trim(typeMod) = 'GY' then result := '40200';
 if trim(typeMod) = 'S' then result := '41000';
 if trim(typeMod) = 'T' then result := '41100';
 if trim(typeMod) = 'SP' then result := '41200';
 if trim(typeMod) = 'X' then result := '40400';
 if trim(typeMod) = 'Y' then result := '40500';
 if trim(typeMod) = 'C' then result := '40600';
end;

function TForm1.ShiftAddr(typeMod, Item: string; shiftWord: integer): string;
var
  itemWordAddr, ItemBitsAddr, bitsCount: integer;
begin
 result := Item;
 if (trim(typeMod) <> 'B') and (trim(typeMod) <> 'V' ) then
 begin
   bitsCount := OctStringToInteger(Item);
   ItemWordAddr := OctStringToInteger(GetStartAddr(typeMod)) + bitsCount div 16;
   ItemBitsAddr := bitsCount mod 16;
   result := IntegerToOctString(ItemWordAddr + ShiftWord) + '.' + IntToStr(ItemBitsAddr);
 end;
end;

function TForm1.DefDflt(var dfltBCD, dfltAlarmedLocal: boolean;
                           var dfltGroup, dfltAlCase: string;
                           var dfltAlLevel: integer;
                           var dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst: real; var dfltLogtime): TModalResult;
var
  inputOK: boolean;
begin
  with TFrmDfltNew.Create(self) do
  begin

    repeat
      rtitems.TegGroups.FillStrings(comboBox2.Items);
      comboBox2.ItemIndex := 0;
      result := ShowModal;

      inputOk := true;
      if result = mrCancel then exit;

      try
        dfltBCD := checkBox2.Checked;
        dfltGroup := ComboBox2.Items[ComboBox2.ItemIndex];
        dfltMinRaw := strtofloat(edit2.text);
        dfltMaxRaw := strtofloat(edit3.text);
        dfltMinEU := strtofloat(edit4.text);
        dfltMaxEU := strtofloat(edit5.text);
        dfltAlarmedLocal := checkBox1.Checked;
        dfltAlCase := comboBox1.items[comboBox1.Itemindex];
        case radioGroup1.Itemindex of
          0: dfltAlLevel := 400;
          1: dfltAlLevel := 600;
        end;//case
        dfltAlConst := strtofloat(edit1.text);
      except
        MessageDlg ('Ввод неверен', mterror, [mbOk], 0);
        inputOk := false;
      end;
    until inputOk = true;
    free;
  end;
end;
procedure TForm1.N4Click(Sender: TObject);
begin
  CreateNewAlarmGroup;
end;

procedure TForm1.CreateNewGroup(GroupName: string = '');
var
  Group: PTGroup;
begin
  new(Group);//память будет уничтжаться при унитожении списка
 // with TFrmGrpNew.Create(self) do
  try
  //  Edit1.Text := GroupName;
   // if showModal = mrOk then
    begin
      if rtitems.TegGroups.itemNum[GroupName] <> -1 then
       raise Exception.Create('Группа уже существует.');
      group.Num := -1; //Когда будем добавлять в список, будет заменен на первый свободный номер группы
      group.Name := GroupName;
      group.App := '';
      group.Topic := '';
      group.SlaveNum := 0;
      rtitems.TegGroups.Add(Group);
      rtitems.TegGroups.SaveToFile(PathMem + 'groups.cfg');
      RefreshNodeName('Опрос');
    end;
  finally
   // free;
  end;
end;


procedure TForm1.N3Click(Sender: TObject);
begin
  CreateNewGroup;
end;

function TForm1.FindNextLess(var CurIt: integer): boolean;
var
  i, less: integer;
  CurName: string;
begin
  less := -1;
  result := false;
  curName := UpperCase(rtItems.GetName(CurIt));
  for i := 0 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if (less = -1) and (UpperCase(rtItems.GetName(i)) < curName) then less := i
      else if (less <> -1) and (UpperCase(rtItems.GetName(i)) < curName) and
           (UpperCase(rtItems.GetName(less)) < UpperCase(rtItems.GetName(i))) then less := i;
  if less <> -1 then
  begin
    curIt := less;
    result := true;
  end;
end;

function TForm1.FindNextMore(var curIt: integer): boolean;
var
  i, more: integer;
  CurName: string;
begin
  more := -1;
  result := false;
  curName := UpperCase(rtItems.GetName(CurIt));
  for i := 0 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if (more = -1) and (UpperCase(rtItems.GetName(i)) > curName) then more := i
      else if (more <> -1) and (UpperCase(rtItems.GetName(i)) > curName) and
           (UpperCase(rtItems.GetName(more)) > UpperCase(rtItems.GetName(i))) then more := i;
  if more <> -1 then
  begin
    curIt := more;
    result := true;
  end;
end;

function TForm1.FindBiggest: integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if UpperCase(rtItems.GetName(i)) > UpperCase(rtItems.GetName(result)) then result := i;
end;

function TForm1.FindLesses: integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to rtItems.Count - 1 do
    if rtItems[i].ID <> -1 then
      if UpperCase(rtItems.GetName(i)) < UpperCase(rtItems.GetName(result)) then result := i;
end;



procedure TForm1.SetMultyEditMode(const Value: boolean);
begin
  if fmultyEditMode = Value then exit;
  fmultyEditMode := Value;
  panelItem.Visible := true;

 // edit1.Enabled := not fmultyEditMode;
 // edit1.Color := ifthen(fmultyEditMode, clSilver, clWindow);

  if not fmultyEditMode then
  begin
  {  Edit2.Color := clWindow;
    Edit3.Color := clWindow;
    Edit4.Color := clWindow;
    Edit5.Color := clWindow;
    Edit6.Color := clWindow;
    Edit7.Color := clWindow;
    FloatEdit1.Color := clWindow;
    FloatEdit2.Color := clWindow;
    FloatEdit3.Color := clWindow;
    FloatEdit4.Color := clWindow;
    FloatEdit5.Color := clWindow;
    FloatEdit6.Color := clWindow;
    FloatEdit7.Color := clWindow;
     FloatEdit8.Color := clWindow; }
  end;
 // isChanged := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  init:=false;
  projcoord.Free;
  MultyEditList.Free;
end;



procedure TForm1.SaveListToFile(SavedItems: TList);
var
  i: integer;
  id: integer;
begin
  for i := 0 to SavedItems.count - 1 do
  begin
    id := rtItems.GetSimpleID(TTreeNode(SavedItems[i]).text);
    if id <> -1 then rtItems.writeToFile(id);
  end;
end;

function TForm1.TreeViewFindNode(tree: TTreeView; str: string): TTreeNode;
var
  i: integer;
begin
  result := nil;
  for i := 0 to tree.Items.Count - 1 do
    if tree.Items[i].Text = str then
    begin
      result := tree.Items[i];
      exit;
    end;

end;

procedure TForm1.TreeView1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  pnt: TPoint;
begin
  pnt := Point(X, Y);
  if TreeView1.GetNodeAt(pnt.X, pnt.Y) <> nil then
    StatusBar1.Panels[0].Text := TreeView1.GetNodeAt(pnt.X, pnt.Y).Text + ':' +
                inttostr(TreeView1.GetNodeAt(pnt.X, pnt.Y).ImageIndex) + ':' +
                inttostr(X) + ',' + inttostr(Y);
end;

function TForm1.HasChildGG(GroupName: string): boolean;
begin
   { with query2 do
    begin
      SQL.Clear;
      SQL.add('select * from groups where parent = :iParent');
      query2.Parameters.ParamByName('iParent').Value:=GroupName;
      //execSQL;
      open;
      result := RecordCount > 0;
      close;
    end;    }
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  CreateNewGroup;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  multyEditMode := false;
  panelItem.Visible := true;
  showTagItem(CurItem,[]);
 //ShowItemNew(nil);
 // comboBox2.ItemIndex := combobox2.Items.IndexOf(RightClickedItem.Parent.Text);
end;


{procedure TForm1.WriteTrenddef;
var i: integer;
    fDBMeneger: TMainDataModule;
begin

   fDBMeneger:=TDBManagerFactory.
      buildManager(dbmanager,connectionstr,dbaAll,false,'ARcServ');
   if fDBMeneger<>nil
     then
       begin
         for i:=0 to rtitems.Count-1 do
          if rtitems[i].ID>-1 then
           begin
              fDBMeneger.Connect;
              fDBMeneger.WriteTrendef(rtitems[i].ID,
              rtitems.GetName(i),
              rtitems.GetComment(i),
              rtitems[i].MinEu,
              rtitems[i].MaxEu,
              rtitems[i].MinRaw,
              rtitems[i].MaxRaw,
              rtitems[i].logDB,
              rtitems[i].logTime,
              rtitems[i].TimeStamp,
              rtitems.GetEU(i),
              rtitems[i].OnMsged,
              rtitems[i].OffMsged,
              rtitems[i].Alarmed,
              tdoAdd,
              );
           end;
       end;

end;       }


procedure TForm1.Refresh(Node: TTreeNode);
begin
  if node = nil then RefreshTree else
end;

procedure TForm1.refreshtree;
var
  curNode, firstNode: TTreeNode;
  i: integer;
  tempb: boolean;
begin
    TreeView1.Items.Clear;
    curNode := TreeView1.Items.AddChild(nil, 'Конфигурация');
    curNode.HasChildren := false;
    curNode.ImageIndex := integer(prjProp);
    firstNode:=curNode;
    curNode := TreeView1.Items.AddChild(nil, 'Опрос');
    curNode.HasChildren := true;
    curNode.ImageIndex := integer(ntO);

    refreshNode(CurNode, true);

    with TreeView1.Items.AddChild(nil, 'Тревоги') do
    begin
      HasChildren := true;
      ImageIndex := integer(ntG);
    end;

   // if fileExists(PathMem + 'AlarmGroupsStruct.cfg') then
   // begin
    // loadNode('Тревоги группы', PathMem + 'AlarmGroupsStruct.cfg');
    // SeTNSNodeType('Тревоги группы', ntGGl, ntGGl);

   // end else
   // with TreeView1.Items.AddChild(nil, 'Тревоги группы') do
   //   ImageIndex := integer(ntGG);


    //Выделяем архивируемые параметры
    curNode := TreeView1.Items.AddChild(nil, 'Архив');
    curNode.HasChildren := true;
    curNode.ImageIndex := integer(ntA);


    // Загружаем метаданные проекта


    //загружаем группы архивы
    //if fileExists(PathMem + 'TrendGroupsStruct.cfg') then
    //begin
     //loadNode('Архив группы', PathMem + 'TrendGroupsStruct.cfg');
    // SeTNSNodeType('Архив группы', ntAl, ntAt);
    //end else
      curNode:=TreeView1.Items.AddChild(nil, 'Отчетные теги');
      curNode.ImageIndex := integer(ntArc);
      self.refreshNode(curNode,true);

    //Выделяем событируемые араметры
    curNode := TreeView1.Items.AddChild(nil, 'События');
    curNode.HasChildren := true;
    curNode.ImageIndex := integer(ntS);

    LoadMetadata(TreeView1.Items.AddChild(nil, 'Метаданные клиента'));

end;

function TForm1.deleteTeg(TegName: string): integer; // next
var
  i: integer;
  DelID, NextItem: integer;

begin
  //редактор справа
  //если мы на последней записи, показать предыдущую, иначе следующую
  DelID := rtItems.GetSimpleID(TegName);
  nextItem := CurItem;
  if not FindNextMore(NextItem) then FindNextLess(NextItem);
  rtItems.FreeItem(DelID);
  rtItems.WriteToFile(DelID); //записать на диск саму запись
  //ShowTagItem(NextItem,[]);
  result:=NextItem;
  //удаляем из списка слева
  for i := TreeView1.Items.Count - 1 downto  0 do
    if TreeView1.Items[i].text = TegName then TreeView1.Items.Delete(TreeView1.Items[i]);
  //еще надо удалить из БД групп

end;

procedure TForm1.refreshNodeName(nodeName: string);
var
  i: integer;
begin
 for i := 0 to TreeView1.Items.Count - 1 do
   if TreeView1.Items[i].Text = nodeName then
   begin
     refreshNode(TreeView1.Items[i], true);
     exit;
   end;
end;

procedure TForm1.refreshNodeNameandtype(nodeName: string; ntype: TNSNodeSet);
var
  i: integer;
begin
 for i := 0 to TreeView1.Items.Count - 1 do
   if ((TreeView1.Items[i].Text = nodeName) and (TNSNodeType(TreeView1.Items[i].ImageIndex) in ntype)) then
   begin
     refreshNode(TreeView1.Items[i], true);
     exit;
   end;
end;

procedure TForm1.ShowGroups(FN:string);
begin
  with TFrmEditCSV.Create(self) do
  try
   fillGridFromCSV(StringGrid1, FN);
   if showModal = mrOK then
   SaveGridToCSV(StringGrid1, FN);
  finally
    free;
  end;
end;

procedure TForm1.DublicateGroup;
var
  nm: string;
  prevItem: integer;

begin
  with TFrmGrpDbl.Create(self) do
  begin
      enableAlarmDefinition := false;
      rtitems.TegGroups.FillStrings(cbGRP1.Items);
      rtitems.TegGroups.FillStrings(cbGRP2.Items);
      cbGRP1.ItemIndex := 0;
      cbGRP2.ItemIndex := 1;
      if showModal = mrOk then
      begin
          if Ed1.Text = '' then
            raise Exception.Create('Префикс не может быть пуст');

          if cbGRP1.Text = cbGRP2.Text then
            raise Exception.Create('Группы должны быть различные');

         // ShowItemFirst(self);
          repeat
         //   if self.comboBox2.Text = cbGRP1.Text then
            begin
             // nm := edit1.Text;
         //     ShowItemNew(Self);
            //  if pos('$', edit1.text) <> 1 then
            //    self.Edit1.Text := Ed1.Text + nm
           //   else
           //     self.Edit1.Text := '$' + Ed1.Text + copy(nm, 2, Length(nm) - 1);
           //   self.comboBox2.ItemIndex := cbGRP2.ItemIndex;
           //   ToolButton7Click(self); //сохранить новую запись
           //   showItem(rtItems.GetSimpleID(nm));//возвращаемся к дублированной
            end;
            prevItem := curItem;
        //    ShowItemNext(self)

          until curItem = prevItem;
      end;
  end;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  //EditGroups(Pathmem + 'Groups.cfg', rtitems.TegGroups);
end;

procedure TForm1.N11Click(Sender: TObject);
begin
 DublicateGroup;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
 ExportGroup(AnsiUpperCase(inputBox('Ввод пользователя', 'Введите экспортируемую группу:', '')));
end;

procedure TForm1.PLCDirect2Click(Sender: TObject);
function addType(types: string; val: string): string;
begin
 types:=trim(uppercase(types));
 result:=val;

  if types='BCD' then result:=val+':B';
  if types='REAL' then result:=val+':R';

end;
var
  i: integer;
  rtName: string;
  isNew: boolean;
  dfltBCD, dfltAlarmedLocal, KnowDflt: boolean;
  dfltGroup, dfltAlCase: string;
  dfltAlLevel, dfltLogTime: integer;
  dfltMinEu, dfltMaxEu, dfltMinRaw, dfltMaxRaw, dfltAlConst: real;
  ImportTo, StartAddr: string; //address of V-memory, where will be imported to
  bitsCount, StartWordAddr: integer;
  shiftWord: integer;
  ReplaceAll: boolean;
  newitem: TAnalogMem;
  _comment, _ddeitem, _onmsg, _ofmsg,_alarmmsg, _eu:  string;
  typeit: string;
begin
  openDialog1.DefaultExt := 'esd';
  openDialog1.Filter := 'Текст с разделителями(*.esd)|*.esd';
  ReplaceAll := false;
  KnowDflt := false;
  enableAlarmDefinition := false;
  if OpenDialog1.Execute then
  begin
    with  TESDImpFrm.Create(self) do
    begin
      ShowDoc (OpenDialog1.FileName);
      Sort1Click(self);
      if showModal = mrOK then
      begin
        ImportTo := Edit2.Text;

        shiftWord := 0;

        if (trim(StringGrid1.Cells[0, 1]) <> 'B') and (trim(StringGrid1.Cells[0, 1]) <> 'V' ) then
        begin
          StartAddr := GetStartAddr(StringGrid1.Cells[0, 1]);
          bitsCount := OctStringToInteger(edit2.text);
          StartWordAddr := OctStringToInteger(StartAddr) + bitsCount div 16;
          importTo := IntegerToOctString(StartWordAddr);

          if not InputQuery('Начальный адрес', 'Импортировать в V:', ImportTo) then exit;
          //новый адрес известен, теперь рассчитать смещение для битов
          shiftWord := OctStringToInteger(importTo) - StartWordAddr;
        end;

        for i := 1 to StringGrid1.RowCount-1 do
        begin
          if StringGrid1.Cells[2, i] = '' then continue;
          ProgressBar1.Position := i;
           typeit := StringGrid1.Cells[3, i];
           rtName := StringGrid1.Cells[2, i];
           isNew := true;


           if isNew and not KnowDflt then
             if DefDflt(dfltBCD, dfltAlarmedLocal,
                           dfltGroup, dfltAlCase,
                           dfltAlLevel,
                           dfltMinEu, dfltMaxEu,
                           dfltMinRaw, dfltMaxRaw,
                           dfltAlConst, dfltLogTime) <> mrOK then exit
             else KnowDflt := true;



           _comment := StringGrid1.Cells[4, i];
           _ddeitem := 'V' + ShiftAddr(StringGrid1.Cells[0, i], StringGrid1.Cells[1, i], shiftWord);

           if isNew then
           with self do
           begin
            // if dfltBCD then
            // begin
               _ddeitem := addType(typeit,_ddeitem);// + ':B';
               newitem.logDB := strtofloat_(format('%g', [(dfltMaxEu - dfltMinEu) / 200])); //0.5%
            // end;
             newitem.GroupNum := rtitems.TegGroups.ItemNum[dfltGroup];
             newitem.MinRaw := strtofloat_(format('%g', [dfltMinRaw]));
             newitem.MaxRaw := strtofloat_(format('%g', [dfltMaxRaw]));
             newitem.MinEU := strtofloat_(format('%g', [dfltMinEu]));
             newitem.MaxEU := strtofloat_(format('%g', [dfltMaxEu]));
             newitem.AlarmedLocal := dfltAlarmedlocal;
             _alarmmsg := _comment ;
             newitem.AlarmLevel := dfltAlLevel;
             newitem.alarmCase := TalarmCase(dfltAlCase='<');
             newitem.AlarmConst := strtofloat_(format('%g', [dfltAlConst]));
             newitem.logTime := dfltLogtime;
           end;
           if AddRTitems(i, rtName,_comment, _ddeitem, _onmsg, _ofmsg,_alarmmsg, _eu, newitem, true, replaceAll) then
           exit;
        end;

      end;
      free;
    end;
  end;
  enableAlarmDefinition := true;
  RefreshNodeName('Опрос');
end;

procedure TForm1.csv3Click(Sender: TObject);
var
  i, j: integer;
  nameCol: integer;
  replaceAll: boolean;
  rtName, pref, group_: string;
  newitem: TAnalogMem;
  _comment, _ddeitem, _onmsg, _ofmsg,_alarmmsg, _eu:  string;
  DeadBaund: real;
begin
  replaceAll := false;
  nameCol := -1;
  openDialog1.DefaultExt := 'csv';
  openDialog1.Filter := 'Текст с разделителями(*.csv)|*.csv';
  if openDialog1.Execute then
  pref := inputBox('Ввод префикса', 'Введите префикс:', '');
  group_ := inputBox('Ввод гуппы', 'Введите группу:', '');
  with TFrmEditCSV.Create(self) do
  try
    fillGridFromCSV(StringGrid1, openDialog1.fileName);
    for i := 0 to StringGrid1.ColCount - 1 do
      if UpperCase(StringGrid1.Cells[i, 0]) = 'NAME' then NameCol :=i
      else
        if (UpperCase(StringGrid1.Cells[i, 0]) <> 'GROUP') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ITEM') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'COMMENT') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGGED') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGTIME') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'LOGDB') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MINRAW') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MAXRAW') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MINEU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'MAXEU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMEDLOCAL') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMMSG') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMLEVEL') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMCASE') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMCONST') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'EU') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ALARMGROUP') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ONMSGED') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'ONMSG') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'OFFMSGED') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'OFFMSG') and
           (UpperCase(StringGrid1.Cells[i, 0]) <> 'DEADBAUND')
        then
           raise exception.Create('Заголовок не определен "' + StringGrid1.Cells[i, 0] + '"');
    if NameCol = -1 then raise exception.Create('Поле NAME не найдено');

    progressBar1.Max := StringGrid1.RowCount - 1;
    for j := 1 to StringGrid1.RowCount - 1 do
    begin
      progressBar1.position := j;
      if StringGrid1.Cells[NameCol, j] = '' then continue;
        rtName := pref + StringGrid1.Cells[nameCol, j];
        StatusBar1.Panels[0].Text := inttostr(j) + '/' + inttostr(StringGrid1.RowCount) + ':' + rtName;
        StatusBar1.Refresh;
        progressBar1.refresh;

        for i := 0 to StringGrid1.ColCount - 1 do

          if (UpperCase(StringGrid1.Cells[i, 0]) = 'GROUP') then
            begin
            if trim(group_)='' then
            newitem.GroupNum := rtitems.TegGroups.ItemNum[trim(StringGrid1.Cells[i, j])]
            else newitem.GroupNum := rtitems.TegGroups.ItemNum[trim(group_)];

            end
            else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ITEM') then
             _ddeitem:= StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'COMMENT') then
            _comment:= StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'LOGGED') then
              newitem.Logged := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE') else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'LOGTIME') then
              newitem.logTime := strtoint(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'LOGDB') then
              newitem.logDB := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MINRAW') then
              newitem.MinRaw := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MAXRAW') then
              newitem.MaxRaw := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MINEU') then
              newitem.Mineu := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'MAXEU') then
              newitem.Maxeu := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMEDLOCAL') then
              newitem.AlarmedLocal := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE')else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMMSG') then
            _alarmmsg := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'EU') then
            _eu := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMLEVEL') then
              newitem.Alarmlevel:= strtoint(StringGrid1.Cells[i, j])  else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMCASE') then
            newitem.alarmCase:=TAlarmCase(trim(StringGrid1.Cells[i, j])='<') else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'DEADBAUND') then
          DeadBaund := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMCONST') then
          newitem.AlarmConst := strtofloat_(StringGrid1.Cells[i, j]) else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ALARMGROUP') then
          newitem.AlarmGroup := rtitems.alarmgroups.ItemNum[trim(StringGrid1.Cells[i, j])] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ONMSGED') then
              newitem.OnMsged := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE') else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'ONMSG') then
            _onmsg := StringGrid1.Cells[i, j] else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'OFFMSGED') then
              newitem.OffMsged := (UpperCase(StringGrid1.Cells[i, j]) = 'TRUE')else
          if (UpperCase(StringGrid1.Cells[i, 0]) = 'OFFMSG') then
            _ofmsg := StringGrid1.Cells[i, j];
      if AddRTitems(i, rtName,_comment, _ddeitem, _onmsg, _ofmsg,_alarmmsg, _eu, newitem, true, replaceAll) then
      exit;
    end; 
    RefreshNodeName('Опрос');
  finally
    free;
  end;
end;

procedure TForm1.exportGroup(GroupName: string);
var
  i: integer;
  f: TextFile;
begin
 if SaveDialog1.Execute then
 if not FileExists(SaveDialog1.FileName) or
   ((FileExists(SaveDialog1.FileName) and
    (MessageDlg('Файл ' + ExtractFileName(SaveDialog1.FileName) + ' существует. Перезаписать?',
        mtConfirmation, [mbYes, mbNo], 0) = IDYes))) then
 try
   assignFile(f, SaveDialog1.FileName);
   rewrite(f);

   writeln(f, 'Name', ';', 'Group', ';',
              'Item', ';', 'Comment', ';',
              'Logged', ';', 'LogTime', ';', 'LogDB', ';',
              'MinRaw', ';', 'MaxRaw', ';',
              'MinEu', ';', 'MaxEu', ';',
              'OnMsged',';', 'OnMsg', ';' ,'offMsged', ';', 'OffMsg', ';',
              'AlarmedLocal', ';', 'AlarmMsg', ';',
              'AlarmLevel', ';', 'AlarmCase', ';',
              'AlarmConst', ';', 'DeadBaund', ';', 'EU', ';', 'AlarmGroup'
          );
   for i := 0 to rtItems.Count - 1 do
     if rtItems[i].ID <> -1 then
     begin
       if (groupName = '') or (AnsiUpperCase(rtitems.TegGroups[rtItems[i].GroupNum]) = GroupName) then
       writeln(f, rtItems.GetName(i), ';', rtitems.TegGroups[rtItems[i].GroupNum], ';',
                rtItems.GetDDEItem(i), ';', rtItems.GetComment(i), ';',
                rtItems[i].Logged, ';', rtItems[i].LogTime, ';', rtItems[i].LogDB:8:3, ';',
                rtItems[i].MinRaw:8:3, ';', rtItems[i].MaxRaw:8:3, ';',
                rtItems[i].MinEu:8:3, ';',rtItems[i].MaxEu:8:3, ';',
                rtItems[i].OnMsged, ';', rtItems.GetOnMsg(i), ';', rtItems[i].offMsged, ';', rtItems.GetOffMsg(i), ';',
                rtItems[i].AlarmedLocal, ';', rtItems.GetAlarmMsg(i), ';',
                rtItems[i].AlarmLevel, ';', rtItems.GetAlarmCase(i), ';',
                rtItems[i].AlarmConst:8:3, ';', 0.0:8:3, ';', rtItems.GetEU(i), ';', rtitems.alarmgroups[rtItems[i].AlarmGroup]
        );
     end;
 finally
   closeFile(f);
 end;
end;

procedure TForm1.SaveAlarmsGroups;
begin
end;

procedure TForm1.N6Click(Sender: TObject);
begin
 // EditGroups(Pathmem + 'alarmGroups.cfg', AlarmGroups);
end;




procedure TForm1.CreateNewAlarmGroup(GroupName: string);
var
  Group: PTGroup;
  str: string;
begin
  new(Group);//память будет уничтжаться при унитожении списка
  str := '';
  if InputQuery('Ввод пользователя','Новая группа тревог',Str) then
    begin
      if (rtitems.TegGroups.itemNum[str] <> -1) or (str = '') then
       raise Exception.Create('Группа уже существует.');
      group.Num := -1; //Когда будем добавлять в список, будет заменен на первый свободный номер группы
      group.Name := str;
      group.App := '';
      group.Topic := '';
      group.SlaveNum := 0;
      rtitems.AlarmGroups.Add(Group);
      rtitems.AlarmGroups.SaveToFile(PathMem + 'Alarmgroups.cfg');
      //RefreshNodeName('Опрос');
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  saveNode('Тревоги группы', PathMem + 'AlarmGroupsStruct.cfg');
end;

procedure TForm1.copyNode(dest:TTreeView; parent, Node: TTreeNode);
var
  i: integer;
  NewNode: TTreeNode;
begin
  newNode := dest.Items.AddChild(parent, Node.Text);
  with newNode do
  begin
    HasChildren := node.HasChildren;
    ImageIndex := node.ImageIndex;
    for i:= 0 to node.Count - 1 do
    copyNode(dest, newNode, node[i]);
  end;
end;



procedure TForm1.Button2Click(Sender: TObject);
begin
  loadNode('Тревоги группы', PathMem + 'AlarmGroupsStruct.cfg');
end;

procedure TForm1.LoadNode(NodeName, fileName: string);
var
  i: integer;
  Temptree: TTreeView;
  FileStream: TFileStream;
begin
  Temptree:= TTreeView.create(self);
  try
    Temptree.Parent := self;
    tempTree.Visible := false;
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    try
      Temptree.LoadFromStream(FileStream);
    finally
      fileStream.Free;
    end;
    with tempTree do
    for i := 0 to Items.Count - 1 do
      if items[i].Text = NodeName then
      begin
        items[i].Expand(true);
        copyNode(treeView1, nil, items[i]);
        break;
      end;
    finally
     tempTree.Free;
    end;

end;

procedure TForm1.SaveNode(NodeName, fileName: string);
var
  i, num: integer;
  Temptree: TTreeView;
  FileStream: TFileStream;
begin
  Temptree:= TTreeView.create(self);
  try
  Temptree.Parent := self;
  tempTree.Visible := false;
  with treeView1 do
  for i := 0 to Items.Count - 1 do
    if items[i].Text = NodeName then
    begin
      items[i].Expand(true);
      copyNode(Temptree, nil, items[i]);
      break;
    end;

  FileStream := TFileStream.Create(FileName, fmCreate);
    try
      Temptree.SaveToStream(FileStream);
    finally
      fileStream.Free;
    end;
  finally
    tempTree.Free;
  end;
end;

procedure TForm1.SeTNSNodeType(NodeName: string; NodeType, TegType: TNSNodeType);
var
  i: integer;
begin
  with treeView1 do
  for i := 0 to items.count - 1 do
    if Items[i].Text = NodeName then
    begin
        SeTNSNodeTypeRec(Items[i], NodeType, TegType);
        break;
    end;
end;

procedure TForm1.SeTNSNodeTypeRec(Node: TTreeNode; NodeType, TegType: TNSNodeType);
var
  i: integer;
begin
  with node do
  begin
    if (NodeType = TegType) or (rtItems.GetSimpleID(node.text) = -1) then
      node.ImageIndex := TImageIndex(NodeType)
    else node.ImageIndex := TImageIndex(TegType);

    for i := 0 to count - 1 do
      SeTNSNodeTypeRec(Item[i], NodeType, TegType);
  end;
end;
procedure TForm1.N7Click(Sender: TObject);
begin
if rtitems<>nil  then
n15.Checked:=rtitems.oper.getRegist;
end;

procedure TForm1.N15Click(Sender: TObject);
begin
  if rtitems<>nil  then begin
      rtitems.oper.setRegist(not rtitems.oper.getRegist);
      n15.Checked:=rtitems.oper.getRegist;
      end;
end;

procedure TForm1.ComboGroupChange(Sender: TObject);
begin
 { if (ComboGroup.ItemIndex<>-1) then begin
   if (geTNSNodeTypebyIndex(ComboGroup.ItemIndex)<>TNSNodeType(TreeView1.Selected.ImageIndex)) then
  ValueListItem.Color:=clGray
  else  ValueListItem.Color:=clWhite;

  ValueListItem.Enabled:=(geTNSNodeTypebyIndex(ComboGroup.ItemIndex)=TNSNodeType(TreeView1.Selected.ImageIndex));
  itemcoord.setTypeGroupC(ComboGroup.ItemIndex); end;    }
end;




procedure TForm1.ButtonSaveClick(Sender: TObject);
var newi: integer;
begin
   if (changeGrMI<>nil) then
   newi:=itemcoord.setTypeGroups(changeGrMI.ImageIndex);
   if (newi>-1) then
    self.TreeView1.Selected.ImageIndex:=newi;
   itemcoord.Save;
end;

procedure TForm1.bSaveClick(Sender: TObject);
var temp_str: string;
    old_str: string;
    i,id: integer;
begin
    temp_str:=itemcoord.Save;
    if (temp_str<>'') then
      begin
      old_str:=TreeView1.Selected.Text;
      TreeView1.Selected.Text:=temp_str;
      if (TNSNodeType(TreeView1.Selected.ImageIndex) in TegSet) then
      UpdateItemName(old_str,temp_str);

      end;
    if ((TNSNodeType(TreeView1.Selected.ImageIndex)  in  ntOl) and (changeGrMI<>nil)) then
      begin
         if (TreeView1.Selected.ImageIndex<>changeGrMI.ImageIndex) then
            TreeView1.Selected.ImageIndex:=changeGrMI.ImageIndex;
            TreeView1.Selected.SelectedIndex:=TreeView1.Selected.ImageIndex;
            //self.refreshNodeName(TreeView1.Selected.Text);
      end;
     if CurItem = rtItems.Count then
      begin
        rtItems.Count := rtItems.Count  + 1;
      //  rtItems.FreeItem(CurItem);
       end;

    if (TNSNodeType(TreeView1.Selected.ImageIndex) in TegSet) then
      for i:=0 to TreeView1.SelectionCount-1 do
        begin
          id:=rtitems.GetSimpleID(TreeView1.Selections[i].Text);
          if id>-1 then
           TreeView1.Selections[i].ImageIndex:=getItemTypeIndex(rtitems.items[id]);
           TreeView1.Selected.SelectedIndex:=TreeView1.Selected.ImageIndex;
           TreeView1.Refresh;
        end;
end;

procedure TForm1.TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
begin
node.SelectedIndex:=node.ImageIndex;
end;


procedure TForm1.setpanel(key: integer);
begin
ToolBar.Visible:=(key>0);
case key  of
1:
begin

     bNew.Enabled:=true;
     bDelete.Enabled:=true;

 //  ComboGroup.Visible:=false;
end;
2:
begin
  // bLeft.Enabled:=false;
 //  bRight.Enabled:=false;
   bNew.Enabled:=false;
   bDelete.Enabled:=false;
 //  bSave.Visible:=false;
 //  bSave.Visible:=false;
 //  bChrest.Visible:=false;
  // ComboGroup.Visible:=true;
end;
3:
begin

 //ComboGroup.Visible:=false;
  bNew.Enabled:=false;
   bDelete.Enabled:=false;
end;
end;
self.ValueListItem.Visible:=true;
end;

procedure TForm1.TreeTagOutofGroup();
var i: integer;
     newNode: TTreeNode;
     outNode: TTreeNode;
     count: integer;
begin

  for i := 0 to TreeView1.Items.Count - 1 do
   if ((TreeView1.Items[i].Text = 'Опрос') and (TNSNodeType(TreeView1.Items[i].ImageIndex)=ntO)) then
   begin
     TreeOutofGroup(TreeView1.Items[i]);
     exit;
   end;
end;

procedure TForm1.TreeOutofGroup(Node: TTreeNode);
var i: integer;
     newNode: TTreeNode;
     outNode: TTreeNode;
     count: integer;
begin
outNode:=nil;
count:=0;
for i:=0 to Node.Count-1 do
 if node.Item[i].Text='Вне групп' then
      begin
      outNode:=node.Item[i];
      end;
if (outNode<>nil) then outNode.DeleteChildren;
for i:=0 to rtitems.Count-1 do
 begin
  if (rtitems[i].id>-1) then
   begin
       if (rtitems.TegGroups.GetIdxByNum(rtitems[i].GroupNum)<0) then
         begin
             if (outNode=nil) then
               begin
                outNode:=TreeView1.Items.AddChild(node,'Вне групп');
                outNode.ImageIndex:=integer(ntOBase);
                outNode.SelectedIndex:=integer(ntOBase);
               end;
            count:=count+1;
            newNode:=TreeView1.Items.AddChild(outNode,rtitems.GetName(i));
            newNode.ImageIndex:=integer(ntOT);
            newNode.SelectedIndex:=integer(ntOBase);
         end;
   end;
 end;
 if (count=0) and (outNode<>nil) then
  begin
     outNode.DeleteChildren;
     TreeView1.Items.Delete(outNode);
  end;
end;


procedure TForm1.ChangeTreeMenuGroup();
var tempmenu: TMenuItem;
    i: integer;
    tmpstr: string;
    groupid: integer;
    fltemp: boolean;
begin
 fltemp:=false;
 PopupMenu1.Items[3].Visible:=(rtitems.TegGroups.Count>0);
 PopupMenu1.Items[3].Clear;
 if (rtitems.TegGroups.Count<1) then exit;
 if (TreeView1.SelectionCount=0) then exit;
 tmpstr:=TreeView1.Selections[0].Text;
 groupid:=rtitems.GetSimpleID(tmpstr);
 if (groupid>-1) then
  begin
    groupid:=rtitems[groupid].GroupNum;
  end;

 for i:=0 to rtitems.TegGroups.Count-1 do
  begin
     if (rtitems.TegGroups.Items[i].Num<>groupid) then
      begin
         tempmenu:=TMenuItem.Create(self.PopupMenu1);
         tempmenu.Caption:=rtitems.TegGroups.Items[i].Name;
         tempmenu.Tag:=i;
         tempmenu.OnClick:=ChangeOGroup;
         tempmenu.ImageIndex:=integer(gettype(rtitems.TegGroups.Items[i].App,rtitems.TegGroups.Items[i].Topic,rtitems.TegGroups.Items[i].Name));
          PopupMenu1.Items[3].Add(tempmenu);
      end else fltemp:=true;

  end;
  if (fltemp) then
    begin
         tempmenu:=TMenuItem.Create(self.PopupMenu1);
         tempmenu.Caption:='Вне групп';
         tempmenu.Tag:=-1;
         tempmenu.OnClick:=ChangeOGroup;
         tempmenu.ImageIndex:=integer(ntOBase);
          PopupMenu1.Items[3].Add(tempmenu);
      end
end;

procedure TForm1.ChangeOGroup(Sender: TObject);
var i: integer;
    num: integer;
    tmpstr: string;
    groupid: integer;
    tgid: integer;
    treenode: TTreeNode;
    list: Tlist;
begin
    list:=Tlist.Create;
    if (sender is TMenuItem) then
      begin
       if (TMenuItem(sender).Tag>-1) then
         begin
            num:=rtitems.TegGroups.Items[TMenuItem(sender).Tag].Num;
         end else num:=-1;
       for i:=0 to TreeView1.SelectionCount-1 do
        begin
           tmpstr:=TreeView1.Selections[i].Text;
           tgid:=rtitems.GetSimpleID(tmpstr);
           if (tgid>-1) then
            begin
              rtitems[tgid].GroupNum:=num;
              rtitems.WriteToFile(tgid);
            end;
        end;
        for i:=0 to TreeView1.SelectionCount-1 do
        begin
           list.Add(TreeView1.Selections[i]);
        end;
         for i:=0 to list.Count-1 do
          TreeView1.Items.Delete(TTreeNode(list.Items[i]));
      end;
      if num>-1 then
      refreshNodeNameandtype(rtitems.TegGroups.Items[TMenuItem(sender).Tag].Name,ntOl);
      TreeTagOutofGroup();
      list.Free;
end;






procedure TForm1.TreeAlTagOutofAlarmGroup();
var i: integer;
     newNode: TTreeNode;
     outNode: TTreeNode;
     count: integer;
begin

  for i := 0 to TreeView1.Items.Count - 1 do
   if ((TreeView1.Items[i].Text = 'Тревоги')) then
   begin
     TreeOutofAlarmGroup(TreeView1.Items[i]);
     exit;
   end;
end;

procedure TForm1.TreeOutofAlarmGroup(Node: TTreeNode);
var i: integer;
     newNode: TTreeNode;
     outNode: TTreeNode;
     count: integer;
begin
outNode:=nil;
count:=0;
for i:=0 to Node.Count-1 do
 if node.Item[i].Text='Вне групп тревог' then
      begin
      outNode:=node.Item[i];
      end;
if (outNode<>nil) then outNode.DeleteChildren;
for i:=0 to rtitems.Count-1 do
 begin
  if (rtitems[i].id>-1) then
   begin
       if (rtitems.AlarmGroups.GetIdxByNum(rtitems[i].AlarmGroup)<0) then
         begin
             if (outNode=nil) then
               begin
                outNode:=TreeView1.Items.AddChild(node,'Вне групп тревог');
                outNode.ImageIndex:=integer(ntGl);
                outNode.SelectedIndex:=integer(ntGl);
               end;
            count:=count+1;
            newNode:=TreeView1.Items.AddChild(outNode,rtitems.GetName(i));
            newNode.ImageIndex:=integer(ntGT);
            newNode.SelectedIndex:=integer(ntGT);
         end;
   end;
 end;
 if (count=0) and (outNode<>nil) then
  begin
     outNode.DeleteChildren;
     TreeView1.Items.Delete(outNode);
  end;
end;


procedure TForm1.ChangeTreeMenuAlarmGroup();
var tempmenu: TMenuItem;
    i: integer;
    tmpstr: string;
    groupid: integer;
    fltemp: boolean;
begin
 fltemp:=false;
 PopupMenu1.Items[4].Visible:=(rtitems.Alarmgroups.Count>0);
 PopupMenu1.Items[4].Clear;
 if (rtitems.Alarmgroups.Count<1) then exit;
 if (TreeView1.SelectionCount=0) then exit;
 tmpstr:=TreeView1.Selections[0].Text;
 groupid:=rtitems.GetSimpleID(tmpstr);
 if (groupid>-1) then
  begin
    groupid:=rtitems[groupid].AlarmGroup;
  end;

 for i:=0 to rtitems.Alarmgroups.Count-1 do
  begin
     if (rtitems.Alarmgroups.Items[i].Num<>groupid) then
      begin
         tempmenu:=TMenuItem.Create(self.PopupMenu1);
         tempmenu.Caption:=rtitems.Alarmgroups.Items[i].Name;
         tempmenu.Tag:=i;
         tempmenu.OnClick:=ChangeOAlarmGroup;
        // tempmenu.ImageIndex:=integer(nt);
          PopupMenu1.Items[4].Add(tempmenu);
      end else fltemp:=true;

  end;
  if (fltemp) then
    begin
         tempmenu:=TMenuItem.Create(self.PopupMenu1);
         tempmenu.Caption:='Вне групп тревог';
         tempmenu.Tag:=-1;
         tempmenu.OnClick:=ChangeOAlarmGroup;
        // tempmenu.ImageIndex:=integer(ntOBase);
          PopupMenu1.Items[4].Add(tempmenu);
      end
end;

procedure TForm1.ChangeOAlarmGroup(Sender: TObject);
var i: integer;
    num: integer;
    tmpstr: string;
    groupid: integer;
    tgid: integer;
    treenode: TTreeNode;
    list: Tlist;
begin

    list:=Tlist.Create;
    if (sender is TMenuItem) then
      begin
       if (TMenuItem(sender).Tag>-1) then
         begin
            num:=rtitems.Alarmgroups.Items[TMenuItem(sender).Tag].Num;
         end else num:=-1;
       for i:=0 to TreeView1.SelectionCount-1 do
        begin
           tmpstr:=TreeView1.Selections[i].Text;
           tgid:=rtitems.GetSimpleID(tmpstr);
           if (tgid>-1) then
            begin
              rtitems[tgid].AlarmGroup:=num;
              rtitems.WriteToFile(tgid);
            end;
        end;
        for i:=0 to TreeView1.SelectionCount-1 do
        begin
           list.Add(TreeView1.Selections[i]);
        end;
         for i:=0 to list.Count-1 do
          TreeView1.Items.Delete(TTreeNode(list.Items[i]));
      end;
      if num>-1 then
      refreshNodeNameandtype(rtitems.Alarmgroups.Items[TMenuItem(sender).Tag].Name,[ntGT,ntT]);
      TreeAlTagOutofAlarmGroup;
      list.Free;
end;

function TForm1.AddRTitems(num: integer;name,comment, ddeitem, onmsg, ofmsg,alarmmsg, eu:  string; newitem: TAnalogMem; save: boolean; var replaceAll: boolean ): boolean;
var i: integer;
begin
   result:=false;
   if (trim(name)='') then
       begin
          MessageDlg('Тег в строке N'+ inttostr(num) + 'пуст и не будет добавлен. ',
                        mtConfirmation, [mbYes], 0);
          exit;
       end;
    if (not tagisCorrect_(name)) then
       begin
          MessageDlg('Тег в строке N'+ inttostr(num)+' имеет некорректное имя ('+name+ ') и не будет добавлен. ',
                        mtConfirmation, [mbYes], 0);
          exit;
       end;

      if rtItems.Count = 0 then
  begin
    //isChanged := true;
    curItem := 0;
  end
  else
  begin
    // ищем, чтобы не было дубликатов

    curItem := rtitems.GetSimpleID(name);
    if (curItem>-1) then
    begin
       if not replaceAll then
            case MessageDlg('Параметр '+ name + ' существует. Изменить?',
                        mtConfirmation, [mbYes, mbAll, mbNo, mbCancel], 0) of
              mrAll: replaceAll := true;
              mrCancel:  begin result:=true;exit;  end;
              mrNo: exit;//skip this record
            end;
    end;
    if (curItem<0) then
    begin
    for  i := 0 to rtitems.Count - 1 do
      if rtItems[i].ID = -1 then
      begin
        curitem := i;
        break;
      end;
    if CurItem = -1 then
    begin
      CurItem := rtitems.Count;
    end;
    end;
    end;

    rtItems.SetName(CurItem, name);
    rtItems.SetComment(CurItem, comment);
    rtItems.SetOnMsg(CurItem, onmsg);
    rtItems.SetOffMsg(CurItem, ofmsg);
    rtItems.SetDDEItem(CurItem, ddeitem);
    rtItems.SetAlarmMsg(CurItem, alarmmsg);
    rtItems.SetEU(CurItem, eu);
    rtItems[CurItem].ID:=CurItem;
    rtItems[CurItem].Logged:=newitem.Logged;
    rtItems[CurItem].logTime:=newitem.logTime;
    rtItems[CurItem].logDB:=newitem.logDB;
   // rtItems[CurItem].DeadBaund:=newitem.DeadBaund;
    rtItems[CurItem].MinEu:=newitem.MinEu;
    rtItems[CurItem].MaxEu:=newitem.MaxEu;
    rtItems[CurItem].MinRaw:=newitem.MinRaw;
    rtItems[CurItem].MaxRaw:=newitem.MaxRaw;
    rtItems[CurItem].GroupNum:=newitem.GroupNum;
    rtItems[CurItem].alarmCase:=newitem.alarmCase;
    rtItems[CurItem].AlarmLevel:=newitem.AlarmLevel;
    rtItems[CurItem].OnMsged:=newitem.OnMsged;
    rtItems[CurItem].OffMsged:=newitem.OffMsged;
    rtItems[CurItem].AlarmConst:=newitem.AlarmConst;
    rtItems[CurItem].AlarmGroup:=newitem.AlarmGroup;
    rtItems[CurItem].Alarmed:=newitem.Alarmed;
    rtItems[CurItem].AlarmedLocal:=newitem.AlarmedLocal;
    rtItems[CurItem].ValidLevel:=0;
    rtItems[CurItem].refCount:=0;

    if CurItem = rtItems.Count then
      begin
       rtItems.Count := rtItems.Count  + 1;
   //    rtItems.FreeItem(CurItem);
      end;
    rtItems.WriteToFile(CurItem);  
end;



procedure TForm1.N21Click(Sender: TObject);
begin
   if TreeView1.SelectionCount=0 then exit;
   case TNSNodeType(TreeView1.Selected.ImageIndex) of
     ntG:  self.refreshNodeName('Тревоги');
     ntA:  self.refreshNodeName('Архив');
     ntS:  self.refreshNodeName('События');
    // ntAl: self.refreshNodeName('Архив группы');
     end;
end;

procedure TForm1.renddef1Click(Sender: TObject);
begin
   if rtitems=nil then exit;
   try
    with TFormTrDfUpdate.Create(self) do
     begin
        Exec(rtitems, getTrdef);
         free;
     end;
  finally
    if TRENDLIST_GLOBAL_TRDF<>nil then
     try
       FreeAndNil(TRENDLIST_GLOBAL_TRDF);
     except
     end;  
  end;
end;

procedure TForm1.CleareClick(Sender: TObject);
procedure removeposition(start: integer; stop: integer);
begin
   rtitems.SetName(start,rtitems.GetName(stop));
   rtitems.SetComment(start,rtitems.GetComment(stop));
   rtitems.SetDDEItem(start,rtitems.GetDDEItem(stop));
   rtitems.SetOnMsg(start,rtitems.GetOnMsg(stop));
   rtitems.SetOffMsg(start,rtitems.GetOffMsg(stop));
   rtitems.SetEU(start,rtitems.GetEU(stop));
   rtitems.SetAlarmMsg(start,rtitems.GetAlarmMsg(stop));
   rtItems[start].ID:=start;
   rtItems[start].Logged:=rtItems[stop].Logged;
   rtItems[start].logTime:=rtItems[stop].logTime;
   rtItems[start].logDB:=rtItems[stop].logDB;
//   rtItems[start].DeadBaund:=rtItems[stop].DeadBaund;
   rtItems[start].MinEu:=rtItems[stop].MinEu;
   rtItems[start].MaxEu:=rtItems[stop].MaxEu;
   rtItems[start].MinRaw:=rtItems[stop].MinRaw;
   rtItems[start].MaxRaw:=rtItems[stop].MaxRaw;
   rtItems[start].GroupNum:=rtItems[stop].GroupNum;
   rtItems[start].alarmCase:=rtItems[stop].alarmCase;
   rtItems[start].AlarmLevel:=rtItems[stop].AlarmLevel;
   rtItems[start].OnMsged:=rtItems[stop].OnMsged;
   rtItems[start].OffMsged:=rtItems[stop].OffMsged;
   rtItems[start].AlarmConst:=rtItems[stop].AlarmConst;
   rtItems[start].AlarmGroup:=rtItems[stop].AlarmGroup;
   rtItems[start].Alarmed:=rtItems[stop].Alarmed;
   rtItems[start].AlarmedLocal:=rtItems[stop].AlarmedLocal;
   rtItems[start].ValidLevel:=0;
   rtItems[start].refCount:=0;
   rtItems[stop].ID:=-1;
   rtItems.FreeItem(stop);
   rtItems.WriteToFile(stop);
   rtItems.WriteToFile(start);
end;
var i, s1, s2: integer;
    fl: boolean;
begin
  if MessageDlg('Сжать базу???', mtWarning, [mbYes, mbNo], 0) <> mrYes then exit;
  fl:=true;
  while (fl) do
  begin
  s1:=-1;
  fl:=FALSE;
  for i:=0 to rtitems.count-1 do
   begin
     if rtitems.count>0 then
     self.ProgressBar1.Position:=round(100*i/rtitems.count);
     if (s1<0) then
      begin
        if (rtitems[i].ID=-1) then s1:=i;
      end
      else
      begin
        if (rtitems[i].ID>-1) then
          begin
             s2:=i;
             removeposition(s1,s2);
             fl:=true;
             break;
             
          end;
      end;
   end;

   end;
   if s1>0 then
    rtitems.Count:=s1;
    rtitems.writeBaseToFile(false);
    self.ProgressBar1.Position:=0;
end;


// изменить имя в других группах
procedure TForm1.UpdateItemName(oldName, newName: string);
var i: integer;
begin
 for i := 0 to TreeView1.Items.Count - 1 do
   if TreeView1.Items[i].Text = oldName then
   begin
    if  (TNSNodeType(TreeView1.Items[i].ImageIndex) in tegSet) then
     begin
        TreeView1.Items[i].Text:=newName;
     end;
   end;  
end;

procedure TForm1.UpdateItem(Name: string);
var idit: integer;
begin
  idit:=rtitems.GetSimpleID(Name);
  

end;


procedure TForm1.bLeftClick(Sender: TObject);
var
  i: integer;
  DelID, NextItem: integer;
begin
  nextItem := CurItem;
  FindNextLess(NextItem) ;
  ShowTagItem(nextitem,[]);
end;

procedure TForm1.bRightClick(Sender: TObject);
var
  i: integer;
  DelID, NextItem: integer;
begin
  nextItem := CurItem;
  FindNextMore(NextItem);
  ShowTagItem(nextitem,[]);
  
end;

procedure TForm1.setbutNav;
var
  i: integer;
  cuID, NextItem: integer;
begin
    if (TreeView1.SelectionCount=1) and (TNSNodeType(TreeView1.Selected.ImageIndex) in tegset) then
    begin
    cuID:=rtitems.GetSimpleID(TreeView1.Selected.Text);
    nextItem := cuID;
    bLeft.Enabled:= FindNextLess(NextItem);
    nextItem := cuID;
    bRight.Enabled:= FindNextMore(NextItem);
    end else
    begin
      bLeft.Enabled:=false;
      bRight.Enabled:=false;
    end;

end;

procedure TForm1.N23Click(Sender: TObject);
var i: integer;
    err: boolean;
begin
  i:=0;
  self.ProgressBar1.Max:=100;
  if rtitems.Count=0 then exit;
  err:=false;
 for i:=0  to rtitems.Count-1 do
   if rtitems.TagDubleErr(i)>-1 then
   begin
   rtitems.ClearDubleErr;
   end else
   begin

   self.ProgressBar1.Position:=round(i*100/rtitems.Count);
   form1.Repaint;
   end;
 { while rtitems.TagDubleErrIs do
  begin
  i:=i+1;
  rtitems.ClearDubleErr;
  self.ProgressBar1.Position:=round(i*100/rtitems.Count);
  form1.Repaint;
  end;     }
end;

procedure TForm1.N22Click(Sender: TObject);
begin
   if MessageDlg('Удалить всю базу???', mtWarning, [mbYes, mbNo], 0) <> mrYes then exit;
  rtItems.Count := 0;
  rtItems.WriteBaseToFile(true);
  refreshNodeName('Опрос');
end;

procedure TForm1.N24Click(Sender: TObject);
begin
   try
       AddAppList(GetCurrentApp,'some');
   except
   end;
  Init:=false;
  LoadRegestry;
  setcaption('Менеджер проектов');
end;

procedure TForm1.TreeViewProjectChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);

var
  i: integer;
  temp: boolean;
  cnt: integer;
  list: Tlist;
  numGr: String;
  tempstr: Pstring;
begin

  cnt := node.Count;
  if (Node.ImageIndex=PRJ_MAIN) then
  begin
    list:=Tlist.Create;
    new(tempstr);
    tempstr^:=GetCurrentApp;
    list.Add(tempstr);
    projcoord.setList(list,prjProp);
    projcoord.refresh;
    list.Free;

  end;
   if (Node.ImageIndex=PRJ_Some) then
  begin
    list:=Tlist.Create;
    new(tempstr);
    tempstr^:=Node.Text;
    list.Add(tempstr);
    projcoord.setList(list,prjProp);
    projcoord.refresh;
    list.Free;
 
  end;

  ValueListPrj.Visible:=
  ((Node.ImageIndex=PRJ_Some) or (Node.ImageIndex=PRJ_MAIN));

end;

procedure TForm1.TreeViewProjectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbRight then
  begin
    RightClickedItemPrj := TreeViewProject.GetNodeAt(X, Y);
  end;
end;



procedure TForm1.PopupMenuPrjPopup(Sender: TObject);
var typindex_: integer;
begin
if RightClickedItemPrj <> nil then
  begin
    typindex_:=RightClickedItemPrj.ImageIndex;
    PopupMenuPrj.Items[0].Visible:=(typindex_ in [PRJ_MAIN,PRJ_SOME]);
    PopupMenuPrj.Items[1].Visible:=(typindex_ in [PRJ_MAINOLD,PRJ_SOMEOLD]);
    PopupMenuPrj.Items[2].Visible:=(typindex_ in [PRJ_SOME]);
    PopupMenuPrj.Items[3].Visible:=(typindex_ in [PRJ_TREE]);
    PopupMenuPrj.Items[4].Visible:=(typindex_ in [PRJ_TREE]);
    PopupMenuPrj.Items[5].Visible:=(typindex_ in [PRJ_TREE]);
    PopupMenuPrj.Items[6].Visible:=(typindex_ in [PRJ_SOME,PRJ_SOMEOLD]);
  end;

end;

procedure TForm1.N30Click(Sender: TObject);
  var typindex_: integer;
begin
if RightClickedItemPrj <> nil then
  begin
    typindex_:=RightClickedItemPrj.ImageIndex;
    // грузим основной
     try
       AddAppList(GetCurrentApp,'some');
     except
     end;

    if (typindex_ in [PRJ_MAIN]) then
       begin
        InitialSys;
        init:=true;
        setcaption(GetCurrentApp);
       end;
    end;

    if (typindex_ in [PRJ_SOME]) then
       begin
        SetCurrentApp(RightClickedItemPrj.Text);
        InitialSysByName(RightClickedItemPrj.Text);
        setcaption(RightClickedItemPrj.Text);
        init:=true;
       end;
end;

procedure TForm1.N29Click(Sender: TObject);
 var typindex_: integer;
begin
if RightClickedItemPrj <> nil then
  begin
     typindex_:=RightClickedItemPrj.ImageIndex;

    if (typindex_ in [PRJ_SOME,PRJ_SOMEOLD]) then
       begin
        try
         if (MessageBox(0,PChar('Удалить запись?'),'Сообщение',
                 MB_OK+MB_OKCANCEL+MB_TOPMOST+MB_ICONWARNING)= IDCANCEL	) then exit;
        DeleteAppList(RightClickedItemPrj.Text);
        TreeViewProject.Items.Delete(RightClickedItemPrj);
        RightClickedItemPrj:=nil;
        except

        end;
       end;
    end;
end;

procedure TForm1.N25Click(Sender: TObject);
var typindex_: integer;
    tempstr,oldstr: string;
begin
if RightClickedItemPrj <> nil then
 { begin
     typindex_:=RightClickedItemPrj.ImageIndex;

    if (typindex_ in [PRJ_SOMEOLD]) then
       begin
        try
        oldstr:=RightClickedItemPrj.Text;
        if (not CheckOldIni(RightClickedItemPrj.Text)) then
          begin
             MessageBox(0,PChar('Проект '+RightClickedItemPrj.Text+' содержит некорректные ссылки!  '+ char(13)+
               'и не может быть преобразован!'),'Ошибка!',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
             exit;
          end;
        tempstr:=UpgrateVer(RightClickedItemPrj.Text);
        if (tempstr<>'') then
         begin
           RightClickedItemPrj.Text:=tempstr;
           RightClickedItemPrj.ImageIndex:=PRJ_SOME;
          // DeleteAppList(oldstr);
         //  TreeViewProject.Items.Delete(RightClickedItemPrj);
          // RightClickedItemPrj:=nil;
           DeleteAppList(oldstr);
           AddAppList(tempstr,'some');
           self.LoadRegestry;
         end;
        except
           MessageBox(0,PChar('Проект '+RightClickedItemPrj.Text+' не преобразован!  '),
               'Ошибка!',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
        end;
       end;

      if (typindex_ in [PRJ_MAINOLD]) then
       begin
        try
        oldstr:=GetCurrentApp;
        tempstr:=UpgrateVer(GetCurrentApp);
        if (tempstr<>'') then
         begin
           SetCurrentApp(tempstr);
           RightClickedItemPrj.ImageIndex:=PRJ_MAIN;
           AddAppList(oldstr,'some');
         end;
        except

        end;
       end; }
   // end;
end;

procedure TForm1.N26Click(Sender: TObject);
var typindex_: integer;
    tempstr,oldstr: string;
begin
if RightClickedItemPrj <> nil then
  begin
     typindex_:=RightClickedItemPrj.ImageIndex;
     if (typindex_ in [PRJ_SOME]) then
     begin
      try
        try
       AddAppList(GetCurrentApp,'some');
      except
      end;
      SetCurrentApp(RightClickedItemPrj.Text);


      self.LoadRegestry;

      except
      end;
     end;
   end;
end;

procedure TForm1.setcaption(path: string);
begin
   self.Caption:='База тегов. Проект: '+path;
end;

procedure TForm1.NewProjClick(Sender: TObject);
var str: string;
begin
   try
       AddAppList(GetCurrentApp,'some');
   except
   end;


   
  str:=NewProjectCreate();
  if (str<>'') then
     begin

      init:=false;
      AddAppList(getCurrentApp,'some');
      SetCurrentApp(str);

      InitialSys;
      init:=true;
     end;
end;

procedure TForm1.N32Click(Sender: TObject);
var str: string;
begin
   try
       AddAppList(GetCurrentApp,'some');
   except
   end;
    str:=OpenProject();
  if (str<>'') then
     begin
      try
      init:=false;

      AddAppList(getCurrentApp,'some');
      SetCurrentApp(str);
       InitialSys;
      init:=true;
      setcaption(getCurrentApp);
      except
      end;
     end;
end;

procedure TForm1.N33Click(Sender: TObject);
var str: string;
begin
  try
       AddAppList(GetCurrentApp,'some');
  except
  end;
 str:=OpenOldProject();
   if (str<>'') then
     begin
      try
      init:=false;

      AddAppList(getCurrentApp,'some');
      SetCurrentApp(str);
      InitialSys;;
      init:=true;
      setcaption(getCurrentApp);
      except
      end;
     end;
end;

procedure TForm1.Setcontrol;
begin
  PanelActive.Visible:=init;
  PanelProject.Visible:= ((not init) or (PtojMen));
  n17.Visible:=init;
  n7.Visible:=init;
  n24.Visible:=init;
  n13.Visible:= not init;
end;

procedure TForm1.N34Click(Sender: TObject);
begin
  exportGroup;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
        InitialSys;
        init:=true;
        setcaption(GetCurrentApp);
end;

procedure TForm1.N5Click(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TForm1.ChangeGroupType(Sender: TObject);
begin
if (sender is TMenuItem) then
  begin
  if (TMenuItem(sender).ImageIndex<>TreeView1.Selected.ImageIndex) then
  ValueListItem.Color:=clGray
  else  ValueListItem.Color:=clWhite;

  ValueListItem.Enabled:=((TMenuItem(sender).ImageIndex)=(TreeView1.Selected.ImageIndex));
  itemcoord.setTypeGroups(TMenuItem(sender).ImageIndex);
  changeGrMI:=TMenuItem(sender);

  end;

end;

procedure TForm1.SystenGroupCreate(Sender: TObject);
var text: string;
    NewNode: TTreeNode;
    i: integer;
begin
   if (sender is TMenuItem) then
    begin
      case  TNSNodeType(TMenuItem(sender).ImageIndex) of
      ntOSysVar: text:='$SysVar';
      ntOSystem: text:='$System';
      ntOReport: text:='$Report';
      ntOPoint:  text:='$Pointer';
      ntOServCount: text:='$ServerCount';
      ntComands: text:='$CommandsCase';
      ntOReportcnt: text:='$ReportCount';
      end;
    rtitems.TegGroups.Add(text,'','');
    rtitems.TegGroups.SaveToFile(pathmem+'groups.cfg');
    if (TreeView1.Selected<>nil) and (TNSNodeType(TreeView1.Selected.ImageIndex)= ntO) then
      NewNode := TreeView1.Items.AddChild(TreeView1.Selected, text);
      NewNode.ImageIndex:=TMenuItem(sender).ImageIndex;
      NewNode.Data:=rtitems.TegGroups.Last;
      self.itemcoord.resetsetgroup(rtitems.TegGroups);
    end;
end;

procedure TForm1.CreateNewO(Sender: TObject);
var str: string;
    Group: PTGroup;
    trnO: TTreeNode;
    trnNew: TTreeNode;
    temp: boolean;
    i: integer;
begin
    if (sender is TMenuItem) then
      begin
      if TNSNodeType(TreeView1.Selected.ImageIndex)=ntO then
        begin
          trnO:=TreeView1.Selected;
          new(Group);
          begin
            i:=1;
            str:='NewGroup1';
            while(rtitems.TegGroups.ItemNum[str]<>-1) do
              begin
                 inc(i);
                 str:='NewGroup'+inttostr(i);
              end;
              if InputQuery('Ввод пользователя','Имя узла',Str) then
                if rtitems.TegGroups.itemNum[str] <> -1 then
                   raise Exception.Create('Группа уже существует.');
            group.Num := -1; //Когда будем добавлять в список, будет заменен на первый свободный номер группы
            group.Name := str;
            group.App := '';
            group.Topic := '';
            group.SlaveNum := 0;

            rtitems.TegGroups.Add(Group);
            rtitems.TegGroups.SaveToFile(PathMem + 'groups.cfg');

            self.itemcoord.resetsetgroup(rtitems.TegGroups);

            trnNew:=TreeView1.Items.AddChild(trnO,str);
            trnNew.Data:=Group;
            if (TMenuItem(sender).ImageIndex<>integer(ntOBase)) then
            trnNew.ImageIndex:= integer(ntOBase) else
              trnNew.ImageIndex:=integer(ntOBase)+1;

            TreeView1Change(self, trnNew);




            ChangeGroupType(sender);

            bSaveClick(sender);

            trnNew.ImageIndex:= integer(TmenuItem(sender).ImageIndex);

            itemcoord.resetsetgroup(rtitems.TegGroups);
          end;
      end;
    end;
end;

procedure TForm1.LoadMetadata(root: TTreeNode);

begin
 try
 if not Fileexists(PathMem+'\AppMetaInfo.xml') then
    CreateMetadata;
  if not Fileexists(PathMem+'\AppMetaInfo.xml') then
    begin
    MessageBox(0,PChar('Не удалось найти или создать AppMetaInfo.xml'),'Сообщение',
                 MB_OK+MB_TOPMOST+MB_ICONWARNING);
    exit;
    end;

 XMLMeta.FileName:=PathMem+'\AppMetaInfo.xml';
 XMLMeta.Active:=true;
 AddMetaNode(XMLMeta.DocumentElement, root , 'root');
 except
 end;
end;


procedure TForm1.AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string; header: boolean=true);
var i: integer;
   str: string;
   tmpTreenode: TTreenode;
   tmptype: TNSNodeType;
begin
tmptype:=gettypeMetaByname(xmlParent.LocalName);
if (tmptype=cdtMainMessageHeader) then exit;
if header then
begin
if ((tmptype<>cdtMessageHeader) and (tmptype<>cdtmeta)) then
begin
tmpTreenode:=TreeView1.Items.AddChild(parent,getTextMetaByName(xmlParent));
tmpTreenode.ImageIndex:=integer(gettypeMetaByname(xmlParent.LocalName));
end else tmpTreenode:=parent;
end else tmpTreenode:=parent;

tmpTreenode.Data:=Pointer(xmlParent);

if (tmptype=cdtmeta) then tmpTreenode.ImageIndex:=integer(cdtmeta);

for i:=0 to xmlParent.ChildNodes.Count-1 do
 begin

   AddMetaNode(xmlParent.ChildNodes[i], tmpTreenode, xmlParent.ChildNodes[i].LocalName);

 end;
end;

procedure TForm1.CreateMetadata;
var tmpXMLMeta: TXMLDocument;
    tempsl: TStringList;
    tmpXMLnode,tmpXMLnode1: IXMLNode;
begin
   if not Fileexists(PathMem+'\AppMetaInfo.xml') then
     begin

       tempsl:=TStringList.Create;
       tempsl.Add('<?xml version="1.0" encoding="UTF-8"?>');
       tempsl.Add('<meta>');

       tempsl.Add('</meta>');
       tempsl.SaveToFile(PathMem+'\AppMetaInfo.xml');
       tempsl.Free;
       try
        try
        tmpXMLMeta:=TXMLDocument.Create(self);

        tmpXMLMeta.LoadFromFile(pathMem+'\AppMetaInfo.xml');
        tmpXMLMeta.Active:=true;

        tmpXMLnode:=tmpXMLMeta.DocumentElement.AddChild('HomeList');
        tmpXMLnode1:=tmpXMLnode.AddChild('ReportArr');
        tmpXMLnode1.Attributes['name']:='StartTable';
        tmpXMLnode1.Attributes['type']:='4';
        tmpXMLnode1:=tmpXMLnode.AddChild('TrendArr');
        tmpXMLnode1.Attributes['name']:='StartTrends';
        tmpXMLMeta.DocumentElement.AddChild('ReportList');
        tmpXMLMeta.DocumentElement.AddChild('TrendList');
        tmpXMLnode:=tmpXMLMeta.DocumentElement.AddChild('MessageList');
        tmpXMLnode.AddChild('MainMessageHeader');
        tmpXMLnode.AddChild('MessageHeader');

        tmpXMLMeta.SaveToFile(PathMem+'\AppMetaInfo.xml');
        finally
          tmpXMLMeta.Free;
        end;
        except;
         Fileexists(PathMem+'\AppMetaInfo.xml');
       end;
     end;
end;


procedure TForm1.SaveMetadata;
var  arhostnameName: array [0..$FF] of Char;
     hostname: string;
     WSAData : TWSAData;
     tempXML,tempXML1: IXMLNode;
     i: integer;
begin
  if XMLMeta.Active then
  begin
  try
  WSAStartup($0101, WSAData);
  GetHostName(arhostnameName, $FF);
  WSACleanup;
  hostname:=arhostnameName;
  except
  end;
  XMLMeta.DocumentElement.Attributes['DBProvider']:=inttostr(dbmanager);
  XMLMeta.DocumentElement.Attributes['constring']:=connectionstr;
  XMLMeta.DocumentElement.Attributes['host']:=hostname;

  // добавляем группы тревог
  try
  tempXML:=XMLMeta.DocumentElement.ChildNodes.FindNode('MessageList');
    if (tempXML<>nil) and (rtItems<>nil) then
      begin
         tempXML:=tempXML.ChildNodes.FindNode('MainMessageHeader');
         if tempXML<>nil then
           begin
             tempXML.ChildNodes.Clear;
             for i:=0 to rtItems.AlarmGroups.Count-1 do
                  begin
                    tempXML1:=tempXML.AddChild('MainGroup');
                    tempXML1.Attributes['name']:=rtItems.AlarmGroups.items[i].Name;
                  end;
           end;
      end;
  except
  end;
//  XMLMeta.DOMDocument.normalize;
  XMLMeta.FileName:=PathMem+'\AppMetaInfo.xml';
  XMLMeta.SaveToFile(PathMem+'\AppMetaInfo.xml');
  XMLMeta.SaveToFile('AppMetaInfo.xml');
  end;
end;

procedure TForm1.NMetaGrClick(Sender: TObject);
var Str: string;
    tmpTN: TTreeNode;
    tmpXML: IXMLNode;
    newTN: TTreeNode;
    newXML: IXMLNode;
begin
if TreeView1.Selected=nil then exit;
tmpTN:=TreeView1.Selected;
if tmpTN.Data=nil then exit;
 begin
   tmpXML:=IXMLNode(tmpTN.Data);
   if (tmpXML<>nil) then
     begin
       case  gettypeMetaByname(tmpXML.LocalName) of

       cdtReportList:
         begin
            if InputQuery('Ввод пользователя','Имя узла',Str) then
                begin
                  newXML:=tmpXML.AddChild('ReportHeader');
                  newXML.Attributes['name']:=Str;
                  newXML.Attributes['fontsize']:='8';
                  newXML.Attributes['color']:='0';
                  newXML.Attributes['textcolor']:='8';
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
         end;

         cdtReportHeader:
         begin
            if InputQuery('Ввод пользователя','Имя группы отчетов',Str) then
                begin
                  newXML:=tmpXML.AddChild('ReportArr');
                  newXML.Attributes['name']:=Str;
                  newXML.Attributes['delt']:='0';
                  newXML.Attributes['group']:='0';
                  newXML.Attributes['width']:='50';
                  newXML.Attributes['heigth']:='200';
                  newXML.Attributes['sum']:='1';
                  newXML.Attributes['type']:='4';
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
         end;

         cdtTrendList:
         begin
            if InputQuery('Ввод пользователя','Имя узла',Str) then
                begin
                  if (Sender=N14) then
                  newXML:=tmpXML.AddChild('TrendHeader') else
                  newXML:=tmpXML.AddChild('TrendArr');
                  newXML.Attributes['name']:=Str;
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
         end;

         cdtTrendHeader:
         begin
            if InputQuery('Ввод пользователя','Имя группы графиков',Str) then
                begin
                  newXML:=tmpXML.AddChild('TrendArr');
                  newXML.Attributes['name']:=Str;
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
         end;

         cdtTrendArr:
         begin
         if (Sender=N19) then
          begin
            if InputQuery('Ввод пользователя','Имя группы отчетов',Str) then
                begin


                  newXML:=tmpXML.AddChild('TrendArr');
                  newXML.Attributes['name']:=Str;
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName));

                end;
         end;
        end;



        cdtMessageHeader:
         begin
          if (Sender=N37) then
            begin
            if InputQuery('Ввод пользователя','Имя узла',Str) then
                begin

                  newXML:=tmpXML.AddChild('Group');
                  newXML.Attributes['name']:=Str;
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
             end;
         end;

         cdtGroup:
         begin
          if (Sender=N37) then
            begin
            if InputQuery('Ввод пользователя','Имя узла',Str) then
                begin

                  newXML:=tmpXML.AddChild('Group');
                  newXML.Attributes['name']:=Str;
                  newTN:=TreeView1.Items.AddChildObject(tmpTN,Str,Pointer(newXML));
                  newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName))
                end;
             end;
         end;



        end;
     end;
 end;
end;

procedure TForm1.NnewRepTagClick(Sender: TObject);
var i: integer;
    tmpTN: TTreeNode;
    tmpXML: IXMLNode;
    newTN: TTreeNode;
    newXML: IXMLNode;
    tmpL: TStringList;
begin
  try
  tmpL:=TStringList.Create;
  tmpL.Clear;
  tmpTN:=TreeView1.Selected;
  if (tmpTN=nil) then exit;
  if  tmpTN.Data=nil then exit;
  tmpXML:=IXMLNode(tmpTN.Data);
  if tmpXML=nil then exit;
  with FMetaSelect do
    begin
       if Sender=NnewRepTag then
       begin

       if FMetaSelect.Exec(tmpL,getMetaObject,tmpXML.Attributes['type']) then
         begin
            for i:=0 to tmpL.Count-1 do
            begin
            newXML:=tmpXML.AddChild('unit');
            newXML.Attributes['tg']:=tmpL.Strings[i];
            newXML.Attributes['sumtype']:='1';
            newXML.Attributes['round']:='0';
            newTN:=TreeView1.Items.AddChildObject(tmpTN,tmpL.Strings[i],Pointer(newXML));
            newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName));
            end;
         end;
       end;
       if Sender=NnewTrendTag then
       begin
       if FMetaSelect.Exec(tmpL,getMetaObject,1000) then
         begin
            for i:=0 to tmpL.Count-1 do
            begin
            newXML:=tmpXML.AddChild('trend');
            newXML.Attributes['tg']:=tmpL.Strings[i];
            newXML.Attributes['fill']:='0';
            newXML.Attributes['fillcolor']:='00000000';
            newXML.Attributes['pencolor']:='00000000';
            newTN:=TreeView1.Items.AddChildObject(tmpTN,tmpL.Strings[i],Pointer(newXML));
            newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName));
            end;
         end;
       end;

       if Sender=NnewMessTag then
       begin
       if FMetaSelect.Exec(tmpL,getMetaObject,0) then
         begin
            for i:=0 to tmpL.Count-1 do
            begin
            newXML:=tmpXML.AddChild('msgtag');
            newXML.Attributes['tg']:=tmpL.Strings[i];
            newTN:=TreeView1.Items.AddChildObject(tmpTN,tmpL.Strings[i],Pointer(newXML));
            newTN.ImageIndex:=integer(gettypeMetaByname(newXML.LocalName));
            end;
         end;
       end;
    end;
    finally
    tmpL.Free;
    end;
end;


// смена порядка
procedure TForm1.NUpDownClick(Sender: TObject);
var str: string;
    tmpTN: TTreeNode;
    tmpXML: IXMLNode;
    tmpParTN: TTreeNode;
    tmpParXML: IXMLNode;
    newTN: TTreeNode;
    newXML: IXMLNode;
    ind: integer;
    indXML,i: integer;

begin
  tmpTN:=TreeView1.Selected;
  if (tmpTN=nil) then exit;
  if (TNSNodeType(TreeView1.Selected.ImageIndex) in ntMeta) then
    begin
     if  tmpTN.Data=nil then exit;
     tmpXML:=IXMLNode(tmpTN.Data);
     tmpParTN:=tmpTN.Parent;
     tmpParXML:=tmpXML.ParentNode;
     ind:=tmpParTN.IndexOf(tmpTN);
     indXML:=tmpParXML.ChildNodes.IndexOf(tmpXML);
     str:=tmpTN.Text;
     if tmpXML=nil then exit;
      if (Sender=Ndown) then
        begin

          tmpParXML.ChildNodes.Remove(tmpXML);
          tmpParXML.ChildNodes.Insert(indXML+1,tmpXML);
          tmpParTN.DeleteChildren;
          AddMetaNode(tmpParXML,tmpParTN,'',false);
          tmpParTN.Expand(false);
          for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;
      if (Sender=NUp) then
        begin
          tmpParXML.ChildNodes.Remove(tmpXML);
          tmpParXML.ChildNodes.Insert(indXML-1,tmpXML);
          tmpParTN.DeleteChildren;
          AddMetaNode(tmpParXML,tmpParTN,'',false);
          tmpParTN.Expand(false);
           for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;
    end;

    if (TNSNodeType(TreeView1.Selected.ImageIndex) in  ntOl) then
       begin
        str:=tmpTN.Text;
        tmpParTN:=tmpTN.Parent;
        ind:=rtitems.TegGroups.Idx[str];
        if ind<0 then exit;
        if (Sender=Ndown) then
        begin
          rtitems.TegGroups.Move(ind,ind+1);
          rtitems.TegGroups.SaveToFile(PathMem + 'groups.cfg');
          tmpParTN.DeleteChildren;
          refreshNode(tmpParTN, true);
          tmpParTN.Expand(false);
          for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;
        if (Sender=NUp) then
        begin
          rtitems.TegGroups.Move(ind,ind-1);
          rtitems.TegGroups.SaveToFile(PathMem + 'groups.cfg');
          tmpParTN.DeleteChildren;
          refreshNode(tmpParTN, true);
          tmpParTN.Expand(false);
           for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;

       end;

       if (TNSNodeType(TreeView1.Selected.ImageIndex)=ntGl) then
       begin
        str:=tmpTN.Text;
        tmpParTN:=tmpTN.Parent;
        ind:=rtitems.AlarmGroups.Idx[str];
        if ind<0 then exit;
        if (Sender=Ndown) then
        begin
          rtitems.AlarmGroups.Move(ind,ind+1);
          rtitems.AlarmGroups.SaveToFile(PathMem + 'alarmgroups.cfg');
          tmpParTN.DeleteChildren;
          refreshNode(tmpParTN, true);
          tmpParTN.Expand(false);
          for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;
        if (Sender=NUp) then
        begin
          rtitems.AlarmGroups.Move(ind,ind-1);
          rtitems.AlarmGroups.SaveToFile(PathMem + 'alarmgroups.cfg');
          tmpParTN.DeleteChildren;
          refreshNode(tmpParTN, true);
          tmpParTN.Expand(false);
           for i:=0 to tmpParTN.Count-1 do
            if tmpParTN.Item[i].Text=str then TreeView1.Select(tmpParTN.Item[i]);
        end;

       end;

end;

function TForm1.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin

try

if TRENDLIST_GLOBAL_TRDF=nil then
   begin
     try
      fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         TRENDLIST_GLOBAL_TRDF:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_TRDF.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
          // if TRENDLIST_GLOBAL_TRDF<>nil then
           //freeAndNil(TRENDLIST_GLOBAL_TRDF);
           //NSDBErrorMessage(NSDB_TRENDDEF_ERR);
         //  if fDM<>nil then fdM.Free;
         result:= TRENDLIST_GLOBAL_TRDF;
           exit;
         end
         except
           TRENDLIST_GLOBAL_TRDF:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end;
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       if fDM<>nil then fdM.Free;
     end;
    // result:=TRENDLIST_GLOBAL_ISC;
   end;

except
TRENDLIST_GLOBAL_TRDF:=nil;
end;
result:=TRENDLIST_GLOBAL_TRDF;
end;



function TForm1.getMetaObject: TObject;
begin
  if fWorkwithMem then
   begin
     result:=getTAGItems;
   end else
   begin
     result:=getTrdef;
   end
end;


procedure TForm1.Trenddef2Click(Sender: TObject);
begin
  Trenddef2.Checked:=not Trenddef2.Checked;
  WorkwithMem:= not Trenddef2.Checked;
end;

procedure TForm1.Xml1Click(Sender: TObject);
var roots: IDOMElement;
    groups_: IDOMElement;
    rtitems_: IDOMElement;
    tmpXML: IXMLNode;
    rootXML: IXMLNode;
    tempsl: TstringList;
begin
//XMLDocumentExport.ChildNodes.Clear;
if SaveDialogXml.Execute then
begin
tempsl:=TStringList.Create;
       tempsl.Add('<?xml version="1.0" encoding="UTF-8"?>');
       tempsl.Add('<root>');

       tempsl.Add('</root>');
       tempsl.SaveToFile(SaveDialogXml.FileName+'.xml');
       tempsl.Free;
       XMLDocumentExport.LoadFromFile(SaveDialogXml.FileName+'.xml');
rootXML:=XMLDocumentExport.DocumentElement;
tmpXML:=rootXML.AddChild('groups');
addExportXMLgroup(tmpXML);
tmpXML:=rootXML.AddChild('rtitems');
addExportXMLrtitems(tmpXML);
XMLDocumentExport.SaveToFile(SaveDialogXml.FileName+'.xml');
XMLDocumentExport.Active:=false;
//XMLDocumentExport.ChildNodes.Clear;

end;

end;

procedure TForm1.addExportXMLgroup(gr: IXMLNode);
var i: integer;
    tmpXML: IXMLNode;
begin
    for i:=0 to rtitems.TegGroups.Count-1 do
      begin

        tmpXML:=gr.AddChild('group');
        tmpXML.Attributes['id']:=inttostr(rtitems.TegGroups.Items[i].Num);
        tmpXML.Attributes['name']:=rtitems.TegGroups.Items[i].Name;
      end;
end;

procedure TForm1.addExportXMLrtitems(gr: IXMLNode);
var i: integer;
    tmpXML: IXMLNode;
    tmpXMLch: IXMLNode;
begin
    for i:=0 to rtitems.Count-1 do
      begin
        if (rtitems.Items[i].ID>-1) then
          begin
            tmpXML:=gr.AddChild('rtitem');
            tmpXML.Attributes['id']:=inttostr(rtitems.Items[i].ID);
            tmpXML.Attributes['name']:=rtitems.GetName(rtitems.Items[i].ID);
            tmpXML.Attributes['group']:=rtitems.TegGroups.ItemNameByNum[rtitems.Items[rtitems.Items[i].ID].GroupNum];
            tmpXML.Attributes['groupid']:=inttostr(rtitems.Items[i].GroupNum);
            tmpXMLch:=tmpXML.AddChild('comment');
            tmpXMLch.NodeValue:=rtitems.GetComment(i);
            tmpXMLch:=tmpXML.AddChild('bind');
            tmpXMLch.NodeValue:=rtitems.GetDDEItem(i);
            tmpXMLch:=tmpXML.AddChild('minraw');
            tmpXMLch.NodeValue:=rtitems.Items[i].MinRaw;
            tmpXMLch:=tmpXML.AddChild('maxraw');
            tmpXMLch.NodeValue:=rtitems.Items[i].MaxRaw;
            tmpXMLch:=tmpXML.AddChild('dbraw');
            tmpXMLch.NodeValue:=rtitems.Items[i].PreTime;
            tmpXMLch:=tmpXML.AddChild('mineu');
            tmpXMLch.NodeValue:=rtitems.Items[i].MinEu;
            tmpXMLch:=tmpXML.AddChild('maxeu');
            tmpXMLch.NodeValue:=rtitems.Items[i].MaxEu;
            tmpXMLch:=tmpXML.AddChild('eu');
            tmpXMLch.NodeValue:=rtitems.GetEU(i);
            tmpXMLch:=tmpXML.AddChild('onmsg');
            tmpXMLch.NodeValue:=rtitems[i].OnMsged;
            tmpXMLch:=tmpXML.AddChild('onmsgtext');
            tmpXMLch.NodeValue:=rtitems.GetOnMsg(i);
            tmpXMLch:=tmpXML.AddChild('offmsg');
            tmpXMLch.NodeValue:=rtitems[i].OffMsged;
            tmpXMLch:=tmpXML.AddChild('offmsgtext');
            tmpXMLch.NodeValue:=rtitems.GetOffMsg(i);
            tmpXMLch:=tmpXML.AddChild('alarmlocalmsg');
            tmpXMLch.NodeValue:=rtitems[i].AlarmedLocal;
            tmpXMLch:=tmpXML.AddChild('alarmmsg');
            tmpXMLch.NodeValue:=rtitems[i].Alarmed;
            tmpXMLch:=tmpXML.AddChild('alarmmsgtext');
            tmpXMLch.NodeValue:=rtitems.GetAlarmMsg(i);
            tmpXMLch:=tmpXML.AddChild('alarmconst');
            tmpXMLch.NodeValue:=rtitems[i].AlarmConst;
            tmpXMLch:=tmpXML.AddChild('alarmcase');
            tmpXMLch.NodeValue:=rtitems[i].alarmCase;
            tmpXMLch:=tmpXML.AddChild('log');
            tmpXMLch.NodeValue:=rtitems[i].Logged;
            tmpXMLch:=tmpXML.AddChild('db');
            tmpXMLch.NodeValue:=rtitems[i].logDB;
            tmpXMLch:=tmpXML.AddChild('type');
            tmpXMLch.NodeValue:=rtitems[i].logTime;

          end;

      end;
end;

initialization
 TRENDLIST_GLOBAL_TRDF:=nil;
finalization
 try
 if TRENDLIST_GLOBAL_TRDF<>nil then TRENDLIST_GLOBAL_TRDF.Free;
 except
end;

end.


