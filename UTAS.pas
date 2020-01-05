unit UTAS;
interface

uses crt, UTipos;

procedure cargarTAS(var TAS: tablaTAS);


implementation

procedure crearProduccion (var prod:Produccion);

begin
     prod.cantidad:=0;
     prod.lista[1]:=error;
end;

procedure insertarEnLista(var prod:Produccion; simbolo:Simbolos);

begin
     if prod.cantidad < 7 then
     begin
          inc(prod.cantidad);
          prod.lista[prod.cantidad]:=simbolo;
     end;
end;

procedure crearTAS(var tabla:tablaTAS);
  var
    V, T : simbolos;

  begin
    for V := programa to ciclo do
    begin
     for T := puntoycoma to pesos do
     begin
       crearProduccion(tabla[V,T]);
    end;
  end;
end;
 
procedure cargarTAS(var TAS: tablaTAS);

begin
     crearTAS(TAS);

     insertarEnLista(TAS[programa , mientras ], sentencia);
     insertarEnLista(TAS[programa , mientras ], puntoycoma);
     insertarEnLista(TAS[programa , mientras ], programa2);
     insertarEnLista(TAS[programa , si ], sentencia);
     insertarEnLista(TAS[programa , si ], puntoycoma);
     insertarEnLista(TAS[programa , si ], programa2);
     insertarEnLista(TAS[programa , escribir ], sentencia);
     insertarEnLista(TAS[programa , escribir ], puntoycoma);
     insertarEnLista(TAS[programa , escribir ], programa2);
     insertarEnLista(TAS[programa , id ], sentencia);
     insertarEnLista(TAS[programa , id ], puntoycoma);
     insertarEnLista(TAS[programa , id ], programa2);
     insertarEnLista(TAS[programa , leerLista ], sentencia);
     insertarEnLista(TAS[programa , leerLista ], puntoycoma);
     insertarEnLista(TAS[programa , leerLista ], programa2);
     insertarEnLista(TAS[programa , leerEntero ], sentencia);
     insertarEnLista(TAS[programa , leerEntero ], puntoycoma);
     insertarEnLista(TAS[programa , leerEntero ], programa2);
     insertarEnLista(TAS[programa2 , pesos ], epsilon);
     insertarEnLista(TAS[programa2 , fin ], epsilon);
     insertarEnLista(TAS[programa2 , mientras ], programa);
     insertarEnLista(TAS[programa2 , sino ], epsilon);
     insertarEnLista(TAS[programa2 , si ], programa);
     insertarEnLista(TAS[programa2 , escribir ], programa);
     insertarEnLista(TAS[programa2 , id ], programa);
     insertarEnLista(TAS[programa2 , leerLista ], programa);
     insertarEnLista(TAS[programa2 , leerEntero ], programa);
     insertarEnLista(TAS[sentencia , mientras ], ciclo);
     insertarEnLista(TAS[sentencia , si ], condicional);
     insertarEnLista(TAS[sentencia , escribir ], escritura);
     insertarEnLista(TAS[sentencia , id ], asig);
     insertarEnLista(TAS[sentencia , leerLista ], lectura);
     insertarEnLista(TAS[sentencia , leerEntero ], lectura);
     insertarEnLista(TAS[asig , id ], id);
     insertarEnLista(TAS[asig , id ], opasig);
     insertarEnLista(TAS[asig , id ], expresion);
     insertarEnLista(TAS[expresion , parentesis1 ], exparit);
     insertarEnLista(TAS[expresion , id ], exparit);
     insertarEnLista(TAS[expresion , consent ], exparit);
     insertarEnLista(TAS[expresion , first ], exparit);
     insertarEnLista(TAS[expresion , corchete1 ], explista);
     insertarEnLista(TAS[expresion , cons ], explista);
     insertarEnLista(TAS[expresion , rest ], explista);
     insertarEnLista(TAS[explista , corchete1 ], lista);
     insertarEnLista(TAS[explista , cons ], oplista);
     insertarEnLista(TAS[explista , rest ], oplista);
     insertarEnLista(TAS[oplista , cons ], cons);
     insertarEnLista(TAS[oplista , cons ], parentesis1);
     insertarEnLista(TAS[oplista , cons ], exparit);
     insertarEnLista(TAS[oplista , cons ], coma);
     insertarEnLista(TAS[oplista , cons ], explistaoid);
     insertarEnLista(TAS[oplista , cons ], parentesis2);
     insertarEnLista(TAS[oplista , rest ], rest);
     insertarEnLista(TAS[oplista , rest ], parentesis1);
     insertarEnLista(TAS[oplista , rest ], explistaoid);
     insertarEnLista(TAS[oplista , rest ], parentesis2);
     insertarEnLista(TAS[explostaoid, id], id);
     insertarEnLista(TAS[explostaoid, corchete1], explista);
     insertarEnLista(TAS[explostaoid, cons], explista);
     insertarEnLista(TAS[explostaoid, rest], explista);
     insertarEnLista(TAS[lista , corchete1 ], corchete1);
     insertarEnLista(TAS[lista , corchete1 ], listanum);
     insertarEnLista(TAS[lista , corchete1 ], corchete2);
     insertarEnLista(TAS[listanum , consent ], consent);
     insertarEnLista(TAS[listanum , consent ], listanum2);
     insertarEnLista(TAS[listanum2 , coma ], coma);
     insertarEnLista(TAS[listanum2 , coma ], listanum);
     insertarEnLista(TAS[listanum2 , corchete2 ], epsilon);
     insertarEnLista(TAS[exparit , parentesis1 ], parentesis1);
     insertarEnLista(TAS[exparit , parentesis1 ], exparit);
     insertarEnLista(TAS[exparit , parentesis1 ], parentesis2);
     insertarEnLista(TAS[exparit , parentesis1 ], exparit2);
     insertarEnLista(TAS[exparit , id ], id);
     insertarEnLista(TAS[exparit , id ], exparit2);
     insertarEnLista(TAS[exparit , consent ], consent);
     insertarEnLista(TAS[exparit , consent ], exparit2);
     insertarEnLista(TAS[exparit , first ], first);
     insertarEnLista(TAS[exparit , first ], parentesis1);
     insertarEnLista(TAS[exparit , first ], explistaoid);
     insertarEnLista(TAS[exparit , first ], parentesis2);
     insertarEnLista(TAS[exparit , first ], exparit2);
     insertarEnLista(TAS[exparit2 , hacer ], epsilon);
     insertarEnLista(TAS[exparit2 , parentesis2 ], epsilon);
     insertarEnLista(TAS[exparit2 , oprel ], epsilon);
     insertarEnLista(TAS[exparit2 , entonces ], epsilon);
     insertarEnLista(TAS[exparit2 , coma ], epsilon);
     insertarEnLista(TAS[exparit2 , oparit ], oparit);
     insertarEnLista(TAS[exparit2 , oparit ], exparit);
     insertarEnLista(TAS[exparit2 , puntoycoma ], epsilon);
     insertarEnLista(TAS[lectura , leerLista ], leerL);
     insertarEnLista(TAS[lectura , leerEntero ], leerE);
     insertarEnLista(TAS[leerE , leerEntero ], leerEntero);
     insertarEnLista(TAS[leerE , leerEntero ], parentesis1);
     insertarEnLista(TAS[leerE , leerEntero ], cadena);
     insertarEnLista(TAS[leerE , leerEntero ], coma);
     insertarEnLista(TAS[leerE , leerEntero ], id);
     insertarEnLista(TAS[leerE , leerEntero ], parentesis2);
     insertarEnLista(TAS[leerL , leerLista ], leerLista);
     insertarEnLista(TAS[leerL , leerLista ], parentesis1);
     insertarEnLista(TAS[leerL , leerLista ], cadena);
     insertarEnLista(TAS[leerL , leerLista ], coma);
     insertarEnLista(TAS[leerL , leerLista ], id);
     insertarEnLista(TAS[leerL , leerLista ], parentesis2);
     insertarEnLista(TAS[escritura , escribir ], escribir);
     insertarEnLista(TAS[escritura , escribir ], parentesis1);
     insertarEnLista(TAS[escritura , escribir ], cadena);
     insertarEnLista(TAS[escritura , escribir ], coma);
     insertarEnLista(TAS[escritura , escribir ], expresion);
     insertarEnLista(TAS[escritura , escribir ], parentesis2);
     insertarEnLista(TAS[condicional , si ], si);
     insertarEnLista(TAS[condicional , si ], condicion);
     insertarEnLista(TAS[condicional , si ], entonces);
     insertarEnLista(TAS[condicional , si ], programa);
     insertarEnLista(TAS[condicional , si ], condicional1);
     insertarEnLista(TAS[condicional1 , fin ], fin);
     insertarEnLista(TAS[condicional1 , sino ], sino);
     insertarEnLista(TAS[condicional1 , sino ], programa);
     insertarEnLista(TAS[condicional1 , sino ], fin);
     insertarEnLista(TAS[condicion , parentesis1 ], exparit);
     insertarEnLista(TAS[condicion , parentesis1 ], oprel);
     insertarEnLista(TAS[condicion , parentesis1 ], exparit);
     insertarEnLista(TAS[condicion , null ], null);
     insertarEnLista(TAS[condicion , null ], parentesis1);
     insertarEnLista(TAS[condicion , null ], explistaoid);
     insertarEnLista(TAS[condicion , null ], parentesis2);
     insertarEnLista(TAS[condicion , id ], exparit);
     insertarEnLista(TAS[condicion , id ], oprel);
     insertarEnLista(TAS[condicion , id ], exparit);
     insertarEnLista(TAS[condicion , consent ], exparit);
     insertarEnLista(TAS[condicion , consent ], oprel);
     insertarEnLista(TAS[condicion , consent ], exparit);
     insertarEnLista(TAS[condicion , first ], exparit);
     insertarEnLista(TAS[condicion , first ], oprel);
     insertarEnLista(TAS[condicion , first ], exparit);
     insertarEnLista(TAS[ciclo , mientras ], mientras);
     insertarEnLista(TAS[ciclo , mientras ], condicion);
     insertarEnLista(TAS[ciclo , mientras ], hacer);
     insertarEnLista(TAS[ciclo , mientras ], programa);
     insertarEnLista(TAS[ciclo , mientras ], fin);


end;

END.
