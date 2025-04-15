program eje1;
const 
    valoralto = 9999;
type 
    ingresos = record
        codigo : integer;
        monto : real;
        nombre : string;
    end;

    archivo = file of ingresos;

procedure importar(var arch:archivo);
var 
    ing:ingresos;
    txt:text;
begin 
    assign(arch,'comisiones.dat');
    rewrite(arch);
    writeln('IMPORTANDO...');
    assign(txt,'comisiones.txt');
    reset(txt);
    while (not eof(txt)) do begin
        readln(txt,ing.codigo,ing.monto,ing.nombre);
        write(arch,ing);
    end;
    writeln('IMPORTACION FINALIZADA.');
    close(arch);
    close(txt);
end;

procedure leer(var arch:archivo;var ing : ingresos);
begin 
    if (not eof(arch)) then 
        read(arch,ing)
    else 
        ing.codigo:= valoralto;
end;

procedure asignar(var compacteado:archivo);
var 
    ruta:string;
begin 
    writeln('NOMBRE PARA EL ARCHIVO MAESTRO: ');
    readln(ruta);
    assign(compacteado,ruta);
end;

procedure compactar(var compacteado , arch:archivo);
var 
    ing:ingresos;
    c:integer;
    montotot:real;
begin 
    asignar(compacteado);
    rewrite(compacteado);
    reset(arch);
    leer(arch,ing);
    while (ing.codigo <> valoralto ) do begin 
        c:= ing.codigo;
        montotot:= 0;
        while (ing.codigo <> valoralto) and (c = ing.codigo) do begin 
            montotot:= ing.monto;
            leer(arch,ing);
        end;
        ing.monto:= montotot;
        write(compacteado,ing);
    end;
    close(arch);
    close(compacteado);
end;

procedure informarempleado(e:ingresos);
begin
    writeln('codigo: ' , e.codigo , ' | nombre:' , e.nombre , ' | monto: ' , e.monto:2:2 );
end;

procedure leercompacto(var compacteado:archivo);
var 
    ing : ingresos;
begin 
    writeln('EMPLEADOS: ');
    reset(compacteado);
    while(not eof(compacteado)) do begin 
        read(compacteado,ing);
        informarempleado(ing);
    end;
    close(compacteado);
end;

var 
    arch,compacteado:archivo;
begin 
    importar(arch);
    compactar(compacteado,arch);
    leercompacto(compacteado);
end.




