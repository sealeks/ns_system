object Form5: TForm5
  Left = 432
  Top = 260
  BorderStyle = bsToolWindow
  Caption = #1052#1072#1089#1096#1090#1072#1073#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 116
  ClientWidth = 223
  Color = clSilver
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
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 73
    Caption = #1052#1072#1089#1096#1090#1072#1073
    TabOrder = 0
    object Label1: TLabel
      Left = 96
      Top = 40
      Width = 104
      Height = 13
      Caption = '10    -    300 %            '
    end
    object Label2: TLabel
      Left = 176
      Top = 16
      Width = 20
      Height = 13
      Caption = '%    '
    end
    object Edit1: TEdit
      Left = 56
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
  end
  object Button1: TButton
    Left = 64
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 144
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button2Click
  end
end
