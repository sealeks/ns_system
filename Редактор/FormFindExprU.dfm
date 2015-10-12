object FormFindExpr: TFormFindExpr
  Left = 516
  Top = 498
  Width = 441
  Height = 462
  Anchors = [akLeft]
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  Caption = #1055#1086#1080#1089#1082' '#1080' '#1079#1072#1084#1077#1085#1072
  Color = clBtnFace
  Constraints.MaxWidth = 680
  Constraints.MinHeight = 462
  Constraints.MinWidth = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    433
    435)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 10
    Top = 344
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
    Top = 362
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
  object Label4: TLabel
    Left = 7
    Top = 401
    Width = 78
    Height = 13
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 330
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
    Width = 132
    Height = 13
    Caption = #1048#1089#1082#1072#1090#1100' '#1074' '#1074#1099#1088#1072#1078#1077#1085#1080#1103#1093
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
    Top = 377
    Width = 422
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
    Left = 291
    Top = 404
    Width = 65
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1057#1090#1086#1087
    TabOrder = 1
    Visible = False
    OnClick = bStopClick
  end
  object bExit: TButton
    Left = 364
    Top = 404
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = bExitClick
  end
  object bStart: TButton
    Left = 292
    Top = 404
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1055#1091#1089#1082
    TabOrder = 3
    OnClick = bStartClick
  end
  object Panel1: TPanel
    Left = 1
    Top = 24
    Width = 430
    Height = 289
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    DesignSize = (
      430
      289)
    object GroupBox1: TGroupBox
      Left = 189
      Top = 40
      Width = 238
      Height = 89
      Anchors = [akLeft, akTop, akRight]
      Caption = #1050#1088#1080#1090#1077#1088#1080#1080
      TabOrder = 4
      object chbFindasTag: TCheckBox
        Left = 10
        Top = 61
        Width = 111
        Height = 17
        Caption = #1050#1072#1082' '#1090#1077#1075
        TabOrder = 0
      end
    end
    object chbWholeWord: TCheckBox
      Left = 199
      Top = 54
      Width = 97
      Height = 17
      Caption = #1057#1083#1086#1074#1086' '#1094#1077#1083#1080#1082#1086#1084
      TabOrder = 0
    end
    object chbCaseSensiv: TCheckBox
      Left = 199
      Top = 77
      Width = 165
      Height = 17
      Caption = #1063#1091#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1082' '#1088#1077#1075#1080#1089#1090#1088#1091
      TabOrder = 1
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 40
      Width = 177
      Height = 89
      Caption = #1052#1077#1089#1090#1086#1085#1072#1093#1086#1078#1076#1077#1085#1080#1077
      Items.Strings = (
        #1042' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1093' '#1082#1086#1084#1087#1086#1085#1077#1090#1072#1093
        #1053#1072' '#1090#1077#1082#1091#1097#1077#1081' '#1092#1086#1088#1084#1077
        #1042#1086' '#1074#1089#1077#1084' '#1087#1088#1086#1077#1082#1090#1077)
      TabOrder = 2
    end
    object RadioGroup2: TRadioGroup
      Left = 8
      Top = 129
      Width = 420
      Height = 72
      Anchors = [akLeft, akTop, akRight]
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Columns = 2
      Items.Strings = (
        #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
        #1042#1099#1076#1077#1083#1103#1090#1100' '#1087#1086#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1100#1085#1086
        #1041#1077#1079' '#1074#1099#1076#1077#1083#1077#1085#1080#1103)
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 232
      Width = 418
      Height = 49
      Anchors = [akLeft, akTop, akRight]
      Caption = #1047#1072#1084#1077#1085#1072
      TabOrder = 5
      DesignSize = (
        418
        49)
      object cboxREplace: TComboBox
        Left = 4
        Top = 16
        Width = 406
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
      end
    end
    object cboxFind: TComboBox
      Left = 4
      Top = 11
      Width = 411
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      Sorted = True
      TabOrder = 6
      OnChange = cboxFindChange
    end
    object CheckBox4: TCheckBox
      Left = 16
      Top = 211
      Width = 145
      Height = 17
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1079#1072#1084#1077#1085#1091
      TabOrder = 7
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 317
    Width = 414
    Height = 12
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
  end
  object bNoReplace: TButton
    Left = 209
    Top = 404
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100
    TabOrder = 6
    Visible = False
    OnClick = bNoReplaceClick
  end
  object bReplace: TButton
    Left = 124
    Top = 406
    Width = 80
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100
    TabOrder = 7
    Visible = False
    OnClick = bReplaceClick
  end
  object EditExpr2: TEditExpr
    Left = 8
    Top = 415
    Width = 422
    Height = 21
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelEdges = [beLeft, beRight, beBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = False
  end
  object bRepAll: TButton
    Left = 39
    Top = 404
    Width = 79
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1074#1089#1077
    TabOrder = 9
    Visible = False
    OnClick = bRepAllClick
  end
  object cboxFormCoose: TComboBox
    Left = 199
    Top = 2
    Width = 228
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 10
  end
end
