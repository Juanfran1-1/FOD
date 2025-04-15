{La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendidos.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo
}
program ejercicio16;
const 
    valoralto= 'ZZZZ';
    dimf = 3; //100
type 
    regmae=record 
        fecha:string;
        cod:integer;
        nom:string;
        des:string;
        prec:real;
        totalact:integer;
        totalven:integer;
    end;

    regdet = record 
        fecha:string;
        cod:integer;
        cant:integer;
    end;

    maestro = file of regmae;
    detalle = file of regdet;

    vecdet = array [1..dimf] of detalle;
    vecregdet = array [1..dimf] of regdet;

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
        readln(txt,r.cod,r.prec,r.totalact,r.totalven,r.fecha);
        readln(txt,r.nom);
        readln(txt,r.des);
        write(mae,r);
    end;
    close(mae);
    close(txt);
end;


procedure importardetalle(var det:detalle;i:integer);
var 
    r:regdet;
    txt2:Text;
begin 
    case i of 
        1: begin Assign(det,'detalle1.dat'); Assign(txt2,'detalle1.txt'); end;
        2: begin Assign(det,'detalle2.dat'); Assign(txt2,'detalle2.txt'); end;
        3: begin Assign(det,'detalle3.dat'); Assign(txt2,'detalle3.txt'); end;
    end;
    reset(txt2);
    rewrite(det);
    while (not eof(txt2)) do begin 
        readln(txt2,r.cod,r.cant,r.fecha);
        write(det,r);
    end;
    close(txt2);
    close(det);
end;

procedure cargarvecdet(var vd:vecdet);
var
    i:integer;
begin   
    for i := 1 to dimf do 
        importardetalle(vd[i],i);
end;

procedure leer(var det:detalle;var r:regdet);
begin 
    if(not eof(det)) then 
        read(det,r)
    else 
        r.fecha:=valoralto;
end;

procedure merge(var vd:vecdet;var vr:vecregdet;var min:regdet);
var 
    pos,i:integer;
begin 
    min.fecha := valoralto;
    for i := 1 to dimf do begin 
        if (vr[i].fecha <= min.fecha) then begin 
                min.fecha:=vr[i].fecha;
                pos:=i;
        end;
    end;
    if (min.fecha <> valoralto) then 
        leer(vd[pos],vr[pos]);
end;

procedure actualizarMaestro(var mae : maestro; var vd : vecdet);
var
	regM : regmae;
	vr : vecregdet;
	min, dato : regdet;
	i : integer;
	fechaMin, fechaMax : string;
	codigoMin, codigoMax, max1, min1, totalVentas : integer;
begin
	max1 := -1;
	min1 := 9999;
	reset(mae);
	read(mae, regM);
	for i := 1 to dimf do begin
		reset(vd[i]);
		leer(vd[i], vr[i]);
	end;
	merge(vd, vr, min);
	while(min.fecha <> valorAlto)do begin
		dato.fecha := min.fecha;
		while(dato.fecha = min.fecha)do begin
			dato.cod := min.cod;
		totalVentas := 0;
			while(dato.fecha = min.fecha) and (dato.cod = min.cod)do begin
				regM.totalven := regM.totalven + min.cant;
				regM.totalact := regM.totalact - min.cant;
				totalVentas := totalVentas + min.cant;
				merge(vd, vr, min);
			end;
			if(totalVentas > max1)then begin
				max1 := totalVentas;
				fechaMax := regM.fecha;
				codigoMax := regM.cod
			end
			else if(totalVentas < min1)then begin
				min1:= totalVentas;
				fechaMin := regM.fecha;
				codigoMin := regM.cod;
			end;
			while(regM.fecha <> dato.fecha)do begin
				read(mae, regM);
			end;
			seek(mae, filepos(mae)-1);
			write(mae, regM);
			if(not eof(mae))then
				read(mae, regM);
		end;
	end;
	close(mae);
	writeln('El semanario con mas ventas es ', fechaMax, ' ', codigoMax);
	writeln('El semanario con menos ventas es ', fechaMin, ' ', codigoMin);
	writeln('Archivo maestro actualizado');
	for i := 1 to dimf do
		close(vd[i]);
end;

procedure imprimirmaestro(var mae: maestro);
var
    r: regmae;
begin
    reset(mae);
    writeln('===IMPRIMIENDO MAESTRO===');
    while not eof(mae) do begin
        read(mae, r);
        writeln('Fecha: ', r.fecha);
        writeln('Codigo: ', r.cod);
        writeln('Nombre: ', r.nom);
        writeln('Descripcion: ', r.des);
        writeln('Precio: ', r.prec:0:2);
        writeln('Total Actual: ', r.totalact);
        writeln('Total Vendido: ', r.totalven);
        writeln('-------------------------');
    end;
    close(mae);
end;

var 
    mae:maestro;
    vd:vecdet;
begin 
    importarmaestro(mae);
    cargarvecdet(vd);
    imprimirmaestro(mae);
    actualizarmaestro(mae,vd);
    imprimirmaestro(mae);
end.


{procedure actualizarmaestro(var mae:maestro;var vd:vecdet);
var 
    vr:vecregdet;
    min,act:regdet;
    rm:regmae;
    i,codmin,codmax,minimo,maximo,total:integer;
    fmin,fmax:string;
begin 
    maximo:=-1;
    minimo:= 9999;
    reset(mae);
    read(mae,rm);
    for i := 1 to dimf do begin 
        reset(vd[i]);
        leer(vd[i],vr[i]);
    end;
    merge(vd,vr,min);
    while (min.fecha <> valoralto)do begin 
        act.fecha:=min.fecha;
        while (act.fecha = min.fecha) do begin 
            total:=0;
            act.cod:=min.cod;
            while (act.fecha = min.fecha) and (act.cod = min.cod) do begin
                total:= total + min.cant;
                merge(vd,vr,min);
            end;
            while ((act.fecha <> rm.fecha) or (act.cod <> rm.cod)) and (not eof(mae)) do 
                read(mae,rm);
            writeln('Leyendo maestro: ', rm.cod, ' ', rm.nom, ' ', rm.fecha);

            if (act.fecha = rm.fecha) and (act.cod = rm.cod) then begin
            if total > maximo then begin
                maximo:=total;
                codmax:=rm.cod;
                fmax:=rm.fecha;
            end;
            if total < minimo then begin
                minimo:=total;
                codmin:=rm.cod;
                fmin:=rm.fecha;
            end;
            end;
            rm.totalact:=rm.totalact - total;
            rm.totalven:=rm.totalven - total;
            seek(mae,filepos(mae)-1);
            write(mae,rm);
            if (not eof(mae)) then 
                read(mae,rm)
        end;
    end;
    close(mae);
    for i := 1 to dimf do 
        close(vd[i]);
    writeln('El semanario con mas ventas es ', fmax, ' ', codmax);
	writeln('El semanario con menos ventas es ', fmin, ' ', codmin);
	writeln('Archivo maestro actualizado');
end;}