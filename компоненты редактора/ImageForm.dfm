object Form18: TForm18
  Left = 556
  Top = 250
  Width = 361
  Height = 299
  Caption = 'Form18'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 351
    Height = 200
    Align = alTop
    BorderStyle = bsSingle
    Caption = 'Panel1'
    TabOrder = 0
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 345
      Height = 194
      Align = alClient
      AutoSize = True
      Center = True
    end
  end
  object Button1: TButton
    Left = 8
    Top = 232
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 232
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 272
    Top = 232
    Width = 75
    Height = 25
    Caption = #1048#1079' '#1092#1072#1081#1083#1072
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 184
    Top = 232
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 4
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 184
    Top = 208
    Width = 161
    Height = 17
    Alignment = taLeftJustify
    BiDiMode = bdLeftToRight
    Caption = #1055#1088#1080#1089#1074#1086#1080#1090#1100' '#1088#1080#1089#1091#1085#1086#1082' '#1087#1088#1086#1077#1082#1090#1072
    ParentBiDiMode = False
    TabOrder = 5
    OnClick = CheckBox1Click
  end
end
