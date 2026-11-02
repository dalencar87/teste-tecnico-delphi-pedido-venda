program Pedidos;

uses
  Vcl.Forms,
  uFrmPedido in 'view\uFrmPedido.pas' {frmPedido},
  uConexao in 'tools\uConexao.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPedido, frmPedido);
  Application.Run;
end.
