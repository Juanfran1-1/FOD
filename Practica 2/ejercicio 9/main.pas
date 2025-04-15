{ Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.
}

program ejercicio9;
const 
    valoralto = 9999;
type
    rangod= 1..31;
    rangom= 1..12;

    cliente = record 
        cod : integer;
        nombre : string;
        apellido : string;
    end;

    regmaestro = record
        cli : cliente;
        ano : integer;
        mes : rangom;
        dia : rangod;
        monto : real;
    end;
    vec= array [rangom] of real;

    imprimir = record 
        cli : cliente;
        total : real;
        mes : vec;
        ano : integer;
    end;


    maestro = file of regmaestro;
    
procedure importarmaestro(var m:maestro);
var 
    r:regmaestro;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    assign(m,'maestro.dat');
    rewrite(m);
    reset(txt);
    while not eof(txt) do begin 
        readln(txt,r.dia,r.mes,r.ano,r.monto,r.cli.cod,r.cli.nombre);
        readln(txt,r.cli.apellido);
        write(m,r);
    end;
    writeln('Archivo maestro importado con exito!');
    close(m);
    close(txt);
end;

procedure leer(var m:maestro; var r:regmaestro);
begin 
    if not eof(m) then 
        read(m,r)
    else 
        r.cli.cod := valoralto;
end;

procedure reiniciar(var v:vec);
var 
    i:integer;
begin
    for i := 1 to 12 do 
        v[i] := 0;
end;


procedure procesarmaestro(var m:maestro);
var 
    r:regmaestro;
    act:imprimir;
    totalano:real;
    pos,i:integer;
    montototal:real;
begin 
    reset(m);
    leer(m,r);
    montototal := 0;
    while(r.cli.cod <> valoralto) do begin 
        act.cli := r.cli;
        reiniciar(act.mes);
        while (act.cli.cod = r.cli.cod)do begin 
            act.ano := r.ano;
            totalano:= 0;  
            while (r.cli.cod = act.cli.cod) and (r.ano = act.ano) do begin 
                pos:=r.mes;
                while (r.cli.cod = act.cli.cod) and (r.ano = act.ano) and (r.mes = pos) do begin 
                    act.mes[pos] := act.mes[pos] + r.monto;
                    totalano := totalano + r.monto;
                    leer(m,r);
                end;
            end;
        end;
        writeln('----------------------------------');
        writeln('Cliente: ', act.cli.cod, ' ', act.cli.nombre, ' ', act.cli.apellido);
        writeln('Total mensual: ');
        for i := 1 to 12 do begin 
            if act.mes[i] <> 0 then 
                writeln('Mes ', i, ': ', act.mes[i]:0:2);
        end;
        writeln('Total anual: ', totalano:0:2);
        writeln('----------------------------------');       
        montototal := montototal + totalano; 
    end;
    writeln('----------------------------------');
    writeln('Monto total de ventas: ', montototal:0:2);
    writeln('----------------------------------');
    close(m);
end;

var 
    m:maestro;
begin
    writeln('===INICIO DEL PROGRAMA===');
    writeln('===IMPORTANDO MAESTRO===');
    importarmaestro(m);
    writeln('===MAESTRO IMPORTADO===');
    writeln('===PROCESANDO MAESTRO===');
    procesarmaestro(m);
    writeln('===PROCESO FINALIZADO===');
end.
