Unit Uinterprete;
interface

uses CRT, Utipos, Uarbol, UTablaSim;

procedure evalPrograma(arbol: Tarbol; var ts:TS);
procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:real);
procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean);

implementation

procedure asignar(var ts:TS; lexema:string; X:tResultado; var errorStatus: boolean);

var
   s:simbolos;
   pos:byte;

begin
     if (not(errorStatus)) then
     begin
          busquedaenTS(ts, lexema, s, pos);
          if pos = 0 then
               errorStatus:=true        // la variable se deberia haber asignado durante el analisis lexico
          else
               ts.lista[pos].val:=x;
     end;
end;

procedure evalPrograma(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
begin
     if (not(errorStatus)) then
     begin
          evalsentencia(arbol^.hijos[1], ts, errorStatus);
          evalprograma2(arbol^.hijos[3], ts, errorStatus);
     end;
end;

procedure evalprograma2(arbol: Tarbol; var ts:TS);
begin
     if arbol^.hijos[1]^.simbolos=programa then
        evalprograma(arbol^.hijos[1], ts, errorStatus);
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

procedure evalAsig(arbol: Tarbol; var ts:TS; var errorStatus: boolean);

var
   resultado: tResultado;

begin
     if (not(errorStatus)) then
     begin
          newTResultado(resultado);
		evalExpresion(arbol^.hijos[3], ts, resultado, errorStatus);  // esto crea la instancia de tResultado
		asignar(ts, arbol^.hijos[1]^.lexema, resultado, errorStatus);  // esto la asigna solamente
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

procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:tResultado; var errorStatus: boolean);       // revisar para que asigne valor real en un tResultado
var
res:tResultado;
numero:real;
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
                              resultado.isReal:=true;                                     // resultado deberia ser de tipo tResultado
                              evalexparit2(arbol^.hijos[2], ts, res,resultado, errorStatus);
                         end;
               end
          else if arbol^.hijos[1]^.simbolos=id then
               begin
                    newTResultado(res);
                    Resultado:= obtenervalor(ts, arbol^.hijos[1]^.lexema);
                    evalexparit2(arbol^.hijos[2], ts, res,resultado, errorStatus);
               end
          else if arbol^.hijos[1]^.simbolos=parentesis1 then
               begin
                    newTResultado(res);
                    evalexparit(arbol^.hijos[2], ts,resultado);
                    evalexparit2(arbol^.hijos[4], ts, res,resultado, errorStatus);
               end
          else if arbol^.hijos[1]^.simbolos=first then
               begin
                    newTResultado(res);
                    newTResultado(resultadoLista);
                    evalexplistaoid(arbol^.hijos[2], ts, resultadoLista, errorStatus);
                    First(resultadoLista.lista, x);
                    resultado.numero=x;
                    evalexparit2(arbol^.hijos[4], ts, res,resultado, errorStatus);
               end;
     end;
end;


procedure evalExparit2(arbol: Tarbol; var ts:TS; var res:real; var resultado:tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=oparit then
               begin
                    evalexparit(arbol^.hijos[2], ts,res, errorStatus);
                    if arbol^.hijos[1]^.lexema = '+' then resultado.numero:=resultado.numero + res.numero
                    else if arbol^.hijos[1]^.lexema = '-' then resultado.numero:=resultado.numero - res.numero
                    else if arbol^.hijos[1]^.lexema = '*' then resultado.numero:=resultado.numero * res.numero
                    else if arbol^.hijos[1]^.lexema = '/' then resultado.numero:=resultado.numero / res.numero;
		     end;
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
               resultado.lista:= Rest(resultadoLista.lista); //errorstatus cambiar en ulista
          end
          else if arbol^.hijos[1]^.simbolos=cons then
          begin
               newTResultado(resultadoLista);
               newTResultado(resultadoArit);
               evalexplista(arbol^.hijos[5], ts, resultadoLista, errorStatus);
               evalexparit(arbol^.hijos[3], ts, resultadoArit, errorStatus);
               Cons(resultadoLista.lista, resultadoArit.numero); //errorstatus cambiar en ulista
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
          // obtenerValor;
     end;
end;

procedure evalexplista(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);

begin
     if (not(errorStatus)) then
     begin
          evallistanum(arbol^.hijos[2], ts, resultado, errorStatus);
     end;
end;

procedure evallistanum(arbol: Tarbol; var ts:TS; var resultado: tResultado; var errorStatus: boolean);
var
     codigoerror:integer;

begin
     if (not(errorStatus)) then
     begin
          val(arbol^.hijos[1]^.lexema, numero, codigoerror);
          if codigoerror = 0 then
               resultado.numero:=numero;          // No va esto, aca hay que asignar en una lista (teniendo en cuenta si el primer elemento es nil y blablablabla);
               resultado.isReal:=false;
               evallistanum2(arbol^.hijos[2], ts, resultado, errorStatus);
          end;
     end;
end;

procedure evallistanum2(arbol: Tarbol; var ts: TS; var resultado: tResultado; var errorStatus: boolean);
var
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1]^.simbolos=coma then
               evallistanum(arbol^.hijos[2], ts, resultado, errorStatus);
     end;
end;

procedure evalLectura(arbol: Tarbol; var ts:TS, var errorStatus: boolean);

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
begin
     if (not(errorStatus)) then
     begin
          write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2));
          read(X);
          for i := 0 to Length(X) do
               begin
                    case X[i] of
                         '0'..'9': begin end;
                    else
                    begin
                         errorStatus:=true;
                    end;
               end;
          if (not(errorStatus)) then 
          begin
               resultado.numero:=X;
               resultado.isReal:=true;
               asignar(ts, arbol^.hijos[5]^.lexema, X, errorStatus);
          end;
     end;
end;

procedure evalLeerL(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var
     resultado: tResultado;
     i: integer;
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
               end
          end
          else
               errorStatus:=true;
          if (not(errorStatus)) then
          begin
               resultado.isReal:=false;
               resultado.lista:=ParseLista(X, errorStatus);
               asignar(ts, arbol^.hijos[5]^.lexema, X, errorStatus);
          end;
     end;
end;

procedure evalEscritura(arbol: Tarbol; var ts:TS; var errorStatus: boolean);
var 
     resultado: tResultado;

begin
     if (not(errorStatus)) then
     begin
          evalExpresion(arbol^.hijos[5], ts, resultado, errorStatus);
          write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2));
          // parseo de tResultado como un string para mostrar por pantalla y mostrar
     end;
end;

procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean; var errorStatus: boolean);
var
resultado, res:tResultado;
begin
     if (not(errorStatus)) then
     begin
          if arbol^.hijos[1].simbolos = exparit then
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
          else if arbol^.hijos[1].simbolos=null then
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

procedure evalciclo(arbol: Tarbol; var ts:TS, var errorStatus: boolean);
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

END.

