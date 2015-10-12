object IMMIPropertysForm: TIMMIPropertysForm
  Left = 302
  Top = 473
  Width = 478
  Height = 258
  Caption = #1057#1074#1086#1081#1089#1090#1074#1072' '#1082#1072#1088#1090#1080#1085#1082#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 392
    Top = 48
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 0
  end
  object Button1: TButton
    Left = 392
    Top = 16
    Width = 75
    Height = 25
    Caption = #1061#1086#1088#1086#1096#1086
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object TPageControl1: TPageControl
    Left = 8
    Top = 16
    Width = 369
    Height = 201
    ActivePage = tsControl
    MultiLine = True
    TabOrder = 2
    object tsValue: TTabSheet
      Caption = #1047#1085#1072#1095#1077#1085#1080#1077
      ImageIndex = 3
      object Label1: TLabel
        Left = 48
        Top = 56
        Width = 59
        Height = 13
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
      end
      object Edit1: TEditExpr
        Left = 120
        Top = 51
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
    end
    object tsPicture: TTabSheet
      Caption = #1050#1072#1088#1090#1080#1085#1082#1072
      object Bevel2: TBevel
        Left = 192
        Top = 32
        Width = 89
        Height = 89
      end
      object Bevel1: TBevel
        Left = 80
        Top = 32
        Width = 89
        Height = 89
      end
      object Image1: TImage
        Left = 80
        Top = 32
        Width = 89
        Height = 89
        Stretch = True
        OnClick = Image1Click
      end
      object Label2: TLabel
        Left = 104
        Top = 16
        Width = 45
        Height = 13
        Caption = #1048#1057#1058#1048#1053#1040
      end
      object Image2: TImage
        Left = 192
        Top = 32
        Width = 89
        Height = 89
        Stretch = True
        OnClick = Image2Click
      end
      object Label3: TLabel
        Left = 216
        Top = 16
        Width = 34
        Height = 13
        Caption = #1051#1054#1046#1068
      end
      object CheckBox2: TCheckBox
        Left = 80
        Top = 136
        Width = 161
        Height = 17
        Caption = #1088#1072#1089#1089#1090#1103#1075#1080#1074#1072#1090#1100' '#1088#1080#1089#1091#1085#1086#1082
        TabOrder = 0
      end
    end
    object tsLine: TTabSheet
      Caption = #1051#1080#1085#1080#1103
      ImageIndex = 4
    end
    object tsFill: TTabSheet
      Caption = #1047#1072#1083#1080#1074#1082#1072
      ImageIndex = 5
    end
    object tsFont: TTabSheet
      Caption = #1060#1086#1085#1090
      ImageIndex = 7
    end
    object tsControl: TTabSheet
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
      ImageIndex = 1
      object Label4: TLabel
        Left = 40
        Top = 26
        Width = 51
        Height = 13
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088
      end
      object Label7: TLabel
        Left = 40
        Top = 75
        Width = 37
        Height = 13
        Caption = #1044#1086#1089#1090#1091#1087
      end
      object Label5: TLabel
        Left = 42
        Top = 96
        Width = 19
        Height = 13
        Caption = #1058#1080#1087
      end
      object Label9: TLabel
        Left = 40
        Top = 49
        Width = 59
        Height = 13
        Caption = #1040#1082#1090#1080#1074#1085#1086#1089#1090#1100
      end
      object SpinEdit1: TSpinEdit
        Left = 120
        Top = 66
        Width = 121
        Height = 22
        Increment = 1000
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 0
      end
      object ComboBox1: TComboBox
        Left = 120
        Top = 89
        Width = 121
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = 'ComboBox1'
        Items.Strings = (
          #1050#1085#1086#1087#1082#1072
          #1058#1091#1084#1073#1083#1077#1088
          #1047#1085#1072#1095#1077#1085#1080#1077)
      end
      object Edit2: TEditExpr
        Left = 119
        Top = 19
        Width = 121
        Height = 23
        Color = 15925234
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Times'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Text = 'Edit2'
        corrColor = clGreen
        nocorrColor = clRed
        defColor = clBlack
        ButDialog = True
      end
      object EditExpr1: TEditExpr
        Left = 119
        Top = 43
        Width = 121
        Height = 23
        Color = 15925234
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Times'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Text = 'Edit2'
        corrColor = clGreen
        nocorrColor = clRed
        defColor = clBlack
        ButDialog = True
      end
      object Button3: TButton
        Left = 32
        Top = 120
        Width = 121
        Height = 25
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1086#1082#1085#1072#1084#1080
        TabOrder = 4
        OnClick = Button3Click
      end
    end
    object tsVisible: TTabSheet
      Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
      ImageIndex = 2
      object Label6: TLabel
        Left = 8
        Top = 16
        Width = 59
        Height = 13
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
      end
      object Edit3: TEditExpr
        Left = 80
        Top = 12
        Width = 155
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
    end
    object tsBlink: TTabSheet
      Caption = #1052#1080#1075#1072#1085#1080#1077
      ImageIndex = 6
      object Label8: TLabel
        Left = 8
        Top = 16
        Width = 59
        Height = 13
        Caption = #1042#1099#1088#1072#1078#1077#1085#1080#1077
      end
      object CheckBox1: TCheckBox
        Left = 88
        Top = 48
        Width = 121
        Height = 17
        Caption = #1052#1080#1075#1072#1090#1100' '#1085#1077#1074#1080#1076#1080#1084#1086
        TabOrder = 0
      end
      object Edit4: TEditExpr
        Left = 80
        Top = 11
        Width = 155
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
  end
  object OpenPictureDialog2: TOpenPictureDialog
    Left = 432
    Top = 88
  end
end
