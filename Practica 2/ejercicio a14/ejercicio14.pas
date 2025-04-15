{Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}

program ejercicio14;
const 
    valoralto = 'ZZZZ';
type 
    vuelos=record 
        destino:string;
        fecha:string;
        hora:integer;
        cantas:integer;
    end;

    maestro=file of vuelos;
    detalle=file of vuelos; 

procedure importarmaestro(var mae:maestro);
var 
    regM:vuelos;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    reset(txt);
    assign(mae,'maestro.dat');
    rewrite(mae);
    while not eof(txt) do begin 
        readln(txt, regM.cantas, regM.destino);
		readln(txt, regM.fecha);
		readln(txt, regM.hora);
		write(mae, regM);
    end;
    close(txt);
    close(mae);
end;

procedure importarDetalle(var d:detalle);
var 
    regD:vuelos;
    txt2:Text;
    rutafis:string;
    rutalog:string;
begin 
    writeln('Ingrese el nombre fisico del archivo de detalle: ');
    readln(rutafis);
    writeln('Ingrese el nombre logico del archivo de detalle: ');
    readln(rutalog);
    assign(txt2,rutafis);
    reset(txt2);
    assign(d,rutalog);
    rewrite(d);
    while not eof(txt2) do begin 
        readln(txt2, regD.cantas, regD.destino);
		readln(txt2, regD.fecha);
		readln(txt2, regD.hora);
        write(d, regD);
    end;
    close(txt2);
    close(d);
end;

procedure leerdetalle(var d:detalle; var r:vuelos);
begin 
    if not eof(d) then 
        read(d,r)
    else 
        r.destino:=valoralto;
end;

procedure Merge(var det1,det2:detalle;var r1,r2,min:vuelos);
begin 
    if (r1.destino < r2.destino) then begin 
        min:=r1;
        leerdetalle(det1,r1);
    end
    else begin 
        min:=r2;
        leerdetalle(det2,r2);
    end;
end;

procedure actualizarmaestro(var m:maestro;var d1,d2:detalle);
var 
    r1,r2,min:vuelos;
    rmaestro:vuelos;
    cant:integer;
begin 
    writeln('Ingrese cantidad de asientos minimo: '); 
    readln(cant);
    reset(m);
    reset(d1);
    reset(d2);
    Merge(d1,d2,r1,r2,min);
    while(min.destino <> valoralto) do begin 
        read(m,rmaestro);
        while (min.destino <> rmaestro.destino) do 
            read(m,rmaestro);
        while(min.destino = rmaestro.destino) do begin 
            while(rmaestro.fecha <> min.fecha) do
                read(m,rmaestro);
            while (rmaestro.destino = min.destino) and (rmaestro.fecha = min.fecha) do begin
                while(rmaestro.hora <> min.hora) do 
                    read(m,rmaestro);
                while (rmaestro.destino = min.destino) and (rmaestro.fecha = min.fecha) and (rmaestro.hora = min.hora) do begin
                    rmaestro.cantas:= rmaestro.cantas - min.cantas;
                    Merge(d1,d2,r1,r2,min);
                end;
                if (rmaestro.cantas < cant) then 
                    writeln('Destino ', rmaestro.destino, ' fecha ', rmaestro.fecha, ' hora de salida ', rmaestro.hora);
                seek(m,filepos(m)-1);
                write(m,rmaestro);
            end;
        end;
    end;
    close(m);
    close(d1);
    close(d2);
end;

procedure imprimirMaestro(var mae : maestro);
var
	regM : vuelos;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Destino ', regM.destino, ' fecha ', regM.fecha, ' hora ', regM.hora, ' asientos disponibles ', regM.cantas);
	end;
	close(mae);
end;

var 
    m:maestro;
    d1,d2:detalle;
begin 
    writeln('===INICIO===');
    importarmaestro(m);
    importarDetalle(d1);
    importarDetalle(d2);
    writeln('===ELEMENTOS IMPORTADOS===');
    actualizarmaestro(m,d1,d2);
    writeln('===MAESTRO ACTUALIZADO===');
    imprimirMaestro(m);
    writeln('===FIN===');
end.