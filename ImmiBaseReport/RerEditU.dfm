object RepEdit: TRepEdit
  Left = 266
  Top = 116
  Width = 736
  Height = 392
  Caption = 'CreteRep'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 568
    Top = 336
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 648
    Top = 336
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 713
    Height = 28
    TabOrder = 2
    object Label1: TLabel
      Left = 328
      Top = 8
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Label1'
    end
  end
  object RichEdit1: TMemo
    Left = 8
    Top = 40
    Width = 185
    Height = 321
    Lines.Strings = (
      'RichEdit1')
    PopupMenu = PopupMenu1
    TabOrder = 3
  end
  object RichEdit2: TMemo
    Left = 200
    Top = 44
    Width = 521
    Height = 285
    Lines.Strings = (
      'RichEdit1')
    TabOrder = 4
  end
  object PopupMenu1: TPopupMenu
    Left = 136
    Top = 304
    object N1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1075
      OnClick = N1Click
    end
  end
end
