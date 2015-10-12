unit fTrendU;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Grids, DBGrids, Db, DBTables, ExtCtrls, Spin,
  TeeProcs, TeEngine, Chart, DBChart, Series, constdef,
  Buttons, Math, DateUtils, ToolWin, TeeFunci,  CustomizeDlg, dxCore,SelectFormVCLU,
  dxButton, ImmibuttonXp, TrackBarDouble,{ debugClasses, TrackBarDouble,  }
  ActnMan, ActnCtrls, jpeg, SYButton, GlobalValue,DBManagerFactoryU,MainDataModuleU,
  ImmiScopeStatic, Scope, ImgList, XPMan, xmldom, XMLIntf, msxmldom, XMLDoc, ConfigurationSys ;

const
//Величина изменения масштаба графика (в %) при нажатии кнопок + -
  ZoomValue = 25;
//Цвет линии при движении горизонтального верхнего trackbar
  TimeLineColor = clAqua;
//Цвет линии при движении горизонтального нижнего trackbar
  ZoomLineColor = clAqua;
//Начало суток
  lBound = '00:00:01';
//Минимум и максимум временной оси
  MaxTrendLength: TDateTime = 1; //Нельзя просматривать график больше года длины
  MinTrendLength: TDateTime = 1 / 24 / 3600 / 100; //10 мсек
  WMU_DRAWAXIS = WM_USER + 1000;

//----------------
  TEST_MODE = true;
//----------------

type

//Горизонтальная и вертикальная оси
  TAxis = (BottomAx, LeftAx);
//TrackBar для изменения значений по временной оси и TrackBar для увеличения по горизонтали
  TTrackBarKind = (tbTime, tbZoom);

  TPenProp = record
    name: string;
    MinEu, MaxEu: double;
    EU: string;
    logCod: integer;
    comment: string;
  end;

  TseriesData = Class (tObject)
  private
    fcA, fcB: double;
  public
    dataStrt, dataLng: TDateTime;
    firstpoint, lastpoint: longint; //добавленные вымышленые точки, для продолжения графика
    pen: tbutton;
    penNum: integer;
    penLbl :tlabel;
    penShp: tShape;
    PP: TPenProp;
    procedure SetAB(A, B: double);
    constructor Create;
    property cA: double read fcA;
    property cB: double read fcB;
  end;


  TfTrend = class(TForm)
    bTime: TCtrlGrArchButton;
    bLeft100: TImmiGraphButton;
    Bleft50: TImmiGraphButton;
    bout: TImmiGraphButton;
    bIn: TImmiGraphButton;
    bRight50: TImmiGraphButton;
    bRight100: TImmiGraphButton;
    bNow: TImmiGraphButton;
    Panel_4: TPanel;
    Panel_3: TPanel;
    ImmiGraphTrBr1: TImmiGraphTrBr;
    ImmiGraphTrBr8: TImmiGraphTrBr;
    ImmiGraphTrBr9: TImmiGraphTrBr;
    Panel_2: TPanel;
    Panel_1: TPanel;
    ImmiGraphTrBr13: TImmiGraphTrBr;
    Panel_2_2: TPanel;
    Panel_6: TPanel;
    ImmiButtonXp1: TImmiButtonXp;
    ImmiButtonXp2: TImmiButtonXp;
    ImmiButtonXp3: TImmiButtonXp;
    ImmiButtonXp4: TImmiButtonXp;
    ImmiButtonXp5: TImmiButtonXp;
    ImmiButtonXp6: TImmiButtonXp;
    Panel1: TPanel;
    Shape9: TShape;
    Shape8: TShape;
    Shape7: TShape;
    ExprNameLabel1: TExprNameLabel;
    ExprNameLabel6: TExprNameLabel;
    ExprNameLabel7: TExprNameLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    TimeGrLabel3: TTimeGrLabel;
    TimeGrLabel4: TTimeGrLabel;
    TimeGrLabel5: TTimeGrLabel;
    TimeGrLabel2: TTimeGrLabel;
    TimeGrLabel6: TTimeGrLabel;
    TimeGrLabel7: TTimeGrLabel;
    TimeGrLabel8: TTimeGrLabel;
    TimeGrLabel9: TTimeGrLabel;
    TimeGrLabel10: TTimeGrLabel;
    ImmiScopeStatic1: TImmiScopeStatic;
    ExprGraphButton1: TExprGraphButton;
    ExprGraphButton6: TExprGraphButton;
    ImmiScopeStatic6: TImmiScopeStatic;
    ExprGraphButton7: TExprGraphButton;
    ImmiScopeStatic7: TImmiScopeStatic;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Shape31: TShape;
    TimeGrLabel1: TTimeGrLabel;
    ImmiGraphTrBr2: TImmiGraphTrBr;
    Panel2: TPanel;
    Shape10: TShape;
    Shape11: TShape;
    Shape17: TShape;
    ExprNameLabel2: TExprNameLabel;
    ExprNameLabel3: TExprNameLabel;
    ExprNameLabel4: TExprNameLabel;
    Label3: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Shape18: TShape;
    Shape32: TShape;
    Shape33: TShape;
    Shape34: TShape;
    Shape35: TShape;
    Shape36: TShape;
    Shape37: TShape;
    Shape38: TShape;
    Shape39: TShape;

    TimeGrLabel11: TTimeGrLabel;
    TimeGrLabel12: TTimeGrLabel;
    TimeGrLabel13: TTimeGrLabel;
    TimeGrLabel14: TTimeGrLabel;
    TimeGrLabel15: TTimeGrLabel;
    TimeGrLabel16: TTimeGrLabel;
    TimeGrLabel17: TTimeGrLabel;
    TimeGrLabel18: TTimeGrLabel;
    TimeGrLabel19: TTimeGrLabel;
    Shape40: TShape;
    TimeGrLabel20: TTimeGrLabel;
    ImmiScopeStatic2: TImmiScopeStatic;
    ExprGraphButton2: TExprGraphButton;
    ExprGraphButton3: TExprGraphButton;
    ImmiScopeStatic3: TImmiScopeStatic;
    ExprGraphButton4: TExprGraphButton;
    ImmiScopeStatic4: TImmiScopeStatic;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Shape41: TShape;
    ExprNameLabel5: TExprNameLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Shape42: TShape;
    Shape43: TShape;
    Shape44: TShape;
    TimeGrLabel21: TTimeGrLabel;
    TimeGrLabel22: TTimeGrLabel;
    TimeGrLabel23: TTimeGrLabel;
    ExprGraphButton5: TExprGraphButton;
    ImmiScopeStatic5: TImmiScopeStatic;
    CheckBox7: TCheckBox;
    ImmiGraphTrBr3: TImmiGraphTrBr;
    ImmiGraphTrBr4: TImmiGraphTrBr;
    ImmiGraphTrBr5: TImmiGraphTrBr;
    ImmiGraphTrBr6: TImmiGraphTrBr;
    ImmiGraphTrBr7: TImmiGraphTrBr;
    Panel3: TPanel;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    ExprNameLabel10: TExprNameLabel;
    ExprNameLabel11: TExprNameLabel;
    ExprNameLabel12: TExprNameLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Shape15: TShape;
    Shape16: TShape;
    Shape45: TShape;
    Shape46: TShape;
    Shape47: TShape;
    Shape48: TShape;
    Shape49: TShape;
    Shape50: TShape;
    Shape51: TShape;
    TimeGrLabel24: TTimeGrLabel;
    TimeGrLabel25: TTimeGrLabel;
    TimeGrLabel26: TTimeGrLabel;
    TimeGrLabel27: TTimeGrLabel;
    TimeGrLabel28: TTimeGrLabel;
    TimeGrLabel29: TTimeGrLabel;
    TimeGrLabel30: TTimeGrLabel;
    TimeGrLabel31: TTimeGrLabel;
    TimeGrLabel32: TTimeGrLabel;
    Shape52: TShape;
    TimeGrLabel33: TTimeGrLabel;
    Shape53: TShape;
    ExprNameLabel13: TExprNameLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Shape54: TShape;
    Shape55: TShape;
    Shape56: TShape;
    TimeGrLabel34: TTimeGrLabel;
    TimeGrLabel35: TTimeGrLabel;
    TimeGrLabel36: TTimeGrLabel;
    ImmiScopeStatic10: TImmiScopeStatic;
    ExprGraphButton10: TExprGraphButton;
    ExprGraphButton11: TExprGraphButton;
    ImmiScopeStatic11: TImmiScopeStatic;
    ExprGraphButton12: TExprGraphButton;
    ImmiScopeStatic12: TImmiScopeStatic;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    ExprGraphButton13: TExprGraphButton;
    ImmiScopeStatic13: TImmiScopeStatic;
    CheckBox11: TCheckBox;
    Panel4: TPanel;
    Shape20: TShape;
    Shape21: TShape;
    ExprNameLabel8: TExprNameLabel;
    ExprNameLabel9: TExprNameLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Shape57: TShape;
    Shape58: TShape;
    Shape60: TShape;
    Shape61: TShape;
    Shape63: TShape;
    Shape64: TShape;
    TimeGrLabel37: TTimeGrLabel;
    TimeGrLabel38: TTimeGrLabel;
    TimeGrLabel39: TTimeGrLabel;
    TimeGrLabel40: TTimeGrLabel;
    TimeGrLabel41: TTimeGrLabel;
    TimeGrLabel42: TTimeGrLabel;
    Shape66: TShape;
    TimeGrLabel46: TTimeGrLabel;
    ImmiScopeStatic8: TImmiScopeStatic;
    ExprGraphButton8: TExprGraphButton;
    ExprGraphButton9: TExprGraphButton;
    ImmiScopeStatic9: TImmiScopeStatic;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    Panel6: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    ExprNameLabel15: TExprNameLabel;
    ExprNameLabel16: TExprNameLabel;
    ExprNameLabel17: TExprNameLabel;
    Label39: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label45: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Shape4: TShape;
    Shape59: TShape;
    Shape69: TShape;
    TimeGrLabel47: TTimeGrLabel;
    TimeGrLabel48: TTimeGrLabel;
    TimeGrLabel49: TTimeGrLabel;
    TimeGrLabel50: TTimeGrLabel;
    TimeGrLabel51: TTimeGrLabel;
    TimeGrLabel52: TTimeGrLabel;
    TimeGrLabel54: TTimeGrLabel;
    TimeGrLabel55: TTimeGrLabel;
    TimeGrLabel56: TTimeGrLabel;
    Shape72: TShape;
    TimeGrLabel57: TTimeGrLabel;
    ImmiScopeStatic15: TImmiScopeStatic;
    ExprGraphButton15: TExprGraphButton;
    ExprGraphButton16: TExprGraphButton;
    ImmiScopeStatic16: TImmiScopeStatic;
    ExprGraphButton17: TExprGraphButton;
    ImmiScopeStatic17: TImmiScopeStatic;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    Shape74: TShape;
    Shape76: TShape;
    Shape77: TShape;
    ExprNameLabel18: TExprNameLabel;
    ExprNameLabel19: TExprNameLabel;
    ExprNameLabel20: TExprNameLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    TimeGrLabel58: TTimeGrLabel;
    TimeGrLabel59: TTimeGrLabel;
    TimeGrLabel60: TTimeGrLabel;
    TimeGrLabel61: TTimeGrLabel;
    TimeGrLabel62: TTimeGrLabel;
    TimeGrLabel63: TTimeGrLabel;
    TimeGrLabel64: TTimeGrLabel;
    TimeGrLabel65: TTimeGrLabel;
    TimeGrLabel66: TTimeGrLabel;
    ImmiScopeStatic18: TImmiScopeStatic;
    ExprGraphButton18: TExprGraphButton;
    ExprGraphButton19: TExprGraphButton;
    ImmiScopeStatic19: TImmiScopeStatic;
    ExprGraphButton20: TExprGraphButton;
    ImmiScopeStatic20: TImmiScopeStatic;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    ImmiGraphTrBr11: TImmiGraphTrBr;
    ImmiGraphTrBr12: TImmiGraphTrBr;
    ImmiGraphTrBr10: TImmiGraphTrBr;
    ImmiGraphTrBr14: TImmiGraphTrBr;
    ImmiGraphTrBr16: TImmiGraphTrBr;
    ImmiGraphTrBr17: TImmiGraphTrBr;
    ImmiGraphTrBr18: TImmiGraphTrBr;
    ImmiGraphTrBr19: TImmiGraphTrBr;
    ImmiGraphTrBr20: TImmiGraphTrBr;
    ImmiGraphTrBr21: TImmiGraphTrBr;
    ImmiGraphTrBr22: TImmiGraphTrBr;
    ImmiGraphTrBr23: TImmiGraphTrBr;
    ImmiGraphTrBr24: TImmiGraphTrBr;
    ImmiGraphTrBr15: TImmiGraphTrBr;
    ImmiGraphTrBr25: TImmiGraphTrBr;
    ImmiGraphTrBr26: TImmiGraphTrBr;
    Shape87: TShape;
    Shape88: TShape;
    Shape89: TShape;
    Shape90: TShape;
    Shape91: TShape;
    Shape92: TShape;
    Shape93: TShape;
    Shape94: TShape;
    Shape95: TShape;
    Shape96: TShape;
    Shape97: TShape;
    Shape98: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape19: TShape;
    Shape67: TShape;
    Shape68: TShape;
    Shape71: TShape;
    Shape78: TShape;
    Shape79: TShape;
    Shape80: TShape;
    Shape81: TShape;
    Shape82: TShape;
    Shape83: TShape;
    Shape84: TShape;
    Shape85: TShape;
    Shape86: TShape;
    Shape99: TShape;
    Shape100: TShape;
    Shape101: TShape;
    Shape102: TShape;
    Shape103: TShape;
    Shape104: TShape;
    Shape105: TShape;
    Shape106: TShape;
    Shape107: TShape;
    Shape108: TShape;
    Shape109: TShape;
    Shape110: TShape;
    Shape111: TShape;
    Shape112: TShape;
    Shape113: TShape;
    Shape114: TShape;
    Shape115: TShape;
    Shape116: TShape;
    Shape117: TShape;
    Shape118: TShape;
    Panel5: TPanel;
    TimeGrLabel53: TTimeGrLabel;
    Shape123: TShape;
    Shape124: TShape;
    Shape125: TShape;
    Shape126: TShape;
    Shape127: TShape;
    Shape128: TShape;
    Shape129: TShape;
    Shape130: TShape;
    Shape131: TShape;
    Shape132: TShape;
    Shape133: TShape;
    Shape134: TShape;
    Shape135: TShape;
    Shape136: TShape;
    Shape137: TShape;
    Shape138: TShape;
    Shape139: TShape;
    Shape140: TShape;
    Shape141: TShape;
    Shape142: TShape;
    Shape143: TShape;
    Shape144: TShape;
    Shape145: TShape;
    Shape146: TShape;
    Shape147: TShape;
    Shape148: TShape;
    Shape149: TShape;
    Shape150: TShape;
    Shape151: TShape;
    Shape152: TShape;
    Shape153: TShape;
    Shape154: TShape;
    Shape155: TShape;
    Shape156: TShape;
    Shape157: TShape;
    Shape158: TShape;
    Shape159: TShape;
    Shape160: TShape;
    Shape161: TShape;
    Shape162: TShape;
    Shape163: TShape;
    Shape164: TShape;
    Shape165: TShape;
    Shape166: TShape;
    TimeGrLabel67: TTimeGrLabel;
    TimeGrLabel68: TTimeGrLabel;
    TimeGrLabel69: TTimeGrLabel;
    TimeGrLabel70: TTimeGrLabel;
    TimeGrLabel71: TTimeGrLabel;
    TimeGrLabel72: TTimeGrLabel;
    TimeGrLabel73: TTimeGrLabel;
    PrintDialog1: TPrintDialog;
    Panel7: TPanel;
    Panel8: TPanel;
    Shape175: TShape;
    ExprNameLabelMulti1: TExprNameLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    ImmiScopeNill: TImmiScopeStatic;
    Exprnill: TExprGraphButton;
    TimeGrLabel43: TTimeGrLabel;
    ExprNameLabel14: TExprNameLabel;
    Shape65: TShape;
    ExprGraphMulti1: TExprGraphButton;
    Shape70: TShape;
    ExprGraphMulti2: TExprGraphButton;
    ExprNameLabel21: TExprNameLabel;
    Shape62: TShape;
    ExprGraphMulti3: TExprGraphButton;
    ExprNameLabel22: TExprNameLabel;
    Shape120: TShape;
    ExprGraphMulti5: TExprGraphButton;
    ExprNameLabel23: TExprNameLabel;
    Shape169: TShape;
    ExprNameLabelMulti2: TExprNameLabel;
    ExprNameLabelMulti3: TExprNameLabel;
    Panel12: TPanel;
    ExprNameLabel24: TExprNameLabel;
    Shape172: TShape;
    ExprNameLabelMulti4: TExprNameLabel;
    ExprGraphMulti4: TExprGraphButton;
    ExprNameLabelMulti5: TExprNameLabel;
    Series5: TLineSeries;
    Series6: TLineSeries;
    ExprGraphMulti6: TExprGraphButton;
    ExprNameLabelMulti6: TExprNameLabel;
    Shape176: TShape;
    ExprGraphMulti7: TExprGraphButton;
    ExprNameLabelMulti7: TExprNameLabel;
    Shape179: TShape;
    ExprGraphMulti8: TExprGraphButton;
    ExprNameLabelMulti8: TExprNameLabel;
    Shape182: TShape;
    Series7: TLineSeries;
    Series8: TLineSeries;
    CheckBox14: TCheckBox;
    Panel11: TPanel;
    Label36: TLabel;
    Labelval1: TLabel;
    Label44: TLabel;
    Labelval2: TLabel;
    Shape73: TShape;
    Label46: TLabel;
    Labelval3: TLabel;
    Shape75: TShape;
    Label62: TLabel;
    Labelval4: TLabel;
    Shape119: TShape;
    Label64: TLabel;
    Labelval5: TLabel;
    Shape121: TShape;
    Label66: TLabel;
    Labelval6: TLabel;
    Shape122: TShape;
    Label68: TLabel;
    Labelval7: TLabel;
    Shape170: TShape;
    Label70: TLabel;
    Labelval8: TLabel;
    Shape171: TShape;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ImageList1: TImageList;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    XPManifest1: TXPManifest;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    XMLInfo: TXMLDocument;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;

    procedure FormCreate(Sender: TObject);
    procedure Pen8Click(Sender: TObject);
    procedure bbExitClick(Sender: TObject);
    procedure bbPrintClick(Sender: TObject);
    procedure bbRight33Click(Sender: TObject);
    procedure bbLeft33Click(Sender: TObject);
    procedure bbLeft100Click(Sender: TObject);
    procedure bbRight100Click(Sender: TObject);
    procedure bbZin2XClick(Sender: TObject);
    procedure bbZin2YClick(Sender: TObject);
    procedure bbZout2YClick(Sender: TObject);
    procedure TrackBar1XChange(Sender: TObject);
    procedure bbResetClick(Sender: TObject);
    procedure TrackBar1YChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure cbProcClick(Sender: TObject);
    procedure Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
     procedure drawFill;
    procedure UpdateChart;
    procedure PrintM;
    procedure SaveSettingsToFile (FN: string);
    procedure LoadCBSaveset;
    procedure FormDestroy(Sender: TObject);
    procedure ImmiButtonXp2Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ImmiButtonXp1Click(Sender: TObject);
    procedure ImmiButtonXp3Click(Sender: TObject);
    procedure ImmiButtonXp4Click(Sender: TObject);
    procedure ImmiButtonXp6Click(Sender: TObject);
    procedure ImmiButtonXp5Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure ImmiGraphTrBr2Change(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox12Click(Sender: TObject);
    procedure CheckBox13Click(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox16Click(Sender: TObject);
    procedure CheckBox17Click(Sender: TObject);
    procedure CheckBox18Click(Sender: TObject);
    procedure CheckBox19Click(Sender: TObject);
    procedure CheckBox20Click(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ExprGraphButtonMulti1Click(Sender: TObject);
    procedure boutClick(Sender: TObject);
    procedure bLeft100Click(Sender: TObject);
    procedure bTimeClick(Sender: TObject);
    procedure ExprNameLabelMulti1Click(Sender: TObject);
    procedure ImmiGraphTrBr13Change(Sender: TObject);
    procedure Chart1AfterDraw(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure setConnInfo(DBT: integer; constr: string);

  private
    fDBMenagType: integer;
    fconstr: string;
    fStartT: TDateTime;
    fStopT: TDateTime;
    resabs: tTDPoint;
    chartisActive: boolean;
    RegisterOn: boolean; // регистратор включен
    fSelectedPen: integer;
    oldTrack1X, oldTrack2X: integer; //предыдущее положение верхнего и нижнего ползунка
    seriesData: array of TseriesData;
    function TAxisToScreen(TimePos: TTime): longint;
    procedure CheckChart;
    function  getStartT: TDateTime;
    function  getStopT: TDateTime;
    function getTrdef: TTrenddefList;

 //   procedure QueryExpr1(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
    procedure SetSelectedPen(val: integer);
    procedure DrawAxisMsg(var Msg: TMessage); message WMU_DRAWAXIS;
    procedure DrawRightAxis(PenNum: integer);
    procedure DrawLeftAxis;
    procedure SetTimeBounds;
    procedure OutCurrentValue;
    procedure LoadInfo;
   // procedure OutAverageValue;
    procedure ShowTrackBars;
    procedure DrawTimeXorLine;
    procedure DrawZoomXorLine;
    procedure SetStartPos;
    procedure DefTitle;
    function TrPosToTime(TrackBarPos: Double): TDateTime;
    procedure AllNil;
    procedure ChangeAxis(Ax: TChartAxis; Min, max: double);
    procedure AddData(PenNum: integer; Start, length: TDateTime; sideStr: string);
    procedure AddDataSeries(PenNum: integer; dataSet: TdataSet);
    function PeriodToStr(Period:TDateTime): string;
    procedure AddEndpoints(PenNum: Integer);
    procedure removeEndpoints(PenNum: Integer);
    procedure AssignPen(PenNum: integer;PenName: String);
    //procedure SaveSettingsToFile (FN: string);

    function ReadSettingsFromFile (FN: string): boolean;
    function MaxLXCount(x: double;penNum: integer): Longint;
    function MinRXCount(x: double;penNum: integer): Longint;
    function IterateYforX(x: double;penNum: integer): double;
    function activepenCount: integer;

    //procedure LoadCBSaveset;
  public
    activPen: integer;
    LastCap: string;
    function BaseDir: String;
    procedure DrawAxis;
    procedure ChangeAB(PenNum: integer; A1, B1, A2, B2: double);
    procedure ChangeDT(aTrendStart, aTrendLength: tDateTime);
    procedure SelectData(PenNum: integer);
    function GetLogCodeByName(iName: string): integer;
    property SelectedPen: integer read fSelectedPen write SetSelectedPen;
    procedure WMImmCloseAll(var messag: TMsg); message WM_IMMICLOSEALL;
    property  StartT: TDateTime read  getStartT write fStartT;
    property  StopT: TDateTime read  getStopT write fStopT;
    procedure QueryFetchComplete1(data: tTDPointData;
    Error: integer);
    procedure QueryExpr1(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
    procedure QueryFetchComplete2(data: tTDPointData;
    Error: integer);
    procedure QueryExpr2(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
     procedure QueryFetchComplete3(data: tTDPointData;
    Error: integer);
    procedure QueryExpr3(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
    procedure QueryFetchComplete4(data: tTDPointData;
    Error: integer);
    procedure QueryExpr4(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
     procedure QueryFetchComplete5(data: tTDPointData;
    Error: integer);
    procedure QueryExpr5(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
    procedure QueryFetchComplete6(data: tTDPointData;
    Error: integer);
    procedure QueryExpr6(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
     procedure QueryFetchComplete7(data: tTDPointData;
    Error: integer);
    procedure QueryExpr7(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
    procedure QueryFetchComplete8(data: tTDPointData;
    Error: integer);
    procedure QueryExpr8(timstart: TDateTime; timstop: TDateTime;  aTagid: string);


  end;


var
 // ind,indx: integer;
 kio: integer;
  fTrend: TfTrend;
  rBound: TTime;
  trendStart, trendLength: double; // Начало и продолжительность отображаемового графика
  TRENDLIST_GLOBAL_TREND: TTrenddefList;
implementation

uses  printers;

{$R *.DFM}

// создаём форму
procedure TfTrend.FormCreate(Sender: TObject);
var
  i: integer;

begin
 activPen:=-1;
 //self.SyButton1.Caption:='Выкл.';
 RegisterOn:=false;

  top:=20;
  left:=0;
  width:=1275;
  height:=855;
  fSelectedPen := -1;

  SetLength(seriesData, 8);








  for i:=0 to self.Chart1.SeriesList.Count-1 do
   begin
     self.Chart1.Series[i].Clear;
   end;

   fStartT:=ImmiScopeNill.StartTm;
   fStopT:=ImmiScopeNill.StartTm+ImmiScopeNill.TimePeriod;

   CheckChart;
  ImmiButtonXp1Click(self);
  chartisActive:=true;
  LoadInfo;
  end;

procedure TfTrend.LoadCBSaveset;
var f: textFile;
    i: byte;
    s: string;
begin

end;

procedure TfTrend.LoadInfo;
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
        then fDBMenagType:=strtointdef(XMLInfo.DocumentElement.Attributes['DBProvider'],-1);
       if assigned(XMLInfo.DocumentElement.AttributeNodes.Nodes['constring'])
        then fconstr:=XMLInfo.DocumentElement.Attributes['constring'];;
       dbmanager:=fDBMenagType;
       connectionstr:=fconstr;
    end;
end;

procedure TfTrend.AssignPen(PenNum: integer;PenName: String);
//var itemrf: PTAnalogMem ;
begin
end;

procedure TfTrend.Pen8Click(Sender: TObject);
begin
end;

// Процедура устанавливает начальные надписи на кнопках выбора параметров отображения и
// полях вывода их текущих значений
procedure TfTrend.DefTitle;
var
 i: integer;
begin
  for i := low(seriesData) to High(seriesData) do
   if (seriesData[i].Pen.Caption = '') then
     begin
       seriesData[i].Pen.Caption := 'Пусто';
       seriesData[i].Penlbl.Caption:= '0';
       seriesData[i].PP.EU := '';
     end;
end;

// Процедура выборки и вывода на график значений из базы данных по требуемым параметрам;
// В конце устанавливаются границы по оси времени (горизонтальной) и оси значений (вертикальной)
procedure TfTrend.SelectData(PenNum: Integer);
begin

end;

// Выход из архива
procedure TfTrend.bbExitClick(Sender: TObject);
begin
  Application.Terminate;
end;



procedure TfTrend.bbPrintClick(Sender: TObject);

 begin

end;

// Сдвиг вправо
procedure TfTrend.bbRight33Click(Sender: TObject);
begin
  ChangeDT(trendStart + trendLength / 3, trendLength);
end;

// Сдвиг влево
procedure TfTrend.bbLeft33Click(Sender: TObject);
begin
  ChangeDT(trendStart - trendLength / 3, trendLength);
end;

// Сдвиг влево
procedure TfTrend.bbLeft100Click(Sender: TObject);
begin
  ChangeDT(trendStart - trendLength, trendLength);
  end;

// Сдвиг вправо
procedure TfTrend.bbRight100Click(Sender: TObject);
begin
  ChangeDT(trendStart + trendLength, trendLength);
end;

// Движение ползунка горизонтального верхнего trackbar
procedure TfTrend.TrackBar1XChange(Sender: TObject);
begin

end;


// Процедура установки граничных значений временной (горизонтальной) оси;
// Параметр TrSetSwitch определяет будут ли установлены соответсвтующие граничные значения TrackBar
procedure TfTrend.SetTimeBounds;
begin

end;

// Функция определяет значение времени, соответвтующее положению ползунка TrackBar;
// Параметр TrackBarNum определяет TrackBar.
function TfTrend.TrPosToTime (TrackBarPos: double): TDateTime;
begin
 result := StartT + (StopT-StartT) * TrackBarPos;
end;

// Вывод средних значений параметров в соответствующие поля вывода
{procedure TfTrend.OutAverageValue;
var
  pwr: integer;
  avrgs: array of Double;
  times: array of TTime;
  deltas: array of TTime;
  values: array of Double;
  i, k: integer;
  integral: double;
begin
  SetLength(avrgs, DBChart.SeriesCount);
  for k:= 0 to Pred(DBChart.SeriesCount) do
    begin
      pwr:= DBChart.Series[k].XValues.Count;
      if (pwr = 0) then
        continue;
      SetLength(times, pwr);
      SetLength(deltas, pwr - 1);
      SetLength(values, pwr);
      for i:= 0 to Pred(pwr) do
        times[i]:= DBChart.Series[k].XValues.Value[i];
      for i:= 0 to (pwr - 2) do
        deltas[i]:= times[i+1] - times[i];
      for i:= 0 to Pred(pwr) do
        values[i]:= DBChart.Series[k].YValues.Value[i];
      integral:= 0;
      for i:= 0 to (pwr - 2) do
        integral:= integral + values[i] * deltas[i];
      avrgs[k]:= integral / (times[pwr - 1] - times[0]);
    end; }
{  lAParam1.Caption:= FloatToStrF(avrgs[0], ffFixed, 7, 1);
  lAParam2.Caption:= FloatToStrF(avrgs[1], ffFixed, 7, 1);
  lAParam3.Caption:= FloatToStrF(avrgs[2], ffFixed, 7, 1);
  lAParam4.Caption:= FloatToStrF(avrgs[3], ffFixed, 7, 1);
  lAParam5.Caption:= FloatToStrF(avrgs[4], ffFixed, 7, 1);
  lAParam6.Caption:= FloatToStrF(avrgs[5], ffFixed, 7, 1);
  lAParam7.Caption:= FloatToStrF(avrgs[6], ffFixed, 7, 1);
  lAParam8.Caption:= FloatToStrF(avrgs[7], ffFixed, 7, 1);
}
//end;

// Вывод текущих значений параметров в соответствующие поля вывода
procedure TfTrend.OutCurrentValue;
var
  indx : integer;
  trBarTime: TDateTime;
begin
 if  chart1=nil then exit;
 if  chart1.SeriesList.Count=0 then  exit;
  trBarTime := TrPosToTime(ImmiGraphTrBr13.Position / 100);
 if (ExprGraphMulti1.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[0].count-1 do
       if ( trBarTime >= chart1.Series[0].XValues.Value[indx]) then
       begin
       {if indx<>0 then  }
      self.Labelval1.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti1.Caption)^.eu,[chart1.Series[0].YValues.Value[indx]]);
      end
   end;

   if (ExprGraphMulti2.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[1].count-1 do
       if ( trBarTime >= chart1.Series[1].XValues.Value[indx]) then
       begin
       {if indx<>0 then}
      self.Labelval2.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti2.Caption)^.eu,[chart1.Series[1].YValues.Value[indx]]);
      end
   end;

   if (ExprGraphMulti3.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[2].count-1 do
       if ( trBarTime >= chart1.Series[2].XValues.Value[indx]) then
       begin
       {if indx<>0 then }
      self.Labelval3.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti3.Caption)^.eu,[chart1.Series[2].YValues.Value[indx]]);
      end
    end;

    if (ExprGraphMulti4.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[3].count-1 do
       if ( trBarTime >= chart1.Series[3].XValues.Value[indx]) then
       begin
       if indx<>0 then
      self.Labelval4.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti4.Caption)^.eu,[chart1.Series[3].YValues.Value[indx]]);
      end
   end;

   if (ExprGraphMulti5.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[4].count-1 do
       if ( trBarTime >= chart1.Series[4].XValues.Value[indx]) then
       begin
       {if indx<>0 then}
      self.Labelval5.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti5.Caption)^.eu,[chart1.Series[4].YValues.Value[indx]]);
      end
   end;

   if (ExprGraphMulti6.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[5].count-1 do
       if ( trBarTime >= chart1.Series[5].XValues.Value[indx]) then
       begin
       {if indx<>0 then}
      self.Labelval6.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti6.Caption)^.eu,[chart1.Series[5].YValues.Value[indx]]);
       end
   end;

   if (ExprGraphMulti7.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[6].count-1 do
       if ( trBarTime >= chart1.Series[6].XValues.Value[indx]) then
       begin
       {if indx<>0 then}
      self.Labelval7.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti7.Caption)^.eu,[chart1.Series[6].YValues.Value[indx]]);
      end
   end;

    if (ExprGraphMulti8.Caption<>'Пусто') then
   begin
       for indx:= 0 to chart1.Series[7].count-1 do
       if ( trBarTime >= chart1.Series[7].XValues.Value[indx]) then
       begin
       {if indx<>0 then}
      self.Labelval8.Caption:=
      format('%6.3f '+getTrdef.GetInfo(ExprGraphMulti8.Caption)^.eu,[chart1.Series[7].YValues.Value[indx]]);
      end else
      exit;
   end;

end;

function TfTrend.ReadSettingsFromFile(FN: string): boolean;
var
  f: textFile;
  str: string;
  TS, TE: TDateTime;
  i: integer;
begin
  result := false;
  if FileExists(FN) then
  try
    assignFile(f, FN);
    reset (f);
    readln(f); // пропуск строки
    readln(f, str);
    readln(f, str);
    TS := StrToDateTime(str);
    readln(f, str);
    readln(f, str);
    TE := StrToDateTime(str);
    ChangeDT(TS, TE - TS);
    for i := 0 to 7 do
    begin
      readln(f, str);
      readln(f, str);
      AssignPen(i, str);
    end;
    result := true;
  finally
    closeFile(f);
  end;
end;

procedure TfTrend.SaveSettingsToFile(FN: string);// Запись настроек в файл
var
  f: textFile;
  i: integer;
  strL: TStringList;
  str: string;
begin
 strL:=TStringList.Create;
 str:=BaseDir+FN+'.arcSt';
 if FileExists(str) then
   if MessageBox(0,'Такая настройка уже есть. Перезаписать?','Предупреждение',MB_YESNO)=IDNO then
     exit;
     strL.Clear;
  for i:=0 to 7 do
      strL.Add(seriesData[i].pen.Caption);
   strl.SaveToFile(BaseDir+FN+'.arcSt');
   strl.Clear;
   strl.LoadFromFile(BaseDir+'ArcSettin.arc');
   strl.add(FN);
   strl.SaveToFile(BaseDir+'ArcSettin.arc');

end;

procedure TfTrend.DrawAxisMsg(var Msg: TMessage);
begin

end;

procedure TfTrend.DrawAxis;//(var Msg: TMessage);

begin
  drawLeftAxis;
  DrawRightAxis(SelectedPen);
  drawfill;
end;

procedure TfTrend.ChangeAxis(Ax: TChartAxis; Min, max: double);
begin
  if ax.Maximum < min then
  begin
    ax.Maximum := max;
    ax.Minimum := min;
  end
  else
  begin
    ax.Minimum := min;
    ax.Maximum := max;
  end;
end;

procedure TfTrend.DrawLeftAxis;
var
  i: integer;
  max, min, minR, maxR: double;
  assigned: boolean;
begin

end;

procedure TfTrend.DrawRightAxis(PenNum: integer);
Var
  cA: double;
  cB: double;
  color: TColor;
begin

end;

procedure TfTrend.SetSelectedPen(val: integer);
begin

end;

// Отрисовка линии при перемещении ползунка верхнего горизонтального TrackBar
procedure TfTrend.DrawTimeXorLine;
begin
IF Chart1=nil then exit;
with Chart1 do
    begin
      Canvas.Pen.Mode:= pmXor;
      Canvas.Pen.Color:= TimeLineColor;

      Canvas.MoveTo(OldTrack1X, ChartBounds.Top + 10);
      Canvas.LineTo(OldTrack1X, ChartBounds.Bottom - 30);

      OldTrack1X := TAxisToScreen(TrPosToTime(ImmiGraphTrBr13.Position / 100));
      Canvas.MoveTo(OldTrack1X, ChartBounds.Top + 10);
      Canvas.LineTo(OldTrack1X, ChartBounds.Bottom - 30);
    end;

end;

// Отрисовка линии при перемещении ползунка нижнего горизонтального TrackBar
procedure TfTrend.DrawZoomXorLine;
begin
 IF Chart1=nil then exit;
     with Chart1 do
    begin
      Canvas.Pen.Mode:= pmXor;
      Canvas.Pen.Color:= TimeLineColor;

      Canvas.MoveTo(OldTrack2X, ChartBounds.Top + 10);
      Canvas.LineTo(OldTrack2X, ChartBounds.Bottom - 30);

      OldTrack2X := TAxisToScreen(TrPosToTime(ImmiGraphTrBr13.Position1 / 100));
      Canvas.MoveTo(OldTrack2X, ChartBounds.Top + 10);
      Canvas.LineTo(OldTrack2X, ChartBounds.Bottom - 30);
    end;
end;

// Увеличение в 2 раза по горизонтальной оси
procedure TfTrend.bbZin2XClick(Sender: TObject);
begin

end;

// Уменьшение в 2 раза по горизонтальной оси
procedure TfTrend.bbZin2YClick(Sender: TObject);
begin
end;

// Уменьшение 2 раза по вертикальной оси
procedure TfTrend.bbZout2YClick(Sender: TObject);
begin
end;

// Установка начального положения линий
procedure TfTrend.SetStartPos;
begin
  OldTrack1X:= -1;
  OldTrack2X:= -1;
end;

// Кнопка сброса/установки
procedure TfTrend.bbResetClick(Sender: TObject);

begin

end;

// Движение ползунка правого вертикального TrackBar
procedure TfTrend.TrackBar1YChange(Sender: TObject);
begin
    DrawLeftAxis;
    //if activPen>-1 then self.DrawRightAxis(activPen);
end;

// Регистратор с установленным периодом опроса в мс
procedure TfTrend.TimerTimer(Sender: TObject);
begin
//if (SyButton1.Caption = 'ВКЛ.') and (trendLength > 10 / 24 / 60) then trendLength := 10 / 24 / 60;
  //ChangeDT(now - trendLength, trendLength);
end;


procedure TfTrend.ChangeDT(aTrendStart, aTrendLength: tDateTime);

begin

end;

procedure TfTrend.AddData(PenNum: integer; Start, length: TDateTime; sideStr: string);
var
   days, i: integer;
   curDate: TDateTime;
   TableName, sQuery: string;
   curdateTS: TdateTime;
   persentP, glpersentP: double;
   currentstop: TDatetime;
//   Day1, Day2: double;
  cond1, cond2: string;

begin

end;

function TfTrend.PeriodToStr(Period: TDateTime): string;
var
  day, hour, min, sec, msec, temp: word;
begin

end;

procedure TfTrend.AddDataSeries(PenNum: integer; dataSet: TdataSet);
var
  i: longInt;
  prevaL, del: double;
begin

end;

procedure TfTrend.AddEndPoints(PenNum: Integer);
  var Xmin, Xmax, Xl, Xr,  Ymin, Ymax, Yl, Yr : double;
      CountMin, CountMax: integer;
begin

end;

procedure TfTrend.removeEndpoints(PenNum: Integer);
begin

end;

procedure TfTrend.CheckBox1Click(Sender: TObject);
var
  i: integer;
begin
self.ImmiScopeStatic1.AutoSizeEU:=CheckBox1.Checked;
end;

procedure TfTrend.cbProcClick(Sender: TObject);
var
  i: integer;
begin

end;

procedure TfTrend.ShowTrackBars;
begin

end;

procedure TfTrend.ChangeAB(PenNum: integer; A1, B1, A2, B2: double);
var
  i: integer;
  k: double;
begin

end;
{ TseriesData }

constructor TseriesData.Create;
begin
  fcA := 1; fcB := 0;
  FirstPoint := -1;
  LastPoint := -1;
end;

procedure TseriesData.SetAB(A, B: Double);
begin
  if (fcA <> A) or (fcB <> B) then
    fTrend.ChangeAB(PenNum, fcA, fcB, A, B);
  fcA := A;
  fcB := B;
  fTrend.DrawAxis;
end;

procedure TfTrend.Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  (Source as TControl).Left := X;
  accept := true;
end;





function TfTrend.BaseDir: String;
begin

end;

procedure TfTrend.FormDestroy(Sender: TObject);
begin
setlength( resabs.point,0);
end;

procedure TfTrend.ImmiButtonXp2Click(Sender: TObject);
begin
   self.Panel_1.Visible:=false;
   self.Panel_2.Visible:=true;
   self.Panel_3.Visible:=false;
   self.Panel_4.Visible:=false;
    self.Panel_2_2.Visible:=false;
   self.Panel_6.Visible:=false;
   AllNil;
   chartisActive:=true;
end;

procedure TfTrend.CheckBox2Click(Sender: TObject);
begin
self.ImmiScopeStatic6.AutoSizeEU:=CheckBox2.Checked;
end;

function TfTrend.GetLogCodeByName(iName: string): integer;
begin

end;


function TfTrend.MaxLXCount(x: double;pennum: integer): Longint;
var fl: boolean;
    i: integer;
    max: double;
begin

end;

function TfTrend.MinRXCount(x: double;pennum: integer): Longint;
var fl: boolean;
    i: integer;
    min: double;
begin

end;

function TfTrend.IterateYforX(x: double;penNum: integer): double;
var  Xl, Xr,  Ymin, Ymax, Yl, Yr : double;
      CountMin, CountMax: integer;
begin

end;

function TfTrend.activepenCount: integer;
var i: integer;
begin
  result:=0;
  for i:=0 to 7 do if (seriesData[i].PP.Name<>'Пусто') and (seriesData[i].PP.Name<>'') then  inc(result);
end;

procedure TfTrend.WMImmCloseAll(var messag: TMsg);
begin
  self.Close;

end;

procedure TfTrend.ImmiButtonXp1Click(Sender: TObject);
begin
chartisActive:=true;
self.Panel_1.Visible:=true;
self.Panel_2.Visible:=false;
self.Panel_3.Visible:=false;
self.Panel_4.Visible:=false;
self.Panel_2_2.Visible:=false;
self.Panel_6.Visible:=false;
AllNil;
end;

procedure TfTrend.ImmiButtonXp3Click(Sender: TObject);
begin
chartisActive:=false;
  self.Panel_1.Visible:=false;
self.Panel_2.Visible:=false;
self.Panel_3.Visible:=true;
self.Panel_4.Visible:=false;
self.Panel_2_2.Visible:=false;
self.Panel_6.Visible:=false;
 AllNil;
end;

procedure TfTrend.ImmiButtonXp4Click(Sender: TObject);
begin
chartisActive:=false;
 self.Panel_1.Visible:=false;
self.Panel_2.Visible:=false;
self.Panel_3.Visible:=false;
self.Panel_4.Visible:=true;
self.Panel_2_2.Visible:=false;
self.Panel_6.Visible:=false;
  AllNil;
end;

procedure TfTrend.ImmiButtonXp6Click(Sender: TObject);
begin
chartisActive:=false;
 self.Panel_1.Visible:=false;
self.Panel_2.Visible:=false;
self.Panel_3.Visible:=false;
self.Panel_4.Visible:=false;
self.Panel_2_2.Visible:=true;
self.Panel_6.Visible:=false;
AllNil;
end;

procedure TfTrend.ImmiButtonXp5Click(Sender: TObject);
begin
chartisActive:=false;
self.Panel_1.Visible:=false;
self.Panel_2.Visible:=false;
self.Panel_3.Visible:=false;
self.Panel_4.Visible:=false;
self.Panel_2_2.Visible:=false;
self.Panel_6.Visible:=true;
AllNil;
end;

procedure TfTrend.AllNil;
begin
self.ImmiScopeStatic1.Expr:='';
self.ImmiScopeStatic6.Expr:='';
self.ImmiScopeStatic7.Expr:='';
self.ImmiScopeStatic2.Expr:='';
self.ImmiScopeStatic3.Expr:='';
self.ImmiScopeStatic4.Expr:='';
self.ImmiScopeStatic5.Expr:='';
self.ImmiScopeStatic6.Expr:='';
self.ImmiScopeStatic7.Expr:='';
self.ImmiScopeStatic11.Expr:='';
self.ImmiScopeStatic12.Expr:='';
self.ImmiScopeStatic13.Expr:='';
self.ImmiScopeStatic15.Expr:='';
//self.ImmiScopeStatic14.Expr:='';
self.ImmiScopeStatic16.Expr:='';
self.ImmiScopeStatic15.Expr:='';
self.ImmiScopeStatic17.Expr:='';
self.ImmiScopeStatic18.Expr:='';
self.ImmiScopeStatic19.Expr:='';
self.ImmiScopeStatic20.Expr:='';
self.ImmiScopeStatic10.Expr:='';
 self.ImmiScopeStatic8.Expr:='';
self.ImmiScopeStatic9.Expr:='';

self.ExprGraphButton1.caption:='Пусто';
self.ExprGraphButton6.caption:='Пусто';
self.ExprGraphButton7.caption:='Пусто';
self.ExprGraphButton2.caption:='Пусто';
self.ExprGraphButton3.caption:='Пусто';
self.ExprGraphButton4.caption:='Пусто';
self.ExprGraphButton5.caption:='Пусто';
self.ExprGraphButton6.caption:='Пусто';
self.ExprGraphButton7.caption:='Пусто';
self.ExprGraphButton11.caption:='Пусто';
self.ExprGraphButton12.caption:='Пусто';
self.ExprGraphButton13.caption:='Пусто';
self.ExprGraphButton15.caption:='Пусто';
//self.ExprGraphButton14.caption:='Пусто';
self.ExprGraphButton16.caption:='Пусто';
self.ExprGraphButton15.caption:='Пусто';
self.ExprGraphButton17.caption:='Пусто';
self.ExprGraphButton18.caption:='Пусто';
self.ExprGraphButton19.caption:='Пусто';
self.ExprGraphButton20.caption:='Пусто';
self.ExprGraphButton10.caption:='Пусто';
 self.ExprGraphButton8.caption:='Пусто';
self.ExprGraphButton9.caption:='Пусто';
end;

procedure TfTrend.CheckBox3Click(Sender: TObject);
begin
 self.ImmiScopeStatic7.AutoSizeEU:=CheckBox3.Checked;
end;

procedure TfTrend.ImmiGraphTrBr2Change(Sender: TObject);
begin
inherited;
if self.ImmiScopeStatic1.Expr<>'' then self.CheckBox1.Checked:= self.ImmiScopeStatic1.AutoSizeEU;
end;

procedure TfTrend.CheckBox8Click(Sender: TObject);
begin
  self.ImmiScopeStatic10.AutoSizeEU:=CheckBox8.Checked;
end;

procedure TfTrend.CheckBox10Click(Sender: TObject);
begin
   self.ImmiScopeStatic12.AutoSizeEU:=CheckBox10.Checked;
end;

procedure TfTrend.CheckBox9Click(Sender: TObject);
begin
  self.ImmiScopeStatic11.AutoSizeEU:=CheckBox9.Checked;
end;

procedure TfTrend.CheckBox11Click(Sender: TObject);
begin
   self.ImmiScopeStatic13.AutoSizeEU:=CheckBox11.Checked;
end;

procedure TfTrend.CheckBox12Click(Sender: TObject);
begin
 self.ImmiScopeStatic8.AutoSizeEU:=CheckBox12.Checked;
end;

procedure TfTrend.CheckBox13Click(Sender: TObject);
begin
  self.ImmiScopeStatic9.AutoSizeEU:=CheckBox13.Checked;
end;

procedure TfTrend.CheckBox15Click(Sender: TObject);
begin
self.ImmiScopeStatic15.AutoSizeEU:=CheckBox15.Checked;
end;

procedure TfTrend.CheckBox16Click(Sender: TObject);
begin
   self.ImmiScopeStatic16.AutoSizeEU:=CheckBox16.Checked;
end;

procedure TfTrend.CheckBox17Click(Sender: TObject);
begin
  self.ImmiScopeStatic17.AutoSizeEU:=CheckBox17.Checked;
end;

procedure TfTrend.CheckBox18Click(Sender: TObject);
begin
  self.ImmiScopeStatic18.AutoSizeEU:=CheckBox18.Checked;
end;

procedure TfTrend.CheckBox19Click(Sender: TObject);
begin
   self.ImmiScopeStatic19.AutoSizeEU:=CheckBox19.Checked;
end;

procedure TfTrend.CheckBox20Click(Sender: TObject);
begin
   self.ImmiScopeStatic20.AutoSizeEU:=CheckBox20.Checked;
end;

procedure TfTrend.CheckBox14Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to Chart1.SeriesList.Count-1 do
      (Chart1.Series[i] as TLineSeries).Stairs:=CheckBox14.Checked;
end;

procedure TfTrend.CheckBox4Click(Sender: TObject);
begin
 self.ImmiScopeStatic2.AutoSizeEU:=CheckBox4.Checked;
end;

procedure TfTrend.CheckBox5Click(Sender: TObject);
begin
    self.ImmiScopeStatic3.AutoSizeEU:=CheckBox5.Checked;
end;

procedure TfTrend.CheckBox6Click(Sender: TObject);
begin
  self.ImmiScopeStatic4.AutoSizeEU:=CheckBox6.Checked;
end;

procedure TfTrend.CheckBox7Click(Sender: TObject);
begin
  self.ImmiScopeStatic5.AutoSizeEU:=CheckBox7.Checked;
end;




procedure TfTrend.BitBtn1Click(Sender: TObject);
var

  dc: HDC;
  isDcPalDevice: BOOL;
  MemDc: hdc;
  MemBitmap: hBitmap;
  OldMemBitmap: hBitmap;
  hDibHeader: Thandle;
  pDibHeader: pointer;
  hBits: Thandle;
  pBits: pointer;
  ScaleX: Double;
  ScaleY: Double;
  ppal: PLOGPALETTE;
  pal: hPalette;
  Oldpal: hPalette;
  i: integer;
  form1: TForm;
begin
//     self.PrintScale:=poProportional;
      Printer.Orientation:=poLandscape;
    self.Print;
    exit;
   form1:=self;
   self.PrintDialog1.Execute;
  {Получаем dc экрана}
  dc := GetDc(0);
  {Создаем совместимый dc}
  MemDc := CreateCompatibleDc(dc);
  {создаем изображение}
  MemBitmap := CreateCompatibleBitmap(Dc,
    form1.width,
    form1.height);
  {выбираем изображение в dc}
  OldMemBitmap := SelectObject(MemDc, MemBitmap);

  {Производим действия, устраняющие ошибки при работе с некоторыми типами видеодрайверов}
  isDcPalDevice := false;
  if GetDeviceCaps(dc, RASTERCAPS) and
    RC_PALETTE = RC_PALETTE then
  begin
    GetMem(pPal, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)));
    FillChar(pPal^, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)), #0);
    pPal^.palVersion := $300;
    pPal^.palNumEntries :=
      GetSystemPaletteEntries(dc,
      0,
      256,
      pPal^.palPalEntry);
    if pPal^.PalNumEntries <> 0 then
    begin
      pal := CreatePalette(pPal^);
      oldPal := SelectPalette(MemDc, Pal, false);
      isDcPalDevice := true
    end
    else
      FreeMem(pPal, sizeof(TLOGPALETTE) +
        (255 * sizeof(TPALETTEENTRY)));
  end;

  {копируем экран в memdc/bitmap}
  BitBlt(MemDc,
    0, 0,
    form1.width, form1.height,
    Dc,
    form1.left, form1.top,
    SrcCopy);
   memDc:= form1.Canvas.Handle;
  if isDcPalDevice = true then
  begin
    SelectPalette(MemDc, OldPal, false);
    DeleteObject(Pal);
  end;

  {удаляем выбор изображения}
  SelectObject(MemDc, OldMemBitmap);
  {удаляем dc памяти}
  DeleteDc(MemDc);
  {Распределяем память для структуры DIB}
  hDibHeader := GlobalAlloc(GHND,
    sizeof(TBITMAPINFO) +
    (sizeof(TRGBQUAD) * 256));
  {получаем указатель на распределенную память}
  pDibHeader := GlobalLock(hDibHeader);

  {заполняем dib-структуру информацией, которая нам необходима в DIB}
  FillChar(pDibHeader^,
    sizeof(TBITMAPINFO) + (sizeof(TRGBQUAD) * 256),
    #0);
  PBITMAPINFOHEADER(pDibHeader)^.biSize :=
    sizeof(TBITMAPINFOHEADER);
  PBITMAPINFOHEADER(pDibHeader)^.biPlanes := 1;
  PBITMAPINFOHEADER(pDibHeader)^.biBitCount := 8;
  PBITMAPINFOHEADER(pDibHeader)^.biWidth := form1.width;
  PBITMAPINFOHEADER(pDibHeader)^.biHeight := form1.height;
  PBITMAPINFOHEADER(pDibHeader)^.biCompression := BI_RGB;

  {узнаем сколько памяти необходимо для битов}
  GetDIBits(dc,
    MemBitmap,
    0,
    form1.height,
    nil,
    TBitmapInfo(pDibHeader^),
    DIB_RGB_COLORS);

  {Распределяем память для битов}
  hBits := GlobalAlloc(GHND,
    PBitmapInfoHeader(pDibHeader)^.BiSizeImage);
  {Получаем указатель на биты}
  pBits := GlobalLock(hBits);

  {Вызываем функцию снова, но на этот раз нам передают биты!}
  GetDIBits(dc,
    MemBitmap,
    0,
    form1.height,
    pBits,
    PBitmapInfo(pDibHeader)^,
    DIB_RGB_COLORS);

  {Пробуем исправить ошибки некоторых видеодрайверов}
  if isDcPalDevice = true then
  begin
    for i := 0 to (pPal^.PalNumEntries - 1) do
    begin
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbRed :=
        pPal^.palPalEntry[i].peRed;
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbGreen :=
        pPal^.palPalEntry[i].peGreen;
      PBitmapInfo(pDibHeader)^.bmiColors[i].rgbBlue :=
        pPal^.palPalEntry[i].peBlue;
    end;
    FreeMem(pPal, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)));
  end;

  {Освобождаем dc экрана}
  ReleaseDc(0, dc);
  {Удаляем изображение}
  DeleteObject(MemBitmap);

  {Запускаем работу печати}
  Printer.BeginDoc;

  {Масштабируем размер печати}
  if Printer.PageWidth < Printer.PageHeight then
  begin
    ScaleX := Printer.PageWidth;
    ScaleY := Form1.Height * (Printer.PageWidth / Form1.Width);
  end
  else
  begin
    ScaleX := Form1.Width * (Printer.PageHeight / Form1.Height);
    ScaleY := Printer.PageHeight;
  end;

  {Просто используем драйвер принтера для устройства палитры}
  isDcPalDevice := false;
  if GetDeviceCaps(Printer.Canvas.Handle, RASTERCAPS) and
    RC_PALETTE = RC_PALETTE then
  begin
    {Создаем палитру для dib}
    GetMem(pPal, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)));
    FillChar(pPal^, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)), #0);
    pPal^.palVersion := $300;
    pPal^.palNumEntries := 256;
    for i := 0 to (pPal^.PalNumEntries - 1) do
    begin
      pPal^.palPalEntry[i].peRed :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbRed;
      pPal^.palPalEntry[i].peGreen :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbGreen;
      pPal^.palPalEntry[i].peBlue :=
        PBitmapInfo(pDibHeader)^.bmiColors[i].rgbBlue;
    end;
    pal := CreatePalette(pPal^);
    FreeMem(pPal, sizeof(TLOGPALETTE) +
      (255 * sizeof(TPALETTEENTRY)));
    oldPal := SelectPalette(Printer.Canvas.Handle, Pal, false);
    isDcPalDevice := true
  end;

  {посылаем биты на принтер}
  StretchDiBits(Printer.Canvas.Handle,
    0, 0,
    Round(scaleX), Round(scaleY),
    0, 0,
    Form1.Width, Form1.Height,
    pBits,
    PBitmapInfo(pDibHeader)^,
    DIB_RGB_COLORS,
    SRCCOPY);

  {Просто используем драйвер принтера для устройства палитры}
  if isDcPalDevice = true then
  begin
    SelectPalette(Printer.Canvas.Handle, oldPal, false);
    DeleteObject(Pal);
  end;

  {Очищаем распределенную память} GlobalUnlock(hBits);
  GlobalFree(hBits);
  GlobalUnlock(hDibHeader);
  GlobalFree(hDibHeader);

  {Заканчиваем работу печати}
  Printer.EndDoc;
 
  end;


  procedure TfTrend.PrintM;
var
  FormImage, FormImage1: TBitmap;
  Info: PBitmapInfo;
  InfoSize: DWORD;
  Image: Pointer;
  ImageSize: DWORD;
  Bits: HBITMAP;
  DIBWidth, DIBHeight: Longint;
  PrintWidth, PrintHeight: Longint;
begin
  Printer.BeginDoc;
  try
    FormImage := GetFormImage;

    Canvas.Lock;
    try
      { Paint bitmap to the printer }

      with Printer, Canvas do
      begin
        Bits := FormImage.Handle;

        GetDIBSizes(Bits, InfoSize, ImageSize);
        Info := AllocMem(InfoSize);
        try
          Image := AllocMem(ImageSize);
          try
            GetDIB(Bits, 0, Info^, Image^);
            with Info^.bmiHeader do
            begin
              DIBWidth := biWidth;
              DIBHeight := biHeight;
            end;
            case PrintScale of
              poProportional:
                begin
                  PrintWidth := MulDiv(DIBWidth, GetDeviceCaps(Handle,
                    LOGPIXELSX), PixelsPerInch);
                  PrintHeight := MulDiv(DIBHeight, GetDeviceCaps(Handle,
                    LOGPIXELSY), PixelsPerInch);
                end;
              poPrintToFit:
                begin
                  PrintWidth := MulDiv(DIBWidth, PageHeight, DIBHeight);
                  if PrintWidth < PageWidth then
                    PrintHeight := PageHeight
                  else
                  begin
                    PrintWidth := PageWidth;
                    PrintHeight := MulDiv(DIBHeight, PageWidth, DIBWidth);
                  end;
                end;
            else
              PrintWidth := DIBWidth;
              PrintHeight := DIBHeight;
            end;
            StretchDIBits(Canvas.Handle, 0, 0, PrintWidth, PrintHeight, 0, 0,
              DIBWidth, DIBHeight, Image, Info^, DIB_RGB_COLORS, SRCCOPY);
          finally
            FreeMem(Image, ImageSize);
          end;
        finally
          FreeMem(Info, InfoSize);
        end;
      end;
    finally
      Canvas.Unlock;
      FormImage.Free;
    end;
  finally
    Printer.EndDoc;
  end;
end;

procedure TfTrend.ExprGraphButtonMulti1Click(Sender: TObject);
var i: integer;
     strV: string;
     tmptrdf: TTrenddefList;
begin
 tmptrdf:= getTrdef;
 if (tmptrdf=nil)
          then
          begin
          if (sender is Tbutton) then Tbutton(sender).caption:='Пусто';
          exit;
          end;
inherited;

   if (Sender = ExprGraphMulti1) then
      begin
      Chart1.Series[0].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr1(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti1.Caption)^.iname);
           ExprNameLabelMulti1.Caption:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.comment;

           //Chart1.Series[0].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
          // Chart1.Series[0].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti1.Caption:='Пусто';
      end;

     if (Sender = ExprGraphMulti2) then
      begin
      Chart1.Series[1].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr2(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti2.Caption)^.iname);
           ExprNameLabelMulti2.Caption:=getTrdef.GetInfo(ExprGraphMulti2.Caption)^.comment;
          // Chart1.Series[1].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
          // Chart1.Series[1].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti2.Caption:='Пусто';
      end;


      if (Sender = ExprGraphMulti3) then
      begin
      Chart1.Series[2].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr3(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti3.Caption)^.iname);
           ExprNameLabelMulti3.Caption:=getTrdef.GetInfo(ExprGraphMulti3.Caption)^.comment;
         //  Chart1.Series[2].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
          // Chart1.Series[2].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti3.Caption:='Пусто';
      end;


      if (Sender = ExprGraphMulti4) then
      begin
      Chart1.Series[3].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr4(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti4.Caption)^.iname);
           ExprNameLabelMulti4.Caption:=getTrdef.GetInfo(ExprGraphMulti4.Caption)^.comment;
         //  Chart1.Series[3].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
         //  Chart1.Series[3].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti4.Caption:='Пусто';
      end;







      if (Sender = ExprGraphMulti5) then
      begin
      Chart1.Series[4].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr5(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti5.Caption)^.iname);
           ExprNameLabelMulti5.Caption:=getTrdef.GetInfo(ExprGraphMulti5.Caption)^.comment;
         //  Chart1.Series[4].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
         //  Chart1.Series[4].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti5.Caption:='Пусто';
      end;

     if (Sender = ExprGraphMulti6) then
      begin
      Chart1.Series[5].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr6(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti6.Caption)^.iname);
           ExprNameLabelMulti6.Caption:=getTrdef.GetInfo(ExprGraphMulti6.Caption)^.comment;
          //  Chart1.Series[5].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
           //Chart1.Series[5].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti6.Caption:='Пусто';
      end;


      if (Sender = ExprGraphMulti7) then
      begin
      Chart1.Series[6].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr7(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti7.Caption)^.iname);
           ExprNameLabelMulti7.Caption:=getTrdef.GetInfo(ExprGraphMulti7.Caption)^.comment;
         //   Chart1.Series[6].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
         //  Chart1.Series[6].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti7.Caption:='Пусто';
      end;


      if (Sender = ExprGraphMulti8) then
      begin
      Chart1.Series[7].Clear;
      if TButton(Sender).Caption<>'Пусто' then
         begin
           QueryExpr8(StartT,StopT,getTrdef.GetInfo(ExprGraphMulti8.Caption)^.iname);
           ExprNameLabelMulti8.Caption:=getTrdef.GetInfo(ExprGraphMulti8.Caption)^.comment;
        //   Chart1.Series[7].MaxYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.maxeu;
        //   Chart1.Series[7].MinYValue:=getTrdef.GetInfo(ExprGraphMulti1.Caption)^.mineu;
         end
      else ExprNameLabelMulti8.Caption:='Пусто';
      end;


      CheckChart;



end;


procedure TfTrend.QueryExpr1(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete1, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr2(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete2, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr3(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete3, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr4(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete4, getTrdef);
   except
   end;
  finally
  end;
end;


procedure TfTrend.QueryExpr5(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete5, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr6(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete6, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr7(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete7, getTrdef);
   except
   end;
  finally
  end;
end;

procedure TfTrend.QueryExpr8(timstart: TDateTime; timstop: TDateTime;  aTagid: string);
 var TTread_T: TTrendThread;
     tmp1, tmp2: string;
begin
  try
   try
   tmp1:=datetimetostr(timstart);
   tmp2:=datetimetostr(timstop);
   TTread_T:=TTrendThread.create(dbmanager,connectionstr,aTagid,timstart, timstop,
   QueryFetchComplete8, getTrdef);
   except
   end;
  finally
  end;
end;



procedure TfTrend.QueryFetchComplete1(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[0].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[0].AddXY(data.point[i][2],data.point[i][1])
             end;
           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
    OutCurrentValue;
    drawFill;
end;

procedure TfTrend.QueryFetchComplete2(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[1].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[1].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
     OutCurrentValue;
end;


procedure TfTrend.QueryFetchComplete3(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[2].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[2].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;


           setlength(data.point,0);
           setlength(data.time,0);
         end;
   OutCurrentValue;
end;

procedure TfTrend.QueryFetchComplete4(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[3].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[3].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
    OutCurrentValue;
end;


procedure TfTrend.QueryFetchComplete5(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[4].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[4].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
     OutCurrentValue;
end;

procedure TfTrend.QueryFetchComplete6(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[5].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[5].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
    OutCurrentValue;
end;


procedure TfTrend.QueryFetchComplete7(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[6].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[6].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
   OutCurrentValue;
end;

procedure TfTrend.QueryFetchComplete8(data: tTDPointData;
   Error: integer);
var
    i: integer;
begin
     Chart1.Series[7].Clear;
     if data.npoint>0 then
        begin
           for i:=0 to data.npoint-1 do
             begin
              Chart1.Series[7].AddXY(data.point[i][2],data.point[i][1])
             end;

           resabs.n:= data.ntime;
           setlength( resabs.point,data.ntime);
           for i:=0 to data.ntime-1 do
             begin
                resabs.point[i][1]:=data.time[i][1];
                resabs.point[i][2]:=data.time[i][2];
             end;

           setlength(data.point,0);
           setlength(data.time,0);
         end;
    OutCurrentValue;
end;

function  TfTrend.getStartT: TDateTime;
begin
   result:=fStartT;
end;

function  TfTrend.getStopT: TDateTime;
begin
   result:=fStopT;
end;


function TfTrend.getTrdef: TTrenddefList;
var fDM: TMainDataModule;
begin
 if (csDesigning  in ComponentState) then
  begin
      result:=nil;
      exit;
  end;
try

if TRENDLIST_GLOBAL_TREND=nil then
   begin
     try
      fDM:=TDBManagerFactory.buildManager(dbmanager,connectionstr, dbaReadOnly);
      if fDM<>nil then
      begin
         try
         fDM.Connect;
         try
         TRENDLIST_GLOBAL_TREND:=fDM.regTrdef();
         if TRENDLIST_GLOBAL_TREND.Count=0 then raise Exception.Create('Trenddef пуст или не существует');
         except
           if TRENDLIST_GLOBAL_TREND<>nil then
           freeAndNil(TRENDLIST_GLOBAL_TREND);
           NSDBErrorMessage(NSDB_TRENDDEF_ERR);
           if fDM<>nil then fdM.Free;
           exit;
         end
         except
           TRENDLIST_GLOBAL_TREND:=nil;
           NSDBErrorMessage(NSDB_CONNECT_ERR);
         end;
      end else NSDBErrorMessage(NSDB_CONNECT_ERR);
     finally
       if fDM<>nil then fdM.Free;
     end;
    // result:=TRENDLIST_GLOBAL_ISC;
   end;

except
TRENDLIST_GLOBAL_TREND:=nil;
end;
result:=TRENDLIST_GLOBAL_TREND;
end;

procedure TfTrend.boutClick(Sender: TObject);
begin
  if chartisActive then
   begin
   UpdateChart();
   end;
end;


procedure TfTrend.UpdateChart;
begin
  if (ExprGraphMulti1.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti1);
  if (ExprGraphMulti2.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti2);
  if (ExprGraphMulti3.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti3);
  if (ExprGraphMulti4.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti4);
  if (ExprGraphMulti5.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti5);
  if (ExprGraphMulti6.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti6);
  if (ExprGraphMulti7.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti7);
  if (ExprGraphMulti8.Caption<>'Пусто') then ExprGraphButtonMulti1Click(ExprGraphMulti8);
end;

procedure TfTrend.CheckChart;
var  rectS: TRect;
begin
  if ((ExprGraphMulti1.Caption='Пусто') and
  (ExprGraphMulti2.Caption='Пусто') and
  (ExprGraphMulti3.Caption='Пусто') and
  (ExprGraphMulti4.Caption='Пусто') and
  (ExprGraphMulti5.Caption='Пусто') and
  (ExprGraphMulti6.Caption='Пусто') and
  (ExprGraphMulti7.Caption='Пусто') and
  (ExprGraphMulti8.Caption='Пусто')) then
    begin
       self.Chart1.Series[0].AddXY(fStartT,0);
       self.Chart1.Series[0].AddXY(fStopT,0);
       setlength(resabs.point,1);
       resabs.n:=1;
       resabs.point[0][1]:=fStartT;
       resabs.point[0][2]:=fStopT;


    end else
    begin
       if (ExprGraphMulti1.Caption='Пусто') then
             self.Chart1.Series[0].clear;

    end;
end;

procedure TfTrend.bLeft100Click(Sender: TObject);
begin

 fStartT:=ImmiScopeNill.StartTm;
 fStopT:=ImmiScopeNill.StartTm+ImmiScopeNill.TimePeriod;
  if chartisActive then
   begin
     UpdateChart();
   end;
end;

procedure TfTrend.bTimeClick(Sender: TObject);
begin
 self.fStartT:=ImmiScopeNill.StartTm;
 self.fStopT:=ImmiScopeNill.StartTm+ImmiScopeNill.TimePeriod;
  if chartisActive then
   begin
     UpdateChart();
   end;
end;

function TfTrend.TAxisToScreen(TimePos: TTime): longint;
begin
    result:= Chart1.BottomAxis.CalcPosValue(TimePos);
end;

procedure TfTrend.ExprNameLabelMulti1Click(Sender: TObject);
begin
//

end;




procedure TfTrend.ImmiGraphTrBr13Change(Sender: TObject);
begin
   DrawTimeXorLine;
   DrawZoomXorLine;
   TImmiGraphTrBr(sender).SliderMouseMove(sender);
   OutCurrentValue;
end;


procedure TfTrend.drawFill;
 var
   rectS: TRect;
   startT,stopT,nowT: Tdatetime;
   i: integer;
begin
  if (fStopT-fStartT)<>0 then
  for i:=0 to resabs.n-1 do
    begin
      Chart1.Canvas.Pen.Mode:= pmCopy	;
      Chart1.Canvas.Brush.Color:=clGray;
      Chart1.Canvas.Pen.Color:=clGray;
      rectS.Left:=round(((resabs.point[i][1]-fStartT)/
      (fStopT-fStartT))*(Chart1.ChartRect.Right-Chart1.ChartRect.Left))+Chart1.ChartRect.Left;
      rectS.Right:=round(((resabs.point[i][2]-fStartT)/
      (fStopT-fStartT))* (Chart1.ChartRect.Right-Chart1.ChartRect.Left))+Chart1.ChartRect.Left;
      rects.Top:=Chart1.ChartRect.top;
      rects.Bottom:=Chart1.ChartRect.bottom;
      Chart1.Canvas.Brush.Color:=clGray;
      Chart1.Canvas.FillRect(rectS);
     /// Chart1.Canvas.DoRectangle(rects);

 
    end;
end;

procedure TfTrend.Chart1AfterDraw(Sender: TObject);
begin
 drawFill;
end;

procedure TfTrend.ToolButton7Click(Sender: TObject);
begin
bTime.Click;
bTimeClick(bTime);

end;

procedure TfTrend.ToolButton8Click(Sender: TObject);
begin
   bLeft100.Click;
   bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton9Click(Sender: TObject);
begin
   bLeft50.Click;
   bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton10Click(Sender: TObject);
begin
  bIn.Click;
  bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton11Click(Sender: TObject);
begin
 bOut.Click;
 bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton12Click(Sender: TObject);
begin
bRight50.Click;
bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton13Click(Sender: TObject);
begin
  bRight100.Click;
  bLeft100Click(Sender);
end;

procedure TfTrend.ToolButton14Click(Sender: TObject);
begin
bNow.Click;
bLeft100Click(Sender);
end;

procedure TfTrend.setConnInfo(DBT: integer; constr: string);
begin
  fDBMenagType:=DBT;
  fconstr:=constr;
end;



initialization
 TRENDLIST_GLOBAL_TREND:=nil;
finalization
 try
 if TRENDLIST_GLOBAL_TREND<>nil then TRENDLIST_GLOBAL_TREND.Free;
 except
end;

end.










