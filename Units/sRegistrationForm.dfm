object RegistrationForm: TRegistrationForm
  Left = 30
  Top = 177
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = #1047#1072#1087#1088#1086#1089' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 105
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 29
    Width = 140
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel2: TBevel
    Left = 157
    Top = 27
    Width = 213
    Height = 18
  end
  object Label2: TLabel
    Left = 178
    Top = 29
    Width = 187
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Bevel3: TBevel
    Left = 11
    Top = 51
    Width = 226
    Height = 18
  end
  object Label3: TLabel
    Left = 16
    Top = 53
    Width = 187
    Height = 12
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1080' '#1087#1086#1076#1090#1074#1077#1088#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 13
    Top = 5
    Width = 355
    Height = 13
    Caption = #1044#1072#1085#1085#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077' '#1090#1088#1077#1073#1091#1077#1090' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1075#1086' '#1074#1074#1086#1076#1072' '#1087#1072#1088#1086#1083#1103' !'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 213
    Top = 75
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 6
    TabOrder = 0
  end
  object Button2: TButton
    Left = 293
    Top = 75
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 241
    Top = 52
    Width = 125
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'Edit1'
    OnEnter = Edit1Enter
  end
end
