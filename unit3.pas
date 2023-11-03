unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, Buttons;

type

  { TDetalhesPokemon }

  TDetalhesPokemon = class(TForm)
    Image1: TImage;
    LHP: TLabel;
    LATK: TLabel;
    LDEF: TLabel;
    LSPD: TLabel;
    LEXP: TLabel;
    LabelTipo1: TLabel;
    LbNomePokemon: TLabel;
    Panel1: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    ShapePokemon: TShape;
    SHP: TShape;
    SATK: TShape;
    SDEF: TShape;
    SpeedButton1: TSpeedButton;
    SSPD: TShape;
    SEXP: TShape;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private


  public

  end;

var
  DetalhesPokemon: TDetalhesPokemon;

implementation

{$R *.lfm}

uses

  Unit1;

{ TDetalhesPokemon }

procedure TDetalhesPokemon.FormCreate(Sender: TObject);
begin
  LabelTipo1.caption:=Pokedex.tipo;
  LbNomePokemon.caption:=Pokedex.nome;

  SHP.Width :=Pokedex.hp;
  SATK.Width:=Pokedex.atk;
  SDEF.Width:=Pokedex.def;
  SEXP.Width:=Pokedex.exp;
  SSPD.Width:=Pokedex.spd;
  LHP.caption:=inttostr(Pokedex.hp);
  LATK.caption:=inttostr(Pokedex.atk);
  LDEF.caption:=inttostr(Pokedex.def);
  LEXP.caption:=inttostr(Pokedex.exp);
  LSPD.caption:=inttostr(Pokedex.spd);


if LabelTipo1.caption ='fire' then

    begin
    ShapePokemon.Brush.Color := clred;
    end
  else
    if LabelTipo1.caption = 'grass' then
      begin
       ShapePokemon.Brush.Color := clgreen;
      end
      else
       if LabelTipo1.caption = 'electric' then
         begin
        ShapePokemon.Brush.Color := clyellow;
         end
          else
           if LabelTipo1.caption = 'water' then
             begin
          ShapePokemon.Brush.Color := clAqua;
             end
             else
              if LabelTipo1.caption = 'ghost' then
               begin
                ShapePokemon.Brush.Color := $00D6C7CA; ;
               end
               else
                begin
                  ShapePokemon.Brush.Color:=clMoneyGreen;
               end;
end;

procedure TDetalhesPokemon.SpeedButton1Click(Sender: TObject);
begin
  Close;
  Pokedex.Show;
end;

end.

