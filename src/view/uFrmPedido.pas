unit uFrmPedido;

interface

uses
  uPedidoService,
  uPedido,
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB;

type
  TfrmPedido = class(TForm)
    statConexao: TStatusBar;
    grpPedido: TGroupBox;
    grpCliente: TGroupBox;
    grpProduto: TGroupBox;
    grpItens: TGroupBox;
    pnlTotais: TPanel;
    lblNumero: TLabel;
    lblDataEmissao: TLabel;
    edtNumero: TEdit;
    edtDataEmissao: TEdit;
    btnCarregar: TButton;
    btnCancelar: TButton;
    lblCodCliente: TLabel;
    edtCodCliente: TEdit;
    lblCliente: TLabel;
    edtNomeCliente: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblUF: TLabel;
    edtUF: TEdit;
    lblCodProduto: TLabel;
    edtCodProduto: TEdit;
    edtDescricao: TEdit;
    lblDescricao: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    gridItens: TDBGrid;
    btnGravar: TButton;
    btnAdicionar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
  private
    FService: TPedidoService;
    FPedido: TPedido;
  public
    procedure BuscarPedido;
    procedure BuscarCliente;
    procedure BuscarProduto;
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
  uConexao,
  uCliente,
  uProduto,
  uPedidoItem;

{$R *.dfm}

procedure TfrmPedido.btnAdicionarClick(Sender: TObject);
var
  lItem: TPedidoItem;
begin
  lItem := TPedidoItem.Create;
  lItem.Produto.Codigo := StrToInt(edtCodProduto.Text);
  lItem.Produto.Descricao := edtDescricao.Text;
  lItem.Quantidade := StrToFloat(edtQuantidade.Text);
  lItem.VlrUnitario := StrToFloat(edtValorUnitario.Text);
  FPedido.Itens.Add(lItem);
end;

procedure TfrmPedido.btnCarregarClick(Sender: TObject);
begin
  FPedido := FService.CarregarPedido(Numero);
end;

procedure TfrmPedido.btnGravarClick(Sender: TObject);
var
  lNumero: Integer;
begin
  if FPedido.Numero = 0 then
    FPedido.DataEmissao := Now;

  lNumero := FService.Gravar(FPedido);
end;

procedure TfrmPedido.BuscarCliente;
var
  lCodigo: Integer;
  lCliente: TCliente;
begin
  if not Assigned(FService) then
    Exit;

  if Trim(edtCodCliente.Text) = '' then
    begin
      edtCodCliente.Clear;
      edtNomeCliente.Clear;
      edtCidade.Clear;
      edtUF.Clear;
      Exit;
    end;

  lCodigo := StrToIntDef(Trim(edtCodCliente.Text), 0);

  if (lCodigo > 0) and (lCodigo = FPedido.Cliente.Codigo) then
    Exit;

  lCliente := FService.BuscarCliente(lCodigo);
  try
    edtCodCliente.Text := IntToStr(lCliente.Codigo);
    edtNomeCliente.Text := lCliente.Nome;
    edtCidade.Text := lCliente.Cidade;
    edtUF.Text := lCliente.UF;

    FPedido.Cliente.Codigo := lCliente.Codigo;
  finally
    lCliente.Free;
  end;
end;

procedure TfrmPedido.BuscarPedido;
begin

end;

procedure TfrmPedido.BuscarProduto;
var
  lCodigo: Integer;
  lProduto: TProduto;
begin
  if not Assigned(FService) then
    Exit;

  if Trim(edtCodProduto.Text) = '' then
    begin
      edtCodProduto.Clear;
      edtDescricao.Clear;
      edtQuantidade.Clear;
      edtValorUnitario.Clear;
      Exit;
    end;

  lCodigo := StrToIntDef(Trim(edtCodProduto.Text), 0);

  lProduto := FService.BuscarProduto(lCodigo);
  try
    edtCodProduto.Text := IntToStr(lProduto.Codigo);
    edtDescricao.Text := lProduto.Descricao;
    edtQuantidade.Text := '1';
    edtValorUnitario.Text := FormatFloat('#.##', lProduto.PrecoVenda);
  finally
    lProduto.Free;
  end;
end;

procedure TfrmPedido.edtCodClienteExit(Sender: TObject);
begin
  BuscarCliente();
end;

procedure TfrmPedido.edtCodProdutoExit(Sender: TObject);
begin
  BuscarProduto();
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  TConexao.Instance.Connect();
  FPedido := TPedido.Create;
  FService := TPedidoService.Create;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  TConexao.ReleaseInstance();
  FreeAndNil(FPedido);
  FreeAndNil(FService);
end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
  if TConexao.Instance.GetConnection.Connected then
    statConexao.Panels[0].Text := 'Conectado!'
  else
    statConexao.Panels[0].Text := 'Erro ao conectar!';
end;

end.
