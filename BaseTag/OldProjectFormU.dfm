object OldProjectForm: TOldProjectForm
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1088#1086#1077#1082#1090#1072' '
  ClientHeight = 135
  ClientWidth = 441
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
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = #1055#1091#1090#1100' dbdata'
  end
  object SpeedButton2: TSpeedButton
    Left = 400
    Top = 24
    Width = 23
    Height = 22
    OnClick = SpeedButton2Click
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 55
    Height = 13
    Caption = #1055#1091#1090#1100' Forms'
  end
  object SpeedButton3: TSpeedButton
    Left = 400
    Top = 64
    Width = 23
    Height = 22
    OnClick = SpeedButton3Click
  end
  object Edit2: TEdit
    Left = 8
    Top = 24
    Width = 385
    Height = 21
    TabOrder = 0
  end
  object Edit3: TEdit
    Left = 8
    Top = 64
    Width = 385
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 267
    Top = 99
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 348
    Top = 99
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
