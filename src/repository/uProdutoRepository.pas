unit uProdutoRepository;

interface

uses
  Data.DB,
  Firedac.Stan.Param, FireDAC.Comp.Client,
  uProduto;

type
  IProdutoRepository = interface
    ['{9C2D7E4A-5B1F-4A3E-8D60-7F2B1E9A4C53}']
    function BuscarPorCodigo(ACodigo: Integer): TProduto;
  end;

  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  public
    function BuscarPorCodigo(ACodigo: Integer): TProduto;
  end;

implementation

uses
  System.SysUtils,
  uConexao;

{ TProdutoRepository }

function TProdutoRepository.BuscarPorCodigo(ACodigo: Integer): TProduto;
var
  lQry: TFDQuery;
begin
  Result := nil;

  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('select codigo, descricao, preco_venda');
    lQry.SQL.Add('  from produto');
    lQry.SQL.Add(' where 1=1');
    lQry.SQL.Add('   and codigo = :codigo');

    lQry.ParamByName('CODIGO').AsInteger := ACodigo;
    lQry.Open;

    if lQry.IsEmpty then
      Exit;

    Result := TProduto.Create;
    Result.Codigo     := lQry.FieldByName('CODIGO').AsInteger;
    Result.Descricao  := lQry.FieldByName('descricao').AsString;
    Result.PrecoVenda := lQry.FieldByName('preco_venda').AsCurrency;
  finally
    lQry.Free;
  end;
end;

end.
