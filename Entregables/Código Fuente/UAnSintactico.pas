unit UAnSintactico;
interface

uses CRT, UTablaSim, UAnLexico, UTAS, UPila, UTipos, UArbol, UArchivo;

procedure analisis(var Fuente: Tarchivo; var tabladesimbolos:TS; var Raiz: Tarbol; var errorStatus: boolean);

implementation


procedure analisis(var Fuente: Tarchivo; var tabladesimbolos:TS; var Raiz:Tarbol; var errorStatus: boolean);

var
   TAS:tablaTAS;
   Pila:Tpila;
   control:longint;
   COMPLEX:simbolos;
   lexema:string;
   X:simbolos;
   i:byte;
   NodoPadre:Tarbol;
   Nodoaux:Tarbol;
   endOfFile: boolean;

begin

     errorStatus:=false;
     endOfFile:=false;
     cargarTAS(TAS);
     crearTS(tabladesimbolos);
     crearpila(Pila);
     Raiz:=Pila.tope^.info.nodo;
     control:=0;

     obtenerSiguienteCompLex(Fuente, control, COMPLEX, lexema, tabladesimbolos, endOfFile);
     if (debugMode) then writeln('Siguiente componente lexico: ' + stringSimbolos[COMPLEX]);
     repeat
           if Pila.tope^.info.Simbolo in [puntoycoma..pesos] then // si es un terminal

              begin
              if (debugMode) then writeln('Es terminal');
              if Pila.tope^.info.Simbolo=COMPLEX then
                 begin
                 if (debugMode) then writeln('Es terminal donde Pila.tope^.info.Simbolo=COMPLEX');
                 desapilar(Pila, X, NodoPadre);
                 nodopadre^.lexema:=lexema;
                 obtenerSiguienteCompLex(Fuente, control, COMPLEX, lexema, tabladesimbolos, endOfFile);
                 if (debugMode) then writeln('Siguiente componente lexico: ' + stringSimbolos[COMPLEX]);
                 if (debugMode) then writeln('Desapila por igualdad: ', NodoPadre^.lexema);  //debug
                 end
               
               else
                  begin
                     errorStatus:= true;
                     if (debugMode) then writeln('Error debido a desigualdad entre el tope de la pila y el componente lexico');
                  end;
              end

           else // es una variable, epsilon o error

              begin
              if (debugMode) then writeln('No es terminal');
              if (debugMode) then writeln('Primer hijo del tope de la pila: ' + stringSimbolos[TAS[Pila.tope^.info.Simbolo, COMPLEX].lista[1]]);
                 if TAS[Pila.tope^.info.Simbolo, COMPLEX].lista[1]<>error then

                     begin
                     if (debugMode) then writeln('No es error');
                     if TAS[Pila.tope^.info.Simbolo, COMPLEX].lista[1]<>epsilon then
                        begin
                        if (debugMode) then writeln('No es epsilon');
                        desapilar(Pila, X, NodoPadre);
                        if (debugMode) then writeln('Desapila: ', NodoPadre^.lexema);   // debug
                        for i:= 1 to TAS[X, COMPLEX].cantidad do
                            begin
                            crearnodo(nodoaux, TAS[X, COMPLEX].lista[i], stringsimbolos[TAS[X, COMPLEX].lista[i]]);
                            insertarnodohijo(nodoPadre, nodoaux);
                            end;
                        for i:= nodopadre^.cantidad downto 1 do
                            begin
                            apilar(pila, nodopadre^.hijos[i]^.simbolos, nodopadre^.hijos[i]);
                            if (debugMode) then writeln('Aplia: ', nodopadre^.hijos[i]^.lexema); // debug
                            end;
                        end

                     else                                 //si es epsilon

                        begin
                        if (debugMode) then writeln('Es epsilon');
                        desapilar(Pila, X, NodoPadre);
                        if (debugMode) then writeln('Desapila por epsilon: ', NodoPadre^.lexema);  // debug
                        crearnodo(nodoaux, epsilon, 'epsilon');
                        insertarnodohijo(NodoPadre, nodoaux);
                        if ((COMPLEX=pesos) and (Pila.tope^.info.Simbolo <> pesos)) then
                           begin
                           errorStatus:= true;
                           if (debugMode) then writeln('Fin incorrecto de programa');
                           end;
                        end;

                     end
              else
               begin
                  if (debugMode) then writeln('Se encontro un error, chequear el archivo arbolError.txt');
                  errorStatus:=true;
                  crearnodo(nodoaux, error, 'error');
                  insertarnodohijo(nodoPadre, nodoaux);
               end;
              end;
      if (debugMode) then writeln('Tope de la pila: ' + stringSimbolos[Pila.tope^.info.Simbolo]);
      if (debugMode) then writeln('----------------------------------------------')
     until (Pila.tope^.info.Simbolo = pesos) or (errorStatus);

end;


end.
