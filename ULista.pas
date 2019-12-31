unit ULista;
interface

const
Max=100;

type

             TElemento=longint;
             TPunteroL= ^TNodoL;
             TNodoL=record
                         Info:TElemento;
                         Sig:TPunteroL;
                         end;
             TLista=Record
                   dato:array[1..Max] of TElemento;
	               Cab: TPunteroL;
	               Tam: 0..Max;
                    end;

Procedure CrearLista(Var L:TLista);
Procedure Cons(Var L:TLista; x:TElemento);
Procedure First(L:TLista;var x:TElemento);
Function Rest(L:TLista):Tlista;
Function ListaVacia(L:TLista):Boolean;
Function ListaLlena(L:TLista):Boolean;
Function ListaTam(L:TLista):Cardinal;



implementation

Procedure CrearLista(Var L:TLista);
begin
L.Cab:=Nil;
L.Tam:= 0;
end;

Procedure Cons(Var L:TLista; x:TElemento);
var Dir: TPunteroL;
begin
     New(Dir);
     Dir^.Info:=x;
     Dir^.Sig:=L.Cab;
     L.Cab:=Dir;
     Inc(L.Tam);
end;

Procedure First(L:TLista;var x:TElemento);
begin
     x:=L.Cab^.info;
end;

Function Rest(L:TLista):Tlista;

begin
     if L.Tam=0 then
     begin
          Rest.cab:=nil;
          Rest.tam:=0;
     end
     else
     begin
          Rest.cab:=L.cab^.sig;
          Rest.tam:=L.tam -1;
     end;
end;

Function ListaVacia(L:TLista):Boolean;
begin
ListaVacia:= (L.Cab=Nil);
end;

Function ListaLlena(L:TLista):Boolean;
begin
ListaLlena:= memavail<sizeof(L.Cab^);
end;

Function ListaTam(L:TLista):Cardinal;
begin
ListaTam:=L.Tam;
end;

begin

end.




