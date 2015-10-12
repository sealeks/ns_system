unit ifpicall;
{
  Innerfuse Pascal Script Call unit
  You may not copy a part of this unit, only use it as whole, with
  Innerfuse Pascal Script Script Engine.
}
{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3utl, ifps3common{$IFDEF HAVEVARIANT}{$IFDEF D6PLUS}, variants{$ENDIF}{$ENDIF};

type
  TCallingConvention = (ccRegister, ccPascal, CCCdecl, CCStdCall);
  PResourcePtrSupportFuncs = ^TResourcePtrSupportFuncs;
  TResourcePtrToStrProc = function (PSelf: PResourcePtrSupportFuncs; Sender: TIFPSExec; P: PIFVariant): string;
  TVarResourcePtrToStrProc = function (PSelf: PResourcePtrSupportFuncs; Sender: TIFPSExec; P: PIFVariant): string;
  TResultToRsourcePtr = procedure(PSelf: PResourcePtrSupportFuncs; Sender: TIFPSExec; Data: Longint; P: PIFVariant);

  TRPSResultMethod = (rmParam, rmRegister);
  TResourcePtrSupportFuncs = record
    Ptr: Pointer;
    PtrToStr: TResourcePtrToStrProc;
    VarPtrToStr: TVarResourcePtrToStrProc;
    ResultMethod: TRPSResultMethod;
    ResToPtr: TResultToRsourcePtr;
  end;
function InnerfuseCall(SE: TIFPSExec; Self, Address: Pointer; CallingConv: TCallingConvention; Params: TIfList; res: PIfVariant; SupFunc: PResourcePtrSupportFuncs): Boolean;

implementation

{$IFDEF HAVEVARIANT}
var
  VNull: Variant;

const
  VariantType: TIFTypeRec = (ext:nil;BaseType: btVariant);
  VariantArrayType: TIFTypeRec = (ext:@VariantType;basetype: btArray);
{$ENDIF}

function RealFloatCall_Register(p: Pointer;
  _EAX, _EDX, _ECX: Cardinal;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    mov eax,_EAX
    mov edx,_EDX
    mov ecx,_ECX
    call p
    fstp tbyte ptr [e]
  end;
  Result := E;
end;

function RealFloatCall_Other(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    fstp tbyte ptr [e]
  end;
  Result := E;
end;

function RealFloatCall_CDecl(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint // stack length are in 4 bytes. (so 1 = 4 bytes)
  ): Extended; Stdcall; // make sure all things are on stack
var
  E: Extended;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    fstp tbyte ptr [e]
    @@5:
    mov ecx, stackdatalen
    jecxz @@2
    @@6:
    pop edx
    dec ecx
    or ecx, ecx
    jnz @@6
  end;
  Result := E;
end;

function RealCall_Register(p: Pointer;
  _EAX, _EDX, _ECX: Cardinal;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    mov eax,_EAX
    mov edx,_EDX
    mov ecx,_ECX
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
  end;
  Result := r;
end;

function RealCall_Other(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
  end;
  Result := r;
end;

function RealCall_CDecl(p: Pointer;
  StackData: Pointer;
  StackDataLen: Longint; // stack length are in 4 bytes. (so 1 = 4 bytes)
  ResultLength: Longint): Longint; Stdcall; // make sure all things are on stack
var
  r: Longint;
begin
  asm
    mov ecx, stackdatalen
    jecxz @@2
    mov eax, stackdata
    @@1:
    mov edx, [eax]
    push edx
    sub eax, 4
    dec ecx
    or ecx, ecx
    jnz @@1
    @@2:
    call p
    mov ecx, resultlength
    cmp ecx, 0
    je @@5
    cmp ecx, 1
    je @@3
    cmp ecx, 2
    je @@4
    mov r, eax
    jmp @@5
    @@3:
    xor ecx, ecx
    mov cl, al
    mov r, ecx
    jmp @@5
    @@4:
    xor ecx, ecx
    mov cx, ax
    mov r, ecx
    @@5:
    mov ecx, stackdatalen
    jecxz @@2
    @@6:
    pop edx
    dec ecx
    or ecx, ecx
    jnz @@6
  end;
  Result := r;
end;

type
  TCallInfoType = (ciRecord, ciVariant, ciOpenArray);
  PCallInfo = ^TCallInfo;
  TCallInfo = record
    ftype: TCallInfoType;
    orgvar: PIFVariant;
    varparam: Boolean;
    recData: string;
{$IFDEF HAVEVARIANT}
    varVar: variant;
{$ENDIF}
    arrLength: Longint;
    arrType: TIFPSBaseType;
    arrData: Pointer;
  end;

{$IFDEF HAVEVARIANT}
function BuildVariant(Exec: TIFPSExec; rec: PIFVariant; SupFunc: PResourcePtrSupportFuncs): PCallInfo;
var
  t: PCallInfo;
  i: Longint;
begin
  New(Result);
  Result^.ftype := ciVariant;
  Result^.orgvar := Rec;
  try
    case rec^.FType^.BaseType of
    btS8: Result^.varVar := Rec^.ts8;
    btU8: Result^.varVar := Rec^.tu8;
    btU16: Result^.varVar := Rec^.tu16;
    btS16: Result^.varVar := Rec^.ts16;
    btU32: Result^.varVar := LongInt(Rec^.tu32);
    btS32: Result^.varVar := Rec^.ts32;
    btSingle: Result^.varVar := Rec^.tsingle;
    btDouble: Result^.varVar := Rec^.tdouble;
    btExtended: Result^.varVar := Rec^.tExtended;
    btString, btPChar: Result^.varVar := string(Rec^.tstring);
    btVariant: begin
      if rec^.tvariant^.FType = nil then
      begin
        Result^.varVar := null;
      end else begin
        t := BuildVariant(Exec, Rec^.tVariant, SupFunc);
        if t = nil then begin
          Dispose(Result);
          result := nil;
          Exit;
        end;
        Result^.varVar := t^.varVar;
        Dispose(t);
      end;
    end;
    btArray:
      begin
        case Exec.GetTypeNo(Cardinal(Rec^.FType^.Ext))^.BaseType of
        {$IFDEF D6PLUS}
          btS16: i := varSmallint;
          bts32: i := varInteger;
          btu32: i := varLongWord;
          btu16: i := varWord;
          btu8: i := varByte;
          bts8: i := varShortInt;
        {$ELSE}
          bts8, btu8, btS16: i := varSmallint;
          btu16, btu32, btS32: i := varInteger;
        {$ENDIF}
          btSingle: i := varSingle;
          btDouble, btExtended : i := varDouble;
          btString, btPChar: i := varString;
          btVariant: i := varVariant;
        else
          begin
            Dispose(Result);
            Result := nil;
            exit;
          end;
        end;
        if Rec^.trecord <> nil then
        begin
          result^.varVar := VarArrayCreate([0, rec^.trecord^.FieldCount-1], i);
          for i := 0 to Rec^.trecord^.FieldCount -1 do
          begin
            t := BuildVariant(Exec, Rec^.trecord^.Fields[I], SupFunc);
            if t = nil then
            begin
              Dispose(Result);
              Result := nil;
              exit;
            end;
            Result^.varvar[i] := t^.varvar;
            Dispose(t);
          end;
        end;
      end;
    else
      begin
        Dispose(Result);
        Result := nil;
      end;
    end;
  except
    if Result <> nil then begin
      Dispose(Result);
      Result := nil;
    end;
  end;
end;

procedure CopyBack(Exec: TIFPSExec; p: PCallInfo);
var
  I: Longint;
  l: Cardinal;
  Pt: PIFTypeRec;

  procedure SetVariant(P: PIfVariant; v: variant);
  begin
    case i of
      varEmpty, varNull: ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, nil);
      varSmallint: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, Exec.FindType2(btS16)); p^.tvariant^.ts16 := v; end;
      varInteger: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, Exec.FindType2(btS32)); p^.tvariant^.ts32 := v; end;
      varSingle: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, Exec.FindType2(btSingle)); p^.tvariant^.tsingle := v; end;
      varDouble, varCurrency, varDate: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p, Exec.FindType2(btdouble)); p^.tvariant^.tdouble := v; end;
      varBoolean: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btU8)); p^.tvariant^.tu8 := ord(boolean(v)); end;
      varOleStr, varString: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btString)); string(p^.tvariant^.tstring) := v;end;
      {$IFDEF D6PLUS}
      varShortInt: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(bts8)); p^.tvariant^.ts8 := v;end;
      varByte: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btu8)); p^.tvariant^.tu8 := v;end;
      varWord: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btu16)); p^.tvariant^.tu16 := v;end;
      varLongWord: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btu32)); p^.tvariant^.tu32 := v;end;
      varInt64: begin ChangeVariantType({$IFNDEF NOSMARTMM}Exec.MemoryManager, {$ENDIF}p^.tvariant, exec.FindType2(btS64)); p^.tvariant^.ts64 := v;end;
      {$ENDIF}
    end;
  end;
begin
  try
  i := VarType(p^.varVar);
  if (i and VarArray) <> 0 then
  begin

    if VarArrayDimCount(p^.Varvar) > 1 then Exit;
    if (p^.orgvar.FType^.BaseType <> btArray) or (Exec.GetTypeNo(Cardinal(p^.orgvar^.FType^.Ext))^.BaseType <> btVariant) then
    begin
      l := 0;
      repeat
        pt := Exec.FindType(l, btArray, l);
        if PIFTypeRec(pt^.Ext)^.BaseType = btVariant then break;
      until pt = nil;
      if pt = nil then pt := @VariantArrayType;
      p^.orgvar^.tvariant.FType := pt;
    end;
    SetIFPSArrayLength(Exec, p^.orgvar, VarArrayHighBound(p^.varvar, 1) - VarArrayLowBound(p^.varvar, 1)+1);
    for i := VarArrayLowBound(p^.varvar, 1) to VarArrayHighBound(p^.varvar, 1) do
    begin
      SetVariant(p^.Orgvar^.tArray^.Fields[i - VarArrayLowBound(p^.varvar, 1)], p^.varvar[i]);
    end;
  end else
    SetVariant(p^.orgvar, p^.varvar);
  except
  end;
end;

{$ENDIF}

function CreateOpenArray(Exec: TIFPSExec; fVar: PIFVariant; SupFunc: PResourcePtrSupportFuncs): PCallInfo;
var
  p: Pointer;
  {$IFDEF HAVEVARIANT}
  fv: PIFVariant;
  temps: string;
  {$ENDIF}
  i, elementsize: Longint;
begin
  New(Result);
  Result^.FType := ciOpenArray;
  Result^.orgvar := FVar;
  Result^.ArrType := Exec.GetTypeNo(Cardinal(fVar^.FType^.Ext))^.BaseType;
  case Result^.ArrType of
    btU8, btS8, btU16, btS16, btu32, bts32, btSingle, btDouble, btExtended,
    btString, btPChar, btVariant: ;
    else begin Dispose(Result); Result := nil; exit; end;
  end;
  Result^.arrLength := GetIFPSArrayLength(Exec, fvar);
  case Result^.ArrType of
    btU8, btS8: elementsize := 1;
    btU16, btS16: elementsize := 2;
    btString, btPChar, btsingle, btu32, bts32: elementsize := 4;
    btDouble{$IFNDEF NOINT64}, bts64{$ENDIF}:elementsize := 8;
    btExtended: elementsize := 12;
    else elementsize := sizeof(TVarRec);
  end;
  try
  GetMem(Result^.ArrData, elementSize * Result^.ArrLength);
  FillChar(Result^.arrData^, elementSize * Result^.ArrLength, 0);
  except
    FreeMem(Result);
    Result := nil;
    exit;
  end;
  case Result^.ArrType of
    btPChar, btU8, btS8, btU16, btS16, btu32, bts32, btSingle, btDouble, btExtended:
    begin
      p := result^.arrData;
      for i := 0 to Result^.arrLength -1 do
      begin
        Move(fVar^.tArray.Fields[i].tu8, p^, elementsize);
        p := pchar(p) + elementsize;
      end;
    end;
    btString:
    begin
      p := result^.arrData;
      for i := 0 to Result^.arrLength -1 do
      begin
        string(p^) := string(fVar^.tArray.Fields[i].tstring);
        p := pchar(p) + elementsize;
      end;
    end;
    {$IFDEF HAVEVARIANT}
    btVariant:
    begin
      p := result^.arrData;
      for i := 0 to Result^.arrLength -1 do
      begin
        fv := fVar^.tArray.Fields[i];
        if fv^.tvariant^.FType = nil then
        begin
          tvarrec(p^).VType := vtVariant;
          tvarrec(p^).VVariant := @VNull;
        end else begin
          case fv^.tvariant^.ftype^.BaseType of
            btU8: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.tu8;
              end;
            btS8: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.ts8;
              end;
            btU16: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.tu16;
              end;
            btS16: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.ts16;
              end;
            btU32: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.tu32;
              end;
            btS32: begin
                tvarrec(p^).VType := vtInteger;
                tvarrec(p^).VInteger := fv^.tvariant^.ts32;
              end;
            btString: begin
              tvarrec(p^).VType := vtAnsiString;
              string(TVarRec(p^).VAnsiString) := string(fv^.tvariant^.tstring);
            end;
            btPChar: begin
              tvarrec(p^).VType := vtPchar;
              TVarRec(p^).VPChar := pointer(fv^.tvariant^.tstring);
            end;
            btResourcePointer: begin
              temps := SupFunc.PtrToStr(supfunc, exec, fv^.tvariant);
              if length(temps) =4 then
              begin
              tvarrec(p^).VType := vtObject;
              TVarRec(p^).VObject := Pointer((@temps[1])^);
              end;
            end;
          end;
        end;
        p := pchar(p) + elementsize;
      end;
    end;
    {$ENDIF}
  end;
end;

procedure DestroyOpenArray(Exec: TIFPSExec; CI: PCallInfo; SupFunc: PResourcePtrSupportFuncs);
var
  p: Pointer;
  fv: PIFVariant;
  i, elementsize: Longint;
begin
  case CI^.ArrType of
    btU8, btS8: elementsize := 1;
    btU16, btS16: elementsize := 2;
    btString, btPChar, btsingle, btu32, bts32: elementsize := 4;
    btDouble{$IFNDEF NOINT64}, bts64{$ENDIF}:elementsize := 8;
    btExtended: elementsize := 12;
    else elementsize := sizeof(TVarRec);
  end;
  case CI^.ArrType of
    btPChar, btU8, btS8, btU16, btS16, btu32, bts32, btSingle, btDouble, btExtended:
    begin
      if CI^.VarParam then
      begin
        p := ci^.arrData;
        for i := 0 to ci^.arrLength -1 do
        begin
          Move(p^, ci^.orgvar^.tArray.Fields[i].tu8, elementsize);
          p := pchar(p) + elementsize;
        end;
      end;
    end;
    btString:
    begin
      p := ci^.arrData;
      for i := 0 to ci^.arrLength -1 do
      begin
        if ci^.varparam then
          string(ci^.OrgVar^.tArray.Fields[i].tstring) := string(p^);
        Finalize(string(p^));
        p := pchar(p) + elementsize;
      end;
    end;
    btVariant:
    begin
      p := ci^.arrData;
      for i := 0 to ci^.arrLength -1 do
      begin
        fv := ci^.OrgVar^.tArray.Fields[i];
        if fv^.tvariant^.FType = nil then
        begin
          tvarrec(p^).VType := vtInteger;
        end else begin
          case fv^.tvariant^.ftype^.BaseType of
            btU8: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                  fv^.tvariant^.tu8 := tvarrec(p^).VInteger;
              end;
            btS8: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                fv^.tvariant^.ts8 := tvarrec(p^).VInteger;
              end;
            btU16: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                fv^.tvariant^.tu16 := tvarrec(p^).VInteger;
              end;
            btS16: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                fv^.tvariant^.ts16 := tvarrec(p^).VInteger;
              end;
            btU32: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                fv^.tvariant^.tu32 := tvarrec(p^).VInteger;
              end;
            btS32: begin
                tvarrec(p^).VType := vtInteger;
                if ci^.varParam then
                fv^.tvariant^.ts32 := tvarrec(p^).VInteger;
              end;
            btString: begin
              tvarrec(p^).VType := vtString;
              if ci^.VarParam then
                string(fv^.tvariant^.tstring) := string(TVarRec(p^).VAnsiString);
              finalize(string(TVarRec(p^).VAnsiString));
            end;
            btResourcePointer: begin
              if ci^.varparam then
              begin
                SupFunc.ResToPtr(SupFunc, Exec, Longint(TVarRec(p^).VObject), fv);
              end;
            end;
          end;
        end;
        p := pchar(p) + elementsize;
      end;
    end;
  end;
  try
    FreeMem(ci^.ArrData, elementSize * ci^.ArrLength);
  except
  end;
end;

procedure CreateRecord_(Rec: PIFVariant; var Data: string; SE: TIFPSExec; SupFunc: PResourcePtrSupportFuncs);
var
  I: Longint;
begin
  while Rec^.FType^.BaseType = btPointer do
  begin
    Rec := Rec^.tPointer;
    if Rec = nil then begin Data := Data + #0#0#0#0; Exit; end;
  end;
  case Rec^.FType^.BaseType of
  btS8, btU8: Data := Data + Chr(Rec^.tu8);
  btU16, btS16: begin Data := Data + #0#0; Word((@Data[Length(Data)-1])^) := Rec^.tu16; end;
  btS32, btU32: begin Data := Data + #0#0#0#0; Cardinal((@Data[Length(Data)-3])^) := Rec^.tu32; end;
  btSingle: begin Data := Data + #0#0#0#0; Single((@Data[Length(Data)-3])^) := Rec^.tsingle; end;
  btDouble: begin Data := Data + #0#0#0#0#0#0#0#0; Double((@Data[Length(Data)-7])^) := Rec^.tdouble; end;
  btExtended: begin Data := Data + #0#0#0#0#0#0#0#0#0#0; Extended((@Data[Length(Data)-9])^) := Rec^.tExtended; end;
  btString, btPChar: begin Data := Data + #0#0#0#0; tbtString((@Data[Length(Data)-3])^) := tbtString(Rec^.tString); end;
  btRecord, btArray:
    begin
      if Rec^.trecord <> nil then
      begin
        for i := 0 to Rec^.trecord^.FieldCount -1 do
        begin
          CreateRecord_(Rec^.trecord^.Fields[I], Data, Se, SupFunc);
        end;
      end;
    end;
  btResourcePointer:
    begin
      Data := Data + SupFunc^.PtrToStr(SupFunc, Se, Rec);
    end;
{$IFNDEF NOINT64}btS64: begin Data := Data + #0#0#0#0#0#0#0#0; int64((@Data[Length(Data)-7])^) := Rec^.ts64; end;{$ENDIF}
  end;
end;

function CreateRecord(VarParam: Boolean; Fvar: PIFVariant; SE: TIFPSExec; SupFunc: PResourcePtrSupportFuncs): PCallInfo;
begin
  New(Result);
  Result^.ftype := ciRecord;
  Result^.orgvar := FVar;
  Result^.varparam:= VarParam;
  CreateRecord_(FVar, Result^.recData, Se, SupFunc);
end;

procedure DestroyRecord_(CopyBack: Boolean; Rec: PIFVariant; var Position: Longint; const Data: string; SE: TIFPSExec; SupFunc: PResourcePtrSupportFuncs);
var
  I: Longint;
  P: Pointer;

  procedure GetP(var D; Len: Longint);
  begin
    if Position + Len -1 <= Length(Data) then
    begin
      if CopyBack then Move(Data[Position], D, Len);
      Position := Position + Len;
    end else Position := Length(Data) + 1;
  end;


begin
  while Rec^.FType^.BaseType = btPointer do
  begin
    Rec := Rec^.tPointer;
    if Rec = nil then begin Inc(position, 4); Exit; end;
  end;
  case Rec^.FType^.BaseType of
  btS8, btU8: GetP(Rec^.tu8, 1);
  btU16, btS16: GetP(Rec^.tu16, 2);
  btS32, btU32: GetP(Rec^.tu32, 4);
  btSingle: GetP(Rec^.tsingle, 4);
  btDouble: GetP(Rec^.tdouble, 8);
  btExtended: GetP(Rec^.TExtended, 10);
  btString, btPChar: begin GetP(P, 4); tbtString(Rec^.tString) := string(p); end;
  btRecord, btArray:
    begin
      if Rec^.trecord <> nil then
      begin
        for i := 0 to Rec^.trecord^.FieldCount -1 do
        begin
          DestroyRecord_(CopyBack, Rec^.trecord^.Fields[I], Position, Data, Se, SupFunc);
        end;
      end;
    end;
  btResourcePointer:
    begin
      GetP(I, 4);
      SupFunc^.ResToPtr(SupFunc, SE, I, Rec);
    end;
{$IFNDEF NOINT64}btS64: begin GetP(Rec^.ts64, 8); end;{$ENDIF}
  end;
end;


procedure DestroyRecord(Rec: PCallInfo; SE: TIFPSExec; SupFunc: PResourcePtrSupportFuncs);
var
  Pos: Longint;
begin
  Pos := 1;
  DestroyRecord_(Rec^.varparam, Rec^.orgvar, Pos, Rec^.recData, Se, SupFunc);
end;

function InnerfuseCall(SE: TIFPSExec; Self, Address: Pointer; CallingConv: TCallingConvention; Params: TIfList; res: PIfVariant; SupFunc: PResourcePtrSupportFuncs): Boolean;
var
  Stack: ansistring;
  I: Longint;
  RegUsage: Byte;
  CallData: TIfList;
  pp: PCallInfo;

  EAX, EDX, ECX: Longint;

  function GetPtr(fVar: PIfVariant): Boolean;
  var
    varPtr: Pointer;
    UseReg: Boolean;
    tempstr: string;
    p: PCallInfo;
  begin
    Result := False;
    if fVar^.RefCount >= IFPSAddrStackStart then begin
      fvar^.RefCount := FVar^.RefCount and not IFPSAddrStackStart;
      case fVar^.FType^.BaseType of
        btArray:
          begin
            p := CreateOpenArray(SE, fVar, SupFunc);
            if p =nil then exit;
            p^.varparam := true;
            CallData.Add(p);
            case RegUsage of
              0: begin EAX := Longint(p^.arrData); Inc(RegUsage); end;
              1: begin EDX := Longint(p^.arrData); Inc(RegUsage); end;
              2: begin ECX := Longint(p^.arrData); Inc(RegUsage); end;
              else begin
                Stack := #0#0#0#0 + Stack;
                Pointer((@Stack[1])^) := p^.arrData;
              end;
            end;
            case RegUsage of
              0: begin EAX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              1: begin EDX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              2: begin ECX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              else begin
                Stack := #0#0#0#0 + Stack;
                Longint((@Stack[1])^) := p^.arrLength -1;
              end;
            end;
            Result := True;
            Exit;
          end;
        {$IFDEF HAVEVARIANT}
        btVariant:
          begin
            p := BuildVariant(SE, fvar, SupFunc);
            if p = nil then exit;
            p^.varparam := True;
            VarPtr := @(p^.varVar);
            CallData.Add(p);
          end;
        {$ENDIF}
        btRecord:
          begin
            p := CreateRecord(True, fVar, SE, SupFunc);
            VarPtr := @(p^.recData[1]);
            CallData.Add(p);
          end;
        btResourcePointer:
          begin
            if SupFunc = nil then exit;
            tempstr := SupFunc^.VarPtrToStr(SupFunc, SE, fVar);
            if length(tempstr) <> 4 then exit;
            VarPtr := Pointer((@tempstr[1])^);
          end;
        btString: VarPtr := @tbtString(fvar^.tstring);
        btU8, btS8, btU16, btS16, btU32, btS32, btSingle, btDouble,
        btExtended{$IFNDEF NOINT64}, bts64{$ENDIF}: VarPtr := @(fVar^.tu8);
      else begin
          exit; //invalid type
        end;
      end; {case}
      case RegUsage of
        0: begin EAX := Longint(VarPtr); Inc(RegUsage); end;
        1: begin EDX := Longint(VarPtr); Inc(RegUsage); end;
        2: begin ECX := Longint(VarPtr); Inc(RegUsage); end;
        else begin
          Stack := #0#0#0#0 + Stack;
          Pointer((@Stack[1])^) := VarPtr;
        end;
      end;
    end else begin
      UseReg := True;
      case fVar^.FType^.BaseType of
        btArray:
          begin
            p := CreateOpenArray(SE, fVar, SupFunc);
            if p =nil then exit;
            CallData.Add(p);
            case RegUsage of
              0: begin EAX := Longint(p^.arrData); Inc(RegUsage); end;
              1: begin EDX := Longint(p^.arrData); Inc(RegUsage); end;
              2: begin ECX := Longint(p^.arrData); Inc(RegUsage); end;
              else begin
                Stack := #0#0#0#0 + Stack;
                Pointer((@Stack[1])^) := p^.arrData;
              end;
            end;
            case RegUsage of
              0: begin EAX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              1: begin EDX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              2: begin ECX := Longint(p^.arrLength -1); Inc(RegUsage); end;
              else begin
                Stack := #0#0#0#0 + Stack;
                Longint((@Stack[1])^) := p^.arrLength -1;
              end;
            end;
            Result := True;
            exit;
          end;
        {$IFDEF HAVEVARIANT}
        btVariant:
          begin
            p := BuildVariant(Se, fvar, SupFunc);
            if p = nil then exit;
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := @(p^.varvar);
            p^.varparam := False;
            CallData.Add(p);
          end;
        {$ENDIF}
        btRecord:
          begin
            p := CreateRecord(False, fVar, SE, SupFunc);
            CallData.Add(p);
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := @(P^.recData[1]);
          end;
        btDouble: {8 bytes} begin
            TempStr := #0#0#0#0#0#0#0#0;
            UseReg := False;
            double((@TempStr[1])^) := fVar^.tdouble;
          end;

        btSingle: {4 bytes} begin
            TempStr := #0#0#0#0;
            UseReg := False;
            Single((@TempStr[1])^) := fVar^.tsingle;
          end;

        btExtended: {10 bytes} begin
            UseReg := False;
            TempStr:= #0#0#0#0#0#0#0#0#0#0#0#0;
            Extended((@TempStr[1])^) := fVar^.textended;
          end;
        btU8,
        btS8: begin
            TempStr := char(fVar^.tu8) + #0#0#0;
          end;
        btu16, btS16: begin
            TempStr := #0#0#0#0;
            Word((@TempStr[1])^) := fVar^.tu16;
          end;
        btu32, bts32: begin
            TempStr := #0#0#0#0;
            Longint((@TempStr[1])^) := fVar^.tu32;
          end;
        btPChar, btString: begin
            TempStr := #0#0#0#0;
            Pointer((@TempStr[1])^) := fVar^.tstring;
          end;
        btResourcePointer:
          begin
            if SupFunc = nil then exit;
            TempStr := SupFunc^.PtrToStr(SupFunc, SE, fVar);
            if Length(TempStr) > 4 then
              UseReg := False
            else
              SetLength(TempStr, 4);
          end;
        {$IFNDEF NOINT64}bts64: begin
            TempStr:= #0#0#0#0#0#0#0#0;
            Int64((@TempStr[1])^) := fvar^.ts64;
        end;{$ENDIF}
      end; {case}
      if UseReg then
      begin
        case RegUsage of
          0: begin EAX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          1: begin EDX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          2: begin ECX := Longint((@Tempstr[1])^); Inc(RegUsage); end;
          else Stack := TempStr + Stack;
        end;
      end else begin
        Stack := TempStr + Stack;
      end;
    end;                      
    Result := True;
  end;
begin
  InnerfuseCall := False;
  if Address = nil then
    exit; // need address
  Stack := '';
  CallData := TIfList.Create;
  if res <> nil then
    res^.RefCount := res^.RefCount or IFPSAddrStackStart;
  try
  try
    case CallingConv of
      ccRegister: begin
          EAX := 0;
          EDX := 0;
          ECX := 0;
          RegUsage := 0;
          if assigned(Self) then begin
            RegUsage := 1;
            EAX := Longint(Self);
          end;
          for I := 0 to Params.Count - 1 do
          begin
            if not GetPtr(Params.GetItem(I)) then Exit;
          end;
          if assigned(res) then begin
            case res^.FType^.BaseType of
              btResourcePointer:
                begin
                  if SupFunc = nil then exit;
                  if SupFunc^.ResultMethod = rmParam then GetPtr(res);
                end;
              btrecord, btstring{$IFNDEF NOINT64}, bts64{$ENDIF}{$IFDEF HAVEVARIANT}, btVariant{$ENDIF}: GetPtr(res);
            end;
            case res^.FType^.BaseType of
              btSingle:      res^.tsingle := RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      res^.tdouble:= RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    res^.textended:= RealFloatCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btU8, btS8:    res^.tu8 := RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 1);
              btu16, bts16:  res^.tu16:= RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 2);
              btu32, bts32:  res^.tu32:= RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4);
              btPChar:       TBTSTRING(res^.tstring) := Pchar(RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4));
              {$IFNDEF NOINT64}bts64, {$ENDIF}{$IFDEF HAVEVARIANT}btVariant, {$ENDIF}
              btrecord, btstring:      RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
              btResourcePointer: if SupFunc^.ResultMethod = rmParam then
                  RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 0)
                else
                  SupFunc^.ResToPtr(SupFunc, SE, RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 4), res);
            else
              exit;
            end;
          end else
            RealCall_Register(Address, EAX, EDX, ECX, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
          Result := True;
        end;
      ccPascal: begin
          RegUsage := 3;
          for I :=  0 to Params.Count - 1 do begin
            if not GetPtr(Params.GetItem(i)) then Exit;
          end;
          if assigned(res) then begin
            case res^.FType^.BaseType of
              btResourcePointer:
                begin
                  if SupFunc = nil then exit;
                  if SupFunc^.ResultMethod = rmParam then GetPtr(res);
                end;
              btrecord, btstring{$IFNDEF NOINT64}, bts64{$ENDIF}{$IFDEF HAVEVARIANT}, btVariant{$ENDIF}: GetPtr(res);
            end;
          end;
          if assigned(Self) then begin
            Stack := #0#0#0#0 +Stack;
            Pointer((@Stack[1])^) := Self;
          end;
          if assigned(res) then begin
            case res^.FType^.BaseType of
              btSingle:      res^.tsingle := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      res^.tdouble:= RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    res^.textended:= RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btU8, btS8:    res^.tu8 := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1);
              btu16, bts16:  res^.tu16:= RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2);
              btu32, bts32:  res^.tu32:= RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4);
              btPChar:       TBTSTRING(res^.tstring) := Pchar(RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4));
              {$IFNDEF NOINT64}bts64, {$ENDIF}{$IFDEF HAVEVARIANT}btVariant, {$ENDIF}
              btrecord, btstring:      RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
              btResourcePointer: if SupFunc^.ResultMethod = rmParam then
                  RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0)
                else
                  SupFunc^.ResToPtr(SupFunc, SE, RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4), res);
            else
              exit;
            end;
          end else
            RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
          Result := True;
        end;

      CCCdecl: begin
          RegUsage := 3;
          if assigned(Self) then begin
            Stack := #0#0#0#0;
            Pointer((@Stack[1])^) := Self;
          end;
          for I := Params.Count - 1 downto 0 do begin
            if not GetPtr(Params.GetItem(I)) then Exit;
          end;
          if assigned(res) then begin
            case res^.FType^.BaseType of
              btSingle:      res^.tsingle := RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      res^.tdouble:= RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    res^.textended:= RealFloatCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btU8, btS8:    res^.tu8 := RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1);
              btu16, bts16:  res^.tu16:= RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2);
              btu32, bts32:  res^.tu32:= RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4);
              btPChar:       TBTSTRING(res^.tstring) := Pchar(RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4));
              {$IFNDEF NOINT64}bts64, {$ENDIF}{$IFDEF HAVEVARIANT}btVariant, {$ENDIF}
              btrecord, btstring:      begin GetPtr(res); RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0); end;
              btResourcePointer: begin
                if SupFunc = nil then exit;
                if SupFunc^.ResultMethod = rmParam then begin
                  GetPtr(res);
                  RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
                end else
                  SupFunc^.ResToPtr(SupFunc, SE, RealCall_Cdecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4), res);
              end;
            else
              exit;
            end;
          end else begin
            RealCall_CDecl(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
          end;
          Result := True;
        end;
      CCStdCall: begin
          RegUsage := 3;
          if assigned(Self) then begin
            Stack := #0#0#0#0;
            Pointer((@Stack[1])^) := Self;
          end;
          for I := Params.Count - 1 downto 0 do begin
            if not GetPtr(Params.GetItem(I)) then exit;
          end;
          if assigned(res) then begin
            case res^.FType^.BaseType of
              btSingle:      res^.tsingle := RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btDouble:      res^.tdouble:= RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btExtended:    res^.textended:= RealFloatCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4);
              btU8, btS8:    res^.tu8 := RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 1);
              btu16, bts16:  res^.tu16:= RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 2);
              btu32, bts32:  res^.tu32:= RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4);
              btPChar:       TBTSTRING(res^.tstring) := Pchar(RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4));
              {$IFNDEF NOINT64}bts64, {$ENDIF}{$IFDEF HAVEVARIANT}btVariant, {$ENDIF}
              btrecord, btstring:      begin GetPtr(res); RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0); end;
              btResourcePointer: begin
                if SupFunc = nil then exit;
                if SupFunc^.ResultMethod = rmParam then begin
                  GetPtr(res);
                  RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
                end else
                  SupFunc^.ResToPtr(SupFunc, SE, RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 4), res);
              end;
            else
              exit;
            end;
          end else begin
            RealCall_Other(Address, @Stack[Length(Stack)-3], Length(Stack) div 4, 0);
          end;
          Result := True;
        end;
    end;
  except
    Result := False;
  end;
  finally
    if res <> nil then
      res^.RefCount := res^.RefCount and not IFPSAddrStackStart;
    for i := CallData.Count -1 downto 0 do
    begin
      pp := CallData.GetItem(i);
      case pp^.ftype of
        ciRecord: DestroyRecord(pp, SE, SupFunc);
        ciOpenArray: DestroyOpenArray(SE, pp, SupFunc);
        {$IFDEF HAVEVARIANT}ciVariant: if (pp^.varparam) then CopyBack(SE, pp); {$ENDIF}
      end;
      Dispose(pp);
    end;
    CallData.Free;
  end;
end;
{$IFDEF HAVEVARIANT}
begin
  VNull := Null;
{$ENDIF}
end.

