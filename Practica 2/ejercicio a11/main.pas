{Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado      Total de Hs.        Importe a cobrar
......                  ..........          .........
......                  ..........          .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}

program ejercicio11;
const 
    valoralto=9999;
type
    rango = 1..15;

    empleado = record 
        dep:integer;
        divi:integer;
        num:integer;
        cat : rango;
        canth:integer;
    end;

    datos = record
        cat:rango;
        valor:real;
    end;

    maestro= file of empleado;

    vec = array [rango] of real;


procedure cargarvalores(var v:vec);
var 
    txt:Text;
    d:datos;
begin 
    assign(txt,'valores.txt');
    reset(txt);
    while(not eof(txt)) do begin 
        readln(txt,d.cat,d.valor);
        v[d.cat] := d.valor;
    end;
    close(txt);
end;

procedure importarmaestro(var m:maestro);
var 
    e:empleado;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    assign(m,'maestro.dat');
    reset(txt);
    rewrite(m);
    while (not eof(txt)) do begin 
        readln(txt,e.dep,e.divi,e.num,e.cat,e.canth);
        write(m,e);
    end;
    close(txt);
    close(m);
end;

procedure leer(var m:maestro; var e:empleado);
begin 
    if(not eof(m)) then 
        read(m,e)
    else 
        e.dep := valoralto;
end;

procedure listar(var mae:maestro; v:vec);
var 
    e:empleado;
    depact,divact,empact,totalh,totalhdiv,totalhdep:integer;
    totalm,totalmdiv,totalmdep:real;    
begin
    reset(mae);
    leer(mae,e);
    while (e.dep <> valoralto) do begin 
        depact := e.dep;
        totalhdep := 0;
        totalmdep := 0;
        writeln('Departamento: ',depact);
        while(depact = e.dep) do begin 
            divact := e.divi;
            totalhdiv:=0;
            totalmdiv:=0;
            writeln('Division: ',divact);
            while (depact = e.dep) and (divact = e.divi) do begin 
                empact := e.num;
                totalh := 0;
                totalm := 0;
                while (depact = e.dep) and (divact = e.divi) and (empact = e.num) do begin
                    totalh := totalh + e.canth;
                    totalm :=totalm + (e.canth * v[e.cat]);
                    leer(mae,e);
                end;
                writeln('Empleado: ',empact,'  Total de Hs.: ',totalh,'  Importe a cobrar: ',totalm:0:2, ' categoria: ',e.cat);
                totalhdiv := totalhdiv + totalh;
                totalmdiv := totalmdiv + totalm;
            end;
            writeln('Total de horas division: ',totalhdiv,'  Monto total por division: ',totalmdiv:0:2);
            totalhdep := totalhdep + totalhdiv;
            totalmdep := totalmdep + totalmdiv;
        end;
        writeln('Total horas departamento: ',totalhdep,'  Monto total departamento: ',totalmdep:0:2);
        writeln('--------------------------------------------------');
    end;
    close(mae);
end;

var 
    m:maestro;
    vector:vec;
begin
    cargarvalores(vector);
    importarmaestro(m);
    listar(m,vector);
end.
