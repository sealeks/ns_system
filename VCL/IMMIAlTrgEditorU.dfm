object AlTrgFrm: TAlTrgFrm
  Left = 192
  Top = 110
  Width = 429
  Height = 171
  Caption = #1058#1088#1077#1074#1086#1078#1085#1099#1081' '#1090#1088#1077#1091#1075#1086#1083#1100#1085#1080#1082
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
    Top = 32
    Width = 51
    Height = 13
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 64
    Width = 185
    Height = 65
    Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    ItemIndex = 0
    Items.Strings = (
      #1042#1074#1077#1088#1093
      #1042#1085#1080#1079)
    TabOrder = 0
  end
  object RadioGroup2: TRadioGroup
    Left = 224
    Top = 64
    Width = 185
    Height = 65
    Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
    ItemIndex = 0
    Items.Strings = (
      #1053#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1100
      #1040#1074#1072#1088#1080#1103)
    TabOrder = 1
  end
  object Button2: TButton
    Left = 320
    Top = 16
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object Button1: TButton
    Left = 232
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Edit1: TEditExpr
    Left = 72
    Top = 24
    Width = 137
    Height = 23
    Color = 15925234
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
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
