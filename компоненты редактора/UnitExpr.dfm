object FormExpr: TFormExpr
  Left = 284
  Top = 564
  Width = 571
  Height = 346
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
    563
    320)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton2: TSpeedButton
    Left = 8
    Top = 88
    Width = 49
    Height = 25
    Caption = '('
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 64
    Top = 88
    Width = 49
    Height = 25
    Caption = ')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton3Click
  end
  object SpeedButton1: TSpeedButton
    Left = 120
    Top = 88
    Width = 49
    Height = 25
    Caption = 'not'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton4: TSpeedButton
    Left = 176
    Top = 88
    Width = 49
    Height = 25
    Caption = 'or'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton4Click
  end
  object SpeedButton5: TSpeedButton
    Left = 232
    Top = 88
    Width = 49
    Height = 25
    Caption = 'and'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton5Click
  end
  object SpeedButton6: TSpeedButton
    Left = 288
    Top = 88
    Width = 65
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton6Click
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 152
    Width = 551
    Height = 118
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    DefaultColWidth = 40
    DefaultRowHeight = 18
    RowCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing]
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
    ColWidths = (
      40
      93
      412)
  end
  object Button1: TButton
    Left = 390
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 486
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 40
    Top = 128
    Width = 97
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
    OnSelect = ComboBox1Select
  end
  object ComboBox2: TComboBox
    Left = 144
    Top = 128
    Width = 414
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'ComboBox1'
    OnSelect = ComboBox2Select
  end
  object Memo1: TEditExpr
    Left = 8
    Top = 8
    Width = 545
    Height = 21
    TabOrder = 5
    Text = 'Memo1'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
  end
end
