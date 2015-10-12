{*******************************************************}
{                                                       }
{     ���������� ��������, �������� ������� ��������    }
{    ��� ���������� � ��������� � ���������� ��������   }
{                GsvObjectInspector                     }
{                                                       }
{                    ������ 1.13                        }
{                                                       }
{          Copyright (C) 2003. ������ �����             }
{                                                       }
{ ������ �������������:                                 }
{   ���� ����� (ikirov@bars-it.ru)                      }
{                                                       }
{*******************************************************}

unit
  GsvObjectInspectorTypes;

interface

uses
  Classes, Windows, SysUtils;

type
  // ���� �������, ������������ ����������� ��������
  TGsvObjectInspectorPropertyKind = (
    pkNone,          // ������������ �������� ���� ��������
    pkText,          // �������� �������� ����� ���� ������������ ��� �����.
                     // ��������� ������ ����������� �� ������� Enter, ��
                     // �������� � ������� �������� ��� ������ ������
    pkDropDownList,  // �������� ����� ������������ ������ �������� ���
                     // ����������� �������������� �������� ��� ������
    pkDialog,        // �������� �������� ��������������� ��������-��������.
                     // �������� ����� ���� ������ ����� �����������
    pkFolder,        // ��������� ��������, ��������� ������������ �������������
                     // ������ �������
    pkReadOnlyText,  // �������� �������� ����� ���� ������������ �������,
                     // �� �������� ������ ��� ������
    pkBoolean,       // �������� ������������ ��� ����������� CheckBox, � �� ���
                     // ������������ ����� �� ���� ��������
    pkImmediateText, // ���������� pkText, �� ��������� �������� ��������
                     // ����������� ���������� ��� ����� ��������� ������
    pkTextList,      // �������� ������� pkDropDownList, �� ��� ��������
                     // ����� ������������� �������, �� ���� �������� ��������
                     // ����� ���� �� ��������� �������
    pkSet,           // ��������-��������� ������������ ��� ������������ ���
                     // ���������� ������ ��������� ���������, ������ ��
                     // ������� �������������� ��� ���������� ��������
    pkColor,         // �������� ���� TColor � ������������ ��������
                     // �������������� � ������������ ������ ����� �� ������
    pkColorRGB,      // �������� ���� TColor � ������������ ��������
                     // ��������������, ������������ ����� ����� � ������� R.G.B
                     // � ������������ ������ ����� � ������� �������
    pkFloat,         // �������� ��� ����������� ������������ ����� � �������� �������
    pkTextDialog     // ���������� pkText, �� �������� ����� ���� �������� ����������� �������
  );

  TGsvObjectInspectorTypeInfoClass = class of TGsvObjectInspectorTypeInfo;

  { ��������� (����������) �������� ������� ��� ��� ����������� � ����������.
    ���� NestedType ������������ ��� ������� ���������� ����� ��������, �������
    ��������� ����� ��� ��������� �����. ���� NestedClass - ��� ������������
    ��� NestedType � ��� ������, ���� ��������� �������� �� ����� ����������.
    ���� Tag ����� ���� ������������ ��� ����������� �����-����
    ������������� ������ ��� ��������, �� ��� ���� pkBoolean ��� �����
    ����� ���������������� �����. ���� �������� ������������� ��������
    ���������, �� �������� Tag ������ ���� ����� ����������� ��������
    ������������� �������� ���������, ��������, ��� �������� fsBold ��
    ��������� FontStyles �������� Tag ����� ����� Ord(fsBold). ��� ��������
    ���� Boolean �������� Tag ������ ���� ����� 0.
  }
  TGsvObjectInspectorPropertyInfo = record
    // ��� ���� �������� ����������� ������� ��� ����������� �����������
    Name:         String;  // ��� �������� � �������
    Caption:      String;  // �������� �������� ��� ����������
    Kind:         TGsvObjectInspectorPropertyKind; // ��� ��������
    Tag:          LongInt; // ������������� ������ ��������
    NestedType:   String;  // ��� �������� �������, ������������ ��������� ��������
    NestedClass:  TGsvObjectInspectorTypeInfoClass; // ����� �������� �������
    Help:         Integer; // ������ �������
    Hint:         String;  // ������ ���������
    EditMask:     String;  // ����� �������������� (��. ������� �� ������ TMaskEdit)
    FloatFormat:  String;  // ��������� ������ ��� ���� pkFloat (��. ������� �� ������� FormatFloat)

    // ��������� ���� ����������� � ������������ �����������
    HasChildren:  Boolean; // ���� ��������� ��������
    Level:        Integer; // ������� �������� � ������ ��������� �������
    Expanded:     Boolean; // ������� ��������� ��� ������� ��������� �������
    TheObject:    TObject; // ������, �������� ����������� ��������
    NestedObject: TObject; // ������ ���������� ��������
    LastValue:    String;  // ������������ � ������ SmartInvalidate
                           //   ��� ������������ ������������ ��������
  end;
  PGsvObjectInspectorPropertyInfo = ^TGsvObjectInspectorPropertyInfo;

  { ����������� ������� ����� ���������� (���������), ����������� ��������
    ��������������� ����. ��� ������ ���������� ������ ����������� �� �����
    ������. ��� ������ ���������� ������ �������� �� ����� ���������������
    ���� ���� ������� _INFO. ��������, ��� ��������������� ������ TButton,
    ��� ������ ���������� ����� TButton_INFO }
  TGsvObjectInspectorTypeInfo = class
  public
    class function  ObjectName(AObject: TObject): String; virtual;
    class function  TypeName: String; virtual;
    class function  TypeInfo: PGsvObjectInspectorPropertyInfo; virtual;
    class function  ChildrenInfo(Index: Integer):
                    PGsvObjectInspectorPropertyInfo; virtual;
    class procedure FillList(Info: PGsvObjectInspectorPropertyInfo;
                    List: TStrings); virtual;
    class procedure ShowDialog(Inspector: TComponent;
                    Info: PGsvObjectInspectorPropertyInfo;
                    const EditRect: TRect); virtual;
    class function  IntegerToString(const Value: LongInt): String; virtual;
    class function  StringToInteger(const Value: String): LongInt; virtual;
    class function  CharToString(const Value: Char): String; virtual;
    class function  StringToChar(const Value: String): Char; virtual;
    class function  FloatToString(const Value: Extended): String; virtual;
    class function  StringToFloat(const Value: String): Extended; virtual;
    class function  ObjectToString(const Value: TObject): String; virtual;
  end;
  PGsvObjectInspectorTypeInfo = ^TGsvObjectInspectorTypeInfo;

  // ��������� ��������� ������ ��� �������� �������-������������
  TGsvObjectInspectorListItem = record
    Name: String;  // ��� �������� ������
    Data: LongInt; // �������� �������� ������
  end;
  PGsvObjectInspectorListItem = ^TGsvObjectInspectorListItem;

  { ������������������ ������� ����� ����������, ����������� ��������
    ������������� ����, � ������� �������� �������� � ���� ������ }
  TGsvObjectInspectorTypeListInfo = class(TGsvObjectInspectorTypeInfo)
  protected
    class function  ListEnumItems(Index: Integer): PGsvObjectInspectorListItem;
                    virtual;
  public
    class procedure FillList(Info: PGsvObjectInspectorPropertyInfo;
                    List: TStrings); override;
    class function  IntegerToString(const Value: LongInt): String; override;
    class function  StringToInteger(const Value: String): LongInt; override;
  end;

  { ������������������ ������� ����� ����������, ����������� ��������
    ����-��������� }
  TGsvObjectInspectorTypeSetInfo = class(TGsvObjectInspectorTypeInfo)
  public
    class function  IntegerToString(const Value: LongInt): String; override;
  end;

  { ������������������ ������� ����� ����������, ����������� ��������
    ������� ������ ������ }
  TGsvObjectInspectorTypeFontInfo = class(TGsvObjectInspectorTypeInfo)
  public
    class procedure ShowDialog(Inspector: TComponent;
                    Info: PGsvObjectInspectorPropertyInfo;
                    const EditRect: TRect); override;
    class function  ObjectToString(const Value: TObject): String; override;
  end;

  { ������������������ ������� ����� ����������, ����������� ��������
    ���� TColor � ������������ ������� ����� � ������� RGB � ������
    ����� � ������� ������������ Windows-������� }
  TGsvObjectInspectorTypeColorRGBInfo = class(TGsvObjectInspectorTypeInfo)
  private
    class procedure ConvertError(const Value: String);

  public
    class procedure ShowDialog(Inspector: TComponent;
                    Info: PGsvObjectInspectorPropertyInfo;
                    const EditRect: TRect); override;
    class function  IntegerToString(const Value: LongInt): String; override;
    class function  StringToInteger(const Value: String): LongInt; override;
  end;

  // ��������� ������� ������ ������ �����������, ������������ � ������
  // TGsvObjectInspectorObjectInfo
  TGsvObjectInspectorTypeLevelInfo = record
    TheObject: TObject;
    Info:      TGsvObjectInspectorTypeInfoClass;
    Index:     Integer;
  end;

  // � ������� �� ������ TGsvObjectInspectorTypeInfo ���� ����� ���������
  // �������� ����������� �������, � �� ����. ����� �������������
  // ���������� ���������� �� �������� �� ������ ����������
  TGsvObjectInspectorObjectInfo = class
  public
    constructor Create;
    destructor  Destroy; override;

  private
    FTypeInfo:   TGsvObjectInspectorTypeInfoClass; // ���������� � ����

    // ������ ��� ������ ������� PropertyInfo
    FLevelInfo:  array of TGsvObjectInspectorTypeLevelInfo;
    FLevel:      Integer;
    FResultInfo: TGsvObjectInspectorPropertyInfo;

  protected
    FObject:  TObject; // �������������� ������

    function  GetObject: TObject; virtual;
    procedure SetObject(const Value: TObject); virtual;

  public
    function  ObjectName: String; virtual;
    function  ObjectTypeName: String; virtual;
    function  ObjectHelp: Integer; virtual;
    function  ObjectHint: String; virtual;
    function  PropertyInfo(Index: Integer):
              PGsvObjectInspectorPropertyInfo;
    procedure FillList(Info: PGsvObjectInspectorPropertyInfo;
              List: TStrings); virtual;
    procedure ShowDialog(Inspector: TComponent;
              Info: PGsvObjectInspectorPropertyInfo;
              const EditRect: TRect); virtual;
    function  GetStringValue(Info: PGsvObjectInspectorPropertyInfo):
              String; virtual;
    procedure SetStringValue(Info: PGsvObjectInspectorPropertyInfo;
              const Value: String); virtual;
    function  GetIntegerValue(Info: PGsvObjectInspectorPropertyInfo):
              LongInt; virtual;
    procedure SetIntegerValue(Info: PGsvObjectInspectorPropertyInfo;
              const Value: LongInt); virtual;

    property  TheObject: TObject read GetObject write SetObject;
  end;

  procedure GsvRegisterTypeInfo(AClass: TGsvObjectInspectorTypeInfoClass);
  procedure GsvRegisterTypesInfo(AClasses:
            array of TGsvObjectInspectorTypeInfoClass);
  function  GsvFindTypeInfo(const ATypeName: String):
            TGsvObjectInspectorTypeInfoClass;

  // ��������������� ��������� � �������
  function  GsvGetBit(Value: LongInt; Bit: Integer): Boolean;
  function  GsvChangeBit(Value: LongInt; Bit: Integer): LongInt;
  function  GsvGetIntegerProperty(Info: PGsvObjectInspectorPropertyInfo):
            LongInt; overload;
  function  GsvGetIntegerProperty(aObject: TObject; const aName: string):
            LongInt; overload;
  procedure GsvSetIntegerProperty(Info: PGsvObjectInspectorPropertyInfo;
            const Value: LongInt); overload;
  procedure GsvSetIntegerProperty(aObject: TObject; const aName: string;
            const Value: LongInt); overload;
  function  GsvGetStringProperty(Info: PGsvObjectInspectorPropertyInfo):
            String; overload;
  function  GsvGetStringProperty(aObject: TObject; const aName: string;
            aNestedClass: TGsvObjectInspectorTypeInfoClass): string; overload;
  procedure GsvSetStringProperty(Info: PGsvObjectInspectorPropertyInfo;
            const Value: String); overload;
  procedure GsvSetStringProperty(aObject: TObject; const aName, Value: string;
            aNestedClass: TGsvObjectInspectorTypeInfoClass); overload;

implementation

uses
  TypInfo, Dialogs, Graphics;

const
  GSV_DEFAULT_INFO: TGsvObjectInspectorPropertyInfo = (  );

resourcestring
  SERROR = 'Error';
  SINVALID_COLOR_VALUE = '''%s'' is not a valid color value';

var
  GsvTypesInfo: TStringList;

// ����������� ������ ����������
procedure GsvRegisterTypeInfo(AClass: TGsvObjectInspectorTypeInfoClass);
begin
  if not Assigned(GsvTypesInfo) then begin
    GsvTypesInfo            := TStringList.Create;
    GsvTypesInfo.Duplicates := dupIgnore;
    GsvTypesInfo.Sorted     := True;
  end;
  GsvTypesInfo.AddObject(AClass.ClassName, TObject(AClass));
end;

// ����������� ������� ������� ����������
procedure GsvRegisterTypesInfo(aClasses:
  array of TGsvObjectInspectorTypeInfoClass);
var
  i: Integer;
begin
  for i := Low(AClasses) to High(AClasses) do
    GsvRegisterTypeInfo(AClasses[i]);
end;

// ����� ������ ���������� ��� ��������� ����� ����. ������� ���������� nil
// ���� ����� �� ������
function GsvFindTypeInfo(const ATypeName: String):
  TGsvObjectInspectorTypeInfoClass;
var
  i: Integer;
begin
  Result := nil;
  if Assigned(GsvTypesInfo) then
    if GsvTypesInfo.Find(ATypeName + '_INFO', i) then
      Result := TGsvObjectInspectorTypeInfoClass(GsvTypesInfo.Objects[i]);
end;

// ��������������� ������� - �������� ��� �� ����� � ���������� True ����
// ��� ���������� � False ���� ��� �������
function GsvGetBit(Value: LongInt; Bit: Integer): Boolean;
begin
  if (Bit >= 0) and (Bit < 32) then
    Result := (Value and (1 shl Bit)) <> 0
  else
    Result := False;
end;

// ��������� �������� ���� �� ���������������
function GsvChangeBit(Value: LongInt; Bit: Integer): LongInt;
begin
  if (Bit >= 0) and (Bit < 32) then
    Result := Value xor (1 shl Bit)
  else
    Result := Value;
end;

// ��������� �������������� �������� �� ������ RTTI
function GsvGetIntegerProperty(Info: PGsvObjectInspectorPropertyInfo):
  LongInt;
var
  obj: TObject;
  nm:  String;
begin
  Result := 0;
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then
    Exit;
  Result := GsvGetIntegerProperty(obj, nm);
end;

function GsvGetIntegerProperty(aObject: TObject; const aName: string): LongInt;
begin
  Result := 0;
  case PropType(aObject, aName) of
    tkInteger,
    tkEnumeration,
    tkSet,
    tkChar:
      Result := GetOrdProp(aObject, aName);
  end;
end;

// ��������� �������������� �������� �� ������ RTTI
procedure GsvSetIntegerProperty(Info: PGsvObjectInspectorPropertyInfo;
  const Value: LongInt);
var
  obj: TObject;
  nm:  String;
begin
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then
    Exit;
  GsvSetIntegerProperty(obj, nm, Value);
end;

procedure GsvSetIntegerProperty(aObject: TObject; const aName: string;
  const Value: LongInt);
begin
  case PropType(aObject, aName) of
    tkInteger,
    tkEnumeration,
    tkSet,
    tkChar:
      SetOrdProp(aObject, aName, Value);
  end;
end;

// ��������� ���������� �������� �� ������ RTTI
function GsvGetStringProperty(Info: PGsvObjectInspectorPropertyInfo):
  String;
var
  obj: TObject;
  nm:  String;
begin
  Result := '';
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then
    Exit;
  case PropType(obj, nm) of
    tkString,
    tkLString:
      Result := GetStrProp(obj, nm);
  end;
end;

function GsvGetStringProperty(aObject: TObject;
  const aName: string; aNestedClass: TGsvObjectInspectorTypeInfoClass): string;
begin
  Result := '';
  // ���� ��� �������� ��������� ��������� �����, �� �������������� � ������
  // ����������� ��, ����� ������������ ����������� ��������������
  case PropType(aObject, aName) of
    tkInteger,
    tkEnumeration,
    tkSet:
      if Assigned(aNestedClass) then
        Result := aNestedClass.IntegerToString(GetOrdProp(aObject, aName))
      else
        Result := TGsvObjectInspectorTypeInfo.IntegerToString(
                    GetOrdProp(aObject, aName));
    tkChar:
      if Assigned(aNestedClass) then
        Result := aNestedClass.CharToString(Char(GetOrdProp(aObject, aName)))
      else
        Result := TGsvObjectInspectorTypeInfo.CharToString(
                    Char(GetOrdProp(aObject, aName)));
    tkFloat:
      if Assigned(aNestedClass) then
        Result := aNestedClass.FloatToString(GetFloatProp(aObject, aName))
      else
        Result := TGsvObjectInspectorTypeInfo.FloatToString(
                    GetFloatProp(aObject, aName));
    tkString,
    tkLString:
      Result := GetStrProp(aObject, aName);
    tkClass:
      if Assigned(aNestedClass) then
        Result := aNestedClass.ObjectToString(GetObjectProp(aObject, aName));
  end;
end;

// ��������� ���������� �������� �� ������ RTTI
procedure GsvSetStringProperty(Info: PGsvObjectInspectorPropertyInfo;
  const Value: String);
var
  obj: TObject;
  nm:  String;
begin
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then
    Exit;
  case PropType(obj, nm) of
    tkString,
    tkLString:
      SetStrProp(obj, nm, Value);
  end;
end;

procedure GsvSetStringProperty(aObject: TObject; const aName, Value: string;
  aNestedClass: TGsvObjectInspectorTypeInfoClass);
begin
  // ���� ��� �������� ��������� ��������� �����, �� �������������� �� ������
  // ����������� ��, ����� ������������ ����������� ��������������
  case PropType(aObject, aName) of
    tkInteger,
    tkEnumeration,
    tkSet:
      if Assigned(aNestedClass) then
        SetOrdProp(aObject, aName, aNestedClass.StringToInteger(Value))
      else
        SetOrdProp(aObject, aName,
          TGsvObjectInspectorTypeInfo.StringToInteger(Value));
    tkChar:
      if Assigned(aNestedClass) then
        SetOrdProp(aObject, aName, Ord(aNestedClass.StringToChar(Value)))
      else
        SetOrdProp(aObject, aName, Ord(
          TGsvObjectInspectorTypeInfo.StringToChar(Value)));
    tkFloat:
      if Assigned(aNestedClass) then
        SetFloatProp(aObject, aName, aNestedClass.StringToFloat(Value))
      else
        SetFloatProp(aObject, aName,
          TGsvObjectInspectorTypeInfo.StringToFloat(Value));
    tkString,
    tkLString:
      SetStrProp(aObject, aName, Value);
  end;
end;

{ TGsvObjectInspectorTypeInfo }

// ��������� ����� �������
class function TGsvObjectInspectorTypeInfo.ObjectName(
  AObject: TObject): String;
begin
  Result := '';
  if Assigned(AObject) then
    if AObject is TComponent then
      Result := TComponent(AObject).Name;
end;

// ��������� �������� ����
class function TGsvObjectInspectorTypeInfo.TypeName: String;
begin
  Result := '';
end;

// ��������� ���������� � ����, ��� � ��������. ���� � ������������ ��������
// �����-�� ���� �������� �� ����������, �� ������������ ���������������
// ���� ���������� �������
class function TGsvObjectInspectorTypeInfo.TypeInfo:
  PGsvObjectInspectorPropertyInfo;
const
  DSK: TGsvObjectInspectorPropertyInfo = ( );
begin
  Result := @DSK;
end;

// ������� ��������� ����������� �������� �� ��� �������. ������������ ���
// CallBack-������� ������� �������������� �������. ���� �������� � �����
// �������� �����������, �� ������� ���������� nil, � ����� �������
// ���������� ��������� �� ��������� ����������� �������� � �������� ��������.
class function TGsvObjectInspectorTypeInfo.ChildrenInfo(Index: Integer)
  : PGsvObjectInspectorPropertyInfo;
begin
  Result := nil;
end;

// ������ ��������� - ��������� ������������ ������ ��������, ���������������
// �������� ������� � ��������� ������
class procedure TGsvObjectInspectorTypeInfo.FillList(
  Info: PGsvObjectInspectorPropertyInfo; List: TStrings);
begin
end;

// ������ ��������� - ������� ������ ��� ��������� �������� ��������
class procedure TGsvObjectInspectorTypeInfo.ShowDialog(Inspector: TComponent;
  Info: PGsvObjectInspectorPropertyInfo; const EditRect: TRect);
begin
end;

// ������� ������ ������������� ������������� �������� � ������
class function TGsvObjectInspectorTypeInfo.IntegerToString(
  const Value: LongInt): String;
begin
  Result := IntToStr(Value);
end;

// ������� ������ ������������� ��������� �������� � �������������. ����
// �������������� ����������, �� ������� ������ ���������� ����������
class function TGsvObjectInspectorTypeInfo.StringToInteger(
  const Value: String): LongInt;
begin
  Result := StrToInt(Value);
end;

// ������� ������ ������� ��������� ��������� ��������, �������
// �������� ����� ������������� ������ �������
class function TGsvObjectInspectorTypeInfo.CharToString(
  const Value: Char): String;
begin
  if Value >= #33 then
    Result := Value
  else
    Result := Format('#%d', [Ord(Value)]);
end;

class function TGsvObjectInspectorTypeInfo.StringToChar(
  const Value: String): Char;

  function RightStr(const AText: String; const ACount: Integer): String;
  begin
    Result := Copy(AText, Length(AText) + 1 - ACount, ACount);
  end;

var
  len: Integer;
begin
  len := Length(Value);
  if len = 0 then
    Result := #0
  else if Value[1] <> '#' then
    Result := Value[1]
  else if len = 1 then
    Result := '#'
  else
    Result := Char(StrToInt(RightStr(Value, len - 1)));
end;

class function TGsvObjectInspectorTypeInfo.FloatToString(
  const Value: Extended): String;
begin
  Result := Format('%g', [Value]);
end;

class function TGsvObjectInspectorTypeInfo.StringToFloat(
  const Value: String): Extended;
begin
  Result := StrToFloat(Value);
end;

class function TGsvObjectInspectorTypeInfo.ObjectToString(
  const Value: TObject): String;
begin
  Result := '';
end;


{ TGsvObjectInspectorTypeListInfo }

// � ����������� ������ ������� ������ ������� ��������� �������
// ���� PGsvObjectInspectorListItem, ����������� ��� � �������� ��������
// ������-������������ � ����������� �� ��� �������. ���� ��� ��������
// �����������, �� ������� ���������� nil
class function TGsvObjectInspectorTypeListInfo.ListEnumItems(
  Index: Integer): PGsvObjectInspectorListItem;
begin
  Result := nil;
end;

class procedure TGsvObjectInspectorTypeListInfo.FillList(
  Info: PGsvObjectInspectorPropertyInfo;
  List: TStrings);
var
  i: Integer;
  p: PGsvObjectInspectorListItem;
begin
  i := 0;
  p := ListEnumItems(0);
  while Assigned(p) do begin
    List.AddObject(p^.Name, TObject(p^.Data));
    Inc(i);
    p := ListEnumItems(i);
  end;
end;

class function TGsvObjectInspectorTypeListInfo.IntegerToString(
  const Value: Integer): String;
var
  i: Integer;
  p: PGsvObjectInspectorListItem;
begin
  Result := '';
  i      := 0;
  p      := ListEnumItems(0);
  while Assigned(p) do begin
    if p^.Data = Value then begin
      Result := p^.Name;
      Break;
    end;
    Inc(i);
    p := ListEnumItems(i);
  end;
end;

class function TGsvObjectInspectorTypeListInfo.StringToInteger(
  const Value: String): LongInt;
var
  i: Integer;
  p: PGsvObjectInspectorListItem;
begin
  Result := 0;
  i      := 0;
  p      := ListEnumItems(0);
  while Assigned(p) do begin
    if p^.Name = Value then begin
      Result := p^.Data;
      Break;
    end;
    Inc(i);
    p := ListEnumItems(i);
  end;
end;


{ TGsvObjectInspectorTypeSetInfo }

class function TGsvObjectInspectorTypeSetInfo.IntegerToString(
  const Value: LongInt): String;
var
  i: Integer;
  p: PGsvObjectInspectorPropertyInfo;
begin
  Result := '';
  i      := 0;
  p      := ChildrenInfo(0);
  while Assigned(p) do begin
    if p^.Kind = pkBoolean then begin
      if GsvGetBit(Value, p^.Tag) then begin
        if Result <> '' then
          Result := Result + ', ';
        Result := Result + p^.Caption;
      end;
    end;
    Inc(i);
    p := ChildrenInfo(i);
  end;
end;

{ TGsvObjectInspectorTypeFontInfo }

class procedure TGsvObjectInspectorTypeFontInfo.ShowDialog(Inspector: TComponent;
  Info: PGsvObjectInspectorPropertyInfo; const EditRect: TRect);
var
  dlg: TFontDialog;
  fnt: TFont;
begin
  if not Assigned(Info) then
    Exit;
  if not Assigned(Info^.NestedObject) then
    Exit;
  if not (Info^.NestedObject is TFont) then
    Exit;
  fnt := TFont(Info^.NestedObject);
  dlg := TFontDialog.Create(Inspector);
  try
    dlg.Font.Assign(fnt);
    if dlg.Execute then
      fnt.Assign(dlg.Font);
  finally
    dlg.Free;
  end;
end;

class function TGsvObjectInspectorTypeFontInfo.ObjectToString(
  const Value: TObject): String;
begin
  Result := '';
  if Assigned(Value) then
    if Value is TFont then
      with TFont(Value) do
        Result := Format('%s, %d', [Name, Size]);
end;


{ TGsvObjectInspectorTypeColorRGBInfo }

class procedure TGsvObjectInspectorTypeColorRGBInfo.ConvertError(
  const Value: String);
begin
  raise EConvertError.CreateResFmt(@SINVALID_COLOR_VALUE, [Value]);
end;

class procedure TGsvObjectInspectorTypeColorRGBInfo.ShowDialog(
  Inspector: TComponent; Info: PGsvObjectInspectorPropertyInfo;
  const EditRect: TRect);
const
  CC: array[0..15] of String = (
    {Black}   'ColorA=000000',
    {Maroon}  'ColorB=000080',
    {Green}   'ColorC=008000',
    {Olive}   'ColorD=008080',
    {Navy}    'ColorE=800000',
    {Purple}  'ColorF=800080',
    {Teal}    'ColorG=808000',
    {Gray}    'ColorH=808080',
    {Silver}  'ColorI=C0C0C0',
    {Red}     'ColorJ=0000FF',
    {Lime}    'ColorK=00FF00',
    {Yellow}  'ColorL=00FFFF',
    {Blue}    'ColorM=FF0000',
    {Fuchsia} 'ColorN=FF00FF',
    {Aqua}    'ColorO=FFFF00',
    {White}   'ColorP=FFFFFF'
  );
var
  dlg: TColorDialog;
  i:   Integer;
begin
  if not Assigned(Info) then
    Exit;
  dlg := TColorDialog.Create(Inspector);
  try
    dlg.Color   := GsvGetIntegerProperty(Info);
    dlg.Options := dlg.Options + [cdFullOpen];
    for i := 0 to High(CC) do
      dlg.CustomColors.Add(CC[i]);
    if dlg.Execute then
      GsvSetIntegerProperty(Info, dlg.Color);
  finally
    dlg.Free;
  end;
end;

class function TGsvObjectInspectorTypeColorRGBInfo.IntegerToString(
  const Value: Integer): String;
begin
  Result := Format('%d.%d.%d', [Value and $FF, (Value shr 8) and $FF,
            (Value shr 16) and $FF]);
end;

class function TGsvObjectInspectorTypeColorRGBInfo.StringToInteger(
  const Value: String): LongInt;
var
  ci:      array[0..2] of Byte;
  ps, len: Integer;

  function ConvNumber: Integer;
  var
    c: Char;
  begin
    Result := 0;
    if ps > len then
      ConvertError(Value);
    while ps <= len do begin
      c := Value[ps];
      if c in ['.', ',', '/', '\', ';', ':', '-', '_', ' '] then begin
        Inc(ps);
        Break;
      end;
      if c in ['0'..'9'] then
        Result := Result * 10 + (Ord(c) - Ord('0'))
      else
        Break;
      Inc(ps);
    end;
    if Result > 255 then
      ConvertError(Value);
  end;

begin
  ps  := 1;
  len := Length(Value);
  if len < 5 then
    ConvertError(Value);
  ci[0]  := Byte(ConvNumber);
  ci[1]  := Byte(ConvNumber);
  ci[2]  := Byte(ConvNumber);
  Result := RGB(ci[0], ci[1], ci[2]);
  if ps <> (len + 1) then
    ConvertError(Value);
end;

{ TGsvObjectInspectorObjectInfo }

constructor TGsvObjectInspectorObjectInfo.Create;
begin
  SetLength(FLevelInfo, 8);
end;

destructor TGsvObjectInspectorObjectInfo.Destroy;
begin
  FLevelInfo := nil;
  inherited;
end;

function TGsvObjectInspectorObjectInfo.GetObject: TObject;
begin
  Result := FObject;
end;

procedure TGsvObjectInspectorObjectInfo.SetObject(const Value: TObject);
begin
  if FObject <> Value then begin
    FObject   := nil;
    FTypeInfo := nil;
    if Assigned(Value) then begin
      FTypeInfo := GsvFindTypeInfo(Value.ClassName);
      if Assigned(FTypeInfo) then
        FObject := Value;
    end;
  end;
end;

// ��������� ����� �������, ���� � ���������� ���� ������� ��� ��������,
// ����� ������� ����� �������� ��� �������
function TGsvObjectInspectorObjectInfo.ObjectName: String;
begin
  if Assigned(FTypeInfo) then Result := FTypeInfo.ObjectName(FObject)
  else                        Result := '';
end;

// ��������� �������� ���� �������
function TGsvObjectInspectorObjectInfo.ObjectTypeName: String;
begin
  if Assigned(FTypeInfo) then Result := FTypeInfo.TypeName
  else                        Result := '';
end;

// ��������� ������� ������� �� �������� ������� ����
function TGsvObjectInspectorObjectInfo.ObjectHelp: Integer;
var
  p: PGsvObjectInspectorPropertyInfo;
begin
  Result := 0;
  if Assigned(FTypeInfo) then begin
    p := FTypeInfo.TypeInfo;
    if Assigned(p) then
      Result := p^.Help;
  end;
end;

// ��������� ��������� �� �������� ������� ����
function TGsvObjectInspectorObjectInfo.ObjectHint: String;
var
  p: PGsvObjectInspectorPropertyInfo;
begin
  Result := '';
  if Assigned(FTypeInfo) then begin
    p := FTypeInfo.TypeInfo;
    if Assigned(p) then
      Result := p^.Hint;
  end;
end;

// ��������� ����������� �������� �� �������
function TGsvObjectInspectorObjectInfo.PropertyInfo(Index: Integer):
  PGsvObjectInspectorPropertyInfo;
var
  p, pc: PGsvObjectInspectorPropertyInfo;
  obj:   TObject;
begin
  Result := nil;

  // ������������� �������� �� ���� ��������� �������
  if Index = 0 then begin
    if not Assigned(FObject) then
      Exit;
    FLevel                  := 0;
    FLevelInfo[0].TheObject := FObject;
    FLevelInfo[0].Info      := FTypeInfo;
    FLevelInfo[0].Index     := 0;
  end;
  if not Assigned(FLevelInfo[FLevel].TheObject) then
    Exit;
  if not Assigned(FLevelInfo[FLevel].Info) then
    Exit;

  while True do begin
    // �������� ���������� �������� �������� � �������������� ������ ���
    // ������� � ���������� �����������
    p := FLevelInfo[FLevel].Info.ChildrenInfo(FLevelInfo[FLevel].Index);
    Inc(FLevelInfo[FLevel].Index);
    if not Assigned(p) then begin
      // ������� ������ ���, ����������� �������
      if FLevel = 0 then begin
        // ������� ������ ���, ����������� ������������
        Exit;
      end
      else begin
        // ��������� �� ���������� ������� � ������������ ��� ��������� ��������
        Dec(FLevel);
        Continue;
      end;
    end;

    // �������� ���� �������� � �������� ����� � ��������� ������������ ����
    FResultInfo              := p^;
    FResultInfo.Level        := FLevel;
    FResultInfo.TheObject    := FLevelInfo[FLevel].TheObject;
    FResultInfo.NestedObject := FLevelInfo[FLevel].TheObject;

    // �������������� ��������� ����� �� ����� ��� ����
    if p^.NestedType <> '' then begin
      FResultInfo.NestedClass := GsvFindTypeInfo(p^.NestedType);
      if not Assigned(FResultInfo.NestedClass) then begin
        // ���������� � ���� ���������� �������� �� �������, ���������� ���
        // � ��������� � ���������� ��������
        Continue;
      end;
    end;

    if not Assigned(FResultInfo.NestedClass) then begin // ������� ��������
      if FResultInfo.Kind = pkNone then begin
        // ��� �������� �� ���������, ���������� ��� � ��������� �
        // ���������� ��������
        Continue;
      end;
      // ���������� ����������� ���������� �������� � �������
      Result := @FResultInfo;
      Exit;
    end
    else begin // ��������, ������� ��������� ��������
      // ������������ ������������� ����� ������� �, ��� �������������,
      // ���������� ���������� �� ���������� ������� (���� ��� ����)
      pc := FResultInfo.NestedClass.TypeInfo;
      if Assigned(pc) then begin
        if p^.Caption = '' then
          FResultInfo.Caption := pc^.Caption;
        if p^.Kind = pkNone then
          FResultInfo.Kind := pc^.Kind;
        if p^.Help = 0 then
          FResultInfo.Help := pc^.Help;
        if p^.Hint = '' then
          FResultInfo.Hint := pc^.Hint;
      end;
      if FResultInfo.Kind = pkNone then begin
        // ��� �������� �� ���������, ���������� ��� � ��������� �
        // ���������� ��������
        Continue;
      end;
      // ���������� ��������� �� ��������� ������
      obj := FLevelInfo[FLevel].TheObject;
      if p^.Name <> '' then begin
        // ���� ��������� �������� - �����, �� ���������� ������ ����� ������
        try
          if PropType(obj, p^.Name) = tkClass then begin
            try
              obj := GetObjectProp(obj, p^.Name);
              FResultInfo.NestedObject := obj;
            except
              obj := nil;
            end;
          end;
        except
        end;
      end;
      if not Assigned(obj) then begin
        // ��������� ������ �� ������, ���������� ��� � ��������� �
        // ���������� �������� �������� �������
        Continue;
      end;
      // ���� ��������� �������� ����, �� ������ ���������� ��� ��������
      // �� ��������� �������
      if FResultInfo.NestedClass.ChildrenInfo(0) <> nil then begin
        Inc(FLevel);
        if FLevel > High(FLevelInfo) then
          SetLength(FLevelInfo, Length(FLevelInfo) + 8);
        FLevelInfo[FLevel].TheObject := obj;
        FLevelInfo[FLevel].Info      := FResultInfo.NestedClass;
        FLevelInfo[FLevel].Index     := 0;
      end;
      // ���������� ����������� ���������� �������� � �������
      Result := @FResultInfo;
      Exit;
    end;
  end;
end;

procedure TGsvObjectInspectorObjectInfo.FillList(
  Info: PGsvObjectInspectorPropertyInfo; List: TStrings);
var
  cls: TGsvObjectInspectorTypeInfoClass;
begin
  if not Assigned(Info) then
    Exit;
  cls := Info^.NestedClass;
  if Assigned(cls) then
    cls.FillList(Info, List);
end;

procedure TGsvObjectInspectorObjectInfo.ShowDialog(Inspector: TComponent;
  Info: PGsvObjectInspectorPropertyInfo; const EditRect: TRect);
begin
  if not Assigned(Info) then
    Exit;
  if not Assigned(Info^.NestedClass) then
    Exit;
  Info^.NestedClass.ShowDialog(Inspector, Info, EditRect);
end;

// ��������� ���������� ������������� �������� ����� RTTI
function TGsvObjectInspectorObjectInfo.GetStringValue(
  Info: PGsvObjectInspectorPropertyInfo): String;
var
  obj: TObject;
  nm:  String;
begin
  Result := '';
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then begin
    Result := SERROR;
    Exit;
  end;
  try
    Result := GsvGetStringProperty(obj, nm, Info^.NestedClass);
  except
    Result := SERROR;
  end;
end;

// ��������� �������� ����� RTTI �� ������ ��� ���������� �������������
procedure TGsvObjectInspectorObjectInfo.SetStringValue(
  Info: PGsvObjectInspectorPropertyInfo; const Value: String);
var
  obj: TObject;
  nm:  String;
begin
  if not Assigned(Info) then
    Exit;
  obj := Info^.TheObject;
  if not Assigned(obj) then
    Exit;
  nm := Info^.Name;
  if nm = '' then
    Exit;
  GsvSetStringProperty(obj, nm, Value, Info^.NestedClass);
end;

// ��������� �������������� ������������� �������� ����� RTTI
function TGsvObjectInspectorObjectInfo.GetIntegerValue(
  Info: PGsvObjectInspectorPropertyInfo): LongInt;
begin
  Result := GsvGetIntegerProperty(Info);
end;

// ��������� �������� ����� RTTI �� ������ ��� �������������� �������������
procedure TGsvObjectInspectorObjectInfo.SetIntegerValue(
  Info: PGsvObjectInspectorPropertyInfo; const Value: LongInt);
begin
  GsvSetIntegerProperty(Info, Value);
end;

end.
