program Pedidos;

uses
  Vcl.Forms,
  uFrmPedido in 'view\uFrmPedido.pas' {frmPedido},
  uConexao in 'tools\uConexao.pas',
  uCliente in 'model\uCliente.pas',
  uProduto in 'model\uProduto.pas',
  uPedidoItem in 'model\uPedidoItem.pas',
  uPedido in 'model\uPedido.pas',
  uClienteRepository in 'repository\uClienteRepository.pas',
  uProdutoRepository in 'repository\uProdutoRepository.pas',
  uPedidoRepository in 'repository\uPedidoRepository.pas',
  uPedidoService in 'service\uPedidoService.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
