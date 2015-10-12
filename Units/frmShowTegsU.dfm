object frmShowTegs: TfrmShowTegs
  Left = 436
  Top = 403
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = #1057#1087#1080#1089#1086#1082' '#1090#1077#1075#1086#1074
  ClientHeight = 163
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 270
    Top = 0
    Width = 101
    Height = 163
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
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 270
    Height = 163
    Align = alClient
    ColCount = 1
    DefaultColWidth = 250
    FixedCols = 0
    RowCount = 7
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    TabOrder = 1
  end
end
