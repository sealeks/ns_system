//
// This is freeware, but, there are always a buts.
//  1.- If you improvit send me a copy please.
//  2.- If you inherit from it keep it freeware.
//  3.- If there are bugs
//       +-> You correct them goto 1
//       L-> You can't send info and I will give it a try
//
// Coments to clopez@intercom.es
//

unit EasyReport;

interface

uses
  Graphics, Classes, Windows;

type

// if we need to print
  TPrintEvent=procedure (Sender:TObject;Canvas:TCanvas;Area:TRect) of object;
  TPrintDetailEvent=function (Sender:TObject;Canvas:TCanvas;var Area:TRect):boolean of object;
  TPrintInformation=function (Sender:TObject):boolean of object;
  THeightInformation=function (Sender:TObject;Canvas:TCanvas):integer of object;

  TUnits=(uMilimiters,uInches,uPixels);

  TEasyReportOption=(erFirstPageHeader,erLastPageFooter);
  TEasyReportOptions=set of TEasyReportOption;
  TEasyAreaAlignment=(eaaTop,eaaBottom);

  TMargins = class(TPersistent)
  private
     fLeft,fTop,fRight,fBottom:Single;
  published
     property Left:Single read fLeft write fLeft;
     property Top:Single read fTop write fTop;
     property Right:Single read fRight write fRight;
     property Bottom:Single read fBottom write fBottom;
  end;

  TEasyPrintArea = class(TComponent)
  private
     fHeight:Integer;
     fPrint:TPrintEvent;
     fAlignment:TEasyAreaAlignment;
     fOnHeight:THeightInformation;
  public
     procedure Print(Sender:TObject;Canvas:TCanvas);
  published
     property Alignment:TEasyAreaAlignment read fAlignment write fAlignment;
     property Height:Integer read fHeight write fHeight;
     property OnPrint:TPrintEvent read fPrint write fPrint;
     property OnHeight:THeightInformation read fOnHeight write fOnHeight;
  end;

  TEasyReport = class(TComponent)
  private
    fTitlePrint:TEasyPrintArea;
    fPageHeaderPrint:TEasyPrintArea;
    fPageFooterPrint:TEasyPrintArea;
    fColumnHeaderPrint:TEasyPrintArea;
    fColumnFooterPrint:TEasyPrintArea;
    fSumaryPrint:TEasyPrintArea;
    fDetailPrint:TPrintDetailEvent;
    fIsLastPage:TPrintInformation;
    fBeforePrint:TNotifyEvent;
    fAfterPrint:TNotifyEvent;
    fUnits:TUnits;
    fMargins:TMargins;
    fColumns:Integer;
    fColumnSpace:Single;
    fOptions:TEasyReportOptions;
    procedure ReduceMargin;
    procedure PrintTitle;
    procedure PrintPageHeader;
    procedure PrintColumnHeader;
    procedure SetColumnClipRect(Rect:TRect;Column:Integer);
    procedure PrintColumnFooter;
    procedure PrintDetail;
    procedure PrintPageFooter;
    procedure PrintSumary;
    function HorzUnitsToPixels(Value:Single):Integer;
    function VertUnitsToPixels(Value:Single):Integer;
    procedure SetColumns(Value:Integer);
    function LastPage:Boolean;
    procedure SetTitlePrint(Value:TEasyPrintArea);
    procedure SetSumaryPrint(Value:TEasyPrintArea);
    procedure SetPageHeaderPrint(Value:TEasyPrintArea);
    procedure SetPageFooterPrint(Value:TEasyPrintArea);
    procedure SetColumnHeaderPrint(Value:TEasyPrintArea);
    procedure SetColumnFooterPrint(Value:TEasyPrintArea);
  protected
    procedure Notification(AComponent:TComponent;Operation:TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print;
    procedure LeftText(x,y:integer;c:string);
    procedure CenterText(x1,x2,y:integer;c:string);
    procedure RightText(x,y:integer;c:string);
  published
    property Margins:TMargins read fMargins write fMargins;
    property ColumnSpace:Single read fColumnSpace write fColumnSpace;
    property Units:TUnits read fUnits write fUnits;
    property Options:TEasyReportOptions read fOptions write fOptions;
    property Columns:Integer read fColumns write SetColumns;
    property TitlePrint:TEasyPrintArea read fTitlePrint write SetTitlePrint;
    property SumaryPrint:TEasyPrintArea read fSumaryPrint write SetSumaryPrint;
    property PageHeaderPrint:TEasyPrintArea read fPageHeaderPrint write SetPageHeaderPrint;
    property PageFooterPrint:TEasyPrintArea read fPageFooterPrint write SetPageFooterPrint;
    property ColumnHeaderPrint:TEasyPrintArea read fColumnHeaderPrint write SetColumnHeaderPrint;
    property ColumnFooterPrint:TEasyPrintArea read fColumnFooterPrint write SetColumnFooterPrint;
    property OnDetailPrint:TPrintDetailEvent read fDetailPrint write fDetailPrint;
    property OnBeforePrint:TNotifyEvent read fBeforePrint write fBeforePrint;
    property OnAfterPrint:TNotifyEvent read fAfterPrint write fAfterPrint;
    property IsLastPage:TPrintInformation read fIsLastPage write fIsLastPage;
  end;

procedure Register;

implementation

uses Printers;

//This is no a good way but I need it to restore clipping

var fOriginalRegion:TRect;
    fFirstTime:Boolean;

constructor TEasyReport.Create(AOwner: TComponent);
begin
   Inherited Create(AOwner);
   fMargins:=TMargins.Create;
   fUnits:=uMilimiters;
   fColumns:=1;
   fColumnSpace:=0;
   with fMargins do
   begin
      Left:=10;
      Right:=10;
      Top:=10;
      Bottom:=10;
   end;
end;

destructor TEasyReport.Destroy;
begin
   fMargins.Free;
   inherited Destroy;
end;

procedure TEasyReport.SetColumns(Value:Integer);
begin
// Just check columns is not set to 0
   if Value<=0 then exit;
   if Value=fColumns then exit;
   fColumns:=Value;
end;

// Do de printing
procedure TEasyReport.Print;
begin
// First check if the basic functions are aviable
   if not Assigned(fDetailPrint) then exit;
   if not Assigned(fIsLastPage) then exit;
// Ok, start document
   Printer.BeginDoc;
// There should be a way of reseting the full paint region
   if fFirstTime then fOriginalRegion:=Printer.Canvas.ClipRect;
   fFirstTime:=False;
// Do we need to do anything before printing
   if assigned(fBeforePrint) then fBeforePrint(Self);
//Set margins, print title, header and footter (for the first page)
   ReduceMargin;
   PrintTitle;
   if (erFirstPageHeader in fOptions) then PrintPageHeader;
   if (not LastPage) or (erLastPageFooter in fOptions) then PrintPageFooter;
// Until last page
   repeat
// Fill it
      PrintDetail;
      if not LastPage then
      begin
// If we nned to keep printing start new pages
         Printer.NewPage;
         ReduceMargin;
         PrintPageHeader;
         if (not LastPage) or (erLastPageFooter in fOptions) then PrintPageFooter;
      end;
   until LastPage;
// We are done, anithing else?
   if assigned(fAfterPrint) then fAfterPrint(Self);
   Printer.EndDoc;
end;

procedure TEasyReport.ReduceMargin;
var Rect,Minimun:TRect;
    pw,ph:Integer;
begin
// Select the entire page
   SelectClipRgn(Printer.Canvas.Handle,CreateRectRgnIndirect(fOriginalRegion));
// And reduce the margins (take care of no printing areas
   Minimun.Left:=GetDeviceCaps(Printer.Canvas.Handle,PhysicalOffsetX);
   Minimun.Top:=GetDeviceCaps(Printer.Canvas.Handle,PhysicalOffsetY);
   pw:=GetDeviceCaps(Printer.Canvas.Handle,PhysicalWidth);
   ph:=GetDeviceCaps(Printer.Canvas.Handle,PhysicalHeight);
   Rect.Left:=HorzUnitsToPixels(fMargins.Left)-Minimun.Left;
   Rect.Top:=VertUnitsToPixels(fMargins.Top)-Minimun.Top;
   Rect.Right:=pw-HorzUnitsToPixels(fMargins.Right)-Minimun.Left;
   Rect.Bottom:=ph-HorzUnitsToPixels(fMargins.Bottom)-Minimun.Top;
   IntersectClipRect(Printer.Canvas.Handle,Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
end;

// If assigned then print

procedure TEasyReport.PrintTitle;
begin
   if Assigned(fTitlePrint) then fTitlePrint.Print(Self,Printer.Canvas);
end;

procedure TEasyReport.PrintPageHeader;
begin
   if Assigned(fPageHeaderPrint) then fPageHeaderPrint.Print(Self,Printer.Canvas);
end;

procedure TEasyReport.PrintColumnHeader;
begin
   if Assigned(fColumnHeaderPrint) then fColumnHeaderPrint.Print(Self,Printer.Canvas);
end;

// Ok we have columns, so clip them from the detail area

procedure TEasyReport.SetColumnClipRect(Rect:TRect;Column:Integer);
var w:Integer;
    r2:TRect;
begin
   w:=(Rect.Right-Rect.Left-HorzUnitsToPixels(fColumnSpace)*(fColumns-1)) div fColumns;
   r2.Left:=(w+HorzUnitsToPixels(fColumnSpace))*(Column-1)+Rect.Left;
   r2.Right:=r2.Left+w;
   r2.Top:=Rect.Top;
   r2.Bottom:=Rect.Bottom;
   SelectClipRgn(Printer.Canvas.Handle,CreateRectRgnIndirect(Rect));
   IntersectClipRect(Printer.Canvas.Handle,r2.Left,r2.Top,r2.Right,r2.Bottom);
end;

// Fill then detail area

procedure TEasyReport.PrintDetail;
var Rect,ro:TRect;
    c:Integer;
    NoMoreData:Boolean;
begin
   Rect:=Printer.Canvas.ClipRect;
// Only one column
   if fColumns=1 then
   begin
// Fill it
      fDetailPrint(Self,Printer.Canvas,Rect);
      IntersectClipRect(Printer.Canvas.Handle,Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
      if LastPage then PrintSumary;
   end
   else
   begin
// There are more
      ro:=Rect;
      c:=1;
// Fill each column until eop or nmd (no more data)
      repeat
         SetColumnClipRect(ro,c);
         PrintColumnHeader;
         PrintColumnFooter;
         Rect:=Printer.Canvas.ClipRect;
         NoMoreData:=fDetailPrint(Self,Printer.Canvas,Rect);
         IntersectClipRect(Printer.Canvas.Handle,Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
         inc(c);
      until (c>fColumns) or (NoMoreData);
      if LastPage then PrintSumary;
   end;
end;

// Just visivility
function TEasyReport.LastPage:Boolean;
begin
   Result:=fIsLastPage(Self);
end;

// Also if assigned then print

procedure TEasyReport.PrintColumnFooter;
begin
   if Assigned(fColumnFooterPrint) then fColumnFooterPrint.Print(Self,Printer.Canvas);
end;

procedure TEasyReport.PrintPageFooter;
begin
   if Assigned(fPageFooterPrint) then fPageFooterPrint.Print(Self,Printer.Canvas);
end;

procedure TEasyReport.PrintSumary;
begin
   if Assigned(fSumaryPrint) then fSumaryPrint.Print(Self,Printer.Canvas);
end;

// We need unit convertions (both Horizontal and Vertical)

function TEasyReport.HorzUnitsToPixels(Value:Single):integer;
var hs,hr:Integer;
begin
   Result:=0;
   hs:=GetDeviceCaps(Printer.Canvas.Handle,HorzSize);
   hr:=GetDeviceCaps(Printer.Canvas.Handle,HorzRes);
   case fUnits of
      uMilimiters:Result:=Round(Value*hr/hs);
      uInches:Result:=Round(Value*254*hr/hs);
      uPixels:Result:=Round(Value);
   end;
end;

function TEasyReport.VertUnitsToPixels(Value:Single):integer;
var vs,vr:Integer;
begin
   Result:=0;
   vs:=GetDeviceCaps(Printer.Canvas.Handle,VertSize);
   vr:=GetDeviceCaps(Printer.Canvas.Handle,VertRes);
   case fUnits of
      uMilimiters:Result:=Round(Value*vr/vs);
      uInches:Result:=Round(Value*254*vr/vs);
      uPixels:Result:=Round(Value);
   end;
end;

// When adding a print object tell it to inform when is disposed

procedure TEasyReport.SetTitlePrint(Value:TEasyPrintArea);
begin
   fTitlePrint:=Value;
   if Assigned(fTitlePrint) then fTitlePrint.FreeNotification(Self);
end;

procedure TEasyReport.SetSumaryPrint(Value:TEasyPrintArea);
begin
   fSumaryPrint:=Value;
   if Assigned(fSumaryPrint) then fSumaryPrint.FreeNotification(Self);
end;

procedure TEasyReport.SetPageHeaderPrint(Value:TEasyPrintArea);
begin
   fPageHeaderPrint:=Value;
   if Assigned(fPageHeaderPrint) then fPageHeaderPrint.FreeNotification(Self);
end;

procedure TEasyReport.SetPageFooterPrint(Value:TEasyPrintArea);
begin
   fPageFooterPrint:=Value;
   if Assigned(fPageFooterPrint) then fPageFooterPrint.FreeNotification(Self);
end;

procedure TEasyReport.SetColumnHeaderPrint(Value:TEasyPrintArea);
begin
   fColumnHeaderPrint:=Value;
   if Assigned(fColumnHeaderPrint) then fColumnHeaderPrint.FreeNotification(Self);
end;

procedure TEasyReport.SetColumnFooterPrint(Value:TEasyPrintArea);
begin
   fColumnFooterPrint:=Value;
   if Assigned(fColumnFooterPrint) then fColumnFooterPrint.FreeNotification(Self);
end;

// If we get notified on disposal clear the print object

procedure TEasyReport.Notification(AComponent:TComponent;Operation:TOperation);
begin
   inherited Notification(AComponent,Operation);
   if Operation=opRemove then
   begin
      if AComponent=TitlePrint then TitlePrint:=nil;
      if AComponent=SumaryPrint then SumaryPrint:=nil;
      if AComponent=PageHeaderPrint then PageHeaderPrint:=nil;
      if AComponent=PageFooterPrint then PageFooterPrint:=nil;
      if AComponent=ColumnHeaderPrint then ColumnHeaderPrint:=nil;
      if AComponent=ColumnFooterPrint then ColumnFooterPrint:=nil;
   end;
end;

// Lets make it easier to write text

procedure TEasyReport.LeftText(x,y:integer;c:string);
begin
   Printer.Canvas.TextOut(x,y,c);
end;

procedure TEasyReport.CenterText(x1,x2,y:integer;c:string);
begin
   Printer.Canvas.TextOut((x1+x2-Printer.Canvas.TextWidth(c)) div 2,y,c);
end;

procedure TEasyReport.RightText(x,y:integer;c:string);
begin
   Printer.Canvas.TextOut(x-Printer.Canvas.TextWidth(c),y,c);
end;

// This is a printing object, clip its area, print and remove the area from original

procedure TEasyPrintArea.Print(Sender:TObject;Canvas:TCanvas);
var Area,OArea:TRect;
begin
   Area:=Canvas.ClipRect;
   OArea:=Canvas.ClipRect;
   if Assigned(fOnHeight) then Height:=fOnHeight(Sender,Canvas);
   if fAlignment=eaaTop then
       Area.Bottom:=Area.Top+fHeight
   else
      Area.Top:=Area.Bottom-fHeight;
   SelectClipRgn(Canvas.Handle,CreateRectRgnIndirect(Area));
   if Assigned(fPrint) then fPrint(Sender,Canvas,Area);
   SelectClipRgn(Canvas.Handle,CreateRectRgnIndirect(OArea));
   ExcludeClipRect(Canvas.Handle,Area.Left,Area.Top,Area.Right,Area.Bottom);
end;

// Oh! put components on the Samples page

procedure Register;
begin
  RegisterComponents('Samples', [TEasyReport,TEasyPrintArea]);
end;

// Remember to initialize those varaibles

begin
   fFirstTime:=True;
end.
