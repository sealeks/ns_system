object ArmatBmEditorFrm: TArmatBmEditorFrm
  Left = 686
  Top = 443
  Width = 508
  Height = 304
  Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1082#1083#1072#1087#1072#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 24
    Top = 253
    Width = 48
    Height = 14
    Caption = #1055#1086#1076#1089#1082#1072#1079#1082#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 24
    Top = 224
    Width = 56
    Height = 14
    Caption = #1040#1082#1090#1080#1074#1085#1086#1089#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 304
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 392
    Top = 16
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 265
    Height = 97
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object Bevel2: TBevel
      Left = 208
      Top = 48
      Width = 33
      Height = 33
    end
    object Bevel1: TBevel
      Left = 208
      Top = 16
      Width = 33
      Height = 33
    end
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 42
      Height = 14
      Caption = #1054#1090#1082#1088#1099#1090'*'
    end
    object Label2: TLabel
      Left = 8
      Top = 64
      Width = 34
      Height = 14
      Caption = #1047#1072#1082#1088#1099#1090
    end
    object Image1: TImage
      Left = 208
      Top = 16
      Width = 33
      Height = 33
      Stretch = True
      OnClick = Image1Click
    end
    object Image2: TImage
      Left = 208
      Top = 48
      Width = 33
      Height = 33
      Stretch = True
      OnClick = Image2Click
    end
    object Edit1: TEditExpr
      Left = 64
      Top = 27
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'Edit1'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object Edit2: TEditExpr
      Left = 64
      Top = 59
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'Edit2'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 120
    Width = 265
    Height = 97
    Caption = #1053#1077#1080#1089#1087#1088#1072#1074#1085#1086#1089#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object Bevel3: TBevel
      Left = 208
      Top = 16
      Width = 33
      Height = 33
    end
    object Label3: TLabel
      Left = 8
      Top = 32
      Width = 29
      Height = 14
      Caption = #1043#1086#1088#1080#1090
    end
    object Label4: TLabel
      Left = 8
      Top = 64
      Width = 36
      Height = 14
      Caption = #1052#1080#1075#1072#1077#1090
    end
    object Image3: TImage
      Left = 208
      Top = 16
      Width = 33
      Height = 33
      Stretch = True
      OnClick = Image3Click
    end
    object Edit3: TEditExpr
      Left = 65
      Top = 27
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'Edit3'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object Edit4: TEditExpr
      Left = 65
      Top = 58
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'Edit4'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object GroupBox3: TGroupBox
    Left = 296
    Top = 64
    Width = 185
    Height = 153
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object Label5: TLabel
      Left = 8
      Top = 32
      Width = 41
      Height = 14
      Caption = #1054#1090#1082#1088#1099#1090#1100
    end
    object Label6: TLabel
      Left = 8
      Top = 64
      Width = 39
      Height = 14
      Caption = #1047#1072#1082#1088#1099#1090#1100
    end
    object Label7: TLabel
      Left = 8
      Top = 96
      Width = 36
      Height = 14
      Caption = #1044#1086#1089#1090#1091#1087
    end
    object Label9: TLabel
      Left = 8
      Top = 133
      Width = 41
      Height = 14
      Caption = #1047#1072#1075#1086#1083#1086#1074'.'
    end
    object SpinEdit1: TSpinEdit
      Left = 56
      Top = 88
      Width = 121
      Height = 23
      Increment = 1000
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object Edit7: TEdit
      Left = 56
      Top = 124
      Width = 121
      Height = 22
      TabOrder = 1
      Text = 'Edit7'
    end
    object Edit5: TEditExpr
      Left = 57
      Top = 27
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = 'Edit5'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
    object Edit6: TEditExpr
      Left = 57
      Top = 58
      Width = 121
      Height = 23
      Color = 15925234
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = 'Edit6'
      corrColor = clGreen
      nocorrColor = clRed
      defColor = clBlack
      ButDialog = True
    end
  end
  object Edit8: TEdit
    Left = 88
    Top = 245
    Width = 385
    Height = 21
    TabOrder = 5
    Text = 'Edit8'
  end
  object EditExpr1: TEditExpr
    Left = 105
    Top = 218
    Width = 121
    Height = 23
    Color = 15925234
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    Text = 'Edit4'
    corrColor = clGreen
    nocorrColor = clRed
    defColor = clBlack
    ButDialog = True
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 176
  end
  object OpenPictureDialog2: TOpenPictureDialog
    Left = 176
  end
end
