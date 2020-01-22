unit UTipos;

interface

uses ULista;

type

Simbolos = (programa, programa2, sentencia, asig, expresion, explista, oplista, explistaoid, lista, listanum, listanum2, exparit, exparit2,
           lectura, leerE, leerL, escritura, condicional, condicional1, condicion, condicion2, ciclo,
           puntoycoma, id, opasig, rest, parentesis1, parentesis2, cons, consent, corchete1, corchete2, coma, first, oparit, leerEntero,
           leerLista, escribir, cadena, si, entonces, fin, sino, oprel, null, mientras, hacer, pesos, epsilon, error);

Variables = programa..ciclo;

Terminales = puntoycoma..pesos;

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

tResultado = record
          numero:real;
          lista:tLista;
          isReal:boolean;
          end;

procedure newTResultado(var resultado: tResultado);

const

stringSimbolos:array [programa..error] of string = ('programa', 'programa2', 'sentencia', 'asig', 'expresion', 'explista','oplista', 'explistaoid',
                                                    'lista', 'listanum', 'listanum2', 'exparit', 'exparit2', 'lectura', 'leerE', 'leerL',
                                                    'escritura', 'condicional', 'condicional1',
                                                    'condicion', 'condicion2', 'ciclo', 'puntoycoma', 'id', 'opasig', 'rest', 'parentesis1',
                                                    'parentesis2', 'cons', 'consent', 'corchete1', 'corchete2', 'coma', 'first','oparit',
                                                    'leerEntero', 'leerLista', 'escribir', 'cadena','si', 'entonces',
                                                    'fin', 'sino', 'oprel', 'null', 'mientras', 'hacer', 'pesos', 'epsilon', 'error');

debugMode=true;
implementation

procedure newTResultado(var resultado: tResultado);
begin
    resultado.numero:=-1;
    CrearLista(resultado.lista);
end;

end.
