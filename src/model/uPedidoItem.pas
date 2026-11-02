unit uPedidoItem;

interface

uses
  System.SysUtils,
  uProduto;

type
  TPedidoItem = class
  private
    FId: Integer;
    FProduto: TProduto;
    FQuantidade: Currency;
    FVlrUnitario: Currency;
    FDescricaoProduto: string;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property Produto: TProduto read FProduto write FProduto;
    property DescricaoProduto: string read FDescricaoProduto write FDescricaoProduto;
    property Quantidade: Currency read FQuantidade write FQuantidade;
    property VlrUnitario: Currency read FVlrUnitario write FVlrUnitario;
    property VlrTotal: Currency read FVlrUnitario write FVlrUnitario;
  end;

implementation

{ TPedidoItem }

constructor TPedidoItem.Create;
begin
  inherited Create;
  FProduto := TProduto.Create;
end;

destructor TPedidoItem.Destroy;
begin
  FreeAndNil(FProduto);
  inherited;
end;

end.
