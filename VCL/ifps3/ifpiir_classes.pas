unit ifpiir_classes;

{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3common, ifps3utl, ifpiclassruntime;
{
  Will register files from:
    Classes (exception TPersistent and TComponent)

  Register STD first

}

procedure RIRegisterTStrings(cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTStringList(cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTBITS(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTSTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTHANDLESTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTFILESTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTMEMORYSTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTRESOURCESTREAM(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTPARSER(Cl: TIFPSRuntimeClassImporter);


procedure RIRegister_Classes(Cl: TIFPSRuntimeClassImporter);

implementation
uses
  Classes;

procedure TStringsCountR(Self: TStrings; var T: Longint); begin T := Self.Count; end;

procedure TStringsTextR(Self: TStrings; var T: string); begin T := Self.Text; end;
procedure TStringsTextW(Self: TStrings; T: string); begin Self.Text:= T; end;

procedure TStringsCommaTextR(Self: TStrings; var T: string); begin T := Self.CommaText; end;
procedure TStringsCommaTextW(Self: TStrings; T: string); begin Self.CommaText:= T; end;

procedure TStringsStringsR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Strings[I];
end;
procedure TStringsStringsW(Self: TStrings; const T: string; I: Longint);
begin
  Self.Strings[I]:= T;
end;

procedure TStringsNamesR(Self: TStrings; var T: string; I: Longint);
begin
T := Self.Names[I];
end;
procedure TStringsValuesR(Self: TStrings; var T: string; const I: string);
begin
T := Self.Values[I];
end;
procedure TStringsValuesW(Self: TStrings; Const T, I: String);
begin
  Self.Values[I]:= T;
end;


procedure RIRegisterTStrings(cl: TIFPSRuntimeClassImporter); // requires TPersistent
begin
  with Cl.Add(TStrings) do
  begin
    RegisterVirtualMethod(@TStrings.Add, 'ADD');
    RegisterMethod(@TStrings.Append, 'APPEND');
    RegisterVirtualMethod(@TStrings.AddStrings, 'ADDSTRINGS');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Clear, 'CLEAR');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Delete, 'DELETE');
    RegisterVirtualMethod(@TStrings.IndexOf, 'INDEXOF');
    RegisterVirtualAbstractMethod(TStringList, @TStringList.Insert, 'INSERT');
    RegisterPropertyHelper(@TStringsCountR, nil, 'COUNT');
    RegisterPropertyHelper(@TStringsTextR, @TStringsTextW, 'TEXT');
    RegisterPropertyHelper(@TStringsCommaTextR, @TStringsCommatextW, 'COMMATEXT');
    RegisterVirtualMethod(@TStrings.LoadFromFile, 'LOADFROMFILE');
    RegisterVirtualMethod(@TStrings.SaveToFile, 'SAVETOFILE');
    RegisterPropertyHelper(@TStringsStringsR, @TStringsStringsW, 'STRINGS');

    {$IFNDEF MINIVCL}
    RegisterMethod(@TStrings.BeginUpdate, 'BEGINUPDATE');
    RegisterMethod(@TStrings.EndUpdate, 'ENDUPDATE');
    RegisterMethod(@TStrings.Equals,  'EQUALS');
    RegisterVirtualMethod(@TStrings.Exchange, 'EXCHANGE');
    RegisterMethod(@TStrings.IndexOfName, 'INDEXOFNAME');
    RegisterVirtualMethod(@TStrings.LoadFromStream, 'LOADFROMSTREAM');
    RegisterVirtualMethod(@TStrings.Move, 'MOVE');
    RegisterVirtualMethod(@TStrings.SaveToStream, 'SAVETOSTREAM');
    RegisterVirtualMethod(@TStrings.SetText, 'SETTEXT');
    RegisterPropertyHelper(@TStringsNamesR, nil, 'NAMES');
    RegisterPropertyHelper(@TStringsValuesR, @TStringsValuesW, 'VALUES');
    RegisterVirtualMethod(@TSTRINGS.ADDOBJECT, 'ADDOBJECT');
    RegisterVirtualMethod(@TSTRINGS.GETTEXT, 'GETTEXT');
    RegisterMethod(@TSTRINGS.INDEXOFOBJECT, 'INDEXOFOBJECT');
    RegisterMethod(@TSTRINGS.INSERTOBJECT, 'INSERTOBJECT');
    {$ENDIF}
  end;
end;

procedure TSTRINGLISTDUPLICATES_R(Self: TSTRINGLIST; var T: TDUPLICATES); begin T := Self.DUPLICATES; end;
procedure TSTRINGLISTDUPLICATES_W(Self: TSTRINGLIST; const T: TDUPLICATES); begin Self.DUPLICATES := T; end;
procedure TSTRINGLISTSORTED_R(Self: TSTRINGLIST; var T: BOOLEAN); begin T := Self.SORTED; end;
procedure TSTRINGLISTSORTED_W(Self: TSTRINGLIST; const T: BOOLEAN); begin Self.SORTED := T; end;
procedure TSTRINGLISTONCHANGE_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT);
begin
T := Self.ONCHANGE; end;
procedure TSTRINGLISTONCHANGE_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT);
begin
Self.ONCHANGE := T; end;
procedure TSTRINGLISTONCHANGING_R(Self: TSTRINGLIST; var T: TNOTIFYEVENT); begin T := Self.ONCHANGING; end;
procedure TSTRINGLISTONCHANGING_W(Self: TSTRINGLIST; const T: TNOTIFYEVENT); begin Self.ONCHANGING := T; end;
procedure RIRegisterTSTRINGLIST(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TSTRINGLIST) do
  begin
    RegisterVirtualMethod(@TSTRINGLIST.FIND, 'FIND');
    RegisterVirtualMethod(@TSTRINGLIST.SORT, 'SORT');
    RegisterPropertyHelper(@TSTRINGLISTDUPLICATES_R, @TSTRINGLISTDUPLICATES_W, 'DUPLICATES');
    RegisterPropertyHelper(@TSTRINGLISTSORTED_R, @TSTRINGLISTSORTED_W, 'SORTED');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGE_R, @TSTRINGLISTONCHANGE_W, 'ONCHANGE');
    RegisterEventPropertyHelper(@TSTRINGLISTONCHANGING_R, @TSTRINGLISTONCHANGING_W, 'ONCHANGING');
  end;
end;
procedure TBITSBITS_R(Self: TBITS; T: BOOLEAN; t1: INTEGER); begin Self.BITS[t1] := T; end;
procedure TBITSBITS_W(Self: TBITS; var T: BOOLEAN; t1: INTEGER); begin T := Self.Bits[t1]; end;
procedure TBITSSIZE_R(Self: TBITS; T: INTEGER); begin Self.SIZE := T; end;
procedure TBITSSIZE_W(Self: TBITS; var T: INTEGER); begin T := Self.SIZE; end;

procedure RIRegisterTBITS(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TBITS) do
  begin
    RegisterMethod(@TBITS.OPENBIT, 'OPENBIT');
    RegisterPropertyHelper(@TBITSBITS_R, @TBITSBITS_W, 'BITS');
    RegisterPropertyHelper(@TBITSSIZE_R, @TBITSSIZE_W, 'SIZE');
  end;
end;

procedure TSTREAMPOSITION_R(Self: TSTREAM; T: LONGINT); begin Self.POSITION := T; end;
procedure TSTREAMPOSITION_W(Self: TSTREAM; var T: LONGINT); begin T := Self.POSITION; end;
procedure TSTREAMSIZE_R(Self: TSTREAM; var T: LONGINT); begin t := Self.SIZE; end;

procedure RIRegisterTSTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TSTREAM) do
  begin
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.READ, 'READ');
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.WRITE, 'WRITE');
    RegisterVirtualAbstractMethod(TMemoryStream, @TMemoryStream.SEEK, 'SEEK');
    RegisterMethod(@TSTREAM.READBUFFER, 'READBUFFER');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFER');
    RegisterMethod(@TSTREAM.COPYFROM, 'COPYFROM');
    RegisterPropertyHelper(@TSTREAMPOSITION_R, @TSTREAMPOSITION_W, 'POSITION');
    RegisterPropertyHelper(@TSTREAMSIZE_R, nil, 'SIZE');
  end;
end;

procedure THANDLESTREAMHANDLE_R(Self: THANDLESTREAM; var T: INTEGER); begin T := Self.HANDLE; end;

procedure RIRegisterTHANDLESTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(THANDLESTREAM) do
  begin
    RegisterConstructor(@THANDLESTREAM.CREATE, 'CREATE');
    RegisterPropertyHelper(@THANDLESTREAMHANDLE_R, nil, 'HANDLE');
  end;
end;



procedure RIRegisterTFILESTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TFILESTREAM) do
  begin
    RegisterConstructor(@TFILESTREAM.CREATE, 'CREATE');
  end;
end;



procedure RIRegisterTCUSTOMMEMORYSTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TCUSTOMMEMORYSTREAM) do
  begin
    RegisterMethod(@TCUSTOMMEMORYSTREAM.SAVETOSTREAM, 'SAVETOSTREAM');
    RegisterMethod(@TCUSTOMMEMORYSTREAM.SAVETOFILE, 'SAVETOFILE');
  end;
end;


procedure RIRegisterTMEMORYSTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TMEMORYSTREAM) do
  begin
    RegisterMethod(@TMEMORYSTREAM.CLEAR, 'CLEAR');
    RegisterMethod(@TMEMORYSTREAM.LOADFROMSTREAM, 'LOADFROMSTREAM');
    RegisterMethod(@TMEMORYSTREAM.LOADFROMFILE, 'LOADFROMFILE');
    RegisterMethod(@TMEMORYSTREAM.SETSIZE, 'SETSIZE');
  end;
end;



procedure RIRegisterTRESOURCESTREAM(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TRESOURCESTREAM) do
  begin
    RegisterConstructor(@TRESOURCESTREAM.CREATE, 'CREATE');
    RegisterConstructor(@TRESOURCESTREAM.CREATEFROMID, 'CREATEFROMID');
  end;
end;



procedure TPARSERSOURCELINE_R(Self: TPARSER; var T: INTEGER); begin T := Self.SOURCELINE; end;
procedure TPARSERTOKEN_R(Self: TPARSER; var T: CHAR); begin T := Self.TOKEN; end;

procedure RIRegisterTPARSER(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TPARSER) do
  begin
    RegisterConstructor(@TPARSER.CREATE, 'CREATE');
    RegisterMethod(@TPARSER.CHECKTOKEN, 'CHECKTOKEN');
    RegisterMethod(@TPARSER.CHECKTOKENSYMBOL, 'CHECKTOKENSYMBOL');
    RegisterMethod(@TPARSER.ERROR, 'ERROR');
    RegisterMethod(@TPARSER.ERRORSTR, 'ERRORSTR');
    RegisterMethod(@TPARSER.HEXTOBINARY, 'HEXTOBINARY');
    RegisterMethod(@TPARSER.NEXTTOKEN, 'NEXTTOKEN');
    RegisterMethod(@TPARSER.SOURCEPOS, 'SOURCEPOS');
    RegisterMethod(@TPARSER.TOKENCOMPONENTIDENT, 'TOKENCOMPONENTIDENT');
    RegisterMethod(@TPARSER.TOKENFLOAT, 'TOKENFLOAT');
    RegisterMethod(@TPARSER.TOKENINT, 'TOKENINT');
    RegisterMethod(@TPARSER.TOKENSTRING, 'TOKENSTRING');
    RegisterMethod(@TPARSER.TOKENSYMBOLIS, 'TOKENSYMBOLIS');
    RegisterPropertyHelper(@TPARSERSOURCELINE_R, nil, 'SOURCELINE');
    RegisterPropertyHelper(@TPARSERTOKEN_R, nil, 'TOKEN');
  end;
end;

procedure RIRegister_Classes(Cl: TIFPSRuntimeClassImporter);
begin
  {$IFNDEF MINIVCL}
  RIRegisterTSTREAM(Cl);
  {$ENDIF}
  RIRegisterTStrings(cl);
  RIRegisterTStringList(cl);
  {$IFNDEF MINIVCL}
  RIRegisterTBITS(cl);
  RIRegisterTHANDLESTREAM(Cl);
  RIRegisterTMEMORYSTREAM(Cl);
  RIRegisterTFILESTREAM(Cl);
  RIRegisterTCUSTOMMEMORYSTREAM(Cl);
  RIRegisterTRESOURCESTREAM(Cl);
  RIRegisterTPARSER(Cl);
  {$ENDIF}
end;

// MiniVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
