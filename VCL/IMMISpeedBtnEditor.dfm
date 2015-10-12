object SpeedBtnEditorFrm: TSpeedBtnEditorFrm
  Left = 483
  Top = 317
  Width = 340
  Height = 408
  Caption = #1047#1072#1087#1072#1076#1072#1102#1097#1072#1103' '#1082#1085#1086#1087#1082#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 72
    Top = 282
    Width = 249
    Height = 43
    Style = bsRaised
  end
  object Image1: TImage
    Left = 72
    Top = 283
    Width = 249
    Height = 41
    Stretch = True
    OnClick = Image1Click
  end
  object Label8: TLabel
    Left = 18
    Top = 298
    Width = 45
    Height = 14
    Caption = #1050#1072#1088#1090#1080#1085#1082#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 168
    Top = 352
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 248
    Top = 352
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 6
    Top = 8
    Width = 315
    Height = 265
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 47
      Height = 14
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 10
      Top = 128
      Width = 36
      Height = 14
      Caption = #1044#1086#1089#1090#1091#1087
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 9
      Top = 87
      Width = 56
      Height = 14
      Caption = #1040#1082#1090#1080#1074#1085#1086#1089#1090#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 11
      Top = 21
      Width = 70
      Height = 14
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 18
      Top = 208
      Width = 34
      Height = 14
      Caption = #1047#1072#1087#1088#1086#1089
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 19
      Top = 235
      Width = 115
      Height = 14
      Caption = #1059#1089#1090#1072#1085#1086#1074#1086#1095#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 66
      Width = 53
      Height = 14
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088'+'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 9
      Top = 109
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
    object SpinEdit1: TSpinEdit
      Left = 89
      Top = 124
      Width = 217
      Height = 24
      Increment = 1000
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object EditExpr1: TEditExpr
      Left = 89
      Top = 39
      Width = 217
      Height = 21
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr2: TEditExpr
      Left = 89
      Top = 81
      Width = 217
      Height = 21
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object Edit1: TEdit
      Left = 103
      Top = 16
      Width = 202
      Height = 23
      TabOrder = 3
      Text = 'Edit1'
    end
    object CheckBox1: TCheckBox
      Left = 16
      Top = 166
      Width = 97
      Height = 17
      Caption = #1047#1072#1087#1088#1086#1089' '#1087#1072#1088#1086#1083#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object CheckBox2: TCheckBox
      Left = 184
      Top = 166
      Width = 97
      Height = 17
      Caption = #1048#1084#1087#1091#1083#1100#1089#1085#1086
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object CheckBox3: TCheckBox
      Left = 16
      Top = 182
      Width = 97
      Height = 17
      Caption = #1056#1077#1074#1077#1088#1089
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object Edit2: TEdit
      Left = 64
      Top = 203
      Width = 241
      Height = 23
      TabOrder = 7
      Text = 'Edit1'
    end
    object SpinEdit2: TSpinEdit
      Left = 171
      Top = 229
      Width = 135
      Height = 24
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 0
    end
    object EditExpr3: TEditExpr
      Left = 89
      Top = 60
      Width = 217
      Height = 21
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object EditExpr4: TEditExpr
      Left = 89
      Top = 103
      Width = 217
      Height = 21
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object Button3: TButton
    Left = 16
    Top = 328
    Width = 121
    Height = 25
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1086#1082#1085#1072#1084#1080
    TabOrder = 3
    OnClick = Button3Click
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 176
  end
end
