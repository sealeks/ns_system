object IMMIImgForm: TIMMIImgForm
  Left = 338
  Top = 559
  Width = 394
  Height = 258
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1082#1072#1088#1090#1080#1085#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 304
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object Button1: TButton
    Left = 304
    Top = 40
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 16
    Width = 289
    Height = 201
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1050#1072#1088#1090#1080#1085#1082#1072
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 59
        Height = 13
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
      end
      object Bevel2: TBevel
        Left = 144
        Top = 64
        Width = 89
        Height = 89
      end
      object Bevel1: TBevel
        Left = 32
        Top = 64
        Width = 89
        Height = 89
      end
      object Image1: TImage
        Left = 32
        Top = 64
        Width = 89
        Height = 89
        Stretch = True
        OnClick = Image1Click
      end
      object Label2: TLabel
        Left = 56
        Top = 48
        Width = 45
        Height = 13
        Caption = #1048#1057#1058#1048#1053#1040
      end
      object Image2: TImage
        Left = 144
        Top = 64
        Width = 89
        Height = 89
        Stretch = True
        OnClick = Image2Click
      end
      object Label3: TLabel
        Left = 168
        Top = 48
        Width = 34
        Height = 13
        Caption = #1051#1054#1046#1068
      end
      object Edit1: TEdit
        Left = 85
        Top = 8
        Width = 172
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
      ImageIndex = 1
      object Label4: TLabel
        Left = 40
        Top = 52
        Width = 51
        Height = 13
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
      end
      object Label7: TLabel
        Left = 40
        Top = 80
        Width = 37
        Height = 13
        Caption = #1044#1086#1089#1090#1091#1087
      end
      object Label5: TLabel
        Left = 40
        Top = 112
        Width = 19
        Height = 13
        Caption = #1058#1080#1087
      end
      object Edit2: TEdit
        Left = 120
        Top = 43
        Width = 121
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
      object SpinEdit1: TSpinEdit
        Left = 120
        Top = 72
        Width = 121
        Height = 22
        Increment = 1000
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 0
      end
      object ComboBox1: TComboBox
        Left = 120
        Top = 104
        Width = 121
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        Text = 'ComboBox1'
        Items.Strings = (
          #1050#1085#1086#1087#1082#1072
          #1058#1091#1084#1073#1083#1077#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      ImageIndex = 2
      object Label6: TLabel
        Left = 8
        Top = 16
        Width = 59
        Height = 13
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
      end
      object Edit3: TEdit
        Left = 85
        Top = 8
        Width = 172
        Height = 21
        TabOrder = 0
        Text = 'Edit3'
      end
    end
  end
  object OpenPictureDialog2: TOpenPictureDialog
    Left = 304
    Top = 128
  end
end
