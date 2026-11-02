unit uConexao;

interface

uses
  System.SysUtils, System.IniFiles,
  Vcl.Forms,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Phys.FB, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.FBDef, FireDAC.Stan.Intf,
  FireDAC.Phys.Intf;

type
  TConexao = class
  private
    FConfig: TIniFile;
    FConnection: TFDConnection;
    FDriverLink: TFDPhysFBDriverLink;

    class var FInstance: TConexao;
    class function GetInstance: TConexao; static;
    constructor CreatePrivate;
  public
    class procedure ReleaseInstance;
    destructor Destroy; override;

    class property Instance: TConexao read GetInstance;

    procedure Connect;
    procedure Disconnect;

    function GetConnection: TFDConnection;
  end;

implementation

{ TConexao }

procedure TConexao.Connect;
begin
  Disconnect();
  FConnection.Params.Clear;
  FConnection.Params.DriverID := 'FB';
  FConnection.Params.Database := ExtractFilePath(Application.ExeName) + FConfig.ReadString('Database', 'Database', '');
  FConnection.Params.UserName := FConfig.ReadString('Database', 'Username', '');
  FConnection.Params.Password := FConfig.ReadString('Database', 'Password', '');
  FConnection.Params.Values['Server'] := FConfig.ReadString('Database', 'Server', '');
  FConnection.Params.Values['Port'] := FConfig.ReadString('Database', 'Port', '3050');
  FConnection.Params.Values['Protocol'] := 'TCPIP';
  FConnection.Params.Values['CharacterSet'] := 'UTF8';
  FConnection.LoginPrompt := False;

  try
    FConnection.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Error: ' + E.Message);
  end;
end;

constructor TConexao.CreatePrivate;
var
  lCaminhoINI: string;
begin
  inherited Create;

  lCaminhoINI := ExtractFilePath(Application.ExeName) + 'config.ini';

  if not FileExists(lCaminhoINI) then
    raise Exception.Create('Arquivo config.ini não encontrado!');

  FConfig := TIniFile.Create(lCaminhoINI);

  FDriverLink := TFDPhysFBDriverLink.Create(nil);
  FDriverLink.VendorLib := ExtractFilePath(Application.ExeName) + FConfig.ReadString('Database', 'ClientLibrary', '');

  FConnection := TFDConnection.Create(nil);
end;

destructor TConexao.Destroy;
begin
  FreeAndNil(FConnection);
  FreeAndNil(FDriverLink);
  FreeAndNil(FConfig);
  inherited;
end;

procedure TConexao.Disconnect;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
end;

function TConexao.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

class function TConexao.GetInstance: TConexao;
begin
  if not Assigned(FInstance) then
    FInstance := TConexao.CreatePrivate;
  Result := FInstance;
end;

class procedure TConexao.ReleaseInstance;
begin
  FreeAndNil(FInstance);
end;

end.
