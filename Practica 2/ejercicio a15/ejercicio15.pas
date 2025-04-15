{Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, viviendas sin luz, viviendas sin gas, viviendas de chapa, viviendas sin
agua, viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, viviendas con luz, viviendas
construidas, viviendas con agua, viviendas con gas, entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
● Idem para viviendas sin agua, sin gas y sin sanitarios.
● A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}

program ejercicio15;
const 
    valoralto=9999;
    dimf=3; //10
type 
    regmae = record 
        codprov:integer;
        nomprov:string;
        codloc:integer;
        nomloc:string;
        vivluz:integer;
        vivgas:integer;
        vivchap:integer;
        vivagua:integer;
        vivsani:integer;
    end;

    regdet = record 
        codprov:integer;
        codloc:integer;
        vivluz:integer;
        vivconst:integer;
        vivagua:integer;
        vivgas:integer;
        entrega:integer;
    end;

    maestro= file of regmae;
    detalle = file of regdet;

    vecdet = array[1..dimf] of detalle;
    vecregdet= array [1..dimf] of regdet;

procedure importarmaestro(var mae:maestro);
var 
    r:regmae;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    reset(txt);
    assign(mae,'maestro.dat');
    rewrite(mae);
    while (not eof(txt)) do begin 
        readln(txt,r.codprov,r.nomprov);
        readln(txt,r.codloc,r.nomloc);
        readln(txt,r.vivluz,r.vivgas,r.vivchap,r.vivagua,r.vivsani);
        write(mae,r);
    end;
    close(txt);
    close(mae);
end;

procedure importardetalle(var det:detalle);
var 
    r:regdet;
    txt2:Text;
    rutafis:string;
    rutalog:string;
begin 
    writeln('Ingrese ruta fisica para archivo detalle: ');readln(rutafis);
    writeln('Ingrese ruta logica para archivo detalle: ');readln(rutalog);
    assign(txt2,rutafis);
    reset(txt2);
    assign(det,rutalog);
    rewrite(det);
    while (not eof(txt2)) do begin 
        readln(txt2,r.codprov,r.codloc,r.vivluz,r.vivgas,r.vivconst,r.vivagua,r.entrega);
        write(det,r);
    end;
    close(txt2);
    close(det);
end;

procedure cargarvectordet(var vd:vecdet);
var 
    i:integer;
begin 
    for i:= 1 to dimf do 
        importardetalle(vd[i]);
end;

procedure leer(var det:detalle;var r:regdet);
begin 
    if (not eof(det)) then 
        read(det,r)
    else 
        r.codprov:=valoralto;
end;

procedure Merge(var vd:vecdet;var vr:vecregdet;var min:regdet);
var 
    i,pos:integer;
begin 
    min.codprov:=valoralto;
    for i:= 1 to dimf do begin 
        if(vr[i].codprov < min.codprov) then begin 
            pos:=i;
            min:=vr[i];
        end;
    end;
    if (min.codprov <> valoralto) then 
        leer(vd[pos],vr[pos])
end;

procedure actualizarmaestro(var mae:maestro;var vd:vecdet );
var 
    rm:regmae;
    min:regdet;
    i:integer;
    provact,locact:integer;
    vr:vecregdet;
begin 
    reset(mae);
    read(mae,rm);
    for i:= 1 to dimf do begin 
        reset(vd[i]);
        leer(vd[i],vr[i]);
    end;
    Merge(vd,vr,min);
    while (min.codprov <> valoralto) do begin 
        provact:=min.codprov;
        while (min.codprov = provact) do begin 
            locact:=min.codloc;
            while (min.codprov = provact) and (min.codloc = locact) do begin 
                rm.vivagua := rm.vivagua - min.vivagua;
				rm.vivgas := rm.vivgas - min.vivgas;
				rm.vivsani := rm.vivsani - min.entrega;
				rm.vivchap := rm.vivchap - min.vivconst;
				Merge(vd, vr, min);
            end;
            while (rm.codprov <> provact) do 
                read(mae,rm);
            seek(mae,filepos(mae)-1);
            write(mae,rm);
        end;
    end;
    close(mae); 
    for i:= 1 to dimf do 
        close(vd[i]);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regM : regmae;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Codigo de provincia ', regM.codprov, ' nombre de provincia ', regM.nomprov, ' codigo de localidad '
				, regM.codloc, ' nombre de localidad ', regM.nomloc, ' viviendas sin luz ', regM.vivluz, ' viviendas sin gas ', regM.vivgas,
                ' viviendas de chapa ', regM.vivchap, ' viviendas sin agua ', regM.vivagua, ' viviendas sin sanitarios ', regM.vivsani);
	end;
	close(mae);
end;

var
	vd : vecdet;
	mae : maestro;
begin 
	importarMaestro(mae);
	cargarvectordet(vd);
	//actualizarMaestro(mae, vd);
	//imprimirMaestro(mae);
end.
    
