unit Upila;
interface

uses UTipos, UArbol;

type

    tdato=simbolos;

    tpunpila=^tnodopila;

    tnodopila=record
                    info:record
                         Simbolo:simbolos;
                         nodo:Tarbol;
                         end;

                    siguiente:tpunpila;
              end;

    Tpila=record
                tamano:cardinal;
                tope:tpunpila;
          end;

procedure apilar(var p:tpila; x:tdato; nodo:Tarbol);
procedure crearpila(var p:tpila);
procedure desapilar(var p:tpila; var x:tdato; var nodo:Tarbol);

implementation
uses CRT;

procedure apilar(var p:tpila; x:tdato; nodo:Tarbol);
var aux:tpunpila;

begin
     new(aux);
     aux^.info.Simbolo:=x;
     aux^.info.nodo:=nodo;
     aux^.siguiente:=p.tope;
     p.tope:=aux;
     inc(p.tamano);
end;

procedure crearpila(var p:tpila);

var
   nodo, nodo2:Tarbol;

begin
     p.tope:=nil;
     p.tamano:=0;
     crearnodo(nodo, pesos, 'pesos');
     apilar(p, pesos, nodo);
     crearnodo(nodo2, PROGRAMA, 'programa');
     apilar(p, PROGRAMA, nodo2);
end;

procedure desapilar(var p:tpila; var x:tdato; var nodo:Tarbol);
var aux:tpunpila;
begin
     x:=p.tope^.info.Simbolo;
     nodo:=p.tope^.info.nodo;
     aux:=p.tope;
     p.tope:=p.tope^.siguiente;
     dispose(aux);
     dec(p.tamano);
end;

END.

