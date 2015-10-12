unit MainCompilerigistration;

interface
   uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ifps3utl, ifpscomp, ifps3, Menus, ifps3lib_std,
  ifps3lib_stdr, ifps3common;
  function MyOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
  var
     ListForm: TList;
     classlistApp: TList;
     ghstr: string;
implementation
uses
  ifps3test2, ifps3disasm, ifpidelphi, ifpidll2, ifpidll2runtime, ifps3debug,
  ifpiclass, ifpiclassruntime, ifpiir_std, ifpii_std, ifpiir_stdctrls, ifpii_stdctrls,
  ifpiir_forms, ifpii_forms, ifpidelphiruntime,

  ifpii_graphics,
  ifpii_controls,
  ifpii_classes,
  ifpiir_graphics,
  ifpiir_controls,
  ifpiir_classes,
  AppImmi;

function MyOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
var
  cl: TIFPSCompileTimeClassesImporter;
  i,j: Integer;
  fn,fc: string;
  formd: TForm;

begin
  if Name = 'SYSTEM' then
  begin

    Sender.AddConstantN('NaN', 'extended')^.Value.Value := transExtendedtoStr(0.0 / 0.0);
    Sender.AddConstantN('Infinity', 'extended')^.Value.Value := transExtendedtoStr(1.0 / 0.0);
    Sender.AddConstantN('NegInfinity', 'extended')^.Value.Value := transExtendedtoStr(- 1.0 / 0.0);
    sender.AddTypeS('TExprStr','STRING');
   // sender.AddType('TShiftState','INTEGER');
    sender.FindType('TPoint');
    sender.AddTypeS('TEprValueNotyfy', 'procedure (Value: double)');
    sender.AddTypeS('TEprBoolNotyfy', 'procedure (State: boolean; BlinkState: boolean)');
    sender.AddTypeS('TUltrasimpleNotyfy', 'procedure ');
    sender.AddTypeS('TCaption','STRING');
    sender.AddTypeS('TDateTime','double');
    sender.AddTypeS('TSiftState','integer');
    cl := TIFPSCompileTimeClassesImporter.Create(Sender, True);
    SIRegister_Std(Cl);
    SIRegister_Classes(Cl);
    SIRegister_Graphics(Cl);
    SIRegister_Controls(Cl);
    SIRegister_stdctrls(Cl);
    SIRegister_Forms(Cl);
    for i:=0 to classlistApp.count-1 do
    if TClass(classlistApp.Items[i]).InheritsFrom(Tcontrol) then
    SIRegisterFreeClass(Cl,TClass(classlistApp.Items[i]),TControl)
    else SIRegisterFreeClass(Cl,TClass(classlistApp.Items[i]),TComponent);
    AddImportedClassVariable(Sender, 'Application', 'TApplication');
    if (ListForm=nil){ or (X2=nil) }then exit;
    for i:=0 to ListForm.Count-1 do
     begin
     if tobject(ListForm.items[i]) is TForm then
       begin
         formd:=TForm(ListForm.items[i]);
         fn:=formd.Name;
         fc:=formd.Caption;
         AddImportedClassVariable(sender ,fn, formd.classname);
         for j:=0 to formd.ComponentCount-1 do
            begin
            AddImportedClassVariable(sender, trim(fn+'->'+formd.components[j].Name), formd.components[j].classname);
            ghstr:=fn+'.'+formd.components[j].Name;
            ghstr:=formd.components[j].classname;
            end;
        end
      else
        begin
         AddImportedClassVariable(sender ,tcomponent(ListForm.items[i]).Name, tcomponent(ListForm.items[i]).ClassName);
        end;
     end;
    RegisterStandardLibrary_C(Sender);
    Result := True;
    RegisterDelphiFunctionC(Sender, 'procedure InitExpr(expr: string);','',5);
    RegisterDelphiFunctionC(Sender, 'procedure UnInitExpr(expr: string);','',5);
    RegisterDelphiFunctionC(Sender, 'procedure setCommandOn(tag: string);','',5);
    RegisterDelphiFunctionC(Sender, 'procedure setCommandOff(tag: string);','',5);
    RegisterDelphiFunctionC(Sender, 'procedure setCommandValue(tag: string; value: double);','',5);
    RegisterDelphiFunctionC(Sender, 'procedure setValue(tag: string; value:  double);','',5);
    RegisterDelphiFunctionC(Sender, 'function GetBoolExpr(Expr: string): boolean;','',5);
    RegisterDelphiFunctionC(Sender, 'function GetValExpr(Expr: string): double;','',5);

    RegisterDelphiFunctionC(Sender, 'procedure OpenForm(form: TForm; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure ShowModalForm(form: TForm; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure SimpleOpenForm(form: TForm; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure HideForm(form: TForm; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure OpenFormByName(caption: string; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure ShowModalFormByName(caption: string; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure SimpleOpenFormByName(caption: string; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'procedure HideFormByName(caption: string; left: integer;top: integer);','',11);
    RegisterDelphiFunctionC(Sender, 'function NowI: TDatetime;','',12);
    RegisterDelphiFunctionC(Sender, 'function TimeI: TDatetime;','',12);
    RegisterDelphiFunctionC(Sender, 'function DateI: TDatetime;','',12);
    RegisterDelphiFunctionC(Sender, 'procedure ExecWin(programPath: string; programName: string);','',10);
    RegisterDelphiFunctionC(Sender, 'procedure beepWin(freq: longint; duration: longint);','',10);
    RegisterDelphiFunctionC(Sender, 'procedure PlaySoundWin(name: string; value: boolean);','',10);
  end
  else
  begin
    TIFPSPascalCompiler(Sender).MakeError('', ecUnknownIdentifier, '');
    Result := False;
  end;
end;



end.
