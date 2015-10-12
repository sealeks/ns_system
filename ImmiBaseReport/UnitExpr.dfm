object FormExpr: TFormExpr
  Left = 211
  Top = 317
  Width = 589
  Height = 458
  BorderStyle = bsSizeToolWin
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1085#1072#1095#1077#1085#1080#1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    581
    431)
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 3
    Top = 56
    Width = 574
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clSilver
    ColCount = 3
    DefaultColWidth = 40
    DefaultRowHeight = 16
    FixedColor = clScrollBar
    RowCount = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing]
    ParentFont = False
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      40
      93
      293)
  end
  object Button1: TButton
    Left = 413
    Top = 402
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 499
    Top = 402
    Width = 79
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 48
    Top = 32
    Width = 89
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
    OnSelect = ComboBox1Select
  end
  object ComboBox2: TComboBox
    Left = 144
    Top = 32
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'ComboBox1'
    OnSelect = ComboBox2Select
  end
  object memo1: TEditExpr
    Left = 8
    Top = 8
    Width = 569
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = False
  end
end
