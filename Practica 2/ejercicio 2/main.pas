program ejercicio2;
const 
    valoralto=9999;
type
    producto=record
        codigo:integer;
        nombre:string[50];
        precio:real;
        stocka:integer;
        stockm:integer;
        
    end;

    venta = record 
        codigo:integer;
        cantidad:integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure leerdetalle(var archdet:detalle; var v:venta);
begin
    if not eof(archdet) then
        read(archdet,v)
    else
        v.codigo:=valoralto;
end;

procedure leermaestro(var archma:maestro; var p:producto);
begin
    if not eof(archma) then
        read(archma,p)
    else
        p.codigo:=valoralto;
end;

procedure importarmaestro(var archm:maestro);
var 
    regm:producto;
    txt:text;
begin 
    assign(txt,'maestro.txt');reset(txt);
    assign(archm,'maestro.dat');rewrite(archm);
    while not eof(txt) do begin
    read(txt, regm.codigo);
    read(txt, regm.precio);
    read(txt, regm.stocka); 
    read(txt, regm.stockm);
    readln(txt, regm.nombre);
    write(archm, regm);
    end;
    close(txt);
    close(archm);
end;

procedure importardetalle(var archd:detalle);
var 
    regd:venta;
    txt:text;
begin
    assign(txt,'detalle.txt');
    assign(archd,'detalle.dat');
    rewrite(archd);
    reset(txt);
    while not eof(txt) do begin 
        readln(txt,regd.codigo,regd.cantidad);
        write(archd,regd);
    end;
    close(txt);
    close(archd);
end;



procedure actualizarmaestro(var archma:maestro; var archdet:detalle);
var 
    p:producto;
    v:venta;
    cantventas:integer;
    act:integer;

begin 
    reset(archma);
    reset(archdet);
    read(archma,p);
    leerdetalle(archdet,v);
    while (v.codigo <> valoralto) do begin 
        cantventas:=0;
        act:=v.codigo;
        while (act = v.codigo) do begin 
            cantventas:=cantventas + v.cantidad;
            leerdetalle(archdet,v);
        end;
        while (p.codigo <> act) do
            read (archma, p);
        p.stocka:=p.stocka - cantventas;
        seek(archma,filepos(archma)-1);
        write(archma,p);
        if (not(EOF(archma))) then
            read(archma, p);
    end;
    close(archma);
    close(archdet);
end;

procedure imprimirmaestro(var archma:maestro);
var 
    p:producto;
begin 
    reset(archma);
    while not eof(archma) do begin 
        read(archma,p);
        writeln('Codigo: ',p.codigo,' Nombre: ',p.nombre,' Stock Actual: ',p.stocka,' Stock Minimo: ',p.stockm,' Precio: ',p.precio:2:2);
    end;
    close(archma);
end;

procedure exportartxt(var archm:maestro);
var 
    p:producto;
    txt:text;
begin 
    Assign(txt,'stock_minimo.txt');
    rewrite(txt);
    reset(archm);
    while (not eof(archm)) do begin 
        read(archm,p);
        if (p.stockm > p.stocka) then 
            writeln(txt, p.codigo, ' ', p.nombre, ' ', p.stocka, ' ', p.stockm, ' ', p.precio:2:2);
    end;
    close(txt);
    close(archm);
end;

var 
    archma:maestro;
    archdet:detalle;
begin
    importarmaestro(archma);
    writeln('Maestro importado');
    importardetalle(archdet);
    writeln('Detalle importado');
    actualizarmaestro(archma,archdet);
    writeln('Maestro actualizado');
    imprimirmaestro(archma);
    writeln('Maestro impreso');
    exportartxt(archma);
    writeln('Archivo exportado');
    writeln('Fin del programa');
end.