// Original Author: Shalonkin Alex
//   e-mail alex@vita-samara.ru
//
// This is a modified pascal unit originally written by Alex Shalonkin.
// It has been made into a component with a couple of properties added
// and the Russian remarks and text translated into English by Alexander Rodygin.
//
// Very basic yet useful component for printing your dbgrids!
//
// No warranty expressed or implied. Use at your own risk! Modify if you wish!
//
// John F. Jarrett
// johnj@jcits.d2g.com
//

unit PrintGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  StdCtrls, DB, DBTables, Printers, dbgrids, extctrls, comctrls, Forms;

const MaxColums=10;
      NumerateColumnWidth=30;
      NumerateFieldName='Num';

type
  TOnLogChangeEvent = procedure (Sender: TObject; aStr:String) of object;
  TOnNextPageEvent = procedure (Sender: TObject; NumPage:Integer) of object;

  PBoundRec = ^TBoundRec;
  TBoundRec=record
    aPos:Integer; // relative to the top displacement
    aStr:String;
    aFontSize:Integer;
    aFontStyle:TFontStyles;
    aAligment:TAlignment;
  end;

  TPrintBound=class(TList)
  private
    FMaxPos:Integer;
    function GetBItem(Index:Integer):TBoundRec;
  public
    constructor Create;
    function Add(aPos:Integer;aStr:String;aFontSize:Integer;aFontStyle:TFontStyles;aAligment:TAlignment):Integer;
    property Items[Index:Integer]:TBoundRec read GetBItem;
    property MaxPos:Integer read FMaxPos;
  end;

  TColumnRect=record
    Left:Integer;
    Right:Integer;
    Top:Integer;
    Alignment:TAlignment;
    Font:TFont;
    Color:TColor;
    TitleFont:TFont;
    TitleAlignment:TAlignment;
    TitleColor:TColor;
    TitleStr:String;
    FieldName:String;
  end;

  TPrintGrid = class(TComponent)
  private

    FDBGrid:TDBGrid;
   // FPreviewImage: TImage;
    FOnLogChangeEvent: TOnLogChangeEvent; //Fires when the log changes
    FOnNextPageEvent:TOnNextPageEvent;
    FLogPanel:TPanel; // Log output panel
    FVisibleColumn:Integer; //Number of visible columns
    FRowNumbers:Boolean; //Should the rows be numerated
    FHeaderColor:TColor; // For Title Text and Page Text Color
    FPageNumFontSize:Integer; //Set for Font Size
    FPageNumFontName:TFontName; // Like Times New Roman
    FPrintPageNum:Boolean; //Set if you want to print page numbers
    FPrintDialog: Boolean; //Should the print dialog be displayed
    FPrintProgressBar:TProgressBar; //Progressbar for printing
    FPrintOrientation: TPrinterOrientation; //Print orientation
    FWidth:Integer; FHeight:Integer; // Canvas Width & Height
    FLeftmargin:Integer; FRightmargin:Integer; FTopmargin:Integer; FBottommargin:Integer; // Margins
    FPageNumberTop:Integer;
    FBoundmargin:Integer; // Margins from the bounds to the table and from the table to the bounds
    procedure SetDBGrid(const Value: TDBGrid);    //const Value
   // procedure SetPreviewImage(const Value: TImage);
  protected
    FActiveTopPosition:Integer; //Top border for painting
    FColumns:Array [0..MaxColums-1] of TColumnRect;
    FCanvas:TCanvas; // Canvas for printing (printer or picture)
    FMaxTitleHeight:Integer;
    FMaxColumnHeight:Integer;
    AutoNumber:Integer;
    FPageNumber:Integer;
    FUsePrinter:Boolean;
    //FOnLogChangeEvent : TOnLogChangeEvent;
    //FOnNextPageEvent : TOnNextPageEvent
    procedure PaintCanvas;
    procedure AddInLog(aStr:String);
    procedure PaintBound(Bound:TPrintBound);
    procedure ProcessingGridCoord;
    procedure PrintGridTitle;
    procedure PrintRows;
    procedure PrintRow;
    procedure PrintPageNumber;
  public
     FDataSet:TDataSet;
    Title:TPrintBound;
    Bottom:TPrintBound;
    Logs:TStringList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    //function Preview:Boolean;
    function Print:Boolean;
  published
    property RowNumbers:Boolean read FRowNumbers write FRowNumbers default True;
    property PageNumFontSize:Integer read FPageNumFontSize write FPageNumFontSize;
    property DBGrid:TDBGrid read FDBGrid write FDBGrid; //SetDBGrid;
    property PageNumFontName:TFontName read FPageNumFontName write FPageNumFontName;
    property HeaderColor:TColor read FHeaderColor write FHeaderColor;
    property LogPanel:TPanel read FLogPanel write FLogPanel;
   // property PreviewImage:TImage read FPreviewImage write FPreviewImage; //SetPreviewImage;
    property PrintDialog:Boolean read FPrintDialog write FPrintDialog default False;
    property PrintOrientation:TPrinterOrientation read FPrintOrientation write FPrintOrientation default poPortrait;
    property PrintPageNum:Boolean read FPrintPageNum write FPrintPageNum default True;
    property PrintProgressBar:TProgressBar read FPrintProgressBar write FPrintProgressBar;
    property TopMargin:Integer read FActiveTopPosition write FActiveTopPosition;
    property BottomMargin:Integer read FBottomMargin write FBottomMargin;
    property LeftMargin:Integer read FLeftMargin write FLeftMargin;
    property RightMargin:Integer read FRightMargin write FRightMargin;
    property OnLogChangeEvent: TOnLogChangeEvent read FOnLogChangeEvent write FOnLogChangeEvent;
    property OnNextPageEvent: TOnNextPageEvent read FOnNextPageEvent write FOnNextPageEvent;
  end;

procedure Register;

implementation
//***************************************
// Register the component on the Palette
//***************************************
procedure Register;
begin
 RegisterComponents('CES', [TPrintGrid]);
end;

//****************************************************
// Create and Initialize
//****************************************************
constructor TPrintGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Title:=TPrintBound.Create;
  Bottom:=TPrintBound.Create;
  Logs:=TStringList.Create;
  FRowNumbers:=True;
  FLogPanel:=nil;
  FHeaderColor := clBlack;
  FPrintDialog := False;
  FPrintPageNum := True;
  FPageNumFontName := 'Times New Roman';
  FPageNumFontSize := 8;
  FPrintProgressBar:=nil;
  FPrintOrientation:=poPortrait;
  //FPreviewImage:=nil;
  FWidth:=0; FHeight:=0;
  FLeftmargin:=240;
  FRightmargin:=60; FBottommargin:=160;
  FActiveTopPosition:=0;
  FBoundmargin:=10;
  FUsePrinter:=True;
end;

//***************************************
// Moves the rect vertically and horizontally
//
function MoveRect(Rect:TColumnRect;x,y:Integer):TColumnRect;
begin
  Result.Left:=Rect.Left+x;
  Result.Right:=Rect.Right+x;
  Result.Top:=Rect.Top+y;
end;

//***************************************
// Outputs the text inside a cell
//***************************************
procedure  PaintCells(aCanvas:TCanvas;aRect:TRect;aFont:TFont;aAlignment:TAlignment;aColor:TColor;aStr:String);
var LeftPoint:Integer;
    lWidth:Integer;
    TopPoint:Integer;
begin
  // Fills the rectangles
  aCanvas.Brush.Color:=aColor;
  aCanvas.FillRect(Rect(aRect.Left+1,aRect.Top+1,aRect.Right,aRect.Bottom));

  aCanvas.Font:=aFont;

  While (Length(aStr)>0)and(aCanvas.TextWidth(aStr)>(aRect.Right-aRect.Left)-aCanvas.TextWidth('A'))
  do Delete(aStr,Length(aStr),1);

  case aAlignment of
    taLeftJustify:LeftPoint:=aRect.Left+2;
    taCenter:
      begin
        LeftPoint:=aRect.Left+((aRect.Right-aRect.Left) div 2)-aCanvas.TextWidth(aStr) div 2;
      end;
    taRightJustify:LeftPoint:=aRect.Right-aCanvas.TextWidth(aStr)-1;
  end;

  TopPoint:=aRect.Top+
    ((aRect.Bottom-aRect.Top) div 2)-aCanvas.TextHeight(aStr) div 2;

  aCanvas.TextOut(LeftPoint,TopPoint,aStr);
end;

//************************************************
// Check and see if we are in design mode. If not,
// we ensure that the DBGrid is set and the TImage
//************************************************
procedure TPrintGrid.Loaded;
begin
 Inherited Loaded;
  if not (csDesigning in ComponentState)then
   begin
    if Assigned(FDBGrid) then
    SetDBGrid(FDBGrid);
    //if Assigned(FPreviewImage) then
    //SetPreviewImage(FPreviewImage);
   end;
end;

//************************************************
// Component Destroy
//************************************************
destructor TPrintGrid.Destroy;
begin
  Title.Free; Title:=nil;
  Bottom.Free; Bottom:=nil;
  Logs.Free; Logs:=nil;
  inherited Destroy;
end;

//**********************************************
// Preview Print in a TImage
//**********************************************
{function TPrintGrid.Preview: Boolean;
var
Left, Right : Integer;
begin
 Left := FLeftMargin;
 Right := FRightMargin;
 FLeftMargin := 20;
 FRightMargin := 20;
  AddInLog('Generating preview');
  Result:=Assigned(FPreviewImage);
  if Result then
  begin
    FCanvas:=FPreviewImage.Canvas;
    FWidth:=FPreviewImage.Width;
    FHeight:=FPreviewImage.Height;
    FUsePrinter:=False;
    PaintCanvas;
  end;
  AddInLog('Preview generation completed');
  if Assigned(FPrintProgressBar) then
   FPrintProgressBar.Position := 0;
 FLeftMargin := Left;
 FRightMargin := Right;
end; }

//**************************************************
// Print the Grid within which the data will reside
//**************************************************
procedure TPrintGrid.PaintCanvas;
begin
  AddInLog('Preparing to output image');
  if FUsePrinter then
  begin
   FTopmargin:=200;
   FPageNumberTop:=50;
   end
   else
    begin
    FTopmargin:=20;
    FPageNumberTop:=10;
    end;
  FActiveTopPosition:=FTopmargin; FPageNumber:=1;
  //PrintPageNumber;
  if Title.Count>0 then
  begin
    PaintBound(Title);
    FActiveTopPosition:=FActiveTopPosition+FBoundmargin;
  end;
  ProcessingGridCoord;
  //PrintGridTitle;
  PrintRows;
  if Bottom.Count>0 then
  begin
    FActiveTopPosition:=FActiveTopPosition+FMaxColumnHeight+FBoundmargin;
    PaintBound(Bottom);
  end;
end;

//***************************************************
// Sets the dbGrid
//***************************************************
procedure TPrintGrid.SetDBGrid(const Value: TDBGrid);
var i:Integer;
begin
  FDBGrid := Value;
  FDataSet:=FDBGrid.DataSource.DataSet;
  FVisibleColumn:=0;
  For i:=0 to FDBGrid.Columns.Count-1 do
  begin
    if FDBGrid.Columns[i].Visible then
     Inc(FVisibleColumn);
    Application.ProcessMessages;
  end;
end;

//*****************************************************
// TPrintBound Adds Strings and Font Data to List
//*****************************************************
function TPrintBound.Add(aPos: Integer; aStr: String; aFontSize: Integer;
  aFontStyle: TFontStyles; aAligment: TAlignment): Integer;
var B:PBoundRec;
begin
  New(B);
  B^.aPos:=aPos;
  B^.aStr:=aStr;
  B^.aFontSize:=aFontSize;
  B^.aFontStyle:=aFontStyle;
  B^.aAligment:=aAligment;
  if FMaxPos<aPos then
   FMaxPos:=aPos;
  Result:=inherited Add(B);
end;

//******************************************************
//  Creates the Print bounds
//******************************************************
constructor TPrintBound.Create;
begin
  inherited;
  FMaxPos:=0;
end;

//*******************************************************
// Gets the item index
//*******************************************************
function TPrintBound.GetBItem(Index: Integer): TBoundRec;
begin
  Result:=PBoundRec(inherited Items[Index])^;
end;

//*******************************************************
//  Sets the preview image to your Image
//*******************************************************
{procedure TPrintGrid.SetPreviewImage(const Value: TImage);
begin
  FPreviewImage := Value;
  FWidth:=FPreviewImage.Width;
  FHeight:=FPreviewImage.Height;
  FCanvas:=Value.Canvas;
  FUsePrinter:=False;
end;  }

//*******************************************************
// Writes events for progress and Logging
//*******************************************************
procedure TPrintGrid.AddInLog(aStr: String);
begin
  Logs.Add(aStr);
  if Assigned(FOnLogChangeEvent) then
   FOnLogChangeEvent(Logs, aStr);
  if Assigned(FPrintProgressBar) then
   FPrintProgressBar.StepIt;
  if Assigned(FLogPanel) then
  begin
    FLogPanel.Caption:=aStr;
    FLogPanel.Refresh;
  end;
end;

//********************************************************
// Paint the boundaries
//********************************************************
procedure TPrintGrid.PaintBound(Bound:TPrintBound);
var I:Integer;
    LeftPoint:Integer;
    lWidth:Integer;
    MaxHeight:Integer;
begin
  AddInLog('Bounds drawing');
  MaxHeight:=0;
  For i:=0 to Bound.Count-1 do
   begin
    FCanvas.Brush.Color:=clWhite;
    FCanvas.Font.Size:=Bound.Items[i].aFontSize;
    FCanvas.Font.Style:=Bound.Items[i].aFontStyle;
    FCanvas.Font.Name:='MS Sans Serif';
    case Bound.Items[i].aAligment of
      taLeftJustify:LeftPoint:=FLeftmargin;
      taCenter:
      begin
        lWidth:=(FWidth-(FLeftmargin+FRightmargin)) div 2;
        LeftPoint:=FLeftmargin+lWidth-FCanvas.TextWidth(Bound.Items[i].aStr) div 2;
      end;
      taRightJustify:LeftPoint:=FWidth-FRightmargin-FCanvas.TextWidth(Bound.Items[i].aStr);
    end;
    FCanvas.TextOut(LeftPoint,FActiveTopPosition,Bound.Items[i].aStr);
    if FCanvas.TextHeight(Bound.Items[i].aStr)>MaxHeight then MaxHeight:=FCanvas.TextHeight(Bound.Items[i].aStr);
    if i<Bound.Count-1 then
      if Bound.Items[i+1].aPos>Bound.Items[i].aPos then
      begin
        FActiveTopPosition:=FActiveTopPosition+MaxHeight;
        MaxHeight:=0;
      end;
  end;
  FActiveTopPosition:=FActiveTopPosition+MaxHeight;
end;

//************************************************************
// Processing and figuring the number of columns and width
//************************************************************
procedure TPrintGrid.ProcessingGridCoord;
var i:Integer;
    lWidth:Integer;
    lKoeff:Real;
    j:Integer;
    LeftPoint:Integer;
begin
  AddInLog('Computing number of visible columns and width of table');
  lWidth:=0; FMaxColumnHeight:=0;
  For i:=0 to FDBGrid.Columns.Count-1 do
  begin
    if FDBGrid.Columns[i].Visible then
    begin
      lWidth:=lWidth+FDBGrid.Columns[i].Width;
      FCanvas.Font:=FDBGrid.Columns[i].Font;
      if FMaxColumnHeight<FCanvas.TextHeight('ROW HEIGHT') then
       FMaxColumnHeight:=FCanvas.TextHeight('ROW HEIGHT')+2;
      FCanvas.Font:=FDBGrid.Columns[i].Title.Font;
      if FMaxTitleHeight<FCanvas.TextHeight('ROW HEIGHT') then
       FMaxTitleHeight:=FCanvas.TextHeight('ROW HEIGHT')+2;
    end;
  end;

  if FRowNumbers then
  begin
    Inc(FVisibleColumn);
    lWidth:=lWidth+NumerateColumnWidth;
  end;

  AddInLog('Calculating the coefficient of compression/stretch');
  lKoeff:=(FWidth-(FLeftmargin+FRightmargin))/lWidth;

  AddInLog('If there is an auto-number field, add one more column');
  j:=0; LeftPoint:=FLeftmargin;
  if FRowNumbers then
  begin
    FColumns[j].Alignment:=taLeftJustify;       // Position of Row Number. Left is best.
    FColumns[j].Font:=FDBGrid.Columns[0].Font;
    FColumns[j].Color:=FDBGrid.Columns[0].Color;
    FColumns[j].FieldName:=NumerateFieldName;

    FColumns[j].TitleFont:=FDBGrid.Columns[0].Title.Font;
    FColumns[j].TitleAlignment:=taLeftJustify;
    FColumns[j].TitleColor:=FDBGrid.Columns[0].Title.Color;
    FColumns[j].TitleStr:='Num';

    FColumns[j].Top:=0;
    FColumns[j].Left:=LeftPoint;
    FColumns[j].Right:=LeftPoint+Trunc(NumerateColumnWidth*lKoeff);
    LeftPoint:=FColumns[j].Right;
    Inc(j);
  end;

  AddInLog('Calculating row coordinates');
  For i:=0 to FDBGrid.Columns.Count-1 do
  begin
    if FDBGrid.Columns[i].Visible then
    begin
      FColumns[j].Alignment:=FDBGrid.Columns[i].Alignment;
      FColumns[j].Font:=FDBGrid.Columns[i].Font;
      FColumns[j].Color:=FDBGrid.Columns[i].Color;
      FColumns[j].FieldName:=FDBGrid.Columns[i].FieldName;

      FColumns[j].TitleFont:=FDBGrid.Columns[i].Title.Font;
      FColumns[j].TitleAlignment:=FDBGrid.Columns[i].Title.Alignment;
      FColumns[j].TitleColor:=FDBGrid.Columns[i].Title.Color;
      FColumns[j].TitleStr:=FDBGrid.Columns[i].Title.Caption;

      FColumns[j].Top:=0;
      FColumns[j].Left:=LeftPoint;
      FColumns[j].Right:=LeftPoint+Trunc(FDBGrid.Columns[i].Width*lKoeff);
      LeftPoint:=FColumns[j].Right;
      Inc(j);
    end;
  end;
end;

//***********************************************************
// Printing the Title
//***********************************************************
procedure TPrintGrid.PrintGridTitle;
var i:Integer;
    lRect:TColumnRect;
    lHeight:Integer;
begin
  AddInLog('Table title output');
  For i:=0 to FVisibleColumn-1 do
  begin
    lRect:=MoveRect(FColumns[i],0,FActiveTopPosition);
    // Paints the "|" of the column
    if i=0 then
    begin
      FCanvas.MoveTo(lRect.Left,lRect.Top);
      FCanvas.LineTo(lRect.Left,FMaxTitleHeight+FActiveTopPosition);
    end;
    // Paints the remaining part of the column
    FCanvas.MoveTo(lRect.Left,lRect.Top);
    FCanvas.LineTo(lRect.Right,lRect.Top);
    FCanvas.LineTo(lRect.Right,FMaxTitleHeight+FActiveTopPosition);
    FCanvas.LineTo(lRect.Left,FMaxTitleHeight+FActiveTopPosition);
    // Paints the text
    PaintCells(FCanvas,Rect(lRect.Left,lRect.Top,
      lRect.Right,FMaxTitleHeight+FActiveTopPosition),
      FColumns[i].TitleFont,
      FColumns[i].TitleAlignment,
      FColumns[i].TitleColor,
      FColumns[i].TitleStr);
  end;
  FActiveTopPosition:=FMaxTitleHeight+FActiveTopPosition;
end;

//*************************************************************
// Formats the rows
//*************************************************************
procedure TPrintGrid.PrintRow;
var i:Integer;
    lRect:TColumnRect;
begin
  AddInLog('Formatting row output');
  For i:=0 to FVisibleColumn-1 do
  begin
    lRect:=MoveRect(FColumns[i],0,FActiveTopPosition);
    // Paints the "|" of the column
    if i=0 then
    begin
      FCanvas.MoveTo(lRect.Left,lRect.Top);
      FCanvas.LineTo(lRect.Left,FMaxColumnHeight+FActiveTopPosition);
    end;
    // Paints the remaining part of the column
    FCanvas.MoveTo(lRect.Left,FMaxColumnHeight+FActiveTopPosition);
    FCanvas.LineTo(lRect.Right,FMaxColumnHeight+FActiveTopPosition);
    FCanvas.LineTo(lRect.Right,lRect.Top);
    // Paints the text
    if FColumns[i].FieldName=NumerateFieldName then
    begin
      PaintCells(FCanvas,Rect(lRect.Left,lRect.Top,
        lRect.Right,FMaxColumnHeight+FActiveTopPosition),
        FColumns[i].Font,
        FColumns[i].Alignment,
        FColumns[i].Color,
        IntToStr(AutoNumber));
    end
     else
    begin
      PaintCells(FCanvas,Rect(lRect.Left,lRect.Top,
        lRect.Right,FMaxColumnHeight+FActiveTopPosition),
        FColumns[i].Font,
        FColumns[i].Alignment,
        FColumns[i].Color,
        FDataSet.FieldByName(FColumns[i].FieldName).asString);
    end;
  end;
end;

//****************************************************************
// Prints the rows
//****************************************************************
procedure TPrintGrid.PrintRows;
var Bookmark:TBookmark;
begin
  AddInLog('Preparing rows for output');
  AutoNumber:=1;
  //FDataSet.DisableControls;
  Bookmark:=FDataSet.GetBookmark;
  FDataSet.First;
  While not FDataSet.Eof do
  begin
    PrintRow;
    FDataSet.Next;
    Inc(AutoNumber);
    FActiveTopPosition:=FActiveTopPosition+FMaxColumnHeight;
    if FActiveTopPosition+FMaxColumnHeight>FHeight-FBottommargin then
    begin
      Inc(FPageNumber);
      if Assigned(FOnNextPageEvent) then FOnNextPageEvent(Self,FPageNumber);
      if FUsePrinter then
      begin
        Printer.NewPage;
        FActiveTopPosition:=FTopmargin;
        PrintPageNumber;
        PrintGridTitle;
      end;
    end;
  end;
  FDataSet.GotoBookmark(Bookmark);
  FDataSet.EnableControls;
end;

//**********************************************************************
// Prints the grid and formats to printer
//**********************************************************************
function TPrintGrid.Print: Boolean;
begin
  if fdataset=nil then exit;
  AddInLog('Formatting document');
  Result:=True;
  FUsePrinter:=True;
  if (FPrintDialog) then
  with TPrintDialog.Create(Self) do
  try
    Result:=Execute;
  finally
    Free;
  end;
  if Result then
  begin
    Printer.Orientation:=FPrintOrientation;
    FCanvas:=Printer.Canvas;
    FWidth:=Printer.PageWidth;
    FHeight:=Printer.PageHeight;
    Printer.BeginDoc;
    PaintCanvas;
    Printer.EndDoc;
  end;
  AddInLog('Formatting complete and job sent to printer');
  if Assigned(FPrintProgressBar) then
   FPrintProgressBar.Position := 0;
end;

//***************************************************************
// Compute and print page numbers
//***************************************************************
procedure TPrintGrid.PrintPageNumber;
begin
  AddInLog('Page number output');
  FCanvas.Font.Color:=FHeaderColor; //fcBlack
  FCanvas.Font.Size:=FPageNumFontSize; //8
  FCanvas.Font.Style:=[];
  FCanvas.Font.Name:= FPageNumFontName; //'Times New Roman';
  if FPrintPageNum then
   FCanvas.TextOut(FWidth-FCanvas.TextWidth('Page '+IntToStr(FPageNumber))-FRightmargin,FPageNumberTop,'Page '+IntToStr(FPageNumber));
end;

end.
