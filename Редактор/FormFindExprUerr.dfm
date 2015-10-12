object FormFindExprErr: TFormFindExprErr
  Left = 279
  Top = 98
  Width = 412
  Height = 379
  Anchors = [akLeft]
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = #1055#1086#1080#1089#1082' '#1085#1077#1082#1086#1088#1088#1077#1082#1090#1085#1099#1093' '#1074#1099#1088#1072#1078#1077#1085#1080#1081
  Color = clBtnFace
  Constraints.MaxWidth = 680
  Constraints.MinHeight = 372
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    404
    352)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 10
    Top = 250
    Width = 5
    Height = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 268
    Width = 69
    Height = 13
    Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 236
    Width = 103
    Height = 13
    Caption = #1058#1077#1082#1091#1097#1080#1081' '#1086#1073#1098#1077#1082#1090':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label1: TLabel
    Left = 2
    Top = 6
    Width = 119
    Height = 13
    Caption = #1048#1089#1082#1072#1090#1100'  '#1074#1099#1088#1072#1078#1077#1085#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 137
    Top = 6
    Width = 58
    Height = 13
    Caption = #1085#1072' '#1092#1086#1088#1084#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EditExpr1: TEditExpr
    Left = 8
    Top = 264
    Width = 393
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    BevelEdges = [beLeft, beRight, beBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnKeyUp = EditExpr1KeyUp
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = False
  end
  object bStop: TButton
    Left = 263
    Top = 315
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1090#1086#1087
    TabOrder = 1
    Visible = False
    OnClick = bStopClick
  end
  object bExit: TButton
    Left = 335
    Top = 313
    Width = 65
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = bExitClick
  end
  object bStart: TButton
    Left = 263
    Top = 313
    Width = 65
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1055#1091#1089#1082
    TabOrder = 3
    OnClick = bStartClick
  end
  object Panel1: TPanel
    Left = 1
    Top = 26
    Width = 401
    Height = 191
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      401
      191)
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 8
      Width = 388
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      Caption = #1052#1077#1089#1090#1086#1085#1072#1093#1086#1078#1076#1077#1085#1080#1077
      Items.Strings = (
        #1042' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1082#1086#1084#1087#1086#1085#1077#1090#1072#1093
        #1053#1072' '#1090#1077#1082#1091#1097#1077#1081' '#1092#1086#1088#1084#1077
        #1042#1086' '#1074#1089#1077#1084' '#1087#1088#1086#1077#1082#1090#1077)
      TabOrder = 0
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 105
      Width = 385
      Height = 80
      Anchors = [akLeft, akTop, akRight]
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Columns = 2
      Items.Strings = (
        #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
        #1042#1099#1076#1077#1083#1103#1090#1100' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086
        #1041#1077#1079' '#1074#1099#1076#1077#1083#1077#1085#1080#1103)
      TabOrder = 1
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 221
    Width = 385
    Height = 12
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
  end
  object bNoReplace: TButton
    Left = 180
    Top = 313
    Width = 73
    Height = 27
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
    TabOrder = 6
    Visible = False
    OnClick = bNoReplaceClick
  end
  object bReplace: TButton
    Left = 95
    Top = 315
    Width = 80
    Height = 24
    Anchors = [akLeft, akRight, akBottom]
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
    TabOrder = 7
    Visible = False
    OnClick = bReplaceClick
  end
  object cboxFormCoose: TComboBox
    Left = 199
    Top = 2
    Width = 199
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 8
  end
end
