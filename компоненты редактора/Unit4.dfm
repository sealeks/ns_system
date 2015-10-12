object Form4: TForm4
  Left = 190
  Top = 159
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1072#1082#1090#1086#1088' '#1082#1072#1088#1090#1080#1085#1086#1082
  ClientHeight = 238
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 358
    Height = 200
    Align = alTop
    BorderStyle = bsSingle
    Caption = 'Panel1'
    TabOrder = 0
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 352
      Height = 194
      Align = alClient
      AutoSize = True
      Center = True
    end
  end
  object Button1: TButton
    Left = 8
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 208
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 272
    Top = 208
    Width = 75
    Height = 25
    Caption = #1048#1079' '#1092#1072#1081#1083#1072
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 184
    Top = 208
    Width = 75
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    TabOrder = 4
    OnClick = Button4Click
  end
end
