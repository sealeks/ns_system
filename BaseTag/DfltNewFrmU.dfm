object dfltNewFrm: TdfltNewFrm
  Left = 288
  Top = 146
  Width = 447
  Height = 387
  Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1076#1083#1103' '#1085#1086#1074#1099#1093' '#1090#1077#1075#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 35
    Height = 13
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object Button1: TButton
    Left = 240
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 56
    Width = 417
    Height = 145
    Caption = #1053#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1100
    TabOrder = 1
    object CheckBox1: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = #1053#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1100
      TabOrder = 0
    end
    object RadioGroup1: TRadioGroup
      Left = 16
      Top = 49
      Width = 185
      Height = 72
      Caption = #1058#1080#1087
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        #1053#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1100
        #1040#1074#1072#1088#1080#1103)
      ParentFont = False
      TabOrder = 1
    end
    object GroupBox2: TGroupBox
      Left = 224
      Top = 48
      Width = 177
      Height = 73
      Caption = #1059#1089#1083#1086#1074#1080#1077' '
      TabOrder = 2
      object ComboBox1: TComboBox
        Left = 8
        Top = 32
        Width = 49
        Height = 21
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = '<'
        Items.Strings = (
          '>'
          '<')
      end
      object Edit1: TEdit
        Left = 72
        Top = 32
        Width = 89
        Height = 21
        TabOrder = 1
        Text = '0'
      end
    end
  end
  object Button2: TButton
    Left = 328
    Top = 16
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 216
    Width = 417
    Height = 129
    Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1085#1080#1103' '
    TabOrder = 3
    object Label7: TLabel
      Left = 16
      Top = 60
      Width = 39
      Height = 13
      Caption = 'MinRaw'
    end
    object Label8: TLabel
      Left = 17
      Top = 92
      Width = 42
      Height = 13
      Caption = 'MaxRaw'
    end
    object Label9: TLabel
      Left = 224
      Top = 60
      Width = 32
      Height = 13
      Caption = 'MinEU'
    end
    object Label10: TLabel
      Left = 225
      Top = 92
      Width = 35
      Height = 13
      Caption = 'MaxEU'
    end
    object Edit2: TEdit
      Left = 72
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object Edit3: TEdit
      Left = 72
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '1'
    end
    object Edit4: TEdit
      Left = 272
      Top = 56
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object Edit5: TEdit
      Left = 272
      Top = 88
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '1'
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 24
      Width = 57
      Height = 17
      Caption = 'BCD'
      TabOrder = 4
      OnClick = CheckBox2Click
    end
  end
  object DBLookupComboBox2: TDBLookupComboBox
    Left = 62
    Top = 16
    Width = 145
    Height = 21
    KeyField = 'DDEGroup'
    ListField = 'DDEGroup'
    ListSource = Dm1.dsDDEGroup
    TabOrder = 4
  end
end
