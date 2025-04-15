{Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.
Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.
Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.
Nota: cada archivo debe recorrerse una única vez.}

program eje8;
const 
    valoralto = 9999;
    dimf = 3; //16
type 
    rango = 1..dimf;

    regmae = record 
        codprov:integer;
        nombre:string;
        canthab:integer;
        cantyer:integer;
    end;

    regdet = record 
        codprov:integer;
        cantyer:integer;
    end;

    maestro = file of regmae;
    detalle = file of regdet;

    vecdet = array [rango] of detalle;
    vecregdet = array [rango] of regdet;

procedure importarmaestro(var m:maestro);
var 
    r:regmae;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    reset(txt);
    assign(m,'maestro.dat');
    rewrite(m);
    while(not eof(txt)) do begin 
        readln(txt,r.codprov,r.canthab,r.cantyer,r.nombre);
        write(m,r);
    end;
    close(m);
    close(txt);
end;

procedure importarDetalle(var d:detalle;i:integer);
var 
    s:regdet;
    txt:text;
begin
    case i of 
        1: begin Assign(d,'detalle1.dat'); Assign(txt,'detalle1.txt'); end;
        2: begin Assign(d,'detalle2.dat'); Assign(txt,'detalle2.txt'); end;
        3: begin Assign(d,'detalle3.dat'); Assign(txt,'detalle3.txt'); end;
    end;
    reset(txt);
    rewrite(d);
    while (not eof(txt)) do begin 
        readln(txt,s.codprov,s.cantyer);
        write(d,s);
    end;
    close(txt);
    close(d);
end;

procedure cargarvector(var vd : vecdet);
var
	i : rango;
begin
	for i := 1 to dimf do
		importarDetalle(vd[i],i);
end;


procedure imprimirmaestro(var m: maestro);
var
    r: regmae;
    promedio: real;
begin
    reset(m);
    writeln('Provincias con mas de 10.000 kilos consumidos:');
    while not eof(m) do begin
        read(m, r);
        if r.cantyer > 10000 then begin
            promedio := r.cantyer / r.canthab;
            writeln('Provincia: ', r.nombre, ' | Codigo: ', r.codprov, ' | Promedio: ', promedio:0:4, ' kg/hab');
        end;
    end;
    close(m);
end;

procedure leer(var d:detalle; var v:regdet);
begin 
    if (not eof(d)) then 
        read(d,v)
    else 
        v.codprov := valoralto;
end;

procedure merge(var vr: vecregdet; var vd:vecdet; var min: regdet);
var
    i, pos: integer;
begin
    min.codprov := valoralto;
    pos := -1;
    for i := 1 to dimf do begin
        if (vr[i].codprov < min.codprov) then begin
            min := vr[i];
            pos := i;
        end;
    end;
    if (pos <> -1) then
        leer(vd[pos], vr[pos]);
end;


procedure actualizarmaestro(var m: maestro; var d: vecdet);
var
    regm: regmae;
    min: regdet;
    regs: vecregdet;
    act,i,totalYerba: integer;
begin
    reset(m);read(m, regm);
    for i := 1 to dimf do begin
        reset(d[i]);
        leer(d[i], regs[i]);
    end;
    merge(regs, d, min);
    while min.codprov <> valoralto do begin
        act:= min.codprov;
        totalYerba := 0;
        while act = min.codprov do begin
            totalYerba := totalYerba + min.cantyer;
            merge(regs, d, min);
        end;
        regm.cantyer := regm.cantyer + totalYerba;
        seek(m, filepos(m) - 1);
        write(m, regm);
        if not eof(m) then
            read(m, regm);
    end;
    for i := 1 to dimf do
        close(d[i]);
    close(m);
end;

var 
    m:maestro;
    d:vecdet;
begin 
    importarmaestro(m);
    cargarvector(d);
    imprimirmaestro(m);
    actualizarmaestro(m, d);
    imprimirmaestro(m);
end.
