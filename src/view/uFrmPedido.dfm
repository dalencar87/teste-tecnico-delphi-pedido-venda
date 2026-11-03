object frmPedido: TfrmPedido
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedidos'
  ClientHeight = 529
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object statConexao: TStatusBar
    Left = 0
    Top = 510
    Width = 738
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object grpPedido: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 732
    Height = 75
    Align = alTop
    Caption = 'Pedido'
    TabOrder = 1
    object lblNumero: TLabel
      Left = 16
      Top = 24
      Width = 47
      Height = 13
      Caption = 'N'#186' Pedido'
    end
    object lblDataEmissao: TLabel
      Left = 122
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Emiss'#227'o'
    end
    object edtNumero: TEdit
      Left = 16
      Top = 43
      Width = 100
      Height = 21
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 0
    end
    object edtDataEmissao: TEdit
      Left = 122
      Top = 43
      Width = 150
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object btnCarregar: TButton
      Left = 278
      Top = 41
      Width = 75
      Height = 25
      Caption = 'Carregar'
      TabOrder = 2
      OnClick = btnCarregarClick
    end
    object btnCancelar: TButton
      Left = 359
      Top = 41
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
  end
  object grpCliente: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 84
    Width = 732
    Height = 75
    Align = alTop
    Caption = 'Cliente'
    TabOrder = 2
    object lblCodCliente: TLabel
      Left = 16
      Top = 22
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object lblCliente: TLabel
      Left = 122
      Top = 22
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object lblCidade: TLabel
      Left = 428
      Top = 22
      Width = 33
      Height = 13
      Caption = 'Cidade'
    end
    object lblUF: TLabel
      Left = 640
      Top = 22
      Width = 13
      Height = 13
      Caption = 'UF'
    end
    object edtCodCliente: TEdit
      Left = 16
      Top = 41
      Width = 100
      Height = 21
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 0
      OnExit = edtCodClienteExit
    end
    object edtNomeCliente: TEdit
      Left = 122
      Top = 41
      Width = 300
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtCidade: TEdit
      Left = 428
      Top = 41
      Width = 206
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object edtUF: TEdit
      Left = 640
      Top = 41
      Width = 50
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 3
    end
  end
  object grpProduto: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 165
    Width = 732
    Height = 75
    Align = alTop
    Caption = 'Produto'
    TabOrder = 3
    object lblCodProduto: TLabel
      Left = 16
      Top = 22
      Width = 33
      Height = 13
      Caption = 'C'#243'digo'
    end
    object lblDescricao: TLabel
      Left = 122
      Top = 22
      Width = 46
      Height = 13
      Caption = 'Descri'#231#227'o'
    end
    object lblQuantidade: TLabel
      Left = 428
      Top = 22
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object lblValorUnitario: TLabel
      Left = 534
      Top = 22
      Width = 56
      Height = 13
      Caption = 'Vlr. Unit'#225'rio'
    end
    object edtCodProduto: TEdit
      Left = 16
      Top = 41
      Width = 100
      Height = 21
      MaxLength = 5
      NumbersOnly = True
      TabOrder = 0
      OnExit = edtCodProdutoExit
    end
    object edtDescricao: TEdit
      Left = 122
      Top = 41
      Width = 300
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtQuantidade: TEdit
      Left = 428
      Top = 41
      Width = 100
      Height = 21
      MaxLength = 10
      TabOrder = 2
    end
    object edtValorUnitario: TEdit
      Left = 534
      Top = 41
      Width = 100
      Height = 21
      MaxLength = 10
      TabOrder = 3
    end
    object btnAdicionar: TButton
      Left = 640
      Top = 39
      Width = 75
      Height = 25
      Caption = 'Inserir'
      TabOrder = 4
      OnClick = btnAdicionarClick
    end
  end
  object grpItens: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 246
    Width = 732
    Height = 219
    Align = alTop
    Caption = 'Itens do Pedido'
    TabOrder = 4
    object gridItens: TStringGrid
      Left = 2
      Top = 15
      Width = 728
      Height = 202
      Align = alClient
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 0
      OnKeyDown = gridItensKeyDown
    end
  end
  object pnlTotais: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 471
    Width = 732
    Height = 36
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 5
    object lblTotal: TLabel
      Left = 16
      Top = 8
      Width = 116
      Height = 19
      Caption = 'Total: R$ 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnGravar: TButton
      Left = 615
      Top = 0
      Width = 100
      Height = 32
      Caption = 'Gravar Pedido'
      TabOrder = 0
      OnClick = btnGravarClick
    end
  end
end
