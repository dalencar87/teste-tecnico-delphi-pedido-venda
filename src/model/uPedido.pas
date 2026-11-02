unit uPedido;

interface

uses
  System.Contnrs,
  System.SysUtils,
  uCliente;

type
  TPedido = class
  private
    FNumero: Integer;
    FDataEmissao: TDateTime;
    FCliente: TCliente;
    FItens: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;

    property Numero: Integer read FNumero write FNumero;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property Cliente: TCliente read FCliente write FCliente;
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

end.
