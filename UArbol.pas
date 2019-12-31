unit UArbol;
interface

uses UTipos;

Type
     TArbol=^TNodoArbol;

     TNodoArbol=record
                 simbolos:simbolos;
                 lexema:string;
                 hijos:array [1..7] of TArbol;
                 cantidad:byte;
                 end;



procedure crearnodo(var nodo:TArbol; entrada:simbolos; lexema:string[80]);
procedure insertarnodohijo(var padre:TArbol; hijo:TArbol);
procedure guardararbol(var f:text; var a:Tarbol; des:integer);

implementation                                             

procedure guardararbol(var f:text; var a:Tarbol; des:integer);
var
i:integer;
begin
     for i:=1 to des do
         write(f,' ');
     writeln(f,stringsimbolos[a^.simbolos],' [',a^.lexema,']');
     for i:=1 to a^.cantidad do
         guardararbol(f,a^.hijos[i],des+2);
end;


procedure crearnodo(var nodo:TArbol; entrada:simbolos; lexema:string[80]);
var
i:byte;
        begin
              new(nodo);
              nodo^.simbolos:=entrada;
              nodo^.lexema:=lexema;
              nodo^.cantidad:=0;
              for i:= 1 to 7 do
               nodo^.hijos[i]:= nil;

         end;

procedure insertarnodohijo(var padre:TArbol; hijo:TArbol);

begin
 if padre^.cantidad < 7 then
 begin
  inc (padre^.cantidad);
  padre^.hijos[padre^.cantidad]:= hijo;
  end;
  end;

 END.
