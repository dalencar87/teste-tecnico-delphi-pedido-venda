unit uPedidoTest;

interface

uses
  DUnitX.TestFramework,
  uPedido,
  uPedidoItem;

type
  [TestFixture]
  TPedidoTest = class
  private
    FPedido: TPedido;
    procedure AdicionarItensPadrao;
    procedure ConferirValor(AEsperado: Double; AAtual: Currency);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure AtualizarItemRecalcularTotal;
    [Test]
    procedure RemoverItemRecalcularTotal;
    [Test]
    procedure RemoverTodosItensZerarTotal;
    [Test]
    procedure QuantidadeZero;
    [Test]
    procedure ValorUnitarioNegativo;
  end;

implementation

uses
  System.SysUtils;

const
  TOLERANCIA: Double = 0.001;

procedure TPedidoTest.AdicionarItensPadrao;
begin
  FPedido.AdicionarItem(1, 'Arroz Tipo 1 5kg', 2, 27.90);
  FPedido.AdicionarItem(4, 'Café Torrado e Moído 500g', 3, 18.75);
  FPedido.AdicionarItem(6, 'Leite Integral 1L', 12, 5.39);
end;

procedure TPedidoTest.ConferirValor(AEsperado: Double; AAtual: Currency);
var
  lAtual: Double;
begin
  lAtual := AAtual;
  Assert.AreEqual(AEsperado, lAtual, TOLERANCIA);
end;

procedure TPedidoTest.Setup;
begin
  FPedido := TPedido.Create;
end;

procedure TPedidoTest.TearDown;
begin
  FreeAndNil(FPedido);
end;

procedure TPedidoTest.AtualizarItemRecalcularTotal;
begin
  AdicionarItensPadrao;

  FPedido.AtualizarItem(1, 4, 'Café Torrado e Moído 500g', 1, 18.75);

  ConferirValor(139.23, FPedido.ValorTotal);
end;

procedure TPedidoTest.RemoverItemRecalcularTotal;
begin
  AdicionarItensPadrao;
  FPedido.AtualizarItem(1, 4, 'Café Torrado e Moído 500g', 1, 18.75);

  FPedido.RemoverItem(2);

  Assert.AreEqual(2, FPedido.Itens.Count);
  ConferirValor(74.55, FPedido.ValorTotal);
end;

procedure TPedidoTest.RemoverTodosItensZerarTotal;
begin
  AdicionarItensPadrao;

  FPedido.RemoverItem(0);
  FPedido.RemoverItem(0);
  FPedido.RemoverItem(0);

  Assert.AreEqual(0, FPedido.Itens.Count);
  ConferirValor(0, FPedido.ValorTotal);
end;

procedure TPedidoTest.QuantidadeZero;
begin
  Assert.WillRaise(
    procedure
    begin
      FPedido.AdicionarItem(1, 'Arroz Tipo 1 5kg', 0, 27.90);
    end,
    Exception);

  Assert.AreEqual(0, FPedido.Itens.Count);
end;

procedure TPedidoTest.ValorUnitarioNegativo;
begin
  Assert.WillRaise(
    procedure
    begin
      FPedido.AdicionarItem(1, 'Arroz Tipo 1 5kg', 1, -1);
    end,
    Exception);

  Assert.AreEqual(0, FPedido.Itens.Count);
end;

initialization
  TDUnitX.RegisterTestFixture(TPedidoTest);

end.
