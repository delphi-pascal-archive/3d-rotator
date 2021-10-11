unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, Opengl;

type
  Tpt = record
    X:integer;
    Y:integer;
    Z:integer;
    X2d:integer;
    Y2d:integer;
  end;
  TLn = record
    Num1:integer;
    Num2:integer;
  end;
  TOptions = record
    ShowPoint:boolean;
    ShowLn:boolean;
  end;

  TBoucle = class(TThread)
  private
    procedure Affiche();
  protected
    procedure Execute();override;
  public
    constructor Create();
  end;

  TfMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel5: TPanel;
    PopupMenu1: TPopupMenu;
    Ajouterunpoint1: TMenuItem;
    Supprimerlepoint1: TMenuItem;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    Nouvelobjet1: TMenuItem;
    Enregistrerlobjet1: TMenuItem;
    Chargerunobjet1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    Aide1: TMenuItem;
    Apropos1: TMenuItem;
    Creerunearrte1: TMenuItem;
    Fond: TPaintBox;
    Fond1: TPaintBox;
    Fond2: TPaintBox;
    Panel6: TPanel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    ENum: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EPosX: TEdit;
    EPosY: TEdit;
    EPosZ: TEdit;
    Label6: TLabel;
    EListeLiaisons: TListBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ESelNum: TComboBox;
    Edition1: TMenuItem;
    Agrandirlobjetx21: TMenuItem;
    Reduirelobjet21: TMenuItem;
    Vue3D1: TMenuItem;
    Afficherlespoints1: TMenuItem;
    Afficherlesarrtes1: TMenuItem;
    N2: TMenuItem;
    Centrerlobjet1: TMenuItem;
    procedure Ajouterunpoint1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Fond1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Fond2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4Resize(Sender: TObject);
    procedure Panel5Resize(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure Fond1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Fond1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Fond2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Fond2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Creerunearrte1Click(Sender: TObject);
    procedure Enregistrerlobjet1Click(Sender: TObject);
    procedure Chargerunobjet1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Nouvelobjet1Click(Sender: TObject);
    procedure EPosXExit(Sender: TObject);
    procedure EPosXKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ESelNumChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Supprimerlepoint1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure FondMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure Agrandirlobjetx21Click(Sender: TObject);
    procedure Reduirelobjet21Click(Sender: TObject);
    procedure Afficherlespoints1Click(Sender: TObject);
    procedure Afficherlesarrtes1Click(Sender: TObject);
    procedure Centrerlobjet1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    procedure AjouterPoint(X,Y,Z:integer);
    procedure AjouterArrete(num1,num2:integer);
    procedure SupprimerPoint(Num:integer);
    procedure SupprimerArrete(Num1,Num2:integer);
    Procedure DessinePoint(X,Y,Num:integer;Bmp:TBitmap);
    Procedure DessineArretes();
    Procedure SaveOBJ(LeFichier:string);
    Procedure LoadOBJ(LeFichier:string);
    procedure Init();
    procedure Pt2Param(UpDateListeLiaison:boolean);
    procedure Param2Pt();
    procedure UpdateListePoint();
    procedure Active(Mode:boolean);
    function Distance(X,Y,X2,Y2:integer):integer;
    procedure Load3dstudio(LeFichier:string);
    function TestArrete(Num1,Num2:integer):boolean;
    function ExtraiChiffreApres(Source:string;Dep:integer):integer;

  end;

var
  fMain: TfMain;
  Points:array of Tpt; //table des points
  Lignes:array of Tln; //table des arretes
  TmpBmp,TmpBmp1,TmpBmp2:TBitmap; //buffer des images
  PClickX,PClickY,Pkel:integer; //c plus
  CentreX,CentreY,CentreX1,CentreY1,CentreX2,CentreY2:integer; //centre de chaque graph
  SelPoint,ActPoint,SurvolPoint:integer; //le point selectionné, le point actif pour déplacement et le point ki est survolé
  TaillePoints:integer; //taille des points
  Zoom:integer; //le zoom
  IncAngle1,IncAngle2:integer;
  Options:Toptions;

implementation

uses newarrete, propos, FctStr;

{$R *.dfm}

{ TfMain }
function ExtraireTexte(Source:string;TexteDep:string;Limites:string;Depart:integer;var Deb:integer; var Longueur:integer):string;
var
a,b:integer;
Fin:integer;
TmpS:string;
BVal:boolean;
begin
Result:='';
if Source='' then exit; //faut ki est kelke chose sinon ca va pas ;)

//cherche TexteDep dans Source
a:=Depart;
BVal:=true;
while BVal do begin
    //dès k'il trouve
    if copy(Source,a,Length(TexteDep))=TexteDep then begin
        BVal:=false;//arrête le boucle
        Depart:=a;//change le dépat
    end;
    //si c a la fin, ben alors il a rien trouvé, terminé
    if (a>=Length(Source)) and (BVal=true) then begin
        BVal:=false;
        exit;
    end;
    inc(a,1);//incrémente
end;


//Cherche le début (Deb)
a:=Depart;
BVal := true;
while BVal=true do begin
    //cherche un caractère limite
    TmpS := copy(Source,a,1);
    for b:=1 to Length(Limites) do begin
        if copy(Limites,b,1)=TmpS then begin
            BVal:=false;//y'en a un, on a trouvé le début
            a:=a+2;
        end;
    end;
    dec(a,1);
    if a<1 then begin
        BVal:=false;//on est au bout :)
        a:=a+1;
    end;
end;
Deb:=a;

//Cherche la fin (Fin)
a:=Depart;
BVal:=true;
while BVal=true do begin
    //cherche un caractère limite
    TmpS := copy(Source,a,1);
    for b:=1 to Length(Limites) do begin
        if copy(Limites,b,1)=TmpS then begin
            BVal:=false;//y'en a un, on a trouvé le début
            a:=a-1;
        end;
    end;
Inc(a,1);
    if TmpS='' then begin
        BVal:=false;//on est au bout :)
        a:=a-1;
    end;
end;
Fin:=a;

Longueur := Fin-Deb;
//prend le morceu
Result := copy(Source,Deb,Fin-Deb);

end;

procedure TfMain.AjouterPoint(X, Y, Z: integer); //ajoute un point
var
Num:integer;
begin
setlength(Points,length(Points)+1); //augmente le tbl
Num := Length(Points)-1;
Points[Num].X := X;
Points[Num].Y := Y;
Points[Num].Z := Z;
UpdateListePoint;
end;

procedure TfMain.Ajouterunpoint1Click(Sender: TObject);
begin

if Pkel = 1 then AjouterPoint(PClickX-CentreX1,PClickY-CentreY1,0) else AjouterPoint(PClickX-CentreX2,0,PClickY-CentreY2);
end;

procedure TfMain.DessinePoint(X, Y, Num: integer; Bmp: TBitmap); //dessine un point
var
Couleur:TColor;
begin
Bmp.Canvas.Lock;
if Num = SelPoint then Couleur := clRed;
if Num = SurvolPoint then Couleur := clyellow;
if (Num<>SelPoint) and (Num<>SurvolPoint) then  Couleur := clwhite;


Bmp.Canvas.Brush.Color := Couleur;
Bmp.Canvas.Pen.Color := Couleur;

Bmp.Canvas.Ellipse(X-TaillePoints,Y-TaillePoints,X+TaillePoints,Y+TaillePoints);
Bmp.Canvas.Unlock;

end;

procedure TfMain.AjouterArrete(num1, num2: integer); //ajoute une arrete
var
num:integer;
begin
SetLength(Lignes,Length(Lignes)+1);
Num := Length(Lignes)-1;
Lignes[Num].Num1 := Num1;
Lignes[Num].Num2 := Num2;
end;

procedure TfMain.DessineArretes; //dessine les arretes
var
a:integer;
DepPos:TPoint;
begin
TmpBmp.Canvas.Brush.Color := clwhite;
TmpBmp.Canvas.pen.Color := clwhite;
a:=0;
while a<= Length(Lignes)-1 do begin
if a>Length(Lignes) then exit;
DepPos.X := Points[Lignes[a].Num1].X2d;
DepPos.Y := Points[Lignes[a].Num1].Y2d;
TmpBmp.Canvas.PenPos := DepPos;

TmpBmp.Canvas.LineTo(Points[Lignes[a].Num2].X2d,Points[Lignes[a].Num2].Y2d);
inc(a,1);
end;

end;

procedure TfMain.LoadOBJ(LeFichier:string); //chage un objet
var
Fichier:TextFile;
a,b:integer;
TmpS:string;
begin
init;
AssignFile(Fichier,LeFichier);
Reset(Fichier);
readln(Fichier,TmpS);
SetLength(Points,strtoint(TmpS));
for a:=0 to Length(Points)-1 do begin
 readln(Fichier,TmpS);
 Points[a].X := strtoint(TmpS);
 readln(Fichier,TmpS);
 Points[a].Y := strtoint(TmpS);
 readln(Fichier,TmpS);
 Points[a].Z := strtoint(TmpS);
end;
readln(Fichier,TmpS);
SetLength(Lignes,strtoint(TmpS));
for a:=0 to Length(Lignes)-1 do begin
 readln(Fichier,TmpS);
 Lignes[a].num1 := strtoint(TmpS);
 readln(Fichier,TmpS);
 Lignes[a].num2 := strtoint(TmpS);
end;
closeFile(Fichier);
UpdateListePoint;
end;

procedure TfMain.SaveOBJ(LeFichier:string); //sauve un objet
var
Fichier:TextFile;
a:integer;
begin
//test si bonne extention
if lowercase(right(LeFichier,4))<>'.3dr' then Lefichier := Lefichier + '.3dr';

AssignFile(Fichier,LeFichier); //ouvre fichier
Rewrite(Fichier);
writeln(Fichier,Length(Points)); //écri nombre points
for a:=0 to Length(Points)-1 do begin //écri chaque point
 writeln(Fichier,inttostr(Points[a].X));
 writeln(Fichier,inttostr(Points[a].Y));
 writeln(Fichier,inttostr(Points[a].Z));
end;
writeln(Fichier,Length(Lignes)); //nombre lignes
for a:=0 to Length(Lignes)-1 do begin
 writeln(Fichier,inttostr(Lignes[a].num1));
 writeln(Fichier,inttostr(Lignes[a].num2));
end;
closeFile(Fichier);

end;

procedure TfMain.Param2Pt; //Paramètres au point
var
I:integer;
Code:integer;
begin
if SelPoint=-1 then exit; // si aucuns point alors kit
val(EPosX.text,I,Code);
Points[SelPoint].X := I;
val(EPosY.text,I,Code);
Points[SelPoint].Y := I;
val(EPosZ.text,I,Code);
Points[SelPoint].Z := I;
end;

procedure TfMain.Pt2Param(UpDateListeLiaison:boolean); //Point au paramètres
var
a:integer;
begin
if SelPoint = -1 then begin //si aucuns sel
 Active(false); //enable:=false sur les param
 exit;
 end else Active(true); //sinon true
ENum.Caption := 'Point N°' + inttostr(SelPoint+1); //affiche param
EPosX.Text := inttostr(Points[SelPoint].X);
EPosY.text := inttostr(Points[SelPoint].Y);
EPosZ.Text := inttostr(Points[SelPoint].Z);
ESelNum.ItemIndex := SelPoint;
if UpDateListeLiaison then begin //si demande d'actualisation de la liste
 EListeLiaisons.Clear;
 for a:=0 to Length(Lignes)-1 do begin
  if Lignes[a].Num1 = SelPoint then EListeLiaisons.Items.Add(inttostr(Lignes[a].Num2+1));
  if Lignes[a].Num2 = SelPoint then EListeLiaisons.Items.Add(inttostr(Lignes[a].Num1+1));
 end;
end;

end;

procedure TfMain.Init; //initialize les paramètres
begin
SetLength(Points,0);
SetLength(Lignes,0);
SurvolPoint := -1;
ActPoint := -1;
SelPoint := -1;
Zoom := 256;
IncAngle1 := 1;
IncAngle2 := 1;

end;

procedure TfMain.UpdateListePoint; //Met a jour le combo des points
var
a:integer;
begin
ESelNum.Clear;
for a:=0 to Length(Points) -1 do
 ESelNum.Items.Add(inttostr(a+1));

end;

procedure TfMain.SupprimerArrete(Num1, Num2: integer); //supprime une arrête
var
a,b:integer;
begin
for a:=0 to length(Lignes)-1 do begin
 if ((Lignes[a].Num1 = Num1) and (Lignes[a].Num2 =Num2)) or ((Lignes[a].Num1 = Num2) and (Lignes[a].Num2 =Num1)) then begin
  for b := a+1 to Length(Lignes)-1 do Lignes[b-1] := Lignes[b];
  SetLength(Lignes,Length(Lignes)-1);
 end;
end;


end;

procedure TfMain.SupprimerPoint(Num: integer); //supprime un point
var
a:integer;
begin
 for a := Num+1 to Length(Points)-1 do Points[a-1] := Points[a];
 SetLength(Points,Length(Points)-1);

 for a:=0 to Length(Lignes)-1 do begin //ici, ca décale les lignes ki sont liés
  if Lignes[a].Num1>=Num then Lignes[a].Num1:=Lignes[a].Num1-1;
  if Lignes[a].Num2>=Num then Lignes[a].Num2:=Lignes[a].Num2-1;
 end;
end;

procedure TfMain.Active(Mode: boolean); //active/desactive les param
begin
if Mode = false then begin
  EPosX.Enabled := false;
  EPosY.Enabled := false;
  EPosZ.Enabled := false;
  EListeLiaisons.Enabled := false;
  Button1.Enabled := false;
  Button2.Enabled := false;
  Button3.Enabled := false;

 end else begin
  EPosX.Enabled := true;
  EPosY.Enabled := true;
  EPosZ.Enabled := true;
  EListeLiaisons.Enabled := true;
  Button1.Enabled := true;
  Button2.Enabled := true;
  Button3.Enabled := true;

end;

end;

function TfMain.Distance(X, Y, X2, Y2: integer): integer;
begin
result := round(sqrt(sqr(X2-X)+sqr(Y2-Y)));
end;

procedure TfMain.Load3dstudio(LeFichier: string);
const
decalage=0;
var
Fichier:TextFile;
TmpS,TmpS2:string;
Deb,Long:integer;
a:integer;
n1,n2,n3:integer;
l1,l2,l3:integer;
stop:boolean;
begin
init();
a:=0;
AssignFile(Fichier,LeFichier);
reset(Fichier);
stop:=false;
TmpS := '';
repeat       //charge points
if EOF(Fichier) then stop:=true;
if instr(1,TmpS,'Vertex')=0 then
  readln(Fichier,TmpS)
 else begin
  if ExtraireTexte(TmpS,'X',' ',1,Deb,Long)<>'' then begin
    SetLength(Points,Length(Points)+1);
    TmpS2 := ExtraireTexte(TmpS,'X',' ',1,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    Points[Length(Points)-1].X := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'Y',' ',1,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    Points[Length(Points)-1].Y := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'Z',' ',1,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    Points[Length(Points)-1].Z := strtoint(TmpS2);
  end;
  readln(Fichier,TmpS);
end;

until stop=true;
TmpS := '';
stop := false;
closefile(Fichier);
AssignFile(Fichier,LeFichier);
reset(Fichier);
repeat //charge lignes
if EOF(Fichier) then stop:=true;
//readln(Fichier,TmpS);
//showmessage(TmpS);
if instr(1,TmpS,'Face')=0 then
  readln(Fichier,TmpS)
 else begin
  if ExtraireTexte(TmpS,'CA',' ',1,Deb,Long)<>'' then begin
    TmpS2 := ExtraireTexte(TmpS,'A',' ',1,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    n1 := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'B',' ',Deb+Long,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    n2 := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'C',' ',Deb+Long,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    n3 := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'AB',' ',Deb+Long,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    l1 := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'BC',' ',Deb+Long,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS,Deb));
    l2 := strtoint(TmpS2);

    TmpS2 := ExtraireTexte(TmpS,'CA',' ',Deb+Long,Deb,Long);
    TmpS2 := inttostr(ExtraiChiffreApres(TmpS+' DE',Deb));
    l3 := strtoint(TmpS2);
    //showmessage(TmpS2);

    if (TestArrete(n1,n2)=false) and (l1=1) then begin
     SetLength(Lignes,Length(Lignes)+1);
     Lignes[Length(Lignes)-1].Num1 := n1;
     Lignes[Length(Lignes)-1].Num2 := n2;
    end;
    if (TestArrete(n2,n3)=false) and (l2=1) then begin
     SetLength(Lignes,Length(Lignes)+1);
     Lignes[Length(Lignes)-1].Num1 := n2;
     Lignes[Length(Lignes)-1].Num2 := n3;
    end;
    if (TestArrete(n3,n1)=false) and (l3=1) then begin
     SetLength(Lignes,Length(Lignes)+1);
     Lignes[Length(Lignes)-1].Num1 := n3;
     Lignes[Length(Lignes)-1].Num2 := n1;
    end;
  end;
   readln(Fichier,TmpS);
end;

until stop=true;
beep;
closefile(Fichier);
Pt2Param(false);
UpdateListePoint;
end;

function TfMain.TestArrete(Num1, Num2: integer):boolean;
var
a:integer;
begin
Result := false;
for a:=0 to Length(Lignes)-1 do begin
  if (Lignes[a].Num1 = Num1) and (Lignes[a].Num2 = Num2) then Result := true;
  if (Lignes[a].Num2 = Num1) and (Lignes[a].Num1 = Num2) then Result := true;

end;
end;

function TfMain.ExtraiChiffreApres(Source: string; Dep: integer): integer;
var
a:integer;
valu:char;
num:string;
premier:boolean;
begin
Num :='';
Result := 0;
premier:=false;

for a:=Dep to Length(Source)-1 do begin
 valu := mid(Source,a,1)[1];

 if ((Ord(valu)>=48) and (Ord(valu)<=57)) or (Ord(valu)=45)  then begin
   num := num + Valu;
   premier:=true;
 end else if premier=true then begin
   Result := strtoint(num);
   exit;
 end;


end;

end;

{ TBoucle }


procedure TBoucle.Affiche; //affiche les graph
begin
fMain.Fond.Canvas.Draw(0,0,TmpBmp);

fMain.Fond1.Canvas.Draw(0,0,TmpBmp1);
fMain.Fond2.Canvas.Draw(0,0,TmpBmp2);

end;

constructor TBoucle.Create;
begin
  FreeOnTerminate := True;
  inherited Create(false);
  Priority := tplowest;
end;


procedure TBoucle.Execute; //boucle principale
var
a:integer;
Val1,Val2,Val3:integer;
nX,nY,nZ:real;
Angle1,Angle2,Angle3:integer;
s:array[0..359] of real;
c:array[0..359] of real;

begin
  inherited;
TmpBmp := TBitmap.Create;
TmpBmp1 := TBitmap.Create;
TmpBmp2 := TBitmap.Create;

  Angle1:=0;
  Angle2:=0;
  Angle3:=0;

  Val1 := 256;


  For a := 0 To 359 do begin    //Pré-charge un tableau du cosinus et du sinus (plus rapide ke d'utilisé directement les fonctions in et cos)
   s[a] := Sin(a * (PI / 180));
   c[a] := Cos(a * (PI / 180));
  end;


  repeat
  //blok les canvas
  TmpBmp.Canvas.Lock;
  TmpBmp1.Canvas.Lock;
  TmpBmp2.Canvas.Lock;

  TmpBmp.Height := fMain.Fond.Height; //met a jour les dim
  TmpBmp.Width := fMain.Fond.Width;
  TmpBmp1.Height := fMain.Fond1.Height;
  TmpBmp1.Width := fMain.Fond1.Width;
  TmpBmp2.Height := fMain.Fond2.Height;
  TmpBmp2.Width := fMain.Fond2.Width;

  TmpBmp.Canvas.Brush.Color := 0; //efface
  TmpBmp.Canvas.Pen.Color := 0;
  TmpBmp.Canvas.Rectangle(0,0,TmpBmp.Width,TmpBmp.Height);
  TmpBmp1.Canvas.Brush.Color := 0;
  TmpBmp1.Canvas.Pen.Color := 0;
  TmpBmp1.Canvas.Rectangle(0,0,TmpBmp1.Width,TmpBmp1.Height);
  TmpBmp2.Canvas.Brush.Color := 0;
  TmpBmp2.Canvas.Pen.Color := 0;
  TmpBmp2.Canvas.Rectangle(0,0,TmpBmp2.Width,TmpBmp2.Height);

  Angle1 := (Angle1+IncAngle1) Mod 359;
  Angle2 := (Angle2+IncAngle2) Mod 359;

  if Angle1<0 then Angle1:=359;
  if Angle2<0 then Angle2:=359;
  a:=0;
  while a<= Length(Points)-1 do begin //pour chaque points
   with Points[a] do begin
   //----ROTATION----
     if a<=Length(Points)-1 then begin
     nz := -x*(c[Angle1]*c[Angle2])-y*(s[Angle1]*c[Angle2])-z*s[Angle2]+Val1;
     nx := (-x*s[Angle1]+y*c[Angle1])/nz;
     ny := (-x*(c[Angle1]*s[Angle2])-y*(s[Angle1]*s[Angle2])+z*c[Angle2])/nz;

   //---Projection 3D->2D---

     X2d := round(nx*Zoom)+CentreX;
     Y2d := round(ny*Zoom) +CentreY;
   //Affichage

     if Options.ShowLn then fMain.DessineArretes();
     if Options.ShowPoint then fMain.DessinePoint(X2d,Y2d,a,TmpBmp);

     fMain.DessinePoint(X+CentreX1,Y+CentreY1,a,TmpBmp1);

     fMain.DessinePoint(X+CentreX2,Z+CentreY2,a,TmpBmp2);

   end;
   end;
   inc(a,1);
  end;
  //affiche
  synchronize(Affiche);
  //déblok canvas
  TmpBmp.Canvas.UnLock;
  TmpBmp1.Canvas.UnLock;
  TmpBmp2.Canvas.UnLock;

  sleep(1); //attent un peu
  until false;

end;

procedure TfMain.FormCreate(Sender: TObject);
var
a:integer;
begin
TaillePoints := 3; //taile des points
Init(); //ini
Options.ShowPoint := true;
Options.ShowLn := true;
pt2Param(false);

TBoucle.Create;  //lance la boucle
end;

procedure TfMain.Fond1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
a:integer;
begin
//kan on klik sur le graph
Pkel := 1;
PClickX := X;
PClickY := Y;
for a:=0 to Length(Points)-1 do //test si y'a un point dessous la souris
  if (PClickX-CentreX1 > Points[a].X-TaillePoints) and (PClickX-CentreX1 < Points[a].X+TaillePoints) and (PClickY-CentreY1 > Points[a].Y-TaillePoints) and (PClickY-CentreY1 < Points[a].Y+TaillePoints) then begin
   SelPoint := a;
   ActPoint := a;
   Pt2Param(true);//affiche param
  end;


end;

procedure TfMain.Fond2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
a:integer;
begin

Pkel := 2;
PClickX := X;
PClickY := Y;
for a:=0 to Length(Points)-1 do
  if (PClickX-CentreX2 > Points[a].X-TaillePoints) and (PClickX-CentreX2 < Points[a].X+TaillePoints) and (PClickY-CentreY2 > Points[a].Z-TaillePoints) and (PClickY-CentreY2 < Points[a].Z+TaillePoints) then begin
    SelPoint := a;
    ActPoint := a;
    Pt2Param(true);
  end;

end;

procedure TfMain.Panel4Resize(Sender: TObject);
begin
CentreX2 := Fond2.Width div 2;
CentreY2 := Fond2.Height div 2;
end;

procedure TfMain.Panel5Resize(Sender: TObject);
begin
CentreX1 := Fond1.Width div 2;
CentreY1 := Fond1.Height div 2;

end;

procedure TfMain.Panel3Resize(Sender: TObject);
begin
CentreX := Fond.Width div 2;
CentreY := Fond.Height div 2;
end;

procedure TfMain.Fond1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
ActPoint:=-1;
end;

procedure TfMain.Fond1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
a:integer;
begin
//kan on bouge la souris sur le graph
if ActPoint<>-1 then begin //déplace un point si sel
  Points[SelPoint].X := X-CentreX1;
  Points[SelPoint].Y := Y-CentreY1;
  Pt2Param(false);
end;
Panel6.Caption := '';
SurvolPoint := -1;
for a:=0 to Length(Points)-1 do //met le point sous la souris en jaune
  if (X-CentreX1 > Points[a].X-TaillePoints) and (X-CentreX1 < Points[a].X+TaillePoints) and (Y-CentreY1 > Points[a].Y-TaillePoints) and (Y-CentreY1 < Points[a].Y+TaillePoints) then begin
   Panel6.Caption := inttostr(a+1);
   SurvolPoint := a;
  end;

end;

procedure TfMain.Fond2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
a:integer;
begin
if ActPoint<>-1 then begin
  Points[SelPoint].X := X-CentreX2;
  Points[SelPoint].Z := Y-CentreY2;
  Pt2Param(false);
end;
SurvolPoint := -1;
Panel6.Caption := '';
for a:=0 to Length(Points)-1 do
  if (X-CentreX2 > Points[a].X-TaillePoints) and (X-CentreX2 < Points[a].X+TaillePoints) and (Y-CentreY2 > Points[a].Z-TaillePoints) and (Y-CentreY2 < Points[a].Z+TaillePoints) then begin
   Panel6.Caption := inttostr(a+1);
   SurvolPoint := a;
  end;

end;

procedure TfMain.Fond2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
ActPoint:=-1;
end;

procedure TfMain.Creerunearrte1Click(Sender: TObject);
begin
//demande pour création d'arrête
fArrete.Show;
end;

procedure TfMain.Enregistrerlobjet1Click(Sender: TObject);
begin
if SaveDialog1.Execute then begin //enregistre
 SaveOBJ(SaveDialog1.FileName);
end;
end;

procedure TfMain.Chargerunobjet1Click(Sender: TObject);
begin
if OpenDialog1.Execute then begin //charge
 if uppercase(right(OpenDialog1.FileName,3))='ASC' then Load3dstudio(OpenDialog1.FileName)
  else if uppercase(right(OpenDialog1.FileName,3))='3DR' then LoadOBJ(OpenDialog1.FileName)
  else showmessage('Format non supporté');
end;
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
fArrete.Show; //demande pour creation d'arrete
fArrete.ComboBox1.ItemIndex := SelPoint;
end;

procedure TfMain.Nouvelobjet1Click(Sender: TObject);
begin
//nouvel objet
Init();
Pt2Param(false);
UpdateListePoint;
end;

procedure TfMain.EPosXExit(Sender: TObject);
begin
Param2Pt;
end;

procedure TfMain.EPosXKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
Param2Pt();
end;



procedure TfMain.ESelNumChange(Sender: TObject);
begin
SelPoint := ESelNum.ItemIndex;
Pt2Param(true);
end;

procedure TfMain.Button2Click(Sender: TObject);
begin
if EListeLiaisons.ItemIndex<0 then exit;
SupprimerArrete(SelPoint,strtoint(EListeLiaisons.Items.Strings[EListeLiaisons.itemindex])-1);
pt2param(true);

end;

procedure TfMain.Button3Click(Sender: TObject);
var
a:integer;
begin
for a:=0 to EListeLiaisons.Count-1 do
 SupprimerArrete(SelPoint,strtoint(EListeLiaisons.Items.Strings[a])-1);


SupprimerPoint(SelPoint);
SelPoint := -1;
UpDateListePoint;
pt2Param(false);
end;

procedure TfMain.PopupMenu1Popup(Sender: TObject);
begin
if SurvolPoint = -1 then Supprimerlepoint1.Enabled := false else Supprimerlepoint1.Enabled := true;
end;

procedure TfMain.Supprimerlepoint1Click(Sender: TObject);
begin
SelPoint := SurvolPoint;
pt2param(true);
Button3Click(sender);
end;

procedure TfMain.Quitter1Click(Sender: TObject);
begin
Close;
end;

procedure TfMain.Apropos1Click(Sender: TObject);
begin
apropos.show;
end;

procedure TfMain.FondMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
Dist,Dist1,Dist2,Dist3,Dist4:integer;
begin
Dist := Distance(CentreX,CentreY,X,Y);
Dist1 := Distance(CentreX,CentreY,X,CentreY);
Dist2 := Distance(CentreX,CentreY,CentreX,Y);

if (Dist < 80) and (Button = mbLeft) then Zoom := Zoom +20;
if (Dist < 80) and (Button = mbRight) and (Zoom>10) then Zoom := Zoom -20;
if (Dist > 80) and (Dist1>Dist2) and (X>CentreX) then IncAngle1 := IncAngle1 +1;
if (Dist > 80) and (Dist1>Dist2) and (X<CentreX) then IncAngle1 := IncAngle1 -1;
if (Dist > 80) and (Button = mbRight) and (Dist1>Dist2) then IncAngle1:=0;
if (Dist > 80) and (Dist2>Dist1) and (Y>CentreY) then IncAngle2 := IncAngle2 -1;
if (Dist > 80) and (Dist2>Dist1) and (Y<CentreY)  then IncAngle2 := IncAngle2 +1;
if (Dist > 80) and (Button = mbRight) and (Dist2>Dist1) then IncAngle2:=0;


end;

procedure TfMain.FormResize(Sender: TObject);
begin
Panel5.Width := Panel2.Width div 2;
end;



procedure TfMain.Agrandirlobjetx21Click(Sender: TObject);
var
a:integer;
begin
for a:=0 to length(Points)-1 do begin
Points[a].X := Points[a].X *2;
Points[a].Y := Points[a].Y *2;
Points[a].Z := Points[a].Z *2;

end;

end;

procedure TfMain.Reduirelobjet21Click(Sender: TObject);
var
a:integer;
begin
for a:=0 to length(Points)-1 do begin
Points[a].X := Points[a].X div 2;
Points[a].Y := Points[a].Y div 2;
Points[a].Z := Points[a].Z div 2;

end;

end;

procedure TfMain.Afficherlespoints1Click(Sender: TObject);
begin
Afficherlespoints1.Checked := not Afficherlespoints1.Checked;
Options.ShowPoint := Afficherlespoints1.Checked;
end;

procedure TfMain.Afficherlesarrtes1Click(Sender: TObject);
begin
Afficherlesarrtes1.Checked := not Afficherlesarrtes1.Checked;
Options.ShowLn := Afficherlesarrtes1.Checked;
end;

procedure TfMain.Centrerlobjet1Click(Sender: TObject);
var
a:integer;
Xmin,Xmax,Ymin,Ymax,Zmin,Zmax:integer;
DecX,DecY,DecZ:integer;
begin
Xmin := 0;
Xmax := 0;
Ymin := 0;
Ymax := 0;
Zmin := 0;
Zmax := 0;

for a:=0 to Length(Points)-1 do begin
if Points[a].X<Points[Xmin].X then Xmin := a;
if Points[a].X>Points[Xmax].X then Xmax := a;
if Points[a].Y<Points[Ymin].Y then Ymin := a;
if Points[a].Y>Points[Ymax].Y then Ymax := a;
if Points[a].Z<Points[Zmin].Z then Zmin := a;
if Points[a].Z>Points[Zmax].Z then Zmax := a;
end;

DecX := 0-(Points[Xmin].X+Points[Xmax].X) div 2;
DecY := 0-(Points[Ymin].Y+Points[Ymax].Y) div 2;
DecZ := 0-(Points[Zmin].Z+Points[Zmax].Z) div 2;

for a:=0 to Length(Points)-1 do begin
Points[a].X :=Points[a].X + DecX;
Points[a].Y :=Points[a].Y + DecY;
Points[a].Z :=Points[a].Z + DecZ;

end;

end;

end.

