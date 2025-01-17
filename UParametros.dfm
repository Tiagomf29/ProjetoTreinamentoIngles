object frmParametros: TfrmParametros
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Par'#226'metros'
  ClientHeight = 237
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 153
    Height = 73
    Caption = 'Tipos de letras'
    Items.Strings = (
      'Exibir letras mai'#250'sculas'
      'Exibir letras minusculas')
    TabOrder = 0
  end
  object RadioGroup2: TRadioGroup
    Left = 159
    Top = 0
    Width = 322
    Height = 73
    Caption = 'Apresenta'#231#227'o de palavras'
    Columns = 2
    Items.Strings = (
      '1 palavra por vez'
      '4 palavras por vez'
      '8 palavras por vez'
      '12 palavras por vez')
    TabOrder = 1
    OnClick = RadioGroup2Click
  end
  object btnGravar: TBitBtn
    Left = 219
    Top = 207
    Width = 75
    Height = 25
    Caption = 'Gravar'
    TabOrder = 2
    OnClick = btnGravarClick
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 79
    Width = 177
    Height = 122
    Caption = 'Grupo de palavras para exibi'#231#227'o'
    TabOrder = 3
    object Label1: TLabel
      Left = 11
      Top = 23
      Width = 61
      Height = 13
      Caption = 'De: c'#243'digo - '
    end
    object Label2: TLabel
      Left = 11
      Top = 69
      Width = 62
      Height = 13
      Caption = 'At'#233': c'#243'digo -'
    end
    object Edit1: TEdit
      Left = 11
      Top = 42
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 11
      Top = 88
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
  end
  object grpmetodoEstudo: TGroupBox
    Left = 183
    Top = 79
    Width = 298
    Height = 122
    Caption = 'M'#233'todo de estudo'
    TabOrder = 4
    object cbParMesclaPalavrasDia: TCheckBox
      Left = 7
      Top = 21
      Width = 142
      Height = 16
      Caption = 'Divide palavras por dia'
      TabOrder = 0
      OnClick = cbParMesclaPalavrasDiaClick
    end
    object btnutilitario: TBitBtn
      Left = 7
      Top = 43
      Width = 145
      Height = 25
      Caption = 'Organizar palavras di'#225'rias'
      Enabled = False
      TabOrder = 2
      OnClick = btnutilitarioClick
    end
    object cbExibirSomenteAudio: TCheckBox
      Left = 7
      Top = 72
      Width = 153
      Height = 21
      Caption = 'somente '#225'udio em ingl'#234's'
      TabOrder = 3
    end
    object cbexibirPlavrasEFrase: TCheckBox
      Left = 7
      Top = 98
      Width = 210
      Height = 17
      Caption = 'Exibir palavras com frases em ingl'#234's'
      TabOrder = 4
    end
    object seQuantidadeDias: TSpinEdit
      Left = 139
      Top = 17
      Width = 52
      Height = 22
      MaxLength = 1
      MaxValue = 9
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  object grpOutros: TGroupBox
    Left = 487
    Top = 0
    Width = 226
    Height = 115
    Caption = 'Outros'
    TabOrder = 5
    object cbPalavrasAleatorias: TCheckBox
      Left = 6
      Top = 23
      Width = 186
      Height = 17
      Caption = 'Palavras sorteadas aleat'#243'riamente'
      Enabled = False
      TabOrder = 0
    end
    object cbOrdenarPalavras: TCheckBox
      Left = 6
      Top = 46
      Width = 185
      Height = 14
      Caption = 'Ordenar palavras alfabeticamente'
      Enabled = False
      TabOrder = 1
    end
    object cbRepetirPalavras: TCheckBox
      Left = 6
      Top = 64
      Width = 161
      Height = 17
      Caption = 'Repetir palavras acertadas'
      TabOrder = 2
    end
    object chkApresentarPalavrasPortugues: TCheckBox
      Left = 6
      Top = 84
      Width = 203
      Height = 17
      Caption = 'Apresentar Palavras em portugues'
      TabOrder = 3
      Visible = False
    end
  end
  object GroupBox2: TGroupBox
    Left = 487
    Top = 114
    Width = 226
    Height = 118
    Caption = 'Tipos de palavras'
    TabOrder = 6
    object chkCategorias: TCheckListBox
      Left = 2
      Top = 15
      Width = 222
      Height = 70
      ItemHeight = 13
      TabOrder = 0
    end
    object btnMarcarTodos: TButton
      Left = 75
      Top = 87
      Width = 93
      Height = 25
      Caption = 'Marcar todos'
      TabOrder = 1
      OnClick = btnMarcarTodosClick
    end
  end
end
