object IMMITubeForm: TIMMITubeForm
  Left = 792
  Top = 321
  Width = 388
  Height = 252
  Caption = #1058#1088#1091#1073#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 59
    Height = 13
    Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
  end
  object Label4: TLabel
    Left = 16
    Top = 56
    Width = 61
    Height = 13
    Caption = #1054#1088#1080#1077#1085#1090#1072#1094#1080#1103
  end
  object Button2: TButton
    Left = 280
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 80
    Width = 161
    Height = 129
    Caption = #1050#1072#1088#1090#1080#1085#1082#1072
    TabOrder = 1
    object Bevel2: TBevel
      Left = 16
      Top = 88
      Width = 89
      Height = 25
    end
    object Bevel1: TBevel
      Left = 16
      Top = 40
      Width = 89
      Height = 25
    end
    object Label2: TLabel
      Left = 40
      Top = 24
      Width = 45
      Height = 13
      Caption = #1048#1057#1058#1048#1053#1040
    end
    object Label3: TLabel
      Left = 48
      Top = 72
      Width = 34
      Height = 13
      Caption = #1051#1054#1046#1068
    end
    object PaintBox1: TPaintBox
      Left = 16
      Top = 40
      Width = 89
      Height = 25
      OnClick = PaintBox1Click
    end
    object PaintBox2: TPaintBox
      Left = 16
      Top = 88
      Width = 89
      Height = 25
      OnClick = PaintBox2Click
    end
    object Button3: TButton
      Left = 112
      Top = 40
      Width = 25
      Height = 25
      Caption = #173#1031
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Symbol'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 120
      Top = 88
      Width = 25
      Height = 25
      Caption = #173#1031
      Font.Charset = SYMBOL_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Symbol'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button4Click
    end
  end
  object ComboBox1: TComboBox
    Left = 85
    Top = 48
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'ComboBox1'
    Items.Strings = (
      #1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1086
      #1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1086)
  end
  object GroupBox2: TGroupBox
    Left = 200
    Top = 80
    Width = 161
    Height = 129
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1103
    TabOrder = 3
    object ComboBox3: TComboBox
      Left = 8
      Top = 88
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox1'
      Items.Strings = (
        #1056#1086#1074#1085#1086
        #1042#1085#1080#1079'/'#1042#1087#1088#1072#1074#1086
        #1042#1074#1077#1088#1093'/'#1042#1083#1077#1074#1086)
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 40
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'ComboBox1'
      Items.Strings = (
        #1056#1086#1074#1085#1086
        #1042#1085#1080#1079'/'#1042#1087#1088#1072#1074#1086
        #1042#1074#1077#1088#1093'/'#1042#1083#1077#1074#1086)
    end
  end
  object Button1: TButton
    Left = 280
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object Edit1: TEditExpr
    Left = 80
    Top = 16
    Width = 185
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
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 176
  end
end
