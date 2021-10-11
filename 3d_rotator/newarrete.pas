unit newarrete;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfArrete = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fArrete: TfArrete;

implementation

uses main;

{$R *.dfm}

procedure TfArrete.FormActivate(Sender: TObject);
var
a:integer;
begin
Combobox1.Clear;
Combobox2.Clear;
for a:=0 to Length(Points)-1 do begin
Combobox1.Items.Add(inttostr(a+1));
Combobox2.Items.Add(inttostr(a+1));
end;
end;

procedure TfArrete.Button1Click(Sender: TObject);
begin
fMain.AjouterArrete(Combobox1.ItemIndex,Combobox2.ItemIndex);
fMain.Pt2Param(true);
fArrete.Close;
end;

procedure TfArrete.Button2Click(Sender: TObject);
begin
fArrete.Close;
end;

end.

