object fMain: TfMain
  Left = 223
  Top = 130
  Width = 762
  Height = 545
  Caption = '3D Rotator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 477
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 39
      Width = 61
      Height = 16
      Caption = 'Positions :'
    end
    object ENum: TLabel
      Left = 5
      Top = 5
      Width = 99
      Height = 25
      Caption = 'Point N'#176' X'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 15
      Top = 59
      Width = 17
      Height = 16
      Caption = 'X : '
    end
    object Label4: TLabel
      Left = 94
      Top = 59
      Width = 18
      Height = 16
      Caption = 'Y : '
    end
    object Label5: TLabel
      Left = 177
      Top = 59
      Width = 17
      Height = 16
      Caption = 'Z : '
    end
    object Label6: TLabel
      Left = 5
      Top = 113
      Width = 35
      Height = 16
      Caption = 'Lie a :'
    end
    object EPosX: TEdit
      Left = 39
      Top = 59
      Width = 46
      Height = 24
      TabOrder = 0
      Text = 'EPosX'
      OnExit = EPosXExit
      OnKeyUp = EPosXKeyUp
    end
    object EPosY: TEdit
      Left = 118
      Top = 59
      Width = 46
      Height = 24
      TabOrder = 1
      Text = 'EPosX'
      OnExit = EPosXExit
      OnKeyUp = EPosXKeyUp
    end
    object EPosZ: TEdit
      Left = 202
      Top = 59
      Width = 45
      Height = 24
      TabOrder = 2
      Text = 'EPosX'
      OnExit = EPosXExit
      OnKeyUp = EPosXKeyUp
    end
    object EListeLiaisons: TListBox
      Left = 20
      Top = 138
      Width = 80
      Height = 114
      ItemHeight = 16
      TabOrder = 3
    end
    object Button1: TButton
      Left = 108
      Top = 138
      Width = 90
      Height = 26
      Caption = 'Ajouter'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 108
      Top = 172
      Width = 90
      Height = 26
      Caption = 'Supprimer'
      TabOrder = 5
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 5
      Top = 261
      Width = 144
      Height = 31
      Caption = 'Supprimer ce point'
      TabOrder = 6
      OnClick = Button3Click
    end
    object ESelNum: TComboBox
      Left = 167
      Top = 10
      Width = 80
      Height = 22
      Style = csOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 7
      OnChange = ESelNumChange
    end
  end
  object Panel2: TPanel
    Left = 257
    Top = 0
    Width = 497
    Height = 477
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 336
      Top = 292
      Width = 5
      Height = 184
      ResizeStyle = rsUpdate
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 287
      Width = 495
      Height = 5
      Cursor = crVSplit
      Align = alTop
      ResizeStyle = rsUpdate
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 495
      Height = 286
      Align = alTop
      TabOrder = 0
      OnResize = Panel3Resize
      object Fond: TPaintBox
        Left = 1
        Top = 1
        Width = 493
        Height = 284
        Align = alClient
        OnMouseDown = FondMouseDown
      end
    end
    object Panel4: TPanel
      Left = 341
      Top = 292
      Width = 155
      Height = 184
      Align = alClient
      PopupMenu = PopupMenu1
      TabOrder = 1
      OnResize = Panel4Resize
      object Fond2: TPaintBox
        Left = 1
        Top = 1
        Width = 153
        Height = 182
        Align = alClient
        OnMouseDown = Fond2MouseDown
        OnMouseMove = Fond2MouseMove
        OnMouseUp = Fond2MouseUp
      end
    end
    object Panel5: TPanel
      Left = 1
      Top = 292
      Width = 335
      Height = 184
      Align = alLeft
      PopupMenu = PopupMenu1
      TabOrder = 2
      OnResize = Panel5Resize
      object Fond1: TPaintBox
        Left = 1
        Top = 1
        Width = 333
        Height = 182
        Align = alClient
        OnMouseDown = Fond1MouseDown
        OnMouseMove = Fond1MouseMove
        OnMouseUp = Fond1MouseUp
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 477
    Width = 754
    Height = 16
    Align = alBottom
    Alignment = taLeftJustify
    Caption = 'Point'
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 472
    Top = 292
    object Ajouterunpoint1: TMenuItem
      Caption = 'Ajouter un point'
      OnClick = Ajouterunpoint1Click
    end
    object Supprimerlepoint1: TMenuItem
      Caption = 'Supprimer le point'
      OnClick = Supprimerlepoint1Click
    end
    object Creerunearrte1: TMenuItem
      Caption = 'Creer une arrete'
      OnClick = Creerunearrte1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 352
    Top = 40
    object Fichier1: TMenuItem
      Caption = 'File'
      object Nouvelobjet1: TMenuItem
        Caption = 'New'
        OnClick = Nouvelobjet1Click
      end
      object Chargerunobjet1: TMenuItem
        Caption = 'Open'
        OnClick = Chargerunobjet1Click
      end
      object Enregistrerlobjet1: TMenuItem
        Caption = 'Save'
        OnClick = Enregistrerlobjet1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Quitter1: TMenuItem
        Caption = 'Exit'
        OnClick = Quitter1Click
      end
    end
    object Edition1: TMenuItem
      Caption = 'Edit'
      object Agrandirlobjetx21: TMenuItem
        Caption = 'Agrandir l'#39'objet x2'
        OnClick = Agrandirlobjetx21Click
      end
      object Reduirelobjet21: TMenuItem
        Caption = 'Reduire l'#39'objet x2'
        OnClick = Reduirelobjet21Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Centrerlobjet1: TMenuItem
        Caption = 'Centrer l'#39'objet'
        OnClick = Centrerlobjet1Click
      end
    end
    object Vue3D1: TMenuItem
      Caption = 'View 3D'
      object Afficherlespoints1: TMenuItem
        Caption = 'Afficher les points'
        Checked = True
        OnClick = Afficherlespoints1Click
      end
      object Afficherlesarrtes1: TMenuItem
        Caption = 'Afficher les arretes'
        Checked = True
        OnClick = Afficherlesarrtes1Click
      end
    end
    object Aide1: TMenuItem
      Caption = 'About'
      object Apropos1: TMenuItem
        Caption = 'A propos...'
        OnClick = Apropos1Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Objet 3D Rotator|*.3dr'
    Left = 320
    Top = 40
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Objet 3D Rotator (*.3dr)|*.3dr|Fichier 3D studio ASCII (*.asc)|*' +
      '.asc'
    Left = 288
    Top = 40
  end
end
