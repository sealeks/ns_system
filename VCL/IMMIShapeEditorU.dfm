object ShapeEditorFrm: TShapeEditorFrm
  Left = 297
  Top = 225
  Width = 452
  Height = 283
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1092#1080#1075#1091#1088#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 16
    Top = 83
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
  object Label1: TLabel
    Left = 16
    Top = 56
    Width = 37
    Height = 14
    Caption = #1047#1072#1083#1080#1074#1082#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 16
    Top = 139
    Width = 44
    Height = 14
    Caption = #1058#1086#1083#1097#1080#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 16
    Top = 163
    Width = 23
    Height = 14
    Caption = #1062#1074#1077#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 20
    Top = 112
    Width = 33
    Height = 13
    Caption = #1050#1072#1081#1084#1072
  end
  object Button1: TButton
    Left = 284
    Top = 223
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 364
    Top = 223
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object GroupBox1: TGroupBox
    Left = 224
    Top = 8
    Width = 217
    Height = 161
    Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' %'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 52
      Width = 35
      Height = 14
      Caption = #1042#1099#1088#1072#1078'.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 8
      Top = 24
      Width = 23
      Height = 14
      Caption = #1062#1074#1077#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 81
      Width = 25
      Height = 14
      Caption = #1052#1080#1085'.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 110
      Width = 28
      Height = 14
      Caption = #1052#1072#1082#1089'.'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 136
      Width = 62
      Height = 14
      Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    end
    object ColorBox2: TColorBox
      Left = 88
      Top = 16
      Width = 120
      Height = 22
      DefaultColorColor = clGreen
      Selected = clGreen
      ItemHeight = 16
      TabOrder = 0
    end
    object Edit3: TEdit
      Left = 88
      Top = 71
      Width = 121
      Height = 22
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit4: TEdit
      Left = 88
      Top = 98
      Width = 121
      Height = 22
      TabOrder = 2
      Text = 'Edit1'
    end
    object ComboBox2: TComboBox
      Left = 88
      Top = 126
      Width = 121
      Height = 22
      ItemHeight = 14
      TabOrder = 3
      Text = 'ComboBox1'
      Items.Strings = (
        #1042#1074#1077#1088#1093
        #1042#1085#1080#1079
        #1042#1083#1077#1074#1086
        #1042#1087#1088#1072#1074#1086)
    end
    object Edit2: TEditExpr
      Left = 88
      Top = 45
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = 'Edit2'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object ColorBox1: TColorBox
    Left = 88
    Top = 48
    Width = 119
    Height = 22
    DefaultColorColor = clWhite
    Selected = clWhite
    ItemHeight = 16
    TabOrder = 1
    OnChange = ColorBox1Change
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 16
    Width = 189
    Height = 19
    Style = csOwnerDrawVariable
    ItemHeight = 13
    TabOrder = 0
    OnChange = ColorBox1Change
    Items.Strings = (
      #1055#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082
      #1050#1074#1072#1076#1088#1072#1090
      #1057#1082#1088#1091#1075#1083#1077#1085#1085#1099#1077' '#1087#1088#1103#1084#1086#1091#1075#1086#1083#1100#1085#1080#1082
      #1057#1082#1088#1091#1075#1083#1077#1085#1085#1099#1081' '#1082#1074#1072#1076#1088#1072#1090
      #1069#1083#1080#1087#1089
      #1050#1088#1091#1075)
  end
  object Edit1: TEditExpr
    Left = 87
    Top = 76
    Width = 121
    Height = 23
    Color = 15925234
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    Text = 'Edit1'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object SpinEdit1: TSpinEdit
    Left = 93
    Top = 134
    Width = 114
    Height = 22
    MaxValue = 50
    MinValue = 0
    TabOrder = 6
    Value = 0
    OnChange = ColorBox1Change
  end
  object Button3: TButton
    Left = 93
    Top = 160
    Width = 113
    Height = 25
    Caption = #1062#1074#1077#1090
    TabOrder = 7
    OnClick = Button3Click
  end
  object Panel1: TPanel
    Left = 20
    Top = 197
    Width = 121
    Height = 49
    TabOrder = 8
    object Shape1: TShape
      Left = 40
      Top = 3
      Width = 49
      Height = 41
    end
  end
  object ColorDialog1: TColorDialog
    Left = 168
    Top = 208
  end
end
