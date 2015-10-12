object Form2: TForm2
  Left = 200
  Top = 205
  Width = 263
  Height = 487
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
    Width = 255
    Height = 25
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      255
      25)
    object ComboBox1: TComboBox
      Left = 5
      Top = 0
      Width = 247
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
      Width = 228
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
    Width = 255
    Height = 428
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 1
    object ObjInsp11: TObjInsp1
      Left = 1
      Top = 1
      Width = 253
      Height = 436
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
        137)
    end
  end
end
