object OperatorReg: TOperatorReg
  Left = 307
  Top = 146
  BorderStyle = bsDialog
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
  ClientHeight = 94
  ClientWidth = 234
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
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 22
    Height = 13
    Caption = #1048#1084#1103
  end
  object Label2: TLabel
    Left = 10
    Top = 37
    Width = 38
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object ComboBox1: TComboBox
    Left = 56
    Top = 8
    Width = 174
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox1Change
  end
  object Edit1: TEdit
    Left = 55
    Top = 32
    Width = 174
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 72
    Top = 64
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 152
    Top = 64
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    ModalResult = 2
    TabOrder = 3
  end
end
