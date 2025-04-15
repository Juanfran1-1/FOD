program ejercicio7;
const 
    valoralto = 9999;
type 
    regmae = record 
        cod:integer;
        apellido:string;
        nombre:string;
        cantcur:integer;
        cantfin:integer;
    end;

    regcur = record 
        codalu:integer;
        codmat:integer;
        ano:integer;
        resultado:integer;
    end;

    regfin = record 
        codalu:integer;
        codmat:integer;
        nota:real;
        fecha:string;
    end;

    maestro = file of regmae;
    detallecur = file of regcur;
    detallefin = file of regfin;

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
        readln(txt,r.cod,r.cantcur,r.cantfin,r.nombre);
        readln(txt,r.apellido);
        write(m,r);
    end;
    close(txt);
    close(m);
end;

procedure imprimirmaestro(var m:maestro);
var 
    r:regmae;
begin 
    reset(m);
    while(not eof(m)) do begin 
        read(m,r);
        writeln('Codigo: ',r.cod,' ','Apellido: ',r.apellido,' ','Nombre: ',r.nombre,' ','Cantidad de cursadas aprobadas: ',r.cantcur,' ','Cantidad de finales: ',r.cantfin);
    end;
    close(m);
end;

procedure importarCursadas(var dc: detallecur);
var
    txt: text;
    r: regcur;
begin
    assign(txt, 'cursadas.txt');
    reset(txt);
    assign(dc, 'cursadas.dat');
    rewrite(dc);
    while not eof(txt) do begin
        readln(txt, r.codalu, r.codmat, r.ano, r.resultado);
        write(dc, r);
    end;
    close(txt);
    close(dc);
end;

procedure importarFinales(var df: detallefin);
var
    txt: text;
    r: regfin;
begin
    assign(txt, 'finales.txt');
    reset(txt);
    assign(df, 'finales.dat');
    rewrite(df);
    while not eof(txt) do begin
        readln(txt, r.codalu, r.codmat, r.nota, r.fecha );
        write(df, r);
    end;
    close(txt);
    close(df);
end;

procedure leercursada(var dc: detallecur; var r:regcur);
begin 
    if(not eof(dc)) then 
        read(dc,r)
    else 
        r.codalu := valoralto;
end;

procedure leerfinal(var df: detallefin; var r:regfin);
begin 
    if(not eof(df)) then 
        read(df,r)
    else 
        r.codalu := valoralto;
end;

procedure actualizarmaestro(var m:maestro; var dc:detallecur; var df:detallefin);
var 
    rcur:regcur;
    rfin:regfin;
    rmae:regmae;
    codalu:integer;
    contcur:integer;
    contfin:integer;
begin 
    reset(m);
    reset(dc);
    reset(df);
    leercursada(dc,rcur);
    leerfinal(df,rfin);
    while(not (eof(m))) do begin 
        read(m,rmae);
        codalu := rmae.cod;
        contcur := 0;
        contfin := 0;
        while (rcur.codalu <> valoralto) and (rcur.codalu = codalu) do begin
            if rcur.resultado = 1 then begin 
                contcur := contcur + 1;
            end; 
            leercursada(dc,rcur);
        end;
        while(rfin.codalu <> valoralto) and (rfin.codalu = codalu) do begin 
            if rfin.nota >= 4 then begin 
                contfin := contfin + 1;
            end;
            leerfinal(df,rfin);
        end;

        rmae.cantcur := contcur;
        rmae.cantfin := contfin;

        seek(m, filepos(m) - 1);
        write(m,rmae);
    end;
    close(m);
    close(dc);
    close(df);
end;


var 
    m:maestro;
    dc:detallecur;
    df:detallefin;
begin 
    writeln('===INICIO===');
    importarmaestro(m);
    writeln('Maestro importado');
    importarCursadas(dc);
    writeln('Cursadas importadas');
    importarFinales(df);
    writeln('Finales importados');
    writeln('Contenido del maestro:');
    imprimirmaestro(m);
    writeln('===ACTUALIZANDO MAESTRO===');
    actualizarmaestro(m,dc,df);
    writeln('Maestro actualizado');
    writeln('Contenido del maestro:');
    imprimirmaestro(m);
    writeln('===FIN===');
end.