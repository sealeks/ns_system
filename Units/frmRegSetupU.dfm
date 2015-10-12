object frmRegSetup: TfrmRegSetup
  Left = 699
  Top = 129
  BorderStyle = bsToolWindow
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 400
  ClientWidth = 115
  Color = clBtnFace
  Constraints.MaxHeight = 434
  Constraints.MaxWidth = 123
  Constraints.MinHeight = 427
  Constraints.MinWidth = 123
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TIMMIPanel
    Left = 0
    Top = 32
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 19
      Height = 16
      Hint = #1050#1086#1101#1092#1080#1094#1080#1077#1085#1090' '#1087#1088#1086#1087#1086#1088#1094#1080#1086#1085#1072#1083#1100#1085#1086#1089#1090#1080
      Caption = #1050#1087
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull1: TIMMILabelFull
      Left = 48
      Top = 8
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry1: TIMMIValueEntry
      Left = 43
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel2: TIMMIPanel
    Left = 0
    Top = 135
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 1
    object Label2: TLabel
      Left = 8
      Top = 9
      Width = 27
      Height = 16
      Hint = #1050#1086#1101#1092#1080#1094#1080#1077#1085#1090' '#1087#1088#1086#1087#1086#1088#1094#1080#1086#1085#1072#1083#1100#1085#1086#1089#1090#1080' 2 '#1089#1090'.'
      Caption = #1050#1087'2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull2: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry2: TIMMIValueEntry
      Left = 43
      Top = 5
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel3: TIMMIPanel
    Left = 0
    Top = 64
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 10
      Width = 20
      Height = 16
      Hint = #1042#1088#1077#1084#1103' '#1080#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1085#1080#1103
      Caption = #1058#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull3: TIMMILabelFull
      Left = 48
      Top = 10
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry3: TIMMIValueEntry
      Left = 45
      Top = 5
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel4: TIMMIPanel
    Left = 0
    Top = 167
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 3
    object Label4: TLabel
      Left = 8
      Top = 9
      Width = 28
      Height = 16
      Hint = #1042#1088#1077#1084#1103' '#1080#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1085#1080#1103' 2 '#1089#1090'.'
      Caption = #1058#1080'2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull4: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry4: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel5: TIMMIPanel
    Left = 0
    Top = 99
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 4
    object Label5: TLabel
      Left = 8
      Top = 9
      Width = 37
      Height = 16
      Caption = 'dEps'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull5: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry5: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      Hint = #1043#1088#1072#1085#1080#1094#1072' '#1087#1077#1088#1077#1093#1086#1076#1072' '#1074' '#1076#1074#1091#1093#1089#1090#1091#1087#1077#1085#1095#1072#1090#1099#1093' '#1088#1077#1075#1091#1083#1103#1090#1086#1088#1072#1093
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel6: TIMMIPanel
    Left = 1
    Top = 199
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 5
    object Label6: TLabel
      Left = 8
      Top = 9
      Width = 20
      Height = 16
      Hint = #1042#1088#1077#1084#1103' '#1076#1080#1092#1092#1077#1088#1077#1085#1094#1080#1088#1086#1074#1072#1085#1080#1103
      Caption = #1058'd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull6: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object TDEntry: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 111
    Height = 33
    BevelInner = bvRaised
    TabOrder = 6
  end
  object IMMIPanel1: TIMMIPanel
    Left = 1
    Top = 231
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 7
    object Label7: TLabel
      Left = 8
      Top = 9
      Width = 31
      Height = 16
      Hint = #1052#1077#1088#1074#1072#1103' '#1079#1086#1085#1072
      Caption = 'DdB'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull7: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry7: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object IMMIPanel2: TIMMIPanel
    Left = 1
    Top = 264
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 8
    object Label8: TLabel
      Left = 8
      Top = 9
      Width = 31
      Height = 16
      Hint = #1042#1088#1077#1084#1103' '#1093#1086#1076#1072
      Caption = 'Tfull'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull8: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry8: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object IMMIPanel3: TIMMIPanel
    Left = 2
    Top = 295
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 9
    object Label9: TLabel
      Left = 8
      Top = 9
      Width = 36
      Height = 16
      Hint = #1042#1088#1077#1084#1103' '#1080#1085#1087#1091#1083#1100#1089#1072
      Caption = 'Timp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull9: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry9: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object IMMIPanel4: TIMMIPanel
    Left = 3
    Top = 328
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 10
    object Label10: TLabel
      Left = 4
      Top = 9
      Width = 41
      Height = 16
      Hint = #1057#1082#1086#1088#1086#1089#1090#1100' '#1089#1090#1088#1077#1084#1083#1077#1085#1080#1103' '#1082' '#1079#1072#1076#1072#1085#1080#1102
      Caption = 'V->sp'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull10: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry10: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
  object IMMIPanel5: TIMMIPanel
    Left = 2
    Top = 361
    Width = 111
    Height = 33
    BevelInner = bvLowered
    TabOrder = 11
    object Label11: TLabel
      Left = 4
      Top = 9
      Width = 28
      Height = 16
      Hint = 'Min/Sec'
      Caption = 'M/S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object IMMILabelFull11: TIMMILabelFull
      Left = 48
      Top = 9
      Width = 38
      Height = 16
      Caption = '%8.2f'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      FPosition.FormTop = -1
      FPosition.FormLeft = -1
      iColorOn = clBlack
      iColorOff = clBlack
      iBounds.iAccess = 0
      isGraphic = False
      isDiscret = False
      ColMinute = 0
      notbouds = False
      noActive = False
    end
    object IMMIValueEntry11: TIMMIValueEntry
      Left = 45
      Top = 4
      Width = 49
      Height = 21
      Cursor = crHandPoint
      iparam.vals = 0
      iparam.Access = 0
      iparam.isOff = False
      iparam.isLogin = False
      iparam.isreset = False
      iparam.maxValue = 100.000000000000000000
      iparam.isQuery = False
      iparam.format = '%.2f'
      Border.EnterColor = clNone
      Border.OutColor = clNone
      Border.BlkColor = clNone
      Border.BorderType = btRectangle
      Border.PenWidth = 0
      Border.BlinkInvisible = False
    end
  end
end
