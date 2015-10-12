unit MainRunTimeRegistration;

interface
uses ifps3,ifpidelphiruntime,MemStructsU,GlobalValue,Expr,forms,sysutils,windows,MMSystem,Dialogs,classes;

procedure RegisterDelphiMainFunction(val: TIFPSExec);
procedure InitExpr(expr: string);
procedure UnInitExpr(expr: string);
procedure setCommandOn(tag: string);
procedure setCommandOff(tag: string);
procedure setCommandValue(tag: string; value: double);
procedure setValue(tag: string; value: double);
function GetBoolExpr(Expr: string): boolean;
function GetValExpr(Expr: string): double;
procedure OpenForm(form: TForm; left: integer;top: integer);
procedure ShowModalForm(form: TForm; left: integer;top: integer);
procedure SimpleOpenForm(form: TForm; left: integer;top: integer);
procedure HideForm(form: TForm; left: integer;top: integer);
procedure OpenFormByName(caption: string; left: integer;top: integer);
procedure ShowFormModalByName(caption: string; left: integer;top: integer);
procedure SimpleOpenFormByName(caption: string; left: integer;top: integer);
procedure HideFormByName(caption: string; left: integer;top: integer);
function NowI: TDatetime;
function DateI: TDateTime;
function TimeI: TDateTime;
function FormatDateTime(val: TDateTime): string;
procedure ExecWin(programPath: string; programName: string);
procedure beepWin(freq: dword; duration: dword);
procedure PlaySoundWin(name: string; value: boolean);
implementation

procedure RegisterDelphiMainFunction(val: TIFPSExec);
begin
  RegisterDelphiFunctionR(val, @InitExpr, 'INITEXPR' , cdRegister);
  RegisterDelphiFunctionR(val, @UnInitExpr, 'UNINITEXPR' , cdRegister);
  RegisterDelphiFunctionR(val, @setCommandOn, 'SETCOMMANDON' , cdRegister);
  RegisterDelphiFunctionR(val, @setCommandOff, 'SETCOMMANDOFF' , cdRegister);
  RegisterDelphiFunctionR(val, @setCommandValue, 'SETCOMMANDVALUE' , cdRegister);
  RegisterDelphiFunctionR(val, @setValue, 'SETVALUE' , cdRegister);
  RegisterDelphiFunctionR(val, @GetBoolExpr, 'GETBOOLEXPR' , cdRegister);
  RegisterDelphiFunctionR(val, @GetValExpr, 'GETVALEXPR' , cdRegister);
  RegisterDelphiFunctionR(val, @OpenForm, 'OPENFORM' , cdRegister);
  RegisterDelphiFunctionR(val, @SimpleOpenForm, 'SIMPLEOPENFORM' , cdRegister);
  RegisterDelphiFunctionR(val, @ShowModalForm, 'SHOWMODALFORM' , cdRegister);
  RegisterDelphiFunctionR(val, @HideForm, 'HIDEFORM' , cdRegister);
  RegisterDelphiFunctionR(val, @OpenFormByName, 'OPENFORMBYNAME' , cdRegister);
  RegisterDelphiFunctionR(val, @SimpleOpenFormByName, 'SIMPLEOPENFORMBYNAME' , cdRegister);
  RegisterDelphiFunctionR(val, @ShowFormModalByName, 'SHOWMODALFORMBYNAME' , cdRegister);
  RegisterDelphiFunctionR(val, @HideFormByName, 'HIDEFORMBYNAME' , cdRegister);
  RegisterDelphiFunctionR(val, @NowI, 'NOWI' , cdRegister);
  RegisterDelphiFunctionR(val, @DateI, 'DATEI' , cdRegister);
  RegisterDelphiFunctionR(val, @TimeI, 'TIMEI' , cdRegister);
  RegisterDelphiFunctionR(val, @FormatDateTime, 'FORMATDATETIME' , cdRegister);
  RegisterDelphiFunctionR(val, @ExecWin, 'EXECWIN' , cdRegister);
  RegisterDelphiFunctionR(val, @beepWin, 'BEEPWIN' , cdRegister);
  RegisterDelphiFunctionR(val, @PlaySoundWin, 'PLAYSOUNDWIN' , cdRegister);
end;


procedure InitExpr(expr: string);
var Expres: TExpretion;
begin
  Expres := TExpretion.Create;
  Expres.Expr:=expr;
  try
   Expres.ImmiInit;
  except
  end;
end;

procedure UnInitExpr(expr: string);
var Expres: TExpretion;
    ilist: TstringList;
    ii,i: integer;
begin
  ilist:=TstringList.create;
  ilist.clear;
  Expres := TExpretion.Create;
  Expres.Expr:=expr;
  try
   Expres.ImmiInit;
   expres.AddIdentList(ilist);
   expres.immiuninit;
   for i:=0 to ilist.count-1 do
     begin
        ii:=rtitems.GetSimpleID(ilist.Strings[i]);
        if ii>-1 then rtitems.DecCounter(ii);
     end;
   except
   end;
   if ilist<>nil then ilist.Free;
end;

procedure setCommandOn(tag: string);
var ii: integer;
begin
  ii:=rtitems.GetSimpleID(tag);
  if (ii>-1) then
   rtitems.AddCommand(ii,1,false) else
    Showmessage('Параметер команды "'+tag+'"не найден!');
end;

procedure setCommandOff(tag: string);
var ii: integer;
begin
 ii:=rtitems.GetSimpleID(tag);
 if (ii>-1) then
  rtitems.AddCommand(ii,0,false) else
    Showmessage('Параметер команды "'+tag+'" не найден!');
end;

procedure setCommandValue(tag: string; value: double);
var ii: integer;
begin
ii:=rtitems.GetSimpleID(tag);
 if (ii>-1) then
  rtitems.AddCommand(ii,value,true) else
    Showmessage('Параметер команды "'+tag+'" не найден!');
end;

procedure setValue(tag: string; value: double);
var ii: integer;
begin
  ii:=rtitems.GetSimpleID(tag);
  if (ii>-1) then
   rtitems.SetVal(ii,value,100) else
    Showmessage('Параметер команды "'+tag+'" не найден!');
end;

function GetBoolExpr(Expr: string): boolean;
var Expres: TExpretion;
begin
   result:=false;
   Expres := TExpretion.Create;
   Expres.Expr:=expr;
   try
   Expres.ImmiInit;
   expres.ImmiUpdate;
   result:=((expres.value<>0) and (expres.validLevel>90));
   expres.ImmiUnInit;
   except
   end;
   if assigned(Expres) then Expres.Free;
end;


function GetValExpr(Expr: string): double;
var Expres: TExpretion;
begin

   result:=0;
   Expres := TExpretion.Create;
   Expres.Expr:=expr;
   try
   Expres.ImmiInit;
   expres.ImmiUpdate;
   if (expres.validLevel>90) then result:=expres.value;
   expres.ImmiUnInit;
   except
   end;
   if assigned(Expres) then Expres.Free;
end;



procedure OpenForm(form: TForm; left: integer;top: integer);
begin
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
form.Left:=left;
form.Top:=top;
form.Show;
form.BringToFront;
end;

procedure ShowModalForm(form: TForm; left: integer;top: integer);
begin
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
form.Left:=left;
form.Top:=top;
form.ShowModal;
end;


procedure SimpleOpenForm(form: TForm; left: integer;top: integer);
begin
if form=nil then exit;
if not (form is TForm) then exit;
form.Left:=left;
form.Top:=top;
form.Show;
form.BringToFront;
end;

procedure HideForm(form: TForm; left: integer;top: integer);
begin
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
end;

procedure OpenFormByName(caption: string; left: integer;top: integer);
var i: integer;
    form: TForm;
begin
form:=nil;
for i:=0 to application.ComponentCount-1 do
   if (application.Components[i] is tform) and (trim(uppercase(tform(application.Components[i]).Caption))=trim(uppercase(caption))) then
       form:=Tform(application.Components[i]);
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
form.Left:=left;
form.Top:=top;
form.Show;
form.BringToFront;
end;

procedure ShowFormModalByName(caption: string; left: integer;top: integer);
var i: integer;
    form: TForm;
begin
form:=nil;
for i:=0 to application.ComponentCount-1 do
   if (application.Components[i] is tform) and (trim(uppercase(tform(application.Components[i]).Caption))=trim(uppercase(caption))) then
       form:=Tform(application.Components[i]);
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
form.Left:=left;
form.Top:=top;
form.ShowModal;
end;


procedure SimpleOpenFormByName(caption: string; left: integer;top: integer);
var i: integer;
    form: TForm;
begin
form:=nil;
for i:=0 to application.ComponentCount-1 do
   if (application.Components[i] is tform) and (trim(uppercase(tform(application.Components[i]).Caption))=trim(uppercase(caption))) then
       form:=Tform(application.Components[i]);
if form=nil then exit;
if not (form is TForm) then exit;
form.Left:=left;
form.Top:=top;
form.Show;
form.BringToFront;
end;

procedure HideFormByName(caption: string; left: integer;top: integer);
var i: integer;
    form: TForm;
begin
form:=nil;
for i:=0 to application.ComponentCount-1 do
   if (application.Components[i] is tform) and (trim(uppercase(tform(application.Components[i]).Caption))=trim(uppercase(caption))) then
       form:=Tform(application.Components[i]);
if form=nil then exit;
if not (form is TForm) then exit;
form.Hide;
end;

function NowI: TDatetime;
begin
  result:=now;
end;

function DateI: TDateTime;
begin
  result:=Date;
end;

function TimeI: TDateTime;
begin
  result:=Time;
end;

function FormatDateTime(val: TDateTime): string;

begin
try
 result:=DateTimetostr(val);
except
result:='error';
end;
end;

procedure ExecWin(programPath: string; programName: string);
var
  hW: HWND;
  ExeN: string;
begin
  hw:=0;
 { hW := findWindow(NIL, PansiChar(programName));
  if hw = 0 then  }
   begin

   WinExec(PansiChar(programPath), SW_SHOWNORMAL)
   end
 { else
  begin
     ShowWindow (hW, SW_SHOWMINIMIZED);
     ShowWindow (hW, SW_SHOWNORMAL);
  end;    }
end;

procedure beepWin(freq: dword; duration: dword);
begin
  beep(freq,duration);
end;

procedure PlaySoundWin(name: string; value: boolean);
begin
if value then Playsound(Pchar(name),0, SND_LOOP or SND_ASYNC or SND_ALIAS)
else Playsound(nil,0,SND_PURGE);
end;

end.
