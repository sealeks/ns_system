object FormDT: TFormDT
  Left = 313
  Top = 163
  Width = 317
  Height = 208
  Caption = #1042#1099#1073#1086#1088' '#1076#1080#1072#1087#1072#1079#1086#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 28
    Top = 9
    Width = 211
    Height = 13
    Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1077' '#1085#1072#1095#1072#1083#1100#1085#1099#1081' '#1084#1086#1084#1077#1085#1090' '#1074#1088#1077#1084#1077#1085#1080':'
  end
  object Label2: TLabel
    Left = 28
    Top = 75
    Width = 205
    Height = 13
    Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1077' '#1082#1086#1085#1077#1095#1085#1099#1081' '#1084#1086#1084#1077#1085#1090' '#1074#1088#1077#1084#1077#1085#1080':'
  end
  object Label3: TLabel
    Left = 79
    Top = 39
    Width = 20
    Height = 13
    Caption = #1095#1072#1089'.'
  end
  object Label4: TLabel
    Left = 79
    Top = 104
    Width = 20
    Height = 13
    Caption = #1095#1072#1089'.'
  end
  object FromDate: TDateTimePicker
    Left = 107
    Top = 32
    Width = 169
    Height = 21
    Date = 37398.000000000000000000
    Time = 37398.000000000000000000
    DateFormat = dfLong
    TabOrder = 0
  end
  object EndDate: TDateTimePicker
    Left = 107
    Top = 97
    Width = 169
    Height = 21
    Date = 37399.000000000000000000
    Time = 37399.000000000000000000
    DateFormat = dfLong
    TabOrder = 1
  end
  object FromHour: TEdit
    Left = 27
    Top = 32
    Width = 35
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object FromHourUpDown: TUpDown
    Left = 62
    Top = 32
    Width = 16
    Height = 21
    Associate = FromHour
    Max = 23
    TabOrder = 3
  end
  object EndHourUpDown: TUpDown
    Left = 62
    Top = 97
    Width = 16
    Height = 21
    Associate = EndHour
    Max = 23
    TabOrder = 4
  end
  object EndHour: TEdit
    Left = 27
    Top = 97
    Width = 35
    Height = 21
    MaxLength = 2
    TabOrder = 5
    Text = '0'
  end
  object Button1: TButton
    Left = 144
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 6
  end
  object Button2: TButton
    Left = 224
    Top = 144
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 7
  end
end
