object ScriptForm: TScriptForm
  Left = 593
  Top = 129
  Width = 840
  Height = 651
  Caption = #1057#1082#1088#1080#1087#1090#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClick = FormClick
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 233
    Top = 36
    Height = 588
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 33
    Width = 832
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 33
    Align = alTop
    TabOrder = 0
    object ToolBar5: TToolBar
      Left = 1
      Top = 1
      Width = 830
      Height = 29
      Caption = 'ToolBar5'
      Images = ImageList10
      TabOrder = 0
      object ToolButton11: TToolButton
        Left = 0
        Top = 2
        Hint = #1050#1086#1084#1087#1080#1083#1083#1080#1088#1086#1074#1072#1090#1100
        Caption = 'ToolButton11'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = ToolButton1Click
      end
    end
  end
  object Panel2: TPanel
    Left = 236
    Top = 36
    Width = 596
    Height = 588
    Align = alClient
    TabOrder = 1
    object Splitter4: TSplitter
      Left = 1
      Top = 477
      Width = 594
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Panel5: TPanel
      Left = 1
      Top = 1
      Width = 594
      Height = 78
      Align = alTop
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 0
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 226
        Height = 78
        Align = alClient
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Lines.Strings = (
          '')
        ParentFont = False
        TabOrder = 0
      end
      object PanelEdit: TPanel
        Left = 411
        Top = 0
        Width = 183
        Height = 78
        Align = alRight
        TabOrder = 1
        object Label1: TLabel
          Left = 6
          Top = 59
          Width = 12
          Height = 13
          Caption = 'Int'
        end
        object Label2: TLabel
          Left = 4
          Top = 34
          Width = 21
          Height = 13
          Caption = 'Expr'
        end
        object SpinEdit1: TSpinEdit
          Left = 31
          Top = 53
          Width = 148
          Height = 22
          MaxValue = 200000000
          MinValue = 100
          TabOrder = 0
          Value = 60000
          OnChange = SpinEdit1Change
        end
        object ToolBar3: TToolBar
          Left = 1
          Top = -1
          Width = 23
          Height = 27
          Align = alNone
          AutoSize = True
          ButtonHeight = 23
          Caption = 'ToolBar3'
          Images = ImageList3
          TabOrder = 1
          object PanelIV: TToolButton
            Left = 0
            Top = 2
            Caption = 'PanelIV'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = PanelIVClick
          end
        end
        object exprstrin: TEditExpr
          Left = 30
          Top = 29
          Width = 147
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnChange = exprstrinChange
          corrColor = clGreen
          nocorrColor = clRed
          defColor = clBlack
          ButDialog = True
        end
        object ToolBar2: TToolBar
          Left = 24
          Top = 1
          Width = 73
          Height = 24
          Align = alNone
          Caption = 'ToolBar2'
          DisabledImages = ImageList4
          EdgeBorders = []
          Images = ImageList5
          TabOrder = 3
          object ToolButton5: TToolButton
            Left = 0
            Top = 2
            Hint = #1055#1088#1086#1089#1090#1086#1081' '#1090#1088#1080#1075#1075#1077#1088
            Caption = 'ToolButton5'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            Style = tbsCheck
            OnClick = ToolButton5Click
          end
          object ToolButton4: TToolButton
            Left = 23
            Top = 2
            Hint = #1058#1088#1080#1075#1075#1077#1088'-'#1090#1072#1081#1084#1077#1088
            Caption = 'ToolButton4'
            ImageIndex = 1
            ParentShowHint = False
            ShowHint = True
            Style = tbsCheck
            OnClick = ToolButton4Click
          end
          object ToolButton6: TToolButton
            Left = 46
            Top = 2
            Hint = #1052#1077#1088#1094#1072#1102#1097#1080#1081' '#1090#1088#1080#1075#1075#1077#1088
            Caption = 'ToolButton6'
            ImageIndex = 2
            ParentShowHint = False
            ShowHint = True
            Style = tbsCheck
            OnClick = ToolButton6Click
          end
        end
      end
      object Panel4: TPanel
        Left = 226
        Top = 0
        Width = 185
        Height = 78
        Align = alRight
        TabOrder = 2
        object Label3: TLabel
          Left = 14
          Top = 11
          Width = 12
          Height = 13
          Caption = 'Int'
        end
        object SpinEdit2: TSpinEdit
          Left = 23
          Top = 29
          Width = 148
          Height = 22
          MaxValue = 200000000
          MinValue = 100
          TabOrder = 0
          Value = 60000
          OnChange = SpinEdit1Change
        end
      end
    end
    object PageControl2: TPageControl
      Left = 1
      Top = 79
      Width = 594
      Height = 398
      ActivePage = TabSheet4
      Align = alTop
      TabOrder = 1
      object TabSheet4: TTabSheet
        Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077
        object Memo1: TSynMemo
          Left = 0
          Top = 0
          Width = 586
          Height = 370
          Cursor = crIBeam
          Align = alClient
          Color = 15138814
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnExit = Memo1Exit
          Gutter.Font.Charset = RUSSIAN_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -13
          Gutter.Font.Name = 'Arial'
          Gutter.Font.Style = []
          HideSelection = True
          Highlighter = SynPasSyn1
          Keystrokes = <
            item
              Command = ecUp
              ShortCut = 38
            end
            item
              Command = ecSelUp
              ShortCut = 8230
            end
            item
              Command = ecScrollUp
              ShortCut = 16422
            end
            item
              Command = ecDown
              ShortCut = 40
            end
            item
              Command = ecSelDown
              ShortCut = 8232
            end
            item
              Command = ecScrollDown
              ShortCut = 16424
            end
            item
              Command = ecLeft
              ShortCut = 37
            end
            item
              Command = ecSelLeft
              ShortCut = 8229
            end
            item
              Command = ecWordLeft
              ShortCut = 16421
            end
            item
              Command = ecSelWordLeft
              ShortCut = 24613
            end
            item
              Command = ecRight
              ShortCut = 39
            end
            item
              Command = ecSelRight
              ShortCut = 8231
            end
            item
              Command = ecWordRight
              ShortCut = 16423
            end
            item
              Command = ecSelWordRight
              ShortCut = 24615
            end
            item
              Command = ecPageDown
              ShortCut = 34
            end
            item
              Command = ecSelPageDown
              ShortCut = 8226
            end
            item
              Command = ecPageBottom
              ShortCut = 16418
            end
            item
              Command = ecSelPageBottom
              ShortCut = 24610
            end
            item
              Command = ecPageUp
              ShortCut = 33
            end
            item
              Command = ecSelPageUp
              ShortCut = 8225
            end
            item
              Command = ecPageTop
              ShortCut = 16417
            end
            item
              Command = ecSelPageTop
              ShortCut = 24609
            end
            item
              Command = ecLineStart
              ShortCut = 36
            end
            item
              Command = ecSelLineStart
              ShortCut = 8228
            end
            item
              Command = ecEditorTop
              ShortCut = 16420
            end
            item
              Command = ecSelEditorTop
              ShortCut = 24612
            end
            item
              Command = ecLineEnd
              ShortCut = 35
            end
            item
              Command = ecSelLineEnd
              ShortCut = 8227
            end
            item
              Command = ecEditorBottom
              ShortCut = 16419
            end
            item
              Command = ecSelEditorBottom
              ShortCut = 24611
            end
            item
              Command = ecToggleMode
              ShortCut = 45
            end
            item
              Command = ecCopy
              ShortCut = 16429
            end
            item
              Command = ecCut
              ShortCut = 8238
            end
            item
              Command = ecPaste
              ShortCut = 8237
            end
            item
              Command = ecDeleteChar
              ShortCut = 46
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8200
            end
            item
              Command = ecDeleteLastWord
              ShortCut = 16392
            end
            item
              Command = ecUndo
              ShortCut = 32776
            end
            item
              Command = ecRedo
              ShortCut = 40968
            end
            item
              Command = ecLineBreak
              ShortCut = 13
            end
            item
              Command = ecLineBreak
              ShortCut = 8205
            end
            item
              Command = ecTab
              ShortCut = 9
            end
            item
              Command = ecShiftTab
              ShortCut = 8201
            end
            item
              Command = ecContextHelp
              ShortCut = 16496
            end
            item
              Command = ecSelectAll
              ShortCut = 16449
            end
            item
              Command = ecCopy
              ShortCut = 16451
            end
            item
              Command = ecPaste
              ShortCut = 16470
            end
            item
              Command = ecCut
              ShortCut = 16472
            end
            item
              Command = ecBlockIndent
              ShortCut = 24649
            end
            item
              Command = ecBlockUnindent
              ShortCut = 24661
            end
            item
              Command = ecLineBreak
              ShortCut = 16461
            end
            item
              Command = ecInsertLine
              ShortCut = 16462
            end
            item
              Command = ecDeleteWord
              ShortCut = 16468
            end
            item
              Command = ecDeleteLine
              ShortCut = 16473
            end
            item
              Command = ecDeleteEOL
              ShortCut = 24665
            end
            item
              Command = ecUndo
              ShortCut = 16474
            end
            item
              Command = ecRedo
              ShortCut = 24666
            end
            item
              Command = ecGotoMarker0
              ShortCut = 16432
            end
            item
              Command = ecGotoMarker1
              ShortCut = 16433
            end
            item
              Command = ecGotoMarker2
              ShortCut = 16434
            end
            item
              Command = ecGotoMarker3
              ShortCut = 16435
            end
            item
              Command = ecGotoMarker4
              ShortCut = 16436
            end
            item
              Command = ecGotoMarker5
              ShortCut = 16437
            end
            item
              Command = ecGotoMarker6
              ShortCut = 16438
            end
            item
              Command = ecGotoMarker7
              ShortCut = 16439
            end
            item
              Command = ecGotoMarker8
              ShortCut = 16440
            end
            item
              Command = ecGotoMarker9
              ShortCut = 16441
            end
            item
              Command = ecSetMarker0
              ShortCut = 24624
            end
            item
              Command = ecSetMarker1
              ShortCut = 24625
            end
            item
              Command = ecSetMarker2
              ShortCut = 24626
            end
            item
              Command = ecSetMarker3
              ShortCut = 24627
            end
            item
              Command = ecSetMarker4
              ShortCut = 24628
            end
            item
              Command = ecSetMarker5
              ShortCut = 24629
            end
            item
              Command = ecSetMarker6
              ShortCut = 24630
            end
            item
              Command = ecSetMarker7
              ShortCut = 24631
            end
            item
              Command = ecSetMarker8
              ShortCut = 24632
            end
            item
              Command = ecSetMarker9
              ShortCut = 24633
            end
            item
              Command = ecNormalSelect
              ShortCut = 24654
            end
            item
              Command = ecColumnSelect
              ShortCut = 24643
            end
            item
              Command = ecLineSelect
              ShortCut = 24652
            end
            item
              Command = ecMatchBracket
              ShortCut = 24642
            end>
          Lines.Strings = (
            '')
        end
      end
      object TabSheet5: TTabSheet
        Caption = #1057#1073#1086#1088#1082#1072
        ImageIndex = 1
        OnShow = TabSheet5Show
        object SynMemo1: TSynMemo
          Left = 0
          Top = 0
          Width = 586
          Height = 370
          Cursor = crIBeam
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Terminal'
          Gutter.Font.Style = []
          Highlighter = SynPasSyn1
          Keystrokes = <
            item
              Command = ecUp
              ShortCut = 38
            end
            item
              Command = ecSelUp
              ShortCut = 8230
            end
            item
              Command = ecScrollUp
              ShortCut = 16422
            end
            item
              Command = ecDown
              ShortCut = 40
            end
            item
              Command = ecSelDown
              ShortCut = 8232
            end
            item
              Command = ecScrollDown
              ShortCut = 16424
            end
            item
              Command = ecLeft
              ShortCut = 37
            end
            item
              Command = ecSelLeft
              ShortCut = 8229
            end
            item
              Command = ecWordLeft
              ShortCut = 16421
            end
            item
              Command = ecSelWordLeft
              ShortCut = 24613
            end
            item
              Command = ecRight
              ShortCut = 39
            end
            item
              Command = ecSelRight
              ShortCut = 8231
            end
            item
              Command = ecWordRight
              ShortCut = 16423
            end
            item
              Command = ecSelWordRight
              ShortCut = 24615
            end
            item
              Command = ecPageDown
              ShortCut = 34
            end
            item
              Command = ecSelPageDown
              ShortCut = 8226
            end
            item
              Command = ecPageBottom
              ShortCut = 16418
            end
            item
              Command = ecSelPageBottom
              ShortCut = 24610
            end
            item
              Command = ecPageUp
              ShortCut = 33
            end
            item
              Command = ecSelPageUp
              ShortCut = 8225
            end
            item
              Command = ecPageTop
              ShortCut = 16417
            end
            item
              Command = ecSelPageTop
              ShortCut = 24609
            end
            item
              Command = ecLineStart
              ShortCut = 36
            end
            item
              Command = ecSelLineStart
              ShortCut = 8228
            end
            item
              Command = ecEditorTop
              ShortCut = 16420
            end
            item
              Command = ecSelEditorTop
              ShortCut = 24612
            end
            item
              Command = ecLineEnd
              ShortCut = 35
            end
            item
              Command = ecSelLineEnd
              ShortCut = 8227
            end
            item
              Command = ecEditorBottom
              ShortCut = 16419
            end
            item
              Command = ecSelEditorBottom
              ShortCut = 24611
            end
            item
              Command = ecToggleMode
              ShortCut = 45
            end
            item
              Command = ecCopy
              ShortCut = 16429
            end
            item
              Command = ecCut
              ShortCut = 8238
            end
            item
              Command = ecPaste
              ShortCut = 8237
            end
            item
              Command = ecDeleteChar
              ShortCut = 46
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8200
            end
            item
              Command = ecDeleteLastWord
              ShortCut = 16392
            end
            item
              Command = ecUndo
              ShortCut = 32776
            end
            item
              Command = ecRedo
              ShortCut = 40968
            end
            item
              Command = ecLineBreak
              ShortCut = 13
            end
            item
              Command = ecLineBreak
              ShortCut = 8205
            end
            item
              Command = ecTab
              ShortCut = 9
            end
            item
              Command = ecShiftTab
              ShortCut = 8201
            end
            item
              Command = ecContextHelp
              ShortCut = 16496
            end
            item
              Command = ecSelectAll
              ShortCut = 16449
            end
            item
              Command = ecCopy
              ShortCut = 16451
            end
            item
              Command = ecPaste
              ShortCut = 16470
            end
            item
              Command = ecCut
              ShortCut = 16472
            end
            item
              Command = ecBlockIndent
              ShortCut = 24649
            end
            item
              Command = ecBlockUnindent
              ShortCut = 24661
            end
            item
              Command = ecLineBreak
              ShortCut = 16461
            end
            item
              Command = ecInsertLine
              ShortCut = 16462
            end
            item
              Command = ecDeleteWord
              ShortCut = 16468
            end
            item
              Command = ecDeleteLine
              ShortCut = 16473
            end
            item
              Command = ecDeleteEOL
              ShortCut = 24665
            end
            item
              Command = ecUndo
              ShortCut = 16474
            end
            item
              Command = ecRedo
              ShortCut = 24666
            end
            item
              Command = ecGotoMarker0
              ShortCut = 16432
            end
            item
              Command = ecGotoMarker1
              ShortCut = 16433
            end
            item
              Command = ecGotoMarker2
              ShortCut = 16434
            end
            item
              Command = ecGotoMarker3
              ShortCut = 16435
            end
            item
              Command = ecGotoMarker4
              ShortCut = 16436
            end
            item
              Command = ecGotoMarker5
              ShortCut = 16437
            end
            item
              Command = ecGotoMarker6
              ShortCut = 16438
            end
            item
              Command = ecGotoMarker7
              ShortCut = 16439
            end
            item
              Command = ecGotoMarker8
              ShortCut = 16440
            end
            item
              Command = ecGotoMarker9
              ShortCut = 16441
            end
            item
              Command = ecSetMarker0
              ShortCut = 24624
            end
            item
              Command = ecSetMarker1
              ShortCut = 24625
            end
            item
              Command = ecSetMarker2
              ShortCut = 24626
            end
            item
              Command = ecSetMarker3
              ShortCut = 24627
            end
            item
              Command = ecSetMarker4
              ShortCut = 24628
            end
            item
              Command = ecSetMarker5
              ShortCut = 24629
            end
            item
              Command = ecSetMarker6
              ShortCut = 24630
            end
            item
              Command = ecSetMarker7
              ShortCut = 24631
            end
            item
              Command = ecSetMarker8
              ShortCut = 24632
            end
            item
              Command = ecSetMarker9
              ShortCut = 24633
            end
            item
              Command = ecNormalSelect
              ShortCut = 24654
            end
            item
              Command = ecColumnSelect
              ShortCut = 24643
            end
            item
              Command = ecLineSelect
              ShortCut = 24652
            end
            item
              Command = ecMatchBracket
              ShortCut = 24642
            end>
          ReadOnly = True
        end
      end
    end
    object PageControl3: TPageControl
      Left = 1
      Top = 480
      Width = 594
      Height = 107
      ActivePage = TabSheet6
      Align = alClient
      TabOrder = 2
      object TabSheet6: TTabSheet
        Caption = #1050#1086#1084#1087#1080#1083#1103#1094#1080#1103
        object Memo3: TSynMemo
          Left = 0
          Top = 0
          Width = 586
          Height = 79
          Cursor = crIBeam
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Terminal'
          Gutter.Font.Style = []
          Highlighter = SynAsmSyn1
          Keystrokes = <
            item
              Command = ecUp
              ShortCut = 38
            end
            item
              Command = ecSelUp
              ShortCut = 8230
            end
            item
              Command = ecScrollUp
              ShortCut = 16422
            end
            item
              Command = ecDown
              ShortCut = 40
            end
            item
              Command = ecSelDown
              ShortCut = 8232
            end
            item
              Command = ecScrollDown
              ShortCut = 16424
            end
            item
              Command = ecLeft
              ShortCut = 37
            end
            item
              Command = ecSelLeft
              ShortCut = 8229
            end
            item
              Command = ecWordLeft
              ShortCut = 16421
            end
            item
              Command = ecSelWordLeft
              ShortCut = 24613
            end
            item
              Command = ecRight
              ShortCut = 39
            end
            item
              Command = ecSelRight
              ShortCut = 8231
            end
            item
              Command = ecWordRight
              ShortCut = 16423
            end
            item
              Command = ecSelWordRight
              ShortCut = 24615
            end
            item
              Command = ecPageDown
              ShortCut = 34
            end
            item
              Command = ecSelPageDown
              ShortCut = 8226
            end
            item
              Command = ecPageBottom
              ShortCut = 16418
            end
            item
              Command = ecSelPageBottom
              ShortCut = 24610
            end
            item
              Command = ecPageUp
              ShortCut = 33
            end
            item
              Command = ecSelPageUp
              ShortCut = 8225
            end
            item
              Command = ecPageTop
              ShortCut = 16417
            end
            item
              Command = ecSelPageTop
              ShortCut = 24609
            end
            item
              Command = ecLineStart
              ShortCut = 36
            end
            item
              Command = ecSelLineStart
              ShortCut = 8228
            end
            item
              Command = ecEditorTop
              ShortCut = 16420
            end
            item
              Command = ecSelEditorTop
              ShortCut = 24612
            end
            item
              Command = ecLineEnd
              ShortCut = 35
            end
            item
              Command = ecSelLineEnd
              ShortCut = 8227
            end
            item
              Command = ecEditorBottom
              ShortCut = 16419
            end
            item
              Command = ecSelEditorBottom
              ShortCut = 24611
            end
            item
              Command = ecToggleMode
              ShortCut = 45
            end
            item
              Command = ecCopy
              ShortCut = 16429
            end
            item
              Command = ecCut
              ShortCut = 8238
            end
            item
              Command = ecPaste
              ShortCut = 8237
            end
            item
              Command = ecDeleteChar
              ShortCut = 46
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8200
            end
            item
              Command = ecDeleteLastWord
              ShortCut = 16392
            end
            item
              Command = ecUndo
              ShortCut = 32776
            end
            item
              Command = ecRedo
              ShortCut = 40968
            end
            item
              Command = ecLineBreak
              ShortCut = 13
            end
            item
              Command = ecLineBreak
              ShortCut = 8205
            end
            item
              Command = ecTab
              ShortCut = 9
            end
            item
              Command = ecShiftTab
              ShortCut = 8201
            end
            item
              Command = ecContextHelp
              ShortCut = 16496
            end
            item
              Command = ecSelectAll
              ShortCut = 16449
            end
            item
              Command = ecCopy
              ShortCut = 16451
            end
            item
              Command = ecPaste
              ShortCut = 16470
            end
            item
              Command = ecCut
              ShortCut = 16472
            end
            item
              Command = ecBlockIndent
              ShortCut = 24649
            end
            item
              Command = ecBlockUnindent
              ShortCut = 24661
            end
            item
              Command = ecLineBreak
              ShortCut = 16461
            end
            item
              Command = ecInsertLine
              ShortCut = 16462
            end
            item
              Command = ecDeleteWord
              ShortCut = 16468
            end
            item
              Command = ecDeleteLine
              ShortCut = 16473
            end
            item
              Command = ecDeleteEOL
              ShortCut = 24665
            end
            item
              Command = ecUndo
              ShortCut = 16474
            end
            item
              Command = ecRedo
              ShortCut = 24666
            end
            item
              Command = ecGotoMarker0
              ShortCut = 16432
            end
            item
              Command = ecGotoMarker1
              ShortCut = 16433
            end
            item
              Command = ecGotoMarker2
              ShortCut = 16434
            end
            item
              Command = ecGotoMarker3
              ShortCut = 16435
            end
            item
              Command = ecGotoMarker4
              ShortCut = 16436
            end
            item
              Command = ecGotoMarker5
              ShortCut = 16437
            end
            item
              Command = ecGotoMarker6
              ShortCut = 16438
            end
            item
              Command = ecGotoMarker7
              ShortCut = 16439
            end
            item
              Command = ecGotoMarker8
              ShortCut = 16440
            end
            item
              Command = ecGotoMarker9
              ShortCut = 16441
            end
            item
              Command = ecSetMarker0
              ShortCut = 24624
            end
            item
              Command = ecSetMarker1
              ShortCut = 24625
            end
            item
              Command = ecSetMarker2
              ShortCut = 24626
            end
            item
              Command = ecSetMarker3
              ShortCut = 24627
            end
            item
              Command = ecSetMarker4
              ShortCut = 24628
            end
            item
              Command = ecSetMarker5
              ShortCut = 24629
            end
            item
              Command = ecSetMarker6
              ShortCut = 24630
            end
            item
              Command = ecSetMarker7
              ShortCut = 24631
            end
            item
              Command = ecSetMarker8
              ShortCut = 24632
            end
            item
              Command = ecSetMarker9
              ShortCut = 24633
            end
            item
              Command = ecNormalSelect
              ShortCut = 24654
            end
            item
              Command = ecColumnSelect
              ShortCut = 24643
            end
            item
              Command = ecLineSelect
              ShortCut = 24652
            end
            item
              Command = ecMatchBracket
              ShortCut = 24642
            end>
          Lines.Strings = (
            'Memo3')
        end
      end
      object TabSheet7: TTabSheet
        Caption = #1040#1089#1089#1077#1084#1073#1083#1077#1088
        ImageIndex = 1
        OnShow = TabSheet7Show
        object SynMemo2: TSynMemo
          Left = 0
          Top = 0
          Width = 586
          Height = 79
          Cursor = crIBeam
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Terminal'
          Gutter.Font.Style = []
          Highlighter = SynAsmSyn1
          Keystrokes = <
            item
              Command = ecUp
              ShortCut = 38
            end
            item
              Command = ecSelUp
              ShortCut = 8230
            end
            item
              Command = ecScrollUp
              ShortCut = 16422
            end
            item
              Command = ecDown
              ShortCut = 40
            end
            item
              Command = ecSelDown
              ShortCut = 8232
            end
            item
              Command = ecScrollDown
              ShortCut = 16424
            end
            item
              Command = ecLeft
              ShortCut = 37
            end
            item
              Command = ecSelLeft
              ShortCut = 8229
            end
            item
              Command = ecWordLeft
              ShortCut = 16421
            end
            item
              Command = ecSelWordLeft
              ShortCut = 24613
            end
            item
              Command = ecRight
              ShortCut = 39
            end
            item
              Command = ecSelRight
              ShortCut = 8231
            end
            item
              Command = ecWordRight
              ShortCut = 16423
            end
            item
              Command = ecSelWordRight
              ShortCut = 24615
            end
            item
              Command = ecPageDown
              ShortCut = 34
            end
            item
              Command = ecSelPageDown
              ShortCut = 8226
            end
            item
              Command = ecPageBottom
              ShortCut = 16418
            end
            item
              Command = ecSelPageBottom
              ShortCut = 24610
            end
            item
              Command = ecPageUp
              ShortCut = 33
            end
            item
              Command = ecSelPageUp
              ShortCut = 8225
            end
            item
              Command = ecPageTop
              ShortCut = 16417
            end
            item
              Command = ecSelPageTop
              ShortCut = 24609
            end
            item
              Command = ecLineStart
              ShortCut = 36
            end
            item
              Command = ecSelLineStart
              ShortCut = 8228
            end
            item
              Command = ecEditorTop
              ShortCut = 16420
            end
            item
              Command = ecSelEditorTop
              ShortCut = 24612
            end
            item
              Command = ecLineEnd
              ShortCut = 35
            end
            item
              Command = ecSelLineEnd
              ShortCut = 8227
            end
            item
              Command = ecEditorBottom
              ShortCut = 16419
            end
            item
              Command = ecSelEditorBottom
              ShortCut = 24611
            end
            item
              Command = ecToggleMode
              ShortCut = 45
            end
            item
              Command = ecCopy
              ShortCut = 16429
            end
            item
              Command = ecCut
              ShortCut = 8238
            end
            item
              Command = ecPaste
              ShortCut = 8237
            end
            item
              Command = ecDeleteChar
              ShortCut = 46
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8
            end
            item
              Command = ecDeleteLastChar
              ShortCut = 8200
            end
            item
              Command = ecDeleteLastWord
              ShortCut = 16392
            end
            item
              Command = ecUndo
              ShortCut = 32776
            end
            item
              Command = ecRedo
              ShortCut = 40968
            end
            item
              Command = ecLineBreak
              ShortCut = 13
            end
            item
              Command = ecLineBreak
              ShortCut = 8205
            end
            item
              Command = ecTab
              ShortCut = 9
            end
            item
              Command = ecShiftTab
              ShortCut = 8201
            end
            item
              Command = ecContextHelp
              ShortCut = 16496
            end
            item
              Command = ecSelectAll
              ShortCut = 16449
            end
            item
              Command = ecCopy
              ShortCut = 16451
            end
            item
              Command = ecPaste
              ShortCut = 16470
            end
            item
              Command = ecCut
              ShortCut = 16472
            end
            item
              Command = ecBlockIndent
              ShortCut = 24649
            end
            item
              Command = ecBlockUnindent
              ShortCut = 24661
            end
            item
              Command = ecLineBreak
              ShortCut = 16461
            end
            item
              Command = ecInsertLine
              ShortCut = 16462
            end
            item
              Command = ecDeleteWord
              ShortCut = 16468
            end
            item
              Command = ecDeleteLine
              ShortCut = 16473
            end
            item
              Command = ecDeleteEOL
              ShortCut = 24665
            end
            item
              Command = ecUndo
              ShortCut = 16474
            end
            item
              Command = ecRedo
              ShortCut = 24666
            end
            item
              Command = ecGotoMarker0
              ShortCut = 16432
            end
            item
              Command = ecGotoMarker1
              ShortCut = 16433
            end
            item
              Command = ecGotoMarker2
              ShortCut = 16434
            end
            item
              Command = ecGotoMarker3
              ShortCut = 16435
            end
            item
              Command = ecGotoMarker4
              ShortCut = 16436
            end
            item
              Command = ecGotoMarker5
              ShortCut = 16437
            end
            item
              Command = ecGotoMarker6
              ShortCut = 16438
            end
            item
              Command = ecGotoMarker7
              ShortCut = 16439
            end
            item
              Command = ecGotoMarker8
              ShortCut = 16440
            end
            item
              Command = ecGotoMarker9
              ShortCut = 16441
            end
            item
              Command = ecSetMarker0
              ShortCut = 24624
            end
            item
              Command = ecSetMarker1
              ShortCut = 24625
            end
            item
              Command = ecSetMarker2
              ShortCut = 24626
            end
            item
              Command = ecSetMarker3
              ShortCut = 24627
            end
            item
              Command = ecSetMarker4
              ShortCut = 24628
            end
            item
              Command = ecSetMarker5
              ShortCut = 24629
            end
            item
              Command = ecSetMarker6
              ShortCut = 24630
            end
            item
              Command = ecSetMarker7
              ShortCut = 24631
            end
            item
              Command = ecSetMarker8
              ShortCut = 24632
            end
            item
              Command = ecSetMarker9
              ShortCut = 24633
            end
            item
              Command = ecNormalSelect
              ShortCut = 24654
            end
            item
              Command = ecColumnSelect
              ShortCut = 24643
            end
            item
              Command = ecLineSelect
              ShortCut = 24652
            end
            item
              Command = ecMatchBracket
              ShortCut = 24642
            end>
          Lines.Strings = (
            '')
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 36
    Width = 233
    Height = 588
    Align = alLeft
    Caption = 'Panel3'
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 231
      Height = 586
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #1057#1082#1088#1080#1087#1090#1099
        OnShow = TabSheet1Show
        object TreeView1: TTreeView
          Left = 0
          Top = 29
          Width = 223
          Height = 529
          Align = alClient
          Color = 15138814
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Images = ImageList1
          Indent = 19
          ParentFont = False
          TabOrder = 0
          OnClick = TreeView1Click
          OnEdited = TreeView1Edited
          OnGetSelectedIndex = TreeView1GetSelectedIndex
        end
        object ToolBar1: TToolBar
          Left = 0
          Top = 0
          Width = 223
          Height = 29
          Caption = 'ToolBar1'
          DisabledImages = ImageList15
          Images = ImageList9
          TabOrder = 1
          object ToolButton1: TToolButton
            Left = 0
            Top = 2
            Hint = #1053#1086#1074#1099#1081' '#1089#1082#1088#1080#1087#1090
            Caption = 'ToolButton1'
            DropdownMenu = PopupMenu2
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            Style = tbsDropDown
          end
          object toolbuttonss: TToolButton
            Left = 36
            Top = 2
            Caption = 'toolbuttonss'
            ImageIndex = 1
            ParentShowHint = False
            ShowHint = True
            OnClick = toolbuttonssClick
          end
          object ToolButton9: TToolButton
            Left = 59
            Top = 2
            Caption = 'ToolButton9'
            ImageIndex = 2
            Visible = False
            OnClick = ToolButton9Click
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = #1057#1080#1089#1090#1077#1084#1085#1099#1077
        ImageIndex = 1
        object Memo4: TMemo
          Left = 0
          Top = 493
          Width = 223
          Height = 65
          Align = alBottom
          Enabled = False
          ReadOnly = True
          TabOrder = 0
        end
        object TreeView2: TTreeView
          Left = 0
          Top = 41
          Width = 223
          Height = 452
          Align = alClient
          Color = 15138814
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Images = ImageList11
          Indent = 19
          ParentFont = False
          ReadOnly = True
          StateImages = ImageList1
          TabOrder = 1
          OnClick = TreeView2Click
          OnDblClick = TreeView1DblClick
        end
        object Memo5: TMemo
          Left = 0
          Top = 0
          Width = 223
          Height = 41
          Align = alTop
          Enabled = False
          ReadOnly = True
          TabOrder = 2
        end
      end
      object TabSheet3: TTabSheet
        Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1077
        ImageIndex = 2
        OnShow = TabSheet1Show
        object ToolBar6: TToolBar
          Left = 0
          Top = 0
          Width = 223
          Height = 29
          Caption = 'ToolBar6'
          DisabledImages = ImageList14
          Images = ImageList13
          TabOrder = 0
          object ToolButton3q: TToolButton
            Left = 0
            Top = 2
            Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1091#1102
            Caption = 'ToolButton3q'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = ToolButton3qClick
          end
          object ToolButton4q: TToolButton
            Left = 23
            Top = 2
            Hint = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1091#1102
            Caption = 'ToolButton4q'
            ImageIndex = 1
            ParentShowHint = False
            ShowHint = True
            OnClick = ToolButton4qClick
          end
          object ToolButton5q: TToolButton
            Left = 46
            Top = 2
            Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1091#1102
            Caption = 'ToolButton5q'
            ImageIndex = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = ToolButton5qClick
          end
        end
        object TreeView3: TTreeView
          Left = 0
          Top = 29
          Width = 223
          Height = 529
          Align = alClient
          Color = 15138814
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Images = ImageList12
          Indent = 19
          ParentFont = False
          StateImages = ImageList1
          TabOrder = 1
          OnClick = TreeView3Click
          OnDblClick = TreeView3DblClick
          OnEdited = TreeView3Edited
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 352
    Top = 192
  end
  object OpenDialog1: TOpenDialog
    Left = 384
    Top = 192
  end
  object SynPasSyn1: TSynPasSyn
    CommentAttri.Foreground = clMaroon
    DirectiveAttri.Background = 10485760
    DirectiveAttri.Foreground = 8404992
    NumberAttri.Foreground = clBlue
    StringAttri.Foreground = clGreen
    Left = 592
    Top = 136
  end
  object SynCompletionProposal1: TSynCompletionProposal
    DefaultType = ctCode
    Options = [scoLimitToMatchedText, scoUseInsertList, scoUsePrettyText, scoUseBuiltInTimer, scoEndCharCompletion]
    OnExecute = SynCompletionProposal1Execute
    ItemList.Strings = (
      'uiykiiii'
      'uyituty'
      'ytftyut'
      'ruttur'
      '5ythy')
    InsertList.Strings = (
      'iiiiiiiiiiiiiii'
      'ikkkkkkkkk'
      'iiiiiiiiiii'
      'lllllllllll'
      '7898989')
    Position = 0
    NbLinesInWindow = 5
    ClSelect = clHighlight
    ClSelectedText = clHighlightText
    ClBackground = clWindow
    Width = 262
    BiggestWord = 'CONSTRUCTOR'
    EndOfTokenChr = '()[].> '
    TriggerChars = '.>'
    ClTitleBackground = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clBtnText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = [fsBold]
    ShortCut = 16416
    Editor = Memo1
    TimerInterval = 1000
    Left = 480
    Top = 256
  end
  object ImageList1: TImageList
    Left = 122
    Top = 100
    Bitmap = {
      494C01010F001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C00000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C0000000C00000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000800000008000000000000000800000000000
      000080000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000000000000080000000800000000000
      000080000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C00000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000000000000000000000800000000000
      000080000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000C00000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000000000000000000000800000000000
      FF0080000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000C0000000C0000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF008000
      00000000FF000000FF00800000000000FF000000FF000000FF00800000000000
      FF00800000000000FF000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000C0000000C0000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00800000008000
      0000800000000000FF00800000000000FF000000FF000000FF00800000000000
      FF0080000000800000008000000080000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000C0000000C0000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000C00000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C00000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000C0000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C0000000C00000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000C00000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000FF000000FF00000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000000000000000000000000000FF0000000000000000000000FF000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000800000008000000000000000000000008000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000080000000000000008000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000FF00000000000000FF000000000000000000000000000000
      FF00000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000080000000000000008000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF000000FF000000FF000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080000000000000000000000000000000800000000000FF008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF0000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000080000000800000000000000000000000800000000000FF008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000FF000000FF000000
      FF000000FF00800000000000FF0080000000800000000000FF000000FF008000
      00000000FF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF0000000000000000000000FF000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000000000000000FF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00F0FBFF00000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF000000FF00FFFFFF00FFFFFF000000FF0080000000000000000000
      00000000FF00000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F0FBFF00F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF000000FF000000FF000000FF00FFFFFF000000FF00800000000000FF00FFFF
      FF000000FF00000000000000FF0000000000FF000000FF000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000FF00FFFFFF0080000000FFFFFF00FFFF
      FF000000FF00800000000000FF00FFFFFF00FFFFFF000000FF00FFFFFF000000
      FF00FFFFFF00000000000000FF000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF000000F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF00000000000000FF0000000000000000000000
      00000000FF00000000000000FF0000000000FFFFFF0080000000FFFFFF000000
      FF00FFFFFF0080000000FFFFFF000000FF00FFFFFF00800000000000FF00FFFF
      FF00FFFFFF00000000000000FF000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF000000F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000FF00000000000000FF0000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF00800000000000000080000000FFFFFF00800000000000
      0000FFFFFF0000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000C00000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000FF00000000000000FF0000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF0000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF00000000000000FF0000000000000000000000
      00000000FF00000000000000FF0000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF0000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF0000000000000000000000000000000000000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF000000FF000000000000000000000000000000FF000000FF000000
      FF000000000000000000000000000000FF00FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF000000000000000000000000000000FF00FF0000000000FF000000
      FF000000FF00FF0000000000FF000000FF000000FF00FF0000000000FF000000
      FF000000FF00FF0000000000FF000000FF00000000000000000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C0000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF00FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF0000000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF0000000000000000000000000000000000000000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF0080000000800000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF008000000000000000FFFFFF00FFFFFF008000
      0000FFFFFF0080000000800000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000C00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      00008000000080000000000000000000000000000000FF000000000000000000
      000000000000FF000000000000000000000000000000FF000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      00008000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF00FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000F0FBFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF0080000000000000000000
      0000FFFFFF000000000000000000000000000000000080000000FFFFFF00FFFF
      FF00FFFFFF00800000000000FF000000FF000000FF00800000000000FF000000
      FF000000FF00000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00800000000000FF00FFFFFF000000FF00800000000000FF00FFFF
      FF000000FF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      800080808000000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00800000000000FF00FFFFFF000000FF00800000000000FF00FFFF
      FF000000FF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF0080000000FFFFFF00FFFF
      FF00FFFFFF00800000000000FF000000FF000000FF00800000000000FF000000
      FF000000FF00000000000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000C00000000000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF00800000000000000080000000FFFFFF00800000000000
      0000FFFFFF00000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF000000FF000000000080000000FFFFFF00800000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF00800000000000FF000000FF00FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000008080800000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000080808000000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      000000000000000000000000000000000000000000008080800000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000000C00000000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000008080800000C0000000C0
      000000C0000000C0000000C0000000C0000000C0000000C0000000C0000000C0
      000080808000000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF0080000000FFFF
      FF0080000000FFFFFF0080000000FFFFFF0080000000FFFFFF0080000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000C0000000C000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00800000008000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF008000000080000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000C00000000000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF008000000000000000FFFFFF00FFFFFF008000
      0000FFFFFF00800000008000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF008000000000000000FFFFFF00FFFFFF008000
      0000FFFFFF008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      000080000000800000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF900790040000FFFF000000000000
      FFFF000000000000EE57000000000000ED97000100000000EDD7000100000000
      EDC700010000000080030001000000008000000100000000EFCF000000000000
      F7DF000100000000FFFF000000000000FFFF000000000000FFFF000300020000
      FFFF000000000000FFFF008700830000EF2BFFFFFFFFFBFFEECBFFFF8001FBFF
      D6EBC001BFFFFA6FD70BDFFD803FF9AFBAEBDFFDBFFFFBAFBB1BDFFD83FFFB8F
      FFFBDF0DBFEFF987FFFBDF3DB8038003FFFEDF7DB8038003FFFFDF7DBFEFFFCF
      FFFFDF7D83FFFFDFFFFFDF7DBFFFFFFFFFFFDF7D803FFFFFFFFECFFDBFFFFFFF
      FFFFC0008001FFFFFFFF7FFEFFFFFFFF96FFFC00FFFFFFFF8034FFF0FFFFFFFF
      00053838FFFFD38E0005BBB8FFFFCD750005BBB8FFFFDD750117BBBAFFBFDD75
      0007BBBAFF9FCD750007BBBBC00FD38E00070000C007DFFE0007BBBBC00FDFFF
      0001BBBBFF9FFFFF0081BBBBFFBFFFFF0003BBBBFFFFFFFF00078382FFFFFFFE
      0007FFFCFFFFFFFF00877FFEFFFFFFFFFFFFFFFF96FF96FFFFFFFFFF80378004
      FFFF800700070005FFFFBF0700070005FFFFBFF700070004FFBFBFB701170117
      FF9FBF9700070007F00F800700070007F00F800700070007F79F800700070007
      F0BFBF9700010001F8FFBFB700810081FFFFBFF700030003FFFF800700070007
      FFFF800700070007FFFFFFFF0087008700000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 348
    Top = 121
    object N7: TMenuItem
      Caption = #1042#1099#1088#1077#1079#1072#1090#1100
      OnClick = N7Click
    end
    object N5: TMenuItem
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100
      OnClick = N6Click
    end
    object D1: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = D1Click
    end
  end
  object ImageList2: TImageList
    Left = 35
    Top = 130
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD000000F60C00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD050000F4770000FD06000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD050000F3770000F4770000FD
      0500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD07000083
      9400008394000083940000839400008394000083940000F2780000F47700009A
      8E0000FD06000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD060000F3
      770000F3770000F4770000F2780000F2780000F4770000F3770000F2780000F2
      78000044CC0000FD050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD060000F3
      770000F4770000F4770000F2780000F4770000F4770000F4770000F3770000F4
      770000F278000074A10000FD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD060000F4
      770000F4770000F2780000F4770000F2780000F4770000F4770000F4770000F2
      780000F4770000F4770000FD0500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD060000F3
      770000F2780000F4770000F4770000F4770000F3770000F4770000F4770000F4
      770000F37700007A9C0000FD0800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD060000F4
      770000F2780000F2780000F2780000F2780000F4770000F4770000F4770000F3
      77000044CC0000FD050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FD07000083
      9400008394000083940000839400008394000083940000F2780000F278000087
      9D0000FD06000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD050000F4770000F4770000FD
      0500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD050000F4770000FD06000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FD000000F90900000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FF3F000000000000
      FF1F000000000000FF0F000000000000C007000000000000C003000000000000
      C001000000000000C001000000000000C001000000000000C003000000000000
      C007000000000000FF0F000000000000FF1F000000000000FF3F000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object SynAsmSyn1: TSynAsmSyn
    Left = 628
    Top = 137
  end
  object ImageList3: TImageList
    Left = 151
    Top = 130
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00800000008000000080000000800000008000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF008000000080000000800000008000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000000000
      FF000000FF000000FF00000000008000000080000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      00000000FF000000FF000000FF0080000000800000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000800000008000
      00008000000080000000800000000000FF000000FF000000FF00800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF000000FF008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF00800000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      00000000FF000000FF000000FF008000000080000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000000000000000000008000000080000000800000000000
      FF000000FF000000FF0000000000800000008000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000800000008000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF008000000080000000800000008000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00800000008000000080000000800000008000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFDFFB00000000
      807F807100000000F87FC063000000000E7F0247000000000E7F000F00000000
      FE7FF81F00000000FE00FC0000000000C000C00000000000FE00FC0000000000
      FE7FF80F000000000E7F0047000000000E7F026300000000F87FC07100000000
      807F807B00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList5: TImageList
    Left = 180
    Top = 100
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF00000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      80000000FF000000FF0000000000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF00808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      0000000000000000000000000000000000000000000000E0000000E0000000E0
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      000000E0000000E0000000E00000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000E0
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      000000E000000000000000000000000000000000000000E00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E0400000E0400000E0400000000000000000000000000000E0400000E0
      400000E0400000E0400000000000000000000000000000000000000000008080
      8000808080008080800080808000000000000000000000000000808080008080
      800080808000808080000000000000000000000000000000000000E0000000E0
      000000E0000000000000000000000000000000000000000000000000000000E0
      000000E0000000E0000000000000000000000000000000E00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E0000000E0
      0000000000000000000000000000000000000000000000000000000000000000
      000000E0000000E0000000000000000000000000000000E00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      000000000000000000000000000000E0000000E0000000E0000000E0000000E0
      000000E000000000000000E000000000000000E0400000E0400000E0400000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      400000E0400000E0400000E0400000E040008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000E0000000E000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      000000000000000000000000000000E000000000000000000000000000000000
      0000000000000000000000E000000000000000E0400000E0400000E0400000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      400000E0400000E0400000E0400000E040008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000E0000000E000000000
      000000E0000000E0000000000000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      000000000000000000000000000000E000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E0000000E0
      000000E0000000E0000000E00000000000000000000000000000000000000000
      00000000000000E0000000E00000000000000000000000E00000000000000000
      000000000000000000000000000000E000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      4000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000E0000000E0000000E0
      000000E0000000E0000000E00000000000000000000000000000000000000000
      000000E0000000E0000000000000000000000000000000E0000000FF000000FF
      000000000000000000000000000000E000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      40000000000000000000000000000000000000000000000000000000FF000000
      FF00808080000000000000000000000000000000000000000000808080008080
      800000000000000000000000000000000000000000000000000000E0000000E0
      000000E0000000E00000000000000000000000000000000000000000000000E0
      000000E0000000E0000000000000000000000000000000FF000000FF000000FF
      000000FF0000000000000000000000E000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E04000000000000000000000000000000000000000000000E0400000E0
      400000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000808080008080
      80000000000000000000000000000000000000000000000000000000000000E0
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      000000E000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000E000000000000000000000000000000000000000E0
      400000E0400000E0400000E0400000000000000000000000000000E0400000E0
      400000E0400000E040000000000000000000000000000000FF000000FF000000
      FF000000FF008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      0000000000000000000000000000000000000000000000E0000000FF000000FF
      000000E0000000E0000000E0000000E0000000E0000000E0000000E0000000E0
      000000E0000000E0000000E00000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF000000008001F00F00000000
      BFFDE00700000000BFFDC7E300000000BFFD8FF300000000BFFD9FF900000000
      BFFD9FF900000000BE059FF900000000BEFD9FF900000000BEFD93F900000000
      BEFD81F9000000008EFD81F30000000086FDC3C30000000087FDC00700000000
      8001E00F00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFF00F8001FFFFFFFF
      E007BFFDE1C3E1C3C7E3BFFDE7CFE7CF8FF3BFFDE7CFE7CF9FF9BFFDE7CFE7CF
      9FF9BFFDE7CFE7CF9FF9BE0507C007C09FF9BEFD07C007C093F9BEFDE7CFE7CF
      81F9BEFDE7CFE7CF81F38EFDE7CFC7CFC3E386FDE7CF87CFE00787FDE1C381C3
      F00F8001FFFFCFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList6: TImageList
    Left = 180
    Top = 130
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080000000000080808000000000008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00008080800080808000000000000000000000000000808080000000FF000000
      FF00000000000000000000000000808080000000000000000000000000000000
      00000000000000000000808080000000000000000000000000000000FF000000
      FF00808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      80000000FF000000FF0000000000000000000000000000000000808080008080
      800080808000808080000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000808080000000000000000000000000000000
      000000000000000000008080800000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000000000000000FF000000FF000000
      FF000000FF008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      80000000000000000000000000000000000000000000808080000000FF000000
      FF00808080008080800080808000808080008080800080808000808080008080
      80008080800080808000808080000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F00F8001FFFF0000
      E007BFFDE1C30000C7E3BFFDE7CF00008FF3BFFDE7CF00009FF9BFFDE7CF0000
      9FF9BFFDE7CF00009FF9BE0507C000009FF9BEFD07C0000093F9BEFDE7CF0000
      81F9BEFDE7CF000081F38EFDC7CF0000C3C386FD87CF0000C00787FD81C30000
      E00F8001CFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object ImageList4: TImageList
    Left = 7
    Top = 130
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF00000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      80000000FF000000FF0000000000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000808080000000FF000000
      FF00808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000008080
      8000808080008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000808080008080
      8000808080000000000000000000000000000000000000000000000000008080
      8000808080008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      8000808080000000000080808000000000008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080000000000080808000808080000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000080808000808080000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      00008080800080808000000000000000000000000000808080000000FF000000
      FF00000000000000000000000000808080000000000000000000000000000000
      00000000000000000000808080000000000000000000000000000000FF000000
      FF00808080000000000000000000000000000000000000000000808080008080
      80000000000000000000000000000000000000000000000000000000FF000000
      FF00808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000808080008080
      80000000FF000000FF0000000000000000000000000000000000808080008080
      800080808000808080000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000808080000000000000000000000000000000
      000000000000000000008080800000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000808080008080
      800000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      800080808000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000008080800000000000000000000000FF000000FF000000
      FF000000FF008080800080808000000000000000000000000000808080008080
      800080808000808080000000000000000000000000000000FF000000FF000000
      FF000000FF008080800080808000000000000000000000000000808080008080
      8000808080008080800000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      80000000000000000000000000000000000000000000808080000000FF000000
      FF00808080008080800080808000808080008080800080808000808080008080
      80008080800080808000808080000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF000000008001F00F00000000
      BFFDE00700000000BFFDC7E300000000BFFD8FF300000000BFFD9FF900000000
      BFFD9FF900000000BE059FF900000000BEFD9FF900000000BEFD93F900000000
      BEFD81F9000000008EFD81F30000000086FDC3C30000000087FDC00700000000
      8001E00F00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFF00F8001FFFFFFFF
      E007BFFDE1C3E1C3C7E3BFFDE7CFE7CF8FF3BFFDE7CFE7CF9FF9BFFDE7CFE7CF
      9FF9BFFDE7CFE7CF9FF9BE0507C007C09FF9BEFD07C007C093F9BEFDE7CFE7CF
      81F9BEFDE7CFE7CF81F38EFDC7CFC7CFC3C386FD87CF87CFC00787FD81C381C3
      E00F8001CFFFCFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList7: TImageList
    Left = 122
    Top = 130
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      9F9F0000000000009F9F0000000000009F9F0000000000009F9F000000000000
      9F9F000000000000801F000000000000801F0000000000009F9F000000000000
      9F9F0000000000009F9F0000000000009F9F0000000000009F9E000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList8: TImageList
    Left = 93
    Top = 130
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      9F9F0000000000009F9F0000000000009F9F0000000000009F9F000000000000
      9F9F000000000000801F000000000000801F0000000000009F9F000000000000
      9F9F0000000000009F9F0000000000009F9F0000000000009F9E000000000000
      FFFF000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList9: TImageList
    Left = 64
    Top = 130
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000008000
      000080000000800000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000000000000000000000000
      000000000000000000008000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      000000000000F0FBFF0080000000F0FBFF00FFFFFF00FFFFFF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000F0FBFF00FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF00F0FBFF00FFFFFF00FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF9000FFFF00009FFF0000FFFF0000
      A00F00009F9F0000BE6100009F9F0000BE7D00009F9F0000BE7D00009F9F0000
      BE7D00009F9F0000BE7D0000801F0000BE7D0000801F0000BE7D00009F9F0000
      BE7D00009F9F0000BE7D00009F9F0000807D00009F9F0000BC0800009F9E0000
      FFE00001FFFF0000FFF80001FFFF000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu2: TPopupMenu
    Images = ImageList1
    Left = 381
    Top = 122
    object N1: TMenuItem
      Caption = #1041#1091#1083#1077#1074'-'#1090#1088#1080#1075#1075#1077#1088
      ImageIndex = 3
      OnClick = toolbuttonsClick
    end
    object N2: TMenuItem
      Caption = #1058#1088#1080#1075#1075#1077#1088'-'#1074#1099#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 4
      OnClick = ToolButton7Click
    end
    object N3: TMenuItem
      Caption = #1062#1080#1082#1083#1080#1095#1077#1089#1082#1080#1081'  '#1089#1082#1088#1080#1087#1090
      ImageIndex = 5
      OnClick = ToolButton3Click
    end
    object N4: TMenuItem
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1092#1103' '#1087#1088#1086#1094#1077#1076#1091#1088#1072
      ImageIndex = 10
      OnClick = ToolButton8Click
    end
  end
  object ImageList10: TImageList
    Left = 151
    Top = 100
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000080
      00000000FF000000FF000000FF000000FF000000FF00008000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000000FF0000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000008000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000008000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00008000000080
      0000008000000080000000800000008000000080000000800000008000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000080
      00000000FF000000FF000000FF000000FF000000FF00008000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FF7F000000000000
      FF3F000000000000801F000000000000800F0000000000008007000000000000
      8002000000000000800100000000000080010000000000008003000000000000
      8007000000000000800F000000000000801F000000000000FF3F000000000000
      FF7F000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
  object ImageList11: TImageList
    Left = 36
    Top = 100
    Bitmap = {
      494C01010D000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF000000FF00000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000FF000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000FF000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000FF0000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF000000FF00000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000000000000000000000000000FF000000FF000000FF00000000000000
      00000000FF0000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      FF0000000000000000000000FF000000FF0000000000000000000000FF000000
      FF00000000000000FF0000000000000000000000FF000000FF00000000000000
      FF00000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF0000000000000000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      00000000FF000000FF00000000000000FF0000000000000000000000FF000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000FF000000FF00000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000000000000000000000000000FF000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      0000000000000000FF00000000000000FF000000000000000000000000000000
      FF00000000000000FF00000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF0000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF0000000000000000000000FF00000000000000
      FF0000000000000000000000FF000000FF00000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF000000FF000000FF000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF0000000000000000000000FF00000000000000
      00000000FF000000FF00000000000000FF000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000FF0000000000000000000000
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000FF000000FF000000FF00000000000000
      00000000FF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000FF0000000000000000000000FF000000FF000000FF000000
      00000000FF000000FF000000FF000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000FF00000000000000FF000000FF000000FF00000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      000000800000008000000080000000000000000000000000FF000000FF000080
      0000008000000000FF000000FF00008000000000FF0000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000080000000000000000000000000FF00000000000000
      00000000FF0000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000FF000000FF000000FF0000000000000000000000FF000000
      FF00000000000000FF000080000000000000000000000000FF00000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      00000000FF000000FF00000000000000FF0000000000000000000000FF000000
      FF00000000000000FF00008000000000FF000000000000800000000000000000
      00000000FF000000000000000000000000000000FF00000000000000FF000000
      0000000000000000FF000080000000000000000000000000FF00000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      FF00000000000000FF00000000000000FF00000000000000FF00000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      FF0000000000000000000000FF000000FF00000000000000FF00000000000000
      00000000FF000000FF00008000000000FF000000000000800000000000000000
      00000000000000000000000000000000FF0000000000000000000000FF000000
      0000000000000000FF000080000000000000000000000000FF00000000000000
      00000000FF0000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      FF00000000000000FF00000000000000FF00000000000000FF00000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      FF000000000000000000000000000000FF00000000000000FF00000000000000
      0000000000000000FF00008000000000FF000000000000800000000000000000
      0000000000000000FF000000FF000000000000000000000000000000FF000000
      0000000000000000FF000080000000000000000000000000FF000000FF000000
      0000000000000000FF000000FF00000000000000FF0000000000000000000000
      00000000000000000000008000000000000000000000000000000000FF000000
      0000000000000000FF00000000000000FF0000000000000000000000FF000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      FF000000000000000000000000000000FF0000000000000000000000FF000000
      FF000000FF000000FF00008000000000FF000000000000800000000000000000
      00000000FF000000000000000000000000000000FF00000000000000FF000000
      0000000000000000FF000000FF0000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008000000000000000000000000000000000FF000000
      000000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF00000000000000FF000000FF000000000000800000000000000000
      FF0000000000000000000000FF000000FF00000000000000FF00000000000000
      0000000000000000FF00008000000000FF000000000000800000000000000000
      0000000000000000FF000000FF000000FF00000000000000FF000000FF000000
      FF00000000000000FF00008000000000FF00000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      00000000FF000000FF00000000000000FF0000000000000000000000FF000000
      FF000000FF00000000000000FF000000FF000000000000800000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000800000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000008000000000FF000000000000800000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000008000000000FF000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000008000000080
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000000000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      00000000FF000000000000000000000000000000FF0000000000000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      00000000FF000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000FF00008000000000000000000000008000000000FF000000
      FF000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF00008000000000FF000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      FF00000000000000FF00000000000000FF00000000000000FF00000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF000080000000000000000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF00000000000000FF000000
      0000000000000000FF000000FF00000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      FF00000000000000FF00000000000000FF00000000000000FF00000000000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF000080000000000000000000000000FF00000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000FF0000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008000000000000000000000008000000000FF000000
      0000000000000000FF00000000000000FF0000000000000000000000FF000000
      00000000FF00000000000000FF00000000000000000000800000000000000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF000080000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000000000000000000000000000FF00000000000000
      0000000000000000FF0000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008000000000000000000000008000000000FF000000
      000000000000000000000000FF000000000000000000000000000000FF000000
      00000000FF00000000000000FF000000FF000000000000800000000000000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF000000FF0000000000000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF00000000000000FF000000
      0000000000000000FF000000FF00000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      FF000000FF000000FF0000000000000000000000FF000000FF000000FF000000
      0000000000000000FF00008000000000FF0000000000008000000000FF000000
      FF000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000FF00008000000000FF000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000800000000000000000000000800000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000800000008000000080
      0000008000000080000000800000008000000080000000800000008000000080
      0000008000000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF00F87F000000000000FFBF000000000000
      CCBF000000000000DB3F000000000000DBBF000000000000DBBF000000000000
      DB3F000000000000CCBF000000000000DFFF000000000000DFFF000000000000
      CFFF00000000000087FF00000000000087FF000000000000CFFF000000000000
      FFFF000000000000FFFF000000000000FFFFFFFDFFFFFFFFFFFFE375FFFFFFFF
      EE37DDACCB29FFFFEDD7DFDDB2CBE32FEDD7C1DDBAEBDD6FEDD7DDACBB0BFB6F
      EDD3E375B2EBE76FC635FFFFCB11DD67EFFFFFFFFBFBE22BF7FFFFFFFBFBFF7F
      CFFFCFFFCFFFCF7F87FF87FF87FF87FF87FF87FF87FF87FFCFFFCFFFCFFFCFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFF800180018001FFFF
      BFFDBFFDB67DF775BFFDB8C9B77DF775B2C8B759B77DEAB5ACB0BED9B67DEAB5
      AEB8B9D9997DDAD5AEC0B759BFFDDDD4ACB8B888BFFDFFFFB2C4BFDDBFFDFFF7
      BEFCBFDDBFFDCFFFBEFCBFFDBFFD87FFBFFDBFFDBFFD87FFBFFDBFFDBFFDCFFF
      800180018001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8001800180018001
      BFFDBFFDBFFDBFFDBFFDBFFDBFFDBFF9BFFDB775BFFDBFF9BFFDB775B71986E8
      BFFDAAB5B6E9BB59BFFDAAB5B6E9BFB9BFFD9AD5B6E983B9BFFD9DD4B6E9BB59
      BFFDBFFDA31886E8BFFDBFF5B7FDBFFDBFFDBFFDBBFDBFFDBFFDBFFDBFFDBFFD
      8001800180018001FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList12: TImageList
    Left = 180
    Top = 162
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080808000808080008080
      80008080800000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000808080008080
      80008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000000000
      00008080800080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      00000000000080808000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      00008080800000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      80000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080800000808000008080000080800000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808000008080000000000000000000000000000000000000000000008080
      0000808000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC0008080800080808000808080008080
      800080808000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000008080000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      00000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000808080008080800080808000808080008080
      80008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000080800000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      80000000000000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000808080008080800080808000808080008080
      80008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000080800000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000808080008080800080808000808080008080
      80008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000808000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000808080008080800080808000808080008080
      80008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000808000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      80008080800000000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000808080008080800080808000808080008080
      80008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008000
      0000808080008080800080808000808080008000000080000000808080008000
      0000808080008000000000000000808000000000000000000000808080008000
      0000808080008080800080808000808080008000000080000000808080008000
      00008080800080000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC0008080800080808000C0DCC000C0DCC000C0DC
      C0008080800080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808080008000
      0000808080008080800080808000800000008080800080808000800000008000
      0000808080008000000000000000808000000000000000000000808080008000
      0000808080008080800080808000800000008080800080808000800000008000
      0000808080008000000000000000F0FBFF0000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC00080808000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC00080808000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000800000008080
      8000800000008080800080808000800000008080800080808000808080008000
      0000808080008000000000000000808000000000000000000000800000008080
      8000800000008080800080808000800000008080800080808000808080008000
      00008080800080000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC00080808000C0DCC000C0DCC000C0DC
      C00080808000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808000008080
      8000800000008080800080808000808080008000000080000000800000008000
      0000808080008000000080800000000000000000000000000000800000008080
      8000800000008080800080808000808080008000000080000000800000008000
      00008080800080000000000000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC00080808000808080008080
      8000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000808000008080
      8000808080008000000000000000800000000000000000000000808080008000
      0000808080008000000080800000000000000000000080000000808080008080
      8000808080008000000000000000800000000000000000000000808080008000
      00008080800080000000800000000000000000000000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DCC000C0DC
      C000C0DCC000C0DCC000C0DCC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000808080008080
      0000000000008000000000000000000000008000000080000000800000000000
      0000808080008080000000000000800000000000000080000000808080000000
      0000000000008000000000000000000000008000000080000000800000000000
      0000808080008000000000000000800000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808000008080000000000000000000000000000000000000808080008080
      0000808000000000000000000000F0FBFF000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000808080008080
      8000000000000000000000000000F0FBFF000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080800000808000008080000080800000808000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF8FFFFF00000000FF07800100000000
      FE03800100000000FE03800100000000FE03800100000000FE03800100000000
      FE03800100000000FE73800100000000C08B800100000000BF77800100000000
      B68B800100000000B29B800100000000BFFB800100000000C007800100000000
      FFFF800100000000FFFFFFFF00000000FC1FFFFFFF8FFFFFF3E7FFFF8001FFFF
      E83BF83F8001FFFFC00DE00F8001FFFFC005C0078001FFFF8006C0078001FFFF
      8006C0078001FFFF8002C0038001FFFF8002C0028001C0078002C0038001BFFB
      C001C0038001B6AB82C182C18001B28B8B129B128001BFFBE3C6E7CE8001C007
      F81FF83F8001FFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageList13: TImageList
    Left = 65
    Top = 100
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000008000
      0000800000008000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000800000000000FF000000
      00000000000000000000000000000000FF000000FF00000000000000FF000000
      00000000FF000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000800000000000FF000000
      000000000000000000000000FF0080000000800000000000FF000000FF000000
      00000000FF000000000080000000000000000000000080000000000000000000
      0000000000000000000080000000000000008000000000000000000000000000
      000080000000000000000000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF00FFFFFF00FFFFFF000000FF000000FF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      FF0000000000000000000000FF008000000080000000000000000000FF000000
      00000000FF000000000080000000000000000000000080000000000000000000
      0000000000008000000000000000000000008000000000000000000000000000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF00FF0000000000FF000000FF000000FF000000FF00FF000000FF000000FFFF
      FF00FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      FF000000000000000000000000000000FF000000FF000000FF000000FF000000
      00000000FF000000000080000000000000000000000080000000000000000000
      0000000000008000000000000000000000008000000000000000000000000000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      FF00FF0000000000FF000000FF000000FF00FF0000000000FF00FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0080000000000000000000
      00000000FF00000000000000FF008000000080000000000000000000FF000000
      00000000FF000000FF0080000000000000000000000080000000000000000000
      0000800000000000000000000000000000008000000000000000000000000000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FF00
      00000000FF00FF0000000000FF000000FF00FF0000000000FF00FFFFFF00FFFF
      FF00FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0080000000000000000000
      00000000FF0000000000000000000000FF000000FF000000FF00000000000000
      00000000FF00000000000000FF00000000000000000080000000800000008000
      0000800000008000000000000000000000008000000000000000000000000000
      000080000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FF00
      00000000FF00FF0000000000FF000000FF000000FF00FF000000FF000000FF00
      0000FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000000000000080000000000000000000000080000000000000000000
      0000000000000000000080000000000000008000000080000000800000008000
      000000000000000000000000000000000000FFFFFF00FFFFFF000000FF00FF00
      00000000FF00FF0000000000FF000000FF000000FF000000FF000000FF000000
      FF00FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000080000000800000008000000000000000000000000000
      0000000000000000000080000000000000000000000080000000000000000000
      0000000000000000000080000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FF0000000000
      FF000000FF000000FF00FF000000FFFFFF00FF0000000000FF000000FF000000
      FF00FF000000FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      000000000000F0FBFF0080000000F0FBFF000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FF0000000000
      FF000000FF00FFFFFF00FF000000FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF000000000000000000FFFFFF00FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF00F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F0FBFF00F0FBFF00F0FBFF00FFFFFF00FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFF9FF900000009FFFFFFF00000000
      A00FFFFF00000000BE61FFFF00000000BE7DFFFF000000009E55FFFF00000000
      9C15BD7700000000AC55BB7700000000AE15BB77000000003451B77700000000
      3635837700000000BE7DBD0F00000000807DBDFF00000000BC0883FF00000000
      FFE0FFFB00010000FFF8FFF80001000000000000000000000000000000000000
      000000000000}
  end
  object ImageList14: TImageList
    Left = 94
    Top = 100
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF00009FFFFFFFFFEF0000
      A00FFFFFDFCF0000BE61FFFFCFCF0000BE7DFFFFCF8F00009E55FFFFC70F0000
      9C15BD77C31F0000AC55BB77E0160000AE15BB77E02600003451B777E0360000
      36358377E0060000BE7DBD0FC0060000807DBDFFC1060000BC0D83FFC58E0000
      FFE1FFFFCFFF0000FFFFFFFFDFFF000000000000000000000000000000000000
      000000000000}
  end
  object ImageList15: TImageList
    Left = 8
    Top = 100
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000F0FBFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF00009FFFFFEFFFFF0000
      A00FDFCF9F9F0000BE61CFCF9F9F0000BE7DCF8F9F9F0000BE7DC70F9F9F0000
      BE7DC31F9F9F0000BE7DE01F801F0000BE7DE03F801F0000BE7DF03F9F9F0000
      BE7DE00F9F9F0000BE7DC00F9F9F0000807DC30F9F9F0000BC0DC78F9F9E0000
      FFE1CFFFFFFF0000FFFFDFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu3: TPopupMenu
    Left = 412
    Top = 122
  end
end
