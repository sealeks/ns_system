object UserScript: TUserScript
  Left = 314
  Top = 135
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100#1089#1082#1080#1081' '#1089#1082#1088#1080#1087#1090
  ClientHeight = 154
  ClientWidth = 365
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
    Top = 32
    Width = 54
    Height = 13
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
  end
  object Label2: TLabel
    Left = 8
    Top = 97
    Width = 157
    Height = 13
    Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1097#1072#1077#1084#1086#1075#1086' '#1079#1085#1072#1095#1077#1085#1080#1103' '
  end
  object Edit1: TEdit
    Left = 136
    Top = 4
    Width = 225
    Height = 21
    Hint = 'Edit1.'
    TabOrder = 0
    OnChange = Edit1Change
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 5
    Width = 121
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
    Text = 'procedure'
    OnChange = ComboBox1Change
    Items.Strings = (
      'procedure'
      'function')
  end
  object RichEdit1: TRichEdit
    Left = 72
    Top = 32
    Width = 289
    Height = 58
    Lines.Strings = (
      '')
    TabOrder = 2
    OnChange = RichEdit1Change
  end
  object Button1: TButton
    Left = 216
    Top = 120
    Width = 65
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 288
    Top = 120
    Width = 75
    Height = 25
    Caption = #1054#1082
    TabOrder = 4
    OnClick = Button2Click
  end
  object ComboBox2: TComboBox
    Left = 182
    Top = 94
    Width = 177
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'BOOLEAN'
  end
end
