object EditEditorFrm: TEditEditorFrm
  Left = 352
  Top = 236
  Width = 344
  Height = 203
  Caption = #1042#1074#1086#1076' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 248
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 248
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 14
    Top = 8
    Width = 217
    Height = 153
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 20
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
    object Label3: TLabel
      Left = 8
      Top = 74
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
      Top = 101
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
      Left = 8
      Top = 47
      Width = 37
      Height = 14
      Caption = #1060#1086#1088#1084#1072#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      ParentFont = False
    end
    object Edit3: TEdit
      Left = 88
      Top = 65
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
    object Edit4: TEdit
      Left = 88
      Top = 92
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object SpinEdit1: TSpinEdit
      Left = 88
      Top = 120
      Width = 121
      Height = 22
      Increment = 1000
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object Edit2: TEdit
      Left = 88
      Top = 38
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit2'
    end
    object Edit1: TEditExpr
      Left = 88
      Top = 13
      Width = 121
      Height = 21
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = 'Edit1'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object CheckBox1: TCheckBox
    Left = 248
    Top = 96
    Width = 65
    Height = 17
    Caption = #1044#1080#1072#1083#1086#1075
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
end
