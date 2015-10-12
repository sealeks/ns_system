object SelectAppForm: TSelectAppForm
  Left = 296
  Top = 159
  Width = 905
  Height = 563
  Caption = #1055#1086#1080#1089#1082
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnResize = FormResize
  DesignSize = (
    897
    536)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 780
    Top = 0
    Width = 117
    Height = 536
    Align = alRight
    TabOrder = 0
    object Button1: TButton
      Left = 18
      Top = 8
      Width = 75
      Height = 25
      Caption = #1042#1074#1086#1076
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 18
      Top = 40
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 40
    Width = 780
    Height = 495
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = 3
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = ListBox1DblClick
  end
  object Edit1: TEdit
    Left = 24
    Top = 8
    Width = 137
    Height = 21
    TabOrder = 2
  end
  object Button3: TButton
    Left = 168
    Top = 8
    Width = 75
    Height = 25
    Caption = #1060#1080#1083#1100#1090#1088
    TabOrder = 3
    OnClick = Button3Click
  end
end
