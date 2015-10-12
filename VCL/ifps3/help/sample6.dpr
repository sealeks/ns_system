program sample6;

uses
  ifpscomp,
  ifps3common,
  ifps3,
  ifps3utl,
  ifps3lib_std,
  ifps3lib_stdr,
  ifpidelphi,
  ifpidelphiruntime,

  Dialogs

  ;

procedure MyOwnFunction(const Data: string);
begin
  // Do something with Data
  ShowMessage(Data);
end;

function ScriptOnExportCheck(Sender: TIFPSPascalCompiler; Proc: PIFPSProcedure; const ProcDecl: string): Boolean;
{
  The OnExportCheck callback function is called for each function in the script
  (Also for the main proc, with '!MAIN' as a Proc^.Name). ProcDecl contains the
  result type and parameter types of a function using this format:
  ProcDecl: ResultType + ' ' + Parameter1 + ' ' + Parameter2 + ' '+Parameter3 + .....
  Parameter: ParameterType+TypeName
  ParameterType is @ for a normal parameter and ! for a var parameter.
  A result type of 0 means no result.
}
begin
  if Proc^.Name = 'TEST' then // Check if the proc is the Test proc we want.
  begin
    if ProcDecl <> '0 @STRING' then // Check if the proc has the correct params.
    begin
      { Something is wrong, so cause an error at the declaration position of the proc. }
      Sender.MakeError('', ecTypeMismatch, '')^.Position := Proc^.DeclarePosition;
      Result := False;
      Exit;
    end;
    Proc^.FExport := 1;
    { Export the proc; This is needed because IFPS doesn't store the name of a
      function by default }
    Result := True;
  end else Result := True;
end;

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

    RegisterDelphiFunctionC(Sender, 'procedure MyOwnFunction(Data: string)');
    { This will register the function to the script engine. Now it can be used from within the script. When adding
      functions always leave the const out, this is not yet supported but doesn't make a change. This function can be
      found in the ifpidelphi.pas file. }

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

  N: PIfVariant;
  { The variant in which we are going to store the parameter }
  ParamList: TIfList;
  { The parameter list}
begin
  Compiler := TIFPSPascalCompiler.Create; // create an instance of the compiler.
  Compiler.OnUses := ScriptOnUses; // assign the OnUses event.

  Compiler.OnExportCheck := ScriptOnExportCheck; // Assign the onExportCheck event.

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

  RegisterDelphiFunctionR(Exec, @MyOwnFunction, 'MYOWNFUNCTION', cdRegister);
  { This will register the function to the executer. The first parameter is the executer. The second parameter is a 
    pointer to the function. The third parameter is the name of the function (in uppercase). And the last parameter is the
    calling convention (usually Register). This function can be found in the ifpidelphiruntime.pas file. }

  if not Exec.LoadData(Data) then // Load the data from the Data string.
  begin
    { For some reason the script could not be loaded. This is usually the case when a 
      library that has been used at compile time isn't registered at runtime. }
    Exec.Free;
     // You could raise an exception here.
    Exit;
  end;

  ParamList := TIfList.Create; // Create the parameter list

  N := CreateVariant(Exec.MemoryManager, Exec.FindType2(btString));
  { Create a variant for the string parameter }
  if n = nil then
  begin
    { Something is wrong. Exit here }
    ParamList.Free;
    Exec.Free;
    Exit;
  end;

  tbtstring(n^.tstring) := 'Test Parameter!';
  // Put something in the string parameter.

  ParamList.Add(n); // Add it to the parameter list.

  Exec.RunProc(ParamList, Exec.GetProc('TEST'));
  { This will call the test proc that was exported before }

  FreePIFVariantList(Exec.MemoryManager, ParamList); // Cleanup the parameters (This will also free N)

  Exec.Free; // Free the executer.
end;



const
  Script = 'procedure test(s: string); begin MyOwnFunction(''Test is called: ''+s);end; begin end.';

begin
  ExecuteScript(Script);
end.
