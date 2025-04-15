{Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.
}
program ejercicio17;
const 
    valoralto = 9999;
    dimf = 3;//10
type

    regmae = record 
        cod:integer;
        nom:string;
        des:string;
        modelo:string;
        marca:string;
        stock:integer;
    end;

    regdet = record 
        cod:integer;
        precio:real;
        fecha:string;
    end;

    maestro = file of regmae;
    detalle = file of regdet;

    vecdet = array [1..dimf] of detalle;
    vecreg = array [1..dimf] of regdet;

procedure importarmaestro(var mae:maestro);
var 
    r:regmae;
    txt:Text;
begin 
    assign(txt,'maestro.txt');
    assign(mae,'maestro.dat');
    reset(txt);
    rewrite(mae);
    while (not eof(txt)) do begin 
        readln(txt,r.cod,r.stock,r.nom);
        readln(txt,r.des);
        readln(txt,r.modelo);
        readln(txt,r.marca);
        write(mae,r);
    end;
    close(txt);
    close(mae);
end;

procedure importardetalle(var det:detalle;i:integer);
var 
    r:regdet;
    txt2:Text;
begin 
    case i of 
        1: begin assign(txt2,'detalle1.txt');assign(det,'detalle1.dat');end;
        2: begin assign(txt2,'detalle2.txt');assign(det,'detalle2.dat');end;
        3: begin assign(txt2,'detalle3.txt');assign(det,'detalle3.dat');end;
    end;
    reset(txt2);
    rewrite(det);
    while (not eof(txt2)) do begin 
        readln(txt2,r.cod,r.precio,r.fecha);
        write(det,r);
    end;
    close(txt2);
    close(det);
end;

procedure cargarvec(var vd:vecdet);
var 
    i:integer;
begin 
    for i := 1 to dimf do 
        importardetalle(vd[i],i);
end;

procedure leer(var det:detalle;var r:regdet);
begin 
    if (not eof(det)) then 
        read(det,r)
    else 
        r.cod :=  valoralto;
end;

procedure merge(var vd:vecdet;var vr:vecreg;var min:regdet);
var 
    i,pos:integer;
begin 
    min.cod:= valoralto;
    for i := 1 to dimf do begin 
        if (vr[i].cod <= min.cod) then begin
            min:= vr[i];
            pos:=i;
        end;
    end;
    if (min.cod <> valoralto) then 
        leer(vd[pos],vr[pos]);
end;

procedure actualizarmaestro (var mae:maestro;var vd:vecdet);
var 
    i:integer;
    rm:regmae;
    vr:vecreg;
    venta:integer;
    max:integer;
    codmax:integer;
    act:integer;
    min:regdet;
begin 
    max:=-1;
    reset(mae);
    read(mae,rm);
    for i := 1 to dimf do begin 
        reset(vd[i]);
        leer(vd[i],vr[i]);
    end;
    merge(vd,vr,min);
    while (min.cod <> valoralto) do begin 
        venta:= 0;
        act:= min.cod;
        while (act = min.cod) do begin 
            venta := venta + 1;
            merge(vd,vr,min);
        end;
        if (venta > max) then begin 
            max:=venta;
            codmax:=act;
        end;

        while (rm.cod < act) do  
            read(mae,rm);
        
        rm.stock:= rm.stock - venta;
        seek(mae,filepos(mae)-1);
        write(mae,rm);
        if (not eof(mae)) then 
            read(mae,rm);
    end;
    close(mae);
    for i := 1 to dimf do
        close(vd[i]);
    writeln('La moto mas vendida fue ',codmax);
end;

procedure imprimirmaestro(var mae : maestro);
var
	regM : regmae;
begin
	reset(mae);
	while(not eof(mae))do begin
		read(mae, regM);
		writeln('Codigo ', regM.cod, ' nombre ', regM.nom, ' descripcion ', regM.des, ' modelo ', regM.modelo, ' marca ', regM.marca, ' stock actual ', regM.stock);
	end;
	close(mae);
end;

var
	vd : vecdet;
	mae : maestro;
BEGIN
	importarMaestro(mae);
	cargarvec(vd);
    imprimirMaestro(mae);
    writeln('-------------');
	actualizarmaestro(mae, vd);
    writeln('-------------');
	imprimirMaestro(mae);
    writeln('-------------');
end.

