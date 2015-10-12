unit ConstDef;
{$WRITEABLECONST ON}

interface
uses SysUtils, Classes, dbTables, Dialogs, messages, Forms, Windows,
 controls, Registry, GlobalValue,DateUtils,XMLDoc,XMLIntf,MATH;

type
  MyProcType = function (Code: integer; wParam: word;
  lParam: Longint): Longint; stdcall;
  SwitchProcType = procedure (IsOn: boolean); stdcall;

const
  wm_LeftShow_Event = wm_User + 133;
  wm_RightShow_Event = wm_User + 134;
  wm_UpShow_Event = wm_User + 135;
  wm_DownShow_Event = wm_User + 136;

    KvitTegName: string ='RKVIT';

const NILL_ANALOG: single = -10000000000;
const NILL_ANALOGDOUBLE: double = -1000000000000;


type
  tresolution = (r640, r800, r1024, r1280);
  TExprStr = string[255];
  PoInteger = ^Integer;
  PoString = ^string;
  arrbool = array [0..999] of boolean;
  PoBoolean = ^arrbool;
const
  resolution : tresolution = r1280;

  DirForms = 'forms\';

  alarmShift = 100000;
  calcShift  = 900000;


  LevelOper      = 1000;
  LevelFighOper  = 3000;
  LevelTehnolog  = 4000;
  LevelBoss      = 8000;
  levelDeveloper = 9999;

  WM_IMMIInit     = WM_USER + 10001;
  WM_IMMIUnInit   = WM_USER + 10002;
  WM_IMMIUpdate   = WM_USER + 10003;
  WM_IMMIBlinkOn  = WM_USER + 10004;
  WM_IMMIBlinkOff = WM_USER + 10005;

  WM_IMMIChange     = WM_USER + 10010;
  WM_IMMILog        = WM_USER + 10011;
  WM_IMMIEvent      = WM_USER + 10012;
  WM_IMMIAlarm      = WM_USER + 10013;
  WM_IMMIAlarmLocal = WM_USER + 10014;
  WM_IMMICommand    = WM_USER + 10015;
  WM_IMMIKvit       = WM_USER + 10016;
  WM_IMMINewRef     = WM_USER + 10017;
  WM_IMMIRemRef     = WM_USER + 10018;
  WM_IMMINewAlarm   = WM_USER + 10019;

  WM_IMMIFirstUpd    = WM_USER + 10020; //all modules was maked
  WM_IMMISaveArchive = WM_USER + 10021;

  WM_IMMIValid       = WM_USER + 10022; //��� ������� ����������

  WM_IMMILogInside        = WM_USER + 10023;

  WM_IMMIEDITFORM    = WM_USER + 10100;
  WM_IMMIRUNFORM     = WM_USER + 10101;
  WM_IMMISaveFORM    = WM_USER + 10102;

  WM_IMMIUSERCHANGED = WM_USER + 10200;

  WM_IMMSHOWPROPFORM    = WM_USER + 10300;
  WM_ALLETHERSERVERDESTROY = WM_USER +1235;
  WM_IMMIKEYSET = WM_USER +1236;
  WM_IMMICLOSEALL = WM_USER +1237;
  WM_IMMIMODECHANGED = 10400;
  WM_IMMIITEMCREATED = 10401;

  WM_IMMIDICSHOWTAG = 10500;

  type
  TNSNodeType =  (ntO, ntG,   ntT,  ntA,   ntS,   ntGG,
                ntGl,ntTl,  ntArc, ntSl,  ntGGl, ntOT,
                ntGT, ntTT, ntAT, ntST,  ntGGT,  ntOll,

                ntOBase, ntOSimple, ntODKoy ,ntOOPCHDA,  ntOOPC, ntODDE,
                ntOnet, ntOEthKoy, ntOSysVar, ntOSystem, ntOReport, ntOPoint,
                ntOServCount, tnoSpac, prjProp,

                ntTDiskr, ntTByte, ntTShortI, ntWord, ntSmallI, ntLongW,
                ntInt, ntSing, ntReal48, ntReal, ntChar, ntText, ntRepY, ntRepM,
                ntRepDec, ntRepD, ntRepH, ntEvent, ntAnEvent, ntOsc, ntRepMin,
                ntRep10Min, ntRep30Min, ntRepQart,ntDT,

                ntOLogika,

                // ���������� �������
                cdtErr, cdtmeta,
                cdtHomeList, cdtReportList,cdtTrendList, cdtMessageList,
                {cdtHomeList}
                {cdtReportList}cdtReportHeader, cdtReportArr, cdtunit,
                {cdtTrendList}cdtTrendHeader, cdtTrendArr, cdttrend,
                {cdtMessageList}cdtMainMessageHeader,cdtMessageHeader,
                {cdtMainMessageHeader}cdtMainGroup,
                {cdtMessageHeader}cdtGroup,
                {cdtGroup}cdtmsgtag,

                ntComands , ntOReportCnt ,
                ntOSET
                );

  TNSNodeSet = set of TNSNodeType;
  //������ ������� ����������, ����� �������� ����� ���� ������� ��� ��������������
  TAcceptArray = array[TNSNodeType] of TNSNodeSet;

const
  tegSet: TNSNodeSet = [ntOT, ntGT, ntTT, ntAT, ntST, ntGGT,
   ntTDiskr, ntTByte, ntTShortI, ntWord, ntSmallI, ntLongW,
   ntInt, ntSing, ntReal48, ntReal, ntChar, ntText,ntRepY, ntRepM, ntRepDec, ntRepD, ntRepH, ntEvent, ntAnEvent, ntOsc,
   ntRepMin, ntRep10Min, ntRep30Min, ntRepQart ,ntDT
  ];
  NodeCanChildSet: TNSNodeSet = [ ntG, ntT, ntArc, ntGG, ntGl, ntTl, ntSl, ntGGl,
  ntO];
  NodeCanDeletedSet: TNSNodeSet = [ntOBase, ntOSimple,  ntOOPCHDA,  ntOOPC, ntGl, ntTl, ntArc, ntAT, ntSl, ntGG, ntGGl, ntGGT, ntOT];
  NodeIsTegsParentSet: TNSNodeSet = [ntOll];
  NodeBaseSet: TNSNodeSet = [ ntG, ntT, ntA, ntS, ntGG,
  ntOBase, ntOSimple,  ntOOPCHDA,  ntOOPC,ntOSysVar, ntOSystem, ntOReport, ntOPoint, ntOServCount, ntComands, ntOReportCnt];

  NodeMidleSet: TNSNodeSet = [ntOBase, ntOSimple,  ntOOPCHDA,  ntOOPC, ntGl, ntTl, ntArc, ntSl, ntGGl];

  ntOl: TNSNodeSet = [ntOBase, ntOSimple, ntODKoy ,ntOOPCHDA,  ntOOPC, ntODDE, ntOnet,ntOll,
  ntOEthKoy,ntOSysVar, ntOSystem, ntOReport, ntOPoint, ntOServCount, tnoSpac, ntOLogika,ntComands, ntOReportCnt, ntOSET];
  ntOSys: TNSNodeSet = [ntOSysVar, ntOSystem, ntOReport, ntOPoint, ntOServCount, ntComands, ntOReportCnt];
  ntOldif: TNSNodeSet = [ ntOSimple, ntODKoy, ntOEthKoy ];
  ntRefresh: TNSNodeSet = [  ntA, ntS,ntG ];
  ntArch: TNSNodeSet = [ntRepY, ntRepM,
                ntRepDec, ntRepD, ntRepH,ntRepMin,
                ntRep10Min, ntRep30Min, ntRepQart];

  ntMeta: TNSNodeSet = [cdtReportHeader, cdtReportArr, cdtunit,
                        cdtTrendHeader, cdtTrendArr, cdttrend,
                        cdtMessageHeader,cdtGroup,cdtmsgtag];

  ntMovable: TNSNodeSet = [ cdtReportHeader, cdtReportArr, cdtunit,
                        cdtTrendHeader, cdtTrendArr, cdttrend,
                         cdtGroup,cdtmsgtag];

  acceptCopyArray: TAcceptArray =
    ([],[],[ntOT, ntGT],[ntOT, ntGT],[ntGl],
     [],[ntOT, ntGt],[ntOT, ntGT],[ntAt],[],[ntOT, ntGGT, ntGGl, ntGl],
     [],[],[ntTl, ntTT],[],[],[],
     [],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ,[],[],[] ,[],[],[],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[] ,[]
     );
  acceptMoveArray: TAcceptArray =
    ([],[],[],[],[ntGGl],
     [ntOT],[ntGT],[ntTl, ntTT],[],[],[ntGGT, ntGGl, ntGl],
     [],[],[ntTl, ntTT],[],[],[],
     [],
      [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
      [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
      [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]
      );
  //���������� �������� �� ��������� ��� ��������������
  //���� ������,�� �� ��������� ��������, ����� ���������
  //��������� � �������� ���� ���, ������������ �� ��������
  DefaultCopyArray :TAcceptArray =
    ([ntOll],[ntOll],[ntOll],[ntOLl],[ntOll],
     [],[ntOll],[ntOll],[ntOLl],[ntOLl],[ntOll],
     [],[],[],[],[], [],
     [],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],
     [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]
    );

const
   NSDB_REQEST_OK = 0;
   NSDB_CONNECT_ERR = -1;
   NSDB_REQEST_ERR = -2;
   NSDB_TRENDDEF_ERR = -3;
   NSDB_NOADD_ERR = -4;
   NSDB_NODEL_ERR = -5;
const




   VALID_LEVEL = 90;   // ������� ����������, ������ ������ - �������


   REPORT_NOACTIVE =      0;   //  ���� ������������
   REPORT_NEEDKHOWDEEP = 10;   // ������ i/o ������������ �� ���� ������ �������� ������� ������  �������
   REPORT_NEEDREQUEST =  20;   //  ��� ����� ��������� � ������ ����� ���������� last ����������
   REPORT_NODATA =       30;          // ������ i/o ���������, ��� ������ �� ��������
                                      // ������ ����������� �����

   REPORT_DATA =         40;          // ������ ������ �� ������� i/o - ���������� ��������
   REPORT_NORMAL =      100;   //  ��� ����� ������� ������� � ���� ��������� ������ �� ����������� ����� �
   REPORT_WRITE =         50;   //  ������ ������ ������������� �� ������

   REPORT_NEEDWAIT =      45;   //  ������ ������������ ������� �� ����� ������ � ������ ���������
   REPORT_WAIT =          46;   //  �������� ������� ��������� ���� ������ � ����
   REPORT_WAITSOURCE =          47;   //  �������� �������  ���� ������ ���������

   REPORT_WRITED =         60;   //  ����� ������ ������������� (������)
   REPORT_NOWRITED =         61;   //  ����� ������ ������������� (��������)

   //����������� ����� � �������    LogTime

   EVENT_TYPE_WITH_TIME_VAL=-500;   // ��� ������� �����������, Logtime=-500
   EVENT_TYPE_WITHTIME=-999;        // ��� ������� � ��������� ��������, Logtime=-999
   EVENT_TYPE_ALARM=-850;            // ��� ������� � ��������� �������� � ���������� ���������, Logtime=-850
   EVENT_TYPE_OSC=-501;              // ������� �����������


   TYPE_DISCRET =-101;                     // ���������� ���������
   TYPE_INTEGER= -102;                     //32 ���������� �������������
   TYPE_DOUBLE = -103;                     //32 ���������� ��������� �����
   TYPE_LONGWORD = -104;                      //32 ���������� ������������� ��� �����
   TYPE_SMALLINT= -105;                    //16 ���������� �������������
   TYPE_WORD	=   -106;                      //16 ���������� ������������� ��� �����
   TYPE_SHORTINT= -107;                    //8 ���������� �������������
   TYPE_BYTE	=   -108;                      //8 ���������� ������������� ��� �����

   TYPE_SINGLE	=   -109;                      //4 ���������� ������������� ��� �����
   TYPE_REAL48	  =   -110;                      //6 ���������� ������������� ��� �����

   TYPE_CHAR	=   -121;                      //���������� ���������
   TYPE_TEXT	  =   -122;                    // ��������� ���������

   TYPE_DT	  =   -130;                    // ��������� ���������

   TYPE_NODEF = - 100;

   //�������� ���������

   //�������     LogTime

   REPORTTYPE_YEAR = 8;
   REPORTTYPE_MIN = 3;
   REPORTTYPE_HOUR = 4;
   REPORTTYPE_DEC = 5;        //��������
   REPORTTYPE_DAY = 6;
   REPORTTYPE_MONTH = 7;
   REPORTTYPE_10MIN = 9;
   REPORTTYPE_30MIN = 10;
   REPORTTYPE_QVART = 11;
   REPORTTYPE_CUSTOM = 12;
   REPORTTYPE_NONE = 0;

   //   ���� ��������������     PreTime

   REPORTAGR_INTEG = 1;
   REPORTAGR_MID = 2;
   REPORTAGR_MIN = 3;
   REPORTTYPE_MAX = 4;
   REPORTTYPE_SCO = 5;


   ALARMTYPE_NONE = 0;
   ALARMTYPE_ALARM = 1;
   ALARMTYPE_AVAR = 2;


   //
   //DEBUGLEVEL
     DEBUGLEVEL_HIGH = 2;
     DEBUGLEVEL_MIDLE = 4;
     DEBUGLEVEL_LOW = 8;

   // debugmessagetype
     _DEBUG_FATALERROR = 16;
     _DEBUG_ERROR = 8;
     _DEBUG_WARNING = 4;
     _DEBUG_MESSAGE = 2;


 //  ������ ������� Koyo
     const
      ERRP_R_NONE=0;
      ERRP_R_1=1;
      ERRP_R_2=2;
      ERRP_R_3=3;
      ERRP_R_4=4;
      ERRP_R_5=5;
      ERRP_R_6=6;
      ERRP_W_NONE=0;
      ERRP_W_1=1;
      ERRP_W_2=2;
      ERRP_W_3=3;
      ERRP_W_4=4;


 //  ����������� ��������� ������� ASCII

    const
     ENQ = #05;
     ACK = chr($06);
     NAK = chr($15);
     SOH = chr($01);
     ETB = chr($17);
     STX = chr($02);
     ETX = chr($03);
     EOT = chr($04);
     ISI = chr($1F);
     DLE = chr($10);
     HT =  chr($09);
     FF =  chr($0C);

const  REPORT_SET   = [REPORTTYPE_YEAR, REPORTTYPE_HOUR,
         REPORTTYPE_DEC, REPORTTYPE_DAY, REPORTTYPE_MONTH,
          REPORTTYPE_30MIN, REPORTTYPE_10MIN, REPORTTYPE_MIN,REPORTTYPE_QVART];

const  REPORT_SET_ONETAB   = [REPORTTYPE_YEAR,  REPORTTYPE_MONTH,
          REPORTTYPE_QVART];

const  REPORT_SET_YEARTAB   = [REPORTTYPE_DAY, REPORTTYPE_DEC
          ];

const  REPORT_SET_MONTHTAB   = [REPORTTYPE_HOUR,
          REPORTTYPE_30MIN, REPORTTYPE_10MIN, REPORTTYPE_MIN
          ];

type TReportCol = array of double;

type TReportTable = record
        tab: array of TReportCol;
        count: integer;
      end;



type
   TJournalMessageType = (ejEvent, ejOn, ejOff, ejCommand, ejAlOn, ejAlOff, ejAlKvit);
   TJournalMessageSet = set of TJournalMessageType;

type
TDPoint =array[1..2] of Double;
type
  tTDPoint =  record
  point: array of TDPoint;
  n: integer;
end;


type
TDPointData =array[1..2] of Double;
type
  tTDPointData =  record
  point: array of TDPointData;
  time: array of TDPointData;
  npoint: integer;
  ntime: integer;
end;

type
pTDPointData=^TDPointData;

type
  TEprBoolNotyfy = procedure (State: boolean; BlinkState: boolean) of object;
  TEprValueNotyfy = procedure (Value: double) of object;
type
  NameString = string[50];

const
  CurrentBaseVersion = 4;

  tmRun = 0;
  tmPoint = 100;

  tmCreateIMMILabelFull = 200;
  tmCreateIMMIImg1 = 201;
  tmCreateIMMIShape = 202;

  tmCreateAlarmTriangle = 300;
  tmCreateArmatVl = 301;
  tmCreateArmatBm = 302;
  tmCreateRegul = 303;
  tmCreateTube = 304;

  tmCreateGo = 400;
  tmCreateEditReal = 401;
  tmCreateTrackBar = 402;
  tmCreateSpeedButton = 403;
  tmCreateBitBtn = 404;
  tmCreateValueEntry = 405;

var
  AccessLevel: PoInteger;
  OperatorName: PoString;
  CurrantKey: PoString;
  ToolMode: integer;
  ComputerName: String;


  P: Pointer;
  SwitchProc: SwitchProcType;
const
  blockIsSet: boolean = false;

procedure SetAccessL(value: integer);
procedure RegisterAccessDLL;
procedure UnRegisterAccessDLL;
procedure SwitchTaskMgr(val: integer);
function gettypeMetaByname(nm: string): TNSNodeType;
function getTextMetaByName(nm: IXMLNode): string;
function getTextJmessage(typ: TJournalMessageType): string;
procedure SendMessageBroadcast(Msg: cardinal; WParam, lParam: longInt);
procedure Immi_BroadCast(ownerM: tcomponent; var Msg: TMessage);
function  getTypeDataItem(val: integer): string;
function  incPeriod(typ_: integer; dt: TDateTime; v: integer =1): TDateTime;
function  GetDeepUtil(typ_: integer; reqdeep: integer): integer;
function  GetTimeReqByTabTime(tm: TDateTime; typ_: integer; delt: integer; countrep: boolean = false): TDateTime;
function  GetTimeReqByTabTimeforRep(tm: TDateTime; typ_: integer; countrep: boolean = false): TDateTime;
function  GetTimeReqByTabTimeforSys(tm: TDateTime; typ_: integer; delt: integer): TDateTime;
function  GetHistTm(typ_:  integer; hp: integer): TDateTime;
function normalizeHour(vl: TDateTime): TDateTime;
function  roundPeriod(typ_: integer;  dt: TDateTime;  delt: integer): TDateTime;
function  getBaseReportPeriodByUnit(tp: integer): integer;
procedure NSErrorMessage(mes: string);
procedure NSDBErrorMessage(mes: integer);




implementation
var
  ComputerNameArr: array [0..MAX_COMPUTERNAME_LENGTH] of char;
  ComputerNameLen: DWORD;


procedure NSErrorMessage(mes: string);
begin
   MessageBox(0,PChar(mes),'������',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
end;



procedure NSDBErrorMessage(mes: integer);
begin
  case mes of
   NSDB_CONNECT_ERR: NSErrorMessage('�� ������� �������� � �������� ��!');
   NSDB_REQEST_ERR: NSErrorMessage('������������ ������ � ��!');
   NSDB_TRENDDEF_ERR: NSErrorMessage('������� �������� TrendDef ����� ��� �� ����������!');
   NSDB_NOADD_ERR: NSErrorMessage('�������� ������� �������� TrendDef �������� � ��������!');
   NSDB_NODEL_ERR: NSErrorMessage('�� ������� ������� ��� ������ ������ TrendDef!')
   end;
end;






//  ������� ������ ������ �� ���� �������� ������
function  getBaseReportPeriodByUnit(tp: integer): integer;
begin
   result:=REPORTTYPE_NONE;
   case tp of
   REPORTTYPE_YEAR:   result:=REPORTTYPE_CUSTOM;
   REPORTTYPE_QVART:  result:=REPORTTYPE_YEAR;
   REPORTTYPE_MONTH:  result:=REPORTTYPE_YEAR;
   REPORTTYPE_DEC:    result:=REPORTTYPE_MONTH;
   REPORTTYPE_DAY:    result:=REPORTTYPE_MONTH;
   REPORTTYPE_HOUR:   result:=REPORTTYPE_DAY;
   REPORTTYPE_30MIN:  result:=REPORTTYPE_DAY;
   REPORTTYPE_10MIN:  result:=REPORTTYPE_HOUR;
   REPORTTYPE_MIN:    result:=REPORTTYPE_HOUR;
   REPORTTYPE_CUSTOM: result:=REPORTTYPE_NONE;
   else result:=REPORTTYPE_NONE;
   end;
end;


function getTextJmessage(typ: TJournalMessageType): string;
begin
  case typ of
  ejEvent:   result:='Event';
  ejOn:      result:='On';
  ejOff:     result:='Off';
  ejCommand: result:='Command';
  ejAlOn:    result:='A_On';
  ejAlOff:   result:='A_Off';
  ejAlKvit:  result:='A_Kvit';
  end;
end;


function getTypeDataItem(val: integer): string;
begin
  case val of
   EVENT_TYPE_WITH_TIME_VAL: result:='EVENT_TWTL';
   EVENT_TYPE_WITHTIME:      result:='EVENT_TWT';
   EVENT_TYPE_ALARM:         result:='EVENT_TALARM';
   EVENT_TYPE_OSC:           result:='EVENT_TOSC';

   TYPE_DISCRET: result:='discret';
   TYPE_INTEGER: result:='int';
   TYPE_DOUBLE: result:='real';
   TYPE_LONGWORD: result:='longword';
   TYPE_SMALLINT: result:='smallint';
   TYPE_WORD: result:='word';
   TYPE_SHORTINT: result:='sortint';
   TYPE_BYTE: result:='byte';

   TYPE_SINGLE: result:='single';
   TYPE_REAL48: result:='real48';

   TYPE_CHAR: result:='char';
   TYPE_TEXT: result:='text';
   TYPE_DT: result:='datetime';

   REPORTTYPE_YEAR: result:='report_y';
   REPORTTYPE_MIN: result:='report_min';
   REPORTTYPE_HOUR: result:='report_h';
   REPORTTYPE_DEC: result:='repot_dec';
   REPORTTYPE_DAY: result:='report_d';
   REPORTTYPE_MONTH: result:='report_m';
   else result:='default';
   end;
end;

function normalizeHour(vl: TDateTime): TDateTime;
begin
 result:=round(vl*24)*1.0/24;
end;


function  incPeriod(typ_: integer;  dt: TDateTime;  v: integer =1): TDateTime;
var tmp_d: integer;
begin

  dt:=Incsecond(dt,1);
  case typ_ of
     REPORTTYPE_YEAR: result:=StartOfTheYear(IncYear(dt,v));

     REPORTTYPE_QVART:  result:=StartOfTheMonth(incMonth(dt,v*4));

     REPORTTYPE_MONTH:  result:=StartOfTheMonth(incMonth(dt,v));

     REPORTTYPE_DEC:
         begin
           if (v=1) then
           begin
           tmp_d:=dayofthemonth(dt);
           if tmp_d<11 then
             result:=StartOftheMonth(dt)+10.0 else
               if tmp_d<21 then
                 result:=StartOftheMonth(dt)+20.0
                   else   result:=StartOftheMonth(dt+12);

            end;

           if (v=-1) then
           begin
           tmp_d:=dayofthemonth(dt);
           if tmp_d<11 then
             result:=incday(StartOftheMonth(incMonth(dt,-1)),20) else
               if tmp_d<21 then
                 result:=incday(StartOftheMonth(dt))
                   else   result:=StartOftheMonth(dt)+10.0;

            end;

           if (v=0) then
           begin
           tmp_d:=dayofthemonth(dt);
           if tmp_d<11 then
             result:=StartOftheMonth(dt) else
               if tmp_d<21 then
                 result:=StartOftheMonth(dt)+10.0
                   else   result:=StartOftheMonth(dt)+20.0;

            end;
         end;

     REPORTTYPE_DAY:  result:=(trunc((incday(dt,v)))*1.0);

     REPORTTYPE_HOUR: result:=(trunc(incHour(dt,v)*24.0))/24.0;

     REPORTTYPE_30MIN: result:=(trunc(((dt+(1.0/48.0*v))*48.0))*1.0)/48.0;

     REPORTTYPE_10MIN: result:=(trunc(((dt+(1.0/144.0*v))*144.0))*1.0)/144.0;

     REPORTTYPE_MIN: result:=(trunc(((dt+(1.0/1440.0*v))*1440.0))*1.0)/1440.0;

   end;
end;



//  ���������� ������� �� ������������� ��������� (���������� HH:59:59.9(9))
//
//  ������� 00:00:00 YYYY-01-00
//  �������� 00:00:00 YYYY-NN-00
//  �������  00:00:00  YYYY-NN-DD
//  �������  HH:00:00  YYYY-NN-DD
//  delt - �������� ����������


function  roundPeriod(typ_: integer;  dt: TDateTime;  delt: integer): TDateTime;
var tmp_d: integer;
begin
  dt:=GetTimeReqByTabTimeforSys(dt,typ_,-1*delt);

  case typ_ of
     REPORTTYPE_YEAR: result:=StartOfTheYear(IncDay(dt,15));

     REPORTTYPE_QVART:  result:=StartOfTheMonth(incDay(dt,15));

     REPORTTYPE_MONTH:  result:=StartOfTheMonth(incDay(dt,10));

     REPORTTYPE_DEC:
         begin
           begin
           tmp_d:=dayofthemonth(dt);
           if tmp_d<11 then
             result:=StartOftheMonth(dt) else
               if tmp_d<21 then
                 result:=StartOftheMonth(dt)+10.0
                   else   result:=StartOftheMonth(dt)+20.0;

            end;
         end;

     REPORTTYPE_DAY:  result:=1.0*round(dt);

     REPORTTYPE_HOUR: result:=(round(dt*24.0))/24.0;

     REPORTTYPE_30MIN: result:=(round(((dt)*48.0))*1.0)/48.0;

     REPORTTYPE_10MIN: result:=(round((dt)*144.0)*1.0)/144.0;

     REPORTTYPE_MIN: result:=(round(((dt)*1440.0))*1.0)/1440.0;

   end;
end;



function  GetDeepUtil(typ_: integer; reqdeep: integer): integer;
begin
  if reqdeep<0 then reqdeep:=abs(reqdeep);
  case typ_ of
     // ������� [1..20]
     REPORTTYPE_YEAR: result:=min(20,max(1,reqdeep));
     // ����������� [1..240]
     REPORTTYPE_QVART:  result:=min(120,max(2,reqdeep));
     // �������� [2..240]
     REPORTTYPE_MONTH:  result:=min(240,max(2,reqdeep));
     // �������� [3..720]
     REPORTTYPE_DEC:  result:=min(720,max(3,reqdeep));
     // ������� [10..1100]
     REPORTTYPE_DAY:  result:=min(1100,max(10,reqdeep));
     //  �������  [5..25000]
     REPORTTYPE_HOUR: result:=min(25000,max(48,reqdeep));
     //  30��������   [48..25000]
     REPORTTYPE_30MIN:  result:=min(25000,max(48,reqdeep));
     //  10��������    [48..25000]
     REPORTTYPE_10MIN:  result:=min(25000,max(48,reqdeep));
     //  ��������    [48..25000]
     REPORTTYPE_MIN:  result:=min(25000,max(48,reqdeep));

   end;
end;



 // ��������� �������� ����� ������ �� �������� �������� ������
function  GetTimeReqByTabTimeforSys(tm: TDateTime; typ_: integer; delt: integer): TDateTime;
begin

   // ���������� ������� �������� ��� ���� ��������� �� ����� 12
   if delt>15 then delt:=15;
   if delt<-15 then delt:=-15;
   case typ_ of
     REPORTTYPE_YEAR: tm:=incDay(tm,delt);
     REPORTTYPE_QVART:  tm:=incDay(tm,delt);
     REPORTTYPE_MONTH: tm:=incDay(tm,delt);
     REPORTTYPE_DEC:   tm:=incDay(tm,delt);
     REPORTTYPE_DAY:   tm:=incHour(tm,delt);
   end;
   result:=tm;
end;


// ��������� �������� � ������� �� ������������ �������
function  GetTimeReqByTabTimeforRep(tm: TDateTime; typ_: integer; countrep: boolean = false): TDateTime;
var h: string;
begin
    h:=Datetimetostr(tm);
  // ��������� ������ '�������' ��������
   case typ_ of
     REPORTTYPE_YEAR:  tm:=incMinute(tm,15);
     REPORTTYPE_QVART:  tm:=incMinute(tm,14);
     REPORTTYPE_MONTH: tm:=incMinute(tm,12);
     REPORTTYPE_DEC:   tm:=incMinute(tm,10);
     REPORTTYPE_DAY:   tm:=incMinute(tm,8);
     REPORTTYPE_HOUR:  tm:=incMinute(tm,4);
     REPORTTYPE_30MIN:   tm:=incMinute(tm,3);
     REPORTTYPE_10MIN:   tm:=incMinute(tm,2);
     REPORTTYPE_MIN:   tm:=incSecond(tm,10);
   end;
   if (countrep) then
      tm:=incMinute(tm,1);
   h:=Datetimetostr(tm);
   result:=tm;
end;

function GetHistTm(typ_:  integer; hp: integer): TDateTime;
var tm,tm2: TDateTime;
begin
   tm:=now;
   case typ_ of
       REPORTTYPE_YEAR: tm2:=incYear(tm,-hp);
       REPORTTYPE_QVART: tm2:=incMonth(tm,-4*hp);
       REPORTTYPE_MONTH: tm2:=incMonth(tm,-hp);
       REPORTTYPE_DEC: tm2:=incDay(tm,-hp*10);       //��������
       REPORTTYPE_DAY:   tm2:=incDay(tm,-hp);
       REPORTTYPE_HOUR: tm2:=incHour(tm,-hp);
       REPORTTYPE_30MIN:  tm2:=incMinute(tm,-hp*30);
       REPORTTYPE_10MIN:  tm2:=incMinute(tm,-hp*10);
       REPORTTYPE_MIN:  tm2:=incMinute(tm,-hp);





  { REPORT_HOUR{4}//: tm2:=incHour(tm,-hp);

   //REPORT_DAY{6}: tm2:=incDay(tm,-hp);
   //REPORT_MONTH{7}: tm2:=incMonth(tm,-hp);
   else  tm2:=incHour(tm,-hp);
   end;
   result:=tm2;
end;

function  GetTimeReqByTabTime(tm: TDateTime; typ_: integer; delt: integer; countrep: boolean = false): TDateTime;
begin

   tm:=GetTimeReqByTabTimeforRep(tm,typ_, countrep);
   tm:=GetTimeReqByTabTimeforSys(tm,typ_,delt);
   result:=tm;
end;



function gettypeMetaByname(nm: string): TNSNodeType;
begin
   result:=cdtErr;
   if nm='meta' then  result:=cdtmeta else
   if nm='HomeList' then  result:=cdtHomeList else
   if nm='ReportList' then  result:=cdtReportList else
   if nm='TrendList' then  result:=cdtTrendList else
   if nm='MessageList' then  result:=cdtMessageList else
   if nm='ReportHeader' then  result:=cdtReportHeader else
   if nm='ReportArr' then  result:=cdtReportArr else
   if nm='unit' then  result:=cdtunit else
   if nm='TrendHeader' then  result:=cdtTrendHeader else
   if nm='TrendArr' then  result:=cdtTrendArr else
   if nm='trend' then  result:=cdttrend else
   if nm='MainMessageHeader' then  result:=cdtMainMessageHeader else
   if nm='MessageHeader' then  result:=cdtMessageHeader else
   if nm='MainGroup' then  result:=cdtMainGroup else
   if nm='Group' then  result:=cdtGroup else
   if nm='msgtag' then  result:=cdtmsgtag;
end;

function getTextMetaByName(nm: IXMLNode): string;
var tmp: TNSNodeType;
begin
   try
   tmp:=gettypeMetaByname(nm.LocalName);
   case tmp of
   cdtmeta: result:='���������� �������';
   cdtHomeList: result:='��������� ��������';
   cdtReportList:  result:='�������� ������ �������';
   cdtTrendList: result:='�������� ������ ��������';
   cdtMessageList: result:='�������� ������ ���������';
   cdtReportHeader,cdtReportArr,cdtTrendHeader,
   cdtTrendArr,cdtMainMessageHeader, cdtGroup:
   begin
   if assigned(nm.AttributeNodes.Nodes['name']) then
   result:=nm.Attributes['name'] else
   result:='';
   end;
   cdtunit,cdttrend,cdtmsgtag:
   begin
     if assigned(nm.AttributeNodes.Nodes['tg']) then
     result:=nm.Attributes['tg'] else
     result:='';
   end;
   else result:=nm.LocalName;
   end;
   except
   end;
end;


procedure SendMessageBroadcast(Msg: cardinal; WParam, lParam: longInt);
var
  i: integer;
begin
  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].visible then
      SendMessage(Screen.Forms[i].Handle, Msg, wParam, lParam);
end;

{function DateToFileName(iDate: TDateTime): String;
var
   OldShortDateFormat: string;
begin
     OldShortDateFormat := ShortDateFormat;
     ShortDateFormat := 'ddmmyyyy';
     result := datetostr(iDate);
     ShortDateFormat := oldShortDateFormat;
end;

function MonthToFileName(iDate: TDateTime): String;
var
   OldShortDateFormat: string;
begin
     OldShortDateFormat := ShortDateFormat;
     ShortDateFormat := 'mmyyyy';
     result := datetostr(iDate);
     ShortDateFormat := oldShortDateFormat;
end;

function DateToFileNameU(iDate: TDateTime; per: integer): String;
var
   OldShortDateFormat: string;
begin
     OldShortDateFormat := ShortDateFormat;
     iDate:=incSecond(iDate,-10);
     if (per>=7) then
     begin
     //ShortDateFormat := '';
     result := '_arch';
     exit;
     end;
     if (per=6) then
     begin
     ShortDateFormat := 'yyyy';
     result := '_arch'+datetostr(iDate);
     ShortDateFormat := oldShortDateFormat;
     exit;
     end;
     // 4 - �������;
     ShortDateFormat:= 'mmyyyy';
     result := '_arch'+datetostr(iDate);
     ShortDateFormat := oldShortDateFormat;
end;


function CreateTrTable(iFileName: String; igroupName: String; con: taDOcONNECTION; query: TADOQuery): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := igroupName;

  with query do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ con.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=query.FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ con.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;

      // ������� ������� � ������

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn + ''+
                                      ' (cod INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm)) ON '+fnG
                                      );
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD) ON '+fnG);
      ExecSQL;


      Sql.Clear;
      Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD) WITH DROP_EXISTING ON '+fnG);
      ExecSQL;
      end;
end;

function CreateStTable(iFileName: String; igroupName: String; con: taDOcONNECTION; query: TADOQuery): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := igroupName;

  with query do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ con.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=query.FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ con.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;

      // ������� ������� � ������

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn +
                                      ' (stoptime DATETIME, starttime DATETIME, isR Integer,'+
                                      'PRIMARY KEY (starttime)) ON '+fnG
                                      );
      ExecSQL;
      
      end;
end;

function CreateOscTable(iFileName: String; igroupName: String; con: taDOcONNECTION; query: TADOQuery): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := igroupName;

  with query do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ con.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=query.FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ con.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;

      // ������� ������� � ������

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn +
                                      ' (tm DATETIME, iName CHAR(50),iComment CHAR(250), idelt INT) ON '+fnG
                                      );
      ExecSQL;

      end;
end;


function CreateUchTable(iFileName: String; igroupName: String; con: taDOcONNECTION; query: TADOQuery): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := igroupName;

  with query do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ con.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=query.FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ con.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;

      // ������� ������� � ������

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn +
                                      ' (cod INTEGER, nm CHAR(50), period INTEGER, tm DATETIME, val FLOAT,' +
                                      'PRIMARY KEY(cod, tm)) ON '+fnG
                                      );
      ExecSQL;
      Sql.Clear;
      Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD) ON '+fnG);
     ExecSQL;


      Sql.Clear;
      Sql.Add ('CREATE INDEX COD ON ' + fn + ' (COD) WITH DROP_EXISTING ON '+fnG);
      ExecSQL;
      end;
end;

function CreateAlTable(iFileName: String; igroupName: String; con: taDOcONNECTION; query: TADOQuery): boolean;
 var fn, fnG, filepath, s : string;
begin
  fn := iFileName;
  fnG := igroupName;

  with query do
   begin


  // �������� ������


     s := 'ALTER DATABASE  '+ con.DefaultDatabase +'  ADD FILEGROUP '+fnG;
     SQL.Clear;
     SQL.Add(s);
      try
       ExecSQL;
      except
      end;

  // ����� ����

     s := 'select top 1 * from sysfiles';
     SQL.Clear;
     SQL.Add(s);
      try
       Open;
       filepath:=query.FieldValues['filename'];
      except
      end;

     filepath:=ExtractFilePath(trim(filepath));

   // �������� ����� � ������

     s := 'ALTER DATABASE  '+ con.DefaultDatabase +
     ' ADD FILE (NAME =' +fnG+', FILENAME = '''+filepath+fnG+'.ndf'''+')'+
    'TO FILEGROUP ' +fnG;
     SQL.Clear;
     SQL.Add(s);
      try
      ExecSQL;
      except
      end;

      // ������� ������� � ������

      Sql.Clear;
      Sql.Add ('CREATE TABLE ' + fn +
                                      ' (tm DateTime, iName CHAR(50), iPARAM CHAR(50),' +
                                     'iLevel integer, icomment CHAR(250), iState CHAR(50),' +
                                      'iOperator CHAR(50), iSELECTED INTEGER) ON '+fnG
                                      );
      ExecSQL;

      end;
end;




function TableExist(iFileName: String; ADCON: taDOcONNECTION): boolean;
var
   TableList: TStringList;
   i : integer;
begin
    // ShowMessage('eeee');
     result := False;
     TableList := TStringlist.Create;
     try
    //  ShowMessage('eeee');
     AdCon.GetTableNames(TableList, false);
    //  ShowMessage('tttt');
     for i := 0 to TableList.count - 1 do
         if Uppercase(TableList[i]) = uppercase(iFileName) then begin
            tableExist := true;
            break;
         end;
     finally
         TableList.Free;
     end;
end;   }

var
  compName: PChar;

procedure SetAccessL(value: integer);
var HTM: HWND;
begin
begin
 //AccessLevel^:=9999;
// exit;
end;
if @SwitchProc=nil then exit;
HTM := FindWindow('Shell_TrayWnd','');
if AccessLevel=nil then new(AccessLevel);
AccessLevel^:=value;

if value<2000 then
   begin
   SwitchProc(true);
   SwitchTaskMgr(1);
   ShowWindow(HTM, sw_hide);
   end
   else
   begin
   SwitchProc(false);
   SwitchTaskMgr(0);
   ShowWindow(HTM, sw_SHOWNORMAL);
   end;

end;

procedure RegisterAccessDLL;
var
reg:Tregistry;
  Hdll : HWND; { ���������� ����������� DLL (��� ������������ ���������)}
begin


  @SwitchProc:= nil; // �������������� ���������� hook

{ ********* ������������ �������� **************}

  Hdll:= LoadLibrary(PChar('keylock.dll')); { �������� DLL }
  if Hdll > HINSTANCE_ERROR then            { ���� �� ��� ������, �� }
    begin
     @SwitchProc:=GetProcAddress(Hdll, 'Hook');     { �������� ��������� �� ����������� ���������}
    end;
 if @SwitchProc<>nil then
   begin
     reg:=Tregistry.create;
     reg.rootkey:=HKEY_CLASSES_ROOT;
{������ ������� ���� ������� ������������� ��� ����� ����������. ������������� ������ - ��� ���������� ���������� �������������, ��������� �� ���������������� ����. � ���� ������ ����� ������� �������� � ����� ����� �������� ����������, �������� ������ MAC, ��� ��������� ����� ����� ��� ���������� ���� � ����� ���������� 8) �������� ���� ������������� ����� ����� ������: 1) � Delphi, � ����� ����� ��������� ���� ������ Ctrl-Shift-G. 2) ��� ��������������� API �������� CoCreateGUID();}
try
 reg.openkey ('CLSID\{52D93922-06D0-4A01-889F-227A55BCADED}//\InProcServer32', true);
 reg.writestring('','keylock.dll');
 reg.closekey;
 reg.rootkey:=HKEY_LOCAL_MACHINE;
 reg.openkey('Software\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad', true);
 reg.writestring('MyDllLoade','{52D93922-06D0-4A01-889F-227A55BCADED}//'); reg.closekey;
finally
 reg.free;
end; {try}
end;
end;

procedure UnRegisterAccessDLL;
var
reg:Tregistry;
begin

if @SwitchProc<>nil then
begin
reg:=Tregistry.create;
reg.rootkey:=HKEY_CLASSES_ROOT;
{������ ������� ���� ������� ������������� ��� ����� ����������. ������������� ������ - ��� ���������� ���������� �������������, ��������� �� ���������������� ����. � ���� ������ ����� ������� �������� � ����� ����� �������� ����������, �������� ������ MAC, ��� ��������� ����� ����� ��� ���������� ���� � ����� ���������� 8) �������� ���� ������������� ����� ����� ������: 1) � Delphi, � ����� ����� ��������� ���� ������ Ctrl-Shift-G. 2) ��� ��������������� API �������� CoCreateGUID();}
try
 reg.deletekey ('CLSID\{52D93922-06D0-4A01-889F-227A55BCADED}//\InProcServer32');
 reg.rootkey:=HKEY_LOCAL_MACHINE;
 reg.openkey('Software\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad', true);
 reg.deletevalue('MyDllLoade');
 reg.closekey;
finally
 reg.free;
end; {try}
end;
end;

procedure SwitchTaskMgr(val: integer);
var
reg:Tregistry;
begin

reg:=Tregistry.create;
reg.rootkey:=HKEY_CURRENT_USER;
{������ ������� ���� ������� ������������� ��� ����� ����������. ������������� ������ - ��� ���������� ���������� �������������, ��������� �� ���������������� ����. � ���� ������ ����� ������� �������� � ����� ����� �������� ����������, �������� ������ MAC, ��� ��������� ����� ����� ��� ���������� ���� � ����� ���������� 8) �������� ���� ������������� ����� ����� ������: 1) � Delphi, � ����� ����� ��������� ���� ������ Ctrl-Shift-G. 2) ��� ��������������� API �������� CoCreateGUID();}
try
 reg.rootkey:=HKEY_CURRENT_USER;
 reg.openkey('Software\Microsoft\Windows\CurrentVersion\Policies\System', true);
 reg.WriteInteger('DisableTaskMgr', val);
 reg.closekey;
finally
 reg.free;
end; {try}
end;

procedure Immi_BroadCast(ownerM: tcomponent; var Msg: TMessage);
var i: integer;
begin
 if ownerM=nil then exit;
 for i:=0 to ownerM.ComponentCount-1 do
   if ownerM.Components[i]<>nil then ownerM.Components[i].Dispatch(Msg);

end;



initialization
  if AccessLevel=nil then new(AccessLevel);
  if OperatorName=nil then new(OperatorName);
   if CurrantKey=nil then new(CurrantKey);
 
  toolMode := tmRun;
  if screen.Width = 1024 then resolution := r1024;
  ComputerNameLen := SizeOf(ComputerName);
  GetComputerName(ComputerNameArr, ComputerNameLen);
  ComputerName := ComputerNameArr;

finalization
  // if AccessLevel<>nil then dispose(AccessLevel);
//  if OperatorName<>nil then dispose(OperatorName);
//   if CurrantKey<>nil then dispose(CurrantKey);
 //  if isActivate<>nil then dispose(isActivate);
end.

