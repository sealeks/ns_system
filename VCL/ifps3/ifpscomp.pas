{ifpscomp is the compiler part of the script engine}
unit ifpscomp;
{

Innerfuse Pascal Script III
Copyright (C) 2000-2002 by Carlo Kok (ck@carlo-kok.com)

Features:

  - Constants
  - Variables
  - Procedures/Functions
  - Procedural Variables
  - If, While, Repeat, For, Case
  - Break/Continue
  - External/Integer Procedures/Functions
  - Arrays, Records
  - Ability to create compiled code that can be used later
  - Debugging Support
  - Importing Delphi Funtions and classes

}
{$I ifps3_def.inc}
interface
uses
  SysUtils, ifps3utl, ifps3common;
const
  {Internal constant: used when a value must be read from an address}
  CVAL_Addr = 0;
  {Internal constant: used when a value is plain data}
  CVAL_Data = 1;
  {Internal constant: used when a value must be read from an address and pushed}
  CVAL_PushAddr = 2;
  {Internal constant: used for function calls}
  CVAL_Proc = 3;
  {Internal constant: used when there are sub calculations}
  CVAL_Eval = 4;
  {Internal constant: same as address except that it has to be freed otherwise}
  CVAL_AllocatedStackReg = 5;
  {Internal constant: A method call}
  CVAL_ClassProcCall = 7;
  {Internal contant: A method call}
  CVAL_ClassMethodCall = 8;
  {Internal constant: Property set method}
  CVAL_ClassPropertyCallSet = 9;
  {Internal constant: Property get method}
  CVAL_ClassPropertyCallGet = 10;
  {Internal Constant: Procedural Call with variable procedure number}
  CVAL_VarProc = 11;
  {Internal Constant: Procedural Pointer}
  CVAL_VarProcPtr = 12;
  {Internal Constant: Array}
  CVAL_Array = 13;
  {Internal Constant: ArrayAllocatedStackRec same as @link(CVAL_AllocatedStackReg)}
  CVAL_ArrayAllocatedStackRec = 14;
  {Internal Constant: Nil}
  CVAL_Nil = 15;
  {Internal Constant; Casting}
  CVAL_Cast = 16;

type
  TIFPSPascalCompiler = class;
  {Internal type used to store the current block type}
  TSubOptType = (tMainBegin, tProcBegin, tSubBegin, tOneLiner, tifOneliner, tRepeat, tTry, tTryEnd);

  {TIFPSExternalClass is used when external classes need to be called}
  TIFPSExternalClass = class;

  PIFPSRegProc = ^TIFPSRegProc;
  {TIFPSRegProc is used to store the registered procs}
  TIFPSRegProc = record
    NameHash: Longint;
    Name, Decl: string;
    FExportName: Boolean;
    ImportDecl: string; // used for dlls
    Comment: string;
    nameUse: string;
    declUse: string;
    typeF: shortint;
  end;
  {The compile time variant}
  PIfRVariant = ^TIfRVariant;
  {The compile time variant}
  TIfRVariant = record
    FType: Cardinal;
    Value: string;
  end;
  {PIFPSRecordType is is used to store records}
  PIFPSRecordType = ^TIFPSRecordType;
  {TIFPSRecordType is is used to store records}
  TIFPSRecordType = record
    FieldNameHash: Longint;
    FieldName: string;
    RealFieldOffset: Cardinal;
    FType: Cardinal;
  end;
  {PIFPSProceduralType is a pointer to @link(TIFPSProceduralType)}
  PIFPSProceduralType = ^TIFPSProceduralType;
  {TIFPSProceduralType contains information to store procedural variables}
  TIFPSProceduralType = record
    ProcDef: string;
  end;
  {PIFPSType is a pointer to a @link(TIFPSType) record}
  PIFPSType = ^TIFPSType;
  {TIFPSType contains a type definition}
  TIFPSType = record
    NameHash: Longint;
    Name: string;
   // nameuse: string;
    BaseType: TIFPSBaseType;
    DeclarePosition: Cardinal;
    Used: Boolean;
    TypeSize: Cardinal;
    RecordSubVals: TIfList;
    FExport: Boolean;
    case byte of
      0: (Ext: Pointer);
      1: (Ex: TIFPSExternalClass);
  end;
  {@link(TIFPSProcVar)
  PIFPSProcVar is a pointer to a TIFPSProcVar record}
  PIFPSProcVar = ^TIFPSProcVar;
  {TIFPSProcVar is used to store procedural variables}
  TIFPSProcVar = record
    NameHash: Longint;
    VarName: string;
    VarType: Cardinal; // only for calculation types
    Used, CurrentlyUsed: Boolean;
    DeclarePosition: Cardinal;
  end;
  {PIFPSUsedRegProc is a pointer to an TIFPSUsedRegProc}
  PIFPSUsedRegProc = ^TIFPSUsedRegProc;
  {TIFPSUsedRegProc is used to store used registered procs}
  TIFPSUsedRegProc = record
    Internal: Boolean; { false }
    RP: PIFPSRegProc;
  end;
  {PIFPSProcedure is a pointer to a TIFPSProcedure}
  PIFPSProcedure = ^TIFPSProcedure;
  {TIFPSProcdure is used to store information about a procedure}
  TIFPSProcedure = record
    Internal: Boolean; { true }
    Forwarded: Boolean;
    Data: string;
    NameHash: Longint;
    Decl, Name: string;
    {Decl: [RESULTTYPE] [PARAM1NAME] [PARAM1TYPE] [PARAM2NAME] ... }
    { @ = Normal Parameter  ! = Var parameter `}
    ProcVars: TIfList;
    Used: Boolean;
    DeclarePosition: Cardinal;
    OutputDeclPosition: Cardinal;
    ResUsed: Boolean;
    FExport: Byte; {1 = yes; 2 = also decl}
    FLabels: TIfStringList; // mi2s(position)+mi2s(namehash)+name   [position=$FFFFFFFF means position unknown]
    FGotos: TIfStringList;  // mi2s(position)+mi2s(destinationnamehash)+destinationname
  end;
  {PIFPSVar is a pointer to a TIFPSVar record}
  PIFPSVar = ^TIFPSVar;
  {TIFPSVar is used to store global variables}
  TIFPSVar = record
    NameHash: Longint;
    Name: string;
    FType: Cardinal;
    Used: Boolean;
    DeclarePosition: Cardinal;
    exportname: string;
  end;
  {PIFPSContant is a pointer to a TIFPSConstant}
  PIFPSConstant = ^TIFPSConstant;
  {TIFPSContant contains a constant}
  TIFPSConstant = record
    NameHash: Longint;
    Name: string;
    Value: TIfRVariant;
  end;
  {Is used to store the type of a compiler error}
  TIFPSPascalCompilerError = (
    ecUnknownIdentifier,
    ecIdentifierExpected,
    ecCommentError,
    ecStringError,
    ecCharError,
    ecSyntaxError,
    ecUnexpectedEndOfFile,
    ecSemicolonExpected,
    ecBeginExpected,
    ecPeriodExpected,
    ecDuplicateIdentifier,
    ecColonExpected,
    ecUnknownType,
    ecCloseRoundExpected,
    ecTypeMismatch,
    ecInternalError,
    ecAssignmentExpected,
    ecThenExpected,
    ecDoExpected,
    ecNoResult,
    ecOpenRoundExpected,
    ecCommaExpected,
    ecToExpected,
    ecIsExpected,
    ecOfExpected,
    ecCloseBlockExpected,
    ecVariableExpected,
    ecStringExpected,
    ecEndExpected,
    ecUnSetLabel,
    ecNotInLoop,
    ecInvalidJump,
    ecOpenBlockExpected,
    ecWriteOnlyProperty,
    ecReadOnlyProperty,
    ecClassTypeExpected,
    ecCustomError,
    ecDivideByZero,
    ecMathError,
    ecUnsatisfiedForward

    );
  {Used to store the type of a hint}
  TIFPSPascalCompilerHint = (
    ehVariableNotUsed, {param = variable name}
    ehFunctionNotUsed, {param = function name}
    ehCustomHint
    );
  {Is used to store the type of a warning}
  TIFPSPascalCompilerWarning = (
    ewCalculationAlwaysEvaluatesTo,
    ewIsNotNeeded,
    ewCustomWarning
  );
  {Is used to store the type of the messages}
  TIFPSPascalCompilerMessageType = (ptWarning, ptError, ptHint);
  {Contains a pointer to an TIFPSPascalCompilerMessages record}
  PIFPSPascalCompilerMessage = ^TIFPSPascalCompilerMessage;
  {Contains compiler messages}
  TIFPSPascalCompilerMessage = packed record

    ModuleName: string;
    Param: string;
    Position: Cardinal;
    MessageType: TIFPSPascalCompilerMessageType;
    case TIFPSPascalCompilerMessageType of
      ptError: (Error: TIFPSPascalCompilerError);
      ptWarning: (Warning: TIFPSPascalCompilerWarning);
      ptHint: (Hint: TIFPSPascalCompilerHint);
  end;

  {See TIFPSPascalCompiler.OnUseVariable}
  TIFPSOnUseVariable = procedure (Sender: TIFPSPascalCompiler; VarType: TIFPSVariableType; VarNo: Longint; ProcNo, Position: Cardinal);
  {See TIFPSPascalCompiler.OnUses}
  TIFPSOnUses = function(Sender: TIFPSPascalCompiler; const Name: string): Boolean;
  {See TIFPSPascalCompiler.OnExportCheck}
  TIFPSOnExportCheck = function(Sender: TIFPSPascalCompiler; Proc: PIFPSProcedure; const ProcDecl: string): Boolean;
  {See TIFPSPascalCompiler.OnWriteLine}
  TIFPSOnWriteLineEvent = function (Sender: TIFPSPascalCompiler; Position: Cardinal): Boolean;
  {See TIFPSPascalCompiler.OnExternalProc}
  TIFPSOnExternalProc = function (Sender: TIFPSPascalCompiler; const Name, Decl, FExternal: string): PIFPSRegProc;
  TIFPSPascalCompiler = class
  protected
    FID: Pointer;
    FOnExportCheck: TIFPSOnExportCheck;
    FBooleanType: Cardinal;


    FUsedTypes: TIfList;

    FOutput: string;
    FParser: TIfPascalParser;
    FMessages: TIfList;
    FOnUses: TIFPSOnUses;
    FIsUnit: Boolean;
    FAllowNoBegin: Boolean;
    FAllowNoEnd: Boolean;
    FAllowUnit: Boolean;
    FDebugOutput: string;
    FOnExternalProc: TIFPSOnExternalProc;
    FOnUseVariable: TIFPSOnUseVariable;
    FOnWriteLine: TIFPSOnWriteLineEvent;
    FContinueOffsets, FBreakOffsets: TIfList;
    FAutoFreeList: TIfList;
    function GetType(BaseType: TIFPSBaseType): Cardinal;
    function GetMsgCount: Longint;
    function MakeDecl(decl: string): string;
    function MakeExportDecl(decl: string): string;
    function GetMsg(l: Longint): PIFPSPascalCompilerMessage;
    procedure DefineStandardTypes;
    procedure UpdateRecordFields(r: Pointer);
    function GetTypeCopyLink(p: PIFPSType): PIFPSType;
    function IsIntBoolType(FTypeNo: Cardinal): Boolean;
    function GetUInt(FUseTypes: TIFList; Src: PIfRVariant; var s: Boolean): Cardinal;
    function GetInt(FUseTypes: TIFList; Src: PIfRVariant; var s: Boolean): Longint;
    function GetReal(FUseTypes: TIFList; Src: PIfRVariant; var s: Boolean): Extended;
    function GetString(FUseTypes: TIFList; Src: PIfRVariant; var s: Boolean): string;
    function PreCalc(FUseTypes: TIFList; Var1Mod: Byte; var1: PIFRVariant; Var2Mod: Byte;
      Var2: PIfRVariant; Cmd: Byte; Pos: Cardinal): Boolean;
    function ReadConstant(StopOn: TIfPasToken): PIfRVariant;
    procedure WriteDebugData(const s: string);
    function ProcessFunction: Boolean;
    function IsDuplicate(const s: string): Boolean;
    function DoVarBlock(proc: PIFPSProcedure): Boolean;
    function DoTypeBlock(FParser: TIfPascalParser): Boolean;
    function ReadType(const Name: string; FParser: TIfPascalParser): Cardinal;
    function NewProc(const Name: string): PIFPSProcedure;
    function ProcessLabel(Proc: PIFPSProcedure): Boolean;
    procedure Debug_SavePosition(ProcNo: Cardinal; Proc: PIFPSProcedure);
    procedure Debug_WriteParams(ProcNo: Cardinal; Proc: PIFPSProcedure);
    function ProcessSub(FType: TSubOptType; ProcNo: Cardinal;
      proc: PIFPSProcedure): Boolean;
    function ProcessLabelForwards(Proc: PIFPSProcedure): Boolean;

    procedure ReplaceTypes(var s: string);
    function AT2UT(L: Cardinal): Cardinal;
    function GetUsedType(No: Cardinal): PIFPSType;
    function GetAvailableType(No: Cardinal): PIFPSType;
    function GetUsedTypeCount: Cardinal;
    function GetAvailableTypeCount: Cardinal;
    function UseAvailableType(No: Cardinal): Cardinal;
    function GetProc(No: Cardinal): PIFPSProcedure;
    function GetProcCount: Cardinal;
    function GetVariableCount: Cardinal;
    function GetVariable(No: Cardinal): PIFPSVar;

    function AddUsedFunction(var Proc: PIFPSProcedure): Cardinal;
    function AddUsedFunction2(var Proc: PIFPSUsedRegProc): Cardinal;
    function CheckCompatProc(FTypeNo, ProcNo: Cardinal): Boolean;
    procedure ParserError(Parser: TObject; Kind: TIFParserErrorKind; Position: Cardinal);
  public
     FVars: TIfList;
     FAvailableTypes: TIfList;
     FRegProcs: TIfList;
     FConstants: TIFList;
     FProcs: TIfList;
    {Add an object to the auto-free list}
    procedure AddToFreeList(Obj: TObject);
   function MainDef: Boolean;
    {Tag}
    property ID: Pointer read FID write FID;
    {Add an error the messages}
    function MakeError(const Module: string; E: TIFPSPascalCompilerError; const
      Param: string): PIFPSPascalCompilerMessage;
    {Add a warning to the messages}
    function MakeWarning(const Module: string; E: TIFPSPascalCompilerWarning;
      const Param: string): PIFPSPascalCompilerMessage;
    {Add a hint to the messages}
    function MakeHint(const Module: string; E: TIFPSPascalCompilerHint;
      const Param: string): PIFPSPascalCompilerMessage;
    {Add a function}
    function AddFunction(const Header: string; comment:  string; typeF:shortint): PIFPSRegProc;
    {add a type}
    function AddType(const Name: string; const BaseType: TIFPSBaseType): PIFPSType;
    {Add a type declared in a string}
    function AddTypeS(const Name, Decl: string): PIFPSType;
    {Add a type copy type}
    function AddTypeCopy(const Name: string; TypeNo: Cardinal): PIFPSType;
    {Add a type copy type}
    function AddTypeCopyN(const Name, FType: string): PIFPSType;
    {Add a constant}
    function AddConstant(const Name: string; FType: Cardinal): PIFPSConstant;
    {Add a constant}
    function AddConstantN(const Name, FType: string): PIFPSConstant;
    {Add a variable}
    function AddVariable(const Name: string; FType: Cardinal): PIFPSVar;
    {Add a variable}
    function AddVariableN(const Name, FType: string): PIFPSVar;
    {Add an used variable}
    function AddUsedVariable(const Name: string; FType: Cardinal): PIFPSVar;
    {add an used variable (with named type)}
    function AddUsedVariableN(const Name, FType: string): PIFPSVar;
    {Add a variable and export it}
    function AddExportVariableN(const Name, FType: string): PIFPSVar;
    {Add an used variable and export it}
    function AddUsedExportVariableN(const Name, FType: string): PIFPSVar;
    {Search for a type}
    function FindType(const Name: string): Cardinal;
    {Compile a script (s)}
    function Compile(const s: string): Boolean;
    {Return the output}
    function GetOutput(var s: string): Boolean;
	{Return the debugger output}
    function GetDebugOutput(var s: string): Boolean;
    {Clear the current data}
    procedure Clear;
    {Create}
    constructor Create;
	{Destroy the current instance of the script compiler}
    destructor Destroy; override;
    {contains the number of messages}
    property MsgCount: Longint read GetMsgCount;
	{The messages/warnings/errors}
    property Msg[l: Longint]: PIFPSPascalCompilerMessage read GetMsg;
    {OnUses i scalled for each Uses and always first with 'SYSTEM' parameters}
    property OnUses: TIFPSOnUses read FOnUses write FOnUses;
	{OnExportCheck is called for each function to check if it needs to be exported and has the correct parameters}
    property OnExportCheck: TIFPSOnExportCheck read FOnExportCheck write FOnExportCheck;
	{OnWriteLine is called after each line}
    property OnWriteLine: TIFPSOnWriteLineEvent read FOnWriteLine write FOnWriteLine;
	{OnExternalProc is called when an external token is found after a procedure header}
    property OnExternalProc: TIFPSOnExternalProc read FOnExternalProc write FOnExternalProc;
	{The OnUseVariant event is called when a variable is used by the script engine}
    property OnUseVariable: TIFPSOnUseVariable read FOnUseVariable write FOnUseVariable;
	{contains true if the current file is a unit}
    property IsUnit: Boolean read FIsUnit;
	{Allow no main begin/end}
    property AllowNoBegin: Boolean read FAllowNoBegin write FAllowNoBegin;
	{Allow a unit instead of program}
    property AllowUnit: Boolean read FAllowUnit write FAllowUnit;
	{Allow it to have no END on the script (only works when AllowNoBegin is true)}
    property AllowNoEnd: Boolean read FAllowNoEnd write FAllowNoEnd;
  end;
  {Pointer to @link(TIFPSValue) type}
  PIFPSValue = ^TIFPSValue;
  {Type containing types}
  TIFPSValue = packed record
    FType: Byte;
    Modifiers: byte;
    {
      1 = not
      2 = minus
      4 = ignore types (casting)
      8 = override type
      128 = don't free
    }
    FNewTypeNo: Cardinal;
    DPos: Cardinal;
    case Byte of
      CVAL_Nil: ();
      CVAL_Addr: (Address: Cardinal; RecField: TIfList); {i/o}
      CVAL_Data: (FData: PIfRVariant); {i}
      CVAL_PushAddr: (Address_: Cardinal; RecField__: TIfList);
      CVAL_Proc: (Parameters: TIfList; ProcNo: Cardinal);
      CVAL_VarProc: (_Parameters: TIfList; _ProcNo: PIFPSValue);
      CVAL_Eval: (SubItems: TIfList; frestype: Cardinal);
      CVAL_ClassPropertyCallGet,
      CVAL_ClassPropertyCallSet,
      CVAL_ClassMethodCall,
      CVAL_ClassProcCall: (Self: PIFPSValue; ClassProcNo: Cardinal; Params: TIfList);
      CVAL_Array: (ArrayItems: TIfList);
      CVAL_VarProcPtr: (VProcNo: Cardinal);
      CVAL_Cast: (NewTypeNo: Cardinal; Input: PIFPSValue);
  end;
  {Internal type: PCalc_Item}
  PCalc_Item = ^TCalc_Item;
  {Internal type: TCalc_Item}
  TCalc_Item = packed record
    C: Boolean;
    case Boolean of
      False: (OutRec: PIFPSValue);
      True: (calcCmd: Byte);
  end;
  {Internal type: PIFRecField}
  PIFRecField = ^TIFRecField;
  {Internal type: TIFRecField}
  TIFRecField = packed record
    FKind: Byte;
    FType: Cardinal;
    case Byte of
      0: (RecFieldNo: Cardinal);
      1: (ArrayFieldNo: Cardinal);
      2: (ReadArrayFieldNoFrom: PIFPSValue);
      3: (ResultRec: PIFPSValue);
  end;
  {TIFPSExternalClass is used when external classes need to be called}
  TIFPSExternalClass = class
  protected
    SE: TIFPSPascalCompiler;
  public
    {The type used as a class}
    function SelfType: Cardinal; virtual;
	{Create}
    constructor Create(Se: TIFPSPascalCompiler);
    {Find a class function}
    function ClassFunc_Find(const Name: string; var Index: Cardinal): Boolean; virtual;
	{Call a class function}
    function ClassFunc_Call(Index: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
    {Find a function}
    function Func_Find(const Name: string; var Index: Cardinal): Boolean; virtual;
	{Call a function}
    function Func_Call(Index: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
    {Find a variant}
    function Property_Find(const Name: string; var Index: Cardinal): Boolean; virtual;
	{Return the header of an variant}
    function Property_GetHeader(Index: Cardinal; var s: string): Boolean; virtual;
	{Get a variant value}
    function Property_Get(Index: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
	{Set a variant value}
    function Property_Set(Index: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
    {Check if the class is compatible}
    function IsCompatibleWith(Cl: TIFPSExternalClass): Boolean; virtual;
    {Returns the ProcNo for setting a class variable to nil}
    function SetNil(TypeNo: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
    {Return the procno for casting}
    function CastToType(TypeNo, IntoType: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
    {Return the procno for comparing two classes}
    function CompareClass(OtherTypeNo: Cardinal; var ProcNo: Cardinal): Boolean; virtual;
  end;
{Convert a message to a string}
function IFPSMessageToString(x: PIFPSPascalCompilerMessage): string;
{Set the name of an exported variable}
procedure SetVarExportName(P: PIFPSVar; const ExpName: string);
{Transform a double to a string}
function TransDoubleToStr(D: Double): string;
{Transform a single to a string}
function TransSingleToStr(D: Single): string;
{Transform a extended to a string}
function TransExtendedToStr(D: Extended): string;
{Transform a longint to a string}
function TransLongintToStr(D: Longint): string;
{Transform a cardinal to a string}
function TransCardinalToStr(D: Cardinal): string;
{Transform a word to a string}
function TransWordToStr(D: Word): string;
{Transform a smallint to a string}
function TransSmallIntToStr(D: SmallInt): string;
{Transform a byte to a string}
function TransByteToStr(D: Byte): string;
{Transform a shortint to a string}
function TransShortIntToStr(D: ShortInt): string;


implementation

procedure SetVarExportName(P: PIFPSVar; const ExpName: string);
begin
  if p <> nil then
    p^.exportname := ExpName;
end;
function TIFPSPascalCompiler.GetType(BaseType: TIFPSBaseType): Cardinal;
var
  l: Longint;
  x: PIFPSType;
begin
  for l := 0 to FUsedTypes.Count - 1 do
  begin
    x := FUsedTypes.GetItem(l);
    if (x^.BaseType = BaseType) and (x^.Ext = nil) then
    begin
      Result := l;
      exit;
    end;
  end;
  for l := 0 to FAvailableTypes.Count - 1 do
  begin
    x := FAvailableTypes.GetItem(l);
    if (x^.BaseType = BaseType) and (x^.Ext = nil) then
    begin
      FUsedTypes.Add(x);
      Result := FUsedTypes.Count - 1;
      exit;
    end;
  end;
  New(x);
  x^.Name := '';
  x^.NameHash := MakeHash(x^.Name);
  x^.BaseType := BaseType;
  x^.TypeSize := 1;
  x^.DeclarePosition := Cardinal(-1);
  x^.Ext := nil;
  x^.Used := True;
  FAvailableTypes.Add(x);
  FUsedTypes.Add(x);
  Result := FUsedTypes.Count - 1;
end;

function TIFPSPascalCompiler.MakeDecl(decl: string): string;
var
  s: string;
  c: char;
begin
  s := grfw(decl);
  if s = '-1' then result := '0' else
  result := PIFPSType(FUsedTypes.GetItem(StrToInt(s)))^.Name;

  while length(decl) > 0 do
  begin
    s := grfw(decl);
    c := s[1];
    s := PIFPSType(FUsedTypes.GetItem(StrToInt(grfw(decl))))^.Name;
    result := result +' '+c+s;
  end;
end;


{ TIFPSPascalCompiler }

const
  BtTypeCopy = 255;
  btChar = 254;

function IFPSMessageToString(x: PIFPSPascalCompilerMessage): string;
begin
  case x^.MessageType of
    ptError:
      begin
        case x^.Error of
          ecUnknownIdentifier: Result := 'неизвестный идентификатор''' + x^.Param +
            '''';
          ecIdentifierExpected: Result := 'утерян иденификатор';
          ecCommentError: Result := 'Comment error';
          ecStringError: Result := 'String error';
          ecCharError: Result := 'Char error';
          ecSyntaxError: Result := 'Синтаксическая ошибка';
          ecUnexpectedEndOfFile: Result := 'Неожиданный конец файла';
          ecSemicolonExpected: Result := 'Semicolon ('';'') expected';
          ecBeginExpected: Result := 'утерян ''BEGIN'' ';
          ecPeriodExpected: Result := 'period (''.'') expected';
          ecDuplicateIdentifier: Result := 'Duplicate identifier ''' + x^.Param + '''';
          ecColonExpected: Result := 'colon ('':'') expected';
          ecUnknownType: Result := 'Не определен тип параметра ''' + x^.Param + '''';
          ecCloseRoundExpected: Result := 'Close round expected';
          ecTypeMismatch: Result := 'Type mismatch';
          ecInternalError: Result := 'Internal error (' + x^.Param + ')';
          ecAssignmentExpected: Result := 'Assignment expected';
          ecThenExpected: Result := 'утерян ''THEN'' ';
          ecDoExpected: Result := 'утерян ''DO''';
          ecNoResult: Result := 'Функция не вернула результат';
          ecOpenRoundExpected: Result := 'open round (''('')expected';
          ecCommaExpected: Result := 'comma ('','') expected';
          ecToExpected: Result := 'утерян ''TO''';
          ecIsExpected: Result := 'is (''='') expected';
          ecOfExpected: Result := 'утерян ''OF''';
          ecCloseBlockExpected: Result := 'Close block('']'') expected';
          ecVariableExpected: Result := 'ожидается переменная';
          ecStringExpected: result := 'ожидается строка';
          ecEndExpected: Result := 'утерян ''END''';
          ecUnSetLabel: Result := 'Label '''+x^.Param+''' not set';
          ecNotInLoop: Result := 'Not in a loop';
          ecInvalidJump: Result := 'Invalid jump';
          ecOpenBlockExpected: Result := 'Open Block (''['') expected';
          ecWriteOnlyProperty: Result := 'Свойство только для записи';
          ecReadOnlyProperty: Result := 'Свойство только для чтения';
          ecClassTypeExpected: Result := 'Class type expected';
          ecCustomError: Result := x^.Param;
          ecDivideByZero: Result := 'Деление на ноль';
          ecMathError:  Result := 'Математическая ошибка';
          ecUnsatisfiedForward: Result := 'Unsatisfied Forward '+ X^.Param;
        else
          Result := 'Unknown error';
        end;
        Result := '[Ошибка] ' + x^.ModuleName + ': ' + Result;
      end;
    ptHint:
      begin
        case x^.Hint of
          ehVariableNotUsed: Result := 'Переменная ''' + x^.Param + ''' не используется';
          ehFunctionNotUsed: Result := 'Функция ''' + x^.Param + '''  не используется';
          ehCustomHint: Result := x^.Param;
        else
          Result := 'Unknown hint';
        end;
        Result := '[Hint] ' + x^.ModuleName + ': ' + Result;
      end;
    ptWarning:
      begin
        case x^.Warning of
          ewCustomWarning: Result := x^.Param;
          ewCalculationAlwaysEvaluatesTo: Result := 'Calculation always evaluates to '+x^.Param;
          ewIsNotNeeded: Result := x^.Param +' is not needed';
        end;
        Result := '[Warning] ' + x^.ModuleName + ': ' + Result;
      end;
  else
    Result := 'Unknown message';
  end;
end;

type
  TFuncType = (ftProc, ftFunc);

function mi2s(i: Cardinal): string;
begin
  Result := #0#0#0#0;
  Cardinal((@Result[1])^) := i;
end;




function TIFPSPascalCompiler.AddType(const Name: string; const BaseType: TIFPSBaseType): PIFPSType;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  New(Result);
  Result^.Name := FastUppercase(Name);
  //result^.nameuse:=Name;
  Result^.NameHash := MakeHash(Result^.Name);
  Result^.BaseType := BaseType;
  Result^.Used := False;
  Result^.TypeSize := 1;
  Result^.DeclarePosition := Cardinal(-1);
  Result^.RecordSubVals := nil;
  Result^.FExport := False;
  Result^.Ext := nil;
  FAvailableTypes.Add(Result);

end;


function TIFPSPascalCompiler.AddFunction(const Header: string; comment:  string; typeF:shortint): PIFPSRegProc;

  function FindType(const s: string): Cardinal;
  var
    h, l: Longint;
  begin
    h := MakeHash(s);
    for l := 0 to FAvailableTypes.Count - 1 do
    begin
      if (PIFPSType(FAvailableTypes.GetItem(l))^.NameHash = h) and
        (PIFPSType(FAvailableTypes.GetItem(l))^.Name = s) then
      begin
        Result := l;
        exit;
      end;
    end;
    Result := Cardinal(-1);
  end;
var
  Parser: TIfPascalParser;
  IsFunction: Boolean;
  VNames, Name, Decl,nameuse,decluse: string;
  modifier: Char;
  VCType: Cardinal;
  x: PIFPSRegProc;
begin
  decluse:=Header;
  nameuse:='';
  if FProcs = nil then begin Result := nil; exit;end;
  Parser := TIfPascalParser.Create;
  Parser.SetText(Header);
  if Parser.CurrTokenId = CSTII_Function then
    IsFunction := True
  else if Parser.CurrTokenId = CSTII_Procedure then
    IsFunction := False
  else
  begin
    Parser.Free;
    Result := nil;
    exit;
  end;
 // typeF:=-1;
  Comment:=comment;
  Decl := '';
  Parser.Next;
  if Parser.CurrTokenId <> CSTI_Identifier then
  begin
    Parser.Free;
    Result := nil;
    exit;
  end; {if}
  Name := Parser.GetToken;
  nameuse:=Parser.OriginalToken;
  Parser.Next;
  if Parser.CurrTokenId = CSTI_OpenRound then
  begin
    Parser.Next;
    if Parser.CurrTokenId <> CSTI_CloseRound then
    begin
      while True do
      begin
        if Parser.CurrTokenId = CSTII_Const then
        begin
          Modifier := '@';
          Parser.Next;
        end else
        if Parser.CurrTokenId = CSTII_Var then
        begin
          modifier := '!';
          Parser.Next;
        end
        else
          modifier := '@';
        if Parser.CurrTokenId <> CSTI_Identifier then
        begin
          Parser.Free;
          Result := nil;
          exit;
        end;
        VNames := Parser.GetToken + '|';
        Parser.Next;
        while Parser.CurrTokenId = CSTI_Comma do
        begin
          Parser.Next;
          if Parser.CurrTokenId <> CSTI_Identifier then
          begin
            Parser.Free;
            Result := nil;
            exit;
          end;
          VNames := VNames + Parser.GetToken + '|';
          Parser.Next;
        end;
        if Parser.CurrTokenId <> CSTI_Colon then
        begin
          Parser.Free;
          Result := nil;
          exit;
        end;
        Parser.Next;
        VCType := FindType(Parser.GetToken);
        if VCType = Cardinal(-1) then
        begin
          Parser.Free;
          Result := nil;
          exit;
        end;
        while Pos('|', VNames) > 0 do
        begin
          Decl := Decl + ' ' + modifier + copy(VNames, 1, Pos('|', VNames) - 1)
            +
            ' ' + inttostr(VCType);
          Delete(VNames, 1, Pos('|', VNames));
        end;
        Parser.Next;
        if Parser.CurrTokenId = CSTI_CloseRound then
          break;
        if Parser.CurrTokenId <> CSTI_Semicolon then
        begin
          Parser.Free;
          Result := nil;
          exit;
        end;
        Parser.Next;
      end; {while}
    end; {if}
    Parser.Next;
  end; {if}
  if IsFunction then
  begin
    if Parser.CurrTokenId <> CSTI_Colon then
    begin
      Parser.Free;
      Result := nil;
      exit;
    end;

    Parser.Next;
    VCType := FindType(Parser.GetToken);
    if VCType = Cardinal(-1) then
    begin
      Parser.Free;
      Result := nil;
      exit;
    end;
  end
  else
    VCType := Cardinal(-1);
  Decl := inttostr(VCType) + Decl;
  Parser.Free;
  New(x);
  x^.Name := Name;
  x^.NameHash := MakeHash(Name);
  x^.FExportName := True;
  x^.Decl := Decl;
  x^.Comment:=comment;
  x^.decluse:=decluse;
  x^.nameuse:=nameuse;
  x^.typeF:=typeF;
  Result := x;
  FRegProcs.Add(x);
end;

function TIFPSPascalCompiler.MakeHint(const Module: string; E: TIFPSPascalCompilerHint; const Param: string): PIFPSPascalCompilerMessage;
var
  n: PIFPSPascalCompilerMessage;
begin
  New(n);
  n^.ModuleName := Module;
  n^.Param := Param;
  n^.Position := FParser.CurrTokenPos;
  n^.MessageType := ptHint;
  n^.Hint := E;
  FMessages.Add(n);
  Result := n;
end;
function TIFPSPascalCompiler.MakeError(const Module: string; E:
  TIFPSPascalCompilerError; const Param: string): PIFPSPascalCompilerMessage;
var
  n: PIFPSPascalCompilerMessage;
begin
  New(n);
  n^.ModuleName := Module;
  n^.Param := Param;
  n^.Position := FParser.CurrTokenPos;
  n^.MessageType := ptError;
  n^.Error := E;
  FMessages.Add(n);
  Result := n;
end;

function TIFPSPascalCompiler.MakeWarning(const Module: string; E:
  TIFPSPascalCompilerWarning; const Param: string): PIFPSPascalCompilerMessage;
var
  n: PIFPSPascalCompilerMessage;
begin
  New(n);
  n^.ModuleName := Module;
  n^.Param := Param;
  n^.Position := FParser.CurrTokenPos;
  n^.MessageType := ptWarning;
  n^.Warning := E;
  FMessages.Add(n);
  Result := n;
end;

procedure TIFPSPascalCompiler.Clear;
var
  l: Longint;
  p: PIFPSPascalCompilerMessage;
begin
  FDebugOutput := '';
  FOutput := '';
  for l := 0 to FMessages.Count - 1 do
  begin
    p := FMessages.GetItem(l);
    Dispose(p);
  end;
  FMessages.Clear;
  for L := FAutoFreeList.Count -1 downto 0 do
  begin
    TObject(FAutoFreeList.GetItem(l)).Free;
  end;
  FAutoFreeList.Clear;
end;


procedure DisposeVariant(p: PIfRVariant);
begin
  if p <> nil then
  begin
    p^.Value := '';
    Dispose(p);
  end;
end;

type
  PParam = ^TParam;
  TParam = record
    InReg, OutReg: PIFPSValue;
    FType: Cardinal;
    OutRegPos: Cardinal;
  end;

procedure DisposePValue(r: PIFPSValue); forward;

procedure FreeRecFields(List: TIfList);
var
  i: Longint;
  p: PIFRecField;
begin
  if list = nil then
    exit;
  for i := List.Count - 1 downto 0 do
  begin
    p := List.GetItem(i);
    if p^.FKind >= 2 then
    begin
      DisposePValue(p^.ReadArrayFieldNoFrom);
    end;
    Dispose(p);
  end;
  List.Free;
end;

procedure DisposePValue(r: PIFPSValue);
var
  l: Longint;
  p: PCalc_Item;
  P2: PParam;
begin
  if (r <> nil) and ((r^.Modifiers and 128)= 0) then
  begin
    if (r^.FType = CVAL_Array) then
    begin
      for l := 0 to r.ArrayItems.Count -1 do
      begin
        DisposePValue(R.ArrayItems.GetItem(l));
      end;
      r.ArrayItems.Free;
    end else
    if (r^.FType = CVAL_AllocatedStackReg) or (r^.FType = CVAL_Addr) or (r^.FType = CVAL_PushAddr) then
    begin
      FreeRecFields(R^.RecField);
    end
    else if r.FType = CVAL_Data then
      DisposeVariant(r^.FData)
    else if r.FType = CVAL_Eval then
    begin
      for l := 0 to r.SubItems.Count - 1 do
      begin
        p := r.SubItems.GetItem(l);
        if not p^.C then
          DisposePValue(p^.OutRec);
        Dispose(p);
      end;
      r^.SubItems.Free;
    end
    else if (r.FType = CVAL_Proc) or (r.FType = CVAL_varProc)then
    begin
      for l := 0 to r^.Parameters.Count - 1 do
      begin
        P2 := r^.Parameters.GetItem(l);
        if P2^.InReg <> nil then
          DisposePValue(P2^.InReg);
        Dispose(P2);
      end;
      r.Parameters.Free;
      if r.FType = CVAL_VarProc then
        DisposePValue(r._ProcNo);
    end else if (r.FType = CVAL_ClassPropertyCallGet) or (r.FType = CVAL_ClassPropertyCallSet) or (r.FType = CVAL_ClassMethodCall) or (r.FType = CVAL_ClassProcCall) then
    begin
      DisposePValue(r.Self);
      for l := 0 to r^.Params.Count - 1 do
      begin
        P2 := r^.Params.GetItem(l);
        if P2^.InReg <> nil then
          DisposePValue(P2^.InReg);
        Dispose(P2);
      end;
    end;
    Dispose(r);
  end;
end;

function TIFPSPascalCompiler.GetTypeCopyLink(p: PIFPSType): PIFPSType;
begin
  if p^.BaseType = BtTypeCopy then begin
    if p^.Ext <> nil then
      Result := p^.Ext
    else
      Result := nil
  end else Result := p;
end;

function IsIntType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF NOINT64}, btS64{$ENDIF}: Result := True;
  else
    Result := False;
  end;
end;

function IsRealType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btSingle, btDouble, btExtended: Result := True;
  else
    Result := False;
  end;
end;

function IsIntRealType(b: TIFPSBaseType): Boolean;
begin
  case b of
    btSingle, btDouble, btExtended, btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF NOINT64}, btS64{$ENDIF}:
      Result := True;
  else
    Result := False;
  end;

end;

function DiffRec(p1, p2: PIFRecField): Boolean;
begin
  Result :=
    (p1^.FKind <> p2^.FKind) or
    (p1^.RecFieldNo <> p2^.RecFieldNo);
end;

function SameReg(x1, x2: PIFPSValue): Boolean;
var
  I: Longint;
begin
  if x1^.FType = x2^.FType then
  begin
    case x1^.FType of
      CVAL_Addr, CVAL_PushAddr, CVAL_AllocatedStackReg, CVAL_AllocatedStackReg +1:
        begin
          if x1^.Address = x2^.Address then
          begin
            if (x1^.RecField = nil) and (x2^.RecField = nil) then
              Result := True
            else if (x1^.RecField <> nil) and (x2^.RecField <> nil) and
              (x1^.RecField.Count = x2^.RecField.Count) then
            begin
              for I := x1^.RecField.Count - 1 downto 0 do
              begin
                if DiffRec(x1^.RecField.GetItem(I), x2^.RecField.GetItem(I))
                  then
                begin
                  Result := False;
                  exit;
                end;
              end;
              Result := True;
            end
            else
              Result := False;
          end
          else
            Result := False;
        end;
    else
      Result := False;
    end;
  end
  else
    Result := False;
end;

function D1(const s: string): string;
begin
  Result := copy(s, 2, Length(s) - 1);
end;

function TIFPSPascalCompiler.AT2UT(L: Cardinal): Cardinal;
var
  i: Longint;
  p: PIFPSType;
begin
  if L = Cardinal(-1) then begin Result := Cardinal(-1); exit; end;
  p := FAvailableTypes.GetItem(L);
  p := GetTypeCopyLink(p);
  if p^.Used then
  begin
    for i := 0 to FUsedTypes.Count - 1 do
    begin
      if FUSedTypes.GetItem(I) = P then
      begin
        Result := i;
        exit;
      end;
    end;
  end;
  UpdateRecordFields(p);
  p^.Used := True;
  FUsedTypes.Add(p);
  Result := FUsedTypes.Count - 1;
end;


procedure TIFPSPascalCompiler.ReplaceTypes(var s: string);
var
  NewS: string;
  ts: string;
begin
  ts := GRFW(s);
  if ts <> '-1' then
  begin
    NewS := IntToStr(AT2UT(StrToInt(ts)));
  end
  else
    NewS := '-1';
  while length(s) > 0 do
  begin
    NewS := NewS + ' ' + grfw(s);
    ts := grfw(s);
    NewS := NewS + ' ' + IntToStr(AT2UT(StrToInt(ts)));
  end;
  s := NewS;
end;


function TIFPSPascalCompiler.GetUInt(FUseTypes: TIfList; Src: PIfRVariant; var s: Boolean): Cardinal;
begin
  case PIFPSType(FUseTypes.GetItem(Src^.FType))^.BaseType of
    btU8: Result := TbtU8((@Src^.Value[1])^);
    btS8: Result := TbtS8((@Src^.Value[1])^);
    btU16: Result := TbtU16((@Src^.Value[1])^);
    btS16: Result := TbtS16((@Src^.Value[1])^);
    btU32: Result := TbtU32((@Src^.Value[1])^);
    btS32: Result := TbtS32((@Src^.Value[1])^);
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;

function TIFPSPascalCompiler.GetInt(FUseTypes: TIfList; Src: PIfRVariant; var s: Boolean): Longint;
begin
  case PIFPSType(FUseTypes.GetItem(Src^.FType))^.BaseType of
    btU8: Result := TbtU8((@Src^.Value[1])^);
    btS8: Result := TbtS8((@Src^.Value[1])^);
    btU16: Result := TbtU16((@Src^.Value[1])^);
    btS16: Result := TbtS16((@Src^.Value[1])^);
    btU32: Result := TbtU32((@Src^.Value[1])^);
    btS32: Result := TbtS32((@Src^.Value[1])^);
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;

function TIFPSPascalCompiler.GetReal(FUseTypes: TIfList; Src: PIfRVariant; var s: Boolean): Extended;
begin
  case PIFPSType(FUseTypes.GetItem(Src^.FType))^.BaseType of
    btU8: Result := TbtU8((@Src^.Value[1])^);
    btS8: Result := TbtS8((@Src^.Value[1])^);
    btU16: Result := TbtU16((@Src^.Value[1])^);
    btS16: Result := TbtS16((@Src^.Value[1])^);
    btU32: Result := TbtU32((@Src^.Value[1])^);
    btS32: Result := TbtS32((@Src^.Value[1])^);
    btSingle: Result := TbtSingle((@Src^.Value[1])^);
    btDouble: Result := TbtDouble((@Src^.Value[1])^);
    btExtended: Result := TbtExtended((@Src^.Value[1])^);
  else
    begin
      s := False;
      Result := 0;
    end;
  end;
end;

function TIFPSPascalCompiler.GetString(FUseTypes: TIfList; Src: PIfRVariant; var s: Boolean): string;
begin
  case PIFPSType(FUseTypes.GetItem(Src^.FType))^.BaseType of
    btChar: Result := Src^.Value;
    btString: Result := Src^.Value;
  else
    begin
      s := False;
      Result := '';
    end;
  end;
end;

function TIFPSPascalCompiler.PreCalc(FUseTypes: TIfList; Var1Mod: Byte; var1: PIFRVariant; Var2Mod: Byte; Var2: PIfRVariant; Cmd: Byte; Pos: Cardinal): Boolean;
  { var1=dest, var2=src }
var
  b: Boolean;

  procedure SetBoolean(b: Boolean);
  begin
    if FUseTypes = FAvailableTypes then
      Var1^.FType := FBooleanType
    else
      Var1^.FType := at2ut(FBooleanType);
    var1^.Value := Chr(Ord(b));
  end;
  function ab(b: Longint): Longint;
  begin
    ab := Longint(b = 0);
  end;

begin
  Result := True;
  try
    case Cmd of
      0:
        begin { + }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) +
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) +
              GetInt(FUseTypes,Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) +
              GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) +
              GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) +
              GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) +
              GetInt(FUseTypes, Var2, Result);
            btSingle: TbtSingle((@var1^.Value[1])^) :=
              TbtSingle((@var1^.Value[1])^) + GetReal(FUseTypes, Var2, Result);
            btDouble: TbtDouble((@var1^.Value[1])^) :=
              TbtDouble((@var1^.Value[1])^) + GetReal(FUseTypes, Var2, Result);
            btExtended: TbtExtended((@var1^.Value[1])^) :=
              TbtExtended((@var1^.Value[1])^) + GetReal(FUseTypes, Var2, Result);
            btString: var1^.Value := var1^.Value + GetString(FUseTypes, Var2, Result);
          end;
        end;
      1:
        begin { - }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) -
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) -
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) -
              GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) -
              GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) -
              GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) -
              GetInt(FUseTypes, Var2, Result);
            btSingle: TbtSingle((@var1^.Value[1])^) :=
              TbtSingle((@var1^.Value[1])^) - GetReal(FUseTypes, Var2, Result);
            btDouble: TbtDouble((@var1^.Value[1])^) :=
              TbtDouble((@var1^.Value[1])^) - GetReal(FUseTypes,Var2, Result);
            btExtended: TbtExtended((@var1^.Value[1])^) :=
              TbtExtended((@var1^.Value[1])^) - GetReal(FUseTypes,Var2, Result);
          end;
        end;
      2:
        begin { * }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) *
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) *
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) *
              GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) *
              GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) *
              GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) *
              GetInt(FUseTypes, Var2, Result);
            btSingle: TbtSingle((@var1^.Value[1])^) :=
              TbtSingle((@var1^.Value[1])^) * GetReal(FUseTypes,Var2, Result);
            btDouble: TbtDouble((@var1^.Value[1])^) :=
              TbtDouble((@var1^.Value[1])^) * GetReal(FUseTypes,Var2, Result);
            btExtended: TbtExtended((@var1^.Value[1])^) :=
              TbtExtended((@var1^.Value[1])^) * GetReal(FUseTypes, Var2, Result);
          end;
        end;
      3:
        begin { / }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8:
                TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) div
                  GetUInt(FUseTypes, Var2, Result);
            btS8:
                TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) div
                  GetInt(FUseTypes, Var2, Result);
            btU16:
                TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) div
                  GetUInt(FUseTypes, Var2, Result);
            btS16:
                TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) div
                  GetInt(FUseTypes, Var2, Result);
            btU32:
                TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) div
                  GetUInt(FUseTypes, Var2, Result);
            btS32:
                TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) div
                  GetInt(FUseTypes, Var2, Result);
            btSingle:
                TbtSingle((@var1^.Value[1])^) := TbtSingle((@var1^.Value[1])^)
                  / GetReal(FUseTypes, Var2, Result);
            btDouble:
                TbtDouble((@var1^.Value[1])^) := TbtDouble((@var1^.Value[1])^)
                  / GetReal(FUseTypes, Var2, Result);
            btExtended:
                TbtExtended((@var1^.Value[1])^) :=
                  TbtExtended((@var1^.Value[1])^) / GetReal(FUseTypes, Var2, Result);
          end;
        end;
      4:
        begin { MOD }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8:
                TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) mod
                  GetUInt(FUseTypes, Var2, Result);
            btS8:
                TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) mod
                  GetInt(FUseTypes, Var2, Result);
            btU16:
                TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) mod
                  GetUInt(FUseTypes, Var2, Result);
            btS16:
                TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) mod
                  GetInt(FUseTypes, Var2, Result);
            btU32:
                TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) mod
                  GetUInt(FUseTypes, Var2, Result);
            btS32:
                TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) mod
                  GetInt(FUseTypes, Var2, Result);
          end;
        end;
      5:
        begin { SHL }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) shl
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) shl
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^)
              shl
                GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^)
              shl
                GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^)
              shl
                GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^)
              shl
                GetInt(FUseTypes, Var2, Result);
          end;
        end;
      6:
        begin { SHR }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) shr
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) shr
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^)
              shr
                GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^)
              shr
                GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^)
              shr
                GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^)
              shr
                GetInt(FUseTypes, Var2, Result);
          end;
        end;
      7:
        begin { AND }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) and
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) and
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^)
              and
                GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^)
              and
                GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^)
              and
                GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^)
              and
                GetInt(FUseTypes, Var2, Result);
          end;
        end;
      8:
        begin { OR }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) or
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) or
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^) or
              GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^) or
              GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^) or
              GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^) or
              GetInt(FUseTypes, Var2, Result);
          end;
        end;
      9:
        begin { XOR }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: TbtU8((@var1^.Value[1])^) := TbtU8((@var1^.Value[1])^) xor
              GetUInt(FUseTypes, Var2, Result);
            btS8: TbtS8((@var1^.Value[1])^) := TbtS8((@var1^.Value[1])^) xor
              GetInt(FUseTypes, Var2, Result);
            btU16: TbtU16((@var1^.Value[1])^) := TbtU16((@var1^.Value[1])^)
              xor
                GetUInt(FUseTypes, Var2, Result);
            btS16: TbtS16((@var1^.Value[1])^) := TbtS16((@var1^.Value[1])^)
              xor
                GetInt(FUseTypes, Var2, Result);
            btU32: TbtU32((@var1^.Value[1])^) := TbtU32((@var1^.Value[1])^)
              xor
                GetUInt(FUseTypes, Var2, Result);
            btS32: TbtS32((@var1^.Value[1])^) := TbtS32((@var1^.Value[1])^)
              xor
                GetInt(FUseTypes, Var2, Result);
          end;
        end;
      10:
        begin { >= }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) >= GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) >= GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) >= GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) >= GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) >= GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) >= GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) >= GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) >= GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) >= GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
      11:
        begin { <= }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) <= GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) <= GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) <= GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) <= GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) <= GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) <= GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) <= GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) <= GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) <= GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
      12:
        begin { > }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) > GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) > GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) > GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) > GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) > GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) > GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) > GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) > GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) > GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
      13:
        begin { < }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) < GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) < GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) < GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) < GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) < GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) < GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) < GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) < GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) < GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
      14:
        begin { <> }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) <> GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) <> GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) <> GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) <> GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) <> GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) <> GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) <> GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) <> GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) <> GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
      15:
        begin { = }
          case PIFPSType(FUseTypes.GetItem(var1^.FType))^.BaseType of
            btU8: b := TbtU8((@var1^.Value[1])^) = GetUInt(FUseTypes, Var2, Result);
            btS8: b := TbtS8((@var1^.Value[1])^) = GetInt(FUseTypes, Var2, Result);
            btU16: b := TbtU16((@var1^.Value[1])^) = GetUInt(FUseTypes, Var2, Result);
            btS16: b := TbtS16((@var1^.Value[1])^) = GetInt(FUseTypes, Var2, Result);
            btU32: b := TbtU32((@var1^.Value[1])^) = GetUInt(FUseTypes, Var2, Result);
            btS32: b := TbtS32((@var1^.Value[1])^) = GetInt(FUseTypes, Var2, Result);
            btSingle: b := TbtSingle((@var1^.Value[1])^) = GetReal(FUseTypes, Var2,
                Result);
            btDouble: b := TbtDouble((@var1^.Value[1])^) = GetReal(FUseTypes, Var2,
                Result);
            btExtended: b := TbtExtended((@var1^.Value[1])^) = GetReal(FUseTypes, Var2,
                Result);
          else
            b := False;
          end;
          SetBoolean(b);
        end;
    end;
  except
    on E: EDivByZero do
    begin
      Result := False;
      MakeError('', ecDivideByZero, '');
      Exit;
    end;
    on E: EZeroDivide do
    begin
      Result := False;
      MakeError('', ecDivideByZero, '');
      Exit;
    end;
    on E: EMathError do
    begin
      Result := False;
      MakeError('', ecMathError, e.Message);
      Exit;
    end;
    on E: Exception do
    begin
      Result := False;
      MakeError('', ecInternalError, E.Message);
      Exit;
    end;
  end;
  if not Result then
    MakeError('', ecTypeMismatch, '')^.Position := Pos;
end;

function TIFPSPascalCompiler.IsDuplicate(const s: string): Boolean;
var
  h, l: Longint;
  x: PIFPSProcedure;
begin
  h := MakeHash(s);
  if (s = 'RESULT') then
  begin
    Result := True;
    exit;
  end;

  for l := 0 to FAvailableTypes.Count - 1 do
  begin
    if (PIFPSType(FAvailableTypes.GetItem(l))^.NameHash = h) and
      (PIFPSType(FAvailableTypes.GetItem(l))^.Name = s) then
    begin
      Result := True;
      exit;
    end;
  end;

  for l := 0 to FProcs.Count - 1 do
  begin
    x := FProcs.GetItem(l);
    if x^.Internal then
    begin
      if (h = x^.NameHash) and (s = x^.Name) then
      begin
        Result := True;
        exit;
      end;
    end
    else
    begin
      if (PIFPSUsedRegProc(x)^.RP^.NameHash = h) and
        (PIFPSUsedRegProc(x)^.RP^.Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;
  end;
  for l := 0 to FVars.Count - 1 do
  begin
    if (PIFPSVar(FVars.GetItem(l))^.NameHash = h) and
      (PIFPSVar(FVars.GetItem(l))^.Name = s) then
    begin
      Result := True;
      exit;
    end;
  end;
  for l := 0 to FConstants.Count -1 do
  begin
    if (PIFPSConstant(FConstants.GetItem(l))^.NameHash = h) and
      (PIFPSConstant(FConstants.GetItem(l))^.Name = s) then
    begin
      Result := TRue;
      exit;
    end;
  end;
  Result := False;
end;


function TIFPSPascalCompiler.ReadType(const Name: string; FParser: TIfPascalParser): Cardinal; // Cardinal(-1) = Invalid
var
  h, l, TypeNo: Longint;
  fieldname,s: string;
  RecSubVals: TIfList;
  rvv: PIFPSRecordType;
  p, p2: PIFPSType;
  function ATNUT(C: Cardinal): Cardinal;
  var
    i: Longint;
    P: PIFPSType;
  begin
    p := FAvailableTypes.GetItem(C);
    for i := 0 to FUsedTypes.Count -1 do
    begin
      if FUsedTypes.GetItem(I) = P then
      begin
        Result := I;
        exit;
      end;
    end;
    result := Cardinal(-1);
  end;
  procedure ClearRecSubVals;
  var
    I: Longint;
    p: PIFPSRecordType;
  begin
    for I := 0 to RecSubVals.Count - 1 do
    begin
      p := RecSubVals.GetItem(I);
      Dispose(p);
    end;
    RecSubVals.Free;
  end;

  procedure MakeRealFieldOffsets;
  var
    I: Longint;
    O: Cardinal;
    rvv: PIFPSRecordType;
  begin
    O := 0;
    for I := 0 to RecSubVals.Count - 1 do
    begin
      rvv := RecSubVals.GetItem(I);
      rvv^.RealFieldOffset := O;
      O := O + PIFPSType(FAvailableTypes.GetItem(rvv^.FType))^.TypeSize;
    end;
    p^.TypeSize := O;
  end;
  function GetTypeCopy(i: Cardinal): Cardinal;
  begin
    if PIFPSType(FAvailableTypes.GetItem(I))^.BaseType = btTypeCopy then
      Result := GetTypeCopy(Cardinal(PIFPSType(FAvailableTypes.GetItem(I))^.Ext))
    else
      Result := i;
  end;

  function AddProcedure: Cardinal;
  var
    IsFunction: Boolean;
    VNames, Decl: string;
    modifier: Char;
    VCType: Cardinal;
    x: PIFPSType;
    xp: PIFPSProceduralType;
    begin
    if FParser.CurrTokenId = CSTII_Function then
      IsFunction := True
    else 
      IsFunction := False;
    Decl := '';
    FParser.Next;
    if FParser.CurrTokenId = CSTI_OpenRound then
    begin
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_CloseRound then
      begin
        while True do
        begin
          if FParser.CurrTokenId = CSTII_Const then
          begin
            Modifier := '@';
            FParser.Next;
          end else
          if FParser.CurrTokenId = CSTII_Var then
          begin
            modifier := '!';
            FParser.Next;
          end
          else
            modifier := '@';
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            Result := Cardinal(-1);
            if FParser = Self.FParser then
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          VNames := FParser.GetToken + '|';
          FParser.Next;
          while FParser.CurrTokenId = CSTI_Comma do
          begin
            FParser.Next;
            if FParser.CurrTokenId <> CSTI_Identifier then
            begin
              Result := Cardinal(-1);
              if FParser = Self.FParser then
              MakeError('', ecIdentifierExpected, '');
              exit;
            end;
            VNames := VNames + FParser.GetToken + '|';
            FParser.Next;
          end;
          if FParser.CurrTokenId <> CSTI_Colon then
          begin
            Result := Cardinal(-1);
            if FParser = Self.FParser then
            MakeError('', ecColonExpected, '');
            exit;
          end;
          FParser.Next;
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            Result := Cardinal(-1);
            if FParser = Self.FParser then
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          VCType := FindType(FParser.GetToken);
          if VCType = Cardinal(-1) then
          begin
            if FParser = Self.FParser then
            MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
            Result := Cardinal(-1);
            exit;
          end;
          while Pos('|', VNames) > 0 do
          begin
            Decl := Decl + ' ' + modifier + copy(VNames, 1, Pos('|', VNames) - 1) +
              ' ' + inttostr(VCType);
            Delete(VNames, 1, Pos('|', VNames));
          end;
          FParser.Next;
          if FParser.CurrTokenId = CSTI_CloseRound then
            break;
          if FParser.CurrTokenId <> CSTI_Semicolon then
          begin
            if FParser = Self.FParser then
            MakeError('', ecSemicolonExpected, '');
            Result := Cardinal(-1);
            exit;
          end;
          FParser.Next;
        end; {while}
      end; {if}
      FParser.Next;
      end; {if}
      if IsFunction then
      begin
        if FParser.CurrTokenId <> CSTI_Colon then
        begin
          if FParser = Self.FParser then
          MakeError('', ecColonExpected, '');
          Result := Cardinal(-1);
          exit;
        end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        Result := Cardinal(-1);
        if FParser = Self.FParser then
        MakeError('', ecIdentifierExpected, '');
        exit;
      end;
      VCType := FindType(FParser.GetToken);
      if VCType = Cardinal(-1) then
      begin
        if FParser = Self.FParser then
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
        Result := Cardinal(-1);
        exit;
      end;
      FParser.Next;
    end
    else
      VCType := Cardinal(-1);
    Decl := inttostr(VCType) + Decl;
    New(x);
    x^.FExport := False;
    x^.Name := Name;
    x^.NameHash := MakeHash(x^.Name);
    x^.BaseType := btProcPtr;
    x^.DeclarePosition := FParser.CurrTokenPos;
    x^.Used := False;
    x^.TypeSize := 1;
    x^.RecordSubVals := nil;
    New(xp);
    x^.Ext := xp;
    xp^.ProcDef := Decl;
    FAvailableTypes.Add(X);
    Result := FAvailableTypes.Count -1;
  end; {AddProcedure}

begin
  if (FParser.CurrTokenID = CSTII_Function) or (FParser.CurrTokenID = CSTII_Procedure) then
  begin
     Result := AddProcedure;
     Exit;
  end else if FParser.CurrTokenId = CSTI_OpenRound then
  begin
    FParser.Next;
    L := 0;
    New(P);
    p^.NameHash := MakeHash(Name);
    p^.Name := Name;
    p^.BaseType := btEnum;
    p^.Used := False;
    p^.TypeSize := 1;
    p^.DeclarePosition := FParser.CurrTokenPos;
    p^.RecordSubVals := nil;
    p^.FExport := False;
    p^.Ext := nil;
    FAvailableTypes.Add(p);

    TypeNo := FAvailableTypes.Count -1;
    repeat
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        if FParser = Self.FParser then
        MakeError('', ecIdentifierExpected, '');
        Result := Cardinal(-1);
        exit;
      end;
      s := FParser.GetToken;
      if IsDuplicate(s) then
      begin
        if FParser = Self.FParser then
        MakeError('', ecDuplicateIdentifier, s);
        Result := Cardinal(-1);
        Exit;
      end;
      AddConstant(s, TypeNo)^.Value.Value := TransCardinalToStr(L);
      Inc(L);
      FParser.Next;
      if FParser.CurrTokenId = CSTI_CloseRound then
        Break
      else if FParser.CurrTokenId <> CSTI_Comma then
      begin
        if FParser = Self.FParser then
        MakeError('', ecCloseRoundExpected, '');
        Result := Cardinal(-1);
        Exit;
      end;
      FParser.Next;
    until False;
    FParser.Next;
    p^.Ext := Pointer(L -1);
    Result := TypeNo;
    exit;
  end else
  if FParser.CurrTokenId = CSTII_Array then
  begin
    FParser.Next;
    if FParser.CurrTokenId <> CSTII_Of then
    begin
      if FParser = Self.FParser then
      MakeError('', ecOfExpected, '');
      Result := Cardinal(-1);
      exit;
    end;
    FParser.Next;
    L := ReadType('', FParser);
    if L = -1 then
    begin
      if FParser = Self.FParser then
      MakeError('', ecUnknownIdentifier, '');
      Result := Cardinal(-1);
      exit;
    end;
    if Name = '' then
    begin
      TypeNo := ATNUT(l);
      if TypeNo <> -1 then
      begin
        for h := 0 to FUsedTypes.Count -1 do
        begin
          p := FUsedTypes.GetItem(H);
          if (p^.BaseType = btArray) and (p^.Ext = Pointer(TypeNo)) then
          begin
            for l := 0 to FAvailableTypes.Count -1 do
            begin
              if FAvailableTypes.GetItem(L) = P then
              begin
                Result := l;
                exit;
              end;
            end;
            if FParser = Self.FParser then
            MakeError('', ecInternalError, '0001C');
            Result := Cardinal(-1);
            Exit;
          end;
        end;
      end;
      for h := 0 to FAvailableTypes.Count -1 do
      begin
        p := FAvailableTypes.GetItem(H);
        if (p^.BaseType = btArray) and (p^.Ext = Pointer(L)) and (not p^.Used) then
        begin
          Result := H;
          Exit;
        end;
      end;
    end;
    New(p);
    p^.NameHash := MakeHash(Name);
    p^.Name := Name;
    p^.Used := False;
    p^.BaseType := btArray;
    p^.TypeSize := 1;
    p^.DeclarePosition := FParser.CurrTokenPos;
    p^.RecordSubVals := nil;
    p^.FExport := False;
    p^.Ext := Pointer(L);
    FAvailableTypes.Add(p);
    Result := Cardinal(FAvailableTypes.Count -1);
    Exit;
  end
  else if FParser.CurrTokenId = CSTII_Record then
  begin
    FParser.Next;
    RecSubVals := TIfList.Create;
    repeat
      repeat
        if FParser.CurrTokenId <> CSTI_Identifier then
        begin
          ClearRecSubVals;
          if FParser = Self.FParser then
          MakeError('', ecIdentifierExpected, '');
          Result := Cardinal(-1);
          exit;
        end;
        FieldName := FParser.GetToken;
        s := S+FieldName+'|';
        FParser.Next;
        TypeNo := MakeHash(S);
        for l := 0 to RecSubVals.Count - 1 do
        begin
          if (PIFPSRecordType(RecSubVals.GetItem(l))^.FieldNameHash = TypeNo) and
            (PIFPSRecordType(RecSubVals.GetItem(l))^.FieldName = s) then
          begin
            if FParser = Self.FParser then
              MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
            ClearRecSubVals;
            Result := Cardinal(-1);
            exit;
          end;
        end;
        if FParser.CurrTokenID = CSTI_Colon then Break else
        if FParser.CurrTokenID <> CSTI_Comma then
        begin
          if FParser = Self.FParser then
            MakeError('', ecColonExpected, '');
          ClearRecSubVals;
          Result := Cardinal(-1);
          exit;
        end;
        FParser.Next;
      until False;
      FParser.Next;
      l := ReadType('', FParser);
      if L = -1 then
      begin
        ClearRecSubVals;
        Result := Cardinal(-1);
        exit;
      end;
      P := FAvailableTypes.GetItem(L);
      if p^.BaseType = BtTypeCopy then
      begin
        L := 0;
        for TypeNo := 0 to FAvailableTypes.Count -1 do
        begin
          if FAvailableTypes.GetItem(TypeNo) = p^.Ext then
          begin
            L := TypeNo;
            Break;
          end;
        end;
      end;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        ClearRecSubVals;
        if FParser = Self.FParser then
        MakeError('', ecSemicolonExpected, '');
        Result := Cardinal(-1);
        exit;
      end; {if}
      FParser.Next;
      while Pos('|', s) > 0 do
      begin
        fieldname := copy(s, 1, pos('|', s)-1);
        Delete(s, 1, length(FieldName)+1);
        New(rvv);
        rvv^.FieldName := fieldname;
        rvv^.FieldNameHash := MakeHash(fieldname);
        rvv^.FType := l;
        RecSubVals.Add(rvv);
      end;
    until FParser.CurrTokenId = CSTII_End;
    FParser.Next; // skip CSTII_End
    New(p);
    p^.NameHash := MakeHash(Name);
    p^.Name := Name;
    p^.BaseType := btRecord;
    p^.DeclarePosition := FParser.CurrTokenPos;
    p^.RecordSubVals := RecSubVals;
    p^.Used := False;
    p^.FExport := False;
    p^.Ext := nil;
    FAvailableTypes.Add(p);
    Result := FAvailableTypes.Count -1;
    MakeRealFieldOffsets;
    Exit;
  end else if FParser.CurrTokenId = CSTI_Identifier then
  begin
    s := FParser.GetToken;
    h := MakeHash(s);
    p2 := nil;
    for l := 0 to FAvailableTypes.Count - 1 do
    begin
      if (PIFPSType(FAvailableTypes.GetItem(l))^.NameHash = h) and
        (PIFPSType(FAvailableTypes.GetItem(l))^.Name = s) then
      begin
        FParser.Next;
        p2 := FAvailableTypes.GetItem(l);
        if p2^.BaseType = BtTypeCopy then
        begin
          P2 := p2^.Ext;
        end;
        Break;
      end;
    end;
    if p2 = nil then
    begin
      Result := Cardinal(-1);
      if FParser = Self.FParser then
      MakeError('', ecUnknownType, FParser.OriginalToken);
      exit;
    end;
    if Name <> '' then
    begin
      New(p);
      p^.NameHash := MakeHash(Name);
      p^.Name := Name;
      p^.BaseType := BtTypeCopy;
      p^.TypeSize := 0;
      p^.DeclarePosition := FParser.CurrTokenPos;
      p^.RecordSubVals := nil;
      p^.FExport := FAlse;
      p^.Used := False;
      p^.Ext := p2;
      FAvailableTypes.Add(p);
      Result := FAvailableTypes.Count -1;
      Exit;
    end else begin
      for h := 0 to FAvailableTypes.Count -1 do
      begin
        if FAvailableTypes.GetItem(h) = P2 then
        begin
          Result := h;
          Exit;
        end;
      end;
    end;
  end;
  Result := Cardinal(-1);
  if FParser = Self.FParser then
  MakeError('', ecIdentifierExpected, '');
  Exit;
end;


function TIFPSPascalCompiler.DoVarBlock(proc: PIFPSProcedure): Boolean;
var
  VarName, s: string;
  VarType: Cardinal;
  VarNo: Cardinal;
  v: PIFPSVar;
  vp: PIFPSProcVar;

  function VarIsDuplicate(const s: string): Boolean;
  var
    h, l: Longint;
    x: PIFPSProcedure;
    v: string;
  begin
    h := MakeHash(s);
    if (s = 'RESULT') then
    begin
      Result := True;
      exit;
    end;

    for l := 0 to FAvailableTypes.Count - 1 do
    begin
      if (PIFPSType(FAvailableTypes.GetItem(l))^.NameHash = h) and
        (PIFPSType(FAvailableTypes.GetItem(l))^.Name = s) then
      begin
        Result := True;
        exit;
      end;
    end;

    for l := 0 to FProcs.Count - 1 do
    begin
      x := FProcs.GetItem(l);
      if x^.Internal then
      begin
        if (h = x^.NameHash) and (s = x^.Name) then
        begin
          Result := True;
          exit;
        end;
      end
      else
      begin
        if (PIFPSUsedRegProc(x)^.RP^.NameHash = h) and
          (PIFPSUsedRegProc(x)^.RP^.Name = s) then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
    if proc <> nil then
    begin
      for l := 0 to proc^.ProcVars.Count - 1 do
      begin
        if (PIFPSProcVar(proc^.ProcVars.GetItem(l))^.NameHash = h) and
          (PIFPSVar(proc^.ProcVars.GetItem(l))^.Name = s) then
        begin
          Result := True;
          exit;
        end;
      end;
    end
    else
    begin
      for l := 0 to FVars.Count - 1 do
      begin
        if (PIFPSVar(FVars.GetItem(l))^.NameHash = h) and
          (PIFPSVar(FVars.GetItem(l))^.Name = s) then
        begin
          Result := True;
          exit;
        end;
      end;
    end;
    v := VarName;
    while Pos('|', v) > 0 do
    begin
      if copy(v, 1, Pos('|', v) - 1) = s then
      begin
        Result := True;
        exit;
      end;
      Delete(v, 1, Pos('|', v));
    end;
    for l := 0 to FConstants.Count -1 do
    begin
      if (PIFPSConstant(FConstants.GetItem(l))^.NameHash = h) and
        (PIFPSConstant(FConstants.GetItem(l))^.Name = s) then
      begin
        Result := TRue;
        exit;
      end;
    end;
    Result := False;
  end;

begin
  Result := False;
  FParser.Next; // skip CSTII_Var
  if FParser.CurrTokenId <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    exit;
  end;
  repeat
    if VarIsDuplicate(FParser.GetToken) then
    begin
      MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
      exit;
    end;
    VarName := FParser.GetToken + '|';
    Varno := 0;
    if @FOnUseVariable <> nil then
    begin
      if Proc <> nil then
        FOnUseVariable(Self, ivtVariable, Proc^.ProcVars.Count + VarNo, FProcs.Count -1, FParser.CurrTokenPos)
      else
        FOnUseVariable(Self, ivtGlobal, FVars.Count + VarNo, Cardinal(-1), FParser.CurrTokenPos)
    end;
    FParser.Next;
    while FParser.CurrTokenId = CSTI_Comma do
    begin
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
      end;
      if VarIsDuplicate(FParser.GetToken) then
      begin
        MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
        exit;
      end;
      VarName := VarName + FParser.GetToken + '|';
      Inc(varno);
      if @FOnUseVariable <> nil then
      begin
        if Proc <> nil then
          FOnUseVariable(Self, ivtVariable, Proc^.ProcVars.Count + VarNo, FProcs.Count -1, FParser.CurrTokenPos)
        else
          FOnUseVariable(Self, ivtGlobal, FVars.Count + VarNo, Cardinal(-1), FParser.CurrTokenPos)
      end;
      FParser.Next;
    end;
    if FParser.CurrTokenId <> CSTI_Colon then
    begin
      MakeError('', ecColonExpected, '');
      exit;
    end;
    FParser.Next;
    VarType := at2ut(ReadType('', FParser));
    if VarType = Cardinal(-1) then
    begin
      exit;
    end;
    while Pos('|', VarName) > 0 do
    begin
      s := copy(VarName, 1, Pos('|', VarName) - 1);
      Delete(VarName, 1, Pos('|', VarName));
      if proc = nil then
      begin
        New(v);
        v^.Used := False;
        v^.Name := s;
        v^.NameHash := MakeHash(v^.Name);
        v^.DeclarePosition := FParser.CurrTokenPos;
        v^.FType := VarType;
        FVars.Add(v);
      end
      else
      begin
        New(vp);
        vp^.Used := False;
        vp^.VarName := s;
        vp^.NameHash := MakeHash(vp^.VarName);
        vp^.VarType := VarType;
        vp^.CurrentlyUsed := False;
        vp^.Used := False;
        vp^.DeclarePosition := FParser.CurrTokenPos;
        proc.ProcVars.Add(vp);
      end;
    end;
    if FParser.CurrTokenId <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
  until FParser.CurrTokenId <> CSTI_Identifier;
  Result := True;
end;

function TIFPSPascalCompiler.NewProc(const Name: string): PIFPSProcedure;
begin
  New(Result);
  Result^.Forwarded := False;
  Result^.FExport := 0;
  Result^.Data := '';
  Result^.Decl := '-1';
  Result^.Name := Name;
  Result^.NameHash := MakeHash(Result^.Name);
  Result^.Used := False;
  Result^.Internal := True;
  Result^.ProcVars := TIfList.Create;
  Result^.ResUsed := False;
  Result^.DeclarePosition := FParser.CurrTokenPos;
  Result^.FLabels := TIfStringList.Create;
  Result^.FGotos := TIfStringList.Create;
  FProcs.Add(Result);
end;

function TIFPSPascalCompiler.ProcessLabel(Proc: PIFPSProcedure): Boolean;
var
  CurrLabel: string;
  function IsProcDuplic(const s: string): Boolean;
  var
    i: Longint;
    h: Longint;
    u: string;
  begin
    h := MakeHash(s);
    if s = 'RESULT' then
      Result := True
    else if Proc^.Name = s then
      Result := True
    else if IsDuplicate(s) then
      Result := True
    else
    begin
      u := Proc^.Decl;
      while Length(u) > 0 do
      begin
        if D1(GRFW(u)) = s then
        begin
          Result := True;
          exit;
        end;
        GRFW(u);
      end;
      for i := 0 to Proc^.ProcVars.Count -1 do
      begin
        if (PIFPSProcVar(Proc^.ProcVars.GetItem(I))^.NameHash = h) and (PIFPSProcVar(Proc^.ProcVars.GetItem(I))^.VarName = s) then
        begin
          Result := True;
          exit;
        end;
      end;
      for i := 0 to Proc^.FLabels.Count -1 do
      begin
        u := Proc^.FLabels.GetItem(i);
        delete(u, 1, 4);
        if Longint((@u[1])^) = h then
        begin
          delete(u, 1, 4);
          if u = s then
          begin
            Result := True;
            exit;
          end;
        end;
      end;
      Result := False;
    end;
  end;
begin
  FParser.Next;
  while true do
  begin
    if FParser.CurrTokenId <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      Result := False;
      exit;
    end;
    CurrLabel := FParser.GetToken;
    if IsDuplicate(CurrLabel) or IsProcDuplic(CurrLabel) then
    begin
      MakeError('', ecDuplicateIdentifier, '');
      Result := False;
      exit;
    end;
    FParser.Next;
    Proc^.FLabels.Add(#$FF#$FF#$FF#$FF+mi2s(MakeHash(CurrLabel))+CurrLabel);
    if FParser.CurrTokenId = CSTI_Semicolon then
    begin
      FParser.Next;
      Break;
    end;
    if FParser.CurrTokenId <> CSTI_Comma then
    begin
      MakeError('', ecCommaExpected, '');
      Result := False;
      exit;
    end;
    FParser.Next;
  end;
  Result := True;
end;

procedure TIFPSPascalCompiler.Debug_SavePosition(ProcNo: Cardinal; Proc: PIFPSProcedure);
begin
  WriteDebugData(#4 + mi2s(ProcNo) + mi2s(Length(Proc^.Data)) + mi2s(FParser.CurrTokenPos));
end;
procedure TIFPSPascalCompiler.Debug_WriteParams(ProcNo: Cardinal; Proc: PIFPSProcedure);
var
  I: Longint;
  s, d: string;
begin
  s := #2 + mi2s(ProcNo);
  d := proc^.Decl;
  if GRFW(d) <> '-1' then
  begin
    s := s + 'RESULT'+#1;
  end;
  while Length(d) > 0 do
  begin
    s := s + D1(GRFW(d)) + #1;
    GRFW(d);
  end;
  s := s + #0#3 + mi2s(ProcNo);
  for I := 0 to proc^.ProcVars.Count - 1 do
  begin
    s := s + PIFPSProcVar(proc^.ProcVars.GetItem(I))^.VarName + #1;
  end;
  s := s + #0;
  WriteDebugData(s);
end;



function TIFPSPascalCompiler.ProcessFunction: Boolean;
var
  FunctionType: TFuncType;
  FunctionName: string;
  FunctionParamNames: string;
  FunctionTempType: Cardinal;
  ParamNo: Cardinal;
  FunctionDecl: string;
  modifier: Char;
  F2, Func: PIFPSProcedure;
  EPos: Cardinal;
  pp: PIFPSRegProc;
  pp2: PIFPSUsedRegProc;
  FuncNo, I: Longint;
  procedure CheckVars(Func: PIFPSProcedure);
  var
    i: Integer;
    p: PIFPSProcVar;
  begin
    for i := 0 to Func^.ProcVars.Count -1 do
    begin
      p := Func^.ProcVars.GetItem(I);
      if not p^.Used then
      begin
        MakeHint('', ehVariableNotUsed, p^.VarName)^.Position := p^.DeclarePosition;
      end;
    end;
    if (not Func^.ResUsed) and (Fw(Func^.Decl) <> '-1') then
    begin
      MakeHint('', ehVariableNotUsed, 'RESULT')^.Position := Func^.DeclarePosition;
    end;
  end;

  function IsDuplic(const s: string): Boolean;
  var
    i: Longint;
    u: string;
  begin
    if s = 'RESULT' then
      Result := True
    else if FunctionName = s then
      Result := True
    else if IsDuplicate(s) then
      Result := True
    else
    begin
      u := FunctionDecl;
      while Length(u) > 0 do
      begin
        if D1(GRFW(u)) = s then
        begin
          Result := True;
          exit;
        end;
        GRFW(u);
      end;
      u := FunctionParamNames;
      while Pos('|', u) > 0 do
      begin
        if copy(u, 1, Pos('|', u) - 1) = s then
        begin
          Result := True;
          exit;
        end;
        Delete(u, 1, Pos('|', u));
      end;
      if Func = nil then
      begin
        result := False;
        exit;
      end;
      for i := 0 to Func^.ProcVars.Count -1 do
      begin
        if s = PIFPSProcVar(Func^.ProcVars.GetItem(I))^.VarName then
        begin
          Result := True;
          exit;
        end;
      end;
      for i := 0 to Func^.FLabels.Count -1 do
      begin
        u := Func^.FLabels.GetItem(i);
        delete(u, 1, 4);
        if u = s then
        begin
          Result := True;
          exit;
        end;
      end;
      Result := False;
    end;
  end;
  procedure WriteProcVars(t: TIfList);
  var
    l: Longint;
    v: PIFPSProcVar;
  begin
    for l := 0 to t.Count - 1 do
    begin
      v := t.GetItem(l);
      Func^.Data := Func^.Data  + chr(cm_pt)+ mi2s(v^.VarType);
    end;
  end;

begin
  if FParser.CurrTokenId = CSTII_Procedure then
    FunctionType := ftProc
  else
    FunctionType := ftFunc;
  Func := nil;
  FParser.Next;
  Result := False;
  if FParser.CurrTokenId <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    exit;
  end;
  EPos := FParser.CurrTokenPos;
  FunctionName := FParser.GetToken;
  FuncNo := -1;
  for i := 0 to FProcs.Count -1 do
  begin
    f2 := FProcs.GetItem(i);
    if (f2^.Internal) and (f2^.Name = FunctionName) and (f2^.Forwarded) then
    begin
      Func := FProcs.GetItem(i);
      FuncNo := i;
      Break;
    end;
  end;
  if (Func = nil) and IsDuplicate(FunctionName) then
  begin
    MakeError('', ecDuplicateIdentifier, FunctionName);
    exit;
  end;
  FParser.Next;
  FunctionDecl := '';
  if FParser.CurrTokenId = CSTI_OpenRound then
  begin
    FParser.Next;
    if FParser.CurrTokenId = CSTI_CloseRound then
    begin
      FParser.Next;
    end
    else
    begin
      if FunctionType = ftFunc then
        ParamNo := 1
      else
        ParamNo := 0;
      while True do
      begin
        if FParser.CurrTokenId = CSTII_Var then
        begin
          modifier := '!';
          FParser.Next;
        end
        else
          modifier := '@';
        if FParser.CurrTokenId <> CSTI_Identifier then
        begin
          MakeError('', ecIdentifierExpected, '');
          exit;
        end;
        if IsDuplic(FParser.GetToken) then
        begin
          MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
          exit;
        end;
        FunctionParamNames := FParser.GetToken + '|';
        if @FOnUseVariable <> nil then
        begin
          FOnUseVariable(Self, ivtParam, ParamNo, FProcs.Count, FParser.CurrTokenPos);
        end;
        inc(ParamNo);
        FParser.Next;
        while FParser.CurrTokenId = CSTI_Comma do
        begin
          FParser.Next;
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          if IsDuplic(FParser.GetToken) then
          begin
            MakeError('', ecDuplicateIdentifier, '');
            exit;
          end;
          if @FOnUseVariable <> nil then
          begin
            FOnUseVariable(Self, ivtParam, ParamNo, FProcs.Count, FParser.CurrTokenPos);
          end;
          inc(ParamNo);
          FunctionParamNames := FunctionParamNames + FParser.GetToken +
            '|';
          FParser.Next;
        end;
        if FParser.CurrTokenId <> CSTI_Colon then
        begin
          MakeError('', ecColonExpected, '');
          exit;
        end;
        FParser.Next;
        FunctionTempType := at2ut(ReadType('', FParser));
        if FunctionTempType = Cardinal(-1) then
        begin
          exit;
        end;
        while Pos('|', FunctionParamNames) > 0 do
        begin
          FunctionDecl := FunctionDecl + ' ' + modifier +
            copy(FunctionParamNames, 1, Pos('|', FunctionParamNames) - 1)
            + ' '
            + inttostr(Longint(FunctionTempType));
          Delete(FunctionParamNames, 1, Pos('|', FunctionParamNames));
        end;
        if FParser.CurrTokenId = CSTI_CloseRound then
          break;
        if FParser.CurrTokenId <> CSTI_Semicolon then
        begin
          MakeError('', ecSemicolonExpected, '');
          exit;
        end;
        FParser.Next;
      end;
      FParser.Next;
    end;
  end;
  if FunctionType = ftFunc then
  begin
    if FParser.CurrTokenId <> CSTI_Colon then
    begin
      MakeError('', ecColonExpected, '');
      exit;
    end;
    FParser.Next;
    FunctionTempType := at2ut(ReadType('', FParser));
    if FunctionTempType = Cardinal(-1) then
      exit;
    FunctionDecl := inttostr(Longint(FunctionTempType)) + FunctionDecl;
  end
  else
    FunctionDecl := '-1' + FunctionDecl;
  if FParser.CurrTokenId <> CSTI_Semicolon then
  begin
    MakeError('', ecSemicolonExpected, '');
    exit;
  end;
  FParser.Next;
  if (Func = nil) and (FParser.CurrTokenID = CSTII_External) then
  begin
    FParser.Next;
    if FParser.CurrTokenID <> CSTI_String then
    begin
      MakeError('', ecStringExpected, '');
      exit;
    end;
    FunctionParamNames := FParser.GetToken;
    FunctionParamNames := copy(FunctionParamNames, 2, length(FunctionParamNames) - 2);
    FParser.Next;
    if FParser.CurrTokenID <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
    pp := FOnExternalProc(Self, FunctionName, FunctionDecl, FunctionParamNames);
    if pp = nil then
    begin
      MakeError('', ecCustomError, '');
      exit;
    end;
    new(pp2);
    pp2^.Internal := false;
    pp2^.RP := pp;
    FProcs.Add(pp2);
    FRegProcs.Add(pp);
    Result := True;
    Exit;
  end else if (Func = nil) and (FParser.CurrTokenID = CSTII_Forward) then
  begin
    FParser.Next;
    if FParser.CurrTokenID  <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      Exit;
    end;
    FParser.Next;
    Func := NewProc(FunctionName);
    Func^.Forwarded := True;
    Func^.DeclarePosition := EPos;
    Result := True;
    exit;
  end;
  if (Func = nil) then
  begin
    Func := NewProc(FunctionName);
    Func^.Decl := FunctionDecl;
    Func^.DeclarePosition := EPos;
    FuncNo := FProcs.Count -1;
  end else begin
    Func^.Forwarded := False;
  end;
  if FParser.CurrTokenID = CSTII_Export then
  begin
    FParser.Next;
    if FParser.CurrTokenID <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
    Func^.FExport := 1;
  end;
  while FParser.CurrTokenId <> CSTII_Begin do
  begin
    if FParser.CurrTokenId = CSTII_Var then
    begin
      if not DoVarBlock(Func) then
        exit;
    end else if FParser.CurrTokenId = CSTII_Label then
    begin
      if not ProcessLabel(Func) then
        Exit;
    end else
    begin
      MakeError('', ecBeginExpected, '');
      exit;
    end;
  end;
  Debug_WriteParams(FuncNo, Func);
  WriteProcVars(Func^.ProcVars);
  if not ProcessSub(tProcBegin, FuncNo, Func) then
  begin
    exit;
  end;
  CheckVars(Func);
  ProcessLabelForwards(Func);
  Result := True;
end;

function TIFPSPascalCompiler.DoTypeBlock(FParser: TIfPascalParser): Boolean;
var
  VName: string;
begin
  Result := False;
  FParser.Next;
  if FParser.CurrTokenId <> CSTI_Identifier then
  begin
    MakeError('', ecIdentifierExpected, '');
    exit;
  end;
  repeat
    VName := FParser.GetToken;
    if IsDuplicate(VName) then
    begin
      MakeError('', ecDuplicateIdentifier, FParser.OriginalToken);
      exit;
    end;

    FParser.Next;
    if FParser.CurrTokenId <> CSTI_Equal then
    begin
      MakeError('', ecIsExpected, '');
      exit;
    end;
    FParser.Next;
    if ReadType(VName, FParser) = Cardinal(-1) then
    begin
      Exit;
    end;
    if FParser.CurrTokenID <> CSTI_Semicolon then
    begin
      MakeError('', ecSemicolonExpected, '');
      Exit;
    end;
    FParser.Next;
  until FParser.CurrTokenId <> CSTI_Identifier;
  Result := True;
end;


function TIFPSPascalCompiler.ProcessSub(FType: TSubOptType; ProcNo: Cardinal; proc: PIFPSProcedure): Boolean;


  procedure Debug_WriteLine;
  var
    b: Boolean;
  begin
    if @FOnWriteLine <> nil then begin
      b := FOnWriteLine(Self, FParser.CurrTokenPos);
    end else
      b := true;
    if b then Debug_SavePosition(ProcNo, proc);
  end;

  procedure WriteCommand(b: Byte);
  begin
    proc^.Data := proc^.Data + Char(b);
  end;

  procedure WriteByte(b: Byte);
  begin
    proc^.Data := proc^.Data + Char(b);
  end;

  procedure WriteData(const Data; Len: Longint);
  begin
    SetLength(proc^.Data, Length(proc^.Data) + Len);
    Move(Data, proc^.Data[Length(proc^.Data) - Len + 1], Len);
  end;

  function ReadReal(const s: string): PIfRVariant;
  var
    C: Integer;
  begin
    New(Result);
    Result^.FType := GetType(btExtended);
    SetLength(Result^.Value, SizeOf(TbtExtended));
    Val(s, TbtExtended((@Result^.Value[1])^), C);
  end;

  function ReadString: PIfRVariant;

    function ParseString: string;
    var
      temp3: string;

      function ChrToStr(s: string): Char;
      begin
        Delete(s, 1, 1); {First char : #}
        ChrToStr := Chr(StrToInt(s));
      end;

      function PString(s: string): string;
      begin
        s := copy(s, 2, Length(s) - 2);
        PString := s;
      end;
    begin
      temp3 := '';
      while (FParser.CurrTokenId = CSTI_String) or (FParser.CurrTokenId =
        CSTI_Char) do
      begin
        if FParser.CurrTokenId = CSTI_String then
        begin
          temp3 := temp3 + PString(FParser.GetToken);
          FParser.Next;
          if FParser.CurrTokenId = CSTI_String then
            temp3 := temp3 + #39;
        end {if}
        else
        begin
          temp3 := temp3 + ChrToStr(FParser.GetToken);
          FParser.Next;
        end; {else if}
      end; {while}
      ParseString := temp3;
    end;

  begin
    New(Result);
    Result^.FType := GetType(btString);
    Result^.Value := ParseString;
  end;

  function ReadInteger(const s: string): PIfRVariant;
  var
    C: Integer;
    {$IFNDEF NOINT64}e: Int64;{$ENDIF}
  begin
    {$IFNDEF NOINT64}
    e := StrToInt64Def(s, -1);
    if (e and $FFFFFFFF) = E then
    begin
      New(Result);
      Result^.FType := GetType(btS32);
      SetLength(Result^.Value, SizeOf(TbtS32));
      Val(s, TbtS32((@Result^.Value[1])^), C);
      if TbtS32((@Result^.Value[1])^) < 0 then
      begin
        Val(s, TbtU32((@Result^.Value[1])^), C);
      end;
    end else begin
      New(Result);
      Result^.FType := GetType(btS64);
      SetLength(Result^.Value, SizeOf(TbtS64));
      tbts64((@Result^.Value[1])^) := e;
    end;
    {$ELSE}
    New(Result);
    Result^.FType := GetType(btS32);
    SetLength(Result^.Value, SizeOf(TbtS32));
    Val(s, TbtS32((@Result^.Value[1])^), C);
    if TbtS32((@Result^.Value[1])^) < 0 then
    begin
      Val(s, TbtU32((@Result^.Value[1])^), C);
    end;
    {$ENDIF}
  end;

  procedure WriteLong(l: Cardinal);
  begin
    WriteData(l, 4);
  end;

  procedure WriteVariant(p: PIfRVariant);
  var
    px: PIFPSType;
  begin
    WriteLong(p^.FType);
    px := FUsedTypes.GetItem(p^.FType);
    if px^.BaseType = btString then
    begin
      WriteLong(Length(p^.Value));
      WriteData(p^.Value[1], Length(p^.Value));
    end
    else if px^.BaseType = btenum then
    begin
      if Longint(px^.Ext) <=256 then
        WriteData(p^.Value[1], 1)
      else if Longint(px^.Ext) <=65536 then
        WriteData(p^.Value[1], 2)
      else
        WriteData(p^.Value[1], 4);
    end else
    begin
      WriteData(p^.Value[1], Length(p^.Value));
    end;
  end;

  function GetParamType(I: Longint): Cardinal;
  var
    u, n: string;
  begin
    u := proc^.Decl;
    Inc(I);
    n := GRFW(u);
    if (I = 0) and (n <> '-1') then
    begin
      Result := StrToIntDef(n, -1);
      exit;
    end
    else if n <> '-1' then
      Inc(I);
    while I < 0 do
    begin
      GRFW(u);
      GRFW(u);
      Inc(I);
    end;
    GRFW(u);
    Result := StrToIntDef(GRFW(u), -1);
  end;
  function GetRecordTypeNo(x: PIFPSValue): Cardinal;
  var
    rr: PIFRecField;
  begin
    rr := x^.RecField.GetItem(x^.RecField.Count - 1);
    Result := rr^.FType;
  end;
  function AllocStackReg(FType: Cardinal): PIFPSValue;
  var
    x: PIFPSProcVar;
  begin
    New(x);
    x^.DeclarePosition := FParser.CurrTokenPos;
    x^.VarName := '';
    x^.NameHash := MakeHash(x^.VarName);
    x^.VarType := FType;
    proc^.ProcVars.Add(x);
    New(Result);
    Result^.FType := CVAL_AllocatedStackReg;
    Result^.DPos := FParser.CurrTokenPos;
    Result^.Address := IFPSAddrStackStart + proc^.ProcVars.Count;
    Result^.RecField := nil;
    Result^.Modifiers := 0;
    WriteCommand(Cm_Pt);
    WriteLong(FType);
  end;

  function AllocStackReg2(FType: Cardinal): PIFPSValue;
  var
    x: PIFPSProcVar;
  begin
    New(x);
    x^.VarName := '';
    x^.NameHash := MakeHash(x^.VarName);
    x^.VarType := FType;
    proc^.ProcVars.Add(x);
    New(Result);
    Result^.FType := CVAL_AllocatedStackReg;
    Result^.RecField := nil;
    Result^.Modifiers := 0;
    Result^.Address := IFPSAddrStackStart + proc^.ProcVars.Count;
  end;
  function WriteCalculation(InData, OutReg: PIFPSValue): Boolean; forward;

  procedure DisposeStackReg(p: PIFPSValue);
  begin
    Dispose(
    PIFPSProcVar(proc^.ProcVars.GetItem(p^.Address - IFPSAddrStackStart - 1))
    );
    proc^.ProcVars.Delete(proc^.ProcVars.Count - 1);
    DisposePValue(p);
    WriteCommand(CM_PO);
  end;
  function GetTypeNo(p: PIFPSValue): Cardinal; forward;

  function WriteOutRec(x: PIFPSValue; AllowData: Boolean): Boolean; forward;
  procedure AfterWriteOutRec(var x: PIFPSValue); forward;
  function FindProc(const Name: string): Cardinal; forward;
  function checkCompatType2(p1, p2: PIFPSType): Boolean;
  begin
    if
      ((p1^.BaseType = btProcPtr) and (p2 = p1)) or
      (p1^.BaseType = btVariant) or
      (p2^.baseType = btVariant) or
      (IsIntType(p1^.BaseType) and IsIntType(P2^.BaseType)) or
      (IsRealType(p1^.BaseType) and IsIntRealType(P2^.BaseType)) or
      ((p1^.BaseType = btString) and (P2^.BaseType = btString)) or
      ((p1^.BaseType = btString) and (P2^.BaseType = btChar)) or
      ((p1^.BaseType = btArray) and (p2^.BaseType = btArray)) or
      ((p1^.BaseType = btChar) and (p2^.BaseType = btChar)) or
      ((p1^.BaseType = btRecord) and (p2^.BaseType = btrecord)) or
      ((p1^.BaseType = btEnum) and (p2^.BaseType = btEnum))
      then
      Result := True
    else if ((P1^.BaseType = btclass) and (p2^.Basetype = btClass)) then
    begin
      Result :=p1^.Ex.IsCompatibleWith(p2^.Ex);
    end else

      Result := False;
  end;

  function CheckCompatType(V1, v2: PIFPSValue): Boolean;
  var
    p1, P2: PIFPSType;
  begin
    if (v1^.Modifiers and 4) <> 0 then
    begin
      Result := True;
      exit;
    end;
    p1 := FUsedTypes.GetItem(GetTypeNo(V1));
    P2 := FUsedTypes.GetItem(GetTypeNo(v2));
    if (p1^.BaseType = btChar) and (p2^.BaseType = btString) and (v2^.FType = CVAL_Data) and (length(V2^.FData^.Value) = 1) then
    begin
      v2^.FData^.FType := GetType(btChar);
      P2 := FUsedTypes.GetItem(GetTypeNo(v2));
    end;
    Result := CheckCompatType2(p1, p2);
  end;

  function ProcessFunction(ResModifiers: Byte; ProcNo: Cardinal; InData: TIfList;
    ResultRegister:
    PIFPSValue): Boolean; forward;
  function ProcessVarFunction(ResModifiers: Byte; ProcNo: PIFPSValue; InData: TIfList;
    ResultRegister:
    PIFPSValue): Boolean; forward;

  function MakeNil(NilPos: Cardinal;ivar: PIFPSValue): Boolean;
  var
    Procno: Cardinal;
    PF: PIFPSType;
    Par: TIfList;
    pp: PParam;
  begin
    Pf := FUsedTypes.GetItem(GetTypeNo(IVar));
    if (pf^.BaseType <> btClass) or (not pf.Ex.SetNil(GetTypeno(IVar), ProcNo)) or ((Ivar.FType <> CVAL_Addr)and(Ivar.FType <> CVAL_AllocatedStackReg)) then
    begin
      MakeError('', ecTypeMismatch, '')^.Position := nilPos;
      Result := False;
      exit;
    end;
    ivar.FType := CVAL_PushAddr;
    ivar.Modifiers := ivar.modifiers or 128;
    Par := TIfList.Create;
    new(pp);
    pp^.InReg := ivar;
    pp^.OutReg := nil;
    pp^.FType := GetTypeNo(ivar);
    pp^.OutRegPos := NilPos;
    par.add(pp);
    Result := ProcessFunction(0, ProcNo, Par, nil);
    Dispose(pp);
    Par.Free;
    ivar.Modifiers := ivar.modifiers and not 128;
  end;

  function PreWriteOutRec(var X: PIFPSValue; FArrType: Cardinal): Boolean;
  var
    rr: PIFRecField;
    tmpp,
      tmpc: PIFPSValue;
    i: Longint;
  begin
    Result := True;
    if x^.FType = CVAL_NIL then
    begin
      if FArrType = Cardinal(-1) then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        Exit;
      end;
      tmpp := AllocStackReg(FArrType);
      if not MakeNil(x^.DPos, tmpp) then
      begin
        Result := False;
        exit;
      end;
      tmpp^.FType := CVAL_ArrayAllocatedStackRec;
      x := tmpp;
    end else
    if x^.FType = CVAL_Array then
    begin
      if FArrType = Cardinal(-1) then
      begin
        MakeError('', ecTypeMismatch, '');
        Result := False;
        Exit;
      end;
      tmpp := AllocStackReg(FArrType);
      tmpp^.FType := CVAL_ArrayAllocatedStackRec;
      tmpc := AllocStackReg(GetType(bts32));
      WriteCommand(CM_A);
      WriteOutrec(tmpc, False);
      WriteByte(1);
      WriteLong(GetType(bts32));
      WriteLong(x^.ArrayItems.Count);
      WriteCommand(CM_PV);
      WriteOutrec(tmpp, False);
      WriteCommand(CM_C);
      WriteLong(FindProc('SETARRAYLENGTH'));
      WriteCommand(CM_PO);
      DisposeStackReg(tmpc);
      new(tmpc);
      tmpc^.FType := CVAL_Addr;
      tmpc^.Modifiers := 0;
      tmpc^.DPos := tmpp^.DPos;
      tmpc^.Address := tmpp^.Address;
      tmpc^.RecField := TIFList.Create;
      new(rr);
      rr^.FKind := 1;
      rr^.FType := Cardinal(PIFPSType(FUsedTypes.GetItem(FArrType))^.Ext);
      tmpc^.RecField.Add(rr);
      for i := 0 to x^.ArrayItems.Count -1 do
      begin
        rr^.ArrayFieldNo := i;
        if not WriteCalculation(x^.ArrayItems.GetItem(i), tmpc) then
        begin
          DisposePValue(tmpc);
          DisposeStackReg(tmpp);
          Result := False;
          Exit;
        end;
      end;
      x := tmpp;
    end else if (x^.FType = CVAL_Eval) then
    begin
      tmpp := AllocStackReg(x^.frestype);
      WriteCalculation(x, tmpp);
      if x^.Modifiers = 1 then
      begin
        WriteCommand(cm_bn);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end else
      if x^.Modifiers = 2 then
      begin
        WriteCommand(cm_vm);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end;
      tmpp^.DPos := cardinal(x);
      x := tmpp;
      x^.FType := CVAL_AllocatedStackReg + 1;
    end else if (x^.FType = CVAL_Proc) or (x^.FType = CVAL_VarProc) then
    begin
      if x^.FType = CVAL_VarProc then
      begin
        tmpp := AllocStackReg(StrToIntDef(Fw(PIFPSProceduralType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(x^._ProcNo)))^.Ext)^.ProcDef), -1));
      end else if PIFPSProcedure(FProcs.GetItem(x^.ProcNo))^.Internal then
        tmpp := AllocStackReg(StrToIntDef(Fw(PIFPSProcedure(FProcs.GetItem(x^.ProcNo))^.Decl), -1))
      else
        tmpp := AllocStackReg(StrToIntDef(Fw(PIFPSUsedRegProc(FPRocs.GetItem(x^.ProcNo))^.RP^.Decl), -1));
      WriteCalculation(x, tmpp);
      if x^.Modifiers = 1 then
      begin
        WriteCommand(cm_bn);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end else
      if x^.Modifiers = 2 then
      begin
        WriteCommand(cm_vm);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end;
      tmpp^.DPos := cardinal(x);
      x := tmpp;
      x^.FType := CVAL_AllocatedStackReg + 1;
   end else
    if ((x^.FType = CVAL_Addr) or (x^.FType = CVAL_PushAddr)) and (x^.RecField <> nil) then
    begin
      if x^.RecField.Count = 1 then
      begin
        rr := x^.RecField.GetItem(0);
        if rr^.FKind < 2 then
          exit; // there is no need pre-calculate anything
        if rr^.ReadArrayFieldNoFrom^.FType = CVAL_Addr then
          exit;
      end; //if
      tmpp := AllocStackReg(GetType(btPointer));
      WriteCommand(cm_sp);
      WriteOutRec(tmpp, True);
      WriteByte(0);
      WriteLong(x^.Address);

      for i := 0 to x^.RecField.Count - 1 do
      begin
        rr := x^.RecField.GetItem(I);
        case rr^.FKind of
          0, 1:
            begin
              WriteCommand(cm_sp);
              WriteOutRec(tmpp, false);
              WriteByte(2);
              WriteLong(tmpp^.Address);
              WriteLong(rr^.RecFieldNo);
            end; // case 0,1
          2:
            begin
              tmpc := AllocStackReg(GetType(btU32));
              if not WriteCalculation(rr^.ReadArrayFieldNoFrom, tmpc) then
              begin
                DisposeStackReg(tmpc);
                DisposeStackReg(tmpp);
                Result := False;
                exit;
              end; //if
              WriteCommand(cm_sp);
              WriteOutRec(tmpp, false);
              WriteByte(3);
              WriteData(tmpp^.Address, 4);
              WriteData(tmpc^.Address, 4);
              DisposeStackReg(tmpc);
            end; // case 2
        end; // case
        Dispose(rr);
      end; // for
      if x^.Modifiers = 1 then
      begin
        WriteCommand(cm_bn);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end else
      if x^.Modifiers = 2 then
      begin
        WriteCommand(cm_vm);
        WriteByte(0);
        WriteLong(Tmpp^.Address);
      end;
      x^.RecField.Clear;
      new(rr);
      rr^.FKind := 3;
      rr^.ResultRec := tmpp;
      x^.RecField.Add(rr);
    end else if (x^.Modifiers and 3) <> 0 then
    begin
      if x^.FType = CVAL_Addr then
      begin
        tmpp := AllocStackReg(GetTypeNo(x));
        tmpp^.FType := CVAL_AllocatedStackReg + 1;
        WriteCommand(CM_A);
        WriteByte(0);
        WriteLong(tmpp^.Address);
        WriteByte(0);
        WriteLong(x^.Address);
        if x^.Modifiers = 1 then
        begin
          WriteCommand(cm_bn);
          WriteByte(0);
          WriteLong(Tmpp^.Address);
        end else
        if x^.Modifiers = 2 then
        begin
          WriteCommand(cm_vm);
          WriteByte(0);
          WriteLong(Tmpp^.Address);
        end;
        tmpp^.DPos := cardinal(x);
        x := tmpp;
      end else if x^.FType = CVAL_PushAddr then
      begin
        if x^.Modifiers = 1 then
        begin
          WriteCommand(cm_bn);
          WriteByte(0);
          WriteLong(x^.Address);
        end else
        if x^.Modifiers = 2 then
        begin
          WriteCommand(cm_vm);
          WriteByte(0);
          WriteLong(x^.Address);
        end;
      end;
    end;
  end;

  procedure AfterWriteOutRec(var x: PIFPSValue);
  var
    rr: PIFRecField;
    p: Pointer;
  begin
    if x^.FType = CVAL_ArrayAllocatedStackRec then
    begin
      DisposeStackReg(x);
    end else
    if x^.FType = CVAL_AllocatedStackReg +1 then
    begin
      p := Pointer(x^.DPos);
      DisposeStackReg(x);
      x := p;
    end else if ((x^.FType = CVAL_Addr) or (x^.FType = CVAL_PushAddr)) and (x^.RecField <> nil) then
    begin
      rr := x^.RecField.GetItem(0);
      if (rr^.FKind = 3) then
      begin
        DisposeStackReg(rr^.ResultRec);
        Dispose(Rr);
        x^.RecField.Free;
        x^.RecField := nil;
      end;
    end;
  end; //afterwriteoutrec

  function WriteOutRec(x: PIFPSValue; AllowData: Boolean): Boolean;
  var
    rr: PIFRecField;
  begin
    Result := True;
    case x^.FType of
      CVAL_ArrayAllocatedStackRec, CVAL_Addr, CVAL_PushAddr, CVAL_AllocatedStackReg, CVAL_AllocatedStackReg + 1:
        begin
          if x^.RecField = nil then
          begin
            WriteByte(0);
            WriteData(x^.Address, 4);
          end
          else
          begin
            rr := x^.RecField.GetItem(0);
            case rr^.FKind of
              0, 1:
                begin
                  WriteByte(2);
                  WriteLong(x^.Address);
                  WriteLong(rr^.RecFieldNo);
                end;
              2:
                begin
                  WriteByte(3);
                  WriteLong(x^.Address);
                  WriteLong(rr^.ReadArrayFieldNoFrom^.Address);
                end;
              3:
                begin
                  WriteByte(0);
                  WriteLong(rr^.ResultRec^.Address);
                end;
            end;
          end;
        end;
      CVAL_Data:
        if AllowData then
        begin
          WriteByte(1);
          WriteVariant(x^.FData)
        end
        else
        begin
          Result := False;
          exit;
        end;
    else
      Result := False;
    end;
  end;

  function GetTypeNo(p: PIFPSValue): Cardinal;
  var
    n: PIFPSProcedure;
  begin
    if (p^.Modifiers and 8) <> 0 then
    begin
      Result := p^.FNewTypeNo;
      exit;
    end;
    if (p^.RecField <> nil) and (p^.FType = CVAL_Addr) then
    begin
      Result := GetRecordTypeNo(p);
    end
    else
      case p^.FType of
        CVAL_Cast:
        begin
          Result := p^.NewTypeNo;
        end;
        CVAL_Array:
        begin
          Result := at2ut(FindType('TVariantArray'));
        end;
        CVAL_ArrayAllocatedStackRec, CVAL_Addr, CVAL_AllocatedStackReg, CVAL_PushAddr:
          begin
            if p^.Address < IFPSAddrNegativeStackStart then
            begin
              if p^.Address < FVars.Count then
              begin
                Result := PIFPSVar(FVars.GetItem(p^.Address))^.FType;
              end
              else
                Result := Cardinal(-1);
            end
            else
            begin
              if p^.Address < IFPSAddrStackStart then
              begin
                Result := GetParamType(p^.Address - IFPSAddrStackStart);
              end
              else
                Result := PIFPSProcVar(proc^.ProcVars.GetItem(p^.Address - 1 -
                  IFPSAddrStackStart))^.VarType;
            end;
          end;
        CVAL_Data: Result := p^.FData^.FType;
        CVAL_VarProc:
          begin
            Result := StrToIntDef(Fw(PIFPSProceduralType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(p^._ProcNo)))^.Ext)^.ProcDef), -1);
          end;
        CVAL_Proc:
          begin
            n := PIFPSProcedure(FProcs.GetItem(p^.ProcNo));

            if n^.Internal then
              Result := StrToIntDef(Fw(n^.Decl), -1)
            else
              Result := StrToIntDef(Fw(PIFPSUsedRegProc(n)^.RP^.Decl), -1);
          end;
        CVAL_Eval: Result := p^.frestype;
      else
        Result := Cardinal(-1);
      end;
  end;

  function ReadParameters(ProcNo: Cardinal; FSelf: PIFPSValue): PIFPSValue; forward;

  function FindProc(const Name: string): Cardinal;
  var
    l, h: Longint;
    x: PIFPSUsedRegProc;

  begin
    h := MakeHash(Name);
    for l := 0 to FProcs.Count - 1 do
    begin
      if PIFPSProcedure(FProcs.GetItem(l))^.Internal then
      begin
        if (PIFPSProcedure(FProcs.GetItem(l))^.NameHash = h) and
          (PIFPSProcedure(FProcs.GetItem(l))^.Name = Name) then
        begin
          Result := l;
          exit;
        end;
      end
      else
      begin
        if (PIFPSUsedRegProc(FProcs.GetItem(l))^.RP^.NameHash = h) and
          (PIFPSUsedRegProc(FProcs.GetItem(l))^.RP^.Name = Name) then
        begin
          Result := l;
          exit;
        end;
      end;
    end;
    for l := 0 to FRegProcs.Count - 1 do
    begin
      if (PIFPSRegProc(FRegProcs.GetItem(l))^.NameHash = h) and
        (PIFPSRegProc(FRegProcs.GetItem(l))^.Name = Name) then
      begin
        New(x);
        x^.Internal := False;
        x^.RP := FRegProcs.GetItem(l);
        ReplaceTypes(x^.Rp^.Decl);
        FProcs.Add(x);
        Result := FProcs.Count - 1;
        exit;
      end;
    end;
    Result := Cardinal(-1);
  end; {findfunc}

  function calc(endOn: TIfPasToken): PIFPSValue; forward;

  function ReadVarParameters(ProcNoVar: PIFPSValue): PIFPSValue; forward;

  function GetIdentifier(const FType: Byte): PIFPSValue;
    {
      FType:
        0 = Anything
        1 = Only variables
        2 = Not constants
    }
  var
    Temp: PIFPSValue;
    l, h: Longint;
    s, u: string;
    t: PIFPSConstant;
    Temp1: Cardinal;

    procedure CheckProcCall(var x: PIFPSValue);
    begin
      if FParser.CurrTokenId = CSTI_Dereference then
      begin
        if PIFPSType(FUsedTypes.GetItem(GetTypeNo(x)))^.BaseType <> btProcPtr then
        begin
          MakeError('', ecTypeMismatch, '');
          DisposePValue(x);
          x := nil;
          Exit;
        end;
        FParser.Next;
        x := ReadVarParameters(x);
      end;
    end;

    procedure CheckFurther(var x: PIFPSValue);
    var
      t: Cardinal;
      rr: PIFRecField;
      LastRecType, I, LL: Longint;
      u: PIFPSType;
      Param: PParam;
      NewRecFields: TIfList;
      tmp, tmp3: PIFPSValue;
      tmp2: Boolean;

      function FindSubR(const n: string; FType: PIFPSType): Cardinal;
      var
        h, I: Longint;
      begin
        h := MakeHash(n);
        for I := 0 to FType.RecordSubVals.Count - 1 do
        begin
          if
            (PIFPSRecordType(FType.RecordSubVals.GetItem(I))^.FieldNameHash =
            h) and
            (PIFPSRecordType(FType.RecordSubVals.GetItem(I))^.FieldName = n)
              then
          begin
            Result := I;
            exit;
          end;
        end;
        Result := Cardinal(-1);
      end;

    begin
      if (x^.FType <> CVAL_Addr) and (x^.FType <> CVAL_PushAddr) and (x^.FType <> CVAL_AllocatedStackReg) then
        Exit;
      x.RecField := nil;
      t := GetTypeNo(x);
      u := FUsedTypes.GetItem(t);
      if u^.BaseType = btClass then exit;
      while True do
      begin
        if FParser.CurrTokenId = CSTI_OpenBlock then
        begin
          if (u^.BaseType = btString) and (x^.FType = CVAL_Addr) then
          begin
            x^.FType := CVAL_PushAddr;
             FParser.Next;
            tmp := Calc(CSTI_CloseBlock);
            if tmp = nil then
            begin
              DisposePValue(x);
              x := nil;
              exit;
            end;
            if not IsIntType(PIFPSType(FUSedTypes.GetItem(GetTypeNo(tmp)))^.BaseType) then
            begin
              MakeError('', ecTypeMismatch, '');
              DisposePValue(tmp);
              DisposePValue(x);
              x := nil;
              exit;
            end;
            FParser.Next;
            if FParser.CurrTokenId = CSTI_Assignment then
            begin
              l := FindProc('STRSET');
              if l = -1 then
              begin
                MakeError('', ecUnknownIdentifier, 'StrGet');
                DisposePValue(tmp);
                DisposePValue(x);
                x := nil;
                exit;
              end;
              New(tmp3);
              tmp3^.FType :=CVAL_Proc;
              tmp3^.Modifiers := 0;
              tmp3^.DPos := FParser.CurrTokenPos;
              tmp3^.ProcNo := L;
              tmp3^.Parameters := TIfList.Create;
              new(Param);
              tmp3^.Parameters.Add(Param);
              new(Param);
              param^.InReg := tmp;
              Param^.FType := GetTypeNo(tmp);
              Param^.OutReg := nil;
              Param^.OutRegPos := tmp^.DPos;
              tmp3^.Parameters.Add(Param);
              new(Param);
              param^.InReg := x;
              Param^.FType := GetTypeNo(x);
              Param^.OutReg := nil;
              Param^.OutRegPos := tmp^.DPos;
              tmp3^.Parameters.Add(Param);
              Param := tmp3^.Parameters.GetItem(0);
              x := tmp3;
              FParser.Next;
              tmp := Calc(CSTI_SemiColon);
              if (Tmp^.FType = CVAL_DATA) and (PIFPSType(FUSedTypes.GetItem(Tmp^.FData^.FType))^.BaseType = btString) then
              begin
                if Length(Tmp^.FData^.Value) <> 1 then
                begin
                  MakeError('', ecTypeMismatch, '');
                  DisposePValue(Tmp);
                  x^.Parameters.Delete(0);
                  DisposePValue(x);
                  x := nil;
                  exit;
                end;
                Tmp^.FData^.FType := GetType(btChar);
              end;
              if PIFPSType(FUSedTypes.GetItem(Tmp^.FData^.FType))^.BaseType <> btChar then
              begin
                MakeError('', ecTypeMismatch, '');
                DisposePValue(Tmp);
                x^.Parameters.Delete(0);
                DisposePValue(x);
                x := nil;
                exit;
              end;
              if tmp = nil then
              begin
                x^.Parameters.Delete(0);
                DisposePValue(x);
                x := nil;
                exit;
              end;
              Param^.InReg := tmp;
              Param^.OutReg := nil;
              param^.FType := GetTypeNo(tmp);
              Param^.OutRegPos := tmp^.DPos;
            end else begin
              l := FindProc('STRGET');
              if l = -1 then
              begin
                MakeError('', ecUnknownIdentifier, 'StrGet');
                DisposePValue(tmp);
                DisposePValue(x);
                x := nil;
                exit;
              end;
              New(tmp3);
              tmp3^.FType :=CVAL_Proc;
              tmp3^.Modifiers := 0;
              tmp3^.DPos := FParser.CurrTokenPos;
              tmp3^.ProcNo := L;
              tmp3^.Parameters := TIfList.Create;
              new(Param);
              param^.InReg := x;
              Param^.FType := GetTypeNo(x);
              Param^.OutReg := nil;
              Param^.OutRegPos := tmp^.DPos;
              tmp3^.Parameters.Add(Param);
              new(Param);
              param^.InReg := tmp;
              Param^.FType := GetTypeNo(tmp);
              Param^.OutReg := nil;
              Param^.OutRegPos := tmp^.DPos;
              tmp3^.Parameters.Add(Param);
              x := tmp3;
            end;
            Break;
          end else if u^.BaseType = btArray then
          begin
            FParser.Next;
            tmp := calc(CSTI_CloseBlock);
            if tmp = nil then
            begin
              DisposePValue(x);
              x := nil;
              exit;
            end;
            if not IsIntType(PIFPSType(FUSedTypes.GetItem(GetTypeNo(tmp)))^.BaseType) then
            begin
              MakeError('', ecTypeMismatch, '');
              DisposePValue(tmp);
              DisposePValue(x);
              x := nil;
              exit;
            end;
            if tmp^.FType = CVAL_Data then
            begin
              if x.RecField = nil then
                x.RecField := TIfList.Create;
              new(rr);
              rr^.FKind := 1;
              rr^.ArrayFieldNo := GetUInt(FUsedTypes, tmp^.FData, tmp2);
              rr^.FType := Cardinal(u^.Ext);
              u := FUsedTypes.GetItem(Cardinal(u^.Ext));
              x^.RecField.Add(rr);
            end
            else
            begin
              if x.RecField = nil then
                x.RecField := TIfList.Create;
              new(rr);
              rr^.FKind := 2;
              rr^.ReadArrayFieldNoFrom := tmp;
              rr^.FType := Cardinal(u^.Ext);
              u := FUsedTypes.GetItem(Cardinal(u^.Ext));
              x^.RecField.Add(rr);
            end;
            if FParser.CurrTokenId <> CSTI_CloseBlock then
            begin
              MakeError('', ecCloseBlockExpected, '');
              DisposePValue(x);
              x := nil;
              exit;
            end;
            Fparser.Next;
          end else begin
            MakeError('', ecSemicolonExpected, '');
            DisposePValue(x);
            x := nil;
            exit;
          end;
        end
        else if FParser.CurrTokenId = CSTI_Period then
        begin
          FParser.Next;
          if u^.BaseType = btRecord then
          begin
            t := FindSubR(FParser.GetToken, u);
            if t = Cardinal(-1) then
            begin
              MakeError('', ecUnknownIdentifier, '');
              DisposePValue(x);
              x := nil;
              exit;
            end;
            FParser.Next;
            if x.RecField = nil then
              x.RecField := TIfList.Create;
            new(rr);
            rr^.FKind := 0;
            rr^.FType := PIFPSRecordType(u^.RecordSubVals.GetItem(t))^.FType;
            rr^.RecFieldNo := t;
            u := FUsedTypes.GetItem(rr^.FType);
            x^.RecField.Add(rr);
          end
          else
          begin
            DisposePValue(x);
            MakeError('', ecSemicolonExpected, '');
            x := nil;
            exit;
          end;
        end
        else
          break;
      end;
      if x^.RecField = nil then
        exit;
      LL := -1;
      NewRecFields := TIfList.Create;
      if x^.FType = 0 then
      begin
        if x^.Address < IFPSAddrNegativeStackStart then
          LastRecType := PIFPSVar(FVars.GetItem(x^.Address))^.FType
        else if x^.Address < IFPSAddrStackStart then
        begin
          LastRecType := GetParamType(Longint(x^.Address - IFPSAddrStackStart));
        end
        else
          LastRecType := PIFPSProcVar(proc^.ProcVars.GetItem(x^.Address - 1 - IFPSAddrStackStart))^.VarType;
        i := 0;
        u := FUsedTypes.GetItem(LastRecType);

        while i < Longint(x^.RecField.Count) do
        begin
          rr := x^.RecField.GetItem(I);
          case rr^.FKind of
            0:
              begin
                if LL = -1 then
                  inc(ll);
                LastRecType := rr^.FType;
                LL := LL + Longint(PIFPSRecordType(u^.RecordSubVals.GetItem(rr^.RecFieldNo))^.RealFieldOffset);
                u := FUsedTypes.GetItem(LastRecType);
                dispose(rr);
              end;
            1:
              begin
                if LL <> -1 then
                begin
                  new(rr);
                  rr^.FKind := 0;
                  rr^.RecFieldNo := LL;
                  rr^.FType := LastRecType;
                  newRecFields.Add(Rr);
                  rr := x^.RecField.GetItem(I);
                end;
                u := FUsedTypes.GetItem(rr^.FType);
                newRecFields.Add(rr);
                LL := -1;
              end;
            2:
              begin
                if LL <> -1 then
                begin
                  new(rr);
                  rr^.FKind := 0;
                  rr^.FType := LastRecType;
                  rr^.RecFieldNo := LL;
                  newRecFields.Add(Rr);
                  rr := x^.RecField.GetItem(I);
                end;
                u := FUsedTypes.GetItem(rr^.FType);
                newRecFields.Add(rr);
                LL := -1;
              end;

          end;
          inc(i);
        end;
        if LL <> -1 then
        begin
          new(rr);
          rr^.FKind := 0;
          rr^.RecFieldNo := LL;
          rr^.FType := LastRecType;
          newRecFields.Add(Rr);
        end;
        x^.RecField.Free;
        x^.RecField := NewRecFields;
      end;
    end;
    function ReadPropertyParameters(Params: TIfList; ParamTypes: string): Boolean;
    var
      CurrParamType: Cardinal;
      Temp: PIFPSValue;
      P: PParam;
    begin
      Delete(ParamTypes, 1, pos(' ', ParamTypes)); // Remove property type
      if FParser.CurrTokenID <> CSTI_OpenBlock then
      begin
        MakeError('', ecOpenBlockExpected, '');
        Result := False;
        exit;
      end;
      FParser.Next;
      while ParamTypes <> '' do
      begin
        CurrParamType := at2ut(StrToIntDef(GRFW(ParamTypes), -1));
        Temp := Calc(CSTI_CloseBlock);
        if temp = nil then
        begin
          Result := False;
          Exit;
        end;
        New(P);
        p^.InReg := Temp;
        p^.OutReg := nil;
        p^.FType := CurrParamType;
        p^.OutRegPos := FParser.CurrTokenPos;
        Params.Add(p);
        if ParamTypes = '' then
        begin
          if FParser.CurrTokenID <> CSTI_CloseBlock then
          begin
            MakeError('', ecCloseBlockExpected, '');
            Result := False;
            Exit;
          end;
          FParser.Next;
        end else begin
          if FParser.CurrTokenId <> CSTI_Comma then
          begin
            MakeError('', ecCommaExpected, '');
            Result := False;
            exit;
          end;
          FParser.Next;
        end;
      end;
      Result := True;
    end;
    procedure CheckClass(var P: PIFPSValue);
    var
      Idx, FTypeNo: Cardinal;
      FType: PIFPSType;
      TempP: PIFPSValue;
      Param: PParam;
      s: string;

    begin
      FTypeNo := GetTypeNo(p);
      if FTypeNo = Cardinal(-1) then Exit;
      FType := FUsedTypes.GetItem(FTypeNo);
      if FType.BaseType <> btClass then Exit;
      while FParser.CurrTokenID = CSTI_Period do
      begin
        FParser.Next;
        if FParser.CurrTokenID <> CSTI_Identifier then
        begin
          MakeError('', ecIdentifierExpected, '');
          DisposePValue(p);
          P := nil;
          Exit;
        end;
        s := FParser.GetToken;
        FParser.Next;
        if FType.Ex.Func_Find(s, Idx) then
        begin
          FType.Ex.Func_Call(Idx, FTypeNo);
          P := ReadParameters(FTypeNo, P);
          if p = nil then
          begin
            Exit;
          end;
        end else if FType.Ex.Property_Find(s, Idx) then
        begin
          FType.Ex.Property_GetHeader(Idx, s);
          TempP := P;
          New(P);
          P^.FType := CVAL_Proc;
          p^.Modifiers := 0;
          p^.DPos := FParser.CurrTokenPos;
          P^.Parameters := TIfList.Create;
          new(param);
          Param^.InReg := TempP;
          Param^.OutReg := nil;
          Param^.FType := GetTypeNo(TempP);
          P^.Parameters.Add(Param);
          if pos(' ', s) <> 0 then
          begin
            if not ReadPropertyParameters(P^.Parameters, s) then
            begin
              DisposePValue(P);
              P := nil;
              exit;
            end;
          end; // if
          if FParser.CurrTokenId = CSTI_Assignment then
          begin
            FParser.Next;
            TempP := Calc(CSTI_SemiColon);
            if TempP = nil then
            begin
              DisposePValue(P);
              p := nil;
              exit;
            end;
            new(param);
            Param^.InReg := tempp;
            Param^.OutReg := nil;
            Param^.FType := at2ut(StrToIntDef(fw(s), -1));
            P^.Parameters.Add(Param);
            if not FType.Ex.Property_Set(Idx, p^.ProcNo) then
            begin
              MakeError('', ecReadOnlyProperty, '');
              DisposePValue(p);
              p := nil;
              exit;
            end;
            Exit;
          end else begin
            if not FType.Ex.Property_Get(Idx, p^.ProcNo) then
            begin
              MakeError('', ecWriteOnlyProperty, '');
              DisposePValue(p);
              p := nil;
              exit;
            end;
          end; // if FParser.CurrTokenId = CSTI_Assign
        end else
        begin
          MakeError('', ecUnknownIdentifier, s);
          DisposePValue(p);
          P := nil;
          Exit;
        end;
        FTypeNo := GetTypeNo(p);
        FType := FUsedTypes.GetItem(FTypeNo);
        if (FType = nil) or (FType.BaseType <> btClass) then Exit;
      end; {while}
    end;
    function CheckClassType(const TypeNo, ParserPos: Cardinal): PIFPSValue;
    var
      FType, FType2: PIFPSType;
      ProcNo, Idx: Cardinal;
      PP: PParam;
      Temp: PIFPSValue;
    begin
      FType := FAvailableTypes.GetItem(TypeNo);
      if FParser.CurrTokenID = CSTI_OpenRound then
      begin
        FParser.Next;
        Temp := Calc(CSTI_CloseRound);
        if Temp = nil then
        begin
          Result := nil;
          exit;
        end;
        if FParser.CurrTokenID <> CSTI_CloseRound then
        begin
          DisposePValue(temp);
          MakeError('', ecCloseRoundExpected, '');
          Result := nil;
          exit;
        end;
        FType2 := FUsedTypes.GetItem(GetTypeNo(Temp));
        if (FType^.basetype = BtClass) and (ftype2^.BaseType = btClass) and (ftype <> ftype2) then
        begin
          if not FType2^.Ex.CastToType(GetTypeNo(Temp), AT2UT(TypeNo), ProcNo) then
          begin
            DisposePValue(Temp);
            MakeError('', ecTypeMismatch, '');
            Result := nil;
            exit;
          end;
          New(Result);
          Result^.FType := CVAL_Proc;
          Result^.Modifiers := 8;
          Result^.FNewTypeNo := at2ut(TypeNo);
          Result^.DPos := FParser.CurrTokenPos;
          Result^.Parameters := TIfList.Create;
          Result^.ProcNo := ProcNo;
          New(pp);
          pp^.InReg := Temp;
          pp^.OutReg := nil;
          pp^.FType := GetTypeNo(Temp);
          Result^.Parameters.Add(pp);
          New(pp);
          pp^.OutReg := nil;
          pp^.FType := GetType(btu32);
          New(pp^.InReg);
          pp^.InReg^.FType := CVAL_Data;
          pp^.InReg^.Modifiers := 0;
          pp^.InReg^.DPos := FParser.CurrTokenPos;
          New(pp^.InReg^.FData);
          pp^.InReg^.FData^.FType := pp^.FType;
          pp^.InReg^.FData^.Value := mi2s(at2ut(TypeNo));
          Result^.Parameters.Add(pp);
          FParser.Next;
          Exit;
        end;
        if not checkCompatType2(FType, FType2) then
        begin
          DisposePValue(Temp);
          MakeError('', ecTypeMismatch, '');
          Result := nil;
          exit;
        end;
        FParser.Next;
        New(Result);
        Result^.FType := CVAL_Cast;
        Result^.Modifiers := 0;
        Result^.DPos := FParser.CurrTokenPos;
        Result^.Input := Temp;
        Result^.NewTypeNo := AT2UT(TypeNo);
        exit;
      end;
      if FParser.CurrTokenId <> CSTI_Period then
      begin
        Result := nil;
        MakeError('', ecPeriodExpected, '');
        Exit;
      end;
      if FType^.BaseType <> btClass then
      begin
        Result := nil;
        MakeError('', ecClassTypeExpected, '');
        Exit;
      end;
      FParser.Next;
      if not FType^.Ex.ClassFunc_Find(FParser.GetToken, Idx) then
      begin
        Result := nil;
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
        Exit;
      end;
      FParser.Next;
      FType^.Ex.ClassFunc_Call(Idx, ProcNo);
      New(Temp);
      Temp^.FType := CVAL_Data;
      Temp^.Modifiers := 0;
      New(Temp^.FData);
      Temp^.FData^.FType := GetType(btU32);
      SetLength(Temp^.FData^.Value, 4);
      Cardinal((@Temp^.FData^.Value[1])^) := AT2UT(TypeNo);
      Result := ReadParameters(ProcNo, Temp);
      if Result <> nil then
      begin
        Result^.Modifiers := Result^.Modifiers or 8;
        Result^.FNewTypeNo := AT2UT(TypeNo);
      end;
    end;

  begin
    s := FParser.GetToken;
    h := MakeHash(s);
    u := proc.Decl;
    if s = 'RESULT' then
    begin
      if GRFW(u) = '-1' then
      begin
        Result := nil;
        MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
      end
      else
      begin
        proc^.ResUsed := True;
        New(Result);
        Result^.FType := CVAL_Addr;
        Result^.Modifiers := 0;
        Result^.Address := IFPSAddrStackStart - 1;
        Result^.DPos := FParser.CurrTokenPos;
        Result^.RecField := nil;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, ivtParam, 0, ProcNo, FParser.CurrTokenPos);
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result);
          if Result <> nil then CheckClass(Result);
          if Result <> nil then CheckProcCall(Result);
        until (Result = nil) or (Temp = Result);
      end;
      exit;
    end;
    if GRFW(u) <> '-1' then
      l := -2
    else
      l := -1;
    while Length(u) > 0 do
    begin
      if D1(GRFW(u)) = s then
      begin
        New(Result);
        Result^.FType := CVAL_Addr;
        Result^.Modifiers := 0;
        Result^.Address := IFPSAddrStackStart + Cardinal(l);
        Result^.RecField := nil;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, ivtParam, -1 - L, ProcNo, FParser.CurrTokenPos);
        FParser.Next;
        Result^.DPos := FParser.CurrTokenPos;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result);
          if Result <> nil then CheckClass(Result);
          if Result <> nil then CheckProcCall(Result);
        until (Result = nil) or (Temp = Result);
        exit;
      end;
      Dec(l);
      GRFW(u);
    end;

    for l := 0 to proc^.ProcVars.Count - 1 do
    begin
      if (PIFPSProcVar(proc^.ProcVars.GetItem(l))^.NameHash = h) and
        (PIFPSProcVar(proc^.ProcVars.GetItem(l))^.VarName = s) then
      begin
        PIFPSProcVar(proc^.ProcVars.GetItem(l))^.Used := True;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, ivtVariable, L, ProcNo, FParser.CurrTokenPos);
        New(Result);
        Result^.FType := CVAL_Addr;
        Result^.Modifiers := 0;
        Result^.Address := IFPSAddrStackStart + Cardinal(l) + 1;
        Result^.DPos := FParser.CurrTokenPos;
        Result^.RecField := nil;

        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result);
          if Result <> nil then CheckClass(Result);
          if Result <> nil then CheckProcCall(Result);
        until (Result = nil) or (Temp = Result);

        exit;
      end;
    end;

    for l := 0 to FVars.Count - 1 do
    begin
      if (PIFPSVar(FVars.GetItem(l))^.NameHash = h) and
        (PIFPSVar(FVars.GetItem(l))^.Name = s) then
      begin
        PIFPSVar(FVars.GetItem(l))^.Used := True;
        New(Result);
        Result^.FType := CVAL_Addr;
        Result^.Modifiers := 0;
        Result^.Address := l;
        Result^.RecField := nil;
        Result^.DPos := FParser.CurrTokenPos;
        if @FOnUseVariable <> nil then
          FOnUseVariable(Self, ivtGlobal, l, ProcNo, FParser.CurrTokenPos);
        FParser.Next;
        repeat
          Temp := Result;
          if Result <> nil then CheckFurther(Result);
          if Result <> nil then CheckClass(Result);
          if Result <> nil then CheckProcCall(Result);
        until (Result = nil) or (Temp = Result);
        exit;
      end;
    end;
    Temp1 := FindType(FParser.GetToken);
    if Temp1 <> Cardinal(-1) then
    begin
      l := FParser.CurrTokenPos;
      if FType = 1 then
      begin
        Result := nil;
        MakeError('', ecVariableExpected, FParser.OriginalToken);
        exit;
      end;
      FParser.Next;
      Result := CheckClassType(Temp1, l);
      repeat
        Temp := Result;
        if Result <> nil then CheckFurther(Result);
        if Result <> nil then CheckClass(Result);
        if Result <> nil then CheckProcCall(Result);
      until (Result = nil) or (Temp = Result);

      exit;
    end;
    Temp1 := FindProc(FParser.GetToken);
    if Temp1 <> Cardinal(-1) then
    begin
      l := FParser.CurrTokenPos;
      if FType = 1 then
      begin
        Result := nil;
        MakeError('', ecVariableExpected, FParser.OriginalToken);
        exit;
      end;
      FParser.Next;
      Result := ReadParameters(Temp1, nil);
      if Result = nil then
        exit;
      Result^.DPos := l;
      repeat
        Temp := Result;
        if Result <> nil then CheckFurther(Result);
        if Result <> nil then CheckClass(Result);
        if Result <> nil then CheckProcCall(Result);
      until (Result = nil) or (Temp = Result);
      exit;
    end;
    for l := 0 to FConstants.Count -1 do
    begin
      t := PIFPSConstant(FConstants.GetItem(l));
      if (t^.NameHash = h) and (t^.Name = s) then
      begin
        if FType <> 0 then
        begin
          Result := nil;
          MakeError('', ecVariableExpected, FParser.OriginalToken);
          exit;
        end;
        fparser.next;
        new(result);
        Result^.FType := CVAL_Data;
        Result^.DPos := FParser.CurrTokenPos;
        Result^.Modifiers := 0;
        new(Result^.FData);
        Result^.FData^.FType := at2ut(t^.Value.FType);
        Result^.FData^.Value := t^.Value.Value;
        exit;
      end;
    end;
    Result := nil;
    MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
  end;
  function ReadVarParameters(ProcNoVar: PIFPSValue): PIFPSValue;
  var
    Decl: string;
    p: PParam;
    Tmp: PIFPSValue;
    FType: Cardinal;
    modifier: Char;

    function IsVarInCompatible(ft1, ft2: PIFPSType): Boolean;
    begin
      ft1 := GetTypeCopyLink(ft1);
      ft2 := GetTypeCopyLink(ft2);
      Result := (ft1 <> ft2);
    end;

    function getfc(const s: string): Char;
    begin
      if Length(s) > 0 then
        Result := s[1]
      else
        Result := #0
    end;
  begin
    Decl := PIFPSProceduralType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(ProcnoVar)))^.Ext)^.ProcDef;
    GRFW(Decl);
    New(Result);
    Result^.FType := CVAL_VarProc;
    Result^.Modifiers := 0;
    Result^._ProcNo := ProcNoVar;
    Result^._Parameters := TIfList.Create;
    if Length(Decl) = 0 then
    begin
      if FParser.CurrTokenId = CSTI_OpenRound then
      begin
        FParser.Next;
        if FParser.CurrTokenId <> CSTI_CloseRound then
        begin
          DisposePValue(Result);
          Result := nil;
          MakeError('', ecCloseRoundExpected, '');
          exit;
        end;
        FParser.Next;
      end;
    end
    else
    begin
      if FParser.CurrTokenId <> CSTI_OpenRound then
      begin
        DisposePValue(Result);
        MakeError('', ecOpenRoundExpected, '');
        Result := nil;
        exit;
      end;
      FParser.Next;
      while Length(Decl) > 0 do
      begin
        modifier := getfc(GRFW(Decl));
        FType := StrToInt(GRFW(Decl));
        if (modifier = '@') then
        begin
          Tmp := calc(CSTI_CloseRound);
          if Tmp = nil then
          begin
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
        end
        else
        begin
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            MakeError('', ecIdentifierExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
          Tmp := GetIdentifier(1); // only variables
          if Tmp = nil then
          begin
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
          if ((FType = Cardinal(-1)) and (PIFPSType(FUsedTypes.GetItem(GetTypeNo(Tmp)))^.BaseType = btArray)) then
          begin
            {nothing}
          end else if IsVarInCompatible(FUsedTypes.GetItem(FType), FUsedTypes.GetItem(GetTypeNo(Tmp))) then
          begin
            MakeError('', ecTypeMismatch, '');
            DisposePValue(Result);
            DisposePValue(Tmp);
            Result := nil;
            exit;
          end;
          Tmp^.FType := Tmp^.FType + CVAL_PushAddr;
        end;
        New(p);
        p^.InReg := Tmp;
        p^.OutReg := nil;
        p^.FType := FType;
        Result._Parameters.Add(p);
        if Length(Decl) = 0 then
        begin
          if FParser.CurrTokenId <> CSTI_CloseRound then
          begin
            MakeError('', ecCloseRoundExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end; {if}
          FParser.Next;
        end
        else
        begin
          if FParser.CurrTokenId <> CSTI_Comma then
          begin
            MakeError('', ecCommaExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end; {if}
          FParser.Next;
        end; {else if}
      end; {for}
    end; {else if}
  end;

  function calc(endOn: TIfPasToken): PIFPSValue;
  var
    Items: TIfList;
    p: PCalc_Item;
    x: PParam;
    v, vc: PIFPSValue;
    Pt: PIFPSType;
    C: Byte;
    modifiers: byte;
    L: Cardinal;

    procedure Cleanup;
    var
      p: PCalc_Item;
      l: Longint;
    begin
      for l := 0 to Items.Count - 1 do
      begin
        p := Items.GetItem(l);
        if not p^.C then
        begin
          DisposePValue(p^.OutRec);
        end;
        Dispose(p);
      end;
      Items.Free;
    end;

    function SortItems: Boolean;
    var
      l: Longint;
      tt: Cardinal;
      p, p1, P2, ptemp: PCalc_Item;
      tempt: PIFPSType;
      pp: PParam;
      temps: string;

      function GetResultType(p1, P2: PIFPSValue; Cmd: Byte): Cardinal;
      var
        t1, t2: PIFPSType;
        tt1, tt2: Cardinal;
      begin
        tt1 := GetTypeNo(p1);
        t1 := FUsedTypes.GetItem(tt1);
        tt2 := GetTypeNo(P2);
        t2 := FUsedTypes.GetItem(tt2);
        if (t1 = nil) or (t2 = nil) then
        begin
          Result := Cardinal(-1);
          exit;
        end;
        case Cmd of
          0: {plus}
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (t2^.BaseType = btString) or
                (t2^.BaseType = btPchar) or
                (t2^.BaseType = btChar) or
                (isIntRealType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (t1^.BaseType = btString) or
                (t1^.BaseType = btPchar) or
                (t1^.BaseType = btChar) or
                (isIntRealType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := tt1
              else if IsIntRealType(t1^.BaseType) and
                IsIntRealType(t2^.BaseType) then
              begin
                if IsRealType(t1^.BaseType) then
                  Result := tt1
                else
                  Result := tt2;
              end
              else if (t1^.BaseType = btString) and (t2^.BaseType = btChar) then
                Result := tt1
              else if (t1^.BaseType = btChar) and (t2^.BaseType = btString) then
                Result := tt2
              else if (t1^.BaseType = btChar) and (t2^.BaseType = btChar) then
                Result := GetType(btString)
              else if (t1^.BaseType = btString) and (t2^.BaseType =
                btString) then
                Result := tt1
              else if (t1^.BaseType = btString) and (t2^.BaseType = btU8) then
                Result := tt1
              else if (t1^.BaseType = btU8) and (t2^.BaseType = btString) then
                Result := tt2
              else
                Result := Cardinal(-1);
            end;
          1, 2, 3: { -  * / }
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (isIntRealType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (isIntRealType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := tt1
              else if IsIntRealType(t1^.BaseType) and
                IsIntRealType(t2^.BaseType) then
              begin
                if IsRealType(t1^.BaseType) then
                  Result := tt1
                else
                  Result := tt2;
              end
              else
                Result := Cardinal(-1);
            end;
          7, 8, 9: {and,or,xor}
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (isIntType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (isIntType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := tt1
              else if (tt1 = at2ut(FBooleanType)) and (tt2 = tt1) then
              begin
                Result := tt1;
                if ((p1^.FType = CVAL_Data) or (p2^.FType = CVAL_Data)) then
                begin
                  if cmd = 7 then {and}
                  begin
                    if p1^.FType = CVAL_Data then
                    begin
                      if (p1^.FData^.Value[1] = #1) then
                        MakeWarning('', ewIsNotNeeded, '"True and"')^.Position := p1^.DPos
                      else
                        MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'False')^.Position := p1^.DPos
                    end else begin
                      if (p2^.FData^.Value[1] = #1) then
                        MakeWarning('', ewIsNotNeeded, '"and True"')^.Position := p2^.DPos
                      else
                        MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'False')^.Position := p2^.DPos;
                    end;
                  end else if cmd = 8 then {or}
                  begin
                    if p1^.FType = CVAL_Data then
                    begin
                      if (p1^.FData^.Value[1] = #1) then
                        MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'True')^.Position := p1^.DPos
                      else
                        MakeWarning('', ewIsNotNeeded, '"False or"')^.Position := p1^.DPos
                    end else begin
                      if (p2^.FData^.Value[1] = #1) then
                        MakeWarning('', ewCalculationAlwaysEvaluatesTo, 'True')^.Position := p2^.DPos
                      else
                        MakeWarning('', ewIsNotNeeded, '"or False"')^.Position := p2^.DPos;
                    end;
                  end;
                end;
              end else
                Result := Cardinal(-1);
            end;
          4, 5, 6: {mod,shl,shr}
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (isIntType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (isIntType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := tt1
              else
                Result := Cardinal(-1);
            end;
          10, 11, 12, 13: { >=, <=, >, <}
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (t2^.BaseType = btString) or
                (t2^.BaseType = btPchar) or
                (t2^.BaseType = btChar) or
                (isIntRealType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (t1^.BaseType = btString) or
                (t1^.BaseType = btPchar) or
                (t1^.BaseType = btChar) or
                (isIntRealType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := at2ut(FBooleanType)
              else if IsIntRealType(t1^.BaseType) and
                IsIntRealType(t2^.BaseType) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btString) and (t2^.BaseType = btString) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btChar) and (t2^.BaseType = btString) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btString) and (t2^.BaseType = btChar) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btVariant) or (t2^.BaseType = btVariant) then
                Result := at2ut(FBooleanType)
              else
                Result := Cardinal(-1);
            end;
          14, 15: {=, <>}
            begin
              if (t1^.BaseType = btVariant) and (
                (t2^.BaseType = btVariant) or
                (t2^.BaseType = btString) or
                (t2^.BaseType = btPchar) or
                (t2^.BaseType = btChar) or
                (isIntRealType(t2^.BaseType))) then
                Result := tt1
              else
              if (t2^.BaseType = btVariant) and (
                (t1^.BaseType = btVariant) or
                (t1^.BaseType = btString) or
                (t1^.BaseType = btPchar) or
                (t1^.BaseType = btChar) or
                (isIntRealType(t1^.BaseType))) then
                Result := tt2
              else if IsIntType(t1^.BaseType) and IsIntType(t2^.BaseType) then
                Result := at2ut(FBooleanType)
              else if IsIntRealType(t1^.BaseType) and
                IsIntRealType(t2^.BaseType) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btChar) and (t2^.BaseType = btChar) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btChar) and (t2^.BaseType = btString) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btString) and (t2^.BaseType = btChar) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btString) and (t2^.BaseType = btString) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btEnum) and (t1 = t2) then
                Result := at2ut(FBooleanType)
              else if (t1^.BaseType = btVariant) or (t2^.BaseType = btVariant) then
                Result := at2ut(FBooleanType)
              else Result := Cardinal(-1);
            end;
        else
          Result := Cardinal(-1);
        end;
      end;
      procedure ApplyModifiers(FData: PIFPSValue);
      begin
        if (FData^.FType = CVAL_Data) then
        begin
          if FData^.Modifiers = 1 then // not
          begin
            FData^.Modifiers := FData^.Modifiers and not 1;
            case PIFPSType(FUsedTypes.GetItem(FData.FData^.FType))^.BaseType of
              btEnum: TbtU32((@FData^.FData^.Value[1])^) := tbtu32(TbtU32((@FData^.FData^.Value[1])^) = 0); 
              btU8: TbtU8((@FData.FData^.Value[1])^) := tbtu8(TbtU8((@FData.FData^.Value[1])^) = 0);
              btS8: TbtS8((@FData^.FData^.Value[1])^) := tbts8(TbtS8((@FData^.FData^.Value[1])^) = 0);
              btU16: TbtU16((@FData^.FData^.Value[1])^) := tbtu16(TbtU16((@FData^.FData^.Value[1])^) = 0);
              btS16: TbtS16((@FData^.FData^.Value[1])^) := tbts16(TbtS16((@FData^.FData^.Value[1])^) = 0);
              btU32: TbtU32((@FData^.FData^.Value[1])^) := tbtu32(TbtU32((@FData^.FData^.Value[1])^) = 0);
              btS32: TbtS32((@FData^.FData^.Value[1])^) := tbts32(TbtS32((@FData^.FData^.Value[1])^) = 0);
            end;
          end else
          if FData^.Modifiers = 2 then // minus
          begin
            FData^.Modifiers := FData^.Modifiers and not 2;
            case PIFPSType(FUsedTypes.GetItem(FData^.FData^.FType))^.BaseType of
              btU8: TbtU8((@FData^.FData^.Value[1])^) := - TbtU8((@FData^.FData^.Value[1])^);
              btS8: TbtS8((@FData^.FData^.Value[1])^) := - TbtS8((@FData^.FData^.Value[1])^);
              btU16: TbtU16((@FData^.FData^.Value[1])^) := - TbtU16((@FData^.FData^.Value[1])^);
              btS16: TbtS16((@FData^.FData^.Value[1])^) := - TbtS16((@FData^.FData^.Value[1])^);
              btU32: TbtU32((@FData^.FData^.Value[1])^) := - TbtU32((@FData^.FData^.Value[1])^);
              btS32: TbtS32((@FData^.FData^.Value[1])^) := - TbtS32((@FData^.FData^.Value[1])^);
              btSingle: TbtSingle((@FData^.FData^.Value[1])^) := - TbtSingle((@FData^.FData^.Value[1])^);
              btDouble: TbtDouble((@FData^.FData^.Value[1])^) := - TbtDouble((@FData^.FData^.Value[1])^);
              btExtended: TbtExtended((@FData^.FData^.Value[1])^) := - tbtExtended((@FData^.FData^.Value[1])^);
            end;
          end;
        end;
      end;
    begin
      SortItems := False;
      if Items.Count = 1 then
      begin
        p1 := Items.GetItem(0);
        ApplyModifiers(p1^.OutRec);
        SortItems := True;
        exit;
      end;
      for l := 0 to (Longint(Items.Count) div 2) do
      begin
        p1 := Items.GetItem(l shl 1);
        if p1^.OutRec^.FType = CVAL_Data then
          ApplyModifiers(P1^.OutRec);
      end;
      l := 0;
      while l < Longint(Items.Count - 1) div 2 do
      begin
        p := Items.GetItem((l shl 1) + 1);
        p1 := Items.GetItem((l shl 1));
        P2 := Items.GetItem((l shl 1) + 2);
        case p^.calcCmd of
          2, 3, 4, 5, 6, 7: {*}
            begin
              if (p1^.OutRec^.FType = CVAL_Data) and (P2^.OutRec^.FType =
                CVAL_Data) then
              begin
                if not PreCalc(FUsedTypes, p1^.OutRec^.Modifiers, p1^.OutRec^.FData, p2^.OutRec^.Modifiers, P2^.OutRec^.FData,
                  p^.calcCmd, P2^.OutRec^.DPos) then
                begin
                  exit;
                end;
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
                DisposePValue(P2^.OutRec);
                Dispose(P2);
                Dispose(p);
              end
              else 
              begin
                tt := GetResultType(p1^.OutRec, P2^.OutRec, p^.calcCmd);
                if tt = Cardinal(-1) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    P2^.OutRec^.DPos;
                  exit;
                end;
                New(ptemp);
                ptemp^.C := False;
                New(ptemp^.OutRec);
                ptemp^.OutRec^.Modifiers := 0;
                ptemp^.OutRec^.FType := CVAL_Eval;
                ptemp^.OutRec^.SubItems := TIfList.Create;
                ptemp^.OutRec^.SubItems.Add(p1);
                ptemp^.OutRec^.SubItems.Add(p);
                ptemp^.OutRec^.SubItems.Add(P2);
                ptemp^.OutRec^.frestype := tt;
                Items.SetItem((l shl 1), ptemp);
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
              end;
            end;
        else
          Inc(l);
        end;
      end;
      l := 0;
      while l < Longint(Items.Count - 1) div 2 do
      begin
        p := Items.GetItem((l shl 1) + 1);
        p1 := Items.GetItem((l shl 1));
        P2 := Items.GetItem((l shl 1) + 2);
        case p^.calcCmd of
          0, 1, 8, 9:
            begin
              if (p1^.OutRec^.FType = CVAL_Data) and (P2^.OutRec^.FType =
                CVAL_Data) then
              begin
                if not PreCalc(FUsedTypes, p1^.OutRec^.Modifiers, p1^.OutRec^.FData, p2^.OutRec^.Modifiers, P2^.OutRec^.FData,
                  p^.calcCmd, P2^.OutRec^.DPos) then
                begin
                  exit;
                end;
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
                DisposePValue(P2^.OutRec);
                Dispose(P2);
                Dispose(p);
              end
              else
              begin
                tt := GetResultType(p1^.OutRec, P2^.OutRec, p^.calcCmd);
                if tt = Cardinal(-1) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    P2^.OutRec^.DPos;
                  exit;
                end;
                New(ptemp);
                ptemp^.C := False;
                New(ptemp^.OutRec);
                ptemp^.OutRec^.Modifiers := 0;
                ptemp^.OutRec^.FType := CVAL_Eval;
                ptemp^.OutRec^.SubItems := TIfList.Create;
                ptemp^.OutRec^.SubItems.Add(p1);
                ptemp^.OutRec^.SubItems.Add(p);
                ptemp^.OutRec^.SubItems.Add(P2);
                ptemp^.OutRec^.frestype := tt;
                Items.SetItem((l shl 1), ptemp);
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
              end;
            end;
        else
          Inc(l);
        end;
      end;
      l := 0;
      while l < Longint(Items.Count - 1) div 2 do
      begin
        p := Items.GetItem((l shl 1) + 1);
        p1 := Items.GetItem((l shl 1));
        P2 := Items.GetItem((l shl 1) + 2);
        case p^.calcCmd of
          10, 11, 12, 13, 14, 15:
            begin
              if (p1^.OutRec^.FType <> CVAL_VarProcPtr) and (p2^.OutRec^.FType <> CVAL_VarProcPtr) and
              ((PIFPSType(FUsedTypes.GetItem(GetTypeNo(p1^.OutRec)))^.BaseType = btclass) or
              (PIFPSType(FUsedTypes.GetItem(GetTypeNo(p2^.OutRec)))^.BaseType = btclass)) and
              ((p^.CalcCmd = 14) or (p^.CalcCmd = 15)) then
              begin
                tempt := FUsedTypes.GetItem(GetTypeNo(p1^.OutRec));
                if not tempt^.Ex.CompareClass(GetTypeNo(p2^.OutRec), tt) then
                begin
                  exit;
                end;
                new(ptemp);
                ptemp^.C := False;
                new(ptemp^.outrec);
                with ptemp^.outrec^ do
                begin
                  FType := CVAL_Proc;
                  if p^.calcCmd = 14 then
                    Modifiers := 1
                  else
                    Modifiers := 0;
                  ProcNo := tt;
                  Parameters := TIfList.Create;
                  new(pp);
                  if PIFPSProcedure(FProcs.GetItem(tt))^.Internal then
                    temps := PIFPSProcedure(FProcs.GetItem(tt))^.Decl
                  else
                    temps := PIFPSUsedRegProc(FProcs.GetItem(tt))^.rp^.Decl;
                  GRFW(temps);
                  pp^.InReg := p1^.OutRec;
                  pp^.OutReg := nil;
                  grfw(temps);
                  pp^.FType := StrToIntDef(grfw(temps), -1);
                  pp^.OutRegPos := p1^.OutRec^.DPos;
                  Parameters.add(pp);
                  new(pp);
                  pp^.InReg := p2^.OutRec;
                  pp^.OutReg := nil;
                  grfw(temps);
                  pp^.FType := StrToIntDef(grfw(temps), -1);
                  pp^.OutRegPos := p2^.OutRec^.DPos;
                  Parameters.add(pp);
                end;
                Items.SetItem((l shl 1), ptemp);
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
                Dispose(P2);
                dispose(p1);
                Dispose(p);
              end else 
              if (p1^.OutRec^.FType = CVAL_Data) and (P2^.OutRec^.FType =
                CVAL_Data) then
              begin
                if not PreCalc(FUsedTypes, p1^.OutRec^.Modifiers, p1^.OutRec^.FData, p2^.OutRec^.Modifiers, P2^.OutRec^.FData,
                  p^.calcCmd, P2^.OutRec^.DPos) then
                begin
                  exit;
                end;
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
                DisposePValue(P2^.OutRec);
                Dispose(P2);
                Dispose(p);
              end
              else
              begin
                tt := GetResultType(p1^.OutRec, P2^.OutRec, p^.calcCmd);
                if tt = Cardinal(-1) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    P2^.OutRec^.DPos;
                  exit;
                end;
                New(ptemp);
                ptemp^.C := False;
                New(ptemp^.OutRec);
                ptemp^.OutRec^.Modifiers := 0;
                ptemp^.OutRec^.FType := CVAL_Eval;
                ptemp^.OutRec^.SubItems := TIfList.Create;
                ptemp^.OutRec^.SubItems.Add(p1);
                ptemp^.OutRec^.SubItems.Add(p);
                ptemp^.OutRec^.SubItems.Add(P2);
                ptemp^.OutRec^.frestype := tt;
                Items.SetItem((l shl 1), ptemp);
                Items.Delete((l shl 1) + 1);
                Items.Delete((l shl 1) + 1);
              end;
            end;
        else
          Inc(l);
        end;
      end;
      SortItems := True;
    end;
  begin
    Items := TIfList.Create;
    calc := nil;
    while True do
    begin
      modifiers := 0;
      if Items.Count and 1 = 0 then
      begin
        if fParser.CurrTokenID = CSTII_Not then
        begin
          FParser.Next;
          modifiers := 1;
        end else // only allow one of these two
        if fParser.CurrTokenID = CSTI_Minus then
        begin
          FParser.Next;
          modifiers := 2;
        end;
        case FParser.CurrTokenId of
          CSTI_AddressOf:
            begin
              if (Modifiers <> 0) then
              begin
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              FParser.Next;
              if FParser.CurrTokenId <> CSTI_Identifier then
              begin
                MakeError('', ecIdentifierExpected, '');
                Cleanup;
                Exit;
              end;
              L := FindProc(FParser.GetToken);
              if L = Cardinal(-1) then
              begin
                MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
                Cleanup;
                Exit;
              end;
              PIFPSProcedure(FProcs.GetItem(L))^.FExport := 2;
              FParser.Next;
              New(v);
              v^.FType := CVAL_VarProcPtr;
              v^.Modifiers := 0;
              v^.DPos := FParser.CurrTokenPos;
              v^.VProcNo := L;
              New(p);
              p^.C := False;
              p^.OutRec := v;
              Items.Add(p);
            end;
          CSTI_OpenBlock:
            begin
              if (Modifiers <> 0) then
              begin
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              New(v);
              v^.FType := CVAL_Array;
              v^.Modifiers := 0;
              v^.DPos := FParser.CurrTokenPos;
              v^.ArrayItems := TIfList.Create;
              New(p);
              p^.C := False;
              p^.OutRec := v;
              Items.Add(p);
              FParser.Next;
              while FParser.CurrTokenId <> CSTI_CloseBlock do
              begin
                vc := calc(CSTI_CloseBlock);
                if vc = nil  then
                begin
                  Cleanup;
                  exit;
                end; {if}
                if vc^.FType = CVAL_Array then
                begin
                  MakeError('', ecIdentifierExpected, '')^.Position := v^.DPos;
                  Cleanup;
                  Exit;
                end;
                v^.ArrayItems.Add(vc);
                if FParser.CurrTokenId = CSTI_Comma then
                begin
                  FParser.Next;
                  Continue;
                end;
              end; {while}
              FParser.Next;
            end; {csti_openblock}
          CSTI_EOF:
            begin
              MakeError('', ecUnexpectedEndOfFile, '');
              Cleanup;
              exit;
            end;
          CSTI_OpenRound:
            begin
              FParser.Next;
              v := calc(CSTI_CloseRound);
              if v = nil then
              begin
                Cleanup;
                exit;
              end;
              if FParser.CurrTokenId <> CSTI_CloseRound then
              begin
                DisposePValue(v);
                MakeError('', ecCloseRoundExpected, '');
                Cleanup;
                exit;
              end;
              if ((Modifiers and 1) <> 0) and (not IsIntBoolType(GetTypeNo(v))) or ((Modifiers and 2) <> 0) and (not IsRealType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(v)))^.BaseType)) then
              begin
                DisposePValue(v);
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;

              New(p);
              p^.C := False;
              if ((v^.Modifiers and 1) <> 0) or ((modifiers and 1) <> 0) then
              begin
                v^.modifiers := v^.modifiers xor (modifiers and 1);
              end;
              if ((v^.Modifiers and 2) <> 0) or ((modifiers and 2) <> 0) then
              begin
                v^.modifiers := v^.modifiers xor (modifiers and 2);
              end;
              p^.OutRec := v;
              Items.Add(p);

              FParser.Next;
            end;
          CSTII_Chr:
            begin
              if modifiers <> 0then
              begin
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              FParser.Next;
              if FParser.CurrTokenID <> CSTI_OpenRound then
              begin
                MakeError('', ecOpenRoundExpected, '');
                Cleanup;
                exit;
              end;
              FParser.Next;
              v := calc(CSTI_CloseRound);
              if v = nil then
              begin
                Cleanup;
                exit;
              end;
              if FParser.CurrTokenId <> CSTI_CloseRound then
              begin
                DisposePValue(v);
                MakeError('', ecCloseRoundExpected, '');
                Cleanup;
                exit;
              end;
              if not IsIntType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(v)))^.BaseType) then
              begin
                DisposePValue(v);
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              New(p);
              p^.c := False;
              New(p^.OutRec);
              p^.OutRec^.FType := CVAL_Cast;
              p^.OutRec^.Modifiers := 0;
              p^.OutRec^.DPos := FParser.CurrTokenPos;
              p^.OutRec^.Input := v;
              p^.OutRec^.NewTypeNo := GetType(btChar);
              Items.Add(p);
              FParser.Next;
            end;
          CSTII_Ord:
            begin
              FParser.Next;
              if FParser.CurrTokenID <> CSTI_OpenRound then
              begin
                MakeError('', ecOpenRoundExpected, '');
                Cleanup;
                exit;
              end;
              FParser.Next;
              v := calc(CSTI_CloseRound);
              if v = nil then
              begin
                Cleanup;
                exit;
              end;
              if FParser.CurrTokenId <> CSTI_CloseRound then
              begin
                DisposePValue(v);
                MakeError('', ecCloseRoundExpected, '');
                Cleanup;
                exit;
              end;
              Pt := FUsedTypes.GetItem(GetTypeNo(v));
              if (pt^.BaseType = btString) and (v^.FType = CVAL_Data) and (Length(v^.FData.Value) =1) then
              begin
                v^.FData.FType := GetType(btChar);
                Pt := FUsedTypes.GetItem(GetTypeNo(v));
              end;
              New(p);
              p^.c := False;
              if ((v^.Modifiers and 1) <> 0) or ((modifiers and 1) <> 0) then
              begin
                v^.modifiers := v^.modifiers xor (modifiers and 1);
              end;
              if ((v^.Modifiers and 2) <> 0) or ((modifiers and 2) <> 0) then
              begin
                v^.modifiers := v^.modifiers xor (modifiers and 2);
              end;
              New(p^.OutRec);
              p^.OutRec^.FType := CVAL_Cast;
              p^.OutRec^.Modifiers := 0;
              p^.OutRec^.DPos := FParser.CurrTokenPos;
              p^.OutRec^.Input := v;
              if (pt^.BaseType = btChar) then
              begin
                p^.OutRec^.NewTypeNo := GetType(btU8);
              end else if (pt^.BaseType = btEnum) then
              begin
                if Longint(pt^.Ext) <= 256 then
                  p^.OutRec^.NewTypeNo := GetType(btU8)
                else if Longint(pt^.Ext) <= 65536 then
                  p^.OutRec^.NewTypeNo := GetType(btU16)
                else
                  p^.OutRec^.NewTypeNo := GetType(btU32);
              end else
              begin
                Dispose(P^.OutRec);
                Dispose(p);
                DisposePValue(v);
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              Items.Add(p);
              FParser.Next;
            end;
         CSTI_String, CSTI_Char:
            begin
              if (Modifiers <> 0) then
              begin
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              New(v);
              v^.FType := CVAL_Data;
              v^.DPos := FParser.CurrTokenPos;
              v^.FData := ReadString;
              v^.Modifiers := modifiers;
              v^.RecField := nil;
              New(p);
              p^.C := False;
              p^.OutRec := v;
              Items.Add(p);

            end;
          CSTI_HexInt, CSTI_Integer:
            begin
              New(v);
              v^.FType := CVAL_Data;
              v^.DPos := FParser.CurrTokenPos;
              v^.FData := ReadInteger(FParser.GetToken);
              v^.Modifiers := modifiers;
              New(p);
              p^.C := False;
              p^.OutRec := v;
              Items.Add(p);

              FParser.Next;
            end;
          CSTI_Real:
            begin
              if ((Modifiers and 1) <> 0)  then
              begin
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              New(v);
              v^.FType := CVAL_Data;
              v^.DPos := FParser.CurrTokenPos;
              v^.FData := ReadReal(FParser.GetToken);
              v^.Modifiers := modifiers;
              New(p);
              p^.C := False;
              p^.OutRec := v;
              Items.Add(p);
              FParser.Next;
            end;
          CSTI_Identifier:
            begin
              if FParser.GetToken = 'LOW' then
                c := 1
              else
                c := 0;
              if (FParser.GetToken = 'HIGH') or (c <> 0) then
              begin
                FParser.Next;
                if FParser.CurrTokenId <> CSTI_OpenRound then
                begin
                  MakeError('', ecOpenRoundExpected, '');
                  Cleanup;
                  Exit;
                end;
                FParser.Next;
                L := FindType(FParser.GetToken);
                if L = Cardinal(-1) then
                begin
                  v := GetIdentifier(1);
                  if v = nil then
                  begin
                    Cleanup;
                    Exit;
                  end;
                  L := GetTypeNo(v);
                  DisposePValue(v);
                end else FParser.Next;
                pt := FAvailableTypes.GetItem(L);
                if pt^.BaseType <> btEnum then
                begin
                  MakeError('', ecTypeMismatch, '');
                  Cleanup;
                  Exit;
                end;
                New(v);
                new(v^.FData);
                v^.FType := CVAL_Data;
                v^.DPos := FParser.CurrTokenPos;
                v^.FData^.FType := AT2UT(L);
                if c = 1 then
                  v^.FData^.Value := #0#0#0#0
                else
                  v^.FData^.Value := TransCardinalToStr(Cardinal(pt^.Ex));
                v^.Modifiers := modifiers;
                New(p);
                p^.C := False;
                p^.OutRec := v;
                Items.Add(p);
                if FParser.CurrTokenId <> CSTI_CloseRound then
                begin
                  MakeError('', ecCloseRoundExpected, '');
                  Cleanup;
                  Exit;
                end;
              end else if FParser.GetToken = 'ASSIGNED' then
              begin
                if (Modifiers and 2) <> 0 then
                begin
                  MakeError('', ecTypeMismatch, '');
                  cleanup;
                  exit;
                end;
                FParser.Next;
                if FParser.CurrTokenId <> CSTI_OpenRound then
                begin
                  MakeError('', ecOpenRoundExpected, '');
                  Cleanup;
                  Exit;
                end;
                FParser.Next;
                vc := calc(CSTI_CloseRound);
                if vc = nil then
                begin
                  Cleanup;
                  Exit;
                end;
                Pt := FUsedTypes.GetItem(GetTypeNo(vc));
                if (pt^.BaseType <> btProcPtr) and (pt^.BaseType <> btClass) and (pt^.BaseType <> btPChar) and (pt^.BaseType <> btString) then
                begin
                  DisposePValue(vc);
                  MakeError('', ecTypeMismatch, '');
                  Cleanup;
                  exit;
                end;
                if FParser.CurrTokenId <> CSTI_CloseRound then
                begin
                  MakeError('', ecCloseRoundExpected, '');
                  Cleanup;
                  Exit;
                end;
                FParser.Next;
                new(v);
                V^.FType := CVAL_Proc;
                v^.Modifiers := 0;
                v^.ProcNo := FindProc('!ASSIGNED');
                V^.Parameters :=TIfList.Create;
                new(x);
                X^.InReg := vc;
                x^.OutReg := nil;
                x^.FType := GetTypeNo(vc);
                X^.OutRegPos := FParser.CurrTokenPos;
                v^.Parameters.Add(x);
                new(p);
                p^.C := False;
                p^.OutRec := v;
                Items.Add(p);
              end else if FParser.GetToken = 'NIL' then
              begin
                if modifiers <> 0 then
                begin
                  MakeError('', ecTypeMismatch, '');
                  cleanup;
                  exit;
                end;
                New(v);
                v^.FType := CVAL_Nil;
                v^.DPos := FParser.CurrTokenPos;
                v^.Modifiers := 0;
                New(p);
                p^.C := False;
                p^.OutRec := v;
                Items.Add(p);
                FParser.Next;
              end else begin
                v := GetIdentifier(0);
                if v = nil then
                begin
                  Cleanup;
                  exit;
                end
                else if (GetTypeNo(v) = Cardinal(-1)) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position := v^.DPos;
                  DisposePValue(v);
                  Cleanup;
                  Exit;
                end else
                begin
                  if ((Modifiers and 1) <> 0) and (not IsIntBoolType(GetTypeNo(v))) or ((Modifiers
                  and 2) <> 0) and (not IsIntRealType(PIFPSType(
                  FUsedTypes.GetItem(GetTypeNo(v)))^.BaseType))
                  then
                  begin
                    DisposePValue(v);
                    MakeError('', ecTypeMismatch, '');
                    Cleanup;
                    exit;
                  end;
                  v^.Modifiers := v^.modifiers or modifiers;
                  New(p);
                  p^.C := False;
                  p^.OutRec := v;
                  Items.Add(p);
                end;
              end;
            end;
        else
          begin
            MakeError('', ecSyntaxError, '');
            Cleanup;
            exit;
          end;
        end; {case}
      end
      else {Items.Count and 1 = 1}
      begin
        if FParser.CurrTokenId = endOn then
          break;
        C := 0;
        case FParser.CurrTokenId of
          CSTI_EOF:
            begin
              MakeError('', ecUnexpectedEndOfFile, '');
              Cleanup;
              exit;
            end;
          CSTI_CloseBlock,
            CSTII_To,
            CSTI_CloseRound,
            CSTI_Semicolon,
            CSTII_Else,
            CSTII_End,
            CSTI_Comma: break;
          CSTI_Plus: ;
          CSTI_Minus: C := 1;
          CSTI_Multiply: C := 2;
          CSTII_div, CSTI_Divide: C := 3;
          CSTII_mod: C := 4;
          CSTII_shl: C := 5;
          CSTII_shr: C := 6;
          CSTII_and: C := 7;
          CSTII_or: C := 8;
          CSTII_xor: C := 9;
          CSTI_GreaterEqual: C := 10;
          CSTI_LessEqual: C := 11;
          CSTI_Greater: C := 12;
          CSTI_Less: C := 13;
          CSTI_NotEqual: C := 14;
          CSTI_Equal: C := 15;
        else
          begin
            MakeError('', ecSyntaxError, '');
            Cleanup;
            exit;
          end;
        end; {case}
        New(p);
        p^.C := True;
        p^.calcCmd := C;
        Items.Add(p);
        FParser.Next;
      end;
    end;
    if not SortItems then
    begin
      Cleanup;
      exit;
    end;
    if Items.Count = 1 then      
    begin
      p := Items.GetItem(0);
      Result := p^.OutRec;
      Dispose(p);
      Items.Free;
    end
    else
    begin
      New(Result);
      Result^.FType := CVAL_Eval;
      Result^.DPos := 0;
      result^.Modifiers := 0;
      Result^.SubItems := Items;
    end;
  end;

  function ReadParameters(ProcNo: Cardinal; fSelf: PIFPSValue): PIFPSValue;
  var
    Decl: string;
    p: PParam;
    Tmp: PIFPSValue;
    FType: Cardinal;
    modifier: Char;

    function IsVarInCompatible(ft1, ft2: PIFPSType): Boolean;
    begin
      ft1 := GetTypeCopyLink(ft1);
      ft2 := GetTypeCopyLink(ft2);
      Result := (ft1 <> ft2);
    end;

    function getfc(const s: string): Char;
    begin
      if Length(s) > 0 then
        Result := s[1]
      else
        Result := #0
    end;
  begin
    if PIFPSProcedure(FProcs.GetItem(ProcNo))^.Internal then
      Decl := PIFPSProcedure(FProcs.GetItem(ProcNo))^.Decl
    else
      Decl := PIFPSUsedRegProc(FProcs.GetItem(ProcNo))^.RP^.Decl;
    GRFW(Decl);
    New(Result);
    Result^.FType := CVAL_Proc;
    Result^.DPos := FParser.CurrTokenPos;
    Result^.Modifiers := 0;
    Result^.ProcNo := ProcNo;
    Result^.Parameters := TIfList.Create;
    if FSelf <> nil then begin
      new(p);
      p^.InReg := fself;
      p^.OutReg := nil;
      p^.FType := GetTypeNo(fself);
      Result^.Parameters.Add(p);
    end;
    if Length(Decl) = 0 then
    begin
      if FParser.CurrTokenId = CSTI_OpenRound then
      begin
        FParser.Next;
        if FParser.CurrTokenId <> CSTI_CloseRound then
        begin
          DisposePValue(Result);
          Result := nil;
          MakeError('', ecCloseRoundExpected, '');
          exit;
        end;
        FParser.Next;
      end;
    end
    else
    begin
      if FParser.CurrTokenId <> CSTI_OpenRound then
      begin
        DisposePValue(Result);
        MakeError('', ecOpenRoundExpected, '');
        Result := nil;
        exit;
      end;
      FParser.Next;
      while Length(Decl) > 0 do
      begin
        modifier := getfc(GRFW(Decl));
        FType := StrToInt(GRFW(Decl));
        if (modifier = '@') then
        begin
          Tmp := calc(CSTI_CloseRound);
          if Tmp = nil then
          begin
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
        end
        else
        begin
          if FParser.CurrTokenId <> CSTI_Identifier then
          begin
            MakeError('', ecIdentifierExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
          Tmp := GetIdentifier(1); // only variables
          if Tmp = nil then
          begin
            DisposePValue(Result);
            Result := nil;
            exit;
          end;
          if ((FType = Cardinal(-1)) or (PIFPSType(FUsedTypes.GetItem(GetTypeNo(Tmp)))^.BaseType = btArray)) then
          begin
            {nothing}
          end else if IsVarInCompatible(FUsedTypes.GetItem(FType), FUsedTypes.GetItem(GetTypeNo(Tmp))) then
          begin
            MakeError('', ecTypeMismatch, '');
            DisposePValue(Result);
            DisposePValue(Tmp);
            Result := nil;
            exit;
          end;
          Tmp^.FType := Tmp^.FType + CVAL_PushAddr;
        end;
        New(p);
        p^.InReg := Tmp;
        p^.OutReg := nil;
        p^.FType := FType;
        Result.Parameters.Add(p);
        if Length(Decl) = 0 then
        begin
          if FParser.CurrTokenId <> CSTI_CloseRound then
          begin
            MakeError('', ecCloseRoundExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end; {if}
          FParser.Next;
        end
        else
        begin
          if FParser.CurrTokenId <> CSTI_Comma then
          begin
            MakeError('', ecCommaExpected, '');
            DisposePValue(Result);
            Result := nil;
            exit;
          end; {if}
          FParser.Next;
        end; {else if}
      end; {for}
    end; {else if}
  end;


  function WriteCalculation(InData, OutReg: PIFPSValue): Boolean;
  var
    l: Longint;
    tmpcalc, p, PT, pt2: PIFPSValue;
    bmodsave: byte;
    C: Byte;

    function CheckOutreg(Where, Outreg: PIFPSValue): Boolean;
    var
      i: Longint;
      P: PCalc_Item;
    begin
      case Where^.FType of
        CVAL_Cast:
          begin
            if CheckOutreg(Where^.Input, Outreg) then
            begin
              Result := True;
              exit;
            end;
          end;
        CVAL_Addr, CVAL_PushAddr, CVAL_AllocatedStackReg:
          begin
            if SameReg(Where, OutReg) then
            begin
              Result := True;
              exit;
            end;
          end;
        CVAL_Eval:
          for i := 0 to Where.SubItems.Count -1 do
          begin
            p := Where.SubItems.GetItem(i);
            if not p^.C then
              if CheckOutreg(p^.OutRec, Outreg) then
              begin
                Result := True;
                Exit;
              end;
          end;
        CVAL_Proc, CVAL_VarProc:
          for i := 0 to Where^.Parameters.Count -1 do
          begin
            if CheckOutreg(PParam(Where^.Parameters.GetItem(i))^.InReg, Outreg) then
            begin
              Result := True;
              Exit;
            end;
          end;
        CVAL_ClassProcCall,
        CVAL_ClassMethodCall,
        CVAL_ClassPropertyCallSet,
        CVAL_ClassPropertyCallGet:
          begin
            if CheckOutreg(Where^.Self, Outreg) then
            begin
              Result := True;
              exit;
            end;
            for i := 0 to Where^.Params.Count -1 do
            begin
              if CheckOutreg(PParam(Where^.Params.GetItem(i))^.InReg, Outreg) then
              begin
                Result := True;
                Exit;
              end;
            end;

          end;
      end;
      Result := False;;
    end;
  begin
    if indata^.FType = CVAL_Cast then
    begin
      if GetTypeNo(OutReg) = Indata^.NewTypeNo then
      begin
        OutReg^.Modifiers := outreg^.modifiers or 4;
        Result := WriteCalculation(Indata^.Input, OutReg);
        OutReg^.Modifiers := outreg^.modifiers and not 4;
        Exit;
      end else begin
        p := AllocStackReg(Indata^.NewTypeNo);
        p^.DPos := InData^.DPos;
        p^.Modifiers := p^.modifiers or 4;
        if not WriteCalculation(Indata^.Input, p) then
        begin
          DisposeStackReg(p);
          Result := False;
          Exit;
        end;
        Result := WriteCalculation(p, outreg);
        DisposeStackReg(p);
        exit;
      end;
    end else
    if InData^.FType = CVAL_VarProcPtr then
    begin
      if not CheckCompatProc(GetTypeNo(OutReg), InData^.VProcNo) then
      begin
        MakeError('', ecTypeMismatch, '')^.Position := InData^.DPos;
        Result := False;
        exit;
      end;
      New(p);
      p^.FType := CVAL_Data;
      p^.Modifiers := 0;
      p^.DPos := Indata^.DPos;
      New(p^.FData);
      p^.FData.FType := GetTypeNo(OutReg);
      p^.FData.Value := mi2s(Indata^.VProcNo);
      WriteCommand(CM_A);
      WriteOutRec( OutReg, False);
      WriteOutRec(p, True);
      DisposePValue(p);
    end else
    if (InData^.FType = CVAL_Proc) or (InData^.FType = CVAL_VarProc) then
    begin
      if not CheckCompatType(OutReg, InData) then
      begin
        MakeError('', ecTypeMismatch, '')^.Position := InData^.DPos;
        Result := False;
        exit;
      end;

      if InData^.FType = CVAL_VarProc then
      begin
        if not ProcessVarFunction(InData^.Modifiers, InData^._ProcNo, InData^._Parameters, OutReg) then
        begin
          Result := False;
          exit;
        end;
      end else begin
        if not ProcessFunction(InData^.Modifiers, InData^.ProcNo, InData^.Parameters, OutReg) then
        begin
          Result := False;
          exit;
        end;
      end;
      if Indata^.Modifiers = 1 then begin
        PreWriteOutRec(OutReg, Cardinal(-1));
        WriteCommand(cm_bn);
        WriteOutRec(OutReg, False);
        AfterWriteOutRec(OutReg);
      end else if Indata^.Modifiers = 2 then begin
        PreWriteOutRec(OutReg, Cardinal(-1));
        WriteCommand(cm_vm);
        WriteOutRec(OutReg, False);
        AfterWriteOutRec(OutReg);
      end;
    end
    else if InData^.FType = CVAL_Eval then
    begin
      if CheckOutreg(InData, OutReg) then
      begin
        tmpcalc := AllocStackReg(GetTypeNo(OutReg));
        if not WriteCalculation(InData, TmpCalc) then
        begin
          DisposeStackReg(tmpcalc);
          Result := False;
          exit;
        end;
        if not WriteCalculation(TmpCalc, OutReg) then
        begin
          DisposeStackReg(tmpcalc);
          Result := False;
          exit;
        end;
        DisposeStackReg(tmpcalc);
      end else begin
        bmodsave := Indata^.Modifiers and 15;
        p := PCalc_Item(InData^.SubItems.GetItem(0))^.OutRec;
        C := PCalc_Item(InData^.SubItems.GetItem(1))^.calcCmd;
        if c >= 10 then
        begin
          tmpcalc := p;
        end else begin
          if not WriteCalculation(p, OutReg) then
          begin
            Result := False;
            exit;
          end; {if}
          tmpcalc := nil;
        end;
        for l := 0 to ((InData^.SubItems.Count - 1) div 2) - 1 do
        begin
          p := PCalc_Item(InData^.SubItems.GetItem((l shl 1) + 2))^.OutRec;
          C := PCalc_Item(InData^.SubItems.GetItem((l shl 1) + 1))^.calcCmd;
          if C < 10 then
          begin
            if p^.FType = CVAL_Eval then
            begin
              PT := AllocStackReg(GetTypeNo(OutReg));
              if not WriteCalculation(p, PT) then
              begin
                DisposeStackReg(PT);
                Result := False;
                exit;
              end; {if}
              PreWriteOutRec( OutReg, Cardinal(-1)); {error}
              WriteCommand(CM_CA);
              WriteData(C, 1);
              if not WriteOutRec(OutReg, False) then
              begin
                MakeError('', ecInternalError, '00001');
                DisposeStackReg(pt);
                Result := False;
                exit;
              end; {if}
              if not WriteOutRec(PT, True) then
              begin
                MakeError('', ecInternalError, '00002');
                DisposeStackReg(pt);
                Result := False;
                exit;
              end; {if}
              AfterWriteOutRec(Pt);
              DisposeStackReg(PT);
            end
            else if (p^.FType = CVAL_Proc) or (P^.Ftype = CVAL_VarProc) or (p^.FType = CVAL_Cast) then
            begin
              PT := AllocStackReg(GetTypeNo(OutReg));
              if not WriteCalculation(p, Pt) then
              begin
                DisposeStackReg(Pt);
                Result := False;
                exit;
              end;
              PreWriteOutRec(OutReg, Cardinal(-1)); {error}
              PreWriteOutRec(pt, Cardinal(-1)); {error}
              WriteCommand(CM_CA);
              WriteData(C, 1);
              if not WriteOutRec(OutReg, False) then
              begin
                MakeError('', ecInternalError, '00005');
                Result := False;
                exit;
              end; {if}
              if not WriteOutRec(pt, True) then
              begin
                MakeError('', ecInternalError, '00006');
                Result := False;
                exit;
              end; {if}
              AfterWriteOutRec(p);
              AfterWriteOutRec(OutReg);
              DisposeStackReg(Pt);
            end else begin
              PreWriteOutRec(OutReg, Cardinal(-1)); {error}
              PreWriteOutRec(p, GetTypeNo(Outreg)); {error}
              WriteCommand(CM_CA);
              WriteData(C, 1);
              if not WriteOutRec(OutReg, False) then
              begin
                MakeError('', ecInternalError, '00005');
                Result := False;
                exit;
              end; {if}
              if not WriteOutRec(p, True) then
              begin
                MakeError('', ecInternalError, '00006');
                Result := False;
                exit;
              end; {if}
              AfterWriteOutRec(p);
              AfterWriteOutRec(OutReg);

            end; {else if}
          end
          else
          begin
            C := C - 10;
            if p^.FType = CVAL_Eval then
            begin

              PT := AllocStackReg(p^.frestype);
              if not WriteCalculation(p, PT) then
              begin
                DisposeStackReg(PT);
                Result := False;
                exit;
              end; {if}
              if GetTypeNo(OutReg)<> at2ut(FBooleanType) then
              begin
                PT2 := AllocStackReg(at2ut(FBooleanType));
              end
              else
                PT2 := OutReg;
              PreWriteOutRec(OutReg, Cardinal(-1));
              if tmpcalc <> nil then PreWriteOutRec(Tmpcalc, Cardinal(-1));
              WriteCommand(CM_CO);
              WriteByte(C);
              if (pt2 = OutReg) then
              begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '00007');
                  Result := False;
                  exit;
                end; {if}
              end
              else
              begin
                if not WriteOutRec(pt2, False) then
                begin
                  MakeError('', ecInternalError, '00007');
                  Result := False;
                  exit;
                end; {if}
              end;
              if tmpcalc <> nil then
              begin
                if not WriteOutRec(tmpcalc, True) then
                begin
                  MakeError('', ecInternalError, '00008');
                  Result := False;
                  exit;
                end; {if}
              end else begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '00008');
                  Result := False;
                  exit;
                end; {if}
              end;
              if not WriteOutRec(PT, True) then
              begin
                MakeError('', ecInternalError, '00009');
                Result := False;
                exit;
              end; {if}
              if tmpcalc <> nil then begin
                AfterWriteOutRec(Tmpcalc);
                tmpcalc := nil;
              end;
              AfterWriteOutRec(OutReg);
              DisposeStackReg(PT);
              if pt2 <> OutReg then
              begin
                if (OutReg^.FType <> CVAL_Addr) or (OutReg^.Address <
                  IFPSAddrNegativeStackStart) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    OutReg^.DPos;
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end;
                PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address - 1 -
                  IFPSAddrStackStart))^.VarType := GetType(btS32);
                WriteCommand(Cm_ST); // set stack type
                WriteLong(PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address
                  - 1 - IFPSAddrStackStart))^.VarType);
                WriteLong(OutReg^.Address - IFPSAddrStackStart);
                WriteCommand(CM_A); // stack assignment
                WriteCommand(CVAL_Addr);
                WriteLong(OutReg^.Address);
                if not WriteOutRec(pt2, False) then
                begin
                  MakeError('', ecInternalError, '0000A');
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end;
                DisposeStackReg(pt2);
              end;

            end
            else if p^.FType = CVAL_Proc then
            begin
              if GetTypeNo(OutReg)<> at2ut(FBooleanType) then
              begin
                PT2 := AllocStackReg(at2ut(FBooleanType));
              end
              else
                PT2 := OutReg;
              if PIFPSProcedure(FProcs.GetItem(p^.ProcNo))^.Internal then
                PT := AllocStackReg(StrToIntDef(Fw(PIFPSProcedure(FProcs.GetItem(p^.ProcNo))^.Decl), -1))
              else
                PT := AllocStackReg(StrToIntDef(Fw(PIFPSUSedRegProc(FProcs.GetItem(p^.ProcNo))^.rp^.Decl), -1));
              if not ProcessFunction(p^.Modifiers, p^.ProcNo, p^.Parameters, PT) then
              begin
                Result := False;
                exit;
              end;
              pt^.Modifiers := p^.modifiers;
              WriteCalculation(pt, pt);
              pt^.Modifiers := 0;
              PreWriteOutRec(OutReg, Cardinal(-1));
              if tmpcalc <> nil then PreWriteOutRec(tmpcalc, Cardinal(-1));
              WriteCommand(CM_CO);
              WriteByte(C);
              if pt2 = Outreg then
              begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '0000B');
                  Result := False;
                  exit;
                end; {if}
              end
              else
              begin
                if not WriteOutRec(pt2, False) then
                begin
                  MakeError('', ecInternalError, '0000B');
                  Result := False;
                  exit;
                end; {if}
              end;
              if tmpcalc <> nil then
              begin
                if not WriteOutRec(tmpcalc, true) then
                begin
                  MakeError('', ecInternalError, '0000C');
                  Result := False;
                  exit;
                end; {if}
              end else begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '0000C');
                  Result := False;
                  exit;
                end; {if}
              end;
              if not WriteOutRec(PT, True) then
              begin
                MakeError('', ecInternalError, '0000D');
                Result := False;
                exit;
              end; {if}
              if TmpCalc <> nil then
              begin
                AfterWriteOutRec(TmpCalc);
                tmpcalc := nil;
              end;
              AfterWriteOutRec(OutReg);
              DisposeStackReg(PT);
              if pt2 <> OutReg then
              begin
                if (OutReg^.FType <> CVAL_Addr) or (OutReg^.Address <
                  IFPSAddrNegativeStackStart) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    InData^.DPos;
                  DisposeStackReg(pt2);
                  Result := False;
                  exit;
                end;
                PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address - 1 -
                  IFPSAddrStackStart))^.VarType := GetType(btS32);
                WriteCommand(Cm_ST); // set stack type
                WriteLong(PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address
                  - 1
                  - IFPSAddrStackStart))^.VarType);
                WriteLong(OutReg^.Address - IFPSAddrStackStart);

                WriteCommand(CM_A); // stack assignment
                WriteCommand(CVAL_Addr);
                WriteLong(OutReg^.Address);
                if not WriteOutRec(pt2, False) then
                begin
                  MakeError('', ecInternalError, '0000E');
                  DisposeStackReg(pt2);
                  Result := False;
                  exit;
                end; {if}
                DisposeStackReg(pt2);
              end;
            end
            else
            begin
              if GetTypeNo(OutReg)<> at2ut(FBooleanType) then
              begin
                PT := AllocStackReg(at2ut(FBooleanType));
              end
              else
                PT := OutReg;
              PreWriteOutRec(OutReg, Cardinal(-1));
              PreWriteOutRec(P, GetTypeNo(Outreg));
              if TmpCalc <> nil then PreWriteOutRec(tmpcalc, Cardinal(-1));

              WriteCommand(CM_CO);
              WriteData(C, 1);
              if Pt = OutReg then
              begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '0000F');
                  Result := False;
                  exit;
                end; {if}
              end
              else
              begin
                if not WriteOutRec(PT, False) then
                begin
                  MakeError('', ecInternalError, '0000F');
                  Result := False;
                  exit;
                end; {if}
              end;
              if tmpcalc <> nil then
              begin
                if not WriteOutRec(tmpcalc, True) then
                begin
                  MakeError('', ecInternalError, '00010');
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end; {if}
              end else begin
                if not WriteOutRec(OutReg, False) then
                begin
                  MakeError('', ecInternalError, '00010');
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end; {if}
              end;
              if not WriteOutRec(p, True) then
              begin
                MakeError('', ecInternalError, '00011');
                DisposeStackReg(PT);
                Result := False;
                exit;
              end; {case}
              if TmpCalc <> nil then begin
                AfterWriteOutRec(tmpcalc);
                tmpcalc := nil;
              end;
              AfterWriteOutRec(P);
              AfterWriteOutRec(OutReg);
              if PT <> OutReg then
              begin
                if (OutReg^.FType <> CVAL_Addr) or (OutReg^.Address < IFPSAddrNegativeStackStart) then
                begin
                  MakeError('', ecTypeMismatch, '')^.Position :=
                    InData^.DPos;
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end;
                PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address - 1 -
                  IFPSAddrStackStart))^.VarType := GetType(btS32);
                WriteCommand(Cm_ST); // set stack type
                WriteLong(PIFPSProcVar(proc^.ProcVars.GetItem(OutReg^.Address
                  - 1
                  - IFPSAddrStackStart))^.VarType);
                WriteLong(OutReg^.Address - IFPSAddrStackStart);

                WriteCommand(CM_A); // stack assignment
                WriteCommand(CVAL_Addr);
                WriteLong(OutReg^.Address);
                if not WriteOutRec(PT, False) then
                begin
                  MakeError('', ecInternalError, '00012');
                  DisposeStackReg(PT);
                  Result := False;
                  exit;
                end; {if}
                DisposeStackReg(PT);
              end;
            end; {else if}
          end;
        end; {for}
        l := outreg^.modifiers;
        OutReg^.Modifiers := outreg^.Modifiers or bmodsave;
        WriteCalculation(OutReg, OutReg);
        outreg^.modifiers := l;
      end; {if}
    end
    else
    begin
      if not SameReg(OutReg, InData) then
      begin
        if (indata^.FType <> CVAL_NIL) and not CheckCompatType(OutReg, InData) then
        begin
          MakeError('', ecTypeMismatch, '')^.Position := InData^.DPos;
          Result := False;
          exit;
        end;
        if not PreWriteOutRec(InData, GetTypeNo(Outreg)) then
        begin
          Result := False;
          exit;
        end;
        if not PreWriteOutRec(OutReg, Cardinal(-1)) then
        begin
          Result := False;
          Exit;
        end;
        WriteCommand(CM_A);
        if not WriteOutRec(OutReg, False) then
        begin
          MakeError('', ecInternalError, '00013');
          AfterWriteOutRec(OutReg);
          AfterWriteOutRec(InData);
          Result := False;
          exit;
        end; {if}
        if not WriteOutRec(InData, True) then
        begin
          MakeError('', ecInternalError, '00014');
          AfterWriteOutRec(OutReg);
          AfterWriteOutRec(InData);
          Result := False;
          exit;
        end; {if}
        AfterWriteOutRec(OutReg);
        AfterWriteOutRec(InData);
      end else if InData^.Modifiers = 1 then begin
        InData^.Modifiers := 0;
        PreWriteOutRec(InData, GetTypeNo(Outreg));
        WriteCommand(cm_bn);
        WriteOutRec(InData, False);
        AfterWriteOutRec(InData);
      end else if InData^.Modifiers = 2 then begin
        InData^.Modifiers := 0;
        PreWriteOutRec(InData, GetTypeNo(Outreg));
        WriteCommand(cm_vm);
        WriteOutRec(InData, False);
        AfterWriteOutRec(InData);
      end;
    end; {if}
    Result := True;
  end; {WriteCalculation}

  function ProcessFunction(ResModifiers: Byte; ProcNo: Cardinal; InData: TIfList;
    ResultRegister:
    PIFPSValue): Boolean;
  var
    res: string;
    Tmp: PParam;
    resreg: PIFPSValue;
    l: Longint;

    procedure CleanParams;
    var
      l: Longint;
      x: PIFPSValue;
    begin
      for l := 0 to InData.Count - 1 do
      begin
        x := PParam(InData.GetItem(l))^.OutReg;
        if x <> nil then
        begin
          DisposeStackReg(x);
        end;
      end;
      if resreg <> nil then
      begin
        if Cardinal(StrTointDef(Res, -1)) <> GetTypeNo(resreg) then
        begin
          ResultRegister^.Modifiers := ResModifiers;
          if not WriteCalculation(ResultRegister, resreg) then
          begin
            Result := False;
          end;

          DisposeStackReg(ResultRegister);
        end else DisposeStackReg(resreg);
      end;
    end;
  begin
    if PIFPSProcedure(FProcs.GetItem(ProcNo))^.Internal then
      res := PIFPSProcedure(FProcs.GetItem(ProcNo))^.Decl
    else
      res := PIFPSUsedRegProc(FProcs.GetItem(ProcNo))^.RP^.Decl;
    if Pos(' ', res) > 0 then
      res := copy(res, 1, Pos(' ', res) - 1);
    Result := False;
    if (ResModifiers and 8 <> 0) then
    begin
      if (ResultRegister = nil) then
      begin
        MakeError('', ecNoResult, '');
        Exit;
      end else resreg := nil;
    end else
    if (res = '-1') and (ResultRegister <> nil) then
    begin
      MakeError('', ecNoResult, '');
      exit;
    end
    else if (res <> '-1')  then
    begin
      if (ResultRegister = nil) then
      begin
        resreg := AllocStackReg(StrToInt(res));
        ResultRegister := resreg;
      end else if Cardinal(StrTointDef(Res, -1)) <> GetTypeNo(ResultRegister) then
      begin
        resreg := ResultRegister;
        ResultRegister := AllocStackReg(StrToInt(res));
      end else resreg := nil;
    end
    else
      resreg := nil;

    for l := InData.Count - 1 downto 0 do
    begin
      Tmp := InData.GetItem(l);
      if (Tmp^.InReg^.FType = CVAL_PushAddr) then
      begin
        Tmp^.OutReg := AllocStackReg2(Tmp^.FType);
        PreWriteOutRec(Tmp^.InReg, Cardinal(-1));
        WriteCommand(CM_PV);
        WriteOutRec(Tmp^.InReg, False);
        AfterWriteOutRec(Tmp^.InReg);
      end
      else
      begin
        Tmp^.OutReg := AllocStackReg(Tmp^.FType);
        if not WriteCalculation(Tmp^.InReg, Tmp^.OutReg) then
        begin
          CleanParams;
          exit;
        end;
      end;
      DisposePValue(Tmp^.InReg);
      Tmp^.InReg := nil;
    end; {for}
    if (res <> '-1') or (ResModifiers and 8 <> 0) then
    begin
      WriteCommand(CM_PV);
      if not WriteOutRec(ResultRegister, False) then
      begin
        CleanParams;
        MakeError('', ecInternalError, '00015');
        exit;
      end;
    end;
    WriteCommand(Cm_C);
    WriteLong(ProcNo);
    if (res <> '-1') or (ResModifiers and 8 <> 0)then
      WriteCommand(CM_PO);
    Result := True;
    CleanParams;
  end; {ProcessFunction}

  function ProcessVarFunction(ResModifiers: Byte; ProcNo: PIFPSValue; InData: TIfList;
    ResultRegister: PIFPSValue): Boolean;
  var
    res: string;
    Tmp: PParam;
    resreg: PIFPSValue;
    l: Longint;

    procedure CleanParams;
    var
      l: Longint;
      x: PIFPSValue;
    begin
      for l := 0 to InData.Count - 1 do
      begin
        x := PParam(InData.GetItem(l))^.OutReg;
        if x <> nil then
        begin
          DisposeStackReg(x);
        end;
      end;
      AfterWriteOutRec(ProcNo);
      if resreg <> nil then
      begin
        if Cardinal(StrTointDef(Res, -1)) <> GetTypeNo(resreg) then
        begin
          ResultRegister^.Modifiers := ResModifiers;
          WriteCalculation(ResultRegister, resreg);
          DisposeStackReg(ResultRegister);
        end else DisposeStackReg(resreg);
      end;
    end;
  begin
    res := PIFPSProceduralType(PIFPSType(FUsedTypes.GetItem(GetTypeNo(ProcNo)))^.Ext)^.ProcDef;
    if Pos(' ', res) > 0 then
      res := copy(res, 1, Pos(' ', res) - 1);
    Result := False;
    if (res = '-1') and (ResultRegister <> nil) then
    begin
      MakeError('', ecNoResult, '');
      exit;
    end
    else if (res <> '-1')  then
    begin
      if (ResultRegister = nil) then
      begin
        resreg := AllocStackReg(StrToInt(res));
        ResultRegister := resreg;
      end else if Cardinal(StrTointDef(Res, -1)) <> GetTypeNo(ResultRegister) then
      begin
        resreg := ResultRegister;
        ResultRegister := AllocStackReg(StrToInt(res));
      end else resreg := nil;
    end
    else
      resreg := nil;

    PreWriteOutRec(ProcNo, Cardinal(-1));
    for l := InData.Count - 1 downto 0 do
    begin
      Tmp := InData.GetItem(l);
      if (Tmp^.InReg^.FType = CVAL_PushAddr) then
      begin
        Tmp^.OutReg := AllocStackReg2(Tmp^.FType);
        PreWriteOutRec(Tmp^.InReg, Cardinal(-1));
        WriteCommand(CM_PV);
        WriteOutRec(Tmp^.InReg, False);
        AfterWriteOutRec(Tmp^.InReg);
      end
      else
      begin
        Tmp^.OutReg := AllocStackReg(Tmp^.FType);
        if not WriteCalculation(Tmp^.InReg, Tmp^.OutReg) then
        begin
          CleanParams;
          exit;
        end;
      end;
      DisposePValue(Tmp^.InReg);
      Tmp^.InReg := nil;
    end; {for}
    if res <> '-1' then
    begin
      WriteCommand(CM_PV);
      if not WriteOutRec(ResultRegister, False) then
      begin
        CleanParams;
        MakeError('', ecInternalError, '00015');
        exit;
      end;
    end;
    WriteCommand(Cm_cv);
    WriteOutRec(ProcNo, True);
    if res <> '-1' then
      WriteCommand(CM_PO);
    Result := True;
    CleanParams;
  end; {ProcessVarFunction}

  function HasInvalidJumps(StartPos, EndPos: Cardinal): Boolean;
  var
    I, J: Longint;
    Ok: LongBool;
    FLabelsInBlock: TIfStringList;
    s: string;
  begin
    FLabelsInBlock := TIfStringList.Create;
    for i := 0 to Proc^.FLabels.Count -1 do
    begin
      s := Proc^.FLabels.GetItem(I);
      if (Cardinal((@s[1])^) >= StartPos) and (Cardinal((@s[1])^) <= EndPos) then
      begin
        Delete(s, 1, 8);
        FLabelsInBlock.Add(s);
      end;
    end;
    for i := 0 to Proc^.FGotos.Count -1 do
    begin
      s := Proc^.FGotos.GetItem(I);
      if (Cardinal((@s[1])^) >= StartPos) and (Cardinal((@s[1])^) <= EndPos) then
      begin
        Delete(s, 1, 8);
        OK := False;
        for J := 0 to FLabelsInBlock.Count -1 do
        begin
          if FLabelsInBlock.GetItem(J) = s then
          begin
            Ok := True;
            Break;
          end;
        end;
        if not Ok then
        begin
          MakeError('', ecInvalidJump, '');
          Result := True;
          FLabelsInBlock.Free;
          exit;
        end;
      end else begin
        Delete(s, 1, 4);
        OK := True;
        for J := 0 to FLabelsInBlock.Count -1 do
        begin
          if FLabelsInBlock.GetItem(J) = s then
          begin
            Ok := False;
            Break;
          end;
        end;
        if not Ok then
        begin
          MakeError('', ecInvalidJump, '');
          Result := True;
          FLabelsInBlock.Free;
          exit;
        end;
      end;
    end;
    FLabelsInBlock.Free;
    Result := False;
  end;

  function ProcessFor: Boolean;
    { Process a for x := y to z do }
  var
    VVar: PIFPSValue;
    TempVar,
      InitialVal,
      finalVal: PIFPSValue;
    Backwards: Boolean;
    FPos, NPos, EPos, RPos: Longint;
    OldCO, OldBO: TIfList;
    I: Longint;
  begin
    Debug_WriteLine;
    Result := False;
    FParser.Next;
    if FParser.CurrTokenId <> CSTI_Identifier then
    begin
      MakeError('', ecIdentifierExpected, '');
      exit;
    end;
    VVar := GetIdentifier(1);
    if VVar = nil then
      exit;
    case PIFPSType(FUsedTypes.GetItem(GetTypeNo(VVar)))^.BaseType of
      btU8, btS8, btU16, btS16, btU32, btS32: ;
    else
      begin
        MakeError('', ecTypeMismatch, '');
        DisposePValue(VVar);
        exit;
      end;
    end;
    if FParser.CurrTokenId <> CSTI_Assignment then
    begin
      MakeError('', ecAssignmentExpected, '');
      DisposePValue(VVar);
      exit;
    end;
    FParser.Next;
    InitialVal := calc(CSTII_DownTo);
    if InitialVal = nil then
    begin
      DisposePValue(VVar);
      exit;
    end;
    if FParser.CurrTokenId = CSTII_To then
      Backwards := False
    else if FParser.CurrTokenId = CSTII_DownTo then
      Backwards := True
    else
    begin
      MakeError('', ecToExpected, '');
      DisposePValue(VVar);
      DisposePValue(InitialVal);
      exit;
    end;
    FParser.Next;
    finalVal := calc(CSTII_do);
    if finalVal = nil then
    begin
      DisposePValue(VVar);
      DisposePValue(InitialVal);
      exit;
    end;
    if FParser.CurrTokenId <> CSTII_do then
    begin
      MakeError('', ecDoExpected, '');
      DisposePValue(VVar);
      DisposePValue(InitialVal);
      DisposePValue(finalVal);
      exit;
    end;
    FParser.Next;
    if not WriteCalculation(InitialVal, VVar) then
    begin
      DisposePValue(VVar);
      DisposePValue(InitialVal);
      DisposePValue(finalVal);
      exit;
    end;
    DisposePValue(InitialVal);
    TempVar := AllocStackReg(at2ut(FBooleanType));
    NPos := Length(proc^.Data);
    PreWriteOutRec(VVar, Cardinal(-1));
    PreWriteOutRec(finalVal, Cardinal(-1));
    WriteCommand(CM_CO);
    if Backwards then
    begin
      WriteByte(0); { >= }
    end
    else
    begin
      WriteByte(1); { <= }
    end;
    if not WriteOutRec(TempVar, False) then
    begin
      DisposePValue(TempVar);
      DisposePValue(VVar);
      DisposePValue(finalVal);
      exit;
    end;
    WriteOutRec(VVar, False);
    WriteOutRec(finalVal, True);
    AfterWriteOutRec(finalVal);
    AfterWriteOutRec(VVar);
    WriteCommand(Cm_CNG);
    EPos := Length(proc^.Data);
    WriteLong($12345678);
    WriteOutRec(TempVar, False);
    RPos := Length(proc^.Data);
    OldCO := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    if not ProcessSub(tOneliner, ProcNo, proc) then
    begin
      DisposePValue(TempVar);
      DisposePValue(VVar);
      DisposePValue(finalVal);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    New(InitialVal);
    InitialVal^.FType := CVAL_Data;
    New(InitialVal^.FData);
    InitialVal^.FData^.FType := GetTypeNo(VVar);
    case PIFPSType(FUsedTypes.GetItem(InitialVal^.FData^.FType))^.BaseType
      of
      btU8, btS8: InitialVal^.FData^.Value := #1;
      btU16, btS16: InitialVal^.FData^.Value := #1#0;
      btU32, btS32: InitialVal^.FData^.Value := #1#0#0#0;
    else
      begin
        MakeError('', ecInternalError, '00019');
        DisposePValue(TempVar);
        DisposePValue(VVar);
        DisposePValue(finalVal);
        DisposePValue(InitialVal);
        FBreakOffsets.Free;
        FContinueOffsets.Free;
        FContinueOffsets := OldCO;
        FBreakOffsets := OldBo;
        exit;
      end;
    end;
    FPos := Length(Proc^.Data);
    PreWriteOutRec(InitialVal, Cardinal(-1));
    PreWriteOutRec(VVar, Cardinal(-1));
    WriteCommand(CM_CA);
    if Backwards then
      WriteByte(1) {-}
    else
      WriteByte(0); {+}
    WriteOutRec(VVar, False);
    WriteOutRec(InitialVal, True);
    AfterWriteOutRec(VVar);
    AfterWriteOutRec(InitialVal);
    DisposePValue(InitialVal);
    WriteCommand(Cm_G);
    WriteLong(Longint(NPos - Length(proc^.Data) - 4));
    Longint((@proc^.Data[EPos + 1])^) := Length(proc^.Data) - RPos;
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Length(proc^.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Longint(FPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    DisposeStackReg(TempVar);
    DisposePValue(VVar);
    DisposePValue(finalVal);
    if HasInvalidJumps(RPos, Length(Proc^.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessFor}

  function ProcessWhile: Boolean;
  var
    vin, vout: PIFPSValue;
    SPos, EPos: Cardinal;
    OldCo, OldBO: TIfList;
    I: Longint;
  begin
    Result := False;
    Debug_WriteLine;
    FParser.Next;
    vout := calc(CSTII_do);
    if vout = nil then
      exit;
    if FParser.CurrTokenId <> CSTII_do then
    begin
      DisposePValue(vout);
      MakeError('', ecDoExpected, '');
      exit;
    end;
    vin := AllocStackReg(at2ut(FBooleanType));
    SPos := Length(proc^.Data); // start position
    OldCo := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    if not WriteCalculation(vout, vin) then
    begin
      DisposePValue(vout);
      DisposeStackReg(vin);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    DisposePValue(vout);
    FParser.Next; // skip DO
    WriteCommand(Cm_CNG); // only goto if expression is false
    WriteLong($12345678);
    EPos := Length(proc^.Data);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00017');
      DisposeStackReg(vin);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    if not ProcessSub(tOneliner, ProcNo, proc) then
    begin
      DisposeStackReg(vin);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Debug_WriteLine;
    WriteCommand(Cm_G);
    WriteLong(Longint(SPos) - Length(proc^.Data) - 4);
    Longint((@proc^.Data[EPos - 3])^) := Length(proc^.Data) - Longint(EPos) - 5;
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Length(proc^.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Longint(SPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    DisposeStackReg(vin);
    if HasInvalidJumps(EPos, Length(Proc^.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end;

  function ProcessRepeat: Boolean;
  var
    vin, vout: PIFPSValue;
    SPos, EPos: Cardinal;
    I: Longint;
    OldCo, OldBO: TIfList;
  begin
    Result := False;
    Debug_WriteLine;
    FParser.Next;
    OldCo := FContinueOffsets;
    FContinueOffsets := TIfList.Create;
    OldBO := FBreakOffsets;
    FBreakOffsets := TIFList.Create;
    vin := AllocStackReg(at2ut(FBooleanType));
    SPos := Length(proc^.Data);
    if not ProcessSub(tRepeat, ProcNo, proc) then
    begin
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      DisposeStackReg(vin);
      exit;
    end;
    FParser.Next; //cstii_until
    vout := calc(CSTI_Semicolon);
    if vout = nil then
    begin
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      DisposeStackReg(vin);
      exit;
    end;
    if not WriteCalculation(vout, vin) then
    begin
      DisposePValue(vout);
      DisposeStackReg(vin);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    DisposePValue(vout);
    WriteCommand(Cm_CNG);
    WriteLong($12345678);
    EPos := Length(proc^.Data);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00016');
      DisposeStackReg(vin);
      FBreakOffsets.Free;
      FContinueOffsets.Free;
      FContinueOffsets := OldCO;
      FBreakOffsets := OldBo;
      exit;
    end;
    Longint((@proc^.Data[EPos - 3])^) := Longint(SPos) -
      Length(proc^.Data);
    for i := 0 to FBreakOffsets.Count -1 do
    begin
      EPos := Cardinal(FBreakOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Length(proc^.Data) - Longint(EPos);
    end;
    for i := 0 to FContinueOffsets.Count -1 do
    begin
      EPos := Cardinal(FContinueOffsets.GetItem(I));
      Longint((@proc^.Data[EPos - 3])^) := Longint(SPos) - Longint(EPos);
    end;
    FBreakOffsets.Free;
    FContinueOffsets.Free;
    FContinueOffsets := OldCO;
    FBreakOffsets := OldBo;
    DisposeStackReg(vin);
    if HasInvalidJumps(SPos, Length(Proc^.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessRepeat}

  function ProcessIf: Boolean;
  var
    vout, vin: PIFPSValue;
    SPos, EPos: Cardinal;
  begin
    Result := False;
    Debug_WriteLine;
    FParser.Next;
    vout := calc(CSTII_Then);
    if vout = nil then
      exit;
    if FParser.CurrTokenId <> CSTII_Then then
    begin
      DisposePValue(vout);
      MakeError('', ecThenExpected, '');
      exit;
    end;
    vin := AllocStackReg(at2ut(FBooleanType));
    if not WriteCalculation(vout, vin) then
    begin
      DisposePValue(vout);
      DisposeStackReg(vin);
      exit;
    end;
    DisposePValue(vout);
    WriteCommand(cm_sf);
    if not WriteOutRec(vin, False) then
    begin
      MakeError('', ecInternalError, '00018');
      DisposeStackReg(vin);
      exit;
    end;
    WriteByte(1);
    DisposeStackReg(vin);
    WriteCommand(cm_fg);
    WriteLong($12345678);
    SPos := Length(proc^.Data);
    FParser.Next; // skip then
    if not ProcessSub(tifOneliner, Procno, proc) then
    begin
      exit;
    end;
    if FParser.CurrTokenId = CSTII_Else then
    begin
      WriteCommand(Cm_G);
      WriteLong($12345678);
      EPos := Length(proc^.Data);
      Longint((@proc^.Data[SPos - 3])^) := Length(proc^.Data) -
        Longint(SPos);
      FParser.Next;
      if not ProcessSub(tOneliner, ProcNo, proc) then
      begin
        exit;
      end;
      Longint((@proc^.Data[EPos - 3])^) := Length(proc^.Data) - Longint(EPos);
    end
    else
    begin
      Longint((@proc^.Data[SPos - 3])^) := Length(proc^.Data) -
        Longint(SPos) + 5
        - 5;
    end;
    Result := True;
  end; {ProcessIf}

  function ProcessLabel: Longint; {0 = failed; 1 = successful; 2 = no label}
  var
    I, H: Longint;
    s: string;
  begin
    h := MakeHash(FParser.GetToken);
    for i := 0 to Proc^.FLabels.Count -1 do
    begin
      s := proc^.FLabels.GetItem(I);
      delete(s, 1, 4);
      if Longint((@s[1])^) = h then
      begin
        delete(s, 1, 4);
        if s = FParser.GetToken then
        begin
          s := proc^.FLabels.GetItem(I);
          Cardinal((@s[1])^) := Length(Proc^.Data);
          Proc^.FLabels.SetItem(i, s);
          FParser.Next;
          if fParser.CurrTokenId = CSTI_Colon then
          begin
            Result := 1;
            FParser.Next;
            exit;
          end else begin
            MakeError('', ecColonExpected, '');
            Result := 0;
            Exit;
          end;
        end;
      end;
    end;
    result := 2;
  end;

  function ProcessIdentifier: Boolean;
  var
    vin, vout: PIFPSValue;
  begin
    Result := False;
    Debug_WriteLine;
    vin := GetIdentifier(2);
    if vin <> nil then
    begin
      if vin^.FType < CVAL_Proc then
      begin // assignment needed
        if FParser.CurrTokenId <> CSTI_Assignment then
        begin
          MakeError('', ecAssignmentExpected, '');
          DisposePValue(vin);
          exit;
        end;
        FParser.Next;
        vout := calc(CSTI_Semicolon);
        if vout = nil then
        begin
          DisposePValue(vin);
          exit;
        end;
        if not WriteCalculation(vout, vin) then
        begin
          DisposePValue(vin);
          DisposePValue(vout);
          exit;
        end;
        DisposePValue(vin);
        DisposePValue(vout);
      end
      else if vin^.FType = CVAL_VarProc then
      begin
        Result := ProcessVarFunction(0, Vin^._ProcNo, vin^._Parameters, nil);
        DisposePValue(vin);
        Exit;
      end else
      begin
        Result := ProcessFunction(0, vin^.ProcNo, vin^.Parameters, nil);
        DisposePValue(vin);
        exit;
      end;
    end
    else
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessIdentifier}

  function ProcessCase: Boolean;
  var
    TempRec, CV, Val, CalcItem: PIFPSValue;
    p: PCalc_Item;
    SPos, CurrP: Cardinal;
    I: Longint;
    EndReloc: TIfList;
  begin
    Debug_WriteLine;
    FParser.Next;
    Val := calc(CSTII_of);
    if Val = nil then
    begin
      ProcessCase := False;
      exit;
    end; {if}
    if FParser.CurrTokenId <> CSTII_Of then
    begin
      MakeError('', ecOfExpected, '');
      DisposePValue(Val);
      ProcessCase := False;
      exit;
    end; {if}
    FParser.Next;
    TempRec := AllocStackReg(GetTypeNo(Val));
    if not WriteCalculation(Val, TempRec) then
    begin
      DisposeStackReg(TempRec);
      DisposePValue(Val);
      ProcessCase := False;
      exit;
    end; {if}
    DisposePValue(Val);
    EndReloc := TIfList.Create;
    CalcItem := AllocStackReg(at2ut(FBooleanType));
    SPos := Length(Proc^.Data);
    repeat
      Val := calc(CSTI_Colon);
      if (Val = nil) or (FParser.CurrTokenID <> CSTI_Colon) then
      begin
        if FParser.CurrTokenID <> CSTI_Colon then
          MakeError('', ecColonExpected, '');
        DisposeStackReg(CalcItem);
        DisposeStackReg(TempRec);
        EndReloc.Free;
        ProcessCase := False;
        exit;
      end; {if}
      FParser.Next;
      New(cv);
      cv^.DPos := FParser.CurrTokenPos;
      cv^.FType := CVAL_Eval;
      cv^.SubItems:= TIfList.Create;
      cv^.Modifiers := 0;
      new(p);
      p^.C := False;
      p^.OutRec := Val;
      cv^.SubItems.Add(p);
      new(p);
      p^.C := True;
      p^.calcCmd := 15;
      cv^.SubItems.Add(p);
      new(p);
      p^.C := False;
      p^.OutRec := TempRec;
      cv^.SubItems.Add(p);
      if not WriteCalculation(CV, CalcItem) then
      begin
        DisposeStackReg(CalcItem);
        DisposePValue(CV);
        EndReloc.Free;
        ProcessCase := False;
        exit;
      end;
      Cv.SubItems.Delete(2);
      Dispose(p);
      DisposePValue(CV);
      WriteByte(Cm_CNG);
      WriteLong($12345678);
      CurrP := Length(Proc^.Data);
      WriteOutRec(CalcItem, False);
      if not ProcessSub(tifOneliner, Procno, proc) then
      begin
        DisposeStackReg(CalcItem);
        DisposeStackReg(TempRec);
        EndReloc.Free;
        ProcessCase := False;
        exit;
      end;
      WriteByte(Cm_G);
      WriteLong($12345678);
      EndReloc.Add(Pointer(Length(Proc^.Data)));
      Cardinal((@Proc^.Data[CurrP - 3])^) := Cardinal(Length(Proc^.Data)) - CurrP - 5;
      if FParser.CurrTokenID = CSTI_Semicolon then FParser.Next;
      if FParser.CurrTokenID = CSTII_Else then
      begin
        FParser.Next;
        if not ProcessSub(tOneliner, Procno, proc) then
        begin
          DisposeStackReg(CalcItem);
          DisposeStackReg(TempRec);
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end;
        if FParser.CurrTokenID = CSTI_Semicolon then FParser.Next;
        if FParser.CurrtokenId <> CSTII_End then
        begin
          MakeError('', ecEndExpected, '');
          DisposeStackReg(CalcItem);
          DisposeStackReg(TempRec);
          EndReloc.Free;
          ProcessCase := False;
          exit;
        end;
      end;
    until FParser.CurrTokenID = CSTII_End;
    FParser.Next;
    for i := 0 to EndReloc.Count -1 do
    begin
      Cardinal((@Proc^.Data[Cardinal(EndReloc.GetItem(I))- 3])^) := Cardinal(Length(Proc^.Data)) - Cardinal(EndReloc.GetItem(I));
    end;
    DisposeStackReg(CalcItem);
    DisposeStackReg(TempRec);
    EndReloc.Free;
    if HasInvalidJumps(SPos, Length(Proc^.Data)) then
    begin
      Result := False;
      exit;
    end;
    Result := True;
  end; {ProcessCase}
  function ProcessGoto: Boolean;
  var
    I, H: Longint;
    s: string;
  begin
    Debug_WriteLine;
    FParser.Next;
    h := MakeHash(FParser.GetToken);
    for i := 0 to Proc^.FLabels.Count -1 do
    begin
      s := proc^.FLabels.GetItem(I);
      delete(s, 1, 4);
      if Longint((@s[1])^) = h then
      begin
        delete(s, 1, 4);
        if s = FParser.GetToken then
        begin
          FParser.Next;
          WriteCommand(Cm_G);
          WriteLong($12345678);
          Proc^.FGotos.Add(mi2s(length(Proc^.Data))+mi2s(i));
          Result := True;
          exit;
        end;
      end;
    end;
    MakeError('', ecUnknownIdentifier, FParser.OriginalToken);
    Result := False;
  end; {ProcessGoto}
  function ProcessTry: Boolean;
  var
    FStartOffset: Cardinal;
  begin
    FParser.Next;
    WriteCommand(cm_puexh);
    FStartOffset := Length(Proc^.Data) + 1;
    WriteLong(Cardinal(-1));
    WriteLong(Cardinal(-1));
    WriteLong(Cardinal(-1));
    WriteLong(Cardinal(-1));
    if ProcessSub(tTry, ProcNo, Proc) then
    begin
      WriteCommand(cmd_poexh);
      WriteByte(0);
      if FParser.CurrTokenID = CSTII_Except then
      begin
        FParser.Next;
        Cardinal((@Proc^.Data[FStartOffset + 4])^) := Cardinal(Length(Proc^.Data)) - FStartOffset - 15;
        if ProcessSub(tTryEnd, ProcNo, Proc) then
        begin
          WriteCommand(cmd_poexh);
          writeByte(2);
          if FParser.CurrTokenId = CSTII_Finally then
          begin
            Cardinal((@Proc^.Data[FStartOffset + 8])^) := Cardinal(Length(Proc^.Data)) - FStartOffset - 15;
            FParser.Next;
            if ProcessSub(tTryEnd, ProcNo, Proc) then
            begin
              if FParser.CurrTokenId = CSTII_End then
              begin
                WriteCommand(cmd_poexh);
                writeByte(3);
              end else begin
                MakeError('', ecEndExpected, '');
                Result := False;
                exit;
              end;
            end else begin Result := False; exit; end;
          end else if FParser.CurrTokenID <> CSTII_End then
          begin
            MakeError('', ecEndExpected, '');
            Result := False;
            exit;
          end;
          FParser.Next;
        end else begin Result := False; exit; end;
      end else if FParser.CurrTokenId = CSTII_Finally then
      begin
        FParser.Next;
        Cardinal((@Proc^.Data[FStartOffset])^) := Cardinal(Length(Proc^.Data)) - FStartOffset - 15;
        if ProcessSub(tTryEnd, ProcNo, Proc) then
        begin
          WriteCommand(cmd_poexh);
          writeByte(1);
          if FParser.CurrTokenId = CSTII_Except then
          begin
            Cardinal((@Proc^.Data[FStartOffset + 4])^) := Cardinal(Length(Proc^.Data)) - FStartOffset - 15;
            FParser.Next;
            if ProcessSub(tTryEnd, ProcNo, Proc) then
            begin
              if FParser.CurrTokenId = CSTII_End then
              begin
                WriteCommand(cmd_poexh);
                writeByte(2);
              end else begin
                MakeError('', ecEndExpected, '');
                Result := False;
                exit;
              end;
            end else begin Result := False; exit; end;
          end else if FParser.CurrTokenID <> CSTII_End then
          begin
            MakeError('', ecEndExpected, '');
            Result := False;
            exit;
          end;
          FParser.Next;
        end else begin Result := False; exit; end;
      end;
    end else begin Result := False; exit; end;
    Cardinal((@Proc^.Data[FStartOffset + 12])^) := Cardinal(Length(Proc^.Data)) - FStartOffset - 15;
    Result := True;
  end; {ProcessTry}
begin
  ProcessSub := False;
  if (FType = tProcBegin) or (FType = tMainBegin) or (FType = tSubBegin) then
  begin
    FParser.Next; // skip CSTII_Begin
  end;
  while True do
  begin
    case FParser.CurrTokenId of
      CSTII_break:
        begin
          if FBreakOffsets = nil then
          begin
            MakeError('', ecNotInLoop, '');
            exit;
          end;
          WriteCommand(Cm_G);
          WriteLong($12345678);
          FBreakOffsets.Add(Pointer(Length(Proc^.Data)));
          FParser.Next;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Continue:
        begin
          if FBreakOffsets = nil then
          begin
            MakeError('', ecNotInLoop, '');
            exit;
          end;
          WriteCommand(Cm_G);
          WriteLong($12345678);
          FContinueOffsets.Add(Pointer(Length(Proc^.Data)));
          FParser.Next;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Goto:
        begin
          if not ProcessGoto then
            Exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Try:
        begin
          if not ProcessTry then
            Exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Finally, CSTII_Except:
        begin
          if (FType = tTry) or (FType = tTryEnd) then
            Break
          else
            begin
              MakeError('', ecEndExpected, '');
              Exit;
            end;
        end;
      CSTII_Begin:
        begin
          if not ProcessSub(tSubBegin, ProcNo, proc) then
            Exit;
          FParser.Next; // skip END
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTI_Semicolon:
        begin
          FParser.Next;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_until:
        begin
          Debug_WriteLine;
          if FType = tRepeat then
          begin
            break;
          end
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Else:
        begin
          if FType = tifOneliner then
            break
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
        end;
      CSTII_repeat:
        begin
          if not ProcessRepeat then
            exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_For:
        begin
          if not ProcessFor then
            exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_While:
        begin
          if not ProcessWhile then
            exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_Exit:
        begin
          Debug_WriteLine;
          WriteCommand(Cm_R);
          FParser.Next;
        end;
      CSTII_Case:
        begin
          if not ProcessCase then
            exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTII_If:
        begin
          if not ProcessIf then
            exit;
          if (FType = tifOneliner) or (FType = TOneLiner) then
            break;
        end;
      CSTI_Identifier:
        begin
          case ProcessLabel of
            0: Exit;
            1: ;
            else
            begin
              if not ProcessIdentifier then
                exit;
              if (FType = tifOneliner) or (FType = TOneLiner) then
                break;
            end;
          end; {case}
        end;
      CSTII_End:
        begin
          if (FType = tTryEnd) or (FType = tMainBegin) or (FType = tSubBegin) or (FType =
            tifOneliner) or (FType = tProcBegin) or (FType = TOneLiner) then
          begin
            break;
          end
          else
          begin
            MakeError('', ecIdentifierExpected, '');
            exit;
          end;
        end;
      CSTI_EOF:
        begin
          MakeError('', ecUnexpectedEndOfFile, '');
          exit;
        end;
    else
      begin
        MakeError('', ecIdentifierExpected, '');
        exit;
      end;
    end;
  end;
  if (FType = tMainBegin) or (FType = tProcBegin) then
  begin
    WriteCommand(Cm_R);
    FParser.Next; // skip end
    if (FType = tMainBegin) and (FParser.CurrTokenId <> CSTI_Period) then
    begin
      MakeError('', ecPeriodExpected, '');
      exit;
    end;
    if (FType = tProcBegin) and (FParser.CurrTokenId <> CSTI_Semicolon) then
    begin
      MakeError('', ecSemicolonExpected, '');
      exit;
    end;
    FParser.Next;
  end;
  ProcessSub := True;
end;


function TIFPSPascalCompiler.ProcessLabelForwards(Proc: PIFPSProcedure): Boolean;
var
  i: Longint;
  s, s2: string;
begin
  for i := 0 to Proc^.FLabels.Count -1 do
  begin
    s := Proc^.FLabels.GetItem(i);
    if Longint((@s[1])^) = -1 then
    begin
      delete(s, 1, 8);
      MakeError('', ecUnSetLabel, s);
      Result := False;
      exit;
    end;
  end;
  for i := proc^.FGotos.Count -1 downto 0 do
  begin
    s := proc^.FGotos.GetItem(I);
    s2 := Proc^.FLabels.GetItem(Cardinal((@s[5])^));
    Cardinal((@Proc^.Data[Cardinal((@s[1])^)-3])^) :=  Cardinal((@s2[1])^) - Cardinal((@s[1])^) ;
  end;
  Result := True;
end;



function TIFPSPascalCompiler.Compile(const s: string): Boolean;
var
  Position: Byte;
  i: Longint;

  procedure FreeAll;
  var
    I, I2: Longint;
    PPV: PIFPSProcVar;
    PT: PIFPSType;
    pp: PIFPSProcedure;
    pc: PIFPSConstant;
    ppe: PIFPSUsedRegProc;
    pv: PIFPSVar;
    pr: PIFPSRegProc;
    pn: PIFPSProceduralType;

    procedure FreeRecord(v: TIfList);
    var
      I: Longint;
      p: PIFPSRecordType;
    begin
      for I := 0 to v.Count - 1 do
      begin
        p := v.GetItem(I);
        p^.FieldName := '';
        Dispose(p);
      end;
      v.Free;
    end;
  begin
    for I := 0 to FRegProcs.Count - 1 do
    begin
      pr := FRegProcs.GetItem(I);
      Dispose(pr);
    end;
    FRegProcs.Free;
    for i := 0 to FConstants.Count -1 do
    begin
      pc := FConstants.GetItem(I);
      Dispose(pc);
    end;
    Fconstants.Free;
    for I := 0 to FVars.Count - 1 do
    begin
      pv := FVars.GetItem(I);
      Dispose(pv);
    end;
    FVars.Free;
    for I := 0 to FProcs.Count - 1 do
    begin
      ppe := FProcs.GetItem(I);
      if ppe^.Internal then
      begin
        pp := Pointer(ppe);
        for I2 := 0 to pp^.ProcVars.Count - 1 do
        begin
          PPV := pp^.ProcVars.GetItem(I2);
          Dispose(PPV);
        end;
        pp^.ProcVars.Free;
        pp^.FGotos.Free;
        pp^.FLabels.Free;
        Dispose(pp);
      end
      else
      begin
        Dispose(ppe);
      end;

    end;
    FProcs.Free;
    FProcs := nil;
    for I := 0 to FAvailableTypes.Count - 1 do
    begin
      PT := FAvailableTypes.GetItem(I);
      if pt^.BaseType = btProcPtr then
      begin
        pn := pt^.Ext;
        Dispose(pn);
      end else if PT^.BaseType = btRecord then
        FreeRecord(PT^.RecordSubVals)
      else if (pt^.BaseType = btClass) and (pt^.Ext <> nil) then
      begin
        TIFPSExternalClass(pt^.Ext).Free;
      end;
      Dispose(PT);
    end;
    FAvailableTypes.Free;
    FUsedTypes.Free;
  end;



  procedure MakeOutput;

    procedure WriteByte(b: Byte);
    begin
      FOutput := FOutput + Char(b);
    end;

    procedure WriteData(const Data; Len: Longint);
    begin
      SetLength(FOutput, Length(FOutput) + Len);
      Move(Data, FOutput[Length(FOutput) - Len + 1], Len);
    end;

    procedure WriteLong(l: Cardinal);
    begin
      WriteData(l, 4);
    end;


    procedure WriteTypes;
    var
      l, n: Longint;
      Tmp: Cardinal;
      x: PIFPSType;
      xxp: PIFPSProceduralType;
      FExportName: string;
    begin
      for l := 0 to FUsedTypes.Count - 1 do
      begin
        x := FUsedTypes.GetItem(l);
        if x^.BaseType = btChar then x^.BaseType := btu8;
        if x^.FExport then
          FExportName := x^.Name
        else
          FExportName := '';
        if x^.BaseType = btClass then
        begin
          x := GetTypeCopyLink(FAvailableTypes.GetItem(TIFPSExternalClass(x^.Ext).SelfType));
        end;
        if (x^.BaseType = btString)and (x^.Ext = Pointer(1))then x^.BaseType := btPChar;
        if (x^.BaseType = btEnum) then begin
          if Longint(x^.Ext) <= 256 then
            x^.BaseType := btU8
          else if Longint(x^.Ext) <= 65536 then
            x^.BaseType := btU16
          else
            x^.BaseType := btU32;
        end;
        if x^.BaseType = btProcPtr then begin
          xxp := x^.Ext;
          Dispose(xxp);
          x^.Ext := nil;
          x^.BaseType := btu32;
        end;
        if FExportName <> '' then
        begin
          WriteByte(x^.BaseType + 128);
        end
        else
          WriteByte(X^.BaseType);
        if x^.BaseType = btArray then
        begin
          WriteLong(Longint(x^.Ext));
        end
        else if x^.BaseType = btRecord then
        begin
          n := x^.RecordSubVals.Count;
          WriteData(n, 4);
          for n := 0 to x^.RecordSubVals.Count - 1 do
          begin
            Tmp := PIFPSRecordType(x^.RecordSubVals.GetItem(n))^.FType;
            WriteData(Tmp, 4);
          end;
        end;
        if FExportName <> '' then
        begin
          WriteLong(Length(FExportName));
          WriteData(FExportName[1], length(FExportName));
        end;
      end;
    end;

    procedure WriteVars;
    var
      l: Longint;
      x: PIFPSVar;
    begin
      for l := 0 to FVars.Count - 1 do
      begin
        x := FVars.GetItem(l);
        WriteLong(x^.FType);
        if x^.exportname <> '' then
        begin
          WriteByte(1);
          WriteLong(Length(X^.ExportName));
          WriteData(X^.ExportName[1], length(X^.ExportName));
        end else
          WriteByte(0);
      end;
    end;

    procedure WriteProcs;
    var
      l: Longint;
      x: PIFPSProcedure;
      xp: PIFPSUsedRegProc;
      s: string;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        x := FProcs.GetItem(l);
        if x^.Internal then
        begin
          x^.OutputDeclPosition := Length(FOutput);
          if x^.FExport <> 0 then
            WriteByte(2) // exported
          else
            WriteByte(0); // not imported
          WriteLong(0); // offset is unknown at this time
          WriteLong(0); // length is also unknown at this time
          if x^.FExport <> 0 then
          begin
            WriteLong(Length(x^.Name));
            WriteData(x^.Name[1], length(x^.Name));
            if x^.FExport = 1 then
            begin
              WriteLong(0);
            end else begin
              s := MakeExportDecl(x^.Decl);
              WriteLong(Length(s));
              WriteData(s[1], length(S));
            end;
          end;
        end
        else
        begin
          xp := Pointer(x);
          if xp^.RP^.ImportDecl <> '' then
          begin
            WriteByte(3); // imported
            if xp^.Rp^.FExportName then
            begin
              WriteByte(Length(xp^.RP^.Name));
              WriteData(xp^.RP^.Name[1], Length(xp^.RP^.Name) and $FF);
            end else begin
              WriteByte(0);
            end;
            WriteLong(Length(xp^.RP^.ImportDecl));
            WriteData(xp^.RP^.ImportDecl[1], Length(xp^.RP^.ImportDecl));
          end else begin
            WriteByte(1); // imported
            WriteByte(Length(xp^.RP^.Name));
            WriteData(xp^.RP^.Name[1], Length(xp^.RP^.Name) and $FF);
          end;
        end;
      end;
    end;

    procedure WriteProcs2;
    var
      l: Longint;
      L2: Cardinal;
      x: PIFPSProcedure;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        x := FProcs.GetItem(l);
        if x^.Internal then
        begin
          L2 := Length(FOutput);
          Move(L2, FOutput[x^.OutputDeclPosition + 2], 4);
          // write position
          WriteData(x^.Data[1], Length(x^.Data));
          L2 := Cardinal(Length(FOutput)) - L2;
          Move(L2, FOutput[x^.OutputDeclPosition + 6], 4); // write length
        end;
      end;
    end;

    function FindMainProc: Cardinal;
    var
      l: Longint;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        if (PIFPSProcedure(FProcs.GetItem(l))^.Internal) and
          (PIFPSProcedure(FProcs.GetItem(l))^.Name = IFPSMainProcName) then
        begin
          Result := l;
          exit;
        end;
      end;
      Result := Cardinal(-1);
    end;
    procedure CreateDebugData;
    var
      I: Longint;
      p: PIFPSProcedure;
      pv: PIFPSVar;
      s: string;
    begin
      s := #0;
      for I := 0 to FProcs.Count - 1 do
      begin
        p := FProcs.GetItem(I);
        if p^.Internal then
        begin
          if p^.Name = IFPSMainProcName then
            s := s + #1
          else
            s := s + p^.Name + #1;
        end
        else
        begin
          s := s+ PIFPSUsedRegProc(p)^.RP^.Name + #1;
        end;
      end;
      s := s + #0#1;
      for I := 0 to FVars.Count - 1 do
      begin
        pv := FVars.GetItem(I);
        s := s + pv.Name + #1;
      end;
      s := s + #0;
      WriteDebugData(s);
    end;
  begin
    CreateDebugData;
    WriteLong(IFPSValidHeader);
    WriteLong(IFPSCurrentBuildNo);
    WriteLong(FUsedTypes.Count);
    WriteLong(FProcs.Count);
    WriteLong(FVars.Count);
    WriteLong(FindMainProc);
    WriteLong(0);
    WriteTypes;
    WriteProcs;
    WriteVars;
    WriteProcs2;
  end;

  function CheckExports: Boolean;
  var
    i: Longint;
    p: PIFPSProcedure;
  begin
    if @FOnExportCheck = nil then
    begin
      result := true;
      exit;
    end;
    for i := 0 to FProcs.Count -1 do
    begin
      p := FProcs.GetItem(i);
      if p^.Internal then
      begin
        if not FOnExportCheck(Self, p, MakeDecl(p^.Decl)) then
        begin
          Result := false;
          exit;
        end;
      end;
    end;
    Result := True;
  end;
  function DoConstBlock: Boolean;
  var
    CName: string;
    CValue: PIFRVariant;
    Cp: PIFPSConstant;
  begin
    FParser.Next;
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        Result := False;
        Exit;
      end;
      CName := FParser.GetToken;
      if IsDuplicate(CName) then
      begin
        MakeError('', ecDuplicateIdentifier, '');
        Result := False;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Equal then
      begin
        MakeError('', ecIsExpected, '');
        Result := False;
        Exit;
      end;
      FParser.Next;
      CValue := ReadConstant(CSTI_SemiColon);
      if CValue = nil then
      begin
        Result := False;
        Exit;
      end;
      if FParser.CurrTokenID <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        exit;
      end;
      New(cp);
      cp^.NameHash := MakeHash(CName);
      cp^.Name := CName;
      cp^.Value.FType := CValue^.FType;
      cp^.Value.Value := CValue^.Value;
      FConstants.Add(cp);
      DisposeVariant(CValue);
      FParser.Next;
    until FParser.CurrTokenId <> CSTI_Identifier;
    Result := True;
  end;
  function ProcessUses: Boolean;
  var
    FUses: TIfStringList;
    I: Longint;
    s: string;
  begin
    FParser.Next;
    FUses := TIfStringList.Create;
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FUses.Free;
        Result := False;
        exit;
      end;
      s := FParser.GetToken;
      for i := 0 to FUses.Count -1 do
      begin
        if FUses.GetItem(I) = s then
        begin
          MakeError('', ecDuplicateIdentifier, s);
          FUses.Free;
          Result := False;
          exit;
        end;
      end;
      FUses.Add(s);
      if @FOnUses <> nil then
      begin
        try
          if not OnUses(Self, FParser.GetToken) then
          begin
            FUses.Free;
            Result := False;
            exit;
          end;
        except
          on e: Exception do
          begin
            MakeError('', ecCustomError, e.Message);
            FUses.Free;
            Result := False;
            exit;
          end;
        end;
      end;
      FParser.Next;
      if FParser.CurrTokenID = CSTI_Semicolon then break
      else if FParser.CurrTokenId <> CSTI_Comma then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        FUses.Free;
        exit;
      end;
      FParser.Next;
    until False;
    FParser.next;
    Result := True;
  end;
var
  Proc: PIFPSProcedure;

begin
  FIsUnit := False;
  Result := False;
  Clear;
  FParser.SetText(s);

  FProcs := TIfList.Create;
  FConstants := TIFList.Create;
  FVars := TIfList.Create;
  FAvailableTypes := TIfList.Create;
  FUsedTypes := TIfList.Create;
  FRegProcs := TIfList.Create;
  DefineStandardTypes;
  if @FOnUses <> nil then
  begin
    try
      if not OnUses(Self, 'SYSTEM') then
      begin
        FreeAll;
        exit;
      end;
    except
      on e: Exception do
      begin
        MakeError('', ecCustomError, e.Message);
        FreeAll;
        exit;
      end;
    end;
  end;
  Position := 0;
  Proc := NewProc(IFPSMainProcName);
  repeat
    if FParser.CurrTokenId = CSTI_EOF then
    begin
      if FAllowNoEnd then
        Break
      else
      begin
        MakeError('', ecUnexpectedEndOfFile, '');
        FreeAll;
        exit;
      end;
    end;
    if (FParser.CurrTokenId = CSTII_Program) and (Position = 0) then
    begin
      Position := 1;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
    end else
    if (FParser.CurrTokenId = CSTII_Unit) and (Position = 0) and (FAllowUnit) then
    begin
      Position := 1;
      FIsUnit := True;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
    end
    else if (FParser.CurrTokenID = CSTII_Uses) and (Position < 2) then
    begin
      Position := 2;
      if not ProcessUses then
      begin
        FreeAll;
        exit;
      end;
    end else if (FParser.CurrTokenId = CSTII_Procedure) or
      (FParser.CurrTokenId = CSTII_Function) then
    begin
      Position := 2;
      if not ProcessFunction then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Label) then
    begin
      Position := 2;
      if not ProcessLabel(Proc) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Var) then
    begin
      Position := 2;
      if not DoVarBlock(nil) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Const) then
    begin
      Position := 2;
      if not DoConstBlock then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Type) then
    begin
      Position := 2;
      if not DoTypeBlock(FParser) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Begin) then
    begin
      if ProcessSub(tMainBegin, 0, Proc) then
      begin
        break;
      end
      else
      begin
        FreeAll;
        exit;
      end;
    end
    else if (Fparser.CurrTokenId = CSTII_End) and (FAllowNoBegin or FIsUnit) then
    begin
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Period then
      begin
        MakeError('', ecPeriodExpected, '');
        FreeAll;
        exit;
      end;
      break;
    end else 
    begin
      MakeError('', ecBeginExpected, '');
      FreeAll;
      exit;
    end;
  until False;
  if not ProcessLabelForwards(Proc) then
  begin
    FreeAll;
    exit;
  end;
  for i := 0 to FProcs.Count -1 do
  begin
    Proc := FProcs.GetItem(i);
    if Proc^.Internal and Proc^.Forwarded then
    begin
      MakeError('', ecUnsatisfiedForward, Proc^.Name)^.Position := Proc^.DeclarePosition;
      FreeAll;
      Exit;
    end;
  end;
  if not CheckExports then
  begin
    FreeAll;
    exit;
  end;
  for i := 0 to FVars.Count -1 do
  begin
    if not PIFPSVar(FVars.GetItem(I))^.Used then
    begin
      MakeHint('', ehVariableNotUsed, PIFPSVar(FVars.GetItem(I))^.Name)^.Position := PIFPSVar(FVars.GetItem(I))^.DeclarePosition;
    end;
  end;
  MakeOutput;
  FreeAll;
  Result := True;
end;

constructor TIFPSPascalCompiler.Create;
begin
  inherited Create;
  FParser := TIfPascalParser.Create;
  FParser.OnParserError := ParserError;
  FAutoFreeList := TIfList.Create;
  FOutput := '';
  FMessages := TIfList.Create;
end;

destructor TIFPSPascalCompiler.Destroy;
begin
  Clear;
  FAutoFreeList.Free;

  FMessages.Free;
  FParser.Free;
  inherited Destroy;
end;

function TIFPSPascalCompiler.GetOutput(var s: string): Boolean;
begin
  if Length(FOutput) <> 0 then
  begin
    s := FOutput;
    Result := True;
  end
  else
    Result := False;
end;

function TIFPSPascalCompiler.GetMsg(l: Longint):
  PIFPSPascalCompilerMessage;
begin
  Result := FMessages.GetItem(l);
end;

function TIFPSPascalCompiler.GetMsgCount: Longint;
begin
  Result := FMessages.Count;
end;

procedure TIFPSPascalCompiler.DefineStandardTypes;
begin
  AddType('Byte', btU8);
  AddTypeS('BOOLEAN', '(False, True)');
  FBooleanType := FAvailableTypes.Count -1;
  AddType('Char', btChar);
  AddType('SHORTINT', btS8);
  AddType('WORD', btU16);
  AddType('SMALLINT', btS16);
  AddType('INTEGER', BtTypeCopy)^.Ext := AddType('LONGINT', btS32);
  AddType('CARDINAL', BtTypeCopy)^.Ext := AddType('LONGWORD', btU32);
  AddType('STRING', btString);
  AddType('PCHAR', btString)^.Ext := Pointer(1);
  AddType('SINGLE', btSingle);
  AddType('DOUBLE', btDouble);
  AddType('EXTENDED', btExtended);
  AddType('VARIANT', btVariant);
  AddType('TVARIANTARRAY', btArray)^.Ext := Pointer(FindType('VARIANT'));
  {$IFNDEF NOINT64}
  AddType('INT64', btS64);
  {$ENDIF}
  with AddFunction('function Assigned(I: Longint): Boolean;','',100)^ do
  begin
    Name := '!ASSIGNED';
    NameHash := MakeHash(Name);
  end;
end;

procedure TIFPSPascalCompiler.UpdateRecordFields(r: Pointer);
var
  I: Longint;

begin
  if PIFPSType(r)^.BaseType = btProcPtr then
  begin
    ReplaceTypes(PIFPSProceduralType(PIFPSType(r)^.Ext)^.ProcDef);

  end else if PIFPSType(r)^.BaseType = btRecord then
  begin
    for I := 0 to PIFPSType(r)^.RecordSubVals.Count - 1 do
    begin
      PIFPSRecordType(PIFPSType(r)^.RecordSubVals.GetItem(I))^.FType := at2ut(PIFPSRecordType(PIFPSType(r)^.RecordSubVals.GetItem(I))^.FType);
    end;
  end
  else if PIFPSType(r)^.BaseType = btArray then
  begin
    if PIFPSType(r)^.Ext <> Pointer(Cardinal(-1)) then
      PIFPSType(r)^.Ext := Pointer(at2ut(Cardinal(PIFPSType(r)^.Ext)));
  end;
end;


function TIFPSPascalCompiler.FindType(const Name: string): Cardinal;
var
  i, n: Longint;
  p: PIFPSType;
  RName: string;
begin
  if FProcs = nil then begin Result := Cardinal(-1); exit;end;
  RName := Fastuppercase(Name);
  n := makehash(rname);
  for i := 0 to FAvailableTypes.Count - 1 do
  begin
    p := FAvailableTypes.GetItem(I);
    if (p^.NameHash = n) and (p^.name = rname) then
    begin
      result := I;
      exit;
    end;
  end;
  result := Cardinal(-1);
end;

function TIFPSPascalCompiler.AddConstant(const Name: string; FType: Cardinal): PIFPSConstant;
var
  pc: PIFPSConstant;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  if FType = Cardinal(-1) then begin Result := nil; exit; end; 
  new(pc);
  pc^.Name := FastUppercase(name);
  pc^.NameHash := makehash(pc^.name);
  pc^.Value.FType := FType;
  FConstants.Add(pc);
  result := pc;
end;

type
  PConstantVal = ^TConstantVal;
  TConstantVal = record
    b: Boolean;
    case boolean  of
    true: (Rec: PIfRVariant; DeclPos: Cardinal; Modifiers: Byte);
    false: (c: byte);
  end;

function TIFPSPascalCompiler.ReadConstant(StopOn: TIfPasToken): PIfRVariant;
var
  Items: TIfList;
  tmp: PConstantVal;
  Val: PIfRVariant;
  c,
  modifiers: byte;

    function GetType(BaseType: TIFPSBaseType): Cardinal;
    var
      l: Longint;
      x: PIFPSType;
    begin
      for l := 0 to FAvailableTypes.Count - 1 do
      begin
        if PIFPSType(FAvailableTypes.GetItem(l))^.BaseType = BaseType then
        begin
          Result := l;
          exit;
        end;
      end;
      New(x);
      x^.Name := '';
      x^.NameHash := MakeHash(x^.Name);
      x^.BaseType := BaseType;
      x^.TypeSize := 1;
      x^.DeclarePosition := Cardinal(-1);
      FAvailableTypes.Add(x);
      FUsedTypes.Add(x);
      Result := FUsedTypes.Count - 1;
    end;

  procedure Cleanup;
  var
    p: PConstantVal;
    l: Longint;
  begin
    for l := 0 to Items.Count - 1 do
    begin
      p := Items.GetItem(l);
      if not p^.b then
      begin
        DisposeVariant(p^.Rec);
      end;
      Dispose(p);
    end;
    Items.Free;
  end;

  function SortItems: Boolean;
  var
    l: Longint;
    p, p1, P2: PConstantVal;
  begin
    SortItems := False;
    if Items.Count = 1 then
    begin
      p1 := Items.GetItem(0);

      if (p1^.Rec^.FType = CVAL_Data) then
      begin

        if p1^.Modifiers = 1 then // not
        begin
          case PIFPSType(FUsedTypes.GetItem(p1^.Rec^.FType))^.BaseType of
            btU8: TbtU8((@p1^.Rec^.Value[1])^) := tbtu8(TbtU8((@p1^.Rec^.Value[1])^) = 0);
            btS8: TbtS8((@p1^.Rec^.Value[1])^) := tbts8(TbtS8((@p1^.Rec^.Value[1])^) = 0);
            btU16: TbtU16((@p1^.Rec^.Value[1])^) := tbtu16(TbtU16((@p1^.Rec^.Value[1])^) = 0);
            btS16: TbtS16((@p1^.Rec^.Value[1])^) := tbts16(TbtS16((@p1^.Rec^.Value[1])^) = 0);
            btU32: TbtU32((@p1^.Rec^.Value[1])^) := tbtu32(TbtU32((@p1^.Rec^.Value[1])^) = 0);
            btS32: TbtS32((@p1^.Rec^.Value[1])^) := tbts32(TbtS32((@p1^.Rec^.Value[1])^) = 0);
          end;
        end else
        if p1^.Modifiers = 2 then // minus
        begin
          case PIFPSType(FUsedTypes.GetItem(p1^.Rec^.FType))^.BaseType of
            btU8: TbtU8((@p1^.Rec^.Value[1])^) := - TbtU8((@p1^.Rec^.Value[1])^);
            btS8: TbtS8((@p1^.Rec^.Value[1])^) := - TbtS8((@p1^.Rec^.Value[1])^);
            btU16: TbtU16((@p1^.Rec^.Value[1])^) := - TbtU16((@p1^.Rec^.Value[1])^);
            btS16: TbtS16((@p1^.Rec^.Value[1])^) := - TbtS16((@p1^.Rec^.Value[1])^);
            btU32: TbtU32((@p1^.Rec^.Value[1])^) := - TbtU32((@p1^.Rec^.Value[1])^);
            btS32: TbtS32((@p1^.Rec^.Value[1])^) := - TbtS32((@p1^.Rec^.Value[1])^);
            btSingle: TbtSingle((@p1^.Rec^.Value[1])^) := - TbtSingle((@p1^.Rec^.Value[1])^);
            btDouble: TbtDouble((@p1^.Rec^.Value[1])^) := - TbtDouble((@p1^.Rec^.Value[1])^);
            btExtended: TbtExtended((@p1^.Rec^.Value[1])^) := - tbtExtended((@p1^.Rec^.Value[1])^);
          end;
        end;
      end;

      SortItems := True;
      exit;
    end;
    l := 0;
    while l < Longint(Items.Count - 1) div 2 do
    begin
      p := Items.GetItem((l shl 1) + 1);
      p1 := Items.GetItem((l shl 1));
      P2 := Items.GetItem((l shl 1) + 2);
      case p^.c of
        2, 3, 4, 5, 6, 7: {*}
          begin
            if not PreCalc(FAvailableTypes, p1^.Modifiers, p1^.Rec, p2^.Modifiers, P2^.Rec, p^.c, p2^.DeclPos) then
            begin
              exit;
            end;
            Items.Delete((l shl 1) + 1);
            Items.Delete((l shl 1) + 1);
            DisposeVariant(p2^.Rec);
            Dispose(P2);
            Dispose(p);
          end;
      else
        Inc(l);
      end;
    end;
    l := 0;
    while l < Longint(Items.Count - 1) div 2 do
    begin
      p := Items.GetItem((l shl 1) + 1);
      p1 := Items.GetItem((l shl 1));
      P2 := Items.GetItem((l shl 1) + 2);
      case p^.c of
        0, 1, 8, 9:
          begin
            if not PreCalc(FAvailableTypes,p1^.Modifiers, p1^.Rec, p2^.Modifiers, P2^.Rec, p^.c, p2^.DeclPos) then
            begin
              exit;
            end;
            Items.Delete((l shl 1) + 1);
            Items.Delete((l shl 1) + 1);
            DisposeVariant(p2^.Rec);
            Dispose(P2);
            Dispose(p);
          end;
      else
        Inc(l);
      end;
    end;
    l := 0;
    while l < Longint(Items.Count - 1) div 2 do
    begin
      p := Items.GetItem((l shl 1) + 1);
      p1 := Items.GetItem((l shl 1));
      P2 := Items.GetItem((l shl 1) + 2);
      case p^.c of
        10, 11, 12, 13, 14, 15:
          begin
            if not PreCalc(FAvailableTypes,p1^.Modifiers, p1^.Rec, p2^.Modifiers, P2^.Rec, p^.c, p2^.DeclPos) then
            begin
              exit;
            end;
            Items.Delete((l shl 1) + 1);
            Items.Delete((l shl 1) + 1);
            DisposeVariant(p2^.Rec);
            Dispose(P2);
            Dispose(p);
          end;
      else
        Inc(l);
      end;
    end;
    SortItems := True;
  end;
  function ReadReal(const s: string): PIfRVariant;
  var
    C: Integer;
  begin
    New(Result);
    Result^.FType := GetType(btExtended);
    SetLength(Result^.Value, SizeOf(TbtExtended));
    System.Val(s, TbtExtended((@Result^.Value[1])^), C);
  end;
  function ReadInteger(const s: string): PIfRVariant;
  var
    C: Integer;
  begin
    New(Result);
    Result^.FType := GetType(btS32);
    SetLength(Result^.Value, SizeOf(TbtS32));
    System.Val(s, TbtS32((@Result^.Value[1])^), C);
    if TbtS32((@Result^.Value[1])^) < 0 then
    begin
      System.Val(s, TbtU32((@Result^.Value[1])^), C);
    end;
  end;
  function ReadString: PIfRVariant;

    function ParseString: string;
    var
      temp3: string;

      function ChrToStr(s: string): Char;
      begin
        Delete(s, 1, 1); {First char : #}
        ChrToStr := Chr(StrToInt(s));
      end;

      function PString(s: string): string;
      begin
        s := copy(s, 2, Length(s) - 2);
        PString := s;
      end;
    begin
      temp3 := '';
      while (FParser.CurrTokenId = CSTI_String) or (FParser.CurrTokenId =
        CSTI_Char) do
      begin
        if FParser.CurrTokenId = CSTI_String then
        begin
          temp3 := temp3 + PString(FParser.GetToken);
          FParser.Next;
          if FParser.CurrTokenId = CSTI_String then
            temp3 := temp3 + #39;
        end {if}
        else
        begin
          temp3 := temp3 + ChrToStr(FParser.GetToken);
          FParser.Next;
        end; {else if}
      end; {while}
      ParseString := temp3;
    end;
  begin
    New(Result);
    Result^.FType := GetType(btString);
    Result^.Value := ParseString;
  end;
  function GetConstantIdentifier: PIfRVariant;
  var
    s: string;
    sh: Longint;
    i: Longint;
    p: PIFPSConstant;
  begin
    s := FParser.GetToken;
    sh := MakeHash(s);
    for i := FConstants.Count -1 downto 0 do
    begin
      p := FConstants.GetItem(I);
      if (p^.NameHash = sh) and (p^.Name = s) then
      begin
        New(Result);
        Result^.FType := p^.Value.FType;
        Result^.Value := p^.Value.Value;
        FParser.Next;
        exit;
      end;
    end;
    MakeError('', ecUnknownIdentifier, '');
    Result := nil;

  end;
begin
  Items := TIfList.Create;
  ReadConstant := nil;
  while True do
  begin
    modifiers := 0;
    if Items.Count and 1 = 0 then
    begin
      if fParser.CurrTokenID = CSTII_Not then
      begin
        FParser.Next;
        modifiers := 1;
      end else // only allow one of these two
      if fParser.CurrTokenID = CSTI_Minus then
      begin
        FParser.Next;
        modifiers := 2;
      end;
      case FParser.CurrTokenId of
        CSTI_EOF:
          begin
            MakeError('', ecUnexpectedEndOfFile, '');
            Cleanup;
            exit;
          end;
        CSTI_OpenRound:
          begin
            FParser.Next;

            val := ReadConstant(CSTI_CloseRound);
            if val = nil then
            begin
              Cleanup;
              exit;
            end;
            if FParser.CurrTokenId <> CSTI_CloseRound then
            begin
              MakeError('', ecCloseRoundExpected, '');
              Cleanup;
              exit;
            end;
            if ((Modifiers and 1) <> 0) and (not IsIntType(PIFPSType(FUsedTypes.GetItem(val^.FType))^.BaseType)) or ((Modifiers and 2) <> 0) and (not IsRealType(PIFPSType(FUsedTypes.GetItem(val^.FType))^.BaseType)) then
            begin
              DisposeVariant(val);
              MakeError('', ecTypeMismatch, '');
              Cleanup;
              exit;
            end;
            new(tmp);
            tmp^.b := False;
            tmp^.Rec := Val;
            tmp^.DeclPos := FParser.CurrTokenPos;
            tmp^.Modifiers := modifiers;
            Items.Add(tmp);
            FParser.Next;
          end;
        CSTI_Char, CSTI_String:
          begin
            if (Modifiers <> 0) then
            begin
              MakeError('', ecTypeMismatch, '');
              Cleanup;
              exit;
            end;
            val := ReadString;
            new(tmp);
            tmp^.b := False;
            tmp^.Rec := Val;
            tmp^.DeclPos := FParser.CurrTokenPos;
            tmp^.Modifiers := modifiers;
            Items.Add(tmp);
          end;
        CSTI_HexInt, CSTI_Integer:
          begin
            Val := ReadInteger(FParser.GetToken);
            new(tmp);
            tmp^.b := False;
            tmp^.Rec := Val;
            tmp^.DeclPos := FParser.CurrTokenPos;
            tmp^.Modifiers := modifiers;
            Items.Add(tmp);
            FParser.Next;
          end;
        CSTI_Real:
          begin
            if ((Modifiers and 1) <> 0)  then
            begin
              MakeError('', ecTypeMismatch, '');
              Cleanup;
              exit;
            end;
            Val := ReadReal(FParser.GetToken);
            new(tmp);
            tmp^.b := False;
            tmp^.Rec := Val;
            tmp^.DeclPos := FParser.CurrTokenPos;
            tmp^.Modifiers := modifiers;
            Items.Add(tmp);
            FParser.Next;
          end;
        CSTI_Identifier:
          begin
            val := GetConstantIdentifier;
            if val = nil then
            begin
              Cleanup;
              exit;
            end
            else
            begin
              if ((Modifiers and 1) <> 0) and (not IsIntType(PIFPSType(FUsedTypes.GetItem(val^.FType))^.BaseType)) or ((Modifiers  and 2) <> 0) and (not IsIntRealType(PIFPSType(FUsedTypes.GetItem(val^.FType))^.BaseType))
              then
              begin
                DisposeVariant(val);
                MakeError('', ecTypeMismatch, '');
                Cleanup;
                exit;
              end;
              new(tmp);
              tmp^.b := False;
              tmp^.Rec := Val;
              tmp^.DeclPos := FParser.CurrTokenPos;
              tmp^.Modifiers := modifiers;
              Items.Add(tmp);
            end;
          end;
      else
        begin
          MakeError('', ecSyntaxError, '');
          Cleanup;
          exit;
        end;
      end; {case}
    end
    else {Items.Count and 1 = 1}
    begin
      if FParser.CurrTokenId = StopOn then
        break;
      C := 0;
      case FParser.CurrTokenId of
        CSTI_EOF:
          begin
            MakeError('', ecUnexpectedEndOfFile, '');
            Cleanup;
            exit;
          end;
        CSTI_CloseBlock,
          CSTII_To,
          CSTI_CloseRound,
          CSTI_Semicolon,
          CSTII_Else,
          CSTII_End,
          CSTI_Comma: break;
        CSTI_Plus: ;
        CSTI_Minus: C := 1;
        CSTI_Multiply: C := 2;
        CSTI_Divide: C := 3;
        CSTII_mod: C := 4;
        CSTII_shl: C := 5;
        CSTII_shr: C := 6;
        CSTII_and: C := 7;
        CSTII_or: C := 8;
        CSTII_xor: C := 9;
        CSTI_GreaterEqual: C := 10;
        CSTI_LessEqual: C := 11;
        CSTI_Greater: C := 12;
        CSTI_Less: C := 13;
        CSTI_NotEqual: C := 14;
        CSTI_Equal: C := 15;
      else
        begin
          MakeError('', ecSyntaxError, '');
          Cleanup;
          exit;
        end;
      end; {case}
      new(tmp);
      tmp^.b := True;
      tmp^.c := C;
      Items.Add(tmp);
      FParser.Next;
    end;
  end;
  if not SortItems then
  begin
    Cleanup;
    exit;
  end;
  if Items.Count = 1 then
  begin
    tmp := Items.GetItem(0);
    Result := tmp^.Rec;
    Dispose(tmp);
    Items.Free;
  end
  else
  begin
    MakeError('', ecInternalError, '0001B');
    Cleanup;
    Exit;
  end;
end;

procedure TIFPSPascalCompiler.WriteDebugData(const s: string);
begin
  FDebugOutput := FDebugOutput + s;
end;

function TIFPSPascalCompiler.GetDebugOutput(var s: string): Boolean;
begin
  if Length(FDebugOutput) <> 0 then
  begin
    s := FDebugOutput;
    Result := True;
  end
  else
    Result := False;
end;

function TIFPSPascalCompiler.AddUsedFunction(var Proc: PIFPSProcedure): Cardinal;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  New(Proc);
  FProcs.Add(Proc);
  Result := FProcs.Count - 1;
end;

function TIFPSPascalCompiler.GetAvailableType(No: Cardinal): PIFPSType;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  Result := FAvailableTypes.GetItem(No);
end;

function TIFPSPascalCompiler.GetAvailableTypeCount: Cardinal;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  Result := FAvailableTypes.Count;
end;

function TIFPSPascalCompiler.GetProc(No: Cardinal): PIFPSProcedure;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  Result := FProcs.GetItem(No);
end;

function TIFPSPascalCompiler.GetProcCount: Cardinal;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  Result := FProcs.Count;
end;

function TIFPSPascalCompiler.GetUsedType(No: Cardinal): PIFPSType;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  Result := FUsedTypes.GetItem(No);
end;

function TIFPSPascalCompiler.GetUsedTypeCount: Cardinal;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  Result := FUsedTypes.Count;
end;

function TIFPSPascalCompiler.UseAvailableType(No: Cardinal): Cardinal;
var
  I: Longint;
  p: PIFPSType;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  p := FAvailableTypes.GetItem(No);
  if p = nil then
  begin
    Result := Cardinal(-1);
    Exit;
  end;

  for I := 0 to FUsedTypes.Count - 1 do
  begin
    if FUsedTypes.GetItem(I) = p then
    begin
      Result := I;
      exit;
    end;
  end;
  UpdateRecordFields(p);
  FUsedTypes.Add(p);
  Result := FUsedTypes.Count - 1;
end;

function TIFPSPascalCompiler.AddUsedFunction2(var Proc: PIFPSUsedRegProc): Cardinal;
begin
  if FProcs = nil then begin Result := Cardinal(-1);exit;end;
  New(Proc);
  Proc^.Internal := False;
  FProcs.Add(Proc);
  Result := FProcs.Count -1;
end;

function TIFPSPascalCompiler.AddVariable(const Name: string; FType: Cardinal): PIFPSVar;
var
  P: PIFPSVar;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  if FType = Cardinal(-1) then begin Result := nil; exit; end;
  New(p);
  p^.Name := Fastuppercase(Name);
  p^.Namehash := MakeHash(p^.Name);
  p^.FType := AT2UT(FType);
  p^.Used := False;
  p^.DeclarePosition := 0;
  FVars.Add(p);
  Result := P;
end;

function TIFPSPascalCompiler.GetVariable(No: Cardinal): PIFPSVar;
begin
  if FProcs = nil then begin Result := nil; exit;end;
  Result := FVars.GetItem(No);
end;

function TIFPSPascalCompiler.GetVariableCount: Cardinal;
begin
  if FProcs = nil then begin Result := 0; exit;end;
  Result := FVars.Count;
end;


procedure TIFPSPascalCompiler.AddToFreeList(Obj: TObject);
begin
  FAutoFreeList.Add(Obj);
end;

function TIFPSPascalCompiler.AddConstantN(const Name,
  FType: string): PIFPSConstant;
var
  L: Cardinal;
begin
  L := FindType(FType);
  if l = Cardinal(-1) then
    Result := nil
  else
    Result := AddConstant(Name, L);
end;

function TIFPSPascalCompiler.AddTypeCopy(const Name: string;
  TypeNo: Cardinal): PIFPSType;
begin
  Result := AddType(Name, BtTypeCopy);
  Result.Ext := Pointer(TypeNo);
end;

function TIFPSPascalCompiler.AddTypeCopyN(const Name,
  FType: string): PIFPSType;
var
  L: Cardinal;
begin
  L := FindType(FType);
  if L = Cardinal(-1) then
    Result := nil
  else
    Result := AddTypeCopy(Name, L);
end;


function TIFPSPascalCompiler.AddUsedVariable(const Name: string;
  FType: Cardinal): PIFPSVar;
begin
  Result := AddVariable(Name, FType);
  if Result <> nil then
    Result^.Used := True;
end;

function TIFPSPascalCompiler.AddUsedVariableN(const Name,
  FType: string): PIFPSVar;
begin
  Result := AddVariable(Name, FindType(FType));
  if Result <> nil then
    Result^.Used := True;
end;

function TIFPSPascalCompiler.AddVariableN(const Name,
  FType: string): PIFPSVar;
begin
  Result := AddVariable(Name, FindType(FType));
end;

function TIFPSPascalCompiler.AddTypeS(const Name, Decl: string): PIFPSType;
var
  Parser: TIfPascalParser;
begin
  Parser := TIfPascalParser.Create;
  Parser.SetText(Decl);
  Result := FAvailableTypes.GetItem(ReadType(FastUppercase(Name), Parser));
  Parser.Free;
end;


function TIFPSPascalCompiler.CheckCompatProc(FTypeNo,
  ProcNo: Cardinal): Boolean;
var
  s1,s2: string;
  P: PIFPSType;

  function c(const e1,e2: string): Boolean;
  begin
    Result := (Length(e1) = 0) or (Length(e2) = 0) or (e1[1] <> e2[1]);  
  end;
begin
  P := FUsedTypes.GetItem(FTypeNo);
  if p^.BaseType <> btProcPtr then begin
    Result := False;
    Exit;
  end;

  S1 := PIFPSProceduralType(p^.Ext)^.ProcDef;

  if PIFPSProcedure(FProcs.GetItem(ProcNo))^.Internal then
    s2 := PIFPSProcedure(FProcs.GetItem(ProcNo))^.Decl
  else
    s2 := PIFPSUsedRegProc(FProcs.GetItem(ProcNo))^.RP^.Decl;
  if GRFW(s1) <> GRFW(s2) then begin
    Result := False;
    Exit;
  end;
  while Length(s1) > 0 do
  begin
    if c(GRFW(s1), GRFW(s2)) or (GRFW(s1) <> GRFW(s2)) then begin
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

function TIFPSPascalCompiler.MakeExportDecl(decl: string): string;
var
  c: char;
begin
  result := grfw(decl);
  while length(decl) > 0 do
  begin
    c := grfw(decl)[1];
    result := result +' '+c+grfw(decl);
  end;
end;


function TIFPSPascalCompiler.IsIntBoolType(FTypeNo: Cardinal): Boolean;
var
  f: PIFPSType;
begin
  if FTypeNo = at2ut(FBooleanType) then begin Result := True; exit;end;
  f := FUsedTypes.GetItem(FTypeNo);
  
  case f^.BaseType of
    btU8, btS8, btU16, btS16, btU32, btS32{$IFNDEF NOINT64}, btS64{$ENDIF}: Result := True;
  else
    Result := False;
  end;
end;

function TIFPSPascalCompiler.AddExportVariableN(const Name,
  FType: string): PIFPSVar;
begin
  Result := AddVariableN(Name, FType);
  if Result <> nil then
    Result^.exportname := FastUppercase(Name);
end;

function TIFPSPascalCompiler.AddUsedExportVariableN(const Name,
  FType: string): PIFPSVar;
begin
  Result := AddUsedVariableN(Name, FType);
  if Result <> nil then
    Result^.exportname := FastUppercase(Name);
end;

procedure TIFPSPascalCompiler.ParserError(Parser: TObject;
  Kind: TIFParserErrorKind; Position: Cardinal);
begin
  case Kind of
    ICOMMENTERROR: MakeError('', ecCommentError, '')^.Position := Position;
    ISTRINGERROR: MakeError('', ecStringError, '')^.Position := Position;
    ICHARERROR: MakeError('', ecCharError, '')^.Position := Position;
  else
    MakeError('', ecSyntaxError, '')^.Position := Position;
  end;
end;

{ TIFPSExternalClass }
function TIFPSExternalClass.SetNil(TypeNo: Cardinal; var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.ClassFunc_Call(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.ClassFunc_Find(const Name: string;
  var Index: Cardinal): Boolean;
begin
  Result := False;
end;

constructor TIFPSExternalClass.Create(Se: TIFPSPascalCompiler);
begin
  inherited Create;
  Self.SE := se;
end;

function TIFPSExternalClass.Func_Call(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.Func_Find(const Name: string;
  var Index: Cardinal): Boolean;
begin
  Result := False;
end;


function TIFPSExternalClass.IsCompatibleWith(
  Cl: TIFPSExternalClass): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.Property_Find(const Name: string;
  var Index: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.Property_Get(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;


function TIFPSExternalClass.Property_GetHeader(Index: Cardinal;
  var s: string): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.Property_Set(Index: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.SelfType: Cardinal;
begin
  Result := Cardinal(-1);
end;

function TIFPSExternalClass.CastToType(TypeNo, IntoType: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := False;
end;

function TIFPSExternalClass.CompareClass(OtherTypeNo: Cardinal;
  var ProcNo: Cardinal): Boolean;
begin
  Result := false;
end;

{  }

function TransDoubleToStr(D: Double): string;
begin
  SetLength(Result, SizeOf(Double));
  Double((@Result[1])^) := D;
end;

function TransSingleToStr(D: Single): string;
begin
  SetLength(Result, SizeOf(Single));
  Single((@Result[1])^) := D;
end;

function TransExtendedToStr(D: Extended): string;
begin
  SetLength(Result, SizeOf(Extended));
  Extended((@Result[1])^) := D;
end;

function TransLongintToStr(D: Longint): string;
begin
  SetLength(Result, SizeOf(Longint));
  Longint((@Result[1])^) := D;
end;

function TransCardinalToStr(D: Cardinal): string;
begin
  SetLength(Result, SizeOf(Cardinal));
  Cardinal((@Result[1])^) := D;
end;

function TransWordToStr(D: Word): string;
begin
  SetLength(Result, SizeOf(Word));
  Word((@Result[1])^) := D;
end;

function TransSmallIntToStr(D: SmallInt): string;
begin
  SetLength(Result, SizeOf(SmallInt));
  SmallInt((@Result[1])^) := D;
end;

function TransByteToStr(D: Byte): string;
begin
  SetLength(Result, SizeOf(Byte));
  Byte((@Result[1])^) := D;
end;

function TransShortIntToStr(D: ShortInt): string;
begin
  SetLength(Result, SizeOf(ShortInt));
  ShortInt((@Result[1])^) := D;
end;





































function TIFPSPascalCompiler.MainDef: Boolean;
var
  Position: Byte;
  i: Longint;

  procedure FreeAll;
  var
    I, I2: Longint;
    PPV: PIFPSProcVar;
    PT: PIFPSType;
    pp: PIFPSProcedure;
    pc: PIFPSConstant;
    ppe: PIFPSUsedRegProc;
    pv: PIFPSVar;
    pr: PIFPSRegProc;
    pn: PIFPSProceduralType;

    procedure FreeRecord(v: TIfList);
    var
      I: Longint;
      p: PIFPSRecordType;
    begin
      for I := 0 to v.Count - 1 do
      begin
        p := v.GetItem(I);
        p^.FieldName := '';
        Dispose(p);
      end;
      v.Free;
    end;
  begin
    for I := 0 to FRegProcs.Count - 1 do
    begin
      pr := FRegProcs.GetItem(I);
      Dispose(pr);
    end;
    FRegProcs.Free;
    for i := 0 to FConstants.Count -1 do
    begin
      pc := FConstants.GetItem(I);
      Dispose(pc);
    end;
    Fconstants.Free;
    for I := 0 to FVars.Count - 1 do
    begin
      pv := FVars.GetItem(I);
      Dispose(pv);
    end;
    FVars.Free;
    for I := 0 to FProcs.Count - 1 do
    begin
      ppe := FProcs.GetItem(I);
      if ppe^.Internal then
      begin
        pp := Pointer(ppe);
        for I2 := 0 to pp^.ProcVars.Count - 1 do
        begin
          PPV := pp^.ProcVars.GetItem(I2);
          Dispose(PPV);
        end;
        pp^.ProcVars.Free;
        pp^.FGotos.Free;
        pp^.FLabels.Free;
        Dispose(pp);
      end
      else
      begin
        Dispose(ppe);
      end;

    end;
    FProcs.Free;
    FProcs := nil;
    for I := 0 to FAvailableTypes.Count - 1 do
    begin
      PT := FAvailableTypes.GetItem(I);
      if pt^.BaseType = btProcPtr then
      begin
        pn := pt^.Ext;
        Dispose(pn);
      end else if PT^.BaseType = btRecord then
        FreeRecord(PT^.RecordSubVals)
      else if (pt^.BaseType = btClass) and (pt^.Ext <> nil) then
      begin
        TIFPSExternalClass(pt^.Ext).Free;
      end;
      Dispose(PT);
    end;
    FAvailableTypes.Free;
    FUsedTypes.Free;
  end;



  procedure MakeOutput;

    procedure WriteByte(b: Byte);
    begin
      FOutput := FOutput + Char(b);
    end;

    procedure WriteData(const Data; Len: Longint);
    begin
      SetLength(FOutput, Length(FOutput) + Len);
      Move(Data, FOutput[Length(FOutput) - Len + 1], Len);
    end;

    procedure WriteLong(l: Cardinal);
    begin
      WriteData(l, 4);
    end;


    procedure WriteTypes;
    var
      l, n: Longint;
      Tmp: Cardinal;
      x: PIFPSType;
      xxp: PIFPSProceduralType;
      FExportName: string;
    begin
      for l := 0 to FUsedTypes.Count - 1 do
      begin
        x := FUsedTypes.GetItem(l);
        if x^.BaseType = btChar then x^.BaseType := btu8;
        if x^.FExport then
          FExportName := x^.Name
        else
          FExportName := '';
        if x^.BaseType = btClass then
        begin
          x := GetTypeCopyLink(FAvailableTypes.GetItem(TIFPSExternalClass(x^.Ext).SelfType));
        end;
        if (x^.BaseType = btString)and (x^.Ext = Pointer(1))then x^.BaseType := btPChar;
        if (x^.BaseType = btEnum) then begin
          if Longint(x^.Ext) <= 256 then
            x^.BaseType := btU8
          else if Longint(x^.Ext) <= 65536 then
            x^.BaseType := btU16
          else
            x^.BaseType := btU32;
        end;
        if x^.BaseType = btProcPtr then begin
          xxp := x^.Ext;
          Dispose(xxp);
          x^.Ext := nil;
          x^.BaseType := btu32;
        end;
        if FExportName <> '' then
        begin
          WriteByte(x^.BaseType + 128);
        end
        else
          WriteByte(X^.BaseType);
        if x^.BaseType = btArray then
        begin
          WriteLong(Longint(x^.Ext));
        end
        else if x^.BaseType = btRecord then
        begin
          n := x^.RecordSubVals.Count;
          WriteData(n, 4);
          for n := 0 to x^.RecordSubVals.Count - 1 do
          begin
            Tmp := PIFPSRecordType(x^.RecordSubVals.GetItem(n))^.FType;
            WriteData(Tmp, 4);
          end;
        end;
        if FExportName <> '' then
        begin
          WriteLong(Length(FExportName));
          WriteData(FExportName[1], length(FExportName));
        end;
      end;
    end;

    procedure WriteVars;
    var
      l: Longint;
      x: PIFPSVar;
    begin
      for l := 0 to FVars.Count - 1 do
      begin
        x := FVars.GetItem(l);
        WriteLong(x^.FType);
        if x^.exportname <> '' then
        begin
          WriteByte(1);
          WriteLong(Length(X^.ExportName));
          WriteData(X^.ExportName[1], length(X^.ExportName));
        end else
          WriteByte(0);
      end;
    end;

    procedure WriteProcs;
    var
      l: Longint;
      x: PIFPSProcedure;
      xp: PIFPSUsedRegProc;
      s: string;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        x := FProcs.GetItem(l);
        if x^.Internal then
        begin
          x^.OutputDeclPosition := Length(FOutput);
          if x^.FExport <> 0 then
            WriteByte(2) // exported
          else
            WriteByte(0); // not imported
          WriteLong(0); // offset is unknown at this time
          WriteLong(0); // length is also unknown at this time
          if x^.FExport <> 0 then
          begin
            WriteLong(Length(x^.Name));
            WriteData(x^.Name[1], length(x^.Name));
            if x^.FExport = 1 then
            begin
              WriteLong(0);
            end else begin
              s := MakeExportDecl(x^.Decl);
              WriteLong(Length(s));
              WriteData(s[1], length(S));
            end;
          end;
        end
        else
        begin
          xp := Pointer(x);
          if xp^.RP^.ImportDecl <> '' then
          begin
            WriteByte(3); // imported
            if xp^.Rp^.FExportName then
            begin
              WriteByte(Length(xp^.RP^.Name));
              WriteData(xp^.RP^.Name[1], Length(xp^.RP^.Name) and $FF);
            end else begin
              WriteByte(0);
            end;
            WriteLong(Length(xp^.RP^.ImportDecl));
            WriteData(xp^.RP^.ImportDecl[1], Length(xp^.RP^.ImportDecl));
          end else begin
            WriteByte(1); // imported
            WriteByte(Length(xp^.RP^.Name));
            WriteData(xp^.RP^.Name[1], Length(xp^.RP^.Name) and $FF);
          end;
        end;
      end;
    end;

    procedure WriteProcs2;
    var
      l: Longint;
      L2: Cardinal;
      x: PIFPSProcedure;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        x := FProcs.GetItem(l);
        if x^.Internal then
        begin
          L2 := Length(FOutput);
          Move(L2, FOutput[x^.OutputDeclPosition + 2], 4);
          // write position
          WriteData(x^.Data[1], Length(x^.Data));
          L2 := Cardinal(Length(FOutput)) - L2;
          Move(L2, FOutput[x^.OutputDeclPosition + 6], 4); // write length
        end;
      end;
    end;

    function FindMainProc: Cardinal;
    var
      l: Longint;
    begin
      for l := 0 to FProcs.Count - 1 do
      begin
        if (PIFPSProcedure(FProcs.GetItem(l))^.Internal) and
          (PIFPSProcedure(FProcs.GetItem(l))^.Name = IFPSMainProcName) then
        begin
          Result := l;
          exit;
        end;
      end;
      Result := Cardinal(-1);
    end;
    procedure CreateDebugData;
    var
      I: Longint;
      p: PIFPSProcedure;
      pv: PIFPSVar;
      s: string;
    begin
      s := #0;
      for I := 0 to FProcs.Count - 1 do
      begin
        p := FProcs.GetItem(I);
        if p^.Internal then
        begin
          if p^.Name = IFPSMainProcName then
            s := s + #1
          else
            s := s + p^.Name + #1;
        end
        else
        begin
          s := s+ PIFPSUsedRegProc(p)^.RP^.Name + #1;
        end;
      end;
      s := s + #0#1;
      for I := 0 to FVars.Count - 1 do
      begin
        pv := FVars.GetItem(I);
        s := s + pv.Name + #1;
      end;
      s := s + #0;
      WriteDebugData(s);
    end;
  begin
    CreateDebugData;
    WriteLong(IFPSValidHeader);
    WriteLong(IFPSCurrentBuildNo);
    WriteLong(FUsedTypes.Count);
    WriteLong(FProcs.Count);
    WriteLong(FVars.Count);
    WriteLong(FindMainProc);
    WriteLong(0);
    WriteTypes;
    WriteProcs;
    WriteVars;
    WriteProcs2;
  end;

  function CheckExports: Boolean;
  var
    i: Longint;
    p: PIFPSProcedure;
  begin
    if @FOnExportCheck = nil then
    begin
      result := true;
      exit;
    end;
    for i := 0 to FProcs.Count -1 do
    begin
      p := FProcs.GetItem(i);
      if p^.Internal then
      begin
        if not FOnExportCheck(Self, p, MakeDecl(p^.Decl)) then
        begin
          Result := false;
          exit;
        end;
      end;
    end;
    Result := True;
  end;
  function DoConstBlock: Boolean;
  var
    CName: string;
    CValue: PIFRVariant;
    Cp: PIFPSConstant;
  begin
    FParser.Next;
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        Result := False;
        Exit;
      end;
      CName := FParser.GetToken;
      if IsDuplicate(CName) then
      begin
        MakeError('', ecDuplicateIdentifier, '');
        Result := False;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Equal then
      begin
        MakeError('', ecIsExpected, '');
        Result := False;
        Exit;
      end;
      FParser.Next;
      CValue := ReadConstant(CSTI_SemiColon);
      if CValue = nil then
      begin
        Result := False;
        Exit;
      end;
      if FParser.CurrTokenID <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        exit;
      end;
      New(cp);
      cp^.NameHash := MakeHash(CName);
      cp^.Name := CName;
      cp^.Value.FType := CValue^.FType;
      cp^.Value.Value := CValue^.Value;
      FConstants.Add(cp);
      DisposeVariant(CValue);
      FParser.Next;
    until FParser.CurrTokenId <> CSTI_Identifier;
    Result := True;
  end;
  function ProcessUses: Boolean;
  var
    FUses: TIfStringList;
    I: Longint;
    s: string;
  begin
    FParser.Next;
    FUses := TIfStringList.Create;
    repeat
      if FParser.CurrTokenID <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FUses.Free;
        Result := False;
        exit;
      end;
      s := FParser.GetToken;
      for i := 0 to FUses.Count -1 do
      begin
        if FUses.GetItem(I) = s then
        begin
          MakeError('', ecDuplicateIdentifier, s);
          FUses.Free;
          Result := False;
          exit;
        end;
      end;
      FUses.Add(s);
      if @FOnUses <> nil then
      begin
        try
          if not OnUses(Self, FParser.GetToken) then
          begin
            FUses.Free;
            Result := False;
            exit;
          end;
        except
          on e: Exception do
          begin
            MakeError('', ecCustomError, e.Message);
            FUses.Free;
            Result := False;
            exit;
          end;
        end;
      end;
      FParser.Next;
      if FParser.CurrTokenID = CSTI_Semicolon then break
      else if FParser.CurrTokenId <> CSTI_Comma then
      begin
        MakeError('', ecSemicolonExpected, '');
        Result := False;
        FUses.Free;
        exit;
      end;
      FParser.Next;
    until False;
    FParser.next;
    Result := True;
  end;
var
  Proc: PIFPSProcedure;

begin
  FIsUnit := False;
  Result := False;
  Clear;


  FProcs := TIfList.Create;
  FConstants := TIFList.Create;
  FVars := TIfList.Create;
  FAvailableTypes := TIfList.Create;
  FUsedTypes := TIfList.Create;
  FRegProcs := TIfList.Create;
  DefineStandardTypes;
  if @FOnUses <> nil then
  begin
    try
      if not OnUses(Self, 'SYSTEM') then
      begin
        FreeAll;
        exit;
      end;
    except
      on e: Exception do
      begin
        MakeError('', ecCustomError, e.Message);
        FreeAll;
        exit;
      end;
    end;
  end;
  Position := 0;
 { Proc := NewProc(IFPSMainProcName);
  repeat
    if FParser.CurrTokenId = CSTI_EOF then
    begin
      if FAllowNoEnd then
        Break
      else
      begin
        MakeError('', ecUnexpectedEndOfFile, '');
        FreeAll;
        exit;
      end;
    end;
    if (FParser.CurrTokenId = CSTII_Program) and (Position = 0) then
    begin
      Position := 1;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
    end else
    if (FParser.CurrTokenId = CSTII_Unit) and (Position = 0) and (FAllowUnit) then
    begin
      Position := 1;
      FIsUnit := True;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Identifier then
      begin
        MakeError('', ecIdentifierExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
      if FParser.CurrTokenId <> CSTI_Semicolon then
      begin
        MakeError('', ecSemicolonExpected, '');
        FreeAll;
        exit;
      end;
      FParser.Next;
    end
    else if (FParser.CurrTokenID = CSTII_Uses) and (Position < 2) then
    begin
      Position := 2;
      if not ProcessUses then
      begin
        FreeAll;
        exit;
      end;
    end else if (FParser.CurrTokenId = CSTII_Procedure) or
      (FParser.CurrTokenId = CSTII_Function) then
    begin
      Position := 2;
      if not ProcessFunction then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Label) then
    begin
      Position := 2;
      if not ProcessLabel(Proc) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Var) then
    begin
      Position := 2;
      if not DoVarBlock(nil) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Const) then
    begin
      Position := 2;
      if not DoConstBlock then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Type) then
    begin
      Position := 2;
      if not DoTypeBlock(FParser) then
      begin
        FreeAll;
        exit;
      end;
    end
    else if (FParser.CurrTokenId = CSTII_Begin) then
    begin
      if ProcessSub(tMainBegin, 0, Proc) then
      begin
        break;
      end
      else
      begin
        FreeAll;
        exit;
      end;
    end
    else if (Fparser.CurrTokenId = CSTII_End) and (FAllowNoBegin or FIsUnit) then
    begin
      FParser.Next;
      if FParser.CurrTokenID <> CSTI_Period then
      begin
        MakeError('', ecPeriodExpected, '');
        FreeAll;
        exit;
      end;
      break;
    end else 
    begin
      MakeError('', ecBeginExpected, '');
      FreeAll;
      exit;
    end;
  until False;
  if not ProcessLabelForwards(Proc) then
  begin
    FreeAll;
    exit;
  end;
  for i := 0 to FProcs.Count -1 do
  begin
    Proc := FProcs.GetItem(i);
    if Proc^.Internal and Proc^.Forwarded then
    begin
      MakeError('', ecUnsatisfiedForward, Proc^.Name)^.Position := Proc^.DeclarePosition;
      FreeAll;
      Exit;
    end;
  end;
  if not CheckExports then
  begin
    FreeAll;
    exit;
  end;
  for i := 0 to FVars.Count -1 do
  begin
    if not PIFPSVar(FVars.GetItem(I))^.Used then
    begin
      MakeHint('', ehVariableNotUsed, PIFPSVar(FVars.GetItem(I))^.Name)^.Position := PIFPSVar(FVars.GetItem(I))^.DeclarePosition;
    end;
  end;
  MakeOutput;
  FreeAll;         }
  Result := True;
end;

{

Internal error counter: 0001D (increase and then use)

}



end.


