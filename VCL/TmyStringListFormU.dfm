object myStringList: TmyStringList
  Left = 192
  Top = 107
  Width = 328
  Height = 401
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1089#1087#1080#1089#1082#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    320
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object Mnemo: TMemo
    Left = 0
    Top = 0
    Width = 320
    Height = 333
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Mnemo')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 159
    Top = 341
    Width = 75
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 239
    Top = 341
    Width = 75
    Height = 27
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
end
