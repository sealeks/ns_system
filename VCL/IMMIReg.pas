unit IMMIReg;

interface

uses Windows, Classes, Graphics, Forms, Controls, Buttons, DesignIntf, DesignEditors,
  DesignWindows, StdCtrls, ComCtrls, TypInfo,ConstDef,IMMILabelRotateU,Line, TClockU,IMMIformx,
  UnitExpr,ActBoolExpr,TmyStringListFormU,
  IMMIAlarmTriangle,
  IMMIArmatVl,IMMIImggif,
  IMMIArmatBm,
  IMMIImg, AppImmi,
  IMMILabelFullU,
  IMMIShape, IMMIShapeImg,
  IMMIImg1, IMMIPropertysEditorU,
  IMMIEditReal,Imit, ImitEditFrm,
  IMMITrackBar,
  IMMIRegul,
  IMMISpeedButton, IMMIBitBtn,
  IMMITube,
  IMMIValueEntryU, PropTubeColorU,
  IMMIPanelU, IMMIGroupBoxU,
  ImmiSyButton,ImmiButtonXp, FormManager, RedacOCForm, Jurnal;

type
TJurnalEditor = class(TComponentEditor)
public
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
end;

TImitEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIAlTrgEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMILabelEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;


  TIMMIArmatVlEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

     TIMMIPanelEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIArmatBmEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIImgEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIImg1Editor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIShapeEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIEditEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMITrackBEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIRegulEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMISpeedBtnEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMITubeEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TIMMIValueEntryEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

 TIMMITubeColor = class(TClassProperty)
  public
   function AllEqual: Boolean; override;
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
  end;

  TIMMIExprStringProperty = class(TStringProperty)
  public
   function AllEqual: Boolean; override;
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
  end;

   TIMMIFormManagerProperty = class(TClassProperty)
  public
   function AllEqual: Boolean; override;
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
  end;

   TMyStringListProperty = class(TClassProperty)
  public
   function AllEqual: Boolean; override;
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
  end;

procedure Register;
function CompeareTubeCol(s1: TTubeColors;s2: TTubeColors): boolean;
function CompeareFormmanager(s1: TFormManager;s2: TFormManager): boolean;

implementation

uses SysUtils;

{ TJurnalEditor }


procedure TIMMIPanelEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    if (component is TIMMIPanel) then
      (Component as TIMMIPanel).ShowPropForm;
    if (component is TIMMIGroupBox) then
      (Component as TIMMIGroupBox).ShowPropForm;
  end;
end;

function TIMMIPanelEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIPanelEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TJurnalEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  if Index = 0 then begin
    (Component as TJurnal).ShowPropForm;
    Designer.Modified;
  end;
end;

function TJurnalEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TJurnalEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIAlTrgEditor

procedure TIMMIAlTrgEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIAlarmTriangle).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIAlTrgEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIAlTrgEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMILabelEditor

procedure TIMMILabelEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
  if (Component is TIMMILabelFull) then
    (Component as TIMMILabelFull).ShowPropForm;
   if (Component is  TIMMILabelRotate) then
    (Component as  TIMMILabelRotate).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMILabelEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMILabelEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIArmatVlEditor

procedure TIMMIArmatVlEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIArmatVl).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIArmatVlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIArmatVlEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIArmatBmEditor

procedure TIMMIArmatBmEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIArmatBm).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIArmatBmEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIArmatBmEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIImgEditor

procedure TIMMIImgEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIImg).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIImgEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIImgEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIImg1Editor

procedure TIMMIImg1Editor.ExecuteVerb(Index: Integer);
begin
  inherited;
  if Index = 0 then begin
    if Component is TIMMIImg1 then (Component as TIMMIImg1).ShowPropForm(Designer.root);
    if Component is TIMMIImggif  then (Component as TIMMIImggif).ShowPropForm(Designer.root);
    Designer.Modified;
  end;
end;

function TIMMIImg1Editor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIImg1Editor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIImgShape

procedure TIMMIShapeEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIShape).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIShapeEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIShapeEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIEditEditor

procedure TIMMIEditEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIEditReal).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIEditEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIEditEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMITrackBEditor

procedure TIMMITrackBEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMITrackBar).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMITrackBEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMITrackBEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIRegulEditor

procedure TIMMIRegulEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    (Component as TIMMIRegul).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIRegulEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIRegulEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


// TIMMISpeedBtnEditor

procedure TIMMISpeedBtnEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    if (component is TIMMISpeedButton) then
      (Component as TIMMISpeedButton).ShowPropForm(TComponent(Designer.Root));
    if (component is TIMMIBitBtn) then
      (Component as TIMMIBitBtn).ShowPropForm(TComponent(Designer.Root));
    if (component is TImmibuttonXp) then
     (Component as TImmibuttonXp).ShowPropForm(TComponent(Designer.Root));
   if (component is TImmiSybutton) then
     (Component as TImmiSybutton).ShowPropForm(TComponent(Designer.Root));
    Designer.Modified;
  end;
end;

function TIMMISpeedBtnEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMISpeedBtnEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMITubeEditor

procedure TIMMITubeEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    if (component is TIMMITube) then
      (Component as TIMMITube).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMITubeEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMITubeEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

// TIMMIValueEntryEditor

procedure TIMMIValueEntryEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    if (component is TIMMIValueEntry) then
      (Component as TIMMIValueEntry).ShowPropForm;
    Designer.Modified;
  end;
end;

function TIMMIValueEntryEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TIMMIValueEntryEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

function TIMMITubeColor.GetAttributes: TPropertyAttributes;
begin
   result:=inherited GetAttributes + [paDialog];
end;

procedure TIMMITubeColor.Edit;
var  PropT: TPropTubeColor;
     Colors : TTubeColors;
     i: integer;
begin
  try
    Colors :=TTubeColors.Create;
    PropT:=TPropTubeColor.Create(Application);
    if AllEqual then TTubeColors(GetordValue).Assign(colors);
    if PropT.Execute(colors) then
      begin
       if colors<>nil then
       begin
       colors.calcColCount;
       for i:=0 to PropCount-1 do
       colors.Assign(TTubeColors(getordValueat(i)));
       end;


      end;
    Designer.Modified;
  finally
    PropT.Free;
     Colors.Free;
  end;
end;

function TIMMITubeColor.AllEqual: Boolean;
var i: integer;
begin
result:=false;
 for I:=1 to PropCount-1 do
         if  not CompeareTubeCol(TTubeColors(getordValueat(0)),
         TTubeColors(getordValueat(i))) then exit;
result:=true;
end;

function TIMMIExprStringProperty.GetAttributes: TPropertyAttributes;
begin
   result:=inherited GetAttributes + [paDialog];
end;

procedure TIMMIExprStringProperty.Edit;
var  PropT: TFormExpr;
     expS : string;
     i: integer;
begin
  try

    PropT:=TFormExpr.Create(Application);
    if AllEqual then expS:=getstrvalue;
    if PropT.Execute(expS) then
      begin
          SetStrValue(Exps);
       end;
     Designer.Modified;
  finally
    PropT.Free;

  end;
end;

function TIMMIExprStringProperty.AllEqual: Boolean;
var i: integer;
begin
result:=false;
 
 for I:=1 to PropCount-1 do
         if  (getstrValueat(0)<>getstrValueat(i)) then exit;
result:=true;
end;


function TIMMIFormManagerProperty.GetAttributes: TPropertyAttributes;
begin
   result:=inherited GetAttributes + [paDialog];
end;

function TIMMIFormManagerProperty.AllEqual: Boolean;
var i: integer;
begin
result:=false;
for I:=1 to PropCount-1 do
         if  not CompeareFormManager(TFormManager(getordValueat(0)),
         TFormManager(getordValueat(i))) then exit;
result:=true;
end;

procedure TIMMIFormManagerProperty.Edit;
var  PropT: TOKBottomDlgForm;
     FormMan : TFormManager;
     i: integer;
begin
  try
    FormMan:=TFormManager.Create(nil);
    PropT:=TOKBottomDlgForm.Create(Application);
    if AllEqual then FormMan.Assign(TFormManager(GetordValue));
    PropT.Execute(Designer.Root,FormMan);
       if FormMan<>nil then
       for i:=0 to PropCount-1 do
       (TFormManager(getordValueat(i))).Assign(FormMan);
    Designer.Modified;
  finally
    PropT.Free;
     FormMan.Free;
  end;
end;


function TMyStringListProperty.GetAttributes: TPropertyAttributes;
begin
   result:=inherited GetAttributes + [paDialog];
end;

function TMyStringListProperty.AllEqual: Boolean;
var i: integer;
begin

result:=false;
for I:=1 to PropCount-1 do
         if  (TStringList(getordValueat(0)).Text<>
         TStringList(getordValueat(i)).Text) then exit;
result:=true;
end;

procedure TMyStringListProperty.Edit;
var  PropT: TmyStringList;
     tempval: TstringList;
     i: integer;
begin
  try
    tempval:=TstringList.Create;
    PropT:=TmyStringList.Create(Application);
    tempval.Clear;
    tempval.Text:=TStringList(GetordValueat(0)).Text;
    if PropT.Execute(tempval) then
      begin

       for i:=0 to PropCount-1 do
         TStringList(getordValueat(i)).text:= tempval.text;
      Designer.Modified;
      end;
  finally
    PropT.Free;
    tempval.Free;
  end;
end;

procedure TImitEditor.ExecuteVerb(Index: Integer);
begin
  if Index = 0 then begin
    if (component is TImit) then
      (Component as TImit).ShowPropForm;
    Designer.Modified;
  end;
end;

function TImitEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Properties';
  end;
end;

function TImitEditor.GetVerbCount: Integer;
begin
  result := 1;
end;

 function CompeareTubeCol(s1: TTubeColors;s2: TTubeColors): boolean;
 var i: integer;
begin
result:=false;
if (not assigned(s1) or not assigned(s2))  then exit;
for i:=1 to 15 do
  if s1.Colors[i]<>s2.Colors[i] then exit;
  if s1.Count<>s2.Count then  exit;
 result:=true;
end;


function CompeareFormmanager(s1: TFormManager;s2: TFormManager): boolean;
 var i: integer;
begin
result:=false;
if (not assigned(s1) or not assigned(s2))  then exit;
if s1.OpenForm.Count<>s2.OpenForm.Count then exit;
for i:=0 to s1.OpenForm.Count-1 do
   if s1.OpenForm.Strings[i]<>s1.OpenForm.Strings[i] then exit;
if s1.CloseForm.Count<>s2.CloseForm.Count then exit;
for i:=0 to s1.CloseForm.Count-1 do
   if s1.CloseForm.Strings[i]<>s1.CloseForm.Strings[i] then exit;
if s1.ShowMod<>s1.ShowMod then exit;
result:=true;
end;



procedure Register;
begin
  RegisterComponents('IMMIImg', [TIMMIAlarmTriangle,
                                TIMMIArmatVl, TIMMIArmatBm,
                                TIMMIShape, {TIMMIImageList,  }
                                TIMMIImg1,  TIMMIImggif,
                                TIMMITube
                               ]);
   RegisterComponents('IMMAction', [TActExpr,TAppExpr,TScriptTimer,TIMMIFormExt,TApplicationImmi]);
  RegisterComponents('IMMIIndicator', [TIMMILabelFull,TIMMILabelRotate,TTClockLabelU
                               ]);
  RegisterComponents('IMMISample', [TLine,
                                TIMMIPanel,
                                TIMMIGroupBox]);
  RegisterComponents('IMMIService', [TIMMIShapeForm]);
  RegisterComponentEditor(TIMMIAlarmTriangle, TIMMIAlTrgEditor);
  RegisterComponentEditor(TIMMIArmatVl, TIMMIArmatVlEditor);
  RegisterComponentEditor(TIMMIArmatBm, TIMMIArmatBmEditor);
  RegisterComponentEditor(TIMMILabelFull, TIMMILabelEditor);

   RegisterComponentEditor( TIMMILabelRotate, TIMMILabelEditor);
  RegisterComponentEditor(TIMMIImg1, TIMMIImg1Editor);
   RegisterComponentEditor(TIMMIImggif, TIMMIImg1Editor);
  RegisterComponentEditor(TIMMIShape, TIMMIShapeEditor);
  RegisterComponentEditor(TIMMITube, TIMMITubeEditor);
  RegisterComponents('IMMICtrls', [TIMMITrackBar, TimmiUpDown,
                                        TIMMIRegul, TIMMISpeedButton,
                                        TIMMIBitBtn, TIMMIValueEntry, TImmiSyButton,TImmibuttonXp]);
  RegisterComponentEditor(TIMMIEditReal, TIMMIEditEditor);
  RegisterComponentEditor(TIMMITrackBar, TIMMITrackBEditor);
  RegisterComponentEditor(TIMMIRegul, TIMMIREGULEditor);
  RegisterComponentEditor(TIMMISpeedButton, TIMMISpeedBtnEditor);
  RegisterComponentEditor(TIMMIBitBtn, TIMMISpeedBtnEditor);
 // RegisterComponentEditor(TImit, TImitEditor);
  RegisterComponentEditor(TImmibuttonXp, TIMMISpeedBtnEditor);
   RegisterComponentEditor(TImmiSybutton, TIMMISpeedBtnEditor);
  RegisterComponentEditor(TIMMIValueEntry, TIMMIValueEntryEditor);
  RegisterPropertyEditor(TypeInfo(TTubeColors),TControl, '' ,TIMMITubeColor);
  RegisterPropertyEditor(TypeInfo(TExprStr),TObject, '' ,TIMMIExprStringProperty);
  RegisterPropertyEditor(TypeInfo(TFormManager),TObject, '' ,TIMMIFormManagerProperty);
 // RegisterComponents('System', [TPLCComPort]);
  RegisterComponents('IMMIIndicator', [TimmiLabelOperator]);
 // RegisterComponents('IMMIImit', [timit]);
  RegisterComponentEditor(TIMMIImg, TIMMIImgEditor);
  RegisterComponents('IMMIJurnal', [TJurnal]);
  RegisterComponentEditor(TJurnal, TJurnalEditor);
  RegisterComponents('IMMISample', [TTClockU]);
   RegisterComponentEditor(TImmiPanel, TIMMIPanelEditor);
  RegisterComponentEditor( TIMMIGroupBox, TIMMIPanelEditor);
 RegisterPropertyEditor(TypeInfo(TStringList),TObject, '' ,TMyStringListProperty);
  //RegisterComponents('IMMISample', []);
end;

end.
