object TrackBEditorFrm: TTrackBEditorFrm
  Left = 351
  Top = 235
  Width = 346
  Height = 171
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
    Height = 129
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
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
      Top = 50
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
      Top = 77
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
      Top = 104
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
    object Edit2: TEdit
      Left = 88
      Top = 41
      Width = 121
      Height = 24
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit3: TEdit
      Left = 88
      Top = 68
      Width = 121
      Height = 24
      TabOrder = 1
      Text = 'Edit1'
    end
    object SpinEdit1: TSpinEdit
      Left = 88
      Top = 96
      Width = 121
      Height = 26
      Increment = 1000
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object Edit1: TEditExpr
      Left = 88
      Top = 14
      Width = 121
      Height = 21
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = 'Edit1'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
end
