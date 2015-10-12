object EditpanelFr: TEditpanelFr
  Left = 243
  Top = 168
  BorderStyle = bsDialog
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1087#1072#1085#1077#1083#1080
  ClientHeight = 74
  ClientWidth = 294
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
    Top = 22
    Width = 59
    Height = 13
    Caption = #1040#1082#1090#1080#1074#1085#1086#1089#1090#1100
  end
  object Label2: TLabel
    Left = 8
    Top = 46
    Width = 56
    Height = 13
    Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
  end
  object Edit1: TEditExpr
    Left = 72
    Top = 16
    Width = 121
    Height = 23
    Color = 15925234
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = 'Edit1'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object Edit2: TEditExpr
    Left = 72
    Top = 40
    Width = 121
    Height = 23
    Color = 15925234
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Text = 'Edit2'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object Button1: TButton
    Left = 208
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1082
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 208
    Top = 38
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
