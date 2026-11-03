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
    function Carregar(ANumeroPedido: Integer): TPedido;
    function Excluir(ANumeroPedido: Integer): Boolean;
  end;

  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    function InserirCabecalho(APedido: TPedido): Integer;
    procedure InserirItens(ANumeroPedido: Integer; APedido: TPedido);
    procedure CarregarItens(APedido: TPedido);
  public
    function Gravar(APedido: TPedido): Integer;
    function Carregar(ANumeroPedido: Integer): TPedido;
    function Excluir(ANumeroPedido: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils,
  uConexao,
  uPedidoItem;

{ TPedidoRepository }

function TPedidoRepository.Carregar(ANumeroPedido: Integer): TPedido;
var
  lQry: TFDQuery;
begin
  Result := nil;

  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('select p.numero_pedido, p.data_emissao, p.codigo_cliente,');
    lQry.SQL.Add('       c.nome, c.cidade, c.uf');
    lQry.SQL.Add('  from pedido p');
    lQry.SQL.Add(' inner join cliente c on c.codigo = p.codigo_cliente');
    lQry.SQL.Add(' where p.numero_pedido = :numero_pedido');

    lQry.ParamByName('numero_pedido').AsInteger := ANumeroPedido;
    lQry.Open;

    if lQry.IsEmpty then
      Exit;

    Result := TPedido.Create;
    try
      Result.Numero := lQry.FieldByName('numero_pedido').AsInteger;
      Result.DataEmissao := lQry.FieldByName('data_emissao').AsDateTime;
      Result.Cliente.Codigo := lQry.FieldByName('codigo_cliente').AsInteger;
      Result.Cliente.Nome := lQry.FieldByName('nome').AsString;
      Result.Cliente.Cidade := lQry.FieldByName('cidade').AsString;
      Result.Cliente.UF := Trim(lQry.FieldByName('uf').AsString);

      CarregarItens(Result);
    except
      FreeAndNil(Result);
      raise;
    end;
  finally
    lQry.Free;
  end;
end;

procedure TPedidoRepository.CarregarItens(APedido: TPedido);
var
  lQry: TFDQuery;
  lItem: TPedidoItem;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('select i.id, i.codigo_produto, pr.descricao, i.quantidade, i.vlr_unitario');
    lQry.SQL.Add('  from pedido_item i');
    lQry.SQL.Add(' inner join produto pr on pr.codigo = i.codigo_produto');
    lQry.SQL.Add(' where i.numero_pedido = :numero_pedido');
    lQry.SQL.Add(' order by i.id');

    lQry.ParamByName('numero_pedido').AsInteger := APedido.Numero;
    lQry.Open;

    while not lQry.Eof do
      begin
        lItem := APedido.AdicionarItem(
          lQry.FieldByName('codigo_produto').AsInteger,
          lQry.FieldByName('descricao').AsString,
          lQry.FieldByName('quantidade').AsCurrency,
          lQry.FieldByName('vlr_unitario').AsCurrency);
        lItem.Id := lQry.FieldByName('id').AsInteger;

        lQry.Next;
      end;
  finally
    lQry.Free;
  end;
end;

function TPedidoRepository.Excluir(ANumeroPedido: Integer): Boolean;
var
  lQry: TFDQuery;
begin
  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Text := 'delete from pedido_item where numero_pedido = :numero_pedido';
    lQry.ParamByName('numero_pedido').AsInteger := ANumeroPedido;
    lQry.ExecSQL;

    lQry.SQL.Text := 'delete from pedido where numero_pedido = :numero_pedido';
    lQry.ParamByName('numero_pedido').AsInteger := ANumeroPedido;
    lQry.ExecSQL;

    Result := lQry.RowsAffected > 0;
  finally
    lQry.Free;
  end;
end;

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
    lQry.ParamByName('valor_total').AsCurrency := APedido.ValorTotal;

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
