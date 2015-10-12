object queryFormTr: TqueryFormTr
  Left = 498
  Top = 178
  BorderStyle = bsNone
  BorderWidth = 2
  Caption = 'queryForm'
  ClientHeight = 118
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 263
    Height = 16
    Caption = #1048#1076#1077#1090' '#1095#1090#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1087#1072#1088#1072#1084#1077#1090#1088#1091':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 290
    Top = 16
    Width = 4
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 40
    Width = 425
    Height = 17
    ParentShowHint = False
    Smooth = True
    Step = 2
    ShowHint = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 368
    Top = 90
    Width = 75
    Height = 25
    Caption = #1057#1090#1086#1087
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar2: TProgressBar
    Left = 15
    Top = 65
    Width = 426
    Height = 16
    Smooth = True
    Step = 2
    TabOrder = 2
  end
end
