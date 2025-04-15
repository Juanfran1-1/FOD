{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia
Código de Localidad               Total de Votos
...........................       ......................
...........................       ......................
Total de Votos Provincia: ____

Código de Provincia
Código de Localidad                Total de Votos
...........................        .....................
Total de Votos Provincia: ___
........................................................
Total General de Votos: ___
........................................................

NOTA: La información está ordenada por código de provincia y código de localidad.}

program ejercicio10;
const 
    valoralto= 9999;
type 
    regmae = record 
        codp:integer;
        codl:integer;
        nmesa:integer;
        cantv:integer;
    end;

    maestro = file of regmae;

procedure importarmaestro(var m:maestro);
var 
    r:regmae;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    reset(txt);
    assign(m,'maestro.dat');
    rewrite(m);
    while not eof(txt) do begin 
        readln(txt,r.codp,r.codl,r.nmesa,r.cantv);
        write(m,r);
    end;
    close(m);
    close(txt);
end;

procedure leer(var m:maestro; var r:regmae);
begin 
    if not eof(m) then 
        read(m,r)
    else 
        r.codp:= valoralto;
end;

procedure contabilizar(var m:maestro);
var 
    r:regmae;
    codp,codl,totp,totl,tot:integer;
begin
    reset(m);
    leer(m,r);
    tot:= 0;
    writeln('----------------------------------');
    while(r.codp <> valoralto) do begin 
        codp:= r.codp;
        writeln('Codigo de provincia: ',codp);
        totp:= 0;
        writeln('Codigo de localidad               Total de Votos');
        while (r.codp = codp) do begin 
            codl:= r.codl;
            totl:= 0;
            while (r.codl = codl) and (r.codp = codp) do begin
                totl:= totl + r.cantv;
                leer(m,r);
            end;
            writeln(codl,totl:35);
            totp:= totp + totl;
        end;
        writeln();
        writeln('Total de votos provincia: ',totp);
        writeln('----------------------------------');
        tot:= tot + totp;
    end;
    writeln('Total general de votos: ',tot);
    close(m);
end;

var 
    m:maestro;
begin
    importarmaestro(m);
    contabilizar(m);
end.

