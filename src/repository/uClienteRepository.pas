unit uClienteRepository;

interface

uses
  Data.DB,
  Firedac.Stan.Param, FireDAC.Comp.Client,
  uCliente;

type
  IClienteRepository = interface
    ['{6B0E3A1C-2F4D-4C8B-9E71-3A5D2C8F1B40}']
    function BuscarPorCodigo(ACodigo: Integer): TCliente;
  end;

  TClienteRepository = class(TInterfacedObject, IClienteRepository)
  public
    function BuscarPorCodigo(ACodigo: Integer): TCliente;
  end;

implementation

uses
  System.SysUtils,
  uConexao;

{ TClienteRepository }

function TClienteRepository.BuscarPorCodigo(ACodigo: Integer): TCliente;
var
  lQry: TFDQuery;
begin
  Result := nil;

  lQry := TFDQuery.Create(nil);
  try
    lQry.Connection := TConexao.Instance.GetConnection;

    lQry.SQL.Add('select codigo, nome, cidade, uf');
    lQry.SQL.Add('  from cliente');
    lQry.SQL.Add(' where 1=1');
    lQry.SQL.Add('   and codigo = :codigo');

    lQry.ParamByName('codigo').AsInteger := ACodigo;
    lQry.Open;

    if lQry.IsEmpty then
      Exit;

    Result := TCliente.Create;
    Result.Codigo := lQry.FieldByName('codigo').AsInteger;
    Result.Nome   := lQry.FieldByName('nome').AsString;
    Result.Cidade := lQry.FieldByName('cidade').AsString;
    Result.UF     := Trim(lQry.FieldByName('uf').AsString);
  finally
    lQry.Free;
  end;
end;

end.
