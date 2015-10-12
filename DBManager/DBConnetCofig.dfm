object FormDBConfig: TFormDBConfig
  Left = 447
  Top = 95
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '
  ClientHeight = 166
  ClientWidth = 426
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
  object ValueListEditor1: TValueListEditor
    Left = 0
    Top = 0
    Width = 426
    Height = 121
    Align = alTop
    DisplayOptions = [doAutoColResize, doKeyColFixed]
    Strings.Strings = (
      'Server='
      'DataBase='
      'Schema='
      'Port='
      'User='
      'Password=')
    TabOrder = 0
    ColWidths = (
      150
      270)
  end
  object Button1: TButton
    Left = 8
    Top = 128
    Width = 75
    Height = 25
    Caption = #1058#1077#1089#1090
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 128
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 2
  end
  object Button3: TButton
    Left = 336
    Top = 128
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 121
    TabOrder = 4
    object Label1: TLabel
      Left = 72
      Top = 8
      Width = 264
      Height = 13
      Caption = 'BDE '#1085#1077' '#1080#1084#1077#1077#1090' '#1089#1087#1077#1094#1080#1072#1083#1100#1085#1099#1093' '#1085#1072#1089#1090#1088#1086#1077#1082' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103'.'
    end
    object Label2: TLabel
      Left = 32
      Top = 24
      Width = 360
      Height = 13
      Caption = 
        #1044#1083#1103' '#1088#1072#1073#1086#1090#1099' '#1084#1077#1085#1077#1076#1078#1077#1088#1072' '#1089#1086#1079#1076#1072#1081#1090#1077' '#1073#1072#1079#1099' Alarms '#1080' Trend '#1074' BDEAdministo' +
        'r.'
    end
  end
end
