program Proyecto;

uses crt, UTipos, UInterprete, UAnSintactico, UArchivo, UArbol, sysutils;

Const
     // Cruta='C:\Users\Rodrigo Romero\Desktop\Compu vieja\Facultad\Sintaxis y Semantica de los lenguajes\SyS\';
     Version='1.0';
     GithubURL='https://github.com/RodrigoRomero2308/SyS';

var
   archivo:TArchivo;
   tabla: TS;
   Raiz: Tarbol;
   f:text;
   errorStatus:boolean;
   Cruta: string;

BEGIN
     // To change debug mode go to UTipos and change it in const sector
     Cruta:=GetCurrentDir;
     writeln('Ruta: ', Cruta);
     errorStatus:=false;
     if (paramcount() = 0) or (paramcount() > 2) then
     begin
          errorStatus:=true;
          writeln('Uso del programa: ');
          writeln('Debe pasar como primer parametro el nombre (comenzando con /) del archivo de texto que contiene el codigo a analizar');
          writeln('Opcionalmente puede pasar un segundo parametro booleano que sera tomado como debug mode (falso por defecto), si se pasa cualquier otro valor, se tomara el valor por defecto');
          writeln('0 o mas de 2 parametros resultaran en la visualizacion de este mensaje de ayuda');
     end
     else if paramcount() = 2 then 
     begin
          if paramstr(2) = 'true' then debugMode:=true else debugMode:=false;
     end;
     if not(errorStatus) then
     begin
          abreFile(archivo,Cruta+paramstr(1)); //+'/archivo.txt');
          writeln('--------------------------------------------');
          writeln('Archivo abierto');
          analisis(archivo,tabla, Raiz, errorStatus);   //carga todo el arbol
     end;
     if not errorStatus then
     begin
          writeln('--------------------------------------------');
          writeln('Analisis finalizado');
          assign(f,Cruta+'/arbol.txt');
          rewrite(f);
          guardararbol(f,raiz,0);          //transcribe el arbol a un txt
          close(f);
          evalPrograma(Raiz, tabla, errorStatus);
          if not errorStatus then 
          begin
               writeln('--------------------------------------------');
               writeln('Programa finalizado con EXITO. Version: ' + Version);
               writeln('Visita nuestro codigo en github: ' + GithubURL);
               writeln('LS V.Alfajor');
          end
          else
          begin
               writeln('--------------------------------------------');
               writeln('Programa finalizado con ERRORES. Version: ' + Version);
               writeln('Visita nuestro codigo en github: ' + GithubURL);
               writeln('LS V.Alfajor');
          end;
     end
     else
     begin
          writeln('--------------------------------------------');
          writeln('Analisis finalizado con ERRORES');
          assign(f,Cruta+'/arbolError.txt');
          rewrite(f);
          guardararbol(f,raiz,0);          //transcribe el arbol a un txt
          close(f);
     end;
     readkey;
END.
