object QueryForm: TQueryForm
  Left = 521
  Top = 415
  BorderStyle = bsNone
  ClientHeight = 128
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object IMMIPanel1: TIMMIPanel
    Left = 0
    Top = 0
    Width = 449
    Height = 65
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 9
      Width = 424
      Height = 48
      AutoSize = False
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
  end
  object IMMIPanel2: TIMMIPanel
    Left = -1
    Top = 66
    Width = 451
    Height = 63
    Color = clBtnShadow
    TabOrder = 1
    object ImmiButtonXp1: TImmiButtonXp
      Left = 56
      Top = 11
      Width = 113
      Height = 41
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      About = 'Design eXperience. '#169' 2002 M. Hoffmann'
      Version = '1.0.2g'
      Caption = #1044#1072
      TabOrder = 0
      ModalResult = 1
      Param.Access = 0
      FormManager.ShowMod = False
      FormManager.NotCloseModal = False
      FormManager.CaverModal = False
      FormManager.BeepTime = 0
    end
    object ImmiButtonXp2: TImmiButtonXp
      Left = 264
      Top = 12
      Width = 113
      Height = 41
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      About = 'Design eXperience. '#169' 2002 M. Hoffmann'
      Version = '1.0.2g'
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      ModalResult = 7
      Param.Access = 0
      FormManager.ShowMod = False
      FormManager.NotCloseModal = False
      FormManager.CaverModal = False
      FormManager.BeepTime = 0
    end
  end
end
