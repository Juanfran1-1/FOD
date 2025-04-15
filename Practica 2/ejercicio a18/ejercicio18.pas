{Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.
NOTA: El archivo debe recorrerse solo una vez.}
program ejercicio18;
const 
    valoralto = 'ZZZZ';
type 
    regmae = record 
        codloc:integer;
        nomloc:string;
        codmuni:integer;
        nommuni:string;
        codhos:integer;
        nomhos:string;
        fecha:string;
        cantcasos:integer;
    end;

    dato = record 
        nomloc:string;
        nommuni:string;
        cant:integer;
    end;
    
    maestro = file of regmae;

procedure importarmaestro(var mae:maestro);
var 
    txt:Text;
    r:regmae;
begin 
    assign(txt,'maestro.txt');
    assign(mae,'maestro.dat');
    reset(txt);
    rewrite(mae);
    while (not eof(txt)) do begin 
        readln(txt, r.codloc, r.nomloc);
        readln(txt, r.codmuni, r.nommuni);
        readln(txt, r.codhos, r.nomhos);
        readln(txt, r.cantcasos, r.fecha); 
        write(mae, r);
    end;
    close(txt);
    close(mae);
end;

procedure leer(var mae:maestro;var r:regmae);
begin 
    if (not eof(mae)) then 
        read(mae,r)
    else 
        r.nomloc := valoralto;
end;

procedure importaratxt(var txt:text;d:dato);
begin 
    writeln(txt,d.nomloc);
    writeln(txt,d.cant,' ',d.nommuni);
end;

procedure procesarmaestro(var mae:maestro);
var 
    casoshosp,casosloc,casosmuni,casosprov:integer;
    rm:regmae;
    locact,muniact,hospact:string;
    txt:Text;
    d:dato;
begin 
    reset(mae);
    leer(mae,rm);
    assign(txt,'1500casos.txt');
    rewrite(txt);
    casosprov:=0;
    writeln('-----------------------------');
    while (rm.nomloc <> valoralto) do begin 
        locact:=rm.nomloc;
        casosloc:=0;
        writeln('Localidad: ',rm.nomloc);
        while (locact = rm.nomloc) do begin 
            muniact:=rm.nommuni;
            writeln('Municipio: ',rm.nommuni);
            casosmuni:=0;
            while (locact = rm.nomloc) and (muniact = rm.nommuni) do begin 
                casoshosp:= 0;
                writeln('Hospital: ',rm.nomhos);
                hospact:= rm.nomhos;
                while (locact = rm.nomloc) and (muniact = rm.nommuni) and (hospact = rm.nomhos) do begin
                    casoshosp:= casoshosp + rm.cantcasos;
                    leer(mae,rm);
                end;
                writeln('Cantidad casos hospital ',casoshosp);
                casosmuni:=casosmuni + casoshosp;
            end;
            writeln('Cantidad casos municipio: ',casosmuni);
            casosloc:=casosloc + casosmuni;
            if (casosmuni > 1500 ) then begin 
                d.nomloc:=locact;
                d.nommuni:=muniact;
                d.cant:=casosmuni;
                importaratxt(txt,d);
            end;
        end;
        casosprov:=casosprov + casosloc;
        writeln('Cantidad casos localidad ',casosloc );
        writeln('-----------------------------');
    end;
    writeln('Cantidad de casos provincia ',casosprov);
    close(txt);
    close(mae);
end;
var
    mae:maestro;
begin 
    importarmaestro(mae);
    procesarmaestro(mae);
end.
