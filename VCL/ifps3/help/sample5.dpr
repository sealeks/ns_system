program sample5;

uses
  ifpscomp,
  ifps3,
  ifps3lib_std,
  ifps3lib_stdr,
  ifpiclass,
  ifpiclassruntime,
  ifpii_std,
  ifpii_controls,
  ifpii_stdctrls,
  ifpii_forms,
  ifpiir_std,
  ifpiir_controls,
  ifpiir_stdctrls,
  ifpiir_forms,
  forms

  ;

function ScriptOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
{ the OnUses callback function is called for each "uses" in the script. 
  It's always called with the parameter 'SYSTEM' at the top of the script. 
  For example: uses ii1, ii2;   
  This will call this function 3 times. First with 'SYSTEM' then 'II1' and then 'II2'.
}
var
  CI: TIFPSCompileTimeClassesImporter; // can be found in ifpiclass.pas unit.
begin
  if Name = 'SYSTEM' then
  begin
    RegisterStandardLibrary_C(Sender);
    { Register the standard library. The standard library is in the 
      ifps3lib_std.pas unit. This will register all standard functions like 
      Copy, Pos, Length.
    }

    CI := TIFPSCompileTimeClassesImporter.Create(Sender, True);
    { Create an instance of the class importer. The first parameter is the script engine. The second parameter is the 
      auto-free parameter, since it's true, there is no need to free the library. }

    SIRegister_Std(CI);  
    { This will register the declarations of these classes:
      TObject, TPersisent. This can be found
      in the ifpii_std.pas unit. }
    SIRegister_Controls(CI);
    { This will register the declarations of these classes:
      TControl, TWinControl, TFont, TStrings, TStringList, TGraphicControl. This can be found
      in the ifpii_controls.pas unit. }

    SIRegister_Forms(CI);
    { This will register: TScrollingWinControl, TCustomForm, TForm and TApplication. ifpii_forms.pas unit. }
  
    SIRegister_stdctrls(CI);
     { This will register: TButtonContol, TButton, TCustomCheckbox, TCheckBox, TCustomEdit, TEdit, TCustomMemo, TMemo,
      TCustomLabel and TLabel. Can be found in the ifpii_stdctrls.pas unit. }
    
    AddImportedClassVariable(Sender, 'Application', 'TApplication');
    // Registers the application variable to the script engine.

    Result := True;
  end else
    Result := False;
end;

procedure ExecuteScript(const Script: string);
var
  Compiler: TIFPSPascalCompiler;
  { TIFPSPascalCompiler is the compiler part of the scriptengine. This will 
    translate a Pascal script into a compiled for the executer understands. } 
  Exec: TIFPSExec;
   { TIFPSExec is the executer part of the scriptengine. It uses the output of
    the compiler to run a script. }
  Data: string;
  CI: TIFPSRuntimeClassImporter; // Can be found in the ifpiclassruntime.pas unit.
begin
  Compiler := TIFPSPascalCompiler.Create; // create an instance of the compiler.
  Compiler.OnUses := ScriptOnUses; // assign the OnUses event.
  if not Compiler.Compile(Script) then  // Compile the Pascal script into bytecode.
  begin
    Compiler.Free;
     // You could raise an exception here.
    Exit;
  end;

  Compiler.GetOutput(Data); // Save the output of the compiler in the string Data.
  Compiler.Free; // After compiling the script, there is no need for the compiler anymore.

  CI := TIFPSRuntimeClassImporter.Create;
  { Create an instance of the runtime class importer.}
  
  RIRegister_Std(CI);  // ifpiir_std.pas unit.
  RIRegister_Controls(CI); // ifpiir_controls.pas unti.
  RIRegister_stdctrls(CI);  // ifpiir_stdctrls.pas unit.
  RIRegister_Forms(CI);  // ifpiir_forms.pas unit.

  Exec := TIFPSExec.Create;  // Create an instance of the executer.
  RegisterStandardLibrary_R(Exec);

  RegisterClassLibraryRuntime(Exec, CI);
  // Assign the runtime class importer to the executer.
  
  { The functions registered at compile time also need to be registered at runtime. These
    functions can be found in the ifps3lib_stdr.pas unit. }
  if not  Exec.LoadData(Data) then // Load the data from the Data string.
  begin
    { For some reason the script could not be loaded. This is usually the case when a 
      library that has been used at compile time isn't registered at runtime. }
    Exec.Free;
     // You could raise an exception here.
    Exit;
  end;

  SetVariantToClass(Exec.GetVarNo(Exec.GetVar('APPLICATION')), Application);
   // This will set the script's Application variable to the real Application variable.

  Exec.RunScript; // Run the script.
  Exec.Free; // Free the executer.
  CI.Free;  // Free the runtime class importer. 
end;




const
  Script =
    'var f: TForm; i: Longint; begin f := TForm.CreateNew(f, 0); f.Show; while f.Visible do Application.ProcessMessages; F.free;  end.';

begin
  ExecuteScript(Script);
end.
