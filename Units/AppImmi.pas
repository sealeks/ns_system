unit AppImmi;                                                                                        //

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ifps3utl, ifpscomp, ifps3, Menus, ifps3lib_std,ScriptFormU, Expr,Constdef,ActBoolExpr,
  ifps3lib_stdr, ifps3common,ifps_maincompile, ifps3debug,StrUtils, ifpiclassruntime, TypInfo, MemStructsU,GlobalValue,DesignIntf;

type
     TMetodKinds =(mkEventForm, mkBoolExpr, mkValueExpr, mkTimerTrigger, mkSimpleFunc);

type
  TUltrasimpleNotyfy = procedure of object;

type
IMethNamePropertyOut = interface
   ['{67F4213C-B9E7-46F5-8665-71878C45166B}']
      function GetMPC: string;
      procedure SetMPC(val: string);
      property NameMPC: string read GetMPC write SetMPC;
end;

type mrthinf = record
  names: string;
  typeF: PTypeData;
  end;

type pmrthinf = ^mrthinf;

type TSysscriptDecl = class (TComponent)
public
    decl: string;
    hint: string;
    MethName: string;
    typ: integer;
end;

type pstr = ^string;

IImmiScriptDesigner = interface
   ['{AE7AEE10-9D28-428E-8952-A4019B5D83B5}']
     procedure CreateComp(comp: TComponent; IDesig: IDesignerSelections);
     procedure DeleteComp(comp: TComponent; IDesig: IDesignerSelections);
     procedure RenameComp(old: string; new: string; IDesig: IDesignerSelections);
     procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
     function  CreateMethod(const Name: string; TypeData: PTypeData; IDesig: IDesignerSelections): TMethod;
     function  MethodExists(const Name: string): Boolean;
     procedure RenameMethod(const CurName, NewName: string; IDesig: IDesignerSelections);
     procedure StartRedactor(name: string);
     procedure StartRedactorS;
     function SaveM: boolean;
     procedure InitMforDesigner(visibles: boolean; l: integer; t: integer; w: integer; h: integer;
     classlist: TList; appList: TList; IDesig: IDesignerSelections);
     procedure SelectChange;
     procedure getfsc(var visibles: boolean;var l, t, w, h: integer);
end;

IImmiApplExec = interface
      ['{81C58896-5D9B-4776-AA61-924B6043E5EE}']
     procedure StartExe;
     procedure StopExe;
     function InitMforApplication(classlist: TList; appList: TList): TForm;
     function getcompilePrepare: boolean;
end;


type TApplicationImmi = class (TComponent,IImmiScriptDesigner,IImmiApplExec)
private
  fclasslistApp: TList;
 fProgrammText: TStringList;

 fbytext: string;
 frootdir: String;
 fConnectionText: String;
 fobjnameList: TStringList;
 flistApp: TList;
 fmethodList: TStringlist;
 finitializationSc:  TstringList;
 ffinalizationSc:  TstringList;
 fTypeList: TstringList;
 fvariableList: TstringList;
 fSysSc:  Tstringlist;
 finitialProg: TUltrasimpleNotyfy;
 ffinalProg: TUltrasimpleNotyfy;
 fcompilePrepare: boolean;
 function getcompilePrepare: boolean;
public
 IDesigS: IDesignerSelections;
 pascaltext: string;
 assablertext: string;
 ExecSc: TIFPSDebugExec;
 GarBigList: TList;
 mainProc: TComponent;
 exprproc: TComponent;
 procedure StopExe;
 procedure CompleteProgtext;
 function CompileFinal: boolean;
 procedure clearUnuseScriptElement;
 function InitM_exe:Tform;
 function  getclasslistApp: TList;
 procedure setclassListApp(val: TList);
 property  classlistApp: TList read getclasslistApp write setclassListApp;
 function GetlistApp: TList;
 procedure addExprToMeth(meth: Tcomponent; expr: Texprstr);
 function findUnicVar: string;
 function findVar(varname: string): integer;
 procedure CreateComp(comp: TComponent; IDesig: IDesignerSelections);
 procedure DeleteComp(comp: TComponent; IDesig: IDesignerSelections);
 function CreateMethodforType(metK: TMetodKinds): TComponent;
 procedure RenameComp(old: string; new: string; IDesig: IDesignerSelections);
 procedure setListApp(value: TList);
 constructor Create(AOwner: TComponent); override;
 destructor Destroy; override;
 procedure Compile;
 procedure StartExe;
 procedure RenamNameMeth(New: string; meth: TComponent);
 procedure StartRedactor(name: string); overload;
 procedure RenameMethod(const CurName, NewName: string; IDesig: IDesignerSelections);
 function MethodExists(const Name: string): Boolean;
 procedure RegisterObjectInForm(ListForm: TList);
 procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
 function FindProcInList(procstr: string): integer;
 property listApp: TList read GetlistApp write setlistApp;
 function CreateMethod(const Name: string; TypeData: PTypeData; IDesig: IDesignerSelections): TMethod;
 procedure RenameClMethod(old: string; new: string);
 procedure AddMethodFrom(Name: string; closure: string);
 procedure InitM;
 function SaveM: boolean;
 procedure ClearMethodFrom(Name: string; closure: string);
 procedure AfterConst;
 function GetFirstObj(meth: Tobject): TObject;
 procedure CreateVar(var name: string);
 procedure DeleteVar(name: string);
 function  VarisName(old, newN: string): boolean;
 procedure DeleteMeth(comp: TComponent);
 procedure StartRedactorS;
 procedure InitMforDesigner(visibles: boolean; l: integer; t: integer; w: integer; h: integer;
     classlist: TList; appList: TList; IDesig: IDesignerSelections);
 function InitMforApplication(classlist: TList; appList: TList): TForm;
 procedure printSb;
 procedure getselectList(var formL: TList;var CompL:TList);
 procedure SelectChange;
 procedure getfsc(var visibles: boolean;var l, t, w, h: integer);
published
 property methodList: TStringlist read {get}fmethodList write {set}fmethodList;
 property bytext: string read {get}fbytext write {set}fbytext;
 property ProgrammText: TStringList read {get}fProgrammText write {set}fProgrammText;
 property objnameList: TStringList read {get}fobjnameList write {set}fobjnameList;
 property ConnectionText: String read {get}fConnectionText write {set}fConnectionText;
 property initializationSc:  TstringList read finitializationSc write finitializationSc;
 property finalizationSc: TstringList read ffinalizationSc write ffinalizationSc;
 property SysSc:  Tstringlist read fSysSc;
 property TypeList: TstringList read fTypeList;
 property variableList: TstringList read fvariableList write fvariableList;
 property initialProg: TUltrasimpleNotyfy read finitialProg write finitialProg;
 property finalProg: TUltrasimpleNotyfy read ffinalProg write ffinalProg;
 property compilePrepare: boolean read fcompilePrepare write fcompilePrepare;
end;

type TMethodInform = class (TComponent)
private
 fMethodName: string;
 fMethodContent: TStringlist;
 fFormCompMethodName: TStringlist;
 fMethodKind: TMethodKind;
 fParamCount: Byte;
 fParamList: string	;
 fMethodDecl: string;
 fMethodType: TMetodKinds;
 fobj:TObject;
 ftypeout: string;
 fresultf: string;
public
 fprocfunc: boolean;
 constructor Create(AOwner: TComponent); override;
 procedure settypeData(td: PTypeData);
 function gettypedata: PTypeData;
 destructor Destroy;  override;
 function getClosure(i: integer;var CompName: string;var MethodPropName: string ): boolean;
 procedure setClosure( CompName: string; MethodPropName: string );



published
 property procfunc: boolean read fprocfunc write fprocfunc; 
 property MethodType: TMetodKinds read fMethodType write fMethodType;
 property MethodKind: TMethodKind read fMethodKind write fMethodKind;
 property ParamCount: Byte read fParamCount write fParamCount;
 property ParamList: string	 read fParamList write fParamList;
 property MethodName: string read fMethodName write fMethodName;
 property MethodContent: TStringlist read fMethodContent write fMethodContent;
 property FormCompMethodName: TStringlist read fFormCompMethodName write fFormCompMethodName;
 property MethodDecl: string read fMethodDecl write fMethodDecl;
 property resultf: string read fresultf write fresultf;

end;

var
  Imp: TIFPSRuntimeClassImporter;
  inscrtag, finscrtag,stinscrtag, stfinscrtag: integer;

  function GetstringByMetod(TypeData: PTypeData): string;
  procedure FillPropList( compl: TStringList ; var proplist: TStrings; var InsertList: TStrings; idetify: string);
 procedure addmethSys(catalog: TstringList; decl: string; hint: string; methname: string; typ: integer);
  procedure GettyPrList(valT :TStringList; valP :TStringList);

implementation
uses
  ifps3test2, ifps3disasm, ifpidelphi, ifpidll2, ifpidll2runtime,
  ifpiclass,  ifpiir_std, ifpii_std, ifpiir_stdctrls, ifpii_stdctrls,
  ifpiir_forms, ifpii_forms, ifpidelphiruntime,
  ifpii_graphics,
  ifpii_controls,
  ifpii_classes,
  ifpiir_graphics,
  ifpiir_controls, MainCompilerigistration,
  ifpiir_classes, UserScriptU, FormNewVarU,MainRunTimeRegistration;




procedure FillPropList( compl: TStringList ; var proplist: TStrings; var InsertList: TStrings; idetify: string);
var i,k,j,m,l,countpr: integer;
    findV: PIFPSVar;
    mystr: TstringList;
    mystrcl: string;
    form: TForm;
    comp: TComponent;
    TypeData: PTypeData;
    Props: PPropList;
    defClass: TClass;
    compilClass: TIfPsCompiletimeClass;
    stopwrite: byte;
    TypeInfo: PTypeInfo;
begin
   proplist.Clear;
   InsertList.Clear;
   mystr:=TstringList.Create;
   mystr.Add('');
   mystr.Strings[0]:=idetify[length(idetify)-0];
   m:=length(idetify)-1;
   l:=0;
   while (not (idetify[m] in [' ',';',':','='])) and (m>-1) do
     begin
      if not (idetify[m] in ['.']) then
        mystr.Strings[l]:=idetify[m]+mystr.Strings[l]
      else
        begin
         mystr.Add('');
         inc(l);
        end;
      dec(m);
     end;

 // showmessage('0');
   if (mystr.Strings[0][length(mystr.Strings[0])]='>') and (length(mystr.Strings[0])>1) and
            (mystr.Strings[0][length(mystr.Strings[0])-1]='-') then
    begin

      mystr.Strings[0]:=LeftStr(mystr.Strings[0],length(mystr.Strings[0])-2);
    //  if compl=nil then showmessage('nil') else  showmessage('no nil') ;
      k:=compl.IndexOf(uppercase(mystr.Strings[0]));

      if k>-1 then
        begin

          proplist.Clear;
          InsertList.Clear;
          form:=Tform(compl.Objects[k]);
          for j:=0 to form.ComponentCount-1 do
            begin
              InsertList.Add(form.Components[j].Name);
              proplist.Add(form.Components[j].Name+' :'+form.Components[j].ClassName);
            end;

        end;
    end
   else
    begin
       // showmessage('2');
        begin

          l:=mystr.count-1;
          if rightstr(mystr.strings[l],1)='.' then
            mystr.strings[l]:=leftstr(mystr.strings[l],length(mystr.strings[l])-1);

          k:=compl.IndexOf(uppercase(mystr.strings[l]));
          if k>-1 then
             begin
              TypeInfo:=TObject(compl.objects[k]).classInfo;
             end;

        if Typeinfo<>nil then
          begin
            while (l>0) and (TypeInfo<>nil) do
              begin
              dec(l);
               if rightstr(mystr.strings[l],1)='.' then
                   mystr.strings[l]:=leftstr(mystr.strings[l],length(mystr.strings[l])-1);
               TypeInfo:=GetPropInfo(TypeInfo,mystr.strings[l])^.PropType^;
              end;


             if typeinfo<>nil then
             begin
             TypeData := GetTypeData(TypeInfo);
             if not ((TypeData = nil) or (TypeData^.PropCount = 0)) then
             begin
             GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
                try
                countpr:=GetPropList(TypeInfo,[ tkInteger, tkChar, tkEnumeration, tkFloat,
                tkString, tkSet, tkClass, tkWChar, tkLString, tkWString,
                tkRecord,  tkInt64], Props,true);
                      for i := 0 to countpr - 1 do
                        begin
                           if (Props^[i]^.Name<>'Name') and  (Props^[i]^.Name<>'Tag') then
                           begin
                           InsertList.Add(Props^[i]^.Name);
                           proplist.Add(Props^[i]^.Name);
                           end;

                        end;
                finally
                Freemem(Props);
                end
            end;
            end;
         end;

   end;

end;
end;


function MyWriteln(Caller: TIFPSExec; p: PIFProcRec; Global, Stack: TIfList): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 1;
  //CompilerForm.Memo2.Lines.Add(LGetStr(Stack, PStart));
  Result := True;
end;

function MyReadln(Caller: TIFPSExec; p: PIFProcRec; Global, Stack: TIfList): Boolean;
var
  PStart: Cardinal;
begin
  if Global = nil then begin result := false; exit; end;
  PStart := Stack.Count - 2;
//  LSetStr(Stack, PStart + 1, InputBox(CompilerForm.Caption, LGetStr(stack, PStart), ''));
  Result := True;
end;

function ImportTest(S1: string; s2: Longint; s3: Byte; s4: word; var s5: string): string;
begin
  Result := s1 + ' ' + IntToStr(s2) + ' ' + IntToStr(s3) + ' ' + IntToStr(s4) + ' - OK!';
  S5 := s5 + ' '+ result + ' -   OK2!';
end;

var
  IgnoreRunline: Boolean = False;
  I: Integer;

procedure RunLine(Sender: TIFPSExec);
begin
  if IgnoreRunline then Exit;
  i := (i + 1) mod 15;
  Sender.GetVar('');
  if i = 0 then Application.ProcessMessages;
end;



constructor TMethodInform.Create(AOwner: TComponent);
begin
 inherited create(Aowner);
 fMethodContent:=TStringlist.Create;
 fFormCompMethodName:=TStringlist.Create;
end;



destructor TMethodInform.Destroy;
begin
  fMethodContent.Free;
  fFormCompMethodName.Free;
  inherited;
end;

procedure TMethodInform.setClosure(CompName: string; MethodPropName: string );
  var newC: string;
      i: integer;
begin
    newC:=UPPERCASE(CompName+':'+MethodPropName);
    if not fFormCompMethodName.Find(newC,i) then
      begin
       fFormCompMethodName.Add(uppercase(newC))
      end;

end;




procedure TMethodInform.settypeData(td: PTypeData);
var i: integer;
begin
 fMethodKind:=td^.MethodKind;
 fParamCount:=td^.ParamCount;
 fParamList:='';
 for i:=0 to 1023 do
 fParamList:=fParamList+td^.ParamList[i];
end;

function TMethodInform.gettypedata;
var k: PTypeData;
type myt = array [0..1023] of char;
begin
  new(k);
  k^.MethodKind:=fMethodKind;
  k^.ParamCount:=fParamCount;
  for i:=1 to length(ParamList) do
  k^.ParamList[i-1]:=char(ParamList[i]);
  result:=k;
end;

function TMethodInform.getClosure(i: integer;var CompName: string;var MethodPropName: string ): boolean;
var f,c,m,reS: string;
    jj: integer;
begin
 result:=false;
 if i<self.fFormCompMethodName.Count then
  begin
      reS:=self.fFormCompMethodName.Strings[i];
      jj:=pos(':',reS);
       if pos(':',reS)>0 then
         begin
           c:=copy(reS,1,pos(':',res)-1);
           reS:=copy(reS,pos(':',res)+1,length(res)-pos(':',res));
           if (pos(':',res)=0) and (length(reS)>0) then
             begin
               m:=Res;
               CompName:=c;
               MethodPropName:=m;
               result:=true;
             end;
         end;

  end;
end;








constructor TApplicationImmi.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 fmethodList:=TStringlist.Create;
 ExecSc := TIFPSDebugExec.Create;
fProgrammText:=TStringList.Create;
 fobjnameList:=TStringlist.Create;
 fobjnameList.Duplicates:=dupError;
 flistapp:=TList.Create;
 fclasslistApp:=tlist.Create;
 fobjnameList.CaseSensitive:=false;
 GarBigList:=TList.Create;
 ScriptForm:=TScriptForm.Create(nil);
 mainProc:=TComponent.Create(nil);
 finitializationSc:=TstringList.Create;
 ffinalizationSc:=TstringList.Create;
 finitializationSc.add('begin'+#10+#13+'end;');
 ffinalizationSc.add('begin'+#10+#13+'end;');
 fSysSc:=Tstringlist.Create;
 fSysSc.Sorted:=true;
 fTypeList:=TstringList.create;
 fTypeList.sorted:=true;
 fvariableList:=TstringList.Create;
 fcompilePrepare:=false;
end;

destructor TApplicationImmi.Destroy;
begin
 fTypeList.free;
 fvariableList.free;
 fSysSc.free;
 mainProc.Free;
 ScriptForm.Free;
  fclasslistApp.Free;
 finitializationSc.Free;
 ffinalizationSc.Free;
 ExecSc.free;
 fProgrammText.Free;
 GarBigList.Free;
 fobjnameList.Free;
 fmethodList.Free;
 flistapp.Free;
 inherited;
end;

procedure TApplicationImmi.getfsc(var visibles: boolean;var l, t, w, h: integer);
begin
  visibles:=ScriptForm.Showing;
  l:=ScriptForm.Left;
  w:=ScriptForm.Width;
  t:=ScriptForm.top;
  h:=ScriptForm.height;
end;


procedure TApplicationImmi.getselectList(var formL: TList;var CompL:TList);
var i:integer;
begin
if formL<>nil then
  begin
    formL.Clear;
    for i:=0 to  flistapp.Count-1 do
    if  (TObject(flistapp.Items[i]) is TForm) and (true) then
    formL.Add(flistapp.Items[i]);
  end;
  if CompL<>nil then
  begin
    CompL.Clear;
    for i:=0 to  IDesigS.Count-1 do
    if  not (TObject(IDesigS.Items[i]) is TForm) and (true) then
    CompL.Add(IDesigS.Items[i]);
  end;
end;

procedure TApplicationImmi.clearUnuseScriptElement;
var i,j,k: integer;
    flfind:boolean;
    methC: TMethodinform;
    compname, methtemp: string;
    remcomp: TComponent;
begin
 if exprproc<>nil then
   begin
     i:=0;
     while i<exprproc.ComponentCount do
       begin
         if  (exprproc.Components[i] is TActExpr) or (exprproc.Components[i] is TScriptTimer) then
           begin
            flfind:=false;
            for j:=0 to mainproc.ComponentCount-1 do
             begin
                if  mainproc.Components[j]<>nil then
                  if  mainproc.Components[j] is TMethodinform then
                    begin
                      methC:=mainproc.Components[j] as TMethodinform;
                      if  methC.fFormCompMethodName.Count>0 then
                      begin
                      k:=0;
                    //  showmessage(inttostr(self.fmethodList.Count));
                      if methC.fFormCompMethodName.Count>0 then
                      begin
                      methC.getClosure(k,compname, methtemp);
                      if trim(uppercase(compname))=trim(uppercase(exprproc.Name+'->'+exprproc.Components[i].Name)) then flfind:=true;
                      end;
                      end;
                    end;
             end;
             if not flfind then
             begin
             //Showmessage(inttostr(i)+' not  '+exprproc.Components[i].Name);
             remcomp:=exprproc.Components[i];
             exprproc.RemoveComponent(remcomp);
             remcomp:=nil;
             end
             else
             begin
           // Showmessage(inttostr(i)+' is '+exprproc.Components[i].Name);
             inc(i);
             end;
           end else inc(i);
       end;
   end;
end;


procedure TApplicationImmi.SelectChange;
begin
   scriptForm.updateshow;
end;

procedure TApplicationImmi.RenamNameMeth(New: string; meth: TComponent);
var i,j,k: integer;
    old: string;
begin
  if meth=nil then exit;
  if not (tcomponent(meth) is TMethodInform) then exit;
  old:= TMethodInform(meth).MethodName;
  i:=self.methodList.IndexOf(old);
  j:= self.methodList.IndexOf(new);
  if (i>-1) and (j<0) then
    begin
     self.methodList.Strings[i]:=new;
     TMethodInform(meth).MethodName:=new;
     for k:=0 to self.GarBigList.Count-1 do
       if pmrthinf(TMethod(self.GarBigList.Items[k]^).data)^.names=old then
       pmrthinf(TMethod(self.GarBigList.Items[k]^).data)^.names:=new;
    end
  else raise exception.Create('');
end;


procedure TApplicationImmi.ClearMethodFrom(Name: string; closure: string);
var i,k: integer;
begin
  for i:=0 to mainproc.ComponentCount-1 do
      if (mainproc.Components[i] is TMethodInform) and
           (uppercase(trim(TMethodInform(mainproc.Components[i]).fMethodName))=uppercase(trim(name))) then
            begin
             TMethodInform(mainproc.Components[i]).fFormCompMethodName.Find(closure,k);
             if k>-1 then
               TMethodInform(mainproc.Components[i]).fFormCompMethodName.Delete(k);
            end;
end;

procedure TApplicationImmi.AddMethodFrom(Name: string; closure: string);
var i,k: integer;
begin
  for i:=0 to mainproc.ComponentCount-1 do
      if (mainproc.Components[i] is TMethodInform) and
           (uppercase(trim(TMethodInform(mainproc.Components[i]).fMethodName))=uppercase(trim(name))) then
            begin
             TMethodInform(mainproc.Components[i]).fFormCompMethodName.Find(uppercase(closure),k);
             if k<0 then
               TMethodInform(mainproc.Components[i]).fFormCompMethodName.Add(uppercase(closure));
            end;
end;

procedure TApplicationImmi.RenameClMethod(old: string; new: string);
var i,k: integer;
begin
  for i:=0 to mainproc.ComponentCount-1 do
      if (mainproc.Components[i] is TMethodInform) and
           (uppercase(trim(TMethodInform(mainproc.Components[i]).fMethodName))=uppercase(trim(old))) then
            begin
             TMethodInform(mainproc.Components[i]).fMethodName:=new;
            end;
    k:=self.methodList.IndexOf(old);
    if k>-1 then self.methodList.Strings[k]:=new;
end;

procedure TApplicationImmi.RenameMethod(const CurName, NewName: string; IDesig: IDesignerSelections);
var procstring, findstr,buffstr: string;
    pos,j,i,k,numM: integer;
    TypeData: PTypeData;
    curnames: string;
    pmeth: ^TMethod;
    methName:  pmrthinf;
    methcom: TMethodInform;
begin
 for K:=0 to self.GarBigList.Count-1 do
   if uppercase(trim(pmrthinf(TMethod(GarBigList.Items[k]^).Data)^.names))=uppercase(CurName) then numM:=k;
 if numM<0 then exit
 else  pmeth:=self.GarBigList.Items[numM];
 if trim(newName)<>'' then
  begin
  for j:=0 to IDesig.Count-1 do
   begin
   if Tcomponent(IDesig.Items[j]) is tform then
   procstring:=Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC else
   procstring:=Tcomponent(IDesig.Items[j]).Owner.Name+'->'+Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC;
   AddMethodFrom(curname,procstring);
   RenameClMethod(curName,newname);
   pmeth^.Code:=nil;
   pmrthinf(pmeth^.Data)^.names:=NewName;
   TypeData:=gettypedata(GetPropInfo(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC)^.PropType^);
   SetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC,pmeth^);
   end
  end
 else
  begin
   for j:=0 to IDesig.Count-1 do
     begin
       if Tcomponent(IDesig.Items[j]) is tform then
       procstring:=Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC else
       procstring:=Tcomponent(IDesig.Items[j]).Owner.Name+'->'+Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC;
       if GetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC).data<>nil then
       begin
       Curnames:=pmrthinf(GetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC).data).names;
       ClearMethodFrom(CurNames,procstring);
       end;
     end;
     pmeth^.Code:=nil;
     pmeth^.Data:=nil;
     SetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC,pmeth^);
     self.GarBigList.Delete(numM);
  end;
end;


function TApplicationImmi.CreateMethodforType(metK: TMetodKinds): TComponent;
var actExp: TActExpr;
    metname: string;
    methnewcom: TMethodInForm;
    meth: ^TMethod;
    methName:  pmrthinf;
    methcom: TMethodInform;
    l: integer;
    scrttim: TScriptTimer;
    UserSc: TUserScript;
begin
if exprproc=nil then exit;
case metK of
      mkBoolExpr:
        begin
          actExp:=TActExpr.create(exprproc);
          l:=1;
          while exprproc.FindComponent('ActExp'+trim(inttostr(l)))<>nil do
          inc(l);
          actExp.Name:= 'ActExp'+trim(inttostr(l));
          metname:=(exprproc.Name+''+actexp.Name+'OnState');
          self.objnameList.AddObject(uppercase(exprproc.Name+'->'+actexp.Name),actExp);
          self.methodList.Add(metname);
          methnewcom:=TMethodInForm.Create(mainproc);
          methnewcom.MethodType:=metK;
          methnewcom.MethodName:=metname;
          methnewcom.MethodDecl:='(State: boolean; BlinkState: boolean)';
          methnewcom.MethodContent.Clear;
          methnewcom.MethodContent.Add('begin'+char(13)+char(10)+'end;');
          methnewcom.setClosure(uppercase(exprproc.Name+'->'+actexp.Name),uppercase('OnStateIMMIExpr'));
        end;
      mkValueExpr:
        begin
          actExp:=TActExpr.create(exprproc);
          l:=1;
          while exprproc.FindComponent('ActExp'+trim(inttostr(l)))<>nil do
          inc(l);
          actExp.Name:= 'ActExp'+trim(inttostr(l));
          metname:=(exprproc.Name+''+actexp.Name+'OnValue');
          self.objnameList.AddObject(uppercase(exprproc.Name+'->'+actexp.Name),actExp);
          self.methodList.Add(metname);
          methnewcom:=TMethodInForm.Create(mainproc);
          methnewcom.MethodType:=metK;
          methnewcom.MethodName:=metname;
          methnewcom.MethodDecl:='(Value: double)';
          methnewcom.MethodContent.Clear;
          methnewcom.MethodContent.Add('begin'+char(13)+char(10)+'end;');
          methnewcom.setClosure(uppercase(exprproc.Name+'->'+actexp.Name),uppercase('OnValueIMMIExpr'));
        end;
      mkTimerTrigger:
        begin
          scrttim:=TScriptTimer.create(exprproc);
          l:=1;
          while exprproc.FindComponent('TScrTimer'+trim(inttostr(l)))<>nil do
          inc(l);
           scrttim.Name:= 'TScrTimer'+trim(inttostr(l));
          scrttim.Enabled:=true;
          metname:=(exprproc.Name+''+ scrttim.Name+'OnTimer');
          self.objnameList.AddObject(uppercase(exprproc.Name+'->'+ scrttim.Name),scrttim);
          self.methodList.Add(metname);
          methnewcom:=TMethodInForm.Create(mainproc);
          methnewcom.MethodType:=metK;
          methnewcom.MethodName:=metname;
          methnewcom.MethodDecl:='(Sender: TObject)';
          methnewcom.MethodContent.Clear;
          methnewcom.MethodContent.Add('begin'+char(13)+char(10)+'end;');
          methnewcom.setClosure(uppercase(exprproc.Name+'->'+scrttim.Name),uppercase('OnTimer'));
        end;
        mkSimpleFunc:
        begin
          l:=1;
          metname:='UserProc'+inttostr(l);
          while methodList.IndexOf(metname)>-1 do
          begin
          inc(l);
          metname:='UserProc'+inttostr(l);
          end;

          methnewcom:=TMethodInForm.Create(mainproc);
          methnewcom.MethodType:=metK;
          methnewcom.MethodName:=metname;
          methnewcom.MethodDecl:='';
          try
          UserSc:=TUserScript.create(nil);
          if not UserSc.Execute(methnewcom,self) then raise Exception.Create('');
          except
          methnewcom.Free;
          if UserSc<>nil then UserSc.Free;;
          result:=nil;
          exit;
          end;
          if UserSc<>nil then UserSc.Free;
          self.methodList.AddObject(metname,methnewcom);
          methnewcom.MethodContent.Clear;
          methnewcom.MethodContent.Add('begin'+char(13)+char(10)+'end;');
        end;

end;
 result:=methnewcom;
 GetFirstObj(result);
end;


procedure TApplicationImmi.addExprToMeth(meth: Tcomponent; expr: Texprstr);
 var inmeth: TMethodInForm;
     compname, methEname: string;
     actExp: TActExpr;
     i,j,k: integer;
     newnameA: string;
begin
 if exprproc=nil then exit;
 inmeth:=TMethodInForm(meth);

      for i:=0 to exprproc.ComponentCount-1 do
        begin
          if exprproc.Components[i] is TActExpr then
            begin
              for j:=0 to inmeth.fFormCompMethodName.Count-1  do
              begin
             inmeth.getClosure(k,compname,methEname);
                begin
                  if inmeth.fMethodType=mkBoolExpr then
                  begin
                  if  (trim(uppercase(compname))=trim(uppercase(exprproc.name+'->'+exprproc.Components[i].name))) and
                      (trim(uppercase(methEname))=trim(uppercase('OnStateIMMIExpr'))) then
                       if (trim(uppercase(TActExpr(exprproc.Components[i]).ExprBool))<>trim(uppercase(expr))) then
                        begin
                          actExp:=TActExpr(TActExpr(exprproc.Components[i]));
                          actexp.ExprBool:=expr;
                        end;
                  end;
                  if inmeth.fMethodType=mkBoolExpr then
                  begin
                  if  (trim(uppercase(compname))=trim(uppercase(exprproc.name+'->'+exprproc.Components[i].name))) and
                      (trim(uppercase(methEname))=trim(uppercase('OnValueIMMIExpr'))) then
                       if (trim(uppercase(TActExpr(exprproc.Components[i]).ExprBool))<>trim(uppercase(expr))) then
                        begin
                          actExp:=TActExpr(TActExpr(exprproc.Components[i]));
                          actexp.ExprBool:=expr;
                        end;
                  end;
                end;
              end;
            end;
        end;

end;


function TApplicationImmi.CreateMethod(const Name: string; TypeData: PTypeData; IDesig: IDesignerSelections): TMethod;
var i, numM, k,j,h: integer;
    connstr: string;
    meth: ^TMethod;
    methName:  pmrthinf;
    methcom: TMethodInform;
    procstring: string;
    curname: string;
begin
    numM:=-1;
       if trim(name)='' then
         begin
           for j:=0 to IDesig.Count-1 do
              begin
               if Tcomponent(IDesig.Items[j]) is tform then
               procstring:=Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC else
               procstring:=Tcomponent(IDesig.Items[j]).Owner.Name+'->'+Tcomponent(IDesig.Items[j]).Name+':'+(IDesig as IMethNamePropertyOut).NameMPC;
               if GetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC).data<>nil then
                 begin
                  Curname:=pmrthinf(GetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC).data).names;
                  ClearMethodFrom(CurName,procstring);
                 end;
              end;
           result.Code:=nil;
           result.Data:=nil;
           exit;
         end;
       for K:=0 to self.GarBigList.Count-1 do
       if uppercase(trim(pmrthinf(TMethod(GarBigList.Items[k]^).Data)^.names))=uppercase(name) then numM:=k;
       if numM>-1 then
          begin
            meth:=GarBigList.Items[numM];
            methcom:=nil;
            for i:=0 to mainproc.ComponentCount-1 do
             if (mainproc.Components[i] is TMethodInform) and (uppercase(trim(TMethodInform(mainproc.Components[i]).fMethodName))=uppercase(trim(name))) then
               methcom:=TMethodInform(mainproc.Components[i]);
            if methcom<>nil then
              begin
                for j:=0 to IDesig.Count-1 do
                  begin
                    if IDesig.Items[j] is TFORM then
                         methcom.setClosure(Tcomponent(IDesig.Items[j]).Name,(IDesig as IMethNamePropertyOut).NameMPC)
                    else
                         methcom.setClosure(Tcomponent(IDesig.Items[j]).Owner.Name+'->'+Tcomponent(IDesig.Items[j]).Name,(IDesig as IMethNamePropertyOut).NameMPC);
                    SetMethodProp(Tcomponent(IDesig.Items[j]),(IDesig as IMethNamePropertyOut).NameMPC,meth^);
                  end;
              end;
          end
       else
          begin
            methcom:=TMethodInform.Create(mainproc);
            methCom.fMethodType:=mkEventForm;
            methcom.settypeData(TypeData);
            methcom.fMethodName:=Name;
            methcom.Name:=Name;
            fmethodList.Add(Name);
            for j:=0 to IDesig.Count-1 do
              begin
                if IDesig.Items[j] is TFORM then
                  methcom.setClosure(Tcomponent(IDesig.Items[j]).Name,(IDesig as IMethNamePropertyOut).NameMPC)
                else
                  methcom.setClosure(Tcomponent(IDesig.Items[j]).Owner.Name+'->'+Tcomponent(IDesig.Items[j]).Name,(IDesig as IMethNamePropertyOut).NameMPC);
              end;
            methcom.MethodContent.Add('begin'+char(13)+char(10)+'end;');
            methcom.MethodDecl:=GetstringByMetod(TypeData);
            new(meth);
            new(methName);
            methName^.names:=name;
            methName^.typeF:=TypeData;
            meth^.Data:=methName;
            meth^.Code:=nil;
            GarBigList.Add(meth);
         end;
    result:=meth^;
end;


procedure TApplicationImmi.setListApp(value: TList);
var formd: TForm;
    fn, fc: string;
    i, j: integer;
begin
   fobjnameList.Clear;
   if not assigned(value) then exit;
   for j:=0 to value.Count-1 do
   if flistapp.IndexOf(value.items[j])<0 then
    fListApp.Add(value.items[j]);
   if exprproc<>nil then
     if listapp.IndexOf(exprproc)<0 then
        flistapp.Add(exprproc);
   for i:=0 to flistapp.Count-1 do
     begin
     formd:=TForm(flistapp.items[i]);
     fn:=formd.Name;
     fobjnameList.AddObject(trim(fn), formd);
       for j:=0 to formd.ComponentCount-1 do
         fobjnameList.AddObject((fn+'->'+trim(formd.components[j].Name)), formd.components[j]);
     end;

     {if exprproc<>nil then
      if flistapp.IndexOf(exprproc)<0 then
      fobjnameList.AddObject(trim(exprproc.Name), exprproc);

     if exprproc<>nil then
         begin
         fobjnameList.AddObject(trim(exprproc.Name), exprproc);
         for j:=0 to exprproc.ComponentCount-1 do
           fobjnameList.AddObject(uppercase(exprproc.Name+'->'+trim(exprproc.components[j].Name)), exprproc.components[j]);
         end;       }
  if self.objnameList.IndexOf(self.Name)<0 then
  self.objnameList.AddObject(self.Name,self);
  flistapp.Add(self)
end;

function TApplicationImmi.getcompilePrepare: boolean;
begin
result:=fcompilePrepare;
end;

function TApplicationImmi.GetFirstObj(meth: TObject): Tobject;
var l,k: integer;
    compname, temp: string;
    fl: boolean;
    tempComp: TComponent;
begin
   result:=nil;
   if meth=nil then exit;
   if not (meth is TMethodInform) then exit;
   if (meth as TMethodInform).MethodType=mkEventForm then exit;
   if (meth as TMethodInform).MethodType=mkSimpleFunc then exit;
   if ((meth as TMethodInform).fobj=nil) then
     begin
         fl:=false;
         l:=TMethodInform(meth).FormCompMethodName.Count-1;
         while (l>-1) and (not fl) do
            begin
               TMethodInform(meth).getClosure(l,compname,temp);
               k:=self.objnameList.IndexOf(compname);
               if k>-1 then
                   result:=tComponent(self.objnameList.Objects[k]);
               if not ((result is  TActExpr) or
                   (result is  TScriptTimer)) then result:=nil;
               if result<>nil then fl:=true;
               dec(l);
            end;
          (meth as TMethodInform).fobj:=result;
          while (l>-1) do
            begin
               TMethodInform(meth).getClosure(l,compname,temp);
                k:=self.objnameList.IndexOf(compname);
                if k>-1 then
                   tempComp:=Tcomponent(self.objnameList.Objects[k]);
               if not (TComponent(tempComp) is  TActExpr) and
                   not (TComponent(tempComp) is  TScriptTimer) then tempComp:=nil;
               if tempComp<>nil then TMethodInform(meth).fFormCompMethodName.Delete(l);
               dec(l);
            end;
      end;
     result:=(meth as TMethodInform).fobj;
end;

procedure TApplicationImmi.InitMforDesigner(visibles: boolean; l: integer; t: integer; w: integer; h: integer;
     classlist: TList; appList: TList; IDesig: IDesignerSelections);
begin
if ScriptForm<>nil then
  begin
  //  ScriptForm.Top:=t;
   // ScriptForm.Left:=l;
   // ScriptForm.Height:=h;
   // ScriptForm.Width:=w;
  end;
IDesigS:= IDesig;
self.Name:='Main_script_kernel';
self.classlistApp:=classlist;
self.listApp:=appList;
self.InitM;

end;

function TApplicationImmi.InitMforApplication(classlist: TList; appList: TList): TForm;
begin
 if not fcompilePrepare then exit;
self.Name:='Main_script_kernel';
result:=self.InitM_exe;
self.classlistApp:=classlist;
self.listApp:=appList;
end;

procedure TApplicationImmi.InitM;
var i,j,k: integer;
     FileNameP: string;
     fs: TFilestream;
     script: TMethodInform;
     objname: string;
     propname: string;
     obj: TComponent;
     meth: ^TMethod;
     methName:  pmrthinf;
    ae:  TAppExpr;

begin
  for i:=0 to self.fmethodList.Count-1 do
    begin
       FileNameP:=formsDir+self.fmethodList.Strings[i]+'.scrl';
       if FileExists(fileNameP) then
         begin
            try
              script:=TMethodInform.Create(mainproc);
              script.Name:=self.fmethodList.Strings[i];
              ReadComponentResFile(FileNameP,script);
              script.Name:=self.fmethodList.Strings[i];
              new(meth);
              new(methName);
              methName^.names:=self.fmethodList.Strings[i];
              methName^.typeF:=script.gettypedata;
              meth^.Data:=methName;
              meth^.Code:=nil;
              for j:=0 to script.fFormCompMethodName.Count-1 do
               begin
                if script.getClosure(j,objname,propname) then
                 begin
                   self.fobjnameList.Count;
                   k:=self.fobjnameList.IndexOf((objname));
                   if k>-1 then
                    begin
                     obj:=tcomponent(self.fobjnameList.Objects[k]);
                     SetMethodProp(obj,propname,meth^);
                    end;
                 end;
               end;
               self.methodList.Objects[i]:=script;
               if GarBigList.IndexOf(meth)=-1 then GarBigList.Add(meth);
            except
               script.Free;
            end
         end;
       //if assigned(fs) then fs.Free
    end;
    exprproc:=TForm.Create(nil);

    exprproc.Name:='_ap_scr';
    FileNameP:=formsDir+'scr_application'+'.scrapp';
    if Fileexists(FileNameP) then
    try
     fs:=TFilestream.Create(fileNameP,fmOpenRead);
     fs.ReadComponent(exprproc);
      exprproc.Name:='_ap_scr';
     //exprproc:=appexpr;
    except

    //  appexpr.Free;
      //self.exprproc:=self.exprproc;
    end else
    begin
      ae:=TAppExpr.Create(exprproc);
      ae.Name:='TAppExpr';
      TForm(exprproc).Visible:=false;
      TForm(exprproc).BorderStyle:=bsNone;
      TForm(exprproc).Left:=0;
      TForm(exprproc).Top:=0;
      TForm(exprproc).height:=0;
      TForm(exprproc).width:=0;
       TForm(exprproc).hide;
    end;
    if assigned(fs) then
      fs.Free;
    if exprproc<>nil then
    for i:=0 to exprproc.ComponentCount-1 do
      begin
             //showmessage(exprproc.Components[i].Name);
             self.objnameList.AddObject(uppercase(exprproc.Name+'->'+ exprproc.Components[i].Name), exprproc.Components[i]);

      end;
  //self.objnameList.AddObject(self.Name,self);
    for i:=0 to mainproc.ComponentCount-1 do
       if mainproc.Components[i] is TMethodInform then self.GetFirstObj( mainproc.Components[i]);
   // for i:=0 to self.methodList.Count-1 do

    AfterConst;
end;



function TApplicationImmi.InitM_exe:Tform;
var i,j,k: integer;
     FileNameP: string;
     fs: TFilestream;
     script: TMethodInform;
     objname: string;
     propname: string;
     obj: TComponent;
     meth: ^TMethod;
     methName:  pmrthinf;
    ae:  TAppExpr;
    rr: TList;
begin
    rr:=TList.create;
    exprproc:=TForm.Create(AppLication);
    //self.exprproc:= appexpr;
    exprproc.Name:='_ap_scr';
    FileNameP:=formsDir+'scr_application'+'.scrapp';
    if Fileexists(FileNameP) then
    try
     fs:=TFilestream.Create(fileNameP,fmOpenRead);
     fs.ReadComponent(exprproc);
     exprproc.Name:='_ap_scr';
    except
       if exprproc<>nil then exprproc.Free
    end;
    if assigned(fs) then
      fs.Free;
   { if exprproc<>nil then
    for i:=0 to exprproc.ComponentCount-1 do
      begin
    //    showmessage(exprproc.Components[i].Name);
             self.objnameList.AddObject(uppercase(exprproc.Name+'->'+ exprproc.Components[i].Name), exprproc.Components[i]);

      end;
     if exprproc<>nil then rr.add(exprproc);
     setlistapp(rr);
     rr.free;               }
   result:=exprproc as TForm;
end;




function TApplicationImmi.SaveM: boolean;
var i: integer;
     FileNameP: string;
     fss: TFilestream;
     script: TMethodInform;
    
begin
  if not self.CompileFinal then
  begin
  result:=false;

  end else
  result:=true;
  clearUnuseScriptElement;
  if ScriptForm<>nil then ScriptForm.Sets;
  for i:=0 to mainproc.ComponentCount-1 do
    begin
       if (mainproc.Components[i] is TMethodInform) then
       begin
       script:=(mainproc.Components[i] as TMethodInform);
      // script.gettypedata;
       FileNameP:=formsDir+TMethodInform(mainproc.Components[i]).fMethodName+'.scrl';
       if not FileExists(FileNameP) then fileclose(filecreate(FileNameP));
       if FileExists(fileNameP)  then
         begin
            try
           //   showmessage(script.ParamList);
              WriteComponentresfile(FileNameP,script);
            except
            end
         end;
       //if assigned(fs) then fs.Free
       end;
    end;
    self.fprogrammtext.text:='';
    if (exprproc<>nil)  and  (exprproc.ComponentCount>0) then
    try

     FileNameP:=formsDir+'scr_application'+'.scrapp';
     //appexpr:=TAppexpr.Create(self);
     if fileexists(FileNameP) then  RenameFile(FileNameP,FileNameP+'~');
     fss:=TFilestream.Create(FileNameP,fmCreate);
      Tform(exprproc).Name:='_ap_scr';
      fss.WriteComponent(Tform(exprproc));


     //self.exprproc:= appexpr;
    except
      if assigned(fss) then fss.Free;
      //appexpr.Free;
      //self.exprproc:=nil;
    end;
end;

procedure TApplicationImmi.CompleteProgtext;
var i,j,k,errc:  integer;
    conm, namPr: string;
begin
clearUnuseScriptElement;
 if exprproc<>nil then
   if listapp.IndexOf(exprproc)<0 then listapp.Add(exprproc);
  if listapp.IndexOf(self)<0 then listapp.Add(self);
  MainCompilerigistration.ListForm:=self.listApp;
  MainCompilerigistration.classlistApp:=fclasslistApp;
  ifps_maincompile.tcom:=self;
  pascaltext:='';

  if fvariableList.Count>0 then pascaltext:=pascaltext+'var'+#13;
  for i:=0 to self.fvariableList.Count-1 do
      pascaltext:=pascaltext+self.fvariableList.Strings[i]+';'+#13;

  pascaltext:=pascaltext+#10+#13;
   inscrtag:= length(pascaltext);
 pascaltext:=pascaltext+'procedure InitializationS;'+#13;
  pascaltext:=pascaltext+self.initializationSc.Text+#10+#13;
  stinscrtag:= length(pascaltext);
  finscrtag:= length(pascaltext);
  pascaltext:=pascaltext+'procedure FinalizationS;'+#13;
  pascaltext:=pascaltext+self.ffinalizationSc.Text+#10+#13;
  stfinscrtag:= length(pascaltext);
  for i:=0 to mainproc.ComponentCount-1 do
    if mainproc.Components[i] is TMethodInform then
        begin
          if TMethodInform(mainproc.Components[i]).fMethodType=mkSimpleFunc then
          begin
          if not TMethodInform(mainproc.Components[i]).procfunc then
          pascaltext:=pascaltext+'procedure '+TMethodInform(mainproc.Components[i]).fMethodName+TMethodInform(mainproc.Components[i]).fMethodDecl+';'+#13 else
          pascaltext:=pascaltext+'function '+TMethodInform(mainproc.Components[i]).fMethodName+TMethodInform(mainproc.Components[i]).fMethodDecl+':'+TMethodInform(mainproc.Components[i]).resultf+';'+#13;
          TMethodInform(mainproc.Components[i]).Tag:=length(pascaltext);
          pascaltext:=pascaltext+TMethodInform(mainproc.Components[i]).fMethodContent.Text+#10+#13;
          end;
        end;


  for i:=0 to mainproc.ComponentCount-1 do
    if mainproc.Components[i] is TMethodInform then
        begin
          if TMethodInform(mainproc.Components[i]).fFormCompMethodName.Count>0 then
          begin
          pascaltext:=pascaltext+'procedure '+TMethodInform(mainproc.Components[i]).fMethodName+TMethodInform(mainproc.Components[i]).fMethodDecl+';'+#13;
          TMethodInform(mainproc.Components[i]).Tag:=length(pascaltext);
          pascaltext:=pascaltext+TMethodInform(mainproc.Components[i]).fMethodContent.Text+#10+#13;
          end;
        end;
   pascaltext:=pascaltext+#10+#13;
   // pascaltext:=pascaltext+'Initialization:=@InitializationS;'+#10+#13;
      // pascaltext:=pascaltext+'Finalization:=@FinalizationS;'+#10+#13;
    pascaltext:=pascaltext+'begin'+#10+#13;
   for i:=0 to mainproc.ComponentCount-1 do
    if mainproc.Components[i] is TMethodInform then
          begin
           for k:=0 to TMethodInform(mainproc.Components[i]).fFormCompMethodName.Count-1 do
            begin
              j:=k;
              namPr:='';conm:='';
              TMethodInform(mainproc.Components[i]).getClosure(j,conm,namPr);
              if (namPr<>'') and (conm<>'') then
                begin
                   pascaltext:=pascaltext+conm+'.'+ namPr+':=@'+TMethodInform(mainproc.Components[i]).fMethodName+';'+#13;
                end;
            end;
          end;

    self.objnameList.AddObject(self.Name,self);
    pascaltext:=pascaltext+uppercase(self.Name+'.initialProg:=@InitializationS;')+#13;
    pascaltext:=pascaltext+uppercase(self.Name+'.finalProg:=@FinalizationS;')+#13;

    pascaltext:= pascaltext+'end.';
   // ScriptForm.memo3.Text:=pascaltext;
end;


function TApplicationImmi.CompileFinal: boolean;
var i,j,k,errc:  integer;
    conm, namPr: string;
begin
  if scriptform<>nil then scriptform.Sets;
  CompleteProgtext;
  if ifps_maincompile.Execute(pascaltext,ScriptForm.memo3,errc) then
      begin
       bytext:=ifps_maincompile.compileText;
       self.fcompilePrepare:=true;
       result:=true;
      end else
      begin
        if MessageBox(0,Pchar('Компиляция скриптов приложения не удалась.'+#10+#13+
        'Сохранить проект некомпилированным?'+#10+#13+#10+#13+
        'Внимание!!! Сохранение проекта некомпилированным'+#10+#13+
        'приведет к тому, что скрипты не будут запущены'+#10+#13+
        ' в среде исполнения. В случае, если будет оставлена'+#10+#13+
         'предыдущая компиляция, возможна некоректная работа'+#10+#13+
          'скриптов. Рекомендуется устранить проблемы приведшие'+#10+#13+
           'к невозможности компиляциии.'),
                                   'Предупреждение',MB_YESNO +MB_TOPMOST+MB_ICONWARNING)=IDYES	then

        begin
         self.fcompilePrepare:=false;
         result:=true;
        end else result:=false;
      end;

end;

procedure TApplicationImmi.Compile;
var i,j,k,errc:  integer;
    conm, namPr: string;
begin
CompleteProgtext;
 errc:=-1;
   if ifps_maincompile.Execute(pascaltext,ScriptForm.memo3,errc) then
      begin
       bytext:=ifps_maincompile.compileText;
       // assablertext:=ifps_maincompile.assembltext;
      end else
      begin
        assablertext:='Проект не компиллирован';
        if (errc>=inscrtag) and (errc<stinscrtag) then
          begin
           ScriptForm.setproerr(self.initializationSc,inscrtag-errc);
           exit;
          end ;
        if (errc>=finscrtag) and (errc<stfinscrtag) then
          begin
           ScriptForm.setproerr(self.finalizationSc,inscrtag-errc);
           exit;
          end ;
          {
           else
          begin
            if ((errc>=finscrtag) and (mainproc.ComponentCount=0)) or
              ((errc>=finscrtag) and ((mainproc.Components[0] as TMethodInform).tag<errc))
             then
              begin
               ScriptForm.setproerr(self.finitializationSc,finscrtag-errc);
              end
              else
              begin   }
                for i:=0 to mainproc.ComponentCount-1 do
                  if mainproc.Components[i] is TMethodInform then
                   begin
                   if ((mainproc.Components[i] as TMethodInform).tag<errc) then
                     if ScriptForm<>nil then
                       ScriptForm.setproerr((mainproc.Components[i] as TMethodInform),(mainproc.Components[i] as TMethodInform).tag-errc);
              end;
              {end;
       { end;}
      end


end;

procedure TApplicationImmi.printSb;
var i,j,k,errc:  integer;
    conm, namPr: string;
begin
CompleteProgtext;
 errc:=-1;
   if ifps_maincompile.ExecuteB(pascaltext,ScriptForm.memo3,errc) then
      begin
        assablertext:=ifps_maincompile.assembltext;
      end else
      begin
        assablertext:='Проект не компиллирован';
      end
end;



procedure TApplicationImmi.CreateVar(var name: string);
var old1, newN: string;
    i,j, ind: integer;
    newVform: TFormNewVar;
begin
if name='' then
 begin
   try
   newVform:=TFormNewVar.Create(nil);
   newN:=self.findUnicVar;
   newN:=newN+': boolean';
   newVform.Execute(newN,self);
   finally
   newVform.Free;
   end;
 end else
   begin
      try
   newVform:=TFormNewVar.Create(nil);
   newN:=self.findUnicVar;
   newVform.Execute(name,self);
   finally
   newVform.Free;
   end;
   end;
end;

procedure TApplicationImmi.DeleteVar(name: string);
   var i,j, ind: integer;
begin
  i:=self.variableList.IndexOf(name);
  self.variableList.Delete(i);
end;

function TApplicationImmi.VarisName(old, newN: string): boolean;
   var i,j, ind: integer;
       ty, nam: string;
begin
  result:=false;
  if pos(':',newN)<>0 then
   begin
    ty:=trim(copy(newN,pos(':',newN)+1,length(newN)-1));
    if self.fTypeList.IndexOf(ty)>-1 then
      begin
      i:=self.variableList.IndexOf(old);
      if i>-1 then
         self.variableList.Strings[i]:=newN;
       result:=true;
       exit;
      end;
    end;

end;

procedure TApplicationImmi.DeleteMeth(comp: TComponent);
var i,j: integer;
    methName: string;
    compR: TComponent;
begin
   if comp=nil then exit;
   if comp is TMethodInform then
     begin
         methName:=(comp as TMethodInform).fMethodName;
         i:=self.fmethodList.IndexOf(methName);
         if i>-1 then
         self.fmethodList.Delete(i);

        methName:=(comp as TMethodInform).fMethodName;
        I:=0;
        while i<self.mainProc.ComponentCount do
         begin
           if comp=self.mainProc.Components[i] then
             begin
             self.GetFirstObj(comp);

             if (comp<>nil) and (TMethodInform(comp).fobj<>nil) then
             begin
             j:=self.fobjnameList.IndexOf(Tcomponent(TMethodInform(comp).fobj).Owner.Name+'->'+Tcomponent(TMethodInform(comp).fobj).Name);
             if j>-1 then
             fobjnameList.Delete(j);
             TMethodInform(comp).fobj.free;
             TMethodInform(comp).fobj:=nil;
             end;
             compR:=self.mainProc.Components[i]; mainProc.RemoveComponent(compR);

             end
           else inc(i);
         end;
         i:=0;

           while i<GarBigList.Count do
              if uppercase(trim(pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.names))=uppercase(trim( methName)) then
                 begin TMethod(GarBigList.Items[i]^).Data:=nil; GarBigList.Delete(i) end else inc(i);
         end;

end;


procedure TApplicationImmi.CreateComp(comp: TComponent; IDesig: IDesignerSelections);
var old1, compare: string;
    i,j: integer;
begin
  if comp=nil then exit;
   if Comp is TForm then
    begin
     old1:=(comp.name);
    end else
    begin
     old1:=(comp.owner.name+'->'+comp.name);
    end;
    self.objnameList.AddObject(old1,Comp);
    if Comp is TForm then
     begin
        for i:=0 to comp.ComponentCount-1 do
         if (comp.Components[i]<>nil) and not (comp.Components[i] is Tform)  then
           CreateComp(comp.Components[i],IDesig);
     end;
end;

procedure TApplicationImmi.DeleteComp(comp: TComponent; IDesig: IDesignerSelections);
var old1,old2, compare: string;
    i,j: integer;
begin
  if comp=nil then exit;
   if Comp is TForm then
    begin
     old1:=uppercase(comp.name+':');
     old2:=uppercase(comp.name+'->');

    end else
    begin
     old1:=uppercase(comp.owner.name+'->'+comp.name+':');
     old2:=''
    end;
   for i:=0 to mainproc.ComponentCount-1 do
     begin
       if (mainproc.Components[i] is TMethodInform) then
         begin
            j:=0;
            while j<(mainproc.Components[i] as TMethodInform).fFormCompMethodName.Count do
             begin
               compare:= uppercase((mainproc.Components[i] as TMethodInform).fFormCompMethodName.Strings[j]);
               if (old1=compare) or ((old2='') and (pos(old2,compare)=1)) then  (mainproc.Components[i] as TMethodInform).fFormCompMethodName.Delete(j) else
               inc(j);
             end;
         end;
     end;


  { if Comp is TForm then
    begin
     old1:=uppercase(comp.name);
     old2:=uppercase(comp.name+'->');

    end else
    begin
     old1:=uppercase(comp.owner.name+'->'+comp.name);
     old2:=''
    end;
   for i:=0 to self.objnameList.Count-1 do
     begin
       j:=0;
       while j<self.objnameList.Count do
          begin
           compare:= uppercase(self.objnameList.Strings[j]);
           if (uppercase(old1)=compare) or ((old2='') and (pos(uppercase(old2),compare)=1)) then  self.objnameList.Delete(j) else
           inc(j);
          end;
     end;     }

end;

procedure TApplicationImmi.RenameComp(old: string; new: string; IDesig: IDesignerSelections);
var Comp: Tcomponent;
    old1, new1, old2, new2, compare: string;
    i,j: integer;
begin
  if IDesig.Count=0 then exit;
  Comp:=TComponent(IDesig.Items[0]);
  if Comp is TForm then
    begin
     old1:=uppercase(old+':');
     old2:=uppercase(old+'->');
     new1:=uppercase(new+':');
     new2:=uppercase(new+'->');
    end else
    begin
     old1:=uppercase(comp.Owner.Name+'->'+old+':');
     old2:='';
     new1:=uppercase(comp.Owner.Name+'->'+new+':');
     new2:='';
    end;
    for i:=0 to mainproc.ComponentCount-1 do
     begin
       if (mainproc.Components[i] is TMethodInform) then
         begin
           for j:=0 to (mainproc.Components[i] as TMethodInform).fFormCompMethodName.Count-1 do
             begin
              compare:=uppercase((mainproc.Components[i] as TMethodInform).fFormCompMethodName.Strings[j]);
              if pos(old1,compare)=1 then
                (mainproc.Components[i] as TMethodInform).fFormCompMethodName.Strings[j]:=AnsiReplaceText(compare,old1,new1);
              if (old2<>'') and (new2<>'') and (pos(old2,compare)=1) then
                (mainproc.Components[i] as TMethodInform).fFormCompMethodName.Strings[j]:=AnsiReplaceText(compare,old2,new2);
             end;
         end;
      end;
  if Comp is TForm then
    begin
     old1:=(old);
     old2:=(old+'->');
     new1:=(new);
     new2:=(new+'->');
    end else
    begin
     old1:=(comp.Owner.Name+'->'+old);
     old2:='';
     new1:=(comp.Owner.Name+'->'+new);
     new2:='';
    end;
  for i:=0 to self.objnameList.Count-1 do
    begin
      if uppercase(self.objnameList.Strings[i])=uppercase(old1) then
        self.objnameList.Strings[i]:=new1;
      if (old2<>'') and (new2<>'') then
        begin
           compare:=(self.objnameList.Strings[i]);
           if pos(uppercase(old2),uppercase(compare))=1 then
             self.objnameList.Strings[i]:=AnsiReplaceText(compare,old2,new2);
        end;
    end
end;

procedure TApplicationImmi.GetMethods(TypeData: PTypeData; Proc: TGetStrProc);

function DAtTypEq(a: PTypedata;b: PTypedata): boolean;
var i: integer;
begin
  result:=false;
  for i:=0 to 1023 do
   begin
   if a^.ParamList[i]<>b^.ParamList[i] then exit;
   if (a^.ParamList[i]=char(0)) and (b^.ParamList[i]=char(0)) then
  begin
    result:=true;
    exit;
  end;
   end;
  // show(i);
  result:=true;
end;
var strL: TStringList;
    i,j, num: integer;
    unitstr: string;
    objstr: string;
    eventstr: string;
    procstr: string;
    tcomp: TComponent;
    meth: ^TMethod;
    methName:  pmrthinf;
    methodL: TStringList;
begin
methodL:=TStringList.Create;
  strL:=TStringList.Create;
  strL.Text:=self.fConnectionText;
  for i:=0 to self.GarBigList.Count-1 do
     begin
     if (pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.typeF^.MethodKind=TypeData^.MethodKind) and
        (pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.typeF^.PropCount=TypeData^.PropCount) and
        DAtTypEq(pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.typeF,TypeData) then
           methodL.Add(pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.names)

     end;
   for i:=0 to methodL.Count-1 do Proc(methodL.Strings[i]);
   methodL.Free;
end;

function TApplicationImmi.FindProcInList(procstr: string): integer;
var strL: TStringList;
    i,j,k, num: integer;
    strp: string;
begin
  result:=0;
  exit;
  //for k:=0 to self.fProgrammText.Count-1 do
  begin
     strp:=trim(pascaltext);
     if AnsiSameText(uppercase(trim({'procedure'+ }procstr{ +'(')})),uppercase(trim(strp))) then
        begin
        result:=k;
        exit;
        end;
  end;
end;




function TApplicationImmi.MethodExists(const Name: string): Boolean;

var strL: TStringList;
    i,j, num: integer;
    unitstr: string;
    objstr: string;
    eventstr: string;
    procstr: string;
    tcomp: TComponent;
    meth: ^TMethod;
    methName:  pstr;
    methodL: TStringList;
begin
  for i:=0 to GarBigList.Count-1 do
      if uppercase(trim(pmrthinf(TMethod(GarBigList.Items[i]^).Data)^.names))=name then
           begin
              result:=true;
              exit
           end;
end;


procedure TApplicationImmi.StartRedactor(name: string);
VAR STRP: STRING;
    a: TMethodInform;
begin
a:=nil;
 for i:=0 to mainproc.ComponentCount-1 do
    begin
      if mainproc.Components[i] is TMethodInform then
       begin

         if trim(TMethodInform(mainproc.Components[i]).MethodName)=trim(Name) then
         a:=TMethodInform(mainproc.Components[i]);
       end;
    end;
  ScriptForm.CompL:=self.fobjnameList;
  if a<>nil then
  ScriptForm.ExecuteByName(self,a);

end;

procedure TApplicationImmi.StartRedactorS;
VAR STRP: STRING;
    a: TMethodInform;
begin
ScriptForm.CompL:=self.fobjnameList;
ScriptForm.ExecuteByName(self,nil);
end;



procedure TApplicationImmi.StartExe;
var i: integer;
begin
    if not fcompilePrepare then exit;
    if trim(bytext)='' then exit;
    try
      RegisterDLLRuntime(ExecSc);
      for i:=0 to fclasslistApp.count-1 do RIRegisterTFreeClass( imp, TClass(fclasslistApp.Items[i]));
      RegisterClassLibraryRuntime(ExecSc, Imp);
      tag := longint(ExecSc);
      ExecSc.OnRunLine := RunLine;
      RegisterDelphiMainFunction(ExecSc);
    //  x2.RegisterFunctionName('WRITELN', MyWriteln, nil, nil);
     // x2.RegisterFunctionName('READLN', MyReadln, nil, nil);
     { RegisterDelphiFunctionR(x2, @SetOn, 'SETON' , cdRegister);
      RegisterDelphiFunctionR(x2, @SetOff, 'SETOFF' , cdRegister);
      RegisterDelphiFunctionR(x2, @SetV, 'SETVAL' , cdRegister);
      RegisterDelphiFunctionR(x2, @getV, 'GETV' , cdRegister);
      RegisterDelphiFunctionR(x2, @getB, 'GETB' , cdRegister);   }
     // RegisterDelphiFunctionR(x2, @ImportTest, 'IMPORTTEST', cdRegister);
      RegisterStandardLibrary_R(ExecSc);
      //x2.LoadData(self.bytext.Strings[0]);
      ///x2.LoadDebugData(d);
      if not ExecSc.LoadData(bytext) then
      begin
        ShowMessage('[Error] : Could not load data: '+TIFErrorToString(ExecSc.ExceptionCode, ExecSc.ExceptionString));
        tag := 0;
        exit;
      end;
      self.RegisterObjectInForm(listApp);
       SetVariantToClass(ExecSc.GetVarNo(ExecSc.GetVar('APPLICATION')), Application);
      ExecSc.RunScript;
      if assigned(finitialProg) then initialProg;
      if ExecSc.ExceptionCode <> erNoError then
        sHOWmESSAGE('[Runtime Error] : ' + TIFErrorToString(ExecSc.ExceptionCode, ExecSc.ExceptionString) +
          ' in ' + IntToStr(ExecSc.ExceptionProcNo) + ' at ' + IntToSTr(ExecSc.ExceptionPos));
    finally
     // tag := 0;
     // x2.Free;
end;
end;
procedure TApplicationImmi.RegisterObjectInForm(ListForm: TList);
var i,j: Integer;
    fn,fc: string;
    formd: TForm;
begin
  if (ListForm=nil) or (ExecSc=nil) then exit;

   for i:=0 to ListForm.Count-1 do
    begin
      if tobject(ListForm.items[i]) is TForm then
     begin
     formd:=TForm(ListForm.items[i]);
     fn:=formd.Name;
    // fc:=formd.Caption;
     SetVariantToClass(ExecSc.GetVarNo(ExecSc.GetVar(trim(fn))), formd);
  //   if fn='_13' then
       for j:=0 to formd.ComponentCount-1 do
            begin
            SetVariantToClass(ExecSc.GetVarNo(ExecSc.GetVar(UpperCase(fn+'->'+trim(formd.components[j].Name)))), formd.components[j]);
            ghstr:=fn+'.'+formd.components[j].Name;
            ghstr:=formd.components[j].classname;
            end;
     end else
     begin
           SetVariantToClass(ExecSc.GetVarNo(ExecSc.GetVar(UpperCase(TComponent(ListForm.items[i]).Name))), TComponent(ListForm.items[i]));
     end;
    end;
end;



function GetstringByMetod(TypeData: PTypeData): string;
var strPr: string;
 P: PChar;
  I,j: Integer;
//  l: mAlParamList;
  strnam: string;
  strtype: string;
begin
  result:='';
  P := @TypeData^.ParamList;
  if TypeData^.ParamCount>0 then result:='(';
  for I := 1 to TypeData^.ParamCount do
  begin
   // Inc(P, 1 + Byte(P[1]) + 1);
    strnam:='';
    strtype:='';
   if pfVar in TParamFlags(p[0])  then result:=result+'var ' else
     if pfConst in TParamFlags(p[0])  then result:=result+'const ' else
        if pfOut in TParamFlags(p[0])  then result:=result+'out ';
    for j:=2 to 2+Byte(P[1])-1 do
      strnam:=strnam+char(p[j]);
    result:=result+strnam+': ';
    Inc(P, 1 + Byte(P[1])+1);
    for j:=1 to 2+Byte(P[0])-2 do
      strtype:=strtype+char(p[j]);
    result:=result+strtype;
    if i<>TypeData^.ParamCount then result:=result+'; '
      else result:=result+')';
    Inc(P, Byte(P[0]) + 1 );
  end;
end;



procedure TApplicationImmi.StopExe;
begin
 if  not fcompilePrepare then exit;
 if assigned(ffinalProg) then finalProg;
 if ExecSc<>nil  then ExecSc.Stop;
end;


procedure TApplicationImmi.AfterConst;
begin
self.fSysSc.Clear;
self.fTypeList.Clear;
MainCompilerigistration.ListForm:=self.listApp;
MainCompilerigistration.classlistApp:=fclasslistApp;
ifps_maincompile.tcom:=self;
GettyprList(self.fTypeList,self.fSyssc);
end;

function TApplicationImmi.findUnicVar: string;
var i: integer;
begin
  result:='';
  i:=1;
  while findVar('newvar'+inttostr(i))>-1 do inc(i);
  result:='newvar'+inttostr(i);
end;



function TApplicationImmi.findVar(varname: string): integer;
  function GetName(val: string): string;
    begin
      result:='';
      if pos(':',val)<>0 then
      result:=trim(copy(val,1,pos(':',val)-1));
    end;
var i: integer;
begin
  result:=-1;
  for i:=0 to self.variableList.Count-1 do
    begin
    if uppercase(trim(GetName(self.variableList.Strings[i])))=uppercase(trim(varname)) then
      begin
         result:=i;
         exit;
      end;
    end;
end;

function  TApplicationImmi.getclasslistApp: TList;
begin
result:= fclasslistApp;
end;

procedure TApplicationImmi.setclassListApp(val: TList);
var i: integer;
begin
fclasslistApp.clear;
if val<>nil then
for i:=0 to val.Count-1 do
 if fclasslistApp.IndexOf(val.items[i])<0 then
   fclasslistApp.Add(val.items[i]);
 if fclasslistApp.IndexOf(self.ClassType)<0 then  fclasslistApp.Add(self.ClassType);
end;

function TApplicationImmi.GetlistApp: TList;
begin
  result:=flistApp;
end;

procedure addmethSys(catalog: TstringList; decl: string; hint: string; methname: string; typ: integer);
var newDecl: TSysscriptDecl;
begin
   newDecl:=TSysscriptDecl.Create(nil);
   newDecl.decl:=decl;
   newDecl.hint:=hint;
   newDecl.typ:=typ;
   newDecl.MethName:=methname;
   catalog.AddObject(methname,newDecl)
end;


procedure GettyPrList(valT :TStringList; valP: TStringList);
var  x1: TIFPSPascalCompiler;
     i: integer;
begin
 // if val=nil then exit;
  valT.clear;
   valP.clear;
  try
   x1:=TIFPSPascalCompiler.Create;
   x1.OnUses := MainCompilerigistration.MyOnUses;
   x1.OnExternalProc := DllExternalProc;
   x1.MainDef;
   for i:=0 to x1.FAvailableTypes.Count-1  do
     if PIFPSType(x1.FAvailableTypes.GetItem(i))^.Name<>'' then
        valT.Add(PIFPSType(x1.FAvailableTypes.GetItem(i))^.Name);
   for i:=0 to x1.FRegProcs.Count-1  do
     begin
       addmethSys(valP, PIFPSRegProc(x1.FRegProcs.GetItem(i))^.decluse,
       PIFPSRegProc(x1.FRegProcs.GetItem(i))^.comment,PIFPSRegProc(x1.FRegProcs.GetItem(i))^.nameuse,
       PIFPSRegProc(x1.FRegProcs.GetItem(i))^.TypeF);
     end;
  except
  end;
  if x1<>nil then x1.Free;
end;





initialization
  Imp := TIFPSRuntimeClassImporter.Create;
  RIRegister_Std(Imp);
  RIRegister_Classes(Imp);
  RIRegister_Graphics(Imp);
  RIRegister_Controls(Imp);
  RIRegister_stdctrls(imp);
  RIRegister_Forms(Imp);
finalization
  Imp.Free;
end.
 