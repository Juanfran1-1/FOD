program eje1;
const
    valoraltoloc = 'zzz';
    valoraltocod = 9999;
    dimf = 3;
type 
    rango = 1..dimf;
    regmae = record 
        codloc : integer;
        nomloc : string;
        codcep : integer;
        loccep : string;    
        cantact : integer;
        cantnuev : integer;
        cantrec : integer;
        cantfal : integer;
    end;

    regdet = record
        codloc : integer;
        codcep : integer;   
        cantact : integer;
        cantnuev : integer;
        cantrec : integer;
        cantfal : integer;
    end;    

    maestro = file of regmae;
    detalle = file of regdet;

    vecdet = array [rango] of detalle;
    vecreg = array [rango] of regdet;

procedure importarmaestro(var m:maestro);
var
    r:regmae;
    txt:text;
begin 
    assign(m,'maestro.dat');
    rewrite(m);
    assign(txt,'maestro.txt');
    reset(txt);
    while (not eof(txt)) do begin 
        readln(txt,r.codloc,r.codcep,r.cantact,r.cantnuev,r.cantrec,r.cantfal,r.nomloc);
        readln(txt,r.loccep);
        write(m,r);
    end;
    close(m);
    close(txt);
end;    

procedure importardetalle(var d:detalle; i:integer);
var
    r:regdet;
    txt:text;
begin
    case i of 
        1: begin assign(txt,'detalle1.txt');assign (d,'detalle1.dat'); end;
        2: begin assign(txt,'detalle2.txt');assign (d,'detalle2.dat'); end;
        3: begin assign(txt,'detalle3.txt');assign (d,'detalle3.dat'); end;
    end;
    rewrite(d);
    reset(txt);
    while (not eof(txt)) do begin 
        readln(txt,r.codloc,r.codcep,r.cantact,r.cantnuev,r.cantrec,r.cantfal);
        write(d,r);
    end;
    close(d);
    close(txt);
end;

procedure cargarvector(var v:vecdet);
var 
    i:integer;
begin 
    for i:= 1 to dimf do begin 
        importardetalle(v[i],i);
    end;
end;

procedure leer(var d:detalle;var r:regdet);
begin 
    if (not eof(d)) then 
        read(d,r)
    else 
        r.codloc := valoraltocod;
end;

procedure Merge(var vd:vecdet;var vr:vecreg;var min:regdet);
var 
    i:integer;
    posmin:integer;
begin 
    min.codloc := valoraltocod;
    for i := 1 to dimf do begin 
        if (vr[i].codloc <= min.codloc) then begin
            min := vr[i];
            posmin := i;
        end;
    end;
    if (min.codloc <> valoraltocod) then begin 
        leer(vd[posmin],vr[posmin]);
    end;
end;    

procedure actualizarmaestro(var m:maestro;var vd:vecdet);
var 
    codlocal,codcepa,cantcasosloc,cant,i:integer;
    r:regmae;
    vr:vecreg;
    min:regdet;
begin 
    reset(m);
    for i := 1 to dimf do begin 
        reset(vd[i]);
        leer(vd[i],vr[i]);
    end;
    Merge(vd,vr,min);
    cant:=0;
    while (min.codloc <> valoraltocod) do begin 
        codlocal := min.codloc;
        cantcasosloc := 0;
        while (min.codloc = codlocal) do begin 
            codcepa := min.codcep;
            while (min.codcep = codcepa) and (min.codloc = codlocal) do begin 
                cantcasosloc := cantcasosloc + min.cantact;
                r.cantnuev := r.cantnuev + min.cantnuev;
                r.cantrec := r.cantrec + min.cantrec;
                r.cantfal := r.cantfal + min.cantfal;
                r.cantact := min.cantact;
                Merge(vd,vr,min);
            end;
            while(r.codloc = codlocal) do begin 
                read(m,r);
            end;
            seek(m,FilePos(m)-1);
            write(m,r);
            if (not eof(m)) then begin 
                read(m,r);
            end;
        end;
        if (cantcasosloc > 50) then begin 
            cant:= cant + 1;
        end;
    end;
    writeln('La cantidad de localidades con mas de 50 casos es: ',cant);
    close(m);
    for i := 1 to dimf do begin 
        close(vd[i]);
    end;
end;

procedure imprimirmaestro(var m:maestro);
var 
    r:regmae;
begin
    reset(m);
    while (not eof(m)) do begin 
        read(m,r);
        writeln('Codigo de localidad: ',r.codloc);
        writeln('Nombre de localidad: ',r.nomloc);
        writeln('Codigo de cepa: ',r.codcep);
        writeln('Cepa: ',r.loccep);
        writeln('Cantidad de casos activos: ',r.cantact);
        writeln('Cantidad de casos nuevos: ',r.cantnuev);
        writeln('Cantidad de recuperados: ',r.cantrec);
        writeln('Cantidad de fallecidos: ',r.cantfal);
    end;
    close(m);
end;

var 
    m:maestro;
    vd:vecdet;
begin 
    importarmaestro(m);
    cargarvector(vd);
    actualizarmaestro(m,vd);
    imprimirmaestro(m);
end.