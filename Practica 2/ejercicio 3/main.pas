program ejercicio3;
const 
    valoralto='zzzzz';
type 
    regMaestro = record 
        provincia:string;
        alfabetizados:integer;
        encuestados:integer;
    end;

    regDetalle = record 
        provincia:string;
        codigo:integer;
        alfabetizados:integer;
        encuestados:integer;
    end;    

    maestro = file of regMaestro;
    detalle = file of regDetalle;

procedure leerdetalle(var d:detalle; var r:regDetalle);
begin 
    if (not eof(d)) then 
        read(d,r)
    else 
        r.provincia:=valoralto;    
end;

procedure Merge(var det1,det2:detalle;var r1,r2,min:regDetalle);
begin 
    if (r1.provincia <= r2.provincia) then begin 
        min:=r1;
        leerdetalle(det1,r1);
    end
    else begin 
        min:=r2;
        leerdetalle(det2,r2);
    end;    
end;


procedure importarmaestro(var mae:maestro);
var 
    r:regMaestro;
    txt:text;
begin 
    assign(mae,'maestro.dat');
    rewrite(mae);
    assign(txt,'maestro.txt');
    reset(txt);
    while(not eof(txt)) do begin 
        readln(txt,r.alfabetizados,r.encuestados,r.provincia);
        write(mae,r);
    end;
    close(mae);
    close(txt);
end;

procedure importardetalle(var det1,det2:detalle);
var 
    d:regDetalle;
    txt,txt2:text;
begin 
    assign(det1,'detalle1.dat');
    rewrite(det1);
    assign(txt,'detalle1.txt');
    reset(txt);
    while(not eof(txt)) do begin 
        readln(txt,d.codigo,d.alfabetizados,d.encuestados,d.provincia);
        write(det1,d);
    end;
    close(det1);
    close(txt);


    assign(det2,'detalle2.dat');
    rewrite(det2);
    assign(txt2,'detalle2.txt');
    reset(txt2);
    while(not eof(txt2)) do begin 
        readln(txt2,d.codigo,d.alfabetizados,d.encuestados,d.provincia);
        write(det2,d);
    end;
    close(det2);
    close(txt2);
end;

procedure actualizarmaestro(var m:maestro; var det1,det2:detalle);
var 
    r1,r2,min:regDetalle;
    rm:regMaestro;
begin 
    reset(m);
    reset(det1);
    reset(det2);
    leerdetalle(det1,r1);
    leerdetalle(det2,r2);
    Merge(det1,det2,r1,r2,min);
    while (min.provincia <> valoralto) do begin 
        read(m,rm);
        while (rm.provincia <> min.provincia) do 
            read(m,rm);
        while (rm.provincia = min.provincia) do begin 
            rm.alfabetizados:=rm.alfabetizados + min.alfabetizados;
            rm.encuestados:=rm.encuestados + min.encuestados;
            Merge(det1,det2,r1,r2,min);
        end;
        seek(m,filepos(m)-1);
        write(m,rm);
    end;
    close(m);
    close(det1);
    close(det2);
end;

procedure imprimirmaestro(var m:maestro);
var 
    r:regMaestro;
begin 
    reset(m);
    while(not eof(m)) do begin 
        read(m,r);
        writeln('Provincia: ',r.provincia,' Alfab: ',r.alfabetizados,' Encuestados: ',r.encuestados);
    end;
    close(m);
end;

var 
    m:maestro;
    d1,d2:detalle;
begin 
    writeln('=== INICIO DEL PROGRAMA ===');
    importarmaestro(m);
    writeln('Importando detalles al maestro...');
    writeln('Importando detalle 1 y 2...');
    importardetalle(d1,d2);
    writeln('Detalles importados. Actualizando maestro...');
    actualizarmaestro(m,d1,d2);
    writeln('Maestro actualizado. Imprimiendo maestro...');
    imprimirmaestro(m);
    writeln('Fin del programa.');
end.
