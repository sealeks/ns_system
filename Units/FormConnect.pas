unit FormConnect;
interface
uses
  Windows,Graphics, Messages, SysUtils, Classes,Contnrs, AppEvnts, Controls, ActiveX,ConstDef,DM1U,
  Types, Menus,StrUtils, Dialogs, ExtDlgs, ExtCtrls, Forms,  Clipbrd, StdCtrls, {GlobalVar ,}globalValue,memStructsU;

type
  TIMMISc = class of TComponent;



type
IImmiApplExec = interface
      ['{81C58896-5D9B-4776-AA61-924B6043E5EE}']
     procedure StartExe;
     procedure StopExe;
     function InitMforApplication(classlist: TList; appList: TList): TForm;
     function getcompilePrepare: boolean;
end;


function OpenProject(dir: string): boolean;
procedure ConnectPackage(path: string);
procedure EveryUnit(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
function LowerCaseForPackage(A: String): string;
procedure ConnectPackages(path: string);
procedure StartExeApp;




var
   strs: string;
   //AppScript: TApplicationImmi;
   formList: TList;
   classlist: TList;
    AppScriptPrep: TComponent;
    AppScript: IImmiApplExec;
implementation

uses fTopMenuU;


function OpenProject(dir: string): boolean;

var
  i,j: integer;
  fi: TextFile;
  filn: string;
  formf: string;
  fileNameP: string;
  fs: TFilestream;
  formn: Tform;
  formhide,showAllf,open: bool;
  fsave: TOpenDialog;
  projBitmap: TBitmap;
  bmm: TBitmap;
  r: TMenuItem;
  StringForm: TStringList;
   scriptClass: TClass;
begin
     StringForm:=TStringList.Create;
     filn:=formsDir+'config.cfg';
 try
    StringForm.LoadFromFile(filn);
 except
    MessageBox(0,' Не удалось считать файл проекта config.cfg','Ошибка',MB_OK+MB_TOPMOST+MB_ICONERROR);
    exit;
 end;

  //   CoInitialize(nil);
     ConnectPackages(PackageIni);
     projBitmap:=nil;
     if  fileexists(GlobalPicturePath) then
       begin
         projBitmap:=Tbitmap.Create;
         try
         projBitmap.LoadFromFile(GlobalPicturePath);
         except
         projBitmap.Free;
         projBitmap:=nil;
         end;
       end;

     for i:=0 to StringForm.Count-1 do
   begin
     FileNameP:=formsDir+StringForm.Strings[i]+'.frm';
     if FileExists(fileNameP) then
         begin
            try
              fs:=TFilestream.Create(fileNameP,fmOpenRead);
              formn:=TForm.Create(Application);
              fs.ReadComponent(formn);
              formlist.Add(formn);
               //showmessage(formn.name);
            except
             MessageBox(0,PChar('Файл формы:  ' +fileNameP +' поврежден '+ char(13)+
               'или использует незарегистрированные компоненты'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
            end;
            if assigned(fs) then fs.Free;
          end;
    end;
 if usescript then
 begin
   if FileExists(formsDir+'AppScript.scr') then
 begin


{  try
 // fs:=TFilestream.Create(fileNameP,fmOpenRead);
 AppScript:=TApplicationImmi.Create(Application);
 ReadComponentresfile(formsDir+'AppScript.scr',AppScript);
 AppScript.listApp:=formlist;
 AppScript.classlistApp:=classList;
   except
  end;
 // if assigned(fs) then fs.Free;  }

   scriptClass:=findclass('TApplicationImmi');
 if scriptClass<>nil then
 begin
 AppScriptPrep:= TIMMISc(scriptClass).Create(Application);
 {AppScript:=TapplicationImmi.Create(owners);}
 if AppScriptPrep<>nil then
  begin
   if FileExists(formsDir+'AppScript.scr') then
    try
     ReadComponentresfile(formsDir+'AppScript.scr',AppScriptPrep)
    except
    end;
   AppScript:=(AppScriptPrep as IImmiApplExec);
   if AppScript.getcompilePrepare then
   dm1.appForm:=AppScript.InitMforApplication(classList,formlist)
   else dm1.appForm:=nil;
  end;
 end;
end;
end;
end;

procedure ConnectPackage(path: string);
var flags : integer;
    HPack: HModule;
begin

 Hpack:=LoadPackage(path);
 GetPackageInfo(Hpack, @Hpack, Flags, everyunit);
end;

procedure EveryUnit(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);

var
  tmp: Pboolean;
  namep: string;
  Registerproc : procedure;
  regitem: function(p: Pointer;p1: Pointer;p2: Pointer): pointer;
  regitem1: function(p: Pointer;p1: Pointer;p2: Pointer;p3: Pointer): pointer;
begin

  if nametype <> ntContainsUnit then exit;
  nameP:='@' + LowerCaseForPackage(Name) + '@Register$qqrv';
  @RegisterProc := getprocaddress(Pinteger(param)^, PChar(nameP));
  if @RegisterProc <> nil then
  begin
    try
    RegisterProc();
    except
    end;
  end;



  nameP:='@' + LowerCaseForPackage(Name) + '@Regrtitems$qqrpvt1t1t1';
  @regitem1 := getprocaddress(Pinteger(param)^, PChar(nameP));
  if @regitem1 <> nil then
  begin
   new(tmp);
   tmp^:=true;
   regitem1(rtitems,nil,nil, tmp);
  end;


  nameP:='@' + LowerCaseForPackage(Name) + '@SetAcsessAdress$qqrpvt1t1';
  @regitem := getprocaddress(Pinteger(param)^, PChar(nameP));
  if @regitem <> nil then
  begin
   regitem(AccessLevel,OperatorName,CurrantKey);
  end;

end;



procedure BwRegisterComponents(const Page: string;
  const ComponentClasses: array of TComponentClass);
var i : integer;

begin
  for i := low(ComponentClasses) to High(ComponentClasses) do
  begin
    RegisterClass(TPersistentClass(ComponentClasses[i]));
    classlist.Add(ComponentClasses[i]);
  end;
end;


function LowerCaseForPackage(A: String): string;
    var
     b: string;
begin
   if Length(A)<1 then exit;
  result:=LowerCase(A);
  b:=UpperCase(Copy(result,1,1));
  delete(result,1,1);
  result:=b+result;
end;


procedure ConnectPackages(path: string);
var i: integer;
    strl: TStringList;
    libstr: string;
begin
//strl:=TStringList.Create;
libstr:='NS_Component.bpl';
if fileexists(libstr) then
ConnectPackage(libstr) else
MessageBox(0,PChar('Файл библиотекки: '+libstr),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
exit;
if fileexists(path) then
strl.LoadFromFile(path);
for i:=0 to strl.Count-1 do
  if fileexists(strl.Strings[i]) then ConnectPackage(strl.Strings[i])
    else  MessageBox(0,PChar('Файл библиотекки:  ' +strl.Strings[i] +
               'не найден'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
end;


procedure StartExeApp;
begin
if not usescript then exit;
 try
  AppScript.StartExe;
except

end;
end;

initialization
   begin
   RegisterComponentsProc := BwRegisterComponents;
   registerclasses([TBevel,TPanel, TShape]);
   formList:=TList.Create;
   classList:=TList.Create;
   classList.clear;
   formlist.Clear;
   end;
finalization
    begin
    formList.Free;
    classList.free;
    end;

end.
