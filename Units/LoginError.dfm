object LoginError: TLoginError
  Left = 323
  Top = 205
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  ClientHeight = 86
  ClientWidth = 262
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
  object Bevel1: TBevel
    Left = 5
    Top = 5
    Width = 252
    Height = 44
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 241
    Height = 33
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 88
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 6000
    OnTimer = Timer1Timer
    Left = 200
    Top = 56
  end
end
