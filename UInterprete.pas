Unit Uinterprete;
interface

uses CRT, Utipos, Uarbol, UTablaSim, ulista, sysutils;

procedure asignar(var ts:TS; lexema:string; X:tResultado; var errorStatus: boolean);
function obtenervalor(ts:TS; lexema:string; var errorStatus: boolean):tResultado;
procedure evalprograma2(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalExparit2(arbol: Tarbol; var ts:TS; var res:tResultado; var resultado:tResultado; var errorStatus: boolean);
procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:tResultado; var errorStatus: boolean);
procedure evalExpresion(arbol: Tarbol; var ts:TS; var resultado:tResultado; var errorStatus: boolean);
procedure evalAsig(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalexplista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
procedure evaloplista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
procedure evalexplistaoid(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
procedure evallista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
procedure evallistanum(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
procedure evallistanum2(arbol: Tarbol; var ts: TS; var resultado: tResultado; var errorStatus: boolean);
procedure evalLectura(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalLeerE(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalLeerL(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalEscritura(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean; var errorStatus: boolean);
procedure evalcondicional(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalcondicional1(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalciclo(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalSentencia(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
procedure evalPrograma(arbol: Tarbol; var ts:TS; var errorStatus: boolean);


implementation

procedure asignar(var ts:TS; lexema:string; X:tResultado; var errorStatus: boolean);

var
   s:simbolos;
   pos:byte;

begin
     if (not(errorStatus)) then
     begin
          busquedaenTS(ts, lexema, s, pos);
          writeln('Asignar Log: lexema:' + lexema + '. pos: ' + IntToStr(pos));
          if pos = 0 then
               errorStatus:=true        // la variable se deberia haber asignado durante el analisis lexico
          else
               ts.lista[pos].val:=x;
               write('Resultado - Numero: ' + IntToStr(x.numero) + '. Tamaño de lista' + IntToStr(x.lista.tam));
               if x.isReal then
                    writeln('. Es real')
               else
                    writeln('. Es lista');
     end;
end;

function obtenervalor(ts:TS; lexema:string; var errorStatus: boolean):tResultado;

var
   s:simbolos;
   pos:byte;

begin
     busquedaenTS(ts, lexema, s, pos);
     writeln('ObtenerValor Log: lexema:' + lexema + '. pos: ' + IntToStr(pos));
     if pos = 0 then 
     begin
          errorStatus:= true;
          writeln('Variable invalida');
     end
     else
          write('Resultado - Numero: ' + IntToStr(ts.lista[pos].val.numero) + '. Tamaño de lista' + IntToStr(ts.lista[pos].val.lista.tam));
          if ts.lista[pos].val.isReal then
               writeln('. Es real')
          else
               writeln('. Es lista');
     obtenervalor:=ts.lista[pos].val;
end;

procedure evalprograma2(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
begin
     if arbol^.hijos[1]^.simbolos=programa then
        evalprograma(arbol^.hijos[1], ts, errorStatus);
end;

procedure evalExparit2(arbol: Tarbol; var ts:TS; var res:tResultado; var resultado:tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=oparit then
               begin
                    evalexparit(arbol^.hijos[2], ts, res, errorStatus);
                    if arbol^.hijos[1]^.lexema = '+' then resultado.numero:=resultado.numero + res.numero
                    else if arbol^.hijos[1]^.lexema = '-' then resultado.numero:=resultado.numero - res.numero
                    else if arbol^.hijos[1]^.lexema = '*' then resultado.numero:=resultado.numero * res.numero
                         else if arbol^.hijos[1]^.lexema = '/' then resultado.numero:=resultado.numero div res.numero;
		     end;
     end;
end;

procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:tResultado; var errorStatus: boolean);       // revisar para que asigne valor real en un tResultado
var
res:tResultado;
numero:longint;
codigoerror:integer;
resultadoLista: tResultado;
x: longint;
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=consent then
               begin
                    val(arbol^.hijos[1]^.lexema, numero, codigoerror);     // convierte string en numero
                    if codigoerror = 0 then
                         begin
                              newTResultado(res);
                              resultado.numero:=numero;
                              resultado.isReal:=true;
                              evalexparit2(arbol^.hijos[2], ts, res,resultado, errorStatus);
                         end;
               end
          else if arbol^.hijos[1]^.simbolos=id then
               begin
                    newTResultado(res);
                    Resultado:= obtenervalor(ts, arbol^.hijos[1]^.lexema, errorStatus);
                    if not(errorStatus) then evalexparit2(arbol^.hijos[2], ts, res,resultado, errorStatus);
               end
          else if arbol^.hijos[1]^.simbolos=parentesis1 then
               begin
                    newTResultado(res);
                    evalexparit(arbol^.hijos[2], ts,resultado, errorStatus);
                    evalexparit2(arbol^.hijos[4], ts, res,resultado, errorStatus);
               end
          else if arbol^.hijos[1]^.simbolos=first then
               begin
                    newTResultado(res);
                    newTResultado(resultadoLista);
                    evalexplistaoid(arbol^.hijos[2], ts, resultadoLista, errorStatus);
                    FirstL(resultadoLista.lista, x);
                    resultado.numero:=x;
                    evalexparit2(arbol^.hijos[4], ts, res,resultado, errorStatus);
               end;
     end;
end;

procedure evalExpresion(arbol: Tarbol; var ts:TS; var resultado:tResultado; var errorStatus: boolean);   //esto daria real o lista
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=exparit then
               begin
		          evalexparit(arbol^.hijos[1], ts, resultado, errorStatus);     //esto real
		     end
          else if arbol^.hijos[1]^.simbolos=explista then
               begin
                    evalexplista(arbol^.hijos[1], ts, resultado, errorStatus);    //esto lista
               end;
     end;
end;

procedure evalAsig(arbol: Tarbol; var ts:TS; var errorStatus: boolean);

var
   resultado: tResultado;

begin
     if (not(errorStatus)) then
     begin
          newTResultado(resultado);
		evalExpresion(arbol^.hijos[3], ts, resultado, errorStatus);
		asignar(ts, arbol^.hijos[1]^.lexema, resultado, errorStatus);
     end;
end;

procedure evalexplista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=oplista then
               evaloplista(arbol^.hijos[1], ts, resultado, errorStatus)
          else if arbol^.hijos[1]^.simbolos=lista then
               evallista(arbol^.hijos[1], ts, resultado, errorStatus);
     end;
end;
procedure evaloplista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
var
resultadoLista:tResultado;
resultadoArit:tResultado;

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=rest then
          begin
               newTResultado(resultadoLista);
               evalexplista(arbol^.hijos[3], ts, resultadoLista, errorStatus);
               resultado.lista:= RestL(resultadoLista.lista);
          end
          else if arbol^.hijos[1]^.simbolos=cons then
          begin
               newTResultado(resultadoLista);
               newTResultado(resultadoArit);
               evalexplista(arbol^.hijos[5], ts, resultadoLista, errorStatus);
               evalexparit(arbol^.hijos[3], ts, resultadoArit, errorStatus);
               if resultadoArit.numero=-1 then 
               begin
                    errorStatus:=true;
                    writeln('Error en el primer parametro del ConsL')     // por si llegara a ser un id que tiene una lista
               end;
               ConsL(resultadoLista.lista, resultadoArit.numero);
               resultado.lista:= resultadoLista.lista;
          end;
     end;
end;

procedure evalexplistaoid(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=explista then
               evalexplista(arbol^.hijos[1], ts, resultado, errorStatus)
          else 
               resultado:= obtenervalor(ts, arbol^.hijos[1]^.lexema, errorStatus);
     end;
end;

procedure evallista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          evallistanum(arbol^.hijos[2], ts, resultado, errorStatus);
     end;
end;

procedure evallistanum(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
var
     punteroAux, punteroAnt, punteroNodoAux:TPunteroL;
     codigoerror:integer;
     numero:longint;
begin
     if (not(errorStatus)) then
     begin
          val(arbol^.hijos[1]^.lexema, numero, codigoerror);
          if codigoerror = 0 then
          begin
               punteroAux:= resultado.lista.cab;            // asignacion al final de la lista
               punteroAnt:= nil;
               while punteroAux <> nil do
               begin
                    punteroAnt:=punteroAux;
                    punteroAux:=punteroAux^.sig;
               end;
               New(punteroNodoAux);
               punteroNodoAux^.info:=numero;
               if punteroAnt=nil then
               begin
                    resultado.lista.cab:=punteroNodoAux;
                    inc(resultado.lista.tam);
               end
               else
               begin
                    punteroAnt^.sig:=punteroNodoAux;
                    inc(resultado.lista.tam);
               end;
               resultado.isReal:=false;
               evallistanum2(arbol^.hijos[2], ts, resultado, errorStatus);
          end;
     end;
end;

procedure evallistanum2(arbol: Tarbol; var ts: TS; var resultado: tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=coma then
               evallistanum(arbol^.hijos[2], ts, resultado, errorStatus);
     end;
end;

procedure evalLectura(arbol: Tarbol; var ts:TS; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=leerE then
               evalLeerE(arbol^.hijos[1], ts, errorStatus)
          else if arbol^.hijos[1]^.simbolos=leerL then
               evalLeerL(arbol^.hijos[1], ts, errorStatus);
     end;
end;

procedure evalLeerE(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var
     resultado: tResultado;
     i: integer;
     X: string;
begin
     if (not(errorStatus)) then
     begin
          write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2));
          read(X);
          for i := 1 to Length(X) do
               begin
                    case X[i] of
                         '0'..'9': ;
                    else
                         begin
                              errorStatus:=true;
                         end;
                    end;
               end;
          if (not(errorStatus)) then 
          begin
               resultado.numero:=StrToInt(X);
               resultado.isReal:=true;
               asignar(ts, arbol^.hijos[5]^.lexema, resultado, errorStatus);
          end;
     end;
end;

procedure evalLeerL(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var
     resultado: tResultado;
     i: integer;
     X: string;
begin
     if (not(errorStatus)) then
     begin
          write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2));
          read(X);
          if ((X[1] = '[') and (X[Length(X)] = ']') and (X[2] <> ',') and (X[Length(x) -1] <> ',')) then
          begin
               if (X <> '[]') then
               begin
                    for i := 2 to (Length(X) -1) do
                    begin
                         case X[i] of
                              '0'..'9': begin end;
                              ',': begin end;
                         else
                              begin
                                   errorStatus:=true;
                              end;
                         end;
                    end;
               end
          end
          else
               errorStatus:=true;
          if (not(errorStatus)) then
          begin
               resultado.isReal:=false;
               resultado.lista:=ParseLista(X, errorStatus);
               asignar(ts, arbol^.hijos[5]^.lexema, resultado, errorStatus);
          end;
     end;
end;

procedure evalEscritura(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var 
     resultado: tResultado;

begin
     if (not(errorStatus)) then
     begin
          newTResultado(resultado);
          evalExpresion(arbol^.hijos[5], ts, resultado, errorStatus);
          if not(errorStatus) then
          begin
               write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2));
               writeln(TResultadoToString(resultado));
          end;
     end;
end;

procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean; var errorStatus: boolean);
var
resultado, res:tResultado;
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos = exparit then
          begin
               newTResultado(resultado);
               newTResultado(res);
               evalexparit(arbol^.hijos[1], ts, resultado, errorStatus);
               evalexparit(arbol^.hijos[3], ts, res, errorStatus);
               if arbol^.hijos[2]^.lexema = '=' then estado:=resultado.numero=res.numero
               else if arbol^.hijos[2]^.lexema = '<' then estado:=resultado.numero<res.numero
               else if arbol^.hijos[2]^.lexema = '<=' then estado:=resultado.numero<=res.numero
               else if arbol^.hijos[2]^.lexema = '>' then estado:=resultado.numero>res.numero
               else if arbol^.hijos[2]^.lexema = '>=' then estado:=resultado.numero>=res.numero
               else if arbol^.hijos[2]^.lexema = '<>' then estado:=resultado.numero<>res.numero
          end
          else if arbol^.hijos[1]^.simbolos=null then
          begin
               evalexplistaoid(arbol^.hijos[3], ts, resultado, errorStatus);
               if ListaVacia(resultado.lista) then estado:=true else estado:=false;
          end;
     end;
end;

procedure evalcondicional(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var estado:boolean;

begin
     if (not(errorStatus)) then
          begin
          evalcondicion(arbol^.hijos[2], ts, estado, errorStatus);
          if estado=true then
               evalprograma(arbol^.hijos[4], ts, errorStatus)
          else
               evalcondicional1(arbol^.hijos[5], ts, errorStatus);
     end;
end;

procedure evalcondicional1(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=sino then
               evalprograma(arbol^.hijos[2], ts, errorStatus);
     end;
end;

procedure evalciclo(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var
estado:boolean;
begin
     if (not(errorStatus)) then
     begin
          evalcondicion(arbol^.hijos[2], ts, estado, errorStatus);
          while estado = true do
               begin
               evalprograma(arbol^.hijos[4], ts, errorStatus);
               evalcondicion(arbol^.hijos[2], ts, estado, errorStatus);
               end;
     end;
end;

procedure evalSentencia(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
begin
     if (not(errorStatus)) then
     begin
		if arbol^.hijos[1]^.simbolos=asig then
             evalasig(arbol^.hijos[1], ts, errorStatus)
        else if arbol^.hijos[1]^.simbolos=lectura then
             evalLectura(arbol^.hijos[1], ts, errorStatus)
        else if arbol^.hijos[1]^.simbolos=escritura then
             evalEscritura(arbol^.hijos[1], ts, errorStatus)
        else if arbol^.hijos[1]^.simbolos=condicional then
             evalcondicional(arbol^.hijos[1], ts, errorStatus)
        else if arbol^.hijos[1]^.simbolos=ciclo then
             evalciclo(arbol^.hijos[1], ts, errorStatus);
     end;
end;

procedure evalPrograma(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
begin
     if (not(errorStatus)) then
     begin
          evalSentencia(arbol^.hijos[1], ts, errorStatus);
          evalprograma2(arbol^.hijos[3], ts, errorStatus);
     end;
end;

begin

END.

