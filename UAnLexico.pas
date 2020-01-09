UNIT UAnLexico;

Interface

uses crt, UTablaSim, UTipos, UArchivo;

Procedure ObtenerSiguienteCompLex(Var Fuente:Tarchivo; Var Control:Longint; Var CompLex:simbolos;
                                  var lexema:string; var Tabla:TS; var endOfFile: boolean);

Implementation

function esconsent(var fuente: Tarchivo; var control:longint; var lexema:string):boolean;
const
     q0=0;
     F=[1];
type
    Q=0..2;
    sigma=(numero, menos, otro);
    tipodelta=array [Q,sigma]of q;
var
   estadoactual:Q;
   estadoanterior:Q;
   delta:tipodelta;
   caracter:char;

function CarAsimb (car:char):sigma;
begin
      case car of
           '0'..'9':CarASimb := numero;
      else
           carAsimb := otro;
      end;
end;

BEGIN
     delta[0,numero]:=1;
     delta[0,otro]:=2;
     delta[1,otro]:=2;
     delta[1,numero]:=1;
     delta[2,numero]:=2;
     delta[2,otro]:=2;

     lexema:='';
     estadoactual:=q0;

     while (estadoactual<>2) and (not(eof(fuente))) do
         begin
             estadoanterior:=estadoactual;
             leereg(fuente, control, caracter);
             estadoactual:= delta [estadoactual, CarAsimb(caracter)];
             lexema:=lexema+caracter;
             inc (control);
         end;

     if (estadoactual = 2) then
     begin
          dec(control);
          Delete(lexema, length(lexema), 1);
          esconsent:= estadoanterior in F;
     end

     else
         esconsent:= estadoactual in F

END;

function EsSimboloEspecial(var Fuente: Tarchivo;var Control:longint;var CompLex:simbolos; var lexema: string[2]):boolean;

var caracter : char;

Begin
     leereg(fuente, control, caracter);
     lexema := caracter;
     if caracter in [';','[',']','(',',',')','+','-','*','/','=','<','>'] then
       case caracter of
        ';': begin
             comPlex:=puntoycoma;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '[': begin
             comPlex:=corchete1;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        ']': begin
             comPlex:=corchete2;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '(': begin
             comPlex:=parentesis1;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        ',': begin
             comPlex:=coma;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        ')': begin
             comPlex:= parentesis2;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '-': begin
             comPlex:= oparit;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '+': begin
             comPlex:= oparit;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '*': begin
             comPlex:=oparit;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '/': begin
             comPlex:=oparit;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '=': begin
             comPlex:=oprel;
             inc(control);
             EsSimboloEspecial:=true;
             end;
        '<': begin
             comPlex:=oprel;
             inc(control);
             EsSimboloEspecial:=true;
             leereg(fuente, control, caracter);
             if caracter = '=' then
             begin
                  inc(control);
                  lexema := lexema + caracter;
             end
             else if caracter = '>' then
             begin
                  inc(control);
                  lexema := lexema + caracter;
             end;
             end;
        '>': begin
                  comPlex:=oprel;
                  inc(control);
                  EsSimboloEspecial:=true;
                  leereg(fuente, control, caracter);
                  if caracter = '=' then
                  begin
                       inc(control);
                       lexema := lexema + caracter;
                  end;
             end;
        end
       
        else if caracter = ':' then
        begin
             inc(control);
             leereg(fuente, control, caracter);
             if caracter = '=' then
             begin
                  lexema := lexema + caracter;
                  comPlex:=opasig;
                  inc(control);
                  EsSimboloEspecial:=true;
             end;
        end

        else
            EsSimboloEspecial:=false;
End;

FUNCTION esidentificador (var fuente: Tarchivo; var control:longint; var lexema:string):boolean;
CONST
	q0=0;
	F=[1];
TYPE
	Q=0..2;
	sigma=(letra,numero,guion,otro);
	tipodelta=Array[Q,sigma]of Q;
VAR
	estadoactual:Q;
    estadoanterior:Q;
	delta:tipodelta;
    caracter:char;

FUNCTION carasimb(car:char):sigma;
BEGIN
	CASE car OF
		'a'..'z','A'..'Z':carasimb:=letra;
		'0'..'9':carasimb:=numero;
		'_':carasimb:=guion
	ELSE
		carasimb:=otro
	END;
END;

BEGIN
	delta[0,letra]:=1;
	delta[0,numero]:=2;
	delta[0,guion]:=2;
	delta[0,otro]:=2;
	delta[1,letra]:=1;
	delta[1,numero]:=1;
	delta[1,guion]:=1;
	delta[1,otro]:=2;
	delta[2,letra]:=2;
	delta[2,numero]:=2;
	delta[2,guion]:=2;
	delta[2,otro]:=2;

	estadoactual:=q0;
    lexema:='';

    while (estadoactual <> 2) and (not(eof(fuente))) do
         begin
         estadoanterior:=estadoactual;
         leereg(fuente, control, caracter);
         estadoactual:= delta [estadoactual, CarAsimb(caracter)];
         lexema:=lexema + caracter;
         inc (control);
         end;
     if (estadoactual = 2) then
        begin
             dec(control);
             Delete(lexema, length(lexema), 1);
             esidentificador:= estadoanterior in F;
        end
     else
        esidentificador:= estadoactual in F;
End;

FUNCTION escadena (var fuente: Tarchivo; var control:longint; var lexema:string):boolean;
CONST
	q0=0;
	F=[2];
TYPE
	Q=0..3;
	sigma=(comilla, simbolos);
	tipodelta=Array[Q,sigma]of Q;
VAR
	estadoactual:Q;
    estadoanterior:Q;
	delta:tipodelta;
    caracter:char;

FUNCTION carasimb(car:char):sigma;
BEGIN
 if car=#34 then
    carasimb:=comilla
 else
    carasimb:=simbolos;
END;

BEGIN
	delta[0,comilla]:=1;
	delta[0,simbolos]:=3;
	delta[1,comilla]:=2;
	delta[1,simbolos]:=1;
	delta[2,comilla]:=3;
	delta[2,simbolos]:=3;
    delta[3,comilla]:=3;
    delta[3,simbolos]:=3;

	estadoactual:=q0;
    lexema:='';

    while (estadoactual <> 3) and (not(eof(fuente))) do
         begin
         estadoanterior:=estadoactual;
         leereg(fuente, control, caracter);
         lexema := lexema + caracter;
         estadoactual:= delta [estadoactual, CarAsimb(caracter)];
         inc (control);
         end;
        if (estadoactual = 3) then
        begin
             dec(control);
             Delete(lexema, length(lexema), 1);
             escadena:= estadoanterior in F;
        end
     else
        escadena:= estadoactual in F;
End;

Procedure ObtenerSiguienteCompLex(Var Fuente:Tarchivo; Var Control:Longint; Var CompLex:simbolos;
                                   var lexema:string; var Tabla:TS; var endOfFile: boolean);
var
   pos:byte;
   caracter:char;
   // endOfFile:boolean;

Begin

if (endOfFile and debugMode) then writeln('Final del archivo');
     
if not(endOfFile) then
begin
     leereg(fuente, control, caracter);
end;

while (not(endOfFile)) and (caracter in [#0..#32]) do
      begin
      inc(control);
      leereg(fuente, control, caracter);
      end;
if not(endOfFile) then
begin
     if esidentificador(Fuente, control, lexema) then
     begin
          busquedaenTS(Tabla, lexema, complex, pos);
          if pos=0 then
          begin
               complex:=id;
               insertarenTS(Tabla, lexema, complex);
          end

     end

     else if escadena(Fuente, control, lexema) then
     begin
          CompLex:=cadena;
     end

     else If esconsent(Fuente, Control, lexema) then
     begin
          CompLex:=consent;
     end

     else if EsSimboloEspecial(Fuente, Control, CompLex, lexema) then
          begin
          CompLex:=CompLex;
          end
     else
         begin
         CompLex:=error;
         end
     end

else
begin
     complex:=pesos;
     lexema:='$';
end;
endOfFile:=eof(fuente);
End;


END.
