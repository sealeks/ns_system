unit ConfigurationSys;

interface

uses
StrUtils,Windows,SysUtils, GlobalValue,Classes,ImmiSys,
Controls, Registry, Dialogs, Forms, iniFiles,memStructsU, ShellAPI, OldProjectFormU;

const
  CONFFILE_V1=1;
  CONFFILE_V2=2;
  CONFFILE_NE=3;

type TBuffer_ = array of Char;

type  TConfFile = (csDbdata,csForms,csIni, csCfgpr);
      TConfSet= set of TConfFile;  //
var
   serverEth: THandle;
   serverCom: THandle;

function  MainKeyExists(): boolean;
function  CreateMainKey(): boolean;
function  CheckAndCreateMainKey(_create: boolean =true): boolean;

procedure AddAppList(key, val: string );
procedure DeleteAppList(Key: string);
procedure DeleteNoExists();
function  getAppList(): TStrings;
function  GetCurrentApp: string;
procedure SetCurrentApp(curApp: string);
function  CheckVer(key: string): integer;
function  CheckCurVer(): integer;
function  getDirType(path: string): TConfSet;



function  InitialSys(): integer;
procedure InitialSysByName(configName: string);
procedure InitialSysByNameOld(configName: string);
procedure WriteSysByName(configName: string; recreate: boolean =false);
procedure WriteSys();

function ChooseDirectory(var dir: string; crtdir: boolean = false): boolean;
function UpdateVerByIni(fn: string): string;
function UpdateVerBy2Dir(dbdata_dir,form_dir: string): string;


function ReplaceFilesImmi( Source: string;
  Dest : string;  ex: string  ) : Integer;

function IniExists(path: string): boolean;
function Checknewdir(path: string): boolean;
function NewProjectCreate(): string;
function OpenProject(): string;
function OpenOldProject(): string;
function GetCurrentAppOld: string;



implementation


// создает ключи софта
function CreateMainKey(): boolean;
begin
  if not MainKeyExists() then
    begin
       with TRegistry.Create do
        try
         RootKey := HKEY_LOCAL_MACHINE;
         try
         CreateKey('SOFTWARE\IMMI');
         except
         end;
         try
         CreateKey('SOFTWARE\IMMI\APP LIST2');
          if (GetCurrentAppOld<>'') then
         SetCurrentApp(GetCurrentAppOld);
         except
         end;

       finally
         Free;
       end;
    end;

end;


// существуют ли ключи софта
function  MainKeyExists(): boolean;
  var reg: TRegistry;
begin
  with TRegistry.Create do
  try

    RootKey := HKEY_LOCAL_MACHINE;
    result:=(KeyExists('SOFTWARE\IMMI') and KeyExists('SOFTWARE\IMMI\APP LIST2'))
  finally
    Free;
  end;

end;

// проверяет и создает ключи софта
function  CheckAndCreateMainKey(_create: boolean =true): boolean;
begin
    result:=MainKeyExists;
    if (not result) and (_create) then
      begin
         CreateMainKey();
      end;
end;



// добавляет проект в реестр

procedure AddAppList(key, val: string );
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('SOFTWARE\IMMI\APP LIST2', True);
    WriteString(Key, Val);
  finally
    Free;
  end;
end;



// удаляет проект с реестра проект в реестр

procedure DeleteAppList(Key: string);
begin
  with TRegistry.Create do
  try
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('SOFTWARE\IMMI', True);
    OpenKey('APP LIST2', True);
    DeleteValue(key);
  finally
    Free;
  end;
end;

// возвращает текущий проект

function GetCurrentApp: string;
var
  curApp, curAppDir: string;
  Registry :TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    result := Registry.ReadString('CURRENT APP2');
  finally
    Registry.Free;
  end;
end;


function GetCurrentAppOld: string;
var
  curApp, curAppDir: string;
  Registry :TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    result := Registry.ReadString('CURRENT APP');
  finally
    Registry.Free;
  end;
end;

// устанавливает текущий проект

procedure SetCurrentApp(curApp: string);
var
  Registry :TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    Registry.WriteString('CURRENT APP2', curApp);
  finally
    Registry.Free;
  end;
end;

// удаляет проекты из реестра  ссыки на которые не действительны

procedure DeleteNoExists();
var SL: TStringList;
    Registry: TRegistry;
    i,j: integer;
    path_: PString;
    temp: string;
    flagdub: boolean;
begin
  Registry := TRegistry.Create;
  try
    SL:=TStringList.Create;
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    Registry.OpenKey('APP LIST2', True);
    SL.Clear;
    Registry.GetValueNames(SL);

    for i:=0 to SL.Count-1 do
      begin
        temp:=trim(uppercase(SL.Strings[i]));
          try
            if not ((FileExists(trim(SL.Strings[i]))) or (FileExists(trim(SL.Strings[i])+'initial.ini'))) then
               Registry.DeleteValue(SL.Strings[i]);

           except
            temp:=trim(uppercase(SL.Strings[i]));
       end;
      end;
  finally
    SL.Free;
    Registry.Free;
  end;

end;

// возвращает список проектов в реестре

function getAppList(): TStrings;
var SL: TStringList;
    Registry: TRegistry;
    i,j: integer;
    path_: PString;
    temp: string;
begin
Registry := TRegistry.Create;
  try
    DeleteNoExists();
    SL:=TStringList.Create;
    result:=TStringList.Create;
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('SOFTWARE\IMMI', True);
    Registry.OpenKey('APP LIST2', True);
    Registry.GetValueNames(SL);
    for i:=0 to SL.Count-1 do
      begin
         if (trim(sl.Strings[i])<>'') then
         result.Add(sl.Strings[i]);
      end;

  finally
    SL.Free;
    Registry.Free;
  end;
end;

// проверка версии

function CheckVer(key: string): integer;
 var dirTyp: TConfSet;
begin
 dirTyp:=getDirType(key);

 result:=CONFFILE_NE;

 if ((csIni in dirTyp) and (csDbdata in dirTyp)
       and (csForms in dirTyp))   then
   begin
     result:=CONFFILE_V2;
     exit;
   end;

 if FileExists(key) then
   begin
     if ((trim(key)<>'') and ((pos('.INI',Uppercase(key))>0)
        or (pos('.CFGPR',Uppercase(key))>0))) then
     result:=CONFFILE_V1;
     exit;
   end;

end;

function CheckCurVer(): integer;
begin
   result:=CheckVer(GetCurrentApp);
end;

//  содержит директория конфиг файлы   TConfSet

function getDirType(path: string): TConfSet;
var analog_file, string_file, groups_file,
    config_form, ini_file, cfgpr_file: boolean;
begin
  result:=[];
  analog_file:=FileExists(path+'analog.mem');
  string_file:=FileExists(path+'strings.mem');
  groups_file:= FileExists(path+'groups.cfg');
  config_form:=FileExists(path+'config.cfg');
  ini_file:=FileExists(path+'initial.ini');
  cfgpr_file:=FileExists(path+'initial.cfgpr');
  if (analog_file and string_file and groups_file) then
      result:=result+[csDbdata];
  if (config_form) then
      result:=result+[csForms];
  if (ini_file) then
    result:=result+[csIni];
   if (ini_file) then
    result:=result+[csCfgpr];
end;

// загрузка глобальных переменных из файла для текущих

function InitialSys(): integer;
begin
  CreateMainKey();
  case CheckVer(GetCurrentApp) of
     CONFFILE_V2:
        begin
          InitialSysByName(GetCurrentApp);
          PathMem:=GetCurrentApp;
          FormsDir:=GetCurrentApp;
          exit;
        end;
     CONFFILE_V1:
        begin
          InitialSysByNameOld(GetCurrentApp);
          exit;
        end;
  //   CONFFILE_NE:
   //      CreateRegisry()     создать ключ
      end;

end;


// загрузка глобальных переменных из файла

procedure InitialSysByName(configName: string);
var
  ini: TIniFile;
begin
       try
         ini := TIniFile.Create(ConfigName+'initial.ini');
         projectName := ini.readString('SETTINGS', 'projectName', 'NoName');
         ProjectComment := ini.readString('SETTINGS', 'ProjectComment', '');
         ProjectLastUpdate := ini.readDateTime('SETTINGS', 'ProjectLastUpdate', Now());
         ProjectVer := ini.readFloat('SETTINGS', 'ProjectVer', 0);
         StartAcses := ini.readInteger('SETTINGS', 'StartAccess', 1500);
         GlobalPicturePath := ini.readString('SETTINGS', 'GlobalPicturePath', '');
         FirstPicturePath := ini.readString('SETTINGS', 'FirstPicturePath', '');
         deletecircle := ini.readInteger('SETTINGS', 'deletecircle', 0);
         asyncBase := ini.ReadBool('SETTINGS', 'asyncBase', FALSE);
//         conttimeoff :=  ini.ReadBool('SETTINGS','conttimeoff', TRUE);
         localBase := ini.ReadBool('SETTINGS', 'localBase', TRUE);
         usescript :=  ini.ReadBool('SETTINGS', 'usescript',FALSE);

         stationname := ini.readString('SETTINGS', 'stationname', '');
         dbmanager:=ini.readInteger('SETTINGS', 'dbmanager',0);
         connectionstr:=ini.readString('SETTINGS', 'connectionstr','');
         JAppl:=ini.readString('SETTINGS', 'JAppl','');
         TAppl:=ini.readString('SETTINGS', 'TAppl','');
         RAppl:=ini.readString('SETTINGS', 'RAppl','');
         debug_Base:= ini.readInteger('SETTINGS', 'debug_Base', 0);
       finally
         ini.free;
       end;
end;


// загрузка глобальных переменных из старых файлов

procedure InitialSysByNameOld(configName: string);
var
  ini: TIniFile;
begin
       try
         ini := TIniFile.Create(ConfigName);
         projectName := ini.readString('SETTINGS', GetGCom('projectName'), 'NoName');
         ProjectComment := ini.readString('SETTINGS', GetGCom('ProjectComment'), '');
         ProjectLastUpdate := ini.readDateTime('SETTINGS', GetGCom('ProjectLastUpdate'), Now());
         ProjectVer := ini.readFloat('SETTINGS', GetGCom('ProjectVer'), 0);
         StartAcses := ini.readInteger('SETTINGS', GetGCom('StartAcses'), 0);
         PathMem := ini.readString('SETTINGS', GetGCom('PathMem'), '');
         FormsDir := ini.readString('SETTINGS', GetGCom('FormsDir'), '');
         GlobalPicturePath := ini.readString('SETTINGS', GetGCom('GlobalPicturePath'), '');
         FirstPicturePath := ini.readString('SETTINGS', GetGCom('FirstPicturePath'), '');
     //    datetimeformats := ini.readString('SETTINGS', GetGCom('datetimeformats'), '');
         deletecircle := ini.readInteger('SETTINGS', GetGCom('deletecircle'), 0);
         asyncBase := not (uppercase(trim(ini.readString('SETTINGS', GetGCom('asyncBase'), '')))='FALSE');
//         conttimeoff :=  (uppercase(trim(ini.readString('SETTINGS', GetGCom('conttimeoff'), '')))='TRUE');
         localBase := not (uppercase(trim(ini.readString('SETTINGS', GetGCom('localBase'), '')))='FALSE');
         usescript :=  (uppercase(trim(ini.readString('SETTINGS', GetGCom('usescript'), '')))='TRUE');
 //        RestorePath := ini.readString('SETTINGS', GetGCom('RestorePath'), '');
   //      DoubleCompTrend := ini.readString('SETTINGS', GetGCom('DoubleCompTrend'), '');
   //      DoubleCompAlarm := ini.readString('SETTINGS', GetGCom('DoubleCompAlarm'), '');
  //       SelfCompTrend := ini.readString('SETTINGS', GetGCom('SelfCompTrend'), '');
 //        SelfCompAlarm := ini.readString('SETTINGS', GetGCom('SelfCompAlarm'), '');
         PackageIni := ini.readString('SETTINGS', GetGCom('PackageIni'), '');
         deltareserver := ini.readInteger('SETTINGS', GetGCom('deltareserver'), 10);
         DogTime := ini.readInteger('SETTINGS', GetGCom('DogTime'), 3);
         stationname := ini.readString('SETTINGS', GetGCom('stationname'), '');
       //  RestorePeriod := ini.readInteger('SETTINGS', GetGCom('RestorePeriod'), 30);
         reserver := ini.readString('SETTINGS', GetGCom('reserver'), '');
         providername:=ini.ReadString('SETTINGS', GetGCom('providername'),'');

       finally
         ini.free;
       end;
end;

// сохранение глобальных переменных для текущего

procedure WriteSys();
begin
   WriteSysByName(GetCurrentApp);
end;



// сохранение глобальных переменных

procedure WriteSysByName(configName: string; recreate: boolean =false);
var
  ini: TIniFile;
begin
       if recreate then
         begin
            if (FileExists(ConfigName+'initial.ini')) then
              begin
                 DeleteFile(ConfigName+'initial.ini');
                 FileClose(FileCreate(ConfigName+'initial.ini'));
              end;
         end;
       try
         ini := TIniFile.Create(ConfigName+'initial.ini');
         ini.writeString('SETTINGS', 'projectName', projectName);
         ini.writeString('SETTINGS', 'ProjectComment', ProjectComment);
         ini.writeDateTime('SETTINGS', 'ProjectLastUpdate', Now());
         ini.writeFloat('SETTINGS', 'ProjectVer', ProjectVer);
         ini.writeInteger('SETTINGS', 'StartAccess', StartAcses);
         ini.writeString('SETTINGS', 'GlobalPicturePath', GlobalPicturePath);
         ini.writeString('SETTINGS', 'FirstPicturePath', FirstPicturePath);
         ini.writeInteger('SETTINGS', 'deletecircle', deletecircle);
         ini.writeBool('SETTINGS', 'asyncBase', asyncBase);
//         ini.writeBool('SETTINGS', 'conttimeoff', conttimeoff);
         ini.writeBool('SETTINGS', 'localBase', localBase);
         ini.writeBool('SETTINGS', 'usescript', usescript);
         
         ini.writeString('SETTINGS', 'stationname',  stationname);
         ini.writeInteger('SETTINGS', 'dbmanager',dbmanager);
         ini.writeString('SETTINGS', 'connectionstr',connectionstr);
         ini.writeString('SETTINGS', 'JAppl',JAppl);
         ini.writeString('SETTINGS', 'TAppl',TAppl);
         ini.writeString('SETTINGS', 'RAppl',RAppl);
         ini.writeInteger('SETTINGS', 'debug_Base', debug_Base);
       finally
         ini.free;
       end;
end;




// выбор директории   createdir - позволять создать

function ChooseDirectory(var dir: string; crtdir: boolean = false): boolean;
begin

  with TImmiSysForm.Create(nil) do
     begin
       try
       Caption:='Выбор директории проекта';
         if Exec(dir) then
           begin
             result:=false;
               if (not directoryExists(dir)) and (crtdir)  then
               begin
                 if (crtdir) then
                   begin
                     if (MessageBox(0,PChar('Папки    '+dir+ '   не существует!  '+ char(13)+
                      'Создать?'),'Сообщение',
                         MB_OK+MB_OKCANCEL+MB_TOPMOST+MB_ICONWARNING)= IDCANCEL	) then exit;
                       try
                        CreateDir(dir);
                       except
                       on E: Exception do
                         begin
                          Showmessage(E.Message);
                          exit;
                         end;
                        end;
                        result:=true;
                    end else
                    begin
                        MessageBox(0,PChar('Папки  '+dir+ '  не существует!  '
                         ),'Сообщение',
                        MB_OK+MB_TOPMOST+MB_ICONERROR);
                       exit;

                    end;

                 end
                    else result:=true;
               end

         finally
         free;
         end;
       end;
end;

// преобразует старый проект по двум папкам

function UpdateVerBy2Dir(dbdata_dir,form_dir: string): string;
var
    str: string;
begin
  result:='';
  try
   if (not (csDbdata in getDirType(dbdata_dir))) then
     begin
         MessageBox(0,PChar('Папкa  '+dbdata_dir+ '  не содержит необходимых файлов!  '
                    ),'Ошибка',
                     MB_OK+MB_TOPMOST+MB_ICONERROR);
                     exit;
     end;
   if (not (csForms in getDirType(form_dir))) then
     begin
         MessageBox(0,PChar('Папкa  '+form_dir+ '  не содержит необходимых файлов!  '
                    ),'Ошибка',
                     MB_OK+MB_TOPMOST+MB_ICONERROR);
                     exit;
     end;

   if (ChooseDirectory(str,true)) then
     begin
     ReplaceFilesImmi(form_dir,str,'*.frm');
     ReplaceFilesImmi(form_dir,str,'config.cfg');
     ReplaceFilesImmi(dbdata_dir,str,'*.mem');
     ReplaceFilesImmi(dbdata_dir,str,'*.cfg');
     ReplaceFilesImmi(dbdata_dir,str,'*.rcfcom');
     ReplaceFilesImmi(dbdata_dir,str,'*.scrl');
     if FileExists( str+'initial.ini')  then
        DeleteFile(str+'initial.ini');
     FileClose(FileCreate( str+'initial.ini'));
     result:=str;
     end;
   finally

   end;
end;

function UpdateVerByIni(fn: string): string;
var pm_,fd_: string;
    ini : TIniFile ;
begin
   try
   ini := TIniFile.Create(fn);
   pm_ := trim(ini.readString('SETTINGS', GetGCom('PathMem'), ''));
   fd_ := trim(ini.readString('SETTINGS', GetGCom('FormsDir'), ''));
   UpdateVerBy2Dir(pm_,fd_);
   finally
   end;
end;


function IniExists(path: string): boolean;
begin
  result:=FileExists(path+'initial.ini');
end;

function Checknewdir(path: string): boolean;
begin
   result:=not ((getDirType(path)=[]) or (getDirType(path)=[csCfgpr]))
end;

// новый проект

function NewProjectCreate(): string;
  var
    str: string;
begin
      result:='';
      if ChooseDirectory(str,true) then
      begin
      if Checknewdir(str) then
          begin
          if (MessageBox(0,PChar('В папке уже содержится какой то проект!  '+ char(13)+
                 'Перезаписать?'),'Сообщение',
                 MB_OK+MB_OKCANCEL+MB_TOPMOST+MB_ICONWARNING)= IDCANCEL	) then
                 exit;
          end;
      TAnalogMems.WriteZero(str);
      result:=str;
      end;
   //   SetCurrentApp(str);
   //   InitialSys;
end;

function OpenProject(): string;
  var
    str: string;
begin
  if ChooseDirectory(str) then
     if Checknewdir(str) then
                    result:=str;
end;

function OpenOldProject(): string;
  var
    str: string;
    dbdat ,form: string;

begin
   result:='';
   with TOldProjectForm.Create(nil) do
     begin
         if Exec(dbdat,form) then
           begin
             result:=UpdateVerBy2Dir(dbdat,form);
           end;
        free;
     end;
end;





//  перемещает файлы из Source->Dest

function ReplaceFilesImmi( Source: string;
                Dest : string;  ex: string ) : Integer;

   function CopyFilesImmi( Src : array of string;
     Dest : string ) : Integer;

     procedure CreateBuffer( Names : array of string; var P : TBuffer_ );
       var
        I, J, L : Integer;
       begin
         for I := Low( Names ) to High( Names ) do
          begin
           L := Length( P );
           SetLength( P, L + Length( Names[ I ] ) + 1 );
           for J := 0 to Length( Names[ I ] ) - 1 do
           P[ L + J ] := Names[ I, J + 1 ];
           P[ L + J ] := #0;
          end;
         SetLength( P, Length( P ) + 1 );
         P[ Length( P ) ] := #0;
       end;

    var
     SHFileOpStruct : TSHFileOpStruct;
      SrcBuf : TBuffer_;
       begin
        CreateBuffer( Src, SrcBuf );
         with SHFileOpStruct do
          begin
           wFunc := FO_COPY;
           pFrom := Pointer( SrcBuf );
           pTo := PChar( Dest );
           fFlags := 0;
           hNameMappings := nil;
           lpszProgressTitle := nil;
          end;
        Result := SHFileOperation( SHFileOpStruct );
        SrcBuf := nil;
        end;

function getFileList(dir: string; ex: string='*.*'): TStringList;
function getP(fn: string): boolean;
var i: integer;
begin
   result:=false;
   for i:=1 to length(fn) do
    if fn[i]<>'.' then
       begin
         result:=true;
         exit;
       end;
end;
var
  sr: TSearchRec;
  s: string;
begin

  result:=TStringList.Create;
  if FindFirst(dir+'\'+ex, faAnyFile, sr) = 0 then
  begin
  repeat
  if getP(trim(sr.Name)) then result.Add(dir+sr.Name);
  until FindNext(sr) <> 0;
  FindClose(sr);
 end;
end;

 var   SL: TStringList;
       sAr: array of string;
       var i: integer;
begin
   SL:=getFileList(Source,ex);
   setlength(sAr,SL.Count);
   for i:=0 to SL.count-1 do
     sar[i]:=SL.Strings[i];
   CopyFilesImmi( sar,
   Dest  );
  SL.Free;
end;


end.



