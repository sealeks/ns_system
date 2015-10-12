object ImitEditForm: TImitEditForm
  Left = 592
  Top = 176
  BorderStyle = bsToolWindow
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1080#1084#1080#1090#1072#1090#1086#1088#1072
  ClientHeight = 184
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 16
    Top = 152
    Width = 114
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1093#1086#1076#1072' (%/'#1089#1077#1082')'
  end
  object Label6: TLabel
    Left = 16
    Top = 16
    Width = 22
    Height = 13
    Caption = #1048#1084#1103
  end
  object OKBtn: TButton
    Left = 228
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 332
    Top = 142
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 40
    Width = 185
    Height = 89
    Caption = #1050#1086#1084#1072#1085#1076#1099
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 22
      Height = 13
      Caption = #1042#1082#1083'.'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 30
      Height = 13
      Caption = #1042#1099#1082#1083'.'
    end
    object Edit1: TEdit
      Left = 48
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 48
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit2'
    end
  end
  object GroupBox2: TGroupBox
    Left = 224
    Top = 40
    Width = 185
    Height = 89
    Caption = #1050#1086#1085#1094#1077#1074#1080#1082#1080
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 32
      Width = 28
      Height = 13
      Caption = #1054#1090#1082#1088'.'
    end
    object Label4: TLabel
      Left = 8
      Top = 56
      Width = 28
      Height = 13
      Caption = #1047#1072#1082#1088'.'
    end
    object Edit3: TEdit
      Left = 56
      Top = 24
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'Edit3'
    end
    object Edit4: TEdit
      Left = 56
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit4'
    end
  end
  object SpinEdit1: TSpinEdit
    Left = 144
    Top = 144
    Width = 57
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 4
    Value = 0
  end
  object Edit5: TEdit
    Left = 56
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 5
    Text = 'Edit5'
  end
  object StaticText1: TStaticText
    Left = 224
    Top = 16
    Width = 41
    Height = 17
    Caption = #1055#1086#1083#1086#1078'.'
    TabOrder = 6
  end
  object Edit6: TEdit
    Left = 280
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 7
    Text = 'Edit6'
  end
end
