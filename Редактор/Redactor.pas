unit Redactor;

interface

uses
  Windows,Graphics, Messages, SysUtils, Classes,Contnrs, AppEvnts, Controls, GlobalValue,
  Controlddh,Constdef,Types, Menus,StrUtils, Dialogs, ExtDlgs, ExtCtrls, Forms,Grids,
  Clipbrd,UnitPicture, ImageForm,UnitAlighn,UnitSized, UnitScale , ActiveX,PicEdit,ComCtrls,
  FormList,Projectdialog,OpenProject, ConFigForm,StdCtrls,memStructsU,FormFix,Expr,ObjInsp1,
  frmShowTegsU,Convert, DesignIntf ,inifiles,CheckLst, FormPackage,typInfo, DesignEditors,VCLEditors,
  ColorStringGrid,FormFindExprU,FormFindExprUerr{, ifps3, ifpiclassruntime},Appimmi;





 type
  MethName = ^string;
type
TRedactorState = set of (rProject,rForm, rNoActivForm);
type
TKeyBordState = set of (pCntrl, pShift, pAlt, pMouseLeftDown, pTube, pA ,pX ,pC ,pV,pDel);
type
TSistemState = set of (sPostDobleClick ,sMoved, sActive, sRedac, sDrag, sDragTwo, sSelect,sChangePar, sOnForm, sMOuseContIsWin,sCreateObj);


type mrthinf = record
  names: string;
  typeF: PTypeData;
  end;

type pmrthinf = ^mrthinf;

type
   TAmem = class (TAnalogMems)
   private
   fileStrings: MappedFile;
   public
    destructor Destroy; override;
      end;
type
  TIMMI = class of TControl;

type
  TIMMISc = class of TComponent;  

type
  TControlHack = class(TComponent);
type
  TControlMy = class(TControl);
type
  TFormMy = class(TForm);
type
  TFormCuMy = class(TCustomForm);

{type
  TIFPSExecHack = class (TIFPSExec) end;
  PScriptMethodInfo = ^TScriptMethodInfo;
  TScriptMethodInfo = record
    Se: TIFPSExecHack;
    ProcNo: Cardinal;
  end;  }

TSelectClass = class
  public
    StartSelect: TPoint;
    PresentSelect: TPoint;
    EndSelect: TPoint;
    BoolSelect: Boolean;
    constructor Create;
    function EndEqPres: boolean;
    function EndEqStart: boolean;
    procedure StartSelecting(point : TPoint);
  end;

type
  TUnitClass = class
    public
     TPClass: TClass;
     TPBitmap: TBitmap;
     TPEditor: TComponentEditorClass;
     constructor create(classp: TClass; bitmap: TBitmap{; editor: TComponentEditorclass});
     destructor destroy;
    end;


type
  SClassesList = class(Tstringlist)
  public
   procedure addClass(classp: TClass; bitmap: TBitmap);
   procedure Clear; override;
   destructor Destroy; override;
  end;

type
  SClassesPalete = class(Tstringlist)
  public
   procedure addClass(classp: TClass; bitmap: TBitmap;Heand: string);
   procedure addEditor(classp: TClass; editclassp: TComponentEditorClass);
   function findEditor(classp: TClass): TComponentEditorClass;
   function findBitmap(classp: TClass): TBitmap;
   procedure Clear; override;
   destructor Destroy; override;
  end;


TMyStringList = class (TStringList)
  public
    caseSensiv: boolean;
    constructor Create;
    function Add(const S: string): Integer;override;
    procedure Replase(from,into: String);
  end;

type
IMethNamePropertyOut = interface
   ['{67F4213C-B9E7-46F5-8665-71878C45166B}']
      function GetMPC: string;
      procedure SetMPC(val: string);
      property NameMPC: string read GetMPC write SetMPC;
end;

IMyNameProperty = interface
   ['{DAFB6CB2-D3C4-4271-93C5-89970D35C97B}']
     procedure RenemeCom (old: string; new: String);
end;

IImmiScriptDesigner = interface
   ['{AE7AEE10-9D28-428E-8952-A4019B5D83B5}']
     procedure CreateComp(comp: TComponent; IDesig: IDesignerSelections);
     procedure DeleteComp(comp: TComponent; IDesig: IDesignerSelections);
     procedure RenameComp(old: string; new: string; IDesig: IDesignerSelections);
     procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
     function  CreateMethod(const Name: string; TypeData: PTypeData; IDesig: IDesignerSelections): TMethod;
     function  MethodExists(const Name: string): Boolean;
     procedure RenameMethod(const CurName, NewName: string; IDesig: IDesignerSelections);
     procedure StartRedactor(name: string);
     procedure StartRedactorS;
     function SaveM: boolean;
      procedure InitMforDesigner(visibles: boolean; l: integer; t: integer; w: integer; h: integer;
     classlist: TList; appList: TList; IDesig: IDesignerSelections);
     procedure SelectChange;
     procedure getfsc(var visibles: boolean;var l, t, w, h: integer);
end;

TMyNamePropertyEditor = class(TComponentNameProperty)
  public
    procedure SetValue(const AValue: string); override;
  end;


type
  TRedactor = class(TApplicationEvents,IDesigner,IMyNameProperty,IDesignerSelections,IDesignerNotify,IDesignerHook,IExprstInt{, IMyMethodProperty},IMethNamePropertyIn,IMethNamePropertyOut)

  private
    fcopytrue:       boolean;
    numCreate:      Tclass;
    BeforeDrag:     TPoint;
    StartDDrag:     TPoint;
    Keybord:        TKeyBordState;
    System:         TSistemState;
   // ControlDDHList: TComponentList;
    SelectedCount:  integer;
    MouseControl:   TControl;
    DDHControl:     TControlddh;
    MustBeParent:    TWinControl;
    CurrentParent:  TWinControl;
    LisObj:          TList;
    PosisSelect:    TSelectClass;
    CreateClass:    TIMMI;
    fMPC: string;
    arrClass:       array of TClass;
    BinStream:      TMemoryStream;
    LastPoint:      TPoint;
    fCommandList:   TStringList;
    fCommentList:   TStringList;
    fDirProject:    string;
    FRedactorState: TRedactorState;
    fRedactorForm:  TList;
    fProjectBitmap: TBitmap;
    fTComList:      TList;
  //  fActivWind:     integer;
    ModuleList:     TStringList;
    fClassTree:     SClassesPalete;
    Opendialog1:    TOpendialog;
    classregister:  Tlist;
    editListC: Tlist;
    noiconbm:       TBitmap;
    ffl:            TList;
    fexprtrue:      boolean;
    ControlDDHList: TComponentList;
    MenuList:       TComponentList;
    classList:      TList;


    function fgetFormasList:    TList;
    procedure addForm(point: Pointer);

  protected
     TClassString: TStringList;
    procedure UpdateSelectionR;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);  //перехват сообщений
 //   procedure OprWindow(ClickPoint: Tpoint);                    //определяет контрол самый верхний под мышью
  //  procedure OprControlDDH(ClickPoint: Tpoint);                //возвращает в MouseControl под выделенным (если есть содержащиеся то его)
    procedure DelAllSel(MesBox: boolean);                       // Удаляет все выделенные элементы, с запросом и без
    procedure SetDr(ClickPoint: TPoint);                         // определение точки начала перетаскивания
    procedure MoveCont(MovePoint: TPoint);                       //перетаскивание всех объектов
    procedure PaintFocusRect(PointMove: TPoint);                 // процесс перетаскивания
    procedure DragStopToRect(PointEnd: TPoint);                  // конец перетаскивания
    procedure MoveContEnd(EndPoint: TPoint);
    procedure ChangeParent;                                       //если CurrentParent не совпадает c MustBeParent - разрушение всех выделений  CurrentParent=MustBeParent;
    procedure DDHContPaint;
    procedure SelectGrope(MovePoint: TPoint);
    procedure EndSelectGrope(EndPoint: TPoint);
    procedure RepaintAll;
    procedure GraphRect;
    function  EnterOfPos(CompCor: TControl; Lansc: TRect): boolean;     //CompCor лежит ли контрол в области Lansc
    function  ControlNoSelect(CompCor: TControl): boolean;              //выделен ли CompCor
    procedure MoveKey(up,down,left,right: integer);                     // сдвиг выделенных элементов
    procedure SizeKey(up,down,left,right: integer);                     // изменение размеров выделенных элементов
    function  CounObjClass(NameOb :ShortString): ShortString;           // определение уникального имени компонента
    function  asChildParent(Ch :TComponent; Par: TWinControl): TWincontrol;    // является ли Par родителем или родителем родителя (и. т. д.) Ch
    procedure SortOlder;
    function  IsRectControl(Rect: TRect): TRect;        //выдает смещение элемента если имеется конрол с теми же координатами
    procedure CreateObjIMMI(ClOb: TClass; CreatePoint: TPoint);
    procedure TubeBuild(up,down,left1,right: integer);
    function  AllOneParent: boolean;
    procedure changeScaleConr(Cont: Tcontrol;xsc: real; ysc: real);
    procedure scaleForm(Form: TForm;xsc: real; ysc: real);
    procedure SetActivWind(value: integer);
    procedure SetExprTrue(value: boolean);
    function GetMPC: string;
    procedure SetMPC(val: string);
     procedure RenemeCom (old: string; new: String);
  public
    {    IDesigner       }
     IdentStrings: TMyStringList;
    owners: Tcomponent;
    objIn:  TObjInsp1;
    ComboBox: TComboBox;
    editO: TEdit;
    CompTree: TTreeView;
    gridf: TColorStringGrid;
    actWind: TForm;
    lastactWind: TForm;
    CheckBoxForm: TCheckListBox;
    fMenu:          TPopupMenu;
    AppScript: IImmiScriptDesigner{TApplicationImmi};
    AppScriptPrep: TComponent;
   
    procedure DelCompSc(comp: tcomponent);
    function GetCustomForm: TCustomForm;
    procedure SetCustomForm(Value: TCustomForm);
    function GetIsControl: Boolean;
    procedure SetIsControl(Value: Boolean);
    function IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
    procedure PaintGrid;
    function GetScriptValid: boolean;
    function GetScriptActiv: boolean;
    procedure ValidateRename(AComponent: TComponent;
      const CurName, NewName: string);
    procedure DisplayComponent(root: TTreeNodes; ansector:  TTreeNode; componentT: TComponent);
    procedure DisplayControl;
    procedure Activate;
    procedure Modified;
    procedure PropertyForm;
    function  CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
    function  GetMethodName(const Method: TMethod): string;
    procedure GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
    function  GetPathAndBaseExeName: string;
    function  GetPrivateDirectory: string;
    function  GetBaseRegKey: string;
    function  GetIDEOptions: TCustomIniFile;
    procedure GetSelections(const List: IDesignerSelections);
    function  MethodExists(const Name: string): Boolean;
    procedure RenameMethod(const CurName, NewName: string);
    procedure SelectComponent(Instance: TPersistent);
    procedure SetSelections(const List: IDesignerSelections);
    procedure ShowMethod(const Name: string);
    procedure GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc);
    function  GetComponent(const Name: string): TComponent;
    function  GetComponentName(Component: TComponent): string;
    function  GetObject(const Name: string): TPersistent;
    function  GetObjectName(Instance: TPersistent): string;
    procedure GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc);
    function  MethodFromAncestor(const Method: TMethod): Boolean;
    function  CreateComponent(ComponentClass: TComponentClass; Parent: TComponent;
      Left, Top, Width, Height: Integer): TComponent;
    function  CreateCurrentComponent(Parent: TComponent; const Rect: TRect): TComponent;
    function  IsComponentLinkable(Component: TComponent): Boolean;
    function  IsComponentHidden(Component: TComponent): Boolean;
    procedure MakeComponentLinkable(Component: TComponent);
    procedure Revert(Instance: TPersistent; PropInfo: PPropInfo);
    function  GetIsDormant: Boolean;
    procedure GetProjectModules(Proc: TGetModuleProc);
    function  GetAncestorDesigner: IDesigner;
    function  IsSourceReadOnly: Boolean;
    function  GetScrollRanges(const ScrollPosition: TPoint): TPoint;
    procedure Edit(const Component: TComponent);
    procedure ChainCall(const MethodName, InstanceName, InstanceMethod: string;
      TypeData: PTypeData);
    procedure CopySelection;
    procedure CutSelection;
    function  CanPaste: Boolean;
    procedure PasteSelection;
    procedure DeleteSelection(ADoAll: Boolean = False);
    procedure ClearSelection;
    procedure NoSelection;
    procedure ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
    function  GetRootClassName: string;
    function  UniqueName(const BaseName: string): string;
    function  GetRoot: TComponent;
    function  GetShiftState: TShiftState;
    procedure ModalEdit(EditKey: Char; const ReturnWindow: IActivatable);
    procedure SelectItemName(const PropertyName: string);
    procedure Resurrect;
    property  FormasList: TList read  fgetFormasList;
    property  Root: TComponent read GetRoot;
    property  IsDormant: Boolean read GetIsDormant;
    property  AncestorDesigner: IDesigner read GetAncestorDesigner;
    function  GetActiveClassGroup: TPersistentClass;
    function  FindRootAncestor(const AClassName: string): TComponent;
    property  ActiveClassGroup: TPersistentClass read GetActiveClassGroup;
    function  QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;
 //   property  ActivWind:       integer        read fActivWind     write SetActivWind;
    property  TComList:        TList          read fTComList      write fTComList;
    property  ExprTrue:        boolean          read fExprTrue    write SetExprTrue;
    property  ProjectBitmap:   TBitmap        read fProjectBitmap write fProjectBitmap;
    property  RedactorForm:    TList          read fRedactorForm  write fRedactorForm;
    property  ReadctorStatus:  TRedactorState read FRedactorState write FRedactorState;
    property  DirProject:      string         read fDirProject    write fDirProject;
    property  CommandList:     TStringList    read fCommandList;
    property  CommentList:     TStringList    read fCommentList;
    property  CopyTrue:        boolean        read fcopytrue;
    property  NumSelected:     integer        read SelectedCount;
    property  Keys:            TKeyBordState  read Keybord;
    property  ClassTree:       SClassesPalete read fClassTree;
    property  ScriptValid: boolean read GetScriptValid;
    property  ScriptActiv: boolean read GetScriptActiv;
    property NameMPC: string read GetMPC write SetMPC;
    procedure  StartScriptRedac;
    procedure   AfterConstruction; override;
    procedure   BeforeDestruction; override;
    procedure   AnalogMem(dir: string);
    procedure   GraphUpdateAll;
    constructor Create(AOwner: TComponent; obj: TObjInsp1);
    destructor  Destroy;  override;
    procedure   DELETECOM(Sender: TObject);
    procedure   COPYCOM(Sender: TObject);
    procedure   CUTCOM(Sender: TObject);
    procedure   PASTCOM(Sender: TObject);
    procedure   SENDTOB(Sender: TObject);
    procedure   BRTFRONT(Sender: TObject);
    procedure   TSV(Sender: TObject);
    procedure   TSVMenu(Sender: TObject);
    procedure   OnEditor(Sender: TObject);
    procedure   ALSIZE(Sender: TObject);
    procedure   CHangeForm(Sender: TObject);
    procedure   ALALIGHN(Sender: TObject);
    procedure   ALSCALE(Sender: TObject);
    procedure   FIXED(Sender: TObject);
    procedure   HideActForm(Sender: TObject);
    procedure   SelectControl(Sdcontrol: TControl; showI: boolean);   //выделяет компонент
    procedure   OBJINSP;
    procedure   SaveFormAs;
    procedure   UpdateDDHinContr;
    procedure   GraphUpdate(gc: TImage);
    function    StartCreate(TCl: TClass): boolean;
    procedure   DeleteSelected(Showprop: boolean);                         //
    function    CreateFormPr: boolean;
    function    CreateNewProject: boolean;
    function    OpenProject(dir: string): boolean;
    function    OpenForm(path: string): boolean;
    function    SaveProject: boolean;
    procedure   showForm;
    function    SaveAndCloseAllForm: boolean;
    procedure   ConfProjForm;
    procedure   FindFormExAndCreate(form: TForm);
    procedure   FindFormExAndDel(form: TForm);
    function    CloseProject: boolean;
    procedure   CloseForm;
    procedure   FixedElement;
    procedure   SelectAll;
    procedure   PopMenuShowTegs(Sender: TObject);
    procedure   PopMenuShowTegsforForm;
    procedure   ShowNextForm(val: boolean);
    procedure   ConnectPackage(path: string);
    procedure   ConnectPackages(path: string);
    procedure   EditPackage(path: string);
    function    Add(const Item: TPersistent): Integer;
    function    Equals(const List: IDesignerSelections): Boolean;
    function    Get(Index: Integer): TPersistent;
    function    GetCount: Integer;
    property    Count: Integer read GetCount;
    //property    CountSe: Integer read GetCount;
    property    Items[Index: Integer]: TPersistent read Get; default;
    procedure   Notification(AnObject: TPersistent; Operation: TOperation);
    procedure   updatelist;
    procedure   ActivateWindow(form: TForm);
    procedure   ConvActForm;
    procedure   Updatetree;
    function    addTotree(comp: TComponent): TTreeNode;
    procedure   DeletefromTree;
    procedure   SelectTree;
    procedure   UpdateCheckForm;
    procedure   incformpos(form: TForm);
    procedure   decformpos(form: TForm);
    function    CheckExprstr(value: string): boolean;
    procedure    ReplaceExpr;
    procedure    FindInExpr;
    procedure    FindInExprErr;
    Procedure   ClearInstrument;
    procedure  StartScriptExec;
    procedure  StartCompile;
    procedure   UnFIXED(Sender: TObject);
    procedure SetMethodInConnect(comp: TComponent; NameEvent: string; procName: String);
  published
    procedure ShowWindD(form: TForm);
    procedure HideWindD(form: TForm);
    property OnMessage;
    property sSistem:TSistemState read System;
  end;

type
    TContainerComponent = class(TImage)
    Procedure After(Red: Tredactor);
    procedure SettoTag;
end;


var
   lastwind: Tform;
   selff: TRedactor;
   ssss: string;
   kkl: Tanalogmems;
   kk: HModule;
   tc: TComponentStyle;
   ts: TComponentstate;
   cs: TControlStyle;
   fs: TFormState;
   lastBring: TForm;

   procedure EveryUnit(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);
   function LowerCaseForPackage(A: String): string;
   function FindBitmap(HM: HModule; A: String): TBitmap;
   procedure BwRegisterComponentsEditor(ComponentClass: TComponentClass;
  ComponentEditor: TComponentEditorClass);

{$R noicon.res}

implementation
 uses FormExprQueekU;

constructor TMyStringList.Create;
begin
  inherited;
  caseSensiv:=false;
end;




function TMyStringList.Add(const S: string): Integer;
var nul: integer;
    i: integer;
    strin, strself: string;
begin
   // if length(S)=0 then exit;
    strself:=S;
    if not caseSensiv then strself:=uppercase(strself);

    if not Sorted then
    Result := Count else Find(S, Result);
    nul:=-1;
    i:=0;
    while (nul<0) and (i<Count) do
      begin
        strin:=self.Strings[i];
        if not caseSensiv then strin:=uppercase(strin);
        if trimleft(trimright(strin))=trimleft(trimright(strself)) then nul:=i else inc(i);
      end;
    if nul>-1 then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Exit;
      end;
  InsertItem(Result, S, nil);
end;

procedure TMyStringList.Replase(from,into: String);
var nul: integer;
    i: integer;
    strin, strself: string;
begin
   // if length(from)=0 then exit;
    Sorted:=false;
    strself:=from;
    if not caseSensiv then strself:=uppercase(strself);


    nul:=-1;
    i:=0;
    while (nul<0) and (i<Count) do
      begin
        strin:=self.Strings[i];
        if not caseSensiv then strin:=uppercase(strin);
        if trimleft(trimright(strin))=trimleft(trimright(strself)) then nul:=i else inc(i);
      end;
  if nul>-1 then Strings[nul]:=into;
end;


//--------TUnitClass ------------------

constructor TUnitClass.create(classp: TClass; bitmap: TBitmap);
begin
  inherited Create;
  TPClass:=Classp;
  TPBitmap:=TBitmap.Create;
  TPBitmap:=bitmap;
end;


destructor TUnitClass.Destroy;
begin
  TPBitmap.free;
  inherited;
end;



//-----------------------------------


//--------SClassesList-----------------
procedure   SClassesList.addClass(classp: TClass; bitmap: TBitmap);
var
 x: TUnitClass;
begin
 x:=TUnitClass.create(classp, bitmap);
 AddObject(classp.ClassName,x);
end;

destructor SClassesList.Destroy;
var i: integer;
begin
 while 0<Count do
    Objects[0].Free;
 inherited;
end;

procedure SClassesList.Clear;
var i: integer;
begin
 while 0<Count do
    Objects[0].Free;
    inherited;
end;
//-------------------------------------


//--------SClassesPalete-----------------

procedure   SClassesPalete.addClass(classp: TClass; bitmap: TBitmap;Heand: string);
var
 y: SClassesList;
begin
 if IndexOf(Heand)<0 then
  begin
    y:=SClassesList.Create;
    y.addClass(classp,bitmap);
    AddObject(Heand,y);
  end
 else
  begin
     SClassesList(Objects[IndexOf(Heand)]).addClass(classp,bitmap);
  end;
end;

procedure SClassesPalete.addEditor(classp: TClass; editclassp: TComponentEditorClass);
  var i,j: integer;
begin
    for i:=0 to Count-1 do
      begin
        for j:=0 to SClassesList(Objects[i]).Count-1 do
           begin
             if TUnitClass(SClassesList(Objects[i]).Objects[j]).TPClass=classP then
               begin
                 TUnitClass(SClassesList(Objects[i]).Objects[j]).TPEditor:=editclassP;
                 exit;
               end;
            end;
       end;
end;


function SClassesPalete.findEditor(classp: TClass): TComponentEditorClass;
  var i,j: integer;
begin
result:=nil;
    for i:=0 to Count-1 do
      begin
        for j:=0 to SClassesList(Objects[i]).Count-1 do
           begin
             if TUnitClass(SClassesList(Objects[i]).Objects[j]).TPClass=classP then
               begin
                 result:=TUnitClass(SClassesList(Objects[i]).Objects[j]).TPEditor;
                 exit;
               end;
            end;
       end;
end;


function SClassesPalete.findBitmap(classp: TClass): TBitmap;
  var i,j: integer;
begin
result:=nil;
    for i:=0 to Count-1 do
      begin
        for j:=0 to SClassesList(Objects[i]).Count-1 do
           begin
             if TUnitClass(SClassesList(Objects[i]).Objects[j]).TPClass=classP then
               begin
                 result:=TUnitClass(SClassesList(Objects[i]).Objects[j]).TPBitmap;
                 exit;
               end;
            end;
       end;
end;

procedure SClassesPalete.Clear;
var i: integer;
begin
 while 0<Count do
    Objects[0].Free;
    inherited;
end;



destructor SClassesPalete.Destroy;
var i,j: integer;
begin

    for i:=0 to Count-1 do
        for j:=0 to SClassesList(Objects[i]).Count-1 do
                 TcomponentEditor(TUnitClass(SClassesList(Objects[i]).Objects[j]).TPEditor).Free;

       
 while 0<Count do
    Objects[0].Free;
 inherited;
end;

////--------------------------------------------------------------------------

destructor TAmem.Destroy;
begin
 fileStrings.Free;
 inherited;
end;

constructor TSelectClass.Create;
begin
 inherited Create;
 BoolSelect:=false;
end;

function TSelectClass.EndEqPres: boolean;
begin
 result:=false;
 if  ((EndSelect.X=PresentSelect.X) and (EndSelect.Y=PresentSelect.Y)) then result:=true;
end;

function TSelectClass.EndEqStart: boolean;
begin
 result:=false;
 if  ((EndSelect.X=StartSelect.X) and (EndSelect.Y=StartSelect.Y)) then result:=true;
end;


procedure TMyNamePropertyEditor.SetValue(const AValue: string);
var old: string;
begin
  old:=getvalue;
  try
  inherited SetValue(AValue);
  (Designer as IMyNameProperty).RenemeCom(old,getvalue);
  except
  end;
end;

procedure TSelectClass.StartSelecting(point : TPoint);
begin
 StartSelect:=Point;
 EndSelect:=Point;
 PresentSelect:=Point;
 BoolSelect:=True;
end;

function TRedactor.CreateFormPr;
var dial: TCommonDialog;
    formcreating: TForm;
    i: integer;
    autoName: string;
    capForm: string;
    point: Tobject;

begin
  i:=componentcount+1;
  repeat
   autoName:='Forma'+inttostr(i);
   inc(i);
  until (FindComponent(autoName)= nil);
  Form7.Redac:=self;
  formcreating:=Form7.Execute(autoName);
  if formcreating=nil then exit;
  TFormCuMy(formcreating).SetDesigning(false);
   TFormCuMy(formcreating).RecreateWnd;
  if Form7.ModalResult=MrOk then
  begin
    point:=TComponentClass(findclass('TIMMIFormExt')).Create(formcreating);
    FindFormExAndCreate(formcreating);
    SetObjectProp(point,'BackBitmap',Form7.formBitmap);
    setordprop(point,'ProjectImage',integer(Form7.projecpicture));
    setstrprop(point,'Name',formcreating.Name+'Ext');
    CurrentParent:=formcreating;
    fRedactorForm.Add(formcreating);
    if appscript<>nil then appscript.CreateComp(formcreating,self);
   // TFormCuMy(formcreating).FFormState:=TFormCuMy(formcreating).FFormState+[fsShowing];
    ShowWindD(formcreating);
    addTotree(formcreating);
    include(FRedactorState,rForm);
    if (rProject in FRedactorState) then formcreating.Tag:=9;
    PropertyForm;
  end;
end;


constructor TRedactor.Create(AOwner: TComponent; obj: TObjInsp1);
begin
 inherited Create(nil);
 owners:=AOwner;
 TControlHack(self).SetDesigning(true,false);
 keyBord:=[];
 System:=[sActive];
 SelectedCount:=0;
 objIn:=obj;
 MenuList:=TComponentList.Create;
 ControlDDHList:=TComponentList.Create;
 PosisSelect:=TSelectClass.Create;
 fRedactorForm:=TList.Create;
 BinStream:=TMemoryStream.Create;
 ffl:=TList.Create;
 fCommandList:= TStringList.Create;
 fCommentList:= TStringList.Create;
 editListC:=Tlist.Create;
 actWind:=nil;
 fMenu := NewPopupMenu(self.owners, 'Menus1', paLeft, false, [NewItem('Копировать', 0, False, True, self.COPYCOM, 0, 'Item1'),
                      NewItem('Вырезать', 0,
                      False, True, self.CUTCOM, 0, 'Item1'),
                      NewItem('Удалить', 0,
                      False, True, self.DELETECOM, 0, 'Item1'),
                       NewItem('Вставить', 0,
                      False, True, self.PASTCOM, 0, 'Item1'),
                      NewItem('Cделать верхним', 0,
                      False, True, self.BRTFRONT, 0, 'Item1'),
                      NewItem('Сделать нижним', 0,
                      False, True, self.SENDTOB, 0, 'Item1'),
                       NewItem('Выровнять размер', 0,
                      False, True, self.ALSIZE, 0, 'Item1'),
                      NewItem('Выровнять размещение ', 0,
                      False, True, self.ALALIGHN, 0, 'Item1'),
                      NewItem('Масштабировать', 0,
                      False, True, self.ALSCALE, 0, 'Item1'),
                      NewItem('Задать фон', 0,
                      False, True, self.CHangeForm, 0, 'Item1'),
                      NewItem('Фиксировать выделение', 0,
                      False, True, self.FIXED, 0, 'Item1'),
                       NewItem('Теги', 0,
                      False, True, self.PopMenuShowTegs, 0, 'Item1'),
                      NewItem('Скрыть форму', 0,
                      False, True, self.HideActForm, 0, 'Item1')
                      ]);

 //CompTree.PopupMenu:=self.fMenu;
 CurrentParent:=nil;
 OnMessage:=AppMessage;
 Form9:=TForm9.Create(nil);
 objIn.IDesig:=self;
 Form7:=TForm7.Create(nil);
 Form3:=TForm3.Create(nil);
 Form5:=TForm5.Create(nil);
 Form6:=TForm6.Create(nil);
 FormFindExpr:=TFormFindExpr.Create(nil);
 FormFindExprErr:=TFormFindExprErr.Create(nil);
 //PropertyForm;
 fexprtrue:=false;
 GraphUpdateAll;
 fDirProject:=ExtractFileDir(ExtractFileDir(Application.ExeName));
 fProjectBitmap:=TBitmap.create;
 fcopytrue:=false;
 fTComList:=TList.Create;
 ModuleList:=TStringList.Create;
 fClassTree:=SClassesPalete.Create;
 lastPoint.X:=0;
 lastPoint.Y:=0;
 Opendialog1:=TOpendialog.Create(owners);
 selff:=self;
 classregister:=Tlist.Create;
 noiconbm:=TBitmap.Create;
 IdentStrings := TMyStringList.Create;
 noiconbm.LoadFromResourceName(HInstance,'noicon');
 lastBring:=nil;
 classList:=TList.Create;
end;

function TRedactor.GetMPC: string;
begin
  result:=fMPC;
end;

procedure TRedactor.SetMPC(val: string);
begin
 fMPC:=val;
end;

procedure   TRedactor.AfterConstruction;
begin
inherited;
 AnalogMem(PathMem);
 CoInitialize(nil);
 ConnectPackages(PackageIni);
 objIn.RegisterPropertyEditorM(TypeInfo(TFont),TPersistent,'',TFontProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TPicture),TPersistent,'',TPictureProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TColor),nil,'',TColorProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(String),nil,'',TCaptionProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(String),nil,'',TComponentNameProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TFontCharset),nil,'',TFontCharsetProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TCursor),nil,'',TCursorProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TGraphic),nil,'',TGraphicProperty);
 objIn.RegisterPropertyEditorM(TypeInfo(TComponentName),Tcomponent,'Name',TMyNamePropertyEditor);
end;

procedure   TRedactor.BeforeDestruction;
var i: integer;
begin
// while editListC.Count>0 do
  { try
    // TcomponentEditor(editListC.Items[0]).free;
    except
    end;  }
   editListC.Clear;
 for i:=0 to classregister.Count-1 do
    Unregisterclass(Tpersistentclass(classregister.items[i]));
 BinStream.Free;
 CoUnInitialize;
 fMenu.Free;
 inherited;
end;


destructor TRedactor.Destroy;
begin
  classList.Free;
  lastBring:=nil;
  FormFindExpr.Free;
  FormFindExprErr.Free;
  IdentStrings.Free;
  fProjectBitmap.Free;
  ControlDDHList.Free;
  PosisSelect.Free;
  ffl.Free;
  fCommandList.free;
  fCommentList.free;
  fTComList.Free;
  ModuleList.free;
  classregister.Free;
  noiconbm.Free;
  MenuList.Free;
  editListC.Free;
  Form7.Free;
  Form3.Free;
  Form5.Free;
  Form6.Free;
  Form9.Free;

end;

procedure Tredactor.ChangeParent;
begin
  DeleteSelected(true);
  if ((MustBeParent<>CurrentParent) and
                 (MustBeParent<>nil) and
                         (MustBeParent is TWinControl)) then
                                          CurrentParent:=MustBeParent;
end;


procedure TRedactor.SelectControl(Sdcontrol : TControl; showI: boolean);
begin
if Sdcontrol=nil then exit;
if (Sdcontrol is TControl) and
        not (Sdcontrol.owner is TForm) and not
                 (Sdcontrol is TContainerComponent)then exit{Sdcontrol:=Sdcontrol.owner as TControl};
if Sdcontrol.owner is TForm then ShowWindD(Sdcontrol.owner as TForm);
 if  Sdcontrol is TForm then Exit;
   if Sdcontrol is TImage  then
        GraphUpdate(Sdcontrol as TImage);

 if ((Sdcontrol.Tag<100)) then
    begin
      ControlDDHList.Add(TControlddh.Create(Sdcontrol));
      SelectedCount:=ControlDDHList.Count;
    end;
   if appscript<>nil then appscript.SelectChange;
end;

procedure TRedactor.DeleteSelected(Showprop:boolean);
var
i: integer;
begin
  ControlDDHList.Clear;
  SelectedCount:=0;
  if Showprop then
          PropertyForm;
end;

procedure TRedactor.DDHContPaint;
var
i: integer;
begin
   for i:=0 to ControlDDHList.Count-1 do
         (ControlDDHList.Items[i] as TControlDDH).Paint;
end;


procedure TRedactor.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
flag: boolean;
menp: TPoint;
actHandl: HWND;
i: integer;
fmsg: TPoint;
begin

          if ((Msg.message = WM_KEYDOWN) and (msg.wParam=119)) then
          begin
             application.ShowMainForm:=true;
            (owners as TForm).WindowState:=wsNormal;
            (owners as TForm).Show;
            (owners as TForm).BringToFront;
             (owners as TForm).FormStyle:=fsStayOntop;
            handled:=true;
            Exit;
          end;

     if ((Msg.message = WM_KEYDOWN) and (msg.wParam=118)) then
          begin
            (owners as TForm).WindowState:=wsMinimized;
           // (owners as TForm).Show;
           // (owners as TForm).BringToFront;
           //  (owners as TForm).FormStyle:=fsStayOntop;
            //handled:=true;
            Exit;
          end;

     if ((Msg.message = WM_KEYDOWN) and (msg.wParam=117)) then
          begin
            application.Minimize;
           // (owners as TForm).Show;
           // (owners as TForm).BringToFront;
           //  (owners as TForm).FormStyle:=fsStayOntop;
            //handled:=true;
            Exit;
          end;

     if Msg.message = WM_KEYUP then
           begin
            if msg.wParam=17  then  KeyBord:=KeyBord-[pCntrl];
            if msg.wParam=16  then  KeyBord:=KeyBord-[pShift];
            handled:=false;
          //  exit;
           end;

     if Msg.message = WM_KEYDOWN then
           begin
            if msg.wParam=17  then  KeyBord:=KeyBord+[pCntrl];
            if msg.wParam=16  then  KeyBord:=KeyBord+[pShift];
           handled:=false;
           //exit;
           end;






           if (Msg.message=WM_MOUSEMOVE) then
             begin
               handled:=true;
               Msg.pt.X:=(Msg.pt.X div  4)*4;
               Msg.pt.y:=(Msg.pt.y div  4)*4;
               if (pMouseLeftDown in KeyBord) then
                  begin
                     if (sSelect in System) then SelectGrope(Msg.pt)
                     else if (sDrag in System) {and (sRedac in System)} then MoveCont(Msg.pt)
                     else
                     begin
                     handled:=false;
                     end;
                 end;
                 handled:=false;

                 exit;
            end;



          if Msg.message = WM_KEYUP then
           begin
             if msg.wParam=65  then
               begin
                 if pCntrl in KeyBord then
               //    self.SelectAll;
                 KeyBord:=KeyBord-[pA,pCntrl];
               end;
             if msg.wParam=88  then
               begin
                 if pCntrl in KeyBord then
                 //  self.CUTCOM(nil);
                 KeyBord:=KeyBord-[pX,pCntrl];
               end;
             if msg.wParam=67  then
               begin
                 if pCntrl in KeyBord then
                //   self.COPYCOM(nil);
                 KeyBord:=KeyBord-[pC,pCntrl];
               end;
             if msg.wParam=86  then
               begin
                 if pCntrl in KeyBord then
               //    self.PastCOM(nil);
                 KeyBord:=KeyBord-[pV,pCntrl];
               end;
               if msg.wParam=46  then
               begin
                 if pCntrl in KeyBord then
                   self.DelAllSel(true);
                 KeyBord:=KeyBord-[pDel,pCntrl];
               end;
                   if msg.wParam=79  then
               begin
                 if pCntrl in KeyBord then
                   self.ShowNextForm(false);

               end;
               if msg.wParam=73  then
               begin
                 if pCntrl in KeyBord then
                   self.ShowNextForm(true);

               end;
        
            if msg.wParam=84  then  KeyBord:=KeyBord-[pTube];
           end;

         if Msg.message = WM_KEYDOWN then
           begin

            if msg.wParam=84 then KeyBord:=KeyBord+[pTube];
            if msg.wParam=46 then KeyBord:=KeyBord+[pDel];
            if msg.wParam=65  then  KeyBord:=KeyBord+[pA];
            if msg.wParam=88  then  KeyBord:=KeyBord+[pX];
            if msg.wParam=67  then  KeyBord:=KeyBord+[pC];
            if msg.wParam=86  then  KeyBord:=KeyBord+[pV];
            if (pTube in KeyBord) then
               begin
               if msg.wParam=37 then TubeBuild(0,0,10,0);
               if msg.wParam=39 then TubeBuild(0,0,0,10);
               if msg.wParam=38 then TubeBuild(10,0,0,0);
               if msg.wParam=40 then TubeBuild(0,10,0,0);

               Exit;
               end;
            if (pShift in KeyBord) then
               begin
               if msg.wParam=37 then SizeKey(0,0,1,0);
               if msg.wParam=39 then SizeKey(0,0,0,1);
               if msg.wParam=38 then SizeKey(1,0,0,0);
               if msg.wParam=40 then SizeKey(0,1,0,0);
               Exit;
               end;
             if (pCntrl in KeyBord) then
               begin
               if msg.wParam=37 then MoveKey(0,0,1,0);
               if msg.wParam=39 then MoveKey(0,0,0,1);
               if msg.wParam=38 then MoveKey(1,0,0,0);
               if msg.wParam=40 then MoveKey(0,1,0,0);
               Exit;
               end;

               Handled:=false;
               exit;
           end;




end;

procedure TRedactor.DelCompSc(comp: tcomponent);
begin
  if appscript<>nil then appscript.DeleteComp(comp,self);
end;


procedure TRedactor.DelAllSel(MesBox: boolean);
var i,ans: integer;
    DelControl: TControl;
begin
   i:=0;
   if SelectedCount>0 then
      begin
        if MesBox then
            ans:=MessageBox(0,'Вы действительно собираетесь удалить ?','Удаление обьектов',MB_YESNO+MB_ICONQUESTION+MB_TOPMOST) else ans:=IDYES;
        if (ans=IDYES) then
          begin
             while i<(ControlDDHList.Count) do
                begin
                    DelControl:=TControlDDH(ControlDDHList.Items[i]).FControl;
                    if appscript<>nil then appscript.DeleteComp(DelControl,self);
                    TControl(ControlDDHList.Items[i]).Free;
                    //ControlDDHList.Items[i]:=nil;
                    if DelControl is TContainerComponent then DelControl.Owner.Free
                                        else DelControl.Free ;
                    DelControl:=nil;

                end;
            SelectedCount:=0;
         end;
      end;
     PropertyForm;
end;



procedure TRedactor.SetDr(ClickPoint: TPoint);
begin
   ClickPoint.X:=(ClickPoint.X div  4)*4;
   ClickPoint.y:=(ClickPoint.y div  4)*4;
   if AllOneParent then
   begin
     beforeDrag:=ClickPoint;
     startDDrag:=ClickPoint;
     PaintFocusRect(beforeDrag);
     System:=System+[sDrag]-[sMoved];

   end;
end;


procedure Tredactor.MoveCont(MovePoint: TPoint);

begin
    SetCapture(CurrentParent.Handle);
      if ((MovePoint.x<>beforeDrag.x) or  (MovePoint.y<>beforeDrag.y)) then  System:=System+[sMoved];
        PaintFocusRect(beforeDrag);
        beforeDrag:=MovePoint;
        PaintFocusRect(beforeDrag);
        System:=System-[sDragTwo];
end;

procedure Tredactor.MoveContEnd(EndPoint: TPoint);
var
i: integer;
begin
  ReleaseCapture;
  if (startDDrag.X<>beforeDrag.X) or (startDDrag.y<>beforeDrag.y) then
     begin
       PaintFocusRect(beforeDrag);
       DragStopToRect(beforeDrag);
       System:=System-[sDragTwo];
     end;
    UpdateDDHinContr;
    System:=System-[sMoved];
  end;

procedure TREdactor.PaintFocusRect(PointMove: TPoint);
var i: integer;
    HDc4: HDC;
    TR4: Trect;
    dc: Hrgn;
    df1,df2: TPoint;
begin
  df1.X:=0;df1.y:=0;
  df2.X:=(CurrentParent as TControl).Width;
  df2.y:=(CurrentParent as TControl).Height;
  df1:=(CurrentParent as TControl).ClientToScreen(df1);
  df2:=(CurrentParent as TControl).ClientToScreen(df2);
  dc:=CreateRectRgn(df1.x,df1.y,df2.X,df2.Y);
  ClientToscreen(CurrentParent.Handle,PointMove);
  hdc4:=GetDCex(CurrentParent.ParentWindow,dc,DCX_INTERSECTRGN);
  i:=0;
  while (i<ControlDDHList.Count) do
        begin
            TR4.TopLeft:=(ControlDDHList.Items[i] as TControlddh).BoundsRect.TopLeft;
            TR4.BottomRight:=(ControlDDHList.Items[i] as TControlddh).BoundsRect.BottomRight;
            TR4.TopLeft.X:=(PointMove.X-startDDrag.x)+TR4.TopLeft.X;
            TR4.TopLeft.y:=(PointMove.y-startDDrag.y)+TR4.TopLeft.y;
            TR4.BottomRight.X:=TR4.TopLeft.X+(ControlDDHList.Items[i] as TControlddh).Width;
            TR4.BottomRight.y:=TR4.TopLeft.Y+(ControlDDHList.Items[i] as TControlddh).Height;
            DrawFocusRect(HDC4,TR4);
            inc(i);
        end;
   DeleteDC(hdc4);
end;

procedure TREdactor.DragStopToRect(PointEnd: TPoint);
var i: integer;
    HDc4: HDC;

begin
  i:=0;
  while (i<ControlDDHList.Count) do
        begin
            MoveWindow((ControlDDHList.Items[i] as TControlddh).Handle,(PointEnd.x-startDDrag.x)+(ControlDDHList.Items[i] as TControlddh).Left,(PointEnd.y-startDDrag.y)+(ControlDDHList.Items[i] as TControlddh).Top,
            (ControlDDHList.Items[i] as TControlddh).Width,(ControlDDHList.Items[i] as TControlddh).Height,false);
            if (ControlDDHList.Items[i] as TControlDDH).BoundsRect.Bottom<10 then (ControlDDHList.Items[i] as TControlDDH).Top:=0;
            if (ControlDDHList.Items[i] as TControlDDH).BoundsRect.Right<10 then (ControlDDHList.Items[i] as TControlDDH).Left:=0;
            if (ControlDDHList.Items[i] as TControlDDH).BoundsRect.Top>Currentparent.Height then (ControlDDHList.Items[i] as TControlDDH).Top:=Currentparent.Height-(ControlDDHList.Items[i] as TControlDDH).Height;
            if (ControlDDHList.Items[i] as TControlDDH).BoundsRect.Left>Currentparent.Width then (ControlDDHList.Items[i] as TControlDDH).Left:=Currentparent.Width-(ControlDDHList.Items[i] as TControlDDH).Width;
            (ControlDDHList.Items[i] as TControlDDH).FControl.BoundsRect:=(ControlDDHList.Items[i] as TControlDDH).BoundsRect;
            inc(i);
        end;

end;



function TREdactor.EnterOfPos(CompCor: TControl; Lansc: TRect): boolean;
var lefttopB,rightbottomB: boolean;
begin
  lefttopB:=false;
  rightbottomB:=false;
  if ((CompCor.BoundsRect.TopLeft.X>=Lansc.TopLeft.X) and
               (CompCor.BoundsRect.TopLeft.Y>=Lansc.TopLeft.Y)) then lefttopB:=true;
  if ((CompCor.BoundsRect.BottomRight.X<=Lansc.BottomRight.X) and
               (CompCor.BoundsRect.BottomRight.Y<=Lansc.BottomRight.Y)) then rightbottomB:=true;
  if rightbottomB and lefttopB then result:=true else result:=false;
end;




function TREdactor.ControlNoSelect(CompCor: TControl): boolean;
var i: integer;
begin
i:=0;
result:=true;
if (CompCor is TControlDDH) then result:=false else
    begin
    while ((i< ControlDDHList.Count)) do
      begin
       if  (ControlDDHList.Items[i] as TControlDDH).FControl=CompCor then
         result:=false;
       inc(i);
      end;
   end;
end;

procedure TRedactor.RenemeCom (old: string; new: String);
begin
  if Appscript<> nil then Appscript.RenameComp(old,new,self);
end;

procedure TRedactor.SelectGrope(MovePoint: TPoint);
var
p1,p2,p3,p4: TPoint;
pc: integer;
hd1: HDC;
SelRect: TRect;
begin

PosisSelect.EndSelect:=MovePoint;
if (not PosisSelect.EndEqPres and  not PosisSelect.EndEqStart)then
  begin
   SetCapture(CurrentParent.Handle);
   p1:=PosisSelect.StartSelect;
   p2:=PosisSelect.PresentSelect;
   p3:=PosisSelect.EndSelect;
   ScreenToClient(CurrentParent.Handle,P1);
   ScreenToclient(CurrentParent.Handle,P2);
   ScreenToclient(CurrentParent.Handle,P3);
   hd1:=GetDC(CurrentParent.Handle);
   p4:=p1;
   if not PosisSelect.BoolSelect then
     begin
      if (P1.X>P2.X) then
         begin
          pc:=P1.X;
          P1.x:=P2.x;
          P2.x:=pc;
         end;
     if (P1.y>P2.y) then
        begin
          pc:=P1.y;
          P1.y:=P2.y;
          P2.y:=pc;
        end;
     SelRect.TopLeft:=p1;
     SelRect.BottomRight:=p2;
     DrawFocusRect(HD1,SelRect);
     end else PosisSelect.BoolSelect:=false;
     p1:=p4;
     if (P1.X>P3.X) then
       begin
         pc:=P1.X;
         P1.x:=P3.x;
         P3.x:=pc;
       end;
     if (P1.y>P3.y) then
       begin
         pc:=P1.y;
         P1.y:=P3.y;
         P3.y:=pc;
       end;
     SelRect.TopLeft:=p1;
     SelRect.BottomRight:=p3;
     DrawFocusRect(HD1,SelRect);
     deleteDC(hd1);
     PosisSelect.PresentSelect:=PosisSelect.EndSelect;
  end;

end;


procedure Tredactor.EndSelectGrope(EndPoint: TPoint);
var
hd1: HDC;
p1,p2: TPoint;
i,pc: integer;
SelRect: TRect;
begin
 ReleaseCapture;
 hd1:=GetDC(CurrentParent.Handle);
 p1:=PosisSelect.StartSelect;
 p2:=PosisSelect.PresentSelect;
 ScreenToClient(CurrentParent.Handle,P1);
 ScreenToclient(CurrentParent.Handle,P2);
 if (P1.X>P2.X) then
  begin
  pc:=P1.X;
  P1.x:=P2.x;
  P2.x:=pc;
  end;
 if (P1.y>P2.y) then
  begin
  pc:=P1.y;
  P1.y:=P2.y;
  P2.y:=pc;
  end;
 SelRect.TopLeft:=p1;
 SelRect.BottomRight:=p2;
 DrawFocusRect(HD1,SelRect);
 i:=0;
 deleteDC(hd1);
 while i<CurrentParent.ControlCount do
  begin
   if ((EnterOfPos(CurrentParent.Controls[i],SelRect)) and
                    (ControlNoSelect(CurrentParent.Controls[i]))) then
                                           SelectControl(CurrentParent.Controls[i],false);
    inc(i);
  end;
 GraphUpdateAll;
 PropertyForm;
 SelectTree;
end;


procedure Tredactor.MoveKey(up,down,left,right: integer);
var i: integer;
begin
  i:=0;
  while (i<ControlDDHList.Count) do
        begin
           (ControlDDHList.Items[i] as TControlddh).Left:=(ControlDDHList.Items[i] as TControlddh).Left-left+right;
           (ControlDDHList.Items[i] as TControlddh).Top:=(ControlDDHList.Items[i] as TControlddh).Top-up+down;
           (ControlDDHList.Items[i] as TControlddh).Fcontrol.BoundsRect:=(ControlDDHList.Items[i] as TControlddh).BoundsRect;
           (ControlDDHList.Items[i] as TControlddh).Fcontrol.Invalidate;
        i:=i+1;
     end;
end;





procedure Tredactor.SizeKey(up,down,left,right: integer);
var i: integer;
begin
  i:=0;
  while (i<ControlDDHList.Count) do
     begin
        (ControlDDHList.Items[i] as TControlddh).Width:=(ControlDDHList.Items[i] as TControlddh).Width+right-left;
        (ControlDDHList.Items[i] as TControlddh).Height:=(ControlDDHList.Items[i] as TControlddh).Height+down-up;
        (ControlDDHList.Items[i] as TControlddh).fcontrol.BoundsRect:=(ControlDDHList.Items[i] as TControlddh).BoundsRect;
        i:=i+1;
     end;
end;


procedure TRedactor.DELETECOM(Sender: TObject);
begin
  DelAllSel(true);
  DeletefromTree;
end;



procedure TRedactor.COPYCOM(Sender: TObject);
var i,j,k: integer;
    kl: TComponentName;
    copCont: TComponent;
    subComp: TControl;
begin
  if self.SelectedCount>0 then
    begin
      fcopytrue:=true;
      SortOlder;
      SetLength(arrClass,TComponent(actWind).ComponentCount);
      i:=0;j:=0;
      BinStream.Clear;
      BinStream.Seek(0,soFromBeginning);
      while i<ControlDDHList.Count do
       begin
        copCont:=(ControlDDHList.Items[i] as TControlDDH).FControl;

        if copcont is TContainerComponent then
          copcont:=(copcont as TContainerComponent).Owner;
          kl:= copCont.Name;
        copCont.name:= copCont.name+'Copy';
        copCont.Tag:=-10;
        BinStream.WriteComponent(copCont);
        copCont.Tag:=j;
        arrClass[j]:=copCont.ClassType;
        copCont.Name:=kl;
        BinStream.Seek(0,soFromEnd);
        j:=j+1;
         //---------------------------------------------------

         if ((( copCont is TWinControl) and ((copCont as TWinControl).ControlCount>0))) then
         begin
           for k:=0 to TForm(actWind).ComponentCount-1 do
              begin
                 if TForm(actWind).Components[k] is TControl then
                 begin
                 subComp:=TControl(TForm(actWind).Components[k]);
                 if ((asChildParent(subComp, (copCont as TWinControl))<>nil) and
                    (subComp<>copCont))then
                    begin
                       kl:=(subComp as TControl).Name;
                       subComp.Name:=subComp.Name+'Copy';
                      subComp.Tag:=subComp.Parent.tag;
                      BinStream.WriteComponent(subComp);
                      subComp.Tag:=j;
                      arrClass[j]:=subComp.ClassType;
                      subComp.Name:=kl;
                      BinStream.Seek(0,soFromEnd);
                      j:=j+1;
                 end;
               end;
         end;
      end;
//-------------------------------------------------------
i:=i+1;
end;
RepaintAll;
end;
end;

procedure TRedactor.CUTCOM(Sender: TObject);
var i,j,k: integer;
kl: TComponentName;
copCont: TComponent;
subComp: TControl;
begin
if self.SelectedCount>0 then
begin
fcopytrue:=true;
SortOlder;
SetLength(arrClass,TComponent(actWind).ComponentCount);
i:=0;j:=0;
 BinStream.Clear;
 BinStream.Seek(0,soFromBeginning);
while i<ControlDDHList.Count do
begin
        copCont:=(ControlDDHList.Items[i] as TControlDDH).FControl;
        if copcont is TContainerComponent then
          copcont:=(copcont as TContainerComponent).Owner as TComponent;
          kl:= copCont.Name;
        copCont.name:= copCont.name+'Copy';
        copCont.Tag:=-10;
        BinStream.WriteComponent(copCont);
        copCont.Tag:=j;
        arrClass[j]:=copCont.ClassType;
        copCont.Name:=kl;
        BinStream.Seek(0,soFromEnd);
        j:=j+1;
         //---------------------------------------------------

         if ((( copCont is TWinControl) and ((copCont as TWinControl).ControlCount>0))) then
         begin
           for k:=0 to TForm(actWind).ComponentCount-1 do
              begin
                 if TForm(actWind).Components[k] is TControl then
                 begin
                 subComp:=TControl(TForm(actWind).Components[k]);
                 if ((asChildParent(subComp, (copCont as TWinControl))<>nil) and
                    (subComp<>copCont))then
                    begin
                       kl:=(subComp as TControl).Name;
                       subComp.Name:=subComp.Name+'Copy';
                      subComp.Tag:=subComp.Parent.tag;
                      BinStream.WriteComponent(subComp);
                      subComp.Tag:=j;
                      arrClass[j]:=subComp.ClassType;
                      subComp.Name:=kl;
                      BinStream.Seek(0,soFromEnd);
                      j:=j+1;
                 end;
               end;
         end;
      end;
//-------------------------------------------------------
i:=i+1;
end;
DelAllSel(false);
RepaintAll;
end;
end;

procedure TRedactor.PASTCOM(Sender: TObject);
var yy,jj,minT,minL: integer;
    arParent: array of TWinControl;
    Rect: TRect;
    lastpoint1: TPoint;
    readComp: TComponent;
    lastpar: TWinControl;
    contain: TContainerComponent;
    form: TForm;
begin
minT:=20000;
minL:=20000;
SetLength(arParent,TComponent(actWind).ComponentCount+100);
if SelectedCount=1 then
begin
   if ((ControlDDHList.Items[0] as TcontrolDDH).FControl is TCustomControl) then
   begin
   MustBeParent:=((ControlDDHList.Items[0] as TcontrolDDH).FControl as TWinControl);
   ChangeParent;
   lastpoint.X:=0;
   lastpoint.Y:=0;
   end;
   DeleteSelected(false);
   end
else
   begin
   DeleteSelected(false);
   System:=System-[sDrag];
   end;
jj:=0;
 if BinStream<>nil then
   begin
     BinStream.Seek(0,soFromBeginning);
     if BinStream.Size<>0 then
     while ((BinStream.Position)+1<BinStream.Size) do
      begin
        CreateClass:=TIMMI(arrClass[jj]);
        with CreateClass.Create(actWind) do
           begin
             readComp:=(TComponent(actWind)).Components[ComponentIndex];
             if appscript<>nil then appscript.CreateComp(readComp,self);
             if readComp is TControl then (readComp as TControl).Parent:=CurrentParent;
             inc(jj);
             BinStream.ReadComponent(readComp);
             if (readComp is TControl) then
               begin

                visible:=true;
                if (readComp as TControl).Top<minT then
                        MinT:=(readComp as TControl).Top;
                if (readComp as TControl).Left<minL then
                        MinL:=(readComp as TControl).Left;
                if (readComp.tag<0) then
                   begin
                      (readComp as TControl).BoundsRect:=IsRectControl((readComp as TControl).BoundsRect);
                      (readComp as TControl).Parent:=CurrentParent;
                      lastpar:=TWinControl(readComp);
                      SelectControl(readComp as Tcontrol,true);
                   end
                else (readComp as TControl).Parent:=(lastpar);
                if readComp is TImage then GraphUpDate(readComp as TImage)
                                          else arParent[jj]:=CurrentParent;
               end
             else
               if  (readComp is TComponent) then
               begin
                 readComp.tag:=0;
                 if CurrentParent is TForm then form:=tform(CurrentParent) else form:=tform(CurrentParent.Owner);
                 contain:=TContainerComponent.Create(readComp);
                 contain.Parent:=form;
                 contain.After(self);
                 contain.Visible:=true;
               end;


          readComp.Name:=CounObjClass(readComp.ClassName);
          readComp.Tag:=0;
          addTotree(readComp);

          BinStream.Seek(0,soFromCurrent);

       end;

    end;
end;
lastpoint1.x:=lastpoint.x;
lastpoint1.y:=lastpoint.y;
if CurrentParent<>nil then
lastpoint1:=CurrentParent.ScreenToClient(lastpoint1);
MoveKey(minT,lastpoint1.Y,minL,lastpoint1.x);
PropertyForm;
SelectTree;
end;



procedure TRedactor.BRTFRONT(Sender: TObject);
var i:integer;
begin
for i:=0 to ControlDDHList.Count-1 do
  (ControlDDHList.Items[i] as TControlddh).FControl.BringToFront;

end;


procedure TRedactor.SENDTOB(Sender: TObject);
var i:integer;
begin
for i:=0 to ControlDDHList.Count-1 do
  (ControlDDHList.Items[i] as TControlddh).FControl.SendToBack;

end;

procedure TRedactor.TSV(Sender: TObject);
var CompEd: TBaseComponentEditor;
    comp: TComponent;
begin
if SelectedCount=1 then
  if (ControlDDHList.Items[0] as TControlddh).FControl is TContainerComponent then
  comp:=TContainerComponent((ControlDDHList.Items[0] as TControlddh).FControl).Owner else
  comp:=(ControlDDHList.Items[0] as TControlddh).FControl;
  begin
    if fClassTree.findEditor(comp.ClassType)<>nil then
      begin
        if TBaseComponentEditor(comp.DesignInfo)=nil then
          begin
            CompEd:=(fClassTree.findEditor(comp.ClassType)).Create(comp,self);
            editListC.Add(CompEd)
          end
        else CompEd:=TBaseComponentEditor(comp.DesignInfo);
        TComponentEditor(CompEd).Edit;
        comp.DesignInfo:=integer(CompEd);
      end;
  end;
  //  System:=System-[sActive];
    //if owners<>nil then
    //(owners as Tform).Show;
end;


procedure TRedactor.TSVMenu(Sender: TObject);
var CompEd: TBaseComponentEditor;
    i: integer;
    it: TMenuItem;
    comp: TComponent;
begin
if SelectedCount=1 then
  begin
    if (ControlDDHList.Items[0] as TControlddh).FControl is TContainerComponent then
    comp:=TContainerComponent((ControlDDHList.Items[0] as TControlddh).FControl).Owner else
    comp:=(ControlDDHList.Items[0] as TControlddh).FControl;
    if fClassTree.findEditor(comp.ClassType)<>nil then
      begin
        MenuList.Clear;
        if TBaseComponentEditor((ControlDDHList.Items[0] as TControlddh).FControl.DesignInfo)=nil then
         begin
           CompEd:=(fClassTree.findEditor(comp.ClassType)).Create(comp,self);
           editListC.Add(CompEd)
         end
        else
         begin

           CompEd:=TBaseComponentEditor(comp.DesignInfo);

         end;
         for i:=0 to TComponentEditor(CompEd).GetVerbCount-1 do
          begin
            it:=TMenuItem.Create(fMenu);
            it.Tag:=i;
            it.Caption:=TComponentEditor(CompEd).GetVerb(i);
            it.OnClick:=OnEditor;
            fMenu.Items.Insert(0,it);
            MenuList.Add(it);
          end;

       comp.DesignInfo:=integer(CompEd);
     end;
   end;
  System:=System-[sActive];
end;


procedure TRedactor.HideActForm(Sender: TObject);
begin
if ((actWind=nil) or not (actWind is TForm)) then exit;
    self.HideWindD(actWind as TForm);
end;

procedure TRedactor.OnEditor(Sender: TObject);
var CompEd: TBaseComponentEditor;
    i: integer;
    it: TMenuItem;
begin
if SelectedCount=1 then
  begin
    if fClassTree.findEditor((ControlDDHList.Items[0] as TControlddh).FControl.ClassType)<>nil then
      begin
        if TBaseComponentEditor((ControlDDHList.Items[0] as TControlddh).FControl.DesignInfo)=nil then exit
        else CompEd:=TBaseComponentEditor((ControlDDHList.Items[0] as TControlddh).FControl.DesignInfo);
        if (sender as tcomponent).tag<TComponentEditor(CompEd).GetVerbCount then
                      TComponentEditor(CompEd).ExecuteVerb((sender as TComponent).Tag);

      end;
  end;
end;


procedure TREdactor.OBJINSP;
begin

end;

procedure TREdactor.CreateObjIMMI(ClOb: TClass; CreatePoint: TPoint);
var
    Rect: TRect;
    crControl: TControl;
    CreateCom: TComponent;
    cOwner: TWinControl;
    fmsg: Tmsg;
    selecttCont: TControl;
    contancom: TContainerComponent;
begin
if ClOb=nil then
  begin
     System:=System-[sCreateObj];
     SendMessageBroadcast(WM_IMMIITEMCREATED, 0, 0);
     Exit;
  end;
if (((rProject in FRedactorState) or
           (rForm in FRedactorState)) and
                       (actWind<>nil) ) then
  begin
   CreatePoint.X:=CreatePoint.X-10;
   CreatePoint.y:=CreatePoint.y-10;
   if ((SelectedCount=1) and not
              (ControlDDHList.Items[0] is TContainerComponent)) then
          begin
            if ((ControlDDHList.Items[0] as TControlDDH).FControl is TCustomControl) then
                begin
                  MustBeParent:=((ControlDDHList.Items[0] as TControlDDH).FControl as TWincontrol);
                  ChangeParent;
                end
            else
                DeleteSelected(false);
          end
        else
          begin
            DeleteSelected(false);
            System:=System-[sDrag];
          end;

       CreateClass:=TImmi(ClOb);

       if CurrentParent is TForm then cOwner:=CurrentParent
                                        else cOwner:=CurrentParent.Owner as TWinControl;
       if cOwner=nil then exit;

       System:=System-[sCreateObj];

       CreateCom:=CreateClass.Create(cOwner);
       if appscript<>nil then appscript.CreateComp(CreateCom,self);
         begin
          SendMessageBroadcast(WM_IMMIITEMCREATED, 0, 0);
          if not (CreateCom is TControl) then
            begin
              contancom:=TContainerComponent.Create(CreateCom);
              contancom.Parent:=cOwner;
              if CreatePoint.X<0 then
                begin
                 contancom.Left:= cOwner.Width div 2 - contancom.Width div 2;
                 contancom.Top:= cOwner.Height div 2 - contancom.Height div 2;
                end
              else
                begin
                 contancom.Left:=(cOwner).ScreenToClient(CreatePoint).X;
                 contancom.Top:=(cOwner).ScreenToClient(CreatePoint).Y;

                end;
               contancom.SettoTag;
              contancom.After(self);
              selecttCont:=contancom;
            end
          else
            begin
             (CreateCom as TControl).Parent:=CurrentParent;
             (CreateCom as TControl).visible:=true;
              if CreatePoint.X<0 then
               begin
                  Rect.Left:=CurrentParent.Width div 2 - (CreateCom as TControl).Width div 2;
                  Rect.Top:=CurrentParent.Height div 2 - (CreateCom as TControl).Height div 2;
                  Rect.Right:=Rect.Left+(CreateCom as TControl).Width;
                  Rect.Bottom:=Rect.Top+(CreateCom as TControl).Height;
                  (CreateCom as TControl).BoundsRect:=IsRectControl(Rect);
               end
              else
               begin
                  Rect.Left:=(CreateCom as TControl).ScreenToClient(CreatePoint).X;
                  Rect.Top:=(CreateCom as TControl).ScreenToClient(CreatePoint).Y;
                  Rect.Right:=Rect.Left+(CreateCom as TControl).Width;
                  Rect.Bottom:=Rect.Top+(CreateCom as TControl).Height;
                  (CreateCom as TControl).BoundsRect:=IsRectControl(Rect);
               end;
                selecttCont:=(CreateCom as TControl);
            end;
          CreateCom.Name:=CounObjClass(CreateCom.ClassName);

          SelectControl(selecttCont,true);
          System:=System-[sDrag];

              end;
              if TComponent(actWind) is TImage then  GraphUpdate(TComponent(actWind) as TImage);
        end;
        UpdateDDHinContr;
        Updatetree;
        PropertyForm;
        SelectTree;
end;

procedure TRedactor.SaveFormAs;
var
  savingform: TForm;
  fs: TFilestream;
  fsave: TSaveDialog;
begin
  DeleteSelected(false);
  fsave:=TSaveDialog.Create(self);
  fsave.Options:=fsave.Options+[ofOverwritePrompt];
  fsave.Filter:='Файлы формы(*.frm )|*.frm' ;
  if fsave.Execute then
  begin
     if ExtractFileExt(fsave.FileName)<>'.frm' then fsave.FileName:=fsave.FileName+'.frm';
     if not FileExists(fsave.FileName) then fs:=TFilestream.Create(fsave.FileName,fmCreate) else
      fs:=TFilestream.Create(fsave.FileName,fmCreate);
     fsave.Free;
     savingform:=(TForm(actWind));
     FindFormExAndDel(savingform);
     fs.WriteComponent(savingform);
     fs.Free;
  end; 
end;

procedure TRedactor.SetActivWind(value: integer);
var i,k,last: integer;

begin
 // last:=fActivWind;
  {if ((value<>fActivWind) and (value<>-1)) then
    begin
     fActivWind:=value;
    end;
  if not (fsShowing in tformCuMy(actWind).FormState) then
    begin
      fActivWind:=-1;
      i:=0;
      while ((i<fRedactorForm.Count)) do
        if fsShowing in tformCuMy(fRedactorForm.Items[i]).FormState then
        begin
        fActivWind:=i;
        break;
        end else inc(i);
    end; }
end;

function TRedactor.asChildParent(Ch: TComponent; Par: TWinControl): TWinControl;
var exCh: TControl;
begin
Result:=nil;
if (Ch is TControl) then
  begin
     exCh:=(Ch as TControl);
     while ((exCh<>Par) and (exCh<>nil)) do exCh:=exCh.Parent;
     if exCh<>nil then Result:=(Ch as TControl).Parent;
  end;
end;

procedure TRedactor.SortOlder;
var i,j: integer;
    flagbool: Boolean;
    xh: TComponent;
begin
flagbool:=true;
while flagbool do
  begin
  flagbool:=false;
  for i:=0 to ComponentCount-2 do
     begin
     for j:=i to ComponentCount-1 do
        begin
        if ((Components[j] is TWinControl) and (Components[i] is TControl) and ((Components[j] as TWinControl)=(Components[i] as TControl).Parent)) then
           begin
           flagbool:=true;
           xh:=owner.Components[i];
           Removecomponent(Components[i]);
           InsertComponent(xh);
           end;
        end;
     end;
end;
end;

function TRedactor.CounObjClass(NameOb: ShortString):ShortString;
var i,r:   integer;
    h0,h1: String;
begin
R:=0;i:=0;
h1:=NameOb;
if actWind<>nil then
  begin
  while (i<TComponent(actWind).ComponentCount) do
   begin
   if TComponent(actWind).Components[i].ClassName=NameOb then inc(r);
   inc(i);
   end;
  h0:=h1+IntTostr(r);
  Delete(h0,1,1);
  while (TComponent(actWind).Findcomponent(h0)<>nil) do
   begin
   inc(r);h0:=h1+IntTostr(r);Delete(h0,1,1);
   end;
  Result:=h0;
  end;
end;

procedure TREdactor.GraphRect;

begin

end;

procedure TREdactor.RepaintALL;
var i: integer;
begin

  i:=0;
  while (I<self.ComponentCount) do
     begin
     if ((self.Components[i] is TControl) and not (self.Components[i] is TControlDDH) ) then
        begin
        (self.Components[i] as TControl).invalidate;
        end;
        i:=i+1;
     end;

end;


procedure TRedactor.PropertyForm;
var
    i: integer;
begin
   PopMenuShowTegsforForm;
   if componentcount=0 then
    begin
     ComboBox.Items.Clear;
     editO.Text:='';
     exit;
    end;
   if Combobox<>nil then
     begin
       Combobox.Text:='';
       Combobox.Items.Clear;
       if (actWind<>nil) then
         begin
            Combobox.Items.AddObject(tform(actWind).Caption,tform(actWind));
            for I:=0 to tform(actWind).ComponentCount-1 do
            Combobox.Items.AddObject(tform(actWind).Components[i].Name,tform(actWind).Components[i]);
         end;
       if Edito<>nil then
         begin
           Edito.Text:='';
           for I:=0 to GetCount-1 do
             begin
                if not (Get(i) is TForm) then Edito.Text:=Edito.Text+string(Tcomponent(Get(i)).Name) else
                    Edito.Text:=Edito.Text+string(TForm(Get(i)).caption);
                if i<>getcount-1 then Edito.Text:=Edito.Text+', ';
                    Edito.Hint:=Edito.Text;
             end
         end;
     end;
   objIn.ShowS(self as IDesigner);
   lisobj.free;

end;


procedure TRedactor.UpdateDDHinContr;
var i: integer;
begin
for i:=0 to ControlDDHList.Count-1 do
begin
 if not ((ControlDDHList.Items[i] as TControlDDH).FControl is TForm) then
  begin
    (ControlDDHList.Items[i] as TControlDDH).BoundsRect:=(ControlDDHList.Items[i] as TControlDDH).FControl.BoundsRect;
    (ControlDDHList.Items[i] as TControlDDH).FControl.update;
    (ControlDDHList.Items[i] as TControlDDH).Paint;
  end;
end;
end;

procedure TRedactor.ALSIZE(Sender: TObject);
begin
if SelectedCount>1 then
 begin
 form6.Shows(ControlDDHList);
 end;
end;

procedure TRedactor.ALALIGHN(Sender: TObject);
begin
if SelectedCount>1 then
 begin
 form3.ShowS(ControlDDHList);
 end;
end;

procedure TRedactor.ALSCALE(Sender: TObject);
begin
if (SelectedCount>0) then
 begin
 form5.ShowS(ControlDDHList);
 end;
UpdateDDHinContr;
end;

procedure TRedactor.GraphUpdate(gc: TImage);
var
    K,kj: boolean;
    h,i,wi,hi: integer;
    li: PPropList;
begin


 if TImage(gc).Picture.Bitmap=nil then
 TControlHack(gc).SetDesigning (true, false) else
  begin
     if not gc.Stretch then
        begin
         // gc.Height:=30;
         // gc.Width:=30;
        end;  

    if TImage(gc).Picture.Bitmap.Empty  then
     TControlHack(gc).SetDesigning (true, false) else
     begin
      if not gc.Stretch then
        begin
         gc.Height:=TImage(gc).Picture.Bitmap.Height;
         gc.Width:=TImage(gc).Picture.Bitmap.Width;
        end;
      //TControlHack(gc).SetDesigning (false, false)
     end;
 end;

end;

procedure TRedactor.GraphUpdateAll;
var i,j: integer;
begin
for j:=0 to fRedactorForm.Count-1 do
begin
  for i:=0 to Tform(fRedactorForm.Items[j]).ComponentCount-1 do
     begin
      if (Tform(fRedactorForm.Items[j]).Components[i] is TImage) then
           GraphUpdate(Tform(fRedactorForm.Items[j]).Components[i] as TImage);
     end;
end;
end;

function  TRedactor.IsRectControl(Rect: TRect): TRect;
 var i: integer;
     b: boolean;

 begin
 b:=true;
 result:=Rect;
 while b do
   begin
   b:=false;
   for i:=0 to CurrentParent.ControlCount-1 do
     begin
         if ((CurrentParent.Controls[i].Top=Result.Top) and
                 (CurrentParent.Controls[i].Left=result.Left)) then
                     begin
                       result.Left:=result.Left+5;
                       result.Right:=result.Right+5;
                       result.Bottom:=result.Bottom+5;
                       result.Top:=result.Top+5;
                       b:=true;
                     end;
     end;
   end;



    end;

function TRedactor.StartCreate(TCl: TClass): boolean;
var
   pt: TPoint;
begin
   result:=false;
   if sCreateObj in System then

    begin
     pt.X:=-100;
     if TCl=numCreate then
       begin
         CreateObjIMMI(TCl,pt);
         result:=true;
         System:=System-[sCreateObj];
       end else
         begin
         numCreate:=TCl;
         end;
     end  else
     begin
     System:=System+[sCreateObj];
     numCreate:=TCl;
     end;
   end;

procedure Tredactor.TubeBuild(up,down,left1,right: integer);
var i: integer;
    t: TControl;
    ow: TComponent;
begin

end;


function Tredactor.AllOneParent: boolean;
var i: integer;
    par: TWinControl;
begin
result:=true;
  if SelectedCount>1 then
     begin
     par:=(ControlDDHList.Items[0] as TControl).Parent;
     i:=1;
     while i<ControlDDHList.Count do
     begin
       if (ControlDDHList.Items[i] as TControl).Parent<>par then result:=false;
       inc(i);
     end;
      end;
if not Result then MessageBox(0,'Некоторые компоненты принадлежат разным родителям'+#13 + 'и не могут быть перемещены вместе!','Ошибка',MB_OK+MB_TOPMOST);
end;

function TRedactor.CreateNewProject: boolean;
begin
SaveAndCloseAllForm;
Form9.shows;
self.PropertyForm;
self.CreateFormPr;
end;

function TRedactor.OpenProject(dir: string): boolean;

var
  StringForm: TStringList;
  i,j: integer;
  fi: TextFile;
  filn: string;
  formf: string;
  fileNameP: string;
  fs: TFilestream;
  t,l,w,h: integer;
  vi: boolean;
  formn: Tform;
  formhide,showAllf,open: bool;
  fsave: TOpenDialog;
  scriptClass: TClass;
begin
 scriptClass:=nil;
 AppScriptPrep:=nil;
 StringForm:=TStringList.Create;

 filn:=formsDir+'config.cfg';
 try
    StringForm.LoadFromFile(filn);
 except
    MessageBox(0,' Не удалось считать файл проекта config.pfg','Ошибка',MB_OK+MB_TOPMOST+MB_ICONERROR);
    exit;
 end;


for i:=0 to StringForm.Count-1 do
   begin
     FileNameP:=formsDir+StringForm.Strings[i]+'.frm';
     if FileExists(fileNameP) then
         begin
            try
              fs:=TFilestream.Create(fileNameP,fmOpenRead);
              formn:=TForm.Create(self);
           //   formn.:=(owners as TForm);
              TFormCuMy(formn).SetDesigning(false);
              fs.ReadComponent(formn);
              FindFormExAndCreate(formn);
              fRedactorForm.Add(formn);
              if  (formn.Visible) then
                   TFormCuMy(formn).FFormState:=TFormCuMy(formn).FFormState+[fsShowing]
              else
              begin
                 TFormCuMy(formn).FFormState:=TFormCuMy(formn).FFormState-[fsShowing];
                 CurrentParent:=formn;
                 actWind:=formn;
             end;
             // showmessage(formn.name);
             ActivateWindow(formn);
            except
             MessageBox(0,PChar('Файл формы:  ' +fileNameP +' поврежден '+ char(13)+
               'или использует незарегистрированные компоненты'),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);
            end;
            if assigned(fs) then fs.Free;
        end;
    end;

 if AppScriptPrep<>nil then  AppScriptPrep.Free;
 if usescript then
 begin
 scriptClass:=findclass('TApplicationImmi');
 if scriptClass<>nil then
 begin
 AppScriptPrep:= TIMMISc(scriptClass).Create(owners);
 {AppScript:=TapplicationImmi.Create(owners);}
 if AppScriptPrep<>nil then
  begin
   if FileExists(formsDir+'AppScript.scr') then
    try
     ReadComponentresfile(formsDir+'AppScript.scr',AppScriptPrep)
    except
    end;

   AppScript:=(AppScriptPrep as IImmiScriptDesigner);
      for i:=0 to ClassTree.Count-1 do
          for j:=0 to TStringlist(ClassTree.Objects[i]).Count-1 do
              classList.Add(TUnitClass(TStringlist(TStringlist(ClassTree.Objects[i]).Objects[j])).TPClass);
   AppScript.InitMforDesigner(vi,t,l,w,h,classList,RedactorForm,self);
  end;
 end;
 end;
include(FRedactorState,rProject);
include(FRedactorState,rForm);
PropertyForm;
DisplayControl;
UpdateCheckForm;
end;





function  TRedactor.OpenForm(path: string): boolean;
var
  Openform: TForm;
  filestr: TFilestream;
  fsave: TOpenDialog;
  fileNameP: string;
begin
 OpenForm:=nil;
 if path='' then
 begin
 fsave:=TOpenDialog.Create(owners);
 fsave.InitialDir:=FormsDir;

// fsave.Options:=[];
 fsave.Filter:='Файлы форм|*.frm';
 if fsave.Execute then
     begin
     try
       filestr:=TFilestream.Create(fsave.FileName,fmOpenRead);
       Openform:=TForm.Create(self);
       TFormCuMy(OpenForm).SetDesigning(false);
       filestr.ReadComponent(OpenForm);

       FindFormExAndCreate(OpenForm);
       openform.Tag:=1;
      // TFormCuMy(openform).FFormState:=TFormCuMy(savedform).FFormState+[fsShowing];
       ShowWindD(openform);
        if appscript<>nil then  appscript.CreateComp(OpenForm,self);
      // ShowWidow.Add(savedform);
     except

       MessageBox(0,PChar('Файл формы:  ' +fsave.FileName +' поврежден '+
           char(13)+ 'или использует незарегистрированные компоненты'),'Ошибка',
                  MB_OK+MB_TOPMOST+MB_ICONERROR)
     end;
     if filestr<>nil then filestr.Free;

     end;

 fsave.Free;
 if OpenForm=nil then exit;
 if ComponentCount>0 then
 begin
 actWind:=Openform;
 self.ShowWindD(Openform);
 CurrentParent:=Openform;
 PropertyForm;
 include(FRedactorState,rForm);
 end;
 end
 else
 begin
     try
       filestr:=TFilestream.Create(path,fmOpenRead);
       OpenForm:=TForm.Create(self);
        TFormCuMy(OpenForm).SetDesigning(false);
       filestr.ReadComponent(Openform);
       FindFormExAndCreate(Openform);
       //TFormCuMy(Openform).FFormState:=TFormCuMy(savedform).FFormState+[fsShowing];
      // ActivateWindow(savedform);
       ShowWindD(openform);
     except
       MessageBox(0,PChar('Файл формы:  ' +path +' поврежден '+
           char(13)+ 'или использует незарегистрированные компоненты'),'Ошибка',
                  MB_OK+MB_TOPMOST+MB_ICONERROR);
     end;
 if filestr<>nil then filestr.Free;
 //fsave.Free;
 if OpenForm=nil then exit;
 if ComponentCount>0 then
 begin
  Openform:=openform;
 CurrentParent:=OPenform;
 PropertyForm;
 include(FRedactorState,rForm);
 end;
 end;
 UpdateCheckForm;
end;


function    TRedactor.SaveProject: boolean;
var
   FileName: string;
   i: integer;
   filestr: TFilestream;
   savingform: TForm;
   hForm: TstringList;
begin
 // showmessage('Это демонстрационная версия. Сохранений не возможно.');
 if (not (rProject in FRedactorState) and not (rProject in FRedactorState)) then exit;
 hForm:=TstringList.Create;
 hForm.Clear;
if rProject in FRedactorState then
 begin
   deleteselected(false);
       for i:=0 to  componentCount-1 do
           begin
             FileName:=Formsdir+TForm(components[i]).Caption +'.frm' ;
             if FileExists(FileName) then RenameFile(FileName,FileName+'~');
             filestr:=TFilestream.Create(FileName,fmCreate);
             savingform:=TForm(components[i]);
             FindFormExAndDel(sf);
             try
                if  savingform.Tag=9 then
                 begin
                   if MessageBox(0,Pchar('Включить форму'+ savingform.caption +' в проект ?'),
                                   'Новая форма',MB_YESNO+MB_ICONQUESTION+MB_TOPMOST)=IDYES then
                   hForm.Add(savingform.caption);
                   savingform.Tag:=0;
                 end  else  hForm.Add(savingform.caption);
                 filestr.WriteComponent(savingform);
             except
                MessageBox(0,PChar(' Ошибка записи формы:  ' + savingform.Caption),'Ошибка',MB_OK+MB_TOPMOST+MB_ICONERROR);
             end;
             FindFormExAndCreate( savingform);
             if assigned(filestr) then filestr.free;
          end;
 end;

if assigned(AppScript) then
begin
   try
   AppScript.SaveM;
   FileName:=Formsdir+'AppScript.scr';
   if not FileExists(FileName) then fileclose(filecreate(FileName));
   WriteComponentResFile(Formsdir+'AppScript.scr',AppScriptPrep);
   except
   end;
end;
HForm.SaveToFile(FormsDir+'config.cfg');
HForm.Free;
end;

function   Tredactor.SaveAndCloseAllForm;
var i,k: integer;
formd: Tform;
begin

result:=true;
if not (rProject in FRedactorState) then
  begin
     for i:=0 to componentCount-1 do
        begin
        //  k:=MessageBox(0,PChar('Сохранить форму '+ tform(components[I]).caption  +'?'),'Сохранение форм',MB_YESNOCANCEL+MB_ICONQUESTION+MB_TOPMOST);
           k:=idNo;
          if k=IDCANCEL then
             begin
                 result:=false;
                 exit;
             end;
          if k=IDYES then
             begin
                 Actwind:=tform(components[i]);
                 SaveFormAs;
                 if Componentcount>0 then
                    begin
                         Actwind:=tform(components[0]);
                         PropertyForm;
                    end else ClearInstrument;
             end;
        end;
        while ComponentCount>0 do
          begin
              self.RemoveComponent(formd);
             formd:= TForm(components[0]);
             FreeAndNil(formd);

          end;
  end
else
  begin
       result:=CloseProject;
  end;
end;

procedure   Tredactor.ConfProjForm;
var Dlg: TForm11;
begin
if rProject in FRedactorState then
  begin
     try
       Dlg:=TForm11.Create(owners);
       Dlg.Red:=self;
       Dlg.shows(fDirProject);
     finally
       Dlg.Free;
     end;

   end;
end;

procedure Tredactor.showForm;

begin

   if Form10=nil then Form10:=TForm10.Create(owners);
   Form10.Redac:=self;
   DeleteSelected(true);
   Form10.shows;


end;

procedure   TRedactor.FindFormExAndCreate(form: TForm);
var j: integer;
bmm: TBitmap;
contain: TContainerComponent;

begin
j:=0;
  if ((form=nil) or (fProjectBitmap=nil)) then Exit;
   tc:=TControlHack(form).FComponentStyle;
   ts:=form.ComponentState;
   cs:=form.ControlStyle;
   fs:=form.FormState;
  while j<form.ComponentCount do
      begin

       if (form.Components[j].ClassName='TIMMIFormExt') then
                                  begin
                                  bmm:=TBitmap.Create;
                                  bmm.Assign(fProjectBitmap);
                                  if boolean(getordprop(TObject(form.Components[j]),'ProjectImage')) then
                                  SetObjectProp(TObject(form.Components[j]),'BackBitmap',bmm);
                                  end;
       if not (form.Components[j] is TControl) then
         begin
          contain:=TContainerComponent.Create(form.Components[j]);
          contain.Parent:=form;
          contain.After(self);
          contain.Visible:=true;
         end;
         inc(j);
       end;

end;

procedure  TRedactor.FindFormExAndDel(form: TForm);
var j,i: integer;
    bmm: TBitmap;
begin
j:=0;
  if ((form=nil) or (fProjectBitmap=nil)) then Exit;
  while j<form.ComponentCount do
      begin
       if (form.Components[j].ClassName='TIMMIFormExt') then
                                  begin
                                  bmm:=TBitmap.Create;
                                  bmm.Assign(fProjectBitmap);
                                  if boolean(getordprop(TObject(form.Components[j]),'ProjectImage')) then
                                  SetObjectProp(TObject(form.Components[j]),'BackBitmap',nil);
                                  end;
         if not (form.Components[j] is TControl) then
         begin
            i:=0;
               while i<form.Components[j].ComponentCount do
                 begin
                    if form.Components[j].Components[i] is TContainerComponent then
                      begin
                        (form.Components[j].Components[i] as TContainerComponent).SettoTag;
                        (form.Components[j].Components[i] as TContainerComponent).Free;
                      end;
                    inc(i);
                 end;
         end;
          inc(j);
           end;

end;

function   TRedactor.CloseProject;
var ans,i: integer;
fr: TForm;
begin
  i:=0;
  result:=true;
  ans:=MessageBox(0,'Сохранить изменения в проекте?','Сохранение',MB_YESNOCANCEL+MB_ICONQUESTION+MB_TOPMOST);
  if ans=IDCANCEL then
    begin
      result:=false;
      Exit;
    end;
  //objIn.DeleteAlls;
  if ans=IDYES then SaveProject;
    ClearInstrument;
    self.DeleteSelected(true);
    if appscriptPrep<>nil then
      begin
      // appscriptPrep.Free;
      // appscriptPrep:=nil;
     //  appscript:=nil;
      end;
   while 0<ComponentCount do
     begin

         if Components[0] is TForm then
           begin

              fr:=TForm(Components[0]);
              self.RemoveComponent(fr);
              FreeAndNil(fr);
             //fRedactorForm.Delete(0);
           end;

     end;
ClearInstrument;
exclude(FRedactorState,rProject);
exclude(FRedactorState,rForm);
fcopytrue:=false;
updatelist;
//fRedactorForm.Clear;
DeletefromTree;

end;

procedure  TRedactor.CloseForm;
 var
  ans: integer;
  formc: Tform;
begin
   if (rForm in FRedactorState) then
      begin
       if ({(fRedactorForm.count>ActivWind) and }
              (TFOrm(actWind)<>nil)) then
            begin
                 ans:=MessageBox(0,PChar('Сохранить форму "'+TForm(actWind).Caption+'"?'),'Сохранение ajhvs',MB_YESNOCANCEL+MB_ICONQUESTION+MB_TOPMOST);
                 if ans=IDCANCEL then  Exit;

                 if ans=IDYES then SaveFormAs;
                 removecomponent(actWind);
                 formc:=TForm(actWind);
                 FreeAndNil(formc);

                 if componentCount>0 then
                   begin
                    actWind:=Components[0] as tform;
                    PropertyForm;
                   end
                 else self.ClearInstrument;
            end;
      end;
      if componentcount=0 then  exclude(FRedactorState,rForm);

   UpdateCheckForm;
   DeletefromTree;
end;


procedure   TRedactor.AnalogMem(dir: string);
var i: integer;

begin


if assigned(rtitems) then
rtitems.free;

 if dir='' then exit;
rtitems:=Tamem.Create(dir);
fCommandList.Clear;
fCommentList.Clear;
  for i:=0 to (rtitems as Tamem).Count-1 do
   begin
    fCommentList.Add((rtitems as TaMem).GetComment(i));
    fCommandList.Add((rtitems as Tamem).GetName(i));
   end;
end;


procedure   TRedactor.CHangeForm(Sender: TObject);
var i: integer;
    find: boolean;
    OpenPi: TForm18;
    chbit: TBitmap;
begin
i:=0;
if lastwind<>nil  then
begin
find:=false;
if (lastwind is TForm) then
  begin
    while ((i<(lastwind as TForm).componentcount) and not find) do
        if (lastwind as TForm).components[i].ClassName='TIMMIFormExt' then find:=true else inc(i);
    if find then
      begin
        chbit:=TBitmap.Create;
        OpenPi:=TForm18.Create(owners);

        if ((fProjectBitmap<>nil)) then OpenPi.BitmapProject.Assign(fProjectBitmap);
       OpenPi.ImagProject:=boolean(getordprop((lastwind as TForm).components[i],'ProjectImage'));
        if  OpenPi.ImagProject then
        OpenPi.CheckBox1.Checked:=true
        else OpenPi.CheckBox1.Checked:=false;
        chbit.Assign(GetObjectProp((lastwind as TForm).components[i],'BackBitmap',Tbitmap) as Tbitmap);
        OpenPi.RedBit(chbit);
        SetObjectProp(TObject((lastwind as TForm).Components[i]),'BackBitmap',chbit);
        SetOrdProp(TObject((lastwind as TForm).Components[i]),'ProjectImage',integer(OpenPi.ImagProject));
        OpenPi.Free;
      end;
  end;
lastwind:=nil;
end;
end;

procedure   TRedactor.FixedElement;
var i,j: integer;
    forf: TFormFix;
begin
fTComList.Clear;
for i:=0 to fRedactorForm.Count-1 do
 begin
   for j:=0 to Tform(fRedactorForm.Items[i]).ComponentCount-1 do
     if not (Tform(fRedactorForm.Items[i]).Components[j] is TControlDDH) then
     fTComList.Add(Tform(fRedactorForm.Items[i]).Components[j]);
 end;
   forf:= TFormFix.Create(owners);
   forf.AddRed(self);
   forf.showmodal;
   forf.Free;
end;

procedure   Tredactor.FIXED(Sender: TObject);
var I: integer;
begin
for i:=0 to ControlDDHList.Count-1 do
    Tcomponent((ControlDDHList.Items[i] as Tcontrolddh).FControl).Tag:=100;
DeleteSelected(true);
end;


procedure   Tredactor.UnFIXED(Sender: TObject);
var I: integer;
begin
if not (sender is TForm) then exit;
for i:=0 to (sender as TForm).ControlCount-1 do
  if not ((sender as TForm).Controls[i] is Tcontrolddh) then
    Tcomponent((sender as TForm).Controls[i]).Tag:=0;
end;

procedure Tredactor.PopMenuShowTegs(Sender: TObject);
var
  IdentStrings: TStringList;
  i, j: integer;
  Expr: TExpretion;
  TypeData: PTypeData;
  Props: PPropList;

  procedure AddPropertyList(Source: TObject; IdentStrings: TStringList);
  var
    //IMMIProp: TIMMIImgPropertys;
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;


  begin
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполняем список всех используемых идентификаторов
         Expr.Expr := GetStrProp(Source, Props^[i]^.Name);
         Expr.AddIdentList(IdentStrings);
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
             AddPropertyList(ChildProp, IdentStrings);
         end;
   finally
     Freemem(Props);
   end;
  end;

  procedure ReplaceIdent(Source: TObject; SourceStr, DestinationStr: String);
  //заменяет идентификаторы в строках типа TExprStr,
  //проходя по всем вложенным объектам
  var
    //IMMIProp: TIMMIImgPropertys;
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;
  begin
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполняем список всех используемых идентификаторов
         Expr.Expr := GetStrProp(Source, Props^[i]^.Name);
         Expr.ReplaceIdent(SourceStr, DestinationStr);
         SetStrProp(Source, Props^[i]^.Name, Expr.Expr);
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
               ReplaceIdent(ChildProp, SourceStr, DestinationStr);
         end;
   finally
     Freemem(Props);
   end;
  end;

begin
 IdentStrings := TStringList.Create;
 try
   Expr := TExpretion.Create;
   IdentStrings.Duplicates := dupIgnore;
   IdentStrings.Sorted := True;
   for i := 0 to ControlDDHList.Count - 1 do
     AddPropertyList((ControlDDHList.Items[i] as TControlDDH).FControl, IdentStrings);

   if IdentStrings.Count > 0 then
     with TfrmShowTegs.create(Self.owners) do
     begin
       try
         StringGrid1.RowCount := IdentStrings.Count;
         for i := 0 to IdentStrings.Count - 1 do
           StringGrid1.Cells[0, i] := IdentStrings.Strings[i];
         if ShowModal = mrOK then
           for j := 0 to IdentStrings.Count - 1 do
             if StringGrid1.Cells[0, j] <> IdentStrings.Strings[j] then
             //Во всех выражениях меняем идентификаторы
               for i := 0 to ControlDDHList.Count - 1 do
                 ReplaceIdent((ControlDDHList.Items[i] as TControlDDH).FControl, IdentStrings.Strings[j], StringGrid1.Cells[0, j]);
       finally
         free;
       end;
     end
   else
     ShowMessage('Нет связанных тегов');
 finally
   IdentStrings.free;
   Expr.Free;
 end;
end;


procedure   TRedactor.SelectAll;
var i: integer;
begin
{if ((ActivWind<0) or (ActivWind>fRedactorForm.Count-1)) then exit; }
deleteselected(false);
for i:=0 to TForm(actWind).ControlCount-1 do
                SelectControl(TForm(actWind).Controls[i],false);

PropertyForm;
end;




procedure TRedactor.changeScaleConr(Cont: Tcontrol;xsc: real; ysc: real);
var lt: Tpoint;
    lt1: Tpoint;
    fn: TFont;
begin
lt:=cont.BoundsRect.TopLeft;
lt1:=cont.BoundsRect.BottomRight;
ClientToScreen(0,lt);
ClientToScreen(0,lt1);
lt.X:=round(lt.X*Xsc);
lt.Y:=round(lt.Y*Ysc);
lt1.X:=round(lt1.X*Xsc);
lt1.Y:=round(lt1.Y*Ysc);
screentoClient(0,lt);
screentoClient(0,lt1);
   cont.Left:=lt.X;
   cont.Top:=lt.y;
     cont.width:=round(lt1.X-lt.x);
     cont.Height:=round(lt1.y-lt.y);

   if cont is TImage then
   begin
     setordprop(TObject(cont),'Stretch',integer(true));
   end;

   if GetPropinfo(TObject(cont),'TFont')<>nil then
    begin
   fn:=TFont(getOrdProp(TObject(cont),'Font'));
   fn.Size:=round(fn.Size*Ysc);
   setordprop(TObject(cont),'Font',integer(fn));
    end;
end;


procedure TRedactor.scaleForm(Form: TForm;xsc: real; ysc: real);
var i: integer;
begin
  form.Top:=round(form.Top*ysc);
  form.Left:=round(form.Left*xsc);
  form.Height:=round(form.height*ysc);
  form.width:=round(form.Width*xsc);
  for i:=0 to form.ControlCount-1  do
   changeScaleConr(form.Controls[i],xsc,ysc);
end;

procedure TRedactor.ShowNextForm(val: boolean);
var i: integer;
begin
{if ActivWind=fRedactorform.Count-1 then i:=0 else i:=ActivWind+1;
if val then TForm(actWind).Hide;
ActivWind:=i;
TForm(actWind).Show;        }
end;




procedure TRedactor.ConnectPackage(path: string);
var flags : integer;
    HPack: HModule;
begin
 Hpack:=LoadPackage(path);
 ModuleList.Add(inttostr(integer(Hpack)));
 GetPackageInfo(Hpack, @Hpack, Flags, everyunit);
end;

procedure EveryUnit(const Name: string; NameType: TNameType; Flags: Byte; Param: Pointer);

var

  namep: string;
  Registerproc : procedure;
  regitem: function(p: Pointer;t: Pointer;t2: pointer;t3: pointer): pointer;
begin
//ssss:= Pinteger(param)^;
  if nametype <> ntContainsUnit then exit;
  nameP:='@' + LowerCaseForPackage(Name) + '@Register$qqrv';
  @RegisterProc := getprocaddress(Pinteger(param)^, PChar(nameP));
  if @RegisterProc <> nil then
  begin
    try
    RegisterComponentEditorProc := BwRegisterComponentsEditor;
//    RegisterPropertyEditorProc :=  bwRegisterPropertyEditorProc;
    RegisterProc();
    except
    end;
  end;
  nameP:='@' + LowerCaseForPackage(Name) + '@Regrtitems$qqrpvt1t1t1';
  @regitem := getprocaddress(Pinteger(param)^, PChar(nameP));
  if @regitem <> nil then
  begin
   kkl:=Tanalogmems(regitem(rtitems,nil,nil,nil));
  end;
end;

procedure BwRegisterComponentsEditor(ComponentClass: TComponentClass;
  ComponentEditor: TComponentEditorClass);
  var i,j: integer;
begin
  selff.fClassTree.addEditor(ComponentClass,ComponentEditor);
end;




procedure BwRegisterComponents(const Page: string;
  const ComponentClasses: array of TComponentClass);
var i : integer;

begin
  for i := low(ComponentClasses) to High(ComponentClasses) do
  begin
    RegisterClass(TPersistentClass(ComponentClasses[i]));
    selff.fClassTree.addClass(ComponentClasses[i],FindBitmap(HModule(strtoint(selff.ModuleList.Strings[selff.ModuleList.count-1])),ComponentClasses[i].ClassName),page);
    selff.classregister.Add(ComponentClasses[i]);
  end;
end;


function LowerCaseForPackage(A: String): string;
    var
     b: string;
begin
   if Length(A)<1 then exit;
   result:=LowerCase(A);
   b:=UpperCase(Copy(result,1,1));
   delete(result,1,1);
   result:=b+result;
end;

procedure Tredactor.ConnectPackages(path: string);
var i: integer;
    strl: TStringList;
    libstr: string;
begin
//strl:=TStringList.Create;
 libstr:='NS_Component.bpl';
if fileexists(libstr) then
ConnectPackage(libstr) else
MessageBox(0,PChar('Файл библиотекки: '+libstr),'Ошибка',
                 MB_OK+MB_TOPMOST+MB_ICONERROR);

 exit;
  if fileexists({ExeDir+}path) then
          strl.LoadFromFile({ExeDir+ }path)
  else
   begin
       MessageBox(0,PChar('Файл пакетов:  ' +{ExeDir + } path +'не найден'),'Ошибка',
                  MB_OK+MB_TOPMOST+MB_ICONERROR);
   end;
for i:=0 to strl.Count-1 do
  if fileexists(strl.Strings[i]) then ConnectPackage(strl.Strings[i]);
if strl<>nil then strl.Free;
end;

function FindBitmap(HM: HModule; A: String): TBitmap;
var
  ResInfo: HRSRC;
  bitm: TBitmap;
  uts: Tinifile;
  strl: TStringList;
begin
  bitm:=TBitmap.Create;
  Result := bitm;
  if FindResource(HM,PChar(Uppercase(A)),RT_BITMAP)<>0 then
    try
      result.LoadFromResourceName(HM,Uppercase(A));
    except
      result.Assign(selff.noiconbm);
    end
  else  result.Assign(selff.noiconbm);
end;


procedure Tredactor.EditPackage(path: string);
var FormP: TFormPackage;
begin
 try
   FormP:=TFormPackage.Create(owners);
   if fileexists(path) then  Formp.Memo1.Lines.LoadFromFile(path)
   else fileclose(filecreate(path));
   if Formp.ShowModal=mrOk then Formp.Memo1.Lines.SaveToFile(path);
 finally
   FormP.Free;
 end;
end;


procedure Tredactor.Activate;
begin

end;

procedure Tredactor.Modified;
begin
   if GetCount=1 then
      begin
         if Get(0) is TForm then
                           ActivateWindow(Get(0) as TForm);
      end;
   if objIn.curEditor=tkClass then
          PropertyForm
   else objIn.UpdateRight;
   UpdateSelectionR;
end;

function Tredactor.CreateMethod(const Name: string; TypeData: PTypeData): TMethod;
var strPr: string;
 P: PChar;
  I,j: Integer;
 // l: mAlParamList;
  strnam: string;
  strtype: string;

begin

if appscript<>nil then  result:=AppScript.CreateMethod(name,typedata,self);

end;

function Tredactor.GetMethodName(const Method: TMethod): string;
var i: integer;
begin
result:='';
if not (assigned(Method.Data)) then exit;
if not (assigned(appscript)) then exit;
try
result:=pmrthinf(Method.Data)^.names;
except

end;
//if (assigned(Method.Data)) and (assigned(Method.Code)) then
// begin
  // if Method.Code=@MyAllMethods then
    //  result:=pmrthinf(Method.Data)^.names;
  //  end;
end;

procedure Tredactor.GetMethods(TypeData: PTypeData; Proc: TGetStrProc);
begin
if appscript<>nil then AppScript.GetMethods(TypeData,Proc);

end;

function Tredactor.GetPathAndBaseExeName: string;
begin
end;

function Tredactor.GetPrivateDirectory: string;
begin
end;

function Tredactor.GetBaseRegKey: string;
begin
end;

function Tredactor.GetIDEOptions: TCustomIniFile;
begin
end;

procedure Tredactor.GetSelections(const List: IDesignerSelections);
begin
end;

function Tredactor.MethodExists(const Name: string): Boolean;
begin
if appscript<>nil then  result:=AppScript.MethodExists(name)
end;

procedure Tredactor.RenameMethod(const CurName, NewName: string);
begin
 if appscript<>nil then AppScript.RenameMethod(CurName, NewName,self);
end;

procedure Tredactor.SelectComponent(Instance: TPersistent);
var i: integer;
  begin
    if (Instance is TControlDDH) then exit;
    if (Instance is TContainerComponent) then exit;
       for i:=0 to getCount-1 do
           if get(i) = Instance then exit;
    if instance is tform then
      begin
        DeleteSelected(true);
        exit;
      end;
     // if not (pShift in Keys) then DeleteSelected(false);
     if instance is tControl then SelectControl(Instance as TControl,true)
     else if (instance is tComponent) then
          begin
            for i:=0 to (instance as tComponent).ComponentCount-1 do
               if (instance as tComponent).Components[i] is TContainerComponent then
                  SelectControl((instance as tComponent).Components[i] as tcontrol,true);
                  PropertyForm;
                  SelectTree;
          end;
    // PropertyForm;
    // SelectTree;
end;

procedure Tredactor.SetSelections(const List: IDesignerSelections);
begin
end;

procedure Tredactor.ShowMethod(const Name: string);
begin
 if appscript<>nil then  AppScript.StartRedactor(name);
end;

procedure Tredactor.GetComponentNames(TypeData: PTypeData; Proc: TGetStrProc);
var i: integer;
begin
  if ((actWind<>nil)) then
     begin
       i:=0;
         while i<tform(actWind).ComponentCount do
           begin
             if  (tform(actWind).Components[i] is TypeData^.ClassType) then Proc(tform(actWind).Components[i].Name);
             inc(i);
           end;
     end;
end;

procedure Tredactor.SetMethodInConnect(comp: TComponent; NameEvent: string; procName: String);
begin
  // AppScript.SetMethodInConnect(comp, NameEvent, procName);
end;



function Tredactor.GetComponent(const Name: string): TComponent;
begin
   if ((actWind<>nil)) then
        begin
          result:=nil;
          result:=tform(actWind).FindComponent(Name);
        end;
end;

function Tredactor.GetComponentName(Component: TComponent): string;
begin
      result:=Component.Name;
end;

function Tredactor.GetObject(const Name: string): TPersistent;
begin

end;

function Tredactor.GetObjectName(Instance: TPersistent): string;
begin
  result:='';
  if not assigned(Instance) then exit;
  if Instance is TForm then result:=(Instance as TForm).Name else
  begin
  if (Instance is TComponent) then
   begin
     if assigned((Instance as TComponent).Owner) then
        result:=(Instance as TComponent).Owner.Name+(Instance as TComponent).name
           else  result:='NoOwner'+(Instance as TComponent).name
  end;
  end;
end;

procedure Tredactor.GetObjectNames(TypeData: PTypeData; Proc: TGetStrProc);
begin
end;

function Tredactor.MethodFromAncestor(const Method: TMethod): Boolean;
begin
result:=false;
end;

function Tredactor.CreateComponent(ComponentClass: TComponentClass; Parent: TComponent;
      Left, Top, Width, Height: Integer): TComponent;
begin
   if ((actWind<>nil)) then
      result:=ComponentClass.Create(Parent);
end;

function Tredactor.CreateCurrentComponent(Parent: TComponent; const Rect: TRect): TComponent;
begin
end;

function Tredactor.IsComponentLinkable(Component: TComponent): Boolean;
begin
end;

function Tredactor.IsComponentHidden(Component: TComponent): Boolean;
begin
end;

procedure Tredactor.MakeComponentLinkable(Component: TComponent);
begin
end;

procedure Tredactor.Revert(Instance: TPersistent; PropInfo: PPropInfo);
begin
end;

function Tredactor.GetIsDormant: Boolean;
begin
end;

procedure Tredactor.GetProjectModules(Proc: TGetModuleProc);
begin
end;

function Tredactor.GetAncestorDesigner: IDesigner;
begin
 result:=self;
end;

function Tredactor.IsSourceReadOnly: Boolean;
begin
end;

function Tredactor.GetScrollRanges(const ScrollPosition: TPoint): TPoint;
begin
end;

procedure Tredactor.Edit(const Component: TComponent);
begin
end;

procedure Tredactor.ChainCall(const MethodName, InstanceName, InstanceMethod: string;
TypeData: PTypeData);
begin
end;

procedure Tredactor.CopySelection;
begin
end;

procedure Tredactor.CutSelection;
begin
end;

function Tredactor.CanPaste: Boolean;
begin
end;

procedure Tredactor.PasteSelection;
begin
end;

procedure Tredactor.DeleteSelection(ADoAll: Boolean = False);
begin
end;

procedure Tredactor.ClearSelection;
begin
end;

procedure Tredactor.NoSelection;
begin
end;

procedure Tredactor.ModuleFileNames(var ImplFileName, IntfFileName, FormFileName: string);
begin
end;

function Tredactor.GetRootClassName: string;
begin
result:=actWind.ClassName;
end;

function Tredactor.UniqueName(const BaseName: string): string;
begin
end;

function Tredactor.GetRoot: TComponent;
begin
  result:=self;
end;

function Tredactor.GetShiftState: TShiftState;
begin
end;

procedure Tredactor.ModalEdit(EditKey: Char; const ReturnWindow: IActivatable);
begin
end;

procedure Tredactor.SelectItemName(const PropertyName: string);
begin
end;

procedure Tredactor.Resurrect;
begin
end;

function Tredactor.GetActiveClassGroup: TPersistentClass;
begin
end;

function Tredactor.FindRootAncestor(const AClassName: string): TComponent;
begin
result:=self.actWind;
end;

function Tredactor.Add(const Item: TPersistent): Integer;
begin
end;

function Tredactor.Equals(const List: IDesignerSelections): Boolean;
begin
end;

function Tredactor.Get(Index: Integer): TPersistent;
  begin
       result:=nil;
       if (ControlddhList.Count>0) and (ControlddhList.Count>Index) then
             begin
                 result:=TPersistent(TControlddh(ControlddhList.Items[Index]).FControl);// else
                 if result is TContainerComponent then
                     result:= (result as TContainerComponent).Owner;
             end else
             begin
               if ((actWind<>nil) and
                                   (Index=0)) then result:= actWind
             end

  end;

function Tredactor.GetCount: Integer;
begin
   result:=ControlddhList.Count;
        if ((result=0) and
                          (actWind<>nil)) then result:= 1;
end;

function Tredactor.fgetFormasList:    TList;
begin
    result:=ffl;
end;

procedure Tredactor.addForm;
  begin
          ffl.Clear;
          ffl.Add(actWind);
  end;

function Tredactor.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
   result:=  inherited QueryInterface( IID, Obj);
end;

procedure TRedactor.Notification(AnObject: TPersistent; Operation: TOperation);
begin
end;


Procedure TContainerComponent.After(Red: Tredactor);
var bm: TBitmap;
begin
  bm:=Red.fClassTree.findBitmap(Owner.ClassType);
  width:=bm.Width;
  height:=bm.Height;
  Picture.Bitmap:=bm;
  if Parent<>nil then
     begin
       top:=round (((owner.Tag and $FFFF) * 1.0 ) / ($FFFF * 1.0 )  * Parent.Height);
       left:=round (((owner.Tag and $FFFF0000) shr 16 * 1.0 ) / ($FFFF * 1.0 )  * Parent.Width);
     end;
end;

Procedure TContainerComponent.SettoTag;
var t,l: integer;
begin
  if Parent<>nil then
     begin
       t:=round ( $FFFF * (top * 1.0) / parent.Height );
       l:=round ( $FFFF * (left * 1.0) / parent.Width );
       Owner.Tag:=t or (l shl 16);
     end;
end;



function TRedactor.GetCustomForm: TCustomForm;
begin
end;

procedure TRedactor.SetCustomForm(Value: TCustomForm);
begin
end;

function TRedactor.GetIsControl: Boolean;
begin
end;

procedure TRedactor.SetIsControl(Value: Boolean);
begin
end;

function TRedactor.IsDesignMsg(Sender: TControl; var Message: TMessage): Boolean;
var   flag: boolean;
      menp: TPoint;
      actHandl: HWND;
      cont: TControl;
      i: integer;
      fmsg: TsmallPoint;
      selforParent: TWinControl;
      Msg: tagMsg;

begin
     if sender is TForm then system:=system+[sOnForm] else system:=system-[sOnForm];
     if sender is TWinControl then system:=system+[sMouseContIsWin] else system:=system-[sMouseContIsWin];
     if sender is TControlDDH then
      begin
      system:=system+[sRedac];
      DDHControl:=sender as TControlDDH;
      end
      else
      begin
      system:=system-[sRedac];
      DDHControl:=nil;
      end;
     if sender.Parent<>CurrentParent then system:=system+[sChangePar] else system:=system-[sChangePar];

     Msg.pt.x:=Message.LParamLo;
     Msg.pt.y:=Message.LParamHi;
     if (message.Msg = WM_LBUTTONDOWN) or
                  (message.Msg = WM_LBUTTONUP) or
                         (message.msg = WM_RBUTTONUP) or
                            (message.Msg=WM_LBUTTONDBLCLK) then
                            begin
                             if (sender is TForm) then actWind:=(sender as tform) else
                             if  sender.Owner is TForm then actWind:=(sender.owner as tform);{ else
                              actWind:=(sender.owner.owner as tform); }
                             if actWind<>lastactWind then lastactWind:=actWind;
                            end;

      mouseControl:=sender;

     if MouseControl is TControlDDH then MouseControl:=(MouseControl as TControlDDH).FControl;
     if Mousecontrol<>nil then Msg.pt:=Mousecontrol.ClientToScreen(Msg.pt);

      if (GetAsyncKeyState(VK_LBUTTON)<>0) then
      begin
      if not (pMouseLeftDown in KeyBord) then
       System:=system-[sSelect,Sdrag];
       KeyBord:=KeyBord+[pMouseLeftDown];

      end
   else
      begin
     // handled:=true;

               {if ((sDrag in System) and  not
                                 (sDragTwo in System)) then
                   begin
                     Msg.pt.X:=(Msg.pt.X div  4)*4;
                     Msg.pt.y:=(Msg.pt.y div  4)*4;}
                    // System:=System+[sDragtwo]-[sMoved];

                     {MoveContEnd((Msg.pt));
                   end; }

      KeyBord:=KeyBord-[pMouseLeftDown];
      end;



      result:=false;
       begin
           

           if ((message.Msg = WM_LBUTTONDOWN)) then
             begin
               lastPoint:=Msg.pt;
              // oprWindow(Msg.pt);

               if (sCreateObj in System)  then
                  begin
                    if (Mousecontrol is TWinControl) then
                    MustBeParent:=(Mousecontrol as TWinControl) else
                    MustBeParent:=Mousecontrol.Parent;
                    ChangeParent;
                    CreateObjIMMI(numCreate,msg.pt);
                    System:=System-[sCreateObj];
                    result:=true;
                    Exit;
                  end;
               if (not (pShift in KeyBord) and
                        not (pCntrl in KeyBord) and
                              (sOnForm in System) and
                                            (sMouseContIsWin in System)  and
                                                                (SelectedCount>0)) then
                   begin
                     MustBeParent:=(Mousecontrol as TWinControl);
                     ChangeParent;
                     result:=true;
                     Exit;
                   end;

               if (((pCntrl in KeyBord) or
                              (sOnForm in System))) then
                   begin
                     if (sMouseContIsWin in System) then
                            MustBeParent:=(Mousecontrol as TWinControl)
                     else
                            MustBeParent:=Mousecontrol.Parent;
                     if (MustBeParent<>CurrentParent) then ChangeParent;
                         System:=System+[sSelect];
                         
                         PosisSelect.StartSelecting(msg.pt);
                         result:=true;
                         Exit;
                   end;

                if ((pShift in KeyBord) and not
                                    (sDrag in System)  and  not
                                                 (sRedac in System)  and not
                                                             (sChangePar in System))  then
                   begin
                        //if not (pShift in KeyBord) then    DeleteSelected(false);
                        SelectControl(MouseControl,true);

                        PropertyForm;
                        SelectTree;
                        SetDr(Msg.pt);
                       // PropertyForm;
                        result:=true;
                        Exit;
                   end;

                if (not (pShift in KeyBord) and not
                                    (sDrag in System)  and not
                                                (sRedac in System)  and not
                                                             (sChangePar in System))  then
                   begin
                         cont:=MouseControl;
                         DeleteSelected(false);
                         SelectControl(cont,true);
                         PropertyForm;
                         SelectTree;
                         SetDr(Msg.pt);
                         //PropertyForm;
                         result:=true;
                         Exit;
                   end;

                if ((pShift in KeyBord) and not
                                    (sDrag in System)  and
                                                   (sRedac in System) and not
                                                             (sChangePar in System))  then
                   begin
                         SetDr(Msg.pt);
                         result:=true;
                         Exit;
                   end;


                if ((pShift in KeyBord) and
                                    (sDrag in System)  and  not
                                                   (sRedac in System) and not
                                                             (sChangePar in System))  then
                   begin
                         SetDr(Msg.pt);
                         SelectControl(MouseControl,true);

                         PropertyForm;
                         SelectTree;
                         result:=true;
                         Exit;
                   end;    

                if ( not (sRedac in System) and
                                      (sChangePar in System)) then
                   begin
                         cont:=MouseControl;
                         MustBeParent:=MouseControl.parent;
                         ChangeParent;
                         SelectControl(cont,true);

                         PropertyForm;
                         SelectTree;
                         SetDr(Msg.pt);
                        // PropertyForm;
                         result:=true;
                         Exit;
                   end;

                if ((sRedac in System) and
                                 (sChangePar in System)) then
                   begin
                         MustBeParent:=MouseControl.parent;
                         ChangeParent;
                         SelectControl(MouseControl,true);

                         PropertyForm;
                         SelectTree;
                         SetDr(Msg.pt);
                        // PropertyForm;
                          result:=true;
                         Exit;
                   end;


                if ((sRedac in System) and
                                    not (sDrag in System))       then
                   begin
                   //  MustBeParent:=(DDHControl as TControlddh).Parent;
                     SetDr(Msg.pt);
                      result:=true;
                     Exit;
                   end;
                  result:=true;
                      Exit;
             end;

           if message.Msg = WM_LBUTTONUP then
             begin
                lastPoint:=Msg.pt;
                //oprWindow(Msg.pt);


                if ((sSelect in System)) then
                   begin
                     System:=System-[sSelect];
                     EndSelectGrope(Msg.pt);
                     PosisSelect.BoolSelect:=false;
                     DDHContPaint;
                      result:=true;
                     Exit;
                   end;

                if ((sDrag in System) and  not
                                 (sDragTwo in System)) then
                   begin
                     System:=System+[sDragTwo]-[sDrag]-[sMoved];
                     MoveContEnd((Msg.pt));
                     result:=true;
                     Exit;
                   end;

                if ((pShift in KeyBord) and
                                 (sDragTwo in System) and
                                   (sRedac in System) ) then
                   begin
                     ControlDDHList.Remove(DDHControl);
                     self.PropertyForm;
                     SelectedCount:=ControlDDHList.Count;
                     System:=System-[sDragTwo,sDrag];
                     result:=true;
                     Exit;
                   end;

               if (not (pShift in KeyBord) and
                          (sDragTwo in System) and
                                    (sRedac in System) and
                                           (SelectedCount>1) ) then
                   begin
             
                      System:=System-[sDragTwo]-[sDrag];
                      result:=true;
                      Exit;
                   end;

              if (not (pShift in KeyBord) and
                           (sDragTwo in System) and
                                      (sRedac in System) and
                                            (SelectedCount=1) ) then
                   begin
                      System:=System-[sDragTwo,sDrag];
                      result:=true;
                      Exit;
                   end;
                result:=true;
                      Exit;


              end;

         if message.msg = WM_RBUTTONUP then

           begin
              lastPoint:=Msg.pt;
              result:=true;
              Menulist.Clear;
              fmenu.Items[0].Enabled:=false;
              fmenu.Items[1].Enabled:=false;
              fmenu.Items[2].Enabled:=false;
              fmenu.Items[3].Enabled:=false;
              fmenu.Items[4].Enabled:=false;
              fmenu.Items[5].Enabled:=false;
              fmenu.Items[6].Enabled:=false;
              fmenu.Items[7].Enabled:=false;
              fmenu.Items[8].Enabled:=false;
              fmenu.Items[9].Enabled:=false;
              fmenu.Items[10].Enabled:=false;
               fmenu.Items[11].Enabled:=false;
              if self.SelectedCount>0 then
               begin
                  fmenu.Items[0].Enabled:=true;
                  fmenu.Items[1].Enabled:=true;
                  fmenu.Items[2].Enabled:=true;
                  fmenu.Items[3].Enabled:=true;
                  fmenu.Items[4].Enabled:=true;
                  fmenu.Items[5].Enabled:=true;
                  fmenu.Items[6].Enabled:=true;
                  fmenu.Items[7].Enabled:=true;
                  fmenu.Items[8].Enabled:=true;
                  fmenu.Items[11].Enabled:=true;

               end;
              if (FindVCLWindow(msg.pt) is TForm) then
                 begin
                 lastwind:=(FindVCLWindow(msg.pt) as TForm);
                  fmenu.Items[0].Enabled:=false;
                  fmenu.Items[1].Enabled:=false;
                  fmenu.Items[2].Enabled:=false;
                  fmenu.Items[3].Enabled:=true;
                  fmenu.Items[4].Enabled:=false;
                  fmenu.Items[5].Enabled:=false;
                  fmenu.Items[6].Enabled:=false;
                  fmenu.Items[7].Enabled:=false;
                  fmenu.Items[8].Enabled:=false;
                  fmenu.Items[10].Enabled:=true;
                  fmenu.Items[9].Enabled:=false;
                  fmenu.Items[11].Enabled:=false;

                 end
              else  lastwind:=nil;

             //  oprwindow(msg.pt);
             if ((ControlDDHList.Count=1) and
             ((MouseControl is TControlDDH) or (TControlDDH(ControlDDHList.Items[0]).FControl=MouseControl)) and
                      not
                     (pShift in KeyBord))
             then  TSVMenu(nil);

              if fcopytrue then fmenu.Items[3].Enabled:=true else fmenu.Items[3].Enabled:=false;
                fmenu.Popup(msg.pt.X+10, msg.pt.Y);
                exit;
            end;

             if (message.Msg=WM_LBUTTONDBLCLK) then
           begin
            //  Dec(Message.Msg, WM_LBUTTONDBLCLK - WM_LBUTTONDOWN);
             if ((ControlDDHList.Count=1) and
             ((MouseControl is TControlDDH) or (TControlDDH(ControlDDHList.Items[0]).FControl=MouseControl)) and
                      not
                     (pShift in KeyBord) and (sRedac in System))
             then
              begin
              TSV(nil);
              //ReleaseCapture;
              //cont:=TControlDDH(ControlDDHList.Items[0]).FControl;
              // DeleteSelected(false);
               //SelectControl(cont,true);
              // ReleaseCapture;
              //System:=System+[sDrag];
          //   System:=System-[sDragTwo,sDrag,sRedac];
             //exit;
          // ((TControlDDH(ControlDDHList.Items[0])).FControl.Owner as TForm).SetFocus;
              result:=true;
             end;
             exit;
            // end;
           //handled:=true;

         end;



         end;
     result:=false;


end;

    procedure TRedactor.PaintGrid;
begin
end;

procedure TRedactor.ValidateRename(AComponent: TComponent;
      const CurName, NewName: string);
begin

end;


procedure TRedactor.ActivateWindow(form: TForm);
var Style:Integer;
    ExStyle: Integer;
    i: integer;
    par: TCreateParams;
    twin: TWinControl;
begin
    Style := 0;
    if (fsShowing in TFormCuMy(form).FFormState) then
     begin
        ShowWindow(form.Handle,SW_SHOW);
         for i:=0 to form.ComponentCount-1 do
        if form.Components[i] is TWinControl then ShowWindow((form.Components[i] as TWinControl).Handle,SW_SHOW);
        // form.BringToFront;
     end
    else
     begin
       for i:=0 to form.ComponentCount-1 do
          if form.Components[i] is TWinControl then ShowWindow((form.Components[i] as TWinControl).Handle,SW_HIDE);
       ShowWindow(form.Handle,SW_HIDE);
     end;
    TFormCuMy(form).SetDesigning(true,true);
    form.Designer:=self;
    for i:=0 to form.ComponentCount-1 do
            if ((form.Components[i] is TImage) and
                  ((form.Components[i] as TImage).Picture.Bitmap.Empty=false)) then
                  begin
                 // TControlHack(form.Components[i]).SetDesigning(false,false);
                 // TControlImage.Create(form.Components[i] as tcontrol);
                  end;
end;

procedure TRedactor.ShowWindD(form: TForm);
begin
    TFormCuMy(form).FFormState:=TFormCuMy(form).FFormState+[fsShowing];
    ActivateWindow(form);
    actWind:=form;
    if lastBring<>form then
      begin
       lastBring:=form;
       form.BringToFront;
      
      end;
     //DisplayControl;
 //  form.BringToFront;
 //  tform(owners).FormStyle:=fsStayOnTop;
 //  tform(owners).BringToFront;
end;

procedure TRedactor.HideWindD(form: TForm);
begin
  TFormCuMy(form).FFormState:=TFormCuMy(form).FFormState-[fsShowing];
  ActivateWindow(form);
end;

procedure TRedactor.UpdateSelectionR;
var i: integer;
begin
   for i:=0 to ControlDDHList.Count-1 do
     begin
       if  (TControlDDH(ControlDDHList.Items[i]).FControl is TImage)
                   then GraphUpdate(TControlDDH(ControlDDHList.Items[i]).FControl as TImage);
        TControlMy(TControlDDH(ControlDDHList.Items[i]).FControl).Repaint;
        TControlDDH(ControlDDHList.Items[i]).Paint;
     end;
end;

procedure TRedactor.updatelist;
var i: integer;
begin
   i:=0;
   while i<fRedactorForm.Count do
      if fRedactorForm.Items[i]=nil then fRedactorForm.Delete(i) else inc(i);
end;

procedure TRedactor.ConvActForm;
var fr: TForm;
    i: integer;
begin
{  if fActivWind>self.fRedactorForm.Count-1 then exit;
  fr:=tform(self.actWind);
  if fr<>nil then
     begin
       for i:=0 to fr.ControlCount-1 do
         fr.Controls[i].Left:=fr.Width-(fr.Controls[i].Left+fr.Controls[i].Width);
  end;   }

end;


procedure TRedactor.DisplayControl;
var i,j: integer;
     trNodeF: TTreeNodes;
     trNode:  TTreeNode;
begin
  // CompTree.Items.Clear;
  // CompTree.OnDblClick:=TreeView1Click;
   //trNodeF:=TTreeNodes.Create(CompTree);
  //for i:=0 to ComponentCount-1 do
  // begin
//     trNode:=trNodeF.AddChildObjectFirst(nil,tform(Components[i]).Caption,Components[i]);
     {if Components[i]=actWind then }
        //    DisplayComponent(trNodeF,trNode,Components[i]);{ else }
           {  begin
               while trNode.Count>0 do
                  trNode.Item[0].Delete;

             end;      }

   //end;
end;

procedure TRedactor.DisplayComponent(root: TTreeNodes; ansector:  TTreeNode; componentT: TComponent);
var i: integer;
    trNode:  TTreeNode;
begin
 //if not CompTree.Visible then exit;
 //if ComponentT is TWincontrol then
   //begin
   //  for i:=0 to (ComponentT as TWincontrol).ControlCount-1 do
    //    begin
     //   if not ((ComponentT as TWincontrol).Controls[i] is TContainerComponent) then
      //   begin
      //    trNode:=root.AddChildObject(ansector,(ComponentT as TWincontrol).Controls[i].Name,(ComponentT as TWincontrol).Controls[i]);
      //    if (ComponentT as TWincontrol).Controls[i] is TWinControl then DisplayComponent(root, trNode , (ComponentT as TWincontrol).Controls[i]);
      //   end;
    //    end;
  // end;
  for i:=0 to ComponentT.ComponentCount-1 do
   begin
     if not (ComponentT.Components[i] is TControl) then
      begin
      //   trNode:=root.AddChildObject(ansector,ComponentT.Components[i].Name,ComponentT.Components[i]);
     //    DisplayComponent(root, trNode , ComponentT.Components[i]);
      end;
   end;
end;


procedure TRedactor.Updatetree;
var i,j,fin: integer;
    fl: boolean;
begin
// if not CompTree.Visible then exit;
 //for i:=0 to self.SelectedCount-1 do
//  addTotree(Items[i] as TComponent);

end;

function TRedactor.addTotree(comp: TComponent): TTreeNode;
var j: integer;
begin
  { if not CompTree.Visible then exit;
   result:=nil;
   for j:=0 to self.CompTree.Items.Count-1 do
      if TObject(CompTree.Items[j].Data)=comp then result:=CompTree.Items[j];
   if result=nil then
     begin
      if not (comp is TControl) then
           result:=CompTree.Items.AddChildObjectFirst(addTotree(comp.Owner),comp.Name,comp)
      else
         if (comp is TForm) then
           result:=CompTree.Items.AddChildObjectFirst(nil,tform(comp as TForm).Caption,comp)
              else
                result:=CompTree.Items.AddChildObjectFirst(addTotree((comp as TControl).Parent),comp.name,comp);

     end;  }
end;

procedure TRedactor.DeletefromTree;
var j: integer;
begin
 {  if not CompTree.Visible then exit;
   if CompTree=nil then exit;
   j:=0;
   while j<CompTree.Items.Count do
      if tobject(CompTree.Items[j].Data)=nil then  CompTree.Items[j].delete else inc(j);  }
end;

procedure TRedactor.SelectTree;
var j,i: integer;
begin
  //  PopMenuShowTegsforForm;
   ///if not CompTree.Visible then exit;
  { for j:=0 to CompTree.Items.Count-1 do
      CompTree.Items[j].Selected:=false;
   for i:=0 to self.SelectedCount-1 do
     addTotree(Items[i] as TComponent).Selected:=true; }

end;


procedure Tredactor.PopMenuShowTegsforForm;
var

  i, j: integer;
  Expr: TExpretion;
  TypeData: PTypeData;
  Props: PPropList;

  procedure AddPropertyList(Source: TObject; IdentStrings: TMyStringList; exprSt: boolean);
  var
    //IMMIProp: TIMMIImgPropertys;
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;



  begin
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполняем список всех используемых идентификаторов
         Expr.Expr := GetStrProp(Source, Props^[i]^.Name);
         if exprSt then Expr.AddIdentList(IdentStrings) else IdentStrings.Add(expr.expr)
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
             AddPropertyList(ChildProp, IdentStrings, exprSt);
         end;
   finally
     Freemem(Props);
   end;
  end;


begin
// if  gridf=nil then exit;
// if TFormExprQueek(gridf).toolbutton1.Enabled then
 begin
// if MessageBox(0,Pchar('Некоторые выражения были изменнены! Сохранить изменения?'),
   //                                'Сохранение',MB_YESNO+MB_ICONQUESTION+MB_TOPMOST)=IDYES then TFormExprQueek(gridf).setDo;

 end;
 TFormExprQueek(gridf).setEnDo;
 //gridf.RowCount:=1;
 IdentStrings.Clear;
 try

   Expr := TExpretion.Create;
   IdentStrings.Duplicates := dupIgnore;
   IdentStrings.Sorted := true;
   for i := 0 to ControlDDHList.Count - 1 do
     AddPropertyList((ControlDDHList.Items[i] as TControlDDH).FControl, IdentStrings, exprtrue);
     if (IdentStrings.Count>0) and (IdentStrings.Strings[0]='') then  IdentStrings.Delete(0);
   if IdentStrings.Count > 0 then
    // with TfrmShowTegs.create(Self.owners) do
     begin
       try
         gridf.RowCount := IdentStrings.Count;
         for i := 0 to IdentStrings.Count - 1 do
           begin
           gridf.Cells[0, i] := IdentStrings.Strings[i];
           if CheckExprstr(IdentStrings.Strings[i]) then
               gridf.Rows[i].font.Color:=clGreen else gridf.Rows[i].font.Color:=clRED;
           end;
         //if ShowModal = mrOK then
           {for j := 0 to IdentStrings.Count - 1 do
             if gridf.Cells[0, j] <> IdentStrings.Strings[j] then
             //Во всех выражениях меняем идентификаторы
               for i := 0 to ControlDDHList.Count - 1 do
                 ReplaceIdent((ControlDDHList.Items[i] as TControlDDH).FControl, IdentStrings.Strings[j], StringGrid1.Cells[0, j]); }
       finally
         //free;
       end;
     end
  else
    begin
     gridf.Cells[0, 0]:='';
     gridf.RowCount:=1;
    end;
 finally
//   IdentStrings.free;
   Expr.Free;
 end;
end;


procedure TRedactor.ReplaceExpr;
  var j,i: integer;
      TypeData: PTypeData;
       Expr: TExpretion;

  procedure AddPropertyList(Source: TObject; IdentStrings: TMyStringList; exprSt: boolean);
  var
    //IMMIProp: TIMMIImgPropertys;
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;



  begin
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполняем список всех используемых идентификаторов
         Expr.Expr := GetStrProp(Source, Props^[i]^.Name);
         if exprSt then
            Expr.AddIdentList(IdentStrings)
            else
            IdentStrings.Add(expr.expr)
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
             AddPropertyList(ChildProp, IdentStrings, exprSt);
         end;
   finally
     Freemem(Props);
   end;
  end;

 procedure ReplaceIdent(Source: TObject; SourceStr, DestinationStr: String; exprb: boolean);

  //заменяет идентификаторы в строках типа TExprStr,
  //проходя по всем вложенным объектам
  var
    //IMMIProp: TIMMIImgPropertys;
    ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;
    exprProp: TExprstr;
  begin
   TypeData := GetTypeData(Source.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(Source.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполняем список всех используемых идентификаторов
         Expr.Expr := GetStrProp(Source, Props^[i]^.Name);
         exprProp:=Expr.Expr;
        if exprB then
         Expr.ReplaceIdent(SourceStr, DestinationStr);
         if not (exprB) and (ExprProp=SourceStr) then
         SetStrProp(Source, Props^[i]^.Name, DestinationStr);
         if (exprB) then
            SetStrProp(Source, Props^[i]^.Name, Expr.Expr);
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           ChildProp := GetObjectProp(Source, Props^[i]^.Name);
           if assigned(ChildProp) then
               ReplaceIdent(ChildProp, SourceStr, DestinationStr, exprtrue);
         end;
   finally
     Freemem(Props);
   end;
  end;


begin
  if  gridf=nil then exit;
  Expr := TExpretion.Create;
  //for i := 0 to IdentStrings.Count - 1 do
         //  gridf.Cells[0, i] := IdentStrings.Strings[i];
         //if ShowModal = mrOK then
           for j := 0 to IdentStrings.Count - 1 do
             begin
             if gridf.Cells[0, j] <> IdentStrings.Strings[j] then
             //Во всех выражениях меняем идентификаторы
               begin
               for i := 0 to ControlDDHList.Count - 1 do
                 ReplaceIdent((ControlDDHList.Items[i] as TControlDDH).FControl, IdentStrings.Strings[j], gridf.Cells[0, j],exprtrue);
                 IdentStrings.Replase(IdentStrings.Strings[j], gridf.Cells[0, j]);
              {if not exprtrue then }
               end;
            end;
    //IdentStrings.Clear;
              {IdentStrings.Add(gridf.Cells[0, j]);      }
               //  Replase
                // for i := 0 to ControlDDHList.Count - 1 do
                 // AddPropertyList((ControlDDHList.Items[i] as TControlDDH).FControl, , exprtrue);
 Expr.Free;
// PopMenuShowTegsforForm;
end;


procedure TRedactor.SetExprTrue(value: boolean);
begin
if value<>fExprTrue then
  begin
    fExprTrue:=value;
    PopMenuShowTegsforForm;
  end;
end;


procedure   TRedactor.UpdateCheckForm;
var i: integer;
begin
  if CheckBoxForm=nil then exit;
  CheckBoxForm.Items.Clear;
  for i:=0 to ComponentCount-1 do
    begin
      CheckBoxForm.Items.AddObject(tform(components[i]).Caption,components[i]);
      CheckBoxForm.Checked[i]:=tform(components[i]).Visible;
    end;
end;

procedure   TRedactor.incformpos(form: TForm);
var num,numnew,i: integer;
    repcomp: TComponent;
    remList: TList;
begin
num:=-1;
remList:=TList.Create;
remList.Clear;
for i:=0 to ComponentCount-1 do if form=Components[i] then num:=i;
for i:=0 to ComponentCount-1 do  remList.Add(Components[i]);
while componentcount>0 do self.RemoveComponent(components[0]);

  numnew:=num+1;
if numnew>remlist.Count-1 then numnew:=0;
 remlist.Delete(num);
 remlist.Insert(numnew,form);
 for i:=0 to remlist.Count-1 do  InsertComponent(remlist.items[i]);
 remlist.Free;
 UpdateCheckForm
end;


procedure   TRedactor.decformpos(form: TForm);
var num,numnew,i: integer;
    repcomp: TComponent;
    remList: TList;
begin
num:=-1;
 remList:=TList.Create;
 remList.Clear;
 for i:=0 to ComponentCount-1 do if form=Components[i] then num:=i;
 for i:=0 to ComponentCount-1 do  remList.Add(Components[i]);
 while componentcount>0 do self.RemoveComponent(components[0]);
 numnew:=num-1;
 if numnew<0 then numnew:=remlist.Count-1;
 remlist.Delete(num);
 remlist.Insert(numnew,form);
 for i:=0 to remlist.Count-1 do  InsertComponent(remlist.items[i]);
 remlist.Free;
 UpdateCheckForm
end;

procedure TRedactor.FindInExpr;
begin
   FormFindExpr.Execute(self);
end;

procedure TRedactor.FindInExprErr;
begin
   FormFindExprErr.Execute(self);
end;

function TRedactor.CheckExprstr(value: string): boolean;
begin
  result:=false;
  if CheckExpr(value)=cesCorr then result:=true;
end;


Procedure   TRedactor.ClearInstrument;
begin
  DeleteSelection;

  //self.objIn.Strings.Clear;
  objIn.DeleteAlls;
 // Propertyform;
  CheckBoxForm.Items.Clear;
//  CompTree.Items.Clear;
  gridf.RowCount:=0;
  gridf.Cells[0,0]:='';
  self.editO.Text:='';
  self.ComboBox.Text:='';
  self.ComboBox.Items.Clear;
end;

procedure  TRedactor.StartScriptRedac;
var i,j: integer;
begin
    if assigned(AppScript) then AppScript.StartRedactorS;
end;

function TRedactor.GetScriptValid: boolean;
begin
  result:=(usescript) and (findclass('TApplicationImmi')<>nil);
end;


function TRedactor.GetScriptActiv: boolean;
begin
  result:=(usescript) and (Appscript<>nil);
end;

procedure  TRedactor.StartScriptExec;
var i,j: integer;
begin
{ if assigned(AppScript) then
   begin
       RedactorForm.Clear;
      for i:=0 to self.ComponentCount-1 do
         RedactorForm.Add(self.Components[i]);
      for i:=0 to ClassTree.Count-1 do
          for j:=0 to TStringlist(ClassTree.Objects[i]).Count-1 do
              classList.Add(TUnitClass(TStringlist(TStringlist(ClassTree.Objects[i]).Objects[j])).TPClass);
       AppScript.classlistApp:=classList;
       AppScript.listApp:=self.fRedactorForm;
      AppScript.StartExe;
   end;   }
end;

procedure  TRedactor.StartCompile;
var i,j: integer;
begin
 {if assigned(AppScript) then
   begin
       RedactorForm.Clear;
      for i:=0 to self.ComponentCount-1 do
         RedactorForm.Add(self.Components[i]);
      for i:=0 to ClassTree.Count-1 do
          for j:=0 to TStringlist(ClassTree.Objects[i]).Count-1 do
              classList.Add(TUnitClass(TStringlist(TStringlist(ClassTree.Objects[i]).Objects[j])).TPClass);
       AppScript.classlistApp:=classList;
       AppScript.listApp:=self.fRedactorForm;
      AppScript.StartCompile;
   end;       }
end;



{procedure TMethodPropertyMy.SetValue(const AValue: string);
var i: integer;
begin
  inherited SetValue(AValue);
   //for I:=0 to self.
    (Designer as IMyMethodProperty).SetMethodInConnect(TComponent(GetComponent(0)),GetName,AValue);
end;   }

initialization
   begin
     RegisterComponentsProc := BwRegisterComponents;
     registerclasses([TBevel,TPanel, TShape])
   end;
end.





