unit uPedidoService;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uCliente,
  uProduto,
  uPedido,
  uClienteRepository,
  uProdutoRepository,
  uPedidoRepository;

type
  TPedidoService = class
  private
    FClienteRepository: IClienteRepository;
    FProdutoRepository: IProdutoRepository;
    FPedidoRepository: IPedidoRepository;
    procedure ValidarPedido(APedido: TPedido);
  public
    constructor Create; overload;
    constructor Create(
      AClienteRepository: IClienteRepository;
      AProdutoRepository: IProdutoRepository;
      APedidoRepository: IPedidoRepository); overload;

    function BuscarCliente(ACodigo: Integer): TCliente;
    function BuscarProduto(ACodigo: Integer): TProduto;
    function Gravar(APedido: TPedido): Integer;
    function CarregarPedido(ANumeroPedido: Integer): TPedido;
    procedure CancelarPedido(ANumeroPedido: Integer);
  end;

implementation

uses
  uConexao;

{ TPedidoService }

constructor TPedidoService.Create(
  AClienteRepository: IClienteRepository;
  AProdutoRepository: IProdutoRepository;
  APedidoRepository: IPedidoRepository);
begin
  inherited Create;
  FClienteRepository := AClienteRepository;
  FProdutoRepository := AProdutoRepository;
  FPedidoRepository := APedidoRepository;
end;

function TPedidoService.BuscarCliente(ACodigo: Integer): TCliente;
begin
  if ACodigo <= 0 then
    raise Exception.Create('Informe um código de cliente válido.');

  Result := FClienteRepository.BuscarPorCodigo(ACodigo);
  if not Assigned(Result) then
    raise Exception.Create(Format('Cliente %d não encontrado.', [ACodigo]));
end;

function TPedidoService.BuscarProduto(ACodigo: Integer): TProduto;
begin
  if ACodigo <= 0 then
    raise Exception.Create('Informe um código de produto válido.');

  Result := FProdutoRepository.BuscarPorCodigo(ACodigo);
  if not Assigned(Result) then
    raise Exception.Create(Format('Produto %d não encontrado.', [ACodigo]));
end;

procedure TPedidoService.CancelarPedido(ANumeroPedido: Integer);
begin
  if ANumeroPedido <= 0 then
    raise Exception.Create('Informe um número de pedido válido.');

  TConexao.Instance.GetConnection.StartTransaction;
  try
    if not FPedidoRepository.Excluir(ANumeroPedido) then
      raise Exception.Create(Format('Pedido %d não encontrado.', [ANumeroPedido]));

    TConexao.Instance.GetConnection.Commit;
  except
    TConexao.Instance.GetConnection.Rollback;
    raise;
  end;
end;

function TPedidoService.CarregarPedido(ANumeroPedido: Integer): TPedido;
begin
  if ANumeroPedido <= 0 then
    raise Exception.Create('Informe um número de pedido válido.');

  Result := FPedidoRepository.Carregar(ANumeroPedido);
  if not Assigned(Result) then
    raise Exception.Create(Format('Pedido %d não encontrado.', [ANumeroPedido]));
end;

constructor TPedidoService.Create;
begin
  Create(
    TClienteRepository.Create,
    TProdutoRepository.Create,
    TPedidoRepository.Create);
end;

procedure TPedidoService.ValidarPedido(APedido: TPedido);
begin
  if not Assigned(APedido) then
    raise Exception.Create('Pedido não informado.');

  if APedido.Numero > 0 then
    raise Exception.Create(Format('O pedido %d já está gravado.', [APedido.Numero]));

  if APedido.Cliente.Codigo <= 0 then
    raise Exception.Create('Informe o cliente do pedido.');

  if APedido.Itens.Count = 0 then
    raise Exception.Create('O pedido deve ter pelo menos um item.');
end;

function TPedidoService.Gravar(APedido: TPedido): Integer;
begin
  ValidarPedido(APedido);

  TConexao.Instance.GetConnection.StartTransaction;
  try
    Result := FPedidoRepository.Gravar(APedido);
    TConexao.Instance.GetConnection.Commit;
  except
    TConexao.Instance.GetConnection.Rollback;
    raise;
  end;

  APedido.Numero := Result;
end;

end.
