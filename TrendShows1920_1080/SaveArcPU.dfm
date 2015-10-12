object SaveArcP: TSaveArcP
  Left = 178
  Top = 255
  Width = 539
  Height = 129
  Caption = 'SaveArcP'
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
    Top = 8
    Width = 177
    Height = 16
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 16
    Top = 32
    Width = 505
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 360
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 448
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 7
    TabOrder = 2
  end
end
