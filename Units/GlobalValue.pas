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
  dbmanager: integer;  // тип менеджера СУБД   в  DBManagerFactoryU.pas
  connectionstr: string;   //   строка подключения
  JAppl: string;    // приложение журнала
  TAppl: string;    // приложение графиков
  RAppl: string;    // приложение отчетов
  debug_Base: integer;  // вести отладку
  CurApplication_: string;
  
type

  TRefArr = array [0..36, 0..1] of string;

const

  NameCommentArr: TRefArr =
    (('ProjectName', 'Название проекта'),
    ('ProjectComment', 'Описание проекта'),
    ('ProjectLastUpdate','Последнее обновление проекта'),
    ('ProjectVer','Версия проекта'),
    ('PathEthSer','Файл Ethernet сервера'),
    ('PathSer','Файл Com сервера'),
    ('StartAcses','Начальный уровень доступа'),
    ('PathMem','Путь к базе мнемонических имен'),
    ('GlobalPicturePath','Файл общей картинки'),
    ('FormsDir','Путь к базе форм'),
    ('PackageIni','Файл инициализации пакетов'),
    ('CSTrend','Cтрока подключения Trend'),
    ('CSAlarms','Cтрока подключения Alarms'),
    ('datetimeformats','Формат дата.время'),
    ('CSRegistration','Cтрока подключения Registration'),
    ('deltareserver','Время рассогласования запуска Восстановления'),
    ('DogTime','Полное время отклика контроллера'),
    ('asyncBase','Асинхронная работа с базой'),
     ('conttimeoff','Контроль времени обрыва'),
    ('localBase','Использовать локальную базу для аналоговых'),
    ('FirstPicturePath','Файл картинки инициализации'),
    ('DoubleCompTrend','Сетевой путь к папке архива параметров (Другой компьютер)'),
    ('DoubleCompAlarm','Сетевой путь к папке архива алармов (Другой комьютер)'),
    ('SelfCompTrend','Путь к резервной папке архива параметров (Этот компьютер)'),
    ('SelfCompAlarm','Путь к резервной папке архива алармов (Этот компьютер)'),
    ('RestorePath','Путь к программе быстрого восстановления'),
    ('RestorePeriod','Время быстрого восстановления'),
    ('reserver','Сетевое имя второго компьютера'),
    ('deletecircle','Время хранения архивов (мес)'),
    ('usescript','Использовать скрипты'),
    ('providername','Файл библиотеки доступа к данным'),
    ('stationname','Имя рабочей станции'),

      ('dbmanager','Менеджер СУБД'),
    ('connectionstr','Строка подключения к СУБД'),
    ('JAppl','Приложение журнала'),
    ('TAppl','Приложение гфаиков'),
    ('RAppl','Приложение отчетов')
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
