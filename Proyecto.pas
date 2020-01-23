program Proyecto;

uses crt, UTipos, UInterprete, UAnSintactico, UArchivo, UArbol;

Const
     Cruta='C:\Users\Rodrigo Romero\Desktop\Compu vieja\Facultad\Sintaxis y Semantica de los lenguajes\SyS\';
     Version='1.0';
     GithubURL='https://github.com/RodrigoRomero2308/SyS';

var
   archivo:TArchivo;
   tabla: TS;
   Raiz: Tarbol;
   f:text;
   errorStatus:boolean;

BEGIN
     // To change debug mode go to UTipos and change it in const sector
     errorStatus:=false;
     abreFile(archivo,Cruta+'archivo.txt');
     writeln('--------------------------------------------');
     writeln('Archivo abierto');
     analisis(archivo,tabla, Raiz, errorStatus);   //carga todo el arbol
     if not errorStatus then
     begin
          writeln('--------------------------------------------');
          writeln('Analisis finalizado');
          assign(f,Cruta+'arbol.txt');
          rewrite(f);
          guardararbol(f,raiz,0);          //transcribe el arbol a un txt
          close(f);
          evalPrograma(Raiz, tabla, errorStatus);
          if not errorStatus then 
          begin
               writeln('--------------------------------------------');
               writeln('Programa finalizado con EXITO. Version: ' + Version);
               writeln('Visita nuestro codigo en github: ' + GithubURL);
          end
          else
          begin
               writeln('--------------------------------------------');
               writeln('Programa finalizado con ERRORES. Version: ' + Version);
               writeln('Visita nuestro codigo en github: ' + GithubURL);
          end;
     end
     else
     begin
          writeln('--------------------------------------------');
          writeln('Analisis finalizado con ERRORES');
          assign(f,Cruta+'arbolError.txt');
          rewrite(f);
          guardararbol(f,raiz,0);          //transcribe el arbol a un txt
          close(f);
     end;
     //readkey;
END.
