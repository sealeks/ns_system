object FormPackage: TFormPackage
  Left = 381
  Top = 200
  Width = 494
  Height = 287
  BorderStyle = bsSizeToolWin
  Caption = #1055#1072#1082#1077#1090#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    486
    253)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 2
    Top = 8
    Width = 478
    Height = 172
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 329
    Top = 190
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1073#1088#1072#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 247
    Top = 190
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 409
    Top = 222
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 7
    TabOrder = 3
  end
  object Button4: TButton
    Left = 329
    Top = 222
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1082
    ModalResult = 1
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 2
    Top = 191
    Width = 237
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 5
    Text = 'Edit1'
  end
  object Button5: TButton
    Left = 409
    Top = 190
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 6
    OnClick = Button5Click
  end
  object OpenDialog1: TOpenDialog
    Left = 208
    Top = 200
  end
end
