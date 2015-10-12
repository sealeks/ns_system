unit ifps3disasm;
{$I ifps3_def.inc}

interface
uses
  ifps3, ifps3utl, ifps3common, sysutils;

function IFPS3DataToText(const Input: string; var Output: string): Boolean;
implementation

type
  TMyIFPSExec = class(TIFPSExec)
    function ImportProc(const Name: ShortString; var proc: TIFProcRec): Boolean; override;
  end;

function Debug2Str(const s: string): string;
var
  i: Integer;
begin
  result := '';
  for i := 1 to length(s) do
  begin
    if (s[i] < #32) or (s[i] > #128) then
      result := result + '\'+inttohex(ord(s[i]), 2)
    else if s[i] = '\' then
      result := result + '\\'
    else
      result := result + s[i]; 
  end;

end;

function SpecImportProc(Sender: TObject; p: PIFProcRec): Boolean; forward;


function IFPS3DataToText(const Input: string; var Output: string): Boolean;
var
  I: TMyIFPSExec;

  procedure Writeln(const s: string);
  begin
    Output := Output + s + #13#10;
  end;
  function BT2S(const S: TIFPSBaseType): string;
  begin
    case s of
      btU8: Result := 'U8';
      btS8: Result := 'S8';
      btU16: Result := 'U16';
      btS16: Result := 'S16';
      btU32: Result := 'U32';
      btS32: Result := 'S32';
      btSingle: Result := 'Single';
      btDouble: Result := 'Double';
      btExtended: Result := 'Extended';
      btString: Result := 'String';
      btRecord: Result := 'Record';
      btArray: Result := 'Array';
      btResourcePointer: Result := 'ResourcePointer';
      btPointer: Result := 'Pointer';
      btVariant: Result := 'Variant';
    else
      Result := 'Unknown';
    end;
  end;
  procedure WriteTypes;
  var
    T: Longint;
  begin
    Writeln('[TYPES]');
    for T := 0 to i.FTypes.Count -1 do
    begin
      if PIFTypeRec(i.FTypes.getItem(t))^.ExportName <> '' then
        Writeln('Type ['+inttostr(t)+']: '+bt2s(PIFTypeRec(i.FTypes.getItem(t))^.BaseType)+' Export: '+PIFTypeRec(i.FTypes.getItem(t))^.ExportName)
      else
        Writeln('Type ['+inttostr(t)+']: '+bt2s(PIFTypeRec(i.FTypes.getItem(t))^.BaseType));
    end;
  end;
  procedure WriteVars;
  var
    T: Longint;
    function FindType(p: Pointer): Cardinal;
    var
      T: Longint;
    begin
      Result := Cardinal(-1);
      for T := 0 to i.FTypes.Count -1 do
      begin
        if p = i.FTypes.GetItem(t) then begin
          result := t;
          exit;
        end;
      end;
    end;
  begin
    Writeln('[VARS]');
    for t := 0 to i.FGlobalVars.count -1 do
    begin
      Writeln('Var ['+inttostr(t)+']: '+ IntToStr(FindType(PIFVariant(i.FGlobalVars.GetItem(t))^.FType)) + ' '+ bt2s(PIFVariant(i.FGlobalVars.GetItem(t))^.Ftype^.BaseType) + ' '+ PIFVariant(i.FGlobalVars.GetItem(t))^.Ftype^.ExportName);
    end;
  end;

  procedure WriteProcs;
  var
    t: Longint;
    procedure WriteProc(proc: PIFProcRec);
    var
      CP: Cardinal;
      function ReadData(var Data; Len: Cardinal): Boolean;
      begin
        if CP + Len <= PROC .Length then begin
          Move(Proc.Data^[CP], Data, Len);
          CP := CP + Len;
          Result := True;
        end else Result := False;
      end;
      function ReadByte(var B: Byte): Boolean;
      begin
        if CP < Proc.Length then begin
          b := Proc.Data^[cp];
          Inc(CP);
          Result := True;
        end else Result := False;
      end;

      function ReadLong(var B: Cardinal): Boolean;
      begin
        if CP + 3 < Proc.Length then begin
          b := Cardinal((@Proc.Data^[CP])^);
          Inc(CP, 4);
          Result := True;
        end else Result := False;
      end;
      function ReadWriteVariable: string;
      var
        VarType: byte;
        L1, L2: Cardinal;
        function ReadVar(FType: Cardinal): string;
        var
          F: PIFTypeRec;
          b: byte;
          w: word;
          l: Cardinal;
          e: extended;
          ss: single;
          d: double;
          s: string;
          function strtostr(const S: string): string;
          var
           i : Longint;
          begin
            result := '''';
            for i := 1 to length(s) do
            begin
              if s[i] = '''' then result := result + '''''' else
              if s[i] in [#32..#127] then result := result + s[i] else
              result := result + '''#'+inttostr(ord(s[i]))+'''';
            end;
            result := result + '''';
          end;

        begin
          result := '';
          F:= i.FTypes.GetItem(Ftype);
          if f = nil then exit;
          case f^.BaseType of
            btU8: begin if not ReadData(b, 1) then exit; Result := IntToStr(tbtu8(B)); end;
            btS8: begin if not ReadData(b, 1) then exit; Result := IntToStr(tbts8(B)); end;
            btU16: begin if not ReadData(w, 2) then exit; Result := IntToStr(tbtu16(w)); end;
            btS16: begin if not ReadData(w, 2) then exit; Result := IntToStr(tbts16(w)); end;
            btU32: begin if not ReadData(l, 4) then exit; Result := IntToStr(tbtu32(l)); end;
            btS32: begin if not ReadData(l, 4) then exit; Result := IntToStr(tbts32(l)); end;
            btSingle: begin if not ReadData(ss, Sizeof(tbtsingle)) then exit; Result := FloatToStr(ss); end;
            btDouble: begin if not ReadData(d, Sizeof(tbtdouble)) then exit; Result := FloatToStr(d); end;
            btExtended: begin if not ReadData(e, Sizeof(tbtextended)) then exit; Result := FloatToStr(e); end;
            btPChar, btString: begin if not ReadData(l, 4) then exit; SetLength(s, l); if not readData(s[1], l) then exit; Result := strtostr(s); end;
          end;
        end;
        function AddressToStr(a: Cardinal): string;
        begin
          if a < IFPSAddrNegativeStackStart then
            Result := 'GlobalVar['+inttostr(a)+']'
          else
            Result := 'Base['+inttostr(Longint(A-IFPSAddrStackStart))+']';
        end;

      begin
        Result := '';
        if not ReadByte(VarType) then Exit;
        case VarType of
          0:
          begin

            if not ReadLong(L1) then Exit;
            Result := AddressToStr(L1);
          end;
          1:
          begin
            if not ReadLong(L1) then Exit;
            Result := '['+ReadVar(l1)+']';
          end;
          2:
          begin
            if not ReadLong(L1) then Exit;
            if not ReadLong(L2) then Exit;
            Result := AddressToStr(L1)+'.['+inttostr(l2)+']';
          end;
          3:
          begin
            if not ReadLong(l1) then Exit;
            if not ReadLong(l2) then Exit;
            Result := AddressToStr(L1)+'.'+AddressToStr(l2);
          end;
        end;
      end;

    var
      b: Byte;
      s: string;
      DP, D1, D2: Cardinal;

    begin
      CP := 0;
      while true do
      begin
        DP := cp;
        if not ReadByte(b) then Exit;
        case b of
          CM_A:
          begin

            Writeln(' ['+inttostr(dp)+'] ASSIGN '+ReadWriteVariable+ ', ' + ReadWriteVariable);
          end;
          CM_CA:
          begin
            if not ReadByte(b) then exit;
            case b of
            0: s:= '+';
            1: s := '-';
            2: s := '*';
            3: s:= '/';
            4: s:= 'MOD';
            5: s:= 'SHL';
            6: s:= 'SHR';
            7: s:= 'AND';
            8: s:= 'OR';
            9: s:= 'XOR';
            else
              exit;
            end;
            Writeln(' ['+inttostr(dp)+'] CALC '+ReadWriteVariable+ ' '+s+' ' + ReadWriteVariable);
          end;
          CM_P:
          begin
            Writeln(' ['+inttostr(dp)+'] PUSH '+ReadWriteVariable);
          end;
          CM_PV:
          begin
            Writeln(' ['+inttostr(dp)+'] PUSHVAR '+ReadWriteVariable);
          end;
          CM_PO:
          begin
            Writeln(' ['+inttostr(dp)+'] POP');
          end;
          Cm_C:
          begin
            if not ReadLong(D1) then exit;
            Writeln(' ['+inttostr(dp)+'] CALL '+inttostr(d1));
          end;
          Cm_G:
          begin
            if not ReadLong(D1) then exit;
            Writeln(' ['+inttostr(dp)+'] GOTO currpos + '+IntToStr(d1)+' ['+IntToStr(CP+d1)+']');
          end;
          Cm_CG:
          begin
            if not ReadLong(D1) then exit;
            Writeln(' ['+inttostr(dp)+'] COND_GOTO currpos + '+IntToStr(d1)+' '+ReadWriteVariable+' ['+IntToStr(CP+d1)+']');
          end;
          Cm_CNG:
          begin
            if not ReadLong(D1) then exit;
            Writeln(' ['+inttostr(dp)+'] COND_NOT_GOTO currpos + '+IntToStr(d1)+' '+ReadWriteVariable+' ['+IntToStr(CP+d1)+']');
          end;
          Cm_R: Writeln(' ['+inttostr(dp)+'] RET');
          Cm_ST:
          begin
            if not ReadLong(d1) or not readLong(d2) then exit;
            Writeln(' ['+inttostr(dp)+'] SETSTACKTYPE Base['+inttostr(d1)+'] '+inttostr(d2));
          end;
          Cm_Pt:
          begin
            if not ReadLong(D1) then exit;
            Writeln(' ['+inttostr(dp)+'] PUSHTYPE '+inttostr(d1));
          end;
          CM_CO:
          begin
            if not readByte(b) then exit;
            case b of
              0: s := '>=';
              1: s := '<=';
              2: s := '>';
              3: s := '<';
              4: s := '<>';
              5: s := '=';
              else exit;
            end;
            Writeln(' ['+inttostr(dp)+'] COMPARE into '+ReadWriteVariable+': '+ReadWriteVariable+' '+s+' '+ReadWriteVariable);
          end;
          Cm_cv:
          begin
            Writeln(' ['+inttostr(dp)+'] CALLVAR '+ReadWriteVariable);
          end;
          cm_sp:
          begin
            Writeln(' ['+inttostr(dp)+'] SETPOINTER '+ReadWriteVariable+': '+ReadWriteVariable);
          end;
          cm_bn:
          begin
            Writeln(' ['+inttostr(dp)+'] NOT '+ReadWriteVariable);
          end;
          cm_vm:
          begin
            Writeln(' ['+inttostr(dp)+'] MINUS '+ReadWriteVariable);
          end;
          cm_sf:
           begin
             s := ReadWriteVariable;
             if not ReadByte(b) then exit;
             if b = 0 then
               Writeln(' ['+inttostr(dp)+'] SETFLAG '+s)
             else
               Writeln(' ['+inttostr(dp)+'] SETFLAG NOT '+s);
           end;
           cm_fg:
           begin
             if not ReadLong(D1) then exit;
             Writeln(' ['+inttostr(dp)+'] FLAGGOTO currpos + '+IntToStr(d1)+' ['+IntToStr(CP+d1)+']');
           end;
        else
          begin
            Writeln(' Disasm Error');
            Break;
          end;
        end;
      end;
    end;

  begin
    Writeln('[PROCS]');
    for t := 0 to i.FProcs.Count -1 do
    begin
      if PIFProcRec(i.FProcs.GetItem(t))^.ExternalProc then
      begin
        if PIFProcRec(i.FProcs.GetItem(t))^.ExportDecl = '' then
          Writeln('Proc ['+inttostr(t)+']: External: '+PIFProcRec(i.FProcs.GetItem(t))^.Name)
        else
          Writeln('Proc ['+inttostr(t)+']: External Decl: '+Debug2Str(PIFProcRec(i.FProcs.GetItem(t))^.ExportDecl));
      end else begin
        if PIFProcRec(i.FProcs.GetItem(t))^.ExportName <> '' then
        begin
          Writeln('Proc ['+inttostr(t)+'] Export: '+PIFProcRec(i.FProcs.GetItem(t))^.ExportName+' '+PIFProcRec(i.FProcs.GetItem(t))^.ExportDecl);
        end else
          Writeln('Proc ['+inttostr(t)+']');
        Writeproc(i.FProcs.GetItem(t));
      end;
    end;
  end;

begin
  Result := False;
  I := TMyIFPSExec.Create;
  I.AddSpecialProcImport('', @SpecImportProc, nil);

  if not I.LoadData(Input)then begin
    I.Free;
    Exit;
  end;
  Output := '';
  WriteTypes;
  WriteVars;
  WriteProcs;
  I.Free;
end;

{ TMyIFPSExec }

function MyDummyProc(Caller: TIFPSExec; p: PIFProcRec; Global, Stack: TIfList): Boolean;
begin
  Result := False;
end;


function TMyIFPSExec.ImportProc(const Name: ShortString;
  var proc: TIFProcRec): Boolean;
begin
  Proc.ProcPtr := MyDummyProc;
  result := true;
end;

function SpecImportProc(Sender: TObject; p: PIFProcRec): Boolean;
begin
  p.ProcPtr := MyDummyProc;
  Result := True;
end;

end.
