unit FctStr;
interface
uses
Windows,Messages, SysUtils, Classes, Graphics,StdCtrls;
function RightTrim(const s:String):String;
function LeftTrim(const s:String):String;
function InStr(Start: integer; Source: string; SourceToFind: string): integer;
function Mid(Source: string; Start: integer; Length: integer): string;
function Left2(Source: string; Length: integer): string;
function Right(Source: string; Lengths: integer): string;
function Replace(Txt:string;Chaine1:string;Chaine2:string;Deb:integer=1):string;
function Split(Source, Deli: string; StringList: TStringList): TStringList;
function Reverse(Line: string): string;
implementation
function Reverse(Line: string): string;
var i: integer;
var a: string;
begin
For i := 1 To Length(Line) do
begin
a := Right(Line, i);
Result := Result + Left2(a, 1);
end;
end;
function Split(Source, Deli: string; StringList: TStringList): TStringList;
var
EndOfCurrentString: byte;
begin
repeat
EndOfCurrentString := Pos(Deli, Source);
if EndOfCurrentString = 0 then
StringList.add(Source)
else
StringList.add(Copy(Source, 1, EndOfCurrentString - 1));
Source := Copy(Source, EndOfCurrentString + length(Deli), length(Source) - EndOfCurrentString);
until EndOfCurrentString = 0;
result := StringList;
end;

function Replace(Txt:string;Chaine1:string;Chaine2:string;Deb:integer=1):string;
var
Long1,Long2:integer;
a:integer;
begin
Long1 := Length(Chaine1);
Long2 := Length(Chaine2);
if Long2=0 then Long2:=-1;

while Deb<=Length(Txt) do begin
    if copy(Txt,Deb,Long1)=Chaine1 then begin
      Delete(Txt,Deb,Long1);
      Insert(Chaine2,Txt,Deb);
      Deb:=Deb+Long2;
    end;
  Deb:=Deb+1;
end;

Result := Txt;

end;


function Left2(Source: string; Length: integer): string;
begin
Result := copy(Source,1,Length);
end;
function Right(Source: string; Lengths: integer): string;
begin
Result := copy(source,Length(Source) - Lengths+1,Lengths+1);
end;
function Mid(Source: string; Start: integer; Length: integer): string;
begin
Result := copy(Source,Start,Length);
end;
function InStr(Start: integer; Source: string; SourceToFind: string): integer;
begin
Result := pos(SourceToFind,copy(Source,Start,Length(Source) - (Start - 1)));
end;
function RightTrim(const s:String):String;
var
i:integer;
begin
i:=length(s);
while (i>0) and (s[i]<=#32) do
Dec(i);
result:=Copy(s,1,i);
end;
function LeftTrim(const s:String):String;
var
i, L:integer;
begin
L:=length(s);
i:=1;
while (i<=L) and (s[i]<=#32) do
Inc(i);
result:=Copy(s,i, MaxInt);
end;
end.
