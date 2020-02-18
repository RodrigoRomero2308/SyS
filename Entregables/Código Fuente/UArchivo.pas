Unit UArchivo;

Interface

Type
    TArchivo= File of char;

Procedure AbreFile(var F:TArchivo; FName:String);
Procedure CierraFile(var F:TArchivo);
Procedure LeeReg(var F:TArchivo; Pos:cardinal; var car:char);

Implementation

Procedure AbreFile(var F:TArchivo; FName:String);
begin
     Assign(F,FName);
     Reset(F);
end;

Procedure CierraFile(var F:TArchivo);
begin
     Close(F);
end;

Procedure LeeReg(var F:TArchivo; Pos:Cardinal; var car:char);
begin
     Seek(F,Pos);
     Read(F, car);
end;


BEGIN

END.
