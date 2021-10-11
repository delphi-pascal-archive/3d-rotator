object fArrete: TfArrete
  Left = 413
  Top = 185
  BorderStyle = bsToolWindow
  Caption = 'Nouvelle arr'#234'te'
  ClientHeight = 32
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 20
    Height = 13
    Caption = 'De :'
  end
  object Label2: TLabel
    Left = 100
    Top = 8
    Width = 13
    Height = 13
    Caption = 'A :'
  end
  object ComboBox1: TComboBox
    Left = 36
    Top = 4
    Width = 57
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'ComboBox1'
  end
  object ComboBox2: TComboBox
    Left = 120
    Top = 4
    Width = 57
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'ComboBox1'
  end
  object Button1: TButton
    Left = 184
    Top = 4
    Width = 49
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 236
    Top = 4
    Width = 49
    Height = 25
    Caption = 'Annuler'
    TabOrder = 3
    OnClick = Button2Click
  end
end
