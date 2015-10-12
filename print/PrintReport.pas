unit PrintReport;

interface

uses PrintEngine, PrintConfig, PrintMainDlg, Graphics, IniFiles;

type TPrintDestination =
    ( pcNone, pcPaper, pcCSV, pcTXT, pcHTML, pcRTF, pcInternet );

type  TReport = class( TPrintEngine )

  protected
    FIniFileName : string;
    FIniSection : string;
    IniFile : TIniFile;
    FDestination : TPrintDestination;
    function GetFileName( const Filter, DefaultExt : string ): boolean;
    procedure Layout;
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure WriteFontIni( const Key : string; Font : TFont );
    procedure ReadFontIni( const Key : string; Font : TFont );

  public
    property IniFileName : string read FIniFileName write FIniFileName;
    property IniSection : string read FIniSection write FIniSection;
    property Destination : TPrintDestination read FDestination write FDestination;

    procedure ExecuteMenu; virtual;
    procedure Output; virtual;
    procedure Execute;

end;


implementation

uses Controls, Dialogs, SysUtils, Printers;

function TReport.GetFileName( const Filter, DefaultExt : string ): boolean;
var OpenDialog : TSaveDialog;
begin
    { get file name from user }
    OpenDialog := TSaveDialog.Create(nil);
    TRY
        OpenDialog.Filter := Filter;
        OpenDialog.Options := [ofOverwritePrompt, ofHideReadOnly,
            ofPathMustExist, ofNoReadOnlyReturn] ;
        OpenDialog.DefaultExt := DefaultExt;

        if OpenDialog.Execute then begin
            DestFileName := OpenDialog.FileName;
            result := True;
        end
        else begin
            result := False;
        end;
    FINALLY
    OpenDialog.Free;
    END;
end;


procedure TReport.ExecuteMenu;

var ModalResult : integer;
    PrintDialog : TPrintDialog;
    PrintMainDialog : TPrintMainDialog;
begin
    // display PrintMainDialog & let user choose what to print
    PrintMainDialog := TPrintMainDialog.Create( nil );
    PrintMainDialog.PrinterTLabel.Caption :=
        Printer.Printers[Printer.PrinterIndex];
    try
        while True do begin

            PrintMainDialog.PrinterTLabel.Caption :=
                Printer.Printers[Printer.PrinterIndex];

            ModalResult := PrintMainDialog.ShowModal;

            // user clicks cancel
            if ModalResult = mrCancel then begin
                FDestination := pcNone;
                break;
            end;

            // if "Layout" button clicked
            if ModalResult = mrYes then begin
                // run layout form
                Layout;
            end

            // if "Setup" button clicked
            else if ModalResult = mrYesToAll then begin
                // run printer setup dialog
                PrintDialog := TPrintDialog.Create(nil);
                TRY
                    PrintDialog.Options := [ poWarning, poPageNums ];
                    PrintDialog.PrintRange := prAllPages;
                    PrintDialog.MinPage := 1;
                    PrintDialog.FromPage := FromPage;
                    PrintDialog.MaxPage := ToPage;
                    PrintDialog.ToPage := 999;

                    if PrintDialog.Execute then begin
                        FromPage := PrintDialog.FromPage;
                        ToPage := PrintDialog.ToPage;
                    end;
                FINALLY
                PrintDialog.Free;
                END;
            end

            // else "OK button clicked
            else if PrintMainDialog.WinTRadioButton.Checked then begin
                FDestination := pcPaper;
                break;
            end
            else if PrintMainDialog.CSVTRadioButton.Checked then begin
                if GetFileName( 'Comma Separated (*.CSV)|*.CSV|', 'CSV' ) then begin
                    FDestination := pcCSV;
                    break;
                end;
            end
            else if PrintMainDialog.HtmTRadioButton.Checked then begin
                if GetFileName( 'Hypertext files (*.HTM)|*.HTM|', 'HTM' ) then begin
                    FDestination := pcHTML;
                    break;
                end;
            end
            else if PrintMainDialog.TxtTRadioButton.Checked then begin
                if GetFileName( 'Text files (*.TXT)|*.TXT|', 'TXT' ) then begin
                    FDestination := pcTXT;
                end;
                    break;
            end
            else if PrintMainDialog.RtfTRadioButton.Checked then begin
                if GetFileName( 'Rich Text Format (*.RTF)|*.RTF|', 'RTF' ) then begin
                    FDestination := pcRTF;
                end;
                    break;
            end

        end;
    finally
        PrintMainDialog.Free;
    end;
end;



procedure TReport.Execute;
begin
    ExecuteMenu;
    Output;
end;

procedure TReport.Output;
begin
    case FDestination of
        pcNone : ;
        pcPaper : begin
            ReadIniFile;
            OutputToPrinter;
        end;
        pcCSV   : OutputToCSV;
        pcTXT   : OutputToText;
        pcHTML  : OutputToHTML;
        pcRTF   : begin
            ReadIniFile;
            OutputToRTF;
        end;
    end;
end;
//    ( pcNone, pcPaper, pcCSV, pcTXT, pcHTML, pcRTF, pcInternet );


procedure TReport.Layout;
var PrintConfigForm : TPrintConfigForm;
begin

    ReadIniFile;
    PrintConfigForm := TPrintConfigForm.Create(nil);
    try

        // load print config form with current settings
        PrintConfigForm.PagedBlocks := FPagedBlocks;
        PrintConfigForm.Tiled := FTiled;
        PrintConfigForm.Orientation := FOrientation;
        PrintConfigForm.SubBlockLines := FSubBlockLines;

        PrintConfigForm.LinePitch := FLinePitch;
        PrintConfigForm.LeftMargin := FLeftMargin;
        PrintConfigForm.TopMargin := FTopMargin;
        PrintConfigForm.HeaderFont.Assign( FHeaderFont );
        PrintConfigForm.Header2Font.Assign( FHeader2Font );
        PrintConfigForm.Header3Font.Assign( FHeader3Font );
        PrintConfigForm.Heading1Font.Assign( FHeading1Font );
        PrintConfigForm.Heading2Font.Assign( FHeading2Font );
        PrintConfigForm.TextFont.Assign( FTextFont  );
        PrintConfigForm.WrappedTextFont.Assign( FWrappedTextFont );
        PrintConfigForm.StringsFont.Assign( FStringsFont );
        PrintConfigForm.DBGridCaptionFont.Assign( FDBGridCaptionFont );
        PrintConfigForm.DBGridFont.Assign( FDBGridFont );

        if PrintConfigForm.ShowModal <> mrOK then begin
            exit;
        end;

        // current settings back from print config form
        FPagedBlocks := PrintConfigForm.PagedBlocks;
        FTiled := PrintConfigForm.Tiled;
        FOrientation := PrintConfigForm.Orientation;
        FSubBlockLines := PrintConfigForm.SubBlockLines;

        FLinePitch := PrintConfigForm.LinePitch;
        FLeftMargin := PrintConfigForm.LeftMargin;
        FTopMargin := PrintConfigForm.TopMargin;

        FHeaderFont.Assign( PrintConfigForm.HeaderFont );
        FHeader2Font.Assign( PrintConfigForm.Header2Font );
        FHeader3Font.Assign( PrintConfigForm.Header3Font );
        FHeading1Font.Assign( PrintConfigForm.Heading1Font );
        FHeading2Font.Assign( PrintConfigForm.Heading2Font );
       FTextFont.Assign( PrintConfigForm.TextFont );
       FWrappedTextFont.Assign( PrintConfigForm.WrappedTextFont );
       FStringsFont.Assign( PrintConfigForm.StringsFont );
        FDBGridCaptionFont.Assign( PrintConfigForm.DBGridCaptionFont );
        FDBGridFont.Assign( PrintConfigForm.DBGridFont );

    finally
        PrintConfigForm.Free;
    end;
    WriteIniFile;
end;

{ *** helper function writes fonts to IniFile ** }

procedure TReport.WriteFontIni( const Key : string; Font : TFont );
var IniString : string;
begin
    IniString := Font.Name + ',' + IntToStr( Font.Size ) + ',';
    if fsBold in Font.Style then begin
        IniString := IniString + 'B';
    end;
    if fsUnderline in Font.Style then begin
        IniString := IniString + 'U';
    end;
    if fsItalic in Font.Style then begin
        IniString := IniString + 'I';
    end;
    IniFile.WriteString( FIniSection, Key, IniString );
end;


{ *** WRITE CURRENT SETTINGS TO CONFIG FILE *** }

procedure TReport.WriteIniFile;
begin
    if (IniFileName = '') or (FIniSection = '') then begin
        exit;
    end;

    IniFile := TIniFile.Create( IniFileName );
    try
        WriteFontIni( 'HEADER', FHeaderFont );
        WriteFontIni( 'HEADER2', FHeader2Font );
        WriteFontIni( 'HEADER3', FHeader3Font );
        WriteFontIni( 'HEADING1', FHeading1Font );
        WriteFontIni( 'HEADING2', FHeading2Font );
        WriteFontIni( 'TEXT', FTextFont );
        WriteFontIni( 'WRAPPEDTEXT', FWrappedTextFont );
        WriteFontIni( 'STRINGS', FStringsFont );
        WriteFontIni( 'GRIDCAPTION', FDBGridCaptionFont );
        WriteFontIni( 'GRID', FDBGridFont );
        IniFile.WriteInteger(FIniSection, 'LEFT_MARGIN', FLeftMargin );
        IniFile.WriteInteger(FIniSection, 'TOP_MARGIN', FTopMargin );
        IniFile.WriteInteger(FIniSection, 'PITCH', FLinePitch );
        if Orientation = poLandscape then begin
            IniFile.WriteString(FIniSection, 'ORIENTATION', 'Landscape' )
        end
        else begin
            IniFile.WriteString( FIniSection, 'ORIENTATION', 'Portrait' );
        end;

        IniFile.WriteBool(FIniSection,'PAGED_SECTIONS', FPagedBlocks);
        IniFile.WriteBool(FIniSection,'TILING', FTiled);
        IniFile.WriteInteger(FIniSection, 'SUB_BLOCK', FSubBlockLines );

    finally
        IniFile.Free;
    end;
end;


{ ** helper function writes fonts to IniFile ** }
// typical entry is HEADER1,Arial,10,BUI
// where B=Bold, U=Underline, I=Italic

procedure TReport.ReadFontIni( const Key : string; Font : TFont );

var IniString : string;
    CommaIndex : integer;
    Comma2Index : integer;
    Len : integer;
    Styles : TFontStyles;

begin
    IniString := IniFile.ReadString( FIniSection, Key, '' );

    Len := Length( IniString );
    if Len = 0 then begin
        exit;
    end;

    // font name
    CommaIndex := Pos( ',', IniString );
    Font.Name := Copy( IniString, 1, CommaIndex - 1 );

    //find next comma
    Comma2Index := CommaIndex +1;
    while (Comma2Index <= Len) and (IniString[Comma2Index] <> ',') do begin
        Inc( Comma2Index );
    end;

    // font size lies between commas
    Font.Size := StrToIntDef( copy(IniString,CommaIndex+1, Comma2Index-CommaIndex -1), 10);

    // font size
    Inc( Comma2Index );

    // font styes
    Styles := [];
    while Comma2Index <= Len do begin
        case IniString[Comma2Index] of
        'B' : Styles := Styles + [fsBold];
        'U' : Styles := Styles + [fsUnderline];
        'I' : Styles := Styles + [fsItalic];
        end;
        Inc( Comma2Index );
    end;
    Font.Style := Styles;
end;


{ *** READ CONFIG FILE INTO CURRENT SETTINGS *** }

procedure TReport.ReadIniFile;

var
    OrientationString : string;

begin
    if (IniFileName = '') or (FIniSection = '') then begin
        exit;
    end;        

    IniFile := TIniFile.Create( IniFileName );
    TRY
        ReadFontIni( 'HEADER', FHeaderFont );
        ReadFontIni( 'HEADER2', FHeader2Font );
        ReadFontIni( 'HEADER3', FHeader3Font );
        ReadFontIni( 'HEADING1', FHeading1Font );
        ReadFontIni( 'HEADING2', FHeading2Font );
        ReadFontIni( 'TEXT', FTextFont );
        ReadFontIni( 'WRAPPEDTEXT', FWrappedTextFont );
        ReadFontIni( 'STRINGS', FStringsFont );
        ReadFontIni( 'GRIDCAPTION', FDBGridCaptionFont );
        ReadFontIni( 'GRID', FDBGridFont );

        FLeftMargin := IniFile.ReadInteger(FIniSection, 'LEFT_MARGIN', FLeftMargin );
        FTopMargin := IniFile.ReadInteger(FIniSection, 'TOP_MARGIN', FTopMargin );
        FLinePitch := IniFile.ReadInteger(FIniSection, 'PITCH', FLinePitch );

        OrientationString := UpperCase( IniFile.ReadString( FIniSection, 'ORIENTATION', '' ));
        if OrientationString = 'LANDSCAPE' then
            FOrientation := poLandscape
        else if OrientationString = 'PORTRAIT' then
            FOrientation := poPortrait;

        FPagedBlocks := IniFile.ReadBool(FIniSection,'PAGED_SECTIONS', FPagedBlocks);
        FTiled := IniFile.ReadBool(FIniSection,'TILING', FTiled);
        FSubBlockLines :=
            IniFile.ReadInteger( FIniSection, 'SUB_BLOCK', FSubBlockLines );

    FINALLY
        IniFile.Free;
    END;

end;

end.



