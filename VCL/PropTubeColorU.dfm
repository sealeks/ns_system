object PropTubeColor: TPropTubeColor
  Left = 703
  Top = 273
  BorderStyle = bsToolWindow
  Caption = 'Form1'
  ClientHeight = 231
  ClientWidth = 284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 205
    Top = 8
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 205
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 185
    Height = 217
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1042#1099#1073#1088#1072#1090#1100
      object GroupBox1: TGroupBox
        Left = 8
        Top = 4
        Width = 161
        Height = 181
        Caption = #1050#1072#1088#1090#1080#1085#1082#1072
        TabOrder = 0
        object Bevel1: TBevel
          Left = 16
          Top = 25
          Width = 89
          Height = 25
        end
        object PaintBox1: TPaintBox
          Left = 16
          Top = 24
          Width = 89
          Height = 27
          OnClick = PaintBox1Click
        end
        object Button3: TButton
          Left = 112
          Top = 24
          Width = 25
          Height = 27
          Caption = #173#1031
          Font.Charset = SYMBOL_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Symbol'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = Button3Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1048#1079' '#1092#1072#1081#1083#1072' '#1088#1077#1089#1091#1088#1089#1086#1074
      ImageIndex = 1
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 176
  end
end
