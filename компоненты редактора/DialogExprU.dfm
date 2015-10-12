object DialogExpr: TDialogExpr
  Left = 281
  Top = 132
  BorderStyle = bsDialog
  Caption = #1047#1072#1084#1077#1085#1072' '#1074' '#1074#1099#1088#1072#1078#1077#1085#1080#1103#1093
  ClientHeight = 108
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 329
    Height = 57
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 40
    Top = 80
    Width = 89
    Height = 25
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 136
    Top = 80
    Width = 89
    Height = 25
    Caption = #1047#1072#1084#1077#1085#1103#1090#1100' '#1074#1089#1077
    ModalResult = 1
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 234
    Top = 80
    Width = 87
    Height = 25
    Caption = #1053#1077' '#1079#1072#1084#1077#1085#1103#1090#1100
    ModalResult = 7
    TabOrder = 1
  end
end
