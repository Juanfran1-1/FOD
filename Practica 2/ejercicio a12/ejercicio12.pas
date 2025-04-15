{La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idUsuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idUsuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idUsuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idUsuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}

program ejercicio12;
const 
    valoralto=9999;
type 

    rangod= 1..31;
    rangom=1..12;

    acceso = record 
        ano : integer;
        mes:rangom;
        dia:rangod;
        id:integer;
        tiempo:real;
    end;

    maestro = file of acceso;

procedure importarmaestro(var mae:maestro);
var 
    a:acceso;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    assign(mae,'maestro.dat');
    reset(txt);
    rewrite(mae);
    while (not eof(txt)) do begin 
        readln(txt,a.ano,a.mes,a.dia,a.id,a.tiempo);
        write(mae,a);
    end;
    close(txt);
    close(mae);
end;

procedure leer(var mae:maestro;var a:acceso);
begin 
    if(not eof(mae)) then 
        read(mae,a)
    else 
        a.ano:=valoralto;
end;

function encontrar(var mae:maestro;ano:integer):boolean;
var 
    ok : boolean;
    a:acceso;
begin 
    ok:=false;
    read(mae,a);
    while (not eof(mae)) and (not ok) do begin
        if (a.ano = ano) then 
            ok:= true
        else 
            read(mae,a);
    end;
    encontrar:=ok;
end;

procedure informe(var mae:maestro);
var 
    ano,mes,dia,id:integer;
    a:acceso;
    ta,tm,td,ti:real;
begin 
    reset(mae);
    writeln('Ingrese el ano a buscar: ');
    readln(ano);
    if (encontrar(mae,ano)) then begin 
        leer(mae,a);
        writeln('--------------------');
        writeln('Año: ',a.ano);
        ano:=a.ano;
        ta:=0;
        while(a.ano = ano) do begin 
            writeln('Mes: ',a.mes);
            mes:=a.mes;
            tm:=0;
            while (a.ano = ano) and (a.mes = mes) do begin 
                writeln('Dia: ',a.dia);
                td:=0;
                dia:=a.dia;
                while(a.ano=ano) and (a.mes = mes) and (a.dia = dia) do begin 
                    ti:=0;
                    id:=a.id;
                    while (a.ano = ano) and (a.mes = mes) and (a.dia = dia) and (a.id = id) do begin 
                        ti := ti + a.tiempo;
                        leer(mae,a);
                    end;
                    writeln('idUsuario: ',id,' Tiempo total de acceso en el dia ',dia,' mes ',mes,' es: ',ti:0:2);
                    td:=td+ti;
                    writeln('--------');
                end;
                writeln('Tiempo total de acceso dia ',dia,' mes ',mes,' es: ',td:0:2);
                tm:=tm+td;
                writeln('-------------');
            end;
            writeln('Tiempo total de acceso mes ',mes,' es: ',tm:0:2);
            ta:=ta+tm;
            writeln('------');
        end;
        writeln('Tiempo total de acceso año ',ano,' es: ',ta:0:2);
        writeln('-------------');
    end
    else 
        writeln('Año no encontrado');
    close(mae);
end;

var 
    mae:maestro;
begin 
    writeln('===INICIO===');
    importarmaestro(mae);
    writeln('===MAESTRO CARGADO===');
    informe(mae);
    writeln('===FIN===');
end.
{Ejemplo de archivo maestro.txt:
2023 1 1 101 2.5
2023 1 1 102 1.0
2023 1 2 101 3.0
2023 1 2 103 4.5
2023 2 1 101 2.0
2023 2 1 102 3.5
2023 2 2 101 1.5
2023 2 2 104 2.0
2024 1 1 105 3.0
2024 1 1 106 2.5}