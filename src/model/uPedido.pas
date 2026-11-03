unit uPedido;

interface

uses
  System.Contnrs,
  System.SysUtils,
  System.Classes,
  uCliente,
  uPedidoItem;

type
  TPedido = class
  private
    FNumero: Integer;
    FDataEmissao: TDateTime;
    FCliente: TCliente;
    FObservacao: string;
    FItens: TObjectList;
    procedure ValidarIndice(AIndex: Integer);
    procedure ValidarValores(AQuantidade, AVlrUnitario: Currency);
  public
    constructor Create;
    destructor Destroy; override;

    function AdicionarItem(ACodigoProduto: Integer; const ADescricao: string;
      AQuantidade, AVlrUnitario: Currency): TPedidoItem;
    procedure AtualizarItem(AIndex: Integer; ACodigoProduto: Integer; const ADescricao: string;
      AQuantidade, AVlrUnitario: Currency);
    procedure RemoverItem(AIndex: Integer);
    function ValorTotal: Currency;

    property Numero: Integer read FNumero write FNumero;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property Cliente: TCliente read FCliente write FCliente;
    property Observacao: string read FObservacao write FObservacao;
    property Itens: TObjectList read FItens write FItens;
  end;

implementation

{ TPedido }

constructor TPedido.Create;
begin
  inherited Create;
  FCliente := TCliente.Create;
  FItens := TObjectList.Create(True);
end;

destructor TPedido.Destroy;
begin
  FreeAndNil(FCliente);
  FreeAndNil(FItens);
  inherited;
end;

function TPedido.AdicionarItem(ACodigoProduto: Integer; const ADescricao: string;
  AQuantidade, AVlrUnitario: Currency): TPedidoItem;
begin
  ValidarValores(AQuantidade, AVlrUnitario);

  Result := TPedidoItem.Create;
  Result.Produto.Codigo := ACodigoProduto;
  Result.Produto.Descricao := ADescricao;
  Result.DescricaoProduto := ADescricao;
  Result.Quantidade := AQuantidade;
  Result.VlrUnitario := AVlrUnitario;
  FItens.Add(Result);
end;

procedure TPedido.AtualizarItem(AIndex: Integer; ACodigoProduto: Integer; const ADescricao: string;
  AQuantidade, AVlrUnitario: Currency);
var
  lItem: TPedidoItem;
begin
  ValidarIndice(AIndex);
  ValidarValores(AQuantidade, AVlrUnitario);

  lItem := TPedidoItem(FItens[AIndex]);
  lItem.Produto.Codigo := ACodigoProduto;
  lItem.Produto.Descricao := ADescricao;
  lItem.DescricaoProduto := ADescricao;
  lItem.Quantidade := AQuantidade;
  lItem.VlrUnitario := AVlrUnitario;
end;

procedure TPedido.RemoverItem(AIndex: Integer);
begin
  ValidarIndice(AIndex);
  FItens.Delete(AIndex);
end;

function TPedido.ValorTotal: Currency;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FItens.Count - 1 do
    Result := Result + TPedidoItem(FItens[I]).VlrTotal;
end;

procedure TPedido.ValidarIndice(AIndex: Integer);
begin
  if (AIndex < 0) or (AIndex >= FItens.Count) then
    raise Exception.Create('Item do pedido não encontrado.');
end;

procedure TPedido.ValidarValores(AQuantidade, AVlrUnitario: Currency);
begin
  if AQuantidade <= 0 then
    raise Exception.Create('A quantidade deve ser maior que zero.');

  if AVlrUnitario < 0 then
    raise Exception.Create('O valor unitário não pode ser negativo.');
end;

end.
