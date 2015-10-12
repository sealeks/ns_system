unit ObjInsp1;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Grids, TypInfo,Contnrs, StdCtrls,Graphics,
  ExtCtrls,Forms,Dialogs,Ex_Grid, Ex_Inspector,ExtActns,ExtDlgs, DesignIntf, DesignEditors,VCLEditors;

type TSetTypeProperty = set of (tpExprOnly, tpExprString,tpInteger,tpstring,tpSet,tpClass,tpEnumeration,tpFloat,tpMethod);
//type TValueListEditors = class(TValueListEditor);
type THack = class(TInplaceEditList);
type THack1 = class(TCustomListbox);
type megr = class(TCustomDrawGrid);
type TStatusType = Set of 0..255;

type TOpenType  = (rOpen, rClose, rNill, rAsinc);

type TPOinterOject= record
       pO: array [0..600] of Pointer;
       count: integer;
       end;

type  PPropertyMapperRec = ^TPropertyMapperRec;
    TPropertyMapperRec = record
    Group: Integer;
    Mapper: TPropertyMapperFunc;
  end;

type
  PPropertyClassRec = ^TPropertyClassRec;
  TPropertyClassRec = record
    Group: Integer;
    PropertyType: PTypeInfo;
    PropertyName: string;
    ComponentClass: TClass;
    ClassGroup: TPersistentClass;
    EditorClass: TPropertyEditorClass;
  end;

type PTPOinterOject= ^TPOinterOject;

type FPropertyU = class(TPropertyEditor);



type
  TDataProp = record
      Status:      TStatusType;
      Editor:      IProperty;
      InOut:       integer;
      InclPr:      integer;
      OpenSet:     integer;
      BoolPr:      boolean;
  end;

  PTDataProp = ^TDataProp;

type
IExprstInt = interface
   ['{8116E749-31FB-4CEB-B14F-A250C82F3CF8}']
     function    CheckExprstr(value: string): boolean;
     procedure   PopMenuShowTegsforForm;
end;

IMethNamePropertyIn = interface
   ['{7AC7989E-886B-437B-99F2-046B5B327DCD}']
      function GetMPC: string;
      procedure SetMPC(val: string);
      property NameMPC: string read GetMPC write SetMPC;
end;

type
  TObjInsp1 = class(TExInspector)
  private

    mainObj:       TList;
    CountList:     integer;
    PrInfList:     TList;
    CList:         TList;
    OpSet:         TStatusType;
    ListPrp:       PPropList;
    LastList:      TList;
    liClear:       PPropList;
    nullstring:    boolean;
    upRow:         integer;
    curstr:        string;
    currentPick:   TStrings;
    faddString:    TGetStrProc;
    fShowProperty: TSetTypeProperty;
    procedure ClearePropList;
    procedure CloseCloused(close: integer);                        // изымает из  Opset числа внутренних закрываемых свойств
    procedure CellFilling;                                          // заполн€ет список  CList (текущие свойсва) исход€ из OpSet
    procedure InsertPropRow(Row: integer);                          //заполн€ет €чейки текущими свойствами
    procedure addStr(const S: string);
    function  InterfaceInheritsFrom(Child, Parent: PTypeData): Boolean;
    function  GetOptions: TGridOptions;
    procedure SetOptions(const Value: TGridOptions);
    procedure setShowProperty(value: TSetTypeProperty);
  protected
    procedure PaintCell(Cell: TGridCell; Rect: TRect); override;
    procedure DrawRectColor(rectOpen: TRect;OpenType: boolean;ColorO: integer);
    procedure DrawRectOpen(rectOpen: TRect;OpenType: TOpenType);                  //рисует пр€моугольник в €чейке
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
               X, Y: Integer); override;

    procedure InspValidate(Cell: TGridCell; Value: String);
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ObjInsp11DblClick(Sender: TObject);
    procedure EditButtonPress(Cell: TGridCell); override;
    procedure KeyPress(var Key: Char); override;
    procedure GetProp(const Prop: IProperty);
    procedure GetEditList(Cell: TGridCell; Items: TStrings); override;
    procedure CellClick(Cell: TGridCell; Shift: TShiftState; X, Y: Integer); override;
    procedure AddListLast;
    function CompearLastList: boolean;
    function ObjPropFilter(const ATestEditor: IProperty): Boolean;
    function myfilter(ptinf: PTypeInfo): boolean;
    function  NonilandExpr(value: TObject): boolean;
    function  getCellText(Cell: TGridCell): String; override;
    function  getEditStyle(Cell: TGridCell): TGridEditStyle; override;


  public
     curEditor: TTypeKind;
     IDesig: TComponent;
     isActive: boolean;

      strings: TStringList;
     procedure sss(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
     procedure RegisterPropertyEditorM(PropertyType: PTypeInfo; ComponentClass: TClass;
     const PropertyName: string; EditorClass: TPropertyEditorClass);
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     procedure   ShowS(IDesig: IDesigner);
    // procedure   FillValue;
     procedure   UpdateRight;
     procedure DeleteAlls;
  published
     property ShowProperty: TSetTypeProperty read fShowProperty write setShowProperty;

     property addString: TGetStrProc read  faddString write  faddString;

  end;
   function settostr(st: TStatusType): string;
   function DeleteMaxSet(st1: TStatusType; num :integer): TStatusType;
var
  maxC: integer;
  maxCs: TStatusType;
  ChangeinSet:TSetTypeProperty;
  MaxM: integer;
  incl: integer;
  inclPrLast: integer;
  CurrentStatusPr: TStatusType;
  GarbigeList: TList;
  ss: tpersistent;
  EditorInstance: TBasePropertyEditor;
  EdClass: TPropertyEditorClass;
  tt: integer;
  Valuess: TStrings;
  ggg: TStatusType;

procedure Register;

implementation


type
  TPropInfoList = class
  private
    FList: PPropList;
    FCount: Integer;
    FSize: Integer;
    function Get(Index: Integer): PPropInfo;
  public
    constructor Create(Instance: TPersistent; Filter: TTypeKinds);
    destructor Destroy; override;
    function Contains(P: PPropInfo): Boolean;
    procedure Delete(Index: Integer);
    procedure Intersect(List: TPropInfoList);
    property Count: Integer read FCount;
    property Items[Index: Integer]: PPropInfo read Get; default;
  end;

constructor TPropInfoList.Create(Instance: TPersistent; Filter: TTypeKinds);
begin
  FCount := GetPropList(Instance.ClassInfo, Filter, nil);
  FSize := FCount * SizeOf(Pointer);
  GetMem(FList, FSize);
  GetPropList(Instance.ClassInfo, Filter, FList);
end;

destructor TPropInfoList.Destroy;
begin
  if FList <> nil then FreeMem(FList, FSize);
end;

function TPropInfoList.Contains(P: PPropInfo): Boolean;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    with FList^[I]^ do
      if (PropType^ = P^.PropType^) and (CompareText(Name, P^.Name) = 0) then
      begin
        Result := True;
        Exit;
      end;
  Result := False;
end;

procedure TPropInfoList.Delete(Index: Integer);
begin
  Dec(FCount);
  if Index < FCount then
    Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(Pointer));
end;

function TPropInfoList.Get(Index: Integer): PPropInfo;
begin
  Result := FList^[Index];
end;

procedure TPropInfoList.Intersect(List: TPropInfoList);
var
  I: Integer;
begin
  for I := FCount - 1 downto 0 do
    if not List.Contains(FList^[I]) then Delete(I);
end;


constructor TObjInsp1.Create(AOwner: TComponent);
begin
inherited;
  upRow:=0;
  isActive:=false;
  nullstring:=false;
  strings:=TstringList.create;
  Rows.count:=0;
  Color:=clMedGray;
  Width:=225;
  Height:=400;
  PrInfList:=TList.Create;
  CList:=TList.Create;
  OnDblClick:=ObjInsp11DblClick;
  OpSet:=[0];
  LastList:=nil;
  faddString:=addStr;
  LastList:=TList.Create;
  fShowProperty:=[tpExprString,tpInteger,tpstring,tpSet,tpClass,tpEnumeration,tpFloat];
end;


destructor TObjInsp1.Destroy;
begin

   ClearePropList;
   PrInfList.Free;
   LastList:=nil;
   CList.Free;
   LastList.Free;
   strings.free;
   inherited Destroy;
end;

procedure TObjInsp1.ClearePropList;
var
  i: integer;
begin
  for  i := 0 to PrInfList.Count - 1 do
    DisPose(PTPOinterOject(PrInfList.Items[i]));
  PrInfList.Clear;
  CList.Clear;
end;




procedure TObjInsp1.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
   var aCol,ARow,j: integer;
   edit: TPropertyEditorClass;
   ed: TPropertyEditor;
   aa: TGetPropProc;
   cell: TGridCell;
begin
         if not isActive then Exit;
      // MouseToCell(x,y,aCol,ARow);
         cell:=self.GetCellAt(x,y);
        if not ((ACol=1) and ((TDataProp(CList.Items[cell.row]^).BoolPr) or
            ( (paReadOnly in (TDataProp(CList.Items[cell.row]^).Editor.GetAttributes)) and not
                 (paDialog in (TDataProp(CList.Items[cell.row]^).Editor.GetAttributes)))))  then  inherited;

end;

procedure TObjInsp1.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  var aCol,ARow: integer;
     i,testint,bit: integer;
     setB: boolean;
     cell: TGridCell;
begin
  if not isActive then Exit;
  cell:=self.GetCellAt(x,y);
  if ((cell.Col=0) and (TDataProp(CList.Items[cell.row]^).OpenSet<>-100)) then
     begin
       if TDataProp(CList.Items[Editcell.row]^).OpenSet in OpSet then
         begin
            upRow:=TopRow;
           // keyoptions := keyoptions +[keyDelete];
            CloseCloused(TDataProp(CList.Items[cell.row]^).OpenSet);
            CellFilling;
            strings.Clear;
            for i:=0 to CList.Count-1 do
                                     InsertPropRow(i);
              TopRow:=upRow;


        end else
          begin
             if (cell.Col=0) then
             begin
             upRow:=TopRow;
             Row:=Editcell.row;
             testint:= CList.Count;
             OpSet:=OpSet+[TDataProp(CList.Items[cell.row]^).OpenSet];
             CellFilling;

             Testint:=CList.Count-Testint;
              strings.Clear;
                  for i:=0 to CList.Count-1 do
                                     InsertPropRow(i);
             TopRow:=upRow;
             end;
         end;
     end;

  {if ((Editcell.Col=1) and (TDataProp(CList.Items[Editcell.row]^).BoolPr)) then
     begin
       if (TDataProp(CList.Items[Editcell.row]^).Editor.GetValue='True') then TDataProp(CList.Items[Editcell.row]^).Editor.Setvalue('false')
          else TDataProp(CList.Items[Editcell.row]^).Editor.Setvalue('true');

           exit;
     end; }
 inherited;
end;



procedure TObjInsp1.DrawRectOpen(rectOpen: TRect;OpenType: TOpenType);
begin
    if not isActive then Exit;
  if OpenType=rClose then
       begin
           Canvas.Pen.Color:=clBlue;
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(rectOpen);
           Canvas.MoveTo(rectOpen.Left+2,(rectOpen.Bottom+rectOpen.Top) div 2);
           Canvas.LineTo(rectOpen.Right-2,(rectOpen.Bottom+rectOpen.Top) div 2);
       end;

  if OpenType=rOpen then
       begin
           Canvas.Pen.Color:=clRed;
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(rectOpen);
           Canvas.MoveTo(rectOpen.Left+2,(rectOpen.Bottom+rectOpen.Top) div 2);
           Canvas.LineTo(rectOpen.Right-2,(rectOpen.Bottom+rectOpen.Top) div 2);
           Canvas.MoveTo((rectOpen.Left+rectOpen.Right) div 2,rectOpen.Bottom-3);
           Canvas.LineTo((rectOpen.Left+rectOpen.Right) div 2,rectOpen.Top+2);
       end;

  if OpenType=rNill then
       begin
           Canvas.Pen.Color:=clGray;
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(rectOpen);
           Canvas.MoveTo(rectOpen.Left+2,(rectOpen.Bottom+rectOpen.Top) div 2);
           Canvas.LineTo(rectOpen.Right-2,(rectOpen.Bottom+rectOpen.Top) div 2);
           Canvas.MoveTo((rectOpen.Left+rectOpen.Right) div 2,rectOpen.Bottom-3);
           Canvas.LineTo((rectOpen.Left+rectOpen.Right) div 2,rectOpen.Top+2);
       end;

   if OpenType=rAsinc then
      begin
           Canvas.Pen.Color:=clGray;
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(rectOpen);
      end;
end;


procedure TObjInsp1.DrawRectColor(rectOpen: TRect;OpenType: boolean;ColorO: integer);
begin
     if not isActive then Exit;
   if OpenType then
     begin
           Canvas.Pen.Color:=clGray;
           Canvas.Brush.Color:=TColor(ColorO);
           Canvas.Rectangle(rectOpen);
     end else

     begin
           Canvas.Pen.Color:=clBlack;
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(rectOpen);
           Canvas.MoveTo(rectOpen.Left,rectOpen.Top);
           Canvas.LineTo(rectOpen.Right,rectOpen.Bottom);
           Canvas.MoveTo(rectopen.Left,rectOpen.Bottom);
           Canvas.LineTo(rectOpen.Right,rectOpen.Top);
     end;

end;

procedure TObjInsp1.InsertPropRow(Row: integer);
var hhst, hhst1: string;
    jj: integer;
    Intf: ICustomPropertyListDrawing;
begin
   hhst:='';
   hhst1:=' ';
   if not isActive then Exit;
   if ((TDataProp(CList.Items[Row]^).Editor.AllEqual))
     then hhst:=TDataProp(CList.Items[Row]^).Editor.GetValue;
     if paSubProperties in TDataProp(CList.Items[row]^).Editor.GetAttributes then hhst1:='  ';
   Rows.Count:=CList.count;
   Cells[0,Row]:=hhst1+TDataProp(CList.Items[Row]^).Editor.GetName;
   Cells[1,Row]:=hhst;
   self.UpdateEdit(true);
   self.UpdateRows;
 {    Strings.Insert(Row,Format('%s=%s',['      '+TDataProp(CList.Items[Row]^).Editor.GetName,hhst])) else
  InsertRow('    '+TDataProp(CList.Items[Row]^).Editor.GetName,hhst,true);

  if ((paValueList in TDataProp(CList.Items[Row]^).Editor.GetAttributes) and not (TDataProp(CList.Items[Row]^).BoolPr))  then
     begin
       ItemProps[Row].EditStyle:=esPickList;
       currentPick:=ItemProps[Row].PickList;
       currentPick.Clear;
      (TDataProp(CList.Items[Row]^).Editor.GetValues(addString));
           if  TDataProp(CList.Items[Row]^).Editor.QueryInterface(StringToGUID('{BE2B8CF7-DDCA-4D4B-BE26-2396B969F8E0}//'),intf)=S_OK then
       {  begin

         end
    end else
 if ((paDialog in TDataProp(CList.Items[Row]^).Editor.GetAttributes))  then
            ItemProps[Row].EditStyle:=esEllipsis else ItemProps[Row].EditStyle:=esSimple;

                   }
   //  self.Cells[0,Row];
end;


procedure TObjInsp1.PaintCell(Cell: TGridCell; Rect: TRect);
var
  ShiftRow: integer;
  Wind: TRect;
  rem: TColor;
  remrect: TRect;
Intf: ICustomPropertyDrawing;
begin
   Canvas.Font:=self.Font;
   if iDesig=nil then exit;
   if not isActive then Exit;
   if (Cell.Row<CList.Count) then
     begin

          if TDataProp(CList.Items[Cell.row]^).Editor.QueryInterface(StringToGUID('{E1A50419-1288-4B26-9EFA-6608A35F0824}'),intf)=S_OK then
          begin
            if cell.col=1 then
               begin
                inherited;

                remrect:=self.GetCellRect(cell);
                inflaterect(remrect,-1,-1);
                (TDataProp(CList.Items[Cell.row]^).Editor as ICustomPropertyDrawing).PropDrawValue(Canvas,remrect,false);

                exit;
               end;
          end;




       if (Cell.Col=0)  then
           begin

              ShiftRow:=(TDataProp(CList.Items[Cell.row]^).InclPr-1)*16;
              self.fTextLeftIndent:=ShiftRow;

           end else self.fTextLeftIndent:=0;
           
     if ((Cell.Col=0) and (paSubProperties in (TDataProp(CList.Items[Cell.row]^).Editor.GetAttributes))) then
      begin
       Canvas.Font.Style:=[fsBold];
      end;

     if ((Cell.Col=0) and (TDataProp(CList.Items[Cell.row]^).Editor.GetPropType^.Name='TExprStr')) then
      begin
       Canvas.Font.color:=clMaroon;
       Canvas.Font.Style:=[fsBold];
      end;


     if ((Cell.Col=0))then
         begin
             inherited;
            if (paSubProperties in TDataProp(CList.Items[Cell.row]^).Editor.GetAttributes) then
               begin
                 Wind:=Rect;
                 Wind.Left:=Wind.Left+3+ShiftRow;
                 Wind.Right:=Rect.Left+16{self.hRowHeight}-3+ShiftRow;
                 Wind.Top:=Rect.Top+3;
                 Wind.Bottom:=Rect.Top+{DefaultRowHeight } 16-3;
                      // if  (((TDataProp(CList.Items[Cell.row]^).Editor.GetPropType^.Kind=tkClass) and
                            //                (TDataProp(CList.Items[Cell.row]^).ObjNill))) then
                             { begin
                                DrawRectOpen(Wind,rNill)
                              end else }
                              begin
                                 if (TDataProp(CList.Items[Cell.row]^).OpenSet in OpSet) then
                                       DrawRectOpen(Wind,rClose)
                                 else
                                       DrawRectOpen(Wind,rOpen);
                             end;
               end;
               //inherited;
               exit;
         end;
     if ((Cell.Col=1) and
               (TDataProp(CList.Items[Cell.row]^).BoolPr)) then
         begin

             Wind:=Rect;
             Wind.Left:=Wind.Right-{DefaultRowHeight}16+3;
             Wind.Right:=rect.Right-3;
             Wind.Top:=Rect.Top+3;
             Wind.Bottom:=Rect.Top+{DefaultRowHeight}16-3;
                if not TDataProp(CList.Items[Cell.row]^).Editor.AllEqual then
                          DrawRectOpen(Wind,rAsinc)
                else
                    begin
                       if TDataProp(CList.Items[Cell.row]^).Editor.GetValue='True' then
                                       DrawRectOpen(Wind,rOpen)
                       else
                                       DrawRectOpen(Wind,rClose);
                    end;
                //    exit;
         end else
          if ((Cell.Col=1) and
               (TDataProp(CList.Items[Cell.row]^).Editor.GetPropType^.Name='TExprStr')) then
               begin

                 if (IDesig as IExprstInt).CheckExprstr(TDataProp(CList.Items[Cell.row]^).Editor.GetValue) then
                   canvas.Font.Color:=clGreen else canvas.Font.Color:=clRed;
                   canvas.Font.Style:=canvas.Font.Style+[fsBold];
                 inherited;

               end else



       //  inherited;

   end;
  inherited;
end;


procedure TObjInsp1.CloseCloused(close: integer);
   var stty: TStatusType;
   i: integer;
begin
 if not isActive then Exit;
stty:=[];
for i:=close to 254 do stty:=stty+[i];
for i:=0 to  PrInfList.Count-1 do
   begin
     if (close in (TDataProp(PrInfList.Items[i]^).Status)) then
        begin
          OpSet:=OpSet-(TDataProp(PrInfList.Items[i]^).Status*stty);
        end;
      OpSet:=OpSet-[close];
   end;
end;




procedure TObjInsp1.CellFilling;
var
   i: integer;
begin

  CList.Clear;
    for i:=0 to  PrInfList.Count-1 do
       begin
        if TDataProp(PrInfList.Items[i]^).Status<=OpSet then
         CList.Add(@TDataProp(PrInfList.Items[i]^));
       end;
end;




function TObjInsp1.InterfaceInheritsFrom(Child, Parent: PTypeData): Boolean;
begin
  while (Child <> nil) and (Child <> Parent) and (Child^.IntfParent <> nil) do
    Child := GetTypeData(Child^.IntfParent^);
  Result := (Child <> nil) and (Child = Parent);
end;




procedure TObjInsp1.showS(IDesig: IDesigner);
var i,j,CountFirst,CountCommon: integer;
    trueProp: bool;
    pPointer: PTPOinterOject;
begin
  if (Idesig=nil) or ((Idesig as Idesignerselections).Count<1) then
     begin
       MaxM:=0;
       Strings.Clear;
       PrInfList.Clear;
       CList.Clear;
       Rows.Count:=0;

       isActive:=false;
       exit;
     end;
  isActive:=true;
  if ((not CompearLastList) or (curEditor=tkClass)) then
  begin
    if  not (CompearLastList) then  CurrentStatusPr:=[0];
    if ((CompearLastList) and not (curEditor=tkClass)) then CurrentStatusPr:=[0];
    OpSet:=[0];
    MaxC:=-1;
    MaxM:=0;
    Strings.Clear;
    PrInfList.Clear;
    CList.Clear;
    incl:=0;
    InclPrLast:=1;
    GReferenceExpandable:=true;
    GetComponentProperties(IDesig as IDesignerSelections,tkAny + tkMethods,IDesig as IDesigner, GetProp,nil);
    CellFilling;
    //self.se;
    for i:=0 to  CList.Count-1 do  InsertPropRow(i);
     if upRow<Rows.Count then topRow:=upRow;

   end
   else UpdateRight;
   self.AddListLast;
   Rows.count:=CList.Count;
   self.HideEdit;
   self.ShowEdit;
    self.UpdateEdit(true);
   self.UpdateText;
   self.Invalidate;
end;







procedure  TObjInsp1.InspValidate(Cell: TGridCell; Value: String);
  var
    i,j: integer;
    cl: TObject;

begin

    if not isActive then Exit;
    curEditor:=TDataProp(CList.Items[cell.Row]^).Editor.GetPropType^.Kind;
    UpRow:=TopRow;
    if ((cell.Row>=CList.Count)) then exit;
       (IDesig as IMethNamePropertyIn).NameMPC:=TDataProp(CList.Items[EditCell.Row]^).Editor.GetName;
        //(IDesig as IMethNamePropertyIn).NameMPC:=TDataProp(CList.Items[EditCell.Row]^).Editor.GetName;
         TDataProp(CList.Items[cell.Row]^).Editor.SetValue(Value);


end;




procedure TObjInsp1.EditButtonPress(Cell: TGridCell);
var gh: string;
begin
    if not isActive then Exit;
    if ((Cell.Row>=CList.Count) or (Cell.Col=0)) then exit;
       TDataProp(CList.Items[Cell.Row]^).Editor.Edit;
end;









procedure TObjInsp1.GetProp(const Prop: IProperty);
  var  pDataProp:      ^TDataProp;
  edit: TPropertyEditorClass;
  intf: IReferenceProperty;
  inMac,i: integer;

begin

   inc(incl);
   new (PDataProp);
   PDataProp.OpenSet:=-100;
   PDataProp.Editor:=Prop;
   PDataProp.InclPr:=incl;

   PDataProp.Status:=CurrentStatusPr;
   if InclPrLast<PDataProp.InclPr then
     begin
        MaxM:=MaxM+(PDataProp.InclPr-InclPrLast);
        inMac:=MaxM;
        if PrInfList.Last<>nil then TDataProp(PrInfList.Last^).OpenSet:=MaxM;
        maxCs:=[];
        for i:=0 to (PDataProp.InclPr-InclPrLast)-1 do maxCs:= maxCs + [inMac-i];
        CurrentStatusPr:=CurrentStatusPr+maxCs;
        PDataProp.Status:=CurrentStatusPr;
     end;
   if InclPrLast>PDataProp.InclPr then
     begin
        inMac:=MaxM;
        CurrentStatusPr:=DeleteMaxSet(CurrentStatusPr,(InclPrLast-PDataProp.InclPr));
        PDataProp.Status:=CurrentStatusPr;
     end;
    InclPrLast:=PDataProp.InclPr;

   if self.myfilter(PDataProp.Editor.GetPropType) then begin PrInfList.Add(PDataProp);
     if PDataProp.Editor.GetPropType.Name='Boolean' then PDataProp.BoolPr:=true else  PDataProp.BoolPr:=false;
   if (paSubProperties in Prop.GetAttributes) then
     begin
      //inc(MaxM);
  //    MaxC:=MaxM;
     // PDataProp.OpenSet:=MaxM;
  //    CurrentStatusPr:=CurrentStatusPr+[MaxC];
      prop.GetProperties(GetProp);
   //   CurrentStatusPr:=CurrentStatusPr-[MaxC];
    //  dec(MaxC);
    end;
   end;
   dec(incl);

end;



procedure TObjInsp1.addStr(const S: string);
begin
   currentPick.Add(S);
end;




procedure TObjInsp1.RegisterPropertyEditorM(PropertyType: PTypeInfo; ComponentClass: TClass;
  const PropertyName: string; EditorClass: TPropertyEditorClass);
var
  P: PPropertyClassRec;
begin
  RegisterPropertyEditor(PropertyType, ComponentClass,
  PropertyName, EditorClass);
  // (IDesig as IMethNamePropertyIn).NameMPC:=TDataProp(CList.Items[EditCell.Row]^).Editor.GetName;
end;


procedure TObjInsp1.ObjInsp11DblClick(Sender: TObject);
begin
    if ((EditCell.Row>=CList.Count) or (EditCell.Col=0)) then exit;
    (IDesig as IMethNamePropertyIn).NameMPC:=TDataProp(CList.Items[EditCell.Row]^).Editor.GetName;
       TDataProp(CList.Items[EditCell.Row]^).Editor.Edit;
end;

procedure TObjInsp1.GetEditList(Cell: TGridCell; items: TStrings);
  var Intf: ICustomPropertyListDrawing;
      i: integer;

begin
     if not isActive then Exit;

      currentPick.Clear;

      (TDataProp(CList.Items[Row]^).Editor.GetValues(addString));
      Edit.PickList.Items:=CurrentPick;
          if  TDataProp(CList.Items[Row]^).Editor.QueryInterface(StringToGUID('{BE2B8CF7-DDCA-4D4B-BE26-2396B969F8E0}'),intf)=S_OK then
        begin

           Edit.PickList.OnDrawItem:=sss;
         end
          else inherited GetEditList(cell,CurrentPick);

end;


procedure TObjInsp1.sss(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
    if not isActive then Exit;
       InflateRect(Rect,-2,-2);
       (TDataProp(CList.Items[Row]^).Editor as ICustomPropertyListDrawing).ListDrawValue(Edit.PickList.Items[index],Edit.PickList.Canvas,Rect,false);

end;



procedure TObjInsp1.UpdateRight;
var i: integer;
begin
     if CList.Count=0 then exit;
    for i:=0 to CList.Count-1 do
         if ((TDataProp(CList.Items[i]^).Editor.AllEqual))
                then cells[1,i]:=TDataProp(CList.Items[i]^).Editor.GetValue;
end;



function settostr(st: TStatusType): string;
var I: integer;
begin
   result:='';
   for i:=0 to 100 do if i in st then result:=result + inttostr(i) +' ';
end;

function DeleteMaxSet(st1: TStatusType; num :integer): TStatusType;
var I,countst: integer;
    ins: TStatusType;
begin
   countst:=0;
   i:=255;
   result:=st1;
   while ((countst<num) and (i>0)) do
    begin
     if i in result then
       begin
         result:=result-[i];
         inc(countst);
       end;
       dec(i);
    end;
end;

procedure TObjInsp1.AddListLast;
var i: integer;
begin
   LastList.clear;
   for I:=0 to (IDesig as IdesignerSelections).GetCount-1 do
        LastList.Add((IDesig as IdesignerSelections).get(i))
end;

function TObjInsp1.CompearLastList: boolean;
var i: integer;
begin
result:=true;
if LastList.Count<>(IDesig as IdesignerSelections).GetCount then
begin
result:=false;
exit;
end;
for i:=0 to (IDesig as IdesignerSelections).GetCount-1 do
  if  LastList.Items[i]<>(IDesig as IdesignerSelections).get(i) then
begin
result:=false;
exit;
end;

end;


procedure TObjInsp1.DeleteAlls;
begin
   MaxM:=0;
   Strings.Clear;
   PrInfList.Clear;
   CList.Clear;
   Rows.Count:=0;
end;


function TObjInsp1.GetOptions: TGridOptions;
begin
  //Result := inherited Options;
end;


procedure TObjInsp1.SetOptions(const Value: TGridOptions);
begin
  //megr(self).Options := Value;
end;


function TObjInsp1.ObjPropFilter(const ATestEditor: IProperty): Boolean;
begin
  result:=myfilter(ATestEditor.GetPropType);
end;


function TObjInsp1.myfilter(ptinf: PTypeInfo): boolean;
begin
   result:=true;
    if (tpMethod in ShowProperty) then
    begin
       if (ptinf^.Kind<>tkMethod)  then result:=false;
           exit;
    end else
    begin
      if (ptinf^.Kind=tkMethod) then
       begin
         result:=false;
         exit;
       end;
    end;


   if (tpExprOnly in ShowProperty) and
        ((ptinf^.Name<>'TExprStr') and
            (ptinf^.Kind<>tkClass)) then
        begin
           result:=false;
           exit;
        end;
   result:=false;

   if (tpExprString in ShowProperty) and (ptinf^.Name='TExprStr') then  result:=true;
   if (tpInteger in ShowProperty) and ((ptinf^.Kind=tkInteger) or
                                            (ptinf^.Kind=tkInt64)) then result:=true;
   if (tpstring in ShowProperty) and ((ptinf^.Kind=tkChar) or (ptinf^.Kind=tkString) or
       (ptinf^.Kind=tkWChar) or (ptinf^.Kind=tkLString) or (ptinf^.Kind=tkWString))
   then result:=true;
   if (tpEnumeration in ShowProperty) and (ptinf^.Kind=tkEnumeration) then result:=true;

   if (tpSet in ShowProperty) and (ptinf^.Kind=tkSet) then result:=true;
   if (tpClass in ShowProperty) and (ptinf^.Kind=tkClass) then result:=true;
   if (tpFloat in ShowProperty) and (ptinf^.Kind=tkFloat) then result:=true;
   if (ptinf^.Kind=tkMethod)  then result:=true;
   end;

procedure Register;
begin
  RegisterComponents('New', [TObjInsp1]);
end;

procedure  TObjInsp1.setShowProperty(value: TSetTypeProperty);

begin
 if value<>fShowProperty then
   begin
          fShowProperty:=value;
          LastList.Clear;
        end;


end;

function  TObjInsp1.NonilandExpr(value: TObject): boolean;
 //замен€ет идентификаторы в строках типа TExprStr,
  //проход€ по всем вложенным объектам
  var
    TypeData: PTypeData;
    //ExprStr: TExprStr;
    ChildProp: TObject;
    i: integer;
    Props: PPropList;
  begin
   result:=false;
   if value=nil then exit;
   TypeData := GetTypeData(value.classInfo);
   if (TypeData = nil) or (TypeData^.PropCount = 0) then Exit;
   GetMem(Props, TypeData^.PropCount * sizeof(Pointer));
   try
     GetPropInfos(value.ClassInfo, Props);
     for i := 0 to TypeData^.PropCount - 1 do
       if Props^[i]^.PropType^^.Name = 'TExprStr' then
       begin
         //заполн€ем список всех используемых идентификаторов
        result:=true;
       end
       else
         if Props^[i]^.PropType^^.Kind = tkClass then
         begin
           result := NonilandExpr(value);

         end;
   finally
     Freemem(Props);
   end;
  end;


function TObjInsp1.GetCellText(Cell: TGridCell): String;
var st,st1: string;
begin
  if CList.Count<=Cell.Row then exit;
  st:='';
  st1:='';
  if TDataProp(CList.Items[Cell.Row]^).Editor.AllEqual then st:=TDataProp(CList.Items[Cell.Row]^).Editor.getvalue;
  if paSubProperties in TDataProp(CList.Items[Cell.row]^).Editor.GetAttributes then st1:='   ';
  case Cell.Col of
    0: result := st1+TDataProp(CList.Items[Cell.Row]^).Editor.GetName;
    1: result := st;
  end;
end;

function TObjInsp1.GetEditStyle(Cell: TGridCell): TGridEditStyle;
var Intf: ICustomPropertyDrawing;
     i: integer;
begin
  if ((paValueList in TDataProp(CList.Items[Row]^).Editor.GetAttributes) {and not (TDataProp(CList.Items[Row]^).BoolPr)}) then
    begin
      result:=gePickList;
      currentPick:=EditColumn.PickList;
      currentPick.Clear;
      (TDataProp(CList.Items[Row]^).Editor.GetValues(addString));
    end
  else
    if ((paDialog in TDataProp(CList.Items[Row]^).Editor.GetAttributes))  then
            result:=geEllipsis
    else result:=geSimple;

end;

procedure TObjInsp1.CellClick( Cell: TGridCell;
  Shift: TShiftState; X, Y: Integer);
   var i: boolean;
begin
  if not isActive then Exit;
      (IDesig as IMethNamePropertyIn).NameMPC:=TDataProp(CList.Items[EditCell.Row]^).Editor.GetName;
     if not ((TDataProp(CList.Items[Cell.Row]^).Editor<>nil)) then TDataProp(CList.Items[Cell.Row]^).Editor.Activate;
  inherited;


end;

procedure TObjInsp1.KeyPress(var Key: Char);
var st: string;
begin

  if key=char(13) then
    begin
    InspValidate(self.EditCell,Edit.EditText);
    self.Edit.SelectAll;
    end;
  inherited KeyPress(key);

end;

initialization
RegisterClasses([TColorBox]);

end.                                         ;
