program Rotator;

uses
  Forms,
  main in 'main.pas' {fMain},
  newarrete in 'newarrete.pas' {fArrete},
  propos in 'propos.pas' {apropos},
  FctStr in 'FctStr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '3D Rotator';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfArrete, fArrete);
  Application.CreateForm(Tapropos, apropos);
  Application.Run;
end.
