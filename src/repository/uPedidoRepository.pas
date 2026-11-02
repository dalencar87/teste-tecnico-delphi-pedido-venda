unit uPedidoRepository;

interface

uses
  System.Classes, System.Contnrs,
  Data.DB,
  Firedac.Stan.Param, FireDAC.Comp.Client,
  uPedido;

type
  IPedidoRepository = interface
    ['{3E8A5C2B-7D14-4F96-A0B3-6C1E9D2F7A85}']
    function Gravar(APedido: TPedido): Integer;
  end;

  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    function InserirCabecalho(APedido: TPedido): Integer;
    procedure InserirItens(ANumeroPedido: Integer; APedido: TPedido);
  public
    function Gravar(APedido: TPedido): Integer;
  end;

implementation

uses
  uConexao,
  uPedidoItem;

{ TPedidoRepository }

function TPedidoRepository.Gravar(APedido: TPedido): Integer;
begin
  Result := InserirCabecalho(APedido);
  InserirItens(Result, APedido);
end;

function TPedidoRepository.InserirCabecalho(APedido: TPedido): Integer;
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('insert into pedido');
    lQry.SQL.Add(' (data_emissao, codigo_cliente, valor_total)');
    lQry.SQL.Add('values');
    lQry.SQL.Add(' (:data_emissao, :codigo_cliente, :valor_total)');
    lQry.SQL.Add('returning numero_pedido');

    lQry.ParamByName('data_emissao').AsDateTime := APedido.DataEmissao;
    lQry.ParamByName('codigo_cliente').AsInteger := APedido.Cliente.Codigo;
    lQry.ParamByName('valor_total').AsCurrency := 0;

    lQry.Open;
    Result := lQry.FieldByName('numero_pedido').AsInteger;
  finally
    lQry.Free;
  end;
end;

procedure TPedidoRepository.InserirItens(ANumeroPedido: Integer; APedido: TPedido);
var
  lQry: TFDQuery;
  I: Integer;
  Item: TPedidoItem;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('insert into pedido_item');
    lQry.SQL.Add(' (numero_pedido, codigo_produto, quantidade, vlr_unitario, vlr_total)');
    lQry.SQL.Add('values');
    lQry.SQL.Add(' (:numero_pedido, :codigo_produto, :quantidade, :vlr_unitario, :vlr_total)');

    lQry.Prepare;

    for I := 0 to APedido.Itens.Count - 1 do
      begin
        Item := TPedidoItem(APedido.Itens[I]);

        lQry.ParamByName('numero_pedido').AsInteger := ANumeroPedido;
        lQry.ParamByName('codigo_produto').AsInteger := Item.Produto.Codigo;
        lQry.ParamByName('quantidade').AsCurrency := Item.Quantidade;
        lQry.ParamByName('vlr_unitario').AsCurrency := Item.VlrUnitario;
        lQry.ParamByName('vlr_total').AsCurrency := Item.VlrTotal;
        lQry.ExecSQL;
      end;
  finally
    lQry.Free;
  end;
end;

end.
