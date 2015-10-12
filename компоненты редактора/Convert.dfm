object FormConvert: TFormConvert
  Left = 349
  Top = 211
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1050#1086#1085#1074#1077#1088#1090#1072#1094#1080#1103
  ClientHeight = 100
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1086#1077
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 69
    Height = 13
    Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086#1077
  end
  object Button1: TButton
    Left = 112
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 120
    Top = 8
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'ComboBox1'
  end
  object ComboBox2: TComboBox
    Left = 120
    Top = 32
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'ComboBox2'
  end
end
