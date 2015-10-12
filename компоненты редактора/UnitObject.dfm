object Form2: TForm2
  Left = 614
  Top = 55
  Width = 321
  Height = 453
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = #1057#1074#1086#1081#1089#1074#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = ObjInsp11KeyDown
  OnKeyUp = ObjInsp11KeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 25
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      313
      25)
    object ComboBox1: TComboBox
      Left = 5
      Top = 0
      Width = 305
      Height = 21
      AutoDropDown = True
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox1'
      OnKeyDown = ObjInsp11KeyDown
      OnKeyUp = ObjInsp11KeyUp
      OnSelect = ComboBox1Select
    end
    object Edit1: TEdit
      Left = 0
      Top = 2
      Width = 286
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'Edit1'
      OnKeyDown = ObjInsp11KeyDown
      OnKeyUp = ObjInsp11KeyUp
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 25
    Width = 313
    Height = 402
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    DesignSize = (
      313
      402)
    object ObjInsp11: TObjInsp1
      Left = 1
      Top = 1
      Width = 311
      Height = 373
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clMedGray
      DefaultColWidth = 110
      DefaultRowHeight = 16
      DisplayOptions = [doAutoColResize, doKeyColFixed]
      FixedCols = 1
      KeyOptions = [keyEdit]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goThumbTracking]
      TabOrder = 0
      ColWidths = (
        110
        195)
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 376
      Width = 185
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1087#1086#1074#1077#1088#1093' '#1086#1089#1090#1072#1083#1100#1085#1099#1093
      TabOrder = 1
    end
  end
end
