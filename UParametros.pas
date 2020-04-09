unit UParametros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  parametros;

type
  TfrmParametros = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    btnGravar: TBitBtn;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbRepetirPalavras: TCheckBox;
    cbParMesclaPalavrasDia: TCheckBox;
    cbOrdenarPalavras: TCheckBox;
    cbPalavrasAleatorias: TCheckBox;
    cbExibirSomenteAudio: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmParametros: TfrmParametros;

implementation

{$R *.dfm}

procedure TfrmParametros.btnGravarClick(Sender: TObject);
var
par : TParametros;
begin
  par := TParametros.Create;

  try
    if RadioGroup1.ItemIndex = 0 then
      par.tpLetras:=1
    else
      par.tpLetras:=2;

    if RadioGroup2.ItemIndex = 0 then
      par.apresentacaoPalavras :=1  
    else
    if RadioGroup2.ItemIndex = 1 then
       par.apresentacaoPalavras := 4
    else
      if RadioGroup2.ItemIndex = 2 then
        par.apresentacaoPalavras := 8
      else
        par.apresentacaoPalavras := 12; 

    par.filtroInicial      := StrToInt(Edit1.Text);
    par.filtroFinal        := StrToInt(Edit2.Text);
    par.repetirPalavras    := cbRepetirPalavras.Checked;
    par.palavrasAleatorias := cbPalavrasAleatorias.Checked;
    par.dividePalavrasDia  := cbParMesclaPalavrasDia.Checked;  
    par.ordenarPalavras    := cbOrdenarPalavras.Checked;
    par.somenteAudio       := cbExibirSomenteAudio.Checked;

    par.recordObject;

    MessageDlg('Registro gravado com sucesso!'+#13+'Inicie o programa novamente.',mtInformation,[mbOK],0);

    close;
  
  finally
    FreeAndNil(par);
  end;
     

end;

procedure TfrmParametros.FormShow(Sender: TObject);
var
  par: Tparametros;
begin

  par := Tparametros.Create;

  try
    par.setObject();

    cbRepetirPalavras.Checked      := (par.repetirPalavras);
    cbParMesclaPalavrasDia.Checked := (par.dividePalavrasDia);
    cbOrdenarPalavras.Checked      := (par.ordenarPalavras);
    cbPalavrasAleatorias.Checked   := (par.palavrasAleatorias);
    cbExibirSomenteAudio.Checked   := (par.somenteAudio);

    if par.tpLetras = 1 then
      RadioGroup1.ItemIndex := 0
    else
      RadioGroup1.ItemIndex :=1;  

    case par.apresentacaoPalavras of
  
      1  : RadioGroup2.ItemIndex  := 0;  
      4  : RadioGroup2.ItemIndex  := 1;
      8  : RadioGroup2.ItemIndex  := 2;
      12 : RadioGroup2.ItemIndex  := 3;
  
    end;

    Edit1.Text := IntToStr(par.filtroInicial);
    Edit2.Text := IntToStr(par.filtroFinal);
  
  finally
    FreeAndNil(par);
  end;

end;

end.
