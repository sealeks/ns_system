object FormSetTag: TFormSetTag
  Left = 293
  Top = 154
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1086#1088
  ClientHeight = 151
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 18
    Height = 13
    Caption = #1058#1077#1075
  end
  object LabelTag: TLabel
    Left = 40
    Top = 8
    Width = 54
    Height = 13
    Caption = 'LabelTag'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 10
    Top = 92
    Width = 40
    Height = 13
    Caption = 'refCount'
  end
  object Label4: TLabel
    Left = 344
    Top = 28
    Width = 28
    Height = 13
    Caption = 'Direct'
  end
  object rcLab: TLabel
    Left = 61
    Top = 94
    Width = 3
    Height = 13
  end
  object Label2: TLabel
    Left = 383
    Top = 28
    Width = 24
    Height = 13
    Caption = 'CMD'
  end
  object CheckVal: TCheckBox
    Left = 8
    Top = 46
    Width = 49
    Height = 17
    Caption = 'Val'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = CheckValClick
  end
  object EditValCur: TEdit
    Left = 56
    Top = 42
    Width = 130
    Height = 21
    Enabled = False
    TabOrder = 1
  end
  object EditValNew: TEdit
    Left = 189
    Top = 42
    Width = 130
    Height = 21
    TabOrder = 2
  end
  object ButtVl: TButton
    Left = 320
    Top = 64
    Width = 23
    Height = 22
    Caption = 'rst'
    TabOrder = 3
    OnClick = ButtVlClick
  end
  object CheckValDir: TCheckBox
    Left = 351
    Top = 42
    Width = 26
    Height = 17
    TabOrder = 4
  end
  object CheckVLdir: TCheckBox
    Left = 351
    Top = 64
    Width = 23
    Height = 17
    TabOrder = 5
  end
  object ButtVal: TButton
    Left = 320
    Top = 42
    Width = 23
    Height = 22
    Caption = 'rst'
    TabOrder = 6
    OnClick = ButtValClick
  end
  object Button3: TButton
    Left = 88
    Top = 90
    Width = 23
    Height = 22
    Caption = '+'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'set'
    TabOrder = 8
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 112
    Top = 90
    Width = 23
    Height = 22
    Caption = '-'
    TabOrder = 9
    OnClick = Button5Click
  end
  object CheckRefDir: TCheckBox
    Left = 351
    Top = 94
    Width = 22
    Height = 17
    TabOrder = 10
  end
  object Button6: TButton
    Left = 336
    Top = 120
    Width = 75
    Height = 25
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 11
    OnClick = Button6Click
  end
  object CheckCmd: TCheckBox
    Left = 386
    Top = 42
    Width = 26
    Height = 17
    TabOrder = 12
  end
  object EditVLNew: TEdit
    Left = 189
    Top = 64
    Width = 130
    Height = 21
    TabOrder = 13
  end
end
