object FormTrDfUpdate: TFormTrDfUpdate
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Trenddef'
  ClientHeight = 115
  ClientWidth = 217
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    217
    115)
  PixelsPerInch = 96
  TextHeight = 13
  object rewrite: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = #1055#1077#1088#1077#1079#1072#1087#1080#1089#1072#1090#1100
    TabOrder = 0
  end
  object delold: TCheckBox
    Left = 8
    Top = 28
    Width = 169
    Height = 17
    Caption = #1059#1076#1072#1083#1103#1090#1100' '#1085#1077#1089#1091#1097#1077#1089#1090#1074#1091#1102#1097#1080#1077
    TabOrder = 1
  end
  object Button1: TButton
    Left = 56
    Top = 87
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object Button2: TButton
    Left = 138
    Top = 87
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 55
    Width = 201
    Height = 22
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
  end
end
