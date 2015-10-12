unit fJournalU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, Spin, xmldom,
  XMLIntf, RpDefine, RpRender, RpRenderCanvas, RpRenderPrinter, XPMan,
  msxmldom, XMLDoc, ImgList, ToolWin, CheckLst, ColorDBGrid, {Globalvar,} GlobalValue,
  {ColorDBGrid, }ConstDef, Buttons, IMMIBitBtn, Printers, Menus, Math, ConfigurationSys,
   dateutils, RpCon, RpConDS, RpRave, RpBase, RpSystem,
  RpRenderPDF, RpRenderRTF, RpRenderHTML,  MainDataModuleU, DBManagerFactoryU, 
  HTTPApp, HTTPProd, IWControl, IWCompMemo, OleCtrls, SHDocVw,
  RpRenderPreview;

const
   ROOT_TREE_MESSAGE=0;
   ROOT_GROUP_MESSAGE=1;
   ROOT_ITEM_MESSAGE=2;

type TMyColorDBGrid = class(TcustomDBGrid);

type
  TfJournal = class(TForm)
    PrintDialog1: TPrintDialog;
    ColorDBGrid1: TColorDBGrid;
    Panel1: TPanel;
    TreeView1: TTreeView;
    ImageList1: TImageList;
    Timer1: TTimer;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    ToolBar1: TToolBar;
    btnReq: TToolButton;
    btnLastMonth: TToolButton;
    Panel2: TPanel;
    StartTimePick: TDateTimePicker;
    StartDatePick: TDateTimePicker;
    StopTimePick: TDateTimePicker;
    StopDatePick: TDateTimePicker;
    btnLastDay: TToolButton;
    btnLastHour: TToolButton;
    CheckListBoxMessage: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    XMLInfo: TXMLDocument;
    ImageList2: TImageList;
    DataSource: TDataSource;
    TimerReq: TTimer;
    PanelDown: TPanel;
    Label3: TLabel;
    ProgressBar: TProgressBar;
    PrintBtn: TToolButton;
    ToolButton2: TToolButton;
    XPManifest1: TXPManifest;
    RvRenderPrinter1: TRvRenderPrinter;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckListBoxMessageClickCheck(Sender: TObject);
    procedure StartPickChange(Sender: TObject);
    procedure StopPickChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure btnReqClick(Sender: TObject);
    procedure TimerReqTimer(Sender: TObject);
    procedure btnLastHourClick(Sender: TObject);
    procedure btnLastDayClick(Sender: TObject);
    procedure btnLastMonthClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);

  private
    timeval: integer;
    fType: integer;
    fConstr: string;
    fGarbidgeDS: TDataSet;
    fDBMeneger: TMainDataModule;
    isRootSet: boolean;
    fJMessageType: TJournalMessageSet;
    fParameterList: TStringList;
    JThr: TJournalThread;
    fStartTime: TDateTime;
    fStopTime: TDateTime;
    procedure FreeGarbige;
    function getParameterList: TStrings;
    procedure LoadTree;
    procedure AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string);
    procedure UpdateContr();
    procedure LoadListParam(val: IXMLNode);
    function  getDBMeneger: TMainDataModule;
    procedure QueryComplete(res: TDataSet; err: integer);
   // procedure setJMessageType(val: TJournalMessageSet);
    procedure raveEx(pr: string);
    procedure ControlEnable(val: boolean);
  public
     property JMessageType: TJournalMessageSet read fJMessageType;// write setJMessageType;
     property StartTime: TDateTime read fStartTime;
     property StopTime: TDateTime read fStopTime;
     property ParameterList: TStrings read getParameterList;
     property DBMeneger: TMainDataModule read getDBMeneger;
  end;

var

  fJournal: TfJournal;
  lastformat: string;



implementation

{$R *.DFM}

function getImgIndex(val: TNSNodeType): integer;
begin

  result:=-1;
  case val of
   cdtMessageHeader: result:=ROOT_TREE_MESSAGE;
   cdtGroup: result:=ROOT_GROUP_MESSAGE;
   cdtmsgtag:  result:=ROOT_ITEM_MESSAGE;
   end;
end;

procedure TfJournal.Button1Click(Sender: TObject);
begin
     Hide;
end;


procedure TfJournal.Button2Click(Sender: TObject);
begin
     print;
end;

procedure TfJournal.raveEx(pr: string);
begin

end;

function TfJournal.getDBMeneger: TMainDataModule;
begin
   if fDBMeneger=nil then
      begin
      fDBMeneger:=TDBManagerFactory.
      buildManager(dbmanager,connectionstr,dbaAll,false,'ARcServ');
      if fDBMeneger=nil then
       begin
        result:=nil;
        exit;
       end;
   end;
   if not fDBMeneger.Conneted then
     try
       fDBMeneger.Connect;
     except
     end;
  if fDBMeneger.Conneted then
  result:=fDBMeneger else result:=nil;
end;

procedure TfJournal.FormCreate(Sender: TObject);
var
  i: integer;
  T: TDateTimeField;
begin
  JThr:=nil;
  left := 0;
  case resolution of
  r640:
    begin
     height := 392;
     width := 640;
     colordbGrid1.width := 460;
     colordbGrid1.Height := 370;
     for i := 0 to ControlCount - 1 do
       if not (controls[i] is tColorDBGrid) then
         controls[i].Left := controls[i].left - 160;
    end;
  r800:
    begin
     height := 455;
     width := 800;
    end;
  r1024:
    begin
     height := 623;
     width := 1024;
    end;
  r1280:
    begin
     top := 0;
     left := 0;
     height := 880;
     width := 1280;
    end;
  end;
  fParameterList:=TStringList.Create;
  fParameterList.Sorted:=true;
  fParameterList.Duplicates:=dupIgnore;

  fJMessageType:=[ejEvent, ejOn, ejOff, ejCommand, ejAlOn, ejAlOff, ejAlKvit];
  fStartTime:=incday(now,-1);
  fStopTime:=now;
  LoadTree;
  UpdateContr;
  isRootSet:=true;
  self.TimerReq.Enabled:=false;
end;

// перерисовка CheckList
procedure TfJournal.UpdateContr();
var i: integer;
begin
  for i:=0 to 6 do
    CheckListBoxMessage.Checked[i]:=(TJournalMessageType(i) in fJMessageType);
  StartTimePick.DateTime:=StartTime;
  StartDatePick.DateTime:=StartTime;
  StopTimePick.DateTime:=StopTime;
  StopDatePick.DateTime:=StopTime;
end;

procedure TfJournal.CheckListBoxMessageClickCheck(Sender: TObject);
var
    i: integer;
    tmp: TJournalMessageSet;
begin
tmp:=[];
for i:=0 to 6 do
  if CheckListBoxMessage.Checked[i] then
          tmp:=tmp + [TJournalMessageType(i)];
fJMessageType:=tmp;

end;

procedure TfJournal.StartPickChange(Sender: TObject);
begin
   fStartTime:=(StartTimePick.DateTime-round(StartTimePick.DateTime)*1.0)+round(StartDatePick.DateTime)*1.0;
   StartTimePick.DateTime:=fStartTime;
   StartDatePick.DateTime:=fStartTime;
   UpdateContr();
end;

procedure TfJournal.StopPickChange(Sender: TObject);
begin
  fStopTime:=(StopTimePick.DateTime-round(StopTimePick.DateTime)*1.0)+round(StopDatePick.DateTime)*1.0;
  StopTimePick.DateTime:=fStopTime;
  StopDatePick.DateTime:=fStopTime;
  UpdateContr();
end;

function TfJournal.getParameterList: TStrings;
begin
   result:=fParameterList;
end;

procedure TfJournal.FormDestroy(Sender: TObject);
begin
fParameterList.Free;
end;

procedure TfJournal.LoadTree;
var i,j: integer;
    tmpXML: IXMLNode;
    nf: string;
begin
  nf:='AppMetaInfo.xml';
  if not FileExists(nf) then
   begin
      try
        InitialSys;
        nf:=PathMem+'AppMetaInfo.xml';
         if not FileExists(nf) then
           begin
              MessageBox(0,PChar('Не найден файл конфигурации AppMetaInfo.xml!  '+ char(13)+
               'Работа с отчетами невозможна!'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
             Application.Terminate;
           end;
      except
        MessageBox(0,PChar('Не найден файл конфигурации AppMetaInfo.xml!  '+ char(13)+
               'Работа с отчетами невозможна!'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
        Application.Terminate;
      end
   end;

  if FileExists(nf) then
    begin
      XMLInfo.FileName:=nf;
      XMLInfo.Active:=true;
      if assigned(XMLInfo.DocumentElement.AttributeNodes.Nodes['DBProvider'])
        then fType:=strtointdef(XMLInfo.DocumentElement.Attributes['DBProvider'],-1);
       if assigned(XMLInfo.DocumentElement.AttributeNodes.Nodes['constring'])
        then fConstr:=XMLInfo.DocumentElement.Attributes['constring'];;
      for i:=0 to XMLInfo.DocumentElement.ChildNodes.Count-1 do
        begin
         if XMLInfo.DocumentElement.ChildNodes[i].LocalName='MessageList' then
           begin
             tmpXML:=XMLInfo.DocumentElement.ChildNodes[i];
                for j:=0 to tmpXML.ChildNodes.Count-1 do
                  begin
                    if tmpXML.ChildNodes[j].LocalName='MessageHeader' then
                      begin
                       tmpXML:=tmpXML.ChildNodes[j];
                       AddMetaNode(tmpXML,TreeView1.TopItem,'');
                       exit;
                      end;
                  end;
           end;
        end;
         XMLInfo.Active:=false;
    end else
    ShowMessage('Не найден файл конфигурации AppMetaInfo.xml');
end;


procedure TfJournal.AddMetaNode(xmlParent: IXMLNode; parent: TTreenode; nm: string);
var i: integer;
   str: string;
   tmpTreenode: TTreenode;
   tmptype: TNSNodeType;
begin
tmptype:=gettypeMetaByname(xmlParent.LocalName);
if (tmptype=cdtMainMessageHeader) then exit;

begin
if ((tmptype<>cdtMessageHeader) and (tmptype<>cdtmeta)) then
begin
tmpTreenode:=TreeView1.Items.AddChild(parent,getTextMetaByName(xmlParent));
tmpTreenode.ImageIndex:=getImgIndex(gettypeMetaByname(xmlParent.LocalName));
end else tmpTreenode:=parent;


tmpTreenode.Data:=Pointer(xmlParent);

if (tmptype=cdtmeta) then tmpTreenode.ImageIndex:=integer(cdtmeta);

for i:=0 to xmlParent.ChildNodes.Count-1 do
 begin

   AddMetaNode(xmlParent.ChildNodes[i], tmpTreenode, xmlParent.ChildNodes[i].LocalName);

 end;
end;
end;

procedure TfJournal.TreeView1Change(Sender: TObject; Node: TTreeNode);
var tmpXML: IXMLNode;
    test: string;
begin
 if Node=nil then
   begin
    fParameterList.Clear;
    exit;
   end;
 case Node.ImageIndex of
   ROOT_TREE_MESSAGE:
      begin
       fParameterList.Clear;
       isRootSet:=true;
      end;
   ROOT_GROUP_MESSAGE: begin
        fParameterList.Clear;
        if Node.Data=nil then exit;
        tmpXML:=IXMLNode(Node.Data);
        LoadListParam(tmpXML);
        isRootSet:=false;
      end;
   ROOT_ITEM_MESSAGE: begin
        fParameterList.Clear;
        fParameterList.Add(Node.Text);
      end;
    end;
  //  test:=ParameterList.GetText;
  //  test:=ParameterList.GetText;
end;

procedure TfJournal.LoadListParam(val: IXMLNode);
var tmptype: TNSNodeType;
    i: integer;
begin
 if val=nil then exit;
 tmptype:=gettypeMetaByname(val.LocalName);
 if (tmptype=cdtmsgtag) then
  begin
    if assigned(val.AttributeNodes.Nodes['tg']) then
       fParameterList.Add(val.Attributes['tg']);
  end;
 if (tmptype=cdtGroup) then
  begin
   for i:=0 to val.ChildNodes.Count-1 do
     LoadListParam(val.ChildNodes[i]);
  end;

end;

procedure TfJournal.TreeView1GetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
Node.SelectedIndex:=Node.ImageIndex;
end;

procedure TfJournal.QueryComplete(res: TDataSet; err: integer);
var recc: integer;
begin
    try
    if err=NSDB_REQEST_OK then
    begin
    fGarbidgeDS:=res;
    DataSource.DataSet:=res;
    DataSource.DataSet.Open;
    DataSource.DataSet.RecordCount;
    self.ColorDBGrid1.DataSource.DataSet.Active:=true;
    PrintBtn.Enabled:=(DataSource.DataSet.RecordCount>0);
    end
    else
    begin
    DataSource.DataSet:=nil;
    NSDBErrorMessage(err);
    PrintBtn.Enabled:=false;
    end;
    finally
    ControlEnable(true);
    end;
end;

procedure TfJournal.btnReqClick(Sender: TObject);
begin
   FreeGarbige;
   DataSource.DataSet:=nil;
   ControlEnable(false);
   JThr:=TJournalThread.create(fType,fConstr,StartTime,StopTime,JMessageType,
                                ParameterList,nil,QueryComplete);

end;

procedure TfJournal.FreeGarbige;
begin
   try
    if JThr<>nil then
      FreeAndNil(JThr);
  { if fGarbidgeDS<>nil then
     begin
       fGarbidgeDS.FreeOnRelease;
       if fGarbidgeDS.Active then
         fGarbidgeDS.Active:=false;
       fGarbidgeDS.Free;

     end; }

   except
   end;
   DataSource.DataSet:=nil;
end;

procedure TfJournal.ControlEnable(val: boolean);
begin
   btnReq.Enabled:=val;
   btnLastHour.Enabled:=val;
   btnLastDay.Enabled:=val;
   btnLastMonth.Enabled:=val;
   StartTimePick.Enabled:=val;
   StartDatePick.Enabled:=val;
   StopTimePick.Enabled:=val;
   StopDatePick.Enabled:=val;
   if not val then PrintBtn.Enabled:=val;
   if not val then
    begin
      timeval:=0;
      TimerReq.Enabled:=true;
      PanelDown.Visible:=true;
    end else
    begin
      timeval:=0;
      TimerReq.Enabled:=false;
      PanelDown.Visible:=false;
    end
end;

procedure TfJournal.TimerReqTimer(Sender: TObject);
begin
 timeval:=timeval+5;
 if timeval>99 then timeval:=0;
 ProgressBar.Position:=timeval;
end;

procedure TfJournal.btnLastHourClick(Sender: TObject);
begin
  fStartTime:=incHour(now,-1);
  fStopTime:=now;
  UpdateContr;
  btnReqClick(Sender);
end;

procedure TfJournal.btnLastDayClick(Sender: TObject);
begin
  fStartTime:=incDay(now,-1);
  fStopTime:=now;
  UpdateContr;
  btnReqClick(Sender);
end;

procedure TfJournal.btnLastMonthClick(Sender: TObject);
begin
  fStartTime:=incMonth(now,-1);
  fStopTime:=now;
  UpdateContr;
  btnReqClick(Sender);
end;

procedure TfJournal.ToolButton2Click(Sender: TObject);
begin
 self.Close;
end;

procedure TfJournal.PrintBtnClick(Sender: TObject);
var str: string;
    i,j: integer;
    ds: TDataSet;
    SS: TStringStream;
    SL: TStringList;
    prt: TPrinter;
    tmpcolor: TColor;
begin
if DataSource.DataSet=nil then
  begin
    Showmessage('Нет данных для печати!!!');
    exit;
  end;
if not DataSource.DataSet.Active then
  begin
    Showmessage('Нет данных для печати!!!');
    exit;
  end;

if DataSource.DataSet.RecordCount=0 then
  begin
    Showmessage('Нет данных для печати!!!');
    exit;
  end;
    tmpcolor:=self.ColorDBGrid1.Color;
    self.ColorDBGrid1.Color:=clWhite;
    Printer.Orientation:=Printers.poLandscape;
    self.Print;
    self.ColorDBGrid1.Color:=tmpcolor;
   {try
   SS:=TStringStream.Create('');
   SL:=TStringList.Create;
   prt:=TPrinter.Create;
   self.ColorDBGrid1.DataSource:=nil;
   SS.WriteString('<html>');
   SS.WriteString('<header>');
   SS.WriteString('</header>');
   SS.WriteString('<body>');
   SS.WriteString('<table style="border-size: 1px;">');
   SS.WriteString('<tr>');
              SS.WriteString('<td>');
              SS.WriteString('Время');
              SS.WriteString('</td>');
              SS.WriteString('<td>');
              SS.WriteString('Тег');
              SS.WriteString('</td>');
              SS.WriteString('<td>');
              SS.WriteString('Комментарий');
              SS.WriteString('</td>');
          SS.WriteString('</tr>');
  DataSource.DataSet.First;
       while (not (DataSource.DataSet.EOF)) do
       begin
          SS.WriteString('<tr>');
          SS.WriteString('<td>');
          SS.WriteString(DataSource.DataSet.FieldByName('tm').AsString);
          SS.WriteString('</td>');
          SS.WriteString('<td>');
          SS.WriteString(DataSource.DataSet.FieldByName('itag').AsString);
          SS.WriteString('</td>');
          SS.WriteString('<td>');
          SS.WriteString(DataSource.DataSet.FieldByName('icomment').AsString);
          SS.WriteString('</td>');
          SS.WriteString('</tr>');
        // if pos(uppercase('Событи'),uppercase(trim(querymy.FieldByName ('istate').asstring)))<>0 then
        // kg:=FormatDateTime('hh:nn:ss.zzz',querymy.FieldByName ('tm').Value) else
        // kg:=FormatDateTime('hh:nn:ss',querymy.FieldByName ('tm').Value);
        // fstr.Add(fillStr(trim(KG), 15)+fillStr(trim(querymy.FieldByName ('iparam').asString), 12)+fillStr(trim(querymy.FieldByName ('iState').asString),10)+fillStr(trim(querymy.FieldByName ('icomment').asString), 80){+fillStr(querymy.FieldByName ('iParam').asString,15));
       {  DataSource.DataSet.next;


       end;
     SS.WriteString('</table>');
      SS.WriteString('</body>');
      SS.WriteString('</html>');
     SL.Add(SS.DataString);
     SL.SaveToFile('test.html');
     ColorDBGrid1.DataSource:=DataSource;
     self.frxHTMLExport1.ShowModal;


     finally
     //SS.free;
    // SL.Free;
     end;   }
end;

end.
