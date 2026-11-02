unit uFrmPedido;

interface

uses
  uPedidoService,
  uPedido,
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids;

type
  TfrmPedido = class(TForm)
    statConexao: TStatusBar;
    grpPedido: TGroupBox;
    grpCliente: TGroupBox;
    grpProduto: TGroupBox;
    grpItens: TGroupBox;
    pnlTotais: TPanel;
    lblNumero: TLabel;
    lblDataEmissao: TLabel;
    edtNumero: TEdit;
    edtDataEmissao: TEdit;
    btnCarregar: TButton;
    btnCancelar: TButton;
    lblCodCliente: TLabel;
    edtCodCliente: TEdit;
    lblCliente: TLabel;
    edtNomeCliente: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblUF: TLabel;
    edtUF: TEdit;
    lblCodProduto: TLabel;
    edtCodProduto: TEdit;
    edtDescricao: TEdit;
    lblDescricao: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    gridItens: TStringGrid;
    btnGravar: TButton;
    btnAdicionar: TButton;
    lblTotal: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure gridItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FService: TPedidoService;
    FPedido: TPedido;
    FIndiceEdicao: Integer;
    procedure ConfigurarGrid;
    procedure AtualizarGrid;
    procedure AtualizarTotal;
    procedure LimparCliente;
    procedure LimparProduto;
    procedure EditarItem;
    procedure ExcluirItem;
    procedure NovoPedido;
  public
    procedure BuscarPedido;
    procedure BuscarCliente;
    procedure BuscarProduto;
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
  System.UITypes,
  uConexao,
  uCliente,
  uProduto,
  uPedidoItem;

{$R *.dfm}

procedure TfrmPedido.AtualizarGrid;
var
  I: Integer;
  lItem: TPedidoItem;
begin
  if FPedido.Itens.Count = 0 then
    begin
      gridItens.RowCount := 2;
      gridItens.Rows[1].Clear;
    end
  else
    begin
      gridItens.RowCount := FPedido.Itens.Count + 1;

      for I := 0 to FPedido.Itens.Count - 1 do
        begin
          lItem := TPedidoItem(FPedido.Itens[I]);

          gridItens.Cells[0, I + 1] := IntToStr(lItem.Produto.Codigo);
          gridItens.Cells[1, I + 1] := lItem.Produto.Descricao;
          gridItens.Cells[2, I + 1] := FormatFloat('#,##0.00', lItem.Quantidade);
          gridItens.Cells[3, I + 1] := FormatFloat('#,##0.00', lItem.VlrUnitario);
          gridItens.Cells[4, I + 1] := FormatFloat('#,##0.00', lItem.VlrTotal);
        end;
    end;

  AtualizarTotal;
end;

procedure TfrmPedido.AtualizarTotal;
begin
  lblTotal.Caption := 'Total: ' + FormatFloat('"R$ "#,##0.00', FPedido.ValorTotal);
end;

procedure TfrmPedido.btnAdicionarClick(Sender: TObject);
var
  lCodigo: Integer;
  lQuantidade: Currency;
  lValorUnitario: Currency;
begin
  lCodigo := StrToIntDef(Trim(edtCodProduto.Text), 0);

  if (lCodigo <= 0) or (Trim(edtDescricao.Text) = '') then
    begin
      ShowMessage('Informe um produto válido.');
      edtCodProduto.SetFocus;
      Exit;
    end;

  if not TryStrToCurr(Trim(edtQuantidade.Text), lQuantidade) then
    begin
      ShowMessage('Quantidade inválida.');
      edtQuantidade.SetFocus;
      Exit;
    end;

  if not TryStrToCurr(Trim(edtValorUnitario.Text), lValorUnitario) then
    begin
      ShowMessage('Valor unitário inválido.');
      edtValorUnitario.SetFocus;
      Exit;
    end;

  try
    if FIndiceEdicao < 0 then
      FPedido.AdicionarItem(lCodigo, edtDescricao.Text, lQuantidade, lValorUnitario)
    else
      FPedido.AtualizarItem(FIndiceEdicao, lCodigo, edtDescricao.Text, lQuantidade, lValorUnitario);
  except
    on E: Exception do
      begin
        ShowMessage(E.Message);
        edtQuantidade.SetFocus;
        Exit;
      end;
  end;

  AtualizarGrid;
  LimparProduto;
  edtCodProduto.SetFocus;
end;

procedure TfrmPedido.btnGravarClick(Sender: TObject);
var
  lNumero: Integer;
begin
  if FIndiceEdicao >= 0 then
    begin
      ShowMessage('Conclua a atualização do item antes de gravar o pedido.');
      edtQuantidade.SetFocus;
      Exit;
    end;

  if FPedido.Numero = 0 then
    FPedido.DataEmissao := Now;

  try
    lNumero := FService.Gravar(FPedido);
  except
    on E: Exception do
      begin
        ShowMessage('Não foi possível gravar o pedido: ' + E.Message);
        Exit;
      end;
  end;

  ShowMessage(Format('Pedido %d gravado com sucesso.', [lNumero]));
  NovoPedido;
end;

procedure TfrmPedido.BuscarCliente;
var
  lCodigo: Integer;
  lCliente: TCliente;
begin
  if not Assigned(FService) then
    Exit;

  if Trim(edtCodCliente.Text) = '' then
    begin
      LimparCliente;
      Exit;
    end;

  lCodigo := StrToIntDef(Trim(edtCodCliente.Text), 0);

  if (lCodigo > 0) and (lCodigo = FPedido.Cliente.Codigo) then
    Exit;

  try
    lCliente := FService.BuscarCliente(lCodigo);
  except
    on E: Exception do
      begin
        LimparCliente;
        ShowMessage(E.Message);
        edtCodCliente.SetFocus;
        Exit;
      end;
  end;

  try
    edtCodCliente.Text := IntToStr(lCliente.Codigo);
    edtNomeCliente.Text := lCliente.Nome;
    edtCidade.Text := lCliente.Cidade;
    edtUF.Text := lCliente.UF;

    FPedido.Cliente.Codigo := lCliente.Codigo;
  finally
    lCliente.Free;
  end;
end;

procedure TfrmPedido.BuscarPedido;
begin

end;

procedure TfrmPedido.BuscarProduto;
var
  lCodigo: Integer;
  lProduto: TProduto;
begin
  if not Assigned(FService) then
    Exit;

  if Trim(edtCodProduto.Text) = '' then
    begin
      edtDescricao.Clear;
      Exit;
    end;

  lCodigo := StrToIntDef(Trim(edtCodProduto.Text), 0);

  try
    lProduto := FService.BuscarProduto(lCodigo);
  except
    on E: Exception do
      begin
        edtCodProduto.Clear;
        edtDescricao.Clear;
        ShowMessage(E.Message);
        edtCodProduto.SetFocus;
        Exit;
      end;
  end;

  try
    edtCodProduto.Text := IntToStr(lProduto.Codigo);
    edtDescricao.Text := lProduto.Descricao;

    if Trim(edtQuantidade.Text) = '' then
      edtQuantidade.Text := '1';

    edtValorUnitario.Text := FormatFloat('0.00', lProduto.PrecoVenda);
  finally
    lProduto.Free;
  end;
end;

procedure TfrmPedido.ConfigurarGrid;
begin
  gridItens.Cells[0, 0] := 'Código';
  gridItens.Cells[1, 0] := 'Descrição';
  gridItens.Cells[2, 0] := 'Quantidade';
  gridItens.Cells[3, 0] := 'Vlr. Unitário';
  gridItens.Cells[4, 0] := 'Vlr. Total';

  gridItens.ColWidths[0] := 60;
  gridItens.ColWidths[1] := 330;
  gridItens.ColWidths[2] := 100;
  gridItens.ColWidths[3] := 100;
  gridItens.ColWidths[4] := 110;
end;

procedure TfrmPedido.EditarItem;
var
  lIndice: Integer;
  lItem: TPedidoItem;
begin
  lIndice := gridItens.Row - 1;

  if (lIndice < 0) or (lIndice >= FPedido.Itens.Count) then
    Exit;

  lItem := TPedidoItem(FPedido.Itens[lIndice]);

  edtCodProduto.Text := IntToStr(lItem.Produto.Codigo);
  edtDescricao.Text := lItem.Produto.Descricao;
  edtQuantidade.Text := FormatFloat('0.00', lItem.Quantidade);
  edtValorUnitario.Text := FormatFloat('0.00', lItem.VlrUnitario);

  FIndiceEdicao := lIndice;
  btnAdicionar.Caption := 'Atualizar';
  edtQuantidade.SetFocus;
end;

procedure TfrmPedido.edtCodClienteExit(Sender: TObject);
begin
  BuscarCliente();
end;

procedure TfrmPedido.edtCodProdutoExit(Sender: TObject);
begin
  BuscarProduto();
end;

procedure TfrmPedido.ExcluirItem;
var
  lIndice: Integer;
begin
  lIndice := gridItens.Row - 1;

  if (lIndice < 0) or (lIndice >= FPedido.Itens.Count) then
    Exit;

  if MessageDlg('Deseja excluir o item selecionado?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  FPedido.RemoverItem(lIndice);

  if FIndiceEdicao = lIndice then
    LimparProduto
  else if FIndiceEdicao > lIndice then
    Dec(FIndiceEdicao);

  AtualizarGrid;
end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  TConexao.Instance.Connect();
  FPedido := TPedido.Create;
  FService := TPedidoService.Create;
  FIndiceEdicao := -1;

  ConfigurarGrid;
  AtualizarGrid;
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  TConexao.ReleaseInstance();
  FreeAndNil(FPedido);
  FreeAndNil(FService);
end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
  if TConexao.Instance.GetConnection.Connected then
    statConexao.Panels[0].Text := 'Conectado!'
  else
    statConexao.Panels[0].Text := 'Erro ao conectar!';
end;

procedure TfrmPedido.gridItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN:
      begin
        Key := 0;
        EditarItem;
      end;
    VK_DELETE:
      begin
        Key := 0;
        ExcluirItem;
      end;
  end;
end;

procedure TfrmPedido.LimparCliente;
begin
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  edtCidade.Clear;
  edtUF.Clear;
  FPedido.Cliente.Codigo := 0;
end;

procedure TfrmPedido.LimparProduto;
begin
  edtCodProduto.Clear;
  edtDescricao.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  FIndiceEdicao := -1;
  btnAdicionar.Caption := 'Inserir';
end;

procedure TfrmPedido.NovoPedido;
begin
  FreeAndNil(FPedido);
  FPedido := TPedido.Create;

  edtNumero.Clear;
  edtDataEmissao.Clear;
  LimparCliente;
  LimparProduto;
  AtualizarGrid;

  if edtCodCliente.CanFocus then
    edtCodCliente.SetFocus;
end;

end.
