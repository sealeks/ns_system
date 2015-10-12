object FormReRegist: TFormReRegist
  Left = 649
  Top = 338
  BorderStyle = bsDialog
  Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 147
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 45
    Width = 77
    Height = 13
    Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object Label3: TLabel
    Left = 18
    Top = 69
    Width = 73
    Height = 13
    Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object Label4: TLabel
    Left = 19
    Top = 92
    Width = 81
    Height = 13
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
  end
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 76
    Height = 13
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
  end
  object Label5: TLabel
    Left = 112
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Label5'
  end
  object Edit1: TEdit
    Left = 104
    Top = 40
    Width = 173
    Height = 21
    AutoSelect = False
    PasswordChar = '*'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 124
    Top = 119
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 204
    Top = 119
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 104
    Top = 88
    Width = 173
    Height = 21
    AutoSelect = False
    PasswordChar = '*'
    TabOrder = 1
  end
  object Edit3: TEdit
    Left = 104
    Top = 64
    Width = 173
    Height = 21
    AutoSelect = False
    PasswordChar = '*'
    TabOrder = 2
  end
end
