unit UTipos;

interface

uses ULista, sysutils;

type

Simbolos = (programa, programa2, sentencia, asig, expresion, explista, oplista, explistaoid, lista, listanum, listanum2, exparit, exparit2,
           lectura, leerE, leerL, escritura, condicional, condicional1, condicion, condicion2, ciclo,
           puntoycoma, id, opasig, rest, parentesis1, parentesis2, cons, consent, corchete1, corchete2, coma, first, oparit, leerEntero,
           leerLista, escribir, cadena, si, entonces, fin, sino, oprel, null, mientras, hacer, pesos, epsilon, error);

Variables = programa..ciclo;

Terminales = puntoycoma..pesos;

tResultado = record
          numero:integer;
          lista:tLista;
          isReal:boolean;
          end;

elementoTS = record
           lexema:string;
           complex:simbolos;
           val:tResultado;
           end;

TS = record
   lista:Array [1..100] of elementoTS;
   cantidad:byte;
   end;

Produccion= record
            lista: Array[1..7] of Simbolos;
            cantidad: byte;
            end;

tablaTAS= Array[Variables,Terminales] of Produccion;

procedure newTResultado(var resultado: tResultado);
function TResultadoToString(resultado: tResultado):string;

const

stringSimbolos:array [programa..error] of string = ('programa', 'programa2', 'sentencia', 'asig', 'expresion', 'explista','oplista', 'explistaoid',
                                                    'lista', 'listanum', 'listanum2', 'exparit', 'exparit2', 'lectura', 'leerE', 'leerL',
                                                    'escritura', 'condicional', 'condicional1',
                                                    'condicion', 'condicion2', 'ciclo', 'puntoycoma', 'id', 'opasig', 'rest', 'parentesis1',
                                                    'parentesis2', 'cons', 'consent', 'corchete1', 'corchete2', 'coma', 'first','oparit',
                                                    'leerEntero', 'leerLista', 'escribir', 'cadena','si', 'entonces',
                                                    'fin', 'sino', 'oprel', 'null', 'mientras', 'hacer', 'pesos', 'epsilon', 'error');

debugMode=false;
implementation

procedure newTResultado(var resultado: tResultado);
begin
    resultado.numero:=-1;
    CrearLista(resultado.lista);
end;

function TResultadoToString(resultado: tResultado):string;
var
    punteroaux: TPunteroL;
    aux:string;
begin
    if resultado.isReal then
    begin
        TResultadoToString:=IntToStr(resultado.numero);
    end
    else
    begin
        aux:='[';
        punteroaux:=resultado.lista.cab;
        while punteroaux <> nil do
        begin
            aux:=aux+IntToStr(punteroaux^.info);
            if punteroaux^.sig <> nil then aux:=aux + ',';
        end;
        aux:=aux+']';
        TResultadoToString:=aux;
    end;
end;

end.
