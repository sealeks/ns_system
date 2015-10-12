unit ProjectpropItWrapU;

interface

uses
  Classes, ItemAdapterU, MemStructsU, ConfigurationSys, Windows,
  GlobalValue, SysUtils,Grids,GroupsU,ValEdit, DBManagerFactoryU,DBConnetCofig,ConstDef;

type
  TProjectpropItWrap = class(TItemWraper)
    protected
     path: string;

     function GetLocate_(): String;

     function GetName_(): String;
     procedure SetName_(value: String);
     function GetComment_(): String;
     procedure SetComment_(value: String);
     function GetImgFile_(): String;
     procedure SetImgFile_(value: String);
     function GetAccessL_(): String;
     procedure SetAccessL_(value: String);
     function GetArchDel_(): String;
     procedure SetArchDel_(value: String);
     function GetVer_(): String;
     procedure SetVer_(value: String);
     function GetIndicateLost_(): String;
     procedure SetIndicateLost_(value: String);
     function GetLocalBase_(): String;
     procedure SetLocalBase_(value: String);
     function GetScripUse_(): String;
     procedure SetScripUse_(value: String);
     function GetDBMenager_(): String;
     procedure SetDBMenager_(value: String);
     function GetConnStr_(): String;
     procedure SetConnStr_(value: String);
     function GetJAppl_(): String;
     procedure SetJAppl_(value: String);
     function GetTAppl_(): String;
     procedure SetTAppl_(value: String);
     function GetRAppl_(): String;
     procedure SetRAppl_(value: String);
     function GetDebugLevel_(): String;
     procedure SetDebugLevel_(value: String);
     function WriteIni(): boolean;
     function ReadIni(): boolean;
    public
    procedure setDBProp(Sender: TObject);
    procedure writetofile(); override;
    procedure setMap(); override;
    function setchange(key: integer; val: string): string; override;
    constructor create(path_: string;le: TValueListEditor);
    destructor destroy;
    procedure setType(); override;

    procedure setVal(key: String; value: String); override;
    procedure setList(value: TList); override;
    property Locate_: String read GetLocate_ ;
    property Name_: String read GetName_ write SetName_;
    property Comment_: String read GetComment_ write SetComment_;
    property ImgFile_: String read getImgFile_ write SetImgFile_;
    property AccessL_: String read GetAccessL_ write SetAccessL_;
    property ArchDel_: String read GetArchDel_ write SetArchDel_;
    property Ver_: String read GetVer_ write SetVer_;
    property IndicateLost_: String read GetIndicateLost_ write SetIndicateLost_;
    property LocalBase_: String read GetLocalBase_ write SetLocalBase_;
    property ScriptUse_: String read GetScripUse_ write SetScripUse_;
    property DBMenager_: String read GetDBMenager_ write SetDBMenager_;
    property ConnStr_: String read GetConnStr_ write SetConnStr_;
    property JAppl_: String read GetJAppl_ write SetJAppl_;
    property TAppl_: String read GetTAppl_ write SetTAppl_;
    property RAppl_: String read GetRAppl_ write SetRAppl_;
    property DebugLevel_: String read GetDebugLevel_ write SetDebugLevel_;

   // property Asyn_: String read GetScriptUse_ write SetScriptUse_;
end;


function getTypDB(): TStringList;
function DBTyptoInt(val: string): integer;
function InttoTypDB(val: integer): string;

function InttoTypDebug(val: integer): string;
function DebugTyptoInt(val: string): integer;
function getTypDebug(): TStringList;

implementation



function getTypDB(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('PostgresSQL');
 result.Add('MSSQLServer');
 result.Add('BDE');
 result.Add('ORACLE');
// result.Add('InterBase');
 result.Add('MySQL');
 result.Add('отсутствует');


end;

function DBTyptoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='POSTGRESSQL') then result:=POSTGRES_MANAGER else
   if (val='MSSQLSERVER')then result:=MSSQL_MANAGER else
     if (val='ORACLE')then result:=ORACLE_MANAGER else
//        if (val='INTERBASE')then result:=INTERBASE_MANAGER else
           if (val='MYSQL')then result:=MYSQL_MANAGER else
             if (val='BDE')then result:=BDE_MANAGER else
        result:=0;
end;

function InttoTypDB(val: integer): string;
begin
 case val of
 POSTGRES_MANAGER : result:='PostgresSQL';
 MSSQL_MANAGER: result:='MSSQLServer';
 ORACLE_MANAGER: result:='Oracle';
// INTERBASE_MANAGER: result:='InterBase';
 MYSQL_MANAGER:   result:='MySQL';
 BDE_MANAGER:  result:='BDE';
 else result:='отсутствует';

 end;
end;

function getTypDebug(): TStringList;
begin
 result:=TStringList.Create;
 result.Add('высокий');
 result.Add('средний');
 result.Add('низкий');
 result.Add('отсутствует');


end;

function DebugTyptoInt(val: string): integer;
begin
 val:=trim(ansiuppercase(val));
 if (val='ВЫСОКИЙ') then result:=DEBUGLEVEL_HIGH else
   if (val='СРЕДНИЙ')then result:=DEBUGLEVEL_MIDLE else
      if (val='НИЗКИЙ')then result:=DEBUGLEVEL_LOW else
        result:=0;
end;

function InttoTypDebug(val: integer): string;
begin
 case val of
 DEBUGLEVEL_HIGH : result:='высокий';
 DEBUGLEVEL_MIDLE: result:='средний';
 DEBUGLEVEL_LOW:  result:='низкий';
 else result:='отсутствует';

 end;
end;

procedure TProjectpropItWrap.setMap();
begin
         editor.Strings.Clear;
         setPropertys('Каталог',Locate_,true);
         setPropertys('Название',Name_);
         setPropertys('Коментарий',Comment_);
         setPropertys('Картинка запуска',ImgFile_);
         setPropertys('Начальный уровень доступа',AccessL_);
         setPropertys('Менеджер СУБД',DBMenager_,getTypDB);
         setPropertys('Строка подключения СУБД',ConnStr_,self.setDBProp);
        // setPropertys('Отображать разрывы',IndicateLost_,getBooleanList());
         setPropertys('Кешировать аналоговые',LocalBase_,getBooleanList());
         setPropertys('Хранить архивы(мес)',ArchDel_);
         setPropertys('Уровень отладки',DebugLevel_,getTypDebug);
         setNew();
end;


function TProjectpropItWrap.setchange(key: integer; val: string): string;
begin
   result:='';

   case key of
   0: val:=val;
   1: Name_:=val;
   2: Comment_:=val;
   3: ImgFile_:=val;
   4: AccessL_:=val;
   5: DBMenager_:=val;
   6: ConnStr_:=val;
  // 7: IndicateLost_:=val;
   7: LocalBase_:=val;
   8: ArchDel_:=val;
   9: DebugLevel_:=val;
   end;


end;

procedure TProjectpropItWrap.setDBProp(Sender: TObject);
var Ty,cs: string;
begin
    Ty:=InttoTypDB(dbmanager);
    if (Ty='отсутствует') then
     begin
      MessageBox(0,PChar('Менеджер СУБД должен быть определен!!!'),'Сообщение',
                 MB_OK+MB_TOPMOST+MB_ICONWARNING);
                  exit;
     end;

    if Ty<>'отсутствует' then
     begin
       try
        with TFormDBConfig.create(nil) do
          begin
             try
             cs:=self.ConnStr_;
             caption:='Подключение '+Ty;
             if Exec(dbmanager,cs) then
               begin

                editor.Values['Строка подключения СУБД']:=cs;
                ValueListEditorEdit(nil,1,6,cs);
                editor.Update;
               end;
             finally
              free;
            end;
          end;
       except

       end;
     end;
end;

procedure TProjectpropItWrap.SetType;
var i: integer;
begin
//
end;

procedure TProjectpropItWrap.writetofile();
begin

end;



constructor TProjectpropItWrap.create(path_: string;le: TValueListEditor);
begin
  inherited create(le);
  path:=path_;
end;

destructor TProjectpropItWrap.destroy;
begin

end;

procedure TProjectpropItWrap.setList(value: TList);
var i: integer;

begin
   SetLength(ids,value.Count);
   ids[0]:=0;
   path:=Pstring(value.Items[0])^;
   idscount:=value.Count;
   dispose(value.Items[0]);
end;




procedure TProjectpropItWrap.setVal(key: String; value: String);
begin

end;

function TProjectpropItWrap.WriteIni(): boolean;
begin
    WriteSysByName(path);
end;

function TProjectpropItWrap.ReadIni(): boolean;
begin
     InitialSysByName(path);
end;

function TProjectpropItWrap.GetLocate_(): String;

begin
     result:=path;
     //ReadIni();
end;

function TProjectpropItWrap.GetName_(): String;

begin
     result:=ProjectName;
     ReadIni();
end;

procedure TProjectpropItWrap.SetName_( value: String);

begin
   ProjectName:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetComment_(): String;

begin
     result:=ProjectComment;
     ReadIni();
end;

procedure TProjectpropItWrap.SetComment_( value: String);

begin
   ProjectComment:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetImgFile_(): String;

begin
     result:=firstPicturePath;
     ReadIni();
end;

procedure TProjectpropItWrap.SetImgFile_( value: String);

begin
   firstPicturePath:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetAccessL_(): String;

begin
     result:=inttostr(StartAcses);
     ReadIni();
end;

procedure TProjectpropItWrap.SetAccessL_( value: String);

begin
   StartAcses:=strtointdef(value,StartAcses);
   WriteIni();
end;

function TProjectpropItWrap.GetArchDel_(): String;

begin
     result:=inttostr(deletecircle);
     ReadIni();
end;

procedure TProjectpropItWrap.SetArchDel_( value: String);

begin
   deletecircle:=strtointdef(value,deletecircle);
   WriteIni();
end;

function TProjectpropItWrap.GetVer_(): String;

begin
     result:=floattostr(ProjectVer);
     ReadIni();
end;

procedure TProjectpropItWrap.SetVer_( value: String);

begin
   try
   ProjectVer:=strtofloat(value);
   except
   end;
   WriteIni();
end;

function TProjectpropItWrap.GetIndicateLost_(): String;

begin
     result:=getbooleanstr(true);
     ReadIni();
end;

procedure TProjectpropItWrap.SetIndicateLost_( value: String);

begin

   getstrboolean(value);

   WriteIni();
end;

function TProjectpropItWrap.GetLocalBase_(): String;

begin
     result:=getbooleanstr(localBase);
     ReadIni();
end;

procedure TProjectpropItWrap.SetLocalBase_( value: String);

begin

   localBase:=getstrboolean(value);

   WriteIni();
end;

function TProjectpropItWrap.GetScripUse_(): String;
begin
     result:=getbooleanstr(UseScript);
     ReadIni();
end;

procedure TProjectpropItWrap.SetScripUse_( value: String);
begin
   UseScript:=getstrboolean(value);
   WriteIni();
end;

function TProjectpropItWrap.GetDBMenager_(): String;
begin
     result:=InttoTypDB(dbmanager);
     ReadIni();
end;

procedure TProjectpropItWrap.SetDBMenager_( value: String);
begin
   if (dbmanager<>DBTyptoInt(value)) then
     begin
         SetConnStr_('');
         editor.Values['Строка подключения СУБД']:='';
     end;
   dbmanager:=DBTyptoInt(value);
   WriteIni();
end;

function TProjectpropItWrap.GetConnStr_(): String;

begin
     result:=connectionstr;
     ReadIni();
end;

procedure TProjectpropItWrap.SetConnStr_( value: String);

begin
   connectionstr:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetJAppl_(): String;

begin
     result:=JAppl;
     ReadIni();
end;

procedure TProjectpropItWrap.SetJAppl_( value: String);

begin
   JAppl:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetTAppl_(): String;

begin
     result:=TAppl;
     ReadIni();
end;

procedure TProjectpropItWrap.SetTAppl_( value: String);

begin
   TAppl:=value;
   WriteIni();
end;

function TProjectpropItWrap.GetRAppl_(): String;

begin
     result:=RAppl;
     ReadIni();
end;

procedure TProjectpropItWrap.SetRAppl_( value: String);

begin
   RAppl:=value;
   WriteIni();
end;


function TProjectpropItWrap.GetDebugLevel_(): String;
begin
     result:=InttoTypDebug(debug_Base);
     ReadIni();
end;

procedure TProjectpropItWrap.SetDebugLevel_( value: String);
begin
   debug_Base:=DebugTyptoInt(value);
   WriteIni();
end;

end.
