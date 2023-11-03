unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient, Forms, Controls, Graphics,
  Dialogs,ExtCtrls, Buttons, RESTRequest4D,
  jsonparser, fpjson, opensslsockets, unit3;

type

  { TPokedex }

  TPokedex = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);

  private

  public

  image,nome,habilidade,tipo:string;
  atk,def,spd,hp,exp,sdef:integer;


  function DownloadFile(Url, DestFile: string): Boolean;
  function NomePokemon(NumeroPokemon: Integer): string;
  procedure ImagemClique (Sender: TObject);
  end;

var
  Pokedex: TPokedex;

implementation

{$R *.lfm}

{ TPokedex }

procedure TPokedex.FormCreate(Sender: TObject);
var
  i: Integer;
  SpeedButton: TSpeedButton;
  PNG: TPortableNetworkGraphic;
  pokemonName: string;
  esquerda, cima: integer;

begin
  esquerda := 20;
  cima := 40;

  i := 1;

  while i <= 150 do
  begin
    SpeedButton := TSpeedButton.Create(Self);
    PNG := TPortableNetworkGraphic.Create;
    nome := IntToStr(i);
    pokemonName := NomePokemon(i);

    if not FileExists('img/' + nome + '.png') then
    begin
      DownloadFile('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' + IntToStr(i) + '.png', 'img/' + nome + '.png');
    end
    else

    with SpeedButton do
    begin
      PNG.LoadFromFile('img/' + nome + '.png');
      Glyph.Assign(PNG);
      Parent := ScrollBox1;
      Name := 'SpeedButton_' + nome;
      Flat := true;
      Height := 144;
      Width := 300;
      Left := esquerda;
      Top := cima;
      AutoSize := True;
      Layout:= blGlyphTop;
      OnClick := @ImagemClique;
      Tag := i;
      Caption := pokemonName;
      Visible := True;

      if i mod 6 = 0 then
      begin
        cima := cima + 120;
        esquerda := 24;
      end
      else
      begin
        esquerda := esquerda + 150;
      end;
    end;
    Inc(i);
  end;
end;

procedure TPokedex.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

function TPokedex.DownloadFile(Url, DestFile: string): Boolean;
var
  HTTPClient: TFPHTTPClient;
  FileName: string;
begin

    Result := True;
  try

      HTTPClient := TFPHTTPClient.Create(nil);
      try

        FileName := DestFile;

        try
          HTTPClient.Get(URL, FileName);
        except
          on E: Exception do
            ShowMessage('Falha no download: ' + E.Message);
        end;
      finally
        HTTPClient.Free;
      end;

  except
    Result := False;
  end;

end;

function TPokedex.NomePokemon(NumeroPokemon: Integer): string;
var
  LResponse: IResponse;
  Json: TJSONData;
begin
  LResponse := TRequest.New.BaseURL('https://pokeapi.co/api/v2/pokemon/' + IntToStr(NumeroPokemon) + '/')
    .Accept('application/json')
    .Get;

  if LResponse.StatusCode = 200 then
  begin
    Json := GetJSON(LResponse.Content);
    Result := Json.FindPath('name').AsString;
  end
  else
    Result := 'Pokemon ' + IntToStr(NumeroPokemon);

end;
procedure TPokedex.ImagemClique(Sender: TObject);
var
  NomeDaImagem  : string;
  LResponse: IResponse;
  i: Integer;
  Json: TJSONData;
  DetalhesPokemon: TDetalhesPokemon;
begin
  if Sender is TSpeedButton then
  begin
    NomeDaImagem := IntToStr(TSpeedButton(Sender).Tag);

    LResponse := TRequest.New.BaseURL('https://pokeapi.co/api/v2/pokemon/' + NomeDaImagem   + '/')
      .Accept('application/json')
      .Get;

    Json := GetJSON(LResponse.Content);
    nome := Json.FindPath('forms[0].name').AsString;
    habilidade := '';


    if not FileExists('img/' + NomeDaImagem  + '.png') then
    begin
      DownloadFile('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' + NomeDaImagem   + '.png', 'img/' + NomeDaImagem   + '.png');
    end;
    for i := 0 to 6 do
    habilidade := habilidade + Json.FindPath('moves[' + IntToStr(i) + '].move.name').AsString + #13;

    tipo:= Json.FindPath('types[0].type.name').asstring;
    hp:=json.findpath('stats[0].base_stat').asinteger;
    atk:=json.findpath('stats[1].base_stat').asinteger;
    def:=json.findpath('stats[2].base_stat').asinteger;
    exp:=json.findpath('stats[3].base_stat').asinteger;
    sdef:=json.findpath('stats[4].base_stat').asinteger;
    spd:=json.findpath('stats[5].base_stat').asinteger;

    DetalhesPokemon := TDetalhesPokemon.Create(Self);
    DetalhesPokemon.Image1.Picture.LoadFromFile('img/' + NomeDaImagem  + '.png');
    DetalhesPokemon.ShapePokemon.Color := clNavy;
    DetalhesPokemon.Show;

    Pokedex.Hide;
  end;
end;

end.

