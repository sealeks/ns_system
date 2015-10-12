object FormOperatorConf: TFormOperatorConf
  Left = 421
  Top = 110
  BorderStyle = bsDialog
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1076#1086#1089#1090#1091#1087#1086#1084
  ClientHeight = 335
  ClientWidth = 483
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 483
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 60
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 0
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 60
      Top = 2
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 1
      OnClick = ToolButton2Click
    end
    object ToolButton3: TToolButton
      Left = 120
      Top = 2
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 2
      OnClick = ToolButton3Click
    end
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 29
    Width = 483
    Height = 306
    Align = alClient
    ColCount = 3
    DefaultColWidth = 40
    DefaultRowHeight = 18
    FixedColor = 4227327
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    ParentFont = False
    TabOrder = 1
    OnSelectCell = StringGrid1SelectCell
    OnSetEditText = StringGrid1SetEditText
    ColWidths = (
      40
      358
      77)
  end
end
