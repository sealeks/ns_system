object fPropSave: TfPropSave
  Left = 592
  Top = 159
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1085#1072#1089#1090#1088#1086#1077#1082
  ClientHeight = 145
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 6
    Width = 187
    Height = 16
    Caption = #1053#1086#1084#1077#1088' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' ('#1086#1090' 1 '#1076#1086' 20)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 62
    Width = 320
    Height = 16
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' ('#1086#1090#1086#1073#1088#1072#1078#1072#1077#1090#1089#1103' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077')'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SYButton1: TSYButton
    Left = 48
    Top = 112
    Width = 80
    Height = 25
    Color = 10663856
    Caption = #1047#1072#1087#1080#1089#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 0
    OnClick = SYButton1Click
  end
  object SYButton2: TSYButton
    Left = 208
    Top = 112
    Width = 80
    Height = 25
    Color = 8689847
    Caption = #1057#1090#1077#1088#1077#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 1
    OnClick = SYButton2Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 65
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnChange = Edit1Change
    OnClick = Edit2Click
  end
  object Edit2: TEdit
    Left = 16
    Top = 80
    Width = 321
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Edit2Click
  end
  object SYButton3: TSYButton
    Left = 96
    Top = 24
    Width = 25
    Height = 25
    Color = 12434860
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 4
    OnClick = SYButton3Click
  end
  object SYButton4: TSYButton
    Left = 122
    Top = 24
    Width = 25
    Height = 25
    Color = 12434860
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    TextStyle = tsLowered
    TabStop = True
    TabOrder = 5
    OnClick = SYButton3Click
  end
end
