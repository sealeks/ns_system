inherited TimersForm: TTimersForm
  Left = 629
  Top = 347
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1058#1072#1081#1084#1077#1088#1099
  ClientHeight = 247
  ClientWidth = 457
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel5: TBevel
    Left = 333
    Top = 33
    Width = 81
    Height = 28
    Shape = bsFrame
    Style = bsRaised
  end
  object Bevel4: TBevel
    Left = 224
    Top = 33
    Width = 111
    Height = 28
    Shape = bsFrame
    Style = bsRaised
  end
  object Bevel3: TBevel
    Left = 333
    Top = 7
    Width = 81
    Height = 28
    Shape = bsFrame
    Style = bsRaised
  end
  object Bevel2: TBevel
    Left = 224
    Top = 7
    Width = 111
    Height = 28
    Shape = bsFrame
    Style = bsRaised
  end
  object Bevel1: TBevel
    Left = 3
    Top = 2
    Width = 174
    Height = 67
    Shape = bsFrame
    Style = bsRaised
  end
  object Label1: TLabel
    Left = 9
    Top = 14
    Width = 39
    Height = 16
    Caption = #1050#1086#1090#1077#1083
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 41
    Width = 54
    Height = 16
    Caption = #1043#1086#1088#1077#1083#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 231
    Top = 38
    Width = 40
    Height = 16
    Caption = #1055#1091#1089#1090#1086
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 424
    Top = 56
    Width = 3
    Height = 13
  end
  object IMMILabelFull1: TIMMILabelFull
    Left = 349
    Top = 38
    Width = 32
    Height = 16
    Caption = '%6.2f'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    iColorOn = clBlack
    iColorOff = clBlack
    iBounds.iAccess = 4000
    isGraphic = False
  end
  object IMMIValueEntry1: TIMMIValueEntry
    Left = 344
    Top = 36
    Width = 57
    Height = 21
    Cursor = crHandPoint
    iparam.Access = 4000
    iparam.maxValue = 100
    iparam.format = '%.2f'
  end
  object Label5: TLabel
    Left = 230
    Top = 12
    Width = 57
    Height = 16
    Caption = #1058#1072#1081#1084#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 336
    Top = 12
    Width = 74
    Height = 16
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object seKotel: TSpinEdit
    Left = 65
    Top = 8
    Width = 41
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 0
    Value = 0
  end
  object seGorelka: TSpinEdit
    Left = 65
    Top = 37
    Width = 41
    Height = 26
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 1
    Value = 0
  end
  object SYButton1: TSYButton
    Left = 112
    Top = 8
    Width = 57
    Height = 25
    Color = 9737289
    Caption = #1060#1080#1083#1100#1090#1088
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 2
    OnClick = SYButton1Click
  end
  object SYButton2: TSYButton
    Left = 112
    Top = 37
    Width = 57
    Height = 25
    Color = 9737289
    Caption = #1054#1090#1082#1083'.'
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 3
    OnClick = SYButton2Click
  end
  object IMMIGrid1: TIMMIGrid
    Left = 1
    Top = 72
    Width = 456
    Height = 174
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 9
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 4
    OnSelectCell = IMMIGrid1SelectCell
    ColWidths = (
      92
      54
      287)
  end
  object DataSource1: TDataSource
    DataSet = QuerySet
    Left = 24
    Top = 200
  end
  object QuerySet: TQuery
    DatabaseName = 'MyLogika'
    SQL.Strings = (
      'SELECT name FROM ddeitem WHERE name LIKE "%tm%"')
    Left = 56
    Top = 200
    object QuerySetname: TStringField
      FieldName = 'name'
      Origin = 'MYLOGIKA."ddeitem.DB".Name'
      Size = 50
    end
  end
end
