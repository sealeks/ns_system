unit RepOfficeF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,ConfigurationSys,
  ComCtrls, StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, Spin,{Globalvar, }GlobalValue,
  ColorDBGrid, ConstDef, Buttons, IMMIBitBtn, Printers, Menus, Math, ADODB, AdoInt,
  ImgList, RpDefine, RpRender, RpRenderText, RpRenderCanvas,  DBClient,Types,

  RpRenderPrinter, dateutils, RpCon, RpConDS, RpRave, RpBase, RpSystem,
  RpRenderPDF, RpRenderRTF, RpRenderHTML, ToolWin,FormDelListU,FormDTU,SetTimiUnitU,
  xmldom, XMLIntf, msxmldom, XMLDoc, XPMan, MainDataModuleU, DBManagerFactoryU;

// необходимость установки временных периодов
type TSetUnitTime = (sutMinute, sutHour, sutDay, sutMonth, sutYear);
type TSetUnitTimeSet = set of TSetUnitTime;

type TMyColorDBGrid = class(TcustomDBGrid);

type ArrDouble = array of double;

const
   ROOT_TREE_REPORT=0;
   ROOT_GROUP_REPORT=1;
   ROOT_ARR_REPORT=2;
   ROOT_ITEM_REPORT=3;

type  TMenuReport = record
         RU: TReportUtit;
         MI: TMenuItem;
end;

type  PMenuReport = ^ TMenuReport;

type TMenuReportList = class(TList)
      private
         function  getItem(ind: integer): PMenuReport;
      public
         procedure AddReport(RU: TReportUtit;
                           MI: TMenuItem);
         function FindMenuReport(MI: TMenuItem): PMenuReport;
         function FindReport(MI: TMenuItem): TReportUtit;
         property Items[ind: integer]: PMenuReport read GetItem;
         procedure Clear;

      end;
type
  TFormReport = class(TForm)
    PrintDialog1: TPrintDialog;
    Timer1: TTimer;
    ToolBar1: TToolBar;
    ReportMenu: TPopupMenu;
    PopupMenuEditMode: TPopupMenu;
    N1: TMenuItem;
    PanelReq: TPanel;
    Label8: TLabel;
    btnRep: TToolButton;
    btSetTime: TToolButton;
    btLeft: TToolButton;
    btRight: TToolButton;
    btnNow: TToolButton;
    XMLInfo: TXMLDocument;
    ImageList2: TImageList;
    XPManifest1: TXPManifest;
    Panel2: TPanel;
    PanelHeader: TPanel;
    ReportTime: TLabel;
    LabelHeader: TLabel;
    btnBase: TToolButton;
    ViewGrid: TStringGrid;
    TimerReq: TTimer;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    PanelFooter: TPanel;
    ProgressBar1: TProgressBar;
    footerLabel: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure LoadTree;
    procedure AddMetaNode(xmlParent: IXMLNode; parent: TMenuItem; nm: string; titlerep: boolean = false);
    procedure FillReportInfo(xmlParent: IXMLNode; RU: TReportUtit);
    function  getTrdef: TTrenddefList;
    procedure btSetTimeClick(Sender: TObject);
    procedure btLeftClick(Sender: TObject);
    procedure btRightClick(Sender: TObject);
    procedure btnNowClick(Sender: TObject);
    procedure btnBaseClick(Sender: TObject);
    procedure prepareView(res: TReportTable; RU: TReportUtit);
    procedure TimerReqTimer(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ReportSelectInit;
  private
    { Private declarations }
    RL: TMenuReportList;
    fCurrReport: TReportUtit;  // текущий отчет
    ftmstt: TDateTime;  // стартовое время отчета
    ftmstp: TDateTime;  // стоповое время отчета
    fcustom: boolean;   // true - произвольный период, false - базовый
    ftp: integer;       // тип исходных данных( минутные,часовые....);
    fdelt: integer;     // смещение в подпериодах по базовому( к примеру смена начинается с 8, fdelt=8)
    fsub: boolean;      // есть группировка
    fgroup: integer;            // группировка
    fLastTipe: integer;
    fReperTime: TdateTime;
    timerpos: integer;
    initRU: TReportUtit;
    procedure setNow(tm: TDatetime);
    procedure navigatePeriod(val: integer=1);
    function  getCurrReport: TReportUtit;
    function  getReportName: string;
    function  getBaseReportPerod: integer;
    procedure UpdateViewReport;
    function  getsub: integer;
    procedure Request;
    function normalizeReport(res: TReportTable; RU: TReportUtit): TReportTable;
    function groupsReport(res: TReportTable; RU: TReportUtit): TReportTable;
    function GetAgregate(res: TReportTable; num: integer; agr_: integer): double;
  public
    procedure FetchComplete(res: TReportTable;  err: integer);
    procedure ReportSelect(Sender: TObject);
    property CurrReport: TReportUtit read getCurrReport;    // текущий отчет
    property ReportName: string read getReportName;     // отображаемое имя отчета
    property BaseReportPerod: integer read getBaseReportPerod;
    property Sub: integer read getsub;     /// возвращает группировку или 0 если ее нет
    //(группировка - к примеру смена в суточном отчете, смена=12часов, sub=12)
  end;

var
  TRENDLIST_GLOBAL_REPORT: TTrenddefList;
  FormReport: TFormReport;

function formatcolumnTime(tp: integer; tmstt: TDateTime; tmstp: TDateTime; tm: TDateTime): string;
procedure CalculateRepPeriod(tm: TDateTime; tp: integer; var tmstt: TDateTime; var tmstp: TDateTime; delt: integer; sub: integer);
procedure CalculateRepPeriodSub(tm: TDateTime; tp: integer; var tmstt: TDateTime; var tmstp: TDateTime; delt: integer; sub: integer);
function  formatPeriodReport(tp: integer; tmstt: TDateTime; tmstp: TDateTime; sub: boolean; custom_t: boolean): string;
procedure RepincPeriod(tp: integer; var tm: TDateTime; sub: integer; val: integer);
procedure RepincSubPeriod(tp: integer; var tm: TDateTime; count: integer);
function  isValidPeriod(tp: integer; stt, stp: TdateTime; group: integer): boolean;

implementation



{$R *.DFM}





// подсчет периода по реперному времени
//  tm - реперное время
//  tmstt- возвращает начало периода
//  tmstp- возвращает конец периода
//  delt- смещение
//  sub 0 если отчет по базовому периоду, иначе отчет по группировке
procedure CalculateRepPeriod(tm: TDateTime; tp: integer; var tmstt: TDateTime; var tmstp: TDateTime; delt: integer; sub: integer);
var tmp,i, l: integer;
    tmp1,tmp2: TdateTime;
begin

 

  case tp of
   REPORTTYPE_YEAR:
     begin
      tmstt:=StartOftheYear(tm);
      tmstp:=StartOftheYear(now);
     end;
   REPORTTYPE_QVART:
     begin
      tmstt:=StartOftheYear(tm);
      tmstp:=incYear(tmstt);
     end;
   REPORTTYPE_MONTH:
     begin
      tmstt:=StartOftheYear(tm);
      tmstp:=incYear(tmstt);
     end;
   REPORTTYPE_DEC:
     begin
      tmstt:=StartOftheMonth(tm);
      tmstp:=incMonth(tmstt);
     end;
   REPORTTYPE_DAY:
     begin
      tmstt:=StartOftheMonth(tm);
      tmstp:=incMonth(tmstt);
     end;
   REPORTTYPE_HOUR:
     begin
      tmstt:=StartOftheDay(tm);
      tmstp:=incDay(tmstt);
     end;
   REPORTTYPE_30MIN:
      begin
      tmstt:=StartOftheDay(tm);
      tmstp:=incDay(tmstt);
     end;
   REPORTTYPE_10MIN:
     begin
      tmstt:=trunc(tm*24)/24;
      tmstp:=tmstt+(1.0/24);
     end;
   REPORTTYPE_MIN:
      begin
       tmstt:=trunc(tm*24)/24;
      tmstp:=tmstt+(1.0/24);
     end;
  end;



   //  если смещение ненулевое инкримент  по смещению
   if delt<>0 then
    begin
     if delt<0 then
      begin
        for i:=(delt+1) to 0 do
         begin
          tmstt:=incPeriod(tp,tmstt,-1);
          tmstp:=incPeriod(tp,tmstp,-1);
         end;
      end else
       begin
        for i:=0 to (delt-1) do
         begin
          tmstt:=incPeriod(tp,tmstt,1);
          tmstp:=incPeriod(tp,tmstp,1);
         end;
      end
    end;



   //  если группировка смещение по группировке
   if sub>0 then
    begin
      CalculateRepPeriodSub(tm,tp,tmstt,tmstp,delt,sub);
    end;

    l:=DayOfTheMonth(tmstt);
    if ((tp=REPORTTYPE_DAY) and (sub=10) and (l=21)) then
    begin
       tmstp:=StartOftheMonth(incDay(tmstt,11));
    end;


end;

// подсчет периода по реперному времени
// если подсчет по группировке
//  tm - реперное время
//  tmstt- возвращает начало периода
//  tmstp- возвращает конец периода
//  delt- смещение
//  sub <>0 отчет по группировке

procedure CalculateRepPeriodSub(tm: TDateTime; tp: integer; var tmstt: TDateTime; var tmstp: TDateTime; delt: integer; sub: integer);
  var tmp,i: integer;
    tmp1,tmp2: TdateTime;
    test_tmp: TdateTime;
begin

   test_tmp:=tmstt;
   tmp1:=test_tmp;


   // проверка безопасен ли while??????
   // безопасен если дает смещение в инкрименте по подпериоду
   RepincSubPeriod(tp,test_tmp,1);

   if test_tmp<=tmp1 then exit;
   i:=0;
   tmp1:=tmstt;
   tmp2:=tmp1;

   RepincSubPeriod(tp,tmp2,sub);


   if tm<tmp1 then sub:=-abs(sub) else sub:=abs(sub);
   while (not((tmp1<=tm) and (tmp2>tm)) and (i<1000)) do
     begin
     //  tmp1:=tmp2;
      // tmp2:=tmp1;
       RepincSubPeriod(tp,tmp1,sub);
       RepincSubPeriod(tp,tmp2,sub);
       inc(i);
     end;

   tmstt:=tmp1;
   tmstp:=tmp2;

end;

//  отображение периода в заголовке
function formatPeriodReport(tp: integer; tmstt: TDateTime; tmstp: TDateTime; sub: boolean; custom_t: boolean): string;
begin
   if (tmstp>now) then tmstp:=now;
   if ((not custom_t) and (not sub)) then
     begin
     case tp of
   REPORTTYPE_YEAR:
     begin
      result:='c '+ formatdatetime('yyyy ', tmstt)+ ' по '+
      formatdatetime('yyyy', tmstp);
     end;
   REPORTTYPE_QVART:
     begin
      result:='c '+ formatdatetime('mm.yyyy ', tmstt)+ ' по '+
      formatdatetime('mm.yyyy', tmstp);
     end;
   REPORTTYPE_MONTH:
     begin
      result:='за '+formatdatetime('yyyy ', tmstt);
     end;
   REPORTTYPE_DEC:
     begin
      result:='за '+formatdatetime('mm.yyyy', tmstt);
     end;
   REPORTTYPE_DAY:
     begin
      result:='за '+formatdatetime('mm.yyyy', tmstt);
     end;
   REPORTTYPE_HOUR:
     begin
     // result:='за '+formatdatetime('dd.mm.yyyy HH', tmstt);
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy HH:nn', tmstp);
     end;
   REPORTTYPE_30MIN:
      begin
      result:='за '+formatdatetime('dd.mm.yyyy', tmstt);
     end;
   REPORTTYPE_10MIN:
     begin
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('yyyy-mm-dd HH:nn', tmstp);
     end;
   REPORTTYPE_MIN:
      begin
       result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('yyyy-mm-dd HH:nn', tmstp)
     end;
     end;
     end else
     begin
      case tp of
   REPORTTYPE_YEAR:
     begin
      result:='c '+ formatdatetime('yyyy ', tmstt)+ ' по '+
      formatdatetime('yyyy', tmstp);
     end;
   REPORTTYPE_QVART:
     begin
      result:='c '+ formatdatetime('mm.yyyy ', tmstt)+ ' по '+
      formatdatetime('mm.yyyy', tmstp);
     end;
   REPORTTYPE_MONTH:
     begin
      result:='c '+ formatdatetime('mm.yyyy ', tmstt)+ ' по '+
      formatdatetime('mm.yyyy', tmstp);
     end;
   REPORTTYPE_DEC:
     begin
      result:='c '+ formatdatetime('dd.mm.yyyy ', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy', tmstp);
     end;
   REPORTTYPE_DAY:
     begin
      result:='c '+ formatdatetime('dd.mm.yyyy', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy', tmstp);
     end;
   REPORTTYPE_HOUR:
     begin
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy HH:nn', tmstp);
     end;
   REPORTTYPE_30MIN:
      begin
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy HH:nn', tmstp);
     end;
   REPORTTYPE_10MIN:
     begin
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy HH:nn', tmstp);
     end;
   REPORTTYPE_MIN:
      begin
      result:='c '+ formatdatetime('dd.mm.yyyy HH:nn', tmstt)+ ' по '+
      formatdatetime('dd.mm.yyyy HH:nn', tmstp);
     end;
     end;
     end;

end;

//  отображение времени в заголовке колонки
function formatcolumnTime(tp: integer; tmstt: TDateTime; tmstp: TDateTime; tm: TDateTime): string;
begin

     case tp of
   REPORTTYPE_YEAR:
     begin
      result:=formatdatetime('yyyy', incsecond(tm,-1));
     end;
   REPORTTYPE_QVART:
     begin
      result:=formatdatetime('mm.yyyy', incMonth(tm,-3));
     end;
   REPORTTYPE_MONTH:
     begin
      result:=formatdatetime('mm', incsecond(tm,-1));
     end;
   REPORTTYPE_DEC:
     begin
      result:=formatdatetime('dd', incday(tm,-10));
     end;
   REPORTTYPE_DAY:
     begin
      result:=formatdatetime('dd', incsecond(tm,-1));
     end;
   REPORTTYPE_HOUR:
     begin
      result:=formatdatetime('HH', incsecond(tm,-1));
     end;
   REPORTTYPE_30MIN:
      begin
      result:=formatdatetime('HH:nn', incminute(tm,-30))+'-'+formatdatetime('HH:nn', tm);
     end;
   REPORTTYPE_10MIN:
     begin
      result:=formatdatetime('HH:nn', incminute(tm,-10))+'-'+formatdatetime('HH:nn', tm);
     end;
   REPORTTYPE_MIN:
      begin
       result:=formatdatetime('nn', incsecond(tm,-1));
     end;
     end;

end;


// инкримент по подпериоду
procedure RepincSubPeriod(tp: integer; var tm: TDateTime; count: integer);
var i: integer;
begin
    if count>0 then
    begin
      for i:=0 to (count-1) do
          tm:=incPeriod(tp,tm,1);
    end else
    begin
      for i:=(count+1) to 0 do
          tm:=incPeriod(tp,tm,-1);
    end
end;


// инкримент по периоду или группировке, если есть группировка
procedure RepincPeriod(tp: integer; var tm: TDateTime; sub: integer; val: integer);
var i: integer;
begin
    if sub<2 then
    begin
    case tp of
      REPORTTYPE_YEAR:  tm:= tm+incyear(tm,val);
      REPORTTYPE_MIN:   tm:=tm+(1.0/24)*val;
      REPORTTYPE_HOUR:  tm:=tm+1.0*val;
      REPORTTYPE_DEC:   tm:=incmonth(tm,val);
      REPORTTYPE_DAY:   tm:=incmonth(tm,val);
      REPORTTYPE_MONTH: tm:=incyear(tm,val);
      REPORTTYPE_10MIN: tm:=tm+(1.0/24)*val;
      REPORTTYPE_30MIN: tm:=tm+1.0*val;
      REPORTTYPE_QVART: tm:=incyear(tm,val);
      else tm:= tm+incyear(tm,val);
      end;
      if tm>now then tm:=now;
      end else
      begin
       for i:=0 to (sub-1) do
        tm:=incPeriod(tp,tm,val);
       if tm>now then tm:=now;

      end;
end;

/// корректен ли период( к примеру при получасовых подпериодах
/// stt=12:00 stp=12:07 некорректен = не может содержать данных

function isValidPeriod(tp: integer; stt, stp: TdateTime; group: integer): boolean;
begin
    result:=true;
    if group<1 then group:=1;
    RepincSubPeriod(tp,stt,group);
    result:=(stt<=stp);
end;

//  индекс картинки для отображения
function getImgIndex(val: TNSNodeType): integer;
begin

  result:=-1;
  case val of
   cdtReportList: result:=ROOT_TREE_REPORT;
   cdtReportHeader: result:=ROOT_GROUP_REPORT;
   cdtReportArr:  result:=ROOT_ARR_REPORT;
   cdtunit: result:=ROOT_ITEM_REPORT;
   end;
end;

//---------------------------------------



function  TMenuReportList.getItem(ind: integer): PMenuReport;
begin
     result := PMenuReport(get(ind));
end;

function TMenuReportList.FindMenuReport(MI: TMenuItem): PMenuReport;
var i: integer;
begin
   result:=nil;
   for i:=0 to count-1 do
    begin
       if items[i].MI=MI then
         begin
           result:=items[i];
           exit;
         end;
    end;
end;

function TMenuReportList.FindReport(MI: TMenuItem): TReportUtit;
var i: integer;
begin
   result:=nil;
   for i:=0 to count-1 do
    begin
       if items[i].MI=MI then
         begin
           result:=items[i].RU;
           exit;
         end;
    end;
end;

procedure TMenuReportList.AddReport(RU: TReportUtit;
                           MI: TMenuItem);
var i: integer;
    MR: PMenuReport;
begin
   if ((RU=nil) or (MI=nil)) then exit;
   if findMenuReport(MI)=nil then
     begin
        new(MR);
        MR^.RU:=RU;
        MR^.MI:=MI;
        add(MR);
     end;
end;



procedure TMenuReportList.clear;
var i: integer;
begin
   for i:=0 to count-1 do
     dispose(items[i]);
   inherited clear;
end;


//---------------------------------------



procedure PrintGrid(var DataSet:TClientDataSet);
begin

end;




procedure TFormReport.FormCreate(Sender: TObject);
var
  i: integer;
  T: TDateTimeField;
begin
 
  initRU:=nil;
  case resolution of
  r640:
    begin
     height := 392;
     width := 640;
    // dbGrid1.width := 460;
   //  dbGrid1.Height := 370;
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
  fLastTipe:=-1;
  RL:=TMenuReportList.Create;
  fCurrReport:=nil;
  LoadTree;
  ViewGrid.ColCount:=0;
  ViewGrid.RowCount:=0;
  UpdateViewReport;
  PanelReq.Visible:=false;
  TimerReq.Enabled:=false;
  timerpos:=0;
end;


procedure TFormReport.LoadTree;
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



    begin
      XMLInfo.FileName:=nf;
      XMLInfo.Active:=true;
      if assigned(XMLInfo.DocumentElement.AttributeNodes.Nodes['DBProvider'])
        then dbmanager:=strtointdef(XMLInfo.DocumentElement.Attributes['DBProvider'],-1);
       if assigned(XMLInfo.DocumentElement.AttributeNodes.Nodes['constring'])
        then connectionstr:=XMLInfo.DocumentElement.Attributes['constring'];;
      for i:=0 to XMLInfo.DocumentElement.ChildNodes.Count-1 do
        begin

        if XMLInfo.DocumentElement.ChildNodes[i].LocalName='HomeList' then
           begin
             tmpXML:=XMLInfo.DocumentElement.ChildNodes[i];
             AddMetaNode(tmpXML,ReportMenu.Items,'',true);
                   //    exit;

           end;

         if XMLInfo.DocumentElement.ChildNodes[i].LocalName='ReportList' then
           begin
             tmpXML:=XMLInfo.DocumentElement.ChildNodes[i];
             AddMetaNode(tmpXML,ReportMenu.Items,'');
                 //      exit;

           end;
        end;
          if InitRU<>nil then
            begin
             self.fCurrReport:=InitRU;
             ReportSelectInit;
            end;
         XMLInfo.Active:=false;
    end
end;


procedure TFormReport.AddMetaNode(xmlParent: IXMLNode; parent: TMenuItem; nm: string; titlerep: boolean = false);
var i: integer;
   str: string;
   tmpTI: TMenuItem;
   tmptype: TNSNodeType;
   ffHeader: string;
   ffFooter: string;
   fftypeEl: integer;
   ffresult_: boolean;
   ffwidth: integer;
   ffheight: integer;
   ffdelt: integer;
   ffgroup: integer;
   ffinitperiod: boolean;
   ffautoprint: boolean;
   ffautoclose: boolean;
   ffsubperiod: boolean;
   tempRU: TReportUtit;
begin
tmptype:=gettypeMetaByname(xmlParent.LocalName);
if not ((tmptype=cdtReportHeader) or
        (tmptype=cdtReportArr) or
        (tmptype=cdtReportList) or (tmptype=cdtHomeList)) then exit;



if ((tmptype<>cdtReportList) and (not titlerep)) then
begin
tmpTI:=TMenuItem.Create(self.ReportMenu);
tmpTI.Caption:=getTextMetaByName(xmlParent);
tmpTI.ImageIndex:= getImgIndex(tmptype);
parent.Add(tmpTI);
end else tmpTI:=parent;

if (tmptype=cdtReportArr) then
begin
   ffHeader:=xmlParent.LocalName;
   fftypeEl:=4;
   ffresult_:=true;
   ffwidth:=400;
   ffheight:=300;
   ffdelt:=0;
   ffgroup:=0;
   ffinitperiod:=false;
   ffsubperiod:=false;
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['name']) then
      ffHeader:=IXMLNode(xmlParent).Attributes['name'];
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['type']) then
      fftypeEl:=strtointdef(IXMLNode(xmlParent).Attributes['type'],4);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['sum']) then
      ffresult_:=(strtointdef(IXMLNode(xmlParent).Attributes['sum'],0)=1);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['width']) then
      ffwidth:=strtointdef(IXMLNode(xmlParent).Attributes['width'],400);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['height']) then
      ffheight:=strtointdef(IXMLNode(xmlParent).Attributes['height'],300);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['delt']) then
      ffdelt:=-strtointdef(IXMLNode(xmlParent).Attributes['delt'],0);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['group']) then
      ffgroup:=strtointdef(IXMLNode(xmlParent).Attributes['group'],0);
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['initperiod']) then
      ffinitperiod:=(IXMLNode(xmlParent).Attributes['initperiod']='1');
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['subperiod']) then
      ffsubperiod:=(IXMLNode(xmlParent).Attributes['subperiod']='1');
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['autoprint']) then
      ffautoprint:=(IXMLNode(xmlParent).Attributes['autoprint']='1');
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['autoclose']) then
      ffautoclose:=(IXMLNode(xmlParent).Attributes['autoclose']='1');
   if assigned(IXMLNode(xmlParent).AttributeNodes.Nodes['footer']) then
      ffFooter:=IXMLNode(xmlParent).Attributes['footer'];
   tempRU:=TReportUtit.create( ffHeader,fftypeEl,ffresult_,ffwidth,ffheight,ffdelt,ffgroup,ffinitperiod,ffsubperiod,ffautoprint,ffautoclose,ffFooter);
   FillReportInfo(xmlParent,tempRU);
   if (titlerep) then
   InitRU:=tempRU else
   begin
   RL.AddReport(tempRU,tmpTI);
   tmpTI.OnClick:=reportSelect;
   end
end else
begin
for i:=0 to xmlParent.ChildNodes.Count-1 do
 begin
   AddMetaNode(xmlParent.ChildNodes[i], tmpTI, xmlParent.ChildNodes[i].LocalName, (tmptype=cdtHomeList));

 end;  
end;
end;

procedure TFormReport.FillReportInfo(xmlParent: IXMLNode; RU: TReportUtit);
var tmptype: TNSNodeType;
    tmpchtype: TNSNodeType;
    xmltmp: IXMLNode;
    i: integer;
    ftg: string;
    feu: string;
    fcomment: string;
    fcod: integer;
    ftypeEl: integer;
    fagrType: integer;
    frnd: integer;
    tmpTD: TTrenddefList;
    tmprec: PTrenddefRec;
begin
 if xmlParent=nil then exit;
 if RU=nil then exit;
 tmptype:=gettypeMetaByname(xmlParent.LocalName);
 if tmptype<>cdtReportArr then exit;
 for i:=0 to xmlParent.ChildNodes.Count-1 do
 begin
   xmltmp:=xmlParent.ChildNodes[i];
   tmpchtype:=gettypeMetaByname(xmltmp.LocalName);
   if tmpchtype=cdtUnit then
    begin
     ftg:='';
     feu:='';
     fcomment:='';
     fcod:=-1;
     ftypeEl:=4;
     fagrType:=1;
     frnd:=2;
     if assigned(IXMLNode(xmltmp).AttributeNodes.Nodes['tg']) then
      ftg:=IXMLNode(xmltmp).Attributes['tg'];
     if assigned(IXMLNode(xmltmp).AttributeNodes.Nodes['sumtype']) then
      fagrType:=strtointdef(IXMLNode(xmltmp).Attributes['sumtype'],0);
     if assigned(IXMLNode(xmltmp).AttributeNodes.Nodes['round']) then
      frnd:=strtointdef(IXMLNode(xmltmp).Attributes['round'],2);
      // begin
       //  tmprec:=tmpTD.GetInfo(ftg);
        //  if tmprec<>nil then
        //    begin
          //     feu:=tmprec^.eu;
           //    fcomment:=tmprec^.comment;
           //    fcod:=tmprec^.cod;
               //ftypeEl:=tmprec^.logtime;
       RU.AddItems(ftg,fagrType,frnd);
             //  RU.AddItems(ftg,feu,fcomment,fcod,ftypeEl,fagrType,frnd)
          //  end;
     //  end;


    end;
 end;
end;

function  TFormReport.getCurrReport: TReportUtit;
begin
  result:=fCurrReport;
end;

procedure TFormReport.ReportSelect(Sender: TObject);
var i: integer;
begin
  fCurrReport:= RL.FindReport(TMenuItem(Sender));
  if fCurrReport=nil then
    begin
       fCurrReport:=nil;
       exit;
    end;
  if not fCurrReport.Init then
   begin
     if self.getTrdef=nil then
        begin
         fCurrReport:=nil;
         exit;
        end;
     if self.getTrdef.Count>0 then
     fCurrReport.initItems(self.getTrdef) else exit;
   end;
  fcustom:=false;
  ftp:=getBaseReportPerod;
  fdelt:=fCurrReport.delt;
  fsub:=fCurrReport.SubPeriod;
  fgroup:=fCurrReport.group;
  fReperTime:=now;


  setNow(now);

  fReperTime:= ftmstt;

  fLastTipe:=ftp;

  if getCurrReport.InitPeriod then
   begin
    RepincPeriod(ftp,ftmstt,sub,-1);
    RepincPeriod(ftp,ftmstp,sub,-1);
   end;



  UpdateViewReport;
  Request;

end;


procedure TFormReport.ReportSelectInit;
var i: integer;
begin

  if fCurrReport=nil then
    begin
       fCurrReport:=nil;
       exit;
    end;
  if not fCurrReport.Init then
   begin
     if self.getTrdef=nil then
        begin
         fCurrReport:=nil;
         exit;
        end;
     if self.getTrdef.Count>0 then
     fCurrReport.initItems(self.getTrdef) else exit;
   end;
  fcustom:=false;
  ftp:=getBaseReportPerod;
  fdelt:=fCurrReport.delt;
  fsub:=fCurrReport.SubPeriod;
  fgroup:=fCurrReport.group;
  fReperTime:=now;


  setNow(now);

  fReperTime:= ftmstt;

  fLastTipe:=ftp;

  if getCurrReport.InitPeriod then
   begin
    RepincPeriod(ftp,ftmstt,sub,-1);
    RepincPeriod(ftp,ftmstp,sub,-1);
   end;



  UpdateViewReport;
  Request;
  

end;

function  TFormReport.getReportName: string;
begin
   result:='';
   if getCurrReport<>nil then
     result:=getCurrReport.Header;
end;

function  TFormReport.getBaseReportPerod: integer;
begin
   result:=REPORTTYPE_NONE;
       if getCurrReport<>nil then
          result:=getCurrReport.typeEl;
end;

procedure TFormReport.setNow(tm: TDatetime);
var tmpst, tmpsp: string;
    tmpgroup: integer;
begin
  fReperTime:=tm;

  CalculateRepPeriod(fReperTime,
      getBaseReportPerod,
      ftmstt, ftmstp, fdelt,sub);

  tmpst:=datetimetostr(ftmstt);
  tmpsp:=datetimetostr(ftmstp);


  if not fsub then
  begin
  if ftmstt>fReperTime then
        begin
         RepincPeriod(ftp,ftmstt,0,-1);
         RepincPeriod(ftp,ftmstp,0,-1);
        end;

  if ftmstp<fReperTime then
        begin
         RepincPeriod(ftp,ftmstt,0,+1);
         RepincPeriod(ftp,ftmstp,0,+1);
        end;
  end;
  if ((sub=0) and (fgroup>1)) then
    tmpgroup:=fgroup else tmpgroup:=1;
  if not isValidPeriod(ftp,ftmstt,ftmstp,tmpgroup) then
      begin
         RepincPeriod(ftp,ftmstt,sub,-1);
         RepincPeriod(ftp,ftmstp,sub,-1);
      end;

end;


procedure TFormReport.navigatePeriod(val: integer=1);
var  tmp_tm: TDateTime;
     tmp_str: string;
begin
   if (getCurrReport=nil) then exit;
   fReperTime:=(ftmstp+ftmstt)/2;
   tmp_str:=datetimetostr(fReperTime);
   RepincPeriod(BaseReportPerod,fReperTime,sub,val);
   tmp_str:=datetimetostr(fReperTime);
   CalculateRepPeriod(fReperTime,
   getBaseReportPerod,
   ftmstt, ftmstp, fdelt,sub);

   UpdateViewReport;
end;


// отчет по подгруппам
// если 0 тогда выводим в базовом периоде
function TFormReport.getsub: integer;
begin
   result:=0;
   if (getCurrReport=nil) then exit;
   if  getCurrReport.SubPeriod then exit;
   result:=getCurrReport.group;
   if result<2 then
     begin
        result:=0;
        exit;
     end;
end;

procedure TFormReport.UpdateViewReport;
var tmp_tp: integer;
begin
   tmp_tp:=getBaseReportPerod;
   PanelHeader.Visible:=(getCurrReport<>nil);
   LabelHeader.Caption:=getReportName;
   ReportTime.Caption:=formatPeriodReport(ftp,ftmstt,ftmstp,(sub=0),fcustom);
   btSetTime.Visible:=(tmp_tp<>REPORTTYPE_NONE);
   btLeft.Visible:=(tmp_tp<>REPORTTYPE_NONE) and (not fcustom);
   btRight.Visible:=((tmp_tp<>REPORTTYPE_NONE) and (ftmstp<now)) and (not fcustom);
   btnNow.Visible:=((tmp_tp<>REPORTTYPE_NONE) and (ftmstp<now)) and (not fcustom);
   btnBase.Visible:=fcustom;
end;




procedure TFormReport.btSetTimeClick(Sender: TObject);
var tmp_ftmstt: TDateTime;
    tmp_ftmstp: TDateTime;
    tmp_fcustom: boolean;
    tmp_ftp: integer;

begin
if SetTimeForm=nil then SetTimeForm:=TSetTimeForm.Create(self);
if SetTimeForm=nil then exit;
   tmp_ftmstt:=ftmstt;
   tmp_ftmstp:=ftmstp;
   tmp_fcustom:=fcustom;
   tmp_ftp:=ftp;
   if SetTimeForm.Exec(tmp_ftp,tmp_ftmstt,tmp_ftmstp,tmp_fcustom,fdelt,sub) then
     begin
        ftmstt:=tmp_ftmstt;
        ftmstp:=tmp_ftmstp;
        fcustom:=tmp_fcustom;
        UpdateViewReport;
        Request;
     end;
end;



procedure TFormReport.btLeftClick(Sender: TObject);
begin
navigatePeriod(-1);
UpdateViewReport;
Request;
end;

procedure TFormReport.btRightClick(Sender: TObject);
begin
navigatePeriod(1);
UpdateViewReport;
Request;
end;


procedure TFormReport.btnBaseClick(Sender: TObject);
begin
fcustom:=false;
fReperTime:=(ftmstp+ftmstt)/2;
 CalculateRepPeriod(fReperTime,
   getBaseReportPerod,
   ftmstt, ftmstp, fdelt,sub);
UpdateViewReport;
end;

procedure TFormReport.btnNowClick(Sender: TObject);
begin
setNow(now);
UpdateViewReport;
Request;
end;

procedure TFormReport.FetchComplete(res: TReportTable;  err: integer);
var i,j: integer;
begin
    btnRep.Enabled:=true;
    btSetTime.Enabled:=true;
    btLeft.Enabled:=true;
    btRight.Enabled:=true;
    btnNow.Enabled:=true;
    btnBase.Enabled:=true;

    PanelReq.Visible:=false;
    PanelFooter.Visible:=(fCurrReport<>nil) and (fCurrReport.Footer<>'');
    if (PanelFooter.Visible) then
       begin
         footerlabel.Caption:=fCurrReport.Footer;
       end;
    TimerReq.Enabled:=true;
    if err=NSDB_REQEST_OK then
    begin
    try
    prepareView(res,self.getCurrReport);
     if fCurrReport<>nil then
        if fCurrReport.fautoprint then
        ToolButton1Click(nil);
        if fCurrReport.fautoclose then
        self.Close;
    except
    end;
    end
    else NSDBErrorMessage(err);
end;

procedure TFormReport.Request;
var RThr: TReportThread;
begin
    if getCurrReport=nil then
      begin
        ShowMessage('Не инициализирован отчет');
      end;

    RThr:=TReportThread.create(dbmanager,connectionstr, ftmstt, ftmstp,
                       FetchComplete, fCurrReport);
    btnRep.Enabled:=false;
    btSetTime.Enabled:=false;
    btLeft.Enabled:=false;
    btRight.Enabled:=false;
    btnNow.Enabled:=false;
    btnBase.Enabled:=false;
    PanelReq.Visible:=true;
    TimerReq.Enabled:=true;
    timerpos:=0;
end;

// нормализация
// отсутствующие периоды заполняются  NILL_ANALOGDOUBLE
function TFormReport.normalizeReport(res: TReportTable; RU: TReportUtit): TReportTable;
var i,j,k, tmpcount: integer;
    tmp: TReportTable;
    _ftmstt, _ftmstp, iter_tm, tm_now: TdateTime;
begin
    try
    _ftmstt:=ftmstt;
    _ftmstp:=ftmstp;
    tm_now:=now;
    tmpcount:=0;
    iter_tm:=_ftmstt;
    iter_tm:=incPeriod(ftp,iter_tm,1);
    while ((iter_tm<=_ftmstp) and (iter_tm>_ftmstt) and (iter_tm<tm_now)) do
      begin

        _ftmstt:=iter_tm;
        iter_tm:=incPeriod(ftp,iter_tm,1);
        inc(tmpcount);
      end;

    setlength(tmp.tab,tmpcount);

    _ftmstt:=ftmstt;
    _ftmstp:=ftmstp;
    iter_tm:=_ftmstt;
    iter_tm:=incPeriod(ftp,iter_tm,1);
    tmpcount:=0;

    for i:=0 to length(tmp.tab)-1 do
    //  for j:=0 to length(res.tab[i])-1 do
       begin

        _ftmstt:=iter_tm;
        setlength(tmp.tab[i],ru.Count+1);
        if (_ftmstt<tm_now) then
        begin
        if (res.count>tmpcount) and (res.tab[tmpcount][0]=_ftmstt) then
          begin
            tmp.tab[i][0]:=res.tab[tmpcount][0];
            for k:=1 to ru.Count do
              tmp.tab[i][k]:=res.tab[tmpcount][k];
            tmpcount:=tmpcount+1;

          end else
          begin
            tmp.tab[i][0]:=_ftmstt;
            for k:=1 to ru.Count do
              tmp.tab[i][k]:=NILL_ANALOGDOUBLE;
          end;
          end;
        iter_tm:=incPeriod(ftp,iter_tm,1);
       end;
   tmp.count:= length(tmp.tab);
   finally
   for i:=0 to res.count-1 do
    setlength(res.tab[i],0);
    setlength(res.tab,0);
    res.count:=0;
   result:=tmp;
   end;
end;

// сведение итогов по группировке
function TFormReport.groupsReport(res: TReportTable; RU: TReportUtit): TReportTable;
var i,j,k,l, tmpcount: integer;
    tmp: TReportTable;
    tmp_cnt: TReportTable;
    _ftmstt, _ftmstp, iter_tm, tm_now: TdateTime;
begin
   try
     tmpcount:=trunc(length(res.tab)/fgroup);
    if (trunc(length(res.tab)/fgroup)<>length(res.tab)/fgroup) then
         tmpcount:=tmpcount+1;

    setlength(tmp.tab,tmpcount);
    setlength(tmp_cnt.tab,tmpcount);
    tmp_cnt.count:=tmpcount;
    tmp.count:=tmpcount;

     for i:=0 to length(tmp.tab)-1 do
       begin
       setlength(tmp.tab[i],length(res.tab[0]));
        for j:=0 to length(tmp.tab[i])-1 do
          tmp.tab[i][j]:=0;
       end;
     for i:=0 to length(tmp_cnt.tab)-1 do
        begin
        setlength(tmp_cnt.tab[i],length(res.tab[0]));
        for j:=0 to length(tmp_cnt.tab[i])-1 do
          tmp_cnt.tab[i][j]:=0;
        end;

    for i:=0 to length(res.tab)-1 do
     begin
       if i<length(res.tab) then
       begin
        if ((i div fgroup)=(i/fgroup)) then tmp.tab[i div fgroup][0]:=res.tab[i][0];
        for j:=1 to length(res.tab[i])-1 do
          begin
            if (res.tab[i][j]<>NILL_ANALOGDOUBLE) then
              begin

                tmp.tab[i div fgroup][j]:=tmp.tab[i div fgroup][j]+res.tab[i][j];
                tmp_cnt.tab[i div fgroup][j]:=tmp_cnt.tab[i div fgroup][j]+1;
              end;
          end;
        end;  
     end;


     for i:=0 to length(tmp.tab)-1 do
     begin
        for j:=1 to length(tmp.tab[i])-1 do
          begin
            if (tmp_cnt.tab[i][j]>0) then
            begin
             if ru.GetAGR(j)=REPORTAGR_MID then
              tmp.tab[i][j]:=tmp.tab[i][j]/tmp_cnt.tab[i][j];
            end else tmp.tab[i][j]:=NILL_ANALOGDOUBLE;

          end;
     end;
   finally
   for i:=0 to res.count-1 do
    setlength(res.tab[i],0);
    setlength(res.tab,0);
    res.count:=0;
   
   end;

   result:=tmp;

end;


//  получение итога
function TFormReport.GetAgregate(res: TReportTable; num: integer; agr_: integer): double;
var i,j,k: integer;
    tmp_cnt:  integer;
    _ftmstt, _ftmstp, iter_tm, tm_now: TdateTime;
begin

    tmp_cnt:=0;
    result:=0;

    for i:=0 to length(res.tab)-1 do
      if res.tab[i][num]<>NILL_ANALOGDOUBLE then
      begin
      result:=result+res.tab[i][num];
      tmp_cnt:=tmp_cnt+1;
      end;

    if tmp_cnt<1 then
      begin
         result:=NILL_ANALOGDOUBLE;
         exit;
      end;

    if result<>NILL_ANALOGDOUBLE then
      case agr_ of
        REPORTAGR_INTEG: result:=result;
        else  result:=result/tmp_cnt;
      end;


end;


//  подготовка и вывод отчета
procedure TFormReport.prepareView(res: TReportTable; RU: TReportUtit);
var i,j: integer;
    tmp_agr:  Double;
    restmp: TReportTable;
begin
    restmp:=normalizeReport(res,RU);
    if ((sub=0) and (fgroup>0)) then
           restmp:=groupsReport(restmp,RU);
    ViewGrid.ColCount:=restmp.count+2;
    ViewGrid.RowCount:=length(restmp.tab[0]);
    if ViewGrid.ColCount>2 then
     begin
     ViewGrid.Cells[0,0]:='Параметер';
     ViewGrid.Cells[1,0]:='Ед. изм.';
     for i:=0 to 1 do
            for j:=1 to length(restmp.tab[0])-1 do
             begin
              if ((Ru.Count>(j-1)) and (i=0)) then
              ViewGrid.Cells[i,j]:=Ru.GetComment(j-1);
              if ((Ru.Count>(j-1)) and (i=1)) then
              if (trim(Ru.GetEu(j-1))='') then
              ViewGrid.Cells[i,j]:='н.д'
              else ViewGrid.Cells[i,j]:=Ru.GetEu(j-1);
             end;


        for i:=0 to restmp.count-1 do
            for j:=0 to length(restmp.tab[i])-1 do
               if j=0 then
               ViewGrid.Cells[i+2,j]:=formatcolumnTime(ru.typeEl, ftmstt, ftmstp,restmp.tab[i][j])
               else
               begin
               if (NILL_ANALOGDOUBLE<>restmp.tab[i][j]) then
               ViewGrid.Cells[i+2,j]:=trim(format(Ru.GetFormat(j-1),[restmp.tab[i][j]])) else
               ViewGrid.Cells[i+2,j]:='-';
               end;
        if ru.result_ then
          begin
            ViewGrid.ColCount:=ViewGrid.ColCount+1;
            ViewGrid.Cells[ViewGrid.ColCount-1,0]:='Итого';
            for i:=1 to ViewGrid.RowCount-1 do
              begin
                tmp_agr:=GetAgregate(restmp,i,ru.GetAGR(i-1));
                if tmp_agr<>NILL_ANALOGDOUBLE then
                ViewGrid.Cells[ViewGrid.ColCount-1,i]:=trim(format(Ru.GetFormat(i-1),[tmp_agr]))
                else ViewGrid.Cells[ViewGrid.ColCount-1,i]:='-';
              end;
          end;
     end else
       begin
        ViewGrid.ColCount:=0;
        ViewGrid.RowCount:=0;
       end;

end;

function TFormReport.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin
 if (csDesigning  in ComponentState) then
  begin
      result:=nil;
      exit;
  end;
try

if TRENDLIST_GLOBAL_REPORT=nil then
   begin
     try
      fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         //if fDM.Connected then
         TRENDLIST_GLOBAL_REPORT:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_REPORT.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
           if TRENDLIST_GLOBAL_REPORT<>nil then
           freeAndNil(TRENDLIST_GLOBAL_REPORT);
           NSDBErrorMessage(NSDB_TRENDDEF_ERR);
           exit;
         end
         except
           TRENDLIST_GLOBAL_REPORT:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       if fDM<>nil then fdM.Free;
     end;
    // result:=TRENDLIST_GLOBAL_ISC;
   end;

except
TRENDLIST_GLOBAL_REPORT:=nil;
end;
result:=TRENDLIST_GLOBAL_REPORT;
end;




procedure TFormReport.TimerReqTimer(Sender: TObject);
begin
  timerpos:=timerpos+5;
  progressBar1.Position:=timerpos;
end;

procedure TFormReport.ToolButton2Click(Sender: TObject);
begin
self.Close;
end;

procedure TFormReport.ToolButton1Click(Sender: TObject);
begin
   ToolBar1.Visible:=false;
   WindowState:=   wsNormal;
   borderstyle:=bsNone;
   ClientHeight:= (ViewGrid.DefaultRowHeight) * ViewGrid.RowCount + 120 + 20 + 80;
   ClientWidth:= (ViewGrid.DefaultColWidth) * (ViewGrid.ColCount-1) +500 + 30;
   Printer.Orientation:=Printers.poLandscape;
   Print;
   //showmessage(inttostr(ClientWidth));
   borderstyle:=bsSizeable;
   WindowState:=   wsMaximized;
   ToolBar1.Visible:=true;
end;

initialization
 TRENDLIST_GLOBAL_REPORT:=nil;
finalization
 try
 if TRENDLIST_GLOBAL_REPORT<>nil then TRENDLIST_GLOBAL_REPORT.Free;
 except
end;


end.
