unit ifpiir_std;
{$I ifps3_def.inc}
interface
uses
  ifps3, ifps3common, ifps3utl, ifpiclassruntime, TypInfo, SysUtils;
{
  Will register files from:
    System
    Classes (No Streams)
}



procedure RIRegisterTObject(CL: TIFPSRuntimeClassImporter);
procedure RIRegisterTPersistent(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTComponent(Cl: TIFPSRuntimeClassImporter);
procedure RIRegisterTFreeClass(Cl: TIFPSRuntimeClassImporter; classP: TClass);
procedure RIRegister_Std(Cl: TIFPSRuntimeClassImporter);

implementation
uses
  Classes{$IFDEF CLX}, QControls, QGraphics{$ELSE}, Controls, Graphics{$ENDIF};



procedure RIRegisterTObject(CL: TIFPSRuntimeClassImporter);
begin
  with cl.Add(TObject) do
  begin
    RegisterConstructor(@TObject.Create, 'CREATE');
    RegisterMethod(@TObject.Free, 'FREE');
  end;
end;

procedure RIRegisterTPersistent(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TPersistent) do
  begin
    RegisterVirtualMethod(@TPersistent.Assign, 'ASSIGN');
  end;
end;

procedure TComponentOwnerR(Self: TComponent; var T: TComponent); begin T := Self.Owner; end;


procedure TCOMPONENTCOMPONENTS_R(Self: TCOMPONENT; var T: TCOMPONENT; t1: INTEGER); begin T := Self.COMPONENTS[t1]; end;
procedure TCOMPONENTCOMPONENTCOUNT_R(Self: TCOMPONENT; var T: INTEGER); begin t := Self.COMPONENTCOUNT; end;
procedure TCOMPONENTCOMPONENTINDEX_R(Self: TCOMPONENT; var T: INTEGER); begin t := Self.COMPONENTINDEX; end;
procedure TCOMPONENTCOMPONENTINDEX_W(Self: TCOMPONENT; T: INTEGER); begin Self.COMPONENTINDEX := t; end;
procedure TCOMPONENTCOMPONENTSTATE_R(Self: TCOMPONENT; var T: TCOMPONENTSTATE); begin t := Self.COMPONENTSTATE; end;
procedure TCOMPONENTDESIGNINFO_R(Self: TCOMPONENT; var T: LONGINT); begin t := Self.DESIGNINFO; end;
procedure TCOMPONENTDESIGNINFO_W(Self: TCOMPONENT; T: LONGINT); begin Self.DESIGNINFO := t; end;
procedure TCOMPONENTOWNER_R(Self: TCOMPONENT; var T: TCOMPONENT); begin T := Self.OWNER; end;


procedure RIRegisterTComponent(Cl: TIFPSRuntimeClassImporter);
begin
  with Cl.Add(TComponent) do
  begin
    RegisterMethod(@TComponent.FindComponent, 'FINDCOMPONENT');
    RegisterVirtualConstructor(@TComponent.Create, 'CREATE');
    RegisterPropertyHelper(@TComponentOwnerR, nil, 'OWNER');

    RegisterMethod(@TCOMPONENT.DESTROYCOMPONENTS, 'DESTROYCOMPONENTS');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTS_R, nil, 'COMPONENTS');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTCOUNT_R, nil, 'COMPONENTCOUNT');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTINDEX_R, @TCOMPONENTCOMPONENTINDEX_W, 'COMPONENTINDEX');
    RegisterPropertyHelper(@TCOMPONENTCOMPONENTSTATE_R, nil, 'COMPONENTSTATE');
    RegisterPropertyHelper(@TCOMPONENTDESIGNINFO_R, @TCOMPONENTDESIGNINFO_W, 'DESIGNINFO');
    RegisterPropertyHelper(@TCOMPONENTOWNER_R, nil, 'OWNER');
  end;




end;


procedure RIRegisterTFreeClass(Cl: TIFPSRuntimeClassImporter; classP: TClass);

  type MParamList = array[1..1023] of
          record
            Flags: TParamFlags;
            ParamName: ShortString;
            TypeName: ShortString;
          end;

var
    i,j: integer;
    Props: PPropList;
    TypeData: PTypeData;
    funcst: string;
    d: ^MParamList;

  begin
  // добавлено
    //if TypeData.CompType=nil then exit;
    TypeData := GetTypeData(classP.classInfo);
   if (TypeData = nil) or
        (TypeData.ClassType = nil) or
      (TypeData^.PropCount = 0)
              then Exit;

   with Cl.Add(ClassP) do
  begin
   try

   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   GetPropInfos(classP.ClassInfo, Props);
   for i := 0 to TypeData^.PropCount - 1 do
      begin
       case Props^[i]^.PropType^^.Kind of
        tkMethod:
            begin
            RegisterEventPropertyHelper(nil,nil,uppercase(Props^[i]^.Name));
            end;

         tkString,tkLString, tkWString{,tkMethod}:
           RegisterPropertyHelperM(nil,nil,uppercase(Props^[i]^.Name));
         tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
         tkSet,tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray:
           RegisterPropertyHelperM(nil,nil,uppercase(Props^[i]^.Name));
         tkClass:
           begin
           if ((cl.FindClass(Uppercase(GetTypeData(Props^[i]^.PropType^).ClassType.ClassName))=nil) and
           (GetTypeData(Props^[i]^.PropType^).ClassType.ClassInfo<>nil))
           then
            RIRegisterTFreeClass(Cl,GetTypeData(Props^[i]^.PropType^).ClassType);
           RegisterPropertyHelperM(nil,nil,uppercase(Props^[i]^.Name));
           end;
        end;
      end;
   finally
     Freemem(Props);
   end;
   end;
end;

function TSTRING_R(Self: TOBJECT; p: Pointer): pointer; begin result:=pointer(longint(self) + (longint(p) and $00FFFFFF)); end;
function TSTRING_W(Self: TOBJECT; p: Pointer): pointer; begin result:=pointer(longint(self) + (longint(p) and $00FFFFFF)); end;

procedure RIRegister_Std(Cl: TIFPSRuntimeClassImporter);
begin
  RIRegisterTObject(CL);
  RIRegisterTPersistent(Cl);
  RIRegisterTComponent(Cl);
end;
// MiniVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)

end.





