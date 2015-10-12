object FormNewVar: TFormNewVar
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = #1043#1083#1086#1073#1072#1083#1100#1085#1072#1103' '#1087#1077#1088#1077#1084#1077#1085#1085#1072#1103
  ClientHeight = 116
  ClientWidth = 301
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
    Left = 8
    Top = 3
    Width = 87
    Height = 13
    Caption = #1048#1084#1103' '#1087#1077#1088#1077#1084#1077#1085#1085#1086#1081
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 82
    Height = 13
    Caption = #1090#1080#1087' '#1087#1077#1088#1077#1084#1077#1085#1085#1086#1081
  end
  object Edit1: TEdit
    Left = 8
    Top = 18
    Width = 283
    Height = 21
    TabOrder = 0
    OnChange = Edit1Change
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 60
    Width = 281
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBox1Change
  end
  object Button1: TButton
    Left = 136
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button2Click
  end
end
