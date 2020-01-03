Unit Uinterprete;
interface

uses CRT, Utipos, Uarbol, UTablaSim;

procedure evalPrograma(arbol: Tarbol; var ts:TS);
procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:real);
procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean);

implementation

// ------------------- Cambio para admitir valores reales o listas --------------------

// Podemos darnos cuenta si es una lista mirando el primer eleento de la construccion (corchete izquierdo)

procedure evalPrograma(arbol: Tarbol; var ts:TS);
begin
     evalsentencia(arbol^.hijos[1], ts);
     evalprograma2(arbol^.hijos[3], ts);
end;

procedure evalprograma2(arbol: Tarbol; var ts:TS);
begin
     if arbol^.hijos[1]^.simbolos=programa then
        evalprograma(arbol^.hijos[1], ts);
end;

procedure evalSentencia(arbol: Tarbol; var ts:TS);
begin
		if arbol^.hijos[1]^.simbolos=asig then
             evalasig(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=lectura then
             evalLectura(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=escritura then
             evalEscritura(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=condicional then
             evalcondicional(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=ciclo then
             evalciclo(arbol^.hijos[1], ts);
end;

procedure evalAsig(arbol: Tarbol; var ts:TS);

var
   resultado: tResultado;

begin
		evalExpresion(arbol^.hijos[3], ts, resultado);  // esto crea la instancia de tResultado
		asignar(ts, arbol^.hijos[1]^.lexema, resultado);  // esto la asigna solamente
end;

procedure evalExpresion(arbol: Tarbol; var ts:TS; var resultado:tResultado);   //esto daria real o lista
begin
        if arbol^.hijos[1]^.simbolos=exparit then
            begin
			         evalexparit(arbol^.hijos[1], ts, resultado);     //esto real
			end;
        if arbol^.hijos[1]^.simbolos=explista then
            begin
                     evalexplista(arbol^.hijos[1], ts, resultado);    //esto lista
            end;
end;

procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:tResultado);       // revisar para que asigne valor real en un tResultado
var
res:tResultado;
numero:real;
codigoerror:integer;
resultadoLista: tResultado;
x: longint;
begin
     if arbol^.hijos[1]^.simbolos=consent then
            begin
                 val(arbol^.hijos[1]^.lexema, numero, codigoerror);        // convierte string en numero
                 if codigoerror = 0 then
                    resultado.numero:=numero;
                    resultado.isReal:=true;                                     // resultado deberia ser de tipo tResultado
                 evalexparit2(arbol^.hijos[2], ts, res,resultado);
			end
       else if arbol^.hijos[1]^.simbolos=id then
            begin
			     Resultado:= obtenervalor(ts, arbol^.hijos[1]^.lexema);
                    evalexparit2(arbol^.hijos[2], ts, res,resultado);
			end
       else if arbol^.hijos[1]^.simbolos=parentesis1 then
            begin
			      evalexparit(arbol^.hijos[2], ts,resultado);
                     evalexparit2(arbol^.hijos[4], ts, res,resultado);
			end
       else if arbol^.hijos[1]^.simbolos=first then
            begin
                    evalexplista(arbol^.hijos[2], ts, resultadoLista);
                    First(resultadoLista.lista, x);
                    resultado.numero=x;
                    evalexparit2(arbol^.hijos[4], ts, res,resultado);
            end;
end;

// ------------------------------------------------------------------------------------

procedure asignar(var ts:TS; lexema:string; X:real);

var
   s:simbolos;
   pos:byte;

begin
     busquedaenTS(ts, lexema, s, pos);
     ts.lista[pos].val:=x;
end;

function obtenervalor(ts:TS; lexema:string):real;

var
   s:simbolos;
   pos:byte;

begin
     busquedaenTS(ts, lexema, s, pos);
     obtenervalor:=ts.lista[pos].val;
end;

procedure evalciclo(arbol: Tarbol; var ts:TS);
var
estado:boolean;
begin
     evalcondicion(arbol^.hijos[2], ts, estado);
     while estado = true do
           begin
           evalprograma(arbol^.hijos[4], ts);
           evalcondicion(arbol^.hijos[2], ts, estado);
           end;
end;

procedure evalcondicion(arbol: Tarbol; var ts:TS; var estado:boolean);
var
resultado, res:real;
begin
     evalexparit(arbol^.hijos[1], ts, resultado);
     evalcondicion2(arbol^.hijos[3], ts, res);
         if arbol^.hijos[2]^.lexema = '=' then estado:=resultado=res
         else if arbol^.hijos[2]^.lexema = '<' then estado:=resultado<res
         else if arbol^.hijos[2]^.lexema = '<=' then estado:=resultado<=res
         else if arbol^.hijos[2]^.lexema = '>' then estado:=resultado>res
         else if arbol^.hijos[2]^.lexema = '>=' then estado:=resultado>=res
         else if arbol^.hijos[2]^.lexema = '<>' then estado:=resultado<>res
end;

procedure evalcondicional1(arbol: Tarbol; var ts:TS);
begin
     if arbol^.hijos[1]^.simbolos=sino then
        evalprograma(arbol^.hijos[2], ts);
end;

procedure evalcondicional(arbol: Tarbol; var ts:TS);
var estado:boolean;

begin
     evalcondicion(arbol^.hijos[2], ts, estado);
     if estado=true then
        evalprograma(arbol^.hijos[4], ts)
     else
         evalcondicional1(arbol^.hijos[5], ts);
end;

procedure evalExparit2(arbol: Tarbol; var ts:TS; var res:real; var resultado:real);

begin
     if arbol^.hijos[1]^.simbolos=oparit then
            begin
			        evalexparit(arbol^.hijos[2], ts,res);
                    if arbol^.hijos[1]^.lexema = '+' then Resultado:=resultado + res
                    else if arbol^.hijos[1]^.lexema = '-' then Resultado:=resultado - res
                    else if arbol^.hijos[1]^.lexema = '*' then Resultado:=resultado * res
                    else if arbol^.hijos[1]^.lexema = '/' then Resultado:=resultado / res;


			end;
end;

procedure evalExparit(arbol: Tarbol; var ts:TS; var resultado:real);
var
res:real;
numero:real;
codigoerror:integer;
begin
     if arbol^.hijos[1]^.simbolos=consent then
            begin
                 val(arbol^.hijos[1]^.lexema, numero, codigoerror);
                 if codigoerror = 0 then
                    Resultado:=numero;
                 evalexparit2(arbol^.hijos[2], ts, res,resultado);
			end
       else if arbol^.hijos[1]^.simbolos=id then
            begin
			     Resultado:= obtenervalor(ts, arbol^.hijos[1]^.lexema);
                    evalexparit2(arbol^.hijos[2], ts, res,resultado);
			end
   else if arbol^.hijos[1]^.simbolos=parentesis1 then
            begin
			         evalexparit(arbol^.hijos[2], ts,resultado);
                     evalexparit2(arbol^.hijos[4], ts, res,resultado);
			end;
end;

procedure evalexplista(arbol: Tarbol; var ts:TS; var resultado:tResultado);
begin
     if arbol^.hijos[1]^.simbolos=oplista then
        begin
             evaloplista(arbol^.hijos[1], ts, resultado);
        end;
     if arbol^.hijos[1]^.simbolos=lista then
        begin
             evallista
        end;
end;


procedure evalExpresion(arbol: Tarbol; var ts:TS; var resultado:tResultado);   //esto daria real o lista
begin
        if arbol^.hijos[1]^.simbolos=exparit then
            begin
			         evalexparit(arbol^.hijos[1], ts, resultado);     //esto real
			end;
        if arbol^.hijos[1]^.simbolos=explista then
            begin
                     evalexplista(arbol^.hijos[1], ts, resultado);    //esto lista
            end;
end;

procedure evalAsig(arbol: Tarbol; var ts:TS);

var
   resultado: tResultado;

begin
		evalExpresion(arbol^.hijos[3], ts, resultado);
		asignar(ts, arbol^.hijos[1]^.lexema, resultado);
end;

procedure evalLeerE(arbol: Tarbol; var ts:TS);

var
   X:real;

begin
        write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2)); //copia la cadena sin comillas
		read(X);
		asignar(ts, arbol^.hijos[5]^.lexema, X);
end;
		
procedure evalEscribirE(arbol: Tarbol; var ts:TS);
var
   res:real;
   aux:string;

begin

		write(copy(arbol^.hijos[3]^.lexema, 2, Length(arbol^.hijos[3]^.lexema)-2)); //copia la cadena sin comillas
		evalexparit(arbol^.hijos[5], ts, res);
		writeln(res:3:2);
end;

procedure evalEscritura(arbol: Tarbol; var ts:TS);

begin
		if arbol^.hijos[1]^.simbolos=escribirE then
            begin
			         evalEscribirE(arbol^.hijos[1], ts);
			end;
end;

procedure evalLectura(arbol: Tarbol; var ts:TS);

begin
		if arbol^.hijos[1]^.simbolos=leerE then
            begin
			         evalLeerE(arbol^.hijos[1], ts);
			end;
end;

procedure evalSentencia(arbol: Tarbol; var ts:TS);
begin
		if arbol^.hijos[1]^.simbolos=asig then
             evalasig(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=lectura then
             evalLectura(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=escritura then
             evalEscritura(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=condicional then
             evalcondicional(arbol^.hijos[1], ts)
        else if arbol^.hijos[1]^.simbolos=ciclo then
             evalciclo(arbol^.hijos[1], ts);
end;

procedure evalprograma2(arbol: Tarbol; var ts:TS);
begin
     if arbol^.hijos[1]^.simbolos=programa then
        evalprograma(arbol^.hijos[1], ts);
end;

procedure evalPrograma(arbol: Tarbol; var ts:TS);
begin
     evalsentencia(arbol^.hijos[1], ts);
     evalprograma2(arbol^.hijos[3], ts);
end;


END.

