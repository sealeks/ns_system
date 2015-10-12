object Form11: TForm11
  Left = 339
  Top = 117
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' / '#1091#1076#1072#1083#1077#1085#1080#1077' '#1092#1086#1088#1084
  ClientHeight = 179
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 135
    Height = 20
    Caption = #1060#1086#1088#1084#1099' '#1087#1088#1086#1077#1082#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 368
    Top = 144
    Width = 23
    Height = 22
    Caption = #1085
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 400
    Top = 144
    Width = 23
    Height = 22
    Caption = #1074
    OnClick = SpeedButton2Click
  end
  object Button2: TButton
    Left = 360
    Top = 40
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 360
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 345
    Height = 137
    ItemHeight = 13
    TabOrder = 2
  end
  object Button1: TButton
    Left = 360
    Top = 72
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 360
    Top = 104
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 4
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Filter = #1060#1072#1081#1083#1099' '#1092#1086#1088#1084'|*.frm'
    Options = [ofHideReadOnly, ofNoChangeDir, ofEnableSizing]
    Left = 304
    Top = 16
  end
end
