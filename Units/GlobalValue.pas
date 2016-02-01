unit GlobalValue;


interface

uses graphics, SysUtils, Forms;

Var
  ProjectName, ProjectComment: string;
  ProjectLastUpdate: TDateTime;
  ProjectVer: real;
  PathMem: string;
 
  StartAcses: integer;
  GlobalPicturePath: string;
  FormsDir:   string;
  providername: string;
  PackageIni: string;
  firstPicturePath: string;
  SaveAnIn: string;
  asyncBase: boolean;
  localBase: boolean;

  ExeDir: string;
  StartTime: TDateTime;
  DogTime: integer = 5;
//  conttimeoff: boolean;
  deltareserver: integer = 30;



  deletecircle: integer = 0;

  FirstPicture: Tpicture;


  reserver: string;
  staR: boolean;
  looR: boolean = true;
  CurrentLogin: string;

  MaxSlaveNum: integer;
  UseScript: boolean;
  stationname: string;
  username: string;
  dbmanager: integer;  // ��� ��������� ����   �  DBManagerFactoryU.pas
  connectionstr: string;   //   ������ �����������
  JAppl: string;    // ���������� �������
  TAppl: string;    // ���������� ��������
  RAppl: string;    // ���������� �������
  debug_Base: integer;  // ����� �������
  CurApplication_: string;
  
type

  TRefArr = array [0..36, 0..1] of string;

const

  NameCommentArr: TRefArr =
    (('ProjectName', '�������� �������'),
    ('ProjectComment', '�������� �������'),
    ('ProjectLastUpdate','��������� ���������� �������'),
    ('ProjectVer','������ �������'),
    ('PathEthSer','���� Ethernet �������'),
    ('PathSer','���� Com �������'),
    ('StartAcses','��������� ������� �������'),
    ('PathMem','���� � ���� ������������� ����'),
    ('GlobalPicturePath','���� ����� ��������'),
    ('FormsDir','���� � ���� ����'),
    ('PackageIni','���� ������������� �������'),
    ('CSTrend','C����� ����������� Trend'),
    ('CSAlarms','C����� ����������� Alarms'),
    ('datetimeformats','������ ����.�����'),
    ('CSRegistration','C����� ����������� Registration'),
    ('deltareserver','����� ��������������� ������� ��������������'),
    ('DogTime','������ ����� ������� �����������'),
    ('asyncBase','����������� ������ � �����'),
     ('conttimeoff','�������� ������� ������'),
    ('localBase','������������ ��������� ���� ��� ����������'),
    ('FirstPicturePath','���� �������� �������������'),
    ('DoubleCompTrend','������� ���� � ����� ������ ���������� (������ ���������)'),
    ('DoubleCompAlarm','������� ���� � ����� ������ ������� (������ ��������)'),
    ('SelfCompTrend','���� � ��������� ����� ������ ���������� (���� ���������)'),
    ('SelfCompAlarm','���� � ��������� ����� ������ ������� (���� ���������)'),
    ('RestorePath','���� � ��������� �������� ��������������'),
    ('RestorePeriod','����� �������� ��������������'),
    ('reserver','������� ��� ������� ����������'),
    ('deletecircle','����� �������� ������� (���)'),
    ('usescript','������������ �������'),
    ('providername','���� ���������� ������� � ������'),
    ('stationname','��� ������� �������'),

      ('dbmanager','�������� ����'),
    ('connectionstr','������ ����������� � ����'),
    ('JAppl','���������� �������'),
    ('TAppl','���������� �������'),
    ('RAppl','���������� �������')
    );

function GetGCom(GlobalVar: String): string;
procedure LogDebug(FileNM: string; msg: string);

implementation

function GetGCom(GlobalVar: String): string;
var
  i: integer;
  str: string;
begin
  result := '';
  str := AnsiUpperCase(GlobalVar);
  for i := Low(NameCommentArr) to high(NameCommentArr) do
    if str = AnsiUpperCase(NameCommentArr[i, 0]) then
    begin
      result := NameCommentArr[i, 1];
      exit;
    end;
end;

procedure LogDebug(FileNM: string; msg: string);
var
  Filename: string;
  LogFile: TextFile;
begin
  exit;
  // prepares log file
  Filename := FileNM + '.log';
  AssignFile (LogFile, Filename);
  if FileExists (FileName) then
    Append (LogFile) // open existing file
  else
    Rewrite (LogFile); // create a new one
  try
    // write to the file and show error
    Writeln (LogFile, DateTimeToStr (Now) + ':' + msg);
  finally
    // close the file
    CloseFile (LogFile);
  end;
end;

initialization
 FirstPicture:=Tpicture.Create;
 try
 CurApplication_:=Application.Title;
 except
 CurApplication_:='nodef';
 end
finalization
 FirstPicture.Free;

end.
