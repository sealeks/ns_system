object Form14: TForm14
  Left = 449
  Top = 245
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1090#1088#1086#1082
  ClientHeight = 426
  ClientWidth = 300
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
  object Button1: TButton
    Left = 64
    Top = 392
    Width = 73
    Height = 25
    Caption = #1048#1079' '#1092#1072#1081#1083#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 224
    Top = 392
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 0
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 289
    Height = 345
    ItemHeight = 13
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 8
    Top = 360
    Width = 169
    Height = 21
    TabOrder = 4
    Text = 'Edit1'
    OnClick = Edit1Click
  end
  object Button4: TButton
    Left = 184
    Top = 360
    Width = 57
    Height = 25
    Caption = '+'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 240
    Top = 360
    Width = 57
    Height = 25
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = Button5Click
  end
end
