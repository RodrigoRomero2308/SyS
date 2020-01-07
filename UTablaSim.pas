unit UTablaSim;

interface

uses crt, Utipos;

procedure crearTS (var tabla:TS);
procedure insertarenTS (var tabla:TS; lex:string[80]; comp:simbolos);
procedure busquedaenTS (tabla:TS; lexema:string[80]; var complex:simbolos ; var pos:byte);

implementation

procedure crearTS (var tabla:TS);
begin
     tabla.cantidad:=0;
     insertarenTS (tabla, 'rest', rest);
     insertarenTS (tabla, 'cons', cons);
     insertarenTS (tabla, 'first', first);
     insertarenTS (tabla, 'leerEntero', leerEntero);
     insertarenTS (tabla, 'leerLista', leerLista);
     insertarenTS (tabla, 'escribir', escribir);
     insertarenTS (tabla, 'si', si);
     insertarenTS (tabla, 'entonces', entonces);
     insertarenTS (tabla, 'fin', fin);
     insertarenTS (tabla, 'sino', sino);
     insertarenTS (tabla, 'null', null);
     insertarenTS (tabla, 'mientras', mientras);
     insertarenTS (tabla, 'hacer', hacer);
end;

procedure insertarenTS (var tabla:TS; lex:string[80]; comp:simbolos);
begin
      if tabla.cantidad<100 then
      begin
           inc(tabla.cantidad);

           with tabla.lista[tabla.cantidad] do
           begin
               lexema:=lex;
               complex:=comp;
               val:=0;
           end;
      end;
end;

procedure busquedaenTS (tabla:TS; lexema:string[80]; var complex:simbolos; var pos:byte);

var
   i:byte;

begin
     i:=0;

     repeat
           inc(i);
           if tabla.lista[i].lexema=lexema then
           begin
                complex:=tabla.lista[i].complex;
                pos:=i
           end
     until (i=tabla.cantidad) or (tabla.lista[i].lexema=lexema);

     if tabla.lista[i].lexema=lexema then
     begin
          complex:=tabla.lista[i].complex;
          pos:=i;
     end
     else
         pos:=0;
end;


end.
