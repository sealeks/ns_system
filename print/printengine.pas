unit PrintEngine;

interface

uses Classes, DbGrids, Printers, Windows, Graphics, db;

type TPrintItemType = (
    txNone,
    txHeader,
    txHeader2,
    txHeader3,
    txHeading1,
    txHeading2,
    txText,
    txWrappedText,
    txStrings,
    txDBGridCaption,
    txDBGrid
);

type TPrintEngine = class

protected

    Items : TList;
    FHeader : TStrings;
    FHeader2 : TStrings;
    FHeader3 : TStrings;
    FFirstHeader : string;

    FDestFileName : string;
    FDestStream : TStream;

    // state machine stuff for printing
    FColumn : integer;
    FPrintNow : TDateTime;

    // print to paper state machine
    FColumnUsed : boolean;
    FPageNumber : integer;      // page we are up to - whether or not we put ink on it
    Y   : integer;              // position down current page, pixels
    FFirstBlockPrinted : boolean;   // kludge for block printing - will remove

    FMediaClean : boolean;      // paper actually current in TPrinter not written on
    FMediaComplete : boolean;   // paper written on and belongs to an earlier page number
    FMediaPageNumber : integer; // page number of paper actually current in TPrinter
    FMediaColumn : integer;  // col number of paper actually current in TPRinter

    FInvisible : boolean;       // text out functions do nothing

    // print to paper properties
    FOrientation : TPrinterOrientation;
    FTiled : boolean;          // if too wide, use page(s) to right }
    FPagedBlocks : boolean;    // start each block on new page }
    FSubBlockLines : integer;  // divide each block each this # lines
    FFromPage : integer;
    FToPage : integer;
    FLinePitch : integer;
    FLeftMargin : integer;      // unit = width of 10 pt Arial 'b' char
    FTopMargin : integer;       // unit = height of 10 pt Arial 'b' char

    // print to paper fonts
    FHeaderFont         : TFont;
    FHeader2Font        : TFont;
    FHeader3Font        : TFont;
    FHeading1Font       : TFont;
    FHeading2Font       : TFont;
    FTextFont           : TFont;
    FWrappedTextFont    : TFont;
    FStringsFont        : TFont;
    FDBGridCaptionFont  : TFont;
    FDBGridFont         : TFont;

    // print to paper working values
    { paper printable area }
    FCanvas : TCanvas;
    LeftPrintableX,
    RightPrintableX,
    TopPrintableY,
    BottomPrintableY : integer;

    { settings of each text type }
    FHeaderDY         : integer;
    FHeader2DY        : integer;
    FHeader3DY        : integer;
    FHeading1DY       : integer;
    FHeading2DY       : integer;
    FTextDY           : integer;
    FWrappedTextDY    : integer;
    FStringsDY        : integer;
    FDBGridCaptionDY  : integer;
    FDBGridDY     : integer;

    function RtfFormat( ItemType : TPrintItemType ) : string;

    // mechanics of printing
    procedure ProvideStream;
    procedure ReleaseStream;
    procedure PrepareForOutput; virtual;
    procedure LineToStream( const Text : string ); //virtual;

    // mechanics of printing to paper
    function PageWanted : boolean;
    procedure CheckPaper;
    procedure NewPage;
    procedure CanvasTextOut( x, y : integer; const text : string );
    procedure CanvasTextRect(Rect: TRect; X, Y: Integer; const Text: string);
    procedure CanvasTextJustified( ColumnLeft, ColumnRight : integer;
                Text : string; Alignment : TAlignment) ;


public
    property DestFileName : string read FDestFileName write FDestFileName;
    property DestStream : TStream read FDestStream write FDestStream;

    // print to paper settings
    property Orientation : TPrinterOrientation read FOrientation write FOrientation;
    property PagedBlocks : boolean read FPagedBlocks write FPagedBlocks;
    property Tiled : boolean read FTiled write FTiled;
    property SubBlockLines : integer read FSubBlockLines write FSubBlockLines;
    property FromPage : integer read FFromPage write FFromPage;
    property ToPage : integer read FToPage write FToPage;
    property LinePitch : integer read FLinePitch write FLinePitch;
    property LeftMargin : integer read FLeftMargin write FLeftMargin;
    property TopMargin : integer read FTopMargin write FTopMargin;

    // print to paper fonts
    property HeaderFont         : TFont read FHeaderFont write FHeaderFont;
    property Header2Font        : TFont read FHeader2Font write FHeader2Font;
    property Header3Font        : TFont read FHeader3Font write FHeader3Font;
    property Heading1Font       : TFont read FHeading1Font write FHeading1Font;
    property Heading2Font       : TFont read FHeading2Font write FHeading2Font;
    property TextFont           : TFont read FTextFont write FTextFont;
    property WrappedTextFont    : TFont read FWrappedTextFont write FWrappedTextFont;
    property StringsFont        : TFont read FStringsFont write FStringsFont;
    property DBGridCaptionFont  : TFont read FDBGridCaptionFont write FDBGridCaptionFont ;
    property DBGridFont         : TFont read FDBGridFont write FDBGridFont;



    // add printed material with these methods
    procedure Clear; virtual;
    procedure PrintHeader( const Text : string );
    procedure PrintHeader2( const Text : string );
    procedure PrintHeader3( const Text : string );
    procedure PrintHeading1( const Text : string );
    procedure PrintHeading2( const Text : string );
    procedure PrintText( const Text : string );
    procedure PrintWrappedText( const Text : string );
    procedure PrintStrings( strings : TStrings );
    procedure PrintDBGrid( DBGrid : TDBGrid; const Caption : string );
    procedure PrintDBGridBlock(
        DBGrid : TDBGrid; const Caption : string; KeyField : TField );

//    procedure PrintGraph;
//    procedure PrintBitmap( Bitmap : TBitmap );

    // produce a printout
    procedure OutputToPrinter;
    procedure OutputToText;
    procedure OutputToCsv;
    procedure OutputToHtml;
    procedure OutputToRtf;
    //    procedure OutputToInternet;
//    procedure PrintPreview;

    constructor Create; virtual;
    destructor Destroy; override;
end;


// ***************************************
// ****  CLASSES HOLD ITEMS TO PRINT *****
// ***************************************

type TPrintItem = class
    public
    FReport : TPrintEngine;
    FItemIndex : TPrintItemType;

    procedure LineToStream( const Text : string );
    function RtfFormat( ItemType : TPrintItemType ) : string;
    procedure SetupForPrinter; virtual;
    procedure OutputToPrinter; virtual;
    procedure OutputToText; virtual;
    procedure OutputToCSV; virtual;
    procedure OutputToHTML; virtual;
    procedure OutputToRtf; virtual;
    procedure OutputTointernet; virtual;
    constructor Create( PrintReport : TPrintEngine ); virtual;
    destructor Destroy; override;
end;

type TPrintHeading1 = class( TPrintItem )
    public
    FText : string;
    procedure Load( const s : string );
    procedure OutputToPrinter; override;
    procedure OutputToText; override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

type TPrintHeading2 = class( TPrintItem )
    public
    FText : string;
    procedure Load( const s : string );
    procedure OutputToPrinter; override;
    procedure OutputToText; override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

type TPrintText = class( TPrintItem )
    public
    FText : string;
    procedure Load( const s : string );
    procedure OutputToPrinter; override;
    procedure OutputToText;  override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

type TPrintWrappedText = class( TPrintItem )
    public
    FText : string;
    procedure Load( const s : string );
    procedure OutputToPrinter; override;
    procedure DoOutputToTextCSV( CSV : boolean );
    procedure OutputToText; override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

type TPrintStrings = class( TPrintItem )
    public
    FStrings : TStringList;
    constructor Create( PrintReport : TPrintEngine ); override;
    destructor Destroy; override;
    procedure Load( s : TStrings );
    procedure OutputToPrinter; override;
    procedure OutputToText; override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

type TPrintDBGrid = class( TPrintItem )
    public
    FColumns : TCollection;
    FCaption : string;
    FColumnGap : integer;

    // state machine variables during printing
    FNextColumnToWrite : integer;

    constructor Create( PrintReport : TPrintEngine ); override;
    destructor Destroy; override;
    procedure Load( DBGrid : TDBGrid; const Caption : string );
    procedure LoadBlock(
        DBGrid : TDBGrid; const Caption : string; KeyField : TField );
    procedure OutputPrinterColHeadings;
    procedure OutputPrinterRow( RowIndex : integer );
    procedure ToNextPrinterCol;
    procedure SetupForPrinter; override;
    procedure OutputToPrinter; override;
    procedure OutputToText; override;
    procedure OutputToCSV; override;
    procedure OutputToHTML; override;
    procedure OutputToRtf; override;
end;

{ TColData - class used to store columns in a TPrintDBGrid }

type TColData = class( TCollectionItem )

    public
    FTitle : string;
    FTitleAlignment : TAlignment;
    FAlignment : TAlignment;
    FPrinterWidth : integer;
    FGridWidth : integer;
    FGridStandardTextWidth : integer;
    FCells : TStringList;
    FCharsWidth : integer;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
end;


implementation

uses Forms, SysUtils, Justify;


{ ***** REMOVE COMMAS FROM STRING ***** }

function DeComma( Text : string ) : string;
var CommaPos : integer;
begin
    while True do begin
        CommaPos := Pos( ',', Text );
        if CommaPos = 0 then
            break;
        Text[CommaPos] := ' ';
    end;
    result := Text;
end;

// return TRUE if DBGrid field to be included in printout
function ColumnWanted( Col : TColumn ) : boolean;
var Field : TField;
begin

    Field := Col.Field;

    // ignore unused fields and calculated fields
    result :=

        (Field <> nil) and       // ignore unused fields and calculated fields
{$IFDEF VER130} // D5 has Col.Visible
        (Col.Visible) and           // ignore invisible columnss
{$ENDIF}
//        (Col.Field.Visible) and   // ignore invisible fields
        (Col.Width >= 2)            // ignore very narrow fields
    ;
end;

//*** PRODUCE RTF FORMAT STRING FOR A PARTICULAR TEXT ITEM ***

function TPrintEngine.RtfFormat( ItemType : TPrintItemType ) : string;
var Font : TFont;
begin
    case ItemType of

        txHeader : begin
            Font := FHeaderFont;
        end;
        txHeader2 : begin
            Font := FHeader2Font;
        end;
        txHeader3 : begin
            Font := FHeader3Font;
        end;
        txHeading1 : begin
            Font := FHeading1Font;
        end;
        txHeading2 : begin
            Font := FHeading2Font;
        end;
        txText : begin
            Font := FTextFont;
        end;
        txWrappedText : begin
            Font := FWrappedTextFont;
        end;
        txStrings : begin
            Font := FStringsFont;
        end;
        txDBGridCaption : begin
            Font := FDBGridCaptionFont;
        end;
        txDBGrid : begin
            Font := FDBGridFont;
        end
        else begin
            raise Exception.Create('Missing print item type' );
        end;
    end;
    result := Format(
        's%d\f%d\fs%d', [ Ord(ItemType), Ord(ItemType), Font.Size * 2] );
    if fsBold in Font.Style then begin
        result := result + '\b';
    end;
    if fsItalic in Font.Style then begin
        result := result +  '\i'
    end;
    if fsUnderline in Font.Style then begin
        result := result + '\ul'
    end;
end;

//*** PRODUCE RTF FORMAT STRING FOR A TEXT ITEM - TPrintItem VERSION ***

function TPrintItem.RtfFormat( ItemType : TPrintItemType ) : string;
begin
    result := FReport.RtfFormat( ItemType );
end;

{ TPrintStrings }

constructor TPrintStrings.Create;
begin
    inherited;
    FStrings := TStringList.Create;
end;

destructor TPrintStrings.Destroy;
begin
    FStrings.Free;
    inherited;
end;



constructor TColData.Create(Collection: TCollection);
begin
    inherited Create( Collection );
    FCells := TStringList.Create;
end;

destructor TColData.Destroy;
begin
    FCells.Free;
    inherited;
end;


{ TPrintItem }

constructor TPrintItem.Create( PrintReport : TPrintEngine );
begin
    FReport := PrintReport;
end;

destructor TPrintItem.Destroy;
begin
    inherited;
end;

procedure TPrintItem.LineToStream( const Text : string );
begin
    FReport.LineToStream( Text );
end;

procedure TPrintItem.SetupForPrinter;
begin
    // do nothing - descendants of this class will override this method
end;

procedure TPrintItem.OutputToPrinter;
begin
    // do nothing - descendants of this class will override this method
end;

procedure TPrintItem.OutputToText;
begin
    // do nothing - descendants of this class will override this method
end;

procedure TPrintItem.OutputToCSV;
begin
    // do nothing - descendants of this class will override this method
end;

procedure TPrintItem.OutputToHTML;
begin
    // do nothing - descendants of this class will override this method
end;


procedure TPrintItem.OutputToRtf;
begin
    // do nothing - descendants of this class will override this method
end;

procedure TPrintItem.OutputTointernet;
begin
    // do nothing - descendants of this class will override this method
end;


{ TPrintHeading1 }

procedure TPrintHeading1.Load( const s : string );
begin
    FText := s;
end;

procedure TPrintHeading1.OutputToPrinter;
begin
    if FText = '' then begin
        exit;
    end;
    
    Inc( FReport.Y, FReport.FHeading1DY );
    if FReport.Y > FReport.BottomPrintableY + FReport.FHeading1DY then begin
        FReport.NewPage;
    end;

    if FReport.FColumn = 0 then begin
        FReport.FCanvas.Font := FReport.FHeading1Font;
        FReport.CanvasTextOut( FReport.LeftPrintableX, FReport.Y, FText );
    end;
    Inc( FReport.Y, FReport.FHeading1DY );
end;

procedure TPrintHeading1.OutputToText;
begin
    LineToStream( '' );
    LineToStream( FText );
end;

procedure TPrintHeading1.OutputToCSV;
begin
    LineToStream( '' );
    LineToStream( DeComma(FText) );
end;

procedure TPrintHeading1.OutputToHTML;
begin
    LineToStream( '<P>' );
    LineToStream( FText );
    LineToStream( '</P>' );
end;

procedure TPrintHeading1.OutputToRtf;
begin
    if FText = '' then begin
        exit;
    end;

    LineToStream( Format(
        '\pard\plain\%s\par ', [RtfFormat(txHeading1)] ) );
    LineToStream( Format(
        '%s\par', [FText] ) );
end;

{ TPrintHeading2 }

procedure TPrintHeading2.Load( const s : string );
begin
    FText := s;
end;

procedure TPrintHeading2.OutputToPrinter;
begin
    if FText = '' then begin
        exit;
    end;
    Inc( FReport.Y, FReport.FHeading2DY );
    if FReport.Y > FReport.BottomPrintableY + FReport.FHeading2DY then begin
        FReport.NewPage;
    end;
    if FReport.FColumn = 0 then begin
        FReport.FCanvas.Font := FReport.FHeading2Font;
        FReport.CanvasTextOut( FReport.LeftPrintableX, FReport.Y, FText );
    end;
    Inc( FReport.Y, FReport.FHeading2DY );
end;

procedure TPrintHeading2.OutputToText;
begin
    LineToStream( '' );
    LineToStream( FText );
end;

procedure TPrintHeading2.OutputToCSV;
begin
    LineToStream( '' );
    LineToStream( DeComma(FText) );
end;

procedure TPrintHeading2.OutputToHTML;
begin
    LineToStream( '<P>' );
    LineToStream( FText );
    LineToStream( '</P>' );
end;

procedure TPrintHeading2.OutputToRtf;
begin
    if FText = '' then begin
        exit;
    end;

    LineToStream( Format(
        '\pard\plain\%s\par ', [RtfFormat(txHeading2)] ) );
    LineToStream( Format(
        '%s\par', [FText] ) );
end;


//{ TPrintText }

procedure TPrintText.Load( const s : string );
begin
    FText := s;
end;

procedure TPrintText.OutputToPrinter;
begin
    if FText = '' then begin
        exit;
    end;
    Inc( FReport.Y, FReport.FTextDY );
    if FReport.Y > FReport.BottomPrintableY + FReport.FTextDY then begin
        FReport.NewPage;
    end;
    if FReport.FColumn = 0 then begin
        FReport.FCanvas.Font := FReport.FTextFont;
        FReport.CanvasTextOut( FReport.LeftPrintableX, FReport.Y, FText );
    end;
    Inc( FReport.Y, FReport.FTextDY );
end;

procedure TPrintText.OutputToText;
begin
    LineToStream( '' );
    LineToStream( FText );
end;

procedure TPrintText.OutputToCSV;
begin
    LineToStream( '' );
    LineToStream( DeComma(FText) );
end;

procedure TPrintText.OutputToHTML;
begin
    LineToStream( '<P>' );
    LineToStream( FText );
    LineToStream( '</P>' );
end;

procedure TPrintText.OutputToRtf;
begin
    if FText = '' then begin
        exit;
    end;
//    LineToStream( Format( '{\pard\plain\s%d\par}', [Ord(txText)] )   );
//    LineToStream( Format( '{\pard\plain\s%d\par %s}', [Ord(txText), FText] ) );

    LineToStream( Format(
        '\pard\plain\%s\par ', [RtfFormat(txText)] ) );
    LineToStream( Format(
        '%s\par', [FText] ) );
end;

{ TPrintWrappedText }

procedure TPrintWrappedText.Load( const s : string );
begin
    FText := s;
end;

procedure TPrintWrappedText.OutputToPrinter;

var
    Canvas : TCanvas;

    pLineStart,         // 1st char in line
    pScan,              // scan pointer
    pLineEnd : pChar;   // last +1 char in line

    PageWidth : integer;
    Line : array[0..1023] of char;

begin
    if FText = '' then begin
        exit;
    end;
    //
    PageWidth := (FReport.RightPrintableX - FReport.LeftPrintableX);
    Canvas := FReport.FCanvas;
    Canvas.Font := FReport.FWrappedTextFont;

    // leave a blank line
    Inc( FReport.Y, FReport.FWrappedTextDY );
    if FReport.Y > FReport.BottomPrintableY + FReport.FWrappedTextDY then begin
        FReport.NewPage;
    end;

    // parse all lines
    pScan := pChar( FText );
    while pScan^ <> #0 do begin

        pLineStart := pScan;   // at least one character !

        // parse one line
        pLineEnd := nil;
        while pScan^ <> #0 do begin

            // find position of next space
            while pScan^ <> #0 do begin
                if pScan^ = ' ' then begin
                    break;
                end;
                Inc( pScan )
            end;

            // see if we have exceeded RHS of paper
            StrLCopy( Line, pLineStart, pScan - pLineStart );

            if Canvas.TextWidth( string(Line)) > PageWidth then begin

                // if we have a space previously on this line, print the line
                if pLineEnd <> nil then begin
                    break;  // print it
                end

                else begin
                    // no space previously on this line, so go back char by char
                    // until line fits.  But permit at least one character
                    pLineEnd := pScan -1;
                    while pLineEnd > pLineStart do begin

                        StrLCopy( Line, pLineStart, pScan - pLineStart );

                        if Canvas.TextWidth( string(Line)) >= PageWidth then begin
                            break;
                        end;
                        dec( pLineEnd )
                    end
                end;
                break;  // print it
            end;

            // we have not exceeded RHS of line, so remember this location for
            // use as fallback if next space exceeds line end
            pLineEnd := pScan;

            // to next char
            Inc( pScan );
        END;

        // print the line
        StrLCopy( Line, pLineStart, pLineEnd - pLineStart );
        if FReport.FColumn < 1 then begin
            FReport.CanvasTextOut( FReport.LeftPrintableX, FReport.Y, string(Line) );
        end;

        // move scan back to end of last lne
        pScan := pLineEnd;

        // Skip multiple spaces
        while pScan^ <> #0 do begin
            if pScan^ <> ' ' then begin
                break;
            end;
            Inc( pScan )
        end;

        // move down the page
        Inc( FReport.Y, FReport.FWrappedTextDY );
        if FReport.Y > FReport.BottomPrintableY + FReport.FWrappedTextDY then begin
            FReport.NewPage;
        end;
    end;
end;


procedure TPrintWrappedText.DoOutputToTextCSV( CSV : boolean );

var LinePos : integer;
    LineEnd : integer;
    WrappedAtSpace : boolean;

const
    MinWrapWidth = 60;  // force wrap if no space after this character position
    LineWidth = 80;     // lines no longer than this # of characters

begin
    LineToStream( '' );

    // ** wrap algorithm needs rework so can better handle wrap at point where
    // mmultiple spaces exist.

    // Wrap text at 80 col widths
    LinePos := 1;
    while LinePos <= Length( FText ) do begin

        WrappedAtSpace := False;
        LineEnd := LinePos + LineWidth;

        // If text does not finish on this line then
        // move searchpos to a suitable wrap point.
        if LineEnd < Length( FText ) then begin
            while LineEnd > LinePos + MinWrapWidth do  begin
                // found a space
                if FText[LineEnd] = ' ' then begin
                    WrappedAtSpace := True;
                    break;
                end;
                Dec( LineEnd );
            end
        end;

        if CSV then begin
            LineToStream( DeComma(copy( FText, LinePos, LineEnd - LinePos )) );
        end
        else begin
            LineToStream( copy( FText, LinePos, LineEnd - LinePos ) );
        end;
        LinePos := LineEnd;

      // discards space we wrapped at
        if WrappedAtSpace then begin
            Inc( LinePos );
        end;
    end;
end;


procedure TPrintWrappedText.OutputToText;
begin
    DoOutputToTextCSV( False );
end;

procedure TPrintWrappedText.OutputToCSV;
begin
    DoOutputToTextCSV( True );
end;

procedure TPrintWrappedText.OutputToHTML;
begin
    LineToStream( '<P>' );
    DoOutputToTextCSV( False );
    LineToStream( '</P>' );
end;

procedure TPrintWrappedText.OutputToRtf;
begin
    if FText = '' then begin
        exit;
    end;
//    LineToStream( Format( '{\pard\plain\s%d\par}', [Ord(txWrappedText)] )   );
//    LineToStream( Format( '{\pard\plain\s%d\par %s}', [Ord(txWrappedText), FText] )   );
    LineToStream( Format(
        '\pard\plain\%s\par ', [RtfFormat(txWrappedText)] ) );
    LineToStream( Format(
        '%s\par', [FText] ) );
end;


{ TPrintStrings }

procedure TPrintStrings.Load( s : TStrings );
begin
    FStrings.Assign( s );
end;


procedure TPrintStrings.OutputToPrinter;
var StringIndex : integer;
begin
    // NEED TO CHECK FOR NEW PAGE **
    FReport.FInvisible := FReport.FColumn > 0;
    FReport.FCanvas.Font := FReport.FStringsFont;
    Inc( FReport.Y, FReport.FStringsDY );
    for StringIndex := 0 to FStrings.Count -1 do begin
        FReport.CanvasTextOut(
            FReport.LeftPrintableX, FReport.Y, FStrings[StringIndex] );
        Inc( FReport.Y, FReport.FStringsDY );
    end;
    FReport.FInvisible := False;
end;

procedure TPrintStrings.OutputToText;
var StringIndex : integer;
begin
    LineToStream( '' );
    for StringIndex := 0 to FStrings.Count -1 do begin
        LineToStream( FStrings[StringIndex] );
    end;
end;

procedure TPrintStrings.OutputToCSV;
var StringIndex : integer;
begin
    LineToStream( '' );
    for StringIndex := 0 to FStrings.Count -1 do begin
        LineToStream( DeComma(FStrings[StringIndex]) );
    end;
end;

procedure TPrintStrings.OutputToHTML;
var StringIndex : integer;
begin
    LineToStream( '<P>' );
    for StringIndex := 0 to FStrings.Count -1 do begin
        LineToStream( DeComma(FStrings[StringIndex]) + '<BR>' );
    end;
    LineToStream( '</P>' );
end;

procedure TPrintStrings.OutputToRtf;
var StringIndex : integer;
begin
    LineToStream( Format(
        '\pard\plain\%s\par ', [RtfFormat(txStrings)] ) );
    for StringIndex := 0 to FStrings.Count -1 do begin
        LineToStream( Format( '{\par %s}', [ FStrings[StringIndex] ] )   );
    end;
    LineToStream( '\par' );
(*
    LineToStream( Format( '{\pard\plain\s%d\par}', [Ord(txStrings)] )   );
    for StringIndex := 0 to FStrings.Count -1 do begin
        LineToStream( Format( '{\pard\plain\s%d\par %s}', [Ord(txStrings),
        FStrings[StringIndex] ] )   );
    end;
*)
end;


{ TPrintDBGrid }

constructor TPrintDBGrid.Create;
begin
    inherited;
    FColumns := TCollection.Create( TColData );
end;

destructor TPrintDBGrid.Destroy;
begin
    FColumns.Free;
    inherited;
end;

procedure TPrintDBGrid.Load( DBGrid : TDBGrid; const Caption : string );
var
    ColIndex : integer;
    Column : TColumn;
    ColData : TColData;
    DataSet : TDataSet;
    Canvas : TCanvas;
    SavePlace : TBookmark;
    ColDataIndex : integer;

begin
    // store grid caption
    FCaption := Caption;

    // add data about each column to the TPrintDBGrid object
    for ColIndex := 0 to DBGrid.Columns.Count -1 do begin

        Column := DBGrid.Columns[ColIndex];
        if not ColumnWanted( Column ) then begin
            continue
        end;

        // found a displayable column - add a TColData to PrintDBGrid
        ColData := TColData( FColumns.Add );

        // - column title
        ColData.FTitle := Column.Title.Caption;

        // - column title alignment
//        ColData.FTitleAlignment := Column.Title.Alignment;
        // Force column title alignment to be same as column data alignment.
        // If this is too inflexible, add a property to switch title alignment
        // between Col.Title.Alignment and Col.Alignment
        ColData.FTitleAlignment := Column.Alignment;

        // - column alignment
        ColData.FAlignment := Column.Alignment;

        // - column width, pixels ( 32 bit integer in bytes 2,3,4,5 )
        ColData.FGridWidth := Column.Width;

        // - width of a standard slab of text written using column font
        Canvas := DbGrid.Canvas;

        Canvas.Font := Column.Font;
        ColData.FGridStandardTextWidth :=
            Canvas.TextWidth( 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqrstuv' );
    end;


    // capture all rows from underlying dataset
    // save data from underlying dataset  This is a chunk of simple strings -
    // ... one string per column per row.  Once row for each
    DataSet := DBGrid.DataSource.DataSet;

    DataSet.DisableControls;
    try

        SavePlace := DataSet.GetBookmark;
        try
            DataSet.First;
            while not DataSet.EOF do begin

                // start of row - start at leftmost TColData
                ColDataIndex := 0;

                for ColIndex := 0 to DBGrid.Columns.Count -1 do begin

                    Column := DBGrid.Columns[ColIndex];
                    if not ColumnWanted( Column ) then begin
                        continue
                    end;

                    // add this cell to the ColData
                    TColData(FColumns.Items[ColDataIndex])
                        .FCells.Add( Column.Field.DisplayText );

                    // move to next ColData
                    Inc( ColDataIndex );
                end;

                DataSet.Next;
            end;

            DataSet.GotoBookmark( SavePlace );
        finally
            DataSet.FreeBookmark( SavePlace );
        end;

    finally
        DataSet.EnableControls;
    end;
end;


procedure TPrintDBGrid.LoadBlock(
        DBGrid : TDBGrid; const Caption : string; KeyField : TField );

var
    ColIndex : integer;
    Column : TColumn;
    ColData : TColData;
    DataSet : TDataSet;
    Canvas : TCanvas;
    ColDataIndex : integer;
    KeyFieldValue : string;

begin
    // store grid caption
    FCaption := Caption;

    // add data about each column to the TPrintDBGrid object
    for ColIndex := 0 to DBGrid.Columns.Count -1 do begin

        Column := DBGrid.Columns[ColIndex];
        if not ColumnWanted( Column ) then begin
            continue
        end;

        // ignore column which is keyfield
        if Column.Field = KeyField then begin
            continue;
        end;

        // found a displayable column - add a TColData to PrintDBGrid
        ColData := TColData( FColumns.Add );

        // - column title
        ColData.FTitle := Column.Title.Caption;

        // - column title alignment
        // Force column title alignment to be same as column data alignment.
        // If this is too inflexible, add a property to switch title alignment
        // between Col.Title.Alignment and Col.Alignment
//        ColData.FTitleAlignment := Column.Title.Alignment;
        ColData.FTitleAlignment := Column.Alignment;

        // - column alignment
        ColData.FAlignment := Column.Alignment;

        // - column width, pixels ( 32 bit integer in bytes 2,3,4,5 )
        ColData.FGridWidth := Column.Width;

        // - width of a standard slab of text written using column font
        Canvas := DbGrid.Canvas;

        Canvas.Font := Column.Font;
        ColData.FGridStandardTextWidth :=
            Canvas.TextWidth( 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqrstuv' );
    end;


    // capture all rows from underlying dataset
    // save data from underlying dataset  This is a chunk of simple strings -
    // ... one string per column per row.  Once row for each
    DataSet := DBGrid.DataSource.DataSet;

    DataSet.DisableControls;
    try
       // capture keyfield value for this block
       KeyFieldValue := KeyField.AsString;

        while not DataSet.EOF do begin

            // check that keyfield has not changed for this row
            if KeyField.AsString <> KeyFieldValue then begin
                break;
            end;

            // start of row - start at leftmost TColData
            ColDataIndex := 0;

            for ColIndex := 0 to DBGrid.Columns.Count -1 do begin

                Column := DBGrid.Columns[ColIndex];

                if not ColumnWanted( Column ) then begin
                    continue
                end;

                if Column.Field = KeyField then begin
                    continue;
                end;

                // add this cell to the ColData
                TColData(FColumns.Items[ColDataIndex])
                    .FCells.Add( Column.Field.DisplayText );

                // move to next ColData
                Inc( ColDataIndex );
            end;

            DataSet.Next;
        end;

        // Move dataset cursor to new block of data
        // by skipping any rows where keyfield is blank.
        while not DataSet.EOF do begin
            // check that keyfield has not changed for this row
            if Trim(KeyField.AsString) <> '' then begin
                break;
            end;
            DataSet.Next
        end;

    finally
        DataSet.EnableControls;
    end;
end;

procedure TPrintDBGrid.SetupForPrinter;

var ColIndex : integer;
    ColData : TColData;
    PrinterStandardTextWidth : integer;

begin
    // Note This proc called AFTER Printer.BeginDoc has set printer canvas
    //

    // get standard text width for printer canvas
    // Note : This proc called AFTER Printer.BeginDoc has set printer canvas.
    FReport.FCanvas.Font := FReport.FDBGridFont;
    PrinterStandardTextWidth :=
        FReport.FCanvas.TextWidth( 'ABCDEFGHIJKLMNOPQRSTUVabcdefghijklmnopqrstuv' );

    // Calculate column widths in pixels of each column - & store widths
    // Methodology - make ratio of StandardTextWidth : ColumnWidthInPixels
    // for the Printer.Canvas match the ratio of the Grid screen display.
    for ColIndex := 0 to FColumns.Count -1 do begin

        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );

        ColData.FPrinterWidth :=
            (PrinterStandardTextWidth * ColData.FGridWidth) div
            ColData.FGridStandardTextWidth;
    end;

    // calculate gap between columns
    FColumnGap := FReport.FCanvas.TextWidth( 'A' );

    // state machine stuff before a print
    FNextColumnToWrite := 0;
end;

procedure TPrintDBGrid.ToNextPrinterCol;

var X : integer;
    ColIndex : integer;
    ColCount : integer;
    ColData : TColData;
    ColumnRight : integer;

begin
    // calculate which column we start printing at on next paper column

    // ... pretend to write columns from the left
    ColCount := FColumns.Count;
    X := FReport.LeftPrintableX;
    ColIndex := FNextColumnToWrite;
    while ColIndex < ColCount do begin

        ColData := TColData(FColumns.Items[ColIndex] );

        // print the heading for this column
        ColumnRight := X + ColData.FPrinterWidth;

        // goto start of next column
        X := ColumnRight + FColumnGap;

        // to next column
        Inc( ColIndex );

        // if no more cols to output, leave at ColCount
        if ColIndex >= ColCount then begin
            break;
        end;

        // if end of next col is beyond page right border then leave the next
        // col to the next paper column
        if X + TColData(FColumns.Items[ColIndex]).FPrinterWidth
            > FReport.RightPrintableX then begin
            break;
        end;
    end;

    FNextColumnToWrite := ColIndex;
end;


procedure TPrintDBGrid.OutputPrinterColHeadings;

var X : integer;
    ColIndex : integer;
    ColCount : integer;
    ColData : TColData;
    ColumnRight : integer;

begin
    // select column font
    FReport.FCanvas.Font := FReport.DBGridFont;

    // leave 1 blank lines before headings
    Inc( FReport.Y, FReport.FDBGridDY );

    // write columns from the left
    ColCount := FColumns.Count;
    X := FReport.LeftPrintableX;
    ColIndex := FNextColumnToWrite;
    while ColIndex < ColCount do begin

        ColData := TColData(FColumns.Items[ColIndex] );

        // print the heading for this column
        ColumnRight := X + ColData.FPrinterWidth;
        FReport.CanvasTextJustified( X, ColumnRight,
            ColData.FTitle, ColData.FTitleAlignment );

        // goto start of next column
        X := ColumnRight + FColumnGap;

        // to next column
        Inc( ColIndex );

        // if no more cols to output, leave at ColCount
        if ColIndex >= ColCount then begin
            break;
        end;

        // if end of next col is beyond page right border then leave the next
        // col to the next paper column
        if X + TColData(FColumns.Items[ColIndex]).FPrinterWidth
            > FReport.RightPrintableX then begin
            break;
        end;
    end;

    // leave 1 blank lines under headings
    Inc( FReport.Y, FReport.FDBGridDY * 2 );
end;


procedure TPrintDBGrid.OutputPrinterRow( RowIndex : integer );

var X : integer;
    ColIndex : integer;
    ColCount : integer;
    ColData : TColData;
    ColumnRight : integer;

begin
    // select column font
    FReport.FCanvas.Font := FReport.DBGridFont;

    // write columns from the left
    ColCount := FColumns.Count;
    X := FReport.LeftPrintableX;
    ColIndex := FNextColumnToWrite;
    while ColIndex < ColCount do begin

        ColData := TColData(FColumns.Items[ColIndex] );

        // print a cell from this column
        ColumnRight := X + ColData.FPrinterWidth;
        FReport.CanvasTextJustified( X, ColumnRight,
            ColData.FCells[RowIndex], ColData.FAlignment );

        // goto start of next column
        X := ColumnRight + FColumnGap;

        // to next column
        Inc( ColIndex );

        // if no more cols to output, leave at ColCount
        if ColIndex >= ColCount then begin
            break;
        end;

        // if end of next col is beyond page right border then leave the next
        // col to the next paper column
        if X + TColData(FColumns.Items[ColIndex]).FPrinterWidth
            > FReport.RightPrintableX then begin

            break;
        end;
    end;

    Inc( FReport.Y, FReport.FDBGridDY );
end;


procedure TPrintDBGrid.OutputToPrinter;

const MinBodyBlock = 5; // blank, col heading, blank, body, body

var RequireNewPage : boolean;
    MinimumNewBlockY : integer;
    RowIndex : integer;
    LinesInBlock : integer;

begin
    // we are printing to a new paper column.
    // do any paper col calcs here ??

    // work out if DBGrid caption should start on next page
    RequireNewPage := False;

    { ...test for NewPagePerBlock property set to True }
    if FReport.FPagedBlocks and FReport.FFirstBlockPrinted then begin
        RequireNewPage := True;
    end

    else begin
    { ...go to new page if not enough room for block title,
        blank line of body, column headings in body font,
        blank line of body and MinBodyBlock lines of body }

        MinimumNewBlockY := FReport.FDBGridDY * MinBodyBlock;
        if FCaption <> '' then begin
            Inc( MinimumNewBlockY, FReport.FDBGridCaptionDY * 2  );
        end;

        if MinimumNewBlockY > FReport.BottomPrintableY - FReport.Y then begin
            RequireNewPage := True;
        end;
    end;

    FReport.FFirstBlockPrinted := True; // kludge

    if RequireNewPage then begin
        FReport.NewPage;
    end;

    // leave line before DB Grid caption.  If caption is empty string
    // then we still need this line for correct appearance
    Inc( FReport.Y, FReport.FDBGridCaptionDY );

    // Write DB Grid caption - only if we have Grid cols to print on
    // this paper col .
    if (FCaption <> '') and (FNextColumnToWrite < FColumns.Count) then begin

        // select caption font
        FReport.FCanvas.Font := FReport.DBGridCaptionFont;

        FReport.CanvasTextOut( FReport.LeftPrintableX, FReport.Y, FCaption );
        Inc( FReport.Y, FReport.FDBGridCaptionDY );
    end;

    // print column headings
    OutputPrinterColHeadings;

    // print column contents
    LinesInBlock := 0;
    for RowIndex := 0 to TColData(FColumns.Items[0]).FCells.Count -1 do begin

        // if nth row, output a blank line
        if LinesInBlock >= FReport.FSubBlockLines then begin
            Inc( FReport.Y, FReport.FDBGridDY );
            LinesInBlock := 0;
        end;

        // check if new page needed
        if FReport.Y + FReport.FDBGridDY > FReport.BottomPrintableY then begin
            FReport.NewPage;
            OutputPrinterColHeadings;
            LinesInBlock := 0;
        end;

        OutputPrinterRow( RowIndex );
        Inc( LinesInBlock );
    end;

    // set FNextColumnToWrite ready next paper column to right of this page
    ToNextPrinterCol;
end;


procedure TPrintDBGrid.OutputToText;
var ColIndex : integer;
    ColData : TColData;
    ColCharsWidth : integer;
    CellIndex : integer;
    ThisCellWidth : integer;
    LineIndex : integer;
    Line : string;

begin
    LineToStream( '' );

    // print grid heading
    if FCaption <> '' then begin
        LineToStream( FCaption );
        LineToStream( '' );
    end;

    // no data to print if no columns
    //... later code will break if no columns !
    if FColumns.Count < 1 then begin
        exit;
    end;

    // rip thru strings and find widest value in each column.
    // and save width in TColData.FCharsWidth
    for ColIndex := 0 to FColumns.Count -1 do begin

        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );

        // find max length of every string in this column
        ColCharsWidth := length( ColData.FTitle );

        for CellIndex := 0 to ColData.FCells.Count -1 do begin
            ThisCellWidth := length( ColData.FCells[CellIndex] );
            if ThisCellWidth > ColCharsWidth then begin
                ColCharsWidth := ThisCellWidth;
            end;
        end;
        ColData.FCharsWidth := ColCharsWidth;
    end;


    // print column headings
    Line := '';
    for ColIndex := 0 to FColumns.Count -1 do begin

        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );

        // get print using cell text, width, alignment
        Line := Line + Align(
            ColData.FTitle,
            ColData.FCharsWidth, ColData.FTitleAlignment ) + ' ';
    end;
    LineToStream( Line );
    LineToStream( '' );

    // print column contents
    for LineIndex := 0 to TColData(FColumns.Items[0]).FCells.Count -1 do begin

        // print across a row
        Line := '';
        for ColIndex := 0 to FColumns.Count -1 do begin

            // get ref to a column
            ColData := TColData(FColumns.Items[ColIndex] );

            // get print using cell text, width, alignment
            Line := Line + Align(
                    ColData.FCells[LineIndex],
                ColData.FCharsWidth, ColData.FAlignment ) + ' ';
        end;

        LineToStream( Line );
    end;
end;

procedure TPrintDBGrid.OutputToCSV;

var ColIndex : integer;
    ColData : TColData;
    LineIndex : integer;
    Line : string;

begin

    LineToStream( '' );

    // print grid heading
    if FCaption <> '' then begin
        LineToStream( FCaption );
        LineToStream( '' );
    end;

    // no data to print if no columns
    //... later code will break if no columns !
    if FColumns.Count < 1 then begin
        exit;
    end;

    // print column headings
    // ...col 0 does not start with a ',' delimiter
    ColData := TColData(FColumns.Items[0] );
    Line := DeComma(ColData.FTitle);

    // ...col 1 onward start with a ',' delimiter
    for ColIndex := 1 to FColumns.Count -1 do begin

        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );

        // print col heading
        Line := Line + ',' + DeComma(ColData.FTitle);
    end;
    LineToStream( Line );
    LineToStream( '' );

    // print contents of all cells

    for LineIndex := 0 to TColData(FColumns.Items[0]).FCells.Count -1 do begin

        // print across a row
        // ...col 0 does not start with a ',' delimiter
        ColData := TColData(FColumns.Items[0] );
        Line := DeComma(ColData.FCells[LineIndex]);

        // ...col 1 onward start with a ',' delimiter
        for ColIndex := 1 to FColumns.Count -1 do begin

            // get ref to a column
            ColData := TColData(FColumns.Items[ColIndex] );

            // print cell text
            Line := Line + ',' + DeComma(ColData.FCells[LineIndex]);
        end;

        LineToStream( Line );
    end;
end;

procedure TPrintDBGrid.OutputToHTML;

var ColIndex : integer;
    ColData : TColData;
    LineIndex : integer;
    Line : string;
    CellText : string;

begin

    LineToStream( '<P>' );
    LineToStream( '<TABLE BORDER>' );

    // table caption
    if FCaption <> '' then begin
        LineToStream( '<CAPTION>' );
        LineToStream( FCaption );
        LineToStream( '</CAPTION>' );
    end;
    
    // column headings
    LineToStream( '<TR>' );

    for ColIndex := 0 to FColumns.Count -1 do begin

        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );

            LineToStream(
{                '<TH> <SAMP>' +}
                '<TH>' +
                ColData.FTitle +
//                '</SAMP></TH>' );}
                '</TH>' );

//      can improve by adding ColData.FTitleAlignment into cell alignment
    end;
    LineToStream( '</TR>' );

    // print column contents
    for LineIndex := 0 to TColData(FColumns.Items[0]).FCells.Count -1 do begin

        // print across a row
        LineToStream( '<TR>' );
        for ColIndex := 0 to FColumns.Count -1 do begin

            // get ref to a column
            ColData := TColData(FColumns.Items[ColIndex] );

            // alignment tag
            case ColData.FAlignment of
                taLeftJustify :
                    Line := '<TD ALIGN="LEFT">';
                taRightJustify :
                    Line := '<TD ALIGN="RIGHT">';
                else
                    Line := '<TD ALIGN="CENTER">';
            end;

            // cell text
            CellText := Trim(ColData.FCells[LineIndex]);
            if CellText = '' then begin
                CellText := ' &nbsp ';
            end;
            Line := Line + '<SAMP>' + CellText + '</SAMP></TD>';
            LineToStream( Line );
        end;
        LineToStream( '</TR>' );
    end;
    LineToStream( '</TABLE>' );
    LineToStream( '</P>' );
end;

procedure TPrintDBGrid.OutputToRtf;

var
    ColIndex : integer;
    ColData : TColData;
    Cellx : integer;
    PixelsPerInch : integer;
    text : string;
    LineIndex : integer;
begin
    // blank line, then caption, then blank line
    if FCaption <> '' then begin
        LineToStream( Format(
            '\pard\plain\%s\par', [RtfFormat(txDBGridCaption)] ));
        LineToStream( Format( '%s\par', [ FCaption] ) );
        LineToStream( Format(
            '\pard\plain\%s\par ', [RtfFormat(txDBGrid)] )  );
    end;

    // print cell dimensions for column headings
    // for example   \cellx1440\cellx2880\cellx4320
    PixelsPerInch := Screen.PixelsPerInch;
//    text := '';
//    text := '\trowd\trqc';
    text := '\trowd';
    Cellx := 0; // right hand pos of cell in twips (1/1440 inch)
    for ColIndex := 0 to FColumns.Count -1 do begin
        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );
        // calc RHS of current cell
        Inc( Cellx, ( 1440 * ColData.FGridWidth ) div PixelsPerInch );
        text := text + '\cellx' + IntToStr( Cellx );
    end;
    LineToStream( text );


    // print column headings
    LineToStream( Format( '\pard\plain\%s\intbl', [RtfFormat(txDBGrid)] )  );
//    LineToStream( Format( '\pard\plain\%s\', [RtfFormat(txDBGrid)] )  );
    for ColIndex := 0 to FColumns.Count -1 do begin
        // get ref to a column
        ColData := TColData(FColumns.Items[ColIndex] );
        // get print using cell text, width, alignment
        text := ColData.FTitle;
        if text = '' then begin
            text := '\~';
        end;
        LineToStream( text + '\cell' );
//        LineToStream( '\intabl ' + text + '\cell' );
    end;
    LineToStream( '\row' );

    // print column contents
    for LineIndex := 0 to TColData(FColumns.Items[0]).FCells.Count -1 do begin

        // print across a row
        LineToStream( Format( '\pard\plain\%s\intbl', [RtfFormat(txDBGrid)] )  );
//        LineToStream( '\intbl' );
        for ColIndex := 0 to FColumns.Count -1 do begin

            // get ref to a column
            ColData := TColData(FColumns.Items[ColIndex] );

            // get print using cell text, width, alignment
            text := ColData.FCells[LineIndex];
            if text = '' then begin
                text := '.';
            end;
{            if ColIndex = FColumns.Count -1 then begin
                LineToStream( text + '\cell \row' );
            end
            else begin
                LineToStream( text + '\cell' );
            end
}
           LineToStream( text + '\cell' );
        end;
        LineToStream( '\row' );
    end;
end;
{$IFDEF 0}
(*
\trql
Left-justifies a table row with respect to its containing column.
\trqr
Right-justifies a table row with respect to its containing column.
\trqc
Centers a table row with respect to its containing column.
\trhdr
Table row header. This row should appear at the top of every page the current table appears on.
\trkeep
Table row keep together. This row cannot be split by a page break. This property is assumed to be off unless the control word is present.

\cellx2890
Specifies the position of the cell’s right edge, in twips. The position
is relative to the left edge of the Help window. It is not affected by
the current indents.  Applies until the next \trowd statement.
*)
(*
The following example creates a two-column table. The second column contains
three separate paragraphs, each having different paragraph properties:
\cellx2880\cellx5760\intblAlignment\cell\qlLeft-aligned\par\qcCentered\par\qrRight-aligned\cell\row \pard
\cellx, \intbl, \row, \trgaph, \trleft, \trowd
*)

(*
The following example creates a three-column table having two rows:
\cellx1440\cellx2880\cellx4320
\intblRow 1 Column 1\cellRow 1 Column 2\cellRow 1 Column 3\cell \row\intblRow 2 Column 1\cellRow 2 Column 2\cellRow 2 Column 3\cell \row \pard
*)
{$ENDIF}

// *******************************************
// ****  TReportPrint CONSTRUCT, DESTROY *****
// *******************************************


constructor TPrintEngine.Create;
begin
    Items := TList.Create;
    FHeader := TStringList.Create;
    FHeader2 := TStringList.Create;
    FHeader3 := TStringList.Create;

    // create TFonts
    FHeaderFont         := TFont.Create;
    FHeader2Font        := TFont.Create;
    FHeader3Font        := TFont.Create;
    FHeading1Font       := TFont.Create;
    FHeading2Font       := TFont.Create;
    FTextFont           := TFont.Create;
    FWrappedTextFont    := TFont.Create;
    FStringsFont        := TFont.Create;
    FDBGridCaptionFont  := TFont.Create;
    FDBGridFont         := TFont.Create;

    // initialise TFonts
	FHeaderFont.Color	:= clBlack;
	FHeaderFont.Size	:= 10;
	FHeaderFont.Name	:= 'Arial';
{	FHeaderFont.Pitch	:= fpDefault; }
	FHeaderFont.Style	:= [];

    FHeader2Font.Assign( FHeaderFont );
    FHeader3Font.Assign( FHeaderFont );
    FHeading1Font.Assign( FHeaderFont );
    FHeading2Font.Assign( FHeaderFont );
    FTextFont.Assign( FHeaderFont );
    FWrappedTextFont.Assign( FHeaderFont );
    FStringsFont.Assign( FHeaderFont );
    FDBGridCaptionFont.Assign( FHeaderFont );
    FDBGridFont.Assign( FHeaderFont );

    { layout defaults }
    FLinePitch := 100;
    FLeftMargin := 3;
    FTopMargin := 2;
    FTiled := True;
    FSubBlockLines := 5;

    FFromPage := 1;
    FToPage := 999;
end;


destructor TPrintEngine.Destroy;
begin
    Clear;

    Items.Free;
    FHeader.Free;
    FHeader2.Free;
    FHeader3.Free;

    FHeaderFont.Free;
    FHeader2Font.Free;
    FHeader3Font.Free;
    FHeading1Font.Free;
    FHeading2Font.Free;
    FTextFont.Free;
    FWrappedTextFont.Free;
    FStringsFont.Free;
    FDBGridCaptionFont.Free;
    FDBGridFont.Free;

    inherited;
end;

procedure TPrintEngine.Clear;
var i : integer;
begin
    FHeader.Clear;
    FHeader2.Clear;
    FHeader3.Clear;
    for i := Items.Count -1 downto 0 do begin
        TObject(Items.Items[i]).Free;
    end;
    Items.Clear;

    FFromPage := 1;
    FToPage := 999;
end;


procedure TPrintEngine.ProvideStream;
begin
    if (FDestFileName <> '') then begin
        FDestStream := TFileStream.Create( FDestFileName, fmCreate );
    end;
end;

procedure TPrintEngine.ReleaseStream;
begin
    if FDestFileName <> '' then begin
        FDestStream.Free;
        FDestStream := nil;
    end;
end;

procedure TPrintEngine.PrepareForOutput;
begin
    FPrintNow := Now;
    // ensure at least one header - even if it is blank
    if FHeader.Count < 1 then begin
        FHeader.Add('');
    end;
    FFirstHeader := FHeader[0] + ' - ' + DateTimeToStr(FPrintNow);
end;


procedure TPrintEngine.LineToStream( const Text : string );
const EOL : array[0..1] of char = #13#10;
begin
    FDestStream.WriteBuffer( (pChar(Text))^, length(Text) );
    FDestStream.WriteBuffer( EOL, 2 );
end;

// ************************************************
// ****  PROCS ACCEPT PRINT DATA AND STORE IT *****
// ************************************************

procedure TPrintEngine.PrintHeader( const Text : string );
begin
    if Text <> '' then begin
        FHeader.Add( Text );
    end;
end;

procedure TPrintEngine.PrintHeader2( const Text : string );
begin
    if Text <> '' then begin
        FHeader2.Add( Text );
    end;
end;

procedure TPrintEngine.PrintHeader3( const Text : string );
begin
    if Text <> '' then begin
        FHeader3.Add( Text );
    end;
end;

procedure TPrintEngine.PrintHeading1( const Text : string );
var Heading1 : TPrintHeading1;
begin
    Heading1 := TPrintHeading1.Create(self);
    Heading1.Load( Text );
    Items.Add( Heading1 );
end;

procedure TPrintEngine.PrintHeading2( const Text : string );
var Heading2 : TPrintHeading2;
begin
    Heading2 := TPrintHeading2.Create(self);
    Heading2.Load( Text );
    Items.Add( Heading2 );
end;

procedure TPrintEngine.PrintText( const Text : string );
var PrintText : TPrintText;
begin
    PrintText := TPrintText.Create(self);
    PrintText.Load( Text );
    Items.Add( PrintText );
end;

procedure TPrintEngine.PrintWrappedText( const Text : string );
var WrappedText : TPrintWrappedText;
begin
    WrappedText := TPrintWrappedText.Create(self);
    WrappedText.Load( Text );
    Items.Add( WrappedText );
end;

procedure TPrintEngine.PrintStrings( strings : TStrings );
var PrintStrings : TPrintStrings;
begin
    PrintStrings := TPrintStrings.Create(self);
    PrintStrings.Load( strings );
    Items.Add( PrintStrings );
end;


procedure TPrintEngine.PrintDBGrid( DBGrid : TDBGrid; const Caption : string );
var PrintDBGrid : TPrintDBGrid;
begin
    // create a TPrintDBGrid and add it to the list of items to print
    PrintDBGrid := TPrintDBGrid.Create( self );
    PrintDBGrid.Load( DBGrid, Caption );
    Items.Add( PrintDBGrid );
end;


procedure TPrintEngine.PrintDBGridBlock(
    DBGrid : TDBGrid; const Caption : string; KeyField : TField );
var PrintDBGrid : TPrintDBGrid;
begin
    // create a TPrintDBGrid and add it to the list of items to print
    PrintDBGrid := TPrintDBGrid.Create( self );
    PrintDBGrid.LoadBlock( DBGrid, Caption, KeyField );
    Items.Add( PrintDBGrid );
end;

// *******************************************
// ****  TPrintEngine PAPER PRINT PROCS  *****
// *******************************************


{ ****** PRINT FUNCTIONS DO NOTHING IF CURRENT PAGE IS OUTSIDE
    RANGE OF WANTED PAGES ***** }

{ show if current page is in range FromPage to ToPage }

function TPrintEngine.PageWanted : boolean;
begin
    result := ((FPageNumber >= FFromPage) and (FPageNumber <= FToPage));
end;

procedure TPrintEngine.CheckPaper;
begin
    if FMediaClean then begin
        FMediaClean := False;
        FMediaPageNumber := FPageNumber;
        FMediaColumn := FColumn;
    end
    else if FMediaComplete then begin
        Printer.NewPage;
        FMediaComplete := False;
        FMediaPageNumber := FPageNumber;
        FMediaColumn := FColumn;
    end;
end;

// ** Setup ready for writing to a new page **

(* This "page" may never be written on and the TPrinter may never get to
hear about it
*)

procedure TPrintEngine.NewPage;

var StringIndex : integer;
    PageString : string;
    SheetLetter : char;
    PageStringWidth : integer;

begin
    // if an actual page has just completed, add its header lines and
    // mark it "ready to go out" = FMediaComplete
    if (not FMediaClean) and (not FMediaComplete) then begin

        // print header line(s) using direct Printer.Canvas.TextOut
        FCanvas.Font := FHeaderFont;
        Y := TopPrintableY;
        FCanvas.TextOut( LeftPrintableX, Y, FFirstHeader );
        Inc( Y, FHeaderDY );        // to next line
        for StringIndex := 1 to FHeader.Count -1 do begin
            FCanvas.TextOut( LeftPrintableX, Y, FHeader[StringIndex] );
            Inc( Y, FHeaderDY );    // to next line
        end;

        // print additional header lines
        if FHeader2.Count > 0 then begin
            FCanvas.Font := FHeader2Font;
            Inc( Y, FHeader2DY );    // blank line
            for StringIndex := 0 to FHeader2.Count -1 do begin
                FCanvas.TextOut( LeftPrintableX, Y, FHeader2[StringIndex] );
                Inc( Y, FHeader2DY );   // to next line
            end;
        end;

        // print additional header lines
        if FHeader3.Count > 0 then begin
            FCanvas.Font := FHeader3Font;
            Inc( Y, FHeader3DY );       // blank line
            for StringIndex := 0 to FHeader3.Count -1 do begin
                FCanvas.TextOut( LeftPrintableX, Y, FHeader3[StringIndex] );
                Inc( Y, FHeader3DY );   // to next line
            end;
        end;

        // add page number to top right of page
        if FMediaColumn > 0 then begin
            SheetLetter := char(integer('A') + FMediaColumn)
        end
        else begin
            SheetLetter := ' ';
        end;
        PageString := '  Page ' + IntToStr(FMediaPageNumber) + SheetLetter;
        PageStringWidth := FCanvas.TextWidth( PageString );
        FCanvas.TextOut(
            RightPrintableX - PageStringWidth, TopPrintableY, PageString );

        // record that a finished sheet is in TPrinter
        FMediaComplete := True;
    end;

    // setup state machine stuff ready to write to page
    Y := TopPrintableY + FHeaderDY * FHeader.Count;
    if FHeader2.Count > 0 then begin
         // header lines plus blank line
        Inc( Y, FHeader2DY * (FHeader2.Count + 1) );
    end;
    if FHeader3.Count > 0 then begin
        Inc( Y, FHeader3DY * (FHeader3.Count + 1) );
    end;
    Inc( FPageNumber );
end;


procedure TPrintEngine.CanvasTextOut( x, y : integer; const text : string );
begin
    if FInvisible or not PageWanted then begin
        exit;
    end;
    CheckPaper;
    Printer.Canvas.TextOut( x, y, text );
    FColumnUsed := True;
end;

procedure TPrintEngine.CanvasTextRect(Rect: TRect; X, Y: Integer; const Text: string);
begin
    if FInvisible or not PageWanted then begin
        exit;
    end;
    CheckPaper;
    Printer.Canvas.TextRect( Rect, x, y, text );
    FColumnUsed := True;
end;

{ ** print line of justified text at current Y between
        ColumnLeft, ColumnRight with Justification = alignment ** }

procedure TPrintEngine.CanvasTextJustified( ColumnLeft, ColumnRight : integer;
                Text : string; Alignment : TAlignment) ;

var
    X : integer;

begin
    // stop "possible uninitialized variable" warning
    X := ColumnLeft;

    { find out X = where to write string }
    case Alignment of
//       taLeftJustify : begin
//          X := ColumnLeft
//      end;
        taCenter : begin
            X := ColumnLeft +
                (ColumnRight - ColumnLeft - FCanvas.TextWidth(Text)) div 2;
            // ensure leftmost char is visible
            if X < ColumnLeft then begin
                X := ColumnLeft;
            end;
        end;
        taRightJustify : begin
            X := ColumnRight - FCanvas.TextWidth( Text );
        end;
    end;

    { write text to canvas }
    canvasTextRect(
        Rect( ColumnLeft, Y, ColumnRight, Y + FCanvas.TextHeight('A') ),
        X, Y, Text );
end;


// *****************************************************************
// ****  REPORT HANDED OVER FOR PRINTING, PREVIEW *****
// *****************************************************************

procedure TPrintEngine.OutputToPrinter;

var ItemIndex : integer;
    Item : TPrintItem;
    MeasureFont : TFont;
begin
    PrepareForOutput;

    // ** start printer object

    Printer.Orientation := FOrientation;
    Printer.Title := FHeader[0];
    FPrintNow := Now;
    Printer.BeginDoc;
    FMediaClean := True;
    FMediaComplete := False;
    FInvisible := False;
    FFirstBlockPrinted := False;    // kludge - will remove
    try

        FCanvas := Printer.Canvas;

        // ** Calculate Layout

        FCanvas.Font := FHeaderFont;
        FHeaderDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FHeader2Font;
        FHeader2DY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FHeader3Font;
        FHeader3DY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FHeading1Font;
        FHeading1DY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FHeading2Font;
        FHeading2DY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FTextFont;
        FTextDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FWrappedTextFont;
        FWrappedTextDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FStringsFont;
        FStringsDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FDBGridCaptionFont;
        FDBGridCaptionDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        FCanvas.Font := FDBGridFont;
        FDBGridDY := ( FCanvas.TextHeight('A') * LinePitch ) div 100;

        // calculate margins using a 10 point Arial font
        MeasureFont := TFont.Create;
        try
            MeasureFont.Name := 'Arial';
            MeasureFont.Size := 10;

            FCanvas.Font := MeasureFont;
            LeftPrintableX := FLeftMargin * FCanvas.TextWidth('A');
            TopPrintableY := FTopMargin * FCanvas.TextHeight('A');
        finally
            MeasureFont.Free;
        end;

        RightPrintableX := Printer.PageWidth;
        BottomPrintableY := Printer.PageHeight;


        // Initialise all printer code
        for ItemIndex := 0 to Items.Count -1 do begin
             // tell print item to output to paper
            Item := TPrintItem(Items[ItemIndex]);
            Item.SetupForPrinter;
        end;

        // print each column of paper until no paper used
        FColumn := -1;

        repeat

            FColumnUsed := False;

            // position just below Header lines
            FPageNumber := 0;
            NewPage;    // moves to page 1

            Inc( FColumn );

            // print each item ( eg text, grid, heading etc ) down the paper column
            for ItemIndex := 0 to Items.Count -1 do begin

                // tell print item to output to paper
                Item := TPrintItem(Items[ItemIndex]);
                Item.OutputToPrinter;
            end;

        until ( (not FColumnUsed) or (not FTiled) );

        NewPage;    // finish writing to existing page

    finally
        Printer.EndDoc; // send out existing page  & finish print job
    end;

end;


procedure TPrintEngine.OutputToText;

var ItemIndex : integer;
    StringIndex : integer;

begin
    PrepareForOutput;
    ProvideStream;
    try

        // print header line(s)
        LineToStream( FFirstHeader );
        for StringIndex := 1 to FHeader.Count -1 do begin
            LineToStream( FHeader[StringIndex] );
        end;

        if FHeader2.Count > 0 then begin
            LineToStream( '' );
            for StringIndex := 0 to FHeader2.Count -1 do begin
                LineToStream( FHeader2[StringIndex] );
            end;
        end;

        if FHeader3.Count > 0 then begin
            LineToStream( '' );
            for StringIndex := 0 to FHeader3.Count -1 do begin
                LineToStream( FHeader3[StringIndex] );
            end;
        end;
        
        // print each item in list
        for ItemIndex := 0 to Items.Count -1 do begin
            TPrintItem(Items[ItemIndex]).OutputToText;
        end;

    finally
        ReleaseStream;
    end;
end;


procedure TPrintEngine.OutputToCSV;

var ItemIndex : integer;
    StringIndex : integer;

begin
    PrepareForOutput;
    ProvideStream;
    try

        // print header line(s)
        LineToStream( FFirstHeader );
        for StringIndex := 1 to FHeader.Count -1 do begin
            LineToStream( FHeader[StringIndex] );
        end;

        if FHeader2.Count > 0 then begin
            LineToStream( '' );
            for StringIndex := 0 to FHeader2.Count -1 do begin
                LineToStream( FHeader2[StringIndex] );
            end;
        end;

        if FHeader3.Count > 0 then begin
            LineToStream( '' );
            for StringIndex := 0 to FHeader3.Count -1 do begin
                LineToStream( FHeader3[StringIndex] );
            end;
        end;

        // print each item in list
        for ItemIndex := 0 to Items.Count -1 do begin
            TPrintItem(Items[ItemIndex]).OutputToCSV;
        end;
        Inc( FColumn );

    finally
        ReleaseStream;
    end;
end;

procedure TPrintEngine.OutputToHTML;

var ItemIndex : integer;
    StringIndex : integer;

begin
    PrepareForOutput;
    ProvideStream;
    try
        LineToStream( '<HTML>' );
        LineToStream( '<HEAD>' );
        LineToStream( '<TITLE>' + FFirstHeader + '</TITLE>' );
        LineToStream( '</HEAD>' );

        LineToStream( '<BODY>' );

        // print header line(s)
        LineToStream( '<P>' );
        LineToStream( FFirstHeader + '<BR>' );
        for StringIndex := 1 to FHeader.Count -1 do begin
            LineToStream( FHeader[StringIndex] + '<BR>' );
        end;
        LineToStream( '</P>' );

        if FHeader2.Count > 0 then begin
            LineToStream( '<P>' );
            for StringIndex := 0 to FHeader2.Count -1 do begin
                LineToStream( FHeader2[StringIndex] + '<BR>' );
            end;
            LineToStream( '</P>' );
        end;

        if FHeader3.Count > 0 then begin
            LineToStream( '<P>' );
            for StringIndex := 0 to FHeader3.Count -1 do begin
                LineToStream( FHeader3[StringIndex] + '<BR>' );
            end;
            LineToStream( '</P>' );
        end;

        // print date
        LineToStream( '<P>' );
        LineToStream( 'Printed on : ' + DateTimeToStr(FPrintNow)  );
        LineToStream( '</P>' );

        // print each item in list
        for ItemIndex := 0 to Items.Count -1 do begin
            TPrintItem(Items[ItemIndex]).OutputToHTML;
        end;

        // finish document
        LineToStream( '</BODY>' );
        LineToStream( '</HTML>' );

    finally
        ReleaseStream;
    end;
end;

procedure TPrintEngine.OutputToRtf;

    const StyleNames : array[TPrintItemType] of string = (
    'txNone',
    'txHeader',
    'txHeader2',
    'txHeader3',
    'txHeading1',
    'txHeading2',
    'txText',
    'txWrappedText',
    'txStrings',
    'txDBGridCaption',
    'txDBGrid'
    );

    procedure DefineFont( Num : TPrintItemType; Font : TFont );
    begin
        LineToStream( Format( '{\f%d\fnil\fcharset%d %s;}',
        [Ord(Num), integer(Font.Charset),Font.Name])  );
    end;

    procedure DefineStyle( Num : TPrintItemType; Font : TFont );
    begin
        // style numb, font, font size
        // s1 -> style 1
        // f2 -> font number 2
        // fs20 -> font size 10 point
        LineToStream( Format( '{\s%d\f%d\fs%d %s;}',
        [Ord(Num), Ord(Num), Font.Size * 2, StyleNames[Num]])  );
    end;


var
    ItemIndex : integer;
    StringIndex : integer;
//    text : string;
    RItem : TPrintItem;
begin
    PrepareForOutput;
    ProvideStream;
    try
        // begin a RTF document
        LineToStream( '{\rtf1\ansi' );

        // font tables section
        LineToStream( '{\fonttbl' );

        DefineFont( txHeader,       FHeaderFont );
        DefineFont( txHeader2,      FHeader2Font );
        DefineFont( txHeader3,      FHeader3Font );
        DefineFont( txHeading1,     FHeading1Font );
        DefineFont( txHeading2,     FHeading1Font );
        DefineFont( txText,         FTextFont );
        DefineFont( txWrappedText,  FWrappedTextFont );
        DefineFont( txStrings,      FStringsFont );
        DefineFont( txDBGridCaption, FDBGridCaptionFont );
        DefineFont( txDBGrid,       FDBGridFont );
        LineToStream( '}' );

        // stylesheets section
        LineToStream( '{\stylesheet' );
        LineToStream( '{\s0\f1\fs24 default;}' );
        DefineStyle( txHeader,      FHeaderFont );
        DefineStyle( txHeader2,     FHeader2Font );
        DefineStyle( txHeader3,     FHeader3Font );
        DefineStyle( txHeading1,    FHeading1Font );
        DefineStyle( txHeading2,    FHeading1Font );
        DefineStyle( txText,        FTextFont );
        DefineStyle( txWrappedText, FWrappedTextFont );
        DefineStyle( txStrings,     FStringsFont );
        DefineStyle( txDBGridCaption, FDBGridCaptionFont );
        DefineStyle( txDBGrid,      FDBGridFont );
        LineToStream( '}' );


        // document formatting properties section (add here stuff like
        // margins


        // commence header
        LineToStream( '{\header' );

        // compulsory first header formatting
        LineToStream( Format(
            '\pard\plain\%s', [RtfFormat(txHeader)] ));

        // first header line 0
        LineToStream( FFirstHeader );

        // subsequent header lines
        for StringIndex := 1 to FHeader.Count -1 do begin
            LineToStream( Format(
                '\par %s', [FHeader[StringIndex]] ) );
        end;

        // header 2 lines
        if FHeader2.Count > 0 then begin
        LineToStream( Format(
            '\par\pard\plain\%s', [RtfFormat(txHeader2)] ));
            for StringIndex := 0 to FHeader2.Count -1 do begin
                LineToStream( Format(
                    '\par %s', [FHeader2[StringIndex]] ) );
            end;
        end;

        // header 3 lines
        if FHeader3.Count > 0 then begin
        LineToStream( Format(
            '\par\pard\plain\%s', [RtfFormat(txHeader3)] ));
            for StringIndex := 0 to FHeader3.Count -1 do begin
                LineToStream( Format(
                    '\par %s', [FHeader3[StringIndex]] ) );
            end;
        end;

        // finish header
        LineToStream( '}' );

        // print each item in list
        for ItemIndex := 0 to Items.Count -1 do begin
            RItem := TPrintItem(Items[ItemIndex]);
            RItem.OutputToRtf;
        end;

        // conclude document
        LineToStream( '}' );


    finally
        ReleaseStream;
    end;
end;






(*
WHERE TO STORE PRINT SETTINGS ?

- In database ? Reports match the club style.  Tiling will adjust for paper width.
- In INI file ? Reports match needs of user and local printer.  Work across
    databases without needing to be setup every time a new database is started.
- Storing print settings may not be done here.
- Another method is to load, save settings from a stream.  The stream can
come from a BLOB or an INI file ??
*)



(*
see DataPrn.pas for TY4 print code

    property BodyLinePitch : integer  read FBodyLinePitch write FBodyLinePitch;
    property LeftMargin : integer  read FLeftMargin write FLeftMargin;
    property Orientation : TPrinterOrientation
        read FOrientation write FOrientation;

    property Tiled : boolean read FTiled write FTiled;
    property PagedBlocks : boolean             { page sections }
        read FPagedBlocks write FPagedBlocks;

    property SubBlockLines : integer read FSubBlockLines write FSubBlockLines;

    property FromPage : integer read FFromPage write FFromPage;
    property ToPage : integer read FToPage write FToPage;

	property HeaderFont	: TFont read FHeaderFont write FHeaderFont;
	property Title1Font	: TFont read FTitle1Font write FTitle1Font;
    property Title2Font : TFont read FTitle2Font write FTitle2Font;
    property BlockTitleFont : TFont read FBlockTitleFont write FBlockTitleFont;
	property BodyFont	: TFont read FBodyFont write FBodyFont;
*)

(*
Printing To Paper with Multiple PaperColumns
=============================================

Do one "column" of paper at a time.
Count paper columns with the variable >PaperColumnIndex< which starts at col 0.

Work down a column from top to bottom by calling each TPrintItem in turn.
Each TPrintItem must set its FPaperColumnUsed member to true if it actually
writes on the page.



Paper management -
----------------

Each TPrintItems calls >NewPage< whenever it has reached the bottom of a page.

NewPage increments the PageNumber property.

A TPrintIntem can set the Invisible property so that calls to CanvasTextOut()
and CanvasTextRect() do not actually write on the paper.

When starting printing, we always call Printer.BeginDoc so that the selected
printer characteristics make it to the Printer.Canvas properties.

The following variables track paper

FPageNumber         // page we are up to - whether or not we put ink on it
FColumn             // column we are up to - whether or not we put ink on it
FInvisible          // ignore calls to CanvasTextOut() and CanvasTextRect()
FFromPage, FToPage  // selection of pages wanted by user
FMediaClean         // if current paper not actually written on
FMediaComplete      // if current paper written on and belongs to an earlier page number
FMediaPageNumber    // page number of piece of paper actually current in TPrinter
FMediaColumn        // col number of piece of paper actually current in TPRinter
Y                   // position down the current page


Initialising
------------
FPageNumber := 1;
FMediaClean := True;
FMediaComplete := False;
Printer.BeginDoc;


Line Spacing Policy
-------------------

Before any new section we insert a blank line of the text height
identical to the text height of the first line of the new section.

Each section must leave the variable X set to the position below
the last written line in the section.

*)
end.

