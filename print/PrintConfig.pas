unit PrintConfig;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, ComCtrls, Printers, ExtCtrls;

type
  TPrintConfigForm = class(TForm)
    OKTButton: TButton;
    Button8: TButton;
    TextTGroupBox: TGroupBox;
    FontTComboBox: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    ItemTComboBox: TComboBox;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    PagedTCheckBox: TCheckBox;
    Label4: TLabel;
    Label7: TLabel;
    GroupBox3: TGroupBox;
    LandscapeTRadioButton: TRadioButton;
    PortraitTRadioButton: TRadioButton;
    TiledTCheckBox: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    MarginTUpDown: TUpDown;
    PitchTUpDown: TUpDown;
    SubBlockTUpDown: TUpDown;
    PitchTEdit: TEdit;
    MarginTEdit: TEdit;
    SubBlockTEdit: TEdit;
    SizeTEdit: TEdit;
    SizeTUpDown: TUpDown;
    TopMarginTEdit: TEdit;
    TopMarginTUpDown: TUpDown;
    Label8: TLabel;
    BoldTCheckBox: TCheckBox;
    UnderlineTCheckBox: TCheckBox;
    ItalicTCheckbox: TCheckBox;
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ItemTComboBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FontTComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PitchTEditChange(Sender: TObject);
    procedure MarginTEditChange(Sender: TObject);
    procedure SubBlockTEditChange(Sender: TObject);
    procedure SizeTEditChange(Sender: TObject);
    procedure TopMarginTEditChange(Sender: TObject);
    procedure BoldTCheckBoxClick(Sender: TObject);
    procedure UnderlineTCheckBoxClick(Sender: TObject);
    procedure ItalicTCheckboxClick(Sender: TObject);

  private
    { Private declarations }

    CurrentFont : TFont;
    DisplayGrid : Boolean;

    LeftMarginUnit : integer;
    TopMarginUnit : integer;
    procedure SwitchToGrid;

  public
    PagedBlocks : boolean;
    Tiled : boolean;
    Orientation : TPrinterOrientation;
    SubBlockLines : integer;

    LinePitch : integer;
    LeftMargin : integer;
    TopMargin : integer;

    HeaderFont   : TFont;
    Header2Font  : TFont;
    Header3Font  : TFont;
    Heading1Font : TFont;
    Heading2Font : TFont;

    DBGridCaptionFont : TFont;
    DBGridFont : TFont;

    TextFont        : TFont;
    WrappedTextFont : TFont;
    StringsFont     : TFont;

  end;

var
  PrintConfigForm: TPrintConfigForm;

implementation

{$R *.DFM}
//uses Printers;

{ *** CONSTRUCT FORM COMPONENTS *** }

procedure TPrintConfigForm.FormCreate(Sender: TObject);
var MeasureFont : TFont;
begin
    HeaderFont     := TFont.Create;
    Header2Font    := TFont.Create;
    Header3Font    := TFont.Create;
    Heading1Font   := TFont.Create;
    Heading2Font   := TFont.Create;
    DBGridCaptionFont := TFont.Create;
    DBGridFont     := TFont.Create;

    TextFont        := TFont.Create;
    WrappedTextFont := TFont.Create;
    StringsFont     := TFont.Create;

    ItemTComboBox.Items.Clear;
    ItemTComboBox.Items.Add( 'Header' );
    ItemTComboBox.Items.Add( 'Header2' );
    ItemTComboBox.Items.Add( 'Header3' );

    ItemTComboBox.Items.Add( 'Heading 1' );
    ItemTComboBox.Items.Add( 'Heading 2' );

    ItemTComboBox.Items.Add( 'Table Caption' );
    ItemTComboBox.Items.Add( 'Table Body' );

    ItemTComboBox.Items.Add( 'Text' );
    ItemTComboBox.Items.Add( 'Wrapped Text' );
    ItemTComboBox.Items.Add( 'Lines' );


    // calculate margins using a 10 point Arial font
    MeasureFont := TFont.Create;
    try
        MeasureFont.Name := 'Arial';
        MeasureFont.Size := 10;

        Canvas.Font := MeasureFont;
        LeftMarginUnit := Canvas.TextWidth('A');
        TopMarginUnit := Canvas.TextHeight('A');
    finally
        MeasureFont.Free;
    end;

end;

{ *** DESTROY FORM COMPONENTS *** }

procedure TPrintConfigForm.FormDestroy(Sender: TObject);
begin
    HeaderFont.Free;
    Heading1Font.Free;
    Heading2Font.Free;
    DBGridCaptionFont.Free;
    DBGridFont.Free;
    TextFont.Free;
    WrappedTextFont.Free;
    StringsFont.Free;
end;

procedure TPrintConfigForm.SwitchToGrid;
begin
    if not DisplayGrid then begin
        DisplayGrid := True;
        ItemTComboBox.ItemIndex := 6;   // to body font
    end;
    Refresh;
end;


{ *** DRAW REPLICA PRINTOUT DIRECTLY ON FORM *** }

procedure TPrintConfigForm.FormPaint(Sender: TObject);

const
    Gap = 5;

var X,
    Y,
    XLeftPage,
    BodyY : integer;
    Line : integer;

begin

    // left margin
    Canvas.font := DBGridFont;
    XLeftPage := TextTGroupBox.Left + TextTGroupBox.Width + Gap;
    X := XLeftPage + LeftMargin * LeftMarginUnit;

    // top margin - display as 1/2 actual margin, to keep stuff on screen
    Y := Gap + TopMargin * TopMarginUnit div 2;

    // inter-line spacing
    BodyY := ( Canvas.TextHeight('A') * LinePitch) div 100;

    // Header
    Canvas.font := HeaderFont;
    Canvas.TextOut( X, Y, 'header : date, page #' );
    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

    // Header 2
    Canvas.font := Header2Font;
    Canvas.TextOut( X, Y, 'header 2' );
    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

    // Header 3
    Canvas.font := Header3Font;
    Canvas.TextOut( X, Y, 'header 3' );
    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

    // Heading 1
    Canvas.font := Heading1Font;
    Inc( Y, Canvas.TextHeight('A') );   // blank line
    Canvas.TextOut( X, Y, 'HEADING 1' );
    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

    // Heading 2
    Canvas.font := Heading2Font;
    Inc( Y, Canvas.TextHeight('A') );   // blank line
    Canvas.TextOut( X, Y, 'HEADING 2' );
    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

    // display Grid
    if DisplayGrid then begin

        // grid caption
        Canvas.font := DBGridCaptionFont;
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'Table Caption' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

        // grid body
        Canvas.font := DBGridFont;
        Inc( Y, BodyY );                    // blank line
        line := 1;
        while Y < OKTButton.Top do begin

            Canvas.TextOut( X, Y, 'Table Body : line ' + IntToStr( Line ) );
            Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

            { sub lines - leave a blank line every SubBlockLines }
            if SubBlockLines > 0 then begin
                if (Line Mod SubBlockLines) = 0 then begin
                    Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
                end;
            end;
            Inc( Line );
        end;
    end

    // display Text
    else begin

        // Text
        Canvas.font := TextFont;
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'text text text text text' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);


        // Wrapped Text

        Canvas.font := WrappedTextFont;
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'wrapped text  wrapped text  wrapped text' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'wrapped text  wrapped text  wrapped text' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'wrapped text  wrapped text  wrapped text' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);

        // Lines

        Canvas.font := StringsFont;
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'lines lines lines lines' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'lines lines lines lines' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
        Canvas.TextOut( X, Y, 'lines lines lines lines' );
        Inc( Y, (Canvas.TextHeight('A') * LinePitch) div 100);
    end;

    // left hand border
    Canvas.MoveTo( XLeftPage, Y );
    Canvas.LineTo( XLeftPage, Gap );

end;

{ *** CALLBACK PROC FOR FONT ENUMERATION *** }
// adds only TrueType fonts to list.
// This permits print preview with easy scaling via TrueType

function EnumFontFamProc(
    var EnumLogFont : TEnumLogFont;	        // logical-font data
    var NewTextMetric : TNewTextMetric;	    // physical-font data
    dwType : DWORD;	    // font type
    lpData : LPARAM 	// pointer to application-defined data
   ) : integer; stdcall;
begin
    if (dwType and TRUETYPE_FONTTYPE) <> 0 then begin
        TStrings(lpData).Add(EnumLogFont.elfLogFont.lfFaceName);
    end;
    Result := 1;
end;


{ *** INITIALISE FORM BEFORE SHOWING *** }
procedure TPrintConfigForm.FormShow(Sender: TObject);
begin

    { load Font ComboBox with system printer fonts }
//    FontTComboBox.Items := Printer.Fonts;

    { load Font ComboBox with TrueType fonts ONLY - facilitates PrintPreview
    if only TT fonts are used on printer and screen }
    FontTComboBox.Items.Clear;
    EnumFontFamilies(
        Canvas.Handle, nil, @EnumFontFamProc, LPARAM(FontTComboBox.Items) );

    { temp variables get copies of originals - can discard if user cancels }
    PitchTUpDown.Position := LinePitch;

    MarginTUpDown.Position := LeftMargin;
    TopMarginTUpDown.Position := TopMargin;

    LandscapeTRadioButton.Checked := Orientation = poLandscape;

    PagedTCheckbox.Checked := PagedBlocks;
    TiledTCheckbox.Checked := Tiled;

    SubBlockTUpDown.Position := SubBlockLines;

    { start BodyText item }
    ItemTComboBox.ItemIndex := 6;
    ItemTComboBoxChange( nil );

    { setup OnChange event handlers.  If we set these TEdit properties up
    with Object Inspector at Design Time, then we get an exception
    somewhere after the OnCreate method has finished. Probably TEdits
    are not finalised with Windows and can't sustain an "OnChange" event.
    Also TUpDown controls may cause TEdit on change too early }

    PitchTEdit.OnChange := PitchTEditChange;
    MarginTEdit.OnChange := MarginTEditChange;
    TopMarginTEdit.OnChange := TopMarginTEditChange;
    SubBlockTEdit.OnChange := SubBlockTEditChange;
    SizeTEdit.OnChange := SizeTEditChange;

end;

{ *** USER CHANGES PITCH OF TEXT *** }
procedure TPrintConfigForm.PitchTEditChange(Sender: TObject);
begin
    if PitchTEdit.Text <> '' then begin
        LinePitch := PitchTUpDown.Position;
        SwitchToGrid;
    end;
end;


{ *** USER CHANGES LEFT MARGIN *** }

procedure TPrintConfigForm.MarginTEditChange(Sender: TObject);
begin
    if MarginTEdit.Text <> '' then begin
        LeftMargin := MarginTUpDown.Position;
        Refresh;
    end;
end;


procedure TPrintConfigForm.TopMarginTEditChange(Sender: TObject);
begin
    if TopMarginTEdit.Text <> '' then begin
        TopMargin := TopMarginTUpDown.Position;
        Refresh;
    end;
end;



{ *** USER CHANGES SUB-BLOCK SIZE *** }

procedure TPrintConfigForm.SubBlockTEditChange(Sender: TObject);
begin
    if SubBlockTEdit.Text <> '' then begin
        SubBlockLines := SubBlockTUpDown.Position;
        SwitchToGrid;
    end;
end;


{ *** USER SELECTS ITEM FOR FONT CHANGES TO APPLY TO *** }

procedure TPrintConfigForm.ItemTComboBoxChange(Sender: TObject);
begin
    case ItemTComboBox.ItemIndex of
        0 : CurrentFont := HeaderFont;
        1 : CurrentFont := Header2Font;
        2 : CurrentFont := Header3Font;

        3 : CurrentFont := Heading1Font;
        4 : CurrentFont := Heading2Font;

        5 : begin
            CurrentFont := DBGridCaptionFont;
            DisplayGrid := True;
        end;

        6 : begin
            CurrentFont := DBGridFont;
            DisplayGrid := True;
        end;

        7 : begin
            CurrentFont := TextFont;
            DisplayGrid := False;
        end;

        8 : begin
            CurrentFont := WrappedTextFont;
            DisplayGrid := False;
        end;

        9 : begin
            CurrentFont := StringsFont;
            DisplayGrid := False;
        end;
    end;

    FontTComboBox.Text := CurrentFont.Name;
    SizeTUpDown.Position := CurrentFont.Size;

    BoldTCheckbox.Checked := fsBold in CurrentFont.Style;
    UnderlineTCheckbox.Checked := fsUnderline in CurrentFont.Style;
    ItalicTCheckbox.Checked := fsItalic in CurrentFont.Style;

    Refresh;
end;


{ ** USER CHANGES SIZE OF CURRENT TEXT ITEM ** }

procedure TPrintConfigForm.SizeTEditChange(Sender: TObject);
begin
    if SizeTEdit.Text <> '' then
        begin
        CurrentFont.Size := SizeTUpDown.Position;
        Refresh;
        end;
end;


{ *** USER CHANGES FONT OF CURRENT TEXT ITEM *** }

procedure TPrintConfigForm.FontTComboBoxChange(Sender: TObject);
begin
    CurrentFont.Name := FontTComboBox.Text;
    Refresh;
end;

{ *** USER CHANGES BOLD/UNDERLINE/ITALIC OF FONT OF CURRENT TEXT ITEM *** }

procedure TPrintConfigForm.BoldTCheckBoxClick(Sender: TObject);
begin
    if BoldTCheckbox.Checked then begin
        CurrentFont.Style := CurrentFont.Style + [fsBold];
    end
    else begin
        CurrentFont.Style := CurrentFont.Style - [fsBold];
    end;
    refresh;
end;


procedure TPrintConfigForm.UnderlineTCheckBoxClick(Sender: TObject);
begin
    if UnderlineTCheckbox.Checked then begin
        CurrentFont.Style := CurrentFont.Style + [fsUnderline];
    end
    else begin
        CurrentFont.Style := CurrentFont.Style - [fsUnderline];
    end;
    refresh;
end;

procedure TPrintConfigForm.ItalicTCheckboxClick(Sender: TObject);
begin
    if ItalicTCheckbox.Checked then begin
        CurrentFont.Style := CurrentFont.Style + [fsItalic];
    end
    else begin
        CurrentFont.Style := CurrentFont.Style - [fsItalic];
    end;
    refresh;
end;


{ *** FORM CLOSES AND USES / DISCARDS USER SETTINGS *** }

procedure TPrintConfigForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if LandscapeTRadioButton.Checked then begin
        Orientation := poLandscape
    end
    else begin
        Orientation := poPortrait;
    end;

    PagedBlocks := PagedTCheckbox.Checked;
    Tiled := TiledTCheckbox.Checked;
end;




end.

