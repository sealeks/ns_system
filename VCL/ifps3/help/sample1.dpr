program sample1;

uses
  ifpscomp,
  ifps3,
  ifps3lib_std,
  ifps3lib_stdr;

function ScriptOnUses(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
{ the OnUses callback function is called for each "uses" in the script. 
  It's always called with the parameter 'SYSTEM' at the top of the script. 
  For example: uses ii1, ii2;   
  This will call this function 3 times. First with 'SYSTEM' then 'II1' and then 'II2'.
}
begin
  if Name = 'SYSTEM' then
  begin
    RegisterStandardLibrary_C(Sender);
    { Register the standard library. The standard library is in the 
      ifps3lib_std.pas unit. This will register all standard functions like
      Copy, Pos, Length.
    }
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

  Exec := TIFPSExec.Create;  // Create an instance of the executer.
  RegisterStandardLibrary_R(Exec);
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

  Exec.RunScript; // Run the script.
  Exec.Free; // Free the executer.
end;

const
  Script = 'var s: string; begin s := ''Test''; S := s + ''ing;''; end.';

begin
  ExecuteScript(Script);
end.
