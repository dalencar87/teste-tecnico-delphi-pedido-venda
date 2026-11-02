unit uFrmPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase,
  Data.DB, FireDAC.Comp.Client, Vcl.ComCtrls;

type
  TfrmPedido = class(TForm)
    statConexao: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPedido: TfrmPedido;

implementation

uses
  uConexao;

{$R *.dfm}

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  TConexao.Instance.Connect();
end;

procedure TfrmPedido.FormDestroy(Sender: TObject);
begin
  TConexao.ReleaseInstance();
end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
  if TConexao.Instance.GetConnection.Connected then
    statConexao.Panels[0].Text := 'Conectado! ' + ' Database: ' + TConexao.Instance.GetConnection.Params.Database
  else
    statConexao.Panels[0].Text := 'Erro ao conectar!';
end;

end.
