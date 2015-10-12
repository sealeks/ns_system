object LabelREditorFrm: TLabelREditorFrm
  Left = 1272
  Top = 446
  BorderStyle = bsDialog
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1084#1077#1090#1082#1080
  ClientHeight = 476
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 17
    Width = 28
    Height = 14
    Caption = #1058#1077#1082#1089#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 44
    Width = 54
    Height = 14
    Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 76
    Width = 52
    Height = 14
    Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 186
    Top = 313
    Width = 8
    Height = 14
    Caption = 'X'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 186
    Top = 338
    Width = 8
    Height = 14
    Caption = 'Y'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 148
    Top = 281
    Width = 41
    Height = 14
    Caption = #1055#1086#1079#1080#1094#1080#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 322
    Top = 333
    Width = 38
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object Label17: TLabel
    Left = 17
    Top = 135
    Width = 35
    Height = 14
    Caption = #1053#1072#1082#1083#1086#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 85
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnChange = Edit1Change
  end
  object Edit2: TEditExpr
    Left = 84
    Top = 38
    Width = 122
    Height = 23
    Color = 13828050
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = 'Edit2'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object Edit3: TEditExpr
    Left = 85
    Top = 66
    Width = 121
    Height = 23
    Color = 13828050
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Text = 'Edit3'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 248
    Width = 161
    Height = 17
    Caption = #1055#1088#1080' '#1082#1083#1080#1082#1077' '#1074#1099#1079#1099#1074#1072#1090#1100' '#1086#1082#1085#1086' '
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 5
    Top = 271
    Width = 129
    Height = 79
    Caption = #1054#1082#1085#1086' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    Items.Strings = (
      #1055#1088#1086#1089#1090#1086#1077
      #1043#1088#1072#1092#1080#1082)
    ParentFont = False
    TabOrder = 4
    OnClick = RadioGroup1Click
  end
  object ComboBox1: TComboBox
    Left = 200
    Top = 276
    Width = 110
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 5
    OnChange = ComboBox1Change
    Items.Strings = (
      #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103
      #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103)
  end
  object SpinEdit1: TSpinEdit
    Left = 199
    Top = 307
    Width = 112
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 199
    Top = 333
    Width = 111
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
  object RadioGroup2: TRadioGroup
    Left = 321
    Top = 271
    Width = 106
    Height = 49
    Caption = #1043#1088#1072#1092#1080#1082
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    Items.Strings = (
      #1044#1080#1089#1082#1088'.'
      #1057#1087#1083#1072#1081#1085)
    ParentFont = False
    TabOrder = 8
    OnClick = RadioGroup2Click
  end
  object SpinEdit3: TSpinEdit
    Left = 368
    Top = 330
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 0
    OnChange = SpinEdit3Change
  end
  object Button1: TButton
    Left = 264
    Top = 438
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object Button2: TButton
    Left = 352
    Top = 438
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 11
  end
  object GroupBox2: TGroupBox
    Left = 216
    Top = 5
    Width = 209
    Height = 135
    Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    object Label11: TLabel
      Left = 9
      Top = 80
      Width = 23
      Height = 14
      Caption = #1062#1074#1077#1090
    end
    object Label12: TLabel
      Left = 9
      Top = 48
      Width = 24
      Height = 14
      Caption = #1042#1099#1082#1083
    end
    object Label13: TLabel
      Left = 9
      Top = 24
      Width = 20
      Height = 14
      Caption = #1042#1082#1083'.'
    end
    object Label2: TLabel
      Left = 9
      Top = 108
      Width = 43
      Height = 14
      Caption = #1052#1080#1075#1072#1085#1080#1077
    end
    object ColorBox1: TColorBox
      Left = 84
      Top = 16
      Width = 113
      Height = 22
      DefaultColorColor = clGreen
      Selected = clGreen
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 0
    end
    object ColorBox2: TColorBox
      Left = 84
      Top = 43
      Width = 113
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 1
    end
    object Edit4: TEditExpr
      Left = 81
      Top = 75
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr1: TEditExpr
      Left = 80
      Top = 102
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 358
    Width = 417
    Height = 73
    Caption = #1040#1074#1072#1088#1080#1081#1085#1099#1077' '#1080' '#1087#1088#1077#1076#1091#1087#1088#1077#1076#1080#1090#1077#1083#1100#1085#1099#1077' '#1075#1088#1072#1085#1080#1094#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    object Label5: TLabel
      Left = 28
      Top = 22
      Width = 21
      Height = 14
      Caption = #1042#1040#1043
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 28
      Top = 45
      Width = 21
      Height = 14
      Caption = #1042#1055#1043
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label14: TLabel
      Left = 244
      Top = 21
      Width = 22
      Height = 14
      Caption = #1053#1055#1043
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 245
      Top = 44
      Width = 21
      Height = 14
      Caption = #1042#1055#1043
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object EditExpr2: TEditExpr
      Left = 57
      Top = 18
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr3: TEditExpr
      Left = 272
      Top = 18
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr4: TEditExpr
      Left = 57
      Top = 42
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr5: TEditExpr
      Left = 272
      Top = 42
      Width = 121
      Height = 23
      Color = 13828050
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 104
    Width = 97
    Height = 17
    Caption = #1055#1088#1086#1079#1088#1072#1095#1085#1086#1089#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = CheckBox2Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 157
    Width = 417
    Height = 87
    TabOrder = 15
    object label16: TIMMILabelRotate
      Left = 168
      Top = 8
      Width = 90
      Height = 74
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = True
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
  end
  object Button3: TButton
    Left = 112
    Top = 99
    Width = 49
    Height = 25
    Caption = #1062#1074#1077#1090
    TabOrder = 16
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 165
    Top = 99
    Width = 49
    Height = 25
    Caption = #1064#1088#1080#1092#1090
    TabOrder = 17
    OnClick = Button4Click
  end
  object ComboBox2: TComboBox
    Left = 75
    Top = 130
    Width = 110
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 18
    Text = '0'#39
    OnChange = ComboBox2Change
    Items.Strings = (
      '0'#39
      '45'#39
      '90'#39
      '135'#39
      '180'#39
      '225'#39
      '270'#39
      '315'#39)
  end
  object ColorDialog1: TColorDialog
    Left = 8
    Top = 4
  end
  object ColorDialog2: TColorDialog
    Left = 96
    Top = 149
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 168
    Top = 193
  end
end
