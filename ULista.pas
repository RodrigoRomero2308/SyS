unit ULista;
interface

uses sysutils;

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
                    // dato:array[1..Max] of TElemento;
	               Cab: TPunteroL;
	               Tam: 0..Max;
                    end;

Procedure CrearLista(Var L:TLista);
Procedure ConsL(Var L:TLista; x:TElemento);
Procedure FirstL(L:TLista;var x:TElemento);
Function RestL(L:TLista):Tlista;
Function ListaVacia(L:TLista):Boolean;
Function ListaLlena(L:TLista):Boolean;
Function ListaTam(L:TLista):Cardinal;
Function ParseLista(str:string; var errorStatus:Boolean):Tlista;

implementation

Procedure CrearLista(Var L:TLista);
begin
L.Cab:=Nil;
L.Tam:= 0;
end;

Procedure ConsL(Var L:TLista; x:TElemento);
var Dir: TPunteroL;
begin
     New(Dir);
     Dir^.Info:=x;
     Dir^.Sig:=L.Cab;
     L.Cab:=Dir;
     Inc(L.Tam);
end;

Procedure FirstL(L:TLista;var x:TElemento);
begin
     x:=L.Cab^.info;
end;

Function RestL(L:TLista):Tlista;

begin
     if L.Tam=0 then
     begin
          RestL.cab:=nil;
          RestL.tam:=0;
     end
     else
     begin
          RestL.cab:=L.cab^.sig;
          RestL.tam:=L.tam -1;
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

Function ParseLista(str:string; var errorStatus:Boolean):Tlista;           // transforma el string en una lista, en el interprete ya se corrobora que el formato sea correcto
var
     aux:string;
     listaAux:tLista;
     punteroAux, punteroAnt, punteroNodoAux:TPunteroL;
     i: integer;
begin
     aux:='';
     CrearLista(listaAux);
     if (str<>'[]') then
     begin
          for i := 2 to (Length(str) -1) do
          begin
               case str[i] of
                    '0'..'9': 
                    begin 
                         aux:=aux+str[i];
                    end;
                    ',': 
                    begin
                         punteroAnt:=nil;
                         punteroAux:=listaAux.cab;
                         while punteroAux <> nil do
                         begin
                              punteroAnt:=punteroAux;
                              punteroAux:=punteroAux^.sig;
                         end;
                         New(punteroNodoAux);
                         punteroNodoAux^.info:=StrToInt(aux);
                         if punteroAnt = nil then
                         begin
                              listaAux.cab:=punteroNodoAux;
                              inc(listaAux.Tam);
                         end
                         else
                         begin
                              punteroAnt^.sig:=punteroNodoAux;
                              inc(listaAux.Tam);
                         end;
                    end;
                    else
                         begin
                              errorStatus:=true;
                         end;
               end;
          end;  //al final de este for el ultimo número aun no fue cargado en la lista, por lo cual hay que cargarlo
          punteroAnt:=nil;
          punteroAux:=listaAux.cab;
          while punteroAux <> nil do
          begin
               punteroAnt:=punteroAux^.sig;
               punteroAux:=punteroAux^.sig;
          end;
          New(punteroNodoAux);
          punteroNodoAux^.info:=StrToInt(aux);
          if (punteroAnt = nil) then
          begin
               listaAux.cab:=punteroNodoAux;
               inc(listaAux.Tam);
          end
          else
          begin
               punteroAux:=punteroNodoAux;
               punteroAnt^.sig:=punteroAux;
               inc(listaAux.Tam);
          end;
     end
     else
     begin
          ParseLista:=listaAux;
     end;
end;

begin

end.




